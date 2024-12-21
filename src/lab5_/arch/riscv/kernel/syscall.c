#include "syscall.h"

extern struct task_struct *get_current_proc();
extern int putc(int c);
extern void __ret_from_fork();

int sys_write(unsigned int fd, const char *buf, unsigned int size)
{
    int cnt = 0;
    if (fd == STDOUT)
    {
        for (cnt = 0; cnt < size && buf[cnt]; ++cnt)
            putc(buf[cnt]);
        return cnt;
    }
    return -1;
}

int sys_getpid()
{
    struct task_struct *current = get_current_proc();
    return current->pid;
}

uint64_t do_fork(struct pt_regs *regs)
{
    struct task_struct *child_task = (struct task_struct *)kalloc();
    if (get_nr_tasks() >= NR_TASKS || !child_task)
    {
        Err("do_fork: failed to fork\n");
    }
    memcpy(child_task, get_current_proc(), PGSIZE);
    child_task->pid = get_nr_tasks();
    child_task->state = TASK_RUNNING;
    child_task->counter = 0;
    child_task->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
    child_task->mm.mmap = NULL;

    // copy pgd
    child_task->pgd = (uint64_t *)alloc_page();
    memcpy(child_task->pgd, get_kernel_pgtbl(), PGSIZE);

    // copy vma
    copy_vma(child_task, get_current_proc());

    // copy regs
    child_task->thread.ra = (uint64_t)__ret_from_fork;
    struct pt_regs *child_regs = (struct pt_regs *)((uint64_t)child_task + (uint64_t)regs - (uint64_t)get_current_proc());
    child_task->thread.sp = (uint64_t)child_regs;
    child_task->thread.sepc = regs->sepc;
    child_task->thread.sscratch = csr_read(sscratch);
    child_regs->a[0] = 0;
    child_regs->sp = child_task->thread.sp;
    child_regs->sepc += 4;

    return add_task(child_task);
}

void copy_vma(struct task_struct *child, struct task_struct *parent)
{
    struct vm_area_struct *p_vma = parent->mm.mmap;
    struct vm_area_struct *c_vma = NULL, *new_vma = NULL;

    while (p_vma)
    {
        do_mmap(&child->mm, p_vma->vm_start, p_vma->vm_end - p_vma->vm_start, p_vma->vm_pgoff, p_vma->vm_filesz, p_vma->vm_flags);

        uint64_t start_addr = PGROUNDDOWN(p_vma->vm_start);
        uint64_t end_addr = PGROUNDUP(p_vma->vm_end);

        for (uint64_t va = start_addr; va < end_addr; va += PGSIZE)
        {
            if (va_mapped(parent->pgd, va))
            {
                uint64_t *pg = (uint64_t *)kalloc();
                memcpy(pg, va, PGSIZE);
                
                uint64_t perm = vmflags2pte(p_vma->vm_flags) | PTE_V | PTE_U;
                create_mapping(child->pgd, va, VA2PA(pg), PGSIZE, perm);
            }
        }

        p_vma = p_vma->vm_next;
    }
}
