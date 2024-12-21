
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
ffffffe000200008:	135010ef          	jal	ra,ffffffe00020193c <setup_vm>
    call relocate
ffffffe00020000c:	044000ef          	jal	ra,ffffffe000200050 <relocate>
    call mm_init
ffffffe000200010:	295000ef          	jal	ra,ffffffe000200aa4 <mm_init>
    call setup_vm_final
ffffffe000200014:	2f1010ef          	jal	ra,ffffffe000201b04 <setup_vm_final>
    call task_init
ffffffe000200018:	619000ef          	jal	ra,ffffffe000200e30 <task_init>

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
ffffffe00020004c:	705010ef          	jal	ra,ffffffe000201f50 <start_kernel>

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
ffffffe00020013c:	6b4010ef          	jal	ra,ffffffe0002017f0 <trap_handler>

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

    csrrw sp, sscratch, sp
ffffffe0002001d0:	14011173          	csrrw	sp,sscratch,sp
    bne sp, zero, 1f
ffffffe0002001d4:	00011463          	bnez	sp,ffffffe0002001dc <_traps+0x148>
    csrrw sp, sscratch, sp
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
ffffffe000200424:	c0078793          	addi	a5,a5,-1024 # ffffffe000209020 <buddy>
ffffffe000200428:	fe843703          	ld	a4,-24(s0)
ffffffe00020042c:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe000200430:	00005797          	auipc	a5,0x5
ffffffe000200434:	bd878793          	addi	a5,a5,-1064 # ffffffe000205008 <free_page_start>
ffffffe000200438:	0007b703          	ld	a4,0(a5)
ffffffe00020043c:	00009797          	auipc	a5,0x9
ffffffe000200440:	be478793          	addi	a5,a5,-1052 # ffffffe000209020 <buddy>
ffffffe000200444:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200448:	00005797          	auipc	a5,0x5
ffffffe00020044c:	bc078793          	addi	a5,a5,-1088 # ffffffe000205008 <free_page_start>
ffffffe000200450:	0007b703          	ld	a4,0(a5)
ffffffe000200454:	00009797          	auipc	a5,0x9
ffffffe000200458:	bcc78793          	addi	a5,a5,-1076 # ffffffe000209020 <buddy>
ffffffe00020045c:	0007b783          	ld	a5,0(a5)
ffffffe000200460:	00479793          	slli	a5,a5,0x4
ffffffe000200464:	00f70733          	add	a4,a4,a5
ffffffe000200468:	00005797          	auipc	a5,0x5
ffffffe00020046c:	ba078793          	addi	a5,a5,-1120 # ffffffe000205008 <free_page_start>
ffffffe000200470:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe000200474:	00009797          	auipc	a5,0x9
ffffffe000200478:	bac78793          	addi	a5,a5,-1108 # ffffffe000209020 <buddy>
ffffffe00020047c:	0087b703          	ld	a4,8(a5)
ffffffe000200480:	00009797          	auipc	a5,0x9
ffffffe000200484:	ba078793          	addi	a5,a5,-1120 # ffffffe000209020 <buddy>
ffffffe000200488:	0007b783          	ld	a5,0(a5)
ffffffe00020048c:	00479793          	slli	a5,a5,0x4
ffffffe000200490:	00078613          	mv	a2,a5
ffffffe000200494:	00000593          	li	a1,0
ffffffe000200498:	00070513          	mv	a0,a4
ffffffe00020049c:	585020ef          	jal	ra,ffffffe000203220 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe0002004a0:	00009797          	auipc	a5,0x9
ffffffe0002004a4:	b8078793          	addi	a5,a5,-1152 # ffffffe000209020 <buddy>
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
ffffffe0002004e0:	b4478793          	addi	a5,a5,-1212 # ffffffe000209020 <buddy>
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
ffffffe00020050c:	b1878793          	addi	a5,a5,-1256 # ffffffe000209020 <buddy>
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
ffffffe000200578:	a8c50513          	addi	a0,a0,-1396 # ffffffe000204000 <_srodata>
ffffffe00020057c:	385020ef          	jal	ra,ffffffe000203100 <printk>
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
ffffffe0002005b4:	a7078793          	addi	a5,a5,-1424 # ffffffe000209020 <buddy>
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
ffffffe0002005fc:	a2878793          	addi	a5,a5,-1496 # ffffffe000209020 <buddy>
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
ffffffe000200624:	a0078793          	addi	a5,a5,-1536 # ffffffe000209020 <buddy>
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
ffffffe000200668:	9bc78793          	addi	a5,a5,-1604 # ffffffe000209020 <buddy>
ffffffe00020066c:	0087b703          	ld	a4,8(a5)
ffffffe000200670:	fe043783          	ld	a5,-32(s0)
ffffffe000200674:	00479793          	slli	a5,a5,0x4
ffffffe000200678:	00878793          	addi	a5,a5,8
ffffffe00020067c:	00f707b3          	add	a5,a4,a5
ffffffe000200680:	0007b783          	ld	a5,0(a5)
ffffffe000200684:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe000200688:	00009797          	auipc	a5,0x9
ffffffe00020068c:	99878793          	addi	a5,a5,-1640 # ffffffe000209020 <buddy>
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
ffffffe0002006c4:	96078793          	addi	a5,a5,-1696 # ffffffe000209020 <buddy>
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
ffffffe0002006e8:	93c78793          	addi	a5,a5,-1732 # ffffffe000209020 <buddy>
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
ffffffe000200780:	8a478793          	addi	a5,a5,-1884 # ffffffe000209020 <buddy>
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
ffffffe0002007ac:	87878793          	addi	a5,a5,-1928 # ffffffe000209020 <buddy>
ffffffe0002007b0:	0007b783          	ld	a5,0(a5)
ffffffe0002007b4:	fef43023          	sd	a5,-32(s0)
ffffffe0002007b8:	05c0006f          	j	ffffffe000200814 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe0002007bc:	00009797          	auipc	a5,0x9
ffffffe0002007c0:	86478793          	addi	a5,a5,-1948 # ffffffe000209020 <buddy>
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
ffffffe000200824:	80078793          	addi	a5,a5,-2048 # ffffffe000209020 <buddy>
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
ffffffe000200850:	7d478793          	addi	a5,a5,2004 # ffffffe000209020 <buddy>
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
ffffffe00020087c:	7a878793          	addi	a5,a5,1960 # ffffffe000209020 <buddy>
ffffffe000200880:	0087b703          	ld	a4,8(a5)
ffffffe000200884:	fe843783          	ld	a5,-24(s0)
ffffffe000200888:	00178793          	addi	a5,a5,1
ffffffe00020088c:	00479793          	slli	a5,a5,0x4
ffffffe000200890:	00f707b3          	add	a5,a4,a5
ffffffe000200894:	0007b603          	ld	a2,0(a5)
ffffffe000200898:	00008797          	auipc	a5,0x8
ffffffe00020089c:	78878793          	addi	a5,a5,1928 # ffffffe000209020 <buddy>
ffffffe0002008a0:	0087b703          	ld	a4,8(a5)
ffffffe0002008a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008a8:	00479793          	slli	a5,a5,0x4
ffffffe0002008ac:	00878793          	addi	a5,a5,8
ffffffe0002008b0:	00f707b3          	add	a5,a4,a5
ffffffe0002008b4:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008b8:	00008797          	auipc	a5,0x8
ffffffe0002008bc:	76878793          	addi	a5,a5,1896 # ffffffe000209020 <buddy>
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
ffffffe000200abc:	56050513          	addi	a0,a0,1376 # ffffffe000204018 <_srodata+0x18>
ffffffe000200ac0:	640020ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe000200ac4:	00000013          	nop
ffffffe000200ac8:	00813083          	ld	ra,8(sp)
ffffffe000200acc:	00013403          	ld	s0,0(sp)
ffffffe000200ad0:	01010113          	addi	sp,sp,16
ffffffe000200ad4:	00008067          	ret

ffffffe000200ad8 <get_current_proc>:
extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];

struct task_struct *get_current_proc()
{
ffffffe000200ad8:	ff010113          	addi	sp,sp,-16
ffffffe000200adc:	00813423          	sd	s0,8(sp)
ffffffe000200ae0:	01010413          	addi	s0,sp,16
    return current;
ffffffe000200ae4:	00008797          	auipc	a5,0x8
ffffffe000200ae8:	52c78793          	addi	a5,a5,1324 # ffffffe000209010 <current>
ffffffe000200aec:	0007b783          	ld	a5,0(a5)
}
ffffffe000200af0:	00078513          	mv	a0,a5
ffffffe000200af4:	00813403          	ld	s0,8(sp)
ffffffe000200af8:	01010113          	addi	sp,sp,16
ffffffe000200afc:	00008067          	ret

ffffffe000200b00 <set_user_pgtbl>:

