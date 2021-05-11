#include "wrapper.h"
#include "user.h"
#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/fs.h"

void search(char *cwd,char *pat){
    char buf[512],*cur;
    struct stat st;
    i32 fd = Open(cwd, O_RDONLY);
    Fstat(fd, &st);
    if (st.type != T_DIR){
        printf("cwd is not a directory");
        exit(0);
    }

    struct dirent child;
    strcpy(buf,cwd);
    cur = buf + strlen(buf);
    *cur++ = '/';
    int index;
    for_(2)
        read(fd, &child, sizeof(child));
    int entries = st.size / (sizeof (struct dirent) );
    for_(entries -2 ){
        Read(fd, &child, sizeof(child));
        if(child.inum == 0)
            continue;
        memcpy(cur,child.name,DIRSIZ);
        *(cur + DIRSIZ) = '\0';
        char *real = strchr(cur,' ');
        if (real != (void*)0)
            *real = '\0';
        Stat(buf,&st);
        switch (st.type)
        {
        case T_FILE:
            if ( (index = strstr(child.name,pat)) >= 0){
                printf("%s \n",buf);
            }
            // else
            //     printf("index %d\n",index); 
            break;
        case T_DIR:
            search(buf,pat);
        default:
            break;
        }
    }

}


int main(int argc, char** argv){
    char *cwd,*pat;
    if (argc == 2){
        cwd = ".";
        pat = argv[1];
    }
    else if (argc == 3){
        cwd = argv[1];
        pat = argv[2];
    }
    else {
        printf("usage : find <path> <pattern>\n");
        exit(0);
    }
    search(cwd,pat);
    exit(0);
}