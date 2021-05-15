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
  struct proc *p = myproc();
  addr = p->sz;
  p->sz += n;
  if (n < 0) {
    uvmdealloc(p->pagetable, addr, p->sz);
  }
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

extern struct trapframe handler_frame;
extern u8 re_en;
u64 sys_alarmret(void) {
  struct proc *p = myproc();
  // * restore argument registers
  memmove(p->trapframe, &handler_frame, sizeof(handler_frame));
  re_en = 0;
  usertrapret();
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
