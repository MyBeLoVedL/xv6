#include "user.h"
#include "kernel/types.h"

int main(int argc, char** argv){
    i32 mask = atoi(argv[1]);
    if (trace(mask) < 0 ) {
        printf("trace error\n");
        exit(1);
    }
    if (fork() == 0){
        exec(argv[2],argv + 2);
    }
    printf("trace end\n");
    exit(0);
}