
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern vm_init
    .section .text.init
    .globl _start
_start:
    #implement
    la sp, boot_stack_top # initialize stack
ffffffe000200000:	00009117          	auipc	sp,0x9
ffffffe000200004:	00010113          	mv	sp,sp

    call setup_vm
ffffffe000200008:	155010ef          	jal	ra,ffffffe00020195c <setup_vm>
    call relocate
ffffffe00020000c:	044000ef          	jal	ra,ffffffe000200050 <relocate>
    call mm_init
ffffffe000200010:	2b5000ef          	jal	ra,ffffffe000200ac4 <mm_init>
    call setup_vm_final
ffffffe000200014:	311010ef          	jal	ra,ffffffe000201b24 <setup_vm_final>
    call task_init
ffffffe000200018:	639000ef          	jal	ra,ffffffe000200e50 <task_init>

    la t0, _traps # load traps
ffffffe00020001c:	00000297          	auipc	t0,0x0
ffffffe000200020:	07828293          	addi	t0,t0,120 # ffffffe000200094 <_traps>
    csrw stvec, t0 # set traps
ffffffe000200024:	10529073          	csrw	stvec,t0

    li t0, (1 << 5) # enable interrupts
ffffffe000200028:	02000293          	li	t0,32
    csrs sie, t0
ffffffe00020002c:	1042a073          	csrs	sie,t0

    li t1, 10000000
ffffffe000200030:	00989337          	lui	t1,0x989
ffffffe000200034:	6803031b          	addiw	t1,t1,1664 # 989680 <OPENSBI_SIZE+0x789680>
    rdtime t0
ffffffe000200038:	c01022f3          	rdtime	t0
    add t0, t0, t1
ffffffe00020003c:	006282b3          	add	t0,t0,t1
    mv a0, t0 # set time to 1s
ffffffe000200040:	00028513          	mv	a0,t0
    li a7, 0 # set eid to 0
ffffffe000200044:	00000893          	li	a7,0
    ecall # call sbi_set_timer
ffffffe000200048:	00000073          	ecall

    # sstatus[PIE]
    # li t0, (1 << 1)
    # csrs sstatus, t0 # enable global interrupt

    call start_kernel # jump to start_kernel
ffffffe00020004c:	725010ef          	jal	ra,ffffffe000201f70 <start_kernel>

ffffffe000200050 <relocate>:

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    li t2, 0xffffffe000000000
ffffffe000200050:	fff0039b          	addiw	t2,zero,-1
ffffffe000200054:	02539393          	slli	t2,t2,0x25
    li t3, 0x80000000
ffffffe000200058:	00100e1b          	addiw	t3,zero,1
ffffffe00020005c:	01fe1e13          	slli	t3,t3,0x1f
    sub t1, t2, t3
ffffffe000200060:	41c38333          	sub	t1,t2,t3
    add ra, ra, t1
ffffffe000200064:	006080b3          	add	ra,ra,t1
    add sp, sp, t1
ffffffe000200068:	00610133          	add	sp,sp,t1
    # la t4, 1f
    # add t4, t4, t1

    # set satp with early_pgtbl

    la t0, early_pgtbl
ffffffe00020006c:	0000a297          	auipc	t0,0xa
ffffffe000200070:	f9428293          	addi	t0,t0,-108 # ffffffe00020a000 <early_pgtbl>
    srli t0, t0, 12
ffffffe000200074:	00c2d293          	srli	t0,t0,0xc
    li t1, (8 << 60)
ffffffe000200078:	fff0031b          	addiw	t1,zero,-1
ffffffe00020007c:	03f31313          	slli	t1,t1,0x3f
    or t0, t0, t1
ffffffe000200080:	0062e2b3          	or	t0,t0,t1
    # csrw stvec, t4
    csrw satp, t0
ffffffe000200084:	18029073          	csrw	satp,t0

# 1:
    # flush tlb
    sfence.vma zero, zero
ffffffe000200088:	12000073          	sfence.vma

    # flush icache
    fence.i
ffffffe00020008c:	0000100f          	fence.i

    ret
ffffffe000200090:	00008067          	ret

ffffffe000200094 <_traps>:
.align 2
.globl _traps 
_traps:
    # implement

    csrr t0, sscratch
ffffffe000200094:	140022f3          	csrr	t0,sscratch
    csrw sscratch, sp
ffffffe000200098:	14011073          	csrw	sscratch,sp
    mv sp, t0
ffffffe00020009c:	00028113          	mv	sp,t0

    bne sp, zero, 1f
ffffffe0002000a0:	00011863          	bnez	sp,ffffffe0002000b0 <_traps+0x1c>

    csrr t0, sscratch
ffffffe0002000a4:	140022f3          	csrr	t0,sscratch
    csrw sscratch, sp
ffffffe0002000a8:	14011073          	csrw	sscratch,sp
    mv sp, t0
ffffffe0002000ac:	00028113          	mv	sp,t0
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap
1:
    addi sp, sp, -33*8
ffffffe0002000b0:	ef810113          	addi	sp,sp,-264 # ffffffe000208ef8 <_sbss+0xef8>
    sd ra, 0*8(sp)
ffffffe0002000b4:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
ffffffe0002000b8:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
ffffffe0002000bc:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
ffffffe0002000c0:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
ffffffe0002000c4:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
ffffffe0002000c8:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
ffffffe0002000cc:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
ffffffe0002000d0:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
ffffffe0002000d4:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
ffffffe0002000d8:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
ffffffe0002000dc:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
ffffffe0002000e0:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
ffffffe0002000e4:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
ffffffe0002000e8:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
ffffffe0002000ec:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
ffffffe0002000f0:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
ffffffe0002000f4:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
ffffffe0002000f8:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
ffffffe0002000fc:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
ffffffe000200100:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
ffffffe000200104:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
ffffffe000200108:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
ffffffe00020010c:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
ffffffe000200110:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
ffffffe000200114:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
ffffffe000200118:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
ffffffe00020011c:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
ffffffe000200120:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
ffffffe000200124:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
ffffffe000200128:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
ffffffe00020012c:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
ffffffe000200130:	0e513823          	sd	t0,240(sp)
    csrr t0, sstatus
ffffffe000200134:	100022f3          	csrr	t0,sstatus
    sd t0, 31*8(sp)
ffffffe000200138:	0e513c23          	sd	t0,248(sp)
    sd sp, 32*8(sp)
ffffffe00020013c:	10213023          	sd	sp,256(sp)

    csrr a0, scause
ffffffe000200140:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe000200144:	141025f3          	csrr	a1,sepc
    mv a2, sp
ffffffe000200148:	00010613          	mv	a2,sp
    call trap_handler
ffffffe00020014c:	6c4010ef          	jal	ra,ffffffe000201810 <trap_handler>

    ld sp, 32*8(sp)
ffffffe000200150:	10013103          	ld	sp,256(sp)
    ld t0, 31*8(sp)
ffffffe000200154:	0f813283          	ld	t0,248(sp)
    csrw sstatus, t0
ffffffe000200158:	10029073          	csrw	sstatus,t0
    ld t0, 30*8(sp)
ffffffe00020015c:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
ffffffe000200160:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
ffffffe000200164:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
ffffffe000200168:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
ffffffe00020016c:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
ffffffe000200170:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
ffffffe000200174:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
ffffffe000200178:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
ffffffe00020017c:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
ffffffe000200180:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
ffffffe000200184:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
ffffffe000200188:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
ffffffe00020018c:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
ffffffe000200190:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
ffffffe000200194:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
ffffffe000200198:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
ffffffe00020019c:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
ffffffe0002001a0:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
ffffffe0002001a4:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
ffffffe0002001a8:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
ffffffe0002001ac:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
ffffffe0002001b0:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
ffffffe0002001b4:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
ffffffe0002001b8:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
ffffffe0002001bc:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
ffffffe0002001c0:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
ffffffe0002001c4:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
ffffffe0002001c8:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
ffffffe0002001cc:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
ffffffe0002001d0:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
ffffffe0002001d4:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
ffffffe0002001d8:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
ffffffe0002001dc:	10810113          	addi	sp,sp,264

    csrr t0, sscratch
ffffffe0002001e0:	140022f3          	csrr	t0,sscratch
    csrw sscratch, sp
ffffffe0002001e4:	14011073          	csrw	sscratch,sp
    mv sp, t0
ffffffe0002001e8:	00028113          	mv	sp,t0

    bne sp, zero, 1f
ffffffe0002001ec:	00011863          	bnez	sp,ffffffe0002001fc <_traps+0x168>

    csrr t0, sscratch
ffffffe0002001f0:	140022f3          	csrr	t0,sscratch
    csrw sscratch, sp
ffffffe0002001f4:	14011073          	csrw	sscratch,sp
    mv sp, t0
ffffffe0002001f8:	00028113          	mv	sp,t0

1:
    sret
ffffffe0002001fc:	10200073          	sret

ffffffe000200200 <__dummy>:

    .globl __dummy
__dummy:
    add t0, sp, zero
ffffffe000200200:	000102b3          	add	t0,sp,zero
    csrr sp, sscratch
ffffffe000200204:	14002173          	csrr	sp,sscratch
    csrw sscratch, t0
ffffffe000200208:	14029073          	csrw	sscratch,t0
    sret
ffffffe00020020c:	10200073          	sret

ffffffe000200210 <__switch_to>:

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
ffffffe000200210:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
ffffffe000200214:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
ffffffe000200218:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
ffffffe00020021c:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
ffffffe000200220:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
ffffffe000200224:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
ffffffe000200228:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
ffffffe00020022c:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
ffffffe000200230:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
ffffffe000200234:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
ffffffe000200238:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
ffffffe00020023c:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
ffffffe000200240:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
ffffffe000200244:	07b53423          	sd	s11,104(a0)

    csrr t0, sepc
ffffffe000200248:	141022f3          	csrr	t0,sepc
    sd t0, 112(a0)
ffffffe00020024c:	06553823          	sd	t0,112(a0)

    csrr t0, sstatus
ffffffe000200250:	100022f3          	csrr	t0,sstatus
    sd t0, 120(a0)
ffffffe000200254:	06553c23          	sd	t0,120(a0)

    csrr t0, sscratch
ffffffe000200258:	140022f3          	csrr	t0,sscratch
    sd t0, 128(a0)
ffffffe00020025c:	08553023          	sd	t0,128(a0)

    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
ffffffe000200260:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
ffffffe000200264:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
ffffffe000200268:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
ffffffe00020026c:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
ffffffe000200270:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
ffffffe000200274:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
ffffffe000200278:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
ffffffe00020027c:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
ffffffe000200280:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
ffffffe000200284:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
ffffffe000200288:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
ffffffe00020028c:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
ffffffe000200290:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
ffffffe000200294:	0685bd83          	ld	s11,104(a1)

    ld t0, 112(a1)
ffffffe000200298:	0705b283          	ld	t0,112(a1)
    csrw sepc, t0
ffffffe00020029c:	14129073          	csrw	sepc,t0

    ld t0, 120(a1)
ffffffe0002002a0:	0785b283          	ld	t0,120(a1)
    csrw sstatus, t0
ffffffe0002002a4:	10029073          	csrw	sstatus,t0

    ld t0, 128(a1)
ffffffe0002002a8:	0805b283          	ld	t0,128(a1)
    csrw sscratch, t0
ffffffe0002002ac:	14029073          	csrw	sscratch,t0

    csrw satp, a2
ffffffe0002002b0:	18061073          	csrw	satp,a2

    sfence.vma zero, zero
ffffffe0002002b4:	12000073          	sfence.vma
    fence.i
ffffffe0002002b8:	0000100f          	fence.i

ffffffe0002002bc:	00008067          	ret

ffffffe0002002c0 <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe0002002c0:	fe010113          	addi	sp,sp,-32
ffffffe0002002c4:	00813c23          	sd	s0,24(sp)
ffffffe0002002c8:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe0002002cc:	c01027f3          	rdtime	a5
ffffffe0002002d0:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe0002002d4:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002d8:	00078513          	mv	a0,a5
ffffffe0002002dc:	01813403          	ld	s0,24(sp)
ffffffe0002002e0:	02010113          	addi	sp,sp,32
ffffffe0002002e4:	00008067          	ret

ffffffe0002002e8 <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
ffffffe0002002e8:	fe010113          	addi	sp,sp,-32
ffffffe0002002ec:	00813c23          	sd	s0,24(sp)
ffffffe0002002f0:	02010413          	addi	s0,sp,32
ffffffe0002002f4:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
ffffffe0002002f8:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
ffffffe0002002fc:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
ffffffe000200300:	00000073          	ecall
}
ffffffe000200304:	00000013          	nop
ffffffe000200308:	01813403          	ld	s0,24(sp)
ffffffe00020030c:	02010113          	addi	sp,sp,32
ffffffe000200310:	00008067          	ret

ffffffe000200314 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe000200314:	fe010113          	addi	sp,sp,-32
ffffffe000200318:	00113c23          	sd	ra,24(sp)
ffffffe00020031c:	00813823          	sd	s0,16(sp)
ffffffe000200320:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe000200324:	f9dff0ef          	jal	ra,ffffffe0002002c0 <get_cycles>
ffffffe000200328:	00050713          	mv	a4,a0
ffffffe00020032c:	00005797          	auipc	a5,0x5
ffffffe000200330:	cd478793          	addi	a5,a5,-812 # ffffffe000205000 <TIMECLOCK>
ffffffe000200334:	0007b783          	ld	a5,0(a5)
ffffffe000200338:	00f707b3          	add	a5,a4,a5
ffffffe00020033c:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe000200340:	fe843503          	ld	a0,-24(s0)
ffffffe000200344:	fa5ff0ef          	jal	ra,ffffffe0002002e8 <sbi_set_timer>
ffffffe000200348:	00000013          	nop
ffffffe00020034c:	01813083          	ld	ra,24(sp)
ffffffe000200350:	01013403          	ld	s0,16(sp)
ffffffe000200354:	02010113          	addi	sp,sp,32
ffffffe000200358:	00008067          	ret

ffffffe00020035c <fixsize>:
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size) {
ffffffe00020035c:	fe010113          	addi	sp,sp,-32
ffffffe000200360:	00813c23          	sd	s0,24(sp)
ffffffe000200364:	02010413          	addi	s0,sp,32
ffffffe000200368:	fea43423          	sd	a0,-24(s0)
    size --;
ffffffe00020036c:	fe843783          	ld	a5,-24(s0)
ffffffe000200370:	fff78793          	addi	a5,a5,-1
ffffffe000200374:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe000200378:	fe843783          	ld	a5,-24(s0)
ffffffe00020037c:	0017d793          	srli	a5,a5,0x1
ffffffe000200380:	fe843703          	ld	a4,-24(s0)
ffffffe000200384:	00f767b3          	or	a5,a4,a5
ffffffe000200388:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe00020038c:	fe843783          	ld	a5,-24(s0)
ffffffe000200390:	0027d793          	srli	a5,a5,0x2
ffffffe000200394:	fe843703          	ld	a4,-24(s0)
ffffffe000200398:	00f767b3          	or	a5,a4,a5
ffffffe00020039c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe0002003a0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003a4:	0047d793          	srli	a5,a5,0x4
ffffffe0002003a8:	fe843703          	ld	a4,-24(s0)
ffffffe0002003ac:	00f767b3          	or	a5,a4,a5
ffffffe0002003b0:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe0002003b4:	fe843783          	ld	a5,-24(s0)
ffffffe0002003b8:	0087d793          	srli	a5,a5,0x8
ffffffe0002003bc:	fe843703          	ld	a4,-24(s0)
ffffffe0002003c0:	00f767b3          	or	a5,a4,a5
ffffffe0002003c4:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe0002003c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002003cc:	0107d793          	srli	a5,a5,0x10
ffffffe0002003d0:	fe843703          	ld	a4,-24(s0)
ffffffe0002003d4:	00f767b3          	or	a5,a4,a5
ffffffe0002003d8:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe0002003dc:	fe843783          	ld	a5,-24(s0)
ffffffe0002003e0:	0207d793          	srli	a5,a5,0x20
ffffffe0002003e4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003e8:	00f767b3          	or	a5,a4,a5
ffffffe0002003ec:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe0002003f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003f4:	00178793          	addi	a5,a5,1
}
ffffffe0002003f8:	00078513          	mv	a0,a5
ffffffe0002003fc:	01813403          	ld	s0,24(sp)
ffffffe000200400:	02010113          	addi	sp,sp,32
ffffffe000200404:	00008067          	ret

ffffffe000200408 <buddy_init>:

void buddy_init() {
ffffffe000200408:	fd010113          	addi	sp,sp,-48
ffffffe00020040c:	02113423          	sd	ra,40(sp)
ffffffe000200410:	02813023          	sd	s0,32(sp)
ffffffe000200414:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe000200418:	000087b7          	lui	a5,0x8
ffffffe00020041c:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe000200420:	fe843783          	ld	a5,-24(s0)
ffffffe000200424:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe000200428:	fe843783          	ld	a5,-24(s0)
ffffffe00020042c:	00f777b3          	and	a5,a4,a5
ffffffe000200430:	00078863          	beqz	a5,ffffffe000200440 <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe000200434:	fe843503          	ld	a0,-24(s0)
ffffffe000200438:	f25ff0ef          	jal	ra,ffffffe00020035c <fixsize>
ffffffe00020043c:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe000200440:	00009797          	auipc	a5,0x9
ffffffe000200444:	be078793          	addi	a5,a5,-1056 # ffffffe000209020 <buddy>
ffffffe000200448:	fe843703          	ld	a4,-24(s0)
ffffffe00020044c:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe000200450:	00005797          	auipc	a5,0x5
ffffffe000200454:	bb878793          	addi	a5,a5,-1096 # ffffffe000205008 <free_page_start>
ffffffe000200458:	0007b703          	ld	a4,0(a5)
ffffffe00020045c:	00009797          	auipc	a5,0x9
ffffffe000200460:	bc478793          	addi	a5,a5,-1084 # ffffffe000209020 <buddy>
ffffffe000200464:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200468:	00005797          	auipc	a5,0x5
ffffffe00020046c:	ba078793          	addi	a5,a5,-1120 # ffffffe000205008 <free_page_start>
ffffffe000200470:	0007b703          	ld	a4,0(a5)
ffffffe000200474:	00009797          	auipc	a5,0x9
ffffffe000200478:	bac78793          	addi	a5,a5,-1108 # ffffffe000209020 <buddy>
ffffffe00020047c:	0007b783          	ld	a5,0(a5)
ffffffe000200480:	00479793          	slli	a5,a5,0x4
ffffffe000200484:	00f70733          	add	a4,a4,a5
ffffffe000200488:	00005797          	auipc	a5,0x5
ffffffe00020048c:	b8078793          	addi	a5,a5,-1152 # ffffffe000205008 <free_page_start>
ffffffe000200490:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe000200494:	00009797          	auipc	a5,0x9
ffffffe000200498:	b8c78793          	addi	a5,a5,-1140 # ffffffe000209020 <buddy>
ffffffe00020049c:	0087b703          	ld	a4,8(a5)
ffffffe0002004a0:	00009797          	auipc	a5,0x9
ffffffe0002004a4:	b8078793          	addi	a5,a5,-1152 # ffffffe000209020 <buddy>
ffffffe0002004a8:	0007b783          	ld	a5,0(a5)
ffffffe0002004ac:	00479793          	slli	a5,a5,0x4
ffffffe0002004b0:	00078613          	mv	a2,a5
ffffffe0002004b4:	00000593          	li	a1,0
ffffffe0002004b8:	00070513          	mv	a0,a4
ffffffe0002004bc:	585020ef          	jal	ra,ffffffe000203240 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe0002004c0:	00009797          	auipc	a5,0x9
ffffffe0002004c4:	b6078793          	addi	a5,a5,-1184 # ffffffe000209020 <buddy>
ffffffe0002004c8:	0007b783          	ld	a5,0(a5)
ffffffe0002004cc:	00179793          	slli	a5,a5,0x1
ffffffe0002004d0:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004d4:	fc043c23          	sd	zero,-40(s0)
ffffffe0002004d8:	0500006f          	j	ffffffe000200528 <buddy_init+0x120>
        if (IS_POWER_OF_2(i + 1))
ffffffe0002004dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002004e0:	00178713          	addi	a4,a5,1
ffffffe0002004e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002004e8:	00f777b3          	and	a5,a4,a5
ffffffe0002004ec:	00079863          	bnez	a5,ffffffe0002004fc <buddy_init+0xf4>
            node_size /= 2;
ffffffe0002004f0:	fe043783          	ld	a5,-32(s0)
ffffffe0002004f4:	0017d793          	srli	a5,a5,0x1
ffffffe0002004f8:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe0002004fc:	00009797          	auipc	a5,0x9
ffffffe000200500:	b2478793          	addi	a5,a5,-1244 # ffffffe000209020 <buddy>
ffffffe000200504:	0087b703          	ld	a4,8(a5)
ffffffe000200508:	fd843783          	ld	a5,-40(s0)
ffffffe00020050c:	00379793          	slli	a5,a5,0x3
ffffffe000200510:	00f707b3          	add	a5,a4,a5
ffffffe000200514:	fe043703          	ld	a4,-32(s0)
ffffffe000200518:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe00020051c:	fd843783          	ld	a5,-40(s0)
ffffffe000200520:	00178793          	addi	a5,a5,1
ffffffe000200524:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200528:	00009797          	auipc	a5,0x9
ffffffe00020052c:	af878793          	addi	a5,a5,-1288 # ffffffe000209020 <buddy>
ffffffe000200530:	0007b783          	ld	a5,0(a5)
ffffffe000200534:	00179793          	slli	a5,a5,0x1
ffffffe000200538:	fff78793          	addi	a5,a5,-1
ffffffe00020053c:	fd843703          	ld	a4,-40(s0)
ffffffe000200540:	f8f76ee3          	bltu	a4,a5,ffffffe0002004dc <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200544:	fc043823          	sd	zero,-48(s0)
ffffffe000200548:	0180006f          	j	ffffffe000200560 <buddy_init+0x158>
        buddy_alloc(1);
ffffffe00020054c:	00100513          	li	a0,1
ffffffe000200550:	1fc000ef          	jal	ra,ffffffe00020074c <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200554:	fd043783          	ld	a5,-48(s0)
ffffffe000200558:	00178793          	addi	a5,a5,1
ffffffe00020055c:	fcf43823          	sd	a5,-48(s0)
ffffffe000200560:	fd043783          	ld	a5,-48(s0)
ffffffe000200564:	00c79713          	slli	a4,a5,0xc
ffffffe000200568:	00100793          	li	a5,1
ffffffe00020056c:	01f79793          	slli	a5,a5,0x1f
ffffffe000200570:	00f70733          	add	a4,a4,a5
ffffffe000200574:	00005797          	auipc	a5,0x5
ffffffe000200578:	a9478793          	addi	a5,a5,-1388 # ffffffe000205008 <free_page_start>
ffffffe00020057c:	0007b783          	ld	a5,0(a5)
ffffffe000200580:	00078693          	mv	a3,a5
ffffffe000200584:	04100793          	li	a5,65
ffffffe000200588:	01f79793          	slli	a5,a5,0x1f
ffffffe00020058c:	00f687b3          	add	a5,a3,a5
ffffffe000200590:	faf76ee3          	bltu	a4,a5,ffffffe00020054c <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe000200594:	00004517          	auipc	a0,0x4
ffffffe000200598:	a6c50513          	addi	a0,a0,-1428 # ffffffe000204000 <_srodata>
ffffffe00020059c:	385020ef          	jal	ra,ffffffe000203120 <printk>
    return;
ffffffe0002005a0:	00000013          	nop
}
ffffffe0002005a4:	02813083          	ld	ra,40(sp)
ffffffe0002005a8:	02013403          	ld	s0,32(sp)
ffffffe0002005ac:	03010113          	addi	sp,sp,48
ffffffe0002005b0:	00008067          	ret

ffffffe0002005b4 <buddy_free>:

void buddy_free(uint64_t pfn) {
ffffffe0002005b4:	fc010113          	addi	sp,sp,-64
ffffffe0002005b8:	02813c23          	sd	s0,56(sp)
ffffffe0002005bc:	04010413          	addi	s0,sp,64
ffffffe0002005c0:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe0002005c4:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe0002005c8:	00100793          	li	a5,1
ffffffe0002005cc:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe0002005d0:	00009797          	auipc	a5,0x9
ffffffe0002005d4:	a5078793          	addi	a5,a5,-1456 # ffffffe000209020 <buddy>
ffffffe0002005d8:	0007b703          	ld	a4,0(a5)
ffffffe0002005dc:	fc843783          	ld	a5,-56(s0)
ffffffe0002005e0:	00f707b3          	add	a5,a4,a5
ffffffe0002005e4:	fff78793          	addi	a5,a5,-1
ffffffe0002005e8:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005ec:	02c0006f          	j	ffffffe000200618 <buddy_free+0x64>
        node_size *= 2;
ffffffe0002005f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002005f4:	00179793          	slli	a5,a5,0x1
ffffffe0002005f8:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe0002005fc:	fe043783          	ld	a5,-32(s0)
ffffffe000200600:	02078e63          	beqz	a5,ffffffe00020063c <buddy_free+0x88>
    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe000200604:	fe043783          	ld	a5,-32(s0)
ffffffe000200608:	00178793          	addi	a5,a5,1
ffffffe00020060c:	0017d793          	srli	a5,a5,0x1
ffffffe000200610:	fff78793          	addi	a5,a5,-1
ffffffe000200614:	fef43023          	sd	a5,-32(s0)
ffffffe000200618:	00009797          	auipc	a5,0x9
ffffffe00020061c:	a0878793          	addi	a5,a5,-1528 # ffffffe000209020 <buddy>
ffffffe000200620:	0087b703          	ld	a4,8(a5)
ffffffe000200624:	fe043783          	ld	a5,-32(s0)
ffffffe000200628:	00379793          	slli	a5,a5,0x3
ffffffe00020062c:	00f707b3          	add	a5,a4,a5
ffffffe000200630:	0007b783          	ld	a5,0(a5)
ffffffe000200634:	fa079ee3          	bnez	a5,ffffffe0002005f0 <buddy_free+0x3c>
ffffffe000200638:	0080006f          	j	ffffffe000200640 <buddy_free+0x8c>
            break;
ffffffe00020063c:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe000200640:	00009797          	auipc	a5,0x9
ffffffe000200644:	9e078793          	addi	a5,a5,-1568 # ffffffe000209020 <buddy>
ffffffe000200648:	0087b703          	ld	a4,8(a5)
ffffffe00020064c:	fe043783          	ld	a5,-32(s0)
ffffffe000200650:	00379793          	slli	a5,a5,0x3
ffffffe000200654:	00f707b3          	add	a5,a4,a5
ffffffe000200658:	fe843703          	ld	a4,-24(s0)
ffffffe00020065c:	00e7b023          	sd	a4,0(a5)

    while (index) {
ffffffe000200660:	0d00006f          	j	ffffffe000200730 <buddy_free+0x17c>
        index = PARENT(index);
ffffffe000200664:	fe043783          	ld	a5,-32(s0)
ffffffe000200668:	00178793          	addi	a5,a5,1
ffffffe00020066c:	0017d793          	srli	a5,a5,0x1
ffffffe000200670:	fff78793          	addi	a5,a5,-1
ffffffe000200674:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe000200678:	fe843783          	ld	a5,-24(s0)
ffffffe00020067c:	00179793          	slli	a5,a5,0x1
ffffffe000200680:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe000200684:	00009797          	auipc	a5,0x9
ffffffe000200688:	99c78793          	addi	a5,a5,-1636 # ffffffe000209020 <buddy>
ffffffe00020068c:	0087b703          	ld	a4,8(a5)
ffffffe000200690:	fe043783          	ld	a5,-32(s0)
ffffffe000200694:	00479793          	slli	a5,a5,0x4
ffffffe000200698:	00878793          	addi	a5,a5,8
ffffffe00020069c:	00f707b3          	add	a5,a4,a5
ffffffe0002006a0:	0007b783          	ld	a5,0(a5)
ffffffe0002006a4:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe0002006a8:	00009797          	auipc	a5,0x9
ffffffe0002006ac:	97878793          	addi	a5,a5,-1672 # ffffffe000209020 <buddy>
ffffffe0002006b0:	0087b703          	ld	a4,8(a5)
ffffffe0002006b4:	fe043783          	ld	a5,-32(s0)
ffffffe0002006b8:	00178793          	addi	a5,a5,1
ffffffe0002006bc:	00479793          	slli	a5,a5,0x4
ffffffe0002006c0:	00f707b3          	add	a5,a4,a5
ffffffe0002006c4:	0007b783          	ld	a5,0(a5)
ffffffe0002006c8:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size) 
ffffffe0002006cc:	fd843703          	ld	a4,-40(s0)
ffffffe0002006d0:	fd043783          	ld	a5,-48(s0)
ffffffe0002006d4:	00f707b3          	add	a5,a4,a5
ffffffe0002006d8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006dc:	02f71463          	bne	a4,a5,ffffffe000200704 <buddy_free+0x150>
            buddy.bitmap[index] = node_size;
ffffffe0002006e0:	00009797          	auipc	a5,0x9
ffffffe0002006e4:	94078793          	addi	a5,a5,-1728 # ffffffe000209020 <buddy>
ffffffe0002006e8:	0087b703          	ld	a4,8(a5)
ffffffe0002006ec:	fe043783          	ld	a5,-32(s0)
ffffffe0002006f0:	00379793          	slli	a5,a5,0x3
ffffffe0002006f4:	00f707b3          	add	a5,a4,a5
ffffffe0002006f8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006fc:	00e7b023          	sd	a4,0(a5)
ffffffe000200700:	0300006f          	j	ffffffe000200730 <buddy_free+0x17c>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe000200704:	00009797          	auipc	a5,0x9
ffffffe000200708:	91c78793          	addi	a5,a5,-1764 # ffffffe000209020 <buddy>
ffffffe00020070c:	0087b703          	ld	a4,8(a5)
ffffffe000200710:	fe043783          	ld	a5,-32(s0)
ffffffe000200714:	00379793          	slli	a5,a5,0x3
ffffffe000200718:	00f706b3          	add	a3,a4,a5
ffffffe00020071c:	fd843703          	ld	a4,-40(s0)
ffffffe000200720:	fd043783          	ld	a5,-48(s0)
ffffffe000200724:	00e7f463          	bgeu	a5,a4,ffffffe00020072c <buddy_free+0x178>
ffffffe000200728:	00070793          	mv	a5,a4
ffffffe00020072c:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200730:	fe043783          	ld	a5,-32(s0)
ffffffe000200734:	f20798e3          	bnez	a5,ffffffe000200664 <buddy_free+0xb0>
    }
}
ffffffe000200738:	00000013          	nop
ffffffe00020073c:	00000013          	nop
ffffffe000200740:	03813403          	ld	s0,56(sp)
ffffffe000200744:	04010113          	addi	sp,sp,64
ffffffe000200748:	00008067          	ret

