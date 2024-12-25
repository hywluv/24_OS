#include "fs.h"
#include "vfs.h"
#include "sbi.h"
#include "defs.h"
#include "printk.h"

char uart_getchar() {
    char ret;
    while (1) {
        struct sbiret sbi_result = sbi_debug_console_read(1, ((uint64_t)&ret - PA2VA_OFFSET), 0);
        // Log("uart_getchar: sbi_result.error = %d, sbi_result.value = %d", sbi_result.error, sbi_result.value);
        if (sbi_result.error == 0 && sbi_result.value == 1) {
            break;
        }
    }
    return ret;
}

int64_t stdin_read(struct file *file, void *buf, uint64_t len) {
    // Log("stdin_read: len = %d", len);
    char *buffer = (char *)buf;
    for (uint64_t i = 0; i < len; i++) {
        // Log("stdin_read: buffer[%d] = %c", i, buffer[i]);
        buffer[i] = uart_getchar();
        // Log("stdin_read: buffer[%d] = %c", i, buffer[i]);
    }
    return len;
}

int64_t stdout_write(struct file *file, const void *buf, uint64_t len) {
    char to_print[len + 1];
    for (int i = 0; i < len; i++) {
        to_print[i] = ((const char *)buf)[i];
    }
    to_print[len] = 0;
    return printk(buf);
}

int64_t stderr_write(struct file *file, const void *buf, uint64_t len) {
    // todo
    char to_print[len + 1];
    for (int i = 0; i < len; i++) {
        to_print[i] = ((const char *)buf)[i];
    }
    to_print[len] = 0;
    
    // stderr
    printk("[stderr] %s", to_print);
    return len;  // return the length of the string
}
