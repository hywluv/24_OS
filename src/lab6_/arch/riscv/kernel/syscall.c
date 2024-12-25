#include "syscall.h"
#include "fs.h"
#include "string.h"
#include "vm.h"
#include "stdlib.h"
#include "fat32.h"

extern struct task_struct *get_current_proc();
extern int putc(int c);
extern void __ret_from_fork();

// int sys_write(unsigned int fd, const char *buf, unsigned int size)
// {
//     int cnt = 0;
//     if (fd == STDOUT)
//     {
//         for (cnt = 0; cnt < size && buf[cnt]; ++cnt)
//             putc(buf[cnt]);
//         return cnt;
//     }
//     return -1;
// }

int64_t sys_write(uint64_t fd, const char *buf, uint64_t len) {
    int64_t ret;
    struct task_struct *current = get_current_proc();
    struct file *file = &(current->files->fd_array[fd]);
    if (file->opened == 0) {
        printk("file not opened\n");
        return ERROR_FILE_NOT_OPEN;
    } else {
        // check perms and call write function of file
        if((file->perms & FILE_WRITABLE)==0){
            Err("file not writable");
            return ERROR_FILE_NOT_WRITABLE;
        }
        // 检查写函数是否定义
        if(file->write==NULL){
            Err("file not support write function");
            return ERROR_NO_WRITE_FUNCTION;
        }
        // 允许写入
        ret = file->write(file, buf, len);
        if(ret<0){
            Err("file write error\n");
        }
    }
    return ret;
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
    struct vm_area_struct *c_vma = NULL;

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

int find_free_fd(struct files_struct *files) {
    for (int i = 0; i < MAX_FILE_NUMBER; i++) {
        if (files->fd_array[i].opened == 0) {
            return i;
        }
    }
    return -1;
}

uint64_t strncmp(const char *s1, const char *s2, int n) {
    while (n > 0) {
        if (*s1 != *s2) {
            return *s1 - *s2;
        }
        if (*s1 == '\0') {
            return 0;
        }
        s1++;
        s2++;
        n--;
    }
    return 0;
}

int64_t strncpy(char *dest, const char *src, int n) {
    int i = 0;
    while (i < n && src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0';
    return i;
}

int64_t sys_openat(int dfd, const char *path, int flags) {
    // Log("sys_openat: path = %s, flags = %d", path, flags);
    struct task_struct *current_task = get_current_proc();
    struct files_struct *files = current_task->files;
    int fd = find_free_fd(files);

    if (fd == -1) {
        Err("No available file descriptor");
        return -1;
    }

    int32_t ret = file_open(&files->fd_array[fd], path, flags);
    if (ret < 0) {
        Err("file open error");
    }
    Log("sys_openat: fd = %d, path = %s", fd, path);
    return fd;
}

int64_t sys_close(int64_t fd) {
    struct task_struct *current_task = get_current_proc();
    struct files_struct *files = current_task->files;
    if (fd < 0 || fd >= MAX_FILE_NUMBER) {
        Err("Invalid file descriptor");
    }
    struct file *file = &files->fd_array[fd];
    if (!file || file->opened == 0) {
        Err("File not opened");
    }
    file->opened = 0;
    return 0;
}

int64_t sys_lseek(uint64_t fd, int64_t offset, uint64_t whence) {
    struct task_struct *current = get_current_proc();
    struct file *file = &(current->files->fd_array[fd]);

    if (file->opened == 0) {
        printk("file not opened\n");
        return ERROR_FILE_NOT_OPEN;
    }

    if (file->lseek == NULL) {
        Err("file not support lseek function");
    }

    int64_t ret = file->lseek(file, offset, whence);

    if (ret < 0) {
        Err("file lseek error");
    }

    return ret;
}

int64_t sys_read(uint64_t fd, void *buf, uint64_t len) {
    struct task_struct *current = get_current_proc();
    struct file *file = &(current->files->fd_array[fd]);

    if (file->opened == 0) {
        printk("file not opened\n");
        return ERROR_FILE_NOT_OPEN;
    }

    if (file->read == NULL) {
        Err("file not support read function");
    }

    int64_t ret = file->read(file, buf, len);

    if (ret < 0) {
        Err("file read error");
    }

    return ret;
}