void set_user_pgtbl(struct task_struct *T)
{
ffffffe000200b00:	fb010113          	addi	sp,sp,-80
ffffffe000200b04:	04113423          	sd	ra,72(sp)
ffffffe000200b08:	04813023          	sd	s0,64(sp)
ffffffe000200b0c:	02913c23          	sd	s1,56(sp)
ffffffe000200b10:	05010413          	addi	s0,sp,80
ffffffe000200b14:	faa43c23          	sd	a0,-72(s0)
    T->pgd = (uint64_t *)alloc_page();
ffffffe000200b18:	e41ff0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe000200b1c:	00050713          	mv	a4,a0
ffffffe000200b20:	fb843783          	ld	a5,-72(s0)
ffffffe000200b24:	0ae7b423          	sd	a4,168(a5)
    memset(T->pgd, 0, PGSIZE);
ffffffe000200b28:	fb843783          	ld	a5,-72(s0)
ffffffe000200b2c:	0a87b783          	ld	a5,168(a5)
ffffffe000200b30:	00001637          	lui	a2,0x1
ffffffe000200b34:	00000593          	li	a1,0
ffffffe000200b38:	00078513          	mv	a0,a5
ffffffe000200b3c:	6e4020ef          	jal	ra,ffffffe000203220 <memset>
    memcpy(T->pgd, get_kernel_pgtbl(), PGSIZE);
ffffffe000200b40:	fb843783          	ld	a5,-72(s0)
ffffffe000200b44:	0a87b483          	ld	s1,168(a5)
ffffffe000200b48:	3e4010ef          	jal	ra,ffffffe000201f2c <get_kernel_pgtbl>
ffffffe000200b4c:	00050793          	mv	a5,a0
ffffffe000200b50:	00001637          	lui	a2,0x1
ffffffe000200b54:	00078593          	mv	a1,a5
ffffffe000200b58:	00048513          	mv	a0,s1
ffffffe000200b5c:	734020ef          	jal	ra,ffffffe000203290 <memcpy>

    printk("set_user_pgtbl: T->pgd = %p\n", T->pgd);
ffffffe000200b60:	fb843783          	ld	a5,-72(s0)
ffffffe000200b64:	0a87b783          	ld	a5,168(a5)
ffffffe000200b68:	00078593          	mv	a1,a5
ffffffe000200b6c:	00003517          	auipc	a0,0x3
ffffffe000200b70:	4c450513          	addi	a0,a0,1220 # ffffffe000204030 <_srodata+0x30>
ffffffe000200b74:	58c020ef          	jal	ra,ffffffe000203100 <printk>

    uint64_t user_perm = PTE_V | PTE_R | PTE_W | PTE_U;
ffffffe000200b78:	01700793          	li	a5,23
ffffffe000200b7c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t pa = VA2PA(alloc_page());
ffffffe000200b80:	dd9ff0ef          	jal	ra,ffffffe000200958 <alloc_page>
ffffffe000200b84:	00050793          	mv	a5,a0
ffffffe000200b88:	00078713          	mv	a4,a5
ffffffe000200b8c:	04100793          	li	a5,65
ffffffe000200b90:	01f79793          	slli	a5,a5,0x1f
ffffffe000200b94:	00f707b3          	add	a5,a4,a5
ffffffe000200b98:	fcf43823          	sd	a5,-48(s0)
    uint64_t va = USER_END - PGSIZE;
ffffffe000200b9c:	040007b7          	lui	a5,0x4000
ffffffe000200ba0:	fff78793          	addi	a5,a5,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000200ba4:	00c79793          	slli	a5,a5,0xc
ffffffe000200ba8:	fcf43423          	sd	a5,-56(s0)
    printk("set_user_pgtbl: va = %lx, pa = %lx\n", va, pa);
ffffffe000200bac:	fd043603          	ld	a2,-48(s0)
ffffffe000200bb0:	fc843583          	ld	a1,-56(s0)
ffffffe000200bb4:	00003517          	auipc	a0,0x3
ffffffe000200bb8:	49c50513          	addi	a0,a0,1180 # ffffffe000204050 <_srodata+0x50>
ffffffe000200bbc:	544020ef          	jal	ra,ffffffe000203100 <printk>
    create_mapping(T->pgd, va, pa, PGSIZE, user_perm);
ffffffe000200bc0:	fb843783          	ld	a5,-72(s0)
ffffffe000200bc4:	0a87b783          	ld	a5,168(a5)
ffffffe000200bc8:	fd843703          	ld	a4,-40(s0)
ffffffe000200bcc:	000016b7          	lui	a3,0x1
ffffffe000200bd0:	fd043603          	ld	a2,-48(s0)
ffffffe000200bd4:	fc843583          	ld	a1,-56(s0)
ffffffe000200bd8:	00078513          	mv	a0,a5
ffffffe000200bdc:	160010ef          	jal	ra,ffffffe000201d3c <create_mapping>
    printk("set_user_pgtbl done\n");
ffffffe000200be0:	00003517          	auipc	a0,0x3
ffffffe000200be4:	49850513          	addi	a0,a0,1176 # ffffffe000204078 <_srodata+0x78>
ffffffe000200be8:	518020ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe000200bec:	00000013          	nop
ffffffe000200bf0:	04813083          	ld	ra,72(sp)
ffffffe000200bf4:	04013403          	ld	s0,64(sp)
ffffffe000200bf8:	03813483          	ld	s1,56(sp)
ffffffe000200bfc:	05010113          	addi	sp,sp,80
ffffffe000200c00:	00008067          	ret

ffffffe000200c04 <load_program>:

void load_program(struct task_struct *task)
{
ffffffe000200c04:	fa010113          	addi	sp,sp,-96
ffffffe000200c08:	04113c23          	sd	ra,88(sp)
ffffffe000200c0c:	04813823          	sd	s0,80(sp)
ffffffe000200c10:	06010413          	addi	s0,sp,96
ffffffe000200c14:	faa43423          	sd	a0,-88(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200c18:	00005797          	auipc	a5,0x5
ffffffe000200c1c:	3e878793          	addi	a5,a5,1000 # ffffffe000206000 <_sramdisk>
ffffffe000200c20:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200c24:	fe043783          	ld	a5,-32(s0)
ffffffe000200c28:	0207b703          	ld	a4,32(a5)
ffffffe000200c2c:	00005797          	auipc	a5,0x5
ffffffe000200c30:	3d478793          	addi	a5,a5,980 # ffffffe000206000 <_sramdisk>
ffffffe000200c34:	00f707b3          	add	a5,a4,a5
ffffffe000200c38:	fcf43c23          	sd	a5,-40(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200c3c:	fe042623          	sw	zero,-20(s0)
ffffffe000200c40:	1b40006f          	j	ffffffe000200df4 <load_program+0x1f0>
    {
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200c44:	fec42703          	lw	a4,-20(s0)
ffffffe000200c48:	00070793          	mv	a5,a4
ffffffe000200c4c:	00379793          	slli	a5,a5,0x3
ffffffe000200c50:	40e787b3          	sub	a5,a5,a4
ffffffe000200c54:	00379793          	slli	a5,a5,0x3
ffffffe000200c58:	00078713          	mv	a4,a5
ffffffe000200c5c:	fd843783          	ld	a5,-40(s0)
ffffffe000200c60:	00e787b3          	add	a5,a5,a4
ffffffe000200c64:	fcf43823          	sd	a5,-48(s0)
        if (phdr->p_type == PT_LOAD)
ffffffe000200c68:	fd043783          	ld	a5,-48(s0)
ffffffe000200c6c:	0007a783          	lw	a5,0(a5)
ffffffe000200c70:	00078713          	mv	a4,a5
ffffffe000200c74:	00100793          	li	a5,1
ffffffe000200c78:	16f71863          	bne	a4,a5,ffffffe000200de8 <load_program+0x1e4>
        {
            // alloc space and copy content
            uint64_t align_offset = phdr->p_vaddr % PGSIZE;
ffffffe000200c7c:	fd043783          	ld	a5,-48(s0)
ffffffe000200c80:	0107b703          	ld	a4,16(a5)
ffffffe000200c84:	000017b7          	lui	a5,0x1
ffffffe000200c88:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200c8c:	00f777b3          	and	a5,a4,a5
ffffffe000200c90:	fcf43423          	sd	a5,-56(s0)
            uint64_t num_pg = (phdr->p_memsz + align_offset + PGSIZE - 1) / PGSIZE;
ffffffe000200c94:	fd043783          	ld	a5,-48(s0)
ffffffe000200c98:	0287b703          	ld	a4,40(a5)
ffffffe000200c9c:	fc843783          	ld	a5,-56(s0)
ffffffe000200ca0:	00f70733          	add	a4,a4,a5
ffffffe000200ca4:	000017b7          	lui	a5,0x1
ffffffe000200ca8:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200cac:	00f707b3          	add	a5,a4,a5
ffffffe000200cb0:	00c7d793          	srli	a5,a5,0xc
ffffffe000200cb4:	fcf43023          	sd	a5,-64(s0)
            uint64_t *new_pgs = (uint64_t *)alloc_pages(num_pg);
ffffffe000200cb8:	fc043503          	ld	a0,-64(s0)
ffffffe000200cbc:	c45ff0ef          	jal	ra,ffffffe000200900 <alloc_pages>
ffffffe000200cc0:	faa43c23          	sd	a0,-72(s0)
            memcpy((void *)((uint64_t)new_pgs + align_offset), _sramdisk + phdr->p_offset, phdr->p_filesz);
ffffffe000200cc4:	fb843703          	ld	a4,-72(s0)
ffffffe000200cc8:	fc843783          	ld	a5,-56(s0)
ffffffe000200ccc:	00f707b3          	add	a5,a4,a5
ffffffe000200cd0:	00078693          	mv	a3,a5
ffffffe000200cd4:	fd043783          	ld	a5,-48(s0)
ffffffe000200cd8:	0087b703          	ld	a4,8(a5)
ffffffe000200cdc:	00005797          	auipc	a5,0x5
ffffffe000200ce0:	32478793          	addi	a5,a5,804 # ffffffe000206000 <_sramdisk>
ffffffe000200ce4:	00f70733          	add	a4,a4,a5
ffffffe000200ce8:	fd043783          	ld	a5,-48(s0)
ffffffe000200cec:	0207b783          	ld	a5,32(a5)
ffffffe000200cf0:	00078613          	mv	a2,a5
ffffffe000200cf4:	00070593          	mv	a1,a4
ffffffe000200cf8:	00068513          	mv	a0,a3
ffffffe000200cfc:	594020ef          	jal	ra,ffffffe000203290 <memcpy>
            memset((void *)((uint64_t)new_pgs + align_offset + phdr->p_filesz), 0x0, phdr->p_memsz - phdr->p_filesz);
ffffffe000200d00:	fb843703          	ld	a4,-72(s0)
ffffffe000200d04:	fc843783          	ld	a5,-56(s0)
ffffffe000200d08:	00f70733          	add	a4,a4,a5
ffffffe000200d0c:	fd043783          	ld	a5,-48(s0)
ffffffe000200d10:	0207b783          	ld	a5,32(a5)
ffffffe000200d14:	00f707b3          	add	a5,a4,a5
ffffffe000200d18:	00078693          	mv	a3,a5
ffffffe000200d1c:	fd043783          	ld	a5,-48(s0)
ffffffe000200d20:	0287b703          	ld	a4,40(a5)
ffffffe000200d24:	fd043783          	ld	a5,-48(s0)
ffffffe000200d28:	0207b783          	ld	a5,32(a5)
ffffffe000200d2c:	40f707b3          	sub	a5,a4,a5
ffffffe000200d30:	00078613          	mv	a2,a5
ffffffe000200d34:	00000593          	li	a1,0
ffffffe000200d38:	00068513          	mv	a0,a3
ffffffe000200d3c:	4e4020ef          	jal	ra,ffffffe000203220 <memset>
            // do mapping
            create_mapping(task->pgd, phdr->p_vaddr - align_offset, VA2PA((uint64_t)new_pgs), phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
ffffffe000200d40:	fa843783          	ld	a5,-88(s0)
ffffffe000200d44:	0a87b503          	ld	a0,168(a5)
ffffffe000200d48:	fd043783          	ld	a5,-48(s0)
ffffffe000200d4c:	0107b703          	ld	a4,16(a5)
ffffffe000200d50:	fc843783          	ld	a5,-56(s0)
ffffffe000200d54:	40f705b3          	sub	a1,a4,a5
ffffffe000200d58:	fb843703          	ld	a4,-72(s0)
ffffffe000200d5c:	04100793          	li	a5,65
ffffffe000200d60:	01f79793          	slli	a5,a5,0x1f
ffffffe000200d64:	00f70633          	add	a2,a4,a5
ffffffe000200d68:	fd043783          	ld	a5,-48(s0)
ffffffe000200d6c:	0287b703          	ld	a4,40(a5)
ffffffe000200d70:	fc843783          	ld	a5,-56(s0)
ffffffe000200d74:	00f706b3          	add	a3,a4,a5
ffffffe000200d78:	fd043783          	ld	a5,-48(s0)
ffffffe000200d7c:	0047a783          	lw	a5,4(a5)
ffffffe000200d80:	0187e793          	ori	a5,a5,24
ffffffe000200d84:	0007879b          	sext.w	a5,a5
ffffffe000200d88:	02079793          	slli	a5,a5,0x20
ffffffe000200d8c:	0207d793          	srli	a5,a5,0x20
ffffffe000200d90:	00078713          	mv	a4,a5
ffffffe000200d94:	7a9000ef          	jal	ra,ffffffe000201d3c <create_mapping>
            printk("[load_program] va = %lx, pa = %lx, sz = %lx, perm = %lx\n", phdr->p_vaddr - align_offset, (uint64_t)new_pgs - PA2VA_OFFSET, phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
ffffffe000200d98:	fd043783          	ld	a5,-48(s0)
ffffffe000200d9c:	0107b703          	ld	a4,16(a5)
ffffffe000200da0:	fc843783          	ld	a5,-56(s0)
ffffffe000200da4:	40f705b3          	sub	a1,a4,a5
ffffffe000200da8:	fb843703          	ld	a4,-72(s0)
ffffffe000200dac:	04100793          	li	a5,65
ffffffe000200db0:	01f79793          	slli	a5,a5,0x1f
ffffffe000200db4:	00f70633          	add	a2,a4,a5
ffffffe000200db8:	fd043783          	ld	a5,-48(s0)
ffffffe000200dbc:	0287b703          	ld	a4,40(a5)
ffffffe000200dc0:	fc843783          	ld	a5,-56(s0)
ffffffe000200dc4:	00f706b3          	add	a3,a4,a5
ffffffe000200dc8:	fd043783          	ld	a5,-48(s0)
ffffffe000200dcc:	0047a783          	lw	a5,4(a5)
ffffffe000200dd0:	0187e793          	ori	a5,a5,24
ffffffe000200dd4:	0007879b          	sext.w	a5,a5
ffffffe000200dd8:	00078713          	mv	a4,a5
ffffffe000200ddc:	00003517          	auipc	a0,0x3
ffffffe000200de0:	2b450513          	addi	a0,a0,692 # ffffffe000204090 <_srodata+0x90>
ffffffe000200de4:	31c020ef          	jal	ra,ffffffe000203100 <printk>
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200de8:	fec42783          	lw	a5,-20(s0)
ffffffe000200dec:	0017879b          	addiw	a5,a5,1
ffffffe000200df0:	fef42623          	sw	a5,-20(s0)
ffffffe000200df4:	fe043783          	ld	a5,-32(s0)
ffffffe000200df8:	0387d783          	lhu	a5,56(a5)
ffffffe000200dfc:	0007871b          	sext.w	a4,a5
ffffffe000200e00:	fec42783          	lw	a5,-20(s0)
ffffffe000200e04:	0007879b          	sext.w	a5,a5
ffffffe000200e08:	e2e7cee3          	blt	a5,a4,ffffffe000200c44 <load_program+0x40>
            // code...
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe000200e0c:	fe043783          	ld	a5,-32(s0)
ffffffe000200e10:	0187b703          	ld	a4,24(a5)
ffffffe000200e14:	fa843783          	ld	a5,-88(s0)
ffffffe000200e18:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200e1c:	00000013          	nop
ffffffe000200e20:	05813083          	ld	ra,88(sp)
ffffffe000200e24:	05013403          	ld	s0,80(sp)
ffffffe000200e28:	06010113          	addi	sp,sp,96
ffffffe000200e2c:	00008067          	ret

ffffffe000200e30 <task_init>:

void task_init()
{
ffffffe000200e30:	fe010113          	addi	sp,sp,-32
ffffffe000200e34:	00113c23          	sd	ra,24(sp)
ffffffe000200e38:	00813823          	sd	s0,16(sp)
ffffffe000200e3c:	02010413          	addi	s0,sp,32
    srand(2024);
ffffffe000200e40:	7e800513          	li	a0,2024
ffffffe000200e44:	33c020ef          	jal	ra,ffffffe000203180 <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
ffffffe000200e48:	b85ff0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000200e4c:	00050713          	mv	a4,a0
ffffffe000200e50:	00008797          	auipc	a5,0x8
ffffffe000200e54:	1b878793          	addi	a5,a5,440 # ffffffe000209008 <idle>
ffffffe000200e58:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe000200e5c:	00008797          	auipc	a5,0x8
ffffffe000200e60:	1ac78793          	addi	a5,a5,428 # ffffffe000209008 <idle>
ffffffe000200e64:	0007b783          	ld	a5,0(a5)
ffffffe000200e68:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200e6c:	00008797          	auipc	a5,0x8
ffffffe000200e70:	19c78793          	addi	a5,a5,412 # ffffffe000209008 <idle>
ffffffe000200e74:	0007b783          	ld	a5,0(a5)
ffffffe000200e78:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200e7c:	00008797          	auipc	a5,0x8
ffffffe000200e80:	18c78793          	addi	a5,a5,396 # ffffffe000209008 <idle>
ffffffe000200e84:	0007b783          	ld	a5,0(a5)
ffffffe000200e88:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200e8c:	00008797          	auipc	a5,0x8
ffffffe000200e90:	17c78793          	addi	a5,a5,380 # ffffffe000209008 <idle>
ffffffe000200e94:	0007b783          	ld	a5,0(a5)
ffffffe000200e98:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe000200e9c:	00008797          	auipc	a5,0x8
ffffffe000200ea0:	16c78793          	addi	a5,a5,364 # ffffffe000209008 <idle>
ffffffe000200ea4:	0007b703          	ld	a4,0(a5)
ffffffe000200ea8:	00008797          	auipc	a5,0x8
ffffffe000200eac:	16878793          	addi	a5,a5,360 # ffffffe000209010 <current>
ffffffe000200eb0:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200eb4:	00008797          	auipc	a5,0x8
ffffffe000200eb8:	15478793          	addi	a5,a5,340 # ffffffe000209008 <idle>
ffffffe000200ebc:	0007b703          	ld	a4,0(a5)
ffffffe000200ec0:	00008797          	auipc	a5,0x8
ffffffe000200ec4:	17078793          	addi	a5,a5,368 # ffffffe000209030 <task>
ffffffe000200ec8:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000200ecc:	00100793          	li	a5,1
ffffffe000200ed0:	fef42623          	sw	a5,-20(s0)
ffffffe000200ed4:	2600006f          	j	ffffffe000201134 <task_init+0x304>
    {
        task[i] = (struct task_struct *)kalloc();
ffffffe000200ed8:	af5ff0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000200edc:	00050693          	mv	a3,a0
ffffffe000200ee0:	00008717          	auipc	a4,0x8
ffffffe000200ee4:	15070713          	addi	a4,a4,336 # ffffffe000209030 <task>
ffffffe000200ee8:	fec42783          	lw	a5,-20(s0)
ffffffe000200eec:	00379793          	slli	a5,a5,0x3
ffffffe000200ef0:	00f707b3          	add	a5,a4,a5
ffffffe000200ef4:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200ef8:	00008717          	auipc	a4,0x8
ffffffe000200efc:	13870713          	addi	a4,a4,312 # ffffffe000209030 <task>
ffffffe000200f00:	fec42783          	lw	a5,-20(s0)
ffffffe000200f04:	00379793          	slli	a5,a5,0x3
ffffffe000200f08:	00f707b3          	add	a5,a4,a5
ffffffe000200f0c:	0007b783          	ld	a5,0(a5)
ffffffe000200f10:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200f14:	2b0020ef          	jal	ra,ffffffe0002031c4 <rand>
ffffffe000200f18:	00050793          	mv	a5,a0
ffffffe000200f1c:	00078713          	mv	a4,a5
ffffffe000200f20:	00a00793          	li	a5,10
ffffffe000200f24:	02f767bb          	remw	a5,a4,a5
ffffffe000200f28:	0007879b          	sext.w	a5,a5
ffffffe000200f2c:	0017879b          	addiw	a5,a5,1
ffffffe000200f30:	0007869b          	sext.w	a3,a5
ffffffe000200f34:	00008717          	auipc	a4,0x8
ffffffe000200f38:	0fc70713          	addi	a4,a4,252 # ffffffe000209030 <task>
ffffffe000200f3c:	fec42783          	lw	a5,-20(s0)
ffffffe000200f40:	00379793          	slli	a5,a5,0x3
ffffffe000200f44:	00f707b3          	add	a5,a4,a5
ffffffe000200f48:	0007b783          	ld	a5,0(a5)
ffffffe000200f4c:	00068713          	mv	a4,a3
ffffffe000200f50:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe000200f54:	00008717          	auipc	a4,0x8
ffffffe000200f58:	0dc70713          	addi	a4,a4,220 # ffffffe000209030 <task>
ffffffe000200f5c:	fec42783          	lw	a5,-20(s0)
ffffffe000200f60:	00379793          	slli	a5,a5,0x3
ffffffe000200f64:	00f707b3          	add	a5,a4,a5
ffffffe000200f68:	0007b783          	ld	a5,0(a5)
ffffffe000200f6c:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe000200f70:	00008717          	auipc	a4,0x8
ffffffe000200f74:	0c070713          	addi	a4,a4,192 # ffffffe000209030 <task>
ffffffe000200f78:	fec42783          	lw	a5,-20(s0)
ffffffe000200f7c:	00379793          	slli	a5,a5,0x3
ffffffe000200f80:	00f707b3          	add	a5,a4,a5
ffffffe000200f84:	0007b783          	ld	a5,0(a5)
ffffffe000200f88:	fec42703          	lw	a4,-20(s0)
ffffffe000200f8c:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe000200f90:	00008717          	auipc	a4,0x8
ffffffe000200f94:	0a070713          	addi	a4,a4,160 # ffffffe000209030 <task>
ffffffe000200f98:	fec42783          	lw	a5,-20(s0)
ffffffe000200f9c:	00379793          	slli	a5,a5,0x3
ffffffe000200fa0:	00f707b3          	add	a5,a4,a5
ffffffe000200fa4:	0007b783          	ld	a5,0(a5)
ffffffe000200fa8:	fffff717          	auipc	a4,0xfffff
ffffffe000200fac:	23870713          	addi	a4,a4,568 # ffffffe0002001e0 <__dummy>
ffffffe000200fb0:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe000200fb4:	00008717          	auipc	a4,0x8
ffffffe000200fb8:	07c70713          	addi	a4,a4,124 # ffffffe000209030 <task>
ffffffe000200fbc:	fec42783          	lw	a5,-20(s0)
ffffffe000200fc0:	00379793          	slli	a5,a5,0x3
ffffffe000200fc4:	00f707b3          	add	a5,a4,a5
ffffffe000200fc8:	0007b783          	ld	a5,0(a5)
ffffffe000200fcc:	00078693          	mv	a3,a5
ffffffe000200fd0:	00008717          	auipc	a4,0x8
ffffffe000200fd4:	06070713          	addi	a4,a4,96 # ffffffe000209030 <task>
ffffffe000200fd8:	fec42783          	lw	a5,-20(s0)
ffffffe000200fdc:	00379793          	slli	a5,a5,0x3
ffffffe000200fe0:	00f707b3          	add	a5,a4,a5
ffffffe000200fe4:	0007b783          	ld	a5,0(a5)
ffffffe000200fe8:	00001737          	lui	a4,0x1
ffffffe000200fec:	00e68733          	add	a4,a3,a4
ffffffe000200ff0:	02e7b423          	sd	a4,40(a5)
        set_user_pgtbl(task[i]);
ffffffe000200ff4:	00008717          	auipc	a4,0x8
ffffffe000200ff8:	03c70713          	addi	a4,a4,60 # ffffffe000209030 <task>
ffffffe000200ffc:	fec42783          	lw	a5,-20(s0)
ffffffe000201000:	00379793          	slli	a5,a5,0x3
ffffffe000201004:	00f707b3          	add	a5,a4,a5
ffffffe000201008:	0007b783          	ld	a5,0(a5)
ffffffe00020100c:	00078513          	mv	a0,a5
ffffffe000201010:	af1ff0ef          	jal	ra,ffffffe000200b00 <set_user_pgtbl>
        // uint64_t uapp_pages = (PGROUNDUP(_eramdisk - _sramdisk)) / PGSIZE;
        // uint64_t *uapp_mem = (uint64_t *)alloc_pages(uapp_pages);
        // memcpy(uapp_mem, _sramdisk, uapp_pages * PGSIZE);
        // create_mapping(task[i]->pgd, USER_START, VA2PA((uint64_t)uapp_mem), uapp_pages * PGSIZE, PTE_V | PTE_R | PTE_W | PTE_X | PTE_U);
        load_program(task[i]);
ffffffe000201014:	00008717          	auipc	a4,0x8
ffffffe000201018:	01c70713          	addi	a4,a4,28 # ffffffe000209030 <task>
ffffffe00020101c:	fec42783          	lw	a5,-20(s0)
ffffffe000201020:	00379793          	slli	a5,a5,0x3
ffffffe000201024:	00f707b3          	add	a5,a4,a5
ffffffe000201028:	0007b783          	ld	a5,0(a5)
ffffffe00020102c:	00078513          	mv	a0,a5
ffffffe000201030:	bd5ff0ef          	jal	ra,ffffffe000200c04 <load_program>
        // task[i]->thread.sepc = USER_START;
        // uint64_t sstatus = SSTATUS_SPIE | SSTATUS_SPP;
        // sstatus &= ~SSTATUS_SPP;
        // task[i]->thread.sstatus = sstatus;
        // task[i]->thread.sscratch = USER_END;
        task[i]->thread.sstatus = 0;
ffffffe000201034:	00008717          	auipc	a4,0x8
ffffffe000201038:	ffc70713          	addi	a4,a4,-4 # ffffffe000209030 <task>
ffffffe00020103c:	fec42783          	lw	a5,-20(s0)
ffffffe000201040:	00379793          	slli	a5,a5,0x3
ffffffe000201044:	00f707b3          	add	a5,a4,a5
ffffffe000201048:	0007b783          	ld	a5,0(a5)
ffffffe00020104c:	0807bc23          	sd	zero,152(a5)
        task[i]->thread.sstatus &= ~SSTATUS_SPP;
ffffffe000201050:	00008717          	auipc	a4,0x8
ffffffe000201054:	fe070713          	addi	a4,a4,-32 # ffffffe000209030 <task>
ffffffe000201058:	fec42783          	lw	a5,-20(s0)
ffffffe00020105c:	00379793          	slli	a5,a5,0x3
ffffffe000201060:	00f707b3          	add	a5,a4,a5
ffffffe000201064:	0007b783          	ld	a5,0(a5)
ffffffe000201068:	0987b703          	ld	a4,152(a5)
ffffffe00020106c:	00008697          	auipc	a3,0x8
ffffffe000201070:	fc468693          	addi	a3,a3,-60 # ffffffe000209030 <task>
ffffffe000201074:	fec42783          	lw	a5,-20(s0)
ffffffe000201078:	00379793          	slli	a5,a5,0x3
ffffffe00020107c:	00f687b3          	add	a5,a3,a5
ffffffe000201080:	0007b783          	ld	a5,0(a5)
ffffffe000201084:	eff77713          	andi	a4,a4,-257
ffffffe000201088:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sstatus |= SSTATUS_SPIE | SSTATUS_SUM;
ffffffe00020108c:	00008717          	auipc	a4,0x8
ffffffe000201090:	fa470713          	addi	a4,a4,-92 # ffffffe000209030 <task>
ffffffe000201094:	fec42783          	lw	a5,-20(s0)
ffffffe000201098:	00379793          	slli	a5,a5,0x3
ffffffe00020109c:	00f707b3          	add	a5,a4,a5
ffffffe0002010a0:	0007b783          	ld	a5,0(a5)
ffffffe0002010a4:	0987b683          	ld	a3,152(a5)
ffffffe0002010a8:	00008717          	auipc	a4,0x8
ffffffe0002010ac:	f8870713          	addi	a4,a4,-120 # ffffffe000209030 <task>
ffffffe0002010b0:	fec42783          	lw	a5,-20(s0)
ffffffe0002010b4:	00379793          	slli	a5,a5,0x3
ffffffe0002010b8:	00f707b3          	add	a5,a4,a5
ffffffe0002010bc:	0007b783          	ld	a5,0(a5)
ffffffe0002010c0:	00040737          	lui	a4,0x40
ffffffe0002010c4:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe0002010c8:	00e6e733          	or	a4,a3,a4
ffffffe0002010cc:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe0002010d0:	00008717          	auipc	a4,0x8
ffffffe0002010d4:	f6070713          	addi	a4,a4,-160 # ffffffe000209030 <task>
ffffffe0002010d8:	fec42783          	lw	a5,-20(s0)
ffffffe0002010dc:	00379793          	slli	a5,a5,0x3
ffffffe0002010e0:	00f707b3          	add	a5,a4,a5
ffffffe0002010e4:	0007b783          	ld	a5,0(a5)
ffffffe0002010e8:	00100713          	li	a4,1
ffffffe0002010ec:	02671713          	slli	a4,a4,0x26
ffffffe0002010f0:	0ae7b023          	sd	a4,160(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe0002010f4:	00008717          	auipc	a4,0x8
ffffffe0002010f8:	f3c70713          	addi	a4,a4,-196 # ffffffe000209030 <task>
ffffffe0002010fc:	fec42783          	lw	a5,-20(s0)
ffffffe000201100:	00379793          	slli	a5,a5,0x3
ffffffe000201104:	00f707b3          	add	a5,a4,a5
ffffffe000201108:	0007b783          	ld	a5,0(a5)
ffffffe00020110c:	0107b703          	ld	a4,16(a5)
ffffffe000201110:	fec42783          	lw	a5,-20(s0)
ffffffe000201114:	00070613          	mv	a2,a4
ffffffe000201118:	00078593          	mv	a1,a5
ffffffe00020111c:	00003517          	auipc	a0,0x3
ffffffe000201120:	fb450513          	addi	a0,a0,-76 # ffffffe0002040d0 <_srodata+0xd0>
ffffffe000201124:	7dd010ef          	jal	ra,ffffffe000203100 <printk>
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000201128:	fec42783          	lw	a5,-20(s0)
ffffffe00020112c:	0017879b          	addiw	a5,a5,1
ffffffe000201130:	fef42623          	sw	a5,-20(s0)
ffffffe000201134:	fec42783          	lw	a5,-20(s0)
ffffffe000201138:	0007871b          	sext.w	a4,a5
ffffffe00020113c:	00400793          	li	a5,4
ffffffe000201140:	d8e7dce3          	bge	a5,a4,ffffffe000200ed8 <task_init+0xa8>
    }

    printk("...task_init done!\n");
ffffffe000201144:	00003517          	auipc	a0,0x3
ffffffe000201148:	fac50513          	addi	a0,a0,-84 # ffffffe0002040f0 <_srodata+0xf0>
ffffffe00020114c:	7b5010ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe000201150:	00000013          	nop
ffffffe000201154:	01813083          	ld	ra,24(sp)
ffffffe000201158:	01013403          	ld	s0,16(sp)
ffffffe00020115c:	02010113          	addi	sp,sp,32
ffffffe000201160:	00008067          	ret

ffffffe000201164 <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next, uint64_t *pgtbl);

void switch_to(struct task_struct *next)
{
ffffffe000201164:	fd010113          	addi	sp,sp,-48
ffffffe000201168:	02113423          	sd	ra,40(sp)
ffffffe00020116c:	02813023          	sd	s0,32(sp)
ffffffe000201170:	03010413          	addi	s0,sp,48
ffffffe000201174:	fca43c23          	sd	a0,-40(s0)
    if (current != next)
ffffffe000201178:	00008797          	auipc	a5,0x8
ffffffe00020117c:	e9878793          	addi	a5,a5,-360 # ffffffe000209010 <current>
ffffffe000201180:	0007b783          	ld	a5,0(a5)
ffffffe000201184:	fd843703          	ld	a4,-40(s0)
ffffffe000201188:	08f70063          	beq	a4,a5,ffffffe000201208 <switch_to+0xa4>
    {
        struct task_struct *prev = current;
ffffffe00020118c:	00008797          	auipc	a5,0x8
ffffffe000201190:	e8478793          	addi	a5,a5,-380 # ffffffe000209010 <current>
ffffffe000201194:	0007b783          	ld	a5,0(a5)
ffffffe000201198:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe00020119c:	00008797          	auipc	a5,0x8
ffffffe0002011a0:	e7478793          	addi	a5,a5,-396 # ffffffe000209010 <current>
ffffffe0002011a4:	fd843703          	ld	a4,-40(s0)
ffffffe0002011a8:	00e7b023          	sd	a4,0(a5)
        printk("from [%d] switch to [%d]\n", prev->pid, next->pid);
ffffffe0002011ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002011b0:	0187b703          	ld	a4,24(a5)
ffffffe0002011b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002011b8:	0187b783          	ld	a5,24(a5)
ffffffe0002011bc:	00078613          	mv	a2,a5
ffffffe0002011c0:	00070593          	mv	a1,a4
ffffffe0002011c4:	00003517          	auipc	a0,0x3
ffffffe0002011c8:	f4450513          	addi	a0,a0,-188 # ffffffe000204108 <_srodata+0x108>
ffffffe0002011cc:	735010ef          	jal	ra,ffffffe000203100 <printk>
        uint64_t next_satp = get_satp(next->pgd);
ffffffe0002011d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002011d4:	0a87b783          	ld	a5,168(a5)
ffffffe0002011d8:	00078513          	mv	a0,a5
ffffffe0002011dc:	319000ef          	jal	ra,ffffffe000201cf4 <get_satp>
ffffffe0002011e0:	fea43023          	sd	a0,-32(s0)
        __switch_to(&(prev->thread), &(next->thread), next_satp);
ffffffe0002011e4:	fe843783          	ld	a5,-24(s0)
ffffffe0002011e8:	02078713          	addi	a4,a5,32
ffffffe0002011ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002011f0:	02078793          	addi	a5,a5,32
ffffffe0002011f4:	fe043683          	ld	a3,-32(s0)
ffffffe0002011f8:	00068613          	mv	a2,a3
ffffffe0002011fc:	00078593          	mv	a1,a5
ffffffe000201200:	00070513          	mv	a0,a4
ffffffe000201204:	fedfe0ef          	jal	ra,ffffffe0002001f0 <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
ffffffe000201208:	00000013          	nop
ffffffe00020120c:	02813083          	ld	ra,40(sp)
ffffffe000201210:	02013403          	ld	s0,32(sp)
ffffffe000201214:	03010113          	addi	sp,sp,48
ffffffe000201218:	00008067          	ret

ffffffe00020121c <do_timer>:

void do_timer()
{
ffffffe00020121c:	ff010113          	addi	sp,sp,-16
ffffffe000201220:	00113423          	sd	ra,8(sp)
ffffffe000201224:	00813023          	sd	s0,0(sp)
ffffffe000201228:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0)
ffffffe00020122c:	00008797          	auipc	a5,0x8
ffffffe000201230:	de478793          	addi	a5,a5,-540 # ffffffe000209010 <current>
ffffffe000201234:	0007b783          	ld	a5,0(a5)
ffffffe000201238:	0187b783          	ld	a5,24(a5)
ffffffe00020123c:	00078c63          	beqz	a5,ffffffe000201254 <do_timer+0x38>
ffffffe000201240:	00008797          	auipc	a5,0x8
ffffffe000201244:	dd078793          	addi	a5,a5,-560 # ffffffe000209010 <current>
ffffffe000201248:	0007b783          	ld	a5,0(a5)
ffffffe00020124c:	0087b783          	ld	a5,8(a5)
ffffffe000201250:	00079663          	bnez	a5,ffffffe00020125c <do_timer+0x40>
    {
        schedule();
ffffffe000201254:	050000ef          	jal	ra,ffffffe0002012a4 <schedule>
ffffffe000201258:	03c0006f          	j	ffffffe000201294 <do_timer+0x78>
    }
    else
    {
        --(current->counter);
ffffffe00020125c:	00008797          	auipc	a5,0x8
ffffffe000201260:	db478793          	addi	a5,a5,-588 # ffffffe000209010 <current>
ffffffe000201264:	0007b783          	ld	a5,0(a5)
ffffffe000201268:	0087b703          	ld	a4,8(a5)
ffffffe00020126c:	fff70713          	addi	a4,a4,-1
ffffffe000201270:	00e7b423          	sd	a4,8(a5)
        if (current->counter > 0)
ffffffe000201274:	00008797          	auipc	a5,0x8
ffffffe000201278:	d9c78793          	addi	a5,a5,-612 # ffffffe000209010 <current>
ffffffe00020127c:	0007b783          	ld	a5,0(a5)
ffffffe000201280:	0087b783          	ld	a5,8(a5)
ffffffe000201284:	00079663          	bnez	a5,ffffffe000201290 <do_timer+0x74>
        {
            return;
        }
        schedule();
ffffffe000201288:	01c000ef          	jal	ra,ffffffe0002012a4 <schedule>
ffffffe00020128c:	0080006f          	j	ffffffe000201294 <do_timer+0x78>
            return;
ffffffe000201290:	00000013          	nop
    }
}
ffffffe000201294:	00813083          	ld	ra,8(sp)
ffffffe000201298:	00013403          	ld	s0,0(sp)
ffffffe00020129c:	01010113          	addi	sp,sp,16
ffffffe0002012a0:	00008067          	ret

ffffffe0002012a4 <schedule>:

void schedule()
{
ffffffe0002012a4:	fd010113          	addi	sp,sp,-48
ffffffe0002012a8:	02113423          	sd	ra,40(sp)
ffffffe0002012ac:	02813023          	sd	s0,32(sp)
ffffffe0002012b0:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe0002012b4:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
ffffffe0002012b8:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < NR_TASKS; i++)
ffffffe0002012bc:	00100793          	li	a5,1
ffffffe0002012c0:	fef42023          	sw	a5,-32(s0)
ffffffe0002012c4:	0ac0006f          	j	ffffffe000201370 <schedule+0xcc>
    {
        if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe0002012c8:	00008717          	auipc	a4,0x8
ffffffe0002012cc:	d6870713          	addi	a4,a4,-664 # ffffffe000209030 <task>
ffffffe0002012d0:	fe042783          	lw	a5,-32(s0)
ffffffe0002012d4:	00379793          	slli	a5,a5,0x3
ffffffe0002012d8:	00f707b3          	add	a5,a4,a5
ffffffe0002012dc:	0007b783          	ld	a5,0(a5)
ffffffe0002012e0:	08078263          	beqz	a5,ffffffe000201364 <schedule+0xc0>
ffffffe0002012e4:	00008717          	auipc	a4,0x8
ffffffe0002012e8:	d4c70713          	addi	a4,a4,-692 # ffffffe000209030 <task>
ffffffe0002012ec:	fe042783          	lw	a5,-32(s0)
ffffffe0002012f0:	00379793          	slli	a5,a5,0x3
ffffffe0002012f4:	00f707b3          	add	a5,a4,a5
ffffffe0002012f8:	0007b783          	ld	a5,0(a5)
ffffffe0002012fc:	0007b783          	ld	a5,0(a5)
ffffffe000201300:	06079263          	bnez	a5,ffffffe000201364 <schedule+0xc0>
        {
            if (task[i]->counter > max_counter)
ffffffe000201304:	00008717          	auipc	a4,0x8
ffffffe000201308:	d2c70713          	addi	a4,a4,-724 # ffffffe000209030 <task>
ffffffe00020130c:	fe042783          	lw	a5,-32(s0)
ffffffe000201310:	00379793          	slli	a5,a5,0x3
ffffffe000201314:	00f707b3          	add	a5,a4,a5
ffffffe000201318:	0007b783          	ld	a5,0(a5)
ffffffe00020131c:	0087b703          	ld	a4,8(a5)
ffffffe000201320:	fe442783          	lw	a5,-28(s0)
ffffffe000201324:	04e7f063          	bgeu	a5,a4,ffffffe000201364 <schedule+0xc0>
            {
                max_counter = task[i]->counter;
ffffffe000201328:	00008717          	auipc	a4,0x8
ffffffe00020132c:	d0870713          	addi	a4,a4,-760 # ffffffe000209030 <task>
ffffffe000201330:	fe042783          	lw	a5,-32(s0)
ffffffe000201334:	00379793          	slli	a5,a5,0x3
ffffffe000201338:	00f707b3          	add	a5,a4,a5
ffffffe00020133c:	0007b783          	ld	a5,0(a5)
ffffffe000201340:	0087b783          	ld	a5,8(a5)
ffffffe000201344:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe000201348:	00008717          	auipc	a4,0x8
ffffffe00020134c:	ce870713          	addi	a4,a4,-792 # ffffffe000209030 <task>
ffffffe000201350:	fe042783          	lw	a5,-32(s0)
ffffffe000201354:	00379793          	slli	a5,a5,0x3
ffffffe000201358:	00f707b3          	add	a5,a4,a5
ffffffe00020135c:	0007b783          	ld	a5,0(a5)
ffffffe000201360:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000201364:	fe042783          	lw	a5,-32(s0)
ffffffe000201368:	0017879b          	addiw	a5,a5,1
ffffffe00020136c:	fef42023          	sw	a5,-32(s0)
ffffffe000201370:	fe042783          	lw	a5,-32(s0)
ffffffe000201374:	0007871b          	sext.w	a4,a5
ffffffe000201378:	00400793          	li	a5,4
ffffffe00020137c:	f4e7d6e3          	bge	a5,a4,ffffffe0002012c8 <schedule+0x24>
            }
        }
    }

    if (max_counter == 0)
ffffffe000201380:	fe442783          	lw	a5,-28(s0)
ffffffe000201384:	0007879b          	sext.w	a5,a5
ffffffe000201388:	0a079263          	bnez	a5,ffffffe00020142c <schedule+0x188>
    {
        for (int i = 0; i < NR_TASKS; i++)
ffffffe00020138c:	fc042e23          	sw	zero,-36(s0)
ffffffe000201390:	0840006f          	j	ffffffe000201414 <schedule+0x170>
        {
            if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe000201394:	00008717          	auipc	a4,0x8
ffffffe000201398:	c9c70713          	addi	a4,a4,-868 # ffffffe000209030 <task>
ffffffe00020139c:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013a0:	00379793          	slli	a5,a5,0x3
ffffffe0002013a4:	00f707b3          	add	a5,a4,a5
ffffffe0002013a8:	0007b783          	ld	a5,0(a5)
ffffffe0002013ac:	04078e63          	beqz	a5,ffffffe000201408 <schedule+0x164>
ffffffe0002013b0:	00008717          	auipc	a4,0x8
ffffffe0002013b4:	c8070713          	addi	a4,a4,-896 # ffffffe000209030 <task>
ffffffe0002013b8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013bc:	00379793          	slli	a5,a5,0x3
ffffffe0002013c0:	00f707b3          	add	a5,a4,a5
ffffffe0002013c4:	0007b783          	ld	a5,0(a5)
ffffffe0002013c8:	0007b783          	ld	a5,0(a5)
ffffffe0002013cc:	02079e63          	bnez	a5,ffffffe000201408 <schedule+0x164>
            {
                task[i]->counter = task[i]->priority;
ffffffe0002013d0:	00008717          	auipc	a4,0x8
ffffffe0002013d4:	c6070713          	addi	a4,a4,-928 # ffffffe000209030 <task>
ffffffe0002013d8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013dc:	00379793          	slli	a5,a5,0x3
ffffffe0002013e0:	00f707b3          	add	a5,a4,a5
ffffffe0002013e4:	0007b703          	ld	a4,0(a5)
ffffffe0002013e8:	00008697          	auipc	a3,0x8
ffffffe0002013ec:	c4868693          	addi	a3,a3,-952 # ffffffe000209030 <task>
ffffffe0002013f0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013f4:	00379793          	slli	a5,a5,0x3
ffffffe0002013f8:	00f687b3          	add	a5,a3,a5
ffffffe0002013fc:	0007b783          	ld	a5,0(a5)
ffffffe000201400:	01073703          	ld	a4,16(a4)
ffffffe000201404:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < NR_TASKS; i++)
ffffffe000201408:	fdc42783          	lw	a5,-36(s0)
ffffffe00020140c:	0017879b          	addiw	a5,a5,1
ffffffe000201410:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201414:	fdc42783          	lw	a5,-36(s0)
ffffffe000201418:	0007871b          	sext.w	a4,a5
ffffffe00020141c:	00400793          	li	a5,4
ffffffe000201420:	f6e7dae3          	bge	a5,a4,ffffffe000201394 <schedule+0xf0>
            }
        }
        schedule();
ffffffe000201424:	e81ff0ef          	jal	ra,ffffffe0002012a4 <schedule>
        return;
ffffffe000201428:	0280006f          	j	ffffffe000201450 <schedule+0x1ac>
    }

    if (next && next != current)
ffffffe00020142c:	fe843783          	ld	a5,-24(s0)
ffffffe000201430:	02078063          	beqz	a5,ffffffe000201450 <schedule+0x1ac>
ffffffe000201434:	00008797          	auipc	a5,0x8
ffffffe000201438:	bdc78793          	addi	a5,a5,-1060 # ffffffe000209010 <current>
ffffffe00020143c:	0007b783          	ld	a5,0(a5)
ffffffe000201440:	fe843703          	ld	a4,-24(s0)
ffffffe000201444:	00f70663          	beq	a4,a5,ffffffe000201450 <schedule+0x1ac>
    {
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
ffffffe000201448:	fe843503          	ld	a0,-24(s0)
ffffffe00020144c:	d19ff0ef          	jal	ra,ffffffe000201164 <switch_to>
    }
}
ffffffe000201450:	02813083          	ld	ra,40(sp)
ffffffe000201454:	02013403          	ld	s0,32(sp)
ffffffe000201458:	03010113          	addi	sp,sp,48
ffffffe00020145c:	00008067          	ret

ffffffe000201460 <dummy>:
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy()
{
ffffffe000201460:	fd010113          	addi	sp,sp,-48
ffffffe000201464:	02113423          	sd	ra,40(sp)
ffffffe000201468:	02813023          	sd	s0,32(sp)
ffffffe00020146c:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000201470:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000201474:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000201478:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe00020147c:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000201480:	fff00793          	li	a5,-1
ffffffe000201484:	fef42223          	sw	a5,-28(s0)
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201488:	fe442783          	lw	a5,-28(s0)
ffffffe00020148c:	0007871b          	sext.w	a4,a5
ffffffe000201490:	fff00793          	li	a5,-1
ffffffe000201494:	00f70e63          	beq	a4,a5,ffffffe0002014b0 <dummy+0x50>
ffffffe000201498:	00008797          	auipc	a5,0x8
ffffffe00020149c:	b7878793          	addi	a5,a5,-1160 # ffffffe000209010 <current>
ffffffe0002014a0:	0007b783          	ld	a5,0(a5)
ffffffe0002014a4:	0087b703          	ld	a4,8(a5)
ffffffe0002014a8:	fe442783          	lw	a5,-28(s0)
ffffffe0002014ac:	fcf70ee3          	beq	a4,a5,ffffffe000201488 <dummy+0x28>
ffffffe0002014b0:	00008797          	auipc	a5,0x8
ffffffe0002014b4:	b6078793          	addi	a5,a5,-1184 # ffffffe000209010 <current>
ffffffe0002014b8:	0007b783          	ld	a5,0(a5)
ffffffe0002014bc:	0087b783          	ld	a5,8(a5)
ffffffe0002014c0:	fc0784e3          	beqz	a5,ffffffe000201488 <dummy+0x28>
        {
            if (current->counter == 1)
ffffffe0002014c4:	00008797          	auipc	a5,0x8
ffffffe0002014c8:	b4c78793          	addi	a5,a5,-1204 # ffffffe000209010 <current>
ffffffe0002014cc:	0007b783          	ld	a5,0(a5)
ffffffe0002014d0:	0087b703          	ld	a4,8(a5)
ffffffe0002014d4:	00100793          	li	a5,1
ffffffe0002014d8:	00f71e63          	bne	a4,a5,ffffffe0002014f4 <dummy+0x94>
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002014dc:	00008797          	auipc	a5,0x8
ffffffe0002014e0:	b3478793          	addi	a5,a5,-1228 # ffffffe000209010 <current>
ffffffe0002014e4:	0007b783          	ld	a5,0(a5)
ffffffe0002014e8:	0087b703          	ld	a4,8(a5)
ffffffe0002014ec:	fff70713          	addi	a4,a4,-1
ffffffe0002014f0:	00e7b423          	sd	a4,8(a5)
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002014f4:	00008797          	auipc	a5,0x8
ffffffe0002014f8:	b1c78793          	addi	a5,a5,-1252 # ffffffe000209010 <current>
ffffffe0002014fc:	0007b783          	ld	a5,0(a5)
ffffffe000201500:	0087b783          	ld	a5,8(a5)
ffffffe000201504:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000201508:	fe843783          	ld	a5,-24(s0)
ffffffe00020150c:	00178713          	addi	a4,a5,1
ffffffe000201510:	fd843783          	ld	a5,-40(s0)
ffffffe000201514:	02f777b3          	remu	a5,a4,a5
ffffffe000201518:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe00020151c:	00008797          	auipc	a5,0x8
ffffffe000201520:	af478793          	addi	a5,a5,-1292 # ffffffe000209010 <current>
ffffffe000201524:	0007b783          	ld	a5,0(a5)
ffffffe000201528:	0187b783          	ld	a5,24(a5)
ffffffe00020152c:	fe843603          	ld	a2,-24(s0)
ffffffe000201530:	00078593          	mv	a1,a5
ffffffe000201534:	00003517          	auipc	a0,0x3
ffffffe000201538:	bf450513          	addi	a0,a0,-1036 # ffffffe000204128 <_srodata+0x128>
ffffffe00020153c:	3c5010ef          	jal	ra,ffffffe000203100 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201540:	f49ff06f          	j	ffffffe000201488 <dummy+0x28>

ffffffe000201544 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000201544:	f8010113          	addi	sp,sp,-128
ffffffe000201548:	06813c23          	sd	s0,120(sp)
ffffffe00020154c:	06913823          	sd	s1,112(sp)
ffffffe000201550:	07213423          	sd	s2,104(sp)
ffffffe000201554:	07313023          	sd	s3,96(sp)
ffffffe000201558:	08010413          	addi	s0,sp,128
ffffffe00020155c:	faa43c23          	sd	a0,-72(s0)
ffffffe000201560:	fab43823          	sd	a1,-80(s0)
ffffffe000201564:	fac43423          	sd	a2,-88(s0)
ffffffe000201568:	fad43023          	sd	a3,-96(s0)
ffffffe00020156c:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201570:	f8f43823          	sd	a5,-112(s0)
ffffffe000201574:	f9043423          	sd	a6,-120(s0)
ffffffe000201578:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe00020157c:	fb843e03          	ld	t3,-72(s0)
ffffffe000201580:	fb043e83          	ld	t4,-80(s0)
ffffffe000201584:	fa843f03          	ld	t5,-88(s0)
ffffffe000201588:	fa043f83          	ld	t6,-96(s0)
ffffffe00020158c:	f9843283          	ld	t0,-104(s0)
ffffffe000201590:	f9043483          	ld	s1,-112(s0)
ffffffe000201594:	f8843903          	ld	s2,-120(s0)
ffffffe000201598:	f8043983          	ld	s3,-128(s0)
ffffffe00020159c:	000e0893          	mv	a7,t3
ffffffe0002015a0:	000e8813          	mv	a6,t4
ffffffe0002015a4:	000f0513          	mv	a0,t5
ffffffe0002015a8:	000f8593          	mv	a1,t6
ffffffe0002015ac:	00028613          	mv	a2,t0
ffffffe0002015b0:	00048693          	mv	a3,s1
ffffffe0002015b4:	00090713          	mv	a4,s2
ffffffe0002015b8:	00098793          	mv	a5,s3
ffffffe0002015bc:	00000073          	ecall
ffffffe0002015c0:	00050e93          	mv	t4,a0
ffffffe0002015c4:	00058e13          	mv	t3,a1
ffffffe0002015c8:	fdd43023          	sd	t4,-64(s0)
ffffffe0002015cc:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe0002015d0:	fc043783          	ld	a5,-64(s0)
ffffffe0002015d4:	fcf43823          	sd	a5,-48(s0)
ffffffe0002015d8:	fc843783          	ld	a5,-56(s0)
ffffffe0002015dc:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002015e0:	fd043703          	ld	a4,-48(s0)
ffffffe0002015e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002015e8:	00070313          	mv	t1,a4
ffffffe0002015ec:	00078393          	mv	t2,a5
ffffffe0002015f0:	00030713          	mv	a4,t1
ffffffe0002015f4:	00038793          	mv	a5,t2
}
ffffffe0002015f8:	00070513          	mv	a0,a4
ffffffe0002015fc:	00078593          	mv	a1,a5
ffffffe000201600:	07813403          	ld	s0,120(sp)
ffffffe000201604:	07013483          	ld	s1,112(sp)
ffffffe000201608:	06813903          	ld	s2,104(sp)
ffffffe00020160c:	06013983          	ld	s3,96(sp)
ffffffe000201610:	08010113          	addi	sp,sp,128
ffffffe000201614:	00008067          	ret

ffffffe000201618 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000201618:	fd010113          	addi	sp,sp,-48
ffffffe00020161c:	02813423          	sd	s0,40(sp)
ffffffe000201620:	03010413          	addi	s0,sp,48
ffffffe000201624:	00050793          	mv	a5,a0
ffffffe000201628:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe00020162c:	00100793          	li	a5,1
ffffffe000201630:	00000713          	li	a4,0
ffffffe000201634:	fdf44683          	lbu	a3,-33(s0)
ffffffe000201638:	00078893          	mv	a7,a5
ffffffe00020163c:	00070813          	mv	a6,a4
ffffffe000201640:	00068513          	mv	a0,a3
ffffffe000201644:	00000073          	ecall
ffffffe000201648:	00050713          	mv	a4,a0
ffffffe00020164c:	00058793          	mv	a5,a1
ffffffe000201650:	fee43023          	sd	a4,-32(s0)
ffffffe000201654:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe000201658:	00000013          	nop
ffffffe00020165c:	00070513          	mv	a0,a4
ffffffe000201660:	00078593          	mv	a1,a5
ffffffe000201664:	02813403          	ld	s0,40(sp)
ffffffe000201668:	03010113          	addi	sp,sp,48
ffffffe00020166c:	00008067          	ret

ffffffe000201670 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000201670:	fc010113          	addi	sp,sp,-64
ffffffe000201674:	02813c23          	sd	s0,56(sp)
ffffffe000201678:	04010413          	addi	s0,sp,64
ffffffe00020167c:	00050793          	mv	a5,a0
ffffffe000201680:	00058713          	mv	a4,a1
ffffffe000201684:	fcf42623          	sw	a5,-52(s0)
ffffffe000201688:	00070793          	mv	a5,a4
ffffffe00020168c:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000201690:	00800793          	li	a5,8
ffffffe000201694:	00000713          	li	a4,0
ffffffe000201698:	fcc42583          	lw	a1,-52(s0)
ffffffe00020169c:	00058313          	mv	t1,a1
ffffffe0002016a0:	fc842583          	lw	a1,-56(s0)
ffffffe0002016a4:	00058e13          	mv	t3,a1
ffffffe0002016a8:	00078893          	mv	a7,a5
ffffffe0002016ac:	00070813          	mv	a6,a4
ffffffe0002016b0:	00030513          	mv	a0,t1
ffffffe0002016b4:	000e0593          	mv	a1,t3
ffffffe0002016b8:	00000073          	ecall
ffffffe0002016bc:	00050713          	mv	a4,a0
ffffffe0002016c0:	00058793          	mv	a5,a1
ffffffe0002016c4:	fce43823          	sd	a4,-48(s0)
ffffffe0002016c8:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe0002016cc:	fd043783          	ld	a5,-48(s0)
ffffffe0002016d0:	fef43023          	sd	a5,-32(s0)
ffffffe0002016d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002016d8:	fef43423          	sd	a5,-24(s0)
ffffffe0002016dc:	fe043703          	ld	a4,-32(s0)
ffffffe0002016e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002016e4:	00070613          	mv	a2,a4
ffffffe0002016e8:	00078693          	mv	a3,a5
ffffffe0002016ec:	00060713          	mv	a4,a2
ffffffe0002016f0:	00068793          	mv	a5,a3
ffffffe0002016f4:	00070513          	mv	a0,a4
ffffffe0002016f8:	00078593          	mv	a1,a5
ffffffe0002016fc:	03813403          	ld	s0,56(sp)
ffffffe000201700:	04010113          	addi	sp,sp,64
ffffffe000201704:	00008067          	ret

ffffffe000201708 <sys_write>:
#include "syscall.h"

extern struct task_struct *get_current_proc();

int sys_write(unsigned int fd, const char* buf, unsigned int size) {
ffffffe000201708:	fd010113          	addi	sp,sp,-48
ffffffe00020170c:	02113423          	sd	ra,40(sp)
ffffffe000201710:	02813023          	sd	s0,32(sp)
ffffffe000201714:	03010413          	addi	s0,sp,48
ffffffe000201718:	00050793          	mv	a5,a0
ffffffe00020171c:	fcb43823          	sd	a1,-48(s0)
ffffffe000201720:	00060713          	mv	a4,a2
ffffffe000201724:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201728:	00070793          	mv	a5,a4
ffffffe00020172c:	fcf42c23          	sw	a5,-40(s0)
    int cnt = 0;
ffffffe000201730:	fe042623          	sw	zero,-20(s0)
    if (fd == STDOUT) {
ffffffe000201734:	fdc42783          	lw	a5,-36(s0)
ffffffe000201738:	0007871b          	sext.w	a4,a5
ffffffe00020173c:	00100793          	li	a5,1
ffffffe000201740:	06f71063          	bne	a4,a5,ffffffe0002017a0 <sys_write+0x98>
        for (cnt = 0; cnt < size && buf[cnt]; ++cnt) putc(buf[cnt]);
ffffffe000201744:	fe042623          	sw	zero,-20(s0)
ffffffe000201748:	02c0006f          	j	ffffffe000201774 <sys_write+0x6c>
ffffffe00020174c:	fec42783          	lw	a5,-20(s0)
ffffffe000201750:	fd043703          	ld	a4,-48(s0)
ffffffe000201754:	00f707b3          	add	a5,a4,a5
ffffffe000201758:	0007c783          	lbu	a5,0(a5)
ffffffe00020175c:	0007879b          	sext.w	a5,a5
ffffffe000201760:	00078513          	mv	a0,a5
ffffffe000201764:	309000ef          	jal	ra,ffffffe00020226c <putc>
ffffffe000201768:	fec42783          	lw	a5,-20(s0)
ffffffe00020176c:	0017879b          	addiw	a5,a5,1
ffffffe000201770:	fef42623          	sw	a5,-20(s0)
ffffffe000201774:	fec42703          	lw	a4,-20(s0)
ffffffe000201778:	fd842783          	lw	a5,-40(s0)
ffffffe00020177c:	0007879b          	sext.w	a5,a5
ffffffe000201780:	00f77c63          	bgeu	a4,a5,ffffffe000201798 <sys_write+0x90>
ffffffe000201784:	fec42783          	lw	a5,-20(s0)
ffffffe000201788:	fd043703          	ld	a4,-48(s0)
ffffffe00020178c:	00f707b3          	add	a5,a4,a5
ffffffe000201790:	0007c783          	lbu	a5,0(a5)
ffffffe000201794:	fa079ce3          	bnez	a5,ffffffe00020174c <sys_write+0x44>
        return cnt;
ffffffe000201798:	fec42783          	lw	a5,-20(s0)
ffffffe00020179c:	0080006f          	j	ffffffe0002017a4 <sys_write+0x9c>
    }
    return -1;
ffffffe0002017a0:	fff00793          	li	a5,-1
}
ffffffe0002017a4:	00078513          	mv	a0,a5
ffffffe0002017a8:	02813083          	ld	ra,40(sp)
ffffffe0002017ac:	02013403          	ld	s0,32(sp)
ffffffe0002017b0:	03010113          	addi	sp,sp,48
ffffffe0002017b4:	00008067          	ret

ffffffe0002017b8 <sys_getpid>:

int sys_getpid(){
ffffffe0002017b8:	fe010113          	addi	sp,sp,-32
ffffffe0002017bc:	00113c23          	sd	ra,24(sp)
ffffffe0002017c0:	00813823          	sd	s0,16(sp)
ffffffe0002017c4:	02010413          	addi	s0,sp,32
    struct task_struct *current = get_current_proc();
ffffffe0002017c8:	b10ff0ef          	jal	ra,ffffffe000200ad8 <get_current_proc>
ffffffe0002017cc:	fea43423          	sd	a0,-24(s0)
    return current->pid;
ffffffe0002017d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002017d4:	0187b783          	ld	a5,24(a5)
ffffffe0002017d8:	0007879b          	sext.w	a5,a5
ffffffe0002017dc:	00078513          	mv	a0,a5
ffffffe0002017e0:	01813083          	ld	ra,24(sp)
ffffffe0002017e4:	01013403          	ld	s0,16(sp)
ffffffe0002017e8:	02010113          	addi	sp,sp,32
ffffffe0002017ec:	00008067          	ret

ffffffe0002017f0 <trap_handler>:
extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc,struct pt_regs *regs) {
ffffffe0002017f0:	f9010113          	addi	sp,sp,-112
ffffffe0002017f4:	06113423          	sd	ra,104(sp)
ffffffe0002017f8:	06813023          	sd	s0,96(sp)
ffffffe0002017fc:	07010413          	addi	s0,sp,112
ffffffe000201800:	faa43423          	sd	a0,-88(s0)
ffffffe000201804:	fab43023          	sd	a1,-96(s0)
ffffffe000201808:	f8c43c23          	sd	a2,-104(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
ffffffe00020180c:	fa843783          	ld	a5,-88(s0)
ffffffe000201810:	0407d063          	bgez	a5,ffffffe000201850 <trap_handler+0x60>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe000201814:	fa843783          	ld	a5,-88(s0)
ffffffe000201818:	0ff7f793          	zext.b	a5,a5
ffffffe00020181c:	faf43c23          	sd	a5,-72(s0)
        if (interrupt_t == 0x5) {
ffffffe000201820:	fb843703          	ld	a4,-72(s0)
ffffffe000201824:	00500793          	li	a5,5
ffffffe000201828:	00f71863          	bne	a4,a5,ffffffe000201838 <trap_handler+0x48>
            // timer interrupt
            // printk("timer interrupt, time = %ld\n", get_cycles());
            clock_set_next_event();
ffffffe00020182c:	ac9fe0ef          	jal	ra,ffffffe0002002f4 <clock_set_next_event>
            do_timer();
ffffffe000201830:	9edff0ef          	jal	ra,ffffffe00020121c <do_timer>
ffffffe000201834:	0f80006f          	j	ffffffe00020192c <trap_handler+0x13c>
        } else{
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000201838:	fa043603          	ld	a2,-96(s0)
ffffffe00020183c:	fa843583          	ld	a1,-88(s0)
ffffffe000201840:	00003517          	auipc	a0,0x3
ffffffe000201844:	91850513          	addi	a0,a0,-1768 # ffffffe000204158 <_srodata+0x158>
ffffffe000201848:	0b9010ef          	jal	ra,ffffffe000203100 <printk>
ffffffe00020184c:	0e00006f          	j	ffffffe00020192c <trap_handler+0x13c>
        }
    }
    else {
        // exception
        if(scause == ECALL_FROM_U_MODE) {
ffffffe000201850:	fa843703          	ld	a4,-88(s0)
ffffffe000201854:	00800793          	li	a5,8
ffffffe000201858:	0cf71a63          	bne	a4,a5,ffffffe00020192c <trap_handler+0x13c>
            uint64_t syscall_id = regs->a[7];
ffffffe00020185c:	f9843783          	ld	a5,-104(s0)
ffffffe000201860:	0787b783          	ld	a5,120(a5)
ffffffe000201864:	fef43423          	sd	a5,-24(s0)
            printk("[trap_handler] ecall from user mode, syscall_id = %ld\n", syscall_id);
ffffffe000201868:	fe843583          	ld	a1,-24(s0)
ffffffe00020186c:	00003517          	auipc	a0,0x3
ffffffe000201870:	91c50513          	addi	a0,a0,-1764 # ffffffe000204188 <_srodata+0x188>
ffffffe000201874:	08d010ef          	jal	ra,ffffffe000203100 <printk>
            if(syscall_id == SYS_WRITE){
ffffffe000201878:	fe843703          	ld	a4,-24(s0)
ffffffe00020187c:	04000793          	li	a5,64
ffffffe000201880:	04f71e63          	bne	a4,a5,ffffffe0002018dc <trap_handler+0xec>
                unsigned int fd = (unsigned int)regs->a[0];
ffffffe000201884:	f9843783          	ld	a5,-104(s0)
ffffffe000201888:	0407b783          	ld	a5,64(a5)
ffffffe00020188c:	fcf42e23          	sw	a5,-36(s0)
                const char *buf = (const char *)regs->a[1];
ffffffe000201890:	f9843783          	ld	a5,-104(s0)
ffffffe000201894:	0487b783          	ld	a5,72(a5)
ffffffe000201898:	fcf43823          	sd	a5,-48(s0)
                size_t count = (size_t)regs->a[2];
ffffffe00020189c:	f9843783          	ld	a5,-104(s0)
ffffffe0002018a0:	0507b783          	ld	a5,80(a5)
ffffffe0002018a4:	fcf43423          	sd	a5,-56(s0)
                uint64_t ret = sys_write(fd, buf, count);
ffffffe0002018a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002018ac:	0007871b          	sext.w	a4,a5
ffffffe0002018b0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002018b4:	00070613          	mv	a2,a4
ffffffe0002018b8:	fd043583          	ld	a1,-48(s0)
ffffffe0002018bc:	00078513          	mv	a0,a5
ffffffe0002018c0:	e49ff0ef          	jal	ra,ffffffe000201708 <sys_write>
ffffffe0002018c4:	00050793          	mv	a5,a0
ffffffe0002018c8:	fcf43023          	sd	a5,-64(s0)
                regs->a[0] = ret;
ffffffe0002018cc:	f9843783          	ld	a5,-104(s0)
ffffffe0002018d0:	fc043703          	ld	a4,-64(s0)
ffffffe0002018d4:	04e7b023          	sd	a4,64(a5)
ffffffe0002018d8:	03c0006f          	j	ffffffe000201914 <trap_handler+0x124>
            } else if (syscall_id == SYS_GETPID){
ffffffe0002018dc:	fe843703          	ld	a4,-24(s0)
ffffffe0002018e0:	0ac00793          	li	a5,172
ffffffe0002018e4:	02f71063          	bne	a4,a5,ffffffe000201904 <trap_handler+0x114>
                uint64_t pid = sys_getpid();
ffffffe0002018e8:	ed1ff0ef          	jal	ra,ffffffe0002017b8 <sys_getpid>
ffffffe0002018ec:	00050793          	mv	a5,a0
ffffffe0002018f0:	fef43023          	sd	a5,-32(s0)
                regs->a[0] = pid;
ffffffe0002018f4:	f9843783          	ld	a5,-104(s0)
ffffffe0002018f8:	fe043703          	ld	a4,-32(s0)
ffffffe0002018fc:	04e7b023          	sd	a4,64(a5)
ffffffe000201900:	0140006f          	j	ffffffe000201914 <trap_handler+0x124>
            } else {
                printk("unimplemented syscall_id: %ld\n", syscall_id);
ffffffe000201904:	fe843583          	ld	a1,-24(s0)
ffffffe000201908:	00003517          	auipc	a0,0x3
ffffffe00020190c:	8b850513          	addi	a0,a0,-1864 # ffffffe0002041c0 <_srodata+0x1c0>
ffffffe000201910:	7f0010ef          	jal	ra,ffffffe000203100 <printk>
            }
            regs->sepc += 4;
ffffffe000201914:	f9843783          	ld	a5,-104(s0)
ffffffe000201918:	0f07b783          	ld	a5,240(a5)
ffffffe00020191c:	00478713          	addi	a4,a5,4
ffffffe000201920:	f9843783          	ld	a5,-104(s0)
ffffffe000201924:	0ee7b823          	sd	a4,240(a5)
            return;
ffffffe000201928:	00000013          	nop
        }
    }
ffffffe00020192c:	06813083          	ld	ra,104(sp)
ffffffe000201930:	06013403          	ld	s0,96(sp)
ffffffe000201934:	07010113          	addi	sp,sp,112
ffffffe000201938:	00008067          	ret

ffffffe00020193c <setup_vm>:
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe00020193c:	fe010113          	addi	sp,sp,-32
ffffffe000201940:	00113c23          	sd	ra,24(sp)
ffffffe000201944:	00813823          	sd	s0,16(sp)
ffffffe000201948:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe00020194c:	00001637          	lui	a2,0x1
ffffffe000201950:	00000593          	li	a1,0
ffffffe000201954:	00008517          	auipc	a0,0x8
ffffffe000201958:	6ac50513          	addi	a0,a0,1708 # ffffffe00020a000 <early_pgtbl>
ffffffe00020195c:	0c5010ef          	jal	ra,ffffffe000203220 <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000201960:	00f00793          	li	a5,15
ffffffe000201964:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000201968:	fe043423          	sd	zero,-24(s0)
ffffffe00020196c:	0740006f          	j	ffffffe0002019e0 <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000201970:	fe843703          	ld	a4,-24(s0)
ffffffe000201974:	fff00793          	li	a5,-1
ffffffe000201978:	02579793          	slli	a5,a5,0x25
ffffffe00020197c:	00f706b3          	add	a3,a4,a5
ffffffe000201980:	fe843703          	ld	a4,-24(s0)
ffffffe000201984:	00100793          	li	a5,1
ffffffe000201988:	01f79793          	slli	a5,a5,0x1f
ffffffe00020198c:	00f707b3          	add	a5,a4,a5
ffffffe000201990:	fe043603          	ld	a2,-32(s0)
ffffffe000201994:	00078593          	mv	a1,a5
ffffffe000201998:	00068513          	mv	a0,a3
ffffffe00020199c:	074000ef          	jal	ra,ffffffe000201a10 <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe0002019a0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019a4:	00100793          	li	a5,1
ffffffe0002019a8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002019ac:	00f706b3          	add	a3,a4,a5
ffffffe0002019b0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019b4:	00100793          	li	a5,1
ffffffe0002019b8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002019bc:	00f707b3          	add	a5,a4,a5
ffffffe0002019c0:	fe043603          	ld	a2,-32(s0)
ffffffe0002019c4:	00078593          	mv	a1,a5
ffffffe0002019c8:	00068513          	mv	a0,a3
ffffffe0002019cc:	044000ef          	jal	ra,ffffffe000201a10 <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe0002019d0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019d4:	400007b7          	lui	a5,0x40000
ffffffe0002019d8:	00f707b3          	add	a5,a4,a5
ffffffe0002019dc:	fef43423          	sd	a5,-24(s0)
ffffffe0002019e0:	fe843703          	ld	a4,-24(s0)
ffffffe0002019e4:	01f00793          	li	a5,31
ffffffe0002019e8:	02079793          	slli	a5,a5,0x20
ffffffe0002019ec:	f8f762e3          	bltu	a4,a5,ffffffe000201970 <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe0002019f0:	00002517          	auipc	a0,0x2
ffffffe0002019f4:	7f050513          	addi	a0,a0,2032 # ffffffe0002041e0 <_srodata+0x1e0>
ffffffe0002019f8:	708010ef          	jal	ra,ffffffe000203100 <printk>
    return;
ffffffe0002019fc:	00000013          	nop
}
ffffffe000201a00:	01813083          	ld	ra,24(sp)
ffffffe000201a04:	01013403          	ld	s0,16(sp)
ffffffe000201a08:	02010113          	addi	sp,sp,32
ffffffe000201a0c:	00008067          	ret

ffffffe000201a10 <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201a10:	fc010113          	addi	sp,sp,-64
ffffffe000201a14:	02813c23          	sd	s0,56(sp)
ffffffe000201a18:	04010413          	addi	s0,sp,64
ffffffe000201a1c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201a20:	fcb43823          	sd	a1,-48(s0)
ffffffe000201a24:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000201a28:	fd843783          	ld	a5,-40(s0)
ffffffe000201a2c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201a30:	1ff7f793          	andi	a5,a5,511
ffffffe000201a34:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000201a38:	fd043783          	ld	a5,-48(s0)
ffffffe000201a3c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201a40:	00a79793          	slli	a5,a5,0xa
ffffffe000201a44:	fc843703          	ld	a4,-56(s0)
ffffffe000201a48:	00f767b3          	or	a5,a4,a5
ffffffe000201a4c:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000201a50:	00008717          	auipc	a4,0x8
ffffffe000201a54:	5b070713          	addi	a4,a4,1456 # ffffffe00020a000 <early_pgtbl>
ffffffe000201a58:	fe843783          	ld	a5,-24(s0)
ffffffe000201a5c:	00379793          	slli	a5,a5,0x3
ffffffe000201a60:	00f707b3          	add	a5,a4,a5
ffffffe000201a64:	fe043703          	ld	a4,-32(s0)
ffffffe000201a68:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe000201a6c:	00000013          	nop
ffffffe000201a70:	03813403          	ld	s0,56(sp)
ffffffe000201a74:	04010113          	addi	sp,sp,64
ffffffe000201a78:	00008067          	ret

ffffffe000201a7c <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe000201a7c:	fc010113          	addi	sp,sp,-64
ffffffe000201a80:	02113c23          	sd	ra,56(sp)
ffffffe000201a84:	02813823          	sd	s0,48(sp)
ffffffe000201a88:	04010413          	addi	s0,sp,64
ffffffe000201a8c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201a90:	fcb43823          	sd	a1,-48(s0)
ffffffe000201a94:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000201a98:	f35fe0ef          	jal	ra,ffffffe0002009cc <kalloc>
ffffffe000201a9c:	00050793          	mv	a5,a0
ffffffe000201aa0:	00078713          	mv	a4,a5
ffffffe000201aa4:	04100793          	li	a5,65
ffffffe000201aa8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201aac:	00f707b3          	add	a5,a4,a5
ffffffe000201ab0:	fef43423          	sd	a5,-24(s0)
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000201ab4:	fe843783          	ld	a5,-24(s0)
ffffffe000201ab8:	00c7d793          	srli	a5,a5,0xc
ffffffe000201abc:	00a79693          	slli	a3,a5,0xa
ffffffe000201ac0:	fd043783          	ld	a5,-48(s0)
ffffffe000201ac4:	00379793          	slli	a5,a5,0x3
ffffffe000201ac8:	fd843703          	ld	a4,-40(s0)
ffffffe000201acc:	00f707b3          	add	a5,a4,a5
ffffffe000201ad0:	fc843703          	ld	a4,-56(s0)
ffffffe000201ad4:	00e6e733          	or	a4,a3,a4
ffffffe000201ad8:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe000201adc:	fd043783          	ld	a5,-48(s0)
ffffffe000201ae0:	00379793          	slli	a5,a5,0x3
ffffffe000201ae4:	fd843703          	ld	a4,-40(s0)
ffffffe000201ae8:	00f707b3          	add	a5,a4,a5
ffffffe000201aec:	0007b783          	ld	a5,0(a5)
}
ffffffe000201af0:	00078513          	mv	a0,a5
ffffffe000201af4:	03813083          	ld	ra,56(sp)
ffffffe000201af8:	03013403          	ld	s0,48(sp)
ffffffe000201afc:	04010113          	addi	sp,sp,64
ffffffe000201b00:	00008067          	ret

ffffffe000201b04 <setup_vm_final>:

void setup_vm_final() {
ffffffe000201b04:	f9010113          	addi	sp,sp,-112
ffffffe000201b08:	06113423          	sd	ra,104(sp)
ffffffe000201b0c:	06813023          	sd	s0,96(sp)
ffffffe000201b10:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe000201b14:	00002517          	auipc	a0,0x2
ffffffe000201b18:	6e450513          	addi	a0,a0,1764 # ffffffe0002041f8 <_srodata+0x1f8>
ffffffe000201b1c:	5e4010ef          	jal	ra,ffffffe000203100 <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000201b20:	00001637          	lui	a2,0x1
ffffffe000201b24:	00000593          	li	a1,0
ffffffe000201b28:	00009517          	auipc	a0,0x9
ffffffe000201b2c:	4d850513          	addi	a0,a0,1240 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201b30:	6f0010ef          	jal	ra,ffffffe000203220 <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000201b34:	40100793          	li	a5,1025
ffffffe000201b38:	01579793          	slli	a5,a5,0x15
ffffffe000201b3c:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000201b40:	f00017b7          	lui	a5,0xf0001
ffffffe000201b44:	00979793          	slli	a5,a5,0x9
ffffffe000201b48:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe000201b4c:	01100793          	li	a5,17
ffffffe000201b50:	01b79793          	slli	a5,a5,0x1b
ffffffe000201b54:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000201b58:	c0100793          	li	a5,-1023
ffffffe000201b5c:	01b79793          	slli	a5,a5,0x1b
ffffffe000201b60:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000201b64:	fe043783          	ld	a5,-32(s0)
ffffffe000201b68:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe000201b6c:	00001717          	auipc	a4,0x1
ffffffe000201b70:	7a070713          	addi	a4,a4,1952 # ffffffe00020330c <_etext>
ffffffe000201b74:	000017b7          	lui	a5,0x1
ffffffe000201b78:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201b7c:	00f70733          	add	a4,a4,a5
ffffffe000201b80:	fffff7b7          	lui	a5,0xfffff
ffffffe000201b84:	00f777b3          	and	a5,a4,a5
ffffffe000201b88:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe000201b8c:	fc843703          	ld	a4,-56(s0)
ffffffe000201b90:	04100793          	li	a5,65
ffffffe000201b94:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b98:	00f70633          	add	a2,a4,a5
ffffffe000201b9c:	fc043703          	ld	a4,-64(s0)
ffffffe000201ba0:	fc843783          	ld	a5,-56(s0)
ffffffe000201ba4:	40f707b3          	sub	a5,a4,a5
ffffffe000201ba8:	00b00713          	li	a4,11
ffffffe000201bac:	00078693          	mv	a3,a5
ffffffe000201bb0:	fc843583          	ld	a1,-56(s0)
ffffffe000201bb4:	00009517          	auipc	a0,0x9
ffffffe000201bb8:	44c50513          	addi	a0,a0,1100 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201bbc:	180000ef          	jal	ra,ffffffe000201d3c <create_mapping>
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);
ffffffe000201bc0:	00b00693          	li	a3,11
ffffffe000201bc4:	fc043603          	ld	a2,-64(s0)
ffffffe000201bc8:	fc843583          	ld	a1,-56(s0)
ffffffe000201bcc:	00002517          	auipc	a0,0x2
ffffffe000201bd0:	64450513          	addi	a0,a0,1604 # ffffffe000204210 <_srodata+0x210>
ffffffe000201bd4:	52c010ef          	jal	ra,ffffffe000203100 <printk>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe000201bd8:	fc043783          	ld	a5,-64(s0)
ffffffe000201bdc:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe000201be0:	00003717          	auipc	a4,0x3
ffffffe000201be4:	99870713          	addi	a4,a4,-1640 # ffffffe000204578 <_erodata>
ffffffe000201be8:	000017b7          	lui	a5,0x1
ffffffe000201bec:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201bf0:	00f70733          	add	a4,a4,a5
ffffffe000201bf4:	fffff7b7          	lui	a5,0xfffff
ffffffe000201bf8:	00f777b3          	and	a5,a4,a5
ffffffe000201bfc:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe000201c00:	fb843703          	ld	a4,-72(s0)
ffffffe000201c04:	04100793          	li	a5,65
ffffffe000201c08:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c0c:	00f70633          	add	a2,a4,a5
ffffffe000201c10:	fb043703          	ld	a4,-80(s0)
ffffffe000201c14:	fb843783          	ld	a5,-72(s0)
ffffffe000201c18:	40f707b3          	sub	a5,a4,a5
ffffffe000201c1c:	00300713          	li	a4,3
ffffffe000201c20:	00078693          	mv	a3,a5
ffffffe000201c24:	fb843583          	ld	a1,-72(s0)
ffffffe000201c28:	00009517          	auipc	a0,0x9
ffffffe000201c2c:	3d850513          	addi	a0,a0,984 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201c30:	10c000ef          	jal	ra,ffffffe000201d3c <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);
ffffffe000201c34:	00300693          	li	a3,3
ffffffe000201c38:	fb043603          	ld	a2,-80(s0)
ffffffe000201c3c:	fb843583          	ld	a1,-72(s0)
ffffffe000201c40:	00002517          	auipc	a0,0x2
ffffffe000201c44:	60850513          	addi	a0,a0,1544 # ffffffe000204248 <_srodata+0x248>
ffffffe000201c48:	4b8010ef          	jal	ra,ffffffe000203100 <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe000201c4c:	fb043783          	ld	a5,-80(s0)
ffffffe000201c50:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe000201c54:	fd043783          	ld	a5,-48(s0)
ffffffe000201c58:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe000201c5c:	fa843703          	ld	a4,-88(s0)
ffffffe000201c60:	04100793          	li	a5,65
ffffffe000201c64:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c68:	00f70633          	add	a2,a4,a5
ffffffe000201c6c:	fa043703          	ld	a4,-96(s0)
ffffffe000201c70:	fa843783          	ld	a5,-88(s0)
ffffffe000201c74:	40f707b3          	sub	a5,a4,a5
ffffffe000201c78:	00700713          	li	a4,7
ffffffe000201c7c:	00078693          	mv	a3,a5
ffffffe000201c80:	fa843583          	ld	a1,-88(s0)
ffffffe000201c84:	00009517          	auipc	a0,0x9
ffffffe000201c88:	37c50513          	addi	a0,a0,892 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201c8c:	0b0000ef          	jal	ra,ffffffe000201d3c <create_mapping>
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);
ffffffe000201c90:	00700693          	li	a3,7
ffffffe000201c94:	fa043603          	ld	a2,-96(s0)
ffffffe000201c98:	fa843583          	ld	a1,-88(s0)
ffffffe000201c9c:	00002517          	auipc	a0,0x2
ffffffe000201ca0:	5e450513          	addi	a0,a0,1508 # ffffffe000204280 <_srodata+0x280>
ffffffe000201ca4:	45c010ef          	jal	ra,ffffffe000203100 <printk>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000201ca8:	00009517          	auipc	a0,0x9
ffffffe000201cac:	35850513          	addi	a0,a0,856 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201cb0:	044000ef          	jal	ra,ffffffe000201cf4 <get_satp>
ffffffe000201cb4:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000201cb8:	f9843783          	ld	a5,-104(s0)
ffffffe000201cbc:	f8f43823          	sd	a5,-112(s0)
ffffffe000201cc0:	f9043783          	ld	a5,-112(s0)
ffffffe000201cc4:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe000201cc8:	f9843583          	ld	a1,-104(s0)
ffffffe000201ccc:	00002517          	auipc	a0,0x2
ffffffe000201cd0:	5e450513          	addi	a0,a0,1508 # ffffffe0002042b0 <_srodata+0x2b0>
ffffffe000201cd4:	42c010ef          	jal	ra,ffffffe000203100 <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201cd8:	12000073          	sfence.vma

    // flush icache
    asm volatile("fence.i");
ffffffe000201cdc:	0000100f          	fence.i
    return;
ffffffe000201ce0:	00000013          	nop
}
ffffffe000201ce4:	06813083          	ld	ra,104(sp)
ffffffe000201ce8:	06013403          	ld	s0,96(sp)
ffffffe000201cec:	07010113          	addi	sp,sp,112
ffffffe000201cf0:	00008067          	ret

ffffffe000201cf4 <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe000201cf4:	fd010113          	addi	sp,sp,-48
ffffffe000201cf8:	02813423          	sd	s0,40(sp)
ffffffe000201cfc:	03010413          	addi	s0,sp,48
ffffffe000201d00:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe000201d04:	fd843703          	ld	a4,-40(s0)
ffffffe000201d08:	04100793          	li	a5,65
ffffffe000201d0c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201d10:	00f707b3          	add	a5,a4,a5
ffffffe000201d14:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe000201d18:	fe843783          	ld	a5,-24(s0)
ffffffe000201d1c:	00c7d713          	srli	a4,a5,0xc
ffffffe000201d20:	fff00793          	li	a5,-1
ffffffe000201d24:	03f79793          	slli	a5,a5,0x3f
ffffffe000201d28:	00f767b3          	or	a5,a4,a5
}
ffffffe000201d2c:	00078513          	mv	a0,a5
ffffffe000201d30:	02813403          	ld	s0,40(sp)
ffffffe000201d34:	03010113          	addi	sp,sp,48
ffffffe000201d38:	00008067          	ret

ffffffe000201d3c <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201d3c:	fb010113          	addi	sp,sp,-80
ffffffe000201d40:	04113423          	sd	ra,72(sp)
ffffffe000201d44:	04813023          	sd	s0,64(sp)
ffffffe000201d48:	05010413          	addi	s0,sp,80
ffffffe000201d4c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201d50:	fcb43823          	sd	a1,-48(s0)
ffffffe000201d54:	fcc43423          	sd	a2,-56(s0)
ffffffe000201d58:	fcd43023          	sd	a3,-64(s0)
ffffffe000201d5c:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe000201d60:	fc043683          	ld	a3,-64(s0)
ffffffe000201d64:	fc843603          	ld	a2,-56(s0)
ffffffe000201d68:	fd043583          	ld	a1,-48(s0)
ffffffe000201d6c:	00002517          	auipc	a0,0x2
ffffffe000201d70:	55450513          	addi	a0,a0,1364 # ffffffe0002042c0 <_srodata+0x2c0>
ffffffe000201d74:	38c010ef          	jal	ra,ffffffe000203100 <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000201d78:	fd043783          	ld	a5,-48(s0)
ffffffe000201d7c:	fef43423          	sd	a5,-24(s0)
ffffffe000201d80:	fc843783          	ld	a5,-56(s0)
ffffffe000201d84:	fef43023          	sd	a5,-32(s0)
ffffffe000201d88:	0380006f          	j	ffffffe000201dc0 <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe000201d8c:	fb843683          	ld	a3,-72(s0)
ffffffe000201d90:	fe043603          	ld	a2,-32(s0)
ffffffe000201d94:	fe843583          	ld	a1,-24(s0)
ffffffe000201d98:	fd843503          	ld	a0,-40(s0)
ffffffe000201d9c:	050000ef          	jal	ra,ffffffe000201dec <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000201da0:	fe843703          	ld	a4,-24(s0)
ffffffe000201da4:	000017b7          	lui	a5,0x1
ffffffe000201da8:	00f707b3          	add	a5,a4,a5
ffffffe000201dac:	fef43423          	sd	a5,-24(s0)
ffffffe000201db0:	fe043703          	ld	a4,-32(s0)
ffffffe000201db4:	000017b7          	lui	a5,0x1
ffffffe000201db8:	00f707b3          	add	a5,a4,a5
ffffffe000201dbc:	fef43023          	sd	a5,-32(s0)
ffffffe000201dc0:	fd043703          	ld	a4,-48(s0)
ffffffe000201dc4:	fc043783          	ld	a5,-64(s0)
ffffffe000201dc8:	00f707b3          	add	a5,a4,a5
ffffffe000201dcc:	fe843703          	ld	a4,-24(s0)
ffffffe000201dd0:	faf76ee3          	bltu	a4,a5,ffffffe000201d8c <create_mapping+0x50>
   }
}
ffffffe000201dd4:	00000013          	nop
ffffffe000201dd8:	00000013          	nop
ffffffe000201ddc:	04813083          	ld	ra,72(sp)
ffffffe000201de0:	04013403          	ld	s0,64(sp)
ffffffe000201de4:	05010113          	addi	sp,sp,80
ffffffe000201de8:	00008067          	ret

ffffffe000201dec <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201dec:	f9010113          	addi	sp,sp,-112
ffffffe000201df0:	06113423          	sd	ra,104(sp)
ffffffe000201df4:	06813023          	sd	s0,96(sp)
ffffffe000201df8:	07010413          	addi	s0,sp,112
ffffffe000201dfc:	faa43423          	sd	a0,-88(s0)
ffffffe000201e00:	fab43023          	sd	a1,-96(s0)
ffffffe000201e04:	f8c43c23          	sd	a2,-104(s0)
ffffffe000201e08:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000201e0c:	fa043783          	ld	a5,-96(s0)
ffffffe000201e10:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201e14:	1ff7f793          	andi	a5,a5,511
ffffffe000201e18:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000201e1c:	fa043783          	ld	a5,-96(s0)
ffffffe000201e20:	0157d793          	srli	a5,a5,0x15
ffffffe000201e24:	1ff7f793          	andi	a5,a5,511
ffffffe000201e28:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000201e2c:	fa043783          	ld	a5,-96(s0)
ffffffe000201e30:	00c7d793          	srli	a5,a5,0xc
ffffffe000201e34:	1ff7f793          	andi	a5,a5,511
ffffffe000201e38:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe000201e3c:	fd843783          	ld	a5,-40(s0)
ffffffe000201e40:	00379793          	slli	a5,a5,0x3
ffffffe000201e44:	fa843703          	ld	a4,-88(s0)
ffffffe000201e48:	00f707b3          	add	a5,a4,a5
ffffffe000201e4c:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe000201e50:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe000201e54:	fe843783          	ld	a5,-24(s0)
ffffffe000201e58:	0017f793          	andi	a5,a5,1
ffffffe000201e5c:	00079c63          	bnez	a5,ffffffe000201e74 <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe000201e60:	00100613          	li	a2,1
ffffffe000201e64:	fd843583          	ld	a1,-40(s0)
ffffffe000201e68:	fa843503          	ld	a0,-88(s0)
ffffffe000201e6c:	c11ff0ef          	jal	ra,ffffffe000201a7c <setup_pgtbl>
ffffffe000201e70:	fea43423          	sd	a0,-24(s0)
    }
    // printk("pte1 = %lx\n", pte);

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET); // VA
ffffffe000201e74:	fe843783          	ld	a5,-24(s0)
ffffffe000201e78:	00a7d793          	srli	a5,a5,0xa
ffffffe000201e7c:	00c79713          	slli	a4,a5,0xc
ffffffe000201e80:	fbf00793          	li	a5,-65
ffffffe000201e84:	01f79793          	slli	a5,a5,0x1f
ffffffe000201e88:	00f707b3          	add	a5,a4,a5
ffffffe000201e8c:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe000201e90:	fd043783          	ld	a5,-48(s0)
ffffffe000201e94:	00379793          	slli	a5,a5,0x3
ffffffe000201e98:	fc043703          	ld	a4,-64(s0)
ffffffe000201e9c:	00f707b3          	add	a5,a4,a5
ffffffe000201ea0:	0007b783          	ld	a5,0(a5)
ffffffe000201ea4:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe000201ea8:	fe043783          	ld	a5,-32(s0)
ffffffe000201eac:	0017f793          	andi	a5,a5,1
ffffffe000201eb0:	00079c63          	bnez	a5,ffffffe000201ec8 <map_vm_final+0xdc>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe000201eb4:	00100613          	li	a2,1
ffffffe000201eb8:	fd043583          	ld	a1,-48(s0)
ffffffe000201ebc:	fc043503          	ld	a0,-64(s0)
ffffffe000201ec0:	bbdff0ef          	jal	ra,ffffffe000201a7c <setup_pgtbl>
ffffffe000201ec4:	fea43023          	sd	a0,-32(s0)
    }
    // printk("pte2 = %lx\n", pte2);

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);// VA
ffffffe000201ec8:	fe043783          	ld	a5,-32(s0)
ffffffe000201ecc:	00a7d793          	srli	a5,a5,0xa
ffffffe000201ed0:	00c79713          	slli	a4,a5,0xc
ffffffe000201ed4:	fbf00793          	li	a5,-65
ffffffe000201ed8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201edc:	00f707b3          	add	a5,a4,a5
ffffffe000201ee0:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe000201ee4:	f9043783          	ld	a5,-112(s0)
ffffffe000201ee8:	0017e793          	ori	a5,a5,1
ffffffe000201eec:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe000201ef0:	f9843783          	ld	a5,-104(s0)
ffffffe000201ef4:	00c7d793          	srli	a5,a5,0xc
ffffffe000201ef8:	00a79693          	slli	a3,a5,0xa
ffffffe000201efc:	fc843783          	ld	a5,-56(s0)
ffffffe000201f00:	00379793          	slli	a5,a5,0x3
ffffffe000201f04:	fb843703          	ld	a4,-72(s0)
ffffffe000201f08:	00f707b3          	add	a5,a4,a5
ffffffe000201f0c:	f9043703          	ld	a4,-112(s0)
ffffffe000201f10:	00e6e733          	or	a4,a3,a4
ffffffe000201f14:	00e7b023          	sd	a4,0(a5)
}
ffffffe000201f18:	00000013          	nop
ffffffe000201f1c:	06813083          	ld	ra,104(sp)
ffffffe000201f20:	06013403          	ld	s0,96(sp)
ffffffe000201f24:	07010113          	addi	sp,sp,112
ffffffe000201f28:	00008067          	ret

