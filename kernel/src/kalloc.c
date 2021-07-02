// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

// ! a page can be used as page cache,a mapping in process's page table
// ! future possible fields to describe a page :

// ! virtual adress, reference count,mapping,flags ......

// * also , physical pages can be grouped into zone,each page in same zone
// * share same properties.
//* ZONE_DMA 0 - 16 MB
//* ZONE_NORMAL 16-896MB
//* ZONE_HIGHMEM 896- MB

#include "defs.h"
#include "memlayout.h"
#include "param.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.
int page_ref_count[REF_IDX(PHYSTOP)];

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  int free_page;
} kmem[NCPU];

void kinit() {
  for (int i = 0; i < NCPU; i++) {
    initlock(&kmem[i].lock, "kmem");
    kmem[i].free_page = 0;
  }
  uint64 i = 0;
  for (i = 0; i < REF_IDX(PHYSTOP); i++)
    page_ref_count[i] = 0;
  // printf("%p %p total pages %p\n", PHYSTOP, KERNBASE, REF_IDX(PHYSTOP));
  freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end) {
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
  struct run *r;
  push_off();
  int cpu_id = cpuid();
  pop_off();

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  if (page_ref_count[REF_IDX(pa)] < 0) {
    printf("free error %d\n", page_ref_count[REF_IDX(pa)]);
    panic("~~~~~");
  } else if (page_ref_count[REF_IDX(pa)] == 0) {
    goto link;
  } else {
    // printf("free page %p\n", pa);
    page_ref_count[REF_IDX(pa)] -= 1;
    if (page_ref_count[REF_IDX(pa)] > 0) {
      return;
    }

  link:
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run *)pa;

    acquire(&kmem[cpu_id].lock);
    r->next = kmem[cpu_id].freelist;
    kmem[cpu_id].freelist = r;
    kmem[cpu_id].free_page += 1;
    release(&kmem[cpu_id].lock);
  }
}

struct spinlock alloc_lock;
void steal_page(int cur_cpu) {
  acquire(&alloc_lock);
  int max_pages = 0, max_id = 0;
  for (int i = 0; i < NCPU; i++) {
    if (i == cur_cpu)
      continue;
    if (kmem[i].free_page > max_pages) {
      max_pages = kmem[i].free_page;
      max_id = i;
    }
  }
  if (max_pages <= 1) {
    release(&alloc_lock);
    return;
  }
  struct run *head, *t, *prev;
  prev = 0;
  t = head = kmem[max_id].freelist;
  for (int i = 0; i < (int)(max_pages / 2); i++) {
    prev = t;
    t = t->next;
  }
  if (prev)
    prev->next = 0;
  kmem[max_id].freelist = t;
  kmem[max_id].free_page = max_pages - (int)(max_pages / 2);
  kmem[cur_cpu].freelist = head;
  kmem[cur_cpu].free_page = (int)(max_pages / 2);
  release(&alloc_lock);
}

// * a simple fixed-size allocator , a more complicated
// * slab allocator can be implemented.
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
  struct run *r;
  push_off();
  int cpu_id = cpuid();
  pop_off();

  acquire(&kmem[cpu_id].lock);
  r = kmem[cpu_id].freelist;
  if (r) {
    kmem[cpu_id].freelist = r->next;
    kmem[cpu_id].free_page -= 1;
  } else {
    if (kmem[cpu_id].free_page != 0) {
      panic("should not get here");
    }
    steal_page(cpu_id);
    if (kmem[cpu_id].free_page == 0) {
      panic("out of memory");
    }
    r = kmem[cpu_id].freelist;
    if (r) {
      kmem[cpu_id].freelist = r->next;
      kmem[cpu_id].free_page -= 1;
    }
  }
  release(&kmem[cpu_id].lock);

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk

  // tome: in the case that r is NULL,REF simply return a nasty negative
  if (r) {
    if (page_ref_count[REF_IDX(r)] != 0) {
      printf("count %d\n", page_ref_count[REF_IDX(r)]);
      panic("incorrect ref count");
    }
    page_ref_count[REF_IDX(r)] = 1;
  }
  return (void *)r;
}
