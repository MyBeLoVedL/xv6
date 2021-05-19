#include "user.h"
int main(int argc, char **argv) {
  if (argc != 2) {
    printf("input at least one argument");
    exit(0);
  }
  char *p = malloc(sizeof(argv[1]) + 1);
  strcpy(p, argv[1]);

  p[0] = 'x';
  printf("%s\n", p);
  char *q = malloc(sizeof(argv[1]) + 1);
  q[0] = 'y';
  printf("%s\n", q);
  exit(0);
  return 0;
}
