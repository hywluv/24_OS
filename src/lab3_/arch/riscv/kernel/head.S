    .extern start_kernel
    .extern mm_init
    .extern task_init
    .extern setup_vm_final
    .extern vm_init
    .section .text.init
    .globl _start
_start:
    #implement
    la sp, boot_stack_top # initialize stack

    call setup_vm
    call relocate
    call mm_init
    call setup_vm_final
    call task_init

    la t0, _traps # load traps
    csrw stvec, t0 # set traps

    li t0, (1 << 5) # enable interrupts
    csrs sie, t0

    li t1, 10000000
    rdtime t0
    add t0, t0, t1
    mv a0, t0 # set time to 1s
    li a7, 0 # set eid to 0
    ecall # call sbi_set_timer

    li t0, (1 << 1)
    csrs sstatus, t0 # enable global interrupt

    call start_kernel # jump to start_kernel

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    li t2, 0xffffffe000000000
    li t3, 0x80000000
    sub t1, t2, t3
    add ra, ra, t1
    add sp, sp, t1

    # set stvec to va
    # la t4, 1f
    # add t4, t4, t1

    # set satp with early_pgtbl

    la t0, early_pgtbl
    srli t0, t0, 12
    li t1, (8 << 60)
    or t0, t0, t1
    # csrw stvec, t4
    csrw satp, t0

# 1:
    # flush tlb
    sfence.vma zero, zero

    # flush icache
    fence.i

    ret

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096
    .globl boot_stack_top
boot_stack_top = boot_stack + 4096