ffffffe00020074c <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages) {
ffffffe00020074c:	fc010113          	addi	sp,sp,-64
ffffffe000200750:	02113c23          	sd	ra,56(sp)
ffffffe000200754:	02813823          	sd	s0,48(sp)
ffffffe000200758:	04010413          	addi	s0,sp,64
ffffffe00020075c:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe000200760:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe000200764:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe000200768:	fc843783          	ld	a5,-56(s0)
ffffffe00020076c:	00079863          	bnez	a5,ffffffe00020077c <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200770:	00100793          	li	a5,1
ffffffe000200774:	fcf43423          	sd	a5,-56(s0)
ffffffe000200778:	0240006f          	j	ffffffe00020079c <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe00020077c:	fc843783          	ld	a5,-56(s0)
ffffffe000200780:	fff78713          	addi	a4,a5,-1
ffffffe000200784:	fc843783          	ld	a5,-56(s0)
ffffffe000200788:	00f777b3          	and	a5,a4,a5
ffffffe00020078c:	00078863          	beqz	a5,ffffffe00020079c <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe000200790:	fc843503          	ld	a0,-56(s0)
ffffffe000200794:	bc9ff0ef          	jal	ra,ffffffe00020035c <fixsize>
ffffffe000200798:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe00020079c:	00009797          	auipc	a5,0x9
ffffffe0002007a0:	88478793          	addi	a5,a5,-1916 # ffffffe000209020 <buddy>
ffffffe0002007a4:	0087b703          	ld	a4,8(a5)
ffffffe0002007a8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007ac:	00379793          	slli	a5,a5,0x3
ffffffe0002007b0:	00f707b3          	add	a5,a4,a5
ffffffe0002007b4:	0007b783          	ld	a5,0(a5)
ffffffe0002007b8:	fc843703          	ld	a4,-56(s0)
ffffffe0002007bc:	00e7f663          	bgeu	a5,a4,ffffffe0002007c8 <buddy_alloc+0x7c>
        return 0;
ffffffe0002007c0:	00000793          	li	a5,0
ffffffe0002007c4:	1480006f          	j	ffffffe00020090c <buddy_alloc+0x1c0>

    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe0002007c8:	00009797          	auipc	a5,0x9
ffffffe0002007cc:	85878793          	addi	a5,a5,-1960 # ffffffe000209020 <buddy>
ffffffe0002007d0:	0007b783          	ld	a5,0(a5)
ffffffe0002007d4:	fef43023          	sd	a5,-32(s0)
ffffffe0002007d8:	05c0006f          	j	ffffffe000200834 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe0002007dc:	00009797          	auipc	a5,0x9
ffffffe0002007e0:	84478793          	addi	a5,a5,-1980 # ffffffe000209020 <buddy>
ffffffe0002007e4:	0087b703          	ld	a4,8(a5)
ffffffe0002007e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007ec:	00479793          	slli	a5,a5,0x4
ffffffe0002007f0:	00878793          	addi	a5,a5,8
ffffffe0002007f4:	00f707b3          	add	a5,a4,a5
ffffffe0002007f8:	0007b783          	ld	a5,0(a5)
ffffffe0002007fc:	fc843703          	ld	a4,-56(s0)
ffffffe000200800:	00e7ec63          	bltu	a5,a4,ffffffe000200818 <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe000200804:	fe843783          	ld	a5,-24(s0)
ffffffe000200808:	00179793          	slli	a5,a5,0x1
ffffffe00020080c:	00178793          	addi	a5,a5,1
ffffffe000200810:	fef43423          	sd	a5,-24(s0)
ffffffe000200814:	0140006f          	j	ffffffe000200828 <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe000200818:	fe843783          	ld	a5,-24(s0)
ffffffe00020081c:	00178793          	addi	a5,a5,1
ffffffe000200820:	00179793          	slli	a5,a5,0x1
ffffffe000200824:	fef43423          	sd	a5,-24(s0)
    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe000200828:	fe043783          	ld	a5,-32(s0)
ffffffe00020082c:	0017d793          	srli	a5,a5,0x1
ffffffe000200830:	fef43023          	sd	a5,-32(s0)
ffffffe000200834:	fe043703          	ld	a4,-32(s0)
ffffffe000200838:	fc843783          	ld	a5,-56(s0)
ffffffe00020083c:	faf710e3          	bne	a4,a5,ffffffe0002007dc <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe000200840:	00008797          	auipc	a5,0x8
ffffffe000200844:	7e078793          	addi	a5,a5,2016 # ffffffe000209020 <buddy>
ffffffe000200848:	0087b703          	ld	a4,8(a5)
ffffffe00020084c:	fe843783          	ld	a5,-24(s0)
ffffffe000200850:	00379793          	slli	a5,a5,0x3
ffffffe000200854:	00f707b3          	add	a5,a4,a5
ffffffe000200858:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe00020085c:	fe843783          	ld	a5,-24(s0)
ffffffe000200860:	00178713          	addi	a4,a5,1
ffffffe000200864:	fe043783          	ld	a5,-32(s0)
ffffffe000200868:	02f70733          	mul	a4,a4,a5
ffffffe00020086c:	00008797          	auipc	a5,0x8
ffffffe000200870:	7b478793          	addi	a5,a5,1972 # ffffffe000209020 <buddy>
ffffffe000200874:	0007b783          	ld	a5,0(a5)
ffffffe000200878:	40f707b3          	sub	a5,a4,a5
ffffffe00020087c:	fcf43c23          	sd	a5,-40(s0)

    while (index) {
ffffffe000200880:	0800006f          	j	ffffffe000200900 <buddy_alloc+0x1b4>
        index = PARENT(index);
ffffffe000200884:	fe843783          	ld	a5,-24(s0)
ffffffe000200888:	00178793          	addi	a5,a5,1
ffffffe00020088c:	0017d793          	srli	a5,a5,0x1
ffffffe000200890:	fff78793          	addi	a5,a5,-1
ffffffe000200894:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] = 
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200898:	00008797          	auipc	a5,0x8
ffffffe00020089c:	78878793          	addi	a5,a5,1928 # ffffffe000209020 <buddy>
ffffffe0002008a0:	0087b703          	ld	a4,8(a5)
ffffffe0002008a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008a8:	00178793          	addi	a5,a5,1
ffffffe0002008ac:	00479793          	slli	a5,a5,0x4
ffffffe0002008b0:	00f707b3          	add	a5,a4,a5
ffffffe0002008b4:	0007b603          	ld	a2,0(a5)
ffffffe0002008b8:	00008797          	auipc	a5,0x8
ffffffe0002008bc:	76878793          	addi	a5,a5,1896 # ffffffe000209020 <buddy>
ffffffe0002008c0:	0087b703          	ld	a4,8(a5)
ffffffe0002008c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008c8:	00479793          	slli	a5,a5,0x4
ffffffe0002008cc:	00878793          	addi	a5,a5,8
ffffffe0002008d0:	00f707b3          	add	a5,a4,a5
ffffffe0002008d4:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008d8:	00008797          	auipc	a5,0x8
ffffffe0002008dc:	74878793          	addi	a5,a5,1864 # ffffffe000209020 <buddy>
ffffffe0002008e0:	0087b683          	ld	a3,8(a5)
ffffffe0002008e4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008e8:	00379793          	slli	a5,a5,0x3
ffffffe0002008ec:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe0002008f0:	00060793          	mv	a5,a2
ffffffe0002008f4:	00e7f463          	bgeu	a5,a4,ffffffe0002008fc <buddy_alloc+0x1b0>
ffffffe0002008f8:	00070793          	mv	a5,a4
        buddy.bitmap[index] = 
ffffffe0002008fc:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200900:	fe843783          	ld	a5,-24(s0)
ffffffe000200904:	f80790e3          	bnez	a5,ffffffe000200884 <buddy_alloc+0x138>
    }
    
    return pfn;
ffffffe000200908:	fd843783          	ld	a5,-40(s0)
}
ffffffe00020090c:	00078513          	mv	a0,a5
ffffffe000200910:	03813083          	ld	ra,56(sp)
ffffffe000200914:	03013403          	ld	s0,48(sp)
ffffffe000200918:	04010113          	addi	sp,sp,64
ffffffe00020091c:	00008067          	ret

ffffffe000200920 <alloc_pages>:


void *alloc_pages(uint64_t nrpages) {
ffffffe000200920:	fd010113          	addi	sp,sp,-48
ffffffe000200924:	02113423          	sd	ra,40(sp)
ffffffe000200928:	02813023          	sd	s0,32(sp)
ffffffe00020092c:	03010413          	addi	s0,sp,48
ffffffe000200930:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe000200934:	fd843503          	ld	a0,-40(s0)
ffffffe000200938:	e15ff0ef          	jal	ra,ffffffe00020074c <buddy_alloc>
ffffffe00020093c:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe000200940:	fe843783          	ld	a5,-24(s0)
ffffffe000200944:	00079663          	bnez	a5,ffffffe000200950 <alloc_pages+0x30>
        return 0;
ffffffe000200948:	00000793          	li	a5,0
ffffffe00020094c:	0180006f          	j	ffffffe000200964 <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe000200950:	fe843783          	ld	a5,-24(s0)
ffffffe000200954:	00c79713          	slli	a4,a5,0xc
ffffffe000200958:	fff00793          	li	a5,-1
ffffffe00020095c:	02579793          	slli	a5,a5,0x25
ffffffe000200960:	00f707b3          	add	a5,a4,a5
}
ffffffe000200964:	00078513          	mv	a0,a5
ffffffe000200968:	02813083          	ld	ra,40(sp)
ffffffe00020096c:	02013403          	ld	s0,32(sp)
ffffffe000200970:	03010113          	addi	sp,sp,48
ffffffe000200974:	00008067          	ret

ffffffe000200978 <alloc_page>:

void *alloc_page() {
ffffffe000200978:	ff010113          	addi	sp,sp,-16
ffffffe00020097c:	00113423          	sd	ra,8(sp)
ffffffe000200980:	00813023          	sd	s0,0(sp)
ffffffe000200984:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe000200988:	00100513          	li	a0,1
ffffffe00020098c:	f95ff0ef          	jal	ra,ffffffe000200920 <alloc_pages>
ffffffe000200990:	00050793          	mv	a5,a0
}
ffffffe000200994:	00078513          	mv	a0,a5
ffffffe000200998:	00813083          	ld	ra,8(sp)
ffffffe00020099c:	00013403          	ld	s0,0(sp)
ffffffe0002009a0:	01010113          	addi	sp,sp,16
ffffffe0002009a4:	00008067          	ret

ffffffe0002009a8 <free_pages>:

void free_pages(void *va) {
ffffffe0002009a8:	fe010113          	addi	sp,sp,-32
ffffffe0002009ac:	00113c23          	sd	ra,24(sp)
ffffffe0002009b0:	00813823          	sd	s0,16(sp)
ffffffe0002009b4:	02010413          	addi	s0,sp,32
ffffffe0002009b8:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe0002009bc:	fe843703          	ld	a4,-24(s0)
ffffffe0002009c0:	00100793          	li	a5,1
ffffffe0002009c4:	02579793          	slli	a5,a5,0x25
ffffffe0002009c8:	00f707b3          	add	a5,a4,a5
ffffffe0002009cc:	00c7d793          	srli	a5,a5,0xc
ffffffe0002009d0:	00078513          	mv	a0,a5
ffffffe0002009d4:	be1ff0ef          	jal	ra,ffffffe0002005b4 <buddy_free>
}
ffffffe0002009d8:	00000013          	nop
ffffffe0002009dc:	01813083          	ld	ra,24(sp)
ffffffe0002009e0:	01013403          	ld	s0,16(sp)
ffffffe0002009e4:	02010113          	addi	sp,sp,32
ffffffe0002009e8:	00008067          	ret

ffffffe0002009ec <kalloc>:

void *kalloc() {
ffffffe0002009ec:	ff010113          	addi	sp,sp,-16
ffffffe0002009f0:	00113423          	sd	ra,8(sp)
ffffffe0002009f4:	00813023          	sd	s0,0(sp)
ffffffe0002009f8:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;
    
    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe0002009fc:	f7dff0ef          	jal	ra,ffffffe000200978 <alloc_page>
ffffffe000200a00:	00050793          	mv	a5,a0
}
ffffffe000200a04:	00078513          	mv	a0,a5
ffffffe000200a08:	00813083          	ld	ra,8(sp)
ffffffe000200a0c:	00013403          	ld	s0,0(sp)
ffffffe000200a10:	01010113          	addi	sp,sp,16
ffffffe000200a14:	00008067          	ret

ffffffe000200a18 <kfree>:

void kfree(void *addr) {
ffffffe000200a18:	fe010113          	addi	sp,sp,-32
ffffffe000200a1c:	00113c23          	sd	ra,24(sp)
ffffffe000200a20:	00813823          	sd	s0,16(sp)
ffffffe000200a24:	02010413          	addi	s0,sp,32
ffffffe000200a28:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe000200a2c:	fe843503          	ld	a0,-24(s0)
ffffffe000200a30:	f79ff0ef          	jal	ra,ffffffe0002009a8 <free_pages>

    return;
ffffffe000200a34:	00000013          	nop
}
ffffffe000200a38:	01813083          	ld	ra,24(sp)
ffffffe000200a3c:	01013403          	ld	s0,16(sp)
ffffffe000200a40:	02010113          	addi	sp,sp,32
ffffffe000200a44:	00008067          	ret

ffffffe000200a48 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe000200a48:	fd010113          	addi	sp,sp,-48
ffffffe000200a4c:	02113423          	sd	ra,40(sp)
ffffffe000200a50:	02813023          	sd	s0,32(sp)
ffffffe000200a54:	03010413          	addi	s0,sp,48
ffffffe000200a58:	fca43c23          	sd	a0,-40(s0)
ffffffe000200a5c:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe000200a60:	fd843703          	ld	a4,-40(s0)
ffffffe000200a64:	000017b7          	lui	a5,0x1
ffffffe000200a68:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200a6c:	00f70733          	add	a4,a4,a5
ffffffe000200a70:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a74:	00f777b3          	and	a5,a4,a5
ffffffe000200a78:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a7c:	01c0006f          	j	ffffffe000200a98 <kfreerange+0x50>
        kfree((void *)addr);
ffffffe000200a80:	fe843503          	ld	a0,-24(s0)
ffffffe000200a84:	f95ff0ef          	jal	ra,ffffffe000200a18 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a88:	fe843703          	ld	a4,-24(s0)
ffffffe000200a8c:	000017b7          	lui	a5,0x1
ffffffe000200a90:	00f707b3          	add	a5,a4,a5
ffffffe000200a94:	fef43423          	sd	a5,-24(s0)
ffffffe000200a98:	fe843703          	ld	a4,-24(s0)
ffffffe000200a9c:	000017b7          	lui	a5,0x1
ffffffe000200aa0:	00f70733          	add	a4,a4,a5
ffffffe000200aa4:	fd043783          	ld	a5,-48(s0)
ffffffe000200aa8:	fce7fce3          	bgeu	a5,a4,ffffffe000200a80 <kfreerange+0x38>
    }
}
ffffffe000200aac:	00000013          	nop
ffffffe000200ab0:	00000013          	nop
ffffffe000200ab4:	02813083          	ld	ra,40(sp)
ffffffe000200ab8:	02013403          	ld	s0,32(sp)
ffffffe000200abc:	03010113          	addi	sp,sp,48
ffffffe000200ac0:	00008067          	ret

ffffffe000200ac4 <mm_init>:

void mm_init(void) {
ffffffe000200ac4:	ff010113          	addi	sp,sp,-16
ffffffe000200ac8:	00113423          	sd	ra,8(sp)
ffffffe000200acc:	00813023          	sd	s0,0(sp)
ffffffe000200ad0:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200ad4:	935ff0ef          	jal	ra,ffffffe000200408 <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200ad8:	00003517          	auipc	a0,0x3
ffffffe000200adc:	54050513          	addi	a0,a0,1344 # ffffffe000204018 <_srodata+0x18>
ffffffe000200ae0:	640020ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe000200ae4:	00000013          	nop
ffffffe000200ae8:	00813083          	ld	ra,8(sp)
ffffffe000200aec:	00013403          	ld	s0,0(sp)
ffffffe000200af0:	01010113          	addi	sp,sp,16
ffffffe000200af4:	00008067          	ret

ffffffe000200af8 <get_current_proc>:
extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];

struct task_struct *get_current_proc()
{
ffffffe000200af8:	ff010113          	addi	sp,sp,-16
ffffffe000200afc:	00813423          	sd	s0,8(sp)
ffffffe000200b00:	01010413          	addi	s0,sp,16
    return current;
ffffffe000200b04:	00008797          	auipc	a5,0x8
ffffffe000200b08:	50c78793          	addi	a5,a5,1292 # ffffffe000209010 <current>
ffffffe000200b0c:	0007b783          	ld	a5,0(a5)
}
ffffffe000200b10:	00078513          	mv	a0,a5
ffffffe000200b14:	00813403          	ld	s0,8(sp)
ffffffe000200b18:	01010113          	addi	sp,sp,16
ffffffe000200b1c:	00008067          	ret

ffffffe000200b20 <set_user_pgtbl>:

