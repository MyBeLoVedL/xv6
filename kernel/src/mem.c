#include "defs.h"
#include "riscv.h"

typedef struct page {
  void *cur;
} page_t;

typedef struct allocator {
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
  alloc.next_page = kalloc();
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
}

void *mallo(u32 size) {
  if (!if_init) {
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  printf("size %d ", size);
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
              sizeof(page_t);
  if (avail > size) {
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
  } else {
    printf("malloc failed");
    return 0;
  }
  return res;
}

void free(void *p) { return; }