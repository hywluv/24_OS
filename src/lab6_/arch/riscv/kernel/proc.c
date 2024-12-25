#include "mm.h"
#include "vm.h"
#include "defs.h"
#include "proc.h"
#include "stdlib.h"
#include "printk.h"
#include "elf.h"
#include "fs.h"

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此
int nr_tasks = 0;                   // 当前线程数

extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];

int get_nr_tasks()
{
    return nr_tasks;
}

struct task_struct *get_current_proc()
{
    return current;
}

void set_user_pgtbl(struct task_struct *T)
{
    T->pgd = (uint64_t *)alloc_page();
    memset(T->pgd, 0, PGSIZE);
    memcpy(T->pgd, get_kernel_pgtbl(), PGSIZE);

    printk("set_user_pgtbl: T->pgd = %p\n", T->pgd);

    // uint64_t user_perm = PTE_V | PTE_R | PTE_W | PTE_U;
    // uint64_t pa = VA2PA(alloc_page());
    // uint64_t va = USER_END - PGSIZE;
    // printk("set_user_pgtbl: va = %lx, pa = %lx\n", va, pa);
    // create_mapping(T->pgd, va, pa, PGSIZE, user_perm);

    // vma
    do_mmap(&(T->mm), USER_END - PGSIZE, PGSIZE, 0, 0, VM_ANON | VM_READ | VM_WRITE);
    printk("set_user_pgtbl done\n");
}

void load_program(struct task_struct *task)
{
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
    for (int i = 0; i < ehdr->e_phnum; ++i)
    {
        Elf64_Phdr *phdr = phdrs + i;
        if (phdr->p_type == PT_LOAD)
        {
            // alloc space and copy content
            uint64_t align_offset = phdr->p_vaddr % PGSIZE;
            uint64_t num_pg = (phdr->p_memsz + align_offset + PGSIZE - 1) / PGSIZE;
            // uint64_t *new_pgs = (uint64_t *)alloc_pages(num_pg);
            // memcpy((void *)((uint64_t)new_pgs + align_offset), _sramdisk + phdr->p_offset, phdr->p_filesz);
            // memset((void *)((uint64_t)new_pgs + align_offset + phdr->p_filesz), 0x0, phdr->p_memsz - phdr->p_filesz);
            // do mapping
            // create_mapping(task->pgd, phdr->p_vaddr - align_offset, VA2PA((uint64_t)new_pgs), phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
            // printk("[load_program] va = %lx, pa = %lx, sz = %lx, perm = %lx\//n", phdr->p_vaddr - align_offset, (uint64_t)new_pgs - PA2VA_OFFSET, phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
            // vma
            do_mmap(&(task->mm), phdr->p_vaddr, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, VM_READ | VM_WRITE | VM_EXEC);
            // code...
        }
    }
    task->thread.sepc = ehdr->e_entry;
}

void task_init()
{
    srand(2024);

    // 1. 调用 kalloc() 为 idle 分配一个物理页
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
    idle->state = TASK_RUNNING;
    idle->counter = 0;
    idle->priority = 0;
    idle->pid = 0;
    current = idle;
    task[0] = idle;

    // 1. 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    // 2. 其中每个线程的 state 为 TASK_RUNNING, 此外，counter 和 priority 进行如下赋值：
    //     - counter  = 0;
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for (int i = 1; i < NR_TASKS; i++)
    {
        task[i] = (struct task_struct *)kalloc();
        task[i]->state = TASK_RUNNING;
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
        task[i]->counter = 0;
        task[i]->pid = i;
        task[i]->thread.ra = (uint64_t)__dummy;
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
        set_user_pgtbl(task[i]);
        // uint64_t uapp_pages = (PGROUNDUP(_eramdisk - _sramdisk)) / PGSIZE;
        // uint64_t *uapp_mem = (uint64_t *)alloc_pages(uapp_pages);
        // memcpy(uapp_mem, _sramdisk, uapp_pages * PGSIZE);
        // create_mapping(task[i]->pgd, USER_START, VA2PA((uint64_t)uapp_mem), uapp_pages * PGSIZE, PTE_V | PTE_R | PTE_W | PTE_X | PTE_U);
        load_program(task[i]);
        // task[i]->thread.sepc = USER_START;
        // uint64_t sstatus = SSTATUS_SPIE | SSTATUS_SPP;
        // sstatus &= ~SSTATUS_SPP;
        // task[i]->thread.sstatus = sstatus;
        // task[i]->thread.sscratch = USER_END;
        task[i]->thread.sstatus = 0;
        task[i]->thread.sstatus &= ~SSTATUS_SPP;
        task[i]->thread.sstatus |= SSTATUS_SPIE | SSTATUS_SUM;
        task[i]->thread.sscratch = USER_END;
        task[i]->files = file_init();
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
    }

    printk("...task_init done!\n");
}

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next, uint64_t satp);