ffffffe000201f2c <get_kernel_pgtbl>:

ffffffe000201f2c:	ff010113          	addi	sp,sp,-16
ffffffe000201f30:	00813423          	sd	s0,8(sp)
ffffffe000201f34:	01010413          	addi	s0,sp,16
ffffffe000201f38:	00009797          	auipc	a5,0x9
ffffffe000201f3c:	0c878793          	addi	a5,a5,200 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201f40:	00078513          	mv	a0,a5
ffffffe000201f44:	00813403          	ld	s0,8(sp)
ffffffe000201f48:	01010113          	addi	sp,sp,16
ffffffe000201f4c:	00008067          	ret

ffffffe000201f50 <start_kernel>:
#include "defs.h"
#include "proc.h"

extern void test();

int start_kernel() {
ffffffe000201f50:	ff010113          	addi	sp,sp,-16
ffffffe000201f54:	00113423          	sd	ra,8(sp)
ffffffe000201f58:	00813023          	sd	s0,0(sp)
ffffffe000201f5c:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000201f60:	00002517          	auipc	a0,0x2
ffffffe000201f64:	38850513          	addi	a0,a0,904 # ffffffe0002042e8 <_srodata+0x2e8>
ffffffe000201f68:	198010ef          	jal	ra,ffffffe000203100 <printk>
    printk(" ZJU Operating System\n");
ffffffe000201f6c:	00002517          	auipc	a0,0x2
ffffffe000201f70:	38450513          	addi	a0,a0,900 # ffffffe0002042f0 <_srodata+0x2f0>
ffffffe000201f74:	18c010ef          	jal	ra,ffffffe000203100 <printk>
    schedule();
ffffffe000201f78:	b2cff0ef          	jal	ra,ffffffe0002012a4 <schedule>
    // verify_vm();

    test();
ffffffe000201f7c:	2c0000ef          	jal	ra,ffffffe00020223c <test>
    return 0;
ffffffe000201f80:	00000793          	li	a5,0
}
ffffffe000201f84:	00078513          	mv	a0,a5
ffffffe000201f88:	00813083          	ld	ra,8(sp)
ffffffe000201f8c:	00013403          	ld	s0,0(sp)
ffffffe000201f90:	01010113          	addi	sp,sp,16
ffffffe000201f94:	00008067          	ret

