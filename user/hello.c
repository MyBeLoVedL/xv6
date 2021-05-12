#include "user.h"

int main(int argc, char **argv) {
  char *s = sbrk(0);
  char a[4096];
  char b[4096];
  printf("init: %p\n", s);
  sleep(10);
  a[4095] = 'b';
  b[4095] = 'a';
  //   printf("%d\n", b[4095]);
  //   printf("a:%p\n", a);
  //   printf("b:%p\n", b);
  exit(0);
}