void switch_to(struct task_struct *next)
{
    if (current != next)
    {
        struct task_struct *prev = current;
        current = next;
        printk("from [%d] switch to [%d]\n", prev->pid, next->pid);
        uint64_t next_satp = get_satp(next->pgd);
        __switch_to(&(prev->thread), &(next->thread), next_satp);
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}

void do_timer()
{
    if (current->pid == 0 || current->counter == 0)
    {
        schedule();
    }
    else
    {
        --(current->counter);
        if (current->counter > 0)
        {
            return;
        }
        schedule();
    }
}

void schedule()
{
    struct task_struct *next = NULL;
    int max_counter = 0;

    for (int i = 1; i < NR_TASKS; i++)
    {
        if (task[i] && task[i]->state == TASK_RUNNING)
        {
            if (task[i]->counter > max_counter)
            {
                max_counter = task[i]->counter;
                next = task[i];
            }
        }
    }

    if (max_counter == 0)
    {
        for (int i = 0; i < NR_TASKS; i++)
        {
            if (task[i] && task[i]->state == TASK_RUNNING)
            {
                task[i]->counter = task[i]->priority;
            }
        }
        schedule();
        return;
    }

    if (next && next != current)
    {
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
    }
}

/*
* @mm       : current thread's mm_struct
* @addr     : the va to look up
*
* @return   : the VMA if found or NULL if not found
*/
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
    struct vm_area_struct *vma = mm->mmap;
    while(vma){
        if(addr >= vma->vm_start && addr < vma->vm_end){
            return vma;
        }
        vma = vma->vm_next;
    }
    return NULL;
}

/*
* @mm       : current thread's mm_struct
* @addr     : the va to map
* @len      : memory size to map
* @vm_pgoff : phdr->p_offset
* @vm_filesz: phdr->p_filesz
* @flags    : flags for the new VMA
*
* @return   : start va
*/
uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
    uint64_t start = addr;
    uint64_t end = addr + len;
    struct vm_area_struct *vma = mm->mmap;
    struct vm_area_struct *prev = NULL;
    while(vma){
        if(end <= vma->vm_start){
            break;
        }
        prev = vma;
        vma = vma->vm_next;
    }
    struct vm_area_struct *new_vma = (struct vm_area_struct *)kalloc();
    new_vma->vm_mm = mm;
    new_vma->vm_start = start;
    new_vma->vm_end = end;
    new_vma->vm_flags = flags;
    new_vma->vm_pgoff = vm_pgoff;
    new_vma->vm_filesz = vm_filesz;
    if(prev){
        prev->vm_next = new_vma;
        new_vma->vm_prev = prev;
    }else{
        mm->mmap = new_vma;
    }
    new_vma->vm_next = vma;
    if(vma){
        vma->vm_prev = new_vma;
    }
    return start;
}

int add_task(struct task_struct *T)
{
    if (nr_tasks >= NR_TASKS)
    {
        return -1;
    }
    task[nr_tasks++] = T;
    return nr_tasks - 1;
}


#if TEST_SCHED
#define MAX_OUTPUT ((NR_TASKS - 1) * 10)
char tasks_output[MAX_OUTPUT];
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy()
{
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
        {
            if (current->counter == 1)
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
#if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT)
            {
                for (int i = 0; i < MAX_OUTPUT; ++i)
                {
                    if (tasks_output[i] != expected_output[i])
                    {
                        printk("\033[31mTest failed!\033[0m\n");
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
            }
#endif
        }
    }
}