void set_user_pgtbl(struct task_struct *T)
{
ffffffe000200b20:	fb010113          	addi	sp,sp,-80
ffffffe000200b24:	04113423          	sd	ra,72(sp)
ffffffe000200b28:	04813023          	sd	s0,64(sp)
ffffffe000200b2c:	02913c23          	sd	s1,56(sp)
ffffffe000200b30:	05010413          	addi	s0,sp,80
ffffffe000200b34:	faa43c23          	sd	a0,-72(s0)
    T->pgd = (uint64_t *)alloc_page();
ffffffe000200b38:	e41ff0ef          	jal	ra,ffffffe000200978 <alloc_page>
ffffffe000200b3c:	00050713          	mv	a4,a0
ffffffe000200b40:	fb843783          	ld	a5,-72(s0)
ffffffe000200b44:	0ae7b423          	sd	a4,168(a5)
    memset(T->pgd, 0, PGSIZE);
ffffffe000200b48:	fb843783          	ld	a5,-72(s0)
ffffffe000200b4c:	0a87b783          	ld	a5,168(a5)
ffffffe000200b50:	00001637          	lui	a2,0x1
ffffffe000200b54:	00000593          	li	a1,0
ffffffe000200b58:	00078513          	mv	a0,a5
ffffffe000200b5c:	6e4020ef          	jal	ra,ffffffe000203240 <memset>
    memcpy(T->pgd, get_kernel_pgtbl(), PGSIZE);
ffffffe000200b60:	fb843783          	ld	a5,-72(s0)
ffffffe000200b64:	0a87b483          	ld	s1,168(a5)
ffffffe000200b68:	3e4010ef          	jal	ra,ffffffe000201f4c <get_kernel_pgtbl>
ffffffe000200b6c:	00050793          	mv	a5,a0
ffffffe000200b70:	00001637          	lui	a2,0x1
ffffffe000200b74:	00078593          	mv	a1,a5
ffffffe000200b78:	00048513          	mv	a0,s1
ffffffe000200b7c:	734020ef          	jal	ra,ffffffe0002032b0 <memcpy>

    printk("set_user_pgtbl: T->pgd = %p\n", T->pgd);
ffffffe000200b80:	fb843783          	ld	a5,-72(s0)
ffffffe000200b84:	0a87b783          	ld	a5,168(a5)
ffffffe000200b88:	00078593          	mv	a1,a5
ffffffe000200b8c:	00003517          	auipc	a0,0x3
ffffffe000200b90:	4a450513          	addi	a0,a0,1188 # ffffffe000204030 <_srodata+0x30>
ffffffe000200b94:	58c020ef          	jal	ra,ffffffe000203120 <printk>

    uint64_t user_perm = PTE_V | PTE_R | PTE_W | PTE_U;
ffffffe000200b98:	01700793          	li	a5,23
ffffffe000200b9c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t pa = VA2PA(alloc_page());
ffffffe000200ba0:	dd9ff0ef          	jal	ra,ffffffe000200978 <alloc_page>
ffffffe000200ba4:	00050793          	mv	a5,a0
ffffffe000200ba8:	00078713          	mv	a4,a5
ffffffe000200bac:	04100793          	li	a5,65
ffffffe000200bb0:	01f79793          	slli	a5,a5,0x1f
ffffffe000200bb4:	00f707b3          	add	a5,a4,a5
ffffffe000200bb8:	fcf43823          	sd	a5,-48(s0)
    uint64_t va = USER_END - PGSIZE;
ffffffe000200bbc:	040007b7          	lui	a5,0x4000
ffffffe000200bc0:	fff78793          	addi	a5,a5,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000200bc4:	00c79793          	slli	a5,a5,0xc
ffffffe000200bc8:	fcf43423          	sd	a5,-56(s0)
    printk("set_user_pgtbl: va = %lx, pa = %lx\n", va, pa);
ffffffe000200bcc:	fd043603          	ld	a2,-48(s0)
ffffffe000200bd0:	fc843583          	ld	a1,-56(s0)
ffffffe000200bd4:	00003517          	auipc	a0,0x3
ffffffe000200bd8:	47c50513          	addi	a0,a0,1148 # ffffffe000204050 <_srodata+0x50>
ffffffe000200bdc:	544020ef          	jal	ra,ffffffe000203120 <printk>
    create_mapping(T->pgd, va, pa, PGSIZE, user_perm);
ffffffe000200be0:	fb843783          	ld	a5,-72(s0)
ffffffe000200be4:	0a87b783          	ld	a5,168(a5)
ffffffe000200be8:	fd843703          	ld	a4,-40(s0)
ffffffe000200bec:	000016b7          	lui	a3,0x1
ffffffe000200bf0:	fd043603          	ld	a2,-48(s0)
ffffffe000200bf4:	fc843583          	ld	a1,-56(s0)
ffffffe000200bf8:	00078513          	mv	a0,a5
ffffffe000200bfc:	160010ef          	jal	ra,ffffffe000201d5c <create_mapping>
    printk("set_user_pgtbl done\n");
ffffffe000200c00:	00003517          	auipc	a0,0x3
ffffffe000200c04:	47850513          	addi	a0,a0,1144 # ffffffe000204078 <_srodata+0x78>
ffffffe000200c08:	518020ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe000200c0c:	00000013          	nop
ffffffe000200c10:	04813083          	ld	ra,72(sp)
ffffffe000200c14:	04013403          	ld	s0,64(sp)
ffffffe000200c18:	03813483          	ld	s1,56(sp)
ffffffe000200c1c:	05010113          	addi	sp,sp,80
ffffffe000200c20:	00008067          	ret

ffffffe000200c24 <load_program>:

void load_program(struct task_struct *task)
{
ffffffe000200c24:	fa010113          	addi	sp,sp,-96
ffffffe000200c28:	04113c23          	sd	ra,88(sp)
ffffffe000200c2c:	04813823          	sd	s0,80(sp)
ffffffe000200c30:	06010413          	addi	s0,sp,96
ffffffe000200c34:	faa43423          	sd	a0,-88(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200c38:	00005797          	auipc	a5,0x5
ffffffe000200c3c:	3c878793          	addi	a5,a5,968 # ffffffe000206000 <_sramdisk>
ffffffe000200c40:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200c44:	fe043783          	ld	a5,-32(s0)
ffffffe000200c48:	0207b703          	ld	a4,32(a5)
ffffffe000200c4c:	00005797          	auipc	a5,0x5
ffffffe000200c50:	3b478793          	addi	a5,a5,948 # ffffffe000206000 <_sramdisk>
ffffffe000200c54:	00f707b3          	add	a5,a4,a5
ffffffe000200c58:	fcf43c23          	sd	a5,-40(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200c5c:	fe042623          	sw	zero,-20(s0)
ffffffe000200c60:	1b40006f          	j	ffffffe000200e14 <load_program+0x1f0>
    {
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200c64:	fec42703          	lw	a4,-20(s0)
ffffffe000200c68:	00070793          	mv	a5,a4
ffffffe000200c6c:	00379793          	slli	a5,a5,0x3
ffffffe000200c70:	40e787b3          	sub	a5,a5,a4
ffffffe000200c74:	00379793          	slli	a5,a5,0x3
ffffffe000200c78:	00078713          	mv	a4,a5
ffffffe000200c7c:	fd843783          	ld	a5,-40(s0)
ffffffe000200c80:	00e787b3          	add	a5,a5,a4
ffffffe000200c84:	fcf43823          	sd	a5,-48(s0)
        if (phdr->p_type == PT_LOAD)
ffffffe000200c88:	fd043783          	ld	a5,-48(s0)
ffffffe000200c8c:	0007a783          	lw	a5,0(a5)
ffffffe000200c90:	00078713          	mv	a4,a5
ffffffe000200c94:	00100793          	li	a5,1
ffffffe000200c98:	16f71863          	bne	a4,a5,ffffffe000200e08 <load_program+0x1e4>
        {
            // alloc space and copy content
            uint64_t align_offset = phdr->p_vaddr % PGSIZE;
ffffffe000200c9c:	fd043783          	ld	a5,-48(s0)
ffffffe000200ca0:	0107b703          	ld	a4,16(a5)
ffffffe000200ca4:	000017b7          	lui	a5,0x1
ffffffe000200ca8:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200cac:	00f777b3          	and	a5,a4,a5
ffffffe000200cb0:	fcf43423          	sd	a5,-56(s0)
            uint64_t num_pg = (phdr->p_memsz + align_offset + PGSIZE - 1) / PGSIZE;
ffffffe000200cb4:	fd043783          	ld	a5,-48(s0)
ffffffe000200cb8:	0287b703          	ld	a4,40(a5)
ffffffe000200cbc:	fc843783          	ld	a5,-56(s0)
ffffffe000200cc0:	00f70733          	add	a4,a4,a5
ffffffe000200cc4:	000017b7          	lui	a5,0x1
ffffffe000200cc8:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200ccc:	00f707b3          	add	a5,a4,a5
ffffffe000200cd0:	00c7d793          	srli	a5,a5,0xc
ffffffe000200cd4:	fcf43023          	sd	a5,-64(s0)
            uint64_t *new_pgs = (uint64_t *)alloc_pages(num_pg);
ffffffe000200cd8:	fc043503          	ld	a0,-64(s0)
ffffffe000200cdc:	c45ff0ef          	jal	ra,ffffffe000200920 <alloc_pages>
ffffffe000200ce0:	faa43c23          	sd	a0,-72(s0)
            memcpy((void *)((uint64_t)new_pgs + align_offset), _sramdisk + phdr->p_offset, phdr->p_filesz);
ffffffe000200ce4:	fb843703          	ld	a4,-72(s0)
ffffffe000200ce8:	fc843783          	ld	a5,-56(s0)
ffffffe000200cec:	00f707b3          	add	a5,a4,a5
ffffffe000200cf0:	00078693          	mv	a3,a5
ffffffe000200cf4:	fd043783          	ld	a5,-48(s0)
ffffffe000200cf8:	0087b703          	ld	a4,8(a5)
ffffffe000200cfc:	00005797          	auipc	a5,0x5
ffffffe000200d00:	30478793          	addi	a5,a5,772 # ffffffe000206000 <_sramdisk>
ffffffe000200d04:	00f70733          	add	a4,a4,a5
ffffffe000200d08:	fd043783          	ld	a5,-48(s0)
ffffffe000200d0c:	0207b783          	ld	a5,32(a5)
ffffffe000200d10:	00078613          	mv	a2,a5
ffffffe000200d14:	00070593          	mv	a1,a4
ffffffe000200d18:	00068513          	mv	a0,a3
ffffffe000200d1c:	594020ef          	jal	ra,ffffffe0002032b0 <memcpy>
            memset((void *)((uint64_t)new_pgs + align_offset + phdr->p_filesz), 0x0, phdr->p_memsz - phdr->p_filesz);
ffffffe000200d20:	fb843703          	ld	a4,-72(s0)
ffffffe000200d24:	fc843783          	ld	a5,-56(s0)
ffffffe000200d28:	00f70733          	add	a4,a4,a5
ffffffe000200d2c:	fd043783          	ld	a5,-48(s0)
ffffffe000200d30:	0207b783          	ld	a5,32(a5)
ffffffe000200d34:	00f707b3          	add	a5,a4,a5
ffffffe000200d38:	00078693          	mv	a3,a5
ffffffe000200d3c:	fd043783          	ld	a5,-48(s0)
ffffffe000200d40:	0287b703          	ld	a4,40(a5)
ffffffe000200d44:	fd043783          	ld	a5,-48(s0)
ffffffe000200d48:	0207b783          	ld	a5,32(a5)
ffffffe000200d4c:	40f707b3          	sub	a5,a4,a5
ffffffe000200d50:	00078613          	mv	a2,a5
ffffffe000200d54:	00000593          	li	a1,0
ffffffe000200d58:	00068513          	mv	a0,a3
ffffffe000200d5c:	4e4020ef          	jal	ra,ffffffe000203240 <memset>
            // do mapping
            create_mapping(task->pgd, phdr->p_vaddr - align_offset, VA2PA((uint64_t)new_pgs), phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
ffffffe000200d60:	fa843783          	ld	a5,-88(s0)
ffffffe000200d64:	0a87b503          	ld	a0,168(a5)
ffffffe000200d68:	fd043783          	ld	a5,-48(s0)
ffffffe000200d6c:	0107b703          	ld	a4,16(a5)
ffffffe000200d70:	fc843783          	ld	a5,-56(s0)
ffffffe000200d74:	40f705b3          	sub	a1,a4,a5
ffffffe000200d78:	fb843703          	ld	a4,-72(s0)
ffffffe000200d7c:	04100793          	li	a5,65
ffffffe000200d80:	01f79793          	slli	a5,a5,0x1f
ffffffe000200d84:	00f70633          	add	a2,a4,a5
ffffffe000200d88:	fd043783          	ld	a5,-48(s0)
ffffffe000200d8c:	0287b703          	ld	a4,40(a5)
ffffffe000200d90:	fc843783          	ld	a5,-56(s0)
ffffffe000200d94:	00f706b3          	add	a3,a4,a5
ffffffe000200d98:	fd043783          	ld	a5,-48(s0)
ffffffe000200d9c:	0047a783          	lw	a5,4(a5)
ffffffe000200da0:	0187e793          	ori	a5,a5,24
ffffffe000200da4:	0007879b          	sext.w	a5,a5
ffffffe000200da8:	02079793          	slli	a5,a5,0x20
ffffffe000200dac:	0207d793          	srli	a5,a5,0x20
ffffffe000200db0:	00078713          	mv	a4,a5
ffffffe000200db4:	7a9000ef          	jal	ra,ffffffe000201d5c <create_mapping>
            printk("[load_program] va = %lx, pa = %lx, sz = %lx, perm = %lx\n", phdr->p_vaddr - align_offset, (uint64_t)new_pgs - PA2VA_OFFSET, phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
ffffffe000200db8:	fd043783          	ld	a5,-48(s0)
ffffffe000200dbc:	0107b703          	ld	a4,16(a5)
ffffffe000200dc0:	fc843783          	ld	a5,-56(s0)
ffffffe000200dc4:	40f705b3          	sub	a1,a4,a5
ffffffe000200dc8:	fb843703          	ld	a4,-72(s0)
ffffffe000200dcc:	04100793          	li	a5,65
ffffffe000200dd0:	01f79793          	slli	a5,a5,0x1f
ffffffe000200dd4:	00f70633          	add	a2,a4,a5
ffffffe000200dd8:	fd043783          	ld	a5,-48(s0)
ffffffe000200ddc:	0287b703          	ld	a4,40(a5)
ffffffe000200de0:	fc843783          	ld	a5,-56(s0)
ffffffe000200de4:	00f706b3          	add	a3,a4,a5
ffffffe000200de8:	fd043783          	ld	a5,-48(s0)
ffffffe000200dec:	0047a783          	lw	a5,4(a5)
ffffffe000200df0:	0187e793          	ori	a5,a5,24
ffffffe000200df4:	0007879b          	sext.w	a5,a5
ffffffe000200df8:	00078713          	mv	a4,a5
ffffffe000200dfc:	00003517          	auipc	a0,0x3
ffffffe000200e00:	29450513          	addi	a0,a0,660 # ffffffe000204090 <_srodata+0x90>
ffffffe000200e04:	31c020ef          	jal	ra,ffffffe000203120 <printk>
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200e08:	fec42783          	lw	a5,-20(s0)
ffffffe000200e0c:	0017879b          	addiw	a5,a5,1
ffffffe000200e10:	fef42623          	sw	a5,-20(s0)
ffffffe000200e14:	fe043783          	ld	a5,-32(s0)
ffffffe000200e18:	0387d783          	lhu	a5,56(a5)
ffffffe000200e1c:	0007871b          	sext.w	a4,a5
ffffffe000200e20:	fec42783          	lw	a5,-20(s0)
ffffffe000200e24:	0007879b          	sext.w	a5,a5
ffffffe000200e28:	e2e7cee3          	blt	a5,a4,ffffffe000200c64 <load_program+0x40>
            // code...
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe000200e2c:	fe043783          	ld	a5,-32(s0)
ffffffe000200e30:	0187b703          	ld	a4,24(a5)
ffffffe000200e34:	fa843783          	ld	a5,-88(s0)
ffffffe000200e38:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200e3c:	00000013          	nop
ffffffe000200e40:	05813083          	ld	ra,88(sp)
ffffffe000200e44:	05013403          	ld	s0,80(sp)
ffffffe000200e48:	06010113          	addi	sp,sp,96
ffffffe000200e4c:	00008067          	ret

ffffffe000200e50 <task_init>:

void task_init()
{
ffffffe000200e50:	fe010113          	addi	sp,sp,-32
ffffffe000200e54:	00113c23          	sd	ra,24(sp)
ffffffe000200e58:	00813823          	sd	s0,16(sp)
ffffffe000200e5c:	02010413          	addi	s0,sp,32
    srand(2024);
ffffffe000200e60:	7e800513          	li	a0,2024
ffffffe000200e64:	33c020ef          	jal	ra,ffffffe0002031a0 <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
ffffffe000200e68:	b85ff0ef          	jal	ra,ffffffe0002009ec <kalloc>
ffffffe000200e6c:	00050713          	mv	a4,a0
ffffffe000200e70:	00008797          	auipc	a5,0x8
ffffffe000200e74:	19878793          	addi	a5,a5,408 # ffffffe000209008 <idle>
ffffffe000200e78:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe000200e7c:	00008797          	auipc	a5,0x8
ffffffe000200e80:	18c78793          	addi	a5,a5,396 # ffffffe000209008 <idle>
ffffffe000200e84:	0007b783          	ld	a5,0(a5)
ffffffe000200e88:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200e8c:	00008797          	auipc	a5,0x8
ffffffe000200e90:	17c78793          	addi	a5,a5,380 # ffffffe000209008 <idle>
ffffffe000200e94:	0007b783          	ld	a5,0(a5)
ffffffe000200e98:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200e9c:	00008797          	auipc	a5,0x8
ffffffe000200ea0:	16c78793          	addi	a5,a5,364 # ffffffe000209008 <idle>
ffffffe000200ea4:	0007b783          	ld	a5,0(a5)
ffffffe000200ea8:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200eac:	00008797          	auipc	a5,0x8
ffffffe000200eb0:	15c78793          	addi	a5,a5,348 # ffffffe000209008 <idle>
ffffffe000200eb4:	0007b783          	ld	a5,0(a5)
ffffffe000200eb8:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe000200ebc:	00008797          	auipc	a5,0x8
ffffffe000200ec0:	14c78793          	addi	a5,a5,332 # ffffffe000209008 <idle>
ffffffe000200ec4:	0007b703          	ld	a4,0(a5)
ffffffe000200ec8:	00008797          	auipc	a5,0x8
ffffffe000200ecc:	14878793          	addi	a5,a5,328 # ffffffe000209010 <current>
ffffffe000200ed0:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200ed4:	00008797          	auipc	a5,0x8
ffffffe000200ed8:	13478793          	addi	a5,a5,308 # ffffffe000209008 <idle>
ffffffe000200edc:	0007b703          	ld	a4,0(a5)
ffffffe000200ee0:	00008797          	auipc	a5,0x8
ffffffe000200ee4:	15078793          	addi	a5,a5,336 # ffffffe000209030 <task>
ffffffe000200ee8:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000200eec:	00100793          	li	a5,1
ffffffe000200ef0:	fef42623          	sw	a5,-20(s0)
ffffffe000200ef4:	2600006f          	j	ffffffe000201154 <task_init+0x304>
    {
        task[i] = (struct task_struct *)kalloc();
ffffffe000200ef8:	af5ff0ef          	jal	ra,ffffffe0002009ec <kalloc>
ffffffe000200efc:	00050693          	mv	a3,a0
ffffffe000200f00:	00008717          	auipc	a4,0x8
ffffffe000200f04:	13070713          	addi	a4,a4,304 # ffffffe000209030 <task>
ffffffe000200f08:	fec42783          	lw	a5,-20(s0)
ffffffe000200f0c:	00379793          	slli	a5,a5,0x3
ffffffe000200f10:	00f707b3          	add	a5,a4,a5
ffffffe000200f14:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200f18:	00008717          	auipc	a4,0x8
ffffffe000200f1c:	11870713          	addi	a4,a4,280 # ffffffe000209030 <task>
ffffffe000200f20:	fec42783          	lw	a5,-20(s0)
ffffffe000200f24:	00379793          	slli	a5,a5,0x3
ffffffe000200f28:	00f707b3          	add	a5,a4,a5
ffffffe000200f2c:	0007b783          	ld	a5,0(a5)
ffffffe000200f30:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200f34:	2b0020ef          	jal	ra,ffffffe0002031e4 <rand>
ffffffe000200f38:	00050793          	mv	a5,a0
ffffffe000200f3c:	00078713          	mv	a4,a5
ffffffe000200f40:	00a00793          	li	a5,10
ffffffe000200f44:	02f767bb          	remw	a5,a4,a5
ffffffe000200f48:	0007879b          	sext.w	a5,a5
ffffffe000200f4c:	0017879b          	addiw	a5,a5,1
ffffffe000200f50:	0007869b          	sext.w	a3,a5
ffffffe000200f54:	00008717          	auipc	a4,0x8
ffffffe000200f58:	0dc70713          	addi	a4,a4,220 # ffffffe000209030 <task>
ffffffe000200f5c:	fec42783          	lw	a5,-20(s0)
ffffffe000200f60:	00379793          	slli	a5,a5,0x3
ffffffe000200f64:	00f707b3          	add	a5,a4,a5
ffffffe000200f68:	0007b783          	ld	a5,0(a5)
ffffffe000200f6c:	00068713          	mv	a4,a3
ffffffe000200f70:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe000200f74:	00008717          	auipc	a4,0x8
ffffffe000200f78:	0bc70713          	addi	a4,a4,188 # ffffffe000209030 <task>
ffffffe000200f7c:	fec42783          	lw	a5,-20(s0)
ffffffe000200f80:	00379793          	slli	a5,a5,0x3
ffffffe000200f84:	00f707b3          	add	a5,a4,a5
ffffffe000200f88:	0007b783          	ld	a5,0(a5)
ffffffe000200f8c:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe000200f90:	00008717          	auipc	a4,0x8
ffffffe000200f94:	0a070713          	addi	a4,a4,160 # ffffffe000209030 <task>
ffffffe000200f98:	fec42783          	lw	a5,-20(s0)
ffffffe000200f9c:	00379793          	slli	a5,a5,0x3
ffffffe000200fa0:	00f707b3          	add	a5,a4,a5
ffffffe000200fa4:	0007b783          	ld	a5,0(a5)
ffffffe000200fa8:	fec42703          	lw	a4,-20(s0)
ffffffe000200fac:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe000200fb0:	00008717          	auipc	a4,0x8
ffffffe000200fb4:	08070713          	addi	a4,a4,128 # ffffffe000209030 <task>
ffffffe000200fb8:	fec42783          	lw	a5,-20(s0)
ffffffe000200fbc:	00379793          	slli	a5,a5,0x3
ffffffe000200fc0:	00f707b3          	add	a5,a4,a5
ffffffe000200fc4:	0007b783          	ld	a5,0(a5)
ffffffe000200fc8:	fffff717          	auipc	a4,0xfffff
ffffffe000200fcc:	23870713          	addi	a4,a4,568 # ffffffe000200200 <__dummy>
ffffffe000200fd0:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe000200fd4:	00008717          	auipc	a4,0x8
ffffffe000200fd8:	05c70713          	addi	a4,a4,92 # ffffffe000209030 <task>
ffffffe000200fdc:	fec42783          	lw	a5,-20(s0)
ffffffe000200fe0:	00379793          	slli	a5,a5,0x3
ffffffe000200fe4:	00f707b3          	add	a5,a4,a5
ffffffe000200fe8:	0007b783          	ld	a5,0(a5)
ffffffe000200fec:	00078693          	mv	a3,a5
ffffffe000200ff0:	00008717          	auipc	a4,0x8
ffffffe000200ff4:	04070713          	addi	a4,a4,64 # ffffffe000209030 <task>
ffffffe000200ff8:	fec42783          	lw	a5,-20(s0)
ffffffe000200ffc:	00379793          	slli	a5,a5,0x3
ffffffe000201000:	00f707b3          	add	a5,a4,a5
ffffffe000201004:	0007b783          	ld	a5,0(a5)
ffffffe000201008:	00001737          	lui	a4,0x1
ffffffe00020100c:	00e68733          	add	a4,a3,a4
ffffffe000201010:	02e7b423          	sd	a4,40(a5)
        set_user_pgtbl(task[i]);
ffffffe000201014:	00008717          	auipc	a4,0x8
ffffffe000201018:	01c70713          	addi	a4,a4,28 # ffffffe000209030 <task>
ffffffe00020101c:	fec42783          	lw	a5,-20(s0)
ffffffe000201020:	00379793          	slli	a5,a5,0x3
ffffffe000201024:	00f707b3          	add	a5,a4,a5
ffffffe000201028:	0007b783          	ld	a5,0(a5)
ffffffe00020102c:	00078513          	mv	a0,a5
ffffffe000201030:	af1ff0ef          	jal	ra,ffffffe000200b20 <set_user_pgtbl>
        // uint64_t uapp_pages = (PGROUNDUP(_eramdisk - _sramdisk)) / PGSIZE;
        // uint64_t *uapp_mem = (uint64_t *)alloc_pages(uapp_pages);
        // memcpy(uapp_mem, _sramdisk, uapp_pages * PGSIZE);
        // create_mapping(task[i]->pgd, USER_START, VA2PA((uint64_t)uapp_mem), uapp_pages * PGSIZE, PTE_V | PTE_R | PTE_W | PTE_X | PTE_U);
        load_program(task[i]);
ffffffe000201034:	00008717          	auipc	a4,0x8
ffffffe000201038:	ffc70713          	addi	a4,a4,-4 # ffffffe000209030 <task>
ffffffe00020103c:	fec42783          	lw	a5,-20(s0)
ffffffe000201040:	00379793          	slli	a5,a5,0x3
ffffffe000201044:	00f707b3          	add	a5,a4,a5
ffffffe000201048:	0007b783          	ld	a5,0(a5)
ffffffe00020104c:	00078513          	mv	a0,a5
ffffffe000201050:	bd5ff0ef          	jal	ra,ffffffe000200c24 <load_program>
        // task[i]->thread.sepc = USER_START;
        // uint64_t sstatus = SSTATUS_SPIE | SSTATUS_SPP;
        // sstatus &= ~SSTATUS_SPP;
        // task[i]->thread.sstatus = sstatus;
        // task[i]->thread.sscratch = USER_END;
        task[i]->thread.sstatus = 0;
ffffffe000201054:	00008717          	auipc	a4,0x8
ffffffe000201058:	fdc70713          	addi	a4,a4,-36 # ffffffe000209030 <task>
ffffffe00020105c:	fec42783          	lw	a5,-20(s0)
ffffffe000201060:	00379793          	slli	a5,a5,0x3
ffffffe000201064:	00f707b3          	add	a5,a4,a5
ffffffe000201068:	0007b783          	ld	a5,0(a5)
ffffffe00020106c:	0807bc23          	sd	zero,152(a5)
        task[i]->thread.sstatus &= ~SSTATUS_SPP;
ffffffe000201070:	00008717          	auipc	a4,0x8
ffffffe000201074:	fc070713          	addi	a4,a4,-64 # ffffffe000209030 <task>
ffffffe000201078:	fec42783          	lw	a5,-20(s0)
ffffffe00020107c:	00379793          	slli	a5,a5,0x3
ffffffe000201080:	00f707b3          	add	a5,a4,a5
ffffffe000201084:	0007b783          	ld	a5,0(a5)
ffffffe000201088:	0987b703          	ld	a4,152(a5)
ffffffe00020108c:	00008697          	auipc	a3,0x8
ffffffe000201090:	fa468693          	addi	a3,a3,-92 # ffffffe000209030 <task>
ffffffe000201094:	fec42783          	lw	a5,-20(s0)
ffffffe000201098:	00379793          	slli	a5,a5,0x3
ffffffe00020109c:	00f687b3          	add	a5,a3,a5
ffffffe0002010a0:	0007b783          	ld	a5,0(a5)
ffffffe0002010a4:	eff77713          	andi	a4,a4,-257
ffffffe0002010a8:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sstatus |= SSTATUS_SPIE | SSTATUS_SUM;
ffffffe0002010ac:	00008717          	auipc	a4,0x8
ffffffe0002010b0:	f8470713          	addi	a4,a4,-124 # ffffffe000209030 <task>
ffffffe0002010b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002010b8:	00379793          	slli	a5,a5,0x3
ffffffe0002010bc:	00f707b3          	add	a5,a4,a5
ffffffe0002010c0:	0007b783          	ld	a5,0(a5)
ffffffe0002010c4:	0987b683          	ld	a3,152(a5)
ffffffe0002010c8:	00008717          	auipc	a4,0x8
ffffffe0002010cc:	f6870713          	addi	a4,a4,-152 # ffffffe000209030 <task>
ffffffe0002010d0:	fec42783          	lw	a5,-20(s0)
ffffffe0002010d4:	00379793          	slli	a5,a5,0x3
ffffffe0002010d8:	00f707b3          	add	a5,a4,a5
ffffffe0002010dc:	0007b783          	ld	a5,0(a5)
ffffffe0002010e0:	00040737          	lui	a4,0x40
ffffffe0002010e4:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe0002010e8:	00e6e733          	or	a4,a3,a4
ffffffe0002010ec:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe0002010f0:	00008717          	auipc	a4,0x8
ffffffe0002010f4:	f4070713          	addi	a4,a4,-192 # ffffffe000209030 <task>
ffffffe0002010f8:	fec42783          	lw	a5,-20(s0)
ffffffe0002010fc:	00379793          	slli	a5,a5,0x3
ffffffe000201100:	00f707b3          	add	a5,a4,a5
ffffffe000201104:	0007b783          	ld	a5,0(a5)
ffffffe000201108:	00100713          	li	a4,1
ffffffe00020110c:	02671713          	slli	a4,a4,0x26
ffffffe000201110:	0ae7b023          	sd	a4,160(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe000201114:	00008717          	auipc	a4,0x8
ffffffe000201118:	f1c70713          	addi	a4,a4,-228 # ffffffe000209030 <task>
ffffffe00020111c:	fec42783          	lw	a5,-20(s0)
ffffffe000201120:	00379793          	slli	a5,a5,0x3
ffffffe000201124:	00f707b3          	add	a5,a4,a5
ffffffe000201128:	0007b783          	ld	a5,0(a5)
ffffffe00020112c:	0107b703          	ld	a4,16(a5)
ffffffe000201130:	fec42783          	lw	a5,-20(s0)
ffffffe000201134:	00070613          	mv	a2,a4
ffffffe000201138:	00078593          	mv	a1,a5
ffffffe00020113c:	00003517          	auipc	a0,0x3
ffffffe000201140:	f9450513          	addi	a0,a0,-108 # ffffffe0002040d0 <_srodata+0xd0>
ffffffe000201144:	7dd010ef          	jal	ra,ffffffe000203120 <printk>
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000201148:	fec42783          	lw	a5,-20(s0)
ffffffe00020114c:	0017879b          	addiw	a5,a5,1
ffffffe000201150:	fef42623          	sw	a5,-20(s0)
ffffffe000201154:	fec42783          	lw	a5,-20(s0)
ffffffe000201158:	0007871b          	sext.w	a4,a5
ffffffe00020115c:	00400793          	li	a5,4
ffffffe000201160:	d8e7dce3          	bge	a5,a4,ffffffe000200ef8 <task_init+0xa8>
    }

    printk("...task_init done!\n");
ffffffe000201164:	00003517          	auipc	a0,0x3
ffffffe000201168:	f8c50513          	addi	a0,a0,-116 # ffffffe0002040f0 <_srodata+0xf0>
ffffffe00020116c:	7b5010ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe000201170:	00000013          	nop
ffffffe000201174:	01813083          	ld	ra,24(sp)
ffffffe000201178:	01013403          	ld	s0,16(sp)
ffffffe00020117c:	02010113          	addi	sp,sp,32
ffffffe000201180:	00008067          	ret

ffffffe000201184 <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next, uint64_t *pgtbl);

void switch_to(struct task_struct *next)
{
ffffffe000201184:	fd010113          	addi	sp,sp,-48
ffffffe000201188:	02113423          	sd	ra,40(sp)
ffffffe00020118c:	02813023          	sd	s0,32(sp)
ffffffe000201190:	03010413          	addi	s0,sp,48
ffffffe000201194:	fca43c23          	sd	a0,-40(s0)
    if (current != next)
ffffffe000201198:	00008797          	auipc	a5,0x8
ffffffe00020119c:	e7878793          	addi	a5,a5,-392 # ffffffe000209010 <current>
ffffffe0002011a0:	0007b783          	ld	a5,0(a5)
ffffffe0002011a4:	fd843703          	ld	a4,-40(s0)
ffffffe0002011a8:	08f70063          	beq	a4,a5,ffffffe000201228 <switch_to+0xa4>
    {
        struct task_struct *prev = current;
ffffffe0002011ac:	00008797          	auipc	a5,0x8
ffffffe0002011b0:	e6478793          	addi	a5,a5,-412 # ffffffe000209010 <current>
ffffffe0002011b4:	0007b783          	ld	a5,0(a5)
ffffffe0002011b8:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002011bc:	00008797          	auipc	a5,0x8
ffffffe0002011c0:	e5478793          	addi	a5,a5,-428 # ffffffe000209010 <current>
ffffffe0002011c4:	fd843703          	ld	a4,-40(s0)
ffffffe0002011c8:	00e7b023          	sd	a4,0(a5)
        printk("from [%d] switch to [%d]\n", prev->pid, next->pid);
ffffffe0002011cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002011d0:	0187b703          	ld	a4,24(a5)
ffffffe0002011d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002011d8:	0187b783          	ld	a5,24(a5)
ffffffe0002011dc:	00078613          	mv	a2,a5
ffffffe0002011e0:	00070593          	mv	a1,a4
ffffffe0002011e4:	00003517          	auipc	a0,0x3
ffffffe0002011e8:	f2450513          	addi	a0,a0,-220 # ffffffe000204108 <_srodata+0x108>
ffffffe0002011ec:	735010ef          	jal	ra,ffffffe000203120 <printk>
        uint64_t next_satp = get_satp(next->pgd);
ffffffe0002011f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002011f4:	0a87b783          	ld	a5,168(a5)
ffffffe0002011f8:	00078513          	mv	a0,a5
ffffffe0002011fc:	319000ef          	jal	ra,ffffffe000201d14 <get_satp>
ffffffe000201200:	fea43023          	sd	a0,-32(s0)
        __switch_to(&(prev->thread), &(next->thread), next_satp);
ffffffe000201204:	fe843783          	ld	a5,-24(s0)
ffffffe000201208:	02078713          	addi	a4,a5,32
ffffffe00020120c:	fd843783          	ld	a5,-40(s0)
ffffffe000201210:	02078793          	addi	a5,a5,32
ffffffe000201214:	fe043683          	ld	a3,-32(s0)
ffffffe000201218:	00068613          	mv	a2,a3
ffffffe00020121c:	00078593          	mv	a1,a5
ffffffe000201220:	00070513          	mv	a0,a4
ffffffe000201224:	fedfe0ef          	jal	ra,ffffffe000200210 <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
ffffffe000201228:	00000013          	nop
ffffffe00020122c:	02813083          	ld	ra,40(sp)
ffffffe000201230:	02013403          	ld	s0,32(sp)
ffffffe000201234:	03010113          	addi	sp,sp,48
ffffffe000201238:	00008067          	ret

ffffffe00020123c <do_timer>:

void do_timer()
{
ffffffe00020123c:	ff010113          	addi	sp,sp,-16
ffffffe000201240:	00113423          	sd	ra,8(sp)
ffffffe000201244:	00813023          	sd	s0,0(sp)
ffffffe000201248:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0)
ffffffe00020124c:	00008797          	auipc	a5,0x8
ffffffe000201250:	dc478793          	addi	a5,a5,-572 # ffffffe000209010 <current>
ffffffe000201254:	0007b783          	ld	a5,0(a5)
ffffffe000201258:	0187b783          	ld	a5,24(a5)
ffffffe00020125c:	00078c63          	beqz	a5,ffffffe000201274 <do_timer+0x38>
ffffffe000201260:	00008797          	auipc	a5,0x8
ffffffe000201264:	db078793          	addi	a5,a5,-592 # ffffffe000209010 <current>
ffffffe000201268:	0007b783          	ld	a5,0(a5)
ffffffe00020126c:	0087b783          	ld	a5,8(a5)
ffffffe000201270:	00079663          	bnez	a5,ffffffe00020127c <do_timer+0x40>
    {
        schedule();
ffffffe000201274:	050000ef          	jal	ra,ffffffe0002012c4 <schedule>
ffffffe000201278:	03c0006f          	j	ffffffe0002012b4 <do_timer+0x78>
    }
    else
    {
        --(current->counter);
ffffffe00020127c:	00008797          	auipc	a5,0x8
ffffffe000201280:	d9478793          	addi	a5,a5,-620 # ffffffe000209010 <current>
ffffffe000201284:	0007b783          	ld	a5,0(a5)
ffffffe000201288:	0087b703          	ld	a4,8(a5)
ffffffe00020128c:	fff70713          	addi	a4,a4,-1
ffffffe000201290:	00e7b423          	sd	a4,8(a5)
        if (current->counter > 0)
ffffffe000201294:	00008797          	auipc	a5,0x8
ffffffe000201298:	d7c78793          	addi	a5,a5,-644 # ffffffe000209010 <current>
ffffffe00020129c:	0007b783          	ld	a5,0(a5)
ffffffe0002012a0:	0087b783          	ld	a5,8(a5)
ffffffe0002012a4:	00079663          	bnez	a5,ffffffe0002012b0 <do_timer+0x74>
        {
            return;
        }
        schedule();
ffffffe0002012a8:	01c000ef          	jal	ra,ffffffe0002012c4 <schedule>
ffffffe0002012ac:	0080006f          	j	ffffffe0002012b4 <do_timer+0x78>
            return;
ffffffe0002012b0:	00000013          	nop
    }
}
ffffffe0002012b4:	00813083          	ld	ra,8(sp)
ffffffe0002012b8:	00013403          	ld	s0,0(sp)
ffffffe0002012bc:	01010113          	addi	sp,sp,16
ffffffe0002012c0:	00008067          	ret

ffffffe0002012c4 <schedule>:

void schedule()
{
ffffffe0002012c4:	fd010113          	addi	sp,sp,-48
ffffffe0002012c8:	02113423          	sd	ra,40(sp)
ffffffe0002012cc:	02813023          	sd	s0,32(sp)
ffffffe0002012d0:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe0002012d4:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
ffffffe0002012d8:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < NR_TASKS; i++)
ffffffe0002012dc:	00100793          	li	a5,1
ffffffe0002012e0:	fef42023          	sw	a5,-32(s0)
ffffffe0002012e4:	0ac0006f          	j	ffffffe000201390 <schedule+0xcc>
    {
        if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe0002012e8:	00008717          	auipc	a4,0x8
ffffffe0002012ec:	d4870713          	addi	a4,a4,-696 # ffffffe000209030 <task>
ffffffe0002012f0:	fe042783          	lw	a5,-32(s0)
ffffffe0002012f4:	00379793          	slli	a5,a5,0x3
ffffffe0002012f8:	00f707b3          	add	a5,a4,a5
ffffffe0002012fc:	0007b783          	ld	a5,0(a5)
ffffffe000201300:	08078263          	beqz	a5,ffffffe000201384 <schedule+0xc0>
ffffffe000201304:	00008717          	auipc	a4,0x8
ffffffe000201308:	d2c70713          	addi	a4,a4,-724 # ffffffe000209030 <task>
ffffffe00020130c:	fe042783          	lw	a5,-32(s0)
ffffffe000201310:	00379793          	slli	a5,a5,0x3
ffffffe000201314:	00f707b3          	add	a5,a4,a5
ffffffe000201318:	0007b783          	ld	a5,0(a5)
ffffffe00020131c:	0007b783          	ld	a5,0(a5)
ffffffe000201320:	06079263          	bnez	a5,ffffffe000201384 <schedule+0xc0>
        {
            if (task[i]->counter > max_counter)
ffffffe000201324:	00008717          	auipc	a4,0x8
ffffffe000201328:	d0c70713          	addi	a4,a4,-756 # ffffffe000209030 <task>
ffffffe00020132c:	fe042783          	lw	a5,-32(s0)
ffffffe000201330:	00379793          	slli	a5,a5,0x3
ffffffe000201334:	00f707b3          	add	a5,a4,a5
ffffffe000201338:	0007b783          	ld	a5,0(a5)
ffffffe00020133c:	0087b703          	ld	a4,8(a5)
ffffffe000201340:	fe442783          	lw	a5,-28(s0)
ffffffe000201344:	04e7f063          	bgeu	a5,a4,ffffffe000201384 <schedule+0xc0>
            {
                max_counter = task[i]->counter;
ffffffe000201348:	00008717          	auipc	a4,0x8
ffffffe00020134c:	ce870713          	addi	a4,a4,-792 # ffffffe000209030 <task>
ffffffe000201350:	fe042783          	lw	a5,-32(s0)
ffffffe000201354:	00379793          	slli	a5,a5,0x3
ffffffe000201358:	00f707b3          	add	a5,a4,a5
ffffffe00020135c:	0007b783          	ld	a5,0(a5)
ffffffe000201360:	0087b783          	ld	a5,8(a5)
ffffffe000201364:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe000201368:	00008717          	auipc	a4,0x8
ffffffe00020136c:	cc870713          	addi	a4,a4,-824 # ffffffe000209030 <task>
ffffffe000201370:	fe042783          	lw	a5,-32(s0)
ffffffe000201374:	00379793          	slli	a5,a5,0x3
ffffffe000201378:	00f707b3          	add	a5,a4,a5
ffffffe00020137c:	0007b783          	ld	a5,0(a5)
ffffffe000201380:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000201384:	fe042783          	lw	a5,-32(s0)
ffffffe000201388:	0017879b          	addiw	a5,a5,1
ffffffe00020138c:	fef42023          	sw	a5,-32(s0)
ffffffe000201390:	fe042783          	lw	a5,-32(s0)
ffffffe000201394:	0007871b          	sext.w	a4,a5
ffffffe000201398:	00400793          	li	a5,4
ffffffe00020139c:	f4e7d6e3          	bge	a5,a4,ffffffe0002012e8 <schedule+0x24>
            }
        }
    }

    if (max_counter == 0)
ffffffe0002013a0:	fe442783          	lw	a5,-28(s0)
ffffffe0002013a4:	0007879b          	sext.w	a5,a5
ffffffe0002013a8:	0a079263          	bnez	a5,ffffffe00020144c <schedule+0x188>
    {
        for (int i = 0; i < NR_TASKS; i++)
ffffffe0002013ac:	fc042e23          	sw	zero,-36(s0)
ffffffe0002013b0:	0840006f          	j	ffffffe000201434 <schedule+0x170>
        {
            if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe0002013b4:	00008717          	auipc	a4,0x8
ffffffe0002013b8:	c7c70713          	addi	a4,a4,-900 # ffffffe000209030 <task>
ffffffe0002013bc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013c0:	00379793          	slli	a5,a5,0x3
ffffffe0002013c4:	00f707b3          	add	a5,a4,a5
ffffffe0002013c8:	0007b783          	ld	a5,0(a5)
ffffffe0002013cc:	04078e63          	beqz	a5,ffffffe000201428 <schedule+0x164>
ffffffe0002013d0:	00008717          	auipc	a4,0x8
ffffffe0002013d4:	c6070713          	addi	a4,a4,-928 # ffffffe000209030 <task>
ffffffe0002013d8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013dc:	00379793          	slli	a5,a5,0x3
ffffffe0002013e0:	00f707b3          	add	a5,a4,a5
ffffffe0002013e4:	0007b783          	ld	a5,0(a5)
ffffffe0002013e8:	0007b783          	ld	a5,0(a5)
ffffffe0002013ec:	02079e63          	bnez	a5,ffffffe000201428 <schedule+0x164>
            {
                task[i]->counter = task[i]->priority;
ffffffe0002013f0:	00008717          	auipc	a4,0x8
ffffffe0002013f4:	c4070713          	addi	a4,a4,-960 # ffffffe000209030 <task>
ffffffe0002013f8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013fc:	00379793          	slli	a5,a5,0x3
ffffffe000201400:	00f707b3          	add	a5,a4,a5
ffffffe000201404:	0007b703          	ld	a4,0(a5)
ffffffe000201408:	00008697          	auipc	a3,0x8
ffffffe00020140c:	c2868693          	addi	a3,a3,-984 # ffffffe000209030 <task>
ffffffe000201410:	fdc42783          	lw	a5,-36(s0)
ffffffe000201414:	00379793          	slli	a5,a5,0x3
ffffffe000201418:	00f687b3          	add	a5,a3,a5
ffffffe00020141c:	0007b783          	ld	a5,0(a5)
ffffffe000201420:	01073703          	ld	a4,16(a4)
ffffffe000201424:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < NR_TASKS; i++)
ffffffe000201428:	fdc42783          	lw	a5,-36(s0)
ffffffe00020142c:	0017879b          	addiw	a5,a5,1
ffffffe000201430:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201434:	fdc42783          	lw	a5,-36(s0)
ffffffe000201438:	0007871b          	sext.w	a4,a5
ffffffe00020143c:	00400793          	li	a5,4
ffffffe000201440:	f6e7dae3          	bge	a5,a4,ffffffe0002013b4 <schedule+0xf0>
            }
        }
        schedule();
ffffffe000201444:	e81ff0ef          	jal	ra,ffffffe0002012c4 <schedule>
        return;
ffffffe000201448:	0280006f          	j	ffffffe000201470 <schedule+0x1ac>
    }

    if (next && next != current)
ffffffe00020144c:	fe843783          	ld	a5,-24(s0)
ffffffe000201450:	02078063          	beqz	a5,ffffffe000201470 <schedule+0x1ac>
ffffffe000201454:	00008797          	auipc	a5,0x8
ffffffe000201458:	bbc78793          	addi	a5,a5,-1092 # ffffffe000209010 <current>
ffffffe00020145c:	0007b783          	ld	a5,0(a5)
ffffffe000201460:	fe843703          	ld	a4,-24(s0)
ffffffe000201464:	00f70663          	beq	a4,a5,ffffffe000201470 <schedule+0x1ac>
    {
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
ffffffe000201468:	fe843503          	ld	a0,-24(s0)
ffffffe00020146c:	d19ff0ef          	jal	ra,ffffffe000201184 <switch_to>
    }
}
ffffffe000201470:	02813083          	ld	ra,40(sp)
ffffffe000201474:	02013403          	ld	s0,32(sp)
ffffffe000201478:	03010113          	addi	sp,sp,48
ffffffe00020147c:	00008067          	ret

ffffffe000201480 <dummy>:
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy()
{
ffffffe000201480:	fd010113          	addi	sp,sp,-48
ffffffe000201484:	02113423          	sd	ra,40(sp)
ffffffe000201488:	02813023          	sd	s0,32(sp)
ffffffe00020148c:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000201490:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000201494:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000201498:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe00020149c:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe0002014a0:	fff00793          	li	a5,-1
ffffffe0002014a4:	fef42223          	sw	a5,-28(s0)
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe0002014a8:	fe442783          	lw	a5,-28(s0)
ffffffe0002014ac:	0007871b          	sext.w	a4,a5
ffffffe0002014b0:	fff00793          	li	a5,-1
ffffffe0002014b4:	00f70e63          	beq	a4,a5,ffffffe0002014d0 <dummy+0x50>
ffffffe0002014b8:	00008797          	auipc	a5,0x8
ffffffe0002014bc:	b5878793          	addi	a5,a5,-1192 # ffffffe000209010 <current>
ffffffe0002014c0:	0007b783          	ld	a5,0(a5)
ffffffe0002014c4:	0087b703          	ld	a4,8(a5)
ffffffe0002014c8:	fe442783          	lw	a5,-28(s0)
ffffffe0002014cc:	fcf70ee3          	beq	a4,a5,ffffffe0002014a8 <dummy+0x28>
ffffffe0002014d0:	00008797          	auipc	a5,0x8
ffffffe0002014d4:	b4078793          	addi	a5,a5,-1216 # ffffffe000209010 <current>
ffffffe0002014d8:	0007b783          	ld	a5,0(a5)
ffffffe0002014dc:	0087b783          	ld	a5,8(a5)
ffffffe0002014e0:	fc0784e3          	beqz	a5,ffffffe0002014a8 <dummy+0x28>
        {
            if (current->counter == 1)
ffffffe0002014e4:	00008797          	auipc	a5,0x8
ffffffe0002014e8:	b2c78793          	addi	a5,a5,-1236 # ffffffe000209010 <current>
ffffffe0002014ec:	0007b783          	ld	a5,0(a5)
ffffffe0002014f0:	0087b703          	ld	a4,8(a5)
ffffffe0002014f4:	00100793          	li	a5,1
ffffffe0002014f8:	00f71e63          	bne	a4,a5,ffffffe000201514 <dummy+0x94>
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002014fc:	00008797          	auipc	a5,0x8
ffffffe000201500:	b1478793          	addi	a5,a5,-1260 # ffffffe000209010 <current>
ffffffe000201504:	0007b783          	ld	a5,0(a5)
ffffffe000201508:	0087b703          	ld	a4,8(a5)
ffffffe00020150c:	fff70713          	addi	a4,a4,-1
ffffffe000201510:	00e7b423          	sd	a4,8(a5)
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe000201514:	00008797          	auipc	a5,0x8
ffffffe000201518:	afc78793          	addi	a5,a5,-1284 # ffffffe000209010 <current>
ffffffe00020151c:	0007b783          	ld	a5,0(a5)
ffffffe000201520:	0087b783          	ld	a5,8(a5)
ffffffe000201524:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000201528:	fe843783          	ld	a5,-24(s0)
ffffffe00020152c:	00178713          	addi	a4,a5,1
ffffffe000201530:	fd843783          	ld	a5,-40(s0)
ffffffe000201534:	02f777b3          	remu	a5,a4,a5
ffffffe000201538:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe00020153c:	00008797          	auipc	a5,0x8
ffffffe000201540:	ad478793          	addi	a5,a5,-1324 # ffffffe000209010 <current>
ffffffe000201544:	0007b783          	ld	a5,0(a5)
ffffffe000201548:	0187b783          	ld	a5,24(a5)
ffffffe00020154c:	fe843603          	ld	a2,-24(s0)
ffffffe000201550:	00078593          	mv	a1,a5
ffffffe000201554:	00003517          	auipc	a0,0x3
ffffffe000201558:	bd450513          	addi	a0,a0,-1068 # ffffffe000204128 <_srodata+0x128>
ffffffe00020155c:	3c5010ef          	jal	ra,ffffffe000203120 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201560:	f49ff06f          	j	ffffffe0002014a8 <dummy+0x28>

ffffffe000201564 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000201564:	f8010113          	addi	sp,sp,-128
ffffffe000201568:	06813c23          	sd	s0,120(sp)
ffffffe00020156c:	06913823          	sd	s1,112(sp)
ffffffe000201570:	07213423          	sd	s2,104(sp)
ffffffe000201574:	07313023          	sd	s3,96(sp)
ffffffe000201578:	08010413          	addi	s0,sp,128
ffffffe00020157c:	faa43c23          	sd	a0,-72(s0)
ffffffe000201580:	fab43823          	sd	a1,-80(s0)
ffffffe000201584:	fac43423          	sd	a2,-88(s0)
ffffffe000201588:	fad43023          	sd	a3,-96(s0)
ffffffe00020158c:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201590:	f8f43823          	sd	a5,-112(s0)
ffffffe000201594:	f9043423          	sd	a6,-120(s0)
ffffffe000201598:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe00020159c:	fb843e03          	ld	t3,-72(s0)
ffffffe0002015a0:	fb043e83          	ld	t4,-80(s0)
ffffffe0002015a4:	fa843f03          	ld	t5,-88(s0)
ffffffe0002015a8:	fa043f83          	ld	t6,-96(s0)
ffffffe0002015ac:	f9843283          	ld	t0,-104(s0)
ffffffe0002015b0:	f9043483          	ld	s1,-112(s0)
ffffffe0002015b4:	f8843903          	ld	s2,-120(s0)
ffffffe0002015b8:	f8043983          	ld	s3,-128(s0)
ffffffe0002015bc:	000e0893          	mv	a7,t3
ffffffe0002015c0:	000e8813          	mv	a6,t4
ffffffe0002015c4:	000f0513          	mv	a0,t5
ffffffe0002015c8:	000f8593          	mv	a1,t6
ffffffe0002015cc:	00028613          	mv	a2,t0
ffffffe0002015d0:	00048693          	mv	a3,s1
ffffffe0002015d4:	00090713          	mv	a4,s2
ffffffe0002015d8:	00098793          	mv	a5,s3
ffffffe0002015dc:	00000073          	ecall
ffffffe0002015e0:	00050e93          	mv	t4,a0
ffffffe0002015e4:	00058e13          	mv	t3,a1
ffffffe0002015e8:	fdd43023          	sd	t4,-64(s0)
ffffffe0002015ec:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe0002015f0:	fc043783          	ld	a5,-64(s0)
ffffffe0002015f4:	fcf43823          	sd	a5,-48(s0)
ffffffe0002015f8:	fc843783          	ld	a5,-56(s0)
ffffffe0002015fc:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201600:	fd043703          	ld	a4,-48(s0)
ffffffe000201604:	fd843783          	ld	a5,-40(s0)
ffffffe000201608:	00070313          	mv	t1,a4
ffffffe00020160c:	00078393          	mv	t2,a5
ffffffe000201610:	00030713          	mv	a4,t1
ffffffe000201614:	00038793          	mv	a5,t2
}
ffffffe000201618:	00070513          	mv	a0,a4
ffffffe00020161c:	00078593          	mv	a1,a5
ffffffe000201620:	07813403          	ld	s0,120(sp)
ffffffe000201624:	07013483          	ld	s1,112(sp)
ffffffe000201628:	06813903          	ld	s2,104(sp)
ffffffe00020162c:	06013983          	ld	s3,96(sp)
ffffffe000201630:	08010113          	addi	sp,sp,128
ffffffe000201634:	00008067          	ret

ffffffe000201638 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000201638:	fd010113          	addi	sp,sp,-48
ffffffe00020163c:	02813423          	sd	s0,40(sp)
ffffffe000201640:	03010413          	addi	s0,sp,48
ffffffe000201644:	00050793          	mv	a5,a0
ffffffe000201648:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe00020164c:	00100793          	li	a5,1
ffffffe000201650:	00000713          	li	a4,0
ffffffe000201654:	fdf44683          	lbu	a3,-33(s0)
ffffffe000201658:	00078893          	mv	a7,a5
ffffffe00020165c:	00070813          	mv	a6,a4
ffffffe000201660:	00068513          	mv	a0,a3
ffffffe000201664:	00000073          	ecall
ffffffe000201668:	00050713          	mv	a4,a0
ffffffe00020166c:	00058793          	mv	a5,a1
ffffffe000201670:	fee43023          	sd	a4,-32(s0)
ffffffe000201674:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe000201678:	00000013          	nop
ffffffe00020167c:	00070513          	mv	a0,a4
ffffffe000201680:	00078593          	mv	a1,a5
ffffffe000201684:	02813403          	ld	s0,40(sp)
ffffffe000201688:	03010113          	addi	sp,sp,48
ffffffe00020168c:	00008067          	ret

ffffffe000201690 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000201690:	fc010113          	addi	sp,sp,-64
ffffffe000201694:	02813c23          	sd	s0,56(sp)
ffffffe000201698:	04010413          	addi	s0,sp,64
ffffffe00020169c:	00050793          	mv	a5,a0
ffffffe0002016a0:	00058713          	mv	a4,a1
ffffffe0002016a4:	fcf42623          	sw	a5,-52(s0)
ffffffe0002016a8:	00070793          	mv	a5,a4
ffffffe0002016ac:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe0002016b0:	00800793          	li	a5,8
ffffffe0002016b4:	00000713          	li	a4,0
ffffffe0002016b8:	fcc42583          	lw	a1,-52(s0)
ffffffe0002016bc:	00058313          	mv	t1,a1
ffffffe0002016c0:	fc842583          	lw	a1,-56(s0)
ffffffe0002016c4:	00058e13          	mv	t3,a1
ffffffe0002016c8:	00078893          	mv	a7,a5
ffffffe0002016cc:	00070813          	mv	a6,a4
ffffffe0002016d0:	00030513          	mv	a0,t1
ffffffe0002016d4:	000e0593          	mv	a1,t3
ffffffe0002016d8:	00000073          	ecall
ffffffe0002016dc:	00050713          	mv	a4,a0
ffffffe0002016e0:	00058793          	mv	a5,a1
ffffffe0002016e4:	fce43823          	sd	a4,-48(s0)
ffffffe0002016e8:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe0002016ec:	fd043783          	ld	a5,-48(s0)
ffffffe0002016f0:	fef43023          	sd	a5,-32(s0)
ffffffe0002016f4:	fd843783          	ld	a5,-40(s0)
ffffffe0002016f8:	fef43423          	sd	a5,-24(s0)
ffffffe0002016fc:	fe043703          	ld	a4,-32(s0)
ffffffe000201700:	fe843783          	ld	a5,-24(s0)
ffffffe000201704:	00070613          	mv	a2,a4
ffffffe000201708:	00078693          	mv	a3,a5
ffffffe00020170c:	00060713          	mv	a4,a2
ffffffe000201710:	00068793          	mv	a5,a3
ffffffe000201714:	00070513          	mv	a0,a4
ffffffe000201718:	00078593          	mv	a1,a5
ffffffe00020171c:	03813403          	ld	s0,56(sp)
ffffffe000201720:	04010113          	addi	sp,sp,64
ffffffe000201724:	00008067          	ret

ffffffe000201728 <sys_write>:
#include "syscall.h"

extern struct task_struct *get_current_proc();

int sys_write(unsigned int fd, const char* buf, unsigned int size) {
ffffffe000201728:	fd010113          	addi	sp,sp,-48
ffffffe00020172c:	02113423          	sd	ra,40(sp)
ffffffe000201730:	02813023          	sd	s0,32(sp)
ffffffe000201734:	03010413          	addi	s0,sp,48
ffffffe000201738:	00050793          	mv	a5,a0
ffffffe00020173c:	fcb43823          	sd	a1,-48(s0)
ffffffe000201740:	00060713          	mv	a4,a2
ffffffe000201744:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201748:	00070793          	mv	a5,a4
ffffffe00020174c:	fcf42c23          	sw	a5,-40(s0)
    int cnt = 0;
ffffffe000201750:	fe042623          	sw	zero,-20(s0)
    if (fd == STDOUT) {
ffffffe000201754:	fdc42783          	lw	a5,-36(s0)
ffffffe000201758:	0007871b          	sext.w	a4,a5
ffffffe00020175c:	00100793          	li	a5,1
ffffffe000201760:	06f71063          	bne	a4,a5,ffffffe0002017c0 <sys_write+0x98>
        for (cnt = 0; cnt < size && buf[cnt]; ++cnt) putc(buf[cnt]);
ffffffe000201764:	fe042623          	sw	zero,-20(s0)
ffffffe000201768:	02c0006f          	j	ffffffe000201794 <sys_write+0x6c>
ffffffe00020176c:	fec42783          	lw	a5,-20(s0)
ffffffe000201770:	fd043703          	ld	a4,-48(s0)
ffffffe000201774:	00f707b3          	add	a5,a4,a5
ffffffe000201778:	0007c783          	lbu	a5,0(a5)
ffffffe00020177c:	0007879b          	sext.w	a5,a5
ffffffe000201780:	00078513          	mv	a0,a5
ffffffe000201784:	309000ef          	jal	ra,ffffffe00020228c <putc>
ffffffe000201788:	fec42783          	lw	a5,-20(s0)
ffffffe00020178c:	0017879b          	addiw	a5,a5,1
ffffffe000201790:	fef42623          	sw	a5,-20(s0)
ffffffe000201794:	fec42703          	lw	a4,-20(s0)
ffffffe000201798:	fd842783          	lw	a5,-40(s0)
ffffffe00020179c:	0007879b          	sext.w	a5,a5
ffffffe0002017a0:	00f77c63          	bgeu	a4,a5,ffffffe0002017b8 <sys_write+0x90>
ffffffe0002017a4:	fec42783          	lw	a5,-20(s0)
ffffffe0002017a8:	fd043703          	ld	a4,-48(s0)
ffffffe0002017ac:	00f707b3          	add	a5,a4,a5
ffffffe0002017b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002017b4:	fa079ce3          	bnez	a5,ffffffe00020176c <sys_write+0x44>
        return cnt;
ffffffe0002017b8:	fec42783          	lw	a5,-20(s0)
ffffffe0002017bc:	0080006f          	j	ffffffe0002017c4 <sys_write+0x9c>
    }
    return -1;
ffffffe0002017c0:	fff00793          	li	a5,-1
}
ffffffe0002017c4:	00078513          	mv	a0,a5
ffffffe0002017c8:	02813083          	ld	ra,40(sp)
ffffffe0002017cc:	02013403          	ld	s0,32(sp)
ffffffe0002017d0:	03010113          	addi	sp,sp,48
ffffffe0002017d4:	00008067          	ret

ffffffe0002017d8 <sys_getpid>:

int sys_getpid(){
ffffffe0002017d8:	fe010113          	addi	sp,sp,-32
ffffffe0002017dc:	00113c23          	sd	ra,24(sp)
ffffffe0002017e0:	00813823          	sd	s0,16(sp)
ffffffe0002017e4:	02010413          	addi	s0,sp,32
    struct task_struct *current = get_current_proc();
ffffffe0002017e8:	b10ff0ef          	jal	ra,ffffffe000200af8 <get_current_proc>
ffffffe0002017ec:	fea43423          	sd	a0,-24(s0)
    return current->pid;
ffffffe0002017f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002017f4:	0187b783          	ld	a5,24(a5)
ffffffe0002017f8:	0007879b          	sext.w	a5,a5
ffffffe0002017fc:	00078513          	mv	a0,a5
ffffffe000201800:	01813083          	ld	ra,24(sp)
ffffffe000201804:	01013403          	ld	s0,16(sp)
ffffffe000201808:	02010113          	addi	sp,sp,32
ffffffe00020180c:	00008067          	ret

ffffffe000201810 <trap_handler>:
extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc,struct pt_regs *regs) {
ffffffe000201810:	f9010113          	addi	sp,sp,-112
ffffffe000201814:	06113423          	sd	ra,104(sp)
ffffffe000201818:	06813023          	sd	s0,96(sp)
ffffffe00020181c:	07010413          	addi	s0,sp,112
ffffffe000201820:	faa43423          	sd	a0,-88(s0)
ffffffe000201824:	fab43023          	sd	a1,-96(s0)
ffffffe000201828:	f8c43c23          	sd	a2,-104(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
ffffffe00020182c:	fa843783          	ld	a5,-88(s0)
ffffffe000201830:	0407d063          	bgez	a5,ffffffe000201870 <trap_handler+0x60>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe000201834:	fa843783          	ld	a5,-88(s0)
ffffffe000201838:	0ff7f793          	zext.b	a5,a5
ffffffe00020183c:	faf43c23          	sd	a5,-72(s0)
        if (interrupt_t == 0x5) {
ffffffe000201840:	fb843703          	ld	a4,-72(s0)
ffffffe000201844:	00500793          	li	a5,5
ffffffe000201848:	00f71863          	bne	a4,a5,ffffffe000201858 <trap_handler+0x48>
            // timer interrupt
            // printk("timer interrupt, time = %ld\n", get_cycles());
            clock_set_next_event();
ffffffe00020184c:	ac9fe0ef          	jal	ra,ffffffe000200314 <clock_set_next_event>
            do_timer();
ffffffe000201850:	9edff0ef          	jal	ra,ffffffe00020123c <do_timer>
ffffffe000201854:	0f80006f          	j	ffffffe00020194c <trap_handler+0x13c>
        } else{
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000201858:	fa043603          	ld	a2,-96(s0)
ffffffe00020185c:	fa843583          	ld	a1,-88(s0)
ffffffe000201860:	00003517          	auipc	a0,0x3
ffffffe000201864:	8f850513          	addi	a0,a0,-1800 # ffffffe000204158 <_srodata+0x158>
ffffffe000201868:	0b9010ef          	jal	ra,ffffffe000203120 <printk>
ffffffe00020186c:	0e00006f          	j	ffffffe00020194c <trap_handler+0x13c>
        }
    }
    else {
        // exception
        if(scause == ECALL_FROM_U_MODE) {
ffffffe000201870:	fa843703          	ld	a4,-88(s0)
ffffffe000201874:	00800793          	li	a5,8
ffffffe000201878:	0cf71a63          	bne	a4,a5,ffffffe00020194c <trap_handler+0x13c>
            uint64_t syscall_id = regs->a[7];
ffffffe00020187c:	f9843783          	ld	a5,-104(s0)
ffffffe000201880:	0787b783          	ld	a5,120(a5)
ffffffe000201884:	fef43423          	sd	a5,-24(s0)
            printk("[trap_handler] ecall from user mode, syscall_id = %ld\n", syscall_id);
ffffffe000201888:	fe843583          	ld	a1,-24(s0)
ffffffe00020188c:	00003517          	auipc	a0,0x3
ffffffe000201890:	8fc50513          	addi	a0,a0,-1796 # ffffffe000204188 <_srodata+0x188>
ffffffe000201894:	08d010ef          	jal	ra,ffffffe000203120 <printk>
            if(syscall_id == SYS_WRITE){
ffffffe000201898:	fe843703          	ld	a4,-24(s0)
ffffffe00020189c:	04000793          	li	a5,64
ffffffe0002018a0:	04f71e63          	bne	a4,a5,ffffffe0002018fc <trap_handler+0xec>
                unsigned int fd = (unsigned int)regs->a[0];
ffffffe0002018a4:	f9843783          	ld	a5,-104(s0)
ffffffe0002018a8:	0407b783          	ld	a5,64(a5)
ffffffe0002018ac:	fcf42e23          	sw	a5,-36(s0)
                const char *buf = (const char *)regs->a[1];
ffffffe0002018b0:	f9843783          	ld	a5,-104(s0)
ffffffe0002018b4:	0487b783          	ld	a5,72(a5)
ffffffe0002018b8:	fcf43823          	sd	a5,-48(s0)
                size_t count = (size_t)regs->a[2];
ffffffe0002018bc:	f9843783          	ld	a5,-104(s0)
ffffffe0002018c0:	0507b783          	ld	a5,80(a5)
ffffffe0002018c4:	fcf43423          	sd	a5,-56(s0)
                uint64_t ret = sys_write(fd, buf, count);
ffffffe0002018c8:	fc843783          	ld	a5,-56(s0)
ffffffe0002018cc:	0007871b          	sext.w	a4,a5
ffffffe0002018d0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002018d4:	00070613          	mv	a2,a4
ffffffe0002018d8:	fd043583          	ld	a1,-48(s0)
ffffffe0002018dc:	00078513          	mv	a0,a5
ffffffe0002018e0:	e49ff0ef          	jal	ra,ffffffe000201728 <sys_write>
ffffffe0002018e4:	00050793          	mv	a5,a0
ffffffe0002018e8:	fcf43023          	sd	a5,-64(s0)
                regs->a[0] = ret;
ffffffe0002018ec:	f9843783          	ld	a5,-104(s0)
ffffffe0002018f0:	fc043703          	ld	a4,-64(s0)
ffffffe0002018f4:	04e7b023          	sd	a4,64(a5)
ffffffe0002018f8:	03c0006f          	j	ffffffe000201934 <trap_handler+0x124>
            } else if (syscall_id == SYS_GETPID){
ffffffe0002018fc:	fe843703          	ld	a4,-24(s0)
ffffffe000201900:	0ac00793          	li	a5,172
ffffffe000201904:	02f71063          	bne	a4,a5,ffffffe000201924 <trap_handler+0x114>
                uint64_t pid = sys_getpid();
ffffffe000201908:	ed1ff0ef          	jal	ra,ffffffe0002017d8 <sys_getpid>
ffffffe00020190c:	00050793          	mv	a5,a0
ffffffe000201910:	fef43023          	sd	a5,-32(s0)
                regs->a[0] = pid;
ffffffe000201914:	f9843783          	ld	a5,-104(s0)
ffffffe000201918:	fe043703          	ld	a4,-32(s0)
ffffffe00020191c:	04e7b023          	sd	a4,64(a5)
ffffffe000201920:	0140006f          	j	ffffffe000201934 <trap_handler+0x124>
            } else {
                printk("unimplemented syscall_id: %ld\n", syscall_id);
ffffffe000201924:	fe843583          	ld	a1,-24(s0)
ffffffe000201928:	00003517          	auipc	a0,0x3
ffffffe00020192c:	89850513          	addi	a0,a0,-1896 # ffffffe0002041c0 <_srodata+0x1c0>
ffffffe000201930:	7f0010ef          	jal	ra,ffffffe000203120 <printk>
            }
            regs->sepc += 4;
ffffffe000201934:	f9843783          	ld	a5,-104(s0)
ffffffe000201938:	0f07b783          	ld	a5,240(a5)
ffffffe00020193c:	00478713          	addi	a4,a5,4
ffffffe000201940:	f9843783          	ld	a5,-104(s0)
ffffffe000201944:	0ee7b823          	sd	a4,240(a5)
            return;
ffffffe000201948:	00000013          	nop
        }
    }
ffffffe00020194c:	06813083          	ld	ra,104(sp)
ffffffe000201950:	06013403          	ld	s0,96(sp)
ffffffe000201954:	07010113          	addi	sp,sp,112
ffffffe000201958:	00008067          	ret

ffffffe00020195c <setup_vm>:
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe00020195c:	fe010113          	addi	sp,sp,-32
ffffffe000201960:	00113c23          	sd	ra,24(sp)
ffffffe000201964:	00813823          	sd	s0,16(sp)
ffffffe000201968:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe00020196c:	00001637          	lui	a2,0x1
ffffffe000201970:	00000593          	li	a1,0
ffffffe000201974:	00008517          	auipc	a0,0x8
ffffffe000201978:	68c50513          	addi	a0,a0,1676 # ffffffe00020a000 <early_pgtbl>
ffffffe00020197c:	0c5010ef          	jal	ra,ffffffe000203240 <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000201980:	00f00793          	li	a5,15
ffffffe000201984:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000201988:	fe043423          	sd	zero,-24(s0)
ffffffe00020198c:	0740006f          	j	ffffffe000201a00 <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000201990:	fe843703          	ld	a4,-24(s0)
ffffffe000201994:	fff00793          	li	a5,-1
ffffffe000201998:	02579793          	slli	a5,a5,0x25
ffffffe00020199c:	00f706b3          	add	a3,a4,a5
ffffffe0002019a0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019a4:	00100793          	li	a5,1
ffffffe0002019a8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002019ac:	00f707b3          	add	a5,a4,a5
ffffffe0002019b0:	fe043603          	ld	a2,-32(s0)
ffffffe0002019b4:	00078593          	mv	a1,a5
ffffffe0002019b8:	00068513          	mv	a0,a3
ffffffe0002019bc:	074000ef          	jal	ra,ffffffe000201a30 <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe0002019c0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019c4:	00100793          	li	a5,1
ffffffe0002019c8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002019cc:	00f706b3          	add	a3,a4,a5
ffffffe0002019d0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019d4:	00100793          	li	a5,1
ffffffe0002019d8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002019dc:	00f707b3          	add	a5,a4,a5
ffffffe0002019e0:	fe043603          	ld	a2,-32(s0)
ffffffe0002019e4:	00078593          	mv	a1,a5
ffffffe0002019e8:	00068513          	mv	a0,a3
ffffffe0002019ec:	044000ef          	jal	ra,ffffffe000201a30 <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe0002019f0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019f4:	400007b7          	lui	a5,0x40000
ffffffe0002019f8:	00f707b3          	add	a5,a4,a5
ffffffe0002019fc:	fef43423          	sd	a5,-24(s0)
ffffffe000201a00:	fe843703          	ld	a4,-24(s0)
ffffffe000201a04:	01f00793          	li	a5,31
ffffffe000201a08:	02079793          	slli	a5,a5,0x20
ffffffe000201a0c:	f8f762e3          	bltu	a4,a5,ffffffe000201990 <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe000201a10:	00002517          	auipc	a0,0x2
ffffffe000201a14:	7d050513          	addi	a0,a0,2000 # ffffffe0002041e0 <_srodata+0x1e0>
ffffffe000201a18:	708010ef          	jal	ra,ffffffe000203120 <printk>
    return;
ffffffe000201a1c:	00000013          	nop
}
ffffffe000201a20:	01813083          	ld	ra,24(sp)
ffffffe000201a24:	01013403          	ld	s0,16(sp)
ffffffe000201a28:	02010113          	addi	sp,sp,32
ffffffe000201a2c:	00008067          	ret

ffffffe000201a30 <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201a30:	fc010113          	addi	sp,sp,-64
ffffffe000201a34:	02813c23          	sd	s0,56(sp)
ffffffe000201a38:	04010413          	addi	s0,sp,64
ffffffe000201a3c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201a40:	fcb43823          	sd	a1,-48(s0)
ffffffe000201a44:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000201a48:	fd843783          	ld	a5,-40(s0)
ffffffe000201a4c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201a50:	1ff7f793          	andi	a5,a5,511
ffffffe000201a54:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000201a58:	fd043783          	ld	a5,-48(s0)
ffffffe000201a5c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201a60:	00a79793          	slli	a5,a5,0xa
ffffffe000201a64:	fc843703          	ld	a4,-56(s0)
ffffffe000201a68:	00f767b3          	or	a5,a4,a5
ffffffe000201a6c:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000201a70:	00008717          	auipc	a4,0x8
ffffffe000201a74:	59070713          	addi	a4,a4,1424 # ffffffe00020a000 <early_pgtbl>
ffffffe000201a78:	fe843783          	ld	a5,-24(s0)
ffffffe000201a7c:	00379793          	slli	a5,a5,0x3
ffffffe000201a80:	00f707b3          	add	a5,a4,a5
ffffffe000201a84:	fe043703          	ld	a4,-32(s0)
ffffffe000201a88:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe000201a8c:	00000013          	nop
ffffffe000201a90:	03813403          	ld	s0,56(sp)
ffffffe000201a94:	04010113          	addi	sp,sp,64
ffffffe000201a98:	00008067          	ret

ffffffe000201a9c <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe000201a9c:	fc010113          	addi	sp,sp,-64
ffffffe000201aa0:	02113c23          	sd	ra,56(sp)
ffffffe000201aa4:	02813823          	sd	s0,48(sp)
ffffffe000201aa8:	04010413          	addi	s0,sp,64
ffffffe000201aac:	fca43c23          	sd	a0,-40(s0)
ffffffe000201ab0:	fcb43823          	sd	a1,-48(s0)
ffffffe000201ab4:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000201ab8:	f35fe0ef          	jal	ra,ffffffe0002009ec <kalloc>
ffffffe000201abc:	00050793          	mv	a5,a0
ffffffe000201ac0:	00078713          	mv	a4,a5
ffffffe000201ac4:	04100793          	li	a5,65
ffffffe000201ac8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201acc:	00f707b3          	add	a5,a4,a5
ffffffe000201ad0:	fef43423          	sd	a5,-24(s0)
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000201ad4:	fe843783          	ld	a5,-24(s0)
ffffffe000201ad8:	00c7d793          	srli	a5,a5,0xc
ffffffe000201adc:	00a79693          	slli	a3,a5,0xa
ffffffe000201ae0:	fd043783          	ld	a5,-48(s0)
ffffffe000201ae4:	00379793          	slli	a5,a5,0x3
ffffffe000201ae8:	fd843703          	ld	a4,-40(s0)
ffffffe000201aec:	00f707b3          	add	a5,a4,a5
ffffffe000201af0:	fc843703          	ld	a4,-56(s0)
ffffffe000201af4:	00e6e733          	or	a4,a3,a4
ffffffe000201af8:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe000201afc:	fd043783          	ld	a5,-48(s0)
ffffffe000201b00:	00379793          	slli	a5,a5,0x3
ffffffe000201b04:	fd843703          	ld	a4,-40(s0)
ffffffe000201b08:	00f707b3          	add	a5,a4,a5
ffffffe000201b0c:	0007b783          	ld	a5,0(a5)
}
ffffffe000201b10:	00078513          	mv	a0,a5
ffffffe000201b14:	03813083          	ld	ra,56(sp)
ffffffe000201b18:	03013403          	ld	s0,48(sp)
ffffffe000201b1c:	04010113          	addi	sp,sp,64
ffffffe000201b20:	00008067          	ret

ffffffe000201b24 <setup_vm_final>:

void setup_vm_final() {
ffffffe000201b24:	f9010113          	addi	sp,sp,-112
ffffffe000201b28:	06113423          	sd	ra,104(sp)
ffffffe000201b2c:	06813023          	sd	s0,96(sp)
ffffffe000201b30:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe000201b34:	00002517          	auipc	a0,0x2
ffffffe000201b38:	6c450513          	addi	a0,a0,1732 # ffffffe0002041f8 <_srodata+0x1f8>
ffffffe000201b3c:	5e4010ef          	jal	ra,ffffffe000203120 <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000201b40:	00001637          	lui	a2,0x1
ffffffe000201b44:	00000593          	li	a1,0
ffffffe000201b48:	00009517          	auipc	a0,0x9
ffffffe000201b4c:	4b850513          	addi	a0,a0,1208 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201b50:	6f0010ef          	jal	ra,ffffffe000203240 <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000201b54:	40100793          	li	a5,1025
ffffffe000201b58:	01579793          	slli	a5,a5,0x15
ffffffe000201b5c:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000201b60:	f00017b7          	lui	a5,0xf0001
ffffffe000201b64:	00979793          	slli	a5,a5,0x9
ffffffe000201b68:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe000201b6c:	01100793          	li	a5,17
ffffffe000201b70:	01b79793          	slli	a5,a5,0x1b
ffffffe000201b74:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000201b78:	c0100793          	li	a5,-1023
ffffffe000201b7c:	01b79793          	slli	a5,a5,0x1b
ffffffe000201b80:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000201b84:	fe043783          	ld	a5,-32(s0)
ffffffe000201b88:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe000201b8c:	00001717          	auipc	a4,0x1
ffffffe000201b90:	7a070713          	addi	a4,a4,1952 # ffffffe00020332c <_etext>
ffffffe000201b94:	000017b7          	lui	a5,0x1
ffffffe000201b98:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201b9c:	00f70733          	add	a4,a4,a5
ffffffe000201ba0:	fffff7b7          	lui	a5,0xfffff
ffffffe000201ba4:	00f777b3          	and	a5,a4,a5
ffffffe000201ba8:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe000201bac:	fc843703          	ld	a4,-56(s0)
ffffffe000201bb0:	04100793          	li	a5,65
ffffffe000201bb4:	01f79793          	slli	a5,a5,0x1f
ffffffe000201bb8:	00f70633          	add	a2,a4,a5
ffffffe000201bbc:	fc043703          	ld	a4,-64(s0)
ffffffe000201bc0:	fc843783          	ld	a5,-56(s0)
ffffffe000201bc4:	40f707b3          	sub	a5,a4,a5
ffffffe000201bc8:	00b00713          	li	a4,11
ffffffe000201bcc:	00078693          	mv	a3,a5
ffffffe000201bd0:	fc843583          	ld	a1,-56(s0)
ffffffe000201bd4:	00009517          	auipc	a0,0x9
ffffffe000201bd8:	42c50513          	addi	a0,a0,1068 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201bdc:	180000ef          	jal	ra,ffffffe000201d5c <create_mapping>
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);
ffffffe000201be0:	00b00693          	li	a3,11
ffffffe000201be4:	fc043603          	ld	a2,-64(s0)
ffffffe000201be8:	fc843583          	ld	a1,-56(s0)
ffffffe000201bec:	00002517          	auipc	a0,0x2
ffffffe000201bf0:	62450513          	addi	a0,a0,1572 # ffffffe000204210 <_srodata+0x210>
ffffffe000201bf4:	52c010ef          	jal	ra,ffffffe000203120 <printk>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe000201bf8:	fc043783          	ld	a5,-64(s0)
ffffffe000201bfc:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe000201c00:	00003717          	auipc	a4,0x3
ffffffe000201c04:	97870713          	addi	a4,a4,-1672 # ffffffe000204578 <_erodata>
ffffffe000201c08:	000017b7          	lui	a5,0x1
ffffffe000201c0c:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201c10:	00f70733          	add	a4,a4,a5
ffffffe000201c14:	fffff7b7          	lui	a5,0xfffff
ffffffe000201c18:	00f777b3          	and	a5,a4,a5
ffffffe000201c1c:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe000201c20:	fb843703          	ld	a4,-72(s0)
ffffffe000201c24:	04100793          	li	a5,65
ffffffe000201c28:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c2c:	00f70633          	add	a2,a4,a5
ffffffe000201c30:	fb043703          	ld	a4,-80(s0)
ffffffe000201c34:	fb843783          	ld	a5,-72(s0)
ffffffe000201c38:	40f707b3          	sub	a5,a4,a5
ffffffe000201c3c:	00300713          	li	a4,3
ffffffe000201c40:	00078693          	mv	a3,a5
ffffffe000201c44:	fb843583          	ld	a1,-72(s0)
ffffffe000201c48:	00009517          	auipc	a0,0x9
ffffffe000201c4c:	3b850513          	addi	a0,a0,952 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201c50:	10c000ef          	jal	ra,ffffffe000201d5c <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);
ffffffe000201c54:	00300693          	li	a3,3
ffffffe000201c58:	fb043603          	ld	a2,-80(s0)
ffffffe000201c5c:	fb843583          	ld	a1,-72(s0)
ffffffe000201c60:	00002517          	auipc	a0,0x2
ffffffe000201c64:	5e850513          	addi	a0,a0,1512 # ffffffe000204248 <_srodata+0x248>
ffffffe000201c68:	4b8010ef          	jal	ra,ffffffe000203120 <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe000201c6c:	fb043783          	ld	a5,-80(s0)
ffffffe000201c70:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe000201c74:	fd043783          	ld	a5,-48(s0)
ffffffe000201c78:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe000201c7c:	fa843703          	ld	a4,-88(s0)
ffffffe000201c80:	04100793          	li	a5,65
ffffffe000201c84:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c88:	00f70633          	add	a2,a4,a5
ffffffe000201c8c:	fa043703          	ld	a4,-96(s0)
ffffffe000201c90:	fa843783          	ld	a5,-88(s0)
ffffffe000201c94:	40f707b3          	sub	a5,a4,a5
ffffffe000201c98:	00700713          	li	a4,7
ffffffe000201c9c:	00078693          	mv	a3,a5
ffffffe000201ca0:	fa843583          	ld	a1,-88(s0)
ffffffe000201ca4:	00009517          	auipc	a0,0x9
ffffffe000201ca8:	35c50513          	addi	a0,a0,860 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201cac:	0b0000ef          	jal	ra,ffffffe000201d5c <create_mapping>
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);
ffffffe000201cb0:	00700693          	li	a3,7
ffffffe000201cb4:	fa043603          	ld	a2,-96(s0)
ffffffe000201cb8:	fa843583          	ld	a1,-88(s0)
ffffffe000201cbc:	00002517          	auipc	a0,0x2
ffffffe000201cc0:	5c450513          	addi	a0,a0,1476 # ffffffe000204280 <_srodata+0x280>
ffffffe000201cc4:	45c010ef          	jal	ra,ffffffe000203120 <printk>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000201cc8:	00009517          	auipc	a0,0x9
ffffffe000201ccc:	33850513          	addi	a0,a0,824 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201cd0:	044000ef          	jal	ra,ffffffe000201d14 <get_satp>
ffffffe000201cd4:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000201cd8:	f9843783          	ld	a5,-104(s0)
ffffffe000201cdc:	f8f43823          	sd	a5,-112(s0)
ffffffe000201ce0:	f9043783          	ld	a5,-112(s0)
ffffffe000201ce4:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe000201ce8:	f9843583          	ld	a1,-104(s0)
ffffffe000201cec:	00002517          	auipc	a0,0x2
ffffffe000201cf0:	5c450513          	addi	a0,a0,1476 # ffffffe0002042b0 <_srodata+0x2b0>
ffffffe000201cf4:	42c010ef          	jal	ra,ffffffe000203120 <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201cf8:	12000073          	sfence.vma

    // flush icache
    asm volatile("fence.i");
ffffffe000201cfc:	0000100f          	fence.i
    return;
ffffffe000201d00:	00000013          	nop
}
ffffffe000201d04:	06813083          	ld	ra,104(sp)
ffffffe000201d08:	06013403          	ld	s0,96(sp)
ffffffe000201d0c:	07010113          	addi	sp,sp,112
ffffffe000201d10:	00008067          	ret

ffffffe000201d14 <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe000201d14:	fd010113          	addi	sp,sp,-48
ffffffe000201d18:	02813423          	sd	s0,40(sp)
ffffffe000201d1c:	03010413          	addi	s0,sp,48
ffffffe000201d20:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe000201d24:	fd843703          	ld	a4,-40(s0)
ffffffe000201d28:	04100793          	li	a5,65
ffffffe000201d2c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201d30:	00f707b3          	add	a5,a4,a5
ffffffe000201d34:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe000201d38:	fe843783          	ld	a5,-24(s0)
ffffffe000201d3c:	00c7d713          	srli	a4,a5,0xc
ffffffe000201d40:	fff00793          	li	a5,-1
ffffffe000201d44:	03f79793          	slli	a5,a5,0x3f
ffffffe000201d48:	00f767b3          	or	a5,a4,a5
}
ffffffe000201d4c:	00078513          	mv	a0,a5
ffffffe000201d50:	02813403          	ld	s0,40(sp)
ffffffe000201d54:	03010113          	addi	sp,sp,48
ffffffe000201d58:	00008067          	ret

ffffffe000201d5c <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201d5c:	fb010113          	addi	sp,sp,-80
ffffffe000201d60:	04113423          	sd	ra,72(sp)
ffffffe000201d64:	04813023          	sd	s0,64(sp)
ffffffe000201d68:	05010413          	addi	s0,sp,80
ffffffe000201d6c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201d70:	fcb43823          	sd	a1,-48(s0)
ffffffe000201d74:	fcc43423          	sd	a2,-56(s0)
ffffffe000201d78:	fcd43023          	sd	a3,-64(s0)
ffffffe000201d7c:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe000201d80:	fc043683          	ld	a3,-64(s0)
ffffffe000201d84:	fc843603          	ld	a2,-56(s0)
ffffffe000201d88:	fd043583          	ld	a1,-48(s0)
ffffffe000201d8c:	00002517          	auipc	a0,0x2
ffffffe000201d90:	53450513          	addi	a0,a0,1332 # ffffffe0002042c0 <_srodata+0x2c0>
ffffffe000201d94:	38c010ef          	jal	ra,ffffffe000203120 <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000201d98:	fd043783          	ld	a5,-48(s0)
ffffffe000201d9c:	fef43423          	sd	a5,-24(s0)
ffffffe000201da0:	fc843783          	ld	a5,-56(s0)
ffffffe000201da4:	fef43023          	sd	a5,-32(s0)
ffffffe000201da8:	0380006f          	j	ffffffe000201de0 <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe000201dac:	fb843683          	ld	a3,-72(s0)
ffffffe000201db0:	fe043603          	ld	a2,-32(s0)
ffffffe000201db4:	fe843583          	ld	a1,-24(s0)
ffffffe000201db8:	fd843503          	ld	a0,-40(s0)
ffffffe000201dbc:	050000ef          	jal	ra,ffffffe000201e0c <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000201dc0:	fe843703          	ld	a4,-24(s0)
ffffffe000201dc4:	000017b7          	lui	a5,0x1
ffffffe000201dc8:	00f707b3          	add	a5,a4,a5
ffffffe000201dcc:	fef43423          	sd	a5,-24(s0)
ffffffe000201dd0:	fe043703          	ld	a4,-32(s0)
ffffffe000201dd4:	000017b7          	lui	a5,0x1
ffffffe000201dd8:	00f707b3          	add	a5,a4,a5
ffffffe000201ddc:	fef43023          	sd	a5,-32(s0)
ffffffe000201de0:	fd043703          	ld	a4,-48(s0)
ffffffe000201de4:	fc043783          	ld	a5,-64(s0)
ffffffe000201de8:	00f707b3          	add	a5,a4,a5
ffffffe000201dec:	fe843703          	ld	a4,-24(s0)
ffffffe000201df0:	faf76ee3          	bltu	a4,a5,ffffffe000201dac <create_mapping+0x50>
   }
}
ffffffe000201df4:	00000013          	nop
ffffffe000201df8:	00000013          	nop
ffffffe000201dfc:	04813083          	ld	ra,72(sp)
ffffffe000201e00:	04013403          	ld	s0,64(sp)
ffffffe000201e04:	05010113          	addi	sp,sp,80
ffffffe000201e08:	00008067          	ret

ffffffe000201e0c <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201e0c:	f9010113          	addi	sp,sp,-112
ffffffe000201e10:	06113423          	sd	ra,104(sp)
ffffffe000201e14:	06813023          	sd	s0,96(sp)
ffffffe000201e18:	07010413          	addi	s0,sp,112
ffffffe000201e1c:	faa43423          	sd	a0,-88(s0)
ffffffe000201e20:	fab43023          	sd	a1,-96(s0)
ffffffe000201e24:	f8c43c23          	sd	a2,-104(s0)
ffffffe000201e28:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000201e2c:	fa043783          	ld	a5,-96(s0)
ffffffe000201e30:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201e34:	1ff7f793          	andi	a5,a5,511
ffffffe000201e38:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000201e3c:	fa043783          	ld	a5,-96(s0)
ffffffe000201e40:	0157d793          	srli	a5,a5,0x15
ffffffe000201e44:	1ff7f793          	andi	a5,a5,511
ffffffe000201e48:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000201e4c:	fa043783          	ld	a5,-96(s0)
ffffffe000201e50:	00c7d793          	srli	a5,a5,0xc
ffffffe000201e54:	1ff7f793          	andi	a5,a5,511
ffffffe000201e58:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe000201e5c:	fd843783          	ld	a5,-40(s0)
ffffffe000201e60:	00379793          	slli	a5,a5,0x3
ffffffe000201e64:	fa843703          	ld	a4,-88(s0)
ffffffe000201e68:	00f707b3          	add	a5,a4,a5
ffffffe000201e6c:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe000201e70:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe000201e74:	fe843783          	ld	a5,-24(s0)
ffffffe000201e78:	0017f793          	andi	a5,a5,1
ffffffe000201e7c:	00079c63          	bnez	a5,ffffffe000201e94 <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe000201e80:	00100613          	li	a2,1
ffffffe000201e84:	fd843583          	ld	a1,-40(s0)
ffffffe000201e88:	fa843503          	ld	a0,-88(s0)
ffffffe000201e8c:	c11ff0ef          	jal	ra,ffffffe000201a9c <setup_pgtbl>
ffffffe000201e90:	fea43423          	sd	a0,-24(s0)
    }
    // printk("pte1 = %lx\n", pte);

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET); // VA
ffffffe000201e94:	fe843783          	ld	a5,-24(s0)
ffffffe000201e98:	00a7d793          	srli	a5,a5,0xa
ffffffe000201e9c:	00c79713          	slli	a4,a5,0xc
ffffffe000201ea0:	fbf00793          	li	a5,-65
ffffffe000201ea4:	01f79793          	slli	a5,a5,0x1f
ffffffe000201ea8:	00f707b3          	add	a5,a4,a5
ffffffe000201eac:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe000201eb0:	fd043783          	ld	a5,-48(s0)
ffffffe000201eb4:	00379793          	slli	a5,a5,0x3
ffffffe000201eb8:	fc043703          	ld	a4,-64(s0)
ffffffe000201ebc:	00f707b3          	add	a5,a4,a5
ffffffe000201ec0:	0007b783          	ld	a5,0(a5)
ffffffe000201ec4:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe000201ec8:	fe043783          	ld	a5,-32(s0)
ffffffe000201ecc:	0017f793          	andi	a5,a5,1
ffffffe000201ed0:	00079c63          	bnez	a5,ffffffe000201ee8 <map_vm_final+0xdc>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe000201ed4:	00100613          	li	a2,1
ffffffe000201ed8:	fd043583          	ld	a1,-48(s0)
ffffffe000201edc:	fc043503          	ld	a0,-64(s0)
ffffffe000201ee0:	bbdff0ef          	jal	ra,ffffffe000201a9c <setup_pgtbl>
ffffffe000201ee4:	fea43023          	sd	a0,-32(s0)
    }
    // printk("pte2 = %lx\n", pte2);

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);// VA
ffffffe000201ee8:	fe043783          	ld	a5,-32(s0)
ffffffe000201eec:	00a7d793          	srli	a5,a5,0xa
ffffffe000201ef0:	00c79713          	slli	a4,a5,0xc
ffffffe000201ef4:	fbf00793          	li	a5,-65
ffffffe000201ef8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201efc:	00f707b3          	add	a5,a4,a5
ffffffe000201f00:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe000201f04:	f9043783          	ld	a5,-112(s0)
ffffffe000201f08:	0017e793          	ori	a5,a5,1
ffffffe000201f0c:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe000201f10:	f9843783          	ld	a5,-104(s0)
ffffffe000201f14:	00c7d793          	srli	a5,a5,0xc
ffffffe000201f18:	00a79693          	slli	a3,a5,0xa
ffffffe000201f1c:	fc843783          	ld	a5,-56(s0)
ffffffe000201f20:	00379793          	slli	a5,a5,0x3
ffffffe000201f24:	fb843703          	ld	a4,-72(s0)
ffffffe000201f28:	00f707b3          	add	a5,a4,a5
ffffffe000201f2c:	f9043703          	ld	a4,-112(s0)
ffffffe000201f30:	00e6e733          	or	a4,a3,a4
ffffffe000201f34:	00e7b023          	sd	a4,0(a5)
}
ffffffe000201f38:	00000013          	nop
ffffffe000201f3c:	06813083          	ld	ra,104(sp)
ffffffe000201f40:	06013403          	ld	s0,96(sp)
ffffffe000201f44:	07010113          	addi	sp,sp,112
ffffffe000201f48:	00008067          	ret

