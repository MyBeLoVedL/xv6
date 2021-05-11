#pragma once
#include "kernel/stat.h"

int Pipe(int *p);
int Write(int fd, void *buf, int count);
int Read(int fd, void *buf, int count);
int Open(const char *path, int flag);
int Fstat(int fd, stat_t *st);
int Stat(const char *link, stat_t *st);

// s as the source string,p as pattern to search
int strstr(char *s, char *p);

#define for_(num) for (int i = 0; i < num; i++)
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define ABS(a) ((a) >= 0 ? (a) : (-(a)))

#define SWAP(pa, pb) ({ __typeof__(*pa) tmp = (*pb); (*pb) = (*pa); (*pa) = tmp; })
