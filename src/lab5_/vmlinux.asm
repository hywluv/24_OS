
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
ffffffe000200008:	314020ef          	jal	ra,ffffffe00020231c <setup_vm>
    call relocate
ffffffe00020000c:	044000ef          	jal	ra,ffffffe000200050 <relocate>
    call mm_init
ffffffe000200010:	295000ef          	jal	ra,ffffffe000200aa4 <mm_init>
    call setup_vm_final
ffffffe000200014:	4d0020ef          	jal	ra,ffffffe0002024e4 <setup_vm_final>
    call task_init
ffffffe000200018:	585000ef          	jal	ra,ffffffe000200d9c <task_init>

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
ffffffe00020004c:	255020ef          	jal	ra,ffffffe000202aa0 <start_kernel>

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

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    csrrw sp, sscratch, sp
ffffffe000200094:	14011173          	csrrw	sp,sscratch,sp
    bne sp, zero, 1f
ffffffe000200098:	00011463          	bnez	sp,ffffffe0002000a0 <_traps+0xc>
    csrrw sp, sscratch, sp
ffffffe00020009c:	14011173          	csrrw	sp,sscratch,sp
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap
1:
    addi sp, sp, -33*8
ffffffe0002000a0:	ef810113          	addi	sp,sp,-264 # ffffffe000208ef8 <_sbss+0xef8>
    sd ra, 0*8(sp)
ffffffe0002000a4:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
ffffffe0002000a8:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
ffffffe0002000ac:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
ffffffe0002000b0:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
ffffffe0002000b4:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
ffffffe0002000b8:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
ffffffe0002000bc:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
ffffffe0002000c0:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
ffffffe0002000c4:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
ffffffe0002000c8:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
ffffffe0002000cc:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
ffffffe0002000d0:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
ffffffe0002000d4:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
ffffffe0002000d8:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
ffffffe0002000dc:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
ffffffe0002000e0:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
ffffffe0002000e4:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
ffffffe0002000e8:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
ffffffe0002000ec:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
ffffffe0002000f0:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
ffffffe0002000f4:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
ffffffe0002000f8:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
ffffffe0002000fc:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
ffffffe000200100:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
ffffffe000200104:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
ffffffe000200108:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
ffffffe00020010c:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
ffffffe000200110:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
ffffffe000200114:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
ffffffe000200118:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
ffffffe00020011c:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
ffffffe000200120:	0e513823          	sd	t0,240(sp)
    csrr t0, sstatus
ffffffe000200124:	100022f3          	csrr	t0,sstatus
    sd t0, 31*8(sp)
ffffffe000200128:	0e513c23          	sd	t0,248(sp)
    sd sp, 32*8(sp)
ffffffe00020012c:	10213023          	sd	sp,256(sp)

    csrr a0, scause
ffffffe000200130:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe000200134:	141025f3          	csrr	a1,sepc
    mv a2, sp
ffffffe000200138:	00010613          	mv	a2,sp
    call trap_handler
ffffffe00020013c:	429010ef          	jal	ra,ffffffe000201d64 <trap_handler>

ffffffe000200140 <__ret_from_fork>:

    .globl __ret_from_fork
__ret_from_fork:

    ld sp, 32*8(sp)
ffffffe000200140:	10013103          	ld	sp,256(sp)
    ld t0, 31*8(sp)
ffffffe000200144:	0f813283          	ld	t0,248(sp)
    csrw sstatus, t0
ffffffe000200148:	10029073          	csrw	sstatus,t0
    ld t0, 30*8(sp)
ffffffe00020014c:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
ffffffe000200150:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
ffffffe000200154:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
ffffffe000200158:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
ffffffe00020015c:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
ffffffe000200160:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
ffffffe000200164:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
ffffffe000200168:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
ffffffe00020016c:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
ffffffe000200170:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
ffffffe000200174:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
ffffffe000200178:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
ffffffe00020017c:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
ffffffe000200180:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
ffffffe000200184:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
ffffffe000200188:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
ffffffe00020018c:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
ffffffe000200190:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
ffffffe000200194:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
ffffffe000200198:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
ffffffe00020019c:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
ffffffe0002001a0:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
ffffffe0002001a4:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
ffffffe0002001a8:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
ffffffe0002001ac:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
ffffffe0002001b0:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
ffffffe0002001b4:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
ffffffe0002001b8:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
ffffffe0002001bc:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
ffffffe0002001c0:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
ffffffe0002001c4:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
ffffffe0002001c8:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
ffffffe0002001cc:	10810113          	addi	sp,sp,264

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    csrrw sp, sscratch, sp     # 交换 sp 和 sscratch
ffffffe0002001d0:	14011173          	csrrw	sp,sscratch,sp
    bne sp, zero, 1f           # 如果 sp 不为零，跳转到标签 1f
ffffffe0002001d4:	00011463          	bnez	sp,ffffffe0002001dc <__ret_from_fork+0x9c>
    csrrw sp, sscratch, sp     # 再次交换 sp 和 sscratch
ffffffe0002001d8:	14011173          	csrrw	sp,sscratch,sp

1:
    sret
ffffffe0002001dc:	10200073          	sret

ffffffe0002001e0 <__dummy>:

    .globl __dummy
__dummy:
    add t0, sp, zero
ffffffe0002001e0:	000102b3          	add	t0,sp,zero
    csrr sp, sscratch
ffffffe0002001e4:	14002173          	csrr	sp,sscratch
    csrw sscratch, t0
ffffffe0002001e8:	14029073          	csrw	sscratch,t0
    sret
ffffffe0002001ec:	10200073          	sret

ffffffe0002001f0 <__switch_to>:

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
ffffffe0002001f0:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
ffffffe0002001f4:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
ffffffe0002001f8:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
ffffffe0002001fc:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
ffffffe000200200:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
ffffffe000200204:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
ffffffe000200208:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
ffffffe00020020c:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
ffffffe000200210:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
ffffffe000200214:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
ffffffe000200218:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
ffffffe00020021c:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
ffffffe000200220:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
ffffffe000200224:	07b53423          	sd	s11,104(a0)

    csrr t0, sepc
ffffffe000200228:	141022f3          	csrr	t0,sepc
    sd t0, 112(a0)
ffffffe00020022c:	06553823          	sd	t0,112(a0)

    csrr t0, sstatus
ffffffe000200230:	100022f3          	csrr	t0,sstatus
    sd t0, 120(a0)
ffffffe000200234:	06553c23          	sd	t0,120(a0)

    csrr t0, sscratch
ffffffe000200238:	140022f3          	csrr	t0,sscratch
    sd t0, 128(a0)
ffffffe00020023c:	08553023          	sd	t0,128(a0)

    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
ffffffe000200240:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
ffffffe000200244:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
ffffffe000200248:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
ffffffe00020024c:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
ffffffe000200250:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
ffffffe000200254:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
ffffffe000200258:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
ffffffe00020025c:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
ffffffe000200260:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
ffffffe000200264:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
ffffffe000200268:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
ffffffe00020026c:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
ffffffe000200270:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
ffffffe000200274:	0685bd83          	ld	s11,104(a1)

    ld t0, 112(a1)
ffffffe000200278:	0705b283          	ld	t0,112(a1)
    csrw sepc, t0
ffffffe00020027c:	14129073          	csrw	sepc,t0

    ld t0, 120(a1)
ffffffe000200280:	0785b283          	ld	t0,120(a1)
    csrw sstatus, t0
ffffffe000200284:	10029073          	csrw	sstatus,t0

    ld t0, 128(a1)
ffffffe000200288:	0805b283          	ld	t0,128(a1)
    csrw sscratch, t0
ffffffe00020028c:	14029073          	csrw	sscratch,t0

    csrw satp, a2
ffffffe000200290:	18061073          	csrw	satp,a2

    sfence.vma zero, zero
ffffffe000200294:	12000073          	sfence.vma
    fence.i
ffffffe000200298:	0000100f          	fence.i

ffffffe00020029c:	00008067          	ret

ffffffe0002002a0 <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe0002002a0:	fe010113          	addi	sp,sp,-32
ffffffe0002002a4:	00813c23          	sd	s0,24(sp)
ffffffe0002002a8:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe0002002ac:	c01027f3          	rdtime	a5
ffffffe0002002b0:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe0002002b4:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002b8:	00078513          	mv	a0,a5
ffffffe0002002bc:	01813403          	ld	s0,24(sp)
ffffffe0002002c0:	02010113          	addi	sp,sp,32
ffffffe0002002c4:	00008067          	ret

ffffffe0002002c8 <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
ffffffe0002002c8:	fe010113          	addi	sp,sp,-32
ffffffe0002002cc:	00813c23          	sd	s0,24(sp)
ffffffe0002002d0:	02010413          	addi	s0,sp,32
ffffffe0002002d4:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
ffffffe0002002d8:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
ffffffe0002002dc:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
ffffffe0002002e0:	00000073          	ecall
}
ffffffe0002002e4:	00000013          	nop
ffffffe0002002e8:	01813403          	ld	s0,24(sp)
ffffffe0002002ec:	02010113          	addi	sp,sp,32
ffffffe0002002f0:	00008067          	ret

ffffffe0002002f4 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe0002002f4:	fe010113          	addi	sp,sp,-32
ffffffe0002002f8:	00113c23          	sd	ra,24(sp)
ffffffe0002002fc:	00813823          	sd	s0,16(sp)
ffffffe000200300:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe000200304:	f9dff0ef          	jal	ra,ffffffe0002002a0 <get_cycles>
ffffffe000200308:	00050713          	mv	a4,a0
ffffffe00020030c:	00005797          	auipc	a5,0x5
ffffffe000200310:	cf478793          	addi	a5,a5,-780 # ffffffe000205000 <TIMECLOCK>
ffffffe000200314:	0007b783          	ld	a5,0(a5)
ffffffe000200318:	00f707b3          	add	a5,a4,a5
ffffffe00020031c:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe000200320:	fe843503          	ld	a0,-24(s0)
ffffffe000200324:	fa5ff0ef          	jal	ra,ffffffe0002002c8 <sbi_set_timer>
ffffffe000200328:	00000013          	nop
ffffffe00020032c:	01813083          	ld	ra,24(sp)
ffffffe000200330:	01013403          	ld	s0,16(sp)
ffffffe000200334:	02010113          	addi	sp,sp,32
ffffffe000200338:	00008067          	ret

ffffffe00020033c <fixsize>:
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size) {
ffffffe00020033c:	fe010113          	addi	sp,sp,-32
ffffffe000200340:	00813c23          	sd	s0,24(sp)
ffffffe000200344:	02010413          	addi	s0,sp,32
ffffffe000200348:	fea43423          	sd	a0,-24(s0)
    size --;
ffffffe00020034c:	fe843783          	ld	a5,-24(s0)
ffffffe000200350:	fff78793          	addi	a5,a5,-1
ffffffe000200354:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe000200358:	fe843783          	ld	a5,-24(s0)
ffffffe00020035c:	0017d793          	srli	a5,a5,0x1
ffffffe000200360:	fe843703          	ld	a4,-24(s0)
ffffffe000200364:	00f767b3          	or	a5,a4,a5
ffffffe000200368:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe00020036c:	fe843783          	ld	a5,-24(s0)
ffffffe000200370:	0027d793          	srli	a5,a5,0x2
ffffffe000200374:	fe843703          	ld	a4,-24(s0)
ffffffe000200378:	00f767b3          	or	a5,a4,a5
ffffffe00020037c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe000200380:	fe843783          	ld	a5,-24(s0)
ffffffe000200384:	0047d793          	srli	a5,a5,0x4
ffffffe000200388:	fe843703          	ld	a4,-24(s0)
ffffffe00020038c:	00f767b3          	or	a5,a4,a5
ffffffe000200390:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe000200394:	fe843783          	ld	a5,-24(s0)
ffffffe000200398:	0087d793          	srli	a5,a5,0x8
ffffffe00020039c:	fe843703          	ld	a4,-24(s0)
ffffffe0002003a0:	00f767b3          	or	a5,a4,a5
ffffffe0002003a4:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe0002003a8:	fe843783          	ld	a5,-24(s0)
ffffffe0002003ac:	0107d793          	srli	a5,a5,0x10
ffffffe0002003b0:	fe843703          	ld	a4,-24(s0)
ffffffe0002003b4:	00f767b3          	or	a5,a4,a5
ffffffe0002003b8:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe0002003bc:	fe843783          	ld	a5,-24(s0)
ffffffe0002003c0:	0207d793          	srli	a5,a5,0x20
ffffffe0002003c4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003c8:	00f767b3          	or	a5,a4,a5
ffffffe0002003cc:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe0002003d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003d4:	00178793          	addi	a5,a5,1
}
ffffffe0002003d8:	00078513          	mv	a0,a5
ffffffe0002003dc:	01813403          	ld	s0,24(sp)
ffffffe0002003e0:	02010113          	addi	sp,sp,32
ffffffe0002003e4:	00008067          	ret

ffffffe0002003e8 <buddy_init>:

void buddy_init() {
ffffffe0002003e8:	fd010113          	addi	sp,sp,-48
ffffffe0002003ec:	02113423          	sd	ra,40(sp)
ffffffe0002003f0:	02813023          	sd	s0,32(sp)
ffffffe0002003f4:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe0002003f8:	000087b7          	lui	a5,0x8
ffffffe0002003fc:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe000200400:	fe843783          	ld	a5,-24(s0)
ffffffe000200404:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe000200408:	fe843783          	ld	a5,-24(s0)
ffffffe00020040c:	00f777b3          	and	a5,a4,a5
ffffffe000200410:	00078863          	beqz	a5,ffffffe000200420 <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe000200414:	fe843503          	ld	a0,-24(s0)
ffffffe000200418:	f25ff0ef          	jal	ra,ffffffe00020033c <fixsize>
ffffffe00020041c:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe000200420:	00009797          	auipc	a5,0x9
ffffffe000200424:	c0878793          	addi	a5,a5,-1016 # ffffffe000209028 <buddy>
ffffffe000200428:	fe843703          	ld	a4,-24(s0)
ffffffe00020042c:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe000200430:	00005797          	auipc	a5,0x5
ffffffe000200434:	bd878793          	addi	a5,a5,-1064 # ffffffe000205008 <free_page_start>
ffffffe000200438:	0007b703          	ld	a4,0(a5)
ffffffe00020043c:	00009797          	auipc	a5,0x9
ffffffe000200440:	bec78793          	addi	a5,a5,-1044 # ffffffe000209028 <buddy>
ffffffe000200444:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200448:	00005797          	auipc	a5,0x5
ffffffe00020044c:	bc078793          	addi	a5,a5,-1088 # ffffffe000205008 <free_page_start>
ffffffe000200450:	0007b703          	ld	a4,0(a5)
ffffffe000200454:	00009797          	auipc	a5,0x9
ffffffe000200458:	bd478793          	addi	a5,a5,-1068 # ffffffe000209028 <buddy>
ffffffe00020045c:	0007b783          	ld	a5,0(a5)
ffffffe000200460:	00479793          	slli	a5,a5,0x4
ffffffe000200464:	00f70733          	add	a4,a4,a5
ffffffe000200468:	00005797          	auipc	a5,0x5
ffffffe00020046c:	ba078793          	addi	a5,a5,-1120 # ffffffe000205008 <free_page_start>
ffffffe000200470:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe000200474:	00009797          	auipc	a5,0x9
ffffffe000200478:	bb478793          	addi	a5,a5,-1100 # ffffffe000209028 <buddy>
ffffffe00020047c:	0087b703          	ld	a4,8(a5)
ffffffe000200480:	00009797          	auipc	a5,0x9
ffffffe000200484:	ba878793          	addi	a5,a5,-1112 # ffffffe000209028 <buddy>
ffffffe000200488:	0007b783          	ld	a5,0(a5)
ffffffe00020048c:	00479793          	slli	a5,a5,0x4
ffffffe000200490:	00078613          	mv	a2,a5
ffffffe000200494:	00000593          	li	a1,0
ffffffe000200498:	00070513          	mv	a0,a4
ffffffe00020049c:	0d5030ef          	jal	ra,ffffffe000203d70 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe0002004a0:	00009797          	auipc	a5,0x9
ffffffe0002004a4:	b8878793          	addi	a5,a5,-1144 # ffffffe000209028 <buddy>
ffffffe0002004a8:	0007b783          	ld	a5,0(a5)
ffffffe0002004ac:	00179793          	slli	a5,a5,0x1
ffffffe0002004b0:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004b4:	fc043c23          	sd	zero,-40(s0)
ffffffe0002004b8:	0500006f          	j	ffffffe000200508 <buddy_init+0x120>
        if (IS_POWER_OF_2(i + 1))
ffffffe0002004bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002004c0:	00178713          	addi	a4,a5,1
ffffffe0002004c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002004c8:	00f777b3          	and	a5,a4,a5
ffffffe0002004cc:	00079863          	bnez	a5,ffffffe0002004dc <buddy_init+0xf4>
            node_size /= 2;
ffffffe0002004d0:	fe043783          	ld	a5,-32(s0)
ffffffe0002004d4:	0017d793          	srli	a5,a5,0x1
ffffffe0002004d8:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe0002004dc:	00009797          	auipc	a5,0x9
ffffffe0002004e0:	b4c78793          	addi	a5,a5,-1204 # ffffffe000209028 <buddy>
ffffffe0002004e4:	0087b703          	ld	a4,8(a5)
ffffffe0002004e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002004ec:	00379793          	slli	a5,a5,0x3
ffffffe0002004f0:	00f707b3          	add	a5,a4,a5
ffffffe0002004f4:	fe043703          	ld	a4,-32(s0)
ffffffe0002004f8:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004fc:	fd843783          	ld	a5,-40(s0)
ffffffe000200500:	00178793          	addi	a5,a5,1
ffffffe000200504:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200508:	00009797          	auipc	a5,0x9
ffffffe00020050c:	b2078793          	addi	a5,a5,-1248 # ffffffe000209028 <buddy>
ffffffe000200510:	0007b783          	ld	a5,0(a5)
ffffffe000200514:	00179793          	slli	a5,a5,0x1
ffffffe000200518:	fff78793          	addi	a5,a5,-1
ffffffe00020051c:	fd843703          	ld	a4,-40(s0)
ffffffe000200520:	f8f76ee3          	bltu	a4,a5,ffffffe0002004bc <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200524:	fc043823          	sd	zero,-48(s0)
ffffffe000200528:	0180006f          	j	ffffffe000200540 <buddy_init+0x158>
        buddy_alloc(1);
ffffffe00020052c:	00100513          	li	a0,1
ffffffe000200530:	1fc000ef          	jal	ra,ffffffe00020072c <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200534:	fd043783          	ld	a5,-48(s0)
ffffffe000200538:	00178793          	addi	a5,a5,1
ffffffe00020053c:	fcf43823          	sd	a5,-48(s0)
ffffffe000200540:	fd043783          	ld	a5,-48(s0)
ffffffe000200544:	00c79713          	slli	a4,a5,0xc
ffffffe000200548:	00100793          	li	a5,1
ffffffe00020054c:	01f79793          	slli	a5,a5,0x1f
ffffffe000200550:	00f70733          	add	a4,a4,a5
ffffffe000200554:	00005797          	auipc	a5,0x5
ffffffe000200558:	ab478793          	addi	a5,a5,-1356 # ffffffe000205008 <free_page_start>
ffffffe00020055c:	0007b783          	ld	a5,0(a5)
ffffffe000200560:	00078693          	mv	a3,a5
ffffffe000200564:	04100793          	li	a5,65
ffffffe000200568:	01f79793          	slli	a5,a5,0x1f
ffffffe00020056c:	00f687b3          	add	a5,a3,a5
ffffffe000200570:	faf76ee3          	bltu	a4,a5,ffffffe00020052c <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe000200574:	00004517          	auipc	a0,0x4
ffffffe000200578:	a9450513          	addi	a0,a0,-1388 # ffffffe000204008 <__func__.0+0x8>
ffffffe00020057c:	6d4030ef          	jal	ra,ffffffe000203c50 <printk>
    return;
ffffffe000200580:	00000013          	nop
}
ffffffe000200584:	02813083          	ld	ra,40(sp)
ffffffe000200588:	02013403          	ld	s0,32(sp)
ffffffe00020058c:	03010113          	addi	sp,sp,48
ffffffe000200590:	00008067          	ret

ffffffe000200594 <buddy_free>:

void buddy_free(uint64_t pfn) {
ffffffe000200594:	fc010113          	addi	sp,sp,-64
ffffffe000200598:	02813c23          	sd	s0,56(sp)
ffffffe00020059c:	04010413          	addi	s0,sp,64
ffffffe0002005a0:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe0002005a4:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe0002005a8:	00100793          	li	a5,1
ffffffe0002005ac:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe0002005b0:	00009797          	auipc	a5,0x9
ffffffe0002005b4:	a7878793          	addi	a5,a5,-1416 # ffffffe000209028 <buddy>
ffffffe0002005b8:	0007b703          	ld	a4,0(a5)
ffffffe0002005bc:	fc843783          	ld	a5,-56(s0)
ffffffe0002005c0:	00f707b3          	add	a5,a4,a5
ffffffe0002005c4:	fff78793          	addi	a5,a5,-1
ffffffe0002005c8:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005cc:	02c0006f          	j	ffffffe0002005f8 <buddy_free+0x64>
        node_size *= 2;
ffffffe0002005d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002005d4:	00179793          	slli	a5,a5,0x1
ffffffe0002005d8:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe0002005dc:	fe043783          	ld	a5,-32(s0)
ffffffe0002005e0:	02078e63          	beqz	a5,ffffffe00020061c <buddy_free+0x88>
    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005e4:	fe043783          	ld	a5,-32(s0)
ffffffe0002005e8:	00178793          	addi	a5,a5,1
ffffffe0002005ec:	0017d793          	srli	a5,a5,0x1
ffffffe0002005f0:	fff78793          	addi	a5,a5,-1
ffffffe0002005f4:	fef43023          	sd	a5,-32(s0)
ffffffe0002005f8:	00009797          	auipc	a5,0x9
ffffffe0002005fc:	a3078793          	addi	a5,a5,-1488 # ffffffe000209028 <buddy>
ffffffe000200600:	0087b703          	ld	a4,8(a5)
ffffffe000200604:	fe043783          	ld	a5,-32(s0)
ffffffe000200608:	00379793          	slli	a5,a5,0x3
ffffffe00020060c:	00f707b3          	add	a5,a4,a5
ffffffe000200610:	0007b783          	ld	a5,0(a5)
ffffffe000200614:	fa079ee3          	bnez	a5,ffffffe0002005d0 <buddy_free+0x3c>
ffffffe000200618:	0080006f          	j	ffffffe000200620 <buddy_free+0x8c>
            break;
ffffffe00020061c:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe000200620:	00009797          	auipc	a5,0x9
ffffffe000200624:	a0878793          	addi	a5,a5,-1528 # ffffffe000209028 <buddy>
ffffffe000200628:	0087b703          	ld	a4,8(a5)
ffffffe00020062c:	fe043783          	ld	a5,-32(s0)
ffffffe000200630:	00379793          	slli	a5,a5,0x3
ffffffe000200634:	00f707b3          	add	a5,a4,a5
ffffffe000200638:	fe843703          	ld	a4,-24(s0)
ffffffe00020063c:	00e7b023          	sd	a4,0(a5)

    while (index) {
ffffffe000200640:	0d00006f          	j	ffffffe000200710 <buddy_free+0x17c>
        index = PARENT(index);
ffffffe000200644:	fe043783          	ld	a5,-32(s0)
ffffffe000200648:	00178793          	addi	a5,a5,1
ffffffe00020064c:	0017d793          	srli	a5,a5,0x1
ffffffe000200650:	fff78793          	addi	a5,a5,-1
ffffffe000200654:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe000200658:	fe843783          	ld	a5,-24(s0)
ffffffe00020065c:	00179793          	slli	a5,a5,0x1
ffffffe000200660:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe000200664:	00009797          	auipc	a5,0x9
ffffffe000200668:	9c478793          	addi	a5,a5,-1596 # ffffffe000209028 <buddy>
ffffffe00020066c:	0087b703          	ld	a4,8(a5)
ffffffe000200670:	fe043783          	ld	a5,-32(s0)
ffffffe000200674:	00479793          	slli	a5,a5,0x4
ffffffe000200678:	00878793          	addi	a5,a5,8
ffffffe00020067c:	00f707b3          	add	a5,a4,a5
ffffffe000200680:	0007b783          	ld	a5,0(a5)
ffffffe000200684:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe000200688:	00009797          	auipc	a5,0x9
ffffffe00020068c:	9a078793          	addi	a5,a5,-1632 # ffffffe000209028 <buddy>
ffffffe000200690:	0087b703          	ld	a4,8(a5)
ffffffe000200694:	fe043783          	ld	a5,-32(s0)
ffffffe000200698:	00178793          	addi	a5,a5,1
ffffffe00020069c:	00479793          	slli	a5,a5,0x4
ffffffe0002006a0:	00f707b3          	add	a5,a4,a5
ffffffe0002006a4:	0007b783          	ld	a5,0(a5)
ffffffe0002006a8:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size) 
ffffffe0002006ac:	fd843703          	ld	a4,-40(s0)
ffffffe0002006b0:	fd043783          	ld	a5,-48(s0)
ffffffe0002006b4:	00f707b3          	add	a5,a4,a5
ffffffe0002006b8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006bc:	02f71463          	bne	a4,a5,ffffffe0002006e4 <buddy_free+0x150>
            buddy.bitmap[index] = node_size;
ffffffe0002006c0:	00009797          	auipc	a5,0x9
ffffffe0002006c4:	96878793          	addi	a5,a5,-1688 # ffffffe000209028 <buddy>
ffffffe0002006c8:	0087b703          	ld	a4,8(a5)
ffffffe0002006cc:	fe043783          	ld	a5,-32(s0)
ffffffe0002006d0:	00379793          	slli	a5,a5,0x3
ffffffe0002006d4:	00f707b3          	add	a5,a4,a5
ffffffe0002006d8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006dc:	00e7b023          	sd	a4,0(a5)
ffffffe0002006e0:	0300006f          	j	ffffffe000200710 <buddy_free+0x17c>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe0002006e4:	00009797          	auipc	a5,0x9
ffffffe0002006e8:	94478793          	addi	a5,a5,-1724 # ffffffe000209028 <buddy>
ffffffe0002006ec:	0087b703          	ld	a4,8(a5)
ffffffe0002006f0:	fe043783          	ld	a5,-32(s0)
ffffffe0002006f4:	00379793          	slli	a5,a5,0x3
ffffffe0002006f8:	00f706b3          	add	a3,a4,a5
ffffffe0002006fc:	fd843703          	ld	a4,-40(s0)
ffffffe000200700:	fd043783          	ld	a5,-48(s0)
ffffffe000200704:	00e7f463          	bgeu	a5,a4,ffffffe00020070c <buddy_free+0x178>
ffffffe000200708:	00070793          	mv	a5,a4
ffffffe00020070c:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200710:	fe043783          	ld	a5,-32(s0)
ffffffe000200714:	f20798e3          	bnez	a5,ffffffe000200644 <buddy_free+0xb0>
    }
}
ffffffe000200718:	00000013          	nop
ffffffe00020071c:	00000013          	nop
ffffffe000200720:	03813403          	ld	s0,56(sp)
ffffffe000200724:	04010113          	addi	sp,sp,64
ffffffe000200728:	00008067          	ret

ffffffe00020072c <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages) {
ffffffe00020072c:	fc010113          	addi	sp,sp,-64
ffffffe000200730:	02113c23          	sd	ra,56(sp)
ffffffe000200734:	02813823          	sd	s0,48(sp)
ffffffe000200738:	04010413          	addi	s0,sp,64
ffffffe00020073c:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe000200740:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe000200744:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe000200748:	fc843783          	ld	a5,-56(s0)
ffffffe00020074c:	00079863          	bnez	a5,ffffffe00020075c <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200750:	00100793          	li	a5,1
ffffffe000200754:	fcf43423          	sd	a5,-56(s0)
ffffffe000200758:	0240006f          	j	ffffffe00020077c <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe00020075c:	fc843783          	ld	a5,-56(s0)
ffffffe000200760:	fff78713          	addi	a4,a5,-1
ffffffe000200764:	fc843783          	ld	a5,-56(s0)
ffffffe000200768:	00f777b3          	and	a5,a4,a5
ffffffe00020076c:	00078863          	beqz	a5,ffffffe00020077c <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe000200770:	fc843503          	ld	a0,-56(s0)
ffffffe000200774:	bc9ff0ef          	jal	ra,ffffffe00020033c <fixsize>
ffffffe000200778:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe00020077c:	00009797          	auipc	a5,0x9
ffffffe000200780:	8ac78793          	addi	a5,a5,-1876 # ffffffe000209028 <buddy>
ffffffe000200784:	0087b703          	ld	a4,8(a5)
ffffffe000200788:	fe843783          	ld	a5,-24(s0)
ffffffe00020078c:	00379793          	slli	a5,a5,0x3
ffffffe000200790:	00f707b3          	add	a5,a4,a5
ffffffe000200794:	0007b783          	ld	a5,0(a5)
ffffffe000200798:	fc843703          	ld	a4,-56(s0)
ffffffe00020079c:	00e7f663          	bgeu	a5,a4,ffffffe0002007a8 <buddy_alloc+0x7c>
        return 0;
ffffffe0002007a0:	00000793          	li	a5,0
ffffffe0002007a4:	1480006f          	j	ffffffe0002008ec <buddy_alloc+0x1c0>

    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe0002007a8:	00009797          	auipc	a5,0x9
ffffffe0002007ac:	88078793          	addi	a5,a5,-1920 # ffffffe000209028 <buddy>
ffffffe0002007b0:	0007b783          	ld	a5,0(a5)
ffffffe0002007b4:	fef43023          	sd	a5,-32(s0)
ffffffe0002007b8:	05c0006f          	j	ffffffe000200814 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe0002007bc:	00009797          	auipc	a5,0x9
ffffffe0002007c0:	86c78793          	addi	a5,a5,-1940 # ffffffe000209028 <buddy>
ffffffe0002007c4:	0087b703          	ld	a4,8(a5)
ffffffe0002007c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007cc:	00479793          	slli	a5,a5,0x4
ffffffe0002007d0:	00878793          	addi	a5,a5,8
ffffffe0002007d4:	00f707b3          	add	a5,a4,a5
ffffffe0002007d8:	0007b783          	ld	a5,0(a5)
ffffffe0002007dc:	fc843703          	ld	a4,-56(s0)
ffffffe0002007e0:	00e7ec63          	bltu	a5,a4,ffffffe0002007f8 <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe0002007e4:	fe843783          	ld	a5,-24(s0)
ffffffe0002007e8:	00179793          	slli	a5,a5,0x1
ffffffe0002007ec:	00178793          	addi	a5,a5,1
ffffffe0002007f0:	fef43423          	sd	a5,-24(s0)
ffffffe0002007f4:	0140006f          	j	ffffffe000200808 <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe0002007f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007fc:	00178793          	addi	a5,a5,1
ffffffe000200800:	00179793          	slli	a5,a5,0x1
ffffffe000200804:	fef43423          	sd	a5,-24(s0)
    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe000200808:	fe043783          	ld	a5,-32(s0)
ffffffe00020080c:	0017d793          	srli	a5,a5,0x1
ffffffe000200810:	fef43023          	sd	a5,-32(s0)
ffffffe000200814:	fe043703          	ld	a4,-32(s0)
ffffffe000200818:	fc843783          	ld	a5,-56(s0)
ffffffe00020081c:	faf710e3          	bne	a4,a5,ffffffe0002007bc <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe000200820:	00009797          	auipc	a5,0x9
ffffffe000200824:	80878793          	addi	a5,a5,-2040 # ffffffe000209028 <buddy>
ffffffe000200828:	0087b703          	ld	a4,8(a5)
ffffffe00020082c:	fe843783          	ld	a5,-24(s0)
ffffffe000200830:	00379793          	slli	a5,a5,0x3
ffffffe000200834:	00f707b3          	add	a5,a4,a5
ffffffe000200838:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe00020083c:	fe843783          	ld	a5,-24(s0)
ffffffe000200840:	00178713          	addi	a4,a5,1
ffffffe000200844:	fe043783          	ld	a5,-32(s0)
ffffffe000200848:	02f70733          	mul	a4,a4,a5
ffffffe00020084c:	00008797          	auipc	a5,0x8
ffffffe000200850:	7dc78793          	addi	a5,a5,2012 # ffffffe000209028 <buddy>
ffffffe000200854:	0007b783          	ld	a5,0(a5)
ffffffe000200858:	40f707b3          	sub	a5,a4,a5
ffffffe00020085c:	fcf43c23          	sd	a5,-40(s0)

    while (index) {
ffffffe000200860:	0800006f          	j	ffffffe0002008e0 <buddy_alloc+0x1b4>
        index = PARENT(index);
ffffffe000200864:	fe843783          	ld	a5,-24(s0)
ffffffe000200868:	00178793          	addi	a5,a5,1
ffffffe00020086c:	0017d793          	srli	a5,a5,0x1
ffffffe000200870:	fff78793          	addi	a5,a5,-1
ffffffe000200874:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] = 
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200878:	00008797          	auipc	a5,0x8
ffffffe00020087c:	7b078793          	addi	a5,a5,1968 # ffffffe000209028 <buddy>
ffffffe000200880:	0087b703          	ld	a4,8(a5)
ffffffe000200884:	fe843783          	ld	a5,-24(s0)
ffffffe000200888:	00178793          	addi	a5,a5,1
ffffffe00020088c:	00479793          	slli	a5,a5,0x4
ffffffe000200890:	00f707b3          	add	a5,a4,a5
ffffffe000200894:	0007b603          	ld	a2,0(a5)
ffffffe000200898:	00008797          	auipc	a5,0x8
ffffffe00020089c:	79078793          	addi	a5,a5,1936 # ffffffe000209028 <buddy>
ffffffe0002008a0:	0087b703          	ld	a4,8(a5)
ffffffe0002008a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008a8:	00479793          	slli	a5,a5,0x4
ffffffe0002008ac:	00878793          	addi	a5,a5,8
ffffffe0002008b0:	00f707b3          	add	a5,a4,a5
ffffffe0002008b4:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008b8:	00008797          	auipc	a5,0x8
ffffffe0002008bc:	77078793          	addi	a5,a5,1904 # ffffffe000209028 <buddy>
ffffffe0002008c0:	0087b683          	ld	a3,8(a5)
ffffffe0002008c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008c8:	00379793          	slli	a5,a5,0x3
ffffffe0002008cc:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe0002008d0:	00060793          	mv	a5,a2
ffffffe0002008d4:	00e7f463          	bgeu	a5,a4,ffffffe0002008dc <buddy_alloc+0x1b0>
ffffffe0002008d8:	00070793          	mv	a5,a4
        buddy.bitmap[index] = 
ffffffe0002008dc:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe0002008e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002008e4:	f80790e3          	bnez	a5,ffffffe000200864 <buddy_alloc+0x138>
    }
    
    return pfn;
ffffffe0002008e8:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002008ec:	00078513          	mv	a0,a5
ffffffe0002008f0:	03813083          	ld	ra,56(sp)
ffffffe0002008f4:	03013403          	ld	s0,48(sp)
ffffffe0002008f8:	04010113          	addi	sp,sp,64
ffffffe0002008fc:	00008067          	ret

ffffffe000200900 <alloc_pages>:


void *alloc_pages(uint64_t nrpages) {
ffffffe000200900:	fd010113          	addi	sp,sp,-48
ffffffe000200904:	02113423          	sd	ra,40(sp)
ffffffe000200908:	02813023          	sd	s0,32(sp)
ffffffe00020090c:	03010413          	addi	s0,sp,48
ffffffe000200910:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe000200914:	fd843503          	ld	a0,-40(s0)
ffffffe000200918:	e15ff0ef          	jal	ra,ffffffe00020072c <buddy_alloc>
ffffffe00020091c:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe000200920:	fe843783          	ld	a5,-24(s0)
ffffffe000200924:	00079663          	bnez	a5,ffffffe000200930 <alloc_pages+0x30>
        return 0;
ffffffe000200928:	00000793          	li	a5,0
ffffffe00020092c:	0180006f          	j	ffffffe000200944 <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe000200930:	fe843783          	ld	a5,-24(s0)
ffffffe000200934:	00c79713          	slli	a4,a5,0xc
ffffffe000200938:	fff00793          	li	a5,-1
ffffffe00020093c:	02579793          	slli	a5,a5,0x25
ffffffe000200940:	00f707b3          	add	a5,a4,a5
}
ffffffe000200944:	00078513          	mv	a0,a5
ffffffe000200948:	02813083          	ld	ra,40(sp)
ffffffe00020094c:	02013403          	ld	s0,32(sp)
ffffffe000200950:	03010113          	addi	sp,sp,48
ffffffe000200954:	00008067          	ret

