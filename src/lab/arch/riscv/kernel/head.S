    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    #implement
    la sp, boot_stack_top # initialize stack

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
    j _start # loop

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096
    .globl boot_stack_top
boot_stack_top = boot_stack + 4096