ffffffe000201f4c <get_kernel_pgtbl>:

ffffffe000201f4c:	ff010113          	addi	sp,sp,-16
ffffffe000201f50:	00813423          	sd	s0,8(sp)
ffffffe000201f54:	01010413          	addi	s0,sp,16
ffffffe000201f58:	00009797          	auipc	a5,0x9
ffffffe000201f5c:	0a878793          	addi	a5,a5,168 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201f60:	00078513          	mv	a0,a5
ffffffe000201f64:	00813403          	ld	s0,8(sp)
ffffffe000201f68:	01010113          	addi	sp,sp,16
ffffffe000201f6c:	00008067          	ret

ffffffe000201f70 <start_kernel>:
#include "defs.h"
#include "proc.h"

extern void test();

int start_kernel() {
ffffffe000201f70:	ff010113          	addi	sp,sp,-16
ffffffe000201f74:	00113423          	sd	ra,8(sp)
ffffffe000201f78:	00813023          	sd	s0,0(sp)
ffffffe000201f7c:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000201f80:	00002517          	auipc	a0,0x2
ffffffe000201f84:	36850513          	addi	a0,a0,872 # ffffffe0002042e8 <_srodata+0x2e8>
ffffffe000201f88:	198010ef          	jal	ra,ffffffe000203120 <printk>
    printk(" ZJU Operating System\n");
ffffffe000201f8c:	00002517          	auipc	a0,0x2
ffffffe000201f90:	36450513          	addi	a0,a0,868 # ffffffe0002042f0 <_srodata+0x2f0>
ffffffe000201f94:	18c010ef          	jal	ra,ffffffe000203120 <printk>
    schedule();
ffffffe000201f98:	b2cff0ef          	jal	ra,ffffffe0002012c4 <schedule>
    // verify_vm();

    test();
ffffffe000201f9c:	2c0000ef          	jal	ra,ffffffe00020225c <test>
    return 0;
ffffffe000201fa0:	00000793          	li	a5,0
}
ffffffe000201fa4:	00078513          	mv	a0,a5
ffffffe000201fa8:	00813083          	ld	ra,8(sp)
ffffffe000201fac:	00013403          	ld	s0,0(sp)
ffffffe000201fb0:	01010113          	addi	sp,sp,16
ffffffe000201fb4:	00008067          	ret

