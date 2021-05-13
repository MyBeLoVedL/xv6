
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
    80000068:	0fc78793          	addi	a5,a5,252 # 80006160 <timervec>
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
    80000122:	7f8080e7          	jalr	2040(ra) # 80002916 <either_copyin>
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
    800001c6:	35a080e7          	jalr	858(ra) # 8000251c <sleep>
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
    80000202:	6c2080e7          	jalr	1730(ra) # 800028c0 <either_copyout>
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
    800002e2:	68e080e7          	jalr	1678(ra) # 8000296c <procdump>
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
    80000436:	276080e7          	jalr	630(ra) # 800026a8 <wakeup>
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
    80000468:	8b478793          	addi	a5,a5,-1868 # 80021d18 <devsw>
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
    800008fa:	db2080e7          	jalr	-590(ra) # 800026a8 <wakeup>
    
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
    80000986:	b9a080e7          	jalr	-1126(ra) # 8000251c <sleep>
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
    80000f2e:	b82080e7          	jalr	-1150(ra) # 80002aac <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f32:	00005097          	auipc	ra,0x5
    80000f36:	26e080e7          	jalr	622(ra) # 800061a0 <plicinithart>
  }

  scheduler();        
    80000f3a:	00001097          	auipc	ra,0x1
    80000f3e:	3e0080e7          	jalr	992(ra) # 8000231a <scheduler>
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
    80000fa6:	ae2080e7          	jalr	-1310(ra) # 80002a84 <trapinit>
    trapinithart();  // install kernel trap vector
    80000faa:	00002097          	auipc	ra,0x2
    80000fae:	b02080e7          	jalr	-1278(ra) # 80002aac <trapinithart>
    plicinit();      // set up interrupt controller
    80000fb2:	00005097          	auipc	ra,0x5
    80000fb6:	1d8080e7          	jalr	472(ra) # 8000618a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	1e6080e7          	jalr	486(ra) # 800061a0 <plicinithart>
    binit();         // buffer cache
    80000fc2:	00002097          	auipc	ra,0x2
    80000fc6:	378080e7          	jalr	888(ra) # 8000333a <binit>
    iinit();         // inode cache
    80000fca:	00003097          	auipc	ra,0x3
    80000fce:	a08080e7          	jalr	-1528(ra) # 800039d2 <iinit>
    fileinit();      // file table
    80000fd2:	00004097          	auipc	ra,0x4
    80000fd6:	9b2080e7          	jalr	-1614(ra) # 80004984 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	2e8080e7          	jalr	744(ra) # 800062c2 <virtio_disk_init>
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
    80001cc0:	c847a783          	lw	a5,-892(a5) # 80008940 <first.1>
    80001cc4:	eb89                	bnez	a5,80001cd6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001cc6:	00001097          	auipc	ra,0x1
    80001cca:	dfe080e7          	jalr	-514(ra) # 80002ac4 <usertrapret>
}
    80001cce:	60a2                	ld	ra,8(sp)
    80001cd0:	6402                	ld	s0,0(sp)
    80001cd2:	0141                	addi	sp,sp,16
    80001cd4:	8082                	ret
    first = 0;
    80001cd6:	00007797          	auipc	a5,0x7
    80001cda:	c607a523          	sw	zero,-918(a5) # 80008940 <first.1>
    fsinit(ROOTDEV);
    80001cde:	4505                	li	a0,1
    80001ce0:	00002097          	auipc	ra,0x2
    80001ce4:	c72080e7          	jalr	-910(ra) # 80003952 <fsinit>
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
    80001d0c:	c3c78793          	addi	a5,a5,-964 # 80008944 <nextpid>
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
    80002016:	93e58593          	addi	a1,a1,-1730 # 80008950 <initcode>
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
    80002068:	31c080e7          	jalr	796(ra) # 80004380 <namei>
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
  p->if_alarm = 1;
    80002176:	4785                	li	a5,1
    80002178:	16f50423          	sb	a5,360(a0)
  p->tick = tick;
    8000217c:	0004879b          	sext.w	a5,s1
    80002180:	16f52623          	sw	a5,364(a0)
  p->tick_left = tick;
    80002184:	16f52823          	sw	a5,368(a0)
  p->handler = handler;
    80002188:	17253c23          	sd	s2,376(a0)
}
    8000218c:	8526                	mv	a0,s1
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	64a2                	ld	s1,8(sp)
    80002194:	6902                	ld	s2,0(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <fork>:
int fork(void) {
    8000219a:	7139                	addi	sp,sp,-64
    8000219c:	fc06                	sd	ra,56(sp)
    8000219e:	f822                	sd	s0,48(sp)
    800021a0:	f426                	sd	s1,40(sp)
    800021a2:	f04a                	sd	s2,32(sp)
    800021a4:	ec4e                	sd	s3,24(sp)
    800021a6:	e852                	sd	s4,16(sp)
    800021a8:	e456                	sd	s5,8(sp)
    800021aa:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	ac0080e7          	jalr	-1344(ra) # 80001c6c <myproc>
    800021b4:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800021b6:	00000097          	auipc	ra,0x0
    800021ba:	cce080e7          	jalr	-818(ra) # 80001e84 <allocproc>
    800021be:	14050c63          	beqz	a0,80002316 <fork+0x17c>
    800021c2:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800021c4:	050ab603          	ld	a2,80(s5)
    800021c8:	6d2c                	ld	a1,88(a0)
    800021ca:	058ab503          	ld	a0,88(s5)
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	58a080e7          	jalr	1418(ra) # 80001758 <uvmcopy>
    800021d6:	08054063          	bltz	a0,80002256 <fork+0xbc>
  uvmapping(np->pagetable, np->k_pagetable, 0, p->sz);
    800021da:	050ab683          	ld	a3,80(s5)
    800021de:	4601                	li	a2,0
    800021e0:	0609b583          	ld	a1,96(s3)
    800021e4:	0589b503          	ld	a0,88(s3)
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	22c080e7          	jalr	556(ra) # 80001414 <uvmapping>
  if ((pte = walk(np->k_pagetable, 0, 0)) == 0) {
    800021f0:	4601                	li	a2,0
    800021f2:	4581                	li	a1,0
    800021f4:	0609b503          	ld	a0,96(s3)
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	e26080e7          	jalr	-474(ra) # 8000101e <walk>
    80002200:	c53d                	beqz	a0,8000226e <fork+0xd4>
  np->sz = p->sz;
    80002202:	050ab783          	ld	a5,80(s5)
    80002206:	04f9b823          	sd	a5,80(s3)
  np->traced = p->traced;
    8000220a:	040aa783          	lw	a5,64(s5)
    8000220e:	04f9a023          	sw	a5,64(s3)
  *(np->trapframe) = *(p->trapframe);
    80002212:	068ab683          	ld	a3,104(s5)
    80002216:	87b6                	mv	a5,a3
    80002218:	0689b703          	ld	a4,104(s3)
    8000221c:	12068693          	addi	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    80002220:	0007b803          	ld	a6,0(a5)
    80002224:	6788                	ld	a0,8(a5)
    80002226:	6b8c                	ld	a1,16(a5)
    80002228:	6f90                	ld	a2,24(a5)
    8000222a:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    8000222e:	e708                	sd	a0,8(a4)
    80002230:	eb0c                	sd	a1,16(a4)
    80002232:	ef10                	sd	a2,24(a4)
    80002234:	02078793          	addi	a5,a5,32
    80002238:	02070713          	addi	a4,a4,32
    8000223c:	fed792e3          	bne	a5,a3,80002220 <fork+0x86>
  np->trapframe->a0 = 0;
    80002240:	0689b783          	ld	a5,104(s3)
    80002244:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80002248:	0e0a8493          	addi	s1,s5,224
    8000224c:	0e098913          	addi	s2,s3,224
    80002250:	160a8a13          	addi	s4,s5,352
    80002254:	a83d                	j	80002292 <fork+0xf8>
    freeproc(np);
    80002256:	854e                	mv	a0,s3
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	bc6080e7          	jalr	-1082(ra) # 80001e1e <freeproc>
    release(&np->lock);
    80002260:	854e                	mv	a0,s3
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	a8c080e7          	jalr	-1396(ra) # 80000cee <release>
    return -1;
    8000226a:	597d                	li	s2,-1
    8000226c:	a859                	j	80002302 <fork+0x168>
    panic("not valid k table");
    8000226e:	00006517          	auipc	a0,0x6
    80002272:	09a50513          	addi	a0,a0,154 # 80008308 <digits+0x2a0>
    80002276:	ffffe097          	auipc	ra,0xffffe
    8000227a:	356080e7          	jalr	854(ra) # 800005cc <panic>
      np->ofile[i] = filedup(p->ofile[i]);
    8000227e:	00002097          	auipc	ra,0x2
    80002282:	798080e7          	jalr	1944(ra) # 80004a16 <filedup>
    80002286:	00a93023          	sd	a0,0(s2)
  for (i = 0; i < NOFILE; i++)
    8000228a:	04a1                	addi	s1,s1,8
    8000228c:	0921                	addi	s2,s2,8
    8000228e:	01448563          	beq	s1,s4,80002298 <fork+0xfe>
    if (p->ofile[i])
    80002292:	6088                	ld	a0,0(s1)
    80002294:	f56d                	bnez	a0,8000227e <fork+0xe4>
    80002296:	bfd5                	j	8000228a <fork+0xf0>
  np->cwd = idup(p->cwd);
    80002298:	160ab503          	ld	a0,352(s5)
    8000229c:	00002097          	auipc	ra,0x2
    800022a0:	8f0080e7          	jalr	-1808(ra) # 80003b8c <idup>
    800022a4:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800022a8:	4641                	li	a2,16
    800022aa:	180a8593          	addi	a1,s5,384
    800022ae:	18098513          	addi	a0,s3,384
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	bd6080e7          	jalr	-1066(ra) # 80000e88 <safestrcpy>
  pid = np->pid;
    800022ba:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800022be:	854e                	mv	a0,s3
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	a2e080e7          	jalr	-1490(ra) # 80000cee <release>
  acquire(&wait_lock);
    800022c8:	0000f497          	auipc	s1,0xf
    800022cc:	ff048493          	addi	s1,s1,-16 # 800112b8 <wait_lock>
    800022d0:	8526                	mv	a0,s1
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	968080e7          	jalr	-1688(ra) # 80000c3a <acquire>
  np->parent = p;
    800022da:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800022de:	8526                	mv	a0,s1
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	a0e080e7          	jalr	-1522(ra) # 80000cee <release>
  acquire(&np->lock);
    800022e8:	854e                	mv	a0,s3
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	950080e7          	jalr	-1712(ra) # 80000c3a <acquire>
  np->state = RUNNABLE;
    800022f2:	478d                	li	a5,3
    800022f4:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800022f8:	854e                	mv	a0,s3
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	9f4080e7          	jalr	-1548(ra) # 80000cee <release>
}
    80002302:	854a                	mv	a0,s2
    80002304:	70e2                	ld	ra,56(sp)
    80002306:	7442                	ld	s0,48(sp)
    80002308:	74a2                	ld	s1,40(sp)
    8000230a:	7902                	ld	s2,32(sp)
    8000230c:	69e2                	ld	s3,24(sp)
    8000230e:	6a42                	ld	s4,16(sp)
    80002310:	6aa2                	ld	s5,8(sp)
    80002312:	6121                	addi	sp,sp,64
    80002314:	8082                	ret
    return -1;
    80002316:	597d                	li	s2,-1
    80002318:	b7ed                	j	80002302 <fork+0x168>

000000008000231a <scheduler>:
void scheduler(void) {
    8000231a:	715d                	addi	sp,sp,-80
    8000231c:	e486                	sd	ra,72(sp)
    8000231e:	e0a2                	sd	s0,64(sp)
    80002320:	fc26                	sd	s1,56(sp)
    80002322:	f84a                	sd	s2,48(sp)
    80002324:	f44e                	sd	s3,40(sp)
    80002326:	f052                	sd	s4,32(sp)
    80002328:	ec56                	sd	s5,24(sp)
    8000232a:	e85a                	sd	s6,16(sp)
    8000232c:	e45e                	sd	s7,8(sp)
    8000232e:	e062                	sd	s8,0(sp)
    80002330:	0880                	addi	s0,sp,80
    80002332:	8792                	mv	a5,tp
  int id = r_tp();
    80002334:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002336:	00779c13          	slli	s8,a5,0x7
    8000233a:	0000f717          	auipc	a4,0xf
    8000233e:	f6670713          	addi	a4,a4,-154 # 800112a0 <pid_lock>
    80002342:	9762                	add	a4,a4,s8
    80002344:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002348:	0000f717          	auipc	a4,0xf
    8000234c:	f9070713          	addi	a4,a4,-112 # 800112d8 <cpus+0x8>
    80002350:	9c3a                	add	s8,s8,a4
        w_satp(MAKE_SATP(kernel_pagetable));
    80002352:	00007b17          	auipc	s6,0x7
    80002356:	cceb0b13          	addi	s6,s6,-818 # 80009020 <kernel_pagetable>
    8000235a:	5afd                	li	s5,-1
    8000235c:	1afe                	slli	s5,s5,0x3f
        c->proc = p;
    8000235e:	079e                	slli	a5,a5,0x7
    80002360:	0000fb97          	auipc	s7,0xf
    80002364:	f40b8b93          	addi	s7,s7,-192 # 800112a0 <pid_lock>
    80002368:	9bbe                	add	s7,s7,a5
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000236a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000236e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002372:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002376:	4a01                	li	s4,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80002378:	0000f497          	auipc	s1,0xf
    8000237c:	35848493          	addi	s1,s1,856 # 800116d0 <proc>
      if (p->state == RUNNABLE) {
    80002380:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80002382:	00015917          	auipc	s2,0x15
    80002386:	74e90913          	addi	s2,s2,1870 # 80017ad0 <tickslock>
    8000238a:	a085                	j	800023ea <scheduler+0xd0>
        p->state = RUNNING;
    8000238c:	4791                	li	a5,4
    8000238e:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    80002390:	029bb823          	sd	s1,48(s7)
        w_satp(MAKE_SATP(p->k_pagetable));
    80002394:	70bc                	ld	a5,96(s1)
    80002396:	83b1                	srli	a5,a5,0xc
    80002398:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    8000239c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800023a0:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    800023a4:	07048593          	addi	a1,s1,112
    800023a8:	8562                	mv	a0,s8
    800023aa:	00000097          	auipc	ra,0x0
    800023ae:	670080e7          	jalr	1648(ra) # 80002a1a <swtch>
        c->proc = 0;
    800023b2:	020bb823          	sd	zero,48(s7)
      release(&p->lock);
    800023b6:	8526                	mv	a0,s1
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	936080e7          	jalr	-1738(ra) # 80000cee <release>
        found = 1;
    800023c0:	4a05                	li	s4,1
    800023c2:	a005                	j	800023e2 <scheduler+0xc8>
        w_satp(MAKE_SATP(kernel_pagetable));
    800023c4:	000b3783          	ld	a5,0(s6)
    800023c8:	83b1                	srli	a5,a5,0xc
    800023ca:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    800023ce:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800023d2:	12000073          	sfence.vma
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800023d6:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800023da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800023de:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    800023e2:	19048493          	addi	s1,s1,400
    800023e6:	f92482e3          	beq	s1,s2,8000236a <scheduler+0x50>
      acquire(&p->lock);
    800023ea:	8526                	mv	a0,s1
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	84e080e7          	jalr	-1970(ra) # 80000c3a <acquire>
      if (p->state == RUNNABLE) {
    800023f4:	4c9c                	lw	a5,24(s1)
    800023f6:	f9378be3          	beq	a5,s3,8000238c <scheduler+0x72>
      release(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	8f2080e7          	jalr	-1806(ra) # 80000cee <release>
      if (!found) {
    80002404:	fc0a00e3          	beqz	s4,800023c4 <scheduler+0xaa>
    80002408:	bfe9                	j	800023e2 <scheduler+0xc8>

000000008000240a <sched>:
void sched(void) {
    8000240a:	7179                	addi	sp,sp,-48
    8000240c:	f406                	sd	ra,40(sp)
    8000240e:	f022                	sd	s0,32(sp)
    80002410:	ec26                	sd	s1,24(sp)
    80002412:	e84a                	sd	s2,16(sp)
    80002414:	e44e                	sd	s3,8(sp)
    80002416:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002418:	00000097          	auipc	ra,0x0
    8000241c:	854080e7          	jalr	-1964(ra) # 80001c6c <myproc>
    80002420:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002422:	ffffe097          	auipc	ra,0xffffe
    80002426:	79e080e7          	jalr	1950(ra) # 80000bc0 <holding>
    8000242a:	c93d                	beqz	a0,800024a0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    8000242c:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000242e:	2781                	sext.w	a5,a5
    80002430:	079e                	slli	a5,a5,0x7
    80002432:	0000f717          	auipc	a4,0xf
    80002436:	e6e70713          	addi	a4,a4,-402 # 800112a0 <pid_lock>
    8000243a:	97ba                	add	a5,a5,a4
    8000243c:	0a87a703          	lw	a4,168(a5)
    80002440:	4785                	li	a5,1
    80002442:	06f71763          	bne	a4,a5,800024b0 <sched+0xa6>
  if (p->state == RUNNING)
    80002446:	4c98                	lw	a4,24(s1)
    80002448:	4791                	li	a5,4
    8000244a:	06f70b63          	beq	a4,a5,800024c0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000244e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002452:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002454:	efb5                	bnez	a5,800024d0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80002456:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002458:	0000f917          	auipc	s2,0xf
    8000245c:	e4890913          	addi	s2,s2,-440 # 800112a0 <pid_lock>
    80002460:	2781                	sext.w	a5,a5
    80002462:	079e                	slli	a5,a5,0x7
    80002464:	97ca                	add	a5,a5,s2
    80002466:	0ac7a983          	lw	s3,172(a5)
    8000246a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000246c:	2781                	sext.w	a5,a5
    8000246e:	079e                	slli	a5,a5,0x7
    80002470:	0000f597          	auipc	a1,0xf
    80002474:	e6858593          	addi	a1,a1,-408 # 800112d8 <cpus+0x8>
    80002478:	95be                	add	a1,a1,a5
    8000247a:	07048513          	addi	a0,s1,112
    8000247e:	00000097          	auipc	ra,0x0
    80002482:	59c080e7          	jalr	1436(ra) # 80002a1a <swtch>
    80002486:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002488:	2781                	sext.w	a5,a5
    8000248a:	079e                	slli	a5,a5,0x7
    8000248c:	97ca                	add	a5,a5,s2
    8000248e:	0b37a623          	sw	s3,172(a5)
}
    80002492:	70a2                	ld	ra,40(sp)
    80002494:	7402                	ld	s0,32(sp)
    80002496:	64e2                	ld	s1,24(sp)
    80002498:	6942                	ld	s2,16(sp)
    8000249a:	69a2                	ld	s3,8(sp)
    8000249c:	6145                	addi	sp,sp,48
    8000249e:	8082                	ret
    panic("sched p->lock");
    800024a0:	00006517          	auipc	a0,0x6
    800024a4:	e8050513          	addi	a0,a0,-384 # 80008320 <digits+0x2b8>
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	124080e7          	jalr	292(ra) # 800005cc <panic>
    panic("sched locks");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	e8050513          	addi	a0,a0,-384 # 80008330 <digits+0x2c8>
    800024b8:	ffffe097          	auipc	ra,0xffffe
    800024bc:	114080e7          	jalr	276(ra) # 800005cc <panic>
    panic("sched running");
    800024c0:	00006517          	auipc	a0,0x6
    800024c4:	e8050513          	addi	a0,a0,-384 # 80008340 <digits+0x2d8>
    800024c8:	ffffe097          	auipc	ra,0xffffe
    800024cc:	104080e7          	jalr	260(ra) # 800005cc <panic>
    panic("sched interruptible");
    800024d0:	00006517          	auipc	a0,0x6
    800024d4:	e8050513          	addi	a0,a0,-384 # 80008350 <digits+0x2e8>
    800024d8:	ffffe097          	auipc	ra,0xffffe
    800024dc:	0f4080e7          	jalr	244(ra) # 800005cc <panic>

00000000800024e0 <yield>:
void yield(void) {
    800024e0:	1101                	addi	sp,sp,-32
    800024e2:	ec06                	sd	ra,24(sp)
    800024e4:	e822                	sd	s0,16(sp)
    800024e6:	e426                	sd	s1,8(sp)
    800024e8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800024ea:	fffff097          	auipc	ra,0xfffff
    800024ee:	782080e7          	jalr	1922(ra) # 80001c6c <myproc>
    800024f2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800024f4:	ffffe097          	auipc	ra,0xffffe
    800024f8:	746080e7          	jalr	1862(ra) # 80000c3a <acquire>
  p->state = RUNNABLE;
    800024fc:	478d                	li	a5,3
    800024fe:	cc9c                	sw	a5,24(s1)
  sched();
    80002500:	00000097          	auipc	ra,0x0
    80002504:	f0a080e7          	jalr	-246(ra) # 8000240a <sched>
  release(&p->lock);
    80002508:	8526                	mv	a0,s1
    8000250a:	ffffe097          	auipc	ra,0xffffe
    8000250e:	7e4080e7          	jalr	2020(ra) # 80000cee <release>
}
    80002512:	60e2                	ld	ra,24(sp)
    80002514:	6442                	ld	s0,16(sp)
    80002516:	64a2                	ld	s1,8(sp)
    80002518:	6105                	addi	sp,sp,32
    8000251a:	8082                	ret

000000008000251c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    8000251c:	7179                	addi	sp,sp,-48
    8000251e:	f406                	sd	ra,40(sp)
    80002520:	f022                	sd	s0,32(sp)
    80002522:	ec26                	sd	s1,24(sp)
    80002524:	e84a                	sd	s2,16(sp)
    80002526:	e44e                	sd	s3,8(sp)
    80002528:	1800                	addi	s0,sp,48
    8000252a:	89aa                	mv	s3,a0
    8000252c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000252e:	fffff097          	auipc	ra,0xfffff
    80002532:	73e080e7          	jalr	1854(ra) # 80001c6c <myproc>
    80002536:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002538:	ffffe097          	auipc	ra,0xffffe
    8000253c:	702080e7          	jalr	1794(ra) # 80000c3a <acquire>
  release(lk);
    80002540:	854a                	mv	a0,s2
    80002542:	ffffe097          	auipc	ra,0xffffe
    80002546:	7ac080e7          	jalr	1964(ra) # 80000cee <release>

  // Go to sleep.
  p->chan = chan;
    8000254a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000254e:	4789                	li	a5,2
    80002550:	cc9c                	sw	a5,24(s1)

  sched();
    80002552:	00000097          	auipc	ra,0x0
    80002556:	eb8080e7          	jalr	-328(ra) # 8000240a <sched>

  // Tidy up.
  p->chan = 0;
    8000255a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000255e:	8526                	mv	a0,s1
    80002560:	ffffe097          	auipc	ra,0xffffe
    80002564:	78e080e7          	jalr	1934(ra) # 80000cee <release>
  acquire(lk);
    80002568:	854a                	mv	a0,s2
    8000256a:	ffffe097          	auipc	ra,0xffffe
    8000256e:	6d0080e7          	jalr	1744(ra) # 80000c3a <acquire>
}
    80002572:	70a2                	ld	ra,40(sp)
    80002574:	7402                	ld	s0,32(sp)
    80002576:	64e2                	ld	s1,24(sp)
    80002578:	6942                	ld	s2,16(sp)
    8000257a:	69a2                	ld	s3,8(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret

0000000080002580 <wait>:
int wait(uint64 addr) {
    80002580:	715d                	addi	sp,sp,-80
    80002582:	e486                	sd	ra,72(sp)
    80002584:	e0a2                	sd	s0,64(sp)
    80002586:	fc26                	sd	s1,56(sp)
    80002588:	f84a                	sd	s2,48(sp)
    8000258a:	f44e                	sd	s3,40(sp)
    8000258c:	f052                	sd	s4,32(sp)
    8000258e:	ec56                	sd	s5,24(sp)
    80002590:	e85a                	sd	s6,16(sp)
    80002592:	e45e                	sd	s7,8(sp)
    80002594:	e062                	sd	s8,0(sp)
    80002596:	0880                	addi	s0,sp,80
    80002598:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000259a:	fffff097          	auipc	ra,0xfffff
    8000259e:	6d2080e7          	jalr	1746(ra) # 80001c6c <myproc>
    800025a2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800025a4:	0000f517          	auipc	a0,0xf
    800025a8:	d1450513          	addi	a0,a0,-748 # 800112b8 <wait_lock>
    800025ac:	ffffe097          	auipc	ra,0xffffe
    800025b0:	68e080e7          	jalr	1678(ra) # 80000c3a <acquire>
    havekids = 0;
    800025b4:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    800025b6:	4a15                	li	s4,5
        havekids = 1;
    800025b8:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    800025ba:	00015997          	auipc	s3,0x15
    800025be:	51698993          	addi	s3,s3,1302 # 80017ad0 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800025c2:	0000fc17          	auipc	s8,0xf
    800025c6:	cf6c0c13          	addi	s8,s8,-778 # 800112b8 <wait_lock>
    havekids = 0;
    800025ca:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    800025cc:	0000f497          	auipc	s1,0xf
    800025d0:	10448493          	addi	s1,s1,260 # 800116d0 <proc>
    800025d4:	a0bd                	j	80002642 <wait+0xc2>
          pid = np->pid;
    800025d6:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800025da:	000b0e63          	beqz	s6,800025f6 <wait+0x76>
    800025de:	4691                	li	a3,4
    800025e0:	02c48613          	addi	a2,s1,44
    800025e4:	85da                	mv	a1,s6
    800025e6:	05893503          	ld	a0,88(s2)
    800025ea:	fffff097          	auipc	ra,0xfffff
    800025ee:	272080e7          	jalr	626(ra) # 8000185c <copyout>
    800025f2:	02054563          	bltz	a0,8000261c <wait+0x9c>
          freeproc(np);
    800025f6:	8526                	mv	a0,s1
    800025f8:	00000097          	auipc	ra,0x0
    800025fc:	826080e7          	jalr	-2010(ra) # 80001e1e <freeproc>
          release(&np->lock);
    80002600:	8526                	mv	a0,s1
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	6ec080e7          	jalr	1772(ra) # 80000cee <release>
          release(&wait_lock);
    8000260a:	0000f517          	auipc	a0,0xf
    8000260e:	cae50513          	addi	a0,a0,-850 # 800112b8 <wait_lock>
    80002612:	ffffe097          	auipc	ra,0xffffe
    80002616:	6dc080e7          	jalr	1756(ra) # 80000cee <release>
          return pid;
    8000261a:	a09d                	j	80002680 <wait+0x100>
            release(&np->lock);
    8000261c:	8526                	mv	a0,s1
    8000261e:	ffffe097          	auipc	ra,0xffffe
    80002622:	6d0080e7          	jalr	1744(ra) # 80000cee <release>
            release(&wait_lock);
    80002626:	0000f517          	auipc	a0,0xf
    8000262a:	c9250513          	addi	a0,a0,-878 # 800112b8 <wait_lock>
    8000262e:	ffffe097          	auipc	ra,0xffffe
    80002632:	6c0080e7          	jalr	1728(ra) # 80000cee <release>
            return -1;
    80002636:	59fd                	li	s3,-1
    80002638:	a0a1                	j	80002680 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++) {
    8000263a:	19048493          	addi	s1,s1,400
    8000263e:	03348463          	beq	s1,s3,80002666 <wait+0xe6>
      if (np->parent == p) {
    80002642:	7c9c                	ld	a5,56(s1)
    80002644:	ff279be3          	bne	a5,s2,8000263a <wait+0xba>
        acquire(&np->lock);
    80002648:	8526                	mv	a0,s1
    8000264a:	ffffe097          	auipc	ra,0xffffe
    8000264e:	5f0080e7          	jalr	1520(ra) # 80000c3a <acquire>
        if (np->state == ZOMBIE) {
    80002652:	4c9c                	lw	a5,24(s1)
    80002654:	f94781e3          	beq	a5,s4,800025d6 <wait+0x56>
        release(&np->lock);
    80002658:	8526                	mv	a0,s1
    8000265a:	ffffe097          	auipc	ra,0xffffe
    8000265e:	694080e7          	jalr	1684(ra) # 80000cee <release>
        havekids = 1;
    80002662:	8756                	mv	a4,s5
    80002664:	bfd9                	j	8000263a <wait+0xba>
    if (!havekids || p->killed) {
    80002666:	c701                	beqz	a4,8000266e <wait+0xee>
    80002668:	02892783          	lw	a5,40(s2)
    8000266c:	c79d                	beqz	a5,8000269a <wait+0x11a>
      release(&wait_lock);
    8000266e:	0000f517          	auipc	a0,0xf
    80002672:	c4a50513          	addi	a0,a0,-950 # 800112b8 <wait_lock>
    80002676:	ffffe097          	auipc	ra,0xffffe
    8000267a:	678080e7          	jalr	1656(ra) # 80000cee <release>
      return -1;
    8000267e:	59fd                	li	s3,-1
}
    80002680:	854e                	mv	a0,s3
    80002682:	60a6                	ld	ra,72(sp)
    80002684:	6406                	ld	s0,64(sp)
    80002686:	74e2                	ld	s1,56(sp)
    80002688:	7942                	ld	s2,48(sp)
    8000268a:	79a2                	ld	s3,40(sp)
    8000268c:	7a02                	ld	s4,32(sp)
    8000268e:	6ae2                	ld	s5,24(sp)
    80002690:	6b42                	ld	s6,16(sp)
    80002692:	6ba2                	ld	s7,8(sp)
    80002694:	6c02                	ld	s8,0(sp)
    80002696:	6161                	addi	sp,sp,80
    80002698:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000269a:	85e2                	mv	a1,s8
    8000269c:	854a                	mv	a0,s2
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	e7e080e7          	jalr	-386(ra) # 8000251c <sleep>
    havekids = 0;
    800026a6:	b715                	j	800025ca <wait+0x4a>

00000000800026a8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    800026a8:	7139                	addi	sp,sp,-64
    800026aa:	fc06                	sd	ra,56(sp)
    800026ac:	f822                	sd	s0,48(sp)
    800026ae:	f426                	sd	s1,40(sp)
    800026b0:	f04a                	sd	s2,32(sp)
    800026b2:	ec4e                	sd	s3,24(sp)
    800026b4:	e852                	sd	s4,16(sp)
    800026b6:	e456                	sd	s5,8(sp)
    800026b8:	0080                	addi	s0,sp,64
    800026ba:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800026bc:	0000f497          	auipc	s1,0xf
    800026c0:	01448493          	addi	s1,s1,20 # 800116d0 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    800026c4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800026c6:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800026c8:	00015917          	auipc	s2,0x15
    800026cc:	40890913          	addi	s2,s2,1032 # 80017ad0 <tickslock>
    800026d0:	a811                	j	800026e4 <wakeup+0x3c>
      }
      release(&p->lock);
    800026d2:	8526                	mv	a0,s1
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	61a080e7          	jalr	1562(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800026dc:	19048493          	addi	s1,s1,400
    800026e0:	03248663          	beq	s1,s2,8000270c <wakeup+0x64>
    if (p != myproc()) {
    800026e4:	fffff097          	auipc	ra,0xfffff
    800026e8:	588080e7          	jalr	1416(ra) # 80001c6c <myproc>
    800026ec:	fea488e3          	beq	s1,a0,800026dc <wakeup+0x34>
      acquire(&p->lock);
    800026f0:	8526                	mv	a0,s1
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	548080e7          	jalr	1352(ra) # 80000c3a <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800026fa:	4c9c                	lw	a5,24(s1)
    800026fc:	fd379be3          	bne	a5,s3,800026d2 <wakeup+0x2a>
    80002700:	709c                	ld	a5,32(s1)
    80002702:	fd4798e3          	bne	a5,s4,800026d2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002706:	0154ac23          	sw	s5,24(s1)
    8000270a:	b7e1                	j	800026d2 <wakeup+0x2a>
    }
  }
}
    8000270c:	70e2                	ld	ra,56(sp)
    8000270e:	7442                	ld	s0,48(sp)
    80002710:	74a2                	ld	s1,40(sp)
    80002712:	7902                	ld	s2,32(sp)
    80002714:	69e2                	ld	s3,24(sp)
    80002716:	6a42                	ld	s4,16(sp)
    80002718:	6aa2                	ld	s5,8(sp)
    8000271a:	6121                	addi	sp,sp,64
    8000271c:	8082                	ret

000000008000271e <reparent>:
void reparent(struct proc *p) {
    8000271e:	7179                	addi	sp,sp,-48
    80002720:	f406                	sd	ra,40(sp)
    80002722:	f022                	sd	s0,32(sp)
    80002724:	ec26                	sd	s1,24(sp)
    80002726:	e84a                	sd	s2,16(sp)
    80002728:	e44e                	sd	s3,8(sp)
    8000272a:	e052                	sd	s4,0(sp)
    8000272c:	1800                	addi	s0,sp,48
    8000272e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002730:	0000f497          	auipc	s1,0xf
    80002734:	fa048493          	addi	s1,s1,-96 # 800116d0 <proc>
      pp->parent = initproc;
    80002738:	00007a17          	auipc	s4,0x7
    8000273c:	8f0a0a13          	addi	s4,s4,-1808 # 80009028 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002740:	00015997          	auipc	s3,0x15
    80002744:	39098993          	addi	s3,s3,912 # 80017ad0 <tickslock>
    80002748:	a029                	j	80002752 <reparent+0x34>
    8000274a:	19048493          	addi	s1,s1,400
    8000274e:	01348d63          	beq	s1,s3,80002768 <reparent+0x4a>
    if (pp->parent == p) {
    80002752:	7c9c                	ld	a5,56(s1)
    80002754:	ff279be3          	bne	a5,s2,8000274a <reparent+0x2c>
      pp->parent = initproc;
    80002758:	000a3503          	ld	a0,0(s4)
    8000275c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000275e:	00000097          	auipc	ra,0x0
    80002762:	f4a080e7          	jalr	-182(ra) # 800026a8 <wakeup>
    80002766:	b7d5                	j	8000274a <reparent+0x2c>
}
    80002768:	70a2                	ld	ra,40(sp)
    8000276a:	7402                	ld	s0,32(sp)
    8000276c:	64e2                	ld	s1,24(sp)
    8000276e:	6942                	ld	s2,16(sp)
    80002770:	69a2                	ld	s3,8(sp)
    80002772:	6a02                	ld	s4,0(sp)
    80002774:	6145                	addi	sp,sp,48
    80002776:	8082                	ret

0000000080002778 <exit>:
void exit(int status) {
    80002778:	7179                	addi	sp,sp,-48
    8000277a:	f406                	sd	ra,40(sp)
    8000277c:	f022                	sd	s0,32(sp)
    8000277e:	ec26                	sd	s1,24(sp)
    80002780:	e84a                	sd	s2,16(sp)
    80002782:	e44e                	sd	s3,8(sp)
    80002784:	e052                	sd	s4,0(sp)
    80002786:	1800                	addi	s0,sp,48
    80002788:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000278a:	fffff097          	auipc	ra,0xfffff
    8000278e:	4e2080e7          	jalr	1250(ra) # 80001c6c <myproc>
    80002792:	89aa                	mv	s3,a0
  if (p == initproc)
    80002794:	00007797          	auipc	a5,0x7
    80002798:	8947b783          	ld	a5,-1900(a5) # 80009028 <initproc>
    8000279c:	0e050493          	addi	s1,a0,224
    800027a0:	16050913          	addi	s2,a0,352
    800027a4:	02a79363          	bne	a5,a0,800027ca <exit+0x52>
    panic("init exiting");
    800027a8:	00006517          	auipc	a0,0x6
    800027ac:	bc050513          	addi	a0,a0,-1088 # 80008368 <digits+0x300>
    800027b0:	ffffe097          	auipc	ra,0xffffe
    800027b4:	e1c080e7          	jalr	-484(ra) # 800005cc <panic>
      fileclose(f);
    800027b8:	00002097          	auipc	ra,0x2
    800027bc:	2b0080e7          	jalr	688(ra) # 80004a68 <fileclose>
      p->ofile[fd] = 0;
    800027c0:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800027c4:	04a1                	addi	s1,s1,8
    800027c6:	01248563          	beq	s1,s2,800027d0 <exit+0x58>
    if (p->ofile[fd]) {
    800027ca:	6088                	ld	a0,0(s1)
    800027cc:	f575                	bnez	a0,800027b8 <exit+0x40>
    800027ce:	bfdd                	j	800027c4 <exit+0x4c>
  begin_op();
    800027d0:	00002097          	auipc	ra,0x2
    800027d4:	dcc080e7          	jalr	-564(ra) # 8000459c <begin_op>
  iput(p->cwd);
    800027d8:	1609b503          	ld	a0,352(s3)
    800027dc:	00001097          	auipc	ra,0x1
    800027e0:	5a8080e7          	jalr	1448(ra) # 80003d84 <iput>
  end_op();
    800027e4:	00002097          	auipc	ra,0x2
    800027e8:	e38080e7          	jalr	-456(ra) # 8000461c <end_op>
  p->cwd = 0;
    800027ec:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    800027f0:	0000f497          	auipc	s1,0xf
    800027f4:	ac848493          	addi	s1,s1,-1336 # 800112b8 <wait_lock>
    800027f8:	8526                	mv	a0,s1
    800027fa:	ffffe097          	auipc	ra,0xffffe
    800027fe:	440080e7          	jalr	1088(ra) # 80000c3a <acquire>
  reparent(p);
    80002802:	854e                	mv	a0,s3
    80002804:	00000097          	auipc	ra,0x0
    80002808:	f1a080e7          	jalr	-230(ra) # 8000271e <reparent>
  wakeup(p->parent);
    8000280c:	0389b503          	ld	a0,56(s3)
    80002810:	00000097          	auipc	ra,0x0
    80002814:	e98080e7          	jalr	-360(ra) # 800026a8 <wakeup>
  acquire(&p->lock);
    80002818:	854e                	mv	a0,s3
    8000281a:	ffffe097          	auipc	ra,0xffffe
    8000281e:	420080e7          	jalr	1056(ra) # 80000c3a <acquire>
  p->xstate = status;
    80002822:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002826:	4795                	li	a5,5
    80002828:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000282c:	8526                	mv	a0,s1
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	4c0080e7          	jalr	1216(ra) # 80000cee <release>
  sched();
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	bd4080e7          	jalr	-1068(ra) # 8000240a <sched>
  panic("zombie exit");
    8000283e:	00006517          	auipc	a0,0x6
    80002842:	b3a50513          	addi	a0,a0,-1222 # 80008378 <digits+0x310>
    80002846:	ffffe097          	auipc	ra,0xffffe
    8000284a:	d86080e7          	jalr	-634(ra) # 800005cc <panic>

000000008000284e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    8000284e:	7179                	addi	sp,sp,-48
    80002850:	f406                	sd	ra,40(sp)
    80002852:	f022                	sd	s0,32(sp)
    80002854:	ec26                	sd	s1,24(sp)
    80002856:	e84a                	sd	s2,16(sp)
    80002858:	e44e                	sd	s3,8(sp)
    8000285a:	1800                	addi	s0,sp,48
    8000285c:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000285e:	0000f497          	auipc	s1,0xf
    80002862:	e7248493          	addi	s1,s1,-398 # 800116d0 <proc>
    80002866:	00015997          	auipc	s3,0x15
    8000286a:	26a98993          	addi	s3,s3,618 # 80017ad0 <tickslock>
    acquire(&p->lock);
    8000286e:	8526                	mv	a0,s1
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	3ca080e7          	jalr	970(ra) # 80000c3a <acquire>
    if (p->pid == pid) {
    80002878:	589c                	lw	a5,48(s1)
    8000287a:	01278d63          	beq	a5,s2,80002894 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000287e:	8526                	mv	a0,s1
    80002880:	ffffe097          	auipc	ra,0xffffe
    80002884:	46e080e7          	jalr	1134(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002888:	19048493          	addi	s1,s1,400
    8000288c:	ff3491e3          	bne	s1,s3,8000286e <kill+0x20>
  }
  return -1;
    80002890:	557d                	li	a0,-1
    80002892:	a829                	j	800028ac <kill+0x5e>
      p->killed = 1;
    80002894:	4785                	li	a5,1
    80002896:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002898:	4c98                	lw	a4,24(s1)
    8000289a:	4789                	li	a5,2
    8000289c:	00f70f63          	beq	a4,a5,800028ba <kill+0x6c>
      release(&p->lock);
    800028a0:	8526                	mv	a0,s1
    800028a2:	ffffe097          	auipc	ra,0xffffe
    800028a6:	44c080e7          	jalr	1100(ra) # 80000cee <release>
      return 0;
    800028aa:	4501                	li	a0,0
}
    800028ac:	70a2                	ld	ra,40(sp)
    800028ae:	7402                	ld	s0,32(sp)
    800028b0:	64e2                	ld	s1,24(sp)
    800028b2:	6942                	ld	s2,16(sp)
    800028b4:	69a2                	ld	s3,8(sp)
    800028b6:	6145                	addi	sp,sp,48
    800028b8:	8082                	ret
        p->state = RUNNABLE;
    800028ba:	478d                	li	a5,3
    800028bc:	cc9c                	sw	a5,24(s1)
    800028be:	b7cd                	j	800028a0 <kill+0x52>

00000000800028c0 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800028c0:	7179                	addi	sp,sp,-48
    800028c2:	f406                	sd	ra,40(sp)
    800028c4:	f022                	sd	s0,32(sp)
    800028c6:	ec26                	sd	s1,24(sp)
    800028c8:	e84a                	sd	s2,16(sp)
    800028ca:	e44e                	sd	s3,8(sp)
    800028cc:	e052                	sd	s4,0(sp)
    800028ce:	1800                	addi	s0,sp,48
    800028d0:	84aa                	mv	s1,a0
    800028d2:	892e                	mv	s2,a1
    800028d4:	89b2                	mv	s3,a2
    800028d6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028d8:	fffff097          	auipc	ra,0xfffff
    800028dc:	394080e7          	jalr	916(ra) # 80001c6c <myproc>
  if (user_dst) {
    800028e0:	c08d                	beqz	s1,80002902 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800028e2:	86d2                	mv	a3,s4
    800028e4:	864e                	mv	a2,s3
    800028e6:	85ca                	mv	a1,s2
    800028e8:	6d28                	ld	a0,88(a0)
    800028ea:	fffff097          	auipc	ra,0xfffff
    800028ee:	f72080e7          	jalr	-142(ra) # 8000185c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028f2:	70a2                	ld	ra,40(sp)
    800028f4:	7402                	ld	s0,32(sp)
    800028f6:	64e2                	ld	s1,24(sp)
    800028f8:	6942                	ld	s2,16(sp)
    800028fa:	69a2                	ld	s3,8(sp)
    800028fc:	6a02                	ld	s4,0(sp)
    800028fe:	6145                	addi	sp,sp,48
    80002900:	8082                	ret
    memmove((char *)dst, src, len);
    80002902:	000a061b          	sext.w	a2,s4
    80002906:	85ce                	mv	a1,s3
    80002908:	854a                	mv	a0,s2
    8000290a:	ffffe097          	auipc	ra,0xffffe
    8000290e:	488080e7          	jalr	1160(ra) # 80000d92 <memmove>
    return 0;
    80002912:	8526                	mv	a0,s1
    80002914:	bff9                	j	800028f2 <either_copyout+0x32>

0000000080002916 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80002916:	7179                	addi	sp,sp,-48
    80002918:	f406                	sd	ra,40(sp)
    8000291a:	f022                	sd	s0,32(sp)
    8000291c:	ec26                	sd	s1,24(sp)
    8000291e:	e84a                	sd	s2,16(sp)
    80002920:	e44e                	sd	s3,8(sp)
    80002922:	e052                	sd	s4,0(sp)
    80002924:	1800                	addi	s0,sp,48
    80002926:	892a                	mv	s2,a0
    80002928:	84ae                	mv	s1,a1
    8000292a:	89b2                	mv	s3,a2
    8000292c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000292e:	fffff097          	auipc	ra,0xfffff
    80002932:	33e080e7          	jalr	830(ra) # 80001c6c <myproc>
  if (user_src) {
    80002936:	c08d                	beqz	s1,80002958 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002938:	86d2                	mv	a3,s4
    8000293a:	864e                	mv	a2,s3
    8000293c:	85ca                	mv	a1,s2
    8000293e:	6d28                	ld	a0,88(a0)
    80002940:	fffff097          	auipc	ra,0xfffff
    80002944:	022080e7          	jalr	34(ra) # 80001962 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002948:	70a2                	ld	ra,40(sp)
    8000294a:	7402                	ld	s0,32(sp)
    8000294c:	64e2                	ld	s1,24(sp)
    8000294e:	6942                	ld	s2,16(sp)
    80002950:	69a2                	ld	s3,8(sp)
    80002952:	6a02                	ld	s4,0(sp)
    80002954:	6145                	addi	sp,sp,48
    80002956:	8082                	ret
    memmove(dst, (char *)src, len);
    80002958:	000a061b          	sext.w	a2,s4
    8000295c:	85ce                	mv	a1,s3
    8000295e:	854a                	mv	a0,s2
    80002960:	ffffe097          	auipc	ra,0xffffe
    80002964:	432080e7          	jalr	1074(ra) # 80000d92 <memmove>
    return 0;
    80002968:	8526                	mv	a0,s1
    8000296a:	bff9                	j	80002948 <either_copyin+0x32>

000000008000296c <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    8000296c:	715d                	addi	sp,sp,-80
    8000296e:	e486                	sd	ra,72(sp)
    80002970:	e0a2                	sd	s0,64(sp)
    80002972:	fc26                	sd	s1,56(sp)
    80002974:	f84a                	sd	s2,48(sp)
    80002976:	f44e                	sd	s3,40(sp)
    80002978:	f052                	sd	s4,32(sp)
    8000297a:	ec56                	sd	s5,24(sp)
    8000297c:	e85a                	sd	s6,16(sp)
    8000297e:	e45e                	sd	s7,8(sp)
    80002980:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002982:	00005517          	auipc	a0,0x5
    80002986:	76e50513          	addi	a0,a0,1902 # 800080f0 <digits+0x88>
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	c94080e7          	jalr	-876(ra) # 8000061e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002992:	0000f497          	auipc	s1,0xf
    80002996:	ebe48493          	addi	s1,s1,-322 # 80011850 <proc+0x180>
    8000299a:	00015917          	auipc	s2,0x15
    8000299e:	2b690913          	addi	s2,s2,694 # 80017c50 <bcache+0x168>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029a2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800029a4:	00006997          	auipc	s3,0x6
    800029a8:	9e498993          	addi	s3,s3,-1564 # 80008388 <digits+0x320>
    printf("%d %s %s", p->pid, state, p->name);
    800029ac:	00006a97          	auipc	s5,0x6
    800029b0:	9e4a8a93          	addi	s5,s5,-1564 # 80008390 <digits+0x328>
    printf("\n");
    800029b4:	00005a17          	auipc	s4,0x5
    800029b8:	73ca0a13          	addi	s4,s4,1852 # 800080f0 <digits+0x88>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029bc:	00006b97          	auipc	s7,0x6
    800029c0:	a0cb8b93          	addi	s7,s7,-1524 # 800083c8 <states.0>
    800029c4:	a00d                	j	800029e6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800029c6:	eb06a583          	lw	a1,-336(a3)
    800029ca:	8556                	mv	a0,s5
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	c52080e7          	jalr	-942(ra) # 8000061e <printf>
    printf("\n");
    800029d4:	8552                	mv	a0,s4
    800029d6:	ffffe097          	auipc	ra,0xffffe
    800029da:	c48080e7          	jalr	-952(ra) # 8000061e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029de:	19048493          	addi	s1,s1,400
    800029e2:	03248163          	beq	s1,s2,80002a04 <procdump+0x98>
    if (p->state == UNUSED)
    800029e6:	86a6                	mv	a3,s1
    800029e8:	e984a783          	lw	a5,-360(s1)
    800029ec:	dbed                	beqz	a5,800029de <procdump+0x72>
      state = "???";
    800029ee:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029f0:	fcfb6be3          	bltu	s6,a5,800029c6 <procdump+0x5a>
    800029f4:	1782                	slli	a5,a5,0x20
    800029f6:	9381                	srli	a5,a5,0x20
    800029f8:	078e                	slli	a5,a5,0x3
    800029fa:	97de                	add	a5,a5,s7
    800029fc:	6390                	ld	a2,0(a5)
    800029fe:	f661                	bnez	a2,800029c6 <procdump+0x5a>
      state = "???";
    80002a00:	864e                	mv	a2,s3
    80002a02:	b7d1                	j	800029c6 <procdump+0x5a>
  }
}
    80002a04:	60a6                	ld	ra,72(sp)
    80002a06:	6406                	ld	s0,64(sp)
    80002a08:	74e2                	ld	s1,56(sp)
    80002a0a:	7942                	ld	s2,48(sp)
    80002a0c:	79a2                	ld	s3,40(sp)
    80002a0e:	7a02                	ld	s4,32(sp)
    80002a10:	6ae2                	ld	s5,24(sp)
    80002a12:	6b42                	ld	s6,16(sp)
    80002a14:	6ba2                	ld	s7,8(sp)
    80002a16:	6161                	addi	sp,sp,80
    80002a18:	8082                	ret

0000000080002a1a <swtch>:
    80002a1a:	00153023          	sd	ra,0(a0)
    80002a1e:	00253423          	sd	sp,8(a0)
    80002a22:	e900                	sd	s0,16(a0)
    80002a24:	ed04                	sd	s1,24(a0)
    80002a26:	03253023          	sd	s2,32(a0)
    80002a2a:	03353423          	sd	s3,40(a0)
    80002a2e:	03453823          	sd	s4,48(a0)
    80002a32:	03553c23          	sd	s5,56(a0)
    80002a36:	05653023          	sd	s6,64(a0)
    80002a3a:	05753423          	sd	s7,72(a0)
    80002a3e:	05853823          	sd	s8,80(a0)
    80002a42:	05953c23          	sd	s9,88(a0)
    80002a46:	07a53023          	sd	s10,96(a0)
    80002a4a:	07b53423          	sd	s11,104(a0)
    80002a4e:	0005b083          	ld	ra,0(a1)
    80002a52:	0085b103          	ld	sp,8(a1)
    80002a56:	6980                	ld	s0,16(a1)
    80002a58:	6d84                	ld	s1,24(a1)
    80002a5a:	0205b903          	ld	s2,32(a1)
    80002a5e:	0285b983          	ld	s3,40(a1)
    80002a62:	0305ba03          	ld	s4,48(a1)
    80002a66:	0385ba83          	ld	s5,56(a1)
    80002a6a:	0405bb03          	ld	s6,64(a1)
    80002a6e:	0485bb83          	ld	s7,72(a1)
    80002a72:	0505bc03          	ld	s8,80(a1)
    80002a76:	0585bc83          	ld	s9,88(a1)
    80002a7a:	0605bd03          	ld	s10,96(a1)
    80002a7e:	0685bd83          	ld	s11,104(a1)
    80002a82:	8082                	ret

0000000080002a84 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002a84:	1141                	addi	sp,sp,-16
    80002a86:	e406                	sd	ra,8(sp)
    80002a88:	e022                	sd	s0,0(sp)
    80002a8a:	0800                	addi	s0,sp,16
    80002a8c:	00006597          	auipc	a1,0x6
    80002a90:	96c58593          	addi	a1,a1,-1684 # 800083f8 <states.0+0x30>
    80002a94:	00015517          	auipc	a0,0x15
    80002a98:	03c50513          	addi	a0,a0,60 # 80017ad0 <tickslock>
    80002a9c:	ffffe097          	auipc	ra,0xffffe
    80002aa0:	10e080e7          	jalr	270(ra) # 80000baa <initlock>
    80002aa4:	60a2                	ld	ra,8(sp)
    80002aa6:	6402                	ld	s0,0(sp)
    80002aa8:	0141                	addi	sp,sp,16
    80002aaa:	8082                	ret

0000000080002aac <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002aac:	1141                	addi	sp,sp,-16
    80002aae:	e422                	sd	s0,8(sp)
    80002ab0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002ab2:	00003797          	auipc	a5,0x3
    80002ab6:	61e78793          	addi	a5,a5,1566 # 800060d0 <kernelvec>
    80002aba:	10579073          	csrw	stvec,a5
    80002abe:	6422                	ld	s0,8(sp)
    80002ac0:	0141                	addi	sp,sp,16
    80002ac2:	8082                	ret

0000000080002ac4 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002ac4:	1141                	addi	sp,sp,-16
    80002ac6:	e406                	sd	ra,8(sp)
    80002ac8:	e022                	sd	s0,0(sp)
    80002aca:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002acc:	fffff097          	auipc	ra,0xfffff
    80002ad0:	1a0080e7          	jalr	416(ra) # 80001c6c <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ad4:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002ad8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002ada:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002ade:	00004617          	auipc	a2,0x4
    80002ae2:	52260613          	addi	a2,a2,1314 # 80007000 <_trampoline>
    80002ae6:	00004697          	auipc	a3,0x4
    80002aea:	51a68693          	addi	a3,a3,1306 # 80007000 <_trampoline>
    80002aee:	8e91                	sub	a3,a3,a2
    80002af0:	040007b7          	lui	a5,0x4000
    80002af4:	17fd                	addi	a5,a5,-1
    80002af6:	07b2                	slli	a5,a5,0xc
    80002af8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002afa:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002afe:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002b00:	180026f3          	csrr	a3,satp
    80002b04:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b06:	7538                	ld	a4,104(a0)
    80002b08:	6534                	ld	a3,72(a0)
    80002b0a:	6585                	lui	a1,0x1
    80002b0c:	96ae                	add	a3,a3,a1
    80002b0e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b10:	7538                	ld	a4,104(a0)
    80002b12:	00000697          	auipc	a3,0x0
    80002b16:	13868693          	addi	a3,a3,312 # 80002c4a <usertrap>
    80002b1a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002b1c:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002b1e:	8692                	mv	a3,tp
    80002b20:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b22:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b26:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b2a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b2e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b32:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002b34:	6f18                	ld	a4,24(a4)
    80002b36:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b3a:	6d2c                	ld	a1,88(a0)
    80002b3c:	81b1                	srli	a1,a1,0xc
  // and switches to user mode with sret.

  // * function calls ,or more generally,program executions is just about
  // * change pc from one place to another,accompany with putting arguments
  // * in stack or registers
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002b3e:	00004717          	auipc	a4,0x4
    80002b42:	55270713          	addi	a4,a4,1362 # 80007090 <userret>
    80002b46:	8f11                	sub	a4,a4,a2
    80002b48:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002b4a:	577d                	li	a4,-1
    80002b4c:	177e                	slli	a4,a4,0x3f
    80002b4e:	8dd9                	or	a1,a1,a4
    80002b50:	02000537          	lui	a0,0x2000
    80002b54:	157d                	addi	a0,a0,-1
    80002b56:	0536                	slli	a0,a0,0xd
    80002b58:	9782                	jalr	a5
}
    80002b5a:	60a2                	ld	ra,8(sp)
    80002b5c:	6402                	ld	s0,0(sp)
    80002b5e:	0141                	addi	sp,sp,16
    80002b60:	8082                	ret

0000000080002b62 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002b6c:	00015497          	auipc	s1,0x15
    80002b70:	f6448493          	addi	s1,s1,-156 # 80017ad0 <tickslock>
    80002b74:	8526                	mv	a0,s1
    80002b76:	ffffe097          	auipc	ra,0xffffe
    80002b7a:	0c4080e7          	jalr	196(ra) # 80000c3a <acquire>
  ticks++;
    80002b7e:	00006517          	auipc	a0,0x6
    80002b82:	4b250513          	addi	a0,a0,1202 # 80009030 <ticks>
    80002b86:	411c                	lw	a5,0(a0)
    80002b88:	2785                	addiw	a5,a5,1
    80002b8a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	b1c080e7          	jalr	-1252(ra) # 800026a8 <wakeup>
  release(&tickslock);
    80002b94:	8526                	mv	a0,s1
    80002b96:	ffffe097          	auipc	ra,0xffffe
    80002b9a:	158080e7          	jalr	344(ra) # 80000cee <release>
}
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	64a2                	ld	s1,8(sp)
    80002ba4:	6105                	addi	sp,sp,32
    80002ba6:	8082                	ret

0000000080002ba8 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002ba8:	1101                	addi	sp,sp,-32
    80002baa:	ec06                	sd	ra,24(sp)
    80002bac:	e822                	sd	s0,16(sp)
    80002bae:	e426                	sd	s1,8(sp)
    80002bb0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002bb2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002bb6:	00074d63          	bltz	a4,80002bd0 <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002bba:	57fd                	li	a5,-1
    80002bbc:	17fe                	slli	a5,a5,0x3f
    80002bbe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002bc0:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002bc2:	06f70363          	beq	a4,a5,80002c28 <devintr+0x80>
  }
}
    80002bc6:	60e2                	ld	ra,24(sp)
    80002bc8:	6442                	ld	s0,16(sp)
    80002bca:	64a2                	ld	s1,8(sp)
    80002bcc:	6105                	addi	sp,sp,32
    80002bce:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002bd0:	0ff77793          	andi	a5,a4,255
    80002bd4:	46a5                	li	a3,9
    80002bd6:	fed792e3          	bne	a5,a3,80002bba <devintr+0x12>
    int irq = plic_claim();
    80002bda:	00003097          	auipc	ra,0x3
    80002bde:	5fe080e7          	jalr	1534(ra) # 800061d8 <plic_claim>
    80002be2:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002be4:	47a9                	li	a5,10
    80002be6:	02f50763          	beq	a0,a5,80002c14 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002bea:	4785                	li	a5,1
    80002bec:	02f50963          	beq	a0,a5,80002c1e <devintr+0x76>
    return 1;
    80002bf0:	4505                	li	a0,1
    } else if (irq) {
    80002bf2:	d8f1                	beqz	s1,80002bc6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002bf4:	85a6                	mv	a1,s1
    80002bf6:	00006517          	auipc	a0,0x6
    80002bfa:	80a50513          	addi	a0,a0,-2038 # 80008400 <states.0+0x38>
    80002bfe:	ffffe097          	auipc	ra,0xffffe
    80002c02:	a20080e7          	jalr	-1504(ra) # 8000061e <printf>
      plic_complete(irq);
    80002c06:	8526                	mv	a0,s1
    80002c08:	00003097          	auipc	ra,0x3
    80002c0c:	5f4080e7          	jalr	1524(ra) # 800061fc <plic_complete>
    return 1;
    80002c10:	4505                	li	a0,1
    80002c12:	bf55                	j	80002bc6 <devintr+0x1e>
      uartintr();
    80002c14:	ffffe097          	auipc	ra,0xffffe
    80002c18:	dea080e7          	jalr	-534(ra) # 800009fe <uartintr>
    80002c1c:	b7ed                	j	80002c06 <devintr+0x5e>
      virtio_disk_intr();
    80002c1e:	00004097          	auipc	ra,0x4
    80002c22:	a70080e7          	jalr	-1424(ra) # 8000668e <virtio_disk_intr>
    80002c26:	b7c5                	j	80002c06 <devintr+0x5e>
    if (cpuid() == 0) {
    80002c28:	fffff097          	auipc	ra,0xfffff
    80002c2c:	018080e7          	jalr	24(ra) # 80001c40 <cpuid>
    80002c30:	c901                	beqz	a0,80002c40 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002c32:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c36:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002c38:	14479073          	csrw	sip,a5
    return 2;
    80002c3c:	4509                	li	a0,2
    80002c3e:	b761                	j	80002bc6 <devintr+0x1e>
      clockintr();
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	f22080e7          	jalr	-222(ra) # 80002b62 <clockintr>
    80002c48:	b7ed                	j	80002c32 <devintr+0x8a>

0000000080002c4a <usertrap>:
void usertrap(void) {
    80002c4a:	1101                	addi	sp,sp,-32
    80002c4c:	ec06                	sd	ra,24(sp)
    80002c4e:	e822                	sd	s0,16(sp)
    80002c50:	e426                	sd	s1,8(sp)
    80002c52:	e04a                	sd	s2,0(sp)
    80002c54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c56:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002c5a:	1007f793          	andi	a5,a5,256
    80002c5e:	e3ad                	bnez	a5,80002cc0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002c60:	00003797          	auipc	a5,0x3
    80002c64:	47078793          	addi	a5,a5,1136 # 800060d0 <kernelvec>
    80002c68:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c6c:	fffff097          	auipc	ra,0xfffff
    80002c70:	000080e7          	jalr	ra # 80001c6c <myproc>
    80002c74:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c76:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002c78:	14102773          	csrr	a4,sepc
    80002c7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c7e:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002c82:	47a1                	li	a5,8
    80002c84:	04f71c63          	bne	a4,a5,80002cdc <usertrap+0x92>
    if (p->killed)
    80002c88:	551c                	lw	a5,40(a0)
    80002c8a:	e3b9                	bnez	a5,80002cd0 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002c8c:	74b8                	ld	a4,104(s1)
    80002c8e:	6f1c                	ld	a5,24(a4)
    80002c90:	0791                	addi	a5,a5,4
    80002c92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c94:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002c98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002c9c:	10079073          	csrw	sstatus,a5
    syscall();
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	312080e7          	jalr	786(ra) # 80002fb2 <syscall>
  if (p->killed)
    80002ca8:	549c                	lw	a5,40(s1)
    80002caa:	e3dd                	bnez	a5,80002d50 <usertrap+0x106>
  usertrapret();
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	e18080e7          	jalr	-488(ra) # 80002ac4 <usertrapret>
}
    80002cb4:	60e2                	ld	ra,24(sp)
    80002cb6:	6442                	ld	s0,16(sp)
    80002cb8:	64a2                	ld	s1,8(sp)
    80002cba:	6902                	ld	s2,0(sp)
    80002cbc:	6105                	addi	sp,sp,32
    80002cbe:	8082                	ret
    panic("usertrap: not from user mode");
    80002cc0:	00005517          	auipc	a0,0x5
    80002cc4:	76050513          	addi	a0,a0,1888 # 80008420 <states.0+0x58>
    80002cc8:	ffffe097          	auipc	ra,0xffffe
    80002ccc:	904080e7          	jalr	-1788(ra) # 800005cc <panic>
      exit(-1);
    80002cd0:	557d                	li	a0,-1
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	aa6080e7          	jalr	-1370(ra) # 80002778 <exit>
    80002cda:	bf4d                	j	80002c8c <usertrap+0x42>
  } else if ((which_dev = devintr()) != 0) {
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	ecc080e7          	jalr	-308(ra) # 80002ba8 <devintr>
    80002ce4:	892a                	mv	s2,a0
    80002ce6:	c501                	beqz	a0,80002cee <usertrap+0xa4>
  if (p->killed)
    80002ce8:	549c                	lw	a5,40(s1)
    80002cea:	c3a1                	beqz	a5,80002d2a <usertrap+0xe0>
    80002cec:	a815                	j	80002d20 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002cee:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002cf2:	5890                	lw	a2,48(s1)
    80002cf4:	00005517          	auipc	a0,0x5
    80002cf8:	74c50513          	addi	a0,a0,1868 # 80008440 <states.0+0x78>
    80002cfc:	ffffe097          	auipc	ra,0xffffe
    80002d00:	922080e7          	jalr	-1758(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002d04:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d08:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d0c:	00005517          	auipc	a0,0x5
    80002d10:	76450513          	addi	a0,a0,1892 # 80008470 <states.0+0xa8>
    80002d14:	ffffe097          	auipc	ra,0xffffe
    80002d18:	90a080e7          	jalr	-1782(ra) # 8000061e <printf>
    p->killed = 1;
    80002d1c:	4785                	li	a5,1
    80002d1e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002d20:	557d                	li	a0,-1
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	a56080e7          	jalr	-1450(ra) # 80002778 <exit>
  if (which_dev == 2) {
    80002d2a:	4789                	li	a5,2
    80002d2c:	f8f910e3          	bne	s2,a5,80002cac <usertrap+0x62>
    if (p->if_alarm) {
    80002d30:	1684c783          	lbu	a5,360(s1)
    80002d34:	cb89                	beqz	a5,80002d46 <usertrap+0xfc>
      p->tick_left -= 1;
    80002d36:	1704a783          	lw	a5,368(s1)
    80002d3a:	37fd                	addiw	a5,a5,-1
    80002d3c:	0007871b          	sext.w	a4,a5
    80002d40:	16f4a823          	sw	a5,368(s1)
      if (p->tick_left == 0) {
    80002d44:	cb01                	beqz	a4,80002d54 <usertrap+0x10a>
    yield();
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	79a080e7          	jalr	1946(ra) # 800024e0 <yield>
    80002d4e:	bfb9                	j	80002cac <usertrap+0x62>
  int which_dev = 0;
    80002d50:	4901                	li	s2,0
    80002d52:	b7f9                	j	80002d20 <usertrap+0xd6>
        p->if_alarm = 0;
    80002d54:	16048423          	sb	zero,360(s1)
        u64 epc = p->trapframe->epc;
    80002d58:	74bc                	ld	a5,104(s1)
    80002d5a:	6f98                	ld	a4,24(a5)
        p->trapframe->epc = (u64)fn;
    80002d5c:	1784b683          	ld	a3,376(s1)
    80002d60:	ef94                	sd	a3,24(a5)
        p->trapframe->ra = epc;
    80002d62:	74bc                	ld	a5,104(s1)
    80002d64:	f798                	sd	a4,40(a5)
        usertrapret();
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	d5e080e7          	jalr	-674(ra) # 80002ac4 <usertrapret>
    80002d6e:	bfe1                	j	80002d46 <usertrap+0xfc>

0000000080002d70 <kerneltrap>:
void kerneltrap() {
    80002d70:	7179                	addi	sp,sp,-48
    80002d72:	f406                	sd	ra,40(sp)
    80002d74:	f022                	sd	s0,32(sp)
    80002d76:	ec26                	sd	s1,24(sp)
    80002d78:	e84a                	sd	s2,16(sp)
    80002d7a:	e44e                	sd	s3,8(sp)
    80002d7c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002d7e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d82:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d86:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002d8a:	1004f793          	andi	a5,s1,256
    80002d8e:	cb85                	beqz	a5,80002dbe <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d90:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d94:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002d96:	ef85                	bnez	a5,80002dce <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	e10080e7          	jalr	-496(ra) # 80002ba8 <devintr>
    80002da0:	cd1d                	beqz	a0,80002dde <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002da2:	4789                	li	a5,2
    80002da4:	06f50a63          	beq	a0,a5,80002e18 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002da8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002dac:	10049073          	csrw	sstatus,s1
}
    80002db0:	70a2                	ld	ra,40(sp)
    80002db2:	7402                	ld	s0,32(sp)
    80002db4:	64e2                	ld	s1,24(sp)
    80002db6:	6942                	ld	s2,16(sp)
    80002db8:	69a2                	ld	s3,8(sp)
    80002dba:	6145                	addi	sp,sp,48
    80002dbc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002dbe:	00005517          	auipc	a0,0x5
    80002dc2:	6d250513          	addi	a0,a0,1746 # 80008490 <states.0+0xc8>
    80002dc6:	ffffe097          	auipc	ra,0xffffe
    80002dca:	806080e7          	jalr	-2042(ra) # 800005cc <panic>
    panic("kerneltrap: interrupts enabled");
    80002dce:	00005517          	auipc	a0,0x5
    80002dd2:	6ea50513          	addi	a0,a0,1770 # 800084b8 <states.0+0xf0>
    80002dd6:	ffffd097          	auipc	ra,0xffffd
    80002dda:	7f6080e7          	jalr	2038(ra) # 800005cc <panic>
    printf("scause %p\n", scause);
    80002dde:	85ce                	mv	a1,s3
    80002de0:	00005517          	auipc	a0,0x5
    80002de4:	6f850513          	addi	a0,a0,1784 # 800084d8 <states.0+0x110>
    80002de8:	ffffe097          	auipc	ra,0xffffe
    80002dec:	836080e7          	jalr	-1994(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002df0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002df4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002df8:	00005517          	auipc	a0,0x5
    80002dfc:	6f050513          	addi	a0,a0,1776 # 800084e8 <states.0+0x120>
    80002e00:	ffffe097          	auipc	ra,0xffffe
    80002e04:	81e080e7          	jalr	-2018(ra) # 8000061e <printf>
    panic("kerneltrap");
    80002e08:	00005517          	auipc	a0,0x5
    80002e0c:	6f850513          	addi	a0,a0,1784 # 80008500 <states.0+0x138>
    80002e10:	ffffd097          	auipc	ra,0xffffd
    80002e14:	7bc080e7          	jalr	1980(ra) # 800005cc <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	e54080e7          	jalr	-428(ra) # 80001c6c <myproc>
    80002e20:	d541                	beqz	a0,80002da8 <kerneltrap+0x38>
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	e4a080e7          	jalr	-438(ra) # 80001c6c <myproc>
    80002e2a:	4d18                	lw	a4,24(a0)
    80002e2c:	4791                	li	a5,4
    80002e2e:	f6f71de3          	bne	a4,a5,80002da8 <kerneltrap+0x38>
    yield();
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	6ae080e7          	jalr	1710(ra) # 800024e0 <yield>
    80002e3a:	b7bd                	j	80002da8 <kerneltrap+0x38>

0000000080002e3c <argraw>:
  if (err < 0)
    return err;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	1000                	addi	s0,sp,32
    80002e46:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002e48:	fffff097          	auipc	ra,0xfffff
    80002e4c:	e24080e7          	jalr	-476(ra) # 80001c6c <myproc>
  switch (n) {
    80002e50:	4795                	li	a5,5
    80002e52:	0497e163          	bltu	a5,s1,80002e94 <argraw+0x58>
    80002e56:	048a                	slli	s1,s1,0x2
    80002e58:	00005717          	auipc	a4,0x5
    80002e5c:	6f870713          	addi	a4,a4,1784 # 80008550 <states.0+0x188>
    80002e60:	94ba                	add	s1,s1,a4
    80002e62:	409c                	lw	a5,0(s1)
    80002e64:	97ba                	add	a5,a5,a4
    80002e66:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e68:	753c                	ld	a5,104(a0)
    80002e6a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	6105                	addi	sp,sp,32
    80002e74:	8082                	ret
    return p->trapframe->a1;
    80002e76:	753c                	ld	a5,104(a0)
    80002e78:	7fa8                	ld	a0,120(a5)
    80002e7a:	bfcd                	j	80002e6c <argraw+0x30>
    return p->trapframe->a2;
    80002e7c:	753c                	ld	a5,104(a0)
    80002e7e:	63c8                	ld	a0,128(a5)
    80002e80:	b7f5                	j	80002e6c <argraw+0x30>
    return p->trapframe->a3;
    80002e82:	753c                	ld	a5,104(a0)
    80002e84:	67c8                	ld	a0,136(a5)
    80002e86:	b7dd                	j	80002e6c <argraw+0x30>
    return p->trapframe->a4;
    80002e88:	753c                	ld	a5,104(a0)
    80002e8a:	6bc8                	ld	a0,144(a5)
    80002e8c:	b7c5                	j	80002e6c <argraw+0x30>
    return p->trapframe->a5;
    80002e8e:	753c                	ld	a5,104(a0)
    80002e90:	6fc8                	ld	a0,152(a5)
    80002e92:	bfe9                	j	80002e6c <argraw+0x30>
  panic("argraw");
    80002e94:	00005517          	auipc	a0,0x5
    80002e98:	67c50513          	addi	a0,a0,1660 # 80008510 <states.0+0x148>
    80002e9c:	ffffd097          	auipc	ra,0xffffd
    80002ea0:	730080e7          	jalr	1840(ra) # 800005cc <panic>

0000000080002ea4 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80002ea4:	1101                	addi	sp,sp,-32
    80002ea6:	ec06                	sd	ra,24(sp)
    80002ea8:	e822                	sd	s0,16(sp)
    80002eaa:	e426                	sd	s1,8(sp)
    80002eac:	e04a                	sd	s2,0(sp)
    80002eae:	1000                	addi	s0,sp,32
    80002eb0:	84aa                	mv	s1,a0
    80002eb2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	db8080e7          	jalr	-584(ra) # 80001c6c <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80002ebc:	693c                	ld	a5,80(a0)
    80002ebe:	02f4f863          	bgeu	s1,a5,80002eee <fetchaddr+0x4a>
    80002ec2:	00848713          	addi	a4,s1,8
    80002ec6:	02e7e663          	bltu	a5,a4,80002ef2 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002eca:	46a1                	li	a3,8
    80002ecc:	8626                	mv	a2,s1
    80002ece:	85ca                	mv	a1,s2
    80002ed0:	6d28                	ld	a0,88(a0)
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	a90080e7          	jalr	-1392(ra) # 80001962 <copyin>
    80002eda:	00a03533          	snez	a0,a0
    80002ede:	40a00533          	neg	a0,a0
}
    80002ee2:	60e2                	ld	ra,24(sp)
    80002ee4:	6442                	ld	s0,16(sp)
    80002ee6:	64a2                	ld	s1,8(sp)
    80002ee8:	6902                	ld	s2,0(sp)
    80002eea:	6105                	addi	sp,sp,32
    80002eec:	8082                	ret
    return -1;
    80002eee:	557d                	li	a0,-1
    80002ef0:	bfcd                	j	80002ee2 <fetchaddr+0x3e>
    80002ef2:	557d                	li	a0,-1
    80002ef4:	b7fd                	j	80002ee2 <fetchaddr+0x3e>

0000000080002ef6 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80002ef6:	7179                	addi	sp,sp,-48
    80002ef8:	f406                	sd	ra,40(sp)
    80002efa:	f022                	sd	s0,32(sp)
    80002efc:	ec26                	sd	s1,24(sp)
    80002efe:	e84a                	sd	s2,16(sp)
    80002f00:	e44e                	sd	s3,8(sp)
    80002f02:	1800                	addi	s0,sp,48
    80002f04:	892a                	mv	s2,a0
    80002f06:	84ae                	mv	s1,a1
    80002f08:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	d62080e7          	jalr	-670(ra) # 80001c6c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002f12:	86ce                	mv	a3,s3
    80002f14:	864a                	mv	a2,s2
    80002f16:	85a6                	mv	a1,s1
    80002f18:	6d28                	ld	a0,88(a0)
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	ada080e7          	jalr	-1318(ra) # 800019f4 <copyinstr>
  if (err < 0)
    80002f22:	00054763          	bltz	a0,80002f30 <fetchstr+0x3a>
  return strlen(buf);
    80002f26:	8526                	mv	a0,s1
    80002f28:	ffffe097          	auipc	ra,0xffffe
    80002f2c:	f92080e7          	jalr	-110(ra) # 80000eba <strlen>
}
    80002f30:	70a2                	ld	ra,40(sp)
    80002f32:	7402                	ld	s0,32(sp)
    80002f34:	64e2                	ld	s1,24(sp)
    80002f36:	6942                	ld	s2,16(sp)
    80002f38:	69a2                	ld	s3,8(sp)
    80002f3a:	6145                	addi	sp,sp,48
    80002f3c:	8082                	ret

0000000080002f3e <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
    80002f3e:	1101                	addi	sp,sp,-32
    80002f40:	ec06                	sd	ra,24(sp)
    80002f42:	e822                	sd	s0,16(sp)
    80002f44:	e426                	sd	s1,8(sp)
    80002f46:	1000                	addi	s0,sp,32
    80002f48:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	ef2080e7          	jalr	-270(ra) # 80002e3c <argraw>
    80002f52:	c088                	sw	a0,0(s1)
  return 0;
}
    80002f54:	4501                	li	a0,0
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret

0000000080002f60 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip) {
    80002f60:	1101                	addi	sp,sp,-32
    80002f62:	ec06                	sd	ra,24(sp)
    80002f64:	e822                	sd	s0,16(sp)
    80002f66:	e426                	sd	s1,8(sp)
    80002f68:	1000                	addi	s0,sp,32
    80002f6a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f6c:	00000097          	auipc	ra,0x0
    80002f70:	ed0080e7          	jalr	-304(ra) # 80002e3c <argraw>
    80002f74:	e088                	sd	a0,0(s1)
  return 0;
}
    80002f76:	4501                	li	a0,0
    80002f78:	60e2                	ld	ra,24(sp)
    80002f7a:	6442                	ld	s0,16(sp)
    80002f7c:	64a2                	ld	s1,8(sp)
    80002f7e:	6105                	addi	sp,sp,32
    80002f80:	8082                	ret

0000000080002f82 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    80002f82:	1101                	addi	sp,sp,-32
    80002f84:	ec06                	sd	ra,24(sp)
    80002f86:	e822                	sd	s0,16(sp)
    80002f88:	e426                	sd	s1,8(sp)
    80002f8a:	e04a                	sd	s2,0(sp)
    80002f8c:	1000                	addi	s0,sp,32
    80002f8e:	84ae                	mv	s1,a1
    80002f90:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f92:	00000097          	auipc	ra,0x0
    80002f96:	eaa080e7          	jalr	-342(ra) # 80002e3c <argraw>
  uint64 addr;
  if (argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002f9a:	864a                	mv	a2,s2
    80002f9c:	85a6                	mv	a1,s1
    80002f9e:	00000097          	auipc	ra,0x0
    80002fa2:	f58080e7          	jalr	-168(ra) # 80002ef6 <fetchstr>
}
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	64a2                	ld	s1,8(sp)
    80002fac:	6902                	ld	s2,0(sp)
    80002fae:	6105                	addi	sp,sp,32
    80002fb0:	8082                	ret

0000000080002fb2 <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,   [SYS_trace] = sys_trace,
    [SYS_alarm] = sys_alarm,   [SYS_alarmret] = sys_alarmret};

void syscall(void) {
    80002fb2:	7179                	addi	sp,sp,-48
    80002fb4:	f406                	sd	ra,40(sp)
    80002fb6:	f022                	sd	s0,32(sp)
    80002fb8:	ec26                	sd	s1,24(sp)
    80002fba:	e84a                	sd	s2,16(sp)
    80002fbc:	e44e                	sd	s3,8(sp)
    80002fbe:	e052                	sd	s4,0(sp)
    80002fc0:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	caa080e7          	jalr	-854(ra) # 80001c6c <myproc>
    80002fca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002fcc:	753c                	ld	a5,104(a0)
    80002fce:	77dc                	ld	a5,168(a5)
    80002fd0:	0007891b          	sext.w	s2,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fd4:	37fd                	addiw	a5,a5,-1
    80002fd6:	475d                	li	a4,23
    80002fd8:	04f76f63          	bltu	a4,a5,80003036 <syscall+0x84>
    80002fdc:	00391713          	slli	a4,s2,0x3
    80002fe0:	00005797          	auipc	a5,0x5
    80002fe4:	58878793          	addi	a5,a5,1416 # 80008568 <syscalls>
    80002fe8:	97ba                	add	a5,a5,a4
    80002fea:	0007ba03          	ld	s4,0(a5)
    80002fee:	040a0463          	beqz	s4,80003036 <syscall+0x84>
    i32 mask = myproc()->traced;
    80002ff2:	fffff097          	auipc	ra,0xfffff
    80002ff6:	c7a080e7          	jalr	-902(ra) # 80001c6c <myproc>
    80002ffa:	04052983          	lw	s3,64(a0)
    u64 res = syscalls[num]();
    80002ffe:	9a02                	jalr	s4
    80003000:	8a2a                	mv	s4,a0
    if (mask & (1 << num)) {
    80003002:	4129d9bb          	sraw	s3,s3,s2
    80003006:	0019f993          	andi	s3,s3,1
    8000300a:	00099663          	bnez	s3,80003016 <syscall+0x64>
      printf("%d: syscall %d -> %d\n", myproc()->pid, num, res);
    }
    p->trapframe->a0 = res;
    8000300e:	74bc                	ld	a5,104(s1)
    80003010:	0747b823          	sd	s4,112(a5)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003014:	a081                	j	80003054 <syscall+0xa2>
      printf("%d: syscall %d -> %d\n", myproc()->pid, num, res);
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	c56080e7          	jalr	-938(ra) # 80001c6c <myproc>
    8000301e:	86d2                	mv	a3,s4
    80003020:	864a                	mv	a2,s2
    80003022:	590c                	lw	a1,48(a0)
    80003024:	00005517          	auipc	a0,0x5
    80003028:	4f450513          	addi	a0,a0,1268 # 80008518 <states.0+0x150>
    8000302c:	ffffd097          	auipc	ra,0xffffd
    80003030:	5f2080e7          	jalr	1522(ra) # 8000061e <printf>
    80003034:	bfe9                	j	8000300e <syscall+0x5c>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80003036:	86ca                	mv	a3,s2
    80003038:	18048613          	addi	a2,s1,384
    8000303c:	588c                	lw	a1,48(s1)
    8000303e:	00005517          	auipc	a0,0x5
    80003042:	4f250513          	addi	a0,a0,1266 # 80008530 <states.0+0x168>
    80003046:	ffffd097          	auipc	ra,0xffffd
    8000304a:	5d8080e7          	jalr	1496(ra) # 8000061e <printf>
    p->trapframe->a0 = -1;
    8000304e:	74bc                	ld	a5,104(s1)
    80003050:	577d                	li	a4,-1
    80003052:	fbb8                	sd	a4,112(a5)
  }
}
    80003054:	70a2                	ld	ra,40(sp)
    80003056:	7402                	ld	s0,32(sp)
    80003058:	64e2                	ld	s1,24(sp)
    8000305a:	6942                	ld	s2,16(sp)
    8000305c:	69a2                	ld	s3,8(sp)
    8000305e:	6a02                	ld	s4,0(sp)
    80003060:	6145                	addi	sp,sp,48
    80003062:	8082                	ret

0000000080003064 <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    80003064:	1101                	addi	sp,sp,-32
    80003066:	ec06                	sd	ra,24(sp)
    80003068:	e822                	sd	s0,16(sp)
    8000306a:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    8000306c:	fec40593          	addi	a1,s0,-20
    80003070:	4501                	li	a0,0
    80003072:	00000097          	auipc	ra,0x0
    80003076:	ecc080e7          	jalr	-308(ra) # 80002f3e <argint>
    return -1;
    8000307a:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    8000307c:	00054963          	bltz	a0,8000308e <sys_exit+0x2a>
  exit(n);
    80003080:	fec42503          	lw	a0,-20(s0)
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	6f4080e7          	jalr	1780(ra) # 80002778 <exit>
  return 0; // not reached
    8000308c:	4781                	li	a5,0
}
    8000308e:	853e                	mv	a0,a5
    80003090:	60e2                	ld	ra,24(sp)
    80003092:	6442                	ld	s0,16(sp)
    80003094:	6105                	addi	sp,sp,32
    80003096:	8082                	ret

0000000080003098 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80003098:	1141                	addi	sp,sp,-16
    8000309a:	e406                	sd	ra,8(sp)
    8000309c:	e022                	sd	s0,0(sp)
    8000309e:	0800                	addi	s0,sp,16
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	bcc080e7          	jalr	-1076(ra) # 80001c6c <myproc>
    800030a8:	5908                	lw	a0,48(a0)
    800030aa:	60a2                	ld	ra,8(sp)
    800030ac:	6402                	ld	s0,0(sp)
    800030ae:	0141                	addi	sp,sp,16
    800030b0:	8082                	ret

00000000800030b2 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800030b2:	1141                	addi	sp,sp,-16
    800030b4:	e406                	sd	ra,8(sp)
    800030b6:	e022                	sd	s0,0(sp)
    800030b8:	0800                	addi	s0,sp,16
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	0e0080e7          	jalr	224(ra) # 8000219a <fork>
    800030c2:	60a2                	ld	ra,8(sp)
    800030c4:	6402                	ld	s0,0(sp)
    800030c6:	0141                	addi	sp,sp,16
    800030c8:	8082                	ret

00000000800030ca <sys_wait>:

uint64 sys_wait(void) {
    800030ca:	1101                	addi	sp,sp,-32
    800030cc:	ec06                	sd	ra,24(sp)
    800030ce:	e822                	sd	s0,16(sp)
    800030d0:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    800030d2:	fe840593          	addi	a1,s0,-24
    800030d6:	4501                	li	a0,0
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	e88080e7          	jalr	-376(ra) # 80002f60 <argaddr>
    800030e0:	87aa                	mv	a5,a0
    return -1;
    800030e2:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    800030e4:	0007c863          	bltz	a5,800030f4 <sys_wait+0x2a>
  return wait(p);
    800030e8:	fe843503          	ld	a0,-24(s0)
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	494080e7          	jalr	1172(ra) # 80002580 <wait>
}
    800030f4:	60e2                	ld	ra,24(sp)
    800030f6:	6442                	ld	s0,16(sp)
    800030f8:	6105                	addi	sp,sp,32
    800030fa:	8082                	ret

00000000800030fc <sys_sbrk>:

uint64 sys_sbrk(void) {
    800030fc:	7179                	addi	sp,sp,-48
    800030fe:	f406                	sd	ra,40(sp)
    80003100:	f022                	sd	s0,32(sp)
    80003102:	ec26                	sd	s1,24(sp)
    80003104:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    80003106:	fdc40593          	addi	a1,s0,-36
    8000310a:	4501                	li	a0,0
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	e32080e7          	jalr	-462(ra) # 80002f3e <argint>
    return -1;
    80003114:	54fd                	li	s1,-1
  if (argint(0, &n) < 0)
    80003116:	00054f63          	bltz	a0,80003134 <sys_sbrk+0x38>
  addr = myproc()->sz;
    8000311a:	fffff097          	auipc	ra,0xfffff
    8000311e:	b52080e7          	jalr	-1198(ra) # 80001c6c <myproc>
    80003122:	4924                	lw	s1,80(a0)
  if (growproc(n) < 0)
    80003124:	fdc42503          	lw	a0,-36(s0)
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	f62080e7          	jalr	-158(ra) # 8000208a <growproc>
    80003130:	00054863          	bltz	a0,80003140 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80003134:	8526                	mv	a0,s1
    80003136:	70a2                	ld	ra,40(sp)
    80003138:	7402                	ld	s0,32(sp)
    8000313a:	64e2                	ld	s1,24(sp)
    8000313c:	6145                	addi	sp,sp,48
    8000313e:	8082                	ret
    return -1;
    80003140:	54fd                	li	s1,-1
    80003142:	bfcd                	j	80003134 <sys_sbrk+0x38>

0000000080003144 <sys_trace>:

u64 sys_trace(void) {
    80003144:	1101                	addi	sp,sp,-32
    80003146:	ec06                	sd	ra,24(sp)
    80003148:	e822                	sd	s0,16(sp)
    8000314a:	1000                	addi	s0,sp,32
  i32 traced;
  if (argint(0, &traced) < 0)
    8000314c:	fec40593          	addi	a1,s0,-20
    80003150:	4501                	li	a0,0
    80003152:	00000097          	auipc	ra,0x0
    80003156:	dec080e7          	jalr	-532(ra) # 80002f3e <argint>
    8000315a:	87aa                	mv	a5,a0
    return -1;
    8000315c:	557d                	li	a0,-1
  if (argint(0, &traced) < 0)
    8000315e:	0007c863          	bltz	a5,8000316e <sys_trace+0x2a>
  return trace(traced);
    80003162:	fec42503          	lw	a0,-20(s0)
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	fd2080e7          	jalr	-46(ra) # 80002138 <trace>
}
    8000316e:	60e2                	ld	ra,24(sp)
    80003170:	6442                	ld	s0,16(sp)
    80003172:	6105                	addi	sp,sp,32
    80003174:	8082                	ret

0000000080003176 <sys_alarm>:

u64 sys_alarm(void) {
    80003176:	1101                	addi	sp,sp,-32
    80003178:	ec06                	sd	ra,24(sp)
    8000317a:	e822                	sd	s0,16(sp)
    8000317c:	1000                	addi	s0,sp,32
  i32 tick;
  u64 handler;
  if (argaddr(1, &handler) < 0)
    8000317e:	fe040593          	addi	a1,s0,-32
    80003182:	4505                	li	a0,1
    80003184:	00000097          	auipc	ra,0x0
    80003188:	ddc080e7          	jalr	-548(ra) # 80002f60 <argaddr>
    return -1;
    8000318c:	57fd                	li	a5,-1
  if (argaddr(1, &handler) < 0)
    8000318e:	02054563          	bltz	a0,800031b8 <sys_alarm+0x42>
  if (argint(0, &tick) < 0)
    80003192:	fec40593          	addi	a1,s0,-20
    80003196:	4501                	li	a0,0
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	da6080e7          	jalr	-602(ra) # 80002f3e <argint>
    return -1;
    800031a0:	57fd                	li	a5,-1
  if (argint(0, &tick) < 0)
    800031a2:	00054b63          	bltz	a0,800031b8 <sys_alarm+0x42>
  return alarm(tick, (void *)handler);
    800031a6:	fe043583          	ld	a1,-32(s0)
    800031aa:	fec42503          	lw	a0,-20(s0)
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	fb0080e7          	jalr	-80(ra) # 8000215e <alarm>
    800031b6:	87aa                	mv	a5,a0
}
    800031b8:	853e                	mv	a0,a5
    800031ba:	60e2                	ld	ra,24(sp)
    800031bc:	6442                	ld	s0,16(sp)
    800031be:	6105                	addi	sp,sp,32
    800031c0:	8082                	ret

00000000800031c2 <sys_alarmret>:

u64 sys_alarmret(void) {
    800031c2:	1141                	addi	sp,sp,-16
    800031c4:	e406                	sd	ra,8(sp)
    800031c6:	e022                	sd	s0,0(sp)
    800031c8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	aa2080e7          	jalr	-1374(ra) # 80001c6c <myproc>
  // * restore argument registers
  asm volatile("csrrw a0, sscratch, a0");
    800031d2:	14051573          	csrrw	a0,sscratch,a0
  asm volatile("ld t0, 112(a0)");
    800031d6:	07053283          	ld	t0,112(a0)
  asm volatile("csrw sscratch, t0");
    800031da:	14029073          	csrw	sscratch,t0

  asm volatile("ld a1,120(a0)");
    800031de:	7d2c                	ld	a1,120(a0)
  asm volatile("ld a2,128(a0)");
    800031e0:	6150                	ld	a2,128(a0)
  asm volatile("ld a3,136(a0)");
    800031e2:	6554                	ld	a3,136(a0)
  asm volatile("ld a4,144(a0)");
    800031e4:	6958                	ld	a4,144(a0)
  asm volatile("ld a5,152(a0)");
    800031e6:	6d5c                	ld	a5,152(a0)
  asm volatile("ld a6,160(a0)");
    800031e8:	0a053803          	ld	a6,160(a0)
  asm volatile("ld a7,168(a0)");
    800031ec:	0a853883          	ld	a7,168(a0)

  asm volatile("ld t0, 72(a0)");
    800031f0:	04853283          	ld	t0,72(a0)
  asm volatile("ld t1, 80(a0)");
    800031f4:	05053303          	ld	t1,80(a0)
  asm volatile("ld t2, 88(a0)");
    800031f8:	05853383          	ld	t2,88(a0)
  asm volatile("ld t3, 256(a0)");
    800031fc:	10053e03          	ld	t3,256(a0)
  asm volatile("ld t4, 264(a0)");
    80003200:	10853e83          	ld	t4,264(a0)
  asm volatile("ld t5, 272(a0)");
    80003204:	11053f03          	ld	t5,272(a0)
  asm volatile("ld t6, 280(a0)");
    80003208:	11853f83          	ld	t6,280(a0)

  asm volatile("csrrw a0, sscratch, a0");
    8000320c:	14051573          	csrrw	a0,sscratch,a0

  return 0;
}
    80003210:	4501                	li	a0,0
    80003212:	60a2                	ld	ra,8(sp)
    80003214:	6402                	ld	s0,0(sp)
    80003216:	0141                	addi	sp,sp,16
    80003218:	8082                	ret

000000008000321a <sys_sleep>:

uint64 sys_sleep(void) {
    8000321a:	7139                	addi	sp,sp,-64
    8000321c:	fc06                	sd	ra,56(sp)
    8000321e:	f822                	sd	s0,48(sp)
    80003220:	f426                	sd	s1,40(sp)
    80003222:	f04a                	sd	s2,32(sp)
    80003224:	ec4e                	sd	s3,24(sp)
    80003226:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80003228:	fcc40593          	addi	a1,s0,-52
    8000322c:	4501                	li	a0,0
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	d10080e7          	jalr	-752(ra) # 80002f3e <argint>
    return -1;
    80003236:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003238:	06054563          	bltz	a0,800032a2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000323c:	00015517          	auipc	a0,0x15
    80003240:	89450513          	addi	a0,a0,-1900 # 80017ad0 <tickslock>
    80003244:	ffffe097          	auipc	ra,0xffffe
    80003248:	9f6080e7          	jalr	-1546(ra) # 80000c3a <acquire>
  ticks0 = ticks;
    8000324c:	00006917          	auipc	s2,0x6
    80003250:	de492903          	lw	s2,-540(s2) # 80009030 <ticks>
  while (ticks - ticks0 < n) {
    80003254:	fcc42783          	lw	a5,-52(s0)
    80003258:	cf85                	beqz	a5,80003290 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000325a:	00015997          	auipc	s3,0x15
    8000325e:	87698993          	addi	s3,s3,-1930 # 80017ad0 <tickslock>
    80003262:	00006497          	auipc	s1,0x6
    80003266:	dce48493          	addi	s1,s1,-562 # 80009030 <ticks>
    if (myproc()->killed) {
    8000326a:	fffff097          	auipc	ra,0xfffff
    8000326e:	a02080e7          	jalr	-1534(ra) # 80001c6c <myproc>
    80003272:	551c                	lw	a5,40(a0)
    80003274:	ef9d                	bnez	a5,800032b2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003276:	85ce                	mv	a1,s3
    80003278:	8526                	mv	a0,s1
    8000327a:	fffff097          	auipc	ra,0xfffff
    8000327e:	2a2080e7          	jalr	674(ra) # 8000251c <sleep>
  while (ticks - ticks0 < n) {
    80003282:	409c                	lw	a5,0(s1)
    80003284:	412787bb          	subw	a5,a5,s2
    80003288:	fcc42703          	lw	a4,-52(s0)
    8000328c:	fce7efe3          	bltu	a5,a4,8000326a <sys_sleep+0x50>
  }
  release(&tickslock);
    80003290:	00015517          	auipc	a0,0x15
    80003294:	84050513          	addi	a0,a0,-1984 # 80017ad0 <tickslock>
    80003298:	ffffe097          	auipc	ra,0xffffe
    8000329c:	a56080e7          	jalr	-1450(ra) # 80000cee <release>
  return 0;
    800032a0:	4781                	li	a5,0
}
    800032a2:	853e                	mv	a0,a5
    800032a4:	70e2                	ld	ra,56(sp)
    800032a6:	7442                	ld	s0,48(sp)
    800032a8:	74a2                	ld	s1,40(sp)
    800032aa:	7902                	ld	s2,32(sp)
    800032ac:	69e2                	ld	s3,24(sp)
    800032ae:	6121                	addi	sp,sp,64
    800032b0:	8082                	ret
      release(&tickslock);
    800032b2:	00015517          	auipc	a0,0x15
    800032b6:	81e50513          	addi	a0,a0,-2018 # 80017ad0 <tickslock>
    800032ba:	ffffe097          	auipc	ra,0xffffe
    800032be:	a34080e7          	jalr	-1484(ra) # 80000cee <release>
      return -1;
    800032c2:	57fd                	li	a5,-1
    800032c4:	bff9                	j	800032a2 <sys_sleep+0x88>

00000000800032c6 <sys_kill>:

uint64 sys_kill(void) {
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800032ce:	fec40593          	addi	a1,s0,-20
    800032d2:	4501                	li	a0,0
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	c6a080e7          	jalr	-918(ra) # 80002f3e <argint>
    800032dc:	87aa                	mv	a5,a0
    return -1;
    800032de:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800032e0:	0007c863          	bltz	a5,800032f0 <sys_kill+0x2a>
  return kill(pid);
    800032e4:	fec42503          	lw	a0,-20(s0)
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	566080e7          	jalr	1382(ra) # 8000284e <kill>
}
    800032f0:	60e2                	ld	ra,24(sp)
    800032f2:	6442                	ld	s0,16(sp)
    800032f4:	6105                	addi	sp,sp,32
    800032f6:	8082                	ret

00000000800032f8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800032f8:	1101                	addi	sp,sp,-32
    800032fa:	ec06                	sd	ra,24(sp)
    800032fc:	e822                	sd	s0,16(sp)
    800032fe:	e426                	sd	s1,8(sp)
    80003300:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003302:	00014517          	auipc	a0,0x14
    80003306:	7ce50513          	addi	a0,a0,1998 # 80017ad0 <tickslock>
    8000330a:	ffffe097          	auipc	ra,0xffffe
    8000330e:	930080e7          	jalr	-1744(ra) # 80000c3a <acquire>
  xticks = ticks;
    80003312:	00006497          	auipc	s1,0x6
    80003316:	d1e4a483          	lw	s1,-738(s1) # 80009030 <ticks>
  release(&tickslock);
    8000331a:	00014517          	auipc	a0,0x14
    8000331e:	7b650513          	addi	a0,a0,1974 # 80017ad0 <tickslock>
    80003322:	ffffe097          	auipc	ra,0xffffe
    80003326:	9cc080e7          	jalr	-1588(ra) # 80000cee <release>
  return xticks;
}
    8000332a:	02049513          	slli	a0,s1,0x20
    8000332e:	9101                	srli	a0,a0,0x20
    80003330:	60e2                	ld	ra,24(sp)
    80003332:	6442                	ld	s0,16(sp)
    80003334:	64a2                	ld	s1,8(sp)
    80003336:	6105                	addi	sp,sp,32
    80003338:	8082                	ret

000000008000333a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000333a:	7179                	addi	sp,sp,-48
    8000333c:	f406                	sd	ra,40(sp)
    8000333e:	f022                	sd	s0,32(sp)
    80003340:	ec26                	sd	s1,24(sp)
    80003342:	e84a                	sd	s2,16(sp)
    80003344:	e44e                	sd	s3,8(sp)
    80003346:	e052                	sd	s4,0(sp)
    80003348:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000334a:	00005597          	auipc	a1,0x5
    8000334e:	2e658593          	addi	a1,a1,742 # 80008630 <syscalls+0xc8>
    80003352:	00014517          	auipc	a0,0x14
    80003356:	79650513          	addi	a0,a0,1942 # 80017ae8 <bcache>
    8000335a:	ffffe097          	auipc	ra,0xffffe
    8000335e:	850080e7          	jalr	-1968(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003362:	0001c797          	auipc	a5,0x1c
    80003366:	78678793          	addi	a5,a5,1926 # 8001fae8 <bcache+0x8000>
    8000336a:	0001d717          	auipc	a4,0x1d
    8000336e:	9e670713          	addi	a4,a4,-1562 # 8001fd50 <bcache+0x8268>
    80003372:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003376:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000337a:	00014497          	auipc	s1,0x14
    8000337e:	78648493          	addi	s1,s1,1926 # 80017b00 <bcache+0x18>
    b->next = bcache.head.next;
    80003382:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003384:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003386:	00005a17          	auipc	s4,0x5
    8000338a:	2b2a0a13          	addi	s4,s4,690 # 80008638 <syscalls+0xd0>
    b->next = bcache.head.next;
    8000338e:	2b893783          	ld	a5,696(s2)
    80003392:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003394:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003398:	85d2                	mv	a1,s4
    8000339a:	01048513          	addi	a0,s1,16
    8000339e:	00001097          	auipc	ra,0x1
    800033a2:	4bc080e7          	jalr	1212(ra) # 8000485a <initsleeplock>
    bcache.head.next->prev = b;
    800033a6:	2b893783          	ld	a5,696(s2)
    800033aa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033ac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033b0:	45848493          	addi	s1,s1,1112
    800033b4:	fd349de3          	bne	s1,s3,8000338e <binit+0x54>
  }
}
    800033b8:	70a2                	ld	ra,40(sp)
    800033ba:	7402                	ld	s0,32(sp)
    800033bc:	64e2                	ld	s1,24(sp)
    800033be:	6942                	ld	s2,16(sp)
    800033c0:	69a2                	ld	s3,8(sp)
    800033c2:	6a02                	ld	s4,0(sp)
    800033c4:	6145                	addi	sp,sp,48
    800033c6:	8082                	ret

00000000800033c8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033c8:	7179                	addi	sp,sp,-48
    800033ca:	f406                	sd	ra,40(sp)
    800033cc:	f022                	sd	s0,32(sp)
    800033ce:	ec26                	sd	s1,24(sp)
    800033d0:	e84a                	sd	s2,16(sp)
    800033d2:	e44e                	sd	s3,8(sp)
    800033d4:	1800                	addi	s0,sp,48
    800033d6:	892a                	mv	s2,a0
    800033d8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033da:	00014517          	auipc	a0,0x14
    800033de:	70e50513          	addi	a0,a0,1806 # 80017ae8 <bcache>
    800033e2:	ffffe097          	auipc	ra,0xffffe
    800033e6:	858080e7          	jalr	-1960(ra) # 80000c3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033ea:	0001d497          	auipc	s1,0x1d
    800033ee:	9b64b483          	ld	s1,-1610(s1) # 8001fda0 <bcache+0x82b8>
    800033f2:	0001d797          	auipc	a5,0x1d
    800033f6:	95e78793          	addi	a5,a5,-1698 # 8001fd50 <bcache+0x8268>
    800033fa:	02f48f63          	beq	s1,a5,80003438 <bread+0x70>
    800033fe:	873e                	mv	a4,a5
    80003400:	a021                	j	80003408 <bread+0x40>
    80003402:	68a4                	ld	s1,80(s1)
    80003404:	02e48a63          	beq	s1,a4,80003438 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003408:	449c                	lw	a5,8(s1)
    8000340a:	ff279ce3          	bne	a5,s2,80003402 <bread+0x3a>
    8000340e:	44dc                	lw	a5,12(s1)
    80003410:	ff3799e3          	bne	a5,s3,80003402 <bread+0x3a>
      b->refcnt++;
    80003414:	40bc                	lw	a5,64(s1)
    80003416:	2785                	addiw	a5,a5,1
    80003418:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000341a:	00014517          	auipc	a0,0x14
    8000341e:	6ce50513          	addi	a0,a0,1742 # 80017ae8 <bcache>
    80003422:	ffffe097          	auipc	ra,0xffffe
    80003426:	8cc080e7          	jalr	-1844(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    8000342a:	01048513          	addi	a0,s1,16
    8000342e:	00001097          	auipc	ra,0x1
    80003432:	466080e7          	jalr	1126(ra) # 80004894 <acquiresleep>
      return b;
    80003436:	a8b9                	j	80003494 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003438:	0001d497          	auipc	s1,0x1d
    8000343c:	9604b483          	ld	s1,-1696(s1) # 8001fd98 <bcache+0x82b0>
    80003440:	0001d797          	auipc	a5,0x1d
    80003444:	91078793          	addi	a5,a5,-1776 # 8001fd50 <bcache+0x8268>
    80003448:	00f48863          	beq	s1,a5,80003458 <bread+0x90>
    8000344c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000344e:	40bc                	lw	a5,64(s1)
    80003450:	cf81                	beqz	a5,80003468 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003452:	64a4                	ld	s1,72(s1)
    80003454:	fee49de3          	bne	s1,a4,8000344e <bread+0x86>
  panic("bget: no buffers");
    80003458:	00005517          	auipc	a0,0x5
    8000345c:	1e850513          	addi	a0,a0,488 # 80008640 <syscalls+0xd8>
    80003460:	ffffd097          	auipc	ra,0xffffd
    80003464:	16c080e7          	jalr	364(ra) # 800005cc <panic>
      b->dev = dev;
    80003468:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000346c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003470:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003474:	4785                	li	a5,1
    80003476:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003478:	00014517          	auipc	a0,0x14
    8000347c:	67050513          	addi	a0,a0,1648 # 80017ae8 <bcache>
    80003480:	ffffe097          	auipc	ra,0xffffe
    80003484:	86e080e7          	jalr	-1938(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    80003488:	01048513          	addi	a0,s1,16
    8000348c:	00001097          	auipc	ra,0x1
    80003490:	408080e7          	jalr	1032(ra) # 80004894 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003494:	409c                	lw	a5,0(s1)
    80003496:	cb89                	beqz	a5,800034a8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003498:	8526                	mv	a0,s1
    8000349a:	70a2                	ld	ra,40(sp)
    8000349c:	7402                	ld	s0,32(sp)
    8000349e:	64e2                	ld	s1,24(sp)
    800034a0:	6942                	ld	s2,16(sp)
    800034a2:	69a2                	ld	s3,8(sp)
    800034a4:	6145                	addi	sp,sp,48
    800034a6:	8082                	ret
    virtio_disk_rw(b, 0);
    800034a8:	4581                	li	a1,0
    800034aa:	8526                	mv	a0,s1
    800034ac:	00003097          	auipc	ra,0x3
    800034b0:	f5a080e7          	jalr	-166(ra) # 80006406 <virtio_disk_rw>
    b->valid = 1;
    800034b4:	4785                	li	a5,1
    800034b6:	c09c                	sw	a5,0(s1)
  return b;
    800034b8:	b7c5                	j	80003498 <bread+0xd0>

00000000800034ba <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800034ba:	1101                	addi	sp,sp,-32
    800034bc:	ec06                	sd	ra,24(sp)
    800034be:	e822                	sd	s0,16(sp)
    800034c0:	e426                	sd	s1,8(sp)
    800034c2:	1000                	addi	s0,sp,32
    800034c4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034c6:	0541                	addi	a0,a0,16
    800034c8:	00001097          	auipc	ra,0x1
    800034cc:	466080e7          	jalr	1126(ra) # 8000492e <holdingsleep>
    800034d0:	cd01                	beqz	a0,800034e8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034d2:	4585                	li	a1,1
    800034d4:	8526                	mv	a0,s1
    800034d6:	00003097          	auipc	ra,0x3
    800034da:	f30080e7          	jalr	-208(ra) # 80006406 <virtio_disk_rw>
}
    800034de:	60e2                	ld	ra,24(sp)
    800034e0:	6442                	ld	s0,16(sp)
    800034e2:	64a2                	ld	s1,8(sp)
    800034e4:	6105                	addi	sp,sp,32
    800034e6:	8082                	ret
    panic("bwrite");
    800034e8:	00005517          	auipc	a0,0x5
    800034ec:	17050513          	addi	a0,a0,368 # 80008658 <syscalls+0xf0>
    800034f0:	ffffd097          	auipc	ra,0xffffd
    800034f4:	0dc080e7          	jalr	220(ra) # 800005cc <panic>

00000000800034f8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800034f8:	1101                	addi	sp,sp,-32
    800034fa:	ec06                	sd	ra,24(sp)
    800034fc:	e822                	sd	s0,16(sp)
    800034fe:	e426                	sd	s1,8(sp)
    80003500:	e04a                	sd	s2,0(sp)
    80003502:	1000                	addi	s0,sp,32
    80003504:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003506:	01050913          	addi	s2,a0,16
    8000350a:	854a                	mv	a0,s2
    8000350c:	00001097          	auipc	ra,0x1
    80003510:	422080e7          	jalr	1058(ra) # 8000492e <holdingsleep>
    80003514:	c92d                	beqz	a0,80003586 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003516:	854a                	mv	a0,s2
    80003518:	00001097          	auipc	ra,0x1
    8000351c:	3d2080e7          	jalr	978(ra) # 800048ea <releasesleep>

  acquire(&bcache.lock);
    80003520:	00014517          	auipc	a0,0x14
    80003524:	5c850513          	addi	a0,a0,1480 # 80017ae8 <bcache>
    80003528:	ffffd097          	auipc	ra,0xffffd
    8000352c:	712080e7          	jalr	1810(ra) # 80000c3a <acquire>
  b->refcnt--;
    80003530:	40bc                	lw	a5,64(s1)
    80003532:	37fd                	addiw	a5,a5,-1
    80003534:	0007871b          	sext.w	a4,a5
    80003538:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000353a:	eb05                	bnez	a4,8000356a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000353c:	68bc                	ld	a5,80(s1)
    8000353e:	64b8                	ld	a4,72(s1)
    80003540:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003542:	64bc                	ld	a5,72(s1)
    80003544:	68b8                	ld	a4,80(s1)
    80003546:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003548:	0001c797          	auipc	a5,0x1c
    8000354c:	5a078793          	addi	a5,a5,1440 # 8001fae8 <bcache+0x8000>
    80003550:	2b87b703          	ld	a4,696(a5)
    80003554:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003556:	0001c717          	auipc	a4,0x1c
    8000355a:	7fa70713          	addi	a4,a4,2042 # 8001fd50 <bcache+0x8268>
    8000355e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003560:	2b87b703          	ld	a4,696(a5)
    80003564:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003566:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000356a:	00014517          	auipc	a0,0x14
    8000356e:	57e50513          	addi	a0,a0,1406 # 80017ae8 <bcache>
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	77c080e7          	jalr	1916(ra) # 80000cee <release>
}
    8000357a:	60e2                	ld	ra,24(sp)
    8000357c:	6442                	ld	s0,16(sp)
    8000357e:	64a2                	ld	s1,8(sp)
    80003580:	6902                	ld	s2,0(sp)
    80003582:	6105                	addi	sp,sp,32
    80003584:	8082                	ret
    panic("brelse");
    80003586:	00005517          	auipc	a0,0x5
    8000358a:	0da50513          	addi	a0,a0,218 # 80008660 <syscalls+0xf8>
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	03e080e7          	jalr	62(ra) # 800005cc <panic>

0000000080003596 <bpin>:

void
bpin(struct buf *b) {
    80003596:	1101                	addi	sp,sp,-32
    80003598:	ec06                	sd	ra,24(sp)
    8000359a:	e822                	sd	s0,16(sp)
    8000359c:	e426                	sd	s1,8(sp)
    8000359e:	1000                	addi	s0,sp,32
    800035a0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035a2:	00014517          	auipc	a0,0x14
    800035a6:	54650513          	addi	a0,a0,1350 # 80017ae8 <bcache>
    800035aa:	ffffd097          	auipc	ra,0xffffd
    800035ae:	690080e7          	jalr	1680(ra) # 80000c3a <acquire>
  b->refcnt++;
    800035b2:	40bc                	lw	a5,64(s1)
    800035b4:	2785                	addiw	a5,a5,1
    800035b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035b8:	00014517          	auipc	a0,0x14
    800035bc:	53050513          	addi	a0,a0,1328 # 80017ae8 <bcache>
    800035c0:	ffffd097          	auipc	ra,0xffffd
    800035c4:	72e080e7          	jalr	1838(ra) # 80000cee <release>
}
    800035c8:	60e2                	ld	ra,24(sp)
    800035ca:	6442                	ld	s0,16(sp)
    800035cc:	64a2                	ld	s1,8(sp)
    800035ce:	6105                	addi	sp,sp,32
    800035d0:	8082                	ret

00000000800035d2 <bunpin>:

void
bunpin(struct buf *b) {
    800035d2:	1101                	addi	sp,sp,-32
    800035d4:	ec06                	sd	ra,24(sp)
    800035d6:	e822                	sd	s0,16(sp)
    800035d8:	e426                	sd	s1,8(sp)
    800035da:	1000                	addi	s0,sp,32
    800035dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035de:	00014517          	auipc	a0,0x14
    800035e2:	50a50513          	addi	a0,a0,1290 # 80017ae8 <bcache>
    800035e6:	ffffd097          	auipc	ra,0xffffd
    800035ea:	654080e7          	jalr	1620(ra) # 80000c3a <acquire>
  b->refcnt--;
    800035ee:	40bc                	lw	a5,64(s1)
    800035f0:	37fd                	addiw	a5,a5,-1
    800035f2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035f4:	00014517          	auipc	a0,0x14
    800035f8:	4f450513          	addi	a0,a0,1268 # 80017ae8 <bcache>
    800035fc:	ffffd097          	auipc	ra,0xffffd
    80003600:	6f2080e7          	jalr	1778(ra) # 80000cee <release>
}
    80003604:	60e2                	ld	ra,24(sp)
    80003606:	6442                	ld	s0,16(sp)
    80003608:	64a2                	ld	s1,8(sp)
    8000360a:	6105                	addi	sp,sp,32
    8000360c:	8082                	ret

000000008000360e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000360e:	1101                	addi	sp,sp,-32
    80003610:	ec06                	sd	ra,24(sp)
    80003612:	e822                	sd	s0,16(sp)
    80003614:	e426                	sd	s1,8(sp)
    80003616:	e04a                	sd	s2,0(sp)
    80003618:	1000                	addi	s0,sp,32
    8000361a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000361c:	00d5d59b          	srliw	a1,a1,0xd
    80003620:	0001d797          	auipc	a5,0x1d
    80003624:	ba47a783          	lw	a5,-1116(a5) # 800201c4 <sb+0x1c>
    80003628:	9dbd                	addw	a1,a1,a5
    8000362a:	00000097          	auipc	ra,0x0
    8000362e:	d9e080e7          	jalr	-610(ra) # 800033c8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003632:	0074f713          	andi	a4,s1,7
    80003636:	4785                	li	a5,1
    80003638:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000363c:	14ce                	slli	s1,s1,0x33
    8000363e:	90d9                	srli	s1,s1,0x36
    80003640:	00950733          	add	a4,a0,s1
    80003644:	05874703          	lbu	a4,88(a4)
    80003648:	00e7f6b3          	and	a3,a5,a4
    8000364c:	c69d                	beqz	a3,8000367a <bfree+0x6c>
    8000364e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003650:	94aa                	add	s1,s1,a0
    80003652:	fff7c793          	not	a5,a5
    80003656:	8ff9                	and	a5,a5,a4
    80003658:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000365c:	00001097          	auipc	ra,0x1
    80003660:	118080e7          	jalr	280(ra) # 80004774 <log_write>
  brelse(bp);
    80003664:	854a                	mv	a0,s2
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	e92080e7          	jalr	-366(ra) # 800034f8 <brelse>
}
    8000366e:	60e2                	ld	ra,24(sp)
    80003670:	6442                	ld	s0,16(sp)
    80003672:	64a2                	ld	s1,8(sp)
    80003674:	6902                	ld	s2,0(sp)
    80003676:	6105                	addi	sp,sp,32
    80003678:	8082                	ret
    panic("freeing free block");
    8000367a:	00005517          	auipc	a0,0x5
    8000367e:	fee50513          	addi	a0,a0,-18 # 80008668 <syscalls+0x100>
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	f4a080e7          	jalr	-182(ra) # 800005cc <panic>

000000008000368a <balloc>:
{
    8000368a:	711d                	addi	sp,sp,-96
    8000368c:	ec86                	sd	ra,88(sp)
    8000368e:	e8a2                	sd	s0,80(sp)
    80003690:	e4a6                	sd	s1,72(sp)
    80003692:	e0ca                	sd	s2,64(sp)
    80003694:	fc4e                	sd	s3,56(sp)
    80003696:	f852                	sd	s4,48(sp)
    80003698:	f456                	sd	s5,40(sp)
    8000369a:	f05a                	sd	s6,32(sp)
    8000369c:	ec5e                	sd	s7,24(sp)
    8000369e:	e862                	sd	s8,16(sp)
    800036a0:	e466                	sd	s9,8(sp)
    800036a2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800036a4:	0001d797          	auipc	a5,0x1d
    800036a8:	b087a783          	lw	a5,-1272(a5) # 800201ac <sb+0x4>
    800036ac:	cbd1                	beqz	a5,80003740 <balloc+0xb6>
    800036ae:	8baa                	mv	s7,a0
    800036b0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800036b2:	0001db17          	auipc	s6,0x1d
    800036b6:	af6b0b13          	addi	s6,s6,-1290 # 800201a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036ba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036bc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036be:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036c0:	6c89                	lui	s9,0x2
    800036c2:	a831                	j	800036de <balloc+0x54>
    brelse(bp);
    800036c4:	854a                	mv	a0,s2
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	e32080e7          	jalr	-462(ra) # 800034f8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800036ce:	015c87bb          	addw	a5,s9,s5
    800036d2:	00078a9b          	sext.w	s5,a5
    800036d6:	004b2703          	lw	a4,4(s6)
    800036da:	06eaf363          	bgeu	s5,a4,80003740 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800036de:	41fad79b          	sraiw	a5,s5,0x1f
    800036e2:	0137d79b          	srliw	a5,a5,0x13
    800036e6:	015787bb          	addw	a5,a5,s5
    800036ea:	40d7d79b          	sraiw	a5,a5,0xd
    800036ee:	01cb2583          	lw	a1,28(s6)
    800036f2:	9dbd                	addw	a1,a1,a5
    800036f4:	855e                	mv	a0,s7
    800036f6:	00000097          	auipc	ra,0x0
    800036fa:	cd2080e7          	jalr	-814(ra) # 800033c8 <bread>
    800036fe:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003700:	004b2503          	lw	a0,4(s6)
    80003704:	000a849b          	sext.w	s1,s5
    80003708:	8662                	mv	a2,s8
    8000370a:	faa4fde3          	bgeu	s1,a0,800036c4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000370e:	41f6579b          	sraiw	a5,a2,0x1f
    80003712:	01d7d69b          	srliw	a3,a5,0x1d
    80003716:	00c6873b          	addw	a4,a3,a2
    8000371a:	00777793          	andi	a5,a4,7
    8000371e:	9f95                	subw	a5,a5,a3
    80003720:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003724:	4037571b          	sraiw	a4,a4,0x3
    80003728:	00e906b3          	add	a3,s2,a4
    8000372c:	0586c683          	lbu	a3,88(a3)
    80003730:	00d7f5b3          	and	a1,a5,a3
    80003734:	cd91                	beqz	a1,80003750 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003736:	2605                	addiw	a2,a2,1
    80003738:	2485                	addiw	s1,s1,1
    8000373a:	fd4618e3          	bne	a2,s4,8000370a <balloc+0x80>
    8000373e:	b759                	j	800036c4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003740:	00005517          	auipc	a0,0x5
    80003744:	f4050513          	addi	a0,a0,-192 # 80008680 <syscalls+0x118>
    80003748:	ffffd097          	auipc	ra,0xffffd
    8000374c:	e84080e7          	jalr	-380(ra) # 800005cc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003750:	974a                	add	a4,a4,s2
    80003752:	8fd5                	or	a5,a5,a3
    80003754:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003758:	854a                	mv	a0,s2
    8000375a:	00001097          	auipc	ra,0x1
    8000375e:	01a080e7          	jalr	26(ra) # 80004774 <log_write>
        brelse(bp);
    80003762:	854a                	mv	a0,s2
    80003764:	00000097          	auipc	ra,0x0
    80003768:	d94080e7          	jalr	-620(ra) # 800034f8 <brelse>
  bp = bread(dev, bno);
    8000376c:	85a6                	mv	a1,s1
    8000376e:	855e                	mv	a0,s7
    80003770:	00000097          	auipc	ra,0x0
    80003774:	c58080e7          	jalr	-936(ra) # 800033c8 <bread>
    80003778:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000377a:	40000613          	li	a2,1024
    8000377e:	4581                	li	a1,0
    80003780:	05850513          	addi	a0,a0,88
    80003784:	ffffd097          	auipc	ra,0xffffd
    80003788:	5b2080e7          	jalr	1458(ra) # 80000d36 <memset>
  log_write(bp);
    8000378c:	854a                	mv	a0,s2
    8000378e:	00001097          	auipc	ra,0x1
    80003792:	fe6080e7          	jalr	-26(ra) # 80004774 <log_write>
  brelse(bp);
    80003796:	854a                	mv	a0,s2
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	d60080e7          	jalr	-672(ra) # 800034f8 <brelse>
}
    800037a0:	8526                	mv	a0,s1
    800037a2:	60e6                	ld	ra,88(sp)
    800037a4:	6446                	ld	s0,80(sp)
    800037a6:	64a6                	ld	s1,72(sp)
    800037a8:	6906                	ld	s2,64(sp)
    800037aa:	79e2                	ld	s3,56(sp)
    800037ac:	7a42                	ld	s4,48(sp)
    800037ae:	7aa2                	ld	s5,40(sp)
    800037b0:	7b02                	ld	s6,32(sp)
    800037b2:	6be2                	ld	s7,24(sp)
    800037b4:	6c42                	ld	s8,16(sp)
    800037b6:	6ca2                	ld	s9,8(sp)
    800037b8:	6125                	addi	sp,sp,96
    800037ba:	8082                	ret

00000000800037bc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800037bc:	7179                	addi	sp,sp,-48
    800037be:	f406                	sd	ra,40(sp)
    800037c0:	f022                	sd	s0,32(sp)
    800037c2:	ec26                	sd	s1,24(sp)
    800037c4:	e84a                	sd	s2,16(sp)
    800037c6:	e44e                	sd	s3,8(sp)
    800037c8:	e052                	sd	s4,0(sp)
    800037ca:	1800                	addi	s0,sp,48
    800037cc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037ce:	47ad                	li	a5,11
    800037d0:	04b7fe63          	bgeu	a5,a1,8000382c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800037d4:	ff45849b          	addiw	s1,a1,-12
    800037d8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800037dc:	0ff00793          	li	a5,255
    800037e0:	0ae7e363          	bltu	a5,a4,80003886 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800037e4:	08052583          	lw	a1,128(a0)
    800037e8:	c5ad                	beqz	a1,80003852 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800037ea:	00092503          	lw	a0,0(s2)
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	bda080e7          	jalr	-1062(ra) # 800033c8 <bread>
    800037f6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800037f8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800037fc:	02049593          	slli	a1,s1,0x20
    80003800:	9181                	srli	a1,a1,0x20
    80003802:	058a                	slli	a1,a1,0x2
    80003804:	00b784b3          	add	s1,a5,a1
    80003808:	0004a983          	lw	s3,0(s1)
    8000380c:	04098d63          	beqz	s3,80003866 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003810:	8552                	mv	a0,s4
    80003812:	00000097          	auipc	ra,0x0
    80003816:	ce6080e7          	jalr	-794(ra) # 800034f8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000381a:	854e                	mv	a0,s3
    8000381c:	70a2                	ld	ra,40(sp)
    8000381e:	7402                	ld	s0,32(sp)
    80003820:	64e2                	ld	s1,24(sp)
    80003822:	6942                	ld	s2,16(sp)
    80003824:	69a2                	ld	s3,8(sp)
    80003826:	6a02                	ld	s4,0(sp)
    80003828:	6145                	addi	sp,sp,48
    8000382a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000382c:	02059493          	slli	s1,a1,0x20
    80003830:	9081                	srli	s1,s1,0x20
    80003832:	048a                	slli	s1,s1,0x2
    80003834:	94aa                	add	s1,s1,a0
    80003836:	0504a983          	lw	s3,80(s1)
    8000383a:	fe0990e3          	bnez	s3,8000381a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000383e:	4108                	lw	a0,0(a0)
    80003840:	00000097          	auipc	ra,0x0
    80003844:	e4a080e7          	jalr	-438(ra) # 8000368a <balloc>
    80003848:	0005099b          	sext.w	s3,a0
    8000384c:	0534a823          	sw	s3,80(s1)
    80003850:	b7e9                	j	8000381a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003852:	4108                	lw	a0,0(a0)
    80003854:	00000097          	auipc	ra,0x0
    80003858:	e36080e7          	jalr	-458(ra) # 8000368a <balloc>
    8000385c:	0005059b          	sext.w	a1,a0
    80003860:	08b92023          	sw	a1,128(s2)
    80003864:	b759                	j	800037ea <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003866:	00092503          	lw	a0,0(s2)
    8000386a:	00000097          	auipc	ra,0x0
    8000386e:	e20080e7          	jalr	-480(ra) # 8000368a <balloc>
    80003872:	0005099b          	sext.w	s3,a0
    80003876:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000387a:	8552                	mv	a0,s4
    8000387c:	00001097          	auipc	ra,0x1
    80003880:	ef8080e7          	jalr	-264(ra) # 80004774 <log_write>
    80003884:	b771                	j	80003810 <bmap+0x54>
  panic("bmap: out of range");
    80003886:	00005517          	auipc	a0,0x5
    8000388a:	e1250513          	addi	a0,a0,-494 # 80008698 <syscalls+0x130>
    8000388e:	ffffd097          	auipc	ra,0xffffd
    80003892:	d3e080e7          	jalr	-706(ra) # 800005cc <panic>

0000000080003896 <iget>:
{
    80003896:	7179                	addi	sp,sp,-48
    80003898:	f406                	sd	ra,40(sp)
    8000389a:	f022                	sd	s0,32(sp)
    8000389c:	ec26                	sd	s1,24(sp)
    8000389e:	e84a                	sd	s2,16(sp)
    800038a0:	e44e                	sd	s3,8(sp)
    800038a2:	e052                	sd	s4,0(sp)
    800038a4:	1800                	addi	s0,sp,48
    800038a6:	89aa                	mv	s3,a0
    800038a8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800038aa:	0001d517          	auipc	a0,0x1d
    800038ae:	91e50513          	addi	a0,a0,-1762 # 800201c8 <itable>
    800038b2:	ffffd097          	auipc	ra,0xffffd
    800038b6:	388080e7          	jalr	904(ra) # 80000c3a <acquire>
  empty = 0;
    800038ba:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038bc:	0001d497          	auipc	s1,0x1d
    800038c0:	92448493          	addi	s1,s1,-1756 # 800201e0 <itable+0x18>
    800038c4:	0001e697          	auipc	a3,0x1e
    800038c8:	3ac68693          	addi	a3,a3,940 # 80021c70 <log>
    800038cc:	a039                	j	800038da <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038ce:	02090b63          	beqz	s2,80003904 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038d2:	08848493          	addi	s1,s1,136
    800038d6:	02d48a63          	beq	s1,a3,8000390a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800038da:	449c                	lw	a5,8(s1)
    800038dc:	fef059e3          	blez	a5,800038ce <iget+0x38>
    800038e0:	4098                	lw	a4,0(s1)
    800038e2:	ff3716e3          	bne	a4,s3,800038ce <iget+0x38>
    800038e6:	40d8                	lw	a4,4(s1)
    800038e8:	ff4713e3          	bne	a4,s4,800038ce <iget+0x38>
      ip->ref++;
    800038ec:	2785                	addiw	a5,a5,1
    800038ee:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800038f0:	0001d517          	auipc	a0,0x1d
    800038f4:	8d850513          	addi	a0,a0,-1832 # 800201c8 <itable>
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	3f6080e7          	jalr	1014(ra) # 80000cee <release>
      return ip;
    80003900:	8926                	mv	s2,s1
    80003902:	a03d                	j	80003930 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003904:	f7f9                	bnez	a5,800038d2 <iget+0x3c>
    80003906:	8926                	mv	s2,s1
    80003908:	b7e9                	j	800038d2 <iget+0x3c>
  if(empty == 0)
    8000390a:	02090c63          	beqz	s2,80003942 <iget+0xac>
  ip->dev = dev;
    8000390e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003912:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003916:	4785                	li	a5,1
    80003918:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000391c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003920:	0001d517          	auipc	a0,0x1d
    80003924:	8a850513          	addi	a0,a0,-1880 # 800201c8 <itable>
    80003928:	ffffd097          	auipc	ra,0xffffd
    8000392c:	3c6080e7          	jalr	966(ra) # 80000cee <release>
}
    80003930:	854a                	mv	a0,s2
    80003932:	70a2                	ld	ra,40(sp)
    80003934:	7402                	ld	s0,32(sp)
    80003936:	64e2                	ld	s1,24(sp)
    80003938:	6942                	ld	s2,16(sp)
    8000393a:	69a2                	ld	s3,8(sp)
    8000393c:	6a02                	ld	s4,0(sp)
    8000393e:	6145                	addi	sp,sp,48
    80003940:	8082                	ret
    panic("iget: no inodes");
    80003942:	00005517          	auipc	a0,0x5
    80003946:	d6e50513          	addi	a0,a0,-658 # 800086b0 <syscalls+0x148>
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	c82080e7          	jalr	-894(ra) # 800005cc <panic>

0000000080003952 <fsinit>:
fsinit(int dev) {
    80003952:	7179                	addi	sp,sp,-48
    80003954:	f406                	sd	ra,40(sp)
    80003956:	f022                	sd	s0,32(sp)
    80003958:	ec26                	sd	s1,24(sp)
    8000395a:	e84a                	sd	s2,16(sp)
    8000395c:	e44e                	sd	s3,8(sp)
    8000395e:	1800                	addi	s0,sp,48
    80003960:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003962:	4585                	li	a1,1
    80003964:	00000097          	auipc	ra,0x0
    80003968:	a64080e7          	jalr	-1436(ra) # 800033c8 <bread>
    8000396c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000396e:	0001d997          	auipc	s3,0x1d
    80003972:	83a98993          	addi	s3,s3,-1990 # 800201a8 <sb>
    80003976:	02000613          	li	a2,32
    8000397a:	05850593          	addi	a1,a0,88
    8000397e:	854e                	mv	a0,s3
    80003980:	ffffd097          	auipc	ra,0xffffd
    80003984:	412080e7          	jalr	1042(ra) # 80000d92 <memmove>
  brelse(bp);
    80003988:	8526                	mv	a0,s1
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	b6e080e7          	jalr	-1170(ra) # 800034f8 <brelse>
  if(sb.magic != FSMAGIC)
    80003992:	0009a703          	lw	a4,0(s3)
    80003996:	102037b7          	lui	a5,0x10203
    8000399a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000399e:	02f71263          	bne	a4,a5,800039c2 <fsinit+0x70>
  initlog(dev, &sb);
    800039a2:	0001d597          	auipc	a1,0x1d
    800039a6:	80658593          	addi	a1,a1,-2042 # 800201a8 <sb>
    800039aa:	854a                	mv	a0,s2
    800039ac:	00001097          	auipc	ra,0x1
    800039b0:	b4c080e7          	jalr	-1204(ra) # 800044f8 <initlog>
}
    800039b4:	70a2                	ld	ra,40(sp)
    800039b6:	7402                	ld	s0,32(sp)
    800039b8:	64e2                	ld	s1,24(sp)
    800039ba:	6942                	ld	s2,16(sp)
    800039bc:	69a2                	ld	s3,8(sp)
    800039be:	6145                	addi	sp,sp,48
    800039c0:	8082                	ret
    panic("invalid file system");
    800039c2:	00005517          	auipc	a0,0x5
    800039c6:	cfe50513          	addi	a0,a0,-770 # 800086c0 <syscalls+0x158>
    800039ca:	ffffd097          	auipc	ra,0xffffd
    800039ce:	c02080e7          	jalr	-1022(ra) # 800005cc <panic>

00000000800039d2 <iinit>:
{
    800039d2:	7179                	addi	sp,sp,-48
    800039d4:	f406                	sd	ra,40(sp)
    800039d6:	f022                	sd	s0,32(sp)
    800039d8:	ec26                	sd	s1,24(sp)
    800039da:	e84a                	sd	s2,16(sp)
    800039dc:	e44e                	sd	s3,8(sp)
    800039de:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800039e0:	00005597          	auipc	a1,0x5
    800039e4:	cf858593          	addi	a1,a1,-776 # 800086d8 <syscalls+0x170>
    800039e8:	0001c517          	auipc	a0,0x1c
    800039ec:	7e050513          	addi	a0,a0,2016 # 800201c8 <itable>
    800039f0:	ffffd097          	auipc	ra,0xffffd
    800039f4:	1ba080e7          	jalr	442(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    800039f8:	0001c497          	auipc	s1,0x1c
    800039fc:	7f848493          	addi	s1,s1,2040 # 800201f0 <itable+0x28>
    80003a00:	0001e997          	auipc	s3,0x1e
    80003a04:	28098993          	addi	s3,s3,640 # 80021c80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a08:	00005917          	auipc	s2,0x5
    80003a0c:	cd890913          	addi	s2,s2,-808 # 800086e0 <syscalls+0x178>
    80003a10:	85ca                	mv	a1,s2
    80003a12:	8526                	mv	a0,s1
    80003a14:	00001097          	auipc	ra,0x1
    80003a18:	e46080e7          	jalr	-442(ra) # 8000485a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a1c:	08848493          	addi	s1,s1,136
    80003a20:	ff3498e3          	bne	s1,s3,80003a10 <iinit+0x3e>
}
    80003a24:	70a2                	ld	ra,40(sp)
    80003a26:	7402                	ld	s0,32(sp)
    80003a28:	64e2                	ld	s1,24(sp)
    80003a2a:	6942                	ld	s2,16(sp)
    80003a2c:	69a2                	ld	s3,8(sp)
    80003a2e:	6145                	addi	sp,sp,48
    80003a30:	8082                	ret

0000000080003a32 <ialloc>:
{
    80003a32:	715d                	addi	sp,sp,-80
    80003a34:	e486                	sd	ra,72(sp)
    80003a36:	e0a2                	sd	s0,64(sp)
    80003a38:	fc26                	sd	s1,56(sp)
    80003a3a:	f84a                	sd	s2,48(sp)
    80003a3c:	f44e                	sd	s3,40(sp)
    80003a3e:	f052                	sd	s4,32(sp)
    80003a40:	ec56                	sd	s5,24(sp)
    80003a42:	e85a                	sd	s6,16(sp)
    80003a44:	e45e                	sd	s7,8(sp)
    80003a46:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a48:	0001c717          	auipc	a4,0x1c
    80003a4c:	76c72703          	lw	a4,1900(a4) # 800201b4 <sb+0xc>
    80003a50:	4785                	li	a5,1
    80003a52:	04e7fa63          	bgeu	a5,a4,80003aa6 <ialloc+0x74>
    80003a56:	8aaa                	mv	s5,a0
    80003a58:	8bae                	mv	s7,a1
    80003a5a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a5c:	0001ca17          	auipc	s4,0x1c
    80003a60:	74ca0a13          	addi	s4,s4,1868 # 800201a8 <sb>
    80003a64:	00048b1b          	sext.w	s6,s1
    80003a68:	0044d793          	srli	a5,s1,0x4
    80003a6c:	018a2583          	lw	a1,24(s4)
    80003a70:	9dbd                	addw	a1,a1,a5
    80003a72:	8556                	mv	a0,s5
    80003a74:	00000097          	auipc	ra,0x0
    80003a78:	954080e7          	jalr	-1708(ra) # 800033c8 <bread>
    80003a7c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a7e:	05850993          	addi	s3,a0,88
    80003a82:	00f4f793          	andi	a5,s1,15
    80003a86:	079a                	slli	a5,a5,0x6
    80003a88:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003a8a:	00099783          	lh	a5,0(s3)
    80003a8e:	c785                	beqz	a5,80003ab6 <ialloc+0x84>
    brelse(bp);
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	a68080e7          	jalr	-1432(ra) # 800034f8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a98:	0485                	addi	s1,s1,1
    80003a9a:	00ca2703          	lw	a4,12(s4)
    80003a9e:	0004879b          	sext.w	a5,s1
    80003aa2:	fce7e1e3          	bltu	a5,a4,80003a64 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003aa6:	00005517          	auipc	a0,0x5
    80003aaa:	c4250513          	addi	a0,a0,-958 # 800086e8 <syscalls+0x180>
    80003aae:	ffffd097          	auipc	ra,0xffffd
    80003ab2:	b1e080e7          	jalr	-1250(ra) # 800005cc <panic>
      memset(dip, 0, sizeof(*dip));
    80003ab6:	04000613          	li	a2,64
    80003aba:	4581                	li	a1,0
    80003abc:	854e                	mv	a0,s3
    80003abe:	ffffd097          	auipc	ra,0xffffd
    80003ac2:	278080e7          	jalr	632(ra) # 80000d36 <memset>
      dip->type = type;
    80003ac6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003aca:	854a                	mv	a0,s2
    80003acc:	00001097          	auipc	ra,0x1
    80003ad0:	ca8080e7          	jalr	-856(ra) # 80004774 <log_write>
      brelse(bp);
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	00000097          	auipc	ra,0x0
    80003ada:	a22080e7          	jalr	-1502(ra) # 800034f8 <brelse>
      return iget(dev, inum);
    80003ade:	85da                	mv	a1,s6
    80003ae0:	8556                	mv	a0,s5
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	db4080e7          	jalr	-588(ra) # 80003896 <iget>
}
    80003aea:	60a6                	ld	ra,72(sp)
    80003aec:	6406                	ld	s0,64(sp)
    80003aee:	74e2                	ld	s1,56(sp)
    80003af0:	7942                	ld	s2,48(sp)
    80003af2:	79a2                	ld	s3,40(sp)
    80003af4:	7a02                	ld	s4,32(sp)
    80003af6:	6ae2                	ld	s5,24(sp)
    80003af8:	6b42                	ld	s6,16(sp)
    80003afa:	6ba2                	ld	s7,8(sp)
    80003afc:	6161                	addi	sp,sp,80
    80003afe:	8082                	ret

0000000080003b00 <iupdate>:
{
    80003b00:	1101                	addi	sp,sp,-32
    80003b02:	ec06                	sd	ra,24(sp)
    80003b04:	e822                	sd	s0,16(sp)
    80003b06:	e426                	sd	s1,8(sp)
    80003b08:	e04a                	sd	s2,0(sp)
    80003b0a:	1000                	addi	s0,sp,32
    80003b0c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b0e:	415c                	lw	a5,4(a0)
    80003b10:	0047d79b          	srliw	a5,a5,0x4
    80003b14:	0001c597          	auipc	a1,0x1c
    80003b18:	6ac5a583          	lw	a1,1708(a1) # 800201c0 <sb+0x18>
    80003b1c:	9dbd                	addw	a1,a1,a5
    80003b1e:	4108                	lw	a0,0(a0)
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	8a8080e7          	jalr	-1880(ra) # 800033c8 <bread>
    80003b28:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b2a:	05850793          	addi	a5,a0,88
    80003b2e:	40c8                	lw	a0,4(s1)
    80003b30:	893d                	andi	a0,a0,15
    80003b32:	051a                	slli	a0,a0,0x6
    80003b34:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003b36:	04449703          	lh	a4,68(s1)
    80003b3a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003b3e:	04649703          	lh	a4,70(s1)
    80003b42:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003b46:	04849703          	lh	a4,72(s1)
    80003b4a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003b4e:	04a49703          	lh	a4,74(s1)
    80003b52:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003b56:	44f8                	lw	a4,76(s1)
    80003b58:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b5a:	03400613          	li	a2,52
    80003b5e:	05048593          	addi	a1,s1,80
    80003b62:	0531                	addi	a0,a0,12
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	22e080e7          	jalr	558(ra) # 80000d92 <memmove>
  log_write(bp);
    80003b6c:	854a                	mv	a0,s2
    80003b6e:	00001097          	auipc	ra,0x1
    80003b72:	c06080e7          	jalr	-1018(ra) # 80004774 <log_write>
  brelse(bp);
    80003b76:	854a                	mv	a0,s2
    80003b78:	00000097          	auipc	ra,0x0
    80003b7c:	980080e7          	jalr	-1664(ra) # 800034f8 <brelse>
}
    80003b80:	60e2                	ld	ra,24(sp)
    80003b82:	6442                	ld	s0,16(sp)
    80003b84:	64a2                	ld	s1,8(sp)
    80003b86:	6902                	ld	s2,0(sp)
    80003b88:	6105                	addi	sp,sp,32
    80003b8a:	8082                	ret

0000000080003b8c <idup>:
{
    80003b8c:	1101                	addi	sp,sp,-32
    80003b8e:	ec06                	sd	ra,24(sp)
    80003b90:	e822                	sd	s0,16(sp)
    80003b92:	e426                	sd	s1,8(sp)
    80003b94:	1000                	addi	s0,sp,32
    80003b96:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b98:	0001c517          	auipc	a0,0x1c
    80003b9c:	63050513          	addi	a0,a0,1584 # 800201c8 <itable>
    80003ba0:	ffffd097          	auipc	ra,0xffffd
    80003ba4:	09a080e7          	jalr	154(ra) # 80000c3a <acquire>
  ip->ref++;
    80003ba8:	449c                	lw	a5,8(s1)
    80003baa:	2785                	addiw	a5,a5,1
    80003bac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003bae:	0001c517          	auipc	a0,0x1c
    80003bb2:	61a50513          	addi	a0,a0,1562 # 800201c8 <itable>
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	138080e7          	jalr	312(ra) # 80000cee <release>
}
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	60e2                	ld	ra,24(sp)
    80003bc2:	6442                	ld	s0,16(sp)
    80003bc4:	64a2                	ld	s1,8(sp)
    80003bc6:	6105                	addi	sp,sp,32
    80003bc8:	8082                	ret

0000000080003bca <ilock>:
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	e426                	sd	s1,8(sp)
    80003bd2:	e04a                	sd	s2,0(sp)
    80003bd4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003bd6:	c115                	beqz	a0,80003bfa <ilock+0x30>
    80003bd8:	84aa                	mv	s1,a0
    80003bda:	451c                	lw	a5,8(a0)
    80003bdc:	00f05f63          	blez	a5,80003bfa <ilock+0x30>
  acquiresleep(&ip->lock);
    80003be0:	0541                	addi	a0,a0,16
    80003be2:	00001097          	auipc	ra,0x1
    80003be6:	cb2080e7          	jalr	-846(ra) # 80004894 <acquiresleep>
  if(ip->valid == 0){
    80003bea:	40bc                	lw	a5,64(s1)
    80003bec:	cf99                	beqz	a5,80003c0a <ilock+0x40>
}
    80003bee:	60e2                	ld	ra,24(sp)
    80003bf0:	6442                	ld	s0,16(sp)
    80003bf2:	64a2                	ld	s1,8(sp)
    80003bf4:	6902                	ld	s2,0(sp)
    80003bf6:	6105                	addi	sp,sp,32
    80003bf8:	8082                	ret
    panic("ilock");
    80003bfa:	00005517          	auipc	a0,0x5
    80003bfe:	b0650513          	addi	a0,a0,-1274 # 80008700 <syscalls+0x198>
    80003c02:	ffffd097          	auipc	ra,0xffffd
    80003c06:	9ca080e7          	jalr	-1590(ra) # 800005cc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c0a:	40dc                	lw	a5,4(s1)
    80003c0c:	0047d79b          	srliw	a5,a5,0x4
    80003c10:	0001c597          	auipc	a1,0x1c
    80003c14:	5b05a583          	lw	a1,1456(a1) # 800201c0 <sb+0x18>
    80003c18:	9dbd                	addw	a1,a1,a5
    80003c1a:	4088                	lw	a0,0(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	7ac080e7          	jalr	1964(ra) # 800033c8 <bread>
    80003c24:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c26:	05850593          	addi	a1,a0,88
    80003c2a:	40dc                	lw	a5,4(s1)
    80003c2c:	8bbd                	andi	a5,a5,15
    80003c2e:	079a                	slli	a5,a5,0x6
    80003c30:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c32:	00059783          	lh	a5,0(a1)
    80003c36:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c3a:	00259783          	lh	a5,2(a1)
    80003c3e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c42:	00459783          	lh	a5,4(a1)
    80003c46:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c4a:	00659783          	lh	a5,6(a1)
    80003c4e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c52:	459c                	lw	a5,8(a1)
    80003c54:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c56:	03400613          	li	a2,52
    80003c5a:	05b1                	addi	a1,a1,12
    80003c5c:	05048513          	addi	a0,s1,80
    80003c60:	ffffd097          	auipc	ra,0xffffd
    80003c64:	132080e7          	jalr	306(ra) # 80000d92 <memmove>
    brelse(bp);
    80003c68:	854a                	mv	a0,s2
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	88e080e7          	jalr	-1906(ra) # 800034f8 <brelse>
    ip->valid = 1;
    80003c72:	4785                	li	a5,1
    80003c74:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c76:	04449783          	lh	a5,68(s1)
    80003c7a:	fbb5                	bnez	a5,80003bee <ilock+0x24>
      panic("ilock: no type");
    80003c7c:	00005517          	auipc	a0,0x5
    80003c80:	a8c50513          	addi	a0,a0,-1396 # 80008708 <syscalls+0x1a0>
    80003c84:	ffffd097          	auipc	ra,0xffffd
    80003c88:	948080e7          	jalr	-1720(ra) # 800005cc <panic>

0000000080003c8c <iunlock>:
{
    80003c8c:	1101                	addi	sp,sp,-32
    80003c8e:	ec06                	sd	ra,24(sp)
    80003c90:	e822                	sd	s0,16(sp)
    80003c92:	e426                	sd	s1,8(sp)
    80003c94:	e04a                	sd	s2,0(sp)
    80003c96:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c98:	c905                	beqz	a0,80003cc8 <iunlock+0x3c>
    80003c9a:	84aa                	mv	s1,a0
    80003c9c:	01050913          	addi	s2,a0,16
    80003ca0:	854a                	mv	a0,s2
    80003ca2:	00001097          	auipc	ra,0x1
    80003ca6:	c8c080e7          	jalr	-884(ra) # 8000492e <holdingsleep>
    80003caa:	cd19                	beqz	a0,80003cc8 <iunlock+0x3c>
    80003cac:	449c                	lw	a5,8(s1)
    80003cae:	00f05d63          	blez	a5,80003cc8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003cb2:	854a                	mv	a0,s2
    80003cb4:	00001097          	auipc	ra,0x1
    80003cb8:	c36080e7          	jalr	-970(ra) # 800048ea <releasesleep>
}
    80003cbc:	60e2                	ld	ra,24(sp)
    80003cbe:	6442                	ld	s0,16(sp)
    80003cc0:	64a2                	ld	s1,8(sp)
    80003cc2:	6902                	ld	s2,0(sp)
    80003cc4:	6105                	addi	sp,sp,32
    80003cc6:	8082                	ret
    panic("iunlock");
    80003cc8:	00005517          	auipc	a0,0x5
    80003ccc:	a5050513          	addi	a0,a0,-1456 # 80008718 <syscalls+0x1b0>
    80003cd0:	ffffd097          	auipc	ra,0xffffd
    80003cd4:	8fc080e7          	jalr	-1796(ra) # 800005cc <panic>

0000000080003cd8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003cd8:	7179                	addi	sp,sp,-48
    80003cda:	f406                	sd	ra,40(sp)
    80003cdc:	f022                	sd	s0,32(sp)
    80003cde:	ec26                	sd	s1,24(sp)
    80003ce0:	e84a                	sd	s2,16(sp)
    80003ce2:	e44e                	sd	s3,8(sp)
    80003ce4:	e052                	sd	s4,0(sp)
    80003ce6:	1800                	addi	s0,sp,48
    80003ce8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003cea:	05050493          	addi	s1,a0,80
    80003cee:	08050913          	addi	s2,a0,128
    80003cf2:	a021                	j	80003cfa <itrunc+0x22>
    80003cf4:	0491                	addi	s1,s1,4
    80003cf6:	01248d63          	beq	s1,s2,80003d10 <itrunc+0x38>
    if(ip->addrs[i]){
    80003cfa:	408c                	lw	a1,0(s1)
    80003cfc:	dde5                	beqz	a1,80003cf4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003cfe:	0009a503          	lw	a0,0(s3)
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	90c080e7          	jalr	-1780(ra) # 8000360e <bfree>
      ip->addrs[i] = 0;
    80003d0a:	0004a023          	sw	zero,0(s1)
    80003d0e:	b7dd                	j	80003cf4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d10:	0809a583          	lw	a1,128(s3)
    80003d14:	e185                	bnez	a1,80003d34 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d16:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d1a:	854e                	mv	a0,s3
    80003d1c:	00000097          	auipc	ra,0x0
    80003d20:	de4080e7          	jalr	-540(ra) # 80003b00 <iupdate>
}
    80003d24:	70a2                	ld	ra,40(sp)
    80003d26:	7402                	ld	s0,32(sp)
    80003d28:	64e2                	ld	s1,24(sp)
    80003d2a:	6942                	ld	s2,16(sp)
    80003d2c:	69a2                	ld	s3,8(sp)
    80003d2e:	6a02                	ld	s4,0(sp)
    80003d30:	6145                	addi	sp,sp,48
    80003d32:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d34:	0009a503          	lw	a0,0(s3)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	690080e7          	jalr	1680(ra) # 800033c8 <bread>
    80003d40:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d42:	05850493          	addi	s1,a0,88
    80003d46:	45850913          	addi	s2,a0,1112
    80003d4a:	a021                	j	80003d52 <itrunc+0x7a>
    80003d4c:	0491                	addi	s1,s1,4
    80003d4e:	01248b63          	beq	s1,s2,80003d64 <itrunc+0x8c>
      if(a[j])
    80003d52:	408c                	lw	a1,0(s1)
    80003d54:	dde5                	beqz	a1,80003d4c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003d56:	0009a503          	lw	a0,0(s3)
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	8b4080e7          	jalr	-1868(ra) # 8000360e <bfree>
    80003d62:	b7ed                	j	80003d4c <itrunc+0x74>
    brelse(bp);
    80003d64:	8552                	mv	a0,s4
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	792080e7          	jalr	1938(ra) # 800034f8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d6e:	0809a583          	lw	a1,128(s3)
    80003d72:	0009a503          	lw	a0,0(s3)
    80003d76:	00000097          	auipc	ra,0x0
    80003d7a:	898080e7          	jalr	-1896(ra) # 8000360e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d7e:	0809a023          	sw	zero,128(s3)
    80003d82:	bf51                	j	80003d16 <itrunc+0x3e>

0000000080003d84 <iput>:
{
    80003d84:	1101                	addi	sp,sp,-32
    80003d86:	ec06                	sd	ra,24(sp)
    80003d88:	e822                	sd	s0,16(sp)
    80003d8a:	e426                	sd	s1,8(sp)
    80003d8c:	e04a                	sd	s2,0(sp)
    80003d8e:	1000                	addi	s0,sp,32
    80003d90:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d92:	0001c517          	auipc	a0,0x1c
    80003d96:	43650513          	addi	a0,a0,1078 # 800201c8 <itable>
    80003d9a:	ffffd097          	auipc	ra,0xffffd
    80003d9e:	ea0080e7          	jalr	-352(ra) # 80000c3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003da2:	4498                	lw	a4,8(s1)
    80003da4:	4785                	li	a5,1
    80003da6:	02f70363          	beq	a4,a5,80003dcc <iput+0x48>
  ip->ref--;
    80003daa:	449c                	lw	a5,8(s1)
    80003dac:	37fd                	addiw	a5,a5,-1
    80003dae:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003db0:	0001c517          	auipc	a0,0x1c
    80003db4:	41850513          	addi	a0,a0,1048 # 800201c8 <itable>
    80003db8:	ffffd097          	auipc	ra,0xffffd
    80003dbc:	f36080e7          	jalr	-202(ra) # 80000cee <release>
}
    80003dc0:	60e2                	ld	ra,24(sp)
    80003dc2:	6442                	ld	s0,16(sp)
    80003dc4:	64a2                	ld	s1,8(sp)
    80003dc6:	6902                	ld	s2,0(sp)
    80003dc8:	6105                	addi	sp,sp,32
    80003dca:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003dcc:	40bc                	lw	a5,64(s1)
    80003dce:	dff1                	beqz	a5,80003daa <iput+0x26>
    80003dd0:	04a49783          	lh	a5,74(s1)
    80003dd4:	fbf9                	bnez	a5,80003daa <iput+0x26>
    acquiresleep(&ip->lock);
    80003dd6:	01048913          	addi	s2,s1,16
    80003dda:	854a                	mv	a0,s2
    80003ddc:	00001097          	auipc	ra,0x1
    80003de0:	ab8080e7          	jalr	-1352(ra) # 80004894 <acquiresleep>
    release(&itable.lock);
    80003de4:	0001c517          	auipc	a0,0x1c
    80003de8:	3e450513          	addi	a0,a0,996 # 800201c8 <itable>
    80003dec:	ffffd097          	auipc	ra,0xffffd
    80003df0:	f02080e7          	jalr	-254(ra) # 80000cee <release>
    itrunc(ip);
    80003df4:	8526                	mv	a0,s1
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	ee2080e7          	jalr	-286(ra) # 80003cd8 <itrunc>
    ip->type = 0;
    80003dfe:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e02:	8526                	mv	a0,s1
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	cfc080e7          	jalr	-772(ra) # 80003b00 <iupdate>
    ip->valid = 0;
    80003e0c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e10:	854a                	mv	a0,s2
    80003e12:	00001097          	auipc	ra,0x1
    80003e16:	ad8080e7          	jalr	-1320(ra) # 800048ea <releasesleep>
    acquire(&itable.lock);
    80003e1a:	0001c517          	auipc	a0,0x1c
    80003e1e:	3ae50513          	addi	a0,a0,942 # 800201c8 <itable>
    80003e22:	ffffd097          	auipc	ra,0xffffd
    80003e26:	e18080e7          	jalr	-488(ra) # 80000c3a <acquire>
    80003e2a:	b741                	j	80003daa <iput+0x26>

0000000080003e2c <iunlockput>:
{
    80003e2c:	1101                	addi	sp,sp,-32
    80003e2e:	ec06                	sd	ra,24(sp)
    80003e30:	e822                	sd	s0,16(sp)
    80003e32:	e426                	sd	s1,8(sp)
    80003e34:	1000                	addi	s0,sp,32
    80003e36:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e38:	00000097          	auipc	ra,0x0
    80003e3c:	e54080e7          	jalr	-428(ra) # 80003c8c <iunlock>
  iput(ip);
    80003e40:	8526                	mv	a0,s1
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	f42080e7          	jalr	-190(ra) # 80003d84 <iput>
}
    80003e4a:	60e2                	ld	ra,24(sp)
    80003e4c:	6442                	ld	s0,16(sp)
    80003e4e:	64a2                	ld	s1,8(sp)
    80003e50:	6105                	addi	sp,sp,32
    80003e52:	8082                	ret

0000000080003e54 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003e54:	1141                	addi	sp,sp,-16
    80003e56:	e422                	sd	s0,8(sp)
    80003e58:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003e5a:	411c                	lw	a5,0(a0)
    80003e5c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e5e:	415c                	lw	a5,4(a0)
    80003e60:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e62:	04451783          	lh	a5,68(a0)
    80003e66:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e6a:	04a51783          	lh	a5,74(a0)
    80003e6e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e72:	04c56783          	lwu	a5,76(a0)
    80003e76:	e99c                	sd	a5,16(a1)
}
    80003e78:	6422                	ld	s0,8(sp)
    80003e7a:	0141                	addi	sp,sp,16
    80003e7c:	8082                	ret

0000000080003e7e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e7e:	457c                	lw	a5,76(a0)
    80003e80:	0ed7e963          	bltu	a5,a3,80003f72 <readi+0xf4>
{
    80003e84:	7159                	addi	sp,sp,-112
    80003e86:	f486                	sd	ra,104(sp)
    80003e88:	f0a2                	sd	s0,96(sp)
    80003e8a:	eca6                	sd	s1,88(sp)
    80003e8c:	e8ca                	sd	s2,80(sp)
    80003e8e:	e4ce                	sd	s3,72(sp)
    80003e90:	e0d2                	sd	s4,64(sp)
    80003e92:	fc56                	sd	s5,56(sp)
    80003e94:	f85a                	sd	s6,48(sp)
    80003e96:	f45e                	sd	s7,40(sp)
    80003e98:	f062                	sd	s8,32(sp)
    80003e9a:	ec66                	sd	s9,24(sp)
    80003e9c:	e86a                	sd	s10,16(sp)
    80003e9e:	e46e                	sd	s11,8(sp)
    80003ea0:	1880                	addi	s0,sp,112
    80003ea2:	8baa                	mv	s7,a0
    80003ea4:	8c2e                	mv	s8,a1
    80003ea6:	8ab2                	mv	s5,a2
    80003ea8:	84b6                	mv	s1,a3
    80003eaa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003eac:	9f35                	addw	a4,a4,a3
    return 0;
    80003eae:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003eb0:	0ad76063          	bltu	a4,a3,80003f50 <readi+0xd2>
  if(off + n > ip->size)
    80003eb4:	00e7f463          	bgeu	a5,a4,80003ebc <readi+0x3e>
    n = ip->size - off;
    80003eb8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ebc:	0a0b0963          	beqz	s6,80003f6e <readi+0xf0>
    80003ec0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ec2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ec6:	5cfd                	li	s9,-1
    80003ec8:	a82d                	j	80003f02 <readi+0x84>
    80003eca:	020a1d93          	slli	s11,s4,0x20
    80003ece:	020ddd93          	srli	s11,s11,0x20
    80003ed2:	05890793          	addi	a5,s2,88
    80003ed6:	86ee                	mv	a3,s11
    80003ed8:	963e                	add	a2,a2,a5
    80003eda:	85d6                	mv	a1,s5
    80003edc:	8562                	mv	a0,s8
    80003ede:	fffff097          	auipc	ra,0xfffff
    80003ee2:	9e2080e7          	jalr	-1566(ra) # 800028c0 <either_copyout>
    80003ee6:	05950d63          	beq	a0,s9,80003f40 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003eea:	854a                	mv	a0,s2
    80003eec:	fffff097          	auipc	ra,0xfffff
    80003ef0:	60c080e7          	jalr	1548(ra) # 800034f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ef4:	013a09bb          	addw	s3,s4,s3
    80003ef8:	009a04bb          	addw	s1,s4,s1
    80003efc:	9aee                	add	s5,s5,s11
    80003efe:	0569f763          	bgeu	s3,s6,80003f4c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003f02:	000ba903          	lw	s2,0(s7)
    80003f06:	00a4d59b          	srliw	a1,s1,0xa
    80003f0a:	855e                	mv	a0,s7
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	8b0080e7          	jalr	-1872(ra) # 800037bc <bmap>
    80003f14:	0005059b          	sext.w	a1,a0
    80003f18:	854a                	mv	a0,s2
    80003f1a:	fffff097          	auipc	ra,0xfffff
    80003f1e:	4ae080e7          	jalr	1198(ra) # 800033c8 <bread>
    80003f22:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f24:	3ff4f613          	andi	a2,s1,1023
    80003f28:	40cd07bb          	subw	a5,s10,a2
    80003f2c:	413b073b          	subw	a4,s6,s3
    80003f30:	8a3e                	mv	s4,a5
    80003f32:	2781                	sext.w	a5,a5
    80003f34:	0007069b          	sext.w	a3,a4
    80003f38:	f8f6f9e3          	bgeu	a3,a5,80003eca <readi+0x4c>
    80003f3c:	8a3a                	mv	s4,a4
    80003f3e:	b771                	j	80003eca <readi+0x4c>
      brelse(bp);
    80003f40:	854a                	mv	a0,s2
    80003f42:	fffff097          	auipc	ra,0xfffff
    80003f46:	5b6080e7          	jalr	1462(ra) # 800034f8 <brelse>
      tot = -1;
    80003f4a:	59fd                	li	s3,-1
  }
  return tot;
    80003f4c:	0009851b          	sext.w	a0,s3
}
    80003f50:	70a6                	ld	ra,104(sp)
    80003f52:	7406                	ld	s0,96(sp)
    80003f54:	64e6                	ld	s1,88(sp)
    80003f56:	6946                	ld	s2,80(sp)
    80003f58:	69a6                	ld	s3,72(sp)
    80003f5a:	6a06                	ld	s4,64(sp)
    80003f5c:	7ae2                	ld	s5,56(sp)
    80003f5e:	7b42                	ld	s6,48(sp)
    80003f60:	7ba2                	ld	s7,40(sp)
    80003f62:	7c02                	ld	s8,32(sp)
    80003f64:	6ce2                	ld	s9,24(sp)
    80003f66:	6d42                	ld	s10,16(sp)
    80003f68:	6da2                	ld	s11,8(sp)
    80003f6a:	6165                	addi	sp,sp,112
    80003f6c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f6e:	89da                	mv	s3,s6
    80003f70:	bff1                	j	80003f4c <readi+0xce>
    return 0;
    80003f72:	4501                	li	a0,0
}
    80003f74:	8082                	ret

0000000080003f76 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f76:	457c                	lw	a5,76(a0)
    80003f78:	10d7e863          	bltu	a5,a3,80004088 <writei+0x112>
{
    80003f7c:	7159                	addi	sp,sp,-112
    80003f7e:	f486                	sd	ra,104(sp)
    80003f80:	f0a2                	sd	s0,96(sp)
    80003f82:	eca6                	sd	s1,88(sp)
    80003f84:	e8ca                	sd	s2,80(sp)
    80003f86:	e4ce                	sd	s3,72(sp)
    80003f88:	e0d2                	sd	s4,64(sp)
    80003f8a:	fc56                	sd	s5,56(sp)
    80003f8c:	f85a                	sd	s6,48(sp)
    80003f8e:	f45e                	sd	s7,40(sp)
    80003f90:	f062                	sd	s8,32(sp)
    80003f92:	ec66                	sd	s9,24(sp)
    80003f94:	e86a                	sd	s10,16(sp)
    80003f96:	e46e                	sd	s11,8(sp)
    80003f98:	1880                	addi	s0,sp,112
    80003f9a:	8b2a                	mv	s6,a0
    80003f9c:	8c2e                	mv	s8,a1
    80003f9e:	8ab2                	mv	s5,a2
    80003fa0:	8936                	mv	s2,a3
    80003fa2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003fa4:	00e687bb          	addw	a5,a3,a4
    80003fa8:	0ed7e263          	bltu	a5,a3,8000408c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003fac:	00043737          	lui	a4,0x43
    80003fb0:	0ef76063          	bltu	a4,a5,80004090 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fb4:	0c0b8863          	beqz	s7,80004084 <writei+0x10e>
    80003fb8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fba:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003fbe:	5cfd                	li	s9,-1
    80003fc0:	a091                	j	80004004 <writei+0x8e>
    80003fc2:	02099d93          	slli	s11,s3,0x20
    80003fc6:	020ddd93          	srli	s11,s11,0x20
    80003fca:	05848793          	addi	a5,s1,88
    80003fce:	86ee                	mv	a3,s11
    80003fd0:	8656                	mv	a2,s5
    80003fd2:	85e2                	mv	a1,s8
    80003fd4:	953e                	add	a0,a0,a5
    80003fd6:	fffff097          	auipc	ra,0xfffff
    80003fda:	940080e7          	jalr	-1728(ra) # 80002916 <either_copyin>
    80003fde:	07950263          	beq	a0,s9,80004042 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00000097          	auipc	ra,0x0
    80003fe8:	790080e7          	jalr	1936(ra) # 80004774 <log_write>
    brelse(bp);
    80003fec:	8526                	mv	a0,s1
    80003fee:	fffff097          	auipc	ra,0xfffff
    80003ff2:	50a080e7          	jalr	1290(ra) # 800034f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ff6:	01498a3b          	addw	s4,s3,s4
    80003ffa:	0129893b          	addw	s2,s3,s2
    80003ffe:	9aee                	add	s5,s5,s11
    80004000:	057a7663          	bgeu	s4,s7,8000404c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004004:	000b2483          	lw	s1,0(s6)
    80004008:	00a9559b          	srliw	a1,s2,0xa
    8000400c:	855a                	mv	a0,s6
    8000400e:	fffff097          	auipc	ra,0xfffff
    80004012:	7ae080e7          	jalr	1966(ra) # 800037bc <bmap>
    80004016:	0005059b          	sext.w	a1,a0
    8000401a:	8526                	mv	a0,s1
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	3ac080e7          	jalr	940(ra) # 800033c8 <bread>
    80004024:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004026:	3ff97513          	andi	a0,s2,1023
    8000402a:	40ad07bb          	subw	a5,s10,a0
    8000402e:	414b873b          	subw	a4,s7,s4
    80004032:	89be                	mv	s3,a5
    80004034:	2781                	sext.w	a5,a5
    80004036:	0007069b          	sext.w	a3,a4
    8000403a:	f8f6f4e3          	bgeu	a3,a5,80003fc2 <writei+0x4c>
    8000403e:	89ba                	mv	s3,a4
    80004040:	b749                	j	80003fc2 <writei+0x4c>
      brelse(bp);
    80004042:	8526                	mv	a0,s1
    80004044:	fffff097          	auipc	ra,0xfffff
    80004048:	4b4080e7          	jalr	1204(ra) # 800034f8 <brelse>
  }

  if(off > ip->size)
    8000404c:	04cb2783          	lw	a5,76(s6)
    80004050:	0127f463          	bgeu	a5,s2,80004058 <writei+0xe2>
    ip->size = off;
    80004054:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004058:	855a                	mv	a0,s6
    8000405a:	00000097          	auipc	ra,0x0
    8000405e:	aa6080e7          	jalr	-1370(ra) # 80003b00 <iupdate>

  return tot;
    80004062:	000a051b          	sext.w	a0,s4
}
    80004066:	70a6                	ld	ra,104(sp)
    80004068:	7406                	ld	s0,96(sp)
    8000406a:	64e6                	ld	s1,88(sp)
    8000406c:	6946                	ld	s2,80(sp)
    8000406e:	69a6                	ld	s3,72(sp)
    80004070:	6a06                	ld	s4,64(sp)
    80004072:	7ae2                	ld	s5,56(sp)
    80004074:	7b42                	ld	s6,48(sp)
    80004076:	7ba2                	ld	s7,40(sp)
    80004078:	7c02                	ld	s8,32(sp)
    8000407a:	6ce2                	ld	s9,24(sp)
    8000407c:	6d42                	ld	s10,16(sp)
    8000407e:	6da2                	ld	s11,8(sp)
    80004080:	6165                	addi	sp,sp,112
    80004082:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004084:	8a5e                	mv	s4,s7
    80004086:	bfc9                	j	80004058 <writei+0xe2>
    return -1;
    80004088:	557d                	li	a0,-1
}
    8000408a:	8082                	ret
    return -1;
    8000408c:	557d                	li	a0,-1
    8000408e:	bfe1                	j	80004066 <writei+0xf0>
    return -1;
    80004090:	557d                	li	a0,-1
    80004092:	bfd1                	j	80004066 <writei+0xf0>

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
    800040a2:	d70080e7          	jalr	-656(ra) # 80000e0e <strncmp>
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
    800040dc:	64850513          	addi	a0,a0,1608 # 80008720 <syscalls+0x1b8>
    800040e0:	ffffc097          	auipc	ra,0xffffc
    800040e4:	4ec080e7          	jalr	1260(ra) # 800005cc <panic>
      panic("dirlookup read");
    800040e8:	00004517          	auipc	a0,0x4
    800040ec:	65050513          	addi	a0,a0,1616 # 80008738 <syscalls+0x1d0>
    800040f0:	ffffc097          	auipc	ra,0xffffc
    800040f4:	4dc080e7          	jalr	1244(ra) # 800005cc <panic>
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
    80004112:	d70080e7          	jalr	-656(ra) # 80003e7e <readi>
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
    80004146:	754080e7          	jalr	1876(ra) # 80003896 <iget>
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
    8000418e:	ae2080e7          	jalr	-1310(ra) # 80001c6c <myproc>
    80004192:	16053503          	ld	a0,352(a0)
    80004196:	00000097          	auipc	ra,0x0
    8000419a:	9f6080e7          	jalr	-1546(ra) # 80003b8c <idup>
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
    800041b4:	6e6080e7          	jalr	1766(ra) # 80003896 <iget>
    800041b8:	89aa                	mv	s3,a0
    800041ba:	b7dd                	j	800041a0 <namex+0x42>
      iunlockput(ip);
    800041bc:	854e                	mv	a0,s3
    800041be:	00000097          	auipc	ra,0x0
    800041c2:	c6e080e7          	jalr	-914(ra) # 80003e2c <iunlockput>
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
    800041ea:	aa6080e7          	jalr	-1370(ra) # 80003c8c <iunlock>
      return ip;
    800041ee:	bfe9                	j	800041c8 <namex+0x6a>
      iunlockput(ip);
    800041f0:	854e                	mv	a0,s3
    800041f2:	00000097          	auipc	ra,0x0
    800041f6:	c3a080e7          	jalr	-966(ra) # 80003e2c <iunlockput>
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
    80004212:	b84080e7          	jalr	-1148(ra) # 80000d92 <memmove>
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
    8000422e:	9a0080e7          	jalr	-1632(ra) # 80003bca <ilock>
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
    8000425c:	bd4080e7          	jalr	-1068(ra) # 80003e2c <iunlockput>
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
    80004296:	b00080e7          	jalr	-1280(ra) # 80000d92 <memmove>
    name[len] = 0;
    8000429a:	9cd2                	add	s9,s9,s4
    8000429c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800042a0:	bf9d                	j	80004216 <namex+0xb8>
  if(nameiparent){
    800042a2:	f20a83e3          	beqz	s5,800041c8 <namex+0x6a>
    iput(ip);
    800042a6:	854e                	mv	a0,s3
    800042a8:	00000097          	auipc	ra,0x0
    800042ac:	adc080e7          	jalr	-1316(ra) # 80003d84 <iput>
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
    800042f8:	b8a080e7          	jalr	-1142(ra) # 80003e7e <readi>
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
    8000431e:	b30080e7          	jalr	-1232(ra) # 80000e4a <strncpy>
  de.inum = inum;
    80004322:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004326:	4741                	li	a4,16
    80004328:	86a6                	mv	a3,s1
    8000432a:	fc040613          	addi	a2,s0,-64
    8000432e:	4581                	li	a1,0
    80004330:	854a                	mv	a0,s2
    80004332:	00000097          	auipc	ra,0x0
    80004336:	c44080e7          	jalr	-956(ra) # 80003f76 <writei>
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
    80004358:	a30080e7          	jalr	-1488(ra) # 80003d84 <iput>
    return -1;
    8000435c:	557d                	li	a0,-1
    8000435e:	b7dd                	j	80004344 <dirlink+0x86>
      panic("dirlink read");
    80004360:	00004517          	auipc	a0,0x4
    80004364:	3e850513          	addi	a0,a0,1000 # 80008748 <syscalls+0x1e0>
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	264080e7          	jalr	612(ra) # 800005cc <panic>
    panic("dirlink");
    80004370:	00004517          	auipc	a0,0x4
    80004374:	4e050513          	addi	a0,a0,1248 # 80008850 <syscalls+0x2e8>
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	254080e7          	jalr	596(ra) # 800005cc <panic>

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
    800043c6:	0001e917          	auipc	s2,0x1e
    800043ca:	8aa90913          	addi	s2,s2,-1878 # 80021c70 <log>
    800043ce:	01892583          	lw	a1,24(s2)
    800043d2:	02892503          	lw	a0,40(s2)
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	ff2080e7          	jalr	-14(ra) # 800033c8 <bread>
    800043de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800043e0:	02c92683          	lw	a3,44(s2)
    800043e4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800043e6:	02d05763          	blez	a3,80004414 <write_head+0x5a>
    800043ea:	0001e797          	auipc	a5,0x1e
    800043ee:	8b678793          	addi	a5,a5,-1866 # 80021ca0 <log+0x30>
    800043f2:	05c50713          	addi	a4,a0,92
    800043f6:	36fd                	addiw	a3,a3,-1
    800043f8:	1682                	slli	a3,a3,0x20
    800043fa:	9281                	srli	a3,a3,0x20
    800043fc:	068a                	slli	a3,a3,0x2
    800043fe:	0001e617          	auipc	a2,0x1e
    80004402:	8a660613          	addi	a2,a2,-1882 # 80021ca4 <log+0x34>
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
    8000441a:	0a4080e7          	jalr	164(ra) # 800034ba <bwrite>
  brelse(buf);
    8000441e:	8526                	mv	a0,s1
    80004420:	fffff097          	auipc	ra,0xfffff
    80004424:	0d8080e7          	jalr	216(ra) # 800034f8 <brelse>
}
    80004428:	60e2                	ld	ra,24(sp)
    8000442a:	6442                	ld	s0,16(sp)
    8000442c:	64a2                	ld	s1,8(sp)
    8000442e:	6902                	ld	s2,0(sp)
    80004430:	6105                	addi	sp,sp,32
    80004432:	8082                	ret

0000000080004434 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004434:	0001e797          	auipc	a5,0x1e
    80004438:	8687a783          	lw	a5,-1944(a5) # 80021c9c <log+0x2c>
    8000443c:	0af05d63          	blez	a5,800044f6 <install_trans+0xc2>
{
    80004440:	7139                	addi	sp,sp,-64
    80004442:	fc06                	sd	ra,56(sp)
    80004444:	f822                	sd	s0,48(sp)
    80004446:	f426                	sd	s1,40(sp)
    80004448:	f04a                	sd	s2,32(sp)
    8000444a:	ec4e                	sd	s3,24(sp)
    8000444c:	e852                	sd	s4,16(sp)
    8000444e:	e456                	sd	s5,8(sp)
    80004450:	e05a                	sd	s6,0(sp)
    80004452:	0080                	addi	s0,sp,64
    80004454:	8b2a                	mv	s6,a0
    80004456:	0001ea97          	auipc	s5,0x1e
    8000445a:	84aa8a93          	addi	s5,s5,-1974 # 80021ca0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000445e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004460:	0001e997          	auipc	s3,0x1e
    80004464:	81098993          	addi	s3,s3,-2032 # 80021c70 <log>
    80004468:	a00d                	j	8000448a <install_trans+0x56>
    brelse(lbuf);
    8000446a:	854a                	mv	a0,s2
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	08c080e7          	jalr	140(ra) # 800034f8 <brelse>
    brelse(dbuf);
    80004474:	8526                	mv	a0,s1
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	082080e7          	jalr	130(ra) # 800034f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000447e:	2a05                	addiw	s4,s4,1
    80004480:	0a91                	addi	s5,s5,4
    80004482:	02c9a783          	lw	a5,44(s3)
    80004486:	04fa5e63          	bge	s4,a5,800044e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000448a:	0189a583          	lw	a1,24(s3)
    8000448e:	014585bb          	addw	a1,a1,s4
    80004492:	2585                	addiw	a1,a1,1
    80004494:	0289a503          	lw	a0,40(s3)
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	f30080e7          	jalr	-208(ra) # 800033c8 <bread>
    800044a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800044a2:	000aa583          	lw	a1,0(s5)
    800044a6:	0289a503          	lw	a0,40(s3)
    800044aa:	fffff097          	auipc	ra,0xfffff
    800044ae:	f1e080e7          	jalr	-226(ra) # 800033c8 <bread>
    800044b2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800044b4:	40000613          	li	a2,1024
    800044b8:	05890593          	addi	a1,s2,88
    800044bc:	05850513          	addi	a0,a0,88
    800044c0:	ffffd097          	auipc	ra,0xffffd
    800044c4:	8d2080e7          	jalr	-1838(ra) # 80000d92 <memmove>
    bwrite(dbuf);  // write dst to disk
    800044c8:	8526                	mv	a0,s1
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	ff0080e7          	jalr	-16(ra) # 800034ba <bwrite>
    if(recovering == 0)
    800044d2:	f80b1ce3          	bnez	s6,8000446a <install_trans+0x36>
      bunpin(dbuf);
    800044d6:	8526                	mv	a0,s1
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	0fa080e7          	jalr	250(ra) # 800035d2 <bunpin>
    800044e0:	b769                	j	8000446a <install_trans+0x36>
}
    800044e2:	70e2                	ld	ra,56(sp)
    800044e4:	7442                	ld	s0,48(sp)
    800044e6:	74a2                	ld	s1,40(sp)
    800044e8:	7902                	ld	s2,32(sp)
    800044ea:	69e2                	ld	s3,24(sp)
    800044ec:	6a42                	ld	s4,16(sp)
    800044ee:	6aa2                	ld	s5,8(sp)
    800044f0:	6b02                	ld	s6,0(sp)
    800044f2:	6121                	addi	sp,sp,64
    800044f4:	8082                	ret
    800044f6:	8082                	ret

00000000800044f8 <initlog>:
{
    800044f8:	7179                	addi	sp,sp,-48
    800044fa:	f406                	sd	ra,40(sp)
    800044fc:	f022                	sd	s0,32(sp)
    800044fe:	ec26                	sd	s1,24(sp)
    80004500:	e84a                	sd	s2,16(sp)
    80004502:	e44e                	sd	s3,8(sp)
    80004504:	1800                	addi	s0,sp,48
    80004506:	892a                	mv	s2,a0
    80004508:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000450a:	0001d497          	auipc	s1,0x1d
    8000450e:	76648493          	addi	s1,s1,1894 # 80021c70 <log>
    80004512:	00004597          	auipc	a1,0x4
    80004516:	24658593          	addi	a1,a1,582 # 80008758 <syscalls+0x1f0>
    8000451a:	8526                	mv	a0,s1
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	68e080e7          	jalr	1678(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    80004524:	0149a583          	lw	a1,20(s3)
    80004528:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000452a:	0109a783          	lw	a5,16(s3)
    8000452e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004530:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004534:	854a                	mv	a0,s2
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	e92080e7          	jalr	-366(ra) # 800033c8 <bread>
  log.lh.n = lh->n;
    8000453e:	4d34                	lw	a3,88(a0)
    80004540:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004542:	02d05563          	blez	a3,8000456c <initlog+0x74>
    80004546:	05c50793          	addi	a5,a0,92
    8000454a:	0001d717          	auipc	a4,0x1d
    8000454e:	75670713          	addi	a4,a4,1878 # 80021ca0 <log+0x30>
    80004552:	36fd                	addiw	a3,a3,-1
    80004554:	1682                	slli	a3,a3,0x20
    80004556:	9281                	srli	a3,a3,0x20
    80004558:	068a                	slli	a3,a3,0x2
    8000455a:	06050613          	addi	a2,a0,96
    8000455e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004560:	4390                	lw	a2,0(a5)
    80004562:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004564:	0791                	addi	a5,a5,4
    80004566:	0711                	addi	a4,a4,4
    80004568:	fed79ce3          	bne	a5,a3,80004560 <initlog+0x68>
  brelse(buf);
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	f8c080e7          	jalr	-116(ra) # 800034f8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004574:	4505                	li	a0,1
    80004576:	00000097          	auipc	ra,0x0
    8000457a:	ebe080e7          	jalr	-322(ra) # 80004434 <install_trans>
  log.lh.n = 0;
    8000457e:	0001d797          	auipc	a5,0x1d
    80004582:	7007af23          	sw	zero,1822(a5) # 80021c9c <log+0x2c>
  write_head(); // clear the log
    80004586:	00000097          	auipc	ra,0x0
    8000458a:	e34080e7          	jalr	-460(ra) # 800043ba <write_head>
}
    8000458e:	70a2                	ld	ra,40(sp)
    80004590:	7402                	ld	s0,32(sp)
    80004592:	64e2                	ld	s1,24(sp)
    80004594:	6942                	ld	s2,16(sp)
    80004596:	69a2                	ld	s3,8(sp)
    80004598:	6145                	addi	sp,sp,48
    8000459a:	8082                	ret

000000008000459c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000459c:	1101                	addi	sp,sp,-32
    8000459e:	ec06                	sd	ra,24(sp)
    800045a0:	e822                	sd	s0,16(sp)
    800045a2:	e426                	sd	s1,8(sp)
    800045a4:	e04a                	sd	s2,0(sp)
    800045a6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800045a8:	0001d517          	auipc	a0,0x1d
    800045ac:	6c850513          	addi	a0,a0,1736 # 80021c70 <log>
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	68a080e7          	jalr	1674(ra) # 80000c3a <acquire>
  while(1){
    if(log.committing){
    800045b8:	0001d497          	auipc	s1,0x1d
    800045bc:	6b848493          	addi	s1,s1,1720 # 80021c70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045c0:	4979                	li	s2,30
    800045c2:	a039                	j	800045d0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800045c4:	85a6                	mv	a1,s1
    800045c6:	8526                	mv	a0,s1
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	f54080e7          	jalr	-172(ra) # 8000251c <sleep>
    if(log.committing){
    800045d0:	50dc                	lw	a5,36(s1)
    800045d2:	fbed                	bnez	a5,800045c4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045d4:	509c                	lw	a5,32(s1)
    800045d6:	0017871b          	addiw	a4,a5,1
    800045da:	0007069b          	sext.w	a3,a4
    800045de:	0027179b          	slliw	a5,a4,0x2
    800045e2:	9fb9                	addw	a5,a5,a4
    800045e4:	0017979b          	slliw	a5,a5,0x1
    800045e8:	54d8                	lw	a4,44(s1)
    800045ea:	9fb9                	addw	a5,a5,a4
    800045ec:	00f95963          	bge	s2,a5,800045fe <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800045f0:	85a6                	mv	a1,s1
    800045f2:	8526                	mv	a0,s1
    800045f4:	ffffe097          	auipc	ra,0xffffe
    800045f8:	f28080e7          	jalr	-216(ra) # 8000251c <sleep>
    800045fc:	bfd1                	j	800045d0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800045fe:	0001d517          	auipc	a0,0x1d
    80004602:	67250513          	addi	a0,a0,1650 # 80021c70 <log>
    80004606:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	6e6080e7          	jalr	1766(ra) # 80000cee <release>
      break;
    }
  }
}
    80004610:	60e2                	ld	ra,24(sp)
    80004612:	6442                	ld	s0,16(sp)
    80004614:	64a2                	ld	s1,8(sp)
    80004616:	6902                	ld	s2,0(sp)
    80004618:	6105                	addi	sp,sp,32
    8000461a:	8082                	ret

000000008000461c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000461c:	7139                	addi	sp,sp,-64
    8000461e:	fc06                	sd	ra,56(sp)
    80004620:	f822                	sd	s0,48(sp)
    80004622:	f426                	sd	s1,40(sp)
    80004624:	f04a                	sd	s2,32(sp)
    80004626:	ec4e                	sd	s3,24(sp)
    80004628:	e852                	sd	s4,16(sp)
    8000462a:	e456                	sd	s5,8(sp)
    8000462c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000462e:	0001d497          	auipc	s1,0x1d
    80004632:	64248493          	addi	s1,s1,1602 # 80021c70 <log>
    80004636:	8526                	mv	a0,s1
    80004638:	ffffc097          	auipc	ra,0xffffc
    8000463c:	602080e7          	jalr	1538(ra) # 80000c3a <acquire>
  log.outstanding -= 1;
    80004640:	509c                	lw	a5,32(s1)
    80004642:	37fd                	addiw	a5,a5,-1
    80004644:	0007891b          	sext.w	s2,a5
    80004648:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000464a:	50dc                	lw	a5,36(s1)
    8000464c:	e7b9                	bnez	a5,8000469a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000464e:	04091e63          	bnez	s2,800046aa <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004652:	0001d497          	auipc	s1,0x1d
    80004656:	61e48493          	addi	s1,s1,1566 # 80021c70 <log>
    8000465a:	4785                	li	a5,1
    8000465c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000465e:	8526                	mv	a0,s1
    80004660:	ffffc097          	auipc	ra,0xffffc
    80004664:	68e080e7          	jalr	1678(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004668:	54dc                	lw	a5,44(s1)
    8000466a:	06f04763          	bgtz	a5,800046d8 <end_op+0xbc>
    acquire(&log.lock);
    8000466e:	0001d497          	auipc	s1,0x1d
    80004672:	60248493          	addi	s1,s1,1538 # 80021c70 <log>
    80004676:	8526                	mv	a0,s1
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	5c2080e7          	jalr	1474(ra) # 80000c3a <acquire>
    log.committing = 0;
    80004680:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004684:	8526                	mv	a0,s1
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	022080e7          	jalr	34(ra) # 800026a8 <wakeup>
    release(&log.lock);
    8000468e:	8526                	mv	a0,s1
    80004690:	ffffc097          	auipc	ra,0xffffc
    80004694:	65e080e7          	jalr	1630(ra) # 80000cee <release>
}
    80004698:	a03d                	j	800046c6 <end_op+0xaa>
    panic("log.committing");
    8000469a:	00004517          	auipc	a0,0x4
    8000469e:	0c650513          	addi	a0,a0,198 # 80008760 <syscalls+0x1f8>
    800046a2:	ffffc097          	auipc	ra,0xffffc
    800046a6:	f2a080e7          	jalr	-214(ra) # 800005cc <panic>
    wakeup(&log);
    800046aa:	0001d497          	auipc	s1,0x1d
    800046ae:	5c648493          	addi	s1,s1,1478 # 80021c70 <log>
    800046b2:	8526                	mv	a0,s1
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	ff4080e7          	jalr	-12(ra) # 800026a8 <wakeup>
  release(&log.lock);
    800046bc:	8526                	mv	a0,s1
    800046be:	ffffc097          	auipc	ra,0xffffc
    800046c2:	630080e7          	jalr	1584(ra) # 80000cee <release>
}
    800046c6:	70e2                	ld	ra,56(sp)
    800046c8:	7442                	ld	s0,48(sp)
    800046ca:	74a2                	ld	s1,40(sp)
    800046cc:	7902                	ld	s2,32(sp)
    800046ce:	69e2                	ld	s3,24(sp)
    800046d0:	6a42                	ld	s4,16(sp)
    800046d2:	6aa2                	ld	s5,8(sp)
    800046d4:	6121                	addi	sp,sp,64
    800046d6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800046d8:	0001da97          	auipc	s5,0x1d
    800046dc:	5c8a8a93          	addi	s5,s5,1480 # 80021ca0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800046e0:	0001da17          	auipc	s4,0x1d
    800046e4:	590a0a13          	addi	s4,s4,1424 # 80021c70 <log>
    800046e8:	018a2583          	lw	a1,24(s4)
    800046ec:	012585bb          	addw	a1,a1,s2
    800046f0:	2585                	addiw	a1,a1,1
    800046f2:	028a2503          	lw	a0,40(s4)
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	cd2080e7          	jalr	-814(ra) # 800033c8 <bread>
    800046fe:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004700:	000aa583          	lw	a1,0(s5)
    80004704:	028a2503          	lw	a0,40(s4)
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	cc0080e7          	jalr	-832(ra) # 800033c8 <bread>
    80004710:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004712:	40000613          	li	a2,1024
    80004716:	05850593          	addi	a1,a0,88
    8000471a:	05848513          	addi	a0,s1,88
    8000471e:	ffffc097          	auipc	ra,0xffffc
    80004722:	674080e7          	jalr	1652(ra) # 80000d92 <memmove>
    bwrite(to);  // write the log
    80004726:	8526                	mv	a0,s1
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	d92080e7          	jalr	-622(ra) # 800034ba <bwrite>
    brelse(from);
    80004730:	854e                	mv	a0,s3
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	dc6080e7          	jalr	-570(ra) # 800034f8 <brelse>
    brelse(to);
    8000473a:	8526                	mv	a0,s1
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	dbc080e7          	jalr	-580(ra) # 800034f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004744:	2905                	addiw	s2,s2,1
    80004746:	0a91                	addi	s5,s5,4
    80004748:	02ca2783          	lw	a5,44(s4)
    8000474c:	f8f94ee3          	blt	s2,a5,800046e8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004750:	00000097          	auipc	ra,0x0
    80004754:	c6a080e7          	jalr	-918(ra) # 800043ba <write_head>
    install_trans(0); // Now install writes to home locations
    80004758:	4501                	li	a0,0
    8000475a:	00000097          	auipc	ra,0x0
    8000475e:	cda080e7          	jalr	-806(ra) # 80004434 <install_trans>
    log.lh.n = 0;
    80004762:	0001d797          	auipc	a5,0x1d
    80004766:	5207ad23          	sw	zero,1338(a5) # 80021c9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	c50080e7          	jalr	-944(ra) # 800043ba <write_head>
    80004772:	bdf5                	j	8000466e <end_op+0x52>

0000000080004774 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004774:	1101                	addi	sp,sp,-32
    80004776:	ec06                	sd	ra,24(sp)
    80004778:	e822                	sd	s0,16(sp)
    8000477a:	e426                	sd	s1,8(sp)
    8000477c:	e04a                	sd	s2,0(sp)
    8000477e:	1000                	addi	s0,sp,32
    80004780:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004782:	0001d917          	auipc	s2,0x1d
    80004786:	4ee90913          	addi	s2,s2,1262 # 80021c70 <log>
    8000478a:	854a                	mv	a0,s2
    8000478c:	ffffc097          	auipc	ra,0xffffc
    80004790:	4ae080e7          	jalr	1198(ra) # 80000c3a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004794:	02c92603          	lw	a2,44(s2)
    80004798:	47f5                	li	a5,29
    8000479a:	06c7c563          	blt	a5,a2,80004804 <log_write+0x90>
    8000479e:	0001d797          	auipc	a5,0x1d
    800047a2:	4ee7a783          	lw	a5,1262(a5) # 80021c8c <log+0x1c>
    800047a6:	37fd                	addiw	a5,a5,-1
    800047a8:	04f65e63          	bge	a2,a5,80004804 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800047ac:	0001d797          	auipc	a5,0x1d
    800047b0:	4e47a783          	lw	a5,1252(a5) # 80021c90 <log+0x20>
    800047b4:	06f05063          	blez	a5,80004814 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047b8:	4781                	li	a5,0
    800047ba:	06c05563          	blez	a2,80004824 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800047be:	44cc                	lw	a1,12(s1)
    800047c0:	0001d717          	auipc	a4,0x1d
    800047c4:	4e070713          	addi	a4,a4,1248 # 80021ca0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800047c8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800047ca:	4314                	lw	a3,0(a4)
    800047cc:	04b68c63          	beq	a3,a1,80004824 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800047d0:	2785                	addiw	a5,a5,1
    800047d2:	0711                	addi	a4,a4,4
    800047d4:	fef61be3          	bne	a2,a5,800047ca <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800047d8:	0621                	addi	a2,a2,8
    800047da:	060a                	slli	a2,a2,0x2
    800047dc:	0001d797          	auipc	a5,0x1d
    800047e0:	49478793          	addi	a5,a5,1172 # 80021c70 <log>
    800047e4:	963e                	add	a2,a2,a5
    800047e6:	44dc                	lw	a5,12(s1)
    800047e8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800047ea:	8526                	mv	a0,s1
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	daa080e7          	jalr	-598(ra) # 80003596 <bpin>
    log.lh.n++;
    800047f4:	0001d717          	auipc	a4,0x1d
    800047f8:	47c70713          	addi	a4,a4,1148 # 80021c70 <log>
    800047fc:	575c                	lw	a5,44(a4)
    800047fe:	2785                	addiw	a5,a5,1
    80004800:	d75c                	sw	a5,44(a4)
    80004802:	a835                	j	8000483e <log_write+0xca>
    panic("too big a transaction");
    80004804:	00004517          	auipc	a0,0x4
    80004808:	f6c50513          	addi	a0,a0,-148 # 80008770 <syscalls+0x208>
    8000480c:	ffffc097          	auipc	ra,0xffffc
    80004810:	dc0080e7          	jalr	-576(ra) # 800005cc <panic>
    panic("log_write outside of trans");
    80004814:	00004517          	auipc	a0,0x4
    80004818:	f7450513          	addi	a0,a0,-140 # 80008788 <syscalls+0x220>
    8000481c:	ffffc097          	auipc	ra,0xffffc
    80004820:	db0080e7          	jalr	-592(ra) # 800005cc <panic>
  log.lh.block[i] = b->blockno;
    80004824:	00878713          	addi	a4,a5,8
    80004828:	00271693          	slli	a3,a4,0x2
    8000482c:	0001d717          	auipc	a4,0x1d
    80004830:	44470713          	addi	a4,a4,1092 # 80021c70 <log>
    80004834:	9736                	add	a4,a4,a3
    80004836:	44d4                	lw	a3,12(s1)
    80004838:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000483a:	faf608e3          	beq	a2,a5,800047ea <log_write+0x76>
  }
  release(&log.lock);
    8000483e:	0001d517          	auipc	a0,0x1d
    80004842:	43250513          	addi	a0,a0,1074 # 80021c70 <log>
    80004846:	ffffc097          	auipc	ra,0xffffc
    8000484a:	4a8080e7          	jalr	1192(ra) # 80000cee <release>
}
    8000484e:	60e2                	ld	ra,24(sp)
    80004850:	6442                	ld	s0,16(sp)
    80004852:	64a2                	ld	s1,8(sp)
    80004854:	6902                	ld	s2,0(sp)
    80004856:	6105                	addi	sp,sp,32
    80004858:	8082                	ret

000000008000485a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000485a:	1101                	addi	sp,sp,-32
    8000485c:	ec06                	sd	ra,24(sp)
    8000485e:	e822                	sd	s0,16(sp)
    80004860:	e426                	sd	s1,8(sp)
    80004862:	e04a                	sd	s2,0(sp)
    80004864:	1000                	addi	s0,sp,32
    80004866:	84aa                	mv	s1,a0
    80004868:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000486a:	00004597          	auipc	a1,0x4
    8000486e:	f3e58593          	addi	a1,a1,-194 # 800087a8 <syscalls+0x240>
    80004872:	0521                	addi	a0,a0,8
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	336080e7          	jalr	822(ra) # 80000baa <initlock>
  lk->name = name;
    8000487c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004880:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004884:	0204a423          	sw	zero,40(s1)
}
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	64a2                	ld	s1,8(sp)
    8000488e:	6902                	ld	s2,0(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret

0000000080004894 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004894:	1101                	addi	sp,sp,-32
    80004896:	ec06                	sd	ra,24(sp)
    80004898:	e822                	sd	s0,16(sp)
    8000489a:	e426                	sd	s1,8(sp)
    8000489c:	e04a                	sd	s2,0(sp)
    8000489e:	1000                	addi	s0,sp,32
    800048a0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048a2:	00850913          	addi	s2,a0,8
    800048a6:	854a                	mv	a0,s2
    800048a8:	ffffc097          	auipc	ra,0xffffc
    800048ac:	392080e7          	jalr	914(ra) # 80000c3a <acquire>
  while (lk->locked) {
    800048b0:	409c                	lw	a5,0(s1)
    800048b2:	cb89                	beqz	a5,800048c4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800048b4:	85ca                	mv	a1,s2
    800048b6:	8526                	mv	a0,s1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	c64080e7          	jalr	-924(ra) # 8000251c <sleep>
  while (lk->locked) {
    800048c0:	409c                	lw	a5,0(s1)
    800048c2:	fbed                	bnez	a5,800048b4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800048c4:	4785                	li	a5,1
    800048c6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800048c8:	ffffd097          	auipc	ra,0xffffd
    800048cc:	3a4080e7          	jalr	932(ra) # 80001c6c <myproc>
    800048d0:	591c                	lw	a5,48(a0)
    800048d2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800048d4:	854a                	mv	a0,s2
    800048d6:	ffffc097          	auipc	ra,0xffffc
    800048da:	418080e7          	jalr	1048(ra) # 80000cee <release>
}
    800048de:	60e2                	ld	ra,24(sp)
    800048e0:	6442                	ld	s0,16(sp)
    800048e2:	64a2                	ld	s1,8(sp)
    800048e4:	6902                	ld	s2,0(sp)
    800048e6:	6105                	addi	sp,sp,32
    800048e8:	8082                	ret

00000000800048ea <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800048ea:	1101                	addi	sp,sp,-32
    800048ec:	ec06                	sd	ra,24(sp)
    800048ee:	e822                	sd	s0,16(sp)
    800048f0:	e426                	sd	s1,8(sp)
    800048f2:	e04a                	sd	s2,0(sp)
    800048f4:	1000                	addi	s0,sp,32
    800048f6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048f8:	00850913          	addi	s2,a0,8
    800048fc:	854a                	mv	a0,s2
    800048fe:	ffffc097          	auipc	ra,0xffffc
    80004902:	33c080e7          	jalr	828(ra) # 80000c3a <acquire>
  lk->locked = 0;
    80004906:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000490a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000490e:	8526                	mv	a0,s1
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	d98080e7          	jalr	-616(ra) # 800026a8 <wakeup>
  release(&lk->lk);
    80004918:	854a                	mv	a0,s2
    8000491a:	ffffc097          	auipc	ra,0xffffc
    8000491e:	3d4080e7          	jalr	980(ra) # 80000cee <release>
}
    80004922:	60e2                	ld	ra,24(sp)
    80004924:	6442                	ld	s0,16(sp)
    80004926:	64a2                	ld	s1,8(sp)
    80004928:	6902                	ld	s2,0(sp)
    8000492a:	6105                	addi	sp,sp,32
    8000492c:	8082                	ret

000000008000492e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000492e:	7179                	addi	sp,sp,-48
    80004930:	f406                	sd	ra,40(sp)
    80004932:	f022                	sd	s0,32(sp)
    80004934:	ec26                	sd	s1,24(sp)
    80004936:	e84a                	sd	s2,16(sp)
    80004938:	e44e                	sd	s3,8(sp)
    8000493a:	1800                	addi	s0,sp,48
    8000493c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000493e:	00850913          	addi	s2,a0,8
    80004942:	854a                	mv	a0,s2
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	2f6080e7          	jalr	758(ra) # 80000c3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000494c:	409c                	lw	a5,0(s1)
    8000494e:	ef99                	bnez	a5,8000496c <holdingsleep+0x3e>
    80004950:	4481                	li	s1,0
  release(&lk->lk);
    80004952:	854a                	mv	a0,s2
    80004954:	ffffc097          	auipc	ra,0xffffc
    80004958:	39a080e7          	jalr	922(ra) # 80000cee <release>
  return r;
}
    8000495c:	8526                	mv	a0,s1
    8000495e:	70a2                	ld	ra,40(sp)
    80004960:	7402                	ld	s0,32(sp)
    80004962:	64e2                	ld	s1,24(sp)
    80004964:	6942                	ld	s2,16(sp)
    80004966:	69a2                	ld	s3,8(sp)
    80004968:	6145                	addi	sp,sp,48
    8000496a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000496c:	0284a983          	lw	s3,40(s1)
    80004970:	ffffd097          	auipc	ra,0xffffd
    80004974:	2fc080e7          	jalr	764(ra) # 80001c6c <myproc>
    80004978:	5904                	lw	s1,48(a0)
    8000497a:	413484b3          	sub	s1,s1,s3
    8000497e:	0014b493          	seqz	s1,s1
    80004982:	bfc1                	j	80004952 <holdingsleep+0x24>

0000000080004984 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004984:	1141                	addi	sp,sp,-16
    80004986:	e406                	sd	ra,8(sp)
    80004988:	e022                	sd	s0,0(sp)
    8000498a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000498c:	00004597          	auipc	a1,0x4
    80004990:	e2c58593          	addi	a1,a1,-468 # 800087b8 <syscalls+0x250>
    80004994:	0001d517          	auipc	a0,0x1d
    80004998:	42450513          	addi	a0,a0,1060 # 80021db8 <ftable>
    8000499c:	ffffc097          	auipc	ra,0xffffc
    800049a0:	20e080e7          	jalr	526(ra) # 80000baa <initlock>
}
    800049a4:	60a2                	ld	ra,8(sp)
    800049a6:	6402                	ld	s0,0(sp)
    800049a8:	0141                	addi	sp,sp,16
    800049aa:	8082                	ret

00000000800049ac <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800049ac:	1101                	addi	sp,sp,-32
    800049ae:	ec06                	sd	ra,24(sp)
    800049b0:	e822                	sd	s0,16(sp)
    800049b2:	e426                	sd	s1,8(sp)
    800049b4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049b6:	0001d517          	auipc	a0,0x1d
    800049ba:	40250513          	addi	a0,a0,1026 # 80021db8 <ftable>
    800049be:	ffffc097          	auipc	ra,0xffffc
    800049c2:	27c080e7          	jalr	636(ra) # 80000c3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049c6:	0001d497          	auipc	s1,0x1d
    800049ca:	40a48493          	addi	s1,s1,1034 # 80021dd0 <ftable+0x18>
    800049ce:	0001e717          	auipc	a4,0x1e
    800049d2:	3a270713          	addi	a4,a4,930 # 80022d70 <ftable+0xfb8>
    if(f->ref == 0){
    800049d6:	40dc                	lw	a5,4(s1)
    800049d8:	cf99                	beqz	a5,800049f6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049da:	02848493          	addi	s1,s1,40
    800049de:	fee49ce3          	bne	s1,a4,800049d6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049e2:	0001d517          	auipc	a0,0x1d
    800049e6:	3d650513          	addi	a0,a0,982 # 80021db8 <ftable>
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	304080e7          	jalr	772(ra) # 80000cee <release>
  return 0;
    800049f2:	4481                	li	s1,0
    800049f4:	a819                	j	80004a0a <filealloc+0x5e>
      f->ref = 1;
    800049f6:	4785                	li	a5,1
    800049f8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049fa:	0001d517          	auipc	a0,0x1d
    800049fe:	3be50513          	addi	a0,a0,958 # 80021db8 <ftable>
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	2ec080e7          	jalr	748(ra) # 80000cee <release>
}
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	60e2                	ld	ra,24(sp)
    80004a0e:	6442                	ld	s0,16(sp)
    80004a10:	64a2                	ld	s1,8(sp)
    80004a12:	6105                	addi	sp,sp,32
    80004a14:	8082                	ret

0000000080004a16 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a16:	1101                	addi	sp,sp,-32
    80004a18:	ec06                	sd	ra,24(sp)
    80004a1a:	e822                	sd	s0,16(sp)
    80004a1c:	e426                	sd	s1,8(sp)
    80004a1e:	1000                	addi	s0,sp,32
    80004a20:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a22:	0001d517          	auipc	a0,0x1d
    80004a26:	39650513          	addi	a0,a0,918 # 80021db8 <ftable>
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	210080e7          	jalr	528(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004a32:	40dc                	lw	a5,4(s1)
    80004a34:	02f05263          	blez	a5,80004a58 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a38:	2785                	addiw	a5,a5,1
    80004a3a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a3c:	0001d517          	auipc	a0,0x1d
    80004a40:	37c50513          	addi	a0,a0,892 # 80021db8 <ftable>
    80004a44:	ffffc097          	auipc	ra,0xffffc
    80004a48:	2aa080e7          	jalr	682(ra) # 80000cee <release>
  return f;
}
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	60e2                	ld	ra,24(sp)
    80004a50:	6442                	ld	s0,16(sp)
    80004a52:	64a2                	ld	s1,8(sp)
    80004a54:	6105                	addi	sp,sp,32
    80004a56:	8082                	ret
    panic("filedup");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	d6850513          	addi	a0,a0,-664 # 800087c0 <syscalls+0x258>
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	b6c080e7          	jalr	-1172(ra) # 800005cc <panic>

0000000080004a68 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a68:	7139                	addi	sp,sp,-64
    80004a6a:	fc06                	sd	ra,56(sp)
    80004a6c:	f822                	sd	s0,48(sp)
    80004a6e:	f426                	sd	s1,40(sp)
    80004a70:	f04a                	sd	s2,32(sp)
    80004a72:	ec4e                	sd	s3,24(sp)
    80004a74:	e852                	sd	s4,16(sp)
    80004a76:	e456                	sd	s5,8(sp)
    80004a78:	0080                	addi	s0,sp,64
    80004a7a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a7c:	0001d517          	auipc	a0,0x1d
    80004a80:	33c50513          	addi	a0,a0,828 # 80021db8 <ftable>
    80004a84:	ffffc097          	auipc	ra,0xffffc
    80004a88:	1b6080e7          	jalr	438(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004a8c:	40dc                	lw	a5,4(s1)
    80004a8e:	06f05163          	blez	a5,80004af0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a92:	37fd                	addiw	a5,a5,-1
    80004a94:	0007871b          	sext.w	a4,a5
    80004a98:	c0dc                	sw	a5,4(s1)
    80004a9a:	06e04363          	bgtz	a4,80004b00 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a9e:	0004a903          	lw	s2,0(s1)
    80004aa2:	0094ca83          	lbu	s5,9(s1)
    80004aa6:	0104ba03          	ld	s4,16(s1)
    80004aaa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004aae:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004ab2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004ab6:	0001d517          	auipc	a0,0x1d
    80004aba:	30250513          	addi	a0,a0,770 # 80021db8 <ftable>
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	230080e7          	jalr	560(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004ac6:	4785                	li	a5,1
    80004ac8:	04f90d63          	beq	s2,a5,80004b22 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004acc:	3979                	addiw	s2,s2,-2
    80004ace:	4785                	li	a5,1
    80004ad0:	0527e063          	bltu	a5,s2,80004b10 <fileclose+0xa8>
    begin_op();
    80004ad4:	00000097          	auipc	ra,0x0
    80004ad8:	ac8080e7          	jalr	-1336(ra) # 8000459c <begin_op>
    iput(ff.ip);
    80004adc:	854e                	mv	a0,s3
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	2a6080e7          	jalr	678(ra) # 80003d84 <iput>
    end_op();
    80004ae6:	00000097          	auipc	ra,0x0
    80004aea:	b36080e7          	jalr	-1226(ra) # 8000461c <end_op>
    80004aee:	a00d                	j	80004b10 <fileclose+0xa8>
    panic("fileclose");
    80004af0:	00004517          	auipc	a0,0x4
    80004af4:	cd850513          	addi	a0,a0,-808 # 800087c8 <syscalls+0x260>
    80004af8:	ffffc097          	auipc	ra,0xffffc
    80004afc:	ad4080e7          	jalr	-1324(ra) # 800005cc <panic>
    release(&ftable.lock);
    80004b00:	0001d517          	auipc	a0,0x1d
    80004b04:	2b850513          	addi	a0,a0,696 # 80021db8 <ftable>
    80004b08:	ffffc097          	auipc	ra,0xffffc
    80004b0c:	1e6080e7          	jalr	486(ra) # 80000cee <release>
  }
}
    80004b10:	70e2                	ld	ra,56(sp)
    80004b12:	7442                	ld	s0,48(sp)
    80004b14:	74a2                	ld	s1,40(sp)
    80004b16:	7902                	ld	s2,32(sp)
    80004b18:	69e2                	ld	s3,24(sp)
    80004b1a:	6a42                	ld	s4,16(sp)
    80004b1c:	6aa2                	ld	s5,8(sp)
    80004b1e:	6121                	addi	sp,sp,64
    80004b20:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b22:	85d6                	mv	a1,s5
    80004b24:	8552                	mv	a0,s4
    80004b26:	00000097          	auipc	ra,0x0
    80004b2a:	34c080e7          	jalr	844(ra) # 80004e72 <pipeclose>
    80004b2e:	b7cd                	j	80004b10 <fileclose+0xa8>

0000000080004b30 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b30:	715d                	addi	sp,sp,-80
    80004b32:	e486                	sd	ra,72(sp)
    80004b34:	e0a2                	sd	s0,64(sp)
    80004b36:	fc26                	sd	s1,56(sp)
    80004b38:	f84a                	sd	s2,48(sp)
    80004b3a:	f44e                	sd	s3,40(sp)
    80004b3c:	0880                	addi	s0,sp,80
    80004b3e:	84aa                	mv	s1,a0
    80004b40:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b42:	ffffd097          	auipc	ra,0xffffd
    80004b46:	12a080e7          	jalr	298(ra) # 80001c6c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b4a:	409c                	lw	a5,0(s1)
    80004b4c:	37f9                	addiw	a5,a5,-2
    80004b4e:	4705                	li	a4,1
    80004b50:	04f76763          	bltu	a4,a5,80004b9e <filestat+0x6e>
    80004b54:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b56:	6c88                	ld	a0,24(s1)
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	072080e7          	jalr	114(ra) # 80003bca <ilock>
    stati(f->ip, &st);
    80004b60:	fb840593          	addi	a1,s0,-72
    80004b64:	6c88                	ld	a0,24(s1)
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	2ee080e7          	jalr	750(ra) # 80003e54 <stati>
    iunlock(f->ip);
    80004b6e:	6c88                	ld	a0,24(s1)
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	11c080e7          	jalr	284(ra) # 80003c8c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b78:	46e1                	li	a3,24
    80004b7a:	fb840613          	addi	a2,s0,-72
    80004b7e:	85ce                	mv	a1,s3
    80004b80:	05893503          	ld	a0,88(s2)
    80004b84:	ffffd097          	auipc	ra,0xffffd
    80004b88:	cd8080e7          	jalr	-808(ra) # 8000185c <copyout>
    80004b8c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b90:	60a6                	ld	ra,72(sp)
    80004b92:	6406                	ld	s0,64(sp)
    80004b94:	74e2                	ld	s1,56(sp)
    80004b96:	7942                	ld	s2,48(sp)
    80004b98:	79a2                	ld	s3,40(sp)
    80004b9a:	6161                	addi	sp,sp,80
    80004b9c:	8082                	ret
  return -1;
    80004b9e:	557d                	li	a0,-1
    80004ba0:	bfc5                	j	80004b90 <filestat+0x60>

0000000080004ba2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004ba2:	7179                	addi	sp,sp,-48
    80004ba4:	f406                	sd	ra,40(sp)
    80004ba6:	f022                	sd	s0,32(sp)
    80004ba8:	ec26                	sd	s1,24(sp)
    80004baa:	e84a                	sd	s2,16(sp)
    80004bac:	e44e                	sd	s3,8(sp)
    80004bae:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004bb0:	00854783          	lbu	a5,8(a0)
    80004bb4:	c3d5                	beqz	a5,80004c58 <fileread+0xb6>
    80004bb6:	84aa                	mv	s1,a0
    80004bb8:	89ae                	mv	s3,a1
    80004bba:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004bbc:	411c                	lw	a5,0(a0)
    80004bbe:	4705                	li	a4,1
    80004bc0:	04e78963          	beq	a5,a4,80004c12 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004bc4:	470d                	li	a4,3
    80004bc6:	04e78d63          	beq	a5,a4,80004c20 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004bca:	4709                	li	a4,2
    80004bcc:	06e79e63          	bne	a5,a4,80004c48 <fileread+0xa6>
    ilock(f->ip);
    80004bd0:	6d08                	ld	a0,24(a0)
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	ff8080e7          	jalr	-8(ra) # 80003bca <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004bda:	874a                	mv	a4,s2
    80004bdc:	5094                	lw	a3,32(s1)
    80004bde:	864e                	mv	a2,s3
    80004be0:	4585                	li	a1,1
    80004be2:	6c88                	ld	a0,24(s1)
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	29a080e7          	jalr	666(ra) # 80003e7e <readi>
    80004bec:	892a                	mv	s2,a0
    80004bee:	00a05563          	blez	a0,80004bf8 <fileread+0x56>
      f->off += r;
    80004bf2:	509c                	lw	a5,32(s1)
    80004bf4:	9fa9                	addw	a5,a5,a0
    80004bf6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004bf8:	6c88                	ld	a0,24(s1)
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	092080e7          	jalr	146(ra) # 80003c8c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004c02:	854a                	mv	a0,s2
    80004c04:	70a2                	ld	ra,40(sp)
    80004c06:	7402                	ld	s0,32(sp)
    80004c08:	64e2                	ld	s1,24(sp)
    80004c0a:	6942                	ld	s2,16(sp)
    80004c0c:	69a2                	ld	s3,8(sp)
    80004c0e:	6145                	addi	sp,sp,48
    80004c10:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c12:	6908                	ld	a0,16(a0)
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	3c0080e7          	jalr	960(ra) # 80004fd4 <piperead>
    80004c1c:	892a                	mv	s2,a0
    80004c1e:	b7d5                	j	80004c02 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c20:	02451783          	lh	a5,36(a0)
    80004c24:	03079693          	slli	a3,a5,0x30
    80004c28:	92c1                	srli	a3,a3,0x30
    80004c2a:	4725                	li	a4,9
    80004c2c:	02d76863          	bltu	a4,a3,80004c5c <fileread+0xba>
    80004c30:	0792                	slli	a5,a5,0x4
    80004c32:	0001d717          	auipc	a4,0x1d
    80004c36:	0e670713          	addi	a4,a4,230 # 80021d18 <devsw>
    80004c3a:	97ba                	add	a5,a5,a4
    80004c3c:	639c                	ld	a5,0(a5)
    80004c3e:	c38d                	beqz	a5,80004c60 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004c40:	4505                	li	a0,1
    80004c42:	9782                	jalr	a5
    80004c44:	892a                	mv	s2,a0
    80004c46:	bf75                	j	80004c02 <fileread+0x60>
    panic("fileread");
    80004c48:	00004517          	auipc	a0,0x4
    80004c4c:	b9050513          	addi	a0,a0,-1136 # 800087d8 <syscalls+0x270>
    80004c50:	ffffc097          	auipc	ra,0xffffc
    80004c54:	97c080e7          	jalr	-1668(ra) # 800005cc <panic>
    return -1;
    80004c58:	597d                	li	s2,-1
    80004c5a:	b765                	j	80004c02 <fileread+0x60>
      return -1;
    80004c5c:	597d                	li	s2,-1
    80004c5e:	b755                	j	80004c02 <fileread+0x60>
    80004c60:	597d                	li	s2,-1
    80004c62:	b745                	j	80004c02 <fileread+0x60>

0000000080004c64 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004c64:	715d                	addi	sp,sp,-80
    80004c66:	e486                	sd	ra,72(sp)
    80004c68:	e0a2                	sd	s0,64(sp)
    80004c6a:	fc26                	sd	s1,56(sp)
    80004c6c:	f84a                	sd	s2,48(sp)
    80004c6e:	f44e                	sd	s3,40(sp)
    80004c70:	f052                	sd	s4,32(sp)
    80004c72:	ec56                	sd	s5,24(sp)
    80004c74:	e85a                	sd	s6,16(sp)
    80004c76:	e45e                	sd	s7,8(sp)
    80004c78:	e062                	sd	s8,0(sp)
    80004c7a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004c7c:	00954783          	lbu	a5,9(a0)
    80004c80:	10078663          	beqz	a5,80004d8c <filewrite+0x128>
    80004c84:	892a                	mv	s2,a0
    80004c86:	8aae                	mv	s5,a1
    80004c88:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c8a:	411c                	lw	a5,0(a0)
    80004c8c:	4705                	li	a4,1
    80004c8e:	02e78263          	beq	a5,a4,80004cb2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c92:	470d                	li	a4,3
    80004c94:	02e78663          	beq	a5,a4,80004cc0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c98:	4709                	li	a4,2
    80004c9a:	0ee79163          	bne	a5,a4,80004d7c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c9e:	0ac05d63          	blez	a2,80004d58 <filewrite+0xf4>
    int i = 0;
    80004ca2:	4981                	li	s3,0
    80004ca4:	6b05                	lui	s6,0x1
    80004ca6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004caa:	6b85                	lui	s7,0x1
    80004cac:	c00b8b9b          	addiw	s7,s7,-1024
    80004cb0:	a861                	j	80004d48 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004cb2:	6908                	ld	a0,16(a0)
    80004cb4:	00000097          	auipc	ra,0x0
    80004cb8:	22e080e7          	jalr	558(ra) # 80004ee2 <pipewrite>
    80004cbc:	8a2a                	mv	s4,a0
    80004cbe:	a045                	j	80004d5e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004cc0:	02451783          	lh	a5,36(a0)
    80004cc4:	03079693          	slli	a3,a5,0x30
    80004cc8:	92c1                	srli	a3,a3,0x30
    80004cca:	4725                	li	a4,9
    80004ccc:	0cd76263          	bltu	a4,a3,80004d90 <filewrite+0x12c>
    80004cd0:	0792                	slli	a5,a5,0x4
    80004cd2:	0001d717          	auipc	a4,0x1d
    80004cd6:	04670713          	addi	a4,a4,70 # 80021d18 <devsw>
    80004cda:	97ba                	add	a5,a5,a4
    80004cdc:	679c                	ld	a5,8(a5)
    80004cde:	cbdd                	beqz	a5,80004d94 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004ce0:	4505                	li	a0,1
    80004ce2:	9782                	jalr	a5
    80004ce4:	8a2a                	mv	s4,a0
    80004ce6:	a8a5                	j	80004d5e <filewrite+0xfa>
    80004ce8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004cec:	00000097          	auipc	ra,0x0
    80004cf0:	8b0080e7          	jalr	-1872(ra) # 8000459c <begin_op>
      ilock(f->ip);
    80004cf4:	01893503          	ld	a0,24(s2)
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	ed2080e7          	jalr	-302(ra) # 80003bca <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d00:	8762                	mv	a4,s8
    80004d02:	02092683          	lw	a3,32(s2)
    80004d06:	01598633          	add	a2,s3,s5
    80004d0a:	4585                	li	a1,1
    80004d0c:	01893503          	ld	a0,24(s2)
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	266080e7          	jalr	614(ra) # 80003f76 <writei>
    80004d18:	84aa                	mv	s1,a0
    80004d1a:	00a05763          	blez	a0,80004d28 <filewrite+0xc4>
        f->off += r;
    80004d1e:	02092783          	lw	a5,32(s2)
    80004d22:	9fa9                	addw	a5,a5,a0
    80004d24:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d28:	01893503          	ld	a0,24(s2)
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	f60080e7          	jalr	-160(ra) # 80003c8c <iunlock>
      end_op();
    80004d34:	00000097          	auipc	ra,0x0
    80004d38:	8e8080e7          	jalr	-1816(ra) # 8000461c <end_op>

      if(r != n1){
    80004d3c:	009c1f63          	bne	s8,s1,80004d5a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004d40:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004d44:	0149db63          	bge	s3,s4,80004d5a <filewrite+0xf6>
      int n1 = n - i;
    80004d48:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004d4c:	84be                	mv	s1,a5
    80004d4e:	2781                	sext.w	a5,a5
    80004d50:	f8fb5ce3          	bge	s6,a5,80004ce8 <filewrite+0x84>
    80004d54:	84de                	mv	s1,s7
    80004d56:	bf49                	j	80004ce8 <filewrite+0x84>
    int i = 0;
    80004d58:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004d5a:	013a1f63          	bne	s4,s3,80004d78 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d5e:	8552                	mv	a0,s4
    80004d60:	60a6                	ld	ra,72(sp)
    80004d62:	6406                	ld	s0,64(sp)
    80004d64:	74e2                	ld	s1,56(sp)
    80004d66:	7942                	ld	s2,48(sp)
    80004d68:	79a2                	ld	s3,40(sp)
    80004d6a:	7a02                	ld	s4,32(sp)
    80004d6c:	6ae2                	ld	s5,24(sp)
    80004d6e:	6b42                	ld	s6,16(sp)
    80004d70:	6ba2                	ld	s7,8(sp)
    80004d72:	6c02                	ld	s8,0(sp)
    80004d74:	6161                	addi	sp,sp,80
    80004d76:	8082                	ret
    ret = (i == n ? n : -1);
    80004d78:	5a7d                	li	s4,-1
    80004d7a:	b7d5                	j	80004d5e <filewrite+0xfa>
    panic("filewrite");
    80004d7c:	00004517          	auipc	a0,0x4
    80004d80:	a6c50513          	addi	a0,a0,-1428 # 800087e8 <syscalls+0x280>
    80004d84:	ffffc097          	auipc	ra,0xffffc
    80004d88:	848080e7          	jalr	-1976(ra) # 800005cc <panic>
    return -1;
    80004d8c:	5a7d                	li	s4,-1
    80004d8e:	bfc1                	j	80004d5e <filewrite+0xfa>
      return -1;
    80004d90:	5a7d                	li	s4,-1
    80004d92:	b7f1                	j	80004d5e <filewrite+0xfa>
    80004d94:	5a7d                	li	s4,-1
    80004d96:	b7e1                	j	80004d5e <filewrite+0xfa>

0000000080004d98 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d98:	7179                	addi	sp,sp,-48
    80004d9a:	f406                	sd	ra,40(sp)
    80004d9c:	f022                	sd	s0,32(sp)
    80004d9e:	ec26                	sd	s1,24(sp)
    80004da0:	e84a                	sd	s2,16(sp)
    80004da2:	e44e                	sd	s3,8(sp)
    80004da4:	e052                	sd	s4,0(sp)
    80004da6:	1800                	addi	s0,sp,48
    80004da8:	84aa                	mv	s1,a0
    80004daa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004dac:	0005b023          	sd	zero,0(a1)
    80004db0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	bf8080e7          	jalr	-1032(ra) # 800049ac <filealloc>
    80004dbc:	e088                	sd	a0,0(s1)
    80004dbe:	c551                	beqz	a0,80004e4a <pipealloc+0xb2>
    80004dc0:	00000097          	auipc	ra,0x0
    80004dc4:	bec080e7          	jalr	-1044(ra) # 800049ac <filealloc>
    80004dc8:	00aa3023          	sd	a0,0(s4)
    80004dcc:	c92d                	beqz	a0,80004e3e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004dce:	ffffc097          	auipc	ra,0xffffc
    80004dd2:	d7c080e7          	jalr	-644(ra) # 80000b4a <kalloc>
    80004dd6:	892a                	mv	s2,a0
    80004dd8:	c125                	beqz	a0,80004e38 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004dda:	4985                	li	s3,1
    80004ddc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004de0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004de4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004de8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004dec:	00004597          	auipc	a1,0x4
    80004df0:	a0c58593          	addi	a1,a1,-1524 # 800087f8 <syscalls+0x290>
    80004df4:	ffffc097          	auipc	ra,0xffffc
    80004df8:	db6080e7          	jalr	-586(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004dfc:	609c                	ld	a5,0(s1)
    80004dfe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e02:	609c                	ld	a5,0(s1)
    80004e04:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e08:	609c                	ld	a5,0(s1)
    80004e0a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e0e:	609c                	ld	a5,0(s1)
    80004e10:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e14:	000a3783          	ld	a5,0(s4)
    80004e18:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e1c:	000a3783          	ld	a5,0(s4)
    80004e20:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e24:	000a3783          	ld	a5,0(s4)
    80004e28:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e2c:	000a3783          	ld	a5,0(s4)
    80004e30:	0127b823          	sd	s2,16(a5)
  return 0;
    80004e34:	4501                	li	a0,0
    80004e36:	a025                	j	80004e5e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004e38:	6088                	ld	a0,0(s1)
    80004e3a:	e501                	bnez	a0,80004e42 <pipealloc+0xaa>
    80004e3c:	a039                	j	80004e4a <pipealloc+0xb2>
    80004e3e:	6088                	ld	a0,0(s1)
    80004e40:	c51d                	beqz	a0,80004e6e <pipealloc+0xd6>
    fileclose(*f0);
    80004e42:	00000097          	auipc	ra,0x0
    80004e46:	c26080e7          	jalr	-986(ra) # 80004a68 <fileclose>
  if(*f1)
    80004e4a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e4e:	557d                	li	a0,-1
  if(*f1)
    80004e50:	c799                	beqz	a5,80004e5e <pipealloc+0xc6>
    fileclose(*f1);
    80004e52:	853e                	mv	a0,a5
    80004e54:	00000097          	auipc	ra,0x0
    80004e58:	c14080e7          	jalr	-1004(ra) # 80004a68 <fileclose>
  return -1;
    80004e5c:	557d                	li	a0,-1
}
    80004e5e:	70a2                	ld	ra,40(sp)
    80004e60:	7402                	ld	s0,32(sp)
    80004e62:	64e2                	ld	s1,24(sp)
    80004e64:	6942                	ld	s2,16(sp)
    80004e66:	69a2                	ld	s3,8(sp)
    80004e68:	6a02                	ld	s4,0(sp)
    80004e6a:	6145                	addi	sp,sp,48
    80004e6c:	8082                	ret
  return -1;
    80004e6e:	557d                	li	a0,-1
    80004e70:	b7fd                	j	80004e5e <pipealloc+0xc6>

0000000080004e72 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e72:	1101                	addi	sp,sp,-32
    80004e74:	ec06                	sd	ra,24(sp)
    80004e76:	e822                	sd	s0,16(sp)
    80004e78:	e426                	sd	s1,8(sp)
    80004e7a:	e04a                	sd	s2,0(sp)
    80004e7c:	1000                	addi	s0,sp,32
    80004e7e:	84aa                	mv	s1,a0
    80004e80:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e82:	ffffc097          	auipc	ra,0xffffc
    80004e86:	db8080e7          	jalr	-584(ra) # 80000c3a <acquire>
  if(writable){
    80004e8a:	02090d63          	beqz	s2,80004ec4 <pipeclose+0x52>
    pi->writeopen = 0;
    80004e8e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e92:	21848513          	addi	a0,s1,536
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	812080e7          	jalr	-2030(ra) # 800026a8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e9e:	2204b783          	ld	a5,544(s1)
    80004ea2:	eb95                	bnez	a5,80004ed6 <pipeclose+0x64>
    release(&pi->lock);
    80004ea4:	8526                	mv	a0,s1
    80004ea6:	ffffc097          	auipc	ra,0xffffc
    80004eaa:	e48080e7          	jalr	-440(ra) # 80000cee <release>
    kfree((char*)pi);
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ffffc097          	auipc	ra,0xffffc
    80004eb4:	b9e080e7          	jalr	-1122(ra) # 80000a4e <kfree>
  } else
    release(&pi->lock);
}
    80004eb8:	60e2                	ld	ra,24(sp)
    80004eba:	6442                	ld	s0,16(sp)
    80004ebc:	64a2                	ld	s1,8(sp)
    80004ebe:	6902                	ld	s2,0(sp)
    80004ec0:	6105                	addi	sp,sp,32
    80004ec2:	8082                	ret
    pi->readopen = 0;
    80004ec4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ec8:	21c48513          	addi	a0,s1,540
    80004ecc:	ffffd097          	auipc	ra,0xffffd
    80004ed0:	7dc080e7          	jalr	2012(ra) # 800026a8 <wakeup>
    80004ed4:	b7e9                	j	80004e9e <pipeclose+0x2c>
    release(&pi->lock);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	ffffc097          	auipc	ra,0xffffc
    80004edc:	e16080e7          	jalr	-490(ra) # 80000cee <release>
}
    80004ee0:	bfe1                	j	80004eb8 <pipeclose+0x46>

0000000080004ee2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ee2:	711d                	addi	sp,sp,-96
    80004ee4:	ec86                	sd	ra,88(sp)
    80004ee6:	e8a2                	sd	s0,80(sp)
    80004ee8:	e4a6                	sd	s1,72(sp)
    80004eea:	e0ca                	sd	s2,64(sp)
    80004eec:	fc4e                	sd	s3,56(sp)
    80004eee:	f852                	sd	s4,48(sp)
    80004ef0:	f456                	sd	s5,40(sp)
    80004ef2:	f05a                	sd	s6,32(sp)
    80004ef4:	ec5e                	sd	s7,24(sp)
    80004ef6:	e862                	sd	s8,16(sp)
    80004ef8:	1080                	addi	s0,sp,96
    80004efa:	84aa                	mv	s1,a0
    80004efc:	8aae                	mv	s5,a1
    80004efe:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	d6c080e7          	jalr	-660(ra) # 80001c6c <myproc>
    80004f08:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f0a:	8526                	mv	a0,s1
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	d2e080e7          	jalr	-722(ra) # 80000c3a <acquire>
  while(i < n){
    80004f14:	0b405363          	blez	s4,80004fba <pipewrite+0xd8>
  int i = 0;
    80004f18:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f1a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f1c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f20:	21c48b93          	addi	s7,s1,540
    80004f24:	a089                	j	80004f66 <pipewrite+0x84>
      release(&pi->lock);
    80004f26:	8526                	mv	a0,s1
    80004f28:	ffffc097          	auipc	ra,0xffffc
    80004f2c:	dc6080e7          	jalr	-570(ra) # 80000cee <release>
      return -1;
    80004f30:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004f32:	854a                	mv	a0,s2
    80004f34:	60e6                	ld	ra,88(sp)
    80004f36:	6446                	ld	s0,80(sp)
    80004f38:	64a6                	ld	s1,72(sp)
    80004f3a:	6906                	ld	s2,64(sp)
    80004f3c:	79e2                	ld	s3,56(sp)
    80004f3e:	7a42                	ld	s4,48(sp)
    80004f40:	7aa2                	ld	s5,40(sp)
    80004f42:	7b02                	ld	s6,32(sp)
    80004f44:	6be2                	ld	s7,24(sp)
    80004f46:	6c42                	ld	s8,16(sp)
    80004f48:	6125                	addi	sp,sp,96
    80004f4a:	8082                	ret
      wakeup(&pi->nread);
    80004f4c:	8562                	mv	a0,s8
    80004f4e:	ffffd097          	auipc	ra,0xffffd
    80004f52:	75a080e7          	jalr	1882(ra) # 800026a8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004f56:	85a6                	mv	a1,s1
    80004f58:	855e                	mv	a0,s7
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	5c2080e7          	jalr	1474(ra) # 8000251c <sleep>
  while(i < n){
    80004f62:	05495d63          	bge	s2,s4,80004fbc <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004f66:	2204a783          	lw	a5,544(s1)
    80004f6a:	dfd5                	beqz	a5,80004f26 <pipewrite+0x44>
    80004f6c:	0289a783          	lw	a5,40(s3)
    80004f70:	fbdd                	bnez	a5,80004f26 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004f72:	2184a783          	lw	a5,536(s1)
    80004f76:	21c4a703          	lw	a4,540(s1)
    80004f7a:	2007879b          	addiw	a5,a5,512
    80004f7e:	fcf707e3          	beq	a4,a5,80004f4c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f82:	4685                	li	a3,1
    80004f84:	01590633          	add	a2,s2,s5
    80004f88:	faf40593          	addi	a1,s0,-81
    80004f8c:	0589b503          	ld	a0,88(s3)
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	9d2080e7          	jalr	-1582(ra) # 80001962 <copyin>
    80004f98:	03650263          	beq	a0,s6,80004fbc <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f9c:	21c4a783          	lw	a5,540(s1)
    80004fa0:	0017871b          	addiw	a4,a5,1
    80004fa4:	20e4ae23          	sw	a4,540(s1)
    80004fa8:	1ff7f793          	andi	a5,a5,511
    80004fac:	97a6                	add	a5,a5,s1
    80004fae:	faf44703          	lbu	a4,-81(s0)
    80004fb2:	00e78c23          	sb	a4,24(a5)
      i++;
    80004fb6:	2905                	addiw	s2,s2,1
    80004fb8:	b76d                	j	80004f62 <pipewrite+0x80>
  int i = 0;
    80004fba:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004fbc:	21848513          	addi	a0,s1,536
    80004fc0:	ffffd097          	auipc	ra,0xffffd
    80004fc4:	6e8080e7          	jalr	1768(ra) # 800026a8 <wakeup>
  release(&pi->lock);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	d24080e7          	jalr	-732(ra) # 80000cee <release>
  return i;
    80004fd2:	b785                	j	80004f32 <pipewrite+0x50>

0000000080004fd4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004fd4:	715d                	addi	sp,sp,-80
    80004fd6:	e486                	sd	ra,72(sp)
    80004fd8:	e0a2                	sd	s0,64(sp)
    80004fda:	fc26                	sd	s1,56(sp)
    80004fdc:	f84a                	sd	s2,48(sp)
    80004fde:	f44e                	sd	s3,40(sp)
    80004fe0:	f052                	sd	s4,32(sp)
    80004fe2:	ec56                	sd	s5,24(sp)
    80004fe4:	e85a                	sd	s6,16(sp)
    80004fe6:	0880                	addi	s0,sp,80
    80004fe8:	84aa                	mv	s1,a0
    80004fea:	892e                	mv	s2,a1
    80004fec:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004fee:	ffffd097          	auipc	ra,0xffffd
    80004ff2:	c7e080e7          	jalr	-898(ra) # 80001c6c <myproc>
    80004ff6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	c40080e7          	jalr	-960(ra) # 80000c3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005002:	2184a703          	lw	a4,536(s1)
    80005006:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000500a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000500e:	02f71463          	bne	a4,a5,80005036 <piperead+0x62>
    80005012:	2244a783          	lw	a5,548(s1)
    80005016:	c385                	beqz	a5,80005036 <piperead+0x62>
    if(pr->killed){
    80005018:	028a2783          	lw	a5,40(s4)
    8000501c:	ebc1                	bnez	a5,800050ac <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000501e:	85a6                	mv	a1,s1
    80005020:	854e                	mv	a0,s3
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	4fa080e7          	jalr	1274(ra) # 8000251c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000502a:	2184a703          	lw	a4,536(s1)
    8000502e:	21c4a783          	lw	a5,540(s1)
    80005032:	fef700e3          	beq	a4,a5,80005012 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005036:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005038:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000503a:	05505363          	blez	s5,80005080 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    8000503e:	2184a783          	lw	a5,536(s1)
    80005042:	21c4a703          	lw	a4,540(s1)
    80005046:	02f70d63          	beq	a4,a5,80005080 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000504a:	0017871b          	addiw	a4,a5,1
    8000504e:	20e4ac23          	sw	a4,536(s1)
    80005052:	1ff7f793          	andi	a5,a5,511
    80005056:	97a6                	add	a5,a5,s1
    80005058:	0187c783          	lbu	a5,24(a5)
    8000505c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005060:	4685                	li	a3,1
    80005062:	fbf40613          	addi	a2,s0,-65
    80005066:	85ca                	mv	a1,s2
    80005068:	058a3503          	ld	a0,88(s4)
    8000506c:	ffffc097          	auipc	ra,0xffffc
    80005070:	7f0080e7          	jalr	2032(ra) # 8000185c <copyout>
    80005074:	01650663          	beq	a0,s6,80005080 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005078:	2985                	addiw	s3,s3,1
    8000507a:	0905                	addi	s2,s2,1
    8000507c:	fd3a91e3          	bne	s5,s3,8000503e <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005080:	21c48513          	addi	a0,s1,540
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	624080e7          	jalr	1572(ra) # 800026a8 <wakeup>
  release(&pi->lock);
    8000508c:	8526                	mv	a0,s1
    8000508e:	ffffc097          	auipc	ra,0xffffc
    80005092:	c60080e7          	jalr	-928(ra) # 80000cee <release>
  return i;
}
    80005096:	854e                	mv	a0,s3
    80005098:	60a6                	ld	ra,72(sp)
    8000509a:	6406                	ld	s0,64(sp)
    8000509c:	74e2                	ld	s1,56(sp)
    8000509e:	7942                	ld	s2,48(sp)
    800050a0:	79a2                	ld	s3,40(sp)
    800050a2:	7a02                	ld	s4,32(sp)
    800050a4:	6ae2                	ld	s5,24(sp)
    800050a6:	6b42                	ld	s6,16(sp)
    800050a8:	6161                	addi	sp,sp,80
    800050aa:	8082                	ret
      release(&pi->lock);
    800050ac:	8526                	mv	a0,s1
    800050ae:	ffffc097          	auipc	ra,0xffffc
    800050b2:	c40080e7          	jalr	-960(ra) # 80000cee <release>
      return -1;
    800050b6:	59fd                	li	s3,-1
    800050b8:	bff9                	j	80005096 <piperead+0xc2>

00000000800050ba <exec>:
extern char trampoline[]; // trampoline.S
extern struct proc proc[NPROC];
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    800050ba:	dd010113          	addi	sp,sp,-560
    800050be:	22113423          	sd	ra,552(sp)
    800050c2:	22813023          	sd	s0,544(sp)
    800050c6:	20913c23          	sd	s1,536(sp)
    800050ca:	21213823          	sd	s2,528(sp)
    800050ce:	21313423          	sd	s3,520(sp)
    800050d2:	21413023          	sd	s4,512(sp)
    800050d6:	ffd6                	sd	s5,504(sp)
    800050d8:	fbda                	sd	s6,496(sp)
    800050da:	f7de                	sd	s7,488(sp)
    800050dc:	f3e2                	sd	s8,480(sp)
    800050de:	efe6                	sd	s9,472(sp)
    800050e0:	ebea                	sd	s10,464(sp)
    800050e2:	e7ee                	sd	s11,456(sp)
    800050e4:	1c00                	addi	s0,sp,560
    800050e6:	84aa                	mv	s1,a0
    800050e8:	dea43023          	sd	a0,-544(s0)
    800050ec:	deb43423          	sd	a1,-536(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800050f0:	ffffd097          	auipc	ra,0xffffd
    800050f4:	b7c080e7          	jalr	-1156(ra) # 80001c6c <myproc>
    800050f8:	dea43c23          	sd	a0,-520(s0)

  begin_op();
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	4a0080e7          	jalr	1184(ra) # 8000459c <begin_op>

  if ((ip = namei(path)) == 0) {
    80005104:	8526                	mv	a0,s1
    80005106:	fffff097          	auipc	ra,0xfffff
    8000510a:	27a080e7          	jalr	634(ra) # 80004380 <namei>
    8000510e:	cd2d                	beqz	a0,80005188 <exec+0xce>
    80005110:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	ab8080e7          	jalr	-1352(ra) # 80003bca <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000511a:	04000713          	li	a4,64
    8000511e:	4681                	li	a3,0
    80005120:	e4840613          	addi	a2,s0,-440
    80005124:	4581                	li	a1,0
    80005126:	8556                	mv	a0,s5
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	d56080e7          	jalr	-682(ra) # 80003e7e <readi>
    80005130:	04000793          	li	a5,64
    80005134:	00f51a63          	bne	a0,a5,80005148 <exec+0x8e>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    80005138:	e4842703          	lw	a4,-440(s0)
    8000513c:	464c47b7          	lui	a5,0x464c4
    80005140:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005144:	04f70863          	beq	a4,a5,80005194 <exec+0xda>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80005148:	8556                	mv	a0,s5
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	ce2080e7          	jalr	-798(ra) # 80003e2c <iunlockput>
    end_op();
    80005152:	fffff097          	auipc	ra,0xfffff
    80005156:	4ca080e7          	jalr	1226(ra) # 8000461c <end_op>
  }
  return -1;
    8000515a:	557d                	li	a0,-1
}
    8000515c:	22813083          	ld	ra,552(sp)
    80005160:	22013403          	ld	s0,544(sp)
    80005164:	21813483          	ld	s1,536(sp)
    80005168:	21013903          	ld	s2,528(sp)
    8000516c:	20813983          	ld	s3,520(sp)
    80005170:	20013a03          	ld	s4,512(sp)
    80005174:	7afe                	ld	s5,504(sp)
    80005176:	7b5e                	ld	s6,496(sp)
    80005178:	7bbe                	ld	s7,488(sp)
    8000517a:	7c1e                	ld	s8,480(sp)
    8000517c:	6cfe                	ld	s9,472(sp)
    8000517e:	6d5e                	ld	s10,464(sp)
    80005180:	6dbe                	ld	s11,456(sp)
    80005182:	23010113          	addi	sp,sp,560
    80005186:	8082                	ret
    end_op();
    80005188:	fffff097          	auipc	ra,0xfffff
    8000518c:	494080e7          	jalr	1172(ra) # 8000461c <end_op>
    return -1;
    80005190:	557d                	li	a0,-1
    80005192:	b7e9                	j	8000515c <exec+0xa2>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005194:	df843503          	ld	a0,-520(s0)
    80005198:	ffffd097          	auipc	ra,0xffffd
    8000519c:	b98080e7          	jalr	-1128(ra) # 80001d30 <proc_pagetable>
    800051a0:	8b2a                	mv	s6,a0
    800051a2:	d15d                	beqz	a0,80005148 <exec+0x8e>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051a4:	e6842783          	lw	a5,-408(s0)
    800051a8:	e8045703          	lhu	a4,-384(s0)
    800051ac:	c735                	beqz	a4,80005218 <exec+0x15e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    800051ae:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051b0:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    800051b4:	6a05                	lui	s4,0x1
    800051b6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800051ba:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    800051be:	6d85                	lui	s11,0x1
    800051c0:	7d7d                	lui	s10,0xfffff
    800051c2:	ac81                	j	80005412 <exec+0x358>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    800051c4:	00003517          	auipc	a0,0x3
    800051c8:	63c50513          	addi	a0,a0,1596 # 80008800 <syscalls+0x298>
    800051cc:	ffffb097          	auipc	ra,0xffffb
    800051d0:	400080e7          	jalr	1024(ra) # 800005cc <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800051d4:	874a                	mv	a4,s2
    800051d6:	009c86bb          	addw	a3,s9,s1
    800051da:	4581                	li	a1,0
    800051dc:	8556                	mv	a0,s5
    800051de:	fffff097          	auipc	ra,0xfffff
    800051e2:	ca0080e7          	jalr	-864(ra) # 80003e7e <readi>
    800051e6:	2501                	sext.w	a0,a0
    800051e8:	1ca91563          	bne	s2,a0,800053b2 <exec+0x2f8>
  for (i = 0; i < sz; i += PGSIZE) {
    800051ec:	009d84bb          	addw	s1,s11,s1
    800051f0:	013d09bb          	addw	s3,s10,s3
    800051f4:	1f74ff63          	bgeu	s1,s7,800053f2 <exec+0x338>
    pa = walkaddr(pagetable, va + i);
    800051f8:	02049593          	slli	a1,s1,0x20
    800051fc:	9181                	srli	a1,a1,0x20
    800051fe:	95e2                	add	a1,a1,s8
    80005200:	855a                	mv	a0,s6
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	ec2080e7          	jalr	-318(ra) # 800010c4 <walkaddr>
    8000520a:	862a                	mv	a2,a0
    if (pa == 0)
    8000520c:	dd45                	beqz	a0,800051c4 <exec+0x10a>
      n = PGSIZE;
    8000520e:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80005210:	fd49f2e3          	bgeu	s3,s4,800051d4 <exec+0x11a>
      n = sz - i;
    80005214:	894e                	mv	s2,s3
    80005216:	bf7d                	j	800051d4 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80005218:	4481                	li	s1,0
  iunlockput(ip);
    8000521a:	8556                	mv	a0,s5
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	c10080e7          	jalr	-1008(ra) # 80003e2c <iunlockput>
  end_op();
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	3f8080e7          	jalr	1016(ra) # 8000461c <end_op>
  uint64 oldsz = p->sz;
    8000522c:	df843983          	ld	s3,-520(s0)
    80005230:	0509bc83          	ld	s9,80(s3)
  sz = PGROUNDUP(sz);
    80005234:	6785                	lui	a5,0x1
    80005236:	17fd                	addi	a5,a5,-1
    80005238:	94be                	add	s1,s1,a5
    8000523a:	77fd                	lui	a5,0xfffff
    8000523c:	00f4f933          	and	s2,s1,a5
    80005240:	df243823          	sd	s2,-528(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + (1 << 6) * PGSIZE)) == 0)
    80005244:	000404b7          	lui	s1,0x40
    80005248:	94ca                	add	s1,s1,s2
    8000524a:	8626                	mv	a2,s1
    8000524c:	85ca                	mv	a1,s2
    8000524e:	855a                	mv	a0,s6
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	2b2080e7          	jalr	690(ra) # 80001502 <uvmalloc>
    80005258:	8baa                	mv	s7,a0
  ip = 0;
    8000525a:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + (1 << 6) * PGSIZE)) == 0)
    8000525c:	14050b63          	beqz	a0,800053b2 <exec+0x2f8>
  uvmapping(pagetable, p->k_pagetable, sz, sz + (1 << 6) * PGSIZE);
    80005260:	86a6                	mv	a3,s1
    80005262:	864a                	mv	a2,s2
    80005264:	0609b583          	ld	a1,96(s3)
    80005268:	855a                	mv	a0,s6
    8000526a:	ffffc097          	auipc	ra,0xffffc
    8000526e:	1aa080e7          	jalr	426(ra) # 80001414 <uvmapping>
  uvmclear(pagetable, sz - (1 << 6) * PGSIZE);
    80005272:	fffc05b7          	lui	a1,0xfffc0
    80005276:	95de                	add	a1,a1,s7
    80005278:	855a                	mv	a0,s6
    8000527a:	ffffc097          	auipc	ra,0xffffc
    8000527e:	5b0080e7          	jalr	1456(ra) # 8000182a <uvmclear>
  stackbase = sp - PGSIZE;
    80005282:	7afd                	lui	s5,0xfffff
    80005284:	9ade                	add	s5,s5,s7
  for (argc = 0; argv[argc]; argc++) {
    80005286:	de843783          	ld	a5,-536(s0)
    8000528a:	6388                	ld	a0,0(a5)
    8000528c:	c925                	beqz	a0,800052fc <exec+0x242>
    8000528e:	e8840993          	addi	s3,s0,-376
    80005292:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005296:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    80005298:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000529a:	ffffc097          	auipc	ra,0xffffc
    8000529e:	c20080e7          	jalr	-992(ra) # 80000eba <strlen>
    800052a2:	0015079b          	addiw	a5,a0,1
    800052a6:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052aa:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    800052ae:	13596663          	bltu	s2,s5,800053da <exec+0x320>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052b2:	de843d03          	ld	s10,-536(s0)
    800052b6:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800052ba:	8552                	mv	a0,s4
    800052bc:	ffffc097          	auipc	ra,0xffffc
    800052c0:	bfe080e7          	jalr	-1026(ra) # 80000eba <strlen>
    800052c4:	0015069b          	addiw	a3,a0,1
    800052c8:	8652                	mv	a2,s4
    800052ca:	85ca                	mv	a1,s2
    800052cc:	855a                	mv	a0,s6
    800052ce:	ffffc097          	auipc	ra,0xffffc
    800052d2:	58e080e7          	jalr	1422(ra) # 8000185c <copyout>
    800052d6:	10054663          	bltz	a0,800053e2 <exec+0x328>
    ustack[argc] = sp;
    800052da:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800052de:	0485                	addi	s1,s1,1
    800052e0:	008d0793          	addi	a5,s10,8
    800052e4:	def43423          	sd	a5,-536(s0)
    800052e8:	008d3503          	ld	a0,8(s10)
    800052ec:	c911                	beqz	a0,80005300 <exec+0x246>
    if (argc >= MAXARG)
    800052ee:	09a1                	addi	s3,s3,8
    800052f0:	fb3c15e3          	bne	s8,s3,8000529a <exec+0x1e0>
  sz = sz1;
    800052f4:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800052f8:	4a81                	li	s5,0
    800052fa:	a865                	j	800053b2 <exec+0x2f8>
  sp = sz;
    800052fc:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    800052fe:	4481                	li	s1,0
  ustack[argc] = 0;
    80005300:	00349793          	slli	a5,s1,0x3
    80005304:	f9040713          	addi	a4,s0,-112
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc + 1) * sizeof(uint64);
    8000530e:	00148693          	addi	a3,s1,1 # 40001 <_entry-0x7ffbffff>
    80005312:	068e                	slli	a3,a3,0x3
    80005314:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005318:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000531c:	01597663          	bgeu	s2,s5,80005328 <exec+0x26e>
  sz = sz1;
    80005320:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005324:	4a81                	li	s5,0
    80005326:	a071                	j	800053b2 <exec+0x2f8>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80005328:	e8840613          	addi	a2,s0,-376
    8000532c:	85ca                	mv	a1,s2
    8000532e:	855a                	mv	a0,s6
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	52c080e7          	jalr	1324(ra) # 8000185c <copyout>
    80005338:	0a054963          	bltz	a0,800053ea <exec+0x330>
  p->trapframe->a1 = sp;
    8000533c:	df843783          	ld	a5,-520(s0)
    80005340:	77bc                	ld	a5,104(a5)
    80005342:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80005346:	de043783          	ld	a5,-544(s0)
    8000534a:	0007c703          	lbu	a4,0(a5)
    8000534e:	cf11                	beqz	a4,8000536a <exec+0x2b0>
    80005350:	0785                	addi	a5,a5,1
    if (*s == '/')
    80005352:	02f00693          	li	a3,47
    80005356:	a039                	j	80005364 <exec+0x2aa>
      last = s + 1;
    80005358:	def43023          	sd	a5,-544(s0)
  for (last = s = path; *s; s++)
    8000535c:	0785                	addi	a5,a5,1
    8000535e:	fff7c703          	lbu	a4,-1(a5)
    80005362:	c701                	beqz	a4,8000536a <exec+0x2b0>
    if (*s == '/')
    80005364:	fed71ce3          	bne	a4,a3,8000535c <exec+0x2a2>
    80005368:	bfc5                	j	80005358 <exec+0x29e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000536a:	4641                	li	a2,16
    8000536c:	de043583          	ld	a1,-544(s0)
    80005370:	df843983          	ld	s3,-520(s0)
    80005374:	18098513          	addi	a0,s3,384
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	b10080e7          	jalr	-1264(ra) # 80000e88 <safestrcpy>
  oldpagetable = p->pagetable;
    80005380:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    80005384:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    80005388:	0579b823          	sd	s7,80(s3)
  p->trapframe->epc = elf.entry; // initial program counter = main
    8000538c:	0689b783          	ld	a5,104(s3)
    80005390:	e6043703          	ld	a4,-416(s0)
    80005394:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80005396:	0689b783          	ld	a5,104(s3)
    8000539a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000539e:	85e6                	mv	a1,s9
    800053a0:	ffffd097          	auipc	ra,0xffffd
    800053a4:	a2c080e7          	jalr	-1492(ra) # 80001dcc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053a8:	0004851b          	sext.w	a0,s1
    800053ac:	bb45                	j	8000515c <exec+0xa2>
    800053ae:	de943823          	sd	s1,-528(s0)
    proc_freepagetable(pagetable, sz);
    800053b2:	df043583          	ld	a1,-528(s0)
    800053b6:	855a                	mv	a0,s6
    800053b8:	ffffd097          	auipc	ra,0xffffd
    800053bc:	a14080e7          	jalr	-1516(ra) # 80001dcc <proc_freepagetable>
  if (ip) {
    800053c0:	d80a94e3          	bnez	s5,80005148 <exec+0x8e>
  return -1;
    800053c4:	557d                	li	a0,-1
    800053c6:	bb59                	j	8000515c <exec+0xa2>
    800053c8:	de943823          	sd	s1,-528(s0)
    800053cc:	b7dd                	j	800053b2 <exec+0x2f8>
    800053ce:	de943823          	sd	s1,-528(s0)
    800053d2:	b7c5                	j	800053b2 <exec+0x2f8>
    800053d4:	de943823          	sd	s1,-528(s0)
    800053d8:	bfe9                	j	800053b2 <exec+0x2f8>
  sz = sz1;
    800053da:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800053de:	4a81                	li	s5,0
    800053e0:	bfc9                	j	800053b2 <exec+0x2f8>
  sz = sz1;
    800053e2:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800053e6:	4a81                	li	s5,0
    800053e8:	b7e9                	j	800053b2 <exec+0x2f8>
  sz = sz1;
    800053ea:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800053ee:	4a81                	li	s5,0
    800053f0:	b7c9                	j	800053b2 <exec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800053f2:	df043483          	ld	s1,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800053f6:	e0843783          	ld	a5,-504(s0)
    800053fa:	0017869b          	addiw	a3,a5,1
    800053fe:	e0d43423          	sd	a3,-504(s0)
    80005402:	e0043783          	ld	a5,-512(s0)
    80005406:	0387879b          	addiw	a5,a5,56
    8000540a:	e8045703          	lhu	a4,-384(s0)
    8000540e:	e0e6d6e3          	bge	a3,a4,8000521a <exec+0x160>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005412:	2781                	sext.w	a5,a5
    80005414:	e0f43023          	sd	a5,-512(s0)
    80005418:	03800713          	li	a4,56
    8000541c:	86be                	mv	a3,a5
    8000541e:	e1040613          	addi	a2,s0,-496
    80005422:	4581                	li	a1,0
    80005424:	8556                	mv	a0,s5
    80005426:	fffff097          	auipc	ra,0xfffff
    8000542a:	a58080e7          	jalr	-1448(ra) # 80003e7e <readi>
    8000542e:	03800793          	li	a5,56
    80005432:	f6f51ee3          	bne	a0,a5,800053ae <exec+0x2f4>
    if (ph.type != ELF_PROG_LOAD)
    80005436:	e1042783          	lw	a5,-496(s0)
    8000543a:	4705                	li	a4,1
    8000543c:	fae79de3          	bne	a5,a4,800053f6 <exec+0x33c>
    if (ph.memsz < ph.filesz)
    80005440:	e3843603          	ld	a2,-456(s0)
    80005444:	e3043783          	ld	a5,-464(s0)
    80005448:	f8f660e3          	bltu	a2,a5,800053c8 <exec+0x30e>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    8000544c:	e2043783          	ld	a5,-480(s0)
    80005450:	963e                	add	a2,a2,a5
    80005452:	f6f66ee3          	bltu	a2,a5,800053ce <exec+0x314>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005456:	85a6                	mv	a1,s1
    80005458:	855a                	mv	a0,s6
    8000545a:	ffffc097          	auipc	ra,0xffffc
    8000545e:	0a8080e7          	jalr	168(ra) # 80001502 <uvmalloc>
    80005462:	dea43823          	sd	a0,-528(s0)
    80005466:	d53d                	beqz	a0,800053d4 <exec+0x31a>
    uvmapping(pagetable, p->k_pagetable, sz, ph.vaddr + ph.memsz);
    80005468:	e2043683          	ld	a3,-480(s0)
    8000546c:	e3843783          	ld	a5,-456(s0)
    80005470:	96be                	add	a3,a3,a5
    80005472:	8626                	mv	a2,s1
    80005474:	df843783          	ld	a5,-520(s0)
    80005478:	73ac                	ld	a1,96(a5)
    8000547a:	855a                	mv	a0,s6
    8000547c:	ffffc097          	auipc	ra,0xffffc
    80005480:	f98080e7          	jalr	-104(ra) # 80001414 <uvmapping>
    if (ph.vaddr % PGSIZE != 0)
    80005484:	e2043c03          	ld	s8,-480(s0)
    80005488:	dd843783          	ld	a5,-552(s0)
    8000548c:	00fc77b3          	and	a5,s8,a5
    80005490:	f38d                	bnez	a5,800053b2 <exec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005492:	e1842c83          	lw	s9,-488(s0)
    80005496:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000549a:	f40b8ce3          	beqz	s7,800053f2 <exec+0x338>
    8000549e:	89de                	mv	s3,s7
    800054a0:	4481                	li	s1,0
    800054a2:	bb99                	j	800051f8 <exec+0x13e>

00000000800054a4 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800054a4:	7179                	addi	sp,sp,-48
    800054a6:	f406                	sd	ra,40(sp)
    800054a8:	f022                	sd	s0,32(sp)
    800054aa:	ec26                	sd	s1,24(sp)
    800054ac:	e84a                	sd	s2,16(sp)
    800054ae:	1800                	addi	s0,sp,48
    800054b0:	892e                	mv	s2,a1
    800054b2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    800054b4:	fdc40593          	addi	a1,s0,-36
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	a86080e7          	jalr	-1402(ra) # 80002f3e <argint>
    800054c0:	04054063          	bltz	a0,80005500 <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800054c4:	fdc42703          	lw	a4,-36(s0)
    800054c8:	47bd                	li	a5,15
    800054ca:	02e7ed63          	bltu	a5,a4,80005504 <argfd+0x60>
    800054ce:	ffffc097          	auipc	ra,0xffffc
    800054d2:	79e080e7          	jalr	1950(ra) # 80001c6c <myproc>
    800054d6:	fdc42703          	lw	a4,-36(s0)
    800054da:	01c70793          	addi	a5,a4,28
    800054de:	078e                	slli	a5,a5,0x3
    800054e0:	953e                	add	a0,a0,a5
    800054e2:	611c                	ld	a5,0(a0)
    800054e4:	c395                	beqz	a5,80005508 <argfd+0x64>
    return -1;
  if (pfd)
    800054e6:	00090463          	beqz	s2,800054ee <argfd+0x4a>
    *pfd = fd;
    800054ea:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    800054ee:	4501                	li	a0,0
  if (pf)
    800054f0:	c091                	beqz	s1,800054f4 <argfd+0x50>
    *pf = f;
    800054f2:	e09c                	sd	a5,0(s1)
}
    800054f4:	70a2                	ld	ra,40(sp)
    800054f6:	7402                	ld	s0,32(sp)
    800054f8:	64e2                	ld	s1,24(sp)
    800054fa:	6942                	ld	s2,16(sp)
    800054fc:	6145                	addi	sp,sp,48
    800054fe:	8082                	ret
    return -1;
    80005500:	557d                	li	a0,-1
    80005502:	bfcd                	j	800054f4 <argfd+0x50>
    return -1;
    80005504:	557d                	li	a0,-1
    80005506:	b7fd                	j	800054f4 <argfd+0x50>
    80005508:	557d                	li	a0,-1
    8000550a:	b7ed                	j	800054f4 <argfd+0x50>

000000008000550c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    8000550c:	1101                	addi	sp,sp,-32
    8000550e:	ec06                	sd	ra,24(sp)
    80005510:	e822                	sd	s0,16(sp)
    80005512:	e426                	sd	s1,8(sp)
    80005514:	1000                	addi	s0,sp,32
    80005516:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005518:	ffffc097          	auipc	ra,0xffffc
    8000551c:	754080e7          	jalr	1876(ra) # 80001c6c <myproc>
    80005520:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80005522:	0e050793          	addi	a5,a0,224
    80005526:	4501                	li	a0,0
    80005528:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000552a:	6398                	ld	a4,0(a5)
    8000552c:	cb19                	beqz	a4,80005542 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    8000552e:	2505                	addiw	a0,a0,1
    80005530:	07a1                	addi	a5,a5,8
    80005532:	fed51ce3          	bne	a0,a3,8000552a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005536:	557d                	li	a0,-1
}
    80005538:	60e2                	ld	ra,24(sp)
    8000553a:	6442                	ld	s0,16(sp)
    8000553c:	64a2                	ld	s1,8(sp)
    8000553e:	6105                	addi	sp,sp,32
    80005540:	8082                	ret
      p->ofile[fd] = f;
    80005542:	01c50793          	addi	a5,a0,28
    80005546:	078e                	slli	a5,a5,0x3
    80005548:	963e                	add	a2,a2,a5
    8000554a:	e204                	sd	s1,0(a2)
      return fd;
    8000554c:	b7f5                	j	80005538 <fdalloc+0x2c>

000000008000554e <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    8000554e:	715d                	addi	sp,sp,-80
    80005550:	e486                	sd	ra,72(sp)
    80005552:	e0a2                	sd	s0,64(sp)
    80005554:	fc26                	sd	s1,56(sp)
    80005556:	f84a                	sd	s2,48(sp)
    80005558:	f44e                	sd	s3,40(sp)
    8000555a:	f052                	sd	s4,32(sp)
    8000555c:	ec56                	sd	s5,24(sp)
    8000555e:	0880                	addi	s0,sp,80
    80005560:	89ae                	mv	s3,a1
    80005562:	8ab2                	mv	s5,a2
    80005564:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80005566:	fb040593          	addi	a1,s0,-80
    8000556a:	fffff097          	auipc	ra,0xfffff
    8000556e:	e34080e7          	jalr	-460(ra) # 8000439e <nameiparent>
    80005572:	892a                	mv	s2,a0
    80005574:	12050e63          	beqz	a0,800056b0 <create+0x162>
    return 0;

  ilock(dp);
    80005578:	ffffe097          	auipc	ra,0xffffe
    8000557c:	652080e7          	jalr	1618(ra) # 80003bca <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80005580:	4601                	li	a2,0
    80005582:	fb040593          	addi	a1,s0,-80
    80005586:	854a                	mv	a0,s2
    80005588:	fffff097          	auipc	ra,0xfffff
    8000558c:	b26080e7          	jalr	-1242(ra) # 800040ae <dirlookup>
    80005590:	84aa                	mv	s1,a0
    80005592:	c921                	beqz	a0,800055e2 <create+0x94>
    iunlockput(dp);
    80005594:	854a                	mv	a0,s2
    80005596:	fffff097          	auipc	ra,0xfffff
    8000559a:	896080e7          	jalr	-1898(ra) # 80003e2c <iunlockput>
    ilock(ip);
    8000559e:	8526                	mv	a0,s1
    800055a0:	ffffe097          	auipc	ra,0xffffe
    800055a4:	62a080e7          	jalr	1578(ra) # 80003bca <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800055a8:	2981                	sext.w	s3,s3
    800055aa:	4789                	li	a5,2
    800055ac:	02f99463          	bne	s3,a5,800055d4 <create+0x86>
    800055b0:	0444d783          	lhu	a5,68(s1)
    800055b4:	37f9                	addiw	a5,a5,-2
    800055b6:	17c2                	slli	a5,a5,0x30
    800055b8:	93c1                	srli	a5,a5,0x30
    800055ba:	4705                	li	a4,1
    800055bc:	00f76c63          	bltu	a4,a5,800055d4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800055c0:	8526                	mv	a0,s1
    800055c2:	60a6                	ld	ra,72(sp)
    800055c4:	6406                	ld	s0,64(sp)
    800055c6:	74e2                	ld	s1,56(sp)
    800055c8:	7942                	ld	s2,48(sp)
    800055ca:	79a2                	ld	s3,40(sp)
    800055cc:	7a02                	ld	s4,32(sp)
    800055ce:	6ae2                	ld	s5,24(sp)
    800055d0:	6161                	addi	sp,sp,80
    800055d2:	8082                	ret
    iunlockput(ip);
    800055d4:	8526                	mv	a0,s1
    800055d6:	fffff097          	auipc	ra,0xfffff
    800055da:	856080e7          	jalr	-1962(ra) # 80003e2c <iunlockput>
    return 0;
    800055de:	4481                	li	s1,0
    800055e0:	b7c5                	j	800055c0 <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    800055e2:	85ce                	mv	a1,s3
    800055e4:	00092503          	lw	a0,0(s2)
    800055e8:	ffffe097          	auipc	ra,0xffffe
    800055ec:	44a080e7          	jalr	1098(ra) # 80003a32 <ialloc>
    800055f0:	84aa                	mv	s1,a0
    800055f2:	c521                	beqz	a0,8000563a <create+0xec>
  ilock(ip);
    800055f4:	ffffe097          	auipc	ra,0xffffe
    800055f8:	5d6080e7          	jalr	1494(ra) # 80003bca <ilock>
  ip->major = major;
    800055fc:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005600:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005604:	4a05                	li	s4,1
    80005606:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000560a:	8526                	mv	a0,s1
    8000560c:	ffffe097          	auipc	ra,0xffffe
    80005610:	4f4080e7          	jalr	1268(ra) # 80003b00 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80005614:	2981                	sext.w	s3,s3
    80005616:	03498a63          	beq	s3,s4,8000564a <create+0xfc>
  if (dirlink(dp, name, ip->inum) < 0)
    8000561a:	40d0                	lw	a2,4(s1)
    8000561c:	fb040593          	addi	a1,s0,-80
    80005620:	854a                	mv	a0,s2
    80005622:	fffff097          	auipc	ra,0xfffff
    80005626:	c9c080e7          	jalr	-868(ra) # 800042be <dirlink>
    8000562a:	06054b63          	bltz	a0,800056a0 <create+0x152>
  iunlockput(dp);
    8000562e:	854a                	mv	a0,s2
    80005630:	ffffe097          	auipc	ra,0xffffe
    80005634:	7fc080e7          	jalr	2044(ra) # 80003e2c <iunlockput>
  return ip;
    80005638:	b761                	j	800055c0 <create+0x72>
    panic("create: ialloc");
    8000563a:	00003517          	auipc	a0,0x3
    8000563e:	1e650513          	addi	a0,a0,486 # 80008820 <syscalls+0x2b8>
    80005642:	ffffb097          	auipc	ra,0xffffb
    80005646:	f8a080e7          	jalr	-118(ra) # 800005cc <panic>
    dp->nlink++;       // for ".."
    8000564a:	04a95783          	lhu	a5,74(s2)
    8000564e:	2785                	addiw	a5,a5,1
    80005650:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005654:	854a                	mv	a0,s2
    80005656:	ffffe097          	auipc	ra,0xffffe
    8000565a:	4aa080e7          	jalr	1194(ra) # 80003b00 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000565e:	40d0                	lw	a2,4(s1)
    80005660:	00003597          	auipc	a1,0x3
    80005664:	1d058593          	addi	a1,a1,464 # 80008830 <syscalls+0x2c8>
    80005668:	8526                	mv	a0,s1
    8000566a:	fffff097          	auipc	ra,0xfffff
    8000566e:	c54080e7          	jalr	-940(ra) # 800042be <dirlink>
    80005672:	00054f63          	bltz	a0,80005690 <create+0x142>
    80005676:	00492603          	lw	a2,4(s2)
    8000567a:	00003597          	auipc	a1,0x3
    8000567e:	bee58593          	addi	a1,a1,-1042 # 80008268 <digits+0x200>
    80005682:	8526                	mv	a0,s1
    80005684:	fffff097          	auipc	ra,0xfffff
    80005688:	c3a080e7          	jalr	-966(ra) # 800042be <dirlink>
    8000568c:	f80557e3          	bgez	a0,8000561a <create+0xcc>
      panic("create dots");
    80005690:	00003517          	auipc	a0,0x3
    80005694:	1a850513          	addi	a0,a0,424 # 80008838 <syscalls+0x2d0>
    80005698:	ffffb097          	auipc	ra,0xffffb
    8000569c:	f34080e7          	jalr	-204(ra) # 800005cc <panic>
    panic("create: dirlink");
    800056a0:	00003517          	auipc	a0,0x3
    800056a4:	1a850513          	addi	a0,a0,424 # 80008848 <syscalls+0x2e0>
    800056a8:	ffffb097          	auipc	ra,0xffffb
    800056ac:	f24080e7          	jalr	-220(ra) # 800005cc <panic>
    return 0;
    800056b0:	84aa                	mv	s1,a0
    800056b2:	b739                	j	800055c0 <create+0x72>

00000000800056b4 <sys_dup>:
uint64 sys_dup(void) {
    800056b4:	7179                	addi	sp,sp,-48
    800056b6:	f406                	sd	ra,40(sp)
    800056b8:	f022                	sd	s0,32(sp)
    800056ba:	ec26                	sd	s1,24(sp)
    800056bc:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    800056be:	fd840613          	addi	a2,s0,-40
    800056c2:	4581                	li	a1,0
    800056c4:	4501                	li	a0,0
    800056c6:	00000097          	auipc	ra,0x0
    800056ca:	dde080e7          	jalr	-546(ra) # 800054a4 <argfd>
    return -1;
    800056ce:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    800056d0:	02054363          	bltz	a0,800056f6 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    800056d4:	fd843503          	ld	a0,-40(s0)
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	e34080e7          	jalr	-460(ra) # 8000550c <fdalloc>
    800056e0:	84aa                	mv	s1,a0
    return -1;
    800056e2:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    800056e4:	00054963          	bltz	a0,800056f6 <sys_dup+0x42>
  filedup(f);
    800056e8:	fd843503          	ld	a0,-40(s0)
    800056ec:	fffff097          	auipc	ra,0xfffff
    800056f0:	32a080e7          	jalr	810(ra) # 80004a16 <filedup>
  return fd;
    800056f4:	87a6                	mv	a5,s1
}
    800056f6:	853e                	mv	a0,a5
    800056f8:	70a2                	ld	ra,40(sp)
    800056fa:	7402                	ld	s0,32(sp)
    800056fc:	64e2                	ld	s1,24(sp)
    800056fe:	6145                	addi	sp,sp,48
    80005700:	8082                	ret

0000000080005702 <sys_read>:
uint64 sys_read(void) {
    80005702:	7179                	addi	sp,sp,-48
    80005704:	f406                	sd	ra,40(sp)
    80005706:	f022                	sd	s0,32(sp)
    80005708:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000570a:	fe840613          	addi	a2,s0,-24
    8000570e:	4581                	li	a1,0
    80005710:	4501                	li	a0,0
    80005712:	00000097          	auipc	ra,0x0
    80005716:	d92080e7          	jalr	-622(ra) # 800054a4 <argfd>
    return -1;
    8000571a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000571c:	04054163          	bltz	a0,8000575e <sys_read+0x5c>
    80005720:	fe440593          	addi	a1,s0,-28
    80005724:	4509                	li	a0,2
    80005726:	ffffe097          	auipc	ra,0xffffe
    8000572a:	818080e7          	jalr	-2024(ra) # 80002f3e <argint>
    return -1;
    8000572e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005730:	02054763          	bltz	a0,8000575e <sys_read+0x5c>
    80005734:	fd840593          	addi	a1,s0,-40
    80005738:	4505                	li	a0,1
    8000573a:	ffffe097          	auipc	ra,0xffffe
    8000573e:	826080e7          	jalr	-2010(ra) # 80002f60 <argaddr>
    return -1;
    80005742:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005744:	00054d63          	bltz	a0,8000575e <sys_read+0x5c>
  return fileread(f, p, n);
    80005748:	fe442603          	lw	a2,-28(s0)
    8000574c:	fd843583          	ld	a1,-40(s0)
    80005750:	fe843503          	ld	a0,-24(s0)
    80005754:	fffff097          	auipc	ra,0xfffff
    80005758:	44e080e7          	jalr	1102(ra) # 80004ba2 <fileread>
    8000575c:	87aa                	mv	a5,a0
}
    8000575e:	853e                	mv	a0,a5
    80005760:	70a2                	ld	ra,40(sp)
    80005762:	7402                	ld	s0,32(sp)
    80005764:	6145                	addi	sp,sp,48
    80005766:	8082                	ret

0000000080005768 <sys_write>:
uint64 sys_write(void) {
    80005768:	7179                	addi	sp,sp,-48
    8000576a:	f406                	sd	ra,40(sp)
    8000576c:	f022                	sd	s0,32(sp)
    8000576e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005770:	fe840613          	addi	a2,s0,-24
    80005774:	4581                	li	a1,0
    80005776:	4501                	li	a0,0
    80005778:	00000097          	auipc	ra,0x0
    8000577c:	d2c080e7          	jalr	-724(ra) # 800054a4 <argfd>
    return -1;
    80005780:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005782:	04054163          	bltz	a0,800057c4 <sys_write+0x5c>
    80005786:	fe440593          	addi	a1,s0,-28
    8000578a:	4509                	li	a0,2
    8000578c:	ffffd097          	auipc	ra,0xffffd
    80005790:	7b2080e7          	jalr	1970(ra) # 80002f3e <argint>
    return -1;
    80005794:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005796:	02054763          	bltz	a0,800057c4 <sys_write+0x5c>
    8000579a:	fd840593          	addi	a1,s0,-40
    8000579e:	4505                	li	a0,1
    800057a0:	ffffd097          	auipc	ra,0xffffd
    800057a4:	7c0080e7          	jalr	1984(ra) # 80002f60 <argaddr>
    return -1;
    800057a8:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057aa:	00054d63          	bltz	a0,800057c4 <sys_write+0x5c>
  return filewrite(f, p, n);
    800057ae:	fe442603          	lw	a2,-28(s0)
    800057b2:	fd843583          	ld	a1,-40(s0)
    800057b6:	fe843503          	ld	a0,-24(s0)
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	4aa080e7          	jalr	1194(ra) # 80004c64 <filewrite>
    800057c2:	87aa                	mv	a5,a0
}
    800057c4:	853e                	mv	a0,a5
    800057c6:	70a2                	ld	ra,40(sp)
    800057c8:	7402                	ld	s0,32(sp)
    800057ca:	6145                	addi	sp,sp,48
    800057cc:	8082                	ret

00000000800057ce <sys_close>:
uint64 sys_close(void) {
    800057ce:	1101                	addi	sp,sp,-32
    800057d0:	ec06                	sd	ra,24(sp)
    800057d2:	e822                	sd	s0,16(sp)
    800057d4:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800057d6:	fe040613          	addi	a2,s0,-32
    800057da:	fec40593          	addi	a1,s0,-20
    800057de:	4501                	li	a0,0
    800057e0:	00000097          	auipc	ra,0x0
    800057e4:	cc4080e7          	jalr	-828(ra) # 800054a4 <argfd>
    return -1;
    800057e8:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    800057ea:	02054463          	bltz	a0,80005812 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800057ee:	ffffc097          	auipc	ra,0xffffc
    800057f2:	47e080e7          	jalr	1150(ra) # 80001c6c <myproc>
    800057f6:	fec42783          	lw	a5,-20(s0)
    800057fa:	07f1                	addi	a5,a5,28
    800057fc:	078e                	slli	a5,a5,0x3
    800057fe:	97aa                	add	a5,a5,a0
    80005800:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005804:	fe043503          	ld	a0,-32(s0)
    80005808:	fffff097          	auipc	ra,0xfffff
    8000580c:	260080e7          	jalr	608(ra) # 80004a68 <fileclose>
  return 0;
    80005810:	4781                	li	a5,0
}
    80005812:	853e                	mv	a0,a5
    80005814:	60e2                	ld	ra,24(sp)
    80005816:	6442                	ld	s0,16(sp)
    80005818:	6105                	addi	sp,sp,32
    8000581a:	8082                	ret

000000008000581c <sys_fstat>:
uint64 sys_fstat(void) {
    8000581c:	1101                	addi	sp,sp,-32
    8000581e:	ec06                	sd	ra,24(sp)
    80005820:	e822                	sd	s0,16(sp)
    80005822:	1000                	addi	s0,sp,32
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005824:	fe840613          	addi	a2,s0,-24
    80005828:	4581                	li	a1,0
    8000582a:	4501                	li	a0,0
    8000582c:	00000097          	auipc	ra,0x0
    80005830:	c78080e7          	jalr	-904(ra) # 800054a4 <argfd>
    return -1;
    80005834:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005836:	02054563          	bltz	a0,80005860 <sys_fstat+0x44>
    8000583a:	fe040593          	addi	a1,s0,-32
    8000583e:	4505                	li	a0,1
    80005840:	ffffd097          	auipc	ra,0xffffd
    80005844:	720080e7          	jalr	1824(ra) # 80002f60 <argaddr>
    return -1;
    80005848:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000584a:	00054b63          	bltz	a0,80005860 <sys_fstat+0x44>
  return filestat(f, st);
    8000584e:	fe043583          	ld	a1,-32(s0)
    80005852:	fe843503          	ld	a0,-24(s0)
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	2da080e7          	jalr	730(ra) # 80004b30 <filestat>
    8000585e:	87aa                	mv	a5,a0
}
    80005860:	853e                	mv	a0,a5
    80005862:	60e2                	ld	ra,24(sp)
    80005864:	6442                	ld	s0,16(sp)
    80005866:	6105                	addi	sp,sp,32
    80005868:	8082                	ret

000000008000586a <sys_link>:
uint64 sys_link(void) {
    8000586a:	7169                	addi	sp,sp,-304
    8000586c:	f606                	sd	ra,296(sp)
    8000586e:	f222                	sd	s0,288(sp)
    80005870:	ee26                	sd	s1,280(sp)
    80005872:	ea4a                	sd	s2,272(sp)
    80005874:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005876:	08000613          	li	a2,128
    8000587a:	ed040593          	addi	a1,s0,-304
    8000587e:	4501                	li	a0,0
    80005880:	ffffd097          	auipc	ra,0xffffd
    80005884:	702080e7          	jalr	1794(ra) # 80002f82 <argstr>
    return -1;
    80005888:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000588a:	10054e63          	bltz	a0,800059a6 <sys_link+0x13c>
    8000588e:	08000613          	li	a2,128
    80005892:	f5040593          	addi	a1,s0,-176
    80005896:	4505                	li	a0,1
    80005898:	ffffd097          	auipc	ra,0xffffd
    8000589c:	6ea080e7          	jalr	1770(ra) # 80002f82 <argstr>
    return -1;
    800058a0:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058a2:	10054263          	bltz	a0,800059a6 <sys_link+0x13c>
  begin_op();
    800058a6:	fffff097          	auipc	ra,0xfffff
    800058aa:	cf6080e7          	jalr	-778(ra) # 8000459c <begin_op>
  if ((ip = namei(old)) == 0) {
    800058ae:	ed040513          	addi	a0,s0,-304
    800058b2:	fffff097          	auipc	ra,0xfffff
    800058b6:	ace080e7          	jalr	-1330(ra) # 80004380 <namei>
    800058ba:	84aa                	mv	s1,a0
    800058bc:	c551                	beqz	a0,80005948 <sys_link+0xde>
  ilock(ip);
    800058be:	ffffe097          	auipc	ra,0xffffe
    800058c2:	30c080e7          	jalr	780(ra) # 80003bca <ilock>
  if (ip->type == T_DIR) {
    800058c6:	04449703          	lh	a4,68(s1)
    800058ca:	4785                	li	a5,1
    800058cc:	08f70463          	beq	a4,a5,80005954 <sys_link+0xea>
  ip->nlink++;
    800058d0:	04a4d783          	lhu	a5,74(s1)
    800058d4:	2785                	addiw	a5,a5,1
    800058d6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058da:	8526                	mv	a0,s1
    800058dc:	ffffe097          	auipc	ra,0xffffe
    800058e0:	224080e7          	jalr	548(ra) # 80003b00 <iupdate>
  iunlock(ip);
    800058e4:	8526                	mv	a0,s1
    800058e6:	ffffe097          	auipc	ra,0xffffe
    800058ea:	3a6080e7          	jalr	934(ra) # 80003c8c <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    800058ee:	fd040593          	addi	a1,s0,-48
    800058f2:	f5040513          	addi	a0,s0,-176
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	aa8080e7          	jalr	-1368(ra) # 8000439e <nameiparent>
    800058fe:	892a                	mv	s2,a0
    80005900:	c935                	beqz	a0,80005974 <sys_link+0x10a>
  ilock(dp);
    80005902:	ffffe097          	auipc	ra,0xffffe
    80005906:	2c8080e7          	jalr	712(ra) # 80003bca <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    8000590a:	00092703          	lw	a4,0(s2)
    8000590e:	409c                	lw	a5,0(s1)
    80005910:	04f71d63          	bne	a4,a5,8000596a <sys_link+0x100>
    80005914:	40d0                	lw	a2,4(s1)
    80005916:	fd040593          	addi	a1,s0,-48
    8000591a:	854a                	mv	a0,s2
    8000591c:	fffff097          	auipc	ra,0xfffff
    80005920:	9a2080e7          	jalr	-1630(ra) # 800042be <dirlink>
    80005924:	04054363          	bltz	a0,8000596a <sys_link+0x100>
  iunlockput(dp);
    80005928:	854a                	mv	a0,s2
    8000592a:	ffffe097          	auipc	ra,0xffffe
    8000592e:	502080e7          	jalr	1282(ra) # 80003e2c <iunlockput>
  iput(ip);
    80005932:	8526                	mv	a0,s1
    80005934:	ffffe097          	auipc	ra,0xffffe
    80005938:	450080e7          	jalr	1104(ra) # 80003d84 <iput>
  end_op();
    8000593c:	fffff097          	auipc	ra,0xfffff
    80005940:	ce0080e7          	jalr	-800(ra) # 8000461c <end_op>
  return 0;
    80005944:	4781                	li	a5,0
    80005946:	a085                	j	800059a6 <sys_link+0x13c>
    end_op();
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	cd4080e7          	jalr	-812(ra) # 8000461c <end_op>
    return -1;
    80005950:	57fd                	li	a5,-1
    80005952:	a891                	j	800059a6 <sys_link+0x13c>
    iunlockput(ip);
    80005954:	8526                	mv	a0,s1
    80005956:	ffffe097          	auipc	ra,0xffffe
    8000595a:	4d6080e7          	jalr	1238(ra) # 80003e2c <iunlockput>
    end_op();
    8000595e:	fffff097          	auipc	ra,0xfffff
    80005962:	cbe080e7          	jalr	-834(ra) # 8000461c <end_op>
    return -1;
    80005966:	57fd                	li	a5,-1
    80005968:	a83d                	j	800059a6 <sys_link+0x13c>
    iunlockput(dp);
    8000596a:	854a                	mv	a0,s2
    8000596c:	ffffe097          	auipc	ra,0xffffe
    80005970:	4c0080e7          	jalr	1216(ra) # 80003e2c <iunlockput>
  ilock(ip);
    80005974:	8526                	mv	a0,s1
    80005976:	ffffe097          	auipc	ra,0xffffe
    8000597a:	254080e7          	jalr	596(ra) # 80003bca <ilock>
  ip->nlink--;
    8000597e:	04a4d783          	lhu	a5,74(s1)
    80005982:	37fd                	addiw	a5,a5,-1
    80005984:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005988:	8526                	mv	a0,s1
    8000598a:	ffffe097          	auipc	ra,0xffffe
    8000598e:	176080e7          	jalr	374(ra) # 80003b00 <iupdate>
  iunlockput(ip);
    80005992:	8526                	mv	a0,s1
    80005994:	ffffe097          	auipc	ra,0xffffe
    80005998:	498080e7          	jalr	1176(ra) # 80003e2c <iunlockput>
  end_op();
    8000599c:	fffff097          	auipc	ra,0xfffff
    800059a0:	c80080e7          	jalr	-896(ra) # 8000461c <end_op>
  return -1;
    800059a4:	57fd                	li	a5,-1
}
    800059a6:	853e                	mv	a0,a5
    800059a8:	70b2                	ld	ra,296(sp)
    800059aa:	7412                	ld	s0,288(sp)
    800059ac:	64f2                	ld	s1,280(sp)
    800059ae:	6952                	ld	s2,272(sp)
    800059b0:	6155                	addi	sp,sp,304
    800059b2:	8082                	ret

00000000800059b4 <sys_unlink>:
uint64 sys_unlink(void) {
    800059b4:	7151                	addi	sp,sp,-240
    800059b6:	f586                	sd	ra,232(sp)
    800059b8:	f1a2                	sd	s0,224(sp)
    800059ba:	eda6                	sd	s1,216(sp)
    800059bc:	e9ca                	sd	s2,208(sp)
    800059be:	e5ce                	sd	s3,200(sp)
    800059c0:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800059c2:	08000613          	li	a2,128
    800059c6:	f3040593          	addi	a1,s0,-208
    800059ca:	4501                	li	a0,0
    800059cc:	ffffd097          	auipc	ra,0xffffd
    800059d0:	5b6080e7          	jalr	1462(ra) # 80002f82 <argstr>
    800059d4:	18054163          	bltz	a0,80005b56 <sys_unlink+0x1a2>
  begin_op();
    800059d8:	fffff097          	auipc	ra,0xfffff
    800059dc:	bc4080e7          	jalr	-1084(ra) # 8000459c <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800059e0:	fb040593          	addi	a1,s0,-80
    800059e4:	f3040513          	addi	a0,s0,-208
    800059e8:	fffff097          	auipc	ra,0xfffff
    800059ec:	9b6080e7          	jalr	-1610(ra) # 8000439e <nameiparent>
    800059f0:	84aa                	mv	s1,a0
    800059f2:	c979                	beqz	a0,80005ac8 <sys_unlink+0x114>
  ilock(dp);
    800059f4:	ffffe097          	auipc	ra,0xffffe
    800059f8:	1d6080e7          	jalr	470(ra) # 80003bca <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800059fc:	00003597          	auipc	a1,0x3
    80005a00:	e3458593          	addi	a1,a1,-460 # 80008830 <syscalls+0x2c8>
    80005a04:	fb040513          	addi	a0,s0,-80
    80005a08:	ffffe097          	auipc	ra,0xffffe
    80005a0c:	68c080e7          	jalr	1676(ra) # 80004094 <namecmp>
    80005a10:	14050a63          	beqz	a0,80005b64 <sys_unlink+0x1b0>
    80005a14:	00003597          	auipc	a1,0x3
    80005a18:	85458593          	addi	a1,a1,-1964 # 80008268 <digits+0x200>
    80005a1c:	fb040513          	addi	a0,s0,-80
    80005a20:	ffffe097          	auipc	ra,0xffffe
    80005a24:	674080e7          	jalr	1652(ra) # 80004094 <namecmp>
    80005a28:	12050e63          	beqz	a0,80005b64 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005a2c:	f2c40613          	addi	a2,s0,-212
    80005a30:	fb040593          	addi	a1,s0,-80
    80005a34:	8526                	mv	a0,s1
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	678080e7          	jalr	1656(ra) # 800040ae <dirlookup>
    80005a3e:	892a                	mv	s2,a0
    80005a40:	12050263          	beqz	a0,80005b64 <sys_unlink+0x1b0>
  ilock(ip);
    80005a44:	ffffe097          	auipc	ra,0xffffe
    80005a48:	186080e7          	jalr	390(ra) # 80003bca <ilock>
  if (ip->nlink < 1)
    80005a4c:	04a91783          	lh	a5,74(s2)
    80005a50:	08f05263          	blez	a5,80005ad4 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005a54:	04491703          	lh	a4,68(s2)
    80005a58:	4785                	li	a5,1
    80005a5a:	08f70563          	beq	a4,a5,80005ae4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005a5e:	4641                	li	a2,16
    80005a60:	4581                	li	a1,0
    80005a62:	fc040513          	addi	a0,s0,-64
    80005a66:	ffffb097          	auipc	ra,0xffffb
    80005a6a:	2d0080e7          	jalr	720(ra) # 80000d36 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a6e:	4741                	li	a4,16
    80005a70:	f2c42683          	lw	a3,-212(s0)
    80005a74:	fc040613          	addi	a2,s0,-64
    80005a78:	4581                	li	a1,0
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	4fa080e7          	jalr	1274(ra) # 80003f76 <writei>
    80005a84:	47c1                	li	a5,16
    80005a86:	0af51563          	bne	a0,a5,80005b30 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80005a8a:	04491703          	lh	a4,68(s2)
    80005a8e:	4785                	li	a5,1
    80005a90:	0af70863          	beq	a4,a5,80005b40 <sys_unlink+0x18c>
  iunlockput(dp);
    80005a94:	8526                	mv	a0,s1
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	396080e7          	jalr	918(ra) # 80003e2c <iunlockput>
  ip->nlink--;
    80005a9e:	04a95783          	lhu	a5,74(s2)
    80005aa2:	37fd                	addiw	a5,a5,-1
    80005aa4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005aa8:	854a                	mv	a0,s2
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	056080e7          	jalr	86(ra) # 80003b00 <iupdate>
  iunlockput(ip);
    80005ab2:	854a                	mv	a0,s2
    80005ab4:	ffffe097          	auipc	ra,0xffffe
    80005ab8:	378080e7          	jalr	888(ra) # 80003e2c <iunlockput>
  end_op();
    80005abc:	fffff097          	auipc	ra,0xfffff
    80005ac0:	b60080e7          	jalr	-1184(ra) # 8000461c <end_op>
  return 0;
    80005ac4:	4501                	li	a0,0
    80005ac6:	a84d                	j	80005b78 <sys_unlink+0x1c4>
    end_op();
    80005ac8:	fffff097          	auipc	ra,0xfffff
    80005acc:	b54080e7          	jalr	-1196(ra) # 8000461c <end_op>
    return -1;
    80005ad0:	557d                	li	a0,-1
    80005ad2:	a05d                	j	80005b78 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005ad4:	00003517          	auipc	a0,0x3
    80005ad8:	d8450513          	addi	a0,a0,-636 # 80008858 <syscalls+0x2f0>
    80005adc:	ffffb097          	auipc	ra,0xffffb
    80005ae0:	af0080e7          	jalr	-1296(ra) # 800005cc <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005ae4:	04c92703          	lw	a4,76(s2)
    80005ae8:	02000793          	li	a5,32
    80005aec:	f6e7f9e3          	bgeu	a5,a4,80005a5e <sys_unlink+0xaa>
    80005af0:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005af4:	4741                	li	a4,16
    80005af6:	86ce                	mv	a3,s3
    80005af8:	f1840613          	addi	a2,s0,-232
    80005afc:	4581                	li	a1,0
    80005afe:	854a                	mv	a0,s2
    80005b00:	ffffe097          	auipc	ra,0xffffe
    80005b04:	37e080e7          	jalr	894(ra) # 80003e7e <readi>
    80005b08:	47c1                	li	a5,16
    80005b0a:	00f51b63          	bne	a0,a5,80005b20 <sys_unlink+0x16c>
    if (de.inum != 0)
    80005b0e:	f1845783          	lhu	a5,-232(s0)
    80005b12:	e7a1                	bnez	a5,80005b5a <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005b14:	29c1                	addiw	s3,s3,16
    80005b16:	04c92783          	lw	a5,76(s2)
    80005b1a:	fcf9ede3          	bltu	s3,a5,80005af4 <sys_unlink+0x140>
    80005b1e:	b781                	j	80005a5e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005b20:	00003517          	auipc	a0,0x3
    80005b24:	d5050513          	addi	a0,a0,-688 # 80008870 <syscalls+0x308>
    80005b28:	ffffb097          	auipc	ra,0xffffb
    80005b2c:	aa4080e7          	jalr	-1372(ra) # 800005cc <panic>
    panic("unlink: writei");
    80005b30:	00003517          	auipc	a0,0x3
    80005b34:	d5850513          	addi	a0,a0,-680 # 80008888 <syscalls+0x320>
    80005b38:	ffffb097          	auipc	ra,0xffffb
    80005b3c:	a94080e7          	jalr	-1388(ra) # 800005cc <panic>
    dp->nlink--;
    80005b40:	04a4d783          	lhu	a5,74(s1)
    80005b44:	37fd                	addiw	a5,a5,-1
    80005b46:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b4a:	8526                	mv	a0,s1
    80005b4c:	ffffe097          	auipc	ra,0xffffe
    80005b50:	fb4080e7          	jalr	-76(ra) # 80003b00 <iupdate>
    80005b54:	b781                	j	80005a94 <sys_unlink+0xe0>
    return -1;
    80005b56:	557d                	li	a0,-1
    80005b58:	a005                	j	80005b78 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005b5a:	854a                	mv	a0,s2
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	2d0080e7          	jalr	720(ra) # 80003e2c <iunlockput>
  iunlockput(dp);
    80005b64:	8526                	mv	a0,s1
    80005b66:	ffffe097          	auipc	ra,0xffffe
    80005b6a:	2c6080e7          	jalr	710(ra) # 80003e2c <iunlockput>
  end_op();
    80005b6e:	fffff097          	auipc	ra,0xfffff
    80005b72:	aae080e7          	jalr	-1362(ra) # 8000461c <end_op>
  return -1;
    80005b76:	557d                	li	a0,-1
}
    80005b78:	70ae                	ld	ra,232(sp)
    80005b7a:	740e                	ld	s0,224(sp)
    80005b7c:	64ee                	ld	s1,216(sp)
    80005b7e:	694e                	ld	s2,208(sp)
    80005b80:	69ae                	ld	s3,200(sp)
    80005b82:	616d                	addi	sp,sp,240
    80005b84:	8082                	ret

0000000080005b86 <sys_open>:

uint64 sys_open(void) {
    80005b86:	7131                	addi	sp,sp,-192
    80005b88:	fd06                	sd	ra,184(sp)
    80005b8a:	f922                	sd	s0,176(sp)
    80005b8c:	f526                	sd	s1,168(sp)
    80005b8e:	f14a                	sd	s2,160(sp)
    80005b90:	ed4e                	sd	s3,152(sp)
    80005b92:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b94:	08000613          	li	a2,128
    80005b98:	f5040593          	addi	a1,s0,-176
    80005b9c:	4501                	li	a0,0
    80005b9e:	ffffd097          	auipc	ra,0xffffd
    80005ba2:	3e4080e7          	jalr	996(ra) # 80002f82 <argstr>
    return -1;
    80005ba6:	54fd                	li	s1,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005ba8:	0c054163          	bltz	a0,80005c6a <sys_open+0xe4>
    80005bac:	f4c40593          	addi	a1,s0,-180
    80005bb0:	4505                	li	a0,1
    80005bb2:	ffffd097          	auipc	ra,0xffffd
    80005bb6:	38c080e7          	jalr	908(ra) # 80002f3e <argint>
    80005bba:	0a054863          	bltz	a0,80005c6a <sys_open+0xe4>

  begin_op();
    80005bbe:	fffff097          	auipc	ra,0xfffff
    80005bc2:	9de080e7          	jalr	-1570(ra) # 8000459c <begin_op>

  if (omode & O_CREATE) {
    80005bc6:	f4c42783          	lw	a5,-180(s0)
    80005bca:	2007f793          	andi	a5,a5,512
    80005bce:	cbdd                	beqz	a5,80005c84 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005bd0:	4681                	li	a3,0
    80005bd2:	4601                	li	a2,0
    80005bd4:	4589                	li	a1,2
    80005bd6:	f5040513          	addi	a0,s0,-176
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	974080e7          	jalr	-1676(ra) # 8000554e <create>
    80005be2:	892a                	mv	s2,a0
    if (ip == 0) {
    80005be4:	c959                	beqz	a0,80005c7a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005be6:	04491703          	lh	a4,68(s2)
    80005bea:	478d                	li	a5,3
    80005bec:	00f71763          	bne	a4,a5,80005bfa <sys_open+0x74>
    80005bf0:	04695703          	lhu	a4,70(s2)
    80005bf4:	47a5                	li	a5,9
    80005bf6:	0ce7ec63          	bltu	a5,a4,80005cce <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	db2080e7          	jalr	-590(ra) # 800049ac <filealloc>
    80005c02:	89aa                	mv	s3,a0
    80005c04:	10050263          	beqz	a0,80005d08 <sys_open+0x182>
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	904080e7          	jalr	-1788(ra) # 8000550c <fdalloc>
    80005c10:	84aa                	mv	s1,a0
    80005c12:	0e054663          	bltz	a0,80005cfe <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005c16:	04491703          	lh	a4,68(s2)
    80005c1a:	478d                	li	a5,3
    80005c1c:	0cf70463          	beq	a4,a5,80005ce4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005c20:	4789                	li	a5,2
    80005c22:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005c26:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005c2a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005c2e:	f4c42783          	lw	a5,-180(s0)
    80005c32:	0017c713          	xori	a4,a5,1
    80005c36:	8b05                	andi	a4,a4,1
    80005c38:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005c3c:	0037f713          	andi	a4,a5,3
    80005c40:	00e03733          	snez	a4,a4
    80005c44:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005c48:	4007f793          	andi	a5,a5,1024
    80005c4c:	c791                	beqz	a5,80005c58 <sys_open+0xd2>
    80005c4e:	04491703          	lh	a4,68(s2)
    80005c52:	4789                	li	a5,2
    80005c54:	08f70f63          	beq	a4,a5,80005cf2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005c58:	854a                	mv	a0,s2
    80005c5a:	ffffe097          	auipc	ra,0xffffe
    80005c5e:	032080e7          	jalr	50(ra) # 80003c8c <iunlock>
  end_op();
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	9ba080e7          	jalr	-1606(ra) # 8000461c <end_op>

  return fd;
}
    80005c6a:	8526                	mv	a0,s1
    80005c6c:	70ea                	ld	ra,184(sp)
    80005c6e:	744a                	ld	s0,176(sp)
    80005c70:	74aa                	ld	s1,168(sp)
    80005c72:	790a                	ld	s2,160(sp)
    80005c74:	69ea                	ld	s3,152(sp)
    80005c76:	6129                	addi	sp,sp,192
    80005c78:	8082                	ret
      end_op();
    80005c7a:	fffff097          	auipc	ra,0xfffff
    80005c7e:	9a2080e7          	jalr	-1630(ra) # 8000461c <end_op>
      return -1;
    80005c82:	b7e5                	j	80005c6a <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80005c84:	f5040513          	addi	a0,s0,-176
    80005c88:	ffffe097          	auipc	ra,0xffffe
    80005c8c:	6f8080e7          	jalr	1784(ra) # 80004380 <namei>
    80005c90:	892a                	mv	s2,a0
    80005c92:	c905                	beqz	a0,80005cc2 <sys_open+0x13c>
    ilock(ip);
    80005c94:	ffffe097          	auipc	ra,0xffffe
    80005c98:	f36080e7          	jalr	-202(ra) # 80003bca <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005c9c:	04491703          	lh	a4,68(s2)
    80005ca0:	4785                	li	a5,1
    80005ca2:	f4f712e3          	bne	a4,a5,80005be6 <sys_open+0x60>
    80005ca6:	f4c42783          	lw	a5,-180(s0)
    80005caa:	dba1                	beqz	a5,80005bfa <sys_open+0x74>
      iunlockput(ip);
    80005cac:	854a                	mv	a0,s2
    80005cae:	ffffe097          	auipc	ra,0xffffe
    80005cb2:	17e080e7          	jalr	382(ra) # 80003e2c <iunlockput>
      end_op();
    80005cb6:	fffff097          	auipc	ra,0xfffff
    80005cba:	966080e7          	jalr	-1690(ra) # 8000461c <end_op>
      return -1;
    80005cbe:	54fd                	li	s1,-1
    80005cc0:	b76d                	j	80005c6a <sys_open+0xe4>
      end_op();
    80005cc2:	fffff097          	auipc	ra,0xfffff
    80005cc6:	95a080e7          	jalr	-1702(ra) # 8000461c <end_op>
      return -1;
    80005cca:	54fd                	li	s1,-1
    80005ccc:	bf79                	j	80005c6a <sys_open+0xe4>
    iunlockput(ip);
    80005cce:	854a                	mv	a0,s2
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	15c080e7          	jalr	348(ra) # 80003e2c <iunlockput>
    end_op();
    80005cd8:	fffff097          	auipc	ra,0xfffff
    80005cdc:	944080e7          	jalr	-1724(ra) # 8000461c <end_op>
    return -1;
    80005ce0:	54fd                	li	s1,-1
    80005ce2:	b761                	j	80005c6a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005ce4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005ce8:	04691783          	lh	a5,70(s2)
    80005cec:	02f99223          	sh	a5,36(s3)
    80005cf0:	bf2d                	j	80005c2a <sys_open+0xa4>
    itrunc(ip);
    80005cf2:	854a                	mv	a0,s2
    80005cf4:	ffffe097          	auipc	ra,0xffffe
    80005cf8:	fe4080e7          	jalr	-28(ra) # 80003cd8 <itrunc>
    80005cfc:	bfb1                	j	80005c58 <sys_open+0xd2>
      fileclose(f);
    80005cfe:	854e                	mv	a0,s3
    80005d00:	fffff097          	auipc	ra,0xfffff
    80005d04:	d68080e7          	jalr	-664(ra) # 80004a68 <fileclose>
    iunlockput(ip);
    80005d08:	854a                	mv	a0,s2
    80005d0a:	ffffe097          	auipc	ra,0xffffe
    80005d0e:	122080e7          	jalr	290(ra) # 80003e2c <iunlockput>
    end_op();
    80005d12:	fffff097          	auipc	ra,0xfffff
    80005d16:	90a080e7          	jalr	-1782(ra) # 8000461c <end_op>
    return -1;
    80005d1a:	54fd                	li	s1,-1
    80005d1c:	b7b9                	j	80005c6a <sys_open+0xe4>

0000000080005d1e <sys_mkdir>:

uint64 sys_mkdir(void) {
    80005d1e:	7175                	addi	sp,sp,-144
    80005d20:	e506                	sd	ra,136(sp)
    80005d22:	e122                	sd	s0,128(sp)
    80005d24:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005d26:	fffff097          	auipc	ra,0xfffff
    80005d2a:	876080e7          	jalr	-1930(ra) # 8000459c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005d2e:	08000613          	li	a2,128
    80005d32:	f7040593          	addi	a1,s0,-144
    80005d36:	4501                	li	a0,0
    80005d38:	ffffd097          	auipc	ra,0xffffd
    80005d3c:	24a080e7          	jalr	586(ra) # 80002f82 <argstr>
    80005d40:	02054963          	bltz	a0,80005d72 <sys_mkdir+0x54>
    80005d44:	4681                	li	a3,0
    80005d46:	4601                	li	a2,0
    80005d48:	4585                	li	a1,1
    80005d4a:	f7040513          	addi	a0,s0,-144
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	800080e7          	jalr	-2048(ra) # 8000554e <create>
    80005d56:	cd11                	beqz	a0,80005d72 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d58:	ffffe097          	auipc	ra,0xffffe
    80005d5c:	0d4080e7          	jalr	212(ra) # 80003e2c <iunlockput>
  end_op();
    80005d60:	fffff097          	auipc	ra,0xfffff
    80005d64:	8bc080e7          	jalr	-1860(ra) # 8000461c <end_op>
  return 0;
    80005d68:	4501                	li	a0,0
}
    80005d6a:	60aa                	ld	ra,136(sp)
    80005d6c:	640a                	ld	s0,128(sp)
    80005d6e:	6149                	addi	sp,sp,144
    80005d70:	8082                	ret
    end_op();
    80005d72:	fffff097          	auipc	ra,0xfffff
    80005d76:	8aa080e7          	jalr	-1878(ra) # 8000461c <end_op>
    return -1;
    80005d7a:	557d                	li	a0,-1
    80005d7c:	b7fd                	j	80005d6a <sys_mkdir+0x4c>

0000000080005d7e <sys_mknod>:

uint64 sys_mknod(void) {
    80005d7e:	7135                	addi	sp,sp,-160
    80005d80:	ed06                	sd	ra,152(sp)
    80005d82:	e922                	sd	s0,144(sp)
    80005d84:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d86:	fffff097          	auipc	ra,0xfffff
    80005d8a:	816080e7          	jalr	-2026(ra) # 8000459c <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005d8e:	08000613          	li	a2,128
    80005d92:	f7040593          	addi	a1,s0,-144
    80005d96:	4501                	li	a0,0
    80005d98:	ffffd097          	auipc	ra,0xffffd
    80005d9c:	1ea080e7          	jalr	490(ra) # 80002f82 <argstr>
    80005da0:	04054a63          	bltz	a0,80005df4 <sys_mknod+0x76>
    80005da4:	f6c40593          	addi	a1,s0,-148
    80005da8:	4505                	li	a0,1
    80005daa:	ffffd097          	auipc	ra,0xffffd
    80005dae:	194080e7          	jalr	404(ra) # 80002f3e <argint>
    80005db2:	04054163          	bltz	a0,80005df4 <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80005db6:	f6840593          	addi	a1,s0,-152
    80005dba:	4509                	li	a0,2
    80005dbc:	ffffd097          	auipc	ra,0xffffd
    80005dc0:	182080e7          	jalr	386(ra) # 80002f3e <argint>
  if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005dc4:	02054863          	bltz	a0,80005df4 <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005dc8:	f6841683          	lh	a3,-152(s0)
    80005dcc:	f6c41603          	lh	a2,-148(s0)
    80005dd0:	458d                	li	a1,3
    80005dd2:	f7040513          	addi	a0,s0,-144
    80005dd6:	fffff097          	auipc	ra,0xfffff
    80005dda:	778080e7          	jalr	1912(ra) # 8000554e <create>
      argint(2, &minor) < 0 ||
    80005dde:	c919                	beqz	a0,80005df4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005de0:	ffffe097          	auipc	ra,0xffffe
    80005de4:	04c080e7          	jalr	76(ra) # 80003e2c <iunlockput>
  end_op();
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	834080e7          	jalr	-1996(ra) # 8000461c <end_op>
  return 0;
    80005df0:	4501                	li	a0,0
    80005df2:	a031                	j	80005dfe <sys_mknod+0x80>
    end_op();
    80005df4:	fffff097          	auipc	ra,0xfffff
    80005df8:	828080e7          	jalr	-2008(ra) # 8000461c <end_op>
    return -1;
    80005dfc:	557d                	li	a0,-1
}
    80005dfe:	60ea                	ld	ra,152(sp)
    80005e00:	644a                	ld	s0,144(sp)
    80005e02:	610d                	addi	sp,sp,160
    80005e04:	8082                	ret

0000000080005e06 <sys_chdir>:

uint64 sys_chdir(void) {
    80005e06:	7135                	addi	sp,sp,-160
    80005e08:	ed06                	sd	ra,152(sp)
    80005e0a:	e922                	sd	s0,144(sp)
    80005e0c:	e526                	sd	s1,136(sp)
    80005e0e:	e14a                	sd	s2,128(sp)
    80005e10:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005e12:	ffffc097          	auipc	ra,0xffffc
    80005e16:	e5a080e7          	jalr	-422(ra) # 80001c6c <myproc>
    80005e1a:	892a                	mv	s2,a0

  begin_op();
    80005e1c:	ffffe097          	auipc	ra,0xffffe
    80005e20:	780080e7          	jalr	1920(ra) # 8000459c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005e24:	08000613          	li	a2,128
    80005e28:	f6040593          	addi	a1,s0,-160
    80005e2c:	4501                	li	a0,0
    80005e2e:	ffffd097          	auipc	ra,0xffffd
    80005e32:	154080e7          	jalr	340(ra) # 80002f82 <argstr>
    80005e36:	04054b63          	bltz	a0,80005e8c <sys_chdir+0x86>
    80005e3a:	f6040513          	addi	a0,s0,-160
    80005e3e:	ffffe097          	auipc	ra,0xffffe
    80005e42:	542080e7          	jalr	1346(ra) # 80004380 <namei>
    80005e46:	84aa                	mv	s1,a0
    80005e48:	c131                	beqz	a0,80005e8c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005e4a:	ffffe097          	auipc	ra,0xffffe
    80005e4e:	d80080e7          	jalr	-640(ra) # 80003bca <ilock>
  if (ip->type != T_DIR) {
    80005e52:	04449703          	lh	a4,68(s1)
    80005e56:	4785                	li	a5,1
    80005e58:	04f71063          	bne	a4,a5,80005e98 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005e5c:	8526                	mv	a0,s1
    80005e5e:	ffffe097          	auipc	ra,0xffffe
    80005e62:	e2e080e7          	jalr	-466(ra) # 80003c8c <iunlock>
  iput(p->cwd);
    80005e66:	16093503          	ld	a0,352(s2)
    80005e6a:	ffffe097          	auipc	ra,0xffffe
    80005e6e:	f1a080e7          	jalr	-230(ra) # 80003d84 <iput>
  end_op();
    80005e72:	ffffe097          	auipc	ra,0xffffe
    80005e76:	7aa080e7          	jalr	1962(ra) # 8000461c <end_op>
  p->cwd = ip;
    80005e7a:	16993023          	sd	s1,352(s2)
  return 0;
    80005e7e:	4501                	li	a0,0
}
    80005e80:	60ea                	ld	ra,152(sp)
    80005e82:	644a                	ld	s0,144(sp)
    80005e84:	64aa                	ld	s1,136(sp)
    80005e86:	690a                	ld	s2,128(sp)
    80005e88:	610d                	addi	sp,sp,160
    80005e8a:	8082                	ret
    end_op();
    80005e8c:	ffffe097          	auipc	ra,0xffffe
    80005e90:	790080e7          	jalr	1936(ra) # 8000461c <end_op>
    return -1;
    80005e94:	557d                	li	a0,-1
    80005e96:	b7ed                	j	80005e80 <sys_chdir+0x7a>
    iunlockput(ip);
    80005e98:	8526                	mv	a0,s1
    80005e9a:	ffffe097          	auipc	ra,0xffffe
    80005e9e:	f92080e7          	jalr	-110(ra) # 80003e2c <iunlockput>
    end_op();
    80005ea2:	ffffe097          	auipc	ra,0xffffe
    80005ea6:	77a080e7          	jalr	1914(ra) # 8000461c <end_op>
    return -1;
    80005eaa:	557d                	li	a0,-1
    80005eac:	bfd1                	j	80005e80 <sys_chdir+0x7a>

0000000080005eae <sys_exec>:

uint64 sys_exec(void) {
    80005eae:	7145                	addi	sp,sp,-464
    80005eb0:	e786                	sd	ra,456(sp)
    80005eb2:	e3a2                	sd	s0,448(sp)
    80005eb4:	ff26                	sd	s1,440(sp)
    80005eb6:	fb4a                	sd	s2,432(sp)
    80005eb8:	f74e                	sd	s3,424(sp)
    80005eba:	f352                	sd	s4,416(sp)
    80005ebc:	ef56                	sd	s5,408(sp)
    80005ebe:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) {
    80005ec0:	08000613          	li	a2,128
    80005ec4:	f4040593          	addi	a1,s0,-192
    80005ec8:	4501                	li	a0,0
    80005eca:	ffffd097          	auipc	ra,0xffffd
    80005ece:	0b8080e7          	jalr	184(ra) # 80002f82 <argstr>
    return -1;
    80005ed2:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) {
    80005ed4:	0c054a63          	bltz	a0,80005fa8 <sys_exec+0xfa>
    80005ed8:	e3840593          	addi	a1,s0,-456
    80005edc:	4505                	li	a0,1
    80005ede:	ffffd097          	auipc	ra,0xffffd
    80005ee2:	082080e7          	jalr	130(ra) # 80002f60 <argaddr>
    80005ee6:	0c054163          	bltz	a0,80005fa8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005eea:	10000613          	li	a2,256
    80005eee:	4581                	li	a1,0
    80005ef0:	e4040513          	addi	a0,s0,-448
    80005ef4:	ffffb097          	auipc	ra,0xffffb
    80005ef8:	e42080e7          	jalr	-446(ra) # 80000d36 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005efc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005f00:	89a6                	mv	s3,s1
    80005f02:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80005f04:	02000a13          	li	s4,32
    80005f08:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005f0c:	00391793          	slli	a5,s2,0x3
    80005f10:	e3040593          	addi	a1,s0,-464
    80005f14:	e3843503          	ld	a0,-456(s0)
    80005f18:	953e                	add	a0,a0,a5
    80005f1a:	ffffd097          	auipc	ra,0xffffd
    80005f1e:	f8a080e7          	jalr	-118(ra) # 80002ea4 <fetchaddr>
    80005f22:	02054a63          	bltz	a0,80005f56 <sys_exec+0xa8>
      goto bad;
    }
    if (uarg == 0) {
    80005f26:	e3043783          	ld	a5,-464(s0)
    80005f2a:	c3b9                	beqz	a5,80005f70 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005f2c:	ffffb097          	auipc	ra,0xffffb
    80005f30:	c1e080e7          	jalr	-994(ra) # 80000b4a <kalloc>
    80005f34:	85aa                	mv	a1,a0
    80005f36:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005f3a:	cd11                	beqz	a0,80005f56 <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005f3c:	6605                	lui	a2,0x1
    80005f3e:	e3043503          	ld	a0,-464(s0)
    80005f42:	ffffd097          	auipc	ra,0xffffd
    80005f46:	fb4080e7          	jalr	-76(ra) # 80002ef6 <fetchstr>
    80005f4a:	00054663          	bltz	a0,80005f56 <sys_exec+0xa8>
    if (i >= NELEM(argv)) {
    80005f4e:	0905                	addi	s2,s2,1
    80005f50:	09a1                	addi	s3,s3,8
    80005f52:	fb491be3          	bne	s2,s4,80005f08 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f56:	10048913          	addi	s2,s1,256
    80005f5a:	6088                	ld	a0,0(s1)
    80005f5c:	c529                	beqz	a0,80005fa6 <sys_exec+0xf8>
    kfree(argv[i]);
    80005f5e:	ffffb097          	auipc	ra,0xffffb
    80005f62:	af0080e7          	jalr	-1296(ra) # 80000a4e <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f66:	04a1                	addi	s1,s1,8
    80005f68:	ff2499e3          	bne	s1,s2,80005f5a <sys_exec+0xac>
  return -1;
    80005f6c:	597d                	li	s2,-1
    80005f6e:	a82d                	j	80005fa8 <sys_exec+0xfa>
      argv[i] = 0;
    80005f70:	0a8e                	slli	s5,s5,0x3
    80005f72:	fc040793          	addi	a5,s0,-64
    80005f76:	9abe                	add	s5,s5,a5
    80005f78:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    80005f7c:	e4040593          	addi	a1,s0,-448
    80005f80:	f4040513          	addi	a0,s0,-192
    80005f84:	fffff097          	auipc	ra,0xfffff
    80005f88:	136080e7          	jalr	310(ra) # 800050ba <exec>
    80005f8c:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f8e:	10048993          	addi	s3,s1,256
    80005f92:	6088                	ld	a0,0(s1)
    80005f94:	c911                	beqz	a0,80005fa8 <sys_exec+0xfa>
    kfree(argv[i]);
    80005f96:	ffffb097          	auipc	ra,0xffffb
    80005f9a:	ab8080e7          	jalr	-1352(ra) # 80000a4e <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f9e:	04a1                	addi	s1,s1,8
    80005fa0:	ff3499e3          	bne	s1,s3,80005f92 <sys_exec+0xe4>
    80005fa4:	a011                	j	80005fa8 <sys_exec+0xfa>
  return -1;
    80005fa6:	597d                	li	s2,-1
}
    80005fa8:	854a                	mv	a0,s2
    80005faa:	60be                	ld	ra,456(sp)
    80005fac:	641e                	ld	s0,448(sp)
    80005fae:	74fa                	ld	s1,440(sp)
    80005fb0:	795a                	ld	s2,432(sp)
    80005fb2:	79ba                	ld	s3,424(sp)
    80005fb4:	7a1a                	ld	s4,416(sp)
    80005fb6:	6afa                	ld	s5,408(sp)
    80005fb8:	6179                	addi	sp,sp,464
    80005fba:	8082                	ret

0000000080005fbc <sys_pipe>:

uint64 sys_pipe(void) {
    80005fbc:	7139                	addi	sp,sp,-64
    80005fbe:	fc06                	sd	ra,56(sp)
    80005fc0:	f822                	sd	s0,48(sp)
    80005fc2:	f426                	sd	s1,40(sp)
    80005fc4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005fc6:	ffffc097          	auipc	ra,0xffffc
    80005fca:	ca6080e7          	jalr	-858(ra) # 80001c6c <myproc>
    80005fce:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    80005fd0:	fd840593          	addi	a1,s0,-40
    80005fd4:	4501                	li	a0,0
    80005fd6:	ffffd097          	auipc	ra,0xffffd
    80005fda:	f8a080e7          	jalr	-118(ra) # 80002f60 <argaddr>
    return -1;
    80005fde:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    80005fe0:	0e054063          	bltz	a0,800060c0 <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    80005fe4:	fc840593          	addi	a1,s0,-56
    80005fe8:	fd040513          	addi	a0,s0,-48
    80005fec:	fffff097          	auipc	ra,0xfffff
    80005ff0:	dac080e7          	jalr	-596(ra) # 80004d98 <pipealloc>
    return -1;
    80005ff4:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80005ff6:	0c054563          	bltz	a0,800060c0 <sys_pipe+0x104>
  fd0 = -1;
    80005ffa:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005ffe:	fd043503          	ld	a0,-48(s0)
    80006002:	fffff097          	auipc	ra,0xfffff
    80006006:	50a080e7          	jalr	1290(ra) # 8000550c <fdalloc>
    8000600a:	fca42223          	sw	a0,-60(s0)
    8000600e:	08054c63          	bltz	a0,800060a6 <sys_pipe+0xea>
    80006012:	fc843503          	ld	a0,-56(s0)
    80006016:	fffff097          	auipc	ra,0xfffff
    8000601a:	4f6080e7          	jalr	1270(ra) # 8000550c <fdalloc>
    8000601e:	fca42023          	sw	a0,-64(s0)
    80006022:	06054863          	bltz	a0,80006092 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80006026:	4691                	li	a3,4
    80006028:	fc440613          	addi	a2,s0,-60
    8000602c:	fd843583          	ld	a1,-40(s0)
    80006030:	6ca8                	ld	a0,88(s1)
    80006032:	ffffc097          	auipc	ra,0xffffc
    80006036:	82a080e7          	jalr	-2006(ra) # 8000185c <copyout>
    8000603a:	02054063          	bltz	a0,8000605a <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    8000603e:	4691                	li	a3,4
    80006040:	fc040613          	addi	a2,s0,-64
    80006044:	fd843583          	ld	a1,-40(s0)
    80006048:	0591                	addi	a1,a1,4
    8000604a:	6ca8                	ld	a0,88(s1)
    8000604c:	ffffc097          	auipc	ra,0xffffc
    80006050:	810080e7          	jalr	-2032(ra) # 8000185c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006054:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80006056:	06055563          	bgez	a0,800060c0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000605a:	fc442783          	lw	a5,-60(s0)
    8000605e:	07f1                	addi	a5,a5,28
    80006060:	078e                	slli	a5,a5,0x3
    80006062:	97a6                	add	a5,a5,s1
    80006064:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006068:	fc042503          	lw	a0,-64(s0)
    8000606c:	0571                	addi	a0,a0,28
    8000606e:	050e                	slli	a0,a0,0x3
    80006070:	9526                	add	a0,a0,s1
    80006072:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006076:	fd043503          	ld	a0,-48(s0)
    8000607a:	fffff097          	auipc	ra,0xfffff
    8000607e:	9ee080e7          	jalr	-1554(ra) # 80004a68 <fileclose>
    fileclose(wf);
    80006082:	fc843503          	ld	a0,-56(s0)
    80006086:	fffff097          	auipc	ra,0xfffff
    8000608a:	9e2080e7          	jalr	-1566(ra) # 80004a68 <fileclose>
    return -1;
    8000608e:	57fd                	li	a5,-1
    80006090:	a805                	j	800060c0 <sys_pipe+0x104>
    if (fd0 >= 0)
    80006092:	fc442783          	lw	a5,-60(s0)
    80006096:	0007c863          	bltz	a5,800060a6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000609a:	01c78513          	addi	a0,a5,28
    8000609e:	050e                	slli	a0,a0,0x3
    800060a0:	9526                	add	a0,a0,s1
    800060a2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800060a6:	fd043503          	ld	a0,-48(s0)
    800060aa:	fffff097          	auipc	ra,0xfffff
    800060ae:	9be080e7          	jalr	-1602(ra) # 80004a68 <fileclose>
    fileclose(wf);
    800060b2:	fc843503          	ld	a0,-56(s0)
    800060b6:	fffff097          	auipc	ra,0xfffff
    800060ba:	9b2080e7          	jalr	-1614(ra) # 80004a68 <fileclose>
    return -1;
    800060be:	57fd                	li	a5,-1
}
    800060c0:	853e                	mv	a0,a5
    800060c2:	70e2                	ld	ra,56(sp)
    800060c4:	7442                	ld	s0,48(sp)
    800060c6:	74a2                	ld	s1,40(sp)
    800060c8:	6121                	addi	sp,sp,64
    800060ca:	8082                	ret
    800060cc:	0000                	unimp
	...

00000000800060d0 <kernelvec>:
    800060d0:	7111                	addi	sp,sp,-256
    800060d2:	e006                	sd	ra,0(sp)
    800060d4:	e40a                	sd	sp,8(sp)
    800060d6:	e80e                	sd	gp,16(sp)
    800060d8:	ec12                	sd	tp,24(sp)
    800060da:	f016                	sd	t0,32(sp)
    800060dc:	f41a                	sd	t1,40(sp)
    800060de:	f81e                	sd	t2,48(sp)
    800060e0:	fc22                	sd	s0,56(sp)
    800060e2:	e0a6                	sd	s1,64(sp)
    800060e4:	e4aa                	sd	a0,72(sp)
    800060e6:	e8ae                	sd	a1,80(sp)
    800060e8:	ecb2                	sd	a2,88(sp)
    800060ea:	f0b6                	sd	a3,96(sp)
    800060ec:	f4ba                	sd	a4,104(sp)
    800060ee:	f8be                	sd	a5,112(sp)
    800060f0:	fcc2                	sd	a6,120(sp)
    800060f2:	e146                	sd	a7,128(sp)
    800060f4:	e54a                	sd	s2,136(sp)
    800060f6:	e94e                	sd	s3,144(sp)
    800060f8:	ed52                	sd	s4,152(sp)
    800060fa:	f156                	sd	s5,160(sp)
    800060fc:	f55a                	sd	s6,168(sp)
    800060fe:	f95e                	sd	s7,176(sp)
    80006100:	fd62                	sd	s8,184(sp)
    80006102:	e1e6                	sd	s9,192(sp)
    80006104:	e5ea                	sd	s10,200(sp)
    80006106:	e9ee                	sd	s11,208(sp)
    80006108:	edf2                	sd	t3,216(sp)
    8000610a:	f1f6                	sd	t4,224(sp)
    8000610c:	f5fa                	sd	t5,232(sp)
    8000610e:	f9fe                	sd	t6,240(sp)
    80006110:	c61fc0ef          	jal	ra,80002d70 <kerneltrap>
    80006114:	6082                	ld	ra,0(sp)
    80006116:	6122                	ld	sp,8(sp)
    80006118:	61c2                	ld	gp,16(sp)
    8000611a:	7282                	ld	t0,32(sp)
    8000611c:	7322                	ld	t1,40(sp)
    8000611e:	73c2                	ld	t2,48(sp)
    80006120:	7462                	ld	s0,56(sp)
    80006122:	6486                	ld	s1,64(sp)
    80006124:	6526                	ld	a0,72(sp)
    80006126:	65c6                	ld	a1,80(sp)
    80006128:	6666                	ld	a2,88(sp)
    8000612a:	7686                	ld	a3,96(sp)
    8000612c:	7726                	ld	a4,104(sp)
    8000612e:	77c6                	ld	a5,112(sp)
    80006130:	7866                	ld	a6,120(sp)
    80006132:	688a                	ld	a7,128(sp)
    80006134:	692a                	ld	s2,136(sp)
    80006136:	69ca                	ld	s3,144(sp)
    80006138:	6a6a                	ld	s4,152(sp)
    8000613a:	7a8a                	ld	s5,160(sp)
    8000613c:	7b2a                	ld	s6,168(sp)
    8000613e:	7bca                	ld	s7,176(sp)
    80006140:	7c6a                	ld	s8,184(sp)
    80006142:	6c8e                	ld	s9,192(sp)
    80006144:	6d2e                	ld	s10,200(sp)
    80006146:	6dce                	ld	s11,208(sp)
    80006148:	6e6e                	ld	t3,216(sp)
    8000614a:	7e8e                	ld	t4,224(sp)
    8000614c:	7f2e                	ld	t5,232(sp)
    8000614e:	7fce                	ld	t6,240(sp)
    80006150:	6111                	addi	sp,sp,256
    80006152:	10200073          	sret
    80006156:	00000013          	nop
    8000615a:	00000013          	nop
    8000615e:	0001                	nop

0000000080006160 <timervec>:
    80006160:	34051573          	csrrw	a0,mscratch,a0
    80006164:	e10c                	sd	a1,0(a0)
    80006166:	e510                	sd	a2,8(a0)
    80006168:	e914                	sd	a3,16(a0)
    8000616a:	6d0c                	ld	a1,24(a0)
    8000616c:	7110                	ld	a2,32(a0)
    8000616e:	6194                	ld	a3,0(a1)
    80006170:	96b2                	add	a3,a3,a2
    80006172:	e194                	sd	a3,0(a1)
    80006174:	4589                	li	a1,2
    80006176:	14459073          	csrw	sip,a1
    8000617a:	6914                	ld	a3,16(a0)
    8000617c:	6510                	ld	a2,8(a0)
    8000617e:	610c                	ld	a1,0(a0)
    80006180:	34051573          	csrrw	a0,mscratch,a0
    80006184:	30200073          	mret
	...

000000008000618a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000618a:	1141                	addi	sp,sp,-16
    8000618c:	e422                	sd	s0,8(sp)
    8000618e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006190:	0c0007b7          	lui	a5,0xc000
    80006194:	4705                	li	a4,1
    80006196:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006198:	c3d8                	sw	a4,4(a5)
}
    8000619a:	6422                	ld	s0,8(sp)
    8000619c:	0141                	addi	sp,sp,16
    8000619e:	8082                	ret

00000000800061a0 <plicinithart>:

void
plicinithart(void)
{
    800061a0:	1141                	addi	sp,sp,-16
    800061a2:	e406                	sd	ra,8(sp)
    800061a4:	e022                	sd	s0,0(sp)
    800061a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061a8:	ffffc097          	auipc	ra,0xffffc
    800061ac:	a98080e7          	jalr	-1384(ra) # 80001c40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800061b0:	0085171b          	slliw	a4,a0,0x8
    800061b4:	0c0027b7          	lui	a5,0xc002
    800061b8:	97ba                	add	a5,a5,a4
    800061ba:	40200713          	li	a4,1026
    800061be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800061c2:	00d5151b          	slliw	a0,a0,0xd
    800061c6:	0c2017b7          	lui	a5,0xc201
    800061ca:	953e                	add	a0,a0,a5
    800061cc:	00052023          	sw	zero,0(a0)
}
    800061d0:	60a2                	ld	ra,8(sp)
    800061d2:	6402                	ld	s0,0(sp)
    800061d4:	0141                	addi	sp,sp,16
    800061d6:	8082                	ret

00000000800061d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800061d8:	1141                	addi	sp,sp,-16
    800061da:	e406                	sd	ra,8(sp)
    800061dc:	e022                	sd	s0,0(sp)
    800061de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061e0:	ffffc097          	auipc	ra,0xffffc
    800061e4:	a60080e7          	jalr	-1440(ra) # 80001c40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800061e8:	00d5179b          	slliw	a5,a0,0xd
    800061ec:	0c201537          	lui	a0,0xc201
    800061f0:	953e                	add	a0,a0,a5
  return irq;
}
    800061f2:	4148                	lw	a0,4(a0)
    800061f4:	60a2                	ld	ra,8(sp)
    800061f6:	6402                	ld	s0,0(sp)
    800061f8:	0141                	addi	sp,sp,16
    800061fa:	8082                	ret

00000000800061fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800061fc:	1101                	addi	sp,sp,-32
    800061fe:	ec06                	sd	ra,24(sp)
    80006200:	e822                	sd	s0,16(sp)
    80006202:	e426                	sd	s1,8(sp)
    80006204:	1000                	addi	s0,sp,32
    80006206:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006208:	ffffc097          	auipc	ra,0xffffc
    8000620c:	a38080e7          	jalr	-1480(ra) # 80001c40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006210:	00d5151b          	slliw	a0,a0,0xd
    80006214:	0c2017b7          	lui	a5,0xc201
    80006218:	97aa                	add	a5,a5,a0
    8000621a:	c3c4                	sw	s1,4(a5)
}
    8000621c:	60e2                	ld	ra,24(sp)
    8000621e:	6442                	ld	s0,16(sp)
    80006220:	64a2                	ld	s1,8(sp)
    80006222:	6105                	addi	sp,sp,32
    80006224:	8082                	ret

0000000080006226 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006226:	1141                	addi	sp,sp,-16
    80006228:	e406                	sd	ra,8(sp)
    8000622a:	e022                	sd	s0,0(sp)
    8000622c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000622e:	479d                	li	a5,7
    80006230:	06a7c963          	blt	a5,a0,800062a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006234:	0001d797          	auipc	a5,0x1d
    80006238:	dcc78793          	addi	a5,a5,-564 # 80023000 <disk>
    8000623c:	00a78733          	add	a4,a5,a0
    80006240:	6789                	lui	a5,0x2
    80006242:	97ba                	add	a5,a5,a4
    80006244:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006248:	e7ad                	bnez	a5,800062b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000624a:	00451793          	slli	a5,a0,0x4
    8000624e:	0001f717          	auipc	a4,0x1f
    80006252:	db270713          	addi	a4,a4,-590 # 80025000 <disk+0x2000>
    80006256:	6314                	ld	a3,0(a4)
    80006258:	96be                	add	a3,a3,a5
    8000625a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000625e:	6314                	ld	a3,0(a4)
    80006260:	96be                	add	a3,a3,a5
    80006262:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006266:	6314                	ld	a3,0(a4)
    80006268:	96be                	add	a3,a3,a5
    8000626a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000626e:	6318                	ld	a4,0(a4)
    80006270:	97ba                	add	a5,a5,a4
    80006272:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006276:	0001d797          	auipc	a5,0x1d
    8000627a:	d8a78793          	addi	a5,a5,-630 # 80023000 <disk>
    8000627e:	97aa                	add	a5,a5,a0
    80006280:	6509                	lui	a0,0x2
    80006282:	953e                	add	a0,a0,a5
    80006284:	4785                	li	a5,1
    80006286:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000628a:	0001f517          	auipc	a0,0x1f
    8000628e:	d8e50513          	addi	a0,a0,-626 # 80025018 <disk+0x2018>
    80006292:	ffffc097          	auipc	ra,0xffffc
    80006296:	416080e7          	jalr	1046(ra) # 800026a8 <wakeup>
}
    8000629a:	60a2                	ld	ra,8(sp)
    8000629c:	6402                	ld	s0,0(sp)
    8000629e:	0141                	addi	sp,sp,16
    800062a0:	8082                	ret
    panic("free_desc 1");
    800062a2:	00002517          	auipc	a0,0x2
    800062a6:	5f650513          	addi	a0,a0,1526 # 80008898 <syscalls+0x330>
    800062aa:	ffffa097          	auipc	ra,0xffffa
    800062ae:	322080e7          	jalr	802(ra) # 800005cc <panic>
    panic("free_desc 2");
    800062b2:	00002517          	auipc	a0,0x2
    800062b6:	5f650513          	addi	a0,a0,1526 # 800088a8 <syscalls+0x340>
    800062ba:	ffffa097          	auipc	ra,0xffffa
    800062be:	312080e7          	jalr	786(ra) # 800005cc <panic>

00000000800062c2 <virtio_disk_init>:
{
    800062c2:	1101                	addi	sp,sp,-32
    800062c4:	ec06                	sd	ra,24(sp)
    800062c6:	e822                	sd	s0,16(sp)
    800062c8:	e426                	sd	s1,8(sp)
    800062ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800062cc:	00002597          	auipc	a1,0x2
    800062d0:	5ec58593          	addi	a1,a1,1516 # 800088b8 <syscalls+0x350>
    800062d4:	0001f517          	auipc	a0,0x1f
    800062d8:	e5450513          	addi	a0,a0,-428 # 80025128 <disk+0x2128>
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	8ce080e7          	jalr	-1842(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062e4:	100017b7          	lui	a5,0x10001
    800062e8:	4398                	lw	a4,0(a5)
    800062ea:	2701                	sext.w	a4,a4
    800062ec:	747277b7          	lui	a5,0x74727
    800062f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800062f4:	0ef71163          	bne	a4,a5,800063d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062f8:	100017b7          	lui	a5,0x10001
    800062fc:	43dc                	lw	a5,4(a5)
    800062fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006300:	4705                	li	a4,1
    80006302:	0ce79a63          	bne	a5,a4,800063d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006306:	100017b7          	lui	a5,0x10001
    8000630a:	479c                	lw	a5,8(a5)
    8000630c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000630e:	4709                	li	a4,2
    80006310:	0ce79363          	bne	a5,a4,800063d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006314:	100017b7          	lui	a5,0x10001
    80006318:	47d8                	lw	a4,12(a5)
    8000631a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000631c:	554d47b7          	lui	a5,0x554d4
    80006320:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006324:	0af71963          	bne	a4,a5,800063d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006328:	100017b7          	lui	a5,0x10001
    8000632c:	4705                	li	a4,1
    8000632e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006330:	470d                	li	a4,3
    80006332:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006334:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006336:	c7ffe737          	lui	a4,0xc7ffe
    8000633a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    8000633e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006340:	2701                	sext.w	a4,a4
    80006342:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006344:	472d                	li	a4,11
    80006346:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006348:	473d                	li	a4,15
    8000634a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000634c:	6705                	lui	a4,0x1
    8000634e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006350:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006354:	5bdc                	lw	a5,52(a5)
    80006356:	2781                	sext.w	a5,a5
  if(max == 0)
    80006358:	c7d9                	beqz	a5,800063e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000635a:	471d                	li	a4,7
    8000635c:	08f77d63          	bgeu	a4,a5,800063f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006360:	100014b7          	lui	s1,0x10001
    80006364:	47a1                	li	a5,8
    80006366:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006368:	6609                	lui	a2,0x2
    8000636a:	4581                	li	a1,0
    8000636c:	0001d517          	auipc	a0,0x1d
    80006370:	c9450513          	addi	a0,a0,-876 # 80023000 <disk>
    80006374:	ffffb097          	auipc	ra,0xffffb
    80006378:	9c2080e7          	jalr	-1598(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000637c:	0001d717          	auipc	a4,0x1d
    80006380:	c8470713          	addi	a4,a4,-892 # 80023000 <disk>
    80006384:	00c75793          	srli	a5,a4,0xc
    80006388:	2781                	sext.w	a5,a5
    8000638a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000638c:	0001f797          	auipc	a5,0x1f
    80006390:	c7478793          	addi	a5,a5,-908 # 80025000 <disk+0x2000>
    80006394:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006396:	0001d717          	auipc	a4,0x1d
    8000639a:	cea70713          	addi	a4,a4,-790 # 80023080 <disk+0x80>
    8000639e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800063a0:	0001e717          	auipc	a4,0x1e
    800063a4:	c6070713          	addi	a4,a4,-928 # 80024000 <disk+0x1000>
    800063a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800063aa:	4705                	li	a4,1
    800063ac:	00e78c23          	sb	a4,24(a5)
    800063b0:	00e78ca3          	sb	a4,25(a5)
    800063b4:	00e78d23          	sb	a4,26(a5)
    800063b8:	00e78da3          	sb	a4,27(a5)
    800063bc:	00e78e23          	sb	a4,28(a5)
    800063c0:	00e78ea3          	sb	a4,29(a5)
    800063c4:	00e78f23          	sb	a4,30(a5)
    800063c8:	00e78fa3          	sb	a4,31(a5)
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	addi	sp,sp,32
    800063d4:	8082                	ret
    panic("could not find virtio disk");
    800063d6:	00002517          	auipc	a0,0x2
    800063da:	4f250513          	addi	a0,a0,1266 # 800088c8 <syscalls+0x360>
    800063de:	ffffa097          	auipc	ra,0xffffa
    800063e2:	1ee080e7          	jalr	494(ra) # 800005cc <panic>
    panic("virtio disk has no queue 0");
    800063e6:	00002517          	auipc	a0,0x2
    800063ea:	50250513          	addi	a0,a0,1282 # 800088e8 <syscalls+0x380>
    800063ee:	ffffa097          	auipc	ra,0xffffa
    800063f2:	1de080e7          	jalr	478(ra) # 800005cc <panic>
    panic("virtio disk max queue too short");
    800063f6:	00002517          	auipc	a0,0x2
    800063fa:	51250513          	addi	a0,a0,1298 # 80008908 <syscalls+0x3a0>
    800063fe:	ffffa097          	auipc	ra,0xffffa
    80006402:	1ce080e7          	jalr	462(ra) # 800005cc <panic>

0000000080006406 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006406:	7119                	addi	sp,sp,-128
    80006408:	fc86                	sd	ra,120(sp)
    8000640a:	f8a2                	sd	s0,112(sp)
    8000640c:	f4a6                	sd	s1,104(sp)
    8000640e:	f0ca                	sd	s2,96(sp)
    80006410:	ecce                	sd	s3,88(sp)
    80006412:	e8d2                	sd	s4,80(sp)
    80006414:	e4d6                	sd	s5,72(sp)
    80006416:	e0da                	sd	s6,64(sp)
    80006418:	fc5e                	sd	s7,56(sp)
    8000641a:	f862                	sd	s8,48(sp)
    8000641c:	f466                	sd	s9,40(sp)
    8000641e:	f06a                	sd	s10,32(sp)
    80006420:	ec6e                	sd	s11,24(sp)
    80006422:	0100                	addi	s0,sp,128
    80006424:	8aaa                	mv	s5,a0
    80006426:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006428:	00c52c83          	lw	s9,12(a0)
    8000642c:	001c9c9b          	slliw	s9,s9,0x1
    80006430:	1c82                	slli	s9,s9,0x20
    80006432:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006436:	0001f517          	auipc	a0,0x1f
    8000643a:	cf250513          	addi	a0,a0,-782 # 80025128 <disk+0x2128>
    8000643e:	ffffa097          	auipc	ra,0xffffa
    80006442:	7fc080e7          	jalr	2044(ra) # 80000c3a <acquire>
  for(int i = 0; i < 3; i++){
    80006446:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006448:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000644a:	0001dc17          	auipc	s8,0x1d
    8000644e:	bb6c0c13          	addi	s8,s8,-1098 # 80023000 <disk>
    80006452:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80006454:	4b0d                	li	s6,3
    80006456:	a0ad                	j	800064c0 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006458:	00fc0733          	add	a4,s8,a5
    8000645c:	975e                	add	a4,a4,s7
    8000645e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006462:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006464:	0207c563          	bltz	a5,8000648e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006468:	2905                	addiw	s2,s2,1
    8000646a:	0611                	addi	a2,a2,4
    8000646c:	19690d63          	beq	s2,s6,80006606 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006470:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006472:	0001f717          	auipc	a4,0x1f
    80006476:	ba670713          	addi	a4,a4,-1114 # 80025018 <disk+0x2018>
    8000647a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000647c:	00074683          	lbu	a3,0(a4)
    80006480:	fee1                	bnez	a3,80006458 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006482:	2785                	addiw	a5,a5,1
    80006484:	0705                	addi	a4,a4,1
    80006486:	fe979be3          	bne	a5,s1,8000647c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000648a:	57fd                	li	a5,-1
    8000648c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000648e:	01205d63          	blez	s2,800064a8 <virtio_disk_rw+0xa2>
    80006492:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006494:	000a2503          	lw	a0,0(s4)
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	d8e080e7          	jalr	-626(ra) # 80006226 <free_desc>
      for(int j = 0; j < i; j++)
    800064a0:	2d85                	addiw	s11,s11,1
    800064a2:	0a11                	addi	s4,s4,4
    800064a4:	ffb918e3          	bne	s2,s11,80006494 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800064a8:	0001f597          	auipc	a1,0x1f
    800064ac:	c8058593          	addi	a1,a1,-896 # 80025128 <disk+0x2128>
    800064b0:	0001f517          	auipc	a0,0x1f
    800064b4:	b6850513          	addi	a0,a0,-1176 # 80025018 <disk+0x2018>
    800064b8:	ffffc097          	auipc	ra,0xffffc
    800064bc:	064080e7          	jalr	100(ra) # 8000251c <sleep>
  for(int i = 0; i < 3; i++){
    800064c0:	f8040a13          	addi	s4,s0,-128
{
    800064c4:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800064c6:	894e                	mv	s2,s3
    800064c8:	b765                	j	80006470 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800064ca:	0001f697          	auipc	a3,0x1f
    800064ce:	b366b683          	ld	a3,-1226(a3) # 80025000 <disk+0x2000>
    800064d2:	96ba                	add	a3,a3,a4
    800064d4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800064d8:	0001d817          	auipc	a6,0x1d
    800064dc:	b2880813          	addi	a6,a6,-1240 # 80023000 <disk>
    800064e0:	0001f697          	auipc	a3,0x1f
    800064e4:	b2068693          	addi	a3,a3,-1248 # 80025000 <disk+0x2000>
    800064e8:	6290                	ld	a2,0(a3)
    800064ea:	963a                	add	a2,a2,a4
    800064ec:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800064f0:	0015e593          	ori	a1,a1,1
    800064f4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800064f8:	f8842603          	lw	a2,-120(s0)
    800064fc:	628c                	ld	a1,0(a3)
    800064fe:	972e                	add	a4,a4,a1
    80006500:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006504:	20050593          	addi	a1,a0,512
    80006508:	0592                	slli	a1,a1,0x4
    8000650a:	95c2                	add	a1,a1,a6
    8000650c:	577d                	li	a4,-1
    8000650e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006512:	00461713          	slli	a4,a2,0x4
    80006516:	6290                	ld	a2,0(a3)
    80006518:	963a                	add	a2,a2,a4
    8000651a:	03078793          	addi	a5,a5,48
    8000651e:	97c2                	add	a5,a5,a6
    80006520:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006522:	629c                	ld	a5,0(a3)
    80006524:	97ba                	add	a5,a5,a4
    80006526:	4605                	li	a2,1
    80006528:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000652a:	629c                	ld	a5,0(a3)
    8000652c:	97ba                	add	a5,a5,a4
    8000652e:	4809                	li	a6,2
    80006530:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006534:	629c                	ld	a5,0(a3)
    80006536:	973e                	add	a4,a4,a5
    80006538:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000653c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006540:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006544:	6698                	ld	a4,8(a3)
    80006546:	00275783          	lhu	a5,2(a4)
    8000654a:	8b9d                	andi	a5,a5,7
    8000654c:	0786                	slli	a5,a5,0x1
    8000654e:	97ba                	add	a5,a5,a4
    80006550:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80006554:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006558:	6698                	ld	a4,8(a3)
    8000655a:	00275783          	lhu	a5,2(a4)
    8000655e:	2785                	addiw	a5,a5,1
    80006560:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006564:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006568:	100017b7          	lui	a5,0x10001
    8000656c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006570:	004aa783          	lw	a5,4(s5)
    80006574:	02c79163          	bne	a5,a2,80006596 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006578:	0001f917          	auipc	s2,0x1f
    8000657c:	bb090913          	addi	s2,s2,-1104 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80006580:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006582:	85ca                	mv	a1,s2
    80006584:	8556                	mv	a0,s5
    80006586:	ffffc097          	auipc	ra,0xffffc
    8000658a:	f96080e7          	jalr	-106(ra) # 8000251c <sleep>
  while(b->disk == 1) {
    8000658e:	004aa783          	lw	a5,4(s5)
    80006592:	fe9788e3          	beq	a5,s1,80006582 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006596:	f8042903          	lw	s2,-128(s0)
    8000659a:	20090793          	addi	a5,s2,512
    8000659e:	00479713          	slli	a4,a5,0x4
    800065a2:	0001d797          	auipc	a5,0x1d
    800065a6:	a5e78793          	addi	a5,a5,-1442 # 80023000 <disk>
    800065aa:	97ba                	add	a5,a5,a4
    800065ac:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800065b0:	0001f997          	auipc	s3,0x1f
    800065b4:	a5098993          	addi	s3,s3,-1456 # 80025000 <disk+0x2000>
    800065b8:	00491713          	slli	a4,s2,0x4
    800065bc:	0009b783          	ld	a5,0(s3)
    800065c0:	97ba                	add	a5,a5,a4
    800065c2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800065c6:	854a                	mv	a0,s2
    800065c8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800065cc:	00000097          	auipc	ra,0x0
    800065d0:	c5a080e7          	jalr	-934(ra) # 80006226 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800065d4:	8885                	andi	s1,s1,1
    800065d6:	f0ed                	bnez	s1,800065b8 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800065d8:	0001f517          	auipc	a0,0x1f
    800065dc:	b5050513          	addi	a0,a0,-1200 # 80025128 <disk+0x2128>
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	70e080e7          	jalr	1806(ra) # 80000cee <release>
}
    800065e8:	70e6                	ld	ra,120(sp)
    800065ea:	7446                	ld	s0,112(sp)
    800065ec:	74a6                	ld	s1,104(sp)
    800065ee:	7906                	ld	s2,96(sp)
    800065f0:	69e6                	ld	s3,88(sp)
    800065f2:	6a46                	ld	s4,80(sp)
    800065f4:	6aa6                	ld	s5,72(sp)
    800065f6:	6b06                	ld	s6,64(sp)
    800065f8:	7be2                	ld	s7,56(sp)
    800065fa:	7c42                	ld	s8,48(sp)
    800065fc:	7ca2                	ld	s9,40(sp)
    800065fe:	7d02                	ld	s10,32(sp)
    80006600:	6de2                	ld	s11,24(sp)
    80006602:	6109                	addi	sp,sp,128
    80006604:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006606:	f8042503          	lw	a0,-128(s0)
    8000660a:	20050793          	addi	a5,a0,512
    8000660e:	0792                	slli	a5,a5,0x4
  if(write)
    80006610:	0001d817          	auipc	a6,0x1d
    80006614:	9f080813          	addi	a6,a6,-1552 # 80023000 <disk>
    80006618:	00f80733          	add	a4,a6,a5
    8000661c:	01a036b3          	snez	a3,s10
    80006620:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006624:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006628:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000662c:	7679                	lui	a2,0xffffe
    8000662e:	963e                	add	a2,a2,a5
    80006630:	0001f697          	auipc	a3,0x1f
    80006634:	9d068693          	addi	a3,a3,-1584 # 80025000 <disk+0x2000>
    80006638:	6298                	ld	a4,0(a3)
    8000663a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000663c:	0a878593          	addi	a1,a5,168
    80006640:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006642:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006644:	6298                	ld	a4,0(a3)
    80006646:	9732                	add	a4,a4,a2
    80006648:	45c1                	li	a1,16
    8000664a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000664c:	6298                	ld	a4,0(a3)
    8000664e:	9732                	add	a4,a4,a2
    80006650:	4585                	li	a1,1
    80006652:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006656:	f8442703          	lw	a4,-124(s0)
    8000665a:	628c                	ld	a1,0(a3)
    8000665c:	962e                	add	a2,a2,a1
    8000665e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006662:	0712                	slli	a4,a4,0x4
    80006664:	6290                	ld	a2,0(a3)
    80006666:	963a                	add	a2,a2,a4
    80006668:	058a8593          	addi	a1,s5,88
    8000666c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000666e:	6294                	ld	a3,0(a3)
    80006670:	96ba                	add	a3,a3,a4
    80006672:	40000613          	li	a2,1024
    80006676:	c690                	sw	a2,8(a3)
  if(write)
    80006678:	e40d19e3          	bnez	s10,800064ca <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000667c:	0001f697          	auipc	a3,0x1f
    80006680:	9846b683          	ld	a3,-1660(a3) # 80025000 <disk+0x2000>
    80006684:	96ba                	add	a3,a3,a4
    80006686:	4609                	li	a2,2
    80006688:	00c69623          	sh	a2,12(a3)
    8000668c:	b5b1                	j	800064d8 <virtio_disk_rw+0xd2>

000000008000668e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000668e:	1101                	addi	sp,sp,-32
    80006690:	ec06                	sd	ra,24(sp)
    80006692:	e822                	sd	s0,16(sp)
    80006694:	e426                	sd	s1,8(sp)
    80006696:	e04a                	sd	s2,0(sp)
    80006698:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000669a:	0001f517          	auipc	a0,0x1f
    8000669e:	a8e50513          	addi	a0,a0,-1394 # 80025128 <disk+0x2128>
    800066a2:	ffffa097          	auipc	ra,0xffffa
    800066a6:	598080e7          	jalr	1432(ra) # 80000c3a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800066aa:	10001737          	lui	a4,0x10001
    800066ae:	533c                	lw	a5,96(a4)
    800066b0:	8b8d                	andi	a5,a5,3
    800066b2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800066b4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800066b8:	0001f797          	auipc	a5,0x1f
    800066bc:	94878793          	addi	a5,a5,-1720 # 80025000 <disk+0x2000>
    800066c0:	6b94                	ld	a3,16(a5)
    800066c2:	0207d703          	lhu	a4,32(a5)
    800066c6:	0026d783          	lhu	a5,2(a3)
    800066ca:	06f70163          	beq	a4,a5,8000672c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800066ce:	0001d917          	auipc	s2,0x1d
    800066d2:	93290913          	addi	s2,s2,-1742 # 80023000 <disk>
    800066d6:	0001f497          	auipc	s1,0x1f
    800066da:	92a48493          	addi	s1,s1,-1750 # 80025000 <disk+0x2000>
    __sync_synchronize();
    800066de:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800066e2:	6898                	ld	a4,16(s1)
    800066e4:	0204d783          	lhu	a5,32(s1)
    800066e8:	8b9d                	andi	a5,a5,7
    800066ea:	078e                	slli	a5,a5,0x3
    800066ec:	97ba                	add	a5,a5,a4
    800066ee:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800066f0:	20078713          	addi	a4,a5,512
    800066f4:	0712                	slli	a4,a4,0x4
    800066f6:	974a                	add	a4,a4,s2
    800066f8:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800066fc:	e731                	bnez	a4,80006748 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800066fe:	20078793          	addi	a5,a5,512
    80006702:	0792                	slli	a5,a5,0x4
    80006704:	97ca                	add	a5,a5,s2
    80006706:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006708:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000670c:	ffffc097          	auipc	ra,0xffffc
    80006710:	f9c080e7          	jalr	-100(ra) # 800026a8 <wakeup>

    disk.used_idx += 1;
    80006714:	0204d783          	lhu	a5,32(s1)
    80006718:	2785                	addiw	a5,a5,1
    8000671a:	17c2                	slli	a5,a5,0x30
    8000671c:	93c1                	srli	a5,a5,0x30
    8000671e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006722:	6898                	ld	a4,16(s1)
    80006724:	00275703          	lhu	a4,2(a4)
    80006728:	faf71be3          	bne	a4,a5,800066de <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000672c:	0001f517          	auipc	a0,0x1f
    80006730:	9fc50513          	addi	a0,a0,-1540 # 80025128 <disk+0x2128>
    80006734:	ffffa097          	auipc	ra,0xffffa
    80006738:	5ba080e7          	jalr	1466(ra) # 80000cee <release>
}
    8000673c:	60e2                	ld	ra,24(sp)
    8000673e:	6442                	ld	s0,16(sp)
    80006740:	64a2                	ld	s1,8(sp)
    80006742:	6902                	ld	s2,0(sp)
    80006744:	6105                	addi	sp,sp,32
    80006746:	8082                	ret
      panic("virtio_disk_intr status");
    80006748:	00002517          	auipc	a0,0x2
    8000674c:	1e050513          	addi	a0,a0,480 # 80008928 <syscalls+0x3c0>
    80006750:	ffffa097          	auipc	ra,0xffffa
    80006754:	e7c080e7          	jalr	-388(ra) # 800005cc <panic>
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