ffffffe000200958 <alloc_page>:

void *alloc_page() {
ffffffe000200958:	ff010113          	addi	sp,sp,-16
ffffffe00020095c:	00113423          	sd	ra,8(sp)
ffffffe000200960:	00813023          	sd	s0,0(sp)
ffffffe000200964:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe000200968:	00100513          	li	a0,1
ffffffe00020096c:	f95ff0ef          	jal	ra,ffffffe000200900 <alloc_pages>
ffffffe000200970:	00050793          	mv	a5,a0
}
ffffffe000200974:	00078513          	mv	a0,a5
ffffffe000200978:	00813083          	ld	ra,8(sp)
ffffffe00020097c:	00013403          	ld	s0,0(sp)
ffffffe000200980:	01010113          	addi	sp,sp,16
ffffffe000200984:	00008067          	ret

ffffffe000200988 <free_pages>:

void free_pages(void *va) {
ffffffe000200988:	fe010113          	addi	sp,sp,-32
ffffffe00020098c:	00113c23          	sd	ra,24(sp)
ffffffe000200990:	00813823          	sd	s0,16(sp)
ffffffe000200994:	02010413          	addi	s0,sp,32
ffffffe000200998:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe00020099c:	fe843703          	ld	a4,-24(s0)
ffffffe0002009a0:	00100793          	li	a5,1
ffffffe0002009a4:	02579793          	slli	a5,a5,0x25
ffffffe0002009a8:	00f707b3          	add	a5,a4,a5
ffffffe0002009ac:	00c7d793          	srli	a5,a5,0xc
ffffffe0002009b0:	00078513          	mv	a0,a5
ffffffe0002009b4:	be1ff0ef          	jal	ra,ffffffe000200594 <buddy_free>
}
ffffffe0002009b8:	00000013          	nop
ffffffe0002009bc:	01813083          	ld	ra,24(sp)
ffffffe0002009c0:	01013403          	ld	s0,16(sp)
ffffffe0002009c4:	02010113          	addi	sp,sp,32
ffffffe0002009c8:	00008067          	ret

ffffffe0002009cc <kalloc>:

void *kalloc() {
ffffffe0002009cc:	ff010113          	addi	sp,sp,-16
ffffffe0002009d0:	00113423          	sd	ra,8(sp)
ffffffe0002009d4:	00813023          	sd	s0,0(sp)
ffffffe0002009d8:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;
    
    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe0002009dc:	f7dff0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe0002009e0:	00050793          	mv	a5,a0
}
ffffffe0002009e4:	00078513          	mv	a0,a5
ffffffe0002009e8:	00813083          	ld	ra,8(sp)
ffffffe0002009ec:	00013403          	ld	s0,0(sp)
ffffffe0002009f0:	01010113          	addi	sp,sp,16
ffffffe0002009f4:	00008067          	ret

ffffffe0002009f8 <kfree>:

void kfree(void *addr) {
ffffffe0002009f8:	fe010113          	addi	sp,sp,-32
ffffffe0002009fc:	00113c23          	sd	ra,24(sp)
ffffffe000200a00:	00813823          	sd	s0,16(sp)
ffffffe000200a04:	02010413          	addi	s0,sp,32
ffffffe000200a08:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe000200a0c:	fe843503          	ld	a0,-24(s0)
ffffffe000200a10:	f79ff0ef          	jal	ra,ffffffe000200988 <free_pages>

    return;
ffffffe000200a14:	00000013          	nop
}
ffffffe000200a18:	01813083          	ld	ra,24(sp)
ffffffe000200a1c:	01013403          	ld	s0,16(sp)
ffffffe000200a20:	02010113          	addi	sp,sp,32
ffffffe000200a24:	00008067          	ret

ffffffe000200a28 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe000200a28:	fd010113          	addi	sp,sp,-48
ffffffe000200a2c:	02113423          	sd	ra,40(sp)
ffffffe000200a30:	02813023          	sd	s0,32(sp)
ffffffe000200a34:	03010413          	addi	s0,sp,48
ffffffe000200a38:	fca43c23          	sd	a0,-40(s0)
ffffffe000200a3c:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe000200a40:	fd843703          	ld	a4,-40(s0)
ffffffe000200a44:	000017b7          	lui	a5,0x1
ffffffe000200a48:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200a4c:	00f70733          	add	a4,a4,a5
ffffffe000200a50:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a54:	00f777b3          	and	a5,a4,a5
ffffffe000200a58:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a5c:	01c0006f          	j	ffffffe000200a78 <kfreerange+0x50>
        kfree((void *)addr);
ffffffe000200a60:	fe843503          	ld	a0,-24(s0)
ffffffe000200a64:	f95ff0ef          	jal	ra,ffffffe0002009f8 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a68:	fe843703          	ld	a4,-24(s0)
ffffffe000200a6c:	000017b7          	lui	a5,0x1
ffffffe000200a70:	00f707b3          	add	a5,a4,a5
ffffffe000200a74:	fef43423          	sd	a5,-24(s0)
ffffffe000200a78:	fe843703          	ld	a4,-24(s0)
ffffffe000200a7c:	000017b7          	lui	a5,0x1
ffffffe000200a80:	00f70733          	add	a4,a4,a5
ffffffe000200a84:	fd043783          	ld	a5,-48(s0)
ffffffe000200a88:	fce7fce3          	bgeu	a5,a4,ffffffe000200a60 <kfreerange+0x38>
    }
}
ffffffe000200a8c:	00000013          	nop
ffffffe000200a90:	00000013          	nop
ffffffe000200a94:	02813083          	ld	ra,40(sp)
ffffffe000200a98:	02013403          	ld	s0,32(sp)
ffffffe000200a9c:	03010113          	addi	sp,sp,48
ffffffe000200aa0:	00008067          	ret

ffffffe000200aa4 <mm_init>:

void mm_init(void) {
ffffffe000200aa4:	ff010113          	addi	sp,sp,-16
ffffffe000200aa8:	00113423          	sd	ra,8(sp)
ffffffe000200aac:	00813023          	sd	s0,0(sp)
ffffffe000200ab0:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200ab4:	935ff0ef          	jal	ra,ffffffe0002003e8 <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200ab8:	00003517          	auipc	a0,0x3
ffffffe000200abc:	56850513          	addi	a0,a0,1384 # ffffffe000204020 <__func__.0+0x20>
ffffffe000200ac0:	190030ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe000200ac4:	00000013          	nop
ffffffe000200ac8:	00813083          	ld	ra,8(sp)
ffffffe000200acc:	00013403          	ld	s0,0(sp)
ffffffe000200ad0:	01010113          	addi	sp,sp,16
ffffffe000200ad4:	00008067          	ret

ffffffe000200ad8 <get_nr_tasks>:
extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];

int get_nr_tasks()
{
ffffffe000200ad8:	ff010113          	addi	sp,sp,-16
ffffffe000200adc:	00813423          	sd	s0,8(sp)
ffffffe000200ae0:	01010413          	addi	s0,sp,16
    return nr_tasks;
ffffffe000200ae4:	00008797          	auipc	a5,0x8
ffffffe000200ae8:	53478793          	addi	a5,a5,1332 # ffffffe000209018 <nr_tasks>
ffffffe000200aec:	0007a783          	lw	a5,0(a5)
}
ffffffe000200af0:	00078513          	mv	a0,a5
ffffffe000200af4:	00813403          	ld	s0,8(sp)
ffffffe000200af8:	01010113          	addi	sp,sp,16
ffffffe000200afc:	00008067          	ret

ffffffe000200b00 <get_current_proc>:

struct task_struct *get_current_proc()
{
ffffffe000200b00:	ff010113          	addi	sp,sp,-16
ffffffe000200b04:	00813423          	sd	s0,8(sp)
ffffffe000200b08:	01010413          	addi	s0,sp,16
    return current;
ffffffe000200b0c:	00008797          	auipc	a5,0x8
ffffffe000200b10:	50478793          	addi	a5,a5,1284 # ffffffe000209010 <current>
ffffffe000200b14:	0007b783          	ld	a5,0(a5)
}
ffffffe000200b18:	00078513          	mv	a0,a5
ffffffe000200b1c:	00813403          	ld	s0,8(sp)
ffffffe000200b20:	01010113          	addi	sp,sp,16
ffffffe000200b24:	00008067          	ret

ffffffe000200b28 <set_user_pgtbl>:

