#include "wrapper.h"
#include "user.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/types.h"


int main(int argc, char** argv){
    if (argc < 2){
        printf("usage: <file to be created>");
        exit(0);
    }

    char **p = argv + 1;
    while (*p != (void*)0){
        Open(*p,O_WRONLY|O_CREATE);
        p++;
    }
    exit(0);
}
