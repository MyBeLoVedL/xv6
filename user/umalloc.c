#include "kernel/param.h"
// #include "kernel/stat.h"
#include "kernel/types.h"
#include "user.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.

typedef long Align;

union header {
  struct {
    union header *ptr;
    uint size;
  } s;
  Align x;
};

typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
  Header *bp, *p;

  bp = (Header *)ap - 1;
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}

static Header *morecore(uint nu) {
  char *p;
  Header *hp;

  if (nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if (p == (char *)-1)
    return 0;
  hp = (Header *)p;
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
  if ((prevp = freep) == 0) {
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    if (p->s.size >= nunits) {
      if (p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}

typedef struct page {
  void *cur;
} page_t;

typedef struct allocator {
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
  alloc.next_page = (page_t *)sbrk(PGSIZE);
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
}

void *l_alloc(u32 size) {
  if (!if_init) {
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
              sizeof(page_t);
  if (avail > size) {
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
  } else {
    return 0;
  }
  return res;
}

void l_free(void *p) { return; }