ffffffe000201fb8 <test_rodata_write>:

void test_rodata_write(uint64_t *addr) {
ffffffe000201fb8:	fd010113          	addi	sp,sp,-48
ffffffe000201fbc:	02113423          	sd	ra,40(sp)
ffffffe000201fc0:	02813023          	sd	s0,32(sp)
ffffffe000201fc4:	03010413          	addi	s0,sp,48
ffffffe000201fc8:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr;
ffffffe000201fcc:	fd843783          	ld	a5,-40(s0)
ffffffe000201fd0:	0007b783          	ld	a5,0(a5)
ffffffe000201fd4:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000201fd8:	00100793          	li	a5,1
ffffffe000201fdc:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000201fe0:	fd843783          	ld	a5,-40(s0)
ffffffe000201fe4:	00100293          	li	t0,1
ffffffe000201fe8:	0057b023          	sd	t0,0(a5)
ffffffe000201fec:	00000793          	li	a5,0
ffffffe000201ff0:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000201ff4:	fe442783          	lw	a5,-28(s0)
ffffffe000201ff8:	0007879b          	sext.w	a5,a5
ffffffe000201ffc:	02078063          	beqz	a5,ffffffe00020201c <test_rodata_write+0x64>
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
ffffffe000202000:	00002517          	auipc	a0,0x2
ffffffe000202004:	30850513          	addi	a0,a0,776 # ffffffe000204308 <_srodata+0x308>
ffffffe000202008:	118010ef          	jal	ra,ffffffe000203120 <printk>
        *addr = backup; // 恢复原值
ffffffe00020200c:	fd843783          	ld	a5,-40(s0)
ffffffe000202010:	fe843703          	ld	a4,-24(s0)
ffffffe000202014:	00e7b023          	sd	a4,0(a5)
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}
ffffffe000202018:	0100006f          	j	ffffffe000202028 <test_rodata_write+0x70>
        printk("PASS: .rodata write failed as expected.\n");
