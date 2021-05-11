#include "kernel/defs.h"
#include "user/user.h"

int main(int argc, char** argv){
    char *s = sbrk(0);
    printf("init: %p\n",s);
    exit(0);

}