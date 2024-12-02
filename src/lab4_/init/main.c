#include "printk.h"
#include "defs.h"

extern void test();

int start_kernel() {
    printk("2024");
    printk(" ZJU Operating System\n");
    // verify_vm();

    test();
    return 0;
}

void test_rodata_write(uint64_t *addr) {
    uint64_t backup = *addr;
    int success = 1;

    asm volatile(
        "li t0, 1\n"
        "sd t0, 0(%1)\n"
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原值
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}

void test_rodata_exec(uint64_t *addr) {
    int success = 1;

    asm volatile(
        "jalr %1\n"
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}

void test_text_read(uint64_t *addr) {
    printk(".text read test: ");
    uint64_t value = *addr;
    printk("PASS: Read succeeded, value = %lx\n", value);
}

void test_text_write(uint64_t *addr) {
    uint64_t backup = *addr; // 备份原始值
    int success = 1;

    asm volatile(
        "li t0, 1\n"           // 加载值 1
        "sd t0, 0(%1)\n"       // 尝试写入 .text 段
        "li %0, 0\n"           // 如果写入成功，将 success 置为 0
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
        printk("PASS: .text write failed as expected.\n");
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}

void test_text_exec() {
    printk("Executing .text segment test: ");
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
}

void verify_vm() {
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;

    // .text R
    printk(".text read test: \n");
    test_text_read(test_addr);

    // .text W
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
    test_text_exec();

    // .rodata
    test_addr = (uint64_t *)va_rodata;

    // .rodata R
    printk(".rodata read test: \n");
    uint64_t value = *test_addr;
    printk("PASS: Read succeeded, value = %lx\n", value);

    // .rodata W/X
    // Invalid operation, should trigger an exception
    
    // printk(".rodata write test: \n");
    // test_rodata_write((uint64_t *)va_rodata);

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
}