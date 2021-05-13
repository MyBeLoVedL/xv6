#include "date.h"
#include "defs.h"
#include "memlayout.h"
#include "param.h"
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
  int n;
  if (argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0; // not reached
}

uint64 sys_getpid(void) { return myproc()->pid; }

uint64 sys_fork(void) { return fork(); }

uint64 sys_wait(void) {
  uint64 p;
  if (argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64 sys_sbrk(void) {
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

u64 sys_trace(void) {
  i32 traced;
  if (argint(0, &traced) < 0)
    return -1;
  return trace(traced);
}

u64 sys_alarm(void) {
  i32 tick;
  u64 handler;
  if (argaddr(1, &handler) < 0)
    return -1;
  if (argint(0, &tick) < 0)
    return -1;
  return alarm(tick, (void *)handler);
}

u64 sys_alarmret(void) {
  struct proc *p = myproc();
  // * restore argument registers
  asm volatile("csrrw a0, sscratch, a0");
  asm volatile("ld t0, 112(a0)");
  asm volatile("csrw sscratch, t0");

  asm volatile("ld a1,120(a0)");
  asm volatile("ld a2,128(a0)");
  asm volatile("ld a3,136(a0)");
  asm volatile("ld a4,144(a0)");
  asm volatile("ld a5,152(a0)");
  asm volatile("ld a6,160(a0)");
  asm volatile("ld a7,168(a0)");

  asm volatile("ld t0, 72(a0)");
  asm volatile("ld t1, 80(a0)");
  asm volatile("ld t2, 88(a0)");
  asm volatile("ld t3, 256(a0)");
  asm volatile("ld t4, 264(a0)");
  asm volatile("ld t5, 272(a0)");
  asm volatile("ld t6, 280(a0)");

  asm volatile("csrrw a0, sscratch, a0");

  return 0;
}

uint64 sys_sleep(void) {
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64 sys_kill(void) {
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
