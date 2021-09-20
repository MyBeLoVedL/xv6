#include "defs.h"
#include "elf.h"
#include "fcntl.h"
#include "file.h"
#include "fs.h"
#include "memlayout.h"
#include "param.h"
#include "proc.h"
#include "riscv.h"
#include "types.h"

/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[]; // kernel.ld sets this to end of kernel code.
extern int page_ref_count[];
extern struct spinlock ref_lock;

extern char trampoline[]; // trampoline.S

/*
 * create a direct-map page table for the kernel.
 */
void kvminit() {
  kernel_pagetable = (pagetable_t)kalloc();
  memset(kernel_pagetable, 0, PGSIZE);

  // uart registers
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

  // CLINT
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);

  // PLIC
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);

  // map kernel text executable and read-only.
  kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);

  // map kernel data and the physical RAM we'll make use of.
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
  if (va >= MAXVA)
    return 0;

  for (int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if (pte == 0)
    return 0;
  if ((*pte & PTE_V) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void kvmmap(uint64 va, uint64 pa, uint64 sz, int perm) {
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

// translate a kernel virtual address to
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64 kvmpa(uint64 va) {
  uint64 off = va % PGSIZE;
  pte_t *pte;
  uint64 pa;

  pte = walk(kernel_pagetable, va, 0);
  if (pte == 0)
    panic("kvmpa");
  if ((*pte & PTE_V) == 0)
    panic("kvmpa");
  pa = PTE2PA(*pte);
  return pa + off;
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if (*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
  uint64 a;
  pte_t *pte;

  // printf("va %p npages %d\n", va, npages);
  if ((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");
  // int total = 0;
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    if ((pte = walk(pagetable, a, 0)) == 0)
      continue;
    // panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      continue;
    // panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
  // if (myproc()->pid == 5) {
  //   backtrace();
  //   printf("sz %p pages %d  freed pages %d\n", myproc()->sz, npages, total);
  // }
}

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
  if (pagetable == 0)
    return 0;
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz) {
  char *mem;

  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
  memmove(mem, src, sz);
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
  char *mem;
  uint64 a;

  if (newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for (a = oldsz; a < newsz; a += PGSIZE) {
    mem = kalloc();
    if (mem == 0) {
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if (mappages(pagetable, a, PGSIZE, (uint64)mem,
                 PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
  if (newsz >= oldsz)
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    }
  }
  kfree((void *)pagetable);
}

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
  if (sz > 0)
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
}

// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 i, pa;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE) {
    if ((pte = walk(old, i, 0)) == 0)
      continue;
    // panic("uvmcopy: pte should exist");
    if ((*pte & PTE_V) == 0)
      continue;
    // panic("uvmcopy: page not present");
    flags = PTE_FLAGS(*pte);
    pa = PTE2PA(*pte);
    pte_t *new_pte = walk(new, i, 1);
    if (new_pte == 0) {
      goto err;
    }
    *pte &= ~PTE_W;
    *pte |= PTE_COW;
    *new_pte = *pte;
    acquire(&ref_lock);
    page_ref_count[REF_IDX(pa)] += 1;
    release(&ref_lock);
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
  pte_t *pte;

  pte = walk(pagetable, va, 0);
  if (pte == 0)
    panic("uvmclear");
  *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    va0 = PGROUNDDOWN(dstva);
    pte_t *pte = walk(pagetable, va0, 0);
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
      if (do_lazy_allocation(myproc()->pagetable, va0) != 0) {
        return -1;
      }
    } else if (pte && (*pte & PTE_COW)) {
      if (do_cow(pagetable, va0) != 0)
        return -2;
    }
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if (n > max)
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
        got_null = 1;
        break;
      } else {
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    return 0;
  } else {
    return -1;
  }
}

int do_cow(pagetable_t pt, uint64 addr) {
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;
  uint64 va = PGROUNDDOWN(addr);
  if ((pte = walk(pt, va, 0)) == 0)
    panic("uvmcopy: pte should exist");
  if ((*pte & PTE_V) == 0)
    panic("uvmcopy: page not present");
  pa = PTE2PA(*pte);
  flags = PTE_FLAGS(*pte);
  flags |= PTE_W;
  flags &= ~PTE_COW;
  acquire(&ref_lock);
  if (page_ref_count[REF_IDX(pa)] == 1) {
    *pte |= PTE_W;
    *pte &= ~PTE_COW;
    release(&ref_lock);
    return 0;
  }
  page_ref_count[REF_IDX(pa)] -= 1;
  release(&ref_lock);
  if ((mem = kalloc()) == 0)
    return -1;
  memmove(mem, (char *)pa, PGSIZE);
  *pte = PA2PTE(mem) | flags;

  return 0;
}

int do_lazy_allocation(pagetable_t pt, u64 addr) {
  u64 va, pa;
  va = PGROUNDDOWN(addr);
  if ((pa = (u64)kalloc()) == 0) {
    // uvmdealloc(pt, va + PGSIZE, va);
    return -1;
  }
  memset((void *)pa, 0, PGSIZE);
  if (mappages(pt, va, PGSIZE, pa, PTE_R | PTE_W | PTE_X | PTE_U) != 0) {
    kfree((void *)pa);
    // uvmdealloc(pt, va + PGSIZE, va);
    return -2;
  }
  return 0;
}
void *find_avail_addr_range(vma_t *vma) {
  void *avail = (void *)VMA_ORIGIN;
  for (int i = 0; i < MAX_VMA; i++) {
    if ((vma + i)->used) {
      if ((vma + i)->start + (vma + i)->length > avail)
        avail =
            (void *)PGROUNDUP((uint64)((vma + i)->start + (vma + i)->length));
    }
  }
  return avail;
}

int do_vma(void *addr, vma_t *vma) {
  if (addr < vma->start || addr >= vma->start + vma->length)
    panic("invalid mmap!!!");
  void *pa;
  if ((pa = kalloc()) == 0)
    return -1;
  memset(pa, 0, PGSIZE);
  if (!(vma->flag & MAP_ANNO)) {
    uint file_off = ((addr - vma->start + vma->offset) >> 12) << 12;
    ilock(vma->mmaped_file->ip);
    int rc = 0;
    if ((rc = readi(vma->mmaped_file->ip, 0, (uint64)pa, file_off, PGSIZE)) <
        0) {
      printf("read failed , actual read %d\n", rc);
      return -2;
    }
    iunlock(vma->mmaped_file->ip);
  }

  // * set proper PTE permission
  int perm = PTE_U;
  if (vma->flag & MAP_ANNO) {
    perm |= PTE_R | PTE_W;
  } else {
    if ((vma->mmaped_file->readable) && (vma->proct & PROT_READ))
      perm |= PTE_R;
    if (((vma->mmaped_file->writable) ||
         (vma->mmaped_file->readable && (vma->proct & MAP_PRIVATE))) &&
        (vma->proct & PROT_WRITE))
      perm |= PTE_W;
    if (vma->proct & PROT_EXEC)
      perm |= PTE_X;
  }
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
               (uint64)pa, perm) < 0)
    return -3;
  // printf("hello in do vma\n");
  return 0;
}

void *mmap(void *addr, u64 length, int proct, int flag, int fd, int offset) {
  struct proc *p = myproc();
  int i;

  // ! error checking for fd
  if ((fd < 0 && !(flag & MAP_ANNO)) || fd > NOFILE ||
      (fd > 0 && !p->ofile[fd]))
    goto err;
  if ((proct & PROT_WRITE) && (fd > 0 && !p->ofile[fd]->writable) &&
      (flag & MAP_SHARED))
    goto err;

  for (i = 0; i < MAX_VMA; i++) {
    if (!p->vma[0].used) {
      p->vma[i].mmaped_file = !(flag & MAP_ANNO) ? filedup(p->ofile[fd]) : 0;
      p->vma[i].used = 1;
      p->vma[i].length = length;
      p->vma[i].proct = proct;
      p->vma[i].offset = offset;
      p->vma[i].flag = flag;
      // * if not desinate an address
      if (addr == 0)
        addr = find_avail_addr_range(&p->vma[0]);
      p->vma[i].start = addr;
      p->vma[i].origin = addr;
      break;
    }
  }

  if (i == MAX_VMA)
    return (void *)-1;

  return p->vma[i].start;

err:
  return (void *)-1;
}

int munmap(void *addr, int length) {
  // printf("~~~hello in unmap\n");
  vma_t *vma;
  struct proc *p = myproc();
  uint8 valid = 0;
  for (int i = 0; i < MAX_VMA; i++) {
    if (p->vma[i].start == addr && p->vma[i].length >= length) {
      vma = &p->vma[i];
      valid = 1;
      break;
    }
  }
  if (!valid) {
    printf("not in vma\n");
    return -1;
  }
  int left = length, should_write = 0;
  void *cur = addr;
  if (!(vma->flag & MAP_ANNO))
    vma->mmaped_file->off = cur - vma->origin + vma->offset;
  for (cur = addr; cur < addr + length; cur += should_write) {
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    if (!pte)
      continue;
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    left -= should_write;
    int wc = -9;
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
      wc = filewrite(vma->mmaped_file, (uint64)cur, should_write);
      if (wc < 0) {
        printf("res %d offset %d cur %p should %d vma write %d\n", wc,
               vma->mmaped_file->off, cur, should_write, wc);
        return -1;
      }
    } // else {
    //   printf("length %d should write %d  write %d\n", length, should_write,
    //   wc);
    // }
    if ((*pte & PTE_V) &&
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
         (should_write == vma->length))) {
      // printf("unmap once\n");
      uvmunmap(p->pagetable, PGROUNDDOWN((uint64)cur), 1, 1);
    }
  }
  if (length == vma->length) {
    if (!(vma->flag & MAP_ANNO))
      fileclose(vma->mmaped_file);
    memset(vma, 0, sizeof(*vma));
    vma->used = 0;
  } else {
    vma->start += length;
    vma->length -= length;
  }
  return 0;
}