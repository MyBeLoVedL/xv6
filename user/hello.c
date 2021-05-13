#include "user.h"
void sayyou();

void sayhi() {
  printf("hi~\n");
  alarm(10, sayyou);
  alarmret();
}

void sayyou() {
  printf("you~\n");
  alarm(10, sayhi);
  alarmret();
}

int main(int argc, char **argv) {
  char *s = sbrk(0);
  char ch;
  alarm(10, sayyou);
  printf("address of hi %p\n", sayhi);
  printf("address of you %p\n", sayyou);
  while (1) {
    for (u64 i = 0; i <= 0xfffffff; i++)
      ch = 9;
    printf("I am in user mode~\n");
    // sleep(5);
    ;
  }

  // char a[4096];
  // char b[4096];
  // printf("init: %p\n", s);
  // sleep(10);
  // a[4095] = 'b';
  // b[4095] = 'a';
  // printf("%d\n", b[4095]);
  // printf("a:%p\n", a);
  // printf("b:%p\n", b);
  exit(0);
}