ffffffe00020201c:	00002517          	auipc	a0,0x2
ffffffe000202020:	31c50513          	addi	a0,a0,796 # ffffffe000204338 <_srodata+0x338>
ffffffe000202024:	0fc010ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe000202028:	00000013          	nop
ffffffe00020202c:	02813083          	ld	ra,40(sp)
ffffffe000202030:	02013403          	ld	s0,32(sp)
ffffffe000202034:	03010113          	addi	sp,sp,48
ffffffe000202038:	00008067          	ret

ffffffe00020203c <test_rodata_exec>:

void test_rodata_exec(uint64_t *addr) {
ffffffe00020203c:	fd010113          	addi	sp,sp,-48
ffffffe000202040:	02113423          	sd	ra,40(sp)
ffffffe000202044:	02813023          	sd	s0,32(sp)
ffffffe000202048:	03010413          	addi	s0,sp,48
ffffffe00020204c:	fca43c23          	sd	a0,-40(s0)
    int success = 1;
ffffffe000202050:	00100793          	li	a5,1
ffffffe000202054:	fef42623          	sw	a5,-20(s0)

    asm volatile(
ffffffe000202058:	fd843783          	ld	a5,-40(s0)
ffffffe00020205c:	000780e7          	jalr	a5
ffffffe000202060:	00000793          	li	a5,0
ffffffe000202064:	fef42623          	sw	a5,-20(s0)
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
ffffffe000202068:	fec42783          	lw	a5,-20(s0)
ffffffe00020206c:	0007879b          	sext.w	a5,a5
ffffffe000202070:	00078a63          	beqz	a5,ffffffe000202084 <test_rodata_exec+0x48>
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
ffffffe000202074:	00002517          	auipc	a0,0x2
ffffffe000202078:	2f450513          	addi	a0,a0,756 # ffffffe000204368 <_srodata+0x368>
ffffffe00020207c:	0a4010ef          	jal	ra,ffffffe000203120 <printk>
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}
ffffffe000202080:	0100006f          	j	ffffffe000202090 <test_rodata_exec+0x54>
        printk("PASS: .rodata execute failed as expected.\n");
ffffffe000202084:	00002517          	auipc	a0,0x2
ffffffe000202088:	31450513          	addi	a0,a0,788 # ffffffe000204398 <_srodata+0x398>
ffffffe00020208c:	094010ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe000202090:	00000013          	nop
ffffffe000202094:	02813083          	ld	ra,40(sp)
ffffffe000202098:	02013403          	ld	s0,32(sp)
ffffffe00020209c:	03010113          	addi	sp,sp,48
ffffffe0002020a0:	00008067          	ret

ffffffe0002020a4 <test_text_read>:

void test_text_read(uint64_t *addr) {
ffffffe0002020a4:	fd010113          	addi	sp,sp,-48
ffffffe0002020a8:	02113423          	sd	ra,40(sp)
ffffffe0002020ac:	02813023          	sd	s0,32(sp)
ffffffe0002020b0:	03010413          	addi	s0,sp,48
ffffffe0002020b4:	fca43c23          	sd	a0,-40(s0)
    printk(".text read test: ");
ffffffe0002020b8:	00002517          	auipc	a0,0x2
ffffffe0002020bc:	31050513          	addi	a0,a0,784 # ffffffe0002043c8 <_srodata+0x3c8>
ffffffe0002020c0:	060010ef          	jal	ra,ffffffe000203120 <printk>
    uint64_t value = *addr;
ffffffe0002020c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002020c8:	0007b783          	ld	a5,0(a5)
ffffffe0002020cc:	fef43423          	sd	a5,-24(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe0002020d0:	fe843583          	ld	a1,-24(s0)
ffffffe0002020d4:	00002517          	auipc	a0,0x2
ffffffe0002020d8:	30c50513          	addi	a0,a0,780 # ffffffe0002043e0 <_srodata+0x3e0>
ffffffe0002020dc:	044010ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe0002020e0:	00000013          	nop
ffffffe0002020e4:	02813083          	ld	ra,40(sp)
ffffffe0002020e8:	02013403          	ld	s0,32(sp)
ffffffe0002020ec:	03010113          	addi	sp,sp,48
ffffffe0002020f0:	00008067          	ret

ffffffe0002020f4 <test_text_write>:

void test_text_write(uint64_t *addr) {
ffffffe0002020f4:	fd010113          	addi	sp,sp,-48
ffffffe0002020f8:	02113423          	sd	ra,40(sp)
ffffffe0002020fc:	02813023          	sd	s0,32(sp)
ffffffe000202100:	03010413          	addi	s0,sp,48
ffffffe000202104:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr; // 备份原始值
ffffffe000202108:	fd843783          	ld	a5,-40(s0)
ffffffe00020210c:	0007b783          	ld	a5,0(a5)
ffffffe000202110:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000202114:	00100793          	li	a5,1
ffffffe000202118:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe00020211c:	fd843783          	ld	a5,-40(s0)
ffffffe000202120:	00100293          	li	t0,1
ffffffe000202124:	0057b023          	sd	t0,0(a5)
ffffffe000202128:	00000793          	li	a5,0
ffffffe00020212c:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000202130:	fe442783          	lw	a5,-28(s0)
ffffffe000202134:	0007879b          	sext.w	a5,a5
ffffffe000202138:	00078a63          	beqz	a5,ffffffe00020214c <test_text_write+0x58>
        printk("PASS: .text write failed as expected.\n");
ffffffe00020213c:	00002517          	auipc	a0,0x2
ffffffe000202140:	2cc50513          	addi	a0,a0,716 # ffffffe000204408 <_srodata+0x408>
ffffffe000202144:	7dd000ef          	jal	ra,ffffffe000203120 <printk>
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}
ffffffe000202148:	01c0006f          	j	ffffffe000202164 <test_text_write+0x70>
        printk("ERROR: .text write succeeded unexpectedly!\n");
ffffffe00020214c:	00002517          	auipc	a0,0x2
ffffffe000202150:	2e450513          	addi	a0,a0,740 # ffffffe000204430 <_srodata+0x430>
ffffffe000202154:	7cd000ef          	jal	ra,ffffffe000203120 <printk>
        *addr = backup; // 恢复原始值，避免破坏代码段
ffffffe000202158:	fd843783          	ld	a5,-40(s0)
ffffffe00020215c:	fe843703          	ld	a4,-24(s0)
ffffffe000202160:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202164:	00000013          	nop
ffffffe000202168:	02813083          	ld	ra,40(sp)
ffffffe00020216c:	02013403          	ld	s0,32(sp)
ffffffe000202170:	03010113          	addi	sp,sp,48
ffffffe000202174:	00008067          	ret

ffffffe000202178 <test_text_exec>:

void test_text_exec() {
ffffffe000202178:	ff010113          	addi	sp,sp,-16
ffffffe00020217c:	00113423          	sd	ra,8(sp)
ffffffe000202180:	00813023          	sd	s0,0(sp)
ffffffe000202184:	01010413          	addi	s0,sp,16
    printk("Executing .text segment test: ");
ffffffe000202188:	00002517          	auipc	a0,0x2
ffffffe00020218c:	2d850513          	addi	a0,a0,728 # ffffffe000204460 <_srodata+0x460>
ffffffe000202190:	791000ef          	jal	ra,ffffffe000203120 <printk>
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
ffffffe000202194:	00002517          	auipc	a0,0x2
ffffffe000202198:	2ec50513          	addi	a0,a0,748 # ffffffe000204480 <_srodata+0x480>
ffffffe00020219c:	785000ef          	jal	ra,ffffffe000203120 <printk>
}
ffffffe0002021a0:	00000013          	nop
ffffffe0002021a4:	00813083          	ld	ra,8(sp)
ffffffe0002021a8:	00013403          	ld	s0,0(sp)
ffffffe0002021ac:	01010113          	addi	sp,sp,16
ffffffe0002021b0:	00008067          	ret

ffffffe0002021b4 <verify_vm>:

void verify_vm() {
ffffffe0002021b4:	fd010113          	addi	sp,sp,-48
ffffffe0002021b8:	02113423          	sd	ra,40(sp)
ffffffe0002021bc:	02813023          	sd	s0,32(sp)
ffffffe0002021c0:	03010413          	addi	s0,sp,48
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
ffffffe0002021c4:	f00017b7          	lui	a5,0xf0001
ffffffe0002021c8:	00979793          	slli	a5,a5,0x9
ffffffe0002021cc:	fef43423          	sd	a5,-24(s0)
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段
ffffffe0002021d0:	fe0007b7          	lui	a5,0xfe000
ffffffe0002021d4:	20378793          	addi	a5,a5,515 # fffffffffe000203 <VM_END+0xfe000203>
ffffffe0002021d8:	00c79793          	slli	a5,a5,0xc
ffffffe0002021dc:	fef43023          	sd	a5,-32(s0)

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;
ffffffe0002021e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002021e4:	fcf43c23          	sd	a5,-40(s0)

    // .text R
    printk(".text read test: \n");
ffffffe0002021e8:	00002517          	auipc	a0,0x2
ffffffe0002021ec:	2b850513          	addi	a0,a0,696 # ffffffe0002044a0 <_srodata+0x4a0>
ffffffe0002021f0:	731000ef          	jal	ra,ffffffe000203120 <printk>
    test_text_read(test_addr);
ffffffe0002021f4:	fd843503          	ld	a0,-40(s0)
ffffffe0002021f8:	eadff0ef          	jal	ra,ffffffe0002020a4 <test_text_read>
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
ffffffe0002021fc:	00002517          	auipc	a0,0x2
ffffffe000202200:	2bc50513          	addi	a0,a0,700 # ffffffe0002044b8 <_srodata+0x4b8>
ffffffe000202204:	71d000ef          	jal	ra,ffffffe000203120 <printk>
    test_text_exec();
ffffffe000202208:	f71ff0ef          	jal	ra,ffffffe000202178 <test_text_exec>

    // .rodata
    test_addr = (uint64_t *)va_rodata;
ffffffe00020220c:	fe043783          	ld	a5,-32(s0)
ffffffe000202210:	fcf43c23          	sd	a5,-40(s0)

    // .rodata R
    printk(".rodata read test: \n");
ffffffe000202214:	00002517          	auipc	a0,0x2
ffffffe000202218:	2bc50513          	addi	a0,a0,700 # ffffffe0002044d0 <_srodata+0x4d0>
ffffffe00020221c:	705000ef          	jal	ra,ffffffe000203120 <printk>
    uint64_t value = *test_addr;
ffffffe000202220:	fd843783          	ld	a5,-40(s0)
ffffffe000202224:	0007b783          	ld	a5,0(a5)
ffffffe000202228:	fcf43823          	sd	a5,-48(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe00020222c:	fd043583          	ld	a1,-48(s0)
ffffffe000202230:	00002517          	auipc	a0,0x2
ffffffe000202234:	1b050513          	addi	a0,a0,432 # ffffffe0002043e0 <_srodata+0x3e0>
ffffffe000202238:	6e9000ef          	jal	ra,ffffffe000203120 <printk>

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
ffffffe00020223c:	00002517          	auipc	a0,0x2
ffffffe000202240:	2ac50513          	addi	a0,a0,684 # ffffffe0002044e8 <_srodata+0x4e8>
ffffffe000202244:	6dd000ef          	jal	ra,ffffffe000203120 <printk>
ffffffe000202248:	00000013          	nop
ffffffe00020224c:	02813083          	ld	ra,40(sp)
ffffffe000202250:	02013403          	ld	s0,32(sp)
ffffffe000202254:	03010113          	addi	sp,sp,48
ffffffe000202258:	00008067          	ret

ffffffe00020225c <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe00020225c:	fe010113          	addi	sp,sp,-32
ffffffe000202260:	00113c23          	sd	ra,24(sp)
ffffffe000202264:	00813823          	sd	s0,16(sp)
ffffffe000202268:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe00020226c:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe000202270:	00002517          	auipc	a0,0x2
ffffffe000202274:	29850513          	addi	a0,a0,664 # ffffffe000204508 <_srodata+0x508>
ffffffe000202278:	6a9000ef          	jal	ra,ffffffe000203120 <printk>
    while (1)
    {
        i++;
ffffffe00020227c:	fec42783          	lw	a5,-20(s0)
ffffffe000202280:	0017879b          	addiw	a5,a5,1
ffffffe000202284:	fef42623          	sw	a5,-20(s0)
ffffffe000202288:	ff5ff06f          	j	ffffffe00020227c <test+0x20>

ffffffe00020228c <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe00020228c:	fe010113          	addi	sp,sp,-32
ffffffe000202290:	00113c23          	sd	ra,24(sp)
ffffffe000202294:	00813823          	sd	s0,16(sp)
ffffffe000202298:	02010413          	addi	s0,sp,32
ffffffe00020229c:	00050793          	mv	a5,a0
ffffffe0002022a0:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe0002022a4:	fec42783          	lw	a5,-20(s0)
ffffffe0002022a8:	0ff7f793          	zext.b	a5,a5
ffffffe0002022ac:	00078513          	mv	a0,a5
ffffffe0002022b0:	b88ff0ef          	jal	ra,ffffffe000201638 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe0002022b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002022b8:	0ff7f793          	zext.b	a5,a5
ffffffe0002022bc:	0007879b          	sext.w	a5,a5
}
ffffffe0002022c0:	00078513          	mv	a0,a5
ffffffe0002022c4:	01813083          	ld	ra,24(sp)
ffffffe0002022c8:	01013403          	ld	s0,16(sp)
ffffffe0002022cc:	02010113          	addi	sp,sp,32
ffffffe0002022d0:	00008067          	ret

ffffffe0002022d4 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe0002022d4:	fe010113          	addi	sp,sp,-32
ffffffe0002022d8:	00813c23          	sd	s0,24(sp)
ffffffe0002022dc:	02010413          	addi	s0,sp,32
ffffffe0002022e0:	00050793          	mv	a5,a0
ffffffe0002022e4:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe0002022e8:	fec42783          	lw	a5,-20(s0)
ffffffe0002022ec:	0007871b          	sext.w	a4,a5
ffffffe0002022f0:	02000793          	li	a5,32
ffffffe0002022f4:	02f70263          	beq	a4,a5,ffffffe000202318 <isspace+0x44>
ffffffe0002022f8:	fec42783          	lw	a5,-20(s0)
ffffffe0002022fc:	0007871b          	sext.w	a4,a5
ffffffe000202300:	00800793          	li	a5,8
ffffffe000202304:	00e7de63          	bge	a5,a4,ffffffe000202320 <isspace+0x4c>
ffffffe000202308:	fec42783          	lw	a5,-20(s0)
ffffffe00020230c:	0007871b          	sext.w	a4,a5
ffffffe000202310:	00d00793          	li	a5,13
ffffffe000202314:	00e7c663          	blt	a5,a4,ffffffe000202320 <isspace+0x4c>
ffffffe000202318:	00100793          	li	a5,1
ffffffe00020231c:	0080006f          	j	ffffffe000202324 <isspace+0x50>
ffffffe000202320:	00000793          	li	a5,0
}
ffffffe000202324:	00078513          	mv	a0,a5
ffffffe000202328:	01813403          	ld	s0,24(sp)
ffffffe00020232c:	02010113          	addi	sp,sp,32
ffffffe000202330:	00008067          	ret

ffffffe000202334 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000202334:	fb010113          	addi	sp,sp,-80
ffffffe000202338:	04113423          	sd	ra,72(sp)
ffffffe00020233c:	04813023          	sd	s0,64(sp)
ffffffe000202340:	05010413          	addi	s0,sp,80
ffffffe000202344:	fca43423          	sd	a0,-56(s0)
ffffffe000202348:	fcb43023          	sd	a1,-64(s0)
ffffffe00020234c:	00060793          	mv	a5,a2
ffffffe000202350:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000202354:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202358:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe00020235c:	fc843783          	ld	a5,-56(s0)
ffffffe000202360:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000202364:	0100006f          	j	ffffffe000202374 <strtol+0x40>
        p++;
ffffffe000202368:	fd843783          	ld	a5,-40(s0)
ffffffe00020236c:	00178793          	addi	a5,a5,1
ffffffe000202370:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000202374:	fd843783          	ld	a5,-40(s0)
ffffffe000202378:	0007c783          	lbu	a5,0(a5)
ffffffe00020237c:	0007879b          	sext.w	a5,a5
ffffffe000202380:	00078513          	mv	a0,a5
ffffffe000202384:	f51ff0ef          	jal	ra,ffffffe0002022d4 <isspace>
ffffffe000202388:	00050793          	mv	a5,a0
ffffffe00020238c:	fc079ee3          	bnez	a5,ffffffe000202368 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000202390:	fd843783          	ld	a5,-40(s0)
ffffffe000202394:	0007c783          	lbu	a5,0(a5)
ffffffe000202398:	00078713          	mv	a4,a5
ffffffe00020239c:	02d00793          	li	a5,45
ffffffe0002023a0:	00f71e63          	bne	a4,a5,ffffffe0002023bc <strtol+0x88>
        neg = true;
ffffffe0002023a4:	00100793          	li	a5,1
ffffffe0002023a8:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002023ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002023b0:	00178793          	addi	a5,a5,1
ffffffe0002023b4:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002023b8:	0240006f          	j	ffffffe0002023dc <strtol+0xa8>
    } else if (*p == '+') {
ffffffe0002023bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002023c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002023c4:	00078713          	mv	a4,a5
ffffffe0002023c8:	02b00793          	li	a5,43
ffffffe0002023cc:	00f71863          	bne	a4,a5,ffffffe0002023dc <strtol+0xa8>
        p++;
ffffffe0002023d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002023d4:	00178793          	addi	a5,a5,1
ffffffe0002023d8:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002023dc:	fbc42783          	lw	a5,-68(s0)
ffffffe0002023e0:	0007879b          	sext.w	a5,a5
ffffffe0002023e4:	06079c63          	bnez	a5,ffffffe00020245c <strtol+0x128>
        if (*p == '0') {
ffffffe0002023e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002023ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002023f0:	00078713          	mv	a4,a5
ffffffe0002023f4:	03000793          	li	a5,48
ffffffe0002023f8:	04f71e63          	bne	a4,a5,ffffffe000202454 <strtol+0x120>
            p++;
ffffffe0002023fc:	fd843783          	ld	a5,-40(s0)
ffffffe000202400:	00178793          	addi	a5,a5,1
ffffffe000202404:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000202408:	fd843783          	ld	a5,-40(s0)
ffffffe00020240c:	0007c783          	lbu	a5,0(a5)
ffffffe000202410:	00078713          	mv	a4,a5
ffffffe000202414:	07800793          	li	a5,120
ffffffe000202418:	00f70c63          	beq	a4,a5,ffffffe000202430 <strtol+0xfc>
ffffffe00020241c:	fd843783          	ld	a5,-40(s0)
ffffffe000202420:	0007c783          	lbu	a5,0(a5)
ffffffe000202424:	00078713          	mv	a4,a5
ffffffe000202428:	05800793          	li	a5,88
ffffffe00020242c:	00f71e63          	bne	a4,a5,ffffffe000202448 <strtol+0x114>
                base = 16;
ffffffe000202430:	01000793          	li	a5,16
ffffffe000202434:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202438:	fd843783          	ld	a5,-40(s0)
ffffffe00020243c:	00178793          	addi	a5,a5,1
ffffffe000202440:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202444:	0180006f          	j	ffffffe00020245c <strtol+0x128>
            } else {
                base = 8;
ffffffe000202448:	00800793          	li	a5,8
ffffffe00020244c:	faf42e23          	sw	a5,-68(s0)
ffffffe000202450:	00c0006f          	j	ffffffe00020245c <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202454:	00a00793          	li	a5,10
ffffffe000202458:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe00020245c:	fd843783          	ld	a5,-40(s0)
ffffffe000202460:	0007c783          	lbu	a5,0(a5)
ffffffe000202464:	00078713          	mv	a4,a5
ffffffe000202468:	02f00793          	li	a5,47
ffffffe00020246c:	02e7f863          	bgeu	a5,a4,ffffffe00020249c <strtol+0x168>
ffffffe000202470:	fd843783          	ld	a5,-40(s0)
ffffffe000202474:	0007c783          	lbu	a5,0(a5)
ffffffe000202478:	00078713          	mv	a4,a5
ffffffe00020247c:	03900793          	li	a5,57
ffffffe000202480:	00e7ee63          	bltu	a5,a4,ffffffe00020249c <strtol+0x168>
            digit = *p - '0';
ffffffe000202484:	fd843783          	ld	a5,-40(s0)
ffffffe000202488:	0007c783          	lbu	a5,0(a5)
ffffffe00020248c:	0007879b          	sext.w	a5,a5
ffffffe000202490:	fd07879b          	addiw	a5,a5,-48
ffffffe000202494:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202498:	0800006f          	j	ffffffe000202518 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe00020249c:	fd843783          	ld	a5,-40(s0)
ffffffe0002024a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002024a4:	00078713          	mv	a4,a5
ffffffe0002024a8:	06000793          	li	a5,96
ffffffe0002024ac:	02e7f863          	bgeu	a5,a4,ffffffe0002024dc <strtol+0x1a8>
ffffffe0002024b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002024b4:	0007c783          	lbu	a5,0(a5)
ffffffe0002024b8:	00078713          	mv	a4,a5
ffffffe0002024bc:	07a00793          	li	a5,122
ffffffe0002024c0:	00e7ee63          	bltu	a5,a4,ffffffe0002024dc <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe0002024c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002024c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002024cc:	0007879b          	sext.w	a5,a5
ffffffe0002024d0:	fa97879b          	addiw	a5,a5,-87
ffffffe0002024d4:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002024d8:	0400006f          	j	ffffffe000202518 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002024dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002024e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002024e4:	00078713          	mv	a4,a5
ffffffe0002024e8:	04000793          	li	a5,64
ffffffe0002024ec:	06e7f863          	bgeu	a5,a4,ffffffe00020255c <strtol+0x228>
ffffffe0002024f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002024f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002024f8:	00078713          	mv	a4,a5
ffffffe0002024fc:	05a00793          	li	a5,90
ffffffe000202500:	04e7ee63          	bltu	a5,a4,ffffffe00020255c <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000202504:	fd843783          	ld	a5,-40(s0)
ffffffe000202508:	0007c783          	lbu	a5,0(a5)
ffffffe00020250c:	0007879b          	sext.w	a5,a5
ffffffe000202510:	fc97879b          	addiw	a5,a5,-55
ffffffe000202514:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000202518:	fd442783          	lw	a5,-44(s0)
ffffffe00020251c:	00078713          	mv	a4,a5
ffffffe000202520:	fbc42783          	lw	a5,-68(s0)
ffffffe000202524:	0007071b          	sext.w	a4,a4
ffffffe000202528:	0007879b          	sext.w	a5,a5
ffffffe00020252c:	02f75663          	bge	a4,a5,ffffffe000202558 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000202530:	fbc42703          	lw	a4,-68(s0)
ffffffe000202534:	fe843783          	ld	a5,-24(s0)
ffffffe000202538:	02f70733          	mul	a4,a4,a5
ffffffe00020253c:	fd442783          	lw	a5,-44(s0)
ffffffe000202540:	00f707b3          	add	a5,a4,a5
ffffffe000202544:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000202548:	fd843783          	ld	a5,-40(s0)
ffffffe00020254c:	00178793          	addi	a5,a5,1
ffffffe000202550:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000202554:	f09ff06f          	j	ffffffe00020245c <strtol+0x128>
            break;
ffffffe000202558:	00000013          	nop
    }

    if (endptr) {
ffffffe00020255c:	fc043783          	ld	a5,-64(s0)
ffffffe000202560:	00078863          	beqz	a5,ffffffe000202570 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000202564:	fc043783          	ld	a5,-64(s0)
ffffffe000202568:	fd843703          	ld	a4,-40(s0)
ffffffe00020256c:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000202570:	fe744783          	lbu	a5,-25(s0)
ffffffe000202574:	0ff7f793          	zext.b	a5,a5
ffffffe000202578:	00078863          	beqz	a5,ffffffe000202588 <strtol+0x254>
ffffffe00020257c:	fe843783          	ld	a5,-24(s0)
ffffffe000202580:	40f007b3          	neg	a5,a5
ffffffe000202584:	0080006f          	j	ffffffe00020258c <strtol+0x258>
ffffffe000202588:	fe843783          	ld	a5,-24(s0)
}
ffffffe00020258c:	00078513          	mv	a0,a5
ffffffe000202590:	04813083          	ld	ra,72(sp)
ffffffe000202594:	04013403          	ld	s0,64(sp)
ffffffe000202598:	05010113          	addi	sp,sp,80
ffffffe00020259c:	00008067          	ret

ffffffe0002025a0 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe0002025a0:	fd010113          	addi	sp,sp,-48
ffffffe0002025a4:	02113423          	sd	ra,40(sp)
ffffffe0002025a8:	02813023          	sd	s0,32(sp)
ffffffe0002025ac:	03010413          	addi	s0,sp,48
ffffffe0002025b0:	fca43c23          	sd	a0,-40(s0)
ffffffe0002025b4:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe0002025b8:	fd043783          	ld	a5,-48(s0)
ffffffe0002025bc:	00079863          	bnez	a5,ffffffe0002025cc <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002025c0:	00002797          	auipc	a5,0x2
ffffffe0002025c4:	f6078793          	addi	a5,a5,-160 # ffffffe000204520 <_srodata+0x520>
ffffffe0002025c8:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002025cc:	fd043783          	ld	a5,-48(s0)
ffffffe0002025d0:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002025d4:	0240006f          	j	ffffffe0002025f8 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002025d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002025dc:	00178713          	addi	a4,a5,1
ffffffe0002025e0:	fee43423          	sd	a4,-24(s0)
ffffffe0002025e4:	0007c783          	lbu	a5,0(a5)
ffffffe0002025e8:	0007871b          	sext.w	a4,a5
ffffffe0002025ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002025f0:	00070513          	mv	a0,a4
ffffffe0002025f4:	000780e7          	jalr	a5
    while (*p) {
ffffffe0002025f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002025fc:	0007c783          	lbu	a5,0(a5)
ffffffe000202600:	fc079ce3          	bnez	a5,ffffffe0002025d8 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000202604:	fe843703          	ld	a4,-24(s0)
ffffffe000202608:	fd043783          	ld	a5,-48(s0)
ffffffe00020260c:	40f707b3          	sub	a5,a4,a5
ffffffe000202610:	0007879b          	sext.w	a5,a5
}
ffffffe000202614:	00078513          	mv	a0,a5
ffffffe000202618:	02813083          	ld	ra,40(sp)
ffffffe00020261c:	02013403          	ld	s0,32(sp)
ffffffe000202620:	03010113          	addi	sp,sp,48
ffffffe000202624:	00008067          	ret

ffffffe000202628 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000202628:	f9010113          	addi	sp,sp,-112
ffffffe00020262c:	06113423          	sd	ra,104(sp)
ffffffe000202630:	06813023          	sd	s0,96(sp)
ffffffe000202634:	07010413          	addi	s0,sp,112
ffffffe000202638:	faa43423          	sd	a0,-88(s0)
ffffffe00020263c:	fab43023          	sd	a1,-96(s0)
ffffffe000202640:	00060793          	mv	a5,a2
ffffffe000202644:	f8d43823          	sd	a3,-112(s0)
ffffffe000202648:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe00020264c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202650:	0ff7f793          	zext.b	a5,a5
ffffffe000202654:	02078663          	beqz	a5,ffffffe000202680 <print_dec_int+0x58>
ffffffe000202658:	fa043703          	ld	a4,-96(s0)
ffffffe00020265c:	fff00793          	li	a5,-1
ffffffe000202660:	03f79793          	slli	a5,a5,0x3f
ffffffe000202664:	00f71e63          	bne	a4,a5,ffffffe000202680 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000202668:	00002597          	auipc	a1,0x2
ffffffe00020266c:	ec058593          	addi	a1,a1,-320 # ffffffe000204528 <_srodata+0x528>
ffffffe000202670:	fa843503          	ld	a0,-88(s0)
ffffffe000202674:	f2dff0ef          	jal	ra,ffffffe0002025a0 <puts_wo_nl>
ffffffe000202678:	00050793          	mv	a5,a0
ffffffe00020267c:	2a00006f          	j	ffffffe00020291c <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202680:	f9043783          	ld	a5,-112(s0)
ffffffe000202684:	00c7a783          	lw	a5,12(a5)
ffffffe000202688:	00079a63          	bnez	a5,ffffffe00020269c <print_dec_int+0x74>
ffffffe00020268c:	fa043783          	ld	a5,-96(s0)
ffffffe000202690:	00079663          	bnez	a5,ffffffe00020269c <print_dec_int+0x74>
        return 0;
ffffffe000202694:	00000793          	li	a5,0
ffffffe000202698:	2840006f          	j	ffffffe00020291c <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe00020269c:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe0002026a0:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002026a4:	0ff7f793          	zext.b	a5,a5
ffffffe0002026a8:	02078063          	beqz	a5,ffffffe0002026c8 <print_dec_int+0xa0>
ffffffe0002026ac:	fa043783          	ld	a5,-96(s0)
ffffffe0002026b0:	0007dc63          	bgez	a5,ffffffe0002026c8 <print_dec_int+0xa0>
        neg = true;
ffffffe0002026b4:	00100793          	li	a5,1
ffffffe0002026b8:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe0002026bc:	fa043783          	ld	a5,-96(s0)
ffffffe0002026c0:	40f007b3          	neg	a5,a5
ffffffe0002026c4:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe0002026c8:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe0002026cc:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002026d0:	0ff7f793          	zext.b	a5,a5
ffffffe0002026d4:	02078863          	beqz	a5,ffffffe000202704 <print_dec_int+0xdc>
ffffffe0002026d8:	fef44783          	lbu	a5,-17(s0)
ffffffe0002026dc:	0ff7f793          	zext.b	a5,a5
ffffffe0002026e0:	00079e63          	bnez	a5,ffffffe0002026fc <print_dec_int+0xd4>
ffffffe0002026e4:	f9043783          	ld	a5,-112(s0)
ffffffe0002026e8:	0057c783          	lbu	a5,5(a5)
ffffffe0002026ec:	00079863          	bnez	a5,ffffffe0002026fc <print_dec_int+0xd4>
ffffffe0002026f0:	f9043783          	ld	a5,-112(s0)
ffffffe0002026f4:	0047c783          	lbu	a5,4(a5)
ffffffe0002026f8:	00078663          	beqz	a5,ffffffe000202704 <print_dec_int+0xdc>
ffffffe0002026fc:	00100793          	li	a5,1
ffffffe000202700:	0080006f          	j	ffffffe000202708 <print_dec_int+0xe0>
ffffffe000202704:	00000793          	li	a5,0
ffffffe000202708:	fcf40ba3          	sb	a5,-41(s0)
ffffffe00020270c:	fd744783          	lbu	a5,-41(s0)
ffffffe000202710:	0017f793          	andi	a5,a5,1
ffffffe000202714:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000202718:	fa043703          	ld	a4,-96(s0)
ffffffe00020271c:	00a00793          	li	a5,10
ffffffe000202720:	02f777b3          	remu	a5,a4,a5
ffffffe000202724:	0ff7f713          	zext.b	a4,a5
ffffffe000202728:	fe842783          	lw	a5,-24(s0)
ffffffe00020272c:	0017869b          	addiw	a3,a5,1
ffffffe000202730:	fed42423          	sw	a3,-24(s0)
ffffffe000202734:	0307071b          	addiw	a4,a4,48
ffffffe000202738:	0ff77713          	zext.b	a4,a4
ffffffe00020273c:	ff078793          	addi	a5,a5,-16
ffffffe000202740:	008787b3          	add	a5,a5,s0
ffffffe000202744:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000202748:	fa043703          	ld	a4,-96(s0)
ffffffe00020274c:	00a00793          	li	a5,10
ffffffe000202750:	02f757b3          	divu	a5,a4,a5
ffffffe000202754:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000202758:	fa043783          	ld	a5,-96(s0)
ffffffe00020275c:	fa079ee3          	bnez	a5,ffffffe000202718 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202760:	f9043783          	ld	a5,-112(s0)
ffffffe000202764:	00c7a783          	lw	a5,12(a5)
ffffffe000202768:	00078713          	mv	a4,a5
ffffffe00020276c:	fff00793          	li	a5,-1
ffffffe000202770:	02f71063          	bne	a4,a5,ffffffe000202790 <print_dec_int+0x168>
ffffffe000202774:	f9043783          	ld	a5,-112(s0)
ffffffe000202778:	0037c783          	lbu	a5,3(a5)
ffffffe00020277c:	00078a63          	beqz	a5,ffffffe000202790 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000202780:	f9043783          	ld	a5,-112(s0)
ffffffe000202784:	0087a703          	lw	a4,8(a5)
ffffffe000202788:	f9043783          	ld	a5,-112(s0)
ffffffe00020278c:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000202790:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202794:	f9043783          	ld	a5,-112(s0)
ffffffe000202798:	0087a703          	lw	a4,8(a5)
ffffffe00020279c:	fe842783          	lw	a5,-24(s0)
ffffffe0002027a0:	fcf42823          	sw	a5,-48(s0)
ffffffe0002027a4:	f9043783          	ld	a5,-112(s0)
ffffffe0002027a8:	00c7a783          	lw	a5,12(a5)
ffffffe0002027ac:	fcf42623          	sw	a5,-52(s0)
ffffffe0002027b0:	fd042783          	lw	a5,-48(s0)
ffffffe0002027b4:	00078593          	mv	a1,a5
ffffffe0002027b8:	fcc42783          	lw	a5,-52(s0)
ffffffe0002027bc:	00078613          	mv	a2,a5
ffffffe0002027c0:	0006069b          	sext.w	a3,a2
ffffffe0002027c4:	0005879b          	sext.w	a5,a1
ffffffe0002027c8:	00f6d463          	bge	a3,a5,ffffffe0002027d0 <print_dec_int+0x1a8>
ffffffe0002027cc:	00058613          	mv	a2,a1
ffffffe0002027d0:	0006079b          	sext.w	a5,a2
ffffffe0002027d4:	40f707bb          	subw	a5,a4,a5
ffffffe0002027d8:	0007871b          	sext.w	a4,a5
ffffffe0002027dc:	fd744783          	lbu	a5,-41(s0)
ffffffe0002027e0:	0007879b          	sext.w	a5,a5
ffffffe0002027e4:	40f707bb          	subw	a5,a4,a5
ffffffe0002027e8:	fef42023          	sw	a5,-32(s0)
ffffffe0002027ec:	0280006f          	j	ffffffe000202814 <print_dec_int+0x1ec>
        putch(' ');
ffffffe0002027f0:	fa843783          	ld	a5,-88(s0)
ffffffe0002027f4:	02000513          	li	a0,32
ffffffe0002027f8:	000780e7          	jalr	a5
        ++written;
ffffffe0002027fc:	fe442783          	lw	a5,-28(s0)
ffffffe000202800:	0017879b          	addiw	a5,a5,1
ffffffe000202804:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202808:	fe042783          	lw	a5,-32(s0)
ffffffe00020280c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202810:	fef42023          	sw	a5,-32(s0)
ffffffe000202814:	fe042783          	lw	a5,-32(s0)
ffffffe000202818:	0007879b          	sext.w	a5,a5
ffffffe00020281c:	fcf04ae3          	bgtz	a5,ffffffe0002027f0 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000202820:	fd744783          	lbu	a5,-41(s0)
ffffffe000202824:	0ff7f793          	zext.b	a5,a5
ffffffe000202828:	04078463          	beqz	a5,ffffffe000202870 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe00020282c:	fef44783          	lbu	a5,-17(s0)
ffffffe000202830:	0ff7f793          	zext.b	a5,a5
ffffffe000202834:	00078663          	beqz	a5,ffffffe000202840 <print_dec_int+0x218>
ffffffe000202838:	02d00793          	li	a5,45
ffffffe00020283c:	01c0006f          	j	ffffffe000202858 <print_dec_int+0x230>
ffffffe000202840:	f9043783          	ld	a5,-112(s0)
ffffffe000202844:	0057c783          	lbu	a5,5(a5)
ffffffe000202848:	00078663          	beqz	a5,ffffffe000202854 <print_dec_int+0x22c>
ffffffe00020284c:	02b00793          	li	a5,43
ffffffe000202850:	0080006f          	j	ffffffe000202858 <print_dec_int+0x230>
ffffffe000202854:	02000793          	li	a5,32
ffffffe000202858:	fa843703          	ld	a4,-88(s0)
ffffffe00020285c:	00078513          	mv	a0,a5
ffffffe000202860:	000700e7          	jalr	a4
        ++written;
ffffffe000202864:	fe442783          	lw	a5,-28(s0)
ffffffe000202868:	0017879b          	addiw	a5,a5,1
ffffffe00020286c:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202870:	fe842783          	lw	a5,-24(s0)
ffffffe000202874:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202878:	0280006f          	j	ffffffe0002028a0 <print_dec_int+0x278>
        putch('0');
ffffffe00020287c:	fa843783          	ld	a5,-88(s0)
ffffffe000202880:	03000513          	li	a0,48
ffffffe000202884:	000780e7          	jalr	a5
        ++written;
ffffffe000202888:	fe442783          	lw	a5,-28(s0)
ffffffe00020288c:	0017879b          	addiw	a5,a5,1
ffffffe000202890:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202894:	fdc42783          	lw	a5,-36(s0)
ffffffe000202898:	0017879b          	addiw	a5,a5,1
ffffffe00020289c:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002028a0:	f9043783          	ld	a5,-112(s0)
ffffffe0002028a4:	00c7a703          	lw	a4,12(a5)
ffffffe0002028a8:	fd744783          	lbu	a5,-41(s0)
ffffffe0002028ac:	0007879b          	sext.w	a5,a5
ffffffe0002028b0:	40f707bb          	subw	a5,a4,a5
ffffffe0002028b4:	0007871b          	sext.w	a4,a5
ffffffe0002028b8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002028bc:	0007879b          	sext.w	a5,a5
ffffffe0002028c0:	fae7cee3          	blt	a5,a4,ffffffe00020287c <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002028c4:	fe842783          	lw	a5,-24(s0)
ffffffe0002028c8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002028cc:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002028d0:	03c0006f          	j	ffffffe00020290c <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe0002028d4:	fd842783          	lw	a5,-40(s0)
ffffffe0002028d8:	ff078793          	addi	a5,a5,-16
ffffffe0002028dc:	008787b3          	add	a5,a5,s0
ffffffe0002028e0:	fc87c783          	lbu	a5,-56(a5)
ffffffe0002028e4:	0007871b          	sext.w	a4,a5
ffffffe0002028e8:	fa843783          	ld	a5,-88(s0)
ffffffe0002028ec:	00070513          	mv	a0,a4
ffffffe0002028f0:	000780e7          	jalr	a5
        ++written;
ffffffe0002028f4:	fe442783          	lw	a5,-28(s0)
ffffffe0002028f8:	0017879b          	addiw	a5,a5,1
ffffffe0002028fc:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202900:	fd842783          	lw	a5,-40(s0)
ffffffe000202904:	fff7879b          	addiw	a5,a5,-1
ffffffe000202908:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020290c:	fd842783          	lw	a5,-40(s0)
ffffffe000202910:	0007879b          	sext.w	a5,a5
ffffffe000202914:	fc07d0e3          	bgez	a5,ffffffe0002028d4 <print_dec_int+0x2ac>
    }

    return written;
ffffffe000202918:	fe442783          	lw	a5,-28(s0)
}
ffffffe00020291c:	00078513          	mv	a0,a5
ffffffe000202920:	06813083          	ld	ra,104(sp)
ffffffe000202924:	06013403          	ld	s0,96(sp)
ffffffe000202928:	07010113          	addi	sp,sp,112
ffffffe00020292c:	00008067          	ret

ffffffe000202930 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000202930:	f4010113          	addi	sp,sp,-192
ffffffe000202934:	0a113c23          	sd	ra,184(sp)
ffffffe000202938:	0a813823          	sd	s0,176(sp)
ffffffe00020293c:	0c010413          	addi	s0,sp,192
ffffffe000202940:	f4a43c23          	sd	a0,-168(s0)
ffffffe000202944:	f4b43823          	sd	a1,-176(s0)
ffffffe000202948:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe00020294c:	f8043023          	sd	zero,-128(s0)
ffffffe000202950:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000202954:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000202958:	7a40006f          	j	ffffffe0002030fc <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe00020295c:	f8044783          	lbu	a5,-128(s0)
ffffffe000202960:	72078e63          	beqz	a5,ffffffe00020309c <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000202964:	f5043783          	ld	a5,-176(s0)
ffffffe000202968:	0007c783          	lbu	a5,0(a5)
ffffffe00020296c:	00078713          	mv	a4,a5
ffffffe000202970:	02300793          	li	a5,35
ffffffe000202974:	00f71863          	bne	a4,a5,ffffffe000202984 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000202978:	00100793          	li	a5,1
ffffffe00020297c:	f8f40123          	sb	a5,-126(s0)
ffffffe000202980:	7700006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000202984:	f5043783          	ld	a5,-176(s0)
ffffffe000202988:	0007c783          	lbu	a5,0(a5)
ffffffe00020298c:	00078713          	mv	a4,a5
ffffffe000202990:	03000793          	li	a5,48
ffffffe000202994:	00f71863          	bne	a4,a5,ffffffe0002029a4 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000202998:	00100793          	li	a5,1
ffffffe00020299c:	f8f401a3          	sb	a5,-125(s0)
ffffffe0002029a0:	7500006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe0002029a4:	f5043783          	ld	a5,-176(s0)
ffffffe0002029a8:	0007c783          	lbu	a5,0(a5)
ffffffe0002029ac:	00078713          	mv	a4,a5
ffffffe0002029b0:	06c00793          	li	a5,108
ffffffe0002029b4:	04f70063          	beq	a4,a5,ffffffe0002029f4 <vprintfmt+0xc4>
ffffffe0002029b8:	f5043783          	ld	a5,-176(s0)
ffffffe0002029bc:	0007c783          	lbu	a5,0(a5)
ffffffe0002029c0:	00078713          	mv	a4,a5
ffffffe0002029c4:	07a00793          	li	a5,122
ffffffe0002029c8:	02f70663          	beq	a4,a5,ffffffe0002029f4 <vprintfmt+0xc4>
ffffffe0002029cc:	f5043783          	ld	a5,-176(s0)
ffffffe0002029d0:	0007c783          	lbu	a5,0(a5)
ffffffe0002029d4:	00078713          	mv	a4,a5
ffffffe0002029d8:	07400793          	li	a5,116
ffffffe0002029dc:	00f70c63          	beq	a4,a5,ffffffe0002029f4 <vprintfmt+0xc4>
ffffffe0002029e0:	f5043783          	ld	a5,-176(s0)
ffffffe0002029e4:	0007c783          	lbu	a5,0(a5)
ffffffe0002029e8:	00078713          	mv	a4,a5
ffffffe0002029ec:	06a00793          	li	a5,106
ffffffe0002029f0:	00f71863          	bne	a4,a5,ffffffe000202a00 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe0002029f4:	00100793          	li	a5,1
ffffffe0002029f8:	f8f400a3          	sb	a5,-127(s0)
ffffffe0002029fc:	6f40006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000202a00:	f5043783          	ld	a5,-176(s0)
ffffffe000202a04:	0007c783          	lbu	a5,0(a5)
ffffffe000202a08:	00078713          	mv	a4,a5
ffffffe000202a0c:	02b00793          	li	a5,43
ffffffe000202a10:	00f71863          	bne	a4,a5,ffffffe000202a20 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000202a14:	00100793          	li	a5,1
ffffffe000202a18:	f8f402a3          	sb	a5,-123(s0)
ffffffe000202a1c:	6d40006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000202a20:	f5043783          	ld	a5,-176(s0)
ffffffe000202a24:	0007c783          	lbu	a5,0(a5)
ffffffe000202a28:	00078713          	mv	a4,a5
ffffffe000202a2c:	02000793          	li	a5,32
ffffffe000202a30:	00f71863          	bne	a4,a5,ffffffe000202a40 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000202a34:	00100793          	li	a5,1
ffffffe000202a38:	f8f40223          	sb	a5,-124(s0)
ffffffe000202a3c:	6b40006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000202a40:	f5043783          	ld	a5,-176(s0)
ffffffe000202a44:	0007c783          	lbu	a5,0(a5)
ffffffe000202a48:	00078713          	mv	a4,a5
ffffffe000202a4c:	02a00793          	li	a5,42
ffffffe000202a50:	00f71e63          	bne	a4,a5,ffffffe000202a6c <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000202a54:	f4843783          	ld	a5,-184(s0)
ffffffe000202a58:	00878713          	addi	a4,a5,8
ffffffe000202a5c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202a60:	0007a783          	lw	a5,0(a5)
ffffffe000202a64:	f8f42423          	sw	a5,-120(s0)
ffffffe000202a68:	6880006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000202a6c:	f5043783          	ld	a5,-176(s0)
ffffffe000202a70:	0007c783          	lbu	a5,0(a5)
ffffffe000202a74:	00078713          	mv	a4,a5
ffffffe000202a78:	03000793          	li	a5,48
ffffffe000202a7c:	04e7f663          	bgeu	a5,a4,ffffffe000202ac8 <vprintfmt+0x198>
ffffffe000202a80:	f5043783          	ld	a5,-176(s0)
ffffffe000202a84:	0007c783          	lbu	a5,0(a5)
ffffffe000202a88:	00078713          	mv	a4,a5
ffffffe000202a8c:	03900793          	li	a5,57
ffffffe000202a90:	02e7ec63          	bltu	a5,a4,ffffffe000202ac8 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000202a94:	f5043783          	ld	a5,-176(s0)
ffffffe000202a98:	f5040713          	addi	a4,s0,-176
ffffffe000202a9c:	00a00613          	li	a2,10
ffffffe000202aa0:	00070593          	mv	a1,a4
ffffffe000202aa4:	00078513          	mv	a0,a5
ffffffe000202aa8:	88dff0ef          	jal	ra,ffffffe000202334 <strtol>
ffffffe000202aac:	00050793          	mv	a5,a0
ffffffe000202ab0:	0007879b          	sext.w	a5,a5
ffffffe000202ab4:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000202ab8:	f5043783          	ld	a5,-176(s0)
ffffffe000202abc:	fff78793          	addi	a5,a5,-1
ffffffe000202ac0:	f4f43823          	sd	a5,-176(s0)
ffffffe000202ac4:	62c0006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000202ac8:	f5043783          	ld	a5,-176(s0)
ffffffe000202acc:	0007c783          	lbu	a5,0(a5)
ffffffe000202ad0:	00078713          	mv	a4,a5
ffffffe000202ad4:	02e00793          	li	a5,46
ffffffe000202ad8:	06f71863          	bne	a4,a5,ffffffe000202b48 <vprintfmt+0x218>
                fmt++;
ffffffe000202adc:	f5043783          	ld	a5,-176(s0)
ffffffe000202ae0:	00178793          	addi	a5,a5,1
ffffffe000202ae4:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000202ae8:	f5043783          	ld	a5,-176(s0)
ffffffe000202aec:	0007c783          	lbu	a5,0(a5)
ffffffe000202af0:	00078713          	mv	a4,a5
ffffffe000202af4:	02a00793          	li	a5,42
ffffffe000202af8:	00f71e63          	bne	a4,a5,ffffffe000202b14 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000202afc:	f4843783          	ld	a5,-184(s0)
ffffffe000202b00:	00878713          	addi	a4,a5,8
ffffffe000202b04:	f4e43423          	sd	a4,-184(s0)
ffffffe000202b08:	0007a783          	lw	a5,0(a5)
ffffffe000202b0c:	f8f42623          	sw	a5,-116(s0)
ffffffe000202b10:	5e00006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000202b14:	f5043783          	ld	a5,-176(s0)
ffffffe000202b18:	f5040713          	addi	a4,s0,-176
ffffffe000202b1c:	00a00613          	li	a2,10
ffffffe000202b20:	00070593          	mv	a1,a4
ffffffe000202b24:	00078513          	mv	a0,a5
ffffffe000202b28:	80dff0ef          	jal	ra,ffffffe000202334 <strtol>
ffffffe000202b2c:	00050793          	mv	a5,a0
ffffffe000202b30:	0007879b          	sext.w	a5,a5
ffffffe000202b34:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000202b38:	f5043783          	ld	a5,-176(s0)
ffffffe000202b3c:	fff78793          	addi	a5,a5,-1
ffffffe000202b40:	f4f43823          	sd	a5,-176(s0)
ffffffe000202b44:	5ac0006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202b48:	f5043783          	ld	a5,-176(s0)
ffffffe000202b4c:	0007c783          	lbu	a5,0(a5)
ffffffe000202b50:	00078713          	mv	a4,a5
ffffffe000202b54:	07800793          	li	a5,120
ffffffe000202b58:	02f70663          	beq	a4,a5,ffffffe000202b84 <vprintfmt+0x254>
ffffffe000202b5c:	f5043783          	ld	a5,-176(s0)
ffffffe000202b60:	0007c783          	lbu	a5,0(a5)
ffffffe000202b64:	00078713          	mv	a4,a5
ffffffe000202b68:	05800793          	li	a5,88
ffffffe000202b6c:	00f70c63          	beq	a4,a5,ffffffe000202b84 <vprintfmt+0x254>
ffffffe000202b70:	f5043783          	ld	a5,-176(s0)
ffffffe000202b74:	0007c783          	lbu	a5,0(a5)
ffffffe000202b78:	00078713          	mv	a4,a5
ffffffe000202b7c:	07000793          	li	a5,112
ffffffe000202b80:	30f71263          	bne	a4,a5,ffffffe000202e84 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000202b84:	f5043783          	ld	a5,-176(s0)
ffffffe000202b88:	0007c783          	lbu	a5,0(a5)
ffffffe000202b8c:	00078713          	mv	a4,a5
ffffffe000202b90:	07000793          	li	a5,112
ffffffe000202b94:	00f70663          	beq	a4,a5,ffffffe000202ba0 <vprintfmt+0x270>
ffffffe000202b98:	f8144783          	lbu	a5,-127(s0)
ffffffe000202b9c:	00078663          	beqz	a5,ffffffe000202ba8 <vprintfmt+0x278>
ffffffe000202ba0:	00100793          	li	a5,1
ffffffe000202ba4:	0080006f          	j	ffffffe000202bac <vprintfmt+0x27c>
ffffffe000202ba8:	00000793          	li	a5,0
ffffffe000202bac:	faf403a3          	sb	a5,-89(s0)
ffffffe000202bb0:	fa744783          	lbu	a5,-89(s0)
ffffffe000202bb4:	0017f793          	andi	a5,a5,1
ffffffe000202bb8:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000202bbc:	fa744783          	lbu	a5,-89(s0)
ffffffe000202bc0:	0ff7f793          	zext.b	a5,a5
ffffffe000202bc4:	00078c63          	beqz	a5,ffffffe000202bdc <vprintfmt+0x2ac>
ffffffe000202bc8:	f4843783          	ld	a5,-184(s0)
ffffffe000202bcc:	00878713          	addi	a4,a5,8
ffffffe000202bd0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202bd4:	0007b783          	ld	a5,0(a5)
ffffffe000202bd8:	01c0006f          	j	ffffffe000202bf4 <vprintfmt+0x2c4>
ffffffe000202bdc:	f4843783          	ld	a5,-184(s0)
ffffffe000202be0:	00878713          	addi	a4,a5,8
ffffffe000202be4:	f4e43423          	sd	a4,-184(s0)
ffffffe000202be8:	0007a783          	lw	a5,0(a5)
ffffffe000202bec:	02079793          	slli	a5,a5,0x20
ffffffe000202bf0:	0207d793          	srli	a5,a5,0x20
ffffffe000202bf4:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000202bf8:	f8c42783          	lw	a5,-116(s0)
ffffffe000202bfc:	02079463          	bnez	a5,ffffffe000202c24 <vprintfmt+0x2f4>
ffffffe000202c00:	fe043783          	ld	a5,-32(s0)
ffffffe000202c04:	02079063          	bnez	a5,ffffffe000202c24 <vprintfmt+0x2f4>
ffffffe000202c08:	f5043783          	ld	a5,-176(s0)
ffffffe000202c0c:	0007c783          	lbu	a5,0(a5)
ffffffe000202c10:	00078713          	mv	a4,a5
ffffffe000202c14:	07000793          	li	a5,112
ffffffe000202c18:	00f70663          	beq	a4,a5,ffffffe000202c24 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000202c1c:	f8040023          	sb	zero,-128(s0)
ffffffe000202c20:	4d00006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000202c24:	f5043783          	ld	a5,-176(s0)
ffffffe000202c28:	0007c783          	lbu	a5,0(a5)
ffffffe000202c2c:	00078713          	mv	a4,a5
ffffffe000202c30:	07000793          	li	a5,112
ffffffe000202c34:	00f70a63          	beq	a4,a5,ffffffe000202c48 <vprintfmt+0x318>
ffffffe000202c38:	f8244783          	lbu	a5,-126(s0)
ffffffe000202c3c:	00078a63          	beqz	a5,ffffffe000202c50 <vprintfmt+0x320>
ffffffe000202c40:	fe043783          	ld	a5,-32(s0)
ffffffe000202c44:	00078663          	beqz	a5,ffffffe000202c50 <vprintfmt+0x320>
ffffffe000202c48:	00100793          	li	a5,1
ffffffe000202c4c:	0080006f          	j	ffffffe000202c54 <vprintfmt+0x324>
ffffffe000202c50:	00000793          	li	a5,0
ffffffe000202c54:	faf40323          	sb	a5,-90(s0)
ffffffe000202c58:	fa644783          	lbu	a5,-90(s0)
ffffffe000202c5c:	0017f793          	andi	a5,a5,1
ffffffe000202c60:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000202c64:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000202c68:	f5043783          	ld	a5,-176(s0)
ffffffe000202c6c:	0007c783          	lbu	a5,0(a5)
ffffffe000202c70:	00078713          	mv	a4,a5
ffffffe000202c74:	05800793          	li	a5,88
ffffffe000202c78:	00f71863          	bne	a4,a5,ffffffe000202c88 <vprintfmt+0x358>
ffffffe000202c7c:	00002797          	auipc	a5,0x2
ffffffe000202c80:	8c478793          	addi	a5,a5,-1852 # ffffffe000204540 <upperxdigits.1>
ffffffe000202c84:	00c0006f          	j	ffffffe000202c90 <vprintfmt+0x360>
ffffffe000202c88:	00002797          	auipc	a5,0x2
ffffffe000202c8c:	8d078793          	addi	a5,a5,-1840 # ffffffe000204558 <lowerxdigits.0>
ffffffe000202c90:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000202c94:	fe043783          	ld	a5,-32(s0)
ffffffe000202c98:	00f7f793          	andi	a5,a5,15
ffffffe000202c9c:	f9843703          	ld	a4,-104(s0)
ffffffe000202ca0:	00f70733          	add	a4,a4,a5
ffffffe000202ca4:	fdc42783          	lw	a5,-36(s0)
ffffffe000202ca8:	0017869b          	addiw	a3,a5,1
ffffffe000202cac:	fcd42e23          	sw	a3,-36(s0)
ffffffe000202cb0:	00074703          	lbu	a4,0(a4)
ffffffe000202cb4:	ff078793          	addi	a5,a5,-16
ffffffe000202cb8:	008787b3          	add	a5,a5,s0
ffffffe000202cbc:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000202cc0:	fe043783          	ld	a5,-32(s0)
ffffffe000202cc4:	0047d793          	srli	a5,a5,0x4
ffffffe000202cc8:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000202ccc:	fe043783          	ld	a5,-32(s0)
ffffffe000202cd0:	fc0792e3          	bnez	a5,ffffffe000202c94 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000202cd4:	f8c42783          	lw	a5,-116(s0)
ffffffe000202cd8:	00078713          	mv	a4,a5
ffffffe000202cdc:	fff00793          	li	a5,-1
ffffffe000202ce0:	02f71663          	bne	a4,a5,ffffffe000202d0c <vprintfmt+0x3dc>
ffffffe000202ce4:	f8344783          	lbu	a5,-125(s0)
ffffffe000202ce8:	02078263          	beqz	a5,ffffffe000202d0c <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000202cec:	f8842703          	lw	a4,-120(s0)
ffffffe000202cf0:	fa644783          	lbu	a5,-90(s0)
ffffffe000202cf4:	0007879b          	sext.w	a5,a5
ffffffe000202cf8:	0017979b          	slliw	a5,a5,0x1
ffffffe000202cfc:	0007879b          	sext.w	a5,a5
ffffffe000202d00:	40f707bb          	subw	a5,a4,a5
ffffffe000202d04:	0007879b          	sext.w	a5,a5
ffffffe000202d08:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202d0c:	f8842703          	lw	a4,-120(s0)
ffffffe000202d10:	fa644783          	lbu	a5,-90(s0)
ffffffe000202d14:	0007879b          	sext.w	a5,a5
ffffffe000202d18:	0017979b          	slliw	a5,a5,0x1
ffffffe000202d1c:	0007879b          	sext.w	a5,a5
ffffffe000202d20:	40f707bb          	subw	a5,a4,a5
ffffffe000202d24:	0007871b          	sext.w	a4,a5
ffffffe000202d28:	fdc42783          	lw	a5,-36(s0)
ffffffe000202d2c:	f8f42a23          	sw	a5,-108(s0)
ffffffe000202d30:	f8c42783          	lw	a5,-116(s0)
ffffffe000202d34:	f8f42823          	sw	a5,-112(s0)
ffffffe000202d38:	f9442783          	lw	a5,-108(s0)
ffffffe000202d3c:	00078593          	mv	a1,a5
ffffffe000202d40:	f9042783          	lw	a5,-112(s0)
ffffffe000202d44:	00078613          	mv	a2,a5
ffffffe000202d48:	0006069b          	sext.w	a3,a2
ffffffe000202d4c:	0005879b          	sext.w	a5,a1
ffffffe000202d50:	00f6d463          	bge	a3,a5,ffffffe000202d58 <vprintfmt+0x428>
ffffffe000202d54:	00058613          	mv	a2,a1
ffffffe000202d58:	0006079b          	sext.w	a5,a2
ffffffe000202d5c:	40f707bb          	subw	a5,a4,a5
ffffffe000202d60:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202d64:	0280006f          	j	ffffffe000202d8c <vprintfmt+0x45c>
                    putch(' ');
ffffffe000202d68:	f5843783          	ld	a5,-168(s0)
ffffffe000202d6c:	02000513          	li	a0,32
ffffffe000202d70:	000780e7          	jalr	a5
                    ++written;
ffffffe000202d74:	fec42783          	lw	a5,-20(s0)
ffffffe000202d78:	0017879b          	addiw	a5,a5,1
ffffffe000202d7c:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202d80:	fd842783          	lw	a5,-40(s0)
ffffffe000202d84:	fff7879b          	addiw	a5,a5,-1
ffffffe000202d88:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202d8c:	fd842783          	lw	a5,-40(s0)
ffffffe000202d90:	0007879b          	sext.w	a5,a5
ffffffe000202d94:	fcf04ae3          	bgtz	a5,ffffffe000202d68 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000202d98:	fa644783          	lbu	a5,-90(s0)
ffffffe000202d9c:	0ff7f793          	zext.b	a5,a5
ffffffe000202da0:	04078463          	beqz	a5,ffffffe000202de8 <vprintfmt+0x4b8>
                    putch('0');
ffffffe000202da4:	f5843783          	ld	a5,-168(s0)
ffffffe000202da8:	03000513          	li	a0,48
ffffffe000202dac:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000202db0:	f5043783          	ld	a5,-176(s0)
ffffffe000202db4:	0007c783          	lbu	a5,0(a5)
ffffffe000202db8:	00078713          	mv	a4,a5
ffffffe000202dbc:	05800793          	li	a5,88
ffffffe000202dc0:	00f71663          	bne	a4,a5,ffffffe000202dcc <vprintfmt+0x49c>
ffffffe000202dc4:	05800793          	li	a5,88
ffffffe000202dc8:	0080006f          	j	ffffffe000202dd0 <vprintfmt+0x4a0>
ffffffe000202dcc:	07800793          	li	a5,120
ffffffe000202dd0:	f5843703          	ld	a4,-168(s0)
ffffffe000202dd4:	00078513          	mv	a0,a5
ffffffe000202dd8:	000700e7          	jalr	a4
                    written += 2;
ffffffe000202ddc:	fec42783          	lw	a5,-20(s0)
ffffffe000202de0:	0027879b          	addiw	a5,a5,2
ffffffe000202de4:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202de8:	fdc42783          	lw	a5,-36(s0)
ffffffe000202dec:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202df0:	0280006f          	j	ffffffe000202e18 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000202df4:	f5843783          	ld	a5,-168(s0)
ffffffe000202df8:	03000513          	li	a0,48
ffffffe000202dfc:	000780e7          	jalr	a5
                    ++written;
ffffffe000202e00:	fec42783          	lw	a5,-20(s0)
ffffffe000202e04:	0017879b          	addiw	a5,a5,1
ffffffe000202e08:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202e0c:	fd442783          	lw	a5,-44(s0)
ffffffe000202e10:	0017879b          	addiw	a5,a5,1
ffffffe000202e14:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202e18:	f8c42703          	lw	a4,-116(s0)
ffffffe000202e1c:	fd442783          	lw	a5,-44(s0)
ffffffe000202e20:	0007879b          	sext.w	a5,a5
ffffffe000202e24:	fce7c8e3          	blt	a5,a4,ffffffe000202df4 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202e28:	fdc42783          	lw	a5,-36(s0)
ffffffe000202e2c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202e30:	fcf42823          	sw	a5,-48(s0)
ffffffe000202e34:	03c0006f          	j	ffffffe000202e70 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000202e38:	fd042783          	lw	a5,-48(s0)
ffffffe000202e3c:	ff078793          	addi	a5,a5,-16
ffffffe000202e40:	008787b3          	add	a5,a5,s0
ffffffe000202e44:	f807c783          	lbu	a5,-128(a5)
ffffffe000202e48:	0007871b          	sext.w	a4,a5
ffffffe000202e4c:	f5843783          	ld	a5,-168(s0)
ffffffe000202e50:	00070513          	mv	a0,a4
ffffffe000202e54:	000780e7          	jalr	a5
                    ++written;
ffffffe000202e58:	fec42783          	lw	a5,-20(s0)
ffffffe000202e5c:	0017879b          	addiw	a5,a5,1
ffffffe000202e60:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202e64:	fd042783          	lw	a5,-48(s0)
ffffffe000202e68:	fff7879b          	addiw	a5,a5,-1
ffffffe000202e6c:	fcf42823          	sw	a5,-48(s0)
ffffffe000202e70:	fd042783          	lw	a5,-48(s0)
ffffffe000202e74:	0007879b          	sext.w	a5,a5
ffffffe000202e78:	fc07d0e3          	bgez	a5,ffffffe000202e38 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000202e7c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202e80:	2700006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202e84:	f5043783          	ld	a5,-176(s0)
ffffffe000202e88:	0007c783          	lbu	a5,0(a5)
ffffffe000202e8c:	00078713          	mv	a4,a5
ffffffe000202e90:	06400793          	li	a5,100
ffffffe000202e94:	02f70663          	beq	a4,a5,ffffffe000202ec0 <vprintfmt+0x590>
ffffffe000202e98:	f5043783          	ld	a5,-176(s0)
ffffffe000202e9c:	0007c783          	lbu	a5,0(a5)
ffffffe000202ea0:	00078713          	mv	a4,a5
ffffffe000202ea4:	06900793          	li	a5,105
ffffffe000202ea8:	00f70c63          	beq	a4,a5,ffffffe000202ec0 <vprintfmt+0x590>
ffffffe000202eac:	f5043783          	ld	a5,-176(s0)
ffffffe000202eb0:	0007c783          	lbu	a5,0(a5)
ffffffe000202eb4:	00078713          	mv	a4,a5
ffffffe000202eb8:	07500793          	li	a5,117
ffffffe000202ebc:	08f71063          	bne	a4,a5,ffffffe000202f3c <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000202ec0:	f8144783          	lbu	a5,-127(s0)
ffffffe000202ec4:	00078c63          	beqz	a5,ffffffe000202edc <vprintfmt+0x5ac>
ffffffe000202ec8:	f4843783          	ld	a5,-184(s0)
ffffffe000202ecc:	00878713          	addi	a4,a5,8
ffffffe000202ed0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202ed4:	0007b783          	ld	a5,0(a5)
ffffffe000202ed8:	0140006f          	j	ffffffe000202eec <vprintfmt+0x5bc>
ffffffe000202edc:	f4843783          	ld	a5,-184(s0)
ffffffe000202ee0:	00878713          	addi	a4,a5,8
ffffffe000202ee4:	f4e43423          	sd	a4,-184(s0)
ffffffe000202ee8:	0007a783          	lw	a5,0(a5)
ffffffe000202eec:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000202ef0:	fa843583          	ld	a1,-88(s0)
ffffffe000202ef4:	f5043783          	ld	a5,-176(s0)
ffffffe000202ef8:	0007c783          	lbu	a5,0(a5)
ffffffe000202efc:	0007871b          	sext.w	a4,a5
ffffffe000202f00:	07500793          	li	a5,117
ffffffe000202f04:	40f707b3          	sub	a5,a4,a5
ffffffe000202f08:	00f037b3          	snez	a5,a5
ffffffe000202f0c:	0ff7f793          	zext.b	a5,a5
ffffffe000202f10:	f8040713          	addi	a4,s0,-128
ffffffe000202f14:	00070693          	mv	a3,a4
ffffffe000202f18:	00078613          	mv	a2,a5
ffffffe000202f1c:	f5843503          	ld	a0,-168(s0)
ffffffe000202f20:	f08ff0ef          	jal	ra,ffffffe000202628 <print_dec_int>
ffffffe000202f24:	00050793          	mv	a5,a0
ffffffe000202f28:	fec42703          	lw	a4,-20(s0)
ffffffe000202f2c:	00f707bb          	addw	a5,a4,a5
ffffffe000202f30:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202f34:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202f38:	1b80006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202f3c:	f5043783          	ld	a5,-176(s0)
ffffffe000202f40:	0007c783          	lbu	a5,0(a5)
ffffffe000202f44:	00078713          	mv	a4,a5
ffffffe000202f48:	06e00793          	li	a5,110
ffffffe000202f4c:	04f71c63          	bne	a4,a5,ffffffe000202fa4 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe000202f50:	f8144783          	lbu	a5,-127(s0)
ffffffe000202f54:	02078463          	beqz	a5,ffffffe000202f7c <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000202f58:	f4843783          	ld	a5,-184(s0)
ffffffe000202f5c:	00878713          	addi	a4,a5,8
ffffffe000202f60:	f4e43423          	sd	a4,-184(s0)
ffffffe000202f64:	0007b783          	ld	a5,0(a5)
ffffffe000202f68:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202f6c:	fec42703          	lw	a4,-20(s0)
ffffffe000202f70:	fb043783          	ld	a5,-80(s0)
ffffffe000202f74:	00e7b023          	sd	a4,0(a5)
ffffffe000202f78:	0240006f          	j	ffffffe000202f9c <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000202f7c:	f4843783          	ld	a5,-184(s0)
ffffffe000202f80:	00878713          	addi	a4,a5,8
ffffffe000202f84:	f4e43423          	sd	a4,-184(s0)
ffffffe000202f88:	0007b783          	ld	a5,0(a5)
ffffffe000202f8c:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe000202f90:	fb843783          	ld	a5,-72(s0)
ffffffe000202f94:	fec42703          	lw	a4,-20(s0)
ffffffe000202f98:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000202f9c:	f8040023          	sb	zero,-128(s0)
ffffffe000202fa0:	1500006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe000202fa4:	f5043783          	ld	a5,-176(s0)
ffffffe000202fa8:	0007c783          	lbu	a5,0(a5)
ffffffe000202fac:	00078713          	mv	a4,a5
ffffffe000202fb0:	07300793          	li	a5,115
ffffffe000202fb4:	02f71e63          	bne	a4,a5,ffffffe000202ff0 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000202fb8:	f4843783          	ld	a5,-184(s0)
ffffffe000202fbc:	00878713          	addi	a4,a5,8
ffffffe000202fc0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202fc4:	0007b783          	ld	a5,0(a5)
ffffffe000202fc8:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000202fcc:	fc043583          	ld	a1,-64(s0)
ffffffe000202fd0:	f5843503          	ld	a0,-168(s0)
ffffffe000202fd4:	dccff0ef          	jal	ra,ffffffe0002025a0 <puts_wo_nl>
ffffffe000202fd8:	00050793          	mv	a5,a0
ffffffe000202fdc:	fec42703          	lw	a4,-20(s0)
ffffffe000202fe0:	00f707bb          	addw	a5,a4,a5
ffffffe000202fe4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202fe8:	f8040023          	sb	zero,-128(s0)
ffffffe000202fec:	1040006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000202ff0:	f5043783          	ld	a5,-176(s0)
ffffffe000202ff4:	0007c783          	lbu	a5,0(a5)
ffffffe000202ff8:	00078713          	mv	a4,a5
ffffffe000202ffc:	06300793          	li	a5,99
ffffffe000203000:	02f71e63          	bne	a4,a5,ffffffe00020303c <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000203004:	f4843783          	ld	a5,-184(s0)
ffffffe000203008:	00878713          	addi	a4,a5,8
ffffffe00020300c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203010:	0007a783          	lw	a5,0(a5)
ffffffe000203014:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000203018:	fcc42703          	lw	a4,-52(s0)
ffffffe00020301c:	f5843783          	ld	a5,-168(s0)
ffffffe000203020:	00070513          	mv	a0,a4
ffffffe000203024:	000780e7          	jalr	a5
                ++written;
ffffffe000203028:	fec42783          	lw	a5,-20(s0)
ffffffe00020302c:	0017879b          	addiw	a5,a5,1
ffffffe000203030:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203034:	f8040023          	sb	zero,-128(s0)
ffffffe000203038:	0b80006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe00020303c:	f5043783          	ld	a5,-176(s0)
ffffffe000203040:	0007c783          	lbu	a5,0(a5)
ffffffe000203044:	00078713          	mv	a4,a5
ffffffe000203048:	02500793          	li	a5,37
ffffffe00020304c:	02f71263          	bne	a4,a5,ffffffe000203070 <vprintfmt+0x740>
                putch('%');
ffffffe000203050:	f5843783          	ld	a5,-168(s0)
ffffffe000203054:	02500513          	li	a0,37
ffffffe000203058:	000780e7          	jalr	a5
                ++written;
ffffffe00020305c:	fec42783          	lw	a5,-20(s0)
ffffffe000203060:	0017879b          	addiw	a5,a5,1
ffffffe000203064:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203068:	f8040023          	sb	zero,-128(s0)
ffffffe00020306c:	0840006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe000203070:	f5043783          	ld	a5,-176(s0)
ffffffe000203074:	0007c783          	lbu	a5,0(a5)
ffffffe000203078:	0007871b          	sext.w	a4,a5
ffffffe00020307c:	f5843783          	ld	a5,-168(s0)
ffffffe000203080:	00070513          	mv	a0,a4
ffffffe000203084:	000780e7          	jalr	a5
                ++written;
ffffffe000203088:	fec42783          	lw	a5,-20(s0)
ffffffe00020308c:	0017879b          	addiw	a5,a5,1
ffffffe000203090:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203094:	f8040023          	sb	zero,-128(s0)
ffffffe000203098:	0580006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe00020309c:	f5043783          	ld	a5,-176(s0)
ffffffe0002030a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002030a4:	00078713          	mv	a4,a5
ffffffe0002030a8:	02500793          	li	a5,37
ffffffe0002030ac:	02f71063          	bne	a4,a5,ffffffe0002030cc <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe0002030b0:	f8043023          	sd	zero,-128(s0)
ffffffe0002030b4:	f8043423          	sd	zero,-120(s0)
ffffffe0002030b8:	00100793          	li	a5,1
ffffffe0002030bc:	f8f40023          	sb	a5,-128(s0)
ffffffe0002030c0:	fff00793          	li	a5,-1
ffffffe0002030c4:	f8f42623          	sw	a5,-116(s0)
ffffffe0002030c8:	0280006f          	j	ffffffe0002030f0 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe0002030cc:	f5043783          	ld	a5,-176(s0)
ffffffe0002030d0:	0007c783          	lbu	a5,0(a5)
ffffffe0002030d4:	0007871b          	sext.w	a4,a5
ffffffe0002030d8:	f5843783          	ld	a5,-168(s0)
ffffffe0002030dc:	00070513          	mv	a0,a4
ffffffe0002030e0:	000780e7          	jalr	a5
            ++written;
ffffffe0002030e4:	fec42783          	lw	a5,-20(s0)
ffffffe0002030e8:	0017879b          	addiw	a5,a5,1
ffffffe0002030ec:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe0002030f0:	f5043783          	ld	a5,-176(s0)
ffffffe0002030f4:	00178793          	addi	a5,a5,1
ffffffe0002030f8:	f4f43823          	sd	a5,-176(s0)
ffffffe0002030fc:	f5043783          	ld	a5,-176(s0)
ffffffe000203100:	0007c783          	lbu	a5,0(a5)
ffffffe000203104:	84079ce3          	bnez	a5,ffffffe00020295c <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000203108:	fec42783          	lw	a5,-20(s0)
}
ffffffe00020310c:	00078513          	mv	a0,a5
ffffffe000203110:	0b813083          	ld	ra,184(sp)
ffffffe000203114:	0b013403          	ld	s0,176(sp)
ffffffe000203118:	0c010113          	addi	sp,sp,192
ffffffe00020311c:	00008067          	ret

ffffffe000203120 <printk>:

int printk(const char* s, ...) {
ffffffe000203120:	f9010113          	addi	sp,sp,-112
ffffffe000203124:	02113423          	sd	ra,40(sp)
ffffffe000203128:	02813023          	sd	s0,32(sp)
ffffffe00020312c:	03010413          	addi	s0,sp,48
ffffffe000203130:	fca43c23          	sd	a0,-40(s0)
ffffffe000203134:	00b43423          	sd	a1,8(s0)
ffffffe000203138:	00c43823          	sd	a2,16(s0)
ffffffe00020313c:	00d43c23          	sd	a3,24(s0)
ffffffe000203140:	02e43023          	sd	a4,32(s0)
ffffffe000203144:	02f43423          	sd	a5,40(s0)
ffffffe000203148:	03043823          	sd	a6,48(s0)
ffffffe00020314c:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000203150:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000203154:	04040793          	addi	a5,s0,64
ffffffe000203158:	fcf43823          	sd	a5,-48(s0)
ffffffe00020315c:	fd043783          	ld	a5,-48(s0)
ffffffe000203160:	fc878793          	addi	a5,a5,-56
ffffffe000203164:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000203168:	fe043783          	ld	a5,-32(s0)
ffffffe00020316c:	00078613          	mv	a2,a5
ffffffe000203170:	fd843583          	ld	a1,-40(s0)
ffffffe000203174:	fffff517          	auipc	a0,0xfffff
ffffffe000203178:	11850513          	addi	a0,a0,280 # ffffffe00020228c <putc>
ffffffe00020317c:	fb4ff0ef          	jal	ra,ffffffe000202930 <vprintfmt>
ffffffe000203180:	00050793          	mv	a5,a0
ffffffe000203184:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000203188:	fec42783          	lw	a5,-20(s0)
}
ffffffe00020318c:	00078513          	mv	a0,a5
ffffffe000203190:	02813083          	ld	ra,40(sp)
ffffffe000203194:	02013403          	ld	s0,32(sp)
ffffffe000203198:	07010113          	addi	sp,sp,112
ffffffe00020319c:	00008067          	ret

ffffffe0002031a0 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe0002031a0:	fe010113          	addi	sp,sp,-32
ffffffe0002031a4:	00813c23          	sd	s0,24(sp)
ffffffe0002031a8:	02010413          	addi	s0,sp,32
ffffffe0002031ac:	00050793          	mv	a5,a0
ffffffe0002031b0:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe0002031b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002031b8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002031bc:	0007879b          	sext.w	a5,a5
ffffffe0002031c0:	02079713          	slli	a4,a5,0x20
ffffffe0002031c4:	02075713          	srli	a4,a4,0x20
ffffffe0002031c8:	00006797          	auipc	a5,0x6
ffffffe0002031cc:	e5078793          	addi	a5,a5,-432 # ffffffe000209018 <seed>
ffffffe0002031d0:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002031d4:	00000013          	nop
ffffffe0002031d8:	01813403          	ld	s0,24(sp)
ffffffe0002031dc:	02010113          	addi	sp,sp,32
ffffffe0002031e0:	00008067          	ret

ffffffe0002031e4 <rand>:

int rand(void) {
ffffffe0002031e4:	ff010113          	addi	sp,sp,-16
ffffffe0002031e8:	00813423          	sd	s0,8(sp)
ffffffe0002031ec:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe0002031f0:	00006797          	auipc	a5,0x6
ffffffe0002031f4:	e2878793          	addi	a5,a5,-472 # ffffffe000209018 <seed>
ffffffe0002031f8:	0007b703          	ld	a4,0(a5)
ffffffe0002031fc:	00001797          	auipc	a5,0x1
ffffffe000203200:	37478793          	addi	a5,a5,884 # ffffffe000204570 <lowerxdigits.0+0x18>
ffffffe000203204:	0007b783          	ld	a5,0(a5)
ffffffe000203208:	02f707b3          	mul	a5,a4,a5
ffffffe00020320c:	00178713          	addi	a4,a5,1
ffffffe000203210:	00006797          	auipc	a5,0x6
ffffffe000203214:	e0878793          	addi	a5,a5,-504 # ffffffe000209018 <seed>
ffffffe000203218:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe00020321c:	00006797          	auipc	a5,0x6
ffffffe000203220:	dfc78793          	addi	a5,a5,-516 # ffffffe000209018 <seed>
ffffffe000203224:	0007b783          	ld	a5,0(a5)
ffffffe000203228:	0217d793          	srli	a5,a5,0x21
ffffffe00020322c:	0007879b          	sext.w	a5,a5
}
ffffffe000203230:	00078513          	mv	a0,a5
ffffffe000203234:	00813403          	ld	s0,8(sp)
ffffffe000203238:	01010113          	addi	sp,sp,16
ffffffe00020323c:	00008067          	ret

ffffffe000203240 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000203240:	fc010113          	addi	sp,sp,-64
ffffffe000203244:	02813c23          	sd	s0,56(sp)
ffffffe000203248:	04010413          	addi	s0,sp,64
ffffffe00020324c:	fca43c23          	sd	a0,-40(s0)
ffffffe000203250:	00058793          	mv	a5,a1
ffffffe000203254:	fcc43423          	sd	a2,-56(s0)
ffffffe000203258:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe00020325c:	fd843783          	ld	a5,-40(s0)
ffffffe000203260:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203264:	fe043423          	sd	zero,-24(s0)
ffffffe000203268:	0280006f          	j	ffffffe000203290 <memset+0x50>
        s[i] = c;
ffffffe00020326c:	fe043703          	ld	a4,-32(s0)
ffffffe000203270:	fe843783          	ld	a5,-24(s0)
ffffffe000203274:	00f707b3          	add	a5,a4,a5
ffffffe000203278:	fd442703          	lw	a4,-44(s0)
ffffffe00020327c:	0ff77713          	zext.b	a4,a4
ffffffe000203280:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203284:	fe843783          	ld	a5,-24(s0)
ffffffe000203288:	00178793          	addi	a5,a5,1
ffffffe00020328c:	fef43423          	sd	a5,-24(s0)
ffffffe000203290:	fe843703          	ld	a4,-24(s0)
ffffffe000203294:	fc843783          	ld	a5,-56(s0)
ffffffe000203298:	fcf76ae3          	bltu	a4,a5,ffffffe00020326c <memset+0x2c>
    }
    return dest;
