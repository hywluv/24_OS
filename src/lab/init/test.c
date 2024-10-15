#include "sbi.h"
#include "printk.h"

// test for kernel_boot
// void test() {
//     sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
    int i = 0;
    while (1)
    {
        if ((++i) % 100000000 == 0)
        {
            printk("kernel is running!\n");
            i = 0;
        }
    }
}