ffffffe000201f98 <test_rodata_write>:

void test_rodata_write(uint64_t *addr) {
ffffffe000201f98:	fd010113          	addi	sp,sp,-48
ffffffe000201f9c:	02113423          	sd	ra,40(sp)
ffffffe000201fa0:	02813023          	sd	s0,32(sp)
ffffffe000201fa4:	03010413          	addi	s0,sp,48
ffffffe000201fa8:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr;
ffffffe000201fac:	fd843783          	ld	a5,-40(s0)
ffffffe000201fb0:	0007b783          	ld	a5,0(a5)
ffffffe000201fb4:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000201fb8:	00100793          	li	a5,1
ffffffe000201fbc:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000201fc0:	fd843783          	ld	a5,-40(s0)
ffffffe000201fc4:	00100293          	li	t0,1
ffffffe000201fc8:	0057b023          	sd	t0,0(a5)
ffffffe000201fcc:	00000793          	li	a5,0
ffffffe000201fd0:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000201fd4:	fe442783          	lw	a5,-28(s0)
ffffffe000201fd8:	0007879b          	sext.w	a5,a5
ffffffe000201fdc:	02078063          	beqz	a5,ffffffe000201ffc <test_rodata_write+0x64>
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
ffffffe000201fe0:	00002517          	auipc	a0,0x2
ffffffe000201fe4:	32850513          	addi	a0,a0,808 # ffffffe000204308 <_srodata+0x308>
ffffffe000201fe8:	118010ef          	jal	ra,ffffffe000203100 <printk>
        *addr = backup; // 恢复原值
ffffffe000201fec:	fd843783          	ld	a5,-40(s0)
ffffffe000201ff0:	fe843703          	ld	a4,-24(s0)
ffffffe000201ff4:	00e7b023          	sd	a4,0(a5)
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}
ffffffe000201ff8:	0100006f          	j	ffffffe000202008 <test_rodata_write+0x70>
        printk("PASS: .rodata write failed as expected.\n");