void set_user_pgtbl(struct task_struct *T)
{
ffffffe000200b28:	fd010113          	addi	sp,sp,-48
ffffffe000200b2c:	02113423          	sd	ra,40(sp)
ffffffe000200b30:	02813023          	sd	s0,32(sp)
ffffffe000200b34:	00913c23          	sd	s1,24(sp)
ffffffe000200b38:	03010413          	addi	s0,sp,48
ffffffe000200b3c:	fca43c23          	sd	a0,-40(s0)
    T->pgd = (uint64_t *)alloc_page();
ffffffe000200b40:	e19ff0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe000200b44:	00050713          	mv	a4,a0
ffffffe000200b48:	fd843783          	ld	a5,-40(s0)
ffffffe000200b4c:	0ae7b423          	sd	a4,168(a5)
    memset(T->pgd, 0, PGSIZE);
ffffffe000200b50:	fd843783          	ld	a5,-40(s0)
ffffffe000200b54:	0a87b783          	ld	a5,168(a5)
ffffffe000200b58:	00001637          	lui	a2,0x1
ffffffe000200b5c:	00000593          	li	a1,0
ffffffe000200b60:	00078513          	mv	a0,a5
ffffffe000200b64:	20c030ef          	jal	ra,ffffffe000203d70 <memset>
    memcpy(T->pgd, get_kernel_pgtbl(), PGSIZE);
ffffffe000200b68:	fd843783          	ld	a5,-40(s0)
ffffffe000200b6c:	0a87b483          	ld	s1,168(a5)
ffffffe000200b70:	5c9010ef          	jal	ra,ffffffe000202938 <get_kernel_pgtbl>
ffffffe000200b74:	00050793          	mv	a5,a0
ffffffe000200b78:	00001637          	lui	a2,0x1
ffffffe000200b7c:	00078593          	mv	a1,a5
ffffffe000200b80:	00048513          	mv	a0,s1
ffffffe000200b84:	25c030ef          	jal	ra,ffffffe000203de0 <memcpy>

    printk("set_user_pgtbl: T->pgd = %p\n", T->pgd);
ffffffe000200b88:	fd843783          	ld	a5,-40(s0)
ffffffe000200b8c:	0a87b783          	ld	a5,168(a5)
ffffffe000200b90:	00078593          	mv	a1,a5
ffffffe000200b94:	00003517          	auipc	a0,0x3
ffffffe000200b98:	4a450513          	addi	a0,a0,1188 # ffffffe000204038 <__func__.0+0x38>
ffffffe000200b9c:	0b4030ef          	jal	ra,ffffffe000203c50 <printk>
    // uint64_t va = USER_END - PGSIZE;
    // printk("set_user_pgtbl: va = %lx, pa = %lx\n", va, pa);
    // create_mapping(T->pgd, va, pa, PGSIZE, user_perm);

    // vma
    do_mmap(&(T->mm), USER_END - PGSIZE, PGSIZE, 0, 0, VM_ANON | VM_READ | VM_WRITE);
ffffffe000200ba0:	fd843783          	ld	a5,-40(s0)
ffffffe000200ba4:	0b078513          	addi	a0,a5,176
ffffffe000200ba8:	00700793          	li	a5,7
ffffffe000200bac:	00000713          	li	a4,0
ffffffe000200bb0:	00000693          	li	a3,0
ffffffe000200bb4:	00001637          	lui	a2,0x1
ffffffe000200bb8:	040005b7          	lui	a1,0x4000
ffffffe000200bbc:	fff58593          	addi	a1,a1,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000200bc0:	00c59593          	slli	a1,a1,0xc
ffffffe000200bc4:	0d9000ef          	jal	ra,ffffffe00020149c <do_mmap>
    printk("set_user_pgtbl done\n");
ffffffe000200bc8:	00003517          	auipc	a0,0x3
ffffffe000200bcc:	49050513          	addi	a0,a0,1168 # ffffffe000204058 <__func__.0+0x58>
ffffffe000200bd0:	080030ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe000200bd4:	00000013          	nop
ffffffe000200bd8:	02813083          	ld	ra,40(sp)
ffffffe000200bdc:	02013403          	ld	s0,32(sp)
ffffffe000200be0:	01813483          	ld	s1,24(sp)
ffffffe000200be4:	03010113          	addi	sp,sp,48
ffffffe000200be8:	00008067          	ret

ffffffe000200bec <pteflags2vmflags>:

uint64_t pteflags2vmflags(uint64_t pte_flags)
{
ffffffe000200bec:	fe010113          	addi	sp,sp,-32
ffffffe000200bf0:	00813c23          	sd	s0,24(sp)
ffffffe000200bf4:	02010413          	addi	s0,sp,32
ffffffe000200bf8:	fea43423          	sd	a0,-24(s0)
    return ((pte_flags & PTE_R) ? VM_READ : 0) | ((pte_flags & PTE_W) ? VM_WRITE : 0) | ((pte_flags & PTE_X) ? VM_EXEC : 0);
ffffffe000200bfc:	fe843783          	ld	a5,-24(s0)
ffffffe000200c00:	0007879b          	sext.w	a5,a5
ffffffe000200c04:	00e7f793          	andi	a5,a5,14
}
ffffffe000200c08:	00078513          	mv	a0,a5
ffffffe000200c0c:	01813403          	ld	s0,24(sp)
ffffffe000200c10:	02010113          	addi	sp,sp,32
ffffffe000200c14:	00008067          	ret

ffffffe000200c18 <load_program>:

void load_program(struct task_struct *task)
{
ffffffe000200c18:	f8010113          	addi	sp,sp,-128
ffffffe000200c1c:	06113c23          	sd	ra,120(sp)
ffffffe000200c20:	06813823          	sd	s0,112(sp)
ffffffe000200c24:	06913423          	sd	s1,104(sp)
ffffffe000200c28:	07213023          	sd	s2,96(sp)
ffffffe000200c2c:	05313c23          	sd	s3,88(sp)
ffffffe000200c30:	05413823          	sd	s4,80(sp)
ffffffe000200c34:	05513423          	sd	s5,72(sp)
ffffffe000200c38:	08010413          	addi	s0,sp,128
ffffffe000200c3c:	f8a43423          	sd	a0,-120(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200c40:	00005797          	auipc	a5,0x5
ffffffe000200c44:	3c078793          	addi	a5,a5,960 # ffffffe000206000 <_sramdisk>
ffffffe000200c48:	faf43823          	sd	a5,-80(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200c4c:	fb043783          	ld	a5,-80(s0)
ffffffe000200c50:	0207b703          	ld	a4,32(a5)
ffffffe000200c54:	00005797          	auipc	a5,0x5
ffffffe000200c58:	3ac78793          	addi	a5,a5,940 # ffffffe000206000 <_sramdisk>
ffffffe000200c5c:	00f707b3          	add	a5,a4,a5
ffffffe000200c60:	faf43423          	sd	a5,-88(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200c64:	fa042e23          	sw	zero,-68(s0)
ffffffe000200c68:	0e40006f          	j	ffffffe000200d4c <load_program+0x134>
    {
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200c6c:	fbc42703          	lw	a4,-68(s0)
ffffffe000200c70:	00070793          	mv	a5,a4
ffffffe000200c74:	00379793          	slli	a5,a5,0x3
ffffffe000200c78:	40e787b3          	sub	a5,a5,a4
ffffffe000200c7c:	00379793          	slli	a5,a5,0x3
ffffffe000200c80:	00078713          	mv	a4,a5
ffffffe000200c84:	fa843783          	ld	a5,-88(s0)
ffffffe000200c88:	00e787b3          	add	a5,a5,a4
ffffffe000200c8c:	faf43023          	sd	a5,-96(s0)
        if (phdr->p_type == PT_LOAD)
ffffffe000200c90:	fa043783          	ld	a5,-96(s0)
ffffffe000200c94:	0007a783          	lw	a5,0(a5)
ffffffe000200c98:	00078713          	mv	a4,a5
ffffffe000200c9c:	00100793          	li	a5,1
ffffffe000200ca0:	0af71063          	bne	a4,a5,ffffffe000200d40 <load_program+0x128>
        {
            // alloc space and copy content
            uint64_t align_offset = phdr->p_vaddr % PGSIZE;
ffffffe000200ca4:	fa043783          	ld	a5,-96(s0)
ffffffe000200ca8:	0107b703          	ld	a4,16(a5)
ffffffe000200cac:	000017b7          	lui	a5,0x1
ffffffe000200cb0:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200cb4:	00f777b3          	and	a5,a4,a5
ffffffe000200cb8:	f8f43c23          	sd	a5,-104(s0)
            uint64_t num_pg = (phdr->p_memsz + align_offset + PGSIZE - 1) / PGSIZE;
ffffffe000200cbc:	fa043783          	ld	a5,-96(s0)
ffffffe000200cc0:	0287b703          	ld	a4,40(a5)
ffffffe000200cc4:	f9843783          	ld	a5,-104(s0)
ffffffe000200cc8:	00f70733          	add	a4,a4,a5
ffffffe000200ccc:	000017b7          	lui	a5,0x1
ffffffe000200cd0:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200cd4:	00f707b3          	add	a5,a4,a5
ffffffe000200cd8:	00c7d793          	srli	a5,a5,0xc
ffffffe000200cdc:	f8f43823          	sd	a5,-112(s0)
            // memset((void *)((uint64_t)new_pgs + align_offset + phdr->p_filesz), 0x0, phdr->p_memsz - phdr->p_filesz);
            // do mapping
            // create_mapping(task->pgd, phdr->p_vaddr - align_offset, VA2PA((uint64_t)new_pgs), phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
            // printk("[load_program] va = %lx, pa = %lx, sz = %lx, perm = %lx\//n", phdr->p_vaddr - align_offset, (uint64_t)new_pgs - PA2VA_OFFSET, phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
            // vma
            do_mmap(&(task->mm), phdr->p_vaddr, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, pteflags2vmflags(phdr->p_flags) | VM_EXEC);
ffffffe000200ce0:	f8843783          	ld	a5,-120(s0)
ffffffe000200ce4:	0b078493          	addi	s1,a5,176
ffffffe000200ce8:	fa043783          	ld	a5,-96(s0)
ffffffe000200cec:	0107b903          	ld	s2,16(a5)
ffffffe000200cf0:	fa043783          	ld	a5,-96(s0)
ffffffe000200cf4:	0287b983          	ld	s3,40(a5)
ffffffe000200cf8:	fa043783          	ld	a5,-96(s0)
ffffffe000200cfc:	0087ba03          	ld	s4,8(a5)
ffffffe000200d00:	fa043783          	ld	a5,-96(s0)
ffffffe000200d04:	0207ba83          	ld	s5,32(a5)
ffffffe000200d08:	fa043783          	ld	a5,-96(s0)
ffffffe000200d0c:	0047a783          	lw	a5,4(a5)
ffffffe000200d10:	02079793          	slli	a5,a5,0x20
ffffffe000200d14:	0207d793          	srli	a5,a5,0x20
ffffffe000200d18:	00078513          	mv	a0,a5
ffffffe000200d1c:	ed1ff0ef          	jal	ra,ffffffe000200bec <pteflags2vmflags>
ffffffe000200d20:	00050793          	mv	a5,a0
ffffffe000200d24:	0087e793          	ori	a5,a5,8
ffffffe000200d28:	000a8713          	mv	a4,s5
ffffffe000200d2c:	000a0693          	mv	a3,s4
ffffffe000200d30:	00098613          	mv	a2,s3
ffffffe000200d34:	00090593          	mv	a1,s2
ffffffe000200d38:	00048513          	mv	a0,s1
ffffffe000200d3c:	760000ef          	jal	ra,ffffffe00020149c <do_mmap>
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200d40:	fbc42783          	lw	a5,-68(s0)
ffffffe000200d44:	0017879b          	addiw	a5,a5,1
ffffffe000200d48:	faf42e23          	sw	a5,-68(s0)
ffffffe000200d4c:	fb043783          	ld	a5,-80(s0)
ffffffe000200d50:	0387d783          	lhu	a5,56(a5)
ffffffe000200d54:	0007871b          	sext.w	a4,a5
ffffffe000200d58:	fbc42783          	lw	a5,-68(s0)
ffffffe000200d5c:	0007879b          	sext.w	a5,a5
ffffffe000200d60:	f0e7c6e3          	blt	a5,a4,ffffffe000200c6c <load_program+0x54>
            // code...
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe000200d64:	fb043783          	ld	a5,-80(s0)
ffffffe000200d68:	0187b703          	ld	a4,24(a5)
ffffffe000200d6c:	f8843783          	ld	a5,-120(s0)
ffffffe000200d70:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200d74:	00000013          	nop
ffffffe000200d78:	07813083          	ld	ra,120(sp)
ffffffe000200d7c:	07013403          	ld	s0,112(sp)
ffffffe000200d80:	06813483          	ld	s1,104(sp)
ffffffe000200d84:	06013903          	ld	s2,96(sp)
ffffffe000200d88:	05813983          	ld	s3,88(sp)
ffffffe000200d8c:	05013a03          	ld	s4,80(sp)
ffffffe000200d90:	04813a83          	ld	s5,72(sp)
ffffffe000200d94:	08010113          	addi	sp,sp,128
ffffffe000200d98:	00008067          	ret

ffffffe000200d9c <task_init>:

void task_init()
{
ffffffe000200d9c:	fe010113          	addi	sp,sp,-32
ffffffe000200da0:	00113c23          	sd	ra,24(sp)
ffffffe000200da4:	00813823          	sd	s0,16(sp)
ffffffe000200da8:	02010413          	addi	s0,sp,32
    srand(2024);
ffffffe000200dac:	7e800513          	li	a0,2024
ffffffe000200db0:	721020ef          	jal	ra,ffffffe000203cd0 <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
ffffffe000200db4:	c19ff0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000200db8:	00050713          	mv	a4,a0
ffffffe000200dbc:	00008797          	auipc	a5,0x8
ffffffe000200dc0:	24c78793          	addi	a5,a5,588 # ffffffe000209008 <idle>
ffffffe000200dc4:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe000200dc8:	00008797          	auipc	a5,0x8
ffffffe000200dcc:	24078793          	addi	a5,a5,576 # ffffffe000209008 <idle>
ffffffe000200dd0:	0007b783          	ld	a5,0(a5)
ffffffe000200dd4:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200dd8:	00008797          	auipc	a5,0x8
ffffffe000200ddc:	23078793          	addi	a5,a5,560 # ffffffe000209008 <idle>
ffffffe000200de0:	0007b783          	ld	a5,0(a5)
ffffffe000200de4:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200de8:	00008797          	auipc	a5,0x8
ffffffe000200dec:	22078793          	addi	a5,a5,544 # ffffffe000209008 <idle>
ffffffe000200df0:	0007b783          	ld	a5,0(a5)
ffffffe000200df4:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200df8:	00008797          	auipc	a5,0x8
ffffffe000200dfc:	21078793          	addi	a5,a5,528 # ffffffe000209008 <idle>
ffffffe000200e00:	0007b783          	ld	a5,0(a5)
ffffffe000200e04:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe000200e08:	00008797          	auipc	a5,0x8
ffffffe000200e0c:	20078793          	addi	a5,a5,512 # ffffffe000209008 <idle>
ffffffe000200e10:	0007b703          	ld	a4,0(a5)
ffffffe000200e14:	00008797          	auipc	a5,0x8
ffffffe000200e18:	1fc78793          	addi	a5,a5,508 # ffffffe000209010 <current>
ffffffe000200e1c:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200e20:	00008797          	auipc	a5,0x8
ffffffe000200e24:	1e878793          	addi	a5,a5,488 # ffffffe000209008 <idle>
ffffffe000200e28:	0007b703          	ld	a4,0(a5)
ffffffe000200e2c:	00008797          	auipc	a5,0x8
ffffffe000200e30:	20c78793          	addi	a5,a5,524 # ffffffe000209038 <task>
ffffffe000200e34:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for (int i = 1; i < 2; i++)
ffffffe000200e38:	00100793          	li	a5,1
ffffffe000200e3c:	fef42623          	sw	a5,-20(s0)
ffffffe000200e40:	2600006f          	j	ffffffe0002010a0 <task_init+0x304>
    {
        task[i] = (struct task_struct *)kalloc();
ffffffe000200e44:	b89ff0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000200e48:	00050693          	mv	a3,a0
ffffffe000200e4c:	00008717          	auipc	a4,0x8
ffffffe000200e50:	1ec70713          	addi	a4,a4,492 # ffffffe000209038 <task>
ffffffe000200e54:	fec42783          	lw	a5,-20(s0)
ffffffe000200e58:	00379793          	slli	a5,a5,0x3
ffffffe000200e5c:	00f707b3          	add	a5,a4,a5
ffffffe000200e60:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200e64:	00008717          	auipc	a4,0x8
ffffffe000200e68:	1d470713          	addi	a4,a4,468 # ffffffe000209038 <task>
ffffffe000200e6c:	fec42783          	lw	a5,-20(s0)
ffffffe000200e70:	00379793          	slli	a5,a5,0x3
ffffffe000200e74:	00f707b3          	add	a5,a4,a5
ffffffe000200e78:	0007b783          	ld	a5,0(a5)
ffffffe000200e7c:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200e80:	695020ef          	jal	ra,ffffffe000203d14 <rand>
ffffffe000200e84:	00050793          	mv	a5,a0
ffffffe000200e88:	00078713          	mv	a4,a5
ffffffe000200e8c:	00a00793          	li	a5,10
ffffffe000200e90:	02f767bb          	remw	a5,a4,a5
ffffffe000200e94:	0007879b          	sext.w	a5,a5
ffffffe000200e98:	0017879b          	addiw	a5,a5,1
ffffffe000200e9c:	0007869b          	sext.w	a3,a5
ffffffe000200ea0:	00008717          	auipc	a4,0x8
ffffffe000200ea4:	19870713          	addi	a4,a4,408 # ffffffe000209038 <task>
ffffffe000200ea8:	fec42783          	lw	a5,-20(s0)
ffffffe000200eac:	00379793          	slli	a5,a5,0x3
ffffffe000200eb0:	00f707b3          	add	a5,a4,a5
ffffffe000200eb4:	0007b783          	ld	a5,0(a5)
ffffffe000200eb8:	00068713          	mv	a4,a3
ffffffe000200ebc:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe000200ec0:	00008717          	auipc	a4,0x8
ffffffe000200ec4:	17870713          	addi	a4,a4,376 # ffffffe000209038 <task>
ffffffe000200ec8:	fec42783          	lw	a5,-20(s0)
ffffffe000200ecc:	00379793          	slli	a5,a5,0x3
ffffffe000200ed0:	00f707b3          	add	a5,a4,a5
ffffffe000200ed4:	0007b783          	ld	a5,0(a5)
ffffffe000200ed8:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe000200edc:	00008717          	auipc	a4,0x8
ffffffe000200ee0:	15c70713          	addi	a4,a4,348 # ffffffe000209038 <task>
ffffffe000200ee4:	fec42783          	lw	a5,-20(s0)
ffffffe000200ee8:	00379793          	slli	a5,a5,0x3
ffffffe000200eec:	00f707b3          	add	a5,a4,a5
ffffffe000200ef0:	0007b783          	ld	a5,0(a5)
ffffffe000200ef4:	fec42703          	lw	a4,-20(s0)
ffffffe000200ef8:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe000200efc:	00008717          	auipc	a4,0x8
ffffffe000200f00:	13c70713          	addi	a4,a4,316 # ffffffe000209038 <task>
ffffffe000200f04:	fec42783          	lw	a5,-20(s0)
ffffffe000200f08:	00379793          	slli	a5,a5,0x3
ffffffe000200f0c:	00f707b3          	add	a5,a4,a5
ffffffe000200f10:	0007b783          	ld	a5,0(a5)
ffffffe000200f14:	fffff717          	auipc	a4,0xfffff
ffffffe000200f18:	2cc70713          	addi	a4,a4,716 # ffffffe0002001e0 <__dummy>
ffffffe000200f1c:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe000200f20:	00008717          	auipc	a4,0x8
ffffffe000200f24:	11870713          	addi	a4,a4,280 # ffffffe000209038 <task>
ffffffe000200f28:	fec42783          	lw	a5,-20(s0)
ffffffe000200f2c:	00379793          	slli	a5,a5,0x3
ffffffe000200f30:	00f707b3          	add	a5,a4,a5
ffffffe000200f34:	0007b783          	ld	a5,0(a5)
ffffffe000200f38:	00078693          	mv	a3,a5
ffffffe000200f3c:	00008717          	auipc	a4,0x8
ffffffe000200f40:	0fc70713          	addi	a4,a4,252 # ffffffe000209038 <task>
ffffffe000200f44:	fec42783          	lw	a5,-20(s0)
ffffffe000200f48:	00379793          	slli	a5,a5,0x3
ffffffe000200f4c:	00f707b3          	add	a5,a4,a5
ffffffe000200f50:	0007b783          	ld	a5,0(a5)
ffffffe000200f54:	00001737          	lui	a4,0x1
ffffffe000200f58:	00e68733          	add	a4,a3,a4
ffffffe000200f5c:	02e7b423          	sd	a4,40(a5)
        set_user_pgtbl(task[i]);
ffffffe000200f60:	00008717          	auipc	a4,0x8
ffffffe000200f64:	0d870713          	addi	a4,a4,216 # ffffffe000209038 <task>
ffffffe000200f68:	fec42783          	lw	a5,-20(s0)
ffffffe000200f6c:	00379793          	slli	a5,a5,0x3
ffffffe000200f70:	00f707b3          	add	a5,a4,a5
ffffffe000200f74:	0007b783          	ld	a5,0(a5)
ffffffe000200f78:	00078513          	mv	a0,a5
ffffffe000200f7c:	badff0ef          	jal	ra,ffffffe000200b28 <set_user_pgtbl>
        // uint64_t uapp_pages = (PGROUNDUP(_eramdisk - _sramdisk)) / PGSIZE;
        // uint64_t *uapp_mem = (uint64_t *)alloc_pages(uapp_pages);
        // memcpy(uapp_mem, _sramdisk, uapp_pages * PGSIZE);
        // create_mapping(task[i]->pgd, USER_START, VA2PA((uint64_t)uapp_mem), uapp_pages * PGSIZE, PTE_V | PTE_R | PTE_W | PTE_X | PTE_U);
        load_program(task[i]);
ffffffe000200f80:	00008717          	auipc	a4,0x8
ffffffe000200f84:	0b870713          	addi	a4,a4,184 # ffffffe000209038 <task>
ffffffe000200f88:	fec42783          	lw	a5,-20(s0)
ffffffe000200f8c:	00379793          	slli	a5,a5,0x3
ffffffe000200f90:	00f707b3          	add	a5,a4,a5
ffffffe000200f94:	0007b783          	ld	a5,0(a5)
ffffffe000200f98:	00078513          	mv	a0,a5
ffffffe000200f9c:	c7dff0ef          	jal	ra,ffffffe000200c18 <load_program>
        // task[i]->thread.sepc = USER_START;
        // uint64_t sstatus = SSTATUS_SPIE | SSTATUS_SPP;
        // sstatus &= ~SSTATUS_SPP;
        // task[i]->thread.sstatus = sstatus;
        // task[i]->thread.sscratch = USER_END;
        task[i]->thread.sstatus = 0;
ffffffe000200fa0:	00008717          	auipc	a4,0x8
ffffffe000200fa4:	09870713          	addi	a4,a4,152 # ffffffe000209038 <task>
ffffffe000200fa8:	fec42783          	lw	a5,-20(s0)
ffffffe000200fac:	00379793          	slli	a5,a5,0x3
ffffffe000200fb0:	00f707b3          	add	a5,a4,a5
ffffffe000200fb4:	0007b783          	ld	a5,0(a5)
ffffffe000200fb8:	0807bc23          	sd	zero,152(a5)
        task[i]->thread.sstatus &= ~SSTATUS_SPP;
ffffffe000200fbc:	00008717          	auipc	a4,0x8
ffffffe000200fc0:	07c70713          	addi	a4,a4,124 # ffffffe000209038 <task>
ffffffe000200fc4:	fec42783          	lw	a5,-20(s0)
ffffffe000200fc8:	00379793          	slli	a5,a5,0x3
ffffffe000200fcc:	00f707b3          	add	a5,a4,a5
ffffffe000200fd0:	0007b783          	ld	a5,0(a5)
ffffffe000200fd4:	0987b703          	ld	a4,152(a5)
ffffffe000200fd8:	00008697          	auipc	a3,0x8
ffffffe000200fdc:	06068693          	addi	a3,a3,96 # ffffffe000209038 <task>
ffffffe000200fe0:	fec42783          	lw	a5,-20(s0)
ffffffe000200fe4:	00379793          	slli	a5,a5,0x3
ffffffe000200fe8:	00f687b3          	add	a5,a3,a5
ffffffe000200fec:	0007b783          	ld	a5,0(a5)
ffffffe000200ff0:	eff77713          	andi	a4,a4,-257
ffffffe000200ff4:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sstatus |= SSTATUS_SPIE | SSTATUS_SUM;
ffffffe000200ff8:	00008717          	auipc	a4,0x8
ffffffe000200ffc:	04070713          	addi	a4,a4,64 # ffffffe000209038 <task>
ffffffe000201000:	fec42783          	lw	a5,-20(s0)
ffffffe000201004:	00379793          	slli	a5,a5,0x3
ffffffe000201008:	00f707b3          	add	a5,a4,a5
ffffffe00020100c:	0007b783          	ld	a5,0(a5)
ffffffe000201010:	0987b683          	ld	a3,152(a5)
ffffffe000201014:	00008717          	auipc	a4,0x8
ffffffe000201018:	02470713          	addi	a4,a4,36 # ffffffe000209038 <task>
ffffffe00020101c:	fec42783          	lw	a5,-20(s0)
ffffffe000201020:	00379793          	slli	a5,a5,0x3
ffffffe000201024:	00f707b3          	add	a5,a4,a5
ffffffe000201028:	0007b783          	ld	a5,0(a5)
ffffffe00020102c:	00040737          	lui	a4,0x40
ffffffe000201030:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe000201034:	00e6e733          	or	a4,a3,a4
ffffffe000201038:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe00020103c:	00008717          	auipc	a4,0x8
ffffffe000201040:	ffc70713          	addi	a4,a4,-4 # ffffffe000209038 <task>
ffffffe000201044:	fec42783          	lw	a5,-20(s0)
ffffffe000201048:	00379793          	slli	a5,a5,0x3
ffffffe00020104c:	00f707b3          	add	a5,a4,a5
ffffffe000201050:	0007b783          	ld	a5,0(a5)
ffffffe000201054:	00100713          	li	a4,1
ffffffe000201058:	02671713          	slli	a4,a4,0x26
ffffffe00020105c:	0ae7b023          	sd	a4,160(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe000201060:	00008717          	auipc	a4,0x8
ffffffe000201064:	fd870713          	addi	a4,a4,-40 # ffffffe000209038 <task>
ffffffe000201068:	fec42783          	lw	a5,-20(s0)
ffffffe00020106c:	00379793          	slli	a5,a5,0x3
ffffffe000201070:	00f707b3          	add	a5,a4,a5
ffffffe000201074:	0007b783          	ld	a5,0(a5)
ffffffe000201078:	0107b703          	ld	a4,16(a5)
ffffffe00020107c:	fec42783          	lw	a5,-20(s0)
ffffffe000201080:	00070613          	mv	a2,a4
ffffffe000201084:	00078593          	mv	a1,a5
ffffffe000201088:	00003517          	auipc	a0,0x3
ffffffe00020108c:	fe850513          	addi	a0,a0,-24 # ffffffe000204070 <__func__.0+0x70>
ffffffe000201090:	3c1020ef          	jal	ra,ffffffe000203c50 <printk>
    for (int i = 1; i < 2; i++)
ffffffe000201094:	fec42783          	lw	a5,-20(s0)
ffffffe000201098:	0017879b          	addiw	a5,a5,1
ffffffe00020109c:	fef42623          	sw	a5,-20(s0)
ffffffe0002010a0:	fec42783          	lw	a5,-20(s0)
ffffffe0002010a4:	0007871b          	sext.w	a4,a5
ffffffe0002010a8:	00100793          	li	a5,1
ffffffe0002010ac:	d8e7dce3          	bge	a5,a4,ffffffe000200e44 <task_init+0xa8>
    }
    nr_tasks = 2;
ffffffe0002010b0:	00008797          	auipc	a5,0x8
ffffffe0002010b4:	f6878793          	addi	a5,a5,-152 # ffffffe000209018 <nr_tasks>
ffffffe0002010b8:	00200713          	li	a4,2
ffffffe0002010bc:	00e7a023          	sw	a4,0(a5)

    for(int i = 2; i < NR_TASKS; i++){
ffffffe0002010c0:	00200793          	li	a5,2
ffffffe0002010c4:	fef42423          	sw	a5,-24(s0)
ffffffe0002010c8:	0280006f          	j	ffffffe0002010f0 <task_init+0x354>
        task[i] = NULL;
ffffffe0002010cc:	00008717          	auipc	a4,0x8
ffffffe0002010d0:	f6c70713          	addi	a4,a4,-148 # ffffffe000209038 <task>
ffffffe0002010d4:	fe842783          	lw	a5,-24(s0)
ffffffe0002010d8:	00379793          	slli	a5,a5,0x3
ffffffe0002010dc:	00f707b3          	add	a5,a4,a5
ffffffe0002010e0:	0007b023          	sd	zero,0(a5)
    for(int i = 2; i < NR_TASKS; i++){
ffffffe0002010e4:	fe842783          	lw	a5,-24(s0)
ffffffe0002010e8:	0017879b          	addiw	a5,a5,1
ffffffe0002010ec:	fef42423          	sw	a5,-24(s0)
ffffffe0002010f0:	fe842783          	lw	a5,-24(s0)
ffffffe0002010f4:	0007871b          	sext.w	a4,a5
ffffffe0002010f8:	00800793          	li	a5,8
ffffffe0002010fc:	fce7d8e3          	bge	a5,a4,ffffffe0002010cc <task_init+0x330>
    }

    printk("...task_init done!\n");
ffffffe000201100:	00003517          	auipc	a0,0x3
ffffffe000201104:	f9050513          	addi	a0,a0,-112 # ffffffe000204090 <__func__.0+0x90>
ffffffe000201108:	349020ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe00020110c:	00000013          	nop
ffffffe000201110:	01813083          	ld	ra,24(sp)
ffffffe000201114:	01013403          	ld	s0,16(sp)
ffffffe000201118:	02010113          	addi	sp,sp,32
ffffffe00020111c:	00008067          	ret

ffffffe000201120 <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next, uint64_t satp);

void switch_to(struct task_struct *next)
{
ffffffe000201120:	fd010113          	addi	sp,sp,-48
ffffffe000201124:	02113423          	sd	ra,40(sp)
ffffffe000201128:	02813023          	sd	s0,32(sp)
ffffffe00020112c:	03010413          	addi	s0,sp,48
ffffffe000201130:	fca43c23          	sd	a0,-40(s0)
    if (current != next)
ffffffe000201134:	00008797          	auipc	a5,0x8
ffffffe000201138:	edc78793          	addi	a5,a5,-292 # ffffffe000209010 <current>
ffffffe00020113c:	0007b783          	ld	a5,0(a5)
ffffffe000201140:	fd843703          	ld	a4,-40(s0)
ffffffe000201144:	06f70e63          	beq	a4,a5,ffffffe0002011c0 <switch_to+0xa0>
    {
        struct task_struct *prev = current;
ffffffe000201148:	00008797          	auipc	a5,0x8
ffffffe00020114c:	ec878793          	addi	a5,a5,-312 # ffffffe000209010 <current>
ffffffe000201150:	0007b783          	ld	a5,0(a5)
ffffffe000201154:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe000201158:	00008797          	auipc	a5,0x8
ffffffe00020115c:	eb878793          	addi	a5,a5,-328 # ffffffe000209010 <current>
ffffffe000201160:	fd843703          	ld	a4,-40(s0)
ffffffe000201164:	00e7b023          	sd	a4,0(a5)
        printk("from [%d] switch to [%d]\n", prev->pid, next->pid);
ffffffe000201168:	fe843783          	ld	a5,-24(s0)
ffffffe00020116c:	0187b703          	ld	a4,24(a5)
ffffffe000201170:	fd843783          	ld	a5,-40(s0)
ffffffe000201174:	0187b783          	ld	a5,24(a5)
ffffffe000201178:	00078613          	mv	a2,a5
ffffffe00020117c:	00070593          	mv	a1,a4
ffffffe000201180:	00003517          	auipc	a0,0x3
ffffffe000201184:	f2850513          	addi	a0,a0,-216 # ffffffe0002040a8 <__func__.0+0xa8>
ffffffe000201188:	2c9020ef          	jal	ra,ffffffe000203c50 <printk>
        uint64_t next_satp = get_satp(next->pgd);
ffffffe00020118c:	fd843783          	ld	a5,-40(s0)
ffffffe000201190:	0a87b783          	ld	a5,168(a5)
ffffffe000201194:	00078513          	mv	a0,a5
ffffffe000201198:	53c010ef          	jal	ra,ffffffe0002026d4 <get_satp>
ffffffe00020119c:	fea43023          	sd	a0,-32(s0)
        __switch_to(&(prev->thread), &(next->thread), next_satp);
ffffffe0002011a0:	fe843783          	ld	a5,-24(s0)
ffffffe0002011a4:	02078713          	addi	a4,a5,32
ffffffe0002011a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002011ac:	02078793          	addi	a5,a5,32
ffffffe0002011b0:	fe043603          	ld	a2,-32(s0)
ffffffe0002011b4:	00078593          	mv	a1,a5
ffffffe0002011b8:	00070513          	mv	a0,a4
ffffffe0002011bc:	834ff0ef          	jal	ra,ffffffe0002001f0 <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
ffffffe0002011c0:	00000013          	nop
ffffffe0002011c4:	02813083          	ld	ra,40(sp)
ffffffe0002011c8:	02013403          	ld	s0,32(sp)
ffffffe0002011cc:	03010113          	addi	sp,sp,48
ffffffe0002011d0:	00008067          	ret

ffffffe0002011d4 <do_timer>:

void do_timer()
{
ffffffe0002011d4:	ff010113          	addi	sp,sp,-16
ffffffe0002011d8:	00113423          	sd	ra,8(sp)
ffffffe0002011dc:	00813023          	sd	s0,0(sp)
ffffffe0002011e0:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0)
ffffffe0002011e4:	00008797          	auipc	a5,0x8
ffffffe0002011e8:	e2c78793          	addi	a5,a5,-468 # ffffffe000209010 <current>
ffffffe0002011ec:	0007b783          	ld	a5,0(a5)
ffffffe0002011f0:	0187b783          	ld	a5,24(a5)
ffffffe0002011f4:	00078c63          	beqz	a5,ffffffe00020120c <do_timer+0x38>
ffffffe0002011f8:	00008797          	auipc	a5,0x8
ffffffe0002011fc:	e1878793          	addi	a5,a5,-488 # ffffffe000209010 <current>
ffffffe000201200:	0007b783          	ld	a5,0(a5)
ffffffe000201204:	0087b783          	ld	a5,8(a5)
ffffffe000201208:	00079663          	bnez	a5,ffffffe000201214 <do_timer+0x40>
    {
        schedule();
ffffffe00020120c:	050000ef          	jal	ra,ffffffe00020125c <schedule>
ffffffe000201210:	03c0006f          	j	ffffffe00020124c <do_timer+0x78>
    }
    else
    {
        --(current->counter);
ffffffe000201214:	00008797          	auipc	a5,0x8
ffffffe000201218:	dfc78793          	addi	a5,a5,-516 # ffffffe000209010 <current>
ffffffe00020121c:	0007b783          	ld	a5,0(a5)
ffffffe000201220:	0087b703          	ld	a4,8(a5)
ffffffe000201224:	fff70713          	addi	a4,a4,-1
ffffffe000201228:	00e7b423          	sd	a4,8(a5)
        if (current->counter > 0)
ffffffe00020122c:	00008797          	auipc	a5,0x8
ffffffe000201230:	de478793          	addi	a5,a5,-540 # ffffffe000209010 <current>
ffffffe000201234:	0007b783          	ld	a5,0(a5)
ffffffe000201238:	0087b783          	ld	a5,8(a5)
ffffffe00020123c:	00079663          	bnez	a5,ffffffe000201248 <do_timer+0x74>
        {
            return;
        }
        schedule();
ffffffe000201240:	01c000ef          	jal	ra,ffffffe00020125c <schedule>
ffffffe000201244:	0080006f          	j	ffffffe00020124c <do_timer+0x78>
            return;
ffffffe000201248:	00000013          	nop
    }
}
ffffffe00020124c:	00813083          	ld	ra,8(sp)
ffffffe000201250:	00013403          	ld	s0,0(sp)
ffffffe000201254:	01010113          	addi	sp,sp,16
ffffffe000201258:	00008067          	ret

ffffffe00020125c <schedule>:

void schedule()
{
ffffffe00020125c:	fd010113          	addi	sp,sp,-48
ffffffe000201260:	02113423          	sd	ra,40(sp)
ffffffe000201264:	02813023          	sd	s0,32(sp)
ffffffe000201268:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe00020126c:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
ffffffe000201270:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < nr_tasks; i++)
ffffffe000201274:	00100793          	li	a5,1
ffffffe000201278:	fef42023          	sw	a5,-32(s0)
ffffffe00020127c:	0ac0006f          	j	ffffffe000201328 <schedule+0xcc>
    {
        if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe000201280:	00008717          	auipc	a4,0x8
ffffffe000201284:	db870713          	addi	a4,a4,-584 # ffffffe000209038 <task>
ffffffe000201288:	fe042783          	lw	a5,-32(s0)
ffffffe00020128c:	00379793          	slli	a5,a5,0x3
ffffffe000201290:	00f707b3          	add	a5,a4,a5
ffffffe000201294:	0007b783          	ld	a5,0(a5)
ffffffe000201298:	08078263          	beqz	a5,ffffffe00020131c <schedule+0xc0>
ffffffe00020129c:	00008717          	auipc	a4,0x8
ffffffe0002012a0:	d9c70713          	addi	a4,a4,-612 # ffffffe000209038 <task>
ffffffe0002012a4:	fe042783          	lw	a5,-32(s0)
ffffffe0002012a8:	00379793          	slli	a5,a5,0x3
ffffffe0002012ac:	00f707b3          	add	a5,a4,a5
ffffffe0002012b0:	0007b783          	ld	a5,0(a5)
ffffffe0002012b4:	0007b783          	ld	a5,0(a5)
ffffffe0002012b8:	06079263          	bnez	a5,ffffffe00020131c <schedule+0xc0>
        {
            if (task[i]->counter > max_counter)
ffffffe0002012bc:	00008717          	auipc	a4,0x8
ffffffe0002012c0:	d7c70713          	addi	a4,a4,-644 # ffffffe000209038 <task>
ffffffe0002012c4:	fe042783          	lw	a5,-32(s0)
ffffffe0002012c8:	00379793          	slli	a5,a5,0x3
ffffffe0002012cc:	00f707b3          	add	a5,a4,a5
ffffffe0002012d0:	0007b783          	ld	a5,0(a5)
ffffffe0002012d4:	0087b703          	ld	a4,8(a5)
ffffffe0002012d8:	fe442783          	lw	a5,-28(s0)
ffffffe0002012dc:	04e7f063          	bgeu	a5,a4,ffffffe00020131c <schedule+0xc0>
            {
                max_counter = task[i]->counter;
ffffffe0002012e0:	00008717          	auipc	a4,0x8
ffffffe0002012e4:	d5870713          	addi	a4,a4,-680 # ffffffe000209038 <task>
ffffffe0002012e8:	fe042783          	lw	a5,-32(s0)
ffffffe0002012ec:	00379793          	slli	a5,a5,0x3
ffffffe0002012f0:	00f707b3          	add	a5,a4,a5
ffffffe0002012f4:	0007b783          	ld	a5,0(a5)
ffffffe0002012f8:	0087b783          	ld	a5,8(a5)
ffffffe0002012fc:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe000201300:	00008717          	auipc	a4,0x8
ffffffe000201304:	d3870713          	addi	a4,a4,-712 # ffffffe000209038 <task>
ffffffe000201308:	fe042783          	lw	a5,-32(s0)
ffffffe00020130c:	00379793          	slli	a5,a5,0x3
ffffffe000201310:	00f707b3          	add	a5,a4,a5
ffffffe000201314:	0007b783          	ld	a5,0(a5)
ffffffe000201318:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < nr_tasks; i++)
ffffffe00020131c:	fe042783          	lw	a5,-32(s0)
ffffffe000201320:	0017879b          	addiw	a5,a5,1
ffffffe000201324:	fef42023          	sw	a5,-32(s0)
ffffffe000201328:	00008797          	auipc	a5,0x8
ffffffe00020132c:	cf078793          	addi	a5,a5,-784 # ffffffe000209018 <nr_tasks>
ffffffe000201330:	0007a703          	lw	a4,0(a5)
ffffffe000201334:	fe042783          	lw	a5,-32(s0)
ffffffe000201338:	0007879b          	sext.w	a5,a5
ffffffe00020133c:	f4e7c2e3          	blt	a5,a4,ffffffe000201280 <schedule+0x24>
            }
        }
    }

    if (max_counter == 0)
ffffffe000201340:	fe442783          	lw	a5,-28(s0)
ffffffe000201344:	0007879b          	sext.w	a5,a5
ffffffe000201348:	0a079663          	bnez	a5,ffffffe0002013f4 <schedule+0x198>
    {
        for (int i = 0; i < nr_tasks; i++)
ffffffe00020134c:	fc042e23          	sw	zero,-36(s0)
ffffffe000201350:	0840006f          	j	ffffffe0002013d4 <schedule+0x178>
        {
            if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe000201354:	00008717          	auipc	a4,0x8
ffffffe000201358:	ce470713          	addi	a4,a4,-796 # ffffffe000209038 <task>
ffffffe00020135c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201360:	00379793          	slli	a5,a5,0x3
ffffffe000201364:	00f707b3          	add	a5,a4,a5
ffffffe000201368:	0007b783          	ld	a5,0(a5)
ffffffe00020136c:	04078e63          	beqz	a5,ffffffe0002013c8 <schedule+0x16c>
ffffffe000201370:	00008717          	auipc	a4,0x8
ffffffe000201374:	cc870713          	addi	a4,a4,-824 # ffffffe000209038 <task>
ffffffe000201378:	fdc42783          	lw	a5,-36(s0)
ffffffe00020137c:	00379793          	slli	a5,a5,0x3
ffffffe000201380:	00f707b3          	add	a5,a4,a5
ffffffe000201384:	0007b783          	ld	a5,0(a5)
ffffffe000201388:	0007b783          	ld	a5,0(a5)
ffffffe00020138c:	02079e63          	bnez	a5,ffffffe0002013c8 <schedule+0x16c>
            {
                task[i]->counter = task[i]->priority;
ffffffe000201390:	00008717          	auipc	a4,0x8
ffffffe000201394:	ca870713          	addi	a4,a4,-856 # ffffffe000209038 <task>
ffffffe000201398:	fdc42783          	lw	a5,-36(s0)
ffffffe00020139c:	00379793          	slli	a5,a5,0x3
ffffffe0002013a0:	00f707b3          	add	a5,a4,a5
ffffffe0002013a4:	0007b703          	ld	a4,0(a5)
ffffffe0002013a8:	00008697          	auipc	a3,0x8
ffffffe0002013ac:	c9068693          	addi	a3,a3,-880 # ffffffe000209038 <task>
ffffffe0002013b0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013b4:	00379793          	slli	a5,a5,0x3
ffffffe0002013b8:	00f687b3          	add	a5,a3,a5
ffffffe0002013bc:	0007b783          	ld	a5,0(a5)
ffffffe0002013c0:	01073703          	ld	a4,16(a4)
ffffffe0002013c4:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < nr_tasks; i++)
ffffffe0002013c8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013cc:	0017879b          	addiw	a5,a5,1
ffffffe0002013d0:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002013d4:	00008797          	auipc	a5,0x8
ffffffe0002013d8:	c4478793          	addi	a5,a5,-956 # ffffffe000209018 <nr_tasks>
ffffffe0002013dc:	0007a703          	lw	a4,0(a5)
ffffffe0002013e0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013e4:	0007879b          	sext.w	a5,a5
ffffffe0002013e8:	f6e7c6e3          	blt	a5,a4,ffffffe000201354 <schedule+0xf8>
            }
        }
        schedule();
ffffffe0002013ec:	e71ff0ef          	jal	ra,ffffffe00020125c <schedule>
        return;
ffffffe0002013f0:	0280006f          	j	ffffffe000201418 <schedule+0x1bc>
    }

    if (next && next != current)
ffffffe0002013f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002013f8:	02078063          	beqz	a5,ffffffe000201418 <schedule+0x1bc>
ffffffe0002013fc:	00008797          	auipc	a5,0x8
ffffffe000201400:	c1478793          	addi	a5,a5,-1004 # ffffffe000209010 <current>
ffffffe000201404:	0007b783          	ld	a5,0(a5)
ffffffe000201408:	fe843703          	ld	a4,-24(s0)
ffffffe00020140c:	00f70663          	beq	a4,a5,ffffffe000201418 <schedule+0x1bc>
    {
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
ffffffe000201410:	fe843503          	ld	a0,-24(s0)
ffffffe000201414:	d0dff0ef          	jal	ra,ffffffe000201120 <switch_to>
    }
}
ffffffe000201418:	02813083          	ld	ra,40(sp)
ffffffe00020141c:	02013403          	ld	s0,32(sp)
ffffffe000201420:	03010113          	addi	sp,sp,48
ffffffe000201424:	00008067          	ret

ffffffe000201428 <find_vma>:
* @mm       : current thread's mm_struct
* @addr     : the va to look up
*
* @return   : the VMA if found or NULL if not found
*/
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
ffffffe000201428:	fd010113          	addi	sp,sp,-48
ffffffe00020142c:	02813423          	sd	s0,40(sp)
ffffffe000201430:	03010413          	addi	s0,sp,48
ffffffe000201434:	fca43c23          	sd	a0,-40(s0)
ffffffe000201438:	fcb43823          	sd	a1,-48(s0)
    struct vm_area_struct *vma = mm->mmap;
ffffffe00020143c:	fd843783          	ld	a5,-40(s0)
ffffffe000201440:	0007b783          	ld	a5,0(a5)
ffffffe000201444:	fef43423          	sd	a5,-24(s0)
    while(vma){
ffffffe000201448:	0380006f          	j	ffffffe000201480 <find_vma+0x58>
        if(addr >= vma->vm_start && addr < vma->vm_end){
ffffffe00020144c:	fe843783          	ld	a5,-24(s0)
ffffffe000201450:	0087b783          	ld	a5,8(a5)
ffffffe000201454:	fd043703          	ld	a4,-48(s0)
ffffffe000201458:	00f76e63          	bltu	a4,a5,ffffffe000201474 <find_vma+0x4c>
ffffffe00020145c:	fe843783          	ld	a5,-24(s0)
ffffffe000201460:	0107b783          	ld	a5,16(a5)
ffffffe000201464:	fd043703          	ld	a4,-48(s0)
ffffffe000201468:	00f77663          	bgeu	a4,a5,ffffffe000201474 <find_vma+0x4c>
            return vma;
ffffffe00020146c:	fe843783          	ld	a5,-24(s0)
ffffffe000201470:	01c0006f          	j	ffffffe00020148c <find_vma+0x64>
        }
        vma = vma->vm_next;
ffffffe000201474:	fe843783          	ld	a5,-24(s0)
ffffffe000201478:	0187b783          	ld	a5,24(a5)
ffffffe00020147c:	fef43423          	sd	a5,-24(s0)
    while(vma){
ffffffe000201480:	fe843783          	ld	a5,-24(s0)
ffffffe000201484:	fc0794e3          	bnez	a5,ffffffe00020144c <find_vma+0x24>
    }
    return NULL;
ffffffe000201488:	00000793          	li	a5,0
}
ffffffe00020148c:	00078513          	mv	a0,a5
ffffffe000201490:	02813403          	ld	s0,40(sp)
ffffffe000201494:	03010113          	addi	sp,sp,48
ffffffe000201498:	00008067          	ret

ffffffe00020149c <do_mmap>:
* @vm_filesz: phdr->p_filesz
* @flags    : flags for the new VMA
*
* @return   : start va
*/
uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
ffffffe00020149c:	f9010113          	addi	sp,sp,-112
ffffffe0002014a0:	06113423          	sd	ra,104(sp)
ffffffe0002014a4:	06813023          	sd	s0,96(sp)
ffffffe0002014a8:	07010413          	addi	s0,sp,112
ffffffe0002014ac:	faa43c23          	sd	a0,-72(s0)
ffffffe0002014b0:	fab43823          	sd	a1,-80(s0)
ffffffe0002014b4:	fac43423          	sd	a2,-88(s0)
ffffffe0002014b8:	fad43023          	sd	a3,-96(s0)
ffffffe0002014bc:	f8e43c23          	sd	a4,-104(s0)
ffffffe0002014c0:	f8f43823          	sd	a5,-112(s0)
    uint64_t start = addr;
ffffffe0002014c4:	fb043783          	ld	a5,-80(s0)
ffffffe0002014c8:	fcf43c23          	sd	a5,-40(s0)
    uint64_t end = addr + len;
ffffffe0002014cc:	fb043703          	ld	a4,-80(s0)
ffffffe0002014d0:	fa843783          	ld	a5,-88(s0)
ffffffe0002014d4:	00f707b3          	add	a5,a4,a5
ffffffe0002014d8:	fcf43823          	sd	a5,-48(s0)
    struct vm_area_struct *vma = mm->mmap;
ffffffe0002014dc:	fb843783          	ld	a5,-72(s0)
ffffffe0002014e0:	0007b783          	ld	a5,0(a5)
ffffffe0002014e4:	fef43423          	sd	a5,-24(s0)
    struct vm_area_struct *prev = NULL;
ffffffe0002014e8:	fe043023          	sd	zero,-32(s0)
    while(vma){
ffffffe0002014ec:	0280006f          	j	ffffffe000201514 <do_mmap+0x78>
        if(end <= vma->vm_start){
ffffffe0002014f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002014f4:	0087b783          	ld	a5,8(a5)
ffffffe0002014f8:	fd043703          	ld	a4,-48(s0)
ffffffe0002014fc:	02e7f263          	bgeu	a5,a4,ffffffe000201520 <do_mmap+0x84>
            break;
        }
        prev = vma;
ffffffe000201500:	fe843783          	ld	a5,-24(s0)
ffffffe000201504:	fef43023          	sd	a5,-32(s0)
        vma = vma->vm_next;
ffffffe000201508:	fe843783          	ld	a5,-24(s0)
ffffffe00020150c:	0187b783          	ld	a5,24(a5)
ffffffe000201510:	fef43423          	sd	a5,-24(s0)
    while(vma){
ffffffe000201514:	fe843783          	ld	a5,-24(s0)
ffffffe000201518:	fc079ce3          	bnez	a5,ffffffe0002014f0 <do_mmap+0x54>
ffffffe00020151c:	0080006f          	j	ffffffe000201524 <do_mmap+0x88>
            break;
ffffffe000201520:	00000013          	nop
    }
    struct vm_area_struct *new_vma = (struct vm_area_struct *)kalloc();
ffffffe000201524:	ca8ff0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000201528:	fca43423          	sd	a0,-56(s0)
    new_vma->vm_mm = mm;
ffffffe00020152c:	fc843783          	ld	a5,-56(s0)
ffffffe000201530:	fb843703          	ld	a4,-72(s0)
ffffffe000201534:	00e7b023          	sd	a4,0(a5)
    new_vma->vm_start = start;
ffffffe000201538:	fc843783          	ld	a5,-56(s0)
ffffffe00020153c:	fd843703          	ld	a4,-40(s0)
ffffffe000201540:	00e7b423          	sd	a4,8(a5)
    new_vma->vm_end = end;
ffffffe000201544:	fc843783          	ld	a5,-56(s0)
ffffffe000201548:	fd043703          	ld	a4,-48(s0)
ffffffe00020154c:	00e7b823          	sd	a4,16(a5)
    new_vma->vm_flags = flags;
ffffffe000201550:	fc843783          	ld	a5,-56(s0)
ffffffe000201554:	f9043703          	ld	a4,-112(s0)
ffffffe000201558:	02e7b423          	sd	a4,40(a5)
    new_vma->vm_pgoff = vm_pgoff;
ffffffe00020155c:	fc843783          	ld	a5,-56(s0)
ffffffe000201560:	fa043703          	ld	a4,-96(s0)
ffffffe000201564:	02e7b823          	sd	a4,48(a5)
    new_vma->vm_filesz = vm_filesz;
ffffffe000201568:	fc843783          	ld	a5,-56(s0)
ffffffe00020156c:	f9843703          	ld	a4,-104(s0)
ffffffe000201570:	02e7bc23          	sd	a4,56(a5)
    if(prev){
ffffffe000201574:	fe043783          	ld	a5,-32(s0)
ffffffe000201578:	02078063          	beqz	a5,ffffffe000201598 <do_mmap+0xfc>
        prev->vm_next = new_vma;
ffffffe00020157c:	fe043783          	ld	a5,-32(s0)
ffffffe000201580:	fc843703          	ld	a4,-56(s0)
ffffffe000201584:	00e7bc23          	sd	a4,24(a5)
        new_vma->vm_prev = prev;
ffffffe000201588:	fc843783          	ld	a5,-56(s0)
ffffffe00020158c:	fe043703          	ld	a4,-32(s0)
ffffffe000201590:	02e7b023          	sd	a4,32(a5)
ffffffe000201594:	0100006f          	j	ffffffe0002015a4 <do_mmap+0x108>
    }else{
        mm->mmap = new_vma;
ffffffe000201598:	fb843783          	ld	a5,-72(s0)
ffffffe00020159c:	fc843703          	ld	a4,-56(s0)
ffffffe0002015a0:	00e7b023          	sd	a4,0(a5)
    }
    new_vma->vm_next = vma;
ffffffe0002015a4:	fc843783          	ld	a5,-56(s0)
ffffffe0002015a8:	fe843703          	ld	a4,-24(s0)
ffffffe0002015ac:	00e7bc23          	sd	a4,24(a5)
    if(vma){
ffffffe0002015b0:	fe843783          	ld	a5,-24(s0)
ffffffe0002015b4:	00078863          	beqz	a5,ffffffe0002015c4 <do_mmap+0x128>
        vma->vm_prev = new_vma;
ffffffe0002015b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002015bc:	fc843703          	ld	a4,-56(s0)
ffffffe0002015c0:	02e7b023          	sd	a4,32(a5)
    }
    return start;
ffffffe0002015c4:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002015c8:	00078513          	mv	a0,a5
ffffffe0002015cc:	06813083          	ld	ra,104(sp)
ffffffe0002015d0:	06013403          	ld	s0,96(sp)
ffffffe0002015d4:	07010113          	addi	sp,sp,112
ffffffe0002015d8:	00008067          	ret

ffffffe0002015dc <add_task>:

int add_task(struct task_struct *T)
{
ffffffe0002015dc:	fe010113          	addi	sp,sp,-32
ffffffe0002015e0:	00813c23          	sd	s0,24(sp)
ffffffe0002015e4:	02010413          	addi	s0,sp,32
ffffffe0002015e8:	fea43423          	sd	a0,-24(s0)
    if (nr_tasks >= NR_TASKS)
ffffffe0002015ec:	00008797          	auipc	a5,0x8
ffffffe0002015f0:	a2c78793          	addi	a5,a5,-1492 # ffffffe000209018 <nr_tasks>
ffffffe0002015f4:	0007a783          	lw	a5,0(a5)
ffffffe0002015f8:	00078713          	mv	a4,a5
ffffffe0002015fc:	00800793          	li	a5,8
ffffffe000201600:	00e7d663          	bge	a5,a4,ffffffe00020160c <add_task+0x30>
    {
        return -1;
ffffffe000201604:	fff00793          	li	a5,-1
ffffffe000201608:	0500006f          	j	ffffffe000201658 <add_task+0x7c>
    }
    task[nr_tasks++] = T;
ffffffe00020160c:	00008797          	auipc	a5,0x8
ffffffe000201610:	a0c78793          	addi	a5,a5,-1524 # ffffffe000209018 <nr_tasks>
ffffffe000201614:	0007a783          	lw	a5,0(a5)
ffffffe000201618:	0017871b          	addiw	a4,a5,1
ffffffe00020161c:	0007069b          	sext.w	a3,a4
ffffffe000201620:	00008717          	auipc	a4,0x8
ffffffe000201624:	9f870713          	addi	a4,a4,-1544 # ffffffe000209018 <nr_tasks>
ffffffe000201628:	00d72023          	sw	a3,0(a4)
ffffffe00020162c:	00008717          	auipc	a4,0x8
ffffffe000201630:	a0c70713          	addi	a4,a4,-1524 # ffffffe000209038 <task>
ffffffe000201634:	00379793          	slli	a5,a5,0x3
ffffffe000201638:	00f707b3          	add	a5,a4,a5
ffffffe00020163c:	fe843703          	ld	a4,-24(s0)
ffffffe000201640:	00e7b023          	sd	a4,0(a5)
    return nr_tasks - 1;
ffffffe000201644:	00008797          	auipc	a5,0x8
ffffffe000201648:	9d478793          	addi	a5,a5,-1580 # ffffffe000209018 <nr_tasks>
ffffffe00020164c:	0007a783          	lw	a5,0(a5)
ffffffe000201650:	fff7879b          	addiw	a5,a5,-1
ffffffe000201654:	0007879b          	sext.w	a5,a5
}
ffffffe000201658:	00078513          	mv	a0,a5
ffffffe00020165c:	01813403          	ld	s0,24(sp)
ffffffe000201660:	02010113          	addi	sp,sp,32
ffffffe000201664:	00008067          	ret

ffffffe000201668 <dummy>:
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy()
{
ffffffe000201668:	fd010113          	addi	sp,sp,-48
ffffffe00020166c:	02113423          	sd	ra,40(sp)
ffffffe000201670:	02813023          	sd	s0,32(sp)
ffffffe000201674:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000201678:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe00020167c:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000201680:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000201684:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000201688:	fff00793          	li	a5,-1
ffffffe00020168c:	fef42223          	sw	a5,-28(s0)
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201690:	fe442783          	lw	a5,-28(s0)
ffffffe000201694:	0007871b          	sext.w	a4,a5
ffffffe000201698:	fff00793          	li	a5,-1
ffffffe00020169c:	00f70e63          	beq	a4,a5,ffffffe0002016b8 <dummy+0x50>
ffffffe0002016a0:	00008797          	auipc	a5,0x8
ffffffe0002016a4:	97078793          	addi	a5,a5,-1680 # ffffffe000209010 <current>
ffffffe0002016a8:	0007b783          	ld	a5,0(a5)
ffffffe0002016ac:	0087b703          	ld	a4,8(a5)
ffffffe0002016b0:	fe442783          	lw	a5,-28(s0)
ffffffe0002016b4:	fcf70ee3          	beq	a4,a5,ffffffe000201690 <dummy+0x28>
ffffffe0002016b8:	00008797          	auipc	a5,0x8
ffffffe0002016bc:	95878793          	addi	a5,a5,-1704 # ffffffe000209010 <current>
ffffffe0002016c0:	0007b783          	ld	a5,0(a5)
ffffffe0002016c4:	0087b783          	ld	a5,8(a5)
ffffffe0002016c8:	fc0784e3          	beqz	a5,ffffffe000201690 <dummy+0x28>
        {
            if (current->counter == 1)
ffffffe0002016cc:	00008797          	auipc	a5,0x8
ffffffe0002016d0:	94478793          	addi	a5,a5,-1724 # ffffffe000209010 <current>
ffffffe0002016d4:	0007b783          	ld	a5,0(a5)
ffffffe0002016d8:	0087b703          	ld	a4,8(a5)
ffffffe0002016dc:	00100793          	li	a5,1
ffffffe0002016e0:	00f71e63          	bne	a4,a5,ffffffe0002016fc <dummy+0x94>
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002016e4:	00008797          	auipc	a5,0x8
ffffffe0002016e8:	92c78793          	addi	a5,a5,-1748 # ffffffe000209010 <current>
ffffffe0002016ec:	0007b783          	ld	a5,0(a5)
ffffffe0002016f0:	0087b703          	ld	a4,8(a5)
ffffffe0002016f4:	fff70713          	addi	a4,a4,-1
ffffffe0002016f8:	00e7b423          	sd	a4,8(a5)
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002016fc:	00008797          	auipc	a5,0x8
ffffffe000201700:	91478793          	addi	a5,a5,-1772 # ffffffe000209010 <current>
ffffffe000201704:	0007b783          	ld	a5,0(a5)
ffffffe000201708:	0087b783          	ld	a5,8(a5)
ffffffe00020170c:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000201710:	fe843783          	ld	a5,-24(s0)
ffffffe000201714:	00178713          	addi	a4,a5,1
ffffffe000201718:	fd843783          	ld	a5,-40(s0)
ffffffe00020171c:	02f777b3          	remu	a5,a4,a5
ffffffe000201720:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe000201724:	00008797          	auipc	a5,0x8
ffffffe000201728:	8ec78793          	addi	a5,a5,-1812 # ffffffe000209010 <current>
ffffffe00020172c:	0007b783          	ld	a5,0(a5)
ffffffe000201730:	0187b783          	ld	a5,24(a5)
ffffffe000201734:	fe843603          	ld	a2,-24(s0)
ffffffe000201738:	00078593          	mv	a1,a5
ffffffe00020173c:	00003517          	auipc	a0,0x3
ffffffe000201740:	98c50513          	addi	a0,a0,-1652 # ffffffe0002040c8 <__func__.0+0xc8>
ffffffe000201744:	50c020ef          	jal	ra,ffffffe000203c50 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201748:	f49ff06f          	j	ffffffe000201690 <dummy+0x28>

ffffffe00020174c <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe00020174c:	f8010113          	addi	sp,sp,-128
ffffffe000201750:	06813c23          	sd	s0,120(sp)
ffffffe000201754:	06913823          	sd	s1,112(sp)
ffffffe000201758:	07213423          	sd	s2,104(sp)
ffffffe00020175c:	07313023          	sd	s3,96(sp)
ffffffe000201760:	08010413          	addi	s0,sp,128
ffffffe000201764:	faa43c23          	sd	a0,-72(s0)
ffffffe000201768:	fab43823          	sd	a1,-80(s0)
ffffffe00020176c:	fac43423          	sd	a2,-88(s0)
ffffffe000201770:	fad43023          	sd	a3,-96(s0)
ffffffe000201774:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201778:	f8f43823          	sd	a5,-112(s0)
ffffffe00020177c:	f9043423          	sd	a6,-120(s0)
ffffffe000201780:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe000201784:	fb843e03          	ld	t3,-72(s0)
ffffffe000201788:	fb043e83          	ld	t4,-80(s0)
ffffffe00020178c:	fa843f03          	ld	t5,-88(s0)
ffffffe000201790:	fa043f83          	ld	t6,-96(s0)
ffffffe000201794:	f9843283          	ld	t0,-104(s0)
ffffffe000201798:	f9043483          	ld	s1,-112(s0)
ffffffe00020179c:	f8843903          	ld	s2,-120(s0)
ffffffe0002017a0:	f8043983          	ld	s3,-128(s0)
ffffffe0002017a4:	000e0893          	mv	a7,t3
ffffffe0002017a8:	000e8813          	mv	a6,t4
ffffffe0002017ac:	000f0513          	mv	a0,t5
ffffffe0002017b0:	000f8593          	mv	a1,t6
ffffffe0002017b4:	00028613          	mv	a2,t0
ffffffe0002017b8:	00048693          	mv	a3,s1
ffffffe0002017bc:	00090713          	mv	a4,s2
ffffffe0002017c0:	00098793          	mv	a5,s3
ffffffe0002017c4:	00000073          	ecall
ffffffe0002017c8:	00050e93          	mv	t4,a0
ffffffe0002017cc:	00058e13          	mv	t3,a1
ffffffe0002017d0:	fdd43023          	sd	t4,-64(s0)
ffffffe0002017d4:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe0002017d8:	fc043783          	ld	a5,-64(s0)
ffffffe0002017dc:	fcf43823          	sd	a5,-48(s0)
ffffffe0002017e0:	fc843783          	ld	a5,-56(s0)
ffffffe0002017e4:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002017e8:	fd043703          	ld	a4,-48(s0)
ffffffe0002017ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002017f0:	00070313          	mv	t1,a4
ffffffe0002017f4:	00078393          	mv	t2,a5
ffffffe0002017f8:	00030713          	mv	a4,t1
ffffffe0002017fc:	00038793          	mv	a5,t2
}
ffffffe000201800:	00070513          	mv	a0,a4
ffffffe000201804:	00078593          	mv	a1,a5
ffffffe000201808:	07813403          	ld	s0,120(sp)
ffffffe00020180c:	07013483          	ld	s1,112(sp)
ffffffe000201810:	06813903          	ld	s2,104(sp)
ffffffe000201814:	06013983          	ld	s3,96(sp)
ffffffe000201818:	08010113          	addi	sp,sp,128
ffffffe00020181c:	00008067          	ret

ffffffe000201820 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000201820:	fd010113          	addi	sp,sp,-48
ffffffe000201824:	02813423          	sd	s0,40(sp)
ffffffe000201828:	03010413          	addi	s0,sp,48
ffffffe00020182c:	00050793          	mv	a5,a0
ffffffe000201830:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000201834:	00100793          	li	a5,1
ffffffe000201838:	00000713          	li	a4,0
ffffffe00020183c:	fdf44683          	lbu	a3,-33(s0)
ffffffe000201840:	00078893          	mv	a7,a5
ffffffe000201844:	00070813          	mv	a6,a4
ffffffe000201848:	00068513          	mv	a0,a3
ffffffe00020184c:	00000073          	ecall
ffffffe000201850:	00050713          	mv	a4,a0
ffffffe000201854:	00058793          	mv	a5,a1
ffffffe000201858:	fee43023          	sd	a4,-32(s0)
ffffffe00020185c:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe000201860:	00000013          	nop
ffffffe000201864:	00070513          	mv	a0,a4
ffffffe000201868:	00078593          	mv	a1,a5
ffffffe00020186c:	02813403          	ld	s0,40(sp)
ffffffe000201870:	03010113          	addi	sp,sp,48
ffffffe000201874:	00008067          	ret

ffffffe000201878 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000201878:	fc010113          	addi	sp,sp,-64
ffffffe00020187c:	02813c23          	sd	s0,56(sp)
ffffffe000201880:	04010413          	addi	s0,sp,64
ffffffe000201884:	00050793          	mv	a5,a0
ffffffe000201888:	00058713          	mv	a4,a1
ffffffe00020188c:	fcf42623          	sw	a5,-52(s0)
ffffffe000201890:	00070793          	mv	a5,a4
ffffffe000201894:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000201898:	00800793          	li	a5,8
ffffffe00020189c:	00000713          	li	a4,0
ffffffe0002018a0:	fcc42583          	lw	a1,-52(s0)
ffffffe0002018a4:	00058313          	mv	t1,a1
ffffffe0002018a8:	fc842583          	lw	a1,-56(s0)
ffffffe0002018ac:	00058e13          	mv	t3,a1
ffffffe0002018b0:	00078893          	mv	a7,a5
ffffffe0002018b4:	00070813          	mv	a6,a4
ffffffe0002018b8:	00030513          	mv	a0,t1
ffffffe0002018bc:	000e0593          	mv	a1,t3
ffffffe0002018c0:	00000073          	ecall
ffffffe0002018c4:	00050713          	mv	a4,a0
ffffffe0002018c8:	00058793          	mv	a5,a1
ffffffe0002018cc:	fce43823          	sd	a4,-48(s0)
ffffffe0002018d0:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe0002018d4:	fd043783          	ld	a5,-48(s0)
ffffffe0002018d8:	fef43023          	sd	a5,-32(s0)
ffffffe0002018dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002018e0:	fef43423          	sd	a5,-24(s0)
ffffffe0002018e4:	fe043703          	ld	a4,-32(s0)
ffffffe0002018e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002018ec:	00070613          	mv	a2,a4
ffffffe0002018f0:	00078693          	mv	a3,a5
ffffffe0002018f4:	00060713          	mv	a4,a2
ffffffe0002018f8:	00068793          	mv	a5,a3
ffffffe0002018fc:	00070513          	mv	a0,a4
ffffffe000201900:	00078593          	mv	a1,a5
ffffffe000201904:	03813403          	ld	s0,56(sp)
ffffffe000201908:	04010113          	addi	sp,sp,64
ffffffe00020190c:	00008067          	ret

ffffffe000201910 <sys_write>:
extern struct task_struct *get_current_proc();
extern int putc(int c);
extern void __ret_from_fork();

int sys_write(unsigned int fd, const char *buf, unsigned int size)
{
ffffffe000201910:	fd010113          	addi	sp,sp,-48
ffffffe000201914:	02113423          	sd	ra,40(sp)
ffffffe000201918:	02813023          	sd	s0,32(sp)
ffffffe00020191c:	03010413          	addi	s0,sp,48
ffffffe000201920:	00050793          	mv	a5,a0
ffffffe000201924:	fcb43823          	sd	a1,-48(s0)
ffffffe000201928:	00060713          	mv	a4,a2
ffffffe00020192c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201930:	00070793          	mv	a5,a4
ffffffe000201934:	fcf42c23          	sw	a5,-40(s0)
    int cnt = 0;
ffffffe000201938:	fe042623          	sw	zero,-20(s0)
    if (fd == STDOUT)
ffffffe00020193c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201940:	0007871b          	sext.w	a4,a5
ffffffe000201944:	00100793          	li	a5,1
ffffffe000201948:	06f71063          	bne	a4,a5,ffffffe0002019a8 <sys_write+0x98>
    {
        for (cnt = 0; cnt < size && buf[cnt]; ++cnt)
ffffffe00020194c:	fe042623          	sw	zero,-20(s0)
ffffffe000201950:	02c0006f          	j	ffffffe00020197c <sys_write+0x6c>
            putc(buf[cnt]);
ffffffe000201954:	fec42783          	lw	a5,-20(s0)
ffffffe000201958:	fd043703          	ld	a4,-48(s0)
ffffffe00020195c:	00f707b3          	add	a5,a4,a5
ffffffe000201960:	0007c783          	lbu	a5,0(a5)
ffffffe000201964:	0007879b          	sext.w	a5,a5
ffffffe000201968:	00078513          	mv	a0,a5
ffffffe00020196c:	450010ef          	jal	ra,ffffffe000202dbc <putc>
        for (cnt = 0; cnt < size && buf[cnt]; ++cnt)
ffffffe000201970:	fec42783          	lw	a5,-20(s0)
ffffffe000201974:	0017879b          	addiw	a5,a5,1
ffffffe000201978:	fef42623          	sw	a5,-20(s0)
ffffffe00020197c:	fec42703          	lw	a4,-20(s0)
ffffffe000201980:	fd842783          	lw	a5,-40(s0)
ffffffe000201984:	0007879b          	sext.w	a5,a5
ffffffe000201988:	00f77c63          	bgeu	a4,a5,ffffffe0002019a0 <sys_write+0x90>
ffffffe00020198c:	fec42783          	lw	a5,-20(s0)
ffffffe000201990:	fd043703          	ld	a4,-48(s0)
ffffffe000201994:	00f707b3          	add	a5,a4,a5
ffffffe000201998:	0007c783          	lbu	a5,0(a5)
ffffffe00020199c:	fa079ce3          	bnez	a5,ffffffe000201954 <sys_write+0x44>
        return cnt;
ffffffe0002019a0:	fec42783          	lw	a5,-20(s0)
ffffffe0002019a4:	0080006f          	j	ffffffe0002019ac <sys_write+0x9c>
    }
    return -1;
ffffffe0002019a8:	fff00793          	li	a5,-1
}
ffffffe0002019ac:	00078513          	mv	a0,a5
ffffffe0002019b0:	02813083          	ld	ra,40(sp)
ffffffe0002019b4:	02013403          	ld	s0,32(sp)
ffffffe0002019b8:	03010113          	addi	sp,sp,48
ffffffe0002019bc:	00008067          	ret

ffffffe0002019c0 <sys_getpid>:

int sys_getpid()
{
ffffffe0002019c0:	fe010113          	addi	sp,sp,-32
ffffffe0002019c4:	00113c23          	sd	ra,24(sp)
ffffffe0002019c8:	00813823          	sd	s0,16(sp)
ffffffe0002019cc:	02010413          	addi	s0,sp,32
    struct task_struct *current = get_current_proc();
ffffffe0002019d0:	930ff0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe0002019d4:	fea43423          	sd	a0,-24(s0)
    return current->pid;
ffffffe0002019d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002019dc:	0187b783          	ld	a5,24(a5)
ffffffe0002019e0:	0007879b          	sext.w	a5,a5
}
ffffffe0002019e4:	00078513          	mv	a0,a5
ffffffe0002019e8:	01813083          	ld	ra,24(sp)
ffffffe0002019ec:	01013403          	ld	s0,16(sp)
ffffffe0002019f0:	02010113          	addi	sp,sp,32
ffffffe0002019f4:	00008067          	ret

ffffffe0002019f8 <do_fork>:

uint64_t do_fork(struct pt_regs *regs)
{
ffffffe0002019f8:	fb010113          	addi	sp,sp,-80
ffffffe0002019fc:	04113423          	sd	ra,72(sp)
ffffffe000201a00:	04813023          	sd	s0,64(sp)
ffffffe000201a04:	02913c23          	sd	s1,56(sp)
ffffffe000201a08:	05010413          	addi	s0,sp,80
ffffffe000201a0c:	faa43c23          	sd	a0,-72(s0)
    struct task_struct *child_task = (struct task_struct *)kalloc();
ffffffe000201a10:	fbdfe0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000201a14:	fca43c23          	sd	a0,-40(s0)
    if (get_nr_tasks() >= NR_TASKS || !child_task)
ffffffe000201a18:	8c0ff0ef          	jal	ra,ffffffe000200ad8 <get_nr_tasks>
ffffffe000201a1c:	00050793          	mv	a5,a0
ffffffe000201a20:	00078713          	mv	a4,a5
ffffffe000201a24:	00800793          	li	a5,8
ffffffe000201a28:	00e7c663          	blt	a5,a4,ffffffe000201a34 <do_fork+0x3c>
ffffffe000201a2c:	fd843783          	ld	a5,-40(s0)
ffffffe000201a30:	02079463          	bnez	a5,ffffffe000201a58 <do_fork+0x60>
    {
        Err("do_fork: failed to fork\n");
ffffffe000201a34:	00002697          	auipc	a3,0x2
ffffffe000201a38:	5cc68693          	addi	a3,a3,1484 # ffffffe000204000 <__func__.0>
ffffffe000201a3c:	01e00613          	li	a2,30
ffffffe000201a40:	00002597          	auipc	a1,0x2
ffffffe000201a44:	6b858593          	addi	a1,a1,1720 # ffffffe0002040f8 <__func__.0+0xf8>
ffffffe000201a48:	00002517          	auipc	a0,0x2
ffffffe000201a4c:	6c050513          	addi	a0,a0,1728 # ffffffe000204108 <__func__.0+0x108>
ffffffe000201a50:	200020ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe000201a54:	0000006f          	j	ffffffe000201a54 <do_fork+0x5c>
    }
    memcpy(child_task, get_current_proc(), PGSIZE);
ffffffe000201a58:	8a8ff0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe000201a5c:	00050793          	mv	a5,a0
ffffffe000201a60:	00001637          	lui	a2,0x1
ffffffe000201a64:	00078593          	mv	a1,a5
ffffffe000201a68:	fd843503          	ld	a0,-40(s0)
ffffffe000201a6c:	374020ef          	jal	ra,ffffffe000203de0 <memcpy>
    child_task->pid = get_nr_tasks();
ffffffe000201a70:	868ff0ef          	jal	ra,ffffffe000200ad8 <get_nr_tasks>
ffffffe000201a74:	00050793          	mv	a5,a0
ffffffe000201a78:	00078713          	mv	a4,a5
ffffffe000201a7c:	fd843783          	ld	a5,-40(s0)
ffffffe000201a80:	00e7bc23          	sd	a4,24(a5)
    child_task->state = TASK_RUNNING;
ffffffe000201a84:	fd843783          	ld	a5,-40(s0)
ffffffe000201a88:	0007b023          	sd	zero,0(a5)
    child_task->counter = 0;
ffffffe000201a8c:	fd843783          	ld	a5,-40(s0)
ffffffe000201a90:	0007b423          	sd	zero,8(a5)
    child_task->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000201a94:	280020ef          	jal	ra,ffffffe000203d14 <rand>
ffffffe000201a98:	00050793          	mv	a5,a0
ffffffe000201a9c:	00078713          	mv	a4,a5
ffffffe000201aa0:	00a00793          	li	a5,10
ffffffe000201aa4:	02f767bb          	remw	a5,a4,a5
ffffffe000201aa8:	0007879b          	sext.w	a5,a5
ffffffe000201aac:	0017879b          	addiw	a5,a5,1
ffffffe000201ab0:	0007879b          	sext.w	a5,a5
ffffffe000201ab4:	00078713          	mv	a4,a5
ffffffe000201ab8:	fd843783          	ld	a5,-40(s0)
ffffffe000201abc:	00e7b823          	sd	a4,16(a5)
    child_task->mm.mmap = NULL;
ffffffe000201ac0:	fd843783          	ld	a5,-40(s0)
ffffffe000201ac4:	0a07b823          	sd	zero,176(a5)

    // copy pgd
    child_task->pgd = (uint64_t *)alloc_page();
ffffffe000201ac8:	e91fe0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe000201acc:	00050713          	mv	a4,a0
ffffffe000201ad0:	fd843783          	ld	a5,-40(s0)
ffffffe000201ad4:	0ae7b423          	sd	a4,168(a5)
    memcpy(child_task->pgd, get_kernel_pgtbl(), PGSIZE);
ffffffe000201ad8:	fd843783          	ld	a5,-40(s0)
ffffffe000201adc:	0a87b483          	ld	s1,168(a5)
ffffffe000201ae0:	659000ef          	jal	ra,ffffffe000202938 <get_kernel_pgtbl>
ffffffe000201ae4:	00050793          	mv	a5,a0
ffffffe000201ae8:	00001637          	lui	a2,0x1
ffffffe000201aec:	00078593          	mv	a1,a5
ffffffe000201af0:	00048513          	mv	a0,s1
ffffffe000201af4:	2ec020ef          	jal	ra,ffffffe000203de0 <memcpy>

    // copy vma
    copy_vma(child_task, get_current_proc());
ffffffe000201af8:	808ff0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe000201afc:	00050793          	mv	a5,a0
ffffffe000201b00:	00078593          	mv	a1,a5
ffffffe000201b04:	fd843503          	ld	a0,-40(s0)
ffffffe000201b08:	0e4000ef          	jal	ra,ffffffe000201bec <copy_vma>

    // copy regs
    child_task->thread.ra = (uint64_t)__ret_from_fork;
ffffffe000201b0c:	ffffe717          	auipc	a4,0xffffe
ffffffe000201b10:	63470713          	addi	a4,a4,1588 # ffffffe000200140 <__ret_from_fork>
ffffffe000201b14:	fd843783          	ld	a5,-40(s0)
ffffffe000201b18:	02e7b023          	sd	a4,32(a5)
    struct pt_regs *child_regs = (struct pt_regs *)((uint64_t)child_task + (uint64_t)regs - (uint64_t)get_current_proc());
ffffffe000201b1c:	fd843703          	ld	a4,-40(s0)
ffffffe000201b20:	fb843783          	ld	a5,-72(s0)
ffffffe000201b24:	00f704b3          	add	s1,a4,a5
ffffffe000201b28:	fd9fe0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe000201b2c:	00050793          	mv	a5,a0
ffffffe000201b30:	40f487b3          	sub	a5,s1,a5
ffffffe000201b34:	fcf43823          	sd	a5,-48(s0)
    child_task->thread.sp = (uint64_t)child_regs;
ffffffe000201b38:	fd043703          	ld	a4,-48(s0)
ffffffe000201b3c:	fd843783          	ld	a5,-40(s0)
ffffffe000201b40:	02e7b423          	sd	a4,40(a5)
    child_task->thread.sepc = regs->sepc;
ffffffe000201b44:	fb843783          	ld	a5,-72(s0)
ffffffe000201b48:	0f07b703          	ld	a4,240(a5)
ffffffe000201b4c:	fd843783          	ld	a5,-40(s0)
ffffffe000201b50:	08e7b823          	sd	a4,144(a5)
    child_task->thread.sscratch = csr_read(sscratch);
ffffffe000201b54:	140027f3          	csrr	a5,sscratch
ffffffe000201b58:	fcf43423          	sd	a5,-56(s0)
ffffffe000201b5c:	fc843703          	ld	a4,-56(s0)
ffffffe000201b60:	fd843783          	ld	a5,-40(s0)
ffffffe000201b64:	0ae7b023          	sd	a4,160(a5)
    child_regs->a[0] = 0;
ffffffe000201b68:	fd043783          	ld	a5,-48(s0)
ffffffe000201b6c:	0407b023          	sd	zero,64(a5)
    child_regs->sp = child_task->thread.sp;
ffffffe000201b70:	fd843783          	ld	a5,-40(s0)
ffffffe000201b74:	0287b703          	ld	a4,40(a5)
ffffffe000201b78:	fd043783          	ld	a5,-48(s0)
ffffffe000201b7c:	10e7b023          	sd	a4,256(a5)
    child_regs->sepc += 4;
ffffffe000201b80:	fd043783          	ld	a5,-48(s0)
ffffffe000201b84:	0f07b783          	ld	a5,240(a5)
ffffffe000201b88:	00478713          	addi	a4,a5,4
ffffffe000201b8c:	fd043783          	ld	a5,-48(s0)
ffffffe000201b90:	0ee7b823          	sd	a4,240(a5)

    // info
    Log("fork: from [%d] to [%d]", get_current_proc()->pid, child_task->pid);
ffffffe000201b94:	f6dfe0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe000201b98:	00050793          	mv	a5,a0
ffffffe000201b9c:	0187b703          	ld	a4,24(a5)
ffffffe000201ba0:	fd843783          	ld	a5,-40(s0)
ffffffe000201ba4:	0187b783          	ld	a5,24(a5)
ffffffe000201ba8:	00002697          	auipc	a3,0x2
ffffffe000201bac:	45868693          	addi	a3,a3,1112 # ffffffe000204000 <__func__.0>
ffffffe000201bb0:	03900613          	li	a2,57
ffffffe000201bb4:	00002597          	auipc	a1,0x2
ffffffe000201bb8:	54458593          	addi	a1,a1,1348 # ffffffe0002040f8 <__func__.0+0xf8>
ffffffe000201bbc:	00002517          	auipc	a0,0x2
ffffffe000201bc0:	57c50513          	addi	a0,a0,1404 # ffffffe000204138 <__func__.0+0x138>
ffffffe000201bc4:	08c020ef          	jal	ra,ffffffe000203c50 <printk>
    // Log("[p] user stack: %p, kernel stack: %p", regs->sp, csr_read(sscratch));
    // Log("[c] user stack: %p, kernel stack: %p", child_regs->sp, csr_read(sscratch));

    return add_task(child_task);
ffffffe000201bc8:	fd843503          	ld	a0,-40(s0)
ffffffe000201bcc:	a11ff0ef          	jal	ra,ffffffe0002015dc <add_task>
ffffffe000201bd0:	00050793          	mv	a5,a0
}
ffffffe000201bd4:	00078513          	mv	a0,a5
ffffffe000201bd8:	04813083          	ld	ra,72(sp)
ffffffe000201bdc:	04013403          	ld	s0,64(sp)
ffffffe000201be0:	03813483          	ld	s1,56(sp)
ffffffe000201be4:	05010113          	addi	sp,sp,80
ffffffe000201be8:	00008067          	ret

ffffffe000201bec <copy_vma>:

void copy_vma(struct task_struct *child, struct task_struct *parent)
{
ffffffe000201bec:	fa010113          	addi	sp,sp,-96
ffffffe000201bf0:	04113c23          	sd	ra,88(sp)
ffffffe000201bf4:	04813823          	sd	s0,80(sp)
ffffffe000201bf8:	06010413          	addi	s0,sp,96
ffffffe000201bfc:	faa43423          	sd	a0,-88(s0)
ffffffe000201c00:	fab43023          	sd	a1,-96(s0)
    struct vm_area_struct *p_vma = parent->mm.mmap;
ffffffe000201c04:	fa043783          	ld	a5,-96(s0)
ffffffe000201c08:	0b07b783          	ld	a5,176(a5)
ffffffe000201c0c:	fef43423          	sd	a5,-24(s0)
    struct vm_area_struct *c_vma = NULL, *new_vma = NULL;
ffffffe000201c10:	fc043c23          	sd	zero,-40(s0)
ffffffe000201c14:	fc043823          	sd	zero,-48(s0)

    while (p_vma)
ffffffe000201c18:	12c0006f          	j	ffffffe000201d44 <copy_vma+0x158>
    {
        do_mmap(&child->mm, p_vma->vm_start, p_vma->vm_end - p_vma->vm_start, p_vma->vm_pgoff, p_vma->vm_filesz, p_vma->vm_flags);
ffffffe000201c1c:	fa843783          	ld	a5,-88(s0)
ffffffe000201c20:	0b078513          	addi	a0,a5,176
ffffffe000201c24:	fe843783          	ld	a5,-24(s0)
ffffffe000201c28:	0087b583          	ld	a1,8(a5)
ffffffe000201c2c:	fe843783          	ld	a5,-24(s0)
ffffffe000201c30:	0107b703          	ld	a4,16(a5)
ffffffe000201c34:	fe843783          	ld	a5,-24(s0)
ffffffe000201c38:	0087b783          	ld	a5,8(a5)
ffffffe000201c3c:	40f70633          	sub	a2,a4,a5
ffffffe000201c40:	fe843783          	ld	a5,-24(s0)
ffffffe000201c44:	0307b683          	ld	a3,48(a5)
ffffffe000201c48:	fe843783          	ld	a5,-24(s0)
ffffffe000201c4c:	0387b703          	ld	a4,56(a5)
ffffffe000201c50:	fe843783          	ld	a5,-24(s0)
ffffffe000201c54:	0287b783          	ld	a5,40(a5)
ffffffe000201c58:	845ff0ef          	jal	ra,ffffffe00020149c <do_mmap>

        uint64_t start_addr = PGROUNDDOWN(p_vma->vm_start);
ffffffe000201c5c:	fe843783          	ld	a5,-24(s0)
ffffffe000201c60:	0087b703          	ld	a4,8(a5)
ffffffe000201c64:	fffff7b7          	lui	a5,0xfffff
ffffffe000201c68:	00f777b3          	and	a5,a4,a5
ffffffe000201c6c:	fcf43423          	sd	a5,-56(s0)
        uint64_t end_addr = PGROUNDUP(p_vma->vm_end);
ffffffe000201c70:	fe843783          	ld	a5,-24(s0)
ffffffe000201c74:	0107b703          	ld	a4,16(a5) # fffffffffffff010 <VM_END+0xfffff010>
ffffffe000201c78:	000017b7          	lui	a5,0x1
ffffffe000201c7c:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201c80:	00f70733          	add	a4,a4,a5
ffffffe000201c84:	fffff7b7          	lui	a5,0xfffff
ffffffe000201c88:	00f777b3          	and	a5,a4,a5
ffffffe000201c8c:	fcf43023          	sd	a5,-64(s0)

        for (uint64_t va = start_addr; va < end_addr; va += PGSIZE)
ffffffe000201c90:	fc843783          	ld	a5,-56(s0)
ffffffe000201c94:	fef43023          	sd	a5,-32(s0)
ffffffe000201c98:	0940006f          	j	ffffffe000201d2c <copy_vma+0x140>
        {
            if (va_mapped(parent->pgd, va))
ffffffe000201c9c:	fa043783          	ld	a5,-96(s0)
ffffffe000201ca0:	0a87b783          	ld	a5,168(a5) # fffffffffffff0a8 <VM_END+0xfffff0a8>
ffffffe000201ca4:	fe043583          	ld	a1,-32(s0)
ffffffe000201ca8:	00078513          	mv	a0,a5
ffffffe000201cac:	5a9000ef          	jal	ra,ffffffe000202a54 <va_mapped>
ffffffe000201cb0:	00050793          	mv	a5,a0
ffffffe000201cb4:	06078463          	beqz	a5,ffffffe000201d1c <copy_vma+0x130>
            {
                uint64_t *pg = (uint64_t *)kalloc();
ffffffe000201cb8:	d15fe0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000201cbc:	faa43c23          	sd	a0,-72(s0)
                memcpy(pg, va, PGSIZE);
ffffffe000201cc0:	fe043783          	ld	a5,-32(s0)
ffffffe000201cc4:	00001637          	lui	a2,0x1
ffffffe000201cc8:	00078593          	mv	a1,a5
ffffffe000201ccc:	fb843503          	ld	a0,-72(s0)
ffffffe000201cd0:	110020ef          	jal	ra,ffffffe000203de0 <memcpy>
                
                uint64_t perm = vmflags2pte(p_vma->vm_flags) | PTE_V | PTE_U;
ffffffe000201cd4:	fe843783          	ld	a5,-24(s0)
ffffffe000201cd8:	0287b783          	ld	a5,40(a5)
ffffffe000201cdc:	00078513          	mv	a0,a5
ffffffe000201ce0:	23d000ef          	jal	ra,ffffffe00020271c <vmflags2pte>
ffffffe000201ce4:	00050793          	mv	a5,a0
ffffffe000201ce8:	0117e793          	ori	a5,a5,17
ffffffe000201cec:	faf43823          	sd	a5,-80(s0)
                create_mapping(child->pgd, va, VA2PA(pg), PGSIZE, perm);
ffffffe000201cf0:	fa843783          	ld	a5,-88(s0)
ffffffe000201cf4:	0a87b503          	ld	a0,168(a5)
ffffffe000201cf8:	fb843703          	ld	a4,-72(s0)
ffffffe000201cfc:	04100793          	li	a5,65
ffffffe000201d00:	01f79793          	slli	a5,a5,0x1f
ffffffe000201d04:	00f707b3          	add	a5,a4,a5
ffffffe000201d08:	fb043703          	ld	a4,-80(s0)
ffffffe000201d0c:	000016b7          	lui	a3,0x1
ffffffe000201d10:	00078613          	mv	a2,a5
ffffffe000201d14:	fe043583          	ld	a1,-32(s0)
ffffffe000201d18:	231000ef          	jal	ra,ffffffe000202748 <create_mapping>
        for (uint64_t va = start_addr; va < end_addr; va += PGSIZE)
ffffffe000201d1c:	fe043703          	ld	a4,-32(s0)
ffffffe000201d20:	000017b7          	lui	a5,0x1
ffffffe000201d24:	00f707b3          	add	a5,a4,a5
ffffffe000201d28:	fef43023          	sd	a5,-32(s0)
ffffffe000201d2c:	fe043703          	ld	a4,-32(s0)
ffffffe000201d30:	fc043783          	ld	a5,-64(s0)
ffffffe000201d34:	f6f764e3          	bltu	a4,a5,ffffffe000201c9c <copy_vma+0xb0>
            }
        }

        p_vma = p_vma->vm_next;
ffffffe000201d38:	fe843783          	ld	a5,-24(s0)
ffffffe000201d3c:	0187b783          	ld	a5,24(a5) # 1018 <PGSIZE+0x18>
ffffffe000201d40:	fef43423          	sd	a5,-24(s0)
    while (p_vma)
ffffffe000201d44:	fe843783          	ld	a5,-24(s0)
ffffffe000201d48:	ec079ae3          	bnez	a5,ffffffe000201c1c <copy_vma+0x30>
    }
}
ffffffe000201d4c:	00000013          	nop
ffffffe000201d50:	00000013          	nop
ffffffe000201d54:	05813083          	ld	ra,88(sp)
ffffffe000201d58:	05013403          	ld	s0,80(sp)
ffffffe000201d5c:	06010113          	addi	sp,sp,96
ffffffe000201d60:	00008067          	ret

ffffffe000201d64 <trap_handler>:
extern void do_timer();
extern void dummy();
extern char _sramdisk[];

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs)
{
ffffffe000201d64:	f7010113          	addi	sp,sp,-144
ffffffe000201d68:	08113423          	sd	ra,136(sp)
ffffffe000201d6c:	08813023          	sd	s0,128(sp)
ffffffe000201d70:	09010413          	addi	s0,sp,144
ffffffe000201d74:	f8a43423          	sd	a0,-120(s0)
ffffffe000201d78:	f8b43023          	sd	a1,-128(s0)
ffffffe000201d7c:	f6c43c23          	sd	a2,-136(s0)
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    // Err("trap_handler: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    if (scause & 0x8000000000000000)
ffffffe000201d80:	f8843783          	ld	a5,-120(s0)
ffffffe000201d84:	0407d063          	bgez	a5,ffffffe000201dc4 <trap_handler+0x60>
    {
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe000201d88:	f8843783          	ld	a5,-120(s0)
ffffffe000201d8c:	0ff7f793          	zext.b	a5,a5
ffffffe000201d90:	f8f43c23          	sd	a5,-104(s0)
        if (interrupt_t == 0x5)
ffffffe000201d94:	f9843703          	ld	a4,-104(s0)
ffffffe000201d98:	00500793          	li	a5,5
ffffffe000201d9c:	00f71863          	bne	a4,a5,ffffffe000201dac <trap_handler+0x48>
        {
            // timer interrupt
            // printk("timer interrupt, time = %ld\n", get_cycles());
            clock_set_next_event();
ffffffe000201da0:	d54fe0ef          	jal	ra,ffffffe0002002f4 <clock_set_next_event>
            do_timer();
ffffffe000201da4:	c30ff0ef          	jal	ra,ffffffe0002011d4 <do_timer>
ffffffe000201da8:	1fc0006f          	j	ffffffe000201fa4 <trap_handler+0x240>
        }
        else
        {
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000201dac:	f8043603          	ld	a2,-128(s0)
ffffffe000201db0:	f8843583          	ld	a1,-120(s0)
ffffffe000201db4:	00002517          	auipc	a0,0x2
ffffffe000201db8:	3b450513          	addi	a0,a0,948 # ffffffe000204168 <__func__.0+0x168>
ffffffe000201dbc:	695010ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe000201dc0:	1e40006f          	j	ffffffe000201fa4 <trap_handler+0x240>
        }
    }
    else
    {
        // exception
        if (scause == ECALL_FROM_U_MODE)
ffffffe000201dc4:	f8843703          	ld	a4,-120(s0)
ffffffe000201dc8:	00800793          	li	a5,8
ffffffe000201dcc:	0ef71663          	bne	a4,a5,ffffffe000201eb8 <trap_handler+0x154>
        {
            uint64_t syscall_id = regs->a[7];
ffffffe000201dd0:	f7843783          	ld	a5,-136(s0)
ffffffe000201dd4:	0787b783          	ld	a5,120(a5)
ffffffe000201dd8:	fcf43823          	sd	a5,-48(s0)
            // printk("[trap_handler] ecall from user mode, syscall_id = %ld\n", syscall_id);
            if (syscall_id == SYS_WRITE)
ffffffe000201ddc:	fd043703          	ld	a4,-48(s0)
ffffffe000201de0:	04000793          	li	a5,64
ffffffe000201de4:	04f71e63          	bne	a4,a5,ffffffe000201e40 <trap_handler+0xdc>
            {
                unsigned int fd = (unsigned int)regs->a[0];
ffffffe000201de8:	f7843783          	ld	a5,-136(s0)
ffffffe000201dec:	0407b783          	ld	a5,64(a5)
ffffffe000201df0:	faf42e23          	sw	a5,-68(s0)
                const char *buf = (const char *)regs->a[1];
ffffffe000201df4:	f7843783          	ld	a5,-136(s0)
ffffffe000201df8:	0487b783          	ld	a5,72(a5)
ffffffe000201dfc:	faf43823          	sd	a5,-80(s0)
                size_t count = (size_t)regs->a[2];
ffffffe000201e00:	f7843783          	ld	a5,-136(s0)
ffffffe000201e04:	0507b783          	ld	a5,80(a5)
ffffffe000201e08:	faf43423          	sd	a5,-88(s0)
                uint64_t ret = sys_write(fd, buf, count);
ffffffe000201e0c:	fa843783          	ld	a5,-88(s0)
ffffffe000201e10:	0007871b          	sext.w	a4,a5
ffffffe000201e14:	fbc42783          	lw	a5,-68(s0)
ffffffe000201e18:	00070613          	mv	a2,a4
ffffffe000201e1c:	fb043583          	ld	a1,-80(s0)
ffffffe000201e20:	00078513          	mv	a0,a5
ffffffe000201e24:	aedff0ef          	jal	ra,ffffffe000201910 <sys_write>
ffffffe000201e28:	00050793          	mv	a5,a0
ffffffe000201e2c:	faf43023          	sd	a5,-96(s0)
                regs->a[0] = ret;
ffffffe000201e30:	f7843783          	ld	a5,-136(s0)
ffffffe000201e34:	fa043703          	ld	a4,-96(s0)
ffffffe000201e38:	04e7b023          	sd	a4,64(a5)
ffffffe000201e3c:	0640006f          	j	ffffffe000201ea0 <trap_handler+0x13c>
            }
            else if (syscall_id == SYS_GETPID)
ffffffe000201e40:	fd043703          	ld	a4,-48(s0)
ffffffe000201e44:	0ac00793          	li	a5,172
ffffffe000201e48:	02f71063          	bne	a4,a5,ffffffe000201e68 <trap_handler+0x104>
            {
                uint64_t pid = sys_getpid();
ffffffe000201e4c:	b75ff0ef          	jal	ra,ffffffe0002019c0 <sys_getpid>
ffffffe000201e50:	00050793          	mv	a5,a0
ffffffe000201e54:	fcf43023          	sd	a5,-64(s0)
                regs->a[0] = pid;
ffffffe000201e58:	f7843783          	ld	a5,-136(s0)
ffffffe000201e5c:	fc043703          	ld	a4,-64(s0)
ffffffe000201e60:	04e7b023          	sd	a4,64(a5)
ffffffe000201e64:	03c0006f          	j	ffffffe000201ea0 <trap_handler+0x13c>
            } 
            else if (syscall_id == SYS_CLONE)
ffffffe000201e68:	fd043703          	ld	a4,-48(s0)
ffffffe000201e6c:	0dc00793          	li	a5,220
ffffffe000201e70:	02f71063          	bne	a4,a5,ffffffe000201e90 <trap_handler+0x12c>
            {
                uint64_t ret = do_fork(regs);
ffffffe000201e74:	f7843503          	ld	a0,-136(s0)
ffffffe000201e78:	b81ff0ef          	jal	ra,ffffffe0002019f8 <do_fork>
ffffffe000201e7c:	fca43423          	sd	a0,-56(s0)
                regs->a[0] = ret;
ffffffe000201e80:	f7843783          	ld	a5,-136(s0)
ffffffe000201e84:	fc843703          	ld	a4,-56(s0)
ffffffe000201e88:	04e7b023          	sd	a4,64(a5)
ffffffe000201e8c:	0140006f          	j	ffffffe000201ea0 <trap_handler+0x13c>
            }
            else
            {
                printk("unimplemented syscall_id: %ld\n", syscall_id);
ffffffe000201e90:	fd043583          	ld	a1,-48(s0)
ffffffe000201e94:	00002517          	auipc	a0,0x2
ffffffe000201e98:	30450513          	addi	a0,a0,772 # ffffffe000204198 <__func__.0+0x198>
ffffffe000201e9c:	5b5010ef          	jal	ra,ffffffe000203c50 <printk>
            }
            regs->sepc += 4;
ffffffe000201ea0:	f7843783          	ld	a5,-136(s0)
ffffffe000201ea4:	0f07b783          	ld	a5,240(a5)
ffffffe000201ea8:	00478713          	addi	a4,a5,4
ffffffe000201eac:	f7843783          	ld	a5,-136(s0)
ffffffe000201eb0:	0ee7b823          	sd	a4,240(a5)
            return;
ffffffe000201eb4:	0f00006f          	j	ffffffe000201fa4 <trap_handler+0x240>
        }
        else if (scause == INST_PAGE_FAULT)
ffffffe000201eb8:	f8843703          	ld	a4,-120(s0)
ffffffe000201ebc:	00c00793          	li	a5,12
ffffffe000201ec0:	04f71063          	bne	a4,a5,ffffffe000201f00 <trap_handler+0x19c>
        {
            Warning("pc @ %lx, instruction page fault, stval = %lx", sepc, csr_read(stval));
ffffffe000201ec4:	143027f3          	csrr	a5,stval
ffffffe000201ec8:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201ecc:	fd843783          	ld	a5,-40(s0)
ffffffe000201ed0:	f8043703          	ld	a4,-128(s0)
ffffffe000201ed4:	00002697          	auipc	a3,0x2
ffffffe000201ed8:	56468693          	addi	a3,a3,1380 # ffffffe000204438 <__func__.1>
ffffffe000201edc:	04b00613          	li	a2,75
ffffffe000201ee0:	00002597          	auipc	a1,0x2
ffffffe000201ee4:	2d858593          	addi	a1,a1,728 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe000201ee8:	00002517          	auipc	a0,0x2
ffffffe000201eec:	2d850513          	addi	a0,a0,728 # ffffffe0002041c0 <__func__.0+0x1c0>
ffffffe000201ef0:	561010ef          	jal	ra,ffffffe000203c50 <printk>
            do_page_fault(regs);
ffffffe000201ef4:	f7843503          	ld	a0,-136(s0)
ffffffe000201ef8:	0bc000ef          	jal	ra,ffffffe000201fb4 <do_page_fault>
ffffffe000201efc:	0a80006f          	j	ffffffe000201fa4 <trap_handler+0x240>
        }
        else if (scause == LOAD_PAGE_FAULT)
ffffffe000201f00:	f8843703          	ld	a4,-120(s0)
ffffffe000201f04:	00d00793          	li	a5,13
ffffffe000201f08:	04f71063          	bne	a4,a5,ffffffe000201f48 <trap_handler+0x1e4>
        {
            Warning("pc @ %lx, load page fault, stval = %lx", sepc, csr_read(stval));
ffffffe000201f0c:	143027f3          	csrr	a5,stval
ffffffe000201f10:	fef43023          	sd	a5,-32(s0)
ffffffe000201f14:	fe043783          	ld	a5,-32(s0)
ffffffe000201f18:	f8043703          	ld	a4,-128(s0)
ffffffe000201f1c:	00002697          	auipc	a3,0x2
ffffffe000201f20:	51c68693          	addi	a3,a3,1308 # ffffffe000204438 <__func__.1>
ffffffe000201f24:	05000613          	li	a2,80
ffffffe000201f28:	00002597          	auipc	a1,0x2
ffffffe000201f2c:	29058593          	addi	a1,a1,656 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe000201f30:	00002517          	auipc	a0,0x2
ffffffe000201f34:	2d850513          	addi	a0,a0,728 # ffffffe000204208 <__func__.0+0x208>
ffffffe000201f38:	519010ef          	jal	ra,ffffffe000203c50 <printk>
            do_page_fault(regs);
ffffffe000201f3c:	f7843503          	ld	a0,-136(s0)
ffffffe000201f40:	074000ef          	jal	ra,ffffffe000201fb4 <do_page_fault>
ffffffe000201f44:	0600006f          	j	ffffffe000201fa4 <trap_handler+0x240>
        }
        else if (scause == STORE_PAGE_FAULT)
ffffffe000201f48:	f8843703          	ld	a4,-120(s0)
ffffffe000201f4c:	00f00793          	li	a5,15
ffffffe000201f50:	04f71063          	bne	a4,a5,ffffffe000201f90 <trap_handler+0x22c>
        {
            Warning("pc @ %lx, store page fault, stval = %lx", sepc, csr_read(stval));
ffffffe000201f54:	143027f3          	csrr	a5,stval
ffffffe000201f58:	fef43423          	sd	a5,-24(s0)
ffffffe000201f5c:	fe843783          	ld	a5,-24(s0)
ffffffe000201f60:	f8043703          	ld	a4,-128(s0)
ffffffe000201f64:	00002697          	auipc	a3,0x2
ffffffe000201f68:	4d468693          	addi	a3,a3,1236 # ffffffe000204438 <__func__.1>
ffffffe000201f6c:	05500613          	li	a2,85
ffffffe000201f70:	00002597          	auipc	a1,0x2
ffffffe000201f74:	24858593          	addi	a1,a1,584 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe000201f78:	00002517          	auipc	a0,0x2
ffffffe000201f7c:	2d050513          	addi	a0,a0,720 # ffffffe000204248 <__func__.0+0x248>
ffffffe000201f80:	4d1010ef          	jal	ra,ffffffe000203c50 <printk>
            do_page_fault(regs);
ffffffe000201f84:	f7843503          	ld	a0,-136(s0)
ffffffe000201f88:	02c000ef          	jal	ra,ffffffe000201fb4 <do_page_fault>
ffffffe000201f8c:	0180006f          	j	ffffffe000201fa4 <trap_handler+0x240>
        }
        else
        {
            printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000201f90:	f8043603          	ld	a2,-128(s0)
ffffffe000201f94:	f8843583          	ld	a1,-120(s0)
ffffffe000201f98:	00002517          	auipc	a0,0x2
ffffffe000201f9c:	2f050513          	addi	a0,a0,752 # ffffffe000204288 <__func__.0+0x288>
ffffffe000201fa0:	4b1010ef          	jal	ra,ffffffe000203c50 <printk>
        }
    }
}
ffffffe000201fa4:	08813083          	ld	ra,136(sp)
ffffffe000201fa8:	08013403          	ld	s0,128(sp)
ffffffe000201fac:	09010113          	addi	sp,sp,144
ffffffe000201fb0:	00008067          	ret

ffffffe000201fb4 <do_page_fault>:

void do_page_fault(struct pt_regs *regs)
{
ffffffe000201fb4:	f4010113          	addi	sp,sp,-192
ffffffe000201fb8:	0a113c23          	sd	ra,184(sp)
ffffffe000201fbc:	0a813823          	sd	s0,176(sp)
ffffffe000201fc0:	0c010413          	addi	s0,sp,192
ffffffe000201fc4:	f4a43423          	sd	a0,-184(s0)
    uint64_t bad_addr = csr_read(stval);
ffffffe000201fc8:	143027f3          	csrr	a5,stval
ffffffe000201fcc:	fef43023          	sd	a5,-32(s0)
ffffffe000201fd0:	fe043783          	ld	a5,-32(s0)
ffffffe000201fd4:	fcf43c23          	sd	a5,-40(s0)
    struct vm_area_struct *vma = find_vma(&(get_current_proc()->mm), bad_addr);
ffffffe000201fd8:	b29fe0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe000201fdc:	00050793          	mv	a5,a0
ffffffe000201fe0:	0b078793          	addi	a5,a5,176
ffffffe000201fe4:	fd843583          	ld	a1,-40(s0)
ffffffe000201fe8:	00078513          	mv	a0,a5
ffffffe000201fec:	c3cff0ef          	jal	ra,ffffffe000201428 <find_vma>
ffffffe000201ff0:	fca43823          	sd	a0,-48(s0)
    if (!vma)
ffffffe000201ff4:	fd043783          	ld	a5,-48(s0)
ffffffe000201ff8:	02079663          	bnez	a5,ffffffe000202024 <do_page_fault+0x70>
    {
        Err("do_page_fault: cannot find vma, bad_addr = %lx", bad_addr);
ffffffe000201ffc:	fd843703          	ld	a4,-40(s0)
ffffffe000202000:	00002697          	auipc	a3,0x2
ffffffe000202004:	44868693          	addi	a3,a3,1096 # ffffffe000204448 <__func__.0>
ffffffe000202008:	06500613          	li	a2,101
ffffffe00020200c:	00002597          	auipc	a1,0x2
ffffffe000202010:	1ac58593          	addi	a1,a1,428 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe000202014:	00002517          	auipc	a0,0x2
ffffffe000202018:	2a450513          	addi	a0,a0,676 # ffffffe0002042b8 <__func__.0+0x2b8>
ffffffe00020201c:	435010ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe000202020:	0000006f          	j	ffffffe000202020 <do_page_fault+0x6c>
    }

    uint64_t scause = csr_read(scause);
ffffffe000202024:	142027f3          	csrr	a5,scause
ffffffe000202028:	fcf43423          	sd	a5,-56(s0)
ffffffe00020202c:	fc843783          	ld	a5,-56(s0)
ffffffe000202030:	fcf43023          	sd	a5,-64(s0)
    switch (scause)
ffffffe000202034:	fc043703          	ld	a4,-64(s0)
ffffffe000202038:	00f00793          	li	a5,15
ffffffe00020203c:	08f70e63          	beq	a4,a5,ffffffe0002020d8 <do_page_fault+0x124>
ffffffe000202040:	fc043703          	ld	a4,-64(s0)
ffffffe000202044:	00f00793          	li	a5,15
ffffffe000202048:	0ce7e463          	bltu	a5,a4,ffffffe000202110 <do_page_fault+0x15c>
ffffffe00020204c:	fc043703          	ld	a4,-64(s0)
ffffffe000202050:	00c00793          	li	a5,12
ffffffe000202054:	00f70a63          	beq	a4,a5,ffffffe000202068 <do_page_fault+0xb4>
ffffffe000202058:	fc043703          	ld	a4,-64(s0)
ffffffe00020205c:	00d00793          	li	a5,13
ffffffe000202060:	04f70063          	beq	a4,a5,ffffffe0002020a0 <do_page_fault+0xec>
ffffffe000202064:	0ac0006f          	j	ffffffe000202110 <do_page_fault+0x15c>
    {
    case INST_PAGE_FAULT:
        if (!(vma->vm_flags & VM_EXEC))
ffffffe000202068:	fd043783          	ld	a5,-48(s0)
ffffffe00020206c:	0287b783          	ld	a5,40(a5)
ffffffe000202070:	0087f793          	andi	a5,a5,8
ffffffe000202074:	0c079463          	bnez	a5,ffffffe00020213c <do_page_fault+0x188>
        {
            Err("do_page_fault: instruction page fault, bad_addr = %lx", bad_addr);
ffffffe000202078:	fd843703          	ld	a4,-40(s0)
ffffffe00020207c:	00002697          	auipc	a3,0x2
ffffffe000202080:	3cc68693          	addi	a3,a3,972 # ffffffe000204448 <__func__.0>
ffffffe000202084:	06e00613          	li	a2,110
ffffffe000202088:	00002597          	auipc	a1,0x2
ffffffe00020208c:	13058593          	addi	a1,a1,304 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe000202090:	00002517          	auipc	a0,0x2
ffffffe000202094:	27050513          	addi	a0,a0,624 # ffffffe000204300 <__func__.0+0x300>
ffffffe000202098:	3b9010ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe00020209c:	0000006f          	j	ffffffe00020209c <do_page_fault+0xe8>
        }
        break;

    case LOAD_PAGE_FAULT:
        if (!(vma->vm_flags & VM_READ))
ffffffe0002020a0:	fd043783          	ld	a5,-48(s0)
ffffffe0002020a4:	0287b783          	ld	a5,40(a5)
ffffffe0002020a8:	0027f793          	andi	a5,a5,2
ffffffe0002020ac:	08079c63          	bnez	a5,ffffffe000202144 <do_page_fault+0x190>
        {
            Err("do_page_fault: load page fault, bad_addr = %lx", bad_addr);
ffffffe0002020b0:	fd843703          	ld	a4,-40(s0)
ffffffe0002020b4:	00002697          	auipc	a3,0x2
ffffffe0002020b8:	39468693          	addi	a3,a3,916 # ffffffe000204448 <__func__.0>
ffffffe0002020bc:	07500613          	li	a2,117
ffffffe0002020c0:	00002597          	auipc	a1,0x2
ffffffe0002020c4:	0f858593          	addi	a1,a1,248 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe0002020c8:	00002517          	auipc	a0,0x2
ffffffe0002020cc:	28850513          	addi	a0,a0,648 # ffffffe000204350 <__func__.0+0x350>
ffffffe0002020d0:	381010ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe0002020d4:	0000006f          	j	ffffffe0002020d4 <do_page_fault+0x120>
        }
        break;

    case STORE_PAGE_FAULT:
        if (!(vma->vm_flags & VM_WRITE))
ffffffe0002020d8:	fd043783          	ld	a5,-48(s0)
ffffffe0002020dc:	0287b783          	ld	a5,40(a5)
ffffffe0002020e0:	0047f793          	andi	a5,a5,4
ffffffe0002020e4:	06079463          	bnez	a5,ffffffe00020214c <do_page_fault+0x198>
        {
            Err("do_page_fault: store page fault, bad_addr = %lx", bad_addr);
ffffffe0002020e8:	fd843703          	ld	a4,-40(s0)
ffffffe0002020ec:	00002697          	auipc	a3,0x2
ffffffe0002020f0:	35c68693          	addi	a3,a3,860 # ffffffe000204448 <__func__.0>
ffffffe0002020f4:	07c00613          	li	a2,124
ffffffe0002020f8:	00002597          	auipc	a1,0x2
ffffffe0002020fc:	0c058593          	addi	a1,a1,192 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe000202100:	00002517          	auipc	a0,0x2
ffffffe000202104:	29850513          	addi	a0,a0,664 # ffffffe000204398 <__func__.0+0x398>
ffffffe000202108:	349010ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe00020210c:	0000006f          	j	ffffffe00020210c <do_page_fault+0x158>
        }
        break;

    default:
        Err("do_page_fault: unknown page fault, scause = %d, bad_addr = %lx", scause, bad_addr);
ffffffe000202110:	fd843783          	ld	a5,-40(s0)
ffffffe000202114:	fc043703          	ld	a4,-64(s0)
ffffffe000202118:	00002697          	auipc	a3,0x2
ffffffe00020211c:	33068693          	addi	a3,a3,816 # ffffffe000204448 <__func__.0>
ffffffe000202120:	08100613          	li	a2,129
ffffffe000202124:	00002597          	auipc	a1,0x2
ffffffe000202128:	09458593          	addi	a1,a1,148 # ffffffe0002041b8 <__func__.0+0x1b8>
ffffffe00020212c:	00002517          	auipc	a0,0x2
ffffffe000202130:	2b450513          	addi	a0,a0,692 # ffffffe0002043e0 <__func__.0+0x3e0>
ffffffe000202134:	31d010ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe000202138:	0000006f          	j	ffffffe000202138 <do_page_fault+0x184>
        break;
ffffffe00020213c:	00000013          	nop
ffffffe000202140:	0100006f          	j	ffffffe000202150 <do_page_fault+0x19c>
        break;
ffffffe000202144:	00000013          	nop
ffffffe000202148:	0080006f          	j	ffffffe000202150 <do_page_fault+0x19c>
        break;
ffffffe00020214c:	00000013          	nop
        break;
    }

    if (vma->vm_flags & VM_ANON)
ffffffe000202150:	fd043783          	ld	a5,-48(s0)
ffffffe000202154:	0287b783          	ld	a5,40(a5)
ffffffe000202158:	0017f793          	andi	a5,a5,1
ffffffe00020215c:	08078463          	beqz	a5,ffffffe0002021e4 <do_page_fault+0x230>
    {
        uint64_t *pg = (uint64_t *)alloc_page();
ffffffe000202160:	ff8fe0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe000202164:	f6a43823          	sd	a0,-144(s0)
        uint64_t pa_s = VA2PA(pg);
ffffffe000202168:	f7043703          	ld	a4,-144(s0)
ffffffe00020216c:	04100793          	li	a5,65
ffffffe000202170:	01f79793          	slli	a5,a5,0x1f
ffffffe000202174:	00f707b3          	add	a5,a4,a5
ffffffe000202178:	f6f43423          	sd	a5,-152(s0)
        memset((void *)pg, 0, PGSIZE);
ffffffe00020217c:	00001637          	lui	a2,0x1
ffffffe000202180:	00000593          	li	a1,0
ffffffe000202184:	f7043503          	ld	a0,-144(s0)
ffffffe000202188:	3e9010ef          	jal	ra,ffffffe000203d70 <memset>
        uint64_t va_s = PGROUNDDOWN(bad_addr);
ffffffe00020218c:	fd843703          	ld	a4,-40(s0)
ffffffe000202190:	fffff7b7          	lui	a5,0xfffff
ffffffe000202194:	00f777b3          	and	a5,a4,a5
ffffffe000202198:	f6f43023          	sd	a5,-160(s0)
        uint64_t *pgtbl = get_current_proc()->pgd;
ffffffe00020219c:	965fe0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe0002021a0:	00050793          	mv	a5,a0
ffffffe0002021a4:	0a87b783          	ld	a5,168(a5) # fffffffffffff0a8 <VM_END+0xfffff0a8>
ffffffe0002021a8:	f4f43c23          	sd	a5,-168(s0)
        uint64_t perm = vmflags2pte(vma->vm_flags) | PTE_V | PTE_U;
ffffffe0002021ac:	fd043783          	ld	a5,-48(s0)
ffffffe0002021b0:	0287b783          	ld	a5,40(a5)
ffffffe0002021b4:	00078513          	mv	a0,a5
ffffffe0002021b8:	564000ef          	jal	ra,ffffffe00020271c <vmflags2pte>
ffffffe0002021bc:	00050793          	mv	a5,a0
ffffffe0002021c0:	0117e793          	ori	a5,a5,17
ffffffe0002021c4:	f4f43823          	sd	a5,-176(s0)
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
ffffffe0002021c8:	f5043703          	ld	a4,-176(s0)
ffffffe0002021cc:	000016b7          	lui	a3,0x1
ffffffe0002021d0:	f6843603          	ld	a2,-152(s0)
ffffffe0002021d4:	f6043583          	ld	a1,-160(s0)
ffffffe0002021d8:	f5843503          	ld	a0,-168(s0)
ffffffe0002021dc:	56c000ef          	jal	ra,ffffffe000202748 <create_mapping>
        }
        uint64_t va_s = PGROUNDDOWN(bad_addr); // 映射的起点 与物理页做映射
        uint64_t pa_s = VA2PA(pg);
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
    }
ffffffe0002021e0:	1280006f          	j	ffffffe000202308 <do_page_fault+0x354>
        uint64_t perm = vmflags2pte(vma->vm_flags) | PTE_V | PTE_U;
ffffffe0002021e4:	fd043783          	ld	a5,-48(s0)
ffffffe0002021e8:	0287b783          	ld	a5,40(a5)
ffffffe0002021ec:	00078513          	mv	a0,a5
ffffffe0002021f0:	52c000ef          	jal	ra,ffffffe00020271c <vmflags2pte>
ffffffe0002021f4:	00050793          	mv	a5,a0
ffffffe0002021f8:	0117e793          	ori	a5,a5,17
ffffffe0002021fc:	faf43c23          	sd	a5,-72(s0)
        uint64_t *pgtbl = get_current_proc()->pgd;
ffffffe000202200:	901fe0ef          	jal	ra,ffffffe000200b00 <get_current_proc>
ffffffe000202204:	00050793          	mv	a5,a0
ffffffe000202208:	0a87b783          	ld	a5,168(a5)
ffffffe00020220c:	faf43823          	sd	a5,-80(s0)
        uint64_t file_start = (uint64_t)_sramdisk + vma->vm_pgoff;
ffffffe000202210:	fd043783          	ld	a5,-48(s0)
ffffffe000202214:	0307b703          	ld	a4,48(a5)
ffffffe000202218:	00004797          	auipc	a5,0x4
ffffffe00020221c:	de878793          	addi	a5,a5,-536 # ffffffe000206000 <_sramdisk>
ffffffe000202220:	00f707b3          	add	a5,a4,a5
ffffffe000202224:	faf43423          	sd	a5,-88(s0)
        uint64_t file_end = file_start + vma->vm_filesz;
ffffffe000202228:	fd043783          	ld	a5,-48(s0)
ffffffe00020222c:	0387b783          	ld	a5,56(a5)
ffffffe000202230:	fa843703          	ld	a4,-88(s0)
ffffffe000202234:	00f707b3          	add	a5,a4,a5
ffffffe000202238:	faf43023          	sd	a5,-96(s0)
        uint64_t offset = bad_addr - vma->vm_start;
ffffffe00020223c:	fd043783          	ld	a5,-48(s0)
ffffffe000202240:	0087b783          	ld	a5,8(a5)
ffffffe000202244:	fd843703          	ld	a4,-40(s0)
ffffffe000202248:	40f707b3          	sub	a5,a4,a5
ffffffe00020224c:	f8f43c23          	sd	a5,-104(s0)
        uint64_t file_page_start = PGROUNDDOWN(file_start + offset); // 文件一页的起点 拷贝到分配的物理页
ffffffe000202250:	fa843703          	ld	a4,-88(s0)
ffffffe000202254:	f9843783          	ld	a5,-104(s0)
ffffffe000202258:	00f70733          	add	a4,a4,a5
ffffffe00020225c:	fffff7b7          	lui	a5,0xfffff
ffffffe000202260:	00f777b3          	and	a5,a4,a5
ffffffe000202264:	f8f43823          	sd	a5,-112(s0)
        uint64_t *pg = (uint64_t *)alloc_page();
ffffffe000202268:	ef0fe0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe00020226c:	f8a43423          	sd	a0,-120(s0)
        memset((void *)pg, 0, PGSIZE);
ffffffe000202270:	00001637          	lui	a2,0x1
ffffffe000202274:	00000593          	li	a1,0
ffffffe000202278:	f8843503          	ld	a0,-120(s0)
ffffffe00020227c:	2f5010ef          	jal	ra,ffffffe000203d70 <memset>
        if (file_page_start < file_end)
ffffffe000202280:	f9043703          	ld	a4,-112(s0)
ffffffe000202284:	fa043783          	ld	a5,-96(s0)
ffffffe000202288:	04f77263          	bgeu	a4,a5,ffffffe0002022cc <do_page_fault+0x318>
            uint64_t sz = PGSIZE;
ffffffe00020228c:	000017b7          	lui	a5,0x1
ffffffe000202290:	fef43423          	sd	a5,-24(s0)
            if (file_page_start + sz > file_end)
ffffffe000202294:	f9043703          	ld	a4,-112(s0)
ffffffe000202298:	fe843783          	ld	a5,-24(s0)
ffffffe00020229c:	00f707b3          	add	a5,a4,a5
ffffffe0002022a0:	fa043703          	ld	a4,-96(s0)
ffffffe0002022a4:	00f77a63          	bgeu	a4,a5,ffffffe0002022b8 <do_page_fault+0x304>
                sz = file_end - file_page_start;
ffffffe0002022a8:	fa043703          	ld	a4,-96(s0)
ffffffe0002022ac:	f9043783          	ld	a5,-112(s0)
ffffffe0002022b0:	40f707b3          	sub	a5,a4,a5
ffffffe0002022b4:	fef43423          	sd	a5,-24(s0)
            memcpy((void *)pg, (void *)file_page_start, sz);
ffffffe0002022b8:	f9043783          	ld	a5,-112(s0)
ffffffe0002022bc:	fe843603          	ld	a2,-24(s0)
ffffffe0002022c0:	00078593          	mv	a1,a5
ffffffe0002022c4:	f8843503          	ld	a0,-120(s0)
ffffffe0002022c8:	319010ef          	jal	ra,ffffffe000203de0 <memcpy>
        uint64_t va_s = PGROUNDDOWN(bad_addr); // 映射的起点 与物理页做映射
ffffffe0002022cc:	fd843703          	ld	a4,-40(s0)
ffffffe0002022d0:	fffff7b7          	lui	a5,0xfffff
ffffffe0002022d4:	00f777b3          	and	a5,a4,a5
ffffffe0002022d8:	f8f43023          	sd	a5,-128(s0)
        uint64_t pa_s = VA2PA(pg);
ffffffe0002022dc:	f8843703          	ld	a4,-120(s0)
ffffffe0002022e0:	04100793          	li	a5,65
ffffffe0002022e4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002022e8:	00f707b3          	add	a5,a4,a5
ffffffe0002022ec:	f6f43c23          	sd	a5,-136(s0)
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
ffffffe0002022f0:	fb843703          	ld	a4,-72(s0)
ffffffe0002022f4:	000016b7          	lui	a3,0x1
ffffffe0002022f8:	f7843603          	ld	a2,-136(s0)
ffffffe0002022fc:	f8043583          	ld	a1,-128(s0)
ffffffe000202300:	fb043503          	ld	a0,-80(s0)
ffffffe000202304:	444000ef          	jal	ra,ffffffe000202748 <create_mapping>
ffffffe000202308:	00000013          	nop
ffffffe00020230c:	0b813083          	ld	ra,184(sp)
ffffffe000202310:	0b013403          	ld	s0,176(sp)
ffffffe000202314:	0c010113          	addi	sp,sp,192
ffffffe000202318:	00008067          	ret

ffffffe00020231c <setup_vm>:
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe00020231c:	fe010113          	addi	sp,sp,-32
ffffffe000202320:	00113c23          	sd	ra,24(sp)
ffffffe000202324:	00813823          	sd	s0,16(sp)
ffffffe000202328:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe00020232c:	00001637          	lui	a2,0x1
ffffffe000202330:	00000593          	li	a1,0
ffffffe000202334:	00008517          	auipc	a0,0x8
ffffffe000202338:	ccc50513          	addi	a0,a0,-820 # ffffffe00020a000 <early_pgtbl>
ffffffe00020233c:	235010ef          	jal	ra,ffffffe000203d70 <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000202340:	00f00793          	li	a5,15
ffffffe000202344:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000202348:	fe043423          	sd	zero,-24(s0)
ffffffe00020234c:	0740006f          	j	ffffffe0002023c0 <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000202350:	fe843703          	ld	a4,-24(s0)
ffffffe000202354:	fff00793          	li	a5,-1
ffffffe000202358:	02579793          	slli	a5,a5,0x25
ffffffe00020235c:	00f706b3          	add	a3,a4,a5
ffffffe000202360:	fe843703          	ld	a4,-24(s0)
ffffffe000202364:	00100793          	li	a5,1
ffffffe000202368:	01f79793          	slli	a5,a5,0x1f
ffffffe00020236c:	00f707b3          	add	a5,a4,a5
ffffffe000202370:	fe043603          	ld	a2,-32(s0)
ffffffe000202374:	00078593          	mv	a1,a5
ffffffe000202378:	00068513          	mv	a0,a3
ffffffe00020237c:	074000ef          	jal	ra,ffffffe0002023f0 <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe000202380:	fe843703          	ld	a4,-24(s0)
ffffffe000202384:	00100793          	li	a5,1
ffffffe000202388:	01f79793          	slli	a5,a5,0x1f
ffffffe00020238c:	00f706b3          	add	a3,a4,a5
ffffffe000202390:	fe843703          	ld	a4,-24(s0)
ffffffe000202394:	00100793          	li	a5,1
ffffffe000202398:	01f79793          	slli	a5,a5,0x1f
ffffffe00020239c:	00f707b3          	add	a5,a4,a5
ffffffe0002023a0:	fe043603          	ld	a2,-32(s0)
ffffffe0002023a4:	00078593          	mv	a1,a5
ffffffe0002023a8:	00068513          	mv	a0,a3
ffffffe0002023ac:	044000ef          	jal	ra,ffffffe0002023f0 <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe0002023b0:	fe843703          	ld	a4,-24(s0)
ffffffe0002023b4:	400007b7          	lui	a5,0x40000
ffffffe0002023b8:	00f707b3          	add	a5,a4,a5
ffffffe0002023bc:	fef43423          	sd	a5,-24(s0)
ffffffe0002023c0:	fe843703          	ld	a4,-24(s0)
ffffffe0002023c4:	01f00793          	li	a5,31
ffffffe0002023c8:	02079793          	slli	a5,a5,0x20
ffffffe0002023cc:	f8f762e3          	bltu	a4,a5,ffffffe000202350 <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe0002023d0:	00002517          	auipc	a0,0x2
ffffffe0002023d4:	08850513          	addi	a0,a0,136 # ffffffe000204458 <__func__.0+0x10>
ffffffe0002023d8:	079010ef          	jal	ra,ffffffe000203c50 <printk>
    return;
ffffffe0002023dc:	00000013          	nop
}
ffffffe0002023e0:	01813083          	ld	ra,24(sp)
ffffffe0002023e4:	01013403          	ld	s0,16(sp)
ffffffe0002023e8:	02010113          	addi	sp,sp,32
ffffffe0002023ec:	00008067          	ret

ffffffe0002023f0 <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe0002023f0:	fc010113          	addi	sp,sp,-64
ffffffe0002023f4:	02813c23          	sd	s0,56(sp)
ffffffe0002023f8:	04010413          	addi	s0,sp,64
ffffffe0002023fc:	fca43c23          	sd	a0,-40(s0)
ffffffe000202400:	fcb43823          	sd	a1,-48(s0)
ffffffe000202404:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000202408:	fd843783          	ld	a5,-40(s0)
ffffffe00020240c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202410:	1ff7f793          	andi	a5,a5,511
ffffffe000202414:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000202418:	fd043783          	ld	a5,-48(s0)
ffffffe00020241c:	00c7d793          	srli	a5,a5,0xc
ffffffe000202420:	00a79793          	slli	a5,a5,0xa
ffffffe000202424:	fc843703          	ld	a4,-56(s0)
ffffffe000202428:	00f767b3          	or	a5,a4,a5
ffffffe00020242c:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000202430:	00008717          	auipc	a4,0x8
ffffffe000202434:	bd070713          	addi	a4,a4,-1072 # ffffffe00020a000 <early_pgtbl>
ffffffe000202438:	fe843783          	ld	a5,-24(s0)
ffffffe00020243c:	00379793          	slli	a5,a5,0x3
ffffffe000202440:	00f707b3          	add	a5,a4,a5
ffffffe000202444:	fe043703          	ld	a4,-32(s0)
ffffffe000202448:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe00020244c:	00000013          	nop
ffffffe000202450:	03813403          	ld	s0,56(sp)
ffffffe000202454:	04010113          	addi	sp,sp,64
ffffffe000202458:	00008067          	ret

ffffffe00020245c <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe00020245c:	fc010113          	addi	sp,sp,-64
ffffffe000202460:	02113c23          	sd	ra,56(sp)
ffffffe000202464:	02813823          	sd	s0,48(sp)
ffffffe000202468:	04010413          	addi	s0,sp,64
ffffffe00020246c:	fca43c23          	sd	a0,-40(s0)
ffffffe000202470:	fcb43823          	sd	a1,-48(s0)
ffffffe000202474:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000202478:	d54fe0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe00020247c:	00050793          	mv	a5,a0
ffffffe000202480:	00078713          	mv	a4,a5
ffffffe000202484:	04100793          	li	a5,65
ffffffe000202488:	01f79793          	slli	a5,a5,0x1f
ffffffe00020248c:	00f707b3          	add	a5,a4,a5
ffffffe000202490:	fef43423          	sd	a5,-24(s0)
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000202494:	fe843783          	ld	a5,-24(s0)
ffffffe000202498:	00c7d793          	srli	a5,a5,0xc
ffffffe00020249c:	00a79693          	slli	a3,a5,0xa
ffffffe0002024a0:	fd043783          	ld	a5,-48(s0)
ffffffe0002024a4:	00379793          	slli	a5,a5,0x3
ffffffe0002024a8:	fd843703          	ld	a4,-40(s0)
ffffffe0002024ac:	00f707b3          	add	a5,a4,a5
ffffffe0002024b0:	fc843703          	ld	a4,-56(s0)
ffffffe0002024b4:	00e6e733          	or	a4,a3,a4
ffffffe0002024b8:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe0002024bc:	fd043783          	ld	a5,-48(s0)
ffffffe0002024c0:	00379793          	slli	a5,a5,0x3
ffffffe0002024c4:	fd843703          	ld	a4,-40(s0)
ffffffe0002024c8:	00f707b3          	add	a5,a4,a5
ffffffe0002024cc:	0007b783          	ld	a5,0(a5)
}
ffffffe0002024d0:	00078513          	mv	a0,a5
ffffffe0002024d4:	03813083          	ld	ra,56(sp)
ffffffe0002024d8:	03013403          	ld	s0,48(sp)
ffffffe0002024dc:	04010113          	addi	sp,sp,64
ffffffe0002024e0:	00008067          	ret

ffffffe0002024e4 <setup_vm_final>:

void setup_vm_final() {
ffffffe0002024e4:	f9010113          	addi	sp,sp,-112
ffffffe0002024e8:	06113423          	sd	ra,104(sp)
ffffffe0002024ec:	06813023          	sd	s0,96(sp)
ffffffe0002024f0:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe0002024f4:	00002517          	auipc	a0,0x2
ffffffe0002024f8:	f7c50513          	addi	a0,a0,-132 # ffffffe000204470 <__func__.0+0x28>
ffffffe0002024fc:	754010ef          	jal	ra,ffffffe000203c50 <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000202500:	00001637          	lui	a2,0x1
ffffffe000202504:	00000593          	li	a1,0
ffffffe000202508:	00009517          	auipc	a0,0x9
ffffffe00020250c:	af850513          	addi	a0,a0,-1288 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202510:	061010ef          	jal	ra,ffffffe000203d70 <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000202514:	40100793          	li	a5,1025
ffffffe000202518:	01579793          	slli	a5,a5,0x15
ffffffe00020251c:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000202520:	f00017b7          	lui	a5,0xf0001
ffffffe000202524:	00979793          	slli	a5,a5,0x9
ffffffe000202528:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe00020252c:	01100793          	li	a5,17
ffffffe000202530:	01b79793          	slli	a5,a5,0x1b
ffffffe000202534:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000202538:	c0100793          	li	a5,-1023
ffffffe00020253c:	01b79793          	slli	a5,a5,0x1b
ffffffe000202540:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000202544:	fe043783          	ld	a5,-32(s0)
ffffffe000202548:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe00020254c:	00002717          	auipc	a4,0x2
ffffffe000202550:	91070713          	addi	a4,a4,-1776 # ffffffe000203e5c <_etext>
ffffffe000202554:	000017b7          	lui	a5,0x1
ffffffe000202558:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe00020255c:	00f70733          	add	a4,a4,a5
ffffffe000202560:	fffff7b7          	lui	a5,0xfffff
ffffffe000202564:	00f777b3          	and	a5,a4,a5
ffffffe000202568:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe00020256c:	fc843703          	ld	a4,-56(s0)
ffffffe000202570:	04100793          	li	a5,65
ffffffe000202574:	01f79793          	slli	a5,a5,0x1f
ffffffe000202578:	00f70633          	add	a2,a4,a5
ffffffe00020257c:	fc043703          	ld	a4,-64(s0)
ffffffe000202580:	fc843783          	ld	a5,-56(s0)
ffffffe000202584:	40f707b3          	sub	a5,a4,a5
ffffffe000202588:	00b00713          	li	a4,11
ffffffe00020258c:	00078693          	mv	a3,a5
ffffffe000202590:	fc843583          	ld	a1,-56(s0)
ffffffe000202594:	00009517          	auipc	a0,0x9
ffffffe000202598:	a6c50513          	addi	a0,a0,-1428 # ffffffe00020b000 <swapper_pg_dir>
ffffffe00020259c:	1ac000ef          	jal	ra,ffffffe000202748 <create_mapping>
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);
ffffffe0002025a0:	00b00693          	li	a3,11
ffffffe0002025a4:	fc043603          	ld	a2,-64(s0)
ffffffe0002025a8:	fc843583          	ld	a1,-56(s0)
ffffffe0002025ac:	00002517          	auipc	a0,0x2
ffffffe0002025b0:	edc50513          	addi	a0,a0,-292 # ffffffe000204488 <__func__.0+0x40>
ffffffe0002025b4:	69c010ef          	jal	ra,ffffffe000203c50 <printk>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe0002025b8:	fc043783          	ld	a5,-64(s0)
ffffffe0002025bc:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe0002025c0:	00002717          	auipc	a4,0x2
ffffffe0002025c4:	23070713          	addi	a4,a4,560 # ffffffe0002047f0 <_erodata>
ffffffe0002025c8:	000017b7          	lui	a5,0x1
ffffffe0002025cc:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe0002025d0:	00f70733          	add	a4,a4,a5
ffffffe0002025d4:	fffff7b7          	lui	a5,0xfffff
ffffffe0002025d8:	00f777b3          	and	a5,a4,a5
ffffffe0002025dc:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe0002025e0:	fb843703          	ld	a4,-72(s0)
ffffffe0002025e4:	04100793          	li	a5,65
ffffffe0002025e8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002025ec:	00f70633          	add	a2,a4,a5
ffffffe0002025f0:	fb043703          	ld	a4,-80(s0)
ffffffe0002025f4:	fb843783          	ld	a5,-72(s0)
ffffffe0002025f8:	40f707b3          	sub	a5,a4,a5
ffffffe0002025fc:	00300713          	li	a4,3
ffffffe000202600:	00078693          	mv	a3,a5
ffffffe000202604:	fb843583          	ld	a1,-72(s0)
ffffffe000202608:	00009517          	auipc	a0,0x9
ffffffe00020260c:	9f850513          	addi	a0,a0,-1544 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202610:	138000ef          	jal	ra,ffffffe000202748 <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);
ffffffe000202614:	00300693          	li	a3,3
ffffffe000202618:	fb043603          	ld	a2,-80(s0)
ffffffe00020261c:	fb843583          	ld	a1,-72(s0)
ffffffe000202620:	00002517          	auipc	a0,0x2
ffffffe000202624:	ea050513          	addi	a0,a0,-352 # ffffffe0002044c0 <__func__.0+0x78>
ffffffe000202628:	628010ef          	jal	ra,ffffffe000203c50 <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe00020262c:	fb043783          	ld	a5,-80(s0)
ffffffe000202630:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe000202634:	fd043783          	ld	a5,-48(s0)
ffffffe000202638:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe00020263c:	fa843703          	ld	a4,-88(s0)
ffffffe000202640:	04100793          	li	a5,65
ffffffe000202644:	01f79793          	slli	a5,a5,0x1f
ffffffe000202648:	00f70633          	add	a2,a4,a5
ffffffe00020264c:	fa043703          	ld	a4,-96(s0)
ffffffe000202650:	fa843783          	ld	a5,-88(s0)
ffffffe000202654:	40f707b3          	sub	a5,a4,a5
ffffffe000202658:	00700713          	li	a4,7
ffffffe00020265c:	00078693          	mv	a3,a5
ffffffe000202660:	fa843583          	ld	a1,-88(s0)
ffffffe000202664:	00009517          	auipc	a0,0x9
ffffffe000202668:	99c50513          	addi	a0,a0,-1636 # ffffffe00020b000 <swapper_pg_dir>
ffffffe00020266c:	0dc000ef          	jal	ra,ffffffe000202748 <create_mapping>
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);
ffffffe000202670:	00700693          	li	a3,7
ffffffe000202674:	fa043603          	ld	a2,-96(s0)
ffffffe000202678:	fa843583          	ld	a1,-88(s0)
ffffffe00020267c:	00002517          	auipc	a0,0x2
ffffffe000202680:	e7c50513          	addi	a0,a0,-388 # ffffffe0002044f8 <__func__.0+0xb0>
ffffffe000202684:	5cc010ef          	jal	ra,ffffffe000203c50 <printk>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000202688:	00009517          	auipc	a0,0x9
ffffffe00020268c:	97850513          	addi	a0,a0,-1672 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202690:	044000ef          	jal	ra,ffffffe0002026d4 <get_satp>
ffffffe000202694:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000202698:	f9843783          	ld	a5,-104(s0)
ffffffe00020269c:	f8f43823          	sd	a5,-112(s0)
ffffffe0002026a0:	f9043783          	ld	a5,-112(s0)
ffffffe0002026a4:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe0002026a8:	f9843583          	ld	a1,-104(s0)
ffffffe0002026ac:	00002517          	auipc	a0,0x2
ffffffe0002026b0:	e7c50513          	addi	a0,a0,-388 # ffffffe000204528 <__func__.0+0xe0>
ffffffe0002026b4:	59c010ef          	jal	ra,ffffffe000203c50 <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe0002026b8:	12000073          	sfence.vma

    // flush icache
    asm volatile("fence.i");
ffffffe0002026bc:	0000100f          	fence.i
    return;
ffffffe0002026c0:	00000013          	nop
}
ffffffe0002026c4:	06813083          	ld	ra,104(sp)
ffffffe0002026c8:	06013403          	ld	s0,96(sp)
ffffffe0002026cc:	07010113          	addi	sp,sp,112
ffffffe0002026d0:	00008067          	ret

ffffffe0002026d4 <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe0002026d4:	fd010113          	addi	sp,sp,-48
ffffffe0002026d8:	02813423          	sd	s0,40(sp)
ffffffe0002026dc:	03010413          	addi	s0,sp,48
ffffffe0002026e0:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe0002026e4:	fd843703          	ld	a4,-40(s0)
ffffffe0002026e8:	04100793          	li	a5,65
ffffffe0002026ec:	01f79793          	slli	a5,a5,0x1f
ffffffe0002026f0:	00f707b3          	add	a5,a4,a5
ffffffe0002026f4:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe0002026f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002026fc:	00c7d713          	srli	a4,a5,0xc
ffffffe000202700:	fff00793          	li	a5,-1
ffffffe000202704:	03f79793          	slli	a5,a5,0x3f
ffffffe000202708:	00f767b3          	or	a5,a4,a5
}
ffffffe00020270c:	00078513          	mv	a0,a5
ffffffe000202710:	02813403          	ld	s0,40(sp)
ffffffe000202714:	03010113          	addi	sp,sp,48
ffffffe000202718:	00008067          	ret

ffffffe00020271c <vmflags2pte>:

uint64_t vmflags2pte(uint64_t vm_flags){
ffffffe00020271c:	fe010113          	addi	sp,sp,-32
ffffffe000202720:	00813c23          	sd	s0,24(sp)
ffffffe000202724:	02010413          	addi	s0,sp,32
ffffffe000202728:	fea43423          	sd	a0,-24(s0)
    return ((vm_flags & VM_READ) ? PTE_R : 0) | ((vm_flags & VM_WRITE) ? PTE_W : 0) | ((vm_flags & VM_EXEC) ? PTE_X : 0);
ffffffe00020272c:	fe843783          	ld	a5,-24(s0)
ffffffe000202730:	0007879b          	sext.w	a5,a5
ffffffe000202734:	00e7f793          	andi	a5,a5,14
}
ffffffe000202738:	00078513          	mv	a0,a5
ffffffe00020273c:	01813403          	ld	s0,24(sp)
ffffffe000202740:	02010113          	addi	sp,sp,32
ffffffe000202744:	00008067          	ret

ffffffe000202748 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000202748:	fb010113          	addi	sp,sp,-80
ffffffe00020274c:	04113423          	sd	ra,72(sp)
ffffffe000202750:	04813023          	sd	s0,64(sp)
ffffffe000202754:	05010413          	addi	s0,sp,80
ffffffe000202758:	fca43c23          	sd	a0,-40(s0)
ffffffe00020275c:	fcb43823          	sd	a1,-48(s0)
ffffffe000202760:	fcc43423          	sd	a2,-56(s0)
ffffffe000202764:	fcd43023          	sd	a3,-64(s0)
ffffffe000202768:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe00020276c:	fc043683          	ld	a3,-64(s0)
ffffffe000202770:	fc843603          	ld	a2,-56(s0)
ffffffe000202774:	fd043583          	ld	a1,-48(s0)
ffffffe000202778:	00002517          	auipc	a0,0x2
ffffffe00020277c:	dc050513          	addi	a0,a0,-576 # ffffffe000204538 <__func__.0+0xf0>
ffffffe000202780:	4d0010ef          	jal	ra,ffffffe000203c50 <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000202784:	fd043783          	ld	a5,-48(s0)
ffffffe000202788:	fef43423          	sd	a5,-24(s0)
ffffffe00020278c:	fc843783          	ld	a5,-56(s0)
ffffffe000202790:	fef43023          	sd	a5,-32(s0)
ffffffe000202794:	0380006f          	j	ffffffe0002027cc <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe000202798:	fb843683          	ld	a3,-72(s0)
ffffffe00020279c:	fe043603          	ld	a2,-32(s0)
ffffffe0002027a0:	fe843583          	ld	a1,-24(s0)
ffffffe0002027a4:	fd843503          	ld	a0,-40(s0)
ffffffe0002027a8:	050000ef          	jal	ra,ffffffe0002027f8 <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe0002027ac:	fe843703          	ld	a4,-24(s0)
ffffffe0002027b0:	000017b7          	lui	a5,0x1
ffffffe0002027b4:	00f707b3          	add	a5,a4,a5
ffffffe0002027b8:	fef43423          	sd	a5,-24(s0)
ffffffe0002027bc:	fe043703          	ld	a4,-32(s0)
ffffffe0002027c0:	000017b7          	lui	a5,0x1
ffffffe0002027c4:	00f707b3          	add	a5,a4,a5
ffffffe0002027c8:	fef43023          	sd	a5,-32(s0)
ffffffe0002027cc:	fd043703          	ld	a4,-48(s0)
ffffffe0002027d0:	fc043783          	ld	a5,-64(s0)
ffffffe0002027d4:	00f707b3          	add	a5,a4,a5
ffffffe0002027d8:	fe843703          	ld	a4,-24(s0)
ffffffe0002027dc:	faf76ee3          	bltu	a4,a5,ffffffe000202798 <create_mapping+0x50>
   }
}
ffffffe0002027e0:	00000013          	nop
ffffffe0002027e4:	00000013          	nop
ffffffe0002027e8:	04813083          	ld	ra,72(sp)
ffffffe0002027ec:	04013403          	ld	s0,64(sp)
ffffffe0002027f0:	05010113          	addi	sp,sp,80
ffffffe0002027f4:	00008067          	ret

