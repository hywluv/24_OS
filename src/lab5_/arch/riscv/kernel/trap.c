#include "stdint.h"
#include "printk.h"
#include "proc.h"
#include "syscall.h"

extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc,struct pt_regs *regs) {
    // 通过 `scause` 判断 trap 类型
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
        if (interrupt_t == 0x5) {
            // timer interrupt
            // printk("timer interrupt, time = %ld\n", get_cycles());
            clock_set_next_event();
            do_timer();
        } else{
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        }
    }
    else {
        // exception
        if(scause == ECALL_FROM_U_MODE) {
            uint64_t syscall_id = regs->a[7];
            printk("[trap_handler] ecall from user mode, syscall_id = %ld\n", syscall_id);
            if(syscall_id == SYS_WRITE){
                unsigned int fd = (unsigned int)regs->a[0];
                const char *buf = (const char *)regs->a[1];
                size_t count = (size_t)regs->a[2];
                uint64_t ret = sys_write(fd, buf, count);
                regs->a[0] = ret;
            } else if (syscall_id == SYS_GETPID){
                uint64_t pid = sys_getpid();
                regs->a[0] = pid;
            } else {
                printk("unimplemented syscall_id: %ld\n", syscall_id);
            }
            regs->sepc += 4;
            return;
        }
    }
}