ffffffe000201ffc:	00002517          	auipc	a0,0x2
ffffffe000202000:	33c50513          	addi	a0,a0,828 # ffffffe000204338 <_srodata+0x338>
ffffffe000202004:	0fc010ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe000202008:	00000013          	nop
ffffffe00020200c:	02813083          	ld	ra,40(sp)
ffffffe000202010:	02013403          	ld	s0,32(sp)
ffffffe000202014:	03010113          	addi	sp,sp,48
ffffffe000202018:	00008067          	ret

ffffffe00020201c <test_rodata_exec>:

void test_rodata_exec(uint64_t *addr) {
ffffffe00020201c:	fd010113          	addi	sp,sp,-48
ffffffe000202020:	02113423          	sd	ra,40(sp)
ffffffe000202024:	02813023          	sd	s0,32(sp)
ffffffe000202028:	03010413          	addi	s0,sp,48
ffffffe00020202c:	fca43c23          	sd	a0,-40(s0)
    int success = 1;
ffffffe000202030:	00100793          	li	a5,1
ffffffe000202034:	fef42623          	sw	a5,-20(s0)

    asm volatile(
ffffffe000202038:	fd843783          	ld	a5,-40(s0)
ffffffe00020203c:	000780e7          	jalr	a5
ffffffe000202040:	00000793          	li	a5,0
ffffffe000202044:	fef42623          	sw	a5,-20(s0)
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
ffffffe000202048:	fec42783          	lw	a5,-20(s0)
ffffffe00020204c:	0007879b          	sext.w	a5,a5
ffffffe000202050:	00078a63          	beqz	a5,ffffffe000202064 <test_rodata_exec+0x48>
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
ffffffe000202054:	00002517          	auipc	a0,0x2
ffffffe000202058:	31450513          	addi	a0,a0,788 # ffffffe000204368 <_srodata+0x368>
ffffffe00020205c:	0a4010ef          	jal	ra,ffffffe000203100 <printk>
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}
ffffffe000202060:	0100006f          	j	ffffffe000202070 <test_rodata_exec+0x54>
        printk("PASS: .rodata execute failed as expected.\n");
ffffffe000202064:	00002517          	auipc	a0,0x2
ffffffe000202068:	33450513          	addi	a0,a0,820 # ffffffe000204398 <_srodata+0x398>
ffffffe00020206c:	094010ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe000202070:	00000013          	nop
ffffffe000202074:	02813083          	ld	ra,40(sp)
ffffffe000202078:	02013403          	ld	s0,32(sp)
ffffffe00020207c:	03010113          	addi	sp,sp,48
ffffffe000202080:	00008067          	ret

ffffffe000202084 <test_text_read>:

void test_text_read(uint64_t *addr) {
ffffffe000202084:	fd010113          	addi	sp,sp,-48
ffffffe000202088:	02113423          	sd	ra,40(sp)
ffffffe00020208c:	02813023          	sd	s0,32(sp)
ffffffe000202090:	03010413          	addi	s0,sp,48
ffffffe000202094:	fca43c23          	sd	a0,-40(s0)
    printk(".text read test: ");
ffffffe000202098:	00002517          	auipc	a0,0x2
ffffffe00020209c:	33050513          	addi	a0,a0,816 # ffffffe0002043c8 <_srodata+0x3c8>
ffffffe0002020a0:	060010ef          	jal	ra,ffffffe000203100 <printk>
    uint64_t value = *addr;
ffffffe0002020a4:	fd843783          	ld	a5,-40(s0)
ffffffe0002020a8:	0007b783          	ld	a5,0(a5)
ffffffe0002020ac:	fef43423          	sd	a5,-24(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe0002020b0:	fe843583          	ld	a1,-24(s0)
ffffffe0002020b4:	00002517          	auipc	a0,0x2
ffffffe0002020b8:	32c50513          	addi	a0,a0,812 # ffffffe0002043e0 <_srodata+0x3e0>
ffffffe0002020bc:	044010ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe0002020c0:	00000013          	nop
ffffffe0002020c4:	02813083          	ld	ra,40(sp)
ffffffe0002020c8:	02013403          	ld	s0,32(sp)
ffffffe0002020cc:	03010113          	addi	sp,sp,48
ffffffe0002020d0:	00008067          	ret

ffffffe0002020d4 <test_text_write>:

void test_text_write(uint64_t *addr) {
ffffffe0002020d4:	fd010113          	addi	sp,sp,-48
ffffffe0002020d8:	02113423          	sd	ra,40(sp)
ffffffe0002020dc:	02813023          	sd	s0,32(sp)
ffffffe0002020e0:	03010413          	addi	s0,sp,48
ffffffe0002020e4:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr; // 备份原始值
ffffffe0002020e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002020ec:	0007b783          	ld	a5,0(a5)
ffffffe0002020f0:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe0002020f4:	00100793          	li	a5,1
ffffffe0002020f8:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe0002020fc:	fd843783          	ld	a5,-40(s0)
ffffffe000202100:	00100293          	li	t0,1
ffffffe000202104:	0057b023          	sd	t0,0(a5)
ffffffe000202108:	00000793          	li	a5,0
ffffffe00020210c:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000202110:	fe442783          	lw	a5,-28(s0)
ffffffe000202114:	0007879b          	sext.w	a5,a5
ffffffe000202118:	00078a63          	beqz	a5,ffffffe00020212c <test_text_write+0x58>
        printk("PASS: .text write failed as expected.\n");
ffffffe00020211c:	00002517          	auipc	a0,0x2
ffffffe000202120:	2ec50513          	addi	a0,a0,748 # ffffffe000204408 <_srodata+0x408>
ffffffe000202124:	7dd000ef          	jal	ra,ffffffe000203100 <printk>
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}
ffffffe000202128:	01c0006f          	j	ffffffe000202144 <test_text_write+0x70>
        printk("ERROR: .text write succeeded unexpectedly!\n");
ffffffe00020212c:	00002517          	auipc	a0,0x2
ffffffe000202130:	30450513          	addi	a0,a0,772 # ffffffe000204430 <_srodata+0x430>
ffffffe000202134:	7cd000ef          	jal	ra,ffffffe000203100 <printk>
        *addr = backup; // 恢复原始值，避免破坏代码段
ffffffe000202138:	fd843783          	ld	a5,-40(s0)
ffffffe00020213c:	fe843703          	ld	a4,-24(s0)
ffffffe000202140:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202144:	00000013          	nop
ffffffe000202148:	02813083          	ld	ra,40(sp)
ffffffe00020214c:	02013403          	ld	s0,32(sp)
ffffffe000202150:	03010113          	addi	sp,sp,48
ffffffe000202154:	00008067          	ret

ffffffe000202158 <test_text_exec>:

void test_text_exec() {
ffffffe000202158:	ff010113          	addi	sp,sp,-16
ffffffe00020215c:	00113423          	sd	ra,8(sp)
ffffffe000202160:	00813023          	sd	s0,0(sp)
ffffffe000202164:	01010413          	addi	s0,sp,16
    printk("Executing .text segment test: ");
ffffffe000202168:	00002517          	auipc	a0,0x2
ffffffe00020216c:	2f850513          	addi	a0,a0,760 # ffffffe000204460 <_srodata+0x460>
ffffffe000202170:	791000ef          	jal	ra,ffffffe000203100 <printk>
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
ffffffe000202174:	00002517          	auipc	a0,0x2
ffffffe000202178:	30c50513          	addi	a0,a0,780 # ffffffe000204480 <_srodata+0x480>
ffffffe00020217c:	785000ef          	jal	ra,ffffffe000203100 <printk>
}
ffffffe000202180:	00000013          	nop
ffffffe000202184:	00813083          	ld	ra,8(sp)
ffffffe000202188:	00013403          	ld	s0,0(sp)
ffffffe00020218c:	01010113          	addi	sp,sp,16
ffffffe000202190:	00008067          	ret

ffffffe000202194 <verify_vm>:

void verify_vm() {
ffffffe000202194:	fd010113          	addi	sp,sp,-48
ffffffe000202198:	02113423          	sd	ra,40(sp)
ffffffe00020219c:	02813023          	sd	s0,32(sp)
ffffffe0002021a0:	03010413          	addi	s0,sp,48
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
ffffffe0002021a4:	f00017b7          	lui	a5,0xf0001
ffffffe0002021a8:	00979793          	slli	a5,a5,0x9
ffffffe0002021ac:	fef43423          	sd	a5,-24(s0)
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段
ffffffe0002021b0:	fe0007b7          	lui	a5,0xfe000
ffffffe0002021b4:	20378793          	addi	a5,a5,515 # fffffffffe000203 <VM_END+0xfe000203>
ffffffe0002021b8:	00c79793          	slli	a5,a5,0xc
ffffffe0002021bc:	fef43023          	sd	a5,-32(s0)

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;
ffffffe0002021c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002021c4:	fcf43c23          	sd	a5,-40(s0)

    // .text R
    printk(".text read test: \n");
ffffffe0002021c8:	00002517          	auipc	a0,0x2
ffffffe0002021cc:	2d850513          	addi	a0,a0,728 # ffffffe0002044a0 <_srodata+0x4a0>
ffffffe0002021d0:	731000ef          	jal	ra,ffffffe000203100 <printk>
    test_text_read(test_addr);
ffffffe0002021d4:	fd843503          	ld	a0,-40(s0)
ffffffe0002021d8:	eadff0ef          	jal	ra,ffffffe000202084 <test_text_read>
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
ffffffe0002021dc:	00002517          	auipc	a0,0x2
ffffffe0002021e0:	2dc50513          	addi	a0,a0,732 # ffffffe0002044b8 <_srodata+0x4b8>
ffffffe0002021e4:	71d000ef          	jal	ra,ffffffe000203100 <printk>
    test_text_exec();
ffffffe0002021e8:	f71ff0ef          	jal	ra,ffffffe000202158 <test_text_exec>

    // .rodata
    test_addr = (uint64_t *)va_rodata;
ffffffe0002021ec:	fe043783          	ld	a5,-32(s0)
ffffffe0002021f0:	fcf43c23          	sd	a5,-40(s0)

    // .rodata R
    printk(".rodata read test: \n");
ffffffe0002021f4:	00002517          	auipc	a0,0x2
ffffffe0002021f8:	2dc50513          	addi	a0,a0,732 # ffffffe0002044d0 <_srodata+0x4d0>
ffffffe0002021fc:	705000ef          	jal	ra,ffffffe000203100 <printk>
    uint64_t value = *test_addr;
ffffffe000202200:	fd843783          	ld	a5,-40(s0)
ffffffe000202204:	0007b783          	ld	a5,0(a5)
ffffffe000202208:	fcf43823          	sd	a5,-48(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe00020220c:	fd043583          	ld	a1,-48(s0)
ffffffe000202210:	00002517          	auipc	a0,0x2
ffffffe000202214:	1d050513          	addi	a0,a0,464 # ffffffe0002043e0 <_srodata+0x3e0>
ffffffe000202218:	6e9000ef          	jal	ra,ffffffe000203100 <printk>

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
ffffffe00020221c:	00002517          	auipc	a0,0x2
ffffffe000202220:	2cc50513          	addi	a0,a0,716 # ffffffe0002044e8 <_srodata+0x4e8>
ffffffe000202224:	6dd000ef          	jal	ra,ffffffe000203100 <printk>
ffffffe000202228:	00000013          	nop
ffffffe00020222c:	02813083          	ld	ra,40(sp)
ffffffe000202230:	02013403          	ld	s0,32(sp)
ffffffe000202234:	03010113          	addi	sp,sp,48
ffffffe000202238:	00008067          	ret

ffffffe00020223c <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe00020223c:	fe010113          	addi	sp,sp,-32
ffffffe000202240:	00113c23          	sd	ra,24(sp)
ffffffe000202244:	00813823          	sd	s0,16(sp)
ffffffe000202248:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe00020224c:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe000202250:	00002517          	auipc	a0,0x2
ffffffe000202254:	2b850513          	addi	a0,a0,696 # ffffffe000204508 <_srodata+0x508>
ffffffe000202258:	6a9000ef          	jal	ra,ffffffe000203100 <printk>
    while (1)
    {
        i++;
ffffffe00020225c:	fec42783          	lw	a5,-20(s0)
ffffffe000202260:	0017879b          	addiw	a5,a5,1
ffffffe000202264:	fef42623          	sw	a5,-20(s0)
ffffffe000202268:	ff5ff06f          	j	ffffffe00020225c <test+0x20>

ffffffe00020226c <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe00020226c:	fe010113          	addi	sp,sp,-32
ffffffe000202270:	00113c23          	sd	ra,24(sp)
ffffffe000202274:	00813823          	sd	s0,16(sp)
ffffffe000202278:	02010413          	addi	s0,sp,32
ffffffe00020227c:	00050793          	mv	a5,a0
ffffffe000202280:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe000202284:	fec42783          	lw	a5,-20(s0)
ffffffe000202288:	0ff7f793          	zext.b	a5,a5
ffffffe00020228c:	00078513          	mv	a0,a5
ffffffe000202290:	b88ff0ef          	jal	ra,ffffffe000201618 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000202294:	fec42783          	lw	a5,-20(s0)
ffffffe000202298:	0ff7f793          	zext.b	a5,a5
ffffffe00020229c:	0007879b          	sext.w	a5,a5
}
ffffffe0002022a0:	00078513          	mv	a0,a5
ffffffe0002022a4:	01813083          	ld	ra,24(sp)
ffffffe0002022a8:	01013403          	ld	s0,16(sp)
ffffffe0002022ac:	02010113          	addi	sp,sp,32
ffffffe0002022b0:	00008067          	ret

ffffffe0002022b4 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe0002022b4:	fe010113          	addi	sp,sp,-32
ffffffe0002022b8:	00813c23          	sd	s0,24(sp)
ffffffe0002022bc:	02010413          	addi	s0,sp,32
ffffffe0002022c0:	00050793          	mv	a5,a0
ffffffe0002022c4:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe0002022c8:	fec42783          	lw	a5,-20(s0)
ffffffe0002022cc:	0007871b          	sext.w	a4,a5
ffffffe0002022d0:	02000793          	li	a5,32
ffffffe0002022d4:	02f70263          	beq	a4,a5,ffffffe0002022f8 <isspace+0x44>
ffffffe0002022d8:	fec42783          	lw	a5,-20(s0)
ffffffe0002022dc:	0007871b          	sext.w	a4,a5
ffffffe0002022e0:	00800793          	li	a5,8
ffffffe0002022e4:	00e7de63          	bge	a5,a4,ffffffe000202300 <isspace+0x4c>
ffffffe0002022e8:	fec42783          	lw	a5,-20(s0)
ffffffe0002022ec:	0007871b          	sext.w	a4,a5
ffffffe0002022f0:	00d00793          	li	a5,13
ffffffe0002022f4:	00e7c663          	blt	a5,a4,ffffffe000202300 <isspace+0x4c>
ffffffe0002022f8:	00100793          	li	a5,1
ffffffe0002022fc:	0080006f          	j	ffffffe000202304 <isspace+0x50>
ffffffe000202300:	00000793          	li	a5,0
}
ffffffe000202304:	00078513          	mv	a0,a5
ffffffe000202308:	01813403          	ld	s0,24(sp)
ffffffe00020230c:	02010113          	addi	sp,sp,32
ffffffe000202310:	00008067          	ret

ffffffe000202314 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000202314:	fb010113          	addi	sp,sp,-80
ffffffe000202318:	04113423          	sd	ra,72(sp)
ffffffe00020231c:	04813023          	sd	s0,64(sp)
ffffffe000202320:	05010413          	addi	s0,sp,80
ffffffe000202324:	fca43423          	sd	a0,-56(s0)
ffffffe000202328:	fcb43023          	sd	a1,-64(s0)
ffffffe00020232c:	00060793          	mv	a5,a2
ffffffe000202330:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000202334:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202338:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe00020233c:	fc843783          	ld	a5,-56(s0)
ffffffe000202340:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000202344:	0100006f          	j	ffffffe000202354 <strtol+0x40>
        p++;
ffffffe000202348:	fd843783          	ld	a5,-40(s0)
ffffffe00020234c:	00178793          	addi	a5,a5,1
ffffffe000202350:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000202354:	fd843783          	ld	a5,-40(s0)
ffffffe000202358:	0007c783          	lbu	a5,0(a5)
ffffffe00020235c:	0007879b          	sext.w	a5,a5
ffffffe000202360:	00078513          	mv	a0,a5
ffffffe000202364:	f51ff0ef          	jal	ra,ffffffe0002022b4 <isspace>
ffffffe000202368:	00050793          	mv	a5,a0
ffffffe00020236c:	fc079ee3          	bnez	a5,ffffffe000202348 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000202370:	fd843783          	ld	a5,-40(s0)
ffffffe000202374:	0007c783          	lbu	a5,0(a5)
ffffffe000202378:	00078713          	mv	a4,a5
ffffffe00020237c:	02d00793          	li	a5,45
ffffffe000202380:	00f71e63          	bne	a4,a5,ffffffe00020239c <strtol+0x88>
        neg = true;
ffffffe000202384:	00100793          	li	a5,1
ffffffe000202388:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe00020238c:	fd843783          	ld	a5,-40(s0)
ffffffe000202390:	00178793          	addi	a5,a5,1
ffffffe000202394:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202398:	0240006f          	j	ffffffe0002023bc <strtol+0xa8>
    } else if (*p == '+') {
ffffffe00020239c:	fd843783          	ld	a5,-40(s0)
ffffffe0002023a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002023a4:	00078713          	mv	a4,a5
ffffffe0002023a8:	02b00793          	li	a5,43
ffffffe0002023ac:	00f71863          	bne	a4,a5,ffffffe0002023bc <strtol+0xa8>
        p++;
ffffffe0002023b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002023b4:	00178793          	addi	a5,a5,1
ffffffe0002023b8:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002023bc:	fbc42783          	lw	a5,-68(s0)
ffffffe0002023c0:	0007879b          	sext.w	a5,a5
ffffffe0002023c4:	06079c63          	bnez	a5,ffffffe00020243c <strtol+0x128>
        if (*p == '0') {
ffffffe0002023c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002023cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002023d0:	00078713          	mv	a4,a5
ffffffe0002023d4:	03000793          	li	a5,48
ffffffe0002023d8:	04f71e63          	bne	a4,a5,ffffffe000202434 <strtol+0x120>
            p++;
ffffffe0002023dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002023e0:	00178793          	addi	a5,a5,1
ffffffe0002023e4:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe0002023e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002023ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002023f0:	00078713          	mv	a4,a5
ffffffe0002023f4:	07800793          	li	a5,120
ffffffe0002023f8:	00f70c63          	beq	a4,a5,ffffffe000202410 <strtol+0xfc>
ffffffe0002023fc:	fd843783          	ld	a5,-40(s0)
ffffffe000202400:	0007c783          	lbu	a5,0(a5)
ffffffe000202404:	00078713          	mv	a4,a5
ffffffe000202408:	05800793          	li	a5,88
ffffffe00020240c:	00f71e63          	bne	a4,a5,ffffffe000202428 <strtol+0x114>
                base = 16;
ffffffe000202410:	01000793          	li	a5,16
ffffffe000202414:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202418:	fd843783          	ld	a5,-40(s0)
ffffffe00020241c:	00178793          	addi	a5,a5,1
ffffffe000202420:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202424:	0180006f          	j	ffffffe00020243c <strtol+0x128>
            } else {
                base = 8;
ffffffe000202428:	00800793          	li	a5,8
ffffffe00020242c:	faf42e23          	sw	a5,-68(s0)
ffffffe000202430:	00c0006f          	j	ffffffe00020243c <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202434:	00a00793          	li	a5,10
ffffffe000202438:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe00020243c:	fd843783          	ld	a5,-40(s0)
ffffffe000202440:	0007c783          	lbu	a5,0(a5)
ffffffe000202444:	00078713          	mv	a4,a5
ffffffe000202448:	02f00793          	li	a5,47
ffffffe00020244c:	02e7f863          	bgeu	a5,a4,ffffffe00020247c <strtol+0x168>
ffffffe000202450:	fd843783          	ld	a5,-40(s0)
ffffffe000202454:	0007c783          	lbu	a5,0(a5)
ffffffe000202458:	00078713          	mv	a4,a5
ffffffe00020245c:	03900793          	li	a5,57
ffffffe000202460:	00e7ee63          	bltu	a5,a4,ffffffe00020247c <strtol+0x168>
            digit = *p - '0';
ffffffe000202464:	fd843783          	ld	a5,-40(s0)
ffffffe000202468:	0007c783          	lbu	a5,0(a5)
ffffffe00020246c:	0007879b          	sext.w	a5,a5
ffffffe000202470:	fd07879b          	addiw	a5,a5,-48
ffffffe000202474:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202478:	0800006f          	j	ffffffe0002024f8 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe00020247c:	fd843783          	ld	a5,-40(s0)
ffffffe000202480:	0007c783          	lbu	a5,0(a5)
ffffffe000202484:	00078713          	mv	a4,a5
ffffffe000202488:	06000793          	li	a5,96
ffffffe00020248c:	02e7f863          	bgeu	a5,a4,ffffffe0002024bc <strtol+0x1a8>
ffffffe000202490:	fd843783          	ld	a5,-40(s0)
ffffffe000202494:	0007c783          	lbu	a5,0(a5)
ffffffe000202498:	00078713          	mv	a4,a5
ffffffe00020249c:	07a00793          	li	a5,122
ffffffe0002024a0:	00e7ee63          	bltu	a5,a4,ffffffe0002024bc <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe0002024a4:	fd843783          	ld	a5,-40(s0)
ffffffe0002024a8:	0007c783          	lbu	a5,0(a5)
ffffffe0002024ac:	0007879b          	sext.w	a5,a5
ffffffe0002024b0:	fa97879b          	addiw	a5,a5,-87
ffffffe0002024b4:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002024b8:	0400006f          	j	ffffffe0002024f8 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002024bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002024c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002024c4:	00078713          	mv	a4,a5
ffffffe0002024c8:	04000793          	li	a5,64
ffffffe0002024cc:	06e7f863          	bgeu	a5,a4,ffffffe00020253c <strtol+0x228>
ffffffe0002024d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002024d4:	0007c783          	lbu	a5,0(a5)
ffffffe0002024d8:	00078713          	mv	a4,a5
ffffffe0002024dc:	05a00793          	li	a5,90
ffffffe0002024e0:	04e7ee63          	bltu	a5,a4,ffffffe00020253c <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe0002024e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002024e8:	0007c783          	lbu	a5,0(a5)
ffffffe0002024ec:	0007879b          	sext.w	a5,a5
ffffffe0002024f0:	fc97879b          	addiw	a5,a5,-55
ffffffe0002024f4:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe0002024f8:	fd442783          	lw	a5,-44(s0)
ffffffe0002024fc:	00078713          	mv	a4,a5
ffffffe000202500:	fbc42783          	lw	a5,-68(s0)
ffffffe000202504:	0007071b          	sext.w	a4,a4
ffffffe000202508:	0007879b          	sext.w	a5,a5
ffffffe00020250c:	02f75663          	bge	a4,a5,ffffffe000202538 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000202510:	fbc42703          	lw	a4,-68(s0)
ffffffe000202514:	fe843783          	ld	a5,-24(s0)
ffffffe000202518:	02f70733          	mul	a4,a4,a5
ffffffe00020251c:	fd442783          	lw	a5,-44(s0)
ffffffe000202520:	00f707b3          	add	a5,a4,a5
ffffffe000202524:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000202528:	fd843783          	ld	a5,-40(s0)
ffffffe00020252c:	00178793          	addi	a5,a5,1
ffffffe000202530:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000202534:	f09ff06f          	j	ffffffe00020243c <strtol+0x128>
            break;
ffffffe000202538:	00000013          	nop
    }

    if (endptr) {
ffffffe00020253c:	fc043783          	ld	a5,-64(s0)
ffffffe000202540:	00078863          	beqz	a5,ffffffe000202550 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000202544:	fc043783          	ld	a5,-64(s0)
ffffffe000202548:	fd843703          	ld	a4,-40(s0)
ffffffe00020254c:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000202550:	fe744783          	lbu	a5,-25(s0)
ffffffe000202554:	0ff7f793          	zext.b	a5,a5
ffffffe000202558:	00078863          	beqz	a5,ffffffe000202568 <strtol+0x254>
ffffffe00020255c:	fe843783          	ld	a5,-24(s0)
ffffffe000202560:	40f007b3          	neg	a5,a5
ffffffe000202564:	0080006f          	j	ffffffe00020256c <strtol+0x258>
ffffffe000202568:	fe843783          	ld	a5,-24(s0)
}
ffffffe00020256c:	00078513          	mv	a0,a5
ffffffe000202570:	04813083          	ld	ra,72(sp)
ffffffe000202574:	04013403          	ld	s0,64(sp)
ffffffe000202578:	05010113          	addi	sp,sp,80
ffffffe00020257c:	00008067          	ret

ffffffe000202580 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe000202580:	fd010113          	addi	sp,sp,-48
ffffffe000202584:	02113423          	sd	ra,40(sp)
ffffffe000202588:	02813023          	sd	s0,32(sp)
ffffffe00020258c:	03010413          	addi	s0,sp,48
ffffffe000202590:	fca43c23          	sd	a0,-40(s0)
ffffffe000202594:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe000202598:	fd043783          	ld	a5,-48(s0)
ffffffe00020259c:	00079863          	bnez	a5,ffffffe0002025ac <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002025a0:	00002797          	auipc	a5,0x2
ffffffe0002025a4:	f8078793          	addi	a5,a5,-128 # ffffffe000204520 <_srodata+0x520>
ffffffe0002025a8:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002025ac:	fd043783          	ld	a5,-48(s0)
ffffffe0002025b0:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002025b4:	0240006f          	j	ffffffe0002025d8 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002025b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002025bc:	00178713          	addi	a4,a5,1
ffffffe0002025c0:	fee43423          	sd	a4,-24(s0)
ffffffe0002025c4:	0007c783          	lbu	a5,0(a5)
ffffffe0002025c8:	0007871b          	sext.w	a4,a5
ffffffe0002025cc:	fd843783          	ld	a5,-40(s0)
ffffffe0002025d0:	00070513          	mv	a0,a4
ffffffe0002025d4:	000780e7          	jalr	a5
    while (*p) {
ffffffe0002025d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002025dc:	0007c783          	lbu	a5,0(a5)
ffffffe0002025e0:	fc079ce3          	bnez	a5,ffffffe0002025b8 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe0002025e4:	fe843703          	ld	a4,-24(s0)
ffffffe0002025e8:	fd043783          	ld	a5,-48(s0)
ffffffe0002025ec:	40f707b3          	sub	a5,a4,a5
ffffffe0002025f0:	0007879b          	sext.w	a5,a5
}
ffffffe0002025f4:	00078513          	mv	a0,a5
ffffffe0002025f8:	02813083          	ld	ra,40(sp)
ffffffe0002025fc:	02013403          	ld	s0,32(sp)
ffffffe000202600:	03010113          	addi	sp,sp,48
ffffffe000202604:	00008067          	ret

ffffffe000202608 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000202608:	f9010113          	addi	sp,sp,-112
ffffffe00020260c:	06113423          	sd	ra,104(sp)
ffffffe000202610:	06813023          	sd	s0,96(sp)
ffffffe000202614:	07010413          	addi	s0,sp,112
ffffffe000202618:	faa43423          	sd	a0,-88(s0)
ffffffe00020261c:	fab43023          	sd	a1,-96(s0)
ffffffe000202620:	00060793          	mv	a5,a2
ffffffe000202624:	f8d43823          	sd	a3,-112(s0)
ffffffe000202628:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe00020262c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202630:	0ff7f793          	zext.b	a5,a5
ffffffe000202634:	02078663          	beqz	a5,ffffffe000202660 <print_dec_int+0x58>
ffffffe000202638:	fa043703          	ld	a4,-96(s0)
ffffffe00020263c:	fff00793          	li	a5,-1
ffffffe000202640:	03f79793          	slli	a5,a5,0x3f
ffffffe000202644:	00f71e63          	bne	a4,a5,ffffffe000202660 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000202648:	00002597          	auipc	a1,0x2
ffffffe00020264c:	ee058593          	addi	a1,a1,-288 # ffffffe000204528 <_srodata+0x528>
ffffffe000202650:	fa843503          	ld	a0,-88(s0)
ffffffe000202654:	f2dff0ef          	jal	ra,ffffffe000202580 <puts_wo_nl>
ffffffe000202658:	00050793          	mv	a5,a0
ffffffe00020265c:	2a00006f          	j	ffffffe0002028fc <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202660:	f9043783          	ld	a5,-112(s0)
ffffffe000202664:	00c7a783          	lw	a5,12(a5)
ffffffe000202668:	00079a63          	bnez	a5,ffffffe00020267c <print_dec_int+0x74>
ffffffe00020266c:	fa043783          	ld	a5,-96(s0)
ffffffe000202670:	00079663          	bnez	a5,ffffffe00020267c <print_dec_int+0x74>
        return 0;
ffffffe000202674:	00000793          	li	a5,0
ffffffe000202678:	2840006f          	j	ffffffe0002028fc <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe00020267c:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000202680:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202684:	0ff7f793          	zext.b	a5,a5
ffffffe000202688:	02078063          	beqz	a5,ffffffe0002026a8 <print_dec_int+0xa0>
ffffffe00020268c:	fa043783          	ld	a5,-96(s0)
ffffffe000202690:	0007dc63          	bgez	a5,ffffffe0002026a8 <print_dec_int+0xa0>
        neg = true;
ffffffe000202694:	00100793          	li	a5,1
ffffffe000202698:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe00020269c:	fa043783          	ld	a5,-96(s0)
ffffffe0002026a0:	40f007b3          	neg	a5,a5
ffffffe0002026a4:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe0002026a8:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe0002026ac:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002026b0:	0ff7f793          	zext.b	a5,a5
ffffffe0002026b4:	02078863          	beqz	a5,ffffffe0002026e4 <print_dec_int+0xdc>
ffffffe0002026b8:	fef44783          	lbu	a5,-17(s0)
ffffffe0002026bc:	0ff7f793          	zext.b	a5,a5
ffffffe0002026c0:	00079e63          	bnez	a5,ffffffe0002026dc <print_dec_int+0xd4>
ffffffe0002026c4:	f9043783          	ld	a5,-112(s0)
ffffffe0002026c8:	0057c783          	lbu	a5,5(a5)
ffffffe0002026cc:	00079863          	bnez	a5,ffffffe0002026dc <print_dec_int+0xd4>
ffffffe0002026d0:	f9043783          	ld	a5,-112(s0)
ffffffe0002026d4:	0047c783          	lbu	a5,4(a5)
ffffffe0002026d8:	00078663          	beqz	a5,ffffffe0002026e4 <print_dec_int+0xdc>
ffffffe0002026dc:	00100793          	li	a5,1
ffffffe0002026e0:	0080006f          	j	ffffffe0002026e8 <print_dec_int+0xe0>
ffffffe0002026e4:	00000793          	li	a5,0
ffffffe0002026e8:	fcf40ba3          	sb	a5,-41(s0)
ffffffe0002026ec:	fd744783          	lbu	a5,-41(s0)
ffffffe0002026f0:	0017f793          	andi	a5,a5,1
ffffffe0002026f4:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe0002026f8:	fa043703          	ld	a4,-96(s0)
ffffffe0002026fc:	00a00793          	li	a5,10
ffffffe000202700:	02f777b3          	remu	a5,a4,a5
ffffffe000202704:	0ff7f713          	zext.b	a4,a5
ffffffe000202708:	fe842783          	lw	a5,-24(s0)
ffffffe00020270c:	0017869b          	addiw	a3,a5,1
ffffffe000202710:	fed42423          	sw	a3,-24(s0)
ffffffe000202714:	0307071b          	addiw	a4,a4,48
ffffffe000202718:	0ff77713          	zext.b	a4,a4
ffffffe00020271c:	ff078793          	addi	a5,a5,-16
ffffffe000202720:	008787b3          	add	a5,a5,s0
ffffffe000202724:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000202728:	fa043703          	ld	a4,-96(s0)
ffffffe00020272c:	00a00793          	li	a5,10
ffffffe000202730:	02f757b3          	divu	a5,a4,a5
ffffffe000202734:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000202738:	fa043783          	ld	a5,-96(s0)
ffffffe00020273c:	fa079ee3          	bnez	a5,ffffffe0002026f8 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202740:	f9043783          	ld	a5,-112(s0)
ffffffe000202744:	00c7a783          	lw	a5,12(a5)
ffffffe000202748:	00078713          	mv	a4,a5
ffffffe00020274c:	fff00793          	li	a5,-1
ffffffe000202750:	02f71063          	bne	a4,a5,ffffffe000202770 <print_dec_int+0x168>
ffffffe000202754:	f9043783          	ld	a5,-112(s0)
ffffffe000202758:	0037c783          	lbu	a5,3(a5)
ffffffe00020275c:	00078a63          	beqz	a5,ffffffe000202770 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000202760:	f9043783          	ld	a5,-112(s0)
ffffffe000202764:	0087a703          	lw	a4,8(a5)
ffffffe000202768:	f9043783          	ld	a5,-112(s0)
ffffffe00020276c:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000202770:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202774:	f9043783          	ld	a5,-112(s0)
ffffffe000202778:	0087a703          	lw	a4,8(a5)
ffffffe00020277c:	fe842783          	lw	a5,-24(s0)
ffffffe000202780:	fcf42823          	sw	a5,-48(s0)
ffffffe000202784:	f9043783          	ld	a5,-112(s0)
ffffffe000202788:	00c7a783          	lw	a5,12(a5)
ffffffe00020278c:	fcf42623          	sw	a5,-52(s0)
ffffffe000202790:	fd042783          	lw	a5,-48(s0)
ffffffe000202794:	00078593          	mv	a1,a5
ffffffe000202798:	fcc42783          	lw	a5,-52(s0)
ffffffe00020279c:	00078613          	mv	a2,a5
ffffffe0002027a0:	0006069b          	sext.w	a3,a2
ffffffe0002027a4:	0005879b          	sext.w	a5,a1
ffffffe0002027a8:	00f6d463          	bge	a3,a5,ffffffe0002027b0 <print_dec_int+0x1a8>
ffffffe0002027ac:	00058613          	mv	a2,a1
ffffffe0002027b0:	0006079b          	sext.w	a5,a2
ffffffe0002027b4:	40f707bb          	subw	a5,a4,a5
ffffffe0002027b8:	0007871b          	sext.w	a4,a5
ffffffe0002027bc:	fd744783          	lbu	a5,-41(s0)
ffffffe0002027c0:	0007879b          	sext.w	a5,a5
ffffffe0002027c4:	40f707bb          	subw	a5,a4,a5
ffffffe0002027c8:	fef42023          	sw	a5,-32(s0)
ffffffe0002027cc:	0280006f          	j	ffffffe0002027f4 <print_dec_int+0x1ec>
        putch(' ');
ffffffe0002027d0:	fa843783          	ld	a5,-88(s0)
ffffffe0002027d4:	02000513          	li	a0,32
ffffffe0002027d8:	000780e7          	jalr	a5
        ++written;
ffffffe0002027dc:	fe442783          	lw	a5,-28(s0)
ffffffe0002027e0:	0017879b          	addiw	a5,a5,1
ffffffe0002027e4:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002027e8:	fe042783          	lw	a5,-32(s0)
ffffffe0002027ec:	fff7879b          	addiw	a5,a5,-1
ffffffe0002027f0:	fef42023          	sw	a5,-32(s0)
ffffffe0002027f4:	fe042783          	lw	a5,-32(s0)
ffffffe0002027f8:	0007879b          	sext.w	a5,a5
ffffffe0002027fc:	fcf04ae3          	bgtz	a5,ffffffe0002027d0 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000202800:	fd744783          	lbu	a5,-41(s0)
ffffffe000202804:	0ff7f793          	zext.b	a5,a5
ffffffe000202808:	04078463          	beqz	a5,ffffffe000202850 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe00020280c:	fef44783          	lbu	a5,-17(s0)
ffffffe000202810:	0ff7f793          	zext.b	a5,a5
ffffffe000202814:	00078663          	beqz	a5,ffffffe000202820 <print_dec_int+0x218>
ffffffe000202818:	02d00793          	li	a5,45
ffffffe00020281c:	01c0006f          	j	ffffffe000202838 <print_dec_int+0x230>
ffffffe000202820:	f9043783          	ld	a5,-112(s0)
ffffffe000202824:	0057c783          	lbu	a5,5(a5)
ffffffe000202828:	00078663          	beqz	a5,ffffffe000202834 <print_dec_int+0x22c>
ffffffe00020282c:	02b00793          	li	a5,43
ffffffe000202830:	0080006f          	j	ffffffe000202838 <print_dec_int+0x230>
ffffffe000202834:	02000793          	li	a5,32
ffffffe000202838:	fa843703          	ld	a4,-88(s0)
ffffffe00020283c:	00078513          	mv	a0,a5
ffffffe000202840:	000700e7          	jalr	a4
        ++written;
ffffffe000202844:	fe442783          	lw	a5,-28(s0)
ffffffe000202848:	0017879b          	addiw	a5,a5,1
ffffffe00020284c:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202850:	fe842783          	lw	a5,-24(s0)
ffffffe000202854:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202858:	0280006f          	j	ffffffe000202880 <print_dec_int+0x278>
        putch('0');
ffffffe00020285c:	fa843783          	ld	a5,-88(s0)
ffffffe000202860:	03000513          	li	a0,48
ffffffe000202864:	000780e7          	jalr	a5
        ++written;
ffffffe000202868:	fe442783          	lw	a5,-28(s0)
ffffffe00020286c:	0017879b          	addiw	a5,a5,1
ffffffe000202870:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202874:	fdc42783          	lw	a5,-36(s0)
ffffffe000202878:	0017879b          	addiw	a5,a5,1
ffffffe00020287c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202880:	f9043783          	ld	a5,-112(s0)
ffffffe000202884:	00c7a703          	lw	a4,12(a5)
ffffffe000202888:	fd744783          	lbu	a5,-41(s0)
ffffffe00020288c:	0007879b          	sext.w	a5,a5
ffffffe000202890:	40f707bb          	subw	a5,a4,a5
ffffffe000202894:	0007871b          	sext.w	a4,a5
ffffffe000202898:	fdc42783          	lw	a5,-36(s0)
ffffffe00020289c:	0007879b          	sext.w	a5,a5
ffffffe0002028a0:	fae7cee3          	blt	a5,a4,ffffffe00020285c <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002028a4:	fe842783          	lw	a5,-24(s0)
ffffffe0002028a8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002028ac:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002028b0:	03c0006f          	j	ffffffe0002028ec <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe0002028b4:	fd842783          	lw	a5,-40(s0)
ffffffe0002028b8:	ff078793          	addi	a5,a5,-16
ffffffe0002028bc:	008787b3          	add	a5,a5,s0
ffffffe0002028c0:	fc87c783          	lbu	a5,-56(a5)
ffffffe0002028c4:	0007871b          	sext.w	a4,a5
ffffffe0002028c8:	fa843783          	ld	a5,-88(s0)
ffffffe0002028cc:	00070513          	mv	a0,a4
ffffffe0002028d0:	000780e7          	jalr	a5
        ++written;
ffffffe0002028d4:	fe442783          	lw	a5,-28(s0)
ffffffe0002028d8:	0017879b          	addiw	a5,a5,1
ffffffe0002028dc:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002028e0:	fd842783          	lw	a5,-40(s0)
ffffffe0002028e4:	fff7879b          	addiw	a5,a5,-1
ffffffe0002028e8:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002028ec:	fd842783          	lw	a5,-40(s0)
ffffffe0002028f0:	0007879b          	sext.w	a5,a5
ffffffe0002028f4:	fc07d0e3          	bgez	a5,ffffffe0002028b4 <print_dec_int+0x2ac>
    }

    return written;
ffffffe0002028f8:	fe442783          	lw	a5,-28(s0)
}
ffffffe0002028fc:	00078513          	mv	a0,a5
ffffffe000202900:	06813083          	ld	ra,104(sp)
ffffffe000202904:	06013403          	ld	s0,96(sp)
ffffffe000202908:	07010113          	addi	sp,sp,112
ffffffe00020290c:	00008067          	ret

ffffffe000202910 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000202910:	f4010113          	addi	sp,sp,-192
ffffffe000202914:	0a113c23          	sd	ra,184(sp)
ffffffe000202918:	0a813823          	sd	s0,176(sp)
ffffffe00020291c:	0c010413          	addi	s0,sp,192
ffffffe000202920:	f4a43c23          	sd	a0,-168(s0)
ffffffe000202924:	f4b43823          	sd	a1,-176(s0)
ffffffe000202928:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe00020292c:	f8043023          	sd	zero,-128(s0)
ffffffe000202930:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000202934:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000202938:	7a40006f          	j	ffffffe0002030dc <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe00020293c:	f8044783          	lbu	a5,-128(s0)
ffffffe000202940:	72078e63          	beqz	a5,ffffffe00020307c <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000202944:	f5043783          	ld	a5,-176(s0)
ffffffe000202948:	0007c783          	lbu	a5,0(a5)
ffffffe00020294c:	00078713          	mv	a4,a5
ffffffe000202950:	02300793          	li	a5,35
ffffffe000202954:	00f71863          	bne	a4,a5,ffffffe000202964 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000202958:	00100793          	li	a5,1
ffffffe00020295c:	f8f40123          	sb	a5,-126(s0)
ffffffe000202960:	7700006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000202964:	f5043783          	ld	a5,-176(s0)
ffffffe000202968:	0007c783          	lbu	a5,0(a5)
ffffffe00020296c:	00078713          	mv	a4,a5
ffffffe000202970:	03000793          	li	a5,48
ffffffe000202974:	00f71863          	bne	a4,a5,ffffffe000202984 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000202978:	00100793          	li	a5,1
ffffffe00020297c:	f8f401a3          	sb	a5,-125(s0)
ffffffe000202980:	7500006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000202984:	f5043783          	ld	a5,-176(s0)
ffffffe000202988:	0007c783          	lbu	a5,0(a5)
ffffffe00020298c:	00078713          	mv	a4,a5
ffffffe000202990:	06c00793          	li	a5,108
ffffffe000202994:	04f70063          	beq	a4,a5,ffffffe0002029d4 <vprintfmt+0xc4>
ffffffe000202998:	f5043783          	ld	a5,-176(s0)
ffffffe00020299c:	0007c783          	lbu	a5,0(a5)
ffffffe0002029a0:	00078713          	mv	a4,a5
ffffffe0002029a4:	07a00793          	li	a5,122
ffffffe0002029a8:	02f70663          	beq	a4,a5,ffffffe0002029d4 <vprintfmt+0xc4>
ffffffe0002029ac:	f5043783          	ld	a5,-176(s0)
ffffffe0002029b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002029b4:	00078713          	mv	a4,a5
ffffffe0002029b8:	07400793          	li	a5,116
ffffffe0002029bc:	00f70c63          	beq	a4,a5,ffffffe0002029d4 <vprintfmt+0xc4>
ffffffe0002029c0:	f5043783          	ld	a5,-176(s0)
ffffffe0002029c4:	0007c783          	lbu	a5,0(a5)
ffffffe0002029c8:	00078713          	mv	a4,a5
ffffffe0002029cc:	06a00793          	li	a5,106
ffffffe0002029d0:	00f71863          	bne	a4,a5,ffffffe0002029e0 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe0002029d4:	00100793          	li	a5,1
ffffffe0002029d8:	f8f400a3          	sb	a5,-127(s0)
ffffffe0002029dc:	6f40006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe0002029e0:	f5043783          	ld	a5,-176(s0)
ffffffe0002029e4:	0007c783          	lbu	a5,0(a5)
ffffffe0002029e8:	00078713          	mv	a4,a5
ffffffe0002029ec:	02b00793          	li	a5,43
ffffffe0002029f0:	00f71863          	bne	a4,a5,ffffffe000202a00 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe0002029f4:	00100793          	li	a5,1
ffffffe0002029f8:	f8f402a3          	sb	a5,-123(s0)
ffffffe0002029fc:	6d40006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000202a00:	f5043783          	ld	a5,-176(s0)
ffffffe000202a04:	0007c783          	lbu	a5,0(a5)
ffffffe000202a08:	00078713          	mv	a4,a5
ffffffe000202a0c:	02000793          	li	a5,32
ffffffe000202a10:	00f71863          	bne	a4,a5,ffffffe000202a20 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000202a14:	00100793          	li	a5,1
ffffffe000202a18:	f8f40223          	sb	a5,-124(s0)
ffffffe000202a1c:	6b40006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000202a20:	f5043783          	ld	a5,-176(s0)
ffffffe000202a24:	0007c783          	lbu	a5,0(a5)
ffffffe000202a28:	00078713          	mv	a4,a5
ffffffe000202a2c:	02a00793          	li	a5,42
ffffffe000202a30:	00f71e63          	bne	a4,a5,ffffffe000202a4c <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000202a34:	f4843783          	ld	a5,-184(s0)
ffffffe000202a38:	00878713          	addi	a4,a5,8
ffffffe000202a3c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202a40:	0007a783          	lw	a5,0(a5)
ffffffe000202a44:	f8f42423          	sw	a5,-120(s0)
ffffffe000202a48:	6880006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000202a4c:	f5043783          	ld	a5,-176(s0)
ffffffe000202a50:	0007c783          	lbu	a5,0(a5)
ffffffe000202a54:	00078713          	mv	a4,a5
ffffffe000202a58:	03000793          	li	a5,48
ffffffe000202a5c:	04e7f663          	bgeu	a5,a4,ffffffe000202aa8 <vprintfmt+0x198>
ffffffe000202a60:	f5043783          	ld	a5,-176(s0)
ffffffe000202a64:	0007c783          	lbu	a5,0(a5)
ffffffe000202a68:	00078713          	mv	a4,a5
ffffffe000202a6c:	03900793          	li	a5,57
ffffffe000202a70:	02e7ec63          	bltu	a5,a4,ffffffe000202aa8 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000202a74:	f5043783          	ld	a5,-176(s0)
ffffffe000202a78:	f5040713          	addi	a4,s0,-176
ffffffe000202a7c:	00a00613          	li	a2,10
ffffffe000202a80:	00070593          	mv	a1,a4
ffffffe000202a84:	00078513          	mv	a0,a5
ffffffe000202a88:	88dff0ef          	jal	ra,ffffffe000202314 <strtol>
ffffffe000202a8c:	00050793          	mv	a5,a0
ffffffe000202a90:	0007879b          	sext.w	a5,a5
ffffffe000202a94:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000202a98:	f5043783          	ld	a5,-176(s0)
ffffffe000202a9c:	fff78793          	addi	a5,a5,-1
ffffffe000202aa0:	f4f43823          	sd	a5,-176(s0)
ffffffe000202aa4:	62c0006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000202aa8:	f5043783          	ld	a5,-176(s0)
ffffffe000202aac:	0007c783          	lbu	a5,0(a5)
ffffffe000202ab0:	00078713          	mv	a4,a5
ffffffe000202ab4:	02e00793          	li	a5,46
ffffffe000202ab8:	06f71863          	bne	a4,a5,ffffffe000202b28 <vprintfmt+0x218>
                fmt++;
ffffffe000202abc:	f5043783          	ld	a5,-176(s0)
ffffffe000202ac0:	00178793          	addi	a5,a5,1
ffffffe000202ac4:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000202ac8:	f5043783          	ld	a5,-176(s0)
ffffffe000202acc:	0007c783          	lbu	a5,0(a5)
ffffffe000202ad0:	00078713          	mv	a4,a5
ffffffe000202ad4:	02a00793          	li	a5,42
ffffffe000202ad8:	00f71e63          	bne	a4,a5,ffffffe000202af4 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000202adc:	f4843783          	ld	a5,-184(s0)
ffffffe000202ae0:	00878713          	addi	a4,a5,8
ffffffe000202ae4:	f4e43423          	sd	a4,-184(s0)
ffffffe000202ae8:	0007a783          	lw	a5,0(a5)
ffffffe000202aec:	f8f42623          	sw	a5,-116(s0)
ffffffe000202af0:	5e00006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000202af4:	f5043783          	ld	a5,-176(s0)
ffffffe000202af8:	f5040713          	addi	a4,s0,-176
ffffffe000202afc:	00a00613          	li	a2,10
ffffffe000202b00:	00070593          	mv	a1,a4
ffffffe000202b04:	00078513          	mv	a0,a5
ffffffe000202b08:	80dff0ef          	jal	ra,ffffffe000202314 <strtol>
ffffffe000202b0c:	00050793          	mv	a5,a0
ffffffe000202b10:	0007879b          	sext.w	a5,a5
ffffffe000202b14:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000202b18:	f5043783          	ld	a5,-176(s0)
ffffffe000202b1c:	fff78793          	addi	a5,a5,-1
ffffffe000202b20:	f4f43823          	sd	a5,-176(s0)
ffffffe000202b24:	5ac0006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202b28:	f5043783          	ld	a5,-176(s0)
ffffffe000202b2c:	0007c783          	lbu	a5,0(a5)
ffffffe000202b30:	00078713          	mv	a4,a5
ffffffe000202b34:	07800793          	li	a5,120
ffffffe000202b38:	02f70663          	beq	a4,a5,ffffffe000202b64 <vprintfmt+0x254>
ffffffe000202b3c:	f5043783          	ld	a5,-176(s0)
ffffffe000202b40:	0007c783          	lbu	a5,0(a5)
ffffffe000202b44:	00078713          	mv	a4,a5
ffffffe000202b48:	05800793          	li	a5,88
ffffffe000202b4c:	00f70c63          	beq	a4,a5,ffffffe000202b64 <vprintfmt+0x254>
ffffffe000202b50:	f5043783          	ld	a5,-176(s0)
ffffffe000202b54:	0007c783          	lbu	a5,0(a5)
ffffffe000202b58:	00078713          	mv	a4,a5
ffffffe000202b5c:	07000793          	li	a5,112
ffffffe000202b60:	30f71263          	bne	a4,a5,ffffffe000202e64 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000202b64:	f5043783          	ld	a5,-176(s0)
ffffffe000202b68:	0007c783          	lbu	a5,0(a5)
ffffffe000202b6c:	00078713          	mv	a4,a5
ffffffe000202b70:	07000793          	li	a5,112
ffffffe000202b74:	00f70663          	beq	a4,a5,ffffffe000202b80 <vprintfmt+0x270>
ffffffe000202b78:	f8144783          	lbu	a5,-127(s0)
ffffffe000202b7c:	00078663          	beqz	a5,ffffffe000202b88 <vprintfmt+0x278>
ffffffe000202b80:	00100793          	li	a5,1
ffffffe000202b84:	0080006f          	j	ffffffe000202b8c <vprintfmt+0x27c>
ffffffe000202b88:	00000793          	li	a5,0
ffffffe000202b8c:	faf403a3          	sb	a5,-89(s0)
ffffffe000202b90:	fa744783          	lbu	a5,-89(s0)
ffffffe000202b94:	0017f793          	andi	a5,a5,1
ffffffe000202b98:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000202b9c:	fa744783          	lbu	a5,-89(s0)
ffffffe000202ba0:	0ff7f793          	zext.b	a5,a5
ffffffe000202ba4:	00078c63          	beqz	a5,ffffffe000202bbc <vprintfmt+0x2ac>
ffffffe000202ba8:	f4843783          	ld	a5,-184(s0)
ffffffe000202bac:	00878713          	addi	a4,a5,8
ffffffe000202bb0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202bb4:	0007b783          	ld	a5,0(a5)
ffffffe000202bb8:	01c0006f          	j	ffffffe000202bd4 <vprintfmt+0x2c4>
ffffffe000202bbc:	f4843783          	ld	a5,-184(s0)
ffffffe000202bc0:	00878713          	addi	a4,a5,8
ffffffe000202bc4:	f4e43423          	sd	a4,-184(s0)
ffffffe000202bc8:	0007a783          	lw	a5,0(a5)
ffffffe000202bcc:	02079793          	slli	a5,a5,0x20
ffffffe000202bd0:	0207d793          	srli	a5,a5,0x20
ffffffe000202bd4:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000202bd8:	f8c42783          	lw	a5,-116(s0)
ffffffe000202bdc:	02079463          	bnez	a5,ffffffe000202c04 <vprintfmt+0x2f4>
ffffffe000202be0:	fe043783          	ld	a5,-32(s0)
ffffffe000202be4:	02079063          	bnez	a5,ffffffe000202c04 <vprintfmt+0x2f4>
ffffffe000202be8:	f5043783          	ld	a5,-176(s0)
ffffffe000202bec:	0007c783          	lbu	a5,0(a5)
ffffffe000202bf0:	00078713          	mv	a4,a5
ffffffe000202bf4:	07000793          	li	a5,112
ffffffe000202bf8:	00f70663          	beq	a4,a5,ffffffe000202c04 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000202bfc:	f8040023          	sb	zero,-128(s0)
ffffffe000202c00:	4d00006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000202c04:	f5043783          	ld	a5,-176(s0)
ffffffe000202c08:	0007c783          	lbu	a5,0(a5)
ffffffe000202c0c:	00078713          	mv	a4,a5
ffffffe000202c10:	07000793          	li	a5,112
ffffffe000202c14:	00f70a63          	beq	a4,a5,ffffffe000202c28 <vprintfmt+0x318>
ffffffe000202c18:	f8244783          	lbu	a5,-126(s0)
ffffffe000202c1c:	00078a63          	beqz	a5,ffffffe000202c30 <vprintfmt+0x320>
ffffffe000202c20:	fe043783          	ld	a5,-32(s0)
ffffffe000202c24:	00078663          	beqz	a5,ffffffe000202c30 <vprintfmt+0x320>
ffffffe000202c28:	00100793          	li	a5,1
ffffffe000202c2c:	0080006f          	j	ffffffe000202c34 <vprintfmt+0x324>
ffffffe000202c30:	00000793          	li	a5,0
ffffffe000202c34:	faf40323          	sb	a5,-90(s0)
ffffffe000202c38:	fa644783          	lbu	a5,-90(s0)
ffffffe000202c3c:	0017f793          	andi	a5,a5,1
ffffffe000202c40:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000202c44:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000202c48:	f5043783          	ld	a5,-176(s0)
ffffffe000202c4c:	0007c783          	lbu	a5,0(a5)
ffffffe000202c50:	00078713          	mv	a4,a5
ffffffe000202c54:	05800793          	li	a5,88
ffffffe000202c58:	00f71863          	bne	a4,a5,ffffffe000202c68 <vprintfmt+0x358>
ffffffe000202c5c:	00002797          	auipc	a5,0x2
ffffffe000202c60:	8e478793          	addi	a5,a5,-1820 # ffffffe000204540 <upperxdigits.1>
ffffffe000202c64:	00c0006f          	j	ffffffe000202c70 <vprintfmt+0x360>
ffffffe000202c68:	00002797          	auipc	a5,0x2
ffffffe000202c6c:	8f078793          	addi	a5,a5,-1808 # ffffffe000204558 <lowerxdigits.0>
ffffffe000202c70:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000202c74:	fe043783          	ld	a5,-32(s0)
ffffffe000202c78:	00f7f793          	andi	a5,a5,15
ffffffe000202c7c:	f9843703          	ld	a4,-104(s0)
ffffffe000202c80:	00f70733          	add	a4,a4,a5
ffffffe000202c84:	fdc42783          	lw	a5,-36(s0)
ffffffe000202c88:	0017869b          	addiw	a3,a5,1
ffffffe000202c8c:	fcd42e23          	sw	a3,-36(s0)
ffffffe000202c90:	00074703          	lbu	a4,0(a4)
ffffffe000202c94:	ff078793          	addi	a5,a5,-16
ffffffe000202c98:	008787b3          	add	a5,a5,s0
ffffffe000202c9c:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000202ca0:	fe043783          	ld	a5,-32(s0)
ffffffe000202ca4:	0047d793          	srli	a5,a5,0x4
ffffffe000202ca8:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000202cac:	fe043783          	ld	a5,-32(s0)
ffffffe000202cb0:	fc0792e3          	bnez	a5,ffffffe000202c74 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000202cb4:	f8c42783          	lw	a5,-116(s0)
ffffffe000202cb8:	00078713          	mv	a4,a5
ffffffe000202cbc:	fff00793          	li	a5,-1
ffffffe000202cc0:	02f71663          	bne	a4,a5,ffffffe000202cec <vprintfmt+0x3dc>
ffffffe000202cc4:	f8344783          	lbu	a5,-125(s0)
ffffffe000202cc8:	02078263          	beqz	a5,ffffffe000202cec <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000202ccc:	f8842703          	lw	a4,-120(s0)
ffffffe000202cd0:	fa644783          	lbu	a5,-90(s0)
ffffffe000202cd4:	0007879b          	sext.w	a5,a5
ffffffe000202cd8:	0017979b          	slliw	a5,a5,0x1
ffffffe000202cdc:	0007879b          	sext.w	a5,a5
ffffffe000202ce0:	40f707bb          	subw	a5,a4,a5
ffffffe000202ce4:	0007879b          	sext.w	a5,a5
ffffffe000202ce8:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202cec:	f8842703          	lw	a4,-120(s0)
ffffffe000202cf0:	fa644783          	lbu	a5,-90(s0)
ffffffe000202cf4:	0007879b          	sext.w	a5,a5
ffffffe000202cf8:	0017979b          	slliw	a5,a5,0x1
ffffffe000202cfc:	0007879b          	sext.w	a5,a5
ffffffe000202d00:	40f707bb          	subw	a5,a4,a5
ffffffe000202d04:	0007871b          	sext.w	a4,a5
ffffffe000202d08:	fdc42783          	lw	a5,-36(s0)
ffffffe000202d0c:	f8f42a23          	sw	a5,-108(s0)
ffffffe000202d10:	f8c42783          	lw	a5,-116(s0)
ffffffe000202d14:	f8f42823          	sw	a5,-112(s0)
ffffffe000202d18:	f9442783          	lw	a5,-108(s0)
ffffffe000202d1c:	00078593          	mv	a1,a5
ffffffe000202d20:	f9042783          	lw	a5,-112(s0)
ffffffe000202d24:	00078613          	mv	a2,a5
ffffffe000202d28:	0006069b          	sext.w	a3,a2
ffffffe000202d2c:	0005879b          	sext.w	a5,a1
ffffffe000202d30:	00f6d463          	bge	a3,a5,ffffffe000202d38 <vprintfmt+0x428>
ffffffe000202d34:	00058613          	mv	a2,a1
ffffffe000202d38:	0006079b          	sext.w	a5,a2
ffffffe000202d3c:	40f707bb          	subw	a5,a4,a5
ffffffe000202d40:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202d44:	0280006f          	j	ffffffe000202d6c <vprintfmt+0x45c>
                    putch(' ');
ffffffe000202d48:	f5843783          	ld	a5,-168(s0)
ffffffe000202d4c:	02000513          	li	a0,32
ffffffe000202d50:	000780e7          	jalr	a5
                    ++written;
ffffffe000202d54:	fec42783          	lw	a5,-20(s0)
ffffffe000202d58:	0017879b          	addiw	a5,a5,1
ffffffe000202d5c:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202d60:	fd842783          	lw	a5,-40(s0)
ffffffe000202d64:	fff7879b          	addiw	a5,a5,-1
ffffffe000202d68:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202d6c:	fd842783          	lw	a5,-40(s0)
ffffffe000202d70:	0007879b          	sext.w	a5,a5
ffffffe000202d74:	fcf04ae3          	bgtz	a5,ffffffe000202d48 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000202d78:	fa644783          	lbu	a5,-90(s0)
ffffffe000202d7c:	0ff7f793          	zext.b	a5,a5
ffffffe000202d80:	04078463          	beqz	a5,ffffffe000202dc8 <vprintfmt+0x4b8>
                    putch('0');
ffffffe000202d84:	f5843783          	ld	a5,-168(s0)
ffffffe000202d88:	03000513          	li	a0,48
ffffffe000202d8c:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000202d90:	f5043783          	ld	a5,-176(s0)
ffffffe000202d94:	0007c783          	lbu	a5,0(a5)
ffffffe000202d98:	00078713          	mv	a4,a5
ffffffe000202d9c:	05800793          	li	a5,88
ffffffe000202da0:	00f71663          	bne	a4,a5,ffffffe000202dac <vprintfmt+0x49c>
ffffffe000202da4:	05800793          	li	a5,88
ffffffe000202da8:	0080006f          	j	ffffffe000202db0 <vprintfmt+0x4a0>
ffffffe000202dac:	07800793          	li	a5,120
ffffffe000202db0:	f5843703          	ld	a4,-168(s0)
ffffffe000202db4:	00078513          	mv	a0,a5
ffffffe000202db8:	000700e7          	jalr	a4
                    written += 2;
ffffffe000202dbc:	fec42783          	lw	a5,-20(s0)
ffffffe000202dc0:	0027879b          	addiw	a5,a5,2
ffffffe000202dc4:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202dc8:	fdc42783          	lw	a5,-36(s0)
ffffffe000202dcc:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202dd0:	0280006f          	j	ffffffe000202df8 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000202dd4:	f5843783          	ld	a5,-168(s0)
ffffffe000202dd8:	03000513          	li	a0,48
ffffffe000202ddc:	000780e7          	jalr	a5
                    ++written;
ffffffe000202de0:	fec42783          	lw	a5,-20(s0)
ffffffe000202de4:	0017879b          	addiw	a5,a5,1
ffffffe000202de8:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202dec:	fd442783          	lw	a5,-44(s0)
ffffffe000202df0:	0017879b          	addiw	a5,a5,1
ffffffe000202df4:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202df8:	f8c42703          	lw	a4,-116(s0)
ffffffe000202dfc:	fd442783          	lw	a5,-44(s0)
ffffffe000202e00:	0007879b          	sext.w	a5,a5
ffffffe000202e04:	fce7c8e3          	blt	a5,a4,ffffffe000202dd4 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202e08:	fdc42783          	lw	a5,-36(s0)
ffffffe000202e0c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202e10:	fcf42823          	sw	a5,-48(s0)
ffffffe000202e14:	03c0006f          	j	ffffffe000202e50 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000202e18:	fd042783          	lw	a5,-48(s0)
ffffffe000202e1c:	ff078793          	addi	a5,a5,-16
ffffffe000202e20:	008787b3          	add	a5,a5,s0
ffffffe000202e24:	f807c783          	lbu	a5,-128(a5)
ffffffe000202e28:	0007871b          	sext.w	a4,a5
ffffffe000202e2c:	f5843783          	ld	a5,-168(s0)
ffffffe000202e30:	00070513          	mv	a0,a4
ffffffe000202e34:	000780e7          	jalr	a5
                    ++written;
ffffffe000202e38:	fec42783          	lw	a5,-20(s0)
ffffffe000202e3c:	0017879b          	addiw	a5,a5,1
ffffffe000202e40:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202e44:	fd042783          	lw	a5,-48(s0)
ffffffe000202e48:	fff7879b          	addiw	a5,a5,-1
ffffffe000202e4c:	fcf42823          	sw	a5,-48(s0)
ffffffe000202e50:	fd042783          	lw	a5,-48(s0)
ffffffe000202e54:	0007879b          	sext.w	a5,a5
ffffffe000202e58:	fc07d0e3          	bgez	a5,ffffffe000202e18 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000202e5c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202e60:	2700006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202e64:	f5043783          	ld	a5,-176(s0)
ffffffe000202e68:	0007c783          	lbu	a5,0(a5)
ffffffe000202e6c:	00078713          	mv	a4,a5
ffffffe000202e70:	06400793          	li	a5,100
ffffffe000202e74:	02f70663          	beq	a4,a5,ffffffe000202ea0 <vprintfmt+0x590>
ffffffe000202e78:	f5043783          	ld	a5,-176(s0)
ffffffe000202e7c:	0007c783          	lbu	a5,0(a5)
ffffffe000202e80:	00078713          	mv	a4,a5
ffffffe000202e84:	06900793          	li	a5,105
ffffffe000202e88:	00f70c63          	beq	a4,a5,ffffffe000202ea0 <vprintfmt+0x590>
ffffffe000202e8c:	f5043783          	ld	a5,-176(s0)
ffffffe000202e90:	0007c783          	lbu	a5,0(a5)
ffffffe000202e94:	00078713          	mv	a4,a5
ffffffe000202e98:	07500793          	li	a5,117
ffffffe000202e9c:	08f71063          	bne	a4,a5,ffffffe000202f1c <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000202ea0:	f8144783          	lbu	a5,-127(s0)
ffffffe000202ea4:	00078c63          	beqz	a5,ffffffe000202ebc <vprintfmt+0x5ac>
ffffffe000202ea8:	f4843783          	ld	a5,-184(s0)
ffffffe000202eac:	00878713          	addi	a4,a5,8
ffffffe000202eb0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202eb4:	0007b783          	ld	a5,0(a5)
ffffffe000202eb8:	0140006f          	j	ffffffe000202ecc <vprintfmt+0x5bc>
ffffffe000202ebc:	f4843783          	ld	a5,-184(s0)
ffffffe000202ec0:	00878713          	addi	a4,a5,8
ffffffe000202ec4:	f4e43423          	sd	a4,-184(s0)
ffffffe000202ec8:	0007a783          	lw	a5,0(a5)
ffffffe000202ecc:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000202ed0:	fa843583          	ld	a1,-88(s0)
ffffffe000202ed4:	f5043783          	ld	a5,-176(s0)
ffffffe000202ed8:	0007c783          	lbu	a5,0(a5)
ffffffe000202edc:	0007871b          	sext.w	a4,a5
ffffffe000202ee0:	07500793          	li	a5,117
ffffffe000202ee4:	40f707b3          	sub	a5,a4,a5
ffffffe000202ee8:	00f037b3          	snez	a5,a5
ffffffe000202eec:	0ff7f793          	zext.b	a5,a5
ffffffe000202ef0:	f8040713          	addi	a4,s0,-128
ffffffe000202ef4:	00070693          	mv	a3,a4
ffffffe000202ef8:	00078613          	mv	a2,a5
ffffffe000202efc:	f5843503          	ld	a0,-168(s0)
ffffffe000202f00:	f08ff0ef          	jal	ra,ffffffe000202608 <print_dec_int>
ffffffe000202f04:	00050793          	mv	a5,a0
ffffffe000202f08:	fec42703          	lw	a4,-20(s0)
ffffffe000202f0c:	00f707bb          	addw	a5,a4,a5
ffffffe000202f10:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202f14:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202f18:	1b80006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202f1c:	f5043783          	ld	a5,-176(s0)
ffffffe000202f20:	0007c783          	lbu	a5,0(a5)
ffffffe000202f24:	00078713          	mv	a4,a5
ffffffe000202f28:	06e00793          	li	a5,110
ffffffe000202f2c:	04f71c63          	bne	a4,a5,ffffffe000202f84 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe000202f30:	f8144783          	lbu	a5,-127(s0)
ffffffe000202f34:	02078463          	beqz	a5,ffffffe000202f5c <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000202f38:	f4843783          	ld	a5,-184(s0)
ffffffe000202f3c:	00878713          	addi	a4,a5,8
ffffffe000202f40:	f4e43423          	sd	a4,-184(s0)
ffffffe000202f44:	0007b783          	ld	a5,0(a5)
ffffffe000202f48:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202f4c:	fec42703          	lw	a4,-20(s0)
ffffffe000202f50:	fb043783          	ld	a5,-80(s0)
ffffffe000202f54:	00e7b023          	sd	a4,0(a5)
ffffffe000202f58:	0240006f          	j	ffffffe000202f7c <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000202f5c:	f4843783          	ld	a5,-184(s0)
ffffffe000202f60:	00878713          	addi	a4,a5,8
ffffffe000202f64:	f4e43423          	sd	a4,-184(s0)
ffffffe000202f68:	0007b783          	ld	a5,0(a5)
ffffffe000202f6c:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe000202f70:	fb843783          	ld	a5,-72(s0)
ffffffe000202f74:	fec42703          	lw	a4,-20(s0)
ffffffe000202f78:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000202f7c:	f8040023          	sb	zero,-128(s0)
ffffffe000202f80:	1500006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe000202f84:	f5043783          	ld	a5,-176(s0)
ffffffe000202f88:	0007c783          	lbu	a5,0(a5)
ffffffe000202f8c:	00078713          	mv	a4,a5
ffffffe000202f90:	07300793          	li	a5,115
ffffffe000202f94:	02f71e63          	bne	a4,a5,ffffffe000202fd0 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000202f98:	f4843783          	ld	a5,-184(s0)
ffffffe000202f9c:	00878713          	addi	a4,a5,8
ffffffe000202fa0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202fa4:	0007b783          	ld	a5,0(a5)
ffffffe000202fa8:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000202fac:	fc043583          	ld	a1,-64(s0)
ffffffe000202fb0:	f5843503          	ld	a0,-168(s0)
ffffffe000202fb4:	dccff0ef          	jal	ra,ffffffe000202580 <puts_wo_nl>
ffffffe000202fb8:	00050793          	mv	a5,a0
ffffffe000202fbc:	fec42703          	lw	a4,-20(s0)
ffffffe000202fc0:	00f707bb          	addw	a5,a4,a5
ffffffe000202fc4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202fc8:	f8040023          	sb	zero,-128(s0)
ffffffe000202fcc:	1040006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000202fd0:	f5043783          	ld	a5,-176(s0)
ffffffe000202fd4:	0007c783          	lbu	a5,0(a5)
ffffffe000202fd8:	00078713          	mv	a4,a5
ffffffe000202fdc:	06300793          	li	a5,99
ffffffe000202fe0:	02f71e63          	bne	a4,a5,ffffffe00020301c <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000202fe4:	f4843783          	ld	a5,-184(s0)
ffffffe000202fe8:	00878713          	addi	a4,a5,8
ffffffe000202fec:	f4e43423          	sd	a4,-184(s0)
ffffffe000202ff0:	0007a783          	lw	a5,0(a5)
ffffffe000202ff4:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000202ff8:	fcc42703          	lw	a4,-52(s0)
ffffffe000202ffc:	f5843783          	ld	a5,-168(s0)
ffffffe000203000:	00070513          	mv	a0,a4
ffffffe000203004:	000780e7          	jalr	a5
                ++written;
ffffffe000203008:	fec42783          	lw	a5,-20(s0)
ffffffe00020300c:	0017879b          	addiw	a5,a5,1
ffffffe000203010:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203014:	f8040023          	sb	zero,-128(s0)
ffffffe000203018:	0b80006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe00020301c:	f5043783          	ld	a5,-176(s0)
ffffffe000203020:	0007c783          	lbu	a5,0(a5)
ffffffe000203024:	00078713          	mv	a4,a5
ffffffe000203028:	02500793          	li	a5,37
ffffffe00020302c:	02f71263          	bne	a4,a5,ffffffe000203050 <vprintfmt+0x740>
                putch('%');
ffffffe000203030:	f5843783          	ld	a5,-168(s0)
ffffffe000203034:	02500513          	li	a0,37
ffffffe000203038:	000780e7          	jalr	a5
                ++written;
ffffffe00020303c:	fec42783          	lw	a5,-20(s0)
ffffffe000203040:	0017879b          	addiw	a5,a5,1
ffffffe000203044:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203048:	f8040023          	sb	zero,-128(s0)
ffffffe00020304c:	0840006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe000203050:	f5043783          	ld	a5,-176(s0)
ffffffe000203054:	0007c783          	lbu	a5,0(a5)
ffffffe000203058:	0007871b          	sext.w	a4,a5
ffffffe00020305c:	f5843783          	ld	a5,-168(s0)
ffffffe000203060:	00070513          	mv	a0,a4
ffffffe000203064:	000780e7          	jalr	a5
                ++written;
ffffffe000203068:	fec42783          	lw	a5,-20(s0)
ffffffe00020306c:	0017879b          	addiw	a5,a5,1
ffffffe000203070:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203074:	f8040023          	sb	zero,-128(s0)
ffffffe000203078:	0580006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe00020307c:	f5043783          	ld	a5,-176(s0)
ffffffe000203080:	0007c783          	lbu	a5,0(a5)
ffffffe000203084:	00078713          	mv	a4,a5
ffffffe000203088:	02500793          	li	a5,37
ffffffe00020308c:	02f71063          	bne	a4,a5,ffffffe0002030ac <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe000203090:	f8043023          	sd	zero,-128(s0)
ffffffe000203094:	f8043423          	sd	zero,-120(s0)
ffffffe000203098:	00100793          	li	a5,1
ffffffe00020309c:	f8f40023          	sb	a5,-128(s0)
ffffffe0002030a0:	fff00793          	li	a5,-1
ffffffe0002030a4:	f8f42623          	sw	a5,-116(s0)
ffffffe0002030a8:	0280006f          	j	ffffffe0002030d0 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe0002030ac:	f5043783          	ld	a5,-176(s0)
ffffffe0002030b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002030b4:	0007871b          	sext.w	a4,a5
ffffffe0002030b8:	f5843783          	ld	a5,-168(s0)
ffffffe0002030bc:	00070513          	mv	a0,a4
ffffffe0002030c0:	000780e7          	jalr	a5
            ++written;
ffffffe0002030c4:	fec42783          	lw	a5,-20(s0)
ffffffe0002030c8:	0017879b          	addiw	a5,a5,1
ffffffe0002030cc:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe0002030d0:	f5043783          	ld	a5,-176(s0)
ffffffe0002030d4:	00178793          	addi	a5,a5,1
ffffffe0002030d8:	f4f43823          	sd	a5,-176(s0)
ffffffe0002030dc:	f5043783          	ld	a5,-176(s0)
ffffffe0002030e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002030e4:	84079ce3          	bnez	a5,ffffffe00020293c <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe0002030e8:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002030ec:	00078513          	mv	a0,a5
ffffffe0002030f0:	0b813083          	ld	ra,184(sp)
ffffffe0002030f4:	0b013403          	ld	s0,176(sp)
ffffffe0002030f8:	0c010113          	addi	sp,sp,192
ffffffe0002030fc:	00008067          	ret

ffffffe000203100 <printk>:

int printk(const char* s, ...) {
ffffffe000203100:	f9010113          	addi	sp,sp,-112
ffffffe000203104:	02113423          	sd	ra,40(sp)
ffffffe000203108:	02813023          	sd	s0,32(sp)
ffffffe00020310c:	03010413          	addi	s0,sp,48
ffffffe000203110:	fca43c23          	sd	a0,-40(s0)
ffffffe000203114:	00b43423          	sd	a1,8(s0)
ffffffe000203118:	00c43823          	sd	a2,16(s0)
ffffffe00020311c:	00d43c23          	sd	a3,24(s0)
ffffffe000203120:	02e43023          	sd	a4,32(s0)
ffffffe000203124:	02f43423          	sd	a5,40(s0)
ffffffe000203128:	03043823          	sd	a6,48(s0)
ffffffe00020312c:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000203130:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000203134:	04040793          	addi	a5,s0,64
ffffffe000203138:	fcf43823          	sd	a5,-48(s0)
ffffffe00020313c:	fd043783          	ld	a5,-48(s0)
ffffffe000203140:	fc878793          	addi	a5,a5,-56
ffffffe000203144:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000203148:	fe043783          	ld	a5,-32(s0)
ffffffe00020314c:	00078613          	mv	a2,a5
ffffffe000203150:	fd843583          	ld	a1,-40(s0)
ffffffe000203154:	fffff517          	auipc	a0,0xfffff
ffffffe000203158:	11850513          	addi	a0,a0,280 # ffffffe00020226c <putc>
ffffffe00020315c:	fb4ff0ef          	jal	ra,ffffffe000202910 <vprintfmt>
ffffffe000203160:	00050793          	mv	a5,a0
ffffffe000203164:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000203168:	fec42783          	lw	a5,-20(s0)
}
ffffffe00020316c:	00078513          	mv	a0,a5
ffffffe000203170:	02813083          	ld	ra,40(sp)
ffffffe000203174:	02013403          	ld	s0,32(sp)
ffffffe000203178:	07010113          	addi	sp,sp,112
ffffffe00020317c:	00008067          	ret

ffffffe000203180 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe000203180:	fe010113          	addi	sp,sp,-32
ffffffe000203184:	00813c23          	sd	s0,24(sp)
ffffffe000203188:	02010413          	addi	s0,sp,32
ffffffe00020318c:	00050793          	mv	a5,a0
ffffffe000203190:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe000203194:	fec42783          	lw	a5,-20(s0)
ffffffe000203198:	fff7879b          	addiw	a5,a5,-1
ffffffe00020319c:	0007879b          	sext.w	a5,a5
ffffffe0002031a0:	02079713          	slli	a4,a5,0x20
ffffffe0002031a4:	02075713          	srli	a4,a4,0x20
ffffffe0002031a8:	00006797          	auipc	a5,0x6
ffffffe0002031ac:	e7078793          	addi	a5,a5,-400 # ffffffe000209018 <seed>
ffffffe0002031b0:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002031b4:	00000013          	nop
ffffffe0002031b8:	01813403          	ld	s0,24(sp)
ffffffe0002031bc:	02010113          	addi	sp,sp,32
ffffffe0002031c0:	00008067          	ret

ffffffe0002031c4 <rand>:

int rand(void) {
ffffffe0002031c4:	ff010113          	addi	sp,sp,-16
ffffffe0002031c8:	00813423          	sd	s0,8(sp)
ffffffe0002031cc:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe0002031d0:	00006797          	auipc	a5,0x6
ffffffe0002031d4:	e4878793          	addi	a5,a5,-440 # ffffffe000209018 <seed>
ffffffe0002031d8:	0007b703          	ld	a4,0(a5)
ffffffe0002031dc:	00001797          	auipc	a5,0x1
ffffffe0002031e0:	39478793          	addi	a5,a5,916 # ffffffe000204570 <lowerxdigits.0+0x18>
ffffffe0002031e4:	0007b783          	ld	a5,0(a5)
ffffffe0002031e8:	02f707b3          	mul	a5,a4,a5
ffffffe0002031ec:	00178713          	addi	a4,a5,1
ffffffe0002031f0:	00006797          	auipc	a5,0x6
ffffffe0002031f4:	e2878793          	addi	a5,a5,-472 # ffffffe000209018 <seed>
ffffffe0002031f8:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe0002031fc:	00006797          	auipc	a5,0x6
ffffffe000203200:	e1c78793          	addi	a5,a5,-484 # ffffffe000209018 <seed>
ffffffe000203204:	0007b783          	ld	a5,0(a5)
ffffffe000203208:	0217d793          	srli	a5,a5,0x21
ffffffe00020320c:	0007879b          	sext.w	a5,a5
}
ffffffe000203210:	00078513          	mv	a0,a5
ffffffe000203214:	00813403          	ld	s0,8(sp)
ffffffe000203218:	01010113          	addi	sp,sp,16
ffffffe00020321c:	00008067          	ret

ffffffe000203220 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000203220:	fc010113          	addi	sp,sp,-64
ffffffe000203224:	02813c23          	sd	s0,56(sp)
ffffffe000203228:	04010413          	addi	s0,sp,64
ffffffe00020322c:	fca43c23          	sd	a0,-40(s0)
ffffffe000203230:	00058793          	mv	a5,a1
ffffffe000203234:	fcc43423          	sd	a2,-56(s0)
ffffffe000203238:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe00020323c:	fd843783          	ld	a5,-40(s0)
ffffffe000203240:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203244:	fe043423          	sd	zero,-24(s0)
ffffffe000203248:	0280006f          	j	ffffffe000203270 <memset+0x50>
        s[i] = c;
ffffffe00020324c:	fe043703          	ld	a4,-32(s0)
ffffffe000203250:	fe843783          	ld	a5,-24(s0)
ffffffe000203254:	00f707b3          	add	a5,a4,a5
ffffffe000203258:	fd442703          	lw	a4,-44(s0)
ffffffe00020325c:	0ff77713          	zext.b	a4,a4
ffffffe000203260:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203264:	fe843783          	ld	a5,-24(s0)
ffffffe000203268:	00178793          	addi	a5,a5,1
ffffffe00020326c:	fef43423          	sd	a5,-24(s0)
ffffffe000203270:	fe843703          	ld	a4,-24(s0)
ffffffe000203274:	fc843783          	ld	a5,-56(s0)
ffffffe000203278:	fcf76ae3          	bltu	a4,a5,ffffffe00020324c <memset+0x2c>
    }
    return dest;
ffffffe00020327c:	fd843783          	ld	a5,-40(s0)
}
ffffffe000203280:	00078513          	mv	a0,a5
ffffffe000203284:	03813403          	ld	s0,56(sp)
ffffffe000203288:	04010113          	addi	sp,sp,64
ffffffe00020328c:	00008067          	ret

