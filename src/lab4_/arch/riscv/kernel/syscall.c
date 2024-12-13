#include "syscall.h"

extern struct task_struct *get_current_proc();

int sys_write(unsigned int fd, const char* buf, unsigned int size) {
    int cnt = 0;
    if (fd == STDOUT) {
        for (cnt = 0; cnt < size && buf[cnt]; ++cnt) putc(buf[cnt]);
        return cnt;
    }
    return -1;
}

int sys_getpid(){
    struct task_struct *current = get_current_proc();
    return current->pid;
}