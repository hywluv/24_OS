#include "printk.h"
#include "defs.h"

extern void test();

int start_kernel() {
    printk("2024");
    printk(" ZJU Operating System\n");
    unsigned long sstatus_value = csr_read(sstatus);
    printk("sstatus: %lx\n", sstatus_value);
    unsigned long test_value = 0x12345678;
    csr_write(sscratch, test_value);
    unsigned long read_value = csr_read(sscratch);
    if(read_value == test_value) {
        printk("Write to ssctatch successful: 0x%lx\n", read_value);
    } else {
        printk("Write to sscratch failed. Expected: 0x%lx, Got: 0x%lx\n", test_value, read_value);
    }
    test();
    return 0;
}