ffffffe000203290 <memcpy>:

void *memcpy(void *dest, const void *src, uint64_t n) {
ffffffe000203290:	fb010113          	addi	sp,sp,-80
ffffffe000203294:	04813423          	sd	s0,72(sp)
ffffffe000203298:	05010413          	addi	s0,sp,80
ffffffe00020329c:	fca43423          	sd	a0,-56(s0)
ffffffe0002032a0:	fcb43023          	sd	a1,-64(s0)
ffffffe0002032a4:	fac43c23          	sd	a2,-72(s0)
    char *d = (char *)dest;
ffffffe0002032a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002032ac:	fef43023          	sd	a5,-32(s0)
    const char *s = (const char *)src;
ffffffe0002032b0:	fc043783          	ld	a5,-64(s0)
ffffffe0002032b4:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002032b8:	fe043423          	sd	zero,-24(s0)
ffffffe0002032bc:	0300006f          	j	ffffffe0002032ec <memcpy+0x5c>
        d[i] = s[i];
ffffffe0002032c0:	fd843703          	ld	a4,-40(s0)
ffffffe0002032c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002032c8:	00f70733          	add	a4,a4,a5
ffffffe0002032cc:	fe043683          	ld	a3,-32(s0)
ffffffe0002032d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002032d4:	00f687b3          	add	a5,a3,a5
ffffffe0002032d8:	00074703          	lbu	a4,0(a4)
ffffffe0002032dc:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002032e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002032e4:	00178793          	addi	a5,a5,1
ffffffe0002032e8:	fef43423          	sd	a5,-24(s0)
ffffffe0002032ec:	fe843703          	ld	a4,-24(s0)
ffffffe0002032f0:	fb843783          	ld	a5,-72(s0)
ffffffe0002032f4:	fcf766e3          	bltu	a4,a5,ffffffe0002032c0 <memcpy+0x30>
    }
    return dest;
ffffffe0002032f8:	fc843783          	ld	a5,-56(s0)
}
ffffffe0002032fc:	00078513          	mv	a0,a5
ffffffe000203300:	04813403          	ld	s0,72(sp)
ffffffe000203304:	05010113          	addi	sp,sp,80
ffffffe000203308:	00008067          	ret