ffffffe0002027f8 <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe0002027f8:	f9010113          	addi	sp,sp,-112
ffffffe0002027fc:	06113423          	sd	ra,104(sp)
ffffffe000202800:	06813023          	sd	s0,96(sp)
ffffffe000202804:	07010413          	addi	s0,sp,112
ffffffe000202808:	faa43423          	sd	a0,-88(s0)
ffffffe00020280c:	fab43023          	sd	a1,-96(s0)
ffffffe000202810:	f8c43c23          	sd	a2,-104(s0)
ffffffe000202814:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000202818:	fa043783          	ld	a5,-96(s0)
ffffffe00020281c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202820:	1ff7f793          	andi	a5,a5,511
ffffffe000202824:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000202828:	fa043783          	ld	a5,-96(s0)
ffffffe00020282c:	0157d793          	srli	a5,a5,0x15
ffffffe000202830:	1ff7f793          	andi	a5,a5,511
ffffffe000202834:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000202838:	fa043783          	ld	a5,-96(s0)
ffffffe00020283c:	00c7d793          	srli	a5,a5,0xc
ffffffe000202840:	1ff7f793          	andi	a5,a5,511
ffffffe000202844:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe000202848:	fd843783          	ld	a5,-40(s0)
ffffffe00020284c:	00379793          	slli	a5,a5,0x3
ffffffe000202850:	fa843703          	ld	a4,-88(s0)
ffffffe000202854:	00f707b3          	add	a5,a4,a5
ffffffe000202858:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe00020285c:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe000202860:	fe843783          	ld	a5,-24(s0)
ffffffe000202864:	0017f793          	andi	a5,a5,1
ffffffe000202868:	00079c63          	bnez	a5,ffffffe000202880 <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe00020286c:	00100613          	li	a2,1
ffffffe000202870:	fd843583          	ld	a1,-40(s0)
ffffffe000202874:	fa843503          	ld	a0,-88(s0)
ffffffe000202878:	be5ff0ef          	jal	ra,ffffffe00020245c <setup_pgtbl>
ffffffe00020287c:	fea43423          	sd	a0,-24(s0)
    }
    // printk("pte1 = %lx\n", pte);

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET); // VA
ffffffe000202880:	fe843783          	ld	a5,-24(s0)
ffffffe000202884:	00a7d793          	srli	a5,a5,0xa
ffffffe000202888:	00c79713          	slli	a4,a5,0xc
ffffffe00020288c:	fbf00793          	li	a5,-65
ffffffe000202890:	01f79793          	slli	a5,a5,0x1f
ffffffe000202894:	00f707b3          	add	a5,a4,a5
ffffffe000202898:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe00020289c:	fd043783          	ld	a5,-48(s0)
ffffffe0002028a0:	00379793          	slli	a5,a5,0x3
ffffffe0002028a4:	fc043703          	ld	a4,-64(s0)
ffffffe0002028a8:	00f707b3          	add	a5,a4,a5
ffffffe0002028ac:	0007b783          	ld	a5,0(a5)
ffffffe0002028b0:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe0002028b4:	fe043783          	ld	a5,-32(s0)
ffffffe0002028b8:	0017f793          	andi	a5,a5,1
ffffffe0002028bc:	00079c63          	bnez	a5,ffffffe0002028d4 <map_vm_final+0xdc>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe0002028c0:	00100613          	li	a2,1
ffffffe0002028c4:	fd043583          	ld	a1,-48(s0)
ffffffe0002028c8:	fc043503          	ld	a0,-64(s0)
ffffffe0002028cc:	b91ff0ef          	jal	ra,ffffffe00020245c <setup_pgtbl>
ffffffe0002028d0:	fea43023          	sd	a0,-32(s0)
    }
    // printk("pte2 = %lx\n", pte2);

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);// VA
ffffffe0002028d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002028d8:	00a7d793          	srli	a5,a5,0xa
ffffffe0002028dc:	00c79713          	slli	a4,a5,0xc
ffffffe0002028e0:	fbf00793          	li	a5,-65
ffffffe0002028e4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002028e8:	00f707b3          	add	a5,a4,a5
ffffffe0002028ec:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe0002028f0:	f9043783          	ld	a5,-112(s0)
ffffffe0002028f4:	0017e793          	ori	a5,a5,1
ffffffe0002028f8:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe0002028fc:	f9843783          	ld	a5,-104(s0)
ffffffe000202900:	00c7d793          	srli	a5,a5,0xc
ffffffe000202904:	00a79693          	slli	a3,a5,0xa
ffffffe000202908:	fc843783          	ld	a5,-56(s0)
ffffffe00020290c:	00379793          	slli	a5,a5,0x3
ffffffe000202910:	fb843703          	ld	a4,-72(s0)
ffffffe000202914:	00f707b3          	add	a5,a4,a5
ffffffe000202918:	f9043703          	ld	a4,-112(s0)
ffffffe00020291c:	00e6e733          	or	a4,a3,a4
ffffffe000202920:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202924:	00000013          	nop
ffffffe000202928:	06813083          	ld	ra,104(sp)
ffffffe00020292c:	06013403          	ld	s0,96(sp)
ffffffe000202930:	07010113          	addi	sp,sp,112
ffffffe000202934:	00008067          	ret

