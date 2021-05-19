#include "user.h"

int main(int argc, char **argv) {
  if (argc != 2) {
    printf("input at least one argument");
    exit(0);
  }

  char *p = 0;
  printf("size %d\n", sizeof(argv[1]));
  for_(1000) {
    p = l_alloc(sizeof(argv[1]) + 1);
    if (!p)
      exit(0);
    strcpy(p, argv[1]);
    p[0] = (i % 26) + 'a';
    printf("%s addr :%p \n", p, p);
  }
  exit(0);
  return 0;
}
