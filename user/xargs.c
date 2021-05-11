#include "user/user.h"
#include "kernel/param.h"

#define MAX_BUF 4096

int readline(int fd,char *buf,int size){
    char ch;
    int i= 0,res ;
    while ((res = Read(fd,&ch,1)) != 0){
        *(buf+i) = ch;
        i++;
        if (ch = '\n')
            break;
    }
    return i;
}


int main(int argc, char** argv){
    char buf[MAXARG * MAXSTRLEN];
    char *args[MAXARG];
    i32 arg_c = 0; 
    char *new_arg[MAXARG];
    char *p; 
    while (readline(0,buf + arg_c * MAXSTRLEN, sizeof(buf) > 0 )){ 
        while (*p != '\n'){ 
            p = buf + arg_c * MAXSTRLEN;
            while (*p == ' ' || *p == '\t')
                p++;
            char *anc = p;
            while (*p != 0 &&  *p != ' ' && *p != '\t')
                p++;
            *p = '\0';
            args[arg_c++] = anc;
        }

        for( int i = 0; i< argc; i++){
            new_arg[i] = argv[i];
        }
        for(int i = 0 ; i< arg_c ;i++){
            new_arg[argc + i] = args[i];
        }
        new_arg[argc + arg_c] = 0;
        if ( fork() == 0 ) {
            exec(new_arg[0],new_arg);
        }
        wait(0);
    }
    exit(0);
}