ffffffe00020329c:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002032a0:	00078513          	mv	a0,a5
ffffffe0002032a4:	03813403          	ld	s0,56(sp)
ffffffe0002032a8:	04010113          	addi	sp,sp,64
ffffffe0002032ac:	00008067          	ret

ffffffe0002032b0 <memcpy>:

void *memcpy(void *dest, const void *src, uint64_t n) {
ffffffe0002032b0:	fb010113          	addi	sp,sp,-80
ffffffe0002032b4:	04813423          	sd	s0,72(sp)
ffffffe0002032b8:	05010413          	addi	s0,sp,80
ffffffe0002032bc:	fca43423          	sd	a0,-56(s0)
ffffffe0002032c0:	fcb43023          	sd	a1,-64(s0)
ffffffe0002032c4:	fac43c23          	sd	a2,-72(s0)
    char *d = (char *)dest;
ffffffe0002032c8:	fc843783          	ld	a5,-56(s0)
ffffffe0002032cc:	fef43023          	sd	a5,-32(s0)
    const char *s = (const char *)src;
ffffffe0002032d0:	fc043783          	ld	a5,-64(s0)
ffffffe0002032d4:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002032d8:	fe043423          	sd	zero,-24(s0)
ffffffe0002032dc:	0300006f          	j	ffffffe00020330c <memcpy+0x5c>
        d[i] = s[i];
ffffffe0002032e0:	fd843703          	ld	a4,-40(s0)
ffffffe0002032e4:	fe843783          	ld	a5,-24(s0)
ffffffe0002032e8:	00f70733          	add	a4,a4,a5
ffffffe0002032ec:	fe043683          	ld	a3,-32(s0)
ffffffe0002032f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002032f4:	00f687b3          	add	a5,a3,a5
ffffffe0002032f8:	00074703          	lbu	a4,0(a4)
ffffffe0002032fc:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203300:	fe843783          	ld	a5,-24(s0)
ffffffe000203304:	00178793          	addi	a5,a5,1
ffffffe000203308:	fef43423          	sd	a5,-24(s0)
ffffffe00020330c:	fe843703          	ld	a4,-24(s0)
ffffffe000203310:	fb843783          	ld	a5,-72(s0)
ffffffe000203314:	fcf766e3          	bltu	a4,a5,ffffffe0002032e0 <memcpy+0x30>
    }
    return dest;
ffffffe000203318:	fc843783          	ld	a5,-56(s0)
}
ffffffe00020331c:	00078513          	mv	a0,a5
ffffffe000203320:	04813403          	ld	s0,72(sp)
ffffffe000203324:	05010113          	addi	sp,sp,80
ffffffe000203328:	00008067          	ret
