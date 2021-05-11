#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
  i32 res = pipe(p);
  if (res < 0) {
    fprintf(2, "pipe creation error");
  }
  return res;
}

int Write(int fd, void *buf, int count){
  i32 res = write(fd, buf, count);
  if (res < 0) {
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}



int Read(int fd,  void*buf, int count){
  i32 res = read(fd, buf, count);
  if (res < 0) {
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}


int Open(const char* path, int flag){
  i32 res = open(path, flag);
  if (res < 0) {
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}


int Fstat(int fd, stat_t *st){
  i32 res = fstat(fd, st);
  if (res < 0) {
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}



int Dup(int fd){
  i32 res = dup(fd);
  if (res < 0) {
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}

int Close(int fd){
  i32 res = close(fd);
  if (res < 0) {
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}

int Dup2(int old_fd,int new_fd){
  Close(new_fd);
  i32 res = Dup(old_fd);
  if (res < 0) {
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}

int Stat(const char*link,stat_t *st){
  i32 res = stat(link,st);
  if (res < 0) {
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}

// s as the source string,p as pattern to search
int strstr(char *s,char *p){
   char *ori = s;
   while (*s != 0){
     if (!strncmp(s,p,strlen(p)))
      return s - ori;
     s++;
   }
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
  int n2 = MIN(n,strlen(pat));
  memmove(buf1,s,n1);
  memmove(buf2,pat,n2);
  return strcmp(buf1,buf2);
}


// char *strip(char *s)
// {
//     while (*s == ' ' || *s == '\t')
//     {
//         s++;
//     }
//     char *src = strdup(s);
//     char *p = src + strlen(src) - 1;
//     while (*p == ' ' || *p == '\t')
//     {
//         p--;
//     }
//     if (p >= src)
//         *(p + 1) = '\0';
//     return src;
// }

// char **split(char *s)
// {
//     char *src = strip(s);
//     u32 len = strlen(src);
//     char *cur = src;
//     char *ori = src;
//     char **res = malloc(sizeof(char *) * 1024);
//     char tmp[1024];
//     u32 i = 0, each_str = 0, cur_len = 0;
//     while (*cur != 0)
//     {
//         if (*cur == ' ' || *cur == '\t')
//         {
//             *cur = 0;
//             res[each_str++] = strdup(src);
//             cur++;
//             cur_len++;
//             while (*cur == ' ' || *cur == '\t')
//             {
//                 cur++;
//                 cur_len++;
//             }
//             src += cur_len;
//             cur_len = 0;
//             continue;
//         }
//         cur_len++;
//         cur++;
//     }
//     res[each_str++] = strdup(src);
//     res[each_str] = NULL;
//     free(ori);
//     return res;
// }

