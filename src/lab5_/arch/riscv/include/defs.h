#ifndef __DEFS_H__
#define __DEFS_H__

#include "stdint.h"

#define csr_read(csr)                   \
  ({                                    \
    uint64_t __v;                       \
    asm volatile("csrr %0, " #csr       \
                 : "=r"(__v)            \
                 :                      \
                 : "memory");           \
    __v;                                \
  })

#define csr_write(csr, val)                                    \
  ({                                                           \
    uint64_t __v = (uint64_t)(val);                            \
    asm volatile("csrw " #csr ", %0" : : "r"(__v) : "memory"); \
  })

// lab2
#define PHY_START 0x0000000080000000
#define PHY_SIZE 128 * 1024 * 1024 // 128 MiB，QEMU 默认内存大小
#define PHY_END (PHY_START + PHY_SIZE)

#define PGSIZE 0x1000 // 4 KiB
#define PGROUNDUP(addr) ((addr + PGSIZE - 1) & (~(PGSIZE - 1)))
#define PGROUNDDOWN(addr) (addr & (~(PGSIZE - 1)))

// lab3
#define OPENSBI_SIZE (0x200000)
#define EARLY_PGSIZE (1 << 30)

#define VM_START (0xffffffe000000000)
#define VM_END (0xffffffff00000000)
#define VM_SIZE (VM_END - VM_START)

#define PA2VA_OFFSET (VM_START - PHY_START)
#define PA2VA(pa) (((uintptr_t)(pa) + (uint64_t)PA2VA_OFFSET))
#define VA2PA(va) (((uintptr_t)(va) - (uint64_t)PA2VA_OFFSET))

#define PTE_V (1 << 0)
#define PTE_R (1 << 1)
#define PTE_W (1 << 2)
#define PTE_X (1 << 3)
#define PTE_U (1 << 4)
#define PTE_G (1 << 5)
#define PTE_A (1 << 6)
#define PTE_D (1 << 7)
#define PTE_ISVALID(pte) ((pte) & PTE_V)

#define SV39 (8L)

// lab4

#define USER_START (0x0000000000000000) // user space start virtual address
#define USER_END (0x0000004000000000) // user space end virtual address

#define SSTATUS_SPIE (1L << 5)
#define SSTATUS_SUM (1L << 18)
#define SSTATUS_SPP (1L << 8)

#define ECALL_FROM_U_MODE 0x8

// lab5 
#define Err(format, ...) {                              \
    printk("\33[1;31m[%s,%d,%s] " format "\33[0m\n",    \
        __FILE__, __LINE__, __func__, ## __VA_ARGS__);  \
    while(1);                                           \
}

#define Warning(format, ...) \
    printk("\33[1;33m[%s,%d,%s] " format "\33[0m\n", \
        __FILE__, __LINE__, __func__, ## __VA_ARGS__)

#define Log(format, ...) \
    printk("\33[1;35m[%s,%d,%s] " format "\33[0m\n", \
        __FILE__, __LINE__, __func__, ## __VA_ARGS__)

#define VM_ANON 0x1
#define VM_READ 0x2
#define VM_WRITE 0x4
#define VM_EXEC 0x8

#define INST_PAGE_FAULT 0x0c
#define LOAD_PAGE_FAULT 0x0d
#define STORE_PAGE_FAULT 0x0f

#endif
