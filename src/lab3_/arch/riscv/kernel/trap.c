#include "stdint.h"
#include "printk.h"

extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc) {
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
            clock_set_next_event();
            do_timer();
        } else{
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        }
    }
    else {
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        // exception
    }
}