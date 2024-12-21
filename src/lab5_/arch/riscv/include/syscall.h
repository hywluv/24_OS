#ifndef __SYSCALL_H__
#define __SYSCALL_H__

#include "defs.h"
#include "proc.h"
#include "printk.h"
#include "vm.h"

#define SYS_WRITE 64
#define SYS_GETPID 172
#define SYS_CLONE 220

#define STDOUT 1

int sys_write(unsigned int fd, const char* buf, unsigned int size);
int sys_getpid();
uint64_t do_fork(struct pt_regs *regs);

#endif