
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
    80000060:	46478793          	addi	a5,a5,1124 # 800064c0 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffaa7ff>
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
    8000012a:	b14080e7          	jalr	-1260(ra) # 80002c3a <either_copyin>
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
    800001ce:	f40080e7          	jalr	-192(ra) # 8000210a <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	7b0080e7          	jalr	1968(ra) # 8000298a <sleep>
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
    8000021a:	9ce080e7          	jalr	-1586(ra) # 80002be4 <either_copyout>
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
    800002fa:	99a080e7          	jalr	-1638(ra) # 80002c90 <procdump>
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
    8000044e:	6c0080e7          	jalr	1728(ra) # 80002b0a <wakeup>
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
    8000047c:	00050797          	auipc	a5,0x50
    80000480:	94478793          	addi	a5,a5,-1724 # 8004fdc0 <devsw>
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
    8000091e:	1f0080e7          	jalr	496(ra) # 80002b0a <wakeup>
    
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
    800009b8:	fd6080e7          	jalr	-42(ra) # 8000298a <sleep>
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
    80000a9e:	00053797          	auipc	a5,0x53
    80000aa2:	56278793          	addi	a5,a5,1378 # 80054000 <end>
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
    80000be4:	00053517          	auipc	a0,0x53
    80000be8:	41c50513          	addi	a0,a0,1052 # 80054000 <end>
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
    80000cd8:	41a080e7          	jalr	1050(ra) # 800020ee <mycpu>
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
    80000d0a:	3e8080e7          	jalr	1000(ra) # 800020ee <mycpu>
    80000d0e:	5d3c                	lw	a5,120(a0)
    80000d10:	cf89                	beqz	a5,80000d2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d12:	00001097          	auipc	ra,0x1
    80000d16:	3dc080e7          	jalr	988(ra) # 800020ee <mycpu>
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
    80000d2e:	3c4080e7          	jalr	964(ra) # 800020ee <mycpu>
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
    80000d6e:	384080e7          	jalr	900(ra) # 800020ee <mycpu>
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
    80000d9a:	358080e7          	jalr	856(ra) # 800020ee <mycpu>
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
    80000ff0:	0f2080e7          	jalr	242(ra) # 800020de <cpuid>
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
    8000100c:	0d6080e7          	jalr	214(ra) # 800020de <cpuid>
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
    8000102e:	da6080e7          	jalr	-602(ra) # 80002dd0 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001032:	00005097          	auipc	ra,0x5
    80001036:	4ce080e7          	jalr	1230(ra) # 80006500 <plicinithart>
  }

  scheduler();
    8000103a:	00001097          	auipc	ra,0x1
    8000103e:	638080e7          	jalr	1592(ra) # 80002672 <scheduler>
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
    8000109e:	f74080e7          	jalr	-140(ra) # 8000200e <procinit>
    trapinit();         // trap vectors
    800010a2:	00002097          	auipc	ra,0x2
    800010a6:	d06080e7          	jalr	-762(ra) # 80002da8 <trapinit>
    trapinithart();     // install kernel trap vector
    800010aa:	00002097          	auipc	ra,0x2
    800010ae:	d26080e7          	jalr	-730(ra) # 80002dd0 <trapinithart>
    plicinit();         // set up interrupt controller
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	438080e7          	jalr	1080(ra) # 800064ea <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	446080e7          	jalr	1094(ra) # 80006500 <plicinithart>
    binit();            // buffer cache
    800010c2:	00002097          	auipc	ra,0x2
    800010c6:	5ee080e7          	jalr	1518(ra) # 800036b0 <binit>
    iinit();            // inode cache
    800010ca:	00003097          	auipc	ra,0x3
    800010ce:	c7e080e7          	jalr	-898(ra) # 80003d48 <iinit>
    fileinit();         // file table
    800010d2:	00004097          	auipc	ra,0x4
    800010d6:	c1c080e7          	jalr	-996(ra) # 80004cee <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010da:	00005097          	auipc	ra,0x5
    800010de:	52e080e7          	jalr	1326(ra) # 80006608 <virtio_disk_init>
    userinit();         // first user process
    800010e2:	00001097          	auipc	ra,0x1
    800010e6:	326080e7          	jalr	806(ra) # 80002408 <userinit>
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
    80001644:	a021                	j	8000164c <freewalk+0x22>
  for (int i = 0; i < 512; i++) {
    80001646:	04a1                	addi	s1,s1,8
    80001648:	03248063          	beq	s1,s2,80001668 <freewalk+0x3e>
    pte_t pte = pagetable[i];
    8000164c:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000164e:	00f57793          	andi	a5,a0,15
    80001652:	ff379ae3          	bne	a5,s3,80001646 <freewalk+0x1c>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001656:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001658:	0532                	slli	a0,a0,0xc
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	fd0080e7          	jalr	-48(ra) # 8000162a <freewalk>
      pagetable[i] = 0;
    80001662:	0004b023          	sd	zero,0(s1)
    80001666:	b7c5                	j	80001646 <freewalk+0x1c>
    } else if (pte & PTE_V) {
      // printf("freewalk: leaf");
    }
  }
  kfree((void *)pagetable);
    80001668:	8552                	mv	a0,s4
    8000166a:	fffff097          	auipc	ra,0xfffff
    8000166e:	420080e7          	jalr	1056(ra) # 80000a8a <kfree>
}
    80001672:	70a2                	ld	ra,40(sp)
    80001674:	7402                	ld	s0,32(sp)
    80001676:	64e2                	ld	s1,24(sp)
    80001678:	6942                	ld	s2,16(sp)
    8000167a:	69a2                	ld	s3,8(sp)
    8000167c:	6a02                	ld	s4,0(sp)
    8000167e:	6145                	addi	sp,sp,48
    80001680:	8082                	ret

0000000080001682 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80001682:	1101                	addi	sp,sp,-32
    80001684:	ec06                	sd	ra,24(sp)
    80001686:	e822                	sd	s0,16(sp)
    80001688:	e426                	sd	s1,8(sp)
    8000168a:	1000                	addi	s0,sp,32
    8000168c:	84aa                	mv	s1,a0
  if (sz > 0)
    8000168e:	e999                	bnez	a1,800016a4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80001690:	8526                	mv	a0,s1
    80001692:	00000097          	auipc	ra,0x0
    80001696:	f98080e7          	jalr	-104(ra) # 8000162a <freewalk>
}
    8000169a:	60e2                	ld	ra,24(sp)
    8000169c:	6442                	ld	s0,16(sp)
    8000169e:	64a2                	ld	s1,8(sp)
    800016a0:	6105                	addi	sp,sp,32
    800016a2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800016a4:	6605                	lui	a2,0x1
    800016a6:	167d                	addi	a2,a2,-1
    800016a8:	962e                	add	a2,a2,a1
    800016aa:	4685                	li	a3,1
    800016ac:	8231                	srli	a2,a2,0xc
    800016ae:	4581                	li	a1,0
    800016b0:	00000097          	auipc	ra,0x0
    800016b4:	d42080e7          	jalr	-702(ra) # 800013f2 <uvmunmap>
    800016b8:	bfe1                	j	80001690 <uvmfree+0xe>

00000000800016ba <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 i, pa;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE) {
    800016ba:	ce55                	beqz	a2,80001776 <uvmcopy+0xbc>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    800016bc:	711d                	addi	sp,sp,-96
    800016be:	ec86                	sd	ra,88(sp)
    800016c0:	e8a2                	sd	s0,80(sp)
    800016c2:	e4a6                	sd	s1,72(sp)
    800016c4:	e0ca                	sd	s2,64(sp)
    800016c6:	fc4e                	sd	s3,56(sp)
    800016c8:	f852                	sd	s4,48(sp)
    800016ca:	f456                	sd	s5,40(sp)
    800016cc:	f05a                	sd	s6,32(sp)
    800016ce:	ec5e                	sd	s7,24(sp)
    800016d0:	e862                	sd	s8,16(sp)
    800016d2:	e466                	sd	s9,8(sp)
    800016d4:	1080                	addi	s0,sp,96
    800016d6:	89aa                	mv	s3,a0
    800016d8:	8aae                	mv	s5,a1
    800016da:	8932                	mv	s2,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800016dc:	4481                	li	s1,0
      goto err;
    }
    *pte &= ~PTE_W;
    *pte |= PTE_COW;
    *new_pte = *pte;
    page_ref_count[REF_IDX(pa)] += 1;
    800016de:	80000bb7          	lui	s7,0x80000
    800016e2:	00010b17          	auipc	s6,0x10
    800016e6:	27eb0b13          	addi	s6,s6,638 # 80011960 <page_ref_count>
  for (i = 0; i < sz; i += PGSIZE) {
    800016ea:	6a05                	lui	s4,0x1
    800016ec:	a839                	j	8000170a <uvmcopy+0x50>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016ee:	4685                	li	a3,1
    800016f0:	00c4d613          	srli	a2,s1,0xc
    800016f4:	4581                	li	a1,0
    800016f6:	8556                	mv	a0,s5
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	cfa080e7          	jalr	-774(ra) # 800013f2 <uvmunmap>
  return -1;
    80001700:	557d                	li	a0,-1
    80001702:	a8a9                	j	8000175c <uvmcopy+0xa2>
  for (i = 0; i < sz; i += PGSIZE) {
    80001704:	94d2                	add	s1,s1,s4
    80001706:	0524fa63          	bgeu	s1,s2,8000175a <uvmcopy+0xa0>
    if ((pte = walk(old, i, 0)) == 0)
    8000170a:	4601                	li	a2,0
    8000170c:	85a6                	mv	a1,s1
    8000170e:	854e                	mv	a0,s3
    80001710:	00000097          	auipc	ra,0x0
    80001714:	a0e080e7          	jalr	-1522(ra) # 8000111e <walk>
    80001718:	8caa                	mv	s9,a0
    8000171a:	d56d                	beqz	a0,80001704 <uvmcopy+0x4a>
    if ((*pte & PTE_V) == 0)
    8000171c:	611c                	ld	a5,0(a0)
    8000171e:	0017f713          	andi	a4,a5,1
    80001722:	d36d                	beqz	a4,80001704 <uvmcopy+0x4a>
    pa = PTE2PA(*pte);
    80001724:	83a9                	srli	a5,a5,0xa
    80001726:	00c79c13          	slli	s8,a5,0xc
    pte_t *new_pte = walk(new, i, 1);
    8000172a:	4605                	li	a2,1
    8000172c:	85a6                	mv	a1,s1
    8000172e:	8556                	mv	a0,s5
    80001730:	00000097          	auipc	ra,0x0
    80001734:	9ee080e7          	jalr	-1554(ra) # 8000111e <walk>
    if (new_pte == 0) {
    80001738:	d95d                	beqz	a0,800016ee <uvmcopy+0x34>
    *pte &= ~PTE_W;
    8000173a:	000cb783          	ld	a5,0(s9)
    8000173e:	9bed                	andi	a5,a5,-5
    *pte |= PTE_COW;
    80001740:	1007e793          	ori	a5,a5,256
    80001744:	00fcb023          	sd	a5,0(s9)
    *new_pte = *pte;
    80001748:	e11c                	sd	a5,0(a0)
    page_ref_count[REF_IDX(pa)] += 1;
    8000174a:	017c07b3          	add	a5,s8,s7
    8000174e:	83a9                	srli	a5,a5,0xa
    80001750:	97da                	add	a5,a5,s6
    80001752:	4398                	lw	a4,0(a5)
    80001754:	2705                	addiw	a4,a4,1
    80001756:	c398                	sw	a4,0(a5)
    80001758:	b775                	j	80001704 <uvmcopy+0x4a>
  return 0;
    8000175a:	4501                	li	a0,0
}
    8000175c:	60e6                	ld	ra,88(sp)
    8000175e:	6446                	ld	s0,80(sp)
    80001760:	64a6                	ld	s1,72(sp)
    80001762:	6906                	ld	s2,64(sp)
    80001764:	79e2                	ld	s3,56(sp)
    80001766:	7a42                	ld	s4,48(sp)
    80001768:	7aa2                	ld	s5,40(sp)
    8000176a:	7b02                	ld	s6,32(sp)
    8000176c:	6be2                	ld	s7,24(sp)
    8000176e:	6c42                	ld	s8,16(sp)
    80001770:	6ca2                	ld	s9,8(sp)
    80001772:	6125                	addi	sp,sp,96
    80001774:	8082                	ret
  return 0;
    80001776:	4501                	li	a0,0
}
    80001778:	8082                	ret

000000008000177a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    8000177a:	1141                	addi	sp,sp,-16
    8000177c:	e406                	sd	ra,8(sp)
    8000177e:	e022                	sd	s0,0(sp)
    80001780:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001782:	4601                	li	a2,0
    80001784:	00000097          	auipc	ra,0x0
    80001788:	99a080e7          	jalr	-1638(ra) # 8000111e <walk>
  if (pte == 0)
    8000178c:	c901                	beqz	a0,8000179c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000178e:	611c                	ld	a5,0(a0)
    80001790:	9bbd                	andi	a5,a5,-17
    80001792:	e11c                	sd	a5,0(a0)
}
    80001794:	60a2                	ld	ra,8(sp)
    80001796:	6402                	ld	s0,0(sp)
    80001798:	0141                	addi	sp,sp,16
    8000179a:	8082                	ret
    panic("uvmclear");
    8000179c:	00007517          	auipc	a0,0x7
    800017a0:	a0450513          	addi	a0,a0,-1532 # 800081a0 <digits+0x138>
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	e40080e7          	jalr	-448(ra) # 800005e4 <panic>

00000000800017ac <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    800017ac:	caa5                	beqz	a3,8000181c <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    800017ae:	715d                	addi	sp,sp,-80
    800017b0:	e486                	sd	ra,72(sp)
    800017b2:	e0a2                	sd	s0,64(sp)
    800017b4:	fc26                	sd	s1,56(sp)
    800017b6:	f84a                	sd	s2,48(sp)
    800017b8:	f44e                	sd	s3,40(sp)
    800017ba:	f052                	sd	s4,32(sp)
    800017bc:	ec56                	sd	s5,24(sp)
    800017be:	e85a                	sd	s6,16(sp)
    800017c0:	e45e                	sd	s7,8(sp)
    800017c2:	e062                	sd	s8,0(sp)
    800017c4:	0880                	addi	s0,sp,80
    800017c6:	8b2a                	mv	s6,a0
    800017c8:	8a2e                	mv	s4,a1
    800017ca:	8c32                	mv	s8,a2
    800017cc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017ce:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017d0:	6a85                	lui	s5,0x1
    800017d2:	a01d                	j	800017f8 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017d4:	018505b3          	add	a1,a0,s8
    800017d8:	0004861b          	sext.w	a2,s1
    800017dc:	412585b3          	sub	a1,a1,s2
    800017e0:	8552                	mv	a0,s4
    800017e2:	fffff097          	auipc	ra,0xfffff
    800017e6:	6b0080e7          	jalr	1712(ra) # 80000e92 <memmove>

    len -= n;
    800017ea:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017ee:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017f0:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    800017f4:	02098263          	beqz	s3,80001818 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017f8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017fc:	85ca                	mv	a1,s2
    800017fe:	855a                	mv	a0,s6
    80001800:	00000097          	auipc	ra,0x0
    80001804:	9ba080e7          	jalr	-1606(ra) # 800011ba <walkaddr>
    if (pa0 == 0)
    80001808:	cd01                	beqz	a0,80001820 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000180a:	418904b3          	sub	s1,s2,s8
    8000180e:	94d6                	add	s1,s1,s5
    if (n > len)
    80001810:	fc99f2e3          	bgeu	s3,s1,800017d4 <copyin+0x28>
    80001814:	84ce                	mv	s1,s3
    80001816:	bf7d                	j	800017d4 <copyin+0x28>
  }
  return 0;
    80001818:	4501                	li	a0,0
    8000181a:	a021                	j	80001822 <copyin+0x76>
    8000181c:	4501                	li	a0,0
}
    8000181e:	8082                	ret
      return -1;
    80001820:	557d                	li	a0,-1
}
    80001822:	60a6                	ld	ra,72(sp)
    80001824:	6406                	ld	s0,64(sp)
    80001826:	74e2                	ld	s1,56(sp)
    80001828:	7942                	ld	s2,48(sp)
    8000182a:	79a2                	ld	s3,40(sp)
    8000182c:	7a02                	ld	s4,32(sp)
    8000182e:	6ae2                	ld	s5,24(sp)
    80001830:	6b42                	ld	s6,16(sp)
    80001832:	6ba2                	ld	s7,8(sp)
    80001834:	6c02                	ld	s8,0(sp)
    80001836:	6161                	addi	sp,sp,80
    80001838:	8082                	ret

000000008000183a <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    8000183a:	c6c5                	beqz	a3,800018e2 <copyinstr+0xa8>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    8000183c:	715d                	addi	sp,sp,-80
    8000183e:	e486                	sd	ra,72(sp)
    80001840:	e0a2                	sd	s0,64(sp)
    80001842:	fc26                	sd	s1,56(sp)
    80001844:	f84a                	sd	s2,48(sp)
    80001846:	f44e                	sd	s3,40(sp)
    80001848:	f052                	sd	s4,32(sp)
    8000184a:	ec56                	sd	s5,24(sp)
    8000184c:	e85a                	sd	s6,16(sp)
    8000184e:	e45e                	sd	s7,8(sp)
    80001850:	0880                	addi	s0,sp,80
    80001852:	8a2a                	mv	s4,a0
    80001854:	8b2e                	mv	s6,a1
    80001856:	8bb2                	mv	s7,a2
    80001858:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000185a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000185c:	6985                	lui	s3,0x1
    8000185e:	a035                	j	8000188a <copyinstr+0x50>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80001860:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001864:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80001866:	0017b793          	seqz	a5,a5
    8000186a:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000186e:	60a6                	ld	ra,72(sp)
    80001870:	6406                	ld	s0,64(sp)
    80001872:	74e2                	ld	s1,56(sp)
    80001874:	7942                	ld	s2,48(sp)
    80001876:	79a2                	ld	s3,40(sp)
    80001878:	7a02                	ld	s4,32(sp)
    8000187a:	6ae2                	ld	s5,24(sp)
    8000187c:	6b42                	ld	s6,16(sp)
    8000187e:	6ba2                	ld	s7,8(sp)
    80001880:	6161                	addi	sp,sp,80
    80001882:	8082                	ret
    srcva = va0 + PGSIZE;
    80001884:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80001888:	c8a9                	beqz	s1,800018da <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000188a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000188e:	85ca                	mv	a1,s2
    80001890:	8552                	mv	a0,s4
    80001892:	00000097          	auipc	ra,0x0
    80001896:	928080e7          	jalr	-1752(ra) # 800011ba <walkaddr>
    if (pa0 == 0)
    8000189a:	c131                	beqz	a0,800018de <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    8000189c:	41790833          	sub	a6,s2,s7
    800018a0:	984e                	add	a6,a6,s3
    if (n > max)
    800018a2:	0104f363          	bgeu	s1,a6,800018a8 <copyinstr+0x6e>
    800018a6:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    800018a8:	955e                	add	a0,a0,s7
    800018aa:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    800018ae:	fc080be3          	beqz	a6,80001884 <copyinstr+0x4a>
    800018b2:	985a                	add	a6,a6,s6
    800018b4:	87da                	mv	a5,s6
      if (*p == '\0') {
    800018b6:	41650633          	sub	a2,a0,s6
    800018ba:	14fd                	addi	s1,s1,-1
    800018bc:	9b26                	add	s6,s6,s1
    800018be:	00f60733          	add	a4,a2,a5
    800018c2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffab000>
    800018c6:	df49                	beqz	a4,80001860 <copyinstr+0x26>
        *dst = *p;
    800018c8:	00e78023          	sb	a4,0(a5)
      --max;
    800018cc:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018d0:	0785                	addi	a5,a5,1
    while (n > 0) {
    800018d2:	ff0796e3          	bne	a5,a6,800018be <copyinstr+0x84>
      dst++;
    800018d6:	8b42                	mv	s6,a6
    800018d8:	b775                	j	80001884 <copyinstr+0x4a>
    800018da:	4781                	li	a5,0
    800018dc:	b769                	j	80001866 <copyinstr+0x2c>
      return -1;
    800018de:	557d                	li	a0,-1
    800018e0:	b779                	j	8000186e <copyinstr+0x34>
  int got_null = 0;
    800018e2:	4781                	li	a5,0
  if (got_null) {
    800018e4:	0017b793          	seqz	a5,a5
    800018e8:	40f00533          	neg	a0,a5
}
    800018ec:	8082                	ret

00000000800018ee <do_cow>:

int do_cow(pagetable_t pt, uint64 addr) {
    800018ee:	7179                	addi	sp,sp,-48
    800018f0:	f406                	sd	ra,40(sp)
    800018f2:	f022                	sd	s0,32(sp)
    800018f4:	ec26                	sd	s1,24(sp)
    800018f6:	e84a                	sd	s2,16(sp)
    800018f8:	e44e                	sd	s3,8(sp)
    800018fa:	e052                	sd	s4,0(sp)
    800018fc:	1800                	addi	s0,sp,48
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;
  uint64 va = PGROUNDDOWN(addr);
  if ((pte = walk(pt, va, 0)) == 0)
    800018fe:	4601                	li	a2,0
    80001900:	77fd                	lui	a5,0xfffff
    80001902:	8dfd                	and	a1,a1,a5
    80001904:	00000097          	auipc	ra,0x0
    80001908:	81a080e7          	jalr	-2022(ra) # 8000111e <walk>
    8000190c:	c141                	beqz	a0,8000198c <do_cow+0x9e>
    8000190e:	89aa                	mv	s3,a0
    panic("uvmcopy: pte should exist");
  if ((*pte & PTE_V) == 0)
    80001910:	6104                	ld	s1,0(a0)
    80001912:	0014f793          	andi	a5,s1,1
    80001916:	c3d9                	beqz	a5,8000199c <do_cow+0xae>
    panic("uvmcopy: page not present");
  pa = PTE2PA(*pte);
    80001918:	00a4da13          	srli	s4,s1,0xa
    8000191c:	0a32                	slli	s4,s4,0xc
  flags = PTE_FLAGS(*pte);
  flags |= PTE_W;
  flags &= ~PTE_COW;
  if (page_ref_count[REF_IDX(pa)] == 1) {
    8000191e:	800007b7          	lui	a5,0x80000
    80001922:	97d2                	add	a5,a5,s4
    80001924:	00c7d693          	srli	a3,a5,0xc
    80001928:	83a9                	srli	a5,a5,0xa
    8000192a:	00010717          	auipc	a4,0x10
    8000192e:	03670713          	addi	a4,a4,54 # 80011960 <page_ref_count>
    80001932:	97ba                	add	a5,a5,a4
    80001934:	439c                	lw	a5,0(a5)
    80001936:	4705                	li	a4,1
    80001938:	06e78a63          	beq	a5,a4,800019ac <do_cow+0xbe>
    *pte |= PTE_W;
    *pte &= ~PTE_COW;
    return 0;
  }
  page_ref_count[REF_IDX(pa)] -= 1;
    8000193c:	068a                	slli	a3,a3,0x2
    8000193e:	00010717          	auipc	a4,0x10
    80001942:	02270713          	addi	a4,a4,34 # 80011960 <page_ref_count>
    80001946:	96ba                	add	a3,a3,a4
    80001948:	37fd                	addiw	a5,a5,-1
    8000194a:	c29c                	sw	a5,0(a3)
  if ((mem = kalloc()) == 0)
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	2b0080e7          	jalr	688(ra) # 80000bfc <kalloc>
    80001954:	892a                	mv	s2,a0
    80001956:	c135                	beqz	a0,800019ba <do_cow+0xcc>
    return -1;
  memmove(mem, (char *)pa, PGSIZE);
    80001958:	6605                	lui	a2,0x1
    8000195a:	85d2                	mv	a1,s4
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	536080e7          	jalr	1334(ra) # 80000e92 <memmove>
  *pte = PA2PTE(mem) | flags;
    80001964:	00c95913          	srli	s2,s2,0xc
    80001968:	092a                	slli	s2,s2,0xa
  flags &= ~PTE_COW;
    8000196a:	2ff4f493          	andi	s1,s1,767
  *pte = PA2PTE(mem) | flags;
    8000196e:	0044e493          	ori	s1,s1,4
    80001972:	009964b3          	or	s1,s2,s1
    80001976:	0099b023          	sd	s1,0(s3) # 1000 <_entry-0x7ffff000>

  return 0;
    8000197a:	4501                	li	a0,0
}
    8000197c:	70a2                	ld	ra,40(sp)
    8000197e:	7402                	ld	s0,32(sp)
    80001980:	64e2                	ld	s1,24(sp)
    80001982:	6942                	ld	s2,16(sp)
    80001984:	69a2                	ld	s3,8(sp)
    80001986:	6a02                	ld	s4,0(sp)
    80001988:	6145                	addi	sp,sp,48
    8000198a:	8082                	ret
    panic("uvmcopy: pte should exist");
    8000198c:	00007517          	auipc	a0,0x7
    80001990:	82450513          	addi	a0,a0,-2012 # 800081b0 <digits+0x148>
    80001994:	fffff097          	auipc	ra,0xfffff
    80001998:	c50080e7          	jalr	-944(ra) # 800005e4 <panic>
    panic("uvmcopy: page not present");
    8000199c:	00007517          	auipc	a0,0x7
    800019a0:	83450513          	addi	a0,a0,-1996 # 800081d0 <digits+0x168>
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	c40080e7          	jalr	-960(ra) # 800005e4 <panic>
    *pte &= ~PTE_COW;
    800019ac:	eff4f493          	andi	s1,s1,-257
    800019b0:	0044e493          	ori	s1,s1,4
    800019b4:	e104                	sd	s1,0(a0)
    return 0;
    800019b6:	4501                	li	a0,0
    800019b8:	b7d1                	j	8000197c <do_cow+0x8e>
    return -1;
    800019ba:	557d                	li	a0,-1
    800019bc:	b7c1                	j	8000197c <do_cow+0x8e>

00000000800019be <do_lazy_allocation>:

int do_lazy_allocation(pagetable_t pt, u64 addr) {
    800019be:	7179                	addi	sp,sp,-48
    800019c0:	f406                	sd	ra,40(sp)
    800019c2:	f022                	sd	s0,32(sp)
    800019c4:	ec26                	sd	s1,24(sp)
    800019c6:	e84a                	sd	s2,16(sp)
    800019c8:	e44e                	sd	s3,8(sp)
    800019ca:	1800                	addi	s0,sp,48
    800019cc:	892a                	mv	s2,a0
  u64 va, pa;
  va = PGROUNDDOWN(addr);
    800019ce:	79fd                	lui	s3,0xfffff
    800019d0:	0135f9b3          	and	s3,a1,s3
  if ((pa = (u64)kalloc()) == 0) {
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	228080e7          	jalr	552(ra) # 80000bfc <kalloc>
    800019dc:	c121                	beqz	a0,80001a1c <do_lazy_allocation+0x5e>
    800019de:	84aa                	mv	s1,a0
    // uvmdealloc(pt, va + PGSIZE, va);
    return -1;
  }
  memset((void *)pa, 0, PGSIZE);
    800019e0:	6605                	lui	a2,0x1
    800019e2:	4581                	li	a1,0
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	452080e7          	jalr	1106(ra) # 80000e36 <memset>
  if (mappages(pt, va, PGSIZE, pa, PTE_R | PTE_W | PTE_X | PTE_U) != 0) {
    800019ec:	4779                	li	a4,30
    800019ee:	86a6                	mv	a3,s1
    800019f0:	6605                	lui	a2,0x1
    800019f2:	85ce                	mv	a1,s3
    800019f4:	854a                	mv	a0,s2
    800019f6:	00000097          	auipc	ra,0x0
    800019fa:	864080e7          	jalr	-1948(ra) # 8000125a <mappages>
    800019fe:	e901                	bnez	a0,80001a0e <do_lazy_allocation+0x50>
    kfree((void *)pa);
    // uvmdealloc(pt, va + PGSIZE, va);
    return -2;
  }
  return 0;
}
    80001a00:	70a2                	ld	ra,40(sp)
    80001a02:	7402                	ld	s0,32(sp)
    80001a04:	64e2                	ld	s1,24(sp)
    80001a06:	6942                	ld	s2,16(sp)
    80001a08:	69a2                	ld	s3,8(sp)
    80001a0a:	6145                	addi	sp,sp,48
    80001a0c:	8082                	ret
    kfree((void *)pa);
    80001a0e:	8526                	mv	a0,s1
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	07a080e7          	jalr	122(ra) # 80000a8a <kfree>
    return -2;
    80001a18:	5579                	li	a0,-2
    80001a1a:	b7dd                	j	80001a00 <do_lazy_allocation+0x42>
    return -1;
    80001a1c:	557d                	li	a0,-1
    80001a1e:	b7cd                	j	80001a00 <do_lazy_allocation+0x42>

0000000080001a20 <copyout>:
  while (len > 0) {
    80001a20:	c695                	beqz	a3,80001a4c <copyout+0x2c>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80001a22:	715d                	addi	sp,sp,-80
    80001a24:	e486                	sd	ra,72(sp)
    80001a26:	e0a2                	sd	s0,64(sp)
    80001a28:	fc26                	sd	s1,56(sp)
    80001a2a:	f84a                	sd	s2,48(sp)
    80001a2c:	f44e                	sd	s3,40(sp)
    80001a2e:	f052                	sd	s4,32(sp)
    80001a30:	ec56                	sd	s5,24(sp)
    80001a32:	e85a                	sd	s6,16(sp)
    80001a34:	e45e                	sd	s7,8(sp)
    80001a36:	e062                	sd	s8,0(sp)
    80001a38:	0880                	addi	s0,sp,80
    80001a3a:	8b2a                	mv	s6,a0
    80001a3c:	89ae                	mv	s3,a1
    80001a3e:	8ab2                	mv	s5,a2
    80001a40:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80001a42:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80001a44:	6b85                	lui	s7,0x1
    80001a46:	a061                	j	80001ace <copyout+0xae>
  return 0;
    80001a48:	4501                	li	a0,0
    80001a4a:	a031                	j	80001a56 <copyout+0x36>
    80001a4c:	4501                	li	a0,0
}
    80001a4e:	8082                	ret
        return -1;
    80001a50:	557d                	li	a0,-1
    80001a52:	a011                	j	80001a56 <copyout+0x36>
      return -1;
    80001a54:	557d                	li	a0,-1
}
    80001a56:	60a6                	ld	ra,72(sp)
    80001a58:	6406                	ld	s0,64(sp)
    80001a5a:	74e2                	ld	s1,56(sp)
    80001a5c:	7942                	ld	s2,48(sp)
    80001a5e:	79a2                	ld	s3,40(sp)
    80001a60:	7a02                	ld	s4,32(sp)
    80001a62:	6ae2                	ld	s5,24(sp)
    80001a64:	6b42                	ld	s6,16(sp)
    80001a66:	6ba2                	ld	s7,8(sp)
    80001a68:	6c02                	ld	s8,0(sp)
    80001a6a:	6161                	addi	sp,sp,80
    80001a6c:	8082                	ret
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001a6e:	00000097          	auipc	ra,0x0
    80001a72:	69c080e7          	jalr	1692(ra) # 8000210a <myproc>
    80001a76:	653c                	ld	a5,72(a0)
    80001a78:	06f97963          	bgeu	s2,a5,80001aea <copyout+0xca>
      if (do_lazy_allocation(myproc()->pagetable, va0) != 0) {
    80001a7c:	00000097          	auipc	ra,0x0
    80001a80:	68e080e7          	jalr	1678(ra) # 8000210a <myproc>
    80001a84:	85ca                	mv	a1,s2
    80001a86:	6928                	ld	a0,80(a0)
    80001a88:	00000097          	auipc	ra,0x0
    80001a8c:	f36080e7          	jalr	-202(ra) # 800019be <do_lazy_allocation>
    80001a90:	f161                	bnez	a0,80001a50 <copyout+0x30>
    pa0 = walkaddr(pagetable, va0);
    80001a92:	85ca                	mv	a1,s2
    80001a94:	855a                	mv	a0,s6
    80001a96:	fffff097          	auipc	ra,0xfffff
    80001a9a:	724080e7          	jalr	1828(ra) # 800011ba <walkaddr>
    if (pa0 == 0)
    80001a9e:	d95d                	beqz	a0,80001a54 <copyout+0x34>
    n = PGSIZE - (dstva - va0);
    80001aa0:	413904b3          	sub	s1,s2,s3
    80001aa4:	94de                	add	s1,s1,s7
    if (n > len)
    80001aa6:	009a7363          	bgeu	s4,s1,80001aac <copyout+0x8c>
    80001aaa:	84d2                	mv	s1,s4
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001aac:	412989b3          	sub	s3,s3,s2
    80001ab0:	0004861b          	sext.w	a2,s1
    80001ab4:	85d6                	mv	a1,s5
    80001ab6:	954e                	add	a0,a0,s3
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	3da080e7          	jalr	986(ra) # 80000e92 <memmove>
    len -= n;
    80001ac0:	409a0a33          	sub	s4,s4,s1
    src += n;
    80001ac4:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001ac6:	017909b3          	add	s3,s2,s7
  while (len > 0) {
    80001aca:	f60a0fe3          	beqz	s4,80001a48 <copyout+0x28>
    va0 = PGROUNDDOWN(dstva);
    80001ace:	0189f933          	and	s2,s3,s8
    pte_t *pte = walk(pagetable, va0, 0);
    80001ad2:	4601                	li	a2,0
    80001ad4:	85ca                	mv	a1,s2
    80001ad6:	855a                	mv	a0,s6
    80001ad8:	fffff097          	auipc	ra,0xfffff
    80001adc:	646080e7          	jalr	1606(ra) # 8000111e <walk>
    80001ae0:	84aa                	mv	s1,a0
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001ae2:	c10d                	beqz	a0,80001b04 <copyout+0xe4>
    80001ae4:	611c                	ld	a5,0(a0)
    80001ae6:	8b85                	andi	a5,a5,1
    80001ae8:	d3d9                	beqz	a5,80001a6e <copyout+0x4e>
    } else if (pte && (*pte & PTE_COW)) {
    80001aea:	609c                	ld	a5,0(s1)
    80001aec:	1007f793          	andi	a5,a5,256
    80001af0:	d3cd                	beqz	a5,80001a92 <copyout+0x72>
      if (do_cow(pagetable, va0) != 0)
    80001af2:	85ca                	mv	a1,s2
    80001af4:	855a                	mv	a0,s6
    80001af6:	00000097          	auipc	ra,0x0
    80001afa:	df8080e7          	jalr	-520(ra) # 800018ee <do_cow>
    80001afe:	d951                	beqz	a0,80001a92 <copyout+0x72>
        return -2;
    80001b00:	5579                	li	a0,-2
    80001b02:	bf91                	j	80001a56 <copyout+0x36>
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001b04:	00000097          	auipc	ra,0x0
    80001b08:	606080e7          	jalr	1542(ra) # 8000210a <myproc>
    80001b0c:	653c                	ld	a5,72(a0)
    80001b0e:	f8f972e3          	bgeu	s2,a5,80001a92 <copyout+0x72>
    80001b12:	b7ad                	j	80001a7c <copyout+0x5c>

0000000080001b14 <find_avail_addr_range>:
void *find_avail_addr_range(vma_t *vma) {
    80001b14:	1141                	addi	sp,sp,-16
    80001b16:	e422                	sd	s0,8(sp)
    80001b18:	0800                	addi	s0,sp,16
    80001b1a:	87aa                	mv	a5,a0
  void *avail = (void *)VMA_ORIGIN;
  for (int i = 0; i < MAX_VMA; i++) {
    80001b1c:	38050613          	addi	a2,a0,896
  void *avail = (void *)VMA_ORIGIN;
    80001b20:	4715                	li	a4,5
    80001b22:	02071513          	slli	a0,a4,0x20
    if ((vma + i)->used) {
      if ((vma + i)->start + (vma + i)->length > avail)
        avail =
            (void *)PGROUNDUP((uint64)((vma + i)->start + (vma + i)->length));
    80001b26:	6585                	lui	a1,0x1
    80001b28:	15fd                	addi	a1,a1,-1
    80001b2a:	787d                	lui	a6,0xfffff
    80001b2c:	a029                	j	80001b36 <find_avail_addr_range+0x22>
  for (int i = 0; i < MAX_VMA; i++) {
    80001b2e:	03878793          	addi	a5,a5,56 # ffffffff80000038 <end+0xfffffffefffac038>
    80001b32:	00c78e63          	beq	a5,a2,80001b4e <find_avail_addr_range+0x3a>
    if ((vma + i)->used) {
    80001b36:	0307c683          	lbu	a3,48(a5)
    80001b3a:	daf5                	beqz	a3,80001b2e <find_avail_addr_range+0x1a>
      if ((vma + i)->start + (vma + i)->length > avail)
    80001b3c:	6398                	ld	a4,0(a5)
    80001b3e:	6b94                	ld	a3,16(a5)
    80001b40:	9736                	add	a4,a4,a3
    80001b42:	fee576e3          	bgeu	a0,a4,80001b2e <find_avail_addr_range+0x1a>
            (void *)PGROUNDUP((uint64)((vma + i)->start + (vma + i)->length));
    80001b46:	972e                	add	a4,a4,a1
    80001b48:	01077533          	and	a0,a4,a6
    80001b4c:	b7cd                	j	80001b2e <find_avail_addr_range+0x1a>
    }
  }
  return avail;
}
    80001b4e:	6422                	ld	s0,8(sp)
    80001b50:	0141                	addi	sp,sp,16
    80001b52:	8082                	ret

0000000080001b54 <do_vma>:

int do_vma(void *addr, vma_t *vma) {
    80001b54:	7179                	addi	sp,sp,-48
    80001b56:	f406                	sd	ra,40(sp)
    80001b58:	f022                	sd	s0,32(sp)
    80001b5a:	ec26                	sd	s1,24(sp)
    80001b5c:	e84a                	sd	s2,16(sp)
    80001b5e:	e44e                	sd	s3,8(sp)
    80001b60:	e052                	sd	s4,0(sp)
    80001b62:	1800                	addi	s0,sp,48
  if (addr < vma->start || addr >= vma->start + vma->length)
    80001b64:	619c                	ld	a5,0(a1)
    80001b66:	06f56363          	bltu	a0,a5,80001bcc <do_vma+0x78>
    80001b6a:	892a                	mv	s2,a0
    80001b6c:	84ae                	mv	s1,a1
    80001b6e:	6998                	ld	a4,16(a1)
    80001b70:	97ba                	add	a5,a5,a4
    80001b72:	04f57d63          	bgeu	a0,a5,80001bcc <do_vma+0x78>
    panic("invalid mmap!!!");
  void *pa;
  if ((pa = kalloc()) == 0)
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	086080e7          	jalr	134(ra) # 80000bfc <kalloc>
    80001b7e:	89aa                	mv	s3,a0
    80001b80:	c565                	beqz	a0,80001c68 <do_vma+0x114>
    return -1;
  memset(pa, 0, PGSIZE);
    80001b82:	6605                	lui	a2,0x1
    80001b84:	4581                	li	a1,0
    80001b86:	fffff097          	auipc	ra,0xfffff
    80001b8a:	2b0080e7          	jalr	688(ra) # 80000e36 <memset>
  if (!(vma->flag & MAP_ANNO)) {
    80001b8e:	4cdc                	lw	a5,28(s1)
    80001b90:	8b91                	andi	a5,a5,4
  }

  // * set proper PTE permission
  int perm = PTE_U;
  if (vma->flag & MAP_ANNO) {
    perm |= PTE_R | PTE_W;
    80001b92:	4a59                	li	s4,22
  if (!(vma->flag & MAP_ANNO)) {
    80001b94:	c7a1                	beqz	a5,80001bdc <do_vma+0x88>
        (vma->proct & PROT_WRITE))
      perm |= PTE_W;
    if (vma->proct & PROT_EXEC)
      perm |= PTE_X;
  }
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
    80001b96:	00000097          	auipc	ra,0x0
    80001b9a:	574080e7          	jalr	1396(ra) # 8000210a <myproc>
    80001b9e:	8752                	mv	a4,s4
    80001ba0:	86ce                	mv	a3,s3
    80001ba2:	6605                	lui	a2,0x1
    80001ba4:	75fd                	lui	a1,0xfffff
    80001ba6:	00b975b3          	and	a1,s2,a1
    80001baa:	6928                	ld	a0,80(a0)
    80001bac:	fffff097          	auipc	ra,0xfffff
    80001bb0:	6ae080e7          	jalr	1710(ra) # 8000125a <mappages>
    80001bb4:	87aa                	mv	a5,a0
               (uint64)pa, perm) < 0)
    return -3;
  // printf("hello in do vma\n");
  return 0;
    80001bb6:	4501                	li	a0,0
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
    80001bb8:	0a07c663          	bltz	a5,80001c64 <do_vma+0x110>
}
    80001bbc:	70a2                	ld	ra,40(sp)
    80001bbe:	7402                	ld	s0,32(sp)
    80001bc0:	64e2                	ld	s1,24(sp)
    80001bc2:	6942                	ld	s2,16(sp)
    80001bc4:	69a2                	ld	s3,8(sp)
    80001bc6:	6a02                	ld	s4,0(sp)
    80001bc8:	6145                	addi	sp,sp,48
    80001bca:	8082                	ret
    panic("invalid mmap!!!");
    80001bcc:	00006517          	auipc	a0,0x6
    80001bd0:	62450513          	addi	a0,a0,1572 # 800081f0 <digits+0x188>
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	a10080e7          	jalr	-1520(ra) # 800005e4 <panic>
    uint file_off = ((addr - vma->start + vma->offset) >> 12) << 12;
    80001bdc:	0004ba03          	ld	s4,0(s1)
    80001be0:	414907b3          	sub	a5,s2,s4
    80001be4:	0204aa03          	lw	s4,32(s1)
    80001be8:	00fa0a3b          	addw	s4,s4,a5
    80001bec:	77fd                	lui	a5,0xfffff
    80001bee:	00fa7a33          	and	s4,s4,a5
    80001bf2:	2a01                	sext.w	s4,s4
    ilock(vma->mmaped_file->ip);
    80001bf4:	749c                	ld	a5,40(s1)
    80001bf6:	6f88                	ld	a0,24(a5)
    80001bf8:	00002097          	auipc	ra,0x2
    80001bfc:	348080e7          	jalr	840(ra) # 80003f40 <ilock>
    if ((rc = readi(vma->mmaped_file->ip, 0, (uint64)pa, file_off, PGSIZE)) <
    80001c00:	749c                	ld	a5,40(s1)
    80001c02:	6705                	lui	a4,0x1
    80001c04:	86d2                	mv	a3,s4
    80001c06:	864e                	mv	a2,s3
    80001c08:	4581                	li	a1,0
    80001c0a:	6f88                	ld	a0,24(a5)
    80001c0c:	00002097          	auipc	ra,0x2
    80001c10:	5e8080e7          	jalr	1512(ra) # 800041f4 <readi>
    80001c14:	02054b63          	bltz	a0,80001c4a <do_vma+0xf6>
    iunlock(vma->mmaped_file->ip);
    80001c18:	749c                	ld	a5,40(s1)
    80001c1a:	6f88                	ld	a0,24(a5)
    80001c1c:	00002097          	auipc	ra,0x2
    80001c20:	3e6080e7          	jalr	998(ra) # 80004002 <iunlock>
  if (vma->flag & MAP_ANNO) {
    80001c24:	4cdc                	lw	a5,28(s1)
    80001c26:	8b91                	andi	a5,a5,4
    80001c28:	ef85                	bnez	a5,80001c60 <do_vma+0x10c>
    if ((vma->mmaped_file->readable) && (vma->proct & PROT_READ))
    80001c2a:	749c                	ld	a5,40(s1)
    80001c2c:	0087c703          	lbu	a4,8(a5) # fffffffffffff008 <end+0xffffffff7ffab008>
    80001c30:	cf15                	beqz	a4,80001c6c <do_vma+0x118>
    80001c32:	4c98                	lw	a4,24(s1)
    80001c34:	00177693          	andi	a3,a4,1
  int perm = PTE_U;
    80001c38:	4a41                	li	s4,16
    if ((vma->mmaped_file->readable) && (vma->proct & PROT_READ))
    80001c3a:	c291                	beqz	a3,80001c3e <do_vma+0xea>
      perm |= PTE_R;
    80001c3c:	4a49                	li	s4,18
    if (((vma->mmaped_file->writable) ||
    80001c3e:	0097c783          	lbu	a5,9(a5)
    80001c42:	eb95                	bnez	a5,80001c76 <do_vma+0x122>
         (vma->mmaped_file->readable && (vma->proct & MAP_PRIVATE))) &&
    80001c44:	8b09                	andi	a4,a4,2
    80001c46:	eb1d                	bnez	a4,80001c7c <do_vma+0x128>
    80001c48:	a825                	j	80001c80 <do_vma+0x12c>
      printf("read failed , actual read %d\n", rc);
    80001c4a:	85aa                	mv	a1,a0
    80001c4c:	00006517          	auipc	a0,0x6
    80001c50:	5b450513          	addi	a0,a0,1460 # 80008200 <digits+0x198>
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	9e2080e7          	jalr	-1566(ra) # 80000636 <printf>
      return -2;
    80001c5c:	5579                	li	a0,-2
    80001c5e:	bfb9                	j	80001bbc <do_vma+0x68>
    perm |= PTE_R | PTE_W;
    80001c60:	4a59                	li	s4,22
    80001c62:	bf15                	j	80001b96 <do_vma+0x42>
    return -3;
    80001c64:	5575                	li	a0,-3
    80001c66:	bf99                	j	80001bbc <do_vma+0x68>
    return -1;
    80001c68:	557d                	li	a0,-1
    80001c6a:	bf89                	j	80001bbc <do_vma+0x68>
    if (((vma->mmaped_file->writable) ||
    80001c6c:	0097c783          	lbu	a5,9(a5)
  int perm = PTE_U;
    80001c70:	4a41                	li	s4,16
    if (((vma->mmaped_file->writable) ||
    80001c72:	c799                	beqz	a5,80001c80 <do_vma+0x12c>
  int perm = PTE_U;
    80001c74:	4a41                	li	s4,16
        (vma->proct & PROT_WRITE))
    80001c76:	4c9c                	lw	a5,24(s1)
         (vma->mmaped_file->readable && (vma->proct & MAP_PRIVATE))) &&
    80001c78:	8b89                	andi	a5,a5,2
    80001c7a:	c399                	beqz	a5,80001c80 <do_vma+0x12c>
      perm |= PTE_W;
    80001c7c:	004a6a13          	ori	s4,s4,4
    if (vma->proct & PROT_EXEC)
    80001c80:	4c9c                	lw	a5,24(s1)
    80001c82:	8b91                	andi	a5,a5,4
    80001c84:	db89                	beqz	a5,80001b96 <do_vma+0x42>
      perm |= PTE_X;
    80001c86:	008a6a13          	ori	s4,s4,8
    80001c8a:	b731                	j	80001b96 <do_vma+0x42>

0000000080001c8c <mmap>:

void *mmap(void *addr, u64 length, int proct, int flag, int fd, int offset) {
    80001c8c:	715d                	addi	sp,sp,-80
    80001c8e:	e486                	sd	ra,72(sp)
    80001c90:	e0a2                	sd	s0,64(sp)
    80001c92:	fc26                	sd	s1,56(sp)
    80001c94:	f84a                	sd	s2,48(sp)
    80001c96:	f44e                	sd	s3,40(sp)
    80001c98:	f052                	sd	s4,32(sp)
    80001c9a:	ec56                	sd	s5,24(sp)
    80001c9c:	e85a                	sd	s6,16(sp)
    80001c9e:	e45e                	sd	s7,8(sp)
    80001ca0:	e062                	sd	s8,0(sp)
    80001ca2:	0880                	addi	s0,sp,80
    80001ca4:	8a2a                	mv	s4,a0
    80001ca6:	8bae                	mv	s7,a1
    80001ca8:	8b32                	mv	s6,a2
    80001caa:	8ab6                	mv	s5,a3
    80001cac:	893a                	mv	s2,a4
    80001cae:	8c3e                	mv	s8,a5
  struct proc *p = myproc();
    80001cb0:	00000097          	auipc	ra,0x0
    80001cb4:	45a080e7          	jalr	1114(ra) # 8000210a <myproc>
    80001cb8:	89aa                	mv	s3,a0
  int i;

  // ! error checking for fd
  if ((fd < 0 && !(flag & MAP_ANNO)) || fd > NOFILE ||
    80001cba:	02094863          	bltz	s2,80001cea <mmap+0x5e>
    80001cbe:	47c1                	li	a5,16
    return (void *)-1;

  return p->vma[i].start;

err:
  return (void *)-1;
    80001cc0:	557d                	li	a0,-1
  if ((fd < 0 && !(flag & MAP_ANNO)) || fd > NOFILE ||
    80001cc2:	0927ce63          	blt	a5,s2,80001d5e <mmap+0xd2>
    80001cc6:	03205663          	blez	s2,80001cf2 <mmap+0x66>
      (fd > 0 && !p->ofile[fd]))
    80001cca:	00391793          	slli	a5,s2,0x3
    80001cce:	97ce                	add	a5,a5,s3
    80001cd0:	6bfc                	ld	a5,208(a5)
    80001cd2:	c7e1                	beqz	a5,80001d9a <mmap+0x10e>
  if ((proct & PROT_WRITE) && (fd > 0 && !p->ofile[fd]->writable) &&
    80001cd4:	002b7713          	andi	a4,s6,2
    80001cd8:	cf09                	beqz	a4,80001cf2 <mmap+0x66>
    80001cda:	0097c783          	lbu	a5,9(a5)
    80001cde:	eb91                	bnez	a5,80001cf2 <mmap+0x66>
    80001ce0:	001af793          	andi	a5,s5,1
  return (void *)-1;
    80001ce4:	557d                	li	a0,-1
  if ((proct & PROT_WRITE) && (fd > 0 && !p->ofile[fd]->writable) &&
    80001ce6:	c791                	beqz	a5,80001cf2 <mmap+0x66>
    80001ce8:	a89d                	j	80001d5e <mmap+0xd2>
  if ((fd < 0 && !(flag & MAP_ANNO)) || fd > NOFILE ||
    80001cea:	004af793          	andi	a5,s5,4
  return (void *)-1;
    80001cee:	557d                	li	a0,-1
  if ((fd < 0 && !(flag & MAP_ANNO)) || fd > NOFILE ||
    80001cf0:	c7bd                	beqz	a5,80001d5e <mmap+0xd2>
    if (!p->vma[0].used) {
    80001cf2:	1a89c703          	lbu	a4,424(s3) # fffffffffffff1a8 <end+0xffffffff7ffab1a8>
    80001cf6:	4481                	li	s1,0
  for (i = 0; i < MAX_VMA; i++) {
    80001cf8:	4841                	li	a6,16
    if (!p->vma[0].used) {
    80001cfa:	c711                	beqz	a4,80001d06 <mmap+0x7a>
  for (i = 0; i < MAX_VMA; i++) {
    80001cfc:	2485                	addiw	s1,s1,1
    80001cfe:	ff049ee3          	bne	s1,a6,80001cfa <mmap+0x6e>
    return (void *)-1;
    80001d02:	557d                	li	a0,-1
    80001d04:	a8a9                	j	80001d5e <mmap+0xd2>
      p->vma[i].mmaped_file = !(flag & MAP_ANNO) ? filedup(p->ofile[fd]) : 0;
    80001d06:	004af793          	andi	a5,s5,4
    80001d0a:	4501                	li	a0,0
    80001d0c:	c7ad                	beqz	a5,80001d76 <mmap+0xea>
    80001d0e:	00349793          	slli	a5,s1,0x3
    80001d12:	8f85                	sub	a5,a5,s1
    80001d14:	078e                	slli	a5,a5,0x3
    80001d16:	97ce                	add	a5,a5,s3
    80001d18:	1aa7b023          	sd	a0,416(a5)
      p->vma[i].used = 1;
    80001d1c:	4705                	li	a4,1
    80001d1e:	1ae78423          	sb	a4,424(a5)
      p->vma[i].length = length;
    80001d22:	1977b423          	sd	s7,392(a5)
      p->vma[i].proct = proct;
    80001d26:	1967a823          	sw	s6,400(a5)
      p->vma[i].offset = offset;
    80001d2a:	1987ac23          	sw	s8,408(a5)
      p->vma[i].flag = flag;
    80001d2e:	1957aa23          	sw	s5,404(a5)
      if (addr == 0)
    80001d32:	040a0c63          	beqz	s4,80001d8a <mmap+0xfe>
      p->vma[i].start = addr;
    80001d36:	00349793          	slli	a5,s1,0x3
    80001d3a:	8f85                	sub	a5,a5,s1
    80001d3c:	078e                	slli	a5,a5,0x3
    80001d3e:	97ce                	add	a5,a5,s3
    80001d40:	1747bc23          	sd	s4,376(a5)
      p->vma[i].origin = addr;
    80001d44:	1947b023          	sd	s4,384(a5)
  if (i == MAX_VMA)
    80001d48:	47c1                	li	a5,16
    80001d4a:	04f48a63          	beq	s1,a5,80001d9e <mmap+0x112>
  return p->vma[i].start;
    80001d4e:	00349793          	slli	a5,s1,0x3
    80001d52:	409784b3          	sub	s1,a5,s1
    80001d56:	048e                	slli	s1,s1,0x3
    80001d58:	99a6                	add	s3,s3,s1
    80001d5a:	1789b503          	ld	a0,376(s3)
}
    80001d5e:	60a6                	ld	ra,72(sp)
    80001d60:	6406                	ld	s0,64(sp)
    80001d62:	74e2                	ld	s1,56(sp)
    80001d64:	7942                	ld	s2,48(sp)
    80001d66:	79a2                	ld	s3,40(sp)
    80001d68:	7a02                	ld	s4,32(sp)
    80001d6a:	6ae2                	ld	s5,24(sp)
    80001d6c:	6b42                	ld	s6,16(sp)
    80001d6e:	6ba2                	ld	s7,8(sp)
    80001d70:	6c02                	ld	s8,0(sp)
    80001d72:	6161                	addi	sp,sp,80
    80001d74:	8082                	ret
      p->vma[i].mmaped_file = !(flag & MAP_ANNO) ? filedup(p->ofile[fd]) : 0;
    80001d76:	01a90793          	addi	a5,s2,26 # 101a <_entry-0x7fffefe6>
    80001d7a:	078e                	slli	a5,a5,0x3
    80001d7c:	97ce                	add	a5,a5,s3
    80001d7e:	6388                	ld	a0,0(a5)
    80001d80:	00003097          	auipc	ra,0x3
    80001d84:	000080e7          	jalr	ra # 80004d80 <filedup>
    80001d88:	b759                	j	80001d0e <mmap+0x82>
        addr = find_avail_addr_range(&p->vma[0]);
    80001d8a:	17898513          	addi	a0,s3,376
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	d86080e7          	jalr	-634(ra) # 80001b14 <find_avail_addr_range>
    80001d96:	8a2a                	mv	s4,a0
    80001d98:	bf79                	j	80001d36 <mmap+0xaa>
  return (void *)-1;
    80001d9a:	557d                	li	a0,-1
    80001d9c:	b7c9                	j	80001d5e <mmap+0xd2>
    return (void *)-1;
    80001d9e:	557d                	li	a0,-1
    80001da0:	bf7d                	j	80001d5e <mmap+0xd2>

0000000080001da2 <munmap>:

int munmap(void *addr, int length) {
    80001da2:	7175                	addi	sp,sp,-144
    80001da4:	e506                	sd	ra,136(sp)
    80001da6:	e122                	sd	s0,128(sp)
    80001da8:	fca6                	sd	s1,120(sp)
    80001daa:	f8ca                	sd	s2,112(sp)
    80001dac:	f4ce                	sd	s3,104(sp)
    80001dae:	f0d2                	sd	s4,96(sp)
    80001db0:	ecd6                	sd	s5,88(sp)
    80001db2:	e8da                	sd	s6,80(sp)
    80001db4:	e4de                	sd	s7,72(sp)
    80001db6:	e0e2                	sd	s8,64(sp)
    80001db8:	fc66                	sd	s9,56(sp)
    80001dba:	f86a                	sd	s10,48(sp)
    80001dbc:	f46e                	sd	s11,40(sp)
    80001dbe:	0900                	addi	s0,sp,144
    80001dc0:	892a                	mv	s2,a0
    80001dc2:	89ae                	mv	s3,a1
  // printf("~~~hello in unmap\n");
  vma_t *vma;
  struct proc *p = myproc();
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	346080e7          	jalr	838(ra) # 8000210a <myproc>
    80001dcc:	8aaa                	mv	s5,a0
  uint8 valid = 0;
  for (int i = 0; i < MAX_VMA; i++) {
    80001dce:	17850793          	addi	a5,a0,376
    80001dd2:	4481                	li	s1,0
    if (p->vma[i].start == addr && p->vma[i].length >= length) {
    80001dd4:	f9343423          	sd	s3,-120(s0)
  for (int i = 0; i < MAX_VMA; i++) {
    80001dd8:	46c1                	li	a3,16
    80001dda:	a031                	j	80001de6 <munmap+0x44>
    80001ddc:	2485                	addiw	s1,s1,1
    80001dde:	03878793          	addi	a5,a5,56
    80001de2:	04d48563          	beq	s1,a3,80001e2c <munmap+0x8a>
    if (p->vma[i].start == addr && p->vma[i].length >= length) {
    80001de6:	6398                	ld	a4,0(a5)
    80001de8:	ff271ae3          	bne	a4,s2,80001ddc <munmap+0x3a>
    80001dec:	f8843703          	ld	a4,-120(s0)
    80001df0:	f6e43c23          	sd	a4,-136(s0)
    80001df4:	6b98                	ld	a4,16(a5)
    80001df6:	ff3763e3          	bltu	a4,s3,80001ddc <munmap+0x3a>
    printf("not in vma\n");
    return -1;
  }
  int left = length, should_write = 0;
  void *cur = addr;
  if (!(vma->flag & MAP_ANNO))
    80001dfa:	00349793          	slli	a5,s1,0x3
    80001dfe:	8f85                	sub	a5,a5,s1
    80001e00:	078e                	slli	a5,a5,0x3
    80001e02:	97d6                	add	a5,a5,s5
    80001e04:	1947a783          	lw	a5,404(a5)
    80001e08:	8b91                	andi	a5,a5,4
    80001e0a:	cba9                	beqz	a5,80001e5c <munmap+0xba>
    vma->mmaped_file->off = cur - vma->origin + vma->offset;
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001e0c:	f8843783          	ld	a5,-120(s0)
    80001e10:	00f90d33          	add	s10,s2,a5
    80001e14:	13a97263          	bgeu	s2,s10,80001f38 <munmap+0x196>
    80001e18:	4b01                	li	s6,0
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    if (!pte)
      continue;
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    80001e1a:	7dfd                	lui	s11,0xfffff
    80001e1c:	6c85                	lui	s9,0x1
    left -= should_write;
    int wc = -9;
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
    80001e1e:	00349c13          	slli	s8,s1,0x3
    80001e22:	409c0c33          	sub	s8,s8,s1
    80001e26:	0c0e                	slli	s8,s8,0x3
    80001e28:	9c56                	add	s8,s8,s5
    80001e2a:	a075                	j	80001ed6 <munmap+0x134>
    printf("not in vma\n");
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	3f450513          	addi	a0,a0,1012 # 80008220 <digits+0x1b8>
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	802080e7          	jalr	-2046(ra) # 80000636 <printf>
    return -1;
    80001e3c:	557d                	li	a0,-1
  } else {
    vma->start += length;
    vma->length -= length;
  }
  return 0;
    80001e3e:	60aa                	ld	ra,136(sp)
    80001e40:	640a                	ld	s0,128(sp)
    80001e42:	74e6                	ld	s1,120(sp)
    80001e44:	7946                	ld	s2,112(sp)
    80001e46:	79a6                	ld	s3,104(sp)
    80001e48:	7a06                	ld	s4,96(sp)
    80001e4a:	6ae6                	ld	s5,88(sp)
    80001e4c:	6b46                	ld	s6,80(sp)
    80001e4e:	6ba6                	ld	s7,72(sp)
    80001e50:	6c06                	ld	s8,64(sp)
    80001e52:	7ce2                	ld	s9,56(sp)
    80001e54:	7d42                	ld	s10,48(sp)
    80001e56:	7da2                	ld	s11,40(sp)
    80001e58:	6149                	addi	sp,sp,144
    80001e5a:	8082                	ret
    vma->mmaped_file->off = cur - vma->origin + vma->offset;
    80001e5c:	00349793          	slli	a5,s1,0x3
    80001e60:	8f85                	sub	a5,a5,s1
    80001e62:	078e                	slli	a5,a5,0x3
    80001e64:	97d6                	add	a5,a5,s5
    80001e66:	1a07b683          	ld	a3,416(a5)
    80001e6a:	1807b703          	ld	a4,384(a5)
    80001e6e:	40e90733          	sub	a4,s2,a4
    80001e72:	1987a783          	lw	a5,408(a5)
    80001e76:	9fb9                	addw	a5,a5,a4
    80001e78:	d29c                	sw	a5,32(a3)
    80001e7a:	bf49                	j	80001e0c <munmap+0x6a>
      wc = filewrite(vma->mmaped_file, (uint64)cur, should_write);
    80001e7c:	865a                	mv	a2,s6
    80001e7e:	f8043583          	ld	a1,-128(s0)
    80001e82:	1a0c3503          	ld	a0,416(s8) # fffffffffffff1a0 <end+0xffffffff7ffab1a0>
    80001e86:	00003097          	auipc	ra,0x3
    80001e8a:	148080e7          	jalr	328(ra) # 80004fce <filewrite>
      if (wc < 0) {
    80001e8e:	08055563          	bgez	a0,80001f18 <munmap+0x176>
               vma->mmaped_file->off, cur, should_write, wc);
    80001e92:	00349793          	slli	a5,s1,0x3
    80001e96:	8f85                	sub	a5,a5,s1
    80001e98:	078e                	slli	a5,a5,0x3
    80001e9a:	9abe                	add	s5,s5,a5
        printf("res %d offset %d cur %p should %d vma write %d\n", wc,
    80001e9c:	1a0ab603          	ld	a2,416(s5) # fffffffffffff1a0 <end+0xffffffff7ffab1a0>
    80001ea0:	87aa                	mv	a5,a0
    80001ea2:	875a                	mv	a4,s6
    80001ea4:	86ca                	mv	a3,s2
    80001ea6:	5210                	lw	a2,32(a2)
    80001ea8:	85aa                	mv	a1,a0
    80001eaa:	00006517          	auipc	a0,0x6
    80001eae:	38650513          	addi	a0,a0,902 # 80008230 <digits+0x1c8>
    80001eb2:	ffffe097          	auipc	ra,0xffffe
    80001eb6:	784080e7          	jalr	1924(ra) # 80000636 <printf>
        return -1;
    80001eba:	557d                	li	a0,-1
    80001ebc:	b749                	j	80001e3e <munmap+0x9c>
      uvmunmap(p->pagetable, PGROUNDDOWN((uint64)cur), 1, 1);
    80001ebe:	4685                	li	a3,1
    80001ec0:	4605                	li	a2,1
    80001ec2:	85de                	mv	a1,s7
    80001ec4:	050ab503          	ld	a0,80(s5)
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	52a080e7          	jalr	1322(ra) # 800013f2 <uvmunmap>
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001ed0:	995a                	add	s2,s2,s6
    80001ed2:	07a97363          	bgeu	s2,s10,80001f38 <munmap+0x196>
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    80001ed6:	f9243023          	sd	s2,-128(s0)
    80001eda:	4601                	li	a2,0
    80001edc:	85ca                	mv	a1,s2
    80001ede:	050ab503          	ld	a0,80(s5)
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	23c080e7          	jalr	572(ra) # 8000111e <walk>
    80001eea:	8a2a                	mv	s4,a0
    if (!pte)
    80001eec:	d175                	beqz	a0,80001ed0 <munmap+0x12e>
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    80001eee:	01b97bb3          	and	s7,s2,s11
    80001ef2:	412b87b3          	sub	a5,s7,s2
    80001ef6:	97e6                	add	a5,a5,s9
    80001ef8:	00f9f363          	bgeu	s3,a5,80001efe <munmap+0x15c>
    80001efc:	87ce                	mv	a5,s3
    80001efe:	00078b1b          	sext.w	s6,a5
    left -= should_write;
    80001f02:	40f989bb          	subw	s3,s3,a5
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
    80001f06:	194c2783          	lw	a5,404(s8)
    80001f0a:	8b85                	andi	a5,a5,1
    80001f0c:	c791                	beqz	a5,80001f18 <munmap+0x176>
    80001f0e:	000a3783          	ld	a5,0(s4) # 1000 <_entry-0x7ffff000>
    80001f12:	0807f793          	andi	a5,a5,128
    80001f16:	f3bd                	bnez	a5,80001e7c <munmap+0xda>
    if ((*pte & PTE_V) &&
    80001f18:	000a3783          	ld	a5,0(s4)
    80001f1c:	8b85                	andi	a5,a5,1
    80001f1e:	dbcd                	beqz	a5,80001ed0 <munmap+0x12e>
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
    80001f20:	f8043783          	ld	a5,-128(s0)
    80001f24:	97da                	add	a5,a5,s6
    80001f26:	019b8733          	add	a4,s7,s9
    if ((*pte & PTE_V) &&
    80001f2a:	f8e78ae3          	beq	a5,a4,80001ebe <munmap+0x11c>
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
    80001f2e:	188c3783          	ld	a5,392(s8)
    80001f32:	f8fb1fe3          	bne	s6,a5,80001ed0 <munmap+0x12e>
    80001f36:	b761                	j	80001ebe <munmap+0x11c>
  if (length == vma->length) {
    80001f38:	00349793          	slli	a5,s1,0x3
    80001f3c:	8f85                	sub	a5,a5,s1
    80001f3e:	078e                	slli	a5,a5,0x3
    80001f40:	97d6                	add	a5,a5,s5
    80001f42:	1887b683          	ld	a3,392(a5)
    80001f46:	f7843783          	ld	a5,-136(s0)
    80001f4a:	02d78463          	beq	a5,a3,80001f72 <munmap+0x1d0>
    vma->start += length;
    80001f4e:	00349793          	slli	a5,s1,0x3
    80001f52:	40978733          	sub	a4,a5,s1
    80001f56:	070e                	slli	a4,a4,0x3
    80001f58:	9756                	add	a4,a4,s5
    80001f5a:	17873603          	ld	a2,376(a4) # 1178 <_entry-0x7fffee88>
    80001f5e:	f8843583          	ld	a1,-120(s0)
    80001f62:	962e                	add	a2,a2,a1
    80001f64:	16c73c23          	sd	a2,376(a4)
    vma->length -= length;
    80001f68:	8e8d                	sub	a3,a3,a1
    80001f6a:	18d73423          	sd	a3,392(a4)
  return 0;
    80001f6e:	4501                	li	a0,0
    80001f70:	b5f9                	j	80001e3e <munmap+0x9c>
    if (!(vma->flag & MAP_ANNO))
    80001f72:	00349793          	slli	a5,s1,0x3
    80001f76:	8f85                	sub	a5,a5,s1
    80001f78:	078e                	slli	a5,a5,0x3
    80001f7a:	97d6                	add	a5,a5,s5
    80001f7c:	1947a783          	lw	a5,404(a5)
    80001f80:	8b91                	andi	a5,a5,4
    80001f82:	cb85                	beqz	a5,80001fb2 <munmap+0x210>
      vma = &p->vma[i];
    80001f84:	00349913          	slli	s2,s1,0x3
    80001f88:	40990533          	sub	a0,s2,s1
    80001f8c:	050e                	slli	a0,a0,0x3
    80001f8e:	17850513          	addi	a0,a0,376
    memset(vma, 0, sizeof(*vma));
    80001f92:	03800613          	li	a2,56
    80001f96:	4581                	li	a1,0
    80001f98:	9556                	add	a0,a0,s5
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	e9c080e7          	jalr	-356(ra) # 80000e36 <memset>
    vma->used = 0;
    80001fa2:	409907b3          	sub	a5,s2,s1
    80001fa6:	078e                	slli	a5,a5,0x3
    80001fa8:	9abe                	add	s5,s5,a5
    80001faa:	1a0a8423          	sb	zero,424(s5)
  return 0;
    80001fae:	4501                	li	a0,0
    80001fb0:	b579                	j	80001e3e <munmap+0x9c>
      fileclose(vma->mmaped_file);
    80001fb2:	00349793          	slli	a5,s1,0x3
    80001fb6:	8f85                	sub	a5,a5,s1
    80001fb8:	078e                	slli	a5,a5,0x3
    80001fba:	97d6                	add	a5,a5,s5
    80001fbc:	1a07b503          	ld	a0,416(a5)
    80001fc0:	00003097          	auipc	ra,0x3
    80001fc4:	e12080e7          	jalr	-494(ra) # 80004dd2 <fileclose>
    80001fc8:	bf75                	j	80001f84 <munmap+0x1e2>

0000000080001fca <wakeup1>:
  }
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void wakeup1(struct proc *p) {
    80001fca:	1101                	addi	sp,sp,-32
    80001fcc:	ec06                	sd	ra,24(sp)
    80001fce:	e822                	sd	s0,16(sp)
    80001fd0:	e426                	sd	s1,8(sp)
    80001fd2:	1000                	addi	s0,sp,32
    80001fd4:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	cea080e7          	jalr	-790(ra) # 80000cc0 <holding>
    80001fde:	c909                	beqz	a0,80001ff0 <wakeup1+0x26>
    panic("wakeup1");
  if (p->chan == p && p->state == SLEEPING) {
    80001fe0:	749c                	ld	a5,40(s1)
    80001fe2:	00978f63          	beq	a5,s1,80002000 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001fe6:	60e2                	ld	ra,24(sp)
    80001fe8:	6442                	ld	s0,16(sp)
    80001fea:	64a2                	ld	s1,8(sp)
    80001fec:	6105                	addi	sp,sp,32
    80001fee:	8082                	ret
    panic("wakeup1");
    80001ff0:	00006517          	auipc	a0,0x6
    80001ff4:	27050513          	addi	a0,a0,624 # 80008260 <digits+0x1f8>
    80001ff8:	ffffe097          	auipc	ra,0xffffe
    80001ffc:	5ec080e7          	jalr	1516(ra) # 800005e4 <panic>
  if (p->chan == p && p->state == SLEEPING) {
    80002000:	4c98                	lw	a4,24(s1)
    80002002:	4785                	li	a5,1
    80002004:	fef711e3          	bne	a4,a5,80001fe6 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80002008:	4789                	li	a5,2
    8000200a:	cc9c                	sw	a5,24(s1)
}
    8000200c:	bfe9                	j	80001fe6 <wakeup1+0x1c>

000000008000200e <procinit>:
void procinit(void) {
    8000200e:	715d                	addi	sp,sp,-80
    80002010:	e486                	sd	ra,72(sp)
    80002012:	e0a2                	sd	s0,64(sp)
    80002014:	fc26                	sd	s1,56(sp)
    80002016:	f84a                	sd	s2,48(sp)
    80002018:	f44e                	sd	s3,40(sp)
    8000201a:	f052                	sd	s4,32(sp)
    8000201c:	ec56                	sd	s5,24(sp)
    8000201e:	e85a                	sd	s6,16(sp)
    80002020:	e45e                	sd	s7,8(sp)
    80002022:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80002024:	00006597          	auipc	a1,0x6
    80002028:	24458593          	addi	a1,a1,580 # 80008268 <digits+0x200>
    8000202c:	00030517          	auipc	a0,0x30
    80002030:	93450513          	addi	a0,a0,-1740 # 80031960 <pid_lock>
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	c76080e7          	jalr	-906(ra) # 80000caa <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000203c:	00030917          	auipc	s2,0x30
    80002040:	d3c90913          	addi	s2,s2,-708 # 80031d78 <proc>
    initlock(&p->lock, "proc");
    80002044:	00006b97          	auipc	s7,0x6
    80002048:	22cb8b93          	addi	s7,s7,556 # 80008270 <digits+0x208>
    uint64 va = KSTACK((int)(p - proc));
    8000204c:	8b4a                	mv	s6,s2
    8000204e:	00006a97          	auipc	s5,0x6
    80002052:	fb2a8a93          	addi	s5,s5,-78 # 80008000 <etext>
    80002056:	040009b7          	lui	s3,0x4000
    8000205a:	19fd                	addi	s3,s3,-1
    8000205c:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000205e:	00044a17          	auipc	s4,0x44
    80002062:	b1aa0a13          	addi	s4,s4,-1254 # 80045b78 <tickslock>
    initlock(&p->lock, "proc");
    80002066:	85de                	mv	a1,s7
    80002068:	854a                	mv	a0,s2
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	c40080e7          	jalr	-960(ra) # 80000caa <initlock>
    char *pa = kalloc();
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	b8a080e7          	jalr	-1142(ra) # 80000bfc <kalloc>
    8000207a:	85aa                	mv	a1,a0
    if (pa == 0)
    8000207c:	c929                	beqz	a0,800020ce <procinit+0xc0>
    uint64 va = KSTACK((int)(p - proc));
    8000207e:	416904b3          	sub	s1,s2,s6
    80002082:	848d                	srai	s1,s1,0x3
    80002084:	000ab783          	ld	a5,0(s5)
    80002088:	02f484b3          	mul	s1,s1,a5
    8000208c:	2485                	addiw	s1,s1,1
    8000208e:	00d4949b          	slliw	s1,s1,0xd
    80002092:	409984b3          	sub	s1,s3,s1
    kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80002096:	4699                	li	a3,6
    80002098:	6605                	lui	a2,0x1
    8000209a:	8526                	mv	a0,s1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	24c080e7          	jalr	588(ra) # 800012e8 <kvmmap>
    p->kstack = va;
    800020a4:	04993023          	sd	s1,64(s2)
  for (p = proc; p < &proc[NPROC]; p++) {
    800020a8:	4f890913          	addi	s2,s2,1272
    800020ac:	fb491de3          	bne	s2,s4,80002066 <procinit+0x58>
  kvminithart();
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	04a080e7          	jalr	74(ra) # 800010fa <kvminithart>
}
    800020b8:	60a6                	ld	ra,72(sp)
    800020ba:	6406                	ld	s0,64(sp)
    800020bc:	74e2                	ld	s1,56(sp)
    800020be:	7942                	ld	s2,48(sp)
    800020c0:	79a2                	ld	s3,40(sp)
    800020c2:	7a02                	ld	s4,32(sp)
    800020c4:	6ae2                	ld	s5,24(sp)
    800020c6:	6b42                	ld	s6,16(sp)
    800020c8:	6ba2                	ld	s7,8(sp)
    800020ca:	6161                	addi	sp,sp,80
    800020cc:	8082                	ret
      panic("kalloc");
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	1aa50513          	addi	a0,a0,426 # 80008278 <digits+0x210>
    800020d6:	ffffe097          	auipc	ra,0xffffe
    800020da:	50e080e7          	jalr	1294(ra) # 800005e4 <panic>

00000000800020de <cpuid>:
int cpuid() {
    800020de:	1141                	addi	sp,sp,-16
    800020e0:	e422                	sd	s0,8(sp)
    800020e2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800020e4:	8512                	mv	a0,tp
}
    800020e6:	2501                	sext.w	a0,a0
    800020e8:	6422                	ld	s0,8(sp)
    800020ea:	0141                	addi	sp,sp,16
    800020ec:	8082                	ret

00000000800020ee <mycpu>:
struct cpu *mycpu(void) {
    800020ee:	1141                	addi	sp,sp,-16
    800020f0:	e422                	sd	s0,8(sp)
    800020f2:	0800                	addi	s0,sp,16
    800020f4:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800020f6:	2781                	sext.w	a5,a5
    800020f8:	079e                	slli	a5,a5,0x7
}
    800020fa:	00030517          	auipc	a0,0x30
    800020fe:	87e50513          	addi	a0,a0,-1922 # 80031978 <cpus>
    80002102:	953e                	add	a0,a0,a5
    80002104:	6422                	ld	s0,8(sp)
    80002106:	0141                	addi	sp,sp,16
    80002108:	8082                	ret

000000008000210a <myproc>:
struct proc *myproc(void) {
    8000210a:	1101                	addi	sp,sp,-32
    8000210c:	ec06                	sd	ra,24(sp)
    8000210e:	e822                	sd	s0,16(sp)
    80002110:	e426                	sd	s1,8(sp)
    80002112:	1000                	addi	s0,sp,32
  push_off();
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	bda080e7          	jalr	-1062(ra) # 80000cee <push_off>
    8000211c:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    8000211e:	2781                	sext.w	a5,a5
    80002120:	079e                	slli	a5,a5,0x7
    80002122:	00030717          	auipc	a4,0x30
    80002126:	83e70713          	addi	a4,a4,-1986 # 80031960 <pid_lock>
    8000212a:	97ba                	add	a5,a5,a4
    8000212c:	6f84                	ld	s1,24(a5)
  pop_off();
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	c60080e7          	jalr	-928(ra) # 80000d8e <pop_off>
}
    80002136:	8526                	mv	a0,s1
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <forkret>:
void forkret(void) {
    80002142:	1141                	addi	sp,sp,-16
    80002144:	e406                	sd	ra,8(sp)
    80002146:	e022                	sd	s0,0(sp)
    80002148:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	fc0080e7          	jalr	-64(ra) # 8000210a <myproc>
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	c9c080e7          	jalr	-868(ra) # 80000dee <release>
  if (first) {
    8000215a:	00007797          	auipc	a5,0x7
    8000215e:	8567a783          	lw	a5,-1962(a5) # 800089b0 <first.1>
    80002162:	eb89                	bnez	a5,80002174 <forkret+0x32>
  usertrapret();
    80002164:	00001097          	auipc	ra,0x1
    80002168:	c84080e7          	jalr	-892(ra) # 80002de8 <usertrapret>
}
    8000216c:	60a2                	ld	ra,8(sp)
    8000216e:	6402                	ld	s0,0(sp)
    80002170:	0141                	addi	sp,sp,16
    80002172:	8082                	ret
    first = 0;
    80002174:	00007797          	auipc	a5,0x7
    80002178:	8207ae23          	sw	zero,-1988(a5) # 800089b0 <first.1>
    fsinit(ROOTDEV);
    8000217c:	4505                	li	a0,1
    8000217e:	00002097          	auipc	ra,0x2
    80002182:	b4a080e7          	jalr	-1206(ra) # 80003cc8 <fsinit>
    80002186:	bff9                	j	80002164 <forkret+0x22>

0000000080002188 <allocpid>:
int allocpid() {
    80002188:	1101                	addi	sp,sp,-32
    8000218a:	ec06                	sd	ra,24(sp)
    8000218c:	e822                	sd	s0,16(sp)
    8000218e:	e426                	sd	s1,8(sp)
    80002190:	e04a                	sd	s2,0(sp)
    80002192:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80002194:	0002f917          	auipc	s2,0x2f
    80002198:	7cc90913          	addi	s2,s2,1996 # 80031960 <pid_lock>
    8000219c:	854a                	mv	a0,s2
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	b9c080e7          	jalr	-1124(ra) # 80000d3a <acquire>
  pid = nextpid;
    800021a6:	00007797          	auipc	a5,0x7
    800021aa:	80e78793          	addi	a5,a5,-2034 # 800089b4 <nextpid>
    800021ae:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800021b0:	0014871b          	addiw	a4,s1,1
    800021b4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800021b6:	854a                	mv	a0,s2
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	c36080e7          	jalr	-970(ra) # 80000dee <release>
}
    800021c0:	8526                	mv	a0,s1
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	64a2                	ld	s1,8(sp)
    800021c8:	6902                	ld	s2,0(sp)
    800021ca:	6105                	addi	sp,sp,32
    800021cc:	8082                	ret

00000000800021ce <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    800021ce:	1101                	addi	sp,sp,-32
    800021d0:	ec06                	sd	ra,24(sp)
    800021d2:	e822                	sd	s0,16(sp)
    800021d4:	e426                	sd	s1,8(sp)
    800021d6:	e04a                	sd	s2,0(sp)
    800021d8:	1000                	addi	s0,sp,32
    800021da:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	2bc080e7          	jalr	700(ra) # 80001498 <uvmcreate>
    800021e4:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800021e6:	c121                	beqz	a0,80002226 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800021e8:	4729                	li	a4,10
    800021ea:	00005697          	auipc	a3,0x5
    800021ee:	e1668693          	addi	a3,a3,-490 # 80007000 <_trampoline>
    800021f2:	6605                	lui	a2,0x1
    800021f4:	040005b7          	lui	a1,0x4000
    800021f8:	15fd                	addi	a1,a1,-1
    800021fa:	05b2                	slli	a1,a1,0xc
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	05e080e7          	jalr	94(ra) # 8000125a <mappages>
    80002204:	02054863          	bltz	a0,80002234 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80002208:	4719                	li	a4,6
    8000220a:	05893683          	ld	a3,88(s2)
    8000220e:	6605                	lui	a2,0x1
    80002210:	020005b7          	lui	a1,0x2000
    80002214:	15fd                	addi	a1,a1,-1
    80002216:	05b6                	slli	a1,a1,0xd
    80002218:	8526                	mv	a0,s1
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	040080e7          	jalr	64(ra) # 8000125a <mappages>
    80002222:	02054163          	bltz	a0,80002244 <proc_pagetable+0x76>
}
    80002226:	8526                	mv	a0,s1
    80002228:	60e2                	ld	ra,24(sp)
    8000222a:	6442                	ld	s0,16(sp)
    8000222c:	64a2                	ld	s1,8(sp)
    8000222e:	6902                	ld	s2,0(sp)
    80002230:	6105                	addi	sp,sp,32
    80002232:	8082                	ret
    uvmfree(pagetable, 0);
    80002234:	4581                	li	a1,0
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	44a080e7          	jalr	1098(ra) # 80001682 <uvmfree>
    return 0;
    80002240:	4481                	li	s1,0
    80002242:	b7d5                	j	80002226 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002244:	4681                	li	a3,0
    80002246:	4605                	li	a2,1
    80002248:	040005b7          	lui	a1,0x4000
    8000224c:	15fd                	addi	a1,a1,-1
    8000224e:	05b2                	slli	a1,a1,0xc
    80002250:	8526                	mv	a0,s1
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	1a0080e7          	jalr	416(ra) # 800013f2 <uvmunmap>
    uvmfree(pagetable, 0);
    8000225a:	4581                	li	a1,0
    8000225c:	8526                	mv	a0,s1
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	424080e7          	jalr	1060(ra) # 80001682 <uvmfree>
    return 0;
    80002266:	4481                	li	s1,0
    80002268:	bf7d                	j	80002226 <proc_pagetable+0x58>

000000008000226a <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    8000226a:	1101                	addi	sp,sp,-32
    8000226c:	ec06                	sd	ra,24(sp)
    8000226e:	e822                	sd	s0,16(sp)
    80002270:	e426                	sd	s1,8(sp)
    80002272:	e04a                	sd	s2,0(sp)
    80002274:	1000                	addi	s0,sp,32
    80002276:	84aa                	mv	s1,a0
    80002278:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000227a:	4681                	li	a3,0
    8000227c:	4605                	li	a2,1
    8000227e:	040005b7          	lui	a1,0x4000
    80002282:	15fd                	addi	a1,a1,-1
    80002284:	05b2                	slli	a1,a1,0xc
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	16c080e7          	jalr	364(ra) # 800013f2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000228e:	4681                	li	a3,0
    80002290:	4605                	li	a2,1
    80002292:	020005b7          	lui	a1,0x2000
    80002296:	15fd                	addi	a1,a1,-1
    80002298:	05b6                	slli	a1,a1,0xd
    8000229a:	8526                	mv	a0,s1
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	156080e7          	jalr	342(ra) # 800013f2 <uvmunmap>
  uvmfree(pagetable, sz);
    800022a4:	85ca                	mv	a1,s2
    800022a6:	8526                	mv	a0,s1
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	3da080e7          	jalr	986(ra) # 80001682 <uvmfree>
}
    800022b0:	60e2                	ld	ra,24(sp)
    800022b2:	6442                	ld	s0,16(sp)
    800022b4:	64a2                	ld	s1,8(sp)
    800022b6:	6902                	ld	s2,0(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <freeproc>:
static void freeproc(struct proc *p) {
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	e426                	sd	s1,8(sp)
    800022c4:	1000                	addi	s0,sp,32
    800022c6:	84aa                	mv	s1,a0
  if (p->trapframe)
    800022c8:	6d28                	ld	a0,88(a0)
    800022ca:	c509                	beqz	a0,800022d4 <freeproc+0x18>
    kfree((void *)p->trapframe);
    800022cc:	ffffe097          	auipc	ra,0xffffe
    800022d0:	7be080e7          	jalr	1982(ra) # 80000a8a <kfree>
  p->trapframe = 0;
    800022d4:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    800022d8:	68a8                	ld	a0,80(s1)
    800022da:	c511                	beqz	a0,800022e6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800022dc:	64ac                	ld	a1,72(s1)
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	f8c080e7          	jalr	-116(ra) # 8000226a <proc_freepagetable>
  p->pagetable = 0;
    800022e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800022ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800022ee:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800022f2:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    800022f6:	14048823          	sb	zero,336(s1)
  p->chan = 0;
    800022fa:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800022fe:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80002302:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80002306:	0004ac23          	sw	zero,24(s1)
}
    8000230a:	60e2                	ld	ra,24(sp)
    8000230c:	6442                	ld	s0,16(sp)
    8000230e:	64a2                	ld	s1,8(sp)
    80002310:	6105                	addi	sp,sp,32
    80002312:	8082                	ret

0000000080002314 <allocproc>:
static struct proc *allocproc(void) {
    80002314:	1101                	addi	sp,sp,-32
    80002316:	ec06                	sd	ra,24(sp)
    80002318:	e822                	sd	s0,16(sp)
    8000231a:	e426                	sd	s1,8(sp)
    8000231c:	e04a                	sd	s2,0(sp)
    8000231e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80002320:	00030497          	auipc	s1,0x30
    80002324:	a5848493          	addi	s1,s1,-1448 # 80031d78 <proc>
    80002328:	00044917          	auipc	s2,0x44
    8000232c:	85090913          	addi	s2,s2,-1968 # 80045b78 <tickslock>
    acquire(&p->lock);
    80002330:	8526                	mv	a0,s1
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	a08080e7          	jalr	-1528(ra) # 80000d3a <acquire>
    if (p->state == UNUSED) {
    8000233a:	4c9c                	lw	a5,24(s1)
    8000233c:	cf81                	beqz	a5,80002354 <allocproc+0x40>
      release(&p->lock);
    8000233e:	8526                	mv	a0,s1
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	aae080e7          	jalr	-1362(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002348:	4f848493          	addi	s1,s1,1272
    8000234c:	ff2492e3          	bne	s1,s2,80002330 <allocproc+0x1c>
  return 0;
    80002350:	4481                	li	s1,0
    80002352:	a049                	j	800023d4 <allocproc+0xc0>
  p->pid = allocpid();
    80002354:	00000097          	auipc	ra,0x0
    80002358:	e34080e7          	jalr	-460(ra) # 80002188 <allocpid>
    8000235c:	dc88                	sw	a0,56(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    8000235e:	fffff097          	auipc	ra,0xfffff
    80002362:	89e080e7          	jalr	-1890(ra) # 80000bfc <kalloc>
    80002366:	892a                	mv	s2,a0
    80002368:	eca8                	sd	a0,88(s1)
    8000236a:	cd25                	beqz	a0,800023e2 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    8000236c:	8526                	mv	a0,s1
    8000236e:	00000097          	auipc	ra,0x0
    80002372:	e60080e7          	jalr	-416(ra) # 800021ce <proc_pagetable>
    80002376:	892a                	mv	s2,a0
    80002378:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    8000237a:	c93d                	beqz	a0,800023f0 <allocproc+0xdc>
    p->vma[0].used = 1;
    8000237c:	4785                	li	a5,1
    8000237e:	1af48423          	sb	a5,424(s1)
    p->vma[0].length = VMA_ORIGIN - VMA_HEAP_START;
    80002382:	02279713          	slli	a4,a5,0x22
    80002386:	18e4b423          	sd	a4,392(s1)
    p->vma[0].proct = PROT_READ | PROT_WRITE;
    8000238a:	470d                	li	a4,3
    8000238c:	18e4a823          	sw	a4,400(s1)
    p->vma[0].offset = 0;
    80002390:	1804ac23          	sw	zero,408(s1)
    p->vma[0].flag = MAP_PRIVATE | MAP_ANNO;
    80002394:	4719                	li	a4,6
    80002396:	18e4aa23          	sw	a4,404(s1)
    p->vma[0].start = (void *)VMA_HEAP_START;
    8000239a:	1782                	slli	a5,a5,0x20
    8000239c:	16f4bc23          	sd	a5,376(s1)
    p->vma[0].origin = (void *)VMA_HEAP_START;
    800023a0:	18f4b023          	sd	a5,384(s1)
  p->mem_layout.heap_start = (void *)VMA_HEAP_START;
    800023a4:	16f4b423          	sd	a5,360(s1)
  p->mem_layout.heap_size = VMA_ORIGIN - VMA_HEAP;
    800023a8:	4795                	li	a5,5
    800023aa:	1782                	slli	a5,a5,0x20
    800023ac:	16f4b823          	sd	a5,368(s1)
  memset(&p->context, 0, sizeof(p->context));
    800023b0:	07000613          	li	a2,112
    800023b4:	4581                	li	a1,0
    800023b6:	06048513          	addi	a0,s1,96
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	a7c080e7          	jalr	-1412(ra) # 80000e36 <memset>
  p->context.ra = (uint64)forkret;
    800023c2:	00000797          	auipc	a5,0x0
    800023c6:	d8078793          	addi	a5,a5,-640 # 80002142 <forkret>
    800023ca:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800023cc:	60bc                	ld	a5,64(s1)
    800023ce:	6705                	lui	a4,0x1
    800023d0:	97ba                	add	a5,a5,a4
    800023d2:	f4bc                	sd	a5,104(s1)
}
    800023d4:	8526                	mv	a0,s1
    800023d6:	60e2                	ld	ra,24(sp)
    800023d8:	6442                	ld	s0,16(sp)
    800023da:	64a2                	ld	s1,8(sp)
    800023dc:	6902                	ld	s2,0(sp)
    800023de:	6105                	addi	sp,sp,32
    800023e0:	8082                	ret
    release(&p->lock);
    800023e2:	8526                	mv	a0,s1
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	a0a080e7          	jalr	-1526(ra) # 80000dee <release>
    return 0;
    800023ec:	84ca                	mv	s1,s2
    800023ee:	b7dd                	j	800023d4 <allocproc+0xc0>
    freeproc(p);
    800023f0:	8526                	mv	a0,s1
    800023f2:	00000097          	auipc	ra,0x0
    800023f6:	eca080e7          	jalr	-310(ra) # 800022bc <freeproc>
    release(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	9f2080e7          	jalr	-1550(ra) # 80000dee <release>
    return 0;
    80002404:	84ca                	mv	s1,s2
    80002406:	b7f9                	j	800023d4 <allocproc+0xc0>

0000000080002408 <userinit>:
void userinit(void) {
    80002408:	1101                	addi	sp,sp,-32
    8000240a:	ec06                	sd	ra,24(sp)
    8000240c:	e822                	sd	s0,16(sp)
    8000240e:	e426                	sd	s1,8(sp)
    80002410:	1000                	addi	s0,sp,32
  p = allocproc();
    80002412:	00000097          	auipc	ra,0x0
    80002416:	f02080e7          	jalr	-254(ra) # 80002314 <allocproc>
    8000241a:	84aa                	mv	s1,a0
  initproc = p;
    8000241c:	00007797          	auipc	a5,0x7
    80002420:	bea7be23          	sd	a0,-1028(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80002424:	03400613          	li	a2,52
    80002428:	00006597          	auipc	a1,0x6
    8000242c:	59858593          	addi	a1,a1,1432 # 800089c0 <initcode>
    80002430:	6928                	ld	a0,80(a0)
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	094080e7          	jalr	148(ra) # 800014c6 <uvminit>
  p->sz = PGSIZE;
    8000243a:	6785                	lui	a5,0x1
    8000243c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    8000243e:	6cb8                	ld	a4,88(s1)
    80002440:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80002444:	6cb8                	ld	a4,88(s1)
    80002446:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002448:	4641                	li	a2,16
    8000244a:	00006597          	auipc	a1,0x6
    8000244e:	e3658593          	addi	a1,a1,-458 # 80008280 <digits+0x218>
    80002452:	15048513          	addi	a0,s1,336
    80002456:	fffff097          	auipc	ra,0xfffff
    8000245a:	b32080e7          	jalr	-1230(ra) # 80000f88 <safestrcpy>
  p->cwd = namei("/");
    8000245e:	00006517          	auipc	a0,0x6
    80002462:	e3250513          	addi	a0,a0,-462 # 80008290 <digits+0x228>
    80002466:	00002097          	auipc	ra,0x2
    8000246a:	28e080e7          	jalr	654(ra) # 800046f4 <namei>
    8000246e:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80002472:	4789                	li	a5,2
    80002474:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002476:	8526                	mv	a0,s1
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	976080e7          	jalr	-1674(ra) # 80000dee <release>
}
    80002480:	60e2                	ld	ra,24(sp)
    80002482:	6442                	ld	s0,16(sp)
    80002484:	64a2                	ld	s1,8(sp)
    80002486:	6105                	addi	sp,sp,32
    80002488:	8082                	ret

000000008000248a <growproc>:
int growproc(int n) {
    8000248a:	1101                	addi	sp,sp,-32
    8000248c:	ec06                	sd	ra,24(sp)
    8000248e:	e822                	sd	s0,16(sp)
    80002490:	e426                	sd	s1,8(sp)
    80002492:	e04a                	sd	s2,0(sp)
    80002494:	1000                	addi	s0,sp,32
    80002496:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002498:	00000097          	auipc	ra,0x0
    8000249c:	c72080e7          	jalr	-910(ra) # 8000210a <myproc>
    800024a0:	892a                	mv	s2,a0
  sz = p->sz;
    800024a2:	652c                	ld	a1,72(a0)
    800024a4:	0005861b          	sext.w	a2,a1
  if (n > 0) {
    800024a8:	00904f63          	bgtz	s1,800024c6 <growproc+0x3c>
  } else if (n < 0) {
    800024ac:	0204cc63          	bltz	s1,800024e4 <growproc+0x5a>
  p->sz = sz;
    800024b0:	1602                	slli	a2,a2,0x20
    800024b2:	9201                	srli	a2,a2,0x20
    800024b4:	04c93423          	sd	a2,72(s2)
  return 0;
    800024b8:	4501                	li	a0,0
}
    800024ba:	60e2                	ld	ra,24(sp)
    800024bc:	6442                	ld	s0,16(sp)
    800024be:	64a2                	ld	s1,8(sp)
    800024c0:	6902                	ld	s2,0(sp)
    800024c2:	6105                	addi	sp,sp,32
    800024c4:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800024c6:	9e25                	addw	a2,a2,s1
    800024c8:	1602                	slli	a2,a2,0x20
    800024ca:	9201                	srli	a2,a2,0x20
    800024cc:	1582                	slli	a1,a1,0x20
    800024ce:	9181                	srli	a1,a1,0x20
    800024d0:	6928                	ld	a0,80(a0)
    800024d2:	fffff097          	auipc	ra,0xfffff
    800024d6:	0ae080e7          	jalr	174(ra) # 80001580 <uvmalloc>
    800024da:	0005061b          	sext.w	a2,a0
    800024de:	fa69                	bnez	a2,800024b0 <growproc+0x26>
      return -1;
    800024e0:	557d                	li	a0,-1
    800024e2:	bfe1                	j	800024ba <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800024e4:	9e25                	addw	a2,a2,s1
    800024e6:	1602                	slli	a2,a2,0x20
    800024e8:	9201                	srli	a2,a2,0x20
    800024ea:	1582                	slli	a1,a1,0x20
    800024ec:	9181                	srli	a1,a1,0x20
    800024ee:	6928                	ld	a0,80(a0)
    800024f0:	fffff097          	auipc	ra,0xfffff
    800024f4:	048080e7          	jalr	72(ra) # 80001538 <uvmdealloc>
    800024f8:	0005061b          	sext.w	a2,a0
    800024fc:	bf55                	j	800024b0 <growproc+0x26>

00000000800024fe <fork>:
int fork(void) {
    800024fe:	7139                	addi	sp,sp,-64
    80002500:	fc06                	sd	ra,56(sp)
    80002502:	f822                	sd	s0,48(sp)
    80002504:	f426                	sd	s1,40(sp)
    80002506:	f04a                	sd	s2,32(sp)
    80002508:	ec4e                	sd	s3,24(sp)
    8000250a:	e852                	sd	s4,16(sp)
    8000250c:	e456                	sd	s5,8(sp)
    8000250e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002510:	00000097          	auipc	ra,0x0
    80002514:	bfa080e7          	jalr	-1030(ra) # 8000210a <myproc>
    80002518:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    8000251a:	00000097          	auipc	ra,0x0
    8000251e:	dfa080e7          	jalr	-518(ra) # 80002314 <allocproc>
    80002522:	c17d                	beqz	a0,80002608 <fork+0x10a>
    80002524:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80002526:	048ab603          	ld	a2,72(s5)
    8000252a:	692c                	ld	a1,80(a0)
    8000252c:	050ab503          	ld	a0,80(s5)
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	18a080e7          	jalr	394(ra) # 800016ba <uvmcopy>
    80002538:	04054a63          	bltz	a0,8000258c <fork+0x8e>
  np->sz = p->sz;
    8000253c:	048ab783          	ld	a5,72(s5)
    80002540:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80002544:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80002548:	058ab683          	ld	a3,88(s5)
    8000254c:	87b6                	mv	a5,a3
    8000254e:	058a3703          	ld	a4,88(s4)
    80002552:	12068693          	addi	a3,a3,288
    80002556:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000255a:	6788                	ld	a0,8(a5)
    8000255c:	6b8c                	ld	a1,16(a5)
    8000255e:	6f90                	ld	a2,24(a5)
    80002560:	01073023          	sd	a6,0(a4)
    80002564:	e708                	sd	a0,8(a4)
    80002566:	eb0c                	sd	a1,16(a4)
    80002568:	ef10                	sd	a2,24(a4)
    8000256a:	02078793          	addi	a5,a5,32
    8000256e:	02070713          	addi	a4,a4,32
    80002572:	fed792e3          	bne	a5,a3,80002556 <fork+0x58>
  np->trapframe->a0 = 0;
    80002576:	058a3783          	ld	a5,88(s4)
    8000257a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000257e:	0d0a8493          	addi	s1,s5,208
    80002582:	0d0a0913          	addi	s2,s4,208
    80002586:	150a8993          	addi	s3,s5,336
    8000258a:	a00d                	j	800025ac <fork+0xae>
    freeproc(np);
    8000258c:	8552                	mv	a0,s4
    8000258e:	00000097          	auipc	ra,0x0
    80002592:	d2e080e7          	jalr	-722(ra) # 800022bc <freeproc>
    release(&np->lock);
    80002596:	8552                	mv	a0,s4
    80002598:	fffff097          	auipc	ra,0xfffff
    8000259c:	856080e7          	jalr	-1962(ra) # 80000dee <release>
    return -1;
    800025a0:	54fd                	li	s1,-1
    800025a2:	a889                	j	800025f4 <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
    800025a4:	04a1                	addi	s1,s1,8
    800025a6:	0921                	addi	s2,s2,8
    800025a8:	01348b63          	beq	s1,s3,800025be <fork+0xc0>
    if (p->ofile[i])
    800025ac:	6088                	ld	a0,0(s1)
    800025ae:	d97d                	beqz	a0,800025a4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800025b0:	00002097          	auipc	ra,0x2
    800025b4:	7d0080e7          	jalr	2000(ra) # 80004d80 <filedup>
    800025b8:	00a93023          	sd	a0,0(s2)
    800025bc:	b7e5                	j	800025a4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800025be:	160ab503          	ld	a0,352(s5)
    800025c2:	00002097          	auipc	ra,0x2
    800025c6:	940080e7          	jalr	-1728(ra) # 80003f02 <idup>
    800025ca:	16aa3023          	sd	a0,352(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800025ce:	4641                	li	a2,16
    800025d0:	150a8593          	addi	a1,s5,336
    800025d4:	150a0513          	addi	a0,s4,336
    800025d8:	fffff097          	auipc	ra,0xfffff
    800025dc:	9b0080e7          	jalr	-1616(ra) # 80000f88 <safestrcpy>
  pid = np->pid;
    800025e0:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    800025e4:	4789                	li	a5,2
    800025e6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800025ea:	8552                	mv	a0,s4
    800025ec:	fffff097          	auipc	ra,0xfffff
    800025f0:	802080e7          	jalr	-2046(ra) # 80000dee <release>
}
    800025f4:	8526                	mv	a0,s1
    800025f6:	70e2                	ld	ra,56(sp)
    800025f8:	7442                	ld	s0,48(sp)
    800025fa:	74a2                	ld	s1,40(sp)
    800025fc:	7902                	ld	s2,32(sp)
    800025fe:	69e2                	ld	s3,24(sp)
    80002600:	6a42                	ld	s4,16(sp)
    80002602:	6aa2                	ld	s5,8(sp)
    80002604:	6121                	addi	sp,sp,64
    80002606:	8082                	ret
    return -1;
    80002608:	54fd                	li	s1,-1
    8000260a:	b7ed                	j	800025f4 <fork+0xf6>

000000008000260c <reparent>:
void reparent(struct proc *p) {
    8000260c:	7179                	addi	sp,sp,-48
    8000260e:	f406                	sd	ra,40(sp)
    80002610:	f022                	sd	s0,32(sp)
    80002612:	ec26                	sd	s1,24(sp)
    80002614:	e84a                	sd	s2,16(sp)
    80002616:	e44e                	sd	s3,8(sp)
    80002618:	e052                	sd	s4,0(sp)
    8000261a:	1800                	addi	s0,sp,48
    8000261c:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000261e:	0002f497          	auipc	s1,0x2f
    80002622:	75a48493          	addi	s1,s1,1882 # 80031d78 <proc>
      pp->parent = initproc;
    80002626:	00007a17          	auipc	s4,0x7
    8000262a:	9f2a0a13          	addi	s4,s4,-1550 # 80009018 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000262e:	00043997          	auipc	s3,0x43
    80002632:	54a98993          	addi	s3,s3,1354 # 80045b78 <tickslock>
    80002636:	a029                	j	80002640 <reparent+0x34>
    80002638:	4f848493          	addi	s1,s1,1272
    8000263c:	03348363          	beq	s1,s3,80002662 <reparent+0x56>
    if (pp->parent == p) {
    80002640:	709c                	ld	a5,32(s1)
    80002642:	ff279be3          	bne	a5,s2,80002638 <reparent+0x2c>
      acquire(&pp->lock);
    80002646:	8526                	mv	a0,s1
    80002648:	ffffe097          	auipc	ra,0xffffe
    8000264c:	6f2080e7          	jalr	1778(ra) # 80000d3a <acquire>
      pp->parent = initproc;
    80002650:	000a3783          	ld	a5,0(s4)
    80002654:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80002656:	8526                	mv	a0,s1
    80002658:	ffffe097          	auipc	ra,0xffffe
    8000265c:	796080e7          	jalr	1942(ra) # 80000dee <release>
    80002660:	bfe1                	j	80002638 <reparent+0x2c>
}
    80002662:	70a2                	ld	ra,40(sp)
    80002664:	7402                	ld	s0,32(sp)
    80002666:	64e2                	ld	s1,24(sp)
    80002668:	6942                	ld	s2,16(sp)
    8000266a:	69a2                	ld	s3,8(sp)
    8000266c:	6a02                	ld	s4,0(sp)
    8000266e:	6145                	addi	sp,sp,48
    80002670:	8082                	ret

0000000080002672 <scheduler>:
void scheduler(void) {
    80002672:	711d                	addi	sp,sp,-96
    80002674:	ec86                	sd	ra,88(sp)
    80002676:	e8a2                	sd	s0,80(sp)
    80002678:	e4a6                	sd	s1,72(sp)
    8000267a:	e0ca                	sd	s2,64(sp)
    8000267c:	fc4e                	sd	s3,56(sp)
    8000267e:	f852                	sd	s4,48(sp)
    80002680:	f456                	sd	s5,40(sp)
    80002682:	f05a                	sd	s6,32(sp)
    80002684:	ec5e                	sd	s7,24(sp)
    80002686:	e862                	sd	s8,16(sp)
    80002688:	e466                	sd	s9,8(sp)
    8000268a:	1080                	addi	s0,sp,96
    8000268c:	8792                	mv	a5,tp
  int id = r_tp();
    8000268e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002690:	00779c13          	slli	s8,a5,0x7
    80002694:	0002f717          	auipc	a4,0x2f
    80002698:	2cc70713          	addi	a4,a4,716 # 80031960 <pid_lock>
    8000269c:	9762                	add	a4,a4,s8
    8000269e:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    800026a2:	0002f717          	auipc	a4,0x2f
    800026a6:	2de70713          	addi	a4,a4,734 # 80031980 <cpus+0x8>
    800026aa:	9c3a                	add	s8,s8,a4
    int nproc = 0;
    800026ac:	4c81                	li	s9,0
      if (p->state == RUNNABLE) {
    800026ae:	4a89                	li	s5,2
        c->proc = p;
    800026b0:	079e                	slli	a5,a5,0x7
    800026b2:	0002fb17          	auipc	s6,0x2f
    800026b6:	2aeb0b13          	addi	s6,s6,686 # 80031960 <pid_lock>
    800026ba:	9b3e                	add	s6,s6,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    800026bc:	00043a17          	auipc	s4,0x43
    800026c0:	4bca0a13          	addi	s4,s4,1212 # 80045b78 <tickslock>
    800026c4:	a8a1                	j	8000271c <scheduler+0xaa>
      release(&p->lock);
    800026c6:	8526                	mv	a0,s1
    800026c8:	ffffe097          	auipc	ra,0xffffe
    800026cc:	726080e7          	jalr	1830(ra) # 80000dee <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800026d0:	4f848493          	addi	s1,s1,1272
    800026d4:	03448a63          	beq	s1,s4,80002708 <scheduler+0x96>
      acquire(&p->lock);
    800026d8:	8526                	mv	a0,s1
    800026da:	ffffe097          	auipc	ra,0xffffe
    800026de:	660080e7          	jalr	1632(ra) # 80000d3a <acquire>
      if (p->state != UNUSED) {
    800026e2:	4c9c                	lw	a5,24(s1)
    800026e4:	d3ed                	beqz	a5,800026c6 <scheduler+0x54>
        nproc++;
    800026e6:	2985                	addiw	s3,s3,1
      if (p->state == RUNNABLE) {
    800026e8:	fd579fe3          	bne	a5,s5,800026c6 <scheduler+0x54>
        p->state = RUNNING;
    800026ec:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    800026f0:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    800026f4:	06048593          	addi	a1,s1,96
    800026f8:	8562                	mv	a0,s8
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	644080e7          	jalr	1604(ra) # 80002d3e <swtch>
        c->proc = 0;
    80002702:	000b3c23          	sd	zero,24(s6)
    80002706:	b7c1                	j	800026c6 <scheduler+0x54>
    if (nproc <= 2) { // only init and sh exist
    80002708:	013aca63          	blt	s5,s3,8000271c <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000270c:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002710:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002714:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002718:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000271c:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002720:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002724:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80002728:	89e6                	mv	s3,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    8000272a:	0002f497          	auipc	s1,0x2f
    8000272e:	64e48493          	addi	s1,s1,1614 # 80031d78 <proc>
        p->state = RUNNING;
    80002732:	4b8d                	li	s7,3
    80002734:	b755                	j	800026d8 <scheduler+0x66>

0000000080002736 <sched>:
void sched(void) {
    80002736:	7179                	addi	sp,sp,-48
    80002738:	f406                	sd	ra,40(sp)
    8000273a:	f022                	sd	s0,32(sp)
    8000273c:	ec26                	sd	s1,24(sp)
    8000273e:	e84a                	sd	s2,16(sp)
    80002740:	e44e                	sd	s3,8(sp)
    80002742:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002744:	00000097          	auipc	ra,0x0
    80002748:	9c6080e7          	jalr	-1594(ra) # 8000210a <myproc>
    8000274c:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000274e:	ffffe097          	auipc	ra,0xffffe
    80002752:	572080e7          	jalr	1394(ra) # 80000cc0 <holding>
    80002756:	c93d                	beqz	a0,800027cc <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80002758:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000275a:	2781                	sext.w	a5,a5
    8000275c:	079e                	slli	a5,a5,0x7
    8000275e:	0002f717          	auipc	a4,0x2f
    80002762:	20270713          	addi	a4,a4,514 # 80031960 <pid_lock>
    80002766:	97ba                	add	a5,a5,a4
    80002768:	0907a703          	lw	a4,144(a5)
    8000276c:	4785                	li	a5,1
    8000276e:	06f71763          	bne	a4,a5,800027dc <sched+0xa6>
  if (p->state == RUNNING)
    80002772:	4c98                	lw	a4,24(s1)
    80002774:	478d                	li	a5,3
    80002776:	06f70b63          	beq	a4,a5,800027ec <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000277a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000277e:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002780:	efb5                	bnez	a5,800027fc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80002782:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002784:	0002f917          	auipc	s2,0x2f
    80002788:	1dc90913          	addi	s2,s2,476 # 80031960 <pid_lock>
    8000278c:	2781                	sext.w	a5,a5
    8000278e:	079e                	slli	a5,a5,0x7
    80002790:	97ca                	add	a5,a5,s2
    80002792:	0947a983          	lw	s3,148(a5)
    80002796:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002798:	2781                	sext.w	a5,a5
    8000279a:	079e                	slli	a5,a5,0x7
    8000279c:	0002f597          	auipc	a1,0x2f
    800027a0:	1e458593          	addi	a1,a1,484 # 80031980 <cpus+0x8>
    800027a4:	95be                	add	a1,a1,a5
    800027a6:	06048513          	addi	a0,s1,96
    800027aa:	00000097          	auipc	ra,0x0
    800027ae:	594080e7          	jalr	1428(ra) # 80002d3e <swtch>
    800027b2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800027b4:	2781                	sext.w	a5,a5
    800027b6:	079e                	slli	a5,a5,0x7
    800027b8:	97ca                	add	a5,a5,s2
    800027ba:	0937aa23          	sw	s3,148(a5)
}
    800027be:	70a2                	ld	ra,40(sp)
    800027c0:	7402                	ld	s0,32(sp)
    800027c2:	64e2                	ld	s1,24(sp)
    800027c4:	6942                	ld	s2,16(sp)
    800027c6:	69a2                	ld	s3,8(sp)
    800027c8:	6145                	addi	sp,sp,48
    800027ca:	8082                	ret
    panic("sched p->lock");
    800027cc:	00006517          	auipc	a0,0x6
    800027d0:	acc50513          	addi	a0,a0,-1332 # 80008298 <digits+0x230>
    800027d4:	ffffe097          	auipc	ra,0xffffe
    800027d8:	e10080e7          	jalr	-496(ra) # 800005e4 <panic>
    panic("sched locks");
    800027dc:	00006517          	auipc	a0,0x6
    800027e0:	acc50513          	addi	a0,a0,-1332 # 800082a8 <digits+0x240>
    800027e4:	ffffe097          	auipc	ra,0xffffe
    800027e8:	e00080e7          	jalr	-512(ra) # 800005e4 <panic>
    panic("sched running");
    800027ec:	00006517          	auipc	a0,0x6
    800027f0:	acc50513          	addi	a0,a0,-1332 # 800082b8 <digits+0x250>
    800027f4:	ffffe097          	auipc	ra,0xffffe
    800027f8:	df0080e7          	jalr	-528(ra) # 800005e4 <panic>
    panic("sched interruptible");
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	acc50513          	addi	a0,a0,-1332 # 800082c8 <digits+0x260>
    80002804:	ffffe097          	auipc	ra,0xffffe
    80002808:	de0080e7          	jalr	-544(ra) # 800005e4 <panic>

000000008000280c <exit>:
void exit(int status) {
    8000280c:	7179                	addi	sp,sp,-48
    8000280e:	f406                	sd	ra,40(sp)
    80002810:	f022                	sd	s0,32(sp)
    80002812:	ec26                	sd	s1,24(sp)
    80002814:	e84a                	sd	s2,16(sp)
    80002816:	e44e                	sd	s3,8(sp)
    80002818:	e052                	sd	s4,0(sp)
    8000281a:	1800                	addi	s0,sp,48
    8000281c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000281e:	00000097          	auipc	ra,0x0
    80002822:	8ec080e7          	jalr	-1812(ra) # 8000210a <myproc>
    80002826:	89aa                	mv	s3,a0
  if (p == initproc)
    80002828:	00006797          	auipc	a5,0x6
    8000282c:	7f07b783          	ld	a5,2032(a5) # 80009018 <initproc>
    80002830:	0d050493          	addi	s1,a0,208
    80002834:	15050913          	addi	s2,a0,336
    80002838:	02a79363          	bne	a5,a0,8000285e <exit+0x52>
    panic("init exiting");
    8000283c:	00006517          	auipc	a0,0x6
    80002840:	aa450513          	addi	a0,a0,-1372 # 800082e0 <digits+0x278>
    80002844:	ffffe097          	auipc	ra,0xffffe
    80002848:	da0080e7          	jalr	-608(ra) # 800005e4 <panic>
      fileclose(f);
    8000284c:	00002097          	auipc	ra,0x2
    80002850:	586080e7          	jalr	1414(ra) # 80004dd2 <fileclose>
      p->ofile[fd] = 0;
    80002854:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80002858:	04a1                	addi	s1,s1,8
    8000285a:	01248563          	beq	s1,s2,80002864 <exit+0x58>
    if (p->ofile[fd]) {
    8000285e:	6088                	ld	a0,0(s1)
    80002860:	f575                	bnez	a0,8000284c <exit+0x40>
    80002862:	bfdd                	j	80002858 <exit+0x4c>
    80002864:	17898493          	addi	s1,s3,376
    80002868:	4f898913          	addi	s2,s3,1272
    8000286c:	a029                	j	80002876 <exit+0x6a>
  for (int i = 0; i < MAX_VMA; i++) {
    8000286e:	03848493          	addi	s1,s1,56
    80002872:	03248563          	beq	s1,s2,8000289c <exit+0x90>
    if (p->vma[i].used) {
    80002876:	0304c783          	lbu	a5,48(s1)
    8000287a:	dbf5                	beqz	a5,8000286e <exit+0x62>
      if (munmap(p->vma[i].start, p->vma[i].length) < 0) {
    8000287c:	488c                	lw	a1,16(s1)
    8000287e:	6088                	ld	a0,0(s1)
    80002880:	fffff097          	auipc	ra,0xfffff
    80002884:	522080e7          	jalr	1314(ra) # 80001da2 <munmap>
    80002888:	fe0553e3          	bgez	a0,8000286e <exit+0x62>
        panic("free on exit");
    8000288c:	00006517          	auipc	a0,0x6
    80002890:	a6450513          	addi	a0,a0,-1436 # 800082f0 <digits+0x288>
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	d50080e7          	jalr	-688(ra) # 800005e4 <panic>
  begin_op();
    8000289c:	00002097          	auipc	ra,0x2
    800028a0:	064080e7          	jalr	100(ra) # 80004900 <begin_op>
  iput(p->cwd);
    800028a4:	1609b503          	ld	a0,352(s3)
    800028a8:	00002097          	auipc	ra,0x2
    800028ac:	852080e7          	jalr	-1966(ra) # 800040fa <iput>
  end_op();
    800028b0:	00002097          	auipc	ra,0x2
    800028b4:	0d0080e7          	jalr	208(ra) # 80004980 <end_op>
  p->cwd = 0;
    800028b8:	1609b023          	sd	zero,352(s3)
  acquire(&initproc->lock);
    800028bc:	00006497          	auipc	s1,0x6
    800028c0:	75c48493          	addi	s1,s1,1884 # 80009018 <initproc>
    800028c4:	6088                	ld	a0,0(s1)
    800028c6:	ffffe097          	auipc	ra,0xffffe
    800028ca:	474080e7          	jalr	1140(ra) # 80000d3a <acquire>
  wakeup1(initproc);
    800028ce:	6088                	ld	a0,0(s1)
    800028d0:	fffff097          	auipc	ra,0xfffff
    800028d4:	6fa080e7          	jalr	1786(ra) # 80001fca <wakeup1>
  release(&initproc->lock);
    800028d8:	6088                	ld	a0,0(s1)
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	514080e7          	jalr	1300(ra) # 80000dee <release>
  acquire(&p->lock);
    800028e2:	854e                	mv	a0,s3
    800028e4:	ffffe097          	auipc	ra,0xffffe
    800028e8:	456080e7          	jalr	1110(ra) # 80000d3a <acquire>
  struct proc *original_parent = p->parent;
    800028ec:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800028f0:	854e                	mv	a0,s3
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	4fc080e7          	jalr	1276(ra) # 80000dee <release>
  acquire(&original_parent->lock);
    800028fa:	8526                	mv	a0,s1
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	43e080e7          	jalr	1086(ra) # 80000d3a <acquire>
  acquire(&p->lock);
    80002904:	854e                	mv	a0,s3
    80002906:	ffffe097          	auipc	ra,0xffffe
    8000290a:	434080e7          	jalr	1076(ra) # 80000d3a <acquire>
  reparent(p);
    8000290e:	854e                	mv	a0,s3
    80002910:	00000097          	auipc	ra,0x0
    80002914:	cfc080e7          	jalr	-772(ra) # 8000260c <reparent>
  wakeup1(original_parent);
    80002918:	8526                	mv	a0,s1
    8000291a:	fffff097          	auipc	ra,0xfffff
    8000291e:	6b0080e7          	jalr	1712(ra) # 80001fca <wakeup1>
  p->xstate = status;
    80002922:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002926:	4791                	li	a5,4
    80002928:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000292c:	8526                	mv	a0,s1
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	4c0080e7          	jalr	1216(ra) # 80000dee <release>
  sched();
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	e00080e7          	jalr	-512(ra) # 80002736 <sched>
  panic("zombie exit");
    8000293e:	00006517          	auipc	a0,0x6
    80002942:	9c250513          	addi	a0,a0,-1598 # 80008300 <digits+0x298>
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	c9e080e7          	jalr	-866(ra) # 800005e4 <panic>

000000008000294e <yield>:
void yield(void) {
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	e426                	sd	s1,8(sp)
    80002956:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002958:	fffff097          	auipc	ra,0xfffff
    8000295c:	7b2080e7          	jalr	1970(ra) # 8000210a <myproc>
    80002960:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002962:	ffffe097          	auipc	ra,0xffffe
    80002966:	3d8080e7          	jalr	984(ra) # 80000d3a <acquire>
  p->state = RUNNABLE;
    8000296a:	4789                	li	a5,2
    8000296c:	cc9c                	sw	a5,24(s1)
  sched();
    8000296e:	00000097          	auipc	ra,0x0
    80002972:	dc8080e7          	jalr	-568(ra) # 80002736 <sched>
  release(&p->lock);
    80002976:	8526                	mv	a0,s1
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	476080e7          	jalr	1142(ra) # 80000dee <release>
}
    80002980:	60e2                	ld	ra,24(sp)
    80002982:	6442                	ld	s0,16(sp)
    80002984:	64a2                	ld	s1,8(sp)
    80002986:	6105                	addi	sp,sp,32
    80002988:	8082                	ret

000000008000298a <sleep>:
void sleep(void *chan, struct spinlock *lk) {
    8000298a:	7179                	addi	sp,sp,-48
    8000298c:	f406                	sd	ra,40(sp)
    8000298e:	f022                	sd	s0,32(sp)
    80002990:	ec26                	sd	s1,24(sp)
    80002992:	e84a                	sd	s2,16(sp)
    80002994:	e44e                	sd	s3,8(sp)
    80002996:	1800                	addi	s0,sp,48
    80002998:	89aa                	mv	s3,a0
    8000299a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000299c:	fffff097          	auipc	ra,0xfffff
    800029a0:	76e080e7          	jalr	1902(ra) # 8000210a <myproc>
    800029a4:	84aa                	mv	s1,a0
  if (lk != &p->lock) { // DOC: sleeplock0
    800029a6:	05250663          	beq	a0,s2,800029f2 <sleep+0x68>
    acquire(&p->lock);  // DOC: sleeplock1
    800029aa:	ffffe097          	auipc	ra,0xffffe
    800029ae:	390080e7          	jalr	912(ra) # 80000d3a <acquire>
    release(lk);
    800029b2:	854a                	mv	a0,s2
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	43a080e7          	jalr	1082(ra) # 80000dee <release>
  p->chan = chan;
    800029bc:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800029c0:	4785                	li	a5,1
    800029c2:	cc9c                	sw	a5,24(s1)
  sched();
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	d72080e7          	jalr	-654(ra) # 80002736 <sched>
  p->chan = 0;
    800029cc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800029d0:	8526                	mv	a0,s1
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	41c080e7          	jalr	1052(ra) # 80000dee <release>
    acquire(lk);
    800029da:	854a                	mv	a0,s2
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	35e080e7          	jalr	862(ra) # 80000d3a <acquire>
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6145                	addi	sp,sp,48
    800029f0:	8082                	ret
  p->chan = chan;
    800029f2:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800029f6:	4785                	li	a5,1
    800029f8:	cd1c                	sw	a5,24(a0)
  sched();
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	d3c080e7          	jalr	-708(ra) # 80002736 <sched>
  p->chan = 0;
    80002a02:	0204b423          	sd	zero,40(s1)
  if (lk != &p->lock) {
    80002a06:	bff9                	j	800029e4 <sleep+0x5a>

0000000080002a08 <wait>:
int wait(uint64 addr) {
    80002a08:	715d                	addi	sp,sp,-80
    80002a0a:	e486                	sd	ra,72(sp)
    80002a0c:	e0a2                	sd	s0,64(sp)
    80002a0e:	fc26                	sd	s1,56(sp)
    80002a10:	f84a                	sd	s2,48(sp)
    80002a12:	f44e                	sd	s3,40(sp)
    80002a14:	f052                	sd	s4,32(sp)
    80002a16:	ec56                	sd	s5,24(sp)
    80002a18:	e85a                	sd	s6,16(sp)
    80002a1a:	e45e                	sd	s7,8(sp)
    80002a1c:	0880                	addi	s0,sp,80
    80002a1e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002a20:	fffff097          	auipc	ra,0xfffff
    80002a24:	6ea080e7          	jalr	1770(ra) # 8000210a <myproc>
    80002a28:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002a2a:	ffffe097          	auipc	ra,0xffffe
    80002a2e:	310080e7          	jalr	784(ra) # 80000d3a <acquire>
    havekids = 0;
    80002a32:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    80002a34:	4a11                	li	s4,4
        havekids = 1;
    80002a36:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    80002a38:	00043997          	auipc	s3,0x43
    80002a3c:	14098993          	addi	s3,s3,320 # 80045b78 <tickslock>
    havekids = 0;
    80002a40:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    80002a42:	0002f497          	auipc	s1,0x2f
    80002a46:	33648493          	addi	s1,s1,822 # 80031d78 <proc>
    80002a4a:	a08d                	j	80002aac <wait+0xa4>
          pid = np->pid;
    80002a4c:	0384a983          	lw	s3,56(s1)
          freeproc(np);
    80002a50:	8526                	mv	a0,s1
    80002a52:	00000097          	auipc	ra,0x0
    80002a56:	86a080e7          	jalr	-1942(ra) # 800022bc <freeproc>
          if (addr != 0 &&
    80002a5a:	000b0e63          	beqz	s6,80002a76 <wait+0x6e>
              (res = copyout(p->pagetable, addr, (char *)&np->xstate,
    80002a5e:	4691                	li	a3,4
    80002a60:	03448613          	addi	a2,s1,52
    80002a64:	85da                	mv	a1,s6
    80002a66:	05093503          	ld	a0,80(s2)
    80002a6a:	fffff097          	auipc	ra,0xfffff
    80002a6e:	fb6080e7          	jalr	-74(ra) # 80001a20 <copyout>
          if (addr != 0 &&
    80002a72:	00054d63          	bltz	a0,80002a8c <wait+0x84>
          release(&np->lock);
    80002a76:	8526                	mv	a0,s1
    80002a78:	ffffe097          	auipc	ra,0xffffe
    80002a7c:	376080e7          	jalr	886(ra) # 80000dee <release>
          release(&p->lock);
    80002a80:	854a                	mv	a0,s2
    80002a82:	ffffe097          	auipc	ra,0xffffe
    80002a86:	36c080e7          	jalr	876(ra) # 80000dee <release>
          return pid;
    80002a8a:	a8a9                	j	80002ae4 <wait+0xdc>
            release(&np->lock);
    80002a8c:	8526                	mv	a0,s1
    80002a8e:	ffffe097          	auipc	ra,0xffffe
    80002a92:	360080e7          	jalr	864(ra) # 80000dee <release>
            release(&p->lock);
    80002a96:	854a                	mv	a0,s2
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	356080e7          	jalr	854(ra) # 80000dee <release>
            return -1;
    80002aa0:	59fd                	li	s3,-1
    80002aa2:	a089                	j	80002ae4 <wait+0xdc>
    for (np = proc; np < &proc[NPROC]; np++) {
    80002aa4:	4f848493          	addi	s1,s1,1272
    80002aa8:	03348463          	beq	s1,s3,80002ad0 <wait+0xc8>
      if (np->parent == p) {
    80002aac:	709c                	ld	a5,32(s1)
    80002aae:	ff279be3          	bne	a5,s2,80002aa4 <wait+0x9c>
        acquire(&np->lock);
    80002ab2:	8526                	mv	a0,s1
    80002ab4:	ffffe097          	auipc	ra,0xffffe
    80002ab8:	286080e7          	jalr	646(ra) # 80000d3a <acquire>
        if (np->state == ZOMBIE) {
    80002abc:	4c9c                	lw	a5,24(s1)
    80002abe:	f94787e3          	beq	a5,s4,80002a4c <wait+0x44>
        release(&np->lock);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	32a080e7          	jalr	810(ra) # 80000dee <release>
        havekids = 1;
    80002acc:	8756                	mv	a4,s5
    80002ace:	bfd9                	j	80002aa4 <wait+0x9c>
    if (!havekids || p->killed) {
    80002ad0:	c701                	beqz	a4,80002ad8 <wait+0xd0>
    80002ad2:	03092783          	lw	a5,48(s2)
    80002ad6:	c39d                	beqz	a5,80002afc <wait+0xf4>
      release(&p->lock);
    80002ad8:	854a                	mv	a0,s2
    80002ada:	ffffe097          	auipc	ra,0xffffe
    80002ade:	314080e7          	jalr	788(ra) # 80000dee <release>
      return -1;
    80002ae2:	59fd                	li	s3,-1
}
    80002ae4:	854e                	mv	a0,s3
    80002ae6:	60a6                	ld	ra,72(sp)
    80002ae8:	6406                	ld	s0,64(sp)
    80002aea:	74e2                	ld	s1,56(sp)
    80002aec:	7942                	ld	s2,48(sp)
    80002aee:	79a2                	ld	s3,40(sp)
    80002af0:	7a02                	ld	s4,32(sp)
    80002af2:	6ae2                	ld	s5,24(sp)
    80002af4:	6b42                	ld	s6,16(sp)
    80002af6:	6ba2                	ld	s7,8(sp)
    80002af8:	6161                	addi	sp,sp,80
    80002afa:	8082                	ret
    sleep(p, &p->lock); // DOC: wait-sleep
    80002afc:	85ca                	mv	a1,s2
    80002afe:	854a                	mv	a0,s2
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	e8a080e7          	jalr	-374(ra) # 8000298a <sleep>
    havekids = 0;
    80002b08:	bf25                	j	80002a40 <wait+0x38>

0000000080002b0a <wakeup>:
void wakeup(void *chan) {
    80002b0a:	7139                	addi	sp,sp,-64
    80002b0c:	fc06                	sd	ra,56(sp)
    80002b0e:	f822                	sd	s0,48(sp)
    80002b10:	f426                	sd	s1,40(sp)
    80002b12:	f04a                	sd	s2,32(sp)
    80002b14:	ec4e                	sd	s3,24(sp)
    80002b16:	e852                	sd	s4,16(sp)
    80002b18:	e456                	sd	s5,8(sp)
    80002b1a:	0080                	addi	s0,sp,64
    80002b1c:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80002b1e:	0002f497          	auipc	s1,0x2f
    80002b22:	25a48493          	addi	s1,s1,602 # 80031d78 <proc>
    if (p->state == SLEEPING && p->chan == chan) {
    80002b26:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002b28:	4a89                	li	s5,2
  for (p = proc; p < &proc[NPROC]; p++) {
    80002b2a:	00043917          	auipc	s2,0x43
    80002b2e:	04e90913          	addi	s2,s2,78 # 80045b78 <tickslock>
    80002b32:	a811                	j	80002b46 <wakeup+0x3c>
    release(&p->lock);
    80002b34:	8526                	mv	a0,s1
    80002b36:	ffffe097          	auipc	ra,0xffffe
    80002b3a:	2b8080e7          	jalr	696(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002b3e:	4f848493          	addi	s1,s1,1272
    80002b42:	03248063          	beq	s1,s2,80002b62 <wakeup+0x58>
    acquire(&p->lock);
    80002b46:	8526                	mv	a0,s1
    80002b48:	ffffe097          	auipc	ra,0xffffe
    80002b4c:	1f2080e7          	jalr	498(ra) # 80000d3a <acquire>
    if (p->state == SLEEPING && p->chan == chan) {
    80002b50:	4c9c                	lw	a5,24(s1)
    80002b52:	ff3791e3          	bne	a5,s3,80002b34 <wakeup+0x2a>
    80002b56:	749c                	ld	a5,40(s1)
    80002b58:	fd479ee3          	bne	a5,s4,80002b34 <wakeup+0x2a>
      p->state = RUNNABLE;
    80002b5c:	0154ac23          	sw	s5,24(s1)
    80002b60:	bfd1                	j	80002b34 <wakeup+0x2a>
}
    80002b62:	70e2                	ld	ra,56(sp)
    80002b64:	7442                	ld	s0,48(sp)
    80002b66:	74a2                	ld	s1,40(sp)
    80002b68:	7902                	ld	s2,32(sp)
    80002b6a:	69e2                	ld	s3,24(sp)
    80002b6c:	6a42                	ld	s4,16(sp)
    80002b6e:	6aa2                	ld	s5,8(sp)
    80002b70:	6121                	addi	sp,sp,64
    80002b72:	8082                	ret

0000000080002b74 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	1800                	addi	s0,sp,48
    80002b82:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002b84:	0002f497          	auipc	s1,0x2f
    80002b88:	1f448493          	addi	s1,s1,500 # 80031d78 <proc>
    80002b8c:	00043997          	auipc	s3,0x43
    80002b90:	fec98993          	addi	s3,s3,-20 # 80045b78 <tickslock>
    acquire(&p->lock);
    80002b94:	8526                	mv	a0,s1
    80002b96:	ffffe097          	auipc	ra,0xffffe
    80002b9a:	1a4080e7          	jalr	420(ra) # 80000d3a <acquire>
    if (p->pid == pid) {
    80002b9e:	5c9c                	lw	a5,56(s1)
    80002ba0:	01278d63          	beq	a5,s2,80002bba <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	ffffe097          	auipc	ra,0xffffe
    80002baa:	248080e7          	jalr	584(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002bae:	4f848493          	addi	s1,s1,1272
    80002bb2:	ff3491e3          	bne	s1,s3,80002b94 <kill+0x20>
  }
  return -1;
    80002bb6:	557d                	li	a0,-1
    80002bb8:	a821                	j	80002bd0 <kill+0x5c>
      p->killed = 1;
    80002bba:	4785                	li	a5,1
    80002bbc:	d89c                	sw	a5,48(s1)
      if (p->state == SLEEPING) {
    80002bbe:	4c98                	lw	a4,24(s1)
    80002bc0:	00f70f63          	beq	a4,a5,80002bde <kill+0x6a>
      release(&p->lock);
    80002bc4:	8526                	mv	a0,s1
    80002bc6:	ffffe097          	auipc	ra,0xffffe
    80002bca:	228080e7          	jalr	552(ra) # 80000dee <release>
      return 0;
    80002bce:	4501                	li	a0,0
}
    80002bd0:	70a2                	ld	ra,40(sp)
    80002bd2:	7402                	ld	s0,32(sp)
    80002bd4:	64e2                	ld	s1,24(sp)
    80002bd6:	6942                	ld	s2,16(sp)
    80002bd8:	69a2                	ld	s3,8(sp)
    80002bda:	6145                	addi	sp,sp,48
    80002bdc:	8082                	ret
        p->state = RUNNABLE;
    80002bde:	4789                	li	a5,2
    80002be0:	cc9c                	sw	a5,24(s1)
    80002be2:	b7cd                	j	80002bc4 <kill+0x50>

0000000080002be4 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80002be4:	7179                	addi	sp,sp,-48
    80002be6:	f406                	sd	ra,40(sp)
    80002be8:	f022                	sd	s0,32(sp)
    80002bea:	ec26                	sd	s1,24(sp)
    80002bec:	e84a                	sd	s2,16(sp)
    80002bee:	e44e                	sd	s3,8(sp)
    80002bf0:	e052                	sd	s4,0(sp)
    80002bf2:	1800                	addi	s0,sp,48
    80002bf4:	84aa                	mv	s1,a0
    80002bf6:	892e                	mv	s2,a1
    80002bf8:	89b2                	mv	s3,a2
    80002bfa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002bfc:	fffff097          	auipc	ra,0xfffff
    80002c00:	50e080e7          	jalr	1294(ra) # 8000210a <myproc>
  if (user_dst) {
    80002c04:	c08d                	beqz	s1,80002c26 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002c06:	86d2                	mv	a3,s4
    80002c08:	864e                	mv	a2,s3
    80002c0a:	85ca                	mv	a1,s2
    80002c0c:	6928                	ld	a0,80(a0)
    80002c0e:	fffff097          	auipc	ra,0xfffff
    80002c12:	e12080e7          	jalr	-494(ra) # 80001a20 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002c16:	70a2                	ld	ra,40(sp)
    80002c18:	7402                	ld	s0,32(sp)
    80002c1a:	64e2                	ld	s1,24(sp)
    80002c1c:	6942                	ld	s2,16(sp)
    80002c1e:	69a2                	ld	s3,8(sp)
    80002c20:	6a02                	ld	s4,0(sp)
    80002c22:	6145                	addi	sp,sp,48
    80002c24:	8082                	ret
    memmove((char *)dst, src, len);
    80002c26:	000a061b          	sext.w	a2,s4
    80002c2a:	85ce                	mv	a1,s3
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	ffffe097          	auipc	ra,0xffffe
    80002c32:	264080e7          	jalr	612(ra) # 80000e92 <memmove>
    return 0;
    80002c36:	8526                	mv	a0,s1
    80002c38:	bff9                	j	80002c16 <either_copyout+0x32>

0000000080002c3a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80002c3a:	7179                	addi	sp,sp,-48
    80002c3c:	f406                	sd	ra,40(sp)
    80002c3e:	f022                	sd	s0,32(sp)
    80002c40:	ec26                	sd	s1,24(sp)
    80002c42:	e84a                	sd	s2,16(sp)
    80002c44:	e44e                	sd	s3,8(sp)
    80002c46:	e052                	sd	s4,0(sp)
    80002c48:	1800                	addi	s0,sp,48
    80002c4a:	892a                	mv	s2,a0
    80002c4c:	84ae                	mv	s1,a1
    80002c4e:	89b2                	mv	s3,a2
    80002c50:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002c52:	fffff097          	auipc	ra,0xfffff
    80002c56:	4b8080e7          	jalr	1208(ra) # 8000210a <myproc>
  if (user_src) {
    80002c5a:	c08d                	beqz	s1,80002c7c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002c5c:	86d2                	mv	a3,s4
    80002c5e:	864e                	mv	a2,s3
    80002c60:	85ca                	mv	a1,s2
    80002c62:	6928                	ld	a0,80(a0)
    80002c64:	fffff097          	auipc	ra,0xfffff
    80002c68:	b48080e7          	jalr	-1208(ra) # 800017ac <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002c6c:	70a2                	ld	ra,40(sp)
    80002c6e:	7402                	ld	s0,32(sp)
    80002c70:	64e2                	ld	s1,24(sp)
    80002c72:	6942                	ld	s2,16(sp)
    80002c74:	69a2                	ld	s3,8(sp)
    80002c76:	6a02                	ld	s4,0(sp)
    80002c78:	6145                	addi	sp,sp,48
    80002c7a:	8082                	ret
    memmove(dst, (char *)src, len);
    80002c7c:	000a061b          	sext.w	a2,s4
    80002c80:	85ce                	mv	a1,s3
    80002c82:	854a                	mv	a0,s2
    80002c84:	ffffe097          	auipc	ra,0xffffe
    80002c88:	20e080e7          	jalr	526(ra) # 80000e92 <memmove>
    return 0;
    80002c8c:	8526                	mv	a0,s1
    80002c8e:	bff9                	j	80002c6c <either_copyin+0x32>

0000000080002c90 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80002c90:	715d                	addi	sp,sp,-80
    80002c92:	e486                	sd	ra,72(sp)
    80002c94:	e0a2                	sd	s0,64(sp)
    80002c96:	fc26                	sd	s1,56(sp)
    80002c98:	f84a                	sd	s2,48(sp)
    80002c9a:	f44e                	sd	s3,40(sp)
    80002c9c:	f052                	sd	s4,32(sp)
    80002c9e:	ec56                	sd	s5,24(sp)
    80002ca0:	e85a                	sd	s6,16(sp)
    80002ca2:	e45e                	sd	s7,8(sp)
    80002ca4:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002ca6:	00005517          	auipc	a0,0x5
    80002caa:	41250513          	addi	a0,a0,1042 # 800080b8 <digits+0x50>
    80002cae:	ffffe097          	auipc	ra,0xffffe
    80002cb2:	988080e7          	jalr	-1656(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002cb6:	0002f497          	auipc	s1,0x2f
    80002cba:	21248493          	addi	s1,s1,530 # 80031ec8 <proc+0x150>
    80002cbe:	00043917          	auipc	s2,0x43
    80002cc2:	00a90913          	addi	s2,s2,10 # 80045cc8 <bcache+0x138>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002cc6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002cc8:	00005997          	auipc	s3,0x5
    80002ccc:	64898993          	addi	s3,s3,1608 # 80008310 <digits+0x2a8>
    printf("%d %s %s", p->pid, state, p->name);
    80002cd0:	00005a97          	auipc	s5,0x5
    80002cd4:	648a8a93          	addi	s5,s5,1608 # 80008318 <digits+0x2b0>
    printf("\n");
    80002cd8:	00005a17          	auipc	s4,0x5
    80002cdc:	3e0a0a13          	addi	s4,s4,992 # 800080b8 <digits+0x50>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ce0:	00005b97          	auipc	s7,0x5
    80002ce4:	670b8b93          	addi	s7,s7,1648 # 80008350 <states.0>
    80002ce8:	a00d                	j	80002d0a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002cea:	ee86a583          	lw	a1,-280(a3)
    80002cee:	8556                	mv	a0,s5
    80002cf0:	ffffe097          	auipc	ra,0xffffe
    80002cf4:	946080e7          	jalr	-1722(ra) # 80000636 <printf>
    printf("\n");
    80002cf8:	8552                	mv	a0,s4
    80002cfa:	ffffe097          	auipc	ra,0xffffe
    80002cfe:	93c080e7          	jalr	-1732(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002d02:	4f848493          	addi	s1,s1,1272
    80002d06:	03248163          	beq	s1,s2,80002d28 <procdump+0x98>
    if (p->state == UNUSED)
    80002d0a:	86a6                	mv	a3,s1
    80002d0c:	ec84a783          	lw	a5,-312(s1)
    80002d10:	dbed                	beqz	a5,80002d02 <procdump+0x72>
      state = "???";
    80002d12:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002d14:	fcfb6be3          	bltu	s6,a5,80002cea <procdump+0x5a>
    80002d18:	1782                	slli	a5,a5,0x20
    80002d1a:	9381                	srli	a5,a5,0x20
    80002d1c:	078e                	slli	a5,a5,0x3
    80002d1e:	97de                	add	a5,a5,s7
    80002d20:	6390                	ld	a2,0(a5)
    80002d22:	f661                	bnez	a2,80002cea <procdump+0x5a>
      state = "???";
    80002d24:	864e                	mv	a2,s3
    80002d26:	b7d1                	j	80002cea <procdump+0x5a>
  }
}
    80002d28:	60a6                	ld	ra,72(sp)
    80002d2a:	6406                	ld	s0,64(sp)
    80002d2c:	74e2                	ld	s1,56(sp)
    80002d2e:	7942                	ld	s2,48(sp)
    80002d30:	79a2                	ld	s3,40(sp)
    80002d32:	7a02                	ld	s4,32(sp)
    80002d34:	6ae2                	ld	s5,24(sp)
    80002d36:	6b42                	ld	s6,16(sp)
    80002d38:	6ba2                	ld	s7,8(sp)
    80002d3a:	6161                	addi	sp,sp,80
    80002d3c:	8082                	ret

0000000080002d3e <swtch>:
    80002d3e:	00153023          	sd	ra,0(a0)
    80002d42:	00253423          	sd	sp,8(a0)
    80002d46:	e900                	sd	s0,16(a0)
    80002d48:	ed04                	sd	s1,24(a0)
    80002d4a:	03253023          	sd	s2,32(a0)
    80002d4e:	03353423          	sd	s3,40(a0)
    80002d52:	03453823          	sd	s4,48(a0)
    80002d56:	03553c23          	sd	s5,56(a0)
    80002d5a:	05653023          	sd	s6,64(a0)
    80002d5e:	05753423          	sd	s7,72(a0)
    80002d62:	05853823          	sd	s8,80(a0)
    80002d66:	05953c23          	sd	s9,88(a0)
    80002d6a:	07a53023          	sd	s10,96(a0)
    80002d6e:	07b53423          	sd	s11,104(a0)
    80002d72:	0005b083          	ld	ra,0(a1)
    80002d76:	0085b103          	ld	sp,8(a1)
    80002d7a:	6980                	ld	s0,16(a1)
    80002d7c:	6d84                	ld	s1,24(a1)
    80002d7e:	0205b903          	ld	s2,32(a1)
    80002d82:	0285b983          	ld	s3,40(a1)
    80002d86:	0305ba03          	ld	s4,48(a1)
    80002d8a:	0385ba83          	ld	s5,56(a1)
    80002d8e:	0405bb03          	ld	s6,64(a1)
    80002d92:	0485bb83          	ld	s7,72(a1)
    80002d96:	0505bc03          	ld	s8,80(a1)
    80002d9a:	0585bc83          	ld	s9,88(a1)
    80002d9e:	0605bd03          	ld	s10,96(a1)
    80002da2:	0685bd83          	ld	s11,104(a1)
    80002da6:	8082                	ret

0000000080002da8 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002da8:	1141                	addi	sp,sp,-16
    80002daa:	e406                	sd	ra,8(sp)
    80002dac:	e022                	sd	s0,0(sp)
    80002dae:	0800                	addi	s0,sp,16
    80002db0:	00005597          	auipc	a1,0x5
    80002db4:	5c858593          	addi	a1,a1,1480 # 80008378 <states.0+0x28>
    80002db8:	00043517          	auipc	a0,0x43
    80002dbc:	dc050513          	addi	a0,a0,-576 # 80045b78 <tickslock>
    80002dc0:	ffffe097          	auipc	ra,0xffffe
    80002dc4:	eea080e7          	jalr	-278(ra) # 80000caa <initlock>
    80002dc8:	60a2                	ld	ra,8(sp)
    80002dca:	6402                	ld	s0,0(sp)
    80002dcc:	0141                	addi	sp,sp,16
    80002dce:	8082                	ret

0000000080002dd0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002dd0:	1141                	addi	sp,sp,-16
    80002dd2:	e422                	sd	s0,8(sp)
    80002dd4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002dd6:	00003797          	auipc	a5,0x3
    80002dda:	65a78793          	addi	a5,a5,1626 # 80006430 <kernelvec>
    80002dde:	10579073          	csrw	stvec,a5
    80002de2:	6422                	ld	s0,8(sp)
    80002de4:	0141                	addi	sp,sp,16
    80002de6:	8082                	ret

0000000080002de8 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002de8:	1141                	addi	sp,sp,-16
    80002dea:	e406                	sd	ra,8(sp)
    80002dec:	e022                	sd	s0,0(sp)
    80002dee:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	31a080e7          	jalr	794(ra) # 8000210a <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002df8:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002dfc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002dfe:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002e02:	00004617          	auipc	a2,0x4
    80002e06:	1fe60613          	addi	a2,a2,510 # 80007000 <_trampoline>
    80002e0a:	00004697          	auipc	a3,0x4
    80002e0e:	1f668693          	addi	a3,a3,502 # 80007000 <_trampoline>
    80002e12:	8e91                	sub	a3,a3,a2
    80002e14:	040007b7          	lui	a5,0x4000
    80002e18:	17fd                	addi	a5,a5,-1
    80002e1a:	07b2                	slli	a5,a5,0xc
    80002e1c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002e1e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002e22:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002e24:	180026f3          	csrr	a3,satp
    80002e28:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002e2a:	6d38                	ld	a4,88(a0)
    80002e2c:	6134                	ld	a3,64(a0)
    80002e2e:	6585                	lui	a1,0x1
    80002e30:	96ae                	add	a3,a3,a1
    80002e32:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002e34:	6d38                	ld	a4,88(a0)
    80002e36:	00000697          	auipc	a3,0x0
    80002e3a:	13868693          	addi	a3,a3,312 # 80002f6e <usertrap>
    80002e3e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002e40:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002e42:	8692                	mv	a3,tp
    80002e44:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e46:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002e4a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002e4e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002e52:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002e56:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002e58:	6f18                	ld	a4,24(a4)
    80002e5a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002e5e:	692c                	ld	a1,80(a0)
    80002e60:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002e62:	00004717          	auipc	a4,0x4
    80002e66:	22e70713          	addi	a4,a4,558 # 80007090 <userret>
    80002e6a:	8f11                	sub	a4,a4,a2
    80002e6c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002e6e:	577d                	li	a4,-1
    80002e70:	177e                	slli	a4,a4,0x3f
    80002e72:	8dd9                	or	a1,a1,a4
    80002e74:	02000537          	lui	a0,0x2000
    80002e78:	157d                	addi	a0,a0,-1
    80002e7a:	0536                	slli	a0,a0,0xd
    80002e7c:	9782                	jalr	a5
}
    80002e7e:	60a2                	ld	ra,8(sp)
    80002e80:	6402                	ld	s0,0(sp)
    80002e82:	0141                	addi	sp,sp,16
    80002e84:	8082                	ret

0000000080002e86 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002e86:	1101                	addi	sp,sp,-32
    80002e88:	ec06                	sd	ra,24(sp)
    80002e8a:	e822                	sd	s0,16(sp)
    80002e8c:	e426                	sd	s1,8(sp)
    80002e8e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002e90:	00043497          	auipc	s1,0x43
    80002e94:	ce848493          	addi	s1,s1,-792 # 80045b78 <tickslock>
    80002e98:	8526                	mv	a0,s1
    80002e9a:	ffffe097          	auipc	ra,0xffffe
    80002e9e:	ea0080e7          	jalr	-352(ra) # 80000d3a <acquire>
  ticks++;
    80002ea2:	00006517          	auipc	a0,0x6
    80002ea6:	17e50513          	addi	a0,a0,382 # 80009020 <ticks>
    80002eaa:	411c                	lw	a5,0(a0)
    80002eac:	2785                	addiw	a5,a5,1
    80002eae:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002eb0:	00000097          	auipc	ra,0x0
    80002eb4:	c5a080e7          	jalr	-934(ra) # 80002b0a <wakeup>
  release(&tickslock);
    80002eb8:	8526                	mv	a0,s1
    80002eba:	ffffe097          	auipc	ra,0xffffe
    80002ebe:	f34080e7          	jalr	-204(ra) # 80000dee <release>
}
    80002ec2:	60e2                	ld	ra,24(sp)
    80002ec4:	6442                	ld	s0,16(sp)
    80002ec6:	64a2                	ld	s1,8(sp)
    80002ec8:	6105                	addi	sp,sp,32
    80002eca:	8082                	ret

0000000080002ecc <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002ed6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002eda:	00074d63          	bltz	a4,80002ef4 <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002ede:	57fd                	li	a5,-1
    80002ee0:	17fe                	slli	a5,a5,0x3f
    80002ee2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002ee4:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002ee6:	06f70363          	beq	a4,a5,80002f4c <devintr+0x80>
  }
}
    80002eea:	60e2                	ld	ra,24(sp)
    80002eec:	6442                	ld	s0,16(sp)
    80002eee:	64a2                	ld	s1,8(sp)
    80002ef0:	6105                	addi	sp,sp,32
    80002ef2:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002ef4:	0ff77793          	andi	a5,a4,255
    80002ef8:	46a5                	li	a3,9
    80002efa:	fed792e3          	bne	a5,a3,80002ede <devintr+0x12>
    int irq = plic_claim();
    80002efe:	00003097          	auipc	ra,0x3
    80002f02:	63a080e7          	jalr	1594(ra) # 80006538 <plic_claim>
    80002f06:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002f08:	47a9                	li	a5,10
    80002f0a:	02f50763          	beq	a0,a5,80002f38 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002f0e:	4785                	li	a5,1
    80002f10:	02f50963          	beq	a0,a5,80002f42 <devintr+0x76>
    return 1;
    80002f14:	4505                	li	a0,1
    } else if (irq) {
    80002f16:	d8f1                	beqz	s1,80002eea <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002f18:	85a6                	mv	a1,s1
    80002f1a:	00005517          	auipc	a0,0x5
    80002f1e:	46650513          	addi	a0,a0,1126 # 80008380 <states.0+0x30>
    80002f22:	ffffd097          	auipc	ra,0xffffd
    80002f26:	714080e7          	jalr	1812(ra) # 80000636 <printf>
      plic_complete(irq);
    80002f2a:	8526                	mv	a0,s1
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	630080e7          	jalr	1584(ra) # 8000655c <plic_complete>
    return 1;
    80002f34:	4505                	li	a0,1
    80002f36:	bf55                	j	80002eea <devintr+0x1e>
      uartintr();
    80002f38:	ffffe097          	auipc	ra,0xffffe
    80002f3c:	b02080e7          	jalr	-1278(ra) # 80000a3a <uartintr>
    80002f40:	b7ed                	j	80002f2a <devintr+0x5e>
      virtio_disk_intr();
    80002f42:	00004097          	auipc	ra,0x4
    80002f46:	a94080e7          	jalr	-1388(ra) # 800069d6 <virtio_disk_intr>
    80002f4a:	b7c5                	j	80002f2a <devintr+0x5e>
    if (cpuid() == 0) {
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	192080e7          	jalr	402(ra) # 800020de <cpuid>
    80002f54:	c901                	beqz	a0,80002f64 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002f56:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002f5a:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002f5c:	14479073          	csrw	sip,a5
    return 2;
    80002f60:	4509                	li	a0,2
    80002f62:	b761                	j	80002eea <devintr+0x1e>
      clockintr();
    80002f64:	00000097          	auipc	ra,0x0
    80002f68:	f22080e7          	jalr	-222(ra) # 80002e86 <clockintr>
    80002f6c:	b7ed                	j	80002f56 <devintr+0x8a>

0000000080002f6e <usertrap>:
void usertrap(void) {
    80002f6e:	7179                	addi	sp,sp,-48
    80002f70:	f406                	sd	ra,40(sp)
    80002f72:	f022                	sd	s0,32(sp)
    80002f74:	ec26                	sd	s1,24(sp)
    80002f76:	e84a                	sd	s2,16(sp)
    80002f78:	e44e                	sd	s3,8(sp)
    80002f7a:	e052                	sd	s4,0(sp)
    80002f7c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f7e:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002f82:	1007f793          	andi	a5,a5,256
    80002f86:	e7a5                	bnez	a5,80002fee <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002f88:	00003797          	auipc	a5,0x3
    80002f8c:	4a878793          	addi	a5,a5,1192 # 80006430 <kernelvec>
    80002f90:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	176080e7          	jalr	374(ra) # 8000210a <myproc>
    80002f9c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f9e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002fa0:	14102773          	csrr	a4,sepc
    80002fa4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002fa6:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002faa:	47a1                	li	a5,8
    80002fac:	04f71f63          	bne	a4,a5,8000300a <usertrap+0x9c>
    if (p->killed)
    80002fb0:	591c                	lw	a5,48(a0)
    80002fb2:	e7b1                	bnez	a5,80002ffe <usertrap+0x90>
    p->trapframe->epc += 4;
    80002fb4:	6cb8                	ld	a4,88(s1)
    80002fb6:	6f1c                	ld	a5,24(a4)
    80002fb8:	0791                	addi	a5,a5,4
    80002fba:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002fbc:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002fc0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002fc4:	10079073          	csrw	sstatus,a5
    syscall();
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	422080e7          	jalr	1058(ra) # 800033ea <syscall>
  if (p->killed)
    80002fd0:	589c                	lw	a5,48(s1)
    80002fd2:	1c079963          	bnez	a5,800031a4 <usertrap+0x236>
  usertrapret();
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	e12080e7          	jalr	-494(ra) # 80002de8 <usertrapret>
}
    80002fde:	70a2                	ld	ra,40(sp)
    80002fe0:	7402                	ld	s0,32(sp)
    80002fe2:	64e2                	ld	s1,24(sp)
    80002fe4:	6942                	ld	s2,16(sp)
    80002fe6:	69a2                	ld	s3,8(sp)
    80002fe8:	6a02                	ld	s4,0(sp)
    80002fea:	6145                	addi	sp,sp,48
    80002fec:	8082                	ret
    panic("usertrap: not from user mode");
    80002fee:	00005517          	auipc	a0,0x5
    80002ff2:	3b250513          	addi	a0,a0,946 # 800083a0 <states.0+0x50>
    80002ff6:	ffffd097          	auipc	ra,0xffffd
    80002ffa:	5ee080e7          	jalr	1518(ra) # 800005e4 <panic>
      exit(-1);
    80002ffe:	557d                	li	a0,-1
    80003000:	00000097          	auipc	ra,0x0
    80003004:	80c080e7          	jalr	-2036(ra) # 8000280c <exit>
    80003008:	b775                	j	80002fb4 <usertrap+0x46>
  } else if ((which_dev = devintr()) != 0) {
    8000300a:	00000097          	auipc	ra,0x0
    8000300e:	ec2080e7          	jalr	-318(ra) # 80002ecc <devintr>
    80003012:	89aa                	mv	s3,a0
    80003014:	18051563          	bnez	a0,8000319e <usertrap+0x230>
  asm volatile("csrr %0, scause" : "=r"(x));
    80003018:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    8000301c:	47b5                	li	a5,13
    8000301e:	00f70763          	beq	a4,a5,8000302c <usertrap+0xbe>
    80003022:	14202773          	csrr	a4,scause
    80003026:	47bd                	li	a5,15
    80003028:	14f71163          	bne	a4,a5,8000316a <usertrap+0x1fc>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000302c:	14302a73          	csrr	s4,stval
    if (addr > MAXVA) {
    80003030:	4785                	li	a5,1
    80003032:	179a                	slli	a5,a5,0x26
    80003034:	0347e463          	bltu	a5,s4,8000305c <usertrap+0xee>
    pte_t *pte = walk(p->pagetable, addr, 0);
    80003038:	4601                	li	a2,0
    8000303a:	85d2                	mv	a1,s4
    8000303c:	68a8                	ld	a0,80(s1)
    8000303e:	ffffe097          	auipc	ra,0xffffe
    80003042:	0e0080e7          	jalr	224(ra) # 8000111e <walk>
    if (pte && (*pte & PTE_COW)) {
    80003046:	c509                	beqz	a0,80003050 <usertrap+0xe2>
    80003048:	611c                	ld	a5,0(a0)
    8000304a:	1007f793          	andi	a5,a5,256
    8000304e:	e395                	bnez	a5,80003072 <usertrap+0x104>
    80003050:	17848793          	addi	a5,s1,376
void usertrap(void) {
    80003054:	894e                	mv	s2,s3
      if ((void *)addr >= p->vma[i].start &&
    80003056:	85d2                	mv	a1,s4
    for (int i = 0; i < MAX_VMA; i++) {
    80003058:	46c1                	li	a3,16
    8000305a:	a07d                	j	80003108 <usertrap+0x19a>
      printf("memory overflow");
    8000305c:	00005517          	auipc	a0,0x5
    80003060:	36450513          	addi	a0,a0,868 # 800083c0 <states.0+0x70>
    80003064:	ffffd097          	auipc	ra,0xffffd
    80003068:	5d2080e7          	jalr	1490(ra) # 80000636 <printf>
      p->killed = 1;
    8000306c:	4785                	li	a5,1
    8000306e:	d89c                	sw	a5,48(s1)
    80003070:	b7e1                	j	80003038 <usertrap+0xca>
      int res = do_cow(p->pagetable, addr);
    80003072:	85d2                	mv	a1,s4
    80003074:	68a8                	ld	a0,80(s1)
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	878080e7          	jalr	-1928(ra) # 800018ee <do_cow>
      if (res != 0) {
    8000307e:	d929                	beqz	a0,80002fd0 <usertrap+0x62>
        printf("cow failed");
    80003080:	00005517          	auipc	a0,0x5
    80003084:	35050513          	addi	a0,a0,848 # 800083d0 <states.0+0x80>
    80003088:	ffffd097          	auipc	ra,0xffffd
    8000308c:	5ae080e7          	jalr	1454(ra) # 80000636 <printf>
        p->killed = 1;
    80003090:	4785                	li	a5,1
    80003092:	d89c                	sw	a5,48(s1)
    80003094:	a82d                	j	800030ce <usertrap+0x160>
          printf("original permission %p\n", PTE_FLAGS(*pte));
    80003096:	3ff5f593          	andi	a1,a1,1023
    8000309a:	00005517          	auipc	a0,0x5
    8000309e:	34650513          	addi	a0,a0,838 # 800083e0 <states.0+0x90>
    800030a2:	ffffd097          	auipc	ra,0xffffd
    800030a6:	594080e7          	jalr	1428(ra) # 80000636 <printf>
          printf("map exists");
    800030aa:	00005517          	auipc	a0,0x5
    800030ae:	34e50513          	addi	a0,a0,846 # 800083f8 <states.0+0xa8>
    800030b2:	ffffd097          	auipc	ra,0xffffd
    800030b6:	584080e7          	jalr	1412(ra) # 80000636 <printf>
      printf("memory access  permission denied");
    800030ba:	00005517          	auipc	a0,0x5
    800030be:	37650513          	addi	a0,a0,886 # 80008430 <states.0+0xe0>
    800030c2:	ffffd097          	auipc	ra,0xffffd
    800030c6:	574080e7          	jalr	1396(ra) # 80000636 <printf>
      p->killed = 1;
    800030ca:	4785                	li	a5,1
    800030cc:	d89c                	sw	a5,48(s1)
    exit(-1);
    800030ce:	557d                	li	a0,-1
    800030d0:	fffff097          	auipc	ra,0xfffff
    800030d4:	73c080e7          	jalr	1852(ra) # 8000280c <exit>
  if (which_dev == 2)
    800030d8:	4789                	li	a5,2
    800030da:	eef99ee3          	bne	s3,a5,80002fd6 <usertrap+0x68>
    yield();
    800030de:	00000097          	auipc	ra,0x0
    800030e2:	870080e7          	jalr	-1936(ra) # 8000294e <yield>
    800030e6:	bdc5                	j	80002fd6 <usertrap+0x68>
          printf("run out of memory\n");
    800030e8:	00005517          	auipc	a0,0x5
    800030ec:	32050513          	addi	a0,a0,800 # 80008408 <states.0+0xb8>
    800030f0:	ffffd097          	auipc	ra,0xffffd
    800030f4:	546080e7          	jalr	1350(ra) # 80000636 <printf>
          p->killed = 1;
    800030f8:	4785                	li	a5,1
    800030fa:	d89c                	sw	a5,48(s1)
    800030fc:	bfc9                	j	800030ce <usertrap+0x160>
    for (int i = 0; i < MAX_VMA; i++) {
    800030fe:	2905                	addiw	s2,s2,1
    80003100:	03878793          	addi	a5,a5,56
    80003104:	fad90be3          	beq	s2,a3,800030ba <usertrap+0x14c>
      if ((void *)addr >= p->vma[i].start &&
    80003108:	6398                	ld	a4,0(a5)
    8000310a:	feea6ae3          	bltu	s4,a4,800030fe <usertrap+0x190>
          (void *)addr < p->vma[i].start + p->vma[i].length) {
    8000310e:	6b90                	ld	a2,16(a5)
    80003110:	9732                	add	a4,a4,a2
      if ((void *)addr >= p->vma[i].start &&
    80003112:	fee5f6e3          	bgeu	a1,a4,800030fe <usertrap+0x190>
        pte_t *pte = walk(p->pagetable, addr, 0);
    80003116:	4601                	li	a2,0
    80003118:	85d2                	mv	a1,s4
    8000311a:	68a8                	ld	a0,80(s1)
    8000311c:	ffffe097          	auipc	ra,0xffffe
    80003120:	002080e7          	jalr	2(ra) # 8000111e <walk>
        if (pte && (*pte & PTE_V)) {
    80003124:	c509                	beqz	a0,8000312e <usertrap+0x1c0>
    80003126:	610c                	ld	a1,0(a0)
    80003128:	0015f793          	andi	a5,a1,1
    8000312c:	f7ad                	bnez	a5,80003096 <usertrap+0x128>
        if ((res = do_vma((void *)addr, &p->vma[i])) == -1) {
    8000312e:	00391593          	slli	a1,s2,0x3
    80003132:	412585b3          	sub	a1,a1,s2
    80003136:	058e                	slli	a1,a1,0x3
    80003138:	17858593          	addi	a1,a1,376 # 1178 <_entry-0x7fffee88>
    8000313c:	95a6                	add	a1,a1,s1
    8000313e:	8552                	mv	a0,s4
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	a14080e7          	jalr	-1516(ra) # 80001b54 <do_vma>
    80003148:	57fd                	li	a5,-1
    8000314a:	f8f50fe3          	beq	a0,a5,800030e8 <usertrap+0x17a>
        } else if (res == -2) {
    8000314e:	57f9                	li	a5,-2
    80003150:	e8f510e3          	bne	a0,a5,80002fd0 <usertrap+0x62>
          printf("map failed");
    80003154:	00005517          	auipc	a0,0x5
    80003158:	2cc50513          	addi	a0,a0,716 # 80008420 <states.0+0xd0>
    8000315c:	ffffd097          	auipc	ra,0xffffd
    80003160:	4da080e7          	jalr	1242(ra) # 80000636 <printf>
          p->killed = 1;
    80003164:	4785                	li	a5,1
    80003166:	d89c                	sw	a5,48(s1)
    80003168:	b79d                	j	800030ce <usertrap+0x160>
  asm volatile("csrr %0, scause" : "=r"(x));
    8000316a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000316e:	5c90                	lw	a2,56(s1)
    80003170:	00005517          	auipc	a0,0x5
    80003174:	2e850513          	addi	a0,a0,744 # 80008458 <states.0+0x108>
    80003178:	ffffd097          	auipc	ra,0xffffd
    8000317c:	4be080e7          	jalr	1214(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003180:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80003184:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003188:	00005517          	auipc	a0,0x5
    8000318c:	30050513          	addi	a0,a0,768 # 80008488 <states.0+0x138>
    80003190:	ffffd097          	auipc	ra,0xffffd
    80003194:	4a6080e7          	jalr	1190(ra) # 80000636 <printf>
    p->killed = 1;
    80003198:	4785                	li	a5,1
    8000319a:	d89c                	sw	a5,48(s1)
    8000319c:	bf0d                	j	800030ce <usertrap+0x160>
  if (p->killed)
    8000319e:	589c                	lw	a5,48(s1)
    800031a0:	df85                	beqz	a5,800030d8 <usertrap+0x16a>
    800031a2:	b735                	j	800030ce <usertrap+0x160>
    800031a4:	4981                	li	s3,0
    800031a6:	b725                	j	800030ce <usertrap+0x160>

00000000800031a8 <kerneltrap>:
void kerneltrap() {
    800031a8:	7179                	addi	sp,sp,-48
    800031aa:	f406                	sd	ra,40(sp)
    800031ac:	f022                	sd	s0,32(sp)
    800031ae:	ec26                	sd	s1,24(sp)
    800031b0:	e84a                	sd	s2,16(sp)
    800031b2:	e44e                	sd	s3,8(sp)
    800031b4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800031b6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800031ba:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800031be:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800031c2:	1004f793          	andi	a5,s1,256
    800031c6:	cb85                	beqz	a5,800031f6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800031c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800031cc:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800031ce:	ef85                	bnez	a5,80003206 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	cfc080e7          	jalr	-772(ra) # 80002ecc <devintr>
    800031d8:	cd1d                	beqz	a0,80003216 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031da:	4789                	li	a5,2
    800031dc:	06f50a63          	beq	a0,a5,80003250 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800031e0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800031e4:	10049073          	csrw	sstatus,s1
}
    800031e8:	70a2                	ld	ra,40(sp)
    800031ea:	7402                	ld	s0,32(sp)
    800031ec:	64e2                	ld	s1,24(sp)
    800031ee:	6942                	ld	s2,16(sp)
    800031f0:	69a2                	ld	s3,8(sp)
    800031f2:	6145                	addi	sp,sp,48
    800031f4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800031f6:	00005517          	auipc	a0,0x5
    800031fa:	2b250513          	addi	a0,a0,690 # 800084a8 <states.0+0x158>
    800031fe:	ffffd097          	auipc	ra,0xffffd
    80003202:	3e6080e7          	jalr	998(ra) # 800005e4 <panic>
    panic("kerneltrap: interrupts enabled");
    80003206:	00005517          	auipc	a0,0x5
    8000320a:	2ca50513          	addi	a0,a0,714 # 800084d0 <states.0+0x180>
    8000320e:	ffffd097          	auipc	ra,0xffffd
    80003212:	3d6080e7          	jalr	982(ra) # 800005e4 <panic>
    printf("scause %p\n", scause);
    80003216:	85ce                	mv	a1,s3
    80003218:	00005517          	auipc	a0,0x5
    8000321c:	2d850513          	addi	a0,a0,728 # 800084f0 <states.0+0x1a0>
    80003220:	ffffd097          	auipc	ra,0xffffd
    80003224:	416080e7          	jalr	1046(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003228:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000322c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003230:	00005517          	auipc	a0,0x5
    80003234:	2d050513          	addi	a0,a0,720 # 80008500 <states.0+0x1b0>
    80003238:	ffffd097          	auipc	ra,0xffffd
    8000323c:	3fe080e7          	jalr	1022(ra) # 80000636 <printf>
    panic("kerneltrap");
    80003240:	00005517          	auipc	a0,0x5
    80003244:	2d850513          	addi	a0,a0,728 # 80008518 <states.0+0x1c8>
    80003248:	ffffd097          	auipc	ra,0xffffd
    8000324c:	39c080e7          	jalr	924(ra) # 800005e4 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003250:	fffff097          	auipc	ra,0xfffff
    80003254:	eba080e7          	jalr	-326(ra) # 8000210a <myproc>
    80003258:	d541                	beqz	a0,800031e0 <kerneltrap+0x38>
    8000325a:	fffff097          	auipc	ra,0xfffff
    8000325e:	eb0080e7          	jalr	-336(ra) # 8000210a <myproc>
    80003262:	4d18                	lw	a4,24(a0)
    80003264:	478d                	li	a5,3
    80003266:	f6f71de3          	bne	a4,a5,800031e0 <kerneltrap+0x38>
    yield();
    8000326a:	fffff097          	auipc	ra,0xfffff
    8000326e:	6e4080e7          	jalr	1764(ra) # 8000294e <yield>
    80003272:	b7bd                	j	800031e0 <kerneltrap+0x38>

0000000080003274 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003274:	1101                	addi	sp,sp,-32
    80003276:	ec06                	sd	ra,24(sp)
    80003278:	e822                	sd	s0,16(sp)
    8000327a:	e426                	sd	s1,8(sp)
    8000327c:	1000                	addi	s0,sp,32
    8000327e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003280:	fffff097          	auipc	ra,0xfffff
    80003284:	e8a080e7          	jalr	-374(ra) # 8000210a <myproc>
  switch (n) {
    80003288:	4795                	li	a5,5
    8000328a:	0497e163          	bltu	a5,s1,800032cc <argraw+0x58>
    8000328e:	048a                	slli	s1,s1,0x2
    80003290:	00005717          	auipc	a4,0x5
    80003294:	2c070713          	addi	a4,a4,704 # 80008550 <states.0+0x200>
    80003298:	94ba                	add	s1,s1,a4
    8000329a:	409c                	lw	a5,0(s1)
    8000329c:	97ba                	add	a5,a5,a4
    8000329e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800032a0:	6d3c                	ld	a5,88(a0)
    800032a2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800032a4:	60e2                	ld	ra,24(sp)
    800032a6:	6442                	ld	s0,16(sp)
    800032a8:	64a2                	ld	s1,8(sp)
    800032aa:	6105                	addi	sp,sp,32
    800032ac:	8082                	ret
    return p->trapframe->a1;
    800032ae:	6d3c                	ld	a5,88(a0)
    800032b0:	7fa8                	ld	a0,120(a5)
    800032b2:	bfcd                	j	800032a4 <argraw+0x30>
    return p->trapframe->a2;
    800032b4:	6d3c                	ld	a5,88(a0)
    800032b6:	63c8                	ld	a0,128(a5)
    800032b8:	b7f5                	j	800032a4 <argraw+0x30>
    return p->trapframe->a3;
    800032ba:	6d3c                	ld	a5,88(a0)
    800032bc:	67c8                	ld	a0,136(a5)
    800032be:	b7dd                	j	800032a4 <argraw+0x30>
    return p->trapframe->a4;
    800032c0:	6d3c                	ld	a5,88(a0)
    800032c2:	6bc8                	ld	a0,144(a5)
    800032c4:	b7c5                	j	800032a4 <argraw+0x30>
    return p->trapframe->a5;
    800032c6:	6d3c                	ld	a5,88(a0)
    800032c8:	6fc8                	ld	a0,152(a5)
    800032ca:	bfe9                	j	800032a4 <argraw+0x30>
  panic("argraw");
    800032cc:	00005517          	auipc	a0,0x5
    800032d0:	25c50513          	addi	a0,a0,604 # 80008528 <states.0+0x1d8>
    800032d4:	ffffd097          	auipc	ra,0xffffd
    800032d8:	310080e7          	jalr	784(ra) # 800005e4 <panic>

00000000800032dc <fetchaddr>:
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
    800032e8:	84aa                	mv	s1,a0
    800032ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	e1e080e7          	jalr	-482(ra) # 8000210a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800032f4:	653c                	ld	a5,72(a0)
    800032f6:	02f4f863          	bgeu	s1,a5,80003326 <fetchaddr+0x4a>
    800032fa:	00848713          	addi	a4,s1,8
    800032fe:	02e7e663          	bltu	a5,a4,8000332a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003302:	46a1                	li	a3,8
    80003304:	8626                	mv	a2,s1
    80003306:	85ca                	mv	a1,s2
    80003308:	6928                	ld	a0,80(a0)
    8000330a:	ffffe097          	auipc	ra,0xffffe
    8000330e:	4a2080e7          	jalr	1186(ra) # 800017ac <copyin>
    80003312:	00a03533          	snez	a0,a0
    80003316:	40a00533          	neg	a0,a0
}
    8000331a:	60e2                	ld	ra,24(sp)
    8000331c:	6442                	ld	s0,16(sp)
    8000331e:	64a2                	ld	s1,8(sp)
    80003320:	6902                	ld	s2,0(sp)
    80003322:	6105                	addi	sp,sp,32
    80003324:	8082                	ret
    return -1;
    80003326:	557d                	li	a0,-1
    80003328:	bfcd                	j	8000331a <fetchaddr+0x3e>
    8000332a:	557d                	li	a0,-1
    8000332c:	b7fd                	j	8000331a <fetchaddr+0x3e>

000000008000332e <fetchstr>:
{
    8000332e:	7179                	addi	sp,sp,-48
    80003330:	f406                	sd	ra,40(sp)
    80003332:	f022                	sd	s0,32(sp)
    80003334:	ec26                	sd	s1,24(sp)
    80003336:	e84a                	sd	s2,16(sp)
    80003338:	e44e                	sd	s3,8(sp)
    8000333a:	1800                	addi	s0,sp,48
    8000333c:	892a                	mv	s2,a0
    8000333e:	84ae                	mv	s1,a1
    80003340:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	dc8080e7          	jalr	-568(ra) # 8000210a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000334a:	86ce                	mv	a3,s3
    8000334c:	864a                	mv	a2,s2
    8000334e:	85a6                	mv	a1,s1
    80003350:	6928                	ld	a0,80(a0)
    80003352:	ffffe097          	auipc	ra,0xffffe
    80003356:	4e8080e7          	jalr	1256(ra) # 8000183a <copyinstr>
  if(err < 0)
    8000335a:	00054763          	bltz	a0,80003368 <fetchstr+0x3a>
  return strlen(buf);
    8000335e:	8526                	mv	a0,s1
    80003360:	ffffe097          	auipc	ra,0xffffe
    80003364:	c5a080e7          	jalr	-934(ra) # 80000fba <strlen>
}
    80003368:	70a2                	ld	ra,40(sp)
    8000336a:	7402                	ld	s0,32(sp)
    8000336c:	64e2                	ld	s1,24(sp)
    8000336e:	6942                	ld	s2,16(sp)
    80003370:	69a2                	ld	s3,8(sp)
    80003372:	6145                	addi	sp,sp,48
    80003374:	8082                	ret

0000000080003376 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003376:	1101                	addi	sp,sp,-32
    80003378:	ec06                	sd	ra,24(sp)
    8000337a:	e822                	sd	s0,16(sp)
    8000337c:	e426                	sd	s1,8(sp)
    8000337e:	1000                	addi	s0,sp,32
    80003380:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003382:	00000097          	auipc	ra,0x0
    80003386:	ef2080e7          	jalr	-270(ra) # 80003274 <argraw>
    8000338a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000338c:	4501                	li	a0,0
    8000338e:	60e2                	ld	ra,24(sp)
    80003390:	6442                	ld	s0,16(sp)
    80003392:	64a2                	ld	s1,8(sp)
    80003394:	6105                	addi	sp,sp,32
    80003396:	8082                	ret

0000000080003398 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003398:	1101                	addi	sp,sp,-32
    8000339a:	ec06                	sd	ra,24(sp)
    8000339c:	e822                	sd	s0,16(sp)
    8000339e:	e426                	sd	s1,8(sp)
    800033a0:	1000                	addi	s0,sp,32
    800033a2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	ed0080e7          	jalr	-304(ra) # 80003274 <argraw>
    800033ac:	e088                	sd	a0,0(s1)
  return 0;
}
    800033ae:	4501                	li	a0,0
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6105                	addi	sp,sp,32
    800033b8:	8082                	ret

00000000800033ba <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800033ba:	1101                	addi	sp,sp,-32
    800033bc:	ec06                	sd	ra,24(sp)
    800033be:	e822                	sd	s0,16(sp)
    800033c0:	e426                	sd	s1,8(sp)
    800033c2:	e04a                	sd	s2,0(sp)
    800033c4:	1000                	addi	s0,sp,32
    800033c6:	84ae                	mv	s1,a1
    800033c8:	8932                	mv	s2,a2
  *ip = argraw(n);
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	eaa080e7          	jalr	-342(ra) # 80003274 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800033d2:	864a                	mv	a2,s2
    800033d4:	85a6                	mv	a1,s1
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	f58080e7          	jalr	-168(ra) # 8000332e <fetchstr>
}
    800033de:	60e2                	ld	ra,24(sp)
    800033e0:	6442                	ld	s0,16(sp)
    800033e2:	64a2                	ld	s1,8(sp)
    800033e4:	6902                	ld	s2,0(sp)
    800033e6:	6105                	addi	sp,sp,32
    800033e8:	8082                	ret

00000000800033ea <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800033ea:	1101                	addi	sp,sp,-32
    800033ec:	ec06                	sd	ra,24(sp)
    800033ee:	e822                	sd	s0,16(sp)
    800033f0:	e426                	sd	s1,8(sp)
    800033f2:	e04a                	sd	s2,0(sp)
    800033f4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800033f6:	fffff097          	auipc	ra,0xfffff
    800033fa:	d14080e7          	jalr	-748(ra) # 8000210a <myproc>
    800033fe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003400:	05853903          	ld	s2,88(a0)
    80003404:	0a893783          	ld	a5,168(s2)
    80003408:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000340c:	37fd                	addiw	a5,a5,-1
    8000340e:	4751                	li	a4,20
    80003410:	00f76f63          	bltu	a4,a5,8000342e <syscall+0x44>
    80003414:	00369713          	slli	a4,a3,0x3
    80003418:	00005797          	auipc	a5,0x5
    8000341c:	15078793          	addi	a5,a5,336 # 80008568 <syscalls>
    80003420:	97ba                	add	a5,a5,a4
    80003422:	639c                	ld	a5,0(a5)
    80003424:	c789                	beqz	a5,8000342e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80003426:	9782                	jalr	a5
    80003428:	06a93823          	sd	a0,112(s2)
    8000342c:	a839                	j	8000344a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000342e:	15048613          	addi	a2,s1,336
    80003432:	5c8c                	lw	a1,56(s1)
    80003434:	00005517          	auipc	a0,0x5
    80003438:	0fc50513          	addi	a0,a0,252 # 80008530 <states.0+0x1e0>
    8000343c:	ffffd097          	auipc	ra,0xffffd
    80003440:	1fa080e7          	jalr	506(ra) # 80000636 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003444:	6cbc                	ld	a5,88(s1)
    80003446:	577d                	li	a4,-1
    80003448:	fbb8                	sd	a4,112(a5)
  }
}
    8000344a:	60e2                	ld	ra,24(sp)
    8000344c:	6442                	ld	s0,16(sp)
    8000344e:	64a2                	ld	s1,8(sp)
    80003450:	6902                	ld	s2,0(sp)
    80003452:	6105                	addi	sp,sp,32
    80003454:	8082                	ret

0000000080003456 <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    80003456:	1101                	addi	sp,sp,-32
    80003458:	ec06                	sd	ra,24(sp)
    8000345a:	e822                	sd	s0,16(sp)
    8000345c:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    8000345e:	fec40593          	addi	a1,s0,-20
    80003462:	4501                	li	a0,0
    80003464:	00000097          	auipc	ra,0x0
    80003468:	f12080e7          	jalr	-238(ra) # 80003376 <argint>
    return -1;
    8000346c:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    8000346e:	00054963          	bltz	a0,80003480 <sys_exit+0x2a>
  exit(n);
    80003472:	fec42503          	lw	a0,-20(s0)
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	396080e7          	jalr	918(ra) # 8000280c <exit>
  return 0; // not reached
    8000347e:	4781                	li	a5,0
}
    80003480:	853e                	mv	a0,a5
    80003482:	60e2                	ld	ra,24(sp)
    80003484:	6442                	ld	s0,16(sp)
    80003486:	6105                	addi	sp,sp,32
    80003488:	8082                	ret

000000008000348a <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000348a:	1141                	addi	sp,sp,-16
    8000348c:	e406                	sd	ra,8(sp)
    8000348e:	e022                	sd	s0,0(sp)
    80003490:	0800                	addi	s0,sp,16
    80003492:	fffff097          	auipc	ra,0xfffff
    80003496:	c78080e7          	jalr	-904(ra) # 8000210a <myproc>
    8000349a:	5d08                	lw	a0,56(a0)
    8000349c:	60a2                	ld	ra,8(sp)
    8000349e:	6402                	ld	s0,0(sp)
    800034a0:	0141                	addi	sp,sp,16
    800034a2:	8082                	ret

00000000800034a4 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800034a4:	1141                	addi	sp,sp,-16
    800034a6:	e406                	sd	ra,8(sp)
    800034a8:	e022                	sd	s0,0(sp)
    800034aa:	0800                	addi	s0,sp,16
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	052080e7          	jalr	82(ra) # 800024fe <fork>
    800034b4:	60a2                	ld	ra,8(sp)
    800034b6:	6402                	ld	s0,0(sp)
    800034b8:	0141                	addi	sp,sp,16
    800034ba:	8082                	ret

00000000800034bc <sys_wait>:

uint64 sys_wait(void) {
    800034bc:	1101                	addi	sp,sp,-32
    800034be:	ec06                	sd	ra,24(sp)
    800034c0:	e822                	sd	s0,16(sp)
    800034c2:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    800034c4:	fe840593          	addi	a1,s0,-24
    800034c8:	4501                	li	a0,0
    800034ca:	00000097          	auipc	ra,0x0
    800034ce:	ece080e7          	jalr	-306(ra) # 80003398 <argaddr>
    800034d2:	87aa                	mv	a5,a0
    return -1;
    800034d4:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    800034d6:	0007c863          	bltz	a5,800034e6 <sys_wait+0x2a>
  return wait(p);
    800034da:	fe843503          	ld	a0,-24(s0)
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	52a080e7          	jalr	1322(ra) # 80002a08 <wait>
}
    800034e6:	60e2                	ld	ra,24(sp)
    800034e8:	6442                	ld	s0,16(sp)
    800034ea:	6105                	addi	sp,sp,32
    800034ec:	8082                	ret

00000000800034ee <sys_sbrk>:

uint64 sys_sbrk(void) {
    800034ee:	7179                	addi	sp,sp,-48
    800034f0:	f406                	sd	ra,40(sp)
    800034f2:	f022                	sd	s0,32(sp)
    800034f4:	ec26                	sd	s1,24(sp)
    800034f6:	e84a                	sd	s2,16(sp)
    800034f8:	1800                	addi	s0,sp,48
  u64 addr;
  int n;

  if (argint(0, &n) < 0)
    800034fa:	fdc40593          	addi	a1,s0,-36
    800034fe:	4501                	li	a0,0
    80003500:	00000097          	auipc	ra,0x0
    80003504:	e76080e7          	jalr	-394(ra) # 80003376 <argint>
    return -1;
    80003508:	597d                	li	s2,-1
  if (argint(0, &n) < 0)
    8000350a:	02054963          	bltz	a0,8000353c <sys_sbrk+0x4e>
  struct proc *p = myproc();
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	bfc080e7          	jalr	-1028(ra) # 8000210a <myproc>
    80003516:	84aa                	mv	s1,a0
  addr = (u64)p->mem_layout.heap_start;
    80003518:	16853903          	ld	s2,360(a0)
  if (addr + n >= p->mem_layout.heap_size) {
    8000351c:	fdc42783          	lw	a5,-36(s0)
    80003520:	97ca                	add	a5,a5,s2
    80003522:	17053703          	ld	a4,368(a0)
    80003526:	02e7f263          	bgeu	a5,a4,8000354a <sys_sbrk+0x5c>
    p->killed = 1;
    printf("user heap momry overflow\n");
    printf("origin : %p after %p", addr, addr + n);
    exit(-1);
  }
  p->mem_layout.heap_start += n;
    8000352a:	fdc42783          	lw	a5,-36(s0)
    8000352e:	1684b603          	ld	a2,360(s1)
    80003532:	963e                	add	a2,a2,a5
    80003534:	16c4b423          	sd	a2,360(s1)
  if (n < 0) {
    80003538:	0407c563          	bltz	a5,80003582 <sys_sbrk+0x94>
    uvmdealloc(p->pagetable, addr, (u64)p->mem_layout.heap_start);
  }
  return addr;
}
    8000353c:	854a                	mv	a0,s2
    8000353e:	70a2                	ld	ra,40(sp)
    80003540:	7402                	ld	s0,32(sp)
    80003542:	64e2                	ld	s1,24(sp)
    80003544:	6942                	ld	s2,16(sp)
    80003546:	6145                	addi	sp,sp,48
    80003548:	8082                	ret
    p->killed = 1;
    8000354a:	4785                	li	a5,1
    8000354c:	d91c                	sw	a5,48(a0)
    printf("user heap momry overflow\n");
    8000354e:	00005517          	auipc	a0,0x5
    80003552:	0ca50513          	addi	a0,a0,202 # 80008618 <syscalls+0xb0>
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	0e0080e7          	jalr	224(ra) # 80000636 <printf>
    printf("origin : %p after %p", addr, addr + n);
    8000355e:	fdc42603          	lw	a2,-36(s0)
    80003562:	964a                	add	a2,a2,s2
    80003564:	85ca                	mv	a1,s2
    80003566:	00005517          	auipc	a0,0x5
    8000356a:	0d250513          	addi	a0,a0,210 # 80008638 <syscalls+0xd0>
    8000356e:	ffffd097          	auipc	ra,0xffffd
    80003572:	0c8080e7          	jalr	200(ra) # 80000636 <printf>
    exit(-1);
    80003576:	557d                	li	a0,-1
    80003578:	fffff097          	auipc	ra,0xfffff
    8000357c:	294080e7          	jalr	660(ra) # 8000280c <exit>
    80003580:	b76d                	j	8000352a <sys_sbrk+0x3c>
    uvmdealloc(p->pagetable, addr, (u64)p->mem_layout.heap_start);
    80003582:	85ca                	mv	a1,s2
    80003584:	68a8                	ld	a0,80(s1)
    80003586:	ffffe097          	auipc	ra,0xffffe
    8000358a:	fb2080e7          	jalr	-78(ra) # 80001538 <uvmdealloc>
    8000358e:	b77d                	j	8000353c <sys_sbrk+0x4e>

0000000080003590 <sys_sleep>:

uint64 sys_sleep(void) {
    80003590:	7139                	addi	sp,sp,-64
    80003592:	fc06                	sd	ra,56(sp)
    80003594:	f822                	sd	s0,48(sp)
    80003596:	f426                	sd	s1,40(sp)
    80003598:	f04a                	sd	s2,32(sp)
    8000359a:	ec4e                	sd	s3,24(sp)
    8000359c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    8000359e:	fcc40593          	addi	a1,s0,-52
    800035a2:	4501                	li	a0,0
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	dd2080e7          	jalr	-558(ra) # 80003376 <argint>
    return -1;
    800035ac:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800035ae:	06054563          	bltz	a0,80003618 <sys_sleep+0x88>
  acquire(&tickslock);
    800035b2:	00042517          	auipc	a0,0x42
    800035b6:	5c650513          	addi	a0,a0,1478 # 80045b78 <tickslock>
    800035ba:	ffffd097          	auipc	ra,0xffffd
    800035be:	780080e7          	jalr	1920(ra) # 80000d3a <acquire>
  ticks0 = ticks;
    800035c2:	00006917          	auipc	s2,0x6
    800035c6:	a5e92903          	lw	s2,-1442(s2) # 80009020 <ticks>
  while (ticks - ticks0 < n) {
    800035ca:	fcc42783          	lw	a5,-52(s0)
    800035ce:	cf85                	beqz	a5,80003606 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800035d0:	00042997          	auipc	s3,0x42
    800035d4:	5a898993          	addi	s3,s3,1448 # 80045b78 <tickslock>
    800035d8:	00006497          	auipc	s1,0x6
    800035dc:	a4848493          	addi	s1,s1,-1464 # 80009020 <ticks>
    if (myproc()->killed) {
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	b2a080e7          	jalr	-1238(ra) # 8000210a <myproc>
    800035e8:	591c                	lw	a5,48(a0)
    800035ea:	ef9d                	bnez	a5,80003628 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800035ec:	85ce                	mv	a1,s3
    800035ee:	8526                	mv	a0,s1
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	39a080e7          	jalr	922(ra) # 8000298a <sleep>
  while (ticks - ticks0 < n) {
    800035f8:	409c                	lw	a5,0(s1)
    800035fa:	412787bb          	subw	a5,a5,s2
    800035fe:	fcc42703          	lw	a4,-52(s0)
    80003602:	fce7efe3          	bltu	a5,a4,800035e0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003606:	00042517          	auipc	a0,0x42
    8000360a:	57250513          	addi	a0,a0,1394 # 80045b78 <tickslock>
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	7e0080e7          	jalr	2016(ra) # 80000dee <release>
  return 0;
    80003616:	4781                	li	a5,0
}
    80003618:	853e                	mv	a0,a5
    8000361a:	70e2                	ld	ra,56(sp)
    8000361c:	7442                	ld	s0,48(sp)
    8000361e:	74a2                	ld	s1,40(sp)
    80003620:	7902                	ld	s2,32(sp)
    80003622:	69e2                	ld	s3,24(sp)
    80003624:	6121                	addi	sp,sp,64
    80003626:	8082                	ret
      release(&tickslock);
    80003628:	00042517          	auipc	a0,0x42
    8000362c:	55050513          	addi	a0,a0,1360 # 80045b78 <tickslock>
    80003630:	ffffd097          	auipc	ra,0xffffd
    80003634:	7be080e7          	jalr	1982(ra) # 80000dee <release>
      return -1;
    80003638:	57fd                	li	a5,-1
    8000363a:	bff9                	j	80003618 <sys_sleep+0x88>

000000008000363c <sys_kill>:

uint64 sys_kill(void) {
    8000363c:	1101                	addi	sp,sp,-32
    8000363e:	ec06                	sd	ra,24(sp)
    80003640:	e822                	sd	s0,16(sp)
    80003642:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    80003644:	fec40593          	addi	a1,s0,-20
    80003648:	4501                	li	a0,0
    8000364a:	00000097          	auipc	ra,0x0
    8000364e:	d2c080e7          	jalr	-724(ra) # 80003376 <argint>
    80003652:	87aa                	mv	a5,a0
    return -1;
    80003654:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    80003656:	0007c863          	bltz	a5,80003666 <sys_kill+0x2a>
  return kill(pid);
    8000365a:	fec42503          	lw	a0,-20(s0)
    8000365e:	fffff097          	auipc	ra,0xfffff
    80003662:	516080e7          	jalr	1302(ra) # 80002b74 <kill>
}
    80003666:	60e2                	ld	ra,24(sp)
    80003668:	6442                	ld	s0,16(sp)
    8000366a:	6105                	addi	sp,sp,32
    8000366c:	8082                	ret

000000008000366e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    8000366e:	1101                	addi	sp,sp,-32
    80003670:	ec06                	sd	ra,24(sp)
    80003672:	e822                	sd	s0,16(sp)
    80003674:	e426                	sd	s1,8(sp)
    80003676:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003678:	00042517          	auipc	a0,0x42
    8000367c:	50050513          	addi	a0,a0,1280 # 80045b78 <tickslock>
    80003680:	ffffd097          	auipc	ra,0xffffd
    80003684:	6ba080e7          	jalr	1722(ra) # 80000d3a <acquire>
  xticks = ticks;
    80003688:	00006497          	auipc	s1,0x6
    8000368c:	9984a483          	lw	s1,-1640(s1) # 80009020 <ticks>
  release(&tickslock);
    80003690:	00042517          	auipc	a0,0x42
    80003694:	4e850513          	addi	a0,a0,1256 # 80045b78 <tickslock>
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	756080e7          	jalr	1878(ra) # 80000dee <release>
  return xticks;
}
    800036a0:	02049513          	slli	a0,s1,0x20
    800036a4:	9101                	srli	a0,a0,0x20
    800036a6:	60e2                	ld	ra,24(sp)
    800036a8:	6442                	ld	s0,16(sp)
    800036aa:	64a2                	ld	s1,8(sp)
    800036ac:	6105                	addi	sp,sp,32
    800036ae:	8082                	ret

00000000800036b0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800036b0:	7179                	addi	sp,sp,-48
    800036b2:	f406                	sd	ra,40(sp)
    800036b4:	f022                	sd	s0,32(sp)
    800036b6:	ec26                	sd	s1,24(sp)
    800036b8:	e84a                	sd	s2,16(sp)
    800036ba:	e44e                	sd	s3,8(sp)
    800036bc:	e052                	sd	s4,0(sp)
    800036be:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800036c0:	00005597          	auipc	a1,0x5
    800036c4:	f9058593          	addi	a1,a1,-112 # 80008650 <syscalls+0xe8>
    800036c8:	00042517          	auipc	a0,0x42
    800036cc:	4c850513          	addi	a0,a0,1224 # 80045b90 <bcache>
    800036d0:	ffffd097          	auipc	ra,0xffffd
    800036d4:	5da080e7          	jalr	1498(ra) # 80000caa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800036d8:	0004a797          	auipc	a5,0x4a
    800036dc:	4b878793          	addi	a5,a5,1208 # 8004db90 <bcache+0x8000>
    800036e0:	0004a717          	auipc	a4,0x4a
    800036e4:	71870713          	addi	a4,a4,1816 # 8004ddf8 <bcache+0x8268>
    800036e8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800036ec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800036f0:	00042497          	auipc	s1,0x42
    800036f4:	4b848493          	addi	s1,s1,1208 # 80045ba8 <bcache+0x18>
    b->next = bcache.head.next;
    800036f8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800036fa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800036fc:	00005a17          	auipc	s4,0x5
    80003700:	f5ca0a13          	addi	s4,s4,-164 # 80008658 <syscalls+0xf0>
    b->next = bcache.head.next;
    80003704:	2b893783          	ld	a5,696(s2)
    80003708:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000370a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000370e:	85d2                	mv	a1,s4
    80003710:	01048513          	addi	a0,s1,16
    80003714:	00001097          	auipc	ra,0x1
    80003718:	4b0080e7          	jalr	1200(ra) # 80004bc4 <initsleeplock>
    bcache.head.next->prev = b;
    8000371c:	2b893783          	ld	a5,696(s2)
    80003720:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003722:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003726:	45848493          	addi	s1,s1,1112
    8000372a:	fd349de3          	bne	s1,s3,80003704 <binit+0x54>
  }
}
    8000372e:	70a2                	ld	ra,40(sp)
    80003730:	7402                	ld	s0,32(sp)
    80003732:	64e2                	ld	s1,24(sp)
    80003734:	6942                	ld	s2,16(sp)
    80003736:	69a2                	ld	s3,8(sp)
    80003738:	6a02                	ld	s4,0(sp)
    8000373a:	6145                	addi	sp,sp,48
    8000373c:	8082                	ret

000000008000373e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000373e:	7179                	addi	sp,sp,-48
    80003740:	f406                	sd	ra,40(sp)
    80003742:	f022                	sd	s0,32(sp)
    80003744:	ec26                	sd	s1,24(sp)
    80003746:	e84a                	sd	s2,16(sp)
    80003748:	e44e                	sd	s3,8(sp)
    8000374a:	1800                	addi	s0,sp,48
    8000374c:	892a                	mv	s2,a0
    8000374e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003750:	00042517          	auipc	a0,0x42
    80003754:	44050513          	addi	a0,a0,1088 # 80045b90 <bcache>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	5e2080e7          	jalr	1506(ra) # 80000d3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003760:	0004a497          	auipc	s1,0x4a
    80003764:	6e84b483          	ld	s1,1768(s1) # 8004de48 <bcache+0x82b8>
    80003768:	0004a797          	auipc	a5,0x4a
    8000376c:	69078793          	addi	a5,a5,1680 # 8004ddf8 <bcache+0x8268>
    80003770:	02f48f63          	beq	s1,a5,800037ae <bread+0x70>
    80003774:	873e                	mv	a4,a5
    80003776:	a021                	j	8000377e <bread+0x40>
    80003778:	68a4                	ld	s1,80(s1)
    8000377a:	02e48a63          	beq	s1,a4,800037ae <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000377e:	449c                	lw	a5,8(s1)
    80003780:	ff279ce3          	bne	a5,s2,80003778 <bread+0x3a>
    80003784:	44dc                	lw	a5,12(s1)
    80003786:	ff3799e3          	bne	a5,s3,80003778 <bread+0x3a>
      b->refcnt++;
    8000378a:	40bc                	lw	a5,64(s1)
    8000378c:	2785                	addiw	a5,a5,1
    8000378e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003790:	00042517          	auipc	a0,0x42
    80003794:	40050513          	addi	a0,a0,1024 # 80045b90 <bcache>
    80003798:	ffffd097          	auipc	ra,0xffffd
    8000379c:	656080e7          	jalr	1622(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    800037a0:	01048513          	addi	a0,s1,16
    800037a4:	00001097          	auipc	ra,0x1
    800037a8:	45a080e7          	jalr	1114(ra) # 80004bfe <acquiresleep>
      return b;
    800037ac:	a8b9                	j	8000380a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037ae:	0004a497          	auipc	s1,0x4a
    800037b2:	6924b483          	ld	s1,1682(s1) # 8004de40 <bcache+0x82b0>
    800037b6:	0004a797          	auipc	a5,0x4a
    800037ba:	64278793          	addi	a5,a5,1602 # 8004ddf8 <bcache+0x8268>
    800037be:	00f48863          	beq	s1,a5,800037ce <bread+0x90>
    800037c2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800037c4:	40bc                	lw	a5,64(s1)
    800037c6:	cf81                	beqz	a5,800037de <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037c8:	64a4                	ld	s1,72(s1)
    800037ca:	fee49de3          	bne	s1,a4,800037c4 <bread+0x86>
  panic("bget: no buffers");
    800037ce:	00005517          	auipc	a0,0x5
    800037d2:	e9250513          	addi	a0,a0,-366 # 80008660 <syscalls+0xf8>
    800037d6:	ffffd097          	auipc	ra,0xffffd
    800037da:	e0e080e7          	jalr	-498(ra) # 800005e4 <panic>
      b->dev = dev;
    800037de:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800037e2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800037e6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800037ea:	4785                	li	a5,1
    800037ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800037ee:	00042517          	auipc	a0,0x42
    800037f2:	3a250513          	addi	a0,a0,930 # 80045b90 <bcache>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	5f8080e7          	jalr	1528(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    800037fe:	01048513          	addi	a0,s1,16
    80003802:	00001097          	auipc	ra,0x1
    80003806:	3fc080e7          	jalr	1020(ra) # 80004bfe <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000380a:	409c                	lw	a5,0(s1)
    8000380c:	cb89                	beqz	a5,8000381e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000380e:	8526                	mv	a0,s1
    80003810:	70a2                	ld	ra,40(sp)
    80003812:	7402                	ld	s0,32(sp)
    80003814:	64e2                	ld	s1,24(sp)
    80003816:	6942                	ld	s2,16(sp)
    80003818:	69a2                	ld	s3,8(sp)
    8000381a:	6145                	addi	sp,sp,48
    8000381c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000381e:	4581                	li	a1,0
    80003820:	8526                	mv	a0,s1
    80003822:	00003097          	auipc	ra,0x3
    80003826:	f2a080e7          	jalr	-214(ra) # 8000674c <virtio_disk_rw>
    b->valid = 1;
    8000382a:	4785                	li	a5,1
    8000382c:	c09c                	sw	a5,0(s1)
  return b;
    8000382e:	b7c5                	j	8000380e <bread+0xd0>

0000000080003830 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003830:	1101                	addi	sp,sp,-32
    80003832:	ec06                	sd	ra,24(sp)
    80003834:	e822                	sd	s0,16(sp)
    80003836:	e426                	sd	s1,8(sp)
    80003838:	1000                	addi	s0,sp,32
    8000383a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000383c:	0541                	addi	a0,a0,16
    8000383e:	00001097          	auipc	ra,0x1
    80003842:	45a080e7          	jalr	1114(ra) # 80004c98 <holdingsleep>
    80003846:	cd01                	beqz	a0,8000385e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003848:	4585                	li	a1,1
    8000384a:	8526                	mv	a0,s1
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	f00080e7          	jalr	-256(ra) # 8000674c <virtio_disk_rw>
}
    80003854:	60e2                	ld	ra,24(sp)
    80003856:	6442                	ld	s0,16(sp)
    80003858:	64a2                	ld	s1,8(sp)
    8000385a:	6105                	addi	sp,sp,32
    8000385c:	8082                	ret
    panic("bwrite");
    8000385e:	00005517          	auipc	a0,0x5
    80003862:	e1a50513          	addi	a0,a0,-486 # 80008678 <syscalls+0x110>
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	d7e080e7          	jalr	-642(ra) # 800005e4 <panic>

000000008000386e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000386e:	1101                	addi	sp,sp,-32
    80003870:	ec06                	sd	ra,24(sp)
    80003872:	e822                	sd	s0,16(sp)
    80003874:	e426                	sd	s1,8(sp)
    80003876:	e04a                	sd	s2,0(sp)
    80003878:	1000                	addi	s0,sp,32
    8000387a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000387c:	01050913          	addi	s2,a0,16
    80003880:	854a                	mv	a0,s2
    80003882:	00001097          	auipc	ra,0x1
    80003886:	416080e7          	jalr	1046(ra) # 80004c98 <holdingsleep>
    8000388a:	c92d                	beqz	a0,800038fc <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000388c:	854a                	mv	a0,s2
    8000388e:	00001097          	auipc	ra,0x1
    80003892:	3c6080e7          	jalr	966(ra) # 80004c54 <releasesleep>

  acquire(&bcache.lock);
    80003896:	00042517          	auipc	a0,0x42
    8000389a:	2fa50513          	addi	a0,a0,762 # 80045b90 <bcache>
    8000389e:	ffffd097          	auipc	ra,0xffffd
    800038a2:	49c080e7          	jalr	1180(ra) # 80000d3a <acquire>
  b->refcnt--;
    800038a6:	40bc                	lw	a5,64(s1)
    800038a8:	37fd                	addiw	a5,a5,-1
    800038aa:	0007871b          	sext.w	a4,a5
    800038ae:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800038b0:	eb05                	bnez	a4,800038e0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800038b2:	68bc                	ld	a5,80(s1)
    800038b4:	64b8                	ld	a4,72(s1)
    800038b6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800038b8:	64bc                	ld	a5,72(s1)
    800038ba:	68b8                	ld	a4,80(s1)
    800038bc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800038be:	0004a797          	auipc	a5,0x4a
    800038c2:	2d278793          	addi	a5,a5,722 # 8004db90 <bcache+0x8000>
    800038c6:	2b87b703          	ld	a4,696(a5)
    800038ca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800038cc:	0004a717          	auipc	a4,0x4a
    800038d0:	52c70713          	addi	a4,a4,1324 # 8004ddf8 <bcache+0x8268>
    800038d4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800038d6:	2b87b703          	ld	a4,696(a5)
    800038da:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800038dc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800038e0:	00042517          	auipc	a0,0x42
    800038e4:	2b050513          	addi	a0,a0,688 # 80045b90 <bcache>
    800038e8:	ffffd097          	auipc	ra,0xffffd
    800038ec:	506080e7          	jalr	1286(ra) # 80000dee <release>
}
    800038f0:	60e2                	ld	ra,24(sp)
    800038f2:	6442                	ld	s0,16(sp)
    800038f4:	64a2                	ld	s1,8(sp)
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret
    panic("brelse");
    800038fc:	00005517          	auipc	a0,0x5
    80003900:	d8450513          	addi	a0,a0,-636 # 80008680 <syscalls+0x118>
    80003904:	ffffd097          	auipc	ra,0xffffd
    80003908:	ce0080e7          	jalr	-800(ra) # 800005e4 <panic>

000000008000390c <bpin>:

void
bpin(struct buf *b) {
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	e426                	sd	s1,8(sp)
    80003914:	1000                	addi	s0,sp,32
    80003916:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003918:	00042517          	auipc	a0,0x42
    8000391c:	27850513          	addi	a0,a0,632 # 80045b90 <bcache>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	41a080e7          	jalr	1050(ra) # 80000d3a <acquire>
  b->refcnt++;
    80003928:	40bc                	lw	a5,64(s1)
    8000392a:	2785                	addiw	a5,a5,1
    8000392c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000392e:	00042517          	auipc	a0,0x42
    80003932:	26250513          	addi	a0,a0,610 # 80045b90 <bcache>
    80003936:	ffffd097          	auipc	ra,0xffffd
    8000393a:	4b8080e7          	jalr	1208(ra) # 80000dee <release>
}
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	64a2                	ld	s1,8(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <bunpin>:

void
bunpin(struct buf *b) {
    80003948:	1101                	addi	sp,sp,-32
    8000394a:	ec06                	sd	ra,24(sp)
    8000394c:	e822                	sd	s0,16(sp)
    8000394e:	e426                	sd	s1,8(sp)
    80003950:	1000                	addi	s0,sp,32
    80003952:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003954:	00042517          	auipc	a0,0x42
    80003958:	23c50513          	addi	a0,a0,572 # 80045b90 <bcache>
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	3de080e7          	jalr	990(ra) # 80000d3a <acquire>
  b->refcnt--;
    80003964:	40bc                	lw	a5,64(s1)
    80003966:	37fd                	addiw	a5,a5,-1
    80003968:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000396a:	00042517          	auipc	a0,0x42
    8000396e:	22650513          	addi	a0,a0,550 # 80045b90 <bcache>
    80003972:	ffffd097          	auipc	ra,0xffffd
    80003976:	47c080e7          	jalr	1148(ra) # 80000dee <release>
}
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	64a2                	ld	s1,8(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret

0000000080003984 <bfree>:
  }
  panic("balloc: out of blocks");
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003992:	00d5d59b          	srliw	a1,a1,0xd
    80003996:	0004b797          	auipc	a5,0x4b
    8000399a:	8d67a783          	lw	a5,-1834(a5) # 8004e26c <sb+0x1c>
    8000399e:	9dbd                	addw	a1,a1,a5
    800039a0:	00000097          	auipc	ra,0x0
    800039a4:	d9e080e7          	jalr	-610(ra) # 8000373e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800039a8:	0074f713          	andi	a4,s1,7
    800039ac:	4785                	li	a5,1
    800039ae:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    800039b2:	14ce                	slli	s1,s1,0x33
    800039b4:	90d9                	srli	s1,s1,0x36
    800039b6:	00950733          	add	a4,a0,s1
    800039ba:	05874703          	lbu	a4,88(a4)
    800039be:	00e7f6b3          	and	a3,a5,a4
    800039c2:	c69d                	beqz	a3,800039f0 <bfree+0x6c>
    800039c4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    800039c6:	94aa                	add	s1,s1,a0
    800039c8:	fff7c793          	not	a5,a5
    800039cc:	8ff9                	and	a5,a5,a4
    800039ce:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800039d2:	00001097          	auipc	ra,0x1
    800039d6:	104080e7          	jalr	260(ra) # 80004ad6 <log_write>
  brelse(bp);
    800039da:	854a                	mv	a0,s2
    800039dc:	00000097          	auipc	ra,0x0
    800039e0:	e92080e7          	jalr	-366(ra) # 8000386e <brelse>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret
    panic("freeing free block");
    800039f0:	00005517          	auipc	a0,0x5
    800039f4:	c9850513          	addi	a0,a0,-872 # 80008688 <syscalls+0x120>
    800039f8:	ffffd097          	auipc	ra,0xffffd
    800039fc:	bec080e7          	jalr	-1044(ra) # 800005e4 <panic>

0000000080003a00 <balloc>:
static uint balloc(uint dev) {
    80003a00:	711d                	addi	sp,sp,-96
    80003a02:	ec86                	sd	ra,88(sp)
    80003a04:	e8a2                	sd	s0,80(sp)
    80003a06:	e4a6                	sd	s1,72(sp)
    80003a08:	e0ca                	sd	s2,64(sp)
    80003a0a:	fc4e                	sd	s3,56(sp)
    80003a0c:	f852                	sd	s4,48(sp)
    80003a0e:	f456                	sd	s5,40(sp)
    80003a10:	f05a                	sd	s6,32(sp)
    80003a12:	ec5e                	sd	s7,24(sp)
    80003a14:	e862                	sd	s8,16(sp)
    80003a16:	e466                	sd	s9,8(sp)
    80003a18:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    80003a1a:	0004b797          	auipc	a5,0x4b
    80003a1e:	83a7a783          	lw	a5,-1990(a5) # 8004e254 <sb+0x4>
    80003a22:	cbd1                	beqz	a5,80003ab6 <balloc+0xb6>
    80003a24:	8baa                	mv	s7,a0
    80003a26:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003a28:	0004bb17          	auipc	s6,0x4b
    80003a2c:	828b0b13          	addi	s6,s6,-2008 # 8004e250 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003a30:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003a32:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003a34:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80003a36:	6c89                	lui	s9,0x2
    80003a38:	a831                	j	80003a54 <balloc+0x54>
    brelse(bp);
    80003a3a:	854a                	mv	a0,s2
    80003a3c:	00000097          	auipc	ra,0x0
    80003a40:	e32080e7          	jalr	-462(ra) # 8000386e <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80003a44:	015c87bb          	addw	a5,s9,s5
    80003a48:	00078a9b          	sext.w	s5,a5
    80003a4c:	004b2703          	lw	a4,4(s6)
    80003a50:	06eaf363          	bgeu	s5,a4,80003ab6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003a54:	41fad79b          	sraiw	a5,s5,0x1f
    80003a58:	0137d79b          	srliw	a5,a5,0x13
    80003a5c:	015787bb          	addw	a5,a5,s5
    80003a60:	40d7d79b          	sraiw	a5,a5,0xd
    80003a64:	01cb2583          	lw	a1,28(s6)
    80003a68:	9dbd                	addw	a1,a1,a5
    80003a6a:	855e                	mv	a0,s7
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	cd2080e7          	jalr	-814(ra) # 8000373e <bread>
    80003a74:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003a76:	004b2503          	lw	a0,4(s6)
    80003a7a:	000a849b          	sext.w	s1,s5
    80003a7e:	8662                	mv	a2,s8
    80003a80:	faa4fde3          	bgeu	s1,a0,80003a3a <balloc+0x3a>
      m = 1 << (bi % 8);
    80003a84:	41f6579b          	sraiw	a5,a2,0x1f
    80003a88:	01d7d69b          	srliw	a3,a5,0x1d
    80003a8c:	00c6873b          	addw	a4,a3,a2
    80003a90:	00777793          	andi	a5,a4,7
    80003a94:	9f95                	subw	a5,a5,a3
    80003a96:	00f997bb          	sllw	a5,s3,a5
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80003a9a:	4037571b          	sraiw	a4,a4,0x3
    80003a9e:	00e906b3          	add	a3,s2,a4
    80003aa2:	0586c683          	lbu	a3,88(a3)
    80003aa6:	00d7f5b3          	and	a1,a5,a3
    80003aaa:	cd91                	beqz	a1,80003ac6 <balloc+0xc6>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003aac:	2605                	addiw	a2,a2,1
    80003aae:	2485                	addiw	s1,s1,1
    80003ab0:	fd4618e3          	bne	a2,s4,80003a80 <balloc+0x80>
    80003ab4:	b759                	j	80003a3a <balloc+0x3a>
  panic("balloc: out of blocks");
    80003ab6:	00005517          	auipc	a0,0x5
    80003aba:	bea50513          	addi	a0,a0,-1046 # 800086a0 <syscalls+0x138>
    80003abe:	ffffd097          	auipc	ra,0xffffd
    80003ac2:	b26080e7          	jalr	-1242(ra) # 800005e4 <panic>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80003ac6:	974a                	add	a4,a4,s2
    80003ac8:	8fd5                	or	a5,a5,a3
    80003aca:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003ace:	854a                	mv	a0,s2
    80003ad0:	00001097          	auipc	ra,0x1
    80003ad4:	006080e7          	jalr	6(ra) # 80004ad6 <log_write>
        brelse(bp);
    80003ad8:	854a                	mv	a0,s2
    80003ada:	00000097          	auipc	ra,0x0
    80003ade:	d94080e7          	jalr	-620(ra) # 8000386e <brelse>
  bp = bread(dev, bno);
    80003ae2:	85a6                	mv	a1,s1
    80003ae4:	855e                	mv	a0,s7
    80003ae6:	00000097          	auipc	ra,0x0
    80003aea:	c58080e7          	jalr	-936(ra) # 8000373e <bread>
    80003aee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003af0:	40000613          	li	a2,1024
    80003af4:	4581                	li	a1,0
    80003af6:	05850513          	addi	a0,a0,88
    80003afa:	ffffd097          	auipc	ra,0xffffd
    80003afe:	33c080e7          	jalr	828(ra) # 80000e36 <memset>
  log_write(bp);
    80003b02:	854a                	mv	a0,s2
    80003b04:	00001097          	auipc	ra,0x1
    80003b08:	fd2080e7          	jalr	-46(ra) # 80004ad6 <log_write>
  brelse(bp);
    80003b0c:	854a                	mv	a0,s2
    80003b0e:	00000097          	auipc	ra,0x0
    80003b12:	d60080e7          	jalr	-672(ra) # 8000386e <brelse>
}
    80003b16:	8526                	mv	a0,s1
    80003b18:	60e6                	ld	ra,88(sp)
    80003b1a:	6446                	ld	s0,80(sp)
    80003b1c:	64a6                	ld	s1,72(sp)
    80003b1e:	6906                	ld	s2,64(sp)
    80003b20:	79e2                	ld	s3,56(sp)
    80003b22:	7a42                	ld	s4,48(sp)
    80003b24:	7aa2                	ld	s5,40(sp)
    80003b26:	7b02                	ld	s6,32(sp)
    80003b28:	6be2                	ld	s7,24(sp)
    80003b2a:	6c42                	ld	s8,16(sp)
    80003b2c:	6ca2                	ld	s9,8(sp)
    80003b2e:	6125                	addi	sp,sp,96
    80003b30:	8082                	ret

0000000080003b32 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
    80003b32:	7179                	addi	sp,sp,-48
    80003b34:	f406                	sd	ra,40(sp)
    80003b36:	f022                	sd	s0,32(sp)
    80003b38:	ec26                	sd	s1,24(sp)
    80003b3a:	e84a                	sd	s2,16(sp)
    80003b3c:	e44e                	sd	s3,8(sp)
    80003b3e:	e052                	sd	s4,0(sp)
    80003b40:	1800                	addi	s0,sp,48
    80003b42:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003b44:	47ad                	li	a5,11
    80003b46:	04b7fe63          	bgeu	a5,a1,80003ba2 <bmap+0x70>
    if ((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003b4a:	ff45849b          	addiw	s1,a1,-12
    80003b4e:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80003b52:	0ff00793          	li	a5,255
    80003b56:	0ae7e363          	bltu	a5,a4,80003bfc <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0)
    80003b5a:	08052583          	lw	a1,128(a0)
    80003b5e:	c5ad                	beqz	a1,80003bc8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003b60:	00092503          	lw	a0,0(s2)
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	bda080e7          	jalr	-1062(ra) # 8000373e <bread>
    80003b6c:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80003b6e:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80003b72:	02049593          	slli	a1,s1,0x20
    80003b76:	9181                	srli	a1,a1,0x20
    80003b78:	058a                	slli	a1,a1,0x2
    80003b7a:	00b784b3          	add	s1,a5,a1
    80003b7e:	0004a983          	lw	s3,0(s1)
    80003b82:	04098d63          	beqz	s3,80003bdc <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003b86:	8552                	mv	a0,s4
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	ce6080e7          	jalr	-794(ra) # 8000386e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003b90:	854e                	mv	a0,s3
    80003b92:	70a2                	ld	ra,40(sp)
    80003b94:	7402                	ld	s0,32(sp)
    80003b96:	64e2                	ld	s1,24(sp)
    80003b98:	6942                	ld	s2,16(sp)
    80003b9a:	69a2                	ld	s3,8(sp)
    80003b9c:	6a02                	ld	s4,0(sp)
    80003b9e:	6145                	addi	sp,sp,48
    80003ba0:	8082                	ret
    if ((addr = ip->addrs[bn]) == 0)
    80003ba2:	02059493          	slli	s1,a1,0x20
    80003ba6:	9081                	srli	s1,s1,0x20
    80003ba8:	048a                	slli	s1,s1,0x2
    80003baa:	94aa                	add	s1,s1,a0
    80003bac:	0504a983          	lw	s3,80(s1)
    80003bb0:	fe0990e3          	bnez	s3,80003b90 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003bb4:	4108                	lw	a0,0(a0)
    80003bb6:	00000097          	auipc	ra,0x0
    80003bba:	e4a080e7          	jalr	-438(ra) # 80003a00 <balloc>
    80003bbe:	0005099b          	sext.w	s3,a0
    80003bc2:	0534a823          	sw	s3,80(s1)
    80003bc6:	b7e9                	j	80003b90 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003bc8:	4108                	lw	a0,0(a0)
    80003bca:	00000097          	auipc	ra,0x0
    80003bce:	e36080e7          	jalr	-458(ra) # 80003a00 <balloc>
    80003bd2:	0005059b          	sext.w	a1,a0
    80003bd6:	08b92023          	sw	a1,128(s2)
    80003bda:	b759                	j	80003b60 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003bdc:	00092503          	lw	a0,0(s2)
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	e20080e7          	jalr	-480(ra) # 80003a00 <balloc>
    80003be8:	0005099b          	sext.w	s3,a0
    80003bec:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003bf0:	8552                	mv	a0,s4
    80003bf2:	00001097          	auipc	ra,0x1
    80003bf6:	ee4080e7          	jalr	-284(ra) # 80004ad6 <log_write>
    80003bfa:	b771                	j	80003b86 <bmap+0x54>
  panic("bmap: out of range");
    80003bfc:	00005517          	auipc	a0,0x5
    80003c00:	abc50513          	addi	a0,a0,-1348 # 800086b8 <syscalls+0x150>
    80003c04:	ffffd097          	auipc	ra,0xffffd
    80003c08:	9e0080e7          	jalr	-1568(ra) # 800005e4 <panic>

0000000080003c0c <iget>:
static struct inode *iget(uint dev, uint inum) {
    80003c0c:	7179                	addi	sp,sp,-48
    80003c0e:	f406                	sd	ra,40(sp)
    80003c10:	f022                	sd	s0,32(sp)
    80003c12:	ec26                	sd	s1,24(sp)
    80003c14:	e84a                	sd	s2,16(sp)
    80003c16:	e44e                	sd	s3,8(sp)
    80003c18:	e052                	sd	s4,0(sp)
    80003c1a:	1800                	addi	s0,sp,48
    80003c1c:	89aa                	mv	s3,a0
    80003c1e:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003c20:	0004a517          	auipc	a0,0x4a
    80003c24:	65050513          	addi	a0,a0,1616 # 8004e270 <icache>
    80003c28:	ffffd097          	auipc	ra,0xffffd
    80003c2c:	112080e7          	jalr	274(ra) # 80000d3a <acquire>
  empty = 0;
    80003c30:	4901                	li	s2,0
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
    80003c32:	0004a497          	auipc	s1,0x4a
    80003c36:	65648493          	addi	s1,s1,1622 # 8004e288 <icache+0x18>
    80003c3a:	0004c697          	auipc	a3,0x4c
    80003c3e:	0de68693          	addi	a3,a3,222 # 8004fd18 <log>
    80003c42:	a039                	j	80003c50 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003c44:	02090b63          	beqz	s2,80003c7a <iget+0x6e>
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
    80003c48:	08848493          	addi	s1,s1,136
    80003c4c:	02d48a63          	beq	s1,a3,80003c80 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80003c50:	449c                	lw	a5,8(s1)
    80003c52:	fef059e3          	blez	a5,80003c44 <iget+0x38>
    80003c56:	4098                	lw	a4,0(s1)
    80003c58:	ff3716e3          	bne	a4,s3,80003c44 <iget+0x38>
    80003c5c:	40d8                	lw	a4,4(s1)
    80003c5e:	ff4713e3          	bne	a4,s4,80003c44 <iget+0x38>
      ip->ref++;
    80003c62:	2785                	addiw	a5,a5,1
    80003c64:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003c66:	0004a517          	auipc	a0,0x4a
    80003c6a:	60a50513          	addi	a0,a0,1546 # 8004e270 <icache>
    80003c6e:	ffffd097          	auipc	ra,0xffffd
    80003c72:	180080e7          	jalr	384(ra) # 80000dee <release>
      return ip;
    80003c76:	8926                	mv	s2,s1
    80003c78:	a03d                	j	80003ca6 <iget+0x9a>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003c7a:	f7f9                	bnez	a5,80003c48 <iget+0x3c>
    80003c7c:	8926                	mv	s2,s1
    80003c7e:	b7e9                	j	80003c48 <iget+0x3c>
  if (empty == 0)
    80003c80:	02090c63          	beqz	s2,80003cb8 <iget+0xac>
  ip->dev = dev;
    80003c84:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003c88:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003c8c:	4785                	li	a5,1
    80003c8e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003c92:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003c96:	0004a517          	auipc	a0,0x4a
    80003c9a:	5da50513          	addi	a0,a0,1498 # 8004e270 <icache>
    80003c9e:	ffffd097          	auipc	ra,0xffffd
    80003ca2:	150080e7          	jalr	336(ra) # 80000dee <release>
}
    80003ca6:	854a                	mv	a0,s2
    80003ca8:	70a2                	ld	ra,40(sp)
    80003caa:	7402                	ld	s0,32(sp)
    80003cac:	64e2                	ld	s1,24(sp)
    80003cae:	6942                	ld	s2,16(sp)
    80003cb0:	69a2                	ld	s3,8(sp)
    80003cb2:	6a02                	ld	s4,0(sp)
    80003cb4:	6145                	addi	sp,sp,48
    80003cb6:	8082                	ret
    panic("iget: no inodes");
    80003cb8:	00005517          	auipc	a0,0x5
    80003cbc:	a1850513          	addi	a0,a0,-1512 # 800086d0 <syscalls+0x168>
    80003cc0:	ffffd097          	auipc	ra,0xffffd
    80003cc4:	924080e7          	jalr	-1756(ra) # 800005e4 <panic>

0000000080003cc8 <fsinit>:
void fsinit(int dev) {
    80003cc8:	7179                	addi	sp,sp,-48
    80003cca:	f406                	sd	ra,40(sp)
    80003ccc:	f022                	sd	s0,32(sp)
    80003cce:	ec26                	sd	s1,24(sp)
    80003cd0:	e84a                	sd	s2,16(sp)
    80003cd2:	e44e                	sd	s3,8(sp)
    80003cd4:	1800                	addi	s0,sp,48
    80003cd6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003cd8:	4585                	li	a1,1
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	a64080e7          	jalr	-1436(ra) # 8000373e <bread>
    80003ce2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003ce4:	0004a997          	auipc	s3,0x4a
    80003ce8:	56c98993          	addi	s3,s3,1388 # 8004e250 <sb>
    80003cec:	02000613          	li	a2,32
    80003cf0:	05850593          	addi	a1,a0,88
    80003cf4:	854e                	mv	a0,s3
    80003cf6:	ffffd097          	auipc	ra,0xffffd
    80003cfa:	19c080e7          	jalr	412(ra) # 80000e92 <memmove>
  brelse(bp);
    80003cfe:	8526                	mv	a0,s1
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	b6e080e7          	jalr	-1170(ra) # 8000386e <brelse>
  if (sb.magic != FSMAGIC)
    80003d08:	0009a703          	lw	a4,0(s3)
    80003d0c:	102037b7          	lui	a5,0x10203
    80003d10:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d14:	02f71263          	bne	a4,a5,80003d38 <fsinit+0x70>
  initlog(dev, &sb);
    80003d18:	0004a597          	auipc	a1,0x4a
    80003d1c:	53858593          	addi	a1,a1,1336 # 8004e250 <sb>
    80003d20:	854a                	mv	a0,s2
    80003d22:	00001097          	auipc	ra,0x1
    80003d26:	b3c080e7          	jalr	-1220(ra) # 8000485e <initlog>
}
    80003d2a:	70a2                	ld	ra,40(sp)
    80003d2c:	7402                	ld	s0,32(sp)
    80003d2e:	64e2                	ld	s1,24(sp)
    80003d30:	6942                	ld	s2,16(sp)
    80003d32:	69a2                	ld	s3,8(sp)
    80003d34:	6145                	addi	sp,sp,48
    80003d36:	8082                	ret
    panic("invalid file system");
    80003d38:	00005517          	auipc	a0,0x5
    80003d3c:	9a850513          	addi	a0,a0,-1624 # 800086e0 <syscalls+0x178>
    80003d40:	ffffd097          	auipc	ra,0xffffd
    80003d44:	8a4080e7          	jalr	-1884(ra) # 800005e4 <panic>

0000000080003d48 <iinit>:
void iinit() {
    80003d48:	7179                	addi	sp,sp,-48
    80003d4a:	f406                	sd	ra,40(sp)
    80003d4c:	f022                	sd	s0,32(sp)
    80003d4e:	ec26                	sd	s1,24(sp)
    80003d50:	e84a                	sd	s2,16(sp)
    80003d52:	e44e                	sd	s3,8(sp)
    80003d54:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003d56:	00005597          	auipc	a1,0x5
    80003d5a:	9a258593          	addi	a1,a1,-1630 # 800086f8 <syscalls+0x190>
    80003d5e:	0004a517          	auipc	a0,0x4a
    80003d62:	51250513          	addi	a0,a0,1298 # 8004e270 <icache>
    80003d66:	ffffd097          	auipc	ra,0xffffd
    80003d6a:	f44080e7          	jalr	-188(ra) # 80000caa <initlock>
  for (i = 0; i < NINODE; i++) {
    80003d6e:	0004a497          	auipc	s1,0x4a
    80003d72:	52a48493          	addi	s1,s1,1322 # 8004e298 <icache+0x28>
    80003d76:	0004c997          	auipc	s3,0x4c
    80003d7a:	fb298993          	addi	s3,s3,-78 # 8004fd28 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003d7e:	00005917          	auipc	s2,0x5
    80003d82:	98290913          	addi	s2,s2,-1662 # 80008700 <syscalls+0x198>
    80003d86:	85ca                	mv	a1,s2
    80003d88:	8526                	mv	a0,s1
    80003d8a:	00001097          	auipc	ra,0x1
    80003d8e:	e3a080e7          	jalr	-454(ra) # 80004bc4 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003d92:	08848493          	addi	s1,s1,136
    80003d96:	ff3498e3          	bne	s1,s3,80003d86 <iinit+0x3e>
}
    80003d9a:	70a2                	ld	ra,40(sp)
    80003d9c:	7402                	ld	s0,32(sp)
    80003d9e:	64e2                	ld	s1,24(sp)
    80003da0:	6942                	ld	s2,16(sp)
    80003da2:	69a2                	ld	s3,8(sp)
    80003da4:	6145                	addi	sp,sp,48
    80003da6:	8082                	ret

0000000080003da8 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80003da8:	715d                	addi	sp,sp,-80
    80003daa:	e486                	sd	ra,72(sp)
    80003dac:	e0a2                	sd	s0,64(sp)
    80003dae:	fc26                	sd	s1,56(sp)
    80003db0:	f84a                	sd	s2,48(sp)
    80003db2:	f44e                	sd	s3,40(sp)
    80003db4:	f052                	sd	s4,32(sp)
    80003db6:	ec56                	sd	s5,24(sp)
    80003db8:	e85a                	sd	s6,16(sp)
    80003dba:	e45e                	sd	s7,8(sp)
    80003dbc:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003dbe:	0004a717          	auipc	a4,0x4a
    80003dc2:	49e72703          	lw	a4,1182(a4) # 8004e25c <sb+0xc>
    80003dc6:	4785                	li	a5,1
    80003dc8:	04e7fa63          	bgeu	a5,a4,80003e1c <ialloc+0x74>
    80003dcc:	8aaa                	mv	s5,a0
    80003dce:	8bae                	mv	s7,a1
    80003dd0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003dd2:	0004aa17          	auipc	s4,0x4a
    80003dd6:	47ea0a13          	addi	s4,s4,1150 # 8004e250 <sb>
    80003dda:	00048b1b          	sext.w	s6,s1
    80003dde:	0044d793          	srli	a5,s1,0x4
    80003de2:	018a2583          	lw	a1,24(s4)
    80003de6:	9dbd                	addw	a1,a1,a5
    80003de8:	8556                	mv	a0,s5
    80003dea:	00000097          	auipc	ra,0x0
    80003dee:	954080e7          	jalr	-1708(ra) # 8000373e <bread>
    80003df2:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003df4:	05850993          	addi	s3,a0,88
    80003df8:	00f4f793          	andi	a5,s1,15
    80003dfc:	079a                	slli	a5,a5,0x6
    80003dfe:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003e00:	00099783          	lh	a5,0(s3)
    80003e04:	c785                	beqz	a5,80003e2c <ialloc+0x84>
    brelse(bp);
    80003e06:	00000097          	auipc	ra,0x0
    80003e0a:	a68080e7          	jalr	-1432(ra) # 8000386e <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003e0e:	0485                	addi	s1,s1,1
    80003e10:	00ca2703          	lw	a4,12(s4)
    80003e14:	0004879b          	sext.w	a5,s1
    80003e18:	fce7e1e3          	bltu	a5,a4,80003dda <ialloc+0x32>
  panic("ialloc: no inodes");
    80003e1c:	00005517          	auipc	a0,0x5
    80003e20:	8ec50513          	addi	a0,a0,-1812 # 80008708 <syscalls+0x1a0>
    80003e24:	ffffc097          	auipc	ra,0xffffc
    80003e28:	7c0080e7          	jalr	1984(ra) # 800005e4 <panic>
      memset(dip, 0, sizeof(*dip));
    80003e2c:	04000613          	li	a2,64
    80003e30:	4581                	li	a1,0
    80003e32:	854e                	mv	a0,s3
    80003e34:	ffffd097          	auipc	ra,0xffffd
    80003e38:	002080e7          	jalr	2(ra) # 80000e36 <memset>
      dip->type = type;
    80003e3c:	01799023          	sh	s7,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003e40:	854a                	mv	a0,s2
    80003e42:	00001097          	auipc	ra,0x1
    80003e46:	c94080e7          	jalr	-876(ra) # 80004ad6 <log_write>
      brelse(bp);
    80003e4a:	854a                	mv	a0,s2
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	a22080e7          	jalr	-1502(ra) # 8000386e <brelse>
      return iget(dev, inum);
    80003e54:	85da                	mv	a1,s6
    80003e56:	8556                	mv	a0,s5
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	db4080e7          	jalr	-588(ra) # 80003c0c <iget>
}
    80003e60:	60a6                	ld	ra,72(sp)
    80003e62:	6406                	ld	s0,64(sp)
    80003e64:	74e2                	ld	s1,56(sp)
    80003e66:	7942                	ld	s2,48(sp)
    80003e68:	79a2                	ld	s3,40(sp)
    80003e6a:	7a02                	ld	s4,32(sp)
    80003e6c:	6ae2                	ld	s5,24(sp)
    80003e6e:	6b42                	ld	s6,16(sp)
    80003e70:	6ba2                	ld	s7,8(sp)
    80003e72:	6161                	addi	sp,sp,80
    80003e74:	8082                	ret

0000000080003e76 <iupdate>:
void iupdate(struct inode *ip) {
    80003e76:	1101                	addi	sp,sp,-32
    80003e78:	ec06                	sd	ra,24(sp)
    80003e7a:	e822                	sd	s0,16(sp)
    80003e7c:	e426                	sd	s1,8(sp)
    80003e7e:	e04a                	sd	s2,0(sp)
    80003e80:	1000                	addi	s0,sp,32
    80003e82:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e84:	415c                	lw	a5,4(a0)
    80003e86:	0047d79b          	srliw	a5,a5,0x4
    80003e8a:	0004a597          	auipc	a1,0x4a
    80003e8e:	3de5a583          	lw	a1,990(a1) # 8004e268 <sb+0x18>
    80003e92:	9dbd                	addw	a1,a1,a5
    80003e94:	4108                	lw	a0,0(a0)
    80003e96:	00000097          	auipc	ra,0x0
    80003e9a:	8a8080e7          	jalr	-1880(ra) # 8000373e <bread>
    80003e9e:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003ea0:	05850793          	addi	a5,a0,88
    80003ea4:	40c8                	lw	a0,4(s1)
    80003ea6:	893d                	andi	a0,a0,15
    80003ea8:	051a                	slli	a0,a0,0x6
    80003eaa:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003eac:	04449703          	lh	a4,68(s1)
    80003eb0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003eb4:	04649703          	lh	a4,70(s1)
    80003eb8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003ebc:	04849703          	lh	a4,72(s1)
    80003ec0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003ec4:	04a49703          	lh	a4,74(s1)
    80003ec8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003ecc:	44f8                	lw	a4,76(s1)
    80003ece:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003ed0:	03400613          	li	a2,52
    80003ed4:	05048593          	addi	a1,s1,80
    80003ed8:	0531                	addi	a0,a0,12
    80003eda:	ffffd097          	auipc	ra,0xffffd
    80003ede:	fb8080e7          	jalr	-72(ra) # 80000e92 <memmove>
  log_write(bp);
    80003ee2:	854a                	mv	a0,s2
    80003ee4:	00001097          	auipc	ra,0x1
    80003ee8:	bf2080e7          	jalr	-1038(ra) # 80004ad6 <log_write>
  brelse(bp);
    80003eec:	854a                	mv	a0,s2
    80003eee:	00000097          	auipc	ra,0x0
    80003ef2:	980080e7          	jalr	-1664(ra) # 8000386e <brelse>
}
    80003ef6:	60e2                	ld	ra,24(sp)
    80003ef8:	6442                	ld	s0,16(sp)
    80003efa:	64a2                	ld	s1,8(sp)
    80003efc:	6902                	ld	s2,0(sp)
    80003efe:	6105                	addi	sp,sp,32
    80003f00:	8082                	ret

0000000080003f02 <idup>:
struct inode *idup(struct inode *ip) {
    80003f02:	1101                	addi	sp,sp,-32
    80003f04:	ec06                	sd	ra,24(sp)
    80003f06:	e822                	sd	s0,16(sp)
    80003f08:	e426                	sd	s1,8(sp)
    80003f0a:	1000                	addi	s0,sp,32
    80003f0c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003f0e:	0004a517          	auipc	a0,0x4a
    80003f12:	36250513          	addi	a0,a0,866 # 8004e270 <icache>
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	e24080e7          	jalr	-476(ra) # 80000d3a <acquire>
  ip->ref++;
    80003f1e:	449c                	lw	a5,8(s1)
    80003f20:	2785                	addiw	a5,a5,1
    80003f22:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003f24:	0004a517          	auipc	a0,0x4a
    80003f28:	34c50513          	addi	a0,a0,844 # 8004e270 <icache>
    80003f2c:	ffffd097          	auipc	ra,0xffffd
    80003f30:	ec2080e7          	jalr	-318(ra) # 80000dee <release>
}
    80003f34:	8526                	mv	a0,s1
    80003f36:	60e2                	ld	ra,24(sp)
    80003f38:	6442                	ld	s0,16(sp)
    80003f3a:	64a2                	ld	s1,8(sp)
    80003f3c:	6105                	addi	sp,sp,32
    80003f3e:	8082                	ret

0000000080003f40 <ilock>:
void ilock(struct inode *ip) {
    80003f40:	1101                	addi	sp,sp,-32
    80003f42:	ec06                	sd	ra,24(sp)
    80003f44:	e822                	sd	s0,16(sp)
    80003f46:	e426                	sd	s1,8(sp)
    80003f48:	e04a                	sd	s2,0(sp)
    80003f4a:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003f4c:	c115                	beqz	a0,80003f70 <ilock+0x30>
    80003f4e:	84aa                	mv	s1,a0
    80003f50:	451c                	lw	a5,8(a0)
    80003f52:	00f05f63          	blez	a5,80003f70 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003f56:	0541                	addi	a0,a0,16
    80003f58:	00001097          	auipc	ra,0x1
    80003f5c:	ca6080e7          	jalr	-858(ra) # 80004bfe <acquiresleep>
  if (ip->valid == 0) {
    80003f60:	40bc                	lw	a5,64(s1)
    80003f62:	cf99                	beqz	a5,80003f80 <ilock+0x40>
}
    80003f64:	60e2                	ld	ra,24(sp)
    80003f66:	6442                	ld	s0,16(sp)
    80003f68:	64a2                	ld	s1,8(sp)
    80003f6a:	6902                	ld	s2,0(sp)
    80003f6c:	6105                	addi	sp,sp,32
    80003f6e:	8082                	ret
    panic("ilock");
    80003f70:	00004517          	auipc	a0,0x4
    80003f74:	7b050513          	addi	a0,a0,1968 # 80008720 <syscalls+0x1b8>
    80003f78:	ffffc097          	auipc	ra,0xffffc
    80003f7c:	66c080e7          	jalr	1644(ra) # 800005e4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f80:	40dc                	lw	a5,4(s1)
    80003f82:	0047d79b          	srliw	a5,a5,0x4
    80003f86:	0004a597          	auipc	a1,0x4a
    80003f8a:	2e25a583          	lw	a1,738(a1) # 8004e268 <sb+0x18>
    80003f8e:	9dbd                	addw	a1,a1,a5
    80003f90:	4088                	lw	a0,0(s1)
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	7ac080e7          	jalr	1964(ra) # 8000373e <bread>
    80003f9a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003f9c:	05850593          	addi	a1,a0,88
    80003fa0:	40dc                	lw	a5,4(s1)
    80003fa2:	8bbd                	andi	a5,a5,15
    80003fa4:	079a                	slli	a5,a5,0x6
    80003fa6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003fa8:	00059783          	lh	a5,0(a1)
    80003fac:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003fb0:	00259783          	lh	a5,2(a1)
    80003fb4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003fb8:	00459783          	lh	a5,4(a1)
    80003fbc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003fc0:	00659783          	lh	a5,6(a1)
    80003fc4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003fc8:	459c                	lw	a5,8(a1)
    80003fca:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003fcc:	03400613          	li	a2,52
    80003fd0:	05b1                	addi	a1,a1,12
    80003fd2:	05048513          	addi	a0,s1,80
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	ebc080e7          	jalr	-324(ra) # 80000e92 <memmove>
    brelse(bp);
    80003fde:	854a                	mv	a0,s2
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	88e080e7          	jalr	-1906(ra) # 8000386e <brelse>
    ip->valid = 1;
    80003fe8:	4785                	li	a5,1
    80003fea:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003fec:	04449783          	lh	a5,68(s1)
    80003ff0:	fbb5                	bnez	a5,80003f64 <ilock+0x24>
      panic("ilock: no type");
    80003ff2:	00004517          	auipc	a0,0x4
    80003ff6:	73650513          	addi	a0,a0,1846 # 80008728 <syscalls+0x1c0>
    80003ffa:	ffffc097          	auipc	ra,0xffffc
    80003ffe:	5ea080e7          	jalr	1514(ra) # 800005e4 <panic>

0000000080004002 <iunlock>:
void iunlock(struct inode *ip) {
    80004002:	1101                	addi	sp,sp,-32
    80004004:	ec06                	sd	ra,24(sp)
    80004006:	e822                	sd	s0,16(sp)
    80004008:	e426                	sd	s1,8(sp)
    8000400a:	e04a                	sd	s2,0(sp)
    8000400c:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000400e:	c905                	beqz	a0,8000403e <iunlock+0x3c>
    80004010:	84aa                	mv	s1,a0
    80004012:	01050913          	addi	s2,a0,16
    80004016:	854a                	mv	a0,s2
    80004018:	00001097          	auipc	ra,0x1
    8000401c:	c80080e7          	jalr	-896(ra) # 80004c98 <holdingsleep>
    80004020:	cd19                	beqz	a0,8000403e <iunlock+0x3c>
    80004022:	449c                	lw	a5,8(s1)
    80004024:	00f05d63          	blez	a5,8000403e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004028:	854a                	mv	a0,s2
    8000402a:	00001097          	auipc	ra,0x1
    8000402e:	c2a080e7          	jalr	-982(ra) # 80004c54 <releasesleep>
}
    80004032:	60e2                	ld	ra,24(sp)
    80004034:	6442                	ld	s0,16(sp)
    80004036:	64a2                	ld	s1,8(sp)
    80004038:	6902                	ld	s2,0(sp)
    8000403a:	6105                	addi	sp,sp,32
    8000403c:	8082                	ret
    panic("iunlock");
    8000403e:	00004517          	auipc	a0,0x4
    80004042:	6fa50513          	addi	a0,a0,1786 # 80008738 <syscalls+0x1d0>
    80004046:	ffffc097          	auipc	ra,0xffffc
    8000404a:	59e080e7          	jalr	1438(ra) # 800005e4 <panic>

000000008000404e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    8000404e:	7179                	addi	sp,sp,-48
    80004050:	f406                	sd	ra,40(sp)
    80004052:	f022                	sd	s0,32(sp)
    80004054:	ec26                	sd	s1,24(sp)
    80004056:	e84a                	sd	s2,16(sp)
    80004058:	e44e                	sd	s3,8(sp)
    8000405a:	e052                	sd	s4,0(sp)
    8000405c:	1800                	addi	s0,sp,48
    8000405e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80004060:	05050493          	addi	s1,a0,80
    80004064:	08050913          	addi	s2,a0,128
    80004068:	a021                	j	80004070 <itrunc+0x22>
    8000406a:	0491                	addi	s1,s1,4
    8000406c:	01248d63          	beq	s1,s2,80004086 <itrunc+0x38>
    if (ip->addrs[i]) {
    80004070:	408c                	lw	a1,0(s1)
    80004072:	dde5                	beqz	a1,8000406a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80004074:	0009a503          	lw	a0,0(s3)
    80004078:	00000097          	auipc	ra,0x0
    8000407c:	90c080e7          	jalr	-1780(ra) # 80003984 <bfree>
      ip->addrs[i] = 0;
    80004080:	0004a023          	sw	zero,0(s1)
    80004084:	b7dd                	j	8000406a <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80004086:	0809a583          	lw	a1,128(s3)
    8000408a:	e185                	bnez	a1,800040aa <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000408c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004090:	854e                	mv	a0,s3
    80004092:	00000097          	auipc	ra,0x0
    80004096:	de4080e7          	jalr	-540(ra) # 80003e76 <iupdate>
}
    8000409a:	70a2                	ld	ra,40(sp)
    8000409c:	7402                	ld	s0,32(sp)
    8000409e:	64e2                	ld	s1,24(sp)
    800040a0:	6942                	ld	s2,16(sp)
    800040a2:	69a2                	ld	s3,8(sp)
    800040a4:	6a02                	ld	s4,0(sp)
    800040a6:	6145                	addi	sp,sp,48
    800040a8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800040aa:	0009a503          	lw	a0,0(s3)
    800040ae:	fffff097          	auipc	ra,0xfffff
    800040b2:	690080e7          	jalr	1680(ra) # 8000373e <bread>
    800040b6:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800040b8:	05850493          	addi	s1,a0,88
    800040bc:	45850913          	addi	s2,a0,1112
    800040c0:	a021                	j	800040c8 <itrunc+0x7a>
    800040c2:	0491                	addi	s1,s1,4
    800040c4:	01248b63          	beq	s1,s2,800040da <itrunc+0x8c>
      if (a[j])
    800040c8:	408c                	lw	a1,0(s1)
    800040ca:	dde5                	beqz	a1,800040c2 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800040cc:	0009a503          	lw	a0,0(s3)
    800040d0:	00000097          	auipc	ra,0x0
    800040d4:	8b4080e7          	jalr	-1868(ra) # 80003984 <bfree>
    800040d8:	b7ed                	j	800040c2 <itrunc+0x74>
    brelse(bp);
    800040da:	8552                	mv	a0,s4
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	792080e7          	jalr	1938(ra) # 8000386e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800040e4:	0809a583          	lw	a1,128(s3)
    800040e8:	0009a503          	lw	a0,0(s3)
    800040ec:	00000097          	auipc	ra,0x0
    800040f0:	898080e7          	jalr	-1896(ra) # 80003984 <bfree>
    ip->addrs[NDIRECT] = 0;
    800040f4:	0809a023          	sw	zero,128(s3)
    800040f8:	bf51                	j	8000408c <itrunc+0x3e>

00000000800040fa <iput>:
void iput(struct inode *ip) {
    800040fa:	1101                	addi	sp,sp,-32
    800040fc:	ec06                	sd	ra,24(sp)
    800040fe:	e822                	sd	s0,16(sp)
    80004100:	e426                	sd	s1,8(sp)
    80004102:	e04a                	sd	s2,0(sp)
    80004104:	1000                	addi	s0,sp,32
    80004106:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80004108:	0004a517          	auipc	a0,0x4a
    8000410c:	16850513          	addi	a0,a0,360 # 8004e270 <icache>
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	c2a080e7          	jalr	-982(ra) # 80000d3a <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80004118:	4498                	lw	a4,8(s1)
    8000411a:	4785                	li	a5,1
    8000411c:	02f70363          	beq	a4,a5,80004142 <iput+0x48>
  ip->ref--;
    80004120:	449c                	lw	a5,8(s1)
    80004122:	37fd                	addiw	a5,a5,-1
    80004124:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80004126:	0004a517          	auipc	a0,0x4a
    8000412a:	14a50513          	addi	a0,a0,330 # 8004e270 <icache>
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	cc0080e7          	jalr	-832(ra) # 80000dee <release>
}
    80004136:	60e2                	ld	ra,24(sp)
    80004138:	6442                	ld	s0,16(sp)
    8000413a:	64a2                	ld	s1,8(sp)
    8000413c:	6902                	ld	s2,0(sp)
    8000413e:	6105                	addi	sp,sp,32
    80004140:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80004142:	40bc                	lw	a5,64(s1)
    80004144:	dff1                	beqz	a5,80004120 <iput+0x26>
    80004146:	04a49783          	lh	a5,74(s1)
    8000414a:	fbf9                	bnez	a5,80004120 <iput+0x26>
    acquiresleep(&ip->lock);
    8000414c:	01048913          	addi	s2,s1,16
    80004150:	854a                	mv	a0,s2
    80004152:	00001097          	auipc	ra,0x1
    80004156:	aac080e7          	jalr	-1364(ra) # 80004bfe <acquiresleep>
    release(&icache.lock);
    8000415a:	0004a517          	auipc	a0,0x4a
    8000415e:	11650513          	addi	a0,a0,278 # 8004e270 <icache>
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	c8c080e7          	jalr	-884(ra) # 80000dee <release>
    itrunc(ip);
    8000416a:	8526                	mv	a0,s1
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	ee2080e7          	jalr	-286(ra) # 8000404e <itrunc>
    ip->type = 0;
    80004174:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004178:	8526                	mv	a0,s1
    8000417a:	00000097          	auipc	ra,0x0
    8000417e:	cfc080e7          	jalr	-772(ra) # 80003e76 <iupdate>
    ip->valid = 0;
    80004182:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004186:	854a                	mv	a0,s2
    80004188:	00001097          	auipc	ra,0x1
    8000418c:	acc080e7          	jalr	-1332(ra) # 80004c54 <releasesleep>
    acquire(&icache.lock);
    80004190:	0004a517          	auipc	a0,0x4a
    80004194:	0e050513          	addi	a0,a0,224 # 8004e270 <icache>
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	ba2080e7          	jalr	-1118(ra) # 80000d3a <acquire>
    800041a0:	b741                	j	80004120 <iput+0x26>

00000000800041a2 <iunlockput>:
void iunlockput(struct inode *ip) {
    800041a2:	1101                	addi	sp,sp,-32
    800041a4:	ec06                	sd	ra,24(sp)
    800041a6:	e822                	sd	s0,16(sp)
    800041a8:	e426                	sd	s1,8(sp)
    800041aa:	1000                	addi	s0,sp,32
    800041ac:	84aa                	mv	s1,a0
  iunlock(ip);
    800041ae:	00000097          	auipc	ra,0x0
    800041b2:	e54080e7          	jalr	-428(ra) # 80004002 <iunlock>
  iput(ip);
    800041b6:	8526                	mv	a0,s1
    800041b8:	00000097          	auipc	ra,0x0
    800041bc:	f42080e7          	jalr	-190(ra) # 800040fa <iput>
}
    800041c0:	60e2                	ld	ra,24(sp)
    800041c2:	6442                	ld	s0,16(sp)
    800041c4:	64a2                	ld	s1,8(sp)
    800041c6:	6105                	addi	sp,sp,32
    800041c8:	8082                	ret

00000000800041ca <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    800041ca:	1141                	addi	sp,sp,-16
    800041cc:	e422                	sd	s0,8(sp)
    800041ce:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800041d0:	411c                	lw	a5,0(a0)
    800041d2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800041d4:	415c                	lw	a5,4(a0)
    800041d6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800041d8:	04451783          	lh	a5,68(a0)
    800041dc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800041e0:	04a51783          	lh	a5,74(a0)
    800041e4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800041e8:	04c56783          	lwu	a5,76(a0)
    800041ec:	e99c                	sd	a5,16(a1)
}
    800041ee:	6422                	ld	s0,8(sp)
    800041f0:	0141                	addi	sp,sp,16
    800041f2:	8082                	ret

00000000800041f4 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800041f4:	457c                	lw	a5,76(a0)
    800041f6:	0ed7e963          	bltu	a5,a3,800042e8 <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    800041fa:	7159                	addi	sp,sp,-112
    800041fc:	f486                	sd	ra,104(sp)
    800041fe:	f0a2                	sd	s0,96(sp)
    80004200:	eca6                	sd	s1,88(sp)
    80004202:	e8ca                	sd	s2,80(sp)
    80004204:	e4ce                	sd	s3,72(sp)
    80004206:	e0d2                	sd	s4,64(sp)
    80004208:	fc56                	sd	s5,56(sp)
    8000420a:	f85a                	sd	s6,48(sp)
    8000420c:	f45e                	sd	s7,40(sp)
    8000420e:	f062                	sd	s8,32(sp)
    80004210:	ec66                	sd	s9,24(sp)
    80004212:	e86a                	sd	s10,16(sp)
    80004214:	e46e                	sd	s11,8(sp)
    80004216:	1880                	addi	s0,sp,112
    80004218:	8baa                	mv	s7,a0
    8000421a:	8c2e                	mv	s8,a1
    8000421c:	8ab2                	mv	s5,a2
    8000421e:	84b6                	mv	s1,a3
    80004220:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80004222:	9f35                	addw	a4,a4,a3
    return 0;
    80004224:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80004226:	0ad76063          	bltu	a4,a3,800042c6 <readi+0xd2>
  if (off + n > ip->size)
    8000422a:	00e7f463          	bgeu	a5,a4,80004232 <readi+0x3e>
    n = ip->size - off;
    8000422e:	40d78b3b          	subw	s6,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004232:	0a0b0963          	beqz	s6,800042e4 <readi+0xf0>
    80004236:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    m = min(n - tot, BSIZE - off % BSIZE);
    80004238:	40000d13          	li	s10,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000423c:	5cfd                	li	s9,-1
    8000423e:	a82d                	j	80004278 <readi+0x84>
    80004240:	020a1d93          	slli	s11,s4,0x20
    80004244:	020ddd93          	srli	s11,s11,0x20
    80004248:	05890793          	addi	a5,s2,88
    8000424c:	86ee                	mv	a3,s11
    8000424e:	963e                	add	a2,a2,a5
    80004250:	85d6                	mv	a1,s5
    80004252:	8562                	mv	a0,s8
    80004254:	fffff097          	auipc	ra,0xfffff
    80004258:	990080e7          	jalr	-1648(ra) # 80002be4 <either_copyout>
    8000425c:	05950d63          	beq	a0,s9,800042b6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004260:	854a                	mv	a0,s2
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	60c080e7          	jalr	1548(ra) # 8000386e <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000426a:	013a09bb          	addw	s3,s4,s3
    8000426e:	009a04bb          	addw	s1,s4,s1
    80004272:	9aee                	add	s5,s5,s11
    80004274:	0569f763          	bgeu	s3,s6,800042c2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80004278:	000ba903          	lw	s2,0(s7)
    8000427c:	00a4d59b          	srliw	a1,s1,0xa
    80004280:	855e                	mv	a0,s7
    80004282:	00000097          	auipc	ra,0x0
    80004286:	8b0080e7          	jalr	-1872(ra) # 80003b32 <bmap>
    8000428a:	0005059b          	sext.w	a1,a0
    8000428e:	854a                	mv	a0,s2
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	4ae080e7          	jalr	1198(ra) # 8000373e <bread>
    80004298:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000429a:	3ff4f613          	andi	a2,s1,1023
    8000429e:	40cd07bb          	subw	a5,s10,a2
    800042a2:	413b073b          	subw	a4,s6,s3
    800042a6:	8a3e                	mv	s4,a5
    800042a8:	2781                	sext.w	a5,a5
    800042aa:	0007069b          	sext.w	a3,a4
    800042ae:	f8f6f9e3          	bgeu	a3,a5,80004240 <readi+0x4c>
    800042b2:	8a3a                	mv	s4,a4
    800042b4:	b771                	j	80004240 <readi+0x4c>
      brelse(bp);
    800042b6:	854a                	mv	a0,s2
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	5b6080e7          	jalr	1462(ra) # 8000386e <brelse>
      tot = -1;
    800042c0:	59fd                	li	s3,-1
  }
  return tot;
    800042c2:	0009851b          	sext.w	a0,s3
}
    800042c6:	70a6                	ld	ra,104(sp)
    800042c8:	7406                	ld	s0,96(sp)
    800042ca:	64e6                	ld	s1,88(sp)
    800042cc:	6946                	ld	s2,80(sp)
    800042ce:	69a6                	ld	s3,72(sp)
    800042d0:	6a06                	ld	s4,64(sp)
    800042d2:	7ae2                	ld	s5,56(sp)
    800042d4:	7b42                	ld	s6,48(sp)
    800042d6:	7ba2                	ld	s7,40(sp)
    800042d8:	7c02                	ld	s8,32(sp)
    800042da:	6ce2                	ld	s9,24(sp)
    800042dc:	6d42                	ld	s10,16(sp)
    800042de:	6da2                	ld	s11,8(sp)
    800042e0:	6165                	addi	sp,sp,112
    800042e2:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800042e4:	89da                	mv	s3,s6
    800042e6:	bff1                	j	800042c2 <readi+0xce>
    return 0;
    800042e8:	4501                	li	a0,0
}
    800042ea:	8082                	ret

00000000800042ec <writei>:
// otherwise, src is a kernel address.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800042ec:	457c                	lw	a5,76(a0)
    800042ee:	10d7e763          	bltu	a5,a3,800043fc <writei+0x110>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    800042f2:	7159                	addi	sp,sp,-112
    800042f4:	f486                	sd	ra,104(sp)
    800042f6:	f0a2                	sd	s0,96(sp)
    800042f8:	eca6                	sd	s1,88(sp)
    800042fa:	e8ca                	sd	s2,80(sp)
    800042fc:	e4ce                	sd	s3,72(sp)
    800042fe:	e0d2                	sd	s4,64(sp)
    80004300:	fc56                	sd	s5,56(sp)
    80004302:	f85a                	sd	s6,48(sp)
    80004304:	f45e                	sd	s7,40(sp)
    80004306:	f062                	sd	s8,32(sp)
    80004308:	ec66                	sd	s9,24(sp)
    8000430a:	e86a                	sd	s10,16(sp)
    8000430c:	e46e                	sd	s11,8(sp)
    8000430e:	1880                	addi	s0,sp,112
    80004310:	8baa                	mv	s7,a0
    80004312:	8c2e                	mv	s8,a1
    80004314:	8ab2                	mv	s5,a2
    80004316:	8936                	mv	s2,a3
    80004318:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    8000431a:	00e687bb          	addw	a5,a3,a4
    8000431e:	0ed7e163          	bltu	a5,a3,80004400 <writei+0x114>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80004322:	00043737          	lui	a4,0x43
    80004326:	0cf76f63          	bltu	a4,a5,80004404 <writei+0x118>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000432a:	0a0b0863          	beqz	s6,800043da <writei+0xee>
    8000432e:	4a01                	li	s4,0

    // * any update will be applied on buffer block,later write back to disk in
    // batch
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    m = min(n - tot, BSIZE - off % BSIZE);
    80004330:	40000d13          	li	s10,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004334:	5cfd                	li	s9,-1
    80004336:	a091                	j	8000437a <writei+0x8e>
    80004338:	02099d93          	slli	s11,s3,0x20
    8000433c:	020ddd93          	srli	s11,s11,0x20
    80004340:	05848793          	addi	a5,s1,88
    80004344:	86ee                	mv	a3,s11
    80004346:	8656                	mv	a2,s5
    80004348:	85e2                	mv	a1,s8
    8000434a:	953e                	add	a0,a0,a5
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	8ee080e7          	jalr	-1810(ra) # 80002c3a <either_copyin>
    80004354:	07950263          	beq	a0,s9,800043b8 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80004358:	8526                	mv	a0,s1
    8000435a:	00000097          	auipc	ra,0x0
    8000435e:	77c080e7          	jalr	1916(ra) # 80004ad6 <log_write>
    brelse(bp);
    80004362:	8526                	mv	a0,s1
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	50a080e7          	jalr	1290(ra) # 8000386e <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000436c:	01498a3b          	addw	s4,s3,s4
    80004370:	0129893b          	addw	s2,s3,s2
    80004374:	9aee                	add	s5,s5,s11
    80004376:	056a7763          	bgeu	s4,s6,800043c4 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    8000437a:	000ba483          	lw	s1,0(s7)
    8000437e:	00a9559b          	srliw	a1,s2,0xa
    80004382:	855e                	mv	a0,s7
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	7ae080e7          	jalr	1966(ra) # 80003b32 <bmap>
    8000438c:	0005059b          	sext.w	a1,a0
    80004390:	8526                	mv	a0,s1
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	3ac080e7          	jalr	940(ra) # 8000373e <bread>
    8000439a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000439c:	3ff97513          	andi	a0,s2,1023
    800043a0:	40ad07bb          	subw	a5,s10,a0
    800043a4:	414b073b          	subw	a4,s6,s4
    800043a8:	89be                	mv	s3,a5
    800043aa:	2781                	sext.w	a5,a5
    800043ac:	0007069b          	sext.w	a3,a4
    800043b0:	f8f6f4e3          	bgeu	a3,a5,80004338 <writei+0x4c>
    800043b4:	89ba                	mv	s3,a4
    800043b6:	b749                	j	80004338 <writei+0x4c>
      brelse(bp);
    800043b8:	8526                	mv	a0,s1
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	4b4080e7          	jalr	1204(ra) # 8000386e <brelse>
      n = -1;
    800043c2:	5b7d                	li	s6,-1
  }

  if (n > 0) {
    if (off > ip->size)
    800043c4:	04cba783          	lw	a5,76(s7)
    800043c8:	0127f463          	bgeu	a5,s2,800043d0 <writei+0xe4>
      ip->size = off;
    800043cc:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800043d0:	855e                	mv	a0,s7
    800043d2:	00000097          	auipc	ra,0x0
    800043d6:	aa4080e7          	jalr	-1372(ra) # 80003e76 <iupdate>
  }

  return n;
    800043da:	000b051b          	sext.w	a0,s6
}
    800043de:	70a6                	ld	ra,104(sp)
    800043e0:	7406                	ld	s0,96(sp)
    800043e2:	64e6                	ld	s1,88(sp)
    800043e4:	6946                	ld	s2,80(sp)
    800043e6:	69a6                	ld	s3,72(sp)
    800043e8:	6a06                	ld	s4,64(sp)
    800043ea:	7ae2                	ld	s5,56(sp)
    800043ec:	7b42                	ld	s6,48(sp)
    800043ee:	7ba2                	ld	s7,40(sp)
    800043f0:	7c02                	ld	s8,32(sp)
    800043f2:	6ce2                	ld	s9,24(sp)
    800043f4:	6d42                	ld	s10,16(sp)
    800043f6:	6da2                	ld	s11,8(sp)
    800043f8:	6165                	addi	sp,sp,112
    800043fa:	8082                	ret
    return -1;
    800043fc:	557d                	li	a0,-1
}
    800043fe:	8082                	ret
    return -1;
    80004400:	557d                	li	a0,-1
    80004402:	bff1                	j	800043de <writei+0xf2>
    return -1;
    80004404:	557d                	li	a0,-1
    80004406:	bfe1                	j	800043de <writei+0xf2>

0000000080004408 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    80004408:	1141                	addi	sp,sp,-16
    8000440a:	e406                	sd	ra,8(sp)
    8000440c:	e022                	sd	s0,0(sp)
    8000440e:	0800                	addi	s0,sp,16
    80004410:	4639                	li	a2,14
    80004412:	ffffd097          	auipc	ra,0xffffd
    80004416:	afc080e7          	jalr	-1284(ra) # 80000f0e <strncmp>
    8000441a:	60a2                	ld	ra,8(sp)
    8000441c:	6402                	ld	s0,0(sp)
    8000441e:	0141                	addi	sp,sp,16
    80004420:	8082                	ret

0000000080004422 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80004422:	7139                	addi	sp,sp,-64
    80004424:	fc06                	sd	ra,56(sp)
    80004426:	f822                	sd	s0,48(sp)
    80004428:	f426                	sd	s1,40(sp)
    8000442a:	f04a                	sd	s2,32(sp)
    8000442c:	ec4e                	sd	s3,24(sp)
    8000442e:	e852                	sd	s4,16(sp)
    80004430:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80004432:	04451703          	lh	a4,68(a0)
    80004436:	4785                	li	a5,1
    80004438:	00f71a63          	bne	a4,a5,8000444c <dirlookup+0x2a>
    8000443c:	892a                	mv	s2,a0
    8000443e:	89ae                	mv	s3,a1
    80004440:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004442:	457c                	lw	a5,76(a0)
    80004444:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004446:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004448:	e79d                	bnez	a5,80004476 <dirlookup+0x54>
    8000444a:	a8a5                	j	800044c2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000444c:	00004517          	auipc	a0,0x4
    80004450:	2f450513          	addi	a0,a0,756 # 80008740 <syscalls+0x1d8>
    80004454:	ffffc097          	auipc	ra,0xffffc
    80004458:	190080e7          	jalr	400(ra) # 800005e4 <panic>
      panic("dirlookup read");
    8000445c:	00004517          	auipc	a0,0x4
    80004460:	2fc50513          	addi	a0,a0,764 # 80008758 <syscalls+0x1f0>
    80004464:	ffffc097          	auipc	ra,0xffffc
    80004468:	180080e7          	jalr	384(ra) # 800005e4 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000446c:	24c1                	addiw	s1,s1,16
    8000446e:	04c92783          	lw	a5,76(s2)
    80004472:	04f4f763          	bgeu	s1,a5,800044c0 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004476:	4741                	li	a4,16
    80004478:	86a6                	mv	a3,s1
    8000447a:	fc040613          	addi	a2,s0,-64
    8000447e:	4581                	li	a1,0
    80004480:	854a                	mv	a0,s2
    80004482:	00000097          	auipc	ra,0x0
    80004486:	d72080e7          	jalr	-654(ra) # 800041f4 <readi>
    8000448a:	47c1                	li	a5,16
    8000448c:	fcf518e3          	bne	a0,a5,8000445c <dirlookup+0x3a>
    if (de.inum == 0)
    80004490:	fc045783          	lhu	a5,-64(s0)
    80004494:	dfe1                	beqz	a5,8000446c <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80004496:	fc240593          	addi	a1,s0,-62
    8000449a:	854e                	mv	a0,s3
    8000449c:	00000097          	auipc	ra,0x0
    800044a0:	f6c080e7          	jalr	-148(ra) # 80004408 <namecmp>
    800044a4:	f561                	bnez	a0,8000446c <dirlookup+0x4a>
      if (poff)
    800044a6:	000a0463          	beqz	s4,800044ae <dirlookup+0x8c>
        *poff = off;
    800044aa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800044ae:	fc045583          	lhu	a1,-64(s0)
    800044b2:	00092503          	lw	a0,0(s2)
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	756080e7          	jalr	1878(ra) # 80003c0c <iget>
    800044be:	a011                	j	800044c2 <dirlookup+0xa0>
  return 0;
    800044c0:	4501                	li	a0,0
}
    800044c2:	70e2                	ld	ra,56(sp)
    800044c4:	7442                	ld	s0,48(sp)
    800044c6:	74a2                	ld	s1,40(sp)
    800044c8:	7902                	ld	s2,32(sp)
    800044ca:	69e2                	ld	s3,24(sp)
    800044cc:	6a42                	ld	s4,16(sp)
    800044ce:	6121                	addi	sp,sp,64
    800044d0:	8082                	ret

00000000800044d2 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800044d2:	711d                	addi	sp,sp,-96
    800044d4:	ec86                	sd	ra,88(sp)
    800044d6:	e8a2                	sd	s0,80(sp)
    800044d8:	e4a6                	sd	s1,72(sp)
    800044da:	e0ca                	sd	s2,64(sp)
    800044dc:	fc4e                	sd	s3,56(sp)
    800044de:	f852                	sd	s4,48(sp)
    800044e0:	f456                	sd	s5,40(sp)
    800044e2:	f05a                	sd	s6,32(sp)
    800044e4:	ec5e                	sd	s7,24(sp)
    800044e6:	e862                	sd	s8,16(sp)
    800044e8:	e466                	sd	s9,8(sp)
    800044ea:	1080                	addi	s0,sp,96
    800044ec:	84aa                	mv	s1,a0
    800044ee:	8aae                	mv	s5,a1
    800044f0:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if (*path == '/')
    800044f2:	00054703          	lbu	a4,0(a0)
    800044f6:	02f00793          	li	a5,47
    800044fa:	02f70363          	beq	a4,a5,80004520 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800044fe:	ffffe097          	auipc	ra,0xffffe
    80004502:	c0c080e7          	jalr	-1012(ra) # 8000210a <myproc>
    80004506:	16053503          	ld	a0,352(a0)
    8000450a:	00000097          	auipc	ra,0x0
    8000450e:	9f8080e7          	jalr	-1544(ra) # 80003f02 <idup>
    80004512:	89aa                	mv	s3,a0
  while (*path == '/')
    80004514:	02f00913          	li	s2,47
  len = path - s;
    80004518:	4b01                	li	s6,0
  if (len >= DIRSIZ)
    8000451a:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    8000451c:	4b85                	li	s7,1
    8000451e:	a865                	j	800045d6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004520:	4585                	li	a1,1
    80004522:	4505                	li	a0,1
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	6e8080e7          	jalr	1768(ra) # 80003c0c <iget>
    8000452c:	89aa                	mv	s3,a0
    8000452e:	b7dd                	j	80004514 <namex+0x42>
      iunlockput(ip);
    80004530:	854e                	mv	a0,s3
    80004532:	00000097          	auipc	ra,0x0
    80004536:	c70080e7          	jalr	-912(ra) # 800041a2 <iunlockput>
      return 0;
    8000453a:	4981                	li	s3,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000453c:	854e                	mv	a0,s3
    8000453e:	60e6                	ld	ra,88(sp)
    80004540:	6446                	ld	s0,80(sp)
    80004542:	64a6                	ld	s1,72(sp)
    80004544:	6906                	ld	s2,64(sp)
    80004546:	79e2                	ld	s3,56(sp)
    80004548:	7a42                	ld	s4,48(sp)
    8000454a:	7aa2                	ld	s5,40(sp)
    8000454c:	7b02                	ld	s6,32(sp)
    8000454e:	6be2                	ld	s7,24(sp)
    80004550:	6c42                	ld	s8,16(sp)
    80004552:	6ca2                	ld	s9,8(sp)
    80004554:	6125                	addi	sp,sp,96
    80004556:	8082                	ret
      iunlock(ip);
    80004558:	854e                	mv	a0,s3
    8000455a:	00000097          	auipc	ra,0x0
    8000455e:	aa8080e7          	jalr	-1368(ra) # 80004002 <iunlock>
      return ip;
    80004562:	bfe9                	j	8000453c <namex+0x6a>
      iunlockput(ip);
    80004564:	854e                	mv	a0,s3
    80004566:	00000097          	auipc	ra,0x0
    8000456a:	c3c080e7          	jalr	-964(ra) # 800041a2 <iunlockput>
      return 0;
    8000456e:	89e6                	mv	s3,s9
    80004570:	b7f1                	j	8000453c <namex+0x6a>
  len = path - s;
    80004572:	40b48633          	sub	a2,s1,a1
    80004576:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    8000457a:	099c5463          	bge	s8,s9,80004602 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000457e:	4639                	li	a2,14
    80004580:	8552                	mv	a0,s4
    80004582:	ffffd097          	auipc	ra,0xffffd
    80004586:	910080e7          	jalr	-1776(ra) # 80000e92 <memmove>
  while (*path == '/')
    8000458a:	0004c783          	lbu	a5,0(s1)
    8000458e:	01279763          	bne	a5,s2,8000459c <namex+0xca>
    path++;
    80004592:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004594:	0004c783          	lbu	a5,0(s1)
    80004598:	ff278de3          	beq	a5,s2,80004592 <namex+0xc0>
    ilock(ip);
    8000459c:	854e                	mv	a0,s3
    8000459e:	00000097          	auipc	ra,0x0
    800045a2:	9a2080e7          	jalr	-1630(ra) # 80003f40 <ilock>
    if (ip->type != T_DIR) {
    800045a6:	04499783          	lh	a5,68(s3)
    800045aa:	f97793e3          	bne	a5,s7,80004530 <namex+0x5e>
    if (nameiparent && *path == '\0') {
    800045ae:	000a8563          	beqz	s5,800045b8 <namex+0xe6>
    800045b2:	0004c783          	lbu	a5,0(s1)
    800045b6:	d3cd                	beqz	a5,80004558 <namex+0x86>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800045b8:	865a                	mv	a2,s6
    800045ba:	85d2                	mv	a1,s4
    800045bc:	854e                	mv	a0,s3
    800045be:	00000097          	auipc	ra,0x0
    800045c2:	e64080e7          	jalr	-412(ra) # 80004422 <dirlookup>
    800045c6:	8caa                	mv	s9,a0
    800045c8:	dd51                	beqz	a0,80004564 <namex+0x92>
    iunlockput(ip);
    800045ca:	854e                	mv	a0,s3
    800045cc:	00000097          	auipc	ra,0x0
    800045d0:	bd6080e7          	jalr	-1066(ra) # 800041a2 <iunlockput>
    ip = next;
    800045d4:	89e6                	mv	s3,s9
  while (*path == '/')
    800045d6:	0004c783          	lbu	a5,0(s1)
    800045da:	05279763          	bne	a5,s2,80004628 <namex+0x156>
    path++;
    800045de:	0485                	addi	s1,s1,1
  while (*path == '/')
    800045e0:	0004c783          	lbu	a5,0(s1)
    800045e4:	ff278de3          	beq	a5,s2,800045de <namex+0x10c>
  if (*path == 0)
    800045e8:	c79d                	beqz	a5,80004616 <namex+0x144>
    path++;
    800045ea:	85a6                	mv	a1,s1
  len = path - s;
    800045ec:	8cda                	mv	s9,s6
    800045ee:	865a                	mv	a2,s6
  while (*path != '/' && *path != 0)
    800045f0:	01278963          	beq	a5,s2,80004602 <namex+0x130>
    800045f4:	dfbd                	beqz	a5,80004572 <namex+0xa0>
    path++;
    800045f6:	0485                	addi	s1,s1,1
  while (*path != '/' && *path != 0)
    800045f8:	0004c783          	lbu	a5,0(s1)
    800045fc:	ff279ce3          	bne	a5,s2,800045f4 <namex+0x122>
    80004600:	bf8d                	j	80004572 <namex+0xa0>
    memmove(name, s, len);
    80004602:	2601                	sext.w	a2,a2
    80004604:	8552                	mv	a0,s4
    80004606:	ffffd097          	auipc	ra,0xffffd
    8000460a:	88c080e7          	jalr	-1908(ra) # 80000e92 <memmove>
    name[len] = 0;
    8000460e:	9cd2                	add	s9,s9,s4
    80004610:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004614:	bf9d                	j	8000458a <namex+0xb8>
  if (nameiparent) {
    80004616:	f20a83e3          	beqz	s5,8000453c <namex+0x6a>
    iput(ip);
    8000461a:	854e                	mv	a0,s3
    8000461c:	00000097          	auipc	ra,0x0
    80004620:	ade080e7          	jalr	-1314(ra) # 800040fa <iput>
    return 0;
    80004624:	4981                	li	s3,0
    80004626:	bf19                	j	8000453c <namex+0x6a>
  if (*path == 0)
    80004628:	d7fd                	beqz	a5,80004616 <namex+0x144>
  while (*path != '/' && *path != 0)
    8000462a:	0004c783          	lbu	a5,0(s1)
    8000462e:	85a6                	mv	a1,s1
    80004630:	b7d1                	j	800045f4 <namex+0x122>

0000000080004632 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80004632:	7139                	addi	sp,sp,-64
    80004634:	fc06                	sd	ra,56(sp)
    80004636:	f822                	sd	s0,48(sp)
    80004638:	f426                	sd	s1,40(sp)
    8000463a:	f04a                	sd	s2,32(sp)
    8000463c:	ec4e                	sd	s3,24(sp)
    8000463e:	e852                	sd	s4,16(sp)
    80004640:	0080                	addi	s0,sp,64
    80004642:	892a                	mv	s2,a0
    80004644:	8a2e                	mv	s4,a1
    80004646:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004648:	4601                	li	a2,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	dd8080e7          	jalr	-552(ra) # 80004422 <dirlookup>
    80004652:	e93d                	bnez	a0,800046c8 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004654:	04c92483          	lw	s1,76(s2)
    80004658:	c49d                	beqz	s1,80004686 <dirlink+0x54>
    8000465a:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000465c:	4741                	li	a4,16
    8000465e:	86a6                	mv	a3,s1
    80004660:	fc040613          	addi	a2,s0,-64
    80004664:	4581                	li	a1,0
    80004666:	854a                	mv	a0,s2
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	b8c080e7          	jalr	-1140(ra) # 800041f4 <readi>
    80004670:	47c1                	li	a5,16
    80004672:	06f51163          	bne	a0,a5,800046d4 <dirlink+0xa2>
    if (de.inum == 0)
    80004676:	fc045783          	lhu	a5,-64(s0)
    8000467a:	c791                	beqz	a5,80004686 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000467c:	24c1                	addiw	s1,s1,16
    8000467e:	04c92783          	lw	a5,76(s2)
    80004682:	fcf4ede3          	bltu	s1,a5,8000465c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004686:	4639                	li	a2,14
    80004688:	85d2                	mv	a1,s4
    8000468a:	fc240513          	addi	a0,s0,-62
    8000468e:	ffffd097          	auipc	ra,0xffffd
    80004692:	8bc080e7          	jalr	-1860(ra) # 80000f4a <strncpy>
  de.inum = inum;
    80004696:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000469a:	4741                	li	a4,16
    8000469c:	86a6                	mv	a3,s1
    8000469e:	fc040613          	addi	a2,s0,-64
    800046a2:	4581                	li	a1,0
    800046a4:	854a                	mv	a0,s2
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	c46080e7          	jalr	-954(ra) # 800042ec <writei>
    800046ae:	872a                	mv	a4,a0
    800046b0:	47c1                	li	a5,16
  return 0;
    800046b2:	4501                	li	a0,0
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046b4:	02f71863          	bne	a4,a5,800046e4 <dirlink+0xb2>
}
    800046b8:	70e2                	ld	ra,56(sp)
    800046ba:	7442                	ld	s0,48(sp)
    800046bc:	74a2                	ld	s1,40(sp)
    800046be:	7902                	ld	s2,32(sp)
    800046c0:	69e2                	ld	s3,24(sp)
    800046c2:	6a42                	ld	s4,16(sp)
    800046c4:	6121                	addi	sp,sp,64
    800046c6:	8082                	ret
    iput(ip);
    800046c8:	00000097          	auipc	ra,0x0
    800046cc:	a32080e7          	jalr	-1486(ra) # 800040fa <iput>
    return -1;
    800046d0:	557d                	li	a0,-1
    800046d2:	b7dd                	j	800046b8 <dirlink+0x86>
      panic("dirlink read");
    800046d4:	00004517          	auipc	a0,0x4
    800046d8:	09450513          	addi	a0,a0,148 # 80008768 <syscalls+0x200>
    800046dc:	ffffc097          	auipc	ra,0xffffc
    800046e0:	f08080e7          	jalr	-248(ra) # 800005e4 <panic>
    panic("dirlink");
    800046e4:	00004517          	auipc	a0,0x4
    800046e8:	1a450513          	addi	a0,a0,420 # 80008888 <syscalls+0x320>
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	ef8080e7          	jalr	-264(ra) # 800005e4 <panic>

00000000800046f4 <namei>:

struct inode *namei(char *path) {
    800046f4:	1101                	addi	sp,sp,-32
    800046f6:	ec06                	sd	ra,24(sp)
    800046f8:	e822                	sd	s0,16(sp)
    800046fa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800046fc:	fe040613          	addi	a2,s0,-32
    80004700:	4581                	li	a1,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	dd0080e7          	jalr	-560(ra) # 800044d2 <namex>
}
    8000470a:	60e2                	ld	ra,24(sp)
    8000470c:	6442                	ld	s0,16(sp)
    8000470e:	6105                	addi	sp,sp,32
    80004710:	8082                	ret

0000000080004712 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80004712:	1141                	addi	sp,sp,-16
    80004714:	e406                	sd	ra,8(sp)
    80004716:	e022                	sd	s0,0(sp)
    80004718:	0800                	addi	s0,sp,16
    8000471a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000471c:	4585                	li	a1,1
    8000471e:	00000097          	auipc	ra,0x0
    80004722:	db4080e7          	jalr	-588(ra) # 800044d2 <namex>
}
    80004726:	60a2                	ld	ra,8(sp)
    80004728:	6402                	ld	s0,0(sp)
    8000472a:	0141                	addi	sp,sp,16
    8000472c:	8082                	ret

000000008000472e <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    8000472e:	1101                	addi	sp,sp,-32
    80004730:	ec06                	sd	ra,24(sp)
    80004732:	e822                	sd	s0,16(sp)
    80004734:	e426                	sd	s1,8(sp)
    80004736:	e04a                	sd	s2,0(sp)
    80004738:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000473a:	0004b917          	auipc	s2,0x4b
    8000473e:	5de90913          	addi	s2,s2,1502 # 8004fd18 <log>
    80004742:	01892583          	lw	a1,24(s2)
    80004746:	02892503          	lw	a0,40(s2)
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	ff4080e7          	jalr	-12(ra) # 8000373e <bread>
    80004752:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80004754:	02c92683          	lw	a3,44(s2)
    80004758:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000475a:	02d05763          	blez	a3,80004788 <write_head+0x5a>
    8000475e:	0004b797          	auipc	a5,0x4b
    80004762:	5ea78793          	addi	a5,a5,1514 # 8004fd48 <log+0x30>
    80004766:	05c50713          	addi	a4,a0,92
    8000476a:	36fd                	addiw	a3,a3,-1
    8000476c:	1682                	slli	a3,a3,0x20
    8000476e:	9281                	srli	a3,a3,0x20
    80004770:	068a                	slli	a3,a3,0x2
    80004772:	0004b617          	auipc	a2,0x4b
    80004776:	5da60613          	addi	a2,a2,1498 # 8004fd4c <log+0x34>
    8000477a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000477c:	4390                	lw	a2,0(a5)
    8000477e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004780:	0791                	addi	a5,a5,4
    80004782:	0711                	addi	a4,a4,4
    80004784:	fed79ce3          	bne	a5,a3,8000477c <write_head+0x4e>
  }
  bwrite(buf);
    80004788:	8526                	mv	a0,s1
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	0a6080e7          	jalr	166(ra) # 80003830 <bwrite>
  brelse(buf);
    80004792:	8526                	mv	a0,s1
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	0da080e7          	jalr	218(ra) # 8000386e <brelse>
}
    8000479c:	60e2                	ld	ra,24(sp)
    8000479e:	6442                	ld	s0,16(sp)
    800047a0:	64a2                	ld	s1,8(sp)
    800047a2:	6902                	ld	s2,0(sp)
    800047a4:	6105                	addi	sp,sp,32
    800047a6:	8082                	ret

00000000800047a8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800047a8:	0004b797          	auipc	a5,0x4b
    800047ac:	59c7a783          	lw	a5,1436(a5) # 8004fd44 <log+0x2c>
    800047b0:	0af05663          	blez	a5,8000485c <install_trans+0xb4>
static void install_trans(void) {
    800047b4:	7139                	addi	sp,sp,-64
    800047b6:	fc06                	sd	ra,56(sp)
    800047b8:	f822                	sd	s0,48(sp)
    800047ba:	f426                	sd	s1,40(sp)
    800047bc:	f04a                	sd	s2,32(sp)
    800047be:	ec4e                	sd	s3,24(sp)
    800047c0:	e852                	sd	s4,16(sp)
    800047c2:	e456                	sd	s5,8(sp)
    800047c4:	0080                	addi	s0,sp,64
    800047c6:	0004ba97          	auipc	s5,0x4b
    800047ca:	582a8a93          	addi	s5,s5,1410 # 8004fd48 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047ce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    800047d0:	0004b997          	auipc	s3,0x4b
    800047d4:	54898993          	addi	s3,s3,1352 # 8004fd18 <log>
    800047d8:	0189a583          	lw	a1,24(s3)
    800047dc:	014585bb          	addw	a1,a1,s4
    800047e0:	2585                	addiw	a1,a1,1
    800047e2:	0289a503          	lw	a0,40(s3)
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	f58080e7          	jalr	-168(ra) # 8000373e <bread>
    800047ee:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    800047f0:	000aa583          	lw	a1,0(s5)
    800047f4:	0289a503          	lw	a0,40(s3)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	f46080e7          	jalr	-186(ra) # 8000373e <bread>
    80004800:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80004802:	40000613          	li	a2,1024
    80004806:	05890593          	addi	a1,s2,88
    8000480a:	05850513          	addi	a0,a0,88
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	684080e7          	jalr	1668(ra) # 80000e92 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80004816:	8526                	mv	a0,s1
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	018080e7          	jalr	24(ra) # 80003830 <bwrite>
    bunpin(dbuf);
    80004820:	8526                	mv	a0,s1
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	126080e7          	jalr	294(ra) # 80003948 <bunpin>
    brelse(lbuf);
    8000482a:	854a                	mv	a0,s2
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	042080e7          	jalr	66(ra) # 8000386e <brelse>
    brelse(dbuf);
    80004834:	8526                	mv	a0,s1
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	038080e7          	jalr	56(ra) # 8000386e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000483e:	2a05                	addiw	s4,s4,1
    80004840:	0a91                	addi	s5,s5,4
    80004842:	02c9a783          	lw	a5,44(s3)
    80004846:	f8fa49e3          	blt	s4,a5,800047d8 <install_trans+0x30>
}
    8000484a:	70e2                	ld	ra,56(sp)
    8000484c:	7442                	ld	s0,48(sp)
    8000484e:	74a2                	ld	s1,40(sp)
    80004850:	7902                	ld	s2,32(sp)
    80004852:	69e2                	ld	s3,24(sp)
    80004854:	6a42                	ld	s4,16(sp)
    80004856:	6aa2                	ld	s5,8(sp)
    80004858:	6121                	addi	sp,sp,64
    8000485a:	8082                	ret
    8000485c:	8082                	ret

000000008000485e <initlog>:
void initlog(int dev, struct superblock *sb) {
    8000485e:	7179                	addi	sp,sp,-48
    80004860:	f406                	sd	ra,40(sp)
    80004862:	f022                	sd	s0,32(sp)
    80004864:	ec26                	sd	s1,24(sp)
    80004866:	e84a                	sd	s2,16(sp)
    80004868:	e44e                	sd	s3,8(sp)
    8000486a:	1800                	addi	s0,sp,48
    8000486c:	892a                	mv	s2,a0
    8000486e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004870:	0004b497          	auipc	s1,0x4b
    80004874:	4a848493          	addi	s1,s1,1192 # 8004fd18 <log>
    80004878:	00004597          	auipc	a1,0x4
    8000487c:	f0058593          	addi	a1,a1,-256 # 80008778 <syscalls+0x210>
    80004880:	8526                	mv	a0,s1
    80004882:	ffffc097          	auipc	ra,0xffffc
    80004886:	428080e7          	jalr	1064(ra) # 80000caa <initlock>
  log.start = sb->logstart;
    8000488a:	0149a583          	lw	a1,20(s3)
    8000488e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004890:	0109a783          	lw	a5,16(s3)
    80004894:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004896:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000489a:	854a                	mv	a0,s2
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	ea2080e7          	jalr	-350(ra) # 8000373e <bread>
  log.lh.n = lh->n;
    800048a4:	4d34                	lw	a3,88(a0)
    800048a6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800048a8:	02d05563          	blez	a3,800048d2 <initlog+0x74>
    800048ac:	05c50793          	addi	a5,a0,92
    800048b0:	0004b717          	auipc	a4,0x4b
    800048b4:	49870713          	addi	a4,a4,1176 # 8004fd48 <log+0x30>
    800048b8:	36fd                	addiw	a3,a3,-1
    800048ba:	1682                	slli	a3,a3,0x20
    800048bc:	9281                	srli	a3,a3,0x20
    800048be:	068a                	slli	a3,a3,0x2
    800048c0:	06050613          	addi	a2,a0,96
    800048c4:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800048c6:	4390                	lw	a2,0(a5)
    800048c8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800048ca:	0791                	addi	a5,a5,4
    800048cc:	0711                	addi	a4,a4,4
    800048ce:	fed79ce3          	bne	a5,a3,800048c6 <initlog+0x68>
  brelse(buf);
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	f9c080e7          	jalr	-100(ra) # 8000386e <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(); // if committed, copy from log to disk
    800048da:	00000097          	auipc	ra,0x0
    800048de:	ece080e7          	jalr	-306(ra) # 800047a8 <install_trans>
  log.lh.n = 0;
    800048e2:	0004b797          	auipc	a5,0x4b
    800048e6:	4607a123          	sw	zero,1122(a5) # 8004fd44 <log+0x2c>
  write_head(); // clear the log
    800048ea:	00000097          	auipc	ra,0x0
    800048ee:	e44080e7          	jalr	-444(ra) # 8000472e <write_head>
}
    800048f2:	70a2                	ld	ra,40(sp)
    800048f4:	7402                	ld	s0,32(sp)
    800048f6:	64e2                	ld	s1,24(sp)
    800048f8:	6942                	ld	s2,16(sp)
    800048fa:	69a2                	ld	s3,8(sp)
    800048fc:	6145                	addi	sp,sp,48
    800048fe:	8082                	ret

0000000080004900 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    80004900:	1101                	addi	sp,sp,-32
    80004902:	ec06                	sd	ra,24(sp)
    80004904:	e822                	sd	s0,16(sp)
    80004906:	e426                	sd	s1,8(sp)
    80004908:	e04a                	sd	s2,0(sp)
    8000490a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000490c:	0004b517          	auipc	a0,0x4b
    80004910:	40c50513          	addi	a0,a0,1036 # 8004fd18 <log>
    80004914:	ffffc097          	auipc	ra,0xffffc
    80004918:	426080e7          	jalr	1062(ra) # 80000d3a <acquire>
  while (1) {
    if (log.committing) {
    8000491c:	0004b497          	auipc	s1,0x4b
    80004920:	3fc48493          	addi	s1,s1,1020 # 8004fd18 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80004924:	4979                	li	s2,30
    80004926:	a039                	j	80004934 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004928:	85a6                	mv	a1,s1
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	05e080e7          	jalr	94(ra) # 8000298a <sleep>
    if (log.committing) {
    80004934:	50dc                	lw	a5,36(s1)
    80004936:	fbed                	bnez	a5,80004928 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80004938:	509c                	lw	a5,32(s1)
    8000493a:	0017871b          	addiw	a4,a5,1
    8000493e:	0007069b          	sext.w	a3,a4
    80004942:	0027179b          	slliw	a5,a4,0x2
    80004946:	9fb9                	addw	a5,a5,a4
    80004948:	0017979b          	slliw	a5,a5,0x1
    8000494c:	54d8                	lw	a4,44(s1)
    8000494e:	9fb9                	addw	a5,a5,a4
    80004950:	00f95963          	bge	s2,a5,80004962 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004954:	85a6                	mv	a1,s1
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	032080e7          	jalr	50(ra) # 8000298a <sleep>
    80004960:	bfd1                	j	80004934 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004962:	0004b517          	auipc	a0,0x4b
    80004966:	3b650513          	addi	a0,a0,950 # 8004fd18 <log>
    8000496a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000496c:	ffffc097          	auipc	ra,0xffffc
    80004970:	482080e7          	jalr	1154(ra) # 80000dee <release>
      break;
    }
  }
}
    80004974:	60e2                	ld	ra,24(sp)
    80004976:	6442                	ld	s0,16(sp)
    80004978:	64a2                	ld	s1,8(sp)
    8000497a:	6902                	ld	s2,0(sp)
    8000497c:	6105                	addi	sp,sp,32
    8000497e:	8082                	ret

0000000080004980 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    80004980:	7139                	addi	sp,sp,-64
    80004982:	fc06                	sd	ra,56(sp)
    80004984:	f822                	sd	s0,48(sp)
    80004986:	f426                	sd	s1,40(sp)
    80004988:	f04a                	sd	s2,32(sp)
    8000498a:	ec4e                	sd	s3,24(sp)
    8000498c:	e852                	sd	s4,16(sp)
    8000498e:	e456                	sd	s5,8(sp)
    80004990:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004992:	0004b497          	auipc	s1,0x4b
    80004996:	38648493          	addi	s1,s1,902 # 8004fd18 <log>
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffc097          	auipc	ra,0xffffc
    800049a0:	39e080e7          	jalr	926(ra) # 80000d3a <acquire>
  log.outstanding -= 1;
    800049a4:	509c                	lw	a5,32(s1)
    800049a6:	37fd                	addiw	a5,a5,-1
    800049a8:	0007891b          	sext.w	s2,a5
    800049ac:	d09c                	sw	a5,32(s1)
  if (log.committing)
    800049ae:	50dc                	lw	a5,36(s1)
    800049b0:	e7b9                	bnez	a5,800049fe <end_op+0x7e>
    panic("log.committing");
  if (log.outstanding == 0) {
    800049b2:	04091e63          	bnez	s2,80004a0e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800049b6:	0004b497          	auipc	s1,0x4b
    800049ba:	36248493          	addi	s1,s1,866 # 8004fd18 <log>
    800049be:	4785                	li	a5,1
    800049c0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffc097          	auipc	ra,0xffffc
    800049c8:	42a080e7          	jalr	1066(ra) # 80000dee <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    800049cc:	54dc                	lw	a5,44(s1)
    800049ce:	06f04763          	bgtz	a5,80004a3c <end_op+0xbc>
    acquire(&log.lock);
    800049d2:	0004b497          	auipc	s1,0x4b
    800049d6:	34648493          	addi	s1,s1,838 # 8004fd18 <log>
    800049da:	8526                	mv	a0,s1
    800049dc:	ffffc097          	auipc	ra,0xffffc
    800049e0:	35e080e7          	jalr	862(ra) # 80000d3a <acquire>
    log.committing = 0;
    800049e4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	120080e7          	jalr	288(ra) # 80002b0a <wakeup>
    release(&log.lock);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffc097          	auipc	ra,0xffffc
    800049f8:	3fa080e7          	jalr	1018(ra) # 80000dee <release>
}
    800049fc:	a03d                	j	80004a2a <end_op+0xaa>
    panic("log.committing");
    800049fe:	00004517          	auipc	a0,0x4
    80004a02:	d8250513          	addi	a0,a0,-638 # 80008780 <syscalls+0x218>
    80004a06:	ffffc097          	auipc	ra,0xffffc
    80004a0a:	bde080e7          	jalr	-1058(ra) # 800005e4 <panic>
    wakeup(&log);
    80004a0e:	0004b497          	auipc	s1,0x4b
    80004a12:	30a48493          	addi	s1,s1,778 # 8004fd18 <log>
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	0f2080e7          	jalr	242(ra) # 80002b0a <wakeup>
  release(&log.lock);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	3cc080e7          	jalr	972(ra) # 80000dee <release>
}
    80004a2a:	70e2                	ld	ra,56(sp)
    80004a2c:	7442                	ld	s0,48(sp)
    80004a2e:	74a2                	ld	s1,40(sp)
    80004a30:	7902                	ld	s2,32(sp)
    80004a32:	69e2                	ld	s3,24(sp)
    80004a34:	6a42                	ld	s4,16(sp)
    80004a36:	6aa2                	ld	s5,8(sp)
    80004a38:	6121                	addi	sp,sp,64
    80004a3a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a3c:	0004ba97          	auipc	s5,0x4b
    80004a40:	30ca8a93          	addi	s5,s5,780 # 8004fd48 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004a44:	0004ba17          	auipc	s4,0x4b
    80004a48:	2d4a0a13          	addi	s4,s4,724 # 8004fd18 <log>
    80004a4c:	018a2583          	lw	a1,24(s4)
    80004a50:	012585bb          	addw	a1,a1,s2
    80004a54:	2585                	addiw	a1,a1,1
    80004a56:	028a2503          	lw	a0,40(s4)
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	ce4080e7          	jalr	-796(ra) # 8000373e <bread>
    80004a62:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004a64:	000aa583          	lw	a1,0(s5)
    80004a68:	028a2503          	lw	a0,40(s4)
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	cd2080e7          	jalr	-814(ra) # 8000373e <bread>
    80004a74:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004a76:	40000613          	li	a2,1024
    80004a7a:	05850593          	addi	a1,a0,88
    80004a7e:	05848513          	addi	a0,s1,88
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	410080e7          	jalr	1040(ra) # 80000e92 <memmove>
    bwrite(to); // write the log
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	da4080e7          	jalr	-604(ra) # 80003830 <bwrite>
    brelse(from);
    80004a94:	854e                	mv	a0,s3
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	dd8080e7          	jalr	-552(ra) # 8000386e <brelse>
    brelse(to);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	dce080e7          	jalr	-562(ra) # 8000386e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004aa8:	2905                	addiw	s2,s2,1
    80004aaa:	0a91                	addi	s5,s5,4
    80004aac:	02ca2783          	lw	a5,44(s4)
    80004ab0:	f8f94ee3          	blt	s2,a5,80004a4c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004ab4:	00000097          	auipc	ra,0x0
    80004ab8:	c7a080e7          	jalr	-902(ra) # 8000472e <write_head>
    install_trans(); // Now install writes to home locations
    80004abc:	00000097          	auipc	ra,0x0
    80004ac0:	cec080e7          	jalr	-788(ra) # 800047a8 <install_trans>
    log.lh.n = 0;
    80004ac4:	0004b797          	auipc	a5,0x4b
    80004ac8:	2807a023          	sw	zero,640(a5) # 8004fd44 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004acc:	00000097          	auipc	ra,0x0
    80004ad0:	c62080e7          	jalr	-926(ra) # 8000472e <write_head>
    80004ad4:	bdfd                	j	800049d2 <end_op+0x52>

0000000080004ad6 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80004ad6:	1101                	addi	sp,sp,-32
    80004ad8:	ec06                	sd	ra,24(sp)
    80004ada:	e822                	sd	s0,16(sp)
    80004adc:	e426                	sd	s1,8(sp)
    80004ade:	e04a                	sd	s2,0(sp)
    80004ae0:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004ae2:	0004b717          	auipc	a4,0x4b
    80004ae6:	26272703          	lw	a4,610(a4) # 8004fd44 <log+0x2c>
    80004aea:	47f5                	li	a5,29
    80004aec:	08e7c063          	blt	a5,a4,80004b6c <log_write+0x96>
    80004af0:	84aa                	mv	s1,a0
    80004af2:	0004b797          	auipc	a5,0x4b
    80004af6:	2427a783          	lw	a5,578(a5) # 8004fd34 <log+0x1c>
    80004afa:	37fd                	addiw	a5,a5,-1
    80004afc:	06f75863          	bge	a4,a5,80004b6c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004b00:	0004b797          	auipc	a5,0x4b
    80004b04:	2387a783          	lw	a5,568(a5) # 8004fd38 <log+0x20>
    80004b08:	06f05a63          	blez	a5,80004b7c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004b0c:	0004b917          	auipc	s2,0x4b
    80004b10:	20c90913          	addi	s2,s2,524 # 8004fd18 <log>
    80004b14:	854a                	mv	a0,s2
    80004b16:	ffffc097          	auipc	ra,0xffffc
    80004b1a:	224080e7          	jalr	548(ra) # 80000d3a <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004b1e:	02c92603          	lw	a2,44(s2)
    80004b22:	06c05563          	blez	a2,80004b8c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno) // log absorbtion
    80004b26:	44cc                	lw	a1,12(s1)
    80004b28:	0004b717          	auipc	a4,0x4b
    80004b2c:	22070713          	addi	a4,a4,544 # 8004fd48 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b30:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorbtion
    80004b32:	4314                	lw	a3,0(a4)
    80004b34:	04b68d63          	beq	a3,a1,80004b8e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004b38:	2785                	addiw	a5,a5,1
    80004b3a:	0711                	addi	a4,a4,4
    80004b3c:	fec79be3          	bne	a5,a2,80004b32 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004b40:	0621                	addi	a2,a2,8
    80004b42:	060a                	slli	a2,a2,0x2
    80004b44:	0004b797          	auipc	a5,0x4b
    80004b48:	1d478793          	addi	a5,a5,468 # 8004fd18 <log>
    80004b4c:	963e                	add	a2,a2,a5
    80004b4e:	44dc                	lw	a5,12(s1)
    80004b50:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80004b52:	8526                	mv	a0,s1
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	db8080e7          	jalr	-584(ra) # 8000390c <bpin>
    log.lh.n++;
    80004b5c:	0004b717          	auipc	a4,0x4b
    80004b60:	1bc70713          	addi	a4,a4,444 # 8004fd18 <log>
    80004b64:	575c                	lw	a5,44(a4)
    80004b66:	2785                	addiw	a5,a5,1
    80004b68:	d75c                	sw	a5,44(a4)
    80004b6a:	a83d                	j	80004ba8 <log_write+0xd2>
    panic("too big a transaction");
    80004b6c:	00004517          	auipc	a0,0x4
    80004b70:	c2450513          	addi	a0,a0,-988 # 80008790 <syscalls+0x228>
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	a70080e7          	jalr	-1424(ra) # 800005e4 <panic>
    panic("log_write outside of trans");
    80004b7c:	00004517          	auipc	a0,0x4
    80004b80:	c2c50513          	addi	a0,a0,-980 # 800087a8 <syscalls+0x240>
    80004b84:	ffffc097          	auipc	ra,0xffffc
    80004b88:	a60080e7          	jalr	-1440(ra) # 800005e4 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004b8c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004b8e:	00878713          	addi	a4,a5,8
    80004b92:	00271693          	slli	a3,a4,0x2
    80004b96:	0004b717          	auipc	a4,0x4b
    80004b9a:	18270713          	addi	a4,a4,386 # 8004fd18 <log>
    80004b9e:	9736                	add	a4,a4,a3
    80004ba0:	44d4                	lw	a3,12(s1)
    80004ba2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004ba4:	faf607e3          	beq	a2,a5,80004b52 <log_write+0x7c>
  }
  release(&log.lock);
    80004ba8:	0004b517          	auipc	a0,0x4b
    80004bac:	17050513          	addi	a0,a0,368 # 8004fd18 <log>
    80004bb0:	ffffc097          	auipc	ra,0xffffc
    80004bb4:	23e080e7          	jalr	574(ra) # 80000dee <release>
}
    80004bb8:	60e2                	ld	ra,24(sp)
    80004bba:	6442                	ld	s0,16(sp)
    80004bbc:	64a2                	ld	s1,8(sp)
    80004bbe:	6902                	ld	s2,0(sp)
    80004bc0:	6105                	addi	sp,sp,32
    80004bc2:	8082                	ret

0000000080004bc4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004bc4:	1101                	addi	sp,sp,-32
    80004bc6:	ec06                	sd	ra,24(sp)
    80004bc8:	e822                	sd	s0,16(sp)
    80004bca:	e426                	sd	s1,8(sp)
    80004bcc:	e04a                	sd	s2,0(sp)
    80004bce:	1000                	addi	s0,sp,32
    80004bd0:	84aa                	mv	s1,a0
    80004bd2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004bd4:	00004597          	auipc	a1,0x4
    80004bd8:	bf458593          	addi	a1,a1,-1036 # 800087c8 <syscalls+0x260>
    80004bdc:	0521                	addi	a0,a0,8
    80004bde:	ffffc097          	auipc	ra,0xffffc
    80004be2:	0cc080e7          	jalr	204(ra) # 80000caa <initlock>
  lk->name = name;
    80004be6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004bea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004bee:	0204a423          	sw	zero,40(s1)
}
    80004bf2:	60e2                	ld	ra,24(sp)
    80004bf4:	6442                	ld	s0,16(sp)
    80004bf6:	64a2                	ld	s1,8(sp)
    80004bf8:	6902                	ld	s2,0(sp)
    80004bfa:	6105                	addi	sp,sp,32
    80004bfc:	8082                	ret

0000000080004bfe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004bfe:	1101                	addi	sp,sp,-32
    80004c00:	ec06                	sd	ra,24(sp)
    80004c02:	e822                	sd	s0,16(sp)
    80004c04:	e426                	sd	s1,8(sp)
    80004c06:	e04a                	sd	s2,0(sp)
    80004c08:	1000                	addi	s0,sp,32
    80004c0a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c0c:	00850913          	addi	s2,a0,8
    80004c10:	854a                	mv	a0,s2
    80004c12:	ffffc097          	auipc	ra,0xffffc
    80004c16:	128080e7          	jalr	296(ra) # 80000d3a <acquire>
  while (lk->locked) {
    80004c1a:	409c                	lw	a5,0(s1)
    80004c1c:	cb89                	beqz	a5,80004c2e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004c1e:	85ca                	mv	a1,s2
    80004c20:	8526                	mv	a0,s1
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	d68080e7          	jalr	-664(ra) # 8000298a <sleep>
  while (lk->locked) {
    80004c2a:	409c                	lw	a5,0(s1)
    80004c2c:	fbed                	bnez	a5,80004c1e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c2e:	4785                	li	a5,1
    80004c30:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	4d8080e7          	jalr	1240(ra) # 8000210a <myproc>
    80004c3a:	5d1c                	lw	a5,56(a0)
    80004c3c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	1ae080e7          	jalr	430(ra) # 80000dee <release>
}
    80004c48:	60e2                	ld	ra,24(sp)
    80004c4a:	6442                	ld	s0,16(sp)
    80004c4c:	64a2                	ld	s1,8(sp)
    80004c4e:	6902                	ld	s2,0(sp)
    80004c50:	6105                	addi	sp,sp,32
    80004c52:	8082                	ret

0000000080004c54 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004c54:	1101                	addi	sp,sp,-32
    80004c56:	ec06                	sd	ra,24(sp)
    80004c58:	e822                	sd	s0,16(sp)
    80004c5a:	e426                	sd	s1,8(sp)
    80004c5c:	e04a                	sd	s2,0(sp)
    80004c5e:	1000                	addi	s0,sp,32
    80004c60:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c62:	00850913          	addi	s2,a0,8
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffc097          	auipc	ra,0xffffc
    80004c6c:	0d2080e7          	jalr	210(ra) # 80000d3a <acquire>
  lk->locked = 0;
    80004c70:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c74:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004c78:	8526                	mv	a0,s1
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	e90080e7          	jalr	-368(ra) # 80002b0a <wakeup>
  release(&lk->lk);
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffc097          	auipc	ra,0xffffc
    80004c88:	16a080e7          	jalr	362(ra) # 80000dee <release>
}
    80004c8c:	60e2                	ld	ra,24(sp)
    80004c8e:	6442                	ld	s0,16(sp)
    80004c90:	64a2                	ld	s1,8(sp)
    80004c92:	6902                	ld	s2,0(sp)
    80004c94:	6105                	addi	sp,sp,32
    80004c96:	8082                	ret

0000000080004c98 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004c98:	7179                	addi	sp,sp,-48
    80004c9a:	f406                	sd	ra,40(sp)
    80004c9c:	f022                	sd	s0,32(sp)
    80004c9e:	ec26                	sd	s1,24(sp)
    80004ca0:	e84a                	sd	s2,16(sp)
    80004ca2:	e44e                	sd	s3,8(sp)
    80004ca4:	1800                	addi	s0,sp,48
    80004ca6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ca8:	00850913          	addi	s2,a0,8
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	08c080e7          	jalr	140(ra) # 80000d3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004cb6:	409c                	lw	a5,0(s1)
    80004cb8:	ef99                	bnez	a5,80004cd6 <holdingsleep+0x3e>
    80004cba:	4481                	li	s1,0
  release(&lk->lk);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffc097          	auipc	ra,0xffffc
    80004cc2:	130080e7          	jalr	304(ra) # 80000dee <release>
  return r;
}
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	70a2                	ld	ra,40(sp)
    80004cca:	7402                	ld	s0,32(sp)
    80004ccc:	64e2                	ld	s1,24(sp)
    80004cce:	6942                	ld	s2,16(sp)
    80004cd0:	69a2                	ld	s3,8(sp)
    80004cd2:	6145                	addi	sp,sp,48
    80004cd4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004cd6:	0284a983          	lw	s3,40(s1)
    80004cda:	ffffd097          	auipc	ra,0xffffd
    80004cde:	430080e7          	jalr	1072(ra) # 8000210a <myproc>
    80004ce2:	5d04                	lw	s1,56(a0)
    80004ce4:	413484b3          	sub	s1,s1,s3
    80004ce8:	0014b493          	seqz	s1,s1
    80004cec:	bfc1                	j	80004cbc <holdingsleep+0x24>

0000000080004cee <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004cee:	1141                	addi	sp,sp,-16
    80004cf0:	e406                	sd	ra,8(sp)
    80004cf2:	e022                	sd	s0,0(sp)
    80004cf4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004cf6:	00004597          	auipc	a1,0x4
    80004cfa:	ae258593          	addi	a1,a1,-1310 # 800087d8 <syscalls+0x270>
    80004cfe:	0004b517          	auipc	a0,0x4b
    80004d02:	16250513          	addi	a0,a0,354 # 8004fe60 <ftable>
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	fa4080e7          	jalr	-92(ra) # 80000caa <initlock>
}
    80004d0e:	60a2                	ld	ra,8(sp)
    80004d10:	6402                	ld	s0,0(sp)
    80004d12:	0141                	addi	sp,sp,16
    80004d14:	8082                	ret

0000000080004d16 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d16:	1101                	addi	sp,sp,-32
    80004d18:	ec06                	sd	ra,24(sp)
    80004d1a:	e822                	sd	s0,16(sp)
    80004d1c:	e426                	sd	s1,8(sp)
    80004d1e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d20:	0004b517          	auipc	a0,0x4b
    80004d24:	14050513          	addi	a0,a0,320 # 8004fe60 <ftable>
    80004d28:	ffffc097          	auipc	ra,0xffffc
    80004d2c:	012080e7          	jalr	18(ra) # 80000d3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d30:	0004b497          	auipc	s1,0x4b
    80004d34:	14848493          	addi	s1,s1,328 # 8004fe78 <ftable+0x18>
    80004d38:	0004c717          	auipc	a4,0x4c
    80004d3c:	0e070713          	addi	a4,a4,224 # 80050e18 <ftable+0xfb8>
    if(f->ref == 0){
    80004d40:	40dc                	lw	a5,4(s1)
    80004d42:	cf99                	beqz	a5,80004d60 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d44:	02848493          	addi	s1,s1,40
    80004d48:	fee49ce3          	bne	s1,a4,80004d40 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004d4c:	0004b517          	auipc	a0,0x4b
    80004d50:	11450513          	addi	a0,a0,276 # 8004fe60 <ftable>
    80004d54:	ffffc097          	auipc	ra,0xffffc
    80004d58:	09a080e7          	jalr	154(ra) # 80000dee <release>
  return 0;
    80004d5c:	4481                	li	s1,0
    80004d5e:	a819                	j	80004d74 <filealloc+0x5e>
      f->ref = 1;
    80004d60:	4785                	li	a5,1
    80004d62:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004d64:	0004b517          	auipc	a0,0x4b
    80004d68:	0fc50513          	addi	a0,a0,252 # 8004fe60 <ftable>
    80004d6c:	ffffc097          	auipc	ra,0xffffc
    80004d70:	082080e7          	jalr	130(ra) # 80000dee <release>
}
    80004d74:	8526                	mv	a0,s1
    80004d76:	60e2                	ld	ra,24(sp)
    80004d78:	6442                	ld	s0,16(sp)
    80004d7a:	64a2                	ld	s1,8(sp)
    80004d7c:	6105                	addi	sp,sp,32
    80004d7e:	8082                	ret

0000000080004d80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004d80:	1101                	addi	sp,sp,-32
    80004d82:	ec06                	sd	ra,24(sp)
    80004d84:	e822                	sd	s0,16(sp)
    80004d86:	e426                	sd	s1,8(sp)
    80004d88:	1000                	addi	s0,sp,32
    80004d8a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004d8c:	0004b517          	auipc	a0,0x4b
    80004d90:	0d450513          	addi	a0,a0,212 # 8004fe60 <ftable>
    80004d94:	ffffc097          	auipc	ra,0xffffc
    80004d98:	fa6080e7          	jalr	-90(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004d9c:	40dc                	lw	a5,4(s1)
    80004d9e:	02f05263          	blez	a5,80004dc2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004da2:	2785                	addiw	a5,a5,1
    80004da4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004da6:	0004b517          	auipc	a0,0x4b
    80004daa:	0ba50513          	addi	a0,a0,186 # 8004fe60 <ftable>
    80004dae:	ffffc097          	auipc	ra,0xffffc
    80004db2:	040080e7          	jalr	64(ra) # 80000dee <release>
  return f;
}
    80004db6:	8526                	mv	a0,s1
    80004db8:	60e2                	ld	ra,24(sp)
    80004dba:	6442                	ld	s0,16(sp)
    80004dbc:	64a2                	ld	s1,8(sp)
    80004dbe:	6105                	addi	sp,sp,32
    80004dc0:	8082                	ret
    panic("filedup");
    80004dc2:	00004517          	auipc	a0,0x4
    80004dc6:	a1e50513          	addi	a0,a0,-1506 # 800087e0 <syscalls+0x278>
    80004dca:	ffffc097          	auipc	ra,0xffffc
    80004dce:	81a080e7          	jalr	-2022(ra) # 800005e4 <panic>

0000000080004dd2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004dd2:	7139                	addi	sp,sp,-64
    80004dd4:	fc06                	sd	ra,56(sp)
    80004dd6:	f822                	sd	s0,48(sp)
    80004dd8:	f426                	sd	s1,40(sp)
    80004dda:	f04a                	sd	s2,32(sp)
    80004ddc:	ec4e                	sd	s3,24(sp)
    80004dde:	e852                	sd	s4,16(sp)
    80004de0:	e456                	sd	s5,8(sp)
    80004de2:	0080                	addi	s0,sp,64
    80004de4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004de6:	0004b517          	auipc	a0,0x4b
    80004dea:	07a50513          	addi	a0,a0,122 # 8004fe60 <ftable>
    80004dee:	ffffc097          	auipc	ra,0xffffc
    80004df2:	f4c080e7          	jalr	-180(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004df6:	40dc                	lw	a5,4(s1)
    80004df8:	06f05163          	blez	a5,80004e5a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004dfc:	37fd                	addiw	a5,a5,-1
    80004dfe:	0007871b          	sext.w	a4,a5
    80004e02:	c0dc                	sw	a5,4(s1)
    80004e04:	06e04363          	bgtz	a4,80004e6a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e08:	0004a903          	lw	s2,0(s1)
    80004e0c:	0094ca83          	lbu	s5,9(s1)
    80004e10:	0104ba03          	ld	s4,16(s1)
    80004e14:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004e18:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e1c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e20:	0004b517          	auipc	a0,0x4b
    80004e24:	04050513          	addi	a0,a0,64 # 8004fe60 <ftable>
    80004e28:	ffffc097          	auipc	ra,0xffffc
    80004e2c:	fc6080e7          	jalr	-58(ra) # 80000dee <release>

  if(ff.type == FD_PIPE){
    80004e30:	4785                	li	a5,1
    80004e32:	04f90d63          	beq	s2,a5,80004e8c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e36:	3979                	addiw	s2,s2,-2
    80004e38:	4785                	li	a5,1
    80004e3a:	0527e063          	bltu	a5,s2,80004e7a <fileclose+0xa8>
    begin_op();
    80004e3e:	00000097          	auipc	ra,0x0
    80004e42:	ac2080e7          	jalr	-1342(ra) # 80004900 <begin_op>
    iput(ff.ip);
    80004e46:	854e                	mv	a0,s3
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	2b2080e7          	jalr	690(ra) # 800040fa <iput>
    end_op();
    80004e50:	00000097          	auipc	ra,0x0
    80004e54:	b30080e7          	jalr	-1232(ra) # 80004980 <end_op>
    80004e58:	a00d                	j	80004e7a <fileclose+0xa8>
    panic("fileclose");
    80004e5a:	00004517          	auipc	a0,0x4
    80004e5e:	98e50513          	addi	a0,a0,-1650 # 800087e8 <syscalls+0x280>
    80004e62:	ffffb097          	auipc	ra,0xffffb
    80004e66:	782080e7          	jalr	1922(ra) # 800005e4 <panic>
    release(&ftable.lock);
    80004e6a:	0004b517          	auipc	a0,0x4b
    80004e6e:	ff650513          	addi	a0,a0,-10 # 8004fe60 <ftable>
    80004e72:	ffffc097          	auipc	ra,0xffffc
    80004e76:	f7c080e7          	jalr	-132(ra) # 80000dee <release>
  }
}
    80004e7a:	70e2                	ld	ra,56(sp)
    80004e7c:	7442                	ld	s0,48(sp)
    80004e7e:	74a2                	ld	s1,40(sp)
    80004e80:	7902                	ld	s2,32(sp)
    80004e82:	69e2                	ld	s3,24(sp)
    80004e84:	6a42                	ld	s4,16(sp)
    80004e86:	6aa2                	ld	s5,8(sp)
    80004e88:	6121                	addi	sp,sp,64
    80004e8a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004e8c:	85d6                	mv	a1,s5
    80004e8e:	8552                	mv	a0,s4
    80004e90:	00000097          	auipc	ra,0x0
    80004e94:	372080e7          	jalr	882(ra) # 80005202 <pipeclose>
    80004e98:	b7cd                	j	80004e7a <fileclose+0xa8>

0000000080004e9a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004e9a:	715d                	addi	sp,sp,-80
    80004e9c:	e486                	sd	ra,72(sp)
    80004e9e:	e0a2                	sd	s0,64(sp)
    80004ea0:	fc26                	sd	s1,56(sp)
    80004ea2:	f84a                	sd	s2,48(sp)
    80004ea4:	f44e                	sd	s3,40(sp)
    80004ea6:	0880                	addi	s0,sp,80
    80004ea8:	84aa                	mv	s1,a0
    80004eaa:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004eac:	ffffd097          	auipc	ra,0xffffd
    80004eb0:	25e080e7          	jalr	606(ra) # 8000210a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004eb4:	409c                	lw	a5,0(s1)
    80004eb6:	37f9                	addiw	a5,a5,-2
    80004eb8:	4705                	li	a4,1
    80004eba:	04f76763          	bltu	a4,a5,80004f08 <filestat+0x6e>
    80004ebe:	892a                	mv	s2,a0
    ilock(f->ip);
    80004ec0:	6c88                	ld	a0,24(s1)
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	07e080e7          	jalr	126(ra) # 80003f40 <ilock>
    stati(f->ip, &st);
    80004eca:	fb840593          	addi	a1,s0,-72
    80004ece:	6c88                	ld	a0,24(s1)
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	2fa080e7          	jalr	762(ra) # 800041ca <stati>
    iunlock(f->ip);
    80004ed8:	6c88                	ld	a0,24(s1)
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	128080e7          	jalr	296(ra) # 80004002 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ee2:	46e1                	li	a3,24
    80004ee4:	fb840613          	addi	a2,s0,-72
    80004ee8:	85ce                	mv	a1,s3
    80004eea:	05093503          	ld	a0,80(s2)
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	b32080e7          	jalr	-1230(ra) # 80001a20 <copyout>
    80004ef6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004efa:	60a6                	ld	ra,72(sp)
    80004efc:	6406                	ld	s0,64(sp)
    80004efe:	74e2                	ld	s1,56(sp)
    80004f00:	7942                	ld	s2,48(sp)
    80004f02:	79a2                	ld	s3,40(sp)
    80004f04:	6161                	addi	sp,sp,80
    80004f06:	8082                	ret
  return -1;
    80004f08:	557d                	li	a0,-1
    80004f0a:	bfc5                	j	80004efa <filestat+0x60>

0000000080004f0c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f0c:	7179                	addi	sp,sp,-48
    80004f0e:	f406                	sd	ra,40(sp)
    80004f10:	f022                	sd	s0,32(sp)
    80004f12:	ec26                	sd	s1,24(sp)
    80004f14:	e84a                	sd	s2,16(sp)
    80004f16:	e44e                	sd	s3,8(sp)
    80004f18:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f1a:	00854783          	lbu	a5,8(a0)
    80004f1e:	c3d5                	beqz	a5,80004fc2 <fileread+0xb6>
    80004f20:	84aa                	mv	s1,a0
    80004f22:	89ae                	mv	s3,a1
    80004f24:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f26:	411c                	lw	a5,0(a0)
    80004f28:	4705                	li	a4,1
    80004f2a:	04e78963          	beq	a5,a4,80004f7c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f2e:	470d                	li	a4,3
    80004f30:	04e78d63          	beq	a5,a4,80004f8a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f34:	4709                	li	a4,2
    80004f36:	06e79e63          	bne	a5,a4,80004fb2 <fileread+0xa6>
    ilock(f->ip);
    80004f3a:	6d08                	ld	a0,24(a0)
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	004080e7          	jalr	4(ra) # 80003f40 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004f44:	874a                	mv	a4,s2
    80004f46:	5094                	lw	a3,32(s1)
    80004f48:	864e                	mv	a2,s3
    80004f4a:	4585                	li	a1,1
    80004f4c:	6c88                	ld	a0,24(s1)
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	2a6080e7          	jalr	678(ra) # 800041f4 <readi>
    80004f56:	892a                	mv	s2,a0
    80004f58:	00a05563          	blez	a0,80004f62 <fileread+0x56>
      f->off += r;
    80004f5c:	509c                	lw	a5,32(s1)
    80004f5e:	9fa9                	addw	a5,a5,a0
    80004f60:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f62:	6c88                	ld	a0,24(s1)
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	09e080e7          	jalr	158(ra) # 80004002 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004f6c:	854a                	mv	a0,s2
    80004f6e:	70a2                	ld	ra,40(sp)
    80004f70:	7402                	ld	s0,32(sp)
    80004f72:	64e2                	ld	s1,24(sp)
    80004f74:	6942                	ld	s2,16(sp)
    80004f76:	69a2                	ld	s3,8(sp)
    80004f78:	6145                	addi	sp,sp,48
    80004f7a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004f7c:	6908                	ld	a0,16(a0)
    80004f7e:	00000097          	auipc	ra,0x0
    80004f82:	3f4080e7          	jalr	1012(ra) # 80005372 <piperead>
    80004f86:	892a                	mv	s2,a0
    80004f88:	b7d5                	j	80004f6c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004f8a:	02451783          	lh	a5,36(a0)
    80004f8e:	03079693          	slli	a3,a5,0x30
    80004f92:	92c1                	srli	a3,a3,0x30
    80004f94:	4725                	li	a4,9
    80004f96:	02d76863          	bltu	a4,a3,80004fc6 <fileread+0xba>
    80004f9a:	0792                	slli	a5,a5,0x4
    80004f9c:	0004b717          	auipc	a4,0x4b
    80004fa0:	e2470713          	addi	a4,a4,-476 # 8004fdc0 <devsw>
    80004fa4:	97ba                	add	a5,a5,a4
    80004fa6:	639c                	ld	a5,0(a5)
    80004fa8:	c38d                	beqz	a5,80004fca <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004faa:	4505                	li	a0,1
    80004fac:	9782                	jalr	a5
    80004fae:	892a                	mv	s2,a0
    80004fb0:	bf75                	j	80004f6c <fileread+0x60>
    panic("fileread");
    80004fb2:	00004517          	auipc	a0,0x4
    80004fb6:	84650513          	addi	a0,a0,-1978 # 800087f8 <syscalls+0x290>
    80004fba:	ffffb097          	auipc	ra,0xffffb
    80004fbe:	62a080e7          	jalr	1578(ra) # 800005e4 <panic>
    return -1;
    80004fc2:	597d                	li	s2,-1
    80004fc4:	b765                	j	80004f6c <fileread+0x60>
      return -1;
    80004fc6:	597d                	li	s2,-1
    80004fc8:	b755                	j	80004f6c <fileread+0x60>
    80004fca:	597d                	li	s2,-1
    80004fcc:	b745                	j	80004f6c <fileread+0x60>

0000000080004fce <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004fce:	00954783          	lbu	a5,9(a0)
    80004fd2:	14078563          	beqz	a5,8000511c <filewrite+0x14e>
{
    80004fd6:	715d                	addi	sp,sp,-80
    80004fd8:	e486                	sd	ra,72(sp)
    80004fda:	e0a2                	sd	s0,64(sp)
    80004fdc:	fc26                	sd	s1,56(sp)
    80004fde:	f84a                	sd	s2,48(sp)
    80004fe0:	f44e                	sd	s3,40(sp)
    80004fe2:	f052                	sd	s4,32(sp)
    80004fe4:	ec56                	sd	s5,24(sp)
    80004fe6:	e85a                	sd	s6,16(sp)
    80004fe8:	e45e                	sd	s7,8(sp)
    80004fea:	e062                	sd	s8,0(sp)
    80004fec:	0880                	addi	s0,sp,80
    80004fee:	892a                	mv	s2,a0
    80004ff0:	8aae                	mv	s5,a1
    80004ff2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ff4:	411c                	lw	a5,0(a0)
    80004ff6:	4705                	li	a4,1
    80004ff8:	02e78263          	beq	a5,a4,8000501c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004ffc:	470d                	li	a4,3
    80004ffe:	02e78563          	beq	a5,a4,80005028 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005002:	4709                	li	a4,2
    80005004:	10e79463          	bne	a5,a4,8000510c <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005008:	0ec05e63          	blez	a2,80005104 <filewrite+0x136>
    int i = 0;
    8000500c:	4981                	li	s3,0
    8000500e:	6b05                	lui	s6,0x1
    80005010:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80005014:	6b85                	lui	s7,0x1
    80005016:	c00b8b9b          	addiw	s7,s7,-1024
    8000501a:	a851                	j	800050ae <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000501c:	6908                	ld	a0,16(a0)
    8000501e:	00000097          	auipc	ra,0x0
    80005022:	254080e7          	jalr	596(ra) # 80005272 <pipewrite>
    80005026:	a85d                	j	800050dc <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005028:	02451783          	lh	a5,36(a0)
    8000502c:	03079693          	slli	a3,a5,0x30
    80005030:	92c1                	srli	a3,a3,0x30
    80005032:	4725                	li	a4,9
    80005034:	0ed76663          	bltu	a4,a3,80005120 <filewrite+0x152>
    80005038:	0792                	slli	a5,a5,0x4
    8000503a:	0004b717          	auipc	a4,0x4b
    8000503e:	d8670713          	addi	a4,a4,-634 # 8004fdc0 <devsw>
    80005042:	97ba                	add	a5,a5,a4
    80005044:	679c                	ld	a5,8(a5)
    80005046:	cff9                	beqz	a5,80005124 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80005048:	4505                	li	a0,1
    8000504a:	9782                	jalr	a5
    8000504c:	a841                	j	800050dc <filewrite+0x10e>
    8000504e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80005052:	00000097          	auipc	ra,0x0
    80005056:	8ae080e7          	jalr	-1874(ra) # 80004900 <begin_op>
      ilock(f->ip);
    8000505a:	01893503          	ld	a0,24(s2)
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	ee2080e7          	jalr	-286(ra) # 80003f40 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005066:	8762                	mv	a4,s8
    80005068:	02092683          	lw	a3,32(s2)
    8000506c:	01598633          	add	a2,s3,s5
    80005070:	4585                	li	a1,1
    80005072:	01893503          	ld	a0,24(s2)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	276080e7          	jalr	630(ra) # 800042ec <writei>
    8000507e:	84aa                	mv	s1,a0
    80005080:	02a05f63          	blez	a0,800050be <filewrite+0xf0>
        f->off += r;
    80005084:	02092783          	lw	a5,32(s2)
    80005088:	9fa9                	addw	a5,a5,a0
    8000508a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000508e:	01893503          	ld	a0,24(s2)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	f70080e7          	jalr	-144(ra) # 80004002 <iunlock>
      end_op();
    8000509a:	00000097          	auipc	ra,0x0
    8000509e:	8e6080e7          	jalr	-1818(ra) # 80004980 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800050a2:	049c1963          	bne	s8,s1,800050f4 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    800050a6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800050aa:	0349d663          	bge	s3,s4,800050d6 <filewrite+0x108>
      int n1 = n - i;
    800050ae:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800050b2:	84be                	mv	s1,a5
    800050b4:	2781                	sext.w	a5,a5
    800050b6:	f8fb5ce3          	bge	s6,a5,8000504e <filewrite+0x80>
    800050ba:	84de                	mv	s1,s7
    800050bc:	bf49                	j	8000504e <filewrite+0x80>
      iunlock(f->ip);
    800050be:	01893503          	ld	a0,24(s2)
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	f40080e7          	jalr	-192(ra) # 80004002 <iunlock>
      end_op();
    800050ca:	00000097          	auipc	ra,0x0
    800050ce:	8b6080e7          	jalr	-1866(ra) # 80004980 <end_op>
      if(r < 0)
    800050d2:	fc04d8e3          	bgez	s1,800050a2 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    800050d6:	8552                	mv	a0,s4
    800050d8:	033a1863          	bne	s4,s3,80005108 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800050dc:	60a6                	ld	ra,72(sp)
    800050de:	6406                	ld	s0,64(sp)
    800050e0:	74e2                	ld	s1,56(sp)
    800050e2:	7942                	ld	s2,48(sp)
    800050e4:	79a2                	ld	s3,40(sp)
    800050e6:	7a02                	ld	s4,32(sp)
    800050e8:	6ae2                	ld	s5,24(sp)
    800050ea:	6b42                	ld	s6,16(sp)
    800050ec:	6ba2                	ld	s7,8(sp)
    800050ee:	6c02                	ld	s8,0(sp)
    800050f0:	6161                	addi	sp,sp,80
    800050f2:	8082                	ret
        panic("short filewrite");
    800050f4:	00003517          	auipc	a0,0x3
    800050f8:	71450513          	addi	a0,a0,1812 # 80008808 <syscalls+0x2a0>
    800050fc:	ffffb097          	auipc	ra,0xffffb
    80005100:	4e8080e7          	jalr	1256(ra) # 800005e4 <panic>
    int i = 0;
    80005104:	4981                	li	s3,0
    80005106:	bfc1                	j	800050d6 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80005108:	557d                	li	a0,-1
    8000510a:	bfc9                	j	800050dc <filewrite+0x10e>
    panic("filewrite");
    8000510c:	00003517          	auipc	a0,0x3
    80005110:	70c50513          	addi	a0,a0,1804 # 80008818 <syscalls+0x2b0>
    80005114:	ffffb097          	auipc	ra,0xffffb
    80005118:	4d0080e7          	jalr	1232(ra) # 800005e4 <panic>
    return -1;
    8000511c:	557d                	li	a0,-1
}
    8000511e:	8082                	ret
      return -1;
    80005120:	557d                	li	a0,-1
    80005122:	bf6d                	j	800050dc <filewrite+0x10e>
    80005124:	557d                	li	a0,-1
    80005126:	bf5d                	j	800050dc <filewrite+0x10e>

0000000080005128 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005128:	7179                	addi	sp,sp,-48
    8000512a:	f406                	sd	ra,40(sp)
    8000512c:	f022                	sd	s0,32(sp)
    8000512e:	ec26                	sd	s1,24(sp)
    80005130:	e84a                	sd	s2,16(sp)
    80005132:	e44e                	sd	s3,8(sp)
    80005134:	e052                	sd	s4,0(sp)
    80005136:	1800                	addi	s0,sp,48
    80005138:	84aa                	mv	s1,a0
    8000513a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000513c:	0005b023          	sd	zero,0(a1)
    80005140:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005144:	00000097          	auipc	ra,0x0
    80005148:	bd2080e7          	jalr	-1070(ra) # 80004d16 <filealloc>
    8000514c:	e088                	sd	a0,0(s1)
    8000514e:	c551                	beqz	a0,800051da <pipealloc+0xb2>
    80005150:	00000097          	auipc	ra,0x0
    80005154:	bc6080e7          	jalr	-1082(ra) # 80004d16 <filealloc>
    80005158:	00aa3023          	sd	a0,0(s4)
    8000515c:	c92d                	beqz	a0,800051ce <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000515e:	ffffc097          	auipc	ra,0xffffc
    80005162:	a9e080e7          	jalr	-1378(ra) # 80000bfc <kalloc>
    80005166:	892a                	mv	s2,a0
    80005168:	c125                	beqz	a0,800051c8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000516a:	4985                	li	s3,1
    8000516c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005170:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005174:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005178:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000517c:	00003597          	auipc	a1,0x3
    80005180:	6ac58593          	addi	a1,a1,1708 # 80008828 <syscalls+0x2c0>
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	b26080e7          	jalr	-1242(ra) # 80000caa <initlock>
  (*f0)->type = FD_PIPE;
    8000518c:	609c                	ld	a5,0(s1)
    8000518e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005192:	609c                	ld	a5,0(s1)
    80005194:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005198:	609c                	ld	a5,0(s1)
    8000519a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000519e:	609c                	ld	a5,0(s1)
    800051a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800051a4:	000a3783          	ld	a5,0(s4)
    800051a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800051ac:	000a3783          	ld	a5,0(s4)
    800051b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800051b4:	000a3783          	ld	a5,0(s4)
    800051b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800051bc:	000a3783          	ld	a5,0(s4)
    800051c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800051c4:	4501                	li	a0,0
    800051c6:	a025                	j	800051ee <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800051c8:	6088                	ld	a0,0(s1)
    800051ca:	e501                	bnez	a0,800051d2 <pipealloc+0xaa>
    800051cc:	a039                	j	800051da <pipealloc+0xb2>
    800051ce:	6088                	ld	a0,0(s1)
    800051d0:	c51d                	beqz	a0,800051fe <pipealloc+0xd6>
    fileclose(*f0);
    800051d2:	00000097          	auipc	ra,0x0
    800051d6:	c00080e7          	jalr	-1024(ra) # 80004dd2 <fileclose>
  if(*f1)
    800051da:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800051de:	557d                	li	a0,-1
  if(*f1)
    800051e0:	c799                	beqz	a5,800051ee <pipealloc+0xc6>
    fileclose(*f1);
    800051e2:	853e                	mv	a0,a5
    800051e4:	00000097          	auipc	ra,0x0
    800051e8:	bee080e7          	jalr	-1042(ra) # 80004dd2 <fileclose>
  return -1;
    800051ec:	557d                	li	a0,-1
}
    800051ee:	70a2                	ld	ra,40(sp)
    800051f0:	7402                	ld	s0,32(sp)
    800051f2:	64e2                	ld	s1,24(sp)
    800051f4:	6942                	ld	s2,16(sp)
    800051f6:	69a2                	ld	s3,8(sp)
    800051f8:	6a02                	ld	s4,0(sp)
    800051fa:	6145                	addi	sp,sp,48
    800051fc:	8082                	ret
  return -1;
    800051fe:	557d                	li	a0,-1
    80005200:	b7fd                	j	800051ee <pipealloc+0xc6>

0000000080005202 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005202:	1101                	addi	sp,sp,-32
    80005204:	ec06                	sd	ra,24(sp)
    80005206:	e822                	sd	s0,16(sp)
    80005208:	e426                	sd	s1,8(sp)
    8000520a:	e04a                	sd	s2,0(sp)
    8000520c:	1000                	addi	s0,sp,32
    8000520e:	84aa                	mv	s1,a0
    80005210:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005212:	ffffc097          	auipc	ra,0xffffc
    80005216:	b28080e7          	jalr	-1240(ra) # 80000d3a <acquire>
  if(writable){
    8000521a:	02090d63          	beqz	s2,80005254 <pipeclose+0x52>
    pi->writeopen = 0;
    8000521e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005222:	21848513          	addi	a0,s1,536
    80005226:	ffffe097          	auipc	ra,0xffffe
    8000522a:	8e4080e7          	jalr	-1820(ra) # 80002b0a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000522e:	2204b783          	ld	a5,544(s1)
    80005232:	eb95                	bnez	a5,80005266 <pipeclose+0x64>
    release(&pi->lock);
    80005234:	8526                	mv	a0,s1
    80005236:	ffffc097          	auipc	ra,0xffffc
    8000523a:	bb8080e7          	jalr	-1096(ra) # 80000dee <release>
    kfree((char*)pi);
    8000523e:	8526                	mv	a0,s1
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	84a080e7          	jalr	-1974(ra) # 80000a8a <kfree>
  } else
    release(&pi->lock);
}
    80005248:	60e2                	ld	ra,24(sp)
    8000524a:	6442                	ld	s0,16(sp)
    8000524c:	64a2                	ld	s1,8(sp)
    8000524e:	6902                	ld	s2,0(sp)
    80005250:	6105                	addi	sp,sp,32
    80005252:	8082                	ret
    pi->readopen = 0;
    80005254:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005258:	21c48513          	addi	a0,s1,540
    8000525c:	ffffe097          	auipc	ra,0xffffe
    80005260:	8ae080e7          	jalr	-1874(ra) # 80002b0a <wakeup>
    80005264:	b7e9                	j	8000522e <pipeclose+0x2c>
    release(&pi->lock);
    80005266:	8526                	mv	a0,s1
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	b86080e7          	jalr	-1146(ra) # 80000dee <release>
}
    80005270:	bfe1                	j	80005248 <pipeclose+0x46>

0000000080005272 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005272:	711d                	addi	sp,sp,-96
    80005274:	ec86                	sd	ra,88(sp)
    80005276:	e8a2                	sd	s0,80(sp)
    80005278:	e4a6                	sd	s1,72(sp)
    8000527a:	e0ca                	sd	s2,64(sp)
    8000527c:	fc4e                	sd	s3,56(sp)
    8000527e:	f852                	sd	s4,48(sp)
    80005280:	f456                	sd	s5,40(sp)
    80005282:	f05a                	sd	s6,32(sp)
    80005284:	ec5e                	sd	s7,24(sp)
    80005286:	e862                	sd	s8,16(sp)
    80005288:	1080                	addi	s0,sp,96
    8000528a:	84aa                	mv	s1,a0
    8000528c:	8b2e                	mv	s6,a1
    8000528e:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80005290:	ffffd097          	auipc	ra,0xffffd
    80005294:	e7a080e7          	jalr	-390(ra) # 8000210a <myproc>
    80005298:	892a                	mv	s2,a0

  acquire(&pi->lock);
    8000529a:	8526                	mv	a0,s1
    8000529c:	ffffc097          	auipc	ra,0xffffc
    800052a0:	a9e080e7          	jalr	-1378(ra) # 80000d3a <acquire>
  for(i = 0; i < n; i++){
    800052a4:	09505763          	blez	s5,80005332 <pipewrite+0xc0>
    800052a8:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    800052aa:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800052ae:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052b2:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800052b4:	2184a783          	lw	a5,536(s1)
    800052b8:	21c4a703          	lw	a4,540(s1)
    800052bc:	2007879b          	addiw	a5,a5,512
    800052c0:	02f71b63          	bne	a4,a5,800052f6 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    800052c4:	2204a783          	lw	a5,544(s1)
    800052c8:	c3d1                	beqz	a5,8000534c <pipewrite+0xda>
    800052ca:	03092783          	lw	a5,48(s2)
    800052ce:	efbd                	bnez	a5,8000534c <pipewrite+0xda>
      wakeup(&pi->nread);
    800052d0:	8552                	mv	a0,s4
    800052d2:	ffffe097          	auipc	ra,0xffffe
    800052d6:	838080e7          	jalr	-1992(ra) # 80002b0a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800052da:	85a6                	mv	a1,s1
    800052dc:	854e                	mv	a0,s3
    800052de:	ffffd097          	auipc	ra,0xffffd
    800052e2:	6ac080e7          	jalr	1708(ra) # 8000298a <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800052e6:	2184a783          	lw	a5,536(s1)
    800052ea:	21c4a703          	lw	a4,540(s1)
    800052ee:	2007879b          	addiw	a5,a5,512
    800052f2:	fcf709e3          	beq	a4,a5,800052c4 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052f6:	4685                	li	a3,1
    800052f8:	865a                	mv	a2,s6
    800052fa:	faf40593          	addi	a1,s0,-81
    800052fe:	05093503          	ld	a0,80(s2)
    80005302:	ffffc097          	auipc	ra,0xffffc
    80005306:	4aa080e7          	jalr	1194(ra) # 800017ac <copyin>
    8000530a:	03850563          	beq	a0,s8,80005334 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000530e:	21c4a783          	lw	a5,540(s1)
    80005312:	0017871b          	addiw	a4,a5,1
    80005316:	20e4ae23          	sw	a4,540(s1)
    8000531a:	1ff7f793          	andi	a5,a5,511
    8000531e:	97a6                	add	a5,a5,s1
    80005320:	faf44703          	lbu	a4,-81(s0)
    80005324:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80005328:	2b85                	addiw	s7,s7,1
    8000532a:	0b05                	addi	s6,s6,1
    8000532c:	f97a94e3          	bne	s5,s7,800052b4 <pipewrite+0x42>
    80005330:	a011                	j	80005334 <pipewrite+0xc2>
    80005332:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80005334:	21848513          	addi	a0,s1,536
    80005338:	ffffd097          	auipc	ra,0xffffd
    8000533c:	7d2080e7          	jalr	2002(ra) # 80002b0a <wakeup>
  release(&pi->lock);
    80005340:	8526                	mv	a0,s1
    80005342:	ffffc097          	auipc	ra,0xffffc
    80005346:	aac080e7          	jalr	-1364(ra) # 80000dee <release>
  return i;
    8000534a:	a039                	j	80005358 <pipewrite+0xe6>
        release(&pi->lock);
    8000534c:	8526                	mv	a0,s1
    8000534e:	ffffc097          	auipc	ra,0xffffc
    80005352:	aa0080e7          	jalr	-1376(ra) # 80000dee <release>
        return -1;
    80005356:	5bfd                	li	s7,-1
}
    80005358:	855e                	mv	a0,s7
    8000535a:	60e6                	ld	ra,88(sp)
    8000535c:	6446                	ld	s0,80(sp)
    8000535e:	64a6                	ld	s1,72(sp)
    80005360:	6906                	ld	s2,64(sp)
    80005362:	79e2                	ld	s3,56(sp)
    80005364:	7a42                	ld	s4,48(sp)
    80005366:	7aa2                	ld	s5,40(sp)
    80005368:	7b02                	ld	s6,32(sp)
    8000536a:	6be2                	ld	s7,24(sp)
    8000536c:	6c42                	ld	s8,16(sp)
    8000536e:	6125                	addi	sp,sp,96
    80005370:	8082                	ret

0000000080005372 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005372:	715d                	addi	sp,sp,-80
    80005374:	e486                	sd	ra,72(sp)
    80005376:	e0a2                	sd	s0,64(sp)
    80005378:	fc26                	sd	s1,56(sp)
    8000537a:	f84a                	sd	s2,48(sp)
    8000537c:	f44e                	sd	s3,40(sp)
    8000537e:	f052                	sd	s4,32(sp)
    80005380:	ec56                	sd	s5,24(sp)
    80005382:	e85a                	sd	s6,16(sp)
    80005384:	0880                	addi	s0,sp,80
    80005386:	84aa                	mv	s1,a0
    80005388:	892e                	mv	s2,a1
    8000538a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000538c:	ffffd097          	auipc	ra,0xffffd
    80005390:	d7e080e7          	jalr	-642(ra) # 8000210a <myproc>
    80005394:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005396:	8526                	mv	a0,s1
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	9a2080e7          	jalr	-1630(ra) # 80000d3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053a0:	2184a703          	lw	a4,536(s1)
    800053a4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053a8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053ac:	02f71463          	bne	a4,a5,800053d4 <piperead+0x62>
    800053b0:	2244a783          	lw	a5,548(s1)
    800053b4:	c385                	beqz	a5,800053d4 <piperead+0x62>
    if(pr->killed){
    800053b6:	030a2783          	lw	a5,48(s4)
    800053ba:	ebc1                	bnez	a5,8000544a <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053bc:	85a6                	mv	a1,s1
    800053be:	854e                	mv	a0,s3
    800053c0:	ffffd097          	auipc	ra,0xffffd
    800053c4:	5ca080e7          	jalr	1482(ra) # 8000298a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053c8:	2184a703          	lw	a4,536(s1)
    800053cc:	21c4a783          	lw	a5,540(s1)
    800053d0:	fef700e3          	beq	a4,a5,800053b0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053d4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053d6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053d8:	05505363          	blez	s5,8000541e <piperead+0xac>
    if(pi->nread == pi->nwrite)
    800053dc:	2184a783          	lw	a5,536(s1)
    800053e0:	21c4a703          	lw	a4,540(s1)
    800053e4:	02f70d63          	beq	a4,a5,8000541e <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800053e8:	0017871b          	addiw	a4,a5,1
    800053ec:	20e4ac23          	sw	a4,536(s1)
    800053f0:	1ff7f793          	andi	a5,a5,511
    800053f4:	97a6                	add	a5,a5,s1
    800053f6:	0187c783          	lbu	a5,24(a5)
    800053fa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053fe:	4685                	li	a3,1
    80005400:	fbf40613          	addi	a2,s0,-65
    80005404:	85ca                	mv	a1,s2
    80005406:	050a3503          	ld	a0,80(s4)
    8000540a:	ffffc097          	auipc	ra,0xffffc
    8000540e:	616080e7          	jalr	1558(ra) # 80001a20 <copyout>
    80005412:	01650663          	beq	a0,s6,8000541e <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005416:	2985                	addiw	s3,s3,1
    80005418:	0905                	addi	s2,s2,1
    8000541a:	fd3a91e3          	bne	s5,s3,800053dc <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000541e:	21c48513          	addi	a0,s1,540
    80005422:	ffffd097          	auipc	ra,0xffffd
    80005426:	6e8080e7          	jalr	1768(ra) # 80002b0a <wakeup>
  release(&pi->lock);
    8000542a:	8526                	mv	a0,s1
    8000542c:	ffffc097          	auipc	ra,0xffffc
    80005430:	9c2080e7          	jalr	-1598(ra) # 80000dee <release>
  return i;
}
    80005434:	854e                	mv	a0,s3
    80005436:	60a6                	ld	ra,72(sp)
    80005438:	6406                	ld	s0,64(sp)
    8000543a:	74e2                	ld	s1,56(sp)
    8000543c:	7942                	ld	s2,48(sp)
    8000543e:	79a2                	ld	s3,40(sp)
    80005440:	7a02                	ld	s4,32(sp)
    80005442:	6ae2                	ld	s5,24(sp)
    80005444:	6b42                	ld	s6,16(sp)
    80005446:	6161                	addi	sp,sp,80
    80005448:	8082                	ret
      release(&pi->lock);
    8000544a:	8526                	mv	a0,s1
    8000544c:	ffffc097          	auipc	ra,0xffffc
    80005450:	9a2080e7          	jalr	-1630(ra) # 80000dee <release>
      return -1;
    80005454:	59fd                	li	s3,-1
    80005456:	bff9                	j	80005434 <piperead+0xc2>

0000000080005458 <exec>:
#include "types.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    80005458:	de010113          	addi	sp,sp,-544
    8000545c:	20113c23          	sd	ra,536(sp)
    80005460:	20813823          	sd	s0,528(sp)
    80005464:	20913423          	sd	s1,520(sp)
    80005468:	21213023          	sd	s2,512(sp)
    8000546c:	ffce                	sd	s3,504(sp)
    8000546e:	fbd2                	sd	s4,496(sp)
    80005470:	f7d6                	sd	s5,488(sp)
    80005472:	f3da                	sd	s6,480(sp)
    80005474:	efde                	sd	s7,472(sp)
    80005476:	ebe2                	sd	s8,464(sp)
    80005478:	e7e6                	sd	s9,456(sp)
    8000547a:	e3ea                	sd	s10,448(sp)
    8000547c:	ff6e                	sd	s11,440(sp)
    8000547e:	1400                	addi	s0,sp,544
    80005480:	892a                	mv	s2,a0
    80005482:	dea43423          	sd	a0,-536(s0)
    80005486:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000548a:	ffffd097          	auipc	ra,0xffffd
    8000548e:	c80080e7          	jalr	-896(ra) # 8000210a <myproc>
    80005492:	84aa                	mv	s1,a0

  begin_op();
    80005494:	fffff097          	auipc	ra,0xfffff
    80005498:	46c080e7          	jalr	1132(ra) # 80004900 <begin_op>

  if ((ip = namei(path)) == 0) {
    8000549c:	854a                	mv	a0,s2
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	256080e7          	jalr	598(ra) # 800046f4 <namei>
    800054a6:	c93d                	beqz	a0,8000551c <exec+0xc4>
    800054a8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800054aa:	fffff097          	auipc	ra,0xfffff
    800054ae:	a96080e7          	jalr	-1386(ra) # 80003f40 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800054b2:	04000713          	li	a4,64
    800054b6:	4681                	li	a3,0
    800054b8:	e4840613          	addi	a2,s0,-440
    800054bc:	4581                	li	a1,0
    800054be:	8556                	mv	a0,s5
    800054c0:	fffff097          	auipc	ra,0xfffff
    800054c4:	d34080e7          	jalr	-716(ra) # 800041f4 <readi>
    800054c8:	04000793          	li	a5,64
    800054cc:	00f51a63          	bne	a0,a5,800054e0 <exec+0x88>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    800054d0:	e4842703          	lw	a4,-440(s0)
    800054d4:	464c47b7          	lui	a5,0x464c4
    800054d8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800054dc:	04f70663          	beq	a4,a5,80005528 <exec+0xd0>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800054e0:	8556                	mv	a0,s5
    800054e2:	fffff097          	auipc	ra,0xfffff
    800054e6:	cc0080e7          	jalr	-832(ra) # 800041a2 <iunlockput>
    end_op();
    800054ea:	fffff097          	auipc	ra,0xfffff
    800054ee:	496080e7          	jalr	1174(ra) # 80004980 <end_op>
  }
  return -1;
    800054f2:	557d                	li	a0,-1
}
    800054f4:	21813083          	ld	ra,536(sp)
    800054f8:	21013403          	ld	s0,528(sp)
    800054fc:	20813483          	ld	s1,520(sp)
    80005500:	20013903          	ld	s2,512(sp)
    80005504:	79fe                	ld	s3,504(sp)
    80005506:	7a5e                	ld	s4,496(sp)
    80005508:	7abe                	ld	s5,488(sp)
    8000550a:	7b1e                	ld	s6,480(sp)
    8000550c:	6bfe                	ld	s7,472(sp)
    8000550e:	6c5e                	ld	s8,464(sp)
    80005510:	6cbe                	ld	s9,456(sp)
    80005512:	6d1e                	ld	s10,448(sp)
    80005514:	7dfa                	ld	s11,440(sp)
    80005516:	22010113          	addi	sp,sp,544
    8000551a:	8082                	ret
    end_op();
    8000551c:	fffff097          	auipc	ra,0xfffff
    80005520:	464080e7          	jalr	1124(ra) # 80004980 <end_op>
    return -1;
    80005524:	557d                	li	a0,-1
    80005526:	b7f9                	j	800054f4 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005528:	8526                	mv	a0,s1
    8000552a:	ffffd097          	auipc	ra,0xffffd
    8000552e:	ca4080e7          	jalr	-860(ra) # 800021ce <proc_pagetable>
    80005532:	8b2a                	mv	s6,a0
    80005534:	d555                	beqz	a0,800054e0 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005536:	e6842783          	lw	a5,-408(s0)
    8000553a:	e8045703          	lhu	a4,-384(s0)
    8000553e:	c735                	beqz	a4,800055aa <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80005540:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005542:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    80005546:	6a05                	lui	s4,0x1
    80005548:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000554c:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    80005550:	6d85                	lui	s11,0x1
    80005552:	7d7d                	lui	s10,0xfffff
    80005554:	ac1d                	j	8000578a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80005556:	00003517          	auipc	a0,0x3
    8000555a:	2da50513          	addi	a0,a0,730 # 80008830 <syscalls+0x2c8>
    8000555e:	ffffb097          	auipc	ra,0xffffb
    80005562:	086080e7          	jalr	134(ra) # 800005e4 <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80005566:	874a                	mv	a4,s2
    80005568:	009c86bb          	addw	a3,s9,s1
    8000556c:	4581                	li	a1,0
    8000556e:	8556                	mv	a0,s5
    80005570:	fffff097          	auipc	ra,0xfffff
    80005574:	c84080e7          	jalr	-892(ra) # 800041f4 <readi>
    80005578:	2501                	sext.w	a0,a0
    8000557a:	1aa91863          	bne	s2,a0,8000572a <exec+0x2d2>
  for (i = 0; i < sz; i += PGSIZE) {
    8000557e:	009d84bb          	addw	s1,s11,s1
    80005582:	013d09bb          	addw	s3,s10,s3
    80005586:	1f74f263          	bgeu	s1,s7,8000576a <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000558a:	02049593          	slli	a1,s1,0x20
    8000558e:	9181                	srli	a1,a1,0x20
    80005590:	95e2                	add	a1,a1,s8
    80005592:	855a                	mv	a0,s6
    80005594:	ffffc097          	auipc	ra,0xffffc
    80005598:	c26080e7          	jalr	-986(ra) # 800011ba <walkaddr>
    8000559c:	862a                	mv	a2,a0
    if (pa == 0)
    8000559e:	dd45                	beqz	a0,80005556 <exec+0xfe>
      n = PGSIZE;
    800055a0:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    800055a2:	fd49f2e3          	bgeu	s3,s4,80005566 <exec+0x10e>
      n = sz - i;
    800055a6:	894e                	mv	s2,s3
    800055a8:	bf7d                	j	80005566 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    800055aa:	4481                	li	s1,0
  iunlockput(ip);
    800055ac:	8556                	mv	a0,s5
    800055ae:	fffff097          	auipc	ra,0xfffff
    800055b2:	bf4080e7          	jalr	-1036(ra) # 800041a2 <iunlockput>
  end_op();
    800055b6:	fffff097          	auipc	ra,0xfffff
    800055ba:	3ca080e7          	jalr	970(ra) # 80004980 <end_op>
  p = myproc();
    800055be:	ffffd097          	auipc	ra,0xffffd
    800055c2:	b4c080e7          	jalr	-1204(ra) # 8000210a <myproc>
    800055c6:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800055c8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800055cc:	6785                	lui	a5,0x1
    800055ce:	17fd                	addi	a5,a5,-1
    800055d0:	94be                	add	s1,s1,a5
    800055d2:	77fd                	lui	a5,0xfffff
    800055d4:	8fe5                	and	a5,a5,s1
    800055d6:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    800055da:	6609                	lui	a2,0x2
    800055dc:	963e                	add	a2,a2,a5
    800055de:	85be                	mv	a1,a5
    800055e0:	855a                	mv	a0,s6
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	f9e080e7          	jalr	-98(ra) # 80001580 <uvmalloc>
    800055ea:	8c2a                	mv	s8,a0
  ip = 0;
    800055ec:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    800055ee:	12050e63          	beqz	a0,8000572a <exec+0x2d2>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800055f2:	75f9                	lui	a1,0xffffe
    800055f4:	95aa                	add	a1,a1,a0
    800055f6:	855a                	mv	a0,s6
    800055f8:	ffffc097          	auipc	ra,0xffffc
    800055fc:	182080e7          	jalr	386(ra) # 8000177a <uvmclear>
  stackbase = sp - PGSIZE;
    80005600:	7afd                	lui	s5,0xfffff
    80005602:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    80005604:	df043783          	ld	a5,-528(s0)
    80005608:	6388                	ld	a0,0(a5)
    8000560a:	c925                	beqz	a0,8000567a <exec+0x222>
    8000560c:	e8840993          	addi	s3,s0,-376
    80005610:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005614:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80005616:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005618:	ffffc097          	auipc	ra,0xffffc
    8000561c:	9a2080e7          	jalr	-1630(ra) # 80000fba <strlen>
    80005620:	0015079b          	addiw	a5,a0,1
    80005624:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005628:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000562c:	13596363          	bltu	s2,s5,80005752 <exec+0x2fa>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005630:	df043d83          	ld	s11,-528(s0)
    80005634:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005638:	8552                	mv	a0,s4
    8000563a:	ffffc097          	auipc	ra,0xffffc
    8000563e:	980080e7          	jalr	-1664(ra) # 80000fba <strlen>
    80005642:	0015069b          	addiw	a3,a0,1
    80005646:	8652                	mv	a2,s4
    80005648:	85ca                	mv	a1,s2
    8000564a:	855a                	mv	a0,s6
    8000564c:	ffffc097          	auipc	ra,0xffffc
    80005650:	3d4080e7          	jalr	980(ra) # 80001a20 <copyout>
    80005654:	10054363          	bltz	a0,8000575a <exec+0x302>
    ustack[argc] = sp;
    80005658:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000565c:	0485                	addi	s1,s1,1
    8000565e:	008d8793          	addi	a5,s11,8
    80005662:	def43823          	sd	a5,-528(s0)
    80005666:	008db503          	ld	a0,8(s11)
    8000566a:	c911                	beqz	a0,8000567e <exec+0x226>
    if (argc >= MAXARG)
    8000566c:	09a1                	addi	s3,s3,8
    8000566e:	fb3c95e3          	bne	s9,s3,80005618 <exec+0x1c0>
  sz = sz1;
    80005672:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005676:	4a81                	li	s5,0
    80005678:	a84d                	j	8000572a <exec+0x2d2>
  sp = sz;
    8000567a:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    8000567c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000567e:	00349793          	slli	a5,s1,0x3
    80005682:	f9040713          	addi	a4,s0,-112
    80005686:	97ba                	add	a5,a5,a4
    80005688:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffaaef8>
  sp -= (argc + 1) * sizeof(uint64);
    8000568c:	00148693          	addi	a3,s1,1
    80005690:	068e                	slli	a3,a3,0x3
    80005692:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005696:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000569a:	01597663          	bgeu	s2,s5,800056a6 <exec+0x24e>
  sz = sz1;
    8000569e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056a2:	4a81                	li	s5,0
    800056a4:	a059                	j	8000572a <exec+0x2d2>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800056a6:	e8840613          	addi	a2,s0,-376
    800056aa:	85ca                	mv	a1,s2
    800056ac:	855a                	mv	a0,s6
    800056ae:	ffffc097          	auipc	ra,0xffffc
    800056b2:	372080e7          	jalr	882(ra) # 80001a20 <copyout>
    800056b6:	0a054663          	bltz	a0,80005762 <exec+0x30a>
  p->trapframe->a1 = sp;
    800056ba:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800056be:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800056c2:	de843783          	ld	a5,-536(s0)
    800056c6:	0007c703          	lbu	a4,0(a5)
    800056ca:	cf11                	beqz	a4,800056e6 <exec+0x28e>
    800056cc:	0785                	addi	a5,a5,1
    if (*s == '/')
    800056ce:	02f00693          	li	a3,47
    800056d2:	a039                	j	800056e0 <exec+0x288>
      last = s + 1;
    800056d4:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800056d8:	0785                	addi	a5,a5,1
    800056da:	fff7c703          	lbu	a4,-1(a5)
    800056de:	c701                	beqz	a4,800056e6 <exec+0x28e>
    if (*s == '/')
    800056e0:	fed71ce3          	bne	a4,a3,800056d8 <exec+0x280>
    800056e4:	bfc5                	j	800056d4 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800056e6:	4641                	li	a2,16
    800056e8:	de843583          	ld	a1,-536(s0)
    800056ec:	150b8513          	addi	a0,s7,336
    800056f0:	ffffc097          	auipc	ra,0xffffc
    800056f4:	898080e7          	jalr	-1896(ra) # 80000f88 <safestrcpy>
  oldpagetable = p->pagetable;
    800056f8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800056fc:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005700:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80005704:	058bb783          	ld	a5,88(s7)
    80005708:	e6043703          	ld	a4,-416(s0)
    8000570c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    8000570e:	058bb783          	ld	a5,88(s7)
    80005712:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005716:	85ea                	mv	a1,s10
    80005718:	ffffd097          	auipc	ra,0xffffd
    8000571c:	b52080e7          	jalr	-1198(ra) # 8000226a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005720:	0004851b          	sext.w	a0,s1
    80005724:	bbc1                	j	800054f4 <exec+0x9c>
    80005726:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000572a:	df843583          	ld	a1,-520(s0)
    8000572e:	855a                	mv	a0,s6
    80005730:	ffffd097          	auipc	ra,0xffffd
    80005734:	b3a080e7          	jalr	-1222(ra) # 8000226a <proc_freepagetable>
  if (ip) {
    80005738:	da0a94e3          	bnez	s5,800054e0 <exec+0x88>
  return -1;
    8000573c:	557d                	li	a0,-1
    8000573e:	bb5d                	j	800054f4 <exec+0x9c>
    80005740:	de943c23          	sd	s1,-520(s0)
    80005744:	b7dd                	j	8000572a <exec+0x2d2>
    80005746:	de943c23          	sd	s1,-520(s0)
    8000574a:	b7c5                	j	8000572a <exec+0x2d2>
    8000574c:	de943c23          	sd	s1,-520(s0)
    80005750:	bfe9                	j	8000572a <exec+0x2d2>
  sz = sz1;
    80005752:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005756:	4a81                	li	s5,0
    80005758:	bfc9                	j	8000572a <exec+0x2d2>
  sz = sz1;
    8000575a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000575e:	4a81                	li	s5,0
    80005760:	b7e9                	j	8000572a <exec+0x2d2>
  sz = sz1;
    80005762:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005766:	4a81                	li	s5,0
    80005768:	b7c9                	j	8000572a <exec+0x2d2>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000576a:	df843483          	ld	s1,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000576e:	e0843783          	ld	a5,-504(s0)
    80005772:	0017869b          	addiw	a3,a5,1
    80005776:	e0d43423          	sd	a3,-504(s0)
    8000577a:	e0043783          	ld	a5,-512(s0)
    8000577e:	0387879b          	addiw	a5,a5,56
    80005782:	e8045703          	lhu	a4,-384(s0)
    80005786:	e2e6d3e3          	bge	a3,a4,800055ac <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000578a:	2781                	sext.w	a5,a5
    8000578c:	e0f43023          	sd	a5,-512(s0)
    80005790:	03800713          	li	a4,56
    80005794:	86be                	mv	a3,a5
    80005796:	e1040613          	addi	a2,s0,-496
    8000579a:	4581                	li	a1,0
    8000579c:	8556                	mv	a0,s5
    8000579e:	fffff097          	auipc	ra,0xfffff
    800057a2:	a56080e7          	jalr	-1450(ra) # 800041f4 <readi>
    800057a6:	03800793          	li	a5,56
    800057aa:	f6f51ee3          	bne	a0,a5,80005726 <exec+0x2ce>
    if (ph.type != ELF_PROG_LOAD)
    800057ae:	e1042783          	lw	a5,-496(s0)
    800057b2:	4705                	li	a4,1
    800057b4:	fae79de3          	bne	a5,a4,8000576e <exec+0x316>
    if (ph.memsz < ph.filesz)
    800057b8:	e3843603          	ld	a2,-456(s0)
    800057bc:	e3043783          	ld	a5,-464(s0)
    800057c0:	f8f660e3          	bltu	a2,a5,80005740 <exec+0x2e8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800057c4:	e2043783          	ld	a5,-480(s0)
    800057c8:	963e                	add	a2,a2,a5
    800057ca:	f6f66ee3          	bltu	a2,a5,80005746 <exec+0x2ee>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800057ce:	85a6                	mv	a1,s1
    800057d0:	855a                	mv	a0,s6
    800057d2:	ffffc097          	auipc	ra,0xffffc
    800057d6:	dae080e7          	jalr	-594(ra) # 80001580 <uvmalloc>
    800057da:	dea43c23          	sd	a0,-520(s0)
    800057de:	d53d                	beqz	a0,8000574c <exec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    800057e0:	e2043c03          	ld	s8,-480(s0)
    800057e4:	de043783          	ld	a5,-544(s0)
    800057e8:	00fc77b3          	and	a5,s8,a5
    800057ec:	ff9d                	bnez	a5,8000572a <exec+0x2d2>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800057ee:	e1842c83          	lw	s9,-488(s0)
    800057f2:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800057f6:	f60b8ae3          	beqz	s7,8000576a <exec+0x312>
    800057fa:	89de                	mv	s3,s7
    800057fc:	4481                	li	s1,0
    800057fe:	b371                	j	8000558a <exec+0x132>

0000000080005800 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005800:	7179                	addi	sp,sp,-48
    80005802:	f406                	sd	ra,40(sp)
    80005804:	f022                	sd	s0,32(sp)
    80005806:	ec26                	sd	s1,24(sp)
    80005808:	e84a                	sd	s2,16(sp)
    8000580a:	1800                	addi	s0,sp,48
    8000580c:	892e                	mv	s2,a1
    8000580e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005810:	fdc40593          	addi	a1,s0,-36
    80005814:	ffffe097          	auipc	ra,0xffffe
    80005818:	b62080e7          	jalr	-1182(ra) # 80003376 <argint>
    8000581c:	04054063          	bltz	a0,8000585c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005820:	fdc42703          	lw	a4,-36(s0)
    80005824:	47bd                	li	a5,15
    80005826:	02e7ed63          	bltu	a5,a4,80005860 <argfd+0x60>
    8000582a:	ffffd097          	auipc	ra,0xffffd
    8000582e:	8e0080e7          	jalr	-1824(ra) # 8000210a <myproc>
    80005832:	fdc42703          	lw	a4,-36(s0)
    80005836:	01a70793          	addi	a5,a4,26
    8000583a:	078e                	slli	a5,a5,0x3
    8000583c:	953e                	add	a0,a0,a5
    8000583e:	611c                	ld	a5,0(a0)
    80005840:	c395                	beqz	a5,80005864 <argfd+0x64>
    return -1;
  if(pfd)
    80005842:	00090463          	beqz	s2,8000584a <argfd+0x4a>
    *pfd = fd;
    80005846:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000584a:	4501                	li	a0,0
  if(pf)
    8000584c:	c091                	beqz	s1,80005850 <argfd+0x50>
    *pf = f;
    8000584e:	e09c                	sd	a5,0(s1)
}
    80005850:	70a2                	ld	ra,40(sp)
    80005852:	7402                	ld	s0,32(sp)
    80005854:	64e2                	ld	s1,24(sp)
    80005856:	6942                	ld	s2,16(sp)
    80005858:	6145                	addi	sp,sp,48
    8000585a:	8082                	ret
    return -1;
    8000585c:	557d                	li	a0,-1
    8000585e:	bfcd                	j	80005850 <argfd+0x50>
    return -1;
    80005860:	557d                	li	a0,-1
    80005862:	b7fd                	j	80005850 <argfd+0x50>
    80005864:	557d                	li	a0,-1
    80005866:	b7ed                	j	80005850 <argfd+0x50>

0000000080005868 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005868:	1101                	addi	sp,sp,-32
    8000586a:	ec06                	sd	ra,24(sp)
    8000586c:	e822                	sd	s0,16(sp)
    8000586e:	e426                	sd	s1,8(sp)
    80005870:	1000                	addi	s0,sp,32
    80005872:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005874:	ffffd097          	auipc	ra,0xffffd
    80005878:	896080e7          	jalr	-1898(ra) # 8000210a <myproc>
    8000587c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000587e:	0d050793          	addi	a5,a0,208
    80005882:	4501                	li	a0,0
    80005884:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005886:	6398                	ld	a4,0(a5)
    80005888:	cb19                	beqz	a4,8000589e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000588a:	2505                	addiw	a0,a0,1
    8000588c:	07a1                	addi	a5,a5,8
    8000588e:	fed51ce3          	bne	a0,a3,80005886 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005892:	557d                	li	a0,-1
}
    80005894:	60e2                	ld	ra,24(sp)
    80005896:	6442                	ld	s0,16(sp)
    80005898:	64a2                	ld	s1,8(sp)
    8000589a:	6105                	addi	sp,sp,32
    8000589c:	8082                	ret
      p->ofile[fd] = f;
    8000589e:	01a50793          	addi	a5,a0,26
    800058a2:	078e                	slli	a5,a5,0x3
    800058a4:	963e                	add	a2,a2,a5
    800058a6:	e204                	sd	s1,0(a2)
      return fd;
    800058a8:	b7f5                	j	80005894 <fdalloc+0x2c>

00000000800058aa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800058aa:	715d                	addi	sp,sp,-80
    800058ac:	e486                	sd	ra,72(sp)
    800058ae:	e0a2                	sd	s0,64(sp)
    800058b0:	fc26                	sd	s1,56(sp)
    800058b2:	f84a                	sd	s2,48(sp)
    800058b4:	f44e                	sd	s3,40(sp)
    800058b6:	f052                	sd	s4,32(sp)
    800058b8:	ec56                	sd	s5,24(sp)
    800058ba:	0880                	addi	s0,sp,80
    800058bc:	89ae                	mv	s3,a1
    800058be:	8ab2                	mv	s5,a2
    800058c0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800058c2:	fb040593          	addi	a1,s0,-80
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	e4c080e7          	jalr	-436(ra) # 80004712 <nameiparent>
    800058ce:	892a                	mv	s2,a0
    800058d0:	12050e63          	beqz	a0,80005a0c <create+0x162>
    return 0;

  ilock(dp);
    800058d4:	ffffe097          	auipc	ra,0xffffe
    800058d8:	66c080e7          	jalr	1644(ra) # 80003f40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800058dc:	4601                	li	a2,0
    800058de:	fb040593          	addi	a1,s0,-80
    800058e2:	854a                	mv	a0,s2
    800058e4:	fffff097          	auipc	ra,0xfffff
    800058e8:	b3e080e7          	jalr	-1218(ra) # 80004422 <dirlookup>
    800058ec:	84aa                	mv	s1,a0
    800058ee:	c921                	beqz	a0,8000593e <create+0x94>
    iunlockput(dp);
    800058f0:	854a                	mv	a0,s2
    800058f2:	fffff097          	auipc	ra,0xfffff
    800058f6:	8b0080e7          	jalr	-1872(ra) # 800041a2 <iunlockput>
    ilock(ip);
    800058fa:	8526                	mv	a0,s1
    800058fc:	ffffe097          	auipc	ra,0xffffe
    80005900:	644080e7          	jalr	1604(ra) # 80003f40 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005904:	2981                	sext.w	s3,s3
    80005906:	4789                	li	a5,2
    80005908:	02f99463          	bne	s3,a5,80005930 <create+0x86>
    8000590c:	0444d783          	lhu	a5,68(s1)
    80005910:	37f9                	addiw	a5,a5,-2
    80005912:	17c2                	slli	a5,a5,0x30
    80005914:	93c1                	srli	a5,a5,0x30
    80005916:	4705                	li	a4,1
    80005918:	00f76c63          	bltu	a4,a5,80005930 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000591c:	8526                	mv	a0,s1
    8000591e:	60a6                	ld	ra,72(sp)
    80005920:	6406                	ld	s0,64(sp)
    80005922:	74e2                	ld	s1,56(sp)
    80005924:	7942                	ld	s2,48(sp)
    80005926:	79a2                	ld	s3,40(sp)
    80005928:	7a02                	ld	s4,32(sp)
    8000592a:	6ae2                	ld	s5,24(sp)
    8000592c:	6161                	addi	sp,sp,80
    8000592e:	8082                	ret
    iunlockput(ip);
    80005930:	8526                	mv	a0,s1
    80005932:	fffff097          	auipc	ra,0xfffff
    80005936:	870080e7          	jalr	-1936(ra) # 800041a2 <iunlockput>
    return 0;
    8000593a:	4481                	li	s1,0
    8000593c:	b7c5                	j	8000591c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000593e:	85ce                	mv	a1,s3
    80005940:	00092503          	lw	a0,0(s2)
    80005944:	ffffe097          	auipc	ra,0xffffe
    80005948:	464080e7          	jalr	1124(ra) # 80003da8 <ialloc>
    8000594c:	84aa                	mv	s1,a0
    8000594e:	c521                	beqz	a0,80005996 <create+0xec>
  ilock(ip);
    80005950:	ffffe097          	auipc	ra,0xffffe
    80005954:	5f0080e7          	jalr	1520(ra) # 80003f40 <ilock>
  ip->major = major;
    80005958:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000595c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005960:	4a05                	li	s4,1
    80005962:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005966:	8526                	mv	a0,s1
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	50e080e7          	jalr	1294(ra) # 80003e76 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005970:	2981                	sext.w	s3,s3
    80005972:	03498a63          	beq	s3,s4,800059a6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005976:	40d0                	lw	a2,4(s1)
    80005978:	fb040593          	addi	a1,s0,-80
    8000597c:	854a                	mv	a0,s2
    8000597e:	fffff097          	auipc	ra,0xfffff
    80005982:	cb4080e7          	jalr	-844(ra) # 80004632 <dirlink>
    80005986:	06054b63          	bltz	a0,800059fc <create+0x152>
  iunlockput(dp);
    8000598a:	854a                	mv	a0,s2
    8000598c:	fffff097          	auipc	ra,0xfffff
    80005990:	816080e7          	jalr	-2026(ra) # 800041a2 <iunlockput>
  return ip;
    80005994:	b761                	j	8000591c <create+0x72>
    panic("create: ialloc");
    80005996:	00003517          	auipc	a0,0x3
    8000599a:	eba50513          	addi	a0,a0,-326 # 80008850 <syscalls+0x2e8>
    8000599e:	ffffb097          	auipc	ra,0xffffb
    800059a2:	c46080e7          	jalr	-954(ra) # 800005e4 <panic>
    dp->nlink++;  // for ".."
    800059a6:	04a95783          	lhu	a5,74(s2)
    800059aa:	2785                	addiw	a5,a5,1
    800059ac:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800059b0:	854a                	mv	a0,s2
    800059b2:	ffffe097          	auipc	ra,0xffffe
    800059b6:	4c4080e7          	jalr	1220(ra) # 80003e76 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800059ba:	40d0                	lw	a2,4(s1)
    800059bc:	00003597          	auipc	a1,0x3
    800059c0:	ea458593          	addi	a1,a1,-348 # 80008860 <syscalls+0x2f8>
    800059c4:	8526                	mv	a0,s1
    800059c6:	fffff097          	auipc	ra,0xfffff
    800059ca:	c6c080e7          	jalr	-916(ra) # 80004632 <dirlink>
    800059ce:	00054f63          	bltz	a0,800059ec <create+0x142>
    800059d2:	00492603          	lw	a2,4(s2)
    800059d6:	00003597          	auipc	a1,0x3
    800059da:	e9258593          	addi	a1,a1,-366 # 80008868 <syscalls+0x300>
    800059de:	8526                	mv	a0,s1
    800059e0:	fffff097          	auipc	ra,0xfffff
    800059e4:	c52080e7          	jalr	-942(ra) # 80004632 <dirlink>
    800059e8:	f80557e3          	bgez	a0,80005976 <create+0xcc>
      panic("create dots");
    800059ec:	00003517          	auipc	a0,0x3
    800059f0:	e8450513          	addi	a0,a0,-380 # 80008870 <syscalls+0x308>
    800059f4:	ffffb097          	auipc	ra,0xffffb
    800059f8:	bf0080e7          	jalr	-1040(ra) # 800005e4 <panic>
    panic("create: dirlink");
    800059fc:	00003517          	auipc	a0,0x3
    80005a00:	e8450513          	addi	a0,a0,-380 # 80008880 <syscalls+0x318>
    80005a04:	ffffb097          	auipc	ra,0xffffb
    80005a08:	be0080e7          	jalr	-1056(ra) # 800005e4 <panic>
    return 0;
    80005a0c:	84aa                	mv	s1,a0
    80005a0e:	b739                	j	8000591c <create+0x72>

0000000080005a10 <sys_dup>:
{
    80005a10:	7179                	addi	sp,sp,-48
    80005a12:	f406                	sd	ra,40(sp)
    80005a14:	f022                	sd	s0,32(sp)
    80005a16:	ec26                	sd	s1,24(sp)
    80005a18:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005a1a:	fd840613          	addi	a2,s0,-40
    80005a1e:	4581                	li	a1,0
    80005a20:	4501                	li	a0,0
    80005a22:	00000097          	auipc	ra,0x0
    80005a26:	dde080e7          	jalr	-546(ra) # 80005800 <argfd>
    return -1;
    80005a2a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005a2c:	02054363          	bltz	a0,80005a52 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005a30:	fd843503          	ld	a0,-40(s0)
    80005a34:	00000097          	auipc	ra,0x0
    80005a38:	e34080e7          	jalr	-460(ra) # 80005868 <fdalloc>
    80005a3c:	84aa                	mv	s1,a0
    return -1;
    80005a3e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005a40:	00054963          	bltz	a0,80005a52 <sys_dup+0x42>
  filedup(f);
    80005a44:	fd843503          	ld	a0,-40(s0)
    80005a48:	fffff097          	auipc	ra,0xfffff
    80005a4c:	338080e7          	jalr	824(ra) # 80004d80 <filedup>
  return fd;
    80005a50:	87a6                	mv	a5,s1
}
    80005a52:	853e                	mv	a0,a5
    80005a54:	70a2                	ld	ra,40(sp)
    80005a56:	7402                	ld	s0,32(sp)
    80005a58:	64e2                	ld	s1,24(sp)
    80005a5a:	6145                	addi	sp,sp,48
    80005a5c:	8082                	ret

0000000080005a5e <sys_read>:
{
    80005a5e:	7179                	addi	sp,sp,-48
    80005a60:	f406                	sd	ra,40(sp)
    80005a62:	f022                	sd	s0,32(sp)
    80005a64:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a66:	fe840613          	addi	a2,s0,-24
    80005a6a:	4581                	li	a1,0
    80005a6c:	4501                	li	a0,0
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	d92080e7          	jalr	-622(ra) # 80005800 <argfd>
    return -1;
    80005a76:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a78:	04054163          	bltz	a0,80005aba <sys_read+0x5c>
    80005a7c:	fe440593          	addi	a1,s0,-28
    80005a80:	4509                	li	a0,2
    80005a82:	ffffe097          	auipc	ra,0xffffe
    80005a86:	8f4080e7          	jalr	-1804(ra) # 80003376 <argint>
    return -1;
    80005a8a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a8c:	02054763          	bltz	a0,80005aba <sys_read+0x5c>
    80005a90:	fd840593          	addi	a1,s0,-40
    80005a94:	4505                	li	a0,1
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	902080e7          	jalr	-1790(ra) # 80003398 <argaddr>
    return -1;
    80005a9e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005aa0:	00054d63          	bltz	a0,80005aba <sys_read+0x5c>
  return fileread(f, p, n);
    80005aa4:	fe442603          	lw	a2,-28(s0)
    80005aa8:	fd843583          	ld	a1,-40(s0)
    80005aac:	fe843503          	ld	a0,-24(s0)
    80005ab0:	fffff097          	auipc	ra,0xfffff
    80005ab4:	45c080e7          	jalr	1116(ra) # 80004f0c <fileread>
    80005ab8:	87aa                	mv	a5,a0
}
    80005aba:	853e                	mv	a0,a5
    80005abc:	70a2                	ld	ra,40(sp)
    80005abe:	7402                	ld	s0,32(sp)
    80005ac0:	6145                	addi	sp,sp,48
    80005ac2:	8082                	ret

0000000080005ac4 <sys_write>:
{
    80005ac4:	7179                	addi	sp,sp,-48
    80005ac6:	f406                	sd	ra,40(sp)
    80005ac8:	f022                	sd	s0,32(sp)
    80005aca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005acc:	fe840613          	addi	a2,s0,-24
    80005ad0:	4581                	li	a1,0
    80005ad2:	4501                	li	a0,0
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	d2c080e7          	jalr	-724(ra) # 80005800 <argfd>
    return -1;
    80005adc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005ade:	04054163          	bltz	a0,80005b20 <sys_write+0x5c>
    80005ae2:	fe440593          	addi	a1,s0,-28
    80005ae6:	4509                	li	a0,2
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	88e080e7          	jalr	-1906(ra) # 80003376 <argint>
    return -1;
    80005af0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005af2:	02054763          	bltz	a0,80005b20 <sys_write+0x5c>
    80005af6:	fd840593          	addi	a1,s0,-40
    80005afa:	4505                	li	a0,1
    80005afc:	ffffe097          	auipc	ra,0xffffe
    80005b00:	89c080e7          	jalr	-1892(ra) # 80003398 <argaddr>
    return -1;
    80005b04:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005b06:	00054d63          	bltz	a0,80005b20 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005b0a:	fe442603          	lw	a2,-28(s0)
    80005b0e:	fd843583          	ld	a1,-40(s0)
    80005b12:	fe843503          	ld	a0,-24(s0)
    80005b16:	fffff097          	auipc	ra,0xfffff
    80005b1a:	4b8080e7          	jalr	1208(ra) # 80004fce <filewrite>
    80005b1e:	87aa                	mv	a5,a0
}
    80005b20:	853e                	mv	a0,a5
    80005b22:	70a2                	ld	ra,40(sp)
    80005b24:	7402                	ld	s0,32(sp)
    80005b26:	6145                	addi	sp,sp,48
    80005b28:	8082                	ret

0000000080005b2a <sys_close>:
{
    80005b2a:	1101                	addi	sp,sp,-32
    80005b2c:	ec06                	sd	ra,24(sp)
    80005b2e:	e822                	sd	s0,16(sp)
    80005b30:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005b32:	fe040613          	addi	a2,s0,-32
    80005b36:	fec40593          	addi	a1,s0,-20
    80005b3a:	4501                	li	a0,0
    80005b3c:	00000097          	auipc	ra,0x0
    80005b40:	cc4080e7          	jalr	-828(ra) # 80005800 <argfd>
    return -1;
    80005b44:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005b46:	02054463          	bltz	a0,80005b6e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005b4a:	ffffc097          	auipc	ra,0xffffc
    80005b4e:	5c0080e7          	jalr	1472(ra) # 8000210a <myproc>
    80005b52:	fec42783          	lw	a5,-20(s0)
    80005b56:	07e9                	addi	a5,a5,26
    80005b58:	078e                	slli	a5,a5,0x3
    80005b5a:	97aa                	add	a5,a5,a0
    80005b5c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005b60:	fe043503          	ld	a0,-32(s0)
    80005b64:	fffff097          	auipc	ra,0xfffff
    80005b68:	26e080e7          	jalr	622(ra) # 80004dd2 <fileclose>
  return 0;
    80005b6c:	4781                	li	a5,0
}
    80005b6e:	853e                	mv	a0,a5
    80005b70:	60e2                	ld	ra,24(sp)
    80005b72:	6442                	ld	s0,16(sp)
    80005b74:	6105                	addi	sp,sp,32
    80005b76:	8082                	ret

0000000080005b78 <sys_fstat>:
{
    80005b78:	1101                	addi	sp,sp,-32
    80005b7a:	ec06                	sd	ra,24(sp)
    80005b7c:	e822                	sd	s0,16(sp)
    80005b7e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005b80:	fe840613          	addi	a2,s0,-24
    80005b84:	4581                	li	a1,0
    80005b86:	4501                	li	a0,0
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	c78080e7          	jalr	-904(ra) # 80005800 <argfd>
    return -1;
    80005b90:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005b92:	02054563          	bltz	a0,80005bbc <sys_fstat+0x44>
    80005b96:	fe040593          	addi	a1,s0,-32
    80005b9a:	4505                	li	a0,1
    80005b9c:	ffffd097          	auipc	ra,0xffffd
    80005ba0:	7fc080e7          	jalr	2044(ra) # 80003398 <argaddr>
    return -1;
    80005ba4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005ba6:	00054b63          	bltz	a0,80005bbc <sys_fstat+0x44>
  return filestat(f, st);
    80005baa:	fe043583          	ld	a1,-32(s0)
    80005bae:	fe843503          	ld	a0,-24(s0)
    80005bb2:	fffff097          	auipc	ra,0xfffff
    80005bb6:	2e8080e7          	jalr	744(ra) # 80004e9a <filestat>
    80005bba:	87aa                	mv	a5,a0
}
    80005bbc:	853e                	mv	a0,a5
    80005bbe:	60e2                	ld	ra,24(sp)
    80005bc0:	6442                	ld	s0,16(sp)
    80005bc2:	6105                	addi	sp,sp,32
    80005bc4:	8082                	ret

0000000080005bc6 <sys_link>:
{
    80005bc6:	7169                	addi	sp,sp,-304
    80005bc8:	f606                	sd	ra,296(sp)
    80005bca:	f222                	sd	s0,288(sp)
    80005bcc:	ee26                	sd	s1,280(sp)
    80005bce:	ea4a                	sd	s2,272(sp)
    80005bd0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005bd2:	08000613          	li	a2,128
    80005bd6:	ed040593          	addi	a1,s0,-304
    80005bda:	4501                	li	a0,0
    80005bdc:	ffffd097          	auipc	ra,0xffffd
    80005be0:	7de080e7          	jalr	2014(ra) # 800033ba <argstr>
    return -1;
    80005be4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005be6:	10054e63          	bltz	a0,80005d02 <sys_link+0x13c>
    80005bea:	08000613          	li	a2,128
    80005bee:	f5040593          	addi	a1,s0,-176
    80005bf2:	4505                	li	a0,1
    80005bf4:	ffffd097          	auipc	ra,0xffffd
    80005bf8:	7c6080e7          	jalr	1990(ra) # 800033ba <argstr>
    return -1;
    80005bfc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005bfe:	10054263          	bltz	a0,80005d02 <sys_link+0x13c>
  begin_op();
    80005c02:	fffff097          	auipc	ra,0xfffff
    80005c06:	cfe080e7          	jalr	-770(ra) # 80004900 <begin_op>
  if((ip = namei(old)) == 0){
    80005c0a:	ed040513          	addi	a0,s0,-304
    80005c0e:	fffff097          	auipc	ra,0xfffff
    80005c12:	ae6080e7          	jalr	-1306(ra) # 800046f4 <namei>
    80005c16:	84aa                	mv	s1,a0
    80005c18:	c551                	beqz	a0,80005ca4 <sys_link+0xde>
  ilock(ip);
    80005c1a:	ffffe097          	auipc	ra,0xffffe
    80005c1e:	326080e7          	jalr	806(ra) # 80003f40 <ilock>
  if(ip->type == T_DIR){
    80005c22:	04449703          	lh	a4,68(s1)
    80005c26:	4785                	li	a5,1
    80005c28:	08f70463          	beq	a4,a5,80005cb0 <sys_link+0xea>
  ip->nlink++;
    80005c2c:	04a4d783          	lhu	a5,74(s1)
    80005c30:	2785                	addiw	a5,a5,1
    80005c32:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c36:	8526                	mv	a0,s1
    80005c38:	ffffe097          	auipc	ra,0xffffe
    80005c3c:	23e080e7          	jalr	574(ra) # 80003e76 <iupdate>
  iunlock(ip);
    80005c40:	8526                	mv	a0,s1
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	3c0080e7          	jalr	960(ra) # 80004002 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005c4a:	fd040593          	addi	a1,s0,-48
    80005c4e:	f5040513          	addi	a0,s0,-176
    80005c52:	fffff097          	auipc	ra,0xfffff
    80005c56:	ac0080e7          	jalr	-1344(ra) # 80004712 <nameiparent>
    80005c5a:	892a                	mv	s2,a0
    80005c5c:	c935                	beqz	a0,80005cd0 <sys_link+0x10a>
  ilock(dp);
    80005c5e:	ffffe097          	auipc	ra,0xffffe
    80005c62:	2e2080e7          	jalr	738(ra) # 80003f40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005c66:	00092703          	lw	a4,0(s2)
    80005c6a:	409c                	lw	a5,0(s1)
    80005c6c:	04f71d63          	bne	a4,a5,80005cc6 <sys_link+0x100>
    80005c70:	40d0                	lw	a2,4(s1)
    80005c72:	fd040593          	addi	a1,s0,-48
    80005c76:	854a                	mv	a0,s2
    80005c78:	fffff097          	auipc	ra,0xfffff
    80005c7c:	9ba080e7          	jalr	-1606(ra) # 80004632 <dirlink>
    80005c80:	04054363          	bltz	a0,80005cc6 <sys_link+0x100>
  iunlockput(dp);
    80005c84:	854a                	mv	a0,s2
    80005c86:	ffffe097          	auipc	ra,0xffffe
    80005c8a:	51c080e7          	jalr	1308(ra) # 800041a2 <iunlockput>
  iput(ip);
    80005c8e:	8526                	mv	a0,s1
    80005c90:	ffffe097          	auipc	ra,0xffffe
    80005c94:	46a080e7          	jalr	1130(ra) # 800040fa <iput>
  end_op();
    80005c98:	fffff097          	auipc	ra,0xfffff
    80005c9c:	ce8080e7          	jalr	-792(ra) # 80004980 <end_op>
  return 0;
    80005ca0:	4781                	li	a5,0
    80005ca2:	a085                	j	80005d02 <sys_link+0x13c>
    end_op();
    80005ca4:	fffff097          	auipc	ra,0xfffff
    80005ca8:	cdc080e7          	jalr	-804(ra) # 80004980 <end_op>
    return -1;
    80005cac:	57fd                	li	a5,-1
    80005cae:	a891                	j	80005d02 <sys_link+0x13c>
    iunlockput(ip);
    80005cb0:	8526                	mv	a0,s1
    80005cb2:	ffffe097          	auipc	ra,0xffffe
    80005cb6:	4f0080e7          	jalr	1264(ra) # 800041a2 <iunlockput>
    end_op();
    80005cba:	fffff097          	auipc	ra,0xfffff
    80005cbe:	cc6080e7          	jalr	-826(ra) # 80004980 <end_op>
    return -1;
    80005cc2:	57fd                	li	a5,-1
    80005cc4:	a83d                	j	80005d02 <sys_link+0x13c>
    iunlockput(dp);
    80005cc6:	854a                	mv	a0,s2
    80005cc8:	ffffe097          	auipc	ra,0xffffe
    80005ccc:	4da080e7          	jalr	1242(ra) # 800041a2 <iunlockput>
  ilock(ip);
    80005cd0:	8526                	mv	a0,s1
    80005cd2:	ffffe097          	auipc	ra,0xffffe
    80005cd6:	26e080e7          	jalr	622(ra) # 80003f40 <ilock>
  ip->nlink--;
    80005cda:	04a4d783          	lhu	a5,74(s1)
    80005cde:	37fd                	addiw	a5,a5,-1
    80005ce0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005ce4:	8526                	mv	a0,s1
    80005ce6:	ffffe097          	auipc	ra,0xffffe
    80005cea:	190080e7          	jalr	400(ra) # 80003e76 <iupdate>
  iunlockput(ip);
    80005cee:	8526                	mv	a0,s1
    80005cf0:	ffffe097          	auipc	ra,0xffffe
    80005cf4:	4b2080e7          	jalr	1202(ra) # 800041a2 <iunlockput>
  end_op();
    80005cf8:	fffff097          	auipc	ra,0xfffff
    80005cfc:	c88080e7          	jalr	-888(ra) # 80004980 <end_op>
  return -1;
    80005d00:	57fd                	li	a5,-1
}
    80005d02:	853e                	mv	a0,a5
    80005d04:	70b2                	ld	ra,296(sp)
    80005d06:	7412                	ld	s0,288(sp)
    80005d08:	64f2                	ld	s1,280(sp)
    80005d0a:	6952                	ld	s2,272(sp)
    80005d0c:	6155                	addi	sp,sp,304
    80005d0e:	8082                	ret

0000000080005d10 <sys_unlink>:
{
    80005d10:	7151                	addi	sp,sp,-240
    80005d12:	f586                	sd	ra,232(sp)
    80005d14:	f1a2                	sd	s0,224(sp)
    80005d16:	eda6                	sd	s1,216(sp)
    80005d18:	e9ca                	sd	s2,208(sp)
    80005d1a:	e5ce                	sd	s3,200(sp)
    80005d1c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005d1e:	08000613          	li	a2,128
    80005d22:	f3040593          	addi	a1,s0,-208
    80005d26:	4501                	li	a0,0
    80005d28:	ffffd097          	auipc	ra,0xffffd
    80005d2c:	692080e7          	jalr	1682(ra) # 800033ba <argstr>
    80005d30:	18054163          	bltz	a0,80005eb2 <sys_unlink+0x1a2>
  begin_op();
    80005d34:	fffff097          	auipc	ra,0xfffff
    80005d38:	bcc080e7          	jalr	-1076(ra) # 80004900 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005d3c:	fb040593          	addi	a1,s0,-80
    80005d40:	f3040513          	addi	a0,s0,-208
    80005d44:	fffff097          	auipc	ra,0xfffff
    80005d48:	9ce080e7          	jalr	-1586(ra) # 80004712 <nameiparent>
    80005d4c:	84aa                	mv	s1,a0
    80005d4e:	c979                	beqz	a0,80005e24 <sys_unlink+0x114>
  ilock(dp);
    80005d50:	ffffe097          	auipc	ra,0xffffe
    80005d54:	1f0080e7          	jalr	496(ra) # 80003f40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005d58:	00003597          	auipc	a1,0x3
    80005d5c:	b0858593          	addi	a1,a1,-1272 # 80008860 <syscalls+0x2f8>
    80005d60:	fb040513          	addi	a0,s0,-80
    80005d64:	ffffe097          	auipc	ra,0xffffe
    80005d68:	6a4080e7          	jalr	1700(ra) # 80004408 <namecmp>
    80005d6c:	14050a63          	beqz	a0,80005ec0 <sys_unlink+0x1b0>
    80005d70:	00003597          	auipc	a1,0x3
    80005d74:	af858593          	addi	a1,a1,-1288 # 80008868 <syscalls+0x300>
    80005d78:	fb040513          	addi	a0,s0,-80
    80005d7c:	ffffe097          	auipc	ra,0xffffe
    80005d80:	68c080e7          	jalr	1676(ra) # 80004408 <namecmp>
    80005d84:	12050e63          	beqz	a0,80005ec0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005d88:	f2c40613          	addi	a2,s0,-212
    80005d8c:	fb040593          	addi	a1,s0,-80
    80005d90:	8526                	mv	a0,s1
    80005d92:	ffffe097          	auipc	ra,0xffffe
    80005d96:	690080e7          	jalr	1680(ra) # 80004422 <dirlookup>
    80005d9a:	892a                	mv	s2,a0
    80005d9c:	12050263          	beqz	a0,80005ec0 <sys_unlink+0x1b0>
  ilock(ip);
    80005da0:	ffffe097          	auipc	ra,0xffffe
    80005da4:	1a0080e7          	jalr	416(ra) # 80003f40 <ilock>
  if(ip->nlink < 1)
    80005da8:	04a91783          	lh	a5,74(s2)
    80005dac:	08f05263          	blez	a5,80005e30 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005db0:	04491703          	lh	a4,68(s2)
    80005db4:	4785                	li	a5,1
    80005db6:	08f70563          	beq	a4,a5,80005e40 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005dba:	4641                	li	a2,16
    80005dbc:	4581                	li	a1,0
    80005dbe:	fc040513          	addi	a0,s0,-64
    80005dc2:	ffffb097          	auipc	ra,0xffffb
    80005dc6:	074080e7          	jalr	116(ra) # 80000e36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005dca:	4741                	li	a4,16
    80005dcc:	f2c42683          	lw	a3,-212(s0)
    80005dd0:	fc040613          	addi	a2,s0,-64
    80005dd4:	4581                	li	a1,0
    80005dd6:	8526                	mv	a0,s1
    80005dd8:	ffffe097          	auipc	ra,0xffffe
    80005ddc:	514080e7          	jalr	1300(ra) # 800042ec <writei>
    80005de0:	47c1                	li	a5,16
    80005de2:	0af51563          	bne	a0,a5,80005e8c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005de6:	04491703          	lh	a4,68(s2)
    80005dea:	4785                	li	a5,1
    80005dec:	0af70863          	beq	a4,a5,80005e9c <sys_unlink+0x18c>
  iunlockput(dp);
    80005df0:	8526                	mv	a0,s1
    80005df2:	ffffe097          	auipc	ra,0xffffe
    80005df6:	3b0080e7          	jalr	944(ra) # 800041a2 <iunlockput>
  ip->nlink--;
    80005dfa:	04a95783          	lhu	a5,74(s2)
    80005dfe:	37fd                	addiw	a5,a5,-1
    80005e00:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005e04:	854a                	mv	a0,s2
    80005e06:	ffffe097          	auipc	ra,0xffffe
    80005e0a:	070080e7          	jalr	112(ra) # 80003e76 <iupdate>
  iunlockput(ip);
    80005e0e:	854a                	mv	a0,s2
    80005e10:	ffffe097          	auipc	ra,0xffffe
    80005e14:	392080e7          	jalr	914(ra) # 800041a2 <iunlockput>
  end_op();
    80005e18:	fffff097          	auipc	ra,0xfffff
    80005e1c:	b68080e7          	jalr	-1176(ra) # 80004980 <end_op>
  return 0;
    80005e20:	4501                	li	a0,0
    80005e22:	a84d                	j	80005ed4 <sys_unlink+0x1c4>
    end_op();
    80005e24:	fffff097          	auipc	ra,0xfffff
    80005e28:	b5c080e7          	jalr	-1188(ra) # 80004980 <end_op>
    return -1;
    80005e2c:	557d                	li	a0,-1
    80005e2e:	a05d                	j	80005ed4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005e30:	00003517          	auipc	a0,0x3
    80005e34:	a6050513          	addi	a0,a0,-1440 # 80008890 <syscalls+0x328>
    80005e38:	ffffa097          	auipc	ra,0xffffa
    80005e3c:	7ac080e7          	jalr	1964(ra) # 800005e4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e40:	04c92703          	lw	a4,76(s2)
    80005e44:	02000793          	li	a5,32
    80005e48:	f6e7f9e3          	bgeu	a5,a4,80005dba <sys_unlink+0xaa>
    80005e4c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e50:	4741                	li	a4,16
    80005e52:	86ce                	mv	a3,s3
    80005e54:	f1840613          	addi	a2,s0,-232
    80005e58:	4581                	li	a1,0
    80005e5a:	854a                	mv	a0,s2
    80005e5c:	ffffe097          	auipc	ra,0xffffe
    80005e60:	398080e7          	jalr	920(ra) # 800041f4 <readi>
    80005e64:	47c1                	li	a5,16
    80005e66:	00f51b63          	bne	a0,a5,80005e7c <sys_unlink+0x16c>
    if(de.inum != 0)
    80005e6a:	f1845783          	lhu	a5,-232(s0)
    80005e6e:	e7a1                	bnez	a5,80005eb6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e70:	29c1                	addiw	s3,s3,16
    80005e72:	04c92783          	lw	a5,76(s2)
    80005e76:	fcf9ede3          	bltu	s3,a5,80005e50 <sys_unlink+0x140>
    80005e7a:	b781                	j	80005dba <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005e7c:	00003517          	auipc	a0,0x3
    80005e80:	a2c50513          	addi	a0,a0,-1492 # 800088a8 <syscalls+0x340>
    80005e84:	ffffa097          	auipc	ra,0xffffa
    80005e88:	760080e7          	jalr	1888(ra) # 800005e4 <panic>
    panic("unlink: writei");
    80005e8c:	00003517          	auipc	a0,0x3
    80005e90:	a3450513          	addi	a0,a0,-1484 # 800088c0 <syscalls+0x358>
    80005e94:	ffffa097          	auipc	ra,0xffffa
    80005e98:	750080e7          	jalr	1872(ra) # 800005e4 <panic>
    dp->nlink--;
    80005e9c:	04a4d783          	lhu	a5,74(s1)
    80005ea0:	37fd                	addiw	a5,a5,-1
    80005ea2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ea6:	8526                	mv	a0,s1
    80005ea8:	ffffe097          	auipc	ra,0xffffe
    80005eac:	fce080e7          	jalr	-50(ra) # 80003e76 <iupdate>
    80005eb0:	b781                	j	80005df0 <sys_unlink+0xe0>
    return -1;
    80005eb2:	557d                	li	a0,-1
    80005eb4:	a005                	j	80005ed4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005eb6:	854a                	mv	a0,s2
    80005eb8:	ffffe097          	auipc	ra,0xffffe
    80005ebc:	2ea080e7          	jalr	746(ra) # 800041a2 <iunlockput>
  iunlockput(dp);
    80005ec0:	8526                	mv	a0,s1
    80005ec2:	ffffe097          	auipc	ra,0xffffe
    80005ec6:	2e0080e7          	jalr	736(ra) # 800041a2 <iunlockput>
  end_op();
    80005eca:	fffff097          	auipc	ra,0xfffff
    80005ece:	ab6080e7          	jalr	-1354(ra) # 80004980 <end_op>
  return -1;
    80005ed2:	557d                	li	a0,-1
}
    80005ed4:	70ae                	ld	ra,232(sp)
    80005ed6:	740e                	ld	s0,224(sp)
    80005ed8:	64ee                	ld	s1,216(sp)
    80005eda:	694e                	ld	s2,208(sp)
    80005edc:	69ae                	ld	s3,200(sp)
    80005ede:	616d                	addi	sp,sp,240
    80005ee0:	8082                	ret

0000000080005ee2 <sys_open>:

uint64
sys_open(void)
{
    80005ee2:	7131                	addi	sp,sp,-192
    80005ee4:	fd06                	sd	ra,184(sp)
    80005ee6:	f922                	sd	s0,176(sp)
    80005ee8:	f526                	sd	s1,168(sp)
    80005eea:	f14a                	sd	s2,160(sp)
    80005eec:	ed4e                	sd	s3,152(sp)
    80005eee:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005ef0:	08000613          	li	a2,128
    80005ef4:	f5040593          	addi	a1,s0,-176
    80005ef8:	4501                	li	a0,0
    80005efa:	ffffd097          	auipc	ra,0xffffd
    80005efe:	4c0080e7          	jalr	1216(ra) # 800033ba <argstr>
    return -1;
    80005f02:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005f04:	0c054163          	bltz	a0,80005fc6 <sys_open+0xe4>
    80005f08:	f4c40593          	addi	a1,s0,-180
    80005f0c:	4505                	li	a0,1
    80005f0e:	ffffd097          	auipc	ra,0xffffd
    80005f12:	468080e7          	jalr	1128(ra) # 80003376 <argint>
    80005f16:	0a054863          	bltz	a0,80005fc6 <sys_open+0xe4>

  begin_op();
    80005f1a:	fffff097          	auipc	ra,0xfffff
    80005f1e:	9e6080e7          	jalr	-1562(ra) # 80004900 <begin_op>

  if(omode & O_CREATE){
    80005f22:	f4c42783          	lw	a5,-180(s0)
    80005f26:	2007f793          	andi	a5,a5,512
    80005f2a:	cbdd                	beqz	a5,80005fe0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005f2c:	4681                	li	a3,0
    80005f2e:	4601                	li	a2,0
    80005f30:	4589                	li	a1,2
    80005f32:	f5040513          	addi	a0,s0,-176
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	974080e7          	jalr	-1676(ra) # 800058aa <create>
    80005f3e:	892a                	mv	s2,a0
    if(ip == 0){
    80005f40:	c959                	beqz	a0,80005fd6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005f42:	04491703          	lh	a4,68(s2)
    80005f46:	478d                	li	a5,3
    80005f48:	00f71763          	bne	a4,a5,80005f56 <sys_open+0x74>
    80005f4c:	04695703          	lhu	a4,70(s2)
    80005f50:	47a5                	li	a5,9
    80005f52:	0ce7ec63          	bltu	a5,a4,8000602a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005f56:	fffff097          	auipc	ra,0xfffff
    80005f5a:	dc0080e7          	jalr	-576(ra) # 80004d16 <filealloc>
    80005f5e:	89aa                	mv	s3,a0
    80005f60:	10050263          	beqz	a0,80006064 <sys_open+0x182>
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	904080e7          	jalr	-1788(ra) # 80005868 <fdalloc>
    80005f6c:	84aa                	mv	s1,a0
    80005f6e:	0e054663          	bltz	a0,8000605a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005f72:	04491703          	lh	a4,68(s2)
    80005f76:	478d                	li	a5,3
    80005f78:	0cf70463          	beq	a4,a5,80006040 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005f7c:	4789                	li	a5,2
    80005f7e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005f82:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005f86:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005f8a:	f4c42783          	lw	a5,-180(s0)
    80005f8e:	0017c713          	xori	a4,a5,1
    80005f92:	8b05                	andi	a4,a4,1
    80005f94:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005f98:	0037f713          	andi	a4,a5,3
    80005f9c:	00e03733          	snez	a4,a4
    80005fa0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005fa4:	4007f793          	andi	a5,a5,1024
    80005fa8:	c791                	beqz	a5,80005fb4 <sys_open+0xd2>
    80005faa:	04491703          	lh	a4,68(s2)
    80005fae:	4789                	li	a5,2
    80005fb0:	08f70f63          	beq	a4,a5,8000604e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005fb4:	854a                	mv	a0,s2
    80005fb6:	ffffe097          	auipc	ra,0xffffe
    80005fba:	04c080e7          	jalr	76(ra) # 80004002 <iunlock>
  end_op();
    80005fbe:	fffff097          	auipc	ra,0xfffff
    80005fc2:	9c2080e7          	jalr	-1598(ra) # 80004980 <end_op>

  return fd;
}
    80005fc6:	8526                	mv	a0,s1
    80005fc8:	70ea                	ld	ra,184(sp)
    80005fca:	744a                	ld	s0,176(sp)
    80005fcc:	74aa                	ld	s1,168(sp)
    80005fce:	790a                	ld	s2,160(sp)
    80005fd0:	69ea                	ld	s3,152(sp)
    80005fd2:	6129                	addi	sp,sp,192
    80005fd4:	8082                	ret
      end_op();
    80005fd6:	fffff097          	auipc	ra,0xfffff
    80005fda:	9aa080e7          	jalr	-1622(ra) # 80004980 <end_op>
      return -1;
    80005fde:	b7e5                	j	80005fc6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005fe0:	f5040513          	addi	a0,s0,-176
    80005fe4:	ffffe097          	auipc	ra,0xffffe
    80005fe8:	710080e7          	jalr	1808(ra) # 800046f4 <namei>
    80005fec:	892a                	mv	s2,a0
    80005fee:	c905                	beqz	a0,8000601e <sys_open+0x13c>
    ilock(ip);
    80005ff0:	ffffe097          	auipc	ra,0xffffe
    80005ff4:	f50080e7          	jalr	-176(ra) # 80003f40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005ff8:	04491703          	lh	a4,68(s2)
    80005ffc:	4785                	li	a5,1
    80005ffe:	f4f712e3          	bne	a4,a5,80005f42 <sys_open+0x60>
    80006002:	f4c42783          	lw	a5,-180(s0)
    80006006:	dba1                	beqz	a5,80005f56 <sys_open+0x74>
      iunlockput(ip);
    80006008:	854a                	mv	a0,s2
    8000600a:	ffffe097          	auipc	ra,0xffffe
    8000600e:	198080e7          	jalr	408(ra) # 800041a2 <iunlockput>
      end_op();
    80006012:	fffff097          	auipc	ra,0xfffff
    80006016:	96e080e7          	jalr	-1682(ra) # 80004980 <end_op>
      return -1;
    8000601a:	54fd                	li	s1,-1
    8000601c:	b76d                	j	80005fc6 <sys_open+0xe4>
      end_op();
    8000601e:	fffff097          	auipc	ra,0xfffff
    80006022:	962080e7          	jalr	-1694(ra) # 80004980 <end_op>
      return -1;
    80006026:	54fd                	li	s1,-1
    80006028:	bf79                	j	80005fc6 <sys_open+0xe4>
    iunlockput(ip);
    8000602a:	854a                	mv	a0,s2
    8000602c:	ffffe097          	auipc	ra,0xffffe
    80006030:	176080e7          	jalr	374(ra) # 800041a2 <iunlockput>
    end_op();
    80006034:	fffff097          	auipc	ra,0xfffff
    80006038:	94c080e7          	jalr	-1716(ra) # 80004980 <end_op>
    return -1;
    8000603c:	54fd                	li	s1,-1
    8000603e:	b761                	j	80005fc6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80006040:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006044:	04691783          	lh	a5,70(s2)
    80006048:	02f99223          	sh	a5,36(s3)
    8000604c:	bf2d                	j	80005f86 <sys_open+0xa4>
    itrunc(ip);
    8000604e:	854a                	mv	a0,s2
    80006050:	ffffe097          	auipc	ra,0xffffe
    80006054:	ffe080e7          	jalr	-2(ra) # 8000404e <itrunc>
    80006058:	bfb1                	j	80005fb4 <sys_open+0xd2>
      fileclose(f);
    8000605a:	854e                	mv	a0,s3
    8000605c:	fffff097          	auipc	ra,0xfffff
    80006060:	d76080e7          	jalr	-650(ra) # 80004dd2 <fileclose>
    iunlockput(ip);
    80006064:	854a                	mv	a0,s2
    80006066:	ffffe097          	auipc	ra,0xffffe
    8000606a:	13c080e7          	jalr	316(ra) # 800041a2 <iunlockput>
    end_op();
    8000606e:	fffff097          	auipc	ra,0xfffff
    80006072:	912080e7          	jalr	-1774(ra) # 80004980 <end_op>
    return -1;
    80006076:	54fd                	li	s1,-1
    80006078:	b7b9                	j	80005fc6 <sys_open+0xe4>

000000008000607a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000607a:	7175                	addi	sp,sp,-144
    8000607c:	e506                	sd	ra,136(sp)
    8000607e:	e122                	sd	s0,128(sp)
    80006080:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006082:	fffff097          	auipc	ra,0xfffff
    80006086:	87e080e7          	jalr	-1922(ra) # 80004900 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000608a:	08000613          	li	a2,128
    8000608e:	f7040593          	addi	a1,s0,-144
    80006092:	4501                	li	a0,0
    80006094:	ffffd097          	auipc	ra,0xffffd
    80006098:	326080e7          	jalr	806(ra) # 800033ba <argstr>
    8000609c:	02054963          	bltz	a0,800060ce <sys_mkdir+0x54>
    800060a0:	4681                	li	a3,0
    800060a2:	4601                	li	a2,0
    800060a4:	4585                	li	a1,1
    800060a6:	f7040513          	addi	a0,s0,-144
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	800080e7          	jalr	-2048(ra) # 800058aa <create>
    800060b2:	cd11                	beqz	a0,800060ce <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800060b4:	ffffe097          	auipc	ra,0xffffe
    800060b8:	0ee080e7          	jalr	238(ra) # 800041a2 <iunlockput>
  end_op();
    800060bc:	fffff097          	auipc	ra,0xfffff
    800060c0:	8c4080e7          	jalr	-1852(ra) # 80004980 <end_op>
  return 0;
    800060c4:	4501                	li	a0,0
}
    800060c6:	60aa                	ld	ra,136(sp)
    800060c8:	640a                	ld	s0,128(sp)
    800060ca:	6149                	addi	sp,sp,144
    800060cc:	8082                	ret
    end_op();
    800060ce:	fffff097          	auipc	ra,0xfffff
    800060d2:	8b2080e7          	jalr	-1870(ra) # 80004980 <end_op>
    return -1;
    800060d6:	557d                	li	a0,-1
    800060d8:	b7fd                	j	800060c6 <sys_mkdir+0x4c>

00000000800060da <sys_mknod>:

uint64
sys_mknod(void)
{
    800060da:	7135                	addi	sp,sp,-160
    800060dc:	ed06                	sd	ra,152(sp)
    800060de:	e922                	sd	s0,144(sp)
    800060e0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800060e2:	fffff097          	auipc	ra,0xfffff
    800060e6:	81e080e7          	jalr	-2018(ra) # 80004900 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800060ea:	08000613          	li	a2,128
    800060ee:	f7040593          	addi	a1,s0,-144
    800060f2:	4501                	li	a0,0
    800060f4:	ffffd097          	auipc	ra,0xffffd
    800060f8:	2c6080e7          	jalr	710(ra) # 800033ba <argstr>
    800060fc:	04054a63          	bltz	a0,80006150 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80006100:	f6c40593          	addi	a1,s0,-148
    80006104:	4505                	li	a0,1
    80006106:	ffffd097          	auipc	ra,0xffffd
    8000610a:	270080e7          	jalr	624(ra) # 80003376 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000610e:	04054163          	bltz	a0,80006150 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80006112:	f6840593          	addi	a1,s0,-152
    80006116:	4509                	li	a0,2
    80006118:	ffffd097          	auipc	ra,0xffffd
    8000611c:	25e080e7          	jalr	606(ra) # 80003376 <argint>
     argint(1, &major) < 0 ||
    80006120:	02054863          	bltz	a0,80006150 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006124:	f6841683          	lh	a3,-152(s0)
    80006128:	f6c41603          	lh	a2,-148(s0)
    8000612c:	458d                	li	a1,3
    8000612e:	f7040513          	addi	a0,s0,-144
    80006132:	fffff097          	auipc	ra,0xfffff
    80006136:	778080e7          	jalr	1912(ra) # 800058aa <create>
     argint(2, &minor) < 0 ||
    8000613a:	c919                	beqz	a0,80006150 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000613c:	ffffe097          	auipc	ra,0xffffe
    80006140:	066080e7          	jalr	102(ra) # 800041a2 <iunlockput>
  end_op();
    80006144:	fffff097          	auipc	ra,0xfffff
    80006148:	83c080e7          	jalr	-1988(ra) # 80004980 <end_op>
  return 0;
    8000614c:	4501                	li	a0,0
    8000614e:	a031                	j	8000615a <sys_mknod+0x80>
    end_op();
    80006150:	fffff097          	auipc	ra,0xfffff
    80006154:	830080e7          	jalr	-2000(ra) # 80004980 <end_op>
    return -1;
    80006158:	557d                	li	a0,-1
}
    8000615a:	60ea                	ld	ra,152(sp)
    8000615c:	644a                	ld	s0,144(sp)
    8000615e:	610d                	addi	sp,sp,160
    80006160:	8082                	ret

0000000080006162 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006162:	7135                	addi	sp,sp,-160
    80006164:	ed06                	sd	ra,152(sp)
    80006166:	e922                	sd	s0,144(sp)
    80006168:	e526                	sd	s1,136(sp)
    8000616a:	e14a                	sd	s2,128(sp)
    8000616c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000616e:	ffffc097          	auipc	ra,0xffffc
    80006172:	f9c080e7          	jalr	-100(ra) # 8000210a <myproc>
    80006176:	892a                	mv	s2,a0
  
  begin_op();
    80006178:	ffffe097          	auipc	ra,0xffffe
    8000617c:	788080e7          	jalr	1928(ra) # 80004900 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006180:	08000613          	li	a2,128
    80006184:	f6040593          	addi	a1,s0,-160
    80006188:	4501                	li	a0,0
    8000618a:	ffffd097          	auipc	ra,0xffffd
    8000618e:	230080e7          	jalr	560(ra) # 800033ba <argstr>
    80006192:	04054b63          	bltz	a0,800061e8 <sys_chdir+0x86>
    80006196:	f6040513          	addi	a0,s0,-160
    8000619a:	ffffe097          	auipc	ra,0xffffe
    8000619e:	55a080e7          	jalr	1370(ra) # 800046f4 <namei>
    800061a2:	84aa                	mv	s1,a0
    800061a4:	c131                	beqz	a0,800061e8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800061a6:	ffffe097          	auipc	ra,0xffffe
    800061aa:	d9a080e7          	jalr	-614(ra) # 80003f40 <ilock>
  if(ip->type != T_DIR){
    800061ae:	04449703          	lh	a4,68(s1)
    800061b2:	4785                	li	a5,1
    800061b4:	04f71063          	bne	a4,a5,800061f4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800061b8:	8526                	mv	a0,s1
    800061ba:	ffffe097          	auipc	ra,0xffffe
    800061be:	e48080e7          	jalr	-440(ra) # 80004002 <iunlock>
  iput(p->cwd);
    800061c2:	16093503          	ld	a0,352(s2)
    800061c6:	ffffe097          	auipc	ra,0xffffe
    800061ca:	f34080e7          	jalr	-204(ra) # 800040fa <iput>
  end_op();
    800061ce:	ffffe097          	auipc	ra,0xffffe
    800061d2:	7b2080e7          	jalr	1970(ra) # 80004980 <end_op>
  p->cwd = ip;
    800061d6:	16993023          	sd	s1,352(s2)
  return 0;
    800061da:	4501                	li	a0,0
}
    800061dc:	60ea                	ld	ra,152(sp)
    800061de:	644a                	ld	s0,144(sp)
    800061e0:	64aa                	ld	s1,136(sp)
    800061e2:	690a                	ld	s2,128(sp)
    800061e4:	610d                	addi	sp,sp,160
    800061e6:	8082                	ret
    end_op();
    800061e8:	ffffe097          	auipc	ra,0xffffe
    800061ec:	798080e7          	jalr	1944(ra) # 80004980 <end_op>
    return -1;
    800061f0:	557d                	li	a0,-1
    800061f2:	b7ed                	j	800061dc <sys_chdir+0x7a>
    iunlockput(ip);
    800061f4:	8526                	mv	a0,s1
    800061f6:	ffffe097          	auipc	ra,0xffffe
    800061fa:	fac080e7          	jalr	-84(ra) # 800041a2 <iunlockput>
    end_op();
    800061fe:	ffffe097          	auipc	ra,0xffffe
    80006202:	782080e7          	jalr	1922(ra) # 80004980 <end_op>
    return -1;
    80006206:	557d                	li	a0,-1
    80006208:	bfd1                	j	800061dc <sys_chdir+0x7a>

000000008000620a <sys_exec>:

uint64
sys_exec(void)
{
    8000620a:	7145                	addi	sp,sp,-464
    8000620c:	e786                	sd	ra,456(sp)
    8000620e:	e3a2                	sd	s0,448(sp)
    80006210:	ff26                	sd	s1,440(sp)
    80006212:	fb4a                	sd	s2,432(sp)
    80006214:	f74e                	sd	s3,424(sp)
    80006216:	f352                	sd	s4,416(sp)
    80006218:	ef56                	sd	s5,408(sp)
    8000621a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000621c:	08000613          	li	a2,128
    80006220:	f4040593          	addi	a1,s0,-192
    80006224:	4501                	li	a0,0
    80006226:	ffffd097          	auipc	ra,0xffffd
    8000622a:	194080e7          	jalr	404(ra) # 800033ba <argstr>
    return -1;
    8000622e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006230:	0c054a63          	bltz	a0,80006304 <sys_exec+0xfa>
    80006234:	e3840593          	addi	a1,s0,-456
    80006238:	4505                	li	a0,1
    8000623a:	ffffd097          	auipc	ra,0xffffd
    8000623e:	15e080e7          	jalr	350(ra) # 80003398 <argaddr>
    80006242:	0c054163          	bltz	a0,80006304 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006246:	10000613          	li	a2,256
    8000624a:	4581                	li	a1,0
    8000624c:	e4040513          	addi	a0,s0,-448
    80006250:	ffffb097          	auipc	ra,0xffffb
    80006254:	be6080e7          	jalr	-1050(ra) # 80000e36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006258:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000625c:	89a6                	mv	s3,s1
    8000625e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006260:	02000a13          	li	s4,32
    80006264:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006268:	00391793          	slli	a5,s2,0x3
    8000626c:	e3040593          	addi	a1,s0,-464
    80006270:	e3843503          	ld	a0,-456(s0)
    80006274:	953e                	add	a0,a0,a5
    80006276:	ffffd097          	auipc	ra,0xffffd
    8000627a:	066080e7          	jalr	102(ra) # 800032dc <fetchaddr>
    8000627e:	02054a63          	bltz	a0,800062b2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80006282:	e3043783          	ld	a5,-464(s0)
    80006286:	c3b9                	beqz	a5,800062cc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006288:	ffffb097          	auipc	ra,0xffffb
    8000628c:	974080e7          	jalr	-1676(ra) # 80000bfc <kalloc>
    80006290:	85aa                	mv	a1,a0
    80006292:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006296:	cd11                	beqz	a0,800062b2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006298:	6605                	lui	a2,0x1
    8000629a:	e3043503          	ld	a0,-464(s0)
    8000629e:	ffffd097          	auipc	ra,0xffffd
    800062a2:	090080e7          	jalr	144(ra) # 8000332e <fetchstr>
    800062a6:	00054663          	bltz	a0,800062b2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800062aa:	0905                	addi	s2,s2,1
    800062ac:	09a1                	addi	s3,s3,8
    800062ae:	fb491be3          	bne	s2,s4,80006264 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062b2:	10048913          	addi	s2,s1,256
    800062b6:	6088                	ld	a0,0(s1)
    800062b8:	c529                	beqz	a0,80006302 <sys_exec+0xf8>
    kfree(argv[i]);
    800062ba:	ffffa097          	auipc	ra,0xffffa
    800062be:	7d0080e7          	jalr	2000(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062c2:	04a1                	addi	s1,s1,8
    800062c4:	ff2499e3          	bne	s1,s2,800062b6 <sys_exec+0xac>
  return -1;
    800062c8:	597d                	li	s2,-1
    800062ca:	a82d                	j	80006304 <sys_exec+0xfa>
      argv[i] = 0;
    800062cc:	0a8e                	slli	s5,s5,0x3
    800062ce:	fc040793          	addi	a5,s0,-64
    800062d2:	9abe                	add	s5,s5,a5
    800062d4:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffaae80>
  int ret = exec(path, argv);
    800062d8:	e4040593          	addi	a1,s0,-448
    800062dc:	f4040513          	addi	a0,s0,-192
    800062e0:	fffff097          	auipc	ra,0xfffff
    800062e4:	178080e7          	jalr	376(ra) # 80005458 <exec>
    800062e8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062ea:	10048993          	addi	s3,s1,256
    800062ee:	6088                	ld	a0,0(s1)
    800062f0:	c911                	beqz	a0,80006304 <sys_exec+0xfa>
    kfree(argv[i]);
    800062f2:	ffffa097          	auipc	ra,0xffffa
    800062f6:	798080e7          	jalr	1944(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062fa:	04a1                	addi	s1,s1,8
    800062fc:	ff3499e3          	bne	s1,s3,800062ee <sys_exec+0xe4>
    80006300:	a011                	j	80006304 <sys_exec+0xfa>
  return -1;
    80006302:	597d                	li	s2,-1
}
    80006304:	854a                	mv	a0,s2
    80006306:	60be                	ld	ra,456(sp)
    80006308:	641e                	ld	s0,448(sp)
    8000630a:	74fa                	ld	s1,440(sp)
    8000630c:	795a                	ld	s2,432(sp)
    8000630e:	79ba                	ld	s3,424(sp)
    80006310:	7a1a                	ld	s4,416(sp)
    80006312:	6afa                	ld	s5,408(sp)
    80006314:	6179                	addi	sp,sp,464
    80006316:	8082                	ret

0000000080006318 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006318:	7139                	addi	sp,sp,-64
    8000631a:	fc06                	sd	ra,56(sp)
    8000631c:	f822                	sd	s0,48(sp)
    8000631e:	f426                	sd	s1,40(sp)
    80006320:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006322:	ffffc097          	auipc	ra,0xffffc
    80006326:	de8080e7          	jalr	-536(ra) # 8000210a <myproc>
    8000632a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000632c:	fd840593          	addi	a1,s0,-40
    80006330:	4501                	li	a0,0
    80006332:	ffffd097          	auipc	ra,0xffffd
    80006336:	066080e7          	jalr	102(ra) # 80003398 <argaddr>
    return -1;
    8000633a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000633c:	0e054063          	bltz	a0,8000641c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80006340:	fc840593          	addi	a1,s0,-56
    80006344:	fd040513          	addi	a0,s0,-48
    80006348:	fffff097          	auipc	ra,0xfffff
    8000634c:	de0080e7          	jalr	-544(ra) # 80005128 <pipealloc>
    return -1;
    80006350:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006352:	0c054563          	bltz	a0,8000641c <sys_pipe+0x104>
  fd0 = -1;
    80006356:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000635a:	fd043503          	ld	a0,-48(s0)
    8000635e:	fffff097          	auipc	ra,0xfffff
    80006362:	50a080e7          	jalr	1290(ra) # 80005868 <fdalloc>
    80006366:	fca42223          	sw	a0,-60(s0)
    8000636a:	08054c63          	bltz	a0,80006402 <sys_pipe+0xea>
    8000636e:	fc843503          	ld	a0,-56(s0)
    80006372:	fffff097          	auipc	ra,0xfffff
    80006376:	4f6080e7          	jalr	1270(ra) # 80005868 <fdalloc>
    8000637a:	fca42023          	sw	a0,-64(s0)
    8000637e:	06054863          	bltz	a0,800063ee <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006382:	4691                	li	a3,4
    80006384:	fc440613          	addi	a2,s0,-60
    80006388:	fd843583          	ld	a1,-40(s0)
    8000638c:	68a8                	ld	a0,80(s1)
    8000638e:	ffffb097          	auipc	ra,0xffffb
    80006392:	692080e7          	jalr	1682(ra) # 80001a20 <copyout>
    80006396:	02054063          	bltz	a0,800063b6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000639a:	4691                	li	a3,4
    8000639c:	fc040613          	addi	a2,s0,-64
    800063a0:	fd843583          	ld	a1,-40(s0)
    800063a4:	0591                	addi	a1,a1,4
    800063a6:	68a8                	ld	a0,80(s1)
    800063a8:	ffffb097          	auipc	ra,0xffffb
    800063ac:	678080e7          	jalr	1656(ra) # 80001a20 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800063b0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063b2:	06055563          	bgez	a0,8000641c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800063b6:	fc442783          	lw	a5,-60(s0)
    800063ba:	07e9                	addi	a5,a5,26
    800063bc:	078e                	slli	a5,a5,0x3
    800063be:	97a6                	add	a5,a5,s1
    800063c0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800063c4:	fc042503          	lw	a0,-64(s0)
    800063c8:	0569                	addi	a0,a0,26
    800063ca:	050e                	slli	a0,a0,0x3
    800063cc:	9526                	add	a0,a0,s1
    800063ce:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800063d2:	fd043503          	ld	a0,-48(s0)
    800063d6:	fffff097          	auipc	ra,0xfffff
    800063da:	9fc080e7          	jalr	-1540(ra) # 80004dd2 <fileclose>
    fileclose(wf);
    800063de:	fc843503          	ld	a0,-56(s0)
    800063e2:	fffff097          	auipc	ra,0xfffff
    800063e6:	9f0080e7          	jalr	-1552(ra) # 80004dd2 <fileclose>
    return -1;
    800063ea:	57fd                	li	a5,-1
    800063ec:	a805                	j	8000641c <sys_pipe+0x104>
    if(fd0 >= 0)
    800063ee:	fc442783          	lw	a5,-60(s0)
    800063f2:	0007c863          	bltz	a5,80006402 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800063f6:	01a78513          	addi	a0,a5,26
    800063fa:	050e                	slli	a0,a0,0x3
    800063fc:	9526                	add	a0,a0,s1
    800063fe:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006402:	fd043503          	ld	a0,-48(s0)
    80006406:	fffff097          	auipc	ra,0xfffff
    8000640a:	9cc080e7          	jalr	-1588(ra) # 80004dd2 <fileclose>
    fileclose(wf);
    8000640e:	fc843503          	ld	a0,-56(s0)
    80006412:	fffff097          	auipc	ra,0xfffff
    80006416:	9c0080e7          	jalr	-1600(ra) # 80004dd2 <fileclose>
    return -1;
    8000641a:	57fd                	li	a5,-1
}
    8000641c:	853e                	mv	a0,a5
    8000641e:	70e2                	ld	ra,56(sp)
    80006420:	7442                	ld	s0,48(sp)
    80006422:	74a2                	ld	s1,40(sp)
    80006424:	6121                	addi	sp,sp,64
    80006426:	8082                	ret
	...

0000000080006430 <kernelvec>:
    80006430:	7111                	addi	sp,sp,-256
    80006432:	e006                	sd	ra,0(sp)
    80006434:	e40a                	sd	sp,8(sp)
    80006436:	e80e                	sd	gp,16(sp)
    80006438:	ec12                	sd	tp,24(sp)
    8000643a:	f016                	sd	t0,32(sp)
    8000643c:	f41a                	sd	t1,40(sp)
    8000643e:	f81e                	sd	t2,48(sp)
    80006440:	fc22                	sd	s0,56(sp)
    80006442:	e0a6                	sd	s1,64(sp)
    80006444:	e4aa                	sd	a0,72(sp)
    80006446:	e8ae                	sd	a1,80(sp)
    80006448:	ecb2                	sd	a2,88(sp)
    8000644a:	f0b6                	sd	a3,96(sp)
    8000644c:	f4ba                	sd	a4,104(sp)
    8000644e:	f8be                	sd	a5,112(sp)
    80006450:	fcc2                	sd	a6,120(sp)
    80006452:	e146                	sd	a7,128(sp)
    80006454:	e54a                	sd	s2,136(sp)
    80006456:	e94e                	sd	s3,144(sp)
    80006458:	ed52                	sd	s4,152(sp)
    8000645a:	f156                	sd	s5,160(sp)
    8000645c:	f55a                	sd	s6,168(sp)
    8000645e:	f95e                	sd	s7,176(sp)
    80006460:	fd62                	sd	s8,184(sp)
    80006462:	e1e6                	sd	s9,192(sp)
    80006464:	e5ea                	sd	s10,200(sp)
    80006466:	e9ee                	sd	s11,208(sp)
    80006468:	edf2                	sd	t3,216(sp)
    8000646a:	f1f6                	sd	t4,224(sp)
    8000646c:	f5fa                	sd	t5,232(sp)
    8000646e:	f9fe                	sd	t6,240(sp)
    80006470:	d39fc0ef          	jal	ra,800031a8 <kerneltrap>
    80006474:	6082                	ld	ra,0(sp)
    80006476:	6122                	ld	sp,8(sp)
    80006478:	61c2                	ld	gp,16(sp)
    8000647a:	7282                	ld	t0,32(sp)
    8000647c:	7322                	ld	t1,40(sp)
    8000647e:	73c2                	ld	t2,48(sp)
    80006480:	7462                	ld	s0,56(sp)
    80006482:	6486                	ld	s1,64(sp)
    80006484:	6526                	ld	a0,72(sp)
    80006486:	65c6                	ld	a1,80(sp)
    80006488:	6666                	ld	a2,88(sp)
    8000648a:	7686                	ld	a3,96(sp)
    8000648c:	7726                	ld	a4,104(sp)
    8000648e:	77c6                	ld	a5,112(sp)
    80006490:	7866                	ld	a6,120(sp)
    80006492:	688a                	ld	a7,128(sp)
    80006494:	692a                	ld	s2,136(sp)
    80006496:	69ca                	ld	s3,144(sp)
    80006498:	6a6a                	ld	s4,152(sp)
    8000649a:	7a8a                	ld	s5,160(sp)
    8000649c:	7b2a                	ld	s6,168(sp)
    8000649e:	7bca                	ld	s7,176(sp)
    800064a0:	7c6a                	ld	s8,184(sp)
    800064a2:	6c8e                	ld	s9,192(sp)
    800064a4:	6d2e                	ld	s10,200(sp)
    800064a6:	6dce                	ld	s11,208(sp)
    800064a8:	6e6e                	ld	t3,216(sp)
    800064aa:	7e8e                	ld	t4,224(sp)
    800064ac:	7f2e                	ld	t5,232(sp)
    800064ae:	7fce                	ld	t6,240(sp)
    800064b0:	6111                	addi	sp,sp,256
    800064b2:	10200073          	sret
    800064b6:	00000013          	nop
    800064ba:	00000013          	nop
    800064be:	0001                	nop

00000000800064c0 <timervec>:
    800064c0:	34051573          	csrrw	a0,mscratch,a0
    800064c4:	e10c                	sd	a1,0(a0)
    800064c6:	e510                	sd	a2,8(a0)
    800064c8:	e914                	sd	a3,16(a0)
    800064ca:	710c                	ld	a1,32(a0)
    800064cc:	7510                	ld	a2,40(a0)
    800064ce:	6194                	ld	a3,0(a1)
    800064d0:	96b2                	add	a3,a3,a2
    800064d2:	e194                	sd	a3,0(a1)
    800064d4:	4589                	li	a1,2
    800064d6:	14459073          	csrw	sip,a1
    800064da:	6914                	ld	a3,16(a0)
    800064dc:	6510                	ld	a2,8(a0)
    800064de:	610c                	ld	a1,0(a0)
    800064e0:	34051573          	csrrw	a0,mscratch,a0
    800064e4:	30200073          	mret
	...

00000000800064ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800064ea:	1141                	addi	sp,sp,-16
    800064ec:	e422                	sd	s0,8(sp)
    800064ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800064f0:	0c0007b7          	lui	a5,0xc000
    800064f4:	4705                	li	a4,1
    800064f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800064f8:	c3d8                	sw	a4,4(a5)
}
    800064fa:	6422                	ld	s0,8(sp)
    800064fc:	0141                	addi	sp,sp,16
    800064fe:	8082                	ret

0000000080006500 <plicinithart>:

void
plicinithart(void)
{
    80006500:	1141                	addi	sp,sp,-16
    80006502:	e406                	sd	ra,8(sp)
    80006504:	e022                	sd	s0,0(sp)
    80006506:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006508:	ffffc097          	auipc	ra,0xffffc
    8000650c:	bd6080e7          	jalr	-1066(ra) # 800020de <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006510:	0085171b          	slliw	a4,a0,0x8
    80006514:	0c0027b7          	lui	a5,0xc002
    80006518:	97ba                	add	a5,a5,a4
    8000651a:	40200713          	li	a4,1026
    8000651e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006522:	00d5151b          	slliw	a0,a0,0xd
    80006526:	0c2017b7          	lui	a5,0xc201
    8000652a:	953e                	add	a0,a0,a5
    8000652c:	00052023          	sw	zero,0(a0)
}
    80006530:	60a2                	ld	ra,8(sp)
    80006532:	6402                	ld	s0,0(sp)
    80006534:	0141                	addi	sp,sp,16
    80006536:	8082                	ret

0000000080006538 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006538:	1141                	addi	sp,sp,-16
    8000653a:	e406                	sd	ra,8(sp)
    8000653c:	e022                	sd	s0,0(sp)
    8000653e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006540:	ffffc097          	auipc	ra,0xffffc
    80006544:	b9e080e7          	jalr	-1122(ra) # 800020de <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006548:	00d5179b          	slliw	a5,a0,0xd
    8000654c:	0c201537          	lui	a0,0xc201
    80006550:	953e                	add	a0,a0,a5
  return irq;
}
    80006552:	4148                	lw	a0,4(a0)
    80006554:	60a2                	ld	ra,8(sp)
    80006556:	6402                	ld	s0,0(sp)
    80006558:	0141                	addi	sp,sp,16
    8000655a:	8082                	ret

000000008000655c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000655c:	1101                	addi	sp,sp,-32
    8000655e:	ec06                	sd	ra,24(sp)
    80006560:	e822                	sd	s0,16(sp)
    80006562:	e426                	sd	s1,8(sp)
    80006564:	1000                	addi	s0,sp,32
    80006566:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006568:	ffffc097          	auipc	ra,0xffffc
    8000656c:	b76080e7          	jalr	-1162(ra) # 800020de <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006570:	00d5151b          	slliw	a0,a0,0xd
    80006574:	0c2017b7          	lui	a5,0xc201
    80006578:	97aa                	add	a5,a5,a0
    8000657a:	c3c4                	sw	s1,4(a5)
}
    8000657c:	60e2                	ld	ra,24(sp)
    8000657e:	6442                	ld	s0,16(sp)
    80006580:	64a2                	ld	s1,8(sp)
    80006582:	6105                	addi	sp,sp,32
    80006584:	8082                	ret

0000000080006586 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006586:	1141                	addi	sp,sp,-16
    80006588:	e406                	sd	ra,8(sp)
    8000658a:	e022                	sd	s0,0(sp)
    8000658c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000658e:	479d                	li	a5,7
    80006590:	04a7cc63          	blt	a5,a0,800065e8 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006594:	0004b797          	auipc	a5,0x4b
    80006598:	a6c78793          	addi	a5,a5,-1428 # 80051000 <disk>
    8000659c:	00a78733          	add	a4,a5,a0
    800065a0:	6789                	lui	a5,0x2
    800065a2:	97ba                	add	a5,a5,a4
    800065a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800065a8:	eba1                	bnez	a5,800065f8 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    800065aa:	00451713          	slli	a4,a0,0x4
    800065ae:	0004d797          	auipc	a5,0x4d
    800065b2:	a527b783          	ld	a5,-1454(a5) # 80053000 <disk+0x2000>
    800065b6:	97ba                	add	a5,a5,a4
    800065b8:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    800065bc:	0004b797          	auipc	a5,0x4b
    800065c0:	a4478793          	addi	a5,a5,-1468 # 80051000 <disk>
    800065c4:	97aa                	add	a5,a5,a0
    800065c6:	6509                	lui	a0,0x2
    800065c8:	953e                	add	a0,a0,a5
    800065ca:	4785                	li	a5,1
    800065cc:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800065d0:	0004d517          	auipc	a0,0x4d
    800065d4:	a4850513          	addi	a0,a0,-1464 # 80053018 <disk+0x2018>
    800065d8:	ffffc097          	auipc	ra,0xffffc
    800065dc:	532080e7          	jalr	1330(ra) # 80002b0a <wakeup>
}
    800065e0:	60a2                	ld	ra,8(sp)
    800065e2:	6402                	ld	s0,0(sp)
    800065e4:	0141                	addi	sp,sp,16
    800065e6:	8082                	ret
    panic("virtio_disk_intr 1");
    800065e8:	00002517          	auipc	a0,0x2
    800065ec:	2e850513          	addi	a0,a0,744 # 800088d0 <syscalls+0x368>
    800065f0:	ffffa097          	auipc	ra,0xffffa
    800065f4:	ff4080e7          	jalr	-12(ra) # 800005e4 <panic>
    panic("virtio_disk_intr 2");
    800065f8:	00002517          	auipc	a0,0x2
    800065fc:	2f050513          	addi	a0,a0,752 # 800088e8 <syscalls+0x380>
    80006600:	ffffa097          	auipc	ra,0xffffa
    80006604:	fe4080e7          	jalr	-28(ra) # 800005e4 <panic>

0000000080006608 <virtio_disk_init>:
{
    80006608:	1101                	addi	sp,sp,-32
    8000660a:	ec06                	sd	ra,24(sp)
    8000660c:	e822                	sd	s0,16(sp)
    8000660e:	e426                	sd	s1,8(sp)
    80006610:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006612:	00002597          	auipc	a1,0x2
    80006616:	2ee58593          	addi	a1,a1,750 # 80008900 <syscalls+0x398>
    8000661a:	0004d517          	auipc	a0,0x4d
    8000661e:	a8e50513          	addi	a0,a0,-1394 # 800530a8 <disk+0x20a8>
    80006622:	ffffa097          	auipc	ra,0xffffa
    80006626:	688080e7          	jalr	1672(ra) # 80000caa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000662a:	100017b7          	lui	a5,0x10001
    8000662e:	4398                	lw	a4,0(a5)
    80006630:	2701                	sext.w	a4,a4
    80006632:	747277b7          	lui	a5,0x74727
    80006636:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000663a:	0ef71163          	bne	a4,a5,8000671c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000663e:	100017b7          	lui	a5,0x10001
    80006642:	43dc                	lw	a5,4(a5)
    80006644:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006646:	4705                	li	a4,1
    80006648:	0ce79a63          	bne	a5,a4,8000671c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000664c:	100017b7          	lui	a5,0x10001
    80006650:	479c                	lw	a5,8(a5)
    80006652:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006654:	4709                	li	a4,2
    80006656:	0ce79363          	bne	a5,a4,8000671c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000665a:	100017b7          	lui	a5,0x10001
    8000665e:	47d8                	lw	a4,12(a5)
    80006660:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006662:	554d47b7          	lui	a5,0x554d4
    80006666:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000666a:	0af71963          	bne	a4,a5,8000671c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000666e:	100017b7          	lui	a5,0x10001
    80006672:	4705                	li	a4,1
    80006674:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006676:	470d                	li	a4,3
    80006678:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000667a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000667c:	c7ffe737          	lui	a4,0xc7ffe
    80006680:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47faa75f>
    80006684:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006686:	2701                	sext.w	a4,a4
    80006688:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000668a:	472d                	li	a4,11
    8000668c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000668e:	473d                	li	a4,15
    80006690:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006692:	6705                	lui	a4,0x1
    80006694:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006696:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000669a:	5bdc                	lw	a5,52(a5)
    8000669c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000669e:	c7d9                	beqz	a5,8000672c <virtio_disk_init+0x124>
  if(max < NUM)
    800066a0:	471d                	li	a4,7
    800066a2:	08f77d63          	bgeu	a4,a5,8000673c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800066a6:	100014b7          	lui	s1,0x10001
    800066aa:	47a1                	li	a5,8
    800066ac:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800066ae:	6609                	lui	a2,0x2
    800066b0:	4581                	li	a1,0
    800066b2:	0004b517          	auipc	a0,0x4b
    800066b6:	94e50513          	addi	a0,a0,-1714 # 80051000 <disk>
    800066ba:	ffffa097          	auipc	ra,0xffffa
    800066be:	77c080e7          	jalr	1916(ra) # 80000e36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800066c2:	0004b717          	auipc	a4,0x4b
    800066c6:	93e70713          	addi	a4,a4,-1730 # 80051000 <disk>
    800066ca:	00c75793          	srli	a5,a4,0xc
    800066ce:	2781                	sext.w	a5,a5
    800066d0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    800066d2:	0004d797          	auipc	a5,0x4d
    800066d6:	92e78793          	addi	a5,a5,-1746 # 80053000 <disk+0x2000>
    800066da:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    800066dc:	0004b717          	auipc	a4,0x4b
    800066e0:	9a470713          	addi	a4,a4,-1628 # 80051080 <disk+0x80>
    800066e4:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    800066e6:	0004c717          	auipc	a4,0x4c
    800066ea:	91a70713          	addi	a4,a4,-1766 # 80052000 <disk+0x1000>
    800066ee:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800066f0:	4705                	li	a4,1
    800066f2:	00e78c23          	sb	a4,24(a5)
    800066f6:	00e78ca3          	sb	a4,25(a5)
    800066fa:	00e78d23          	sb	a4,26(a5)
    800066fe:	00e78da3          	sb	a4,27(a5)
    80006702:	00e78e23          	sb	a4,28(a5)
    80006706:	00e78ea3          	sb	a4,29(a5)
    8000670a:	00e78f23          	sb	a4,30(a5)
    8000670e:	00e78fa3          	sb	a4,31(a5)
}
    80006712:	60e2                	ld	ra,24(sp)
    80006714:	6442                	ld	s0,16(sp)
    80006716:	64a2                	ld	s1,8(sp)
    80006718:	6105                	addi	sp,sp,32
    8000671a:	8082                	ret
    panic("could not find virtio disk");
    8000671c:	00002517          	auipc	a0,0x2
    80006720:	1f450513          	addi	a0,a0,500 # 80008910 <syscalls+0x3a8>
    80006724:	ffffa097          	auipc	ra,0xffffa
    80006728:	ec0080e7          	jalr	-320(ra) # 800005e4 <panic>
    panic("virtio disk has no queue 0");
    8000672c:	00002517          	auipc	a0,0x2
    80006730:	20450513          	addi	a0,a0,516 # 80008930 <syscalls+0x3c8>
    80006734:	ffffa097          	auipc	ra,0xffffa
    80006738:	eb0080e7          	jalr	-336(ra) # 800005e4 <panic>
    panic("virtio disk max queue too short");
    8000673c:	00002517          	auipc	a0,0x2
    80006740:	21450513          	addi	a0,a0,532 # 80008950 <syscalls+0x3e8>
    80006744:	ffffa097          	auipc	ra,0xffffa
    80006748:	ea0080e7          	jalr	-352(ra) # 800005e4 <panic>

000000008000674c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000674c:	7175                	addi	sp,sp,-144
    8000674e:	e506                	sd	ra,136(sp)
    80006750:	e122                	sd	s0,128(sp)
    80006752:	fca6                	sd	s1,120(sp)
    80006754:	f8ca                	sd	s2,112(sp)
    80006756:	f4ce                	sd	s3,104(sp)
    80006758:	f0d2                	sd	s4,96(sp)
    8000675a:	ecd6                	sd	s5,88(sp)
    8000675c:	e8da                	sd	s6,80(sp)
    8000675e:	e4de                	sd	s7,72(sp)
    80006760:	e0e2                	sd	s8,64(sp)
    80006762:	fc66                	sd	s9,56(sp)
    80006764:	f86a                	sd	s10,48(sp)
    80006766:	f46e                	sd	s11,40(sp)
    80006768:	0900                	addi	s0,sp,144
    8000676a:	8aaa                	mv	s5,a0
    8000676c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000676e:	00c52c83          	lw	s9,12(a0)
    80006772:	001c9c9b          	slliw	s9,s9,0x1
    80006776:	1c82                	slli	s9,s9,0x20
    80006778:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000677c:	0004d517          	auipc	a0,0x4d
    80006780:	92c50513          	addi	a0,a0,-1748 # 800530a8 <disk+0x20a8>
    80006784:	ffffa097          	auipc	ra,0xffffa
    80006788:	5b6080e7          	jalr	1462(ra) # 80000d3a <acquire>
  for(int i = 0; i < 3; i++){
    8000678c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000678e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006790:	0004bc17          	auipc	s8,0x4b
    80006794:	870c0c13          	addi	s8,s8,-1936 # 80051000 <disk>
    80006798:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000679a:	4b0d                	li	s6,3
    8000679c:	a0ad                	j	80006806 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000679e:	00fc0733          	add	a4,s8,a5
    800067a2:	975e                	add	a4,a4,s7
    800067a4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800067a8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800067aa:	0207c563          	bltz	a5,800067d4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800067ae:	2905                	addiw	s2,s2,1
    800067b0:	0611                	addi	a2,a2,4
    800067b2:	19690d63          	beq	s2,s6,8000694c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800067b6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800067b8:	0004d717          	auipc	a4,0x4d
    800067bc:	86070713          	addi	a4,a4,-1952 # 80053018 <disk+0x2018>
    800067c0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800067c2:	00074683          	lbu	a3,0(a4)
    800067c6:	fee1                	bnez	a3,8000679e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800067c8:	2785                	addiw	a5,a5,1
    800067ca:	0705                	addi	a4,a4,1
    800067cc:	fe979be3          	bne	a5,s1,800067c2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800067d0:	57fd                	li	a5,-1
    800067d2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800067d4:	01205d63          	blez	s2,800067ee <virtio_disk_rw+0xa2>
    800067d8:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800067da:	000a2503          	lw	a0,0(s4)
    800067de:	00000097          	auipc	ra,0x0
    800067e2:	da8080e7          	jalr	-600(ra) # 80006586 <free_desc>
      for(int j = 0; j < i; j++)
    800067e6:	2d85                	addiw	s11,s11,1
    800067e8:	0a11                	addi	s4,s4,4
    800067ea:	ffb918e3          	bne	s2,s11,800067da <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800067ee:	0004d597          	auipc	a1,0x4d
    800067f2:	8ba58593          	addi	a1,a1,-1862 # 800530a8 <disk+0x20a8>
    800067f6:	0004d517          	auipc	a0,0x4d
    800067fa:	82250513          	addi	a0,a0,-2014 # 80053018 <disk+0x2018>
    800067fe:	ffffc097          	auipc	ra,0xffffc
    80006802:	18c080e7          	jalr	396(ra) # 8000298a <sleep>
  for(int i = 0; i < 3; i++){
    80006806:	f8040a13          	addi	s4,s0,-128
{
    8000680a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000680c:	894e                	mv	s2,s3
    8000680e:	b765                	j	800067b6 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006810:	0004c717          	auipc	a4,0x4c
    80006814:	7f073703          	ld	a4,2032(a4) # 80053000 <disk+0x2000>
    80006818:	973e                	add	a4,a4,a5
    8000681a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000681e:	0004a517          	auipc	a0,0x4a
    80006822:	7e250513          	addi	a0,a0,2018 # 80051000 <disk>
    80006826:	0004c717          	auipc	a4,0x4c
    8000682a:	7da70713          	addi	a4,a4,2010 # 80053000 <disk+0x2000>
    8000682e:	6314                	ld	a3,0(a4)
    80006830:	96be                	add	a3,a3,a5
    80006832:	00c6d603          	lhu	a2,12(a3)
    80006836:	00166613          	ori	a2,a2,1
    8000683a:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000683e:	f8842683          	lw	a3,-120(s0)
    80006842:	6310                	ld	a2,0(a4)
    80006844:	97b2                	add	a5,a5,a2
    80006846:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    8000684a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000684e:	0612                	slli	a2,a2,0x4
    80006850:	962a                	add	a2,a2,a0
    80006852:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006856:	00469793          	slli	a5,a3,0x4
    8000685a:	630c                	ld	a1,0(a4)
    8000685c:	95be                	add	a1,a1,a5
    8000685e:	6689                	lui	a3,0x2
    80006860:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006864:	96ca                	add	a3,a3,s2
    80006866:	96aa                	add	a3,a3,a0
    80006868:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    8000686a:	6314                	ld	a3,0(a4)
    8000686c:	96be                	add	a3,a3,a5
    8000686e:	4585                	li	a1,1
    80006870:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006872:	6314                	ld	a3,0(a4)
    80006874:	96be                	add	a3,a3,a5
    80006876:	4509                	li	a0,2
    80006878:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000687c:	6314                	ld	a3,0(a4)
    8000687e:	97b6                	add	a5,a5,a3
    80006880:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006884:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006888:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000688c:	6714                	ld	a3,8(a4)
    8000688e:	0026d783          	lhu	a5,2(a3)
    80006892:	8b9d                	andi	a5,a5,7
    80006894:	0789                	addi	a5,a5,2
    80006896:	0786                	slli	a5,a5,0x1
    80006898:	97b6                	add	a5,a5,a3
    8000689a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000689e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    800068a2:	6718                	ld	a4,8(a4)
    800068a4:	00275783          	lhu	a5,2(a4)
    800068a8:	2785                	addiw	a5,a5,1
    800068aa:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800068ae:	100017b7          	lui	a5,0x10001
    800068b2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800068b6:	004aa783          	lw	a5,4(s5)
    800068ba:	02b79163          	bne	a5,a1,800068dc <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800068be:	0004c917          	auipc	s2,0x4c
    800068c2:	7ea90913          	addi	s2,s2,2026 # 800530a8 <disk+0x20a8>
  while(b->disk == 1) {
    800068c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800068c8:	85ca                	mv	a1,s2
    800068ca:	8556                	mv	a0,s5
    800068cc:	ffffc097          	auipc	ra,0xffffc
    800068d0:	0be080e7          	jalr	190(ra) # 8000298a <sleep>
  while(b->disk == 1) {
    800068d4:	004aa783          	lw	a5,4(s5)
    800068d8:	fe9788e3          	beq	a5,s1,800068c8 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800068dc:	f8042483          	lw	s1,-128(s0)
    800068e0:	20048793          	addi	a5,s1,512
    800068e4:	00479713          	slli	a4,a5,0x4
    800068e8:	0004a797          	auipc	a5,0x4a
    800068ec:	71878793          	addi	a5,a5,1816 # 80051000 <disk>
    800068f0:	97ba                	add	a5,a5,a4
    800068f2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800068f6:	0004c917          	auipc	s2,0x4c
    800068fa:	70a90913          	addi	s2,s2,1802 # 80053000 <disk+0x2000>
    800068fe:	a019                	j	80006904 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006900:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006904:	8526                	mv	a0,s1
    80006906:	00000097          	auipc	ra,0x0
    8000690a:	c80080e7          	jalr	-896(ra) # 80006586 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000690e:	0492                	slli	s1,s1,0x4
    80006910:	00093783          	ld	a5,0(s2)
    80006914:	94be                	add	s1,s1,a5
    80006916:	00c4d783          	lhu	a5,12(s1)
    8000691a:	8b85                	andi	a5,a5,1
    8000691c:	f3f5                	bnez	a5,80006900 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000691e:	0004c517          	auipc	a0,0x4c
    80006922:	78a50513          	addi	a0,a0,1930 # 800530a8 <disk+0x20a8>
    80006926:	ffffa097          	auipc	ra,0xffffa
    8000692a:	4c8080e7          	jalr	1224(ra) # 80000dee <release>
}
    8000692e:	60aa                	ld	ra,136(sp)
    80006930:	640a                	ld	s0,128(sp)
    80006932:	74e6                	ld	s1,120(sp)
    80006934:	7946                	ld	s2,112(sp)
    80006936:	79a6                	ld	s3,104(sp)
    80006938:	7a06                	ld	s4,96(sp)
    8000693a:	6ae6                	ld	s5,88(sp)
    8000693c:	6b46                	ld	s6,80(sp)
    8000693e:	6ba6                	ld	s7,72(sp)
    80006940:	6c06                	ld	s8,64(sp)
    80006942:	7ce2                	ld	s9,56(sp)
    80006944:	7d42                	ld	s10,48(sp)
    80006946:	7da2                	ld	s11,40(sp)
    80006948:	6149                	addi	sp,sp,144
    8000694a:	8082                	ret
  if(write)
    8000694c:	01a037b3          	snez	a5,s10
    80006950:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    80006954:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006958:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    8000695c:	f8042483          	lw	s1,-128(s0)
    80006960:	00449913          	slli	s2,s1,0x4
    80006964:	0004c997          	auipc	s3,0x4c
    80006968:	69c98993          	addi	s3,s3,1692 # 80053000 <disk+0x2000>
    8000696c:	0009ba03          	ld	s4,0(s3)
    80006970:	9a4a                	add	s4,s4,s2
    80006972:	f7040513          	addi	a0,s0,-144
    80006976:	ffffb097          	auipc	ra,0xffffb
    8000697a:	886080e7          	jalr	-1914(ra) # 800011fc <kvmpa>
    8000697e:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006982:	0009b783          	ld	a5,0(s3)
    80006986:	97ca                	add	a5,a5,s2
    80006988:	4741                	li	a4,16
    8000698a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000698c:	0009b783          	ld	a5,0(s3)
    80006990:	97ca                	add	a5,a5,s2
    80006992:	4705                	li	a4,1
    80006994:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006998:	f8442783          	lw	a5,-124(s0)
    8000699c:	0009b703          	ld	a4,0(s3)
    800069a0:	974a                	add	a4,a4,s2
    800069a2:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800069a6:	0792                	slli	a5,a5,0x4
    800069a8:	0009b703          	ld	a4,0(s3)
    800069ac:	973e                	add	a4,a4,a5
    800069ae:	058a8693          	addi	a3,s5,88
    800069b2:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    800069b4:	0009b703          	ld	a4,0(s3)
    800069b8:	973e                	add	a4,a4,a5
    800069ba:	40000693          	li	a3,1024
    800069be:	c714                	sw	a3,8(a4)
  if(write)
    800069c0:	e40d18e3          	bnez	s10,80006810 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800069c4:	0004c717          	auipc	a4,0x4c
    800069c8:	63c73703          	ld	a4,1596(a4) # 80053000 <disk+0x2000>
    800069cc:	973e                	add	a4,a4,a5
    800069ce:	4689                	li	a3,2
    800069d0:	00d71623          	sh	a3,12(a4)
    800069d4:	b5a9                	j	8000681e <virtio_disk_rw+0xd2>

00000000800069d6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800069d6:	1101                	addi	sp,sp,-32
    800069d8:	ec06                	sd	ra,24(sp)
    800069da:	e822                	sd	s0,16(sp)
    800069dc:	e426                	sd	s1,8(sp)
    800069de:	e04a                	sd	s2,0(sp)
    800069e0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800069e2:	0004c517          	auipc	a0,0x4c
    800069e6:	6c650513          	addi	a0,a0,1734 # 800530a8 <disk+0x20a8>
    800069ea:	ffffa097          	auipc	ra,0xffffa
    800069ee:	350080e7          	jalr	848(ra) # 80000d3a <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800069f2:	0004c717          	auipc	a4,0x4c
    800069f6:	60e70713          	addi	a4,a4,1550 # 80053000 <disk+0x2000>
    800069fa:	02075783          	lhu	a5,32(a4)
    800069fe:	6b18                	ld	a4,16(a4)
    80006a00:	00275683          	lhu	a3,2(a4)
    80006a04:	8ebd                	xor	a3,a3,a5
    80006a06:	8a9d                	andi	a3,a3,7
    80006a08:	cab9                	beqz	a3,80006a5e <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006a0a:	0004a917          	auipc	s2,0x4a
    80006a0e:	5f690913          	addi	s2,s2,1526 # 80051000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006a12:	0004c497          	auipc	s1,0x4c
    80006a16:	5ee48493          	addi	s1,s1,1518 # 80053000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006a1a:	078e                	slli	a5,a5,0x3
    80006a1c:	97ba                	add	a5,a5,a4
    80006a1e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006a20:	20078713          	addi	a4,a5,512
    80006a24:	0712                	slli	a4,a4,0x4
    80006a26:	974a                	add	a4,a4,s2
    80006a28:	03074703          	lbu	a4,48(a4)
    80006a2c:	ef21                	bnez	a4,80006a84 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006a2e:	20078793          	addi	a5,a5,512
    80006a32:	0792                	slli	a5,a5,0x4
    80006a34:	97ca                	add	a5,a5,s2
    80006a36:	7798                	ld	a4,40(a5)
    80006a38:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80006a3c:	7788                	ld	a0,40(a5)
    80006a3e:	ffffc097          	auipc	ra,0xffffc
    80006a42:	0cc080e7          	jalr	204(ra) # 80002b0a <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006a46:	0204d783          	lhu	a5,32(s1)
    80006a4a:	2785                	addiw	a5,a5,1
    80006a4c:	8b9d                	andi	a5,a5,7
    80006a4e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006a52:	6898                	ld	a4,16(s1)
    80006a54:	00275683          	lhu	a3,2(a4)
    80006a58:	8a9d                	andi	a3,a3,7
    80006a5a:	fcf690e3          	bne	a3,a5,80006a1a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006a5e:	10001737          	lui	a4,0x10001
    80006a62:	533c                	lw	a5,96(a4)
    80006a64:	8b8d                	andi	a5,a5,3
    80006a66:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    80006a68:	0004c517          	auipc	a0,0x4c
    80006a6c:	64050513          	addi	a0,a0,1600 # 800530a8 <disk+0x20a8>
    80006a70:	ffffa097          	auipc	ra,0xffffa
    80006a74:	37e080e7          	jalr	894(ra) # 80000dee <release>
}
    80006a78:	60e2                	ld	ra,24(sp)
    80006a7a:	6442                	ld	s0,16(sp)
    80006a7c:	64a2                	ld	s1,8(sp)
    80006a7e:	6902                	ld	s2,0(sp)
    80006a80:	6105                	addi	sp,sp,32
    80006a82:	8082                	ret
      panic("virtio_disk_intr status");
    80006a84:	00002517          	auipc	a0,0x2
    80006a88:	eec50513          	addi	a0,a0,-276 # 80008970 <syscalls+0x408>
    80006a8c:	ffffa097          	auipc	ra,0xffffa
    80006a90:	b58080e7          	jalr	-1192(ra) # 800005e4 <panic>

0000000080006a94 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    80006a94:	1141                	addi	sp,sp,-16
    80006a96:	e406                	sd	ra,8(sp)
    80006a98:	e022                	sd	s0,0(sp)
    80006a9a:	0800                	addi	s0,sp,16
  alloc.next_page = kalloc();
    80006a9c:	ffffa097          	auipc	ra,0xffffa
    80006aa0:	160080e7          	jalr	352(ra) # 80000bfc <kalloc>
    80006aa4:	00002797          	auipc	a5,0x2
    80006aa8:	58a7b623          	sd	a0,1420(a5) # 80009030 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    80006aac:	00850793          	addi	a5,a0,8
    80006ab0:	e11c                	sd	a5,0(a0)
}
    80006ab2:	60a2                	ld	ra,8(sp)
    80006ab4:	6402                	ld	s0,0(sp)
    80006ab6:	0141                	addi	sp,sp,16
    80006ab8:	8082                	ret

0000000080006aba <mallo>:

void *mallo(u32 size) {
    80006aba:	1101                	addi	sp,sp,-32
    80006abc:	ec06                	sd	ra,24(sp)
    80006abe:	e822                	sd	s0,16(sp)
    80006ac0:	e426                	sd	s1,8(sp)
    80006ac2:	1000                	addi	s0,sp,32
    80006ac4:	84aa                	mv	s1,a0
  if (!if_init) {
    80006ac6:	00002797          	auipc	a5,0x2
    80006aca:	5627a783          	lw	a5,1378(a5) # 80009028 <if_init>
    80006ace:	cf9d                	beqz	a5,80006b0c <mallo+0x52>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  printf("size %d ", size);
    80006ad0:	85a6                	mv	a1,s1
    80006ad2:	00002517          	auipc	a0,0x2
    80006ad6:	eb650513          	addi	a0,a0,-330 # 80008988 <syscalls+0x420>
    80006ada:	ffffa097          	auipc	ra,0xffffa
    80006ade:	b5c080e7          	jalr	-1188(ra) # 80000636 <printf>
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    80006ae2:	00002717          	auipc	a4,0x2
    80006ae6:	54e73703          	ld	a4,1358(a4) # 80009030 <alloc>
    80006aea:	6308                	ld	a0,0(a4)
    80006aec:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    80006af0:	6785                	lui	a5,0x1
    80006af2:	37e1                	addiw	a5,a5,-8
    80006af4:	9f95                	subw	a5,a5,a3
    80006af6:	02f4f563          	bgeu	s1,a5,80006b20 <mallo+0x66>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    80006afa:	1482                	slli	s1,s1,0x20
    80006afc:	9081                	srli	s1,s1,0x20
    80006afe:	94aa                	add	s1,s1,a0
    80006b00:	e304                	sd	s1,0(a4)
  } else {
    printf("malloc failed");
    return 0;
  }
  return res;
}
    80006b02:	60e2                	ld	ra,24(sp)
    80006b04:	6442                	ld	s0,16(sp)
    80006b06:	64a2                	ld	s1,8(sp)
    80006b08:	6105                	addi	sp,sp,32
    80006b0a:	8082                	ret
    mem_init();
    80006b0c:	00000097          	auipc	ra,0x0
    80006b10:	f88080e7          	jalr	-120(ra) # 80006a94 <mem_init>
    if_init = 1;
    80006b14:	4785                	li	a5,1
    80006b16:	00002717          	auipc	a4,0x2
    80006b1a:	50f72923          	sw	a5,1298(a4) # 80009028 <if_init>
    80006b1e:	bf4d                	j	80006ad0 <mallo+0x16>
    printf("malloc failed");
    80006b20:	00002517          	auipc	a0,0x2
    80006b24:	e7850513          	addi	a0,a0,-392 # 80008998 <syscalls+0x430>
    80006b28:	ffffa097          	auipc	ra,0xffffa
    80006b2c:	b0e080e7          	jalr	-1266(ra) # 80000636 <printf>
    return 0;
    80006b30:	4501                	li	a0,0
    80006b32:	bfc1                	j	80006b02 <mallo+0x48>

0000000080006b34 <free>:

    80006b34:	1141                	addi	sp,sp,-16
    80006b36:	e422                	sd	s0,8(sp)
    80006b38:	0800                	addi	s0,sp,16
    80006b3a:	6422                	ld	s0,8(sp)
    80006b3c:	0141                	addi	sp,sp,16
    80006b3e:	8082                	ret
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
