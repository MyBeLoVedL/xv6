
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
    80000068:	26c78793          	addi	a5,a5,620 # 800062d0 <timervec>
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
    8000011e:	00003097          	auipc	ra,0x3
    80000122:	822080e7          	jalr	-2014(ra) # 80002940 <either_copyin>
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
    800001b6:	ae2080e7          	jalr	-1310(ra) # 80001c94 <myproc>
    800001ba:	551c                	lw	a5,40(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	384080e7          	jalr	900(ra) # 80002546 <sleep>
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
    80000202:	6ec080e7          	jalr	1772(ra) # 800028ea <either_copyout>
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
    800002e2:	6b8080e7          	jalr	1720(ra) # 80002996 <procdump>
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
    80000436:	2a0080e7          	jalr	672(ra) # 800026d2 <wakeup>
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
    80000464:	00022797          	auipc	a5,0x22
    80000468:	9d478793          	addi	a5,a5,-1580 # 80021e38 <devsw>
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
    800008fa:	ddc080e7          	jalr	-548(ra) # 800026d2 <wakeup>
    
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
    80000986:	bc4080e7          	jalr	-1084(ra) # 80002546 <sleep>
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
    80000bd8:	0a4080e7          	jalr	164(ra) # 80001c78 <mycpu>
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
    80000c0a:	072080e7          	jalr	114(ra) # 80001c78 <mycpu>
    80000c0e:	5d3c                	lw	a5,120(a0)
    80000c10:	cf89                	beqz	a5,80000c2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c12:	00001097          	auipc	ra,0x1
    80000c16:	066080e7          	jalr	102(ra) # 80001c78 <mycpu>
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
    80000c2e:	04e080e7          	jalr	78(ra) # 80001c78 <mycpu>
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
    80000c6e:	00e080e7          	jalr	14(ra) # 80001c78 <mycpu>
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
    80000c9a:	fe2080e7          	jalr	-30(ra) # 80001c78 <mycpu>
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
    80000ef0:	d7c080e7          	jalr	-644(ra) # 80001c68 <cpuid>
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
    80000f0c:	d60080e7          	jalr	-672(ra) # 80001c68 <cpuid>
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
    80000f2e:	bac080e7          	jalr	-1108(ra) # 80002ad6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f32:	00005097          	auipc	ra,0x5
    80000f36:	3de080e7          	jalr	990(ra) # 80006310 <plicinithart>
  }

  scheduler();        
    80000f3a:	00001097          	auipc	ra,0x1
    80000f3e:	40a080e7          	jalr	1034(ra) # 80002344 <scheduler>
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
    80000f8e:	312080e7          	jalr	786(ra) # 8000129c <kvminit>
    kvminithart();   // turn on paging
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	068080e7          	jalr	104(ra) # 80000ffa <kvminithart>
    procinit();      // process table
    80000f9a:	00001097          	auipc	ra,0x1
    80000f9e:	c1e080e7          	jalr	-994(ra) # 80001bb8 <procinit>
    trapinit();      // trap vectors
    80000fa2:	00002097          	auipc	ra,0x2
    80000fa6:	b0c080e7          	jalr	-1268(ra) # 80002aae <trapinit>
    trapinithart();  // install kernel trap vector
    80000faa:	00002097          	auipc	ra,0x2
    80000fae:	b2c080e7          	jalr	-1236(ra) # 80002ad6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fb2:	00005097          	auipc	ra,0x5
    80000fb6:	348080e7          	jalr	840(ra) # 800062fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	356080e7          	jalr	854(ra) # 80006310 <plicinithart>
    binit();         // buffer cache
    80000fc2:	00002097          	auipc	ra,0x2
    80000fc6:	4e6080e7          	jalr	1254(ra) # 800034a8 <binit>
    iinit();         // inode cache
    80000fca:	00003097          	auipc	ra,0x3
    80000fce:	b76080e7          	jalr	-1162(ra) # 80003b40 <iinit>
    fileinit();      // file table
    80000fd2:	00004097          	auipc	ra,0x4
    80000fd6:	b20080e7          	jalr	-1248(ra) # 80004af2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	458080e7          	jalr	1112(ra) # 80006432 <virtio_disk_init>
    userinit();      // first user process
    80000fe2:	00001097          	auipc	ra,0x1
    80000fe6:	036080e7          	jalr	54(ra) # 80002018 <userinit>
    __sync_synchronize();
    80000fea:	0ff0000f          	fence
    started = 1;
    80000fee:	4785                	li	a5,1
    80000ff0:	00008717          	auipc	a4,0x8
    80000ff4:	02f72423          	sw	a5,40(a4) # 80009018 <started>
    80000ff8:	b789                	j	80000f3a <main+0x56>

0000000080000ffa <kvminithart>:
  // proc_mapstacks(kernel_pagetable);
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
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
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
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
  if (va >= MAXVA)
    80001038:	57fd                	li	a5,-1
    8000103a:	83e9                	srli	a5,a5,0x1a
    8000103c:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    8000103e:	4b31                	li	s6,12
  if (va >= MAXVA)
    80001040:	04b7f263          	bgeu	a5,a1,80001084 <walk+0x66>
    panic("walk");
    80001044:	00007517          	auipc	a0,0x7
    80001048:	0b450513          	addi	a0,a0,180 # 800080f8 <digits+0x90>
    8000104c:	fffff097          	auipc	ra,0xfffff
    80001050:	580080e7          	jalr	1408(ra) # 800005cc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
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
  for (int level = 2; level > 0; level--) {
    8000107e:	3a5d                	addiw	s4,s4,-9
    80001080:	036a0063          	beq	s4,s6,800010a0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001084:	0149d933          	srl	s2,s3,s4
    80001088:	1ff97913          	andi	s2,s2,511
    8000108c:	090e                	slli	s2,s2,0x3
    8000108e:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
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
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800010c4:	57fd                	li	a5,-1
    800010c6:	83e9                	srli	a5,a5,0x1a
    800010c8:	00b7f463          	bgeu	a5,a1,800010d0 <walkaddr+0xc>
    return 0;
    800010cc:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010ce:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    800010d0:	1141                	addi	sp,sp,-16
    800010d2:	e406                	sd	ra,8(sp)
    800010d4:	e022                	sd	s0,0(sp)
    800010d6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010d8:	4601                	li	a2,0
    800010da:	00000097          	auipc	ra,0x0
    800010de:	f44080e7          	jalr	-188(ra) # 8000101e <walk>
  if (pte == 0)
    800010e2:	c105                	beqz	a0,80001102 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    800010e4:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800010e6:	0117f693          	andi	a3,a5,17
    800010ea:	4745                	li	a4,17
    return 0;
    800010ec:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
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
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
  uint64 a, last;
  pte_t *pte;
  if (va >= MAXVA)
    80001106:	57fd                	li	a5,-1
    80001108:	83e9                	srli	a5,a5,0x1a
    8000110a:	06b7eb63          	bltu	a5,a1,80001180 <mappages+0x7a>
             int perm) {
    8000110e:	715d                	addi	sp,sp,-80
    80001110:	e486                	sd	ra,72(sp)
    80001112:	e0a2                	sd	s0,64(sp)
    80001114:	fc26                	sd	s1,56(sp)
    80001116:	f84a                	sd	s2,48(sp)
    80001118:	f44e                	sd	s3,40(sp)
    8000111a:	f052                	sd	s4,32(sp)
    8000111c:	ec56                	sd	s5,24(sp)
    8000111e:	e85a                	sd	s6,16(sp)
    80001120:	e45e                	sd	s7,8(sp)
    80001122:	0880                	addi	s0,sp,80
    80001124:	8aaa                	mv	s5,a0
    80001126:	8b3a                	mv	s6,a4
    return -1;
  a = PGROUNDDOWN(va);
    80001128:	77fd                	lui	a5,0xfffff
    8000112a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000112e:	167d                	addi	a2,a2,-1
    80001130:	00b609b3          	add	s3,a2,a1
    80001134:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80001138:	8952                	mv	s2,s4
    8000113a:	41468a33          	sub	s4,a3,s4
    *pte = PA2PTE(pa) | perm | PTE_V;
    // if (a == va)
    //   printf("pte in map page %p\n",pte);
    if (a == last)
      break;
    a += PGSIZE;
    8000113e:	6b85                	lui	s7,0x1
    80001140:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001144:	4605                	li	a2,1
    80001146:	85ca                	mv	a1,s2
    80001148:	8556                	mv	a0,s5
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	ed4080e7          	jalr	-300(ra) # 8000101e <walk>
    80001152:	c90d                	beqz	a0,80001184 <mappages+0x7e>
    if (*pte & PTE_V)
    80001154:	611c                	ld	a5,0(a0)
    80001156:	8b85                	andi	a5,a5,1
    80001158:	ef81                	bnez	a5,80001170 <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000115a:	80b1                	srli	s1,s1,0xc
    8000115c:	04aa                	slli	s1,s1,0xa
    8000115e:	0164e4b3          	or	s1,s1,s6
    80001162:	0014e493          	ori	s1,s1,1
    80001166:	e104                	sd	s1,0(a0)
    if (a == last)
    80001168:	03390a63          	beq	s2,s3,8000119c <mappages+0x96>
    a += PGSIZE;
    8000116c:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000116e:	bfc9                	j	80001140 <mappages+0x3a>
      panic("remap");
    80001170:	00007517          	auipc	a0,0x7
    80001174:	f9050513          	addi	a0,a0,-112 # 80008100 <digits+0x98>
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	454080e7          	jalr	1108(ra) # 800005cc <panic>
    return -1;
    80001180:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001182:	8082                	ret
      return -1;
    80001184:	557d                	li	a0,-1
}
    80001186:	60a6                	ld	ra,72(sp)
    80001188:	6406                	ld	s0,64(sp)
    8000118a:	74e2                	ld	s1,56(sp)
    8000118c:	7942                	ld	s2,48(sp)
    8000118e:	79a2                	ld	s3,40(sp)
    80001190:	7a02                	ld	s4,32(sp)
    80001192:	6ae2                	ld	s5,24(sp)
    80001194:	6b42                	ld	s6,16(sp)
    80001196:	6ba2                	ld	s7,8(sp)
    80001198:	6161                	addi	sp,sp,80
    8000119a:	8082                	ret
  return 0;
    8000119c:	4501                	li	a0,0
    8000119e:	b7e5                	j	80001186 <mappages+0x80>

00000000800011a0 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800011a0:	1141                	addi	sp,sp,-16
    800011a2:	e406                	sd	ra,8(sp)
    800011a4:	e022                	sd	s0,0(sp)
    800011a6:	0800                	addi	s0,sp,16
    800011a8:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011aa:	86b2                	mv	a3,a2
    800011ac:	863e                	mv	a2,a5
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	f58080e7          	jalr	-168(ra) # 80001106 <mappages>
    800011b6:	e509                	bnez	a0,800011c0 <kvmmap+0x20>
}
    800011b8:	60a2                	ld	ra,8(sp)
    800011ba:	6402                	ld	s0,0(sp)
    800011bc:	0141                	addi	sp,sp,16
    800011be:	8082                	ret
    panic("kvmmap");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	f4850513          	addi	a0,a0,-184 # 80008108 <digits+0xa0>
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	404080e7          	jalr	1028(ra) # 800005cc <panic>

00000000800011d0 <kvmmake>:
pagetable_t kvmmake(void) {
    800011d0:	1101                	addi	sp,sp,-32
    800011d2:	ec06                	sd	ra,24(sp)
    800011d4:	e822                	sd	s0,16(sp)
    800011d6:	e426                	sd	s1,8(sp)
    800011d8:	e04a                	sd	s2,0(sp)
    800011da:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800011dc:	00000097          	auipc	ra,0x0
    800011e0:	96e080e7          	jalr	-1682(ra) # 80000b4a <kalloc>
    800011e4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011e6:	6605                	lui	a2,0x1
    800011e8:	4581                	li	a1,0
    800011ea:	00000097          	auipc	ra,0x0
    800011ee:	b4c080e7          	jalr	-1204(ra) # 80000d36 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011f2:	4719                	li	a4,6
    800011f4:	6685                	lui	a3,0x1
    800011f6:	10000637          	lui	a2,0x10000
    800011fa:	100005b7          	lui	a1,0x10000
    800011fe:	8526                	mv	a0,s1
    80001200:	00000097          	auipc	ra,0x0
    80001204:	fa0080e7          	jalr	-96(ra) # 800011a0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001208:	4719                	li	a4,6
    8000120a:	6685                	lui	a3,0x1
    8000120c:	10001637          	lui	a2,0x10001
    80001210:	100015b7          	lui	a1,0x10001
    80001214:	8526                	mv	a0,s1
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	f8a080e7          	jalr	-118(ra) # 800011a0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000121e:	4719                	li	a4,6
    80001220:	004006b7          	lui	a3,0x400
    80001224:	0c000637          	lui	a2,0xc000
    80001228:	0c0005b7          	lui	a1,0xc000
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	f72080e7          	jalr	-142(ra) # 800011a0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001236:	00007917          	auipc	s2,0x7
    8000123a:	dca90913          	addi	s2,s2,-566 # 80008000 <etext>
    8000123e:	4729                	li	a4,10
    80001240:	80007697          	auipc	a3,0x80007
    80001244:	dc068693          	addi	a3,a3,-576 # 8000 <_entry-0x7fff8000>
    80001248:	4605                	li	a2,1
    8000124a:	067e                	slli	a2,a2,0x1f
    8000124c:	85b2                	mv	a1,a2
    8000124e:	8526                	mv	a0,s1
    80001250:	00000097          	auipc	ra,0x0
    80001254:	f50080e7          	jalr	-176(ra) # 800011a0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001258:	4719                	li	a4,6
    8000125a:	46c5                	li	a3,17
    8000125c:	06ee                	slli	a3,a3,0x1b
    8000125e:	412686b3          	sub	a3,a3,s2
    80001262:	864a                	mv	a2,s2
    80001264:	85ca                	mv	a1,s2
    80001266:	8526                	mv	a0,s1
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	f38080e7          	jalr	-200(ra) # 800011a0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001270:	4729                	li	a4,10
    80001272:	6685                	lui	a3,0x1
    80001274:	00006617          	auipc	a2,0x6
    80001278:	d8c60613          	addi	a2,a2,-628 # 80007000 <_trampoline>
    8000127c:	040005b7          	lui	a1,0x4000
    80001280:	15fd                	addi	a1,a1,-1
    80001282:	05b2                	slli	a1,a1,0xc
    80001284:	8526                	mv	a0,s1
    80001286:	00000097          	auipc	ra,0x0
    8000128a:	f1a080e7          	jalr	-230(ra) # 800011a0 <kvmmap>
}
    8000128e:	8526                	mv	a0,s1
    80001290:	60e2                	ld	ra,24(sp)
    80001292:	6442                	ld	s0,16(sp)
    80001294:	64a2                	ld	s1,8(sp)
    80001296:	6902                	ld	s2,0(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <kvminit>:
void kvminit(void) {
    8000129c:	1141                	addi	sp,sp,-16
    8000129e:	e406                	sd	ra,8(sp)
    800012a0:	e022                	sd	s0,0(sp)
    800012a2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	f2c080e7          	jalr	-212(ra) # 800011d0 <kvmmake>
    800012ac:	00008797          	auipc	a5,0x8
    800012b0:	d6a7ba23          	sd	a0,-652(a5) # 80009020 <kernel_pagetable>
}
    800012b4:	60a2                	ld	ra,8(sp)
    800012b6:	6402                	ld	s0,0(sp)
    800012b8:	0141                	addi	sp,sp,16
    800012ba:	8082                	ret

00000000800012bc <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    800012bc:	715d                	addi	sp,sp,-80
    800012be:	e486                	sd	ra,72(sp)
    800012c0:	e0a2                	sd	s0,64(sp)
    800012c2:	fc26                	sd	s1,56(sp)
    800012c4:	f84a                	sd	s2,48(sp)
    800012c6:	f44e                	sd	s3,40(sp)
    800012c8:	f052                	sd	s4,32(sp)
    800012ca:	ec56                	sd	s5,24(sp)
    800012cc:	e85a                	sd	s6,16(sp)
    800012ce:	e45e                	sd	s7,8(sp)
    800012d0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800012d2:	03459793          	slli	a5,a1,0x34
    800012d6:	e795                	bnez	a5,80001302 <uvmunmap+0x46>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800012de:	0632                	slli	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0)
      continue;
    if ((*pte & PTE_V) == 0)
      continue;
    if (PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800012e6:	6a85                	lui	s5,0x1
    800012e8:	0535e263          	bltu	a1,s3,8000132c <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    800012ec:	60a6                	ld	ra,72(sp)
    800012ee:	6406                	ld	s0,64(sp)
    800012f0:	74e2                	ld	s1,56(sp)
    800012f2:	7942                	ld	s2,48(sp)
    800012f4:	79a2                	ld	s3,40(sp)
    800012f6:	7a02                	ld	s4,32(sp)
    800012f8:	6ae2                	ld	s5,24(sp)
    800012fa:	6b42                	ld	s6,16(sp)
    800012fc:	6ba2                	ld	s7,8(sp)
    800012fe:	6161                	addi	sp,sp,80
    80001300:	8082                	ret
    panic("uvmunmap: not aligned");
    80001302:	00007517          	auipc	a0,0x7
    80001306:	e0e50513          	addi	a0,a0,-498 # 80008110 <digits+0xa8>
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	2c2080e7          	jalr	706(ra) # 800005cc <panic>
      panic("uvmunmap: not a leaf");
    80001312:	00007517          	auipc	a0,0x7
    80001316:	e1650513          	addi	a0,a0,-490 # 80008128 <digits+0xc0>
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	2b2080e7          	jalr	690(ra) # 800005cc <panic>
    *pte = 0;
    80001322:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001326:	9956                	add	s2,s2,s5
    80001328:	fd3972e3          	bgeu	s2,s3,800012ec <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    8000132c:	4601                	li	a2,0
    8000132e:	85ca                	mv	a1,s2
    80001330:	8552                	mv	a0,s4
    80001332:	00000097          	auipc	ra,0x0
    80001336:	cec080e7          	jalr	-788(ra) # 8000101e <walk>
    8000133a:	84aa                	mv	s1,a0
    8000133c:	d56d                	beqz	a0,80001326 <uvmunmap+0x6a>
    if ((*pte & PTE_V) == 0)
    8000133e:	611c                	ld	a5,0(a0)
    80001340:	0017f713          	andi	a4,a5,1
    80001344:	d36d                	beqz	a4,80001326 <uvmunmap+0x6a>
    if (PTE_FLAGS(*pte) == PTE_V)
    80001346:	3ff7f713          	andi	a4,a5,1023
    8000134a:	fd7704e3          	beq	a4,s7,80001312 <uvmunmap+0x56>
    if (do_free) {
    8000134e:	fc0b0ae3          	beqz	s6,80001322 <uvmunmap+0x66>
      uint64 pa = PTE2PA(*pte);
    80001352:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001354:	00c79513          	slli	a0,a5,0xc
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	6f6080e7          	jalr	1782(ra) # 80000a4e <kfree>
    80001360:	b7c9                	j	80001322 <uvmunmap+0x66>

0000000080001362 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    80001362:	1101                	addi	sp,sp,-32
    80001364:	ec06                	sd	ra,24(sp)
    80001366:	e822                	sd	s0,16(sp)
    80001368:	e426                	sd	s1,8(sp)
    8000136a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	7de080e7          	jalr	2014(ra) # 80000b4a <kalloc>
    80001374:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001376:	c519                	beqz	a0,80001384 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	00000097          	auipc	ra,0x0
    80001380:	9ba080e7          	jalr	-1606(ra) # 80000d36 <memset>
  return pagetable;
}
    80001384:	8526                	mv	a0,s1
    80001386:	60e2                	ld	ra,24(sp)
    80001388:	6442                	ld	s0,16(sp)
    8000138a:	64a2                	ld	s1,8(sp)
    8000138c:	6105                	addi	sp,sp,32
    8000138e:	8082                	ret

0000000080001390 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz) {
    80001390:	7179                	addi	sp,sp,-48
    80001392:	f406                	sd	ra,40(sp)
    80001394:	f022                	sd	s0,32(sp)
    80001396:	ec26                	sd	s1,24(sp)
    80001398:	e84a                	sd	s2,16(sp)
    8000139a:	e44e                	sd	s3,8(sp)
    8000139c:	e052                	sd	s4,0(sp)
    8000139e:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800013a0:	6785                	lui	a5,0x1
    800013a2:	04f67863          	bgeu	a2,a5,800013f2 <uvminit+0x62>
    800013a6:	8a2a                	mv	s4,a0
    800013a8:	89ae                	mv	s3,a1
    800013aa:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	79e080e7          	jalr	1950(ra) # 80000b4a <kalloc>
    800013b4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013b6:	6605                	lui	a2,0x1
    800013b8:	4581                	li	a1,0
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	97c080e7          	jalr	-1668(ra) # 80000d36 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800013c2:	4779                	li	a4,30
    800013c4:	86ca                	mv	a3,s2
    800013c6:	6605                	lui	a2,0x1
    800013c8:	4581                	li	a1,0
    800013ca:	8552                	mv	a0,s4
    800013cc:	00000097          	auipc	ra,0x0
    800013d0:	d3a080e7          	jalr	-710(ra) # 80001106 <mappages>
  memmove(mem, src, sz);
    800013d4:	8626                	mv	a2,s1
    800013d6:	85ce                	mv	a1,s3
    800013d8:	854a                	mv	a0,s2
    800013da:	00000097          	auipc	ra,0x0
    800013de:	9b8080e7          	jalr	-1608(ra) # 80000d92 <memmove>
}
    800013e2:	70a2                	ld	ra,40(sp)
    800013e4:	7402                	ld	s0,32(sp)
    800013e6:	64e2                	ld	s1,24(sp)
    800013e8:	6942                	ld	s2,16(sp)
    800013ea:	69a2                	ld	s3,8(sp)
    800013ec:	6a02                	ld	s4,0(sp)
    800013ee:	6145                	addi	sp,sp,48
    800013f0:	8082                	ret
    panic("inituvm: more than a page");
    800013f2:	00007517          	auipc	a0,0x7
    800013f6:	d4e50513          	addi	a0,a0,-690 # 80008140 <digits+0xd8>
    800013fa:	fffff097          	auipc	ra,0xfffff
    800013fe:	1d2080e7          	jalr	466(ra) # 800005cc <panic>

0000000080001402 <uvmapping>:
  }
  return newsz;
}

// * copy mapping from va to end to another pagetable dst.
int uvmapping(pagetable_t pagetable, pagetable_t dst, u64 ori, u64 end) {
    80001402:	7139                	addi	sp,sp,-64
    80001404:	fc06                	sd	ra,56(sp)
    80001406:	f822                	sd	s0,48(sp)
    80001408:	f426                	sd	s1,40(sp)
    8000140a:	f04a                	sd	s2,32(sp)
    8000140c:	ec4e                	sd	s3,24(sp)
    8000140e:	e852                	sd	s4,16(sp)
    80001410:	e456                	sd	s5,8(sp)
    80001412:	e05a                	sd	s6,0(sp)
    80001414:	0080                	addi	s0,sp,64
  ori = PGROUNDUP(ori);
    80001416:	6905                	lui	s2,0x1
    80001418:	197d                	addi	s2,s2,-1
    8000141a:	964a                	add	a2,a2,s2
    8000141c:	797d                	lui	s2,0xfffff
    8000141e:	01267933          	and	s2,a2,s2
  for (u64 cur = ori; cur < end; cur += PGSIZE) {
    80001422:	04d97a63          	bgeu	s2,a3,80001476 <uvmapping+0x74>
    80001426:	8a2a                	mv	s4,a0
    80001428:	8b2e                	mv	s6,a1
    8000142a:	89b6                	mv	s3,a3
    8000142c:	6a85                	lui	s5,0x1
    8000142e:	a821                	j	80001446 <uvmapping+0x44>
    if ((*pte & PTE_V) == 0) {
      continue;
    }
    pte_t *d_pte = walk(dst, cur, 1);
    if (d_pte == 0) {
      panic("can't allocate an pte");
    80001430:	00007517          	auipc	a0,0x7
    80001434:	d3050513          	addi	a0,a0,-720 # 80008160 <digits+0xf8>
    80001438:	fffff097          	auipc	ra,0xfffff
    8000143c:	194080e7          	jalr	404(ra) # 800005cc <panic>
  for (u64 cur = ori; cur < end; cur += PGSIZE) {
    80001440:	9956                	add	s2,s2,s5
    80001442:	03397a63          	bgeu	s2,s3,80001476 <uvmapping+0x74>
    pte_t *pte = walk(pagetable, cur, 0);
    80001446:	4601                	li	a2,0
    80001448:	85ca                	mv	a1,s2
    8000144a:	8552                	mv	a0,s4
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	bd2080e7          	jalr	-1070(ra) # 8000101e <walk>
    80001454:	84aa                	mv	s1,a0
    if (pte == 0) {
    80001456:	d56d                	beqz	a0,80001440 <uvmapping+0x3e>
    if ((*pte & PTE_V) == 0) {
    80001458:	611c                	ld	a5,0(a0)
    8000145a:	8b85                	andi	a5,a5,1
    8000145c:	d3f5                	beqz	a5,80001440 <uvmapping+0x3e>
    pte_t *d_pte = walk(dst, cur, 1);
    8000145e:	4605                	li	a2,1
    80001460:	85ca                	mv	a1,s2
    80001462:	855a                	mv	a0,s6
    80001464:	00000097          	auipc	ra,0x0
    80001468:	bba080e7          	jalr	-1094(ra) # 8000101e <walk>
    if (d_pte == 0) {
    8000146c:	d171                	beqz	a0,80001430 <uvmapping+0x2e>
    }
    *d_pte = *pte & (~PTE_U);
    8000146e:	609c                	ld	a5,0(s1)
    80001470:	9bbd                	andi	a5,a5,-17
    80001472:	e11c                	sd	a5,0(a0)
    80001474:	b7f1                	j	80001440 <uvmapping+0x3e>
  }
  return 0;
}
    80001476:	4501                	li	a0,0
    80001478:	70e2                	ld	ra,56(sp)
    8000147a:	7442                	ld	s0,48(sp)
    8000147c:	74a2                	ld	s1,40(sp)
    8000147e:	7902                	ld	s2,32(sp)
    80001480:	69e2                	ld	s3,24(sp)
    80001482:	6a42                	ld	s4,16(sp)
    80001484:	6aa2                	ld	s5,8(sp)
    80001486:	6b02                	ld	s6,0(sp)
    80001488:	6121                	addi	sp,sp,64
    8000148a:	8082                	ret

000000008000148c <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    8000148c:	1101                	addi	sp,sp,-32
    8000148e:	ec06                	sd	ra,24(sp)
    80001490:	e822                	sd	s0,16(sp)
    80001492:	e426                	sd	s1,8(sp)
    80001494:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001496:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001498:	00b67d63          	bgeu	a2,a1,800014b2 <uvmdealloc+0x26>
    8000149c:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000149e:	6785                	lui	a5,0x1
    800014a0:	17fd                	addi	a5,a5,-1
    800014a2:	00f60733          	add	a4,a2,a5
    800014a6:	767d                	lui	a2,0xfffff
    800014a8:	8f71                	and	a4,a4,a2
    800014aa:	97ae                	add	a5,a5,a1
    800014ac:	8ff1                	and	a5,a5,a2
    800014ae:	00f76863          	bltu	a4,a5,800014be <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014b2:	8526                	mv	a0,s1
    800014b4:	60e2                	ld	ra,24(sp)
    800014b6:	6442                	ld	s0,16(sp)
    800014b8:	64a2                	ld	s1,8(sp)
    800014ba:	6105                	addi	sp,sp,32
    800014bc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014be:	8f99                	sub	a5,a5,a4
    800014c0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014c2:	4685                	li	a3,1
    800014c4:	0007861b          	sext.w	a2,a5
    800014c8:	85ba                	mv	a1,a4
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	df2080e7          	jalr	-526(ra) # 800012bc <uvmunmap>
    800014d2:	b7c5                	j	800014b2 <uvmdealloc+0x26>

00000000800014d4 <uvmalloc>:
  if (newsz < oldsz)
    800014d4:	0cb66963          	bltu	a2,a1,800015a6 <uvmalloc+0xd2>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    800014d8:	7139                	addi	sp,sp,-64
    800014da:	fc06                	sd	ra,56(sp)
    800014dc:	f822                	sd	s0,48(sp)
    800014de:	f426                	sd	s1,40(sp)
    800014e0:	f04a                	sd	s2,32(sp)
    800014e2:	ec4e                	sd	s3,24(sp)
    800014e4:	e852                	sd	s4,16(sp)
    800014e6:	e456                	sd	s5,8(sp)
    800014e8:	e05a                	sd	s6,0(sp)
    800014ea:	0080                	addi	s0,sp,64
    800014ec:	8aaa                	mv	s5,a0
    800014ee:	8b32                	mv	s6,a2
  if (newsz >= PLIC) {
    800014f0:	0c0007b7          	lui	a5,0xc000
    800014f4:	06f67163          	bgeu	a2,a5,80001556 <uvmalloc+0x82>
  oldsz = PGROUNDUP(oldsz);
    800014f8:	6985                	lui	s3,0x1
    800014fa:	19fd                	addi	s3,s3,-1
    800014fc:	95ce                	add	a1,a1,s3
    800014fe:	79fd                	lui	s3,0xfffff
    80001500:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001504:	0ac9f363          	bgeu	s3,a2,800015aa <uvmalloc+0xd6>
    80001508:	fff60a13          	addi	s4,a2,-1 # ffffffffffffefff <end+0xffffffff7ffd8fff>
    8000150c:	413a0a33          	sub	s4,s4,s3
    80001510:	77fd                	lui	a5,0xfffff
    80001512:	00fa7a33          	and	s4,s4,a5
    80001516:	6785                	lui	a5,0x1
    80001518:	97ce                	add	a5,a5,s3
    8000151a:	9a3e                	add	s4,s4,a5
    8000151c:	894e                	mv	s2,s3
    mem = kalloc();
    8000151e:	fffff097          	auipc	ra,0xfffff
    80001522:	62c080e7          	jalr	1580(ra) # 80000b4a <kalloc>
    80001526:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001528:	cd1d                	beqz	a0,80001566 <uvmalloc+0x92>
    memset(mem, 0, PGSIZE);
    8000152a:	6605                	lui	a2,0x1
    8000152c:	4581                	li	a1,0
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	808080e7          	jalr	-2040(ra) # 80000d36 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    80001536:	4779                	li	a4,30
    80001538:	86a6                	mv	a3,s1
    8000153a:	6605                	lui	a2,0x1
    8000153c:	85ca                	mv	a1,s2
    8000153e:	8556                	mv	a0,s5
    80001540:	00000097          	auipc	ra,0x0
    80001544:	bc6080e7          	jalr	-1082(ra) # 80001106 <mappages>
    80001548:	e129                	bnez	a0,8000158a <uvmalloc+0xb6>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000154a:	6785                	lui	a5,0x1
    8000154c:	993e                	add	s2,s2,a5
    8000154e:	fd4918e3          	bne	s2,s4,8000151e <uvmalloc+0x4a>
  return newsz;
    80001552:	855a                	mv	a0,s6
    80001554:	a00d                	j	80001576 <uvmalloc+0xa2>
    panic("user memory overloaded!");
    80001556:	00007517          	auipc	a0,0x7
    8000155a:	c2250513          	addi	a0,a0,-990 # 80008178 <digits+0x110>
    8000155e:	fffff097          	auipc	ra,0xfffff
    80001562:	06e080e7          	jalr	110(ra) # 800005cc <panic>
      uvmdealloc(pagetable, a, oldsz);
    80001566:	864e                	mv	a2,s3
    80001568:	85ca                	mv	a1,s2
    8000156a:	8556                	mv	a0,s5
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	f20080e7          	jalr	-224(ra) # 8000148c <uvmdealloc>
      return 0;
    80001574:	4501                	li	a0,0
}
    80001576:	70e2                	ld	ra,56(sp)
    80001578:	7442                	ld	s0,48(sp)
    8000157a:	74a2                	ld	s1,40(sp)
    8000157c:	7902                	ld	s2,32(sp)
    8000157e:	69e2                	ld	s3,24(sp)
    80001580:	6a42                	ld	s4,16(sp)
    80001582:	6aa2                	ld	s5,8(sp)
    80001584:	6b02                	ld	s6,0(sp)
    80001586:	6121                	addi	sp,sp,64
    80001588:	8082                	ret
      kfree(mem);
    8000158a:	8526                	mv	a0,s1
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	4c2080e7          	jalr	1218(ra) # 80000a4e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001594:	864e                	mv	a2,s3
    80001596:	85ca                	mv	a1,s2
    80001598:	8556                	mv	a0,s5
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	ef2080e7          	jalr	-270(ra) # 8000148c <uvmdealloc>
      return 0;
    800015a2:	4501                	li	a0,0
    800015a4:	bfc9                	j	80001576 <uvmalloc+0xa2>
    return oldsz;
    800015a6:	852e                	mv	a0,a1
}
    800015a8:	8082                	ret
  return newsz;
    800015aa:	8532                	mv	a0,a2
    800015ac:	b7e9                	j	80001576 <uvmalloc+0xa2>

00000000800015ae <do_lazy_allocation>:

int do_lazy_allocation(u64 addr) {
    800015ae:	1101                	addi	sp,sp,-32
    800015b0:	ec06                	sd	ra,24(sp)
    800015b2:	e822                	sd	s0,16(sp)
    800015b4:	e426                	sd	s1,8(sp)
    800015b6:	e04a                	sd	s2,0(sp)
    800015b8:	1000                	addi	s0,sp,32
  u64 va, pa;
  va = PGROUNDDOWN(addr);
    800015ba:	797d                	lui	s2,0xfffff
    800015bc:	01257933          	and	s2,a0,s2
  if ((pa = (u64)kalloc()) == 0) {
    800015c0:	fffff097          	auipc	ra,0xfffff
    800015c4:	58a080e7          	jalr	1418(ra) # 80000b4a <kalloc>
    800015c8:	c13d                	beqz	a0,8000162e <do_lazy_allocation+0x80>
    800015ca:	84aa                	mv	s1,a0
    return -1;
  }
  memset((void *)pa, 0, PGSIZE);
    800015cc:	6605                	lui	a2,0x1
    800015ce:	4581                	li	a1,0
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	766080e7          	jalr	1894(ra) # 80000d36 <memset>
  if (mappages(myproc()->pagetable, va, PGSIZE, pa,
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	6bc080e7          	jalr	1724(ra) # 80001c94 <myproc>
    800015e0:	4779                	li	a4,30
    800015e2:	86a6                	mv	a3,s1
    800015e4:	6605                	lui	a2,0x1
    800015e6:	85ca                	mv	a1,s2
    800015e8:	6d28                	ld	a0,88(a0)
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	b1c080e7          	jalr	-1252(ra) # 80001106 <mappages>
    800015f2:	e50d                	bnez	a0,8000161c <do_lazy_allocation+0x6e>
               PTE_R | PTE_W | PTE_X | PTE_U) != 0) {
    kfree((void *)pa);
    return -2;
  }
  struct proc *p = myproc();
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	6a0080e7          	jalr	1696(ra) # 80001c94 <myproc>
  if (uvmapping(p->pagetable, p->k_pagetable, va, va + PGSIZE) != 0) {
    800015fc:	6685                	lui	a3,0x1
    800015fe:	96ca                	add	a3,a3,s2
    80001600:	864a                	mv	a2,s2
    80001602:	712c                	ld	a1,96(a0)
    80001604:	6d28                	ld	a0,88(a0)
    80001606:	00000097          	auipc	ra,0x0
    8000160a:	dfc080e7          	jalr	-516(ra) # 80001402 <uvmapping>
    8000160e:	ed11                	bnez	a0,8000162a <do_lazy_allocation+0x7c>
    return -2;
  }
  return 0;
}
    80001610:	60e2                	ld	ra,24(sp)
    80001612:	6442                	ld	s0,16(sp)
    80001614:	64a2                	ld	s1,8(sp)
    80001616:	6902                	ld	s2,0(sp)
    80001618:	6105                	addi	sp,sp,32
    8000161a:	8082                	ret
    kfree((void *)pa);
    8000161c:	8526                	mv	a0,s1
    8000161e:	fffff097          	auipc	ra,0xfffff
    80001622:	430080e7          	jalr	1072(ra) # 80000a4e <kfree>
    return -2;
    80001626:	5579                	li	a0,-2
    80001628:	b7e5                	j	80001610 <do_lazy_allocation+0x62>
    return -2;
    8000162a:	5579                	li	a0,-2
    8000162c:	b7d5                	j	80001610 <do_lazy_allocation+0x62>
    return -1;
    8000162e:	557d                	li	a0,-1
    80001630:	b7c5                	j	80001610 <do_lazy_allocation+0x62>

0000000080001632 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    80001632:	7179                	addi	sp,sp,-48
    80001634:	f406                	sd	ra,40(sp)
    80001636:	f022                	sd	s0,32(sp)
    80001638:	ec26                	sd	s1,24(sp)
    8000163a:	e84a                	sd	s2,16(sp)
    8000163c:	e44e                	sd	s3,8(sp)
    8000163e:	e052                	sd	s4,0(sp)
    80001640:	1800                	addi	s0,sp,48
    80001642:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001644:	84aa                	mv	s1,a0
    80001646:	6905                	lui	s2,0x1
    80001648:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000164a:	4985                	li	s3,1
    8000164c:	a021                	j	80001654 <freewalk+0x22>
  for (int i = 0; i < 512; i++) {
    8000164e:	04a1                	addi	s1,s1,8
    80001650:	03248063          	beq	s1,s2,80001670 <freewalk+0x3e>
    pte_t pte = pagetable[i];
    80001654:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001656:	00f57793          	andi	a5,a0,15
    8000165a:	ff379ae3          	bne	a5,s3,8000164e <freewalk+0x1c>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000165e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001660:	0532                	slli	a0,a0,0xc
    80001662:	00000097          	auipc	ra,0x0
    80001666:	fd0080e7          	jalr	-48(ra) # 80001632 <freewalk>
      pagetable[i] = 0;
    8000166a:	0004b023          	sd	zero,0(s1)
    8000166e:	b7c5                	j	8000164e <freewalk+0x1c>
    } else if (pte & PTE_V) {
      continue;
    }
  }
  kfree((void *)pagetable);
    80001670:	8552                	mv	a0,s4
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	3dc080e7          	jalr	988(ra) # 80000a4e <kfree>
}
    8000167a:	70a2                	ld	ra,40(sp)
    8000167c:	7402                	ld	s0,32(sp)
    8000167e:	64e2                	ld	s1,24(sp)
    80001680:	6942                	ld	s2,16(sp)
    80001682:	69a2                	ld	s3,8(sp)
    80001684:	6a02                	ld	s4,0(sp)
    80001686:	6145                	addi	sp,sp,48
    80001688:	8082                	ret

000000008000168a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    8000168a:	1101                	addi	sp,sp,-32
    8000168c:	ec06                	sd	ra,24(sp)
    8000168e:	e822                	sd	s0,16(sp)
    80001690:	e426                	sd	s1,8(sp)
    80001692:	1000                	addi	s0,sp,32
    80001694:	84aa                	mv	s1,a0
  if (sz > 0)
    80001696:	e999                	bnez	a1,800016ac <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80001698:	8526                	mv	a0,s1
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	f98080e7          	jalr	-104(ra) # 80001632 <freewalk>
}
    800016a2:	60e2                	ld	ra,24(sp)
    800016a4:	6442                	ld	s0,16(sp)
    800016a6:	64a2                	ld	s1,8(sp)
    800016a8:	6105                	addi	sp,sp,32
    800016aa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800016ac:	6605                	lui	a2,0x1
    800016ae:	167d                	addi	a2,a2,-1
    800016b0:	962e                	add	a2,a2,a1
    800016b2:	4685                	li	a3,1
    800016b4:	8231                	srli	a2,a2,0xc
    800016b6:	4581                	li	a1,0
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	c04080e7          	jalr	-1020(ra) # 800012bc <uvmunmap>
    800016c0:	bfe1                	j	80001698 <uvmfree+0xe>

00000000800016c2 <free_kmapping>:

void free_kmapping(struct proc *p) {
    800016c2:	7179                	addi	sp,sp,-48
    800016c4:	f406                	sd	ra,40(sp)
    800016c6:	f022                	sd	s0,32(sp)
    800016c8:	ec26                	sd	s1,24(sp)
    800016ca:	e84a                	sd	s2,16(sp)
    800016cc:	e44e                	sd	s3,8(sp)
    800016ce:	1800                	addi	s0,sp,48
    800016d0:	892a                	mv	s2,a0

  pagetable_t k_pagetable = p->k_pagetable;
    800016d2:	7124                	ld	s1,96(a0)
  uvmunmap(k_pagetable, UART0, 1, 0);
    800016d4:	4681                	li	a3,0
    800016d6:	4605                	li	a2,1
    800016d8:	100005b7          	lui	a1,0x10000
    800016dc:	8526                	mv	a0,s1
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	bde080e7          	jalr	-1058(ra) # 800012bc <uvmunmap>
  uvmunmap(k_pagetable, VIRTIO0, 1, 0);
    800016e6:	4681                	li	a3,0
    800016e8:	4605                	li	a2,1
    800016ea:	100015b7          	lui	a1,0x10001
    800016ee:	8526                	mv	a0,s1
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	bcc080e7          	jalr	-1076(ra) # 800012bc <uvmunmap>
  uvmunmap(k_pagetable, PLIC, (0x400000) / PGSIZE, 0);
    800016f8:	4681                	li	a3,0
    800016fa:	40000613          	li	a2,1024
    800016fe:	0c0005b7          	lui	a1,0xc000
    80001702:	8526                	mv	a0,s1
    80001704:	00000097          	auipc	ra,0x0
    80001708:	bb8080e7          	jalr	-1096(ra) # 800012bc <uvmunmap>
  uvmunmap(k_pagetable, KERNBASE, ((uint64)etext - KERNBASE) / PGSIZE, 0);
    8000170c:	00007997          	auipc	s3,0x7
    80001710:	8f498993          	addi	s3,s3,-1804 # 80008000 <etext>
    80001714:	4681                	li	a3,0
    80001716:	80007617          	auipc	a2,0x80007
    8000171a:	8ea60613          	addi	a2,a2,-1814 # 8000 <_entry-0x7fff8000>
    8000171e:	8231                	srli	a2,a2,0xc
    80001720:	4585                	li	a1,1
    80001722:	05fe                	slli	a1,a1,0x1f
    80001724:	8526                	mv	a0,s1
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	b96080e7          	jalr	-1130(ra) # 800012bc <uvmunmap>
  uvmunmap(k_pagetable, (u64)etext, (PHYSTOP - (u64)etext) / PGSIZE, 0);
    8000172e:	4645                	li	a2,17
    80001730:	066e                	slli	a2,a2,0x1b
    80001732:	41360633          	sub	a2,a2,s3
    80001736:	4681                	li	a3,0
    80001738:	8231                	srli	a2,a2,0xc
    8000173a:	85ce                	mv	a1,s3
    8000173c:	8526                	mv	a0,s1
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	b7e080e7          	jalr	-1154(ra) # 800012bc <uvmunmap>
  uvmunmap(k_pagetable, TRAMPOLINE, 1, 0);
    80001746:	4681                	li	a3,0
    80001748:	4605                	li	a2,1
    8000174a:	040005b7          	lui	a1,0x4000
    8000174e:	15fd                	addi	a1,a1,-1
    80001750:	05b2                	slli	a1,a1,0xc
    80001752:	8526                	mv	a0,s1
    80001754:	00000097          	auipc	ra,0x0
    80001758:	b68080e7          	jalr	-1176(ra) # 800012bc <uvmunmap>

  //  * free physical page for kernel stack
  pte_t *pte = walk(p->k_pagetable, p->kstack, 0);
    8000175c:	4601                	li	a2,0
    8000175e:	04893583          	ld	a1,72(s2) # 1048 <_entry-0x7fffefb8>
    80001762:	06093503          	ld	a0,96(s2)
    80001766:	00000097          	auipc	ra,0x0
    8000176a:	8b8080e7          	jalr	-1864(ra) # 8000101e <walk>
  void *s = (void *)PTE2PA(*pte);
    8000176e:	6108                	ld	a0,0(a0)
    80001770:	8129                	srli	a0,a0,0xa
  kfree(s);
    80001772:	0532                	slli	a0,a0,0xc
    80001774:	fffff097          	auipc	ra,0xfffff
    80001778:	2da080e7          	jalr	730(ra) # 80000a4e <kfree>
  uvmunmap(k_pagetable, p->kstack, 1, 0);
    8000177c:	4681                	li	a3,0
    8000177e:	4605                	li	a2,1
    80001780:	04893583          	ld	a1,72(s2)
    80001784:	8526                	mv	a0,s1
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	b36080e7          	jalr	-1226(ra) # 800012bc <uvmunmap>
}
    8000178e:	70a2                	ld	ra,40(sp)
    80001790:	7402                	ld	s0,32(sp)
    80001792:	64e2                	ld	s1,24(sp)
    80001794:	6942                	ld	s2,16(sp)
    80001796:	69a2                	ld	s3,8(sp)
    80001798:	6145                	addi	sp,sp,48
    8000179a:	8082                	ret

000000008000179c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    8000179c:	ca4d                	beqz	a2,8000184e <uvmcopy+0xb2>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    8000179e:	715d                	addi	sp,sp,-80
    800017a0:	e486                	sd	ra,72(sp)
    800017a2:	e0a2                	sd	s0,64(sp)
    800017a4:	fc26                	sd	s1,56(sp)
    800017a6:	f84a                	sd	s2,48(sp)
    800017a8:	f44e                	sd	s3,40(sp)
    800017aa:	f052                	sd	s4,32(sp)
    800017ac:	ec56                	sd	s5,24(sp)
    800017ae:	e85a                	sd	s6,16(sp)
    800017b0:	e45e                	sd	s7,8(sp)
    800017b2:	0880                	addi	s0,sp,80
    800017b4:	8aaa                	mv	s5,a0
    800017b6:	8b2e                	mv	s6,a1
    800017b8:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800017ba:	4481                	li	s1,0
    800017bc:	a029                	j	800017c6 <uvmcopy+0x2a>
    800017be:	6785                	lui	a5,0x1
    800017c0:	94be                	add	s1,s1,a5
    800017c2:	0744fa63          	bgeu	s1,s4,80001836 <uvmcopy+0x9a>
    if ((pte = walk(old, i, 0)) == 0)
    800017c6:	4601                	li	a2,0
    800017c8:	85a6                	mv	a1,s1
    800017ca:	8556                	mv	a0,s5
    800017cc:	00000097          	auipc	ra,0x0
    800017d0:	852080e7          	jalr	-1966(ra) # 8000101e <walk>
    800017d4:	d56d                	beqz	a0,800017be <uvmcopy+0x22>
      continue;
    if ((*pte & PTE_V) == 0)
    800017d6:	6118                	ld	a4,0(a0)
    800017d8:	00177793          	andi	a5,a4,1
    800017dc:	d3ed                	beqz	a5,800017be <uvmcopy+0x22>
      continue;
    pa = PTE2PA(*pte);
    800017de:	00a75593          	srli	a1,a4,0xa
    800017e2:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800017e6:	3ff77913          	andi	s2,a4,1023
    if ((mem = kalloc()) == 0)
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	360080e7          	jalr	864(ra) # 80000b4a <kalloc>
    800017f2:	89aa                	mv	s3,a0
    800017f4:	c515                	beqz	a0,80001820 <uvmcopy+0x84>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    800017f6:	6605                	lui	a2,0x1
    800017f8:	85de                	mv	a1,s7
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	598080e7          	jalr	1432(ra) # 80000d92 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001802:	874a                	mv	a4,s2
    80001804:	86ce                	mv	a3,s3
    80001806:	6605                	lui	a2,0x1
    80001808:	85a6                	mv	a1,s1
    8000180a:	855a                	mv	a0,s6
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	8fa080e7          	jalr	-1798(ra) # 80001106 <mappages>
    80001814:	d54d                	beqz	a0,800017be <uvmcopy+0x22>
      kfree(mem);
    80001816:	854e                	mv	a0,s3
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	236080e7          	jalr	566(ra) # 80000a4e <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001820:	4685                	li	a3,1
    80001822:	00c4d613          	srli	a2,s1,0xc
    80001826:	4581                	li	a1,0
    80001828:	855a                	mv	a0,s6
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	a92080e7          	jalr	-1390(ra) # 800012bc <uvmunmap>
  return -1;
    80001832:	557d                	li	a0,-1
    80001834:	a011                	j	80001838 <uvmcopy+0x9c>
  return 0;
    80001836:	4501                	li	a0,0
}
    80001838:	60a6                	ld	ra,72(sp)
    8000183a:	6406                	ld	s0,64(sp)
    8000183c:	74e2                	ld	s1,56(sp)
    8000183e:	7942                	ld	s2,48(sp)
    80001840:	79a2                	ld	s3,40(sp)
    80001842:	7a02                	ld	s4,32(sp)
    80001844:	6ae2                	ld	s5,24(sp)
    80001846:	6b42                	ld	s6,16(sp)
    80001848:	6ba2                	ld	s7,8(sp)
    8000184a:	6161                	addi	sp,sp,80
    8000184c:	8082                	ret
  return 0;
    8000184e:	4501                	li	a0,0
}
    80001850:	8082                	ret

0000000080001852 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80001852:	1141                	addi	sp,sp,-16
    80001854:	e406                	sd	ra,8(sp)
    80001856:	e022                	sd	s0,0(sp)
    80001858:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    8000185a:	4601                	li	a2,0
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	7c2080e7          	jalr	1986(ra) # 8000101e <walk>
  if (pte == 0)
    80001864:	c901                	beqz	a0,80001874 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001866:	611c                	ld	a5,0(a0)
    80001868:	9bbd                	andi	a5,a5,-17
    8000186a:	e11c                	sd	a5,0(a0)
}
    8000186c:	60a2                	ld	ra,8(sp)
    8000186e:	6402                	ld	s0,0(sp)
    80001870:	0141                	addi	sp,sp,16
    80001872:	8082                	ret
    panic("uvmclear");
    80001874:	00007517          	auipc	a0,0x7
    80001878:	91c50513          	addi	a0,a0,-1764 # 80008190 <digits+0x128>
    8000187c:	fffff097          	auipc	ra,0xfffff
    80001880:	d50080e7          	jalr	-688(ra) # 800005cc <panic>

0000000080001884 <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80001884:	c6bd                	beqz	a3,800018f2 <copyout+0x6e>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80001886:	715d                	addi	sp,sp,-80
    80001888:	e486                	sd	ra,72(sp)
    8000188a:	e0a2                	sd	s0,64(sp)
    8000188c:	fc26                	sd	s1,56(sp)
    8000188e:	f84a                	sd	s2,48(sp)
    80001890:	f44e                	sd	s3,40(sp)
    80001892:	f052                	sd	s4,32(sp)
    80001894:	ec56                	sd	s5,24(sp)
    80001896:	e85a                	sd	s6,16(sp)
    80001898:	e45e                	sd	s7,8(sp)
    8000189a:	e062                	sd	s8,0(sp)
    8000189c:	0880                	addi	s0,sp,80
    8000189e:	8b2a                	mv	s6,a0
    800018a0:	8c2e                	mv	s8,a1
    800018a2:	8a32                	mv	s4,a2
    800018a4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800018a6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800018a8:	6a85                	lui	s5,0x1
    800018aa:	a015                	j	800018ce <copyout+0x4a>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018ac:	9562                	add	a0,a0,s8
    800018ae:	0004861b          	sext.w	a2,s1
    800018b2:	85d2                	mv	a1,s4
    800018b4:	41250533          	sub	a0,a0,s2
    800018b8:	fffff097          	auipc	ra,0xfffff
    800018bc:	4da080e7          	jalr	1242(ra) # 80000d92 <memmove>

    len -= n;
    800018c0:	409989b3          	sub	s3,s3,s1
    src += n;
    800018c4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800018c6:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    800018ca:	02098263          	beqz	s3,800018ee <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800018ce:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018d2:	85ca                	mv	a1,s2
    800018d4:	855a                	mv	a0,s6
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	7ee080e7          	jalr	2030(ra) # 800010c4 <walkaddr>
    if (pa0 == 0)
    800018de:	cd01                	beqz	a0,800018f6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800018e0:	418904b3          	sub	s1,s2,s8
    800018e4:	94d6                	add	s1,s1,s5
    if (n > len)
    800018e6:	fc99f3e3          	bgeu	s3,s1,800018ac <copyout+0x28>
    800018ea:	84ce                	mv	s1,s3
    800018ec:	b7c1                	j	800018ac <copyout+0x28>
  }
  return 0;
    800018ee:	4501                	li	a0,0
    800018f0:	a021                	j	800018f8 <copyout+0x74>
    800018f2:	4501                	li	a0,0
}
    800018f4:	8082                	ret
      return -1;
    800018f6:	557d                	li	a0,-1
}
    800018f8:	60a6                	ld	ra,72(sp)
    800018fa:	6406                	ld	s0,64(sp)
    800018fc:	74e2                	ld	s1,56(sp)
    800018fe:	7942                	ld	s2,48(sp)
    80001900:	79a2                	ld	s3,40(sp)
    80001902:	7a02                	ld	s4,32(sp)
    80001904:	6ae2                	ld	s5,24(sp)
    80001906:	6b42                	ld	s6,16(sp)
    80001908:	6ba2                	ld	s7,8(sp)
    8000190a:	6c02                	ld	s8,0(sp)
    8000190c:	6161                	addi	sp,sp,80
    8000190e:	8082                	ret

0000000080001910 <copyin_new>:

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.

int copyin_new(char *dst, uint64 srcva, uint64 len) {
    80001910:	7139                	addi	sp,sp,-64
    80001912:	fc06                	sd	ra,56(sp)
    80001914:	f822                	sd	s0,48(sp)
    80001916:	f426                	sd	s1,40(sp)
    80001918:	f04a                	sd	s2,32(sp)
    8000191a:	ec4e                	sd	s3,24(sp)
    8000191c:	e852                	sd	s4,16(sp)
    8000191e:	e456                	sd	s5,8(sp)
    80001920:	e05a                	sd	s6,0(sp)
    80001922:	0080                	addi	s0,sp,64
  uint64 n, va0, pa0;
  if (srcva > PLIC) {
    80001924:	0c0007b7          	lui	a5,0xc000
    80001928:	02b7e263          	bltu	a5,a1,8000194c <copyin_new+0x3c>
    8000192c:	89aa                	mv	s3,a0
    8000192e:	8932                	mv	s2,a2
  // if (*pte1 != *pte2){
  //   printf("pte1 = %p , pte2 = %p\n",PTE2PA(*pte1),PTE2PA(*pte2));
  // }

  while (len > 0) {
    va0 = PGROUNDDOWN(srcva);
    80001930:	7b7d                	lui	s6,0xfffff
    n = PGSIZE - (srcva - va0);
    80001932:	6a85                	lui	s5,0x1
  while (len > 0) {
    80001934:	e231                	bnez	a2,80001978 <copyin_new+0x68>
    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}
    80001936:	4501                	li	a0,0
    80001938:	70e2                	ld	ra,56(sp)
    8000193a:	7442                	ld	s0,48(sp)
    8000193c:	74a2                	ld	s1,40(sp)
    8000193e:	7902                	ld	s2,32(sp)
    80001940:	69e2                	ld	s3,24(sp)
    80001942:	6a42                	ld	s4,16(sp)
    80001944:	6aa2                	ld	s5,8(sp)
    80001946:	6b02                	ld	s6,0(sp)
    80001948:	6121                	addi	sp,sp,64
    8000194a:	8082                	ret
    panic("invalid user pointer");
    8000194c:	00007517          	auipc	a0,0x7
    80001950:	85450513          	addi	a0,a0,-1964 # 800081a0 <digits+0x138>
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	c78080e7          	jalr	-904(ra) # 800005cc <panic>
    memmove(dst, (void *)srcva, n);
    8000195c:	0004861b          	sext.w	a2,s1
    80001960:	854e                	mv	a0,s3
    80001962:	fffff097          	auipc	ra,0xfffff
    80001966:	430080e7          	jalr	1072(ra) # 80000d92 <memmove>
    len -= n;
    8000196a:	40990933          	sub	s2,s2,s1
    dst += n;
    8000196e:	99a6                	add	s3,s3,s1
    srcva = va0 + PGSIZE;
    80001970:	015a05b3          	add	a1,s4,s5
  while (len > 0) {
    80001974:	fc0901e3          	beqz	s2,80001936 <copyin_new+0x26>
    va0 = PGROUNDDOWN(srcva);
    80001978:	0165fa33          	and	s4,a1,s6
    n = PGSIZE - (srcva - va0);
    8000197c:	40ba04b3          	sub	s1,s4,a1
    80001980:	94d6                	add	s1,s1,s5
    if (n > len)
    80001982:	fc997de3          	bgeu	s2,s1,8000195c <copyin_new+0x4c>
    80001986:	84ca                	mv	s1,s2
    80001988:	bfd1                	j	8000195c <copyin_new+0x4c>

000000008000198a <copyin>:

int copyin(pagetable_t p, char *dst, uint64 srcva, uint64 len) {
    8000198a:	1141                	addi	sp,sp,-16
    8000198c:	e406                	sd	ra,8(sp)
    8000198e:	e022                	sd	s0,0(sp)
    80001990:	0800                	addi	s0,sp,16
    80001992:	852e                	mv	a0,a1
    80001994:	85b2                	mv	a1,a2
  return copyin_new(dst, srcva, len);
    80001996:	8636                	mv	a2,a3
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	f78080e7          	jalr	-136(ra) # 80001910 <copyin_new>
}
    800019a0:	60a2                	ld	ra,8(sp)
    800019a2:	6402                	ld	s0,0(sp)
    800019a4:	0141                	addi	sp,sp,16
    800019a6:	8082                	ret

00000000800019a8 <copyinstr_new>:

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr_new(char *dst, uint64 srcva, uint64 max) {
    800019a8:	1141                	addi	sp,sp,-16
    800019aa:	e422                	sd	s0,8(sp)
    800019ac:	0800                	addi	s0,sp,16
  uint64 n, va0, pa0;
  int got_null = 0;

  pa0 = srcva;
  while (got_null == 0 && max > 0) {
    800019ae:	c23d                	beqz	a2,80001a14 <copyinstr_new+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800019b0:	78fd                	lui	a7,0xfffff
    800019b2:	0115f8b3          	and	a7,a1,a7
    // pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
    800019b6:	c1ad                	beqz	a1,80001a18 <copyinstr_new+0x70>
    800019b8:	6785                	lui	a5,0x1
    800019ba:	98be                	add	a7,a7,a5
    800019bc:	86ae                	mv	a3,a1
    800019be:	6305                	lui	t1,0x1
    800019c0:	a831                	j	800019dc <copyinstr_new+0x34>
      n = max;

    char *p = (char *)pa0;
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    800019c2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800019c6:	4785                	li	a5,1
      dst++;
    }
    pa0 += n;
    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    800019c8:	0017b793          	seqz	a5,a5
    800019cc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800019d0:	6422                	ld	s0,8(sp)
    800019d2:	0141                	addi	sp,sp,16
    800019d4:	8082                	ret
  while (got_null == 0 && max > 0) {
    800019d6:	ce0d                	beqz	a2,80001a10 <copyinstr_new+0x68>
    srcva = va0 + PGSIZE;
    800019d8:	86c6                	mv	a3,a7
    if (pa0 == 0)
    800019da:	989a                	add	a7,a7,t1
    n = PGSIZE - (srcva - va0);
    800019dc:	40d886b3          	sub	a3,a7,a3
    if (n > max)
    800019e0:	00d67363          	bgeu	a2,a3,800019e6 <copyinstr_new+0x3e>
    800019e4:	86b2                	mv	a3,a2
    while (n > 0) {
    800019e6:	dae5                	beqz	a3,800019d6 <copyinstr_new+0x2e>
    800019e8:	96aa                	add	a3,a3,a0
    800019ea:	87aa                	mv	a5,a0
      if (*p == '\0') {
    800019ec:	40a58833          	sub	a6,a1,a0
    800019f0:	167d                	addi	a2,a2,-1
    800019f2:	9532                	add	a0,a0,a2
    800019f4:	00f80733          	add	a4,a6,a5
    800019f8:	00074703          	lbu	a4,0(a4)
    800019fc:	d379                	beqz	a4,800019c2 <copyinstr_new+0x1a>
        *dst = *p;
    800019fe:	00e78023          	sb	a4,0(a5)
      --max;
    80001a02:	40f50633          	sub	a2,a0,a5
      dst++;
    80001a06:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001a08:	fef696e3          	bne	a3,a5,800019f4 <copyinstr_new+0x4c>
      dst++;
    80001a0c:	8536                	mv	a0,a3
    80001a0e:	b7e1                	j	800019d6 <copyinstr_new+0x2e>
    80001a10:	4781                	li	a5,0
    80001a12:	bf5d                	j	800019c8 <copyinstr_new+0x20>
  int got_null = 0;
    80001a14:	4781                	li	a5,0
    80001a16:	bf4d                	j	800019c8 <copyinstr_new+0x20>
      return -1;
    80001a18:	557d                	li	a0,-1
    80001a1a:	bf5d                	j	800019d0 <copyinstr_new+0x28>

0000000080001a1c <copyinstr>:

int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80001a1c:	1141                	addi	sp,sp,-16
    80001a1e:	e406                	sd	ra,8(sp)
    80001a20:	e022                	sd	s0,0(sp)
    80001a22:	0800                	addi	s0,sp,16
    80001a24:	852e                	mv	a0,a1
    80001a26:	85b2                	mv	a1,a2
  return copyinstr_new(dst, srcva, max);
    80001a28:	8636                	mv	a2,a3
    80001a2a:	00000097          	auipc	ra,0x0
    80001a2e:	f7e080e7          	jalr	-130(ra) # 800019a8 <copyinstr_new>
}
    80001a32:	60a2                	ld	ra,8(sp)
    80001a34:	6402                	ld	s0,0(sp)
    80001a36:	0141                	addi	sp,sp,16
    80001a38:	8082                	ret

0000000080001a3a <vm_p_helper>:

void vm_p_helper(pagetable_t pgt, int level) {
  if (level < 0)
    80001a3a:	0a05c963          	bltz	a1,80001aec <vm_p_helper+0xb2>
void vm_p_helper(pagetable_t pgt, int level) {
    80001a3e:	7139                	addi	sp,sp,-64
    80001a40:	fc06                	sd	ra,56(sp)
    80001a42:	f822                	sd	s0,48(sp)
    80001a44:	f426                	sd	s1,40(sp)
    80001a46:	f04a                	sd	s2,32(sp)
    80001a48:	ec4e                	sd	s3,24(sp)
    80001a4a:	e852                	sd	s4,16(sp)
    80001a4c:	e456                	sd	s5,8(sp)
    80001a4e:	e05a                	sd	s6,0(sp)
    80001a50:	0080                	addi	s0,sp,64
    return;
  char *sep;
  if (level == 2) {
    80001a52:	4789                	li	a5,2
    80001a54:	02f58d63          	beq	a1,a5,80001a8e <vm_p_helper+0x54>
    sep = "..";
  } else if (level == 1) {
    80001a58:	4785                	li	a5,1
    80001a5a:	02f58f63          	beq	a1,a5,80001a98 <vm_p_helper+0x5e>
    sep = ".. ..";
  } else if (level == 0) {
    sep = ".. .. ..";
    80001a5e:	00006b17          	auipc	s6,0x6
    80001a62:	76ab0b13          	addi	s6,s6,1898 # 800081c8 <digits+0x160>
  } else if (level == 0) {
    80001a66:	ed81                	bnez	a1,80001a7e <vm_p_helper+0x44>
  } else {
    panic("error print page table");
  }
  for (int i = 0; i < 512; i++) {
    80001a68:	84aa                	mv	s1,a0
    80001a6a:	4901                	li	s2,0
    pte_t *pte = &pgt[i];
    if ((*pte & PTE_V) == 1) {
      printf(" %s%d: pte %p pa %p\n", sep, i, *pte, PTE2PA(*pte));
    80001a6c:	00006a97          	auipc	s5,0x6
    80001a70:	784a8a93          	addi	s5,s5,1924 # 800081f0 <digits+0x188>
      vm_p_helper((pagetable_t)PTE2PA(*pte), level - 1);
    80001a74:	fff58a1b          	addiw	s4,a1,-1
  for (int i = 0; i < 512; i++) {
    80001a78:	20000993          	li	s3,512
    80001a7c:	a03d                	j	80001aaa <vm_p_helper+0x70>
    panic("error print page table");
    80001a7e:	00006517          	auipc	a0,0x6
    80001a82:	75a50513          	addi	a0,a0,1882 # 800081d8 <digits+0x170>
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	b46080e7          	jalr	-1210(ra) # 800005cc <panic>
    sep = "..";
    80001a8e:	00006b17          	auipc	s6,0x6
    80001a92:	72ab0b13          	addi	s6,s6,1834 # 800081b8 <digits+0x150>
    80001a96:	bfc9                	j	80001a68 <vm_p_helper+0x2e>
    sep = ".. ..";
    80001a98:	00006b17          	auipc	s6,0x6
    80001a9c:	728b0b13          	addi	s6,s6,1832 # 800081c0 <digits+0x158>
    80001aa0:	b7e1                	j	80001a68 <vm_p_helper+0x2e>
  for (int i = 0; i < 512; i++) {
    80001aa2:	2905                	addiw	s2,s2,1
    80001aa4:	04a1                	addi	s1,s1,8
    80001aa6:	03390963          	beq	s2,s3,80001ad8 <vm_p_helper+0x9e>
    if ((*pte & PTE_V) == 1) {
    80001aaa:	6094                	ld	a3,0(s1)
    80001aac:	0016f793          	andi	a5,a3,1
    80001ab0:	dbed                	beqz	a5,80001aa2 <vm_p_helper+0x68>
      printf(" %s%d: pte %p pa %p\n", sep, i, *pte, PTE2PA(*pte));
    80001ab2:	00a6d713          	srli	a4,a3,0xa
    80001ab6:	0732                	slli	a4,a4,0xc
    80001ab8:	864a                	mv	a2,s2
    80001aba:	85da                	mv	a1,s6
    80001abc:	8556                	mv	a0,s5
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	b60080e7          	jalr	-1184(ra) # 8000061e <printf>
      vm_p_helper((pagetable_t)PTE2PA(*pte), level - 1);
    80001ac6:	6088                	ld	a0,0(s1)
    80001ac8:	8129                	srli	a0,a0,0xa
    80001aca:	85d2                	mv	a1,s4
    80001acc:	0532                	slli	a0,a0,0xc
    80001ace:	00000097          	auipc	ra,0x0
    80001ad2:	f6c080e7          	jalr	-148(ra) # 80001a3a <vm_p_helper>
    80001ad6:	b7f1                	j	80001aa2 <vm_p_helper+0x68>
    }
  }
}
    80001ad8:	70e2                	ld	ra,56(sp)
    80001ada:	7442                	ld	s0,48(sp)
    80001adc:	74a2                	ld	s1,40(sp)
    80001ade:	7902                	ld	s2,32(sp)
    80001ae0:	69e2                	ld	s3,24(sp)
    80001ae2:	6a42                	ld	s4,16(sp)
    80001ae4:	6aa2                	ld	s5,8(sp)
    80001ae6:	6b02                	ld	s6,0(sp)
    80001ae8:	6121                	addi	sp,sp,64
    80001aea:	8082                	ret
    80001aec:	8082                	ret

0000000080001aee <vmprint>:

void vmprint(pagetable_t pgt) {
    80001aee:	1101                	addi	sp,sp,-32
    80001af0:	ec06                	sd	ra,24(sp)
    80001af2:	e822                	sd	s0,16(sp)
    80001af4:	e426                	sd	s1,8(sp)
    80001af6:	1000                	addi	s0,sp,32
    80001af8:	84aa                	mv	s1,a0
  printf("page table %p\n", pgt);
    80001afa:	85aa                	mv	a1,a0
    80001afc:	00006517          	auipc	a0,0x6
    80001b00:	70c50513          	addi	a0,a0,1804 # 80008208 <digits+0x1a0>
    80001b04:	fffff097          	auipc	ra,0xfffff
    80001b08:	b1a080e7          	jalr	-1254(ra) # 8000061e <printf>
  vm_p_helper(pgt, 2);
    80001b0c:	4589                	li	a1,2
    80001b0e:	8526                	mv	a0,s1
    80001b10:	00000097          	auipc	ra,0x0
    80001b14:	f2a080e7          	jalr	-214(ra) # 80001a3a <vm_p_helper>
    80001b18:	60e2                	ld	ra,24(sp)
    80001b1a:	6442                	ld	s0,16(sp)
    80001b1c:	64a2                	ld	s1,8(sp)
    80001b1e:	6105                	addi	sp,sp,32
    80001b20:	8082                	ret

0000000080001b22 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80001b22:	7139                	addi	sp,sp,-64
    80001b24:	fc06                	sd	ra,56(sp)
    80001b26:	f822                	sd	s0,48(sp)
    80001b28:	f426                	sd	s1,40(sp)
    80001b2a:	f04a                	sd	s2,32(sp)
    80001b2c:	ec4e                	sd	s3,24(sp)
    80001b2e:	e852                	sd	s4,16(sp)
    80001b30:	e456                	sd	s5,8(sp)
    80001b32:	e05a                	sd	s6,0(sp)
    80001b34:	0080                	addi	s0,sp,64
    80001b36:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001b38:	00010497          	auipc	s1,0x10
    80001b3c:	b9848493          	addi	s1,s1,-1128 # 800116d0 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001b40:	8b26                	mv	s6,s1
    80001b42:	00006a97          	auipc	s5,0x6
    80001b46:	4bea8a93          	addi	s5,s5,1214 # 80008000 <etext>
    80001b4a:	04000937          	lui	s2,0x4000
    80001b4e:	197d                	addi	s2,s2,-1
    80001b50:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b52:	00016a17          	auipc	s4,0x16
    80001b56:	f7ea0a13          	addi	s4,s4,-130 # 80017ad0 <tickslock>
    char *pa = kalloc();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	ff0080e7          	jalr	-16(ra) # 80000b4a <kalloc>
    80001b62:	862a                	mv	a2,a0
    if (pa == 0)
    80001b64:	c131                	beqz	a0,80001ba8 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001b66:	416485b3          	sub	a1,s1,s6
    80001b6a:	8591                	srai	a1,a1,0x4
    80001b6c:	000ab783          	ld	a5,0(s5)
    80001b70:	02f585b3          	mul	a1,a1,a5
    80001b74:	2585                	addiw	a1,a1,1
    80001b76:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b7a:	4719                	li	a4,6
    80001b7c:	6685                	lui	a3,0x1
    80001b7e:	40b905b3          	sub	a1,s2,a1
    80001b82:	854e                	mv	a0,s3
    80001b84:	fffff097          	auipc	ra,0xfffff
    80001b88:	61c080e7          	jalr	1564(ra) # 800011a0 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b8c:	19048493          	addi	s1,s1,400
    80001b90:	fd4495e3          	bne	s1,s4,80001b5a <proc_mapstacks+0x38>
  }
}
    80001b94:	70e2                	ld	ra,56(sp)
    80001b96:	7442                	ld	s0,48(sp)
    80001b98:	74a2                	ld	s1,40(sp)
    80001b9a:	7902                	ld	s2,32(sp)
    80001b9c:	69e2                	ld	s3,24(sp)
    80001b9e:	6a42                	ld	s4,16(sp)
    80001ba0:	6aa2                	ld	s5,8(sp)
    80001ba2:	6b02                	ld	s6,0(sp)
    80001ba4:	6121                	addi	sp,sp,64
    80001ba6:	8082                	ret
      panic("kalloc");
    80001ba8:	00006517          	auipc	a0,0x6
    80001bac:	67050513          	addi	a0,a0,1648 # 80008218 <digits+0x1b0>
    80001bb0:	fffff097          	auipc	ra,0xfffff
    80001bb4:	a1c080e7          	jalr	-1508(ra) # 800005cc <panic>

0000000080001bb8 <procinit>:

// initialize the proc table at boot time.
void procinit(void) {
    80001bb8:	7139                	addi	sp,sp,-64
    80001bba:	fc06                	sd	ra,56(sp)
    80001bbc:	f822                	sd	s0,48(sp)
    80001bbe:	f426                	sd	s1,40(sp)
    80001bc0:	f04a                	sd	s2,32(sp)
    80001bc2:	ec4e                	sd	s3,24(sp)
    80001bc4:	e852                	sd	s4,16(sp)
    80001bc6:	e456                	sd	s5,8(sp)
    80001bc8:	e05a                	sd	s6,0(sp)
    80001bca:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001bcc:	00006597          	auipc	a1,0x6
    80001bd0:	65458593          	addi	a1,a1,1620 # 80008220 <digits+0x1b8>
    80001bd4:	0000f517          	auipc	a0,0xf
    80001bd8:	6cc50513          	addi	a0,a0,1740 # 800112a0 <pid_lock>
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	fce080e7          	jalr	-50(ra) # 80000baa <initlock>
  initlock(&wait_lock, "wait_lock");
    80001be4:	00006597          	auipc	a1,0x6
    80001be8:	64458593          	addi	a1,a1,1604 # 80008228 <digits+0x1c0>
    80001bec:	0000f517          	auipc	a0,0xf
    80001bf0:	6cc50513          	addi	a0,a0,1740 # 800112b8 <wait_lock>
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	fb6080e7          	jalr	-74(ra) # 80000baa <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bfc:	00010497          	auipc	s1,0x10
    80001c00:	ad448493          	addi	s1,s1,-1324 # 800116d0 <proc>
    initlock(&p->lock, "proc");
    80001c04:	00006b17          	auipc	s6,0x6
    80001c08:	634b0b13          	addi	s6,s6,1588 # 80008238 <digits+0x1d0>
    p->kstack = KSTACK((int)(p - proc));
    80001c0c:	8aa6                	mv	s5,s1
    80001c0e:	00006a17          	auipc	s4,0x6
    80001c12:	3f2a0a13          	addi	s4,s4,1010 # 80008000 <etext>
    80001c16:	04000937          	lui	s2,0x4000
    80001c1a:	197d                	addi	s2,s2,-1
    80001c1c:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001c1e:	00016997          	auipc	s3,0x16
    80001c22:	eb298993          	addi	s3,s3,-334 # 80017ad0 <tickslock>
    initlock(&p->lock, "proc");
    80001c26:	85da                	mv	a1,s6
    80001c28:	8526                	mv	a0,s1
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	f80080e7          	jalr	-128(ra) # 80000baa <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80001c32:	415487b3          	sub	a5,s1,s5
    80001c36:	8791                	srai	a5,a5,0x4
    80001c38:	000a3703          	ld	a4,0(s4)
    80001c3c:	02e787b3          	mul	a5,a5,a4
    80001c40:	2785                	addiw	a5,a5,1
    80001c42:	00d7979b          	slliw	a5,a5,0xd
    80001c46:	40f907b3          	sub	a5,s2,a5
    80001c4a:	e4bc                	sd	a5,72(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001c4c:	19048493          	addi	s1,s1,400
    80001c50:	fd349be3          	bne	s1,s3,80001c26 <procinit+0x6e>
  }
}
    80001c54:	70e2                	ld	ra,56(sp)
    80001c56:	7442                	ld	s0,48(sp)
    80001c58:	74a2                	ld	s1,40(sp)
    80001c5a:	7902                	ld	s2,32(sp)
    80001c5c:	69e2                	ld	s3,24(sp)
    80001c5e:	6a42                	ld	s4,16(sp)
    80001c60:	6aa2                	ld	s5,8(sp)
    80001c62:	6b02                	ld	s6,0(sp)
    80001c64:	6121                	addi	sp,sp,64
    80001c66:	8082                	ret

0000000080001c68 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80001c68:	1141                	addi	sp,sp,-16
    80001c6a:	e422                	sd	s0,8(sp)
    80001c6c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001c6e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001c70:	2501                	sext.w	a0,a0
    80001c72:	6422                	ld	s0,8(sp)
    80001c74:	0141                	addi	sp,sp,16
    80001c76:	8082                	ret

0000000080001c78 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80001c78:	1141                	addi	sp,sp,-16
    80001c7a:	e422                	sd	s0,8(sp)
    80001c7c:	0800                	addi	s0,sp,16
    80001c7e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001c80:	2781                	sext.w	a5,a5
    80001c82:	079e                	slli	a5,a5,0x7
  return c;
}
    80001c84:	0000f517          	auipc	a0,0xf
    80001c88:	64c50513          	addi	a0,a0,1612 # 800112d0 <cpus>
    80001c8c:	953e                	add	a0,a0,a5
    80001c8e:	6422                	ld	s0,8(sp)
    80001c90:	0141                	addi	sp,sp,16
    80001c92:	8082                	ret

0000000080001c94 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	1000                	addi	s0,sp,32
  push_off();
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	f50080e7          	jalr	-176(ra) # 80000bee <push_off>
    80001ca6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001ca8:	2781                	sext.w	a5,a5
    80001caa:	079e                	slli	a5,a5,0x7
    80001cac:	0000f717          	auipc	a4,0xf
    80001cb0:	5f470713          	addi	a4,a4,1524 # 800112a0 <pid_lock>
    80001cb4:	97ba                	add	a5,a5,a4
    80001cb6:	7b84                	ld	s1,48(a5)
  pop_off();
    80001cb8:	fffff097          	auipc	ra,0xfffff
    80001cbc:	fd6080e7          	jalr	-42(ra) # 80000c8e <pop_off>
  return p;
}
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	60e2                	ld	ra,24(sp)
    80001cc4:	6442                	ld	s0,16(sp)
    80001cc6:	64a2                	ld	s1,8(sp)
    80001cc8:	6105                	addi	sp,sp,32
    80001cca:	8082                	ret

0000000080001ccc <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80001ccc:	1141                	addi	sp,sp,-16
    80001cce:	e406                	sd	ra,8(sp)
    80001cd0:	e022                	sd	s0,0(sp)
    80001cd2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	fc0080e7          	jalr	-64(ra) # 80001c94 <myproc>
    80001cdc:	fffff097          	auipc	ra,0xfffff
    80001ce0:	012080e7          	jalr	18(ra) # 80000cee <release>

  if (first) {
    80001ce4:	00007797          	auipc	a5,0x7
    80001ce8:	bfc7a783          	lw	a5,-1028(a5) # 800088e0 <first.1>
    80001cec:	eb89                	bnez	a5,80001cfe <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001cee:	00001097          	auipc	ra,0x1
    80001cf2:	e58080e7          	jalr	-424(ra) # 80002b46 <usertrapret>
}
    80001cf6:	60a2                	ld	ra,8(sp)
    80001cf8:	6402                	ld	s0,0(sp)
    80001cfa:	0141                	addi	sp,sp,16
    80001cfc:	8082                	ret
    first = 0;
    80001cfe:	00007797          	auipc	a5,0x7
    80001d02:	be07a123          	sw	zero,-1054(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80001d06:	4505                	li	a0,1
    80001d08:	00002097          	auipc	ra,0x2
    80001d0c:	db8080e7          	jalr	-584(ra) # 80003ac0 <fsinit>
    80001d10:	bff9                	j	80001cee <forkret+0x22>

0000000080001d12 <allocpid>:
int allocpid() {
    80001d12:	1101                	addi	sp,sp,-32
    80001d14:	ec06                	sd	ra,24(sp)
    80001d16:	e822                	sd	s0,16(sp)
    80001d18:	e426                	sd	s1,8(sp)
    80001d1a:	e04a                	sd	s2,0(sp)
    80001d1c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001d1e:	0000f917          	auipc	s2,0xf
    80001d22:	58290913          	addi	s2,s2,1410 # 800112a0 <pid_lock>
    80001d26:	854a                	mv	a0,s2
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	f12080e7          	jalr	-238(ra) # 80000c3a <acquire>
  pid = nextpid;
    80001d30:	00007797          	auipc	a5,0x7
    80001d34:	bb478793          	addi	a5,a5,-1100 # 800088e4 <nextpid>
    80001d38:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d3a:	0014871b          	addiw	a4,s1,1
    80001d3e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001d40:	854a                	mv	a0,s2
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	fac080e7          	jalr	-84(ra) # 80000cee <release>
}
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	60e2                	ld	ra,24(sp)
    80001d4e:	6442                	ld	s0,16(sp)
    80001d50:	64a2                	ld	s1,8(sp)
    80001d52:	6902                	ld	s2,0(sp)
    80001d54:	6105                	addi	sp,sp,32
    80001d56:	8082                	ret

0000000080001d58 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80001d58:	1101                	addi	sp,sp,-32
    80001d5a:	ec06                	sd	ra,24(sp)
    80001d5c:	e822                	sd	s0,16(sp)
    80001d5e:	e426                	sd	s1,8(sp)
    80001d60:	e04a                	sd	s2,0(sp)
    80001d62:	1000                	addi	s0,sp,32
    80001d64:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	5fc080e7          	jalr	1532(ra) # 80001362 <uvmcreate>
    80001d6e:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001d70:	c121                	beqz	a0,80001db0 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001d72:	4729                	li	a4,10
    80001d74:	00005697          	auipc	a3,0x5
    80001d78:	28c68693          	addi	a3,a3,652 # 80007000 <_trampoline>
    80001d7c:	6605                	lui	a2,0x1
    80001d7e:	040005b7          	lui	a1,0x4000
    80001d82:	15fd                	addi	a1,a1,-1
    80001d84:	05b2                	slli	a1,a1,0xc
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	380080e7          	jalr	896(ra) # 80001106 <mappages>
    80001d8e:	02054863          	bltz	a0,80001dbe <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001d92:	4719                	li	a4,6
    80001d94:	06893683          	ld	a3,104(s2)
    80001d98:	6605                	lui	a2,0x1
    80001d9a:	020005b7          	lui	a1,0x2000
    80001d9e:	15fd                	addi	a1,a1,-1
    80001da0:	05b6                	slli	a1,a1,0xd
    80001da2:	8526                	mv	a0,s1
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	362080e7          	jalr	866(ra) # 80001106 <mappages>
    80001dac:	02054163          	bltz	a0,80001dce <proc_pagetable+0x76>
}
    80001db0:	8526                	mv	a0,s1
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6902                	ld	s2,0(sp)
    80001dba:	6105                	addi	sp,sp,32
    80001dbc:	8082                	ret
    uvmfree(pagetable, 0);
    80001dbe:	4581                	li	a1,0
    80001dc0:	8526                	mv	a0,s1
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	8c8080e7          	jalr	-1848(ra) # 8000168a <uvmfree>
    return 0;
    80001dca:	4481                	li	s1,0
    80001dcc:	b7d5                	j	80001db0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001dce:	4681                	li	a3,0
    80001dd0:	4605                	li	a2,1
    80001dd2:	040005b7          	lui	a1,0x4000
    80001dd6:	15fd                	addi	a1,a1,-1
    80001dd8:	05b2                	slli	a1,a1,0xc
    80001dda:	8526                	mv	a0,s1
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	4e0080e7          	jalr	1248(ra) # 800012bc <uvmunmap>
    uvmfree(pagetable, 0);
    80001de4:	4581                	li	a1,0
    80001de6:	8526                	mv	a0,s1
    80001de8:	00000097          	auipc	ra,0x0
    80001dec:	8a2080e7          	jalr	-1886(ra) # 8000168a <uvmfree>
    return 0;
    80001df0:	4481                	li	s1,0
    80001df2:	bf7d                	j	80001db0 <proc_pagetable+0x58>

0000000080001df4 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80001df4:	1101                	addi	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	e04a                	sd	s2,0(sp)
    80001dfe:	1000                	addi	s0,sp,32
    80001e00:	84aa                	mv	s1,a0
    80001e02:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e04:	4681                	li	a3,0
    80001e06:	4605                	li	a2,1
    80001e08:	040005b7          	lui	a1,0x4000
    80001e0c:	15fd                	addi	a1,a1,-1
    80001e0e:	05b2                	slli	a1,a1,0xc
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	4ac080e7          	jalr	1196(ra) # 800012bc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e18:	4681                	li	a3,0
    80001e1a:	4605                	li	a2,1
    80001e1c:	020005b7          	lui	a1,0x2000
    80001e20:	15fd                	addi	a1,a1,-1
    80001e22:	05b6                	slli	a1,a1,0xd
    80001e24:	8526                	mv	a0,s1
    80001e26:	fffff097          	auipc	ra,0xfffff
    80001e2a:	496080e7          	jalr	1174(ra) # 800012bc <uvmunmap>
  uvmfree(pagetable, sz);
    80001e2e:	85ca                	mv	a1,s2
    80001e30:	8526                	mv	a0,s1
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	858080e7          	jalr	-1960(ra) # 8000168a <uvmfree>
}
    80001e3a:	60e2                	ld	ra,24(sp)
    80001e3c:	6442                	ld	s0,16(sp)
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	6902                	ld	s2,0(sp)
    80001e42:	6105                	addi	sp,sp,32
    80001e44:	8082                	ret

0000000080001e46 <freeproc>:
static void freeproc(struct proc *p) {
    80001e46:	1101                	addi	sp,sp,-32
    80001e48:	ec06                	sd	ra,24(sp)
    80001e4a:	e822                	sd	s0,16(sp)
    80001e4c:	e426                	sd	s1,8(sp)
    80001e4e:	1000                	addi	s0,sp,32
    80001e50:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001e52:	7528                	ld	a0,104(a0)
    80001e54:	c509                	beqz	a0,80001e5e <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	bf8080e7          	jalr	-1032(ra) # 80000a4e <kfree>
  p->trapframe = 0;
    80001e5e:	0604b423          	sd	zero,104(s1)
  if (p->pagetable)
    80001e62:	6ca8                	ld	a0,88(s1)
    80001e64:	c511                	beqz	a0,80001e70 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001e66:	68ac                	ld	a1,80(s1)
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	f8c080e7          	jalr	-116(ra) # 80001df4 <proc_freepagetable>
  if (p->k_pagetable) {
    80001e70:	70bc                	ld	a5,96(s1)
    80001e72:	c791                	beqz	a5,80001e7e <freeproc+0x38>
  free_kmapping(p);
    80001e74:	8526                	mv	a0,s1
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	84c080e7          	jalr	-1972(ra) # 800016c2 <free_kmapping>
  p->pagetable = 0;
    80001e7e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001e82:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001e86:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001e8a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001e8e:	18048023          	sb	zero,384(s1)
  p->chan = 0;
    80001e92:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001e96:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001e9a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001e9e:	0004ac23          	sw	zero,24(s1)
}
    80001ea2:	60e2                	ld	ra,24(sp)
    80001ea4:	6442                	ld	s0,16(sp)
    80001ea6:	64a2                	ld	s1,8(sp)
    80001ea8:	6105                	addi	sp,sp,32
    80001eaa:	8082                	ret

0000000080001eac <allocproc>:
static struct proc *allocproc(void) {
    80001eac:	1101                	addi	sp,sp,-32
    80001eae:	ec06                	sd	ra,24(sp)
    80001eb0:	e822                	sd	s0,16(sp)
    80001eb2:	e426                	sd	s1,8(sp)
    80001eb4:	e04a                	sd	s2,0(sp)
    80001eb6:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001eb8:	00010497          	auipc	s1,0x10
    80001ebc:	81848493          	addi	s1,s1,-2024 # 800116d0 <proc>
    80001ec0:	00016917          	auipc	s2,0x16
    80001ec4:	c1090913          	addi	s2,s2,-1008 # 80017ad0 <tickslock>
    acquire(&p->lock);
    80001ec8:	8526                	mv	a0,s1
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	d70080e7          	jalr	-656(ra) # 80000c3a <acquire>
    if (p->state == UNUSED) {
    80001ed2:	4c9c                	lw	a5,24(s1)
    80001ed4:	cf81                	beqz	a5,80001eec <allocproc+0x40>
      release(&p->lock);
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	e16080e7          	jalr	-490(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ee0:	19048493          	addi	s1,s1,400
    80001ee4:	ff2492e3          	bne	s1,s2,80001ec8 <allocproc+0x1c>
  return 0;
    80001ee8:	4481                	li	s1,0
    80001eea:	a845                	j	80001f9a <allocproc+0xee>
  p->pid = allocpid();
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	e26080e7          	jalr	-474(ra) # 80001d12 <allocpid>
    80001ef4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ef6:	4785                	li	a5,1
    80001ef8:	cc9c                	sw	a5,24(s1)
  p->if_alarm = 0;
    80001efa:	16048423          	sb	zero,360(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	c4c080e7          	jalr	-948(ra) # 80000b4a <kalloc>
    80001f06:	892a                	mv	s2,a0
    80001f08:	f4a8                	sd	a0,104(s1)
    80001f0a:	cd59                	beqz	a0,80001fa8 <allocproc+0xfc>
  p->pagetable = proc_pagetable(p);
    80001f0c:	8526                	mv	a0,s1
    80001f0e:	00000097          	auipc	ra,0x0
    80001f12:	e4a080e7          	jalr	-438(ra) # 80001d58 <proc_pagetable>
    80001f16:	892a                	mv	s2,a0
    80001f18:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0) {
    80001f1a:	c15d                	beqz	a0,80001fc0 <allocproc+0x114>
  p->k_pagetable = kvmmake();
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	2b4080e7          	jalr	692(ra) # 800011d0 <kvmmake>
    80001f24:	892a                	mv	s2,a0
    80001f26:	f0a8                	sd	a0,96(s1)
  if (p->k_pagetable == 0) {
    80001f28:	c945                	beqz	a0,80001fd8 <allocproc+0x12c>
  char *pa = kalloc();
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	c20080e7          	jalr	-992(ra) # 80000b4a <kalloc>
    80001f32:	862a                	mv	a2,a0
  if (pa == 0)
    80001f34:	cd55                	beqz	a0,80001ff0 <allocproc+0x144>
  uint64 va = KSTACK((int)(p - proc));
    80001f36:	0000f797          	auipc	a5,0xf
    80001f3a:	79a78793          	addi	a5,a5,1946 # 800116d0 <proc>
    80001f3e:	40f487b3          	sub	a5,s1,a5
    80001f42:	8791                	srai	a5,a5,0x4
    80001f44:	00006717          	auipc	a4,0x6
    80001f48:	0bc73703          	ld	a4,188(a4) # 80008000 <etext>
    80001f4c:	02e787b3          	mul	a5,a5,a4
    80001f50:	2785                	addiw	a5,a5,1
    80001f52:	00d7979b          	slliw	a5,a5,0xd
    80001f56:	04000937          	lui	s2,0x4000
    80001f5a:	197d                	addi	s2,s2,-1
    80001f5c:	0932                	slli	s2,s2,0xc
    80001f5e:	40f90933          	sub	s2,s2,a5
  kvmmap(p->k_pagetable, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f62:	4719                	li	a4,6
    80001f64:	6685                	lui	a3,0x1
    80001f66:	85ca                	mv	a1,s2
    80001f68:	70a8                	ld	a0,96(s1)
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	236080e7          	jalr	566(ra) # 800011a0 <kvmmap>
  p->kstack = va;
    80001f72:	0524b423          	sd	s2,72(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001f76:	07000613          	li	a2,112
    80001f7a:	4581                	li	a1,0
    80001f7c:	07048513          	addi	a0,s1,112
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	db6080e7          	jalr	-586(ra) # 80000d36 <memset>
  p->context.ra = (uint64)forkret;
    80001f88:	00000797          	auipc	a5,0x0
    80001f8c:	d4478793          	addi	a5,a5,-700 # 80001ccc <forkret>
    80001f90:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001f92:	64bc                	ld	a5,72(s1)
    80001f94:	6705                	lui	a4,0x1
    80001f96:	97ba                	add	a5,a5,a4
    80001f98:	fcbc                	sd	a5,120(s1)
}
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6902                	ld	s2,0(sp)
    80001fa4:	6105                	addi	sp,sp,32
    80001fa6:	8082                	ret
    freeproc(p);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	00000097          	auipc	ra,0x0
    80001fae:	e9c080e7          	jalr	-356(ra) # 80001e46 <freeproc>
    release(&p->lock);
    80001fb2:	8526                	mv	a0,s1
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	d3a080e7          	jalr	-710(ra) # 80000cee <release>
    return 0;
    80001fbc:	84ca                	mv	s1,s2
    80001fbe:	bff1                	j	80001f9a <allocproc+0xee>
    freeproc(p);
    80001fc0:	8526                	mv	a0,s1
    80001fc2:	00000097          	auipc	ra,0x0
    80001fc6:	e84080e7          	jalr	-380(ra) # 80001e46 <freeproc>
    release(&p->lock);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	fffff097          	auipc	ra,0xfffff
    80001fd0:	d22080e7          	jalr	-734(ra) # 80000cee <release>
    return 0;
    80001fd4:	84ca                	mv	s1,s2
    80001fd6:	b7d1                	j	80001f9a <allocproc+0xee>
    freeproc(p);
    80001fd8:	8526                	mv	a0,s1
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	e6c080e7          	jalr	-404(ra) # 80001e46 <freeproc>
    release(&p->lock);
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	fffff097          	auipc	ra,0xfffff
    80001fe8:	d0a080e7          	jalr	-758(ra) # 80000cee <release>
    return 0;
    80001fec:	84ca                	mv	s1,s2
    80001fee:	b775                	j	80001f9a <allocproc+0xee>
    panic("kalloc");
    80001ff0:	00006517          	auipc	a0,0x6
    80001ff4:	22850513          	addi	a0,a0,552 # 80008218 <digits+0x1b0>
    80001ff8:	ffffe097          	auipc	ra,0xffffe
    80001ffc:	5d4080e7          	jalr	1492(ra) # 800005cc <panic>

0000000080002000 <proc_freekpagetable>:
void proc_freekpagetable(struct proc *p) {
    80002000:	1141                	addi	sp,sp,-16
    80002002:	e406                	sd	ra,8(sp)
    80002004:	e022                	sd	s0,0(sp)
    80002006:	0800                	addi	s0,sp,16
  free_kmapping(p);
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	6ba080e7          	jalr	1722(ra) # 800016c2 <free_kmapping>
}
    80002010:	60a2                	ld	ra,8(sp)
    80002012:	6402                	ld	s0,0(sp)
    80002014:	0141                	addi	sp,sp,16
    80002016:	8082                	ret

0000000080002018 <userinit>:
void userinit(void) {
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	e04a                	sd	s2,0(sp)
    80002022:	1000                	addi	s0,sp,32
  p = allocproc();
    80002024:	00000097          	auipc	ra,0x0
    80002028:	e88080e7          	jalr	-376(ra) # 80001eac <allocproc>
    8000202c:	84aa                	mv	s1,a0
  initproc = p;
    8000202e:	00007797          	auipc	a5,0x7
    80002032:	fea7bd23          	sd	a0,-6(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80002036:	03400613          	li	a2,52
    8000203a:	00007597          	auipc	a1,0x7
    8000203e:	8b658593          	addi	a1,a1,-1866 # 800088f0 <initcode>
    80002042:	6d28                	ld	a0,88(a0)
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	34c080e7          	jalr	844(ra) # 80001390 <uvminit>
  p->sz = PGSIZE;
    8000204c:	6905                	lui	s2,0x1
    8000204e:	0524b823          	sd	s2,80(s1)
  uvmapping(p->pagetable, p->k_pagetable, 0, p->sz);
    80002052:	6685                	lui	a3,0x1
    80002054:	4601                	li	a2,0
    80002056:	70ac                	ld	a1,96(s1)
    80002058:	6ca8                	ld	a0,88(s1)
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	3a8080e7          	jalr	936(ra) # 80001402 <uvmapping>
  p->trapframe->epc = 0;     // user program counter
    80002062:	74bc                	ld	a5,104(s1)
    80002064:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE; // user stack pointer
    80002068:	74bc                	ld	a5,104(s1)
    8000206a:	0327b823          	sd	s2,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000206e:	4641                	li	a2,16
    80002070:	00006597          	auipc	a1,0x6
    80002074:	1d058593          	addi	a1,a1,464 # 80008240 <digits+0x1d8>
    80002078:	18048513          	addi	a0,s1,384
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	e0c080e7          	jalr	-500(ra) # 80000e88 <safestrcpy>
  p->cwd = namei("/");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	1cc50513          	addi	a0,a0,460 # 80008250 <digits+0x1e8>
    8000208c:	00002097          	auipc	ra,0x2
    80002090:	462080e7          	jalr	1122(ra) # 800044ee <namei>
    80002094:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80002098:	478d                	li	a5,3
    8000209a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000209c:	8526                	mv	a0,s1
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	c50080e7          	jalr	-944(ra) # 80000cee <release>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6902                	ld	s2,0(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret

00000000800020b2 <growproc>:
int growproc(int n) {
    800020b2:	7139                	addi	sp,sp,-64
    800020b4:	fc06                	sd	ra,56(sp)
    800020b6:	f822                	sd	s0,48(sp)
    800020b8:	f426                	sd	s1,40(sp)
    800020ba:	f04a                	sd	s2,32(sp)
    800020bc:	ec4e                	sd	s3,24(sp)
    800020be:	e852                	sd	s4,16(sp)
    800020c0:	e456                	sd	s5,8(sp)
    800020c2:	0080                	addi	s0,sp,64
    800020c4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	bce080e7          	jalr	-1074(ra) # 80001c94 <myproc>
    800020ce:	892a                	mv	s2,a0
  sz = p->sz;
    800020d0:	05053a03          	ld	s4,80(a0)
    800020d4:	000a0a9b          	sext.w	s5,s4
  if (n > 0) {
    800020d8:	04904363          	bgtz	s1,8000211e <growproc+0x6c>
  sz = p->sz;
    800020dc:	89d6                	mv	s3,s5
  } else if (n < 0) {
    800020de:	0604c263          	bltz	s1,80002142 <growproc+0x90>
  uvmapping(p->pagetable, p->k_pagetable, oldsz, oldsz + n);
    800020e2:	015486bb          	addw	a3,s1,s5
    800020e6:	1682                	slli	a3,a3,0x20
    800020e8:	9281                	srli	a3,a3,0x20
    800020ea:	020a1613          	slli	a2,s4,0x20
    800020ee:	9201                	srli	a2,a2,0x20
    800020f0:	06093583          	ld	a1,96(s2) # 1060 <_entry-0x7fffefa0>
    800020f4:	05893503          	ld	a0,88(s2)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	30a080e7          	jalr	778(ra) # 80001402 <uvmapping>
  p->sz = sz;
    80002100:	1982                	slli	s3,s3,0x20
    80002102:	0209d993          	srli	s3,s3,0x20
    80002106:	05393823          	sd	s3,80(s2)
  return 0;
    8000210a:	4501                	li	a0,0
}
    8000210c:	70e2                	ld	ra,56(sp)
    8000210e:	7442                	ld	s0,48(sp)
    80002110:	74a2                	ld	s1,40(sp)
    80002112:	7902                	ld	s2,32(sp)
    80002114:	69e2                	ld	s3,24(sp)
    80002116:	6a42                	ld	s4,16(sp)
    80002118:	6aa2                	ld	s5,8(sp)
    8000211a:	6121                	addi	sp,sp,64
    8000211c:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000211e:	0154863b          	addw	a2,s1,s5
    80002122:	1602                	slli	a2,a2,0x20
    80002124:	9201                	srli	a2,a2,0x20
    80002126:	020a1593          	slli	a1,s4,0x20
    8000212a:	9181                	srli	a1,a1,0x20
    8000212c:	6d28                	ld	a0,88(a0)
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	3a6080e7          	jalr	934(ra) # 800014d4 <uvmalloc>
    80002136:	0005099b          	sext.w	s3,a0
    8000213a:	fa0994e3          	bnez	s3,800020e2 <growproc+0x30>
      return -1;
    8000213e:	557d                	li	a0,-1
    80002140:	b7f1                	j	8000210c <growproc+0x5a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002142:	0154863b          	addw	a2,s1,s5
    80002146:	1602                	slli	a2,a2,0x20
    80002148:	9201                	srli	a2,a2,0x20
    8000214a:	020a1593          	slli	a1,s4,0x20
    8000214e:	9181                	srli	a1,a1,0x20
    80002150:	6d28                	ld	a0,88(a0)
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	33a080e7          	jalr	826(ra) # 8000148c <uvmdealloc>
    8000215a:	0005099b          	sext.w	s3,a0
    8000215e:	b751                	j	800020e2 <growproc+0x30>

0000000080002160 <trace>:
i32 trace(i32 traced) {
    80002160:	1101                	addi	sp,sp,-32
    80002162:	ec06                	sd	ra,24(sp)
    80002164:	e822                	sd	s0,16(sp)
    80002166:	e426                	sd	s1,8(sp)
    80002168:	1000                	addi	s0,sp,32
    8000216a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	b28080e7          	jalr	-1240(ra) # 80001c94 <myproc>
  p->traced |= traced;
    80002174:	413c                	lw	a5,64(a0)
    80002176:	8cdd                	or	s1,s1,a5
    80002178:	c124                	sw	s1,64(a0)
}
    8000217a:	4501                	li	a0,0
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	64a2                	ld	s1,8(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <alarm>:
u64 alarm(i32 tick, void *handler) {
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	e426                	sd	s1,8(sp)
    8000218e:	e04a                	sd	s2,0(sp)
    80002190:	1000                	addi	s0,sp,32
    80002192:	84aa                	mv	s1,a0
    80002194:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	afe080e7          	jalr	-1282(ra) # 80001c94 <myproc>
  p->if_alarm = (tick != 0);
    8000219e:	009037b3          	snez	a5,s1
    800021a2:	16f50423          	sb	a5,360(a0)
  p->tick = tick;
    800021a6:	0004879b          	sext.w	a5,s1
    800021aa:	16f52623          	sw	a5,364(a0)
  p->tick_left = tick;
    800021ae:	16f52823          	sw	a5,368(a0)
  p->handler = handler;
    800021b2:	17253c23          	sd	s2,376(a0)
}
    800021b6:	8526                	mv	a0,s1
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6902                	ld	s2,0(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <fork>:
int fork(void) {
    800021c4:	7139                	addi	sp,sp,-64
    800021c6:	fc06                	sd	ra,56(sp)
    800021c8:	f822                	sd	s0,48(sp)
    800021ca:	f426                	sd	s1,40(sp)
    800021cc:	f04a                	sd	s2,32(sp)
    800021ce:	ec4e                	sd	s3,24(sp)
    800021d0:	e852                	sd	s4,16(sp)
    800021d2:	e456                	sd	s5,8(sp)
    800021d4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800021d6:	00000097          	auipc	ra,0x0
    800021da:	abe080e7          	jalr	-1346(ra) # 80001c94 <myproc>
    800021de:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	ccc080e7          	jalr	-820(ra) # 80001eac <allocproc>
    800021e8:	14050c63          	beqz	a0,80002340 <fork+0x17c>
    800021ec:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800021ee:	050ab603          	ld	a2,80(s5)
    800021f2:	6d2c                	ld	a1,88(a0)
    800021f4:	058ab503          	ld	a0,88(s5)
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	5a4080e7          	jalr	1444(ra) # 8000179c <uvmcopy>
    80002200:	08054063          	bltz	a0,80002280 <fork+0xbc>
  uvmapping(np->pagetable, np->k_pagetable, 0, p->sz);
    80002204:	050ab683          	ld	a3,80(s5)
    80002208:	4601                	li	a2,0
    8000220a:	0609b583          	ld	a1,96(s3)
    8000220e:	0589b503          	ld	a0,88(s3)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	1f0080e7          	jalr	496(ra) # 80001402 <uvmapping>
  if ((pte = walk(np->k_pagetable, 0, 0)) == 0) {
    8000221a:	4601                	li	a2,0
    8000221c:	4581                	li	a1,0
    8000221e:	0609b503          	ld	a0,96(s3)
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	dfc080e7          	jalr	-516(ra) # 8000101e <walk>
    8000222a:	c53d                	beqz	a0,80002298 <fork+0xd4>
  np->sz = p->sz;
    8000222c:	050ab783          	ld	a5,80(s5)
    80002230:	04f9b823          	sd	a5,80(s3)
  np->traced = p->traced;
    80002234:	040aa783          	lw	a5,64(s5)
    80002238:	04f9a023          	sw	a5,64(s3)
  *(np->trapframe) = *(p->trapframe);
    8000223c:	068ab683          	ld	a3,104(s5)
    80002240:	87b6                	mv	a5,a3
    80002242:	0689b703          	ld	a4,104(s3)
    80002246:	12068693          	addi	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    8000224a:	0007b803          	ld	a6,0(a5)
    8000224e:	6788                	ld	a0,8(a5)
    80002250:	6b8c                	ld	a1,16(a5)
    80002252:	6f90                	ld	a2,24(a5)
    80002254:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80002258:	e708                	sd	a0,8(a4)
    8000225a:	eb0c                	sd	a1,16(a4)
    8000225c:	ef10                	sd	a2,24(a4)
    8000225e:	02078793          	addi	a5,a5,32
    80002262:	02070713          	addi	a4,a4,32
    80002266:	fed792e3          	bne	a5,a3,8000224a <fork+0x86>
  np->trapframe->a0 = 0;
    8000226a:	0689b783          	ld	a5,104(s3)
    8000226e:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80002272:	0e0a8493          	addi	s1,s5,224
    80002276:	0e098913          	addi	s2,s3,224
    8000227a:	160a8a13          	addi	s4,s5,352
    8000227e:	a83d                	j	800022bc <fork+0xf8>
    freeproc(np);
    80002280:	854e                	mv	a0,s3
    80002282:	00000097          	auipc	ra,0x0
    80002286:	bc4080e7          	jalr	-1084(ra) # 80001e46 <freeproc>
    release(&np->lock);
    8000228a:	854e                	mv	a0,s3
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	a62080e7          	jalr	-1438(ra) # 80000cee <release>
    return -1;
    80002294:	597d                	li	s2,-1
    80002296:	a859                	j	8000232c <fork+0x168>
    panic("not valid k table");
    80002298:	00006517          	auipc	a0,0x6
    8000229c:	fc050513          	addi	a0,a0,-64 # 80008258 <digits+0x1f0>
    800022a0:	ffffe097          	auipc	ra,0xffffe
    800022a4:	32c080e7          	jalr	812(ra) # 800005cc <panic>
      np->ofile[i] = filedup(p->ofile[i]);
    800022a8:	00003097          	auipc	ra,0x3
    800022ac:	8dc080e7          	jalr	-1828(ra) # 80004b84 <filedup>
    800022b0:	00a93023          	sd	a0,0(s2)
  for (i = 0; i < NOFILE; i++)
    800022b4:	04a1                	addi	s1,s1,8
    800022b6:	0921                	addi	s2,s2,8
    800022b8:	01448563          	beq	s1,s4,800022c2 <fork+0xfe>
    if (p->ofile[i])
    800022bc:	6088                	ld	a0,0(s1)
    800022be:	f56d                	bnez	a0,800022a8 <fork+0xe4>
    800022c0:	bfd5                	j	800022b4 <fork+0xf0>
  np->cwd = idup(p->cwd);
    800022c2:	160ab503          	ld	a0,352(s5)
    800022c6:	00002097          	auipc	ra,0x2
    800022ca:	a34080e7          	jalr	-1484(ra) # 80003cfa <idup>
    800022ce:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800022d2:	4641                	li	a2,16
    800022d4:	180a8593          	addi	a1,s5,384
    800022d8:	18098513          	addi	a0,s3,384
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	bac080e7          	jalr	-1108(ra) # 80000e88 <safestrcpy>
  pid = np->pid;
    800022e4:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800022e8:	854e                	mv	a0,s3
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	a04080e7          	jalr	-1532(ra) # 80000cee <release>
  acquire(&wait_lock);
    800022f2:	0000f497          	auipc	s1,0xf
    800022f6:	fc648493          	addi	s1,s1,-58 # 800112b8 <wait_lock>
    800022fa:	8526                	mv	a0,s1
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	93e080e7          	jalr	-1730(ra) # 80000c3a <acquire>
  np->parent = p;
    80002304:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	9e4080e7          	jalr	-1564(ra) # 80000cee <release>
  acquire(&np->lock);
    80002312:	854e                	mv	a0,s3
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	926080e7          	jalr	-1754(ra) # 80000c3a <acquire>
  np->state = RUNNABLE;
    8000231c:	478d                	li	a5,3
    8000231e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002322:	854e                	mv	a0,s3
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	9ca080e7          	jalr	-1590(ra) # 80000cee <release>
}
    8000232c:	854a                	mv	a0,s2
    8000232e:	70e2                	ld	ra,56(sp)
    80002330:	7442                	ld	s0,48(sp)
    80002332:	74a2                	ld	s1,40(sp)
    80002334:	7902                	ld	s2,32(sp)
    80002336:	69e2                	ld	s3,24(sp)
    80002338:	6a42                	ld	s4,16(sp)
    8000233a:	6aa2                	ld	s5,8(sp)
    8000233c:	6121                	addi	sp,sp,64
    8000233e:	8082                	ret
    return -1;
    80002340:	597d                	li	s2,-1
    80002342:	b7ed                	j	8000232c <fork+0x168>

0000000080002344 <scheduler>:
void scheduler(void) {
    80002344:	715d                	addi	sp,sp,-80
    80002346:	e486                	sd	ra,72(sp)
    80002348:	e0a2                	sd	s0,64(sp)
    8000234a:	fc26                	sd	s1,56(sp)
    8000234c:	f84a                	sd	s2,48(sp)
    8000234e:	f44e                	sd	s3,40(sp)
    80002350:	f052                	sd	s4,32(sp)
    80002352:	ec56                	sd	s5,24(sp)
    80002354:	e85a                	sd	s6,16(sp)
    80002356:	e45e                	sd	s7,8(sp)
    80002358:	e062                	sd	s8,0(sp)
    8000235a:	0880                	addi	s0,sp,80
    8000235c:	8792                	mv	a5,tp
  int id = r_tp();
    8000235e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002360:	00779c13          	slli	s8,a5,0x7
    80002364:	0000f717          	auipc	a4,0xf
    80002368:	f3c70713          	addi	a4,a4,-196 # 800112a0 <pid_lock>
    8000236c:	9762                	add	a4,a4,s8
    8000236e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002372:	0000f717          	auipc	a4,0xf
    80002376:	f6670713          	addi	a4,a4,-154 # 800112d8 <cpus+0x8>
    8000237a:	9c3a                	add	s8,s8,a4
        w_satp(MAKE_SATP(kernel_pagetable));
    8000237c:	00007b17          	auipc	s6,0x7
    80002380:	ca4b0b13          	addi	s6,s6,-860 # 80009020 <kernel_pagetable>
    80002384:	5afd                	li	s5,-1
    80002386:	1afe                	slli	s5,s5,0x3f
        c->proc = p;
    80002388:	079e                	slli	a5,a5,0x7
    8000238a:	0000fb97          	auipc	s7,0xf
    8000238e:	f16b8b93          	addi	s7,s7,-234 # 800112a0 <pid_lock>
    80002392:	9bbe                	add	s7,s7,a5
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002394:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000239c:	10079073          	csrw	sstatus,a5
    int found = 0;
    800023a0:	4a01                	li	s4,0
    for (p = proc; p < &proc[NPROC]; p++) {
    800023a2:	0000f497          	auipc	s1,0xf
    800023a6:	32e48493          	addi	s1,s1,814 # 800116d0 <proc>
      if (p->state == RUNNABLE) {
    800023aa:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    800023ac:	00015917          	auipc	s2,0x15
    800023b0:	72490913          	addi	s2,s2,1828 # 80017ad0 <tickslock>
    800023b4:	a085                	j	80002414 <scheduler+0xd0>
        p->state = RUNNING;
    800023b6:	4791                	li	a5,4
    800023b8:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    800023ba:	029bb823          	sd	s1,48(s7)
        w_satp(MAKE_SATP(p->k_pagetable));
    800023be:	70bc                	ld	a5,96(s1)
    800023c0:	83b1                	srli	a5,a5,0xc
    800023c2:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    800023c6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800023ca:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    800023ce:	07048593          	addi	a1,s1,112
    800023d2:	8562                	mv	a0,s8
    800023d4:	00000097          	auipc	ra,0x0
    800023d8:	670080e7          	jalr	1648(ra) # 80002a44 <swtch>
        c->proc = 0;
    800023dc:	020bb823          	sd	zero,48(s7)
      release(&p->lock);
    800023e0:	8526                	mv	a0,s1
    800023e2:	fffff097          	auipc	ra,0xfffff
    800023e6:	90c080e7          	jalr	-1780(ra) # 80000cee <release>
        found = 1;
    800023ea:	4a05                	li	s4,1
    800023ec:	a005                	j	8000240c <scheduler+0xc8>
        w_satp(MAKE_SATP(kernel_pagetable));
    800023ee:	000b3783          	ld	a5,0(s6)
    800023f2:	83b1                	srli	a5,a5,0xc
    800023f4:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    800023f8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800023fc:	12000073          	sfence.vma
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002400:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002404:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002408:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    8000240c:	19048493          	addi	s1,s1,400
    80002410:	f92482e3          	beq	s1,s2,80002394 <scheduler+0x50>
      acquire(&p->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	824080e7          	jalr	-2012(ra) # 80000c3a <acquire>
      if (p->state == RUNNABLE) {
    8000241e:	4c9c                	lw	a5,24(s1)
    80002420:	f9378be3          	beq	a5,s3,800023b6 <scheduler+0x72>
      release(&p->lock);
    80002424:	8526                	mv	a0,s1
    80002426:	fffff097          	auipc	ra,0xfffff
    8000242a:	8c8080e7          	jalr	-1848(ra) # 80000cee <release>
      if (!found) {
    8000242e:	fc0a00e3          	beqz	s4,800023ee <scheduler+0xaa>
    80002432:	bfe9                	j	8000240c <scheduler+0xc8>

0000000080002434 <sched>:
void sched(void) {
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002442:	00000097          	auipc	ra,0x0
    80002446:	852080e7          	jalr	-1966(ra) # 80001c94 <myproc>
    8000244a:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000244c:	ffffe097          	auipc	ra,0xffffe
    80002450:	774080e7          	jalr	1908(ra) # 80000bc0 <holding>
    80002454:	c93d                	beqz	a0,800024ca <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80002456:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002458:	2781                	sext.w	a5,a5
    8000245a:	079e                	slli	a5,a5,0x7
    8000245c:	0000f717          	auipc	a4,0xf
    80002460:	e4470713          	addi	a4,a4,-444 # 800112a0 <pid_lock>
    80002464:	97ba                	add	a5,a5,a4
    80002466:	0a87a703          	lw	a4,168(a5)
    8000246a:	4785                	li	a5,1
    8000246c:	06f71763          	bne	a4,a5,800024da <sched+0xa6>
  if (p->state == RUNNING)
    80002470:	4c98                	lw	a4,24(s1)
    80002472:	4791                	li	a5,4
    80002474:	06f70b63          	beq	a4,a5,800024ea <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002478:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000247c:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000247e:	efb5                	bnez	a5,800024fa <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80002480:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002482:	0000f917          	auipc	s2,0xf
    80002486:	e1e90913          	addi	s2,s2,-482 # 800112a0 <pid_lock>
    8000248a:	2781                	sext.w	a5,a5
    8000248c:	079e                	slli	a5,a5,0x7
    8000248e:	97ca                	add	a5,a5,s2
    80002490:	0ac7a983          	lw	s3,172(a5)
    80002494:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002496:	2781                	sext.w	a5,a5
    80002498:	079e                	slli	a5,a5,0x7
    8000249a:	0000f597          	auipc	a1,0xf
    8000249e:	e3e58593          	addi	a1,a1,-450 # 800112d8 <cpus+0x8>
    800024a2:	95be                	add	a1,a1,a5
    800024a4:	07048513          	addi	a0,s1,112
    800024a8:	00000097          	auipc	ra,0x0
    800024ac:	59c080e7          	jalr	1436(ra) # 80002a44 <swtch>
    800024b0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800024b2:	2781                	sext.w	a5,a5
    800024b4:	079e                	slli	a5,a5,0x7
    800024b6:	97ca                	add	a5,a5,s2
    800024b8:	0b37a623          	sw	s3,172(a5)
}
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6145                	addi	sp,sp,48
    800024c8:	8082                	ret
    panic("sched p->lock");
    800024ca:	00006517          	auipc	a0,0x6
    800024ce:	da650513          	addi	a0,a0,-602 # 80008270 <digits+0x208>
    800024d2:	ffffe097          	auipc	ra,0xffffe
    800024d6:	0fa080e7          	jalr	250(ra) # 800005cc <panic>
    panic("sched locks");
    800024da:	00006517          	auipc	a0,0x6
    800024de:	da650513          	addi	a0,a0,-602 # 80008280 <digits+0x218>
    800024e2:	ffffe097          	auipc	ra,0xffffe
    800024e6:	0ea080e7          	jalr	234(ra) # 800005cc <panic>
    panic("sched running");
    800024ea:	00006517          	auipc	a0,0x6
    800024ee:	da650513          	addi	a0,a0,-602 # 80008290 <digits+0x228>
    800024f2:	ffffe097          	auipc	ra,0xffffe
    800024f6:	0da080e7          	jalr	218(ra) # 800005cc <panic>
    panic("sched interruptible");
    800024fa:	00006517          	auipc	a0,0x6
    800024fe:	da650513          	addi	a0,a0,-602 # 800082a0 <digits+0x238>
    80002502:	ffffe097          	auipc	ra,0xffffe
    80002506:	0ca080e7          	jalr	202(ra) # 800005cc <panic>

000000008000250a <yield>:
void yield(void) {
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002514:	fffff097          	auipc	ra,0xfffff
    80002518:	780080e7          	jalr	1920(ra) # 80001c94 <myproc>
    8000251c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000251e:	ffffe097          	auipc	ra,0xffffe
    80002522:	71c080e7          	jalr	1820(ra) # 80000c3a <acquire>
  p->state = RUNNABLE;
    80002526:	478d                	li	a5,3
    80002528:	cc9c                	sw	a5,24(s1)
  sched();
    8000252a:	00000097          	auipc	ra,0x0
    8000252e:	f0a080e7          	jalr	-246(ra) # 80002434 <sched>
  release(&p->lock);
    80002532:	8526                	mv	a0,s1
    80002534:	ffffe097          	auipc	ra,0xffffe
    80002538:	7ba080e7          	jalr	1978(ra) # 80000cee <release>
}
    8000253c:	60e2                	ld	ra,24(sp)
    8000253e:	6442                	ld	s0,16(sp)
    80002540:	64a2                	ld	s1,8(sp)
    80002542:	6105                	addi	sp,sp,32
    80002544:	8082                	ret

0000000080002546 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	1800                	addi	s0,sp,48
    80002554:	89aa                	mv	s3,a0
    80002556:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002558:	fffff097          	auipc	ra,0xfffff
    8000255c:	73c080e7          	jalr	1852(ra) # 80001c94 <myproc>
    80002560:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002562:	ffffe097          	auipc	ra,0xffffe
    80002566:	6d8080e7          	jalr	1752(ra) # 80000c3a <acquire>
  release(lk);
    8000256a:	854a                	mv	a0,s2
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	782080e7          	jalr	1922(ra) # 80000cee <release>

  // Go to sleep.
  p->chan = chan;
    80002574:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002578:	4789                	li	a5,2
    8000257a:	cc9c                	sw	a5,24(s1)

  sched();
    8000257c:	00000097          	auipc	ra,0x0
    80002580:	eb8080e7          	jalr	-328(ra) # 80002434 <sched>

  // Tidy up.
  p->chan = 0;
    80002584:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002588:	8526                	mv	a0,s1
    8000258a:	ffffe097          	auipc	ra,0xffffe
    8000258e:	764080e7          	jalr	1892(ra) # 80000cee <release>
  acquire(lk);
    80002592:	854a                	mv	a0,s2
    80002594:	ffffe097          	auipc	ra,0xffffe
    80002598:	6a6080e7          	jalr	1702(ra) # 80000c3a <acquire>
}
    8000259c:	70a2                	ld	ra,40(sp)
    8000259e:	7402                	ld	s0,32(sp)
    800025a0:	64e2                	ld	s1,24(sp)
    800025a2:	6942                	ld	s2,16(sp)
    800025a4:	69a2                	ld	s3,8(sp)
    800025a6:	6145                	addi	sp,sp,48
    800025a8:	8082                	ret

00000000800025aa <wait>:
int wait(uint64 addr) {
    800025aa:	715d                	addi	sp,sp,-80
    800025ac:	e486                	sd	ra,72(sp)
    800025ae:	e0a2                	sd	s0,64(sp)
    800025b0:	fc26                	sd	s1,56(sp)
    800025b2:	f84a                	sd	s2,48(sp)
    800025b4:	f44e                	sd	s3,40(sp)
    800025b6:	f052                	sd	s4,32(sp)
    800025b8:	ec56                	sd	s5,24(sp)
    800025ba:	e85a                	sd	s6,16(sp)
    800025bc:	e45e                	sd	s7,8(sp)
    800025be:	e062                	sd	s8,0(sp)
    800025c0:	0880                	addi	s0,sp,80
    800025c2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800025c4:	fffff097          	auipc	ra,0xfffff
    800025c8:	6d0080e7          	jalr	1744(ra) # 80001c94 <myproc>
    800025cc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800025ce:	0000f517          	auipc	a0,0xf
    800025d2:	cea50513          	addi	a0,a0,-790 # 800112b8 <wait_lock>
    800025d6:	ffffe097          	auipc	ra,0xffffe
    800025da:	664080e7          	jalr	1636(ra) # 80000c3a <acquire>
    havekids = 0;
    800025de:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    800025e0:	4a15                	li	s4,5
        havekids = 1;
    800025e2:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    800025e4:	00015997          	auipc	s3,0x15
    800025e8:	4ec98993          	addi	s3,s3,1260 # 80017ad0 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800025ec:	0000fc17          	auipc	s8,0xf
    800025f0:	cccc0c13          	addi	s8,s8,-820 # 800112b8 <wait_lock>
    havekids = 0;
    800025f4:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    800025f6:	0000f497          	auipc	s1,0xf
    800025fa:	0da48493          	addi	s1,s1,218 # 800116d0 <proc>
    800025fe:	a0bd                	j	8000266c <wait+0xc2>
          pid = np->pid;
    80002600:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002604:	000b0e63          	beqz	s6,80002620 <wait+0x76>
    80002608:	4691                	li	a3,4
    8000260a:	02c48613          	addi	a2,s1,44
    8000260e:	85da                	mv	a1,s6
    80002610:	05893503          	ld	a0,88(s2)
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	270080e7          	jalr	624(ra) # 80001884 <copyout>
    8000261c:	02054563          	bltz	a0,80002646 <wait+0x9c>
          freeproc(np);
    80002620:	8526                	mv	a0,s1
    80002622:	00000097          	auipc	ra,0x0
    80002626:	824080e7          	jalr	-2012(ra) # 80001e46 <freeproc>
          release(&np->lock);
    8000262a:	8526                	mv	a0,s1
    8000262c:	ffffe097          	auipc	ra,0xffffe
    80002630:	6c2080e7          	jalr	1730(ra) # 80000cee <release>
          release(&wait_lock);
    80002634:	0000f517          	auipc	a0,0xf
    80002638:	c8450513          	addi	a0,a0,-892 # 800112b8 <wait_lock>
    8000263c:	ffffe097          	auipc	ra,0xffffe
    80002640:	6b2080e7          	jalr	1714(ra) # 80000cee <release>
          return pid;
    80002644:	a09d                	j	800026aa <wait+0x100>
            release(&np->lock);
    80002646:	8526                	mv	a0,s1
    80002648:	ffffe097          	auipc	ra,0xffffe
    8000264c:	6a6080e7          	jalr	1702(ra) # 80000cee <release>
            release(&wait_lock);
    80002650:	0000f517          	auipc	a0,0xf
    80002654:	c6850513          	addi	a0,a0,-920 # 800112b8 <wait_lock>
    80002658:	ffffe097          	auipc	ra,0xffffe
    8000265c:	696080e7          	jalr	1686(ra) # 80000cee <release>
            return -1;
    80002660:	59fd                	li	s3,-1
    80002662:	a0a1                	j	800026aa <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++) {
    80002664:	19048493          	addi	s1,s1,400
    80002668:	03348463          	beq	s1,s3,80002690 <wait+0xe6>
      if (np->parent == p) {
    8000266c:	7c9c                	ld	a5,56(s1)
    8000266e:	ff279be3          	bne	a5,s2,80002664 <wait+0xba>
        acquire(&np->lock);
    80002672:	8526                	mv	a0,s1
    80002674:	ffffe097          	auipc	ra,0xffffe
    80002678:	5c6080e7          	jalr	1478(ra) # 80000c3a <acquire>
        if (np->state == ZOMBIE) {
    8000267c:	4c9c                	lw	a5,24(s1)
    8000267e:	f94781e3          	beq	a5,s4,80002600 <wait+0x56>
        release(&np->lock);
    80002682:	8526                	mv	a0,s1
    80002684:	ffffe097          	auipc	ra,0xffffe
    80002688:	66a080e7          	jalr	1642(ra) # 80000cee <release>
        havekids = 1;
    8000268c:	8756                	mv	a4,s5
    8000268e:	bfd9                	j	80002664 <wait+0xba>
    if (!havekids || p->killed) {
    80002690:	c701                	beqz	a4,80002698 <wait+0xee>
    80002692:	02892783          	lw	a5,40(s2)
    80002696:	c79d                	beqz	a5,800026c4 <wait+0x11a>
      release(&wait_lock);
    80002698:	0000f517          	auipc	a0,0xf
    8000269c:	c2050513          	addi	a0,a0,-992 # 800112b8 <wait_lock>
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	64e080e7          	jalr	1614(ra) # 80000cee <release>
      return -1;
    800026a8:	59fd                	li	s3,-1
}
    800026aa:	854e                	mv	a0,s3
    800026ac:	60a6                	ld	ra,72(sp)
    800026ae:	6406                	ld	s0,64(sp)
    800026b0:	74e2                	ld	s1,56(sp)
    800026b2:	7942                	ld	s2,48(sp)
    800026b4:	79a2                	ld	s3,40(sp)
    800026b6:	7a02                	ld	s4,32(sp)
    800026b8:	6ae2                	ld	s5,24(sp)
    800026ba:	6b42                	ld	s6,16(sp)
    800026bc:	6ba2                	ld	s7,8(sp)
    800026be:	6c02                	ld	s8,0(sp)
    800026c0:	6161                	addi	sp,sp,80
    800026c2:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800026c4:	85e2                	mv	a1,s8
    800026c6:	854a                	mv	a0,s2
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	e7e080e7          	jalr	-386(ra) # 80002546 <sleep>
    havekids = 0;
    800026d0:	b715                	j	800025f4 <wait+0x4a>

00000000800026d2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    800026d2:	7139                	addi	sp,sp,-64
    800026d4:	fc06                	sd	ra,56(sp)
    800026d6:	f822                	sd	s0,48(sp)
    800026d8:	f426                	sd	s1,40(sp)
    800026da:	f04a                	sd	s2,32(sp)
    800026dc:	ec4e                	sd	s3,24(sp)
    800026de:	e852                	sd	s4,16(sp)
    800026e0:	e456                	sd	s5,8(sp)
    800026e2:	0080                	addi	s0,sp,64
    800026e4:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800026e6:	0000f497          	auipc	s1,0xf
    800026ea:	fea48493          	addi	s1,s1,-22 # 800116d0 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    800026ee:	4989                	li	s3,2
        p->state = RUNNABLE;
    800026f0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800026f2:	00015917          	auipc	s2,0x15
    800026f6:	3de90913          	addi	s2,s2,990 # 80017ad0 <tickslock>
    800026fa:	a811                	j	8000270e <wakeup+0x3c>
      }
      release(&p->lock);
    800026fc:	8526                	mv	a0,s1
    800026fe:	ffffe097          	auipc	ra,0xffffe
    80002702:	5f0080e7          	jalr	1520(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002706:	19048493          	addi	s1,s1,400
    8000270a:	03248663          	beq	s1,s2,80002736 <wakeup+0x64>
    if (p != myproc()) {
    8000270e:	fffff097          	auipc	ra,0xfffff
    80002712:	586080e7          	jalr	1414(ra) # 80001c94 <myproc>
    80002716:	fea488e3          	beq	s1,a0,80002706 <wakeup+0x34>
      acquire(&p->lock);
    8000271a:	8526                	mv	a0,s1
    8000271c:	ffffe097          	auipc	ra,0xffffe
    80002720:	51e080e7          	jalr	1310(ra) # 80000c3a <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80002724:	4c9c                	lw	a5,24(s1)
    80002726:	fd379be3          	bne	a5,s3,800026fc <wakeup+0x2a>
    8000272a:	709c                	ld	a5,32(s1)
    8000272c:	fd4798e3          	bne	a5,s4,800026fc <wakeup+0x2a>
        p->state = RUNNABLE;
    80002730:	0154ac23          	sw	s5,24(s1)
    80002734:	b7e1                	j	800026fc <wakeup+0x2a>
    }
  }
}
    80002736:	70e2                	ld	ra,56(sp)
    80002738:	7442                	ld	s0,48(sp)
    8000273a:	74a2                	ld	s1,40(sp)
    8000273c:	7902                	ld	s2,32(sp)
    8000273e:	69e2                	ld	s3,24(sp)
    80002740:	6a42                	ld	s4,16(sp)
    80002742:	6aa2                	ld	s5,8(sp)
    80002744:	6121                	addi	sp,sp,64
    80002746:	8082                	ret

0000000080002748 <reparent>:
void reparent(struct proc *p) {
    80002748:	7179                	addi	sp,sp,-48
    8000274a:	f406                	sd	ra,40(sp)
    8000274c:	f022                	sd	s0,32(sp)
    8000274e:	ec26                	sd	s1,24(sp)
    80002750:	e84a                	sd	s2,16(sp)
    80002752:	e44e                	sd	s3,8(sp)
    80002754:	e052                	sd	s4,0(sp)
    80002756:	1800                	addi	s0,sp,48
    80002758:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000275a:	0000f497          	auipc	s1,0xf
    8000275e:	f7648493          	addi	s1,s1,-138 # 800116d0 <proc>
      pp->parent = initproc;
    80002762:	00007a17          	auipc	s4,0x7
    80002766:	8c6a0a13          	addi	s4,s4,-1850 # 80009028 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000276a:	00015997          	auipc	s3,0x15
    8000276e:	36698993          	addi	s3,s3,870 # 80017ad0 <tickslock>
    80002772:	a029                	j	8000277c <reparent+0x34>
    80002774:	19048493          	addi	s1,s1,400
    80002778:	01348d63          	beq	s1,s3,80002792 <reparent+0x4a>
    if (pp->parent == p) {
    8000277c:	7c9c                	ld	a5,56(s1)
    8000277e:	ff279be3          	bne	a5,s2,80002774 <reparent+0x2c>
      pp->parent = initproc;
    80002782:	000a3503          	ld	a0,0(s4)
    80002786:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	f4a080e7          	jalr	-182(ra) # 800026d2 <wakeup>
    80002790:	b7d5                	j	80002774 <reparent+0x2c>
}
    80002792:	70a2                	ld	ra,40(sp)
    80002794:	7402                	ld	s0,32(sp)
    80002796:	64e2                	ld	s1,24(sp)
    80002798:	6942                	ld	s2,16(sp)
    8000279a:	69a2                	ld	s3,8(sp)
    8000279c:	6a02                	ld	s4,0(sp)
    8000279e:	6145                	addi	sp,sp,48
    800027a0:	8082                	ret

00000000800027a2 <exit>:
void exit(int status) {
    800027a2:	7179                	addi	sp,sp,-48
    800027a4:	f406                	sd	ra,40(sp)
    800027a6:	f022                	sd	s0,32(sp)
    800027a8:	ec26                	sd	s1,24(sp)
    800027aa:	e84a                	sd	s2,16(sp)
    800027ac:	e44e                	sd	s3,8(sp)
    800027ae:	e052                	sd	s4,0(sp)
    800027b0:	1800                	addi	s0,sp,48
    800027b2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800027b4:	fffff097          	auipc	ra,0xfffff
    800027b8:	4e0080e7          	jalr	1248(ra) # 80001c94 <myproc>
    800027bc:	89aa                	mv	s3,a0
  if (p == initproc)
    800027be:	00007797          	auipc	a5,0x7
    800027c2:	86a7b783          	ld	a5,-1942(a5) # 80009028 <initproc>
    800027c6:	0e050493          	addi	s1,a0,224
    800027ca:	16050913          	addi	s2,a0,352
    800027ce:	02a79363          	bne	a5,a0,800027f4 <exit+0x52>
    panic("init exiting");
    800027d2:	00006517          	auipc	a0,0x6
    800027d6:	ae650513          	addi	a0,a0,-1306 # 800082b8 <digits+0x250>
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	df2080e7          	jalr	-526(ra) # 800005cc <panic>
      fileclose(f);
    800027e2:	00002097          	auipc	ra,0x2
    800027e6:	3f4080e7          	jalr	1012(ra) # 80004bd6 <fileclose>
      p->ofile[fd] = 0;
    800027ea:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800027ee:	04a1                	addi	s1,s1,8
    800027f0:	01248563          	beq	s1,s2,800027fa <exit+0x58>
    if (p->ofile[fd]) {
    800027f4:	6088                	ld	a0,0(s1)
    800027f6:	f575                	bnez	a0,800027e2 <exit+0x40>
    800027f8:	bfdd                	j	800027ee <exit+0x4c>
  begin_op();
    800027fa:	00002097          	auipc	ra,0x2
    800027fe:	f10080e7          	jalr	-240(ra) # 8000470a <begin_op>
  iput(p->cwd);
    80002802:	1609b503          	ld	a0,352(s3)
    80002806:	00001097          	auipc	ra,0x1
    8000280a:	6ec080e7          	jalr	1772(ra) # 80003ef2 <iput>
  end_op();
    8000280e:	00002097          	auipc	ra,0x2
    80002812:	f7c080e7          	jalr	-132(ra) # 8000478a <end_op>
  p->cwd = 0;
    80002816:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    8000281a:	0000f497          	auipc	s1,0xf
    8000281e:	a9e48493          	addi	s1,s1,-1378 # 800112b8 <wait_lock>
    80002822:	8526                	mv	a0,s1
    80002824:	ffffe097          	auipc	ra,0xffffe
    80002828:	416080e7          	jalr	1046(ra) # 80000c3a <acquire>
  reparent(p);
    8000282c:	854e                	mv	a0,s3
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	f1a080e7          	jalr	-230(ra) # 80002748 <reparent>
  wakeup(p->parent);
    80002836:	0389b503          	ld	a0,56(s3)
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e98080e7          	jalr	-360(ra) # 800026d2 <wakeup>
  acquire(&p->lock);
    80002842:	854e                	mv	a0,s3
    80002844:	ffffe097          	auipc	ra,0xffffe
    80002848:	3f6080e7          	jalr	1014(ra) # 80000c3a <acquire>
  p->xstate = status;
    8000284c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002850:	4795                	li	a5,5
    80002852:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002856:	8526                	mv	a0,s1
    80002858:	ffffe097          	auipc	ra,0xffffe
    8000285c:	496080e7          	jalr	1174(ra) # 80000cee <release>
  sched();
    80002860:	00000097          	auipc	ra,0x0
    80002864:	bd4080e7          	jalr	-1068(ra) # 80002434 <sched>
  panic("zombie exit");
    80002868:	00006517          	auipc	a0,0x6
    8000286c:	a6050513          	addi	a0,a0,-1440 # 800082c8 <digits+0x260>
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	d5c080e7          	jalr	-676(ra) # 800005cc <panic>

0000000080002878 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80002878:	7179                	addi	sp,sp,-48
    8000287a:	f406                	sd	ra,40(sp)
    8000287c:	f022                	sd	s0,32(sp)
    8000287e:	ec26                	sd	s1,24(sp)
    80002880:	e84a                	sd	s2,16(sp)
    80002882:	e44e                	sd	s3,8(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002888:	0000f497          	auipc	s1,0xf
    8000288c:	e4848493          	addi	s1,s1,-440 # 800116d0 <proc>
    80002890:	00015997          	auipc	s3,0x15
    80002894:	24098993          	addi	s3,s3,576 # 80017ad0 <tickslock>
    acquire(&p->lock);
    80002898:	8526                	mv	a0,s1
    8000289a:	ffffe097          	auipc	ra,0xffffe
    8000289e:	3a0080e7          	jalr	928(ra) # 80000c3a <acquire>
    if (p->pid == pid) {
    800028a2:	589c                	lw	a5,48(s1)
    800028a4:	01278d63          	beq	a5,s2,800028be <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800028a8:	8526                	mv	a0,s1
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	444080e7          	jalr	1092(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800028b2:	19048493          	addi	s1,s1,400
    800028b6:	ff3491e3          	bne	s1,s3,80002898 <kill+0x20>
  }
  return -1;
    800028ba:	557d                	li	a0,-1
    800028bc:	a829                	j	800028d6 <kill+0x5e>
      p->killed = 1;
    800028be:	4785                	li	a5,1
    800028c0:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800028c2:	4c98                	lw	a4,24(s1)
    800028c4:	4789                	li	a5,2
    800028c6:	00f70f63          	beq	a4,a5,800028e4 <kill+0x6c>
      release(&p->lock);
    800028ca:	8526                	mv	a0,s1
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	422080e7          	jalr	1058(ra) # 80000cee <release>
      return 0;
    800028d4:	4501                	li	a0,0
}
    800028d6:	70a2                	ld	ra,40(sp)
    800028d8:	7402                	ld	s0,32(sp)
    800028da:	64e2                	ld	s1,24(sp)
    800028dc:	6942                	ld	s2,16(sp)
    800028de:	69a2                	ld	s3,8(sp)
    800028e0:	6145                	addi	sp,sp,48
    800028e2:	8082                	ret
        p->state = RUNNABLE;
    800028e4:	478d                	li	a5,3
    800028e6:	cc9c                	sw	a5,24(s1)
    800028e8:	b7cd                	j	800028ca <kill+0x52>

00000000800028ea <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800028ea:	7179                	addi	sp,sp,-48
    800028ec:	f406                	sd	ra,40(sp)
    800028ee:	f022                	sd	s0,32(sp)
    800028f0:	ec26                	sd	s1,24(sp)
    800028f2:	e84a                	sd	s2,16(sp)
    800028f4:	e44e                	sd	s3,8(sp)
    800028f6:	e052                	sd	s4,0(sp)
    800028f8:	1800                	addi	s0,sp,48
    800028fa:	84aa                	mv	s1,a0
    800028fc:	892e                	mv	s2,a1
    800028fe:	89b2                	mv	s3,a2
    80002900:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002902:	fffff097          	auipc	ra,0xfffff
    80002906:	392080e7          	jalr	914(ra) # 80001c94 <myproc>
  if (user_dst) {
    8000290a:	c08d                	beqz	s1,8000292c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000290c:	86d2                	mv	a3,s4
    8000290e:	864e                	mv	a2,s3
    80002910:	85ca                	mv	a1,s2
    80002912:	6d28                	ld	a0,88(a0)
    80002914:	fffff097          	auipc	ra,0xfffff
    80002918:	f70080e7          	jalr	-144(ra) # 80001884 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000291c:	70a2                	ld	ra,40(sp)
    8000291e:	7402                	ld	s0,32(sp)
    80002920:	64e2                	ld	s1,24(sp)
    80002922:	6942                	ld	s2,16(sp)
    80002924:	69a2                	ld	s3,8(sp)
    80002926:	6a02                	ld	s4,0(sp)
    80002928:	6145                	addi	sp,sp,48
    8000292a:	8082                	ret
    memmove((char *)dst, src, len);
    8000292c:	000a061b          	sext.w	a2,s4
    80002930:	85ce                	mv	a1,s3
    80002932:	854a                	mv	a0,s2
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	45e080e7          	jalr	1118(ra) # 80000d92 <memmove>
    return 0;
    8000293c:	8526                	mv	a0,s1
    8000293e:	bff9                	j	8000291c <either_copyout+0x32>

0000000080002940 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80002940:	7179                	addi	sp,sp,-48
    80002942:	f406                	sd	ra,40(sp)
    80002944:	f022                	sd	s0,32(sp)
    80002946:	ec26                	sd	s1,24(sp)
    80002948:	e84a                	sd	s2,16(sp)
    8000294a:	e44e                	sd	s3,8(sp)
    8000294c:	e052                	sd	s4,0(sp)
    8000294e:	1800                	addi	s0,sp,48
    80002950:	892a                	mv	s2,a0
    80002952:	84ae                	mv	s1,a1
    80002954:	89b2                	mv	s3,a2
    80002956:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002958:	fffff097          	auipc	ra,0xfffff
    8000295c:	33c080e7          	jalr	828(ra) # 80001c94 <myproc>
  if (user_src) {
    80002960:	c08d                	beqz	s1,80002982 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002962:	86d2                	mv	a3,s4
    80002964:	864e                	mv	a2,s3
    80002966:	85ca                	mv	a1,s2
    80002968:	6d28                	ld	a0,88(a0)
    8000296a:	fffff097          	auipc	ra,0xfffff
    8000296e:	020080e7          	jalr	32(ra) # 8000198a <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002972:	70a2                	ld	ra,40(sp)
    80002974:	7402                	ld	s0,32(sp)
    80002976:	64e2                	ld	s1,24(sp)
    80002978:	6942                	ld	s2,16(sp)
    8000297a:	69a2                	ld	s3,8(sp)
    8000297c:	6a02                	ld	s4,0(sp)
    8000297e:	6145                	addi	sp,sp,48
    80002980:	8082                	ret
    memmove(dst, (char *)src, len);
    80002982:	000a061b          	sext.w	a2,s4
    80002986:	85ce                	mv	a1,s3
    80002988:	854a                	mv	a0,s2
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	408080e7          	jalr	1032(ra) # 80000d92 <memmove>
    return 0;
    80002992:	8526                	mv	a0,s1
    80002994:	bff9                	j	80002972 <either_copyin+0x32>

0000000080002996 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80002996:	715d                	addi	sp,sp,-80
    80002998:	e486                	sd	ra,72(sp)
    8000299a:	e0a2                	sd	s0,64(sp)
    8000299c:	fc26                	sd	s1,56(sp)
    8000299e:	f84a                	sd	s2,48(sp)
    800029a0:	f44e                	sd	s3,40(sp)
    800029a2:	f052                	sd	s4,32(sp)
    800029a4:	ec56                	sd	s5,24(sp)
    800029a6:	e85a                	sd	s6,16(sp)
    800029a8:	e45e                	sd	s7,8(sp)
    800029aa:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800029ac:	00005517          	auipc	a0,0x5
    800029b0:	74450513          	addi	a0,a0,1860 # 800080f0 <digits+0x88>
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	c6a080e7          	jalr	-918(ra) # 8000061e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029bc:	0000f497          	auipc	s1,0xf
    800029c0:	e9448493          	addi	s1,s1,-364 # 80011850 <proc+0x180>
    800029c4:	00015917          	auipc	s2,0x15
    800029c8:	28c90913          	addi	s2,s2,652 # 80017c50 <bcache+0x48>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029cc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800029ce:	00006997          	auipc	s3,0x6
    800029d2:	90a98993          	addi	s3,s3,-1782 # 800082d8 <digits+0x270>
    printf("%d %s %s", p->pid, state, p->name);
    800029d6:	00006a97          	auipc	s5,0x6
    800029da:	90aa8a93          	addi	s5,s5,-1782 # 800082e0 <digits+0x278>
    printf("\n");
    800029de:	00005a17          	auipc	s4,0x5
    800029e2:	712a0a13          	addi	s4,s4,1810 # 800080f0 <digits+0x88>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029e6:	00006b97          	auipc	s7,0x6
    800029ea:	932b8b93          	addi	s7,s7,-1742 # 80008318 <states.0>
    800029ee:	a00d                	j	80002a10 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800029f0:	eb06a583          	lw	a1,-336(a3)
    800029f4:	8556                	mv	a0,s5
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	c28080e7          	jalr	-984(ra) # 8000061e <printf>
    printf("\n");
    800029fe:	8552                	mv	a0,s4
    80002a00:	ffffe097          	auipc	ra,0xffffe
    80002a04:	c1e080e7          	jalr	-994(ra) # 8000061e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002a08:	19048493          	addi	s1,s1,400
    80002a0c:	03248163          	beq	s1,s2,80002a2e <procdump+0x98>
    if (p->state == UNUSED)
    80002a10:	86a6                	mv	a3,s1
    80002a12:	e984a783          	lw	a5,-360(s1)
    80002a16:	dbed                	beqz	a5,80002a08 <procdump+0x72>
      state = "???";
    80002a18:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a1a:	fcfb6be3          	bltu	s6,a5,800029f0 <procdump+0x5a>
    80002a1e:	1782                	slli	a5,a5,0x20
    80002a20:	9381                	srli	a5,a5,0x20
    80002a22:	078e                	slli	a5,a5,0x3
    80002a24:	97de                	add	a5,a5,s7
    80002a26:	6390                	ld	a2,0(a5)
    80002a28:	f661                	bnez	a2,800029f0 <procdump+0x5a>
      state = "???";
    80002a2a:	864e                	mv	a2,s3
    80002a2c:	b7d1                	j	800029f0 <procdump+0x5a>
  }
}
    80002a2e:	60a6                	ld	ra,72(sp)
    80002a30:	6406                	ld	s0,64(sp)
    80002a32:	74e2                	ld	s1,56(sp)
    80002a34:	7942                	ld	s2,48(sp)
    80002a36:	79a2                	ld	s3,40(sp)
    80002a38:	7a02                	ld	s4,32(sp)
    80002a3a:	6ae2                	ld	s5,24(sp)
    80002a3c:	6b42                	ld	s6,16(sp)
    80002a3e:	6ba2                	ld	s7,8(sp)
    80002a40:	6161                	addi	sp,sp,80
    80002a42:	8082                	ret

0000000080002a44 <swtch>:
    80002a44:	00153023          	sd	ra,0(a0)
    80002a48:	00253423          	sd	sp,8(a0)
    80002a4c:	e900                	sd	s0,16(a0)
    80002a4e:	ed04                	sd	s1,24(a0)
    80002a50:	03253023          	sd	s2,32(a0)
    80002a54:	03353423          	sd	s3,40(a0)
    80002a58:	03453823          	sd	s4,48(a0)
    80002a5c:	03553c23          	sd	s5,56(a0)
    80002a60:	05653023          	sd	s6,64(a0)
    80002a64:	05753423          	sd	s7,72(a0)
    80002a68:	05853823          	sd	s8,80(a0)
    80002a6c:	05953c23          	sd	s9,88(a0)
    80002a70:	07a53023          	sd	s10,96(a0)
    80002a74:	07b53423          	sd	s11,104(a0)
    80002a78:	0005b083          	ld	ra,0(a1)
    80002a7c:	0085b103          	ld	sp,8(a1)
    80002a80:	6980                	ld	s0,16(a1)
    80002a82:	6d84                	ld	s1,24(a1)
    80002a84:	0205b903          	ld	s2,32(a1)
    80002a88:	0285b983          	ld	s3,40(a1)
    80002a8c:	0305ba03          	ld	s4,48(a1)
    80002a90:	0385ba83          	ld	s5,56(a1)
    80002a94:	0405bb03          	ld	s6,64(a1)
    80002a98:	0485bb83          	ld	s7,72(a1)
    80002a9c:	0505bc03          	ld	s8,80(a1)
    80002aa0:	0585bc83          	ld	s9,88(a1)
    80002aa4:	0605bd03          	ld	s10,96(a1)
    80002aa8:	0685bd83          	ld	s11,104(a1)
    80002aac:	8082                	ret

0000000080002aae <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002aae:	1141                	addi	sp,sp,-16
    80002ab0:	e406                	sd	ra,8(sp)
    80002ab2:	e022                	sd	s0,0(sp)
    80002ab4:	0800                	addi	s0,sp,16
    80002ab6:	00006597          	auipc	a1,0x6
    80002aba:	89258593          	addi	a1,a1,-1902 # 80008348 <states.0+0x30>
    80002abe:	00015517          	auipc	a0,0x15
    80002ac2:	01250513          	addi	a0,a0,18 # 80017ad0 <tickslock>
    80002ac6:	ffffe097          	auipc	ra,0xffffe
    80002aca:	0e4080e7          	jalr	228(ra) # 80000baa <initlock>
    80002ace:	60a2                	ld	ra,8(sp)
    80002ad0:	6402                	ld	s0,0(sp)
    80002ad2:	0141                	addi	sp,sp,16
    80002ad4:	8082                	ret

0000000080002ad6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002ad6:	1141                	addi	sp,sp,-16
    80002ad8:	e422                	sd	s0,8(sp)
    80002ada:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002adc:	00003797          	auipc	a5,0x3
    80002ae0:	76478793          	addi	a5,a5,1892 # 80006240 <kernelvec>
    80002ae4:	10579073          	csrw	stvec,a5
    80002ae8:	6422                	ld	s0,8(sp)
    80002aea:	0141                	addi	sp,sp,16
    80002aec:	8082                	ret

0000000080002aee <info_reg>:
//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//

void info_reg() {
    80002aee:	1141                	addi	sp,sp,-16
    80002af0:	e406                	sd	ra,8(sp)
    80002af2:	e022                	sd	s0,0(sp)
    80002af4:	0800                	addi	s0,sp,16
  uint64 x;
  asm volatile("mv %0, ra" : "=r"(x));
    80002af6:	8586                	mv	a1,ra
  printf("ra:%p\n", x);
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	85850513          	addi	a0,a0,-1960 # 80008350 <states.0+0x38>
    80002b00:	ffffe097          	auipc	ra,0xffffe
    80002b04:	b1e080e7          	jalr	-1250(ra) # 8000061e <printf>
  asm volatile("mv %0, sp" : "=r"(x));
    80002b08:	858a                	mv	a1,sp
  printf("sp:%p\n", x);
    80002b0a:	00006517          	auipc	a0,0x6
    80002b0e:	84e50513          	addi	a0,a0,-1970 # 80008358 <states.0+0x40>
    80002b12:	ffffe097          	auipc	ra,0xffffe
    80002b16:	b0c080e7          	jalr	-1268(ra) # 8000061e <printf>
  asm volatile("mv %0, gp" : "=r"(x));
    80002b1a:	858e                	mv	a1,gp
  printf("gp:%p\n", x);
    80002b1c:	00006517          	auipc	a0,0x6
    80002b20:	84450513          	addi	a0,a0,-1980 # 80008360 <states.0+0x48>
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	afa080e7          	jalr	-1286(ra) # 8000061e <printf>
  asm volatile("mv %0, tp" : "=r"(x));
    80002b2c:	8592                	mv	a1,tp
  printf("tp:%p\n", x);
    80002b2e:	00006517          	auipc	a0,0x6
    80002b32:	83a50513          	addi	a0,a0,-1990 # 80008368 <states.0+0x50>
    80002b36:	ffffe097          	auipc	ra,0xffffe
    80002b3a:	ae8080e7          	jalr	-1304(ra) # 8000061e <printf>
}
    80002b3e:	60a2                	ld	ra,8(sp)
    80002b40:	6402                	ld	s0,0(sp)
    80002b42:	0141                	addi	sp,sp,16
    80002b44:	8082                	ret

0000000080002b46 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002b46:	1141                	addi	sp,sp,-16
    80002b48:	e406                	sd	ra,8(sp)
    80002b4a:	e022                	sd	s0,0(sp)
    80002b4c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b4e:	fffff097          	auipc	ra,0xfffff
    80002b52:	146080e7          	jalr	326(ra) # 80001c94 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b56:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002b5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b5c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002b60:	00004617          	auipc	a2,0x4
    80002b64:	4a060613          	addi	a2,a2,1184 # 80007000 <_trampoline>
    80002b68:	00004697          	auipc	a3,0x4
    80002b6c:	49868693          	addi	a3,a3,1176 # 80007000 <_trampoline>
    80002b70:	8e91                	sub	a3,a3,a2
    80002b72:	040007b7          	lui	a5,0x4000
    80002b76:	17fd                	addi	a5,a5,-1
    80002b78:	07b2                	slli	a5,a5,0xc
    80002b7a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002b7c:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b80:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002b82:	180026f3          	csrr	a3,satp
    80002b86:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b88:	7538                	ld	a4,104(a0)
    80002b8a:	6534                	ld	a3,72(a0)
    80002b8c:	6585                	lui	a1,0x1
    80002b8e:	96ae                	add	a3,a3,a1
    80002b90:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b92:	7538                	ld	a4,104(a0)
    80002b94:	00000697          	auipc	a3,0x0
    80002b98:	13868693          	addi	a3,a3,312 # 80002ccc <usertrap>
    80002b9c:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002b9e:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002ba0:	8692                	mv	a3,tp
    80002ba2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ba4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ba8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bac:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002bb0:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bb4:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002bb6:	6f18                	ld	a4,24(a4)
    80002bb8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002bbc:	6d2c                	ld	a1,88(a0)
    80002bbe:	81b1                	srli	a1,a1,0xc
  // and switches to user mode with sret.

  // * function calls ,or more generally,program executions is just about
  // * change pc from one place to another,accompany with putting arguments
  // * in stack or registers
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002bc0:	00004717          	auipc	a4,0x4
    80002bc4:	4d070713          	addi	a4,a4,1232 # 80007090 <userret>
    80002bc8:	8f11                	sub	a4,a4,a2
    80002bca:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002bcc:	577d                	li	a4,-1
    80002bce:	177e                	slli	a4,a4,0x3f
    80002bd0:	8dd9                	or	a1,a1,a4
    80002bd2:	02000537          	lui	a0,0x2000
    80002bd6:	157d                	addi	a0,a0,-1
    80002bd8:	0536                	slli	a0,a0,0xd
    80002bda:	9782                	jalr	a5
}
    80002bdc:	60a2                	ld	ra,8(sp)
    80002bde:	6402                	ld	s0,0(sp)
    80002be0:	0141                	addi	sp,sp,16
    80002be2:	8082                	ret

0000000080002be4 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002bee:	00015497          	auipc	s1,0x15
    80002bf2:	ee248493          	addi	s1,s1,-286 # 80017ad0 <tickslock>
    80002bf6:	8526                	mv	a0,s1
    80002bf8:	ffffe097          	auipc	ra,0xffffe
    80002bfc:	042080e7          	jalr	66(ra) # 80000c3a <acquire>
  ticks++;
    80002c00:	00006517          	auipc	a0,0x6
    80002c04:	43450513          	addi	a0,a0,1076 # 80009034 <ticks>
    80002c08:	411c                	lw	a5,0(a0)
    80002c0a:	2785                	addiw	a5,a5,1
    80002c0c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002c0e:	00000097          	auipc	ra,0x0
    80002c12:	ac4080e7          	jalr	-1340(ra) # 800026d2 <wakeup>
  release(&tickslock);
    80002c16:	8526                	mv	a0,s1
    80002c18:	ffffe097          	auipc	ra,0xffffe
    80002c1c:	0d6080e7          	jalr	214(ra) # 80000cee <release>
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret

0000000080002c2a <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c34:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002c38:	00074d63          	bltz	a4,80002c52 <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002c3c:	57fd                	li	a5,-1
    80002c3e:	17fe                	slli	a5,a5,0x3f
    80002c40:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c42:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002c44:	06f70363          	beq	a4,a5,80002caa <devintr+0x80>
  }
}
    80002c48:	60e2                	ld	ra,24(sp)
    80002c4a:	6442                	ld	s0,16(sp)
    80002c4c:	64a2                	ld	s1,8(sp)
    80002c4e:	6105                	addi	sp,sp,32
    80002c50:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002c52:	0ff77793          	andi	a5,a4,255
    80002c56:	46a5                	li	a3,9
    80002c58:	fed792e3          	bne	a5,a3,80002c3c <devintr+0x12>
    int irq = plic_claim();
    80002c5c:	00003097          	auipc	ra,0x3
    80002c60:	6ec080e7          	jalr	1772(ra) # 80006348 <plic_claim>
    80002c64:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002c66:	47a9                	li	a5,10
    80002c68:	02f50763          	beq	a0,a5,80002c96 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002c6c:	4785                	li	a5,1
    80002c6e:	02f50963          	beq	a0,a5,80002ca0 <devintr+0x76>
    return 1;
    80002c72:	4505                	li	a0,1
    } else if (irq) {
    80002c74:	d8f1                	beqz	s1,80002c48 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c76:	85a6                	mv	a1,s1
    80002c78:	00005517          	auipc	a0,0x5
    80002c7c:	6f850513          	addi	a0,a0,1784 # 80008370 <states.0+0x58>
    80002c80:	ffffe097          	auipc	ra,0xffffe
    80002c84:	99e080e7          	jalr	-1634(ra) # 8000061e <printf>
      plic_complete(irq);
    80002c88:	8526                	mv	a0,s1
    80002c8a:	00003097          	auipc	ra,0x3
    80002c8e:	6e2080e7          	jalr	1762(ra) # 8000636c <plic_complete>
    return 1;
    80002c92:	4505                	li	a0,1
    80002c94:	bf55                	j	80002c48 <devintr+0x1e>
      uartintr();
    80002c96:	ffffe097          	auipc	ra,0xffffe
    80002c9a:	d68080e7          	jalr	-664(ra) # 800009fe <uartintr>
    80002c9e:	b7ed                	j	80002c88 <devintr+0x5e>
      virtio_disk_intr();
    80002ca0:	00004097          	auipc	ra,0x4
    80002ca4:	b5e080e7          	jalr	-1186(ra) # 800067fe <virtio_disk_intr>
    80002ca8:	b7c5                	j	80002c88 <devintr+0x5e>
    if (cpuid() == 0) {
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	fbe080e7          	jalr	-66(ra) # 80001c68 <cpuid>
    80002cb2:	c901                	beqz	a0,80002cc2 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002cb4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002cb8:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002cba:	14479073          	csrw	sip,a5
    return 2;
    80002cbe:	4509                	li	a0,2
    80002cc0:	b761                	j	80002c48 <devintr+0x1e>
      clockintr();
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	f22080e7          	jalr	-222(ra) # 80002be4 <clockintr>
    80002cca:	b7ed                	j	80002cb4 <devintr+0x8a>

0000000080002ccc <usertrap>:
void usertrap(void) {
    80002ccc:	7179                	addi	sp,sp,-48
    80002cce:	f406                	sd	ra,40(sp)
    80002cd0:	f022                	sd	s0,32(sp)
    80002cd2:	ec26                	sd	s1,24(sp)
    80002cd4:	e84a                	sd	s2,16(sp)
    80002cd6:	e44e                	sd	s3,8(sp)
    80002cd8:	e052                	sd	s4,0(sp)
    80002cda:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002cdc:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002ce0:	1007f793          	andi	a5,a5,256
    80002ce4:	e7a5                	bnez	a5,80002d4c <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002ce6:	00003797          	auipc	a5,0x3
    80002cea:	55a78793          	addi	a5,a5,1370 # 80006240 <kernelvec>
    80002cee:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002cf2:	fffff097          	auipc	ra,0xfffff
    80002cf6:	fa2080e7          	jalr	-94(ra) # 80001c94 <myproc>
    80002cfa:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002cfc:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002cfe:	14102773          	csrr	a4,sepc
    80002d02:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d04:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002d08:	47a1                	li	a5,8
    80002d0a:	04f71f63          	bne	a4,a5,80002d68 <usertrap+0x9c>
    if (p->killed)
    80002d0e:	551c                	lw	a5,40(a0)
    80002d10:	e7b1                	bnez	a5,80002d5c <usertrap+0x90>
    p->trapframe->epc += 4;
    80002d12:	74b8                	ld	a4,104(s1)
    80002d14:	6f1c                	ld	a5,24(a4)
    80002d16:	0791                	addi	a5,a5,4
    80002d18:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d1a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002d1e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d22:	10079073          	csrw	sstatus,a5
    syscall();
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	406080e7          	jalr	1030(ra) # 8000312c <syscall>
  if (p->killed)
    80002d2e:	549c                	lw	a5,40(s1)
    80002d30:	12079f63          	bnez	a5,80002e6e <usertrap+0x1a2>
  usertrapret();
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	e12080e7          	jalr	-494(ra) # 80002b46 <usertrapret>
}
    80002d3c:	70a2                	ld	ra,40(sp)
    80002d3e:	7402                	ld	s0,32(sp)
    80002d40:	64e2                	ld	s1,24(sp)
    80002d42:	6942                	ld	s2,16(sp)
    80002d44:	69a2                	ld	s3,8(sp)
    80002d46:	6a02                	ld	s4,0(sp)
    80002d48:	6145                	addi	sp,sp,48
    80002d4a:	8082                	ret
    panic("usertrap: not from user mode");
    80002d4c:	00005517          	auipc	a0,0x5
    80002d50:	64450513          	addi	a0,a0,1604 # 80008390 <states.0+0x78>
    80002d54:	ffffe097          	auipc	ra,0xffffe
    80002d58:	878080e7          	jalr	-1928(ra) # 800005cc <panic>
      exit(-1);
    80002d5c:	557d                	li	a0,-1
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	a44080e7          	jalr	-1468(ra) # 800027a2 <exit>
    80002d66:	b775                	j	80002d12 <usertrap+0x46>
  } else if ((which_dev = devintr()) != 0) {
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	ec2080e7          	jalr	-318(ra) # 80002c2a <devintr>
    80002d70:	892a                	mv	s2,a0
    80002d72:	e97d                	bnez	a0,80002e68 <usertrap+0x19c>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d74:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80002d78:	47b5                	li	a5,13
    80002d7a:	00f70763          	beq	a4,a5,80002d88 <usertrap+0xbc>
    80002d7e:	14202773          	csrr	a4,scause
    80002d82:	47bd                	li	a5,15
    80002d84:	08f71f63          	bne	a4,a5,80002e22 <usertrap+0x156>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d88:	143029f3          	csrr	s3,stval
    if (fault_addr > myproc()->sz) {
    80002d8c:	fffff097          	auipc	ra,0xfffff
    80002d90:	f08080e7          	jalr	-248(ra) # 80001c94 <myproc>
    80002d94:	693c                	ld	a5,80(a0)
    80002d96:	0337e863          	bltu	a5,s3,80002dc6 <usertrap+0xfa>
    if ((res = do_lazy_allocation(fault_addr)) == -1) {
    80002d9a:	854e                	mv	a0,s3
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	812080e7          	jalr	-2030(ra) # 800015ae <do_lazy_allocation>
    80002da4:	57fd                	li	a5,-1
    80002da6:	06f50363          	beq	a0,a5,80002e0c <usertrap+0x140>
    } else if (res == -2) {
    80002daa:	57f9                	li	a5,-2
    80002dac:	f8f511e3          	bne	a0,a5,80002d2e <usertrap+0x62>
      printf("map failed");
    80002db0:	00005517          	auipc	a0,0x5
    80002db4:	66850513          	addi	a0,a0,1640 # 80008418 <states.0+0x100>
    80002db8:	ffffe097          	auipc	ra,0xffffe
    80002dbc:	866080e7          	jalr	-1946(ra) # 8000061e <printf>
      p->killed = 1;
    80002dc0:	4785                	li	a5,1
    80002dc2:	d49c                	sw	a5,40(s1)
    80002dc4:	a075                	j	80002e70 <usertrap+0x1a4>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002dc6:	14202a73          	csrr	s4,scause
         myproc()->pid);
    80002dca:	fffff097          	auipc	ra,0xfffff
    80002dce:	eca080e7          	jalr	-310(ra) # 80001c94 <myproc>
  printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(),
    80002dd2:	5910                	lw	a2,48(a0)
    80002dd4:	85d2                	mv	a1,s4
    80002dd6:	00005517          	auipc	a0,0x5
    80002dda:	5da50513          	addi	a0,a0,1498 # 800083b0 <states.0+0x98>
    80002dde:	ffffe097          	auipc	ra,0xffffe
    80002de2:	840080e7          	jalr	-1984(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002de6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002dea:	14302673          	csrr	a2,stval
  printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dee:	00005517          	auipc	a0,0x5
    80002df2:	5f250513          	addi	a0,a0,1522 # 800083e0 <states.0+0xc8>
    80002df6:	ffffe097          	auipc	ra,0xffffe
    80002dfa:	828080e7          	jalr	-2008(ra) # 8000061e <printf>
  myproc()->killed = 1;
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	e96080e7          	jalr	-362(ra) # 80001c94 <myproc>
    80002e06:	4785                	li	a5,1
    80002e08:	d51c                	sw	a5,40(a0)
}
    80002e0a:	bf41                	j	80002d9a <usertrap+0xce>
      printf("run out of memory\n");
    80002e0c:	00005517          	auipc	a0,0x5
    80002e10:	5f450513          	addi	a0,a0,1524 # 80008400 <states.0+0xe8>
    80002e14:	ffffe097          	auipc	ra,0xffffe
    80002e18:	80a080e7          	jalr	-2038(ra) # 8000061e <printf>
      p->killed = 1;
    80002e1c:	4785                	li	a5,1
    80002e1e:	d49c                	sw	a5,40(s1)
    80002e20:	a881                	j	80002e70 <usertrap+0x1a4>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002e22:	14202973          	csrr	s2,scause
         myproc()->pid);
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	e6e080e7          	jalr	-402(ra) # 80001c94 <myproc>
  printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(),
    80002e2e:	5910                	lw	a2,48(a0)
    80002e30:	85ca                	mv	a1,s2
    80002e32:	00005517          	auipc	a0,0x5
    80002e36:	57e50513          	addi	a0,a0,1406 # 800083b0 <states.0+0x98>
    80002e3a:	ffffd097          	auipc	ra,0xffffd
    80002e3e:	7e4080e7          	jalr	2020(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002e42:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002e46:	14302673          	csrr	a2,stval
  printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e4a:	00005517          	auipc	a0,0x5
    80002e4e:	59650513          	addi	a0,a0,1430 # 800083e0 <states.0+0xc8>
    80002e52:	ffffd097          	auipc	ra,0xffffd
    80002e56:	7cc080e7          	jalr	1996(ra) # 8000061e <printf>
  myproc()->killed = 1;
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	e3a080e7          	jalr	-454(ra) # 80001c94 <myproc>
    80002e62:	4785                	li	a5,1
    80002e64:	d51c                	sw	a5,40(a0)
}
    80002e66:	b5e1                	j	80002d2e <usertrap+0x62>
  if (p->killed)
    80002e68:	549c                	lw	a5,40(s1)
    80002e6a:	cb81                	beqz	a5,80002e7a <usertrap+0x1ae>
    80002e6c:	a011                	j	80002e70 <usertrap+0x1a4>
    80002e6e:	4901                	li	s2,0
    exit(-1);
    80002e70:	557d                	li	a0,-1
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	930080e7          	jalr	-1744(ra) # 800027a2 <exit>
  if (which_dev == 2) {
    80002e7a:	4789                	li	a5,2
    80002e7c:	eaf91ce3          	bne	s2,a5,80002d34 <usertrap+0x68>
    if (p->if_alarm) {
    80002e80:	1684c783          	lbu	a5,360(s1)
    80002e84:	cf91                	beqz	a5,80002ea0 <usertrap+0x1d4>
      p->tick_left -= 1;
    80002e86:	1704a783          	lw	a5,368(s1)
    80002e8a:	37fd                	addiw	a5,a5,-1
    80002e8c:	0007871b          	sext.w	a4,a5
    80002e90:	16f4a823          	sw	a5,368(s1)
      if (p->tick_left == 0 && !re_en) {
    80002e94:	e711                	bnez	a4,80002ea0 <usertrap+0x1d4>
    80002e96:	00006797          	auipc	a5,0x6
    80002e9a:	19a7c783          	lbu	a5,410(a5) # 80009030 <re_en>
    80002e9e:	c791                	beqz	a5,80002eaa <usertrap+0x1de>
    yield();
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	66a080e7          	jalr	1642(ra) # 8000250a <yield>
    80002ea8:	b571                	j	80002d34 <usertrap+0x68>
        memmove(&handler_frame, p->trapframe, sizeof(handler_frame));
    80002eaa:	12000613          	li	a2,288
    80002eae:	74ac                	ld	a1,104(s1)
    80002eb0:	00015517          	auipc	a0,0x15
    80002eb4:	c3850513          	addi	a0,a0,-968 # 80017ae8 <handler_frame>
    80002eb8:	ffffe097          	auipc	ra,0xffffe
    80002ebc:	eda080e7          	jalr	-294(ra) # 80000d92 <memmove>
        p->tick_left = p->tick;
    80002ec0:	16c4a783          	lw	a5,364(s1)
    80002ec4:	16f4a823          	sw	a5,368(s1)
        u64 epc = p->trapframe->epc;
    80002ec8:	74bc                	ld	a5,104(s1)
    80002eca:	6f98                	ld	a4,24(a5)
        p->trapframe->epc = (u64)fn;
    80002ecc:	1784b683          	ld	a3,376(s1)
    80002ed0:	ef94                	sd	a3,24(a5)
        p->trapframe->ra = epc;
    80002ed2:	74bc                	ld	a5,104(s1)
    80002ed4:	f798                	sd	a4,40(a5)
        re_en = 1;
    80002ed6:	4785                	li	a5,1
    80002ed8:	00006717          	auipc	a4,0x6
    80002edc:	14f70c23          	sb	a5,344(a4) # 80009030 <re_en>
        usertrapret();
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	c66080e7          	jalr	-922(ra) # 80002b46 <usertrapret>
    80002ee8:	bf65                	j	80002ea0 <usertrap+0x1d4>

0000000080002eea <kerneltrap>:
void kerneltrap() {
    80002eea:	7179                	addi	sp,sp,-48
    80002eec:	f406                	sd	ra,40(sp)
    80002eee:	f022                	sd	s0,32(sp)
    80002ef0:	ec26                	sd	s1,24(sp)
    80002ef2:	e84a                	sd	s2,16(sp)
    80002ef4:	e44e                	sd	s3,8(sp)
    80002ef6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002ef8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002efc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002f00:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002f04:	1004f793          	andi	a5,s1,256
    80002f08:	cb85                	beqz	a5,80002f38 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f0a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f0e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002f10:	ef85                	bnez	a5,80002f48 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	d18080e7          	jalr	-744(ra) # 80002c2a <devintr>
    80002f1a:	cd1d                	beqz	a0,80002f58 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f1c:	4789                	li	a5,2
    80002f1e:	06f50a63          	beq	a0,a5,80002f92 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002f22:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002f26:	10049073          	csrw	sstatus,s1
}
    80002f2a:	70a2                	ld	ra,40(sp)
    80002f2c:	7402                	ld	s0,32(sp)
    80002f2e:	64e2                	ld	s1,24(sp)
    80002f30:	6942                	ld	s2,16(sp)
    80002f32:	69a2                	ld	s3,8(sp)
    80002f34:	6145                	addi	sp,sp,48
    80002f36:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002f38:	00005517          	auipc	a0,0x5
    80002f3c:	4f050513          	addi	a0,a0,1264 # 80008428 <states.0+0x110>
    80002f40:	ffffd097          	auipc	ra,0xffffd
    80002f44:	68c080e7          	jalr	1676(ra) # 800005cc <panic>
    panic("kerneltrap: interrupts enabled");
    80002f48:	00005517          	auipc	a0,0x5
    80002f4c:	50850513          	addi	a0,a0,1288 # 80008450 <states.0+0x138>
    80002f50:	ffffd097          	auipc	ra,0xffffd
    80002f54:	67c080e7          	jalr	1660(ra) # 800005cc <panic>
    printf("scause %p\n", scause);
    80002f58:	85ce                	mv	a1,s3
    80002f5a:	00005517          	auipc	a0,0x5
    80002f5e:	51650513          	addi	a0,a0,1302 # 80008470 <states.0+0x158>
    80002f62:	ffffd097          	auipc	ra,0xffffd
    80002f66:	6bc080e7          	jalr	1724(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002f6a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002f6e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f72:	00005517          	auipc	a0,0x5
    80002f76:	50e50513          	addi	a0,a0,1294 # 80008480 <states.0+0x168>
    80002f7a:	ffffd097          	auipc	ra,0xffffd
    80002f7e:	6a4080e7          	jalr	1700(ra) # 8000061e <printf>
    panic("kerneltrap");
    80002f82:	00005517          	auipc	a0,0x5
    80002f86:	51650513          	addi	a0,a0,1302 # 80008498 <states.0+0x180>
    80002f8a:	ffffd097          	auipc	ra,0xffffd
    80002f8e:	642080e7          	jalr	1602(ra) # 800005cc <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	d02080e7          	jalr	-766(ra) # 80001c94 <myproc>
    80002f9a:	d541                	beqz	a0,80002f22 <kerneltrap+0x38>
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	cf8080e7          	jalr	-776(ra) # 80001c94 <myproc>
    80002fa4:	4d18                	lw	a4,24(a0)
    80002fa6:	4791                	li	a5,4
    80002fa8:	f6f71de3          	bne	a4,a5,80002f22 <kerneltrap+0x38>
    yield();
    80002fac:	fffff097          	auipc	ra,0xfffff
    80002fb0:	55e080e7          	jalr	1374(ra) # 8000250a <yield>
    80002fb4:	b7bd                	j	80002f22 <kerneltrap+0x38>

0000000080002fb6 <argraw>:
  if (err < 0)
    return err;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80002fb6:	1101                	addi	sp,sp,-32
    80002fb8:	ec06                	sd	ra,24(sp)
    80002fba:	e822                	sd	s0,16(sp)
    80002fbc:	e426                	sd	s1,8(sp)
    80002fbe:	1000                	addi	s0,sp,32
    80002fc0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	cd2080e7          	jalr	-814(ra) # 80001c94 <myproc>
  switch (n) {
    80002fca:	4795                	li	a5,5
    80002fcc:	0497e163          	bltu	a5,s1,8000300e <argraw+0x58>
    80002fd0:	048a                	slli	s1,s1,0x2
    80002fd2:	00005717          	auipc	a4,0x5
    80002fd6:	51670713          	addi	a4,a4,1302 # 800084e8 <states.0+0x1d0>
    80002fda:	94ba                	add	s1,s1,a4
    80002fdc:	409c                	lw	a5,0(s1)
    80002fde:	97ba                	add	a5,a5,a4
    80002fe0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002fe2:	753c                	ld	a5,104(a0)
    80002fe4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002fe6:	60e2                	ld	ra,24(sp)
    80002fe8:	6442                	ld	s0,16(sp)
    80002fea:	64a2                	ld	s1,8(sp)
    80002fec:	6105                	addi	sp,sp,32
    80002fee:	8082                	ret
    return p->trapframe->a1;
    80002ff0:	753c                	ld	a5,104(a0)
    80002ff2:	7fa8                	ld	a0,120(a5)
    80002ff4:	bfcd                	j	80002fe6 <argraw+0x30>
    return p->trapframe->a2;
    80002ff6:	753c                	ld	a5,104(a0)
    80002ff8:	63c8                	ld	a0,128(a5)
    80002ffa:	b7f5                	j	80002fe6 <argraw+0x30>
    return p->trapframe->a3;
    80002ffc:	753c                	ld	a5,104(a0)
    80002ffe:	67c8                	ld	a0,136(a5)
    80003000:	b7dd                	j	80002fe6 <argraw+0x30>
    return p->trapframe->a4;
    80003002:	753c                	ld	a5,104(a0)
    80003004:	6bc8                	ld	a0,144(a5)
    80003006:	b7c5                	j	80002fe6 <argraw+0x30>
    return p->trapframe->a5;
    80003008:	753c                	ld	a5,104(a0)
    8000300a:	6fc8                	ld	a0,152(a5)
    8000300c:	bfe9                	j	80002fe6 <argraw+0x30>
  panic("argraw");
    8000300e:	00005517          	auipc	a0,0x5
    80003012:	49a50513          	addi	a0,a0,1178 # 800084a8 <states.0+0x190>
    80003016:	ffffd097          	auipc	ra,0xffffd
    8000301a:	5b6080e7          	jalr	1462(ra) # 800005cc <panic>

000000008000301e <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    8000301e:	1101                	addi	sp,sp,-32
    80003020:	ec06                	sd	ra,24(sp)
    80003022:	e822                	sd	s0,16(sp)
    80003024:	e426                	sd	s1,8(sp)
    80003026:	e04a                	sd	s2,0(sp)
    80003028:	1000                	addi	s0,sp,32
    8000302a:	84aa                	mv	s1,a0
    8000302c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	c66080e7          	jalr	-922(ra) # 80001c94 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80003036:	693c                	ld	a5,80(a0)
    80003038:	02f4f863          	bgeu	s1,a5,80003068 <fetchaddr+0x4a>
    8000303c:	00848713          	addi	a4,s1,8
    80003040:	02e7e663          	bltu	a5,a4,8000306c <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003044:	46a1                	li	a3,8
    80003046:	8626                	mv	a2,s1
    80003048:	85ca                	mv	a1,s2
    8000304a:	6d28                	ld	a0,88(a0)
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	93e080e7          	jalr	-1730(ra) # 8000198a <copyin>
    80003054:	00a03533          	snez	a0,a0
    80003058:	40a00533          	neg	a0,a0
}
    8000305c:	60e2                	ld	ra,24(sp)
    8000305e:	6442                	ld	s0,16(sp)
    80003060:	64a2                	ld	s1,8(sp)
    80003062:	6902                	ld	s2,0(sp)
    80003064:	6105                	addi	sp,sp,32
    80003066:	8082                	ret
    return -1;
    80003068:	557d                	li	a0,-1
    8000306a:	bfcd                	j	8000305c <fetchaddr+0x3e>
    8000306c:	557d                	li	a0,-1
    8000306e:	b7fd                	j	8000305c <fetchaddr+0x3e>

0000000080003070 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80003070:	7179                	addi	sp,sp,-48
    80003072:	f406                	sd	ra,40(sp)
    80003074:	f022                	sd	s0,32(sp)
    80003076:	ec26                	sd	s1,24(sp)
    80003078:	e84a                	sd	s2,16(sp)
    8000307a:	e44e                	sd	s3,8(sp)
    8000307c:	1800                	addi	s0,sp,48
    8000307e:	892a                	mv	s2,a0
    80003080:	84ae                	mv	s1,a1
    80003082:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	c10080e7          	jalr	-1008(ra) # 80001c94 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000308c:	86ce                	mv	a3,s3
    8000308e:	864a                	mv	a2,s2
    80003090:	85a6                	mv	a1,s1
    80003092:	6d28                	ld	a0,88(a0)
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	988080e7          	jalr	-1656(ra) # 80001a1c <copyinstr>
  if (err < 0)
    8000309c:	00054763          	bltz	a0,800030aa <fetchstr+0x3a>
  return strlen(buf);
    800030a0:	8526                	mv	a0,s1
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	e18080e7          	jalr	-488(ra) # 80000eba <strlen>
}
    800030aa:	70a2                	ld	ra,40(sp)
    800030ac:	7402                	ld	s0,32(sp)
    800030ae:	64e2                	ld	s1,24(sp)
    800030b0:	6942                	ld	s2,16(sp)
    800030b2:	69a2                	ld	s3,8(sp)
    800030b4:	6145                	addi	sp,sp,48
    800030b6:	8082                	ret

00000000800030b8 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
    800030b8:	1101                	addi	sp,sp,-32
    800030ba:	ec06                	sd	ra,24(sp)
    800030bc:	e822                	sd	s0,16(sp)
    800030be:	e426                	sd	s1,8(sp)
    800030c0:	1000                	addi	s0,sp,32
    800030c2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	ef2080e7          	jalr	-270(ra) # 80002fb6 <argraw>
    800030cc:	c088                	sw	a0,0(s1)
  return 0;
}
    800030ce:	4501                	li	a0,0
    800030d0:	60e2                	ld	ra,24(sp)
    800030d2:	6442                	ld	s0,16(sp)
    800030d4:	64a2                	ld	s1,8(sp)
    800030d6:	6105                	addi	sp,sp,32
    800030d8:	8082                	ret

00000000800030da <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip) {
    800030da:	1101                	addi	sp,sp,-32
    800030dc:	ec06                	sd	ra,24(sp)
    800030de:	e822                	sd	s0,16(sp)
    800030e0:	e426                	sd	s1,8(sp)
    800030e2:	1000                	addi	s0,sp,32
    800030e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	ed0080e7          	jalr	-304(ra) # 80002fb6 <argraw>
    800030ee:	e088                	sd	a0,0(s1)
  return 0;
}
    800030f0:	4501                	li	a0,0
    800030f2:	60e2                	ld	ra,24(sp)
    800030f4:	6442                	ld	s0,16(sp)
    800030f6:	64a2                	ld	s1,8(sp)
    800030f8:	6105                	addi	sp,sp,32
    800030fa:	8082                	ret

00000000800030fc <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    800030fc:	1101                	addi	sp,sp,-32
    800030fe:	ec06                	sd	ra,24(sp)
    80003100:	e822                	sd	s0,16(sp)
    80003102:	e426                	sd	s1,8(sp)
    80003104:	e04a                	sd	s2,0(sp)
    80003106:	1000                	addi	s0,sp,32
    80003108:	84ae                	mv	s1,a1
    8000310a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	eaa080e7          	jalr	-342(ra) # 80002fb6 <argraw>
  uint64 addr;
  if (argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003114:	864a                	mv	a2,s2
    80003116:	85a6                	mv	a1,s1
    80003118:	00000097          	auipc	ra,0x0
    8000311c:	f58080e7          	jalr	-168(ra) # 80003070 <fetchstr>
}
    80003120:	60e2                	ld	ra,24(sp)
    80003122:	6442                	ld	s0,16(sp)
    80003124:	64a2                	ld	s1,8(sp)
    80003126:	6902                	ld	s2,0(sp)
    80003128:	6105                	addi	sp,sp,32
    8000312a:	8082                	ret

000000008000312c <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,   [SYS_trace] = sys_trace,
    [SYS_alarm] = sys_alarm,   [SYS_alarmret] = sys_alarmret};

void syscall(void) {
    8000312c:	7179                	addi	sp,sp,-48
    8000312e:	f406                	sd	ra,40(sp)
    80003130:	f022                	sd	s0,32(sp)
    80003132:	ec26                	sd	s1,24(sp)
    80003134:	e84a                	sd	s2,16(sp)
    80003136:	e44e                	sd	s3,8(sp)
    80003138:	e052                	sd	s4,0(sp)
    8000313a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	b58080e7          	jalr	-1192(ra) # 80001c94 <myproc>
    80003144:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003146:	753c                	ld	a5,104(a0)
    80003148:	77dc                	ld	a5,168(a5)
    8000314a:	0007891b          	sext.w	s2,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000314e:	37fd                	addiw	a5,a5,-1
    80003150:	475d                	li	a4,23
    80003152:	04f76f63          	bltu	a4,a5,800031b0 <syscall+0x84>
    80003156:	00391713          	slli	a4,s2,0x3
    8000315a:	00005797          	auipc	a5,0x5
    8000315e:	3a678793          	addi	a5,a5,934 # 80008500 <syscalls>
    80003162:	97ba                	add	a5,a5,a4
    80003164:	0007ba03          	ld	s4,0(a5)
    80003168:	040a0463          	beqz	s4,800031b0 <syscall+0x84>
    i32 mask = myproc()->traced;
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	b28080e7          	jalr	-1240(ra) # 80001c94 <myproc>
    80003174:	04052983          	lw	s3,64(a0)
    u64 res = syscalls[num]();
    80003178:	9a02                	jalr	s4
    8000317a:	8a2a                	mv	s4,a0
    if (mask & (1 << num)) {
    8000317c:	4129d9bb          	sraw	s3,s3,s2
    80003180:	0019f993          	andi	s3,s3,1
    80003184:	00099663          	bnez	s3,80003190 <syscall+0x64>
      printf("%d: syscall %d -> %d\n", myproc()->pid, num, res);
    }
    p->trapframe->a0 = res;
    80003188:	74bc                	ld	a5,104(s1)
    8000318a:	0747b823          	sd	s4,112(a5)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000318e:	a081                	j	800031ce <syscall+0xa2>
      printf("%d: syscall %d -> %d\n", myproc()->pid, num, res);
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	b04080e7          	jalr	-1276(ra) # 80001c94 <myproc>
    80003198:	86d2                	mv	a3,s4
    8000319a:	864a                	mv	a2,s2
    8000319c:	590c                	lw	a1,48(a0)
    8000319e:	00005517          	auipc	a0,0x5
    800031a2:	31250513          	addi	a0,a0,786 # 800084b0 <states.0+0x198>
    800031a6:	ffffd097          	auipc	ra,0xffffd
    800031aa:	478080e7          	jalr	1144(ra) # 8000061e <printf>
    800031ae:	bfe9                	j	80003188 <syscall+0x5c>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800031b0:	86ca                	mv	a3,s2
    800031b2:	18048613          	addi	a2,s1,384
    800031b6:	588c                	lw	a1,48(s1)
    800031b8:	00005517          	auipc	a0,0x5
    800031bc:	31050513          	addi	a0,a0,784 # 800084c8 <states.0+0x1b0>
    800031c0:	ffffd097          	auipc	ra,0xffffd
    800031c4:	45e080e7          	jalr	1118(ra) # 8000061e <printf>
    p->trapframe->a0 = -1;
    800031c8:	74bc                	ld	a5,104(s1)
    800031ca:	577d                	li	a4,-1
    800031cc:	fbb8                	sd	a4,112(a5)
  }
}
    800031ce:	70a2                	ld	ra,40(sp)
    800031d0:	7402                	ld	s0,32(sp)
    800031d2:	64e2                	ld	s1,24(sp)
    800031d4:	6942                	ld	s2,16(sp)
    800031d6:	69a2                	ld	s3,8(sp)
    800031d8:	6a02                	ld	s4,0(sp)
    800031da:	6145                	addi	sp,sp,48
    800031dc:	8082                	ret

00000000800031de <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    800031de:	1101                	addi	sp,sp,-32
    800031e0:	ec06                	sd	ra,24(sp)
    800031e2:	e822                	sd	s0,16(sp)
    800031e4:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    800031e6:	fec40593          	addi	a1,s0,-20
    800031ea:	4501                	li	a0,0
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	ecc080e7          	jalr	-308(ra) # 800030b8 <argint>
    return -1;
    800031f4:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800031f6:	00054963          	bltz	a0,80003208 <sys_exit+0x2a>
  exit(n);
    800031fa:	fec42503          	lw	a0,-20(s0)
    800031fe:	fffff097          	auipc	ra,0xfffff
    80003202:	5a4080e7          	jalr	1444(ra) # 800027a2 <exit>
  return 0; // not reached
    80003206:	4781                	li	a5,0
}
    80003208:	853e                	mv	a0,a5
    8000320a:	60e2                	ld	ra,24(sp)
    8000320c:	6442                	ld	s0,16(sp)
    8000320e:	6105                	addi	sp,sp,32
    80003210:	8082                	ret

0000000080003212 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80003212:	1141                	addi	sp,sp,-16
    80003214:	e406                	sd	ra,8(sp)
    80003216:	e022                	sd	s0,0(sp)
    80003218:	0800                	addi	s0,sp,16
    8000321a:	fffff097          	auipc	ra,0xfffff
    8000321e:	a7a080e7          	jalr	-1414(ra) # 80001c94 <myproc>
    80003222:	5908                	lw	a0,48(a0)
    80003224:	60a2                	ld	ra,8(sp)
    80003226:	6402                	ld	s0,0(sp)
    80003228:	0141                	addi	sp,sp,16
    8000322a:	8082                	ret

000000008000322c <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    8000322c:	1141                	addi	sp,sp,-16
    8000322e:	e406                	sd	ra,8(sp)
    80003230:	e022                	sd	s0,0(sp)
    80003232:	0800                	addi	s0,sp,16
    80003234:	fffff097          	auipc	ra,0xfffff
    80003238:	f90080e7          	jalr	-112(ra) # 800021c4 <fork>
    8000323c:	60a2                	ld	ra,8(sp)
    8000323e:	6402                	ld	s0,0(sp)
    80003240:	0141                	addi	sp,sp,16
    80003242:	8082                	ret

0000000080003244 <sys_wait>:

uint64 sys_wait(void) {
    80003244:	1101                	addi	sp,sp,-32
    80003246:	ec06                	sd	ra,24(sp)
    80003248:	e822                	sd	s0,16(sp)
    8000324a:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    8000324c:	fe840593          	addi	a1,s0,-24
    80003250:	4501                	li	a0,0
    80003252:	00000097          	auipc	ra,0x0
    80003256:	e88080e7          	jalr	-376(ra) # 800030da <argaddr>
    8000325a:	87aa                	mv	a5,a0
    return -1;
    8000325c:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    8000325e:	0007c863          	bltz	a5,8000326e <sys_wait+0x2a>
  return wait(p);
    80003262:	fe843503          	ld	a0,-24(s0)
    80003266:	fffff097          	auipc	ra,0xfffff
    8000326a:	344080e7          	jalr	836(ra) # 800025aa <wait>
}
    8000326e:	60e2                	ld	ra,24(sp)
    80003270:	6442                	ld	s0,16(sp)
    80003272:	6105                	addi	sp,sp,32
    80003274:	8082                	ret

0000000080003276 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003276:	7179                	addi	sp,sp,-48
    80003278:	f406                	sd	ra,40(sp)
    8000327a:	f022                	sd	s0,32(sp)
    8000327c:	ec26                	sd	s1,24(sp)
    8000327e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    80003280:	fdc40593          	addi	a1,s0,-36
    80003284:	4501                	li	a0,0
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	e32080e7          	jalr	-462(ra) # 800030b8 <argint>
    8000328e:	87aa                	mv	a5,a0
    return -1;
    80003290:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    80003292:	0207c063          	bltz	a5,800032b2 <sys_sbrk+0x3c>
  struct proc *p = myproc();
    80003296:	fffff097          	auipc	ra,0xfffff
    8000329a:	9fe080e7          	jalr	-1538(ra) # 80001c94 <myproc>
  addr = p->sz;
    8000329e:	6930                	ld	a2,80(a0)
    800032a0:	0006049b          	sext.w	s1,a2
  p->sz += n;
    800032a4:	fdc42783          	lw	a5,-36(s0)
    800032a8:	963e                	add	a2,a2,a5
    800032aa:	e930                	sd	a2,80(a0)
  if (n < 0) {
    800032ac:	0007c863          	bltz	a5,800032bc <sys_sbrk+0x46>
    uvmdealloc(p->pagetable, addr, p->sz);
  }
  return addr;
    800032b0:	8526                	mv	a0,s1
}
    800032b2:	70a2                	ld	ra,40(sp)
    800032b4:	7402                	ld	s0,32(sp)
    800032b6:	64e2                	ld	s1,24(sp)
    800032b8:	6145                	addi	sp,sp,48
    800032ba:	8082                	ret
    uvmdealloc(p->pagetable, addr, p->sz);
    800032bc:	85a6                	mv	a1,s1
    800032be:	6d28                	ld	a0,88(a0)
    800032c0:	ffffe097          	auipc	ra,0xffffe
    800032c4:	1cc080e7          	jalr	460(ra) # 8000148c <uvmdealloc>
    800032c8:	b7e5                	j	800032b0 <sys_sbrk+0x3a>

00000000800032ca <sys_trace>:

u64 sys_trace(void) {
    800032ca:	1101                	addi	sp,sp,-32
    800032cc:	ec06                	sd	ra,24(sp)
    800032ce:	e822                	sd	s0,16(sp)
    800032d0:	1000                	addi	s0,sp,32
  i32 traced;
  if (argint(0, &traced) < 0)
    800032d2:	fec40593          	addi	a1,s0,-20
    800032d6:	4501                	li	a0,0
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	de0080e7          	jalr	-544(ra) # 800030b8 <argint>
    800032e0:	87aa                	mv	a5,a0
    return -1;
    800032e2:	557d                	li	a0,-1
  if (argint(0, &traced) < 0)
    800032e4:	0007c863          	bltz	a5,800032f4 <sys_trace+0x2a>
  return trace(traced);
    800032e8:	fec42503          	lw	a0,-20(s0)
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	e74080e7          	jalr	-396(ra) # 80002160 <trace>
}
    800032f4:	60e2                	ld	ra,24(sp)
    800032f6:	6442                	ld	s0,16(sp)
    800032f8:	6105                	addi	sp,sp,32
    800032fa:	8082                	ret

00000000800032fc <sys_alarm>:

u64 sys_alarm(void) {
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	1000                	addi	s0,sp,32
  i32 tick;
  u64 handler;
  if (argaddr(1, &handler) < 0)
    80003304:	fe040593          	addi	a1,s0,-32
    80003308:	4505                	li	a0,1
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	dd0080e7          	jalr	-560(ra) # 800030da <argaddr>
    return -1;
    80003312:	57fd                	li	a5,-1
  if (argaddr(1, &handler) < 0)
    80003314:	02054563          	bltz	a0,8000333e <sys_alarm+0x42>
  if (argint(0, &tick) < 0)
    80003318:	fec40593          	addi	a1,s0,-20
    8000331c:	4501                	li	a0,0
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	d9a080e7          	jalr	-614(ra) # 800030b8 <argint>
    return -1;
    80003326:	57fd                	li	a5,-1
  if (argint(0, &tick) < 0)
    80003328:	00054b63          	bltz	a0,8000333e <sys_alarm+0x42>
  return alarm(tick, (void *)handler);
    8000332c:	fe043583          	ld	a1,-32(s0)
    80003330:	fec42503          	lw	a0,-20(s0)
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	e52080e7          	jalr	-430(ra) # 80002186 <alarm>
    8000333c:	87aa                	mv	a5,a0
}
    8000333e:	853e                	mv	a0,a5
    80003340:	60e2                	ld	ra,24(sp)
    80003342:	6442                	ld	s0,16(sp)
    80003344:	6105                	addi	sp,sp,32
    80003346:	8082                	ret

0000000080003348 <sys_alarmret>:

extern struct trapframe handler_frame;
extern u8 re_en;
u64 sys_alarmret(void) {
    80003348:	1141                	addi	sp,sp,-16
    8000334a:	e406                	sd	ra,8(sp)
    8000334c:	e022                	sd	s0,0(sp)
    8000334e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	944080e7          	jalr	-1724(ra) # 80001c94 <myproc>
  // * restore argument registers
  memmove(p->trapframe, &handler_frame, sizeof(handler_frame));
    80003358:	12000613          	li	a2,288
    8000335c:	00014597          	auipc	a1,0x14
    80003360:	78c58593          	addi	a1,a1,1932 # 80017ae8 <handler_frame>
    80003364:	7528                	ld	a0,104(a0)
    80003366:	ffffe097          	auipc	ra,0xffffe
    8000336a:	a2c080e7          	jalr	-1492(ra) # 80000d92 <memmove>
  re_en = 0;
    8000336e:	00006797          	auipc	a5,0x6
    80003372:	cc078123          	sb	zero,-830(a5) # 80009030 <re_en>
  usertrapret();
    80003376:	fffff097          	auipc	ra,0xfffff
    8000337a:	7d0080e7          	jalr	2000(ra) # 80002b46 <usertrapret>
  return 0;
}
    8000337e:	4501                	li	a0,0
    80003380:	60a2                	ld	ra,8(sp)
    80003382:	6402                	ld	s0,0(sp)
    80003384:	0141                	addi	sp,sp,16
    80003386:	8082                	ret

0000000080003388 <sys_sleep>:

uint64 sys_sleep(void) {
    80003388:	7139                	addi	sp,sp,-64
    8000338a:	fc06                	sd	ra,56(sp)
    8000338c:	f822                	sd	s0,48(sp)
    8000338e:	f426                	sd	s1,40(sp)
    80003390:	f04a                	sd	s2,32(sp)
    80003392:	ec4e                	sd	s3,24(sp)
    80003394:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80003396:	fcc40593          	addi	a1,s0,-52
    8000339a:	4501                	li	a0,0
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	d1c080e7          	jalr	-740(ra) # 800030b8 <argint>
    return -1;
    800033a4:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800033a6:	06054563          	bltz	a0,80003410 <sys_sleep+0x88>
  acquire(&tickslock);
    800033aa:	00014517          	auipc	a0,0x14
    800033ae:	72650513          	addi	a0,a0,1830 # 80017ad0 <tickslock>
    800033b2:	ffffe097          	auipc	ra,0xffffe
    800033b6:	888080e7          	jalr	-1912(ra) # 80000c3a <acquire>
  ticks0 = ticks;
    800033ba:	00006917          	auipc	s2,0x6
    800033be:	c7a92903          	lw	s2,-902(s2) # 80009034 <ticks>
  while (ticks - ticks0 < n) {
    800033c2:	fcc42783          	lw	a5,-52(s0)
    800033c6:	cf85                	beqz	a5,800033fe <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800033c8:	00014997          	auipc	s3,0x14
    800033cc:	70898993          	addi	s3,s3,1800 # 80017ad0 <tickslock>
    800033d0:	00006497          	auipc	s1,0x6
    800033d4:	c6448493          	addi	s1,s1,-924 # 80009034 <ticks>
    if (myproc()->killed) {
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	8bc080e7          	jalr	-1860(ra) # 80001c94 <myproc>
    800033e0:	551c                	lw	a5,40(a0)
    800033e2:	ef9d                	bnez	a5,80003420 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800033e4:	85ce                	mv	a1,s3
    800033e6:	8526                	mv	a0,s1
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	15e080e7          	jalr	350(ra) # 80002546 <sleep>
  while (ticks - ticks0 < n) {
    800033f0:	409c                	lw	a5,0(s1)
    800033f2:	412787bb          	subw	a5,a5,s2
    800033f6:	fcc42703          	lw	a4,-52(s0)
    800033fa:	fce7efe3          	bltu	a5,a4,800033d8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800033fe:	00014517          	auipc	a0,0x14
    80003402:	6d250513          	addi	a0,a0,1746 # 80017ad0 <tickslock>
    80003406:	ffffe097          	auipc	ra,0xffffe
    8000340a:	8e8080e7          	jalr	-1816(ra) # 80000cee <release>
  return 0;
    8000340e:	4781                	li	a5,0
}
    80003410:	853e                	mv	a0,a5
    80003412:	70e2                	ld	ra,56(sp)
    80003414:	7442                	ld	s0,48(sp)
    80003416:	74a2                	ld	s1,40(sp)
    80003418:	7902                	ld	s2,32(sp)
    8000341a:	69e2                	ld	s3,24(sp)
    8000341c:	6121                	addi	sp,sp,64
    8000341e:	8082                	ret
      release(&tickslock);
    80003420:	00014517          	auipc	a0,0x14
    80003424:	6b050513          	addi	a0,a0,1712 # 80017ad0 <tickslock>
    80003428:	ffffe097          	auipc	ra,0xffffe
    8000342c:	8c6080e7          	jalr	-1850(ra) # 80000cee <release>
      return -1;
    80003430:	57fd                	li	a5,-1
    80003432:	bff9                	j	80003410 <sys_sleep+0x88>

0000000080003434 <sys_kill>:

uint64 sys_kill(void) {
    80003434:	1101                	addi	sp,sp,-32
    80003436:	ec06                	sd	ra,24(sp)
    80003438:	e822                	sd	s0,16(sp)
    8000343a:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    8000343c:	fec40593          	addi	a1,s0,-20
    80003440:	4501                	li	a0,0
    80003442:	00000097          	auipc	ra,0x0
    80003446:	c76080e7          	jalr	-906(ra) # 800030b8 <argint>
    8000344a:	87aa                	mv	a5,a0
    return -1;
    8000344c:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    8000344e:	0007c863          	bltz	a5,8000345e <sys_kill+0x2a>
  return kill(pid);
    80003452:	fec42503          	lw	a0,-20(s0)
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	422080e7          	jalr	1058(ra) # 80002878 <kill>
}
    8000345e:	60e2                	ld	ra,24(sp)
    80003460:	6442                	ld	s0,16(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80003466:	1101                	addi	sp,sp,-32
    80003468:	ec06                	sd	ra,24(sp)
    8000346a:	e822                	sd	s0,16(sp)
    8000346c:	e426                	sd	s1,8(sp)
    8000346e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003470:	00014517          	auipc	a0,0x14
    80003474:	66050513          	addi	a0,a0,1632 # 80017ad0 <tickslock>
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	7c2080e7          	jalr	1986(ra) # 80000c3a <acquire>
  xticks = ticks;
    80003480:	00006497          	auipc	s1,0x6
    80003484:	bb44a483          	lw	s1,-1100(s1) # 80009034 <ticks>
  release(&tickslock);
    80003488:	00014517          	auipc	a0,0x14
    8000348c:	64850513          	addi	a0,a0,1608 # 80017ad0 <tickslock>
    80003490:	ffffe097          	auipc	ra,0xffffe
    80003494:	85e080e7          	jalr	-1954(ra) # 80000cee <release>
  return xticks;
}
    80003498:	02049513          	slli	a0,s1,0x20
    8000349c:	9101                	srli	a0,a0,0x20
    8000349e:	60e2                	ld	ra,24(sp)
    800034a0:	6442                	ld	s0,16(sp)
    800034a2:	64a2                	ld	s1,8(sp)
    800034a4:	6105                	addi	sp,sp,32
    800034a6:	8082                	ret

00000000800034a8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800034a8:	7179                	addi	sp,sp,-48
    800034aa:	f406                	sd	ra,40(sp)
    800034ac:	f022                	sd	s0,32(sp)
    800034ae:	ec26                	sd	s1,24(sp)
    800034b0:	e84a                	sd	s2,16(sp)
    800034b2:	e44e                	sd	s3,8(sp)
    800034b4:	e052                	sd	s4,0(sp)
    800034b6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800034b8:	00005597          	auipc	a1,0x5
    800034bc:	11058593          	addi	a1,a1,272 # 800085c8 <syscalls+0xc8>
    800034c0:	00014517          	auipc	a0,0x14
    800034c4:	74850513          	addi	a0,a0,1864 # 80017c08 <bcache>
    800034c8:	ffffd097          	auipc	ra,0xffffd
    800034cc:	6e2080e7          	jalr	1762(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800034d0:	0001c797          	auipc	a5,0x1c
    800034d4:	73878793          	addi	a5,a5,1848 # 8001fc08 <bcache+0x8000>
    800034d8:	0001d717          	auipc	a4,0x1d
    800034dc:	99870713          	addi	a4,a4,-1640 # 8001fe70 <bcache+0x8268>
    800034e0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800034e4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034e8:	00014497          	auipc	s1,0x14
    800034ec:	73848493          	addi	s1,s1,1848 # 80017c20 <bcache+0x18>
    b->next = bcache.head.next;
    800034f0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800034f2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800034f4:	00005a17          	auipc	s4,0x5
    800034f8:	0dca0a13          	addi	s4,s4,220 # 800085d0 <syscalls+0xd0>
    b->next = bcache.head.next;
    800034fc:	2b893783          	ld	a5,696(s2)
    80003500:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003502:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003506:	85d2                	mv	a1,s4
    80003508:	01048513          	addi	a0,s1,16
    8000350c:	00001097          	auipc	ra,0x1
    80003510:	4bc080e7          	jalr	1212(ra) # 800049c8 <initsleeplock>
    bcache.head.next->prev = b;
    80003514:	2b893783          	ld	a5,696(s2)
    80003518:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000351a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000351e:	45848493          	addi	s1,s1,1112
    80003522:	fd349de3          	bne	s1,s3,800034fc <binit+0x54>
  }
}
    80003526:	70a2                	ld	ra,40(sp)
    80003528:	7402                	ld	s0,32(sp)
    8000352a:	64e2                	ld	s1,24(sp)
    8000352c:	6942                	ld	s2,16(sp)
    8000352e:	69a2                	ld	s3,8(sp)
    80003530:	6a02                	ld	s4,0(sp)
    80003532:	6145                	addi	sp,sp,48
    80003534:	8082                	ret

0000000080003536 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003536:	7179                	addi	sp,sp,-48
    80003538:	f406                	sd	ra,40(sp)
    8000353a:	f022                	sd	s0,32(sp)
    8000353c:	ec26                	sd	s1,24(sp)
    8000353e:	e84a                	sd	s2,16(sp)
    80003540:	e44e                	sd	s3,8(sp)
    80003542:	1800                	addi	s0,sp,48
    80003544:	892a                	mv	s2,a0
    80003546:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003548:	00014517          	auipc	a0,0x14
    8000354c:	6c050513          	addi	a0,a0,1728 # 80017c08 <bcache>
    80003550:	ffffd097          	auipc	ra,0xffffd
    80003554:	6ea080e7          	jalr	1770(ra) # 80000c3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003558:	0001d497          	auipc	s1,0x1d
    8000355c:	9684b483          	ld	s1,-1688(s1) # 8001fec0 <bcache+0x82b8>
    80003560:	0001d797          	auipc	a5,0x1d
    80003564:	91078793          	addi	a5,a5,-1776 # 8001fe70 <bcache+0x8268>
    80003568:	02f48f63          	beq	s1,a5,800035a6 <bread+0x70>
    8000356c:	873e                	mv	a4,a5
    8000356e:	a021                	j	80003576 <bread+0x40>
    80003570:	68a4                	ld	s1,80(s1)
    80003572:	02e48a63          	beq	s1,a4,800035a6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003576:	449c                	lw	a5,8(s1)
    80003578:	ff279ce3          	bne	a5,s2,80003570 <bread+0x3a>
    8000357c:	44dc                	lw	a5,12(s1)
    8000357e:	ff3799e3          	bne	a5,s3,80003570 <bread+0x3a>
      b->refcnt++;
    80003582:	40bc                	lw	a5,64(s1)
    80003584:	2785                	addiw	a5,a5,1
    80003586:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003588:	00014517          	auipc	a0,0x14
    8000358c:	68050513          	addi	a0,a0,1664 # 80017c08 <bcache>
    80003590:	ffffd097          	auipc	ra,0xffffd
    80003594:	75e080e7          	jalr	1886(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    80003598:	01048513          	addi	a0,s1,16
    8000359c:	00001097          	auipc	ra,0x1
    800035a0:	466080e7          	jalr	1126(ra) # 80004a02 <acquiresleep>
      return b;
    800035a4:	a8b9                	j	80003602 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035a6:	0001d497          	auipc	s1,0x1d
    800035aa:	9124b483          	ld	s1,-1774(s1) # 8001feb8 <bcache+0x82b0>
    800035ae:	0001d797          	auipc	a5,0x1d
    800035b2:	8c278793          	addi	a5,a5,-1854 # 8001fe70 <bcache+0x8268>
    800035b6:	00f48863          	beq	s1,a5,800035c6 <bread+0x90>
    800035ba:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800035bc:	40bc                	lw	a5,64(s1)
    800035be:	cf81                	beqz	a5,800035d6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035c0:	64a4                	ld	s1,72(s1)
    800035c2:	fee49de3          	bne	s1,a4,800035bc <bread+0x86>
  panic("bget: no buffers");
    800035c6:	00005517          	auipc	a0,0x5
    800035ca:	01250513          	addi	a0,a0,18 # 800085d8 <syscalls+0xd8>
    800035ce:	ffffd097          	auipc	ra,0xffffd
    800035d2:	ffe080e7          	jalr	-2(ra) # 800005cc <panic>
      b->dev = dev;
    800035d6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800035da:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800035de:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800035e2:	4785                	li	a5,1
    800035e4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800035e6:	00014517          	auipc	a0,0x14
    800035ea:	62250513          	addi	a0,a0,1570 # 80017c08 <bcache>
    800035ee:	ffffd097          	auipc	ra,0xffffd
    800035f2:	700080e7          	jalr	1792(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    800035f6:	01048513          	addi	a0,s1,16
    800035fa:	00001097          	auipc	ra,0x1
    800035fe:	408080e7          	jalr	1032(ra) # 80004a02 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003602:	409c                	lw	a5,0(s1)
    80003604:	cb89                	beqz	a5,80003616 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003606:	8526                	mv	a0,s1
    80003608:	70a2                	ld	ra,40(sp)
    8000360a:	7402                	ld	s0,32(sp)
    8000360c:	64e2                	ld	s1,24(sp)
    8000360e:	6942                	ld	s2,16(sp)
    80003610:	69a2                	ld	s3,8(sp)
    80003612:	6145                	addi	sp,sp,48
    80003614:	8082                	ret
    virtio_disk_rw(b, 0);
    80003616:	4581                	li	a1,0
    80003618:	8526                	mv	a0,s1
    8000361a:	00003097          	auipc	ra,0x3
    8000361e:	f5c080e7          	jalr	-164(ra) # 80006576 <virtio_disk_rw>
    b->valid = 1;
    80003622:	4785                	li	a5,1
    80003624:	c09c                	sw	a5,0(s1)
  return b;
    80003626:	b7c5                	j	80003606 <bread+0xd0>

0000000080003628 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003628:	1101                	addi	sp,sp,-32
    8000362a:	ec06                	sd	ra,24(sp)
    8000362c:	e822                	sd	s0,16(sp)
    8000362e:	e426                	sd	s1,8(sp)
    80003630:	1000                	addi	s0,sp,32
    80003632:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003634:	0541                	addi	a0,a0,16
    80003636:	00001097          	auipc	ra,0x1
    8000363a:	466080e7          	jalr	1126(ra) # 80004a9c <holdingsleep>
    8000363e:	cd01                	beqz	a0,80003656 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003640:	4585                	li	a1,1
    80003642:	8526                	mv	a0,s1
    80003644:	00003097          	auipc	ra,0x3
    80003648:	f32080e7          	jalr	-206(ra) # 80006576 <virtio_disk_rw>
}
    8000364c:	60e2                	ld	ra,24(sp)
    8000364e:	6442                	ld	s0,16(sp)
    80003650:	64a2                	ld	s1,8(sp)
    80003652:	6105                	addi	sp,sp,32
    80003654:	8082                	ret
    panic("bwrite");
    80003656:	00005517          	auipc	a0,0x5
    8000365a:	f9a50513          	addi	a0,a0,-102 # 800085f0 <syscalls+0xf0>
    8000365e:	ffffd097          	auipc	ra,0xffffd
    80003662:	f6e080e7          	jalr	-146(ra) # 800005cc <panic>

0000000080003666 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003666:	1101                	addi	sp,sp,-32
    80003668:	ec06                	sd	ra,24(sp)
    8000366a:	e822                	sd	s0,16(sp)
    8000366c:	e426                	sd	s1,8(sp)
    8000366e:	e04a                	sd	s2,0(sp)
    80003670:	1000                	addi	s0,sp,32
    80003672:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003674:	01050913          	addi	s2,a0,16
    80003678:	854a                	mv	a0,s2
    8000367a:	00001097          	auipc	ra,0x1
    8000367e:	422080e7          	jalr	1058(ra) # 80004a9c <holdingsleep>
    80003682:	c92d                	beqz	a0,800036f4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003684:	854a                	mv	a0,s2
    80003686:	00001097          	auipc	ra,0x1
    8000368a:	3d2080e7          	jalr	978(ra) # 80004a58 <releasesleep>

  acquire(&bcache.lock);
    8000368e:	00014517          	auipc	a0,0x14
    80003692:	57a50513          	addi	a0,a0,1402 # 80017c08 <bcache>
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	5a4080e7          	jalr	1444(ra) # 80000c3a <acquire>
  b->refcnt--;
    8000369e:	40bc                	lw	a5,64(s1)
    800036a0:	37fd                	addiw	a5,a5,-1
    800036a2:	0007871b          	sext.w	a4,a5
    800036a6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800036a8:	eb05                	bnez	a4,800036d8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800036aa:	68bc                	ld	a5,80(s1)
    800036ac:	64b8                	ld	a4,72(s1)
    800036ae:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800036b0:	64bc                	ld	a5,72(s1)
    800036b2:	68b8                	ld	a4,80(s1)
    800036b4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800036b6:	0001c797          	auipc	a5,0x1c
    800036ba:	55278793          	addi	a5,a5,1362 # 8001fc08 <bcache+0x8000>
    800036be:	2b87b703          	ld	a4,696(a5)
    800036c2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800036c4:	0001c717          	auipc	a4,0x1c
    800036c8:	7ac70713          	addi	a4,a4,1964 # 8001fe70 <bcache+0x8268>
    800036cc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800036ce:	2b87b703          	ld	a4,696(a5)
    800036d2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800036d4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800036d8:	00014517          	auipc	a0,0x14
    800036dc:	53050513          	addi	a0,a0,1328 # 80017c08 <bcache>
    800036e0:	ffffd097          	auipc	ra,0xffffd
    800036e4:	60e080e7          	jalr	1550(ra) # 80000cee <release>
}
    800036e8:	60e2                	ld	ra,24(sp)
    800036ea:	6442                	ld	s0,16(sp)
    800036ec:	64a2                	ld	s1,8(sp)
    800036ee:	6902                	ld	s2,0(sp)
    800036f0:	6105                	addi	sp,sp,32
    800036f2:	8082                	ret
    panic("brelse");
    800036f4:	00005517          	auipc	a0,0x5
    800036f8:	f0450513          	addi	a0,a0,-252 # 800085f8 <syscalls+0xf8>
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	ed0080e7          	jalr	-304(ra) # 800005cc <panic>

0000000080003704 <bpin>:

void
bpin(struct buf *b) {
    80003704:	1101                	addi	sp,sp,-32
    80003706:	ec06                	sd	ra,24(sp)
    80003708:	e822                	sd	s0,16(sp)
    8000370a:	e426                	sd	s1,8(sp)
    8000370c:	1000                	addi	s0,sp,32
    8000370e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003710:	00014517          	auipc	a0,0x14
    80003714:	4f850513          	addi	a0,a0,1272 # 80017c08 <bcache>
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	522080e7          	jalr	1314(ra) # 80000c3a <acquire>
  b->refcnt++;
    80003720:	40bc                	lw	a5,64(s1)
    80003722:	2785                	addiw	a5,a5,1
    80003724:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003726:	00014517          	auipc	a0,0x14
    8000372a:	4e250513          	addi	a0,a0,1250 # 80017c08 <bcache>
    8000372e:	ffffd097          	auipc	ra,0xffffd
    80003732:	5c0080e7          	jalr	1472(ra) # 80000cee <release>
}
    80003736:	60e2                	ld	ra,24(sp)
    80003738:	6442                	ld	s0,16(sp)
    8000373a:	64a2                	ld	s1,8(sp)
    8000373c:	6105                	addi	sp,sp,32
    8000373e:	8082                	ret

0000000080003740 <bunpin>:

void
bunpin(struct buf *b) {
    80003740:	1101                	addi	sp,sp,-32
    80003742:	ec06                	sd	ra,24(sp)
    80003744:	e822                	sd	s0,16(sp)
    80003746:	e426                	sd	s1,8(sp)
    80003748:	1000                	addi	s0,sp,32
    8000374a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000374c:	00014517          	auipc	a0,0x14
    80003750:	4bc50513          	addi	a0,a0,1212 # 80017c08 <bcache>
    80003754:	ffffd097          	auipc	ra,0xffffd
    80003758:	4e6080e7          	jalr	1254(ra) # 80000c3a <acquire>
  b->refcnt--;
    8000375c:	40bc                	lw	a5,64(s1)
    8000375e:	37fd                	addiw	a5,a5,-1
    80003760:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003762:	00014517          	auipc	a0,0x14
    80003766:	4a650513          	addi	a0,a0,1190 # 80017c08 <bcache>
    8000376a:	ffffd097          	auipc	ra,0xffffd
    8000376e:	584080e7          	jalr	1412(ra) # 80000cee <release>
}
    80003772:	60e2                	ld	ra,24(sp)
    80003774:	6442                	ld	s0,16(sp)
    80003776:	64a2                	ld	s1,8(sp)
    80003778:	6105                	addi	sp,sp,32
    8000377a:	8082                	ret

000000008000377c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000377c:	1101                	addi	sp,sp,-32
    8000377e:	ec06                	sd	ra,24(sp)
    80003780:	e822                	sd	s0,16(sp)
    80003782:	e426                	sd	s1,8(sp)
    80003784:	e04a                	sd	s2,0(sp)
    80003786:	1000                	addi	s0,sp,32
    80003788:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000378a:	00d5d59b          	srliw	a1,a1,0xd
    8000378e:	0001d797          	auipc	a5,0x1d
    80003792:	b567a783          	lw	a5,-1194(a5) # 800202e4 <sb+0x1c>
    80003796:	9dbd                	addw	a1,a1,a5
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	d9e080e7          	jalr	-610(ra) # 80003536 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800037a0:	0074f713          	andi	a4,s1,7
    800037a4:	4785                	li	a5,1
    800037a6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800037aa:	14ce                	slli	s1,s1,0x33
    800037ac:	90d9                	srli	s1,s1,0x36
    800037ae:	00950733          	add	a4,a0,s1
    800037b2:	05874703          	lbu	a4,88(a4)
    800037b6:	00e7f6b3          	and	a3,a5,a4
    800037ba:	c69d                	beqz	a3,800037e8 <bfree+0x6c>
    800037bc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800037be:	94aa                	add	s1,s1,a0
    800037c0:	fff7c793          	not	a5,a5
    800037c4:	8ff9                	and	a5,a5,a4
    800037c6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800037ca:	00001097          	auipc	ra,0x1
    800037ce:	118080e7          	jalr	280(ra) # 800048e2 <log_write>
  brelse(bp);
    800037d2:	854a                	mv	a0,s2
    800037d4:	00000097          	auipc	ra,0x0
    800037d8:	e92080e7          	jalr	-366(ra) # 80003666 <brelse>
}
    800037dc:	60e2                	ld	ra,24(sp)
    800037de:	6442                	ld	s0,16(sp)
    800037e0:	64a2                	ld	s1,8(sp)
    800037e2:	6902                	ld	s2,0(sp)
    800037e4:	6105                	addi	sp,sp,32
    800037e6:	8082                	ret
    panic("freeing free block");
    800037e8:	00005517          	auipc	a0,0x5
    800037ec:	e1850513          	addi	a0,a0,-488 # 80008600 <syscalls+0x100>
    800037f0:	ffffd097          	auipc	ra,0xffffd
    800037f4:	ddc080e7          	jalr	-548(ra) # 800005cc <panic>

00000000800037f8 <balloc>:
{
    800037f8:	711d                	addi	sp,sp,-96
    800037fa:	ec86                	sd	ra,88(sp)
    800037fc:	e8a2                	sd	s0,80(sp)
    800037fe:	e4a6                	sd	s1,72(sp)
    80003800:	e0ca                	sd	s2,64(sp)
    80003802:	fc4e                	sd	s3,56(sp)
    80003804:	f852                	sd	s4,48(sp)
    80003806:	f456                	sd	s5,40(sp)
    80003808:	f05a                	sd	s6,32(sp)
    8000380a:	ec5e                	sd	s7,24(sp)
    8000380c:	e862                	sd	s8,16(sp)
    8000380e:	e466                	sd	s9,8(sp)
    80003810:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003812:	0001d797          	auipc	a5,0x1d
    80003816:	aba7a783          	lw	a5,-1350(a5) # 800202cc <sb+0x4>
    8000381a:	cbd1                	beqz	a5,800038ae <balloc+0xb6>
    8000381c:	8baa                	mv	s7,a0
    8000381e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003820:	0001db17          	auipc	s6,0x1d
    80003824:	aa8b0b13          	addi	s6,s6,-1368 # 800202c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003828:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000382a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000382c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000382e:	6c89                	lui	s9,0x2
    80003830:	a831                	j	8000384c <balloc+0x54>
    brelse(bp);
    80003832:	854a                	mv	a0,s2
    80003834:	00000097          	auipc	ra,0x0
    80003838:	e32080e7          	jalr	-462(ra) # 80003666 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000383c:	015c87bb          	addw	a5,s9,s5
    80003840:	00078a9b          	sext.w	s5,a5
    80003844:	004b2703          	lw	a4,4(s6)
    80003848:	06eaf363          	bgeu	s5,a4,800038ae <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000384c:	41fad79b          	sraiw	a5,s5,0x1f
    80003850:	0137d79b          	srliw	a5,a5,0x13
    80003854:	015787bb          	addw	a5,a5,s5
    80003858:	40d7d79b          	sraiw	a5,a5,0xd
    8000385c:	01cb2583          	lw	a1,28(s6)
    80003860:	9dbd                	addw	a1,a1,a5
    80003862:	855e                	mv	a0,s7
    80003864:	00000097          	auipc	ra,0x0
    80003868:	cd2080e7          	jalr	-814(ra) # 80003536 <bread>
    8000386c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000386e:	004b2503          	lw	a0,4(s6)
    80003872:	000a849b          	sext.w	s1,s5
    80003876:	8662                	mv	a2,s8
    80003878:	faa4fde3          	bgeu	s1,a0,80003832 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000387c:	41f6579b          	sraiw	a5,a2,0x1f
    80003880:	01d7d69b          	srliw	a3,a5,0x1d
    80003884:	00c6873b          	addw	a4,a3,a2
    80003888:	00777793          	andi	a5,a4,7
    8000388c:	9f95                	subw	a5,a5,a3
    8000388e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003892:	4037571b          	sraiw	a4,a4,0x3
    80003896:	00e906b3          	add	a3,s2,a4
    8000389a:	0586c683          	lbu	a3,88(a3)
    8000389e:	00d7f5b3          	and	a1,a5,a3
    800038a2:	cd91                	beqz	a1,800038be <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038a4:	2605                	addiw	a2,a2,1
    800038a6:	2485                	addiw	s1,s1,1
    800038a8:	fd4618e3          	bne	a2,s4,80003878 <balloc+0x80>
    800038ac:	b759                	j	80003832 <balloc+0x3a>
  panic("balloc: out of blocks");
    800038ae:	00005517          	auipc	a0,0x5
    800038b2:	d6a50513          	addi	a0,a0,-662 # 80008618 <syscalls+0x118>
    800038b6:	ffffd097          	auipc	ra,0xffffd
    800038ba:	d16080e7          	jalr	-746(ra) # 800005cc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800038be:	974a                	add	a4,a4,s2
    800038c0:	8fd5                	or	a5,a5,a3
    800038c2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800038c6:	854a                	mv	a0,s2
    800038c8:	00001097          	auipc	ra,0x1
    800038cc:	01a080e7          	jalr	26(ra) # 800048e2 <log_write>
        brelse(bp);
    800038d0:	854a                	mv	a0,s2
    800038d2:	00000097          	auipc	ra,0x0
    800038d6:	d94080e7          	jalr	-620(ra) # 80003666 <brelse>
  bp = bread(dev, bno);
    800038da:	85a6                	mv	a1,s1
    800038dc:	855e                	mv	a0,s7
    800038de:	00000097          	auipc	ra,0x0
    800038e2:	c58080e7          	jalr	-936(ra) # 80003536 <bread>
    800038e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800038e8:	40000613          	li	a2,1024
    800038ec:	4581                	li	a1,0
    800038ee:	05850513          	addi	a0,a0,88
    800038f2:	ffffd097          	auipc	ra,0xffffd
    800038f6:	444080e7          	jalr	1092(ra) # 80000d36 <memset>
  log_write(bp);
    800038fa:	854a                	mv	a0,s2
    800038fc:	00001097          	auipc	ra,0x1
    80003900:	fe6080e7          	jalr	-26(ra) # 800048e2 <log_write>
  brelse(bp);
    80003904:	854a                	mv	a0,s2
    80003906:	00000097          	auipc	ra,0x0
    8000390a:	d60080e7          	jalr	-672(ra) # 80003666 <brelse>
}
    8000390e:	8526                	mv	a0,s1
    80003910:	60e6                	ld	ra,88(sp)
    80003912:	6446                	ld	s0,80(sp)
    80003914:	64a6                	ld	s1,72(sp)
    80003916:	6906                	ld	s2,64(sp)
    80003918:	79e2                	ld	s3,56(sp)
    8000391a:	7a42                	ld	s4,48(sp)
    8000391c:	7aa2                	ld	s5,40(sp)
    8000391e:	7b02                	ld	s6,32(sp)
    80003920:	6be2                	ld	s7,24(sp)
    80003922:	6c42                	ld	s8,16(sp)
    80003924:	6ca2                	ld	s9,8(sp)
    80003926:	6125                	addi	sp,sp,96
    80003928:	8082                	ret

000000008000392a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000392a:	7179                	addi	sp,sp,-48
    8000392c:	f406                	sd	ra,40(sp)
    8000392e:	f022                	sd	s0,32(sp)
    80003930:	ec26                	sd	s1,24(sp)
    80003932:	e84a                	sd	s2,16(sp)
    80003934:	e44e                	sd	s3,8(sp)
    80003936:	e052                	sd	s4,0(sp)
    80003938:	1800                	addi	s0,sp,48
    8000393a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000393c:	47ad                	li	a5,11
    8000393e:	04b7fe63          	bgeu	a5,a1,8000399a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003942:	ff45849b          	addiw	s1,a1,-12
    80003946:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000394a:	0ff00793          	li	a5,255
    8000394e:	0ae7e363          	bltu	a5,a4,800039f4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003952:	08052583          	lw	a1,128(a0)
    80003956:	c5ad                	beqz	a1,800039c0 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003958:	00092503          	lw	a0,0(s2)
    8000395c:	00000097          	auipc	ra,0x0
    80003960:	bda080e7          	jalr	-1062(ra) # 80003536 <bread>
    80003964:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003966:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000396a:	02049593          	slli	a1,s1,0x20
    8000396e:	9181                	srli	a1,a1,0x20
    80003970:	058a                	slli	a1,a1,0x2
    80003972:	00b784b3          	add	s1,a5,a1
    80003976:	0004a983          	lw	s3,0(s1)
    8000397a:	04098d63          	beqz	s3,800039d4 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000397e:	8552                	mv	a0,s4
    80003980:	00000097          	auipc	ra,0x0
    80003984:	ce6080e7          	jalr	-794(ra) # 80003666 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003988:	854e                	mv	a0,s3
    8000398a:	70a2                	ld	ra,40(sp)
    8000398c:	7402                	ld	s0,32(sp)
    8000398e:	64e2                	ld	s1,24(sp)
    80003990:	6942                	ld	s2,16(sp)
    80003992:	69a2                	ld	s3,8(sp)
    80003994:	6a02                	ld	s4,0(sp)
    80003996:	6145                	addi	sp,sp,48
    80003998:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000399a:	02059493          	slli	s1,a1,0x20
    8000399e:	9081                	srli	s1,s1,0x20
    800039a0:	048a                	slli	s1,s1,0x2
    800039a2:	94aa                	add	s1,s1,a0
    800039a4:	0504a983          	lw	s3,80(s1)
    800039a8:	fe0990e3          	bnez	s3,80003988 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800039ac:	4108                	lw	a0,0(a0)
    800039ae:	00000097          	auipc	ra,0x0
    800039b2:	e4a080e7          	jalr	-438(ra) # 800037f8 <balloc>
    800039b6:	0005099b          	sext.w	s3,a0
    800039ba:	0534a823          	sw	s3,80(s1)
    800039be:	b7e9                	j	80003988 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800039c0:	4108                	lw	a0,0(a0)
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	e36080e7          	jalr	-458(ra) # 800037f8 <balloc>
    800039ca:	0005059b          	sext.w	a1,a0
    800039ce:	08b92023          	sw	a1,128(s2)
    800039d2:	b759                	j	80003958 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800039d4:	00092503          	lw	a0,0(s2)
    800039d8:	00000097          	auipc	ra,0x0
    800039dc:	e20080e7          	jalr	-480(ra) # 800037f8 <balloc>
    800039e0:	0005099b          	sext.w	s3,a0
    800039e4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800039e8:	8552                	mv	a0,s4
    800039ea:	00001097          	auipc	ra,0x1
    800039ee:	ef8080e7          	jalr	-264(ra) # 800048e2 <log_write>
    800039f2:	b771                	j	8000397e <bmap+0x54>
  panic("bmap: out of range");
    800039f4:	00005517          	auipc	a0,0x5
    800039f8:	c3c50513          	addi	a0,a0,-964 # 80008630 <syscalls+0x130>
    800039fc:	ffffd097          	auipc	ra,0xffffd
    80003a00:	bd0080e7          	jalr	-1072(ra) # 800005cc <panic>

0000000080003a04 <iget>:
{
    80003a04:	7179                	addi	sp,sp,-48
    80003a06:	f406                	sd	ra,40(sp)
    80003a08:	f022                	sd	s0,32(sp)
    80003a0a:	ec26                	sd	s1,24(sp)
    80003a0c:	e84a                	sd	s2,16(sp)
    80003a0e:	e44e                	sd	s3,8(sp)
    80003a10:	e052                	sd	s4,0(sp)
    80003a12:	1800                	addi	s0,sp,48
    80003a14:	89aa                	mv	s3,a0
    80003a16:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003a18:	0001d517          	auipc	a0,0x1d
    80003a1c:	8d050513          	addi	a0,a0,-1840 # 800202e8 <itable>
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	21a080e7          	jalr	538(ra) # 80000c3a <acquire>
  empty = 0;
    80003a28:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a2a:	0001d497          	auipc	s1,0x1d
    80003a2e:	8d648493          	addi	s1,s1,-1834 # 80020300 <itable+0x18>
    80003a32:	0001e697          	auipc	a3,0x1e
    80003a36:	35e68693          	addi	a3,a3,862 # 80021d90 <log>
    80003a3a:	a039                	j	80003a48 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a3c:	02090b63          	beqz	s2,80003a72 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a40:	08848493          	addi	s1,s1,136
    80003a44:	02d48a63          	beq	s1,a3,80003a78 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003a48:	449c                	lw	a5,8(s1)
    80003a4a:	fef059e3          	blez	a5,80003a3c <iget+0x38>
    80003a4e:	4098                	lw	a4,0(s1)
    80003a50:	ff3716e3          	bne	a4,s3,80003a3c <iget+0x38>
    80003a54:	40d8                	lw	a4,4(s1)
    80003a56:	ff4713e3          	bne	a4,s4,80003a3c <iget+0x38>
      ip->ref++;
    80003a5a:	2785                	addiw	a5,a5,1
    80003a5c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003a5e:	0001d517          	auipc	a0,0x1d
    80003a62:	88a50513          	addi	a0,a0,-1910 # 800202e8 <itable>
    80003a66:	ffffd097          	auipc	ra,0xffffd
    80003a6a:	288080e7          	jalr	648(ra) # 80000cee <release>
      return ip;
    80003a6e:	8926                	mv	s2,s1
    80003a70:	a03d                	j	80003a9e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a72:	f7f9                	bnez	a5,80003a40 <iget+0x3c>
    80003a74:	8926                	mv	s2,s1
    80003a76:	b7e9                	j	80003a40 <iget+0x3c>
  if(empty == 0)
    80003a78:	02090c63          	beqz	s2,80003ab0 <iget+0xac>
  ip->dev = dev;
    80003a7c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a80:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a84:	4785                	li	a5,1
    80003a86:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a8a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003a8e:	0001d517          	auipc	a0,0x1d
    80003a92:	85a50513          	addi	a0,a0,-1958 # 800202e8 <itable>
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	258080e7          	jalr	600(ra) # 80000cee <release>
}
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	70a2                	ld	ra,40(sp)
    80003aa2:	7402                	ld	s0,32(sp)
    80003aa4:	64e2                	ld	s1,24(sp)
    80003aa6:	6942                	ld	s2,16(sp)
    80003aa8:	69a2                	ld	s3,8(sp)
    80003aaa:	6a02                	ld	s4,0(sp)
    80003aac:	6145                	addi	sp,sp,48
    80003aae:	8082                	ret
    panic("iget: no inodes");
    80003ab0:	00005517          	auipc	a0,0x5
    80003ab4:	b9850513          	addi	a0,a0,-1128 # 80008648 <syscalls+0x148>
    80003ab8:	ffffd097          	auipc	ra,0xffffd
    80003abc:	b14080e7          	jalr	-1260(ra) # 800005cc <panic>

0000000080003ac0 <fsinit>:
fsinit(int dev) {
    80003ac0:	7179                	addi	sp,sp,-48
    80003ac2:	f406                	sd	ra,40(sp)
    80003ac4:	f022                	sd	s0,32(sp)
    80003ac6:	ec26                	sd	s1,24(sp)
    80003ac8:	e84a                	sd	s2,16(sp)
    80003aca:	e44e                	sd	s3,8(sp)
    80003acc:	1800                	addi	s0,sp,48
    80003ace:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003ad0:	4585                	li	a1,1
    80003ad2:	00000097          	auipc	ra,0x0
    80003ad6:	a64080e7          	jalr	-1436(ra) # 80003536 <bread>
    80003ada:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003adc:	0001c997          	auipc	s3,0x1c
    80003ae0:	7ec98993          	addi	s3,s3,2028 # 800202c8 <sb>
    80003ae4:	02000613          	li	a2,32
    80003ae8:	05850593          	addi	a1,a0,88
    80003aec:	854e                	mv	a0,s3
    80003aee:	ffffd097          	auipc	ra,0xffffd
    80003af2:	2a4080e7          	jalr	676(ra) # 80000d92 <memmove>
  brelse(bp);
    80003af6:	8526                	mv	a0,s1
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	b6e080e7          	jalr	-1170(ra) # 80003666 <brelse>
  if(sb.magic != FSMAGIC)
    80003b00:	0009a703          	lw	a4,0(s3)
    80003b04:	102037b7          	lui	a5,0x10203
    80003b08:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b0c:	02f71263          	bne	a4,a5,80003b30 <fsinit+0x70>
  initlog(dev, &sb);
    80003b10:	0001c597          	auipc	a1,0x1c
    80003b14:	7b858593          	addi	a1,a1,1976 # 800202c8 <sb>
    80003b18:	854a                	mv	a0,s2
    80003b1a:	00001097          	auipc	ra,0x1
    80003b1e:	b4c080e7          	jalr	-1204(ra) # 80004666 <initlog>
}
    80003b22:	70a2                	ld	ra,40(sp)
    80003b24:	7402                	ld	s0,32(sp)
    80003b26:	64e2                	ld	s1,24(sp)
    80003b28:	6942                	ld	s2,16(sp)
    80003b2a:	69a2                	ld	s3,8(sp)
    80003b2c:	6145                	addi	sp,sp,48
    80003b2e:	8082                	ret
    panic("invalid file system");
    80003b30:	00005517          	auipc	a0,0x5
    80003b34:	b2850513          	addi	a0,a0,-1240 # 80008658 <syscalls+0x158>
    80003b38:	ffffd097          	auipc	ra,0xffffd
    80003b3c:	a94080e7          	jalr	-1388(ra) # 800005cc <panic>

0000000080003b40 <iinit>:
{
    80003b40:	7179                	addi	sp,sp,-48
    80003b42:	f406                	sd	ra,40(sp)
    80003b44:	f022                	sd	s0,32(sp)
    80003b46:	ec26                	sd	s1,24(sp)
    80003b48:	e84a                	sd	s2,16(sp)
    80003b4a:	e44e                	sd	s3,8(sp)
    80003b4c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b4e:	00005597          	auipc	a1,0x5
    80003b52:	b2258593          	addi	a1,a1,-1246 # 80008670 <syscalls+0x170>
    80003b56:	0001c517          	auipc	a0,0x1c
    80003b5a:	79250513          	addi	a0,a0,1938 # 800202e8 <itable>
    80003b5e:	ffffd097          	auipc	ra,0xffffd
    80003b62:	04c080e7          	jalr	76(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b66:	0001c497          	auipc	s1,0x1c
    80003b6a:	7aa48493          	addi	s1,s1,1962 # 80020310 <itable+0x28>
    80003b6e:	0001e997          	auipc	s3,0x1e
    80003b72:	23298993          	addi	s3,s3,562 # 80021da0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b76:	00005917          	auipc	s2,0x5
    80003b7a:	b0290913          	addi	s2,s2,-1278 # 80008678 <syscalls+0x178>
    80003b7e:	85ca                	mv	a1,s2
    80003b80:	8526                	mv	a0,s1
    80003b82:	00001097          	auipc	ra,0x1
    80003b86:	e46080e7          	jalr	-442(ra) # 800049c8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b8a:	08848493          	addi	s1,s1,136
    80003b8e:	ff3498e3          	bne	s1,s3,80003b7e <iinit+0x3e>
}
    80003b92:	70a2                	ld	ra,40(sp)
    80003b94:	7402                	ld	s0,32(sp)
    80003b96:	64e2                	ld	s1,24(sp)
    80003b98:	6942                	ld	s2,16(sp)
    80003b9a:	69a2                	ld	s3,8(sp)
    80003b9c:	6145                	addi	sp,sp,48
    80003b9e:	8082                	ret

0000000080003ba0 <ialloc>:
{
    80003ba0:	715d                	addi	sp,sp,-80
    80003ba2:	e486                	sd	ra,72(sp)
    80003ba4:	e0a2                	sd	s0,64(sp)
    80003ba6:	fc26                	sd	s1,56(sp)
    80003ba8:	f84a                	sd	s2,48(sp)
    80003baa:	f44e                	sd	s3,40(sp)
    80003bac:	f052                	sd	s4,32(sp)
    80003bae:	ec56                	sd	s5,24(sp)
    80003bb0:	e85a                	sd	s6,16(sp)
    80003bb2:	e45e                	sd	s7,8(sp)
    80003bb4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003bb6:	0001c717          	auipc	a4,0x1c
    80003bba:	71e72703          	lw	a4,1822(a4) # 800202d4 <sb+0xc>
    80003bbe:	4785                	li	a5,1
    80003bc0:	04e7fa63          	bgeu	a5,a4,80003c14 <ialloc+0x74>
    80003bc4:	8aaa                	mv	s5,a0
    80003bc6:	8bae                	mv	s7,a1
    80003bc8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003bca:	0001ca17          	auipc	s4,0x1c
    80003bce:	6fea0a13          	addi	s4,s4,1790 # 800202c8 <sb>
    80003bd2:	00048b1b          	sext.w	s6,s1
    80003bd6:	0044d793          	srli	a5,s1,0x4
    80003bda:	018a2583          	lw	a1,24(s4)
    80003bde:	9dbd                	addw	a1,a1,a5
    80003be0:	8556                	mv	a0,s5
    80003be2:	00000097          	auipc	ra,0x0
    80003be6:	954080e7          	jalr	-1708(ra) # 80003536 <bread>
    80003bea:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003bec:	05850993          	addi	s3,a0,88
    80003bf0:	00f4f793          	andi	a5,s1,15
    80003bf4:	079a                	slli	a5,a5,0x6
    80003bf6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003bf8:	00099783          	lh	a5,0(s3)
    80003bfc:	c785                	beqz	a5,80003c24 <ialloc+0x84>
    brelse(bp);
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	a68080e7          	jalr	-1432(ra) # 80003666 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c06:	0485                	addi	s1,s1,1
    80003c08:	00ca2703          	lw	a4,12(s4)
    80003c0c:	0004879b          	sext.w	a5,s1
    80003c10:	fce7e1e3          	bltu	a5,a4,80003bd2 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003c14:	00005517          	auipc	a0,0x5
    80003c18:	a6c50513          	addi	a0,a0,-1428 # 80008680 <syscalls+0x180>
    80003c1c:	ffffd097          	auipc	ra,0xffffd
    80003c20:	9b0080e7          	jalr	-1616(ra) # 800005cc <panic>
      memset(dip, 0, sizeof(*dip));
    80003c24:	04000613          	li	a2,64
    80003c28:	4581                	li	a1,0
    80003c2a:	854e                	mv	a0,s3
    80003c2c:	ffffd097          	auipc	ra,0xffffd
    80003c30:	10a080e7          	jalr	266(ra) # 80000d36 <memset>
      dip->type = type;
    80003c34:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c38:	854a                	mv	a0,s2
    80003c3a:	00001097          	auipc	ra,0x1
    80003c3e:	ca8080e7          	jalr	-856(ra) # 800048e2 <log_write>
      brelse(bp);
    80003c42:	854a                	mv	a0,s2
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	a22080e7          	jalr	-1502(ra) # 80003666 <brelse>
      return iget(dev, inum);
    80003c4c:	85da                	mv	a1,s6
    80003c4e:	8556                	mv	a0,s5
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	db4080e7          	jalr	-588(ra) # 80003a04 <iget>
}
    80003c58:	60a6                	ld	ra,72(sp)
    80003c5a:	6406                	ld	s0,64(sp)
    80003c5c:	74e2                	ld	s1,56(sp)
    80003c5e:	7942                	ld	s2,48(sp)
    80003c60:	79a2                	ld	s3,40(sp)
    80003c62:	7a02                	ld	s4,32(sp)
    80003c64:	6ae2                	ld	s5,24(sp)
    80003c66:	6b42                	ld	s6,16(sp)
    80003c68:	6ba2                	ld	s7,8(sp)
    80003c6a:	6161                	addi	sp,sp,80
    80003c6c:	8082                	ret

0000000080003c6e <iupdate>:
{
    80003c6e:	1101                	addi	sp,sp,-32
    80003c70:	ec06                	sd	ra,24(sp)
    80003c72:	e822                	sd	s0,16(sp)
    80003c74:	e426                	sd	s1,8(sp)
    80003c76:	e04a                	sd	s2,0(sp)
    80003c78:	1000                	addi	s0,sp,32
    80003c7a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c7c:	415c                	lw	a5,4(a0)
    80003c7e:	0047d79b          	srliw	a5,a5,0x4
    80003c82:	0001c597          	auipc	a1,0x1c
    80003c86:	65e5a583          	lw	a1,1630(a1) # 800202e0 <sb+0x18>
    80003c8a:	9dbd                	addw	a1,a1,a5
    80003c8c:	4108                	lw	a0,0(a0)
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	8a8080e7          	jalr	-1880(ra) # 80003536 <bread>
    80003c96:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c98:	05850793          	addi	a5,a0,88
    80003c9c:	40c8                	lw	a0,4(s1)
    80003c9e:	893d                	andi	a0,a0,15
    80003ca0:	051a                	slli	a0,a0,0x6
    80003ca2:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003ca4:	04449703          	lh	a4,68(s1)
    80003ca8:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003cac:	04649703          	lh	a4,70(s1)
    80003cb0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003cb4:	04849703          	lh	a4,72(s1)
    80003cb8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003cbc:	04a49703          	lh	a4,74(s1)
    80003cc0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003cc4:	44f8                	lw	a4,76(s1)
    80003cc6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003cc8:	03400613          	li	a2,52
    80003ccc:	05048593          	addi	a1,s1,80
    80003cd0:	0531                	addi	a0,a0,12
    80003cd2:	ffffd097          	auipc	ra,0xffffd
    80003cd6:	0c0080e7          	jalr	192(ra) # 80000d92 <memmove>
  log_write(bp);
    80003cda:	854a                	mv	a0,s2
    80003cdc:	00001097          	auipc	ra,0x1
    80003ce0:	c06080e7          	jalr	-1018(ra) # 800048e2 <log_write>
  brelse(bp);
    80003ce4:	854a                	mv	a0,s2
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	980080e7          	jalr	-1664(ra) # 80003666 <brelse>
}
    80003cee:	60e2                	ld	ra,24(sp)
    80003cf0:	6442                	ld	s0,16(sp)
    80003cf2:	64a2                	ld	s1,8(sp)
    80003cf4:	6902                	ld	s2,0(sp)
    80003cf6:	6105                	addi	sp,sp,32
    80003cf8:	8082                	ret

0000000080003cfa <idup>:
{
    80003cfa:	1101                	addi	sp,sp,-32
    80003cfc:	ec06                	sd	ra,24(sp)
    80003cfe:	e822                	sd	s0,16(sp)
    80003d00:	e426                	sd	s1,8(sp)
    80003d02:	1000                	addi	s0,sp,32
    80003d04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d06:	0001c517          	auipc	a0,0x1c
    80003d0a:	5e250513          	addi	a0,a0,1506 # 800202e8 <itable>
    80003d0e:	ffffd097          	auipc	ra,0xffffd
    80003d12:	f2c080e7          	jalr	-212(ra) # 80000c3a <acquire>
  ip->ref++;
    80003d16:	449c                	lw	a5,8(s1)
    80003d18:	2785                	addiw	a5,a5,1
    80003d1a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d1c:	0001c517          	auipc	a0,0x1c
    80003d20:	5cc50513          	addi	a0,a0,1484 # 800202e8 <itable>
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	fca080e7          	jalr	-54(ra) # 80000cee <release>
}
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	60e2                	ld	ra,24(sp)
    80003d30:	6442                	ld	s0,16(sp)
    80003d32:	64a2                	ld	s1,8(sp)
    80003d34:	6105                	addi	sp,sp,32
    80003d36:	8082                	ret

0000000080003d38 <ilock>:
{
    80003d38:	1101                	addi	sp,sp,-32
    80003d3a:	ec06                	sd	ra,24(sp)
    80003d3c:	e822                	sd	s0,16(sp)
    80003d3e:	e426                	sd	s1,8(sp)
    80003d40:	e04a                	sd	s2,0(sp)
    80003d42:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d44:	c115                	beqz	a0,80003d68 <ilock+0x30>
    80003d46:	84aa                	mv	s1,a0
    80003d48:	451c                	lw	a5,8(a0)
    80003d4a:	00f05f63          	blez	a5,80003d68 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003d4e:	0541                	addi	a0,a0,16
    80003d50:	00001097          	auipc	ra,0x1
    80003d54:	cb2080e7          	jalr	-846(ra) # 80004a02 <acquiresleep>
  if(ip->valid == 0){
    80003d58:	40bc                	lw	a5,64(s1)
    80003d5a:	cf99                	beqz	a5,80003d78 <ilock+0x40>
}
    80003d5c:	60e2                	ld	ra,24(sp)
    80003d5e:	6442                	ld	s0,16(sp)
    80003d60:	64a2                	ld	s1,8(sp)
    80003d62:	6902                	ld	s2,0(sp)
    80003d64:	6105                	addi	sp,sp,32
    80003d66:	8082                	ret
    panic("ilock");
    80003d68:	00005517          	auipc	a0,0x5
    80003d6c:	93050513          	addi	a0,a0,-1744 # 80008698 <syscalls+0x198>
    80003d70:	ffffd097          	auipc	ra,0xffffd
    80003d74:	85c080e7          	jalr	-1956(ra) # 800005cc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d78:	40dc                	lw	a5,4(s1)
    80003d7a:	0047d79b          	srliw	a5,a5,0x4
    80003d7e:	0001c597          	auipc	a1,0x1c
    80003d82:	5625a583          	lw	a1,1378(a1) # 800202e0 <sb+0x18>
    80003d86:	9dbd                	addw	a1,a1,a5
    80003d88:	4088                	lw	a0,0(s1)
    80003d8a:	fffff097          	auipc	ra,0xfffff
    80003d8e:	7ac080e7          	jalr	1964(ra) # 80003536 <bread>
    80003d92:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d94:	05850593          	addi	a1,a0,88
    80003d98:	40dc                	lw	a5,4(s1)
    80003d9a:	8bbd                	andi	a5,a5,15
    80003d9c:	079a                	slli	a5,a5,0x6
    80003d9e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003da0:	00059783          	lh	a5,0(a1)
    80003da4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003da8:	00259783          	lh	a5,2(a1)
    80003dac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003db0:	00459783          	lh	a5,4(a1)
    80003db4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003db8:	00659783          	lh	a5,6(a1)
    80003dbc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003dc0:	459c                	lw	a5,8(a1)
    80003dc2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003dc4:	03400613          	li	a2,52
    80003dc8:	05b1                	addi	a1,a1,12
    80003dca:	05048513          	addi	a0,s1,80
    80003dce:	ffffd097          	auipc	ra,0xffffd
    80003dd2:	fc4080e7          	jalr	-60(ra) # 80000d92 <memmove>
    brelse(bp);
    80003dd6:	854a                	mv	a0,s2
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	88e080e7          	jalr	-1906(ra) # 80003666 <brelse>
    ip->valid = 1;
    80003de0:	4785                	li	a5,1
    80003de2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003de4:	04449783          	lh	a5,68(s1)
    80003de8:	fbb5                	bnez	a5,80003d5c <ilock+0x24>
      panic("ilock: no type");
    80003dea:	00005517          	auipc	a0,0x5
    80003dee:	8b650513          	addi	a0,a0,-1866 # 800086a0 <syscalls+0x1a0>
    80003df2:	ffffc097          	auipc	ra,0xffffc
    80003df6:	7da080e7          	jalr	2010(ra) # 800005cc <panic>

0000000080003dfa <iunlock>:
{
    80003dfa:	1101                	addi	sp,sp,-32
    80003dfc:	ec06                	sd	ra,24(sp)
    80003dfe:	e822                	sd	s0,16(sp)
    80003e00:	e426                	sd	s1,8(sp)
    80003e02:	e04a                	sd	s2,0(sp)
    80003e04:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e06:	c905                	beqz	a0,80003e36 <iunlock+0x3c>
    80003e08:	84aa                	mv	s1,a0
    80003e0a:	01050913          	addi	s2,a0,16
    80003e0e:	854a                	mv	a0,s2
    80003e10:	00001097          	auipc	ra,0x1
    80003e14:	c8c080e7          	jalr	-884(ra) # 80004a9c <holdingsleep>
    80003e18:	cd19                	beqz	a0,80003e36 <iunlock+0x3c>
    80003e1a:	449c                	lw	a5,8(s1)
    80003e1c:	00f05d63          	blez	a5,80003e36 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003e20:	854a                	mv	a0,s2
    80003e22:	00001097          	auipc	ra,0x1
    80003e26:	c36080e7          	jalr	-970(ra) # 80004a58 <releasesleep>
}
    80003e2a:	60e2                	ld	ra,24(sp)
    80003e2c:	6442                	ld	s0,16(sp)
    80003e2e:	64a2                	ld	s1,8(sp)
    80003e30:	6902                	ld	s2,0(sp)
    80003e32:	6105                	addi	sp,sp,32
    80003e34:	8082                	ret
    panic("iunlock");
    80003e36:	00005517          	auipc	a0,0x5
    80003e3a:	87a50513          	addi	a0,a0,-1926 # 800086b0 <syscalls+0x1b0>
    80003e3e:	ffffc097          	auipc	ra,0xffffc
    80003e42:	78e080e7          	jalr	1934(ra) # 800005cc <panic>

0000000080003e46 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e46:	7179                	addi	sp,sp,-48
    80003e48:	f406                	sd	ra,40(sp)
    80003e4a:	f022                	sd	s0,32(sp)
    80003e4c:	ec26                	sd	s1,24(sp)
    80003e4e:	e84a                	sd	s2,16(sp)
    80003e50:	e44e                	sd	s3,8(sp)
    80003e52:	e052                	sd	s4,0(sp)
    80003e54:	1800                	addi	s0,sp,48
    80003e56:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e58:	05050493          	addi	s1,a0,80
    80003e5c:	08050913          	addi	s2,a0,128
    80003e60:	a021                	j	80003e68 <itrunc+0x22>
    80003e62:	0491                	addi	s1,s1,4
    80003e64:	01248d63          	beq	s1,s2,80003e7e <itrunc+0x38>
    if(ip->addrs[i]){
    80003e68:	408c                	lw	a1,0(s1)
    80003e6a:	dde5                	beqz	a1,80003e62 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003e6c:	0009a503          	lw	a0,0(s3)
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	90c080e7          	jalr	-1780(ra) # 8000377c <bfree>
      ip->addrs[i] = 0;
    80003e78:	0004a023          	sw	zero,0(s1)
    80003e7c:	b7dd                	j	80003e62 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e7e:	0809a583          	lw	a1,128(s3)
    80003e82:	e185                	bnez	a1,80003ea2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e84:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e88:	854e                	mv	a0,s3
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	de4080e7          	jalr	-540(ra) # 80003c6e <iupdate>
}
    80003e92:	70a2                	ld	ra,40(sp)
    80003e94:	7402                	ld	s0,32(sp)
    80003e96:	64e2                	ld	s1,24(sp)
    80003e98:	6942                	ld	s2,16(sp)
    80003e9a:	69a2                	ld	s3,8(sp)
    80003e9c:	6a02                	ld	s4,0(sp)
    80003e9e:	6145                	addi	sp,sp,48
    80003ea0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ea2:	0009a503          	lw	a0,0(s3)
    80003ea6:	fffff097          	auipc	ra,0xfffff
    80003eaa:	690080e7          	jalr	1680(ra) # 80003536 <bread>
    80003eae:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003eb0:	05850493          	addi	s1,a0,88
    80003eb4:	45850913          	addi	s2,a0,1112
    80003eb8:	a021                	j	80003ec0 <itrunc+0x7a>
    80003eba:	0491                	addi	s1,s1,4
    80003ebc:	01248b63          	beq	s1,s2,80003ed2 <itrunc+0x8c>
      if(a[j])
    80003ec0:	408c                	lw	a1,0(s1)
    80003ec2:	dde5                	beqz	a1,80003eba <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003ec4:	0009a503          	lw	a0,0(s3)
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	8b4080e7          	jalr	-1868(ra) # 8000377c <bfree>
    80003ed0:	b7ed                	j	80003eba <itrunc+0x74>
    brelse(bp);
    80003ed2:	8552                	mv	a0,s4
    80003ed4:	fffff097          	auipc	ra,0xfffff
    80003ed8:	792080e7          	jalr	1938(ra) # 80003666 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003edc:	0809a583          	lw	a1,128(s3)
    80003ee0:	0009a503          	lw	a0,0(s3)
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	898080e7          	jalr	-1896(ra) # 8000377c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003eec:	0809a023          	sw	zero,128(s3)
    80003ef0:	bf51                	j	80003e84 <itrunc+0x3e>

0000000080003ef2 <iput>:
{
    80003ef2:	1101                	addi	sp,sp,-32
    80003ef4:	ec06                	sd	ra,24(sp)
    80003ef6:	e822                	sd	s0,16(sp)
    80003ef8:	e426                	sd	s1,8(sp)
    80003efa:	e04a                	sd	s2,0(sp)
    80003efc:	1000                	addi	s0,sp,32
    80003efe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f00:	0001c517          	auipc	a0,0x1c
    80003f04:	3e850513          	addi	a0,a0,1000 # 800202e8 <itable>
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	d32080e7          	jalr	-718(ra) # 80000c3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f10:	4498                	lw	a4,8(s1)
    80003f12:	4785                	li	a5,1
    80003f14:	02f70363          	beq	a4,a5,80003f3a <iput+0x48>
  ip->ref--;
    80003f18:	449c                	lw	a5,8(s1)
    80003f1a:	37fd                	addiw	a5,a5,-1
    80003f1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f1e:	0001c517          	auipc	a0,0x1c
    80003f22:	3ca50513          	addi	a0,a0,970 # 800202e8 <itable>
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	dc8080e7          	jalr	-568(ra) # 80000cee <release>
}
    80003f2e:	60e2                	ld	ra,24(sp)
    80003f30:	6442                	ld	s0,16(sp)
    80003f32:	64a2                	ld	s1,8(sp)
    80003f34:	6902                	ld	s2,0(sp)
    80003f36:	6105                	addi	sp,sp,32
    80003f38:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f3a:	40bc                	lw	a5,64(s1)
    80003f3c:	dff1                	beqz	a5,80003f18 <iput+0x26>
    80003f3e:	04a49783          	lh	a5,74(s1)
    80003f42:	fbf9                	bnez	a5,80003f18 <iput+0x26>
    acquiresleep(&ip->lock);
    80003f44:	01048913          	addi	s2,s1,16
    80003f48:	854a                	mv	a0,s2
    80003f4a:	00001097          	auipc	ra,0x1
    80003f4e:	ab8080e7          	jalr	-1352(ra) # 80004a02 <acquiresleep>
    release(&itable.lock);
    80003f52:	0001c517          	auipc	a0,0x1c
    80003f56:	39650513          	addi	a0,a0,918 # 800202e8 <itable>
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	d94080e7          	jalr	-620(ra) # 80000cee <release>
    itrunc(ip);
    80003f62:	8526                	mv	a0,s1
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	ee2080e7          	jalr	-286(ra) # 80003e46 <itrunc>
    ip->type = 0;
    80003f6c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	cfc080e7          	jalr	-772(ra) # 80003c6e <iupdate>
    ip->valid = 0;
    80003f7a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f7e:	854a                	mv	a0,s2
    80003f80:	00001097          	auipc	ra,0x1
    80003f84:	ad8080e7          	jalr	-1320(ra) # 80004a58 <releasesleep>
    acquire(&itable.lock);
    80003f88:	0001c517          	auipc	a0,0x1c
    80003f8c:	36050513          	addi	a0,a0,864 # 800202e8 <itable>
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	caa080e7          	jalr	-854(ra) # 80000c3a <acquire>
    80003f98:	b741                	j	80003f18 <iput+0x26>

0000000080003f9a <iunlockput>:
{
    80003f9a:	1101                	addi	sp,sp,-32
    80003f9c:	ec06                	sd	ra,24(sp)
    80003f9e:	e822                	sd	s0,16(sp)
    80003fa0:	e426                	sd	s1,8(sp)
    80003fa2:	1000                	addi	s0,sp,32
    80003fa4:	84aa                	mv	s1,a0
  iunlock(ip);
    80003fa6:	00000097          	auipc	ra,0x0
    80003faa:	e54080e7          	jalr	-428(ra) # 80003dfa <iunlock>
  iput(ip);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	00000097          	auipc	ra,0x0
    80003fb4:	f42080e7          	jalr	-190(ra) # 80003ef2 <iput>
}
    80003fb8:	60e2                	ld	ra,24(sp)
    80003fba:	6442                	ld	s0,16(sp)
    80003fbc:	64a2                	ld	s1,8(sp)
    80003fbe:	6105                	addi	sp,sp,32
    80003fc0:	8082                	ret

0000000080003fc2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003fc2:	1141                	addi	sp,sp,-16
    80003fc4:	e422                	sd	s0,8(sp)
    80003fc6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003fc8:	411c                	lw	a5,0(a0)
    80003fca:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003fcc:	415c                	lw	a5,4(a0)
    80003fce:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003fd0:	04451783          	lh	a5,68(a0)
    80003fd4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003fd8:	04a51783          	lh	a5,74(a0)
    80003fdc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003fe0:	04c56783          	lwu	a5,76(a0)
    80003fe4:	e99c                	sd	a5,16(a1)
}
    80003fe6:	6422                	ld	s0,8(sp)
    80003fe8:	0141                	addi	sp,sp,16
    80003fea:	8082                	ret

0000000080003fec <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fec:	457c                	lw	a5,76(a0)
    80003fee:	0ed7e963          	bltu	a5,a3,800040e0 <readi+0xf4>
{
    80003ff2:	7159                	addi	sp,sp,-112
    80003ff4:	f486                	sd	ra,104(sp)
    80003ff6:	f0a2                	sd	s0,96(sp)
    80003ff8:	eca6                	sd	s1,88(sp)
    80003ffa:	e8ca                	sd	s2,80(sp)
    80003ffc:	e4ce                	sd	s3,72(sp)
    80003ffe:	e0d2                	sd	s4,64(sp)
    80004000:	fc56                	sd	s5,56(sp)
    80004002:	f85a                	sd	s6,48(sp)
    80004004:	f45e                	sd	s7,40(sp)
    80004006:	f062                	sd	s8,32(sp)
    80004008:	ec66                	sd	s9,24(sp)
    8000400a:	e86a                	sd	s10,16(sp)
    8000400c:	e46e                	sd	s11,8(sp)
    8000400e:	1880                	addi	s0,sp,112
    80004010:	8baa                	mv	s7,a0
    80004012:	8c2e                	mv	s8,a1
    80004014:	8ab2                	mv	s5,a2
    80004016:	84b6                	mv	s1,a3
    80004018:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000401a:	9f35                	addw	a4,a4,a3
    return 0;
    8000401c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000401e:	0ad76063          	bltu	a4,a3,800040be <readi+0xd2>
  if(off + n > ip->size)
    80004022:	00e7f463          	bgeu	a5,a4,8000402a <readi+0x3e>
    n = ip->size - off;
    80004026:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000402a:	0a0b0963          	beqz	s6,800040dc <readi+0xf0>
    8000402e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004030:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004034:	5cfd                	li	s9,-1
    80004036:	a82d                	j	80004070 <readi+0x84>
    80004038:	020a1d93          	slli	s11,s4,0x20
    8000403c:	020ddd93          	srli	s11,s11,0x20
    80004040:	05890793          	addi	a5,s2,88
    80004044:	86ee                	mv	a3,s11
    80004046:	963e                	add	a2,a2,a5
    80004048:	85d6                	mv	a1,s5
    8000404a:	8562                	mv	a0,s8
    8000404c:	fffff097          	auipc	ra,0xfffff
    80004050:	89e080e7          	jalr	-1890(ra) # 800028ea <either_copyout>
    80004054:	05950d63          	beq	a0,s9,800040ae <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004058:	854a                	mv	a0,s2
    8000405a:	fffff097          	auipc	ra,0xfffff
    8000405e:	60c080e7          	jalr	1548(ra) # 80003666 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004062:	013a09bb          	addw	s3,s4,s3
    80004066:	009a04bb          	addw	s1,s4,s1
    8000406a:	9aee                	add	s5,s5,s11
    8000406c:	0569f763          	bgeu	s3,s6,800040ba <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004070:	000ba903          	lw	s2,0(s7)
    80004074:	00a4d59b          	srliw	a1,s1,0xa
    80004078:	855e                	mv	a0,s7
    8000407a:	00000097          	auipc	ra,0x0
    8000407e:	8b0080e7          	jalr	-1872(ra) # 8000392a <bmap>
    80004082:	0005059b          	sext.w	a1,a0
    80004086:	854a                	mv	a0,s2
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	4ae080e7          	jalr	1198(ra) # 80003536 <bread>
    80004090:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004092:	3ff4f613          	andi	a2,s1,1023
    80004096:	40cd07bb          	subw	a5,s10,a2
    8000409a:	413b073b          	subw	a4,s6,s3
    8000409e:	8a3e                	mv	s4,a5
    800040a0:	2781                	sext.w	a5,a5
    800040a2:	0007069b          	sext.w	a3,a4
    800040a6:	f8f6f9e3          	bgeu	a3,a5,80004038 <readi+0x4c>
    800040aa:	8a3a                	mv	s4,a4
    800040ac:	b771                	j	80004038 <readi+0x4c>
      brelse(bp);
    800040ae:	854a                	mv	a0,s2
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	5b6080e7          	jalr	1462(ra) # 80003666 <brelse>
      tot = -1;
    800040b8:	59fd                	li	s3,-1
  }
  return tot;
    800040ba:	0009851b          	sext.w	a0,s3
}
    800040be:	70a6                	ld	ra,104(sp)
    800040c0:	7406                	ld	s0,96(sp)
    800040c2:	64e6                	ld	s1,88(sp)
    800040c4:	6946                	ld	s2,80(sp)
    800040c6:	69a6                	ld	s3,72(sp)
    800040c8:	6a06                	ld	s4,64(sp)
    800040ca:	7ae2                	ld	s5,56(sp)
    800040cc:	7b42                	ld	s6,48(sp)
    800040ce:	7ba2                	ld	s7,40(sp)
    800040d0:	7c02                	ld	s8,32(sp)
    800040d2:	6ce2                	ld	s9,24(sp)
    800040d4:	6d42                	ld	s10,16(sp)
    800040d6:	6da2                	ld	s11,8(sp)
    800040d8:	6165                	addi	sp,sp,112
    800040da:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040dc:	89da                	mv	s3,s6
    800040de:	bff1                	j	800040ba <readi+0xce>
    return 0;
    800040e0:	4501                	li	a0,0
}
    800040e2:	8082                	ret

00000000800040e4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040e4:	457c                	lw	a5,76(a0)
    800040e6:	10d7e863          	bltu	a5,a3,800041f6 <writei+0x112>
{
    800040ea:	7159                	addi	sp,sp,-112
    800040ec:	f486                	sd	ra,104(sp)
    800040ee:	f0a2                	sd	s0,96(sp)
    800040f0:	eca6                	sd	s1,88(sp)
    800040f2:	e8ca                	sd	s2,80(sp)
    800040f4:	e4ce                	sd	s3,72(sp)
    800040f6:	e0d2                	sd	s4,64(sp)
    800040f8:	fc56                	sd	s5,56(sp)
    800040fa:	f85a                	sd	s6,48(sp)
    800040fc:	f45e                	sd	s7,40(sp)
    800040fe:	f062                	sd	s8,32(sp)
    80004100:	ec66                	sd	s9,24(sp)
    80004102:	e86a                	sd	s10,16(sp)
    80004104:	e46e                	sd	s11,8(sp)
    80004106:	1880                	addi	s0,sp,112
    80004108:	8b2a                	mv	s6,a0
    8000410a:	8c2e                	mv	s8,a1
    8000410c:	8ab2                	mv	s5,a2
    8000410e:	8936                	mv	s2,a3
    80004110:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80004112:	00e687bb          	addw	a5,a3,a4
    80004116:	0ed7e263          	bltu	a5,a3,800041fa <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000411a:	00043737          	lui	a4,0x43
    8000411e:	0ef76063          	bltu	a4,a5,800041fe <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004122:	0c0b8863          	beqz	s7,800041f2 <writei+0x10e>
    80004126:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004128:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000412c:	5cfd                	li	s9,-1
    8000412e:	a091                	j	80004172 <writei+0x8e>
    80004130:	02099d93          	slli	s11,s3,0x20
    80004134:	020ddd93          	srli	s11,s11,0x20
    80004138:	05848793          	addi	a5,s1,88
    8000413c:	86ee                	mv	a3,s11
    8000413e:	8656                	mv	a2,s5
    80004140:	85e2                	mv	a1,s8
    80004142:	953e                	add	a0,a0,a5
    80004144:	ffffe097          	auipc	ra,0xffffe
    80004148:	7fc080e7          	jalr	2044(ra) # 80002940 <either_copyin>
    8000414c:	07950263          	beq	a0,s9,800041b0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004150:	8526                	mv	a0,s1
    80004152:	00000097          	auipc	ra,0x0
    80004156:	790080e7          	jalr	1936(ra) # 800048e2 <log_write>
    brelse(bp);
    8000415a:	8526                	mv	a0,s1
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	50a080e7          	jalr	1290(ra) # 80003666 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004164:	01498a3b          	addw	s4,s3,s4
    80004168:	0129893b          	addw	s2,s3,s2
    8000416c:	9aee                	add	s5,s5,s11
    8000416e:	057a7663          	bgeu	s4,s7,800041ba <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004172:	000b2483          	lw	s1,0(s6)
    80004176:	00a9559b          	srliw	a1,s2,0xa
    8000417a:	855a                	mv	a0,s6
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	7ae080e7          	jalr	1966(ra) # 8000392a <bmap>
    80004184:	0005059b          	sext.w	a1,a0
    80004188:	8526                	mv	a0,s1
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	3ac080e7          	jalr	940(ra) # 80003536 <bread>
    80004192:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004194:	3ff97513          	andi	a0,s2,1023
    80004198:	40ad07bb          	subw	a5,s10,a0
    8000419c:	414b873b          	subw	a4,s7,s4
    800041a0:	89be                	mv	s3,a5
    800041a2:	2781                	sext.w	a5,a5
    800041a4:	0007069b          	sext.w	a3,a4
    800041a8:	f8f6f4e3          	bgeu	a3,a5,80004130 <writei+0x4c>
    800041ac:	89ba                	mv	s3,a4
    800041ae:	b749                	j	80004130 <writei+0x4c>
      brelse(bp);
    800041b0:	8526                	mv	a0,s1
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	4b4080e7          	jalr	1204(ra) # 80003666 <brelse>
  }

  if(off > ip->size)
    800041ba:	04cb2783          	lw	a5,76(s6)
    800041be:	0127f463          	bgeu	a5,s2,800041c6 <writei+0xe2>
    ip->size = off;
    800041c2:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800041c6:	855a                	mv	a0,s6
    800041c8:	00000097          	auipc	ra,0x0
    800041cc:	aa6080e7          	jalr	-1370(ra) # 80003c6e <iupdate>

  return tot;
    800041d0:	000a051b          	sext.w	a0,s4
}
    800041d4:	70a6                	ld	ra,104(sp)
    800041d6:	7406                	ld	s0,96(sp)
    800041d8:	64e6                	ld	s1,88(sp)
    800041da:	6946                	ld	s2,80(sp)
    800041dc:	69a6                	ld	s3,72(sp)
    800041de:	6a06                	ld	s4,64(sp)
    800041e0:	7ae2                	ld	s5,56(sp)
    800041e2:	7b42                	ld	s6,48(sp)
    800041e4:	7ba2                	ld	s7,40(sp)
    800041e6:	7c02                	ld	s8,32(sp)
    800041e8:	6ce2                	ld	s9,24(sp)
    800041ea:	6d42                	ld	s10,16(sp)
    800041ec:	6da2                	ld	s11,8(sp)
    800041ee:	6165                	addi	sp,sp,112
    800041f0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041f2:	8a5e                	mv	s4,s7
    800041f4:	bfc9                	j	800041c6 <writei+0xe2>
    return -1;
    800041f6:	557d                	li	a0,-1
}
    800041f8:	8082                	ret
    return -1;
    800041fa:	557d                	li	a0,-1
    800041fc:	bfe1                	j	800041d4 <writei+0xf0>
    return -1;
    800041fe:	557d                	li	a0,-1
    80004200:	bfd1                	j	800041d4 <writei+0xf0>

0000000080004202 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004202:	1141                	addi	sp,sp,-16
    80004204:	e406                	sd	ra,8(sp)
    80004206:	e022                	sd	s0,0(sp)
    80004208:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000420a:	4639                	li	a2,14
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	c02080e7          	jalr	-1022(ra) # 80000e0e <strncmp>
}
    80004214:	60a2                	ld	ra,8(sp)
    80004216:	6402                	ld	s0,0(sp)
    80004218:	0141                	addi	sp,sp,16
    8000421a:	8082                	ret

000000008000421c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000421c:	7139                	addi	sp,sp,-64
    8000421e:	fc06                	sd	ra,56(sp)
    80004220:	f822                	sd	s0,48(sp)
    80004222:	f426                	sd	s1,40(sp)
    80004224:	f04a                	sd	s2,32(sp)
    80004226:	ec4e                	sd	s3,24(sp)
    80004228:	e852                	sd	s4,16(sp)
    8000422a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000422c:	04451703          	lh	a4,68(a0)
    80004230:	4785                	li	a5,1
    80004232:	00f71a63          	bne	a4,a5,80004246 <dirlookup+0x2a>
    80004236:	892a                	mv	s2,a0
    80004238:	89ae                	mv	s3,a1
    8000423a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000423c:	457c                	lw	a5,76(a0)
    8000423e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004240:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004242:	e79d                	bnez	a5,80004270 <dirlookup+0x54>
    80004244:	a8a5                	j	800042bc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004246:	00004517          	auipc	a0,0x4
    8000424a:	47250513          	addi	a0,a0,1138 # 800086b8 <syscalls+0x1b8>
    8000424e:	ffffc097          	auipc	ra,0xffffc
    80004252:	37e080e7          	jalr	894(ra) # 800005cc <panic>
      panic("dirlookup read");
    80004256:	00004517          	auipc	a0,0x4
    8000425a:	47a50513          	addi	a0,a0,1146 # 800086d0 <syscalls+0x1d0>
    8000425e:	ffffc097          	auipc	ra,0xffffc
    80004262:	36e080e7          	jalr	878(ra) # 800005cc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004266:	24c1                	addiw	s1,s1,16
    80004268:	04c92783          	lw	a5,76(s2)
    8000426c:	04f4f763          	bgeu	s1,a5,800042ba <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004270:	4741                	li	a4,16
    80004272:	86a6                	mv	a3,s1
    80004274:	fc040613          	addi	a2,s0,-64
    80004278:	4581                	li	a1,0
    8000427a:	854a                	mv	a0,s2
    8000427c:	00000097          	auipc	ra,0x0
    80004280:	d70080e7          	jalr	-656(ra) # 80003fec <readi>
    80004284:	47c1                	li	a5,16
    80004286:	fcf518e3          	bne	a0,a5,80004256 <dirlookup+0x3a>
    if(de.inum == 0)
    8000428a:	fc045783          	lhu	a5,-64(s0)
    8000428e:	dfe1                	beqz	a5,80004266 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004290:	fc240593          	addi	a1,s0,-62
    80004294:	854e                	mv	a0,s3
    80004296:	00000097          	auipc	ra,0x0
    8000429a:	f6c080e7          	jalr	-148(ra) # 80004202 <namecmp>
    8000429e:	f561                	bnez	a0,80004266 <dirlookup+0x4a>
      if(poff)
    800042a0:	000a0463          	beqz	s4,800042a8 <dirlookup+0x8c>
        *poff = off;
    800042a4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800042a8:	fc045583          	lhu	a1,-64(s0)
    800042ac:	00092503          	lw	a0,0(s2)
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	754080e7          	jalr	1876(ra) # 80003a04 <iget>
    800042b8:	a011                	j	800042bc <dirlookup+0xa0>
  return 0;
    800042ba:	4501                	li	a0,0
}
    800042bc:	70e2                	ld	ra,56(sp)
    800042be:	7442                	ld	s0,48(sp)
    800042c0:	74a2                	ld	s1,40(sp)
    800042c2:	7902                	ld	s2,32(sp)
    800042c4:	69e2                	ld	s3,24(sp)
    800042c6:	6a42                	ld	s4,16(sp)
    800042c8:	6121                	addi	sp,sp,64
    800042ca:	8082                	ret

00000000800042cc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800042cc:	711d                	addi	sp,sp,-96
    800042ce:	ec86                	sd	ra,88(sp)
    800042d0:	e8a2                	sd	s0,80(sp)
    800042d2:	e4a6                	sd	s1,72(sp)
    800042d4:	e0ca                	sd	s2,64(sp)
    800042d6:	fc4e                	sd	s3,56(sp)
    800042d8:	f852                	sd	s4,48(sp)
    800042da:	f456                	sd	s5,40(sp)
    800042dc:	f05a                	sd	s6,32(sp)
    800042de:	ec5e                	sd	s7,24(sp)
    800042e0:	e862                	sd	s8,16(sp)
    800042e2:	e466                	sd	s9,8(sp)
    800042e4:	1080                	addi	s0,sp,96
    800042e6:	84aa                	mv	s1,a0
    800042e8:	8aae                	mv	s5,a1
    800042ea:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800042ec:	00054703          	lbu	a4,0(a0)
    800042f0:	02f00793          	li	a5,47
    800042f4:	02f70363          	beq	a4,a5,8000431a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042f8:	ffffe097          	auipc	ra,0xffffe
    800042fc:	99c080e7          	jalr	-1636(ra) # 80001c94 <myproc>
    80004300:	16053503          	ld	a0,352(a0)
    80004304:	00000097          	auipc	ra,0x0
    80004308:	9f6080e7          	jalr	-1546(ra) # 80003cfa <idup>
    8000430c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000430e:	02f00913          	li	s2,47
  len = path - s;
    80004312:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004314:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004316:	4b85                	li	s7,1
    80004318:	a865                	j	800043d0 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000431a:	4585                	li	a1,1
    8000431c:	4505                	li	a0,1
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	6e6080e7          	jalr	1766(ra) # 80003a04 <iget>
    80004326:	89aa                	mv	s3,a0
    80004328:	b7dd                	j	8000430e <namex+0x42>
      iunlockput(ip);
    8000432a:	854e                	mv	a0,s3
    8000432c:	00000097          	auipc	ra,0x0
    80004330:	c6e080e7          	jalr	-914(ra) # 80003f9a <iunlockput>
      return 0;
    80004334:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004336:	854e                	mv	a0,s3
    80004338:	60e6                	ld	ra,88(sp)
    8000433a:	6446                	ld	s0,80(sp)
    8000433c:	64a6                	ld	s1,72(sp)
    8000433e:	6906                	ld	s2,64(sp)
    80004340:	79e2                	ld	s3,56(sp)
    80004342:	7a42                	ld	s4,48(sp)
    80004344:	7aa2                	ld	s5,40(sp)
    80004346:	7b02                	ld	s6,32(sp)
    80004348:	6be2                	ld	s7,24(sp)
    8000434a:	6c42                	ld	s8,16(sp)
    8000434c:	6ca2                	ld	s9,8(sp)
    8000434e:	6125                	addi	sp,sp,96
    80004350:	8082                	ret
      iunlock(ip);
    80004352:	854e                	mv	a0,s3
    80004354:	00000097          	auipc	ra,0x0
    80004358:	aa6080e7          	jalr	-1370(ra) # 80003dfa <iunlock>
      return ip;
    8000435c:	bfe9                	j	80004336 <namex+0x6a>
      iunlockput(ip);
    8000435e:	854e                	mv	a0,s3
    80004360:	00000097          	auipc	ra,0x0
    80004364:	c3a080e7          	jalr	-966(ra) # 80003f9a <iunlockput>
      return 0;
    80004368:	89e6                	mv	s3,s9
    8000436a:	b7f1                	j	80004336 <namex+0x6a>
  len = path - s;
    8000436c:	40b48633          	sub	a2,s1,a1
    80004370:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004374:	099c5463          	bge	s8,s9,800043fc <namex+0x130>
    memmove(name, s, DIRSIZ);
    80004378:	4639                	li	a2,14
    8000437a:	8552                	mv	a0,s4
    8000437c:	ffffd097          	auipc	ra,0xffffd
    80004380:	a16080e7          	jalr	-1514(ra) # 80000d92 <memmove>
  while(*path == '/')
    80004384:	0004c783          	lbu	a5,0(s1)
    80004388:	01279763          	bne	a5,s2,80004396 <namex+0xca>
    path++;
    8000438c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000438e:	0004c783          	lbu	a5,0(s1)
    80004392:	ff278de3          	beq	a5,s2,8000438c <namex+0xc0>
    ilock(ip);
    80004396:	854e                	mv	a0,s3
    80004398:	00000097          	auipc	ra,0x0
    8000439c:	9a0080e7          	jalr	-1632(ra) # 80003d38 <ilock>
    if(ip->type != T_DIR){
    800043a0:	04499783          	lh	a5,68(s3)
    800043a4:	f97793e3          	bne	a5,s7,8000432a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800043a8:	000a8563          	beqz	s5,800043b2 <namex+0xe6>
    800043ac:	0004c783          	lbu	a5,0(s1)
    800043b0:	d3cd                	beqz	a5,80004352 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800043b2:	865a                	mv	a2,s6
    800043b4:	85d2                	mv	a1,s4
    800043b6:	854e                	mv	a0,s3
    800043b8:	00000097          	auipc	ra,0x0
    800043bc:	e64080e7          	jalr	-412(ra) # 8000421c <dirlookup>
    800043c0:	8caa                	mv	s9,a0
    800043c2:	dd51                	beqz	a0,8000435e <namex+0x92>
    iunlockput(ip);
    800043c4:	854e                	mv	a0,s3
    800043c6:	00000097          	auipc	ra,0x0
    800043ca:	bd4080e7          	jalr	-1068(ra) # 80003f9a <iunlockput>
    ip = next;
    800043ce:	89e6                	mv	s3,s9
  while(*path == '/')
    800043d0:	0004c783          	lbu	a5,0(s1)
    800043d4:	05279763          	bne	a5,s2,80004422 <namex+0x156>
    path++;
    800043d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043da:	0004c783          	lbu	a5,0(s1)
    800043de:	ff278de3          	beq	a5,s2,800043d8 <namex+0x10c>
  if(*path == 0)
    800043e2:	c79d                	beqz	a5,80004410 <namex+0x144>
    path++;
    800043e4:	85a6                	mv	a1,s1
  len = path - s;
    800043e6:	8cda                	mv	s9,s6
    800043e8:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800043ea:	01278963          	beq	a5,s2,800043fc <namex+0x130>
    800043ee:	dfbd                	beqz	a5,8000436c <namex+0xa0>
    path++;
    800043f0:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800043f2:	0004c783          	lbu	a5,0(s1)
    800043f6:	ff279ce3          	bne	a5,s2,800043ee <namex+0x122>
    800043fa:	bf8d                	j	8000436c <namex+0xa0>
    memmove(name, s, len);
    800043fc:	2601                	sext.w	a2,a2
    800043fe:	8552                	mv	a0,s4
    80004400:	ffffd097          	auipc	ra,0xffffd
    80004404:	992080e7          	jalr	-1646(ra) # 80000d92 <memmove>
    name[len] = 0;
    80004408:	9cd2                	add	s9,s9,s4
    8000440a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000440e:	bf9d                	j	80004384 <namex+0xb8>
  if(nameiparent){
    80004410:	f20a83e3          	beqz	s5,80004336 <namex+0x6a>
    iput(ip);
    80004414:	854e                	mv	a0,s3
    80004416:	00000097          	auipc	ra,0x0
    8000441a:	adc080e7          	jalr	-1316(ra) # 80003ef2 <iput>
    return 0;
    8000441e:	4981                	li	s3,0
    80004420:	bf19                	j	80004336 <namex+0x6a>
  if(*path == 0)
    80004422:	d7fd                	beqz	a5,80004410 <namex+0x144>
  while(*path != '/' && *path != 0)
    80004424:	0004c783          	lbu	a5,0(s1)
    80004428:	85a6                	mv	a1,s1
    8000442a:	b7d1                	j	800043ee <namex+0x122>

000000008000442c <dirlink>:
{
    8000442c:	7139                	addi	sp,sp,-64
    8000442e:	fc06                	sd	ra,56(sp)
    80004430:	f822                	sd	s0,48(sp)
    80004432:	f426                	sd	s1,40(sp)
    80004434:	f04a                	sd	s2,32(sp)
    80004436:	ec4e                	sd	s3,24(sp)
    80004438:	e852                	sd	s4,16(sp)
    8000443a:	0080                	addi	s0,sp,64
    8000443c:	892a                	mv	s2,a0
    8000443e:	8a2e                	mv	s4,a1
    80004440:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004442:	4601                	li	a2,0
    80004444:	00000097          	auipc	ra,0x0
    80004448:	dd8080e7          	jalr	-552(ra) # 8000421c <dirlookup>
    8000444c:	e93d                	bnez	a0,800044c2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000444e:	04c92483          	lw	s1,76(s2)
    80004452:	c49d                	beqz	s1,80004480 <dirlink+0x54>
    80004454:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004456:	4741                	li	a4,16
    80004458:	86a6                	mv	a3,s1
    8000445a:	fc040613          	addi	a2,s0,-64
    8000445e:	4581                	li	a1,0
    80004460:	854a                	mv	a0,s2
    80004462:	00000097          	auipc	ra,0x0
    80004466:	b8a080e7          	jalr	-1142(ra) # 80003fec <readi>
    8000446a:	47c1                	li	a5,16
    8000446c:	06f51163          	bne	a0,a5,800044ce <dirlink+0xa2>
    if(de.inum == 0)
    80004470:	fc045783          	lhu	a5,-64(s0)
    80004474:	c791                	beqz	a5,80004480 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004476:	24c1                	addiw	s1,s1,16
    80004478:	04c92783          	lw	a5,76(s2)
    8000447c:	fcf4ede3          	bltu	s1,a5,80004456 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004480:	4639                	li	a2,14
    80004482:	85d2                	mv	a1,s4
    80004484:	fc240513          	addi	a0,s0,-62
    80004488:	ffffd097          	auipc	ra,0xffffd
    8000448c:	9c2080e7          	jalr	-1598(ra) # 80000e4a <strncpy>
  de.inum = inum;
    80004490:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004494:	4741                	li	a4,16
    80004496:	86a6                	mv	a3,s1
    80004498:	fc040613          	addi	a2,s0,-64
    8000449c:	4581                	li	a1,0
    8000449e:	854a                	mv	a0,s2
    800044a0:	00000097          	auipc	ra,0x0
    800044a4:	c44080e7          	jalr	-956(ra) # 800040e4 <writei>
    800044a8:	872a                	mv	a4,a0
    800044aa:	47c1                	li	a5,16
  return 0;
    800044ac:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044ae:	02f71863          	bne	a4,a5,800044de <dirlink+0xb2>
}
    800044b2:	70e2                	ld	ra,56(sp)
    800044b4:	7442                	ld	s0,48(sp)
    800044b6:	74a2                	ld	s1,40(sp)
    800044b8:	7902                	ld	s2,32(sp)
    800044ba:	69e2                	ld	s3,24(sp)
    800044bc:	6a42                	ld	s4,16(sp)
    800044be:	6121                	addi	sp,sp,64
    800044c0:	8082                	ret
    iput(ip);
    800044c2:	00000097          	auipc	ra,0x0
    800044c6:	a30080e7          	jalr	-1488(ra) # 80003ef2 <iput>
    return -1;
    800044ca:	557d                	li	a0,-1
    800044cc:	b7dd                	j	800044b2 <dirlink+0x86>
      panic("dirlink read");
    800044ce:	00004517          	auipc	a0,0x4
    800044d2:	21250513          	addi	a0,a0,530 # 800086e0 <syscalls+0x1e0>
    800044d6:	ffffc097          	auipc	ra,0xffffc
    800044da:	0f6080e7          	jalr	246(ra) # 800005cc <panic>
    panic("dirlink");
    800044de:	00004517          	auipc	a0,0x4
    800044e2:	30a50513          	addi	a0,a0,778 # 800087e8 <syscalls+0x2e8>
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	0e6080e7          	jalr	230(ra) # 800005cc <panic>

00000000800044ee <namei>:

struct inode*
namei(char *path)
{
    800044ee:	1101                	addi	sp,sp,-32
    800044f0:	ec06                	sd	ra,24(sp)
    800044f2:	e822                	sd	s0,16(sp)
    800044f4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044f6:	fe040613          	addi	a2,s0,-32
    800044fa:	4581                	li	a1,0
    800044fc:	00000097          	auipc	ra,0x0
    80004500:	dd0080e7          	jalr	-560(ra) # 800042cc <namex>
}
    80004504:	60e2                	ld	ra,24(sp)
    80004506:	6442                	ld	s0,16(sp)
    80004508:	6105                	addi	sp,sp,32
    8000450a:	8082                	ret

000000008000450c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000450c:	1141                	addi	sp,sp,-16
    8000450e:	e406                	sd	ra,8(sp)
    80004510:	e022                	sd	s0,0(sp)
    80004512:	0800                	addi	s0,sp,16
    80004514:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004516:	4585                	li	a1,1
    80004518:	00000097          	auipc	ra,0x0
    8000451c:	db4080e7          	jalr	-588(ra) # 800042cc <namex>
}
    80004520:	60a2                	ld	ra,8(sp)
    80004522:	6402                	ld	s0,0(sp)
    80004524:	0141                	addi	sp,sp,16
    80004526:	8082                	ret

0000000080004528 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004528:	1101                	addi	sp,sp,-32
    8000452a:	ec06                	sd	ra,24(sp)
    8000452c:	e822                	sd	s0,16(sp)
    8000452e:	e426                	sd	s1,8(sp)
    80004530:	e04a                	sd	s2,0(sp)
    80004532:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004534:	0001e917          	auipc	s2,0x1e
    80004538:	85c90913          	addi	s2,s2,-1956 # 80021d90 <log>
    8000453c:	01892583          	lw	a1,24(s2)
    80004540:	02892503          	lw	a0,40(s2)
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	ff2080e7          	jalr	-14(ra) # 80003536 <bread>
    8000454c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000454e:	02c92683          	lw	a3,44(s2)
    80004552:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004554:	02d05763          	blez	a3,80004582 <write_head+0x5a>
    80004558:	0001e797          	auipc	a5,0x1e
    8000455c:	86878793          	addi	a5,a5,-1944 # 80021dc0 <log+0x30>
    80004560:	05c50713          	addi	a4,a0,92
    80004564:	36fd                	addiw	a3,a3,-1
    80004566:	1682                	slli	a3,a3,0x20
    80004568:	9281                	srli	a3,a3,0x20
    8000456a:	068a                	slli	a3,a3,0x2
    8000456c:	0001e617          	auipc	a2,0x1e
    80004570:	85860613          	addi	a2,a2,-1960 # 80021dc4 <log+0x34>
    80004574:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004576:	4390                	lw	a2,0(a5)
    80004578:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000457a:	0791                	addi	a5,a5,4
    8000457c:	0711                	addi	a4,a4,4
    8000457e:	fed79ce3          	bne	a5,a3,80004576 <write_head+0x4e>
  }
  bwrite(buf);
    80004582:	8526                	mv	a0,s1
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	0a4080e7          	jalr	164(ra) # 80003628 <bwrite>
  brelse(buf);
    8000458c:	8526                	mv	a0,s1
    8000458e:	fffff097          	auipc	ra,0xfffff
    80004592:	0d8080e7          	jalr	216(ra) # 80003666 <brelse>
}
    80004596:	60e2                	ld	ra,24(sp)
    80004598:	6442                	ld	s0,16(sp)
    8000459a:	64a2                	ld	s1,8(sp)
    8000459c:	6902                	ld	s2,0(sp)
    8000459e:	6105                	addi	sp,sp,32
    800045a0:	8082                	ret

00000000800045a2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800045a2:	0001e797          	auipc	a5,0x1e
    800045a6:	81a7a783          	lw	a5,-2022(a5) # 80021dbc <log+0x2c>
    800045aa:	0af05d63          	blez	a5,80004664 <install_trans+0xc2>
{
    800045ae:	7139                	addi	sp,sp,-64
    800045b0:	fc06                	sd	ra,56(sp)
    800045b2:	f822                	sd	s0,48(sp)
    800045b4:	f426                	sd	s1,40(sp)
    800045b6:	f04a                	sd	s2,32(sp)
    800045b8:	ec4e                	sd	s3,24(sp)
    800045ba:	e852                	sd	s4,16(sp)
    800045bc:	e456                	sd	s5,8(sp)
    800045be:	e05a                	sd	s6,0(sp)
    800045c0:	0080                	addi	s0,sp,64
    800045c2:	8b2a                	mv	s6,a0
    800045c4:	0001da97          	auipc	s5,0x1d
    800045c8:	7fca8a93          	addi	s5,s5,2044 # 80021dc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045cc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045ce:	0001d997          	auipc	s3,0x1d
    800045d2:	7c298993          	addi	s3,s3,1986 # 80021d90 <log>
    800045d6:	a00d                	j	800045f8 <install_trans+0x56>
    brelse(lbuf);
    800045d8:	854a                	mv	a0,s2
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	08c080e7          	jalr	140(ra) # 80003666 <brelse>
    brelse(dbuf);
    800045e2:	8526                	mv	a0,s1
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	082080e7          	jalr	130(ra) # 80003666 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045ec:	2a05                	addiw	s4,s4,1
    800045ee:	0a91                	addi	s5,s5,4
    800045f0:	02c9a783          	lw	a5,44(s3)
    800045f4:	04fa5e63          	bge	s4,a5,80004650 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045f8:	0189a583          	lw	a1,24(s3)
    800045fc:	014585bb          	addw	a1,a1,s4
    80004600:	2585                	addiw	a1,a1,1
    80004602:	0289a503          	lw	a0,40(s3)
    80004606:	fffff097          	auipc	ra,0xfffff
    8000460a:	f30080e7          	jalr	-208(ra) # 80003536 <bread>
    8000460e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004610:	000aa583          	lw	a1,0(s5)
    80004614:	0289a503          	lw	a0,40(s3)
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	f1e080e7          	jalr	-226(ra) # 80003536 <bread>
    80004620:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004622:	40000613          	li	a2,1024
    80004626:	05890593          	addi	a1,s2,88
    8000462a:	05850513          	addi	a0,a0,88
    8000462e:	ffffc097          	auipc	ra,0xffffc
    80004632:	764080e7          	jalr	1892(ra) # 80000d92 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004636:	8526                	mv	a0,s1
    80004638:	fffff097          	auipc	ra,0xfffff
    8000463c:	ff0080e7          	jalr	-16(ra) # 80003628 <bwrite>
    if(recovering == 0)
    80004640:	f80b1ce3          	bnez	s6,800045d8 <install_trans+0x36>
      bunpin(dbuf);
    80004644:	8526                	mv	a0,s1
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	0fa080e7          	jalr	250(ra) # 80003740 <bunpin>
    8000464e:	b769                	j	800045d8 <install_trans+0x36>
}
    80004650:	70e2                	ld	ra,56(sp)
    80004652:	7442                	ld	s0,48(sp)
    80004654:	74a2                	ld	s1,40(sp)
    80004656:	7902                	ld	s2,32(sp)
    80004658:	69e2                	ld	s3,24(sp)
    8000465a:	6a42                	ld	s4,16(sp)
    8000465c:	6aa2                	ld	s5,8(sp)
    8000465e:	6b02                	ld	s6,0(sp)
    80004660:	6121                	addi	sp,sp,64
    80004662:	8082                	ret
    80004664:	8082                	ret

0000000080004666 <initlog>:
{
    80004666:	7179                	addi	sp,sp,-48
    80004668:	f406                	sd	ra,40(sp)
    8000466a:	f022                	sd	s0,32(sp)
    8000466c:	ec26                	sd	s1,24(sp)
    8000466e:	e84a                	sd	s2,16(sp)
    80004670:	e44e                	sd	s3,8(sp)
    80004672:	1800                	addi	s0,sp,48
    80004674:	892a                	mv	s2,a0
    80004676:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004678:	0001d497          	auipc	s1,0x1d
    8000467c:	71848493          	addi	s1,s1,1816 # 80021d90 <log>
    80004680:	00004597          	auipc	a1,0x4
    80004684:	07058593          	addi	a1,a1,112 # 800086f0 <syscalls+0x1f0>
    80004688:	8526                	mv	a0,s1
    8000468a:	ffffc097          	auipc	ra,0xffffc
    8000468e:	520080e7          	jalr	1312(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    80004692:	0149a583          	lw	a1,20(s3)
    80004696:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004698:	0109a783          	lw	a5,16(s3)
    8000469c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000469e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800046a2:	854a                	mv	a0,s2
    800046a4:	fffff097          	auipc	ra,0xfffff
    800046a8:	e92080e7          	jalr	-366(ra) # 80003536 <bread>
  log.lh.n = lh->n;
    800046ac:	4d34                	lw	a3,88(a0)
    800046ae:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800046b0:	02d05563          	blez	a3,800046da <initlog+0x74>
    800046b4:	05c50793          	addi	a5,a0,92
    800046b8:	0001d717          	auipc	a4,0x1d
    800046bc:	70870713          	addi	a4,a4,1800 # 80021dc0 <log+0x30>
    800046c0:	36fd                	addiw	a3,a3,-1
    800046c2:	1682                	slli	a3,a3,0x20
    800046c4:	9281                	srli	a3,a3,0x20
    800046c6:	068a                	slli	a3,a3,0x2
    800046c8:	06050613          	addi	a2,a0,96
    800046cc:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800046ce:	4390                	lw	a2,0(a5)
    800046d0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800046d2:	0791                	addi	a5,a5,4
    800046d4:	0711                	addi	a4,a4,4
    800046d6:	fed79ce3          	bne	a5,a3,800046ce <initlog+0x68>
  brelse(buf);
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	f8c080e7          	jalr	-116(ra) # 80003666 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800046e2:	4505                	li	a0,1
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	ebe080e7          	jalr	-322(ra) # 800045a2 <install_trans>
  log.lh.n = 0;
    800046ec:	0001d797          	auipc	a5,0x1d
    800046f0:	6c07a823          	sw	zero,1744(a5) # 80021dbc <log+0x2c>
  write_head(); // clear the log
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	e34080e7          	jalr	-460(ra) # 80004528 <write_head>
}
    800046fc:	70a2                	ld	ra,40(sp)
    800046fe:	7402                	ld	s0,32(sp)
    80004700:	64e2                	ld	s1,24(sp)
    80004702:	6942                	ld	s2,16(sp)
    80004704:	69a2                	ld	s3,8(sp)
    80004706:	6145                	addi	sp,sp,48
    80004708:	8082                	ret

000000008000470a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000470a:	1101                	addi	sp,sp,-32
    8000470c:	ec06                	sd	ra,24(sp)
    8000470e:	e822                	sd	s0,16(sp)
    80004710:	e426                	sd	s1,8(sp)
    80004712:	e04a                	sd	s2,0(sp)
    80004714:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004716:	0001d517          	auipc	a0,0x1d
    8000471a:	67a50513          	addi	a0,a0,1658 # 80021d90 <log>
    8000471e:	ffffc097          	auipc	ra,0xffffc
    80004722:	51c080e7          	jalr	1308(ra) # 80000c3a <acquire>
  while(1){
    if(log.committing){
    80004726:	0001d497          	auipc	s1,0x1d
    8000472a:	66a48493          	addi	s1,s1,1642 # 80021d90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000472e:	4979                	li	s2,30
    80004730:	a039                	j	8000473e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004732:	85a6                	mv	a1,s1
    80004734:	8526                	mv	a0,s1
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	e10080e7          	jalr	-496(ra) # 80002546 <sleep>
    if(log.committing){
    8000473e:	50dc                	lw	a5,36(s1)
    80004740:	fbed                	bnez	a5,80004732 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004742:	509c                	lw	a5,32(s1)
    80004744:	0017871b          	addiw	a4,a5,1
    80004748:	0007069b          	sext.w	a3,a4
    8000474c:	0027179b          	slliw	a5,a4,0x2
    80004750:	9fb9                	addw	a5,a5,a4
    80004752:	0017979b          	slliw	a5,a5,0x1
    80004756:	54d8                	lw	a4,44(s1)
    80004758:	9fb9                	addw	a5,a5,a4
    8000475a:	00f95963          	bge	s2,a5,8000476c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000475e:	85a6                	mv	a1,s1
    80004760:	8526                	mv	a0,s1
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	de4080e7          	jalr	-540(ra) # 80002546 <sleep>
    8000476a:	bfd1                	j	8000473e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000476c:	0001d517          	auipc	a0,0x1d
    80004770:	62450513          	addi	a0,a0,1572 # 80021d90 <log>
    80004774:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004776:	ffffc097          	auipc	ra,0xffffc
    8000477a:	578080e7          	jalr	1400(ra) # 80000cee <release>
      break;
    }
  }
}
    8000477e:	60e2                	ld	ra,24(sp)
    80004780:	6442                	ld	s0,16(sp)
    80004782:	64a2                	ld	s1,8(sp)
    80004784:	6902                	ld	s2,0(sp)
    80004786:	6105                	addi	sp,sp,32
    80004788:	8082                	ret

000000008000478a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000478a:	7139                	addi	sp,sp,-64
    8000478c:	fc06                	sd	ra,56(sp)
    8000478e:	f822                	sd	s0,48(sp)
    80004790:	f426                	sd	s1,40(sp)
    80004792:	f04a                	sd	s2,32(sp)
    80004794:	ec4e                	sd	s3,24(sp)
    80004796:	e852                	sd	s4,16(sp)
    80004798:	e456                	sd	s5,8(sp)
    8000479a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000479c:	0001d497          	auipc	s1,0x1d
    800047a0:	5f448493          	addi	s1,s1,1524 # 80021d90 <log>
    800047a4:	8526                	mv	a0,s1
    800047a6:	ffffc097          	auipc	ra,0xffffc
    800047aa:	494080e7          	jalr	1172(ra) # 80000c3a <acquire>
  log.outstanding -= 1;
    800047ae:	509c                	lw	a5,32(s1)
    800047b0:	37fd                	addiw	a5,a5,-1
    800047b2:	0007891b          	sext.w	s2,a5
    800047b6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800047b8:	50dc                	lw	a5,36(s1)
    800047ba:	e7b9                	bnez	a5,80004808 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800047bc:	04091e63          	bnez	s2,80004818 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800047c0:	0001d497          	auipc	s1,0x1d
    800047c4:	5d048493          	addi	s1,s1,1488 # 80021d90 <log>
    800047c8:	4785                	li	a5,1
    800047ca:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800047cc:	8526                	mv	a0,s1
    800047ce:	ffffc097          	auipc	ra,0xffffc
    800047d2:	520080e7          	jalr	1312(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800047d6:	54dc                	lw	a5,44(s1)
    800047d8:	06f04763          	bgtz	a5,80004846 <end_op+0xbc>
    acquire(&log.lock);
    800047dc:	0001d497          	auipc	s1,0x1d
    800047e0:	5b448493          	addi	s1,s1,1460 # 80021d90 <log>
    800047e4:	8526                	mv	a0,s1
    800047e6:	ffffc097          	auipc	ra,0xffffc
    800047ea:	454080e7          	jalr	1108(ra) # 80000c3a <acquire>
    log.committing = 0;
    800047ee:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800047f2:	8526                	mv	a0,s1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	ede080e7          	jalr	-290(ra) # 800026d2 <wakeup>
    release(&log.lock);
    800047fc:	8526                	mv	a0,s1
    800047fe:	ffffc097          	auipc	ra,0xffffc
    80004802:	4f0080e7          	jalr	1264(ra) # 80000cee <release>
}
    80004806:	a03d                	j	80004834 <end_op+0xaa>
    panic("log.committing");
    80004808:	00004517          	auipc	a0,0x4
    8000480c:	ef050513          	addi	a0,a0,-272 # 800086f8 <syscalls+0x1f8>
    80004810:	ffffc097          	auipc	ra,0xffffc
    80004814:	dbc080e7          	jalr	-580(ra) # 800005cc <panic>
    wakeup(&log);
    80004818:	0001d497          	auipc	s1,0x1d
    8000481c:	57848493          	addi	s1,s1,1400 # 80021d90 <log>
    80004820:	8526                	mv	a0,s1
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	eb0080e7          	jalr	-336(ra) # 800026d2 <wakeup>
  release(&log.lock);
    8000482a:	8526                	mv	a0,s1
    8000482c:	ffffc097          	auipc	ra,0xffffc
    80004830:	4c2080e7          	jalr	1218(ra) # 80000cee <release>
}
    80004834:	70e2                	ld	ra,56(sp)
    80004836:	7442                	ld	s0,48(sp)
    80004838:	74a2                	ld	s1,40(sp)
    8000483a:	7902                	ld	s2,32(sp)
    8000483c:	69e2                	ld	s3,24(sp)
    8000483e:	6a42                	ld	s4,16(sp)
    80004840:	6aa2                	ld	s5,8(sp)
    80004842:	6121                	addi	sp,sp,64
    80004844:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004846:	0001da97          	auipc	s5,0x1d
    8000484a:	57aa8a93          	addi	s5,s5,1402 # 80021dc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000484e:	0001da17          	auipc	s4,0x1d
    80004852:	542a0a13          	addi	s4,s4,1346 # 80021d90 <log>
    80004856:	018a2583          	lw	a1,24(s4)
    8000485a:	012585bb          	addw	a1,a1,s2
    8000485e:	2585                	addiw	a1,a1,1
    80004860:	028a2503          	lw	a0,40(s4)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	cd2080e7          	jalr	-814(ra) # 80003536 <bread>
    8000486c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000486e:	000aa583          	lw	a1,0(s5)
    80004872:	028a2503          	lw	a0,40(s4)
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	cc0080e7          	jalr	-832(ra) # 80003536 <bread>
    8000487e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004880:	40000613          	li	a2,1024
    80004884:	05850593          	addi	a1,a0,88
    80004888:	05848513          	addi	a0,s1,88
    8000488c:	ffffc097          	auipc	ra,0xffffc
    80004890:	506080e7          	jalr	1286(ra) # 80000d92 <memmove>
    bwrite(to);  // write the log
    80004894:	8526                	mv	a0,s1
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	d92080e7          	jalr	-622(ra) # 80003628 <bwrite>
    brelse(from);
    8000489e:	854e                	mv	a0,s3
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	dc6080e7          	jalr	-570(ra) # 80003666 <brelse>
    brelse(to);
    800048a8:	8526                	mv	a0,s1
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	dbc080e7          	jalr	-580(ra) # 80003666 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048b2:	2905                	addiw	s2,s2,1
    800048b4:	0a91                	addi	s5,s5,4
    800048b6:	02ca2783          	lw	a5,44(s4)
    800048ba:	f8f94ee3          	blt	s2,a5,80004856 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	c6a080e7          	jalr	-918(ra) # 80004528 <write_head>
    install_trans(0); // Now install writes to home locations
    800048c6:	4501                	li	a0,0
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	cda080e7          	jalr	-806(ra) # 800045a2 <install_trans>
    log.lh.n = 0;
    800048d0:	0001d797          	auipc	a5,0x1d
    800048d4:	4e07a623          	sw	zero,1260(a5) # 80021dbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	c50080e7          	jalr	-944(ra) # 80004528 <write_head>
    800048e0:	bdf5                	j	800047dc <end_op+0x52>

00000000800048e2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800048e2:	1101                	addi	sp,sp,-32
    800048e4:	ec06                	sd	ra,24(sp)
    800048e6:	e822                	sd	s0,16(sp)
    800048e8:	e426                	sd	s1,8(sp)
    800048ea:	e04a                	sd	s2,0(sp)
    800048ec:	1000                	addi	s0,sp,32
    800048ee:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800048f0:	0001d917          	auipc	s2,0x1d
    800048f4:	4a090913          	addi	s2,s2,1184 # 80021d90 <log>
    800048f8:	854a                	mv	a0,s2
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	340080e7          	jalr	832(ra) # 80000c3a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004902:	02c92603          	lw	a2,44(s2)
    80004906:	47f5                	li	a5,29
    80004908:	06c7c563          	blt	a5,a2,80004972 <log_write+0x90>
    8000490c:	0001d797          	auipc	a5,0x1d
    80004910:	4a07a783          	lw	a5,1184(a5) # 80021dac <log+0x1c>
    80004914:	37fd                	addiw	a5,a5,-1
    80004916:	04f65e63          	bge	a2,a5,80004972 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000491a:	0001d797          	auipc	a5,0x1d
    8000491e:	4967a783          	lw	a5,1174(a5) # 80021db0 <log+0x20>
    80004922:	06f05063          	blez	a5,80004982 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004926:	4781                	li	a5,0
    80004928:	06c05563          	blez	a2,80004992 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000492c:	44cc                	lw	a1,12(s1)
    8000492e:	0001d717          	auipc	a4,0x1d
    80004932:	49270713          	addi	a4,a4,1170 # 80021dc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004936:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004938:	4314                	lw	a3,0(a4)
    8000493a:	04b68c63          	beq	a3,a1,80004992 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000493e:	2785                	addiw	a5,a5,1
    80004940:	0711                	addi	a4,a4,4
    80004942:	fef61be3          	bne	a2,a5,80004938 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004946:	0621                	addi	a2,a2,8
    80004948:	060a                	slli	a2,a2,0x2
    8000494a:	0001d797          	auipc	a5,0x1d
    8000494e:	44678793          	addi	a5,a5,1094 # 80021d90 <log>
    80004952:	963e                	add	a2,a2,a5
    80004954:	44dc                	lw	a5,12(s1)
    80004956:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004958:	8526                	mv	a0,s1
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	daa080e7          	jalr	-598(ra) # 80003704 <bpin>
    log.lh.n++;
    80004962:	0001d717          	auipc	a4,0x1d
    80004966:	42e70713          	addi	a4,a4,1070 # 80021d90 <log>
    8000496a:	575c                	lw	a5,44(a4)
    8000496c:	2785                	addiw	a5,a5,1
    8000496e:	d75c                	sw	a5,44(a4)
    80004970:	a835                	j	800049ac <log_write+0xca>
    panic("too big a transaction");
    80004972:	00004517          	auipc	a0,0x4
    80004976:	d9650513          	addi	a0,a0,-618 # 80008708 <syscalls+0x208>
    8000497a:	ffffc097          	auipc	ra,0xffffc
    8000497e:	c52080e7          	jalr	-942(ra) # 800005cc <panic>
    panic("log_write outside of trans");
    80004982:	00004517          	auipc	a0,0x4
    80004986:	d9e50513          	addi	a0,a0,-610 # 80008720 <syscalls+0x220>
    8000498a:	ffffc097          	auipc	ra,0xffffc
    8000498e:	c42080e7          	jalr	-958(ra) # 800005cc <panic>
  log.lh.block[i] = b->blockno;
    80004992:	00878713          	addi	a4,a5,8
    80004996:	00271693          	slli	a3,a4,0x2
    8000499a:	0001d717          	auipc	a4,0x1d
    8000499e:	3f670713          	addi	a4,a4,1014 # 80021d90 <log>
    800049a2:	9736                	add	a4,a4,a3
    800049a4:	44d4                	lw	a3,12(s1)
    800049a6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800049a8:	faf608e3          	beq	a2,a5,80004958 <log_write+0x76>
  }
  release(&log.lock);
    800049ac:	0001d517          	auipc	a0,0x1d
    800049b0:	3e450513          	addi	a0,a0,996 # 80021d90 <log>
    800049b4:	ffffc097          	auipc	ra,0xffffc
    800049b8:	33a080e7          	jalr	826(ra) # 80000cee <release>
}
    800049bc:	60e2                	ld	ra,24(sp)
    800049be:	6442                	ld	s0,16(sp)
    800049c0:	64a2                	ld	s1,8(sp)
    800049c2:	6902                	ld	s2,0(sp)
    800049c4:	6105                	addi	sp,sp,32
    800049c6:	8082                	ret

00000000800049c8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800049c8:	1101                	addi	sp,sp,-32
    800049ca:	ec06                	sd	ra,24(sp)
    800049cc:	e822                	sd	s0,16(sp)
    800049ce:	e426                	sd	s1,8(sp)
    800049d0:	e04a                	sd	s2,0(sp)
    800049d2:	1000                	addi	s0,sp,32
    800049d4:	84aa                	mv	s1,a0
    800049d6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800049d8:	00004597          	auipc	a1,0x4
    800049dc:	d6858593          	addi	a1,a1,-664 # 80008740 <syscalls+0x240>
    800049e0:	0521                	addi	a0,a0,8
    800049e2:	ffffc097          	auipc	ra,0xffffc
    800049e6:	1c8080e7          	jalr	456(ra) # 80000baa <initlock>
  lk->name = name;
    800049ea:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800049ee:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049f2:	0204a423          	sw	zero,40(s1)
}
    800049f6:	60e2                	ld	ra,24(sp)
    800049f8:	6442                	ld	s0,16(sp)
    800049fa:	64a2                	ld	s1,8(sp)
    800049fc:	6902                	ld	s2,0(sp)
    800049fe:	6105                	addi	sp,sp,32
    80004a00:	8082                	ret

0000000080004a02 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004a02:	1101                	addi	sp,sp,-32
    80004a04:	ec06                	sd	ra,24(sp)
    80004a06:	e822                	sd	s0,16(sp)
    80004a08:	e426                	sd	s1,8(sp)
    80004a0a:	e04a                	sd	s2,0(sp)
    80004a0c:	1000                	addi	s0,sp,32
    80004a0e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a10:	00850913          	addi	s2,a0,8
    80004a14:	854a                	mv	a0,s2
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	224080e7          	jalr	548(ra) # 80000c3a <acquire>
  while (lk->locked) {
    80004a1e:	409c                	lw	a5,0(s1)
    80004a20:	cb89                	beqz	a5,80004a32 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004a22:	85ca                	mv	a1,s2
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	b20080e7          	jalr	-1248(ra) # 80002546 <sleep>
  while (lk->locked) {
    80004a2e:	409c                	lw	a5,0(s1)
    80004a30:	fbed                	bnez	a5,80004a22 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004a32:	4785                	li	a5,1
    80004a34:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	25e080e7          	jalr	606(ra) # 80001c94 <myproc>
    80004a3e:	591c                	lw	a5,48(a0)
    80004a40:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a42:	854a                	mv	a0,s2
    80004a44:	ffffc097          	auipc	ra,0xffffc
    80004a48:	2aa080e7          	jalr	682(ra) # 80000cee <release>
}
    80004a4c:	60e2                	ld	ra,24(sp)
    80004a4e:	6442                	ld	s0,16(sp)
    80004a50:	64a2                	ld	s1,8(sp)
    80004a52:	6902                	ld	s2,0(sp)
    80004a54:	6105                	addi	sp,sp,32
    80004a56:	8082                	ret

0000000080004a58 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a58:	1101                	addi	sp,sp,-32
    80004a5a:	ec06                	sd	ra,24(sp)
    80004a5c:	e822                	sd	s0,16(sp)
    80004a5e:	e426                	sd	s1,8(sp)
    80004a60:	e04a                	sd	s2,0(sp)
    80004a62:	1000                	addi	s0,sp,32
    80004a64:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a66:	00850913          	addi	s2,a0,8
    80004a6a:	854a                	mv	a0,s2
    80004a6c:	ffffc097          	auipc	ra,0xffffc
    80004a70:	1ce080e7          	jalr	462(ra) # 80000c3a <acquire>
  lk->locked = 0;
    80004a74:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a78:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	c54080e7          	jalr	-940(ra) # 800026d2 <wakeup>
  release(&lk->lk);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffc097          	auipc	ra,0xffffc
    80004a8c:	266080e7          	jalr	614(ra) # 80000cee <release>
}
    80004a90:	60e2                	ld	ra,24(sp)
    80004a92:	6442                	ld	s0,16(sp)
    80004a94:	64a2                	ld	s1,8(sp)
    80004a96:	6902                	ld	s2,0(sp)
    80004a98:	6105                	addi	sp,sp,32
    80004a9a:	8082                	ret

0000000080004a9c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a9c:	7179                	addi	sp,sp,-48
    80004a9e:	f406                	sd	ra,40(sp)
    80004aa0:	f022                	sd	s0,32(sp)
    80004aa2:	ec26                	sd	s1,24(sp)
    80004aa4:	e84a                	sd	s2,16(sp)
    80004aa6:	e44e                	sd	s3,8(sp)
    80004aa8:	1800                	addi	s0,sp,48
    80004aaa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004aac:	00850913          	addi	s2,a0,8
    80004ab0:	854a                	mv	a0,s2
    80004ab2:	ffffc097          	auipc	ra,0xffffc
    80004ab6:	188080e7          	jalr	392(ra) # 80000c3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004aba:	409c                	lw	a5,0(s1)
    80004abc:	ef99                	bnez	a5,80004ada <holdingsleep+0x3e>
    80004abe:	4481                	li	s1,0
  release(&lk->lk);
    80004ac0:	854a                	mv	a0,s2
    80004ac2:	ffffc097          	auipc	ra,0xffffc
    80004ac6:	22c080e7          	jalr	556(ra) # 80000cee <release>
  return r;
}
    80004aca:	8526                	mv	a0,s1
    80004acc:	70a2                	ld	ra,40(sp)
    80004ace:	7402                	ld	s0,32(sp)
    80004ad0:	64e2                	ld	s1,24(sp)
    80004ad2:	6942                	ld	s2,16(sp)
    80004ad4:	69a2                	ld	s3,8(sp)
    80004ad6:	6145                	addi	sp,sp,48
    80004ad8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ada:	0284a983          	lw	s3,40(s1)
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	1b6080e7          	jalr	438(ra) # 80001c94 <myproc>
    80004ae6:	5904                	lw	s1,48(a0)
    80004ae8:	413484b3          	sub	s1,s1,s3
    80004aec:	0014b493          	seqz	s1,s1
    80004af0:	bfc1                	j	80004ac0 <holdingsleep+0x24>

0000000080004af2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004af2:	1141                	addi	sp,sp,-16
    80004af4:	e406                	sd	ra,8(sp)
    80004af6:	e022                	sd	s0,0(sp)
    80004af8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004afa:	00004597          	auipc	a1,0x4
    80004afe:	c5658593          	addi	a1,a1,-938 # 80008750 <syscalls+0x250>
    80004b02:	0001d517          	auipc	a0,0x1d
    80004b06:	3d650513          	addi	a0,a0,982 # 80021ed8 <ftable>
    80004b0a:	ffffc097          	auipc	ra,0xffffc
    80004b0e:	0a0080e7          	jalr	160(ra) # 80000baa <initlock>
}
    80004b12:	60a2                	ld	ra,8(sp)
    80004b14:	6402                	ld	s0,0(sp)
    80004b16:	0141                	addi	sp,sp,16
    80004b18:	8082                	ret

0000000080004b1a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004b1a:	1101                	addi	sp,sp,-32
    80004b1c:	ec06                	sd	ra,24(sp)
    80004b1e:	e822                	sd	s0,16(sp)
    80004b20:	e426                	sd	s1,8(sp)
    80004b22:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004b24:	0001d517          	auipc	a0,0x1d
    80004b28:	3b450513          	addi	a0,a0,948 # 80021ed8 <ftable>
    80004b2c:	ffffc097          	auipc	ra,0xffffc
    80004b30:	10e080e7          	jalr	270(ra) # 80000c3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b34:	0001d497          	auipc	s1,0x1d
    80004b38:	3bc48493          	addi	s1,s1,956 # 80021ef0 <ftable+0x18>
    80004b3c:	0001e717          	auipc	a4,0x1e
    80004b40:	35470713          	addi	a4,a4,852 # 80022e90 <ftable+0xfb8>
    if(f->ref == 0){
    80004b44:	40dc                	lw	a5,4(s1)
    80004b46:	cf99                	beqz	a5,80004b64 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b48:	02848493          	addi	s1,s1,40
    80004b4c:	fee49ce3          	bne	s1,a4,80004b44 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b50:	0001d517          	auipc	a0,0x1d
    80004b54:	38850513          	addi	a0,a0,904 # 80021ed8 <ftable>
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	196080e7          	jalr	406(ra) # 80000cee <release>
  return 0;
    80004b60:	4481                	li	s1,0
    80004b62:	a819                	j	80004b78 <filealloc+0x5e>
      f->ref = 1;
    80004b64:	4785                	li	a5,1
    80004b66:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b68:	0001d517          	auipc	a0,0x1d
    80004b6c:	37050513          	addi	a0,a0,880 # 80021ed8 <ftable>
    80004b70:	ffffc097          	auipc	ra,0xffffc
    80004b74:	17e080e7          	jalr	382(ra) # 80000cee <release>
}
    80004b78:	8526                	mv	a0,s1
    80004b7a:	60e2                	ld	ra,24(sp)
    80004b7c:	6442                	ld	s0,16(sp)
    80004b7e:	64a2                	ld	s1,8(sp)
    80004b80:	6105                	addi	sp,sp,32
    80004b82:	8082                	ret

0000000080004b84 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b84:	1101                	addi	sp,sp,-32
    80004b86:	ec06                	sd	ra,24(sp)
    80004b88:	e822                	sd	s0,16(sp)
    80004b8a:	e426                	sd	s1,8(sp)
    80004b8c:	1000                	addi	s0,sp,32
    80004b8e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b90:	0001d517          	auipc	a0,0x1d
    80004b94:	34850513          	addi	a0,a0,840 # 80021ed8 <ftable>
    80004b98:	ffffc097          	auipc	ra,0xffffc
    80004b9c:	0a2080e7          	jalr	162(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004ba0:	40dc                	lw	a5,4(s1)
    80004ba2:	02f05263          	blez	a5,80004bc6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004ba6:	2785                	addiw	a5,a5,1
    80004ba8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004baa:	0001d517          	auipc	a0,0x1d
    80004bae:	32e50513          	addi	a0,a0,814 # 80021ed8 <ftable>
    80004bb2:	ffffc097          	auipc	ra,0xffffc
    80004bb6:	13c080e7          	jalr	316(ra) # 80000cee <release>
  return f;
}
    80004bba:	8526                	mv	a0,s1
    80004bbc:	60e2                	ld	ra,24(sp)
    80004bbe:	6442                	ld	s0,16(sp)
    80004bc0:	64a2                	ld	s1,8(sp)
    80004bc2:	6105                	addi	sp,sp,32
    80004bc4:	8082                	ret
    panic("filedup");
    80004bc6:	00004517          	auipc	a0,0x4
    80004bca:	b9250513          	addi	a0,a0,-1134 # 80008758 <syscalls+0x258>
    80004bce:	ffffc097          	auipc	ra,0xffffc
    80004bd2:	9fe080e7          	jalr	-1538(ra) # 800005cc <panic>

0000000080004bd6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004bd6:	7139                	addi	sp,sp,-64
    80004bd8:	fc06                	sd	ra,56(sp)
    80004bda:	f822                	sd	s0,48(sp)
    80004bdc:	f426                	sd	s1,40(sp)
    80004bde:	f04a                	sd	s2,32(sp)
    80004be0:	ec4e                	sd	s3,24(sp)
    80004be2:	e852                	sd	s4,16(sp)
    80004be4:	e456                	sd	s5,8(sp)
    80004be6:	0080                	addi	s0,sp,64
    80004be8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004bea:	0001d517          	auipc	a0,0x1d
    80004bee:	2ee50513          	addi	a0,a0,750 # 80021ed8 <ftable>
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	048080e7          	jalr	72(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004bfa:	40dc                	lw	a5,4(s1)
    80004bfc:	06f05163          	blez	a5,80004c5e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004c00:	37fd                	addiw	a5,a5,-1
    80004c02:	0007871b          	sext.w	a4,a5
    80004c06:	c0dc                	sw	a5,4(s1)
    80004c08:	06e04363          	bgtz	a4,80004c6e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004c0c:	0004a903          	lw	s2,0(s1)
    80004c10:	0094ca83          	lbu	s5,9(s1)
    80004c14:	0104ba03          	ld	s4,16(s1)
    80004c18:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004c1c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004c20:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004c24:	0001d517          	auipc	a0,0x1d
    80004c28:	2b450513          	addi	a0,a0,692 # 80021ed8 <ftable>
    80004c2c:	ffffc097          	auipc	ra,0xffffc
    80004c30:	0c2080e7          	jalr	194(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004c34:	4785                	li	a5,1
    80004c36:	04f90d63          	beq	s2,a5,80004c90 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004c3a:	3979                	addiw	s2,s2,-2
    80004c3c:	4785                	li	a5,1
    80004c3e:	0527e063          	bltu	a5,s2,80004c7e <fileclose+0xa8>
    begin_op();
    80004c42:	00000097          	auipc	ra,0x0
    80004c46:	ac8080e7          	jalr	-1336(ra) # 8000470a <begin_op>
    iput(ff.ip);
    80004c4a:	854e                	mv	a0,s3
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	2a6080e7          	jalr	678(ra) # 80003ef2 <iput>
    end_op();
    80004c54:	00000097          	auipc	ra,0x0
    80004c58:	b36080e7          	jalr	-1226(ra) # 8000478a <end_op>
    80004c5c:	a00d                	j	80004c7e <fileclose+0xa8>
    panic("fileclose");
    80004c5e:	00004517          	auipc	a0,0x4
    80004c62:	b0250513          	addi	a0,a0,-1278 # 80008760 <syscalls+0x260>
    80004c66:	ffffc097          	auipc	ra,0xffffc
    80004c6a:	966080e7          	jalr	-1690(ra) # 800005cc <panic>
    release(&ftable.lock);
    80004c6e:	0001d517          	auipc	a0,0x1d
    80004c72:	26a50513          	addi	a0,a0,618 # 80021ed8 <ftable>
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	078080e7          	jalr	120(ra) # 80000cee <release>
  }
}
    80004c7e:	70e2                	ld	ra,56(sp)
    80004c80:	7442                	ld	s0,48(sp)
    80004c82:	74a2                	ld	s1,40(sp)
    80004c84:	7902                	ld	s2,32(sp)
    80004c86:	69e2                	ld	s3,24(sp)
    80004c88:	6a42                	ld	s4,16(sp)
    80004c8a:	6aa2                	ld	s5,8(sp)
    80004c8c:	6121                	addi	sp,sp,64
    80004c8e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c90:	85d6                	mv	a1,s5
    80004c92:	8552                	mv	a0,s4
    80004c94:	00000097          	auipc	ra,0x0
    80004c98:	34c080e7          	jalr	844(ra) # 80004fe0 <pipeclose>
    80004c9c:	b7cd                	j	80004c7e <fileclose+0xa8>

0000000080004c9e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c9e:	715d                	addi	sp,sp,-80
    80004ca0:	e486                	sd	ra,72(sp)
    80004ca2:	e0a2                	sd	s0,64(sp)
    80004ca4:	fc26                	sd	s1,56(sp)
    80004ca6:	f84a                	sd	s2,48(sp)
    80004ca8:	f44e                	sd	s3,40(sp)
    80004caa:	0880                	addi	s0,sp,80
    80004cac:	84aa                	mv	s1,a0
    80004cae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004cb0:	ffffd097          	auipc	ra,0xffffd
    80004cb4:	fe4080e7          	jalr	-28(ra) # 80001c94 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004cb8:	409c                	lw	a5,0(s1)
    80004cba:	37f9                	addiw	a5,a5,-2
    80004cbc:	4705                	li	a4,1
    80004cbe:	04f76763          	bltu	a4,a5,80004d0c <filestat+0x6e>
    80004cc2:	892a                	mv	s2,a0
    ilock(f->ip);
    80004cc4:	6c88                	ld	a0,24(s1)
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	072080e7          	jalr	114(ra) # 80003d38 <ilock>
    stati(f->ip, &st);
    80004cce:	fb840593          	addi	a1,s0,-72
    80004cd2:	6c88                	ld	a0,24(s1)
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	2ee080e7          	jalr	750(ra) # 80003fc2 <stati>
    iunlock(f->ip);
    80004cdc:	6c88                	ld	a0,24(s1)
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	11c080e7          	jalr	284(ra) # 80003dfa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ce6:	46e1                	li	a3,24
    80004ce8:	fb840613          	addi	a2,s0,-72
    80004cec:	85ce                	mv	a1,s3
    80004cee:	05893503          	ld	a0,88(s2)
    80004cf2:	ffffd097          	auipc	ra,0xffffd
    80004cf6:	b92080e7          	jalr	-1134(ra) # 80001884 <copyout>
    80004cfa:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004cfe:	60a6                	ld	ra,72(sp)
    80004d00:	6406                	ld	s0,64(sp)
    80004d02:	74e2                	ld	s1,56(sp)
    80004d04:	7942                	ld	s2,48(sp)
    80004d06:	79a2                	ld	s3,40(sp)
    80004d08:	6161                	addi	sp,sp,80
    80004d0a:	8082                	ret
  return -1;
    80004d0c:	557d                	li	a0,-1
    80004d0e:	bfc5                	j	80004cfe <filestat+0x60>

0000000080004d10 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004d10:	7179                	addi	sp,sp,-48
    80004d12:	f406                	sd	ra,40(sp)
    80004d14:	f022                	sd	s0,32(sp)
    80004d16:	ec26                	sd	s1,24(sp)
    80004d18:	e84a                	sd	s2,16(sp)
    80004d1a:	e44e                	sd	s3,8(sp)
    80004d1c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004d1e:	00854783          	lbu	a5,8(a0)
    80004d22:	c3d5                	beqz	a5,80004dc6 <fileread+0xb6>
    80004d24:	84aa                	mv	s1,a0
    80004d26:	89ae                	mv	s3,a1
    80004d28:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d2a:	411c                	lw	a5,0(a0)
    80004d2c:	4705                	li	a4,1
    80004d2e:	04e78963          	beq	a5,a4,80004d80 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d32:	470d                	li	a4,3
    80004d34:	04e78d63          	beq	a5,a4,80004d8e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d38:	4709                	li	a4,2
    80004d3a:	06e79e63          	bne	a5,a4,80004db6 <fileread+0xa6>
    ilock(f->ip);
    80004d3e:	6d08                	ld	a0,24(a0)
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	ff8080e7          	jalr	-8(ra) # 80003d38 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d48:	874a                	mv	a4,s2
    80004d4a:	5094                	lw	a3,32(s1)
    80004d4c:	864e                	mv	a2,s3
    80004d4e:	4585                	li	a1,1
    80004d50:	6c88                	ld	a0,24(s1)
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	29a080e7          	jalr	666(ra) # 80003fec <readi>
    80004d5a:	892a                	mv	s2,a0
    80004d5c:	00a05563          	blez	a0,80004d66 <fileread+0x56>
      f->off += r;
    80004d60:	509c                	lw	a5,32(s1)
    80004d62:	9fa9                	addw	a5,a5,a0
    80004d64:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d66:	6c88                	ld	a0,24(s1)
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	092080e7          	jalr	146(ra) # 80003dfa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004d70:	854a                	mv	a0,s2
    80004d72:	70a2                	ld	ra,40(sp)
    80004d74:	7402                	ld	s0,32(sp)
    80004d76:	64e2                	ld	s1,24(sp)
    80004d78:	6942                	ld	s2,16(sp)
    80004d7a:	69a2                	ld	s3,8(sp)
    80004d7c:	6145                	addi	sp,sp,48
    80004d7e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d80:	6908                	ld	a0,16(a0)
    80004d82:	00000097          	auipc	ra,0x0
    80004d86:	3c0080e7          	jalr	960(ra) # 80005142 <piperead>
    80004d8a:	892a                	mv	s2,a0
    80004d8c:	b7d5                	j	80004d70 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d8e:	02451783          	lh	a5,36(a0)
    80004d92:	03079693          	slli	a3,a5,0x30
    80004d96:	92c1                	srli	a3,a3,0x30
    80004d98:	4725                	li	a4,9
    80004d9a:	02d76863          	bltu	a4,a3,80004dca <fileread+0xba>
    80004d9e:	0792                	slli	a5,a5,0x4
    80004da0:	0001d717          	auipc	a4,0x1d
    80004da4:	09870713          	addi	a4,a4,152 # 80021e38 <devsw>
    80004da8:	97ba                	add	a5,a5,a4
    80004daa:	639c                	ld	a5,0(a5)
    80004dac:	c38d                	beqz	a5,80004dce <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004dae:	4505                	li	a0,1
    80004db0:	9782                	jalr	a5
    80004db2:	892a                	mv	s2,a0
    80004db4:	bf75                	j	80004d70 <fileread+0x60>
    panic("fileread");
    80004db6:	00004517          	auipc	a0,0x4
    80004dba:	9ba50513          	addi	a0,a0,-1606 # 80008770 <syscalls+0x270>
    80004dbe:	ffffc097          	auipc	ra,0xffffc
    80004dc2:	80e080e7          	jalr	-2034(ra) # 800005cc <panic>
    return -1;
    80004dc6:	597d                	li	s2,-1
    80004dc8:	b765                	j	80004d70 <fileread+0x60>
      return -1;
    80004dca:	597d                	li	s2,-1
    80004dcc:	b755                	j	80004d70 <fileread+0x60>
    80004dce:	597d                	li	s2,-1
    80004dd0:	b745                	j	80004d70 <fileread+0x60>

0000000080004dd2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004dd2:	715d                	addi	sp,sp,-80
    80004dd4:	e486                	sd	ra,72(sp)
    80004dd6:	e0a2                	sd	s0,64(sp)
    80004dd8:	fc26                	sd	s1,56(sp)
    80004dda:	f84a                	sd	s2,48(sp)
    80004ddc:	f44e                	sd	s3,40(sp)
    80004dde:	f052                	sd	s4,32(sp)
    80004de0:	ec56                	sd	s5,24(sp)
    80004de2:	e85a                	sd	s6,16(sp)
    80004de4:	e45e                	sd	s7,8(sp)
    80004de6:	e062                	sd	s8,0(sp)
    80004de8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004dea:	00954783          	lbu	a5,9(a0)
    80004dee:	10078663          	beqz	a5,80004efa <filewrite+0x128>
    80004df2:	892a                	mv	s2,a0
    80004df4:	8aae                	mv	s5,a1
    80004df6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004df8:	411c                	lw	a5,0(a0)
    80004dfa:	4705                	li	a4,1
    80004dfc:	02e78263          	beq	a5,a4,80004e20 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e00:	470d                	li	a4,3
    80004e02:	02e78663          	beq	a5,a4,80004e2e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e06:	4709                	li	a4,2
    80004e08:	0ee79163          	bne	a5,a4,80004eea <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004e0c:	0ac05d63          	blez	a2,80004ec6 <filewrite+0xf4>
    int i = 0;
    80004e10:	4981                	li	s3,0
    80004e12:	6b05                	lui	s6,0x1
    80004e14:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004e18:	6b85                	lui	s7,0x1
    80004e1a:	c00b8b9b          	addiw	s7,s7,-1024
    80004e1e:	a861                	j	80004eb6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004e20:	6908                	ld	a0,16(a0)
    80004e22:	00000097          	auipc	ra,0x0
    80004e26:	22e080e7          	jalr	558(ra) # 80005050 <pipewrite>
    80004e2a:	8a2a                	mv	s4,a0
    80004e2c:	a045                	j	80004ecc <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e2e:	02451783          	lh	a5,36(a0)
    80004e32:	03079693          	slli	a3,a5,0x30
    80004e36:	92c1                	srli	a3,a3,0x30
    80004e38:	4725                	li	a4,9
    80004e3a:	0cd76263          	bltu	a4,a3,80004efe <filewrite+0x12c>
    80004e3e:	0792                	slli	a5,a5,0x4
    80004e40:	0001d717          	auipc	a4,0x1d
    80004e44:	ff870713          	addi	a4,a4,-8 # 80021e38 <devsw>
    80004e48:	97ba                	add	a5,a5,a4
    80004e4a:	679c                	ld	a5,8(a5)
    80004e4c:	cbdd                	beqz	a5,80004f02 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004e4e:	4505                	li	a0,1
    80004e50:	9782                	jalr	a5
    80004e52:	8a2a                	mv	s4,a0
    80004e54:	a8a5                	j	80004ecc <filewrite+0xfa>
    80004e56:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004e5a:	00000097          	auipc	ra,0x0
    80004e5e:	8b0080e7          	jalr	-1872(ra) # 8000470a <begin_op>
      ilock(f->ip);
    80004e62:	01893503          	ld	a0,24(s2)
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	ed2080e7          	jalr	-302(ra) # 80003d38 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e6e:	8762                	mv	a4,s8
    80004e70:	02092683          	lw	a3,32(s2)
    80004e74:	01598633          	add	a2,s3,s5
    80004e78:	4585                	li	a1,1
    80004e7a:	01893503          	ld	a0,24(s2)
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	266080e7          	jalr	614(ra) # 800040e4 <writei>
    80004e86:	84aa                	mv	s1,a0
    80004e88:	00a05763          	blez	a0,80004e96 <filewrite+0xc4>
        f->off += r;
    80004e8c:	02092783          	lw	a5,32(s2)
    80004e90:	9fa9                	addw	a5,a5,a0
    80004e92:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e96:	01893503          	ld	a0,24(s2)
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	f60080e7          	jalr	-160(ra) # 80003dfa <iunlock>
      end_op();
    80004ea2:	00000097          	auipc	ra,0x0
    80004ea6:	8e8080e7          	jalr	-1816(ra) # 8000478a <end_op>

      if(r != n1){
    80004eaa:	009c1f63          	bne	s8,s1,80004ec8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004eae:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004eb2:	0149db63          	bge	s3,s4,80004ec8 <filewrite+0xf6>
      int n1 = n - i;
    80004eb6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004eba:	84be                	mv	s1,a5
    80004ebc:	2781                	sext.w	a5,a5
    80004ebe:	f8fb5ce3          	bge	s6,a5,80004e56 <filewrite+0x84>
    80004ec2:	84de                	mv	s1,s7
    80004ec4:	bf49                	j	80004e56 <filewrite+0x84>
    int i = 0;
    80004ec6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004ec8:	013a1f63          	bne	s4,s3,80004ee6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004ecc:	8552                	mv	a0,s4
    80004ece:	60a6                	ld	ra,72(sp)
    80004ed0:	6406                	ld	s0,64(sp)
    80004ed2:	74e2                	ld	s1,56(sp)
    80004ed4:	7942                	ld	s2,48(sp)
    80004ed6:	79a2                	ld	s3,40(sp)
    80004ed8:	7a02                	ld	s4,32(sp)
    80004eda:	6ae2                	ld	s5,24(sp)
    80004edc:	6b42                	ld	s6,16(sp)
    80004ede:	6ba2                	ld	s7,8(sp)
    80004ee0:	6c02                	ld	s8,0(sp)
    80004ee2:	6161                	addi	sp,sp,80
    80004ee4:	8082                	ret
    ret = (i == n ? n : -1);
    80004ee6:	5a7d                	li	s4,-1
    80004ee8:	b7d5                	j	80004ecc <filewrite+0xfa>
    panic("filewrite");
    80004eea:	00004517          	auipc	a0,0x4
    80004eee:	89650513          	addi	a0,a0,-1898 # 80008780 <syscalls+0x280>
    80004ef2:	ffffb097          	auipc	ra,0xffffb
    80004ef6:	6da080e7          	jalr	1754(ra) # 800005cc <panic>
    return -1;
    80004efa:	5a7d                	li	s4,-1
    80004efc:	bfc1                	j	80004ecc <filewrite+0xfa>
      return -1;
    80004efe:	5a7d                	li	s4,-1
    80004f00:	b7f1                	j	80004ecc <filewrite+0xfa>
    80004f02:	5a7d                	li	s4,-1
    80004f04:	b7e1                	j	80004ecc <filewrite+0xfa>

0000000080004f06 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f06:	7179                	addi	sp,sp,-48
    80004f08:	f406                	sd	ra,40(sp)
    80004f0a:	f022                	sd	s0,32(sp)
    80004f0c:	ec26                	sd	s1,24(sp)
    80004f0e:	e84a                	sd	s2,16(sp)
    80004f10:	e44e                	sd	s3,8(sp)
    80004f12:	e052                	sd	s4,0(sp)
    80004f14:	1800                	addi	s0,sp,48
    80004f16:	84aa                	mv	s1,a0
    80004f18:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f1a:	0005b023          	sd	zero,0(a1)
    80004f1e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f22:	00000097          	auipc	ra,0x0
    80004f26:	bf8080e7          	jalr	-1032(ra) # 80004b1a <filealloc>
    80004f2a:	e088                	sd	a0,0(s1)
    80004f2c:	c551                	beqz	a0,80004fb8 <pipealloc+0xb2>
    80004f2e:	00000097          	auipc	ra,0x0
    80004f32:	bec080e7          	jalr	-1044(ra) # 80004b1a <filealloc>
    80004f36:	00aa3023          	sd	a0,0(s4)
    80004f3a:	c92d                	beqz	a0,80004fac <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f3c:	ffffc097          	auipc	ra,0xffffc
    80004f40:	c0e080e7          	jalr	-1010(ra) # 80000b4a <kalloc>
    80004f44:	892a                	mv	s2,a0
    80004f46:	c125                	beqz	a0,80004fa6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004f48:	4985                	li	s3,1
    80004f4a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f4e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f52:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f56:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f5a:	00004597          	auipc	a1,0x4
    80004f5e:	83658593          	addi	a1,a1,-1994 # 80008790 <syscalls+0x290>
    80004f62:	ffffc097          	auipc	ra,0xffffc
    80004f66:	c48080e7          	jalr	-952(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004f6a:	609c                	ld	a5,0(s1)
    80004f6c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f70:	609c                	ld	a5,0(s1)
    80004f72:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f76:	609c                	ld	a5,0(s1)
    80004f78:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f7c:	609c                	ld	a5,0(s1)
    80004f7e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f82:	000a3783          	ld	a5,0(s4)
    80004f86:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f8a:	000a3783          	ld	a5,0(s4)
    80004f8e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f92:	000a3783          	ld	a5,0(s4)
    80004f96:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f9a:	000a3783          	ld	a5,0(s4)
    80004f9e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004fa2:	4501                	li	a0,0
    80004fa4:	a025                	j	80004fcc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fa6:	6088                	ld	a0,0(s1)
    80004fa8:	e501                	bnez	a0,80004fb0 <pipealloc+0xaa>
    80004faa:	a039                	j	80004fb8 <pipealloc+0xb2>
    80004fac:	6088                	ld	a0,0(s1)
    80004fae:	c51d                	beqz	a0,80004fdc <pipealloc+0xd6>
    fileclose(*f0);
    80004fb0:	00000097          	auipc	ra,0x0
    80004fb4:	c26080e7          	jalr	-986(ra) # 80004bd6 <fileclose>
  if(*f1)
    80004fb8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fbc:	557d                	li	a0,-1
  if(*f1)
    80004fbe:	c799                	beqz	a5,80004fcc <pipealloc+0xc6>
    fileclose(*f1);
    80004fc0:	853e                	mv	a0,a5
    80004fc2:	00000097          	auipc	ra,0x0
    80004fc6:	c14080e7          	jalr	-1004(ra) # 80004bd6 <fileclose>
  return -1;
    80004fca:	557d                	li	a0,-1
}
    80004fcc:	70a2                	ld	ra,40(sp)
    80004fce:	7402                	ld	s0,32(sp)
    80004fd0:	64e2                	ld	s1,24(sp)
    80004fd2:	6942                	ld	s2,16(sp)
    80004fd4:	69a2                	ld	s3,8(sp)
    80004fd6:	6a02                	ld	s4,0(sp)
    80004fd8:	6145                	addi	sp,sp,48
    80004fda:	8082                	ret
  return -1;
    80004fdc:	557d                	li	a0,-1
    80004fde:	b7fd                	j	80004fcc <pipealloc+0xc6>

0000000080004fe0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004fe0:	1101                	addi	sp,sp,-32
    80004fe2:	ec06                	sd	ra,24(sp)
    80004fe4:	e822                	sd	s0,16(sp)
    80004fe6:	e426                	sd	s1,8(sp)
    80004fe8:	e04a                	sd	s2,0(sp)
    80004fea:	1000                	addi	s0,sp,32
    80004fec:	84aa                	mv	s1,a0
    80004fee:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ff0:	ffffc097          	auipc	ra,0xffffc
    80004ff4:	c4a080e7          	jalr	-950(ra) # 80000c3a <acquire>
  if(writable){
    80004ff8:	02090d63          	beqz	s2,80005032 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ffc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005000:	21848513          	addi	a0,s1,536
    80005004:	ffffd097          	auipc	ra,0xffffd
    80005008:	6ce080e7          	jalr	1742(ra) # 800026d2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000500c:	2204b783          	ld	a5,544(s1)
    80005010:	eb95                	bnez	a5,80005044 <pipeclose+0x64>
    release(&pi->lock);
    80005012:	8526                	mv	a0,s1
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	cda080e7          	jalr	-806(ra) # 80000cee <release>
    kfree((char*)pi);
    8000501c:	8526                	mv	a0,s1
    8000501e:	ffffc097          	auipc	ra,0xffffc
    80005022:	a30080e7          	jalr	-1488(ra) # 80000a4e <kfree>
  } else
    release(&pi->lock);
}
    80005026:	60e2                	ld	ra,24(sp)
    80005028:	6442                	ld	s0,16(sp)
    8000502a:	64a2                	ld	s1,8(sp)
    8000502c:	6902                	ld	s2,0(sp)
    8000502e:	6105                	addi	sp,sp,32
    80005030:	8082                	ret
    pi->readopen = 0;
    80005032:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005036:	21c48513          	addi	a0,s1,540
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	698080e7          	jalr	1688(ra) # 800026d2 <wakeup>
    80005042:	b7e9                	j	8000500c <pipeclose+0x2c>
    release(&pi->lock);
    80005044:	8526                	mv	a0,s1
    80005046:	ffffc097          	auipc	ra,0xffffc
    8000504a:	ca8080e7          	jalr	-856(ra) # 80000cee <release>
}
    8000504e:	bfe1                	j	80005026 <pipeclose+0x46>

0000000080005050 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005050:	711d                	addi	sp,sp,-96
    80005052:	ec86                	sd	ra,88(sp)
    80005054:	e8a2                	sd	s0,80(sp)
    80005056:	e4a6                	sd	s1,72(sp)
    80005058:	e0ca                	sd	s2,64(sp)
    8000505a:	fc4e                	sd	s3,56(sp)
    8000505c:	f852                	sd	s4,48(sp)
    8000505e:	f456                	sd	s5,40(sp)
    80005060:	f05a                	sd	s6,32(sp)
    80005062:	ec5e                	sd	s7,24(sp)
    80005064:	e862                	sd	s8,16(sp)
    80005066:	1080                	addi	s0,sp,96
    80005068:	84aa                	mv	s1,a0
    8000506a:	8aae                	mv	s5,a1
    8000506c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	c26080e7          	jalr	-986(ra) # 80001c94 <myproc>
    80005076:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005078:	8526                	mv	a0,s1
    8000507a:	ffffc097          	auipc	ra,0xffffc
    8000507e:	bc0080e7          	jalr	-1088(ra) # 80000c3a <acquire>
  while(i < n){
    80005082:	0b405363          	blez	s4,80005128 <pipewrite+0xd8>
  int i = 0;
    80005086:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005088:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000508a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000508e:	21c48b93          	addi	s7,s1,540
    80005092:	a089                	j	800050d4 <pipewrite+0x84>
      release(&pi->lock);
    80005094:	8526                	mv	a0,s1
    80005096:	ffffc097          	auipc	ra,0xffffc
    8000509a:	c58080e7          	jalr	-936(ra) # 80000cee <release>
      return -1;
    8000509e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050a0:	854a                	mv	a0,s2
    800050a2:	60e6                	ld	ra,88(sp)
    800050a4:	6446                	ld	s0,80(sp)
    800050a6:	64a6                	ld	s1,72(sp)
    800050a8:	6906                	ld	s2,64(sp)
    800050aa:	79e2                	ld	s3,56(sp)
    800050ac:	7a42                	ld	s4,48(sp)
    800050ae:	7aa2                	ld	s5,40(sp)
    800050b0:	7b02                	ld	s6,32(sp)
    800050b2:	6be2                	ld	s7,24(sp)
    800050b4:	6c42                	ld	s8,16(sp)
    800050b6:	6125                	addi	sp,sp,96
    800050b8:	8082                	ret
      wakeup(&pi->nread);
    800050ba:	8562                	mv	a0,s8
    800050bc:	ffffd097          	auipc	ra,0xffffd
    800050c0:	616080e7          	jalr	1558(ra) # 800026d2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050c4:	85a6                	mv	a1,s1
    800050c6:	855e                	mv	a0,s7
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	47e080e7          	jalr	1150(ra) # 80002546 <sleep>
  while(i < n){
    800050d0:	05495d63          	bge	s2,s4,8000512a <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800050d4:	2204a783          	lw	a5,544(s1)
    800050d8:	dfd5                	beqz	a5,80005094 <pipewrite+0x44>
    800050da:	0289a783          	lw	a5,40(s3)
    800050de:	fbdd                	bnez	a5,80005094 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050e0:	2184a783          	lw	a5,536(s1)
    800050e4:	21c4a703          	lw	a4,540(s1)
    800050e8:	2007879b          	addiw	a5,a5,512
    800050ec:	fcf707e3          	beq	a4,a5,800050ba <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050f0:	4685                	li	a3,1
    800050f2:	01590633          	add	a2,s2,s5
    800050f6:	faf40593          	addi	a1,s0,-81
    800050fa:	0589b503          	ld	a0,88(s3)
    800050fe:	ffffd097          	auipc	ra,0xffffd
    80005102:	88c080e7          	jalr	-1908(ra) # 8000198a <copyin>
    80005106:	03650263          	beq	a0,s6,8000512a <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000510a:	21c4a783          	lw	a5,540(s1)
    8000510e:	0017871b          	addiw	a4,a5,1
    80005112:	20e4ae23          	sw	a4,540(s1)
    80005116:	1ff7f793          	andi	a5,a5,511
    8000511a:	97a6                	add	a5,a5,s1
    8000511c:	faf44703          	lbu	a4,-81(s0)
    80005120:	00e78c23          	sb	a4,24(a5)
      i++;
    80005124:	2905                	addiw	s2,s2,1
    80005126:	b76d                	j	800050d0 <pipewrite+0x80>
  int i = 0;
    80005128:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000512a:	21848513          	addi	a0,s1,536
    8000512e:	ffffd097          	auipc	ra,0xffffd
    80005132:	5a4080e7          	jalr	1444(ra) # 800026d2 <wakeup>
  release(&pi->lock);
    80005136:	8526                	mv	a0,s1
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	bb6080e7          	jalr	-1098(ra) # 80000cee <release>
  return i;
    80005140:	b785                	j	800050a0 <pipewrite+0x50>

0000000080005142 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005142:	715d                	addi	sp,sp,-80
    80005144:	e486                	sd	ra,72(sp)
    80005146:	e0a2                	sd	s0,64(sp)
    80005148:	fc26                	sd	s1,56(sp)
    8000514a:	f84a                	sd	s2,48(sp)
    8000514c:	f44e                	sd	s3,40(sp)
    8000514e:	f052                	sd	s4,32(sp)
    80005150:	ec56                	sd	s5,24(sp)
    80005152:	e85a                	sd	s6,16(sp)
    80005154:	0880                	addi	s0,sp,80
    80005156:	84aa                	mv	s1,a0
    80005158:	892e                	mv	s2,a1
    8000515a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000515c:	ffffd097          	auipc	ra,0xffffd
    80005160:	b38080e7          	jalr	-1224(ra) # 80001c94 <myproc>
    80005164:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005166:	8526                	mv	a0,s1
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	ad2080e7          	jalr	-1326(ra) # 80000c3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005170:	2184a703          	lw	a4,536(s1)
    80005174:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005178:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000517c:	02f71463          	bne	a4,a5,800051a4 <piperead+0x62>
    80005180:	2244a783          	lw	a5,548(s1)
    80005184:	c385                	beqz	a5,800051a4 <piperead+0x62>
    if(pr->killed){
    80005186:	028a2783          	lw	a5,40(s4)
    8000518a:	ebc1                	bnez	a5,8000521a <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000518c:	85a6                	mv	a1,s1
    8000518e:	854e                	mv	a0,s3
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	3b6080e7          	jalr	950(ra) # 80002546 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005198:	2184a703          	lw	a4,536(s1)
    8000519c:	21c4a783          	lw	a5,540(s1)
    800051a0:	fef700e3          	beq	a4,a5,80005180 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051a4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051a6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051a8:	05505363          	blez	s5,800051ee <piperead+0xac>
    if(pi->nread == pi->nwrite)
    800051ac:	2184a783          	lw	a5,536(s1)
    800051b0:	21c4a703          	lw	a4,540(s1)
    800051b4:	02f70d63          	beq	a4,a5,800051ee <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051b8:	0017871b          	addiw	a4,a5,1
    800051bc:	20e4ac23          	sw	a4,536(s1)
    800051c0:	1ff7f793          	andi	a5,a5,511
    800051c4:	97a6                	add	a5,a5,s1
    800051c6:	0187c783          	lbu	a5,24(a5)
    800051ca:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051ce:	4685                	li	a3,1
    800051d0:	fbf40613          	addi	a2,s0,-65
    800051d4:	85ca                	mv	a1,s2
    800051d6:	058a3503          	ld	a0,88(s4)
    800051da:	ffffc097          	auipc	ra,0xffffc
    800051de:	6aa080e7          	jalr	1706(ra) # 80001884 <copyout>
    800051e2:	01650663          	beq	a0,s6,800051ee <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051e6:	2985                	addiw	s3,s3,1
    800051e8:	0905                	addi	s2,s2,1
    800051ea:	fd3a91e3          	bne	s5,s3,800051ac <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800051ee:	21c48513          	addi	a0,s1,540
    800051f2:	ffffd097          	auipc	ra,0xffffd
    800051f6:	4e0080e7          	jalr	1248(ra) # 800026d2 <wakeup>
  release(&pi->lock);
    800051fa:	8526                	mv	a0,s1
    800051fc:	ffffc097          	auipc	ra,0xffffc
    80005200:	af2080e7          	jalr	-1294(ra) # 80000cee <release>
  return i;
}
    80005204:	854e                	mv	a0,s3
    80005206:	60a6                	ld	ra,72(sp)
    80005208:	6406                	ld	s0,64(sp)
    8000520a:	74e2                	ld	s1,56(sp)
    8000520c:	7942                	ld	s2,48(sp)
    8000520e:	79a2                	ld	s3,40(sp)
    80005210:	7a02                	ld	s4,32(sp)
    80005212:	6ae2                	ld	s5,24(sp)
    80005214:	6b42                	ld	s6,16(sp)
    80005216:	6161                	addi	sp,sp,80
    80005218:	8082                	ret
      release(&pi->lock);
    8000521a:	8526                	mv	a0,s1
    8000521c:	ffffc097          	auipc	ra,0xffffc
    80005220:	ad2080e7          	jalr	-1326(ra) # 80000cee <release>
      return -1;
    80005224:	59fd                	li	s3,-1
    80005226:	bff9                	j	80005204 <piperead+0xc2>

0000000080005228 <exec>:
extern char trampoline[]; // trampoline.S
extern struct proc proc[NPROC];
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    80005228:	dd010113          	addi	sp,sp,-560
    8000522c:	22113423          	sd	ra,552(sp)
    80005230:	22813023          	sd	s0,544(sp)
    80005234:	20913c23          	sd	s1,536(sp)
    80005238:	21213823          	sd	s2,528(sp)
    8000523c:	21313423          	sd	s3,520(sp)
    80005240:	21413023          	sd	s4,512(sp)
    80005244:	ffd6                	sd	s5,504(sp)
    80005246:	fbda                	sd	s6,496(sp)
    80005248:	f7de                	sd	s7,488(sp)
    8000524a:	f3e2                	sd	s8,480(sp)
    8000524c:	efe6                	sd	s9,472(sp)
    8000524e:	ebea                	sd	s10,464(sp)
    80005250:	e7ee                	sd	s11,456(sp)
    80005252:	1c00                	addi	s0,sp,560
    80005254:	84aa                	mv	s1,a0
    80005256:	dea43023          	sd	a0,-544(s0)
    8000525a:	deb43423          	sd	a1,-536(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000525e:	ffffd097          	auipc	ra,0xffffd
    80005262:	a36080e7          	jalr	-1482(ra) # 80001c94 <myproc>
    80005266:	dea43c23          	sd	a0,-520(s0)

  begin_op();
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	4a0080e7          	jalr	1184(ra) # 8000470a <begin_op>

  if ((ip = namei(path)) == 0) {
    80005272:	8526                	mv	a0,s1
    80005274:	fffff097          	auipc	ra,0xfffff
    80005278:	27a080e7          	jalr	634(ra) # 800044ee <namei>
    8000527c:	cd2d                	beqz	a0,800052f6 <exec+0xce>
    8000527e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005280:	fffff097          	auipc	ra,0xfffff
    80005284:	ab8080e7          	jalr	-1352(ra) # 80003d38 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005288:	04000713          	li	a4,64
    8000528c:	4681                	li	a3,0
    8000528e:	e4840613          	addi	a2,s0,-440
    80005292:	4581                	li	a1,0
    80005294:	8556                	mv	a0,s5
    80005296:	fffff097          	auipc	ra,0xfffff
    8000529a:	d56080e7          	jalr	-682(ra) # 80003fec <readi>
    8000529e:	04000793          	li	a5,64
    800052a2:	00f51a63          	bne	a0,a5,800052b6 <exec+0x8e>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    800052a6:	e4842703          	lw	a4,-440(s0)
    800052aa:	464c47b7          	lui	a5,0x464c4
    800052ae:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800052b2:	04f70863          	beq	a4,a5,80005302 <exec+0xda>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800052b6:	8556                	mv	a0,s5
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	ce2080e7          	jalr	-798(ra) # 80003f9a <iunlockput>
    end_op();
    800052c0:	fffff097          	auipc	ra,0xfffff
    800052c4:	4ca080e7          	jalr	1226(ra) # 8000478a <end_op>
  }
  return -1;
    800052c8:	557d                	li	a0,-1
}
    800052ca:	22813083          	ld	ra,552(sp)
    800052ce:	22013403          	ld	s0,544(sp)
    800052d2:	21813483          	ld	s1,536(sp)
    800052d6:	21013903          	ld	s2,528(sp)
    800052da:	20813983          	ld	s3,520(sp)
    800052de:	20013a03          	ld	s4,512(sp)
    800052e2:	7afe                	ld	s5,504(sp)
    800052e4:	7b5e                	ld	s6,496(sp)
    800052e6:	7bbe                	ld	s7,488(sp)
    800052e8:	7c1e                	ld	s8,480(sp)
    800052ea:	6cfe                	ld	s9,472(sp)
    800052ec:	6d5e                	ld	s10,464(sp)
    800052ee:	6dbe                	ld	s11,456(sp)
    800052f0:	23010113          	addi	sp,sp,560
    800052f4:	8082                	ret
    end_op();
    800052f6:	fffff097          	auipc	ra,0xfffff
    800052fa:	494080e7          	jalr	1172(ra) # 8000478a <end_op>
    return -1;
    800052fe:	557d                	li	a0,-1
    80005300:	b7e9                	j	800052ca <exec+0xa2>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005302:	df843503          	ld	a0,-520(s0)
    80005306:	ffffd097          	auipc	ra,0xffffd
    8000530a:	a52080e7          	jalr	-1454(ra) # 80001d58 <proc_pagetable>
    8000530e:	8b2a                	mv	s6,a0
    80005310:	d15d                	beqz	a0,800052b6 <exec+0x8e>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005312:	e6842783          	lw	a5,-408(s0)
    80005316:	e8045703          	lhu	a4,-384(s0)
    8000531a:	c735                	beqz	a4,80005386 <exec+0x15e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    8000531c:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000531e:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    80005322:	6a05                	lui	s4,0x1
    80005324:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005328:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    8000532c:	6d85                	lui	s11,0x1
    8000532e:	7d7d                	lui	s10,0xfffff
    80005330:	ac81                	j	80005580 <exec+0x358>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	46650513          	addi	a0,a0,1126 # 80008798 <syscalls+0x298>
    8000533a:	ffffb097          	auipc	ra,0xffffb
    8000533e:	292080e7          	jalr	658(ra) # 800005cc <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80005342:	874a                	mv	a4,s2
    80005344:	009c86bb          	addw	a3,s9,s1
    80005348:	4581                	li	a1,0
    8000534a:	8556                	mv	a0,s5
    8000534c:	fffff097          	auipc	ra,0xfffff
    80005350:	ca0080e7          	jalr	-864(ra) # 80003fec <readi>
    80005354:	2501                	sext.w	a0,a0
    80005356:	1ca91563          	bne	s2,a0,80005520 <exec+0x2f8>
  for (i = 0; i < sz; i += PGSIZE) {
    8000535a:	009d84bb          	addw	s1,s11,s1
    8000535e:	013d09bb          	addw	s3,s10,s3
    80005362:	1f74ff63          	bgeu	s1,s7,80005560 <exec+0x338>
    pa = walkaddr(pagetable, va + i);
    80005366:	02049593          	slli	a1,s1,0x20
    8000536a:	9181                	srli	a1,a1,0x20
    8000536c:	95e2                	add	a1,a1,s8
    8000536e:	855a                	mv	a0,s6
    80005370:	ffffc097          	auipc	ra,0xffffc
    80005374:	d54080e7          	jalr	-684(ra) # 800010c4 <walkaddr>
    80005378:	862a                	mv	a2,a0
    if (pa == 0)
    8000537a:	dd45                	beqz	a0,80005332 <exec+0x10a>
      n = PGSIZE;
    8000537c:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    8000537e:	fd49f2e3          	bgeu	s3,s4,80005342 <exec+0x11a>
      n = sz - i;
    80005382:	894e                	mv	s2,s3
    80005384:	bf7d                	j	80005342 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80005386:	4481                	li	s1,0
  iunlockput(ip);
    80005388:	8556                	mv	a0,s5
    8000538a:	fffff097          	auipc	ra,0xfffff
    8000538e:	c10080e7          	jalr	-1008(ra) # 80003f9a <iunlockput>
  end_op();
    80005392:	fffff097          	auipc	ra,0xfffff
    80005396:	3f8080e7          	jalr	1016(ra) # 8000478a <end_op>
  uint64 oldsz = p->sz;
    8000539a:	df843983          	ld	s3,-520(s0)
    8000539e:	0509bc83          	ld	s9,80(s3)
  sz = PGROUNDUP(sz);
    800053a2:	6785                	lui	a5,0x1
    800053a4:	17fd                	addi	a5,a5,-1
    800053a6:	94be                	add	s1,s1,a5
    800053a8:	77fd                	lui	a5,0xfffff
    800053aa:	00f4f933          	and	s2,s1,a5
    800053ae:	df243823          	sd	s2,-528(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + (1 << 6) * PGSIZE)) == 0)
    800053b2:	000404b7          	lui	s1,0x40
    800053b6:	94ca                	add	s1,s1,s2
    800053b8:	8626                	mv	a2,s1
    800053ba:	85ca                	mv	a1,s2
    800053bc:	855a                	mv	a0,s6
    800053be:	ffffc097          	auipc	ra,0xffffc
    800053c2:	116080e7          	jalr	278(ra) # 800014d4 <uvmalloc>
    800053c6:	8baa                	mv	s7,a0
  ip = 0;
    800053c8:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + (1 << 6) * PGSIZE)) == 0)
    800053ca:	14050b63          	beqz	a0,80005520 <exec+0x2f8>
  uvmapping(pagetable, p->k_pagetable, sz, sz + (1 << 6) * PGSIZE);
    800053ce:	86a6                	mv	a3,s1
    800053d0:	864a                	mv	a2,s2
    800053d2:	0609b583          	ld	a1,96(s3)
    800053d6:	855a                	mv	a0,s6
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	02a080e7          	jalr	42(ra) # 80001402 <uvmapping>
  uvmclear(pagetable, sz - (1 << 6) * PGSIZE);
    800053e0:	fffc05b7          	lui	a1,0xfffc0
    800053e4:	95de                	add	a1,a1,s7
    800053e6:	855a                	mv	a0,s6
    800053e8:	ffffc097          	auipc	ra,0xffffc
    800053ec:	46a080e7          	jalr	1130(ra) # 80001852 <uvmclear>
  stackbase = sp - PGSIZE;
    800053f0:	7afd                	lui	s5,0xfffff
    800053f2:	9ade                	add	s5,s5,s7
  for (argc = 0; argv[argc]; argc++) {
    800053f4:	de843783          	ld	a5,-536(s0)
    800053f8:	6388                	ld	a0,0(a5)
    800053fa:	c925                	beqz	a0,8000546a <exec+0x242>
    800053fc:	e8840993          	addi	s3,s0,-376
    80005400:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005404:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    80005406:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005408:	ffffc097          	auipc	ra,0xffffc
    8000540c:	ab2080e7          	jalr	-1358(ra) # 80000eba <strlen>
    80005410:	0015079b          	addiw	a5,a0,1
    80005414:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005418:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000541c:	13596663          	bltu	s2,s5,80005548 <exec+0x320>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005420:	de843d03          	ld	s10,-536(s0)
    80005424:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80005428:	8552                	mv	a0,s4
    8000542a:	ffffc097          	auipc	ra,0xffffc
    8000542e:	a90080e7          	jalr	-1392(ra) # 80000eba <strlen>
    80005432:	0015069b          	addiw	a3,a0,1
    80005436:	8652                	mv	a2,s4
    80005438:	85ca                	mv	a1,s2
    8000543a:	855a                	mv	a0,s6
    8000543c:	ffffc097          	auipc	ra,0xffffc
    80005440:	448080e7          	jalr	1096(ra) # 80001884 <copyout>
    80005444:	10054663          	bltz	a0,80005550 <exec+0x328>
    ustack[argc] = sp;
    80005448:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000544c:	0485                	addi	s1,s1,1
    8000544e:	008d0793          	addi	a5,s10,8
    80005452:	def43423          	sd	a5,-536(s0)
    80005456:	008d3503          	ld	a0,8(s10)
    8000545a:	c911                	beqz	a0,8000546e <exec+0x246>
    if (argc >= MAXARG)
    8000545c:	09a1                	addi	s3,s3,8
    8000545e:	fb3c15e3          	bne	s8,s3,80005408 <exec+0x1e0>
  sz = sz1;
    80005462:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005466:	4a81                	li	s5,0
    80005468:	a865                	j	80005520 <exec+0x2f8>
  sp = sz;
    8000546a:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    8000546c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000546e:	00349793          	slli	a5,s1,0x3
    80005472:	f9040713          	addi	a4,s0,-112
    80005476:	97ba                	add	a5,a5,a4
    80005478:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc + 1) * sizeof(uint64);
    8000547c:	00148693          	addi	a3,s1,1 # 40001 <_entry-0x7ffbffff>
    80005480:	068e                	slli	a3,a3,0x3
    80005482:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005486:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000548a:	01597663          	bgeu	s2,s5,80005496 <exec+0x26e>
  sz = sz1;
    8000548e:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005492:	4a81                	li	s5,0
    80005494:	a071                	j	80005520 <exec+0x2f8>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80005496:	e8840613          	addi	a2,s0,-376
    8000549a:	85ca                	mv	a1,s2
    8000549c:	855a                	mv	a0,s6
    8000549e:	ffffc097          	auipc	ra,0xffffc
    800054a2:	3e6080e7          	jalr	998(ra) # 80001884 <copyout>
    800054a6:	0a054963          	bltz	a0,80005558 <exec+0x330>
  p->trapframe->a1 = sp;
    800054aa:	df843783          	ld	a5,-520(s0)
    800054ae:	77bc                	ld	a5,104(a5)
    800054b0:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800054b4:	de043783          	ld	a5,-544(s0)
    800054b8:	0007c703          	lbu	a4,0(a5)
    800054bc:	cf11                	beqz	a4,800054d8 <exec+0x2b0>
    800054be:	0785                	addi	a5,a5,1
    if (*s == '/')
    800054c0:	02f00693          	li	a3,47
    800054c4:	a039                	j	800054d2 <exec+0x2aa>
      last = s + 1;
    800054c6:	def43023          	sd	a5,-544(s0)
  for (last = s = path; *s; s++)
    800054ca:	0785                	addi	a5,a5,1
    800054cc:	fff7c703          	lbu	a4,-1(a5)
    800054d0:	c701                	beqz	a4,800054d8 <exec+0x2b0>
    if (*s == '/')
    800054d2:	fed71ce3          	bne	a4,a3,800054ca <exec+0x2a2>
    800054d6:	bfc5                	j	800054c6 <exec+0x29e>
  safestrcpy(p->name, last, sizeof(p->name));
    800054d8:	4641                	li	a2,16
    800054da:	de043583          	ld	a1,-544(s0)
    800054de:	df843983          	ld	s3,-520(s0)
    800054e2:	18098513          	addi	a0,s3,384
    800054e6:	ffffc097          	auipc	ra,0xffffc
    800054ea:	9a2080e7          	jalr	-1630(ra) # 80000e88 <safestrcpy>
  oldpagetable = p->pagetable;
    800054ee:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    800054f2:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    800054f6:	0579b823          	sd	s7,80(s3)
  p->trapframe->epc = elf.entry; // initial program counter = main
    800054fa:	0689b783          	ld	a5,104(s3)
    800054fe:	e6043703          	ld	a4,-416(s0)
    80005502:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80005504:	0689b783          	ld	a5,104(s3)
    80005508:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000550c:	85e6                	mv	a1,s9
    8000550e:	ffffd097          	auipc	ra,0xffffd
    80005512:	8e6080e7          	jalr	-1818(ra) # 80001df4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005516:	0004851b          	sext.w	a0,s1
    8000551a:	bb45                	j	800052ca <exec+0xa2>
    8000551c:	de943823          	sd	s1,-528(s0)
    proc_freepagetable(pagetable, sz);
    80005520:	df043583          	ld	a1,-528(s0)
    80005524:	855a                	mv	a0,s6
    80005526:	ffffd097          	auipc	ra,0xffffd
    8000552a:	8ce080e7          	jalr	-1842(ra) # 80001df4 <proc_freepagetable>
  if (ip) {
    8000552e:	d80a94e3          	bnez	s5,800052b6 <exec+0x8e>
  return -1;
    80005532:	557d                	li	a0,-1
    80005534:	bb59                	j	800052ca <exec+0xa2>
    80005536:	de943823          	sd	s1,-528(s0)
    8000553a:	b7dd                	j	80005520 <exec+0x2f8>
    8000553c:	de943823          	sd	s1,-528(s0)
    80005540:	b7c5                	j	80005520 <exec+0x2f8>
    80005542:	de943823          	sd	s1,-528(s0)
    80005546:	bfe9                	j	80005520 <exec+0x2f8>
  sz = sz1;
    80005548:	df743823          	sd	s7,-528(s0)
  ip = 0;
    8000554c:	4a81                	li	s5,0
    8000554e:	bfc9                	j	80005520 <exec+0x2f8>
  sz = sz1;
    80005550:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005554:	4a81                	li	s5,0
    80005556:	b7e9                	j	80005520 <exec+0x2f8>
  sz = sz1;
    80005558:	df743823          	sd	s7,-528(s0)
  ip = 0;
    8000555c:	4a81                	li	s5,0
    8000555e:	b7c9                	j	80005520 <exec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005560:	df043483          	ld	s1,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005564:	e0843783          	ld	a5,-504(s0)
    80005568:	0017869b          	addiw	a3,a5,1
    8000556c:	e0d43423          	sd	a3,-504(s0)
    80005570:	e0043783          	ld	a5,-512(s0)
    80005574:	0387879b          	addiw	a5,a5,56
    80005578:	e8045703          	lhu	a4,-384(s0)
    8000557c:	e0e6d6e3          	bge	a3,a4,80005388 <exec+0x160>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005580:	2781                	sext.w	a5,a5
    80005582:	e0f43023          	sd	a5,-512(s0)
    80005586:	03800713          	li	a4,56
    8000558a:	86be                	mv	a3,a5
    8000558c:	e1040613          	addi	a2,s0,-496
    80005590:	4581                	li	a1,0
    80005592:	8556                	mv	a0,s5
    80005594:	fffff097          	auipc	ra,0xfffff
    80005598:	a58080e7          	jalr	-1448(ra) # 80003fec <readi>
    8000559c:	03800793          	li	a5,56
    800055a0:	f6f51ee3          	bne	a0,a5,8000551c <exec+0x2f4>
    if (ph.type != ELF_PROG_LOAD)
    800055a4:	e1042783          	lw	a5,-496(s0)
    800055a8:	4705                	li	a4,1
    800055aa:	fae79de3          	bne	a5,a4,80005564 <exec+0x33c>
    if (ph.memsz < ph.filesz)
    800055ae:	e3843603          	ld	a2,-456(s0)
    800055b2:	e3043783          	ld	a5,-464(s0)
    800055b6:	f8f660e3          	bltu	a2,a5,80005536 <exec+0x30e>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800055ba:	e2043783          	ld	a5,-480(s0)
    800055be:	963e                	add	a2,a2,a5
    800055c0:	f6f66ee3          	bltu	a2,a5,8000553c <exec+0x314>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800055c4:	85a6                	mv	a1,s1
    800055c6:	855a                	mv	a0,s6
    800055c8:	ffffc097          	auipc	ra,0xffffc
    800055cc:	f0c080e7          	jalr	-244(ra) # 800014d4 <uvmalloc>
    800055d0:	dea43823          	sd	a0,-528(s0)
    800055d4:	d53d                	beqz	a0,80005542 <exec+0x31a>
    uvmapping(pagetable, p->k_pagetable, sz, ph.vaddr + ph.memsz);
    800055d6:	e2043683          	ld	a3,-480(s0)
    800055da:	e3843783          	ld	a5,-456(s0)
    800055de:	96be                	add	a3,a3,a5
    800055e0:	8626                	mv	a2,s1
    800055e2:	df843783          	ld	a5,-520(s0)
    800055e6:	73ac                	ld	a1,96(a5)
    800055e8:	855a                	mv	a0,s6
    800055ea:	ffffc097          	auipc	ra,0xffffc
    800055ee:	e18080e7          	jalr	-488(ra) # 80001402 <uvmapping>
    if (ph.vaddr % PGSIZE != 0)
    800055f2:	e2043c03          	ld	s8,-480(s0)
    800055f6:	dd843783          	ld	a5,-552(s0)
    800055fa:	00fc77b3          	and	a5,s8,a5
    800055fe:	f38d                	bnez	a5,80005520 <exec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005600:	e1842c83          	lw	s9,-488(s0)
    80005604:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005608:	f40b8ce3          	beqz	s7,80005560 <exec+0x338>
    8000560c:	89de                	mv	s3,s7
    8000560e:	4481                	li	s1,0
    80005610:	bb99                	j	80005366 <exec+0x13e>

0000000080005612 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    80005612:	7179                	addi	sp,sp,-48
    80005614:	f406                	sd	ra,40(sp)
    80005616:	f022                	sd	s0,32(sp)
    80005618:	ec26                	sd	s1,24(sp)
    8000561a:	e84a                	sd	s2,16(sp)
    8000561c:	1800                	addi	s0,sp,48
    8000561e:	892e                	mv	s2,a1
    80005620:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    80005622:	fdc40593          	addi	a1,s0,-36
    80005626:	ffffe097          	auipc	ra,0xffffe
    8000562a:	a92080e7          	jalr	-1390(ra) # 800030b8 <argint>
    8000562e:	04054063          	bltz	a0,8000566e <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80005632:	fdc42703          	lw	a4,-36(s0)
    80005636:	47bd                	li	a5,15
    80005638:	02e7ed63          	bltu	a5,a4,80005672 <argfd+0x60>
    8000563c:	ffffc097          	auipc	ra,0xffffc
    80005640:	658080e7          	jalr	1624(ra) # 80001c94 <myproc>
    80005644:	fdc42703          	lw	a4,-36(s0)
    80005648:	01c70793          	addi	a5,a4,28
    8000564c:	078e                	slli	a5,a5,0x3
    8000564e:	953e                	add	a0,a0,a5
    80005650:	611c                	ld	a5,0(a0)
    80005652:	c395                	beqz	a5,80005676 <argfd+0x64>
    return -1;
  if (pfd)
    80005654:	00090463          	beqz	s2,8000565c <argfd+0x4a>
    *pfd = fd;
    80005658:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    8000565c:	4501                	li	a0,0
  if (pf)
    8000565e:	c091                	beqz	s1,80005662 <argfd+0x50>
    *pf = f;
    80005660:	e09c                	sd	a5,0(s1)
}
    80005662:	70a2                	ld	ra,40(sp)
    80005664:	7402                	ld	s0,32(sp)
    80005666:	64e2                	ld	s1,24(sp)
    80005668:	6942                	ld	s2,16(sp)
    8000566a:	6145                	addi	sp,sp,48
    8000566c:	8082                	ret
    return -1;
    8000566e:	557d                	li	a0,-1
    80005670:	bfcd                	j	80005662 <argfd+0x50>
    return -1;
    80005672:	557d                	li	a0,-1
    80005674:	b7fd                	j	80005662 <argfd+0x50>
    80005676:	557d                	li	a0,-1
    80005678:	b7ed                	j	80005662 <argfd+0x50>

000000008000567a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    8000567a:	1101                	addi	sp,sp,-32
    8000567c:	ec06                	sd	ra,24(sp)
    8000567e:	e822                	sd	s0,16(sp)
    80005680:	e426                	sd	s1,8(sp)
    80005682:	1000                	addi	s0,sp,32
    80005684:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005686:	ffffc097          	auipc	ra,0xffffc
    8000568a:	60e080e7          	jalr	1550(ra) # 80001c94 <myproc>
    8000568e:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80005690:	0e050793          	addi	a5,a0,224
    80005694:	4501                	li	a0,0
    80005696:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80005698:	6398                	ld	a4,0(a5)
    8000569a:	cb19                	beqz	a4,800056b0 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    8000569c:	2505                	addiw	a0,a0,1
    8000569e:	07a1                	addi	a5,a5,8
    800056a0:	fed51ce3          	bne	a0,a3,80005698 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056a4:	557d                	li	a0,-1
}
    800056a6:	60e2                	ld	ra,24(sp)
    800056a8:	6442                	ld	s0,16(sp)
    800056aa:	64a2                	ld	s1,8(sp)
    800056ac:	6105                	addi	sp,sp,32
    800056ae:	8082                	ret
      p->ofile[fd] = f;
    800056b0:	01c50793          	addi	a5,a0,28
    800056b4:	078e                	slli	a5,a5,0x3
    800056b6:	963e                	add	a2,a2,a5
    800056b8:	e204                	sd	s1,0(a2)
      return fd;
    800056ba:	b7f5                	j	800056a6 <fdalloc+0x2c>

00000000800056bc <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    800056bc:	715d                	addi	sp,sp,-80
    800056be:	e486                	sd	ra,72(sp)
    800056c0:	e0a2                	sd	s0,64(sp)
    800056c2:	fc26                	sd	s1,56(sp)
    800056c4:	f84a                	sd	s2,48(sp)
    800056c6:	f44e                	sd	s3,40(sp)
    800056c8:	f052                	sd	s4,32(sp)
    800056ca:	ec56                	sd	s5,24(sp)
    800056cc:	0880                	addi	s0,sp,80
    800056ce:	89ae                	mv	s3,a1
    800056d0:	8ab2                	mv	s5,a2
    800056d2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800056d4:	fb040593          	addi	a1,s0,-80
    800056d8:	fffff097          	auipc	ra,0xfffff
    800056dc:	e34080e7          	jalr	-460(ra) # 8000450c <nameiparent>
    800056e0:	892a                	mv	s2,a0
    800056e2:	12050e63          	beqz	a0,8000581e <create+0x162>
    return 0;

  ilock(dp);
    800056e6:	ffffe097          	auipc	ra,0xffffe
    800056ea:	652080e7          	jalr	1618(ra) # 80003d38 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800056ee:	4601                	li	a2,0
    800056f0:	fb040593          	addi	a1,s0,-80
    800056f4:	854a                	mv	a0,s2
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	b26080e7          	jalr	-1242(ra) # 8000421c <dirlookup>
    800056fe:	84aa                	mv	s1,a0
    80005700:	c921                	beqz	a0,80005750 <create+0x94>
    iunlockput(dp);
    80005702:	854a                	mv	a0,s2
    80005704:	fffff097          	auipc	ra,0xfffff
    80005708:	896080e7          	jalr	-1898(ra) # 80003f9a <iunlockput>
    ilock(ip);
    8000570c:	8526                	mv	a0,s1
    8000570e:	ffffe097          	auipc	ra,0xffffe
    80005712:	62a080e7          	jalr	1578(ra) # 80003d38 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005716:	2981                	sext.w	s3,s3
    80005718:	4789                	li	a5,2
    8000571a:	02f99463          	bne	s3,a5,80005742 <create+0x86>
    8000571e:	0444d783          	lhu	a5,68(s1)
    80005722:	37f9                	addiw	a5,a5,-2
    80005724:	17c2                	slli	a5,a5,0x30
    80005726:	93c1                	srli	a5,a5,0x30
    80005728:	4705                	li	a4,1
    8000572a:	00f76c63          	bltu	a4,a5,80005742 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000572e:	8526                	mv	a0,s1
    80005730:	60a6                	ld	ra,72(sp)
    80005732:	6406                	ld	s0,64(sp)
    80005734:	74e2                	ld	s1,56(sp)
    80005736:	7942                	ld	s2,48(sp)
    80005738:	79a2                	ld	s3,40(sp)
    8000573a:	7a02                	ld	s4,32(sp)
    8000573c:	6ae2                	ld	s5,24(sp)
    8000573e:	6161                	addi	sp,sp,80
    80005740:	8082                	ret
    iunlockput(ip);
    80005742:	8526                	mv	a0,s1
    80005744:	fffff097          	auipc	ra,0xfffff
    80005748:	856080e7          	jalr	-1962(ra) # 80003f9a <iunlockput>
    return 0;
    8000574c:	4481                	li	s1,0
    8000574e:	b7c5                	j	8000572e <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80005750:	85ce                	mv	a1,s3
    80005752:	00092503          	lw	a0,0(s2)
    80005756:	ffffe097          	auipc	ra,0xffffe
    8000575a:	44a080e7          	jalr	1098(ra) # 80003ba0 <ialloc>
    8000575e:	84aa                	mv	s1,a0
    80005760:	c521                	beqz	a0,800057a8 <create+0xec>
  ilock(ip);
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	5d6080e7          	jalr	1494(ra) # 80003d38 <ilock>
  ip->major = major;
    8000576a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000576e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005772:	4a05                	li	s4,1
    80005774:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005778:	8526                	mv	a0,s1
    8000577a:	ffffe097          	auipc	ra,0xffffe
    8000577e:	4f4080e7          	jalr	1268(ra) # 80003c6e <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80005782:	2981                	sext.w	s3,s3
    80005784:	03498a63          	beq	s3,s4,800057b8 <create+0xfc>
  if (dirlink(dp, name, ip->inum) < 0)
    80005788:	40d0                	lw	a2,4(s1)
    8000578a:	fb040593          	addi	a1,s0,-80
    8000578e:	854a                	mv	a0,s2
    80005790:	fffff097          	auipc	ra,0xfffff
    80005794:	c9c080e7          	jalr	-868(ra) # 8000442c <dirlink>
    80005798:	06054b63          	bltz	a0,8000580e <create+0x152>
  iunlockput(dp);
    8000579c:	854a                	mv	a0,s2
    8000579e:	ffffe097          	auipc	ra,0xffffe
    800057a2:	7fc080e7          	jalr	2044(ra) # 80003f9a <iunlockput>
  return ip;
    800057a6:	b761                	j	8000572e <create+0x72>
    panic("create: ialloc");
    800057a8:	00003517          	auipc	a0,0x3
    800057ac:	01050513          	addi	a0,a0,16 # 800087b8 <syscalls+0x2b8>
    800057b0:	ffffb097          	auipc	ra,0xffffb
    800057b4:	e1c080e7          	jalr	-484(ra) # 800005cc <panic>
    dp->nlink++;       // for ".."
    800057b8:	04a95783          	lhu	a5,74(s2)
    800057bc:	2785                	addiw	a5,a5,1
    800057be:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800057c2:	854a                	mv	a0,s2
    800057c4:	ffffe097          	auipc	ra,0xffffe
    800057c8:	4aa080e7          	jalr	1194(ra) # 80003c6e <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057cc:	40d0                	lw	a2,4(s1)
    800057ce:	00003597          	auipc	a1,0x3
    800057d2:	ffa58593          	addi	a1,a1,-6 # 800087c8 <syscalls+0x2c8>
    800057d6:	8526                	mv	a0,s1
    800057d8:	fffff097          	auipc	ra,0xfffff
    800057dc:	c54080e7          	jalr	-940(ra) # 8000442c <dirlink>
    800057e0:	00054f63          	bltz	a0,800057fe <create+0x142>
    800057e4:	00492603          	lw	a2,4(s2)
    800057e8:	00003597          	auipc	a1,0x3
    800057ec:	9d058593          	addi	a1,a1,-1584 # 800081b8 <digits+0x150>
    800057f0:	8526                	mv	a0,s1
    800057f2:	fffff097          	auipc	ra,0xfffff
    800057f6:	c3a080e7          	jalr	-966(ra) # 8000442c <dirlink>
    800057fa:	f80557e3          	bgez	a0,80005788 <create+0xcc>
      panic("create dots");
    800057fe:	00003517          	auipc	a0,0x3
    80005802:	fd250513          	addi	a0,a0,-46 # 800087d0 <syscalls+0x2d0>
    80005806:	ffffb097          	auipc	ra,0xffffb
    8000580a:	dc6080e7          	jalr	-570(ra) # 800005cc <panic>
    panic("create: dirlink");
    8000580e:	00003517          	auipc	a0,0x3
    80005812:	fd250513          	addi	a0,a0,-46 # 800087e0 <syscalls+0x2e0>
    80005816:	ffffb097          	auipc	ra,0xffffb
    8000581a:	db6080e7          	jalr	-586(ra) # 800005cc <panic>
    return 0;
    8000581e:	84aa                	mv	s1,a0
    80005820:	b739                	j	8000572e <create+0x72>

0000000080005822 <sys_dup>:
uint64 sys_dup(void) {
    80005822:	7179                	addi	sp,sp,-48
    80005824:	f406                	sd	ra,40(sp)
    80005826:	f022                	sd	s0,32(sp)
    80005828:	ec26                	sd	s1,24(sp)
    8000582a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000582c:	fd840613          	addi	a2,s0,-40
    80005830:	4581                	li	a1,0
    80005832:	4501                	li	a0,0
    80005834:	00000097          	auipc	ra,0x0
    80005838:	dde080e7          	jalr	-546(ra) # 80005612 <argfd>
    return -1;
    8000583c:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    8000583e:	02054363          	bltz	a0,80005864 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80005842:	fd843503          	ld	a0,-40(s0)
    80005846:	00000097          	auipc	ra,0x0
    8000584a:	e34080e7          	jalr	-460(ra) # 8000567a <fdalloc>
    8000584e:	84aa                	mv	s1,a0
    return -1;
    80005850:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80005852:	00054963          	bltz	a0,80005864 <sys_dup+0x42>
  filedup(f);
    80005856:	fd843503          	ld	a0,-40(s0)
    8000585a:	fffff097          	auipc	ra,0xfffff
    8000585e:	32a080e7          	jalr	810(ra) # 80004b84 <filedup>
  return fd;
    80005862:	87a6                	mv	a5,s1
}
    80005864:	853e                	mv	a0,a5
    80005866:	70a2                	ld	ra,40(sp)
    80005868:	7402                	ld	s0,32(sp)
    8000586a:	64e2                	ld	s1,24(sp)
    8000586c:	6145                	addi	sp,sp,48
    8000586e:	8082                	ret

0000000080005870 <sys_read>:
uint64 sys_read(void) {
    80005870:	7179                	addi	sp,sp,-48
    80005872:	f406                	sd	ra,40(sp)
    80005874:	f022                	sd	s0,32(sp)
    80005876:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005878:	fe840613          	addi	a2,s0,-24
    8000587c:	4581                	li	a1,0
    8000587e:	4501                	li	a0,0
    80005880:	00000097          	auipc	ra,0x0
    80005884:	d92080e7          	jalr	-622(ra) # 80005612 <argfd>
    return -1;
    80005888:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000588a:	04054163          	bltz	a0,800058cc <sys_read+0x5c>
    8000588e:	fe440593          	addi	a1,s0,-28
    80005892:	4509                	li	a0,2
    80005894:	ffffe097          	auipc	ra,0xffffe
    80005898:	824080e7          	jalr	-2012(ra) # 800030b8 <argint>
    return -1;
    8000589c:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000589e:	02054763          	bltz	a0,800058cc <sys_read+0x5c>
    800058a2:	fd840593          	addi	a1,s0,-40
    800058a6:	4505                	li	a0,1
    800058a8:	ffffe097          	auipc	ra,0xffffe
    800058ac:	832080e7          	jalr	-1998(ra) # 800030da <argaddr>
    return -1;
    800058b0:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058b2:	00054d63          	bltz	a0,800058cc <sys_read+0x5c>
  return fileread(f, p, n);
    800058b6:	fe442603          	lw	a2,-28(s0)
    800058ba:	fd843583          	ld	a1,-40(s0)
    800058be:	fe843503          	ld	a0,-24(s0)
    800058c2:	fffff097          	auipc	ra,0xfffff
    800058c6:	44e080e7          	jalr	1102(ra) # 80004d10 <fileread>
    800058ca:	87aa                	mv	a5,a0
}
    800058cc:	853e                	mv	a0,a5
    800058ce:	70a2                	ld	ra,40(sp)
    800058d0:	7402                	ld	s0,32(sp)
    800058d2:	6145                	addi	sp,sp,48
    800058d4:	8082                	ret

00000000800058d6 <sys_write>:
uint64 sys_write(void) {
    800058d6:	7179                	addi	sp,sp,-48
    800058d8:	f406                	sd	ra,40(sp)
    800058da:	f022                	sd	s0,32(sp)
    800058dc:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058de:	fe840613          	addi	a2,s0,-24
    800058e2:	4581                	li	a1,0
    800058e4:	4501                	li	a0,0
    800058e6:	00000097          	auipc	ra,0x0
    800058ea:	d2c080e7          	jalr	-724(ra) # 80005612 <argfd>
    return -1;
    800058ee:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058f0:	04054163          	bltz	a0,80005932 <sys_write+0x5c>
    800058f4:	fe440593          	addi	a1,s0,-28
    800058f8:	4509                	li	a0,2
    800058fa:	ffffd097          	auipc	ra,0xffffd
    800058fe:	7be080e7          	jalr	1982(ra) # 800030b8 <argint>
    return -1;
    80005902:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005904:	02054763          	bltz	a0,80005932 <sys_write+0x5c>
    80005908:	fd840593          	addi	a1,s0,-40
    8000590c:	4505                	li	a0,1
    8000590e:	ffffd097          	auipc	ra,0xffffd
    80005912:	7cc080e7          	jalr	1996(ra) # 800030da <argaddr>
    return -1;
    80005916:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005918:	00054d63          	bltz	a0,80005932 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000591c:	fe442603          	lw	a2,-28(s0)
    80005920:	fd843583          	ld	a1,-40(s0)
    80005924:	fe843503          	ld	a0,-24(s0)
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	4aa080e7          	jalr	1194(ra) # 80004dd2 <filewrite>
    80005930:	87aa                	mv	a5,a0
}
    80005932:	853e                	mv	a0,a5
    80005934:	70a2                	ld	ra,40(sp)
    80005936:	7402                	ld	s0,32(sp)
    80005938:	6145                	addi	sp,sp,48
    8000593a:	8082                	ret

000000008000593c <sys_close>:
uint64 sys_close(void) {
    8000593c:	1101                	addi	sp,sp,-32
    8000593e:	ec06                	sd	ra,24(sp)
    80005940:	e822                	sd	s0,16(sp)
    80005942:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80005944:	fe040613          	addi	a2,s0,-32
    80005948:	fec40593          	addi	a1,s0,-20
    8000594c:	4501                	li	a0,0
    8000594e:	00000097          	auipc	ra,0x0
    80005952:	cc4080e7          	jalr	-828(ra) # 80005612 <argfd>
    return -1;
    80005956:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80005958:	02054463          	bltz	a0,80005980 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	338080e7          	jalr	824(ra) # 80001c94 <myproc>
    80005964:	fec42783          	lw	a5,-20(s0)
    80005968:	07f1                	addi	a5,a5,28
    8000596a:	078e                	slli	a5,a5,0x3
    8000596c:	97aa                	add	a5,a5,a0
    8000596e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005972:	fe043503          	ld	a0,-32(s0)
    80005976:	fffff097          	auipc	ra,0xfffff
    8000597a:	260080e7          	jalr	608(ra) # 80004bd6 <fileclose>
  return 0;
    8000597e:	4781                	li	a5,0
}
    80005980:	853e                	mv	a0,a5
    80005982:	60e2                	ld	ra,24(sp)
    80005984:	6442                	ld	s0,16(sp)
    80005986:	6105                	addi	sp,sp,32
    80005988:	8082                	ret

000000008000598a <sys_fstat>:
uint64 sys_fstat(void) {
    8000598a:	1101                	addi	sp,sp,-32
    8000598c:	ec06                	sd	ra,24(sp)
    8000598e:	e822                	sd	s0,16(sp)
    80005990:	1000                	addi	s0,sp,32
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005992:	fe840613          	addi	a2,s0,-24
    80005996:	4581                	li	a1,0
    80005998:	4501                	li	a0,0
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	c78080e7          	jalr	-904(ra) # 80005612 <argfd>
    return -1;
    800059a2:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800059a4:	02054563          	bltz	a0,800059ce <sys_fstat+0x44>
    800059a8:	fe040593          	addi	a1,s0,-32
    800059ac:	4505                	li	a0,1
    800059ae:	ffffd097          	auipc	ra,0xffffd
    800059b2:	72c080e7          	jalr	1836(ra) # 800030da <argaddr>
    return -1;
    800059b6:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800059b8:	00054b63          	bltz	a0,800059ce <sys_fstat+0x44>
  return filestat(f, st);
    800059bc:	fe043583          	ld	a1,-32(s0)
    800059c0:	fe843503          	ld	a0,-24(s0)
    800059c4:	fffff097          	auipc	ra,0xfffff
    800059c8:	2da080e7          	jalr	730(ra) # 80004c9e <filestat>
    800059cc:	87aa                	mv	a5,a0
}
    800059ce:	853e                	mv	a0,a5
    800059d0:	60e2                	ld	ra,24(sp)
    800059d2:	6442                	ld	s0,16(sp)
    800059d4:	6105                	addi	sp,sp,32
    800059d6:	8082                	ret

00000000800059d8 <sys_link>:
uint64 sys_link(void) {
    800059d8:	7169                	addi	sp,sp,-304
    800059da:	f606                	sd	ra,296(sp)
    800059dc:	f222                	sd	s0,288(sp)
    800059de:	ee26                	sd	s1,280(sp)
    800059e0:	ea4a                	sd	s2,272(sp)
    800059e2:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059e4:	08000613          	li	a2,128
    800059e8:	ed040593          	addi	a1,s0,-304
    800059ec:	4501                	li	a0,0
    800059ee:	ffffd097          	auipc	ra,0xffffd
    800059f2:	70e080e7          	jalr	1806(ra) # 800030fc <argstr>
    return -1;
    800059f6:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059f8:	10054e63          	bltz	a0,80005b14 <sys_link+0x13c>
    800059fc:	08000613          	li	a2,128
    80005a00:	f5040593          	addi	a1,s0,-176
    80005a04:	4505                	li	a0,1
    80005a06:	ffffd097          	auipc	ra,0xffffd
    80005a0a:	6f6080e7          	jalr	1782(ra) # 800030fc <argstr>
    return -1;
    80005a0e:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a10:	10054263          	bltz	a0,80005b14 <sys_link+0x13c>
  begin_op();
    80005a14:	fffff097          	auipc	ra,0xfffff
    80005a18:	cf6080e7          	jalr	-778(ra) # 8000470a <begin_op>
  if ((ip = namei(old)) == 0) {
    80005a1c:	ed040513          	addi	a0,s0,-304
    80005a20:	fffff097          	auipc	ra,0xfffff
    80005a24:	ace080e7          	jalr	-1330(ra) # 800044ee <namei>
    80005a28:	84aa                	mv	s1,a0
    80005a2a:	c551                	beqz	a0,80005ab6 <sys_link+0xde>
  ilock(ip);
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	30c080e7          	jalr	780(ra) # 80003d38 <ilock>
  if (ip->type == T_DIR) {
    80005a34:	04449703          	lh	a4,68(s1)
    80005a38:	4785                	li	a5,1
    80005a3a:	08f70463          	beq	a4,a5,80005ac2 <sys_link+0xea>
  ip->nlink++;
    80005a3e:	04a4d783          	lhu	a5,74(s1)
    80005a42:	2785                	addiw	a5,a5,1
    80005a44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a48:	8526                	mv	a0,s1
    80005a4a:	ffffe097          	auipc	ra,0xffffe
    80005a4e:	224080e7          	jalr	548(ra) # 80003c6e <iupdate>
  iunlock(ip);
    80005a52:	8526                	mv	a0,s1
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	3a6080e7          	jalr	934(ra) # 80003dfa <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80005a5c:	fd040593          	addi	a1,s0,-48
    80005a60:	f5040513          	addi	a0,s0,-176
    80005a64:	fffff097          	auipc	ra,0xfffff
    80005a68:	aa8080e7          	jalr	-1368(ra) # 8000450c <nameiparent>
    80005a6c:	892a                	mv	s2,a0
    80005a6e:	c935                	beqz	a0,80005ae2 <sys_link+0x10a>
  ilock(dp);
    80005a70:	ffffe097          	auipc	ra,0xffffe
    80005a74:	2c8080e7          	jalr	712(ra) # 80003d38 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80005a78:	00092703          	lw	a4,0(s2)
    80005a7c:	409c                	lw	a5,0(s1)
    80005a7e:	04f71d63          	bne	a4,a5,80005ad8 <sys_link+0x100>
    80005a82:	40d0                	lw	a2,4(s1)
    80005a84:	fd040593          	addi	a1,s0,-48
    80005a88:	854a                	mv	a0,s2
    80005a8a:	fffff097          	auipc	ra,0xfffff
    80005a8e:	9a2080e7          	jalr	-1630(ra) # 8000442c <dirlink>
    80005a92:	04054363          	bltz	a0,80005ad8 <sys_link+0x100>
  iunlockput(dp);
    80005a96:	854a                	mv	a0,s2
    80005a98:	ffffe097          	auipc	ra,0xffffe
    80005a9c:	502080e7          	jalr	1282(ra) # 80003f9a <iunlockput>
  iput(ip);
    80005aa0:	8526                	mv	a0,s1
    80005aa2:	ffffe097          	auipc	ra,0xffffe
    80005aa6:	450080e7          	jalr	1104(ra) # 80003ef2 <iput>
  end_op();
    80005aaa:	fffff097          	auipc	ra,0xfffff
    80005aae:	ce0080e7          	jalr	-800(ra) # 8000478a <end_op>
  return 0;
    80005ab2:	4781                	li	a5,0
    80005ab4:	a085                	j	80005b14 <sys_link+0x13c>
    end_op();
    80005ab6:	fffff097          	auipc	ra,0xfffff
    80005aba:	cd4080e7          	jalr	-812(ra) # 8000478a <end_op>
    return -1;
    80005abe:	57fd                	li	a5,-1
    80005ac0:	a891                	j	80005b14 <sys_link+0x13c>
    iunlockput(ip);
    80005ac2:	8526                	mv	a0,s1
    80005ac4:	ffffe097          	auipc	ra,0xffffe
    80005ac8:	4d6080e7          	jalr	1238(ra) # 80003f9a <iunlockput>
    end_op();
    80005acc:	fffff097          	auipc	ra,0xfffff
    80005ad0:	cbe080e7          	jalr	-834(ra) # 8000478a <end_op>
    return -1;
    80005ad4:	57fd                	li	a5,-1
    80005ad6:	a83d                	j	80005b14 <sys_link+0x13c>
    iunlockput(dp);
    80005ad8:	854a                	mv	a0,s2
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	4c0080e7          	jalr	1216(ra) # 80003f9a <iunlockput>
  ilock(ip);
    80005ae2:	8526                	mv	a0,s1
    80005ae4:	ffffe097          	auipc	ra,0xffffe
    80005ae8:	254080e7          	jalr	596(ra) # 80003d38 <ilock>
  ip->nlink--;
    80005aec:	04a4d783          	lhu	a5,74(s1)
    80005af0:	37fd                	addiw	a5,a5,-1
    80005af2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005af6:	8526                	mv	a0,s1
    80005af8:	ffffe097          	auipc	ra,0xffffe
    80005afc:	176080e7          	jalr	374(ra) # 80003c6e <iupdate>
  iunlockput(ip);
    80005b00:	8526                	mv	a0,s1
    80005b02:	ffffe097          	auipc	ra,0xffffe
    80005b06:	498080e7          	jalr	1176(ra) # 80003f9a <iunlockput>
  end_op();
    80005b0a:	fffff097          	auipc	ra,0xfffff
    80005b0e:	c80080e7          	jalr	-896(ra) # 8000478a <end_op>
  return -1;
    80005b12:	57fd                	li	a5,-1
}
    80005b14:	853e                	mv	a0,a5
    80005b16:	70b2                	ld	ra,296(sp)
    80005b18:	7412                	ld	s0,288(sp)
    80005b1a:	64f2                	ld	s1,280(sp)
    80005b1c:	6952                	ld	s2,272(sp)
    80005b1e:	6155                	addi	sp,sp,304
    80005b20:	8082                	ret

0000000080005b22 <sys_unlink>:
uint64 sys_unlink(void) {
    80005b22:	7151                	addi	sp,sp,-240
    80005b24:	f586                	sd	ra,232(sp)
    80005b26:	f1a2                	sd	s0,224(sp)
    80005b28:	eda6                	sd	s1,216(sp)
    80005b2a:	e9ca                	sd	s2,208(sp)
    80005b2c:	e5ce                	sd	s3,200(sp)
    80005b2e:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80005b30:	08000613          	li	a2,128
    80005b34:	f3040593          	addi	a1,s0,-208
    80005b38:	4501                	li	a0,0
    80005b3a:	ffffd097          	auipc	ra,0xffffd
    80005b3e:	5c2080e7          	jalr	1474(ra) # 800030fc <argstr>
    80005b42:	18054163          	bltz	a0,80005cc4 <sys_unlink+0x1a2>
  begin_op();
    80005b46:	fffff097          	auipc	ra,0xfffff
    80005b4a:	bc4080e7          	jalr	-1084(ra) # 8000470a <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80005b4e:	fb040593          	addi	a1,s0,-80
    80005b52:	f3040513          	addi	a0,s0,-208
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	9b6080e7          	jalr	-1610(ra) # 8000450c <nameiparent>
    80005b5e:	84aa                	mv	s1,a0
    80005b60:	c979                	beqz	a0,80005c36 <sys_unlink+0x114>
  ilock(dp);
    80005b62:	ffffe097          	auipc	ra,0xffffe
    80005b66:	1d6080e7          	jalr	470(ra) # 80003d38 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b6a:	00003597          	auipc	a1,0x3
    80005b6e:	c5e58593          	addi	a1,a1,-930 # 800087c8 <syscalls+0x2c8>
    80005b72:	fb040513          	addi	a0,s0,-80
    80005b76:	ffffe097          	auipc	ra,0xffffe
    80005b7a:	68c080e7          	jalr	1676(ra) # 80004202 <namecmp>
    80005b7e:	14050a63          	beqz	a0,80005cd2 <sys_unlink+0x1b0>
    80005b82:	00002597          	auipc	a1,0x2
    80005b86:	63658593          	addi	a1,a1,1590 # 800081b8 <digits+0x150>
    80005b8a:	fb040513          	addi	a0,s0,-80
    80005b8e:	ffffe097          	auipc	ra,0xffffe
    80005b92:	674080e7          	jalr	1652(ra) # 80004202 <namecmp>
    80005b96:	12050e63          	beqz	a0,80005cd2 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005b9a:	f2c40613          	addi	a2,s0,-212
    80005b9e:	fb040593          	addi	a1,s0,-80
    80005ba2:	8526                	mv	a0,s1
    80005ba4:	ffffe097          	auipc	ra,0xffffe
    80005ba8:	678080e7          	jalr	1656(ra) # 8000421c <dirlookup>
    80005bac:	892a                	mv	s2,a0
    80005bae:	12050263          	beqz	a0,80005cd2 <sys_unlink+0x1b0>
  ilock(ip);
    80005bb2:	ffffe097          	auipc	ra,0xffffe
    80005bb6:	186080e7          	jalr	390(ra) # 80003d38 <ilock>
  if (ip->nlink < 1)
    80005bba:	04a91783          	lh	a5,74(s2)
    80005bbe:	08f05263          	blez	a5,80005c42 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005bc2:	04491703          	lh	a4,68(s2)
    80005bc6:	4785                	li	a5,1
    80005bc8:	08f70563          	beq	a4,a5,80005c52 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005bcc:	4641                	li	a2,16
    80005bce:	4581                	li	a1,0
    80005bd0:	fc040513          	addi	a0,s0,-64
    80005bd4:	ffffb097          	auipc	ra,0xffffb
    80005bd8:	162080e7          	jalr	354(ra) # 80000d36 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bdc:	4741                	li	a4,16
    80005bde:	f2c42683          	lw	a3,-212(s0)
    80005be2:	fc040613          	addi	a2,s0,-64
    80005be6:	4581                	li	a1,0
    80005be8:	8526                	mv	a0,s1
    80005bea:	ffffe097          	auipc	ra,0xffffe
    80005bee:	4fa080e7          	jalr	1274(ra) # 800040e4 <writei>
    80005bf2:	47c1                	li	a5,16
    80005bf4:	0af51563          	bne	a0,a5,80005c9e <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80005bf8:	04491703          	lh	a4,68(s2)
    80005bfc:	4785                	li	a5,1
    80005bfe:	0af70863          	beq	a4,a5,80005cae <sys_unlink+0x18c>
  iunlockput(dp);
    80005c02:	8526                	mv	a0,s1
    80005c04:	ffffe097          	auipc	ra,0xffffe
    80005c08:	396080e7          	jalr	918(ra) # 80003f9a <iunlockput>
  ip->nlink--;
    80005c0c:	04a95783          	lhu	a5,74(s2)
    80005c10:	37fd                	addiw	a5,a5,-1
    80005c12:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c16:	854a                	mv	a0,s2
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	056080e7          	jalr	86(ra) # 80003c6e <iupdate>
  iunlockput(ip);
    80005c20:	854a                	mv	a0,s2
    80005c22:	ffffe097          	auipc	ra,0xffffe
    80005c26:	378080e7          	jalr	888(ra) # 80003f9a <iunlockput>
  end_op();
    80005c2a:	fffff097          	auipc	ra,0xfffff
    80005c2e:	b60080e7          	jalr	-1184(ra) # 8000478a <end_op>
  return 0;
    80005c32:	4501                	li	a0,0
    80005c34:	a84d                	j	80005ce6 <sys_unlink+0x1c4>
    end_op();
    80005c36:	fffff097          	auipc	ra,0xfffff
    80005c3a:	b54080e7          	jalr	-1196(ra) # 8000478a <end_op>
    return -1;
    80005c3e:	557d                	li	a0,-1
    80005c40:	a05d                	j	80005ce6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005c42:	00003517          	auipc	a0,0x3
    80005c46:	bae50513          	addi	a0,a0,-1106 # 800087f0 <syscalls+0x2f0>
    80005c4a:	ffffb097          	auipc	ra,0xffffb
    80005c4e:	982080e7          	jalr	-1662(ra) # 800005cc <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005c52:	04c92703          	lw	a4,76(s2)
    80005c56:	02000793          	li	a5,32
    80005c5a:	f6e7f9e3          	bgeu	a5,a4,80005bcc <sys_unlink+0xaa>
    80005c5e:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c62:	4741                	li	a4,16
    80005c64:	86ce                	mv	a3,s3
    80005c66:	f1840613          	addi	a2,s0,-232
    80005c6a:	4581                	li	a1,0
    80005c6c:	854a                	mv	a0,s2
    80005c6e:	ffffe097          	auipc	ra,0xffffe
    80005c72:	37e080e7          	jalr	894(ra) # 80003fec <readi>
    80005c76:	47c1                	li	a5,16
    80005c78:	00f51b63          	bne	a0,a5,80005c8e <sys_unlink+0x16c>
    if (de.inum != 0)
    80005c7c:	f1845783          	lhu	a5,-232(s0)
    80005c80:	e7a1                	bnez	a5,80005cc8 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005c82:	29c1                	addiw	s3,s3,16
    80005c84:	04c92783          	lw	a5,76(s2)
    80005c88:	fcf9ede3          	bltu	s3,a5,80005c62 <sys_unlink+0x140>
    80005c8c:	b781                	j	80005bcc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005c8e:	00003517          	auipc	a0,0x3
    80005c92:	b7a50513          	addi	a0,a0,-1158 # 80008808 <syscalls+0x308>
    80005c96:	ffffb097          	auipc	ra,0xffffb
    80005c9a:	936080e7          	jalr	-1738(ra) # 800005cc <panic>
    panic("unlink: writei");
    80005c9e:	00003517          	auipc	a0,0x3
    80005ca2:	b8250513          	addi	a0,a0,-1150 # 80008820 <syscalls+0x320>
    80005ca6:	ffffb097          	auipc	ra,0xffffb
    80005caa:	926080e7          	jalr	-1754(ra) # 800005cc <panic>
    dp->nlink--;
    80005cae:	04a4d783          	lhu	a5,74(s1)
    80005cb2:	37fd                	addiw	a5,a5,-1
    80005cb4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005cb8:	8526                	mv	a0,s1
    80005cba:	ffffe097          	auipc	ra,0xffffe
    80005cbe:	fb4080e7          	jalr	-76(ra) # 80003c6e <iupdate>
    80005cc2:	b781                	j	80005c02 <sys_unlink+0xe0>
    return -1;
    80005cc4:	557d                	li	a0,-1
    80005cc6:	a005                	j	80005ce6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005cc8:	854a                	mv	a0,s2
    80005cca:	ffffe097          	auipc	ra,0xffffe
    80005cce:	2d0080e7          	jalr	720(ra) # 80003f9a <iunlockput>
  iunlockput(dp);
    80005cd2:	8526                	mv	a0,s1
    80005cd4:	ffffe097          	auipc	ra,0xffffe
    80005cd8:	2c6080e7          	jalr	710(ra) # 80003f9a <iunlockput>
  end_op();
    80005cdc:	fffff097          	auipc	ra,0xfffff
    80005ce0:	aae080e7          	jalr	-1362(ra) # 8000478a <end_op>
  return -1;
    80005ce4:	557d                	li	a0,-1
}
    80005ce6:	70ae                	ld	ra,232(sp)
    80005ce8:	740e                	ld	s0,224(sp)
    80005cea:	64ee                	ld	s1,216(sp)
    80005cec:	694e                	ld	s2,208(sp)
    80005cee:	69ae                	ld	s3,200(sp)
    80005cf0:	616d                	addi	sp,sp,240
    80005cf2:	8082                	ret

0000000080005cf4 <sys_open>:

uint64 sys_open(void) {
    80005cf4:	7131                	addi	sp,sp,-192
    80005cf6:	fd06                	sd	ra,184(sp)
    80005cf8:	f922                	sd	s0,176(sp)
    80005cfa:	f526                	sd	s1,168(sp)
    80005cfc:	f14a                	sd	s2,160(sp)
    80005cfe:	ed4e                	sd	s3,152(sp)
    80005d00:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005d02:	08000613          	li	a2,128
    80005d06:	f5040593          	addi	a1,s0,-176
    80005d0a:	4501                	li	a0,0
    80005d0c:	ffffd097          	auipc	ra,0xffffd
    80005d10:	3f0080e7          	jalr	1008(ra) # 800030fc <argstr>
    return -1;
    80005d14:	54fd                	li	s1,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005d16:	0c054163          	bltz	a0,80005dd8 <sys_open+0xe4>
    80005d1a:	f4c40593          	addi	a1,s0,-180
    80005d1e:	4505                	li	a0,1
    80005d20:	ffffd097          	auipc	ra,0xffffd
    80005d24:	398080e7          	jalr	920(ra) # 800030b8 <argint>
    80005d28:	0a054863          	bltz	a0,80005dd8 <sys_open+0xe4>

  begin_op();
    80005d2c:	fffff097          	auipc	ra,0xfffff
    80005d30:	9de080e7          	jalr	-1570(ra) # 8000470a <begin_op>

  if (omode & O_CREATE) {
    80005d34:	f4c42783          	lw	a5,-180(s0)
    80005d38:	2007f793          	andi	a5,a5,512
    80005d3c:	cbdd                	beqz	a5,80005df2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d3e:	4681                	li	a3,0
    80005d40:	4601                	li	a2,0
    80005d42:	4589                	li	a1,2
    80005d44:	f5040513          	addi	a0,s0,-176
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	974080e7          	jalr	-1676(ra) # 800056bc <create>
    80005d50:	892a                	mv	s2,a0
    if (ip == 0) {
    80005d52:	c959                	beqz	a0,80005de8 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005d54:	04491703          	lh	a4,68(s2)
    80005d58:	478d                	li	a5,3
    80005d5a:	00f71763          	bne	a4,a5,80005d68 <sys_open+0x74>
    80005d5e:	04695703          	lhu	a4,70(s2)
    80005d62:	47a5                	li	a5,9
    80005d64:	0ce7ec63          	bltu	a5,a4,80005e3c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005d68:	fffff097          	auipc	ra,0xfffff
    80005d6c:	db2080e7          	jalr	-590(ra) # 80004b1a <filealloc>
    80005d70:	89aa                	mv	s3,a0
    80005d72:	10050263          	beqz	a0,80005e76 <sys_open+0x182>
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	904080e7          	jalr	-1788(ra) # 8000567a <fdalloc>
    80005d7e:	84aa                	mv	s1,a0
    80005d80:	0e054663          	bltz	a0,80005e6c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005d84:	04491703          	lh	a4,68(s2)
    80005d88:	478d                	li	a5,3
    80005d8a:	0cf70463          	beq	a4,a5,80005e52 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005d8e:	4789                	li	a5,2
    80005d90:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005d94:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005d98:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005d9c:	f4c42783          	lw	a5,-180(s0)
    80005da0:	0017c713          	xori	a4,a5,1
    80005da4:	8b05                	andi	a4,a4,1
    80005da6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005daa:	0037f713          	andi	a4,a5,3
    80005dae:	00e03733          	snez	a4,a4
    80005db2:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005db6:	4007f793          	andi	a5,a5,1024
    80005dba:	c791                	beqz	a5,80005dc6 <sys_open+0xd2>
    80005dbc:	04491703          	lh	a4,68(s2)
    80005dc0:	4789                	li	a5,2
    80005dc2:	08f70f63          	beq	a4,a5,80005e60 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005dc6:	854a                	mv	a0,s2
    80005dc8:	ffffe097          	auipc	ra,0xffffe
    80005dcc:	032080e7          	jalr	50(ra) # 80003dfa <iunlock>
  end_op();
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	9ba080e7          	jalr	-1606(ra) # 8000478a <end_op>

  return fd;
}
    80005dd8:	8526                	mv	a0,s1
    80005dda:	70ea                	ld	ra,184(sp)
    80005ddc:	744a                	ld	s0,176(sp)
    80005dde:	74aa                	ld	s1,168(sp)
    80005de0:	790a                	ld	s2,160(sp)
    80005de2:	69ea                	ld	s3,152(sp)
    80005de4:	6129                	addi	sp,sp,192
    80005de6:	8082                	ret
      end_op();
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	9a2080e7          	jalr	-1630(ra) # 8000478a <end_op>
      return -1;
    80005df0:	b7e5                	j	80005dd8 <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80005df2:	f5040513          	addi	a0,s0,-176
    80005df6:	ffffe097          	auipc	ra,0xffffe
    80005dfa:	6f8080e7          	jalr	1784(ra) # 800044ee <namei>
    80005dfe:	892a                	mv	s2,a0
    80005e00:	c905                	beqz	a0,80005e30 <sys_open+0x13c>
    ilock(ip);
    80005e02:	ffffe097          	auipc	ra,0xffffe
    80005e06:	f36080e7          	jalr	-202(ra) # 80003d38 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005e0a:	04491703          	lh	a4,68(s2)
    80005e0e:	4785                	li	a5,1
    80005e10:	f4f712e3          	bne	a4,a5,80005d54 <sys_open+0x60>
    80005e14:	f4c42783          	lw	a5,-180(s0)
    80005e18:	dba1                	beqz	a5,80005d68 <sys_open+0x74>
      iunlockput(ip);
    80005e1a:	854a                	mv	a0,s2
    80005e1c:	ffffe097          	auipc	ra,0xffffe
    80005e20:	17e080e7          	jalr	382(ra) # 80003f9a <iunlockput>
      end_op();
    80005e24:	fffff097          	auipc	ra,0xfffff
    80005e28:	966080e7          	jalr	-1690(ra) # 8000478a <end_op>
      return -1;
    80005e2c:	54fd                	li	s1,-1
    80005e2e:	b76d                	j	80005dd8 <sys_open+0xe4>
      end_op();
    80005e30:	fffff097          	auipc	ra,0xfffff
    80005e34:	95a080e7          	jalr	-1702(ra) # 8000478a <end_op>
      return -1;
    80005e38:	54fd                	li	s1,-1
    80005e3a:	bf79                	j	80005dd8 <sys_open+0xe4>
    iunlockput(ip);
    80005e3c:	854a                	mv	a0,s2
    80005e3e:	ffffe097          	auipc	ra,0xffffe
    80005e42:	15c080e7          	jalr	348(ra) # 80003f9a <iunlockput>
    end_op();
    80005e46:	fffff097          	auipc	ra,0xfffff
    80005e4a:	944080e7          	jalr	-1724(ra) # 8000478a <end_op>
    return -1;
    80005e4e:	54fd                	li	s1,-1
    80005e50:	b761                	j	80005dd8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005e52:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005e56:	04691783          	lh	a5,70(s2)
    80005e5a:	02f99223          	sh	a5,36(s3)
    80005e5e:	bf2d                	j	80005d98 <sys_open+0xa4>
    itrunc(ip);
    80005e60:	854a                	mv	a0,s2
    80005e62:	ffffe097          	auipc	ra,0xffffe
    80005e66:	fe4080e7          	jalr	-28(ra) # 80003e46 <itrunc>
    80005e6a:	bfb1                	j	80005dc6 <sys_open+0xd2>
      fileclose(f);
    80005e6c:	854e                	mv	a0,s3
    80005e6e:	fffff097          	auipc	ra,0xfffff
    80005e72:	d68080e7          	jalr	-664(ra) # 80004bd6 <fileclose>
    iunlockput(ip);
    80005e76:	854a                	mv	a0,s2
    80005e78:	ffffe097          	auipc	ra,0xffffe
    80005e7c:	122080e7          	jalr	290(ra) # 80003f9a <iunlockput>
    end_op();
    80005e80:	fffff097          	auipc	ra,0xfffff
    80005e84:	90a080e7          	jalr	-1782(ra) # 8000478a <end_op>
    return -1;
    80005e88:	54fd                	li	s1,-1
    80005e8a:	b7b9                	j	80005dd8 <sys_open+0xe4>

0000000080005e8c <sys_mkdir>:

uint64 sys_mkdir(void) {
    80005e8c:	7175                	addi	sp,sp,-144
    80005e8e:	e506                	sd	ra,136(sp)
    80005e90:	e122                	sd	s0,128(sp)
    80005e92:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e94:	fffff097          	auipc	ra,0xfffff
    80005e98:	876080e7          	jalr	-1930(ra) # 8000470a <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005e9c:	08000613          	li	a2,128
    80005ea0:	f7040593          	addi	a1,s0,-144
    80005ea4:	4501                	li	a0,0
    80005ea6:	ffffd097          	auipc	ra,0xffffd
    80005eaa:	256080e7          	jalr	598(ra) # 800030fc <argstr>
    80005eae:	02054963          	bltz	a0,80005ee0 <sys_mkdir+0x54>
    80005eb2:	4681                	li	a3,0
    80005eb4:	4601                	li	a2,0
    80005eb6:	4585                	li	a1,1
    80005eb8:	f7040513          	addi	a0,s0,-144
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	800080e7          	jalr	-2048(ra) # 800056bc <create>
    80005ec4:	cd11                	beqz	a0,80005ee0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ec6:	ffffe097          	auipc	ra,0xffffe
    80005eca:	0d4080e7          	jalr	212(ra) # 80003f9a <iunlockput>
  end_op();
    80005ece:	fffff097          	auipc	ra,0xfffff
    80005ed2:	8bc080e7          	jalr	-1860(ra) # 8000478a <end_op>
  return 0;
    80005ed6:	4501                	li	a0,0
}
    80005ed8:	60aa                	ld	ra,136(sp)
    80005eda:	640a                	ld	s0,128(sp)
    80005edc:	6149                	addi	sp,sp,144
    80005ede:	8082                	ret
    end_op();
    80005ee0:	fffff097          	auipc	ra,0xfffff
    80005ee4:	8aa080e7          	jalr	-1878(ra) # 8000478a <end_op>
    return -1;
    80005ee8:	557d                	li	a0,-1
    80005eea:	b7fd                	j	80005ed8 <sys_mkdir+0x4c>

0000000080005eec <sys_mknod>:

uint64 sys_mknod(void) {
    80005eec:	7135                	addi	sp,sp,-160
    80005eee:	ed06                	sd	ra,152(sp)
    80005ef0:	e922                	sd	s0,144(sp)
    80005ef2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005ef4:	fffff097          	auipc	ra,0xfffff
    80005ef8:	816080e7          	jalr	-2026(ra) # 8000470a <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005efc:	08000613          	li	a2,128
    80005f00:	f7040593          	addi	a1,s0,-144
    80005f04:	4501                	li	a0,0
    80005f06:	ffffd097          	auipc	ra,0xffffd
    80005f0a:	1f6080e7          	jalr	502(ra) # 800030fc <argstr>
    80005f0e:	04054a63          	bltz	a0,80005f62 <sys_mknod+0x76>
    80005f12:	f6c40593          	addi	a1,s0,-148
    80005f16:	4505                	li	a0,1
    80005f18:	ffffd097          	auipc	ra,0xffffd
    80005f1c:	1a0080e7          	jalr	416(ra) # 800030b8 <argint>
    80005f20:	04054163          	bltz	a0,80005f62 <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80005f24:	f6840593          	addi	a1,s0,-152
    80005f28:	4509                	li	a0,2
    80005f2a:	ffffd097          	auipc	ra,0xffffd
    80005f2e:	18e080e7          	jalr	398(ra) # 800030b8 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005f32:	02054863          	bltz	a0,80005f62 <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005f36:	f6841683          	lh	a3,-152(s0)
    80005f3a:	f6c41603          	lh	a2,-148(s0)
    80005f3e:	458d                	li	a1,3
    80005f40:	f7040513          	addi	a0,s0,-144
    80005f44:	fffff097          	auipc	ra,0xfffff
    80005f48:	778080e7          	jalr	1912(ra) # 800056bc <create>
      argint(2, &minor) < 0 ||
    80005f4c:	c919                	beqz	a0,80005f62 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f4e:	ffffe097          	auipc	ra,0xffffe
    80005f52:	04c080e7          	jalr	76(ra) # 80003f9a <iunlockput>
  end_op();
    80005f56:	fffff097          	auipc	ra,0xfffff
    80005f5a:	834080e7          	jalr	-1996(ra) # 8000478a <end_op>
  return 0;
    80005f5e:	4501                	li	a0,0
    80005f60:	a031                	j	80005f6c <sys_mknod+0x80>
    end_op();
    80005f62:	fffff097          	auipc	ra,0xfffff
    80005f66:	828080e7          	jalr	-2008(ra) # 8000478a <end_op>
    return -1;
    80005f6a:	557d                	li	a0,-1
}
    80005f6c:	60ea                	ld	ra,152(sp)
    80005f6e:	644a                	ld	s0,144(sp)
    80005f70:	610d                	addi	sp,sp,160
    80005f72:	8082                	ret

0000000080005f74 <sys_chdir>:

uint64 sys_chdir(void) {
    80005f74:	7135                	addi	sp,sp,-160
    80005f76:	ed06                	sd	ra,152(sp)
    80005f78:	e922                	sd	s0,144(sp)
    80005f7a:	e526                	sd	s1,136(sp)
    80005f7c:	e14a                	sd	s2,128(sp)
    80005f7e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f80:	ffffc097          	auipc	ra,0xffffc
    80005f84:	d14080e7          	jalr	-748(ra) # 80001c94 <myproc>
    80005f88:	892a                	mv	s2,a0

  begin_op();
    80005f8a:	ffffe097          	auipc	ra,0xffffe
    80005f8e:	780080e7          	jalr	1920(ra) # 8000470a <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005f92:	08000613          	li	a2,128
    80005f96:	f6040593          	addi	a1,s0,-160
    80005f9a:	4501                	li	a0,0
    80005f9c:	ffffd097          	auipc	ra,0xffffd
    80005fa0:	160080e7          	jalr	352(ra) # 800030fc <argstr>
    80005fa4:	04054b63          	bltz	a0,80005ffa <sys_chdir+0x86>
    80005fa8:	f6040513          	addi	a0,s0,-160
    80005fac:	ffffe097          	auipc	ra,0xffffe
    80005fb0:	542080e7          	jalr	1346(ra) # 800044ee <namei>
    80005fb4:	84aa                	mv	s1,a0
    80005fb6:	c131                	beqz	a0,80005ffa <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005fb8:	ffffe097          	auipc	ra,0xffffe
    80005fbc:	d80080e7          	jalr	-640(ra) # 80003d38 <ilock>
  if (ip->type != T_DIR) {
    80005fc0:	04449703          	lh	a4,68(s1)
    80005fc4:	4785                	li	a5,1
    80005fc6:	04f71063          	bne	a4,a5,80006006 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005fca:	8526                	mv	a0,s1
    80005fcc:	ffffe097          	auipc	ra,0xffffe
    80005fd0:	e2e080e7          	jalr	-466(ra) # 80003dfa <iunlock>
  iput(p->cwd);
    80005fd4:	16093503          	ld	a0,352(s2)
    80005fd8:	ffffe097          	auipc	ra,0xffffe
    80005fdc:	f1a080e7          	jalr	-230(ra) # 80003ef2 <iput>
  end_op();
    80005fe0:	ffffe097          	auipc	ra,0xffffe
    80005fe4:	7aa080e7          	jalr	1962(ra) # 8000478a <end_op>
  p->cwd = ip;
    80005fe8:	16993023          	sd	s1,352(s2)
  return 0;
    80005fec:	4501                	li	a0,0
}
    80005fee:	60ea                	ld	ra,152(sp)
    80005ff0:	644a                	ld	s0,144(sp)
    80005ff2:	64aa                	ld	s1,136(sp)
    80005ff4:	690a                	ld	s2,128(sp)
    80005ff6:	610d                	addi	sp,sp,160
    80005ff8:	8082                	ret
    end_op();
    80005ffa:	ffffe097          	auipc	ra,0xffffe
    80005ffe:	790080e7          	jalr	1936(ra) # 8000478a <end_op>
    return -1;
    80006002:	557d                	li	a0,-1
    80006004:	b7ed                	j	80005fee <sys_chdir+0x7a>
    iunlockput(ip);
    80006006:	8526                	mv	a0,s1
    80006008:	ffffe097          	auipc	ra,0xffffe
    8000600c:	f92080e7          	jalr	-110(ra) # 80003f9a <iunlockput>
    end_op();
    80006010:	ffffe097          	auipc	ra,0xffffe
    80006014:	77a080e7          	jalr	1914(ra) # 8000478a <end_op>
    return -1;
    80006018:	557d                	li	a0,-1
    8000601a:	bfd1                	j	80005fee <sys_chdir+0x7a>

000000008000601c <sys_exec>:

uint64 sys_exec(void) {
    8000601c:	7145                	addi	sp,sp,-464
    8000601e:	e786                	sd	ra,456(sp)
    80006020:	e3a2                	sd	s0,448(sp)
    80006022:	ff26                	sd	s1,440(sp)
    80006024:	fb4a                	sd	s2,432(sp)
    80006026:	f74e                	sd	s3,424(sp)
    80006028:	f352                	sd	s4,416(sp)
    8000602a:	ef56                	sd	s5,408(sp)
    8000602c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) {
    8000602e:	08000613          	li	a2,128
    80006032:	f4040593          	addi	a1,s0,-192
    80006036:	4501                	li	a0,0
    80006038:	ffffd097          	auipc	ra,0xffffd
    8000603c:	0c4080e7          	jalr	196(ra) # 800030fc <argstr>
    return -1;
    80006040:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) {
    80006042:	0c054a63          	bltz	a0,80006116 <sys_exec+0xfa>
    80006046:	e3840593          	addi	a1,s0,-456
    8000604a:	4505                	li	a0,1
    8000604c:	ffffd097          	auipc	ra,0xffffd
    80006050:	08e080e7          	jalr	142(ra) # 800030da <argaddr>
    80006054:	0c054163          	bltz	a0,80006116 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006058:	10000613          	li	a2,256
    8000605c:	4581                	li	a1,0
    8000605e:	e4040513          	addi	a0,s0,-448
    80006062:	ffffb097          	auipc	ra,0xffffb
    80006066:	cd4080e7          	jalr	-812(ra) # 80000d36 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    8000606a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000606e:	89a6                	mv	s3,s1
    80006070:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80006072:	02000a13          	li	s4,32
    80006076:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000607a:	00391793          	slli	a5,s2,0x3
    8000607e:	e3040593          	addi	a1,s0,-464
    80006082:	e3843503          	ld	a0,-456(s0)
    80006086:	953e                	add	a0,a0,a5
    80006088:	ffffd097          	auipc	ra,0xffffd
    8000608c:	f96080e7          	jalr	-106(ra) # 8000301e <fetchaddr>
    80006090:	02054a63          	bltz	a0,800060c4 <sys_exec+0xa8>
      goto bad;
    }
    if (uarg == 0) {
    80006094:	e3043783          	ld	a5,-464(s0)
    80006098:	c3b9                	beqz	a5,800060de <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000609a:	ffffb097          	auipc	ra,0xffffb
    8000609e:	ab0080e7          	jalr	-1360(ra) # 80000b4a <kalloc>
    800060a2:	85aa                	mv	a1,a0
    800060a4:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    800060a8:	cd11                	beqz	a0,800060c4 <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060aa:	6605                	lui	a2,0x1
    800060ac:	e3043503          	ld	a0,-464(s0)
    800060b0:	ffffd097          	auipc	ra,0xffffd
    800060b4:	fc0080e7          	jalr	-64(ra) # 80003070 <fetchstr>
    800060b8:	00054663          	bltz	a0,800060c4 <sys_exec+0xa8>
    if (i >= NELEM(argv)) {
    800060bc:	0905                	addi	s2,s2,1
    800060be:	09a1                	addi	s3,s3,8
    800060c0:	fb491be3          	bne	s2,s4,80006076 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060c4:	10048913          	addi	s2,s1,256
    800060c8:	6088                	ld	a0,0(s1)
    800060ca:	c529                	beqz	a0,80006114 <sys_exec+0xf8>
    kfree(argv[i]);
    800060cc:	ffffb097          	auipc	ra,0xffffb
    800060d0:	982080e7          	jalr	-1662(ra) # 80000a4e <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060d4:	04a1                	addi	s1,s1,8
    800060d6:	ff2499e3          	bne	s1,s2,800060c8 <sys_exec+0xac>
  return -1;
    800060da:	597d                	li	s2,-1
    800060dc:	a82d                	j	80006116 <sys_exec+0xfa>
      argv[i] = 0;
    800060de:	0a8e                	slli	s5,s5,0x3
    800060e0:	fc040793          	addi	a5,s0,-64
    800060e4:	9abe                	add	s5,s5,a5
    800060e6:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    800060ea:	e4040593          	addi	a1,s0,-448
    800060ee:	f4040513          	addi	a0,s0,-192
    800060f2:	fffff097          	auipc	ra,0xfffff
    800060f6:	136080e7          	jalr	310(ra) # 80005228 <exec>
    800060fa:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060fc:	10048993          	addi	s3,s1,256
    80006100:	6088                	ld	a0,0(s1)
    80006102:	c911                	beqz	a0,80006116 <sys_exec+0xfa>
    kfree(argv[i]);
    80006104:	ffffb097          	auipc	ra,0xffffb
    80006108:	94a080e7          	jalr	-1718(ra) # 80000a4e <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000610c:	04a1                	addi	s1,s1,8
    8000610e:	ff3499e3          	bne	s1,s3,80006100 <sys_exec+0xe4>
    80006112:	a011                	j	80006116 <sys_exec+0xfa>
  return -1;
    80006114:	597d                	li	s2,-1
}
    80006116:	854a                	mv	a0,s2
    80006118:	60be                	ld	ra,456(sp)
    8000611a:	641e                	ld	s0,448(sp)
    8000611c:	74fa                	ld	s1,440(sp)
    8000611e:	795a                	ld	s2,432(sp)
    80006120:	79ba                	ld	s3,424(sp)
    80006122:	7a1a                	ld	s4,416(sp)
    80006124:	6afa                	ld	s5,408(sp)
    80006126:	6179                	addi	sp,sp,464
    80006128:	8082                	ret

000000008000612a <sys_pipe>:

uint64 sys_pipe(void) {
    8000612a:	7139                	addi	sp,sp,-64
    8000612c:	fc06                	sd	ra,56(sp)
    8000612e:	f822                	sd	s0,48(sp)
    80006130:	f426                	sd	s1,40(sp)
    80006132:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006134:	ffffc097          	auipc	ra,0xffffc
    80006138:	b60080e7          	jalr	-1184(ra) # 80001c94 <myproc>
    8000613c:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    8000613e:	fd840593          	addi	a1,s0,-40
    80006142:	4501                	li	a0,0
    80006144:	ffffd097          	auipc	ra,0xffffd
    80006148:	f96080e7          	jalr	-106(ra) # 800030da <argaddr>
    return -1;
    8000614c:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    8000614e:	0e054063          	bltz	a0,8000622e <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    80006152:	fc840593          	addi	a1,s0,-56
    80006156:	fd040513          	addi	a0,s0,-48
    8000615a:	fffff097          	auipc	ra,0xfffff
    8000615e:	dac080e7          	jalr	-596(ra) # 80004f06 <pipealloc>
    return -1;
    80006162:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80006164:	0c054563          	bltz	a0,8000622e <sys_pipe+0x104>
  fd0 = -1;
    80006168:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000616c:	fd043503          	ld	a0,-48(s0)
    80006170:	fffff097          	auipc	ra,0xfffff
    80006174:	50a080e7          	jalr	1290(ra) # 8000567a <fdalloc>
    80006178:	fca42223          	sw	a0,-60(s0)
    8000617c:	08054c63          	bltz	a0,80006214 <sys_pipe+0xea>
    80006180:	fc843503          	ld	a0,-56(s0)
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	4f6080e7          	jalr	1270(ra) # 8000567a <fdalloc>
    8000618c:	fca42023          	sw	a0,-64(s0)
    80006190:	06054863          	bltz	a0,80006200 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80006194:	4691                	li	a3,4
    80006196:	fc440613          	addi	a2,s0,-60
    8000619a:	fd843583          	ld	a1,-40(s0)
    8000619e:	6ca8                	ld	a0,88(s1)
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	6e4080e7          	jalr	1764(ra) # 80001884 <copyout>
    800061a8:	02054063          	bltz	a0,800061c8 <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    800061ac:	4691                	li	a3,4
    800061ae:	fc040613          	addi	a2,s0,-64
    800061b2:	fd843583          	ld	a1,-40(s0)
    800061b6:	0591                	addi	a1,a1,4
    800061b8:	6ca8                	ld	a0,88(s1)
    800061ba:	ffffb097          	auipc	ra,0xffffb
    800061be:	6ca080e7          	jalr	1738(ra) # 80001884 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800061c2:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800061c4:	06055563          	bgez	a0,8000622e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800061c8:	fc442783          	lw	a5,-60(s0)
    800061cc:	07f1                	addi	a5,a5,28
    800061ce:	078e                	slli	a5,a5,0x3
    800061d0:	97a6                	add	a5,a5,s1
    800061d2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800061d6:	fc042503          	lw	a0,-64(s0)
    800061da:	0571                	addi	a0,a0,28
    800061dc:	050e                	slli	a0,a0,0x3
    800061de:	9526                	add	a0,a0,s1
    800061e0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800061e4:	fd043503          	ld	a0,-48(s0)
    800061e8:	fffff097          	auipc	ra,0xfffff
    800061ec:	9ee080e7          	jalr	-1554(ra) # 80004bd6 <fileclose>
    fileclose(wf);
    800061f0:	fc843503          	ld	a0,-56(s0)
    800061f4:	fffff097          	auipc	ra,0xfffff
    800061f8:	9e2080e7          	jalr	-1566(ra) # 80004bd6 <fileclose>
    return -1;
    800061fc:	57fd                	li	a5,-1
    800061fe:	a805                	j	8000622e <sys_pipe+0x104>
    if (fd0 >= 0)
    80006200:	fc442783          	lw	a5,-60(s0)
    80006204:	0007c863          	bltz	a5,80006214 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80006208:	01c78513          	addi	a0,a5,28
    8000620c:	050e                	slli	a0,a0,0x3
    8000620e:	9526                	add	a0,a0,s1
    80006210:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006214:	fd043503          	ld	a0,-48(s0)
    80006218:	fffff097          	auipc	ra,0xfffff
    8000621c:	9be080e7          	jalr	-1602(ra) # 80004bd6 <fileclose>
    fileclose(wf);
    80006220:	fc843503          	ld	a0,-56(s0)
    80006224:	fffff097          	auipc	ra,0xfffff
    80006228:	9b2080e7          	jalr	-1614(ra) # 80004bd6 <fileclose>
    return -1;
    8000622c:	57fd                	li	a5,-1
}
    8000622e:	853e                	mv	a0,a5
    80006230:	70e2                	ld	ra,56(sp)
    80006232:	7442                	ld	s0,48(sp)
    80006234:	74a2                	ld	s1,40(sp)
    80006236:	6121                	addi	sp,sp,64
    80006238:	8082                	ret
    8000623a:	0000                	unimp
    8000623c:	0000                	unimp
	...

0000000080006240 <kernelvec>:
    80006240:	7111                	addi	sp,sp,-256
    80006242:	e006                	sd	ra,0(sp)
    80006244:	e40a                	sd	sp,8(sp)
    80006246:	e80e                	sd	gp,16(sp)
    80006248:	ec12                	sd	tp,24(sp)
    8000624a:	f016                	sd	t0,32(sp)
    8000624c:	f41a                	sd	t1,40(sp)
    8000624e:	f81e                	sd	t2,48(sp)
    80006250:	fc22                	sd	s0,56(sp)
    80006252:	e0a6                	sd	s1,64(sp)
    80006254:	e4aa                	sd	a0,72(sp)
    80006256:	e8ae                	sd	a1,80(sp)
    80006258:	ecb2                	sd	a2,88(sp)
    8000625a:	f0b6                	sd	a3,96(sp)
    8000625c:	f4ba                	sd	a4,104(sp)
    8000625e:	f8be                	sd	a5,112(sp)
    80006260:	fcc2                	sd	a6,120(sp)
    80006262:	e146                	sd	a7,128(sp)
    80006264:	e54a                	sd	s2,136(sp)
    80006266:	e94e                	sd	s3,144(sp)
    80006268:	ed52                	sd	s4,152(sp)
    8000626a:	f156                	sd	s5,160(sp)
    8000626c:	f55a                	sd	s6,168(sp)
    8000626e:	f95e                	sd	s7,176(sp)
    80006270:	fd62                	sd	s8,184(sp)
    80006272:	e1e6                	sd	s9,192(sp)
    80006274:	e5ea                	sd	s10,200(sp)
    80006276:	e9ee                	sd	s11,208(sp)
    80006278:	edf2                	sd	t3,216(sp)
    8000627a:	f1f6                	sd	t4,224(sp)
    8000627c:	f5fa                	sd	t5,232(sp)
    8000627e:	f9fe                	sd	t6,240(sp)
    80006280:	c6bfc0ef          	jal	ra,80002eea <kerneltrap>
    80006284:	6082                	ld	ra,0(sp)
    80006286:	6122                	ld	sp,8(sp)
    80006288:	61c2                	ld	gp,16(sp)
    8000628a:	7282                	ld	t0,32(sp)
    8000628c:	7322                	ld	t1,40(sp)
    8000628e:	73c2                	ld	t2,48(sp)
    80006290:	7462                	ld	s0,56(sp)
    80006292:	6486                	ld	s1,64(sp)
    80006294:	6526                	ld	a0,72(sp)
    80006296:	65c6                	ld	a1,80(sp)
    80006298:	6666                	ld	a2,88(sp)
    8000629a:	7686                	ld	a3,96(sp)
    8000629c:	7726                	ld	a4,104(sp)
    8000629e:	77c6                	ld	a5,112(sp)
    800062a0:	7866                	ld	a6,120(sp)
    800062a2:	688a                	ld	a7,128(sp)
    800062a4:	692a                	ld	s2,136(sp)
    800062a6:	69ca                	ld	s3,144(sp)
    800062a8:	6a6a                	ld	s4,152(sp)
    800062aa:	7a8a                	ld	s5,160(sp)
    800062ac:	7b2a                	ld	s6,168(sp)
    800062ae:	7bca                	ld	s7,176(sp)
    800062b0:	7c6a                	ld	s8,184(sp)
    800062b2:	6c8e                	ld	s9,192(sp)
    800062b4:	6d2e                	ld	s10,200(sp)
    800062b6:	6dce                	ld	s11,208(sp)
    800062b8:	6e6e                	ld	t3,216(sp)
    800062ba:	7e8e                	ld	t4,224(sp)
    800062bc:	7f2e                	ld	t5,232(sp)
    800062be:	7fce                	ld	t6,240(sp)
    800062c0:	6111                	addi	sp,sp,256
    800062c2:	10200073          	sret
    800062c6:	00000013          	nop
    800062ca:	00000013          	nop
    800062ce:	0001                	nop

00000000800062d0 <timervec>:
    800062d0:	34051573          	csrrw	a0,mscratch,a0
    800062d4:	e10c                	sd	a1,0(a0)
    800062d6:	e510                	sd	a2,8(a0)
    800062d8:	e914                	sd	a3,16(a0)
    800062da:	6d0c                	ld	a1,24(a0)
    800062dc:	7110                	ld	a2,32(a0)
    800062de:	6194                	ld	a3,0(a1)
    800062e0:	96b2                	add	a3,a3,a2
    800062e2:	e194                	sd	a3,0(a1)
    800062e4:	4589                	li	a1,2
    800062e6:	14459073          	csrw	sip,a1
    800062ea:	6914                	ld	a3,16(a0)
    800062ec:	6510                	ld	a2,8(a0)
    800062ee:	610c                	ld	a1,0(a0)
    800062f0:	34051573          	csrrw	a0,mscratch,a0
    800062f4:	30200073          	mret
	...

00000000800062fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800062fa:	1141                	addi	sp,sp,-16
    800062fc:	e422                	sd	s0,8(sp)
    800062fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006300:	0c0007b7          	lui	a5,0xc000
    80006304:	4705                	li	a4,1
    80006306:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006308:	c3d8                	sw	a4,4(a5)
}
    8000630a:	6422                	ld	s0,8(sp)
    8000630c:	0141                	addi	sp,sp,16
    8000630e:	8082                	ret

0000000080006310 <plicinithart>:

void
plicinithart(void)
{
    80006310:	1141                	addi	sp,sp,-16
    80006312:	e406                	sd	ra,8(sp)
    80006314:	e022                	sd	s0,0(sp)
    80006316:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006318:	ffffc097          	auipc	ra,0xffffc
    8000631c:	950080e7          	jalr	-1712(ra) # 80001c68 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006320:	0085171b          	slliw	a4,a0,0x8
    80006324:	0c0027b7          	lui	a5,0xc002
    80006328:	97ba                	add	a5,a5,a4
    8000632a:	40200713          	li	a4,1026
    8000632e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006332:	00d5151b          	slliw	a0,a0,0xd
    80006336:	0c2017b7          	lui	a5,0xc201
    8000633a:	953e                	add	a0,a0,a5
    8000633c:	00052023          	sw	zero,0(a0)
}
    80006340:	60a2                	ld	ra,8(sp)
    80006342:	6402                	ld	s0,0(sp)
    80006344:	0141                	addi	sp,sp,16
    80006346:	8082                	ret

0000000080006348 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006348:	1141                	addi	sp,sp,-16
    8000634a:	e406                	sd	ra,8(sp)
    8000634c:	e022                	sd	s0,0(sp)
    8000634e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006350:	ffffc097          	auipc	ra,0xffffc
    80006354:	918080e7          	jalr	-1768(ra) # 80001c68 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006358:	00d5179b          	slliw	a5,a0,0xd
    8000635c:	0c201537          	lui	a0,0xc201
    80006360:	953e                	add	a0,a0,a5
  return irq;
}
    80006362:	4148                	lw	a0,4(a0)
    80006364:	60a2                	ld	ra,8(sp)
    80006366:	6402                	ld	s0,0(sp)
    80006368:	0141                	addi	sp,sp,16
    8000636a:	8082                	ret

000000008000636c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	1000                	addi	s0,sp,32
    80006376:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006378:	ffffc097          	auipc	ra,0xffffc
    8000637c:	8f0080e7          	jalr	-1808(ra) # 80001c68 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006380:	00d5151b          	slliw	a0,a0,0xd
    80006384:	0c2017b7          	lui	a5,0xc201
    80006388:	97aa                	add	a5,a5,a0
    8000638a:	c3c4                	sw	s1,4(a5)
}
    8000638c:	60e2                	ld	ra,24(sp)
    8000638e:	6442                	ld	s0,16(sp)
    80006390:	64a2                	ld	s1,8(sp)
    80006392:	6105                	addi	sp,sp,32
    80006394:	8082                	ret

0000000080006396 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006396:	1141                	addi	sp,sp,-16
    80006398:	e406                	sd	ra,8(sp)
    8000639a:	e022                	sd	s0,0(sp)
    8000639c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000639e:	479d                	li	a5,7
    800063a0:	06a7c963          	blt	a5,a0,80006412 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800063a4:	0001d797          	auipc	a5,0x1d
    800063a8:	c5c78793          	addi	a5,a5,-932 # 80023000 <disk>
    800063ac:	00a78733          	add	a4,a5,a0
    800063b0:	6789                	lui	a5,0x2
    800063b2:	97ba                	add	a5,a5,a4
    800063b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800063b8:	e7ad                	bnez	a5,80006422 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800063ba:	00451793          	slli	a5,a0,0x4
    800063be:	0001f717          	auipc	a4,0x1f
    800063c2:	c4270713          	addi	a4,a4,-958 # 80025000 <disk+0x2000>
    800063c6:	6314                	ld	a3,0(a4)
    800063c8:	96be                	add	a3,a3,a5
    800063ca:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800063ce:	6314                	ld	a3,0(a4)
    800063d0:	96be                	add	a3,a3,a5
    800063d2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800063d6:	6314                	ld	a3,0(a4)
    800063d8:	96be                	add	a3,a3,a5
    800063da:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800063de:	6318                	ld	a4,0(a4)
    800063e0:	97ba                	add	a5,a5,a4
    800063e2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800063e6:	0001d797          	auipc	a5,0x1d
    800063ea:	c1a78793          	addi	a5,a5,-998 # 80023000 <disk>
    800063ee:	97aa                	add	a5,a5,a0
    800063f0:	6509                	lui	a0,0x2
    800063f2:	953e                	add	a0,a0,a5
    800063f4:	4785                	li	a5,1
    800063f6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800063fa:	0001f517          	auipc	a0,0x1f
    800063fe:	c1e50513          	addi	a0,a0,-994 # 80025018 <disk+0x2018>
    80006402:	ffffc097          	auipc	ra,0xffffc
    80006406:	2d0080e7          	jalr	720(ra) # 800026d2 <wakeup>
}
    8000640a:	60a2                	ld	ra,8(sp)
    8000640c:	6402                	ld	s0,0(sp)
    8000640e:	0141                	addi	sp,sp,16
    80006410:	8082                	ret
    panic("free_desc 1");
    80006412:	00002517          	auipc	a0,0x2
    80006416:	41e50513          	addi	a0,a0,1054 # 80008830 <syscalls+0x330>
    8000641a:	ffffa097          	auipc	ra,0xffffa
    8000641e:	1b2080e7          	jalr	434(ra) # 800005cc <panic>
    panic("free_desc 2");
    80006422:	00002517          	auipc	a0,0x2
    80006426:	41e50513          	addi	a0,a0,1054 # 80008840 <syscalls+0x340>
    8000642a:	ffffa097          	auipc	ra,0xffffa
    8000642e:	1a2080e7          	jalr	418(ra) # 800005cc <panic>

0000000080006432 <virtio_disk_init>:
{
    80006432:	1101                	addi	sp,sp,-32
    80006434:	ec06                	sd	ra,24(sp)
    80006436:	e822                	sd	s0,16(sp)
    80006438:	e426                	sd	s1,8(sp)
    8000643a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000643c:	00002597          	auipc	a1,0x2
    80006440:	41458593          	addi	a1,a1,1044 # 80008850 <syscalls+0x350>
    80006444:	0001f517          	auipc	a0,0x1f
    80006448:	ce450513          	addi	a0,a0,-796 # 80025128 <disk+0x2128>
    8000644c:	ffffa097          	auipc	ra,0xffffa
    80006450:	75e080e7          	jalr	1886(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006454:	100017b7          	lui	a5,0x10001
    80006458:	4398                	lw	a4,0(a5)
    8000645a:	2701                	sext.w	a4,a4
    8000645c:	747277b7          	lui	a5,0x74727
    80006460:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006464:	0ef71163          	bne	a4,a5,80006546 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006468:	100017b7          	lui	a5,0x10001
    8000646c:	43dc                	lw	a5,4(a5)
    8000646e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006470:	4705                	li	a4,1
    80006472:	0ce79a63          	bne	a5,a4,80006546 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006476:	100017b7          	lui	a5,0x10001
    8000647a:	479c                	lw	a5,8(a5)
    8000647c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000647e:	4709                	li	a4,2
    80006480:	0ce79363          	bne	a5,a4,80006546 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006484:	100017b7          	lui	a5,0x10001
    80006488:	47d8                	lw	a4,12(a5)
    8000648a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000648c:	554d47b7          	lui	a5,0x554d4
    80006490:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006494:	0af71963          	bne	a4,a5,80006546 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006498:	100017b7          	lui	a5,0x10001
    8000649c:	4705                	li	a4,1
    8000649e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064a0:	470d                	li	a4,3
    800064a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064a4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800064a6:	c7ffe737          	lui	a4,0xc7ffe
    800064aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    800064ae:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064b0:	2701                	sext.w	a4,a4
    800064b2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064b4:	472d                	li	a4,11
    800064b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064b8:	473d                	li	a4,15
    800064ba:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800064bc:	6705                	lui	a4,0x1
    800064be:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800064c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800064c4:	5bdc                	lw	a5,52(a5)
    800064c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800064c8:	c7d9                	beqz	a5,80006556 <virtio_disk_init+0x124>
  if(max < NUM)
    800064ca:	471d                	li	a4,7
    800064cc:	08f77d63          	bgeu	a4,a5,80006566 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800064d0:	100014b7          	lui	s1,0x10001
    800064d4:	47a1                	li	a5,8
    800064d6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800064d8:	6609                	lui	a2,0x2
    800064da:	4581                	li	a1,0
    800064dc:	0001d517          	auipc	a0,0x1d
    800064e0:	b2450513          	addi	a0,a0,-1244 # 80023000 <disk>
    800064e4:	ffffb097          	auipc	ra,0xffffb
    800064e8:	852080e7          	jalr	-1966(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800064ec:	0001d717          	auipc	a4,0x1d
    800064f0:	b1470713          	addi	a4,a4,-1260 # 80023000 <disk>
    800064f4:	00c75793          	srli	a5,a4,0xc
    800064f8:	2781                	sext.w	a5,a5
    800064fa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800064fc:	0001f797          	auipc	a5,0x1f
    80006500:	b0478793          	addi	a5,a5,-1276 # 80025000 <disk+0x2000>
    80006504:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006506:	0001d717          	auipc	a4,0x1d
    8000650a:	b7a70713          	addi	a4,a4,-1158 # 80023080 <disk+0x80>
    8000650e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006510:	0001e717          	auipc	a4,0x1e
    80006514:	af070713          	addi	a4,a4,-1296 # 80024000 <disk+0x1000>
    80006518:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000651a:	4705                	li	a4,1
    8000651c:	00e78c23          	sb	a4,24(a5)
    80006520:	00e78ca3          	sb	a4,25(a5)
    80006524:	00e78d23          	sb	a4,26(a5)
    80006528:	00e78da3          	sb	a4,27(a5)
    8000652c:	00e78e23          	sb	a4,28(a5)
    80006530:	00e78ea3          	sb	a4,29(a5)
    80006534:	00e78f23          	sb	a4,30(a5)
    80006538:	00e78fa3          	sb	a4,31(a5)
}
    8000653c:	60e2                	ld	ra,24(sp)
    8000653e:	6442                	ld	s0,16(sp)
    80006540:	64a2                	ld	s1,8(sp)
    80006542:	6105                	addi	sp,sp,32
    80006544:	8082                	ret
    panic("could not find virtio disk");
    80006546:	00002517          	auipc	a0,0x2
    8000654a:	31a50513          	addi	a0,a0,794 # 80008860 <syscalls+0x360>
    8000654e:	ffffa097          	auipc	ra,0xffffa
    80006552:	07e080e7          	jalr	126(ra) # 800005cc <panic>
    panic("virtio disk has no queue 0");
    80006556:	00002517          	auipc	a0,0x2
    8000655a:	32a50513          	addi	a0,a0,810 # 80008880 <syscalls+0x380>
    8000655e:	ffffa097          	auipc	ra,0xffffa
    80006562:	06e080e7          	jalr	110(ra) # 800005cc <panic>
    panic("virtio disk max queue too short");
    80006566:	00002517          	auipc	a0,0x2
    8000656a:	33a50513          	addi	a0,a0,826 # 800088a0 <syscalls+0x3a0>
    8000656e:	ffffa097          	auipc	ra,0xffffa
    80006572:	05e080e7          	jalr	94(ra) # 800005cc <panic>

0000000080006576 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006576:	7119                	addi	sp,sp,-128
    80006578:	fc86                	sd	ra,120(sp)
    8000657a:	f8a2                	sd	s0,112(sp)
    8000657c:	f4a6                	sd	s1,104(sp)
    8000657e:	f0ca                	sd	s2,96(sp)
    80006580:	ecce                	sd	s3,88(sp)
    80006582:	e8d2                	sd	s4,80(sp)
    80006584:	e4d6                	sd	s5,72(sp)
    80006586:	e0da                	sd	s6,64(sp)
    80006588:	fc5e                	sd	s7,56(sp)
    8000658a:	f862                	sd	s8,48(sp)
    8000658c:	f466                	sd	s9,40(sp)
    8000658e:	f06a                	sd	s10,32(sp)
    80006590:	ec6e                	sd	s11,24(sp)
    80006592:	0100                	addi	s0,sp,128
    80006594:	8aaa                	mv	s5,a0
    80006596:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006598:	00c52c83          	lw	s9,12(a0)
    8000659c:	001c9c9b          	slliw	s9,s9,0x1
    800065a0:	1c82                	slli	s9,s9,0x20
    800065a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800065a6:	0001f517          	auipc	a0,0x1f
    800065aa:	b8250513          	addi	a0,a0,-1150 # 80025128 <disk+0x2128>
    800065ae:	ffffa097          	auipc	ra,0xffffa
    800065b2:	68c080e7          	jalr	1676(ra) # 80000c3a <acquire>
  for(int i = 0; i < 3; i++){
    800065b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800065b8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800065ba:	0001dc17          	auipc	s8,0x1d
    800065be:	a46c0c13          	addi	s8,s8,-1466 # 80023000 <disk>
    800065c2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800065c4:	4b0d                	li	s6,3
    800065c6:	a0ad                	j	80006630 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800065c8:	00fc0733          	add	a4,s8,a5
    800065cc:	975e                	add	a4,a4,s7
    800065ce:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800065d2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800065d4:	0207c563          	bltz	a5,800065fe <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800065d8:	2905                	addiw	s2,s2,1
    800065da:	0611                	addi	a2,a2,4
    800065dc:	19690d63          	beq	s2,s6,80006776 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800065e0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800065e2:	0001f717          	auipc	a4,0x1f
    800065e6:	a3670713          	addi	a4,a4,-1482 # 80025018 <disk+0x2018>
    800065ea:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800065ec:	00074683          	lbu	a3,0(a4)
    800065f0:	fee1                	bnez	a3,800065c8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800065f2:	2785                	addiw	a5,a5,1
    800065f4:	0705                	addi	a4,a4,1
    800065f6:	fe979be3          	bne	a5,s1,800065ec <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800065fa:	57fd                	li	a5,-1
    800065fc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800065fe:	01205d63          	blez	s2,80006618 <virtio_disk_rw+0xa2>
    80006602:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006604:	000a2503          	lw	a0,0(s4)
    80006608:	00000097          	auipc	ra,0x0
    8000660c:	d8e080e7          	jalr	-626(ra) # 80006396 <free_desc>
      for(int j = 0; j < i; j++)
    80006610:	2d85                	addiw	s11,s11,1
    80006612:	0a11                	addi	s4,s4,4
    80006614:	ffb918e3          	bne	s2,s11,80006604 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006618:	0001f597          	auipc	a1,0x1f
    8000661c:	b1058593          	addi	a1,a1,-1264 # 80025128 <disk+0x2128>
    80006620:	0001f517          	auipc	a0,0x1f
    80006624:	9f850513          	addi	a0,a0,-1544 # 80025018 <disk+0x2018>
    80006628:	ffffc097          	auipc	ra,0xffffc
    8000662c:	f1e080e7          	jalr	-226(ra) # 80002546 <sleep>
  for(int i = 0; i < 3; i++){
    80006630:	f8040a13          	addi	s4,s0,-128
{
    80006634:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006636:	894e                	mv	s2,s3
    80006638:	b765                	j	800065e0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000663a:	0001f697          	auipc	a3,0x1f
    8000663e:	9c66b683          	ld	a3,-1594(a3) # 80025000 <disk+0x2000>
    80006642:	96ba                	add	a3,a3,a4
    80006644:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006648:	0001d817          	auipc	a6,0x1d
    8000664c:	9b880813          	addi	a6,a6,-1608 # 80023000 <disk>
    80006650:	0001f697          	auipc	a3,0x1f
    80006654:	9b068693          	addi	a3,a3,-1616 # 80025000 <disk+0x2000>
    80006658:	6290                	ld	a2,0(a3)
    8000665a:	963a                	add	a2,a2,a4
    8000665c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006660:	0015e593          	ori	a1,a1,1
    80006664:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006668:	f8842603          	lw	a2,-120(s0)
    8000666c:	628c                	ld	a1,0(a3)
    8000666e:	972e                	add	a4,a4,a1
    80006670:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006674:	20050593          	addi	a1,a0,512
    80006678:	0592                	slli	a1,a1,0x4
    8000667a:	95c2                	add	a1,a1,a6
    8000667c:	577d                	li	a4,-1
    8000667e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006682:	00461713          	slli	a4,a2,0x4
    80006686:	6290                	ld	a2,0(a3)
    80006688:	963a                	add	a2,a2,a4
    8000668a:	03078793          	addi	a5,a5,48
    8000668e:	97c2                	add	a5,a5,a6
    80006690:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006692:	629c                	ld	a5,0(a3)
    80006694:	97ba                	add	a5,a5,a4
    80006696:	4605                	li	a2,1
    80006698:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000669a:	629c                	ld	a5,0(a3)
    8000669c:	97ba                	add	a5,a5,a4
    8000669e:	4809                	li	a6,2
    800066a0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800066a4:	629c                	ld	a5,0(a3)
    800066a6:	973e                	add	a4,a4,a5
    800066a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800066ac:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800066b0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800066b4:	6698                	ld	a4,8(a3)
    800066b6:	00275783          	lhu	a5,2(a4)
    800066ba:	8b9d                	andi	a5,a5,7
    800066bc:	0786                	slli	a5,a5,0x1
    800066be:	97ba                	add	a5,a5,a4
    800066c0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800066c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800066c8:	6698                	ld	a4,8(a3)
    800066ca:	00275783          	lhu	a5,2(a4)
    800066ce:	2785                	addiw	a5,a5,1
    800066d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800066d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800066d8:	100017b7          	lui	a5,0x10001
    800066dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800066e0:	004aa783          	lw	a5,4(s5)
    800066e4:	02c79163          	bne	a5,a2,80006706 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800066e8:	0001f917          	auipc	s2,0x1f
    800066ec:	a4090913          	addi	s2,s2,-1472 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    800066f0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800066f2:	85ca                	mv	a1,s2
    800066f4:	8556                	mv	a0,s5
    800066f6:	ffffc097          	auipc	ra,0xffffc
    800066fa:	e50080e7          	jalr	-432(ra) # 80002546 <sleep>
  while(b->disk == 1) {
    800066fe:	004aa783          	lw	a5,4(s5)
    80006702:	fe9788e3          	beq	a5,s1,800066f2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006706:	f8042903          	lw	s2,-128(s0)
    8000670a:	20090793          	addi	a5,s2,512
    8000670e:	00479713          	slli	a4,a5,0x4
    80006712:	0001d797          	auipc	a5,0x1d
    80006716:	8ee78793          	addi	a5,a5,-1810 # 80023000 <disk>
    8000671a:	97ba                	add	a5,a5,a4
    8000671c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006720:	0001f997          	auipc	s3,0x1f
    80006724:	8e098993          	addi	s3,s3,-1824 # 80025000 <disk+0x2000>
    80006728:	00491713          	slli	a4,s2,0x4
    8000672c:	0009b783          	ld	a5,0(s3)
    80006730:	97ba                	add	a5,a5,a4
    80006732:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006736:	854a                	mv	a0,s2
    80006738:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000673c:	00000097          	auipc	ra,0x0
    80006740:	c5a080e7          	jalr	-934(ra) # 80006396 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006744:	8885                	andi	s1,s1,1
    80006746:	f0ed                	bnez	s1,80006728 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006748:	0001f517          	auipc	a0,0x1f
    8000674c:	9e050513          	addi	a0,a0,-1568 # 80025128 <disk+0x2128>
    80006750:	ffffa097          	auipc	ra,0xffffa
    80006754:	59e080e7          	jalr	1438(ra) # 80000cee <release>
}
    80006758:	70e6                	ld	ra,120(sp)
    8000675a:	7446                	ld	s0,112(sp)
    8000675c:	74a6                	ld	s1,104(sp)
    8000675e:	7906                	ld	s2,96(sp)
    80006760:	69e6                	ld	s3,88(sp)
    80006762:	6a46                	ld	s4,80(sp)
    80006764:	6aa6                	ld	s5,72(sp)
    80006766:	6b06                	ld	s6,64(sp)
    80006768:	7be2                	ld	s7,56(sp)
    8000676a:	7c42                	ld	s8,48(sp)
    8000676c:	7ca2                	ld	s9,40(sp)
    8000676e:	7d02                	ld	s10,32(sp)
    80006770:	6de2                	ld	s11,24(sp)
    80006772:	6109                	addi	sp,sp,128
    80006774:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006776:	f8042503          	lw	a0,-128(s0)
    8000677a:	20050793          	addi	a5,a0,512
    8000677e:	0792                	slli	a5,a5,0x4
  if(write)
    80006780:	0001d817          	auipc	a6,0x1d
    80006784:	88080813          	addi	a6,a6,-1920 # 80023000 <disk>
    80006788:	00f80733          	add	a4,a6,a5
    8000678c:	01a036b3          	snez	a3,s10
    80006790:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006794:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006798:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000679c:	7679                	lui	a2,0xffffe
    8000679e:	963e                	add	a2,a2,a5
    800067a0:	0001f697          	auipc	a3,0x1f
    800067a4:	86068693          	addi	a3,a3,-1952 # 80025000 <disk+0x2000>
    800067a8:	6298                	ld	a4,0(a3)
    800067aa:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800067ac:	0a878593          	addi	a1,a5,168
    800067b0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800067b2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800067b4:	6298                	ld	a4,0(a3)
    800067b6:	9732                	add	a4,a4,a2
    800067b8:	45c1                	li	a1,16
    800067ba:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800067bc:	6298                	ld	a4,0(a3)
    800067be:	9732                	add	a4,a4,a2
    800067c0:	4585                	li	a1,1
    800067c2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800067c6:	f8442703          	lw	a4,-124(s0)
    800067ca:	628c                	ld	a1,0(a3)
    800067cc:	962e                	add	a2,a2,a1
    800067ce:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800067d2:	0712                	slli	a4,a4,0x4
    800067d4:	6290                	ld	a2,0(a3)
    800067d6:	963a                	add	a2,a2,a4
    800067d8:	058a8593          	addi	a1,s5,88
    800067dc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800067de:	6294                	ld	a3,0(a3)
    800067e0:	96ba                	add	a3,a3,a4
    800067e2:	40000613          	li	a2,1024
    800067e6:	c690                	sw	a2,8(a3)
  if(write)
    800067e8:	e40d19e3          	bnez	s10,8000663a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800067ec:	0001f697          	auipc	a3,0x1f
    800067f0:	8146b683          	ld	a3,-2028(a3) # 80025000 <disk+0x2000>
    800067f4:	96ba                	add	a3,a3,a4
    800067f6:	4609                	li	a2,2
    800067f8:	00c69623          	sh	a2,12(a3)
    800067fc:	b5b1                	j	80006648 <virtio_disk_rw+0xd2>

00000000800067fe <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800067fe:	1101                	addi	sp,sp,-32
    80006800:	ec06                	sd	ra,24(sp)
    80006802:	e822                	sd	s0,16(sp)
    80006804:	e426                	sd	s1,8(sp)
    80006806:	e04a                	sd	s2,0(sp)
    80006808:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000680a:	0001f517          	auipc	a0,0x1f
    8000680e:	91e50513          	addi	a0,a0,-1762 # 80025128 <disk+0x2128>
    80006812:	ffffa097          	auipc	ra,0xffffa
    80006816:	428080e7          	jalr	1064(ra) # 80000c3a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000681a:	10001737          	lui	a4,0x10001
    8000681e:	533c                	lw	a5,96(a4)
    80006820:	8b8d                	andi	a5,a5,3
    80006822:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006824:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006828:	0001e797          	auipc	a5,0x1e
    8000682c:	7d878793          	addi	a5,a5,2008 # 80025000 <disk+0x2000>
    80006830:	6b94                	ld	a3,16(a5)
    80006832:	0207d703          	lhu	a4,32(a5)
    80006836:	0026d783          	lhu	a5,2(a3)
    8000683a:	06f70163          	beq	a4,a5,8000689c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000683e:	0001c917          	auipc	s2,0x1c
    80006842:	7c290913          	addi	s2,s2,1986 # 80023000 <disk>
    80006846:	0001e497          	auipc	s1,0x1e
    8000684a:	7ba48493          	addi	s1,s1,1978 # 80025000 <disk+0x2000>
    __sync_synchronize();
    8000684e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006852:	6898                	ld	a4,16(s1)
    80006854:	0204d783          	lhu	a5,32(s1)
    80006858:	8b9d                	andi	a5,a5,7
    8000685a:	078e                	slli	a5,a5,0x3
    8000685c:	97ba                	add	a5,a5,a4
    8000685e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006860:	20078713          	addi	a4,a5,512
    80006864:	0712                	slli	a4,a4,0x4
    80006866:	974a                	add	a4,a4,s2
    80006868:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000686c:	e731                	bnez	a4,800068b8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000686e:	20078793          	addi	a5,a5,512
    80006872:	0792                	slli	a5,a5,0x4
    80006874:	97ca                	add	a5,a5,s2
    80006876:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006878:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000687c:	ffffc097          	auipc	ra,0xffffc
    80006880:	e56080e7          	jalr	-426(ra) # 800026d2 <wakeup>

    disk.used_idx += 1;
    80006884:	0204d783          	lhu	a5,32(s1)
    80006888:	2785                	addiw	a5,a5,1
    8000688a:	17c2                	slli	a5,a5,0x30
    8000688c:	93c1                	srli	a5,a5,0x30
    8000688e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006892:	6898                	ld	a4,16(s1)
    80006894:	00275703          	lhu	a4,2(a4)
    80006898:	faf71be3          	bne	a4,a5,8000684e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000689c:	0001f517          	auipc	a0,0x1f
    800068a0:	88c50513          	addi	a0,a0,-1908 # 80025128 <disk+0x2128>
    800068a4:	ffffa097          	auipc	ra,0xffffa
    800068a8:	44a080e7          	jalr	1098(ra) # 80000cee <release>
}
    800068ac:	60e2                	ld	ra,24(sp)
    800068ae:	6442                	ld	s0,16(sp)
    800068b0:	64a2                	ld	s1,8(sp)
    800068b2:	6902                	ld	s2,0(sp)
    800068b4:	6105                	addi	sp,sp,32
    800068b6:	8082                	ret
      panic("virtio_disk_intr status");
    800068b8:	00002517          	auipc	a0,0x2
    800068bc:	00850513          	addi	a0,a0,8 # 800088c0 <syscalls+0x3c0>
    800068c0:	ffffa097          	auipc	ra,0xffffa
    800068c4:	d0c080e7          	jalr	-756(ra) # 800005cc <panic>
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
