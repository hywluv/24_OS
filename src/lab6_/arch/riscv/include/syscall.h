#ifndef __SYSCALL_H__
#define __SYSCALL_H__

#include "defs.h"
#include "proc.h"
#include "printk.h"
#include "stdint.h"

#define SYS_WRITE 64
#define SYS_GETPID 172
#define SYS_CLONE 220
#define SYS_READ 63
#define SYS_OPENAT 56
#define SYS_CLOSE 57
#define SYS_LSEEK 62

#define STDOUT 1

// int sys_write(unsigned int fd, const char* buf, unsigned int size);
int64_t sys_write(uint64_t fd, const char *buf, uint64_t len);
int sys_getpid();
uint64_t do_fork(struct pt_regs *regs);
void copy_vma(struct task_struct *child, struct task_struct *parent);
uint64_t strncmp(const char *s1, const char *s2, int n);
int64_t sys_openat(int dfd, const char *path, int flags);
int64_t sys_close(int64_t fd);
int64_t sys_lseek(uint64_t fd, int64_t offset, uint64_t whence);
int64_t sys_read(uint64_t fd, void *buf, uint64_t len);
#endif