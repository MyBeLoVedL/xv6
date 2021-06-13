
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
    80000060:	3e478793          	addi	a5,a5,996 # 80006440 <timervec>
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
    8000012a:	aae080e7          	jalr	-1362(ra) # 80002bd4 <either_copyin>
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
    800001ce:	f12080e7          	jalr	-238(ra) # 800020dc <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	74a080e7          	jalr	1866(ra) # 80002924 <sleep>
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
    8000021a:	968080e7          	jalr	-1688(ra) # 80002b7e <either_copyout>
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
    800002fa:	934080e7          	jalr	-1740(ra) # 80002c2a <procdump>
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
    8000044e:	65a080e7          	jalr	1626(ra) # 80002aa4 <wakeup>
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
    8000091e:	18a080e7          	jalr	394(ra) # 80002aa4 <wakeup>
    
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
    800009b8:	f70080e7          	jalr	-144(ra) # 80002924 <sleep>
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
    80000cd8:	3ec080e7          	jalr	1004(ra) # 800020c0 <mycpu>
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
    80000d0a:	3ba080e7          	jalr	954(ra) # 800020c0 <mycpu>
    80000d0e:	5d3c                	lw	a5,120(a0)
    80000d10:	cf89                	beqz	a5,80000d2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d12:	00001097          	auipc	ra,0x1
    80000d16:	3ae080e7          	jalr	942(ra) # 800020c0 <mycpu>
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
    80000d2e:	396080e7          	jalr	918(ra) # 800020c0 <mycpu>
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
    80000d6e:	356080e7          	jalr	854(ra) # 800020c0 <mycpu>
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
    80000d9a:	32a080e7          	jalr	810(ra) # 800020c0 <mycpu>
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
    80000ff0:	0c4080e7          	jalr	196(ra) # 800020b0 <cpuid>
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
    8000100c:	0a8080e7          	jalr	168(ra) # 800020b0 <cpuid>
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
    8000102e:	d40080e7          	jalr	-704(ra) # 80002d6a <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001032:	00005097          	auipc	ra,0x5
    80001036:	44e080e7          	jalr	1102(ra) # 80006480 <plicinithart>
  }

  scheduler();
    8000103a:	00001097          	auipc	ra,0x1
    8000103e:	60a080e7          	jalr	1546(ra) # 80002644 <scheduler>
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
    8000109e:	f46080e7          	jalr	-186(ra) # 80001fe0 <procinit>
    trapinit();         // trap vectors
    800010a2:	00002097          	auipc	ra,0x2
    800010a6:	ca0080e7          	jalr	-864(ra) # 80002d42 <trapinit>
    trapinithart();     // install kernel trap vector
    800010aa:	00002097          	auipc	ra,0x2
    800010ae:	cc0080e7          	jalr	-832(ra) # 80002d6a <trapinithart>
    plicinit();         // set up interrupt controller
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	3b8080e7          	jalr	952(ra) # 8000646a <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	3c6080e7          	jalr	966(ra) # 80006480 <plicinithart>
    binit();            // buffer cache
    800010c2:	00002097          	auipc	ra,0x2
    800010c6:	570080e7          	jalr	1392(ra) # 80003632 <binit>
    iinit();            // inode cache
    800010ca:	00003097          	auipc	ra,0x3
    800010ce:	c00080e7          	jalr	-1024(ra) # 80003cca <iinit>
    fileinit();         // file table
    800010d2:	00004097          	auipc	ra,0x4
    800010d6:	b9e080e7          	jalr	-1122(ra) # 80004c70 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010da:	00005097          	auipc	ra,0x5
    800010de:	4ae080e7          	jalr	1198(ra) # 80006588 <virtio_disk_init>
    userinit();         // first user process
    800010e2:	00001097          	auipc	ra,0x1
    800010e6:	2f8080e7          	jalr	760(ra) # 800023da <userinit>
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
    800018d4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffab000>
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
    80001a84:	65c080e7          	jalr	1628(ra) # 800020dc <myproc>
    80001a88:	653c                	ld	a5,72(a0)
    80001a8a:	06f97963          	bgeu	s2,a5,80001afc <copyout+0xca>
      if (do_lazy_allocation(myproc()->pagetable, va0) != 0) {
    80001a8e:	00000097          	auipc	ra,0x0
    80001a92:	64e080e7          	jalr	1614(ra) # 800020dc <myproc>
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
    80001b1a:	5c6080e7          	jalr	1478(ra) # 800020dc <myproc>
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
    80001b2e:	38050613          	addi	a2,a0,896
  void *avail = (void *)VMA_ORIGIN;
    80001b32:	4715                	li	a4,5
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
    80001b40:	03878793          	addi	a5,a5,56 # ffffffff80000038 <end+0xfffffffefffac038>
    80001b44:	00c78e63          	beq	a5,a2,80001b60 <find_avail_addr_range+0x3a>
    if ((vma + i)->used) {
    80001b48:	0307c683          	lbu	a3,48(a5)
    80001b4c:	daf5                	beqz	a3,80001b40 <find_avail_addr_range+0x1a>
      if ((vma + i)->start + (vma + i)->length > avail)
    80001b4e:	6398                	ld	a4,0(a5)
    80001b50:	6b94                	ld	a3,16(a5)
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
    80001b80:	6998                	ld	a4,16(a1)
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
    80001ba8:	0204a903          	lw	s2,32(s1)
    80001bac:	00f9093b          	addw	s2,s2,a5
    80001bb0:	77fd                	lui	a5,0xfffff
    80001bb2:	00f97933          	and	s2,s2,a5
    80001bb6:	2901                	sext.w	s2,s2
  ilock(vma->mmaped_file->ip);
    80001bb8:	749c                	ld	a5,40(s1)
    80001bba:	6f88                	ld	a0,24(a5)
    80001bbc:	00002097          	auipc	ra,0x2
    80001bc0:	306080e7          	jalr	774(ra) # 80003ec2 <ilock>
  int rc = 0;
  if ((rc = readi(vma->mmaped_file->ip, 0, (uint64)pa, file_off, PGSIZE)) < 0) {
    80001bc4:	749c                	ld	a5,40(s1)
    80001bc6:	6705                	lui	a4,0x1
    80001bc8:	86ca                	mv	a3,s2
    80001bca:	8652                	mv	a2,s4
    80001bcc:	4581                	li	a1,0
    80001bce:	6f88                	ld	a0,24(a5)
    80001bd0:	00002097          	auipc	ra,0x2
    80001bd4:	5a6080e7          	jalr	1446(ra) # 80004176 <readi>
    80001bd8:	04054263          	bltz	a0,80001c1c <do_vma+0xb6>
    printf("read failed , actual read %d\n", rc);
    return -2;
  }
  iunlock(vma->mmaped_file->ip);
    80001bdc:	749c                	ld	a5,40(s1)
    80001bde:	6f88                	ld	a0,24(a5)
    80001be0:	00002097          	auipc	ra,0x2
    80001be4:	3a4080e7          	jalr	932(ra) # 80003f84 <iunlock>
  int perm = PTE_U;
  if ((vma->mmaped_file->readable) && (vma->proct & PROT_READ))
    80001be8:	749c                	ld	a5,40(s1)
    80001bea:	0087c703          	lbu	a4,8(a5) # fffffffffffff008 <end+0xffffffff7ffab008>
    80001bee:	c731                	beqz	a4,80001c3a <do_vma+0xd4>
    80001bf0:	4c98                	lw	a4,24(s1)
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
    80001c44:	4c9c                	lw	a5,24(s1)
       (vma->mmaped_file->readable && (vma->proct & MAP_PRIVATE))) &&
    80001c46:	8b89                	andi	a5,a5,2
    80001c48:	ffdd                	bnez	a5,80001c06 <do_vma+0xa0>
  if (vma->proct & PROT_EXEC)
    80001c4a:	4c9c                	lw	a5,24(s1)
    80001c4c:	8b91                	andi	a5,a5,4
    80001c4e:	c399                	beqz	a5,80001c54 <do_vma+0xee>
    perm |= PTE_X;
    80001c50:	00896913          	ori	s2,s2,8
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
    80001c54:	00000097          	auipc	ra,0x0
    80001c58:	488080e7          	jalr	1160(ra) # 800020dc <myproc>
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

void *mmap(void *addr, u64 length, int proct, int flag, int fd, int offset) {
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
    80001c9e:	e062                	sd	s8,0(sp)
    80001ca0:	0880                	addi	s0,sp,80
    80001ca2:	8a2a                	mv	s4,a0
    80001ca4:	8bae                	mv	s7,a1
    80001ca6:	8ab2                	mv	s5,a2
    80001ca8:	8b36                	mv	s6,a3
    80001caa:	89ba                	mv	s3,a4
    80001cac:	8c3e                	mv	s8,a5
  struct proc *p = myproc();
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	42e080e7          	jalr	1070(ra) # 800020dc <myproc>
    80001cb6:	892a                	mv	s2,a0
  int i;
  u8 is_anno = 0;
  if (fd < 0)
    80001cb8:	0a09cb63          	bltz	s3,80001d6e <mmap+0xe4>
    is_anno = 1;
  else if (!p->ofile[fd])
    80001cbc:	01a98793          	addi	a5,s3,26 # fffffffffffff01a <end+0xffffffff7ffab01a>
    80001cc0:	078e                	slli	a5,a5,0x3
    80001cc2:	97aa                	add	a5,a5,a0
    80001cc4:	639c                	ld	a5,0(a5)
    80001cc6:	cbe1                	beqz	a5,80001d96 <mmap+0x10c>
    goto err;
  // printf("map proct  %d flag  %d\n", proct, flag);

  if (!is_anno && ((proct & PROT_WRITE) && !p->ofile[fd]->writable) &&
    80001cc8:	002af713          	andi	a4,s5,2
    80001ccc:	c369                	beqz	a4,80001d8e <mmap+0x104>
    80001cce:	0097c783          	lbu	a5,9(a5)
    80001cd2:	e3e1                	bnez	a5,80001d92 <mmap+0x108>
    80001cd4:	001b7713          	andi	a4,s6,1
    return (void *)-1;

  return p->vma[i].start;

err:
  return (void *)-1;
    80001cd8:	557d                	li	a0,-1
  if (!is_anno && ((proct & PROT_WRITE) && !p->ofile[fd]->writable) &&
    80001cda:	cb59                	beqz	a4,80001d70 <mmap+0xe6>
    80001cdc:	a899                	j	80001d32 <mmap+0xa8>
      p->vma[i].mmaped_file = !is_anno ? filedup(p->ofile[fd]) : 0;
    80001cde:	4501                	li	a0,0
    80001ce0:	c7ad                	beqz	a5,80001d4a <mmap+0xc0>
    80001ce2:	00349793          	slli	a5,s1,0x3
    80001ce6:	8f85                	sub	a5,a5,s1
    80001ce8:	078e                	slli	a5,a5,0x3
    80001cea:	97ca                	add	a5,a5,s2
    80001cec:	1aa7b023          	sd	a0,416(a5)
      p->vma[i].used = 1;
    80001cf0:	4705                	li	a4,1
    80001cf2:	1ae78423          	sb	a4,424(a5)
      p->vma[i].length = length;
    80001cf6:	1977b423          	sd	s7,392(a5)
      p->vma[i].proct = proct;
    80001cfa:	1957a823          	sw	s5,400(a5)
      p->vma[i].offset = offset;
    80001cfe:	1987ac23          	sw	s8,408(a5)
      p->vma[i].flag = flag;
    80001d02:	1967aa23          	sw	s6,404(a5)
      if (addr == 0)
    80001d06:	040a0c63          	beqz	s4,80001d5e <mmap+0xd4>
      p->vma[i].start = addr;
    80001d0a:	00349793          	slli	a5,s1,0x3
    80001d0e:	8f85                	sub	a5,a5,s1
    80001d10:	078e                	slli	a5,a5,0x3
    80001d12:	97ca                	add	a5,a5,s2
    80001d14:	1747bc23          	sd	s4,376(a5)
      p->vma[i].origin = addr;
    80001d18:	1947b023          	sd	s4,384(a5)
  if (i == MAX_VMA)
    80001d1c:	47c1                	li	a5,16
    80001d1e:	06f48e63          	beq	s1,a5,80001d9a <mmap+0x110>
  return p->vma[i].start;
    80001d22:	00349793          	slli	a5,s1,0x3
    80001d26:	409784b3          	sub	s1,a5,s1
    80001d2a:	048e                	slli	s1,s1,0x3
    80001d2c:	9926                	add	s2,s2,s1
    80001d2e:	17893503          	ld	a0,376(s2) # 1178 <_entry-0x7fffee88>
}
    80001d32:	60a6                	ld	ra,72(sp)
    80001d34:	6406                	ld	s0,64(sp)
    80001d36:	74e2                	ld	s1,56(sp)
    80001d38:	7942                	ld	s2,48(sp)
    80001d3a:	79a2                	ld	s3,40(sp)
    80001d3c:	7a02                	ld	s4,32(sp)
    80001d3e:	6ae2                	ld	s5,24(sp)
    80001d40:	6b42                	ld	s6,16(sp)
    80001d42:	6ba2                	ld	s7,8(sp)
    80001d44:	6c02                	ld	s8,0(sp)
    80001d46:	6161                	addi	sp,sp,80
    80001d48:	8082                	ret
      p->vma[i].mmaped_file = !is_anno ? filedup(p->ofile[fd]) : 0;
    80001d4a:	01a98793          	addi	a5,s3,26
    80001d4e:	078e                	slli	a5,a5,0x3
    80001d50:	97ca                	add	a5,a5,s2
    80001d52:	6388                	ld	a0,0(a5)
    80001d54:	00003097          	auipc	ra,0x3
    80001d58:	fae080e7          	jalr	-82(ra) # 80004d02 <filedup>
    80001d5c:	b759                	j	80001ce2 <mmap+0x58>
        addr = find_avail_addr_range(&p->vma[0]);
    80001d5e:	17890513          	addi	a0,s2,376
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	dc4080e7          	jalr	-572(ra) # 80001b26 <find_avail_addr_range>
    80001d6a:	8a2a                	mv	s4,a0
    80001d6c:	bf79                	j	80001d0a <mmap+0x80>
    is_anno = 1;
    80001d6e:	4785                	li	a5,1
  for (i = 0; i < MAX_VMA; i++) {
    80001d70:	1a890813          	addi	a6,s2,424
void *mmap(void *addr, u64 length, int proct, int flag, int fd, int offset) {
    80001d74:	4481                	li	s1,0
  for (i = 0; i < MAX_VMA; i++) {
    80001d76:	4341                	li	t1,16
    if (!p->vma[i].used) {
    80001d78:	00084883          	lbu	a7,0(a6) # fffffffffffff000 <end+0xffffffff7ffab000>
    80001d7c:	f60881e3          	beqz	a7,80001cde <mmap+0x54>
  for (i = 0; i < MAX_VMA; i++) {
    80001d80:	2485                	addiw	s1,s1,1
    80001d82:	03880813          	addi	a6,a6,56
    80001d86:	fe6499e3          	bne	s1,t1,80001d78 <mmap+0xee>
    return (void *)-1;
    80001d8a:	557d                	li	a0,-1
    80001d8c:	b75d                	j	80001d32 <mmap+0xa8>
  u8 is_anno = 0;
    80001d8e:	4781                	li	a5,0
    80001d90:	b7c5                	j	80001d70 <mmap+0xe6>
    80001d92:	4781                	li	a5,0
    80001d94:	bff1                	j	80001d70 <mmap+0xe6>
  return (void *)-1;
    80001d96:	557d                	li	a0,-1
    80001d98:	bf69                	j	80001d32 <mmap+0xa8>
    return (void *)-1;
    80001d9a:	557d                	li	a0,-1
    80001d9c:	bf59                	j	80001d32 <mmap+0xa8>

0000000080001d9e <munmap>:

int munmap(void *addr, int length) {
    80001d9e:	7175                	addi	sp,sp,-144
    80001da0:	e506                	sd	ra,136(sp)
    80001da2:	e122                	sd	s0,128(sp)
    80001da4:	fca6                	sd	s1,120(sp)
    80001da6:	f8ca                	sd	s2,112(sp)
    80001da8:	f4ce                	sd	s3,104(sp)
    80001daa:	f0d2                	sd	s4,96(sp)
    80001dac:	ecd6                	sd	s5,88(sp)
    80001dae:	e8da                	sd	s6,80(sp)
    80001db0:	e4de                	sd	s7,72(sp)
    80001db2:	e0e2                	sd	s8,64(sp)
    80001db4:	fc66                	sd	s9,56(sp)
    80001db6:	f86a                	sd	s10,48(sp)
    80001db8:	f46e                	sd	s11,40(sp)
    80001dba:	0900                	addi	s0,sp,144
    80001dbc:	892a                	mv	s2,a0
    80001dbe:	89ae                	mv	s3,a1
  // printf("~~~hello in unmap\n");
  vma_t *vma;
  struct proc *p = myproc();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	31c080e7          	jalr	796(ra) # 800020dc <myproc>
    80001dc8:	8aaa                	mv	s5,a0
  uint8 valid = 0;
  for (int i = 0; i < MAX_VMA; i++) {
    80001dca:	17850793          	addi	a5,a0,376
    80001dce:	4481                	li	s1,0
    if (p->vma[i].start == addr && p->vma[i].length >= length) {
    80001dd0:	f9343423          	sd	s3,-120(s0)
  for (int i = 0; i < MAX_VMA; i++) {
    80001dd4:	46c1                	li	a3,16
    80001dd6:	a031                	j	80001de2 <munmap+0x44>
    80001dd8:	2485                	addiw	s1,s1,1
    80001dda:	03878793          	addi	a5,a5,56
    80001dde:	04d48b63          	beq	s1,a3,80001e34 <munmap+0x96>
    if (p->vma[i].start == addr && p->vma[i].length >= length) {
    80001de2:	6398                	ld	a4,0(a5)
    80001de4:	ff271ae3          	bne	a4,s2,80001dd8 <munmap+0x3a>
    80001de8:	f8843703          	ld	a4,-120(s0)
    80001dec:	f6e43c23          	sd	a4,-136(s0)
    80001df0:	6b98                	ld	a4,16(a5)
    80001df2:	ff3763e3          	bltu	a4,s3,80001dd8 <munmap+0x3a>
    printf("not in vma\n");
    return -1;
  }
  int left = length, should_write = 0;
  void *cur = addr;
  vma->mmaped_file->off = cur - vma->origin + vma->offset;
    80001df6:	00349793          	slli	a5,s1,0x3
    80001dfa:	8f85                	sub	a5,a5,s1
    80001dfc:	078e                	slli	a5,a5,0x3
    80001dfe:	97d6                	add	a5,a5,s5
    80001e00:	1a07b683          	ld	a3,416(a5)
    80001e04:	1807b703          	ld	a4,384(a5)
    80001e08:	40e90733          	sub	a4,s2,a4
    80001e0c:	1987a783          	lw	a5,408(a5)
    80001e10:	9fb9                	addw	a5,a5,a4
    80001e12:	d29c                	sw	a5,32(a3)
  // printf("flag %p proctect %p\n", vma->flag, vma->proct);
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001e14:	f8843783          	ld	a5,-120(s0)
    80001e18:	00f90d33          	add	s10,s2,a5
  int left = length, should_write = 0;
    80001e1c:	4b01                	li	s6,0
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001e1e:	11a97163          	bgeu	s2,s10,80001f20 <munmap+0x182>
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    if (!pte)
      continue;
    // if (!(*pte & PTE_V))
    //   panic("unrecognized");
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    80001e22:	7dfd                	lui	s11,0xfffff
    80001e24:	6c85                	lui	s9,0x1
    left -= should_write;
    int wc = -9;
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
    80001e26:	00349c13          	slli	s8,s1,0x3
    80001e2a:	409c0c33          	sub	s8,s8,s1
    80001e2e:	0c0e                	slli	s8,s8,0x3
    80001e30:	9c56                	add	s8,s8,s5
    80001e32:	a071                	j	80001ebe <munmap+0x120>
    printf("not in vma\n");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	3fc50513          	addi	a0,a0,1020 # 80008230 <digits+0x1c8>
    80001e3c:	ffffe097          	auipc	ra,0xffffe
    80001e40:	7fa080e7          	jalr	2042(ra) # 80000636 <printf>
    return -1;
    80001e44:	557d                	li	a0,-1
  } else {
    vma->start += length;
    vma->length -= length;
  }
  return 0;
    80001e46:	60aa                	ld	ra,136(sp)
    80001e48:	640a                	ld	s0,128(sp)
    80001e4a:	74e6                	ld	s1,120(sp)
    80001e4c:	7946                	ld	s2,112(sp)
    80001e4e:	79a6                	ld	s3,104(sp)
    80001e50:	7a06                	ld	s4,96(sp)
    80001e52:	6ae6                	ld	s5,88(sp)
    80001e54:	6b46                	ld	s6,80(sp)
    80001e56:	6ba6                	ld	s7,72(sp)
    80001e58:	6c06                	ld	s8,64(sp)
    80001e5a:	7ce2                	ld	s9,56(sp)
    80001e5c:	7d42                	ld	s10,48(sp)
    80001e5e:	7da2                	ld	s11,40(sp)
    80001e60:	6149                	addi	sp,sp,144
    80001e62:	8082                	ret
      wc = filewrite(vma->mmaped_file, (uint64)cur, should_write);
    80001e64:	865a                	mv	a2,s6
    80001e66:	f8043583          	ld	a1,-128(s0)
    80001e6a:	1a0c3503          	ld	a0,416(s8) # fffffffffffff1a0 <end+0xffffffff7ffab1a0>
    80001e6e:	00003097          	auipc	ra,0x3
    80001e72:	0e2080e7          	jalr	226(ra) # 80004f50 <filewrite>
      if (wc < 0) {
    80001e76:	08055563          	bgez	a0,80001f00 <munmap+0x162>
               vma->mmaped_file->off, cur, should_write, wc);
    80001e7a:	00349793          	slli	a5,s1,0x3
    80001e7e:	8f85                	sub	a5,a5,s1
    80001e80:	078e                	slli	a5,a5,0x3
    80001e82:	9abe                	add	s5,s5,a5
        printf("res %d offset %d cur %p should %d vma write %d\n", wc,
    80001e84:	1a0ab603          	ld	a2,416(s5) # fffffffffffff1a0 <end+0xffffffff7ffab1a0>
    80001e88:	87aa                	mv	a5,a0
    80001e8a:	875a                	mv	a4,s6
    80001e8c:	86ca                	mv	a3,s2
    80001e8e:	5210                	lw	a2,32(a2)
    80001e90:	85aa                	mv	a1,a0
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	3ae50513          	addi	a0,a0,942 # 80008240 <digits+0x1d8>
    80001e9a:	ffffe097          	auipc	ra,0xffffe
    80001e9e:	79c080e7          	jalr	1948(ra) # 80000636 <printf>
        return -1;
    80001ea2:	557d                	li	a0,-1
    80001ea4:	b74d                	j	80001e46 <munmap+0xa8>
      uvmunmap(p->pagetable, PGROUNDDOWN((uint64)cur), 1, 1);
    80001ea6:	4685                	li	a3,1
    80001ea8:	4605                	li	a2,1
    80001eaa:	85de                	mv	a1,s7
    80001eac:	050ab503          	ld	a0,80(s5)
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	542080e7          	jalr	1346(ra) # 800013f2 <uvmunmap>
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001eb8:	995a                	add	s2,s2,s6
    80001eba:	07a97363          	bgeu	s2,s10,80001f20 <munmap+0x182>
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    80001ebe:	f9243023          	sd	s2,-128(s0)
    80001ec2:	4601                	li	a2,0
    80001ec4:	85ca                	mv	a1,s2
    80001ec6:	050ab503          	ld	a0,80(s5)
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	254080e7          	jalr	596(ra) # 8000111e <walk>
    80001ed2:	8a2a                	mv	s4,a0
    if (!pte)
    80001ed4:	d175                	beqz	a0,80001eb8 <munmap+0x11a>
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    80001ed6:	01b97bb3          	and	s7,s2,s11
    80001eda:	412b87b3          	sub	a5,s7,s2
    80001ede:	97e6                	add	a5,a5,s9
    80001ee0:	00f9f363          	bgeu	s3,a5,80001ee6 <munmap+0x148>
    80001ee4:	87ce                	mv	a5,s3
    80001ee6:	00078b1b          	sext.w	s6,a5
    left -= should_write;
    80001eea:	40f989bb          	subw	s3,s3,a5
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
    80001eee:	194c2783          	lw	a5,404(s8)
    80001ef2:	8b85                	andi	a5,a5,1
    80001ef4:	c791                	beqz	a5,80001f00 <munmap+0x162>
    80001ef6:	000a3783          	ld	a5,0(s4) # 1000 <_entry-0x7ffff000>
    80001efa:	0807f793          	andi	a5,a5,128
    80001efe:	f3bd                	bnez	a5,80001e64 <munmap+0xc6>
    if ((*pte & PTE_V) &&
    80001f00:	000a3783          	ld	a5,0(s4)
    80001f04:	8b85                	andi	a5,a5,1
    80001f06:	dbcd                	beqz	a5,80001eb8 <munmap+0x11a>
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
    80001f08:	f8043783          	ld	a5,-128(s0)
    80001f0c:	97da                	add	a5,a5,s6
    80001f0e:	019b8733          	add	a4,s7,s9
    if ((*pte & PTE_V) &&
    80001f12:	f8e78ae3          	beq	a5,a4,80001ea6 <munmap+0x108>
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
    80001f16:	188c3783          	ld	a5,392(s8)
    80001f1a:	f8fb1fe3          	bne	s6,a5,80001eb8 <munmap+0x11a>
    80001f1e:	b761                	j	80001ea6 <munmap+0x108>
  if (length == vma->length) {
    80001f20:	00349793          	slli	a5,s1,0x3
    80001f24:	8f85                	sub	a5,a5,s1
    80001f26:	078e                	slli	a5,a5,0x3
    80001f28:	97d6                	add	a5,a5,s5
    80001f2a:	1887b683          	ld	a3,392(a5)
    80001f2e:	f7843783          	ld	a5,-136(s0)
    80001f32:	02d78463          	beq	a5,a3,80001f5a <munmap+0x1bc>
    vma->start += length;
    80001f36:	00349793          	slli	a5,s1,0x3
    80001f3a:	40978733          	sub	a4,a5,s1
    80001f3e:	070e                	slli	a4,a4,0x3
    80001f40:	9756                	add	a4,a4,s5
    80001f42:	17873603          	ld	a2,376(a4) # 1178 <_entry-0x7fffee88>
    80001f46:	f8843583          	ld	a1,-120(s0)
    80001f4a:	962e                	add	a2,a2,a1
    80001f4c:	16c73c23          	sd	a2,376(a4)
    vma->length -= length;
    80001f50:	8e8d                	sub	a3,a3,a1
    80001f52:	18d73423          	sd	a3,392(a4)
  return 0;
    80001f56:	4501                	li	a0,0
    80001f58:	b5fd                	j	80001e46 <munmap+0xa8>
    fileclose(vma->mmaped_file);
    80001f5a:	00349913          	slli	s2,s1,0x3
    80001f5e:	409907b3          	sub	a5,s2,s1
    80001f62:	078e                	slli	a5,a5,0x3
    80001f64:	97d6                	add	a5,a5,s5
    80001f66:	1a07b503          	ld	a0,416(a5)
    80001f6a:	00003097          	auipc	ra,0x3
    80001f6e:	dea080e7          	jalr	-534(ra) # 80004d54 <fileclose>
      vma = &p->vma[i];
    80001f72:	40990533          	sub	a0,s2,s1
    80001f76:	050e                	slli	a0,a0,0x3
    80001f78:	17850513          	addi	a0,a0,376
    memset(vma, 0, sizeof(*vma));
    80001f7c:	03800613          	li	a2,56
    80001f80:	4581                	li	a1,0
    80001f82:	9556                	add	a0,a0,s5
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	eb2080e7          	jalr	-334(ra) # 80000e36 <memset>
    vma->used = 0;
    80001f8c:	409907b3          	sub	a5,s2,s1
    80001f90:	078e                	slli	a5,a5,0x3
    80001f92:	9abe                	add	s5,s5,a5
    80001f94:	1a0a8423          	sb	zero,424(s5)
  return 0;
    80001f98:	4501                	li	a0,0
    80001f9a:	b575                	j	80001e46 <munmap+0xa8>

0000000080001f9c <wakeup1>:
  }
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void wakeup1(struct proc *p) {
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	1000                	addi	s0,sp,32
    80001fa6:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	d18080e7          	jalr	-744(ra) # 80000cc0 <holding>
    80001fb0:	c909                	beqz	a0,80001fc2 <wakeup1+0x26>
    panic("wakeup1");
  if (p->chan == p && p->state == SLEEPING) {
    80001fb2:	749c                	ld	a5,40(s1)
    80001fb4:	00978f63          	beq	a5,s1,80001fd2 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	64a2                	ld	s1,8(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret
    panic("wakeup1");
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	2ae50513          	addi	a0,a0,686 # 80008270 <digits+0x208>
    80001fca:	ffffe097          	auipc	ra,0xffffe
    80001fce:	61a080e7          	jalr	1562(ra) # 800005e4 <panic>
  if (p->chan == p && p->state == SLEEPING) {
    80001fd2:	4c98                	lw	a4,24(s1)
    80001fd4:	4785                	li	a5,1
    80001fd6:	fef711e3          	bne	a4,a5,80001fb8 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001fda:	4789                	li	a5,2
    80001fdc:	cc9c                	sw	a5,24(s1)
}
    80001fde:	bfe9                	j	80001fb8 <wakeup1+0x1c>

0000000080001fe0 <procinit>:
void procinit(void) {
    80001fe0:	715d                	addi	sp,sp,-80
    80001fe2:	e486                	sd	ra,72(sp)
    80001fe4:	e0a2                	sd	s0,64(sp)
    80001fe6:	fc26                	sd	s1,56(sp)
    80001fe8:	f84a                	sd	s2,48(sp)
    80001fea:	f44e                	sd	s3,40(sp)
    80001fec:	f052                	sd	s4,32(sp)
    80001fee:	ec56                	sd	s5,24(sp)
    80001ff0:	e85a                	sd	s6,16(sp)
    80001ff2:	e45e                	sd	s7,8(sp)
    80001ff4:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001ff6:	00006597          	auipc	a1,0x6
    80001ffa:	28258593          	addi	a1,a1,642 # 80008278 <digits+0x210>
    80001ffe:	00030517          	auipc	a0,0x30
    80002002:	96250513          	addi	a0,a0,-1694 # 80031960 <pid_lock>
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	ca4080e7          	jalr	-860(ra) # 80000caa <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000200e:	00030917          	auipc	s2,0x30
    80002012:	d6a90913          	addi	s2,s2,-662 # 80031d78 <proc>
    initlock(&p->lock, "proc");
    80002016:	00006b97          	auipc	s7,0x6
    8000201a:	26ab8b93          	addi	s7,s7,618 # 80008280 <digits+0x218>
    uint64 va = KSTACK((int)(p - proc));
    8000201e:	8b4a                	mv	s6,s2
    80002020:	00006a97          	auipc	s5,0x6
    80002024:	fe0a8a93          	addi	s5,s5,-32 # 80008000 <etext>
    80002028:	040009b7          	lui	s3,0x4000
    8000202c:	19fd                	addi	s3,s3,-1
    8000202e:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80002030:	00044a17          	auipc	s4,0x44
    80002034:	b48a0a13          	addi	s4,s4,-1208 # 80045b78 <tickslock>
    initlock(&p->lock, "proc");
    80002038:	85de                	mv	a1,s7
    8000203a:	854a                	mv	a0,s2
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	c6e080e7          	jalr	-914(ra) # 80000caa <initlock>
    char *pa = kalloc();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	bb8080e7          	jalr	-1096(ra) # 80000bfc <kalloc>
    8000204c:	85aa                	mv	a1,a0
    if (pa == 0)
    8000204e:	c929                	beqz	a0,800020a0 <procinit+0xc0>
    uint64 va = KSTACK((int)(p - proc));
    80002050:	416904b3          	sub	s1,s2,s6
    80002054:	848d                	srai	s1,s1,0x3
    80002056:	000ab783          	ld	a5,0(s5)
    8000205a:	02f484b3          	mul	s1,s1,a5
    8000205e:	2485                	addiw	s1,s1,1
    80002060:	00d4949b          	slliw	s1,s1,0xd
    80002064:	409984b3          	sub	s1,s3,s1
    kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80002068:	4699                	li	a3,6
    8000206a:	6605                	lui	a2,0x1
    8000206c:	8526                	mv	a0,s1
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	27a080e7          	jalr	634(ra) # 800012e8 <kvmmap>
    p->kstack = va;
    80002076:	04993023          	sd	s1,64(s2)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000207a:	4f890913          	addi	s2,s2,1272
    8000207e:	fb491de3          	bne	s2,s4,80002038 <procinit+0x58>
  kvminithart();
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	078080e7          	jalr	120(ra) # 800010fa <kvminithart>
}
    8000208a:	60a6                	ld	ra,72(sp)
    8000208c:	6406                	ld	s0,64(sp)
    8000208e:	74e2                	ld	s1,56(sp)
    80002090:	7942                	ld	s2,48(sp)
    80002092:	79a2                	ld	s3,40(sp)
    80002094:	7a02                	ld	s4,32(sp)
    80002096:	6ae2                	ld	s5,24(sp)
    80002098:	6b42                	ld	s6,16(sp)
    8000209a:	6ba2                	ld	s7,8(sp)
    8000209c:	6161                	addi	sp,sp,80
    8000209e:	8082                	ret
      panic("kalloc");
    800020a0:	00006517          	auipc	a0,0x6
    800020a4:	1e850513          	addi	a0,a0,488 # 80008288 <digits+0x220>
    800020a8:	ffffe097          	auipc	ra,0xffffe
    800020ac:	53c080e7          	jalr	1340(ra) # 800005e4 <panic>

00000000800020b0 <cpuid>:
int cpuid() {
    800020b0:	1141                	addi	sp,sp,-16
    800020b2:	e422                	sd	s0,8(sp)
    800020b4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800020b6:	8512                	mv	a0,tp
}
    800020b8:	2501                	sext.w	a0,a0
    800020ba:	6422                	ld	s0,8(sp)
    800020bc:	0141                	addi	sp,sp,16
    800020be:	8082                	ret

00000000800020c0 <mycpu>:
struct cpu *mycpu(void) {
    800020c0:	1141                	addi	sp,sp,-16
    800020c2:	e422                	sd	s0,8(sp)
    800020c4:	0800                	addi	s0,sp,16
    800020c6:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800020c8:	2781                	sext.w	a5,a5
    800020ca:	079e                	slli	a5,a5,0x7
}
    800020cc:	00030517          	auipc	a0,0x30
    800020d0:	8ac50513          	addi	a0,a0,-1876 # 80031978 <cpus>
    800020d4:	953e                	add	a0,a0,a5
    800020d6:	6422                	ld	s0,8(sp)
    800020d8:	0141                	addi	sp,sp,16
    800020da:	8082                	ret

00000000800020dc <myproc>:
struct proc *myproc(void) {
    800020dc:	1101                	addi	sp,sp,-32
    800020de:	ec06                	sd	ra,24(sp)
    800020e0:	e822                	sd	s0,16(sp)
    800020e2:	e426                	sd	s1,8(sp)
    800020e4:	1000                	addi	s0,sp,32
  push_off();
    800020e6:	fffff097          	auipc	ra,0xfffff
    800020ea:	c08080e7          	jalr	-1016(ra) # 80000cee <push_off>
    800020ee:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800020f0:	2781                	sext.w	a5,a5
    800020f2:	079e                	slli	a5,a5,0x7
    800020f4:	00030717          	auipc	a4,0x30
    800020f8:	86c70713          	addi	a4,a4,-1940 # 80031960 <pid_lock>
    800020fc:	97ba                	add	a5,a5,a4
    800020fe:	6f84                	ld	s1,24(a5)
  pop_off();
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	c8e080e7          	jalr	-882(ra) # 80000d8e <pop_off>
}
    80002108:	8526                	mv	a0,s1
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	64a2                	ld	s1,8(sp)
    80002110:	6105                	addi	sp,sp,32
    80002112:	8082                	ret

0000000080002114 <forkret>:
void forkret(void) {
    80002114:	1141                	addi	sp,sp,-16
    80002116:	e406                	sd	ra,8(sp)
    80002118:	e022                	sd	s0,0(sp)
    8000211a:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	fc0080e7          	jalr	-64(ra) # 800020dc <myproc>
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	cca080e7          	jalr	-822(ra) # 80000dee <release>
  if (first) {
    8000212c:	00007797          	auipc	a5,0x7
    80002130:	8847a783          	lw	a5,-1916(a5) # 800089b0 <first.1>
    80002134:	eb89                	bnez	a5,80002146 <forkret+0x32>
  usertrapret();
    80002136:	00001097          	auipc	ra,0x1
    8000213a:	c4c080e7          	jalr	-948(ra) # 80002d82 <usertrapret>
}
    8000213e:	60a2                	ld	ra,8(sp)
    80002140:	6402                	ld	s0,0(sp)
    80002142:	0141                	addi	sp,sp,16
    80002144:	8082                	ret
    first = 0;
    80002146:	00007797          	auipc	a5,0x7
    8000214a:	8607a523          	sw	zero,-1942(a5) # 800089b0 <first.1>
    fsinit(ROOTDEV);
    8000214e:	4505                	li	a0,1
    80002150:	00002097          	auipc	ra,0x2
    80002154:	afa080e7          	jalr	-1286(ra) # 80003c4a <fsinit>
    80002158:	bff9                	j	80002136 <forkret+0x22>

000000008000215a <allocpid>:
int allocpid() {
    8000215a:	1101                	addi	sp,sp,-32
    8000215c:	ec06                	sd	ra,24(sp)
    8000215e:	e822                	sd	s0,16(sp)
    80002160:	e426                	sd	s1,8(sp)
    80002162:	e04a                	sd	s2,0(sp)
    80002164:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80002166:	0002f917          	auipc	s2,0x2f
    8000216a:	7fa90913          	addi	s2,s2,2042 # 80031960 <pid_lock>
    8000216e:	854a                	mv	a0,s2
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	bca080e7          	jalr	-1078(ra) # 80000d3a <acquire>
  pid = nextpid;
    80002178:	00007797          	auipc	a5,0x7
    8000217c:	83c78793          	addi	a5,a5,-1988 # 800089b4 <nextpid>
    80002180:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002182:	0014871b          	addiw	a4,s1,1
    80002186:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80002188:	854a                	mv	a0,s2
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	c64080e7          	jalr	-924(ra) # 80000dee <release>
}
    80002192:	8526                	mv	a0,s1
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6902                	ld	s2,0(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret

00000000800021a0 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	e426                	sd	s1,8(sp)
    800021a8:	e04a                	sd	s2,0(sp)
    800021aa:	1000                	addi	s0,sp,32
    800021ac:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	2ea080e7          	jalr	746(ra) # 80001498 <uvmcreate>
    800021b6:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800021b8:	c121                	beqz	a0,800021f8 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800021ba:	4729                	li	a4,10
    800021bc:	00005697          	auipc	a3,0x5
    800021c0:	e4468693          	addi	a3,a3,-444 # 80007000 <_trampoline>
    800021c4:	6605                	lui	a2,0x1
    800021c6:	040005b7          	lui	a1,0x4000
    800021ca:	15fd                	addi	a1,a1,-1
    800021cc:	05b2                	slli	a1,a1,0xc
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	08c080e7          	jalr	140(ra) # 8000125a <mappages>
    800021d6:	02054863          	bltz	a0,80002206 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    800021da:	4719                	li	a4,6
    800021dc:	05893683          	ld	a3,88(s2)
    800021e0:	6605                	lui	a2,0x1
    800021e2:	020005b7          	lui	a1,0x2000
    800021e6:	15fd                	addi	a1,a1,-1
    800021e8:	05b6                	slli	a1,a1,0xd
    800021ea:	8526                	mv	a0,s1
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	06e080e7          	jalr	110(ra) # 8000125a <mappages>
    800021f4:	02054163          	bltz	a0,80002216 <proc_pagetable+0x76>
}
    800021f8:	8526                	mv	a0,s1
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	64a2                	ld	s1,8(sp)
    80002200:	6902                	ld	s2,0(sp)
    80002202:	6105                	addi	sp,sp,32
    80002204:	8082                	ret
    uvmfree(pagetable, 0);
    80002206:	4581                	li	a1,0
    80002208:	8526                	mv	a0,s1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	48a080e7          	jalr	1162(ra) # 80001694 <uvmfree>
    return 0;
    80002212:	4481                	li	s1,0
    80002214:	b7d5                	j	800021f8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002216:	4681                	li	a3,0
    80002218:	4605                	li	a2,1
    8000221a:	040005b7          	lui	a1,0x4000
    8000221e:	15fd                	addi	a1,a1,-1
    80002220:	05b2                	slli	a1,a1,0xc
    80002222:	8526                	mv	a0,s1
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	1ce080e7          	jalr	462(ra) # 800013f2 <uvmunmap>
    uvmfree(pagetable, 0);
    8000222c:	4581                	li	a1,0
    8000222e:	8526                	mv	a0,s1
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	464080e7          	jalr	1124(ra) # 80001694 <uvmfree>
    return 0;
    80002238:	4481                	li	s1,0
    8000223a:	bf7d                	j	800021f8 <proc_pagetable+0x58>

000000008000223c <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    8000223c:	1101                	addi	sp,sp,-32
    8000223e:	ec06                	sd	ra,24(sp)
    80002240:	e822                	sd	s0,16(sp)
    80002242:	e426                	sd	s1,8(sp)
    80002244:	e04a                	sd	s2,0(sp)
    80002246:	1000                	addi	s0,sp,32
    80002248:	84aa                	mv	s1,a0
    8000224a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000224c:	4681                	li	a3,0
    8000224e:	4605                	li	a2,1
    80002250:	040005b7          	lui	a1,0x4000
    80002254:	15fd                	addi	a1,a1,-1
    80002256:	05b2                	slli	a1,a1,0xc
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	19a080e7          	jalr	410(ra) # 800013f2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002260:	4681                	li	a3,0
    80002262:	4605                	li	a2,1
    80002264:	020005b7          	lui	a1,0x2000
    80002268:	15fd                	addi	a1,a1,-1
    8000226a:	05b6                	slli	a1,a1,0xd
    8000226c:	8526                	mv	a0,s1
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	184080e7          	jalr	388(ra) # 800013f2 <uvmunmap>
  uvmfree(pagetable, sz);
    80002276:	85ca                	mv	a1,s2
    80002278:	8526                	mv	a0,s1
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	41a080e7          	jalr	1050(ra) # 80001694 <uvmfree>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	64a2                	ld	s1,8(sp)
    80002288:	6902                	ld	s2,0(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret

000000008000228e <freeproc>:
static void freeproc(struct proc *p) {
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	e426                	sd	s1,8(sp)
    80002296:	1000                	addi	s0,sp,32
    80002298:	84aa                	mv	s1,a0
  if (p->trapframe)
    8000229a:	6d28                	ld	a0,88(a0)
    8000229c:	c509                	beqz	a0,800022a6 <freeproc+0x18>
    kfree((void *)p->trapframe);
    8000229e:	ffffe097          	auipc	ra,0xffffe
    800022a2:	7ec080e7          	jalr	2028(ra) # 80000a8a <kfree>
  p->trapframe = 0;
    800022a6:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    800022aa:	68a8                	ld	a0,80(s1)
    800022ac:	c511                	beqz	a0,800022b8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800022ae:	64ac                	ld	a1,72(s1)
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	f8c080e7          	jalr	-116(ra) # 8000223c <proc_freepagetable>
  p->pagetable = 0;
    800022b8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800022bc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800022c0:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800022c4:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    800022c8:	14048823          	sb	zero,336(s1)
  p->chan = 0;
    800022cc:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800022d0:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800022d4:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800022d8:	0004ac23          	sw	zero,24(s1)
}
    800022dc:	60e2                	ld	ra,24(sp)
    800022de:	6442                	ld	s0,16(sp)
    800022e0:	64a2                	ld	s1,8(sp)
    800022e2:	6105                	addi	sp,sp,32
    800022e4:	8082                	ret

00000000800022e6 <allocproc>:
static struct proc *allocproc(void) {
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	e426                	sd	s1,8(sp)
    800022ee:	e04a                	sd	s2,0(sp)
    800022f0:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    800022f2:	00030497          	auipc	s1,0x30
    800022f6:	a8648493          	addi	s1,s1,-1402 # 80031d78 <proc>
    800022fa:	00044917          	auipc	s2,0x44
    800022fe:	87e90913          	addi	s2,s2,-1922 # 80045b78 <tickslock>
    acquire(&p->lock);
    80002302:	8526                	mv	a0,s1
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	a36080e7          	jalr	-1482(ra) # 80000d3a <acquire>
    if (p->state == UNUSED) {
    8000230c:	4c9c                	lw	a5,24(s1)
    8000230e:	cf81                	beqz	a5,80002326 <allocproc+0x40>
      release(&p->lock);
    80002310:	8526                	mv	a0,s1
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	adc080e7          	jalr	-1316(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000231a:	4f848493          	addi	s1,s1,1272
    8000231e:	ff2492e3          	bne	s1,s2,80002302 <allocproc+0x1c>
  return 0;
    80002322:	4481                	li	s1,0
    80002324:	a88d                	j	80002396 <allocproc+0xb0>
  p->pid = allocpid();
    80002326:	00000097          	auipc	ra,0x0
    8000232a:	e34080e7          	jalr	-460(ra) # 8000215a <allocpid>
    8000232e:	dc88                	sw	a0,56(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	8cc080e7          	jalr	-1844(ra) # 80000bfc <kalloc>
    80002338:	892a                	mv	s2,a0
    8000233a:	eca8                	sd	a0,88(s1)
    8000233c:	c525                	beqz	a0,800023a4 <allocproc+0xbe>
  p->pagetable = proc_pagetable(p);
    8000233e:	8526                	mv	a0,s1
    80002340:	00000097          	auipc	ra,0x0
    80002344:	e60080e7          	jalr	-416(ra) # 800021a0 <proc_pagetable>
    80002348:	892a                	mv	s2,a0
    8000234a:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    8000234c:	c13d                	beqz	a0,800023b2 <allocproc+0xcc>
  void *start = mmap((void *)VMA_HEAP_START,
    8000234e:	4781                	li	a5,0
    80002350:	577d                	li	a4,-1
    80002352:	4689                	li	a3,2
    80002354:	460d                	li	a2,3
    80002356:	4581                	li	a1,0
    80002358:	4505                	li	a0,1
    8000235a:	1502                	slli	a0,a0,0x20
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	92e080e7          	jalr	-1746(ra) # 80001c8a <mmap>
  if (start == 0)
    80002364:	c13d                	beqz	a0,800023ca <allocproc+0xe4>
  p->mem_layout.heap_start = start;
    80002366:	16a4b423          	sd	a0,360(s1)
  p->mem_layout.heap_size = VMA_ORIGIN - VMA_HEAP;
    8000236a:	4795                	li	a5,5
    8000236c:	1782                	slli	a5,a5,0x20
    8000236e:	16f4b823          	sd	a5,368(s1)
  memset(&p->context, 0, sizeof(p->context));
    80002372:	07000613          	li	a2,112
    80002376:	4581                	li	a1,0
    80002378:	06048513          	addi	a0,s1,96
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	aba080e7          	jalr	-1350(ra) # 80000e36 <memset>
  p->context.ra = (uint64)forkret;
    80002384:	00000797          	auipc	a5,0x0
    80002388:	d9078793          	addi	a5,a5,-624 # 80002114 <forkret>
    8000238c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000238e:	60bc                	ld	a5,64(s1)
    80002390:	6705                	lui	a4,0x1
    80002392:	97ba                	add	a5,a5,a4
    80002394:	f4bc                	sd	a5,104(s1)
}
    80002396:	8526                	mv	a0,s1
    80002398:	60e2                	ld	ra,24(sp)
    8000239a:	6442                	ld	s0,16(sp)
    8000239c:	64a2                	ld	s1,8(sp)
    8000239e:	6902                	ld	s2,0(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret
    release(&p->lock);
    800023a4:	8526                	mv	a0,s1
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	a48080e7          	jalr	-1464(ra) # 80000dee <release>
    return 0;
    800023ae:	84ca                	mv	s1,s2
    800023b0:	b7dd                	j	80002396 <allocproc+0xb0>
    freeproc(p);
    800023b2:	8526                	mv	a0,s1
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	eda080e7          	jalr	-294(ra) # 8000228e <freeproc>
    release(&p->lock);
    800023bc:	8526                	mv	a0,s1
    800023be:	fffff097          	auipc	ra,0xfffff
    800023c2:	a30080e7          	jalr	-1488(ra) # 80000dee <release>
    return 0;
    800023c6:	84ca                	mv	s1,s2
    800023c8:	b7f9                	j	80002396 <allocproc+0xb0>
    panic("can't create heap vma maping");
    800023ca:	00006517          	auipc	a0,0x6
    800023ce:	ec650513          	addi	a0,a0,-314 # 80008290 <digits+0x228>
    800023d2:	ffffe097          	auipc	ra,0xffffe
    800023d6:	212080e7          	jalr	530(ra) # 800005e4 <panic>

00000000800023da <userinit>:
void userinit(void) {
    800023da:	1101                	addi	sp,sp,-32
    800023dc:	ec06                	sd	ra,24(sp)
    800023de:	e822                	sd	s0,16(sp)
    800023e0:	e426                	sd	s1,8(sp)
    800023e2:	1000                	addi	s0,sp,32
  p = allocproc();
    800023e4:	00000097          	auipc	ra,0x0
    800023e8:	f02080e7          	jalr	-254(ra) # 800022e6 <allocproc>
    800023ec:	84aa                	mv	s1,a0
  initproc = p;
    800023ee:	00007797          	auipc	a5,0x7
    800023f2:	c2a7b523          	sd	a0,-982(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800023f6:	03400613          	li	a2,52
    800023fa:	00006597          	auipc	a1,0x6
    800023fe:	5c658593          	addi	a1,a1,1478 # 800089c0 <initcode>
    80002402:	6928                	ld	a0,80(a0)
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	0c2080e7          	jalr	194(ra) # 800014c6 <uvminit>
  p->sz = PGSIZE;
    8000240c:	6785                	lui	a5,0x1
    8000240e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80002410:	6cb8                	ld	a4,88(s1)
    80002412:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80002416:	6cb8                	ld	a4,88(s1)
    80002418:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000241a:	4641                	li	a2,16
    8000241c:	00006597          	auipc	a1,0x6
    80002420:	e9458593          	addi	a1,a1,-364 # 800082b0 <digits+0x248>
    80002424:	15048513          	addi	a0,s1,336
    80002428:	fffff097          	auipc	ra,0xfffff
    8000242c:	b60080e7          	jalr	-1184(ra) # 80000f88 <safestrcpy>
  p->cwd = namei("/");
    80002430:	00006517          	auipc	a0,0x6
    80002434:	e9050513          	addi	a0,a0,-368 # 800082c0 <digits+0x258>
    80002438:	00002097          	auipc	ra,0x2
    8000243c:	23e080e7          	jalr	574(ra) # 80004676 <namei>
    80002440:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80002444:	4789                	li	a5,2
    80002446:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002448:	8526                	mv	a0,s1
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	9a4080e7          	jalr	-1628(ra) # 80000dee <release>
}
    80002452:	60e2                	ld	ra,24(sp)
    80002454:	6442                	ld	s0,16(sp)
    80002456:	64a2                	ld	s1,8(sp)
    80002458:	6105                	addi	sp,sp,32
    8000245a:	8082                	ret

000000008000245c <growproc>:
int growproc(int n) {
    8000245c:	1101                	addi	sp,sp,-32
    8000245e:	ec06                	sd	ra,24(sp)
    80002460:	e822                	sd	s0,16(sp)
    80002462:	e426                	sd	s1,8(sp)
    80002464:	e04a                	sd	s2,0(sp)
    80002466:	1000                	addi	s0,sp,32
    80002468:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000246a:	00000097          	auipc	ra,0x0
    8000246e:	c72080e7          	jalr	-910(ra) # 800020dc <myproc>
    80002472:	892a                	mv	s2,a0
  sz = p->sz;
    80002474:	652c                	ld	a1,72(a0)
    80002476:	0005861b          	sext.w	a2,a1
  if (n > 0) {
    8000247a:	00904f63          	bgtz	s1,80002498 <growproc+0x3c>
  } else if (n < 0) {
    8000247e:	0204cc63          	bltz	s1,800024b6 <growproc+0x5a>
  p->sz = sz;
    80002482:	1602                	slli	a2,a2,0x20
    80002484:	9201                	srli	a2,a2,0x20
    80002486:	04c93423          	sd	a2,72(s2)
  return 0;
    8000248a:	4501                	li	a0,0
}
    8000248c:	60e2                	ld	ra,24(sp)
    8000248e:	6442                	ld	s0,16(sp)
    80002490:	64a2                	ld	s1,8(sp)
    80002492:	6902                	ld	s2,0(sp)
    80002494:	6105                	addi	sp,sp,32
    80002496:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80002498:	9e25                	addw	a2,a2,s1
    8000249a:	1602                	slli	a2,a2,0x20
    8000249c:	9201                	srli	a2,a2,0x20
    8000249e:	1582                	slli	a1,a1,0x20
    800024a0:	9181                	srli	a1,a1,0x20
    800024a2:	6928                	ld	a0,80(a0)
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	0dc080e7          	jalr	220(ra) # 80001580 <uvmalloc>
    800024ac:	0005061b          	sext.w	a2,a0
    800024b0:	fa69                	bnez	a2,80002482 <growproc+0x26>
      return -1;
    800024b2:	557d                	li	a0,-1
    800024b4:	bfe1                	j	8000248c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800024b6:	9e25                	addw	a2,a2,s1
    800024b8:	1602                	slli	a2,a2,0x20
    800024ba:	9201                	srli	a2,a2,0x20
    800024bc:	1582                	slli	a1,a1,0x20
    800024be:	9181                	srli	a1,a1,0x20
    800024c0:	6928                	ld	a0,80(a0)
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	076080e7          	jalr	118(ra) # 80001538 <uvmdealloc>
    800024ca:	0005061b          	sext.w	a2,a0
    800024ce:	bf55                	j	80002482 <growproc+0x26>

00000000800024d0 <fork>:
int fork(void) {
    800024d0:	7139                	addi	sp,sp,-64
    800024d2:	fc06                	sd	ra,56(sp)
    800024d4:	f822                	sd	s0,48(sp)
    800024d6:	f426                	sd	s1,40(sp)
    800024d8:	f04a                	sd	s2,32(sp)
    800024da:	ec4e                	sd	s3,24(sp)
    800024dc:	e852                	sd	s4,16(sp)
    800024de:	e456                	sd	s5,8(sp)
    800024e0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800024e2:	00000097          	auipc	ra,0x0
    800024e6:	bfa080e7          	jalr	-1030(ra) # 800020dc <myproc>
    800024ea:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800024ec:	00000097          	auipc	ra,0x0
    800024f0:	dfa080e7          	jalr	-518(ra) # 800022e6 <allocproc>
    800024f4:	c17d                	beqz	a0,800025da <fork+0x10a>
    800024f6:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800024f8:	048ab603          	ld	a2,72(s5)
    800024fc:	692c                	ld	a1,80(a0)
    800024fe:	050ab503          	ld	a0,80(s5)
    80002502:	fffff097          	auipc	ra,0xfffff
    80002506:	1ca080e7          	jalr	458(ra) # 800016cc <uvmcopy>
    8000250a:	04054a63          	bltz	a0,8000255e <fork+0x8e>
  np->sz = p->sz;
    8000250e:	048ab783          	ld	a5,72(s5)
    80002512:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80002516:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    8000251a:	058ab683          	ld	a3,88(s5)
    8000251e:	87b6                	mv	a5,a3
    80002520:	058a3703          	ld	a4,88(s4)
    80002524:	12068693          	addi	a3,a3,288
    80002528:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000252c:	6788                	ld	a0,8(a5)
    8000252e:	6b8c                	ld	a1,16(a5)
    80002530:	6f90                	ld	a2,24(a5)
    80002532:	01073023          	sd	a6,0(a4)
    80002536:	e708                	sd	a0,8(a4)
    80002538:	eb0c                	sd	a1,16(a4)
    8000253a:	ef10                	sd	a2,24(a4)
    8000253c:	02078793          	addi	a5,a5,32
    80002540:	02070713          	addi	a4,a4,32
    80002544:	fed792e3          	bne	a5,a3,80002528 <fork+0x58>
  np->trapframe->a0 = 0;
    80002548:	058a3783          	ld	a5,88(s4)
    8000254c:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80002550:	0d0a8493          	addi	s1,s5,208
    80002554:	0d0a0913          	addi	s2,s4,208
    80002558:	150a8993          	addi	s3,s5,336
    8000255c:	a00d                	j	8000257e <fork+0xae>
    freeproc(np);
    8000255e:	8552                	mv	a0,s4
    80002560:	00000097          	auipc	ra,0x0
    80002564:	d2e080e7          	jalr	-722(ra) # 8000228e <freeproc>
    release(&np->lock);
    80002568:	8552                	mv	a0,s4
    8000256a:	fffff097          	auipc	ra,0xfffff
    8000256e:	884080e7          	jalr	-1916(ra) # 80000dee <release>
    return -1;
    80002572:	54fd                	li	s1,-1
    80002574:	a889                	j	800025c6 <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
    80002576:	04a1                	addi	s1,s1,8
    80002578:	0921                	addi	s2,s2,8
    8000257a:	01348b63          	beq	s1,s3,80002590 <fork+0xc0>
    if (p->ofile[i])
    8000257e:	6088                	ld	a0,0(s1)
    80002580:	d97d                	beqz	a0,80002576 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80002582:	00002097          	auipc	ra,0x2
    80002586:	780080e7          	jalr	1920(ra) # 80004d02 <filedup>
    8000258a:	00a93023          	sd	a0,0(s2)
    8000258e:	b7e5                	j	80002576 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002590:	160ab503          	ld	a0,352(s5)
    80002594:	00002097          	auipc	ra,0x2
    80002598:	8f0080e7          	jalr	-1808(ra) # 80003e84 <idup>
    8000259c:	16aa3023          	sd	a0,352(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800025a0:	4641                	li	a2,16
    800025a2:	150a8593          	addi	a1,s5,336
    800025a6:	150a0513          	addi	a0,s4,336
    800025aa:	fffff097          	auipc	ra,0xfffff
    800025ae:	9de080e7          	jalr	-1570(ra) # 80000f88 <safestrcpy>
  pid = np->pid;
    800025b2:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    800025b6:	4789                	li	a5,2
    800025b8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800025bc:	8552                	mv	a0,s4
    800025be:	fffff097          	auipc	ra,0xfffff
    800025c2:	830080e7          	jalr	-2000(ra) # 80000dee <release>
}
    800025c6:	8526                	mv	a0,s1
    800025c8:	70e2                	ld	ra,56(sp)
    800025ca:	7442                	ld	s0,48(sp)
    800025cc:	74a2                	ld	s1,40(sp)
    800025ce:	7902                	ld	s2,32(sp)
    800025d0:	69e2                	ld	s3,24(sp)
    800025d2:	6a42                	ld	s4,16(sp)
    800025d4:	6aa2                	ld	s5,8(sp)
    800025d6:	6121                	addi	sp,sp,64
    800025d8:	8082                	ret
    return -1;
    800025da:	54fd                	li	s1,-1
    800025dc:	b7ed                	j	800025c6 <fork+0xf6>

00000000800025de <reparent>:
void reparent(struct proc *p) {
    800025de:	7179                	addi	sp,sp,-48
    800025e0:	f406                	sd	ra,40(sp)
    800025e2:	f022                	sd	s0,32(sp)
    800025e4:	ec26                	sd	s1,24(sp)
    800025e6:	e84a                	sd	s2,16(sp)
    800025e8:	e44e                	sd	s3,8(sp)
    800025ea:	e052                	sd	s4,0(sp)
    800025ec:	1800                	addi	s0,sp,48
    800025ee:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800025f0:	0002f497          	auipc	s1,0x2f
    800025f4:	78848493          	addi	s1,s1,1928 # 80031d78 <proc>
      pp->parent = initproc;
    800025f8:	00007a17          	auipc	s4,0x7
    800025fc:	a20a0a13          	addi	s4,s4,-1504 # 80009018 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002600:	00043997          	auipc	s3,0x43
    80002604:	57898993          	addi	s3,s3,1400 # 80045b78 <tickslock>
    80002608:	a029                	j	80002612 <reparent+0x34>
    8000260a:	4f848493          	addi	s1,s1,1272
    8000260e:	03348363          	beq	s1,s3,80002634 <reparent+0x56>
    if (pp->parent == p) {
    80002612:	709c                	ld	a5,32(s1)
    80002614:	ff279be3          	bne	a5,s2,8000260a <reparent+0x2c>
      acquire(&pp->lock);
    80002618:	8526                	mv	a0,s1
    8000261a:	ffffe097          	auipc	ra,0xffffe
    8000261e:	720080e7          	jalr	1824(ra) # 80000d3a <acquire>
      pp->parent = initproc;
    80002622:	000a3783          	ld	a5,0(s4)
    80002626:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80002628:	8526                	mv	a0,s1
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	7c4080e7          	jalr	1988(ra) # 80000dee <release>
    80002632:	bfe1                	j	8000260a <reparent+0x2c>
}
    80002634:	70a2                	ld	ra,40(sp)
    80002636:	7402                	ld	s0,32(sp)
    80002638:	64e2                	ld	s1,24(sp)
    8000263a:	6942                	ld	s2,16(sp)
    8000263c:	69a2                	ld	s3,8(sp)
    8000263e:	6a02                	ld	s4,0(sp)
    80002640:	6145                	addi	sp,sp,48
    80002642:	8082                	ret

0000000080002644 <scheduler>:
void scheduler(void) {
    80002644:	711d                	addi	sp,sp,-96
    80002646:	ec86                	sd	ra,88(sp)
    80002648:	e8a2                	sd	s0,80(sp)
    8000264a:	e4a6                	sd	s1,72(sp)
    8000264c:	e0ca                	sd	s2,64(sp)
    8000264e:	fc4e                	sd	s3,56(sp)
    80002650:	f852                	sd	s4,48(sp)
    80002652:	f456                	sd	s5,40(sp)
    80002654:	f05a                	sd	s6,32(sp)
    80002656:	ec5e                	sd	s7,24(sp)
    80002658:	e862                	sd	s8,16(sp)
    8000265a:	e466                	sd	s9,8(sp)
    8000265c:	1080                	addi	s0,sp,96
    8000265e:	8792                	mv	a5,tp
  int id = r_tp();
    80002660:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002662:	00779c13          	slli	s8,a5,0x7
    80002666:	0002f717          	auipc	a4,0x2f
    8000266a:	2fa70713          	addi	a4,a4,762 # 80031960 <pid_lock>
    8000266e:	9762                	add	a4,a4,s8
    80002670:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80002674:	0002f717          	auipc	a4,0x2f
    80002678:	30c70713          	addi	a4,a4,780 # 80031980 <cpus+0x8>
    8000267c:	9c3a                	add	s8,s8,a4
    int nproc = 0;
    8000267e:	4c81                	li	s9,0
      if (p->state == RUNNABLE) {
    80002680:	4a89                	li	s5,2
        c->proc = p;
    80002682:	079e                	slli	a5,a5,0x7
    80002684:	0002fb17          	auipc	s6,0x2f
    80002688:	2dcb0b13          	addi	s6,s6,732 # 80031960 <pid_lock>
    8000268c:	9b3e                	add	s6,s6,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    8000268e:	00043a17          	auipc	s4,0x43
    80002692:	4eaa0a13          	addi	s4,s4,1258 # 80045b78 <tickslock>
    80002696:	a8a1                	j	800026ee <scheduler+0xaa>
      release(&p->lock);
    80002698:	8526                	mv	a0,s1
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	754080e7          	jalr	1876(ra) # 80000dee <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800026a2:	4f848493          	addi	s1,s1,1272
    800026a6:	03448a63          	beq	s1,s4,800026da <scheduler+0x96>
      acquire(&p->lock);
    800026aa:	8526                	mv	a0,s1
    800026ac:	ffffe097          	auipc	ra,0xffffe
    800026b0:	68e080e7          	jalr	1678(ra) # 80000d3a <acquire>
      if (p->state != UNUSED) {
    800026b4:	4c9c                	lw	a5,24(s1)
    800026b6:	d3ed                	beqz	a5,80002698 <scheduler+0x54>
        nproc++;
    800026b8:	2985                	addiw	s3,s3,1
      if (p->state == RUNNABLE) {
    800026ba:	fd579fe3          	bne	a5,s5,80002698 <scheduler+0x54>
        p->state = RUNNING;
    800026be:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    800026c2:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    800026c6:	06048593          	addi	a1,s1,96
    800026ca:	8562                	mv	a0,s8
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	60c080e7          	jalr	1548(ra) # 80002cd8 <swtch>
        c->proc = 0;
    800026d4:	000b3c23          	sd	zero,24(s6)
    800026d8:	b7c1                	j	80002698 <scheduler+0x54>
    if (nproc <= 2) { // only init and sh exist
    800026da:	013aca63          	blt	s5,s3,800026ee <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026de:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800026e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800026e6:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800026ea:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026ee:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800026f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800026f6:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    800026fa:	89e6                	mv	s3,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    800026fc:	0002f497          	auipc	s1,0x2f
    80002700:	67c48493          	addi	s1,s1,1660 # 80031d78 <proc>
        p->state = RUNNING;
    80002704:	4b8d                	li	s7,3
    80002706:	b755                	j	800026aa <scheduler+0x66>

0000000080002708 <sched>:
void sched(void) {
    80002708:	7179                	addi	sp,sp,-48
    8000270a:	f406                	sd	ra,40(sp)
    8000270c:	f022                	sd	s0,32(sp)
    8000270e:	ec26                	sd	s1,24(sp)
    80002710:	e84a                	sd	s2,16(sp)
    80002712:	e44e                	sd	s3,8(sp)
    80002714:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	9c6080e7          	jalr	-1594(ra) # 800020dc <myproc>
    8000271e:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	5a0080e7          	jalr	1440(ra) # 80000cc0 <holding>
    80002728:	c93d                	beqz	a0,8000279e <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    8000272a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000272c:	2781                	sext.w	a5,a5
    8000272e:	079e                	slli	a5,a5,0x7
    80002730:	0002f717          	auipc	a4,0x2f
    80002734:	23070713          	addi	a4,a4,560 # 80031960 <pid_lock>
    80002738:	97ba                	add	a5,a5,a4
    8000273a:	0907a703          	lw	a4,144(a5)
    8000273e:	4785                	li	a5,1
    80002740:	06f71763          	bne	a4,a5,800027ae <sched+0xa6>
  if (p->state == RUNNING)
    80002744:	4c98                	lw	a4,24(s1)
    80002746:	478d                	li	a5,3
    80002748:	06f70b63          	beq	a4,a5,800027be <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000274c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002750:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002752:	efb5                	bnez	a5,800027ce <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80002754:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002756:	0002f917          	auipc	s2,0x2f
    8000275a:	20a90913          	addi	s2,s2,522 # 80031960 <pid_lock>
    8000275e:	2781                	sext.w	a5,a5
    80002760:	079e                	slli	a5,a5,0x7
    80002762:	97ca                	add	a5,a5,s2
    80002764:	0947a983          	lw	s3,148(a5)
    80002768:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000276a:	2781                	sext.w	a5,a5
    8000276c:	079e                	slli	a5,a5,0x7
    8000276e:	0002f597          	auipc	a1,0x2f
    80002772:	21258593          	addi	a1,a1,530 # 80031980 <cpus+0x8>
    80002776:	95be                	add	a1,a1,a5
    80002778:	06048513          	addi	a0,s1,96
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	55c080e7          	jalr	1372(ra) # 80002cd8 <swtch>
    80002784:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002786:	2781                	sext.w	a5,a5
    80002788:	079e                	slli	a5,a5,0x7
    8000278a:	97ca                	add	a5,a5,s2
    8000278c:	0937aa23          	sw	s3,148(a5)
}
    80002790:	70a2                	ld	ra,40(sp)
    80002792:	7402                	ld	s0,32(sp)
    80002794:	64e2                	ld	s1,24(sp)
    80002796:	6942                	ld	s2,16(sp)
    80002798:	69a2                	ld	s3,8(sp)
    8000279a:	6145                	addi	sp,sp,48
    8000279c:	8082                	ret
    panic("sched p->lock");
    8000279e:	00006517          	auipc	a0,0x6
    800027a2:	b2a50513          	addi	a0,a0,-1238 # 800082c8 <digits+0x260>
    800027a6:	ffffe097          	auipc	ra,0xffffe
    800027aa:	e3e080e7          	jalr	-450(ra) # 800005e4 <panic>
    panic("sched locks");
    800027ae:	00006517          	auipc	a0,0x6
    800027b2:	b2a50513          	addi	a0,a0,-1238 # 800082d8 <digits+0x270>
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	e2e080e7          	jalr	-466(ra) # 800005e4 <panic>
    panic("sched running");
    800027be:	00006517          	auipc	a0,0x6
    800027c2:	b2a50513          	addi	a0,a0,-1238 # 800082e8 <digits+0x280>
    800027c6:	ffffe097          	auipc	ra,0xffffe
    800027ca:	e1e080e7          	jalr	-482(ra) # 800005e4 <panic>
    panic("sched interruptible");
    800027ce:	00006517          	auipc	a0,0x6
    800027d2:	b2a50513          	addi	a0,a0,-1238 # 800082f8 <digits+0x290>
    800027d6:	ffffe097          	auipc	ra,0xffffe
    800027da:	e0e080e7          	jalr	-498(ra) # 800005e4 <panic>

00000000800027de <exit>:
void exit(int status) {
    800027de:	7179                	addi	sp,sp,-48
    800027e0:	f406                	sd	ra,40(sp)
    800027e2:	f022                	sd	s0,32(sp)
    800027e4:	ec26                	sd	s1,24(sp)
    800027e6:	e84a                	sd	s2,16(sp)
    800027e8:	e44e                	sd	s3,8(sp)
    800027ea:	e052                	sd	s4,0(sp)
    800027ec:	1800                	addi	s0,sp,48
    800027ee:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	8ec080e7          	jalr	-1812(ra) # 800020dc <myproc>
    800027f8:	89aa                	mv	s3,a0
  if (p == initproc)
    800027fa:	00007797          	auipc	a5,0x7
    800027fe:	81e7b783          	ld	a5,-2018(a5) # 80009018 <initproc>
    80002802:	0d050493          	addi	s1,a0,208
    80002806:	15050913          	addi	s2,a0,336
    8000280a:	02a79363          	bne	a5,a0,80002830 <exit+0x52>
    panic("init exiting");
    8000280e:	00006517          	auipc	a0,0x6
    80002812:	b0250513          	addi	a0,a0,-1278 # 80008310 <digits+0x2a8>
    80002816:	ffffe097          	auipc	ra,0xffffe
    8000281a:	dce080e7          	jalr	-562(ra) # 800005e4 <panic>
      fileclose(f);
    8000281e:	00002097          	auipc	ra,0x2
    80002822:	536080e7          	jalr	1334(ra) # 80004d54 <fileclose>
      p->ofile[fd] = 0;
    80002826:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    8000282a:	04a1                	addi	s1,s1,8
    8000282c:	01248563          	beq	s1,s2,80002836 <exit+0x58>
    if (p->ofile[fd]) {
    80002830:	6088                	ld	a0,0(s1)
    80002832:	f575                	bnez	a0,8000281e <exit+0x40>
    80002834:	bfdd                	j	8000282a <exit+0x4c>
  begin_op();
    80002836:	00002097          	auipc	ra,0x2
    8000283a:	04c080e7          	jalr	76(ra) # 80004882 <begin_op>
  iput(p->cwd);
    8000283e:	1609b503          	ld	a0,352(s3)
    80002842:	00002097          	auipc	ra,0x2
    80002846:	83a080e7          	jalr	-1990(ra) # 8000407c <iput>
  end_op();
    8000284a:	00002097          	auipc	ra,0x2
    8000284e:	0b8080e7          	jalr	184(ra) # 80004902 <end_op>
  p->cwd = 0;
    80002852:	1609b023          	sd	zero,352(s3)
  acquire(&initproc->lock);
    80002856:	00006497          	auipc	s1,0x6
    8000285a:	7c248493          	addi	s1,s1,1986 # 80009018 <initproc>
    8000285e:	6088                	ld	a0,0(s1)
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	4da080e7          	jalr	1242(ra) # 80000d3a <acquire>
  wakeup1(initproc);
    80002868:	6088                	ld	a0,0(s1)
    8000286a:	fffff097          	auipc	ra,0xfffff
    8000286e:	732080e7          	jalr	1842(ra) # 80001f9c <wakeup1>
  release(&initproc->lock);
    80002872:	6088                	ld	a0,0(s1)
    80002874:	ffffe097          	auipc	ra,0xffffe
    80002878:	57a080e7          	jalr	1402(ra) # 80000dee <release>
  acquire(&p->lock);
    8000287c:	854e                	mv	a0,s3
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	4bc080e7          	jalr	1212(ra) # 80000d3a <acquire>
  struct proc *original_parent = p->parent;
    80002886:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    8000288a:	854e                	mv	a0,s3
    8000288c:	ffffe097          	auipc	ra,0xffffe
    80002890:	562080e7          	jalr	1378(ra) # 80000dee <release>
  acquire(&original_parent->lock);
    80002894:	8526                	mv	a0,s1
    80002896:	ffffe097          	auipc	ra,0xffffe
    8000289a:	4a4080e7          	jalr	1188(ra) # 80000d3a <acquire>
  acquire(&p->lock);
    8000289e:	854e                	mv	a0,s3
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	49a080e7          	jalr	1178(ra) # 80000d3a <acquire>
  reparent(p);
    800028a8:	854e                	mv	a0,s3
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	d34080e7          	jalr	-716(ra) # 800025de <reparent>
  wakeup1(original_parent);
    800028b2:	8526                	mv	a0,s1
    800028b4:	fffff097          	auipc	ra,0xfffff
    800028b8:	6e8080e7          	jalr	1768(ra) # 80001f9c <wakeup1>
  p->xstate = status;
    800028bc:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800028c0:	4791                	li	a5,4
    800028c2:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800028c6:	8526                	mv	a0,s1
    800028c8:	ffffe097          	auipc	ra,0xffffe
    800028cc:	526080e7          	jalr	1318(ra) # 80000dee <release>
  sched();
    800028d0:	00000097          	auipc	ra,0x0
    800028d4:	e38080e7          	jalr	-456(ra) # 80002708 <sched>
  panic("zombie exit");
    800028d8:	00006517          	auipc	a0,0x6
    800028dc:	a4850513          	addi	a0,a0,-1464 # 80008320 <digits+0x2b8>
    800028e0:	ffffe097          	auipc	ra,0xffffe
    800028e4:	d04080e7          	jalr	-764(ra) # 800005e4 <panic>

00000000800028e8 <yield>:
void yield(void) {
    800028e8:	1101                	addi	sp,sp,-32
    800028ea:	ec06                	sd	ra,24(sp)
    800028ec:	e822                	sd	s0,16(sp)
    800028ee:	e426                	sd	s1,8(sp)
    800028f0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800028f2:	fffff097          	auipc	ra,0xfffff
    800028f6:	7ea080e7          	jalr	2026(ra) # 800020dc <myproc>
    800028fa:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	43e080e7          	jalr	1086(ra) # 80000d3a <acquire>
  p->state = RUNNABLE;
    80002904:	4789                	li	a5,2
    80002906:	cc9c                	sw	a5,24(s1)
  sched();
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	e00080e7          	jalr	-512(ra) # 80002708 <sched>
  release(&p->lock);
    80002910:	8526                	mv	a0,s1
    80002912:	ffffe097          	auipc	ra,0xffffe
    80002916:	4dc080e7          	jalr	1244(ra) # 80000dee <release>
}
    8000291a:	60e2                	ld	ra,24(sp)
    8000291c:	6442                	ld	s0,16(sp)
    8000291e:	64a2                	ld	s1,8(sp)
    80002920:	6105                	addi	sp,sp,32
    80002922:	8082                	ret

0000000080002924 <sleep>:
void sleep(void *chan, struct spinlock *lk) {
    80002924:	7179                	addi	sp,sp,-48
    80002926:	f406                	sd	ra,40(sp)
    80002928:	f022                	sd	s0,32(sp)
    8000292a:	ec26                	sd	s1,24(sp)
    8000292c:	e84a                	sd	s2,16(sp)
    8000292e:	e44e                	sd	s3,8(sp)
    80002930:	1800                	addi	s0,sp,48
    80002932:	89aa                	mv	s3,a0
    80002934:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002936:	fffff097          	auipc	ra,0xfffff
    8000293a:	7a6080e7          	jalr	1958(ra) # 800020dc <myproc>
    8000293e:	84aa                	mv	s1,a0
  if (lk != &p->lock) { // DOC: sleeplock0
    80002940:	05250663          	beq	a0,s2,8000298c <sleep+0x68>
    acquire(&p->lock);  // DOC: sleeplock1
    80002944:	ffffe097          	auipc	ra,0xffffe
    80002948:	3f6080e7          	jalr	1014(ra) # 80000d3a <acquire>
    release(lk);
    8000294c:	854a                	mv	a0,s2
    8000294e:	ffffe097          	auipc	ra,0xffffe
    80002952:	4a0080e7          	jalr	1184(ra) # 80000dee <release>
  p->chan = chan;
    80002956:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000295a:	4785                	li	a5,1
    8000295c:	cc9c                	sw	a5,24(s1)
  sched();
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	daa080e7          	jalr	-598(ra) # 80002708 <sched>
  p->chan = 0;
    80002966:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000296a:	8526                	mv	a0,s1
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	482080e7          	jalr	1154(ra) # 80000dee <release>
    acquire(lk);
    80002974:	854a                	mv	a0,s2
    80002976:	ffffe097          	auipc	ra,0xffffe
    8000297a:	3c4080e7          	jalr	964(ra) # 80000d3a <acquire>
}
    8000297e:	70a2                	ld	ra,40(sp)
    80002980:	7402                	ld	s0,32(sp)
    80002982:	64e2                	ld	s1,24(sp)
    80002984:	6942                	ld	s2,16(sp)
    80002986:	69a2                	ld	s3,8(sp)
    80002988:	6145                	addi	sp,sp,48
    8000298a:	8082                	ret
  p->chan = chan;
    8000298c:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002990:	4785                	li	a5,1
    80002992:	cd1c                	sw	a5,24(a0)
  sched();
    80002994:	00000097          	auipc	ra,0x0
    80002998:	d74080e7          	jalr	-652(ra) # 80002708 <sched>
  p->chan = 0;
    8000299c:	0204b423          	sd	zero,40(s1)
  if (lk != &p->lock) {
    800029a0:	bff9                	j	8000297e <sleep+0x5a>

00000000800029a2 <wait>:
int wait(uint64 addr) {
    800029a2:	715d                	addi	sp,sp,-80
    800029a4:	e486                	sd	ra,72(sp)
    800029a6:	e0a2                	sd	s0,64(sp)
    800029a8:	fc26                	sd	s1,56(sp)
    800029aa:	f84a                	sd	s2,48(sp)
    800029ac:	f44e                	sd	s3,40(sp)
    800029ae:	f052                	sd	s4,32(sp)
    800029b0:	ec56                	sd	s5,24(sp)
    800029b2:	e85a                	sd	s6,16(sp)
    800029b4:	e45e                	sd	s7,8(sp)
    800029b6:	0880                	addi	s0,sp,80
    800029b8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800029ba:	fffff097          	auipc	ra,0xfffff
    800029be:	722080e7          	jalr	1826(ra) # 800020dc <myproc>
    800029c2:	892a                	mv	s2,a0
  acquire(&p->lock);
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	376080e7          	jalr	886(ra) # 80000d3a <acquire>
    havekids = 0;
    800029cc:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    800029ce:	4a11                	li	s4,4
        havekids = 1;
    800029d0:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    800029d2:	00043997          	auipc	s3,0x43
    800029d6:	1a698993          	addi	s3,s3,422 # 80045b78 <tickslock>
    havekids = 0;
    800029da:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    800029dc:	0002f497          	auipc	s1,0x2f
    800029e0:	39c48493          	addi	s1,s1,924 # 80031d78 <proc>
    800029e4:	a08d                	j	80002a46 <wait+0xa4>
          pid = np->pid;
    800029e6:	0384a983          	lw	s3,56(s1)
          freeproc(np);
    800029ea:	8526                	mv	a0,s1
    800029ec:	00000097          	auipc	ra,0x0
    800029f0:	8a2080e7          	jalr	-1886(ra) # 8000228e <freeproc>
          if (addr != 0 &&
    800029f4:	000b0e63          	beqz	s6,80002a10 <wait+0x6e>
              (res = copyout(p->pagetable, addr, (char *)&np->xstate,
    800029f8:	4691                	li	a3,4
    800029fa:	03448613          	addi	a2,s1,52
    800029fe:	85da                	mv	a1,s6
    80002a00:	05093503          	ld	a0,80(s2)
    80002a04:	fffff097          	auipc	ra,0xfffff
    80002a08:	02e080e7          	jalr	46(ra) # 80001a32 <copyout>
          if (addr != 0 &&
    80002a0c:	00054d63          	bltz	a0,80002a26 <wait+0x84>
          release(&np->lock);
    80002a10:	8526                	mv	a0,s1
    80002a12:	ffffe097          	auipc	ra,0xffffe
    80002a16:	3dc080e7          	jalr	988(ra) # 80000dee <release>
          release(&p->lock);
    80002a1a:	854a                	mv	a0,s2
    80002a1c:	ffffe097          	auipc	ra,0xffffe
    80002a20:	3d2080e7          	jalr	978(ra) # 80000dee <release>
          return pid;
    80002a24:	a8a9                	j	80002a7e <wait+0xdc>
            release(&np->lock);
    80002a26:	8526                	mv	a0,s1
    80002a28:	ffffe097          	auipc	ra,0xffffe
    80002a2c:	3c6080e7          	jalr	966(ra) # 80000dee <release>
            release(&p->lock);
    80002a30:	854a                	mv	a0,s2
    80002a32:	ffffe097          	auipc	ra,0xffffe
    80002a36:	3bc080e7          	jalr	956(ra) # 80000dee <release>
            return -1;
    80002a3a:	59fd                	li	s3,-1
    80002a3c:	a089                	j	80002a7e <wait+0xdc>
    for (np = proc; np < &proc[NPROC]; np++) {
    80002a3e:	4f848493          	addi	s1,s1,1272
    80002a42:	03348463          	beq	s1,s3,80002a6a <wait+0xc8>
      if (np->parent == p) {
    80002a46:	709c                	ld	a5,32(s1)
    80002a48:	ff279be3          	bne	a5,s2,80002a3e <wait+0x9c>
        acquire(&np->lock);
    80002a4c:	8526                	mv	a0,s1
    80002a4e:	ffffe097          	auipc	ra,0xffffe
    80002a52:	2ec080e7          	jalr	748(ra) # 80000d3a <acquire>
        if (np->state == ZOMBIE) {
    80002a56:	4c9c                	lw	a5,24(s1)
    80002a58:	f94787e3          	beq	a5,s4,800029e6 <wait+0x44>
        release(&np->lock);
    80002a5c:	8526                	mv	a0,s1
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	390080e7          	jalr	912(ra) # 80000dee <release>
        havekids = 1;
    80002a66:	8756                	mv	a4,s5
    80002a68:	bfd9                	j	80002a3e <wait+0x9c>
    if (!havekids || p->killed) {
    80002a6a:	c701                	beqz	a4,80002a72 <wait+0xd0>
    80002a6c:	03092783          	lw	a5,48(s2)
    80002a70:	c39d                	beqz	a5,80002a96 <wait+0xf4>
      release(&p->lock);
    80002a72:	854a                	mv	a0,s2
    80002a74:	ffffe097          	auipc	ra,0xffffe
    80002a78:	37a080e7          	jalr	890(ra) # 80000dee <release>
      return -1;
    80002a7c:	59fd                	li	s3,-1
}
    80002a7e:	854e                	mv	a0,s3
    80002a80:	60a6                	ld	ra,72(sp)
    80002a82:	6406                	ld	s0,64(sp)
    80002a84:	74e2                	ld	s1,56(sp)
    80002a86:	7942                	ld	s2,48(sp)
    80002a88:	79a2                	ld	s3,40(sp)
    80002a8a:	7a02                	ld	s4,32(sp)
    80002a8c:	6ae2                	ld	s5,24(sp)
    80002a8e:	6b42                	ld	s6,16(sp)
    80002a90:	6ba2                	ld	s7,8(sp)
    80002a92:	6161                	addi	sp,sp,80
    80002a94:	8082                	ret
    sleep(p, &p->lock); // DOC: wait-sleep
    80002a96:	85ca                	mv	a1,s2
    80002a98:	854a                	mv	a0,s2
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	e8a080e7          	jalr	-374(ra) # 80002924 <sleep>
    havekids = 0;
    80002aa2:	bf25                	j	800029da <wait+0x38>

0000000080002aa4 <wakeup>:
void wakeup(void *chan) {
    80002aa4:	7139                	addi	sp,sp,-64
    80002aa6:	fc06                	sd	ra,56(sp)
    80002aa8:	f822                	sd	s0,48(sp)
    80002aaa:	f426                	sd	s1,40(sp)
    80002aac:	f04a                	sd	s2,32(sp)
    80002aae:	ec4e                	sd	s3,24(sp)
    80002ab0:	e852                	sd	s4,16(sp)
    80002ab2:	e456                	sd	s5,8(sp)
    80002ab4:	0080                	addi	s0,sp,64
    80002ab6:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80002ab8:	0002f497          	auipc	s1,0x2f
    80002abc:	2c048493          	addi	s1,s1,704 # 80031d78 <proc>
    if (p->state == SLEEPING && p->chan == chan) {
    80002ac0:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002ac2:	4a89                	li	s5,2
  for (p = proc; p < &proc[NPROC]; p++) {
    80002ac4:	00043917          	auipc	s2,0x43
    80002ac8:	0b490913          	addi	s2,s2,180 # 80045b78 <tickslock>
    80002acc:	a811                	j	80002ae0 <wakeup+0x3c>
    release(&p->lock);
    80002ace:	8526                	mv	a0,s1
    80002ad0:	ffffe097          	auipc	ra,0xffffe
    80002ad4:	31e080e7          	jalr	798(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002ad8:	4f848493          	addi	s1,s1,1272
    80002adc:	03248063          	beq	s1,s2,80002afc <wakeup+0x58>
    acquire(&p->lock);
    80002ae0:	8526                	mv	a0,s1
    80002ae2:	ffffe097          	auipc	ra,0xffffe
    80002ae6:	258080e7          	jalr	600(ra) # 80000d3a <acquire>
    if (p->state == SLEEPING && p->chan == chan) {
    80002aea:	4c9c                	lw	a5,24(s1)
    80002aec:	ff3791e3          	bne	a5,s3,80002ace <wakeup+0x2a>
    80002af0:	749c                	ld	a5,40(s1)
    80002af2:	fd479ee3          	bne	a5,s4,80002ace <wakeup+0x2a>
      p->state = RUNNABLE;
    80002af6:	0154ac23          	sw	s5,24(s1)
    80002afa:	bfd1                	j	80002ace <wakeup+0x2a>
}
    80002afc:	70e2                	ld	ra,56(sp)
    80002afe:	7442                	ld	s0,48(sp)
    80002b00:	74a2                	ld	s1,40(sp)
    80002b02:	7902                	ld	s2,32(sp)
    80002b04:	69e2                	ld	s3,24(sp)
    80002b06:	6a42                	ld	s4,16(sp)
    80002b08:	6aa2                	ld	s5,8(sp)
    80002b0a:	6121                	addi	sp,sp,64
    80002b0c:	8082                	ret

0000000080002b0e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80002b0e:	7179                	addi	sp,sp,-48
    80002b10:	f406                	sd	ra,40(sp)
    80002b12:	f022                	sd	s0,32(sp)
    80002b14:	ec26                	sd	s1,24(sp)
    80002b16:	e84a                	sd	s2,16(sp)
    80002b18:	e44e                	sd	s3,8(sp)
    80002b1a:	1800                	addi	s0,sp,48
    80002b1c:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002b1e:	0002f497          	auipc	s1,0x2f
    80002b22:	25a48493          	addi	s1,s1,602 # 80031d78 <proc>
    80002b26:	00043997          	auipc	s3,0x43
    80002b2a:	05298993          	addi	s3,s3,82 # 80045b78 <tickslock>
    acquire(&p->lock);
    80002b2e:	8526                	mv	a0,s1
    80002b30:	ffffe097          	auipc	ra,0xffffe
    80002b34:	20a080e7          	jalr	522(ra) # 80000d3a <acquire>
    if (p->pid == pid) {
    80002b38:	5c9c                	lw	a5,56(s1)
    80002b3a:	01278d63          	beq	a5,s2,80002b54 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002b3e:	8526                	mv	a0,s1
    80002b40:	ffffe097          	auipc	ra,0xffffe
    80002b44:	2ae080e7          	jalr	686(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002b48:	4f848493          	addi	s1,s1,1272
    80002b4c:	ff3491e3          	bne	s1,s3,80002b2e <kill+0x20>
  }
  return -1;
    80002b50:	557d                	li	a0,-1
    80002b52:	a821                	j	80002b6a <kill+0x5c>
      p->killed = 1;
    80002b54:	4785                	li	a5,1
    80002b56:	d89c                	sw	a5,48(s1)
      if (p->state == SLEEPING) {
    80002b58:	4c98                	lw	a4,24(s1)
    80002b5a:	00f70f63          	beq	a4,a5,80002b78 <kill+0x6a>
      release(&p->lock);
    80002b5e:	8526                	mv	a0,s1
    80002b60:	ffffe097          	auipc	ra,0xffffe
    80002b64:	28e080e7          	jalr	654(ra) # 80000dee <release>
      return 0;
    80002b68:	4501                	li	a0,0
}
    80002b6a:	70a2                	ld	ra,40(sp)
    80002b6c:	7402                	ld	s0,32(sp)
    80002b6e:	64e2                	ld	s1,24(sp)
    80002b70:	6942                	ld	s2,16(sp)
    80002b72:	69a2                	ld	s3,8(sp)
    80002b74:	6145                	addi	sp,sp,48
    80002b76:	8082                	ret
        p->state = RUNNABLE;
    80002b78:	4789                	li	a5,2
    80002b7a:	cc9c                	sw	a5,24(s1)
    80002b7c:	b7cd                	j	80002b5e <kill+0x50>

0000000080002b7e <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80002b7e:	7179                	addi	sp,sp,-48
    80002b80:	f406                	sd	ra,40(sp)
    80002b82:	f022                	sd	s0,32(sp)
    80002b84:	ec26                	sd	s1,24(sp)
    80002b86:	e84a                	sd	s2,16(sp)
    80002b88:	e44e                	sd	s3,8(sp)
    80002b8a:	e052                	sd	s4,0(sp)
    80002b8c:	1800                	addi	s0,sp,48
    80002b8e:	84aa                	mv	s1,a0
    80002b90:	892e                	mv	s2,a1
    80002b92:	89b2                	mv	s3,a2
    80002b94:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b96:	fffff097          	auipc	ra,0xfffff
    80002b9a:	546080e7          	jalr	1350(ra) # 800020dc <myproc>
  if (user_dst) {
    80002b9e:	c08d                	beqz	s1,80002bc0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002ba0:	86d2                	mv	a3,s4
    80002ba2:	864e                	mv	a2,s3
    80002ba4:	85ca                	mv	a1,s2
    80002ba6:	6928                	ld	a0,80(a0)
    80002ba8:	fffff097          	auipc	ra,0xfffff
    80002bac:	e8a080e7          	jalr	-374(ra) # 80001a32 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002bb0:	70a2                	ld	ra,40(sp)
    80002bb2:	7402                	ld	s0,32(sp)
    80002bb4:	64e2                	ld	s1,24(sp)
    80002bb6:	6942                	ld	s2,16(sp)
    80002bb8:	69a2                	ld	s3,8(sp)
    80002bba:	6a02                	ld	s4,0(sp)
    80002bbc:	6145                	addi	sp,sp,48
    80002bbe:	8082                	ret
    memmove((char *)dst, src, len);
    80002bc0:	000a061b          	sext.w	a2,s4
    80002bc4:	85ce                	mv	a1,s3
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	ffffe097          	auipc	ra,0xffffe
    80002bcc:	2ca080e7          	jalr	714(ra) # 80000e92 <memmove>
    return 0;
    80002bd0:	8526                	mv	a0,s1
    80002bd2:	bff9                	j	80002bb0 <either_copyout+0x32>

0000000080002bd4 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80002bd4:	7179                	addi	sp,sp,-48
    80002bd6:	f406                	sd	ra,40(sp)
    80002bd8:	f022                	sd	s0,32(sp)
    80002bda:	ec26                	sd	s1,24(sp)
    80002bdc:	e84a                	sd	s2,16(sp)
    80002bde:	e44e                	sd	s3,8(sp)
    80002be0:	e052                	sd	s4,0(sp)
    80002be2:	1800                	addi	s0,sp,48
    80002be4:	892a                	mv	s2,a0
    80002be6:	84ae                	mv	s1,a1
    80002be8:	89b2                	mv	s3,a2
    80002bea:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002bec:	fffff097          	auipc	ra,0xfffff
    80002bf0:	4f0080e7          	jalr	1264(ra) # 800020dc <myproc>
  if (user_src) {
    80002bf4:	c08d                	beqz	s1,80002c16 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002bf6:	86d2                	mv	a3,s4
    80002bf8:	864e                	mv	a2,s3
    80002bfa:	85ca                	mv	a1,s2
    80002bfc:	6928                	ld	a0,80(a0)
    80002bfe:	fffff097          	auipc	ra,0xfffff
    80002c02:	bc0080e7          	jalr	-1088(ra) # 800017be <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002c06:	70a2                	ld	ra,40(sp)
    80002c08:	7402                	ld	s0,32(sp)
    80002c0a:	64e2                	ld	s1,24(sp)
    80002c0c:	6942                	ld	s2,16(sp)
    80002c0e:	69a2                	ld	s3,8(sp)
    80002c10:	6a02                	ld	s4,0(sp)
    80002c12:	6145                	addi	sp,sp,48
    80002c14:	8082                	ret
    memmove(dst, (char *)src, len);
    80002c16:	000a061b          	sext.w	a2,s4
    80002c1a:	85ce                	mv	a1,s3
    80002c1c:	854a                	mv	a0,s2
    80002c1e:	ffffe097          	auipc	ra,0xffffe
    80002c22:	274080e7          	jalr	628(ra) # 80000e92 <memmove>
    return 0;
    80002c26:	8526                	mv	a0,s1
    80002c28:	bff9                	j	80002c06 <either_copyin+0x32>

0000000080002c2a <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80002c2a:	715d                	addi	sp,sp,-80
    80002c2c:	e486                	sd	ra,72(sp)
    80002c2e:	e0a2                	sd	s0,64(sp)
    80002c30:	fc26                	sd	s1,56(sp)
    80002c32:	f84a                	sd	s2,48(sp)
    80002c34:	f44e                	sd	s3,40(sp)
    80002c36:	f052                	sd	s4,32(sp)
    80002c38:	ec56                	sd	s5,24(sp)
    80002c3a:	e85a                	sd	s6,16(sp)
    80002c3c:	e45e                	sd	s7,8(sp)
    80002c3e:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002c40:	00005517          	auipc	a0,0x5
    80002c44:	47850513          	addi	a0,a0,1144 # 800080b8 <digits+0x50>
    80002c48:	ffffe097          	auipc	ra,0xffffe
    80002c4c:	9ee080e7          	jalr	-1554(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002c50:	0002f497          	auipc	s1,0x2f
    80002c54:	27848493          	addi	s1,s1,632 # 80031ec8 <proc+0x150>
    80002c58:	00043917          	auipc	s2,0x43
    80002c5c:	07090913          	addi	s2,s2,112 # 80045cc8 <bcache+0x138>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c60:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002c62:	00005997          	auipc	s3,0x5
    80002c66:	6ce98993          	addi	s3,s3,1742 # 80008330 <digits+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002c6a:	00005a97          	auipc	s5,0x5
    80002c6e:	6cea8a93          	addi	s5,s5,1742 # 80008338 <digits+0x2d0>
    printf("\n");
    80002c72:	00005a17          	auipc	s4,0x5
    80002c76:	446a0a13          	addi	s4,s4,1094 # 800080b8 <digits+0x50>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c7a:	00005b97          	auipc	s7,0x5
    80002c7e:	6f6b8b93          	addi	s7,s7,1782 # 80008370 <states.0>
    80002c82:	a00d                	j	80002ca4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002c84:	ee86a583          	lw	a1,-280(a3)
    80002c88:	8556                	mv	a0,s5
    80002c8a:	ffffe097          	auipc	ra,0xffffe
    80002c8e:	9ac080e7          	jalr	-1620(ra) # 80000636 <printf>
    printf("\n");
    80002c92:	8552                	mv	a0,s4
    80002c94:	ffffe097          	auipc	ra,0xffffe
    80002c98:	9a2080e7          	jalr	-1630(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002c9c:	4f848493          	addi	s1,s1,1272
    80002ca0:	03248163          	beq	s1,s2,80002cc2 <procdump+0x98>
    if (p->state == UNUSED)
    80002ca4:	86a6                	mv	a3,s1
    80002ca6:	ec84a783          	lw	a5,-312(s1)
    80002caa:	dbed                	beqz	a5,80002c9c <procdump+0x72>
      state = "???";
    80002cac:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002cae:	fcfb6be3          	bltu	s6,a5,80002c84 <procdump+0x5a>
    80002cb2:	1782                	slli	a5,a5,0x20
    80002cb4:	9381                	srli	a5,a5,0x20
    80002cb6:	078e                	slli	a5,a5,0x3
    80002cb8:	97de                	add	a5,a5,s7
    80002cba:	6390                	ld	a2,0(a5)
    80002cbc:	f661                	bnez	a2,80002c84 <procdump+0x5a>
      state = "???";
    80002cbe:	864e                	mv	a2,s3
    80002cc0:	b7d1                	j	80002c84 <procdump+0x5a>
  }
}
    80002cc2:	60a6                	ld	ra,72(sp)
    80002cc4:	6406                	ld	s0,64(sp)
    80002cc6:	74e2                	ld	s1,56(sp)
    80002cc8:	7942                	ld	s2,48(sp)
    80002cca:	79a2                	ld	s3,40(sp)
    80002ccc:	7a02                	ld	s4,32(sp)
    80002cce:	6ae2                	ld	s5,24(sp)
    80002cd0:	6b42                	ld	s6,16(sp)
    80002cd2:	6ba2                	ld	s7,8(sp)
    80002cd4:	6161                	addi	sp,sp,80
    80002cd6:	8082                	ret

0000000080002cd8 <swtch>:
    80002cd8:	00153023          	sd	ra,0(a0)
    80002cdc:	00253423          	sd	sp,8(a0)
    80002ce0:	e900                	sd	s0,16(a0)
    80002ce2:	ed04                	sd	s1,24(a0)
    80002ce4:	03253023          	sd	s2,32(a0)
    80002ce8:	03353423          	sd	s3,40(a0)
    80002cec:	03453823          	sd	s4,48(a0)
    80002cf0:	03553c23          	sd	s5,56(a0)
    80002cf4:	05653023          	sd	s6,64(a0)
    80002cf8:	05753423          	sd	s7,72(a0)
    80002cfc:	05853823          	sd	s8,80(a0)
    80002d00:	05953c23          	sd	s9,88(a0)
    80002d04:	07a53023          	sd	s10,96(a0)
    80002d08:	07b53423          	sd	s11,104(a0)
    80002d0c:	0005b083          	ld	ra,0(a1)
    80002d10:	0085b103          	ld	sp,8(a1)
    80002d14:	6980                	ld	s0,16(a1)
    80002d16:	6d84                	ld	s1,24(a1)
    80002d18:	0205b903          	ld	s2,32(a1)
    80002d1c:	0285b983          	ld	s3,40(a1)
    80002d20:	0305ba03          	ld	s4,48(a1)
    80002d24:	0385ba83          	ld	s5,56(a1)
    80002d28:	0405bb03          	ld	s6,64(a1)
    80002d2c:	0485bb83          	ld	s7,72(a1)
    80002d30:	0505bc03          	ld	s8,80(a1)
    80002d34:	0585bc83          	ld	s9,88(a1)
    80002d38:	0605bd03          	ld	s10,96(a1)
    80002d3c:	0685bd83          	ld	s11,104(a1)
    80002d40:	8082                	ret

0000000080002d42 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002d42:	1141                	addi	sp,sp,-16
    80002d44:	e406                	sd	ra,8(sp)
    80002d46:	e022                	sd	s0,0(sp)
    80002d48:	0800                	addi	s0,sp,16
    80002d4a:	00005597          	auipc	a1,0x5
    80002d4e:	64e58593          	addi	a1,a1,1614 # 80008398 <states.0+0x28>
    80002d52:	00043517          	auipc	a0,0x43
    80002d56:	e2650513          	addi	a0,a0,-474 # 80045b78 <tickslock>
    80002d5a:	ffffe097          	auipc	ra,0xffffe
    80002d5e:	f50080e7          	jalr	-176(ra) # 80000caa <initlock>
    80002d62:	60a2                	ld	ra,8(sp)
    80002d64:	6402                	ld	s0,0(sp)
    80002d66:	0141                	addi	sp,sp,16
    80002d68:	8082                	ret

0000000080002d6a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002d6a:	1141                	addi	sp,sp,-16
    80002d6c:	e422                	sd	s0,8(sp)
    80002d6e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002d70:	00003797          	auipc	a5,0x3
    80002d74:	64078793          	addi	a5,a5,1600 # 800063b0 <kernelvec>
    80002d78:	10579073          	csrw	stvec,a5
    80002d7c:	6422                	ld	s0,8(sp)
    80002d7e:	0141                	addi	sp,sp,16
    80002d80:	8082                	ret

0000000080002d82 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002d82:	1141                	addi	sp,sp,-16
    80002d84:	e406                	sd	ra,8(sp)
    80002d86:	e022                	sd	s0,0(sp)
    80002d88:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	352080e7          	jalr	850(ra) # 800020dc <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d92:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002d96:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d98:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002d9c:	00004617          	auipc	a2,0x4
    80002da0:	26460613          	addi	a2,a2,612 # 80007000 <_trampoline>
    80002da4:	00004697          	auipc	a3,0x4
    80002da8:	25c68693          	addi	a3,a3,604 # 80007000 <_trampoline>
    80002dac:	8e91                	sub	a3,a3,a2
    80002dae:	040007b7          	lui	a5,0x4000
    80002db2:	17fd                	addi	a5,a5,-1
    80002db4:	07b2                	slli	a5,a5,0xc
    80002db6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002db8:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002dbc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002dbe:	180026f3          	csrr	a3,satp
    80002dc2:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002dc4:	6d38                	ld	a4,88(a0)
    80002dc6:	6134                	ld	a3,64(a0)
    80002dc8:	6585                	lui	a1,0x1
    80002dca:	96ae                	add	a3,a3,a1
    80002dcc:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002dce:	6d38                	ld	a4,88(a0)
    80002dd0:	00000697          	auipc	a3,0x0
    80002dd4:	13868693          	addi	a3,a3,312 # 80002f08 <usertrap>
    80002dd8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002dda:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002ddc:	8692                	mv	a3,tp
    80002dde:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002de0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002de4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002de8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002dec:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002df0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002df2:	6f18                	ld	a4,24(a4)
    80002df4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002df8:	692c                	ld	a1,80(a0)
    80002dfa:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002dfc:	00004717          	auipc	a4,0x4
    80002e00:	29470713          	addi	a4,a4,660 # 80007090 <userret>
    80002e04:	8f11                	sub	a4,a4,a2
    80002e06:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002e08:	577d                	li	a4,-1
    80002e0a:	177e                	slli	a4,a4,0x3f
    80002e0c:	8dd9                	or	a1,a1,a4
    80002e0e:	02000537          	lui	a0,0x2000
    80002e12:	157d                	addi	a0,a0,-1
    80002e14:	0536                	slli	a0,a0,0xd
    80002e16:	9782                	jalr	a5
}
    80002e18:	60a2                	ld	ra,8(sp)
    80002e1a:	6402                	ld	s0,0(sp)
    80002e1c:	0141                	addi	sp,sp,16
    80002e1e:	8082                	ret

0000000080002e20 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002e20:	1101                	addi	sp,sp,-32
    80002e22:	ec06                	sd	ra,24(sp)
    80002e24:	e822                	sd	s0,16(sp)
    80002e26:	e426                	sd	s1,8(sp)
    80002e28:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002e2a:	00043497          	auipc	s1,0x43
    80002e2e:	d4e48493          	addi	s1,s1,-690 # 80045b78 <tickslock>
    80002e32:	8526                	mv	a0,s1
    80002e34:	ffffe097          	auipc	ra,0xffffe
    80002e38:	f06080e7          	jalr	-250(ra) # 80000d3a <acquire>
  ticks++;
    80002e3c:	00006517          	auipc	a0,0x6
    80002e40:	1e450513          	addi	a0,a0,484 # 80009020 <ticks>
    80002e44:	411c                	lw	a5,0(a0)
    80002e46:	2785                	addiw	a5,a5,1
    80002e48:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	c5a080e7          	jalr	-934(ra) # 80002aa4 <wakeup>
  release(&tickslock);
    80002e52:	8526                	mv	a0,s1
    80002e54:	ffffe097          	auipc	ra,0xffffe
    80002e58:	f9a080e7          	jalr	-102(ra) # 80000dee <release>
}
    80002e5c:	60e2                	ld	ra,24(sp)
    80002e5e:	6442                	ld	s0,16(sp)
    80002e60:	64a2                	ld	s1,8(sp)
    80002e62:	6105                	addi	sp,sp,32
    80002e64:	8082                	ret

0000000080002e66 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	e426                	sd	s1,8(sp)
    80002e6e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002e70:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002e74:	00074d63          	bltz	a4,80002e8e <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002e78:	57fd                	li	a5,-1
    80002e7a:	17fe                	slli	a5,a5,0x3f
    80002e7c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002e7e:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002e80:	06f70363          	beq	a4,a5,80002ee6 <devintr+0x80>
  }
}
    80002e84:	60e2                	ld	ra,24(sp)
    80002e86:	6442                	ld	s0,16(sp)
    80002e88:	64a2                	ld	s1,8(sp)
    80002e8a:	6105                	addi	sp,sp,32
    80002e8c:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002e8e:	0ff77793          	andi	a5,a4,255
    80002e92:	46a5                	li	a3,9
    80002e94:	fed792e3          	bne	a5,a3,80002e78 <devintr+0x12>
    int irq = plic_claim();
    80002e98:	00003097          	auipc	ra,0x3
    80002e9c:	620080e7          	jalr	1568(ra) # 800064b8 <plic_claim>
    80002ea0:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002ea2:	47a9                	li	a5,10
    80002ea4:	02f50763          	beq	a0,a5,80002ed2 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002ea8:	4785                	li	a5,1
    80002eaa:	02f50963          	beq	a0,a5,80002edc <devintr+0x76>
    return 1;
    80002eae:	4505                	li	a0,1
    } else if (irq) {
    80002eb0:	d8f1                	beqz	s1,80002e84 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002eb2:	85a6                	mv	a1,s1
    80002eb4:	00005517          	auipc	a0,0x5
    80002eb8:	4ec50513          	addi	a0,a0,1260 # 800083a0 <states.0+0x30>
    80002ebc:	ffffd097          	auipc	ra,0xffffd
    80002ec0:	77a080e7          	jalr	1914(ra) # 80000636 <printf>
      plic_complete(irq);
    80002ec4:	8526                	mv	a0,s1
    80002ec6:	00003097          	auipc	ra,0x3
    80002eca:	616080e7          	jalr	1558(ra) # 800064dc <plic_complete>
    return 1;
    80002ece:	4505                	li	a0,1
    80002ed0:	bf55                	j	80002e84 <devintr+0x1e>
      uartintr();
    80002ed2:	ffffe097          	auipc	ra,0xffffe
    80002ed6:	b68080e7          	jalr	-1176(ra) # 80000a3a <uartintr>
    80002eda:	b7ed                	j	80002ec4 <devintr+0x5e>
      virtio_disk_intr();
    80002edc:	00004097          	auipc	ra,0x4
    80002ee0:	a7a080e7          	jalr	-1414(ra) # 80006956 <virtio_disk_intr>
    80002ee4:	b7c5                	j	80002ec4 <devintr+0x5e>
    if (cpuid() == 0) {
    80002ee6:	fffff097          	auipc	ra,0xfffff
    80002eea:	1ca080e7          	jalr	458(ra) # 800020b0 <cpuid>
    80002eee:	c901                	beqz	a0,80002efe <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002ef0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002ef4:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002ef6:	14479073          	csrw	sip,a5
    return 2;
    80002efa:	4509                	li	a0,2
    80002efc:	b761                	j	80002e84 <devintr+0x1e>
      clockintr();
    80002efe:	00000097          	auipc	ra,0x0
    80002f02:	f22080e7          	jalr	-222(ra) # 80002e20 <clockintr>
    80002f06:	b7ed                	j	80002ef0 <devintr+0x8a>

0000000080002f08 <usertrap>:
void usertrap(void) {
    80002f08:	7179                	addi	sp,sp,-48
    80002f0a:	f406                	sd	ra,40(sp)
    80002f0c:	f022                	sd	s0,32(sp)
    80002f0e:	ec26                	sd	s1,24(sp)
    80002f10:	e84a                	sd	s2,16(sp)
    80002f12:	e44e                	sd	s3,8(sp)
    80002f14:	e052                	sd	s4,0(sp)
    80002f16:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f18:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002f1c:	1007f793          	andi	a5,a5,256
    80002f20:	e7a5                	bnez	a5,80002f88 <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002f22:	00003797          	auipc	a5,0x3
    80002f26:	48e78793          	addi	a5,a5,1166 # 800063b0 <kernelvec>
    80002f2a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	1ae080e7          	jalr	430(ra) # 800020dc <myproc>
    80002f36:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f38:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002f3a:	14102773          	csrr	a4,sepc
    80002f3e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002f40:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002f44:	47a1                	li	a5,8
    80002f46:	04f71f63          	bne	a4,a5,80002fa4 <usertrap+0x9c>
    if (p->killed)
    80002f4a:	591c                	lw	a5,48(a0)
    80002f4c:	e7b1                	bnez	a5,80002f98 <usertrap+0x90>
    p->trapframe->epc += 4;
    80002f4e:	6cb8                	ld	a4,88(s1)
    80002f50:	6f1c                	ld	a5,24(a4)
    80002f52:	0791                	addi	a5,a5,4
    80002f54:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f56:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002f5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002f5e:	10079073          	csrw	sstatus,a5
    syscall();
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	422080e7          	jalr	1058(ra) # 80003384 <syscall>
  if (p->killed)
    80002f6a:	589c                	lw	a5,48(s1)
    80002f6c:	1c079963          	bnez	a5,8000313e <usertrap+0x236>
  usertrapret();
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	e12080e7          	jalr	-494(ra) # 80002d82 <usertrapret>
}
    80002f78:	70a2                	ld	ra,40(sp)
    80002f7a:	7402                	ld	s0,32(sp)
    80002f7c:	64e2                	ld	s1,24(sp)
    80002f7e:	6942                	ld	s2,16(sp)
    80002f80:	69a2                	ld	s3,8(sp)
    80002f82:	6a02                	ld	s4,0(sp)
    80002f84:	6145                	addi	sp,sp,48
    80002f86:	8082                	ret
    panic("usertrap: not from user mode");
    80002f88:	00005517          	auipc	a0,0x5
    80002f8c:	43850513          	addi	a0,a0,1080 # 800083c0 <states.0+0x50>
    80002f90:	ffffd097          	auipc	ra,0xffffd
    80002f94:	654080e7          	jalr	1620(ra) # 800005e4 <panic>
      exit(-1);
    80002f98:	557d                	li	a0,-1
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	844080e7          	jalr	-1980(ra) # 800027de <exit>
    80002fa2:	b775                	j	80002f4e <usertrap+0x46>
  } else if ((which_dev = devintr()) != 0) {
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	ec2080e7          	jalr	-318(ra) # 80002e66 <devintr>
    80002fac:	89aa                	mv	s3,a0
    80002fae:	18051563          	bnez	a0,80003138 <usertrap+0x230>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002fb2:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80002fb6:	47b5                	li	a5,13
    80002fb8:	00f70763          	beq	a4,a5,80002fc6 <usertrap+0xbe>
    80002fbc:	14202773          	csrr	a4,scause
    80002fc0:	47bd                	li	a5,15
    80002fc2:	14f71163          	bne	a4,a5,80003104 <usertrap+0x1fc>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002fc6:	14302a73          	csrr	s4,stval
    if (addr > MAXVA) {
    80002fca:	4785                	li	a5,1
    80002fcc:	179a                	slli	a5,a5,0x26
    80002fce:	0347e463          	bltu	a5,s4,80002ff6 <usertrap+0xee>
    pte_t *pte = walk(p->pagetable, addr, 0);
    80002fd2:	4601                	li	a2,0
    80002fd4:	85d2                	mv	a1,s4
    80002fd6:	68a8                	ld	a0,80(s1)
    80002fd8:	ffffe097          	auipc	ra,0xffffe
    80002fdc:	146080e7          	jalr	326(ra) # 8000111e <walk>
    if (pte && (*pte & PTE_COW)) {
    80002fe0:	c509                	beqz	a0,80002fea <usertrap+0xe2>
    80002fe2:	611c                	ld	a5,0(a0)
    80002fe4:	1007f793          	andi	a5,a5,256
    80002fe8:	e395                	bnez	a5,8000300c <usertrap+0x104>
    80002fea:	17848793          	addi	a5,s1,376
void usertrap(void) {
    80002fee:	894e                	mv	s2,s3
      if ((void *)addr >= p->vma[i].start &&
    80002ff0:	85d2                	mv	a1,s4
    for (int i = 0; i < MAX_VMA; i++) {
    80002ff2:	46c1                	li	a3,16
    80002ff4:	a07d                	j	800030a2 <usertrap+0x19a>
      printf("memory overflow");
    80002ff6:	00005517          	auipc	a0,0x5
    80002ffa:	3ea50513          	addi	a0,a0,1002 # 800083e0 <states.0+0x70>
    80002ffe:	ffffd097          	auipc	ra,0xffffd
    80003002:	638080e7          	jalr	1592(ra) # 80000636 <printf>
      p->killed = 1;
    80003006:	4785                	li	a5,1
    80003008:	d89c                	sw	a5,48(s1)
    8000300a:	b7e1                	j	80002fd2 <usertrap+0xca>
      int res = do_cow(p->pagetable, addr);
    8000300c:	85d2                	mv	a1,s4
    8000300e:	68a8                	ld	a0,80(s1)
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	8f0080e7          	jalr	-1808(ra) # 80001900 <do_cow>
      if (res != 0) {
    80003018:	d929                	beqz	a0,80002f6a <usertrap+0x62>
        printf("cow failed");
    8000301a:	00005517          	auipc	a0,0x5
    8000301e:	3d650513          	addi	a0,a0,982 # 800083f0 <states.0+0x80>
    80003022:	ffffd097          	auipc	ra,0xffffd
    80003026:	614080e7          	jalr	1556(ra) # 80000636 <printf>
        p->killed = 1;
    8000302a:	4785                	li	a5,1
    8000302c:	d89c                	sw	a5,48(s1)
    8000302e:	a82d                	j	80003068 <usertrap+0x160>
          printf("original permission %p\n", PTE_FLAGS(*pte));
    80003030:	3ff5f593          	andi	a1,a1,1023
    80003034:	00005517          	auipc	a0,0x5
    80003038:	3cc50513          	addi	a0,a0,972 # 80008400 <states.0+0x90>
    8000303c:	ffffd097          	auipc	ra,0xffffd
    80003040:	5fa080e7          	jalr	1530(ra) # 80000636 <printf>
          printf("map exists");
    80003044:	00005517          	auipc	a0,0x5
    80003048:	3d450513          	addi	a0,a0,980 # 80008418 <states.0+0xa8>
    8000304c:	ffffd097          	auipc	ra,0xffffd
    80003050:	5ea080e7          	jalr	1514(ra) # 80000636 <printf>
      printf("memory access  permission denied");
    80003054:	00005517          	auipc	a0,0x5
    80003058:	3fc50513          	addi	a0,a0,1020 # 80008450 <states.0+0xe0>
    8000305c:	ffffd097          	auipc	ra,0xffffd
    80003060:	5da080e7          	jalr	1498(ra) # 80000636 <printf>
      p->killed = 1;
    80003064:	4785                	li	a5,1
    80003066:	d89c                	sw	a5,48(s1)
    exit(-1);
    80003068:	557d                	li	a0,-1
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	774080e7          	jalr	1908(ra) # 800027de <exit>
  if (which_dev == 2)
    80003072:	4789                	li	a5,2
    80003074:	eef99ee3          	bne	s3,a5,80002f70 <usertrap+0x68>
    yield();
    80003078:	00000097          	auipc	ra,0x0
    8000307c:	870080e7          	jalr	-1936(ra) # 800028e8 <yield>
    80003080:	bdc5                	j	80002f70 <usertrap+0x68>
          printf("run out of memory\n");
    80003082:	00005517          	auipc	a0,0x5
    80003086:	3a650513          	addi	a0,a0,934 # 80008428 <states.0+0xb8>
    8000308a:	ffffd097          	auipc	ra,0xffffd
    8000308e:	5ac080e7          	jalr	1452(ra) # 80000636 <printf>
          p->killed = 1;
    80003092:	4785                	li	a5,1
    80003094:	d89c                	sw	a5,48(s1)
    80003096:	bfc9                	j	80003068 <usertrap+0x160>
    for (int i = 0; i < MAX_VMA; i++) {
    80003098:	2905                	addiw	s2,s2,1
    8000309a:	03878793          	addi	a5,a5,56
    8000309e:	fad90be3          	beq	s2,a3,80003054 <usertrap+0x14c>
      if ((void *)addr >= p->vma[i].start &&
    800030a2:	6398                	ld	a4,0(a5)
    800030a4:	feea6ae3          	bltu	s4,a4,80003098 <usertrap+0x190>
          (void *)addr < p->vma[i].start + p->vma[i].length) {
    800030a8:	6b90                	ld	a2,16(a5)
    800030aa:	9732                	add	a4,a4,a2
      if ((void *)addr >= p->vma[i].start &&
    800030ac:	fee5f6e3          	bgeu	a1,a4,80003098 <usertrap+0x190>
        pte_t *pte = walk(p->pagetable, addr, 0);
    800030b0:	4601                	li	a2,0
    800030b2:	85d2                	mv	a1,s4
    800030b4:	68a8                	ld	a0,80(s1)
    800030b6:	ffffe097          	auipc	ra,0xffffe
    800030ba:	068080e7          	jalr	104(ra) # 8000111e <walk>
        if (pte && (*pte & PTE_V)) {
    800030be:	c509                	beqz	a0,800030c8 <usertrap+0x1c0>
    800030c0:	610c                	ld	a1,0(a0)
    800030c2:	0015f793          	andi	a5,a1,1
    800030c6:	f7ad                	bnez	a5,80003030 <usertrap+0x128>
        if ((res = do_vma((void *)addr, &p->vma[i])) == -1) {
    800030c8:	00391593          	slli	a1,s2,0x3
    800030cc:	412585b3          	sub	a1,a1,s2
    800030d0:	058e                	slli	a1,a1,0x3
    800030d2:	17858593          	addi	a1,a1,376 # 1178 <_entry-0x7fffee88>
    800030d6:	95a6                	add	a1,a1,s1
    800030d8:	8552                	mv	a0,s4
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	a8c080e7          	jalr	-1396(ra) # 80001b66 <do_vma>
    800030e2:	57fd                	li	a5,-1
    800030e4:	f8f50fe3          	beq	a0,a5,80003082 <usertrap+0x17a>
        } else if (res == -2) {
    800030e8:	57f9                	li	a5,-2
    800030ea:	e8f510e3          	bne	a0,a5,80002f6a <usertrap+0x62>
          printf("map failed");
    800030ee:	00005517          	auipc	a0,0x5
    800030f2:	35250513          	addi	a0,a0,850 # 80008440 <states.0+0xd0>
    800030f6:	ffffd097          	auipc	ra,0xffffd
    800030fa:	540080e7          	jalr	1344(ra) # 80000636 <printf>
          p->killed = 1;
    800030fe:	4785                	li	a5,1
    80003100:	d89c                	sw	a5,48(s1)
    80003102:	b79d                	j	80003068 <usertrap+0x160>
  asm volatile("csrr %0, scause" : "=r"(x));
    80003104:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003108:	5c90                	lw	a2,56(s1)
    8000310a:	00005517          	auipc	a0,0x5
    8000310e:	36e50513          	addi	a0,a0,878 # 80008478 <states.0+0x108>
    80003112:	ffffd097          	auipc	ra,0xffffd
    80003116:	524080e7          	jalr	1316(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000311a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000311e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003122:	00005517          	auipc	a0,0x5
    80003126:	38650513          	addi	a0,a0,902 # 800084a8 <states.0+0x138>
    8000312a:	ffffd097          	auipc	ra,0xffffd
    8000312e:	50c080e7          	jalr	1292(ra) # 80000636 <printf>
    p->killed = 1;
    80003132:	4785                	li	a5,1
    80003134:	d89c                	sw	a5,48(s1)
    80003136:	bf0d                	j	80003068 <usertrap+0x160>
  if (p->killed)
    80003138:	589c                	lw	a5,48(s1)
    8000313a:	df85                	beqz	a5,80003072 <usertrap+0x16a>
    8000313c:	b735                	j	80003068 <usertrap+0x160>
    8000313e:	4981                	li	s3,0
    80003140:	b725                	j	80003068 <usertrap+0x160>

0000000080003142 <kerneltrap>:
void kerneltrap() {
    80003142:	7179                	addi	sp,sp,-48
    80003144:	f406                	sd	ra,40(sp)
    80003146:	f022                	sd	s0,32(sp)
    80003148:	ec26                	sd	s1,24(sp)
    8000314a:	e84a                	sd	s2,16(sp)
    8000314c:	e44e                	sd	s3,8(sp)
    8000314e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003150:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003154:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80003158:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    8000315c:	1004f793          	andi	a5,s1,256
    80003160:	cb85                	beqz	a5,80003190 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003162:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003166:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80003168:	ef85                	bnez	a5,800031a0 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	cfc080e7          	jalr	-772(ra) # 80002e66 <devintr>
    80003172:	cd1d                	beqz	a0,800031b0 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003174:	4789                	li	a5,2
    80003176:	06f50a63          	beq	a0,a5,800031ea <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000317a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000317e:	10049073          	csrw	sstatus,s1
}
    80003182:	70a2                	ld	ra,40(sp)
    80003184:	7402                	ld	s0,32(sp)
    80003186:	64e2                	ld	s1,24(sp)
    80003188:	6942                	ld	s2,16(sp)
    8000318a:	69a2                	ld	s3,8(sp)
    8000318c:	6145                	addi	sp,sp,48
    8000318e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003190:	00005517          	auipc	a0,0x5
    80003194:	33850513          	addi	a0,a0,824 # 800084c8 <states.0+0x158>
    80003198:	ffffd097          	auipc	ra,0xffffd
    8000319c:	44c080e7          	jalr	1100(ra) # 800005e4 <panic>
    panic("kerneltrap: interrupts enabled");
    800031a0:	00005517          	auipc	a0,0x5
    800031a4:	35050513          	addi	a0,a0,848 # 800084f0 <states.0+0x180>
    800031a8:	ffffd097          	auipc	ra,0xffffd
    800031ac:	43c080e7          	jalr	1084(ra) # 800005e4 <panic>
    printf("scause %p\n", scause);
    800031b0:	85ce                	mv	a1,s3
    800031b2:	00005517          	auipc	a0,0x5
    800031b6:	35e50513          	addi	a0,a0,862 # 80008510 <states.0+0x1a0>
    800031ba:	ffffd097          	auipc	ra,0xffffd
    800031be:	47c080e7          	jalr	1148(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800031c2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800031c6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800031ca:	00005517          	auipc	a0,0x5
    800031ce:	35650513          	addi	a0,a0,854 # 80008520 <states.0+0x1b0>
    800031d2:	ffffd097          	auipc	ra,0xffffd
    800031d6:	464080e7          	jalr	1124(ra) # 80000636 <printf>
    panic("kerneltrap");
    800031da:	00005517          	auipc	a0,0x5
    800031de:	35e50513          	addi	a0,a0,862 # 80008538 <states.0+0x1c8>
    800031e2:	ffffd097          	auipc	ra,0xffffd
    800031e6:	402080e7          	jalr	1026(ra) # 800005e4 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	ef2080e7          	jalr	-270(ra) # 800020dc <myproc>
    800031f2:	d541                	beqz	a0,8000317a <kerneltrap+0x38>
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	ee8080e7          	jalr	-280(ra) # 800020dc <myproc>
    800031fc:	4d18                	lw	a4,24(a0)
    800031fe:	478d                	li	a5,3
    80003200:	f6f71de3          	bne	a4,a5,8000317a <kerneltrap+0x38>
    yield();
    80003204:	fffff097          	auipc	ra,0xfffff
    80003208:	6e4080e7          	jalr	1764(ra) # 800028e8 <yield>
    8000320c:	b7bd                	j	8000317a <kerneltrap+0x38>

000000008000320e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000320e:	1101                	addi	sp,sp,-32
    80003210:	ec06                	sd	ra,24(sp)
    80003212:	e822                	sd	s0,16(sp)
    80003214:	e426                	sd	s1,8(sp)
    80003216:	1000                	addi	s0,sp,32
    80003218:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000321a:	fffff097          	auipc	ra,0xfffff
    8000321e:	ec2080e7          	jalr	-318(ra) # 800020dc <myproc>
  switch (n) {
    80003222:	4795                	li	a5,5
    80003224:	0497e163          	bltu	a5,s1,80003266 <argraw+0x58>
    80003228:	048a                	slli	s1,s1,0x2
    8000322a:	00005717          	auipc	a4,0x5
    8000322e:	34670713          	addi	a4,a4,838 # 80008570 <states.0+0x200>
    80003232:	94ba                	add	s1,s1,a4
    80003234:	409c                	lw	a5,0(s1)
    80003236:	97ba                	add	a5,a5,a4
    80003238:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000323a:	6d3c                	ld	a5,88(a0)
    8000323c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000323e:	60e2                	ld	ra,24(sp)
    80003240:	6442                	ld	s0,16(sp)
    80003242:	64a2                	ld	s1,8(sp)
    80003244:	6105                	addi	sp,sp,32
    80003246:	8082                	ret
    return p->trapframe->a1;
    80003248:	6d3c                	ld	a5,88(a0)
    8000324a:	7fa8                	ld	a0,120(a5)
    8000324c:	bfcd                	j	8000323e <argraw+0x30>
    return p->trapframe->a2;
    8000324e:	6d3c                	ld	a5,88(a0)
    80003250:	63c8                	ld	a0,128(a5)
    80003252:	b7f5                	j	8000323e <argraw+0x30>
    return p->trapframe->a3;
    80003254:	6d3c                	ld	a5,88(a0)
    80003256:	67c8                	ld	a0,136(a5)
    80003258:	b7dd                	j	8000323e <argraw+0x30>
    return p->trapframe->a4;
    8000325a:	6d3c                	ld	a5,88(a0)
    8000325c:	6bc8                	ld	a0,144(a5)
    8000325e:	b7c5                	j	8000323e <argraw+0x30>
    return p->trapframe->a5;
    80003260:	6d3c                	ld	a5,88(a0)
    80003262:	6fc8                	ld	a0,152(a5)
    80003264:	bfe9                	j	8000323e <argraw+0x30>
  panic("argraw");
    80003266:	00005517          	auipc	a0,0x5
    8000326a:	2e250513          	addi	a0,a0,738 # 80008548 <states.0+0x1d8>
    8000326e:	ffffd097          	auipc	ra,0xffffd
    80003272:	376080e7          	jalr	886(ra) # 800005e4 <panic>

0000000080003276 <fetchaddr>:
{
    80003276:	1101                	addi	sp,sp,-32
    80003278:	ec06                	sd	ra,24(sp)
    8000327a:	e822                	sd	s0,16(sp)
    8000327c:	e426                	sd	s1,8(sp)
    8000327e:	e04a                	sd	s2,0(sp)
    80003280:	1000                	addi	s0,sp,32
    80003282:	84aa                	mv	s1,a0
    80003284:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003286:	fffff097          	auipc	ra,0xfffff
    8000328a:	e56080e7          	jalr	-426(ra) # 800020dc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000328e:	653c                	ld	a5,72(a0)
    80003290:	02f4f863          	bgeu	s1,a5,800032c0 <fetchaddr+0x4a>
    80003294:	00848713          	addi	a4,s1,8
    80003298:	02e7e663          	bltu	a5,a4,800032c4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000329c:	46a1                	li	a3,8
    8000329e:	8626                	mv	a2,s1
    800032a0:	85ca                	mv	a1,s2
    800032a2:	6928                	ld	a0,80(a0)
    800032a4:	ffffe097          	auipc	ra,0xffffe
    800032a8:	51a080e7          	jalr	1306(ra) # 800017be <copyin>
    800032ac:	00a03533          	snez	a0,a0
    800032b0:	40a00533          	neg	a0,a0
}
    800032b4:	60e2                	ld	ra,24(sp)
    800032b6:	6442                	ld	s0,16(sp)
    800032b8:	64a2                	ld	s1,8(sp)
    800032ba:	6902                	ld	s2,0(sp)
    800032bc:	6105                	addi	sp,sp,32
    800032be:	8082                	ret
    return -1;
    800032c0:	557d                	li	a0,-1
    800032c2:	bfcd                	j	800032b4 <fetchaddr+0x3e>
    800032c4:	557d                	li	a0,-1
    800032c6:	b7fd                	j	800032b4 <fetchaddr+0x3e>

00000000800032c8 <fetchstr>:
{
    800032c8:	7179                	addi	sp,sp,-48
    800032ca:	f406                	sd	ra,40(sp)
    800032cc:	f022                	sd	s0,32(sp)
    800032ce:	ec26                	sd	s1,24(sp)
    800032d0:	e84a                	sd	s2,16(sp)
    800032d2:	e44e                	sd	s3,8(sp)
    800032d4:	1800                	addi	s0,sp,48
    800032d6:	892a                	mv	s2,a0
    800032d8:	84ae                	mv	s1,a1
    800032da:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800032dc:	fffff097          	auipc	ra,0xfffff
    800032e0:	e00080e7          	jalr	-512(ra) # 800020dc <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800032e4:	86ce                	mv	a3,s3
    800032e6:	864a                	mv	a2,s2
    800032e8:	85a6                	mv	a1,s1
    800032ea:	6928                	ld	a0,80(a0)
    800032ec:	ffffe097          	auipc	ra,0xffffe
    800032f0:	560080e7          	jalr	1376(ra) # 8000184c <copyinstr>
  if(err < 0)
    800032f4:	00054763          	bltz	a0,80003302 <fetchstr+0x3a>
  return strlen(buf);
    800032f8:	8526                	mv	a0,s1
    800032fa:	ffffe097          	auipc	ra,0xffffe
    800032fe:	cc0080e7          	jalr	-832(ra) # 80000fba <strlen>
}
    80003302:	70a2                	ld	ra,40(sp)
    80003304:	7402                	ld	s0,32(sp)
    80003306:	64e2                	ld	s1,24(sp)
    80003308:	6942                	ld	s2,16(sp)
    8000330a:	69a2                	ld	s3,8(sp)
    8000330c:	6145                	addi	sp,sp,48
    8000330e:	8082                	ret

0000000080003310 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003310:	1101                	addi	sp,sp,-32
    80003312:	ec06                	sd	ra,24(sp)
    80003314:	e822                	sd	s0,16(sp)
    80003316:	e426                	sd	s1,8(sp)
    80003318:	1000                	addi	s0,sp,32
    8000331a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	ef2080e7          	jalr	-270(ra) # 8000320e <argraw>
    80003324:	c088                	sw	a0,0(s1)
  return 0;
}
    80003326:	4501                	li	a0,0
    80003328:	60e2                	ld	ra,24(sp)
    8000332a:	6442                	ld	s0,16(sp)
    8000332c:	64a2                	ld	s1,8(sp)
    8000332e:	6105                	addi	sp,sp,32
    80003330:	8082                	ret

0000000080003332 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	1000                	addi	s0,sp,32
    8000333c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000333e:	00000097          	auipc	ra,0x0
    80003342:	ed0080e7          	jalr	-304(ra) # 8000320e <argraw>
    80003346:	e088                	sd	a0,0(s1)
  return 0;
}
    80003348:	4501                	li	a0,0
    8000334a:	60e2                	ld	ra,24(sp)
    8000334c:	6442                	ld	s0,16(sp)
    8000334e:	64a2                	ld	s1,8(sp)
    80003350:	6105                	addi	sp,sp,32
    80003352:	8082                	ret

0000000080003354 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003354:	1101                	addi	sp,sp,-32
    80003356:	ec06                	sd	ra,24(sp)
    80003358:	e822                	sd	s0,16(sp)
    8000335a:	e426                	sd	s1,8(sp)
    8000335c:	e04a                	sd	s2,0(sp)
    8000335e:	1000                	addi	s0,sp,32
    80003360:	84ae                	mv	s1,a1
    80003362:	8932                	mv	s2,a2
  *ip = argraw(n);
    80003364:	00000097          	auipc	ra,0x0
    80003368:	eaa080e7          	jalr	-342(ra) # 8000320e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000336c:	864a                	mv	a2,s2
    8000336e:	85a6                	mv	a1,s1
    80003370:	00000097          	auipc	ra,0x0
    80003374:	f58080e7          	jalr	-168(ra) # 800032c8 <fetchstr>
}
    80003378:	60e2                	ld	ra,24(sp)
    8000337a:	6442                	ld	s0,16(sp)
    8000337c:	64a2                	ld	s1,8(sp)
    8000337e:	6902                	ld	s2,0(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003384:	1101                	addi	sp,sp,-32
    80003386:	ec06                	sd	ra,24(sp)
    80003388:	e822                	sd	s0,16(sp)
    8000338a:	e426                	sd	s1,8(sp)
    8000338c:	e04a                	sd	s2,0(sp)
    8000338e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	d4c080e7          	jalr	-692(ra) # 800020dc <myproc>
    80003398:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000339a:	05853903          	ld	s2,88(a0)
    8000339e:	0a893783          	ld	a5,168(s2)
    800033a2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800033a6:	37fd                	addiw	a5,a5,-1
    800033a8:	4751                	li	a4,20
    800033aa:	00f76f63          	bltu	a4,a5,800033c8 <syscall+0x44>
    800033ae:	00369713          	slli	a4,a3,0x3
    800033b2:	00005797          	auipc	a5,0x5
    800033b6:	1d678793          	addi	a5,a5,470 # 80008588 <syscalls>
    800033ba:	97ba                	add	a5,a5,a4
    800033bc:	639c                	ld	a5,0(a5)
    800033be:	c789                	beqz	a5,800033c8 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800033c0:	9782                	jalr	a5
    800033c2:	06a93823          	sd	a0,112(s2)
    800033c6:	a839                	j	800033e4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800033c8:	15048613          	addi	a2,s1,336
    800033cc:	5c8c                	lw	a1,56(s1)
    800033ce:	00005517          	auipc	a0,0x5
    800033d2:	18250513          	addi	a0,a0,386 # 80008550 <states.0+0x1e0>
    800033d6:	ffffd097          	auipc	ra,0xffffd
    800033da:	260080e7          	jalr	608(ra) # 80000636 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800033de:	6cbc                	ld	a5,88(s1)
    800033e0:	577d                	li	a4,-1
    800033e2:	fbb8                	sd	a4,112(a5)
  }
}
    800033e4:	60e2                	ld	ra,24(sp)
    800033e6:	6442                	ld	s0,16(sp)
    800033e8:	64a2                	ld	s1,8(sp)
    800033ea:	6902                	ld	s2,0(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret

00000000800033f0 <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    800033f0:	1101                	addi	sp,sp,-32
    800033f2:	ec06                	sd	ra,24(sp)
    800033f4:	e822                	sd	s0,16(sp)
    800033f6:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    800033f8:	fec40593          	addi	a1,s0,-20
    800033fc:	4501                	li	a0,0
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	f12080e7          	jalr	-238(ra) # 80003310 <argint>
    return -1;
    80003406:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003408:	00054963          	bltz	a0,8000341a <sys_exit+0x2a>
  exit(n);
    8000340c:	fec42503          	lw	a0,-20(s0)
    80003410:	fffff097          	auipc	ra,0xfffff
    80003414:	3ce080e7          	jalr	974(ra) # 800027de <exit>
  return 0; // not reached
    80003418:	4781                	li	a5,0
}
    8000341a:	853e                	mv	a0,a5
    8000341c:	60e2                	ld	ra,24(sp)
    8000341e:	6442                	ld	s0,16(sp)
    80003420:	6105                	addi	sp,sp,32
    80003422:	8082                	ret

0000000080003424 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80003424:	1141                	addi	sp,sp,-16
    80003426:	e406                	sd	ra,8(sp)
    80003428:	e022                	sd	s0,0(sp)
    8000342a:	0800                	addi	s0,sp,16
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	cb0080e7          	jalr	-848(ra) # 800020dc <myproc>
    80003434:	5d08                	lw	a0,56(a0)
    80003436:	60a2                	ld	ra,8(sp)
    80003438:	6402                	ld	s0,0(sp)
    8000343a:	0141                	addi	sp,sp,16
    8000343c:	8082                	ret

000000008000343e <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    8000343e:	1141                	addi	sp,sp,-16
    80003440:	e406                	sd	ra,8(sp)
    80003442:	e022                	sd	s0,0(sp)
    80003444:	0800                	addi	s0,sp,16
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	08a080e7          	jalr	138(ra) # 800024d0 <fork>
    8000344e:	60a2                	ld	ra,8(sp)
    80003450:	6402                	ld	s0,0(sp)
    80003452:	0141                	addi	sp,sp,16
    80003454:	8082                	ret

0000000080003456 <sys_wait>:

uint64 sys_wait(void) {
    80003456:	1101                	addi	sp,sp,-32
    80003458:	ec06                	sd	ra,24(sp)
    8000345a:	e822                	sd	s0,16(sp)
    8000345c:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    8000345e:	fe840593          	addi	a1,s0,-24
    80003462:	4501                	li	a0,0
    80003464:	00000097          	auipc	ra,0x0
    80003468:	ece080e7          	jalr	-306(ra) # 80003332 <argaddr>
    8000346c:	87aa                	mv	a5,a0
    return -1;
    8000346e:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    80003470:	0007c863          	bltz	a5,80003480 <sys_wait+0x2a>
  return wait(p);
    80003474:	fe843503          	ld	a0,-24(s0)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	52a080e7          	jalr	1322(ra) # 800029a2 <wait>
}
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	6105                	addi	sp,sp,32
    80003486:	8082                	ret

0000000080003488 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003488:	7179                	addi	sp,sp,-48
    8000348a:	f406                	sd	ra,40(sp)
    8000348c:	f022                	sd	s0,32(sp)
    8000348e:	ec26                	sd	s1,24(sp)
    80003490:	e84a                	sd	s2,16(sp)
    80003492:	1800                	addi	s0,sp,48
  u64 addr;
  int n;

  if (argint(0, &n) < 0)
    80003494:	fdc40593          	addi	a1,s0,-36
    80003498:	4501                	li	a0,0
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	e76080e7          	jalr	-394(ra) # 80003310 <argint>
    return -1;
    800034a2:	597d                	li	s2,-1
  if (argint(0, &n) < 0)
    800034a4:	02054963          	bltz	a0,800034d6 <sys_sbrk+0x4e>
  struct proc *p = myproc();
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	c34080e7          	jalr	-972(ra) # 800020dc <myproc>
    800034b0:	84aa                	mv	s1,a0
  addr = (u64)p->mem_layout.heap_start;
    800034b2:	16853903          	ld	s2,360(a0)
  if (addr + n >= p->mem_layout.heap_size) {
    800034b6:	fdc42783          	lw	a5,-36(s0)
    800034ba:	97ca                	add	a5,a5,s2
    800034bc:	17053703          	ld	a4,368(a0)
    800034c0:	02e7f263          	bgeu	a5,a4,800034e4 <sys_sbrk+0x5c>
    p->killed = 1;
    printf("user heap momry overflow");
    exit(-1);
  }
  p->mem_layout.heap_start += n;
    800034c4:	fdc42783          	lw	a5,-36(s0)
    800034c8:	1684b603          	ld	a2,360(s1)
    800034cc:	963e                	add	a2,a2,a5
    800034ce:	16c4b423          	sd	a2,360(s1)
  if (n < 0) {
    800034d2:	0207c963          	bltz	a5,80003504 <sys_sbrk+0x7c>
    uvmdealloc(p->pagetable, addr, (u64)p->mem_layout.heap_start);
  }
  return addr;
}
    800034d6:	854a                	mv	a0,s2
    800034d8:	70a2                	ld	ra,40(sp)
    800034da:	7402                	ld	s0,32(sp)
    800034dc:	64e2                	ld	s1,24(sp)
    800034de:	6942                	ld	s2,16(sp)
    800034e0:	6145                	addi	sp,sp,48
    800034e2:	8082                	ret
    p->killed = 1;
    800034e4:	4785                	li	a5,1
    800034e6:	d91c                	sw	a5,48(a0)
    printf("user heap momry overflow");
    800034e8:	00005517          	auipc	a0,0x5
    800034ec:	15050513          	addi	a0,a0,336 # 80008638 <syscalls+0xb0>
    800034f0:	ffffd097          	auipc	ra,0xffffd
    800034f4:	146080e7          	jalr	326(ra) # 80000636 <printf>
    exit(-1);
    800034f8:	557d                	li	a0,-1
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	2e4080e7          	jalr	740(ra) # 800027de <exit>
    80003502:	b7c9                	j	800034c4 <sys_sbrk+0x3c>
    uvmdealloc(p->pagetable, addr, (u64)p->mem_layout.heap_start);
    80003504:	85ca                	mv	a1,s2
    80003506:	68a8                	ld	a0,80(s1)
    80003508:	ffffe097          	auipc	ra,0xffffe
    8000350c:	030080e7          	jalr	48(ra) # 80001538 <uvmdealloc>
    80003510:	b7d9                	j	800034d6 <sys_sbrk+0x4e>

0000000080003512 <sys_sleep>:

uint64 sys_sleep(void) {
    80003512:	7139                	addi	sp,sp,-64
    80003514:	fc06                	sd	ra,56(sp)
    80003516:	f822                	sd	s0,48(sp)
    80003518:	f426                	sd	s1,40(sp)
    8000351a:	f04a                	sd	s2,32(sp)
    8000351c:	ec4e                	sd	s3,24(sp)
    8000351e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80003520:	fcc40593          	addi	a1,s0,-52
    80003524:	4501                	li	a0,0
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	dea080e7          	jalr	-534(ra) # 80003310 <argint>
    return -1;
    8000352e:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003530:	06054563          	bltz	a0,8000359a <sys_sleep+0x88>
  acquire(&tickslock);
    80003534:	00042517          	auipc	a0,0x42
    80003538:	64450513          	addi	a0,a0,1604 # 80045b78 <tickslock>
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	7fe080e7          	jalr	2046(ra) # 80000d3a <acquire>
  ticks0 = ticks;
    80003544:	00006917          	auipc	s2,0x6
    80003548:	adc92903          	lw	s2,-1316(s2) # 80009020 <ticks>
  while (ticks - ticks0 < n) {
    8000354c:	fcc42783          	lw	a5,-52(s0)
    80003550:	cf85                	beqz	a5,80003588 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003552:	00042997          	auipc	s3,0x42
    80003556:	62698993          	addi	s3,s3,1574 # 80045b78 <tickslock>
    8000355a:	00006497          	auipc	s1,0x6
    8000355e:	ac648493          	addi	s1,s1,-1338 # 80009020 <ticks>
    if (myproc()->killed) {
    80003562:	fffff097          	auipc	ra,0xfffff
    80003566:	b7a080e7          	jalr	-1158(ra) # 800020dc <myproc>
    8000356a:	591c                	lw	a5,48(a0)
    8000356c:	ef9d                	bnez	a5,800035aa <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000356e:	85ce                	mv	a1,s3
    80003570:	8526                	mv	a0,s1
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	3b2080e7          	jalr	946(ra) # 80002924 <sleep>
  while (ticks - ticks0 < n) {
    8000357a:	409c                	lw	a5,0(s1)
    8000357c:	412787bb          	subw	a5,a5,s2
    80003580:	fcc42703          	lw	a4,-52(s0)
    80003584:	fce7efe3          	bltu	a5,a4,80003562 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003588:	00042517          	auipc	a0,0x42
    8000358c:	5f050513          	addi	a0,a0,1520 # 80045b78 <tickslock>
    80003590:	ffffe097          	auipc	ra,0xffffe
    80003594:	85e080e7          	jalr	-1954(ra) # 80000dee <release>
  return 0;
    80003598:	4781                	li	a5,0
}
    8000359a:	853e                	mv	a0,a5
    8000359c:	70e2                	ld	ra,56(sp)
    8000359e:	7442                	ld	s0,48(sp)
    800035a0:	74a2                	ld	s1,40(sp)
    800035a2:	7902                	ld	s2,32(sp)
    800035a4:	69e2                	ld	s3,24(sp)
    800035a6:	6121                	addi	sp,sp,64
    800035a8:	8082                	ret
      release(&tickslock);
    800035aa:	00042517          	auipc	a0,0x42
    800035ae:	5ce50513          	addi	a0,a0,1486 # 80045b78 <tickslock>
    800035b2:	ffffe097          	auipc	ra,0xffffe
    800035b6:	83c080e7          	jalr	-1988(ra) # 80000dee <release>
      return -1;
    800035ba:	57fd                	li	a5,-1
    800035bc:	bff9                	j	8000359a <sys_sleep+0x88>

00000000800035be <sys_kill>:

uint64 sys_kill(void) {
    800035be:	1101                	addi	sp,sp,-32
    800035c0:	ec06                	sd	ra,24(sp)
    800035c2:	e822                	sd	s0,16(sp)
    800035c4:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800035c6:	fec40593          	addi	a1,s0,-20
    800035ca:	4501                	li	a0,0
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	d44080e7          	jalr	-700(ra) # 80003310 <argint>
    800035d4:	87aa                	mv	a5,a0
    return -1;
    800035d6:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800035d8:	0007c863          	bltz	a5,800035e8 <sys_kill+0x2a>
  return kill(pid);
    800035dc:	fec42503          	lw	a0,-20(s0)
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	52e080e7          	jalr	1326(ra) # 80002b0e <kill>
}
    800035e8:	60e2                	ld	ra,24(sp)
    800035ea:	6442                	ld	s0,16(sp)
    800035ec:	6105                	addi	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800035fa:	00042517          	auipc	a0,0x42
    800035fe:	57e50513          	addi	a0,a0,1406 # 80045b78 <tickslock>
    80003602:	ffffd097          	auipc	ra,0xffffd
    80003606:	738080e7          	jalr	1848(ra) # 80000d3a <acquire>
  xticks = ticks;
    8000360a:	00006497          	auipc	s1,0x6
    8000360e:	a164a483          	lw	s1,-1514(s1) # 80009020 <ticks>
  release(&tickslock);
    80003612:	00042517          	auipc	a0,0x42
    80003616:	56650513          	addi	a0,a0,1382 # 80045b78 <tickslock>
    8000361a:	ffffd097          	auipc	ra,0xffffd
    8000361e:	7d4080e7          	jalr	2004(ra) # 80000dee <release>
  return xticks;
}
    80003622:	02049513          	slli	a0,s1,0x20
    80003626:	9101                	srli	a0,a0,0x20
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6105                	addi	sp,sp,32
    80003630:	8082                	ret

0000000080003632 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003632:	7179                	addi	sp,sp,-48
    80003634:	f406                	sd	ra,40(sp)
    80003636:	f022                	sd	s0,32(sp)
    80003638:	ec26                	sd	s1,24(sp)
    8000363a:	e84a                	sd	s2,16(sp)
    8000363c:	e44e                	sd	s3,8(sp)
    8000363e:	e052                	sd	s4,0(sp)
    80003640:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003642:	00005597          	auipc	a1,0x5
    80003646:	01658593          	addi	a1,a1,22 # 80008658 <syscalls+0xd0>
    8000364a:	00042517          	auipc	a0,0x42
    8000364e:	54650513          	addi	a0,a0,1350 # 80045b90 <bcache>
    80003652:	ffffd097          	auipc	ra,0xffffd
    80003656:	658080e7          	jalr	1624(ra) # 80000caa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000365a:	0004a797          	auipc	a5,0x4a
    8000365e:	53678793          	addi	a5,a5,1334 # 8004db90 <bcache+0x8000>
    80003662:	0004a717          	auipc	a4,0x4a
    80003666:	79670713          	addi	a4,a4,1942 # 8004ddf8 <bcache+0x8268>
    8000366a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000366e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003672:	00042497          	auipc	s1,0x42
    80003676:	53648493          	addi	s1,s1,1334 # 80045ba8 <bcache+0x18>
    b->next = bcache.head.next;
    8000367a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000367c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000367e:	00005a17          	auipc	s4,0x5
    80003682:	fe2a0a13          	addi	s4,s4,-30 # 80008660 <syscalls+0xd8>
    b->next = bcache.head.next;
    80003686:	2b893783          	ld	a5,696(s2)
    8000368a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000368c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003690:	85d2                	mv	a1,s4
    80003692:	01048513          	addi	a0,s1,16
    80003696:	00001097          	auipc	ra,0x1
    8000369a:	4b0080e7          	jalr	1200(ra) # 80004b46 <initsleeplock>
    bcache.head.next->prev = b;
    8000369e:	2b893783          	ld	a5,696(s2)
    800036a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800036a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800036a8:	45848493          	addi	s1,s1,1112
    800036ac:	fd349de3          	bne	s1,s3,80003686 <binit+0x54>
  }
}
    800036b0:	70a2                	ld	ra,40(sp)
    800036b2:	7402                	ld	s0,32(sp)
    800036b4:	64e2                	ld	s1,24(sp)
    800036b6:	6942                	ld	s2,16(sp)
    800036b8:	69a2                	ld	s3,8(sp)
    800036ba:	6a02                	ld	s4,0(sp)
    800036bc:	6145                	addi	sp,sp,48
    800036be:	8082                	ret

00000000800036c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800036c0:	7179                	addi	sp,sp,-48
    800036c2:	f406                	sd	ra,40(sp)
    800036c4:	f022                	sd	s0,32(sp)
    800036c6:	ec26                	sd	s1,24(sp)
    800036c8:	e84a                	sd	s2,16(sp)
    800036ca:	e44e                	sd	s3,8(sp)
    800036cc:	1800                	addi	s0,sp,48
    800036ce:	892a                	mv	s2,a0
    800036d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800036d2:	00042517          	auipc	a0,0x42
    800036d6:	4be50513          	addi	a0,a0,1214 # 80045b90 <bcache>
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	660080e7          	jalr	1632(ra) # 80000d3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800036e2:	0004a497          	auipc	s1,0x4a
    800036e6:	7664b483          	ld	s1,1894(s1) # 8004de48 <bcache+0x82b8>
    800036ea:	0004a797          	auipc	a5,0x4a
    800036ee:	70e78793          	addi	a5,a5,1806 # 8004ddf8 <bcache+0x8268>
    800036f2:	02f48f63          	beq	s1,a5,80003730 <bread+0x70>
    800036f6:	873e                	mv	a4,a5
    800036f8:	a021                	j	80003700 <bread+0x40>
    800036fa:	68a4                	ld	s1,80(s1)
    800036fc:	02e48a63          	beq	s1,a4,80003730 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003700:	449c                	lw	a5,8(s1)
    80003702:	ff279ce3          	bne	a5,s2,800036fa <bread+0x3a>
    80003706:	44dc                	lw	a5,12(s1)
    80003708:	ff3799e3          	bne	a5,s3,800036fa <bread+0x3a>
      b->refcnt++;
    8000370c:	40bc                	lw	a5,64(s1)
    8000370e:	2785                	addiw	a5,a5,1
    80003710:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003712:	00042517          	auipc	a0,0x42
    80003716:	47e50513          	addi	a0,a0,1150 # 80045b90 <bcache>
    8000371a:	ffffd097          	auipc	ra,0xffffd
    8000371e:	6d4080e7          	jalr	1748(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    80003722:	01048513          	addi	a0,s1,16
    80003726:	00001097          	auipc	ra,0x1
    8000372a:	45a080e7          	jalr	1114(ra) # 80004b80 <acquiresleep>
      return b;
    8000372e:	a8b9                	j	8000378c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003730:	0004a497          	auipc	s1,0x4a
    80003734:	7104b483          	ld	s1,1808(s1) # 8004de40 <bcache+0x82b0>
    80003738:	0004a797          	auipc	a5,0x4a
    8000373c:	6c078793          	addi	a5,a5,1728 # 8004ddf8 <bcache+0x8268>
    80003740:	00f48863          	beq	s1,a5,80003750 <bread+0x90>
    80003744:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003746:	40bc                	lw	a5,64(s1)
    80003748:	cf81                	beqz	a5,80003760 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000374a:	64a4                	ld	s1,72(s1)
    8000374c:	fee49de3          	bne	s1,a4,80003746 <bread+0x86>
  panic("bget: no buffers");
    80003750:	00005517          	auipc	a0,0x5
    80003754:	f1850513          	addi	a0,a0,-232 # 80008668 <syscalls+0xe0>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	e8c080e7          	jalr	-372(ra) # 800005e4 <panic>
      b->dev = dev;
    80003760:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003764:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003768:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000376c:	4785                	li	a5,1
    8000376e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003770:	00042517          	auipc	a0,0x42
    80003774:	42050513          	addi	a0,a0,1056 # 80045b90 <bcache>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	676080e7          	jalr	1654(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    80003780:	01048513          	addi	a0,s1,16
    80003784:	00001097          	auipc	ra,0x1
    80003788:	3fc080e7          	jalr	1020(ra) # 80004b80 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000378c:	409c                	lw	a5,0(s1)
    8000378e:	cb89                	beqz	a5,800037a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003790:	8526                	mv	a0,s1
    80003792:	70a2                	ld	ra,40(sp)
    80003794:	7402                	ld	s0,32(sp)
    80003796:	64e2                	ld	s1,24(sp)
    80003798:	6942                	ld	s2,16(sp)
    8000379a:	69a2                	ld	s3,8(sp)
    8000379c:	6145                	addi	sp,sp,48
    8000379e:	8082                	ret
    virtio_disk_rw(b, 0);
    800037a0:	4581                	li	a1,0
    800037a2:	8526                	mv	a0,s1
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	f28080e7          	jalr	-216(ra) # 800066cc <virtio_disk_rw>
    b->valid = 1;
    800037ac:	4785                	li	a5,1
    800037ae:	c09c                	sw	a5,0(s1)
  return b;
    800037b0:	b7c5                	j	80003790 <bread+0xd0>

00000000800037b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800037b2:	1101                	addi	sp,sp,-32
    800037b4:	ec06                	sd	ra,24(sp)
    800037b6:	e822                	sd	s0,16(sp)
    800037b8:	e426                	sd	s1,8(sp)
    800037ba:	1000                	addi	s0,sp,32
    800037bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037be:	0541                	addi	a0,a0,16
    800037c0:	00001097          	auipc	ra,0x1
    800037c4:	45a080e7          	jalr	1114(ra) # 80004c1a <holdingsleep>
    800037c8:	cd01                	beqz	a0,800037e0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800037ca:	4585                	li	a1,1
    800037cc:	8526                	mv	a0,s1
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	efe080e7          	jalr	-258(ra) # 800066cc <virtio_disk_rw>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6105                	addi	sp,sp,32
    800037de:	8082                	ret
    panic("bwrite");
    800037e0:	00005517          	auipc	a0,0x5
    800037e4:	ea050513          	addi	a0,a0,-352 # 80008680 <syscalls+0xf8>
    800037e8:	ffffd097          	auipc	ra,0xffffd
    800037ec:	dfc080e7          	jalr	-516(ra) # 800005e4 <panic>

00000000800037f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800037f0:	1101                	addi	sp,sp,-32
    800037f2:	ec06                	sd	ra,24(sp)
    800037f4:	e822                	sd	s0,16(sp)
    800037f6:	e426                	sd	s1,8(sp)
    800037f8:	e04a                	sd	s2,0(sp)
    800037fa:	1000                	addi	s0,sp,32
    800037fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037fe:	01050913          	addi	s2,a0,16
    80003802:	854a                	mv	a0,s2
    80003804:	00001097          	auipc	ra,0x1
    80003808:	416080e7          	jalr	1046(ra) # 80004c1a <holdingsleep>
    8000380c:	c92d                	beqz	a0,8000387e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000380e:	854a                	mv	a0,s2
    80003810:	00001097          	auipc	ra,0x1
    80003814:	3c6080e7          	jalr	966(ra) # 80004bd6 <releasesleep>

  acquire(&bcache.lock);
    80003818:	00042517          	auipc	a0,0x42
    8000381c:	37850513          	addi	a0,a0,888 # 80045b90 <bcache>
    80003820:	ffffd097          	auipc	ra,0xffffd
    80003824:	51a080e7          	jalr	1306(ra) # 80000d3a <acquire>
  b->refcnt--;
    80003828:	40bc                	lw	a5,64(s1)
    8000382a:	37fd                	addiw	a5,a5,-1
    8000382c:	0007871b          	sext.w	a4,a5
    80003830:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003832:	eb05                	bnez	a4,80003862 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003834:	68bc                	ld	a5,80(s1)
    80003836:	64b8                	ld	a4,72(s1)
    80003838:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000383a:	64bc                	ld	a5,72(s1)
    8000383c:	68b8                	ld	a4,80(s1)
    8000383e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003840:	0004a797          	auipc	a5,0x4a
    80003844:	35078793          	addi	a5,a5,848 # 8004db90 <bcache+0x8000>
    80003848:	2b87b703          	ld	a4,696(a5)
    8000384c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000384e:	0004a717          	auipc	a4,0x4a
    80003852:	5aa70713          	addi	a4,a4,1450 # 8004ddf8 <bcache+0x8268>
    80003856:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003858:	2b87b703          	ld	a4,696(a5)
    8000385c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000385e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003862:	00042517          	auipc	a0,0x42
    80003866:	32e50513          	addi	a0,a0,814 # 80045b90 <bcache>
    8000386a:	ffffd097          	auipc	ra,0xffffd
    8000386e:	584080e7          	jalr	1412(ra) # 80000dee <release>
}
    80003872:	60e2                	ld	ra,24(sp)
    80003874:	6442                	ld	s0,16(sp)
    80003876:	64a2                	ld	s1,8(sp)
    80003878:	6902                	ld	s2,0(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret
    panic("brelse");
    8000387e:	00005517          	auipc	a0,0x5
    80003882:	e0a50513          	addi	a0,a0,-502 # 80008688 <syscalls+0x100>
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	d5e080e7          	jalr	-674(ra) # 800005e4 <panic>

000000008000388e <bpin>:

void
bpin(struct buf *b) {
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000389a:	00042517          	auipc	a0,0x42
    8000389e:	2f650513          	addi	a0,a0,758 # 80045b90 <bcache>
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	498080e7          	jalr	1176(ra) # 80000d3a <acquire>
  b->refcnt++;
    800038aa:	40bc                	lw	a5,64(s1)
    800038ac:	2785                	addiw	a5,a5,1
    800038ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038b0:	00042517          	auipc	a0,0x42
    800038b4:	2e050513          	addi	a0,a0,736 # 80045b90 <bcache>
    800038b8:	ffffd097          	auipc	ra,0xffffd
    800038bc:	536080e7          	jalr	1334(ra) # 80000dee <release>
}
    800038c0:	60e2                	ld	ra,24(sp)
    800038c2:	6442                	ld	s0,16(sp)
    800038c4:	64a2                	ld	s1,8(sp)
    800038c6:	6105                	addi	sp,sp,32
    800038c8:	8082                	ret

00000000800038ca <bunpin>:

void
bunpin(struct buf *b) {
    800038ca:	1101                	addi	sp,sp,-32
    800038cc:	ec06                	sd	ra,24(sp)
    800038ce:	e822                	sd	s0,16(sp)
    800038d0:	e426                	sd	s1,8(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038d6:	00042517          	auipc	a0,0x42
    800038da:	2ba50513          	addi	a0,a0,698 # 80045b90 <bcache>
    800038de:	ffffd097          	auipc	ra,0xffffd
    800038e2:	45c080e7          	jalr	1116(ra) # 80000d3a <acquire>
  b->refcnt--;
    800038e6:	40bc                	lw	a5,64(s1)
    800038e8:	37fd                	addiw	a5,a5,-1
    800038ea:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038ec:	00042517          	auipc	a0,0x42
    800038f0:	2a450513          	addi	a0,a0,676 # 80045b90 <bcache>
    800038f4:	ffffd097          	auipc	ra,0xffffd
    800038f8:	4fa080e7          	jalr	1274(ra) # 80000dee <release>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6105                	addi	sp,sp,32
    80003904:	8082                	ret

0000000080003906 <bfree>:
  }
  panic("balloc: out of blocks");
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80003906:	1101                	addi	sp,sp,-32
    80003908:	ec06                	sd	ra,24(sp)
    8000390a:	e822                	sd	s0,16(sp)
    8000390c:	e426                	sd	s1,8(sp)
    8000390e:	e04a                	sd	s2,0(sp)
    80003910:	1000                	addi	s0,sp,32
    80003912:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003914:	00d5d59b          	srliw	a1,a1,0xd
    80003918:	0004b797          	auipc	a5,0x4b
    8000391c:	9547a783          	lw	a5,-1708(a5) # 8004e26c <sb+0x1c>
    80003920:	9dbd                	addw	a1,a1,a5
    80003922:	00000097          	auipc	ra,0x0
    80003926:	d9e080e7          	jalr	-610(ra) # 800036c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000392a:	0074f713          	andi	a4,s1,7
    8000392e:	4785                	li	a5,1
    80003930:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    80003934:	14ce                	slli	s1,s1,0x33
    80003936:	90d9                	srli	s1,s1,0x36
    80003938:	00950733          	add	a4,a0,s1
    8000393c:	05874703          	lbu	a4,88(a4)
    80003940:	00e7f6b3          	and	a3,a5,a4
    80003944:	c69d                	beqz	a3,80003972 <bfree+0x6c>
    80003946:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80003948:	94aa                	add	s1,s1,a0
    8000394a:	fff7c793          	not	a5,a5
    8000394e:	8ff9                	and	a5,a5,a4
    80003950:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003954:	00001097          	auipc	ra,0x1
    80003958:	104080e7          	jalr	260(ra) # 80004a58 <log_write>
  brelse(bp);
    8000395c:	854a                	mv	a0,s2
    8000395e:	00000097          	auipc	ra,0x0
    80003962:	e92080e7          	jalr	-366(ra) # 800037f0 <brelse>
}
    80003966:	60e2                	ld	ra,24(sp)
    80003968:	6442                	ld	s0,16(sp)
    8000396a:	64a2                	ld	s1,8(sp)
    8000396c:	6902                	ld	s2,0(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret
    panic("freeing free block");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	d1e50513          	addi	a0,a0,-738 # 80008690 <syscalls+0x108>
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	c6a080e7          	jalr	-918(ra) # 800005e4 <panic>

0000000080003982 <balloc>:
static uint balloc(uint dev) {
    80003982:	711d                	addi	sp,sp,-96
    80003984:	ec86                	sd	ra,88(sp)
    80003986:	e8a2                	sd	s0,80(sp)
    80003988:	e4a6                	sd	s1,72(sp)
    8000398a:	e0ca                	sd	s2,64(sp)
    8000398c:	fc4e                	sd	s3,56(sp)
    8000398e:	f852                	sd	s4,48(sp)
    80003990:	f456                	sd	s5,40(sp)
    80003992:	f05a                	sd	s6,32(sp)
    80003994:	ec5e                	sd	s7,24(sp)
    80003996:	e862                	sd	s8,16(sp)
    80003998:	e466                	sd	s9,8(sp)
    8000399a:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    8000399c:	0004b797          	auipc	a5,0x4b
    800039a0:	8b87a783          	lw	a5,-1864(a5) # 8004e254 <sb+0x4>
    800039a4:	cbd1                	beqz	a5,80003a38 <balloc+0xb6>
    800039a6:	8baa                	mv	s7,a0
    800039a8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800039aa:	0004bb17          	auipc	s6,0x4b
    800039ae:	8a6b0b13          	addi	s6,s6,-1882 # 8004e250 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800039b2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800039b4:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800039b6:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800039b8:	6c89                	lui	s9,0x2
    800039ba:	a831                	j	800039d6 <balloc+0x54>
    brelse(bp);
    800039bc:	854a                	mv	a0,s2
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	e32080e7          	jalr	-462(ra) # 800037f0 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800039c6:	015c87bb          	addw	a5,s9,s5
    800039ca:	00078a9b          	sext.w	s5,a5
    800039ce:	004b2703          	lw	a4,4(s6)
    800039d2:	06eaf363          	bgeu	s5,a4,80003a38 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800039d6:	41fad79b          	sraiw	a5,s5,0x1f
    800039da:	0137d79b          	srliw	a5,a5,0x13
    800039de:	015787bb          	addw	a5,a5,s5
    800039e2:	40d7d79b          	sraiw	a5,a5,0xd
    800039e6:	01cb2583          	lw	a1,28(s6)
    800039ea:	9dbd                	addw	a1,a1,a5
    800039ec:	855e                	mv	a0,s7
    800039ee:	00000097          	auipc	ra,0x0
    800039f2:	cd2080e7          	jalr	-814(ra) # 800036c0 <bread>
    800039f6:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800039f8:	004b2503          	lw	a0,4(s6)
    800039fc:	000a849b          	sext.w	s1,s5
    80003a00:	8662                	mv	a2,s8
    80003a02:	faa4fde3          	bgeu	s1,a0,800039bc <balloc+0x3a>
      m = 1 << (bi % 8);
    80003a06:	41f6579b          	sraiw	a5,a2,0x1f
    80003a0a:	01d7d69b          	srliw	a3,a5,0x1d
    80003a0e:	00c6873b          	addw	a4,a3,a2
    80003a12:	00777793          	andi	a5,a4,7
    80003a16:	9f95                	subw	a5,a5,a3
    80003a18:	00f997bb          	sllw	a5,s3,a5
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80003a1c:	4037571b          	sraiw	a4,a4,0x3
    80003a20:	00e906b3          	add	a3,s2,a4
    80003a24:	0586c683          	lbu	a3,88(a3)
    80003a28:	00d7f5b3          	and	a1,a5,a3
    80003a2c:	cd91                	beqz	a1,80003a48 <balloc+0xc6>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003a2e:	2605                	addiw	a2,a2,1
    80003a30:	2485                	addiw	s1,s1,1
    80003a32:	fd4618e3          	bne	a2,s4,80003a02 <balloc+0x80>
    80003a36:	b759                	j	800039bc <balloc+0x3a>
  panic("balloc: out of blocks");
    80003a38:	00005517          	auipc	a0,0x5
    80003a3c:	c7050513          	addi	a0,a0,-912 # 800086a8 <syscalls+0x120>
    80003a40:	ffffd097          	auipc	ra,0xffffd
    80003a44:	ba4080e7          	jalr	-1116(ra) # 800005e4 <panic>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80003a48:	974a                	add	a4,a4,s2
    80003a4a:	8fd5                	or	a5,a5,a3
    80003a4c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003a50:	854a                	mv	a0,s2
    80003a52:	00001097          	auipc	ra,0x1
    80003a56:	006080e7          	jalr	6(ra) # 80004a58 <log_write>
        brelse(bp);
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	d94080e7          	jalr	-620(ra) # 800037f0 <brelse>
  bp = bread(dev, bno);
    80003a64:	85a6                	mv	a1,s1
    80003a66:	855e                	mv	a0,s7
    80003a68:	00000097          	auipc	ra,0x0
    80003a6c:	c58080e7          	jalr	-936(ra) # 800036c0 <bread>
    80003a70:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003a72:	40000613          	li	a2,1024
    80003a76:	4581                	li	a1,0
    80003a78:	05850513          	addi	a0,a0,88
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	3ba080e7          	jalr	954(ra) # 80000e36 <memset>
  log_write(bp);
    80003a84:	854a                	mv	a0,s2
    80003a86:	00001097          	auipc	ra,0x1
    80003a8a:	fd2080e7          	jalr	-46(ra) # 80004a58 <log_write>
  brelse(bp);
    80003a8e:	854a                	mv	a0,s2
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	d60080e7          	jalr	-672(ra) # 800037f0 <brelse>
}
    80003a98:	8526                	mv	a0,s1
    80003a9a:	60e6                	ld	ra,88(sp)
    80003a9c:	6446                	ld	s0,80(sp)
    80003a9e:	64a6                	ld	s1,72(sp)
    80003aa0:	6906                	ld	s2,64(sp)
    80003aa2:	79e2                	ld	s3,56(sp)
    80003aa4:	7a42                	ld	s4,48(sp)
    80003aa6:	7aa2                	ld	s5,40(sp)
    80003aa8:	7b02                	ld	s6,32(sp)
    80003aaa:	6be2                	ld	s7,24(sp)
    80003aac:	6c42                	ld	s8,16(sp)
    80003aae:	6ca2                	ld	s9,8(sp)
    80003ab0:	6125                	addi	sp,sp,96
    80003ab2:	8082                	ret

0000000080003ab4 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
    80003ab4:	7179                	addi	sp,sp,-48
    80003ab6:	f406                	sd	ra,40(sp)
    80003ab8:	f022                	sd	s0,32(sp)
    80003aba:	ec26                	sd	s1,24(sp)
    80003abc:	e84a                	sd	s2,16(sp)
    80003abe:	e44e                	sd	s3,8(sp)
    80003ac0:	e052                	sd	s4,0(sp)
    80003ac2:	1800                	addi	s0,sp,48
    80003ac4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003ac6:	47ad                	li	a5,11
    80003ac8:	04b7fe63          	bgeu	a5,a1,80003b24 <bmap+0x70>
    if ((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003acc:	ff45849b          	addiw	s1,a1,-12
    80003ad0:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80003ad4:	0ff00793          	li	a5,255
    80003ad8:	0ae7e363          	bltu	a5,a4,80003b7e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0)
    80003adc:	08052583          	lw	a1,128(a0)
    80003ae0:	c5ad                	beqz	a1,80003b4a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003ae2:	00092503          	lw	a0,0(s2)
    80003ae6:	00000097          	auipc	ra,0x0
    80003aea:	bda080e7          	jalr	-1062(ra) # 800036c0 <bread>
    80003aee:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80003af0:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80003af4:	02049593          	slli	a1,s1,0x20
    80003af8:	9181                	srli	a1,a1,0x20
    80003afa:	058a                	slli	a1,a1,0x2
    80003afc:	00b784b3          	add	s1,a5,a1
    80003b00:	0004a983          	lw	s3,0(s1)
    80003b04:	04098d63          	beqz	s3,80003b5e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003b08:	8552                	mv	a0,s4
    80003b0a:	00000097          	auipc	ra,0x0
    80003b0e:	ce6080e7          	jalr	-794(ra) # 800037f0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003b12:	854e                	mv	a0,s3
    80003b14:	70a2                	ld	ra,40(sp)
    80003b16:	7402                	ld	s0,32(sp)
    80003b18:	64e2                	ld	s1,24(sp)
    80003b1a:	6942                	ld	s2,16(sp)
    80003b1c:	69a2                	ld	s3,8(sp)
    80003b1e:	6a02                	ld	s4,0(sp)
    80003b20:	6145                	addi	sp,sp,48
    80003b22:	8082                	ret
    if ((addr = ip->addrs[bn]) == 0)
    80003b24:	02059493          	slli	s1,a1,0x20
    80003b28:	9081                	srli	s1,s1,0x20
    80003b2a:	048a                	slli	s1,s1,0x2
    80003b2c:	94aa                	add	s1,s1,a0
    80003b2e:	0504a983          	lw	s3,80(s1)
    80003b32:	fe0990e3          	bnez	s3,80003b12 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003b36:	4108                	lw	a0,0(a0)
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	e4a080e7          	jalr	-438(ra) # 80003982 <balloc>
    80003b40:	0005099b          	sext.w	s3,a0
    80003b44:	0534a823          	sw	s3,80(s1)
    80003b48:	b7e9                	j	80003b12 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003b4a:	4108                	lw	a0,0(a0)
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	e36080e7          	jalr	-458(ra) # 80003982 <balloc>
    80003b54:	0005059b          	sext.w	a1,a0
    80003b58:	08b92023          	sw	a1,128(s2)
    80003b5c:	b759                	j	80003ae2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003b5e:	00092503          	lw	a0,0(s2)
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	e20080e7          	jalr	-480(ra) # 80003982 <balloc>
    80003b6a:	0005099b          	sext.w	s3,a0
    80003b6e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003b72:	8552                	mv	a0,s4
    80003b74:	00001097          	auipc	ra,0x1
    80003b78:	ee4080e7          	jalr	-284(ra) # 80004a58 <log_write>
    80003b7c:	b771                	j	80003b08 <bmap+0x54>
  panic("bmap: out of range");
    80003b7e:	00005517          	auipc	a0,0x5
    80003b82:	b4250513          	addi	a0,a0,-1214 # 800086c0 <syscalls+0x138>
    80003b86:	ffffd097          	auipc	ra,0xffffd
    80003b8a:	a5e080e7          	jalr	-1442(ra) # 800005e4 <panic>

0000000080003b8e <iget>:
static struct inode *iget(uint dev, uint inum) {
    80003b8e:	7179                	addi	sp,sp,-48
    80003b90:	f406                	sd	ra,40(sp)
    80003b92:	f022                	sd	s0,32(sp)
    80003b94:	ec26                	sd	s1,24(sp)
    80003b96:	e84a                	sd	s2,16(sp)
    80003b98:	e44e                	sd	s3,8(sp)
    80003b9a:	e052                	sd	s4,0(sp)
    80003b9c:	1800                	addi	s0,sp,48
    80003b9e:	89aa                	mv	s3,a0
    80003ba0:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003ba2:	0004a517          	auipc	a0,0x4a
    80003ba6:	6ce50513          	addi	a0,a0,1742 # 8004e270 <icache>
    80003baa:	ffffd097          	auipc	ra,0xffffd
    80003bae:	190080e7          	jalr	400(ra) # 80000d3a <acquire>
  empty = 0;
    80003bb2:	4901                	li	s2,0
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
    80003bb4:	0004a497          	auipc	s1,0x4a
    80003bb8:	6d448493          	addi	s1,s1,1748 # 8004e288 <icache+0x18>
    80003bbc:	0004c697          	auipc	a3,0x4c
    80003bc0:	15c68693          	addi	a3,a3,348 # 8004fd18 <log>
    80003bc4:	a039                	j	80003bd2 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003bc6:	02090b63          	beqz	s2,80003bfc <iget+0x6e>
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
    80003bca:	08848493          	addi	s1,s1,136
    80003bce:	02d48a63          	beq	s1,a3,80003c02 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80003bd2:	449c                	lw	a5,8(s1)
    80003bd4:	fef059e3          	blez	a5,80003bc6 <iget+0x38>
    80003bd8:	4098                	lw	a4,0(s1)
    80003bda:	ff3716e3          	bne	a4,s3,80003bc6 <iget+0x38>
    80003bde:	40d8                	lw	a4,4(s1)
    80003be0:	ff4713e3          	bne	a4,s4,80003bc6 <iget+0x38>
      ip->ref++;
    80003be4:	2785                	addiw	a5,a5,1
    80003be6:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003be8:	0004a517          	auipc	a0,0x4a
    80003bec:	68850513          	addi	a0,a0,1672 # 8004e270 <icache>
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	1fe080e7          	jalr	510(ra) # 80000dee <release>
      return ip;
    80003bf8:	8926                	mv	s2,s1
    80003bfa:	a03d                	j	80003c28 <iget+0x9a>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003bfc:	f7f9                	bnez	a5,80003bca <iget+0x3c>
    80003bfe:	8926                	mv	s2,s1
    80003c00:	b7e9                	j	80003bca <iget+0x3c>
  if (empty == 0)
    80003c02:	02090c63          	beqz	s2,80003c3a <iget+0xac>
  ip->dev = dev;
    80003c06:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003c0a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003c0e:	4785                	li	a5,1
    80003c10:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003c14:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003c18:	0004a517          	auipc	a0,0x4a
    80003c1c:	65850513          	addi	a0,a0,1624 # 8004e270 <icache>
    80003c20:	ffffd097          	auipc	ra,0xffffd
    80003c24:	1ce080e7          	jalr	462(ra) # 80000dee <release>
}
    80003c28:	854a                	mv	a0,s2
    80003c2a:	70a2                	ld	ra,40(sp)
    80003c2c:	7402                	ld	s0,32(sp)
    80003c2e:	64e2                	ld	s1,24(sp)
    80003c30:	6942                	ld	s2,16(sp)
    80003c32:	69a2                	ld	s3,8(sp)
    80003c34:	6a02                	ld	s4,0(sp)
    80003c36:	6145                	addi	sp,sp,48
    80003c38:	8082                	ret
    panic("iget: no inodes");
    80003c3a:	00005517          	auipc	a0,0x5
    80003c3e:	a9e50513          	addi	a0,a0,-1378 # 800086d8 <syscalls+0x150>
    80003c42:	ffffd097          	auipc	ra,0xffffd
    80003c46:	9a2080e7          	jalr	-1630(ra) # 800005e4 <panic>

0000000080003c4a <fsinit>:
void fsinit(int dev) {
    80003c4a:	7179                	addi	sp,sp,-48
    80003c4c:	f406                	sd	ra,40(sp)
    80003c4e:	f022                	sd	s0,32(sp)
    80003c50:	ec26                	sd	s1,24(sp)
    80003c52:	e84a                	sd	s2,16(sp)
    80003c54:	e44e                	sd	s3,8(sp)
    80003c56:	1800                	addi	s0,sp,48
    80003c58:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003c5a:	4585                	li	a1,1
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	a64080e7          	jalr	-1436(ra) # 800036c0 <bread>
    80003c64:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003c66:	0004a997          	auipc	s3,0x4a
    80003c6a:	5ea98993          	addi	s3,s3,1514 # 8004e250 <sb>
    80003c6e:	02000613          	li	a2,32
    80003c72:	05850593          	addi	a1,a0,88
    80003c76:	854e                	mv	a0,s3
    80003c78:	ffffd097          	auipc	ra,0xffffd
    80003c7c:	21a080e7          	jalr	538(ra) # 80000e92 <memmove>
  brelse(bp);
    80003c80:	8526                	mv	a0,s1
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	b6e080e7          	jalr	-1170(ra) # 800037f0 <brelse>
  if (sb.magic != FSMAGIC)
    80003c8a:	0009a703          	lw	a4,0(s3)
    80003c8e:	102037b7          	lui	a5,0x10203
    80003c92:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c96:	02f71263          	bne	a4,a5,80003cba <fsinit+0x70>
  initlog(dev, &sb);
    80003c9a:	0004a597          	auipc	a1,0x4a
    80003c9e:	5b658593          	addi	a1,a1,1462 # 8004e250 <sb>
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	00001097          	auipc	ra,0x1
    80003ca8:	b3c080e7          	jalr	-1220(ra) # 800047e0 <initlog>
}
    80003cac:	70a2                	ld	ra,40(sp)
    80003cae:	7402                	ld	s0,32(sp)
    80003cb0:	64e2                	ld	s1,24(sp)
    80003cb2:	6942                	ld	s2,16(sp)
    80003cb4:	69a2                	ld	s3,8(sp)
    80003cb6:	6145                	addi	sp,sp,48
    80003cb8:	8082                	ret
    panic("invalid file system");
    80003cba:	00005517          	auipc	a0,0x5
    80003cbe:	a2e50513          	addi	a0,a0,-1490 # 800086e8 <syscalls+0x160>
    80003cc2:	ffffd097          	auipc	ra,0xffffd
    80003cc6:	922080e7          	jalr	-1758(ra) # 800005e4 <panic>

0000000080003cca <iinit>:
void iinit() {
    80003cca:	7179                	addi	sp,sp,-48
    80003ccc:	f406                	sd	ra,40(sp)
    80003cce:	f022                	sd	s0,32(sp)
    80003cd0:	ec26                	sd	s1,24(sp)
    80003cd2:	e84a                	sd	s2,16(sp)
    80003cd4:	e44e                	sd	s3,8(sp)
    80003cd6:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003cd8:	00005597          	auipc	a1,0x5
    80003cdc:	a2858593          	addi	a1,a1,-1496 # 80008700 <syscalls+0x178>
    80003ce0:	0004a517          	auipc	a0,0x4a
    80003ce4:	59050513          	addi	a0,a0,1424 # 8004e270 <icache>
    80003ce8:	ffffd097          	auipc	ra,0xffffd
    80003cec:	fc2080e7          	jalr	-62(ra) # 80000caa <initlock>
  for (i = 0; i < NINODE; i++) {
    80003cf0:	0004a497          	auipc	s1,0x4a
    80003cf4:	5a848493          	addi	s1,s1,1448 # 8004e298 <icache+0x28>
    80003cf8:	0004c997          	auipc	s3,0x4c
    80003cfc:	03098993          	addi	s3,s3,48 # 8004fd28 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003d00:	00005917          	auipc	s2,0x5
    80003d04:	a0890913          	addi	s2,s2,-1528 # 80008708 <syscalls+0x180>
    80003d08:	85ca                	mv	a1,s2
    80003d0a:	8526                	mv	a0,s1
    80003d0c:	00001097          	auipc	ra,0x1
    80003d10:	e3a080e7          	jalr	-454(ra) # 80004b46 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003d14:	08848493          	addi	s1,s1,136
    80003d18:	ff3498e3          	bne	s1,s3,80003d08 <iinit+0x3e>
}
    80003d1c:	70a2                	ld	ra,40(sp)
    80003d1e:	7402                	ld	s0,32(sp)
    80003d20:	64e2                	ld	s1,24(sp)
    80003d22:	6942                	ld	s2,16(sp)
    80003d24:	69a2                	ld	s3,8(sp)
    80003d26:	6145                	addi	sp,sp,48
    80003d28:	8082                	ret

0000000080003d2a <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80003d2a:	715d                	addi	sp,sp,-80
    80003d2c:	e486                	sd	ra,72(sp)
    80003d2e:	e0a2                	sd	s0,64(sp)
    80003d30:	fc26                	sd	s1,56(sp)
    80003d32:	f84a                	sd	s2,48(sp)
    80003d34:	f44e                	sd	s3,40(sp)
    80003d36:	f052                	sd	s4,32(sp)
    80003d38:	ec56                	sd	s5,24(sp)
    80003d3a:	e85a                	sd	s6,16(sp)
    80003d3c:	e45e                	sd	s7,8(sp)
    80003d3e:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003d40:	0004a717          	auipc	a4,0x4a
    80003d44:	51c72703          	lw	a4,1308(a4) # 8004e25c <sb+0xc>
    80003d48:	4785                	li	a5,1
    80003d4a:	04e7fa63          	bgeu	a5,a4,80003d9e <ialloc+0x74>
    80003d4e:	8aaa                	mv	s5,a0
    80003d50:	8bae                	mv	s7,a1
    80003d52:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003d54:	0004aa17          	auipc	s4,0x4a
    80003d58:	4fca0a13          	addi	s4,s4,1276 # 8004e250 <sb>
    80003d5c:	00048b1b          	sext.w	s6,s1
    80003d60:	0044d793          	srli	a5,s1,0x4
    80003d64:	018a2583          	lw	a1,24(s4)
    80003d68:	9dbd                	addw	a1,a1,a5
    80003d6a:	8556                	mv	a0,s5
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	954080e7          	jalr	-1708(ra) # 800036c0 <bread>
    80003d74:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003d76:	05850993          	addi	s3,a0,88
    80003d7a:	00f4f793          	andi	a5,s1,15
    80003d7e:	079a                	slli	a5,a5,0x6
    80003d80:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003d82:	00099783          	lh	a5,0(s3)
    80003d86:	c785                	beqz	a5,80003dae <ialloc+0x84>
    brelse(bp);
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	a68080e7          	jalr	-1432(ra) # 800037f0 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003d90:	0485                	addi	s1,s1,1
    80003d92:	00ca2703          	lw	a4,12(s4)
    80003d96:	0004879b          	sext.w	a5,s1
    80003d9a:	fce7e1e3          	bltu	a5,a4,80003d5c <ialloc+0x32>
  panic("ialloc: no inodes");
    80003d9e:	00005517          	auipc	a0,0x5
    80003da2:	97250513          	addi	a0,a0,-1678 # 80008710 <syscalls+0x188>
    80003da6:	ffffd097          	auipc	ra,0xffffd
    80003daa:	83e080e7          	jalr	-1986(ra) # 800005e4 <panic>
      memset(dip, 0, sizeof(*dip));
    80003dae:	04000613          	li	a2,64
    80003db2:	4581                	li	a1,0
    80003db4:	854e                	mv	a0,s3
    80003db6:	ffffd097          	auipc	ra,0xffffd
    80003dba:	080080e7          	jalr	128(ra) # 80000e36 <memset>
      dip->type = type;
    80003dbe:	01799023          	sh	s7,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003dc2:	854a                	mv	a0,s2
    80003dc4:	00001097          	auipc	ra,0x1
    80003dc8:	c94080e7          	jalr	-876(ra) # 80004a58 <log_write>
      brelse(bp);
    80003dcc:	854a                	mv	a0,s2
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	a22080e7          	jalr	-1502(ra) # 800037f0 <brelse>
      return iget(dev, inum);
    80003dd6:	85da                	mv	a1,s6
    80003dd8:	8556                	mv	a0,s5
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	db4080e7          	jalr	-588(ra) # 80003b8e <iget>
}
    80003de2:	60a6                	ld	ra,72(sp)
    80003de4:	6406                	ld	s0,64(sp)
    80003de6:	74e2                	ld	s1,56(sp)
    80003de8:	7942                	ld	s2,48(sp)
    80003dea:	79a2                	ld	s3,40(sp)
    80003dec:	7a02                	ld	s4,32(sp)
    80003dee:	6ae2                	ld	s5,24(sp)
    80003df0:	6b42                	ld	s6,16(sp)
    80003df2:	6ba2                	ld	s7,8(sp)
    80003df4:	6161                	addi	sp,sp,80
    80003df6:	8082                	ret

0000000080003df8 <iupdate>:
void iupdate(struct inode *ip) {
    80003df8:	1101                	addi	sp,sp,-32
    80003dfa:	ec06                	sd	ra,24(sp)
    80003dfc:	e822                	sd	s0,16(sp)
    80003dfe:	e426                	sd	s1,8(sp)
    80003e00:	e04a                	sd	s2,0(sp)
    80003e02:	1000                	addi	s0,sp,32
    80003e04:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e06:	415c                	lw	a5,4(a0)
    80003e08:	0047d79b          	srliw	a5,a5,0x4
    80003e0c:	0004a597          	auipc	a1,0x4a
    80003e10:	45c5a583          	lw	a1,1116(a1) # 8004e268 <sb+0x18>
    80003e14:	9dbd                	addw	a1,a1,a5
    80003e16:	4108                	lw	a0,0(a0)
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	8a8080e7          	jalr	-1880(ra) # 800036c0 <bread>
    80003e20:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003e22:	05850793          	addi	a5,a0,88
    80003e26:	40c8                	lw	a0,4(s1)
    80003e28:	893d                	andi	a0,a0,15
    80003e2a:	051a                	slli	a0,a0,0x6
    80003e2c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003e2e:	04449703          	lh	a4,68(s1)
    80003e32:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003e36:	04649703          	lh	a4,70(s1)
    80003e3a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003e3e:	04849703          	lh	a4,72(s1)
    80003e42:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003e46:	04a49703          	lh	a4,74(s1)
    80003e4a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003e4e:	44f8                	lw	a4,76(s1)
    80003e50:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003e52:	03400613          	li	a2,52
    80003e56:	05048593          	addi	a1,s1,80
    80003e5a:	0531                	addi	a0,a0,12
    80003e5c:	ffffd097          	auipc	ra,0xffffd
    80003e60:	036080e7          	jalr	54(ra) # 80000e92 <memmove>
  log_write(bp);
    80003e64:	854a                	mv	a0,s2
    80003e66:	00001097          	auipc	ra,0x1
    80003e6a:	bf2080e7          	jalr	-1038(ra) # 80004a58 <log_write>
  brelse(bp);
    80003e6e:	854a                	mv	a0,s2
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	980080e7          	jalr	-1664(ra) # 800037f0 <brelse>
}
    80003e78:	60e2                	ld	ra,24(sp)
    80003e7a:	6442                	ld	s0,16(sp)
    80003e7c:	64a2                	ld	s1,8(sp)
    80003e7e:	6902                	ld	s2,0(sp)
    80003e80:	6105                	addi	sp,sp,32
    80003e82:	8082                	ret

0000000080003e84 <idup>:
struct inode *idup(struct inode *ip) {
    80003e84:	1101                	addi	sp,sp,-32
    80003e86:	ec06                	sd	ra,24(sp)
    80003e88:	e822                	sd	s0,16(sp)
    80003e8a:	e426                	sd	s1,8(sp)
    80003e8c:	1000                	addi	s0,sp,32
    80003e8e:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003e90:	0004a517          	auipc	a0,0x4a
    80003e94:	3e050513          	addi	a0,a0,992 # 8004e270 <icache>
    80003e98:	ffffd097          	auipc	ra,0xffffd
    80003e9c:	ea2080e7          	jalr	-350(ra) # 80000d3a <acquire>
  ip->ref++;
    80003ea0:	449c                	lw	a5,8(s1)
    80003ea2:	2785                	addiw	a5,a5,1
    80003ea4:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003ea6:	0004a517          	auipc	a0,0x4a
    80003eaa:	3ca50513          	addi	a0,a0,970 # 8004e270 <icache>
    80003eae:	ffffd097          	auipc	ra,0xffffd
    80003eb2:	f40080e7          	jalr	-192(ra) # 80000dee <release>
}
    80003eb6:	8526                	mv	a0,s1
    80003eb8:	60e2                	ld	ra,24(sp)
    80003eba:	6442                	ld	s0,16(sp)
    80003ebc:	64a2                	ld	s1,8(sp)
    80003ebe:	6105                	addi	sp,sp,32
    80003ec0:	8082                	ret

0000000080003ec2 <ilock>:
void ilock(struct inode *ip) {
    80003ec2:	1101                	addi	sp,sp,-32
    80003ec4:	ec06                	sd	ra,24(sp)
    80003ec6:	e822                	sd	s0,16(sp)
    80003ec8:	e426                	sd	s1,8(sp)
    80003eca:	e04a                	sd	s2,0(sp)
    80003ecc:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003ece:	c115                	beqz	a0,80003ef2 <ilock+0x30>
    80003ed0:	84aa                	mv	s1,a0
    80003ed2:	451c                	lw	a5,8(a0)
    80003ed4:	00f05f63          	blez	a5,80003ef2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003ed8:	0541                	addi	a0,a0,16
    80003eda:	00001097          	auipc	ra,0x1
    80003ede:	ca6080e7          	jalr	-858(ra) # 80004b80 <acquiresleep>
  if (ip->valid == 0) {
    80003ee2:	40bc                	lw	a5,64(s1)
    80003ee4:	cf99                	beqz	a5,80003f02 <ilock+0x40>
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	64a2                	ld	s1,8(sp)
    80003eec:	6902                	ld	s2,0(sp)
    80003eee:	6105                	addi	sp,sp,32
    80003ef0:	8082                	ret
    panic("ilock");
    80003ef2:	00005517          	auipc	a0,0x5
    80003ef6:	83650513          	addi	a0,a0,-1994 # 80008728 <syscalls+0x1a0>
    80003efa:	ffffc097          	auipc	ra,0xffffc
    80003efe:	6ea080e7          	jalr	1770(ra) # 800005e4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f02:	40dc                	lw	a5,4(s1)
    80003f04:	0047d79b          	srliw	a5,a5,0x4
    80003f08:	0004a597          	auipc	a1,0x4a
    80003f0c:	3605a583          	lw	a1,864(a1) # 8004e268 <sb+0x18>
    80003f10:	9dbd                	addw	a1,a1,a5
    80003f12:	4088                	lw	a0,0(s1)
    80003f14:	fffff097          	auipc	ra,0xfffff
    80003f18:	7ac080e7          	jalr	1964(ra) # 800036c0 <bread>
    80003f1c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003f1e:	05850593          	addi	a1,a0,88
    80003f22:	40dc                	lw	a5,4(s1)
    80003f24:	8bbd                	andi	a5,a5,15
    80003f26:	079a                	slli	a5,a5,0x6
    80003f28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003f2a:	00059783          	lh	a5,0(a1)
    80003f2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003f32:	00259783          	lh	a5,2(a1)
    80003f36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003f3a:	00459783          	lh	a5,4(a1)
    80003f3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003f42:	00659783          	lh	a5,6(a1)
    80003f46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003f4a:	459c                	lw	a5,8(a1)
    80003f4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003f4e:	03400613          	li	a2,52
    80003f52:	05b1                	addi	a1,a1,12
    80003f54:	05048513          	addi	a0,s1,80
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	f3a080e7          	jalr	-198(ra) # 80000e92 <memmove>
    brelse(bp);
    80003f60:	854a                	mv	a0,s2
    80003f62:	00000097          	auipc	ra,0x0
    80003f66:	88e080e7          	jalr	-1906(ra) # 800037f0 <brelse>
    ip->valid = 1;
    80003f6a:	4785                	li	a5,1
    80003f6c:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003f6e:	04449783          	lh	a5,68(s1)
    80003f72:	fbb5                	bnez	a5,80003ee6 <ilock+0x24>
      panic("ilock: no type");
    80003f74:	00004517          	auipc	a0,0x4
    80003f78:	7bc50513          	addi	a0,a0,1980 # 80008730 <syscalls+0x1a8>
    80003f7c:	ffffc097          	auipc	ra,0xffffc
    80003f80:	668080e7          	jalr	1640(ra) # 800005e4 <panic>

0000000080003f84 <iunlock>:
void iunlock(struct inode *ip) {
    80003f84:	1101                	addi	sp,sp,-32
    80003f86:	ec06                	sd	ra,24(sp)
    80003f88:	e822                	sd	s0,16(sp)
    80003f8a:	e426                	sd	s1,8(sp)
    80003f8c:	e04a                	sd	s2,0(sp)
    80003f8e:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003f90:	c905                	beqz	a0,80003fc0 <iunlock+0x3c>
    80003f92:	84aa                	mv	s1,a0
    80003f94:	01050913          	addi	s2,a0,16
    80003f98:	854a                	mv	a0,s2
    80003f9a:	00001097          	auipc	ra,0x1
    80003f9e:	c80080e7          	jalr	-896(ra) # 80004c1a <holdingsleep>
    80003fa2:	cd19                	beqz	a0,80003fc0 <iunlock+0x3c>
    80003fa4:	449c                	lw	a5,8(s1)
    80003fa6:	00f05d63          	blez	a5,80003fc0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003faa:	854a                	mv	a0,s2
    80003fac:	00001097          	auipc	ra,0x1
    80003fb0:	c2a080e7          	jalr	-982(ra) # 80004bd6 <releasesleep>
}
    80003fb4:	60e2                	ld	ra,24(sp)
    80003fb6:	6442                	ld	s0,16(sp)
    80003fb8:	64a2                	ld	s1,8(sp)
    80003fba:	6902                	ld	s2,0(sp)
    80003fbc:	6105                	addi	sp,sp,32
    80003fbe:	8082                	ret
    panic("iunlock");
    80003fc0:	00004517          	auipc	a0,0x4
    80003fc4:	78050513          	addi	a0,a0,1920 # 80008740 <syscalls+0x1b8>
    80003fc8:	ffffc097          	auipc	ra,0xffffc
    80003fcc:	61c080e7          	jalr	1564(ra) # 800005e4 <panic>

0000000080003fd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80003fd0:	7179                	addi	sp,sp,-48
    80003fd2:	f406                	sd	ra,40(sp)
    80003fd4:	f022                	sd	s0,32(sp)
    80003fd6:	ec26                	sd	s1,24(sp)
    80003fd8:	e84a                	sd	s2,16(sp)
    80003fda:	e44e                	sd	s3,8(sp)
    80003fdc:	e052                	sd	s4,0(sp)
    80003fde:	1800                	addi	s0,sp,48
    80003fe0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80003fe2:	05050493          	addi	s1,a0,80
    80003fe6:	08050913          	addi	s2,a0,128
    80003fea:	a021                	j	80003ff2 <itrunc+0x22>
    80003fec:	0491                	addi	s1,s1,4
    80003fee:	01248d63          	beq	s1,s2,80004008 <itrunc+0x38>
    if (ip->addrs[i]) {
    80003ff2:	408c                	lw	a1,0(s1)
    80003ff4:	dde5                	beqz	a1,80003fec <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003ff6:	0009a503          	lw	a0,0(s3)
    80003ffa:	00000097          	auipc	ra,0x0
    80003ffe:	90c080e7          	jalr	-1780(ra) # 80003906 <bfree>
      ip->addrs[i] = 0;
    80004002:	0004a023          	sw	zero,0(s1)
    80004006:	b7dd                	j	80003fec <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80004008:	0809a583          	lw	a1,128(s3)
    8000400c:	e185                	bnez	a1,8000402c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000400e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004012:	854e                	mv	a0,s3
    80004014:	00000097          	auipc	ra,0x0
    80004018:	de4080e7          	jalr	-540(ra) # 80003df8 <iupdate>
}
    8000401c:	70a2                	ld	ra,40(sp)
    8000401e:	7402                	ld	s0,32(sp)
    80004020:	64e2                	ld	s1,24(sp)
    80004022:	6942                	ld	s2,16(sp)
    80004024:	69a2                	ld	s3,8(sp)
    80004026:	6a02                	ld	s4,0(sp)
    80004028:	6145                	addi	sp,sp,48
    8000402a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000402c:	0009a503          	lw	a0,0(s3)
    80004030:	fffff097          	auipc	ra,0xfffff
    80004034:	690080e7          	jalr	1680(ra) # 800036c0 <bread>
    80004038:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    8000403a:	05850493          	addi	s1,a0,88
    8000403e:	45850913          	addi	s2,a0,1112
    80004042:	a021                	j	8000404a <itrunc+0x7a>
    80004044:	0491                	addi	s1,s1,4
    80004046:	01248b63          	beq	s1,s2,8000405c <itrunc+0x8c>
      if (a[j])
    8000404a:	408c                	lw	a1,0(s1)
    8000404c:	dde5                	beqz	a1,80004044 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000404e:	0009a503          	lw	a0,0(s3)
    80004052:	00000097          	auipc	ra,0x0
    80004056:	8b4080e7          	jalr	-1868(ra) # 80003906 <bfree>
    8000405a:	b7ed                	j	80004044 <itrunc+0x74>
    brelse(bp);
    8000405c:	8552                	mv	a0,s4
    8000405e:	fffff097          	auipc	ra,0xfffff
    80004062:	792080e7          	jalr	1938(ra) # 800037f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004066:	0809a583          	lw	a1,128(s3)
    8000406a:	0009a503          	lw	a0,0(s3)
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	898080e7          	jalr	-1896(ra) # 80003906 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004076:	0809a023          	sw	zero,128(s3)
    8000407a:	bf51                	j	8000400e <itrunc+0x3e>

000000008000407c <iput>:
void iput(struct inode *ip) {
    8000407c:	1101                	addi	sp,sp,-32
    8000407e:	ec06                	sd	ra,24(sp)
    80004080:	e822                	sd	s0,16(sp)
    80004082:	e426                	sd	s1,8(sp)
    80004084:	e04a                	sd	s2,0(sp)
    80004086:	1000                	addi	s0,sp,32
    80004088:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000408a:	0004a517          	auipc	a0,0x4a
    8000408e:	1e650513          	addi	a0,a0,486 # 8004e270 <icache>
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	ca8080e7          	jalr	-856(ra) # 80000d3a <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    8000409a:	4498                	lw	a4,8(s1)
    8000409c:	4785                	li	a5,1
    8000409e:	02f70363          	beq	a4,a5,800040c4 <iput+0x48>
  ip->ref--;
    800040a2:	449c                	lw	a5,8(s1)
    800040a4:	37fd                	addiw	a5,a5,-1
    800040a6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800040a8:	0004a517          	auipc	a0,0x4a
    800040ac:	1c850513          	addi	a0,a0,456 # 8004e270 <icache>
    800040b0:	ffffd097          	auipc	ra,0xffffd
    800040b4:	d3e080e7          	jalr	-706(ra) # 80000dee <release>
}
    800040b8:	60e2                	ld	ra,24(sp)
    800040ba:	6442                	ld	s0,16(sp)
    800040bc:	64a2                	ld	s1,8(sp)
    800040be:	6902                	ld	s2,0(sp)
    800040c0:	6105                	addi	sp,sp,32
    800040c2:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800040c4:	40bc                	lw	a5,64(s1)
    800040c6:	dff1                	beqz	a5,800040a2 <iput+0x26>
    800040c8:	04a49783          	lh	a5,74(s1)
    800040cc:	fbf9                	bnez	a5,800040a2 <iput+0x26>
    acquiresleep(&ip->lock);
    800040ce:	01048913          	addi	s2,s1,16
    800040d2:	854a                	mv	a0,s2
    800040d4:	00001097          	auipc	ra,0x1
    800040d8:	aac080e7          	jalr	-1364(ra) # 80004b80 <acquiresleep>
    release(&icache.lock);
    800040dc:	0004a517          	auipc	a0,0x4a
    800040e0:	19450513          	addi	a0,a0,404 # 8004e270 <icache>
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	d0a080e7          	jalr	-758(ra) # 80000dee <release>
    itrunc(ip);
    800040ec:	8526                	mv	a0,s1
    800040ee:	00000097          	auipc	ra,0x0
    800040f2:	ee2080e7          	jalr	-286(ra) # 80003fd0 <itrunc>
    ip->type = 0;
    800040f6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800040fa:	8526                	mv	a0,s1
    800040fc:	00000097          	auipc	ra,0x0
    80004100:	cfc080e7          	jalr	-772(ra) # 80003df8 <iupdate>
    ip->valid = 0;
    80004104:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004108:	854a                	mv	a0,s2
    8000410a:	00001097          	auipc	ra,0x1
    8000410e:	acc080e7          	jalr	-1332(ra) # 80004bd6 <releasesleep>
    acquire(&icache.lock);
    80004112:	0004a517          	auipc	a0,0x4a
    80004116:	15e50513          	addi	a0,a0,350 # 8004e270 <icache>
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	c20080e7          	jalr	-992(ra) # 80000d3a <acquire>
    80004122:	b741                	j	800040a2 <iput+0x26>

0000000080004124 <iunlockput>:
void iunlockput(struct inode *ip) {
    80004124:	1101                	addi	sp,sp,-32
    80004126:	ec06                	sd	ra,24(sp)
    80004128:	e822                	sd	s0,16(sp)
    8000412a:	e426                	sd	s1,8(sp)
    8000412c:	1000                	addi	s0,sp,32
    8000412e:	84aa                	mv	s1,a0
  iunlock(ip);
    80004130:	00000097          	auipc	ra,0x0
    80004134:	e54080e7          	jalr	-428(ra) # 80003f84 <iunlock>
  iput(ip);
    80004138:	8526                	mv	a0,s1
    8000413a:	00000097          	auipc	ra,0x0
    8000413e:	f42080e7          	jalr	-190(ra) # 8000407c <iput>
}
    80004142:	60e2                	ld	ra,24(sp)
    80004144:	6442                	ld	s0,16(sp)
    80004146:	64a2                	ld	s1,8(sp)
    80004148:	6105                	addi	sp,sp,32
    8000414a:	8082                	ret

000000008000414c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    8000414c:	1141                	addi	sp,sp,-16
    8000414e:	e422                	sd	s0,8(sp)
    80004150:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004152:	411c                	lw	a5,0(a0)
    80004154:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004156:	415c                	lw	a5,4(a0)
    80004158:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000415a:	04451783          	lh	a5,68(a0)
    8000415e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004162:	04a51783          	lh	a5,74(a0)
    80004166:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000416a:	04c56783          	lwu	a5,76(a0)
    8000416e:	e99c                	sd	a5,16(a1)
}
    80004170:	6422                	ld	s0,8(sp)
    80004172:	0141                	addi	sp,sp,16
    80004174:	8082                	ret

0000000080004176 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80004176:	457c                	lw	a5,76(a0)
    80004178:	0ed7e963          	bltu	a5,a3,8000426a <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    8000417c:	7159                	addi	sp,sp,-112
    8000417e:	f486                	sd	ra,104(sp)
    80004180:	f0a2                	sd	s0,96(sp)
    80004182:	eca6                	sd	s1,88(sp)
    80004184:	e8ca                	sd	s2,80(sp)
    80004186:	e4ce                	sd	s3,72(sp)
    80004188:	e0d2                	sd	s4,64(sp)
    8000418a:	fc56                	sd	s5,56(sp)
    8000418c:	f85a                	sd	s6,48(sp)
    8000418e:	f45e                	sd	s7,40(sp)
    80004190:	f062                	sd	s8,32(sp)
    80004192:	ec66                	sd	s9,24(sp)
    80004194:	e86a                	sd	s10,16(sp)
    80004196:	e46e                	sd	s11,8(sp)
    80004198:	1880                	addi	s0,sp,112
    8000419a:	8baa                	mv	s7,a0
    8000419c:	8c2e                	mv	s8,a1
    8000419e:	8ab2                	mv	s5,a2
    800041a0:	84b6                	mv	s1,a3
    800041a2:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    800041a4:	9f35                	addw	a4,a4,a3
    return 0;
    800041a6:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    800041a8:	0ad76063          	bltu	a4,a3,80004248 <readi+0xd2>
  if (off + n > ip->size)
    800041ac:	00e7f463          	bgeu	a5,a4,800041b4 <readi+0x3e>
    n = ip->size - off;
    800041b0:	40d78b3b          	subw	s6,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800041b4:	0a0b0963          	beqz	s6,80004266 <readi+0xf0>
    800041b8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    m = min(n - tot, BSIZE - off % BSIZE);
    800041ba:	40000d13          	li	s10,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800041be:	5cfd                	li	s9,-1
    800041c0:	a82d                	j	800041fa <readi+0x84>
    800041c2:	020a1d93          	slli	s11,s4,0x20
    800041c6:	020ddd93          	srli	s11,s11,0x20
    800041ca:	05890793          	addi	a5,s2,88
    800041ce:	86ee                	mv	a3,s11
    800041d0:	963e                	add	a2,a2,a5
    800041d2:	85d6                	mv	a1,s5
    800041d4:	8562                	mv	a0,s8
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	9a8080e7          	jalr	-1624(ra) # 80002b7e <either_copyout>
    800041de:	05950d63          	beq	a0,s9,80004238 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800041e2:	854a                	mv	a0,s2
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	60c080e7          	jalr	1548(ra) # 800037f0 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800041ec:	013a09bb          	addw	s3,s4,s3
    800041f0:	009a04bb          	addw	s1,s4,s1
    800041f4:	9aee                	add	s5,s5,s11
    800041f6:	0569f763          	bgeu	s3,s6,80004244 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    800041fa:	000ba903          	lw	s2,0(s7)
    800041fe:	00a4d59b          	srliw	a1,s1,0xa
    80004202:	855e                	mv	a0,s7
    80004204:	00000097          	auipc	ra,0x0
    80004208:	8b0080e7          	jalr	-1872(ra) # 80003ab4 <bmap>
    8000420c:	0005059b          	sext.w	a1,a0
    80004210:	854a                	mv	a0,s2
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	4ae080e7          	jalr	1198(ra) # 800036c0 <bread>
    8000421a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000421c:	3ff4f613          	andi	a2,s1,1023
    80004220:	40cd07bb          	subw	a5,s10,a2
    80004224:	413b073b          	subw	a4,s6,s3
    80004228:	8a3e                	mv	s4,a5
    8000422a:	2781                	sext.w	a5,a5
    8000422c:	0007069b          	sext.w	a3,a4
    80004230:	f8f6f9e3          	bgeu	a3,a5,800041c2 <readi+0x4c>
    80004234:	8a3a                	mv	s4,a4
    80004236:	b771                	j	800041c2 <readi+0x4c>
      brelse(bp);
    80004238:	854a                	mv	a0,s2
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	5b6080e7          	jalr	1462(ra) # 800037f0 <brelse>
      tot = -1;
    80004242:	59fd                	li	s3,-1
  }
  return tot;
    80004244:	0009851b          	sext.w	a0,s3
}
    80004248:	70a6                	ld	ra,104(sp)
    8000424a:	7406                	ld	s0,96(sp)
    8000424c:	64e6                	ld	s1,88(sp)
    8000424e:	6946                	ld	s2,80(sp)
    80004250:	69a6                	ld	s3,72(sp)
    80004252:	6a06                	ld	s4,64(sp)
    80004254:	7ae2                	ld	s5,56(sp)
    80004256:	7b42                	ld	s6,48(sp)
    80004258:	7ba2                	ld	s7,40(sp)
    8000425a:	7c02                	ld	s8,32(sp)
    8000425c:	6ce2                	ld	s9,24(sp)
    8000425e:	6d42                	ld	s10,16(sp)
    80004260:	6da2                	ld	s11,8(sp)
    80004262:	6165                	addi	sp,sp,112
    80004264:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004266:	89da                	mv	s3,s6
    80004268:	bff1                	j	80004244 <readi+0xce>
    return 0;
    8000426a:	4501                	li	a0,0
}
    8000426c:	8082                	ret

000000008000426e <writei>:
// otherwise, src is a kernel address.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000426e:	457c                	lw	a5,76(a0)
    80004270:	10d7e763          	bltu	a5,a3,8000437e <writei+0x110>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80004274:	7159                	addi	sp,sp,-112
    80004276:	f486                	sd	ra,104(sp)
    80004278:	f0a2                	sd	s0,96(sp)
    8000427a:	eca6                	sd	s1,88(sp)
    8000427c:	e8ca                	sd	s2,80(sp)
    8000427e:	e4ce                	sd	s3,72(sp)
    80004280:	e0d2                	sd	s4,64(sp)
    80004282:	fc56                	sd	s5,56(sp)
    80004284:	f85a                	sd	s6,48(sp)
    80004286:	f45e                	sd	s7,40(sp)
    80004288:	f062                	sd	s8,32(sp)
    8000428a:	ec66                	sd	s9,24(sp)
    8000428c:	e86a                	sd	s10,16(sp)
    8000428e:	e46e                	sd	s11,8(sp)
    80004290:	1880                	addi	s0,sp,112
    80004292:	8baa                	mv	s7,a0
    80004294:	8c2e                	mv	s8,a1
    80004296:	8ab2                	mv	s5,a2
    80004298:	8936                	mv	s2,a3
    8000429a:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    8000429c:	00e687bb          	addw	a5,a3,a4
    800042a0:	0ed7e163          	bltu	a5,a3,80004382 <writei+0x114>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    800042a4:	00043737          	lui	a4,0x43
    800042a8:	0cf76f63          	bltu	a4,a5,80004386 <writei+0x118>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800042ac:	0a0b0863          	beqz	s6,8000435c <writei+0xee>
    800042b0:	4a01                	li	s4,0

    // * any update will be applied on buffer block,later write back to disk in
    // batch
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    m = min(n - tot, BSIZE - off % BSIZE);
    800042b2:	40000d13          	li	s10,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800042b6:	5cfd                	li	s9,-1
    800042b8:	a091                	j	800042fc <writei+0x8e>
    800042ba:	02099d93          	slli	s11,s3,0x20
    800042be:	020ddd93          	srli	s11,s11,0x20
    800042c2:	05848793          	addi	a5,s1,88
    800042c6:	86ee                	mv	a3,s11
    800042c8:	8656                	mv	a2,s5
    800042ca:	85e2                	mv	a1,s8
    800042cc:	953e                	add	a0,a0,a5
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	906080e7          	jalr	-1786(ra) # 80002bd4 <either_copyin>
    800042d6:	07950263          	beq	a0,s9,8000433a <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    800042da:	8526                	mv	a0,s1
    800042dc:	00000097          	auipc	ra,0x0
    800042e0:	77c080e7          	jalr	1916(ra) # 80004a58 <log_write>
    brelse(bp);
    800042e4:	8526                	mv	a0,s1
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	50a080e7          	jalr	1290(ra) # 800037f0 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800042ee:	01498a3b          	addw	s4,s3,s4
    800042f2:	0129893b          	addw	s2,s3,s2
    800042f6:	9aee                	add	s5,s5,s11
    800042f8:	056a7763          	bgeu	s4,s6,80004346 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    800042fc:	000ba483          	lw	s1,0(s7)
    80004300:	00a9559b          	srliw	a1,s2,0xa
    80004304:	855e                	mv	a0,s7
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	7ae080e7          	jalr	1966(ra) # 80003ab4 <bmap>
    8000430e:	0005059b          	sext.w	a1,a0
    80004312:	8526                	mv	a0,s1
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	3ac080e7          	jalr	940(ra) # 800036c0 <bread>
    8000431c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000431e:	3ff97513          	andi	a0,s2,1023
    80004322:	40ad07bb          	subw	a5,s10,a0
    80004326:	414b073b          	subw	a4,s6,s4
    8000432a:	89be                	mv	s3,a5
    8000432c:	2781                	sext.w	a5,a5
    8000432e:	0007069b          	sext.w	a3,a4
    80004332:	f8f6f4e3          	bgeu	a3,a5,800042ba <writei+0x4c>
    80004336:	89ba                	mv	s3,a4
    80004338:	b749                	j	800042ba <writei+0x4c>
      brelse(bp);
    8000433a:	8526                	mv	a0,s1
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	4b4080e7          	jalr	1204(ra) # 800037f0 <brelse>
      n = -1;
    80004344:	5b7d                	li	s6,-1
  }

  if (n > 0) {
    if (off > ip->size)
    80004346:	04cba783          	lw	a5,76(s7)
    8000434a:	0127f463          	bgeu	a5,s2,80004352 <writei+0xe4>
      ip->size = off;
    8000434e:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80004352:	855e                	mv	a0,s7
    80004354:	00000097          	auipc	ra,0x0
    80004358:	aa4080e7          	jalr	-1372(ra) # 80003df8 <iupdate>
  }

  return n;
    8000435c:	000b051b          	sext.w	a0,s6
}
    80004360:	70a6                	ld	ra,104(sp)
    80004362:	7406                	ld	s0,96(sp)
    80004364:	64e6                	ld	s1,88(sp)
    80004366:	6946                	ld	s2,80(sp)
    80004368:	69a6                	ld	s3,72(sp)
    8000436a:	6a06                	ld	s4,64(sp)
    8000436c:	7ae2                	ld	s5,56(sp)
    8000436e:	7b42                	ld	s6,48(sp)
    80004370:	7ba2                	ld	s7,40(sp)
    80004372:	7c02                	ld	s8,32(sp)
    80004374:	6ce2                	ld	s9,24(sp)
    80004376:	6d42                	ld	s10,16(sp)
    80004378:	6da2                	ld	s11,8(sp)
    8000437a:	6165                	addi	sp,sp,112
    8000437c:	8082                	ret
    return -1;
    8000437e:	557d                	li	a0,-1
}
    80004380:	8082                	ret
    return -1;
    80004382:	557d                	li	a0,-1
    80004384:	bff1                	j	80004360 <writei+0xf2>
    return -1;
    80004386:	557d                	li	a0,-1
    80004388:	bfe1                	j	80004360 <writei+0xf2>

000000008000438a <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    8000438a:	1141                	addi	sp,sp,-16
    8000438c:	e406                	sd	ra,8(sp)
    8000438e:	e022                	sd	s0,0(sp)
    80004390:	0800                	addi	s0,sp,16
    80004392:	4639                	li	a2,14
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	b7a080e7          	jalr	-1158(ra) # 80000f0e <strncmp>
    8000439c:	60a2                	ld	ra,8(sp)
    8000439e:	6402                	ld	s0,0(sp)
    800043a0:	0141                	addi	sp,sp,16
    800043a2:	8082                	ret

00000000800043a4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    800043a4:	7139                	addi	sp,sp,-64
    800043a6:	fc06                	sd	ra,56(sp)
    800043a8:	f822                	sd	s0,48(sp)
    800043aa:	f426                	sd	s1,40(sp)
    800043ac:	f04a                	sd	s2,32(sp)
    800043ae:	ec4e                	sd	s3,24(sp)
    800043b0:	e852                	sd	s4,16(sp)
    800043b2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    800043b4:	04451703          	lh	a4,68(a0)
    800043b8:	4785                	li	a5,1
    800043ba:	00f71a63          	bne	a4,a5,800043ce <dirlookup+0x2a>
    800043be:	892a                	mv	s2,a0
    800043c0:	89ae                	mv	s3,a1
    800043c2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800043c4:	457c                	lw	a5,76(a0)
    800043c6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800043c8:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800043ca:	e79d                	bnez	a5,800043f8 <dirlookup+0x54>
    800043cc:	a8a5                	j	80004444 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800043ce:	00004517          	auipc	a0,0x4
    800043d2:	37a50513          	addi	a0,a0,890 # 80008748 <syscalls+0x1c0>
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	20e080e7          	jalr	526(ra) # 800005e4 <panic>
      panic("dirlookup read");
    800043de:	00004517          	auipc	a0,0x4
    800043e2:	38250513          	addi	a0,a0,898 # 80008760 <syscalls+0x1d8>
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	1fe080e7          	jalr	510(ra) # 800005e4 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800043ee:	24c1                	addiw	s1,s1,16
    800043f0:	04c92783          	lw	a5,76(s2)
    800043f4:	04f4f763          	bgeu	s1,a5,80004442 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043f8:	4741                	li	a4,16
    800043fa:	86a6                	mv	a3,s1
    800043fc:	fc040613          	addi	a2,s0,-64
    80004400:	4581                	li	a1,0
    80004402:	854a                	mv	a0,s2
    80004404:	00000097          	auipc	ra,0x0
    80004408:	d72080e7          	jalr	-654(ra) # 80004176 <readi>
    8000440c:	47c1                	li	a5,16
    8000440e:	fcf518e3          	bne	a0,a5,800043de <dirlookup+0x3a>
    if (de.inum == 0)
    80004412:	fc045783          	lhu	a5,-64(s0)
    80004416:	dfe1                	beqz	a5,800043ee <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80004418:	fc240593          	addi	a1,s0,-62
    8000441c:	854e                	mv	a0,s3
    8000441e:	00000097          	auipc	ra,0x0
    80004422:	f6c080e7          	jalr	-148(ra) # 8000438a <namecmp>
    80004426:	f561                	bnez	a0,800043ee <dirlookup+0x4a>
      if (poff)
    80004428:	000a0463          	beqz	s4,80004430 <dirlookup+0x8c>
        *poff = off;
    8000442c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004430:	fc045583          	lhu	a1,-64(s0)
    80004434:	00092503          	lw	a0,0(s2)
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	756080e7          	jalr	1878(ra) # 80003b8e <iget>
    80004440:	a011                	j	80004444 <dirlookup+0xa0>
  return 0;
    80004442:	4501                	li	a0,0
}
    80004444:	70e2                	ld	ra,56(sp)
    80004446:	7442                	ld	s0,48(sp)
    80004448:	74a2                	ld	s1,40(sp)
    8000444a:	7902                	ld	s2,32(sp)
    8000444c:	69e2                	ld	s3,24(sp)
    8000444e:	6a42                	ld	s4,16(sp)
    80004450:	6121                	addi	sp,sp,64
    80004452:	8082                	ret

0000000080004454 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    80004454:	711d                	addi	sp,sp,-96
    80004456:	ec86                	sd	ra,88(sp)
    80004458:	e8a2                	sd	s0,80(sp)
    8000445a:	e4a6                	sd	s1,72(sp)
    8000445c:	e0ca                	sd	s2,64(sp)
    8000445e:	fc4e                	sd	s3,56(sp)
    80004460:	f852                	sd	s4,48(sp)
    80004462:	f456                	sd	s5,40(sp)
    80004464:	f05a                	sd	s6,32(sp)
    80004466:	ec5e                	sd	s7,24(sp)
    80004468:	e862                	sd	s8,16(sp)
    8000446a:	e466                	sd	s9,8(sp)
    8000446c:	1080                	addi	s0,sp,96
    8000446e:	84aa                	mv	s1,a0
    80004470:	8aae                	mv	s5,a1
    80004472:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if (*path == '/')
    80004474:	00054703          	lbu	a4,0(a0)
    80004478:	02f00793          	li	a5,47
    8000447c:	02f70363          	beq	a4,a5,800044a2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004480:	ffffe097          	auipc	ra,0xffffe
    80004484:	c5c080e7          	jalr	-932(ra) # 800020dc <myproc>
    80004488:	16053503          	ld	a0,352(a0)
    8000448c:	00000097          	auipc	ra,0x0
    80004490:	9f8080e7          	jalr	-1544(ra) # 80003e84 <idup>
    80004494:	89aa                	mv	s3,a0
  while (*path == '/')
    80004496:	02f00913          	li	s2,47
  len = path - s;
    8000449a:	4b01                	li	s6,0
  if (len >= DIRSIZ)
    8000449c:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    8000449e:	4b85                	li	s7,1
    800044a0:	a865                	j	80004558 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800044a2:	4585                	li	a1,1
    800044a4:	4505                	li	a0,1
    800044a6:	fffff097          	auipc	ra,0xfffff
    800044aa:	6e8080e7          	jalr	1768(ra) # 80003b8e <iget>
    800044ae:	89aa                	mv	s3,a0
    800044b0:	b7dd                	j	80004496 <namex+0x42>
      iunlockput(ip);
    800044b2:	854e                	mv	a0,s3
    800044b4:	00000097          	auipc	ra,0x0
    800044b8:	c70080e7          	jalr	-912(ra) # 80004124 <iunlockput>
      return 0;
    800044bc:	4981                	li	s3,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800044be:	854e                	mv	a0,s3
    800044c0:	60e6                	ld	ra,88(sp)
    800044c2:	6446                	ld	s0,80(sp)
    800044c4:	64a6                	ld	s1,72(sp)
    800044c6:	6906                	ld	s2,64(sp)
    800044c8:	79e2                	ld	s3,56(sp)
    800044ca:	7a42                	ld	s4,48(sp)
    800044cc:	7aa2                	ld	s5,40(sp)
    800044ce:	7b02                	ld	s6,32(sp)
    800044d0:	6be2                	ld	s7,24(sp)
    800044d2:	6c42                	ld	s8,16(sp)
    800044d4:	6ca2                	ld	s9,8(sp)
    800044d6:	6125                	addi	sp,sp,96
    800044d8:	8082                	ret
      iunlock(ip);
    800044da:	854e                	mv	a0,s3
    800044dc:	00000097          	auipc	ra,0x0
    800044e0:	aa8080e7          	jalr	-1368(ra) # 80003f84 <iunlock>
      return ip;
    800044e4:	bfe9                	j	800044be <namex+0x6a>
      iunlockput(ip);
    800044e6:	854e                	mv	a0,s3
    800044e8:	00000097          	auipc	ra,0x0
    800044ec:	c3c080e7          	jalr	-964(ra) # 80004124 <iunlockput>
      return 0;
    800044f0:	89e6                	mv	s3,s9
    800044f2:	b7f1                	j	800044be <namex+0x6a>
  len = path - s;
    800044f4:	40b48633          	sub	a2,s1,a1
    800044f8:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    800044fc:	099c5463          	bge	s8,s9,80004584 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80004500:	4639                	li	a2,14
    80004502:	8552                	mv	a0,s4
    80004504:	ffffd097          	auipc	ra,0xffffd
    80004508:	98e080e7          	jalr	-1650(ra) # 80000e92 <memmove>
  while (*path == '/')
    8000450c:	0004c783          	lbu	a5,0(s1)
    80004510:	01279763          	bne	a5,s2,8000451e <namex+0xca>
    path++;
    80004514:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004516:	0004c783          	lbu	a5,0(s1)
    8000451a:	ff278de3          	beq	a5,s2,80004514 <namex+0xc0>
    ilock(ip);
    8000451e:	854e                	mv	a0,s3
    80004520:	00000097          	auipc	ra,0x0
    80004524:	9a2080e7          	jalr	-1630(ra) # 80003ec2 <ilock>
    if (ip->type != T_DIR) {
    80004528:	04499783          	lh	a5,68(s3)
    8000452c:	f97793e3          	bne	a5,s7,800044b2 <namex+0x5e>
    if (nameiparent && *path == '\0') {
    80004530:	000a8563          	beqz	s5,8000453a <namex+0xe6>
    80004534:	0004c783          	lbu	a5,0(s1)
    80004538:	d3cd                	beqz	a5,800044da <namex+0x86>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    8000453a:	865a                	mv	a2,s6
    8000453c:	85d2                	mv	a1,s4
    8000453e:	854e                	mv	a0,s3
    80004540:	00000097          	auipc	ra,0x0
    80004544:	e64080e7          	jalr	-412(ra) # 800043a4 <dirlookup>
    80004548:	8caa                	mv	s9,a0
    8000454a:	dd51                	beqz	a0,800044e6 <namex+0x92>
    iunlockput(ip);
    8000454c:	854e                	mv	a0,s3
    8000454e:	00000097          	auipc	ra,0x0
    80004552:	bd6080e7          	jalr	-1066(ra) # 80004124 <iunlockput>
    ip = next;
    80004556:	89e6                	mv	s3,s9
  while (*path == '/')
    80004558:	0004c783          	lbu	a5,0(s1)
    8000455c:	05279763          	bne	a5,s2,800045aa <namex+0x156>
    path++;
    80004560:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004562:	0004c783          	lbu	a5,0(s1)
    80004566:	ff278de3          	beq	a5,s2,80004560 <namex+0x10c>
  if (*path == 0)
    8000456a:	c79d                	beqz	a5,80004598 <namex+0x144>
    path++;
    8000456c:	85a6                	mv	a1,s1
  len = path - s;
    8000456e:	8cda                	mv	s9,s6
    80004570:	865a                	mv	a2,s6
  while (*path != '/' && *path != 0)
    80004572:	01278963          	beq	a5,s2,80004584 <namex+0x130>
    80004576:	dfbd                	beqz	a5,800044f4 <namex+0xa0>
    path++;
    80004578:	0485                	addi	s1,s1,1
  while (*path != '/' && *path != 0)
    8000457a:	0004c783          	lbu	a5,0(s1)
    8000457e:	ff279ce3          	bne	a5,s2,80004576 <namex+0x122>
    80004582:	bf8d                	j	800044f4 <namex+0xa0>
    memmove(name, s, len);
    80004584:	2601                	sext.w	a2,a2
    80004586:	8552                	mv	a0,s4
    80004588:	ffffd097          	auipc	ra,0xffffd
    8000458c:	90a080e7          	jalr	-1782(ra) # 80000e92 <memmove>
    name[len] = 0;
    80004590:	9cd2                	add	s9,s9,s4
    80004592:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004596:	bf9d                	j	8000450c <namex+0xb8>
  if (nameiparent) {
    80004598:	f20a83e3          	beqz	s5,800044be <namex+0x6a>
    iput(ip);
    8000459c:	854e                	mv	a0,s3
    8000459e:	00000097          	auipc	ra,0x0
    800045a2:	ade080e7          	jalr	-1314(ra) # 8000407c <iput>
    return 0;
    800045a6:	4981                	li	s3,0
    800045a8:	bf19                	j	800044be <namex+0x6a>
  if (*path == 0)
    800045aa:	d7fd                	beqz	a5,80004598 <namex+0x144>
  while (*path != '/' && *path != 0)
    800045ac:	0004c783          	lbu	a5,0(s1)
    800045b0:	85a6                	mv	a1,s1
    800045b2:	b7d1                	j	80004576 <namex+0x122>

00000000800045b4 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    800045b4:	7139                	addi	sp,sp,-64
    800045b6:	fc06                	sd	ra,56(sp)
    800045b8:	f822                	sd	s0,48(sp)
    800045ba:	f426                	sd	s1,40(sp)
    800045bc:	f04a                	sd	s2,32(sp)
    800045be:	ec4e                	sd	s3,24(sp)
    800045c0:	e852                	sd	s4,16(sp)
    800045c2:	0080                	addi	s0,sp,64
    800045c4:	892a                	mv	s2,a0
    800045c6:	8a2e                	mv	s4,a1
    800045c8:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800045ca:	4601                	li	a2,0
    800045cc:	00000097          	auipc	ra,0x0
    800045d0:	dd8080e7          	jalr	-552(ra) # 800043a4 <dirlookup>
    800045d4:	e93d                	bnez	a0,8000464a <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800045d6:	04c92483          	lw	s1,76(s2)
    800045da:	c49d                	beqz	s1,80004608 <dirlink+0x54>
    800045dc:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045de:	4741                	li	a4,16
    800045e0:	86a6                	mv	a3,s1
    800045e2:	fc040613          	addi	a2,s0,-64
    800045e6:	4581                	li	a1,0
    800045e8:	854a                	mv	a0,s2
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	b8c080e7          	jalr	-1140(ra) # 80004176 <readi>
    800045f2:	47c1                	li	a5,16
    800045f4:	06f51163          	bne	a0,a5,80004656 <dirlink+0xa2>
    if (de.inum == 0)
    800045f8:	fc045783          	lhu	a5,-64(s0)
    800045fc:	c791                	beqz	a5,80004608 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800045fe:	24c1                	addiw	s1,s1,16
    80004600:	04c92783          	lw	a5,76(s2)
    80004604:	fcf4ede3          	bltu	s1,a5,800045de <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004608:	4639                	li	a2,14
    8000460a:	85d2                	mv	a1,s4
    8000460c:	fc240513          	addi	a0,s0,-62
    80004610:	ffffd097          	auipc	ra,0xffffd
    80004614:	93a080e7          	jalr	-1734(ra) # 80000f4a <strncpy>
  de.inum = inum;
    80004618:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000461c:	4741                	li	a4,16
    8000461e:	86a6                	mv	a3,s1
    80004620:	fc040613          	addi	a2,s0,-64
    80004624:	4581                	li	a1,0
    80004626:	854a                	mv	a0,s2
    80004628:	00000097          	auipc	ra,0x0
    8000462c:	c46080e7          	jalr	-954(ra) # 8000426e <writei>
    80004630:	872a                	mv	a4,a0
    80004632:	47c1                	li	a5,16
  return 0;
    80004634:	4501                	li	a0,0
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004636:	02f71863          	bne	a4,a5,80004666 <dirlink+0xb2>
}
    8000463a:	70e2                	ld	ra,56(sp)
    8000463c:	7442                	ld	s0,48(sp)
    8000463e:	74a2                	ld	s1,40(sp)
    80004640:	7902                	ld	s2,32(sp)
    80004642:	69e2                	ld	s3,24(sp)
    80004644:	6a42                	ld	s4,16(sp)
    80004646:	6121                	addi	sp,sp,64
    80004648:	8082                	ret
    iput(ip);
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	a32080e7          	jalr	-1486(ra) # 8000407c <iput>
    return -1;
    80004652:	557d                	li	a0,-1
    80004654:	b7dd                	j	8000463a <dirlink+0x86>
      panic("dirlink read");
    80004656:	00004517          	auipc	a0,0x4
    8000465a:	11a50513          	addi	a0,a0,282 # 80008770 <syscalls+0x1e8>
    8000465e:	ffffc097          	auipc	ra,0xffffc
    80004662:	f86080e7          	jalr	-122(ra) # 800005e4 <panic>
    panic("dirlink");
    80004666:	00004517          	auipc	a0,0x4
    8000466a:	22a50513          	addi	a0,a0,554 # 80008890 <syscalls+0x308>
    8000466e:	ffffc097          	auipc	ra,0xffffc
    80004672:	f76080e7          	jalr	-138(ra) # 800005e4 <panic>

0000000080004676 <namei>:

struct inode *namei(char *path) {
    80004676:	1101                	addi	sp,sp,-32
    80004678:	ec06                	sd	ra,24(sp)
    8000467a:	e822                	sd	s0,16(sp)
    8000467c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000467e:	fe040613          	addi	a2,s0,-32
    80004682:	4581                	li	a1,0
    80004684:	00000097          	auipc	ra,0x0
    80004688:	dd0080e7          	jalr	-560(ra) # 80004454 <namex>
}
    8000468c:	60e2                	ld	ra,24(sp)
    8000468e:	6442                	ld	s0,16(sp)
    80004690:	6105                	addi	sp,sp,32
    80004692:	8082                	ret

0000000080004694 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80004694:	1141                	addi	sp,sp,-16
    80004696:	e406                	sd	ra,8(sp)
    80004698:	e022                	sd	s0,0(sp)
    8000469a:	0800                	addi	s0,sp,16
    8000469c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000469e:	4585                	li	a1,1
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	db4080e7          	jalr	-588(ra) # 80004454 <namex>
}
    800046a8:	60a2                	ld	ra,8(sp)
    800046aa:	6402                	ld	s0,0(sp)
    800046ac:	0141                	addi	sp,sp,16
    800046ae:	8082                	ret

00000000800046b0 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    800046b0:	1101                	addi	sp,sp,-32
    800046b2:	ec06                	sd	ra,24(sp)
    800046b4:	e822                	sd	s0,16(sp)
    800046b6:	e426                	sd	s1,8(sp)
    800046b8:	e04a                	sd	s2,0(sp)
    800046ba:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800046bc:	0004b917          	auipc	s2,0x4b
    800046c0:	65c90913          	addi	s2,s2,1628 # 8004fd18 <log>
    800046c4:	01892583          	lw	a1,24(s2)
    800046c8:	02892503          	lw	a0,40(s2)
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	ff4080e7          	jalr	-12(ra) # 800036c0 <bread>
    800046d4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    800046d6:	02c92683          	lw	a3,44(s2)
    800046da:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800046dc:	02d05763          	blez	a3,8000470a <write_head+0x5a>
    800046e0:	0004b797          	auipc	a5,0x4b
    800046e4:	66878793          	addi	a5,a5,1640 # 8004fd48 <log+0x30>
    800046e8:	05c50713          	addi	a4,a0,92
    800046ec:	36fd                	addiw	a3,a3,-1
    800046ee:	1682                	slli	a3,a3,0x20
    800046f0:	9281                	srli	a3,a3,0x20
    800046f2:	068a                	slli	a3,a3,0x2
    800046f4:	0004b617          	auipc	a2,0x4b
    800046f8:	65860613          	addi	a2,a2,1624 # 8004fd4c <log+0x34>
    800046fc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800046fe:	4390                	lw	a2,0(a5)
    80004700:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004702:	0791                	addi	a5,a5,4
    80004704:	0711                	addi	a4,a4,4
    80004706:	fed79ce3          	bne	a5,a3,800046fe <write_head+0x4e>
  }
  bwrite(buf);
    8000470a:	8526                	mv	a0,s1
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	0a6080e7          	jalr	166(ra) # 800037b2 <bwrite>
  brelse(buf);
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	0da080e7          	jalr	218(ra) # 800037f0 <brelse>
}
    8000471e:	60e2                	ld	ra,24(sp)
    80004720:	6442                	ld	s0,16(sp)
    80004722:	64a2                	ld	s1,8(sp)
    80004724:	6902                	ld	s2,0(sp)
    80004726:	6105                	addi	sp,sp,32
    80004728:	8082                	ret

000000008000472a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000472a:	0004b797          	auipc	a5,0x4b
    8000472e:	61a7a783          	lw	a5,1562(a5) # 8004fd44 <log+0x2c>
    80004732:	0af05663          	blez	a5,800047de <install_trans+0xb4>
static void install_trans(void) {
    80004736:	7139                	addi	sp,sp,-64
    80004738:	fc06                	sd	ra,56(sp)
    8000473a:	f822                	sd	s0,48(sp)
    8000473c:	f426                	sd	s1,40(sp)
    8000473e:	f04a                	sd	s2,32(sp)
    80004740:	ec4e                	sd	s3,24(sp)
    80004742:	e852                	sd	s4,16(sp)
    80004744:	e456                	sd	s5,8(sp)
    80004746:	0080                	addi	s0,sp,64
    80004748:	0004ba97          	auipc	s5,0x4b
    8000474c:	600a8a93          	addi	s5,s5,1536 # 8004fd48 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004750:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80004752:	0004b997          	auipc	s3,0x4b
    80004756:	5c698993          	addi	s3,s3,1478 # 8004fd18 <log>
    8000475a:	0189a583          	lw	a1,24(s3)
    8000475e:	014585bb          	addw	a1,a1,s4
    80004762:	2585                	addiw	a1,a1,1
    80004764:	0289a503          	lw	a0,40(s3)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	f58080e7          	jalr	-168(ra) # 800036c0 <bread>
    80004770:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80004772:	000aa583          	lw	a1,0(s5)
    80004776:	0289a503          	lw	a0,40(s3)
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	f46080e7          	jalr	-186(ra) # 800036c0 <bread>
    80004782:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80004784:	40000613          	li	a2,1024
    80004788:	05890593          	addi	a1,s2,88
    8000478c:	05850513          	addi	a0,a0,88
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	702080e7          	jalr	1794(ra) # 80000e92 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80004798:	8526                	mv	a0,s1
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	018080e7          	jalr	24(ra) # 800037b2 <bwrite>
    bunpin(dbuf);
    800047a2:	8526                	mv	a0,s1
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	126080e7          	jalr	294(ra) # 800038ca <bunpin>
    brelse(lbuf);
    800047ac:	854a                	mv	a0,s2
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	042080e7          	jalr	66(ra) # 800037f0 <brelse>
    brelse(dbuf);
    800047b6:	8526                	mv	a0,s1
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	038080e7          	jalr	56(ra) # 800037f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047c0:	2a05                	addiw	s4,s4,1
    800047c2:	0a91                	addi	s5,s5,4
    800047c4:	02c9a783          	lw	a5,44(s3)
    800047c8:	f8fa49e3          	blt	s4,a5,8000475a <install_trans+0x30>
}
    800047cc:	70e2                	ld	ra,56(sp)
    800047ce:	7442                	ld	s0,48(sp)
    800047d0:	74a2                	ld	s1,40(sp)
    800047d2:	7902                	ld	s2,32(sp)
    800047d4:	69e2                	ld	s3,24(sp)
    800047d6:	6a42                	ld	s4,16(sp)
    800047d8:	6aa2                	ld	s5,8(sp)
    800047da:	6121                	addi	sp,sp,64
    800047dc:	8082                	ret
    800047de:	8082                	ret

00000000800047e0 <initlog>:
void initlog(int dev, struct superblock *sb) {
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	ec26                	sd	s1,24(sp)
    800047e8:	e84a                	sd	s2,16(sp)
    800047ea:	e44e                	sd	s3,8(sp)
    800047ec:	1800                	addi	s0,sp,48
    800047ee:	892a                	mv	s2,a0
    800047f0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800047f2:	0004b497          	auipc	s1,0x4b
    800047f6:	52648493          	addi	s1,s1,1318 # 8004fd18 <log>
    800047fa:	00004597          	auipc	a1,0x4
    800047fe:	f8658593          	addi	a1,a1,-122 # 80008780 <syscalls+0x1f8>
    80004802:	8526                	mv	a0,s1
    80004804:	ffffc097          	auipc	ra,0xffffc
    80004808:	4a6080e7          	jalr	1190(ra) # 80000caa <initlock>
  log.start = sb->logstart;
    8000480c:	0149a583          	lw	a1,20(s3)
    80004810:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004812:	0109a783          	lw	a5,16(s3)
    80004816:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004818:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000481c:	854a                	mv	a0,s2
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	ea2080e7          	jalr	-350(ra) # 800036c0 <bread>
  log.lh.n = lh->n;
    80004826:	4d34                	lw	a3,88(a0)
    80004828:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000482a:	02d05563          	blez	a3,80004854 <initlog+0x74>
    8000482e:	05c50793          	addi	a5,a0,92
    80004832:	0004b717          	auipc	a4,0x4b
    80004836:	51670713          	addi	a4,a4,1302 # 8004fd48 <log+0x30>
    8000483a:	36fd                	addiw	a3,a3,-1
    8000483c:	1682                	slli	a3,a3,0x20
    8000483e:	9281                	srli	a3,a3,0x20
    80004840:	068a                	slli	a3,a3,0x2
    80004842:	06050613          	addi	a2,a0,96
    80004846:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004848:	4390                	lw	a2,0(a5)
    8000484a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000484c:	0791                	addi	a5,a5,4
    8000484e:	0711                	addi	a4,a4,4
    80004850:	fed79ce3          	bne	a5,a3,80004848 <initlog+0x68>
  brelse(buf);
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	f9c080e7          	jalr	-100(ra) # 800037f0 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000485c:	00000097          	auipc	ra,0x0
    80004860:	ece080e7          	jalr	-306(ra) # 8000472a <install_trans>
  log.lh.n = 0;
    80004864:	0004b797          	auipc	a5,0x4b
    80004868:	4e07a023          	sw	zero,1248(a5) # 8004fd44 <log+0x2c>
  write_head(); // clear the log
    8000486c:	00000097          	auipc	ra,0x0
    80004870:	e44080e7          	jalr	-444(ra) # 800046b0 <write_head>
}
    80004874:	70a2                	ld	ra,40(sp)
    80004876:	7402                	ld	s0,32(sp)
    80004878:	64e2                	ld	s1,24(sp)
    8000487a:	6942                	ld	s2,16(sp)
    8000487c:	69a2                	ld	s3,8(sp)
    8000487e:	6145                	addi	sp,sp,48
    80004880:	8082                	ret

0000000080004882 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    80004882:	1101                	addi	sp,sp,-32
    80004884:	ec06                	sd	ra,24(sp)
    80004886:	e822                	sd	s0,16(sp)
    80004888:	e426                	sd	s1,8(sp)
    8000488a:	e04a                	sd	s2,0(sp)
    8000488c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000488e:	0004b517          	auipc	a0,0x4b
    80004892:	48a50513          	addi	a0,a0,1162 # 8004fd18 <log>
    80004896:	ffffc097          	auipc	ra,0xffffc
    8000489a:	4a4080e7          	jalr	1188(ra) # 80000d3a <acquire>
  while (1) {
    if (log.committing) {
    8000489e:	0004b497          	auipc	s1,0x4b
    800048a2:	47a48493          	addi	s1,s1,1146 # 8004fd18 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800048a6:	4979                	li	s2,30
    800048a8:	a039                	j	800048b6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800048aa:	85a6                	mv	a1,s1
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	076080e7          	jalr	118(ra) # 80002924 <sleep>
    if (log.committing) {
    800048b6:	50dc                	lw	a5,36(s1)
    800048b8:	fbed                	bnez	a5,800048aa <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800048ba:	509c                	lw	a5,32(s1)
    800048bc:	0017871b          	addiw	a4,a5,1
    800048c0:	0007069b          	sext.w	a3,a4
    800048c4:	0027179b          	slliw	a5,a4,0x2
    800048c8:	9fb9                	addw	a5,a5,a4
    800048ca:	0017979b          	slliw	a5,a5,0x1
    800048ce:	54d8                	lw	a4,44(s1)
    800048d0:	9fb9                	addw	a5,a5,a4
    800048d2:	00f95963          	bge	s2,a5,800048e4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800048d6:	85a6                	mv	a1,s1
    800048d8:	8526                	mv	a0,s1
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	04a080e7          	jalr	74(ra) # 80002924 <sleep>
    800048e2:	bfd1                	j	800048b6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800048e4:	0004b517          	auipc	a0,0x4b
    800048e8:	43450513          	addi	a0,a0,1076 # 8004fd18 <log>
    800048ec:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800048ee:	ffffc097          	auipc	ra,0xffffc
    800048f2:	500080e7          	jalr	1280(ra) # 80000dee <release>
      break;
    }
  }
}
    800048f6:	60e2                	ld	ra,24(sp)
    800048f8:	6442                	ld	s0,16(sp)
    800048fa:	64a2                	ld	s1,8(sp)
    800048fc:	6902                	ld	s2,0(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret

0000000080004902 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    80004902:	7139                	addi	sp,sp,-64
    80004904:	fc06                	sd	ra,56(sp)
    80004906:	f822                	sd	s0,48(sp)
    80004908:	f426                	sd	s1,40(sp)
    8000490a:	f04a                	sd	s2,32(sp)
    8000490c:	ec4e                	sd	s3,24(sp)
    8000490e:	e852                	sd	s4,16(sp)
    80004910:	e456                	sd	s5,8(sp)
    80004912:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004914:	0004b497          	auipc	s1,0x4b
    80004918:	40448493          	addi	s1,s1,1028 # 8004fd18 <log>
    8000491c:	8526                	mv	a0,s1
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	41c080e7          	jalr	1052(ra) # 80000d3a <acquire>
  log.outstanding -= 1;
    80004926:	509c                	lw	a5,32(s1)
    80004928:	37fd                	addiw	a5,a5,-1
    8000492a:	0007891b          	sext.w	s2,a5
    8000492e:	d09c                	sw	a5,32(s1)
  if (log.committing)
    80004930:	50dc                	lw	a5,36(s1)
    80004932:	e7b9                	bnez	a5,80004980 <end_op+0x7e>
    panic("log.committing");
  if (log.outstanding == 0) {
    80004934:	04091e63          	bnez	s2,80004990 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004938:	0004b497          	auipc	s1,0x4b
    8000493c:	3e048493          	addi	s1,s1,992 # 8004fd18 <log>
    80004940:	4785                	li	a5,1
    80004942:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffc097          	auipc	ra,0xffffc
    8000494a:	4a8080e7          	jalr	1192(ra) # 80000dee <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    8000494e:	54dc                	lw	a5,44(s1)
    80004950:	06f04763          	bgtz	a5,800049be <end_op+0xbc>
    acquire(&log.lock);
    80004954:	0004b497          	auipc	s1,0x4b
    80004958:	3c448493          	addi	s1,s1,964 # 8004fd18 <log>
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffc097          	auipc	ra,0xffffc
    80004962:	3dc080e7          	jalr	988(ra) # 80000d3a <acquire>
    log.committing = 0;
    80004966:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	138080e7          	jalr	312(ra) # 80002aa4 <wakeup>
    release(&log.lock);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	478080e7          	jalr	1144(ra) # 80000dee <release>
}
    8000497e:	a03d                	j	800049ac <end_op+0xaa>
    panic("log.committing");
    80004980:	00004517          	auipc	a0,0x4
    80004984:	e0850513          	addi	a0,a0,-504 # 80008788 <syscalls+0x200>
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	c5c080e7          	jalr	-932(ra) # 800005e4 <panic>
    wakeup(&log);
    80004990:	0004b497          	auipc	s1,0x4b
    80004994:	38848493          	addi	s1,s1,904 # 8004fd18 <log>
    80004998:	8526                	mv	a0,s1
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	10a080e7          	jalr	266(ra) # 80002aa4 <wakeup>
  release(&log.lock);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffc097          	auipc	ra,0xffffc
    800049a8:	44a080e7          	jalr	1098(ra) # 80000dee <release>
}
    800049ac:	70e2                	ld	ra,56(sp)
    800049ae:	7442                	ld	s0,48(sp)
    800049b0:	74a2                	ld	s1,40(sp)
    800049b2:	7902                	ld	s2,32(sp)
    800049b4:	69e2                	ld	s3,24(sp)
    800049b6:	6a42                	ld	s4,16(sp)
    800049b8:	6aa2                	ld	s5,8(sp)
    800049ba:	6121                	addi	sp,sp,64
    800049bc:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800049be:	0004ba97          	auipc	s5,0x4b
    800049c2:	38aa8a93          	addi	s5,s5,906 # 8004fd48 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    800049c6:	0004ba17          	auipc	s4,0x4b
    800049ca:	352a0a13          	addi	s4,s4,850 # 8004fd18 <log>
    800049ce:	018a2583          	lw	a1,24(s4)
    800049d2:	012585bb          	addw	a1,a1,s2
    800049d6:	2585                	addiw	a1,a1,1
    800049d8:	028a2503          	lw	a0,40(s4)
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	ce4080e7          	jalr	-796(ra) # 800036c0 <bread>
    800049e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800049e6:	000aa583          	lw	a1,0(s5)
    800049ea:	028a2503          	lw	a0,40(s4)
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	cd2080e7          	jalr	-814(ra) # 800036c0 <bread>
    800049f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800049f8:	40000613          	li	a2,1024
    800049fc:	05850593          	addi	a1,a0,88
    80004a00:	05848513          	addi	a0,s1,88
    80004a04:	ffffc097          	auipc	ra,0xffffc
    80004a08:	48e080e7          	jalr	1166(ra) # 80000e92 <memmove>
    bwrite(to); // write the log
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	da4080e7          	jalr	-604(ra) # 800037b2 <bwrite>
    brelse(from);
    80004a16:	854e                	mv	a0,s3
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	dd8080e7          	jalr	-552(ra) # 800037f0 <brelse>
    brelse(to);
    80004a20:	8526                	mv	a0,s1
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	dce080e7          	jalr	-562(ra) # 800037f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a2a:	2905                	addiw	s2,s2,1
    80004a2c:	0a91                	addi	s5,s5,4
    80004a2e:	02ca2783          	lw	a5,44(s4)
    80004a32:	f8f94ee3          	blt	s2,a5,800049ce <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004a36:	00000097          	auipc	ra,0x0
    80004a3a:	c7a080e7          	jalr	-902(ra) # 800046b0 <write_head>
    install_trans(); // Now install writes to home locations
    80004a3e:	00000097          	auipc	ra,0x0
    80004a42:	cec080e7          	jalr	-788(ra) # 8000472a <install_trans>
    log.lh.n = 0;
    80004a46:	0004b797          	auipc	a5,0x4b
    80004a4a:	2e07af23          	sw	zero,766(a5) # 8004fd44 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004a4e:	00000097          	auipc	ra,0x0
    80004a52:	c62080e7          	jalr	-926(ra) # 800046b0 <write_head>
    80004a56:	bdfd                	j	80004954 <end_op+0x52>

0000000080004a58 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80004a58:	1101                	addi	sp,sp,-32
    80004a5a:	ec06                	sd	ra,24(sp)
    80004a5c:	e822                	sd	s0,16(sp)
    80004a5e:	e426                	sd	s1,8(sp)
    80004a60:	e04a                	sd	s2,0(sp)
    80004a62:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004a64:	0004b717          	auipc	a4,0x4b
    80004a68:	2e072703          	lw	a4,736(a4) # 8004fd44 <log+0x2c>
    80004a6c:	47f5                	li	a5,29
    80004a6e:	08e7c063          	blt	a5,a4,80004aee <log_write+0x96>
    80004a72:	84aa                	mv	s1,a0
    80004a74:	0004b797          	auipc	a5,0x4b
    80004a78:	2c07a783          	lw	a5,704(a5) # 8004fd34 <log+0x1c>
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	06f75863          	bge	a4,a5,80004aee <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004a82:	0004b797          	auipc	a5,0x4b
    80004a86:	2b67a783          	lw	a5,694(a5) # 8004fd38 <log+0x20>
    80004a8a:	06f05a63          	blez	a5,80004afe <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004a8e:	0004b917          	auipc	s2,0x4b
    80004a92:	28a90913          	addi	s2,s2,650 # 8004fd18 <log>
    80004a96:	854a                	mv	a0,s2
    80004a98:	ffffc097          	auipc	ra,0xffffc
    80004a9c:	2a2080e7          	jalr	674(ra) # 80000d3a <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004aa0:	02c92603          	lw	a2,44(s2)
    80004aa4:	06c05563          	blez	a2,80004b0e <log_write+0xb6>
    if (log.lh.block[i] == b->blockno) // log absorbtion
    80004aa8:	44cc                	lw	a1,12(s1)
    80004aaa:	0004b717          	auipc	a4,0x4b
    80004aae:	29e70713          	addi	a4,a4,670 # 8004fd48 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004ab2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorbtion
    80004ab4:	4314                	lw	a3,0(a4)
    80004ab6:	04b68d63          	beq	a3,a1,80004b10 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004aba:	2785                	addiw	a5,a5,1
    80004abc:	0711                	addi	a4,a4,4
    80004abe:	fec79be3          	bne	a5,a2,80004ab4 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004ac2:	0621                	addi	a2,a2,8
    80004ac4:	060a                	slli	a2,a2,0x2
    80004ac6:	0004b797          	auipc	a5,0x4b
    80004aca:	25278793          	addi	a5,a5,594 # 8004fd18 <log>
    80004ace:	963e                	add	a2,a2,a5
    80004ad0:	44dc                	lw	a5,12(s1)
    80004ad2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	db8080e7          	jalr	-584(ra) # 8000388e <bpin>
    log.lh.n++;
    80004ade:	0004b717          	auipc	a4,0x4b
    80004ae2:	23a70713          	addi	a4,a4,570 # 8004fd18 <log>
    80004ae6:	575c                	lw	a5,44(a4)
    80004ae8:	2785                	addiw	a5,a5,1
    80004aea:	d75c                	sw	a5,44(a4)
    80004aec:	a83d                	j	80004b2a <log_write+0xd2>
    panic("too big a transaction");
    80004aee:	00004517          	auipc	a0,0x4
    80004af2:	caa50513          	addi	a0,a0,-854 # 80008798 <syscalls+0x210>
    80004af6:	ffffc097          	auipc	ra,0xffffc
    80004afa:	aee080e7          	jalr	-1298(ra) # 800005e4 <panic>
    panic("log_write outside of trans");
    80004afe:	00004517          	auipc	a0,0x4
    80004b02:	cb250513          	addi	a0,a0,-846 # 800087b0 <syscalls+0x228>
    80004b06:	ffffc097          	auipc	ra,0xffffc
    80004b0a:	ade080e7          	jalr	-1314(ra) # 800005e4 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004b0e:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004b10:	00878713          	addi	a4,a5,8
    80004b14:	00271693          	slli	a3,a4,0x2
    80004b18:	0004b717          	auipc	a4,0x4b
    80004b1c:	20070713          	addi	a4,a4,512 # 8004fd18 <log>
    80004b20:	9736                	add	a4,a4,a3
    80004b22:	44d4                	lw	a3,12(s1)
    80004b24:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004b26:	faf607e3          	beq	a2,a5,80004ad4 <log_write+0x7c>
  }
  release(&log.lock);
    80004b2a:	0004b517          	auipc	a0,0x4b
    80004b2e:	1ee50513          	addi	a0,a0,494 # 8004fd18 <log>
    80004b32:	ffffc097          	auipc	ra,0xffffc
    80004b36:	2bc080e7          	jalr	700(ra) # 80000dee <release>
}
    80004b3a:	60e2                	ld	ra,24(sp)
    80004b3c:	6442                	ld	s0,16(sp)
    80004b3e:	64a2                	ld	s1,8(sp)
    80004b40:	6902                	ld	s2,0(sp)
    80004b42:	6105                	addi	sp,sp,32
    80004b44:	8082                	ret

0000000080004b46 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004b46:	1101                	addi	sp,sp,-32
    80004b48:	ec06                	sd	ra,24(sp)
    80004b4a:	e822                	sd	s0,16(sp)
    80004b4c:	e426                	sd	s1,8(sp)
    80004b4e:	e04a                	sd	s2,0(sp)
    80004b50:	1000                	addi	s0,sp,32
    80004b52:	84aa                	mv	s1,a0
    80004b54:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004b56:	00004597          	auipc	a1,0x4
    80004b5a:	c7a58593          	addi	a1,a1,-902 # 800087d0 <syscalls+0x248>
    80004b5e:	0521                	addi	a0,a0,8
    80004b60:	ffffc097          	auipc	ra,0xffffc
    80004b64:	14a080e7          	jalr	330(ra) # 80000caa <initlock>
  lk->name = name;
    80004b68:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004b6c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b70:	0204a423          	sw	zero,40(s1)
}
    80004b74:	60e2                	ld	ra,24(sp)
    80004b76:	6442                	ld	s0,16(sp)
    80004b78:	64a2                	ld	s1,8(sp)
    80004b7a:	6902                	ld	s2,0(sp)
    80004b7c:	6105                	addi	sp,sp,32
    80004b7e:	8082                	ret

0000000080004b80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004b80:	1101                	addi	sp,sp,-32
    80004b82:	ec06                	sd	ra,24(sp)
    80004b84:	e822                	sd	s0,16(sp)
    80004b86:	e426                	sd	s1,8(sp)
    80004b88:	e04a                	sd	s2,0(sp)
    80004b8a:	1000                	addi	s0,sp,32
    80004b8c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b8e:	00850913          	addi	s2,a0,8
    80004b92:	854a                	mv	a0,s2
    80004b94:	ffffc097          	auipc	ra,0xffffc
    80004b98:	1a6080e7          	jalr	422(ra) # 80000d3a <acquire>
  while (lk->locked) {
    80004b9c:	409c                	lw	a5,0(s1)
    80004b9e:	cb89                	beqz	a5,80004bb0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004ba0:	85ca                	mv	a1,s2
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	d80080e7          	jalr	-640(ra) # 80002924 <sleep>
  while (lk->locked) {
    80004bac:	409c                	lw	a5,0(s1)
    80004bae:	fbed                	bnez	a5,80004ba0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004bb0:	4785                	li	a5,1
    80004bb2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004bb4:	ffffd097          	auipc	ra,0xffffd
    80004bb8:	528080e7          	jalr	1320(ra) # 800020dc <myproc>
    80004bbc:	5d1c                	lw	a5,56(a0)
    80004bbe:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004bc0:	854a                	mv	a0,s2
    80004bc2:	ffffc097          	auipc	ra,0xffffc
    80004bc6:	22c080e7          	jalr	556(ra) # 80000dee <release>
}
    80004bca:	60e2                	ld	ra,24(sp)
    80004bcc:	6442                	ld	s0,16(sp)
    80004bce:	64a2                	ld	s1,8(sp)
    80004bd0:	6902                	ld	s2,0(sp)
    80004bd2:	6105                	addi	sp,sp,32
    80004bd4:	8082                	ret

0000000080004bd6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004bd6:	1101                	addi	sp,sp,-32
    80004bd8:	ec06                	sd	ra,24(sp)
    80004bda:	e822                	sd	s0,16(sp)
    80004bdc:	e426                	sd	s1,8(sp)
    80004bde:	e04a                	sd	s2,0(sp)
    80004be0:	1000                	addi	s0,sp,32
    80004be2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004be4:	00850913          	addi	s2,a0,8
    80004be8:	854a                	mv	a0,s2
    80004bea:	ffffc097          	auipc	ra,0xffffc
    80004bee:	150080e7          	jalr	336(ra) # 80000d3a <acquire>
  lk->locked = 0;
    80004bf2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004bf6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	ea8080e7          	jalr	-344(ra) # 80002aa4 <wakeup>
  release(&lk->lk);
    80004c04:	854a                	mv	a0,s2
    80004c06:	ffffc097          	auipc	ra,0xffffc
    80004c0a:	1e8080e7          	jalr	488(ra) # 80000dee <release>
}
    80004c0e:	60e2                	ld	ra,24(sp)
    80004c10:	6442                	ld	s0,16(sp)
    80004c12:	64a2                	ld	s1,8(sp)
    80004c14:	6902                	ld	s2,0(sp)
    80004c16:	6105                	addi	sp,sp,32
    80004c18:	8082                	ret

0000000080004c1a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004c1a:	7179                	addi	sp,sp,-48
    80004c1c:	f406                	sd	ra,40(sp)
    80004c1e:	f022                	sd	s0,32(sp)
    80004c20:	ec26                	sd	s1,24(sp)
    80004c22:	e84a                	sd	s2,16(sp)
    80004c24:	e44e                	sd	s3,8(sp)
    80004c26:	1800                	addi	s0,sp,48
    80004c28:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004c2a:	00850913          	addi	s2,a0,8
    80004c2e:	854a                	mv	a0,s2
    80004c30:	ffffc097          	auipc	ra,0xffffc
    80004c34:	10a080e7          	jalr	266(ra) # 80000d3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c38:	409c                	lw	a5,0(s1)
    80004c3a:	ef99                	bnez	a5,80004c58 <holdingsleep+0x3e>
    80004c3c:	4481                	li	s1,0
  release(&lk->lk);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	1ae080e7          	jalr	430(ra) # 80000dee <release>
  return r;
}
    80004c48:	8526                	mv	a0,s1
    80004c4a:	70a2                	ld	ra,40(sp)
    80004c4c:	7402                	ld	s0,32(sp)
    80004c4e:	64e2                	ld	s1,24(sp)
    80004c50:	6942                	ld	s2,16(sp)
    80004c52:	69a2                	ld	s3,8(sp)
    80004c54:	6145                	addi	sp,sp,48
    80004c56:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c58:	0284a983          	lw	s3,40(s1)
    80004c5c:	ffffd097          	auipc	ra,0xffffd
    80004c60:	480080e7          	jalr	1152(ra) # 800020dc <myproc>
    80004c64:	5d04                	lw	s1,56(a0)
    80004c66:	413484b3          	sub	s1,s1,s3
    80004c6a:	0014b493          	seqz	s1,s1
    80004c6e:	bfc1                	j	80004c3e <holdingsleep+0x24>

0000000080004c70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004c70:	1141                	addi	sp,sp,-16
    80004c72:	e406                	sd	ra,8(sp)
    80004c74:	e022                	sd	s0,0(sp)
    80004c76:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004c78:	00004597          	auipc	a1,0x4
    80004c7c:	b6858593          	addi	a1,a1,-1176 # 800087e0 <syscalls+0x258>
    80004c80:	0004b517          	auipc	a0,0x4b
    80004c84:	1e050513          	addi	a0,a0,480 # 8004fe60 <ftable>
    80004c88:	ffffc097          	auipc	ra,0xffffc
    80004c8c:	022080e7          	jalr	34(ra) # 80000caa <initlock>
}
    80004c90:	60a2                	ld	ra,8(sp)
    80004c92:	6402                	ld	s0,0(sp)
    80004c94:	0141                	addi	sp,sp,16
    80004c96:	8082                	ret

0000000080004c98 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004c98:	1101                	addi	sp,sp,-32
    80004c9a:	ec06                	sd	ra,24(sp)
    80004c9c:	e822                	sd	s0,16(sp)
    80004c9e:	e426                	sd	s1,8(sp)
    80004ca0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ca2:	0004b517          	auipc	a0,0x4b
    80004ca6:	1be50513          	addi	a0,a0,446 # 8004fe60 <ftable>
    80004caa:	ffffc097          	auipc	ra,0xffffc
    80004cae:	090080e7          	jalr	144(ra) # 80000d3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004cb2:	0004b497          	auipc	s1,0x4b
    80004cb6:	1c648493          	addi	s1,s1,454 # 8004fe78 <ftable+0x18>
    80004cba:	0004c717          	auipc	a4,0x4c
    80004cbe:	15e70713          	addi	a4,a4,350 # 80050e18 <ftable+0xfb8>
    if(f->ref == 0){
    80004cc2:	40dc                	lw	a5,4(s1)
    80004cc4:	cf99                	beqz	a5,80004ce2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004cc6:	02848493          	addi	s1,s1,40
    80004cca:	fee49ce3          	bne	s1,a4,80004cc2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004cce:	0004b517          	auipc	a0,0x4b
    80004cd2:	19250513          	addi	a0,a0,402 # 8004fe60 <ftable>
    80004cd6:	ffffc097          	auipc	ra,0xffffc
    80004cda:	118080e7          	jalr	280(ra) # 80000dee <release>
  return 0;
    80004cde:	4481                	li	s1,0
    80004ce0:	a819                	j	80004cf6 <filealloc+0x5e>
      f->ref = 1;
    80004ce2:	4785                	li	a5,1
    80004ce4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004ce6:	0004b517          	auipc	a0,0x4b
    80004cea:	17a50513          	addi	a0,a0,378 # 8004fe60 <ftable>
    80004cee:	ffffc097          	auipc	ra,0xffffc
    80004cf2:	100080e7          	jalr	256(ra) # 80000dee <release>
}
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	60e2                	ld	ra,24(sp)
    80004cfa:	6442                	ld	s0,16(sp)
    80004cfc:	64a2                	ld	s1,8(sp)
    80004cfe:	6105                	addi	sp,sp,32
    80004d00:	8082                	ret

0000000080004d02 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004d02:	1101                	addi	sp,sp,-32
    80004d04:	ec06                	sd	ra,24(sp)
    80004d06:	e822                	sd	s0,16(sp)
    80004d08:	e426                	sd	s1,8(sp)
    80004d0a:	1000                	addi	s0,sp,32
    80004d0c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004d0e:	0004b517          	auipc	a0,0x4b
    80004d12:	15250513          	addi	a0,a0,338 # 8004fe60 <ftable>
    80004d16:	ffffc097          	auipc	ra,0xffffc
    80004d1a:	024080e7          	jalr	36(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004d1e:	40dc                	lw	a5,4(s1)
    80004d20:	02f05263          	blez	a5,80004d44 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004d24:	2785                	addiw	a5,a5,1
    80004d26:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004d28:	0004b517          	auipc	a0,0x4b
    80004d2c:	13850513          	addi	a0,a0,312 # 8004fe60 <ftable>
    80004d30:	ffffc097          	auipc	ra,0xffffc
    80004d34:	0be080e7          	jalr	190(ra) # 80000dee <release>
  return f;
}
    80004d38:	8526                	mv	a0,s1
    80004d3a:	60e2                	ld	ra,24(sp)
    80004d3c:	6442                	ld	s0,16(sp)
    80004d3e:	64a2                	ld	s1,8(sp)
    80004d40:	6105                	addi	sp,sp,32
    80004d42:	8082                	ret
    panic("filedup");
    80004d44:	00004517          	auipc	a0,0x4
    80004d48:	aa450513          	addi	a0,a0,-1372 # 800087e8 <syscalls+0x260>
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	898080e7          	jalr	-1896(ra) # 800005e4 <panic>

0000000080004d54 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004d54:	7139                	addi	sp,sp,-64
    80004d56:	fc06                	sd	ra,56(sp)
    80004d58:	f822                	sd	s0,48(sp)
    80004d5a:	f426                	sd	s1,40(sp)
    80004d5c:	f04a                	sd	s2,32(sp)
    80004d5e:	ec4e                	sd	s3,24(sp)
    80004d60:	e852                	sd	s4,16(sp)
    80004d62:	e456                	sd	s5,8(sp)
    80004d64:	0080                	addi	s0,sp,64
    80004d66:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004d68:	0004b517          	auipc	a0,0x4b
    80004d6c:	0f850513          	addi	a0,a0,248 # 8004fe60 <ftable>
    80004d70:	ffffc097          	auipc	ra,0xffffc
    80004d74:	fca080e7          	jalr	-54(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004d78:	40dc                	lw	a5,4(s1)
    80004d7a:	06f05163          	blez	a5,80004ddc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004d7e:	37fd                	addiw	a5,a5,-1
    80004d80:	0007871b          	sext.w	a4,a5
    80004d84:	c0dc                	sw	a5,4(s1)
    80004d86:	06e04363          	bgtz	a4,80004dec <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d8a:	0004a903          	lw	s2,0(s1)
    80004d8e:	0094ca83          	lbu	s5,9(s1)
    80004d92:	0104ba03          	ld	s4,16(s1)
    80004d96:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004d9a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004d9e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004da2:	0004b517          	auipc	a0,0x4b
    80004da6:	0be50513          	addi	a0,a0,190 # 8004fe60 <ftable>
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	044080e7          	jalr	68(ra) # 80000dee <release>

  if(ff.type == FD_PIPE){
    80004db2:	4785                	li	a5,1
    80004db4:	04f90d63          	beq	s2,a5,80004e0e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004db8:	3979                	addiw	s2,s2,-2
    80004dba:	4785                	li	a5,1
    80004dbc:	0527e063          	bltu	a5,s2,80004dfc <fileclose+0xa8>
    begin_op();
    80004dc0:	00000097          	auipc	ra,0x0
    80004dc4:	ac2080e7          	jalr	-1342(ra) # 80004882 <begin_op>
    iput(ff.ip);
    80004dc8:	854e                	mv	a0,s3
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	2b2080e7          	jalr	690(ra) # 8000407c <iput>
    end_op();
    80004dd2:	00000097          	auipc	ra,0x0
    80004dd6:	b30080e7          	jalr	-1232(ra) # 80004902 <end_op>
    80004dda:	a00d                	j	80004dfc <fileclose+0xa8>
    panic("fileclose");
    80004ddc:	00004517          	auipc	a0,0x4
    80004de0:	a1450513          	addi	a0,a0,-1516 # 800087f0 <syscalls+0x268>
    80004de4:	ffffc097          	auipc	ra,0xffffc
    80004de8:	800080e7          	jalr	-2048(ra) # 800005e4 <panic>
    release(&ftable.lock);
    80004dec:	0004b517          	auipc	a0,0x4b
    80004df0:	07450513          	addi	a0,a0,116 # 8004fe60 <ftable>
    80004df4:	ffffc097          	auipc	ra,0xffffc
    80004df8:	ffa080e7          	jalr	-6(ra) # 80000dee <release>
  }
}
    80004dfc:	70e2                	ld	ra,56(sp)
    80004dfe:	7442                	ld	s0,48(sp)
    80004e00:	74a2                	ld	s1,40(sp)
    80004e02:	7902                	ld	s2,32(sp)
    80004e04:	69e2                	ld	s3,24(sp)
    80004e06:	6a42                	ld	s4,16(sp)
    80004e08:	6aa2                	ld	s5,8(sp)
    80004e0a:	6121                	addi	sp,sp,64
    80004e0c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004e0e:	85d6                	mv	a1,s5
    80004e10:	8552                	mv	a0,s4
    80004e12:	00000097          	auipc	ra,0x0
    80004e16:	372080e7          	jalr	882(ra) # 80005184 <pipeclose>
    80004e1a:	b7cd                	j	80004dfc <fileclose+0xa8>

0000000080004e1c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004e1c:	715d                	addi	sp,sp,-80
    80004e1e:	e486                	sd	ra,72(sp)
    80004e20:	e0a2                	sd	s0,64(sp)
    80004e22:	fc26                	sd	s1,56(sp)
    80004e24:	f84a                	sd	s2,48(sp)
    80004e26:	f44e                	sd	s3,40(sp)
    80004e28:	0880                	addi	s0,sp,80
    80004e2a:	84aa                	mv	s1,a0
    80004e2c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	2ae080e7          	jalr	686(ra) # 800020dc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004e36:	409c                	lw	a5,0(s1)
    80004e38:	37f9                	addiw	a5,a5,-2
    80004e3a:	4705                	li	a4,1
    80004e3c:	04f76763          	bltu	a4,a5,80004e8a <filestat+0x6e>
    80004e40:	892a                	mv	s2,a0
    ilock(f->ip);
    80004e42:	6c88                	ld	a0,24(s1)
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	07e080e7          	jalr	126(ra) # 80003ec2 <ilock>
    stati(f->ip, &st);
    80004e4c:	fb840593          	addi	a1,s0,-72
    80004e50:	6c88                	ld	a0,24(s1)
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	2fa080e7          	jalr	762(ra) # 8000414c <stati>
    iunlock(f->ip);
    80004e5a:	6c88                	ld	a0,24(s1)
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	128080e7          	jalr	296(ra) # 80003f84 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004e64:	46e1                	li	a3,24
    80004e66:	fb840613          	addi	a2,s0,-72
    80004e6a:	85ce                	mv	a1,s3
    80004e6c:	05093503          	ld	a0,80(s2)
    80004e70:	ffffd097          	auipc	ra,0xffffd
    80004e74:	bc2080e7          	jalr	-1086(ra) # 80001a32 <copyout>
    80004e78:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004e7c:	60a6                	ld	ra,72(sp)
    80004e7e:	6406                	ld	s0,64(sp)
    80004e80:	74e2                	ld	s1,56(sp)
    80004e82:	7942                	ld	s2,48(sp)
    80004e84:	79a2                	ld	s3,40(sp)
    80004e86:	6161                	addi	sp,sp,80
    80004e88:	8082                	ret
  return -1;
    80004e8a:	557d                	li	a0,-1
    80004e8c:	bfc5                	j	80004e7c <filestat+0x60>

0000000080004e8e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004e8e:	7179                	addi	sp,sp,-48
    80004e90:	f406                	sd	ra,40(sp)
    80004e92:	f022                	sd	s0,32(sp)
    80004e94:	ec26                	sd	s1,24(sp)
    80004e96:	e84a                	sd	s2,16(sp)
    80004e98:	e44e                	sd	s3,8(sp)
    80004e9a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004e9c:	00854783          	lbu	a5,8(a0)
    80004ea0:	c3d5                	beqz	a5,80004f44 <fileread+0xb6>
    80004ea2:	84aa                	mv	s1,a0
    80004ea4:	89ae                	mv	s3,a1
    80004ea6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ea8:	411c                	lw	a5,0(a0)
    80004eaa:	4705                	li	a4,1
    80004eac:	04e78963          	beq	a5,a4,80004efe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004eb0:	470d                	li	a4,3
    80004eb2:	04e78d63          	beq	a5,a4,80004f0c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004eb6:	4709                	li	a4,2
    80004eb8:	06e79e63          	bne	a5,a4,80004f34 <fileread+0xa6>
    ilock(f->ip);
    80004ebc:	6d08                	ld	a0,24(a0)
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	004080e7          	jalr	4(ra) # 80003ec2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004ec6:	874a                	mv	a4,s2
    80004ec8:	5094                	lw	a3,32(s1)
    80004eca:	864e                	mv	a2,s3
    80004ecc:	4585                	li	a1,1
    80004ece:	6c88                	ld	a0,24(s1)
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	2a6080e7          	jalr	678(ra) # 80004176 <readi>
    80004ed8:	892a                	mv	s2,a0
    80004eda:	00a05563          	blez	a0,80004ee4 <fileread+0x56>
      f->off += r;
    80004ede:	509c                	lw	a5,32(s1)
    80004ee0:	9fa9                	addw	a5,a5,a0
    80004ee2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ee4:	6c88                	ld	a0,24(s1)
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	09e080e7          	jalr	158(ra) # 80003f84 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004eee:	854a                	mv	a0,s2
    80004ef0:	70a2                	ld	ra,40(sp)
    80004ef2:	7402                	ld	s0,32(sp)
    80004ef4:	64e2                	ld	s1,24(sp)
    80004ef6:	6942                	ld	s2,16(sp)
    80004ef8:	69a2                	ld	s3,8(sp)
    80004efa:	6145                	addi	sp,sp,48
    80004efc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004efe:	6908                	ld	a0,16(a0)
    80004f00:	00000097          	auipc	ra,0x0
    80004f04:	3f4080e7          	jalr	1012(ra) # 800052f4 <piperead>
    80004f08:	892a                	mv	s2,a0
    80004f0a:	b7d5                	j	80004eee <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004f0c:	02451783          	lh	a5,36(a0)
    80004f10:	03079693          	slli	a3,a5,0x30
    80004f14:	92c1                	srli	a3,a3,0x30
    80004f16:	4725                	li	a4,9
    80004f18:	02d76863          	bltu	a4,a3,80004f48 <fileread+0xba>
    80004f1c:	0792                	slli	a5,a5,0x4
    80004f1e:	0004b717          	auipc	a4,0x4b
    80004f22:	ea270713          	addi	a4,a4,-350 # 8004fdc0 <devsw>
    80004f26:	97ba                	add	a5,a5,a4
    80004f28:	639c                	ld	a5,0(a5)
    80004f2a:	c38d                	beqz	a5,80004f4c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004f2c:	4505                	li	a0,1
    80004f2e:	9782                	jalr	a5
    80004f30:	892a                	mv	s2,a0
    80004f32:	bf75                	j	80004eee <fileread+0x60>
    panic("fileread");
    80004f34:	00004517          	auipc	a0,0x4
    80004f38:	8cc50513          	addi	a0,a0,-1844 # 80008800 <syscalls+0x278>
    80004f3c:	ffffb097          	auipc	ra,0xffffb
    80004f40:	6a8080e7          	jalr	1704(ra) # 800005e4 <panic>
    return -1;
    80004f44:	597d                	li	s2,-1
    80004f46:	b765                	j	80004eee <fileread+0x60>
      return -1;
    80004f48:	597d                	li	s2,-1
    80004f4a:	b755                	j	80004eee <fileread+0x60>
    80004f4c:	597d                	li	s2,-1
    80004f4e:	b745                	j	80004eee <fileread+0x60>

0000000080004f50 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004f50:	00954783          	lbu	a5,9(a0)
    80004f54:	14078563          	beqz	a5,8000509e <filewrite+0x14e>
{
    80004f58:	715d                	addi	sp,sp,-80
    80004f5a:	e486                	sd	ra,72(sp)
    80004f5c:	e0a2                	sd	s0,64(sp)
    80004f5e:	fc26                	sd	s1,56(sp)
    80004f60:	f84a                	sd	s2,48(sp)
    80004f62:	f44e                	sd	s3,40(sp)
    80004f64:	f052                	sd	s4,32(sp)
    80004f66:	ec56                	sd	s5,24(sp)
    80004f68:	e85a                	sd	s6,16(sp)
    80004f6a:	e45e                	sd	s7,8(sp)
    80004f6c:	e062                	sd	s8,0(sp)
    80004f6e:	0880                	addi	s0,sp,80
    80004f70:	892a                	mv	s2,a0
    80004f72:	8aae                	mv	s5,a1
    80004f74:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f76:	411c                	lw	a5,0(a0)
    80004f78:	4705                	li	a4,1
    80004f7a:	02e78263          	beq	a5,a4,80004f9e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f7e:	470d                	li	a4,3
    80004f80:	02e78563          	beq	a5,a4,80004faa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f84:	4709                	li	a4,2
    80004f86:	10e79463          	bne	a5,a4,8000508e <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004f8a:	0ec05e63          	blez	a2,80005086 <filewrite+0x136>
    int i = 0;
    80004f8e:	4981                	li	s3,0
    80004f90:	6b05                	lui	s6,0x1
    80004f92:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004f96:	6b85                	lui	s7,0x1
    80004f98:	c00b8b9b          	addiw	s7,s7,-1024
    80004f9c:	a851                	j	80005030 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004f9e:	6908                	ld	a0,16(a0)
    80004fa0:	00000097          	auipc	ra,0x0
    80004fa4:	254080e7          	jalr	596(ra) # 800051f4 <pipewrite>
    80004fa8:	a85d                	j	8000505e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004faa:	02451783          	lh	a5,36(a0)
    80004fae:	03079693          	slli	a3,a5,0x30
    80004fb2:	92c1                	srli	a3,a3,0x30
    80004fb4:	4725                	li	a4,9
    80004fb6:	0ed76663          	bltu	a4,a3,800050a2 <filewrite+0x152>
    80004fba:	0792                	slli	a5,a5,0x4
    80004fbc:	0004b717          	auipc	a4,0x4b
    80004fc0:	e0470713          	addi	a4,a4,-508 # 8004fdc0 <devsw>
    80004fc4:	97ba                	add	a5,a5,a4
    80004fc6:	679c                	ld	a5,8(a5)
    80004fc8:	cff9                	beqz	a5,800050a6 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004fca:	4505                	li	a0,1
    80004fcc:	9782                	jalr	a5
    80004fce:	a841                	j	8000505e <filewrite+0x10e>
    80004fd0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004fd4:	00000097          	auipc	ra,0x0
    80004fd8:	8ae080e7          	jalr	-1874(ra) # 80004882 <begin_op>
      ilock(f->ip);
    80004fdc:	01893503          	ld	a0,24(s2)
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	ee2080e7          	jalr	-286(ra) # 80003ec2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004fe8:	8762                	mv	a4,s8
    80004fea:	02092683          	lw	a3,32(s2)
    80004fee:	01598633          	add	a2,s3,s5
    80004ff2:	4585                	li	a1,1
    80004ff4:	01893503          	ld	a0,24(s2)
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	276080e7          	jalr	630(ra) # 8000426e <writei>
    80005000:	84aa                	mv	s1,a0
    80005002:	02a05f63          	blez	a0,80005040 <filewrite+0xf0>
        f->off += r;
    80005006:	02092783          	lw	a5,32(s2)
    8000500a:	9fa9                	addw	a5,a5,a0
    8000500c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005010:	01893503          	ld	a0,24(s2)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	f70080e7          	jalr	-144(ra) # 80003f84 <iunlock>
      end_op();
    8000501c:	00000097          	auipc	ra,0x0
    80005020:	8e6080e7          	jalr	-1818(ra) # 80004902 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80005024:	049c1963          	bne	s8,s1,80005076 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80005028:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000502c:	0349d663          	bge	s3,s4,80005058 <filewrite+0x108>
      int n1 = n - i;
    80005030:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80005034:	84be                	mv	s1,a5
    80005036:	2781                	sext.w	a5,a5
    80005038:	f8fb5ce3          	bge	s6,a5,80004fd0 <filewrite+0x80>
    8000503c:	84de                	mv	s1,s7
    8000503e:	bf49                	j	80004fd0 <filewrite+0x80>
      iunlock(f->ip);
    80005040:	01893503          	ld	a0,24(s2)
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	f40080e7          	jalr	-192(ra) # 80003f84 <iunlock>
      end_op();
    8000504c:	00000097          	auipc	ra,0x0
    80005050:	8b6080e7          	jalr	-1866(ra) # 80004902 <end_op>
      if(r < 0)
    80005054:	fc04d8e3          	bgez	s1,80005024 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80005058:	8552                	mv	a0,s4
    8000505a:	033a1863          	bne	s4,s3,8000508a <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000505e:	60a6                	ld	ra,72(sp)
    80005060:	6406                	ld	s0,64(sp)
    80005062:	74e2                	ld	s1,56(sp)
    80005064:	7942                	ld	s2,48(sp)
    80005066:	79a2                	ld	s3,40(sp)
    80005068:	7a02                	ld	s4,32(sp)
    8000506a:	6ae2                	ld	s5,24(sp)
    8000506c:	6b42                	ld	s6,16(sp)
    8000506e:	6ba2                	ld	s7,8(sp)
    80005070:	6c02                	ld	s8,0(sp)
    80005072:	6161                	addi	sp,sp,80
    80005074:	8082                	ret
        panic("short filewrite");
    80005076:	00003517          	auipc	a0,0x3
    8000507a:	79a50513          	addi	a0,a0,1946 # 80008810 <syscalls+0x288>
    8000507e:	ffffb097          	auipc	ra,0xffffb
    80005082:	566080e7          	jalr	1382(ra) # 800005e4 <panic>
    int i = 0;
    80005086:	4981                	li	s3,0
    80005088:	bfc1                	j	80005058 <filewrite+0x108>
    ret = (i == n ? n : -1);
    8000508a:	557d                	li	a0,-1
    8000508c:	bfc9                	j	8000505e <filewrite+0x10e>
    panic("filewrite");
    8000508e:	00003517          	auipc	a0,0x3
    80005092:	79250513          	addi	a0,a0,1938 # 80008820 <syscalls+0x298>
    80005096:	ffffb097          	auipc	ra,0xffffb
    8000509a:	54e080e7          	jalr	1358(ra) # 800005e4 <panic>
    return -1;
    8000509e:	557d                	li	a0,-1
}
    800050a0:	8082                	ret
      return -1;
    800050a2:	557d                	li	a0,-1
    800050a4:	bf6d                	j	8000505e <filewrite+0x10e>
    800050a6:	557d                	li	a0,-1
    800050a8:	bf5d                	j	8000505e <filewrite+0x10e>

00000000800050aa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800050aa:	7179                	addi	sp,sp,-48
    800050ac:	f406                	sd	ra,40(sp)
    800050ae:	f022                	sd	s0,32(sp)
    800050b0:	ec26                	sd	s1,24(sp)
    800050b2:	e84a                	sd	s2,16(sp)
    800050b4:	e44e                	sd	s3,8(sp)
    800050b6:	e052                	sd	s4,0(sp)
    800050b8:	1800                	addi	s0,sp,48
    800050ba:	84aa                	mv	s1,a0
    800050bc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800050be:	0005b023          	sd	zero,0(a1)
    800050c2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800050c6:	00000097          	auipc	ra,0x0
    800050ca:	bd2080e7          	jalr	-1070(ra) # 80004c98 <filealloc>
    800050ce:	e088                	sd	a0,0(s1)
    800050d0:	c551                	beqz	a0,8000515c <pipealloc+0xb2>
    800050d2:	00000097          	auipc	ra,0x0
    800050d6:	bc6080e7          	jalr	-1082(ra) # 80004c98 <filealloc>
    800050da:	00aa3023          	sd	a0,0(s4)
    800050de:	c92d                	beqz	a0,80005150 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	b1c080e7          	jalr	-1252(ra) # 80000bfc <kalloc>
    800050e8:	892a                	mv	s2,a0
    800050ea:	c125                	beqz	a0,8000514a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800050ec:	4985                	li	s3,1
    800050ee:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800050f2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800050f6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800050fa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800050fe:	00003597          	auipc	a1,0x3
    80005102:	73258593          	addi	a1,a1,1842 # 80008830 <syscalls+0x2a8>
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	ba4080e7          	jalr	-1116(ra) # 80000caa <initlock>
  (*f0)->type = FD_PIPE;
    8000510e:	609c                	ld	a5,0(s1)
    80005110:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005114:	609c                	ld	a5,0(s1)
    80005116:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000511a:	609c                	ld	a5,0(s1)
    8000511c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005120:	609c                	ld	a5,0(s1)
    80005122:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005126:	000a3783          	ld	a5,0(s4)
    8000512a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000512e:	000a3783          	ld	a5,0(s4)
    80005132:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005136:	000a3783          	ld	a5,0(s4)
    8000513a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000513e:	000a3783          	ld	a5,0(s4)
    80005142:	0127b823          	sd	s2,16(a5)
  return 0;
    80005146:	4501                	li	a0,0
    80005148:	a025                	j	80005170 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000514a:	6088                	ld	a0,0(s1)
    8000514c:	e501                	bnez	a0,80005154 <pipealloc+0xaa>
    8000514e:	a039                	j	8000515c <pipealloc+0xb2>
    80005150:	6088                	ld	a0,0(s1)
    80005152:	c51d                	beqz	a0,80005180 <pipealloc+0xd6>
    fileclose(*f0);
    80005154:	00000097          	auipc	ra,0x0
    80005158:	c00080e7          	jalr	-1024(ra) # 80004d54 <fileclose>
  if(*f1)
    8000515c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005160:	557d                	li	a0,-1
  if(*f1)
    80005162:	c799                	beqz	a5,80005170 <pipealloc+0xc6>
    fileclose(*f1);
    80005164:	853e                	mv	a0,a5
    80005166:	00000097          	auipc	ra,0x0
    8000516a:	bee080e7          	jalr	-1042(ra) # 80004d54 <fileclose>
  return -1;
    8000516e:	557d                	li	a0,-1
}
    80005170:	70a2                	ld	ra,40(sp)
    80005172:	7402                	ld	s0,32(sp)
    80005174:	64e2                	ld	s1,24(sp)
    80005176:	6942                	ld	s2,16(sp)
    80005178:	69a2                	ld	s3,8(sp)
    8000517a:	6a02                	ld	s4,0(sp)
    8000517c:	6145                	addi	sp,sp,48
    8000517e:	8082                	ret
  return -1;
    80005180:	557d                	li	a0,-1
    80005182:	b7fd                	j	80005170 <pipealloc+0xc6>

0000000080005184 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005184:	1101                	addi	sp,sp,-32
    80005186:	ec06                	sd	ra,24(sp)
    80005188:	e822                	sd	s0,16(sp)
    8000518a:	e426                	sd	s1,8(sp)
    8000518c:	e04a                	sd	s2,0(sp)
    8000518e:	1000                	addi	s0,sp,32
    80005190:	84aa                	mv	s1,a0
    80005192:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005194:	ffffc097          	auipc	ra,0xffffc
    80005198:	ba6080e7          	jalr	-1114(ra) # 80000d3a <acquire>
  if(writable){
    8000519c:	02090d63          	beqz	s2,800051d6 <pipeclose+0x52>
    pi->writeopen = 0;
    800051a0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800051a4:	21848513          	addi	a0,s1,536
    800051a8:	ffffe097          	auipc	ra,0xffffe
    800051ac:	8fc080e7          	jalr	-1796(ra) # 80002aa4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800051b0:	2204b783          	ld	a5,544(s1)
    800051b4:	eb95                	bnez	a5,800051e8 <pipeclose+0x64>
    release(&pi->lock);
    800051b6:	8526                	mv	a0,s1
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	c36080e7          	jalr	-970(ra) # 80000dee <release>
    kfree((char*)pi);
    800051c0:	8526                	mv	a0,s1
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	8c8080e7          	jalr	-1848(ra) # 80000a8a <kfree>
  } else
    release(&pi->lock);
}
    800051ca:	60e2                	ld	ra,24(sp)
    800051cc:	6442                	ld	s0,16(sp)
    800051ce:	64a2                	ld	s1,8(sp)
    800051d0:	6902                	ld	s2,0(sp)
    800051d2:	6105                	addi	sp,sp,32
    800051d4:	8082                	ret
    pi->readopen = 0;
    800051d6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800051da:	21c48513          	addi	a0,s1,540
    800051de:	ffffe097          	auipc	ra,0xffffe
    800051e2:	8c6080e7          	jalr	-1850(ra) # 80002aa4 <wakeup>
    800051e6:	b7e9                	j	800051b0 <pipeclose+0x2c>
    release(&pi->lock);
    800051e8:	8526                	mv	a0,s1
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	c04080e7          	jalr	-1020(ra) # 80000dee <release>
}
    800051f2:	bfe1                	j	800051ca <pipeclose+0x46>

00000000800051f4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800051f4:	711d                	addi	sp,sp,-96
    800051f6:	ec86                	sd	ra,88(sp)
    800051f8:	e8a2                	sd	s0,80(sp)
    800051fa:	e4a6                	sd	s1,72(sp)
    800051fc:	e0ca                	sd	s2,64(sp)
    800051fe:	fc4e                	sd	s3,56(sp)
    80005200:	f852                	sd	s4,48(sp)
    80005202:	f456                	sd	s5,40(sp)
    80005204:	f05a                	sd	s6,32(sp)
    80005206:	ec5e                	sd	s7,24(sp)
    80005208:	e862                	sd	s8,16(sp)
    8000520a:	1080                	addi	s0,sp,96
    8000520c:	84aa                	mv	s1,a0
    8000520e:	8b2e                	mv	s6,a1
    80005210:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80005212:	ffffd097          	auipc	ra,0xffffd
    80005216:	eca080e7          	jalr	-310(ra) # 800020dc <myproc>
    8000521a:	892a                	mv	s2,a0

  acquire(&pi->lock);
    8000521c:	8526                	mv	a0,s1
    8000521e:	ffffc097          	auipc	ra,0xffffc
    80005222:	b1c080e7          	jalr	-1252(ra) # 80000d3a <acquire>
  for(i = 0; i < n; i++){
    80005226:	09505763          	blez	s5,800052b4 <pipewrite+0xc0>
    8000522a:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    8000522c:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005230:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005234:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80005236:	2184a783          	lw	a5,536(s1)
    8000523a:	21c4a703          	lw	a4,540(s1)
    8000523e:	2007879b          	addiw	a5,a5,512
    80005242:	02f71b63          	bne	a4,a5,80005278 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80005246:	2204a783          	lw	a5,544(s1)
    8000524a:	c3d1                	beqz	a5,800052ce <pipewrite+0xda>
    8000524c:	03092783          	lw	a5,48(s2)
    80005250:	efbd                	bnez	a5,800052ce <pipewrite+0xda>
      wakeup(&pi->nread);
    80005252:	8552                	mv	a0,s4
    80005254:	ffffe097          	auipc	ra,0xffffe
    80005258:	850080e7          	jalr	-1968(ra) # 80002aa4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000525c:	85a6                	mv	a1,s1
    8000525e:	854e                	mv	a0,s3
    80005260:	ffffd097          	auipc	ra,0xffffd
    80005264:	6c4080e7          	jalr	1732(ra) # 80002924 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80005268:	2184a783          	lw	a5,536(s1)
    8000526c:	21c4a703          	lw	a4,540(s1)
    80005270:	2007879b          	addiw	a5,a5,512
    80005274:	fcf709e3          	beq	a4,a5,80005246 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005278:	4685                	li	a3,1
    8000527a:	865a                	mv	a2,s6
    8000527c:	faf40593          	addi	a1,s0,-81
    80005280:	05093503          	ld	a0,80(s2)
    80005284:	ffffc097          	auipc	ra,0xffffc
    80005288:	53a080e7          	jalr	1338(ra) # 800017be <copyin>
    8000528c:	03850563          	beq	a0,s8,800052b6 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005290:	21c4a783          	lw	a5,540(s1)
    80005294:	0017871b          	addiw	a4,a5,1
    80005298:	20e4ae23          	sw	a4,540(s1)
    8000529c:	1ff7f793          	andi	a5,a5,511
    800052a0:	97a6                	add	a5,a5,s1
    800052a2:	faf44703          	lbu	a4,-81(s0)
    800052a6:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800052aa:	2b85                	addiw	s7,s7,1
    800052ac:	0b05                	addi	s6,s6,1
    800052ae:	f97a94e3          	bne	s5,s7,80005236 <pipewrite+0x42>
    800052b2:	a011                	j	800052b6 <pipewrite+0xc2>
    800052b4:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    800052b6:	21848513          	addi	a0,s1,536
    800052ba:	ffffd097          	auipc	ra,0xffffd
    800052be:	7ea080e7          	jalr	2026(ra) # 80002aa4 <wakeup>
  release(&pi->lock);
    800052c2:	8526                	mv	a0,s1
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	b2a080e7          	jalr	-1238(ra) # 80000dee <release>
  return i;
    800052cc:	a039                	j	800052da <pipewrite+0xe6>
        release(&pi->lock);
    800052ce:	8526                	mv	a0,s1
    800052d0:	ffffc097          	auipc	ra,0xffffc
    800052d4:	b1e080e7          	jalr	-1250(ra) # 80000dee <release>
        return -1;
    800052d8:	5bfd                	li	s7,-1
}
    800052da:	855e                	mv	a0,s7
    800052dc:	60e6                	ld	ra,88(sp)
    800052de:	6446                	ld	s0,80(sp)
    800052e0:	64a6                	ld	s1,72(sp)
    800052e2:	6906                	ld	s2,64(sp)
    800052e4:	79e2                	ld	s3,56(sp)
    800052e6:	7a42                	ld	s4,48(sp)
    800052e8:	7aa2                	ld	s5,40(sp)
    800052ea:	7b02                	ld	s6,32(sp)
    800052ec:	6be2                	ld	s7,24(sp)
    800052ee:	6c42                	ld	s8,16(sp)
    800052f0:	6125                	addi	sp,sp,96
    800052f2:	8082                	ret

00000000800052f4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800052f4:	715d                	addi	sp,sp,-80
    800052f6:	e486                	sd	ra,72(sp)
    800052f8:	e0a2                	sd	s0,64(sp)
    800052fa:	fc26                	sd	s1,56(sp)
    800052fc:	f84a                	sd	s2,48(sp)
    800052fe:	f44e                	sd	s3,40(sp)
    80005300:	f052                	sd	s4,32(sp)
    80005302:	ec56                	sd	s5,24(sp)
    80005304:	e85a                	sd	s6,16(sp)
    80005306:	0880                	addi	s0,sp,80
    80005308:	84aa                	mv	s1,a0
    8000530a:	892e                	mv	s2,a1
    8000530c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000530e:	ffffd097          	auipc	ra,0xffffd
    80005312:	dce080e7          	jalr	-562(ra) # 800020dc <myproc>
    80005316:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005318:	8526                	mv	a0,s1
    8000531a:	ffffc097          	auipc	ra,0xffffc
    8000531e:	a20080e7          	jalr	-1504(ra) # 80000d3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005322:	2184a703          	lw	a4,536(s1)
    80005326:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000532a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000532e:	02f71463          	bne	a4,a5,80005356 <piperead+0x62>
    80005332:	2244a783          	lw	a5,548(s1)
    80005336:	c385                	beqz	a5,80005356 <piperead+0x62>
    if(pr->killed){
    80005338:	030a2783          	lw	a5,48(s4)
    8000533c:	ebc1                	bnez	a5,800053cc <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000533e:	85a6                	mv	a1,s1
    80005340:	854e                	mv	a0,s3
    80005342:	ffffd097          	auipc	ra,0xffffd
    80005346:	5e2080e7          	jalr	1506(ra) # 80002924 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000534a:	2184a703          	lw	a4,536(s1)
    8000534e:	21c4a783          	lw	a5,540(s1)
    80005352:	fef700e3          	beq	a4,a5,80005332 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005356:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005358:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000535a:	05505363          	blez	s5,800053a0 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    8000535e:	2184a783          	lw	a5,536(s1)
    80005362:	21c4a703          	lw	a4,540(s1)
    80005366:	02f70d63          	beq	a4,a5,800053a0 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000536a:	0017871b          	addiw	a4,a5,1
    8000536e:	20e4ac23          	sw	a4,536(s1)
    80005372:	1ff7f793          	andi	a5,a5,511
    80005376:	97a6                	add	a5,a5,s1
    80005378:	0187c783          	lbu	a5,24(a5)
    8000537c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005380:	4685                	li	a3,1
    80005382:	fbf40613          	addi	a2,s0,-65
    80005386:	85ca                	mv	a1,s2
    80005388:	050a3503          	ld	a0,80(s4)
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	6a6080e7          	jalr	1702(ra) # 80001a32 <copyout>
    80005394:	01650663          	beq	a0,s6,800053a0 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005398:	2985                	addiw	s3,s3,1
    8000539a:	0905                	addi	s2,s2,1
    8000539c:	fd3a91e3          	bne	s5,s3,8000535e <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800053a0:	21c48513          	addi	a0,s1,540
    800053a4:	ffffd097          	auipc	ra,0xffffd
    800053a8:	700080e7          	jalr	1792(ra) # 80002aa4 <wakeup>
  release(&pi->lock);
    800053ac:	8526                	mv	a0,s1
    800053ae:	ffffc097          	auipc	ra,0xffffc
    800053b2:	a40080e7          	jalr	-1472(ra) # 80000dee <release>
  return i;
}
    800053b6:	854e                	mv	a0,s3
    800053b8:	60a6                	ld	ra,72(sp)
    800053ba:	6406                	ld	s0,64(sp)
    800053bc:	74e2                	ld	s1,56(sp)
    800053be:	7942                	ld	s2,48(sp)
    800053c0:	79a2                	ld	s3,40(sp)
    800053c2:	7a02                	ld	s4,32(sp)
    800053c4:	6ae2                	ld	s5,24(sp)
    800053c6:	6b42                	ld	s6,16(sp)
    800053c8:	6161                	addi	sp,sp,80
    800053ca:	8082                	ret
      release(&pi->lock);
    800053cc:	8526                	mv	a0,s1
    800053ce:	ffffc097          	auipc	ra,0xffffc
    800053d2:	a20080e7          	jalr	-1504(ra) # 80000dee <release>
      return -1;
    800053d6:	59fd                	li	s3,-1
    800053d8:	bff9                	j	800053b6 <piperead+0xc2>

00000000800053da <exec>:
#include "types.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    800053da:	de010113          	addi	sp,sp,-544
    800053de:	20113c23          	sd	ra,536(sp)
    800053e2:	20813823          	sd	s0,528(sp)
    800053e6:	20913423          	sd	s1,520(sp)
    800053ea:	21213023          	sd	s2,512(sp)
    800053ee:	ffce                	sd	s3,504(sp)
    800053f0:	fbd2                	sd	s4,496(sp)
    800053f2:	f7d6                	sd	s5,488(sp)
    800053f4:	f3da                	sd	s6,480(sp)
    800053f6:	efde                	sd	s7,472(sp)
    800053f8:	ebe2                	sd	s8,464(sp)
    800053fa:	e7e6                	sd	s9,456(sp)
    800053fc:	e3ea                	sd	s10,448(sp)
    800053fe:	ff6e                	sd	s11,440(sp)
    80005400:	1400                	addi	s0,sp,544
    80005402:	892a                	mv	s2,a0
    80005404:	dea43423          	sd	a0,-536(s0)
    80005408:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000540c:	ffffd097          	auipc	ra,0xffffd
    80005410:	cd0080e7          	jalr	-816(ra) # 800020dc <myproc>
    80005414:	84aa                	mv	s1,a0

  begin_op();
    80005416:	fffff097          	auipc	ra,0xfffff
    8000541a:	46c080e7          	jalr	1132(ra) # 80004882 <begin_op>

  if ((ip = namei(path)) == 0) {
    8000541e:	854a                	mv	a0,s2
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	256080e7          	jalr	598(ra) # 80004676 <namei>
    80005428:	c93d                	beqz	a0,8000549e <exec+0xc4>
    8000542a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000542c:	fffff097          	auipc	ra,0xfffff
    80005430:	a96080e7          	jalr	-1386(ra) # 80003ec2 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005434:	04000713          	li	a4,64
    80005438:	4681                	li	a3,0
    8000543a:	e4840613          	addi	a2,s0,-440
    8000543e:	4581                	li	a1,0
    80005440:	8556                	mv	a0,s5
    80005442:	fffff097          	auipc	ra,0xfffff
    80005446:	d34080e7          	jalr	-716(ra) # 80004176 <readi>
    8000544a:	04000793          	li	a5,64
    8000544e:	00f51a63          	bne	a0,a5,80005462 <exec+0x88>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    80005452:	e4842703          	lw	a4,-440(s0)
    80005456:	464c47b7          	lui	a5,0x464c4
    8000545a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000545e:	04f70663          	beq	a4,a5,800054aa <exec+0xd0>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80005462:	8556                	mv	a0,s5
    80005464:	fffff097          	auipc	ra,0xfffff
    80005468:	cc0080e7          	jalr	-832(ra) # 80004124 <iunlockput>
    end_op();
    8000546c:	fffff097          	auipc	ra,0xfffff
    80005470:	496080e7          	jalr	1174(ra) # 80004902 <end_op>
  }
  return -1;
    80005474:	557d                	li	a0,-1
}
    80005476:	21813083          	ld	ra,536(sp)
    8000547a:	21013403          	ld	s0,528(sp)
    8000547e:	20813483          	ld	s1,520(sp)
    80005482:	20013903          	ld	s2,512(sp)
    80005486:	79fe                	ld	s3,504(sp)
    80005488:	7a5e                	ld	s4,496(sp)
    8000548a:	7abe                	ld	s5,488(sp)
    8000548c:	7b1e                	ld	s6,480(sp)
    8000548e:	6bfe                	ld	s7,472(sp)
    80005490:	6c5e                	ld	s8,464(sp)
    80005492:	6cbe                	ld	s9,456(sp)
    80005494:	6d1e                	ld	s10,448(sp)
    80005496:	7dfa                	ld	s11,440(sp)
    80005498:	22010113          	addi	sp,sp,544
    8000549c:	8082                	ret
    end_op();
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	464080e7          	jalr	1124(ra) # 80004902 <end_op>
    return -1;
    800054a6:	557d                	li	a0,-1
    800054a8:	b7f9                	j	80005476 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    800054aa:	8526                	mv	a0,s1
    800054ac:	ffffd097          	auipc	ra,0xffffd
    800054b0:	cf4080e7          	jalr	-780(ra) # 800021a0 <proc_pagetable>
    800054b4:	8b2a                	mv	s6,a0
    800054b6:	d555                	beqz	a0,80005462 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800054b8:	e6842783          	lw	a5,-408(s0)
    800054bc:	e8045703          	lhu	a4,-384(s0)
    800054c0:	c735                	beqz	a4,8000552c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    800054c2:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800054c4:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    800054c8:	6a05                	lui	s4,0x1
    800054ca:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800054ce:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    800054d2:	6d85                	lui	s11,0x1
    800054d4:	7d7d                	lui	s10,0xfffff
    800054d6:	ac1d                	j	8000570c <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    800054d8:	00003517          	auipc	a0,0x3
    800054dc:	36050513          	addi	a0,a0,864 # 80008838 <syscalls+0x2b0>
    800054e0:	ffffb097          	auipc	ra,0xffffb
    800054e4:	104080e7          	jalr	260(ra) # 800005e4 <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800054e8:	874a                	mv	a4,s2
    800054ea:	009c86bb          	addw	a3,s9,s1
    800054ee:	4581                	li	a1,0
    800054f0:	8556                	mv	a0,s5
    800054f2:	fffff097          	auipc	ra,0xfffff
    800054f6:	c84080e7          	jalr	-892(ra) # 80004176 <readi>
    800054fa:	2501                	sext.w	a0,a0
    800054fc:	1aa91863          	bne	s2,a0,800056ac <exec+0x2d2>
  for (i = 0; i < sz; i += PGSIZE) {
    80005500:	009d84bb          	addw	s1,s11,s1
    80005504:	013d09bb          	addw	s3,s10,s3
    80005508:	1f74f263          	bgeu	s1,s7,800056ec <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000550c:	02049593          	slli	a1,s1,0x20
    80005510:	9181                	srli	a1,a1,0x20
    80005512:	95e2                	add	a1,a1,s8
    80005514:	855a                	mv	a0,s6
    80005516:	ffffc097          	auipc	ra,0xffffc
    8000551a:	ca4080e7          	jalr	-860(ra) # 800011ba <walkaddr>
    8000551e:	862a                	mv	a2,a0
    if (pa == 0)
    80005520:	dd45                	beqz	a0,800054d8 <exec+0xfe>
      n = PGSIZE;
    80005522:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80005524:	fd49f2e3          	bgeu	s3,s4,800054e8 <exec+0x10e>
      n = sz - i;
    80005528:	894e                	mv	s2,s3
    8000552a:	bf7d                	j	800054e8 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    8000552c:	4481                	li	s1,0
  iunlockput(ip);
    8000552e:	8556                	mv	a0,s5
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	bf4080e7          	jalr	-1036(ra) # 80004124 <iunlockput>
  end_op();
    80005538:	fffff097          	auipc	ra,0xfffff
    8000553c:	3ca080e7          	jalr	970(ra) # 80004902 <end_op>
  p = myproc();
    80005540:	ffffd097          	auipc	ra,0xffffd
    80005544:	b9c080e7          	jalr	-1124(ra) # 800020dc <myproc>
    80005548:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000554a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000554e:	6785                	lui	a5,0x1
    80005550:	17fd                	addi	a5,a5,-1
    80005552:	94be                	add	s1,s1,a5
    80005554:	77fd                	lui	a5,0xfffff
    80005556:	8fe5                	and	a5,a5,s1
    80005558:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    8000555c:	6609                	lui	a2,0x2
    8000555e:	963e                	add	a2,a2,a5
    80005560:	85be                	mv	a1,a5
    80005562:	855a                	mv	a0,s6
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	01c080e7          	jalr	28(ra) # 80001580 <uvmalloc>
    8000556c:	8c2a                	mv	s8,a0
  ip = 0;
    8000556e:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80005570:	12050e63          	beqz	a0,800056ac <exec+0x2d2>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80005574:	75f9                	lui	a1,0xffffe
    80005576:	95aa                	add	a1,a1,a0
    80005578:	855a                	mv	a0,s6
    8000557a:	ffffc097          	auipc	ra,0xffffc
    8000557e:	212080e7          	jalr	530(ra) # 8000178c <uvmclear>
  stackbase = sp - PGSIZE;
    80005582:	7afd                	lui	s5,0xfffff
    80005584:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    80005586:	df043783          	ld	a5,-528(s0)
    8000558a:	6388                	ld	a0,0(a5)
    8000558c:	c925                	beqz	a0,800055fc <exec+0x222>
    8000558e:	e8840993          	addi	s3,s0,-376
    80005592:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005596:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80005598:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000559a:	ffffc097          	auipc	ra,0xffffc
    8000559e:	a20080e7          	jalr	-1504(ra) # 80000fba <strlen>
    800055a2:	0015079b          	addiw	a5,a0,1
    800055a6:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800055aa:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    800055ae:	13596363          	bltu	s2,s5,800056d4 <exec+0x2fa>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800055b2:	df043d83          	ld	s11,-528(s0)
    800055b6:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800055ba:	8552                	mv	a0,s4
    800055bc:	ffffc097          	auipc	ra,0xffffc
    800055c0:	9fe080e7          	jalr	-1538(ra) # 80000fba <strlen>
    800055c4:	0015069b          	addiw	a3,a0,1
    800055c8:	8652                	mv	a2,s4
    800055ca:	85ca                	mv	a1,s2
    800055cc:	855a                	mv	a0,s6
    800055ce:	ffffc097          	auipc	ra,0xffffc
    800055d2:	464080e7          	jalr	1124(ra) # 80001a32 <copyout>
    800055d6:	10054363          	bltz	a0,800056dc <exec+0x302>
    ustack[argc] = sp;
    800055da:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800055de:	0485                	addi	s1,s1,1
    800055e0:	008d8793          	addi	a5,s11,8
    800055e4:	def43823          	sd	a5,-528(s0)
    800055e8:	008db503          	ld	a0,8(s11)
    800055ec:	c911                	beqz	a0,80005600 <exec+0x226>
    if (argc >= MAXARG)
    800055ee:	09a1                	addi	s3,s3,8
    800055f0:	fb3c95e3          	bne	s9,s3,8000559a <exec+0x1c0>
  sz = sz1;
    800055f4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800055f8:	4a81                	li	s5,0
    800055fa:	a84d                	j	800056ac <exec+0x2d2>
  sp = sz;
    800055fc:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800055fe:	4481                	li	s1,0
  ustack[argc] = 0;
    80005600:	00349793          	slli	a5,s1,0x3
    80005604:	f9040713          	addi	a4,s0,-112
    80005608:	97ba                	add	a5,a5,a4
    8000560a:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffaaef8>
  sp -= (argc + 1) * sizeof(uint64);
    8000560e:	00148693          	addi	a3,s1,1
    80005612:	068e                	slli	a3,a3,0x3
    80005614:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005618:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000561c:	01597663          	bgeu	s2,s5,80005628 <exec+0x24e>
  sz = sz1;
    80005620:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005624:	4a81                	li	s5,0
    80005626:	a059                	j	800056ac <exec+0x2d2>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80005628:	e8840613          	addi	a2,s0,-376
    8000562c:	85ca                	mv	a1,s2
    8000562e:	855a                	mv	a0,s6
    80005630:	ffffc097          	auipc	ra,0xffffc
    80005634:	402080e7          	jalr	1026(ra) # 80001a32 <copyout>
    80005638:	0a054663          	bltz	a0,800056e4 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000563c:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80005640:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80005644:	de843783          	ld	a5,-536(s0)
    80005648:	0007c703          	lbu	a4,0(a5)
    8000564c:	cf11                	beqz	a4,80005668 <exec+0x28e>
    8000564e:	0785                	addi	a5,a5,1
    if (*s == '/')
    80005650:	02f00693          	li	a3,47
    80005654:	a039                	j	80005662 <exec+0x288>
      last = s + 1;
    80005656:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    8000565a:	0785                	addi	a5,a5,1
    8000565c:	fff7c703          	lbu	a4,-1(a5)
    80005660:	c701                	beqz	a4,80005668 <exec+0x28e>
    if (*s == '/')
    80005662:	fed71ce3          	bne	a4,a3,8000565a <exec+0x280>
    80005666:	bfc5                	j	80005656 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005668:	4641                	li	a2,16
    8000566a:	de843583          	ld	a1,-536(s0)
    8000566e:	150b8513          	addi	a0,s7,336
    80005672:	ffffc097          	auipc	ra,0xffffc
    80005676:	916080e7          	jalr	-1770(ra) # 80000f88 <safestrcpy>
  oldpagetable = p->pagetable;
    8000567a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000567e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005682:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80005686:	058bb783          	ld	a5,88(s7)
    8000568a:	e6043703          	ld	a4,-416(s0)
    8000568e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80005690:	058bb783          	ld	a5,88(s7)
    80005694:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005698:	85ea                	mv	a1,s10
    8000569a:	ffffd097          	auipc	ra,0xffffd
    8000569e:	ba2080e7          	jalr	-1118(ra) # 8000223c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800056a2:	0004851b          	sext.w	a0,s1
    800056a6:	bbc1                	j	80005476 <exec+0x9c>
    800056a8:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800056ac:	df843583          	ld	a1,-520(s0)
    800056b0:	855a                	mv	a0,s6
    800056b2:	ffffd097          	auipc	ra,0xffffd
    800056b6:	b8a080e7          	jalr	-1142(ra) # 8000223c <proc_freepagetable>
  if (ip) {
    800056ba:	da0a94e3          	bnez	s5,80005462 <exec+0x88>
  return -1;
    800056be:	557d                	li	a0,-1
    800056c0:	bb5d                	j	80005476 <exec+0x9c>
    800056c2:	de943c23          	sd	s1,-520(s0)
    800056c6:	b7dd                	j	800056ac <exec+0x2d2>
    800056c8:	de943c23          	sd	s1,-520(s0)
    800056cc:	b7c5                	j	800056ac <exec+0x2d2>
    800056ce:	de943c23          	sd	s1,-520(s0)
    800056d2:	bfe9                	j	800056ac <exec+0x2d2>
  sz = sz1;
    800056d4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056d8:	4a81                	li	s5,0
    800056da:	bfc9                	j	800056ac <exec+0x2d2>
  sz = sz1;
    800056dc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056e0:	4a81                	li	s5,0
    800056e2:	b7e9                	j	800056ac <exec+0x2d2>
  sz = sz1;
    800056e4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056e8:	4a81                	li	s5,0
    800056ea:	b7c9                	j	800056ac <exec+0x2d2>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800056ec:	df843483          	ld	s1,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800056f0:	e0843783          	ld	a5,-504(s0)
    800056f4:	0017869b          	addiw	a3,a5,1
    800056f8:	e0d43423          	sd	a3,-504(s0)
    800056fc:	e0043783          	ld	a5,-512(s0)
    80005700:	0387879b          	addiw	a5,a5,56
    80005704:	e8045703          	lhu	a4,-384(s0)
    80005708:	e2e6d3e3          	bge	a3,a4,8000552e <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000570c:	2781                	sext.w	a5,a5
    8000570e:	e0f43023          	sd	a5,-512(s0)
    80005712:	03800713          	li	a4,56
    80005716:	86be                	mv	a3,a5
    80005718:	e1040613          	addi	a2,s0,-496
    8000571c:	4581                	li	a1,0
    8000571e:	8556                	mv	a0,s5
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	a56080e7          	jalr	-1450(ra) # 80004176 <readi>
    80005728:	03800793          	li	a5,56
    8000572c:	f6f51ee3          	bne	a0,a5,800056a8 <exec+0x2ce>
    if (ph.type != ELF_PROG_LOAD)
    80005730:	e1042783          	lw	a5,-496(s0)
    80005734:	4705                	li	a4,1
    80005736:	fae79de3          	bne	a5,a4,800056f0 <exec+0x316>
    if (ph.memsz < ph.filesz)
    8000573a:	e3843603          	ld	a2,-456(s0)
    8000573e:	e3043783          	ld	a5,-464(s0)
    80005742:	f8f660e3          	bltu	a2,a5,800056c2 <exec+0x2e8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005746:	e2043783          	ld	a5,-480(s0)
    8000574a:	963e                	add	a2,a2,a5
    8000574c:	f6f66ee3          	bltu	a2,a5,800056c8 <exec+0x2ee>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005750:	85a6                	mv	a1,s1
    80005752:	855a                	mv	a0,s6
    80005754:	ffffc097          	auipc	ra,0xffffc
    80005758:	e2c080e7          	jalr	-468(ra) # 80001580 <uvmalloc>
    8000575c:	dea43c23          	sd	a0,-520(s0)
    80005760:	d53d                	beqz	a0,800056ce <exec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    80005762:	e2043c03          	ld	s8,-480(s0)
    80005766:	de043783          	ld	a5,-544(s0)
    8000576a:	00fc77b3          	and	a5,s8,a5
    8000576e:	ff9d                	bnez	a5,800056ac <exec+0x2d2>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005770:	e1842c83          	lw	s9,-488(s0)
    80005774:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005778:	f60b8ae3          	beqz	s7,800056ec <exec+0x312>
    8000577c:	89de                	mv	s3,s7
    8000577e:	4481                	li	s1,0
    80005780:	b371                	j	8000550c <exec+0x132>

0000000080005782 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005782:	7179                	addi	sp,sp,-48
    80005784:	f406                	sd	ra,40(sp)
    80005786:	f022                	sd	s0,32(sp)
    80005788:	ec26                	sd	s1,24(sp)
    8000578a:	e84a                	sd	s2,16(sp)
    8000578c:	1800                	addi	s0,sp,48
    8000578e:	892e                	mv	s2,a1
    80005790:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005792:	fdc40593          	addi	a1,s0,-36
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	b7a080e7          	jalr	-1158(ra) # 80003310 <argint>
    8000579e:	04054063          	bltz	a0,800057de <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800057a2:	fdc42703          	lw	a4,-36(s0)
    800057a6:	47bd                	li	a5,15
    800057a8:	02e7ed63          	bltu	a5,a4,800057e2 <argfd+0x60>
    800057ac:	ffffd097          	auipc	ra,0xffffd
    800057b0:	930080e7          	jalr	-1744(ra) # 800020dc <myproc>
    800057b4:	fdc42703          	lw	a4,-36(s0)
    800057b8:	01a70793          	addi	a5,a4,26
    800057bc:	078e                	slli	a5,a5,0x3
    800057be:	953e                	add	a0,a0,a5
    800057c0:	611c                	ld	a5,0(a0)
    800057c2:	c395                	beqz	a5,800057e6 <argfd+0x64>
    return -1;
  if(pfd)
    800057c4:	00090463          	beqz	s2,800057cc <argfd+0x4a>
    *pfd = fd;
    800057c8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800057cc:	4501                	li	a0,0
  if(pf)
    800057ce:	c091                	beqz	s1,800057d2 <argfd+0x50>
    *pf = f;
    800057d0:	e09c                	sd	a5,0(s1)
}
    800057d2:	70a2                	ld	ra,40(sp)
    800057d4:	7402                	ld	s0,32(sp)
    800057d6:	64e2                	ld	s1,24(sp)
    800057d8:	6942                	ld	s2,16(sp)
    800057da:	6145                	addi	sp,sp,48
    800057dc:	8082                	ret
    return -1;
    800057de:	557d                	li	a0,-1
    800057e0:	bfcd                	j	800057d2 <argfd+0x50>
    return -1;
    800057e2:	557d                	li	a0,-1
    800057e4:	b7fd                	j	800057d2 <argfd+0x50>
    800057e6:	557d                	li	a0,-1
    800057e8:	b7ed                	j	800057d2 <argfd+0x50>

00000000800057ea <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800057ea:	1101                	addi	sp,sp,-32
    800057ec:	ec06                	sd	ra,24(sp)
    800057ee:	e822                	sd	s0,16(sp)
    800057f0:	e426                	sd	s1,8(sp)
    800057f2:	1000                	addi	s0,sp,32
    800057f4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800057f6:	ffffd097          	auipc	ra,0xffffd
    800057fa:	8e6080e7          	jalr	-1818(ra) # 800020dc <myproc>
    800057fe:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005800:	0d050793          	addi	a5,a0,208
    80005804:	4501                	li	a0,0
    80005806:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005808:	6398                	ld	a4,0(a5)
    8000580a:	cb19                	beqz	a4,80005820 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000580c:	2505                	addiw	a0,a0,1
    8000580e:	07a1                	addi	a5,a5,8
    80005810:	fed51ce3          	bne	a0,a3,80005808 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005814:	557d                	li	a0,-1
}
    80005816:	60e2                	ld	ra,24(sp)
    80005818:	6442                	ld	s0,16(sp)
    8000581a:	64a2                	ld	s1,8(sp)
    8000581c:	6105                	addi	sp,sp,32
    8000581e:	8082                	ret
      p->ofile[fd] = f;
    80005820:	01a50793          	addi	a5,a0,26
    80005824:	078e                	slli	a5,a5,0x3
    80005826:	963e                	add	a2,a2,a5
    80005828:	e204                	sd	s1,0(a2)
      return fd;
    8000582a:	b7f5                	j	80005816 <fdalloc+0x2c>

000000008000582c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000582c:	715d                	addi	sp,sp,-80
    8000582e:	e486                	sd	ra,72(sp)
    80005830:	e0a2                	sd	s0,64(sp)
    80005832:	fc26                	sd	s1,56(sp)
    80005834:	f84a                	sd	s2,48(sp)
    80005836:	f44e                	sd	s3,40(sp)
    80005838:	f052                	sd	s4,32(sp)
    8000583a:	ec56                	sd	s5,24(sp)
    8000583c:	0880                	addi	s0,sp,80
    8000583e:	89ae                	mv	s3,a1
    80005840:	8ab2                	mv	s5,a2
    80005842:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005844:	fb040593          	addi	a1,s0,-80
    80005848:	fffff097          	auipc	ra,0xfffff
    8000584c:	e4c080e7          	jalr	-436(ra) # 80004694 <nameiparent>
    80005850:	892a                	mv	s2,a0
    80005852:	12050e63          	beqz	a0,8000598e <create+0x162>
    return 0;

  ilock(dp);
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	66c080e7          	jalr	1644(ra) # 80003ec2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000585e:	4601                	li	a2,0
    80005860:	fb040593          	addi	a1,s0,-80
    80005864:	854a                	mv	a0,s2
    80005866:	fffff097          	auipc	ra,0xfffff
    8000586a:	b3e080e7          	jalr	-1218(ra) # 800043a4 <dirlookup>
    8000586e:	84aa                	mv	s1,a0
    80005870:	c921                	beqz	a0,800058c0 <create+0x94>
    iunlockput(dp);
    80005872:	854a                	mv	a0,s2
    80005874:	fffff097          	auipc	ra,0xfffff
    80005878:	8b0080e7          	jalr	-1872(ra) # 80004124 <iunlockput>
    ilock(ip);
    8000587c:	8526                	mv	a0,s1
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	644080e7          	jalr	1604(ra) # 80003ec2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005886:	2981                	sext.w	s3,s3
    80005888:	4789                	li	a5,2
    8000588a:	02f99463          	bne	s3,a5,800058b2 <create+0x86>
    8000588e:	0444d783          	lhu	a5,68(s1)
    80005892:	37f9                	addiw	a5,a5,-2
    80005894:	17c2                	slli	a5,a5,0x30
    80005896:	93c1                	srli	a5,a5,0x30
    80005898:	4705                	li	a4,1
    8000589a:	00f76c63          	bltu	a4,a5,800058b2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000589e:	8526                	mv	a0,s1
    800058a0:	60a6                	ld	ra,72(sp)
    800058a2:	6406                	ld	s0,64(sp)
    800058a4:	74e2                	ld	s1,56(sp)
    800058a6:	7942                	ld	s2,48(sp)
    800058a8:	79a2                	ld	s3,40(sp)
    800058aa:	7a02                	ld	s4,32(sp)
    800058ac:	6ae2                	ld	s5,24(sp)
    800058ae:	6161                	addi	sp,sp,80
    800058b0:	8082                	ret
    iunlockput(ip);
    800058b2:	8526                	mv	a0,s1
    800058b4:	fffff097          	auipc	ra,0xfffff
    800058b8:	870080e7          	jalr	-1936(ra) # 80004124 <iunlockput>
    return 0;
    800058bc:	4481                	li	s1,0
    800058be:	b7c5                	j	8000589e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800058c0:	85ce                	mv	a1,s3
    800058c2:	00092503          	lw	a0,0(s2)
    800058c6:	ffffe097          	auipc	ra,0xffffe
    800058ca:	464080e7          	jalr	1124(ra) # 80003d2a <ialloc>
    800058ce:	84aa                	mv	s1,a0
    800058d0:	c521                	beqz	a0,80005918 <create+0xec>
  ilock(ip);
    800058d2:	ffffe097          	auipc	ra,0xffffe
    800058d6:	5f0080e7          	jalr	1520(ra) # 80003ec2 <ilock>
  ip->major = major;
    800058da:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800058de:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800058e2:	4a05                	li	s4,1
    800058e4:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800058e8:	8526                	mv	a0,s1
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	50e080e7          	jalr	1294(ra) # 80003df8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800058f2:	2981                	sext.w	s3,s3
    800058f4:	03498a63          	beq	s3,s4,80005928 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800058f8:	40d0                	lw	a2,4(s1)
    800058fa:	fb040593          	addi	a1,s0,-80
    800058fe:	854a                	mv	a0,s2
    80005900:	fffff097          	auipc	ra,0xfffff
    80005904:	cb4080e7          	jalr	-844(ra) # 800045b4 <dirlink>
    80005908:	06054b63          	bltz	a0,8000597e <create+0x152>
  iunlockput(dp);
    8000590c:	854a                	mv	a0,s2
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	816080e7          	jalr	-2026(ra) # 80004124 <iunlockput>
  return ip;
    80005916:	b761                	j	8000589e <create+0x72>
    panic("create: ialloc");
    80005918:	00003517          	auipc	a0,0x3
    8000591c:	f4050513          	addi	a0,a0,-192 # 80008858 <syscalls+0x2d0>
    80005920:	ffffb097          	auipc	ra,0xffffb
    80005924:	cc4080e7          	jalr	-828(ra) # 800005e4 <panic>
    dp->nlink++;  // for ".."
    80005928:	04a95783          	lhu	a5,74(s2)
    8000592c:	2785                	addiw	a5,a5,1
    8000592e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005932:	854a                	mv	a0,s2
    80005934:	ffffe097          	auipc	ra,0xffffe
    80005938:	4c4080e7          	jalr	1220(ra) # 80003df8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000593c:	40d0                	lw	a2,4(s1)
    8000593e:	00003597          	auipc	a1,0x3
    80005942:	f2a58593          	addi	a1,a1,-214 # 80008868 <syscalls+0x2e0>
    80005946:	8526                	mv	a0,s1
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	c6c080e7          	jalr	-916(ra) # 800045b4 <dirlink>
    80005950:	00054f63          	bltz	a0,8000596e <create+0x142>
    80005954:	00492603          	lw	a2,4(s2)
    80005958:	00003597          	auipc	a1,0x3
    8000595c:	f1858593          	addi	a1,a1,-232 # 80008870 <syscalls+0x2e8>
    80005960:	8526                	mv	a0,s1
    80005962:	fffff097          	auipc	ra,0xfffff
    80005966:	c52080e7          	jalr	-942(ra) # 800045b4 <dirlink>
    8000596a:	f80557e3          	bgez	a0,800058f8 <create+0xcc>
      panic("create dots");
    8000596e:	00003517          	auipc	a0,0x3
    80005972:	f0a50513          	addi	a0,a0,-246 # 80008878 <syscalls+0x2f0>
    80005976:	ffffb097          	auipc	ra,0xffffb
    8000597a:	c6e080e7          	jalr	-914(ra) # 800005e4 <panic>
    panic("create: dirlink");
    8000597e:	00003517          	auipc	a0,0x3
    80005982:	f0a50513          	addi	a0,a0,-246 # 80008888 <syscalls+0x300>
    80005986:	ffffb097          	auipc	ra,0xffffb
    8000598a:	c5e080e7          	jalr	-930(ra) # 800005e4 <panic>
    return 0;
    8000598e:	84aa                	mv	s1,a0
    80005990:	b739                	j	8000589e <create+0x72>

0000000080005992 <sys_dup>:
{
    80005992:	7179                	addi	sp,sp,-48
    80005994:	f406                	sd	ra,40(sp)
    80005996:	f022                	sd	s0,32(sp)
    80005998:	ec26                	sd	s1,24(sp)
    8000599a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000599c:	fd840613          	addi	a2,s0,-40
    800059a0:	4581                	li	a1,0
    800059a2:	4501                	li	a0,0
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	dde080e7          	jalr	-546(ra) # 80005782 <argfd>
    return -1;
    800059ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800059ae:	02054363          	bltz	a0,800059d4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800059b2:	fd843503          	ld	a0,-40(s0)
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	e34080e7          	jalr	-460(ra) # 800057ea <fdalloc>
    800059be:	84aa                	mv	s1,a0
    return -1;
    800059c0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800059c2:	00054963          	bltz	a0,800059d4 <sys_dup+0x42>
  filedup(f);
    800059c6:	fd843503          	ld	a0,-40(s0)
    800059ca:	fffff097          	auipc	ra,0xfffff
    800059ce:	338080e7          	jalr	824(ra) # 80004d02 <filedup>
  return fd;
    800059d2:	87a6                	mv	a5,s1
}
    800059d4:	853e                	mv	a0,a5
    800059d6:	70a2                	ld	ra,40(sp)
    800059d8:	7402                	ld	s0,32(sp)
    800059da:	64e2                	ld	s1,24(sp)
    800059dc:	6145                	addi	sp,sp,48
    800059de:	8082                	ret

00000000800059e0 <sys_read>:
{
    800059e0:	7179                	addi	sp,sp,-48
    800059e2:	f406                	sd	ra,40(sp)
    800059e4:	f022                	sd	s0,32(sp)
    800059e6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800059e8:	fe840613          	addi	a2,s0,-24
    800059ec:	4581                	li	a1,0
    800059ee:	4501                	li	a0,0
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	d92080e7          	jalr	-622(ra) # 80005782 <argfd>
    return -1;
    800059f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800059fa:	04054163          	bltz	a0,80005a3c <sys_read+0x5c>
    800059fe:	fe440593          	addi	a1,s0,-28
    80005a02:	4509                	li	a0,2
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	90c080e7          	jalr	-1780(ra) # 80003310 <argint>
    return -1;
    80005a0c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a0e:	02054763          	bltz	a0,80005a3c <sys_read+0x5c>
    80005a12:	fd840593          	addi	a1,s0,-40
    80005a16:	4505                	li	a0,1
    80005a18:	ffffe097          	auipc	ra,0xffffe
    80005a1c:	91a080e7          	jalr	-1766(ra) # 80003332 <argaddr>
    return -1;
    80005a20:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a22:	00054d63          	bltz	a0,80005a3c <sys_read+0x5c>
  return fileread(f, p, n);
    80005a26:	fe442603          	lw	a2,-28(s0)
    80005a2a:	fd843583          	ld	a1,-40(s0)
    80005a2e:	fe843503          	ld	a0,-24(s0)
    80005a32:	fffff097          	auipc	ra,0xfffff
    80005a36:	45c080e7          	jalr	1116(ra) # 80004e8e <fileread>
    80005a3a:	87aa                	mv	a5,a0
}
    80005a3c:	853e                	mv	a0,a5
    80005a3e:	70a2                	ld	ra,40(sp)
    80005a40:	7402                	ld	s0,32(sp)
    80005a42:	6145                	addi	sp,sp,48
    80005a44:	8082                	ret

0000000080005a46 <sys_write>:
{
    80005a46:	7179                	addi	sp,sp,-48
    80005a48:	f406                	sd	ra,40(sp)
    80005a4a:	f022                	sd	s0,32(sp)
    80005a4c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a4e:	fe840613          	addi	a2,s0,-24
    80005a52:	4581                	li	a1,0
    80005a54:	4501                	li	a0,0
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	d2c080e7          	jalr	-724(ra) # 80005782 <argfd>
    return -1;
    80005a5e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a60:	04054163          	bltz	a0,80005aa2 <sys_write+0x5c>
    80005a64:	fe440593          	addi	a1,s0,-28
    80005a68:	4509                	li	a0,2
    80005a6a:	ffffe097          	auipc	ra,0xffffe
    80005a6e:	8a6080e7          	jalr	-1882(ra) # 80003310 <argint>
    return -1;
    80005a72:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a74:	02054763          	bltz	a0,80005aa2 <sys_write+0x5c>
    80005a78:	fd840593          	addi	a1,s0,-40
    80005a7c:	4505                	li	a0,1
    80005a7e:	ffffe097          	auipc	ra,0xffffe
    80005a82:	8b4080e7          	jalr	-1868(ra) # 80003332 <argaddr>
    return -1;
    80005a86:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a88:	00054d63          	bltz	a0,80005aa2 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005a8c:	fe442603          	lw	a2,-28(s0)
    80005a90:	fd843583          	ld	a1,-40(s0)
    80005a94:	fe843503          	ld	a0,-24(s0)
    80005a98:	fffff097          	auipc	ra,0xfffff
    80005a9c:	4b8080e7          	jalr	1208(ra) # 80004f50 <filewrite>
    80005aa0:	87aa                	mv	a5,a0
}
    80005aa2:	853e                	mv	a0,a5
    80005aa4:	70a2                	ld	ra,40(sp)
    80005aa6:	7402                	ld	s0,32(sp)
    80005aa8:	6145                	addi	sp,sp,48
    80005aaa:	8082                	ret

0000000080005aac <sys_close>:
{
    80005aac:	1101                	addi	sp,sp,-32
    80005aae:	ec06                	sd	ra,24(sp)
    80005ab0:	e822                	sd	s0,16(sp)
    80005ab2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005ab4:	fe040613          	addi	a2,s0,-32
    80005ab8:	fec40593          	addi	a1,s0,-20
    80005abc:	4501                	li	a0,0
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	cc4080e7          	jalr	-828(ra) # 80005782 <argfd>
    return -1;
    80005ac6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005ac8:	02054463          	bltz	a0,80005af0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005acc:	ffffc097          	auipc	ra,0xffffc
    80005ad0:	610080e7          	jalr	1552(ra) # 800020dc <myproc>
    80005ad4:	fec42783          	lw	a5,-20(s0)
    80005ad8:	07e9                	addi	a5,a5,26
    80005ada:	078e                	slli	a5,a5,0x3
    80005adc:	97aa                	add	a5,a5,a0
    80005ade:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005ae2:	fe043503          	ld	a0,-32(s0)
    80005ae6:	fffff097          	auipc	ra,0xfffff
    80005aea:	26e080e7          	jalr	622(ra) # 80004d54 <fileclose>
  return 0;
    80005aee:	4781                	li	a5,0
}
    80005af0:	853e                	mv	a0,a5
    80005af2:	60e2                	ld	ra,24(sp)
    80005af4:	6442                	ld	s0,16(sp)
    80005af6:	6105                	addi	sp,sp,32
    80005af8:	8082                	ret

0000000080005afa <sys_fstat>:
{
    80005afa:	1101                	addi	sp,sp,-32
    80005afc:	ec06                	sd	ra,24(sp)
    80005afe:	e822                	sd	s0,16(sp)
    80005b00:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005b02:	fe840613          	addi	a2,s0,-24
    80005b06:	4581                	li	a1,0
    80005b08:	4501                	li	a0,0
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	c78080e7          	jalr	-904(ra) # 80005782 <argfd>
    return -1;
    80005b12:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005b14:	02054563          	bltz	a0,80005b3e <sys_fstat+0x44>
    80005b18:	fe040593          	addi	a1,s0,-32
    80005b1c:	4505                	li	a0,1
    80005b1e:	ffffe097          	auipc	ra,0xffffe
    80005b22:	814080e7          	jalr	-2028(ra) # 80003332 <argaddr>
    return -1;
    80005b26:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005b28:	00054b63          	bltz	a0,80005b3e <sys_fstat+0x44>
  return filestat(f, st);
    80005b2c:	fe043583          	ld	a1,-32(s0)
    80005b30:	fe843503          	ld	a0,-24(s0)
    80005b34:	fffff097          	auipc	ra,0xfffff
    80005b38:	2e8080e7          	jalr	744(ra) # 80004e1c <filestat>
    80005b3c:	87aa                	mv	a5,a0
}
    80005b3e:	853e                	mv	a0,a5
    80005b40:	60e2                	ld	ra,24(sp)
    80005b42:	6442                	ld	s0,16(sp)
    80005b44:	6105                	addi	sp,sp,32
    80005b46:	8082                	ret

0000000080005b48 <sys_link>:
{
    80005b48:	7169                	addi	sp,sp,-304
    80005b4a:	f606                	sd	ra,296(sp)
    80005b4c:	f222                	sd	s0,288(sp)
    80005b4e:	ee26                	sd	s1,280(sp)
    80005b50:	ea4a                	sd	s2,272(sp)
    80005b52:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b54:	08000613          	li	a2,128
    80005b58:	ed040593          	addi	a1,s0,-304
    80005b5c:	4501                	li	a0,0
    80005b5e:	ffffd097          	auipc	ra,0xffffd
    80005b62:	7f6080e7          	jalr	2038(ra) # 80003354 <argstr>
    return -1;
    80005b66:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b68:	10054e63          	bltz	a0,80005c84 <sys_link+0x13c>
    80005b6c:	08000613          	li	a2,128
    80005b70:	f5040593          	addi	a1,s0,-176
    80005b74:	4505                	li	a0,1
    80005b76:	ffffd097          	auipc	ra,0xffffd
    80005b7a:	7de080e7          	jalr	2014(ra) # 80003354 <argstr>
    return -1;
    80005b7e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b80:	10054263          	bltz	a0,80005c84 <sys_link+0x13c>
  begin_op();
    80005b84:	fffff097          	auipc	ra,0xfffff
    80005b88:	cfe080e7          	jalr	-770(ra) # 80004882 <begin_op>
  if((ip = namei(old)) == 0){
    80005b8c:	ed040513          	addi	a0,s0,-304
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	ae6080e7          	jalr	-1306(ra) # 80004676 <namei>
    80005b98:	84aa                	mv	s1,a0
    80005b9a:	c551                	beqz	a0,80005c26 <sys_link+0xde>
  ilock(ip);
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	326080e7          	jalr	806(ra) # 80003ec2 <ilock>
  if(ip->type == T_DIR){
    80005ba4:	04449703          	lh	a4,68(s1)
    80005ba8:	4785                	li	a5,1
    80005baa:	08f70463          	beq	a4,a5,80005c32 <sys_link+0xea>
  ip->nlink++;
    80005bae:	04a4d783          	lhu	a5,74(s1)
    80005bb2:	2785                	addiw	a5,a5,1
    80005bb4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005bb8:	8526                	mv	a0,s1
    80005bba:	ffffe097          	auipc	ra,0xffffe
    80005bbe:	23e080e7          	jalr	574(ra) # 80003df8 <iupdate>
  iunlock(ip);
    80005bc2:	8526                	mv	a0,s1
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	3c0080e7          	jalr	960(ra) # 80003f84 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005bcc:	fd040593          	addi	a1,s0,-48
    80005bd0:	f5040513          	addi	a0,s0,-176
    80005bd4:	fffff097          	auipc	ra,0xfffff
    80005bd8:	ac0080e7          	jalr	-1344(ra) # 80004694 <nameiparent>
    80005bdc:	892a                	mv	s2,a0
    80005bde:	c935                	beqz	a0,80005c52 <sys_link+0x10a>
  ilock(dp);
    80005be0:	ffffe097          	auipc	ra,0xffffe
    80005be4:	2e2080e7          	jalr	738(ra) # 80003ec2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005be8:	00092703          	lw	a4,0(s2)
    80005bec:	409c                	lw	a5,0(s1)
    80005bee:	04f71d63          	bne	a4,a5,80005c48 <sys_link+0x100>
    80005bf2:	40d0                	lw	a2,4(s1)
    80005bf4:	fd040593          	addi	a1,s0,-48
    80005bf8:	854a                	mv	a0,s2
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	9ba080e7          	jalr	-1606(ra) # 800045b4 <dirlink>
    80005c02:	04054363          	bltz	a0,80005c48 <sys_link+0x100>
  iunlockput(dp);
    80005c06:	854a                	mv	a0,s2
    80005c08:	ffffe097          	auipc	ra,0xffffe
    80005c0c:	51c080e7          	jalr	1308(ra) # 80004124 <iunlockput>
  iput(ip);
    80005c10:	8526                	mv	a0,s1
    80005c12:	ffffe097          	auipc	ra,0xffffe
    80005c16:	46a080e7          	jalr	1130(ra) # 8000407c <iput>
  end_op();
    80005c1a:	fffff097          	auipc	ra,0xfffff
    80005c1e:	ce8080e7          	jalr	-792(ra) # 80004902 <end_op>
  return 0;
    80005c22:	4781                	li	a5,0
    80005c24:	a085                	j	80005c84 <sys_link+0x13c>
    end_op();
    80005c26:	fffff097          	auipc	ra,0xfffff
    80005c2a:	cdc080e7          	jalr	-804(ra) # 80004902 <end_op>
    return -1;
    80005c2e:	57fd                	li	a5,-1
    80005c30:	a891                	j	80005c84 <sys_link+0x13c>
    iunlockput(ip);
    80005c32:	8526                	mv	a0,s1
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	4f0080e7          	jalr	1264(ra) # 80004124 <iunlockput>
    end_op();
    80005c3c:	fffff097          	auipc	ra,0xfffff
    80005c40:	cc6080e7          	jalr	-826(ra) # 80004902 <end_op>
    return -1;
    80005c44:	57fd                	li	a5,-1
    80005c46:	a83d                	j	80005c84 <sys_link+0x13c>
    iunlockput(dp);
    80005c48:	854a                	mv	a0,s2
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	4da080e7          	jalr	1242(ra) # 80004124 <iunlockput>
  ilock(ip);
    80005c52:	8526                	mv	a0,s1
    80005c54:	ffffe097          	auipc	ra,0xffffe
    80005c58:	26e080e7          	jalr	622(ra) # 80003ec2 <ilock>
  ip->nlink--;
    80005c5c:	04a4d783          	lhu	a5,74(s1)
    80005c60:	37fd                	addiw	a5,a5,-1
    80005c62:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c66:	8526                	mv	a0,s1
    80005c68:	ffffe097          	auipc	ra,0xffffe
    80005c6c:	190080e7          	jalr	400(ra) # 80003df8 <iupdate>
  iunlockput(ip);
    80005c70:	8526                	mv	a0,s1
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	4b2080e7          	jalr	1202(ra) # 80004124 <iunlockput>
  end_op();
    80005c7a:	fffff097          	auipc	ra,0xfffff
    80005c7e:	c88080e7          	jalr	-888(ra) # 80004902 <end_op>
  return -1;
    80005c82:	57fd                	li	a5,-1
}
    80005c84:	853e                	mv	a0,a5
    80005c86:	70b2                	ld	ra,296(sp)
    80005c88:	7412                	ld	s0,288(sp)
    80005c8a:	64f2                	ld	s1,280(sp)
    80005c8c:	6952                	ld	s2,272(sp)
    80005c8e:	6155                	addi	sp,sp,304
    80005c90:	8082                	ret

0000000080005c92 <sys_unlink>:
{
    80005c92:	7151                	addi	sp,sp,-240
    80005c94:	f586                	sd	ra,232(sp)
    80005c96:	f1a2                	sd	s0,224(sp)
    80005c98:	eda6                	sd	s1,216(sp)
    80005c9a:	e9ca                	sd	s2,208(sp)
    80005c9c:	e5ce                	sd	s3,200(sp)
    80005c9e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005ca0:	08000613          	li	a2,128
    80005ca4:	f3040593          	addi	a1,s0,-208
    80005ca8:	4501                	li	a0,0
    80005caa:	ffffd097          	auipc	ra,0xffffd
    80005cae:	6aa080e7          	jalr	1706(ra) # 80003354 <argstr>
    80005cb2:	18054163          	bltz	a0,80005e34 <sys_unlink+0x1a2>
  begin_op();
    80005cb6:	fffff097          	auipc	ra,0xfffff
    80005cba:	bcc080e7          	jalr	-1076(ra) # 80004882 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005cbe:	fb040593          	addi	a1,s0,-80
    80005cc2:	f3040513          	addi	a0,s0,-208
    80005cc6:	fffff097          	auipc	ra,0xfffff
    80005cca:	9ce080e7          	jalr	-1586(ra) # 80004694 <nameiparent>
    80005cce:	84aa                	mv	s1,a0
    80005cd0:	c979                	beqz	a0,80005da6 <sys_unlink+0x114>
  ilock(dp);
    80005cd2:	ffffe097          	auipc	ra,0xffffe
    80005cd6:	1f0080e7          	jalr	496(ra) # 80003ec2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005cda:	00003597          	auipc	a1,0x3
    80005cde:	b8e58593          	addi	a1,a1,-1138 # 80008868 <syscalls+0x2e0>
    80005ce2:	fb040513          	addi	a0,s0,-80
    80005ce6:	ffffe097          	auipc	ra,0xffffe
    80005cea:	6a4080e7          	jalr	1700(ra) # 8000438a <namecmp>
    80005cee:	14050a63          	beqz	a0,80005e42 <sys_unlink+0x1b0>
    80005cf2:	00003597          	auipc	a1,0x3
    80005cf6:	b7e58593          	addi	a1,a1,-1154 # 80008870 <syscalls+0x2e8>
    80005cfa:	fb040513          	addi	a0,s0,-80
    80005cfe:	ffffe097          	auipc	ra,0xffffe
    80005d02:	68c080e7          	jalr	1676(ra) # 8000438a <namecmp>
    80005d06:	12050e63          	beqz	a0,80005e42 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005d0a:	f2c40613          	addi	a2,s0,-212
    80005d0e:	fb040593          	addi	a1,s0,-80
    80005d12:	8526                	mv	a0,s1
    80005d14:	ffffe097          	auipc	ra,0xffffe
    80005d18:	690080e7          	jalr	1680(ra) # 800043a4 <dirlookup>
    80005d1c:	892a                	mv	s2,a0
    80005d1e:	12050263          	beqz	a0,80005e42 <sys_unlink+0x1b0>
  ilock(ip);
    80005d22:	ffffe097          	auipc	ra,0xffffe
    80005d26:	1a0080e7          	jalr	416(ra) # 80003ec2 <ilock>
  if(ip->nlink < 1)
    80005d2a:	04a91783          	lh	a5,74(s2)
    80005d2e:	08f05263          	blez	a5,80005db2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005d32:	04491703          	lh	a4,68(s2)
    80005d36:	4785                	li	a5,1
    80005d38:	08f70563          	beq	a4,a5,80005dc2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005d3c:	4641                	li	a2,16
    80005d3e:	4581                	li	a1,0
    80005d40:	fc040513          	addi	a0,s0,-64
    80005d44:	ffffb097          	auipc	ra,0xffffb
    80005d48:	0f2080e7          	jalr	242(ra) # 80000e36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d4c:	4741                	li	a4,16
    80005d4e:	f2c42683          	lw	a3,-212(s0)
    80005d52:	fc040613          	addi	a2,s0,-64
    80005d56:	4581                	li	a1,0
    80005d58:	8526                	mv	a0,s1
    80005d5a:	ffffe097          	auipc	ra,0xffffe
    80005d5e:	514080e7          	jalr	1300(ra) # 8000426e <writei>
    80005d62:	47c1                	li	a5,16
    80005d64:	0af51563          	bne	a0,a5,80005e0e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005d68:	04491703          	lh	a4,68(s2)
    80005d6c:	4785                	li	a5,1
    80005d6e:	0af70863          	beq	a4,a5,80005e1e <sys_unlink+0x18c>
  iunlockput(dp);
    80005d72:	8526                	mv	a0,s1
    80005d74:	ffffe097          	auipc	ra,0xffffe
    80005d78:	3b0080e7          	jalr	944(ra) # 80004124 <iunlockput>
  ip->nlink--;
    80005d7c:	04a95783          	lhu	a5,74(s2)
    80005d80:	37fd                	addiw	a5,a5,-1
    80005d82:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005d86:	854a                	mv	a0,s2
    80005d88:	ffffe097          	auipc	ra,0xffffe
    80005d8c:	070080e7          	jalr	112(ra) # 80003df8 <iupdate>
  iunlockput(ip);
    80005d90:	854a                	mv	a0,s2
    80005d92:	ffffe097          	auipc	ra,0xffffe
    80005d96:	392080e7          	jalr	914(ra) # 80004124 <iunlockput>
  end_op();
    80005d9a:	fffff097          	auipc	ra,0xfffff
    80005d9e:	b68080e7          	jalr	-1176(ra) # 80004902 <end_op>
  return 0;
    80005da2:	4501                	li	a0,0
    80005da4:	a84d                	j	80005e56 <sys_unlink+0x1c4>
    end_op();
    80005da6:	fffff097          	auipc	ra,0xfffff
    80005daa:	b5c080e7          	jalr	-1188(ra) # 80004902 <end_op>
    return -1;
    80005dae:	557d                	li	a0,-1
    80005db0:	a05d                	j	80005e56 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005db2:	00003517          	auipc	a0,0x3
    80005db6:	ae650513          	addi	a0,a0,-1306 # 80008898 <syscalls+0x310>
    80005dba:	ffffb097          	auipc	ra,0xffffb
    80005dbe:	82a080e7          	jalr	-2006(ra) # 800005e4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005dc2:	04c92703          	lw	a4,76(s2)
    80005dc6:	02000793          	li	a5,32
    80005dca:	f6e7f9e3          	bgeu	a5,a4,80005d3c <sys_unlink+0xaa>
    80005dce:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005dd2:	4741                	li	a4,16
    80005dd4:	86ce                	mv	a3,s3
    80005dd6:	f1840613          	addi	a2,s0,-232
    80005dda:	4581                	li	a1,0
    80005ddc:	854a                	mv	a0,s2
    80005dde:	ffffe097          	auipc	ra,0xffffe
    80005de2:	398080e7          	jalr	920(ra) # 80004176 <readi>
    80005de6:	47c1                	li	a5,16
    80005de8:	00f51b63          	bne	a0,a5,80005dfe <sys_unlink+0x16c>
    if(de.inum != 0)
    80005dec:	f1845783          	lhu	a5,-232(s0)
    80005df0:	e7a1                	bnez	a5,80005e38 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005df2:	29c1                	addiw	s3,s3,16
    80005df4:	04c92783          	lw	a5,76(s2)
    80005df8:	fcf9ede3          	bltu	s3,a5,80005dd2 <sys_unlink+0x140>
    80005dfc:	b781                	j	80005d3c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005dfe:	00003517          	auipc	a0,0x3
    80005e02:	ab250513          	addi	a0,a0,-1358 # 800088b0 <syscalls+0x328>
    80005e06:	ffffa097          	auipc	ra,0xffffa
    80005e0a:	7de080e7          	jalr	2014(ra) # 800005e4 <panic>
    panic("unlink: writei");
    80005e0e:	00003517          	auipc	a0,0x3
    80005e12:	aba50513          	addi	a0,a0,-1350 # 800088c8 <syscalls+0x340>
    80005e16:	ffffa097          	auipc	ra,0xffffa
    80005e1a:	7ce080e7          	jalr	1998(ra) # 800005e4 <panic>
    dp->nlink--;
    80005e1e:	04a4d783          	lhu	a5,74(s1)
    80005e22:	37fd                	addiw	a5,a5,-1
    80005e24:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e28:	8526                	mv	a0,s1
    80005e2a:	ffffe097          	auipc	ra,0xffffe
    80005e2e:	fce080e7          	jalr	-50(ra) # 80003df8 <iupdate>
    80005e32:	b781                	j	80005d72 <sys_unlink+0xe0>
    return -1;
    80005e34:	557d                	li	a0,-1
    80005e36:	a005                	j	80005e56 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005e38:	854a                	mv	a0,s2
    80005e3a:	ffffe097          	auipc	ra,0xffffe
    80005e3e:	2ea080e7          	jalr	746(ra) # 80004124 <iunlockput>
  iunlockput(dp);
    80005e42:	8526                	mv	a0,s1
    80005e44:	ffffe097          	auipc	ra,0xffffe
    80005e48:	2e0080e7          	jalr	736(ra) # 80004124 <iunlockput>
  end_op();
    80005e4c:	fffff097          	auipc	ra,0xfffff
    80005e50:	ab6080e7          	jalr	-1354(ra) # 80004902 <end_op>
  return -1;
    80005e54:	557d                	li	a0,-1
}
    80005e56:	70ae                	ld	ra,232(sp)
    80005e58:	740e                	ld	s0,224(sp)
    80005e5a:	64ee                	ld	s1,216(sp)
    80005e5c:	694e                	ld	s2,208(sp)
    80005e5e:	69ae                	ld	s3,200(sp)
    80005e60:	616d                	addi	sp,sp,240
    80005e62:	8082                	ret

0000000080005e64 <sys_open>:

uint64
sys_open(void)
{
    80005e64:	7131                	addi	sp,sp,-192
    80005e66:	fd06                	sd	ra,184(sp)
    80005e68:	f922                	sd	s0,176(sp)
    80005e6a:	f526                	sd	s1,168(sp)
    80005e6c:	f14a                	sd	s2,160(sp)
    80005e6e:	ed4e                	sd	s3,152(sp)
    80005e70:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005e72:	08000613          	li	a2,128
    80005e76:	f5040593          	addi	a1,s0,-176
    80005e7a:	4501                	li	a0,0
    80005e7c:	ffffd097          	auipc	ra,0xffffd
    80005e80:	4d8080e7          	jalr	1240(ra) # 80003354 <argstr>
    return -1;
    80005e84:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005e86:	0c054163          	bltz	a0,80005f48 <sys_open+0xe4>
    80005e8a:	f4c40593          	addi	a1,s0,-180
    80005e8e:	4505                	li	a0,1
    80005e90:	ffffd097          	auipc	ra,0xffffd
    80005e94:	480080e7          	jalr	1152(ra) # 80003310 <argint>
    80005e98:	0a054863          	bltz	a0,80005f48 <sys_open+0xe4>

  begin_op();
    80005e9c:	fffff097          	auipc	ra,0xfffff
    80005ea0:	9e6080e7          	jalr	-1562(ra) # 80004882 <begin_op>

  if(omode & O_CREATE){
    80005ea4:	f4c42783          	lw	a5,-180(s0)
    80005ea8:	2007f793          	andi	a5,a5,512
    80005eac:	cbdd                	beqz	a5,80005f62 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005eae:	4681                	li	a3,0
    80005eb0:	4601                	li	a2,0
    80005eb2:	4589                	li	a1,2
    80005eb4:	f5040513          	addi	a0,s0,-176
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	974080e7          	jalr	-1676(ra) # 8000582c <create>
    80005ec0:	892a                	mv	s2,a0
    if(ip == 0){
    80005ec2:	c959                	beqz	a0,80005f58 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005ec4:	04491703          	lh	a4,68(s2)
    80005ec8:	478d                	li	a5,3
    80005eca:	00f71763          	bne	a4,a5,80005ed8 <sys_open+0x74>
    80005ece:	04695703          	lhu	a4,70(s2)
    80005ed2:	47a5                	li	a5,9
    80005ed4:	0ce7ec63          	bltu	a5,a4,80005fac <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ed8:	fffff097          	auipc	ra,0xfffff
    80005edc:	dc0080e7          	jalr	-576(ra) # 80004c98 <filealloc>
    80005ee0:	89aa                	mv	s3,a0
    80005ee2:	10050263          	beqz	a0,80005fe6 <sys_open+0x182>
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	904080e7          	jalr	-1788(ra) # 800057ea <fdalloc>
    80005eee:	84aa                	mv	s1,a0
    80005ef0:	0e054663          	bltz	a0,80005fdc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005ef4:	04491703          	lh	a4,68(s2)
    80005ef8:	478d                	li	a5,3
    80005efa:	0cf70463          	beq	a4,a5,80005fc2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005efe:	4789                	li	a5,2
    80005f00:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005f04:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005f08:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005f0c:	f4c42783          	lw	a5,-180(s0)
    80005f10:	0017c713          	xori	a4,a5,1
    80005f14:	8b05                	andi	a4,a4,1
    80005f16:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005f1a:	0037f713          	andi	a4,a5,3
    80005f1e:	00e03733          	snez	a4,a4
    80005f22:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005f26:	4007f793          	andi	a5,a5,1024
    80005f2a:	c791                	beqz	a5,80005f36 <sys_open+0xd2>
    80005f2c:	04491703          	lh	a4,68(s2)
    80005f30:	4789                	li	a5,2
    80005f32:	08f70f63          	beq	a4,a5,80005fd0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005f36:	854a                	mv	a0,s2
    80005f38:	ffffe097          	auipc	ra,0xffffe
    80005f3c:	04c080e7          	jalr	76(ra) # 80003f84 <iunlock>
  end_op();
    80005f40:	fffff097          	auipc	ra,0xfffff
    80005f44:	9c2080e7          	jalr	-1598(ra) # 80004902 <end_op>

  return fd;
}
    80005f48:	8526                	mv	a0,s1
    80005f4a:	70ea                	ld	ra,184(sp)
    80005f4c:	744a                	ld	s0,176(sp)
    80005f4e:	74aa                	ld	s1,168(sp)
    80005f50:	790a                	ld	s2,160(sp)
    80005f52:	69ea                	ld	s3,152(sp)
    80005f54:	6129                	addi	sp,sp,192
    80005f56:	8082                	ret
      end_op();
    80005f58:	fffff097          	auipc	ra,0xfffff
    80005f5c:	9aa080e7          	jalr	-1622(ra) # 80004902 <end_op>
      return -1;
    80005f60:	b7e5                	j	80005f48 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005f62:	f5040513          	addi	a0,s0,-176
    80005f66:	ffffe097          	auipc	ra,0xffffe
    80005f6a:	710080e7          	jalr	1808(ra) # 80004676 <namei>
    80005f6e:	892a                	mv	s2,a0
    80005f70:	c905                	beqz	a0,80005fa0 <sys_open+0x13c>
    ilock(ip);
    80005f72:	ffffe097          	auipc	ra,0xffffe
    80005f76:	f50080e7          	jalr	-176(ra) # 80003ec2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005f7a:	04491703          	lh	a4,68(s2)
    80005f7e:	4785                	li	a5,1
    80005f80:	f4f712e3          	bne	a4,a5,80005ec4 <sys_open+0x60>
    80005f84:	f4c42783          	lw	a5,-180(s0)
    80005f88:	dba1                	beqz	a5,80005ed8 <sys_open+0x74>
      iunlockput(ip);
    80005f8a:	854a                	mv	a0,s2
    80005f8c:	ffffe097          	auipc	ra,0xffffe
    80005f90:	198080e7          	jalr	408(ra) # 80004124 <iunlockput>
      end_op();
    80005f94:	fffff097          	auipc	ra,0xfffff
    80005f98:	96e080e7          	jalr	-1682(ra) # 80004902 <end_op>
      return -1;
    80005f9c:	54fd                	li	s1,-1
    80005f9e:	b76d                	j	80005f48 <sys_open+0xe4>
      end_op();
    80005fa0:	fffff097          	auipc	ra,0xfffff
    80005fa4:	962080e7          	jalr	-1694(ra) # 80004902 <end_op>
      return -1;
    80005fa8:	54fd                	li	s1,-1
    80005faa:	bf79                	j	80005f48 <sys_open+0xe4>
    iunlockput(ip);
    80005fac:	854a                	mv	a0,s2
    80005fae:	ffffe097          	auipc	ra,0xffffe
    80005fb2:	176080e7          	jalr	374(ra) # 80004124 <iunlockput>
    end_op();
    80005fb6:	fffff097          	auipc	ra,0xfffff
    80005fba:	94c080e7          	jalr	-1716(ra) # 80004902 <end_op>
    return -1;
    80005fbe:	54fd                	li	s1,-1
    80005fc0:	b761                	j	80005f48 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005fc2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005fc6:	04691783          	lh	a5,70(s2)
    80005fca:	02f99223          	sh	a5,36(s3)
    80005fce:	bf2d                	j	80005f08 <sys_open+0xa4>
    itrunc(ip);
    80005fd0:	854a                	mv	a0,s2
    80005fd2:	ffffe097          	auipc	ra,0xffffe
    80005fd6:	ffe080e7          	jalr	-2(ra) # 80003fd0 <itrunc>
    80005fda:	bfb1                	j	80005f36 <sys_open+0xd2>
      fileclose(f);
    80005fdc:	854e                	mv	a0,s3
    80005fde:	fffff097          	auipc	ra,0xfffff
    80005fe2:	d76080e7          	jalr	-650(ra) # 80004d54 <fileclose>
    iunlockput(ip);
    80005fe6:	854a                	mv	a0,s2
    80005fe8:	ffffe097          	auipc	ra,0xffffe
    80005fec:	13c080e7          	jalr	316(ra) # 80004124 <iunlockput>
    end_op();
    80005ff0:	fffff097          	auipc	ra,0xfffff
    80005ff4:	912080e7          	jalr	-1774(ra) # 80004902 <end_op>
    return -1;
    80005ff8:	54fd                	li	s1,-1
    80005ffa:	b7b9                	j	80005f48 <sys_open+0xe4>

0000000080005ffc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ffc:	7175                	addi	sp,sp,-144
    80005ffe:	e506                	sd	ra,136(sp)
    80006000:	e122                	sd	s0,128(sp)
    80006002:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006004:	fffff097          	auipc	ra,0xfffff
    80006008:	87e080e7          	jalr	-1922(ra) # 80004882 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000600c:	08000613          	li	a2,128
    80006010:	f7040593          	addi	a1,s0,-144
    80006014:	4501                	li	a0,0
    80006016:	ffffd097          	auipc	ra,0xffffd
    8000601a:	33e080e7          	jalr	830(ra) # 80003354 <argstr>
    8000601e:	02054963          	bltz	a0,80006050 <sys_mkdir+0x54>
    80006022:	4681                	li	a3,0
    80006024:	4601                	li	a2,0
    80006026:	4585                	li	a1,1
    80006028:	f7040513          	addi	a0,s0,-144
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	800080e7          	jalr	-2048(ra) # 8000582c <create>
    80006034:	cd11                	beqz	a0,80006050 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006036:	ffffe097          	auipc	ra,0xffffe
    8000603a:	0ee080e7          	jalr	238(ra) # 80004124 <iunlockput>
  end_op();
    8000603e:	fffff097          	auipc	ra,0xfffff
    80006042:	8c4080e7          	jalr	-1852(ra) # 80004902 <end_op>
  return 0;
    80006046:	4501                	li	a0,0
}
    80006048:	60aa                	ld	ra,136(sp)
    8000604a:	640a                	ld	s0,128(sp)
    8000604c:	6149                	addi	sp,sp,144
    8000604e:	8082                	ret
    end_op();
    80006050:	fffff097          	auipc	ra,0xfffff
    80006054:	8b2080e7          	jalr	-1870(ra) # 80004902 <end_op>
    return -1;
    80006058:	557d                	li	a0,-1
    8000605a:	b7fd                	j	80006048 <sys_mkdir+0x4c>

000000008000605c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000605c:	7135                	addi	sp,sp,-160
    8000605e:	ed06                	sd	ra,152(sp)
    80006060:	e922                	sd	s0,144(sp)
    80006062:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006064:	fffff097          	auipc	ra,0xfffff
    80006068:	81e080e7          	jalr	-2018(ra) # 80004882 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000606c:	08000613          	li	a2,128
    80006070:	f7040593          	addi	a1,s0,-144
    80006074:	4501                	li	a0,0
    80006076:	ffffd097          	auipc	ra,0xffffd
    8000607a:	2de080e7          	jalr	734(ra) # 80003354 <argstr>
    8000607e:	04054a63          	bltz	a0,800060d2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80006082:	f6c40593          	addi	a1,s0,-148
    80006086:	4505                	li	a0,1
    80006088:	ffffd097          	auipc	ra,0xffffd
    8000608c:	288080e7          	jalr	648(ra) # 80003310 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006090:	04054163          	bltz	a0,800060d2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80006094:	f6840593          	addi	a1,s0,-152
    80006098:	4509                	li	a0,2
    8000609a:	ffffd097          	auipc	ra,0xffffd
    8000609e:	276080e7          	jalr	630(ra) # 80003310 <argint>
     argint(1, &major) < 0 ||
    800060a2:	02054863          	bltz	a0,800060d2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800060a6:	f6841683          	lh	a3,-152(s0)
    800060aa:	f6c41603          	lh	a2,-148(s0)
    800060ae:	458d                	li	a1,3
    800060b0:	f7040513          	addi	a0,s0,-144
    800060b4:	fffff097          	auipc	ra,0xfffff
    800060b8:	778080e7          	jalr	1912(ra) # 8000582c <create>
     argint(2, &minor) < 0 ||
    800060bc:	c919                	beqz	a0,800060d2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800060be:	ffffe097          	auipc	ra,0xffffe
    800060c2:	066080e7          	jalr	102(ra) # 80004124 <iunlockput>
  end_op();
    800060c6:	fffff097          	auipc	ra,0xfffff
    800060ca:	83c080e7          	jalr	-1988(ra) # 80004902 <end_op>
  return 0;
    800060ce:	4501                	li	a0,0
    800060d0:	a031                	j	800060dc <sys_mknod+0x80>
    end_op();
    800060d2:	fffff097          	auipc	ra,0xfffff
    800060d6:	830080e7          	jalr	-2000(ra) # 80004902 <end_op>
    return -1;
    800060da:	557d                	li	a0,-1
}
    800060dc:	60ea                	ld	ra,152(sp)
    800060de:	644a                	ld	s0,144(sp)
    800060e0:	610d                	addi	sp,sp,160
    800060e2:	8082                	ret

00000000800060e4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800060e4:	7135                	addi	sp,sp,-160
    800060e6:	ed06                	sd	ra,152(sp)
    800060e8:	e922                	sd	s0,144(sp)
    800060ea:	e526                	sd	s1,136(sp)
    800060ec:	e14a                	sd	s2,128(sp)
    800060ee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800060f0:	ffffc097          	auipc	ra,0xffffc
    800060f4:	fec080e7          	jalr	-20(ra) # 800020dc <myproc>
    800060f8:	892a                	mv	s2,a0
  
  begin_op();
    800060fa:	ffffe097          	auipc	ra,0xffffe
    800060fe:	788080e7          	jalr	1928(ra) # 80004882 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006102:	08000613          	li	a2,128
    80006106:	f6040593          	addi	a1,s0,-160
    8000610a:	4501                	li	a0,0
    8000610c:	ffffd097          	auipc	ra,0xffffd
    80006110:	248080e7          	jalr	584(ra) # 80003354 <argstr>
    80006114:	04054b63          	bltz	a0,8000616a <sys_chdir+0x86>
    80006118:	f6040513          	addi	a0,s0,-160
    8000611c:	ffffe097          	auipc	ra,0xffffe
    80006120:	55a080e7          	jalr	1370(ra) # 80004676 <namei>
    80006124:	84aa                	mv	s1,a0
    80006126:	c131                	beqz	a0,8000616a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006128:	ffffe097          	auipc	ra,0xffffe
    8000612c:	d9a080e7          	jalr	-614(ra) # 80003ec2 <ilock>
  if(ip->type != T_DIR){
    80006130:	04449703          	lh	a4,68(s1)
    80006134:	4785                	li	a5,1
    80006136:	04f71063          	bne	a4,a5,80006176 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000613a:	8526                	mv	a0,s1
    8000613c:	ffffe097          	auipc	ra,0xffffe
    80006140:	e48080e7          	jalr	-440(ra) # 80003f84 <iunlock>
  iput(p->cwd);
    80006144:	16093503          	ld	a0,352(s2)
    80006148:	ffffe097          	auipc	ra,0xffffe
    8000614c:	f34080e7          	jalr	-204(ra) # 8000407c <iput>
  end_op();
    80006150:	ffffe097          	auipc	ra,0xffffe
    80006154:	7b2080e7          	jalr	1970(ra) # 80004902 <end_op>
  p->cwd = ip;
    80006158:	16993023          	sd	s1,352(s2)
  return 0;
    8000615c:	4501                	li	a0,0
}
    8000615e:	60ea                	ld	ra,152(sp)
    80006160:	644a                	ld	s0,144(sp)
    80006162:	64aa                	ld	s1,136(sp)
    80006164:	690a                	ld	s2,128(sp)
    80006166:	610d                	addi	sp,sp,160
    80006168:	8082                	ret
    end_op();
    8000616a:	ffffe097          	auipc	ra,0xffffe
    8000616e:	798080e7          	jalr	1944(ra) # 80004902 <end_op>
    return -1;
    80006172:	557d                	li	a0,-1
    80006174:	b7ed                	j	8000615e <sys_chdir+0x7a>
    iunlockput(ip);
    80006176:	8526                	mv	a0,s1
    80006178:	ffffe097          	auipc	ra,0xffffe
    8000617c:	fac080e7          	jalr	-84(ra) # 80004124 <iunlockput>
    end_op();
    80006180:	ffffe097          	auipc	ra,0xffffe
    80006184:	782080e7          	jalr	1922(ra) # 80004902 <end_op>
    return -1;
    80006188:	557d                	li	a0,-1
    8000618a:	bfd1                	j	8000615e <sys_chdir+0x7a>

000000008000618c <sys_exec>:

uint64
sys_exec(void)
{
    8000618c:	7145                	addi	sp,sp,-464
    8000618e:	e786                	sd	ra,456(sp)
    80006190:	e3a2                	sd	s0,448(sp)
    80006192:	ff26                	sd	s1,440(sp)
    80006194:	fb4a                	sd	s2,432(sp)
    80006196:	f74e                	sd	s3,424(sp)
    80006198:	f352                	sd	s4,416(sp)
    8000619a:	ef56                	sd	s5,408(sp)
    8000619c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000619e:	08000613          	li	a2,128
    800061a2:	f4040593          	addi	a1,s0,-192
    800061a6:	4501                	li	a0,0
    800061a8:	ffffd097          	auipc	ra,0xffffd
    800061ac:	1ac080e7          	jalr	428(ra) # 80003354 <argstr>
    return -1;
    800061b0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800061b2:	0c054a63          	bltz	a0,80006286 <sys_exec+0xfa>
    800061b6:	e3840593          	addi	a1,s0,-456
    800061ba:	4505                	li	a0,1
    800061bc:	ffffd097          	auipc	ra,0xffffd
    800061c0:	176080e7          	jalr	374(ra) # 80003332 <argaddr>
    800061c4:	0c054163          	bltz	a0,80006286 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800061c8:	10000613          	li	a2,256
    800061cc:	4581                	li	a1,0
    800061ce:	e4040513          	addi	a0,s0,-448
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	c64080e7          	jalr	-924(ra) # 80000e36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800061da:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800061de:	89a6                	mv	s3,s1
    800061e0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800061e2:	02000a13          	li	s4,32
    800061e6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800061ea:	00391793          	slli	a5,s2,0x3
    800061ee:	e3040593          	addi	a1,s0,-464
    800061f2:	e3843503          	ld	a0,-456(s0)
    800061f6:	953e                	add	a0,a0,a5
    800061f8:	ffffd097          	auipc	ra,0xffffd
    800061fc:	07e080e7          	jalr	126(ra) # 80003276 <fetchaddr>
    80006200:	02054a63          	bltz	a0,80006234 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80006204:	e3043783          	ld	a5,-464(s0)
    80006208:	c3b9                	beqz	a5,8000624e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000620a:	ffffb097          	auipc	ra,0xffffb
    8000620e:	9f2080e7          	jalr	-1550(ra) # 80000bfc <kalloc>
    80006212:	85aa                	mv	a1,a0
    80006214:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006218:	cd11                	beqz	a0,80006234 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000621a:	6605                	lui	a2,0x1
    8000621c:	e3043503          	ld	a0,-464(s0)
    80006220:	ffffd097          	auipc	ra,0xffffd
    80006224:	0a8080e7          	jalr	168(ra) # 800032c8 <fetchstr>
    80006228:	00054663          	bltz	a0,80006234 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000622c:	0905                	addi	s2,s2,1
    8000622e:	09a1                	addi	s3,s3,8
    80006230:	fb491be3          	bne	s2,s4,800061e6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006234:	10048913          	addi	s2,s1,256
    80006238:	6088                	ld	a0,0(s1)
    8000623a:	c529                	beqz	a0,80006284 <sys_exec+0xf8>
    kfree(argv[i]);
    8000623c:	ffffb097          	auipc	ra,0xffffb
    80006240:	84e080e7          	jalr	-1970(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006244:	04a1                	addi	s1,s1,8
    80006246:	ff2499e3          	bne	s1,s2,80006238 <sys_exec+0xac>
  return -1;
    8000624a:	597d                	li	s2,-1
    8000624c:	a82d                	j	80006286 <sys_exec+0xfa>
      argv[i] = 0;
    8000624e:	0a8e                	slli	s5,s5,0x3
    80006250:	fc040793          	addi	a5,s0,-64
    80006254:	9abe                	add	s5,s5,a5
    80006256:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffaae80>
  int ret = exec(path, argv);
    8000625a:	e4040593          	addi	a1,s0,-448
    8000625e:	f4040513          	addi	a0,s0,-192
    80006262:	fffff097          	auipc	ra,0xfffff
    80006266:	178080e7          	jalr	376(ra) # 800053da <exec>
    8000626a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000626c:	10048993          	addi	s3,s1,256
    80006270:	6088                	ld	a0,0(s1)
    80006272:	c911                	beqz	a0,80006286 <sys_exec+0xfa>
    kfree(argv[i]);
    80006274:	ffffb097          	auipc	ra,0xffffb
    80006278:	816080e7          	jalr	-2026(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000627c:	04a1                	addi	s1,s1,8
    8000627e:	ff3499e3          	bne	s1,s3,80006270 <sys_exec+0xe4>
    80006282:	a011                	j	80006286 <sys_exec+0xfa>
  return -1;
    80006284:	597d                	li	s2,-1
}
    80006286:	854a                	mv	a0,s2
    80006288:	60be                	ld	ra,456(sp)
    8000628a:	641e                	ld	s0,448(sp)
    8000628c:	74fa                	ld	s1,440(sp)
    8000628e:	795a                	ld	s2,432(sp)
    80006290:	79ba                	ld	s3,424(sp)
    80006292:	7a1a                	ld	s4,416(sp)
    80006294:	6afa                	ld	s5,408(sp)
    80006296:	6179                	addi	sp,sp,464
    80006298:	8082                	ret

000000008000629a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000629a:	7139                	addi	sp,sp,-64
    8000629c:	fc06                	sd	ra,56(sp)
    8000629e:	f822                	sd	s0,48(sp)
    800062a0:	f426                	sd	s1,40(sp)
    800062a2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800062a4:	ffffc097          	auipc	ra,0xffffc
    800062a8:	e38080e7          	jalr	-456(ra) # 800020dc <myproc>
    800062ac:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800062ae:	fd840593          	addi	a1,s0,-40
    800062b2:	4501                	li	a0,0
    800062b4:	ffffd097          	auipc	ra,0xffffd
    800062b8:	07e080e7          	jalr	126(ra) # 80003332 <argaddr>
    return -1;
    800062bc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800062be:	0e054063          	bltz	a0,8000639e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800062c2:	fc840593          	addi	a1,s0,-56
    800062c6:	fd040513          	addi	a0,s0,-48
    800062ca:	fffff097          	auipc	ra,0xfffff
    800062ce:	de0080e7          	jalr	-544(ra) # 800050aa <pipealloc>
    return -1;
    800062d2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800062d4:	0c054563          	bltz	a0,8000639e <sys_pipe+0x104>
  fd0 = -1;
    800062d8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800062dc:	fd043503          	ld	a0,-48(s0)
    800062e0:	fffff097          	auipc	ra,0xfffff
    800062e4:	50a080e7          	jalr	1290(ra) # 800057ea <fdalloc>
    800062e8:	fca42223          	sw	a0,-60(s0)
    800062ec:	08054c63          	bltz	a0,80006384 <sys_pipe+0xea>
    800062f0:	fc843503          	ld	a0,-56(s0)
    800062f4:	fffff097          	auipc	ra,0xfffff
    800062f8:	4f6080e7          	jalr	1270(ra) # 800057ea <fdalloc>
    800062fc:	fca42023          	sw	a0,-64(s0)
    80006300:	06054863          	bltz	a0,80006370 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006304:	4691                	li	a3,4
    80006306:	fc440613          	addi	a2,s0,-60
    8000630a:	fd843583          	ld	a1,-40(s0)
    8000630e:	68a8                	ld	a0,80(s1)
    80006310:	ffffb097          	auipc	ra,0xffffb
    80006314:	722080e7          	jalr	1826(ra) # 80001a32 <copyout>
    80006318:	02054063          	bltz	a0,80006338 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000631c:	4691                	li	a3,4
    8000631e:	fc040613          	addi	a2,s0,-64
    80006322:	fd843583          	ld	a1,-40(s0)
    80006326:	0591                	addi	a1,a1,4
    80006328:	68a8                	ld	a0,80(s1)
    8000632a:	ffffb097          	auipc	ra,0xffffb
    8000632e:	708080e7          	jalr	1800(ra) # 80001a32 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006332:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006334:	06055563          	bgez	a0,8000639e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80006338:	fc442783          	lw	a5,-60(s0)
    8000633c:	07e9                	addi	a5,a5,26
    8000633e:	078e                	slli	a5,a5,0x3
    80006340:	97a6                	add	a5,a5,s1
    80006342:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006346:	fc042503          	lw	a0,-64(s0)
    8000634a:	0569                	addi	a0,a0,26
    8000634c:	050e                	slli	a0,a0,0x3
    8000634e:	9526                	add	a0,a0,s1
    80006350:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006354:	fd043503          	ld	a0,-48(s0)
    80006358:	fffff097          	auipc	ra,0xfffff
    8000635c:	9fc080e7          	jalr	-1540(ra) # 80004d54 <fileclose>
    fileclose(wf);
    80006360:	fc843503          	ld	a0,-56(s0)
    80006364:	fffff097          	auipc	ra,0xfffff
    80006368:	9f0080e7          	jalr	-1552(ra) # 80004d54 <fileclose>
    return -1;
    8000636c:	57fd                	li	a5,-1
    8000636e:	a805                	j	8000639e <sys_pipe+0x104>
    if(fd0 >= 0)
    80006370:	fc442783          	lw	a5,-60(s0)
    80006374:	0007c863          	bltz	a5,80006384 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80006378:	01a78513          	addi	a0,a5,26
    8000637c:	050e                	slli	a0,a0,0x3
    8000637e:	9526                	add	a0,a0,s1
    80006380:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006384:	fd043503          	ld	a0,-48(s0)
    80006388:	fffff097          	auipc	ra,0xfffff
    8000638c:	9cc080e7          	jalr	-1588(ra) # 80004d54 <fileclose>
    fileclose(wf);
    80006390:	fc843503          	ld	a0,-56(s0)
    80006394:	fffff097          	auipc	ra,0xfffff
    80006398:	9c0080e7          	jalr	-1600(ra) # 80004d54 <fileclose>
    return -1;
    8000639c:	57fd                	li	a5,-1
}
    8000639e:	853e                	mv	a0,a5
    800063a0:	70e2                	ld	ra,56(sp)
    800063a2:	7442                	ld	s0,48(sp)
    800063a4:	74a2                	ld	s1,40(sp)
    800063a6:	6121                	addi	sp,sp,64
    800063a8:	8082                	ret
    800063aa:	0000                	unimp
    800063ac:	0000                	unimp
	...

00000000800063b0 <kernelvec>:
    800063b0:	7111                	addi	sp,sp,-256
    800063b2:	e006                	sd	ra,0(sp)
    800063b4:	e40a                	sd	sp,8(sp)
    800063b6:	e80e                	sd	gp,16(sp)
    800063b8:	ec12                	sd	tp,24(sp)
    800063ba:	f016                	sd	t0,32(sp)
    800063bc:	f41a                	sd	t1,40(sp)
    800063be:	f81e                	sd	t2,48(sp)
    800063c0:	fc22                	sd	s0,56(sp)
    800063c2:	e0a6                	sd	s1,64(sp)
    800063c4:	e4aa                	sd	a0,72(sp)
    800063c6:	e8ae                	sd	a1,80(sp)
    800063c8:	ecb2                	sd	a2,88(sp)
    800063ca:	f0b6                	sd	a3,96(sp)
    800063cc:	f4ba                	sd	a4,104(sp)
    800063ce:	f8be                	sd	a5,112(sp)
    800063d0:	fcc2                	sd	a6,120(sp)
    800063d2:	e146                	sd	a7,128(sp)
    800063d4:	e54a                	sd	s2,136(sp)
    800063d6:	e94e                	sd	s3,144(sp)
    800063d8:	ed52                	sd	s4,152(sp)
    800063da:	f156                	sd	s5,160(sp)
    800063dc:	f55a                	sd	s6,168(sp)
    800063de:	f95e                	sd	s7,176(sp)
    800063e0:	fd62                	sd	s8,184(sp)
    800063e2:	e1e6                	sd	s9,192(sp)
    800063e4:	e5ea                	sd	s10,200(sp)
    800063e6:	e9ee                	sd	s11,208(sp)
    800063e8:	edf2                	sd	t3,216(sp)
    800063ea:	f1f6                	sd	t4,224(sp)
    800063ec:	f5fa                	sd	t5,232(sp)
    800063ee:	f9fe                	sd	t6,240(sp)
    800063f0:	d53fc0ef          	jal	ra,80003142 <kerneltrap>
    800063f4:	6082                	ld	ra,0(sp)
    800063f6:	6122                	ld	sp,8(sp)
    800063f8:	61c2                	ld	gp,16(sp)
    800063fa:	7282                	ld	t0,32(sp)
    800063fc:	7322                	ld	t1,40(sp)
    800063fe:	73c2                	ld	t2,48(sp)
    80006400:	7462                	ld	s0,56(sp)
    80006402:	6486                	ld	s1,64(sp)
    80006404:	6526                	ld	a0,72(sp)
    80006406:	65c6                	ld	a1,80(sp)
    80006408:	6666                	ld	a2,88(sp)
    8000640a:	7686                	ld	a3,96(sp)
    8000640c:	7726                	ld	a4,104(sp)
    8000640e:	77c6                	ld	a5,112(sp)
    80006410:	7866                	ld	a6,120(sp)
    80006412:	688a                	ld	a7,128(sp)
    80006414:	692a                	ld	s2,136(sp)
    80006416:	69ca                	ld	s3,144(sp)
    80006418:	6a6a                	ld	s4,152(sp)
    8000641a:	7a8a                	ld	s5,160(sp)
    8000641c:	7b2a                	ld	s6,168(sp)
    8000641e:	7bca                	ld	s7,176(sp)
    80006420:	7c6a                	ld	s8,184(sp)
    80006422:	6c8e                	ld	s9,192(sp)
    80006424:	6d2e                	ld	s10,200(sp)
    80006426:	6dce                	ld	s11,208(sp)
    80006428:	6e6e                	ld	t3,216(sp)
    8000642a:	7e8e                	ld	t4,224(sp)
    8000642c:	7f2e                	ld	t5,232(sp)
    8000642e:	7fce                	ld	t6,240(sp)
    80006430:	6111                	addi	sp,sp,256
    80006432:	10200073          	sret
    80006436:	00000013          	nop
    8000643a:	00000013          	nop
    8000643e:	0001                	nop

0000000080006440 <timervec>:
    80006440:	34051573          	csrrw	a0,mscratch,a0
    80006444:	e10c                	sd	a1,0(a0)
    80006446:	e510                	sd	a2,8(a0)
    80006448:	e914                	sd	a3,16(a0)
    8000644a:	710c                	ld	a1,32(a0)
    8000644c:	7510                	ld	a2,40(a0)
    8000644e:	6194                	ld	a3,0(a1)
    80006450:	96b2                	add	a3,a3,a2
    80006452:	e194                	sd	a3,0(a1)
    80006454:	4589                	li	a1,2
    80006456:	14459073          	csrw	sip,a1
    8000645a:	6914                	ld	a3,16(a0)
    8000645c:	6510                	ld	a2,8(a0)
    8000645e:	610c                	ld	a1,0(a0)
    80006460:	34051573          	csrrw	a0,mscratch,a0
    80006464:	30200073          	mret
	...

000000008000646a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000646a:	1141                	addi	sp,sp,-16
    8000646c:	e422                	sd	s0,8(sp)
    8000646e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006470:	0c0007b7          	lui	a5,0xc000
    80006474:	4705                	li	a4,1
    80006476:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006478:	c3d8                	sw	a4,4(a5)
}
    8000647a:	6422                	ld	s0,8(sp)
    8000647c:	0141                	addi	sp,sp,16
    8000647e:	8082                	ret

0000000080006480 <plicinithart>:

void
plicinithart(void)
{
    80006480:	1141                	addi	sp,sp,-16
    80006482:	e406                	sd	ra,8(sp)
    80006484:	e022                	sd	s0,0(sp)
    80006486:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006488:	ffffc097          	auipc	ra,0xffffc
    8000648c:	c28080e7          	jalr	-984(ra) # 800020b0 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006490:	0085171b          	slliw	a4,a0,0x8
    80006494:	0c0027b7          	lui	a5,0xc002
    80006498:	97ba                	add	a5,a5,a4
    8000649a:	40200713          	li	a4,1026
    8000649e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800064a2:	00d5151b          	slliw	a0,a0,0xd
    800064a6:	0c2017b7          	lui	a5,0xc201
    800064aa:	953e                	add	a0,a0,a5
    800064ac:	00052023          	sw	zero,0(a0)
}
    800064b0:	60a2                	ld	ra,8(sp)
    800064b2:	6402                	ld	s0,0(sp)
    800064b4:	0141                	addi	sp,sp,16
    800064b6:	8082                	ret

00000000800064b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800064b8:	1141                	addi	sp,sp,-16
    800064ba:	e406                	sd	ra,8(sp)
    800064bc:	e022                	sd	s0,0(sp)
    800064be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064c0:	ffffc097          	auipc	ra,0xffffc
    800064c4:	bf0080e7          	jalr	-1040(ra) # 800020b0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800064c8:	00d5179b          	slliw	a5,a0,0xd
    800064cc:	0c201537          	lui	a0,0xc201
    800064d0:	953e                	add	a0,a0,a5
  return irq;
}
    800064d2:	4148                	lw	a0,4(a0)
    800064d4:	60a2                	ld	ra,8(sp)
    800064d6:	6402                	ld	s0,0(sp)
    800064d8:	0141                	addi	sp,sp,16
    800064da:	8082                	ret

00000000800064dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800064dc:	1101                	addi	sp,sp,-32
    800064de:	ec06                	sd	ra,24(sp)
    800064e0:	e822                	sd	s0,16(sp)
    800064e2:	e426                	sd	s1,8(sp)
    800064e4:	1000                	addi	s0,sp,32
    800064e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800064e8:	ffffc097          	auipc	ra,0xffffc
    800064ec:	bc8080e7          	jalr	-1080(ra) # 800020b0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800064f0:	00d5151b          	slliw	a0,a0,0xd
    800064f4:	0c2017b7          	lui	a5,0xc201
    800064f8:	97aa                	add	a5,a5,a0
    800064fa:	c3c4                	sw	s1,4(a5)
}
    800064fc:	60e2                	ld	ra,24(sp)
    800064fe:	6442                	ld	s0,16(sp)
    80006500:	64a2                	ld	s1,8(sp)
    80006502:	6105                	addi	sp,sp,32
    80006504:	8082                	ret

0000000080006506 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006506:	1141                	addi	sp,sp,-16
    80006508:	e406                	sd	ra,8(sp)
    8000650a:	e022                	sd	s0,0(sp)
    8000650c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000650e:	479d                	li	a5,7
    80006510:	04a7cc63          	blt	a5,a0,80006568 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006514:	0004b797          	auipc	a5,0x4b
    80006518:	aec78793          	addi	a5,a5,-1300 # 80051000 <disk>
    8000651c:	00a78733          	add	a4,a5,a0
    80006520:	6789                	lui	a5,0x2
    80006522:	97ba                	add	a5,a5,a4
    80006524:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006528:	eba1                	bnez	a5,80006578 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    8000652a:	00451713          	slli	a4,a0,0x4
    8000652e:	0004d797          	auipc	a5,0x4d
    80006532:	ad27b783          	ld	a5,-1326(a5) # 80053000 <disk+0x2000>
    80006536:	97ba                	add	a5,a5,a4
    80006538:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000653c:	0004b797          	auipc	a5,0x4b
    80006540:	ac478793          	addi	a5,a5,-1340 # 80051000 <disk>
    80006544:	97aa                	add	a5,a5,a0
    80006546:	6509                	lui	a0,0x2
    80006548:	953e                	add	a0,a0,a5
    8000654a:	4785                	li	a5,1
    8000654c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006550:	0004d517          	auipc	a0,0x4d
    80006554:	ac850513          	addi	a0,a0,-1336 # 80053018 <disk+0x2018>
    80006558:	ffffc097          	auipc	ra,0xffffc
    8000655c:	54c080e7          	jalr	1356(ra) # 80002aa4 <wakeup>
}
    80006560:	60a2                	ld	ra,8(sp)
    80006562:	6402                	ld	s0,0(sp)
    80006564:	0141                	addi	sp,sp,16
    80006566:	8082                	ret
    panic("virtio_disk_intr 1");
    80006568:	00002517          	auipc	a0,0x2
    8000656c:	37050513          	addi	a0,a0,880 # 800088d8 <syscalls+0x350>
    80006570:	ffffa097          	auipc	ra,0xffffa
    80006574:	074080e7          	jalr	116(ra) # 800005e4 <panic>
    panic("virtio_disk_intr 2");
    80006578:	00002517          	auipc	a0,0x2
    8000657c:	37850513          	addi	a0,a0,888 # 800088f0 <syscalls+0x368>
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	064080e7          	jalr	100(ra) # 800005e4 <panic>

0000000080006588 <virtio_disk_init>:
{
    80006588:	1101                	addi	sp,sp,-32
    8000658a:	ec06                	sd	ra,24(sp)
    8000658c:	e822                	sd	s0,16(sp)
    8000658e:	e426                	sd	s1,8(sp)
    80006590:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006592:	00002597          	auipc	a1,0x2
    80006596:	37658593          	addi	a1,a1,886 # 80008908 <syscalls+0x380>
    8000659a:	0004d517          	auipc	a0,0x4d
    8000659e:	b0e50513          	addi	a0,a0,-1266 # 800530a8 <disk+0x20a8>
    800065a2:	ffffa097          	auipc	ra,0xffffa
    800065a6:	708080e7          	jalr	1800(ra) # 80000caa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065aa:	100017b7          	lui	a5,0x10001
    800065ae:	4398                	lw	a4,0(a5)
    800065b0:	2701                	sext.w	a4,a4
    800065b2:	747277b7          	lui	a5,0x74727
    800065b6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800065ba:	0ef71163          	bne	a4,a5,8000669c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800065be:	100017b7          	lui	a5,0x10001
    800065c2:	43dc                	lw	a5,4(a5)
    800065c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065c6:	4705                	li	a4,1
    800065c8:	0ce79a63          	bne	a5,a4,8000669c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800065cc:	100017b7          	lui	a5,0x10001
    800065d0:	479c                	lw	a5,8(a5)
    800065d2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800065d4:	4709                	li	a4,2
    800065d6:	0ce79363          	bne	a5,a4,8000669c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800065da:	100017b7          	lui	a5,0x10001
    800065de:	47d8                	lw	a4,12(a5)
    800065e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800065e2:	554d47b7          	lui	a5,0x554d4
    800065e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800065ea:	0af71963          	bne	a4,a5,8000669c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800065ee:	100017b7          	lui	a5,0x10001
    800065f2:	4705                	li	a4,1
    800065f4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800065f6:	470d                	li	a4,3
    800065f8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800065fa:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800065fc:	c7ffe737          	lui	a4,0xc7ffe
    80006600:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47faa75f>
    80006604:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006606:	2701                	sext.w	a4,a4
    80006608:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000660a:	472d                	li	a4,11
    8000660c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000660e:	473d                	li	a4,15
    80006610:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006612:	6705                	lui	a4,0x1
    80006614:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006616:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000661a:	5bdc                	lw	a5,52(a5)
    8000661c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000661e:	c7d9                	beqz	a5,800066ac <virtio_disk_init+0x124>
  if(max < NUM)
    80006620:	471d                	li	a4,7
    80006622:	08f77d63          	bgeu	a4,a5,800066bc <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006626:	100014b7          	lui	s1,0x10001
    8000662a:	47a1                	li	a5,8
    8000662c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000662e:	6609                	lui	a2,0x2
    80006630:	4581                	li	a1,0
    80006632:	0004b517          	auipc	a0,0x4b
    80006636:	9ce50513          	addi	a0,a0,-1586 # 80051000 <disk>
    8000663a:	ffffa097          	auipc	ra,0xffffa
    8000663e:	7fc080e7          	jalr	2044(ra) # 80000e36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006642:	0004b717          	auipc	a4,0x4b
    80006646:	9be70713          	addi	a4,a4,-1602 # 80051000 <disk>
    8000664a:	00c75793          	srli	a5,a4,0xc
    8000664e:	2781                	sext.w	a5,a5
    80006650:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80006652:	0004d797          	auipc	a5,0x4d
    80006656:	9ae78793          	addi	a5,a5,-1618 # 80053000 <disk+0x2000>
    8000665a:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    8000665c:	0004b717          	auipc	a4,0x4b
    80006660:	a2470713          	addi	a4,a4,-1500 # 80051080 <disk+0x80>
    80006664:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006666:	0004c717          	auipc	a4,0x4c
    8000666a:	99a70713          	addi	a4,a4,-1638 # 80052000 <disk+0x1000>
    8000666e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006670:	4705                	li	a4,1
    80006672:	00e78c23          	sb	a4,24(a5)
    80006676:	00e78ca3          	sb	a4,25(a5)
    8000667a:	00e78d23          	sb	a4,26(a5)
    8000667e:	00e78da3          	sb	a4,27(a5)
    80006682:	00e78e23          	sb	a4,28(a5)
    80006686:	00e78ea3          	sb	a4,29(a5)
    8000668a:	00e78f23          	sb	a4,30(a5)
    8000668e:	00e78fa3          	sb	a4,31(a5)
}
    80006692:	60e2                	ld	ra,24(sp)
    80006694:	6442                	ld	s0,16(sp)
    80006696:	64a2                	ld	s1,8(sp)
    80006698:	6105                	addi	sp,sp,32
    8000669a:	8082                	ret
    panic("could not find virtio disk");
    8000669c:	00002517          	auipc	a0,0x2
    800066a0:	27c50513          	addi	a0,a0,636 # 80008918 <syscalls+0x390>
    800066a4:	ffffa097          	auipc	ra,0xffffa
    800066a8:	f40080e7          	jalr	-192(ra) # 800005e4 <panic>
    panic("virtio disk has no queue 0");
    800066ac:	00002517          	auipc	a0,0x2
    800066b0:	28c50513          	addi	a0,a0,652 # 80008938 <syscalls+0x3b0>
    800066b4:	ffffa097          	auipc	ra,0xffffa
    800066b8:	f30080e7          	jalr	-208(ra) # 800005e4 <panic>
    panic("virtio disk max queue too short");
    800066bc:	00002517          	auipc	a0,0x2
    800066c0:	29c50513          	addi	a0,a0,668 # 80008958 <syscalls+0x3d0>
    800066c4:	ffffa097          	auipc	ra,0xffffa
    800066c8:	f20080e7          	jalr	-224(ra) # 800005e4 <panic>

00000000800066cc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800066cc:	7175                	addi	sp,sp,-144
    800066ce:	e506                	sd	ra,136(sp)
    800066d0:	e122                	sd	s0,128(sp)
    800066d2:	fca6                	sd	s1,120(sp)
    800066d4:	f8ca                	sd	s2,112(sp)
    800066d6:	f4ce                	sd	s3,104(sp)
    800066d8:	f0d2                	sd	s4,96(sp)
    800066da:	ecd6                	sd	s5,88(sp)
    800066dc:	e8da                	sd	s6,80(sp)
    800066de:	e4de                	sd	s7,72(sp)
    800066e0:	e0e2                	sd	s8,64(sp)
    800066e2:	fc66                	sd	s9,56(sp)
    800066e4:	f86a                	sd	s10,48(sp)
    800066e6:	f46e                	sd	s11,40(sp)
    800066e8:	0900                	addi	s0,sp,144
    800066ea:	8aaa                	mv	s5,a0
    800066ec:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800066ee:	00c52c83          	lw	s9,12(a0)
    800066f2:	001c9c9b          	slliw	s9,s9,0x1
    800066f6:	1c82                	slli	s9,s9,0x20
    800066f8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800066fc:	0004d517          	auipc	a0,0x4d
    80006700:	9ac50513          	addi	a0,a0,-1620 # 800530a8 <disk+0x20a8>
    80006704:	ffffa097          	auipc	ra,0xffffa
    80006708:	636080e7          	jalr	1590(ra) # 80000d3a <acquire>
  for(int i = 0; i < 3; i++){
    8000670c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000670e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006710:	0004bc17          	auipc	s8,0x4b
    80006714:	8f0c0c13          	addi	s8,s8,-1808 # 80051000 <disk>
    80006718:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000671a:	4b0d                	li	s6,3
    8000671c:	a0ad                	j	80006786 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000671e:	00fc0733          	add	a4,s8,a5
    80006722:	975e                	add	a4,a4,s7
    80006724:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006728:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000672a:	0207c563          	bltz	a5,80006754 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000672e:	2905                	addiw	s2,s2,1
    80006730:	0611                	addi	a2,a2,4
    80006732:	19690d63          	beq	s2,s6,800068cc <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006736:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006738:	0004d717          	auipc	a4,0x4d
    8000673c:	8e070713          	addi	a4,a4,-1824 # 80053018 <disk+0x2018>
    80006740:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006742:	00074683          	lbu	a3,0(a4)
    80006746:	fee1                	bnez	a3,8000671e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006748:	2785                	addiw	a5,a5,1
    8000674a:	0705                	addi	a4,a4,1
    8000674c:	fe979be3          	bne	a5,s1,80006742 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006750:	57fd                	li	a5,-1
    80006752:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006754:	01205d63          	blez	s2,8000676e <virtio_disk_rw+0xa2>
    80006758:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000675a:	000a2503          	lw	a0,0(s4)
    8000675e:	00000097          	auipc	ra,0x0
    80006762:	da8080e7          	jalr	-600(ra) # 80006506 <free_desc>
      for(int j = 0; j < i; j++)
    80006766:	2d85                	addiw	s11,s11,1
    80006768:	0a11                	addi	s4,s4,4
    8000676a:	ffb918e3          	bne	s2,s11,8000675a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000676e:	0004d597          	auipc	a1,0x4d
    80006772:	93a58593          	addi	a1,a1,-1734 # 800530a8 <disk+0x20a8>
    80006776:	0004d517          	auipc	a0,0x4d
    8000677a:	8a250513          	addi	a0,a0,-1886 # 80053018 <disk+0x2018>
    8000677e:	ffffc097          	auipc	ra,0xffffc
    80006782:	1a6080e7          	jalr	422(ra) # 80002924 <sleep>
  for(int i = 0; i < 3; i++){
    80006786:	f8040a13          	addi	s4,s0,-128
{
    8000678a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000678c:	894e                	mv	s2,s3
    8000678e:	b765                	j	80006736 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006790:	0004d717          	auipc	a4,0x4d
    80006794:	87073703          	ld	a4,-1936(a4) # 80053000 <disk+0x2000>
    80006798:	973e                	add	a4,a4,a5
    8000679a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000679e:	0004b517          	auipc	a0,0x4b
    800067a2:	86250513          	addi	a0,a0,-1950 # 80051000 <disk>
    800067a6:	0004d717          	auipc	a4,0x4d
    800067aa:	85a70713          	addi	a4,a4,-1958 # 80053000 <disk+0x2000>
    800067ae:	6314                	ld	a3,0(a4)
    800067b0:	96be                	add	a3,a3,a5
    800067b2:	00c6d603          	lhu	a2,12(a3)
    800067b6:	00166613          	ori	a2,a2,1
    800067ba:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800067be:	f8842683          	lw	a3,-120(s0)
    800067c2:	6310                	ld	a2,0(a4)
    800067c4:	97b2                	add	a5,a5,a2
    800067c6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    800067ca:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    800067ce:	0612                	slli	a2,a2,0x4
    800067d0:	962a                	add	a2,a2,a0
    800067d2:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800067d6:	00469793          	slli	a5,a3,0x4
    800067da:	630c                	ld	a1,0(a4)
    800067dc:	95be                	add	a1,a1,a5
    800067de:	6689                	lui	a3,0x2
    800067e0:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800067e4:	96ca                	add	a3,a3,s2
    800067e6:	96aa                	add	a3,a3,a0
    800067e8:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    800067ea:	6314                	ld	a3,0(a4)
    800067ec:	96be                	add	a3,a3,a5
    800067ee:	4585                	li	a1,1
    800067f0:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800067f2:	6314                	ld	a3,0(a4)
    800067f4:	96be                	add	a3,a3,a5
    800067f6:	4509                	li	a0,2
    800067f8:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    800067fc:	6314                	ld	a3,0(a4)
    800067fe:	97b6                	add	a5,a5,a3
    80006800:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006804:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006808:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000680c:	6714                	ld	a3,8(a4)
    8000680e:	0026d783          	lhu	a5,2(a3)
    80006812:	8b9d                	andi	a5,a5,7
    80006814:	0789                	addi	a5,a5,2
    80006816:	0786                	slli	a5,a5,0x1
    80006818:	97b6                	add	a5,a5,a3
    8000681a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000681e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006822:	6718                	ld	a4,8(a4)
    80006824:	00275783          	lhu	a5,2(a4)
    80006828:	2785                	addiw	a5,a5,1
    8000682a:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000682e:	100017b7          	lui	a5,0x10001
    80006832:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006836:	004aa783          	lw	a5,4(s5)
    8000683a:	02b79163          	bne	a5,a1,8000685c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000683e:	0004d917          	auipc	s2,0x4d
    80006842:	86a90913          	addi	s2,s2,-1942 # 800530a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006846:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006848:	85ca                	mv	a1,s2
    8000684a:	8556                	mv	a0,s5
    8000684c:	ffffc097          	auipc	ra,0xffffc
    80006850:	0d8080e7          	jalr	216(ra) # 80002924 <sleep>
  while(b->disk == 1) {
    80006854:	004aa783          	lw	a5,4(s5)
    80006858:	fe9788e3          	beq	a5,s1,80006848 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000685c:	f8042483          	lw	s1,-128(s0)
    80006860:	20048793          	addi	a5,s1,512
    80006864:	00479713          	slli	a4,a5,0x4
    80006868:	0004a797          	auipc	a5,0x4a
    8000686c:	79878793          	addi	a5,a5,1944 # 80051000 <disk>
    80006870:	97ba                	add	a5,a5,a4
    80006872:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006876:	0004c917          	auipc	s2,0x4c
    8000687a:	78a90913          	addi	s2,s2,1930 # 80053000 <disk+0x2000>
    8000687e:	a019                	j	80006884 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006880:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006884:	8526                	mv	a0,s1
    80006886:	00000097          	auipc	ra,0x0
    8000688a:	c80080e7          	jalr	-896(ra) # 80006506 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000688e:	0492                	slli	s1,s1,0x4
    80006890:	00093783          	ld	a5,0(s2)
    80006894:	94be                	add	s1,s1,a5
    80006896:	00c4d783          	lhu	a5,12(s1)
    8000689a:	8b85                	andi	a5,a5,1
    8000689c:	f3f5                	bnez	a5,80006880 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000689e:	0004d517          	auipc	a0,0x4d
    800068a2:	80a50513          	addi	a0,a0,-2038 # 800530a8 <disk+0x20a8>
    800068a6:	ffffa097          	auipc	ra,0xffffa
    800068aa:	548080e7          	jalr	1352(ra) # 80000dee <release>
}
    800068ae:	60aa                	ld	ra,136(sp)
    800068b0:	640a                	ld	s0,128(sp)
    800068b2:	74e6                	ld	s1,120(sp)
    800068b4:	7946                	ld	s2,112(sp)
    800068b6:	79a6                	ld	s3,104(sp)
    800068b8:	7a06                	ld	s4,96(sp)
    800068ba:	6ae6                	ld	s5,88(sp)
    800068bc:	6b46                	ld	s6,80(sp)
    800068be:	6ba6                	ld	s7,72(sp)
    800068c0:	6c06                	ld	s8,64(sp)
    800068c2:	7ce2                	ld	s9,56(sp)
    800068c4:	7d42                	ld	s10,48(sp)
    800068c6:	7da2                	ld	s11,40(sp)
    800068c8:	6149                	addi	sp,sp,144
    800068ca:	8082                	ret
  if(write)
    800068cc:	01a037b3          	snez	a5,s10
    800068d0:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800068d4:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800068d8:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800068dc:	f8042483          	lw	s1,-128(s0)
    800068e0:	00449913          	slli	s2,s1,0x4
    800068e4:	0004c997          	auipc	s3,0x4c
    800068e8:	71c98993          	addi	s3,s3,1820 # 80053000 <disk+0x2000>
    800068ec:	0009ba03          	ld	s4,0(s3)
    800068f0:	9a4a                	add	s4,s4,s2
    800068f2:	f7040513          	addi	a0,s0,-144
    800068f6:	ffffb097          	auipc	ra,0xffffb
    800068fa:	906080e7          	jalr	-1786(ra) # 800011fc <kvmpa>
    800068fe:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006902:	0009b783          	ld	a5,0(s3)
    80006906:	97ca                	add	a5,a5,s2
    80006908:	4741                	li	a4,16
    8000690a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000690c:	0009b783          	ld	a5,0(s3)
    80006910:	97ca                	add	a5,a5,s2
    80006912:	4705                	li	a4,1
    80006914:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006918:	f8442783          	lw	a5,-124(s0)
    8000691c:	0009b703          	ld	a4,0(s3)
    80006920:	974a                	add	a4,a4,s2
    80006922:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006926:	0792                	slli	a5,a5,0x4
    80006928:	0009b703          	ld	a4,0(s3)
    8000692c:	973e                	add	a4,a4,a5
    8000692e:	058a8693          	addi	a3,s5,88
    80006932:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    80006934:	0009b703          	ld	a4,0(s3)
    80006938:	973e                	add	a4,a4,a5
    8000693a:	40000693          	li	a3,1024
    8000693e:	c714                	sw	a3,8(a4)
  if(write)
    80006940:	e40d18e3          	bnez	s10,80006790 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006944:	0004c717          	auipc	a4,0x4c
    80006948:	6bc73703          	ld	a4,1724(a4) # 80053000 <disk+0x2000>
    8000694c:	973e                	add	a4,a4,a5
    8000694e:	4689                	li	a3,2
    80006950:	00d71623          	sh	a3,12(a4)
    80006954:	b5a9                	j	8000679e <virtio_disk_rw+0xd2>

0000000080006956 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006956:	1101                	addi	sp,sp,-32
    80006958:	ec06                	sd	ra,24(sp)
    8000695a:	e822                	sd	s0,16(sp)
    8000695c:	e426                	sd	s1,8(sp)
    8000695e:	e04a                	sd	s2,0(sp)
    80006960:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006962:	0004c517          	auipc	a0,0x4c
    80006966:	74650513          	addi	a0,a0,1862 # 800530a8 <disk+0x20a8>
    8000696a:	ffffa097          	auipc	ra,0xffffa
    8000696e:	3d0080e7          	jalr	976(ra) # 80000d3a <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006972:	0004c717          	auipc	a4,0x4c
    80006976:	68e70713          	addi	a4,a4,1678 # 80053000 <disk+0x2000>
    8000697a:	02075783          	lhu	a5,32(a4)
    8000697e:	6b18                	ld	a4,16(a4)
    80006980:	00275683          	lhu	a3,2(a4)
    80006984:	8ebd                	xor	a3,a3,a5
    80006986:	8a9d                	andi	a3,a3,7
    80006988:	cab9                	beqz	a3,800069de <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000698a:	0004a917          	auipc	s2,0x4a
    8000698e:	67690913          	addi	s2,s2,1654 # 80051000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006992:	0004c497          	auipc	s1,0x4c
    80006996:	66e48493          	addi	s1,s1,1646 # 80053000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000699a:	078e                	slli	a5,a5,0x3
    8000699c:	97ba                	add	a5,a5,a4
    8000699e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800069a0:	20078713          	addi	a4,a5,512
    800069a4:	0712                	slli	a4,a4,0x4
    800069a6:	974a                	add	a4,a4,s2
    800069a8:	03074703          	lbu	a4,48(a4)
    800069ac:	ef21                	bnez	a4,80006a04 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800069ae:	20078793          	addi	a5,a5,512
    800069b2:	0792                	slli	a5,a5,0x4
    800069b4:	97ca                	add	a5,a5,s2
    800069b6:	7798                	ld	a4,40(a5)
    800069b8:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800069bc:	7788                	ld	a0,40(a5)
    800069be:	ffffc097          	auipc	ra,0xffffc
    800069c2:	0e6080e7          	jalr	230(ra) # 80002aa4 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800069c6:	0204d783          	lhu	a5,32(s1)
    800069ca:	2785                	addiw	a5,a5,1
    800069cc:	8b9d                	andi	a5,a5,7
    800069ce:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800069d2:	6898                	ld	a4,16(s1)
    800069d4:	00275683          	lhu	a3,2(a4)
    800069d8:	8a9d                	andi	a3,a3,7
    800069da:	fcf690e3          	bne	a3,a5,8000699a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800069de:	10001737          	lui	a4,0x10001
    800069e2:	533c                	lw	a5,96(a4)
    800069e4:	8b8d                	andi	a5,a5,3
    800069e6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800069e8:	0004c517          	auipc	a0,0x4c
    800069ec:	6c050513          	addi	a0,a0,1728 # 800530a8 <disk+0x20a8>
    800069f0:	ffffa097          	auipc	ra,0xffffa
    800069f4:	3fe080e7          	jalr	1022(ra) # 80000dee <release>
}
    800069f8:	60e2                	ld	ra,24(sp)
    800069fa:	6442                	ld	s0,16(sp)
    800069fc:	64a2                	ld	s1,8(sp)
    800069fe:	6902                	ld	s2,0(sp)
    80006a00:	6105                	addi	sp,sp,32
    80006a02:	8082                	ret
      panic("virtio_disk_intr status");
    80006a04:	00002517          	auipc	a0,0x2
    80006a08:	f7450513          	addi	a0,a0,-140 # 80008978 <syscalls+0x3f0>
    80006a0c:	ffffa097          	auipc	ra,0xffffa
    80006a10:	bd8080e7          	jalr	-1064(ra) # 800005e4 <panic>

0000000080006a14 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    80006a14:	1141                	addi	sp,sp,-16
    80006a16:	e406                	sd	ra,8(sp)
    80006a18:	e022                	sd	s0,0(sp)
    80006a1a:	0800                	addi	s0,sp,16
  alloc.next_page = kalloc();
    80006a1c:	ffffa097          	auipc	ra,0xffffa
    80006a20:	1e0080e7          	jalr	480(ra) # 80000bfc <kalloc>
    80006a24:	00002797          	auipc	a5,0x2
    80006a28:	60a7b623          	sd	a0,1548(a5) # 80009030 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    80006a2c:	00850793          	addi	a5,a0,8
    80006a30:	e11c                	sd	a5,0(a0)
}
    80006a32:	60a2                	ld	ra,8(sp)
    80006a34:	6402                	ld	s0,0(sp)
    80006a36:	0141                	addi	sp,sp,16
    80006a38:	8082                	ret

0000000080006a3a <mallo>:

void *mallo(u32 size) {
    80006a3a:	1101                	addi	sp,sp,-32
    80006a3c:	ec06                	sd	ra,24(sp)
    80006a3e:	e822                	sd	s0,16(sp)
    80006a40:	e426                	sd	s1,8(sp)
    80006a42:	1000                	addi	s0,sp,32
    80006a44:	84aa                	mv	s1,a0
  if (!if_init) {
    80006a46:	00002797          	auipc	a5,0x2
    80006a4a:	5e27a783          	lw	a5,1506(a5) # 80009028 <if_init>
    80006a4e:	cf9d                	beqz	a5,80006a8c <mallo+0x52>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  printf("size %d ", size);
    80006a50:	85a6                	mv	a1,s1
    80006a52:	00002517          	auipc	a0,0x2
    80006a56:	f3e50513          	addi	a0,a0,-194 # 80008990 <syscalls+0x408>
    80006a5a:	ffffa097          	auipc	ra,0xffffa
    80006a5e:	bdc080e7          	jalr	-1060(ra) # 80000636 <printf>
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    80006a62:	00002717          	auipc	a4,0x2
    80006a66:	5ce73703          	ld	a4,1486(a4) # 80009030 <alloc>
    80006a6a:	6308                	ld	a0,0(a4)
    80006a6c:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    80006a70:	6785                	lui	a5,0x1
    80006a72:	37e1                	addiw	a5,a5,-8
    80006a74:	9f95                	subw	a5,a5,a3
    80006a76:	02f4f563          	bgeu	s1,a5,80006aa0 <mallo+0x66>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    80006a7a:	1482                	slli	s1,s1,0x20
    80006a7c:	9081                	srli	s1,s1,0x20
    80006a7e:	94aa                	add	s1,s1,a0
    80006a80:	e304                	sd	s1,0(a4)
  } else {
    printf("malloc failed");
    return 0;
  }
  return res;
}
    80006a82:	60e2                	ld	ra,24(sp)
    80006a84:	6442                	ld	s0,16(sp)
    80006a86:	64a2                	ld	s1,8(sp)
    80006a88:	6105                	addi	sp,sp,32
    80006a8a:	8082                	ret
    mem_init();
    80006a8c:	00000097          	auipc	ra,0x0
    80006a90:	f88080e7          	jalr	-120(ra) # 80006a14 <mem_init>
    if_init = 1;
    80006a94:	4785                	li	a5,1
    80006a96:	00002717          	auipc	a4,0x2
    80006a9a:	58f72923          	sw	a5,1426(a4) # 80009028 <if_init>
    80006a9e:	bf4d                	j	80006a50 <mallo+0x16>
    printf("malloc failed");
    80006aa0:	00002517          	auipc	a0,0x2
    80006aa4:	f0050513          	addi	a0,a0,-256 # 800089a0 <syscalls+0x418>
    80006aa8:	ffffa097          	auipc	ra,0xffffa
    80006aac:	b8e080e7          	jalr	-1138(ra) # 80000636 <printf>
    return 0;
    80006ab0:	4501                	li	a0,0
    80006ab2:	bfc1                	j	80006a82 <mallo+0x48>

0000000080006ab4 <free>:

    80006ab4:	1141                	addi	sp,sp,-16
    80006ab6:	e422                	sd	s0,8(sp)
    80006ab8:	0800                	addi	s0,sp,16
    80006aba:	6422                	ld	s0,8(sp)
    80006abc:	0141                	addi	sp,sp,16
    80006abe:	8082                	ret
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
