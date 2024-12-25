.extern trap_handler
.section .text.entry
.align 2
.globl _traps 
_traps:
    # implement

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    # bne sp, zero, 1f

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    csrrw sp, sscratch, sp
    bne sp, zero, 1f
    csrrw sp, sscratch, sp

    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap
1:
    addi sp, sp, -33*8
    sd ra, 0*8(sp)
    sd t0, 1*8(sp)
    sd t1, 2*8(sp)
    sd t2, 3*8(sp)
    sd t3, 4*8(sp)
    sd t4, 5*8(sp)
    sd t5, 6*8(sp)
    sd t6, 7*8(sp)
    sd a0, 8*8(sp)
    sd a1, 9*8(sp)
    sd a2, 10*8(sp)
    sd a3, 11*8(sp)
    sd a4, 12*8(sp)
    sd a5, 13*8(sp)
    sd a6, 14*8(sp)
    sd a7, 15*8(sp)
    sd s0, 16*8(sp)
    sd s1, 17*8(sp)
    sd s2, 18*8(sp)
    sd s3, 19*8(sp)
    sd s4, 20*8(sp)
    sd s5, 21*8(sp)
    sd s6, 22*8(sp)
    sd s7, 23*8(sp)
    sd s8, 24*8(sp)
    sd s9, 25*8(sp)
    sd s10, 26*8(sp)
    sd s11, 27*8(sp)
    sd gp, 28*8(sp)
    sd tp, 29*8(sp)
    csrr t0, sepc
    sd t0, 30*8(sp)
    csrr t0, sstatus
    sd t0, 31*8(sp)
    sd sp, 32*8(sp)

    csrr a0, scause
    csrr a1, sepc
    mv a2, sp
    call trap_handler

    .globl __ret_from_fork
__ret_from_fork:

    ld sp, 32*8(sp)
    ld t0, 31*8(sp)
    csrw sstatus, t0
    ld t0, 30*8(sp)
    csrw sepc, t0
    ld ra, 0*8(sp)
    ld t0, 1*8(sp)
    ld t1, 2*8(sp)
    ld t2, 3*8(sp)
    ld t3, 4*8(sp)
    ld t4, 5*8(sp)
    ld t5, 6*8(sp)
    ld t6, 7*8(sp)
    ld a0, 8*8(sp)
    ld a1, 9*8(sp)
    ld a2, 10*8(sp)
    ld a3, 11*8(sp)
    ld a4, 12*8(sp)
    ld a5, 13*8(sp)
    ld a6, 14*8(sp)
    ld a7, 15*8(sp)
    ld s0, 16*8(sp)
    ld s1, 17*8(sp)
    ld s2, 18*8(sp)
    ld s3, 19*8(sp)
    ld s4, 20*8(sp)
    ld s5, 21*8(sp)
    ld s6, 22*8(sp)
    ld s7, 23*8(sp)
    ld s8, 24*8(sp)
    ld s9, 25*8(sp)
    ld s10, 26*8(sp)
    ld s11, 27*8(sp)
    ld gp, 28*8(sp)
    ld tp, 29*8(sp)
    addi sp, sp, 33*8

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    # bne sp, zero, 1f

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    csrrw sp, sscratch, sp     # 交换 sp 和 sscratch
    bne sp, zero, 1f           # 如果 sp 不为零，跳转到标签 1f
    csrrw sp, sscratch, sp     # 再次交换 sp 和 sscratch

1:
    sret

    .globl __dummy
__dummy:
    add t0, sp, zero
    csrr sp, sscratch
    csrw sscratch, t0
    sret

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
    sd sp, 8(a0)
    sd s0, 16(a0)
    sd s1, 24(a0)
    sd s2, 32(a0)
    sd s3, 40(a0)
    sd s4, 48(a0)
    sd s5, 56(a0)
    sd s6, 64(a0)
    sd s7, 72(a0)
    sd s8, 80(a0)
    sd s9, 88(a0)
    sd s10, 96(a0)
    sd s11, 104(a0)

    csrr t0, sepc
    sd t0, 112(a0)

    csrr t0, sstatus
    sd t0, 120(a0)

    csrr t0, sscratch
    sd t0, 128(a0)

    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
    ld sp, 8(a1)
    ld s0, 16(a1)
    ld s1, 24(a1)
    ld s2, 32(a1)
    ld s3, 40(a1)
    ld s4, 48(a1)
    ld s5, 56(a1)
    ld s6, 64(a1)
    ld s7, 72(a1)
    ld s8, 80(a1)
    ld s9, 88(a1)
    ld s10, 96(a1)
    ld s11, 104(a1)

    ld t0, 112(a1)
    csrw sepc, t0

    ld t0, 120(a1)
    csrw sstatus, t0

    ld t0, 128(a1)
    csrw sscratch, t0

    csrw satp, a2

    sfence.vma zero, zero
    fence.i

    ret