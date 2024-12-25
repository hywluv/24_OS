#include "stdint.h"
#include "printk.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"
#include "vm.h"
#include "vfs.h"

extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();
extern char _sramdisk[];
void do_page_fault(struct pt_regs *regs);

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs)
{
    // 通过 `scause` 判断 trap 类型
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    // Err("trap_handler: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    if (scause & 0x8000000000000000)
    {
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
        if (interrupt_t == 0x5)
        {
            // timer interrupt
            // printk("timer interrupt, time = %ld\n", get_cycles());
            clock_set_next_event();
            do_timer();
        }
        else
        {
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        }
    }
    else
    {
        // exception
        if (scause == ECALL_FROM_U_MODE)
        {
            uint64_t syscall_id = regs->a[7];
            // printk("[trap_handler] ecall from user mode, syscall_id = %ld\n", syscall_id);

            switch (syscall_id)
            {
            case SYS_WRITE:
            {
                uint64_t fd = (unsigned int)regs->a[0];
                const char *buf = (const char *)regs->a[1];
                uint64_t count = (size_t)regs->a[2];
                int64_t ret = sys_write(fd, buf, count);
                regs->a[0] = ret;
                break;
            }

            case SYS_GETPID:
            {
                uint64_t pid = sys_getpid();
                regs->a[0] = pid;
                break;
            }

            case SYS_CLONE:
            {
                uint64_t ret = do_fork(regs);
                regs->a[0] = ret;
                break;
            }

            case SYS_READ:
            {
                // Log("fildes = %ld, buf = %lx, nbyte = %ld", regs->a[0], regs->a[1], regs->a[2]);
                // struct file *file = (struct file *)regs->a[0];
                // void *buf = (void *)regs->a[1];
                // uint64_t len = (uint64_t)regs->a[2];
                // int64_t ret = stdin_read(file, buf, len);
                // regs->a[0] = ret;
                // break;
                uint64_t fd = (uint64_t)regs->a[0];
                void *buf = (void *)regs->a[1];
                uint64_t len = (uint64_t)regs->a[2];
                int64_t ret = sys_read(fd, buf, len);
                regs->a[0] = ret;
                break;
            }

            case SYS_OPENAT:
            {
                // Log("path = %lx, flags = %ld", regs->a[0], regs->a[1]);
                int dfd = (int)regs->a[0];
                const char *path = (const char *)regs->a[1];
                int64_t flags = (int64_t)regs->a[2];
                int64_t ret = sys_openat(dfd, path, flags);
                regs->a[0] = ret;
                break;
            }

            case SYS_CLOSE:
            {
                int64_t fd = (int64_t)regs->a[0];
                int64_t ret = sys_close(fd);
                regs->a[0] = ret;
                break;
            }

            case SYS_LSEEK:
            {
                uint64_t fd = (uint64_t)regs->a[0];
                int64_t offset = (int64_t)regs->a[1];
                uint64_t whence = (uint64_t)regs->a[2];
                int64_t ret = sys_lseek(fd, offset, whence);
                regs->a[0] = ret;
                break;
            }

            default:
                Err("unimplemented syscall_id: %ld\n", syscall_id);
                break;
            }

            regs->sepc += 4;
            return;
        }
        else if (scause == INST_PAGE_FAULT)
        {
            // Warning("pc @ %lx, instruction page fault, stval = %lx", sepc, csr_read(stval));
            do_page_fault(regs);
        }
        else if (scause == LOAD_PAGE_FAULT)
        {
            // Warning("pc @ %lx, load page fault, stval = %lx", sepc, csr_read(stval));
            do_page_fault(regs);
        }
        else if (scause == STORE_PAGE_FAULT)
        {
            // Warning("pc @ %lx, store page fault, stval = %lx", sepc, csr_read(stval));
            do_page_fault(regs);
        }
        else
        {
            printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        }
    }
}

void do_page_fault(struct pt_regs *regs)
{
    uint64_t bad_addr = csr_read(stval);
    struct vm_area_struct *vma = find_vma(&(get_current_proc()->mm), bad_addr);
    if (!vma)
    {
        Err("do_page_fault: cannot find vma, bad_addr = %lx", bad_addr);
    }

    uint64_t scause = csr_read(scause);
    switch (scause)
    {
    case INST_PAGE_FAULT:
        if (!(vma->vm_flags & VM_EXEC))
        {
            Err("do_page_fault: instruction page fault, bad_addr = %lx", bad_addr);
        }
        break;

    case LOAD_PAGE_FAULT:
        if (!(vma->vm_flags & VM_READ))
        {
            Err("do_page_fault: load page fault, bad_addr = %lx", bad_addr);
        }
        break;

    case STORE_PAGE_FAULT:
        if (!(vma->vm_flags & VM_WRITE))
        {
            Err("do_page_fault: store page fault, bad_addr = %lx", bad_addr);
        }
        break;

    default:
        Err("do_page_fault: unknown page fault, scause = %d, bad_addr = %lx", scause, bad_addr);
        break;
    }

    if (vma->vm_flags & VM_ANON)
    {
        uint64_t *pg = (uint64_t *)alloc_page();
        uint64_t pa_s = VA2PA(pg);
        memset((void *)pg, 0, PGSIZE);
        uint64_t va_s = PGROUNDDOWN(bad_addr);
        uint64_t *pgtbl = get_current_proc()->pgd;
        uint64_t perm = vmflags2pte(vma->vm_flags) | PTE_V | PTE_U;
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
    }
    else
    {
        uint64_t perm = vmflags2pte(vma->vm_flags) | PTE_V | PTE_U;
        uint64_t *pgtbl = get_current_proc()->pgd;
        uint64_t file_start = (uint64_t)_sramdisk + vma->vm_pgoff;
        uint64_t file_end = file_start + vma->vm_filesz;
        uint64_t offset = bad_addr - vma->vm_start;
        uint64_t file_page_start = PGROUNDDOWN(file_start + offset); // 文件一页的起点 拷贝到分配的物理页
        uint64_t *pg = (uint64_t *)alloc_page();
        memset((void *)pg, 0, PGSIZE);
        if (file_page_start < file_end)
        {
            uint64_t sz = PGSIZE;
            if (file_page_start + sz > file_end)
            {
                sz = file_end - file_page_start;
            }
            memcpy((void *)pg, (void *)file_page_start, sz);
        }
        uint64_t va_s = PGROUNDDOWN(bad_addr); // 映射的起点 与物理页做映射
        uint64_t pa_s = VA2PA(pg);
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
    }
}