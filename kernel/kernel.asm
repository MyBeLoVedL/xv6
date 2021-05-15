
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
    80000068:	16c78793          	addi	a5,a5,364 # 800061d0 <timervec>
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
    80000122:	7fa080e7          	jalr	2042(ra) # 80002918 <either_copyin>
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
    800001c6:	35c080e7          	jalr	860(ra) # 8000251e <sleep>
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
    80000202:	6c4080e7          	jalr	1732(ra) # 800028c2 <either_copyout>
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
    800002e2:	690080e7          	jalr	1680(ra) # 8000296e <procdump>
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
    80000436:	278080e7          	jalr	632(ra) # 800026aa <wakeup>
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
    800008fa:	db4080e7          	jalr	-588(ra) # 800026aa <wakeup>
    
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
    80000986:	b9c080e7          	jalr	-1124(ra) # 8000251e <sleep>
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
    80000f2e:	b84080e7          	jalr	-1148(ra) # 80002aae <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f32:	00005097          	auipc	ra,0x5
    80000f36:	2de080e7          	jalr	734(ra) # 80006210 <plicinithart>
  }

  scheduler();        
    80000f3a:	00001097          	auipc	ra,0x1
    80000f3e:	3e2080e7          	jalr	994(ra) # 8000231c <scheduler>
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
    80000fa6:	ae4080e7          	jalr	-1308(ra) # 80002a86 <trapinit>
    trapinithart();  // install kernel trap vector
    80000faa:	00002097          	auipc	ra,0x2
    80000fae:	b04080e7          	jalr	-1276(ra) # 80002aae <trapinithart>
    plicinit();      // set up interrupt controller
    80000fb2:	00005097          	auipc	ra,0x5
    80000fb6:	248080e7          	jalr	584(ra) # 800061fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	256080e7          	jalr	598(ra) # 80006210 <plicinithart>
    binit();         // buffer cache
    80000fc2:	00002097          	auipc	ra,0x2
    80000fc6:	3e8080e7          	jalr	1000(ra) # 800033aa <binit>
    iinit();         // inode cache
    80000fca:	00003097          	auipc	ra,0x3
    80000fce:	a78080e7          	jalr	-1416(ra) # 80003a42 <iinit>
    fileinit();      // file table
    80000fd2:	00004097          	auipc	ra,0x4
    80000fd6:	a22080e7          	jalr	-1502(ra) # 800049f4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	358080e7          	jalr	856(ra) # 80006332 <virtio_disk_init>
    userinit();      // first user process
    80000fe2:	00001097          	auipc	ra,0x1
    80000fe6:	00e080e7          	jalr	14(ra) # 80001ff0 <userinit>
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
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
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

  for (p = proc; p < &proc[NPROC]; p++) {
    80001b10:	00010497          	auipc	s1,0x10
    80001b14:	bc048493          	addi	s1,s1,-1088 # 800116d0 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001b18:	8b26                	mv	s6,s1
    80001b1a:	00006a97          	auipc	s5,0x6
    80001b1e:	4e6a8a93          	addi	s5,s5,1254 # 80008000 <etext>
    80001b22:	04000937          	lui	s2,0x4000
    80001b26:	197d                	addi	s2,s2,-1
    80001b28:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b2a:	00016a17          	auipc	s4,0x16
    80001b2e:	fa6a0a13          	addi	s4,s4,-90 # 80017ad0 <tickslock>
    char *pa = kalloc();
    80001b32:	fffff097          	auipc	ra,0xfffff
    80001b36:	018080e7          	jalr	24(ra) # 80000b4a <kalloc>
    80001b3a:	862a                	mv	a2,a0
    if (pa == 0)
    80001b3c:	c131                	beqz	a0,80001b80 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001b3e:	416485b3          	sub	a1,s1,s6
    80001b42:	8591                	srai	a1,a1,0x4
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
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b64:	19048493          	addi	s1,s1,400
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
void procinit(void) {
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
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bd4:	00010497          	auipc	s1,0x10
    80001bd8:	afc48493          	addi	s1,s1,-1284 # 800116d0 <proc>
    initlock(&p->lock, "proc");
    80001bdc:	00006b17          	auipc	s6,0x6
    80001be0:	70cb0b13          	addi	s6,s6,1804 # 800082e8 <digits+0x280>
    p->kstack = KSTACK((int)(p - proc));
    80001be4:	8aa6                	mv	s5,s1
    80001be6:	00006a17          	auipc	s4,0x6
    80001bea:	41aa0a13          	addi	s4,s4,1050 # 80008000 <etext>
    80001bee:	04000937          	lui	s2,0x4000
    80001bf2:	197d                	addi	s2,s2,-1
    80001bf4:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bf6:	00016997          	auipc	s3,0x16
    80001bfa:	eda98993          	addi	s3,s3,-294 # 80017ad0 <tickslock>
    initlock(&p->lock, "proc");
    80001bfe:	85da                	mv	a1,s6
    80001c00:	8526                	mv	a0,s1
    80001c02:	fffff097          	auipc	ra,0xfffff
    80001c06:	fa8080e7          	jalr	-88(ra) # 80000baa <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80001c0a:	415487b3          	sub	a5,s1,s5
    80001c0e:	8791                	srai	a5,a5,0x4
    80001c10:	000a3703          	ld	a4,0(s4)
    80001c14:	02e787b3          	mul	a5,a5,a4
    80001c18:	2785                	addiw	a5,a5,1
    80001c1a:	00d7979b          	slliw	a5,a5,0xd
    80001c1e:	40f907b3          	sub	a5,s2,a5
    80001c22:	e4bc                	sd	a5,72(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001c24:	19048493          	addi	s1,s1,400
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
int cpuid() {
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
struct cpu *mycpu(void) {
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
struct proc *myproc(void) {
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
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
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
    80001cc0:	ca47a783          	lw	a5,-860(a5) # 80008960 <first.1>
    80001cc4:	eb89                	bnez	a5,80001cd6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001cc6:	00001097          	auipc	ra,0x1
    80001cca:	e58080e7          	jalr	-424(ra) # 80002b1e <usertrapret>
}
    80001cce:	60a2                	ld	ra,8(sp)
    80001cd0:	6402                	ld	s0,0(sp)
    80001cd2:	0141                	addi	sp,sp,16
    80001cd4:	8082                	ret
    first = 0;
    80001cd6:	00007797          	auipc	a5,0x7
    80001cda:	c807a523          	sw	zero,-886(a5) # 80008960 <first.1>
    fsinit(ROOTDEV);
    80001cde:	4505                	li	a0,1
    80001ce0:	00002097          	auipc	ra,0x2
    80001ce4:	ce2080e7          	jalr	-798(ra) # 800039c2 <fsinit>
    80001ce8:	bff9                	j	80001cc6 <forkret+0x22>

0000000080001cea <allocpid>:
int allocpid() {
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
    80001d0c:	c5c78793          	addi	a5,a5,-932 # 80008964 <nextpid>
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
pagetable_t proc_pagetable(struct proc *p) {
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
  if (pagetable == 0)
    80001d48:	c121                	beqz	a0,80001d88 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
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
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
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
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
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
static void freeproc(struct proc *p) {
    80001e1e:	1101                	addi	sp,sp,-32
    80001e20:	ec06                	sd	ra,24(sp)
    80001e22:	e822                	sd	s0,16(sp)
    80001e24:	e426                	sd	s1,8(sp)
    80001e26:	1000                	addi	s0,sp,32
    80001e28:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001e2a:	7528                	ld	a0,104(a0)
    80001e2c:	c509                	beqz	a0,80001e36 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	c20080e7          	jalr	-992(ra) # 80000a4e <kfree>
  p->trapframe = 0;
    80001e36:	0604b423          	sd	zero,104(s1)
  if (p->pagetable)
    80001e3a:	6ca8                	ld	a0,88(s1)
    80001e3c:	c511                	beqz	a0,80001e48 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001e3e:	68ac                	ld	a1,80(s1)
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	f8c080e7          	jalr	-116(ra) # 80001dcc <proc_freepagetable>
  if (p->k_pagetable) {
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
    80001e66:	18048023          	sb	zero,384(s1)
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
static struct proc *allocproc(void) {
    80001e84:	1101                	addi	sp,sp,-32
    80001e86:	ec06                	sd	ra,24(sp)
    80001e88:	e822                	sd	s0,16(sp)
    80001e8a:	e426                	sd	s1,8(sp)
    80001e8c:	e04a                	sd	s2,0(sp)
    80001e8e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e90:	00010497          	auipc	s1,0x10
    80001e94:	84048493          	addi	s1,s1,-1984 # 800116d0 <proc>
    80001e98:	00016917          	auipc	s2,0x16
    80001e9c:	c3890913          	addi	s2,s2,-968 # 80017ad0 <tickslock>
    acquire(&p->lock);
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	d98080e7          	jalr	-616(ra) # 80000c3a <acquire>
    if (p->state == UNUSED) {
    80001eaa:	4c9c                	lw	a5,24(s1)
    80001eac:	cf81                	beqz	a5,80001ec4 <allocproc+0x40>
      release(&p->lock);
    80001eae:	8526                	mv	a0,s1
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	e3e080e7          	jalr	-450(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001eb8:	19048493          	addi	s1,s1,400
    80001ebc:	ff2492e3          	bne	s1,s2,80001ea0 <allocproc+0x1c>
  return 0;
    80001ec0:	4481                	li	s1,0
    80001ec2:	a845                	j	80001f72 <allocproc+0xee>
  p->pid = allocpid();
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	e26080e7          	jalr	-474(ra) # 80001cea <allocpid>
    80001ecc:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ece:	4785                	li	a5,1
    80001ed0:	cc9c                	sw	a5,24(s1)
  p->if_alarm = 0;
    80001ed2:	16048423          	sb	zero,360(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	c74080e7          	jalr	-908(ra) # 80000b4a <kalloc>
    80001ede:	892a                	mv	s2,a0
    80001ee0:	f4a8                	sd	a0,104(s1)
    80001ee2:	cd59                	beqz	a0,80001f80 <allocproc+0xfc>
  p->pagetable = proc_pagetable(p);
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	e4a080e7          	jalr	-438(ra) # 80001d30 <proc_pagetable>
    80001eee:	892a                	mv	s2,a0
    80001ef0:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0) {
    80001ef2:	c15d                	beqz	a0,80001f98 <allocproc+0x114>
  p->k_pagetable = kvmmake();
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	2d0080e7          	jalr	720(ra) # 800011c4 <kvmmake>
    80001efc:	892a                	mv	s2,a0
    80001efe:	f0a8                	sd	a0,96(s1)
  if (p->k_pagetable == 0) {
    80001f00:	c945                	beqz	a0,80001fb0 <allocproc+0x12c>
  char *pa = kalloc();
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	c48080e7          	jalr	-952(ra) # 80000b4a <kalloc>
    80001f0a:	862a                	mv	a2,a0
  if (pa == 0)
    80001f0c:	cd55                	beqz	a0,80001fc8 <allocproc+0x144>
  uint64 va = KSTACK((int)(p - proc));
    80001f0e:	0000f797          	auipc	a5,0xf
    80001f12:	7c278793          	addi	a5,a5,1986 # 800116d0 <proc>
    80001f16:	40f487b3          	sub	a5,s1,a5
    80001f1a:	8791                	srai	a5,a5,0x4
    80001f1c:	00006717          	auipc	a4,0x6
    80001f20:	0e473703          	ld	a4,228(a4) # 80008000 <etext>
    80001f24:	02e787b3          	mul	a5,a5,a4
    80001f28:	2785                	addiw	a5,a5,1
    80001f2a:	00d7979b          	slliw	a5,a5,0xd
    80001f2e:	04000937          	lui	s2,0x4000
    80001f32:	197d                	addi	s2,s2,-1
    80001f34:	0932                	slli	s2,s2,0xc
    80001f36:	40f90933          	sub	s2,s2,a5
  kvmmap(p->k_pagetable, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f3a:	4719                	li	a4,6
    80001f3c:	6685                	lui	a3,0x1
    80001f3e:	85ca                	mv	a1,s2
    80001f40:	70a8                	ld	a0,96(s1)
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	252080e7          	jalr	594(ra) # 80001194 <kvmmap>
  p->kstack = va;
    80001f4a:	0524b423          	sd	s2,72(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001f4e:	07000613          	li	a2,112
    80001f52:	4581                	li	a1,0
    80001f54:	07048513          	addi	a0,s1,112
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	dde080e7          	jalr	-546(ra) # 80000d36 <memset>
  p->context.ra = (uint64)forkret;
    80001f60:	00000797          	auipc	a5,0x0
    80001f64:	d4478793          	addi	a5,a5,-700 # 80001ca4 <forkret>
    80001f68:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001f6a:	64bc                	ld	a5,72(s1)
    80001f6c:	6705                	lui	a4,0x1
    80001f6e:	97ba                	add	a5,a5,a4
    80001f70:	fcbc                	sd	a5,120(s1)
}
    80001f72:	8526                	mv	a0,s1
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	64a2                	ld	s1,8(sp)
    80001f7a:	6902                	ld	s2,0(sp)
    80001f7c:	6105                	addi	sp,sp,32
    80001f7e:	8082                	ret
    freeproc(p);
    80001f80:	8526                	mv	a0,s1
    80001f82:	00000097          	auipc	ra,0x0
    80001f86:	e9c080e7          	jalr	-356(ra) # 80001e1e <freeproc>
    release(&p->lock);
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	d62080e7          	jalr	-670(ra) # 80000cee <release>
    return 0;
    80001f94:	84ca                	mv	s1,s2
    80001f96:	bff1                	j	80001f72 <allocproc+0xee>
    freeproc(p);
    80001f98:	8526                	mv	a0,s1
    80001f9a:	00000097          	auipc	ra,0x0
    80001f9e:	e84080e7          	jalr	-380(ra) # 80001e1e <freeproc>
    release(&p->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	d4a080e7          	jalr	-694(ra) # 80000cee <release>
    return 0;
    80001fac:	84ca                	mv	s1,s2
    80001fae:	b7d1                	j	80001f72 <allocproc+0xee>
    freeproc(p);
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	e6c080e7          	jalr	-404(ra) # 80001e1e <freeproc>
    release(&p->lock);
    80001fba:	8526                	mv	a0,s1
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	d32080e7          	jalr	-718(ra) # 80000cee <release>
    return 0;
    80001fc4:	84ca                	mv	s1,s2
    80001fc6:	b775                	j	80001f72 <allocproc+0xee>
    panic("kalloc");
    80001fc8:	00006517          	auipc	a0,0x6
    80001fcc:	30050513          	addi	a0,a0,768 # 800082c8 <digits+0x260>
    80001fd0:	ffffe097          	auipc	ra,0xffffe
    80001fd4:	5fc080e7          	jalr	1532(ra) # 800005cc <panic>

0000000080001fd8 <proc_freekpagetable>:
void proc_freekpagetable(struct proc *p) {
    80001fd8:	1141                	addi	sp,sp,-16
    80001fda:	e406                	sd	ra,8(sp)
    80001fdc:	e022                	sd	s0,0(sp)
    80001fde:	0800                	addi	s0,sp,16
  free_kmapping(p);
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	69e080e7          	jalr	1694(ra) # 8000167e <free_kmapping>
}
    80001fe8:	60a2                	ld	ra,8(sp)
    80001fea:	6402                	ld	s0,0(sp)
    80001fec:	0141                	addi	sp,sp,16
    80001fee:	8082                	ret

0000000080001ff0 <userinit>:
void userinit(void) {
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	e04a                	sd	s2,0(sp)
    80001ffa:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	e88080e7          	jalr	-376(ra) # 80001e84 <allocproc>
    80002004:	84aa                	mv	s1,a0
  initproc = p;
    80002006:	00007797          	auipc	a5,0x7
    8000200a:	02a7b123          	sd	a0,34(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000200e:	03400613          	li	a2,52
    80002012:	00007597          	auipc	a1,0x7
    80002016:	95e58593          	addi	a1,a1,-1698 # 80008970 <initcode>
    8000201a:	6d28                	ld	a0,88(a0)
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	386080e7          	jalr	902(ra) # 800013a2 <uvminit>
  p->sz = PGSIZE;
    80002024:	6905                	lui	s2,0x1
    80002026:	0524b823          	sd	s2,80(s1)
  uvmapping(p->pagetable, p->k_pagetable, 0, p->sz);
    8000202a:	6685                	lui	a3,0x1
    8000202c:	4601                	li	a2,0
    8000202e:	70ac                	ld	a1,96(s1)
    80002030:	6ca8                	ld	a0,88(s1)
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	3e2080e7          	jalr	994(ra) # 80001414 <uvmapping>
  p->trapframe->epc = 0;     // user program counter
    8000203a:	74bc                	ld	a5,104(s1)
    8000203c:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE; // user stack pointer
    80002040:	74bc                	ld	a5,104(s1)
    80002042:	0327b823          	sd	s2,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002046:	4641                	li	a2,16
    80002048:	00006597          	auipc	a1,0x6
    8000204c:	2a858593          	addi	a1,a1,680 # 800082f0 <digits+0x288>
    80002050:	18048513          	addi	a0,s1,384
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	e34080e7          	jalr	-460(ra) # 80000e88 <safestrcpy>
  p->cwd = namei("/");
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	2a450513          	addi	a0,a0,676 # 80008300 <digits+0x298>
    80002064:	00002097          	auipc	ra,0x2
    80002068:	38c080e7          	jalr	908(ra) # 800043f0 <namei>
    8000206c:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80002070:	478d                	li	a5,3
    80002072:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002074:	8526                	mv	a0,s1
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	c78080e7          	jalr	-904(ra) # 80000cee <release>
}
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	64a2                	ld	s1,8(sp)
    80002084:	6902                	ld	s2,0(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret

000000008000208a <growproc>:
int growproc(int n) {
    8000208a:	7139                	addi	sp,sp,-64
    8000208c:	fc06                	sd	ra,56(sp)
    8000208e:	f822                	sd	s0,48(sp)
    80002090:	f426                	sd	s1,40(sp)
    80002092:	f04a                	sd	s2,32(sp)
    80002094:	ec4e                	sd	s3,24(sp)
    80002096:	e852                	sd	s4,16(sp)
    80002098:	e456                	sd	s5,8(sp)
    8000209a:	0080                	addi	s0,sp,64
    8000209c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	bce080e7          	jalr	-1074(ra) # 80001c6c <myproc>
    800020a6:	892a                	mv	s2,a0
  sz = p->sz;
    800020a8:	05053a03          	ld	s4,80(a0)
    800020ac:	000a0a9b          	sext.w	s5,s4
  if (n > 0) {
    800020b0:	04904363          	bgtz	s1,800020f6 <growproc+0x6c>
  sz = p->sz;
    800020b4:	89d6                	mv	s3,s5
  } else if (n < 0) {
    800020b6:	0604c263          	bltz	s1,8000211a <growproc+0x90>
  uvmapping(p->pagetable, p->k_pagetable, oldsz, oldsz + n);
    800020ba:	015486bb          	addw	a3,s1,s5
    800020be:	1682                	slli	a3,a3,0x20
    800020c0:	9281                	srli	a3,a3,0x20
    800020c2:	020a1613          	slli	a2,s4,0x20
    800020c6:	9201                	srli	a2,a2,0x20
    800020c8:	06093583          	ld	a1,96(s2) # 1060 <_entry-0x7fffefa0>
    800020cc:	05893503          	ld	a0,88(s2)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	344080e7          	jalr	836(ra) # 80001414 <uvmapping>
  p->sz = sz;
    800020d8:	1982                	slli	s3,s3,0x20
    800020da:	0209d993          	srli	s3,s3,0x20
    800020de:	05393823          	sd	s3,80(s2)
  return 0;
    800020e2:	4501                	li	a0,0
}
    800020e4:	70e2                	ld	ra,56(sp)
    800020e6:	7442                	ld	s0,48(sp)
    800020e8:	74a2                	ld	s1,40(sp)
    800020ea:	7902                	ld	s2,32(sp)
    800020ec:	69e2                	ld	s3,24(sp)
    800020ee:	6a42                	ld	s4,16(sp)
    800020f0:	6aa2                	ld	s5,8(sp)
    800020f2:	6121                	addi	sp,sp,64
    800020f4:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800020f6:	0154863b          	addw	a2,s1,s5
    800020fa:	1602                	slli	a2,a2,0x20
    800020fc:	9201                	srli	a2,a2,0x20
    800020fe:	020a1593          	slli	a1,s4,0x20
    80002102:	9181                	srli	a1,a1,0x20
    80002104:	6d28                	ld	a0,88(a0)
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	3fc080e7          	jalr	1020(ra) # 80001502 <uvmalloc>
    8000210e:	0005099b          	sext.w	s3,a0
    80002112:	fa0994e3          	bnez	s3,800020ba <growproc+0x30>
      return -1;
    80002116:	557d                	li	a0,-1
    80002118:	b7f1                	j	800020e4 <growproc+0x5a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000211a:	0154863b          	addw	a2,s1,s5
    8000211e:	1602                	slli	a2,a2,0x20
    80002120:	9201                	srli	a2,a2,0x20
    80002122:	020a1593          	slli	a1,s4,0x20
    80002126:	9181                	srli	a1,a1,0x20
    80002128:	6d28                	ld	a0,88(a0)
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	390080e7          	jalr	912(ra) # 800014ba <uvmdealloc>
    80002132:	0005099b          	sext.w	s3,a0
    80002136:	b751                	j	800020ba <growproc+0x30>

0000000080002138 <trace>:
i32 trace(i32 traced) {
    80002138:	1101                	addi	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	e426                	sd	s1,8(sp)
    80002140:	1000                	addi	s0,sp,32
    80002142:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002144:	00000097          	auipc	ra,0x0
    80002148:	b28080e7          	jalr	-1240(ra) # 80001c6c <myproc>
  p->traced |= traced;
    8000214c:	413c                	lw	a5,64(a0)
    8000214e:	8cdd                	or	s1,s1,a5
    80002150:	c124                	sw	s1,64(a0)
}
    80002152:	4501                	li	a0,0
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6105                	addi	sp,sp,32
    8000215c:	8082                	ret

000000008000215e <alarm>:
u64 alarm(i32 tick, void *handler) {
    8000215e:	1101                	addi	sp,sp,-32
    80002160:	ec06                	sd	ra,24(sp)
    80002162:	e822                	sd	s0,16(sp)
    80002164:	e426                	sd	s1,8(sp)
    80002166:	e04a                	sd	s2,0(sp)
    80002168:	1000                	addi	s0,sp,32
    8000216a:	84aa                	mv	s1,a0
    8000216c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	afe080e7          	jalr	-1282(ra) # 80001c6c <myproc>
  p->if_alarm = (tick != 0);
    80002176:	009037b3          	snez	a5,s1
    8000217a:	16f50423          	sb	a5,360(a0)
  p->tick = tick;
    8000217e:	0004879b          	sext.w	a5,s1
    80002182:	16f52623          	sw	a5,364(a0)
  p->tick_left = tick;
    80002186:	16f52823          	sw	a5,368(a0)
  p->handler = handler;
    8000218a:	17253c23          	sd	s2,376(a0)
}
    8000218e:	8526                	mv	a0,s1
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	64a2                	ld	s1,8(sp)
    80002196:	6902                	ld	s2,0(sp)
    80002198:	6105                	addi	sp,sp,32
    8000219a:	8082                	ret

000000008000219c <fork>:
int fork(void) {
    8000219c:	7139                	addi	sp,sp,-64
    8000219e:	fc06                	sd	ra,56(sp)
    800021a0:	f822                	sd	s0,48(sp)
    800021a2:	f426                	sd	s1,40(sp)
    800021a4:	f04a                	sd	s2,32(sp)
    800021a6:	ec4e                	sd	s3,24(sp)
    800021a8:	e852                	sd	s4,16(sp)
    800021aa:	e456                	sd	s5,8(sp)
    800021ac:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	abe080e7          	jalr	-1346(ra) # 80001c6c <myproc>
    800021b6:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	ccc080e7          	jalr	-820(ra) # 80001e84 <allocproc>
    800021c0:	14050c63          	beqz	a0,80002318 <fork+0x17c>
    800021c4:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800021c6:	050ab603          	ld	a2,80(s5)
    800021ca:	6d2c                	ld	a1,88(a0)
    800021cc:	058ab503          	ld	a0,88(s5)
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	588080e7          	jalr	1416(ra) # 80001758 <uvmcopy>
    800021d8:	08054063          	bltz	a0,80002258 <fork+0xbc>
  uvmapping(np->pagetable, np->k_pagetable, 0, p->sz);
    800021dc:	050ab683          	ld	a3,80(s5)
    800021e0:	4601                	li	a2,0
    800021e2:	0609b583          	ld	a1,96(s3)
    800021e6:	0589b503          	ld	a0,88(s3)
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	22a080e7          	jalr	554(ra) # 80001414 <uvmapping>
  if ((pte = walk(np->k_pagetable, 0, 0)) == 0) {
    800021f2:	4601                	li	a2,0
    800021f4:	4581                	li	a1,0
    800021f6:	0609b503          	ld	a0,96(s3)
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	e24080e7          	jalr	-476(ra) # 8000101e <walk>
    80002202:	c53d                	beqz	a0,80002270 <fork+0xd4>
  np->sz = p->sz;
    80002204:	050ab783          	ld	a5,80(s5)
    80002208:	04f9b823          	sd	a5,80(s3)
  np->traced = p->traced;
    8000220c:	040aa783          	lw	a5,64(s5)
    80002210:	04f9a023          	sw	a5,64(s3)
  *(np->trapframe) = *(p->trapframe);
    80002214:	068ab683          	ld	a3,104(s5)
    80002218:	87b6                	mv	a5,a3
    8000221a:	0689b703          	ld	a4,104(s3)
    8000221e:	12068693          	addi	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    80002222:	0007b803          	ld	a6,0(a5)
    80002226:	6788                	ld	a0,8(a5)
    80002228:	6b8c                	ld	a1,16(a5)
    8000222a:	6f90                	ld	a2,24(a5)
    8000222c:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80002230:	e708                	sd	a0,8(a4)
    80002232:	eb0c                	sd	a1,16(a4)
    80002234:	ef10                	sd	a2,24(a4)
    80002236:	02078793          	addi	a5,a5,32
    8000223a:	02070713          	addi	a4,a4,32
    8000223e:	fed792e3          	bne	a5,a3,80002222 <fork+0x86>
  np->trapframe->a0 = 0;
    80002242:	0689b783          	ld	a5,104(s3)
    80002246:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000224a:	0e0a8493          	addi	s1,s5,224
    8000224e:	0e098913          	addi	s2,s3,224
    80002252:	160a8a13          	addi	s4,s5,352
    80002256:	a83d                	j	80002294 <fork+0xf8>
    freeproc(np);
    80002258:	854e                	mv	a0,s3
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	bc4080e7          	jalr	-1084(ra) # 80001e1e <freeproc>
    release(&np->lock);
    80002262:	854e                	mv	a0,s3
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	a8a080e7          	jalr	-1398(ra) # 80000cee <release>
    return -1;
    8000226c:	597d                	li	s2,-1
    8000226e:	a859                	j	80002304 <fork+0x168>
    panic("not valid k table");
    80002270:	00006517          	auipc	a0,0x6
    80002274:	09850513          	addi	a0,a0,152 # 80008308 <digits+0x2a0>
    80002278:	ffffe097          	auipc	ra,0xffffe
    8000227c:	354080e7          	jalr	852(ra) # 800005cc <panic>
      np->ofile[i] = filedup(p->ofile[i]);
    80002280:	00003097          	auipc	ra,0x3
    80002284:	806080e7          	jalr	-2042(ra) # 80004a86 <filedup>
    80002288:	00a93023          	sd	a0,0(s2)
  for (i = 0; i < NOFILE; i++)
    8000228c:	04a1                	addi	s1,s1,8
    8000228e:	0921                	addi	s2,s2,8
    80002290:	01448563          	beq	s1,s4,8000229a <fork+0xfe>
    if (p->ofile[i])
    80002294:	6088                	ld	a0,0(s1)
    80002296:	f56d                	bnez	a0,80002280 <fork+0xe4>
    80002298:	bfd5                	j	8000228c <fork+0xf0>
  np->cwd = idup(p->cwd);
    8000229a:	160ab503          	ld	a0,352(s5)
    8000229e:	00002097          	auipc	ra,0x2
    800022a2:	95e080e7          	jalr	-1698(ra) # 80003bfc <idup>
    800022a6:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800022aa:	4641                	li	a2,16
    800022ac:	180a8593          	addi	a1,s5,384
    800022b0:	18098513          	addi	a0,s3,384
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	bd4080e7          	jalr	-1068(ra) # 80000e88 <safestrcpy>
  pid = np->pid;
    800022bc:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800022c0:	854e                	mv	a0,s3
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	a2c080e7          	jalr	-1492(ra) # 80000cee <release>
  acquire(&wait_lock);
    800022ca:	0000f497          	auipc	s1,0xf
    800022ce:	fee48493          	addi	s1,s1,-18 # 800112b8 <wait_lock>
    800022d2:	8526                	mv	a0,s1
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	966080e7          	jalr	-1690(ra) # 80000c3a <acquire>
  np->parent = p;
    800022dc:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800022e0:	8526                	mv	a0,s1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	a0c080e7          	jalr	-1524(ra) # 80000cee <release>
  acquire(&np->lock);
    800022ea:	854e                	mv	a0,s3
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	94e080e7          	jalr	-1714(ra) # 80000c3a <acquire>
  np->state = RUNNABLE;
    800022f4:	478d                	li	a5,3
    800022f6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800022fa:	854e                	mv	a0,s3
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	9f2080e7          	jalr	-1550(ra) # 80000cee <release>
}
    80002304:	854a                	mv	a0,s2
    80002306:	70e2                	ld	ra,56(sp)
    80002308:	7442                	ld	s0,48(sp)
    8000230a:	74a2                	ld	s1,40(sp)
    8000230c:	7902                	ld	s2,32(sp)
    8000230e:	69e2                	ld	s3,24(sp)
    80002310:	6a42                	ld	s4,16(sp)
    80002312:	6aa2                	ld	s5,8(sp)
    80002314:	6121                	addi	sp,sp,64
    80002316:	8082                	ret
    return -1;
    80002318:	597d                	li	s2,-1
    8000231a:	b7ed                	j	80002304 <fork+0x168>

000000008000231c <scheduler>:
void scheduler(void) {
    8000231c:	715d                	addi	sp,sp,-80
    8000231e:	e486                	sd	ra,72(sp)
    80002320:	e0a2                	sd	s0,64(sp)
    80002322:	fc26                	sd	s1,56(sp)
    80002324:	f84a                	sd	s2,48(sp)
    80002326:	f44e                	sd	s3,40(sp)
    80002328:	f052                	sd	s4,32(sp)
    8000232a:	ec56                	sd	s5,24(sp)
    8000232c:	e85a                	sd	s6,16(sp)
    8000232e:	e45e                	sd	s7,8(sp)
    80002330:	e062                	sd	s8,0(sp)
    80002332:	0880                	addi	s0,sp,80
    80002334:	8792                	mv	a5,tp
  int id = r_tp();
    80002336:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002338:	00779c13          	slli	s8,a5,0x7
    8000233c:	0000f717          	auipc	a4,0xf
    80002340:	f6470713          	addi	a4,a4,-156 # 800112a0 <pid_lock>
    80002344:	9762                	add	a4,a4,s8
    80002346:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000234a:	0000f717          	auipc	a4,0xf
    8000234e:	f8e70713          	addi	a4,a4,-114 # 800112d8 <cpus+0x8>
    80002352:	9c3a                	add	s8,s8,a4
        w_satp(MAKE_SATP(kernel_pagetable));
    80002354:	00007b17          	auipc	s6,0x7
    80002358:	cccb0b13          	addi	s6,s6,-820 # 80009020 <kernel_pagetable>
    8000235c:	5afd                	li	s5,-1
    8000235e:	1afe                	slli	s5,s5,0x3f
        c->proc = p;
    80002360:	079e                	slli	a5,a5,0x7
    80002362:	0000fb97          	auipc	s7,0xf
    80002366:	f3eb8b93          	addi	s7,s7,-194 # 800112a0 <pid_lock>
    8000236a:	9bbe                	add	s7,s7,a5
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000236c:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002370:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002374:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002378:	4a01                	li	s4,0
    for (p = proc; p < &proc[NPROC]; p++) {
    8000237a:	0000f497          	auipc	s1,0xf
    8000237e:	35648493          	addi	s1,s1,854 # 800116d0 <proc>
      if (p->state == RUNNABLE) {
    80002382:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80002384:	00015917          	auipc	s2,0x15
    80002388:	74c90913          	addi	s2,s2,1868 # 80017ad0 <tickslock>
    8000238c:	a085                	j	800023ec <scheduler+0xd0>
        p->state = RUNNING;
    8000238e:	4791                	li	a5,4
    80002390:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    80002392:	029bb823          	sd	s1,48(s7)
        w_satp(MAKE_SATP(p->k_pagetable));
    80002396:	70bc                	ld	a5,96(s1)
    80002398:	83b1                	srli	a5,a5,0xc
    8000239a:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    8000239e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800023a2:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    800023a6:	07048593          	addi	a1,s1,112
    800023aa:	8562                	mv	a0,s8
    800023ac:	00000097          	auipc	ra,0x0
    800023b0:	670080e7          	jalr	1648(ra) # 80002a1c <swtch>
        c->proc = 0;
    800023b4:	020bb823          	sd	zero,48(s7)
      release(&p->lock);
    800023b8:	8526                	mv	a0,s1
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	934080e7          	jalr	-1740(ra) # 80000cee <release>
        found = 1;
    800023c2:	4a05                	li	s4,1
    800023c4:	a005                	j	800023e4 <scheduler+0xc8>
        w_satp(MAKE_SATP(kernel_pagetable));
    800023c6:	000b3783          	ld	a5,0(s6)
    800023ca:	83b1                	srli	a5,a5,0xc
    800023cc:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    800023d0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800023d4:	12000073          	sfence.vma
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800023d8:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800023dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800023e0:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    800023e4:	19048493          	addi	s1,s1,400
    800023e8:	f92482e3          	beq	s1,s2,8000236c <scheduler+0x50>
      acquire(&p->lock);
    800023ec:	8526                	mv	a0,s1
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	84c080e7          	jalr	-1972(ra) # 80000c3a <acquire>
      if (p->state == RUNNABLE) {
    800023f6:	4c9c                	lw	a5,24(s1)
    800023f8:	f9378be3          	beq	a5,s3,8000238e <scheduler+0x72>
      release(&p->lock);
    800023fc:	8526                	mv	a0,s1
    800023fe:	fffff097          	auipc	ra,0xfffff
    80002402:	8f0080e7          	jalr	-1808(ra) # 80000cee <release>
      if (!found) {
    80002406:	fc0a00e3          	beqz	s4,800023c6 <scheduler+0xaa>
    8000240a:	bfe9                	j	800023e4 <scheduler+0xc8>

000000008000240c <sched>:
void sched(void) {
    8000240c:	7179                	addi	sp,sp,-48
    8000240e:	f406                	sd	ra,40(sp)
    80002410:	f022                	sd	s0,32(sp)
    80002412:	ec26                	sd	s1,24(sp)
    80002414:	e84a                	sd	s2,16(sp)
    80002416:	e44e                	sd	s3,8(sp)
    80002418:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000241a:	00000097          	auipc	ra,0x0
    8000241e:	852080e7          	jalr	-1966(ra) # 80001c6c <myproc>
    80002422:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002424:	ffffe097          	auipc	ra,0xffffe
    80002428:	79c080e7          	jalr	1948(ra) # 80000bc0 <holding>
    8000242c:	c93d                	beqz	a0,800024a2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    8000242e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002430:	2781                	sext.w	a5,a5
    80002432:	079e                	slli	a5,a5,0x7
    80002434:	0000f717          	auipc	a4,0xf
    80002438:	e6c70713          	addi	a4,a4,-404 # 800112a0 <pid_lock>
    8000243c:	97ba                	add	a5,a5,a4
    8000243e:	0a87a703          	lw	a4,168(a5)
    80002442:	4785                	li	a5,1
    80002444:	06f71763          	bne	a4,a5,800024b2 <sched+0xa6>
  if (p->state == RUNNING)
    80002448:	4c98                	lw	a4,24(s1)
    8000244a:	4791                	li	a5,4
    8000244c:	06f70b63          	beq	a4,a5,800024c2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002450:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002454:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002456:	efb5                	bnez	a5,800024d2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80002458:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000245a:	0000f917          	auipc	s2,0xf
    8000245e:	e4690913          	addi	s2,s2,-442 # 800112a0 <pid_lock>
    80002462:	2781                	sext.w	a5,a5
    80002464:	079e                	slli	a5,a5,0x7
    80002466:	97ca                	add	a5,a5,s2
    80002468:	0ac7a983          	lw	s3,172(a5)
    8000246c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000246e:	2781                	sext.w	a5,a5
    80002470:	079e                	slli	a5,a5,0x7
    80002472:	0000f597          	auipc	a1,0xf
    80002476:	e6658593          	addi	a1,a1,-410 # 800112d8 <cpus+0x8>
    8000247a:	95be                	add	a1,a1,a5
    8000247c:	07048513          	addi	a0,s1,112
    80002480:	00000097          	auipc	ra,0x0
    80002484:	59c080e7          	jalr	1436(ra) # 80002a1c <swtch>
    80002488:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000248a:	2781                	sext.w	a5,a5
    8000248c:	079e                	slli	a5,a5,0x7
    8000248e:	97ca                	add	a5,a5,s2
    80002490:	0b37a623          	sw	s3,172(a5)
}
    80002494:	70a2                	ld	ra,40(sp)
    80002496:	7402                	ld	s0,32(sp)
    80002498:	64e2                	ld	s1,24(sp)
    8000249a:	6942                	ld	s2,16(sp)
    8000249c:	69a2                	ld	s3,8(sp)
    8000249e:	6145                	addi	sp,sp,48
    800024a0:	8082                	ret
    panic("sched p->lock");
    800024a2:	00006517          	auipc	a0,0x6
    800024a6:	e7e50513          	addi	a0,a0,-386 # 80008320 <digits+0x2b8>
    800024aa:	ffffe097          	auipc	ra,0xffffe
    800024ae:	122080e7          	jalr	290(ra) # 800005cc <panic>
    panic("sched locks");
    800024b2:	00006517          	auipc	a0,0x6
    800024b6:	e7e50513          	addi	a0,a0,-386 # 80008330 <digits+0x2c8>
    800024ba:	ffffe097          	auipc	ra,0xffffe
    800024be:	112080e7          	jalr	274(ra) # 800005cc <panic>
    panic("sched running");
    800024c2:	00006517          	auipc	a0,0x6
    800024c6:	e7e50513          	addi	a0,a0,-386 # 80008340 <digits+0x2d8>
    800024ca:	ffffe097          	auipc	ra,0xffffe
    800024ce:	102080e7          	jalr	258(ra) # 800005cc <panic>
    panic("sched interruptible");
    800024d2:	00006517          	auipc	a0,0x6
    800024d6:	e7e50513          	addi	a0,a0,-386 # 80008350 <digits+0x2e8>
    800024da:	ffffe097          	auipc	ra,0xffffe
    800024de:	0f2080e7          	jalr	242(ra) # 800005cc <panic>

00000000800024e2 <yield>:
void yield(void) {
    800024e2:	1101                	addi	sp,sp,-32
    800024e4:	ec06                	sd	ra,24(sp)
    800024e6:	e822                	sd	s0,16(sp)
    800024e8:	e426                	sd	s1,8(sp)
    800024ea:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800024ec:	fffff097          	auipc	ra,0xfffff
    800024f0:	780080e7          	jalr	1920(ra) # 80001c6c <myproc>
    800024f4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800024f6:	ffffe097          	auipc	ra,0xffffe
    800024fa:	744080e7          	jalr	1860(ra) # 80000c3a <acquire>
  p->state = RUNNABLE;
    800024fe:	478d                	li	a5,3
    80002500:	cc9c                	sw	a5,24(s1)
  sched();
    80002502:	00000097          	auipc	ra,0x0
    80002506:	f0a080e7          	jalr	-246(ra) # 8000240c <sched>
  release(&p->lock);
    8000250a:	8526                	mv	a0,s1
    8000250c:	ffffe097          	auipc	ra,0xffffe
    80002510:	7e2080e7          	jalr	2018(ra) # 80000cee <release>
}
    80002514:	60e2                	ld	ra,24(sp)
    80002516:	6442                	ld	s0,16(sp)
    80002518:	64a2                	ld	s1,8(sp)
    8000251a:	6105                	addi	sp,sp,32
    8000251c:	8082                	ret

000000008000251e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    8000251e:	7179                	addi	sp,sp,-48
    80002520:	f406                	sd	ra,40(sp)
    80002522:	f022                	sd	s0,32(sp)
    80002524:	ec26                	sd	s1,24(sp)
    80002526:	e84a                	sd	s2,16(sp)
    80002528:	e44e                	sd	s3,8(sp)
    8000252a:	1800                	addi	s0,sp,48
    8000252c:	89aa                	mv	s3,a0
    8000252e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	73c080e7          	jalr	1852(ra) # 80001c6c <myproc>
    80002538:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000253a:	ffffe097          	auipc	ra,0xffffe
    8000253e:	700080e7          	jalr	1792(ra) # 80000c3a <acquire>
  release(lk);
    80002542:	854a                	mv	a0,s2
    80002544:	ffffe097          	auipc	ra,0xffffe
    80002548:	7aa080e7          	jalr	1962(ra) # 80000cee <release>

  // Go to sleep.
  p->chan = chan;
    8000254c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002550:	4789                	li	a5,2
    80002552:	cc9c                	sw	a5,24(s1)

  sched();
    80002554:	00000097          	auipc	ra,0x0
    80002558:	eb8080e7          	jalr	-328(ra) # 8000240c <sched>

  // Tidy up.
  p->chan = 0;
    8000255c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002560:	8526                	mv	a0,s1
    80002562:	ffffe097          	auipc	ra,0xffffe
    80002566:	78c080e7          	jalr	1932(ra) # 80000cee <release>
  acquire(lk);
    8000256a:	854a                	mv	a0,s2
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	6ce080e7          	jalr	1742(ra) # 80000c3a <acquire>
}
    80002574:	70a2                	ld	ra,40(sp)
    80002576:	7402                	ld	s0,32(sp)
    80002578:	64e2                	ld	s1,24(sp)
    8000257a:	6942                	ld	s2,16(sp)
    8000257c:	69a2                	ld	s3,8(sp)
    8000257e:	6145                	addi	sp,sp,48
    80002580:	8082                	ret

0000000080002582 <wait>:
int wait(uint64 addr) {
    80002582:	715d                	addi	sp,sp,-80
    80002584:	e486                	sd	ra,72(sp)
    80002586:	e0a2                	sd	s0,64(sp)
    80002588:	fc26                	sd	s1,56(sp)
    8000258a:	f84a                	sd	s2,48(sp)
    8000258c:	f44e                	sd	s3,40(sp)
    8000258e:	f052                	sd	s4,32(sp)
    80002590:	ec56                	sd	s5,24(sp)
    80002592:	e85a                	sd	s6,16(sp)
    80002594:	e45e                	sd	s7,8(sp)
    80002596:	e062                	sd	s8,0(sp)
    80002598:	0880                	addi	s0,sp,80
    8000259a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000259c:	fffff097          	auipc	ra,0xfffff
    800025a0:	6d0080e7          	jalr	1744(ra) # 80001c6c <myproc>
    800025a4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800025a6:	0000f517          	auipc	a0,0xf
    800025aa:	d1250513          	addi	a0,a0,-750 # 800112b8 <wait_lock>
    800025ae:	ffffe097          	auipc	ra,0xffffe
    800025b2:	68c080e7          	jalr	1676(ra) # 80000c3a <acquire>
    havekids = 0;
    800025b6:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    800025b8:	4a15                	li	s4,5
        havekids = 1;
    800025ba:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    800025bc:	00015997          	auipc	s3,0x15
    800025c0:	51498993          	addi	s3,s3,1300 # 80017ad0 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800025c4:	0000fc17          	auipc	s8,0xf
    800025c8:	cf4c0c13          	addi	s8,s8,-780 # 800112b8 <wait_lock>
    havekids = 0;
    800025cc:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    800025ce:	0000f497          	auipc	s1,0xf
    800025d2:	10248493          	addi	s1,s1,258 # 800116d0 <proc>
    800025d6:	a0bd                	j	80002644 <wait+0xc2>
          pid = np->pid;
    800025d8:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800025dc:	000b0e63          	beqz	s6,800025f8 <wait+0x76>
    800025e0:	4691                	li	a3,4
    800025e2:	02c48613          	addi	a2,s1,44
    800025e6:	85da                	mv	a1,s6
    800025e8:	05893503          	ld	a0,88(s2)
    800025ec:	fffff097          	auipc	ra,0xfffff
    800025f0:	270080e7          	jalr	624(ra) # 8000185c <copyout>
    800025f4:	02054563          	bltz	a0,8000261e <wait+0x9c>
          freeproc(np);
    800025f8:	8526                	mv	a0,s1
    800025fa:	00000097          	auipc	ra,0x0
    800025fe:	824080e7          	jalr	-2012(ra) # 80001e1e <freeproc>
          release(&np->lock);
    80002602:	8526                	mv	a0,s1
    80002604:	ffffe097          	auipc	ra,0xffffe
    80002608:	6ea080e7          	jalr	1770(ra) # 80000cee <release>
          release(&wait_lock);
    8000260c:	0000f517          	auipc	a0,0xf
    80002610:	cac50513          	addi	a0,a0,-852 # 800112b8 <wait_lock>
    80002614:	ffffe097          	auipc	ra,0xffffe
    80002618:	6da080e7          	jalr	1754(ra) # 80000cee <release>
          return pid;
    8000261c:	a09d                	j	80002682 <wait+0x100>
            release(&np->lock);
    8000261e:	8526                	mv	a0,s1
    80002620:	ffffe097          	auipc	ra,0xffffe
    80002624:	6ce080e7          	jalr	1742(ra) # 80000cee <release>
            release(&wait_lock);
    80002628:	0000f517          	auipc	a0,0xf
    8000262c:	c9050513          	addi	a0,a0,-880 # 800112b8 <wait_lock>
    80002630:	ffffe097          	auipc	ra,0xffffe
    80002634:	6be080e7          	jalr	1726(ra) # 80000cee <release>
            return -1;
    80002638:	59fd                	li	s3,-1
    8000263a:	a0a1                	j	80002682 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++) {
    8000263c:	19048493          	addi	s1,s1,400
    80002640:	03348463          	beq	s1,s3,80002668 <wait+0xe6>
      if (np->parent == p) {
    80002644:	7c9c                	ld	a5,56(s1)
    80002646:	ff279be3          	bne	a5,s2,8000263c <wait+0xba>
        acquire(&np->lock);
    8000264a:	8526                	mv	a0,s1
    8000264c:	ffffe097          	auipc	ra,0xffffe
    80002650:	5ee080e7          	jalr	1518(ra) # 80000c3a <acquire>
        if (np->state == ZOMBIE) {
    80002654:	4c9c                	lw	a5,24(s1)
    80002656:	f94781e3          	beq	a5,s4,800025d8 <wait+0x56>
        release(&np->lock);
    8000265a:	8526                	mv	a0,s1
    8000265c:	ffffe097          	auipc	ra,0xffffe
    80002660:	692080e7          	jalr	1682(ra) # 80000cee <release>
        havekids = 1;
    80002664:	8756                	mv	a4,s5
    80002666:	bfd9                	j	8000263c <wait+0xba>
    if (!havekids || p->killed) {
    80002668:	c701                	beqz	a4,80002670 <wait+0xee>
    8000266a:	02892783          	lw	a5,40(s2)
    8000266e:	c79d                	beqz	a5,8000269c <wait+0x11a>
      release(&wait_lock);
    80002670:	0000f517          	auipc	a0,0xf
    80002674:	c4850513          	addi	a0,a0,-952 # 800112b8 <wait_lock>
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	676080e7          	jalr	1654(ra) # 80000cee <release>
      return -1;
    80002680:	59fd                	li	s3,-1
}
    80002682:	854e                	mv	a0,s3
    80002684:	60a6                	ld	ra,72(sp)
    80002686:	6406                	ld	s0,64(sp)
    80002688:	74e2                	ld	s1,56(sp)
    8000268a:	7942                	ld	s2,48(sp)
    8000268c:	79a2                	ld	s3,40(sp)
    8000268e:	7a02                	ld	s4,32(sp)
    80002690:	6ae2                	ld	s5,24(sp)
    80002692:	6b42                	ld	s6,16(sp)
    80002694:	6ba2                	ld	s7,8(sp)
    80002696:	6c02                	ld	s8,0(sp)
    80002698:	6161                	addi	sp,sp,80
    8000269a:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000269c:	85e2                	mv	a1,s8
    8000269e:	854a                	mv	a0,s2
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	e7e080e7          	jalr	-386(ra) # 8000251e <sleep>
    havekids = 0;
    800026a8:	b715                	j	800025cc <wait+0x4a>

00000000800026aa <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    800026aa:	7139                	addi	sp,sp,-64
    800026ac:	fc06                	sd	ra,56(sp)
    800026ae:	f822                	sd	s0,48(sp)
    800026b0:	f426                	sd	s1,40(sp)
    800026b2:	f04a                	sd	s2,32(sp)
    800026b4:	ec4e                	sd	s3,24(sp)
    800026b6:	e852                	sd	s4,16(sp)
    800026b8:	e456                	sd	s5,8(sp)
    800026ba:	0080                	addi	s0,sp,64
    800026bc:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800026be:	0000f497          	auipc	s1,0xf
    800026c2:	01248493          	addi	s1,s1,18 # 800116d0 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    800026c6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800026c8:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800026ca:	00015917          	auipc	s2,0x15
    800026ce:	40690913          	addi	s2,s2,1030 # 80017ad0 <tickslock>
    800026d2:	a811                	j	800026e6 <wakeup+0x3c>
      }
      release(&p->lock);
    800026d4:	8526                	mv	a0,s1
    800026d6:	ffffe097          	auipc	ra,0xffffe
    800026da:	618080e7          	jalr	1560(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800026de:	19048493          	addi	s1,s1,400
    800026e2:	03248663          	beq	s1,s2,8000270e <wakeup+0x64>
    if (p != myproc()) {
    800026e6:	fffff097          	auipc	ra,0xfffff
    800026ea:	586080e7          	jalr	1414(ra) # 80001c6c <myproc>
    800026ee:	fea488e3          	beq	s1,a0,800026de <wakeup+0x34>
      acquire(&p->lock);
    800026f2:	8526                	mv	a0,s1
    800026f4:	ffffe097          	auipc	ra,0xffffe
    800026f8:	546080e7          	jalr	1350(ra) # 80000c3a <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800026fc:	4c9c                	lw	a5,24(s1)
    800026fe:	fd379be3          	bne	a5,s3,800026d4 <wakeup+0x2a>
    80002702:	709c                	ld	a5,32(s1)
    80002704:	fd4798e3          	bne	a5,s4,800026d4 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002708:	0154ac23          	sw	s5,24(s1)
    8000270c:	b7e1                	j	800026d4 <wakeup+0x2a>
    }
  }
}
    8000270e:	70e2                	ld	ra,56(sp)
    80002710:	7442                	ld	s0,48(sp)
    80002712:	74a2                	ld	s1,40(sp)
    80002714:	7902                	ld	s2,32(sp)
    80002716:	69e2                	ld	s3,24(sp)
    80002718:	6a42                	ld	s4,16(sp)
    8000271a:	6aa2                	ld	s5,8(sp)
    8000271c:	6121                	addi	sp,sp,64
    8000271e:	8082                	ret

0000000080002720 <reparent>:
void reparent(struct proc *p) {
    80002720:	7179                	addi	sp,sp,-48
    80002722:	f406                	sd	ra,40(sp)
    80002724:	f022                	sd	s0,32(sp)
    80002726:	ec26                	sd	s1,24(sp)
    80002728:	e84a                	sd	s2,16(sp)
    8000272a:	e44e                	sd	s3,8(sp)
    8000272c:	e052                	sd	s4,0(sp)
    8000272e:	1800                	addi	s0,sp,48
    80002730:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002732:	0000f497          	auipc	s1,0xf
    80002736:	f9e48493          	addi	s1,s1,-98 # 800116d0 <proc>
      pp->parent = initproc;
    8000273a:	00007a17          	auipc	s4,0x7
    8000273e:	8eea0a13          	addi	s4,s4,-1810 # 80009028 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002742:	00015997          	auipc	s3,0x15
    80002746:	38e98993          	addi	s3,s3,910 # 80017ad0 <tickslock>
    8000274a:	a029                	j	80002754 <reparent+0x34>
    8000274c:	19048493          	addi	s1,s1,400
    80002750:	01348d63          	beq	s1,s3,8000276a <reparent+0x4a>
    if (pp->parent == p) {
    80002754:	7c9c                	ld	a5,56(s1)
    80002756:	ff279be3          	bne	a5,s2,8000274c <reparent+0x2c>
      pp->parent = initproc;
    8000275a:	000a3503          	ld	a0,0(s4)
    8000275e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002760:	00000097          	auipc	ra,0x0
    80002764:	f4a080e7          	jalr	-182(ra) # 800026aa <wakeup>
    80002768:	b7d5                	j	8000274c <reparent+0x2c>
}
    8000276a:	70a2                	ld	ra,40(sp)
    8000276c:	7402                	ld	s0,32(sp)
    8000276e:	64e2                	ld	s1,24(sp)
    80002770:	6942                	ld	s2,16(sp)
    80002772:	69a2                	ld	s3,8(sp)
    80002774:	6a02                	ld	s4,0(sp)
    80002776:	6145                	addi	sp,sp,48
    80002778:	8082                	ret

000000008000277a <exit>:
void exit(int status) {
    8000277a:	7179                	addi	sp,sp,-48
    8000277c:	f406                	sd	ra,40(sp)
    8000277e:	f022                	sd	s0,32(sp)
    80002780:	ec26                	sd	s1,24(sp)
    80002782:	e84a                	sd	s2,16(sp)
    80002784:	e44e                	sd	s3,8(sp)
    80002786:	e052                	sd	s4,0(sp)
    80002788:	1800                	addi	s0,sp,48
    8000278a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000278c:	fffff097          	auipc	ra,0xfffff
    80002790:	4e0080e7          	jalr	1248(ra) # 80001c6c <myproc>
    80002794:	89aa                	mv	s3,a0
  if (p == initproc)
    80002796:	00007797          	auipc	a5,0x7
    8000279a:	8927b783          	ld	a5,-1902(a5) # 80009028 <initproc>
    8000279e:	0e050493          	addi	s1,a0,224
    800027a2:	16050913          	addi	s2,a0,352
    800027a6:	02a79363          	bne	a5,a0,800027cc <exit+0x52>
    panic("init exiting");
    800027aa:	00006517          	auipc	a0,0x6
    800027ae:	bbe50513          	addi	a0,a0,-1090 # 80008368 <digits+0x300>
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	e1a080e7          	jalr	-486(ra) # 800005cc <panic>
      fileclose(f);
    800027ba:	00002097          	auipc	ra,0x2
    800027be:	31e080e7          	jalr	798(ra) # 80004ad8 <fileclose>
      p->ofile[fd] = 0;
    800027c2:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800027c6:	04a1                	addi	s1,s1,8
    800027c8:	01248563          	beq	s1,s2,800027d2 <exit+0x58>
    if (p->ofile[fd]) {
    800027cc:	6088                	ld	a0,0(s1)
    800027ce:	f575                	bnez	a0,800027ba <exit+0x40>
    800027d0:	bfdd                	j	800027c6 <exit+0x4c>
  begin_op();
    800027d2:	00002097          	auipc	ra,0x2
    800027d6:	e3a080e7          	jalr	-454(ra) # 8000460c <begin_op>
  iput(p->cwd);
    800027da:	1609b503          	ld	a0,352(s3)
    800027de:	00001097          	auipc	ra,0x1
    800027e2:	616080e7          	jalr	1558(ra) # 80003df4 <iput>
  end_op();
    800027e6:	00002097          	auipc	ra,0x2
    800027ea:	ea6080e7          	jalr	-346(ra) # 8000468c <end_op>
  p->cwd = 0;
    800027ee:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    800027f2:	0000f497          	auipc	s1,0xf
    800027f6:	ac648493          	addi	s1,s1,-1338 # 800112b8 <wait_lock>
    800027fa:	8526                	mv	a0,s1
    800027fc:	ffffe097          	auipc	ra,0xffffe
    80002800:	43e080e7          	jalr	1086(ra) # 80000c3a <acquire>
  reparent(p);
    80002804:	854e                	mv	a0,s3
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	f1a080e7          	jalr	-230(ra) # 80002720 <reparent>
  wakeup(p->parent);
    8000280e:	0389b503          	ld	a0,56(s3)
    80002812:	00000097          	auipc	ra,0x0
    80002816:	e98080e7          	jalr	-360(ra) # 800026aa <wakeup>
  acquire(&p->lock);
    8000281a:	854e                	mv	a0,s3
    8000281c:	ffffe097          	auipc	ra,0xffffe
    80002820:	41e080e7          	jalr	1054(ra) # 80000c3a <acquire>
  p->xstate = status;
    80002824:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002828:	4795                	li	a5,5
    8000282a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000282e:	8526                	mv	a0,s1
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	4be080e7          	jalr	1214(ra) # 80000cee <release>
  sched();
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	bd4080e7          	jalr	-1068(ra) # 8000240c <sched>
  panic("zombie exit");
    80002840:	00006517          	auipc	a0,0x6
    80002844:	b3850513          	addi	a0,a0,-1224 # 80008378 <digits+0x310>
    80002848:	ffffe097          	auipc	ra,0xffffe
    8000284c:	d84080e7          	jalr	-636(ra) # 800005cc <panic>

0000000080002850 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80002850:	7179                	addi	sp,sp,-48
    80002852:	f406                	sd	ra,40(sp)
    80002854:	f022                	sd	s0,32(sp)
    80002856:	ec26                	sd	s1,24(sp)
    80002858:	e84a                	sd	s2,16(sp)
    8000285a:	e44e                	sd	s3,8(sp)
    8000285c:	1800                	addi	s0,sp,48
    8000285e:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002860:	0000f497          	auipc	s1,0xf
    80002864:	e7048493          	addi	s1,s1,-400 # 800116d0 <proc>
    80002868:	00015997          	auipc	s3,0x15
    8000286c:	26898993          	addi	s3,s3,616 # 80017ad0 <tickslock>
    acquire(&p->lock);
    80002870:	8526                	mv	a0,s1
    80002872:	ffffe097          	auipc	ra,0xffffe
    80002876:	3c8080e7          	jalr	968(ra) # 80000c3a <acquire>
    if (p->pid == pid) {
    8000287a:	589c                	lw	a5,48(s1)
    8000287c:	01278d63          	beq	a5,s2,80002896 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002880:	8526                	mv	a0,s1
    80002882:	ffffe097          	auipc	ra,0xffffe
    80002886:	46c080e7          	jalr	1132(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000288a:	19048493          	addi	s1,s1,400
    8000288e:	ff3491e3          	bne	s1,s3,80002870 <kill+0x20>
  }
  return -1;
    80002892:	557d                	li	a0,-1
    80002894:	a829                	j	800028ae <kill+0x5e>
      p->killed = 1;
    80002896:	4785                	li	a5,1
    80002898:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    8000289a:	4c98                	lw	a4,24(s1)
    8000289c:	4789                	li	a5,2
    8000289e:	00f70f63          	beq	a4,a5,800028bc <kill+0x6c>
      release(&p->lock);
    800028a2:	8526                	mv	a0,s1
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	44a080e7          	jalr	1098(ra) # 80000cee <release>
      return 0;
    800028ac:	4501                	li	a0,0
}
    800028ae:	70a2                	ld	ra,40(sp)
    800028b0:	7402                	ld	s0,32(sp)
    800028b2:	64e2                	ld	s1,24(sp)
    800028b4:	6942                	ld	s2,16(sp)
    800028b6:	69a2                	ld	s3,8(sp)
    800028b8:	6145                	addi	sp,sp,48
    800028ba:	8082                	ret
        p->state = RUNNABLE;
    800028bc:	478d                	li	a5,3
    800028be:	cc9c                	sw	a5,24(s1)
    800028c0:	b7cd                	j	800028a2 <kill+0x52>

00000000800028c2 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800028c2:	7179                	addi	sp,sp,-48
    800028c4:	f406                	sd	ra,40(sp)
    800028c6:	f022                	sd	s0,32(sp)
    800028c8:	ec26                	sd	s1,24(sp)
    800028ca:	e84a                	sd	s2,16(sp)
    800028cc:	e44e                	sd	s3,8(sp)
    800028ce:	e052                	sd	s4,0(sp)
    800028d0:	1800                	addi	s0,sp,48
    800028d2:	84aa                	mv	s1,a0
    800028d4:	892e                	mv	s2,a1
    800028d6:	89b2                	mv	s3,a2
    800028d8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028da:	fffff097          	auipc	ra,0xfffff
    800028de:	392080e7          	jalr	914(ra) # 80001c6c <myproc>
  if (user_dst) {
    800028e2:	c08d                	beqz	s1,80002904 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800028e4:	86d2                	mv	a3,s4
    800028e6:	864e                	mv	a2,s3
    800028e8:	85ca                	mv	a1,s2
    800028ea:	6d28                	ld	a0,88(a0)
    800028ec:	fffff097          	auipc	ra,0xfffff
    800028f0:	f70080e7          	jalr	-144(ra) # 8000185c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028f4:	70a2                	ld	ra,40(sp)
    800028f6:	7402                	ld	s0,32(sp)
    800028f8:	64e2                	ld	s1,24(sp)
    800028fa:	6942                	ld	s2,16(sp)
    800028fc:	69a2                	ld	s3,8(sp)
    800028fe:	6a02                	ld	s4,0(sp)
    80002900:	6145                	addi	sp,sp,48
    80002902:	8082                	ret
    memmove((char *)dst, src, len);
    80002904:	000a061b          	sext.w	a2,s4
    80002908:	85ce                	mv	a1,s3
    8000290a:	854a                	mv	a0,s2
    8000290c:	ffffe097          	auipc	ra,0xffffe
    80002910:	486080e7          	jalr	1158(ra) # 80000d92 <memmove>
    return 0;
    80002914:	8526                	mv	a0,s1
    80002916:	bff9                	j	800028f4 <either_copyout+0x32>

0000000080002918 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80002918:	7179                	addi	sp,sp,-48
    8000291a:	f406                	sd	ra,40(sp)
    8000291c:	f022                	sd	s0,32(sp)
    8000291e:	ec26                	sd	s1,24(sp)
    80002920:	e84a                	sd	s2,16(sp)
    80002922:	e44e                	sd	s3,8(sp)
    80002924:	e052                	sd	s4,0(sp)
    80002926:	1800                	addi	s0,sp,48
    80002928:	892a                	mv	s2,a0
    8000292a:	84ae                	mv	s1,a1
    8000292c:	89b2                	mv	s3,a2
    8000292e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002930:	fffff097          	auipc	ra,0xfffff
    80002934:	33c080e7          	jalr	828(ra) # 80001c6c <myproc>
  if (user_src) {
    80002938:	c08d                	beqz	s1,8000295a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000293a:	86d2                	mv	a3,s4
    8000293c:	864e                	mv	a2,s3
    8000293e:	85ca                	mv	a1,s2
    80002940:	6d28                	ld	a0,88(a0)
    80002942:	fffff097          	auipc	ra,0xfffff
    80002946:	020080e7          	jalr	32(ra) # 80001962 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000294a:	70a2                	ld	ra,40(sp)
    8000294c:	7402                	ld	s0,32(sp)
    8000294e:	64e2                	ld	s1,24(sp)
    80002950:	6942                	ld	s2,16(sp)
    80002952:	69a2                	ld	s3,8(sp)
    80002954:	6a02                	ld	s4,0(sp)
    80002956:	6145                	addi	sp,sp,48
    80002958:	8082                	ret
    memmove(dst, (char *)src, len);
    8000295a:	000a061b          	sext.w	a2,s4
    8000295e:	85ce                	mv	a1,s3
    80002960:	854a                	mv	a0,s2
    80002962:	ffffe097          	auipc	ra,0xffffe
    80002966:	430080e7          	jalr	1072(ra) # 80000d92 <memmove>
    return 0;
    8000296a:	8526                	mv	a0,s1
    8000296c:	bff9                	j	8000294a <either_copyin+0x32>

000000008000296e <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    8000296e:	715d                	addi	sp,sp,-80
    80002970:	e486                	sd	ra,72(sp)
    80002972:	e0a2                	sd	s0,64(sp)
    80002974:	fc26                	sd	s1,56(sp)
    80002976:	f84a                	sd	s2,48(sp)
    80002978:	f44e                	sd	s3,40(sp)
    8000297a:	f052                	sd	s4,32(sp)
    8000297c:	ec56                	sd	s5,24(sp)
    8000297e:	e85a                	sd	s6,16(sp)
    80002980:	e45e                	sd	s7,8(sp)
    80002982:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002984:	00005517          	auipc	a0,0x5
    80002988:	76c50513          	addi	a0,a0,1900 # 800080f0 <digits+0x88>
    8000298c:	ffffe097          	auipc	ra,0xffffe
    80002990:	c92080e7          	jalr	-878(ra) # 8000061e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002994:	0000f497          	auipc	s1,0xf
    80002998:	ebc48493          	addi	s1,s1,-324 # 80011850 <proc+0x180>
    8000299c:	00015917          	auipc	s2,0x15
    800029a0:	2b490913          	addi	s2,s2,692 # 80017c50 <bcache+0x48>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029a4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800029a6:	00006997          	auipc	s3,0x6
    800029aa:	9e298993          	addi	s3,s3,-1566 # 80008388 <digits+0x320>
    printf("%d %s %s", p->pid, state, p->name);
    800029ae:	00006a97          	auipc	s5,0x6
    800029b2:	9e2a8a93          	addi	s5,s5,-1566 # 80008390 <digits+0x328>
    printf("\n");
    800029b6:	00005a17          	auipc	s4,0x5
    800029ba:	73aa0a13          	addi	s4,s4,1850 # 800080f0 <digits+0x88>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029be:	00006b97          	auipc	s7,0x6
    800029c2:	a0ab8b93          	addi	s7,s7,-1526 # 800083c8 <states.0>
    800029c6:	a00d                	j	800029e8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800029c8:	eb06a583          	lw	a1,-336(a3)
    800029cc:	8556                	mv	a0,s5
    800029ce:	ffffe097          	auipc	ra,0xffffe
    800029d2:	c50080e7          	jalr	-944(ra) # 8000061e <printf>
    printf("\n");
    800029d6:	8552                	mv	a0,s4
    800029d8:	ffffe097          	auipc	ra,0xffffe
    800029dc:	c46080e7          	jalr	-954(ra) # 8000061e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029e0:	19048493          	addi	s1,s1,400
    800029e4:	03248163          	beq	s1,s2,80002a06 <procdump+0x98>
    if (p->state == UNUSED)
    800029e8:	86a6                	mv	a3,s1
    800029ea:	e984a783          	lw	a5,-360(s1)
    800029ee:	dbed                	beqz	a5,800029e0 <procdump+0x72>
      state = "???";
    800029f0:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029f2:	fcfb6be3          	bltu	s6,a5,800029c8 <procdump+0x5a>
    800029f6:	1782                	slli	a5,a5,0x20
    800029f8:	9381                	srli	a5,a5,0x20
    800029fa:	078e                	slli	a5,a5,0x3
    800029fc:	97de                	add	a5,a5,s7
    800029fe:	6390                	ld	a2,0(a5)
    80002a00:	f661                	bnez	a2,800029c8 <procdump+0x5a>
      state = "???";
    80002a02:	864e                	mv	a2,s3
    80002a04:	b7d1                	j	800029c8 <procdump+0x5a>
  }
}
    80002a06:	60a6                	ld	ra,72(sp)
    80002a08:	6406                	ld	s0,64(sp)
    80002a0a:	74e2                	ld	s1,56(sp)
    80002a0c:	7942                	ld	s2,48(sp)
    80002a0e:	79a2                	ld	s3,40(sp)
    80002a10:	7a02                	ld	s4,32(sp)
    80002a12:	6ae2                	ld	s5,24(sp)
    80002a14:	6b42                	ld	s6,16(sp)
    80002a16:	6ba2                	ld	s7,8(sp)
    80002a18:	6161                	addi	sp,sp,80
    80002a1a:	8082                	ret

0000000080002a1c <swtch>:
    80002a1c:	00153023          	sd	ra,0(a0)
    80002a20:	00253423          	sd	sp,8(a0)
    80002a24:	e900                	sd	s0,16(a0)
    80002a26:	ed04                	sd	s1,24(a0)
    80002a28:	03253023          	sd	s2,32(a0)
    80002a2c:	03353423          	sd	s3,40(a0)
    80002a30:	03453823          	sd	s4,48(a0)
    80002a34:	03553c23          	sd	s5,56(a0)
    80002a38:	05653023          	sd	s6,64(a0)
    80002a3c:	05753423          	sd	s7,72(a0)
    80002a40:	05853823          	sd	s8,80(a0)
    80002a44:	05953c23          	sd	s9,88(a0)
    80002a48:	07a53023          	sd	s10,96(a0)
    80002a4c:	07b53423          	sd	s11,104(a0)
    80002a50:	0005b083          	ld	ra,0(a1)
    80002a54:	0085b103          	ld	sp,8(a1)
    80002a58:	6980                	ld	s0,16(a1)
    80002a5a:	6d84                	ld	s1,24(a1)
    80002a5c:	0205b903          	ld	s2,32(a1)
    80002a60:	0285b983          	ld	s3,40(a1)
    80002a64:	0305ba03          	ld	s4,48(a1)
    80002a68:	0385ba83          	ld	s5,56(a1)
    80002a6c:	0405bb03          	ld	s6,64(a1)
    80002a70:	0485bb83          	ld	s7,72(a1)
    80002a74:	0505bc03          	ld	s8,80(a1)
    80002a78:	0585bc83          	ld	s9,88(a1)
    80002a7c:	0605bd03          	ld	s10,96(a1)
    80002a80:	0685bd83          	ld	s11,104(a1)
    80002a84:	8082                	ret

0000000080002a86 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002a86:	1141                	addi	sp,sp,-16
    80002a88:	e406                	sd	ra,8(sp)
    80002a8a:	e022                	sd	s0,0(sp)
    80002a8c:	0800                	addi	s0,sp,16
    80002a8e:	00006597          	auipc	a1,0x6
    80002a92:	96a58593          	addi	a1,a1,-1686 # 800083f8 <states.0+0x30>
    80002a96:	00015517          	auipc	a0,0x15
    80002a9a:	03a50513          	addi	a0,a0,58 # 80017ad0 <tickslock>
    80002a9e:	ffffe097          	auipc	ra,0xffffe
    80002aa2:	10c080e7          	jalr	268(ra) # 80000baa <initlock>
    80002aa6:	60a2                	ld	ra,8(sp)
    80002aa8:	6402                	ld	s0,0(sp)
    80002aaa:	0141                	addi	sp,sp,16
    80002aac:	8082                	ret

0000000080002aae <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002aae:	1141                	addi	sp,sp,-16
    80002ab0:	e422                	sd	s0,8(sp)
    80002ab2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002ab4:	00003797          	auipc	a5,0x3
    80002ab8:	68c78793          	addi	a5,a5,1676 # 80006140 <kernelvec>
    80002abc:	10579073          	csrw	stvec,a5
    80002ac0:	6422                	ld	s0,8(sp)
    80002ac2:	0141                	addi	sp,sp,16
    80002ac4:	8082                	ret

0000000080002ac6 <info_reg>:
//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//

void info_reg() {
    80002ac6:	1141                	addi	sp,sp,-16
    80002ac8:	e406                	sd	ra,8(sp)
    80002aca:	e022                	sd	s0,0(sp)
    80002acc:	0800                	addi	s0,sp,16
  uint64 x;
  asm volatile("mv %0, ra" : "=r"(x));
    80002ace:	8586                	mv	a1,ra
  printf("ra:%p\n", x);
    80002ad0:	00006517          	auipc	a0,0x6
    80002ad4:	93050513          	addi	a0,a0,-1744 # 80008400 <states.0+0x38>
    80002ad8:	ffffe097          	auipc	ra,0xffffe
    80002adc:	b46080e7          	jalr	-1210(ra) # 8000061e <printf>
  asm volatile("mv %0, sp" : "=r"(x));
    80002ae0:	858a                	mv	a1,sp
  printf("sp:%p\n", x);
    80002ae2:	00006517          	auipc	a0,0x6
    80002ae6:	92650513          	addi	a0,a0,-1754 # 80008408 <states.0+0x40>
    80002aea:	ffffe097          	auipc	ra,0xffffe
    80002aee:	b34080e7          	jalr	-1228(ra) # 8000061e <printf>
  asm volatile("mv %0, gp" : "=r"(x));
    80002af2:	858e                	mv	a1,gp
  printf("gp:%p\n", x);
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	91c50513          	addi	a0,a0,-1764 # 80008410 <states.0+0x48>
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	b22080e7          	jalr	-1246(ra) # 8000061e <printf>
  asm volatile("mv %0, tp" : "=r"(x));
    80002b04:	8592                	mv	a1,tp
  printf("tp:%p\n", x);
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	91250513          	addi	a0,a0,-1774 # 80008418 <states.0+0x50>
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	b10080e7          	jalr	-1264(ra) # 8000061e <printf>
}
    80002b16:	60a2                	ld	ra,8(sp)
    80002b18:	6402                	ld	s0,0(sp)
    80002b1a:	0141                	addi	sp,sp,16
    80002b1c:	8082                	ret

0000000080002b1e <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002b1e:	1141                	addi	sp,sp,-16
    80002b20:	e406                	sd	ra,8(sp)
    80002b22:	e022                	sd	s0,0(sp)
    80002b24:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	146080e7          	jalr	326(ra) # 80001c6c <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b2e:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002b32:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b34:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002b38:	00004617          	auipc	a2,0x4
    80002b3c:	4c860613          	addi	a2,a2,1224 # 80007000 <_trampoline>
    80002b40:	00004697          	auipc	a3,0x4
    80002b44:	4c068693          	addi	a3,a3,1216 # 80007000 <_trampoline>
    80002b48:	8e91                	sub	a3,a3,a2
    80002b4a:	040007b7          	lui	a5,0x4000
    80002b4e:	17fd                	addi	a5,a5,-1
    80002b50:	07b2                	slli	a5,a5,0xc
    80002b52:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002b54:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b58:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002b5a:	180026f3          	csrr	a3,satp
    80002b5e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b60:	7538                	ld	a4,104(a0)
    80002b62:	6534                	ld	a3,72(a0)
    80002b64:	6585                	lui	a1,0x1
    80002b66:	96ae                	add	a3,a3,a1
    80002b68:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b6a:	7538                	ld	a4,104(a0)
    80002b6c:	00000697          	auipc	a3,0x0
    80002b70:	13868693          	addi	a3,a3,312 # 80002ca4 <usertrap>
    80002b74:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002b76:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002b78:	8692                	mv	a3,tp
    80002b7a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b7c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b80:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b84:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b88:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b8c:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002b8e:	6f18                	ld	a4,24(a4)
    80002b90:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b94:	6d2c                	ld	a1,88(a0)
    80002b96:	81b1                	srli	a1,a1,0xc
  // and switches to user mode with sret.

  // * function calls ,or more generally,program executions is just about
  // * change pc from one place to another,accompany with putting arguments
  // * in stack or registers
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002b98:	00004717          	auipc	a4,0x4
    80002b9c:	4f870713          	addi	a4,a4,1272 # 80007090 <userret>
    80002ba0:	8f11                	sub	a4,a4,a2
    80002ba2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002ba4:	577d                	li	a4,-1
    80002ba6:	177e                	slli	a4,a4,0x3f
    80002ba8:	8dd9                	or	a1,a1,a4
    80002baa:	02000537          	lui	a0,0x2000
    80002bae:	157d                	addi	a0,a0,-1
    80002bb0:	0536                	slli	a0,a0,0xd
    80002bb2:	9782                	jalr	a5
}
    80002bb4:	60a2                	ld	ra,8(sp)
    80002bb6:	6402                	ld	s0,0(sp)
    80002bb8:	0141                	addi	sp,sp,16
    80002bba:	8082                	ret

0000000080002bbc <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002bbc:	1101                	addi	sp,sp,-32
    80002bbe:	ec06                	sd	ra,24(sp)
    80002bc0:	e822                	sd	s0,16(sp)
    80002bc2:	e426                	sd	s1,8(sp)
    80002bc4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002bc6:	00015497          	auipc	s1,0x15
    80002bca:	f0a48493          	addi	s1,s1,-246 # 80017ad0 <tickslock>
    80002bce:	8526                	mv	a0,s1
    80002bd0:	ffffe097          	auipc	ra,0xffffe
    80002bd4:	06a080e7          	jalr	106(ra) # 80000c3a <acquire>
  ticks++;
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	45c50513          	addi	a0,a0,1116 # 80009034 <ticks>
    80002be0:	411c                	lw	a5,0(a0)
    80002be2:	2785                	addiw	a5,a5,1
    80002be4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002be6:	00000097          	auipc	ra,0x0
    80002bea:	ac4080e7          	jalr	-1340(ra) # 800026aa <wakeup>
  release(&tickslock);
    80002bee:	8526                	mv	a0,s1
    80002bf0:	ffffe097          	auipc	ra,0xffffe
    80002bf4:	0fe080e7          	jalr	254(ra) # 80000cee <release>
}
    80002bf8:	60e2                	ld	ra,24(sp)
    80002bfa:	6442                	ld	s0,16(sp)
    80002bfc:	64a2                	ld	s1,8(sp)
    80002bfe:	6105                	addi	sp,sp,32
    80002c00:	8082                	ret

0000000080002c02 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002c02:	1101                	addi	sp,sp,-32
    80002c04:	ec06                	sd	ra,24(sp)
    80002c06:	e822                	sd	s0,16(sp)
    80002c08:	e426                	sd	s1,8(sp)
    80002c0a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c0c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002c10:	00074d63          	bltz	a4,80002c2a <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002c14:	57fd                	li	a5,-1
    80002c16:	17fe                	slli	a5,a5,0x3f
    80002c18:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c1a:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002c1c:	06f70363          	beq	a4,a5,80002c82 <devintr+0x80>
  }
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002c2a:	0ff77793          	andi	a5,a4,255
    80002c2e:	46a5                	li	a3,9
    80002c30:	fed792e3          	bne	a5,a3,80002c14 <devintr+0x12>
    int irq = plic_claim();
    80002c34:	00003097          	auipc	ra,0x3
    80002c38:	614080e7          	jalr	1556(ra) # 80006248 <plic_claim>
    80002c3c:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002c3e:	47a9                	li	a5,10
    80002c40:	02f50763          	beq	a0,a5,80002c6e <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002c44:	4785                	li	a5,1
    80002c46:	02f50963          	beq	a0,a5,80002c78 <devintr+0x76>
    return 1;
    80002c4a:	4505                	li	a0,1
    } else if (irq) {
    80002c4c:	d8f1                	beqz	s1,80002c20 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c4e:	85a6                	mv	a1,s1
    80002c50:	00005517          	auipc	a0,0x5
    80002c54:	7d050513          	addi	a0,a0,2000 # 80008420 <states.0+0x58>
    80002c58:	ffffe097          	auipc	ra,0xffffe
    80002c5c:	9c6080e7          	jalr	-1594(ra) # 8000061e <printf>
      plic_complete(irq);
    80002c60:	8526                	mv	a0,s1
    80002c62:	00003097          	auipc	ra,0x3
    80002c66:	60a080e7          	jalr	1546(ra) # 8000626c <plic_complete>
    return 1;
    80002c6a:	4505                	li	a0,1
    80002c6c:	bf55                	j	80002c20 <devintr+0x1e>
      uartintr();
    80002c6e:	ffffe097          	auipc	ra,0xffffe
    80002c72:	d90080e7          	jalr	-624(ra) # 800009fe <uartintr>
    80002c76:	b7ed                	j	80002c60 <devintr+0x5e>
      virtio_disk_intr();
    80002c78:	00004097          	auipc	ra,0x4
    80002c7c:	a86080e7          	jalr	-1402(ra) # 800066fe <virtio_disk_intr>
    80002c80:	b7c5                	j	80002c60 <devintr+0x5e>
    if (cpuid() == 0) {
    80002c82:	fffff097          	auipc	ra,0xfffff
    80002c86:	fbe080e7          	jalr	-66(ra) # 80001c40 <cpuid>
    80002c8a:	c901                	beqz	a0,80002c9a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002c8c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c90:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002c92:	14479073          	csrw	sip,a5
    return 2;
    80002c96:	4509                	li	a0,2
    80002c98:	b761                	j	80002c20 <devintr+0x1e>
      clockintr();
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	f22080e7          	jalr	-222(ra) # 80002bbc <clockintr>
    80002ca2:	b7ed                	j	80002c8c <devintr+0x8a>

0000000080002ca4 <usertrap>:
void usertrap(void) {
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	e04a                	sd	s2,0(sp)
    80002cae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002cb0:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002cb4:	1007f793          	andi	a5,a5,256
    80002cb8:	e3ad                	bnez	a5,80002d1a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002cba:	00003797          	auipc	a5,0x3
    80002cbe:	48678793          	addi	a5,a5,1158 # 80006140 <kernelvec>
    80002cc2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002cc6:	fffff097          	auipc	ra,0xfffff
    80002cca:	fa6080e7          	jalr	-90(ra) # 80001c6c <myproc>
    80002cce:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002cd0:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002cd2:	14102773          	csrr	a4,sepc
    80002cd6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002cd8:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002cdc:	47a1                	li	a5,8
    80002cde:	04f71c63          	bne	a4,a5,80002d36 <usertrap+0x92>
    if (p->killed)
    80002ce2:	551c                	lw	a5,40(a0)
    80002ce4:	e3b9                	bnez	a5,80002d2a <usertrap+0x86>
    p->trapframe->epc += 4;
    80002ce6:	74b8                	ld	a4,104(s1)
    80002ce8:	6f1c                	ld	a5,24(a4)
    80002cea:	0791                	addi	a5,a5,4
    80002cec:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002cee:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002cf2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002cf6:	10079073          	csrw	sstatus,a5
    syscall();
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	340080e7          	jalr	832(ra) # 8000303a <syscall>
  if (p->killed)
    80002d02:	549c                	lw	a5,40(s1)
    80002d04:	ebc5                	bnez	a5,80002db4 <usertrap+0x110>
  usertrapret();
    80002d06:	00000097          	auipc	ra,0x0
    80002d0a:	e18080e7          	jalr	-488(ra) # 80002b1e <usertrapret>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6902                	ld	s2,0(sp)
    80002d16:	6105                	addi	sp,sp,32
    80002d18:	8082                	ret
    panic("usertrap: not from user mode");
    80002d1a:	00005517          	auipc	a0,0x5
    80002d1e:	72650513          	addi	a0,a0,1830 # 80008440 <states.0+0x78>
    80002d22:	ffffe097          	auipc	ra,0xffffe
    80002d26:	8aa080e7          	jalr	-1878(ra) # 800005cc <panic>
      exit(-1);
    80002d2a:	557d                	li	a0,-1
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	a4e080e7          	jalr	-1458(ra) # 8000277a <exit>
    80002d34:	bf4d                	j	80002ce6 <usertrap+0x42>
  } else if ((which_dev = devintr()) != 0) {
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	ecc080e7          	jalr	-308(ra) # 80002c02 <devintr>
    80002d3e:	892a                	mv	s2,a0
    80002d40:	c501                	beqz	a0,80002d48 <usertrap+0xa4>
  if (p->killed)
    80002d42:	549c                	lw	a5,40(s1)
    80002d44:	c3a1                	beqz	a5,80002d84 <usertrap+0xe0>
    80002d46:	a815                	j	80002d7a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d48:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002d4c:	5890                	lw	a2,48(s1)
    80002d4e:	00005517          	auipc	a0,0x5
    80002d52:	71250513          	addi	a0,a0,1810 # 80008460 <states.0+0x98>
    80002d56:	ffffe097          	auipc	ra,0xffffe
    80002d5a:	8c8080e7          	jalr	-1848(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002d5e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d62:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d66:	00005517          	auipc	a0,0x5
    80002d6a:	72a50513          	addi	a0,a0,1834 # 80008490 <states.0+0xc8>
    80002d6e:	ffffe097          	auipc	ra,0xffffe
    80002d72:	8b0080e7          	jalr	-1872(ra) # 8000061e <printf>
    p->killed = 1;
    80002d76:	4785                	li	a5,1
    80002d78:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002d7a:	557d                	li	a0,-1
    80002d7c:	00000097          	auipc	ra,0x0
    80002d80:	9fe080e7          	jalr	-1538(ra) # 8000277a <exit>
  if (which_dev == 2) {
    80002d84:	4789                	li	a5,2
    80002d86:	f8f910e3          	bne	s2,a5,80002d06 <usertrap+0x62>
    if (p->if_alarm) {
    80002d8a:	1684c783          	lbu	a5,360(s1)
    80002d8e:	cf91                	beqz	a5,80002daa <usertrap+0x106>
      p->tick_left -= 1;
    80002d90:	1704a783          	lw	a5,368(s1)
    80002d94:	37fd                	addiw	a5,a5,-1
    80002d96:	0007871b          	sext.w	a4,a5
    80002d9a:	16f4a823          	sw	a5,368(s1)
      if (p->tick_left == 0 && !re_en) {
    80002d9e:	e711                	bnez	a4,80002daa <usertrap+0x106>
    80002da0:	00006797          	auipc	a5,0x6
    80002da4:	2907c783          	lbu	a5,656(a5) # 80009030 <re_en>
    80002da8:	cb81                	beqz	a5,80002db8 <usertrap+0x114>
    yield();
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	738080e7          	jalr	1848(ra) # 800024e2 <yield>
    80002db2:	bf91                	j	80002d06 <usertrap+0x62>
  int which_dev = 0;
    80002db4:	4901                	li	s2,0
    80002db6:	b7d1                	j	80002d7a <usertrap+0xd6>
        memmove(&handler_frame, p->trapframe, sizeof(handler_frame));
    80002db8:	12000613          	li	a2,288
    80002dbc:	74ac                	ld	a1,104(s1)
    80002dbe:	00015517          	auipc	a0,0x15
    80002dc2:	d2a50513          	addi	a0,a0,-726 # 80017ae8 <handler_frame>
    80002dc6:	ffffe097          	auipc	ra,0xffffe
    80002dca:	fcc080e7          	jalr	-52(ra) # 80000d92 <memmove>
        p->tick_left = p->tick;
    80002dce:	16c4a783          	lw	a5,364(s1)
    80002dd2:	16f4a823          	sw	a5,368(s1)
        u64 epc = p->trapframe->epc;
    80002dd6:	74bc                	ld	a5,104(s1)
    80002dd8:	6f98                	ld	a4,24(a5)
        p->trapframe->epc = (u64)fn;
    80002dda:	1784b683          	ld	a3,376(s1)
    80002dde:	ef94                	sd	a3,24(a5)
        p->trapframe->ra = epc;
    80002de0:	74bc                	ld	a5,104(s1)
    80002de2:	f798                	sd	a4,40(a5)
        re_en = 1;
    80002de4:	4785                	li	a5,1
    80002de6:	00006717          	auipc	a4,0x6
    80002dea:	24f70523          	sb	a5,586(a4) # 80009030 <re_en>
        usertrapret();
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	d30080e7          	jalr	-720(ra) # 80002b1e <usertrapret>
    80002df6:	bf55                	j	80002daa <usertrap+0x106>

0000000080002df8 <kerneltrap>:
void kerneltrap() {
    80002df8:	7179                	addi	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002e06:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e0a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002e0e:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002e12:	1004f793          	andi	a5,s1,256
    80002e16:	cb85                	beqz	a5,80002e46 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e18:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e1c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002e1e:	ef85                	bnez	a5,80002e56 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	de2080e7          	jalr	-542(ra) # 80002c02 <devintr>
    80002e28:	cd1d                	beqz	a0,80002e66 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e2a:	4789                	li	a5,2
    80002e2c:	06f50a63          	beq	a0,a5,80002ea0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002e30:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002e34:	10049073          	csrw	sstatus,s1
}
    80002e38:	70a2                	ld	ra,40(sp)
    80002e3a:	7402                	ld	s0,32(sp)
    80002e3c:	64e2                	ld	s1,24(sp)
    80002e3e:	6942                	ld	s2,16(sp)
    80002e40:	69a2                	ld	s3,8(sp)
    80002e42:	6145                	addi	sp,sp,48
    80002e44:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e46:	00005517          	auipc	a0,0x5
    80002e4a:	66a50513          	addi	a0,a0,1642 # 800084b0 <states.0+0xe8>
    80002e4e:	ffffd097          	auipc	ra,0xffffd
    80002e52:	77e080e7          	jalr	1918(ra) # 800005cc <panic>
    panic("kerneltrap: interrupts enabled");
    80002e56:	00005517          	auipc	a0,0x5
    80002e5a:	68250513          	addi	a0,a0,1666 # 800084d8 <states.0+0x110>
    80002e5e:	ffffd097          	auipc	ra,0xffffd
    80002e62:	76e080e7          	jalr	1902(ra) # 800005cc <panic>
    printf("scause %p\n", scause);
    80002e66:	85ce                	mv	a1,s3
    80002e68:	00005517          	auipc	a0,0x5
    80002e6c:	69050513          	addi	a0,a0,1680 # 800084f8 <states.0+0x130>
    80002e70:	ffffd097          	auipc	ra,0xffffd
    80002e74:	7ae080e7          	jalr	1966(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002e78:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002e7c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e80:	00005517          	auipc	a0,0x5
    80002e84:	68850513          	addi	a0,a0,1672 # 80008508 <states.0+0x140>
    80002e88:	ffffd097          	auipc	ra,0xffffd
    80002e8c:	796080e7          	jalr	1942(ra) # 8000061e <printf>
    panic("kerneltrap");
    80002e90:	00005517          	auipc	a0,0x5
    80002e94:	69050513          	addi	a0,a0,1680 # 80008520 <states.0+0x158>
    80002e98:	ffffd097          	auipc	ra,0xffffd
    80002e9c:	734080e7          	jalr	1844(ra) # 800005cc <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	dcc080e7          	jalr	-564(ra) # 80001c6c <myproc>
    80002ea8:	d541                	beqz	a0,80002e30 <kerneltrap+0x38>
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	dc2080e7          	jalr	-574(ra) # 80001c6c <myproc>
    80002eb2:	4d18                	lw	a4,24(a0)
    80002eb4:	4791                	li	a5,4
    80002eb6:	f6f71de3          	bne	a4,a5,80002e30 <kerneltrap+0x38>
    yield();
    80002eba:	fffff097          	auipc	ra,0xfffff
    80002ebe:	628080e7          	jalr	1576(ra) # 800024e2 <yield>
    80002ec2:	b7bd                	j	80002e30 <kerneltrap+0x38>

0000000080002ec4 <argraw>:
  if (err < 0)
    return err;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80002ec4:	1101                	addi	sp,sp,-32
    80002ec6:	ec06                	sd	ra,24(sp)
    80002ec8:	e822                	sd	s0,16(sp)
    80002eca:	e426                	sd	s1,8(sp)
    80002ecc:	1000                	addi	s0,sp,32
    80002ece:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002ed0:	fffff097          	auipc	ra,0xfffff
    80002ed4:	d9c080e7          	jalr	-612(ra) # 80001c6c <myproc>
  switch (n) {
    80002ed8:	4795                	li	a5,5
    80002eda:	0497e163          	bltu	a5,s1,80002f1c <argraw+0x58>
    80002ede:	048a                	slli	s1,s1,0x2
    80002ee0:	00005717          	auipc	a4,0x5
    80002ee4:	69070713          	addi	a4,a4,1680 # 80008570 <states.0+0x1a8>
    80002ee8:	94ba                	add	s1,s1,a4
    80002eea:	409c                	lw	a5,0(s1)
    80002eec:	97ba                	add	a5,a5,a4
    80002eee:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ef0:	753c                	ld	a5,104(a0)
    80002ef2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ef4:	60e2                	ld	ra,24(sp)
    80002ef6:	6442                	ld	s0,16(sp)
    80002ef8:	64a2                	ld	s1,8(sp)
    80002efa:	6105                	addi	sp,sp,32
    80002efc:	8082                	ret
    return p->trapframe->a1;
    80002efe:	753c                	ld	a5,104(a0)
    80002f00:	7fa8                	ld	a0,120(a5)
    80002f02:	bfcd                	j	80002ef4 <argraw+0x30>
    return p->trapframe->a2;
    80002f04:	753c                	ld	a5,104(a0)
    80002f06:	63c8                	ld	a0,128(a5)
    80002f08:	b7f5                	j	80002ef4 <argraw+0x30>
    return p->trapframe->a3;
    80002f0a:	753c                	ld	a5,104(a0)
    80002f0c:	67c8                	ld	a0,136(a5)
    80002f0e:	b7dd                	j	80002ef4 <argraw+0x30>
    return p->trapframe->a4;
    80002f10:	753c                	ld	a5,104(a0)
    80002f12:	6bc8                	ld	a0,144(a5)
    80002f14:	b7c5                	j	80002ef4 <argraw+0x30>
    return p->trapframe->a5;
    80002f16:	753c                	ld	a5,104(a0)
    80002f18:	6fc8                	ld	a0,152(a5)
    80002f1a:	bfe9                	j	80002ef4 <argraw+0x30>
  panic("argraw");
    80002f1c:	00005517          	auipc	a0,0x5
    80002f20:	61450513          	addi	a0,a0,1556 # 80008530 <states.0+0x168>
    80002f24:	ffffd097          	auipc	ra,0xffffd
    80002f28:	6a8080e7          	jalr	1704(ra) # 800005cc <panic>

0000000080002f2c <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80002f2c:	1101                	addi	sp,sp,-32
    80002f2e:	ec06                	sd	ra,24(sp)
    80002f30:	e822                	sd	s0,16(sp)
    80002f32:	e426                	sd	s1,8(sp)
    80002f34:	e04a                	sd	s2,0(sp)
    80002f36:	1000                	addi	s0,sp,32
    80002f38:	84aa                	mv	s1,a0
    80002f3a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	d30080e7          	jalr	-720(ra) # 80001c6c <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80002f44:	693c                	ld	a5,80(a0)
    80002f46:	02f4f863          	bgeu	s1,a5,80002f76 <fetchaddr+0x4a>
    80002f4a:	00848713          	addi	a4,s1,8
    80002f4e:	02e7e663          	bltu	a5,a4,80002f7a <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f52:	46a1                	li	a3,8
    80002f54:	8626                	mv	a2,s1
    80002f56:	85ca                	mv	a1,s2
    80002f58:	6d28                	ld	a0,88(a0)
    80002f5a:	fffff097          	auipc	ra,0xfffff
    80002f5e:	a08080e7          	jalr	-1528(ra) # 80001962 <copyin>
    80002f62:	00a03533          	snez	a0,a0
    80002f66:	40a00533          	neg	a0,a0
}
    80002f6a:	60e2                	ld	ra,24(sp)
    80002f6c:	6442                	ld	s0,16(sp)
    80002f6e:	64a2                	ld	s1,8(sp)
    80002f70:	6902                	ld	s2,0(sp)
    80002f72:	6105                	addi	sp,sp,32
    80002f74:	8082                	ret
    return -1;
    80002f76:	557d                	li	a0,-1
    80002f78:	bfcd                	j	80002f6a <fetchaddr+0x3e>
    80002f7a:	557d                	li	a0,-1
    80002f7c:	b7fd                	j	80002f6a <fetchaddr+0x3e>

0000000080002f7e <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80002f7e:	7179                	addi	sp,sp,-48
    80002f80:	f406                	sd	ra,40(sp)
    80002f82:	f022                	sd	s0,32(sp)
    80002f84:	ec26                	sd	s1,24(sp)
    80002f86:	e84a                	sd	s2,16(sp)
    80002f88:	e44e                	sd	s3,8(sp)
    80002f8a:	1800                	addi	s0,sp,48
    80002f8c:	892a                	mv	s2,a0
    80002f8e:	84ae                	mv	s1,a1
    80002f90:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	cda080e7          	jalr	-806(ra) # 80001c6c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002f9a:	86ce                	mv	a3,s3
    80002f9c:	864a                	mv	a2,s2
    80002f9e:	85a6                	mv	a1,s1
    80002fa0:	6d28                	ld	a0,88(a0)
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	a52080e7          	jalr	-1454(ra) # 800019f4 <copyinstr>
  if (err < 0)
    80002faa:	00054763          	bltz	a0,80002fb8 <fetchstr+0x3a>
  return strlen(buf);
    80002fae:	8526                	mv	a0,s1
    80002fb0:	ffffe097          	auipc	ra,0xffffe
    80002fb4:	f0a080e7          	jalr	-246(ra) # 80000eba <strlen>
}
    80002fb8:	70a2                	ld	ra,40(sp)
    80002fba:	7402                	ld	s0,32(sp)
    80002fbc:	64e2                	ld	s1,24(sp)
    80002fbe:	6942                	ld	s2,16(sp)
    80002fc0:	69a2                	ld	s3,8(sp)
    80002fc2:	6145                	addi	sp,sp,48
    80002fc4:	8082                	ret

0000000080002fc6 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
    80002fc6:	1101                	addi	sp,sp,-32
    80002fc8:	ec06                	sd	ra,24(sp)
    80002fca:	e822                	sd	s0,16(sp)
    80002fcc:	e426                	sd	s1,8(sp)
    80002fce:	1000                	addi	s0,sp,32
    80002fd0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	ef2080e7          	jalr	-270(ra) # 80002ec4 <argraw>
    80002fda:	c088                	sw	a0,0(s1)
  return 0;
}
    80002fdc:	4501                	li	a0,0
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	64a2                	ld	s1,8(sp)
    80002fe4:	6105                	addi	sp,sp,32
    80002fe6:	8082                	ret

0000000080002fe8 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip) {
    80002fe8:	1101                	addi	sp,sp,-32
    80002fea:	ec06                	sd	ra,24(sp)
    80002fec:	e822                	sd	s0,16(sp)
    80002fee:	e426                	sd	s1,8(sp)
    80002ff0:	1000                	addi	s0,sp,32
    80002ff2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	ed0080e7          	jalr	-304(ra) # 80002ec4 <argraw>
    80002ffc:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ffe:	4501                	li	a0,0
    80003000:	60e2                	ld	ra,24(sp)
    80003002:	6442                	ld	s0,16(sp)
    80003004:	64a2                	ld	s1,8(sp)
    80003006:	6105                	addi	sp,sp,32
    80003008:	8082                	ret

000000008000300a <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    8000300a:	1101                	addi	sp,sp,-32
    8000300c:	ec06                	sd	ra,24(sp)
    8000300e:	e822                	sd	s0,16(sp)
    80003010:	e426                	sd	s1,8(sp)
    80003012:	e04a                	sd	s2,0(sp)
    80003014:	1000                	addi	s0,sp,32
    80003016:	84ae                	mv	s1,a1
    80003018:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	eaa080e7          	jalr	-342(ra) # 80002ec4 <argraw>
  uint64 addr;
  if (argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003022:	864a                	mv	a2,s2
    80003024:	85a6                	mv	a1,s1
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	f58080e7          	jalr	-168(ra) # 80002f7e <fetchstr>
}
    8000302e:	60e2                	ld	ra,24(sp)
    80003030:	6442                	ld	s0,16(sp)
    80003032:	64a2                	ld	s1,8(sp)
    80003034:	6902                	ld	s2,0(sp)
    80003036:	6105                	addi	sp,sp,32
    80003038:	8082                	ret

000000008000303a <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,   [SYS_trace] = sys_trace,
    [SYS_alarm] = sys_alarm,   [SYS_alarmret] = sys_alarmret};

void syscall(void) {
    8000303a:	7179                	addi	sp,sp,-48
    8000303c:	f406                	sd	ra,40(sp)
    8000303e:	f022                	sd	s0,32(sp)
    80003040:	ec26                	sd	s1,24(sp)
    80003042:	e84a                	sd	s2,16(sp)
    80003044:	e44e                	sd	s3,8(sp)
    80003046:	e052                	sd	s4,0(sp)
    80003048:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	c22080e7          	jalr	-990(ra) # 80001c6c <myproc>
    80003052:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003054:	753c                	ld	a5,104(a0)
    80003056:	77dc                	ld	a5,168(a5)
    80003058:	0007891b          	sext.w	s2,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000305c:	37fd                	addiw	a5,a5,-1
    8000305e:	475d                	li	a4,23
    80003060:	04f76f63          	bltu	a4,a5,800030be <syscall+0x84>
    80003064:	00391713          	slli	a4,s2,0x3
    80003068:	00005797          	auipc	a5,0x5
    8000306c:	52078793          	addi	a5,a5,1312 # 80008588 <syscalls>
    80003070:	97ba                	add	a5,a5,a4
    80003072:	0007ba03          	ld	s4,0(a5)
    80003076:	040a0463          	beqz	s4,800030be <syscall+0x84>
    i32 mask = myproc()->traced;
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	bf2080e7          	jalr	-1038(ra) # 80001c6c <myproc>
    80003082:	04052983          	lw	s3,64(a0)
    u64 res = syscalls[num]();
    80003086:	9a02                	jalr	s4
    80003088:	8a2a                	mv	s4,a0
    if (mask & (1 << num)) {
    8000308a:	4129d9bb          	sraw	s3,s3,s2
    8000308e:	0019f993          	andi	s3,s3,1
    80003092:	00099663          	bnez	s3,8000309e <syscall+0x64>
      printf("%d: syscall %d -> %d\n", myproc()->pid, num, res);
    }
    p->trapframe->a0 = res;
    80003096:	74bc                	ld	a5,104(s1)
    80003098:	0747b823          	sd	s4,112(a5)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000309c:	a081                	j	800030dc <syscall+0xa2>
      printf("%d: syscall %d -> %d\n", myproc()->pid, num, res);
    8000309e:	fffff097          	auipc	ra,0xfffff
    800030a2:	bce080e7          	jalr	-1074(ra) # 80001c6c <myproc>
    800030a6:	86d2                	mv	a3,s4
    800030a8:	864a                	mv	a2,s2
    800030aa:	590c                	lw	a1,48(a0)
    800030ac:	00005517          	auipc	a0,0x5
    800030b0:	48c50513          	addi	a0,a0,1164 # 80008538 <states.0+0x170>
    800030b4:	ffffd097          	auipc	ra,0xffffd
    800030b8:	56a080e7          	jalr	1386(ra) # 8000061e <printf>
    800030bc:	bfe9                	j	80003096 <syscall+0x5c>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800030be:	86ca                	mv	a3,s2
    800030c0:	18048613          	addi	a2,s1,384
    800030c4:	588c                	lw	a1,48(s1)
    800030c6:	00005517          	auipc	a0,0x5
    800030ca:	48a50513          	addi	a0,a0,1162 # 80008550 <states.0+0x188>
    800030ce:	ffffd097          	auipc	ra,0xffffd
    800030d2:	550080e7          	jalr	1360(ra) # 8000061e <printf>
    p->trapframe->a0 = -1;
    800030d6:	74bc                	ld	a5,104(s1)
    800030d8:	577d                	li	a4,-1
    800030da:	fbb8                	sd	a4,112(a5)
  }
}
    800030dc:	70a2                	ld	ra,40(sp)
    800030de:	7402                	ld	s0,32(sp)
    800030e0:	64e2                	ld	s1,24(sp)
    800030e2:	6942                	ld	s2,16(sp)
    800030e4:	69a2                	ld	s3,8(sp)
    800030e6:	6a02                	ld	s4,0(sp)
    800030e8:	6145                	addi	sp,sp,48
    800030ea:	8082                	ret

00000000800030ec <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    800030ec:	1101                	addi	sp,sp,-32
    800030ee:	ec06                	sd	ra,24(sp)
    800030f0:	e822                	sd	s0,16(sp)
    800030f2:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    800030f4:	fec40593          	addi	a1,s0,-20
    800030f8:	4501                	li	a0,0
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	ecc080e7          	jalr	-308(ra) # 80002fc6 <argint>
    return -1;
    80003102:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003104:	00054963          	bltz	a0,80003116 <sys_exit+0x2a>
  exit(n);
    80003108:	fec42503          	lw	a0,-20(s0)
    8000310c:	fffff097          	auipc	ra,0xfffff
    80003110:	66e080e7          	jalr	1646(ra) # 8000277a <exit>
  return 0; // not reached
    80003114:	4781                	li	a5,0
}
    80003116:	853e                	mv	a0,a5
    80003118:	60e2                	ld	ra,24(sp)
    8000311a:	6442                	ld	s0,16(sp)
    8000311c:	6105                	addi	sp,sp,32
    8000311e:	8082                	ret

0000000080003120 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80003120:	1141                	addi	sp,sp,-16
    80003122:	e406                	sd	ra,8(sp)
    80003124:	e022                	sd	s0,0(sp)
    80003126:	0800                	addi	s0,sp,16
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	b44080e7          	jalr	-1212(ra) # 80001c6c <myproc>
    80003130:	5908                	lw	a0,48(a0)
    80003132:	60a2                	ld	ra,8(sp)
    80003134:	6402                	ld	s0,0(sp)
    80003136:	0141                	addi	sp,sp,16
    80003138:	8082                	ret

000000008000313a <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    8000313a:	1141                	addi	sp,sp,-16
    8000313c:	e406                	sd	ra,8(sp)
    8000313e:	e022                	sd	s0,0(sp)
    80003140:	0800                	addi	s0,sp,16
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	05a080e7          	jalr	90(ra) # 8000219c <fork>
    8000314a:	60a2                	ld	ra,8(sp)
    8000314c:	6402                	ld	s0,0(sp)
    8000314e:	0141                	addi	sp,sp,16
    80003150:	8082                	ret

0000000080003152 <sys_wait>:

uint64 sys_wait(void) {
    80003152:	1101                	addi	sp,sp,-32
    80003154:	ec06                	sd	ra,24(sp)
    80003156:	e822                	sd	s0,16(sp)
    80003158:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    8000315a:	fe840593          	addi	a1,s0,-24
    8000315e:	4501                	li	a0,0
    80003160:	00000097          	auipc	ra,0x0
    80003164:	e88080e7          	jalr	-376(ra) # 80002fe8 <argaddr>
    80003168:	87aa                	mv	a5,a0
    return -1;
    8000316a:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    8000316c:	0007c863          	bltz	a5,8000317c <sys_wait+0x2a>
  return wait(p);
    80003170:	fe843503          	ld	a0,-24(s0)
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	40e080e7          	jalr	1038(ra) # 80002582 <wait>
}
    8000317c:	60e2                	ld	ra,24(sp)
    8000317e:	6442                	ld	s0,16(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003184:	7179                	addi	sp,sp,-48
    80003186:	f406                	sd	ra,40(sp)
    80003188:	f022                	sd	s0,32(sp)
    8000318a:	ec26                	sd	s1,24(sp)
    8000318c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    8000318e:	fdc40593          	addi	a1,s0,-36
    80003192:	4501                	li	a0,0
    80003194:	00000097          	auipc	ra,0x0
    80003198:	e32080e7          	jalr	-462(ra) # 80002fc6 <argint>
    return -1;
    8000319c:	54fd                	li	s1,-1
  if (argint(0, &n) < 0)
    8000319e:	00054f63          	bltz	a0,800031bc <sys_sbrk+0x38>
  addr = myproc()->sz;
    800031a2:	fffff097          	auipc	ra,0xfffff
    800031a6:	aca080e7          	jalr	-1334(ra) # 80001c6c <myproc>
    800031aa:	4924                	lw	s1,80(a0)
  if (growproc(n) < 0)
    800031ac:	fdc42503          	lw	a0,-36(s0)
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	eda080e7          	jalr	-294(ra) # 8000208a <growproc>
    800031b8:	00054863          	bltz	a0,800031c8 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    800031bc:	8526                	mv	a0,s1
    800031be:	70a2                	ld	ra,40(sp)
    800031c0:	7402                	ld	s0,32(sp)
    800031c2:	64e2                	ld	s1,24(sp)
    800031c4:	6145                	addi	sp,sp,48
    800031c6:	8082                	ret
    return -1;
    800031c8:	54fd                	li	s1,-1
    800031ca:	bfcd                	j	800031bc <sys_sbrk+0x38>

00000000800031cc <sys_trace>:

u64 sys_trace(void) {
    800031cc:	1101                	addi	sp,sp,-32
    800031ce:	ec06                	sd	ra,24(sp)
    800031d0:	e822                	sd	s0,16(sp)
    800031d2:	1000                	addi	s0,sp,32
  i32 traced;
  if (argint(0, &traced) < 0)
    800031d4:	fec40593          	addi	a1,s0,-20
    800031d8:	4501                	li	a0,0
    800031da:	00000097          	auipc	ra,0x0
    800031de:	dec080e7          	jalr	-532(ra) # 80002fc6 <argint>
    800031e2:	87aa                	mv	a5,a0
    return -1;
    800031e4:	557d                	li	a0,-1
  if (argint(0, &traced) < 0)
    800031e6:	0007c863          	bltz	a5,800031f6 <sys_trace+0x2a>
  return trace(traced);
    800031ea:	fec42503          	lw	a0,-20(s0)
    800031ee:	fffff097          	auipc	ra,0xfffff
    800031f2:	f4a080e7          	jalr	-182(ra) # 80002138 <trace>
}
    800031f6:	60e2                	ld	ra,24(sp)
    800031f8:	6442                	ld	s0,16(sp)
    800031fa:	6105                	addi	sp,sp,32
    800031fc:	8082                	ret

00000000800031fe <sys_alarm>:

u64 sys_alarm(void) {
    800031fe:	1101                	addi	sp,sp,-32
    80003200:	ec06                	sd	ra,24(sp)
    80003202:	e822                	sd	s0,16(sp)
    80003204:	1000                	addi	s0,sp,32
  i32 tick;
  u64 handler;
  if (argaddr(1, &handler) < 0)
    80003206:	fe040593          	addi	a1,s0,-32
    8000320a:	4505                	li	a0,1
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	ddc080e7          	jalr	-548(ra) # 80002fe8 <argaddr>
    return -1;
    80003214:	57fd                	li	a5,-1
  if (argaddr(1, &handler) < 0)
    80003216:	02054563          	bltz	a0,80003240 <sys_alarm+0x42>
  if (argint(0, &tick) < 0)
    8000321a:	fec40593          	addi	a1,s0,-20
    8000321e:	4501                	li	a0,0
    80003220:	00000097          	auipc	ra,0x0
    80003224:	da6080e7          	jalr	-602(ra) # 80002fc6 <argint>
    return -1;
    80003228:	57fd                	li	a5,-1
  if (argint(0, &tick) < 0)
    8000322a:	00054b63          	bltz	a0,80003240 <sys_alarm+0x42>
  return alarm(tick, (void *)handler);
    8000322e:	fe043583          	ld	a1,-32(s0)
    80003232:	fec42503          	lw	a0,-20(s0)
    80003236:	fffff097          	auipc	ra,0xfffff
    8000323a:	f28080e7          	jalr	-216(ra) # 8000215e <alarm>
    8000323e:	87aa                	mv	a5,a0
}
    80003240:	853e                	mv	a0,a5
    80003242:	60e2                	ld	ra,24(sp)
    80003244:	6442                	ld	s0,16(sp)
    80003246:	6105                	addi	sp,sp,32
    80003248:	8082                	ret

000000008000324a <sys_alarmret>:

extern struct trapframe handler_frame;
extern u8 re_en;
u64 sys_alarmret(void) {
    8000324a:	1141                	addi	sp,sp,-16
    8000324c:	e406                	sd	ra,8(sp)
    8000324e:	e022                	sd	s0,0(sp)
    80003250:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	a1a080e7          	jalr	-1510(ra) # 80001c6c <myproc>
  // * restore argument registers
  memmove(p->trapframe, &handler_frame, sizeof(handler_frame));
    8000325a:	12000613          	li	a2,288
    8000325e:	00015597          	auipc	a1,0x15
    80003262:	88a58593          	addi	a1,a1,-1910 # 80017ae8 <handler_frame>
    80003266:	7528                	ld	a0,104(a0)
    80003268:	ffffe097          	auipc	ra,0xffffe
    8000326c:	b2a080e7          	jalr	-1238(ra) # 80000d92 <memmove>
  re_en = 0;
    80003270:	00006797          	auipc	a5,0x6
    80003274:	dc078023          	sb	zero,-576(a5) # 80009030 <re_en>
  usertrapret();
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	8a6080e7          	jalr	-1882(ra) # 80002b1e <usertrapret>
  return 0;
}
    80003280:	4501                	li	a0,0
    80003282:	60a2                	ld	ra,8(sp)
    80003284:	6402                	ld	s0,0(sp)
    80003286:	0141                	addi	sp,sp,16
    80003288:	8082                	ret

000000008000328a <sys_sleep>:

uint64 sys_sleep(void) {
    8000328a:	7139                	addi	sp,sp,-64
    8000328c:	fc06                	sd	ra,56(sp)
    8000328e:	f822                	sd	s0,48(sp)
    80003290:	f426                	sd	s1,40(sp)
    80003292:	f04a                	sd	s2,32(sp)
    80003294:	ec4e                	sd	s3,24(sp)
    80003296:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80003298:	fcc40593          	addi	a1,s0,-52
    8000329c:	4501                	li	a0,0
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	d28080e7          	jalr	-728(ra) # 80002fc6 <argint>
    return -1;
    800032a6:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800032a8:	06054563          	bltz	a0,80003312 <sys_sleep+0x88>
  acquire(&tickslock);
    800032ac:	00015517          	auipc	a0,0x15
    800032b0:	82450513          	addi	a0,a0,-2012 # 80017ad0 <tickslock>
    800032b4:	ffffe097          	auipc	ra,0xffffe
    800032b8:	986080e7          	jalr	-1658(ra) # 80000c3a <acquire>
  ticks0 = ticks;
    800032bc:	00006917          	auipc	s2,0x6
    800032c0:	d7892903          	lw	s2,-648(s2) # 80009034 <ticks>
  while (ticks - ticks0 < n) {
    800032c4:	fcc42783          	lw	a5,-52(s0)
    800032c8:	cf85                	beqz	a5,80003300 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800032ca:	00015997          	auipc	s3,0x15
    800032ce:	80698993          	addi	s3,s3,-2042 # 80017ad0 <tickslock>
    800032d2:	00006497          	auipc	s1,0x6
    800032d6:	d6248493          	addi	s1,s1,-670 # 80009034 <ticks>
    if (myproc()->killed) {
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	992080e7          	jalr	-1646(ra) # 80001c6c <myproc>
    800032e2:	551c                	lw	a5,40(a0)
    800032e4:	ef9d                	bnez	a5,80003322 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800032e6:	85ce                	mv	a1,s3
    800032e8:	8526                	mv	a0,s1
    800032ea:	fffff097          	auipc	ra,0xfffff
    800032ee:	234080e7          	jalr	564(ra) # 8000251e <sleep>
  while (ticks - ticks0 < n) {
    800032f2:	409c                	lw	a5,0(s1)
    800032f4:	412787bb          	subw	a5,a5,s2
    800032f8:	fcc42703          	lw	a4,-52(s0)
    800032fc:	fce7efe3          	bltu	a5,a4,800032da <sys_sleep+0x50>
  }
  release(&tickslock);
    80003300:	00014517          	auipc	a0,0x14
    80003304:	7d050513          	addi	a0,a0,2000 # 80017ad0 <tickslock>
    80003308:	ffffe097          	auipc	ra,0xffffe
    8000330c:	9e6080e7          	jalr	-1562(ra) # 80000cee <release>
  return 0;
    80003310:	4781                	li	a5,0
}
    80003312:	853e                	mv	a0,a5
    80003314:	70e2                	ld	ra,56(sp)
    80003316:	7442                	ld	s0,48(sp)
    80003318:	74a2                	ld	s1,40(sp)
    8000331a:	7902                	ld	s2,32(sp)
    8000331c:	69e2                	ld	s3,24(sp)
    8000331e:	6121                	addi	sp,sp,64
    80003320:	8082                	ret
      release(&tickslock);
    80003322:	00014517          	auipc	a0,0x14
    80003326:	7ae50513          	addi	a0,a0,1966 # 80017ad0 <tickslock>
    8000332a:	ffffe097          	auipc	ra,0xffffe
    8000332e:	9c4080e7          	jalr	-1596(ra) # 80000cee <release>
      return -1;
    80003332:	57fd                	li	a5,-1
    80003334:	bff9                	j	80003312 <sys_sleep+0x88>

0000000080003336 <sys_kill>:

uint64 sys_kill(void) {
    80003336:	1101                	addi	sp,sp,-32
    80003338:	ec06                	sd	ra,24(sp)
    8000333a:	e822                	sd	s0,16(sp)
    8000333c:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    8000333e:	fec40593          	addi	a1,s0,-20
    80003342:	4501                	li	a0,0
    80003344:	00000097          	auipc	ra,0x0
    80003348:	c82080e7          	jalr	-894(ra) # 80002fc6 <argint>
    8000334c:	87aa                	mv	a5,a0
    return -1;
    8000334e:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    80003350:	0007c863          	bltz	a5,80003360 <sys_kill+0x2a>
  return kill(pid);
    80003354:	fec42503          	lw	a0,-20(s0)
    80003358:	fffff097          	auipc	ra,0xfffff
    8000335c:	4f8080e7          	jalr	1272(ra) # 80002850 <kill>
}
    80003360:	60e2                	ld	ra,24(sp)
    80003362:	6442                	ld	s0,16(sp)
    80003364:	6105                	addi	sp,sp,32
    80003366:	8082                	ret

0000000080003368 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003372:	00014517          	auipc	a0,0x14
    80003376:	75e50513          	addi	a0,a0,1886 # 80017ad0 <tickslock>
    8000337a:	ffffe097          	auipc	ra,0xffffe
    8000337e:	8c0080e7          	jalr	-1856(ra) # 80000c3a <acquire>
  xticks = ticks;
    80003382:	00006497          	auipc	s1,0x6
    80003386:	cb24a483          	lw	s1,-846(s1) # 80009034 <ticks>
  release(&tickslock);
    8000338a:	00014517          	auipc	a0,0x14
    8000338e:	74650513          	addi	a0,a0,1862 # 80017ad0 <tickslock>
    80003392:	ffffe097          	auipc	ra,0xffffe
    80003396:	95c080e7          	jalr	-1700(ra) # 80000cee <release>
  return xticks;
}
    8000339a:	02049513          	slli	a0,s1,0x20
    8000339e:	9101                	srli	a0,a0,0x20
    800033a0:	60e2                	ld	ra,24(sp)
    800033a2:	6442                	ld	s0,16(sp)
    800033a4:	64a2                	ld	s1,8(sp)
    800033a6:	6105                	addi	sp,sp,32
    800033a8:	8082                	ret

00000000800033aa <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800033aa:	7179                	addi	sp,sp,-48
    800033ac:	f406                	sd	ra,40(sp)
    800033ae:	f022                	sd	s0,32(sp)
    800033b0:	ec26                	sd	s1,24(sp)
    800033b2:	e84a                	sd	s2,16(sp)
    800033b4:	e44e                	sd	s3,8(sp)
    800033b6:	e052                	sd	s4,0(sp)
    800033b8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800033ba:	00005597          	auipc	a1,0x5
    800033be:	29658593          	addi	a1,a1,662 # 80008650 <syscalls+0xc8>
    800033c2:	00015517          	auipc	a0,0x15
    800033c6:	84650513          	addi	a0,a0,-1978 # 80017c08 <bcache>
    800033ca:	ffffd097          	auipc	ra,0xffffd
    800033ce:	7e0080e7          	jalr	2016(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800033d2:	0001d797          	auipc	a5,0x1d
    800033d6:	83678793          	addi	a5,a5,-1994 # 8001fc08 <bcache+0x8000>
    800033da:	0001d717          	auipc	a4,0x1d
    800033de:	a9670713          	addi	a4,a4,-1386 # 8001fe70 <bcache+0x8268>
    800033e2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800033e6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033ea:	00015497          	auipc	s1,0x15
    800033ee:	83648493          	addi	s1,s1,-1994 # 80017c20 <bcache+0x18>
    b->next = bcache.head.next;
    800033f2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033f4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033f6:	00005a17          	auipc	s4,0x5
    800033fa:	262a0a13          	addi	s4,s4,610 # 80008658 <syscalls+0xd0>
    b->next = bcache.head.next;
    800033fe:	2b893783          	ld	a5,696(s2)
    80003402:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003404:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003408:	85d2                	mv	a1,s4
    8000340a:	01048513          	addi	a0,s1,16
    8000340e:	00001097          	auipc	ra,0x1
    80003412:	4bc080e7          	jalr	1212(ra) # 800048ca <initsleeplock>
    bcache.head.next->prev = b;
    80003416:	2b893783          	ld	a5,696(s2)
    8000341a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000341c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003420:	45848493          	addi	s1,s1,1112
    80003424:	fd349de3          	bne	s1,s3,800033fe <binit+0x54>
  }
}
    80003428:	70a2                	ld	ra,40(sp)
    8000342a:	7402                	ld	s0,32(sp)
    8000342c:	64e2                	ld	s1,24(sp)
    8000342e:	6942                	ld	s2,16(sp)
    80003430:	69a2                	ld	s3,8(sp)
    80003432:	6a02                	ld	s4,0(sp)
    80003434:	6145                	addi	sp,sp,48
    80003436:	8082                	ret

0000000080003438 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003438:	7179                	addi	sp,sp,-48
    8000343a:	f406                	sd	ra,40(sp)
    8000343c:	f022                	sd	s0,32(sp)
    8000343e:	ec26                	sd	s1,24(sp)
    80003440:	e84a                	sd	s2,16(sp)
    80003442:	e44e                	sd	s3,8(sp)
    80003444:	1800                	addi	s0,sp,48
    80003446:	892a                	mv	s2,a0
    80003448:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000344a:	00014517          	auipc	a0,0x14
    8000344e:	7be50513          	addi	a0,a0,1982 # 80017c08 <bcache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	7e8080e7          	jalr	2024(ra) # 80000c3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000345a:	0001d497          	auipc	s1,0x1d
    8000345e:	a664b483          	ld	s1,-1434(s1) # 8001fec0 <bcache+0x82b8>
    80003462:	0001d797          	auipc	a5,0x1d
    80003466:	a0e78793          	addi	a5,a5,-1522 # 8001fe70 <bcache+0x8268>
    8000346a:	02f48f63          	beq	s1,a5,800034a8 <bread+0x70>
    8000346e:	873e                	mv	a4,a5
    80003470:	a021                	j	80003478 <bread+0x40>
    80003472:	68a4                	ld	s1,80(s1)
    80003474:	02e48a63          	beq	s1,a4,800034a8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003478:	449c                	lw	a5,8(s1)
    8000347a:	ff279ce3          	bne	a5,s2,80003472 <bread+0x3a>
    8000347e:	44dc                	lw	a5,12(s1)
    80003480:	ff3799e3          	bne	a5,s3,80003472 <bread+0x3a>
      b->refcnt++;
    80003484:	40bc                	lw	a5,64(s1)
    80003486:	2785                	addiw	a5,a5,1
    80003488:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000348a:	00014517          	auipc	a0,0x14
    8000348e:	77e50513          	addi	a0,a0,1918 # 80017c08 <bcache>
    80003492:	ffffe097          	auipc	ra,0xffffe
    80003496:	85c080e7          	jalr	-1956(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    8000349a:	01048513          	addi	a0,s1,16
    8000349e:	00001097          	auipc	ra,0x1
    800034a2:	466080e7          	jalr	1126(ra) # 80004904 <acquiresleep>
      return b;
    800034a6:	a8b9                	j	80003504 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034a8:	0001d497          	auipc	s1,0x1d
    800034ac:	a104b483          	ld	s1,-1520(s1) # 8001feb8 <bcache+0x82b0>
    800034b0:	0001d797          	auipc	a5,0x1d
    800034b4:	9c078793          	addi	a5,a5,-1600 # 8001fe70 <bcache+0x8268>
    800034b8:	00f48863          	beq	s1,a5,800034c8 <bread+0x90>
    800034bc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800034be:	40bc                	lw	a5,64(s1)
    800034c0:	cf81                	beqz	a5,800034d8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034c2:	64a4                	ld	s1,72(s1)
    800034c4:	fee49de3          	bne	s1,a4,800034be <bread+0x86>
  panic("bget: no buffers");
    800034c8:	00005517          	auipc	a0,0x5
    800034cc:	19850513          	addi	a0,a0,408 # 80008660 <syscalls+0xd8>
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	0fc080e7          	jalr	252(ra) # 800005cc <panic>
      b->dev = dev;
    800034d8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800034dc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800034e0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800034e4:	4785                	li	a5,1
    800034e6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034e8:	00014517          	auipc	a0,0x14
    800034ec:	72050513          	addi	a0,a0,1824 # 80017c08 <bcache>
    800034f0:	ffffd097          	auipc	ra,0xffffd
    800034f4:	7fe080e7          	jalr	2046(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    800034f8:	01048513          	addi	a0,s1,16
    800034fc:	00001097          	auipc	ra,0x1
    80003500:	408080e7          	jalr	1032(ra) # 80004904 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003504:	409c                	lw	a5,0(s1)
    80003506:	cb89                	beqz	a5,80003518 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003508:	8526                	mv	a0,s1
    8000350a:	70a2                	ld	ra,40(sp)
    8000350c:	7402                	ld	s0,32(sp)
    8000350e:	64e2                	ld	s1,24(sp)
    80003510:	6942                	ld	s2,16(sp)
    80003512:	69a2                	ld	s3,8(sp)
    80003514:	6145                	addi	sp,sp,48
    80003516:	8082                	ret
    virtio_disk_rw(b, 0);
    80003518:	4581                	li	a1,0
    8000351a:	8526                	mv	a0,s1
    8000351c:	00003097          	auipc	ra,0x3
    80003520:	f5a080e7          	jalr	-166(ra) # 80006476 <virtio_disk_rw>
    b->valid = 1;
    80003524:	4785                	li	a5,1
    80003526:	c09c                	sw	a5,0(s1)
  return b;
    80003528:	b7c5                	j	80003508 <bread+0xd0>

000000008000352a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000352a:	1101                	addi	sp,sp,-32
    8000352c:	ec06                	sd	ra,24(sp)
    8000352e:	e822                	sd	s0,16(sp)
    80003530:	e426                	sd	s1,8(sp)
    80003532:	1000                	addi	s0,sp,32
    80003534:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003536:	0541                	addi	a0,a0,16
    80003538:	00001097          	auipc	ra,0x1
    8000353c:	466080e7          	jalr	1126(ra) # 8000499e <holdingsleep>
    80003540:	cd01                	beqz	a0,80003558 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003542:	4585                	li	a1,1
    80003544:	8526                	mv	a0,s1
    80003546:	00003097          	auipc	ra,0x3
    8000354a:	f30080e7          	jalr	-208(ra) # 80006476 <virtio_disk_rw>
}
    8000354e:	60e2                	ld	ra,24(sp)
    80003550:	6442                	ld	s0,16(sp)
    80003552:	64a2                	ld	s1,8(sp)
    80003554:	6105                	addi	sp,sp,32
    80003556:	8082                	ret
    panic("bwrite");
    80003558:	00005517          	auipc	a0,0x5
    8000355c:	12050513          	addi	a0,a0,288 # 80008678 <syscalls+0xf0>
    80003560:	ffffd097          	auipc	ra,0xffffd
    80003564:	06c080e7          	jalr	108(ra) # 800005cc <panic>

0000000080003568 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003568:	1101                	addi	sp,sp,-32
    8000356a:	ec06                	sd	ra,24(sp)
    8000356c:	e822                	sd	s0,16(sp)
    8000356e:	e426                	sd	s1,8(sp)
    80003570:	e04a                	sd	s2,0(sp)
    80003572:	1000                	addi	s0,sp,32
    80003574:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003576:	01050913          	addi	s2,a0,16
    8000357a:	854a                	mv	a0,s2
    8000357c:	00001097          	auipc	ra,0x1
    80003580:	422080e7          	jalr	1058(ra) # 8000499e <holdingsleep>
    80003584:	c92d                	beqz	a0,800035f6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003586:	854a                	mv	a0,s2
    80003588:	00001097          	auipc	ra,0x1
    8000358c:	3d2080e7          	jalr	978(ra) # 8000495a <releasesleep>

  acquire(&bcache.lock);
    80003590:	00014517          	auipc	a0,0x14
    80003594:	67850513          	addi	a0,a0,1656 # 80017c08 <bcache>
    80003598:	ffffd097          	auipc	ra,0xffffd
    8000359c:	6a2080e7          	jalr	1698(ra) # 80000c3a <acquire>
  b->refcnt--;
    800035a0:	40bc                	lw	a5,64(s1)
    800035a2:	37fd                	addiw	a5,a5,-1
    800035a4:	0007871b          	sext.w	a4,a5
    800035a8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035aa:	eb05                	bnez	a4,800035da <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035ac:	68bc                	ld	a5,80(s1)
    800035ae:	64b8                	ld	a4,72(s1)
    800035b0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800035b2:	64bc                	ld	a5,72(s1)
    800035b4:	68b8                	ld	a4,80(s1)
    800035b6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800035b8:	0001c797          	auipc	a5,0x1c
    800035bc:	65078793          	addi	a5,a5,1616 # 8001fc08 <bcache+0x8000>
    800035c0:	2b87b703          	ld	a4,696(a5)
    800035c4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800035c6:	0001d717          	auipc	a4,0x1d
    800035ca:	8aa70713          	addi	a4,a4,-1878 # 8001fe70 <bcache+0x8268>
    800035ce:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800035d0:	2b87b703          	ld	a4,696(a5)
    800035d4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800035d6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800035da:	00014517          	auipc	a0,0x14
    800035de:	62e50513          	addi	a0,a0,1582 # 80017c08 <bcache>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	70c080e7          	jalr	1804(ra) # 80000cee <release>
}
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	64a2                	ld	s1,8(sp)
    800035f0:	6902                	ld	s2,0(sp)
    800035f2:	6105                	addi	sp,sp,32
    800035f4:	8082                	ret
    panic("brelse");
    800035f6:	00005517          	auipc	a0,0x5
    800035fa:	08a50513          	addi	a0,a0,138 # 80008680 <syscalls+0xf8>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	fce080e7          	jalr	-50(ra) # 800005cc <panic>

0000000080003606 <bpin>:

void
bpin(struct buf *b) {
    80003606:	1101                	addi	sp,sp,-32
    80003608:	ec06                	sd	ra,24(sp)
    8000360a:	e822                	sd	s0,16(sp)
    8000360c:	e426                	sd	s1,8(sp)
    8000360e:	1000                	addi	s0,sp,32
    80003610:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003612:	00014517          	auipc	a0,0x14
    80003616:	5f650513          	addi	a0,a0,1526 # 80017c08 <bcache>
    8000361a:	ffffd097          	auipc	ra,0xffffd
    8000361e:	620080e7          	jalr	1568(ra) # 80000c3a <acquire>
  b->refcnt++;
    80003622:	40bc                	lw	a5,64(s1)
    80003624:	2785                	addiw	a5,a5,1
    80003626:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003628:	00014517          	auipc	a0,0x14
    8000362c:	5e050513          	addi	a0,a0,1504 # 80017c08 <bcache>
    80003630:	ffffd097          	auipc	ra,0xffffd
    80003634:	6be080e7          	jalr	1726(ra) # 80000cee <release>
}
    80003638:	60e2                	ld	ra,24(sp)
    8000363a:	6442                	ld	s0,16(sp)
    8000363c:	64a2                	ld	s1,8(sp)
    8000363e:	6105                	addi	sp,sp,32
    80003640:	8082                	ret

0000000080003642 <bunpin>:

void
bunpin(struct buf *b) {
    80003642:	1101                	addi	sp,sp,-32
    80003644:	ec06                	sd	ra,24(sp)
    80003646:	e822                	sd	s0,16(sp)
    80003648:	e426                	sd	s1,8(sp)
    8000364a:	1000                	addi	s0,sp,32
    8000364c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000364e:	00014517          	auipc	a0,0x14
    80003652:	5ba50513          	addi	a0,a0,1466 # 80017c08 <bcache>
    80003656:	ffffd097          	auipc	ra,0xffffd
    8000365a:	5e4080e7          	jalr	1508(ra) # 80000c3a <acquire>
  b->refcnt--;
    8000365e:	40bc                	lw	a5,64(s1)
    80003660:	37fd                	addiw	a5,a5,-1
    80003662:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003664:	00014517          	auipc	a0,0x14
    80003668:	5a450513          	addi	a0,a0,1444 # 80017c08 <bcache>
    8000366c:	ffffd097          	auipc	ra,0xffffd
    80003670:	682080e7          	jalr	1666(ra) # 80000cee <release>
}
    80003674:	60e2                	ld	ra,24(sp)
    80003676:	6442                	ld	s0,16(sp)
    80003678:	64a2                	ld	s1,8(sp)
    8000367a:	6105                	addi	sp,sp,32
    8000367c:	8082                	ret

000000008000367e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000367e:	1101                	addi	sp,sp,-32
    80003680:	ec06                	sd	ra,24(sp)
    80003682:	e822                	sd	s0,16(sp)
    80003684:	e426                	sd	s1,8(sp)
    80003686:	e04a                	sd	s2,0(sp)
    80003688:	1000                	addi	s0,sp,32
    8000368a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000368c:	00d5d59b          	srliw	a1,a1,0xd
    80003690:	0001d797          	auipc	a5,0x1d
    80003694:	c547a783          	lw	a5,-940(a5) # 800202e4 <sb+0x1c>
    80003698:	9dbd                	addw	a1,a1,a5
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	d9e080e7          	jalr	-610(ra) # 80003438 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800036a2:	0074f713          	andi	a4,s1,7
    800036a6:	4785                	li	a5,1
    800036a8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800036ac:	14ce                	slli	s1,s1,0x33
    800036ae:	90d9                	srli	s1,s1,0x36
    800036b0:	00950733          	add	a4,a0,s1
    800036b4:	05874703          	lbu	a4,88(a4)
    800036b8:	00e7f6b3          	and	a3,a5,a4
    800036bc:	c69d                	beqz	a3,800036ea <bfree+0x6c>
    800036be:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800036c0:	94aa                	add	s1,s1,a0
    800036c2:	fff7c793          	not	a5,a5
    800036c6:	8ff9                	and	a5,a5,a4
    800036c8:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800036cc:	00001097          	auipc	ra,0x1
    800036d0:	118080e7          	jalr	280(ra) # 800047e4 <log_write>
  brelse(bp);
    800036d4:	854a                	mv	a0,s2
    800036d6:	00000097          	auipc	ra,0x0
    800036da:	e92080e7          	jalr	-366(ra) # 80003568 <brelse>
}
    800036de:	60e2                	ld	ra,24(sp)
    800036e0:	6442                	ld	s0,16(sp)
    800036e2:	64a2                	ld	s1,8(sp)
    800036e4:	6902                	ld	s2,0(sp)
    800036e6:	6105                	addi	sp,sp,32
    800036e8:	8082                	ret
    panic("freeing free block");
    800036ea:	00005517          	auipc	a0,0x5
    800036ee:	f9e50513          	addi	a0,a0,-98 # 80008688 <syscalls+0x100>
    800036f2:	ffffd097          	auipc	ra,0xffffd
    800036f6:	eda080e7          	jalr	-294(ra) # 800005cc <panic>

00000000800036fa <balloc>:
{
    800036fa:	711d                	addi	sp,sp,-96
    800036fc:	ec86                	sd	ra,88(sp)
    800036fe:	e8a2                	sd	s0,80(sp)
    80003700:	e4a6                	sd	s1,72(sp)
    80003702:	e0ca                	sd	s2,64(sp)
    80003704:	fc4e                	sd	s3,56(sp)
    80003706:	f852                	sd	s4,48(sp)
    80003708:	f456                	sd	s5,40(sp)
    8000370a:	f05a                	sd	s6,32(sp)
    8000370c:	ec5e                	sd	s7,24(sp)
    8000370e:	e862                	sd	s8,16(sp)
    80003710:	e466                	sd	s9,8(sp)
    80003712:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003714:	0001d797          	auipc	a5,0x1d
    80003718:	bb87a783          	lw	a5,-1096(a5) # 800202cc <sb+0x4>
    8000371c:	cbd1                	beqz	a5,800037b0 <balloc+0xb6>
    8000371e:	8baa                	mv	s7,a0
    80003720:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003722:	0001db17          	auipc	s6,0x1d
    80003726:	ba6b0b13          	addi	s6,s6,-1114 # 800202c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000372a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000372c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000372e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003730:	6c89                	lui	s9,0x2
    80003732:	a831                	j	8000374e <balloc+0x54>
    brelse(bp);
    80003734:	854a                	mv	a0,s2
    80003736:	00000097          	auipc	ra,0x0
    8000373a:	e32080e7          	jalr	-462(ra) # 80003568 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000373e:	015c87bb          	addw	a5,s9,s5
    80003742:	00078a9b          	sext.w	s5,a5
    80003746:	004b2703          	lw	a4,4(s6)
    8000374a:	06eaf363          	bgeu	s5,a4,800037b0 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000374e:	41fad79b          	sraiw	a5,s5,0x1f
    80003752:	0137d79b          	srliw	a5,a5,0x13
    80003756:	015787bb          	addw	a5,a5,s5
    8000375a:	40d7d79b          	sraiw	a5,a5,0xd
    8000375e:	01cb2583          	lw	a1,28(s6)
    80003762:	9dbd                	addw	a1,a1,a5
    80003764:	855e                	mv	a0,s7
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	cd2080e7          	jalr	-814(ra) # 80003438 <bread>
    8000376e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003770:	004b2503          	lw	a0,4(s6)
    80003774:	000a849b          	sext.w	s1,s5
    80003778:	8662                	mv	a2,s8
    8000377a:	faa4fde3          	bgeu	s1,a0,80003734 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000377e:	41f6579b          	sraiw	a5,a2,0x1f
    80003782:	01d7d69b          	srliw	a3,a5,0x1d
    80003786:	00c6873b          	addw	a4,a3,a2
    8000378a:	00777793          	andi	a5,a4,7
    8000378e:	9f95                	subw	a5,a5,a3
    80003790:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003794:	4037571b          	sraiw	a4,a4,0x3
    80003798:	00e906b3          	add	a3,s2,a4
    8000379c:	0586c683          	lbu	a3,88(a3)
    800037a0:	00d7f5b3          	and	a1,a5,a3
    800037a4:	cd91                	beqz	a1,800037c0 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037a6:	2605                	addiw	a2,a2,1
    800037a8:	2485                	addiw	s1,s1,1
    800037aa:	fd4618e3          	bne	a2,s4,8000377a <balloc+0x80>
    800037ae:	b759                	j	80003734 <balloc+0x3a>
  panic("balloc: out of blocks");
    800037b0:	00005517          	auipc	a0,0x5
    800037b4:	ef050513          	addi	a0,a0,-272 # 800086a0 <syscalls+0x118>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	e14080e7          	jalr	-492(ra) # 800005cc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800037c0:	974a                	add	a4,a4,s2
    800037c2:	8fd5                	or	a5,a5,a3
    800037c4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800037c8:	854a                	mv	a0,s2
    800037ca:	00001097          	auipc	ra,0x1
    800037ce:	01a080e7          	jalr	26(ra) # 800047e4 <log_write>
        brelse(bp);
    800037d2:	854a                	mv	a0,s2
    800037d4:	00000097          	auipc	ra,0x0
    800037d8:	d94080e7          	jalr	-620(ra) # 80003568 <brelse>
  bp = bread(dev, bno);
    800037dc:	85a6                	mv	a1,s1
    800037de:	855e                	mv	a0,s7
    800037e0:	00000097          	auipc	ra,0x0
    800037e4:	c58080e7          	jalr	-936(ra) # 80003438 <bread>
    800037e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037ea:	40000613          	li	a2,1024
    800037ee:	4581                	li	a1,0
    800037f0:	05850513          	addi	a0,a0,88
    800037f4:	ffffd097          	auipc	ra,0xffffd
    800037f8:	542080e7          	jalr	1346(ra) # 80000d36 <memset>
  log_write(bp);
    800037fc:	854a                	mv	a0,s2
    800037fe:	00001097          	auipc	ra,0x1
    80003802:	fe6080e7          	jalr	-26(ra) # 800047e4 <log_write>
  brelse(bp);
    80003806:	854a                	mv	a0,s2
    80003808:	00000097          	auipc	ra,0x0
    8000380c:	d60080e7          	jalr	-672(ra) # 80003568 <brelse>
}
    80003810:	8526                	mv	a0,s1
    80003812:	60e6                	ld	ra,88(sp)
    80003814:	6446                	ld	s0,80(sp)
    80003816:	64a6                	ld	s1,72(sp)
    80003818:	6906                	ld	s2,64(sp)
    8000381a:	79e2                	ld	s3,56(sp)
    8000381c:	7a42                	ld	s4,48(sp)
    8000381e:	7aa2                	ld	s5,40(sp)
    80003820:	7b02                	ld	s6,32(sp)
    80003822:	6be2                	ld	s7,24(sp)
    80003824:	6c42                	ld	s8,16(sp)
    80003826:	6ca2                	ld	s9,8(sp)
    80003828:	6125                	addi	sp,sp,96
    8000382a:	8082                	ret

000000008000382c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000382c:	7179                	addi	sp,sp,-48
    8000382e:	f406                	sd	ra,40(sp)
    80003830:	f022                	sd	s0,32(sp)
    80003832:	ec26                	sd	s1,24(sp)
    80003834:	e84a                	sd	s2,16(sp)
    80003836:	e44e                	sd	s3,8(sp)
    80003838:	e052                	sd	s4,0(sp)
    8000383a:	1800                	addi	s0,sp,48
    8000383c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000383e:	47ad                	li	a5,11
    80003840:	04b7fe63          	bgeu	a5,a1,8000389c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003844:	ff45849b          	addiw	s1,a1,-12
    80003848:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000384c:	0ff00793          	li	a5,255
    80003850:	0ae7e363          	bltu	a5,a4,800038f6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003854:	08052583          	lw	a1,128(a0)
    80003858:	c5ad                	beqz	a1,800038c2 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000385a:	00092503          	lw	a0,0(s2)
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	bda080e7          	jalr	-1062(ra) # 80003438 <bread>
    80003866:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003868:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000386c:	02049593          	slli	a1,s1,0x20
    80003870:	9181                	srli	a1,a1,0x20
    80003872:	058a                	slli	a1,a1,0x2
    80003874:	00b784b3          	add	s1,a5,a1
    80003878:	0004a983          	lw	s3,0(s1)
    8000387c:	04098d63          	beqz	s3,800038d6 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003880:	8552                	mv	a0,s4
    80003882:	00000097          	auipc	ra,0x0
    80003886:	ce6080e7          	jalr	-794(ra) # 80003568 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000388a:	854e                	mv	a0,s3
    8000388c:	70a2                	ld	ra,40(sp)
    8000388e:	7402                	ld	s0,32(sp)
    80003890:	64e2                	ld	s1,24(sp)
    80003892:	6942                	ld	s2,16(sp)
    80003894:	69a2                	ld	s3,8(sp)
    80003896:	6a02                	ld	s4,0(sp)
    80003898:	6145                	addi	sp,sp,48
    8000389a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000389c:	02059493          	slli	s1,a1,0x20
    800038a0:	9081                	srli	s1,s1,0x20
    800038a2:	048a                	slli	s1,s1,0x2
    800038a4:	94aa                	add	s1,s1,a0
    800038a6:	0504a983          	lw	s3,80(s1)
    800038aa:	fe0990e3          	bnez	s3,8000388a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800038ae:	4108                	lw	a0,0(a0)
    800038b0:	00000097          	auipc	ra,0x0
    800038b4:	e4a080e7          	jalr	-438(ra) # 800036fa <balloc>
    800038b8:	0005099b          	sext.w	s3,a0
    800038bc:	0534a823          	sw	s3,80(s1)
    800038c0:	b7e9                	j	8000388a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800038c2:	4108                	lw	a0,0(a0)
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	e36080e7          	jalr	-458(ra) # 800036fa <balloc>
    800038cc:	0005059b          	sext.w	a1,a0
    800038d0:	08b92023          	sw	a1,128(s2)
    800038d4:	b759                	j	8000385a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800038d6:	00092503          	lw	a0,0(s2)
    800038da:	00000097          	auipc	ra,0x0
    800038de:	e20080e7          	jalr	-480(ra) # 800036fa <balloc>
    800038e2:	0005099b          	sext.w	s3,a0
    800038e6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800038ea:	8552                	mv	a0,s4
    800038ec:	00001097          	auipc	ra,0x1
    800038f0:	ef8080e7          	jalr	-264(ra) # 800047e4 <log_write>
    800038f4:	b771                	j	80003880 <bmap+0x54>
  panic("bmap: out of range");
    800038f6:	00005517          	auipc	a0,0x5
    800038fa:	dc250513          	addi	a0,a0,-574 # 800086b8 <syscalls+0x130>
    800038fe:	ffffd097          	auipc	ra,0xffffd
    80003902:	cce080e7          	jalr	-818(ra) # 800005cc <panic>

0000000080003906 <iget>:
{
    80003906:	7179                	addi	sp,sp,-48
    80003908:	f406                	sd	ra,40(sp)
    8000390a:	f022                	sd	s0,32(sp)
    8000390c:	ec26                	sd	s1,24(sp)
    8000390e:	e84a                	sd	s2,16(sp)
    80003910:	e44e                	sd	s3,8(sp)
    80003912:	e052                	sd	s4,0(sp)
    80003914:	1800                	addi	s0,sp,48
    80003916:	89aa                	mv	s3,a0
    80003918:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000391a:	0001d517          	auipc	a0,0x1d
    8000391e:	9ce50513          	addi	a0,a0,-1586 # 800202e8 <itable>
    80003922:	ffffd097          	auipc	ra,0xffffd
    80003926:	318080e7          	jalr	792(ra) # 80000c3a <acquire>
  empty = 0;
    8000392a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000392c:	0001d497          	auipc	s1,0x1d
    80003930:	9d448493          	addi	s1,s1,-1580 # 80020300 <itable+0x18>
    80003934:	0001e697          	auipc	a3,0x1e
    80003938:	45c68693          	addi	a3,a3,1116 # 80021d90 <log>
    8000393c:	a039                	j	8000394a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000393e:	02090b63          	beqz	s2,80003974 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003942:	08848493          	addi	s1,s1,136
    80003946:	02d48a63          	beq	s1,a3,8000397a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000394a:	449c                	lw	a5,8(s1)
    8000394c:	fef059e3          	blez	a5,8000393e <iget+0x38>
    80003950:	4098                	lw	a4,0(s1)
    80003952:	ff3716e3          	bne	a4,s3,8000393e <iget+0x38>
    80003956:	40d8                	lw	a4,4(s1)
    80003958:	ff4713e3          	bne	a4,s4,8000393e <iget+0x38>
      ip->ref++;
    8000395c:	2785                	addiw	a5,a5,1
    8000395e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003960:	0001d517          	auipc	a0,0x1d
    80003964:	98850513          	addi	a0,a0,-1656 # 800202e8 <itable>
    80003968:	ffffd097          	auipc	ra,0xffffd
    8000396c:	386080e7          	jalr	902(ra) # 80000cee <release>
      return ip;
    80003970:	8926                	mv	s2,s1
    80003972:	a03d                	j	800039a0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003974:	f7f9                	bnez	a5,80003942 <iget+0x3c>
    80003976:	8926                	mv	s2,s1
    80003978:	b7e9                	j	80003942 <iget+0x3c>
  if(empty == 0)
    8000397a:	02090c63          	beqz	s2,800039b2 <iget+0xac>
  ip->dev = dev;
    8000397e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003982:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003986:	4785                	li	a5,1
    80003988:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000398c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003990:	0001d517          	auipc	a0,0x1d
    80003994:	95850513          	addi	a0,a0,-1704 # 800202e8 <itable>
    80003998:	ffffd097          	auipc	ra,0xffffd
    8000399c:	356080e7          	jalr	854(ra) # 80000cee <release>
}
    800039a0:	854a                	mv	a0,s2
    800039a2:	70a2                	ld	ra,40(sp)
    800039a4:	7402                	ld	s0,32(sp)
    800039a6:	64e2                	ld	s1,24(sp)
    800039a8:	6942                	ld	s2,16(sp)
    800039aa:	69a2                	ld	s3,8(sp)
    800039ac:	6a02                	ld	s4,0(sp)
    800039ae:	6145                	addi	sp,sp,48
    800039b0:	8082                	ret
    panic("iget: no inodes");
    800039b2:	00005517          	auipc	a0,0x5
    800039b6:	d1e50513          	addi	a0,a0,-738 # 800086d0 <syscalls+0x148>
    800039ba:	ffffd097          	auipc	ra,0xffffd
    800039be:	c12080e7          	jalr	-1006(ra) # 800005cc <panic>

00000000800039c2 <fsinit>:
fsinit(int dev) {
    800039c2:	7179                	addi	sp,sp,-48
    800039c4:	f406                	sd	ra,40(sp)
    800039c6:	f022                	sd	s0,32(sp)
    800039c8:	ec26                	sd	s1,24(sp)
    800039ca:	e84a                	sd	s2,16(sp)
    800039cc:	e44e                	sd	s3,8(sp)
    800039ce:	1800                	addi	s0,sp,48
    800039d0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800039d2:	4585                	li	a1,1
    800039d4:	00000097          	auipc	ra,0x0
    800039d8:	a64080e7          	jalr	-1436(ra) # 80003438 <bread>
    800039dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039de:	0001d997          	auipc	s3,0x1d
    800039e2:	8ea98993          	addi	s3,s3,-1814 # 800202c8 <sb>
    800039e6:	02000613          	li	a2,32
    800039ea:	05850593          	addi	a1,a0,88
    800039ee:	854e                	mv	a0,s3
    800039f0:	ffffd097          	auipc	ra,0xffffd
    800039f4:	3a2080e7          	jalr	930(ra) # 80000d92 <memmove>
  brelse(bp);
    800039f8:	8526                	mv	a0,s1
    800039fa:	00000097          	auipc	ra,0x0
    800039fe:	b6e080e7          	jalr	-1170(ra) # 80003568 <brelse>
  if(sb.magic != FSMAGIC)
    80003a02:	0009a703          	lw	a4,0(s3)
    80003a06:	102037b7          	lui	a5,0x10203
    80003a0a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a0e:	02f71263          	bne	a4,a5,80003a32 <fsinit+0x70>
  initlog(dev, &sb);
    80003a12:	0001d597          	auipc	a1,0x1d
    80003a16:	8b658593          	addi	a1,a1,-1866 # 800202c8 <sb>
    80003a1a:	854a                	mv	a0,s2
    80003a1c:	00001097          	auipc	ra,0x1
    80003a20:	b4c080e7          	jalr	-1204(ra) # 80004568 <initlog>
}
    80003a24:	70a2                	ld	ra,40(sp)
    80003a26:	7402                	ld	s0,32(sp)
    80003a28:	64e2                	ld	s1,24(sp)
    80003a2a:	6942                	ld	s2,16(sp)
    80003a2c:	69a2                	ld	s3,8(sp)
    80003a2e:	6145                	addi	sp,sp,48
    80003a30:	8082                	ret
    panic("invalid file system");
    80003a32:	00005517          	auipc	a0,0x5
    80003a36:	cae50513          	addi	a0,a0,-850 # 800086e0 <syscalls+0x158>
    80003a3a:	ffffd097          	auipc	ra,0xffffd
    80003a3e:	b92080e7          	jalr	-1134(ra) # 800005cc <panic>

0000000080003a42 <iinit>:
{
    80003a42:	7179                	addi	sp,sp,-48
    80003a44:	f406                	sd	ra,40(sp)
    80003a46:	f022                	sd	s0,32(sp)
    80003a48:	ec26                	sd	s1,24(sp)
    80003a4a:	e84a                	sd	s2,16(sp)
    80003a4c:	e44e                	sd	s3,8(sp)
    80003a4e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a50:	00005597          	auipc	a1,0x5
    80003a54:	ca858593          	addi	a1,a1,-856 # 800086f8 <syscalls+0x170>
    80003a58:	0001d517          	auipc	a0,0x1d
    80003a5c:	89050513          	addi	a0,a0,-1904 # 800202e8 <itable>
    80003a60:	ffffd097          	auipc	ra,0xffffd
    80003a64:	14a080e7          	jalr	330(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a68:	0001d497          	auipc	s1,0x1d
    80003a6c:	8a848493          	addi	s1,s1,-1880 # 80020310 <itable+0x28>
    80003a70:	0001e997          	auipc	s3,0x1e
    80003a74:	33098993          	addi	s3,s3,816 # 80021da0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a78:	00005917          	auipc	s2,0x5
    80003a7c:	c8890913          	addi	s2,s2,-888 # 80008700 <syscalls+0x178>
    80003a80:	85ca                	mv	a1,s2
    80003a82:	8526                	mv	a0,s1
    80003a84:	00001097          	auipc	ra,0x1
    80003a88:	e46080e7          	jalr	-442(ra) # 800048ca <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a8c:	08848493          	addi	s1,s1,136
    80003a90:	ff3498e3          	bne	s1,s3,80003a80 <iinit+0x3e>
}
    80003a94:	70a2                	ld	ra,40(sp)
    80003a96:	7402                	ld	s0,32(sp)
    80003a98:	64e2                	ld	s1,24(sp)
    80003a9a:	6942                	ld	s2,16(sp)
    80003a9c:	69a2                	ld	s3,8(sp)
    80003a9e:	6145                	addi	sp,sp,48
    80003aa0:	8082                	ret

0000000080003aa2 <ialloc>:
{
    80003aa2:	715d                	addi	sp,sp,-80
    80003aa4:	e486                	sd	ra,72(sp)
    80003aa6:	e0a2                	sd	s0,64(sp)
    80003aa8:	fc26                	sd	s1,56(sp)
    80003aaa:	f84a                	sd	s2,48(sp)
    80003aac:	f44e                	sd	s3,40(sp)
    80003aae:	f052                	sd	s4,32(sp)
    80003ab0:	ec56                	sd	s5,24(sp)
    80003ab2:	e85a                	sd	s6,16(sp)
    80003ab4:	e45e                	sd	s7,8(sp)
    80003ab6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ab8:	0001d717          	auipc	a4,0x1d
    80003abc:	81c72703          	lw	a4,-2020(a4) # 800202d4 <sb+0xc>
    80003ac0:	4785                	li	a5,1
    80003ac2:	04e7fa63          	bgeu	a5,a4,80003b16 <ialloc+0x74>
    80003ac6:	8aaa                	mv	s5,a0
    80003ac8:	8bae                	mv	s7,a1
    80003aca:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003acc:	0001ca17          	auipc	s4,0x1c
    80003ad0:	7fca0a13          	addi	s4,s4,2044 # 800202c8 <sb>
    80003ad4:	00048b1b          	sext.w	s6,s1
    80003ad8:	0044d793          	srli	a5,s1,0x4
    80003adc:	018a2583          	lw	a1,24(s4)
    80003ae0:	9dbd                	addw	a1,a1,a5
    80003ae2:	8556                	mv	a0,s5
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	954080e7          	jalr	-1708(ra) # 80003438 <bread>
    80003aec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003aee:	05850993          	addi	s3,a0,88
    80003af2:	00f4f793          	andi	a5,s1,15
    80003af6:	079a                	slli	a5,a5,0x6
    80003af8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003afa:	00099783          	lh	a5,0(s3)
    80003afe:	c785                	beqz	a5,80003b26 <ialloc+0x84>
    brelse(bp);
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	a68080e7          	jalr	-1432(ra) # 80003568 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b08:	0485                	addi	s1,s1,1
    80003b0a:	00ca2703          	lw	a4,12(s4)
    80003b0e:	0004879b          	sext.w	a5,s1
    80003b12:	fce7e1e3          	bltu	a5,a4,80003ad4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003b16:	00005517          	auipc	a0,0x5
    80003b1a:	bf250513          	addi	a0,a0,-1038 # 80008708 <syscalls+0x180>
    80003b1e:	ffffd097          	auipc	ra,0xffffd
    80003b22:	aae080e7          	jalr	-1362(ra) # 800005cc <panic>
      memset(dip, 0, sizeof(*dip));
    80003b26:	04000613          	li	a2,64
    80003b2a:	4581                	li	a1,0
    80003b2c:	854e                	mv	a0,s3
    80003b2e:	ffffd097          	auipc	ra,0xffffd
    80003b32:	208080e7          	jalr	520(ra) # 80000d36 <memset>
      dip->type = type;
    80003b36:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b3a:	854a                	mv	a0,s2
    80003b3c:	00001097          	auipc	ra,0x1
    80003b40:	ca8080e7          	jalr	-856(ra) # 800047e4 <log_write>
      brelse(bp);
    80003b44:	854a                	mv	a0,s2
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	a22080e7          	jalr	-1502(ra) # 80003568 <brelse>
      return iget(dev, inum);
    80003b4e:	85da                	mv	a1,s6
    80003b50:	8556                	mv	a0,s5
    80003b52:	00000097          	auipc	ra,0x0
    80003b56:	db4080e7          	jalr	-588(ra) # 80003906 <iget>
}
    80003b5a:	60a6                	ld	ra,72(sp)
    80003b5c:	6406                	ld	s0,64(sp)
    80003b5e:	74e2                	ld	s1,56(sp)
    80003b60:	7942                	ld	s2,48(sp)
    80003b62:	79a2                	ld	s3,40(sp)
    80003b64:	7a02                	ld	s4,32(sp)
    80003b66:	6ae2                	ld	s5,24(sp)
    80003b68:	6b42                	ld	s6,16(sp)
    80003b6a:	6ba2                	ld	s7,8(sp)
    80003b6c:	6161                	addi	sp,sp,80
    80003b6e:	8082                	ret

0000000080003b70 <iupdate>:
{
    80003b70:	1101                	addi	sp,sp,-32
    80003b72:	ec06                	sd	ra,24(sp)
    80003b74:	e822                	sd	s0,16(sp)
    80003b76:	e426                	sd	s1,8(sp)
    80003b78:	e04a                	sd	s2,0(sp)
    80003b7a:	1000                	addi	s0,sp,32
    80003b7c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b7e:	415c                	lw	a5,4(a0)
    80003b80:	0047d79b          	srliw	a5,a5,0x4
    80003b84:	0001c597          	auipc	a1,0x1c
    80003b88:	75c5a583          	lw	a1,1884(a1) # 800202e0 <sb+0x18>
    80003b8c:	9dbd                	addw	a1,a1,a5
    80003b8e:	4108                	lw	a0,0(a0)
    80003b90:	00000097          	auipc	ra,0x0
    80003b94:	8a8080e7          	jalr	-1880(ra) # 80003438 <bread>
    80003b98:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b9a:	05850793          	addi	a5,a0,88
    80003b9e:	40c8                	lw	a0,4(s1)
    80003ba0:	893d                	andi	a0,a0,15
    80003ba2:	051a                	slli	a0,a0,0x6
    80003ba4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003ba6:	04449703          	lh	a4,68(s1)
    80003baa:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003bae:	04649703          	lh	a4,70(s1)
    80003bb2:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003bb6:	04849703          	lh	a4,72(s1)
    80003bba:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003bbe:	04a49703          	lh	a4,74(s1)
    80003bc2:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003bc6:	44f8                	lw	a4,76(s1)
    80003bc8:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003bca:	03400613          	li	a2,52
    80003bce:	05048593          	addi	a1,s1,80
    80003bd2:	0531                	addi	a0,a0,12
    80003bd4:	ffffd097          	auipc	ra,0xffffd
    80003bd8:	1be080e7          	jalr	446(ra) # 80000d92 <memmove>
  log_write(bp);
    80003bdc:	854a                	mv	a0,s2
    80003bde:	00001097          	auipc	ra,0x1
    80003be2:	c06080e7          	jalr	-1018(ra) # 800047e4 <log_write>
  brelse(bp);
    80003be6:	854a                	mv	a0,s2
    80003be8:	00000097          	auipc	ra,0x0
    80003bec:	980080e7          	jalr	-1664(ra) # 80003568 <brelse>
}
    80003bf0:	60e2                	ld	ra,24(sp)
    80003bf2:	6442                	ld	s0,16(sp)
    80003bf4:	64a2                	ld	s1,8(sp)
    80003bf6:	6902                	ld	s2,0(sp)
    80003bf8:	6105                	addi	sp,sp,32
    80003bfa:	8082                	ret

0000000080003bfc <idup>:
{
    80003bfc:	1101                	addi	sp,sp,-32
    80003bfe:	ec06                	sd	ra,24(sp)
    80003c00:	e822                	sd	s0,16(sp)
    80003c02:	e426                	sd	s1,8(sp)
    80003c04:	1000                	addi	s0,sp,32
    80003c06:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c08:	0001c517          	auipc	a0,0x1c
    80003c0c:	6e050513          	addi	a0,a0,1760 # 800202e8 <itable>
    80003c10:	ffffd097          	auipc	ra,0xffffd
    80003c14:	02a080e7          	jalr	42(ra) # 80000c3a <acquire>
  ip->ref++;
    80003c18:	449c                	lw	a5,8(s1)
    80003c1a:	2785                	addiw	a5,a5,1
    80003c1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c1e:	0001c517          	auipc	a0,0x1c
    80003c22:	6ca50513          	addi	a0,a0,1738 # 800202e8 <itable>
    80003c26:	ffffd097          	auipc	ra,0xffffd
    80003c2a:	0c8080e7          	jalr	200(ra) # 80000cee <release>
}
    80003c2e:	8526                	mv	a0,s1
    80003c30:	60e2                	ld	ra,24(sp)
    80003c32:	6442                	ld	s0,16(sp)
    80003c34:	64a2                	ld	s1,8(sp)
    80003c36:	6105                	addi	sp,sp,32
    80003c38:	8082                	ret

0000000080003c3a <ilock>:
{
    80003c3a:	1101                	addi	sp,sp,-32
    80003c3c:	ec06                	sd	ra,24(sp)
    80003c3e:	e822                	sd	s0,16(sp)
    80003c40:	e426                	sd	s1,8(sp)
    80003c42:	e04a                	sd	s2,0(sp)
    80003c44:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c46:	c115                	beqz	a0,80003c6a <ilock+0x30>
    80003c48:	84aa                	mv	s1,a0
    80003c4a:	451c                	lw	a5,8(a0)
    80003c4c:	00f05f63          	blez	a5,80003c6a <ilock+0x30>
  acquiresleep(&ip->lock);
    80003c50:	0541                	addi	a0,a0,16
    80003c52:	00001097          	auipc	ra,0x1
    80003c56:	cb2080e7          	jalr	-846(ra) # 80004904 <acquiresleep>
  if(ip->valid == 0){
    80003c5a:	40bc                	lw	a5,64(s1)
    80003c5c:	cf99                	beqz	a5,80003c7a <ilock+0x40>
}
    80003c5e:	60e2                	ld	ra,24(sp)
    80003c60:	6442                	ld	s0,16(sp)
    80003c62:	64a2                	ld	s1,8(sp)
    80003c64:	6902                	ld	s2,0(sp)
    80003c66:	6105                	addi	sp,sp,32
    80003c68:	8082                	ret
    panic("ilock");
    80003c6a:	00005517          	auipc	a0,0x5
    80003c6e:	ab650513          	addi	a0,a0,-1354 # 80008720 <syscalls+0x198>
    80003c72:	ffffd097          	auipc	ra,0xffffd
    80003c76:	95a080e7          	jalr	-1702(ra) # 800005cc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c7a:	40dc                	lw	a5,4(s1)
    80003c7c:	0047d79b          	srliw	a5,a5,0x4
    80003c80:	0001c597          	auipc	a1,0x1c
    80003c84:	6605a583          	lw	a1,1632(a1) # 800202e0 <sb+0x18>
    80003c88:	9dbd                	addw	a1,a1,a5
    80003c8a:	4088                	lw	a0,0(s1)
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	7ac080e7          	jalr	1964(ra) # 80003438 <bread>
    80003c94:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c96:	05850593          	addi	a1,a0,88
    80003c9a:	40dc                	lw	a5,4(s1)
    80003c9c:	8bbd                	andi	a5,a5,15
    80003c9e:	079a                	slli	a5,a5,0x6
    80003ca0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ca2:	00059783          	lh	a5,0(a1)
    80003ca6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003caa:	00259783          	lh	a5,2(a1)
    80003cae:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003cb2:	00459783          	lh	a5,4(a1)
    80003cb6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003cba:	00659783          	lh	a5,6(a1)
    80003cbe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003cc2:	459c                	lw	a5,8(a1)
    80003cc4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003cc6:	03400613          	li	a2,52
    80003cca:	05b1                	addi	a1,a1,12
    80003ccc:	05048513          	addi	a0,s1,80
    80003cd0:	ffffd097          	auipc	ra,0xffffd
    80003cd4:	0c2080e7          	jalr	194(ra) # 80000d92 <memmove>
    brelse(bp);
    80003cd8:	854a                	mv	a0,s2
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	88e080e7          	jalr	-1906(ra) # 80003568 <brelse>
    ip->valid = 1;
    80003ce2:	4785                	li	a5,1
    80003ce4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003ce6:	04449783          	lh	a5,68(s1)
    80003cea:	fbb5                	bnez	a5,80003c5e <ilock+0x24>
      panic("ilock: no type");
    80003cec:	00005517          	auipc	a0,0x5
    80003cf0:	a3c50513          	addi	a0,a0,-1476 # 80008728 <syscalls+0x1a0>
    80003cf4:	ffffd097          	auipc	ra,0xffffd
    80003cf8:	8d8080e7          	jalr	-1832(ra) # 800005cc <panic>

0000000080003cfc <iunlock>:
{
    80003cfc:	1101                	addi	sp,sp,-32
    80003cfe:	ec06                	sd	ra,24(sp)
    80003d00:	e822                	sd	s0,16(sp)
    80003d02:	e426                	sd	s1,8(sp)
    80003d04:	e04a                	sd	s2,0(sp)
    80003d06:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d08:	c905                	beqz	a0,80003d38 <iunlock+0x3c>
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	01050913          	addi	s2,a0,16
    80003d10:	854a                	mv	a0,s2
    80003d12:	00001097          	auipc	ra,0x1
    80003d16:	c8c080e7          	jalr	-884(ra) # 8000499e <holdingsleep>
    80003d1a:	cd19                	beqz	a0,80003d38 <iunlock+0x3c>
    80003d1c:	449c                	lw	a5,8(s1)
    80003d1e:	00f05d63          	blez	a5,80003d38 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d22:	854a                	mv	a0,s2
    80003d24:	00001097          	auipc	ra,0x1
    80003d28:	c36080e7          	jalr	-970(ra) # 8000495a <releasesleep>
}
    80003d2c:	60e2                	ld	ra,24(sp)
    80003d2e:	6442                	ld	s0,16(sp)
    80003d30:	64a2                	ld	s1,8(sp)
    80003d32:	6902                	ld	s2,0(sp)
    80003d34:	6105                	addi	sp,sp,32
    80003d36:	8082                	ret
    panic("iunlock");
    80003d38:	00005517          	auipc	a0,0x5
    80003d3c:	a0050513          	addi	a0,a0,-1536 # 80008738 <syscalls+0x1b0>
    80003d40:	ffffd097          	auipc	ra,0xffffd
    80003d44:	88c080e7          	jalr	-1908(ra) # 800005cc <panic>

0000000080003d48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d48:	7179                	addi	sp,sp,-48
    80003d4a:	f406                	sd	ra,40(sp)
    80003d4c:	f022                	sd	s0,32(sp)
    80003d4e:	ec26                	sd	s1,24(sp)
    80003d50:	e84a                	sd	s2,16(sp)
    80003d52:	e44e                	sd	s3,8(sp)
    80003d54:	e052                	sd	s4,0(sp)
    80003d56:	1800                	addi	s0,sp,48
    80003d58:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d5a:	05050493          	addi	s1,a0,80
    80003d5e:	08050913          	addi	s2,a0,128
    80003d62:	a021                	j	80003d6a <itrunc+0x22>
    80003d64:	0491                	addi	s1,s1,4
    80003d66:	01248d63          	beq	s1,s2,80003d80 <itrunc+0x38>
    if(ip->addrs[i]){
    80003d6a:	408c                	lw	a1,0(s1)
    80003d6c:	dde5                	beqz	a1,80003d64 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003d6e:	0009a503          	lw	a0,0(s3)
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	90c080e7          	jalr	-1780(ra) # 8000367e <bfree>
      ip->addrs[i] = 0;
    80003d7a:	0004a023          	sw	zero,0(s1)
    80003d7e:	b7dd                	j	80003d64 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d80:	0809a583          	lw	a1,128(s3)
    80003d84:	e185                	bnez	a1,80003da4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d8a:	854e                	mv	a0,s3
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	de4080e7          	jalr	-540(ra) # 80003b70 <iupdate>
}
    80003d94:	70a2                	ld	ra,40(sp)
    80003d96:	7402                	ld	s0,32(sp)
    80003d98:	64e2                	ld	s1,24(sp)
    80003d9a:	6942                	ld	s2,16(sp)
    80003d9c:	69a2                	ld	s3,8(sp)
    80003d9e:	6a02                	ld	s4,0(sp)
    80003da0:	6145                	addi	sp,sp,48
    80003da2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003da4:	0009a503          	lw	a0,0(s3)
    80003da8:	fffff097          	auipc	ra,0xfffff
    80003dac:	690080e7          	jalr	1680(ra) # 80003438 <bread>
    80003db0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003db2:	05850493          	addi	s1,a0,88
    80003db6:	45850913          	addi	s2,a0,1112
    80003dba:	a021                	j	80003dc2 <itrunc+0x7a>
    80003dbc:	0491                	addi	s1,s1,4
    80003dbe:	01248b63          	beq	s1,s2,80003dd4 <itrunc+0x8c>
      if(a[j])
    80003dc2:	408c                	lw	a1,0(s1)
    80003dc4:	dde5                	beqz	a1,80003dbc <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003dc6:	0009a503          	lw	a0,0(s3)
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	8b4080e7          	jalr	-1868(ra) # 8000367e <bfree>
    80003dd2:	b7ed                	j	80003dbc <itrunc+0x74>
    brelse(bp);
    80003dd4:	8552                	mv	a0,s4
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	792080e7          	jalr	1938(ra) # 80003568 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003dde:	0809a583          	lw	a1,128(s3)
    80003de2:	0009a503          	lw	a0,0(s3)
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	898080e7          	jalr	-1896(ra) # 8000367e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003dee:	0809a023          	sw	zero,128(s3)
    80003df2:	bf51                	j	80003d86 <itrunc+0x3e>

0000000080003df4 <iput>:
{
    80003df4:	1101                	addi	sp,sp,-32
    80003df6:	ec06                	sd	ra,24(sp)
    80003df8:	e822                	sd	s0,16(sp)
    80003dfa:	e426                	sd	s1,8(sp)
    80003dfc:	e04a                	sd	s2,0(sp)
    80003dfe:	1000                	addi	s0,sp,32
    80003e00:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e02:	0001c517          	auipc	a0,0x1c
    80003e06:	4e650513          	addi	a0,a0,1254 # 800202e8 <itable>
    80003e0a:	ffffd097          	auipc	ra,0xffffd
    80003e0e:	e30080e7          	jalr	-464(ra) # 80000c3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e12:	4498                	lw	a4,8(s1)
    80003e14:	4785                	li	a5,1
    80003e16:	02f70363          	beq	a4,a5,80003e3c <iput+0x48>
  ip->ref--;
    80003e1a:	449c                	lw	a5,8(s1)
    80003e1c:	37fd                	addiw	a5,a5,-1
    80003e1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e20:	0001c517          	auipc	a0,0x1c
    80003e24:	4c850513          	addi	a0,a0,1224 # 800202e8 <itable>
    80003e28:	ffffd097          	auipc	ra,0xffffd
    80003e2c:	ec6080e7          	jalr	-314(ra) # 80000cee <release>
}
    80003e30:	60e2                	ld	ra,24(sp)
    80003e32:	6442                	ld	s0,16(sp)
    80003e34:	64a2                	ld	s1,8(sp)
    80003e36:	6902                	ld	s2,0(sp)
    80003e38:	6105                	addi	sp,sp,32
    80003e3a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e3c:	40bc                	lw	a5,64(s1)
    80003e3e:	dff1                	beqz	a5,80003e1a <iput+0x26>
    80003e40:	04a49783          	lh	a5,74(s1)
    80003e44:	fbf9                	bnez	a5,80003e1a <iput+0x26>
    acquiresleep(&ip->lock);
    80003e46:	01048913          	addi	s2,s1,16
    80003e4a:	854a                	mv	a0,s2
    80003e4c:	00001097          	auipc	ra,0x1
    80003e50:	ab8080e7          	jalr	-1352(ra) # 80004904 <acquiresleep>
    release(&itable.lock);
    80003e54:	0001c517          	auipc	a0,0x1c
    80003e58:	49450513          	addi	a0,a0,1172 # 800202e8 <itable>
    80003e5c:	ffffd097          	auipc	ra,0xffffd
    80003e60:	e92080e7          	jalr	-366(ra) # 80000cee <release>
    itrunc(ip);
    80003e64:	8526                	mv	a0,s1
    80003e66:	00000097          	auipc	ra,0x0
    80003e6a:	ee2080e7          	jalr	-286(ra) # 80003d48 <itrunc>
    ip->type = 0;
    80003e6e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e72:	8526                	mv	a0,s1
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	cfc080e7          	jalr	-772(ra) # 80003b70 <iupdate>
    ip->valid = 0;
    80003e7c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e80:	854a                	mv	a0,s2
    80003e82:	00001097          	auipc	ra,0x1
    80003e86:	ad8080e7          	jalr	-1320(ra) # 8000495a <releasesleep>
    acquire(&itable.lock);
    80003e8a:	0001c517          	auipc	a0,0x1c
    80003e8e:	45e50513          	addi	a0,a0,1118 # 800202e8 <itable>
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	da8080e7          	jalr	-600(ra) # 80000c3a <acquire>
    80003e9a:	b741                	j	80003e1a <iput+0x26>

0000000080003e9c <iunlockput>:
{
    80003e9c:	1101                	addi	sp,sp,-32
    80003e9e:	ec06                	sd	ra,24(sp)
    80003ea0:	e822                	sd	s0,16(sp)
    80003ea2:	e426                	sd	s1,8(sp)
    80003ea4:	1000                	addi	s0,sp,32
    80003ea6:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ea8:	00000097          	auipc	ra,0x0
    80003eac:	e54080e7          	jalr	-428(ra) # 80003cfc <iunlock>
  iput(ip);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	f42080e7          	jalr	-190(ra) # 80003df4 <iput>
}
    80003eba:	60e2                	ld	ra,24(sp)
    80003ebc:	6442                	ld	s0,16(sp)
    80003ebe:	64a2                	ld	s1,8(sp)
    80003ec0:	6105                	addi	sp,sp,32
    80003ec2:	8082                	ret

0000000080003ec4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003ec4:	1141                	addi	sp,sp,-16
    80003ec6:	e422                	sd	s0,8(sp)
    80003ec8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003eca:	411c                	lw	a5,0(a0)
    80003ecc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003ece:	415c                	lw	a5,4(a0)
    80003ed0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003ed2:	04451783          	lh	a5,68(a0)
    80003ed6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003eda:	04a51783          	lh	a5,74(a0)
    80003ede:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003ee2:	04c56783          	lwu	a5,76(a0)
    80003ee6:	e99c                	sd	a5,16(a1)
}
    80003ee8:	6422                	ld	s0,8(sp)
    80003eea:	0141                	addi	sp,sp,16
    80003eec:	8082                	ret

0000000080003eee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003eee:	457c                	lw	a5,76(a0)
    80003ef0:	0ed7e963          	bltu	a5,a3,80003fe2 <readi+0xf4>
{
    80003ef4:	7159                	addi	sp,sp,-112
    80003ef6:	f486                	sd	ra,104(sp)
    80003ef8:	f0a2                	sd	s0,96(sp)
    80003efa:	eca6                	sd	s1,88(sp)
    80003efc:	e8ca                	sd	s2,80(sp)
    80003efe:	e4ce                	sd	s3,72(sp)
    80003f00:	e0d2                	sd	s4,64(sp)
    80003f02:	fc56                	sd	s5,56(sp)
    80003f04:	f85a                	sd	s6,48(sp)
    80003f06:	f45e                	sd	s7,40(sp)
    80003f08:	f062                	sd	s8,32(sp)
    80003f0a:	ec66                	sd	s9,24(sp)
    80003f0c:	e86a                	sd	s10,16(sp)
    80003f0e:	e46e                	sd	s11,8(sp)
    80003f10:	1880                	addi	s0,sp,112
    80003f12:	8baa                	mv	s7,a0
    80003f14:	8c2e                	mv	s8,a1
    80003f16:	8ab2                	mv	s5,a2
    80003f18:	84b6                	mv	s1,a3
    80003f1a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f1c:	9f35                	addw	a4,a4,a3
    return 0;
    80003f1e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f20:	0ad76063          	bltu	a4,a3,80003fc0 <readi+0xd2>
  if(off + n > ip->size)
    80003f24:	00e7f463          	bgeu	a5,a4,80003f2c <readi+0x3e>
    n = ip->size - off;
    80003f28:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f2c:	0a0b0963          	beqz	s6,80003fde <readi+0xf0>
    80003f30:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f32:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f36:	5cfd                	li	s9,-1
    80003f38:	a82d                	j	80003f72 <readi+0x84>
    80003f3a:	020a1d93          	slli	s11,s4,0x20
    80003f3e:	020ddd93          	srli	s11,s11,0x20
    80003f42:	05890793          	addi	a5,s2,88
    80003f46:	86ee                	mv	a3,s11
    80003f48:	963e                	add	a2,a2,a5
    80003f4a:	85d6                	mv	a1,s5
    80003f4c:	8562                	mv	a0,s8
    80003f4e:	fffff097          	auipc	ra,0xfffff
    80003f52:	974080e7          	jalr	-1676(ra) # 800028c2 <either_copyout>
    80003f56:	05950d63          	beq	a0,s9,80003fb0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f5a:	854a                	mv	a0,s2
    80003f5c:	fffff097          	auipc	ra,0xfffff
    80003f60:	60c080e7          	jalr	1548(ra) # 80003568 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f64:	013a09bb          	addw	s3,s4,s3
    80003f68:	009a04bb          	addw	s1,s4,s1
    80003f6c:	9aee                	add	s5,s5,s11
    80003f6e:	0569f763          	bgeu	s3,s6,80003fbc <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003f72:	000ba903          	lw	s2,0(s7)
    80003f76:	00a4d59b          	srliw	a1,s1,0xa
    80003f7a:	855e                	mv	a0,s7
    80003f7c:	00000097          	auipc	ra,0x0
    80003f80:	8b0080e7          	jalr	-1872(ra) # 8000382c <bmap>
    80003f84:	0005059b          	sext.w	a1,a0
    80003f88:	854a                	mv	a0,s2
    80003f8a:	fffff097          	auipc	ra,0xfffff
    80003f8e:	4ae080e7          	jalr	1198(ra) # 80003438 <bread>
    80003f92:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f94:	3ff4f613          	andi	a2,s1,1023
    80003f98:	40cd07bb          	subw	a5,s10,a2
    80003f9c:	413b073b          	subw	a4,s6,s3
    80003fa0:	8a3e                	mv	s4,a5
    80003fa2:	2781                	sext.w	a5,a5
    80003fa4:	0007069b          	sext.w	a3,a4
    80003fa8:	f8f6f9e3          	bgeu	a3,a5,80003f3a <readi+0x4c>
    80003fac:	8a3a                	mv	s4,a4
    80003fae:	b771                	j	80003f3a <readi+0x4c>
      brelse(bp);
    80003fb0:	854a                	mv	a0,s2
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	5b6080e7          	jalr	1462(ra) # 80003568 <brelse>
      tot = -1;
    80003fba:	59fd                	li	s3,-1
  }
  return tot;
    80003fbc:	0009851b          	sext.w	a0,s3
}
    80003fc0:	70a6                	ld	ra,104(sp)
    80003fc2:	7406                	ld	s0,96(sp)
    80003fc4:	64e6                	ld	s1,88(sp)
    80003fc6:	6946                	ld	s2,80(sp)
    80003fc8:	69a6                	ld	s3,72(sp)
    80003fca:	6a06                	ld	s4,64(sp)
    80003fcc:	7ae2                	ld	s5,56(sp)
    80003fce:	7b42                	ld	s6,48(sp)
    80003fd0:	7ba2                	ld	s7,40(sp)
    80003fd2:	7c02                	ld	s8,32(sp)
    80003fd4:	6ce2                	ld	s9,24(sp)
    80003fd6:	6d42                	ld	s10,16(sp)
    80003fd8:	6da2                	ld	s11,8(sp)
    80003fda:	6165                	addi	sp,sp,112
    80003fdc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fde:	89da                	mv	s3,s6
    80003fe0:	bff1                	j	80003fbc <readi+0xce>
    return 0;
    80003fe2:	4501                	li	a0,0
}
    80003fe4:	8082                	ret

0000000080003fe6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fe6:	457c                	lw	a5,76(a0)
    80003fe8:	10d7e863          	bltu	a5,a3,800040f8 <writei+0x112>
{
    80003fec:	7159                	addi	sp,sp,-112
    80003fee:	f486                	sd	ra,104(sp)
    80003ff0:	f0a2                	sd	s0,96(sp)
    80003ff2:	eca6                	sd	s1,88(sp)
    80003ff4:	e8ca                	sd	s2,80(sp)
    80003ff6:	e4ce                	sd	s3,72(sp)
    80003ff8:	e0d2                	sd	s4,64(sp)
    80003ffa:	fc56                	sd	s5,56(sp)
    80003ffc:	f85a                	sd	s6,48(sp)
    80003ffe:	f45e                	sd	s7,40(sp)
    80004000:	f062                	sd	s8,32(sp)
    80004002:	ec66                	sd	s9,24(sp)
    80004004:	e86a                	sd	s10,16(sp)
    80004006:	e46e                	sd	s11,8(sp)
    80004008:	1880                	addi	s0,sp,112
    8000400a:	8b2a                	mv	s6,a0
    8000400c:	8c2e                	mv	s8,a1
    8000400e:	8ab2                	mv	s5,a2
    80004010:	8936                	mv	s2,a3
    80004012:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80004014:	00e687bb          	addw	a5,a3,a4
    80004018:	0ed7e263          	bltu	a5,a3,800040fc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000401c:	00043737          	lui	a4,0x43
    80004020:	0ef76063          	bltu	a4,a5,80004100 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004024:	0c0b8863          	beqz	s7,800040f4 <writei+0x10e>
    80004028:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000402a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000402e:	5cfd                	li	s9,-1
    80004030:	a091                	j	80004074 <writei+0x8e>
    80004032:	02099d93          	slli	s11,s3,0x20
    80004036:	020ddd93          	srli	s11,s11,0x20
    8000403a:	05848793          	addi	a5,s1,88
    8000403e:	86ee                	mv	a3,s11
    80004040:	8656                	mv	a2,s5
    80004042:	85e2                	mv	a1,s8
    80004044:	953e                	add	a0,a0,a5
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	8d2080e7          	jalr	-1838(ra) # 80002918 <either_copyin>
    8000404e:	07950263          	beq	a0,s9,800040b2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004052:	8526                	mv	a0,s1
    80004054:	00000097          	auipc	ra,0x0
    80004058:	790080e7          	jalr	1936(ra) # 800047e4 <log_write>
    brelse(bp);
    8000405c:	8526                	mv	a0,s1
    8000405e:	fffff097          	auipc	ra,0xfffff
    80004062:	50a080e7          	jalr	1290(ra) # 80003568 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004066:	01498a3b          	addw	s4,s3,s4
    8000406a:	0129893b          	addw	s2,s3,s2
    8000406e:	9aee                	add	s5,s5,s11
    80004070:	057a7663          	bgeu	s4,s7,800040bc <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004074:	000b2483          	lw	s1,0(s6)
    80004078:	00a9559b          	srliw	a1,s2,0xa
    8000407c:	855a                	mv	a0,s6
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	7ae080e7          	jalr	1966(ra) # 8000382c <bmap>
    80004086:	0005059b          	sext.w	a1,a0
    8000408a:	8526                	mv	a0,s1
    8000408c:	fffff097          	auipc	ra,0xfffff
    80004090:	3ac080e7          	jalr	940(ra) # 80003438 <bread>
    80004094:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004096:	3ff97513          	andi	a0,s2,1023
    8000409a:	40ad07bb          	subw	a5,s10,a0
    8000409e:	414b873b          	subw	a4,s7,s4
    800040a2:	89be                	mv	s3,a5
    800040a4:	2781                	sext.w	a5,a5
    800040a6:	0007069b          	sext.w	a3,a4
    800040aa:	f8f6f4e3          	bgeu	a3,a5,80004032 <writei+0x4c>
    800040ae:	89ba                	mv	s3,a4
    800040b0:	b749                	j	80004032 <writei+0x4c>
      brelse(bp);
    800040b2:	8526                	mv	a0,s1
    800040b4:	fffff097          	auipc	ra,0xfffff
    800040b8:	4b4080e7          	jalr	1204(ra) # 80003568 <brelse>
  }

  if(off > ip->size)
    800040bc:	04cb2783          	lw	a5,76(s6)
    800040c0:	0127f463          	bgeu	a5,s2,800040c8 <writei+0xe2>
    ip->size = off;
    800040c4:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800040c8:	855a                	mv	a0,s6
    800040ca:	00000097          	auipc	ra,0x0
    800040ce:	aa6080e7          	jalr	-1370(ra) # 80003b70 <iupdate>

  return tot;
    800040d2:	000a051b          	sext.w	a0,s4
}
    800040d6:	70a6                	ld	ra,104(sp)
    800040d8:	7406                	ld	s0,96(sp)
    800040da:	64e6                	ld	s1,88(sp)
    800040dc:	6946                	ld	s2,80(sp)
    800040de:	69a6                	ld	s3,72(sp)
    800040e0:	6a06                	ld	s4,64(sp)
    800040e2:	7ae2                	ld	s5,56(sp)
    800040e4:	7b42                	ld	s6,48(sp)
    800040e6:	7ba2                	ld	s7,40(sp)
    800040e8:	7c02                	ld	s8,32(sp)
    800040ea:	6ce2                	ld	s9,24(sp)
    800040ec:	6d42                	ld	s10,16(sp)
    800040ee:	6da2                	ld	s11,8(sp)
    800040f0:	6165                	addi	sp,sp,112
    800040f2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040f4:	8a5e                	mv	s4,s7
    800040f6:	bfc9                	j	800040c8 <writei+0xe2>
    return -1;
    800040f8:	557d                	li	a0,-1
}
    800040fa:	8082                	ret
    return -1;
    800040fc:	557d                	li	a0,-1
    800040fe:	bfe1                	j	800040d6 <writei+0xf0>
    return -1;
    80004100:	557d                	li	a0,-1
    80004102:	bfd1                	j	800040d6 <writei+0xf0>

0000000080004104 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004104:	1141                	addi	sp,sp,-16
    80004106:	e406                	sd	ra,8(sp)
    80004108:	e022                	sd	s0,0(sp)
    8000410a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000410c:	4639                	li	a2,14
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	d00080e7          	jalr	-768(ra) # 80000e0e <strncmp>
}
    80004116:	60a2                	ld	ra,8(sp)
    80004118:	6402                	ld	s0,0(sp)
    8000411a:	0141                	addi	sp,sp,16
    8000411c:	8082                	ret

000000008000411e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000411e:	7139                	addi	sp,sp,-64
    80004120:	fc06                	sd	ra,56(sp)
    80004122:	f822                	sd	s0,48(sp)
    80004124:	f426                	sd	s1,40(sp)
    80004126:	f04a                	sd	s2,32(sp)
    80004128:	ec4e                	sd	s3,24(sp)
    8000412a:	e852                	sd	s4,16(sp)
    8000412c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000412e:	04451703          	lh	a4,68(a0)
    80004132:	4785                	li	a5,1
    80004134:	00f71a63          	bne	a4,a5,80004148 <dirlookup+0x2a>
    80004138:	892a                	mv	s2,a0
    8000413a:	89ae                	mv	s3,a1
    8000413c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000413e:	457c                	lw	a5,76(a0)
    80004140:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004142:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004144:	e79d                	bnez	a5,80004172 <dirlookup+0x54>
    80004146:	a8a5                	j	800041be <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004148:	00004517          	auipc	a0,0x4
    8000414c:	5f850513          	addi	a0,a0,1528 # 80008740 <syscalls+0x1b8>
    80004150:	ffffc097          	auipc	ra,0xffffc
    80004154:	47c080e7          	jalr	1148(ra) # 800005cc <panic>
      panic("dirlookup read");
    80004158:	00004517          	auipc	a0,0x4
    8000415c:	60050513          	addi	a0,a0,1536 # 80008758 <syscalls+0x1d0>
    80004160:	ffffc097          	auipc	ra,0xffffc
    80004164:	46c080e7          	jalr	1132(ra) # 800005cc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004168:	24c1                	addiw	s1,s1,16
    8000416a:	04c92783          	lw	a5,76(s2)
    8000416e:	04f4f763          	bgeu	s1,a5,800041bc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004172:	4741                	li	a4,16
    80004174:	86a6                	mv	a3,s1
    80004176:	fc040613          	addi	a2,s0,-64
    8000417a:	4581                	li	a1,0
    8000417c:	854a                	mv	a0,s2
    8000417e:	00000097          	auipc	ra,0x0
    80004182:	d70080e7          	jalr	-656(ra) # 80003eee <readi>
    80004186:	47c1                	li	a5,16
    80004188:	fcf518e3          	bne	a0,a5,80004158 <dirlookup+0x3a>
    if(de.inum == 0)
    8000418c:	fc045783          	lhu	a5,-64(s0)
    80004190:	dfe1                	beqz	a5,80004168 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004192:	fc240593          	addi	a1,s0,-62
    80004196:	854e                	mv	a0,s3
    80004198:	00000097          	auipc	ra,0x0
    8000419c:	f6c080e7          	jalr	-148(ra) # 80004104 <namecmp>
    800041a0:	f561                	bnez	a0,80004168 <dirlookup+0x4a>
      if(poff)
    800041a2:	000a0463          	beqz	s4,800041aa <dirlookup+0x8c>
        *poff = off;
    800041a6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041aa:	fc045583          	lhu	a1,-64(s0)
    800041ae:	00092503          	lw	a0,0(s2)
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	754080e7          	jalr	1876(ra) # 80003906 <iget>
    800041ba:	a011                	j	800041be <dirlookup+0xa0>
  return 0;
    800041bc:	4501                	li	a0,0
}
    800041be:	70e2                	ld	ra,56(sp)
    800041c0:	7442                	ld	s0,48(sp)
    800041c2:	74a2                	ld	s1,40(sp)
    800041c4:	7902                	ld	s2,32(sp)
    800041c6:	69e2                	ld	s3,24(sp)
    800041c8:	6a42                	ld	s4,16(sp)
    800041ca:	6121                	addi	sp,sp,64
    800041cc:	8082                	ret

00000000800041ce <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800041ce:	711d                	addi	sp,sp,-96
    800041d0:	ec86                	sd	ra,88(sp)
    800041d2:	e8a2                	sd	s0,80(sp)
    800041d4:	e4a6                	sd	s1,72(sp)
    800041d6:	e0ca                	sd	s2,64(sp)
    800041d8:	fc4e                	sd	s3,56(sp)
    800041da:	f852                	sd	s4,48(sp)
    800041dc:	f456                	sd	s5,40(sp)
    800041de:	f05a                	sd	s6,32(sp)
    800041e0:	ec5e                	sd	s7,24(sp)
    800041e2:	e862                	sd	s8,16(sp)
    800041e4:	e466                	sd	s9,8(sp)
    800041e6:	1080                	addi	s0,sp,96
    800041e8:	84aa                	mv	s1,a0
    800041ea:	8aae                	mv	s5,a1
    800041ec:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800041ee:	00054703          	lbu	a4,0(a0)
    800041f2:	02f00793          	li	a5,47
    800041f6:	02f70363          	beq	a4,a5,8000421c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800041fa:	ffffe097          	auipc	ra,0xffffe
    800041fe:	a72080e7          	jalr	-1422(ra) # 80001c6c <myproc>
    80004202:	16053503          	ld	a0,352(a0)
    80004206:	00000097          	auipc	ra,0x0
    8000420a:	9f6080e7          	jalr	-1546(ra) # 80003bfc <idup>
    8000420e:	89aa                	mv	s3,a0
  while(*path == '/')
    80004210:	02f00913          	li	s2,47
  len = path - s;
    80004214:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004216:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004218:	4b85                	li	s7,1
    8000421a:	a865                	j	800042d2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000421c:	4585                	li	a1,1
    8000421e:	4505                	li	a0,1
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	6e6080e7          	jalr	1766(ra) # 80003906 <iget>
    80004228:	89aa                	mv	s3,a0
    8000422a:	b7dd                	j	80004210 <namex+0x42>
      iunlockput(ip);
    8000422c:	854e                	mv	a0,s3
    8000422e:	00000097          	auipc	ra,0x0
    80004232:	c6e080e7          	jalr	-914(ra) # 80003e9c <iunlockput>
      return 0;
    80004236:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004238:	854e                	mv	a0,s3
    8000423a:	60e6                	ld	ra,88(sp)
    8000423c:	6446                	ld	s0,80(sp)
    8000423e:	64a6                	ld	s1,72(sp)
    80004240:	6906                	ld	s2,64(sp)
    80004242:	79e2                	ld	s3,56(sp)
    80004244:	7a42                	ld	s4,48(sp)
    80004246:	7aa2                	ld	s5,40(sp)
    80004248:	7b02                	ld	s6,32(sp)
    8000424a:	6be2                	ld	s7,24(sp)
    8000424c:	6c42                	ld	s8,16(sp)
    8000424e:	6ca2                	ld	s9,8(sp)
    80004250:	6125                	addi	sp,sp,96
    80004252:	8082                	ret
      iunlock(ip);
    80004254:	854e                	mv	a0,s3
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	aa6080e7          	jalr	-1370(ra) # 80003cfc <iunlock>
      return ip;
    8000425e:	bfe9                	j	80004238 <namex+0x6a>
      iunlockput(ip);
    80004260:	854e                	mv	a0,s3
    80004262:	00000097          	auipc	ra,0x0
    80004266:	c3a080e7          	jalr	-966(ra) # 80003e9c <iunlockput>
      return 0;
    8000426a:	89e6                	mv	s3,s9
    8000426c:	b7f1                	j	80004238 <namex+0x6a>
  len = path - s;
    8000426e:	40b48633          	sub	a2,s1,a1
    80004272:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004276:	099c5463          	bge	s8,s9,800042fe <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000427a:	4639                	li	a2,14
    8000427c:	8552                	mv	a0,s4
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	b14080e7          	jalr	-1260(ra) # 80000d92 <memmove>
  while(*path == '/')
    80004286:	0004c783          	lbu	a5,0(s1)
    8000428a:	01279763          	bne	a5,s2,80004298 <namex+0xca>
    path++;
    8000428e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004290:	0004c783          	lbu	a5,0(s1)
    80004294:	ff278de3          	beq	a5,s2,8000428e <namex+0xc0>
    ilock(ip);
    80004298:	854e                	mv	a0,s3
    8000429a:	00000097          	auipc	ra,0x0
    8000429e:	9a0080e7          	jalr	-1632(ra) # 80003c3a <ilock>
    if(ip->type != T_DIR){
    800042a2:	04499783          	lh	a5,68(s3)
    800042a6:	f97793e3          	bne	a5,s7,8000422c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800042aa:	000a8563          	beqz	s5,800042b4 <namex+0xe6>
    800042ae:	0004c783          	lbu	a5,0(s1)
    800042b2:	d3cd                	beqz	a5,80004254 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800042b4:	865a                	mv	a2,s6
    800042b6:	85d2                	mv	a1,s4
    800042b8:	854e                	mv	a0,s3
    800042ba:	00000097          	auipc	ra,0x0
    800042be:	e64080e7          	jalr	-412(ra) # 8000411e <dirlookup>
    800042c2:	8caa                	mv	s9,a0
    800042c4:	dd51                	beqz	a0,80004260 <namex+0x92>
    iunlockput(ip);
    800042c6:	854e                	mv	a0,s3
    800042c8:	00000097          	auipc	ra,0x0
    800042cc:	bd4080e7          	jalr	-1068(ra) # 80003e9c <iunlockput>
    ip = next;
    800042d0:	89e6                	mv	s3,s9
  while(*path == '/')
    800042d2:	0004c783          	lbu	a5,0(s1)
    800042d6:	05279763          	bne	a5,s2,80004324 <namex+0x156>
    path++;
    800042da:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042dc:	0004c783          	lbu	a5,0(s1)
    800042e0:	ff278de3          	beq	a5,s2,800042da <namex+0x10c>
  if(*path == 0)
    800042e4:	c79d                	beqz	a5,80004312 <namex+0x144>
    path++;
    800042e6:	85a6                	mv	a1,s1
  len = path - s;
    800042e8:	8cda                	mv	s9,s6
    800042ea:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800042ec:	01278963          	beq	a5,s2,800042fe <namex+0x130>
    800042f0:	dfbd                	beqz	a5,8000426e <namex+0xa0>
    path++;
    800042f2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800042f4:	0004c783          	lbu	a5,0(s1)
    800042f8:	ff279ce3          	bne	a5,s2,800042f0 <namex+0x122>
    800042fc:	bf8d                	j	8000426e <namex+0xa0>
    memmove(name, s, len);
    800042fe:	2601                	sext.w	a2,a2
    80004300:	8552                	mv	a0,s4
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	a90080e7          	jalr	-1392(ra) # 80000d92 <memmove>
    name[len] = 0;
    8000430a:	9cd2                	add	s9,s9,s4
    8000430c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004310:	bf9d                	j	80004286 <namex+0xb8>
  if(nameiparent){
    80004312:	f20a83e3          	beqz	s5,80004238 <namex+0x6a>
    iput(ip);
    80004316:	854e                	mv	a0,s3
    80004318:	00000097          	auipc	ra,0x0
    8000431c:	adc080e7          	jalr	-1316(ra) # 80003df4 <iput>
    return 0;
    80004320:	4981                	li	s3,0
    80004322:	bf19                	j	80004238 <namex+0x6a>
  if(*path == 0)
    80004324:	d7fd                	beqz	a5,80004312 <namex+0x144>
  while(*path != '/' && *path != 0)
    80004326:	0004c783          	lbu	a5,0(s1)
    8000432a:	85a6                	mv	a1,s1
    8000432c:	b7d1                	j	800042f0 <namex+0x122>

000000008000432e <dirlink>:
{
    8000432e:	7139                	addi	sp,sp,-64
    80004330:	fc06                	sd	ra,56(sp)
    80004332:	f822                	sd	s0,48(sp)
    80004334:	f426                	sd	s1,40(sp)
    80004336:	f04a                	sd	s2,32(sp)
    80004338:	ec4e                	sd	s3,24(sp)
    8000433a:	e852                	sd	s4,16(sp)
    8000433c:	0080                	addi	s0,sp,64
    8000433e:	892a                	mv	s2,a0
    80004340:	8a2e                	mv	s4,a1
    80004342:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004344:	4601                	li	a2,0
    80004346:	00000097          	auipc	ra,0x0
    8000434a:	dd8080e7          	jalr	-552(ra) # 8000411e <dirlookup>
    8000434e:	e93d                	bnez	a0,800043c4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004350:	04c92483          	lw	s1,76(s2)
    80004354:	c49d                	beqz	s1,80004382 <dirlink+0x54>
    80004356:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004358:	4741                	li	a4,16
    8000435a:	86a6                	mv	a3,s1
    8000435c:	fc040613          	addi	a2,s0,-64
    80004360:	4581                	li	a1,0
    80004362:	854a                	mv	a0,s2
    80004364:	00000097          	auipc	ra,0x0
    80004368:	b8a080e7          	jalr	-1142(ra) # 80003eee <readi>
    8000436c:	47c1                	li	a5,16
    8000436e:	06f51163          	bne	a0,a5,800043d0 <dirlink+0xa2>
    if(de.inum == 0)
    80004372:	fc045783          	lhu	a5,-64(s0)
    80004376:	c791                	beqz	a5,80004382 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004378:	24c1                	addiw	s1,s1,16
    8000437a:	04c92783          	lw	a5,76(s2)
    8000437e:	fcf4ede3          	bltu	s1,a5,80004358 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004382:	4639                	li	a2,14
    80004384:	85d2                	mv	a1,s4
    80004386:	fc240513          	addi	a0,s0,-62
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	ac0080e7          	jalr	-1344(ra) # 80000e4a <strncpy>
  de.inum = inum;
    80004392:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004396:	4741                	li	a4,16
    80004398:	86a6                	mv	a3,s1
    8000439a:	fc040613          	addi	a2,s0,-64
    8000439e:	4581                	li	a1,0
    800043a0:	854a                	mv	a0,s2
    800043a2:	00000097          	auipc	ra,0x0
    800043a6:	c44080e7          	jalr	-956(ra) # 80003fe6 <writei>
    800043aa:	872a                	mv	a4,a0
    800043ac:	47c1                	li	a5,16
  return 0;
    800043ae:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043b0:	02f71863          	bne	a4,a5,800043e0 <dirlink+0xb2>
}
    800043b4:	70e2                	ld	ra,56(sp)
    800043b6:	7442                	ld	s0,48(sp)
    800043b8:	74a2                	ld	s1,40(sp)
    800043ba:	7902                	ld	s2,32(sp)
    800043bc:	69e2                	ld	s3,24(sp)
    800043be:	6a42                	ld	s4,16(sp)
    800043c0:	6121                	addi	sp,sp,64
    800043c2:	8082                	ret
    iput(ip);
    800043c4:	00000097          	auipc	ra,0x0
    800043c8:	a30080e7          	jalr	-1488(ra) # 80003df4 <iput>
    return -1;
    800043cc:	557d                	li	a0,-1
    800043ce:	b7dd                	j	800043b4 <dirlink+0x86>
      panic("dirlink read");
    800043d0:	00004517          	auipc	a0,0x4
    800043d4:	39850513          	addi	a0,a0,920 # 80008768 <syscalls+0x1e0>
    800043d8:	ffffc097          	auipc	ra,0xffffc
    800043dc:	1f4080e7          	jalr	500(ra) # 800005cc <panic>
    panic("dirlink");
    800043e0:	00004517          	auipc	a0,0x4
    800043e4:	49050513          	addi	a0,a0,1168 # 80008870 <syscalls+0x2e8>
    800043e8:	ffffc097          	auipc	ra,0xffffc
    800043ec:	1e4080e7          	jalr	484(ra) # 800005cc <panic>

00000000800043f0 <namei>:

struct inode*
namei(char *path)
{
    800043f0:	1101                	addi	sp,sp,-32
    800043f2:	ec06                	sd	ra,24(sp)
    800043f4:	e822                	sd	s0,16(sp)
    800043f6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800043f8:	fe040613          	addi	a2,s0,-32
    800043fc:	4581                	li	a1,0
    800043fe:	00000097          	auipc	ra,0x0
    80004402:	dd0080e7          	jalr	-560(ra) # 800041ce <namex>
}
    80004406:	60e2                	ld	ra,24(sp)
    80004408:	6442                	ld	s0,16(sp)
    8000440a:	6105                	addi	sp,sp,32
    8000440c:	8082                	ret

000000008000440e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000440e:	1141                	addi	sp,sp,-16
    80004410:	e406                	sd	ra,8(sp)
    80004412:	e022                	sd	s0,0(sp)
    80004414:	0800                	addi	s0,sp,16
    80004416:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004418:	4585                	li	a1,1
    8000441a:	00000097          	auipc	ra,0x0
    8000441e:	db4080e7          	jalr	-588(ra) # 800041ce <namex>
}
    80004422:	60a2                	ld	ra,8(sp)
    80004424:	6402                	ld	s0,0(sp)
    80004426:	0141                	addi	sp,sp,16
    80004428:	8082                	ret

000000008000442a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000442a:	1101                	addi	sp,sp,-32
    8000442c:	ec06                	sd	ra,24(sp)
    8000442e:	e822                	sd	s0,16(sp)
    80004430:	e426                	sd	s1,8(sp)
    80004432:	e04a                	sd	s2,0(sp)
    80004434:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004436:	0001e917          	auipc	s2,0x1e
    8000443a:	95a90913          	addi	s2,s2,-1702 # 80021d90 <log>
    8000443e:	01892583          	lw	a1,24(s2)
    80004442:	02892503          	lw	a0,40(s2)
    80004446:	fffff097          	auipc	ra,0xfffff
    8000444a:	ff2080e7          	jalr	-14(ra) # 80003438 <bread>
    8000444e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004450:	02c92683          	lw	a3,44(s2)
    80004454:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004456:	02d05763          	blez	a3,80004484 <write_head+0x5a>
    8000445a:	0001e797          	auipc	a5,0x1e
    8000445e:	96678793          	addi	a5,a5,-1690 # 80021dc0 <log+0x30>
    80004462:	05c50713          	addi	a4,a0,92
    80004466:	36fd                	addiw	a3,a3,-1
    80004468:	1682                	slli	a3,a3,0x20
    8000446a:	9281                	srli	a3,a3,0x20
    8000446c:	068a                	slli	a3,a3,0x2
    8000446e:	0001e617          	auipc	a2,0x1e
    80004472:	95660613          	addi	a2,a2,-1706 # 80021dc4 <log+0x34>
    80004476:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004478:	4390                	lw	a2,0(a5)
    8000447a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000447c:	0791                	addi	a5,a5,4
    8000447e:	0711                	addi	a4,a4,4
    80004480:	fed79ce3          	bne	a5,a3,80004478 <write_head+0x4e>
  }
  bwrite(buf);
    80004484:	8526                	mv	a0,s1
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	0a4080e7          	jalr	164(ra) # 8000352a <bwrite>
  brelse(buf);
    8000448e:	8526                	mv	a0,s1
    80004490:	fffff097          	auipc	ra,0xfffff
    80004494:	0d8080e7          	jalr	216(ra) # 80003568 <brelse>
}
    80004498:	60e2                	ld	ra,24(sp)
    8000449a:	6442                	ld	s0,16(sp)
    8000449c:	64a2                	ld	s1,8(sp)
    8000449e:	6902                	ld	s2,0(sp)
    800044a0:	6105                	addi	sp,sp,32
    800044a2:	8082                	ret

00000000800044a4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044a4:	0001e797          	auipc	a5,0x1e
    800044a8:	9187a783          	lw	a5,-1768(a5) # 80021dbc <log+0x2c>
    800044ac:	0af05d63          	blez	a5,80004566 <install_trans+0xc2>
{
    800044b0:	7139                	addi	sp,sp,-64
    800044b2:	fc06                	sd	ra,56(sp)
    800044b4:	f822                	sd	s0,48(sp)
    800044b6:	f426                	sd	s1,40(sp)
    800044b8:	f04a                	sd	s2,32(sp)
    800044ba:	ec4e                	sd	s3,24(sp)
    800044bc:	e852                	sd	s4,16(sp)
    800044be:	e456                	sd	s5,8(sp)
    800044c0:	e05a                	sd	s6,0(sp)
    800044c2:	0080                	addi	s0,sp,64
    800044c4:	8b2a                	mv	s6,a0
    800044c6:	0001ea97          	auipc	s5,0x1e
    800044ca:	8faa8a93          	addi	s5,s5,-1798 # 80021dc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044d0:	0001e997          	auipc	s3,0x1e
    800044d4:	8c098993          	addi	s3,s3,-1856 # 80021d90 <log>
    800044d8:	a00d                	j	800044fa <install_trans+0x56>
    brelse(lbuf);
    800044da:	854a                	mv	a0,s2
    800044dc:	fffff097          	auipc	ra,0xfffff
    800044e0:	08c080e7          	jalr	140(ra) # 80003568 <brelse>
    brelse(dbuf);
    800044e4:	8526                	mv	a0,s1
    800044e6:	fffff097          	auipc	ra,0xfffff
    800044ea:	082080e7          	jalr	130(ra) # 80003568 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ee:	2a05                	addiw	s4,s4,1
    800044f0:	0a91                	addi	s5,s5,4
    800044f2:	02c9a783          	lw	a5,44(s3)
    800044f6:	04fa5e63          	bge	s4,a5,80004552 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044fa:	0189a583          	lw	a1,24(s3)
    800044fe:	014585bb          	addw	a1,a1,s4
    80004502:	2585                	addiw	a1,a1,1
    80004504:	0289a503          	lw	a0,40(s3)
    80004508:	fffff097          	auipc	ra,0xfffff
    8000450c:	f30080e7          	jalr	-208(ra) # 80003438 <bread>
    80004510:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004512:	000aa583          	lw	a1,0(s5)
    80004516:	0289a503          	lw	a0,40(s3)
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	f1e080e7          	jalr	-226(ra) # 80003438 <bread>
    80004522:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004524:	40000613          	li	a2,1024
    80004528:	05890593          	addi	a1,s2,88
    8000452c:	05850513          	addi	a0,a0,88
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	862080e7          	jalr	-1950(ra) # 80000d92 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	ff0080e7          	jalr	-16(ra) # 8000352a <bwrite>
    if(recovering == 0)
    80004542:	f80b1ce3          	bnez	s6,800044da <install_trans+0x36>
      bunpin(dbuf);
    80004546:	8526                	mv	a0,s1
    80004548:	fffff097          	auipc	ra,0xfffff
    8000454c:	0fa080e7          	jalr	250(ra) # 80003642 <bunpin>
    80004550:	b769                	j	800044da <install_trans+0x36>
}
    80004552:	70e2                	ld	ra,56(sp)
    80004554:	7442                	ld	s0,48(sp)
    80004556:	74a2                	ld	s1,40(sp)
    80004558:	7902                	ld	s2,32(sp)
    8000455a:	69e2                	ld	s3,24(sp)
    8000455c:	6a42                	ld	s4,16(sp)
    8000455e:	6aa2                	ld	s5,8(sp)
    80004560:	6b02                	ld	s6,0(sp)
    80004562:	6121                	addi	sp,sp,64
    80004564:	8082                	ret
    80004566:	8082                	ret

0000000080004568 <initlog>:
{
    80004568:	7179                	addi	sp,sp,-48
    8000456a:	f406                	sd	ra,40(sp)
    8000456c:	f022                	sd	s0,32(sp)
    8000456e:	ec26                	sd	s1,24(sp)
    80004570:	e84a                	sd	s2,16(sp)
    80004572:	e44e                	sd	s3,8(sp)
    80004574:	1800                	addi	s0,sp,48
    80004576:	892a                	mv	s2,a0
    80004578:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000457a:	0001e497          	auipc	s1,0x1e
    8000457e:	81648493          	addi	s1,s1,-2026 # 80021d90 <log>
    80004582:	00004597          	auipc	a1,0x4
    80004586:	1f658593          	addi	a1,a1,502 # 80008778 <syscalls+0x1f0>
    8000458a:	8526                	mv	a0,s1
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	61e080e7          	jalr	1566(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    80004594:	0149a583          	lw	a1,20(s3)
    80004598:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000459a:	0109a783          	lw	a5,16(s3)
    8000459e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045a0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045a4:	854a                	mv	a0,s2
    800045a6:	fffff097          	auipc	ra,0xfffff
    800045aa:	e92080e7          	jalr	-366(ra) # 80003438 <bread>
  log.lh.n = lh->n;
    800045ae:	4d34                	lw	a3,88(a0)
    800045b0:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800045b2:	02d05563          	blez	a3,800045dc <initlog+0x74>
    800045b6:	05c50793          	addi	a5,a0,92
    800045ba:	0001e717          	auipc	a4,0x1e
    800045be:	80670713          	addi	a4,a4,-2042 # 80021dc0 <log+0x30>
    800045c2:	36fd                	addiw	a3,a3,-1
    800045c4:	1682                	slli	a3,a3,0x20
    800045c6:	9281                	srli	a3,a3,0x20
    800045c8:	068a                	slli	a3,a3,0x2
    800045ca:	06050613          	addi	a2,a0,96
    800045ce:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800045d0:	4390                	lw	a2,0(a5)
    800045d2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045d4:	0791                	addi	a5,a5,4
    800045d6:	0711                	addi	a4,a4,4
    800045d8:	fed79ce3          	bne	a5,a3,800045d0 <initlog+0x68>
  brelse(buf);
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	f8c080e7          	jalr	-116(ra) # 80003568 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045e4:	4505                	li	a0,1
    800045e6:	00000097          	auipc	ra,0x0
    800045ea:	ebe080e7          	jalr	-322(ra) # 800044a4 <install_trans>
  log.lh.n = 0;
    800045ee:	0001d797          	auipc	a5,0x1d
    800045f2:	7c07a723          	sw	zero,1998(a5) # 80021dbc <log+0x2c>
  write_head(); // clear the log
    800045f6:	00000097          	auipc	ra,0x0
    800045fa:	e34080e7          	jalr	-460(ra) # 8000442a <write_head>
}
    800045fe:	70a2                	ld	ra,40(sp)
    80004600:	7402                	ld	s0,32(sp)
    80004602:	64e2                	ld	s1,24(sp)
    80004604:	6942                	ld	s2,16(sp)
    80004606:	69a2                	ld	s3,8(sp)
    80004608:	6145                	addi	sp,sp,48
    8000460a:	8082                	ret

000000008000460c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000460c:	1101                	addi	sp,sp,-32
    8000460e:	ec06                	sd	ra,24(sp)
    80004610:	e822                	sd	s0,16(sp)
    80004612:	e426                	sd	s1,8(sp)
    80004614:	e04a                	sd	s2,0(sp)
    80004616:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004618:	0001d517          	auipc	a0,0x1d
    8000461c:	77850513          	addi	a0,a0,1912 # 80021d90 <log>
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	61a080e7          	jalr	1562(ra) # 80000c3a <acquire>
  while(1){
    if(log.committing){
    80004628:	0001d497          	auipc	s1,0x1d
    8000462c:	76848493          	addi	s1,s1,1896 # 80021d90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004630:	4979                	li	s2,30
    80004632:	a039                	j	80004640 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004634:	85a6                	mv	a1,s1
    80004636:	8526                	mv	a0,s1
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	ee6080e7          	jalr	-282(ra) # 8000251e <sleep>
    if(log.committing){
    80004640:	50dc                	lw	a5,36(s1)
    80004642:	fbed                	bnez	a5,80004634 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004644:	509c                	lw	a5,32(s1)
    80004646:	0017871b          	addiw	a4,a5,1
    8000464a:	0007069b          	sext.w	a3,a4
    8000464e:	0027179b          	slliw	a5,a4,0x2
    80004652:	9fb9                	addw	a5,a5,a4
    80004654:	0017979b          	slliw	a5,a5,0x1
    80004658:	54d8                	lw	a4,44(s1)
    8000465a:	9fb9                	addw	a5,a5,a4
    8000465c:	00f95963          	bge	s2,a5,8000466e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004660:	85a6                	mv	a1,s1
    80004662:	8526                	mv	a0,s1
    80004664:	ffffe097          	auipc	ra,0xffffe
    80004668:	eba080e7          	jalr	-326(ra) # 8000251e <sleep>
    8000466c:	bfd1                	j	80004640 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000466e:	0001d517          	auipc	a0,0x1d
    80004672:	72250513          	addi	a0,a0,1826 # 80021d90 <log>
    80004676:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	676080e7          	jalr	1654(ra) # 80000cee <release>
      break;
    }
  }
}
    80004680:	60e2                	ld	ra,24(sp)
    80004682:	6442                	ld	s0,16(sp)
    80004684:	64a2                	ld	s1,8(sp)
    80004686:	6902                	ld	s2,0(sp)
    80004688:	6105                	addi	sp,sp,32
    8000468a:	8082                	ret

000000008000468c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000468c:	7139                	addi	sp,sp,-64
    8000468e:	fc06                	sd	ra,56(sp)
    80004690:	f822                	sd	s0,48(sp)
    80004692:	f426                	sd	s1,40(sp)
    80004694:	f04a                	sd	s2,32(sp)
    80004696:	ec4e                	sd	s3,24(sp)
    80004698:	e852                	sd	s4,16(sp)
    8000469a:	e456                	sd	s5,8(sp)
    8000469c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000469e:	0001d497          	auipc	s1,0x1d
    800046a2:	6f248493          	addi	s1,s1,1778 # 80021d90 <log>
    800046a6:	8526                	mv	a0,s1
    800046a8:	ffffc097          	auipc	ra,0xffffc
    800046ac:	592080e7          	jalr	1426(ra) # 80000c3a <acquire>
  log.outstanding -= 1;
    800046b0:	509c                	lw	a5,32(s1)
    800046b2:	37fd                	addiw	a5,a5,-1
    800046b4:	0007891b          	sext.w	s2,a5
    800046b8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800046ba:	50dc                	lw	a5,36(s1)
    800046bc:	e7b9                	bnez	a5,8000470a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800046be:	04091e63          	bnez	s2,8000471a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800046c2:	0001d497          	auipc	s1,0x1d
    800046c6:	6ce48493          	addi	s1,s1,1742 # 80021d90 <log>
    800046ca:	4785                	li	a5,1
    800046cc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800046ce:	8526                	mv	a0,s1
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	61e080e7          	jalr	1566(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800046d8:	54dc                	lw	a5,44(s1)
    800046da:	06f04763          	bgtz	a5,80004748 <end_op+0xbc>
    acquire(&log.lock);
    800046de:	0001d497          	auipc	s1,0x1d
    800046e2:	6b248493          	addi	s1,s1,1714 # 80021d90 <log>
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffc097          	auipc	ra,0xffffc
    800046ec:	552080e7          	jalr	1362(ra) # 80000c3a <acquire>
    log.committing = 0;
    800046f0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046f4:	8526                	mv	a0,s1
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	fb4080e7          	jalr	-76(ra) # 800026aa <wakeup>
    release(&log.lock);
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffc097          	auipc	ra,0xffffc
    80004704:	5ee080e7          	jalr	1518(ra) # 80000cee <release>
}
    80004708:	a03d                	j	80004736 <end_op+0xaa>
    panic("log.committing");
    8000470a:	00004517          	auipc	a0,0x4
    8000470e:	07650513          	addi	a0,a0,118 # 80008780 <syscalls+0x1f8>
    80004712:	ffffc097          	auipc	ra,0xffffc
    80004716:	eba080e7          	jalr	-326(ra) # 800005cc <panic>
    wakeup(&log);
    8000471a:	0001d497          	auipc	s1,0x1d
    8000471e:	67648493          	addi	s1,s1,1654 # 80021d90 <log>
    80004722:	8526                	mv	a0,s1
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	f86080e7          	jalr	-122(ra) # 800026aa <wakeup>
  release(&log.lock);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	5c0080e7          	jalr	1472(ra) # 80000cee <release>
}
    80004736:	70e2                	ld	ra,56(sp)
    80004738:	7442                	ld	s0,48(sp)
    8000473a:	74a2                	ld	s1,40(sp)
    8000473c:	7902                	ld	s2,32(sp)
    8000473e:	69e2                	ld	s3,24(sp)
    80004740:	6a42                	ld	s4,16(sp)
    80004742:	6aa2                	ld	s5,8(sp)
    80004744:	6121                	addi	sp,sp,64
    80004746:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004748:	0001da97          	auipc	s5,0x1d
    8000474c:	678a8a93          	addi	s5,s5,1656 # 80021dc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004750:	0001da17          	auipc	s4,0x1d
    80004754:	640a0a13          	addi	s4,s4,1600 # 80021d90 <log>
    80004758:	018a2583          	lw	a1,24(s4)
    8000475c:	012585bb          	addw	a1,a1,s2
    80004760:	2585                	addiw	a1,a1,1
    80004762:	028a2503          	lw	a0,40(s4)
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	cd2080e7          	jalr	-814(ra) # 80003438 <bread>
    8000476e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004770:	000aa583          	lw	a1,0(s5)
    80004774:	028a2503          	lw	a0,40(s4)
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	cc0080e7          	jalr	-832(ra) # 80003438 <bread>
    80004780:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004782:	40000613          	li	a2,1024
    80004786:	05850593          	addi	a1,a0,88
    8000478a:	05848513          	addi	a0,s1,88
    8000478e:	ffffc097          	auipc	ra,0xffffc
    80004792:	604080e7          	jalr	1540(ra) # 80000d92 <memmove>
    bwrite(to);  // write the log
    80004796:	8526                	mv	a0,s1
    80004798:	fffff097          	auipc	ra,0xfffff
    8000479c:	d92080e7          	jalr	-622(ra) # 8000352a <bwrite>
    brelse(from);
    800047a0:	854e                	mv	a0,s3
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	dc6080e7          	jalr	-570(ra) # 80003568 <brelse>
    brelse(to);
    800047aa:	8526                	mv	a0,s1
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	dbc080e7          	jalr	-580(ra) # 80003568 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047b4:	2905                	addiw	s2,s2,1
    800047b6:	0a91                	addi	s5,s5,4
    800047b8:	02ca2783          	lw	a5,44(s4)
    800047bc:	f8f94ee3          	blt	s2,a5,80004758 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	c6a080e7          	jalr	-918(ra) # 8000442a <write_head>
    install_trans(0); // Now install writes to home locations
    800047c8:	4501                	li	a0,0
    800047ca:	00000097          	auipc	ra,0x0
    800047ce:	cda080e7          	jalr	-806(ra) # 800044a4 <install_trans>
    log.lh.n = 0;
    800047d2:	0001d797          	auipc	a5,0x1d
    800047d6:	5e07a523          	sw	zero,1514(a5) # 80021dbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800047da:	00000097          	auipc	ra,0x0
    800047de:	c50080e7          	jalr	-944(ra) # 8000442a <write_head>
    800047e2:	bdf5                	j	800046de <end_op+0x52>

00000000800047e4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800047e4:	1101                	addi	sp,sp,-32
    800047e6:	ec06                	sd	ra,24(sp)
    800047e8:	e822                	sd	s0,16(sp)
    800047ea:	e426                	sd	s1,8(sp)
    800047ec:	e04a                	sd	s2,0(sp)
    800047ee:	1000                	addi	s0,sp,32
    800047f0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800047f2:	0001d917          	auipc	s2,0x1d
    800047f6:	59e90913          	addi	s2,s2,1438 # 80021d90 <log>
    800047fa:	854a                	mv	a0,s2
    800047fc:	ffffc097          	auipc	ra,0xffffc
    80004800:	43e080e7          	jalr	1086(ra) # 80000c3a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004804:	02c92603          	lw	a2,44(s2)
    80004808:	47f5                	li	a5,29
    8000480a:	06c7c563          	blt	a5,a2,80004874 <log_write+0x90>
    8000480e:	0001d797          	auipc	a5,0x1d
    80004812:	59e7a783          	lw	a5,1438(a5) # 80021dac <log+0x1c>
    80004816:	37fd                	addiw	a5,a5,-1
    80004818:	04f65e63          	bge	a2,a5,80004874 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000481c:	0001d797          	auipc	a5,0x1d
    80004820:	5947a783          	lw	a5,1428(a5) # 80021db0 <log+0x20>
    80004824:	06f05063          	blez	a5,80004884 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004828:	4781                	li	a5,0
    8000482a:	06c05563          	blez	a2,80004894 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000482e:	44cc                	lw	a1,12(s1)
    80004830:	0001d717          	auipc	a4,0x1d
    80004834:	59070713          	addi	a4,a4,1424 # 80021dc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004838:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000483a:	4314                	lw	a3,0(a4)
    8000483c:	04b68c63          	beq	a3,a1,80004894 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004840:	2785                	addiw	a5,a5,1
    80004842:	0711                	addi	a4,a4,4
    80004844:	fef61be3          	bne	a2,a5,8000483a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004848:	0621                	addi	a2,a2,8
    8000484a:	060a                	slli	a2,a2,0x2
    8000484c:	0001d797          	auipc	a5,0x1d
    80004850:	54478793          	addi	a5,a5,1348 # 80021d90 <log>
    80004854:	963e                	add	a2,a2,a5
    80004856:	44dc                	lw	a5,12(s1)
    80004858:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000485a:	8526                	mv	a0,s1
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	daa080e7          	jalr	-598(ra) # 80003606 <bpin>
    log.lh.n++;
    80004864:	0001d717          	auipc	a4,0x1d
    80004868:	52c70713          	addi	a4,a4,1324 # 80021d90 <log>
    8000486c:	575c                	lw	a5,44(a4)
    8000486e:	2785                	addiw	a5,a5,1
    80004870:	d75c                	sw	a5,44(a4)
    80004872:	a835                	j	800048ae <log_write+0xca>
    panic("too big a transaction");
    80004874:	00004517          	auipc	a0,0x4
    80004878:	f1c50513          	addi	a0,a0,-228 # 80008790 <syscalls+0x208>
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	d50080e7          	jalr	-688(ra) # 800005cc <panic>
    panic("log_write outside of trans");
    80004884:	00004517          	auipc	a0,0x4
    80004888:	f2450513          	addi	a0,a0,-220 # 800087a8 <syscalls+0x220>
    8000488c:	ffffc097          	auipc	ra,0xffffc
    80004890:	d40080e7          	jalr	-704(ra) # 800005cc <panic>
  log.lh.block[i] = b->blockno;
    80004894:	00878713          	addi	a4,a5,8
    80004898:	00271693          	slli	a3,a4,0x2
    8000489c:	0001d717          	auipc	a4,0x1d
    800048a0:	4f470713          	addi	a4,a4,1268 # 80021d90 <log>
    800048a4:	9736                	add	a4,a4,a3
    800048a6:	44d4                	lw	a3,12(s1)
    800048a8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800048aa:	faf608e3          	beq	a2,a5,8000485a <log_write+0x76>
  }
  release(&log.lock);
    800048ae:	0001d517          	auipc	a0,0x1d
    800048b2:	4e250513          	addi	a0,a0,1250 # 80021d90 <log>
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	438080e7          	jalr	1080(ra) # 80000cee <release>
}
    800048be:	60e2                	ld	ra,24(sp)
    800048c0:	6442                	ld	s0,16(sp)
    800048c2:	64a2                	ld	s1,8(sp)
    800048c4:	6902                	ld	s2,0(sp)
    800048c6:	6105                	addi	sp,sp,32
    800048c8:	8082                	ret

00000000800048ca <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800048ca:	1101                	addi	sp,sp,-32
    800048cc:	ec06                	sd	ra,24(sp)
    800048ce:	e822                	sd	s0,16(sp)
    800048d0:	e426                	sd	s1,8(sp)
    800048d2:	e04a                	sd	s2,0(sp)
    800048d4:	1000                	addi	s0,sp,32
    800048d6:	84aa                	mv	s1,a0
    800048d8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048da:	00004597          	auipc	a1,0x4
    800048de:	eee58593          	addi	a1,a1,-274 # 800087c8 <syscalls+0x240>
    800048e2:	0521                	addi	a0,a0,8
    800048e4:	ffffc097          	auipc	ra,0xffffc
    800048e8:	2c6080e7          	jalr	710(ra) # 80000baa <initlock>
  lk->name = name;
    800048ec:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048f0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048f4:	0204a423          	sw	zero,40(s1)
}
    800048f8:	60e2                	ld	ra,24(sp)
    800048fa:	6442                	ld	s0,16(sp)
    800048fc:	64a2                	ld	s1,8(sp)
    800048fe:	6902                	ld	s2,0(sp)
    80004900:	6105                	addi	sp,sp,32
    80004902:	8082                	ret

0000000080004904 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004904:	1101                	addi	sp,sp,-32
    80004906:	ec06                	sd	ra,24(sp)
    80004908:	e822                	sd	s0,16(sp)
    8000490a:	e426                	sd	s1,8(sp)
    8000490c:	e04a                	sd	s2,0(sp)
    8000490e:	1000                	addi	s0,sp,32
    80004910:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004912:	00850913          	addi	s2,a0,8
    80004916:	854a                	mv	a0,s2
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	322080e7          	jalr	802(ra) # 80000c3a <acquire>
  while (lk->locked) {
    80004920:	409c                	lw	a5,0(s1)
    80004922:	cb89                	beqz	a5,80004934 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004924:	85ca                	mv	a1,s2
    80004926:	8526                	mv	a0,s1
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	bf6080e7          	jalr	-1034(ra) # 8000251e <sleep>
  while (lk->locked) {
    80004930:	409c                	lw	a5,0(s1)
    80004932:	fbed                	bnez	a5,80004924 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004934:	4785                	li	a5,1
    80004936:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004938:	ffffd097          	auipc	ra,0xffffd
    8000493c:	334080e7          	jalr	820(ra) # 80001c6c <myproc>
    80004940:	591c                	lw	a5,48(a0)
    80004942:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004944:	854a                	mv	a0,s2
    80004946:	ffffc097          	auipc	ra,0xffffc
    8000494a:	3a8080e7          	jalr	936(ra) # 80000cee <release>
}
    8000494e:	60e2                	ld	ra,24(sp)
    80004950:	6442                	ld	s0,16(sp)
    80004952:	64a2                	ld	s1,8(sp)
    80004954:	6902                	ld	s2,0(sp)
    80004956:	6105                	addi	sp,sp,32
    80004958:	8082                	ret

000000008000495a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000495a:	1101                	addi	sp,sp,-32
    8000495c:	ec06                	sd	ra,24(sp)
    8000495e:	e822                	sd	s0,16(sp)
    80004960:	e426                	sd	s1,8(sp)
    80004962:	e04a                	sd	s2,0(sp)
    80004964:	1000                	addi	s0,sp,32
    80004966:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004968:	00850913          	addi	s2,a0,8
    8000496c:	854a                	mv	a0,s2
    8000496e:	ffffc097          	auipc	ra,0xffffc
    80004972:	2cc080e7          	jalr	716(ra) # 80000c3a <acquire>
  lk->locked = 0;
    80004976:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000497a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	d2a080e7          	jalr	-726(ra) # 800026aa <wakeup>
  release(&lk->lk);
    80004988:	854a                	mv	a0,s2
    8000498a:	ffffc097          	auipc	ra,0xffffc
    8000498e:	364080e7          	jalr	868(ra) # 80000cee <release>
}
    80004992:	60e2                	ld	ra,24(sp)
    80004994:	6442                	ld	s0,16(sp)
    80004996:	64a2                	ld	s1,8(sp)
    80004998:	6902                	ld	s2,0(sp)
    8000499a:	6105                	addi	sp,sp,32
    8000499c:	8082                	ret

000000008000499e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000499e:	7179                	addi	sp,sp,-48
    800049a0:	f406                	sd	ra,40(sp)
    800049a2:	f022                	sd	s0,32(sp)
    800049a4:	ec26                	sd	s1,24(sp)
    800049a6:	e84a                	sd	s2,16(sp)
    800049a8:	e44e                	sd	s3,8(sp)
    800049aa:	1800                	addi	s0,sp,48
    800049ac:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800049ae:	00850913          	addi	s2,a0,8
    800049b2:	854a                	mv	a0,s2
    800049b4:	ffffc097          	auipc	ra,0xffffc
    800049b8:	286080e7          	jalr	646(ra) # 80000c3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800049bc:	409c                	lw	a5,0(s1)
    800049be:	ef99                	bnez	a5,800049dc <holdingsleep+0x3e>
    800049c0:	4481                	li	s1,0
  release(&lk->lk);
    800049c2:	854a                	mv	a0,s2
    800049c4:	ffffc097          	auipc	ra,0xffffc
    800049c8:	32a080e7          	jalr	810(ra) # 80000cee <release>
  return r;
}
    800049cc:	8526                	mv	a0,s1
    800049ce:	70a2                	ld	ra,40(sp)
    800049d0:	7402                	ld	s0,32(sp)
    800049d2:	64e2                	ld	s1,24(sp)
    800049d4:	6942                	ld	s2,16(sp)
    800049d6:	69a2                	ld	s3,8(sp)
    800049d8:	6145                	addi	sp,sp,48
    800049da:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800049dc:	0284a983          	lw	s3,40(s1)
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	28c080e7          	jalr	652(ra) # 80001c6c <myproc>
    800049e8:	5904                	lw	s1,48(a0)
    800049ea:	413484b3          	sub	s1,s1,s3
    800049ee:	0014b493          	seqz	s1,s1
    800049f2:	bfc1                	j	800049c2 <holdingsleep+0x24>

00000000800049f4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049f4:	1141                	addi	sp,sp,-16
    800049f6:	e406                	sd	ra,8(sp)
    800049f8:	e022                	sd	s0,0(sp)
    800049fa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800049fc:	00004597          	auipc	a1,0x4
    80004a00:	ddc58593          	addi	a1,a1,-548 # 800087d8 <syscalls+0x250>
    80004a04:	0001d517          	auipc	a0,0x1d
    80004a08:	4d450513          	addi	a0,a0,1236 # 80021ed8 <ftable>
    80004a0c:	ffffc097          	auipc	ra,0xffffc
    80004a10:	19e080e7          	jalr	414(ra) # 80000baa <initlock>
}
    80004a14:	60a2                	ld	ra,8(sp)
    80004a16:	6402                	ld	s0,0(sp)
    80004a18:	0141                	addi	sp,sp,16
    80004a1a:	8082                	ret

0000000080004a1c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a1c:	1101                	addi	sp,sp,-32
    80004a1e:	ec06                	sd	ra,24(sp)
    80004a20:	e822                	sd	s0,16(sp)
    80004a22:	e426                	sd	s1,8(sp)
    80004a24:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a26:	0001d517          	auipc	a0,0x1d
    80004a2a:	4b250513          	addi	a0,a0,1202 # 80021ed8 <ftable>
    80004a2e:	ffffc097          	auipc	ra,0xffffc
    80004a32:	20c080e7          	jalr	524(ra) # 80000c3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a36:	0001d497          	auipc	s1,0x1d
    80004a3a:	4ba48493          	addi	s1,s1,1210 # 80021ef0 <ftable+0x18>
    80004a3e:	0001e717          	auipc	a4,0x1e
    80004a42:	45270713          	addi	a4,a4,1106 # 80022e90 <ftable+0xfb8>
    if(f->ref == 0){
    80004a46:	40dc                	lw	a5,4(s1)
    80004a48:	cf99                	beqz	a5,80004a66 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a4a:	02848493          	addi	s1,s1,40
    80004a4e:	fee49ce3          	bne	s1,a4,80004a46 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a52:	0001d517          	auipc	a0,0x1d
    80004a56:	48650513          	addi	a0,a0,1158 # 80021ed8 <ftable>
    80004a5a:	ffffc097          	auipc	ra,0xffffc
    80004a5e:	294080e7          	jalr	660(ra) # 80000cee <release>
  return 0;
    80004a62:	4481                	li	s1,0
    80004a64:	a819                	j	80004a7a <filealloc+0x5e>
      f->ref = 1;
    80004a66:	4785                	li	a5,1
    80004a68:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a6a:	0001d517          	auipc	a0,0x1d
    80004a6e:	46e50513          	addi	a0,a0,1134 # 80021ed8 <ftable>
    80004a72:	ffffc097          	auipc	ra,0xffffc
    80004a76:	27c080e7          	jalr	636(ra) # 80000cee <release>
}
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	60e2                	ld	ra,24(sp)
    80004a7e:	6442                	ld	s0,16(sp)
    80004a80:	64a2                	ld	s1,8(sp)
    80004a82:	6105                	addi	sp,sp,32
    80004a84:	8082                	ret

0000000080004a86 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a86:	1101                	addi	sp,sp,-32
    80004a88:	ec06                	sd	ra,24(sp)
    80004a8a:	e822                	sd	s0,16(sp)
    80004a8c:	e426                	sd	s1,8(sp)
    80004a8e:	1000                	addi	s0,sp,32
    80004a90:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a92:	0001d517          	auipc	a0,0x1d
    80004a96:	44650513          	addi	a0,a0,1094 # 80021ed8 <ftable>
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	1a0080e7          	jalr	416(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004aa2:	40dc                	lw	a5,4(s1)
    80004aa4:	02f05263          	blez	a5,80004ac8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004aa8:	2785                	addiw	a5,a5,1
    80004aaa:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004aac:	0001d517          	auipc	a0,0x1d
    80004ab0:	42c50513          	addi	a0,a0,1068 # 80021ed8 <ftable>
    80004ab4:	ffffc097          	auipc	ra,0xffffc
    80004ab8:	23a080e7          	jalr	570(ra) # 80000cee <release>
  return f;
}
    80004abc:	8526                	mv	a0,s1
    80004abe:	60e2                	ld	ra,24(sp)
    80004ac0:	6442                	ld	s0,16(sp)
    80004ac2:	64a2                	ld	s1,8(sp)
    80004ac4:	6105                	addi	sp,sp,32
    80004ac6:	8082                	ret
    panic("filedup");
    80004ac8:	00004517          	auipc	a0,0x4
    80004acc:	d1850513          	addi	a0,a0,-744 # 800087e0 <syscalls+0x258>
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	afc080e7          	jalr	-1284(ra) # 800005cc <panic>

0000000080004ad8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004ad8:	7139                	addi	sp,sp,-64
    80004ada:	fc06                	sd	ra,56(sp)
    80004adc:	f822                	sd	s0,48(sp)
    80004ade:	f426                	sd	s1,40(sp)
    80004ae0:	f04a                	sd	s2,32(sp)
    80004ae2:	ec4e                	sd	s3,24(sp)
    80004ae4:	e852                	sd	s4,16(sp)
    80004ae6:	e456                	sd	s5,8(sp)
    80004ae8:	0080                	addi	s0,sp,64
    80004aea:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004aec:	0001d517          	auipc	a0,0x1d
    80004af0:	3ec50513          	addi	a0,a0,1004 # 80021ed8 <ftable>
    80004af4:	ffffc097          	auipc	ra,0xffffc
    80004af8:	146080e7          	jalr	326(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004afc:	40dc                	lw	a5,4(s1)
    80004afe:	06f05163          	blez	a5,80004b60 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004b02:	37fd                	addiw	a5,a5,-1
    80004b04:	0007871b          	sext.w	a4,a5
    80004b08:	c0dc                	sw	a5,4(s1)
    80004b0a:	06e04363          	bgtz	a4,80004b70 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b0e:	0004a903          	lw	s2,0(s1)
    80004b12:	0094ca83          	lbu	s5,9(s1)
    80004b16:	0104ba03          	ld	s4,16(s1)
    80004b1a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b1e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b22:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b26:	0001d517          	auipc	a0,0x1d
    80004b2a:	3b250513          	addi	a0,a0,946 # 80021ed8 <ftable>
    80004b2e:	ffffc097          	auipc	ra,0xffffc
    80004b32:	1c0080e7          	jalr	448(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004b36:	4785                	li	a5,1
    80004b38:	04f90d63          	beq	s2,a5,80004b92 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b3c:	3979                	addiw	s2,s2,-2
    80004b3e:	4785                	li	a5,1
    80004b40:	0527e063          	bltu	a5,s2,80004b80 <fileclose+0xa8>
    begin_op();
    80004b44:	00000097          	auipc	ra,0x0
    80004b48:	ac8080e7          	jalr	-1336(ra) # 8000460c <begin_op>
    iput(ff.ip);
    80004b4c:	854e                	mv	a0,s3
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	2a6080e7          	jalr	678(ra) # 80003df4 <iput>
    end_op();
    80004b56:	00000097          	auipc	ra,0x0
    80004b5a:	b36080e7          	jalr	-1226(ra) # 8000468c <end_op>
    80004b5e:	a00d                	j	80004b80 <fileclose+0xa8>
    panic("fileclose");
    80004b60:	00004517          	auipc	a0,0x4
    80004b64:	c8850513          	addi	a0,a0,-888 # 800087e8 <syscalls+0x260>
    80004b68:	ffffc097          	auipc	ra,0xffffc
    80004b6c:	a64080e7          	jalr	-1436(ra) # 800005cc <panic>
    release(&ftable.lock);
    80004b70:	0001d517          	auipc	a0,0x1d
    80004b74:	36850513          	addi	a0,a0,872 # 80021ed8 <ftable>
    80004b78:	ffffc097          	auipc	ra,0xffffc
    80004b7c:	176080e7          	jalr	374(ra) # 80000cee <release>
  }
}
    80004b80:	70e2                	ld	ra,56(sp)
    80004b82:	7442                	ld	s0,48(sp)
    80004b84:	74a2                	ld	s1,40(sp)
    80004b86:	7902                	ld	s2,32(sp)
    80004b88:	69e2                	ld	s3,24(sp)
    80004b8a:	6a42                	ld	s4,16(sp)
    80004b8c:	6aa2                	ld	s5,8(sp)
    80004b8e:	6121                	addi	sp,sp,64
    80004b90:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b92:	85d6                	mv	a1,s5
    80004b94:	8552                	mv	a0,s4
    80004b96:	00000097          	auipc	ra,0x0
    80004b9a:	34c080e7          	jalr	844(ra) # 80004ee2 <pipeclose>
    80004b9e:	b7cd                	j	80004b80 <fileclose+0xa8>

0000000080004ba0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ba0:	715d                	addi	sp,sp,-80
    80004ba2:	e486                	sd	ra,72(sp)
    80004ba4:	e0a2                	sd	s0,64(sp)
    80004ba6:	fc26                	sd	s1,56(sp)
    80004ba8:	f84a                	sd	s2,48(sp)
    80004baa:	f44e                	sd	s3,40(sp)
    80004bac:	0880                	addi	s0,sp,80
    80004bae:	84aa                	mv	s1,a0
    80004bb0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	0ba080e7          	jalr	186(ra) # 80001c6c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004bba:	409c                	lw	a5,0(s1)
    80004bbc:	37f9                	addiw	a5,a5,-2
    80004bbe:	4705                	li	a4,1
    80004bc0:	04f76763          	bltu	a4,a5,80004c0e <filestat+0x6e>
    80004bc4:	892a                	mv	s2,a0
    ilock(f->ip);
    80004bc6:	6c88                	ld	a0,24(s1)
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	072080e7          	jalr	114(ra) # 80003c3a <ilock>
    stati(f->ip, &st);
    80004bd0:	fb840593          	addi	a1,s0,-72
    80004bd4:	6c88                	ld	a0,24(s1)
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	2ee080e7          	jalr	750(ra) # 80003ec4 <stati>
    iunlock(f->ip);
    80004bde:	6c88                	ld	a0,24(s1)
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	11c080e7          	jalr	284(ra) # 80003cfc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004be8:	46e1                	li	a3,24
    80004bea:	fb840613          	addi	a2,s0,-72
    80004bee:	85ce                	mv	a1,s3
    80004bf0:	05893503          	ld	a0,88(s2)
    80004bf4:	ffffd097          	auipc	ra,0xffffd
    80004bf8:	c68080e7          	jalr	-920(ra) # 8000185c <copyout>
    80004bfc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004c00:	60a6                	ld	ra,72(sp)
    80004c02:	6406                	ld	s0,64(sp)
    80004c04:	74e2                	ld	s1,56(sp)
    80004c06:	7942                	ld	s2,48(sp)
    80004c08:	79a2                	ld	s3,40(sp)
    80004c0a:	6161                	addi	sp,sp,80
    80004c0c:	8082                	ret
  return -1;
    80004c0e:	557d                	li	a0,-1
    80004c10:	bfc5                	j	80004c00 <filestat+0x60>

0000000080004c12 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c12:	7179                	addi	sp,sp,-48
    80004c14:	f406                	sd	ra,40(sp)
    80004c16:	f022                	sd	s0,32(sp)
    80004c18:	ec26                	sd	s1,24(sp)
    80004c1a:	e84a                	sd	s2,16(sp)
    80004c1c:	e44e                	sd	s3,8(sp)
    80004c1e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c20:	00854783          	lbu	a5,8(a0)
    80004c24:	c3d5                	beqz	a5,80004cc8 <fileread+0xb6>
    80004c26:	84aa                	mv	s1,a0
    80004c28:	89ae                	mv	s3,a1
    80004c2a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c2c:	411c                	lw	a5,0(a0)
    80004c2e:	4705                	li	a4,1
    80004c30:	04e78963          	beq	a5,a4,80004c82 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c34:	470d                	li	a4,3
    80004c36:	04e78d63          	beq	a5,a4,80004c90 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c3a:	4709                	li	a4,2
    80004c3c:	06e79e63          	bne	a5,a4,80004cb8 <fileread+0xa6>
    ilock(f->ip);
    80004c40:	6d08                	ld	a0,24(a0)
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	ff8080e7          	jalr	-8(ra) # 80003c3a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c4a:	874a                	mv	a4,s2
    80004c4c:	5094                	lw	a3,32(s1)
    80004c4e:	864e                	mv	a2,s3
    80004c50:	4585                	li	a1,1
    80004c52:	6c88                	ld	a0,24(s1)
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	29a080e7          	jalr	666(ra) # 80003eee <readi>
    80004c5c:	892a                	mv	s2,a0
    80004c5e:	00a05563          	blez	a0,80004c68 <fileread+0x56>
      f->off += r;
    80004c62:	509c                	lw	a5,32(s1)
    80004c64:	9fa9                	addw	a5,a5,a0
    80004c66:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c68:	6c88                	ld	a0,24(s1)
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	092080e7          	jalr	146(ra) # 80003cfc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004c72:	854a                	mv	a0,s2
    80004c74:	70a2                	ld	ra,40(sp)
    80004c76:	7402                	ld	s0,32(sp)
    80004c78:	64e2                	ld	s1,24(sp)
    80004c7a:	6942                	ld	s2,16(sp)
    80004c7c:	69a2                	ld	s3,8(sp)
    80004c7e:	6145                	addi	sp,sp,48
    80004c80:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c82:	6908                	ld	a0,16(a0)
    80004c84:	00000097          	auipc	ra,0x0
    80004c88:	3c0080e7          	jalr	960(ra) # 80005044 <piperead>
    80004c8c:	892a                	mv	s2,a0
    80004c8e:	b7d5                	j	80004c72 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c90:	02451783          	lh	a5,36(a0)
    80004c94:	03079693          	slli	a3,a5,0x30
    80004c98:	92c1                	srli	a3,a3,0x30
    80004c9a:	4725                	li	a4,9
    80004c9c:	02d76863          	bltu	a4,a3,80004ccc <fileread+0xba>
    80004ca0:	0792                	slli	a5,a5,0x4
    80004ca2:	0001d717          	auipc	a4,0x1d
    80004ca6:	19670713          	addi	a4,a4,406 # 80021e38 <devsw>
    80004caa:	97ba                	add	a5,a5,a4
    80004cac:	639c                	ld	a5,0(a5)
    80004cae:	c38d                	beqz	a5,80004cd0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004cb0:	4505                	li	a0,1
    80004cb2:	9782                	jalr	a5
    80004cb4:	892a                	mv	s2,a0
    80004cb6:	bf75                	j	80004c72 <fileread+0x60>
    panic("fileread");
    80004cb8:	00004517          	auipc	a0,0x4
    80004cbc:	b4050513          	addi	a0,a0,-1216 # 800087f8 <syscalls+0x270>
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	90c080e7          	jalr	-1780(ra) # 800005cc <panic>
    return -1;
    80004cc8:	597d                	li	s2,-1
    80004cca:	b765                	j	80004c72 <fileread+0x60>
      return -1;
    80004ccc:	597d                	li	s2,-1
    80004cce:	b755                	j	80004c72 <fileread+0x60>
    80004cd0:	597d                	li	s2,-1
    80004cd2:	b745                	j	80004c72 <fileread+0x60>

0000000080004cd4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004cd4:	715d                	addi	sp,sp,-80
    80004cd6:	e486                	sd	ra,72(sp)
    80004cd8:	e0a2                	sd	s0,64(sp)
    80004cda:	fc26                	sd	s1,56(sp)
    80004cdc:	f84a                	sd	s2,48(sp)
    80004cde:	f44e                	sd	s3,40(sp)
    80004ce0:	f052                	sd	s4,32(sp)
    80004ce2:	ec56                	sd	s5,24(sp)
    80004ce4:	e85a                	sd	s6,16(sp)
    80004ce6:	e45e                	sd	s7,8(sp)
    80004ce8:	e062                	sd	s8,0(sp)
    80004cea:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004cec:	00954783          	lbu	a5,9(a0)
    80004cf0:	10078663          	beqz	a5,80004dfc <filewrite+0x128>
    80004cf4:	892a                	mv	s2,a0
    80004cf6:	8aae                	mv	s5,a1
    80004cf8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cfa:	411c                	lw	a5,0(a0)
    80004cfc:	4705                	li	a4,1
    80004cfe:	02e78263          	beq	a5,a4,80004d22 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d02:	470d                	li	a4,3
    80004d04:	02e78663          	beq	a5,a4,80004d30 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d08:	4709                	li	a4,2
    80004d0a:	0ee79163          	bne	a5,a4,80004dec <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d0e:	0ac05d63          	blez	a2,80004dc8 <filewrite+0xf4>
    int i = 0;
    80004d12:	4981                	li	s3,0
    80004d14:	6b05                	lui	s6,0x1
    80004d16:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004d1a:	6b85                	lui	s7,0x1
    80004d1c:	c00b8b9b          	addiw	s7,s7,-1024
    80004d20:	a861                	j	80004db8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004d22:	6908                	ld	a0,16(a0)
    80004d24:	00000097          	auipc	ra,0x0
    80004d28:	22e080e7          	jalr	558(ra) # 80004f52 <pipewrite>
    80004d2c:	8a2a                	mv	s4,a0
    80004d2e:	a045                	j	80004dce <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d30:	02451783          	lh	a5,36(a0)
    80004d34:	03079693          	slli	a3,a5,0x30
    80004d38:	92c1                	srli	a3,a3,0x30
    80004d3a:	4725                	li	a4,9
    80004d3c:	0cd76263          	bltu	a4,a3,80004e00 <filewrite+0x12c>
    80004d40:	0792                	slli	a5,a5,0x4
    80004d42:	0001d717          	auipc	a4,0x1d
    80004d46:	0f670713          	addi	a4,a4,246 # 80021e38 <devsw>
    80004d4a:	97ba                	add	a5,a5,a4
    80004d4c:	679c                	ld	a5,8(a5)
    80004d4e:	cbdd                	beqz	a5,80004e04 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004d50:	4505                	li	a0,1
    80004d52:	9782                	jalr	a5
    80004d54:	8a2a                	mv	s4,a0
    80004d56:	a8a5                	j	80004dce <filewrite+0xfa>
    80004d58:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004d5c:	00000097          	auipc	ra,0x0
    80004d60:	8b0080e7          	jalr	-1872(ra) # 8000460c <begin_op>
      ilock(f->ip);
    80004d64:	01893503          	ld	a0,24(s2)
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	ed2080e7          	jalr	-302(ra) # 80003c3a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d70:	8762                	mv	a4,s8
    80004d72:	02092683          	lw	a3,32(s2)
    80004d76:	01598633          	add	a2,s3,s5
    80004d7a:	4585                	li	a1,1
    80004d7c:	01893503          	ld	a0,24(s2)
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	266080e7          	jalr	614(ra) # 80003fe6 <writei>
    80004d88:	84aa                	mv	s1,a0
    80004d8a:	00a05763          	blez	a0,80004d98 <filewrite+0xc4>
        f->off += r;
    80004d8e:	02092783          	lw	a5,32(s2)
    80004d92:	9fa9                	addw	a5,a5,a0
    80004d94:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d98:	01893503          	ld	a0,24(s2)
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	f60080e7          	jalr	-160(ra) # 80003cfc <iunlock>
      end_op();
    80004da4:	00000097          	auipc	ra,0x0
    80004da8:	8e8080e7          	jalr	-1816(ra) # 8000468c <end_op>

      if(r != n1){
    80004dac:	009c1f63          	bne	s8,s1,80004dca <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004db0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004db4:	0149db63          	bge	s3,s4,80004dca <filewrite+0xf6>
      int n1 = n - i;
    80004db8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004dbc:	84be                	mv	s1,a5
    80004dbe:	2781                	sext.w	a5,a5
    80004dc0:	f8fb5ce3          	bge	s6,a5,80004d58 <filewrite+0x84>
    80004dc4:	84de                	mv	s1,s7
    80004dc6:	bf49                	j	80004d58 <filewrite+0x84>
    int i = 0;
    80004dc8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004dca:	013a1f63          	bne	s4,s3,80004de8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004dce:	8552                	mv	a0,s4
    80004dd0:	60a6                	ld	ra,72(sp)
    80004dd2:	6406                	ld	s0,64(sp)
    80004dd4:	74e2                	ld	s1,56(sp)
    80004dd6:	7942                	ld	s2,48(sp)
    80004dd8:	79a2                	ld	s3,40(sp)
    80004dda:	7a02                	ld	s4,32(sp)
    80004ddc:	6ae2                	ld	s5,24(sp)
    80004dde:	6b42                	ld	s6,16(sp)
    80004de0:	6ba2                	ld	s7,8(sp)
    80004de2:	6c02                	ld	s8,0(sp)
    80004de4:	6161                	addi	sp,sp,80
    80004de6:	8082                	ret
    ret = (i == n ? n : -1);
    80004de8:	5a7d                	li	s4,-1
    80004dea:	b7d5                	j	80004dce <filewrite+0xfa>
    panic("filewrite");
    80004dec:	00004517          	auipc	a0,0x4
    80004df0:	a1c50513          	addi	a0,a0,-1508 # 80008808 <syscalls+0x280>
    80004df4:	ffffb097          	auipc	ra,0xffffb
    80004df8:	7d8080e7          	jalr	2008(ra) # 800005cc <panic>
    return -1;
    80004dfc:	5a7d                	li	s4,-1
    80004dfe:	bfc1                	j	80004dce <filewrite+0xfa>
      return -1;
    80004e00:	5a7d                	li	s4,-1
    80004e02:	b7f1                	j	80004dce <filewrite+0xfa>
    80004e04:	5a7d                	li	s4,-1
    80004e06:	b7e1                	j	80004dce <filewrite+0xfa>

0000000080004e08 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e08:	7179                	addi	sp,sp,-48
    80004e0a:	f406                	sd	ra,40(sp)
    80004e0c:	f022                	sd	s0,32(sp)
    80004e0e:	ec26                	sd	s1,24(sp)
    80004e10:	e84a                	sd	s2,16(sp)
    80004e12:	e44e                	sd	s3,8(sp)
    80004e14:	e052                	sd	s4,0(sp)
    80004e16:	1800                	addi	s0,sp,48
    80004e18:	84aa                	mv	s1,a0
    80004e1a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e1c:	0005b023          	sd	zero,0(a1)
    80004e20:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e24:	00000097          	auipc	ra,0x0
    80004e28:	bf8080e7          	jalr	-1032(ra) # 80004a1c <filealloc>
    80004e2c:	e088                	sd	a0,0(s1)
    80004e2e:	c551                	beqz	a0,80004eba <pipealloc+0xb2>
    80004e30:	00000097          	auipc	ra,0x0
    80004e34:	bec080e7          	jalr	-1044(ra) # 80004a1c <filealloc>
    80004e38:	00aa3023          	sd	a0,0(s4)
    80004e3c:	c92d                	beqz	a0,80004eae <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e3e:	ffffc097          	auipc	ra,0xffffc
    80004e42:	d0c080e7          	jalr	-756(ra) # 80000b4a <kalloc>
    80004e46:	892a                	mv	s2,a0
    80004e48:	c125                	beqz	a0,80004ea8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004e4a:	4985                	li	s3,1
    80004e4c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e50:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e54:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e58:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e5c:	00004597          	auipc	a1,0x4
    80004e60:	9bc58593          	addi	a1,a1,-1604 # 80008818 <syscalls+0x290>
    80004e64:	ffffc097          	auipc	ra,0xffffc
    80004e68:	d46080e7          	jalr	-698(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004e6c:	609c                	ld	a5,0(s1)
    80004e6e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e72:	609c                	ld	a5,0(s1)
    80004e74:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e78:	609c                	ld	a5,0(s1)
    80004e7a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e7e:	609c                	ld	a5,0(s1)
    80004e80:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e84:	000a3783          	ld	a5,0(s4)
    80004e88:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e8c:	000a3783          	ld	a5,0(s4)
    80004e90:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e94:	000a3783          	ld	a5,0(s4)
    80004e98:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e9c:	000a3783          	ld	a5,0(s4)
    80004ea0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ea4:	4501                	li	a0,0
    80004ea6:	a025                	j	80004ece <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ea8:	6088                	ld	a0,0(s1)
    80004eaa:	e501                	bnez	a0,80004eb2 <pipealloc+0xaa>
    80004eac:	a039                	j	80004eba <pipealloc+0xb2>
    80004eae:	6088                	ld	a0,0(s1)
    80004eb0:	c51d                	beqz	a0,80004ede <pipealloc+0xd6>
    fileclose(*f0);
    80004eb2:	00000097          	auipc	ra,0x0
    80004eb6:	c26080e7          	jalr	-986(ra) # 80004ad8 <fileclose>
  if(*f1)
    80004eba:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ebe:	557d                	li	a0,-1
  if(*f1)
    80004ec0:	c799                	beqz	a5,80004ece <pipealloc+0xc6>
    fileclose(*f1);
    80004ec2:	853e                	mv	a0,a5
    80004ec4:	00000097          	auipc	ra,0x0
    80004ec8:	c14080e7          	jalr	-1004(ra) # 80004ad8 <fileclose>
  return -1;
    80004ecc:	557d                	li	a0,-1
}
    80004ece:	70a2                	ld	ra,40(sp)
    80004ed0:	7402                	ld	s0,32(sp)
    80004ed2:	64e2                	ld	s1,24(sp)
    80004ed4:	6942                	ld	s2,16(sp)
    80004ed6:	69a2                	ld	s3,8(sp)
    80004ed8:	6a02                	ld	s4,0(sp)
    80004eda:	6145                	addi	sp,sp,48
    80004edc:	8082                	ret
  return -1;
    80004ede:	557d                	li	a0,-1
    80004ee0:	b7fd                	j	80004ece <pipealloc+0xc6>

0000000080004ee2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ee2:	1101                	addi	sp,sp,-32
    80004ee4:	ec06                	sd	ra,24(sp)
    80004ee6:	e822                	sd	s0,16(sp)
    80004ee8:	e426                	sd	s1,8(sp)
    80004eea:	e04a                	sd	s2,0(sp)
    80004eec:	1000                	addi	s0,sp,32
    80004eee:	84aa                	mv	s1,a0
    80004ef0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ef2:	ffffc097          	auipc	ra,0xffffc
    80004ef6:	d48080e7          	jalr	-696(ra) # 80000c3a <acquire>
  if(writable){
    80004efa:	02090d63          	beqz	s2,80004f34 <pipeclose+0x52>
    pi->writeopen = 0;
    80004efe:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f02:	21848513          	addi	a0,s1,536
    80004f06:	ffffd097          	auipc	ra,0xffffd
    80004f0a:	7a4080e7          	jalr	1956(ra) # 800026aa <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f0e:	2204b783          	ld	a5,544(s1)
    80004f12:	eb95                	bnez	a5,80004f46 <pipeclose+0x64>
    release(&pi->lock);
    80004f14:	8526                	mv	a0,s1
    80004f16:	ffffc097          	auipc	ra,0xffffc
    80004f1a:	dd8080e7          	jalr	-552(ra) # 80000cee <release>
    kfree((char*)pi);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	ffffc097          	auipc	ra,0xffffc
    80004f24:	b2e080e7          	jalr	-1234(ra) # 80000a4e <kfree>
  } else
    release(&pi->lock);
}
    80004f28:	60e2                	ld	ra,24(sp)
    80004f2a:	6442                	ld	s0,16(sp)
    80004f2c:	64a2                	ld	s1,8(sp)
    80004f2e:	6902                	ld	s2,0(sp)
    80004f30:	6105                	addi	sp,sp,32
    80004f32:	8082                	ret
    pi->readopen = 0;
    80004f34:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f38:	21c48513          	addi	a0,s1,540
    80004f3c:	ffffd097          	auipc	ra,0xffffd
    80004f40:	76e080e7          	jalr	1902(ra) # 800026aa <wakeup>
    80004f44:	b7e9                	j	80004f0e <pipeclose+0x2c>
    release(&pi->lock);
    80004f46:	8526                	mv	a0,s1
    80004f48:	ffffc097          	auipc	ra,0xffffc
    80004f4c:	da6080e7          	jalr	-602(ra) # 80000cee <release>
}
    80004f50:	bfe1                	j	80004f28 <pipeclose+0x46>

0000000080004f52 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f52:	711d                	addi	sp,sp,-96
    80004f54:	ec86                	sd	ra,88(sp)
    80004f56:	e8a2                	sd	s0,80(sp)
    80004f58:	e4a6                	sd	s1,72(sp)
    80004f5a:	e0ca                	sd	s2,64(sp)
    80004f5c:	fc4e                	sd	s3,56(sp)
    80004f5e:	f852                	sd	s4,48(sp)
    80004f60:	f456                	sd	s5,40(sp)
    80004f62:	f05a                	sd	s6,32(sp)
    80004f64:	ec5e                	sd	s7,24(sp)
    80004f66:	e862                	sd	s8,16(sp)
    80004f68:	1080                	addi	s0,sp,96
    80004f6a:	84aa                	mv	s1,a0
    80004f6c:	8aae                	mv	s5,a1
    80004f6e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f70:	ffffd097          	auipc	ra,0xffffd
    80004f74:	cfc080e7          	jalr	-772(ra) # 80001c6c <myproc>
    80004f78:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	cbe080e7          	jalr	-834(ra) # 80000c3a <acquire>
  while(i < n){
    80004f84:	0b405363          	blez	s4,8000502a <pipewrite+0xd8>
  int i = 0;
    80004f88:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f8a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f8c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f90:	21c48b93          	addi	s7,s1,540
    80004f94:	a089                	j	80004fd6 <pipewrite+0x84>
      release(&pi->lock);
    80004f96:	8526                	mv	a0,s1
    80004f98:	ffffc097          	auipc	ra,0xffffc
    80004f9c:	d56080e7          	jalr	-682(ra) # 80000cee <release>
      return -1;
    80004fa0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004fa2:	854a                	mv	a0,s2
    80004fa4:	60e6                	ld	ra,88(sp)
    80004fa6:	6446                	ld	s0,80(sp)
    80004fa8:	64a6                	ld	s1,72(sp)
    80004faa:	6906                	ld	s2,64(sp)
    80004fac:	79e2                	ld	s3,56(sp)
    80004fae:	7a42                	ld	s4,48(sp)
    80004fb0:	7aa2                	ld	s5,40(sp)
    80004fb2:	7b02                	ld	s6,32(sp)
    80004fb4:	6be2                	ld	s7,24(sp)
    80004fb6:	6c42                	ld	s8,16(sp)
    80004fb8:	6125                	addi	sp,sp,96
    80004fba:	8082                	ret
      wakeup(&pi->nread);
    80004fbc:	8562                	mv	a0,s8
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	6ec080e7          	jalr	1772(ra) # 800026aa <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004fc6:	85a6                	mv	a1,s1
    80004fc8:	855e                	mv	a0,s7
    80004fca:	ffffd097          	auipc	ra,0xffffd
    80004fce:	554080e7          	jalr	1364(ra) # 8000251e <sleep>
  while(i < n){
    80004fd2:	05495d63          	bge	s2,s4,8000502c <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004fd6:	2204a783          	lw	a5,544(s1)
    80004fda:	dfd5                	beqz	a5,80004f96 <pipewrite+0x44>
    80004fdc:	0289a783          	lw	a5,40(s3)
    80004fe0:	fbdd                	bnez	a5,80004f96 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004fe2:	2184a783          	lw	a5,536(s1)
    80004fe6:	21c4a703          	lw	a4,540(s1)
    80004fea:	2007879b          	addiw	a5,a5,512
    80004fee:	fcf707e3          	beq	a4,a5,80004fbc <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ff2:	4685                	li	a3,1
    80004ff4:	01590633          	add	a2,s2,s5
    80004ff8:	faf40593          	addi	a1,s0,-81
    80004ffc:	0589b503          	ld	a0,88(s3)
    80005000:	ffffd097          	auipc	ra,0xffffd
    80005004:	962080e7          	jalr	-1694(ra) # 80001962 <copyin>
    80005008:	03650263          	beq	a0,s6,8000502c <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000500c:	21c4a783          	lw	a5,540(s1)
    80005010:	0017871b          	addiw	a4,a5,1
    80005014:	20e4ae23          	sw	a4,540(s1)
    80005018:	1ff7f793          	andi	a5,a5,511
    8000501c:	97a6                	add	a5,a5,s1
    8000501e:	faf44703          	lbu	a4,-81(s0)
    80005022:	00e78c23          	sb	a4,24(a5)
      i++;
    80005026:	2905                	addiw	s2,s2,1
    80005028:	b76d                	j	80004fd2 <pipewrite+0x80>
  int i = 0;
    8000502a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000502c:	21848513          	addi	a0,s1,536
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	67a080e7          	jalr	1658(ra) # 800026aa <wakeup>
  release(&pi->lock);
    80005038:	8526                	mv	a0,s1
    8000503a:	ffffc097          	auipc	ra,0xffffc
    8000503e:	cb4080e7          	jalr	-844(ra) # 80000cee <release>
  return i;
    80005042:	b785                	j	80004fa2 <pipewrite+0x50>

0000000080005044 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005044:	715d                	addi	sp,sp,-80
    80005046:	e486                	sd	ra,72(sp)
    80005048:	e0a2                	sd	s0,64(sp)
    8000504a:	fc26                	sd	s1,56(sp)
    8000504c:	f84a                	sd	s2,48(sp)
    8000504e:	f44e                	sd	s3,40(sp)
    80005050:	f052                	sd	s4,32(sp)
    80005052:	ec56                	sd	s5,24(sp)
    80005054:	e85a                	sd	s6,16(sp)
    80005056:	0880                	addi	s0,sp,80
    80005058:	84aa                	mv	s1,a0
    8000505a:	892e                	mv	s2,a1
    8000505c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	c0e080e7          	jalr	-1010(ra) # 80001c6c <myproc>
    80005066:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005068:	8526                	mv	a0,s1
    8000506a:	ffffc097          	auipc	ra,0xffffc
    8000506e:	bd0080e7          	jalr	-1072(ra) # 80000c3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005072:	2184a703          	lw	a4,536(s1)
    80005076:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000507a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000507e:	02f71463          	bne	a4,a5,800050a6 <piperead+0x62>
    80005082:	2244a783          	lw	a5,548(s1)
    80005086:	c385                	beqz	a5,800050a6 <piperead+0x62>
    if(pr->killed){
    80005088:	028a2783          	lw	a5,40(s4)
    8000508c:	ebc1                	bnez	a5,8000511c <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000508e:	85a6                	mv	a1,s1
    80005090:	854e                	mv	a0,s3
    80005092:	ffffd097          	auipc	ra,0xffffd
    80005096:	48c080e7          	jalr	1164(ra) # 8000251e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000509a:	2184a703          	lw	a4,536(s1)
    8000509e:	21c4a783          	lw	a5,540(s1)
    800050a2:	fef700e3          	beq	a4,a5,80005082 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050a6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050a8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050aa:	05505363          	blez	s5,800050f0 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    800050ae:	2184a783          	lw	a5,536(s1)
    800050b2:	21c4a703          	lw	a4,540(s1)
    800050b6:	02f70d63          	beq	a4,a5,800050f0 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800050ba:	0017871b          	addiw	a4,a5,1
    800050be:	20e4ac23          	sw	a4,536(s1)
    800050c2:	1ff7f793          	andi	a5,a5,511
    800050c6:	97a6                	add	a5,a5,s1
    800050c8:	0187c783          	lbu	a5,24(a5)
    800050cc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050d0:	4685                	li	a3,1
    800050d2:	fbf40613          	addi	a2,s0,-65
    800050d6:	85ca                	mv	a1,s2
    800050d8:	058a3503          	ld	a0,88(s4)
    800050dc:	ffffc097          	auipc	ra,0xffffc
    800050e0:	780080e7          	jalr	1920(ra) # 8000185c <copyout>
    800050e4:	01650663          	beq	a0,s6,800050f0 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050e8:	2985                	addiw	s3,s3,1
    800050ea:	0905                	addi	s2,s2,1
    800050ec:	fd3a91e3          	bne	s5,s3,800050ae <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800050f0:	21c48513          	addi	a0,s1,540
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	5b6080e7          	jalr	1462(ra) # 800026aa <wakeup>
  release(&pi->lock);
    800050fc:	8526                	mv	a0,s1
    800050fe:	ffffc097          	auipc	ra,0xffffc
    80005102:	bf0080e7          	jalr	-1040(ra) # 80000cee <release>
  return i;
}
    80005106:	854e                	mv	a0,s3
    80005108:	60a6                	ld	ra,72(sp)
    8000510a:	6406                	ld	s0,64(sp)
    8000510c:	74e2                	ld	s1,56(sp)
    8000510e:	7942                	ld	s2,48(sp)
    80005110:	79a2                	ld	s3,40(sp)
    80005112:	7a02                	ld	s4,32(sp)
    80005114:	6ae2                	ld	s5,24(sp)
    80005116:	6b42                	ld	s6,16(sp)
    80005118:	6161                	addi	sp,sp,80
    8000511a:	8082                	ret
      release(&pi->lock);
    8000511c:	8526                	mv	a0,s1
    8000511e:	ffffc097          	auipc	ra,0xffffc
    80005122:	bd0080e7          	jalr	-1072(ra) # 80000cee <release>
      return -1;
    80005126:	59fd                	li	s3,-1
    80005128:	bff9                	j	80005106 <piperead+0xc2>

000000008000512a <exec>:
extern char trampoline[]; // trampoline.S
extern struct proc proc[NPROC];
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    8000512a:	dd010113          	addi	sp,sp,-560
    8000512e:	22113423          	sd	ra,552(sp)
    80005132:	22813023          	sd	s0,544(sp)
    80005136:	20913c23          	sd	s1,536(sp)
    8000513a:	21213823          	sd	s2,528(sp)
    8000513e:	21313423          	sd	s3,520(sp)
    80005142:	21413023          	sd	s4,512(sp)
    80005146:	ffd6                	sd	s5,504(sp)
    80005148:	fbda                	sd	s6,496(sp)
    8000514a:	f7de                	sd	s7,488(sp)
    8000514c:	f3e2                	sd	s8,480(sp)
    8000514e:	efe6                	sd	s9,472(sp)
    80005150:	ebea                	sd	s10,464(sp)
    80005152:	e7ee                	sd	s11,456(sp)
    80005154:	1c00                	addi	s0,sp,560
    80005156:	84aa                	mv	s1,a0
    80005158:	dea43023          	sd	a0,-544(s0)
    8000515c:	deb43423          	sd	a1,-536(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005160:	ffffd097          	auipc	ra,0xffffd
    80005164:	b0c080e7          	jalr	-1268(ra) # 80001c6c <myproc>
    80005168:	dea43c23          	sd	a0,-520(s0)

  begin_op();
    8000516c:	fffff097          	auipc	ra,0xfffff
    80005170:	4a0080e7          	jalr	1184(ra) # 8000460c <begin_op>

  if ((ip = namei(path)) == 0) {
    80005174:	8526                	mv	a0,s1
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	27a080e7          	jalr	634(ra) # 800043f0 <namei>
    8000517e:	cd2d                	beqz	a0,800051f8 <exec+0xce>
    80005180:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	ab8080e7          	jalr	-1352(ra) # 80003c3a <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000518a:	04000713          	li	a4,64
    8000518e:	4681                	li	a3,0
    80005190:	e4840613          	addi	a2,s0,-440
    80005194:	4581                	li	a1,0
    80005196:	8556                	mv	a0,s5
    80005198:	fffff097          	auipc	ra,0xfffff
    8000519c:	d56080e7          	jalr	-682(ra) # 80003eee <readi>
    800051a0:	04000793          	li	a5,64
    800051a4:	00f51a63          	bne	a0,a5,800051b8 <exec+0x8e>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    800051a8:	e4842703          	lw	a4,-440(s0)
    800051ac:	464c47b7          	lui	a5,0x464c4
    800051b0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800051b4:	04f70863          	beq	a4,a5,80005204 <exec+0xda>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800051b8:	8556                	mv	a0,s5
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	ce2080e7          	jalr	-798(ra) # 80003e9c <iunlockput>
    end_op();
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	4ca080e7          	jalr	1226(ra) # 8000468c <end_op>
  }
  return -1;
    800051ca:	557d                	li	a0,-1
}
    800051cc:	22813083          	ld	ra,552(sp)
    800051d0:	22013403          	ld	s0,544(sp)
    800051d4:	21813483          	ld	s1,536(sp)
    800051d8:	21013903          	ld	s2,528(sp)
    800051dc:	20813983          	ld	s3,520(sp)
    800051e0:	20013a03          	ld	s4,512(sp)
    800051e4:	7afe                	ld	s5,504(sp)
    800051e6:	7b5e                	ld	s6,496(sp)
    800051e8:	7bbe                	ld	s7,488(sp)
    800051ea:	7c1e                	ld	s8,480(sp)
    800051ec:	6cfe                	ld	s9,472(sp)
    800051ee:	6d5e                	ld	s10,464(sp)
    800051f0:	6dbe                	ld	s11,456(sp)
    800051f2:	23010113          	addi	sp,sp,560
    800051f6:	8082                	ret
    end_op();
    800051f8:	fffff097          	auipc	ra,0xfffff
    800051fc:	494080e7          	jalr	1172(ra) # 8000468c <end_op>
    return -1;
    80005200:	557d                	li	a0,-1
    80005202:	b7e9                	j	800051cc <exec+0xa2>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005204:	df843503          	ld	a0,-520(s0)
    80005208:	ffffd097          	auipc	ra,0xffffd
    8000520c:	b28080e7          	jalr	-1240(ra) # 80001d30 <proc_pagetable>
    80005210:	8b2a                	mv	s6,a0
    80005212:	d15d                	beqz	a0,800051b8 <exec+0x8e>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005214:	e6842783          	lw	a5,-408(s0)
    80005218:	e8045703          	lhu	a4,-384(s0)
    8000521c:	c735                	beqz	a4,80005288 <exec+0x15e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    8000521e:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005220:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    80005224:	6a05                	lui	s4,0x1
    80005226:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000522a:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    8000522e:	6d85                	lui	s11,0x1
    80005230:	7d7d                	lui	s10,0xfffff
    80005232:	ac81                	j	80005482 <exec+0x358>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80005234:	00003517          	auipc	a0,0x3
    80005238:	5ec50513          	addi	a0,a0,1516 # 80008820 <syscalls+0x298>
    8000523c:	ffffb097          	auipc	ra,0xffffb
    80005240:	390080e7          	jalr	912(ra) # 800005cc <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80005244:	874a                	mv	a4,s2
    80005246:	009c86bb          	addw	a3,s9,s1
    8000524a:	4581                	li	a1,0
    8000524c:	8556                	mv	a0,s5
    8000524e:	fffff097          	auipc	ra,0xfffff
    80005252:	ca0080e7          	jalr	-864(ra) # 80003eee <readi>
    80005256:	2501                	sext.w	a0,a0
    80005258:	1ca91563          	bne	s2,a0,80005422 <exec+0x2f8>
  for (i = 0; i < sz; i += PGSIZE) {
    8000525c:	009d84bb          	addw	s1,s11,s1
    80005260:	013d09bb          	addw	s3,s10,s3
    80005264:	1f74ff63          	bgeu	s1,s7,80005462 <exec+0x338>
    pa = walkaddr(pagetable, va + i);
    80005268:	02049593          	slli	a1,s1,0x20
    8000526c:	9181                	srli	a1,a1,0x20
    8000526e:	95e2                	add	a1,a1,s8
    80005270:	855a                	mv	a0,s6
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	e52080e7          	jalr	-430(ra) # 800010c4 <walkaddr>
    8000527a:	862a                	mv	a2,a0
    if (pa == 0)
    8000527c:	dd45                	beqz	a0,80005234 <exec+0x10a>
      n = PGSIZE;
    8000527e:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80005280:	fd49f2e3          	bgeu	s3,s4,80005244 <exec+0x11a>
      n = sz - i;
    80005284:	894e                	mv	s2,s3
    80005286:	bf7d                	j	80005244 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80005288:	4481                	li	s1,0
  iunlockput(ip);
    8000528a:	8556                	mv	a0,s5
    8000528c:	fffff097          	auipc	ra,0xfffff
    80005290:	c10080e7          	jalr	-1008(ra) # 80003e9c <iunlockput>
  end_op();
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	3f8080e7          	jalr	1016(ra) # 8000468c <end_op>
  uint64 oldsz = p->sz;
    8000529c:	df843983          	ld	s3,-520(s0)
    800052a0:	0509bc83          	ld	s9,80(s3)
  sz = PGROUNDUP(sz);
    800052a4:	6785                	lui	a5,0x1
    800052a6:	17fd                	addi	a5,a5,-1
    800052a8:	94be                	add	s1,s1,a5
    800052aa:	77fd                	lui	a5,0xfffff
    800052ac:	00f4f933          	and	s2,s1,a5
    800052b0:	df243823          	sd	s2,-528(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + (1 << 6) * PGSIZE)) == 0)
    800052b4:	000404b7          	lui	s1,0x40
    800052b8:	94ca                	add	s1,s1,s2
    800052ba:	8626                	mv	a2,s1
    800052bc:	85ca                	mv	a1,s2
    800052be:	855a                	mv	a0,s6
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	242080e7          	jalr	578(ra) # 80001502 <uvmalloc>
    800052c8:	8baa                	mv	s7,a0
  ip = 0;
    800052ca:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + (1 << 6) * PGSIZE)) == 0)
    800052cc:	14050b63          	beqz	a0,80005422 <exec+0x2f8>
  uvmapping(pagetable, p->k_pagetable, sz, sz + (1 << 6) * PGSIZE);
    800052d0:	86a6                	mv	a3,s1
    800052d2:	864a                	mv	a2,s2
    800052d4:	0609b583          	ld	a1,96(s3)
    800052d8:	855a                	mv	a0,s6
    800052da:	ffffc097          	auipc	ra,0xffffc
    800052de:	13a080e7          	jalr	314(ra) # 80001414 <uvmapping>
  uvmclear(pagetable, sz - (1 << 6) * PGSIZE);
    800052e2:	fffc05b7          	lui	a1,0xfffc0
    800052e6:	95de                	add	a1,a1,s7
    800052e8:	855a                	mv	a0,s6
    800052ea:	ffffc097          	auipc	ra,0xffffc
    800052ee:	540080e7          	jalr	1344(ra) # 8000182a <uvmclear>
  stackbase = sp - PGSIZE;
    800052f2:	7afd                	lui	s5,0xfffff
    800052f4:	9ade                	add	s5,s5,s7
  for (argc = 0; argv[argc]; argc++) {
    800052f6:	de843783          	ld	a5,-536(s0)
    800052fa:	6388                	ld	a0,0(a5)
    800052fc:	c925                	beqz	a0,8000536c <exec+0x242>
    800052fe:	e8840993          	addi	s3,s0,-376
    80005302:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005306:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    80005308:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000530a:	ffffc097          	auipc	ra,0xffffc
    8000530e:	bb0080e7          	jalr	-1104(ra) # 80000eba <strlen>
    80005312:	0015079b          	addiw	a5,a0,1
    80005316:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000531a:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000531e:	13596663          	bltu	s2,s5,8000544a <exec+0x320>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005322:	de843d03          	ld	s10,-536(s0)
    80005326:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd9000>
    8000532a:	8552                	mv	a0,s4
    8000532c:	ffffc097          	auipc	ra,0xffffc
    80005330:	b8e080e7          	jalr	-1138(ra) # 80000eba <strlen>
    80005334:	0015069b          	addiw	a3,a0,1
    80005338:	8652                	mv	a2,s4
    8000533a:	85ca                	mv	a1,s2
    8000533c:	855a                	mv	a0,s6
    8000533e:	ffffc097          	auipc	ra,0xffffc
    80005342:	51e080e7          	jalr	1310(ra) # 8000185c <copyout>
    80005346:	10054663          	bltz	a0,80005452 <exec+0x328>
    ustack[argc] = sp;
    8000534a:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000534e:	0485                	addi	s1,s1,1
    80005350:	008d0793          	addi	a5,s10,8
    80005354:	def43423          	sd	a5,-536(s0)
    80005358:	008d3503          	ld	a0,8(s10)
    8000535c:	c911                	beqz	a0,80005370 <exec+0x246>
    if (argc >= MAXARG)
    8000535e:	09a1                	addi	s3,s3,8
    80005360:	fb3c15e3          	bne	s8,s3,8000530a <exec+0x1e0>
  sz = sz1;
    80005364:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005368:	4a81                	li	s5,0
    8000536a:	a865                	j	80005422 <exec+0x2f8>
  sp = sz;
    8000536c:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    8000536e:	4481                	li	s1,0
  ustack[argc] = 0;
    80005370:	00349793          	slli	a5,s1,0x3
    80005374:	f9040713          	addi	a4,s0,-112
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc + 1) * sizeof(uint64);
    8000537e:	00148693          	addi	a3,s1,1 # 40001 <_entry-0x7ffbffff>
    80005382:	068e                	slli	a3,a3,0x3
    80005384:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005388:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000538c:	01597663          	bgeu	s2,s5,80005398 <exec+0x26e>
  sz = sz1;
    80005390:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005394:	4a81                	li	s5,0
    80005396:	a071                	j	80005422 <exec+0x2f8>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80005398:	e8840613          	addi	a2,s0,-376
    8000539c:	85ca                	mv	a1,s2
    8000539e:	855a                	mv	a0,s6
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	4bc080e7          	jalr	1212(ra) # 8000185c <copyout>
    800053a8:	0a054963          	bltz	a0,8000545a <exec+0x330>
  p->trapframe->a1 = sp;
    800053ac:	df843783          	ld	a5,-520(s0)
    800053b0:	77bc                	ld	a5,104(a5)
    800053b2:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800053b6:	de043783          	ld	a5,-544(s0)
    800053ba:	0007c703          	lbu	a4,0(a5)
    800053be:	cf11                	beqz	a4,800053da <exec+0x2b0>
    800053c0:	0785                	addi	a5,a5,1
    if (*s == '/')
    800053c2:	02f00693          	li	a3,47
    800053c6:	a039                	j	800053d4 <exec+0x2aa>
      last = s + 1;
    800053c8:	def43023          	sd	a5,-544(s0)
  for (last = s = path; *s; s++)
    800053cc:	0785                	addi	a5,a5,1
    800053ce:	fff7c703          	lbu	a4,-1(a5)
    800053d2:	c701                	beqz	a4,800053da <exec+0x2b0>
    if (*s == '/')
    800053d4:	fed71ce3          	bne	a4,a3,800053cc <exec+0x2a2>
    800053d8:	bfc5                	j	800053c8 <exec+0x29e>
  safestrcpy(p->name, last, sizeof(p->name));
    800053da:	4641                	li	a2,16
    800053dc:	de043583          	ld	a1,-544(s0)
    800053e0:	df843983          	ld	s3,-520(s0)
    800053e4:	18098513          	addi	a0,s3,384
    800053e8:	ffffc097          	auipc	ra,0xffffc
    800053ec:	aa0080e7          	jalr	-1376(ra) # 80000e88 <safestrcpy>
  oldpagetable = p->pagetable;
    800053f0:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    800053f4:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    800053f8:	0579b823          	sd	s7,80(s3)
  p->trapframe->epc = elf.entry; // initial program counter = main
    800053fc:	0689b783          	ld	a5,104(s3)
    80005400:	e6043703          	ld	a4,-416(s0)
    80005404:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80005406:	0689b783          	ld	a5,104(s3)
    8000540a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000540e:	85e6                	mv	a1,s9
    80005410:	ffffd097          	auipc	ra,0xffffd
    80005414:	9bc080e7          	jalr	-1604(ra) # 80001dcc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005418:	0004851b          	sext.w	a0,s1
    8000541c:	bb45                	j	800051cc <exec+0xa2>
    8000541e:	de943823          	sd	s1,-528(s0)
    proc_freepagetable(pagetable, sz);
    80005422:	df043583          	ld	a1,-528(s0)
    80005426:	855a                	mv	a0,s6
    80005428:	ffffd097          	auipc	ra,0xffffd
    8000542c:	9a4080e7          	jalr	-1628(ra) # 80001dcc <proc_freepagetable>
  if (ip) {
    80005430:	d80a94e3          	bnez	s5,800051b8 <exec+0x8e>
  return -1;
    80005434:	557d                	li	a0,-1
    80005436:	bb59                	j	800051cc <exec+0xa2>
    80005438:	de943823          	sd	s1,-528(s0)
    8000543c:	b7dd                	j	80005422 <exec+0x2f8>
    8000543e:	de943823          	sd	s1,-528(s0)
    80005442:	b7c5                	j	80005422 <exec+0x2f8>
    80005444:	de943823          	sd	s1,-528(s0)
    80005448:	bfe9                	j	80005422 <exec+0x2f8>
  sz = sz1;
    8000544a:	df743823          	sd	s7,-528(s0)
  ip = 0;
    8000544e:	4a81                	li	s5,0
    80005450:	bfc9                	j	80005422 <exec+0x2f8>
  sz = sz1;
    80005452:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005456:	4a81                	li	s5,0
    80005458:	b7e9                	j	80005422 <exec+0x2f8>
  sz = sz1;
    8000545a:	df743823          	sd	s7,-528(s0)
  ip = 0;
    8000545e:	4a81                	li	s5,0
    80005460:	b7c9                	j	80005422 <exec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005462:	df043483          	ld	s1,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005466:	e0843783          	ld	a5,-504(s0)
    8000546a:	0017869b          	addiw	a3,a5,1
    8000546e:	e0d43423          	sd	a3,-504(s0)
    80005472:	e0043783          	ld	a5,-512(s0)
    80005476:	0387879b          	addiw	a5,a5,56
    8000547a:	e8045703          	lhu	a4,-384(s0)
    8000547e:	e0e6d6e3          	bge	a3,a4,8000528a <exec+0x160>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005482:	2781                	sext.w	a5,a5
    80005484:	e0f43023          	sd	a5,-512(s0)
    80005488:	03800713          	li	a4,56
    8000548c:	86be                	mv	a3,a5
    8000548e:	e1040613          	addi	a2,s0,-496
    80005492:	4581                	li	a1,0
    80005494:	8556                	mv	a0,s5
    80005496:	fffff097          	auipc	ra,0xfffff
    8000549a:	a58080e7          	jalr	-1448(ra) # 80003eee <readi>
    8000549e:	03800793          	li	a5,56
    800054a2:	f6f51ee3          	bne	a0,a5,8000541e <exec+0x2f4>
    if (ph.type != ELF_PROG_LOAD)
    800054a6:	e1042783          	lw	a5,-496(s0)
    800054aa:	4705                	li	a4,1
    800054ac:	fae79de3          	bne	a5,a4,80005466 <exec+0x33c>
    if (ph.memsz < ph.filesz)
    800054b0:	e3843603          	ld	a2,-456(s0)
    800054b4:	e3043783          	ld	a5,-464(s0)
    800054b8:	f8f660e3          	bltu	a2,a5,80005438 <exec+0x30e>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800054bc:	e2043783          	ld	a5,-480(s0)
    800054c0:	963e                	add	a2,a2,a5
    800054c2:	f6f66ee3          	bltu	a2,a5,8000543e <exec+0x314>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800054c6:	85a6                	mv	a1,s1
    800054c8:	855a                	mv	a0,s6
    800054ca:	ffffc097          	auipc	ra,0xffffc
    800054ce:	038080e7          	jalr	56(ra) # 80001502 <uvmalloc>
    800054d2:	dea43823          	sd	a0,-528(s0)
    800054d6:	d53d                	beqz	a0,80005444 <exec+0x31a>
    uvmapping(pagetable, p->k_pagetable, sz, ph.vaddr + ph.memsz);
    800054d8:	e2043683          	ld	a3,-480(s0)
    800054dc:	e3843783          	ld	a5,-456(s0)
    800054e0:	96be                	add	a3,a3,a5
    800054e2:	8626                	mv	a2,s1
    800054e4:	df843783          	ld	a5,-520(s0)
    800054e8:	73ac                	ld	a1,96(a5)
    800054ea:	855a                	mv	a0,s6
    800054ec:	ffffc097          	auipc	ra,0xffffc
    800054f0:	f28080e7          	jalr	-216(ra) # 80001414 <uvmapping>
    if (ph.vaddr % PGSIZE != 0)
    800054f4:	e2043c03          	ld	s8,-480(s0)
    800054f8:	dd843783          	ld	a5,-552(s0)
    800054fc:	00fc77b3          	and	a5,s8,a5
    80005500:	f38d                	bnez	a5,80005422 <exec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005502:	e1842c83          	lw	s9,-488(s0)
    80005506:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000550a:	f40b8ce3          	beqz	s7,80005462 <exec+0x338>
    8000550e:	89de                	mv	s3,s7
    80005510:	4481                	li	s1,0
    80005512:	bb99                	j	80005268 <exec+0x13e>

0000000080005514 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    80005514:	7179                	addi	sp,sp,-48
    80005516:	f406                	sd	ra,40(sp)
    80005518:	f022                	sd	s0,32(sp)
    8000551a:	ec26                	sd	s1,24(sp)
    8000551c:	e84a                	sd	s2,16(sp)
    8000551e:	1800                	addi	s0,sp,48
    80005520:	892e                	mv	s2,a1
    80005522:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    80005524:	fdc40593          	addi	a1,s0,-36
    80005528:	ffffe097          	auipc	ra,0xffffe
    8000552c:	a9e080e7          	jalr	-1378(ra) # 80002fc6 <argint>
    80005530:	04054063          	bltz	a0,80005570 <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80005534:	fdc42703          	lw	a4,-36(s0)
    80005538:	47bd                	li	a5,15
    8000553a:	02e7ed63          	bltu	a5,a4,80005574 <argfd+0x60>
    8000553e:	ffffc097          	auipc	ra,0xffffc
    80005542:	72e080e7          	jalr	1838(ra) # 80001c6c <myproc>
    80005546:	fdc42703          	lw	a4,-36(s0)
    8000554a:	01c70793          	addi	a5,a4,28
    8000554e:	078e                	slli	a5,a5,0x3
    80005550:	953e                	add	a0,a0,a5
    80005552:	611c                	ld	a5,0(a0)
    80005554:	c395                	beqz	a5,80005578 <argfd+0x64>
    return -1;
  if (pfd)
    80005556:	00090463          	beqz	s2,8000555e <argfd+0x4a>
    *pfd = fd;
    8000555a:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    8000555e:	4501                	li	a0,0
  if (pf)
    80005560:	c091                	beqz	s1,80005564 <argfd+0x50>
    *pf = f;
    80005562:	e09c                	sd	a5,0(s1)
}
    80005564:	70a2                	ld	ra,40(sp)
    80005566:	7402                	ld	s0,32(sp)
    80005568:	64e2                	ld	s1,24(sp)
    8000556a:	6942                	ld	s2,16(sp)
    8000556c:	6145                	addi	sp,sp,48
    8000556e:	8082                	ret
    return -1;
    80005570:	557d                	li	a0,-1
    80005572:	bfcd                	j	80005564 <argfd+0x50>
    return -1;
    80005574:	557d                	li	a0,-1
    80005576:	b7fd                	j	80005564 <argfd+0x50>
    80005578:	557d                	li	a0,-1
    8000557a:	b7ed                	j	80005564 <argfd+0x50>

000000008000557c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    8000557c:	1101                	addi	sp,sp,-32
    8000557e:	ec06                	sd	ra,24(sp)
    80005580:	e822                	sd	s0,16(sp)
    80005582:	e426                	sd	s1,8(sp)
    80005584:	1000                	addi	s0,sp,32
    80005586:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005588:	ffffc097          	auipc	ra,0xffffc
    8000558c:	6e4080e7          	jalr	1764(ra) # 80001c6c <myproc>
    80005590:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80005592:	0e050793          	addi	a5,a0,224
    80005596:	4501                	li	a0,0
    80005598:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000559a:	6398                	ld	a4,0(a5)
    8000559c:	cb19                	beqz	a4,800055b2 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    8000559e:	2505                	addiw	a0,a0,1
    800055a0:	07a1                	addi	a5,a5,8
    800055a2:	fed51ce3          	bne	a0,a3,8000559a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800055a6:	557d                	li	a0,-1
}
    800055a8:	60e2                	ld	ra,24(sp)
    800055aa:	6442                	ld	s0,16(sp)
    800055ac:	64a2                	ld	s1,8(sp)
    800055ae:	6105                	addi	sp,sp,32
    800055b0:	8082                	ret
      p->ofile[fd] = f;
    800055b2:	01c50793          	addi	a5,a0,28
    800055b6:	078e                	slli	a5,a5,0x3
    800055b8:	963e                	add	a2,a2,a5
    800055ba:	e204                	sd	s1,0(a2)
      return fd;
    800055bc:	b7f5                	j	800055a8 <fdalloc+0x2c>

00000000800055be <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    800055be:	715d                	addi	sp,sp,-80
    800055c0:	e486                	sd	ra,72(sp)
    800055c2:	e0a2                	sd	s0,64(sp)
    800055c4:	fc26                	sd	s1,56(sp)
    800055c6:	f84a                	sd	s2,48(sp)
    800055c8:	f44e                	sd	s3,40(sp)
    800055ca:	f052                	sd	s4,32(sp)
    800055cc:	ec56                	sd	s5,24(sp)
    800055ce:	0880                	addi	s0,sp,80
    800055d0:	89ae                	mv	s3,a1
    800055d2:	8ab2                	mv	s5,a2
    800055d4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800055d6:	fb040593          	addi	a1,s0,-80
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	e34080e7          	jalr	-460(ra) # 8000440e <nameiparent>
    800055e2:	892a                	mv	s2,a0
    800055e4:	12050e63          	beqz	a0,80005720 <create+0x162>
    return 0;

  ilock(dp);
    800055e8:	ffffe097          	auipc	ra,0xffffe
    800055ec:	652080e7          	jalr	1618(ra) # 80003c3a <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800055f0:	4601                	li	a2,0
    800055f2:	fb040593          	addi	a1,s0,-80
    800055f6:	854a                	mv	a0,s2
    800055f8:	fffff097          	auipc	ra,0xfffff
    800055fc:	b26080e7          	jalr	-1242(ra) # 8000411e <dirlookup>
    80005600:	84aa                	mv	s1,a0
    80005602:	c921                	beqz	a0,80005652 <create+0x94>
    iunlockput(dp);
    80005604:	854a                	mv	a0,s2
    80005606:	fffff097          	auipc	ra,0xfffff
    8000560a:	896080e7          	jalr	-1898(ra) # 80003e9c <iunlockput>
    ilock(ip);
    8000560e:	8526                	mv	a0,s1
    80005610:	ffffe097          	auipc	ra,0xffffe
    80005614:	62a080e7          	jalr	1578(ra) # 80003c3a <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005618:	2981                	sext.w	s3,s3
    8000561a:	4789                	li	a5,2
    8000561c:	02f99463          	bne	s3,a5,80005644 <create+0x86>
    80005620:	0444d783          	lhu	a5,68(s1)
    80005624:	37f9                	addiw	a5,a5,-2
    80005626:	17c2                	slli	a5,a5,0x30
    80005628:	93c1                	srli	a5,a5,0x30
    8000562a:	4705                	li	a4,1
    8000562c:	00f76c63          	bltu	a4,a5,80005644 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005630:	8526                	mv	a0,s1
    80005632:	60a6                	ld	ra,72(sp)
    80005634:	6406                	ld	s0,64(sp)
    80005636:	74e2                	ld	s1,56(sp)
    80005638:	7942                	ld	s2,48(sp)
    8000563a:	79a2                	ld	s3,40(sp)
    8000563c:	7a02                	ld	s4,32(sp)
    8000563e:	6ae2                	ld	s5,24(sp)
    80005640:	6161                	addi	sp,sp,80
    80005642:	8082                	ret
    iunlockput(ip);
    80005644:	8526                	mv	a0,s1
    80005646:	fffff097          	auipc	ra,0xfffff
    8000564a:	856080e7          	jalr	-1962(ra) # 80003e9c <iunlockput>
    return 0;
    8000564e:	4481                	li	s1,0
    80005650:	b7c5                	j	80005630 <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80005652:	85ce                	mv	a1,s3
    80005654:	00092503          	lw	a0,0(s2)
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	44a080e7          	jalr	1098(ra) # 80003aa2 <ialloc>
    80005660:	84aa                	mv	s1,a0
    80005662:	c521                	beqz	a0,800056aa <create+0xec>
  ilock(ip);
    80005664:	ffffe097          	auipc	ra,0xffffe
    80005668:	5d6080e7          	jalr	1494(ra) # 80003c3a <ilock>
  ip->major = major;
    8000566c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005670:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005674:	4a05                	li	s4,1
    80005676:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000567a:	8526                	mv	a0,s1
    8000567c:	ffffe097          	auipc	ra,0xffffe
    80005680:	4f4080e7          	jalr	1268(ra) # 80003b70 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80005684:	2981                	sext.w	s3,s3
    80005686:	03498a63          	beq	s3,s4,800056ba <create+0xfc>
  if (dirlink(dp, name, ip->inum) < 0)
    8000568a:	40d0                	lw	a2,4(s1)
    8000568c:	fb040593          	addi	a1,s0,-80
    80005690:	854a                	mv	a0,s2
    80005692:	fffff097          	auipc	ra,0xfffff
    80005696:	c9c080e7          	jalr	-868(ra) # 8000432e <dirlink>
    8000569a:	06054b63          	bltz	a0,80005710 <create+0x152>
  iunlockput(dp);
    8000569e:	854a                	mv	a0,s2
    800056a0:	ffffe097          	auipc	ra,0xffffe
    800056a4:	7fc080e7          	jalr	2044(ra) # 80003e9c <iunlockput>
  return ip;
    800056a8:	b761                	j	80005630 <create+0x72>
    panic("create: ialloc");
    800056aa:	00003517          	auipc	a0,0x3
    800056ae:	19650513          	addi	a0,a0,406 # 80008840 <syscalls+0x2b8>
    800056b2:	ffffb097          	auipc	ra,0xffffb
    800056b6:	f1a080e7          	jalr	-230(ra) # 800005cc <panic>
    dp->nlink++;       // for ".."
    800056ba:	04a95783          	lhu	a5,74(s2)
    800056be:	2785                	addiw	a5,a5,1
    800056c0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800056c4:	854a                	mv	a0,s2
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	4aa080e7          	jalr	1194(ra) # 80003b70 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056ce:	40d0                	lw	a2,4(s1)
    800056d0:	00003597          	auipc	a1,0x3
    800056d4:	18058593          	addi	a1,a1,384 # 80008850 <syscalls+0x2c8>
    800056d8:	8526                	mv	a0,s1
    800056da:	fffff097          	auipc	ra,0xfffff
    800056de:	c54080e7          	jalr	-940(ra) # 8000432e <dirlink>
    800056e2:	00054f63          	bltz	a0,80005700 <create+0x142>
    800056e6:	00492603          	lw	a2,4(s2)
    800056ea:	00003597          	auipc	a1,0x3
    800056ee:	b7e58593          	addi	a1,a1,-1154 # 80008268 <digits+0x200>
    800056f2:	8526                	mv	a0,s1
    800056f4:	fffff097          	auipc	ra,0xfffff
    800056f8:	c3a080e7          	jalr	-966(ra) # 8000432e <dirlink>
    800056fc:	f80557e3          	bgez	a0,8000568a <create+0xcc>
      panic("create dots");
    80005700:	00003517          	auipc	a0,0x3
    80005704:	15850513          	addi	a0,a0,344 # 80008858 <syscalls+0x2d0>
    80005708:	ffffb097          	auipc	ra,0xffffb
    8000570c:	ec4080e7          	jalr	-316(ra) # 800005cc <panic>
    panic("create: dirlink");
    80005710:	00003517          	auipc	a0,0x3
    80005714:	15850513          	addi	a0,a0,344 # 80008868 <syscalls+0x2e0>
    80005718:	ffffb097          	auipc	ra,0xffffb
    8000571c:	eb4080e7          	jalr	-332(ra) # 800005cc <panic>
    return 0;
    80005720:	84aa                	mv	s1,a0
    80005722:	b739                	j	80005630 <create+0x72>

0000000080005724 <sys_dup>:
uint64 sys_dup(void) {
    80005724:	7179                	addi	sp,sp,-48
    80005726:	f406                	sd	ra,40(sp)
    80005728:	f022                	sd	s0,32(sp)
    8000572a:	ec26                	sd	s1,24(sp)
    8000572c:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000572e:	fd840613          	addi	a2,s0,-40
    80005732:	4581                	li	a1,0
    80005734:	4501                	li	a0,0
    80005736:	00000097          	auipc	ra,0x0
    8000573a:	dde080e7          	jalr	-546(ra) # 80005514 <argfd>
    return -1;
    8000573e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80005740:	02054363          	bltz	a0,80005766 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80005744:	fd843503          	ld	a0,-40(s0)
    80005748:	00000097          	auipc	ra,0x0
    8000574c:	e34080e7          	jalr	-460(ra) # 8000557c <fdalloc>
    80005750:	84aa                	mv	s1,a0
    return -1;
    80005752:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80005754:	00054963          	bltz	a0,80005766 <sys_dup+0x42>
  filedup(f);
    80005758:	fd843503          	ld	a0,-40(s0)
    8000575c:	fffff097          	auipc	ra,0xfffff
    80005760:	32a080e7          	jalr	810(ra) # 80004a86 <filedup>
  return fd;
    80005764:	87a6                	mv	a5,s1
}
    80005766:	853e                	mv	a0,a5
    80005768:	70a2                	ld	ra,40(sp)
    8000576a:	7402                	ld	s0,32(sp)
    8000576c:	64e2                	ld	s1,24(sp)
    8000576e:	6145                	addi	sp,sp,48
    80005770:	8082                	ret

0000000080005772 <sys_read>:
uint64 sys_read(void) {
    80005772:	7179                	addi	sp,sp,-48
    80005774:	f406                	sd	ra,40(sp)
    80005776:	f022                	sd	s0,32(sp)
    80005778:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000577a:	fe840613          	addi	a2,s0,-24
    8000577e:	4581                	li	a1,0
    80005780:	4501                	li	a0,0
    80005782:	00000097          	auipc	ra,0x0
    80005786:	d92080e7          	jalr	-622(ra) # 80005514 <argfd>
    return -1;
    8000578a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000578c:	04054163          	bltz	a0,800057ce <sys_read+0x5c>
    80005790:	fe440593          	addi	a1,s0,-28
    80005794:	4509                	li	a0,2
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	830080e7          	jalr	-2000(ra) # 80002fc6 <argint>
    return -1;
    8000579e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057a0:	02054763          	bltz	a0,800057ce <sys_read+0x5c>
    800057a4:	fd840593          	addi	a1,s0,-40
    800057a8:	4505                	li	a0,1
    800057aa:	ffffe097          	auipc	ra,0xffffe
    800057ae:	83e080e7          	jalr	-1986(ra) # 80002fe8 <argaddr>
    return -1;
    800057b2:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057b4:	00054d63          	bltz	a0,800057ce <sys_read+0x5c>
  return fileread(f, p, n);
    800057b8:	fe442603          	lw	a2,-28(s0)
    800057bc:	fd843583          	ld	a1,-40(s0)
    800057c0:	fe843503          	ld	a0,-24(s0)
    800057c4:	fffff097          	auipc	ra,0xfffff
    800057c8:	44e080e7          	jalr	1102(ra) # 80004c12 <fileread>
    800057cc:	87aa                	mv	a5,a0
}
    800057ce:	853e                	mv	a0,a5
    800057d0:	70a2                	ld	ra,40(sp)
    800057d2:	7402                	ld	s0,32(sp)
    800057d4:	6145                	addi	sp,sp,48
    800057d6:	8082                	ret

00000000800057d8 <sys_write>:
uint64 sys_write(void) {
    800057d8:	7179                	addi	sp,sp,-48
    800057da:	f406                	sd	ra,40(sp)
    800057dc:	f022                	sd	s0,32(sp)
    800057de:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057e0:	fe840613          	addi	a2,s0,-24
    800057e4:	4581                	li	a1,0
    800057e6:	4501                	li	a0,0
    800057e8:	00000097          	auipc	ra,0x0
    800057ec:	d2c080e7          	jalr	-724(ra) # 80005514 <argfd>
    return -1;
    800057f0:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057f2:	04054163          	bltz	a0,80005834 <sys_write+0x5c>
    800057f6:	fe440593          	addi	a1,s0,-28
    800057fa:	4509                	li	a0,2
    800057fc:	ffffd097          	auipc	ra,0xffffd
    80005800:	7ca080e7          	jalr	1994(ra) # 80002fc6 <argint>
    return -1;
    80005804:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005806:	02054763          	bltz	a0,80005834 <sys_write+0x5c>
    8000580a:	fd840593          	addi	a1,s0,-40
    8000580e:	4505                	li	a0,1
    80005810:	ffffd097          	auipc	ra,0xffffd
    80005814:	7d8080e7          	jalr	2008(ra) # 80002fe8 <argaddr>
    return -1;
    80005818:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000581a:	00054d63          	bltz	a0,80005834 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000581e:	fe442603          	lw	a2,-28(s0)
    80005822:	fd843583          	ld	a1,-40(s0)
    80005826:	fe843503          	ld	a0,-24(s0)
    8000582a:	fffff097          	auipc	ra,0xfffff
    8000582e:	4aa080e7          	jalr	1194(ra) # 80004cd4 <filewrite>
    80005832:	87aa                	mv	a5,a0
}
    80005834:	853e                	mv	a0,a5
    80005836:	70a2                	ld	ra,40(sp)
    80005838:	7402                	ld	s0,32(sp)
    8000583a:	6145                	addi	sp,sp,48
    8000583c:	8082                	ret

000000008000583e <sys_close>:
uint64 sys_close(void) {
    8000583e:	1101                	addi	sp,sp,-32
    80005840:	ec06                	sd	ra,24(sp)
    80005842:	e822                	sd	s0,16(sp)
    80005844:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80005846:	fe040613          	addi	a2,s0,-32
    8000584a:	fec40593          	addi	a1,s0,-20
    8000584e:	4501                	li	a0,0
    80005850:	00000097          	auipc	ra,0x0
    80005854:	cc4080e7          	jalr	-828(ra) # 80005514 <argfd>
    return -1;
    80005858:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000585a:	02054463          	bltz	a0,80005882 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000585e:	ffffc097          	auipc	ra,0xffffc
    80005862:	40e080e7          	jalr	1038(ra) # 80001c6c <myproc>
    80005866:	fec42783          	lw	a5,-20(s0)
    8000586a:	07f1                	addi	a5,a5,28
    8000586c:	078e                	slli	a5,a5,0x3
    8000586e:	97aa                	add	a5,a5,a0
    80005870:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005874:	fe043503          	ld	a0,-32(s0)
    80005878:	fffff097          	auipc	ra,0xfffff
    8000587c:	260080e7          	jalr	608(ra) # 80004ad8 <fileclose>
  return 0;
    80005880:	4781                	li	a5,0
}
    80005882:	853e                	mv	a0,a5
    80005884:	60e2                	ld	ra,24(sp)
    80005886:	6442                	ld	s0,16(sp)
    80005888:	6105                	addi	sp,sp,32
    8000588a:	8082                	ret

000000008000588c <sys_fstat>:
uint64 sys_fstat(void) {
    8000588c:	1101                	addi	sp,sp,-32
    8000588e:	ec06                	sd	ra,24(sp)
    80005890:	e822                	sd	s0,16(sp)
    80005892:	1000                	addi	s0,sp,32
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005894:	fe840613          	addi	a2,s0,-24
    80005898:	4581                	li	a1,0
    8000589a:	4501                	li	a0,0
    8000589c:	00000097          	auipc	ra,0x0
    800058a0:	c78080e7          	jalr	-904(ra) # 80005514 <argfd>
    return -1;
    800058a4:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800058a6:	02054563          	bltz	a0,800058d0 <sys_fstat+0x44>
    800058aa:	fe040593          	addi	a1,s0,-32
    800058ae:	4505                	li	a0,1
    800058b0:	ffffd097          	auipc	ra,0xffffd
    800058b4:	738080e7          	jalr	1848(ra) # 80002fe8 <argaddr>
    return -1;
    800058b8:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800058ba:	00054b63          	bltz	a0,800058d0 <sys_fstat+0x44>
  return filestat(f, st);
    800058be:	fe043583          	ld	a1,-32(s0)
    800058c2:	fe843503          	ld	a0,-24(s0)
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	2da080e7          	jalr	730(ra) # 80004ba0 <filestat>
    800058ce:	87aa                	mv	a5,a0
}
    800058d0:	853e                	mv	a0,a5
    800058d2:	60e2                	ld	ra,24(sp)
    800058d4:	6442                	ld	s0,16(sp)
    800058d6:	6105                	addi	sp,sp,32
    800058d8:	8082                	ret

00000000800058da <sys_link>:
uint64 sys_link(void) {
    800058da:	7169                	addi	sp,sp,-304
    800058dc:	f606                	sd	ra,296(sp)
    800058de:	f222                	sd	s0,288(sp)
    800058e0:	ee26                	sd	s1,280(sp)
    800058e2:	ea4a                	sd	s2,272(sp)
    800058e4:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058e6:	08000613          	li	a2,128
    800058ea:	ed040593          	addi	a1,s0,-304
    800058ee:	4501                	li	a0,0
    800058f0:	ffffd097          	auipc	ra,0xffffd
    800058f4:	71a080e7          	jalr	1818(ra) # 8000300a <argstr>
    return -1;
    800058f8:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058fa:	10054e63          	bltz	a0,80005a16 <sys_link+0x13c>
    800058fe:	08000613          	li	a2,128
    80005902:	f5040593          	addi	a1,s0,-176
    80005906:	4505                	li	a0,1
    80005908:	ffffd097          	auipc	ra,0xffffd
    8000590c:	702080e7          	jalr	1794(ra) # 8000300a <argstr>
    return -1;
    80005910:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005912:	10054263          	bltz	a0,80005a16 <sys_link+0x13c>
  begin_op();
    80005916:	fffff097          	auipc	ra,0xfffff
    8000591a:	cf6080e7          	jalr	-778(ra) # 8000460c <begin_op>
  if ((ip = namei(old)) == 0) {
    8000591e:	ed040513          	addi	a0,s0,-304
    80005922:	fffff097          	auipc	ra,0xfffff
    80005926:	ace080e7          	jalr	-1330(ra) # 800043f0 <namei>
    8000592a:	84aa                	mv	s1,a0
    8000592c:	c551                	beqz	a0,800059b8 <sys_link+0xde>
  ilock(ip);
    8000592e:	ffffe097          	auipc	ra,0xffffe
    80005932:	30c080e7          	jalr	780(ra) # 80003c3a <ilock>
  if (ip->type == T_DIR) {
    80005936:	04449703          	lh	a4,68(s1)
    8000593a:	4785                	li	a5,1
    8000593c:	08f70463          	beq	a4,a5,800059c4 <sys_link+0xea>
  ip->nlink++;
    80005940:	04a4d783          	lhu	a5,74(s1)
    80005944:	2785                	addiw	a5,a5,1
    80005946:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000594a:	8526                	mv	a0,s1
    8000594c:	ffffe097          	auipc	ra,0xffffe
    80005950:	224080e7          	jalr	548(ra) # 80003b70 <iupdate>
  iunlock(ip);
    80005954:	8526                	mv	a0,s1
    80005956:	ffffe097          	auipc	ra,0xffffe
    8000595a:	3a6080e7          	jalr	934(ra) # 80003cfc <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000595e:	fd040593          	addi	a1,s0,-48
    80005962:	f5040513          	addi	a0,s0,-176
    80005966:	fffff097          	auipc	ra,0xfffff
    8000596a:	aa8080e7          	jalr	-1368(ra) # 8000440e <nameiparent>
    8000596e:	892a                	mv	s2,a0
    80005970:	c935                	beqz	a0,800059e4 <sys_link+0x10a>
  ilock(dp);
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	2c8080e7          	jalr	712(ra) # 80003c3a <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    8000597a:	00092703          	lw	a4,0(s2)
    8000597e:	409c                	lw	a5,0(s1)
    80005980:	04f71d63          	bne	a4,a5,800059da <sys_link+0x100>
    80005984:	40d0                	lw	a2,4(s1)
    80005986:	fd040593          	addi	a1,s0,-48
    8000598a:	854a                	mv	a0,s2
    8000598c:	fffff097          	auipc	ra,0xfffff
    80005990:	9a2080e7          	jalr	-1630(ra) # 8000432e <dirlink>
    80005994:	04054363          	bltz	a0,800059da <sys_link+0x100>
  iunlockput(dp);
    80005998:	854a                	mv	a0,s2
    8000599a:	ffffe097          	auipc	ra,0xffffe
    8000599e:	502080e7          	jalr	1282(ra) # 80003e9c <iunlockput>
  iput(ip);
    800059a2:	8526                	mv	a0,s1
    800059a4:	ffffe097          	auipc	ra,0xffffe
    800059a8:	450080e7          	jalr	1104(ra) # 80003df4 <iput>
  end_op();
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	ce0080e7          	jalr	-800(ra) # 8000468c <end_op>
  return 0;
    800059b4:	4781                	li	a5,0
    800059b6:	a085                	j	80005a16 <sys_link+0x13c>
    end_op();
    800059b8:	fffff097          	auipc	ra,0xfffff
    800059bc:	cd4080e7          	jalr	-812(ra) # 8000468c <end_op>
    return -1;
    800059c0:	57fd                	li	a5,-1
    800059c2:	a891                	j	80005a16 <sys_link+0x13c>
    iunlockput(ip);
    800059c4:	8526                	mv	a0,s1
    800059c6:	ffffe097          	auipc	ra,0xffffe
    800059ca:	4d6080e7          	jalr	1238(ra) # 80003e9c <iunlockput>
    end_op();
    800059ce:	fffff097          	auipc	ra,0xfffff
    800059d2:	cbe080e7          	jalr	-834(ra) # 8000468c <end_op>
    return -1;
    800059d6:	57fd                	li	a5,-1
    800059d8:	a83d                	j	80005a16 <sys_link+0x13c>
    iunlockput(dp);
    800059da:	854a                	mv	a0,s2
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	4c0080e7          	jalr	1216(ra) # 80003e9c <iunlockput>
  ilock(ip);
    800059e4:	8526                	mv	a0,s1
    800059e6:	ffffe097          	auipc	ra,0xffffe
    800059ea:	254080e7          	jalr	596(ra) # 80003c3a <ilock>
  ip->nlink--;
    800059ee:	04a4d783          	lhu	a5,74(s1)
    800059f2:	37fd                	addiw	a5,a5,-1
    800059f4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059f8:	8526                	mv	a0,s1
    800059fa:	ffffe097          	auipc	ra,0xffffe
    800059fe:	176080e7          	jalr	374(ra) # 80003b70 <iupdate>
  iunlockput(ip);
    80005a02:	8526                	mv	a0,s1
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	498080e7          	jalr	1176(ra) # 80003e9c <iunlockput>
  end_op();
    80005a0c:	fffff097          	auipc	ra,0xfffff
    80005a10:	c80080e7          	jalr	-896(ra) # 8000468c <end_op>
  return -1;
    80005a14:	57fd                	li	a5,-1
}
    80005a16:	853e                	mv	a0,a5
    80005a18:	70b2                	ld	ra,296(sp)
    80005a1a:	7412                	ld	s0,288(sp)
    80005a1c:	64f2                	ld	s1,280(sp)
    80005a1e:	6952                	ld	s2,272(sp)
    80005a20:	6155                	addi	sp,sp,304
    80005a22:	8082                	ret

0000000080005a24 <sys_unlink>:
uint64 sys_unlink(void) {
    80005a24:	7151                	addi	sp,sp,-240
    80005a26:	f586                	sd	ra,232(sp)
    80005a28:	f1a2                	sd	s0,224(sp)
    80005a2a:	eda6                	sd	s1,216(sp)
    80005a2c:	e9ca                	sd	s2,208(sp)
    80005a2e:	e5ce                	sd	s3,200(sp)
    80005a30:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80005a32:	08000613          	li	a2,128
    80005a36:	f3040593          	addi	a1,s0,-208
    80005a3a:	4501                	li	a0,0
    80005a3c:	ffffd097          	auipc	ra,0xffffd
    80005a40:	5ce080e7          	jalr	1486(ra) # 8000300a <argstr>
    80005a44:	18054163          	bltz	a0,80005bc6 <sys_unlink+0x1a2>
  begin_op();
    80005a48:	fffff097          	auipc	ra,0xfffff
    80005a4c:	bc4080e7          	jalr	-1084(ra) # 8000460c <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80005a50:	fb040593          	addi	a1,s0,-80
    80005a54:	f3040513          	addi	a0,s0,-208
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	9b6080e7          	jalr	-1610(ra) # 8000440e <nameiparent>
    80005a60:	84aa                	mv	s1,a0
    80005a62:	c979                	beqz	a0,80005b38 <sys_unlink+0x114>
  ilock(dp);
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	1d6080e7          	jalr	470(ra) # 80003c3a <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005a6c:	00003597          	auipc	a1,0x3
    80005a70:	de458593          	addi	a1,a1,-540 # 80008850 <syscalls+0x2c8>
    80005a74:	fb040513          	addi	a0,s0,-80
    80005a78:	ffffe097          	auipc	ra,0xffffe
    80005a7c:	68c080e7          	jalr	1676(ra) # 80004104 <namecmp>
    80005a80:	14050a63          	beqz	a0,80005bd4 <sys_unlink+0x1b0>
    80005a84:	00002597          	auipc	a1,0x2
    80005a88:	7e458593          	addi	a1,a1,2020 # 80008268 <digits+0x200>
    80005a8c:	fb040513          	addi	a0,s0,-80
    80005a90:	ffffe097          	auipc	ra,0xffffe
    80005a94:	674080e7          	jalr	1652(ra) # 80004104 <namecmp>
    80005a98:	12050e63          	beqz	a0,80005bd4 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005a9c:	f2c40613          	addi	a2,s0,-212
    80005aa0:	fb040593          	addi	a1,s0,-80
    80005aa4:	8526                	mv	a0,s1
    80005aa6:	ffffe097          	auipc	ra,0xffffe
    80005aaa:	678080e7          	jalr	1656(ra) # 8000411e <dirlookup>
    80005aae:	892a                	mv	s2,a0
    80005ab0:	12050263          	beqz	a0,80005bd4 <sys_unlink+0x1b0>
  ilock(ip);
    80005ab4:	ffffe097          	auipc	ra,0xffffe
    80005ab8:	186080e7          	jalr	390(ra) # 80003c3a <ilock>
  if (ip->nlink < 1)
    80005abc:	04a91783          	lh	a5,74(s2)
    80005ac0:	08f05263          	blez	a5,80005b44 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005ac4:	04491703          	lh	a4,68(s2)
    80005ac8:	4785                	li	a5,1
    80005aca:	08f70563          	beq	a4,a5,80005b54 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005ace:	4641                	li	a2,16
    80005ad0:	4581                	li	a1,0
    80005ad2:	fc040513          	addi	a0,s0,-64
    80005ad6:	ffffb097          	auipc	ra,0xffffb
    80005ada:	260080e7          	jalr	608(ra) # 80000d36 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ade:	4741                	li	a4,16
    80005ae0:	f2c42683          	lw	a3,-212(s0)
    80005ae4:	fc040613          	addi	a2,s0,-64
    80005ae8:	4581                	li	a1,0
    80005aea:	8526                	mv	a0,s1
    80005aec:	ffffe097          	auipc	ra,0xffffe
    80005af0:	4fa080e7          	jalr	1274(ra) # 80003fe6 <writei>
    80005af4:	47c1                	li	a5,16
    80005af6:	0af51563          	bne	a0,a5,80005ba0 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80005afa:	04491703          	lh	a4,68(s2)
    80005afe:	4785                	li	a5,1
    80005b00:	0af70863          	beq	a4,a5,80005bb0 <sys_unlink+0x18c>
  iunlockput(dp);
    80005b04:	8526                	mv	a0,s1
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	396080e7          	jalr	918(ra) # 80003e9c <iunlockput>
  ip->nlink--;
    80005b0e:	04a95783          	lhu	a5,74(s2)
    80005b12:	37fd                	addiw	a5,a5,-1
    80005b14:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b18:	854a                	mv	a0,s2
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	056080e7          	jalr	86(ra) # 80003b70 <iupdate>
  iunlockput(ip);
    80005b22:	854a                	mv	a0,s2
    80005b24:	ffffe097          	auipc	ra,0xffffe
    80005b28:	378080e7          	jalr	888(ra) # 80003e9c <iunlockput>
  end_op();
    80005b2c:	fffff097          	auipc	ra,0xfffff
    80005b30:	b60080e7          	jalr	-1184(ra) # 8000468c <end_op>
  return 0;
    80005b34:	4501                	li	a0,0
    80005b36:	a84d                	j	80005be8 <sys_unlink+0x1c4>
    end_op();
    80005b38:	fffff097          	auipc	ra,0xfffff
    80005b3c:	b54080e7          	jalr	-1196(ra) # 8000468c <end_op>
    return -1;
    80005b40:	557d                	li	a0,-1
    80005b42:	a05d                	j	80005be8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005b44:	00003517          	auipc	a0,0x3
    80005b48:	d3450513          	addi	a0,a0,-716 # 80008878 <syscalls+0x2f0>
    80005b4c:	ffffb097          	auipc	ra,0xffffb
    80005b50:	a80080e7          	jalr	-1408(ra) # 800005cc <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005b54:	04c92703          	lw	a4,76(s2)
    80005b58:	02000793          	li	a5,32
    80005b5c:	f6e7f9e3          	bgeu	a5,a4,80005ace <sys_unlink+0xaa>
    80005b60:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b64:	4741                	li	a4,16
    80005b66:	86ce                	mv	a3,s3
    80005b68:	f1840613          	addi	a2,s0,-232
    80005b6c:	4581                	li	a1,0
    80005b6e:	854a                	mv	a0,s2
    80005b70:	ffffe097          	auipc	ra,0xffffe
    80005b74:	37e080e7          	jalr	894(ra) # 80003eee <readi>
    80005b78:	47c1                	li	a5,16
    80005b7a:	00f51b63          	bne	a0,a5,80005b90 <sys_unlink+0x16c>
    if (de.inum != 0)
    80005b7e:	f1845783          	lhu	a5,-232(s0)
    80005b82:	e7a1                	bnez	a5,80005bca <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005b84:	29c1                	addiw	s3,s3,16
    80005b86:	04c92783          	lw	a5,76(s2)
    80005b8a:	fcf9ede3          	bltu	s3,a5,80005b64 <sys_unlink+0x140>
    80005b8e:	b781                	j	80005ace <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005b90:	00003517          	auipc	a0,0x3
    80005b94:	d0050513          	addi	a0,a0,-768 # 80008890 <syscalls+0x308>
    80005b98:	ffffb097          	auipc	ra,0xffffb
    80005b9c:	a34080e7          	jalr	-1484(ra) # 800005cc <panic>
    panic("unlink: writei");
    80005ba0:	00003517          	auipc	a0,0x3
    80005ba4:	d0850513          	addi	a0,a0,-760 # 800088a8 <syscalls+0x320>
    80005ba8:	ffffb097          	auipc	ra,0xffffb
    80005bac:	a24080e7          	jalr	-1500(ra) # 800005cc <panic>
    dp->nlink--;
    80005bb0:	04a4d783          	lhu	a5,74(s1)
    80005bb4:	37fd                	addiw	a5,a5,-1
    80005bb6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bba:	8526                	mv	a0,s1
    80005bbc:	ffffe097          	auipc	ra,0xffffe
    80005bc0:	fb4080e7          	jalr	-76(ra) # 80003b70 <iupdate>
    80005bc4:	b781                	j	80005b04 <sys_unlink+0xe0>
    return -1;
    80005bc6:	557d                	li	a0,-1
    80005bc8:	a005                	j	80005be8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005bca:	854a                	mv	a0,s2
    80005bcc:	ffffe097          	auipc	ra,0xffffe
    80005bd0:	2d0080e7          	jalr	720(ra) # 80003e9c <iunlockput>
  iunlockput(dp);
    80005bd4:	8526                	mv	a0,s1
    80005bd6:	ffffe097          	auipc	ra,0xffffe
    80005bda:	2c6080e7          	jalr	710(ra) # 80003e9c <iunlockput>
  end_op();
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	aae080e7          	jalr	-1362(ra) # 8000468c <end_op>
  return -1;
    80005be6:	557d                	li	a0,-1
}
    80005be8:	70ae                	ld	ra,232(sp)
    80005bea:	740e                	ld	s0,224(sp)
    80005bec:	64ee                	ld	s1,216(sp)
    80005bee:	694e                	ld	s2,208(sp)
    80005bf0:	69ae                	ld	s3,200(sp)
    80005bf2:	616d                	addi	sp,sp,240
    80005bf4:	8082                	ret

0000000080005bf6 <sys_open>:

uint64 sys_open(void) {
    80005bf6:	7131                	addi	sp,sp,-192
    80005bf8:	fd06                	sd	ra,184(sp)
    80005bfa:	f922                	sd	s0,176(sp)
    80005bfc:	f526                	sd	s1,168(sp)
    80005bfe:	f14a                	sd	s2,160(sp)
    80005c00:	ed4e                	sd	s3,152(sp)
    80005c02:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005c04:	08000613          	li	a2,128
    80005c08:	f5040593          	addi	a1,s0,-176
    80005c0c:	4501                	li	a0,0
    80005c0e:	ffffd097          	auipc	ra,0xffffd
    80005c12:	3fc080e7          	jalr	1020(ra) # 8000300a <argstr>
    return -1;
    80005c16:	54fd                	li	s1,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005c18:	0c054163          	bltz	a0,80005cda <sys_open+0xe4>
    80005c1c:	f4c40593          	addi	a1,s0,-180
    80005c20:	4505                	li	a0,1
    80005c22:	ffffd097          	auipc	ra,0xffffd
    80005c26:	3a4080e7          	jalr	932(ra) # 80002fc6 <argint>
    80005c2a:	0a054863          	bltz	a0,80005cda <sys_open+0xe4>

  begin_op();
    80005c2e:	fffff097          	auipc	ra,0xfffff
    80005c32:	9de080e7          	jalr	-1570(ra) # 8000460c <begin_op>

  if (omode & O_CREATE) {
    80005c36:	f4c42783          	lw	a5,-180(s0)
    80005c3a:	2007f793          	andi	a5,a5,512
    80005c3e:	cbdd                	beqz	a5,80005cf4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c40:	4681                	li	a3,0
    80005c42:	4601                	li	a2,0
    80005c44:	4589                	li	a1,2
    80005c46:	f5040513          	addi	a0,s0,-176
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	974080e7          	jalr	-1676(ra) # 800055be <create>
    80005c52:	892a                	mv	s2,a0
    if (ip == 0) {
    80005c54:	c959                	beqz	a0,80005cea <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005c56:	04491703          	lh	a4,68(s2)
    80005c5a:	478d                	li	a5,3
    80005c5c:	00f71763          	bne	a4,a5,80005c6a <sys_open+0x74>
    80005c60:	04695703          	lhu	a4,70(s2)
    80005c64:	47a5                	li	a5,9
    80005c66:	0ce7ec63          	bltu	a5,a4,80005d3e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005c6a:	fffff097          	auipc	ra,0xfffff
    80005c6e:	db2080e7          	jalr	-590(ra) # 80004a1c <filealloc>
    80005c72:	89aa                	mv	s3,a0
    80005c74:	10050263          	beqz	a0,80005d78 <sys_open+0x182>
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	904080e7          	jalr	-1788(ra) # 8000557c <fdalloc>
    80005c80:	84aa                	mv	s1,a0
    80005c82:	0e054663          	bltz	a0,80005d6e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005c86:	04491703          	lh	a4,68(s2)
    80005c8a:	478d                	li	a5,3
    80005c8c:	0cf70463          	beq	a4,a5,80005d54 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005c90:	4789                	li	a5,2
    80005c92:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005c96:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005c9a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005c9e:	f4c42783          	lw	a5,-180(s0)
    80005ca2:	0017c713          	xori	a4,a5,1
    80005ca6:	8b05                	andi	a4,a4,1
    80005ca8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005cac:	0037f713          	andi	a4,a5,3
    80005cb0:	00e03733          	snez	a4,a4
    80005cb4:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005cb8:	4007f793          	andi	a5,a5,1024
    80005cbc:	c791                	beqz	a5,80005cc8 <sys_open+0xd2>
    80005cbe:	04491703          	lh	a4,68(s2)
    80005cc2:	4789                	li	a5,2
    80005cc4:	08f70f63          	beq	a4,a5,80005d62 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005cc8:	854a                	mv	a0,s2
    80005cca:	ffffe097          	auipc	ra,0xffffe
    80005cce:	032080e7          	jalr	50(ra) # 80003cfc <iunlock>
  end_op();
    80005cd2:	fffff097          	auipc	ra,0xfffff
    80005cd6:	9ba080e7          	jalr	-1606(ra) # 8000468c <end_op>

  return fd;
}
    80005cda:	8526                	mv	a0,s1
    80005cdc:	70ea                	ld	ra,184(sp)
    80005cde:	744a                	ld	s0,176(sp)
    80005ce0:	74aa                	ld	s1,168(sp)
    80005ce2:	790a                	ld	s2,160(sp)
    80005ce4:	69ea                	ld	s3,152(sp)
    80005ce6:	6129                	addi	sp,sp,192
    80005ce8:	8082                	ret
      end_op();
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	9a2080e7          	jalr	-1630(ra) # 8000468c <end_op>
      return -1;
    80005cf2:	b7e5                	j	80005cda <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80005cf4:	f5040513          	addi	a0,s0,-176
    80005cf8:	ffffe097          	auipc	ra,0xffffe
    80005cfc:	6f8080e7          	jalr	1784(ra) # 800043f0 <namei>
    80005d00:	892a                	mv	s2,a0
    80005d02:	c905                	beqz	a0,80005d32 <sys_open+0x13c>
    ilock(ip);
    80005d04:	ffffe097          	auipc	ra,0xffffe
    80005d08:	f36080e7          	jalr	-202(ra) # 80003c3a <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005d0c:	04491703          	lh	a4,68(s2)
    80005d10:	4785                	li	a5,1
    80005d12:	f4f712e3          	bne	a4,a5,80005c56 <sys_open+0x60>
    80005d16:	f4c42783          	lw	a5,-180(s0)
    80005d1a:	dba1                	beqz	a5,80005c6a <sys_open+0x74>
      iunlockput(ip);
    80005d1c:	854a                	mv	a0,s2
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	17e080e7          	jalr	382(ra) # 80003e9c <iunlockput>
      end_op();
    80005d26:	fffff097          	auipc	ra,0xfffff
    80005d2a:	966080e7          	jalr	-1690(ra) # 8000468c <end_op>
      return -1;
    80005d2e:	54fd                	li	s1,-1
    80005d30:	b76d                	j	80005cda <sys_open+0xe4>
      end_op();
    80005d32:	fffff097          	auipc	ra,0xfffff
    80005d36:	95a080e7          	jalr	-1702(ra) # 8000468c <end_op>
      return -1;
    80005d3a:	54fd                	li	s1,-1
    80005d3c:	bf79                	j	80005cda <sys_open+0xe4>
    iunlockput(ip);
    80005d3e:	854a                	mv	a0,s2
    80005d40:	ffffe097          	auipc	ra,0xffffe
    80005d44:	15c080e7          	jalr	348(ra) # 80003e9c <iunlockput>
    end_op();
    80005d48:	fffff097          	auipc	ra,0xfffff
    80005d4c:	944080e7          	jalr	-1724(ra) # 8000468c <end_op>
    return -1;
    80005d50:	54fd                	li	s1,-1
    80005d52:	b761                	j	80005cda <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005d54:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005d58:	04691783          	lh	a5,70(s2)
    80005d5c:	02f99223          	sh	a5,36(s3)
    80005d60:	bf2d                	j	80005c9a <sys_open+0xa4>
    itrunc(ip);
    80005d62:	854a                	mv	a0,s2
    80005d64:	ffffe097          	auipc	ra,0xffffe
    80005d68:	fe4080e7          	jalr	-28(ra) # 80003d48 <itrunc>
    80005d6c:	bfb1                	j	80005cc8 <sys_open+0xd2>
      fileclose(f);
    80005d6e:	854e                	mv	a0,s3
    80005d70:	fffff097          	auipc	ra,0xfffff
    80005d74:	d68080e7          	jalr	-664(ra) # 80004ad8 <fileclose>
    iunlockput(ip);
    80005d78:	854a                	mv	a0,s2
    80005d7a:	ffffe097          	auipc	ra,0xffffe
    80005d7e:	122080e7          	jalr	290(ra) # 80003e9c <iunlockput>
    end_op();
    80005d82:	fffff097          	auipc	ra,0xfffff
    80005d86:	90a080e7          	jalr	-1782(ra) # 8000468c <end_op>
    return -1;
    80005d8a:	54fd                	li	s1,-1
    80005d8c:	b7b9                	j	80005cda <sys_open+0xe4>

0000000080005d8e <sys_mkdir>:

uint64 sys_mkdir(void) {
    80005d8e:	7175                	addi	sp,sp,-144
    80005d90:	e506                	sd	ra,136(sp)
    80005d92:	e122                	sd	s0,128(sp)
    80005d94:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	876080e7          	jalr	-1930(ra) # 8000460c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005d9e:	08000613          	li	a2,128
    80005da2:	f7040593          	addi	a1,s0,-144
    80005da6:	4501                	li	a0,0
    80005da8:	ffffd097          	auipc	ra,0xffffd
    80005dac:	262080e7          	jalr	610(ra) # 8000300a <argstr>
    80005db0:	02054963          	bltz	a0,80005de2 <sys_mkdir+0x54>
    80005db4:	4681                	li	a3,0
    80005db6:	4601                	li	a2,0
    80005db8:	4585                	li	a1,1
    80005dba:	f7040513          	addi	a0,s0,-144
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	800080e7          	jalr	-2048(ra) # 800055be <create>
    80005dc6:	cd11                	beqz	a0,80005de2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005dc8:	ffffe097          	auipc	ra,0xffffe
    80005dcc:	0d4080e7          	jalr	212(ra) # 80003e9c <iunlockput>
  end_op();
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	8bc080e7          	jalr	-1860(ra) # 8000468c <end_op>
  return 0;
    80005dd8:	4501                	li	a0,0
}
    80005dda:	60aa                	ld	ra,136(sp)
    80005ddc:	640a                	ld	s0,128(sp)
    80005dde:	6149                	addi	sp,sp,144
    80005de0:	8082                	ret
    end_op();
    80005de2:	fffff097          	auipc	ra,0xfffff
    80005de6:	8aa080e7          	jalr	-1878(ra) # 8000468c <end_op>
    return -1;
    80005dea:	557d                	li	a0,-1
    80005dec:	b7fd                	j	80005dda <sys_mkdir+0x4c>

0000000080005dee <sys_mknod>:

uint64 sys_mknod(void) {
    80005dee:	7135                	addi	sp,sp,-160
    80005df0:	ed06                	sd	ra,152(sp)
    80005df2:	e922                	sd	s0,144(sp)
    80005df4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005df6:	fffff097          	auipc	ra,0xfffff
    80005dfa:	816080e7          	jalr	-2026(ra) # 8000460c <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005dfe:	08000613          	li	a2,128
    80005e02:	f7040593          	addi	a1,s0,-144
    80005e06:	4501                	li	a0,0
    80005e08:	ffffd097          	auipc	ra,0xffffd
    80005e0c:	202080e7          	jalr	514(ra) # 8000300a <argstr>
    80005e10:	04054a63          	bltz	a0,80005e64 <sys_mknod+0x76>
    80005e14:	f6c40593          	addi	a1,s0,-148
    80005e18:	4505                	li	a0,1
    80005e1a:	ffffd097          	auipc	ra,0xffffd
    80005e1e:	1ac080e7          	jalr	428(ra) # 80002fc6 <argint>
    80005e22:	04054163          	bltz	a0,80005e64 <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80005e26:	f6840593          	addi	a1,s0,-152
    80005e2a:	4509                	li	a0,2
    80005e2c:	ffffd097          	auipc	ra,0xffffd
    80005e30:	19a080e7          	jalr	410(ra) # 80002fc6 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005e34:	02054863          	bltz	a0,80005e64 <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005e38:	f6841683          	lh	a3,-152(s0)
    80005e3c:	f6c41603          	lh	a2,-148(s0)
    80005e40:	458d                	li	a1,3
    80005e42:	f7040513          	addi	a0,s0,-144
    80005e46:	fffff097          	auipc	ra,0xfffff
    80005e4a:	778080e7          	jalr	1912(ra) # 800055be <create>
      argint(2, &minor) < 0 ||
    80005e4e:	c919                	beqz	a0,80005e64 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e50:	ffffe097          	auipc	ra,0xffffe
    80005e54:	04c080e7          	jalr	76(ra) # 80003e9c <iunlockput>
  end_op();
    80005e58:	fffff097          	auipc	ra,0xfffff
    80005e5c:	834080e7          	jalr	-1996(ra) # 8000468c <end_op>
  return 0;
    80005e60:	4501                	li	a0,0
    80005e62:	a031                	j	80005e6e <sys_mknod+0x80>
    end_op();
    80005e64:	fffff097          	auipc	ra,0xfffff
    80005e68:	828080e7          	jalr	-2008(ra) # 8000468c <end_op>
    return -1;
    80005e6c:	557d                	li	a0,-1
}
    80005e6e:	60ea                	ld	ra,152(sp)
    80005e70:	644a                	ld	s0,144(sp)
    80005e72:	610d                	addi	sp,sp,160
    80005e74:	8082                	ret

0000000080005e76 <sys_chdir>:

uint64 sys_chdir(void) {
    80005e76:	7135                	addi	sp,sp,-160
    80005e78:	ed06                	sd	ra,152(sp)
    80005e7a:	e922                	sd	s0,144(sp)
    80005e7c:	e526                	sd	s1,136(sp)
    80005e7e:	e14a                	sd	s2,128(sp)
    80005e80:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005e82:	ffffc097          	auipc	ra,0xffffc
    80005e86:	dea080e7          	jalr	-534(ra) # 80001c6c <myproc>
    80005e8a:	892a                	mv	s2,a0

  begin_op();
    80005e8c:	ffffe097          	auipc	ra,0xffffe
    80005e90:	780080e7          	jalr	1920(ra) # 8000460c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005e94:	08000613          	li	a2,128
    80005e98:	f6040593          	addi	a1,s0,-160
    80005e9c:	4501                	li	a0,0
    80005e9e:	ffffd097          	auipc	ra,0xffffd
    80005ea2:	16c080e7          	jalr	364(ra) # 8000300a <argstr>
    80005ea6:	04054b63          	bltz	a0,80005efc <sys_chdir+0x86>
    80005eaa:	f6040513          	addi	a0,s0,-160
    80005eae:	ffffe097          	auipc	ra,0xffffe
    80005eb2:	542080e7          	jalr	1346(ra) # 800043f0 <namei>
    80005eb6:	84aa                	mv	s1,a0
    80005eb8:	c131                	beqz	a0,80005efc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005eba:	ffffe097          	auipc	ra,0xffffe
    80005ebe:	d80080e7          	jalr	-640(ra) # 80003c3a <ilock>
  if (ip->type != T_DIR) {
    80005ec2:	04449703          	lh	a4,68(s1)
    80005ec6:	4785                	li	a5,1
    80005ec8:	04f71063          	bne	a4,a5,80005f08 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ecc:	8526                	mv	a0,s1
    80005ece:	ffffe097          	auipc	ra,0xffffe
    80005ed2:	e2e080e7          	jalr	-466(ra) # 80003cfc <iunlock>
  iput(p->cwd);
    80005ed6:	16093503          	ld	a0,352(s2)
    80005eda:	ffffe097          	auipc	ra,0xffffe
    80005ede:	f1a080e7          	jalr	-230(ra) # 80003df4 <iput>
  end_op();
    80005ee2:	ffffe097          	auipc	ra,0xffffe
    80005ee6:	7aa080e7          	jalr	1962(ra) # 8000468c <end_op>
  p->cwd = ip;
    80005eea:	16993023          	sd	s1,352(s2)
  return 0;
    80005eee:	4501                	li	a0,0
}
    80005ef0:	60ea                	ld	ra,152(sp)
    80005ef2:	644a                	ld	s0,144(sp)
    80005ef4:	64aa                	ld	s1,136(sp)
    80005ef6:	690a                	ld	s2,128(sp)
    80005ef8:	610d                	addi	sp,sp,160
    80005efa:	8082                	ret
    end_op();
    80005efc:	ffffe097          	auipc	ra,0xffffe
    80005f00:	790080e7          	jalr	1936(ra) # 8000468c <end_op>
    return -1;
    80005f04:	557d                	li	a0,-1
    80005f06:	b7ed                	j	80005ef0 <sys_chdir+0x7a>
    iunlockput(ip);
    80005f08:	8526                	mv	a0,s1
    80005f0a:	ffffe097          	auipc	ra,0xffffe
    80005f0e:	f92080e7          	jalr	-110(ra) # 80003e9c <iunlockput>
    end_op();
    80005f12:	ffffe097          	auipc	ra,0xffffe
    80005f16:	77a080e7          	jalr	1914(ra) # 8000468c <end_op>
    return -1;
    80005f1a:	557d                	li	a0,-1
    80005f1c:	bfd1                	j	80005ef0 <sys_chdir+0x7a>

0000000080005f1e <sys_exec>:

uint64 sys_exec(void) {
    80005f1e:	7145                	addi	sp,sp,-464
    80005f20:	e786                	sd	ra,456(sp)
    80005f22:	e3a2                	sd	s0,448(sp)
    80005f24:	ff26                	sd	s1,440(sp)
    80005f26:	fb4a                	sd	s2,432(sp)
    80005f28:	f74e                	sd	s3,424(sp)
    80005f2a:	f352                	sd	s4,416(sp)
    80005f2c:	ef56                	sd	s5,408(sp)
    80005f2e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) {
    80005f30:	08000613          	li	a2,128
    80005f34:	f4040593          	addi	a1,s0,-192
    80005f38:	4501                	li	a0,0
    80005f3a:	ffffd097          	auipc	ra,0xffffd
    80005f3e:	0d0080e7          	jalr	208(ra) # 8000300a <argstr>
    return -1;
    80005f42:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) {
    80005f44:	0c054a63          	bltz	a0,80006018 <sys_exec+0xfa>
    80005f48:	e3840593          	addi	a1,s0,-456
    80005f4c:	4505                	li	a0,1
    80005f4e:	ffffd097          	auipc	ra,0xffffd
    80005f52:	09a080e7          	jalr	154(ra) # 80002fe8 <argaddr>
    80005f56:	0c054163          	bltz	a0,80006018 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005f5a:	10000613          	li	a2,256
    80005f5e:	4581                	li	a1,0
    80005f60:	e4040513          	addi	a0,s0,-448
    80005f64:	ffffb097          	auipc	ra,0xffffb
    80005f68:	dd2080e7          	jalr	-558(ra) # 80000d36 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005f6c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005f70:	89a6                	mv	s3,s1
    80005f72:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80005f74:	02000a13          	li	s4,32
    80005f78:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005f7c:	00391793          	slli	a5,s2,0x3
    80005f80:	e3040593          	addi	a1,s0,-464
    80005f84:	e3843503          	ld	a0,-456(s0)
    80005f88:	953e                	add	a0,a0,a5
    80005f8a:	ffffd097          	auipc	ra,0xffffd
    80005f8e:	fa2080e7          	jalr	-94(ra) # 80002f2c <fetchaddr>
    80005f92:	02054a63          	bltz	a0,80005fc6 <sys_exec+0xa8>
      goto bad;
    }
    if (uarg == 0) {
    80005f96:	e3043783          	ld	a5,-464(s0)
    80005f9a:	c3b9                	beqz	a5,80005fe0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005f9c:	ffffb097          	auipc	ra,0xffffb
    80005fa0:	bae080e7          	jalr	-1106(ra) # 80000b4a <kalloc>
    80005fa4:	85aa                	mv	a1,a0
    80005fa6:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005faa:	cd11                	beqz	a0,80005fc6 <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005fac:	6605                	lui	a2,0x1
    80005fae:	e3043503          	ld	a0,-464(s0)
    80005fb2:	ffffd097          	auipc	ra,0xffffd
    80005fb6:	fcc080e7          	jalr	-52(ra) # 80002f7e <fetchstr>
    80005fba:	00054663          	bltz	a0,80005fc6 <sys_exec+0xa8>
    if (i >= NELEM(argv)) {
    80005fbe:	0905                	addi	s2,s2,1
    80005fc0:	09a1                	addi	s3,s3,8
    80005fc2:	fb491be3          	bne	s2,s4,80005f78 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005fc6:	10048913          	addi	s2,s1,256
    80005fca:	6088                	ld	a0,0(s1)
    80005fcc:	c529                	beqz	a0,80006016 <sys_exec+0xf8>
    kfree(argv[i]);
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	a80080e7          	jalr	-1408(ra) # 80000a4e <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005fd6:	04a1                	addi	s1,s1,8
    80005fd8:	ff2499e3          	bne	s1,s2,80005fca <sys_exec+0xac>
  return -1;
    80005fdc:	597d                	li	s2,-1
    80005fde:	a82d                	j	80006018 <sys_exec+0xfa>
      argv[i] = 0;
    80005fe0:	0a8e                	slli	s5,s5,0x3
    80005fe2:	fc040793          	addi	a5,s0,-64
    80005fe6:	9abe                	add	s5,s5,a5
    80005fe8:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    80005fec:	e4040593          	addi	a1,s0,-448
    80005ff0:	f4040513          	addi	a0,s0,-192
    80005ff4:	fffff097          	auipc	ra,0xfffff
    80005ff8:	136080e7          	jalr	310(ra) # 8000512a <exec>
    80005ffc:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ffe:	10048993          	addi	s3,s1,256
    80006002:	6088                	ld	a0,0(s1)
    80006004:	c911                	beqz	a0,80006018 <sys_exec+0xfa>
    kfree(argv[i]);
    80006006:	ffffb097          	auipc	ra,0xffffb
    8000600a:	a48080e7          	jalr	-1464(ra) # 80000a4e <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000600e:	04a1                	addi	s1,s1,8
    80006010:	ff3499e3          	bne	s1,s3,80006002 <sys_exec+0xe4>
    80006014:	a011                	j	80006018 <sys_exec+0xfa>
  return -1;
    80006016:	597d                	li	s2,-1
}
    80006018:	854a                	mv	a0,s2
    8000601a:	60be                	ld	ra,456(sp)
    8000601c:	641e                	ld	s0,448(sp)
    8000601e:	74fa                	ld	s1,440(sp)
    80006020:	795a                	ld	s2,432(sp)
    80006022:	79ba                	ld	s3,424(sp)
    80006024:	7a1a                	ld	s4,416(sp)
    80006026:	6afa                	ld	s5,408(sp)
    80006028:	6179                	addi	sp,sp,464
    8000602a:	8082                	ret

000000008000602c <sys_pipe>:

uint64 sys_pipe(void) {
    8000602c:	7139                	addi	sp,sp,-64
    8000602e:	fc06                	sd	ra,56(sp)
    80006030:	f822                	sd	s0,48(sp)
    80006032:	f426                	sd	s1,40(sp)
    80006034:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006036:	ffffc097          	auipc	ra,0xffffc
    8000603a:	c36080e7          	jalr	-970(ra) # 80001c6c <myproc>
    8000603e:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    80006040:	fd840593          	addi	a1,s0,-40
    80006044:	4501                	li	a0,0
    80006046:	ffffd097          	auipc	ra,0xffffd
    8000604a:	fa2080e7          	jalr	-94(ra) # 80002fe8 <argaddr>
    return -1;
    8000604e:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    80006050:	0e054063          	bltz	a0,80006130 <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    80006054:	fc840593          	addi	a1,s0,-56
    80006058:	fd040513          	addi	a0,s0,-48
    8000605c:	fffff097          	auipc	ra,0xfffff
    80006060:	dac080e7          	jalr	-596(ra) # 80004e08 <pipealloc>
    return -1;
    80006064:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80006066:	0c054563          	bltz	a0,80006130 <sys_pipe+0x104>
  fd0 = -1;
    8000606a:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000606e:	fd043503          	ld	a0,-48(s0)
    80006072:	fffff097          	auipc	ra,0xfffff
    80006076:	50a080e7          	jalr	1290(ra) # 8000557c <fdalloc>
    8000607a:	fca42223          	sw	a0,-60(s0)
    8000607e:	08054c63          	bltz	a0,80006116 <sys_pipe+0xea>
    80006082:	fc843503          	ld	a0,-56(s0)
    80006086:	fffff097          	auipc	ra,0xfffff
    8000608a:	4f6080e7          	jalr	1270(ra) # 8000557c <fdalloc>
    8000608e:	fca42023          	sw	a0,-64(s0)
    80006092:	06054863          	bltz	a0,80006102 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80006096:	4691                	li	a3,4
    80006098:	fc440613          	addi	a2,s0,-60
    8000609c:	fd843583          	ld	a1,-40(s0)
    800060a0:	6ca8                	ld	a0,88(s1)
    800060a2:	ffffb097          	auipc	ra,0xffffb
    800060a6:	7ba080e7          	jalr	1978(ra) # 8000185c <copyout>
    800060aa:	02054063          	bltz	a0,800060ca <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    800060ae:	4691                	li	a3,4
    800060b0:	fc040613          	addi	a2,s0,-64
    800060b4:	fd843583          	ld	a1,-40(s0)
    800060b8:	0591                	addi	a1,a1,4
    800060ba:	6ca8                	ld	a0,88(s1)
    800060bc:	ffffb097          	auipc	ra,0xffffb
    800060c0:	7a0080e7          	jalr	1952(ra) # 8000185c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800060c4:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800060c6:	06055563          	bgez	a0,80006130 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800060ca:	fc442783          	lw	a5,-60(s0)
    800060ce:	07f1                	addi	a5,a5,28
    800060d0:	078e                	slli	a5,a5,0x3
    800060d2:	97a6                	add	a5,a5,s1
    800060d4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800060d8:	fc042503          	lw	a0,-64(s0)
    800060dc:	0571                	addi	a0,a0,28
    800060de:	050e                	slli	a0,a0,0x3
    800060e0:	9526                	add	a0,a0,s1
    800060e2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800060e6:	fd043503          	ld	a0,-48(s0)
    800060ea:	fffff097          	auipc	ra,0xfffff
    800060ee:	9ee080e7          	jalr	-1554(ra) # 80004ad8 <fileclose>
    fileclose(wf);
    800060f2:	fc843503          	ld	a0,-56(s0)
    800060f6:	fffff097          	auipc	ra,0xfffff
    800060fa:	9e2080e7          	jalr	-1566(ra) # 80004ad8 <fileclose>
    return -1;
    800060fe:	57fd                	li	a5,-1
    80006100:	a805                	j	80006130 <sys_pipe+0x104>
    if (fd0 >= 0)
    80006102:	fc442783          	lw	a5,-60(s0)
    80006106:	0007c863          	bltz	a5,80006116 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000610a:	01c78513          	addi	a0,a5,28
    8000610e:	050e                	slli	a0,a0,0x3
    80006110:	9526                	add	a0,a0,s1
    80006112:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006116:	fd043503          	ld	a0,-48(s0)
    8000611a:	fffff097          	auipc	ra,0xfffff
    8000611e:	9be080e7          	jalr	-1602(ra) # 80004ad8 <fileclose>
    fileclose(wf);
    80006122:	fc843503          	ld	a0,-56(s0)
    80006126:	fffff097          	auipc	ra,0xfffff
    8000612a:	9b2080e7          	jalr	-1614(ra) # 80004ad8 <fileclose>
    return -1;
    8000612e:	57fd                	li	a5,-1
}
    80006130:	853e                	mv	a0,a5
    80006132:	70e2                	ld	ra,56(sp)
    80006134:	7442                	ld	s0,48(sp)
    80006136:	74a2                	ld	s1,40(sp)
    80006138:	6121                	addi	sp,sp,64
    8000613a:	8082                	ret
    8000613c:	0000                	unimp
	...

0000000080006140 <kernelvec>:
    80006140:	7111                	addi	sp,sp,-256
    80006142:	e006                	sd	ra,0(sp)
    80006144:	e40a                	sd	sp,8(sp)
    80006146:	e80e                	sd	gp,16(sp)
    80006148:	ec12                	sd	tp,24(sp)
    8000614a:	f016                	sd	t0,32(sp)
    8000614c:	f41a                	sd	t1,40(sp)
    8000614e:	f81e                	sd	t2,48(sp)
    80006150:	fc22                	sd	s0,56(sp)
    80006152:	e0a6                	sd	s1,64(sp)
    80006154:	e4aa                	sd	a0,72(sp)
    80006156:	e8ae                	sd	a1,80(sp)
    80006158:	ecb2                	sd	a2,88(sp)
    8000615a:	f0b6                	sd	a3,96(sp)
    8000615c:	f4ba                	sd	a4,104(sp)
    8000615e:	f8be                	sd	a5,112(sp)
    80006160:	fcc2                	sd	a6,120(sp)
    80006162:	e146                	sd	a7,128(sp)
    80006164:	e54a                	sd	s2,136(sp)
    80006166:	e94e                	sd	s3,144(sp)
    80006168:	ed52                	sd	s4,152(sp)
    8000616a:	f156                	sd	s5,160(sp)
    8000616c:	f55a                	sd	s6,168(sp)
    8000616e:	f95e                	sd	s7,176(sp)
    80006170:	fd62                	sd	s8,184(sp)
    80006172:	e1e6                	sd	s9,192(sp)
    80006174:	e5ea                	sd	s10,200(sp)
    80006176:	e9ee                	sd	s11,208(sp)
    80006178:	edf2                	sd	t3,216(sp)
    8000617a:	f1f6                	sd	t4,224(sp)
    8000617c:	f5fa                	sd	t5,232(sp)
    8000617e:	f9fe                	sd	t6,240(sp)
    80006180:	c79fc0ef          	jal	ra,80002df8 <kerneltrap>
    80006184:	6082                	ld	ra,0(sp)
    80006186:	6122                	ld	sp,8(sp)
    80006188:	61c2                	ld	gp,16(sp)
    8000618a:	7282                	ld	t0,32(sp)
    8000618c:	7322                	ld	t1,40(sp)
    8000618e:	73c2                	ld	t2,48(sp)
    80006190:	7462                	ld	s0,56(sp)
    80006192:	6486                	ld	s1,64(sp)
    80006194:	6526                	ld	a0,72(sp)
    80006196:	65c6                	ld	a1,80(sp)
    80006198:	6666                	ld	a2,88(sp)
    8000619a:	7686                	ld	a3,96(sp)
    8000619c:	7726                	ld	a4,104(sp)
    8000619e:	77c6                	ld	a5,112(sp)
    800061a0:	7866                	ld	a6,120(sp)
    800061a2:	688a                	ld	a7,128(sp)
    800061a4:	692a                	ld	s2,136(sp)
    800061a6:	69ca                	ld	s3,144(sp)
    800061a8:	6a6a                	ld	s4,152(sp)
    800061aa:	7a8a                	ld	s5,160(sp)
    800061ac:	7b2a                	ld	s6,168(sp)
    800061ae:	7bca                	ld	s7,176(sp)
    800061b0:	7c6a                	ld	s8,184(sp)
    800061b2:	6c8e                	ld	s9,192(sp)
    800061b4:	6d2e                	ld	s10,200(sp)
    800061b6:	6dce                	ld	s11,208(sp)
    800061b8:	6e6e                	ld	t3,216(sp)
    800061ba:	7e8e                	ld	t4,224(sp)
    800061bc:	7f2e                	ld	t5,232(sp)
    800061be:	7fce                	ld	t6,240(sp)
    800061c0:	6111                	addi	sp,sp,256
    800061c2:	10200073          	sret
    800061c6:	00000013          	nop
    800061ca:	00000013          	nop
    800061ce:	0001                	nop

00000000800061d0 <timervec>:
    800061d0:	34051573          	csrrw	a0,mscratch,a0
    800061d4:	e10c                	sd	a1,0(a0)
    800061d6:	e510                	sd	a2,8(a0)
    800061d8:	e914                	sd	a3,16(a0)
    800061da:	6d0c                	ld	a1,24(a0)
    800061dc:	7110                	ld	a2,32(a0)
    800061de:	6194                	ld	a3,0(a1)
    800061e0:	96b2                	add	a3,a3,a2
    800061e2:	e194                	sd	a3,0(a1)
    800061e4:	4589                	li	a1,2
    800061e6:	14459073          	csrw	sip,a1
    800061ea:	6914                	ld	a3,16(a0)
    800061ec:	6510                	ld	a2,8(a0)
    800061ee:	610c                	ld	a1,0(a0)
    800061f0:	34051573          	csrrw	a0,mscratch,a0
    800061f4:	30200073          	mret
	...

00000000800061fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800061fa:	1141                	addi	sp,sp,-16
    800061fc:	e422                	sd	s0,8(sp)
    800061fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006200:	0c0007b7          	lui	a5,0xc000
    80006204:	4705                	li	a4,1
    80006206:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006208:	c3d8                	sw	a4,4(a5)
}
    8000620a:	6422                	ld	s0,8(sp)
    8000620c:	0141                	addi	sp,sp,16
    8000620e:	8082                	ret

0000000080006210 <plicinithart>:

void
plicinithart(void)
{
    80006210:	1141                	addi	sp,sp,-16
    80006212:	e406                	sd	ra,8(sp)
    80006214:	e022                	sd	s0,0(sp)
    80006216:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006218:	ffffc097          	auipc	ra,0xffffc
    8000621c:	a28080e7          	jalr	-1496(ra) # 80001c40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006220:	0085171b          	slliw	a4,a0,0x8
    80006224:	0c0027b7          	lui	a5,0xc002
    80006228:	97ba                	add	a5,a5,a4
    8000622a:	40200713          	li	a4,1026
    8000622e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006232:	00d5151b          	slliw	a0,a0,0xd
    80006236:	0c2017b7          	lui	a5,0xc201
    8000623a:	953e                	add	a0,a0,a5
    8000623c:	00052023          	sw	zero,0(a0)
}
    80006240:	60a2                	ld	ra,8(sp)
    80006242:	6402                	ld	s0,0(sp)
    80006244:	0141                	addi	sp,sp,16
    80006246:	8082                	ret

0000000080006248 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006248:	1141                	addi	sp,sp,-16
    8000624a:	e406                	sd	ra,8(sp)
    8000624c:	e022                	sd	s0,0(sp)
    8000624e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006250:	ffffc097          	auipc	ra,0xffffc
    80006254:	9f0080e7          	jalr	-1552(ra) # 80001c40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006258:	00d5179b          	slliw	a5,a0,0xd
    8000625c:	0c201537          	lui	a0,0xc201
    80006260:	953e                	add	a0,a0,a5
  return irq;
}
    80006262:	4148                	lw	a0,4(a0)
    80006264:	60a2                	ld	ra,8(sp)
    80006266:	6402                	ld	s0,0(sp)
    80006268:	0141                	addi	sp,sp,16
    8000626a:	8082                	ret

000000008000626c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000626c:	1101                	addi	sp,sp,-32
    8000626e:	ec06                	sd	ra,24(sp)
    80006270:	e822                	sd	s0,16(sp)
    80006272:	e426                	sd	s1,8(sp)
    80006274:	1000                	addi	s0,sp,32
    80006276:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006278:	ffffc097          	auipc	ra,0xffffc
    8000627c:	9c8080e7          	jalr	-1592(ra) # 80001c40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006280:	00d5151b          	slliw	a0,a0,0xd
    80006284:	0c2017b7          	lui	a5,0xc201
    80006288:	97aa                	add	a5,a5,a0
    8000628a:	c3c4                	sw	s1,4(a5)
}
    8000628c:	60e2                	ld	ra,24(sp)
    8000628e:	6442                	ld	s0,16(sp)
    80006290:	64a2                	ld	s1,8(sp)
    80006292:	6105                	addi	sp,sp,32
    80006294:	8082                	ret

0000000080006296 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006296:	1141                	addi	sp,sp,-16
    80006298:	e406                	sd	ra,8(sp)
    8000629a:	e022                	sd	s0,0(sp)
    8000629c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000629e:	479d                	li	a5,7
    800062a0:	06a7c963          	blt	a5,a0,80006312 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800062a4:	0001d797          	auipc	a5,0x1d
    800062a8:	d5c78793          	addi	a5,a5,-676 # 80023000 <disk>
    800062ac:	00a78733          	add	a4,a5,a0
    800062b0:	6789                	lui	a5,0x2
    800062b2:	97ba                	add	a5,a5,a4
    800062b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800062b8:	e7ad                	bnez	a5,80006322 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800062ba:	00451793          	slli	a5,a0,0x4
    800062be:	0001f717          	auipc	a4,0x1f
    800062c2:	d4270713          	addi	a4,a4,-702 # 80025000 <disk+0x2000>
    800062c6:	6314                	ld	a3,0(a4)
    800062c8:	96be                	add	a3,a3,a5
    800062ca:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800062ce:	6314                	ld	a3,0(a4)
    800062d0:	96be                	add	a3,a3,a5
    800062d2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800062d6:	6314                	ld	a3,0(a4)
    800062d8:	96be                	add	a3,a3,a5
    800062da:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800062de:	6318                	ld	a4,0(a4)
    800062e0:	97ba                	add	a5,a5,a4
    800062e2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800062e6:	0001d797          	auipc	a5,0x1d
    800062ea:	d1a78793          	addi	a5,a5,-742 # 80023000 <disk>
    800062ee:	97aa                	add	a5,a5,a0
    800062f0:	6509                	lui	a0,0x2
    800062f2:	953e                	add	a0,a0,a5
    800062f4:	4785                	li	a5,1
    800062f6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800062fa:	0001f517          	auipc	a0,0x1f
    800062fe:	d1e50513          	addi	a0,a0,-738 # 80025018 <disk+0x2018>
    80006302:	ffffc097          	auipc	ra,0xffffc
    80006306:	3a8080e7          	jalr	936(ra) # 800026aa <wakeup>
}
    8000630a:	60a2                	ld	ra,8(sp)
    8000630c:	6402                	ld	s0,0(sp)
    8000630e:	0141                	addi	sp,sp,16
    80006310:	8082                	ret
    panic("free_desc 1");
    80006312:	00002517          	auipc	a0,0x2
    80006316:	5a650513          	addi	a0,a0,1446 # 800088b8 <syscalls+0x330>
    8000631a:	ffffa097          	auipc	ra,0xffffa
    8000631e:	2b2080e7          	jalr	690(ra) # 800005cc <panic>
    panic("free_desc 2");
    80006322:	00002517          	auipc	a0,0x2
    80006326:	5a650513          	addi	a0,a0,1446 # 800088c8 <syscalls+0x340>
    8000632a:	ffffa097          	auipc	ra,0xffffa
    8000632e:	2a2080e7          	jalr	674(ra) # 800005cc <panic>

0000000080006332 <virtio_disk_init>:
{
    80006332:	1101                	addi	sp,sp,-32
    80006334:	ec06                	sd	ra,24(sp)
    80006336:	e822                	sd	s0,16(sp)
    80006338:	e426                	sd	s1,8(sp)
    8000633a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000633c:	00002597          	auipc	a1,0x2
    80006340:	59c58593          	addi	a1,a1,1436 # 800088d8 <syscalls+0x350>
    80006344:	0001f517          	auipc	a0,0x1f
    80006348:	de450513          	addi	a0,a0,-540 # 80025128 <disk+0x2128>
    8000634c:	ffffb097          	auipc	ra,0xffffb
    80006350:	85e080e7          	jalr	-1954(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006354:	100017b7          	lui	a5,0x10001
    80006358:	4398                	lw	a4,0(a5)
    8000635a:	2701                	sext.w	a4,a4
    8000635c:	747277b7          	lui	a5,0x74727
    80006360:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006364:	0ef71163          	bne	a4,a5,80006446 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006368:	100017b7          	lui	a5,0x10001
    8000636c:	43dc                	lw	a5,4(a5)
    8000636e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006370:	4705                	li	a4,1
    80006372:	0ce79a63          	bne	a5,a4,80006446 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006376:	100017b7          	lui	a5,0x10001
    8000637a:	479c                	lw	a5,8(a5)
    8000637c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000637e:	4709                	li	a4,2
    80006380:	0ce79363          	bne	a5,a4,80006446 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006384:	100017b7          	lui	a5,0x10001
    80006388:	47d8                	lw	a4,12(a5)
    8000638a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000638c:	554d47b7          	lui	a5,0x554d4
    80006390:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006394:	0af71963          	bne	a4,a5,80006446 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006398:	100017b7          	lui	a5,0x10001
    8000639c:	4705                	li	a4,1
    8000639e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063a0:	470d                	li	a4,3
    800063a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063a4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063a6:	c7ffe737          	lui	a4,0xc7ffe
    800063aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    800063ae:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063b0:	2701                	sext.w	a4,a4
    800063b2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063b4:	472d                	li	a4,11
    800063b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063b8:	473d                	li	a4,15
    800063ba:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800063bc:	6705                	lui	a4,0x1
    800063be:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063c4:	5bdc                	lw	a5,52(a5)
    800063c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800063c8:	c7d9                	beqz	a5,80006456 <virtio_disk_init+0x124>
  if(max < NUM)
    800063ca:	471d                	li	a4,7
    800063cc:	08f77d63          	bgeu	a4,a5,80006466 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800063d0:	100014b7          	lui	s1,0x10001
    800063d4:	47a1                	li	a5,8
    800063d6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800063d8:	6609                	lui	a2,0x2
    800063da:	4581                	li	a1,0
    800063dc:	0001d517          	auipc	a0,0x1d
    800063e0:	c2450513          	addi	a0,a0,-988 # 80023000 <disk>
    800063e4:	ffffb097          	auipc	ra,0xffffb
    800063e8:	952080e7          	jalr	-1710(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800063ec:	0001d717          	auipc	a4,0x1d
    800063f0:	c1470713          	addi	a4,a4,-1004 # 80023000 <disk>
    800063f4:	00c75793          	srli	a5,a4,0xc
    800063f8:	2781                	sext.w	a5,a5
    800063fa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800063fc:	0001f797          	auipc	a5,0x1f
    80006400:	c0478793          	addi	a5,a5,-1020 # 80025000 <disk+0x2000>
    80006404:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006406:	0001d717          	auipc	a4,0x1d
    8000640a:	c7a70713          	addi	a4,a4,-902 # 80023080 <disk+0x80>
    8000640e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006410:	0001e717          	auipc	a4,0x1e
    80006414:	bf070713          	addi	a4,a4,-1040 # 80024000 <disk+0x1000>
    80006418:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000641a:	4705                	li	a4,1
    8000641c:	00e78c23          	sb	a4,24(a5)
    80006420:	00e78ca3          	sb	a4,25(a5)
    80006424:	00e78d23          	sb	a4,26(a5)
    80006428:	00e78da3          	sb	a4,27(a5)
    8000642c:	00e78e23          	sb	a4,28(a5)
    80006430:	00e78ea3          	sb	a4,29(a5)
    80006434:	00e78f23          	sb	a4,30(a5)
    80006438:	00e78fa3          	sb	a4,31(a5)
}
    8000643c:	60e2                	ld	ra,24(sp)
    8000643e:	6442                	ld	s0,16(sp)
    80006440:	64a2                	ld	s1,8(sp)
    80006442:	6105                	addi	sp,sp,32
    80006444:	8082                	ret
    panic("could not find virtio disk");
    80006446:	00002517          	auipc	a0,0x2
    8000644a:	4a250513          	addi	a0,a0,1186 # 800088e8 <syscalls+0x360>
    8000644e:	ffffa097          	auipc	ra,0xffffa
    80006452:	17e080e7          	jalr	382(ra) # 800005cc <panic>
    panic("virtio disk has no queue 0");
    80006456:	00002517          	auipc	a0,0x2
    8000645a:	4b250513          	addi	a0,a0,1202 # 80008908 <syscalls+0x380>
    8000645e:	ffffa097          	auipc	ra,0xffffa
    80006462:	16e080e7          	jalr	366(ra) # 800005cc <panic>
    panic("virtio disk max queue too short");
    80006466:	00002517          	auipc	a0,0x2
    8000646a:	4c250513          	addi	a0,a0,1218 # 80008928 <syscalls+0x3a0>
    8000646e:	ffffa097          	auipc	ra,0xffffa
    80006472:	15e080e7          	jalr	350(ra) # 800005cc <panic>

0000000080006476 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006476:	7119                	addi	sp,sp,-128
    80006478:	fc86                	sd	ra,120(sp)
    8000647a:	f8a2                	sd	s0,112(sp)
    8000647c:	f4a6                	sd	s1,104(sp)
    8000647e:	f0ca                	sd	s2,96(sp)
    80006480:	ecce                	sd	s3,88(sp)
    80006482:	e8d2                	sd	s4,80(sp)
    80006484:	e4d6                	sd	s5,72(sp)
    80006486:	e0da                	sd	s6,64(sp)
    80006488:	fc5e                	sd	s7,56(sp)
    8000648a:	f862                	sd	s8,48(sp)
    8000648c:	f466                	sd	s9,40(sp)
    8000648e:	f06a                	sd	s10,32(sp)
    80006490:	ec6e                	sd	s11,24(sp)
    80006492:	0100                	addi	s0,sp,128
    80006494:	8aaa                	mv	s5,a0
    80006496:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006498:	00c52c83          	lw	s9,12(a0)
    8000649c:	001c9c9b          	slliw	s9,s9,0x1
    800064a0:	1c82                	slli	s9,s9,0x20
    800064a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800064a6:	0001f517          	auipc	a0,0x1f
    800064aa:	c8250513          	addi	a0,a0,-894 # 80025128 <disk+0x2128>
    800064ae:	ffffa097          	auipc	ra,0xffffa
    800064b2:	78c080e7          	jalr	1932(ra) # 80000c3a <acquire>
  for(int i = 0; i < 3; i++){
    800064b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800064b8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800064ba:	0001dc17          	auipc	s8,0x1d
    800064be:	b46c0c13          	addi	s8,s8,-1210 # 80023000 <disk>
    800064c2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800064c4:	4b0d                	li	s6,3
    800064c6:	a0ad                	j	80006530 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800064c8:	00fc0733          	add	a4,s8,a5
    800064cc:	975e                	add	a4,a4,s7
    800064ce:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800064d2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800064d4:	0207c563          	bltz	a5,800064fe <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800064d8:	2905                	addiw	s2,s2,1
    800064da:	0611                	addi	a2,a2,4
    800064dc:	19690d63          	beq	s2,s6,80006676 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800064e0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800064e2:	0001f717          	auipc	a4,0x1f
    800064e6:	b3670713          	addi	a4,a4,-1226 # 80025018 <disk+0x2018>
    800064ea:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800064ec:	00074683          	lbu	a3,0(a4)
    800064f0:	fee1                	bnez	a3,800064c8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800064f2:	2785                	addiw	a5,a5,1
    800064f4:	0705                	addi	a4,a4,1
    800064f6:	fe979be3          	bne	a5,s1,800064ec <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800064fa:	57fd                	li	a5,-1
    800064fc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800064fe:	01205d63          	blez	s2,80006518 <virtio_disk_rw+0xa2>
    80006502:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006504:	000a2503          	lw	a0,0(s4)
    80006508:	00000097          	auipc	ra,0x0
    8000650c:	d8e080e7          	jalr	-626(ra) # 80006296 <free_desc>
      for(int j = 0; j < i; j++)
    80006510:	2d85                	addiw	s11,s11,1
    80006512:	0a11                	addi	s4,s4,4
    80006514:	ffb918e3          	bne	s2,s11,80006504 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006518:	0001f597          	auipc	a1,0x1f
    8000651c:	c1058593          	addi	a1,a1,-1008 # 80025128 <disk+0x2128>
    80006520:	0001f517          	auipc	a0,0x1f
    80006524:	af850513          	addi	a0,a0,-1288 # 80025018 <disk+0x2018>
    80006528:	ffffc097          	auipc	ra,0xffffc
    8000652c:	ff6080e7          	jalr	-10(ra) # 8000251e <sleep>
  for(int i = 0; i < 3; i++){
    80006530:	f8040a13          	addi	s4,s0,-128
{
    80006534:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006536:	894e                	mv	s2,s3
    80006538:	b765                	j	800064e0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000653a:	0001f697          	auipc	a3,0x1f
    8000653e:	ac66b683          	ld	a3,-1338(a3) # 80025000 <disk+0x2000>
    80006542:	96ba                	add	a3,a3,a4
    80006544:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006548:	0001d817          	auipc	a6,0x1d
    8000654c:	ab880813          	addi	a6,a6,-1352 # 80023000 <disk>
    80006550:	0001f697          	auipc	a3,0x1f
    80006554:	ab068693          	addi	a3,a3,-1360 # 80025000 <disk+0x2000>
    80006558:	6290                	ld	a2,0(a3)
    8000655a:	963a                	add	a2,a2,a4
    8000655c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006560:	0015e593          	ori	a1,a1,1
    80006564:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006568:	f8842603          	lw	a2,-120(s0)
    8000656c:	628c                	ld	a1,0(a3)
    8000656e:	972e                	add	a4,a4,a1
    80006570:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006574:	20050593          	addi	a1,a0,512
    80006578:	0592                	slli	a1,a1,0x4
    8000657a:	95c2                	add	a1,a1,a6
    8000657c:	577d                	li	a4,-1
    8000657e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006582:	00461713          	slli	a4,a2,0x4
    80006586:	6290                	ld	a2,0(a3)
    80006588:	963a                	add	a2,a2,a4
    8000658a:	03078793          	addi	a5,a5,48
    8000658e:	97c2                	add	a5,a5,a6
    80006590:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006592:	629c                	ld	a5,0(a3)
    80006594:	97ba                	add	a5,a5,a4
    80006596:	4605                	li	a2,1
    80006598:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000659a:	629c                	ld	a5,0(a3)
    8000659c:	97ba                	add	a5,a5,a4
    8000659e:	4809                	li	a6,2
    800065a0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800065a4:	629c                	ld	a5,0(a3)
    800065a6:	973e                	add	a4,a4,a5
    800065a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800065ac:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800065b0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800065b4:	6698                	ld	a4,8(a3)
    800065b6:	00275783          	lhu	a5,2(a4)
    800065ba:	8b9d                	andi	a5,a5,7
    800065bc:	0786                	slli	a5,a5,0x1
    800065be:	97ba                	add	a5,a5,a4
    800065c0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800065c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800065c8:	6698                	ld	a4,8(a3)
    800065ca:	00275783          	lhu	a5,2(a4)
    800065ce:	2785                	addiw	a5,a5,1
    800065d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800065d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800065d8:	100017b7          	lui	a5,0x10001
    800065dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800065e0:	004aa783          	lw	a5,4(s5)
    800065e4:	02c79163          	bne	a5,a2,80006606 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800065e8:	0001f917          	auipc	s2,0x1f
    800065ec:	b4090913          	addi	s2,s2,-1216 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    800065f0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800065f2:	85ca                	mv	a1,s2
    800065f4:	8556                	mv	a0,s5
    800065f6:	ffffc097          	auipc	ra,0xffffc
    800065fa:	f28080e7          	jalr	-216(ra) # 8000251e <sleep>
  while(b->disk == 1) {
    800065fe:	004aa783          	lw	a5,4(s5)
    80006602:	fe9788e3          	beq	a5,s1,800065f2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006606:	f8042903          	lw	s2,-128(s0)
    8000660a:	20090793          	addi	a5,s2,512
    8000660e:	00479713          	slli	a4,a5,0x4
    80006612:	0001d797          	auipc	a5,0x1d
    80006616:	9ee78793          	addi	a5,a5,-1554 # 80023000 <disk>
    8000661a:	97ba                	add	a5,a5,a4
    8000661c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006620:	0001f997          	auipc	s3,0x1f
    80006624:	9e098993          	addi	s3,s3,-1568 # 80025000 <disk+0x2000>
    80006628:	00491713          	slli	a4,s2,0x4
    8000662c:	0009b783          	ld	a5,0(s3)
    80006630:	97ba                	add	a5,a5,a4
    80006632:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006636:	854a                	mv	a0,s2
    80006638:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000663c:	00000097          	auipc	ra,0x0
    80006640:	c5a080e7          	jalr	-934(ra) # 80006296 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006644:	8885                	andi	s1,s1,1
    80006646:	f0ed                	bnez	s1,80006628 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006648:	0001f517          	auipc	a0,0x1f
    8000664c:	ae050513          	addi	a0,a0,-1312 # 80025128 <disk+0x2128>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	69e080e7          	jalr	1694(ra) # 80000cee <release>
}
    80006658:	70e6                	ld	ra,120(sp)
    8000665a:	7446                	ld	s0,112(sp)
    8000665c:	74a6                	ld	s1,104(sp)
    8000665e:	7906                	ld	s2,96(sp)
    80006660:	69e6                	ld	s3,88(sp)
    80006662:	6a46                	ld	s4,80(sp)
    80006664:	6aa6                	ld	s5,72(sp)
    80006666:	6b06                	ld	s6,64(sp)
    80006668:	7be2                	ld	s7,56(sp)
    8000666a:	7c42                	ld	s8,48(sp)
    8000666c:	7ca2                	ld	s9,40(sp)
    8000666e:	7d02                	ld	s10,32(sp)
    80006670:	6de2                	ld	s11,24(sp)
    80006672:	6109                	addi	sp,sp,128
    80006674:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006676:	f8042503          	lw	a0,-128(s0)
    8000667a:	20050793          	addi	a5,a0,512
    8000667e:	0792                	slli	a5,a5,0x4
  if(write)
    80006680:	0001d817          	auipc	a6,0x1d
    80006684:	98080813          	addi	a6,a6,-1664 # 80023000 <disk>
    80006688:	00f80733          	add	a4,a6,a5
    8000668c:	01a036b3          	snez	a3,s10
    80006690:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006694:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006698:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000669c:	7679                	lui	a2,0xffffe
    8000669e:	963e                	add	a2,a2,a5
    800066a0:	0001f697          	auipc	a3,0x1f
    800066a4:	96068693          	addi	a3,a3,-1696 # 80025000 <disk+0x2000>
    800066a8:	6298                	ld	a4,0(a3)
    800066aa:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800066ac:	0a878593          	addi	a1,a5,168
    800066b0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800066b2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800066b4:	6298                	ld	a4,0(a3)
    800066b6:	9732                	add	a4,a4,a2
    800066b8:	45c1                	li	a1,16
    800066ba:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800066bc:	6298                	ld	a4,0(a3)
    800066be:	9732                	add	a4,a4,a2
    800066c0:	4585                	li	a1,1
    800066c2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800066c6:	f8442703          	lw	a4,-124(s0)
    800066ca:	628c                	ld	a1,0(a3)
    800066cc:	962e                	add	a2,a2,a1
    800066ce:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800066d2:	0712                	slli	a4,a4,0x4
    800066d4:	6290                	ld	a2,0(a3)
    800066d6:	963a                	add	a2,a2,a4
    800066d8:	058a8593          	addi	a1,s5,88
    800066dc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800066de:	6294                	ld	a3,0(a3)
    800066e0:	96ba                	add	a3,a3,a4
    800066e2:	40000613          	li	a2,1024
    800066e6:	c690                	sw	a2,8(a3)
  if(write)
    800066e8:	e40d19e3          	bnez	s10,8000653a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800066ec:	0001f697          	auipc	a3,0x1f
    800066f0:	9146b683          	ld	a3,-1772(a3) # 80025000 <disk+0x2000>
    800066f4:	96ba                	add	a3,a3,a4
    800066f6:	4609                	li	a2,2
    800066f8:	00c69623          	sh	a2,12(a3)
    800066fc:	b5b1                	j	80006548 <virtio_disk_rw+0xd2>

00000000800066fe <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800066fe:	1101                	addi	sp,sp,-32
    80006700:	ec06                	sd	ra,24(sp)
    80006702:	e822                	sd	s0,16(sp)
    80006704:	e426                	sd	s1,8(sp)
    80006706:	e04a                	sd	s2,0(sp)
    80006708:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000670a:	0001f517          	auipc	a0,0x1f
    8000670e:	a1e50513          	addi	a0,a0,-1506 # 80025128 <disk+0x2128>
    80006712:	ffffa097          	auipc	ra,0xffffa
    80006716:	528080e7          	jalr	1320(ra) # 80000c3a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000671a:	10001737          	lui	a4,0x10001
    8000671e:	533c                	lw	a5,96(a4)
    80006720:	8b8d                	andi	a5,a5,3
    80006722:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006724:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006728:	0001f797          	auipc	a5,0x1f
    8000672c:	8d878793          	addi	a5,a5,-1832 # 80025000 <disk+0x2000>
    80006730:	6b94                	ld	a3,16(a5)
    80006732:	0207d703          	lhu	a4,32(a5)
    80006736:	0026d783          	lhu	a5,2(a3)
    8000673a:	06f70163          	beq	a4,a5,8000679c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000673e:	0001d917          	auipc	s2,0x1d
    80006742:	8c290913          	addi	s2,s2,-1854 # 80023000 <disk>
    80006746:	0001f497          	auipc	s1,0x1f
    8000674a:	8ba48493          	addi	s1,s1,-1862 # 80025000 <disk+0x2000>
    __sync_synchronize();
    8000674e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006752:	6898                	ld	a4,16(s1)
    80006754:	0204d783          	lhu	a5,32(s1)
    80006758:	8b9d                	andi	a5,a5,7
    8000675a:	078e                	slli	a5,a5,0x3
    8000675c:	97ba                	add	a5,a5,a4
    8000675e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006760:	20078713          	addi	a4,a5,512
    80006764:	0712                	slli	a4,a4,0x4
    80006766:	974a                	add	a4,a4,s2
    80006768:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000676c:	e731                	bnez	a4,800067b8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000676e:	20078793          	addi	a5,a5,512
    80006772:	0792                	slli	a5,a5,0x4
    80006774:	97ca                	add	a5,a5,s2
    80006776:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006778:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000677c:	ffffc097          	auipc	ra,0xffffc
    80006780:	f2e080e7          	jalr	-210(ra) # 800026aa <wakeup>

    disk.used_idx += 1;
    80006784:	0204d783          	lhu	a5,32(s1)
    80006788:	2785                	addiw	a5,a5,1
    8000678a:	17c2                	slli	a5,a5,0x30
    8000678c:	93c1                	srli	a5,a5,0x30
    8000678e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006792:	6898                	ld	a4,16(s1)
    80006794:	00275703          	lhu	a4,2(a4)
    80006798:	faf71be3          	bne	a4,a5,8000674e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000679c:	0001f517          	auipc	a0,0x1f
    800067a0:	98c50513          	addi	a0,a0,-1652 # 80025128 <disk+0x2128>
    800067a4:	ffffa097          	auipc	ra,0xffffa
    800067a8:	54a080e7          	jalr	1354(ra) # 80000cee <release>
}
    800067ac:	60e2                	ld	ra,24(sp)
    800067ae:	6442                	ld	s0,16(sp)
    800067b0:	64a2                	ld	s1,8(sp)
    800067b2:	6902                	ld	s2,0(sp)
    800067b4:	6105                	addi	sp,sp,32
    800067b6:	8082                	ret
      panic("virtio_disk_intr status");
    800067b8:	00002517          	auipc	a0,0x2
    800067bc:	19050513          	addi	a0,a0,400 # 80008948 <syscalls+0x3c0>
    800067c0:	ffffa097          	auipc	ra,0xffffa
    800067c4:	e0c080e7          	jalr	-500(ra) # 800005cc <panic>
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