ffffffe000202938 <get_kernel_pgtbl>:

uint64_t* get_kernel_pgtbl() { return swapper_pg_dir; }
ffffffe000202938:	ff010113          	addi	sp,sp,-16
ffffffe00020293c:	00813423          	sd	s0,8(sp)
ffffffe000202940:	01010413          	addi	s0,sp,16
ffffffe000202944:	00008797          	auipc	a5,0x8
ffffffe000202948:	6bc78793          	addi	a5,a5,1724 # ffffffe00020b000 <swapper_pg_dir>
ffffffe00020294c:	00078513          	mv	a0,a5
ffffffe000202950:	00813403          	ld	s0,8(sp)
ffffffe000202954:	01010113          	addi	sp,sp,16
ffffffe000202958:	00008067          	ret

ffffffe00020295c <get_pte>:

uint64_t get_pte(uint64_t *pgtbl, uint64_t va){
ffffffe00020295c:	fa010113          	addi	sp,sp,-96
ffffffe000202960:	04813c23          	sd	s0,88(sp)
ffffffe000202964:	06010413          	addi	s0,sp,96
ffffffe000202968:	faa43423          	sd	a0,-88(s0)
ffffffe00020296c:	fab43023          	sd	a1,-96(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000202970:	fa043783          	ld	a5,-96(s0)
ffffffe000202974:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202978:	1ff7f793          	andi	a5,a5,511
ffffffe00020297c:	fef43423          	sd	a5,-24(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000202980:	fa043783          	ld	a5,-96(s0)
ffffffe000202984:	0157d793          	srli	a5,a5,0x15
ffffffe000202988:	1ff7f793          	andi	a5,a5,511
ffffffe00020298c:	fef43023          	sd	a5,-32(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000202990:	fa043783          	ld	a5,-96(s0)
ffffffe000202994:	00c7d793          	srli	a5,a5,0xc
ffffffe000202998:	1ff7f793          	andi	a5,a5,511
ffffffe00020299c:	fcf43c23          	sd	a5,-40(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe0002029a0:	fe843783          	ld	a5,-24(s0)
ffffffe0002029a4:	00379793          	slli	a5,a5,0x3
ffffffe0002029a8:	fa843703          	ld	a4,-88(s0)
ffffffe0002029ac:	00f707b3          	add	a5,a4,a5
ffffffe0002029b0:	0007b783          	ld	a5,0(a5)
ffffffe0002029b4:	fcf43823          	sd	a5,-48(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe0002029b8:	fd043783          	ld	a5,-48(s0)
ffffffe0002029bc:	0017f793          	andi	a5,a5,1
ffffffe0002029c0:	00079663          	bnez	a5,ffffffe0002029cc <get_pte+0x70>
        return 0;
ffffffe0002029c4:	00000793          	li	a5,0
ffffffe0002029c8:	07c0006f          	j	ffffffe000202a44 <get_pte+0xe8>
    }

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe0002029cc:	fd043783          	ld	a5,-48(s0)
ffffffe0002029d0:	00a7d793          	srli	a5,a5,0xa
ffffffe0002029d4:	00c79713          	slli	a4,a5,0xc
ffffffe0002029d8:	fbf00793          	li	a5,-65
ffffffe0002029dc:	01f79793          	slli	a5,a5,0x1f
ffffffe0002029e0:	00f707b3          	add	a5,a4,a5
ffffffe0002029e4:	fcf43423          	sd	a5,-56(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe0002029e8:	fe043783          	ld	a5,-32(s0)
ffffffe0002029ec:	00379793          	slli	a5,a5,0x3
ffffffe0002029f0:	fc843703          	ld	a4,-56(s0)
ffffffe0002029f4:	00f707b3          	add	a5,a4,a5
ffffffe0002029f8:	0007b783          	ld	a5,0(a5)
ffffffe0002029fc:	fcf43023          	sd	a5,-64(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe000202a00:	fc043783          	ld	a5,-64(s0)
ffffffe000202a04:	0017f793          	andi	a5,a5,1
ffffffe000202a08:	00079663          	bnez	a5,ffffffe000202a14 <get_pte+0xb8>
        return 0;
ffffffe000202a0c:	00000793          	li	a5,0
ffffffe000202a10:	0340006f          	j	ffffffe000202a44 <get_pte+0xe8>
    }

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);
ffffffe000202a14:	fc043783          	ld	a5,-64(s0)
ffffffe000202a18:	00a7d793          	srli	a5,a5,0xa
ffffffe000202a1c:	00c79713          	slli	a4,a5,0xc
ffffffe000202a20:	fbf00793          	li	a5,-65
ffffffe000202a24:	01f79793          	slli	a5,a5,0x1f
ffffffe000202a28:	00f707b3          	add	a5,a4,a5
ffffffe000202a2c:	faf43c23          	sd	a5,-72(s0)
    return pgtbl3[idx3];
ffffffe000202a30:	fd843783          	ld	a5,-40(s0)
ffffffe000202a34:	00379793          	slli	a5,a5,0x3
ffffffe000202a38:	fb843703          	ld	a4,-72(s0)
ffffffe000202a3c:	00f707b3          	add	a5,a4,a5
ffffffe000202a40:	0007b783          	ld	a5,0(a5)
}
ffffffe000202a44:	00078513          	mv	a0,a5
ffffffe000202a48:	05813403          	ld	s0,88(sp)
ffffffe000202a4c:	06010113          	addi	sp,sp,96
ffffffe000202a50:	00008067          	ret

ffffffe000202a54 <va_mapped>:

int va_mapped(uint64_t *pgtbl, uint64_t va){
ffffffe000202a54:	fd010113          	addi	sp,sp,-48
ffffffe000202a58:	02113423          	sd	ra,40(sp)
ffffffe000202a5c:	02813023          	sd	s0,32(sp)
ffffffe000202a60:	03010413          	addi	s0,sp,48
ffffffe000202a64:	fca43c23          	sd	a0,-40(s0)
ffffffe000202a68:	fcb43823          	sd	a1,-48(s0)
    uint64_t pte = get_pte(pgtbl, va);
ffffffe000202a6c:	fd043583          	ld	a1,-48(s0)
ffffffe000202a70:	fd843503          	ld	a0,-40(s0)
ffffffe000202a74:	ee9ff0ef          	jal	ra,ffffffe00020295c <get_pte>
ffffffe000202a78:	fea43423          	sd	a0,-24(s0)
    return PTE_ISVALID(pte);
ffffffe000202a7c:	fe843783          	ld	a5,-24(s0)
ffffffe000202a80:	0007879b          	sext.w	a5,a5
ffffffe000202a84:	0017f793          	andi	a5,a5,1
ffffffe000202a88:	0007879b          	sext.w	a5,a5
ffffffe000202a8c:	00078513          	mv	a0,a5
ffffffe000202a90:	02813083          	ld	ra,40(sp)
ffffffe000202a94:	02013403          	ld	s0,32(sp)
ffffffe000202a98:	03010113          	addi	sp,sp,48
ffffffe000202a9c:	00008067          	ret

ffffffe000202aa0 <start_kernel>:
#include "defs.h"
#include "proc.h"

extern void test();

int start_kernel() {
ffffffe000202aa0:	ff010113          	addi	sp,sp,-16
ffffffe000202aa4:	00113423          	sd	ra,8(sp)
ffffffe000202aa8:	00813023          	sd	s0,0(sp)
ffffffe000202aac:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000202ab0:	00002517          	auipc	a0,0x2
ffffffe000202ab4:	ab050513          	addi	a0,a0,-1360 # ffffffe000204560 <__func__.0+0x118>
ffffffe000202ab8:	198010ef          	jal	ra,ffffffe000203c50 <printk>
    printk(" ZJU Operating System\n");
ffffffe000202abc:	00002517          	auipc	a0,0x2
ffffffe000202ac0:	aac50513          	addi	a0,a0,-1364 # ffffffe000204568 <__func__.0+0x120>
ffffffe000202ac4:	18c010ef          	jal	ra,ffffffe000203c50 <printk>
    schedule();
ffffffe000202ac8:	f94fe0ef          	jal	ra,ffffffe00020125c <schedule>
    // verify_vm();

    test();
ffffffe000202acc:	2c0000ef          	jal	ra,ffffffe000202d8c <test>
    return 0;
ffffffe000202ad0:	00000793          	li	a5,0
}
ffffffe000202ad4:	00078513          	mv	a0,a5
ffffffe000202ad8:	00813083          	ld	ra,8(sp)
ffffffe000202adc:	00013403          	ld	s0,0(sp)
ffffffe000202ae0:	01010113          	addi	sp,sp,16
ffffffe000202ae4:	00008067          	ret

ffffffe000202ae8 <test_rodata_write>:

void test_rodata_write(uint64_t *addr) {
ffffffe000202ae8:	fd010113          	addi	sp,sp,-48
ffffffe000202aec:	02113423          	sd	ra,40(sp)
ffffffe000202af0:	02813023          	sd	s0,32(sp)
ffffffe000202af4:	03010413          	addi	s0,sp,48
ffffffe000202af8:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr;
ffffffe000202afc:	fd843783          	ld	a5,-40(s0)
ffffffe000202b00:	0007b783          	ld	a5,0(a5)
ffffffe000202b04:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000202b08:	00100793          	li	a5,1
ffffffe000202b0c:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000202b10:	fd843783          	ld	a5,-40(s0)
ffffffe000202b14:	00100293          	li	t0,1
ffffffe000202b18:	0057b023          	sd	t0,0(a5)
ffffffe000202b1c:	00000793          	li	a5,0
ffffffe000202b20:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000202b24:	fe442783          	lw	a5,-28(s0)
ffffffe000202b28:	0007879b          	sext.w	a5,a5
ffffffe000202b2c:	02078063          	beqz	a5,ffffffe000202b4c <test_rodata_write+0x64>
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
ffffffe000202b30:	00002517          	auipc	a0,0x2
ffffffe000202b34:	a5050513          	addi	a0,a0,-1456 # ffffffe000204580 <__func__.0+0x138>
ffffffe000202b38:	118010ef          	jal	ra,ffffffe000203c50 <printk>
        *addr = backup; // 恢复原值
ffffffe000202b3c:	fd843783          	ld	a5,-40(s0)
ffffffe000202b40:	fe843703          	ld	a4,-24(s0)
ffffffe000202b44:	00e7b023          	sd	a4,0(a5)
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}
ffffffe000202b48:	0100006f          	j	ffffffe000202b58 <test_rodata_write+0x70>
        printk("PASS: .rodata write failed as expected.\n");
ffffffe000202b4c:	00002517          	auipc	a0,0x2
ffffffe000202b50:	a6450513          	addi	a0,a0,-1436 # ffffffe0002045b0 <__func__.0+0x168>
ffffffe000202b54:	0fc010ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe000202b58:	00000013          	nop
ffffffe000202b5c:	02813083          	ld	ra,40(sp)
ffffffe000202b60:	02013403          	ld	s0,32(sp)
ffffffe000202b64:	03010113          	addi	sp,sp,48
ffffffe000202b68:	00008067          	ret

ffffffe000202b6c <test_rodata_exec>:

void test_rodata_exec(uint64_t *addr) {
ffffffe000202b6c:	fd010113          	addi	sp,sp,-48
ffffffe000202b70:	02113423          	sd	ra,40(sp)
ffffffe000202b74:	02813023          	sd	s0,32(sp)
ffffffe000202b78:	03010413          	addi	s0,sp,48
ffffffe000202b7c:	fca43c23          	sd	a0,-40(s0)
    int success = 1;
ffffffe000202b80:	00100793          	li	a5,1
ffffffe000202b84:	fef42623          	sw	a5,-20(s0)

    asm volatile(
ffffffe000202b88:	fd843783          	ld	a5,-40(s0)
ffffffe000202b8c:	000780e7          	jalr	a5
ffffffe000202b90:	00000793          	li	a5,0
ffffffe000202b94:	fef42623          	sw	a5,-20(s0)
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
ffffffe000202b98:	fec42783          	lw	a5,-20(s0)
ffffffe000202b9c:	0007879b          	sext.w	a5,a5
ffffffe000202ba0:	00078a63          	beqz	a5,ffffffe000202bb4 <test_rodata_exec+0x48>
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
ffffffe000202ba4:	00002517          	auipc	a0,0x2
ffffffe000202ba8:	a3c50513          	addi	a0,a0,-1476 # ffffffe0002045e0 <__func__.0+0x198>
ffffffe000202bac:	0a4010ef          	jal	ra,ffffffe000203c50 <printk>
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}
ffffffe000202bb0:	0100006f          	j	ffffffe000202bc0 <test_rodata_exec+0x54>
        printk("PASS: .rodata execute failed as expected.\n");
ffffffe000202bb4:	00002517          	auipc	a0,0x2
ffffffe000202bb8:	a5c50513          	addi	a0,a0,-1444 # ffffffe000204610 <__func__.0+0x1c8>
ffffffe000202bbc:	094010ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe000202bc0:	00000013          	nop
ffffffe000202bc4:	02813083          	ld	ra,40(sp)
ffffffe000202bc8:	02013403          	ld	s0,32(sp)
ffffffe000202bcc:	03010113          	addi	sp,sp,48
ffffffe000202bd0:	00008067          	ret

ffffffe000202bd4 <test_text_read>:

void test_text_read(uint64_t *addr) {
ffffffe000202bd4:	fd010113          	addi	sp,sp,-48
ffffffe000202bd8:	02113423          	sd	ra,40(sp)
ffffffe000202bdc:	02813023          	sd	s0,32(sp)
ffffffe000202be0:	03010413          	addi	s0,sp,48
ffffffe000202be4:	fca43c23          	sd	a0,-40(s0)
    printk(".text read test: ");
ffffffe000202be8:	00002517          	auipc	a0,0x2
ffffffe000202bec:	a5850513          	addi	a0,a0,-1448 # ffffffe000204640 <__func__.0+0x1f8>
ffffffe000202bf0:	060010ef          	jal	ra,ffffffe000203c50 <printk>
    uint64_t value = *addr;
ffffffe000202bf4:	fd843783          	ld	a5,-40(s0)
ffffffe000202bf8:	0007b783          	ld	a5,0(a5)
ffffffe000202bfc:	fef43423          	sd	a5,-24(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe000202c00:	fe843583          	ld	a1,-24(s0)
ffffffe000202c04:	00002517          	auipc	a0,0x2
ffffffe000202c08:	a5450513          	addi	a0,a0,-1452 # ffffffe000204658 <__func__.0+0x210>
ffffffe000202c0c:	044010ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe000202c10:	00000013          	nop
ffffffe000202c14:	02813083          	ld	ra,40(sp)
ffffffe000202c18:	02013403          	ld	s0,32(sp)
ffffffe000202c1c:	03010113          	addi	sp,sp,48
ffffffe000202c20:	00008067          	ret

ffffffe000202c24 <test_text_write>:

void test_text_write(uint64_t *addr) {
ffffffe000202c24:	fd010113          	addi	sp,sp,-48
ffffffe000202c28:	02113423          	sd	ra,40(sp)
ffffffe000202c2c:	02813023          	sd	s0,32(sp)
ffffffe000202c30:	03010413          	addi	s0,sp,48
ffffffe000202c34:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr; // 备份原始值
ffffffe000202c38:	fd843783          	ld	a5,-40(s0)
ffffffe000202c3c:	0007b783          	ld	a5,0(a5)
ffffffe000202c40:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000202c44:	00100793          	li	a5,1
ffffffe000202c48:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000202c4c:	fd843783          	ld	a5,-40(s0)
ffffffe000202c50:	00100293          	li	t0,1
ffffffe000202c54:	0057b023          	sd	t0,0(a5)
ffffffe000202c58:	00000793          	li	a5,0
ffffffe000202c5c:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000202c60:	fe442783          	lw	a5,-28(s0)
ffffffe000202c64:	0007879b          	sext.w	a5,a5
ffffffe000202c68:	00078a63          	beqz	a5,ffffffe000202c7c <test_text_write+0x58>
        printk("PASS: .text write failed as expected.\n");
ffffffe000202c6c:	00002517          	auipc	a0,0x2
ffffffe000202c70:	a1450513          	addi	a0,a0,-1516 # ffffffe000204680 <__func__.0+0x238>
ffffffe000202c74:	7dd000ef          	jal	ra,ffffffe000203c50 <printk>
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}
ffffffe000202c78:	01c0006f          	j	ffffffe000202c94 <test_text_write+0x70>
        printk("ERROR: .text write succeeded unexpectedly!\n");
ffffffe000202c7c:	00002517          	auipc	a0,0x2
ffffffe000202c80:	a2c50513          	addi	a0,a0,-1492 # ffffffe0002046a8 <__func__.0+0x260>
ffffffe000202c84:	7cd000ef          	jal	ra,ffffffe000203c50 <printk>
        *addr = backup; // 恢复原始值，避免破坏代码段
ffffffe000202c88:	fd843783          	ld	a5,-40(s0)
ffffffe000202c8c:	fe843703          	ld	a4,-24(s0)
ffffffe000202c90:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202c94:	00000013          	nop
ffffffe000202c98:	02813083          	ld	ra,40(sp)
ffffffe000202c9c:	02013403          	ld	s0,32(sp)
ffffffe000202ca0:	03010113          	addi	sp,sp,48
ffffffe000202ca4:	00008067          	ret

ffffffe000202ca8 <test_text_exec>:

void test_text_exec() {
ffffffe000202ca8:	ff010113          	addi	sp,sp,-16
ffffffe000202cac:	00113423          	sd	ra,8(sp)
ffffffe000202cb0:	00813023          	sd	s0,0(sp)
ffffffe000202cb4:	01010413          	addi	s0,sp,16
    printk("Executing .text segment test: ");
ffffffe000202cb8:	00002517          	auipc	a0,0x2
ffffffe000202cbc:	a2050513          	addi	a0,a0,-1504 # ffffffe0002046d8 <__func__.0+0x290>
ffffffe000202cc0:	791000ef          	jal	ra,ffffffe000203c50 <printk>
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
ffffffe000202cc4:	00002517          	auipc	a0,0x2
ffffffe000202cc8:	a3450513          	addi	a0,a0,-1484 # ffffffe0002046f8 <__func__.0+0x2b0>
ffffffe000202ccc:	785000ef          	jal	ra,ffffffe000203c50 <printk>
}
ffffffe000202cd0:	00000013          	nop
ffffffe000202cd4:	00813083          	ld	ra,8(sp)
ffffffe000202cd8:	00013403          	ld	s0,0(sp)
ffffffe000202cdc:	01010113          	addi	sp,sp,16
ffffffe000202ce0:	00008067          	ret

ffffffe000202ce4 <verify_vm>:

void verify_vm() {
ffffffe000202ce4:	fd010113          	addi	sp,sp,-48
ffffffe000202ce8:	02113423          	sd	ra,40(sp)
ffffffe000202cec:	02813023          	sd	s0,32(sp)
ffffffe000202cf0:	03010413          	addi	s0,sp,48
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
ffffffe000202cf4:	f00017b7          	lui	a5,0xf0001
ffffffe000202cf8:	00979793          	slli	a5,a5,0x9
ffffffe000202cfc:	fef43423          	sd	a5,-24(s0)
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段
ffffffe000202d00:	fe0007b7          	lui	a5,0xfe000
ffffffe000202d04:	20378793          	addi	a5,a5,515 # fffffffffe000203 <VM_END+0xfe000203>
ffffffe000202d08:	00c79793          	slli	a5,a5,0xc
ffffffe000202d0c:	fef43023          	sd	a5,-32(s0)

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;
ffffffe000202d10:	fe843783          	ld	a5,-24(s0)
ffffffe000202d14:	fcf43c23          	sd	a5,-40(s0)

    // .text R
    printk(".text read test: \n");
ffffffe000202d18:	00002517          	auipc	a0,0x2
ffffffe000202d1c:	a0050513          	addi	a0,a0,-1536 # ffffffe000204718 <__func__.0+0x2d0>
ffffffe000202d20:	731000ef          	jal	ra,ffffffe000203c50 <printk>
    test_text_read(test_addr);
ffffffe000202d24:	fd843503          	ld	a0,-40(s0)
ffffffe000202d28:	eadff0ef          	jal	ra,ffffffe000202bd4 <test_text_read>
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
ffffffe000202d2c:	00002517          	auipc	a0,0x2
ffffffe000202d30:	a0450513          	addi	a0,a0,-1532 # ffffffe000204730 <__func__.0+0x2e8>
ffffffe000202d34:	71d000ef          	jal	ra,ffffffe000203c50 <printk>
    test_text_exec();
ffffffe000202d38:	f71ff0ef          	jal	ra,ffffffe000202ca8 <test_text_exec>

    // .rodata
    test_addr = (uint64_t *)va_rodata;
ffffffe000202d3c:	fe043783          	ld	a5,-32(s0)
ffffffe000202d40:	fcf43c23          	sd	a5,-40(s0)

    // .rodata R
    printk(".rodata read test: \n");
ffffffe000202d44:	00002517          	auipc	a0,0x2
ffffffe000202d48:	a0450513          	addi	a0,a0,-1532 # ffffffe000204748 <__func__.0+0x300>
ffffffe000202d4c:	705000ef          	jal	ra,ffffffe000203c50 <printk>
    uint64_t value = *test_addr;
ffffffe000202d50:	fd843783          	ld	a5,-40(s0)
ffffffe000202d54:	0007b783          	ld	a5,0(a5)
ffffffe000202d58:	fcf43823          	sd	a5,-48(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe000202d5c:	fd043583          	ld	a1,-48(s0)
ffffffe000202d60:	00002517          	auipc	a0,0x2
ffffffe000202d64:	8f850513          	addi	a0,a0,-1800 # ffffffe000204658 <__func__.0+0x210>
ffffffe000202d68:	6e9000ef          	jal	ra,ffffffe000203c50 <printk>

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
ffffffe000202d6c:	00002517          	auipc	a0,0x2
ffffffe000202d70:	9f450513          	addi	a0,a0,-1548 # ffffffe000204760 <__func__.0+0x318>
ffffffe000202d74:	6dd000ef          	jal	ra,ffffffe000203c50 <printk>
ffffffe000202d78:	00000013          	nop
ffffffe000202d7c:	02813083          	ld	ra,40(sp)
ffffffe000202d80:	02013403          	ld	s0,32(sp)
ffffffe000202d84:	03010113          	addi	sp,sp,48
ffffffe000202d88:	00008067          	ret

ffffffe000202d8c <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe000202d8c:	fe010113          	addi	sp,sp,-32
ffffffe000202d90:	00113c23          	sd	ra,24(sp)
ffffffe000202d94:	00813823          	sd	s0,16(sp)
ffffffe000202d98:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000202d9c:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe000202da0:	00002517          	auipc	a0,0x2
ffffffe000202da4:	9e050513          	addi	a0,a0,-1568 # ffffffe000204780 <__func__.0+0x338>
ffffffe000202da8:	6a9000ef          	jal	ra,ffffffe000203c50 <printk>
    while (1)
    {
        i++;
ffffffe000202dac:	fec42783          	lw	a5,-20(s0)
ffffffe000202db0:	0017879b          	addiw	a5,a5,1
ffffffe000202db4:	fef42623          	sw	a5,-20(s0)
ffffffe000202db8:	ff5ff06f          	j	ffffffe000202dac <test+0x20>

ffffffe000202dbc <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000202dbc:	fe010113          	addi	sp,sp,-32
ffffffe000202dc0:	00113c23          	sd	ra,24(sp)
ffffffe000202dc4:	00813823          	sd	s0,16(sp)
ffffffe000202dc8:	02010413          	addi	s0,sp,32
ffffffe000202dcc:	00050793          	mv	a5,a0
ffffffe000202dd0:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe000202dd4:	fec42783          	lw	a5,-20(s0)
ffffffe000202dd8:	0ff7f793          	zext.b	a5,a5
ffffffe000202ddc:	00078513          	mv	a0,a5
ffffffe000202de0:	a41fe0ef          	jal	ra,ffffffe000201820 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000202de4:	fec42783          	lw	a5,-20(s0)
ffffffe000202de8:	0ff7f793          	zext.b	a5,a5
ffffffe000202dec:	0007879b          	sext.w	a5,a5
}
ffffffe000202df0:	00078513          	mv	a0,a5
ffffffe000202df4:	01813083          	ld	ra,24(sp)
ffffffe000202df8:	01013403          	ld	s0,16(sp)
ffffffe000202dfc:	02010113          	addi	sp,sp,32
ffffffe000202e00:	00008067          	ret

ffffffe000202e04 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe000202e04:	fe010113          	addi	sp,sp,-32
ffffffe000202e08:	00813c23          	sd	s0,24(sp)
ffffffe000202e0c:	02010413          	addi	s0,sp,32
ffffffe000202e10:	00050793          	mv	a5,a0
ffffffe000202e14:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000202e18:	fec42783          	lw	a5,-20(s0)
ffffffe000202e1c:	0007871b          	sext.w	a4,a5
ffffffe000202e20:	02000793          	li	a5,32
ffffffe000202e24:	02f70263          	beq	a4,a5,ffffffe000202e48 <isspace+0x44>
ffffffe000202e28:	fec42783          	lw	a5,-20(s0)
ffffffe000202e2c:	0007871b          	sext.w	a4,a5
ffffffe000202e30:	00800793          	li	a5,8
ffffffe000202e34:	00e7de63          	bge	a5,a4,ffffffe000202e50 <isspace+0x4c>
ffffffe000202e38:	fec42783          	lw	a5,-20(s0)
ffffffe000202e3c:	0007871b          	sext.w	a4,a5
ffffffe000202e40:	00d00793          	li	a5,13
ffffffe000202e44:	00e7c663          	blt	a5,a4,ffffffe000202e50 <isspace+0x4c>
ffffffe000202e48:	00100793          	li	a5,1
ffffffe000202e4c:	0080006f          	j	ffffffe000202e54 <isspace+0x50>
ffffffe000202e50:	00000793          	li	a5,0
}
ffffffe000202e54:	00078513          	mv	a0,a5
ffffffe000202e58:	01813403          	ld	s0,24(sp)
ffffffe000202e5c:	02010113          	addi	sp,sp,32
ffffffe000202e60:	00008067          	ret

ffffffe000202e64 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000202e64:	fb010113          	addi	sp,sp,-80
ffffffe000202e68:	04113423          	sd	ra,72(sp)
ffffffe000202e6c:	04813023          	sd	s0,64(sp)
ffffffe000202e70:	05010413          	addi	s0,sp,80
ffffffe000202e74:	fca43423          	sd	a0,-56(s0)
ffffffe000202e78:	fcb43023          	sd	a1,-64(s0)
ffffffe000202e7c:	00060793          	mv	a5,a2
ffffffe000202e80:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000202e84:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202e88:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000202e8c:	fc843783          	ld	a5,-56(s0)
ffffffe000202e90:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000202e94:	0100006f          	j	ffffffe000202ea4 <strtol+0x40>
        p++;
ffffffe000202e98:	fd843783          	ld	a5,-40(s0)
ffffffe000202e9c:	00178793          	addi	a5,a5,1
ffffffe000202ea0:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000202ea4:	fd843783          	ld	a5,-40(s0)
ffffffe000202ea8:	0007c783          	lbu	a5,0(a5)
ffffffe000202eac:	0007879b          	sext.w	a5,a5
ffffffe000202eb0:	00078513          	mv	a0,a5
ffffffe000202eb4:	f51ff0ef          	jal	ra,ffffffe000202e04 <isspace>
ffffffe000202eb8:	00050793          	mv	a5,a0
ffffffe000202ebc:	fc079ee3          	bnez	a5,ffffffe000202e98 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000202ec0:	fd843783          	ld	a5,-40(s0)
ffffffe000202ec4:	0007c783          	lbu	a5,0(a5)
ffffffe000202ec8:	00078713          	mv	a4,a5
ffffffe000202ecc:	02d00793          	li	a5,45
ffffffe000202ed0:	00f71e63          	bne	a4,a5,ffffffe000202eec <strtol+0x88>
        neg = true;
ffffffe000202ed4:	00100793          	li	a5,1
ffffffe000202ed8:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe000202edc:	fd843783          	ld	a5,-40(s0)
ffffffe000202ee0:	00178793          	addi	a5,a5,1
ffffffe000202ee4:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202ee8:	0240006f          	j	ffffffe000202f0c <strtol+0xa8>
    } else if (*p == '+') {
ffffffe000202eec:	fd843783          	ld	a5,-40(s0)
ffffffe000202ef0:	0007c783          	lbu	a5,0(a5)
ffffffe000202ef4:	00078713          	mv	a4,a5
ffffffe000202ef8:	02b00793          	li	a5,43
ffffffe000202efc:	00f71863          	bne	a4,a5,ffffffe000202f0c <strtol+0xa8>
        p++;
ffffffe000202f00:	fd843783          	ld	a5,-40(s0)
ffffffe000202f04:	00178793          	addi	a5,a5,1
ffffffe000202f08:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe000202f0c:	fbc42783          	lw	a5,-68(s0)
ffffffe000202f10:	0007879b          	sext.w	a5,a5
ffffffe000202f14:	06079c63          	bnez	a5,ffffffe000202f8c <strtol+0x128>
        if (*p == '0') {
ffffffe000202f18:	fd843783          	ld	a5,-40(s0)
ffffffe000202f1c:	0007c783          	lbu	a5,0(a5)
ffffffe000202f20:	00078713          	mv	a4,a5
ffffffe000202f24:	03000793          	li	a5,48
ffffffe000202f28:	04f71e63          	bne	a4,a5,ffffffe000202f84 <strtol+0x120>
            p++;
ffffffe000202f2c:	fd843783          	ld	a5,-40(s0)
ffffffe000202f30:	00178793          	addi	a5,a5,1
ffffffe000202f34:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000202f38:	fd843783          	ld	a5,-40(s0)
ffffffe000202f3c:	0007c783          	lbu	a5,0(a5)
ffffffe000202f40:	00078713          	mv	a4,a5
ffffffe000202f44:	07800793          	li	a5,120
ffffffe000202f48:	00f70c63          	beq	a4,a5,ffffffe000202f60 <strtol+0xfc>
ffffffe000202f4c:	fd843783          	ld	a5,-40(s0)
ffffffe000202f50:	0007c783          	lbu	a5,0(a5)
ffffffe000202f54:	00078713          	mv	a4,a5
ffffffe000202f58:	05800793          	li	a5,88
ffffffe000202f5c:	00f71e63          	bne	a4,a5,ffffffe000202f78 <strtol+0x114>
                base = 16;
ffffffe000202f60:	01000793          	li	a5,16
ffffffe000202f64:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202f68:	fd843783          	ld	a5,-40(s0)
ffffffe000202f6c:	00178793          	addi	a5,a5,1
ffffffe000202f70:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202f74:	0180006f          	j	ffffffe000202f8c <strtol+0x128>
            } else {
                base = 8;
ffffffe000202f78:	00800793          	li	a5,8
ffffffe000202f7c:	faf42e23          	sw	a5,-68(s0)
ffffffe000202f80:	00c0006f          	j	ffffffe000202f8c <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202f84:	00a00793          	li	a5,10
ffffffe000202f88:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000202f8c:	fd843783          	ld	a5,-40(s0)
ffffffe000202f90:	0007c783          	lbu	a5,0(a5)
ffffffe000202f94:	00078713          	mv	a4,a5
ffffffe000202f98:	02f00793          	li	a5,47
ffffffe000202f9c:	02e7f863          	bgeu	a5,a4,ffffffe000202fcc <strtol+0x168>
ffffffe000202fa0:	fd843783          	ld	a5,-40(s0)
ffffffe000202fa4:	0007c783          	lbu	a5,0(a5)
ffffffe000202fa8:	00078713          	mv	a4,a5
ffffffe000202fac:	03900793          	li	a5,57
ffffffe000202fb0:	00e7ee63          	bltu	a5,a4,ffffffe000202fcc <strtol+0x168>
            digit = *p - '0';
ffffffe000202fb4:	fd843783          	ld	a5,-40(s0)
ffffffe000202fb8:	0007c783          	lbu	a5,0(a5)
ffffffe000202fbc:	0007879b          	sext.w	a5,a5
ffffffe000202fc0:	fd07879b          	addiw	a5,a5,-48
ffffffe000202fc4:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202fc8:	0800006f          	j	ffffffe000203048 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000202fcc:	fd843783          	ld	a5,-40(s0)
ffffffe000202fd0:	0007c783          	lbu	a5,0(a5)
ffffffe000202fd4:	00078713          	mv	a4,a5
ffffffe000202fd8:	06000793          	li	a5,96
ffffffe000202fdc:	02e7f863          	bgeu	a5,a4,ffffffe00020300c <strtol+0x1a8>
ffffffe000202fe0:	fd843783          	ld	a5,-40(s0)
ffffffe000202fe4:	0007c783          	lbu	a5,0(a5)
ffffffe000202fe8:	00078713          	mv	a4,a5
ffffffe000202fec:	07a00793          	li	a5,122
ffffffe000202ff0:	00e7ee63          	bltu	a5,a4,ffffffe00020300c <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe000202ff4:	fd843783          	ld	a5,-40(s0)
ffffffe000202ff8:	0007c783          	lbu	a5,0(a5)
ffffffe000202ffc:	0007879b          	sext.w	a5,a5
ffffffe000203000:	fa97879b          	addiw	a5,a5,-87
ffffffe000203004:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203008:	0400006f          	j	ffffffe000203048 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe00020300c:	fd843783          	ld	a5,-40(s0)
ffffffe000203010:	0007c783          	lbu	a5,0(a5)
ffffffe000203014:	00078713          	mv	a4,a5
ffffffe000203018:	04000793          	li	a5,64
ffffffe00020301c:	06e7f863          	bgeu	a5,a4,ffffffe00020308c <strtol+0x228>
ffffffe000203020:	fd843783          	ld	a5,-40(s0)
ffffffe000203024:	0007c783          	lbu	a5,0(a5)
ffffffe000203028:	00078713          	mv	a4,a5
ffffffe00020302c:	05a00793          	li	a5,90
ffffffe000203030:	04e7ee63          	bltu	a5,a4,ffffffe00020308c <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000203034:	fd843783          	ld	a5,-40(s0)
ffffffe000203038:	0007c783          	lbu	a5,0(a5)
ffffffe00020303c:	0007879b          	sext.w	a5,a5
ffffffe000203040:	fc97879b          	addiw	a5,a5,-55
ffffffe000203044:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000203048:	fd442783          	lw	a5,-44(s0)
ffffffe00020304c:	00078713          	mv	a4,a5
ffffffe000203050:	fbc42783          	lw	a5,-68(s0)
ffffffe000203054:	0007071b          	sext.w	a4,a4
ffffffe000203058:	0007879b          	sext.w	a5,a5
ffffffe00020305c:	02f75663          	bge	a4,a5,ffffffe000203088 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000203060:	fbc42703          	lw	a4,-68(s0)
ffffffe000203064:	fe843783          	ld	a5,-24(s0)
ffffffe000203068:	02f70733          	mul	a4,a4,a5
ffffffe00020306c:	fd442783          	lw	a5,-44(s0)
ffffffe000203070:	00f707b3          	add	a5,a4,a5
ffffffe000203074:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000203078:	fd843783          	ld	a5,-40(s0)
ffffffe00020307c:	00178793          	addi	a5,a5,1
ffffffe000203080:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000203084:	f09ff06f          	j	ffffffe000202f8c <strtol+0x128>
            break;
ffffffe000203088:	00000013          	nop
    }

    if (endptr) {
ffffffe00020308c:	fc043783          	ld	a5,-64(s0)
ffffffe000203090:	00078863          	beqz	a5,ffffffe0002030a0 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000203094:	fc043783          	ld	a5,-64(s0)
ffffffe000203098:	fd843703          	ld	a4,-40(s0)
ffffffe00020309c:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe0002030a0:	fe744783          	lbu	a5,-25(s0)
ffffffe0002030a4:	0ff7f793          	zext.b	a5,a5
ffffffe0002030a8:	00078863          	beqz	a5,ffffffe0002030b8 <strtol+0x254>
ffffffe0002030ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002030b0:	40f007b3          	neg	a5,a5
ffffffe0002030b4:	0080006f          	j	ffffffe0002030bc <strtol+0x258>
ffffffe0002030b8:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002030bc:	00078513          	mv	a0,a5
ffffffe0002030c0:	04813083          	ld	ra,72(sp)
ffffffe0002030c4:	04013403          	ld	s0,64(sp)
ffffffe0002030c8:	05010113          	addi	sp,sp,80
ffffffe0002030cc:	00008067          	ret

ffffffe0002030d0 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe0002030d0:	fd010113          	addi	sp,sp,-48
ffffffe0002030d4:	02113423          	sd	ra,40(sp)
ffffffe0002030d8:	02813023          	sd	s0,32(sp)
ffffffe0002030dc:	03010413          	addi	s0,sp,48
ffffffe0002030e0:	fca43c23          	sd	a0,-40(s0)
ffffffe0002030e4:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe0002030e8:	fd043783          	ld	a5,-48(s0)
ffffffe0002030ec:	00079863          	bnez	a5,ffffffe0002030fc <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002030f0:	00001797          	auipc	a5,0x1
ffffffe0002030f4:	6a878793          	addi	a5,a5,1704 # ffffffe000204798 <__func__.0+0x350>
ffffffe0002030f8:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002030fc:	fd043783          	ld	a5,-48(s0)
ffffffe000203100:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe000203104:	0240006f          	j	ffffffe000203128 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe000203108:	fe843783          	ld	a5,-24(s0)
ffffffe00020310c:	00178713          	addi	a4,a5,1
ffffffe000203110:	fee43423          	sd	a4,-24(s0)
ffffffe000203114:	0007c783          	lbu	a5,0(a5)
ffffffe000203118:	0007871b          	sext.w	a4,a5
ffffffe00020311c:	fd843783          	ld	a5,-40(s0)
ffffffe000203120:	00070513          	mv	a0,a4
ffffffe000203124:	000780e7          	jalr	a5
    while (*p) {
ffffffe000203128:	fe843783          	ld	a5,-24(s0)
ffffffe00020312c:	0007c783          	lbu	a5,0(a5)
ffffffe000203130:	fc079ce3          	bnez	a5,ffffffe000203108 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000203134:	fe843703          	ld	a4,-24(s0)
ffffffe000203138:	fd043783          	ld	a5,-48(s0)
ffffffe00020313c:	40f707b3          	sub	a5,a4,a5
ffffffe000203140:	0007879b          	sext.w	a5,a5
}
ffffffe000203144:	00078513          	mv	a0,a5
ffffffe000203148:	02813083          	ld	ra,40(sp)
ffffffe00020314c:	02013403          	ld	s0,32(sp)
ffffffe000203150:	03010113          	addi	sp,sp,48
ffffffe000203154:	00008067          	ret

ffffffe000203158 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000203158:	f9010113          	addi	sp,sp,-112
ffffffe00020315c:	06113423          	sd	ra,104(sp)
ffffffe000203160:	06813023          	sd	s0,96(sp)
ffffffe000203164:	07010413          	addi	s0,sp,112
ffffffe000203168:	faa43423          	sd	a0,-88(s0)
ffffffe00020316c:	fab43023          	sd	a1,-96(s0)
ffffffe000203170:	00060793          	mv	a5,a2
ffffffe000203174:	f8d43823          	sd	a3,-112(s0)
ffffffe000203178:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe00020317c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000203180:	0ff7f793          	zext.b	a5,a5
ffffffe000203184:	02078663          	beqz	a5,ffffffe0002031b0 <print_dec_int+0x58>
ffffffe000203188:	fa043703          	ld	a4,-96(s0)
ffffffe00020318c:	fff00793          	li	a5,-1
ffffffe000203190:	03f79793          	slli	a5,a5,0x3f
ffffffe000203194:	00f71e63          	bne	a4,a5,ffffffe0002031b0 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000203198:	00001597          	auipc	a1,0x1
ffffffe00020319c:	60858593          	addi	a1,a1,1544 # ffffffe0002047a0 <__func__.0+0x358>
ffffffe0002031a0:	fa843503          	ld	a0,-88(s0)
ffffffe0002031a4:	f2dff0ef          	jal	ra,ffffffe0002030d0 <puts_wo_nl>
ffffffe0002031a8:	00050793          	mv	a5,a0
ffffffe0002031ac:	2a00006f          	j	ffffffe00020344c <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe0002031b0:	f9043783          	ld	a5,-112(s0)
ffffffe0002031b4:	00c7a783          	lw	a5,12(a5)
ffffffe0002031b8:	00079a63          	bnez	a5,ffffffe0002031cc <print_dec_int+0x74>
ffffffe0002031bc:	fa043783          	ld	a5,-96(s0)
ffffffe0002031c0:	00079663          	bnez	a5,ffffffe0002031cc <print_dec_int+0x74>
        return 0;
ffffffe0002031c4:	00000793          	li	a5,0
ffffffe0002031c8:	2840006f          	j	ffffffe00020344c <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe0002031cc:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe0002031d0:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002031d4:	0ff7f793          	zext.b	a5,a5
ffffffe0002031d8:	02078063          	beqz	a5,ffffffe0002031f8 <print_dec_int+0xa0>
ffffffe0002031dc:	fa043783          	ld	a5,-96(s0)
ffffffe0002031e0:	0007dc63          	bgez	a5,ffffffe0002031f8 <print_dec_int+0xa0>
        neg = true;
ffffffe0002031e4:	00100793          	li	a5,1
ffffffe0002031e8:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe0002031ec:	fa043783          	ld	a5,-96(s0)
ffffffe0002031f0:	40f007b3          	neg	a5,a5
ffffffe0002031f4:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe0002031f8:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe0002031fc:	f9f44783          	lbu	a5,-97(s0)
ffffffe000203200:	0ff7f793          	zext.b	a5,a5
ffffffe000203204:	02078863          	beqz	a5,ffffffe000203234 <print_dec_int+0xdc>
ffffffe000203208:	fef44783          	lbu	a5,-17(s0)
ffffffe00020320c:	0ff7f793          	zext.b	a5,a5
ffffffe000203210:	00079e63          	bnez	a5,ffffffe00020322c <print_dec_int+0xd4>
ffffffe000203214:	f9043783          	ld	a5,-112(s0)
ffffffe000203218:	0057c783          	lbu	a5,5(a5)
ffffffe00020321c:	00079863          	bnez	a5,ffffffe00020322c <print_dec_int+0xd4>
ffffffe000203220:	f9043783          	ld	a5,-112(s0)
ffffffe000203224:	0047c783          	lbu	a5,4(a5)
ffffffe000203228:	00078663          	beqz	a5,ffffffe000203234 <print_dec_int+0xdc>
ffffffe00020322c:	00100793          	li	a5,1
ffffffe000203230:	0080006f          	j	ffffffe000203238 <print_dec_int+0xe0>
ffffffe000203234:	00000793          	li	a5,0
ffffffe000203238:	fcf40ba3          	sb	a5,-41(s0)
ffffffe00020323c:	fd744783          	lbu	a5,-41(s0)
ffffffe000203240:	0017f793          	andi	a5,a5,1
ffffffe000203244:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000203248:	fa043703          	ld	a4,-96(s0)
ffffffe00020324c:	00a00793          	li	a5,10
ffffffe000203250:	02f777b3          	remu	a5,a4,a5
ffffffe000203254:	0ff7f713          	zext.b	a4,a5
ffffffe000203258:	fe842783          	lw	a5,-24(s0)
ffffffe00020325c:	0017869b          	addiw	a3,a5,1
ffffffe000203260:	fed42423          	sw	a3,-24(s0)
ffffffe000203264:	0307071b          	addiw	a4,a4,48
ffffffe000203268:	0ff77713          	zext.b	a4,a4
ffffffe00020326c:	ff078793          	addi	a5,a5,-16
ffffffe000203270:	008787b3          	add	a5,a5,s0
ffffffe000203274:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000203278:	fa043703          	ld	a4,-96(s0)
ffffffe00020327c:	00a00793          	li	a5,10
ffffffe000203280:	02f757b3          	divu	a5,a4,a5
ffffffe000203284:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000203288:	fa043783          	ld	a5,-96(s0)
ffffffe00020328c:	fa079ee3          	bnez	a5,ffffffe000203248 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000203290:	f9043783          	ld	a5,-112(s0)
ffffffe000203294:	00c7a783          	lw	a5,12(a5)
ffffffe000203298:	00078713          	mv	a4,a5
ffffffe00020329c:	fff00793          	li	a5,-1
ffffffe0002032a0:	02f71063          	bne	a4,a5,ffffffe0002032c0 <print_dec_int+0x168>
ffffffe0002032a4:	f9043783          	ld	a5,-112(s0)
ffffffe0002032a8:	0037c783          	lbu	a5,3(a5)
ffffffe0002032ac:	00078a63          	beqz	a5,ffffffe0002032c0 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe0002032b0:	f9043783          	ld	a5,-112(s0)
ffffffe0002032b4:	0087a703          	lw	a4,8(a5)
ffffffe0002032b8:	f9043783          	ld	a5,-112(s0)
ffffffe0002032bc:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe0002032c0:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002032c4:	f9043783          	ld	a5,-112(s0)
ffffffe0002032c8:	0087a703          	lw	a4,8(a5)
ffffffe0002032cc:	fe842783          	lw	a5,-24(s0)
ffffffe0002032d0:	fcf42823          	sw	a5,-48(s0)
ffffffe0002032d4:	f9043783          	ld	a5,-112(s0)
ffffffe0002032d8:	00c7a783          	lw	a5,12(a5)
ffffffe0002032dc:	fcf42623          	sw	a5,-52(s0)
ffffffe0002032e0:	fd042783          	lw	a5,-48(s0)
ffffffe0002032e4:	00078593          	mv	a1,a5
ffffffe0002032e8:	fcc42783          	lw	a5,-52(s0)
ffffffe0002032ec:	00078613          	mv	a2,a5
ffffffe0002032f0:	0006069b          	sext.w	a3,a2
ffffffe0002032f4:	0005879b          	sext.w	a5,a1
ffffffe0002032f8:	00f6d463          	bge	a3,a5,ffffffe000203300 <print_dec_int+0x1a8>
ffffffe0002032fc:	00058613          	mv	a2,a1
ffffffe000203300:	0006079b          	sext.w	a5,a2
ffffffe000203304:	40f707bb          	subw	a5,a4,a5
ffffffe000203308:	0007871b          	sext.w	a4,a5
ffffffe00020330c:	fd744783          	lbu	a5,-41(s0)
ffffffe000203310:	0007879b          	sext.w	a5,a5
ffffffe000203314:	40f707bb          	subw	a5,a4,a5
ffffffe000203318:	fef42023          	sw	a5,-32(s0)
ffffffe00020331c:	0280006f          	j	ffffffe000203344 <print_dec_int+0x1ec>
        putch(' ');
ffffffe000203320:	fa843783          	ld	a5,-88(s0)
ffffffe000203324:	02000513          	li	a0,32
ffffffe000203328:	000780e7          	jalr	a5
        ++written;
ffffffe00020332c:	fe442783          	lw	a5,-28(s0)
ffffffe000203330:	0017879b          	addiw	a5,a5,1
ffffffe000203334:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000203338:	fe042783          	lw	a5,-32(s0)
ffffffe00020333c:	fff7879b          	addiw	a5,a5,-1
ffffffe000203340:	fef42023          	sw	a5,-32(s0)
ffffffe000203344:	fe042783          	lw	a5,-32(s0)
ffffffe000203348:	0007879b          	sext.w	a5,a5
ffffffe00020334c:	fcf04ae3          	bgtz	a5,ffffffe000203320 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000203350:	fd744783          	lbu	a5,-41(s0)
ffffffe000203354:	0ff7f793          	zext.b	a5,a5
ffffffe000203358:	04078463          	beqz	a5,ffffffe0002033a0 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe00020335c:	fef44783          	lbu	a5,-17(s0)
ffffffe000203360:	0ff7f793          	zext.b	a5,a5
ffffffe000203364:	00078663          	beqz	a5,ffffffe000203370 <print_dec_int+0x218>
ffffffe000203368:	02d00793          	li	a5,45
ffffffe00020336c:	01c0006f          	j	ffffffe000203388 <print_dec_int+0x230>
ffffffe000203370:	f9043783          	ld	a5,-112(s0)
ffffffe000203374:	0057c783          	lbu	a5,5(a5)
ffffffe000203378:	00078663          	beqz	a5,ffffffe000203384 <print_dec_int+0x22c>
ffffffe00020337c:	02b00793          	li	a5,43
ffffffe000203380:	0080006f          	j	ffffffe000203388 <print_dec_int+0x230>
ffffffe000203384:	02000793          	li	a5,32
ffffffe000203388:	fa843703          	ld	a4,-88(s0)
ffffffe00020338c:	00078513          	mv	a0,a5
ffffffe000203390:	000700e7          	jalr	a4
        ++written;
ffffffe000203394:	fe442783          	lw	a5,-28(s0)
ffffffe000203398:	0017879b          	addiw	a5,a5,1
ffffffe00020339c:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002033a0:	fe842783          	lw	a5,-24(s0)
ffffffe0002033a4:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002033a8:	0280006f          	j	ffffffe0002033d0 <print_dec_int+0x278>
        putch('0');
ffffffe0002033ac:	fa843783          	ld	a5,-88(s0)
ffffffe0002033b0:	03000513          	li	a0,48
ffffffe0002033b4:	000780e7          	jalr	a5
        ++written;
ffffffe0002033b8:	fe442783          	lw	a5,-28(s0)
ffffffe0002033bc:	0017879b          	addiw	a5,a5,1
ffffffe0002033c0:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002033c4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002033c8:	0017879b          	addiw	a5,a5,1
ffffffe0002033cc:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002033d0:	f9043783          	ld	a5,-112(s0)
ffffffe0002033d4:	00c7a703          	lw	a4,12(a5)
ffffffe0002033d8:	fd744783          	lbu	a5,-41(s0)
ffffffe0002033dc:	0007879b          	sext.w	a5,a5
ffffffe0002033e0:	40f707bb          	subw	a5,a4,a5
ffffffe0002033e4:	0007871b          	sext.w	a4,a5
ffffffe0002033e8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002033ec:	0007879b          	sext.w	a5,a5
ffffffe0002033f0:	fae7cee3          	blt	a5,a4,ffffffe0002033ac <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002033f4:	fe842783          	lw	a5,-24(s0)
ffffffe0002033f8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002033fc:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203400:	03c0006f          	j	ffffffe00020343c <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe000203404:	fd842783          	lw	a5,-40(s0)
ffffffe000203408:	ff078793          	addi	a5,a5,-16
ffffffe00020340c:	008787b3          	add	a5,a5,s0
ffffffe000203410:	fc87c783          	lbu	a5,-56(a5)
ffffffe000203414:	0007871b          	sext.w	a4,a5
ffffffe000203418:	fa843783          	ld	a5,-88(s0)
ffffffe00020341c:	00070513          	mv	a0,a4
ffffffe000203420:	000780e7          	jalr	a5
        ++written;
ffffffe000203424:	fe442783          	lw	a5,-28(s0)
ffffffe000203428:	0017879b          	addiw	a5,a5,1
ffffffe00020342c:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000203430:	fd842783          	lw	a5,-40(s0)
ffffffe000203434:	fff7879b          	addiw	a5,a5,-1
ffffffe000203438:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020343c:	fd842783          	lw	a5,-40(s0)
ffffffe000203440:	0007879b          	sext.w	a5,a5
ffffffe000203444:	fc07d0e3          	bgez	a5,ffffffe000203404 <print_dec_int+0x2ac>
    }

    return written;
ffffffe000203448:	fe442783          	lw	a5,-28(s0)
}
ffffffe00020344c:	00078513          	mv	a0,a5
ffffffe000203450:	06813083          	ld	ra,104(sp)
ffffffe000203454:	06013403          	ld	s0,96(sp)
ffffffe000203458:	07010113          	addi	sp,sp,112
ffffffe00020345c:	00008067          	ret

ffffffe000203460 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000203460:	f4010113          	addi	sp,sp,-192
ffffffe000203464:	0a113c23          	sd	ra,184(sp)
ffffffe000203468:	0a813823          	sd	s0,176(sp)
ffffffe00020346c:	0c010413          	addi	s0,sp,192
ffffffe000203470:	f4a43c23          	sd	a0,-168(s0)
ffffffe000203474:	f4b43823          	sd	a1,-176(s0)
ffffffe000203478:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe00020347c:	f8043023          	sd	zero,-128(s0)
ffffffe000203480:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000203484:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000203488:	7a40006f          	j	ffffffe000203c2c <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe00020348c:	f8044783          	lbu	a5,-128(s0)
ffffffe000203490:	72078e63          	beqz	a5,ffffffe000203bcc <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000203494:	f5043783          	ld	a5,-176(s0)
ffffffe000203498:	0007c783          	lbu	a5,0(a5)
ffffffe00020349c:	00078713          	mv	a4,a5
ffffffe0002034a0:	02300793          	li	a5,35
ffffffe0002034a4:	00f71863          	bne	a4,a5,ffffffe0002034b4 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe0002034a8:	00100793          	li	a5,1
ffffffe0002034ac:	f8f40123          	sb	a5,-126(s0)
ffffffe0002034b0:	7700006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe0002034b4:	f5043783          	ld	a5,-176(s0)
ffffffe0002034b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002034bc:	00078713          	mv	a4,a5
ffffffe0002034c0:	03000793          	li	a5,48
ffffffe0002034c4:	00f71863          	bne	a4,a5,ffffffe0002034d4 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe0002034c8:	00100793          	li	a5,1
ffffffe0002034cc:	f8f401a3          	sb	a5,-125(s0)
ffffffe0002034d0:	7500006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe0002034d4:	f5043783          	ld	a5,-176(s0)
ffffffe0002034d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002034dc:	00078713          	mv	a4,a5
ffffffe0002034e0:	06c00793          	li	a5,108
ffffffe0002034e4:	04f70063          	beq	a4,a5,ffffffe000203524 <vprintfmt+0xc4>
ffffffe0002034e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002034ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002034f0:	00078713          	mv	a4,a5
ffffffe0002034f4:	07a00793          	li	a5,122
ffffffe0002034f8:	02f70663          	beq	a4,a5,ffffffe000203524 <vprintfmt+0xc4>
ffffffe0002034fc:	f5043783          	ld	a5,-176(s0)
ffffffe000203500:	0007c783          	lbu	a5,0(a5)
ffffffe000203504:	00078713          	mv	a4,a5
ffffffe000203508:	07400793          	li	a5,116
ffffffe00020350c:	00f70c63          	beq	a4,a5,ffffffe000203524 <vprintfmt+0xc4>
ffffffe000203510:	f5043783          	ld	a5,-176(s0)
ffffffe000203514:	0007c783          	lbu	a5,0(a5)
ffffffe000203518:	00078713          	mv	a4,a5
ffffffe00020351c:	06a00793          	li	a5,106
ffffffe000203520:	00f71863          	bne	a4,a5,ffffffe000203530 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000203524:	00100793          	li	a5,1
ffffffe000203528:	f8f400a3          	sb	a5,-127(s0)
ffffffe00020352c:	6f40006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000203530:	f5043783          	ld	a5,-176(s0)
ffffffe000203534:	0007c783          	lbu	a5,0(a5)
ffffffe000203538:	00078713          	mv	a4,a5
ffffffe00020353c:	02b00793          	li	a5,43
ffffffe000203540:	00f71863          	bne	a4,a5,ffffffe000203550 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000203544:	00100793          	li	a5,1
ffffffe000203548:	f8f402a3          	sb	a5,-123(s0)
ffffffe00020354c:	6d40006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000203550:	f5043783          	ld	a5,-176(s0)
ffffffe000203554:	0007c783          	lbu	a5,0(a5)
ffffffe000203558:	00078713          	mv	a4,a5
ffffffe00020355c:	02000793          	li	a5,32
ffffffe000203560:	00f71863          	bne	a4,a5,ffffffe000203570 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000203564:	00100793          	li	a5,1
ffffffe000203568:	f8f40223          	sb	a5,-124(s0)
ffffffe00020356c:	6b40006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000203570:	f5043783          	ld	a5,-176(s0)
ffffffe000203574:	0007c783          	lbu	a5,0(a5)
ffffffe000203578:	00078713          	mv	a4,a5
ffffffe00020357c:	02a00793          	li	a5,42
ffffffe000203580:	00f71e63          	bne	a4,a5,ffffffe00020359c <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000203584:	f4843783          	ld	a5,-184(s0)
ffffffe000203588:	00878713          	addi	a4,a5,8
ffffffe00020358c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203590:	0007a783          	lw	a5,0(a5)
ffffffe000203594:	f8f42423          	sw	a5,-120(s0)
ffffffe000203598:	6880006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe00020359c:	f5043783          	ld	a5,-176(s0)
ffffffe0002035a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002035a4:	00078713          	mv	a4,a5
ffffffe0002035a8:	03000793          	li	a5,48
ffffffe0002035ac:	04e7f663          	bgeu	a5,a4,ffffffe0002035f8 <vprintfmt+0x198>
ffffffe0002035b0:	f5043783          	ld	a5,-176(s0)
ffffffe0002035b4:	0007c783          	lbu	a5,0(a5)
ffffffe0002035b8:	00078713          	mv	a4,a5
ffffffe0002035bc:	03900793          	li	a5,57
ffffffe0002035c0:	02e7ec63          	bltu	a5,a4,ffffffe0002035f8 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe0002035c4:	f5043783          	ld	a5,-176(s0)
ffffffe0002035c8:	f5040713          	addi	a4,s0,-176
ffffffe0002035cc:	00a00613          	li	a2,10
ffffffe0002035d0:	00070593          	mv	a1,a4
ffffffe0002035d4:	00078513          	mv	a0,a5
ffffffe0002035d8:	88dff0ef          	jal	ra,ffffffe000202e64 <strtol>
ffffffe0002035dc:	00050793          	mv	a5,a0
ffffffe0002035e0:	0007879b          	sext.w	a5,a5
ffffffe0002035e4:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe0002035e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002035ec:	fff78793          	addi	a5,a5,-1
ffffffe0002035f0:	f4f43823          	sd	a5,-176(s0)
ffffffe0002035f4:	62c0006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe0002035f8:	f5043783          	ld	a5,-176(s0)
ffffffe0002035fc:	0007c783          	lbu	a5,0(a5)
ffffffe000203600:	00078713          	mv	a4,a5
ffffffe000203604:	02e00793          	li	a5,46
ffffffe000203608:	06f71863          	bne	a4,a5,ffffffe000203678 <vprintfmt+0x218>
                fmt++;
ffffffe00020360c:	f5043783          	ld	a5,-176(s0)
ffffffe000203610:	00178793          	addi	a5,a5,1
ffffffe000203614:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000203618:	f5043783          	ld	a5,-176(s0)
ffffffe00020361c:	0007c783          	lbu	a5,0(a5)
ffffffe000203620:	00078713          	mv	a4,a5
ffffffe000203624:	02a00793          	li	a5,42
ffffffe000203628:	00f71e63          	bne	a4,a5,ffffffe000203644 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe00020362c:	f4843783          	ld	a5,-184(s0)
ffffffe000203630:	00878713          	addi	a4,a5,8
ffffffe000203634:	f4e43423          	sd	a4,-184(s0)
ffffffe000203638:	0007a783          	lw	a5,0(a5)
ffffffe00020363c:	f8f42623          	sw	a5,-116(s0)
ffffffe000203640:	5e00006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000203644:	f5043783          	ld	a5,-176(s0)
ffffffe000203648:	f5040713          	addi	a4,s0,-176
ffffffe00020364c:	00a00613          	li	a2,10
ffffffe000203650:	00070593          	mv	a1,a4
ffffffe000203654:	00078513          	mv	a0,a5
ffffffe000203658:	80dff0ef          	jal	ra,ffffffe000202e64 <strtol>
ffffffe00020365c:	00050793          	mv	a5,a0
ffffffe000203660:	0007879b          	sext.w	a5,a5
ffffffe000203664:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000203668:	f5043783          	ld	a5,-176(s0)
ffffffe00020366c:	fff78793          	addi	a5,a5,-1
ffffffe000203670:	f4f43823          	sd	a5,-176(s0)
ffffffe000203674:	5ac0006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000203678:	f5043783          	ld	a5,-176(s0)
ffffffe00020367c:	0007c783          	lbu	a5,0(a5)
ffffffe000203680:	00078713          	mv	a4,a5
ffffffe000203684:	07800793          	li	a5,120
ffffffe000203688:	02f70663          	beq	a4,a5,ffffffe0002036b4 <vprintfmt+0x254>
ffffffe00020368c:	f5043783          	ld	a5,-176(s0)
ffffffe000203690:	0007c783          	lbu	a5,0(a5)
ffffffe000203694:	00078713          	mv	a4,a5
ffffffe000203698:	05800793          	li	a5,88
ffffffe00020369c:	00f70c63          	beq	a4,a5,ffffffe0002036b4 <vprintfmt+0x254>
ffffffe0002036a0:	f5043783          	ld	a5,-176(s0)
ffffffe0002036a4:	0007c783          	lbu	a5,0(a5)
ffffffe0002036a8:	00078713          	mv	a4,a5
ffffffe0002036ac:	07000793          	li	a5,112
ffffffe0002036b0:	30f71263          	bne	a4,a5,ffffffe0002039b4 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe0002036b4:	f5043783          	ld	a5,-176(s0)
ffffffe0002036b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002036bc:	00078713          	mv	a4,a5
ffffffe0002036c0:	07000793          	li	a5,112
ffffffe0002036c4:	00f70663          	beq	a4,a5,ffffffe0002036d0 <vprintfmt+0x270>
ffffffe0002036c8:	f8144783          	lbu	a5,-127(s0)
ffffffe0002036cc:	00078663          	beqz	a5,ffffffe0002036d8 <vprintfmt+0x278>
ffffffe0002036d0:	00100793          	li	a5,1
ffffffe0002036d4:	0080006f          	j	ffffffe0002036dc <vprintfmt+0x27c>
ffffffe0002036d8:	00000793          	li	a5,0
ffffffe0002036dc:	faf403a3          	sb	a5,-89(s0)
ffffffe0002036e0:	fa744783          	lbu	a5,-89(s0)
ffffffe0002036e4:	0017f793          	andi	a5,a5,1
ffffffe0002036e8:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe0002036ec:	fa744783          	lbu	a5,-89(s0)
ffffffe0002036f0:	0ff7f793          	zext.b	a5,a5
ffffffe0002036f4:	00078c63          	beqz	a5,ffffffe00020370c <vprintfmt+0x2ac>
ffffffe0002036f8:	f4843783          	ld	a5,-184(s0)
ffffffe0002036fc:	00878713          	addi	a4,a5,8
ffffffe000203700:	f4e43423          	sd	a4,-184(s0)
ffffffe000203704:	0007b783          	ld	a5,0(a5)
ffffffe000203708:	01c0006f          	j	ffffffe000203724 <vprintfmt+0x2c4>
ffffffe00020370c:	f4843783          	ld	a5,-184(s0)
ffffffe000203710:	00878713          	addi	a4,a5,8
ffffffe000203714:	f4e43423          	sd	a4,-184(s0)
ffffffe000203718:	0007a783          	lw	a5,0(a5)
ffffffe00020371c:	02079793          	slli	a5,a5,0x20
ffffffe000203720:	0207d793          	srli	a5,a5,0x20
ffffffe000203724:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000203728:	f8c42783          	lw	a5,-116(s0)
ffffffe00020372c:	02079463          	bnez	a5,ffffffe000203754 <vprintfmt+0x2f4>
ffffffe000203730:	fe043783          	ld	a5,-32(s0)
ffffffe000203734:	02079063          	bnez	a5,ffffffe000203754 <vprintfmt+0x2f4>
ffffffe000203738:	f5043783          	ld	a5,-176(s0)
ffffffe00020373c:	0007c783          	lbu	a5,0(a5)
ffffffe000203740:	00078713          	mv	a4,a5
ffffffe000203744:	07000793          	li	a5,112
ffffffe000203748:	00f70663          	beq	a4,a5,ffffffe000203754 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe00020374c:	f8040023          	sb	zero,-128(s0)
ffffffe000203750:	4d00006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000203754:	f5043783          	ld	a5,-176(s0)
ffffffe000203758:	0007c783          	lbu	a5,0(a5)
ffffffe00020375c:	00078713          	mv	a4,a5
ffffffe000203760:	07000793          	li	a5,112
ffffffe000203764:	00f70a63          	beq	a4,a5,ffffffe000203778 <vprintfmt+0x318>
ffffffe000203768:	f8244783          	lbu	a5,-126(s0)
ffffffe00020376c:	00078a63          	beqz	a5,ffffffe000203780 <vprintfmt+0x320>
ffffffe000203770:	fe043783          	ld	a5,-32(s0)
ffffffe000203774:	00078663          	beqz	a5,ffffffe000203780 <vprintfmt+0x320>
ffffffe000203778:	00100793          	li	a5,1
ffffffe00020377c:	0080006f          	j	ffffffe000203784 <vprintfmt+0x324>
ffffffe000203780:	00000793          	li	a5,0
ffffffe000203784:	faf40323          	sb	a5,-90(s0)
ffffffe000203788:	fa644783          	lbu	a5,-90(s0)
ffffffe00020378c:	0017f793          	andi	a5,a5,1
ffffffe000203790:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000203794:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000203798:	f5043783          	ld	a5,-176(s0)
ffffffe00020379c:	0007c783          	lbu	a5,0(a5)
ffffffe0002037a0:	00078713          	mv	a4,a5
ffffffe0002037a4:	05800793          	li	a5,88
ffffffe0002037a8:	00f71863          	bne	a4,a5,ffffffe0002037b8 <vprintfmt+0x358>
ffffffe0002037ac:	00001797          	auipc	a5,0x1
ffffffe0002037b0:	00c78793          	addi	a5,a5,12 # ffffffe0002047b8 <upperxdigits.1>
ffffffe0002037b4:	00c0006f          	j	ffffffe0002037c0 <vprintfmt+0x360>
ffffffe0002037b8:	00001797          	auipc	a5,0x1
ffffffe0002037bc:	01878793          	addi	a5,a5,24 # ffffffe0002047d0 <lowerxdigits.0>
ffffffe0002037c0:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe0002037c4:	fe043783          	ld	a5,-32(s0)
ffffffe0002037c8:	00f7f793          	andi	a5,a5,15
ffffffe0002037cc:	f9843703          	ld	a4,-104(s0)
ffffffe0002037d0:	00f70733          	add	a4,a4,a5
ffffffe0002037d4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002037d8:	0017869b          	addiw	a3,a5,1
ffffffe0002037dc:	fcd42e23          	sw	a3,-36(s0)
ffffffe0002037e0:	00074703          	lbu	a4,0(a4)
ffffffe0002037e4:	ff078793          	addi	a5,a5,-16
ffffffe0002037e8:	008787b3          	add	a5,a5,s0
ffffffe0002037ec:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe0002037f0:	fe043783          	ld	a5,-32(s0)
ffffffe0002037f4:	0047d793          	srli	a5,a5,0x4
ffffffe0002037f8:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe0002037fc:	fe043783          	ld	a5,-32(s0)
ffffffe000203800:	fc0792e3          	bnez	a5,ffffffe0002037c4 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000203804:	f8c42783          	lw	a5,-116(s0)
ffffffe000203808:	00078713          	mv	a4,a5
ffffffe00020380c:	fff00793          	li	a5,-1
ffffffe000203810:	02f71663          	bne	a4,a5,ffffffe00020383c <vprintfmt+0x3dc>
ffffffe000203814:	f8344783          	lbu	a5,-125(s0)
ffffffe000203818:	02078263          	beqz	a5,ffffffe00020383c <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe00020381c:	f8842703          	lw	a4,-120(s0)
ffffffe000203820:	fa644783          	lbu	a5,-90(s0)
ffffffe000203824:	0007879b          	sext.w	a5,a5
ffffffe000203828:	0017979b          	slliw	a5,a5,0x1
ffffffe00020382c:	0007879b          	sext.w	a5,a5
ffffffe000203830:	40f707bb          	subw	a5,a4,a5
ffffffe000203834:	0007879b          	sext.w	a5,a5
ffffffe000203838:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe00020383c:	f8842703          	lw	a4,-120(s0)
ffffffe000203840:	fa644783          	lbu	a5,-90(s0)
ffffffe000203844:	0007879b          	sext.w	a5,a5
ffffffe000203848:	0017979b          	slliw	a5,a5,0x1
ffffffe00020384c:	0007879b          	sext.w	a5,a5
ffffffe000203850:	40f707bb          	subw	a5,a4,a5
ffffffe000203854:	0007871b          	sext.w	a4,a5
ffffffe000203858:	fdc42783          	lw	a5,-36(s0)
ffffffe00020385c:	f8f42a23          	sw	a5,-108(s0)
ffffffe000203860:	f8c42783          	lw	a5,-116(s0)
ffffffe000203864:	f8f42823          	sw	a5,-112(s0)
ffffffe000203868:	f9442783          	lw	a5,-108(s0)
ffffffe00020386c:	00078593          	mv	a1,a5
ffffffe000203870:	f9042783          	lw	a5,-112(s0)
ffffffe000203874:	00078613          	mv	a2,a5
ffffffe000203878:	0006069b          	sext.w	a3,a2
ffffffe00020387c:	0005879b          	sext.w	a5,a1
ffffffe000203880:	00f6d463          	bge	a3,a5,ffffffe000203888 <vprintfmt+0x428>
ffffffe000203884:	00058613          	mv	a2,a1
ffffffe000203888:	0006079b          	sext.w	a5,a2
ffffffe00020388c:	40f707bb          	subw	a5,a4,a5
ffffffe000203890:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203894:	0280006f          	j	ffffffe0002038bc <vprintfmt+0x45c>
                    putch(' ');
ffffffe000203898:	f5843783          	ld	a5,-168(s0)
ffffffe00020389c:	02000513          	li	a0,32
ffffffe0002038a0:	000780e7          	jalr	a5
                    ++written;
ffffffe0002038a4:	fec42783          	lw	a5,-20(s0)
ffffffe0002038a8:	0017879b          	addiw	a5,a5,1
ffffffe0002038ac:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe0002038b0:	fd842783          	lw	a5,-40(s0)
ffffffe0002038b4:	fff7879b          	addiw	a5,a5,-1
ffffffe0002038b8:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002038bc:	fd842783          	lw	a5,-40(s0)
ffffffe0002038c0:	0007879b          	sext.w	a5,a5
ffffffe0002038c4:	fcf04ae3          	bgtz	a5,ffffffe000203898 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe0002038c8:	fa644783          	lbu	a5,-90(s0)
ffffffe0002038cc:	0ff7f793          	zext.b	a5,a5
ffffffe0002038d0:	04078463          	beqz	a5,ffffffe000203918 <vprintfmt+0x4b8>
                    putch('0');
ffffffe0002038d4:	f5843783          	ld	a5,-168(s0)
ffffffe0002038d8:	03000513          	li	a0,48
ffffffe0002038dc:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe0002038e0:	f5043783          	ld	a5,-176(s0)
ffffffe0002038e4:	0007c783          	lbu	a5,0(a5)
ffffffe0002038e8:	00078713          	mv	a4,a5
ffffffe0002038ec:	05800793          	li	a5,88
ffffffe0002038f0:	00f71663          	bne	a4,a5,ffffffe0002038fc <vprintfmt+0x49c>
ffffffe0002038f4:	05800793          	li	a5,88
ffffffe0002038f8:	0080006f          	j	ffffffe000203900 <vprintfmt+0x4a0>
ffffffe0002038fc:	07800793          	li	a5,120
ffffffe000203900:	f5843703          	ld	a4,-168(s0)
ffffffe000203904:	00078513          	mv	a0,a5
ffffffe000203908:	000700e7          	jalr	a4
                    written += 2;
ffffffe00020390c:	fec42783          	lw	a5,-20(s0)
ffffffe000203910:	0027879b          	addiw	a5,a5,2
ffffffe000203914:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000203918:	fdc42783          	lw	a5,-36(s0)
ffffffe00020391c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203920:	0280006f          	j	ffffffe000203948 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000203924:	f5843783          	ld	a5,-168(s0)
ffffffe000203928:	03000513          	li	a0,48
ffffffe00020392c:	000780e7          	jalr	a5
                    ++written;
ffffffe000203930:	fec42783          	lw	a5,-20(s0)
ffffffe000203934:	0017879b          	addiw	a5,a5,1
ffffffe000203938:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe00020393c:	fd442783          	lw	a5,-44(s0)
ffffffe000203940:	0017879b          	addiw	a5,a5,1
ffffffe000203944:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203948:	f8c42703          	lw	a4,-116(s0)
ffffffe00020394c:	fd442783          	lw	a5,-44(s0)
ffffffe000203950:	0007879b          	sext.w	a5,a5
ffffffe000203954:	fce7c8e3          	blt	a5,a4,ffffffe000203924 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000203958:	fdc42783          	lw	a5,-36(s0)
ffffffe00020395c:	fff7879b          	addiw	a5,a5,-1
ffffffe000203960:	fcf42823          	sw	a5,-48(s0)
ffffffe000203964:	03c0006f          	j	ffffffe0002039a0 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000203968:	fd042783          	lw	a5,-48(s0)
ffffffe00020396c:	ff078793          	addi	a5,a5,-16
ffffffe000203970:	008787b3          	add	a5,a5,s0
ffffffe000203974:	f807c783          	lbu	a5,-128(a5)
ffffffe000203978:	0007871b          	sext.w	a4,a5
ffffffe00020397c:	f5843783          	ld	a5,-168(s0)
ffffffe000203980:	00070513          	mv	a0,a4
ffffffe000203984:	000780e7          	jalr	a5
                    ++written;
ffffffe000203988:	fec42783          	lw	a5,-20(s0)
ffffffe00020398c:	0017879b          	addiw	a5,a5,1
ffffffe000203990:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000203994:	fd042783          	lw	a5,-48(s0)
ffffffe000203998:	fff7879b          	addiw	a5,a5,-1
ffffffe00020399c:	fcf42823          	sw	a5,-48(s0)
ffffffe0002039a0:	fd042783          	lw	a5,-48(s0)
ffffffe0002039a4:	0007879b          	sext.w	a5,a5
ffffffe0002039a8:	fc07d0e3          	bgez	a5,ffffffe000203968 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe0002039ac:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe0002039b0:	2700006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe0002039b4:	f5043783          	ld	a5,-176(s0)
ffffffe0002039b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002039bc:	00078713          	mv	a4,a5
ffffffe0002039c0:	06400793          	li	a5,100
ffffffe0002039c4:	02f70663          	beq	a4,a5,ffffffe0002039f0 <vprintfmt+0x590>
ffffffe0002039c8:	f5043783          	ld	a5,-176(s0)
ffffffe0002039cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002039d0:	00078713          	mv	a4,a5
ffffffe0002039d4:	06900793          	li	a5,105
ffffffe0002039d8:	00f70c63          	beq	a4,a5,ffffffe0002039f0 <vprintfmt+0x590>
ffffffe0002039dc:	f5043783          	ld	a5,-176(s0)
ffffffe0002039e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002039e4:	00078713          	mv	a4,a5
ffffffe0002039e8:	07500793          	li	a5,117
ffffffe0002039ec:	08f71063          	bne	a4,a5,ffffffe000203a6c <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe0002039f0:	f8144783          	lbu	a5,-127(s0)
ffffffe0002039f4:	00078c63          	beqz	a5,ffffffe000203a0c <vprintfmt+0x5ac>
ffffffe0002039f8:	f4843783          	ld	a5,-184(s0)
ffffffe0002039fc:	00878713          	addi	a4,a5,8
ffffffe000203a00:	f4e43423          	sd	a4,-184(s0)
ffffffe000203a04:	0007b783          	ld	a5,0(a5)
ffffffe000203a08:	0140006f          	j	ffffffe000203a1c <vprintfmt+0x5bc>
ffffffe000203a0c:	f4843783          	ld	a5,-184(s0)
ffffffe000203a10:	00878713          	addi	a4,a5,8
ffffffe000203a14:	f4e43423          	sd	a4,-184(s0)
ffffffe000203a18:	0007a783          	lw	a5,0(a5)
ffffffe000203a1c:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000203a20:	fa843583          	ld	a1,-88(s0)
ffffffe000203a24:	f5043783          	ld	a5,-176(s0)
ffffffe000203a28:	0007c783          	lbu	a5,0(a5)
ffffffe000203a2c:	0007871b          	sext.w	a4,a5
ffffffe000203a30:	07500793          	li	a5,117
ffffffe000203a34:	40f707b3          	sub	a5,a4,a5
ffffffe000203a38:	00f037b3          	snez	a5,a5
ffffffe000203a3c:	0ff7f793          	zext.b	a5,a5
ffffffe000203a40:	f8040713          	addi	a4,s0,-128
ffffffe000203a44:	00070693          	mv	a3,a4
ffffffe000203a48:	00078613          	mv	a2,a5
ffffffe000203a4c:	f5843503          	ld	a0,-168(s0)
ffffffe000203a50:	f08ff0ef          	jal	ra,ffffffe000203158 <print_dec_int>
ffffffe000203a54:	00050793          	mv	a5,a0
ffffffe000203a58:	fec42703          	lw	a4,-20(s0)
ffffffe000203a5c:	00f707bb          	addw	a5,a4,a5
ffffffe000203a60:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203a64:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000203a68:	1b80006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000203a6c:	f5043783          	ld	a5,-176(s0)
ffffffe000203a70:	0007c783          	lbu	a5,0(a5)
ffffffe000203a74:	00078713          	mv	a4,a5
ffffffe000203a78:	06e00793          	li	a5,110
ffffffe000203a7c:	04f71c63          	bne	a4,a5,ffffffe000203ad4 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe000203a80:	f8144783          	lbu	a5,-127(s0)
ffffffe000203a84:	02078463          	beqz	a5,ffffffe000203aac <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000203a88:	f4843783          	ld	a5,-184(s0)
ffffffe000203a8c:	00878713          	addi	a4,a5,8
ffffffe000203a90:	f4e43423          	sd	a4,-184(s0)
ffffffe000203a94:	0007b783          	ld	a5,0(a5)
ffffffe000203a98:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000203a9c:	fec42703          	lw	a4,-20(s0)
ffffffe000203aa0:	fb043783          	ld	a5,-80(s0)
ffffffe000203aa4:	00e7b023          	sd	a4,0(a5)
ffffffe000203aa8:	0240006f          	j	ffffffe000203acc <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000203aac:	f4843783          	ld	a5,-184(s0)
ffffffe000203ab0:	00878713          	addi	a4,a5,8
ffffffe000203ab4:	f4e43423          	sd	a4,-184(s0)
ffffffe000203ab8:	0007b783          	ld	a5,0(a5)
ffffffe000203abc:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe000203ac0:	fb843783          	ld	a5,-72(s0)
ffffffe000203ac4:	fec42703          	lw	a4,-20(s0)
ffffffe000203ac8:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000203acc:	f8040023          	sb	zero,-128(s0)
ffffffe000203ad0:	1500006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe000203ad4:	f5043783          	ld	a5,-176(s0)
ffffffe000203ad8:	0007c783          	lbu	a5,0(a5)
ffffffe000203adc:	00078713          	mv	a4,a5
ffffffe000203ae0:	07300793          	li	a5,115
ffffffe000203ae4:	02f71e63          	bne	a4,a5,ffffffe000203b20 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000203ae8:	f4843783          	ld	a5,-184(s0)
ffffffe000203aec:	00878713          	addi	a4,a5,8
ffffffe000203af0:	f4e43423          	sd	a4,-184(s0)
ffffffe000203af4:	0007b783          	ld	a5,0(a5)
ffffffe000203af8:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000203afc:	fc043583          	ld	a1,-64(s0)
ffffffe000203b00:	f5843503          	ld	a0,-168(s0)
ffffffe000203b04:	dccff0ef          	jal	ra,ffffffe0002030d0 <puts_wo_nl>
ffffffe000203b08:	00050793          	mv	a5,a0
ffffffe000203b0c:	fec42703          	lw	a4,-20(s0)
ffffffe000203b10:	00f707bb          	addw	a5,a4,a5
ffffffe000203b14:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203b18:	f8040023          	sb	zero,-128(s0)
ffffffe000203b1c:	1040006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000203b20:	f5043783          	ld	a5,-176(s0)
ffffffe000203b24:	0007c783          	lbu	a5,0(a5)
ffffffe000203b28:	00078713          	mv	a4,a5
ffffffe000203b2c:	06300793          	li	a5,99
ffffffe000203b30:	02f71e63          	bne	a4,a5,ffffffe000203b6c <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000203b34:	f4843783          	ld	a5,-184(s0)
ffffffe000203b38:	00878713          	addi	a4,a5,8
ffffffe000203b3c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203b40:	0007a783          	lw	a5,0(a5)
ffffffe000203b44:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000203b48:	fcc42703          	lw	a4,-52(s0)
ffffffe000203b4c:	f5843783          	ld	a5,-168(s0)
ffffffe000203b50:	00070513          	mv	a0,a4
ffffffe000203b54:	000780e7          	jalr	a5
                ++written;
ffffffe000203b58:	fec42783          	lw	a5,-20(s0)
ffffffe000203b5c:	0017879b          	addiw	a5,a5,1
ffffffe000203b60:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203b64:	f8040023          	sb	zero,-128(s0)
ffffffe000203b68:	0b80006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000203b6c:	f5043783          	ld	a5,-176(s0)
ffffffe000203b70:	0007c783          	lbu	a5,0(a5)
ffffffe000203b74:	00078713          	mv	a4,a5
ffffffe000203b78:	02500793          	li	a5,37
ffffffe000203b7c:	02f71263          	bne	a4,a5,ffffffe000203ba0 <vprintfmt+0x740>
                putch('%');
ffffffe000203b80:	f5843783          	ld	a5,-168(s0)
ffffffe000203b84:	02500513          	li	a0,37
ffffffe000203b88:	000780e7          	jalr	a5
                ++written;
ffffffe000203b8c:	fec42783          	lw	a5,-20(s0)
ffffffe000203b90:	0017879b          	addiw	a5,a5,1
ffffffe000203b94:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203b98:	f8040023          	sb	zero,-128(s0)
ffffffe000203b9c:	0840006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe000203ba0:	f5043783          	ld	a5,-176(s0)
ffffffe000203ba4:	0007c783          	lbu	a5,0(a5)
ffffffe000203ba8:	0007871b          	sext.w	a4,a5
ffffffe000203bac:	f5843783          	ld	a5,-168(s0)
ffffffe000203bb0:	00070513          	mv	a0,a4
ffffffe000203bb4:	000780e7          	jalr	a5
                ++written;
ffffffe000203bb8:	fec42783          	lw	a5,-20(s0)
ffffffe000203bbc:	0017879b          	addiw	a5,a5,1
ffffffe000203bc0:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203bc4:	f8040023          	sb	zero,-128(s0)
ffffffe000203bc8:	0580006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe000203bcc:	f5043783          	ld	a5,-176(s0)
ffffffe000203bd0:	0007c783          	lbu	a5,0(a5)
ffffffe000203bd4:	00078713          	mv	a4,a5
ffffffe000203bd8:	02500793          	li	a5,37
ffffffe000203bdc:	02f71063          	bne	a4,a5,ffffffe000203bfc <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe000203be0:	f8043023          	sd	zero,-128(s0)
ffffffe000203be4:	f8043423          	sd	zero,-120(s0)
ffffffe000203be8:	00100793          	li	a5,1
ffffffe000203bec:	f8f40023          	sb	a5,-128(s0)
ffffffe000203bf0:	fff00793          	li	a5,-1
ffffffe000203bf4:	f8f42623          	sw	a5,-116(s0)
ffffffe000203bf8:	0280006f          	j	ffffffe000203c20 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe000203bfc:	f5043783          	ld	a5,-176(s0)
ffffffe000203c00:	0007c783          	lbu	a5,0(a5)
ffffffe000203c04:	0007871b          	sext.w	a4,a5
ffffffe000203c08:	f5843783          	ld	a5,-168(s0)
ffffffe000203c0c:	00070513          	mv	a0,a4
ffffffe000203c10:	000780e7          	jalr	a5
            ++written;
ffffffe000203c14:	fec42783          	lw	a5,-20(s0)
ffffffe000203c18:	0017879b          	addiw	a5,a5,1
ffffffe000203c1c:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000203c20:	f5043783          	ld	a5,-176(s0)
ffffffe000203c24:	00178793          	addi	a5,a5,1
ffffffe000203c28:	f4f43823          	sd	a5,-176(s0)
ffffffe000203c2c:	f5043783          	ld	a5,-176(s0)
ffffffe000203c30:	0007c783          	lbu	a5,0(a5)
ffffffe000203c34:	84079ce3          	bnez	a5,ffffffe00020348c <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000203c38:	fec42783          	lw	a5,-20(s0)
}
ffffffe000203c3c:	00078513          	mv	a0,a5
ffffffe000203c40:	0b813083          	ld	ra,184(sp)
ffffffe000203c44:	0b013403          	ld	s0,176(sp)
ffffffe000203c48:	0c010113          	addi	sp,sp,192
ffffffe000203c4c:	00008067          	ret

ffffffe000203c50 <printk>:

int printk(const char* s, ...) {
ffffffe000203c50:	f9010113          	addi	sp,sp,-112
ffffffe000203c54:	02113423          	sd	ra,40(sp)
ffffffe000203c58:	02813023          	sd	s0,32(sp)
ffffffe000203c5c:	03010413          	addi	s0,sp,48
ffffffe000203c60:	fca43c23          	sd	a0,-40(s0)
ffffffe000203c64:	00b43423          	sd	a1,8(s0)
ffffffe000203c68:	00c43823          	sd	a2,16(s0)
ffffffe000203c6c:	00d43c23          	sd	a3,24(s0)
ffffffe000203c70:	02e43023          	sd	a4,32(s0)
ffffffe000203c74:	02f43423          	sd	a5,40(s0)
ffffffe000203c78:	03043823          	sd	a6,48(s0)
ffffffe000203c7c:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000203c80:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000203c84:	04040793          	addi	a5,s0,64
ffffffe000203c88:	fcf43823          	sd	a5,-48(s0)
ffffffe000203c8c:	fd043783          	ld	a5,-48(s0)
ffffffe000203c90:	fc878793          	addi	a5,a5,-56
ffffffe000203c94:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000203c98:	fe043783          	ld	a5,-32(s0)
ffffffe000203c9c:	00078613          	mv	a2,a5
ffffffe000203ca0:	fd843583          	ld	a1,-40(s0)
ffffffe000203ca4:	fffff517          	auipc	a0,0xfffff
ffffffe000203ca8:	11850513          	addi	a0,a0,280 # ffffffe000202dbc <putc>
ffffffe000203cac:	fb4ff0ef          	jal	ra,ffffffe000203460 <vprintfmt>
ffffffe000203cb0:	00050793          	mv	a5,a0
ffffffe000203cb4:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000203cb8:	fec42783          	lw	a5,-20(s0)
}
ffffffe000203cbc:	00078513          	mv	a0,a5
ffffffe000203cc0:	02813083          	ld	ra,40(sp)
ffffffe000203cc4:	02013403          	ld	s0,32(sp)
ffffffe000203cc8:	07010113          	addi	sp,sp,112
ffffffe000203ccc:	00008067          	ret

ffffffe000203cd0 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe000203cd0:	fe010113          	addi	sp,sp,-32
ffffffe000203cd4:	00813c23          	sd	s0,24(sp)
ffffffe000203cd8:	02010413          	addi	s0,sp,32
ffffffe000203cdc:	00050793          	mv	a5,a0
ffffffe000203ce0:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe000203ce4:	fec42783          	lw	a5,-20(s0)
ffffffe000203ce8:	fff7879b          	addiw	a5,a5,-1
ffffffe000203cec:	0007879b          	sext.w	a5,a5
ffffffe000203cf0:	02079713          	slli	a4,a5,0x20
ffffffe000203cf4:	02075713          	srli	a4,a4,0x20
ffffffe000203cf8:	00005797          	auipc	a5,0x5
ffffffe000203cfc:	32878793          	addi	a5,a5,808 # ffffffe000209020 <seed>
ffffffe000203d00:	00e7b023          	sd	a4,0(a5)
}
ffffffe000203d04:	00000013          	nop
ffffffe000203d08:	01813403          	ld	s0,24(sp)
ffffffe000203d0c:	02010113          	addi	sp,sp,32
ffffffe000203d10:	00008067          	ret

ffffffe000203d14 <rand>:

int rand(void) {
ffffffe000203d14:	ff010113          	addi	sp,sp,-16
ffffffe000203d18:	00813423          	sd	s0,8(sp)
ffffffe000203d1c:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000203d20:	00005797          	auipc	a5,0x5
ffffffe000203d24:	30078793          	addi	a5,a5,768 # ffffffe000209020 <seed>
ffffffe000203d28:	0007b703          	ld	a4,0(a5)
ffffffe000203d2c:	00001797          	auipc	a5,0x1
ffffffe000203d30:	abc78793          	addi	a5,a5,-1348 # ffffffe0002047e8 <lowerxdigits.0+0x18>
ffffffe000203d34:	0007b783          	ld	a5,0(a5)
ffffffe000203d38:	02f707b3          	mul	a5,a4,a5
ffffffe000203d3c:	00178713          	addi	a4,a5,1
ffffffe000203d40:	00005797          	auipc	a5,0x5
ffffffe000203d44:	2e078793          	addi	a5,a5,736 # ffffffe000209020 <seed>
ffffffe000203d48:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000203d4c:	00005797          	auipc	a5,0x5
ffffffe000203d50:	2d478793          	addi	a5,a5,724 # ffffffe000209020 <seed>
ffffffe000203d54:	0007b783          	ld	a5,0(a5)
ffffffe000203d58:	0217d793          	srli	a5,a5,0x21
ffffffe000203d5c:	0007879b          	sext.w	a5,a5
}
ffffffe000203d60:	00078513          	mv	a0,a5
ffffffe000203d64:	00813403          	ld	s0,8(sp)
ffffffe000203d68:	01010113          	addi	sp,sp,16
ffffffe000203d6c:	00008067          	ret

ffffffe000203d70 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000203d70:	fc010113          	addi	sp,sp,-64
ffffffe000203d74:	02813c23          	sd	s0,56(sp)
ffffffe000203d78:	04010413          	addi	s0,sp,64
ffffffe000203d7c:	fca43c23          	sd	a0,-40(s0)
ffffffe000203d80:	00058793          	mv	a5,a1
ffffffe000203d84:	fcc43423          	sd	a2,-56(s0)
ffffffe000203d88:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000203d8c:	fd843783          	ld	a5,-40(s0)
ffffffe000203d90:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203d94:	fe043423          	sd	zero,-24(s0)
ffffffe000203d98:	0280006f          	j	ffffffe000203dc0 <memset+0x50>
        s[i] = c;
ffffffe000203d9c:	fe043703          	ld	a4,-32(s0)
ffffffe000203da0:	fe843783          	ld	a5,-24(s0)
ffffffe000203da4:	00f707b3          	add	a5,a4,a5
ffffffe000203da8:	fd442703          	lw	a4,-44(s0)
ffffffe000203dac:	0ff77713          	zext.b	a4,a4
ffffffe000203db0:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203db4:	fe843783          	ld	a5,-24(s0)
ffffffe000203db8:	00178793          	addi	a5,a5,1
ffffffe000203dbc:	fef43423          	sd	a5,-24(s0)
ffffffe000203dc0:	fe843703          	ld	a4,-24(s0)
ffffffe000203dc4:	fc843783          	ld	a5,-56(s0)
ffffffe000203dc8:	fcf76ae3          	bltu	a4,a5,ffffffe000203d9c <memset+0x2c>
    }
    return dest;
ffffffe000203dcc:	fd843783          	ld	a5,-40(s0)
}
ffffffe000203dd0:	00078513          	mv	a0,a5
ffffffe000203dd4:	03813403          	ld	s0,56(sp)
ffffffe000203dd8:	04010113          	addi	sp,sp,64
ffffffe000203ddc:	00008067          	ret

ffffffe000203de0 <memcpy>:

void *memcpy(void *dest, const void *src, uint64_t n) {
ffffffe000203de0:	fb010113          	addi	sp,sp,-80
ffffffe000203de4:	04813423          	sd	s0,72(sp)
ffffffe000203de8:	05010413          	addi	s0,sp,80
ffffffe000203dec:	fca43423          	sd	a0,-56(s0)
ffffffe000203df0:	fcb43023          	sd	a1,-64(s0)
ffffffe000203df4:	fac43c23          	sd	a2,-72(s0)
    char *d = (char *)dest;
ffffffe000203df8:	fc843783          	ld	a5,-56(s0)
ffffffe000203dfc:	fef43023          	sd	a5,-32(s0)
    const char *s = (const char *)src;
ffffffe000203e00:	fc043783          	ld	a5,-64(s0)
ffffffe000203e04:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203e08:	fe043423          	sd	zero,-24(s0)
ffffffe000203e0c:	0300006f          	j	ffffffe000203e3c <memcpy+0x5c>
        d[i] = s[i];
ffffffe000203e10:	fd843703          	ld	a4,-40(s0)
ffffffe000203e14:	fe843783          	ld	a5,-24(s0)
ffffffe000203e18:	00f70733          	add	a4,a4,a5
ffffffe000203e1c:	fe043683          	ld	a3,-32(s0)
ffffffe000203e20:	fe843783          	ld	a5,-24(s0)
ffffffe000203e24:	00f687b3          	add	a5,a3,a5
ffffffe000203e28:	00074703          	lbu	a4,0(a4)
ffffffe000203e2c:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203e30:	fe843783          	ld	a5,-24(s0)
ffffffe000203e34:	00178793          	addi	a5,a5,1
ffffffe000203e38:	fef43423          	sd	a5,-24(s0)
ffffffe000203e3c:	fe843703          	ld	a4,-24(s0)
ffffffe000203e40:	fb843783          	ld	a5,-72(s0)
ffffffe000203e44:	fcf766e3          	bltu	a4,a5,ffffffe000203e10 <memcpy+0x30>
    }
    return dest;
ffffffe000203e48:	fc843783          	ld	a5,-56(s0)
}
ffffffe000203e4c:	00078513          	mv	a0,a5
ffffffe000203e50:	04813403          	ld	s0,72(sp)
ffffffe000203e54:	05010113          	addi	sp,sp,80
ffffffe000203e58:	00008067          	ret
