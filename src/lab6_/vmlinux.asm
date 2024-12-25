
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern virtio_dev_init
    .extern mbr_init

_start:
    #implement
    la sp, boot_stack_top # initialize stack
ffffffe000200000:	0000d117          	auipc	sp,0xd
ffffffe000200004:	00010113          	mv	sp,sp

    call setup_vm
ffffffe000200008:	20d020ef          	jal	ra,ffffffe000202a14 <setup_vm>
    call relocate
ffffffe00020000c:	04c000ef          	jal	ra,ffffffe000200058 <relocate>
    call mm_init
ffffffe000200010:	29d000ef          	jal	ra,ffffffe000200aac <mm_init>
    call setup_vm_final
ffffffe000200014:	3c9020ef          	jal	ra,ffffffe000202bdc <setup_vm_final>
    call task_init
ffffffe000200018:	509000ef          	jal	ra,ffffffe000200d20 <task_init>
    call virtio_dev_init
ffffffe00020001c:	614060ef          	jal	ra,ffffffe000206630 <virtio_dev_init>
    call mbr_init
ffffffe000200020:	075050ef          	jal	ra,ffffffe000205894 <mbr_init>

    la t0, _traps # load traps
ffffffe000200024:	00000297          	auipc	t0,0x0
ffffffe000200028:	07828293          	addi	t0,t0,120 # ffffffe00020009c <_traps>
    csrw stvec, t0 # set traps
ffffffe00020002c:	10529073          	csrw	stvec,t0

    li t0, (1 << 5) # enable interrupts
ffffffe000200030:	02000293          	li	t0,32
    csrs sie, t0
ffffffe000200034:	1042a073          	csrs	sie,t0

    li t1, 10000000
ffffffe000200038:	00989337          	lui	t1,0x989
ffffffe00020003c:	6803031b          	addiw	t1,t1,1664 # 989680 <OPENSBI_SIZE+0x789680>
    rdtime t0
ffffffe000200040:	c01022f3          	rdtime	t0
    add t0, t0, t1
ffffffe000200044:	006282b3          	add	t0,t0,t1
    mv a0, t0 # set time to 1s
ffffffe000200048:	00028513          	mv	a0,t0
    li a7, 0 # set eid to 0
ffffffe00020004c:	00000893          	li	a7,0
    ecall # call sbi_set_timer
ffffffe000200050:	00000073          	ecall

    # sstatus[PIE]
    # li t0, (1 << 1)
    # csrs sstatus, t0 # enable global interrupt

    call start_kernel # jump to start_kernel
ffffffe000200054:	16c030ef          	jal	ra,ffffffe0002031c0 <start_kernel>

ffffffe000200058 <relocate>:

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    li t2, 0xffffffe000000000
ffffffe000200058:	fff0039b          	addiw	t2,zero,-1
ffffffe00020005c:	02539393          	slli	t2,t2,0x25
    li t3, 0x80000000
ffffffe000200060:	00100e1b          	addiw	t3,zero,1
ffffffe000200064:	01fe1e13          	slli	t3,t3,0x1f
    sub t1, t2, t3
ffffffe000200068:	41c38333          	sub	t1,t2,t3
    add ra, ra, t1
ffffffe00020006c:	006080b3          	add	ra,ra,t1
    add sp, sp, t1
ffffffe000200070:	00610133          	add	sp,sp,t1
    # la t4, 1f
    # add t4, t4, t1

    # set satp with early_pgtbl

    la t0, early_pgtbl
ffffffe000200074:	0000e297          	auipc	t0,0xe
ffffffe000200078:	f8c28293          	addi	t0,t0,-116 # ffffffe00020e000 <early_pgtbl>
    srli t0, t0, 12
ffffffe00020007c:	00c2d293          	srli	t0,t0,0xc
    li t1, (8 << 60)
ffffffe000200080:	fff0031b          	addiw	t1,zero,-1
ffffffe000200084:	03f31313          	slli	t1,t1,0x3f
    or t0, t0, t1
ffffffe000200088:	0062e2b3          	or	t0,t0,t1
    # csrw stvec, t4
    csrw satp, t0
ffffffe00020008c:	18029073          	csrw	satp,t0

# 1:
    # flush tlb
    sfence.vma zero, zero
ffffffe000200090:	12000073          	sfence.vma

    # flush icache
    fence.i
ffffffe000200094:	0000100f          	fence.i

    ret
ffffffe000200098:	00008067          	ret

ffffffe00020009c <_traps>:

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    csrrw sp, sscratch, sp
ffffffe00020009c:	14011173          	csrrw	sp,sscratch,sp
    bne sp, zero, 1f
ffffffe0002000a0:	00011463          	bnez	sp,ffffffe0002000a8 <_traps+0xc>
    csrrw sp, sscratch, sp
ffffffe0002000a4:	14011173          	csrrw	sp,sscratch,sp
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap
1:
    addi sp, sp, -33*8
ffffffe0002000a8:	ef810113          	addi	sp,sp,-264 # ffffffe00020cef8 <_sbss+0xef8>
    sd ra, 0*8(sp)
ffffffe0002000ac:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
ffffffe0002000b0:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
ffffffe0002000b4:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
ffffffe0002000b8:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
ffffffe0002000bc:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
ffffffe0002000c0:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
ffffffe0002000c4:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
ffffffe0002000c8:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
ffffffe0002000cc:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
ffffffe0002000d0:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
ffffffe0002000d4:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
ffffffe0002000d8:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
ffffffe0002000dc:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
ffffffe0002000e0:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
ffffffe0002000e4:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
ffffffe0002000e8:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
ffffffe0002000ec:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
ffffffe0002000f0:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
ffffffe0002000f4:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
ffffffe0002000f8:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
ffffffe0002000fc:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
ffffffe000200100:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
ffffffe000200104:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
ffffffe000200108:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
ffffffe00020010c:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
ffffffe000200110:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
ffffffe000200114:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
ffffffe000200118:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
ffffffe00020011c:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
ffffffe000200120:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
ffffffe000200124:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
ffffffe000200128:	0e513823          	sd	t0,240(sp)
    csrr t0, sstatus
ffffffe00020012c:	100022f3          	csrr	t0,sstatus
    sd t0, 31*8(sp)
ffffffe000200130:	0e513c23          	sd	t0,248(sp)
    sd sp, 32*8(sp)
ffffffe000200134:	10213023          	sd	sp,256(sp)

    csrr a0, scause
ffffffe000200138:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe00020013c:	141025f3          	csrr	a1,sepc
    mv a2, sp
ffffffe000200140:	00010613          	mv	a2,sp
    call trap_handler
ffffffe000200144:	204020ef          	jal	ra,ffffffe000202348 <trap_handler>

ffffffe000200148 <__ret_from_fork>:

    .globl __ret_from_fork
__ret_from_fork:

    ld sp, 32*8(sp)
ffffffe000200148:	10013103          	ld	sp,256(sp)
    ld t0, 31*8(sp)
ffffffe00020014c:	0f813283          	ld	t0,248(sp)
    csrw sstatus, t0
ffffffe000200150:	10029073          	csrw	sstatus,t0
    ld t0, 30*8(sp)
ffffffe000200154:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
ffffffe000200158:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
ffffffe00020015c:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
ffffffe000200160:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
ffffffe000200164:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
ffffffe000200168:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
ffffffe00020016c:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
ffffffe000200170:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
ffffffe000200174:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
ffffffe000200178:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
ffffffe00020017c:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
ffffffe000200180:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
ffffffe000200184:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
ffffffe000200188:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
ffffffe00020018c:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
ffffffe000200190:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
ffffffe000200194:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
ffffffe000200198:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
ffffffe00020019c:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
ffffffe0002001a0:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
ffffffe0002001a4:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
ffffffe0002001a8:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
ffffffe0002001ac:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
ffffffe0002001b0:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
ffffffe0002001b4:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
ffffffe0002001b8:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
ffffffe0002001bc:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
ffffffe0002001c0:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
ffffffe0002001c4:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
ffffffe0002001c8:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
ffffffe0002001cc:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
ffffffe0002001d0:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
ffffffe0002001d4:	10810113          	addi	sp,sp,264

    # csrr t0, sscratch
    # csrw sscratch, sp
    # mv sp, t0

    csrrw sp, sscratch, sp     # 交换 sp 和 sscratch
ffffffe0002001d8:	14011173          	csrrw	sp,sscratch,sp
    bne sp, zero, 1f           # 如果 sp 不为零，跳转到标签 1f
ffffffe0002001dc:	00011463          	bnez	sp,ffffffe0002001e4 <__ret_from_fork+0x9c>
    csrrw sp, sscratch, sp     # 再次交换 sp 和 sscratch
ffffffe0002001e0:	14011173          	csrrw	sp,sscratch,sp

1:
    sret
ffffffe0002001e4:	10200073          	sret

ffffffe0002001e8 <__dummy>:

    .globl __dummy
__dummy:
    add t0, sp, zero
ffffffe0002001e8:	000102b3          	add	t0,sp,zero
    csrr sp, sscratch
ffffffe0002001ec:	14002173          	csrr	sp,sscratch
    csrw sscratch, t0
ffffffe0002001f0:	14029073          	csrw	sscratch,t0
    sret
ffffffe0002001f4:	10200073          	sret

ffffffe0002001f8 <__switch_to>:

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
ffffffe0002001f8:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
ffffffe0002001fc:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
ffffffe000200200:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
ffffffe000200204:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
ffffffe000200208:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
ffffffe00020020c:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
ffffffe000200210:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
ffffffe000200214:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
ffffffe000200218:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
ffffffe00020021c:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
ffffffe000200220:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
ffffffe000200224:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
ffffffe000200228:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
ffffffe00020022c:	07b53423          	sd	s11,104(a0)

    csrr t0, sepc
ffffffe000200230:	141022f3          	csrr	t0,sepc
    sd t0, 112(a0)
ffffffe000200234:	06553823          	sd	t0,112(a0)

    csrr t0, sstatus
ffffffe000200238:	100022f3          	csrr	t0,sstatus
    sd t0, 120(a0)
ffffffe00020023c:	06553c23          	sd	t0,120(a0)

    csrr t0, sscratch
ffffffe000200240:	140022f3          	csrr	t0,sscratch
    sd t0, 128(a0)
ffffffe000200244:	08553023          	sd	t0,128(a0)

    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
ffffffe000200248:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
ffffffe00020024c:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
ffffffe000200250:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
ffffffe000200254:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
ffffffe000200258:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
ffffffe00020025c:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
ffffffe000200260:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
ffffffe000200264:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
ffffffe000200268:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
ffffffe00020026c:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
ffffffe000200270:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
ffffffe000200274:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
ffffffe000200278:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
ffffffe00020027c:	0685bd83          	ld	s11,104(a1)

    ld t0, 112(a1)
ffffffe000200280:	0705b283          	ld	t0,112(a1)
    csrw sepc, t0
ffffffe000200284:	14129073          	csrw	sepc,t0

    ld t0, 120(a1)
ffffffe000200288:	0785b283          	ld	t0,120(a1)
    csrw sstatus, t0
ffffffe00020028c:	10029073          	csrw	sstatus,t0

    ld t0, 128(a1)
ffffffe000200290:	0805b283          	ld	t0,128(a1)
    csrw sscratch, t0
ffffffe000200294:	14029073          	csrw	sscratch,t0

    csrw satp, a2
ffffffe000200298:	18061073          	csrw	satp,a2

    sfence.vma zero, zero
ffffffe00020029c:	12000073          	sfence.vma
    fence.i
ffffffe0002002a0:	0000100f          	fence.i

ffffffe0002002a4:	00008067          	ret

ffffffe0002002a8 <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe0002002a8:	fe010113          	addi	sp,sp,-32
ffffffe0002002ac:	00813c23          	sd	s0,24(sp)
ffffffe0002002b0:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe0002002b4:	c01027f3          	rdtime	a5
ffffffe0002002b8:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe0002002bc:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002c0:	00078513          	mv	a0,a5
ffffffe0002002c4:	01813403          	ld	s0,24(sp)
ffffffe0002002c8:	02010113          	addi	sp,sp,32
ffffffe0002002cc:	00008067          	ret

ffffffe0002002d0 <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
ffffffe0002002d0:	fe010113          	addi	sp,sp,-32
ffffffe0002002d4:	00813c23          	sd	s0,24(sp)
ffffffe0002002d8:	02010413          	addi	s0,sp,32
ffffffe0002002dc:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
ffffffe0002002e0:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
ffffffe0002002e4:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
ffffffe0002002e8:	00000073          	ecall
}
ffffffe0002002ec:	00000013          	nop
ffffffe0002002f0:	01813403          	ld	s0,24(sp)
ffffffe0002002f4:	02010113          	addi	sp,sp,32
ffffffe0002002f8:	00008067          	ret

ffffffe0002002fc <clock_set_next_event>:

void clock_set_next_event() {
ffffffe0002002fc:	fe010113          	addi	sp,sp,-32
ffffffe000200300:	00113c23          	sd	ra,24(sp)
ffffffe000200304:	00813823          	sd	s0,16(sp)
ffffffe000200308:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe00020030c:	f9dff0ef          	jal	ra,ffffffe0002002a8 <get_cycles>
ffffffe000200310:	00050713          	mv	a4,a0
ffffffe000200314:	00008797          	auipc	a5,0x8
ffffffe000200318:	cec78793          	addi	a5,a5,-788 # ffffffe000208000 <TIMECLOCK>
ffffffe00020031c:	0007b783          	ld	a5,0(a5)
ffffffe000200320:	00f707b3          	add	a5,a4,a5
ffffffe000200324:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe000200328:	fe843503          	ld	a0,-24(s0)
ffffffe00020032c:	fa5ff0ef          	jal	ra,ffffffe0002002d0 <sbi_set_timer>
ffffffe000200330:	00000013          	nop
ffffffe000200334:	01813083          	ld	ra,24(sp)
ffffffe000200338:	01013403          	ld	s0,16(sp)
ffffffe00020033c:	02010113          	addi	sp,sp,32
ffffffe000200340:	00008067          	ret

ffffffe000200344 <fixsize>:
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size) {
ffffffe000200344:	fe010113          	addi	sp,sp,-32
ffffffe000200348:	00813c23          	sd	s0,24(sp)
ffffffe00020034c:	02010413          	addi	s0,sp,32
ffffffe000200350:	fea43423          	sd	a0,-24(s0)
    size --;
ffffffe000200354:	fe843783          	ld	a5,-24(s0)
ffffffe000200358:	fff78793          	addi	a5,a5,-1
ffffffe00020035c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe000200360:	fe843783          	ld	a5,-24(s0)
ffffffe000200364:	0017d793          	srli	a5,a5,0x1
ffffffe000200368:	fe843703          	ld	a4,-24(s0)
ffffffe00020036c:	00f767b3          	or	a5,a4,a5
ffffffe000200370:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe000200374:	fe843783          	ld	a5,-24(s0)
ffffffe000200378:	0027d793          	srli	a5,a5,0x2
ffffffe00020037c:	fe843703          	ld	a4,-24(s0)
ffffffe000200380:	00f767b3          	or	a5,a4,a5
ffffffe000200384:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe000200388:	fe843783          	ld	a5,-24(s0)
ffffffe00020038c:	0047d793          	srli	a5,a5,0x4
ffffffe000200390:	fe843703          	ld	a4,-24(s0)
ffffffe000200394:	00f767b3          	or	a5,a4,a5
ffffffe000200398:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe00020039c:	fe843783          	ld	a5,-24(s0)
ffffffe0002003a0:	0087d793          	srli	a5,a5,0x8
ffffffe0002003a4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003a8:	00f767b3          	or	a5,a4,a5
ffffffe0002003ac:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe0002003b0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003b4:	0107d793          	srli	a5,a5,0x10
ffffffe0002003b8:	fe843703          	ld	a4,-24(s0)
ffffffe0002003bc:	00f767b3          	or	a5,a4,a5
ffffffe0002003c0:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe0002003c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002003c8:	0207d793          	srli	a5,a5,0x20
ffffffe0002003cc:	fe843703          	ld	a4,-24(s0)
ffffffe0002003d0:	00f767b3          	or	a5,a4,a5
ffffffe0002003d4:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe0002003d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002003dc:	00178793          	addi	a5,a5,1
}
ffffffe0002003e0:	00078513          	mv	a0,a5
ffffffe0002003e4:	01813403          	ld	s0,24(sp)
ffffffe0002003e8:	02010113          	addi	sp,sp,32
ffffffe0002003ec:	00008067          	ret

ffffffe0002003f0 <buddy_init>:

void buddy_init() {
ffffffe0002003f0:	fd010113          	addi	sp,sp,-48
ffffffe0002003f4:	02113423          	sd	ra,40(sp)
ffffffe0002003f8:	02813023          	sd	s0,32(sp)
ffffffe0002003fc:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe000200400:	000087b7          	lui	a5,0x8
ffffffe000200404:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe000200408:	fe843783          	ld	a5,-24(s0)
ffffffe00020040c:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe000200410:	fe843783          	ld	a5,-24(s0)
ffffffe000200414:	00f777b3          	and	a5,a4,a5
ffffffe000200418:	00078863          	beqz	a5,ffffffe000200428 <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe00020041c:	fe843503          	ld	a0,-24(s0)
ffffffe000200420:	f25ff0ef          	jal	ra,ffffffe000200344 <fixsize>
ffffffe000200424:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe000200428:	0000d797          	auipc	a5,0xd
ffffffe00020042c:	c1878793          	addi	a5,a5,-1000 # ffffffe00020d040 <buddy>
ffffffe000200430:	fe843703          	ld	a4,-24(s0)
ffffffe000200434:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe000200438:	00008797          	auipc	a5,0x8
ffffffe00020043c:	bd078793          	addi	a5,a5,-1072 # ffffffe000208008 <free_page_start>
ffffffe000200440:	0007b703          	ld	a4,0(a5)
ffffffe000200444:	0000d797          	auipc	a5,0xd
ffffffe000200448:	bfc78793          	addi	a5,a5,-1028 # ffffffe00020d040 <buddy>
ffffffe00020044c:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200450:	00008797          	auipc	a5,0x8
ffffffe000200454:	bb878793          	addi	a5,a5,-1096 # ffffffe000208008 <free_page_start>
ffffffe000200458:	0007b703          	ld	a4,0(a5)
ffffffe00020045c:	0000d797          	auipc	a5,0xd
ffffffe000200460:	be478793          	addi	a5,a5,-1052 # ffffffe00020d040 <buddy>
ffffffe000200464:	0007b783          	ld	a5,0(a5)
ffffffe000200468:	00479793          	slli	a5,a5,0x4
ffffffe00020046c:	00f70733          	add	a4,a4,a5
ffffffe000200470:	00008797          	auipc	a5,0x8
ffffffe000200474:	b9878793          	addi	a5,a5,-1128 # ffffffe000208008 <free_page_start>
ffffffe000200478:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe00020047c:	0000d797          	auipc	a5,0xd
ffffffe000200480:	bc478793          	addi	a5,a5,-1084 # ffffffe00020d040 <buddy>
ffffffe000200484:	0087b703          	ld	a4,8(a5)
ffffffe000200488:	0000d797          	auipc	a5,0xd
ffffffe00020048c:	bb878793          	addi	a5,a5,-1096 # ffffffe00020d040 <buddy>
ffffffe000200490:	0007b783          	ld	a5,0(a5)
ffffffe000200494:	00479793          	slli	a5,a5,0x4
ffffffe000200498:	00078613          	mv	a2,a5
ffffffe00020049c:	00000593          	li	a1,0
ffffffe0002004a0:	00070513          	mv	a0,a4
ffffffe0002004a4:	7ed030ef          	jal	ra,ffffffe000204490 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe0002004a8:	0000d797          	auipc	a5,0xd
ffffffe0002004ac:	b9878793          	addi	a5,a5,-1128 # ffffffe00020d040 <buddy>
ffffffe0002004b0:	0007b783          	ld	a5,0(a5)
ffffffe0002004b4:	00179793          	slli	a5,a5,0x1
ffffffe0002004b8:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004bc:	fc043c23          	sd	zero,-40(s0)
ffffffe0002004c0:	0500006f          	j	ffffffe000200510 <buddy_init+0x120>
        if (IS_POWER_OF_2(i + 1))
ffffffe0002004c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002004c8:	00178713          	addi	a4,a5,1
ffffffe0002004cc:	fd843783          	ld	a5,-40(s0)
ffffffe0002004d0:	00f777b3          	and	a5,a4,a5
ffffffe0002004d4:	00079863          	bnez	a5,ffffffe0002004e4 <buddy_init+0xf4>
            node_size /= 2;
ffffffe0002004d8:	fe043783          	ld	a5,-32(s0)
ffffffe0002004dc:	0017d793          	srli	a5,a5,0x1
ffffffe0002004e0:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe0002004e4:	0000d797          	auipc	a5,0xd
ffffffe0002004e8:	b5c78793          	addi	a5,a5,-1188 # ffffffe00020d040 <buddy>
ffffffe0002004ec:	0087b703          	ld	a4,8(a5)
ffffffe0002004f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002004f4:	00379793          	slli	a5,a5,0x3
ffffffe0002004f8:	00f707b3          	add	a5,a4,a5
ffffffe0002004fc:	fe043703          	ld	a4,-32(s0)
ffffffe000200500:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe000200504:	fd843783          	ld	a5,-40(s0)
ffffffe000200508:	00178793          	addi	a5,a5,1
ffffffe00020050c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200510:	0000d797          	auipc	a5,0xd
ffffffe000200514:	b3078793          	addi	a5,a5,-1232 # ffffffe00020d040 <buddy>
ffffffe000200518:	0007b783          	ld	a5,0(a5)
ffffffe00020051c:	00179793          	slli	a5,a5,0x1
ffffffe000200520:	fff78793          	addi	a5,a5,-1
ffffffe000200524:	fd843703          	ld	a4,-40(s0)
ffffffe000200528:	f8f76ee3          	bltu	a4,a5,ffffffe0002004c4 <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe00020052c:	fc043823          	sd	zero,-48(s0)
ffffffe000200530:	0180006f          	j	ffffffe000200548 <buddy_init+0x158>
        buddy_alloc(1);
ffffffe000200534:	00100513          	li	a0,1
ffffffe000200538:	1fc000ef          	jal	ra,ffffffe000200734 <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe00020053c:	fd043783          	ld	a5,-48(s0)
ffffffe000200540:	00178793          	addi	a5,a5,1
ffffffe000200544:	fcf43823          	sd	a5,-48(s0)
ffffffe000200548:	fd043783          	ld	a5,-48(s0)
ffffffe00020054c:	00c79713          	slli	a4,a5,0xc
ffffffe000200550:	00100793          	li	a5,1
ffffffe000200554:	01f79793          	slli	a5,a5,0x1f
ffffffe000200558:	00f70733          	add	a4,a4,a5
ffffffe00020055c:	00008797          	auipc	a5,0x8
ffffffe000200560:	aac78793          	addi	a5,a5,-1364 # ffffffe000208008 <free_page_start>
ffffffe000200564:	0007b783          	ld	a5,0(a5)
ffffffe000200568:	00078693          	mv	a3,a5
ffffffe00020056c:	04100793          	li	a5,65
ffffffe000200570:	01f79793          	slli	a5,a5,0x1f
ffffffe000200574:	00f687b3          	add	a5,a3,a5
ffffffe000200578:	faf76ee3          	bltu	a4,a5,ffffffe000200534 <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe00020057c:	00007517          	auipc	a0,0x7
ffffffe000200580:	a8c50513          	addi	a0,a0,-1396 # ffffffe000207008 <__func__.4+0x8>
ffffffe000200584:	5ed030ef          	jal	ra,ffffffe000204370 <printk>
    return;
ffffffe000200588:	00000013          	nop
}
ffffffe00020058c:	02813083          	ld	ra,40(sp)
ffffffe000200590:	02013403          	ld	s0,32(sp)
ffffffe000200594:	03010113          	addi	sp,sp,48
ffffffe000200598:	00008067          	ret

ffffffe00020059c <buddy_free>:

void buddy_free(uint64_t pfn) {
ffffffe00020059c:	fc010113          	addi	sp,sp,-64
ffffffe0002005a0:	02813c23          	sd	s0,56(sp)
ffffffe0002005a4:	04010413          	addi	s0,sp,64
ffffffe0002005a8:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe0002005ac:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe0002005b0:	00100793          	li	a5,1
ffffffe0002005b4:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe0002005b8:	0000d797          	auipc	a5,0xd
ffffffe0002005bc:	a8878793          	addi	a5,a5,-1400 # ffffffe00020d040 <buddy>
ffffffe0002005c0:	0007b703          	ld	a4,0(a5)
ffffffe0002005c4:	fc843783          	ld	a5,-56(s0)
ffffffe0002005c8:	00f707b3          	add	a5,a4,a5
ffffffe0002005cc:	fff78793          	addi	a5,a5,-1
ffffffe0002005d0:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005d4:	02c0006f          	j	ffffffe000200600 <buddy_free+0x64>
        node_size *= 2;
ffffffe0002005d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002005dc:	00179793          	slli	a5,a5,0x1
ffffffe0002005e0:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe0002005e4:	fe043783          	ld	a5,-32(s0)
ffffffe0002005e8:	02078e63          	beqz	a5,ffffffe000200624 <buddy_free+0x88>
    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005ec:	fe043783          	ld	a5,-32(s0)
ffffffe0002005f0:	00178793          	addi	a5,a5,1
ffffffe0002005f4:	0017d793          	srli	a5,a5,0x1
ffffffe0002005f8:	fff78793          	addi	a5,a5,-1
ffffffe0002005fc:	fef43023          	sd	a5,-32(s0)
ffffffe000200600:	0000d797          	auipc	a5,0xd
ffffffe000200604:	a4078793          	addi	a5,a5,-1472 # ffffffe00020d040 <buddy>
ffffffe000200608:	0087b703          	ld	a4,8(a5)
ffffffe00020060c:	fe043783          	ld	a5,-32(s0)
ffffffe000200610:	00379793          	slli	a5,a5,0x3
ffffffe000200614:	00f707b3          	add	a5,a4,a5
ffffffe000200618:	0007b783          	ld	a5,0(a5)
ffffffe00020061c:	fa079ee3          	bnez	a5,ffffffe0002005d8 <buddy_free+0x3c>
ffffffe000200620:	0080006f          	j	ffffffe000200628 <buddy_free+0x8c>
            break;
ffffffe000200624:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe000200628:	0000d797          	auipc	a5,0xd
ffffffe00020062c:	a1878793          	addi	a5,a5,-1512 # ffffffe00020d040 <buddy>
ffffffe000200630:	0087b703          	ld	a4,8(a5)
ffffffe000200634:	fe043783          	ld	a5,-32(s0)
ffffffe000200638:	00379793          	slli	a5,a5,0x3
ffffffe00020063c:	00f707b3          	add	a5,a4,a5
ffffffe000200640:	fe843703          	ld	a4,-24(s0)
ffffffe000200644:	00e7b023          	sd	a4,0(a5)

    while (index) {
ffffffe000200648:	0d00006f          	j	ffffffe000200718 <buddy_free+0x17c>
        index = PARENT(index);
ffffffe00020064c:	fe043783          	ld	a5,-32(s0)
ffffffe000200650:	00178793          	addi	a5,a5,1
ffffffe000200654:	0017d793          	srli	a5,a5,0x1
ffffffe000200658:	fff78793          	addi	a5,a5,-1
ffffffe00020065c:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe000200660:	fe843783          	ld	a5,-24(s0)
ffffffe000200664:	00179793          	slli	a5,a5,0x1
ffffffe000200668:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe00020066c:	0000d797          	auipc	a5,0xd
ffffffe000200670:	9d478793          	addi	a5,a5,-1580 # ffffffe00020d040 <buddy>
ffffffe000200674:	0087b703          	ld	a4,8(a5)
ffffffe000200678:	fe043783          	ld	a5,-32(s0)
ffffffe00020067c:	00479793          	slli	a5,a5,0x4
ffffffe000200680:	00878793          	addi	a5,a5,8
ffffffe000200684:	00f707b3          	add	a5,a4,a5
ffffffe000200688:	0007b783          	ld	a5,0(a5)
ffffffe00020068c:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe000200690:	0000d797          	auipc	a5,0xd
ffffffe000200694:	9b078793          	addi	a5,a5,-1616 # ffffffe00020d040 <buddy>
ffffffe000200698:	0087b703          	ld	a4,8(a5)
ffffffe00020069c:	fe043783          	ld	a5,-32(s0)
ffffffe0002006a0:	00178793          	addi	a5,a5,1
ffffffe0002006a4:	00479793          	slli	a5,a5,0x4
ffffffe0002006a8:	00f707b3          	add	a5,a4,a5
ffffffe0002006ac:	0007b783          	ld	a5,0(a5)
ffffffe0002006b0:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size) 
ffffffe0002006b4:	fd843703          	ld	a4,-40(s0)
ffffffe0002006b8:	fd043783          	ld	a5,-48(s0)
ffffffe0002006bc:	00f707b3          	add	a5,a4,a5
ffffffe0002006c0:	fe843703          	ld	a4,-24(s0)
ffffffe0002006c4:	02f71463          	bne	a4,a5,ffffffe0002006ec <buddy_free+0x150>
            buddy.bitmap[index] = node_size;
ffffffe0002006c8:	0000d797          	auipc	a5,0xd
ffffffe0002006cc:	97878793          	addi	a5,a5,-1672 # ffffffe00020d040 <buddy>
ffffffe0002006d0:	0087b703          	ld	a4,8(a5)
ffffffe0002006d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002006d8:	00379793          	slli	a5,a5,0x3
ffffffe0002006dc:	00f707b3          	add	a5,a4,a5
ffffffe0002006e0:	fe843703          	ld	a4,-24(s0)
ffffffe0002006e4:	00e7b023          	sd	a4,0(a5)
ffffffe0002006e8:	0300006f          	j	ffffffe000200718 <buddy_free+0x17c>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe0002006ec:	0000d797          	auipc	a5,0xd
ffffffe0002006f0:	95478793          	addi	a5,a5,-1708 # ffffffe00020d040 <buddy>
ffffffe0002006f4:	0087b703          	ld	a4,8(a5)
ffffffe0002006f8:	fe043783          	ld	a5,-32(s0)
ffffffe0002006fc:	00379793          	slli	a5,a5,0x3
ffffffe000200700:	00f706b3          	add	a3,a4,a5
ffffffe000200704:	fd843703          	ld	a4,-40(s0)
ffffffe000200708:	fd043783          	ld	a5,-48(s0)
ffffffe00020070c:	00e7f463          	bgeu	a5,a4,ffffffe000200714 <buddy_free+0x178>
ffffffe000200710:	00070793          	mv	a5,a4
ffffffe000200714:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200718:	fe043783          	ld	a5,-32(s0)
ffffffe00020071c:	f20798e3          	bnez	a5,ffffffe00020064c <buddy_free+0xb0>
    }
}
ffffffe000200720:	00000013          	nop
ffffffe000200724:	00000013          	nop
ffffffe000200728:	03813403          	ld	s0,56(sp)
ffffffe00020072c:	04010113          	addi	sp,sp,64
ffffffe000200730:	00008067          	ret

ffffffe000200734 <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages) {
ffffffe000200734:	fc010113          	addi	sp,sp,-64
ffffffe000200738:	02113c23          	sd	ra,56(sp)
ffffffe00020073c:	02813823          	sd	s0,48(sp)
ffffffe000200740:	04010413          	addi	s0,sp,64
ffffffe000200744:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe000200748:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe00020074c:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe000200750:	fc843783          	ld	a5,-56(s0)
ffffffe000200754:	00079863          	bnez	a5,ffffffe000200764 <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200758:	00100793          	li	a5,1
ffffffe00020075c:	fcf43423          	sd	a5,-56(s0)
ffffffe000200760:	0240006f          	j	ffffffe000200784 <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe000200764:	fc843783          	ld	a5,-56(s0)
ffffffe000200768:	fff78713          	addi	a4,a5,-1
ffffffe00020076c:	fc843783          	ld	a5,-56(s0)
ffffffe000200770:	00f777b3          	and	a5,a4,a5
ffffffe000200774:	00078863          	beqz	a5,ffffffe000200784 <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe000200778:	fc843503          	ld	a0,-56(s0)
ffffffe00020077c:	bc9ff0ef          	jal	ra,ffffffe000200344 <fixsize>
ffffffe000200780:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe000200784:	0000d797          	auipc	a5,0xd
ffffffe000200788:	8bc78793          	addi	a5,a5,-1860 # ffffffe00020d040 <buddy>
ffffffe00020078c:	0087b703          	ld	a4,8(a5)
ffffffe000200790:	fe843783          	ld	a5,-24(s0)
ffffffe000200794:	00379793          	slli	a5,a5,0x3
ffffffe000200798:	00f707b3          	add	a5,a4,a5
ffffffe00020079c:	0007b783          	ld	a5,0(a5)
ffffffe0002007a0:	fc843703          	ld	a4,-56(s0)
ffffffe0002007a4:	00e7f663          	bgeu	a5,a4,ffffffe0002007b0 <buddy_alloc+0x7c>
        return 0;
ffffffe0002007a8:	00000793          	li	a5,0
ffffffe0002007ac:	1480006f          	j	ffffffe0002008f4 <buddy_alloc+0x1c0>

    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe0002007b0:	0000d797          	auipc	a5,0xd
ffffffe0002007b4:	89078793          	addi	a5,a5,-1904 # ffffffe00020d040 <buddy>
ffffffe0002007b8:	0007b783          	ld	a5,0(a5)
ffffffe0002007bc:	fef43023          	sd	a5,-32(s0)
ffffffe0002007c0:	05c0006f          	j	ffffffe00020081c <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe0002007c4:	0000d797          	auipc	a5,0xd
ffffffe0002007c8:	87c78793          	addi	a5,a5,-1924 # ffffffe00020d040 <buddy>
ffffffe0002007cc:	0087b703          	ld	a4,8(a5)
ffffffe0002007d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002007d4:	00479793          	slli	a5,a5,0x4
ffffffe0002007d8:	00878793          	addi	a5,a5,8
ffffffe0002007dc:	00f707b3          	add	a5,a4,a5
ffffffe0002007e0:	0007b783          	ld	a5,0(a5)
ffffffe0002007e4:	fc843703          	ld	a4,-56(s0)
ffffffe0002007e8:	00e7ec63          	bltu	a5,a4,ffffffe000200800 <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe0002007ec:	fe843783          	ld	a5,-24(s0)
ffffffe0002007f0:	00179793          	slli	a5,a5,0x1
ffffffe0002007f4:	00178793          	addi	a5,a5,1
ffffffe0002007f8:	fef43423          	sd	a5,-24(s0)
ffffffe0002007fc:	0140006f          	j	ffffffe000200810 <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe000200800:	fe843783          	ld	a5,-24(s0)
ffffffe000200804:	00178793          	addi	a5,a5,1
ffffffe000200808:	00179793          	slli	a5,a5,0x1
ffffffe00020080c:	fef43423          	sd	a5,-24(s0)
    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe000200810:	fe043783          	ld	a5,-32(s0)
ffffffe000200814:	0017d793          	srli	a5,a5,0x1
ffffffe000200818:	fef43023          	sd	a5,-32(s0)
ffffffe00020081c:	fe043703          	ld	a4,-32(s0)
ffffffe000200820:	fc843783          	ld	a5,-56(s0)
ffffffe000200824:	faf710e3          	bne	a4,a5,ffffffe0002007c4 <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe000200828:	0000d797          	auipc	a5,0xd
ffffffe00020082c:	81878793          	addi	a5,a5,-2024 # ffffffe00020d040 <buddy>
ffffffe000200830:	0087b703          	ld	a4,8(a5)
ffffffe000200834:	fe843783          	ld	a5,-24(s0)
ffffffe000200838:	00379793          	slli	a5,a5,0x3
ffffffe00020083c:	00f707b3          	add	a5,a4,a5
ffffffe000200840:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe000200844:	fe843783          	ld	a5,-24(s0)
ffffffe000200848:	00178713          	addi	a4,a5,1
ffffffe00020084c:	fe043783          	ld	a5,-32(s0)
ffffffe000200850:	02f70733          	mul	a4,a4,a5
ffffffe000200854:	0000c797          	auipc	a5,0xc
ffffffe000200858:	7ec78793          	addi	a5,a5,2028 # ffffffe00020d040 <buddy>
ffffffe00020085c:	0007b783          	ld	a5,0(a5)
ffffffe000200860:	40f707b3          	sub	a5,a4,a5
ffffffe000200864:	fcf43c23          	sd	a5,-40(s0)

    while (index) {
ffffffe000200868:	0800006f          	j	ffffffe0002008e8 <buddy_alloc+0x1b4>
        index = PARENT(index);
ffffffe00020086c:	fe843783          	ld	a5,-24(s0)
ffffffe000200870:	00178793          	addi	a5,a5,1
ffffffe000200874:	0017d793          	srli	a5,a5,0x1
ffffffe000200878:	fff78793          	addi	a5,a5,-1
ffffffe00020087c:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] = 
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200880:	0000c797          	auipc	a5,0xc
ffffffe000200884:	7c078793          	addi	a5,a5,1984 # ffffffe00020d040 <buddy>
ffffffe000200888:	0087b703          	ld	a4,8(a5)
ffffffe00020088c:	fe843783          	ld	a5,-24(s0)
ffffffe000200890:	00178793          	addi	a5,a5,1
ffffffe000200894:	00479793          	slli	a5,a5,0x4
ffffffe000200898:	00f707b3          	add	a5,a4,a5
ffffffe00020089c:	0007b603          	ld	a2,0(a5)
ffffffe0002008a0:	0000c797          	auipc	a5,0xc
ffffffe0002008a4:	7a078793          	addi	a5,a5,1952 # ffffffe00020d040 <buddy>
ffffffe0002008a8:	0087b703          	ld	a4,8(a5)
ffffffe0002008ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002008b0:	00479793          	slli	a5,a5,0x4
ffffffe0002008b4:	00878793          	addi	a5,a5,8
ffffffe0002008b8:	00f707b3          	add	a5,a4,a5
ffffffe0002008bc:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008c0:	0000c797          	auipc	a5,0xc
ffffffe0002008c4:	78078793          	addi	a5,a5,1920 # ffffffe00020d040 <buddy>
ffffffe0002008c8:	0087b683          	ld	a3,8(a5)
ffffffe0002008cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002008d0:	00379793          	slli	a5,a5,0x3
ffffffe0002008d4:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe0002008d8:	00060793          	mv	a5,a2
ffffffe0002008dc:	00e7f463          	bgeu	a5,a4,ffffffe0002008e4 <buddy_alloc+0x1b0>
ffffffe0002008e0:	00070793          	mv	a5,a4
        buddy.bitmap[index] = 
ffffffe0002008e4:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe0002008e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008ec:	f80790e3          	bnez	a5,ffffffe00020086c <buddy_alloc+0x138>
    }
    
    return pfn;
ffffffe0002008f0:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002008f4:	00078513          	mv	a0,a5
ffffffe0002008f8:	03813083          	ld	ra,56(sp)
ffffffe0002008fc:	03013403          	ld	s0,48(sp)
ffffffe000200900:	04010113          	addi	sp,sp,64
ffffffe000200904:	00008067          	ret

ffffffe000200908 <alloc_pages>:


void *alloc_pages(uint64_t nrpages) {
ffffffe000200908:	fd010113          	addi	sp,sp,-48
ffffffe00020090c:	02113423          	sd	ra,40(sp)
ffffffe000200910:	02813023          	sd	s0,32(sp)
ffffffe000200914:	03010413          	addi	s0,sp,48
ffffffe000200918:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe00020091c:	fd843503          	ld	a0,-40(s0)
ffffffe000200920:	e15ff0ef          	jal	ra,ffffffe000200734 <buddy_alloc>
ffffffe000200924:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe000200928:	fe843783          	ld	a5,-24(s0)
ffffffe00020092c:	00079663          	bnez	a5,ffffffe000200938 <alloc_pages+0x30>
        return 0;
ffffffe000200930:	00000793          	li	a5,0
ffffffe000200934:	0180006f          	j	ffffffe00020094c <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe000200938:	fe843783          	ld	a5,-24(s0)
ffffffe00020093c:	00c79713          	slli	a4,a5,0xc
ffffffe000200940:	fff00793          	li	a5,-1
ffffffe000200944:	02579793          	slli	a5,a5,0x25
ffffffe000200948:	00f707b3          	add	a5,a4,a5
}
ffffffe00020094c:	00078513          	mv	a0,a5
ffffffe000200950:	02813083          	ld	ra,40(sp)
ffffffe000200954:	02013403          	ld	s0,32(sp)
ffffffe000200958:	03010113          	addi	sp,sp,48
ffffffe00020095c:	00008067          	ret

ffffffe000200960 <alloc_page>:

void *alloc_page() {
ffffffe000200960:	ff010113          	addi	sp,sp,-16
ffffffe000200964:	00113423          	sd	ra,8(sp)
ffffffe000200968:	00813023          	sd	s0,0(sp)
ffffffe00020096c:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe000200970:	00100513          	li	a0,1
ffffffe000200974:	f95ff0ef          	jal	ra,ffffffe000200908 <alloc_pages>
ffffffe000200978:	00050793          	mv	a5,a0
}
ffffffe00020097c:	00078513          	mv	a0,a5
ffffffe000200980:	00813083          	ld	ra,8(sp)
ffffffe000200984:	00013403          	ld	s0,0(sp)
ffffffe000200988:	01010113          	addi	sp,sp,16
ffffffe00020098c:	00008067          	ret

ffffffe000200990 <free_pages>:

void free_pages(void *va) {
ffffffe000200990:	fe010113          	addi	sp,sp,-32
ffffffe000200994:	00113c23          	sd	ra,24(sp)
ffffffe000200998:	00813823          	sd	s0,16(sp)
ffffffe00020099c:	02010413          	addi	s0,sp,32
ffffffe0002009a0:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe0002009a4:	fe843703          	ld	a4,-24(s0)
ffffffe0002009a8:	00100793          	li	a5,1
ffffffe0002009ac:	02579793          	slli	a5,a5,0x25
ffffffe0002009b0:	00f707b3          	add	a5,a4,a5
ffffffe0002009b4:	00c7d793          	srli	a5,a5,0xc
ffffffe0002009b8:	00078513          	mv	a0,a5
ffffffe0002009bc:	be1ff0ef          	jal	ra,ffffffe00020059c <buddy_free>
}
ffffffe0002009c0:	00000013          	nop
ffffffe0002009c4:	01813083          	ld	ra,24(sp)
ffffffe0002009c8:	01013403          	ld	s0,16(sp)
ffffffe0002009cc:	02010113          	addi	sp,sp,32
ffffffe0002009d0:	00008067          	ret

ffffffe0002009d4 <kalloc>:

void *kalloc() {
ffffffe0002009d4:	ff010113          	addi	sp,sp,-16
ffffffe0002009d8:	00113423          	sd	ra,8(sp)
ffffffe0002009dc:	00813023          	sd	s0,0(sp)
ffffffe0002009e0:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;
    
    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe0002009e4:	f7dff0ef          	jal	ra,ffffffe000200960 <alloc_page>
ffffffe0002009e8:	00050793          	mv	a5,a0
}
ffffffe0002009ec:	00078513          	mv	a0,a5
ffffffe0002009f0:	00813083          	ld	ra,8(sp)
ffffffe0002009f4:	00013403          	ld	s0,0(sp)
ffffffe0002009f8:	01010113          	addi	sp,sp,16
ffffffe0002009fc:	00008067          	ret

ffffffe000200a00 <kfree>:

void kfree(void *addr) {
ffffffe000200a00:	fe010113          	addi	sp,sp,-32
ffffffe000200a04:	00113c23          	sd	ra,24(sp)
ffffffe000200a08:	00813823          	sd	s0,16(sp)
ffffffe000200a0c:	02010413          	addi	s0,sp,32
ffffffe000200a10:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe000200a14:	fe843503          	ld	a0,-24(s0)
ffffffe000200a18:	f79ff0ef          	jal	ra,ffffffe000200990 <free_pages>

    return;
ffffffe000200a1c:	00000013          	nop
}
ffffffe000200a20:	01813083          	ld	ra,24(sp)
ffffffe000200a24:	01013403          	ld	s0,16(sp)
ffffffe000200a28:	02010113          	addi	sp,sp,32
ffffffe000200a2c:	00008067          	ret

ffffffe000200a30 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe000200a30:	fd010113          	addi	sp,sp,-48
ffffffe000200a34:	02113423          	sd	ra,40(sp)
ffffffe000200a38:	02813023          	sd	s0,32(sp)
ffffffe000200a3c:	03010413          	addi	s0,sp,48
ffffffe000200a40:	fca43c23          	sd	a0,-40(s0)
ffffffe000200a44:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe000200a48:	fd843703          	ld	a4,-40(s0)
ffffffe000200a4c:	000017b7          	lui	a5,0x1
ffffffe000200a50:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200a54:	00f70733          	add	a4,a4,a5
ffffffe000200a58:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a5c:	00f777b3          	and	a5,a4,a5
ffffffe000200a60:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a64:	01c0006f          	j	ffffffe000200a80 <kfreerange+0x50>
        kfree((void *)addr);
ffffffe000200a68:	fe843503          	ld	a0,-24(s0)
ffffffe000200a6c:	f95ff0ef          	jal	ra,ffffffe000200a00 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a70:	fe843703          	ld	a4,-24(s0)
ffffffe000200a74:	000017b7          	lui	a5,0x1
ffffffe000200a78:	00f707b3          	add	a5,a4,a5
ffffffe000200a7c:	fef43423          	sd	a5,-24(s0)
ffffffe000200a80:	fe843703          	ld	a4,-24(s0)
ffffffe000200a84:	000017b7          	lui	a5,0x1
ffffffe000200a88:	00f70733          	add	a4,a4,a5
ffffffe000200a8c:	fd043783          	ld	a5,-48(s0)
ffffffe000200a90:	fce7fce3          	bgeu	a5,a4,ffffffe000200a68 <kfreerange+0x38>
    }
}
ffffffe000200a94:	00000013          	nop
ffffffe000200a98:	00000013          	nop
ffffffe000200a9c:	02813083          	ld	ra,40(sp)
ffffffe000200aa0:	02013403          	ld	s0,32(sp)
ffffffe000200aa4:	03010113          	addi	sp,sp,48
ffffffe000200aa8:	00008067          	ret

ffffffe000200aac <mm_init>:

void mm_init(void) {
ffffffe000200aac:	ff010113          	addi	sp,sp,-16
ffffffe000200ab0:	00113423          	sd	ra,8(sp)
ffffffe000200ab4:	00813023          	sd	s0,0(sp)
ffffffe000200ab8:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200abc:	935ff0ef          	jal	ra,ffffffe0002003f0 <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200ac0:	00006517          	auipc	a0,0x6
ffffffe000200ac4:	56050513          	addi	a0,a0,1376 # ffffffe000207020 <__func__.4+0x20>
ffffffe000200ac8:	0a9030ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe000200acc:	00000013          	nop
ffffffe000200ad0:	00813083          	ld	ra,8(sp)
ffffffe000200ad4:	00013403          	ld	s0,0(sp)
ffffffe000200ad8:	01010113          	addi	sp,sp,16
ffffffe000200adc:	00008067          	ret

ffffffe000200ae0 <get_nr_tasks>:
extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];

int get_nr_tasks()
{
ffffffe000200ae0:	ff010113          	addi	sp,sp,-16
ffffffe000200ae4:	00813423          	sd	s0,8(sp)
ffffffe000200ae8:	01010413          	addi	s0,sp,16
    return nr_tasks;
ffffffe000200aec:	0000c797          	auipc	a5,0xc
ffffffe000200af0:	52c78793          	addi	a5,a5,1324 # ffffffe00020d018 <nr_tasks>
ffffffe000200af4:	0007a783          	lw	a5,0(a5)
}
ffffffe000200af8:	00078513          	mv	a0,a5
ffffffe000200afc:	00813403          	ld	s0,8(sp)
ffffffe000200b00:	01010113          	addi	sp,sp,16
ffffffe000200b04:	00008067          	ret

ffffffe000200b08 <get_current_proc>:

struct task_struct *get_current_proc()
{
ffffffe000200b08:	ff010113          	addi	sp,sp,-16
ffffffe000200b0c:	00813423          	sd	s0,8(sp)
ffffffe000200b10:	01010413          	addi	s0,sp,16
    return current;
ffffffe000200b14:	0000c797          	auipc	a5,0xc
ffffffe000200b18:	4fc78793          	addi	a5,a5,1276 # ffffffe00020d010 <current>
ffffffe000200b1c:	0007b783          	ld	a5,0(a5)
}
ffffffe000200b20:	00078513          	mv	a0,a5
ffffffe000200b24:	00813403          	ld	s0,8(sp)
ffffffe000200b28:	01010113          	addi	sp,sp,16
ffffffe000200b2c:	00008067          	ret

ffffffe000200b30 <set_user_pgtbl>:

void set_user_pgtbl(struct task_struct *T)
{
ffffffe000200b30:	fd010113          	addi	sp,sp,-48
ffffffe000200b34:	02113423          	sd	ra,40(sp)
ffffffe000200b38:	02813023          	sd	s0,32(sp)
ffffffe000200b3c:	00913c23          	sd	s1,24(sp)
ffffffe000200b40:	03010413          	addi	s0,sp,48
ffffffe000200b44:	fca43c23          	sd	a0,-40(s0)
    T->pgd = (uint64_t *)alloc_page();
ffffffe000200b48:	e19ff0ef          	jal	ra,ffffffe000200960 <alloc_page>
ffffffe000200b4c:	00050713          	mv	a4,a0
ffffffe000200b50:	fd843783          	ld	a5,-40(s0)
ffffffe000200b54:	0ae7b423          	sd	a4,168(a5)
    memset(T->pgd, 0, PGSIZE);
ffffffe000200b58:	fd843783          	ld	a5,-40(s0)
ffffffe000200b5c:	0a87b783          	ld	a5,168(a5)
ffffffe000200b60:	00001637          	lui	a2,0x1
ffffffe000200b64:	00000593          	li	a1,0
ffffffe000200b68:	00078513          	mv	a0,a5
ffffffe000200b6c:	125030ef          	jal	ra,ffffffe000204490 <memset>
    memcpy(T->pgd, get_kernel_pgtbl(), PGSIZE);
ffffffe000200b70:	fd843783          	ld	a5,-40(s0)
ffffffe000200b74:	0a87b483          	ld	s1,168(a5)
ffffffe000200b78:	4e0020ef          	jal	ra,ffffffe000203058 <get_kernel_pgtbl>
ffffffe000200b7c:	00050793          	mv	a5,a0
ffffffe000200b80:	00001637          	lui	a2,0x1
ffffffe000200b84:	00078593          	mv	a1,a5
ffffffe000200b88:	00048513          	mv	a0,s1
ffffffe000200b8c:	175030ef          	jal	ra,ffffffe000204500 <memcpy>

    printk("set_user_pgtbl: T->pgd = %p\n", T->pgd);
ffffffe000200b90:	fd843783          	ld	a5,-40(s0)
ffffffe000200b94:	0a87b783          	ld	a5,168(a5)
ffffffe000200b98:	00078593          	mv	a1,a5
ffffffe000200b9c:	00006517          	auipc	a0,0x6
ffffffe000200ba0:	49c50513          	addi	a0,a0,1180 # ffffffe000207038 <__func__.4+0x38>
ffffffe000200ba4:	7cc030ef          	jal	ra,ffffffe000204370 <printk>
    // uint64_t va = USER_END - PGSIZE;
    // printk("set_user_pgtbl: va = %lx, pa = %lx\n", va, pa);
    // create_mapping(T->pgd, va, pa, PGSIZE, user_perm);

    // vma
    do_mmap(&(T->mm), USER_END - PGSIZE, PGSIZE, 0, 0, VM_ANON | VM_READ | VM_WRITE);
ffffffe000200ba8:	fd843783          	ld	a5,-40(s0)
ffffffe000200bac:	0b078513          	addi	a0,a5,176
ffffffe000200bb0:	00700793          	li	a5,7
ffffffe000200bb4:	00000713          	li	a4,0
ffffffe000200bb8:	00000693          	li	a3,0
ffffffe000200bbc:	00001637          	lui	a2,0x1
ffffffe000200bc0:	040005b7          	lui	a1,0x4000
ffffffe000200bc4:	fff58593          	addi	a1,a1,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000200bc8:	00c59593          	slli	a1,a1,0xc
ffffffe000200bcc:	021000ef          	jal	ra,ffffffe0002013ec <do_mmap>
    printk("set_user_pgtbl done\n");
ffffffe000200bd0:	00006517          	auipc	a0,0x6
ffffffe000200bd4:	48850513          	addi	a0,a0,1160 # ffffffe000207058 <__func__.4+0x58>
ffffffe000200bd8:	798030ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe000200bdc:	00000013          	nop
ffffffe000200be0:	02813083          	ld	ra,40(sp)
ffffffe000200be4:	02013403          	ld	s0,32(sp)
ffffffe000200be8:	01813483          	ld	s1,24(sp)
ffffffe000200bec:	03010113          	addi	sp,sp,48
ffffffe000200bf0:	00008067          	ret

ffffffe000200bf4 <load_program>:

void load_program(struct task_struct *task)
{
ffffffe000200bf4:	fb010113          	addi	sp,sp,-80
ffffffe000200bf8:	04113423          	sd	ra,72(sp)
ffffffe000200bfc:	04813023          	sd	s0,64(sp)
ffffffe000200c00:	05010413          	addi	s0,sp,80
ffffffe000200c04:	faa43c23          	sd	a0,-72(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200c08:	00008797          	auipc	a5,0x8
ffffffe000200c0c:	3f878793          	addi	a5,a5,1016 # ffffffe000209000 <_sramdisk>
ffffffe000200c10:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200c14:	fe043783          	ld	a5,-32(s0)
ffffffe000200c18:	0207b703          	ld	a4,32(a5)
ffffffe000200c1c:	00008797          	auipc	a5,0x8
ffffffe000200c20:	3e478793          	addi	a5,a5,996 # ffffffe000209000 <_sramdisk>
ffffffe000200c24:	00f707b3          	add	a5,a4,a5
ffffffe000200c28:	fcf43c23          	sd	a5,-40(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200c2c:	fe042623          	sw	zero,-20(s0)
ffffffe000200c30:	0b40006f          	j	ffffffe000200ce4 <load_program+0xf0>
    {
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200c34:	fec42703          	lw	a4,-20(s0)
ffffffe000200c38:	00070793          	mv	a5,a4
ffffffe000200c3c:	00379793          	slli	a5,a5,0x3
ffffffe000200c40:	40e787b3          	sub	a5,a5,a4
ffffffe000200c44:	00379793          	slli	a5,a5,0x3
ffffffe000200c48:	00078713          	mv	a4,a5
ffffffe000200c4c:	fd843783          	ld	a5,-40(s0)
ffffffe000200c50:	00e787b3          	add	a5,a5,a4
ffffffe000200c54:	fcf43823          	sd	a5,-48(s0)
        if (phdr->p_type == PT_LOAD)
ffffffe000200c58:	fd043783          	ld	a5,-48(s0)
ffffffe000200c5c:	0007a783          	lw	a5,0(a5)
ffffffe000200c60:	00078713          	mv	a4,a5
ffffffe000200c64:	00100793          	li	a5,1
ffffffe000200c68:	06f71863          	bne	a4,a5,ffffffe000200cd8 <load_program+0xe4>
        {
            // alloc space and copy content
            uint64_t align_offset = phdr->p_vaddr % PGSIZE;
ffffffe000200c6c:	fd043783          	ld	a5,-48(s0)
ffffffe000200c70:	0107b703          	ld	a4,16(a5)
ffffffe000200c74:	000017b7          	lui	a5,0x1
ffffffe000200c78:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200c7c:	00f777b3          	and	a5,a4,a5
ffffffe000200c80:	fcf43423          	sd	a5,-56(s0)
            uint64_t num_pg = (phdr->p_memsz + align_offset + PGSIZE - 1) / PGSIZE;
ffffffe000200c84:	fd043783          	ld	a5,-48(s0)
ffffffe000200c88:	0287b703          	ld	a4,40(a5)
ffffffe000200c8c:	fc843783          	ld	a5,-56(s0)
ffffffe000200c90:	00f70733          	add	a4,a4,a5
ffffffe000200c94:	000017b7          	lui	a5,0x1
ffffffe000200c98:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200c9c:	00f707b3          	add	a5,a4,a5
ffffffe000200ca0:	00c7d793          	srli	a5,a5,0xc
ffffffe000200ca4:	fcf43023          	sd	a5,-64(s0)
            // memset((void *)((uint64_t)new_pgs + align_offset + phdr->p_filesz), 0x0, phdr->p_memsz - phdr->p_filesz);
            // do mapping
            // create_mapping(task->pgd, phdr->p_vaddr - align_offset, VA2PA((uint64_t)new_pgs), phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
            // printk("[load_program] va = %lx, pa = %lx, sz = %lx, perm = %lx\//n", phdr->p_vaddr - align_offset, (uint64_t)new_pgs - PA2VA_OFFSET, phdr->p_memsz + align_offset, PTE_U | PTE_X | phdr->p_flags);
            // vma
            do_mmap(&(task->mm), phdr->p_vaddr, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, VM_READ | VM_WRITE | VM_EXEC);
ffffffe000200ca8:	fb843783          	ld	a5,-72(s0)
ffffffe000200cac:	0b078513          	addi	a0,a5,176
ffffffe000200cb0:	fd043783          	ld	a5,-48(s0)
ffffffe000200cb4:	0107b583          	ld	a1,16(a5)
ffffffe000200cb8:	fd043783          	ld	a5,-48(s0)
ffffffe000200cbc:	0287b603          	ld	a2,40(a5)
ffffffe000200cc0:	fd043783          	ld	a5,-48(s0)
ffffffe000200cc4:	0087b683          	ld	a3,8(a5)
ffffffe000200cc8:	fd043783          	ld	a5,-48(s0)
ffffffe000200ccc:	0207b703          	ld	a4,32(a5)
ffffffe000200cd0:	00e00793          	li	a5,14
ffffffe000200cd4:	718000ef          	jal	ra,ffffffe0002013ec <do_mmap>
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe000200cd8:	fec42783          	lw	a5,-20(s0)
ffffffe000200cdc:	0017879b          	addiw	a5,a5,1
ffffffe000200ce0:	fef42623          	sw	a5,-20(s0)
ffffffe000200ce4:	fe043783          	ld	a5,-32(s0)
ffffffe000200ce8:	0387d783          	lhu	a5,56(a5)
ffffffe000200cec:	0007871b          	sext.w	a4,a5
ffffffe000200cf0:	fec42783          	lw	a5,-20(s0)
ffffffe000200cf4:	0007879b          	sext.w	a5,a5
ffffffe000200cf8:	f2e7cee3          	blt	a5,a4,ffffffe000200c34 <load_program+0x40>
            // code...
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe000200cfc:	fe043783          	ld	a5,-32(s0)
ffffffe000200d00:	0187b703          	ld	a4,24(a5)
ffffffe000200d04:	fb843783          	ld	a5,-72(s0)
ffffffe000200d08:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200d0c:	00000013          	nop
ffffffe000200d10:	04813083          	ld	ra,72(sp)
ffffffe000200d14:	04013403          	ld	s0,64(sp)
ffffffe000200d18:	05010113          	addi	sp,sp,80
ffffffe000200d1c:	00008067          	ret

ffffffe000200d20 <task_init>:

void task_init()
{
ffffffe000200d20:	fd010113          	addi	sp,sp,-48
ffffffe000200d24:	02113423          	sd	ra,40(sp)
ffffffe000200d28:	02813023          	sd	s0,32(sp)
ffffffe000200d2c:	00913c23          	sd	s1,24(sp)
ffffffe000200d30:	03010413          	addi	s0,sp,48
    srand(2024);
ffffffe000200d34:	7e800513          	li	a0,2024
ffffffe000200d38:	6b8030ef          	jal	ra,ffffffe0002043f0 <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
ffffffe000200d3c:	c99ff0ef          	jal	ra,ffffffe0002009d4 <kalloc>
ffffffe000200d40:	00050713          	mv	a4,a0
ffffffe000200d44:	0000c797          	auipc	a5,0xc
ffffffe000200d48:	2c478793          	addi	a5,a5,708 # ffffffe00020d008 <idle>
ffffffe000200d4c:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe000200d50:	0000c797          	auipc	a5,0xc
ffffffe000200d54:	2b878793          	addi	a5,a5,696 # ffffffe00020d008 <idle>
ffffffe000200d58:	0007b783          	ld	a5,0(a5)
ffffffe000200d5c:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200d60:	0000c797          	auipc	a5,0xc
ffffffe000200d64:	2a878793          	addi	a5,a5,680 # ffffffe00020d008 <idle>
ffffffe000200d68:	0007b783          	ld	a5,0(a5)
ffffffe000200d6c:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200d70:	0000c797          	auipc	a5,0xc
ffffffe000200d74:	29878793          	addi	a5,a5,664 # ffffffe00020d008 <idle>
ffffffe000200d78:	0007b783          	ld	a5,0(a5)
ffffffe000200d7c:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200d80:	0000c797          	auipc	a5,0xc
ffffffe000200d84:	28878793          	addi	a5,a5,648 # ffffffe00020d008 <idle>
ffffffe000200d88:	0007b783          	ld	a5,0(a5)
ffffffe000200d8c:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe000200d90:	0000c797          	auipc	a5,0xc
ffffffe000200d94:	27878793          	addi	a5,a5,632 # ffffffe00020d008 <idle>
ffffffe000200d98:	0007b703          	ld	a4,0(a5)
ffffffe000200d9c:	0000c797          	auipc	a5,0xc
ffffffe000200da0:	27478793          	addi	a5,a5,628 # ffffffe00020d010 <current>
ffffffe000200da4:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200da8:	0000c797          	auipc	a5,0xc
ffffffe000200dac:	26078793          	addi	a5,a5,608 # ffffffe00020d008 <idle>
ffffffe000200db0:	0007b703          	ld	a4,0(a5)
ffffffe000200db4:	0000c797          	auipc	a5,0xc
ffffffe000200db8:	29c78793          	addi	a5,a5,668 # ffffffe00020d050 <task>
ffffffe000200dbc:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000200dc0:	00100793          	li	a5,1
ffffffe000200dc4:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200dc8:	2840006f          	j	ffffffe00020104c <task_init+0x32c>
    {
        task[i] = (struct task_struct *)kalloc();
ffffffe000200dcc:	c09ff0ef          	jal	ra,ffffffe0002009d4 <kalloc>
ffffffe000200dd0:	00050693          	mv	a3,a0
ffffffe000200dd4:	0000c717          	auipc	a4,0xc
ffffffe000200dd8:	27c70713          	addi	a4,a4,636 # ffffffe00020d050 <task>
ffffffe000200ddc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200de0:	00379793          	slli	a5,a5,0x3
ffffffe000200de4:	00f707b3          	add	a5,a4,a5
ffffffe000200de8:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200dec:	0000c717          	auipc	a4,0xc
ffffffe000200df0:	26470713          	addi	a4,a4,612 # ffffffe00020d050 <task>
ffffffe000200df4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200df8:	00379793          	slli	a5,a5,0x3
ffffffe000200dfc:	00f707b3          	add	a5,a4,a5
ffffffe000200e00:	0007b783          	ld	a5,0(a5)
ffffffe000200e04:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200e08:	62c030ef          	jal	ra,ffffffe000204434 <rand>
ffffffe000200e0c:	00050793          	mv	a5,a0
ffffffe000200e10:	00078713          	mv	a4,a5
ffffffe000200e14:	00a00793          	li	a5,10
ffffffe000200e18:	02f767bb          	remw	a5,a4,a5
ffffffe000200e1c:	0007879b          	sext.w	a5,a5
ffffffe000200e20:	0017879b          	addiw	a5,a5,1
ffffffe000200e24:	0007869b          	sext.w	a3,a5
ffffffe000200e28:	0000c717          	auipc	a4,0xc
ffffffe000200e2c:	22870713          	addi	a4,a4,552 # ffffffe00020d050 <task>
ffffffe000200e30:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e34:	00379793          	slli	a5,a5,0x3
ffffffe000200e38:	00f707b3          	add	a5,a4,a5
ffffffe000200e3c:	0007b783          	ld	a5,0(a5)
ffffffe000200e40:	00068713          	mv	a4,a3
ffffffe000200e44:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe000200e48:	0000c717          	auipc	a4,0xc
ffffffe000200e4c:	20870713          	addi	a4,a4,520 # ffffffe00020d050 <task>
ffffffe000200e50:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e54:	00379793          	slli	a5,a5,0x3
ffffffe000200e58:	00f707b3          	add	a5,a4,a5
ffffffe000200e5c:	0007b783          	ld	a5,0(a5)
ffffffe000200e60:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe000200e64:	0000c717          	auipc	a4,0xc
ffffffe000200e68:	1ec70713          	addi	a4,a4,492 # ffffffe00020d050 <task>
ffffffe000200e6c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e70:	00379793          	slli	a5,a5,0x3
ffffffe000200e74:	00f707b3          	add	a5,a4,a5
ffffffe000200e78:	0007b783          	ld	a5,0(a5)
ffffffe000200e7c:	fdc42703          	lw	a4,-36(s0)
ffffffe000200e80:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe000200e84:	0000c717          	auipc	a4,0xc
ffffffe000200e88:	1cc70713          	addi	a4,a4,460 # ffffffe00020d050 <task>
ffffffe000200e8c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e90:	00379793          	slli	a5,a5,0x3
ffffffe000200e94:	00f707b3          	add	a5,a4,a5
ffffffe000200e98:	0007b783          	ld	a5,0(a5)
ffffffe000200e9c:	fffff717          	auipc	a4,0xfffff
ffffffe000200ea0:	34c70713          	addi	a4,a4,844 # ffffffe0002001e8 <__dummy>
ffffffe000200ea4:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe000200ea8:	0000c717          	auipc	a4,0xc
ffffffe000200eac:	1a870713          	addi	a4,a4,424 # ffffffe00020d050 <task>
ffffffe000200eb0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200eb4:	00379793          	slli	a5,a5,0x3
ffffffe000200eb8:	00f707b3          	add	a5,a4,a5
ffffffe000200ebc:	0007b783          	ld	a5,0(a5)
ffffffe000200ec0:	00078693          	mv	a3,a5
ffffffe000200ec4:	0000c717          	auipc	a4,0xc
ffffffe000200ec8:	18c70713          	addi	a4,a4,396 # ffffffe00020d050 <task>
ffffffe000200ecc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ed0:	00379793          	slli	a5,a5,0x3
ffffffe000200ed4:	00f707b3          	add	a5,a4,a5
ffffffe000200ed8:	0007b783          	ld	a5,0(a5)
ffffffe000200edc:	00001737          	lui	a4,0x1
ffffffe000200ee0:	00e68733          	add	a4,a3,a4
ffffffe000200ee4:	02e7b423          	sd	a4,40(a5)
        set_user_pgtbl(task[i]);
ffffffe000200ee8:	0000c717          	auipc	a4,0xc
ffffffe000200eec:	16870713          	addi	a4,a4,360 # ffffffe00020d050 <task>
ffffffe000200ef0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ef4:	00379793          	slli	a5,a5,0x3
ffffffe000200ef8:	00f707b3          	add	a5,a4,a5
ffffffe000200efc:	0007b783          	ld	a5,0(a5)
ffffffe000200f00:	00078513          	mv	a0,a5
ffffffe000200f04:	c2dff0ef          	jal	ra,ffffffe000200b30 <set_user_pgtbl>
        // uint64_t uapp_pages = (PGROUNDUP(_eramdisk - _sramdisk)) / PGSIZE;
        // uint64_t *uapp_mem = (uint64_t *)alloc_pages(uapp_pages);
        // memcpy(uapp_mem, _sramdisk, uapp_pages * PGSIZE);
        // create_mapping(task[i]->pgd, USER_START, VA2PA((uint64_t)uapp_mem), uapp_pages * PGSIZE, PTE_V | PTE_R | PTE_W | PTE_X | PTE_U);
        load_program(task[i]);
ffffffe000200f08:	0000c717          	auipc	a4,0xc
ffffffe000200f0c:	14870713          	addi	a4,a4,328 # ffffffe00020d050 <task>
ffffffe000200f10:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f14:	00379793          	slli	a5,a5,0x3
ffffffe000200f18:	00f707b3          	add	a5,a4,a5
ffffffe000200f1c:	0007b783          	ld	a5,0(a5)
ffffffe000200f20:	00078513          	mv	a0,a5
ffffffe000200f24:	cd1ff0ef          	jal	ra,ffffffe000200bf4 <load_program>
        // task[i]->thread.sepc = USER_START;
        // uint64_t sstatus = SSTATUS_SPIE | SSTATUS_SPP;
        // sstatus &= ~SSTATUS_SPP;
        // task[i]->thread.sstatus = sstatus;
        // task[i]->thread.sscratch = USER_END;
        task[i]->thread.sstatus = 0;
ffffffe000200f28:	0000c717          	auipc	a4,0xc
ffffffe000200f2c:	12870713          	addi	a4,a4,296 # ffffffe00020d050 <task>
ffffffe000200f30:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f34:	00379793          	slli	a5,a5,0x3
ffffffe000200f38:	00f707b3          	add	a5,a4,a5
ffffffe000200f3c:	0007b783          	ld	a5,0(a5)
ffffffe000200f40:	0807bc23          	sd	zero,152(a5)
        task[i]->thread.sstatus &= ~SSTATUS_SPP;
ffffffe000200f44:	0000c717          	auipc	a4,0xc
ffffffe000200f48:	10c70713          	addi	a4,a4,268 # ffffffe00020d050 <task>
ffffffe000200f4c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f50:	00379793          	slli	a5,a5,0x3
ffffffe000200f54:	00f707b3          	add	a5,a4,a5
ffffffe000200f58:	0007b783          	ld	a5,0(a5)
ffffffe000200f5c:	0987b703          	ld	a4,152(a5)
ffffffe000200f60:	0000c697          	auipc	a3,0xc
ffffffe000200f64:	0f068693          	addi	a3,a3,240 # ffffffe00020d050 <task>
ffffffe000200f68:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f6c:	00379793          	slli	a5,a5,0x3
ffffffe000200f70:	00f687b3          	add	a5,a3,a5
ffffffe000200f74:	0007b783          	ld	a5,0(a5)
ffffffe000200f78:	eff77713          	andi	a4,a4,-257
ffffffe000200f7c:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sstatus |= SSTATUS_SPIE | SSTATUS_SUM;
ffffffe000200f80:	0000c717          	auipc	a4,0xc
ffffffe000200f84:	0d070713          	addi	a4,a4,208 # ffffffe00020d050 <task>
ffffffe000200f88:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f8c:	00379793          	slli	a5,a5,0x3
ffffffe000200f90:	00f707b3          	add	a5,a4,a5
ffffffe000200f94:	0007b783          	ld	a5,0(a5)
ffffffe000200f98:	0987b683          	ld	a3,152(a5)
ffffffe000200f9c:	0000c717          	auipc	a4,0xc
ffffffe000200fa0:	0b470713          	addi	a4,a4,180 # ffffffe00020d050 <task>
ffffffe000200fa4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fa8:	00379793          	slli	a5,a5,0x3
ffffffe000200fac:	00f707b3          	add	a5,a4,a5
ffffffe000200fb0:	0007b783          	ld	a5,0(a5)
ffffffe000200fb4:	00040737          	lui	a4,0x40
ffffffe000200fb8:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe000200fbc:	00e6e733          	or	a4,a3,a4
ffffffe000200fc0:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe000200fc4:	0000c717          	auipc	a4,0xc
ffffffe000200fc8:	08c70713          	addi	a4,a4,140 # ffffffe00020d050 <task>
ffffffe000200fcc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fd0:	00379793          	slli	a5,a5,0x3
ffffffe000200fd4:	00f707b3          	add	a5,a4,a5
ffffffe000200fd8:	0007b783          	ld	a5,0(a5)
ffffffe000200fdc:	00100713          	li	a4,1
ffffffe000200fe0:	02671713          	slli	a4,a4,0x26
ffffffe000200fe4:	0ae7b023          	sd	a4,160(a5)
        task[i]->files = file_init();
ffffffe000200fe8:	0000c717          	auipc	a4,0xc
ffffffe000200fec:	06870713          	addi	a4,a4,104 # ffffffe00020d050 <task>
ffffffe000200ff0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ff4:	00379793          	slli	a5,a5,0x3
ffffffe000200ff8:	00f707b3          	add	a5,a4,a5
ffffffe000200ffc:	0007b483          	ld	s1,0(a5)
ffffffe000201000:	400040ef          	jal	ra,ffffffe000205400 <file_init>
ffffffe000201004:	00050793          	mv	a5,a0
ffffffe000201008:	0af4bc23          	sd	a5,184(s1)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe00020100c:	0000c717          	auipc	a4,0xc
ffffffe000201010:	04470713          	addi	a4,a4,68 # ffffffe00020d050 <task>
ffffffe000201014:	fdc42783          	lw	a5,-36(s0)
ffffffe000201018:	00379793          	slli	a5,a5,0x3
ffffffe00020101c:	00f707b3          	add	a5,a4,a5
ffffffe000201020:	0007b783          	ld	a5,0(a5)
ffffffe000201024:	0107b703          	ld	a4,16(a5)
ffffffe000201028:	fdc42783          	lw	a5,-36(s0)
ffffffe00020102c:	00070613          	mv	a2,a4
ffffffe000201030:	00078593          	mv	a1,a5
ffffffe000201034:	00006517          	auipc	a0,0x6
ffffffe000201038:	03c50513          	addi	a0,a0,60 # ffffffe000207070 <__func__.4+0x70>
ffffffe00020103c:	334030ef          	jal	ra,ffffffe000204370 <printk>
    for (int i = 1; i < NR_TASKS; i++)
ffffffe000201040:	fdc42783          	lw	a5,-36(s0)
ffffffe000201044:	0017879b          	addiw	a5,a5,1
ffffffe000201048:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020104c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201050:	0007871b          	sext.w	a4,a5
ffffffe000201054:	00100793          	li	a5,1
ffffffe000201058:	d6e7dae3          	bge	a5,a4,ffffffe000200dcc <task_init+0xac>
    }

    printk("...task_init done!\n");
ffffffe00020105c:	00006517          	auipc	a0,0x6
ffffffe000201060:	03450513          	addi	a0,a0,52 # ffffffe000207090 <__func__.4+0x90>
ffffffe000201064:	30c030ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe000201068:	00000013          	nop
ffffffe00020106c:	02813083          	ld	ra,40(sp)
ffffffe000201070:	02013403          	ld	s0,32(sp)
ffffffe000201074:	01813483          	ld	s1,24(sp)
ffffffe000201078:	03010113          	addi	sp,sp,48
ffffffe00020107c:	00008067          	ret

ffffffe000201080 <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next, uint64_t satp);

void switch_to(struct task_struct *next)
{
ffffffe000201080:	fd010113          	addi	sp,sp,-48
ffffffe000201084:	02113423          	sd	ra,40(sp)
ffffffe000201088:	02813023          	sd	s0,32(sp)
ffffffe00020108c:	03010413          	addi	s0,sp,48
ffffffe000201090:	fca43c23          	sd	a0,-40(s0)
    if (current != next)
ffffffe000201094:	0000c797          	auipc	a5,0xc
ffffffe000201098:	f7c78793          	addi	a5,a5,-132 # ffffffe00020d010 <current>
ffffffe00020109c:	0007b783          	ld	a5,0(a5)
ffffffe0002010a0:	fd843703          	ld	a4,-40(s0)
ffffffe0002010a4:	06f70e63          	beq	a4,a5,ffffffe000201120 <switch_to+0xa0>
    {
        struct task_struct *prev = current;
ffffffe0002010a8:	0000c797          	auipc	a5,0xc
ffffffe0002010ac:	f6878793          	addi	a5,a5,-152 # ffffffe00020d010 <current>
ffffffe0002010b0:	0007b783          	ld	a5,0(a5)
ffffffe0002010b4:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002010b8:	0000c797          	auipc	a5,0xc
ffffffe0002010bc:	f5878793          	addi	a5,a5,-168 # ffffffe00020d010 <current>
ffffffe0002010c0:	fd843703          	ld	a4,-40(s0)
ffffffe0002010c4:	00e7b023          	sd	a4,0(a5)
        printk("from [%d] switch to [%d]\n", prev->pid, next->pid);
ffffffe0002010c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002010cc:	0187b703          	ld	a4,24(a5)
ffffffe0002010d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002010d4:	0187b783          	ld	a5,24(a5)
ffffffe0002010d8:	00078613          	mv	a2,a5
ffffffe0002010dc:	00070593          	mv	a1,a4
ffffffe0002010e0:	00006517          	auipc	a0,0x6
ffffffe0002010e4:	fc850513          	addi	a0,a0,-56 # ffffffe0002070a8 <__func__.4+0xa8>
ffffffe0002010e8:	288030ef          	jal	ra,ffffffe000204370 <printk>
        uint64_t next_satp = get_satp(next->pgd);
ffffffe0002010ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002010f0:	0a87b783          	ld	a5,168(a5)
ffffffe0002010f4:	00078513          	mv	a0,a5
ffffffe0002010f8:	4fd010ef          	jal	ra,ffffffe000202df4 <get_satp>
ffffffe0002010fc:	fea43023          	sd	a0,-32(s0)
        __switch_to(&(prev->thread), &(next->thread), next_satp);
ffffffe000201100:	fe843783          	ld	a5,-24(s0)
ffffffe000201104:	02078713          	addi	a4,a5,32
ffffffe000201108:	fd843783          	ld	a5,-40(s0)
ffffffe00020110c:	02078793          	addi	a5,a5,32
ffffffe000201110:	fe043603          	ld	a2,-32(s0)
ffffffe000201114:	00078593          	mv	a1,a5
ffffffe000201118:	00070513          	mv	a0,a4
ffffffe00020111c:	8dcff0ef          	jal	ra,ffffffe0002001f8 <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
ffffffe000201120:	00000013          	nop
ffffffe000201124:	02813083          	ld	ra,40(sp)
ffffffe000201128:	02013403          	ld	s0,32(sp)
ffffffe00020112c:	03010113          	addi	sp,sp,48
ffffffe000201130:	00008067          	ret

ffffffe000201134 <do_timer>:

void do_timer()
{
ffffffe000201134:	ff010113          	addi	sp,sp,-16
ffffffe000201138:	00113423          	sd	ra,8(sp)
ffffffe00020113c:	00813023          	sd	s0,0(sp)
ffffffe000201140:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0)
ffffffe000201144:	0000c797          	auipc	a5,0xc
ffffffe000201148:	ecc78793          	addi	a5,a5,-308 # ffffffe00020d010 <current>
ffffffe00020114c:	0007b783          	ld	a5,0(a5)
ffffffe000201150:	0187b783          	ld	a5,24(a5)
ffffffe000201154:	00078c63          	beqz	a5,ffffffe00020116c <do_timer+0x38>
ffffffe000201158:	0000c797          	auipc	a5,0xc
ffffffe00020115c:	eb878793          	addi	a5,a5,-328 # ffffffe00020d010 <current>
ffffffe000201160:	0007b783          	ld	a5,0(a5)
ffffffe000201164:	0087b783          	ld	a5,8(a5)
ffffffe000201168:	00079663          	bnez	a5,ffffffe000201174 <do_timer+0x40>
    {
        schedule();
ffffffe00020116c:	050000ef          	jal	ra,ffffffe0002011bc <schedule>
ffffffe000201170:	03c0006f          	j	ffffffe0002011ac <do_timer+0x78>
    }
    else
    {
        --(current->counter);
ffffffe000201174:	0000c797          	auipc	a5,0xc
ffffffe000201178:	e9c78793          	addi	a5,a5,-356 # ffffffe00020d010 <current>
ffffffe00020117c:	0007b783          	ld	a5,0(a5)
ffffffe000201180:	0087b703          	ld	a4,8(a5)
ffffffe000201184:	fff70713          	addi	a4,a4,-1
ffffffe000201188:	00e7b423          	sd	a4,8(a5)
        if (current->counter > 0)
ffffffe00020118c:	0000c797          	auipc	a5,0xc
ffffffe000201190:	e8478793          	addi	a5,a5,-380 # ffffffe00020d010 <current>
ffffffe000201194:	0007b783          	ld	a5,0(a5)
ffffffe000201198:	0087b783          	ld	a5,8(a5)
ffffffe00020119c:	00079663          	bnez	a5,ffffffe0002011a8 <do_timer+0x74>
        {
            return;
        }
        schedule();
ffffffe0002011a0:	01c000ef          	jal	ra,ffffffe0002011bc <schedule>
ffffffe0002011a4:	0080006f          	j	ffffffe0002011ac <do_timer+0x78>
            return;
ffffffe0002011a8:	00000013          	nop
    }
}
ffffffe0002011ac:	00813083          	ld	ra,8(sp)
ffffffe0002011b0:	00013403          	ld	s0,0(sp)
ffffffe0002011b4:	01010113          	addi	sp,sp,16
ffffffe0002011b8:	00008067          	ret

ffffffe0002011bc <schedule>:

void schedule()
{
ffffffe0002011bc:	fd010113          	addi	sp,sp,-48
ffffffe0002011c0:	02113423          	sd	ra,40(sp)
ffffffe0002011c4:	02813023          	sd	s0,32(sp)
ffffffe0002011c8:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe0002011cc:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
ffffffe0002011d0:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < NR_TASKS; i++)
ffffffe0002011d4:	00100793          	li	a5,1
ffffffe0002011d8:	fef42023          	sw	a5,-32(s0)
ffffffe0002011dc:	0ac0006f          	j	ffffffe000201288 <schedule+0xcc>
    {
        if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe0002011e0:	0000c717          	auipc	a4,0xc
ffffffe0002011e4:	e7070713          	addi	a4,a4,-400 # ffffffe00020d050 <task>
ffffffe0002011e8:	fe042783          	lw	a5,-32(s0)
ffffffe0002011ec:	00379793          	slli	a5,a5,0x3
ffffffe0002011f0:	00f707b3          	add	a5,a4,a5
ffffffe0002011f4:	0007b783          	ld	a5,0(a5)
ffffffe0002011f8:	08078263          	beqz	a5,ffffffe00020127c <schedule+0xc0>
ffffffe0002011fc:	0000c717          	auipc	a4,0xc
ffffffe000201200:	e5470713          	addi	a4,a4,-428 # ffffffe00020d050 <task>
ffffffe000201204:	fe042783          	lw	a5,-32(s0)
ffffffe000201208:	00379793          	slli	a5,a5,0x3
ffffffe00020120c:	00f707b3          	add	a5,a4,a5
ffffffe000201210:	0007b783          	ld	a5,0(a5)
ffffffe000201214:	0007b783          	ld	a5,0(a5)
ffffffe000201218:	06079263          	bnez	a5,ffffffe00020127c <schedule+0xc0>
        {
            if (task[i]->counter > max_counter)
ffffffe00020121c:	0000c717          	auipc	a4,0xc
ffffffe000201220:	e3470713          	addi	a4,a4,-460 # ffffffe00020d050 <task>
ffffffe000201224:	fe042783          	lw	a5,-32(s0)
ffffffe000201228:	00379793          	slli	a5,a5,0x3
ffffffe00020122c:	00f707b3          	add	a5,a4,a5
ffffffe000201230:	0007b783          	ld	a5,0(a5)
ffffffe000201234:	0087b703          	ld	a4,8(a5)
ffffffe000201238:	fe442783          	lw	a5,-28(s0)
ffffffe00020123c:	04e7f063          	bgeu	a5,a4,ffffffe00020127c <schedule+0xc0>
            {
                max_counter = task[i]->counter;
ffffffe000201240:	0000c717          	auipc	a4,0xc
ffffffe000201244:	e1070713          	addi	a4,a4,-496 # ffffffe00020d050 <task>
ffffffe000201248:	fe042783          	lw	a5,-32(s0)
ffffffe00020124c:	00379793          	slli	a5,a5,0x3
ffffffe000201250:	00f707b3          	add	a5,a4,a5
ffffffe000201254:	0007b783          	ld	a5,0(a5)
ffffffe000201258:	0087b783          	ld	a5,8(a5)
ffffffe00020125c:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe000201260:	0000c717          	auipc	a4,0xc
ffffffe000201264:	df070713          	addi	a4,a4,-528 # ffffffe00020d050 <task>
ffffffe000201268:	fe042783          	lw	a5,-32(s0)
ffffffe00020126c:	00379793          	slli	a5,a5,0x3
ffffffe000201270:	00f707b3          	add	a5,a4,a5
ffffffe000201274:	0007b783          	ld	a5,0(a5)
ffffffe000201278:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < NR_TASKS; i++)
ffffffe00020127c:	fe042783          	lw	a5,-32(s0)
ffffffe000201280:	0017879b          	addiw	a5,a5,1
ffffffe000201284:	fef42023          	sw	a5,-32(s0)
ffffffe000201288:	fe042783          	lw	a5,-32(s0)
ffffffe00020128c:	0007871b          	sext.w	a4,a5
ffffffe000201290:	00100793          	li	a5,1
ffffffe000201294:	f4e7d6e3          	bge	a5,a4,ffffffe0002011e0 <schedule+0x24>
            }
        }
    }

    if (max_counter == 0)
ffffffe000201298:	fe442783          	lw	a5,-28(s0)
ffffffe00020129c:	0007879b          	sext.w	a5,a5
ffffffe0002012a0:	0a079263          	bnez	a5,ffffffe000201344 <schedule+0x188>
    {
        for (int i = 0; i < NR_TASKS; i++)
ffffffe0002012a4:	fc042e23          	sw	zero,-36(s0)
ffffffe0002012a8:	0840006f          	j	ffffffe00020132c <schedule+0x170>
        {
            if (task[i] && task[i]->state == TASK_RUNNING)
ffffffe0002012ac:	0000c717          	auipc	a4,0xc
ffffffe0002012b0:	da470713          	addi	a4,a4,-604 # ffffffe00020d050 <task>
ffffffe0002012b4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002012b8:	00379793          	slli	a5,a5,0x3
ffffffe0002012bc:	00f707b3          	add	a5,a4,a5
ffffffe0002012c0:	0007b783          	ld	a5,0(a5)
ffffffe0002012c4:	04078e63          	beqz	a5,ffffffe000201320 <schedule+0x164>
ffffffe0002012c8:	0000c717          	auipc	a4,0xc
ffffffe0002012cc:	d8870713          	addi	a4,a4,-632 # ffffffe00020d050 <task>
ffffffe0002012d0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002012d4:	00379793          	slli	a5,a5,0x3
ffffffe0002012d8:	00f707b3          	add	a5,a4,a5
ffffffe0002012dc:	0007b783          	ld	a5,0(a5)
ffffffe0002012e0:	0007b783          	ld	a5,0(a5)
ffffffe0002012e4:	02079e63          	bnez	a5,ffffffe000201320 <schedule+0x164>
            {
                task[i]->counter = task[i]->priority;
ffffffe0002012e8:	0000c717          	auipc	a4,0xc
ffffffe0002012ec:	d6870713          	addi	a4,a4,-664 # ffffffe00020d050 <task>
ffffffe0002012f0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002012f4:	00379793          	slli	a5,a5,0x3
ffffffe0002012f8:	00f707b3          	add	a5,a4,a5
ffffffe0002012fc:	0007b703          	ld	a4,0(a5)
ffffffe000201300:	0000c697          	auipc	a3,0xc
ffffffe000201304:	d5068693          	addi	a3,a3,-688 # ffffffe00020d050 <task>
ffffffe000201308:	fdc42783          	lw	a5,-36(s0)
ffffffe00020130c:	00379793          	slli	a5,a5,0x3
ffffffe000201310:	00f687b3          	add	a5,a3,a5
ffffffe000201314:	0007b783          	ld	a5,0(a5)
ffffffe000201318:	01073703          	ld	a4,16(a4)
ffffffe00020131c:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < NR_TASKS; i++)
ffffffe000201320:	fdc42783          	lw	a5,-36(s0)
ffffffe000201324:	0017879b          	addiw	a5,a5,1
ffffffe000201328:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020132c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201330:	0007871b          	sext.w	a4,a5
ffffffe000201334:	00100793          	li	a5,1
ffffffe000201338:	f6e7dae3          	bge	a5,a4,ffffffe0002012ac <schedule+0xf0>
            }
        }
        schedule();
ffffffe00020133c:	e81ff0ef          	jal	ra,ffffffe0002011bc <schedule>
        return;
ffffffe000201340:	0280006f          	j	ffffffe000201368 <schedule+0x1ac>
    }

    if (next && next != current)
ffffffe000201344:	fe843783          	ld	a5,-24(s0)
ffffffe000201348:	02078063          	beqz	a5,ffffffe000201368 <schedule+0x1ac>
ffffffe00020134c:	0000c797          	auipc	a5,0xc
ffffffe000201350:	cc478793          	addi	a5,a5,-828 # ffffffe00020d010 <current>
ffffffe000201354:	0007b783          	ld	a5,0(a5)
ffffffe000201358:	fe843703          	ld	a4,-24(s0)
ffffffe00020135c:	00f70663          	beq	a4,a5,ffffffe000201368 <schedule+0x1ac>
    {
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
ffffffe000201360:	fe843503          	ld	a0,-24(s0)
ffffffe000201364:	d1dff0ef          	jal	ra,ffffffe000201080 <switch_to>
    }
}
ffffffe000201368:	02813083          	ld	ra,40(sp)
ffffffe00020136c:	02013403          	ld	s0,32(sp)
ffffffe000201370:	03010113          	addi	sp,sp,48
ffffffe000201374:	00008067          	ret

ffffffe000201378 <find_vma>:
* @mm       : current thread's mm_struct
* @addr     : the va to look up
*
* @return   : the VMA if found or NULL if not found
*/
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
ffffffe000201378:	fd010113          	addi	sp,sp,-48
ffffffe00020137c:	02813423          	sd	s0,40(sp)
ffffffe000201380:	03010413          	addi	s0,sp,48
ffffffe000201384:	fca43c23          	sd	a0,-40(s0)
ffffffe000201388:	fcb43823          	sd	a1,-48(s0)
    struct vm_area_struct *vma = mm->mmap;
ffffffe00020138c:	fd843783          	ld	a5,-40(s0)
ffffffe000201390:	0007b783          	ld	a5,0(a5)
ffffffe000201394:	fef43423          	sd	a5,-24(s0)
    while(vma){
ffffffe000201398:	0380006f          	j	ffffffe0002013d0 <find_vma+0x58>
        if(addr >= vma->vm_start && addr < vma->vm_end){
ffffffe00020139c:	fe843783          	ld	a5,-24(s0)
ffffffe0002013a0:	0087b783          	ld	a5,8(a5)
ffffffe0002013a4:	fd043703          	ld	a4,-48(s0)
ffffffe0002013a8:	00f76e63          	bltu	a4,a5,ffffffe0002013c4 <find_vma+0x4c>
ffffffe0002013ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002013b0:	0107b783          	ld	a5,16(a5)
ffffffe0002013b4:	fd043703          	ld	a4,-48(s0)
ffffffe0002013b8:	00f77663          	bgeu	a4,a5,ffffffe0002013c4 <find_vma+0x4c>
            return vma;
ffffffe0002013bc:	fe843783          	ld	a5,-24(s0)
ffffffe0002013c0:	01c0006f          	j	ffffffe0002013dc <find_vma+0x64>
        }
        vma = vma->vm_next;
ffffffe0002013c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002013c8:	0187b783          	ld	a5,24(a5)
ffffffe0002013cc:	fef43423          	sd	a5,-24(s0)
    while(vma){
ffffffe0002013d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002013d4:	fc0794e3          	bnez	a5,ffffffe00020139c <find_vma+0x24>
    }
    return NULL;
ffffffe0002013d8:	00000793          	li	a5,0
}
ffffffe0002013dc:	00078513          	mv	a0,a5
ffffffe0002013e0:	02813403          	ld	s0,40(sp)
ffffffe0002013e4:	03010113          	addi	sp,sp,48
ffffffe0002013e8:	00008067          	ret

ffffffe0002013ec <do_mmap>:
* @vm_filesz: phdr->p_filesz
* @flags    : flags for the new VMA
*
* @return   : start va
*/
uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
ffffffe0002013ec:	f9010113          	addi	sp,sp,-112
ffffffe0002013f0:	06113423          	sd	ra,104(sp)
ffffffe0002013f4:	06813023          	sd	s0,96(sp)
ffffffe0002013f8:	07010413          	addi	s0,sp,112
ffffffe0002013fc:	faa43c23          	sd	a0,-72(s0)
ffffffe000201400:	fab43823          	sd	a1,-80(s0)
ffffffe000201404:	fac43423          	sd	a2,-88(s0)
ffffffe000201408:	fad43023          	sd	a3,-96(s0)
ffffffe00020140c:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201410:	f8f43823          	sd	a5,-112(s0)
    uint64_t start = addr;
ffffffe000201414:	fb043783          	ld	a5,-80(s0)
ffffffe000201418:	fcf43c23          	sd	a5,-40(s0)
    uint64_t end = addr + len;
ffffffe00020141c:	fb043703          	ld	a4,-80(s0)
ffffffe000201420:	fa843783          	ld	a5,-88(s0)
ffffffe000201424:	00f707b3          	add	a5,a4,a5
ffffffe000201428:	fcf43823          	sd	a5,-48(s0)
    struct vm_area_struct *vma = mm->mmap;
ffffffe00020142c:	fb843783          	ld	a5,-72(s0)
ffffffe000201430:	0007b783          	ld	a5,0(a5)
ffffffe000201434:	fef43423          	sd	a5,-24(s0)
    struct vm_area_struct *prev = NULL;
ffffffe000201438:	fe043023          	sd	zero,-32(s0)
    while(vma){
ffffffe00020143c:	0280006f          	j	ffffffe000201464 <do_mmap+0x78>
        if(end <= vma->vm_start){
ffffffe000201440:	fe843783          	ld	a5,-24(s0)
ffffffe000201444:	0087b783          	ld	a5,8(a5)
ffffffe000201448:	fd043703          	ld	a4,-48(s0)
ffffffe00020144c:	02e7f263          	bgeu	a5,a4,ffffffe000201470 <do_mmap+0x84>
            break;
        }
        prev = vma;
ffffffe000201450:	fe843783          	ld	a5,-24(s0)
ffffffe000201454:	fef43023          	sd	a5,-32(s0)
        vma = vma->vm_next;
ffffffe000201458:	fe843783          	ld	a5,-24(s0)
ffffffe00020145c:	0187b783          	ld	a5,24(a5)
ffffffe000201460:	fef43423          	sd	a5,-24(s0)
    while(vma){
ffffffe000201464:	fe843783          	ld	a5,-24(s0)
ffffffe000201468:	fc079ce3          	bnez	a5,ffffffe000201440 <do_mmap+0x54>
ffffffe00020146c:	0080006f          	j	ffffffe000201474 <do_mmap+0x88>
            break;
ffffffe000201470:	00000013          	nop
    }
    struct vm_area_struct *new_vma = (struct vm_area_struct *)kalloc();
ffffffe000201474:	d60ff0ef          	jal	ra,ffffffe0002009d4 <kalloc>
ffffffe000201478:	fca43423          	sd	a0,-56(s0)
    new_vma->vm_mm = mm;
ffffffe00020147c:	fc843783          	ld	a5,-56(s0)
ffffffe000201480:	fb843703          	ld	a4,-72(s0)
ffffffe000201484:	00e7b023          	sd	a4,0(a5)
    new_vma->vm_start = start;
ffffffe000201488:	fc843783          	ld	a5,-56(s0)
ffffffe00020148c:	fd843703          	ld	a4,-40(s0)
ffffffe000201490:	00e7b423          	sd	a4,8(a5)
    new_vma->vm_end = end;
ffffffe000201494:	fc843783          	ld	a5,-56(s0)
ffffffe000201498:	fd043703          	ld	a4,-48(s0)
ffffffe00020149c:	00e7b823          	sd	a4,16(a5)
    new_vma->vm_flags = flags;
ffffffe0002014a0:	fc843783          	ld	a5,-56(s0)
ffffffe0002014a4:	f9043703          	ld	a4,-112(s0)
ffffffe0002014a8:	02e7b423          	sd	a4,40(a5)
    new_vma->vm_pgoff = vm_pgoff;
ffffffe0002014ac:	fc843783          	ld	a5,-56(s0)
ffffffe0002014b0:	fa043703          	ld	a4,-96(s0)
ffffffe0002014b4:	02e7b823          	sd	a4,48(a5)
    new_vma->vm_filesz = vm_filesz;
ffffffe0002014b8:	fc843783          	ld	a5,-56(s0)
ffffffe0002014bc:	f9843703          	ld	a4,-104(s0)
ffffffe0002014c0:	02e7bc23          	sd	a4,56(a5)
    if(prev){
ffffffe0002014c4:	fe043783          	ld	a5,-32(s0)
ffffffe0002014c8:	02078063          	beqz	a5,ffffffe0002014e8 <do_mmap+0xfc>
        prev->vm_next = new_vma;
ffffffe0002014cc:	fe043783          	ld	a5,-32(s0)
ffffffe0002014d0:	fc843703          	ld	a4,-56(s0)
ffffffe0002014d4:	00e7bc23          	sd	a4,24(a5)
        new_vma->vm_prev = prev;
ffffffe0002014d8:	fc843783          	ld	a5,-56(s0)
ffffffe0002014dc:	fe043703          	ld	a4,-32(s0)
ffffffe0002014e0:	02e7b023          	sd	a4,32(a5)
ffffffe0002014e4:	0100006f          	j	ffffffe0002014f4 <do_mmap+0x108>
    }else{
        mm->mmap = new_vma;
ffffffe0002014e8:	fb843783          	ld	a5,-72(s0)
ffffffe0002014ec:	fc843703          	ld	a4,-56(s0)
ffffffe0002014f0:	00e7b023          	sd	a4,0(a5)
    }
    new_vma->vm_next = vma;
ffffffe0002014f4:	fc843783          	ld	a5,-56(s0)
ffffffe0002014f8:	fe843703          	ld	a4,-24(s0)
ffffffe0002014fc:	00e7bc23          	sd	a4,24(a5)
    if(vma){
ffffffe000201500:	fe843783          	ld	a5,-24(s0)
ffffffe000201504:	00078863          	beqz	a5,ffffffe000201514 <do_mmap+0x128>
        vma->vm_prev = new_vma;
ffffffe000201508:	fe843783          	ld	a5,-24(s0)
ffffffe00020150c:	fc843703          	ld	a4,-56(s0)
ffffffe000201510:	02e7b023          	sd	a4,32(a5)
    }
    return start;
ffffffe000201514:	fd843783          	ld	a5,-40(s0)
}
ffffffe000201518:	00078513          	mv	a0,a5
ffffffe00020151c:	06813083          	ld	ra,104(sp)
ffffffe000201520:	06013403          	ld	s0,96(sp)
ffffffe000201524:	07010113          	addi	sp,sp,112
ffffffe000201528:	00008067          	ret

ffffffe00020152c <add_task>:

int add_task(struct task_struct *T)
{
ffffffe00020152c:	fe010113          	addi	sp,sp,-32
ffffffe000201530:	00813c23          	sd	s0,24(sp)
ffffffe000201534:	02010413          	addi	s0,sp,32
ffffffe000201538:	fea43423          	sd	a0,-24(s0)
    if (nr_tasks >= NR_TASKS)
ffffffe00020153c:	0000c797          	auipc	a5,0xc
ffffffe000201540:	adc78793          	addi	a5,a5,-1316 # ffffffe00020d018 <nr_tasks>
ffffffe000201544:	0007a783          	lw	a5,0(a5)
ffffffe000201548:	00078713          	mv	a4,a5
ffffffe00020154c:	00100793          	li	a5,1
ffffffe000201550:	00e7d663          	bge	a5,a4,ffffffe00020155c <add_task+0x30>
    {
        return -1;
ffffffe000201554:	fff00793          	li	a5,-1
ffffffe000201558:	0500006f          	j	ffffffe0002015a8 <add_task+0x7c>
    }
    task[nr_tasks++] = T;
ffffffe00020155c:	0000c797          	auipc	a5,0xc
ffffffe000201560:	abc78793          	addi	a5,a5,-1348 # ffffffe00020d018 <nr_tasks>
ffffffe000201564:	0007a783          	lw	a5,0(a5)
ffffffe000201568:	0017871b          	addiw	a4,a5,1
ffffffe00020156c:	0007069b          	sext.w	a3,a4
ffffffe000201570:	0000c717          	auipc	a4,0xc
ffffffe000201574:	aa870713          	addi	a4,a4,-1368 # ffffffe00020d018 <nr_tasks>
ffffffe000201578:	00d72023          	sw	a3,0(a4)
ffffffe00020157c:	0000c717          	auipc	a4,0xc
ffffffe000201580:	ad470713          	addi	a4,a4,-1324 # ffffffe00020d050 <task>
ffffffe000201584:	00379793          	slli	a5,a5,0x3
ffffffe000201588:	00f707b3          	add	a5,a4,a5
ffffffe00020158c:	fe843703          	ld	a4,-24(s0)
ffffffe000201590:	00e7b023          	sd	a4,0(a5)
    return nr_tasks - 1;
ffffffe000201594:	0000c797          	auipc	a5,0xc
ffffffe000201598:	a8478793          	addi	a5,a5,-1404 # ffffffe00020d018 <nr_tasks>
ffffffe00020159c:	0007a783          	lw	a5,0(a5)
ffffffe0002015a0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002015a4:	0007879b          	sext.w	a5,a5
}
ffffffe0002015a8:	00078513          	mv	a0,a5
ffffffe0002015ac:	01813403          	ld	s0,24(sp)
ffffffe0002015b0:	02010113          	addi	sp,sp,32
ffffffe0002015b4:	00008067          	ret

ffffffe0002015b8 <dummy>:
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy()
{
ffffffe0002015b8:	fd010113          	addi	sp,sp,-48
ffffffe0002015bc:	02113423          	sd	ra,40(sp)
ffffffe0002015c0:	02813023          	sd	s0,32(sp)
ffffffe0002015c4:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe0002015c8:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe0002015cc:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe0002015d0:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe0002015d4:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe0002015d8:	fff00793          	li	a5,-1
ffffffe0002015dc:	fef42223          	sw	a5,-28(s0)
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe0002015e0:	fe442783          	lw	a5,-28(s0)
ffffffe0002015e4:	0007871b          	sext.w	a4,a5
ffffffe0002015e8:	fff00793          	li	a5,-1
ffffffe0002015ec:	00f70e63          	beq	a4,a5,ffffffe000201608 <dummy+0x50>
ffffffe0002015f0:	0000c797          	auipc	a5,0xc
ffffffe0002015f4:	a2078793          	addi	a5,a5,-1504 # ffffffe00020d010 <current>
ffffffe0002015f8:	0007b783          	ld	a5,0(a5)
ffffffe0002015fc:	0087b703          	ld	a4,8(a5)
ffffffe000201600:	fe442783          	lw	a5,-28(s0)
ffffffe000201604:	fcf70ee3          	beq	a4,a5,ffffffe0002015e0 <dummy+0x28>
ffffffe000201608:	0000c797          	auipc	a5,0xc
ffffffe00020160c:	a0878793          	addi	a5,a5,-1528 # ffffffe00020d010 <current>
ffffffe000201610:	0007b783          	ld	a5,0(a5)
ffffffe000201614:	0087b783          	ld	a5,8(a5)
ffffffe000201618:	fc0784e3          	beqz	a5,ffffffe0002015e0 <dummy+0x28>
        {
            if (current->counter == 1)
ffffffe00020161c:	0000c797          	auipc	a5,0xc
ffffffe000201620:	9f478793          	addi	a5,a5,-1548 # ffffffe00020d010 <current>
ffffffe000201624:	0007b783          	ld	a5,0(a5)
ffffffe000201628:	0087b703          	ld	a4,8(a5)
ffffffe00020162c:	00100793          	li	a5,1
ffffffe000201630:	00f71e63          	bne	a4,a5,ffffffe00020164c <dummy+0x94>
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
ffffffe000201634:	0000c797          	auipc	a5,0xc
ffffffe000201638:	9dc78793          	addi	a5,a5,-1572 # ffffffe00020d010 <current>
ffffffe00020163c:	0007b783          	ld	a5,0(a5)
ffffffe000201640:	0087b703          	ld	a4,8(a5)
ffffffe000201644:	fff70713          	addi	a4,a4,-1
ffffffe000201648:	00e7b423          	sd	a4,8(a5)
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe00020164c:	0000c797          	auipc	a5,0xc
ffffffe000201650:	9c478793          	addi	a5,a5,-1596 # ffffffe00020d010 <current>
ffffffe000201654:	0007b783          	ld	a5,0(a5)
ffffffe000201658:	0087b783          	ld	a5,8(a5)
ffffffe00020165c:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000201660:	fe843783          	ld	a5,-24(s0)
ffffffe000201664:	00178713          	addi	a4,a5,1
ffffffe000201668:	fd843783          	ld	a5,-40(s0)
ffffffe00020166c:	02f777b3          	remu	a5,a4,a5
ffffffe000201670:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe000201674:	0000c797          	auipc	a5,0xc
ffffffe000201678:	99c78793          	addi	a5,a5,-1636 # ffffffe00020d010 <current>
ffffffe00020167c:	0007b783          	ld	a5,0(a5)
ffffffe000201680:	0187b783          	ld	a5,24(a5)
ffffffe000201684:	fe843603          	ld	a2,-24(s0)
ffffffe000201688:	00078593          	mv	a1,a5
ffffffe00020168c:	00006517          	auipc	a0,0x6
ffffffe000201690:	a3c50513          	addi	a0,a0,-1476 # ffffffe0002070c8 <__func__.4+0xc8>
ffffffe000201694:	4dd020ef          	jal	ra,ffffffe000204370 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201698:	f49ff06f          	j	ffffffe0002015e0 <dummy+0x28>

ffffffe00020169c <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe00020169c:	f8010113          	addi	sp,sp,-128
ffffffe0002016a0:	06813c23          	sd	s0,120(sp)
ffffffe0002016a4:	06913823          	sd	s1,112(sp)
ffffffe0002016a8:	07213423          	sd	s2,104(sp)
ffffffe0002016ac:	07313023          	sd	s3,96(sp)
ffffffe0002016b0:	08010413          	addi	s0,sp,128
ffffffe0002016b4:	faa43c23          	sd	a0,-72(s0)
ffffffe0002016b8:	fab43823          	sd	a1,-80(s0)
ffffffe0002016bc:	fac43423          	sd	a2,-88(s0)
ffffffe0002016c0:	fad43023          	sd	a3,-96(s0)
ffffffe0002016c4:	f8e43c23          	sd	a4,-104(s0)
ffffffe0002016c8:	f8f43823          	sd	a5,-112(s0)
ffffffe0002016cc:	f9043423          	sd	a6,-120(s0)
ffffffe0002016d0:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe0002016d4:	fb843e03          	ld	t3,-72(s0)
ffffffe0002016d8:	fb043e83          	ld	t4,-80(s0)
ffffffe0002016dc:	fa843f03          	ld	t5,-88(s0)
ffffffe0002016e0:	fa043f83          	ld	t6,-96(s0)
ffffffe0002016e4:	f9843283          	ld	t0,-104(s0)
ffffffe0002016e8:	f9043483          	ld	s1,-112(s0)
ffffffe0002016ec:	f8843903          	ld	s2,-120(s0)
ffffffe0002016f0:	f8043983          	ld	s3,-128(s0)
ffffffe0002016f4:	000e0893          	mv	a7,t3
ffffffe0002016f8:	000e8813          	mv	a6,t4
ffffffe0002016fc:	000f0513          	mv	a0,t5
ffffffe000201700:	000f8593          	mv	a1,t6
ffffffe000201704:	00028613          	mv	a2,t0
ffffffe000201708:	00048693          	mv	a3,s1
ffffffe00020170c:	00090713          	mv	a4,s2
ffffffe000201710:	00098793          	mv	a5,s3
ffffffe000201714:	00000073          	ecall
ffffffe000201718:	00050e93          	mv	t4,a0
ffffffe00020171c:	00058e13          	mv	t3,a1
ffffffe000201720:	fdd43023          	sd	t4,-64(s0)
ffffffe000201724:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe000201728:	fc043783          	ld	a5,-64(s0)
ffffffe00020172c:	fcf43823          	sd	a5,-48(s0)
ffffffe000201730:	fc843783          	ld	a5,-56(s0)
ffffffe000201734:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201738:	fd043703          	ld	a4,-48(s0)
ffffffe00020173c:	fd843783          	ld	a5,-40(s0)
ffffffe000201740:	00070313          	mv	t1,a4
ffffffe000201744:	00078393          	mv	t2,a5
ffffffe000201748:	00030713          	mv	a4,t1
ffffffe00020174c:	00038793          	mv	a5,t2
}
ffffffe000201750:	00070513          	mv	a0,a4
ffffffe000201754:	00078593          	mv	a1,a5
ffffffe000201758:	07813403          	ld	s0,120(sp)
ffffffe00020175c:	07013483          	ld	s1,112(sp)
ffffffe000201760:	06813903          	ld	s2,104(sp)
ffffffe000201764:	06013983          	ld	s3,96(sp)
ffffffe000201768:	08010113          	addi	sp,sp,128
ffffffe00020176c:	00008067          	ret

ffffffe000201770 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000201770:	fd010113          	addi	sp,sp,-48
ffffffe000201774:	02813423          	sd	s0,40(sp)
ffffffe000201778:	03010413          	addi	s0,sp,48
ffffffe00020177c:	00050793          	mv	a5,a0
ffffffe000201780:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000201784:	444247b7          	lui	a5,0x44424
ffffffe000201788:	34e7879b          	addiw	a5,a5,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe00020178c:	00200713          	li	a4,2
ffffffe000201790:	fdf44683          	lbu	a3,-33(s0)
ffffffe000201794:	00078893          	mv	a7,a5
ffffffe000201798:	00070813          	mv	a6,a4
ffffffe00020179c:	00068513          	mv	a0,a3
ffffffe0002017a0:	00000073          	ecall
ffffffe0002017a4:	00050713          	mv	a4,a0
ffffffe0002017a8:	00058793          	mv	a5,a1
ffffffe0002017ac:	fee43023          	sd	a4,-32(s0)
ffffffe0002017b0:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x4442434e), [fid] "r"(0x2), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe0002017b4:	00000013          	nop
ffffffe0002017b8:	00070513          	mv	a0,a4
ffffffe0002017bc:	00078593          	mv	a1,a5
ffffffe0002017c0:	02813403          	ld	s0,40(sp)
ffffffe0002017c4:	03010113          	addi	sp,sp,48
ffffffe0002017c8:	00008067          	ret

ffffffe0002017cc <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe0002017cc:	fc010113          	addi	sp,sp,-64
ffffffe0002017d0:	02813c23          	sd	s0,56(sp)
ffffffe0002017d4:	04010413          	addi	s0,sp,64
ffffffe0002017d8:	00050793          	mv	a5,a0
ffffffe0002017dc:	00058713          	mv	a4,a1
ffffffe0002017e0:	fcf42623          	sw	a5,-52(s0)
ffffffe0002017e4:	00070793          	mv	a5,a4
ffffffe0002017e8:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe0002017ec:	00800793          	li	a5,8
ffffffe0002017f0:	00000713          	li	a4,0
ffffffe0002017f4:	fcc42583          	lw	a1,-52(s0)
ffffffe0002017f8:	00058313          	mv	t1,a1
ffffffe0002017fc:	fc842583          	lw	a1,-56(s0)
ffffffe000201800:	00058e13          	mv	t3,a1
ffffffe000201804:	00078893          	mv	a7,a5
ffffffe000201808:	00070813          	mv	a6,a4
ffffffe00020180c:	00030513          	mv	a0,t1
ffffffe000201810:	000e0593          	mv	a1,t3
ffffffe000201814:	00000073          	ecall
ffffffe000201818:	00050713          	mv	a4,a0
ffffffe00020181c:	00058793          	mv	a5,a1
ffffffe000201820:	fce43823          	sd	a4,-48(s0)
ffffffe000201824:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe000201828:	fd043783          	ld	a5,-48(s0)
ffffffe00020182c:	fef43023          	sd	a5,-32(s0)
ffffffe000201830:	fd843783          	ld	a5,-40(s0)
ffffffe000201834:	fef43423          	sd	a5,-24(s0)
ffffffe000201838:	fe043703          	ld	a4,-32(s0)
ffffffe00020183c:	fe843783          	ld	a5,-24(s0)
ffffffe000201840:	00070613          	mv	a2,a4
ffffffe000201844:	00078693          	mv	a3,a5
ffffffe000201848:	00060713          	mv	a4,a2
ffffffe00020184c:	00068793          	mv	a5,a3
}
ffffffe000201850:	00070513          	mv	a0,a4
ffffffe000201854:	00078593          	mv	a1,a5
ffffffe000201858:	03813403          	ld	s0,56(sp)
ffffffe00020185c:	04010113          	addi	sp,sp,64
ffffffe000201860:	00008067          	ret

ffffffe000201864 <sbi_debug_console_read>:

struct sbiret sbi_debug_console_read(uint64_t num_bytes, uint64_t base_addr_lo, uint64_t base_addr_hi){
ffffffe000201864:	fb010113          	addi	sp,sp,-80
ffffffe000201868:	04813423          	sd	s0,72(sp)
ffffffe00020186c:	05010413          	addi	s0,sp,80
ffffffe000201870:	fca43423          	sd	a0,-56(s0)
ffffffe000201874:	fcb43023          	sd	a1,-64(s0)
ffffffe000201878:	fac43c23          	sd	a2,-72(s0)
    struct sbiret ret;
    asm volatile(
ffffffe00020187c:	444247b7          	lui	a5,0x44424
ffffffe000201880:	34e7879b          	addiw	a5,a5,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe000201884:	00100713          	li	a4,1
ffffffe000201888:	fc843683          	ld	a3,-56(s0)
ffffffe00020188c:	fc043e03          	ld	t3,-64(s0)
ffffffe000201890:	fb843e83          	ld	t4,-72(s0)
ffffffe000201894:	00078893          	mv	a7,a5
ffffffe000201898:	00070813          	mv	a6,a4
ffffffe00020189c:	00068513          	mv	a0,a3
ffffffe0002018a0:	000e0593          	mv	a1,t3
ffffffe0002018a4:	000e8613          	mv	a2,t4
ffffffe0002018a8:	00000073          	ecall
ffffffe0002018ac:	00050713          	mv	a4,a0
ffffffe0002018b0:	00058793          	mv	a5,a1
ffffffe0002018b4:	fce43823          	sd	a4,-48(s0)
ffffffe0002018b8:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x4442434e), [fid] "r"(0x1), [num_bytes] "r"(num_bytes), [base_addr_lo] "r"(base_addr_lo), [base_addr_hi] "r"(base_addr_hi)
        : "memory", "a0", "a1", "a2", "a6", "a7"
    );
    return ret;
ffffffe0002018bc:	fd043783          	ld	a5,-48(s0)
ffffffe0002018c0:	fef43023          	sd	a5,-32(s0)
ffffffe0002018c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002018c8:	fef43423          	sd	a5,-24(s0)
ffffffe0002018cc:	fe043703          	ld	a4,-32(s0)
ffffffe0002018d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002018d4:	00070313          	mv	t1,a4
ffffffe0002018d8:	00078393          	mv	t2,a5
ffffffe0002018dc:	00030713          	mv	a4,t1
ffffffe0002018e0:	00038793          	mv	a5,t2
ffffffe0002018e4:	00070513          	mv	a0,a4
ffffffe0002018e8:	00078593          	mv	a1,a5
ffffffe0002018ec:	04813403          	ld	s0,72(sp)
ffffffe0002018f0:	05010113          	addi	sp,sp,80
ffffffe0002018f4:	00008067          	ret

ffffffe0002018f8 <sys_write>:
//         return cnt;
//     }
//     return -1;
// }

int64_t sys_write(uint64_t fd, const char *buf, uint64_t len) {
ffffffe0002018f8:	fb010113          	addi	sp,sp,-80
ffffffe0002018fc:	04113423          	sd	ra,72(sp)
ffffffe000201900:	04813023          	sd	s0,64(sp)
ffffffe000201904:	05010413          	addi	s0,sp,80
ffffffe000201908:	fca43423          	sd	a0,-56(s0)
ffffffe00020190c:	fcb43023          	sd	a1,-64(s0)
ffffffe000201910:	fac43c23          	sd	a2,-72(s0)
    int64_t ret;
    struct task_struct *current = get_current_proc();
ffffffe000201914:	9f4ff0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000201918:	fea43423          	sd	a0,-24(s0)
    struct file *file = &(current->files->fd_array[fd]);
ffffffe00020191c:	fe843783          	ld	a5,-24(s0)
ffffffe000201920:	0b87b683          	ld	a3,184(a5)
ffffffe000201924:	fc843703          	ld	a4,-56(s0)
ffffffe000201928:	00070793          	mv	a5,a4
ffffffe00020192c:	00479793          	slli	a5,a5,0x4
ffffffe000201930:	00e787b3          	add	a5,a5,a4
ffffffe000201934:	00379793          	slli	a5,a5,0x3
ffffffe000201938:	00f687b3          	add	a5,a3,a5
ffffffe00020193c:	fef43023          	sd	a5,-32(s0)
    if (file->opened == 0) {
ffffffe000201940:	fe043783          	ld	a5,-32(s0)
ffffffe000201944:	0007a783          	lw	a5,0(a5)
ffffffe000201948:	00079c63          	bnez	a5,ffffffe000201960 <sys_write+0x68>
        printk("file not opened\n");
ffffffe00020194c:	00005517          	auipc	a0,0x5
ffffffe000201950:	7ac50513          	addi	a0,a0,1964 # ffffffe0002070f8 <__func__.4+0xf8>
ffffffe000201954:	21d020ef          	jal	ra,ffffffe000204370 <printk>
        return ERROR_FILE_NOT_OPEN;
ffffffe000201958:	0ff00793          	li	a5,255
ffffffe00020195c:	0b80006f          	j	ffffffe000201a14 <sys_write+0x11c>
    } else {
        // check perms and call write function of file
        if((file->perms & FILE_WRITABLE)==0){
ffffffe000201960:	fe043783          	ld	a5,-32(s0)
ffffffe000201964:	0047a783          	lw	a5,4(a5)
ffffffe000201968:	0027f793          	andi	a5,a5,2
ffffffe00020196c:	0007879b          	sext.w	a5,a5
ffffffe000201970:	02079463          	bnez	a5,ffffffe000201998 <sys_write+0xa0>
            Err("file not writable");
ffffffe000201974:	00006697          	auipc	a3,0x6
ffffffe000201978:	a2468693          	addi	a3,a3,-1500 # ffffffe000207398 <__func__.5>
ffffffe00020197c:	02200613          	li	a2,34
ffffffe000201980:	00005597          	auipc	a1,0x5
ffffffe000201984:	79058593          	addi	a1,a1,1936 # ffffffe000207110 <__func__.4+0x110>
ffffffe000201988:	00005517          	auipc	a0,0x5
ffffffe00020198c:	79850513          	addi	a0,a0,1944 # ffffffe000207120 <__func__.4+0x120>
ffffffe000201990:	1e1020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000201994:	0000006f          	j	ffffffe000201994 <sys_write+0x9c>
            return ERROR_FILE_NOT_WRITABLE;
        }
        // 检查写函数是否定义
        if(file->write==NULL){
ffffffe000201998:	fe043783          	ld	a5,-32(s0)
ffffffe00020199c:	0287b783          	ld	a5,40(a5)
ffffffe0002019a0:	02079463          	bnez	a5,ffffffe0002019c8 <sys_write+0xd0>
            Err("file not support write function");
ffffffe0002019a4:	00006697          	auipc	a3,0x6
ffffffe0002019a8:	9f468693          	addi	a3,a3,-1548 # ffffffe000207398 <__func__.5>
ffffffe0002019ac:	02700613          	li	a2,39
ffffffe0002019b0:	00005597          	auipc	a1,0x5
ffffffe0002019b4:	76058593          	addi	a1,a1,1888 # ffffffe000207110 <__func__.4+0x110>
ffffffe0002019b8:	00005517          	auipc	a0,0x5
ffffffe0002019bc:	79850513          	addi	a0,a0,1944 # ffffffe000207150 <__func__.4+0x150>
ffffffe0002019c0:	1b1020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002019c4:	0000006f          	j	ffffffe0002019c4 <sys_write+0xcc>
            return ERROR_NO_WRITE_FUNCTION;
        }
        // 允许写入
        ret = file->write(file, buf, len);
ffffffe0002019c8:	fe043783          	ld	a5,-32(s0)
ffffffe0002019cc:	0287b783          	ld	a5,40(a5)
ffffffe0002019d0:	fb843603          	ld	a2,-72(s0)
ffffffe0002019d4:	fc043583          	ld	a1,-64(s0)
ffffffe0002019d8:	fe043503          	ld	a0,-32(s0)
ffffffe0002019dc:	000780e7          	jalr	a5
ffffffe0002019e0:	fca43c23          	sd	a0,-40(s0)
        if(ret<0){
ffffffe0002019e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002019e8:	0207d463          	bgez	a5,ffffffe000201a10 <sys_write+0x118>
            Err("file write error\n");
ffffffe0002019ec:	00006697          	auipc	a3,0x6
ffffffe0002019f0:	9ac68693          	addi	a3,a3,-1620 # ffffffe000207398 <__func__.5>
ffffffe0002019f4:	02d00613          	li	a2,45
ffffffe0002019f8:	00005597          	auipc	a1,0x5
ffffffe0002019fc:	71858593          	addi	a1,a1,1816 # ffffffe000207110 <__func__.4+0x110>
ffffffe000201a00:	00005517          	auipc	a0,0x5
ffffffe000201a04:	78850513          	addi	a0,a0,1928 # ffffffe000207188 <__func__.4+0x188>
ffffffe000201a08:	169020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000201a0c:	0000006f          	j	ffffffe000201a0c <sys_write+0x114>
        }
    }
    return ret;
ffffffe000201a10:	fd843783          	ld	a5,-40(s0)
}
ffffffe000201a14:	00078513          	mv	a0,a5
ffffffe000201a18:	04813083          	ld	ra,72(sp)
ffffffe000201a1c:	04013403          	ld	s0,64(sp)
ffffffe000201a20:	05010113          	addi	sp,sp,80
ffffffe000201a24:	00008067          	ret

ffffffe000201a28 <sys_getpid>:

int sys_getpid()
{
ffffffe000201a28:	fe010113          	addi	sp,sp,-32
ffffffe000201a2c:	00113c23          	sd	ra,24(sp)
ffffffe000201a30:	00813823          	sd	s0,16(sp)
ffffffe000201a34:	02010413          	addi	s0,sp,32
    struct task_struct *current = get_current_proc();
ffffffe000201a38:	8d0ff0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000201a3c:	fea43423          	sd	a0,-24(s0)
    return current->pid;
ffffffe000201a40:	fe843783          	ld	a5,-24(s0)
ffffffe000201a44:	0187b783          	ld	a5,24(a5)
ffffffe000201a48:	0007879b          	sext.w	a5,a5
}
ffffffe000201a4c:	00078513          	mv	a0,a5
ffffffe000201a50:	01813083          	ld	ra,24(sp)
ffffffe000201a54:	01013403          	ld	s0,16(sp)
ffffffe000201a58:	02010113          	addi	sp,sp,32
ffffffe000201a5c:	00008067          	ret

ffffffe000201a60 <do_fork>:

uint64_t do_fork(struct pt_regs *regs)
{
ffffffe000201a60:	fb010113          	addi	sp,sp,-80
ffffffe000201a64:	04113423          	sd	ra,72(sp)
ffffffe000201a68:	04813023          	sd	s0,64(sp)
ffffffe000201a6c:	02913c23          	sd	s1,56(sp)
ffffffe000201a70:	05010413          	addi	s0,sp,80
ffffffe000201a74:	faa43c23          	sd	a0,-72(s0)
    struct task_struct *child_task = (struct task_struct *)kalloc();
ffffffe000201a78:	f5dfe0ef          	jal	ra,ffffffe0002009d4 <kalloc>
ffffffe000201a7c:	fca43c23          	sd	a0,-40(s0)
    if (get_nr_tasks() >= NR_TASKS || !child_task)
ffffffe000201a80:	860ff0ef          	jal	ra,ffffffe000200ae0 <get_nr_tasks>
ffffffe000201a84:	00050793          	mv	a5,a0
ffffffe000201a88:	00078713          	mv	a4,a5
ffffffe000201a8c:	00100793          	li	a5,1
ffffffe000201a90:	00e7c663          	blt	a5,a4,ffffffe000201a9c <do_fork+0x3c>
ffffffe000201a94:	fd843783          	ld	a5,-40(s0)
ffffffe000201a98:	02079463          	bnez	a5,ffffffe000201ac0 <do_fork+0x60>
    {
        Err("do_fork: failed to fork\n");
ffffffe000201a9c:	00005697          	auipc	a3,0x5
ffffffe000201aa0:	56468693          	addi	a3,a3,1380 # ffffffe000207000 <__func__.4>
ffffffe000201aa4:	03e00613          	li	a2,62
ffffffe000201aa8:	00005597          	auipc	a1,0x5
ffffffe000201aac:	66858593          	addi	a1,a1,1640 # ffffffe000207110 <__func__.4+0x110>
ffffffe000201ab0:	00005517          	auipc	a0,0x5
ffffffe000201ab4:	70850513          	addi	a0,a0,1800 # ffffffe0002071b8 <__func__.4+0x1b8>
ffffffe000201ab8:	0b9020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000201abc:	0000006f          	j	ffffffe000201abc <do_fork+0x5c>
    }
    memcpy(child_task, get_current_proc(), PGSIZE);
ffffffe000201ac0:	848ff0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000201ac4:	00050793          	mv	a5,a0
ffffffe000201ac8:	00001637          	lui	a2,0x1
ffffffe000201acc:	00078593          	mv	a1,a5
ffffffe000201ad0:	fd843503          	ld	a0,-40(s0)
ffffffe000201ad4:	22d020ef          	jal	ra,ffffffe000204500 <memcpy>
    child_task->pid = get_nr_tasks();
ffffffe000201ad8:	808ff0ef          	jal	ra,ffffffe000200ae0 <get_nr_tasks>
ffffffe000201adc:	00050793          	mv	a5,a0
ffffffe000201ae0:	00078713          	mv	a4,a5
ffffffe000201ae4:	fd843783          	ld	a5,-40(s0)
ffffffe000201ae8:	00e7bc23          	sd	a4,24(a5)
    child_task->state = TASK_RUNNING;
ffffffe000201aec:	fd843783          	ld	a5,-40(s0)
ffffffe000201af0:	0007b023          	sd	zero,0(a5)
    child_task->counter = 0;
ffffffe000201af4:	fd843783          	ld	a5,-40(s0)
ffffffe000201af8:	0007b423          	sd	zero,8(a5)
    child_task->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000201afc:	139020ef          	jal	ra,ffffffe000204434 <rand>
ffffffe000201b00:	00050793          	mv	a5,a0
ffffffe000201b04:	00078713          	mv	a4,a5
ffffffe000201b08:	00a00793          	li	a5,10
ffffffe000201b0c:	02f767bb          	remw	a5,a4,a5
ffffffe000201b10:	0007879b          	sext.w	a5,a5
ffffffe000201b14:	0017879b          	addiw	a5,a5,1
ffffffe000201b18:	0007879b          	sext.w	a5,a5
ffffffe000201b1c:	00078713          	mv	a4,a5
ffffffe000201b20:	fd843783          	ld	a5,-40(s0)
ffffffe000201b24:	00e7b823          	sd	a4,16(a5)
    child_task->mm.mmap = NULL;
ffffffe000201b28:	fd843783          	ld	a5,-40(s0)
ffffffe000201b2c:	0a07b823          	sd	zero,176(a5)

    // copy pgd
    child_task->pgd = (uint64_t *)alloc_page();
ffffffe000201b30:	e31fe0ef          	jal	ra,ffffffe000200960 <alloc_page>
ffffffe000201b34:	00050713          	mv	a4,a0
ffffffe000201b38:	fd843783          	ld	a5,-40(s0)
ffffffe000201b3c:	0ae7b423          	sd	a4,168(a5)
    memcpy(child_task->pgd, get_kernel_pgtbl(), PGSIZE);
ffffffe000201b40:	fd843783          	ld	a5,-40(s0)
ffffffe000201b44:	0a87b483          	ld	s1,168(a5)
ffffffe000201b48:	510010ef          	jal	ra,ffffffe000203058 <get_kernel_pgtbl>
ffffffe000201b4c:	00050793          	mv	a5,a0
ffffffe000201b50:	00001637          	lui	a2,0x1
ffffffe000201b54:	00078593          	mv	a1,a5
ffffffe000201b58:	00048513          	mv	a0,s1
ffffffe000201b5c:	1a5020ef          	jal	ra,ffffffe000204500 <memcpy>

    // copy vma
    copy_vma(child_task, get_current_proc());
ffffffe000201b60:	fa9fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000201b64:	00050793          	mv	a5,a0
ffffffe000201b68:	00078593          	mv	a1,a5
ffffffe000201b6c:	fd843503          	ld	a0,-40(s0)
ffffffe000201b70:	0b0000ef          	jal	ra,ffffffe000201c20 <copy_vma>

    // copy regs
    child_task->thread.ra = (uint64_t)__ret_from_fork;
ffffffe000201b74:	ffffe717          	auipc	a4,0xffffe
ffffffe000201b78:	5d470713          	addi	a4,a4,1492 # ffffffe000200148 <__ret_from_fork>
ffffffe000201b7c:	fd843783          	ld	a5,-40(s0)
ffffffe000201b80:	02e7b023          	sd	a4,32(a5)
    struct pt_regs *child_regs = (struct pt_regs *)((uint64_t)child_task + (uint64_t)regs - (uint64_t)get_current_proc());
ffffffe000201b84:	fd843703          	ld	a4,-40(s0)
ffffffe000201b88:	fb843783          	ld	a5,-72(s0)
ffffffe000201b8c:	00f704b3          	add	s1,a4,a5
ffffffe000201b90:	f79fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000201b94:	00050793          	mv	a5,a0
ffffffe000201b98:	40f487b3          	sub	a5,s1,a5
ffffffe000201b9c:	fcf43823          	sd	a5,-48(s0)
    child_task->thread.sp = (uint64_t)child_regs;
ffffffe000201ba0:	fd043703          	ld	a4,-48(s0)
ffffffe000201ba4:	fd843783          	ld	a5,-40(s0)
ffffffe000201ba8:	02e7b423          	sd	a4,40(a5)
    child_task->thread.sepc = regs->sepc;
ffffffe000201bac:	fb843783          	ld	a5,-72(s0)
ffffffe000201bb0:	0f07b703          	ld	a4,240(a5)
ffffffe000201bb4:	fd843783          	ld	a5,-40(s0)
ffffffe000201bb8:	08e7b823          	sd	a4,144(a5)
    child_task->thread.sscratch = csr_read(sscratch);
ffffffe000201bbc:	140027f3          	csrr	a5,sscratch
ffffffe000201bc0:	fcf43423          	sd	a5,-56(s0)
ffffffe000201bc4:	fc843703          	ld	a4,-56(s0)
ffffffe000201bc8:	fd843783          	ld	a5,-40(s0)
ffffffe000201bcc:	0ae7b023          	sd	a4,160(a5)
    child_regs->a[0] = 0;
ffffffe000201bd0:	fd043783          	ld	a5,-48(s0)
ffffffe000201bd4:	0407b023          	sd	zero,64(a5)
    child_regs->sp = child_task->thread.sp;
ffffffe000201bd8:	fd843783          	ld	a5,-40(s0)
ffffffe000201bdc:	0287b703          	ld	a4,40(a5)
ffffffe000201be0:	fd043783          	ld	a5,-48(s0)
ffffffe000201be4:	10e7b023          	sd	a4,256(a5)
    child_regs->sepc += 4;
ffffffe000201be8:	fd043783          	ld	a5,-48(s0)
ffffffe000201bec:	0f07b783          	ld	a5,240(a5)
ffffffe000201bf0:	00478713          	addi	a4,a5,4
ffffffe000201bf4:	fd043783          	ld	a5,-48(s0)
ffffffe000201bf8:	0ee7b823          	sd	a4,240(a5)

    return add_task(child_task);
ffffffe000201bfc:	fd843503          	ld	a0,-40(s0)
ffffffe000201c00:	92dff0ef          	jal	ra,ffffffe00020152c <add_task>
ffffffe000201c04:	00050793          	mv	a5,a0
}
ffffffe000201c08:	00078513          	mv	a0,a5
ffffffe000201c0c:	04813083          	ld	ra,72(sp)
ffffffe000201c10:	04013403          	ld	s0,64(sp)
ffffffe000201c14:	03813483          	ld	s1,56(sp)
ffffffe000201c18:	05010113          	addi	sp,sp,80
ffffffe000201c1c:	00008067          	ret

ffffffe000201c20 <copy_vma>:

void copy_vma(struct task_struct *child, struct task_struct *parent)
{
ffffffe000201c20:	fa010113          	addi	sp,sp,-96
ffffffe000201c24:	04113c23          	sd	ra,88(sp)
ffffffe000201c28:	04813823          	sd	s0,80(sp)
ffffffe000201c2c:	06010413          	addi	s0,sp,96
ffffffe000201c30:	faa43423          	sd	a0,-88(s0)
ffffffe000201c34:	fab43023          	sd	a1,-96(s0)
    struct vm_area_struct *p_vma = parent->mm.mmap;
ffffffe000201c38:	fa043783          	ld	a5,-96(s0)
ffffffe000201c3c:	0b07b783          	ld	a5,176(a5)
ffffffe000201c40:	fef43423          	sd	a5,-24(s0)
    struct vm_area_struct *c_vma = NULL;
ffffffe000201c44:	fc043c23          	sd	zero,-40(s0)

    while (p_vma)
ffffffe000201c48:	12c0006f          	j	ffffffe000201d74 <copy_vma+0x154>
    {
        do_mmap(&child->mm, p_vma->vm_start, p_vma->vm_end - p_vma->vm_start, p_vma->vm_pgoff, p_vma->vm_filesz, p_vma->vm_flags);
ffffffe000201c4c:	fa843783          	ld	a5,-88(s0)
ffffffe000201c50:	0b078513          	addi	a0,a5,176
ffffffe000201c54:	fe843783          	ld	a5,-24(s0)
ffffffe000201c58:	0087b583          	ld	a1,8(a5)
ffffffe000201c5c:	fe843783          	ld	a5,-24(s0)
ffffffe000201c60:	0107b703          	ld	a4,16(a5)
ffffffe000201c64:	fe843783          	ld	a5,-24(s0)
ffffffe000201c68:	0087b783          	ld	a5,8(a5)
ffffffe000201c6c:	40f70633          	sub	a2,a4,a5
ffffffe000201c70:	fe843783          	ld	a5,-24(s0)
ffffffe000201c74:	0307b683          	ld	a3,48(a5)
ffffffe000201c78:	fe843783          	ld	a5,-24(s0)
ffffffe000201c7c:	0387b703          	ld	a4,56(a5)
ffffffe000201c80:	fe843783          	ld	a5,-24(s0)
ffffffe000201c84:	0287b783          	ld	a5,40(a5)
ffffffe000201c88:	f64ff0ef          	jal	ra,ffffffe0002013ec <do_mmap>

        uint64_t start_addr = PGROUNDDOWN(p_vma->vm_start);
ffffffe000201c8c:	fe843783          	ld	a5,-24(s0)
ffffffe000201c90:	0087b703          	ld	a4,8(a5)
ffffffe000201c94:	fffff7b7          	lui	a5,0xfffff
ffffffe000201c98:	00f777b3          	and	a5,a4,a5
ffffffe000201c9c:	fcf43823          	sd	a5,-48(s0)
        uint64_t end_addr = PGROUNDUP(p_vma->vm_end);
ffffffe000201ca0:	fe843783          	ld	a5,-24(s0)
ffffffe000201ca4:	0107b703          	ld	a4,16(a5) # fffffffffffff010 <VM_END+0xfffff010>
ffffffe000201ca8:	000017b7          	lui	a5,0x1
ffffffe000201cac:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201cb0:	00f70733          	add	a4,a4,a5
ffffffe000201cb4:	fffff7b7          	lui	a5,0xfffff
ffffffe000201cb8:	00f777b3          	and	a5,a4,a5
ffffffe000201cbc:	fcf43423          	sd	a5,-56(s0)

        for (uint64_t va = start_addr; va < end_addr; va += PGSIZE)
ffffffe000201cc0:	fd043783          	ld	a5,-48(s0)
ffffffe000201cc4:	fef43023          	sd	a5,-32(s0)
ffffffe000201cc8:	0940006f          	j	ffffffe000201d5c <copy_vma+0x13c>
        {
            if (va_mapped(parent->pgd, va))
ffffffe000201ccc:	fa043783          	ld	a5,-96(s0)
ffffffe000201cd0:	0a87b783          	ld	a5,168(a5) # fffffffffffff0a8 <VM_END+0xfffff0a8>
ffffffe000201cd4:	fe043583          	ld	a1,-32(s0)
ffffffe000201cd8:	00078513          	mv	a0,a5
ffffffe000201cdc:	498010ef          	jal	ra,ffffffe000203174 <va_mapped>
ffffffe000201ce0:	00050793          	mv	a5,a0
ffffffe000201ce4:	06078463          	beqz	a5,ffffffe000201d4c <copy_vma+0x12c>
            {
                uint64_t *pg = (uint64_t *)kalloc();
ffffffe000201ce8:	cedfe0ef          	jal	ra,ffffffe0002009d4 <kalloc>
ffffffe000201cec:	fca43023          	sd	a0,-64(s0)
                memcpy(pg, va, PGSIZE);
ffffffe000201cf0:	fe043783          	ld	a5,-32(s0)
ffffffe000201cf4:	00001637          	lui	a2,0x1
ffffffe000201cf8:	00078593          	mv	a1,a5
ffffffe000201cfc:	fc043503          	ld	a0,-64(s0)
ffffffe000201d00:	001020ef          	jal	ra,ffffffe000204500 <memcpy>
                
                uint64_t perm = vmflags2pte(p_vma->vm_flags) | PTE_V | PTE_U;
ffffffe000201d04:	fe843783          	ld	a5,-24(s0)
ffffffe000201d08:	0287b783          	ld	a5,40(a5)
ffffffe000201d0c:	00078513          	mv	a0,a5
ffffffe000201d10:	12c010ef          	jal	ra,ffffffe000202e3c <vmflags2pte>
ffffffe000201d14:	00050793          	mv	a5,a0
ffffffe000201d18:	0117e793          	ori	a5,a5,17
ffffffe000201d1c:	faf43c23          	sd	a5,-72(s0)
                create_mapping(child->pgd, va, VA2PA(pg), PGSIZE, perm);
ffffffe000201d20:	fa843783          	ld	a5,-88(s0)
ffffffe000201d24:	0a87b503          	ld	a0,168(a5)
ffffffe000201d28:	fc043703          	ld	a4,-64(s0)
ffffffe000201d2c:	04100793          	li	a5,65
ffffffe000201d30:	01f79793          	slli	a5,a5,0x1f
ffffffe000201d34:	00f707b3          	add	a5,a4,a5
ffffffe000201d38:	fb843703          	ld	a4,-72(s0)
ffffffe000201d3c:	000016b7          	lui	a3,0x1
ffffffe000201d40:	00078613          	mv	a2,a5
ffffffe000201d44:	fe043583          	ld	a1,-32(s0)
ffffffe000201d48:	120010ef          	jal	ra,ffffffe000202e68 <create_mapping>
        for (uint64_t va = start_addr; va < end_addr; va += PGSIZE)
ffffffe000201d4c:	fe043703          	ld	a4,-32(s0)
ffffffe000201d50:	000017b7          	lui	a5,0x1
ffffffe000201d54:	00f707b3          	add	a5,a4,a5
ffffffe000201d58:	fef43023          	sd	a5,-32(s0)
ffffffe000201d5c:	fe043703          	ld	a4,-32(s0)
ffffffe000201d60:	fc843783          	ld	a5,-56(s0)
ffffffe000201d64:	f6f764e3          	bltu	a4,a5,ffffffe000201ccc <copy_vma+0xac>
            }
        }

        p_vma = p_vma->vm_next;
ffffffe000201d68:	fe843783          	ld	a5,-24(s0)
ffffffe000201d6c:	0187b783          	ld	a5,24(a5) # 1018 <PGSIZE+0x18>
ffffffe000201d70:	fef43423          	sd	a5,-24(s0)
    while (p_vma)
ffffffe000201d74:	fe843783          	ld	a5,-24(s0)
ffffffe000201d78:	ec079ae3          	bnez	a5,ffffffe000201c4c <copy_vma+0x2c>
    }
}
ffffffe000201d7c:	00000013          	nop
ffffffe000201d80:	00000013          	nop
ffffffe000201d84:	05813083          	ld	ra,88(sp)
ffffffe000201d88:	05013403          	ld	s0,80(sp)
ffffffe000201d8c:	06010113          	addi	sp,sp,96
ffffffe000201d90:	00008067          	ret

ffffffe000201d94 <find_free_fd>:

int find_free_fd(struct files_struct *files) {
ffffffe000201d94:	fd010113          	addi	sp,sp,-48
ffffffe000201d98:	02813423          	sd	s0,40(sp)
ffffffe000201d9c:	03010413          	addi	s0,sp,48
ffffffe000201da0:	fca43c23          	sd	a0,-40(s0)
    for (int i = 0; i < MAX_FILE_NUMBER; i++) {
ffffffe000201da4:	fe042623          	sw	zero,-20(s0)
ffffffe000201da8:	03c0006f          	j	ffffffe000201de4 <find_free_fd+0x50>
        if (files->fd_array[i].opened == 0) {
ffffffe000201dac:	fd843683          	ld	a3,-40(s0)
ffffffe000201db0:	fec42703          	lw	a4,-20(s0)
ffffffe000201db4:	00070793          	mv	a5,a4
ffffffe000201db8:	00479793          	slli	a5,a5,0x4
ffffffe000201dbc:	00e787b3          	add	a5,a5,a4
ffffffe000201dc0:	00379793          	slli	a5,a5,0x3
ffffffe000201dc4:	00f687b3          	add	a5,a3,a5
ffffffe000201dc8:	0007a783          	lw	a5,0(a5)
ffffffe000201dcc:	00079663          	bnez	a5,ffffffe000201dd8 <find_free_fd+0x44>
            return i;
ffffffe000201dd0:	fec42783          	lw	a5,-20(s0)
ffffffe000201dd4:	0240006f          	j	ffffffe000201df8 <find_free_fd+0x64>
    for (int i = 0; i < MAX_FILE_NUMBER; i++) {
ffffffe000201dd8:	fec42783          	lw	a5,-20(s0)
ffffffe000201ddc:	0017879b          	addiw	a5,a5,1
ffffffe000201de0:	fef42623          	sw	a5,-20(s0)
ffffffe000201de4:	fec42783          	lw	a5,-20(s0)
ffffffe000201de8:	0007871b          	sext.w	a4,a5
ffffffe000201dec:	00f00793          	li	a5,15
ffffffe000201df0:	fae7dee3          	bge	a5,a4,ffffffe000201dac <find_free_fd+0x18>
        }
    }
    return -1;
ffffffe000201df4:	fff00793          	li	a5,-1
}
ffffffe000201df8:	00078513          	mv	a0,a5
ffffffe000201dfc:	02813403          	ld	s0,40(sp)
ffffffe000201e00:	03010113          	addi	sp,sp,48
ffffffe000201e04:	00008067          	ret

ffffffe000201e08 <strncmp>:

uint64_t strncmp(const char *s1, const char *s2, int n) {
ffffffe000201e08:	fd010113          	addi	sp,sp,-48
ffffffe000201e0c:	02813423          	sd	s0,40(sp)
ffffffe000201e10:	03010413          	addi	s0,sp,48
ffffffe000201e14:	fea43423          	sd	a0,-24(s0)
ffffffe000201e18:	feb43023          	sd	a1,-32(s0)
ffffffe000201e1c:	00060793          	mv	a5,a2
ffffffe000201e20:	fcf42e23          	sw	a5,-36(s0)
    while (n > 0) {
ffffffe000201e24:	0740006f          	j	ffffffe000201e98 <strncmp+0x90>
        if (*s1 != *s2) {
ffffffe000201e28:	fe843783          	ld	a5,-24(s0)
ffffffe000201e2c:	0007c703          	lbu	a4,0(a5)
ffffffe000201e30:	fe043783          	ld	a5,-32(s0)
ffffffe000201e34:	0007c783          	lbu	a5,0(a5)
ffffffe000201e38:	02f70463          	beq	a4,a5,ffffffe000201e60 <strncmp+0x58>
            return *s1 - *s2;
ffffffe000201e3c:	fe843783          	ld	a5,-24(s0)
ffffffe000201e40:	0007c783          	lbu	a5,0(a5)
ffffffe000201e44:	0007871b          	sext.w	a4,a5
ffffffe000201e48:	fe043783          	ld	a5,-32(s0)
ffffffe000201e4c:	0007c783          	lbu	a5,0(a5)
ffffffe000201e50:	0007879b          	sext.w	a5,a5
ffffffe000201e54:	40f707bb          	subw	a5,a4,a5
ffffffe000201e58:	0007879b          	sext.w	a5,a5
ffffffe000201e5c:	04c0006f          	j	ffffffe000201ea8 <strncmp+0xa0>
        }
        if (*s1 == '\0') {
ffffffe000201e60:	fe843783          	ld	a5,-24(s0)
ffffffe000201e64:	0007c783          	lbu	a5,0(a5)
ffffffe000201e68:	00079663          	bnez	a5,ffffffe000201e74 <strncmp+0x6c>
            return 0;
ffffffe000201e6c:	00000793          	li	a5,0
ffffffe000201e70:	0380006f          	j	ffffffe000201ea8 <strncmp+0xa0>
        }
        s1++;
ffffffe000201e74:	fe843783          	ld	a5,-24(s0)
ffffffe000201e78:	00178793          	addi	a5,a5,1
ffffffe000201e7c:	fef43423          	sd	a5,-24(s0)
        s2++;
ffffffe000201e80:	fe043783          	ld	a5,-32(s0)
ffffffe000201e84:	00178793          	addi	a5,a5,1
ffffffe000201e88:	fef43023          	sd	a5,-32(s0)
        n--;
ffffffe000201e8c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201e90:	fff7879b          	addiw	a5,a5,-1
ffffffe000201e94:	fcf42e23          	sw	a5,-36(s0)
    while (n > 0) {
ffffffe000201e98:	fdc42783          	lw	a5,-36(s0)
ffffffe000201e9c:	0007879b          	sext.w	a5,a5
ffffffe000201ea0:	f8f044e3          	bgtz	a5,ffffffe000201e28 <strncmp+0x20>
    }
    return 0;
ffffffe000201ea4:	00000793          	li	a5,0
}
ffffffe000201ea8:	00078513          	mv	a0,a5
ffffffe000201eac:	02813403          	ld	s0,40(sp)
ffffffe000201eb0:	03010113          	addi	sp,sp,48
ffffffe000201eb4:	00008067          	ret

ffffffe000201eb8 <strncpy>:

int64_t strncpy(char *dest, const char *src, int n) {
ffffffe000201eb8:	fc010113          	addi	sp,sp,-64
ffffffe000201ebc:	02813c23          	sd	s0,56(sp)
ffffffe000201ec0:	04010413          	addi	s0,sp,64
ffffffe000201ec4:	fca43c23          	sd	a0,-40(s0)
ffffffe000201ec8:	fcb43823          	sd	a1,-48(s0)
ffffffe000201ecc:	00060793          	mv	a5,a2
ffffffe000201ed0:	fcf42623          	sw	a5,-52(s0)
    int i = 0;
ffffffe000201ed4:	fe042623          	sw	zero,-20(s0)
    while (i < n && src[i] != '\0') {
ffffffe000201ed8:	0300006f          	j	ffffffe000201f08 <strncpy+0x50>
        dest[i] = src[i];
ffffffe000201edc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ee0:	fd043703          	ld	a4,-48(s0)
ffffffe000201ee4:	00f70733          	add	a4,a4,a5
ffffffe000201ee8:	fec42783          	lw	a5,-20(s0)
ffffffe000201eec:	fd843683          	ld	a3,-40(s0)
ffffffe000201ef0:	00f687b3          	add	a5,a3,a5
ffffffe000201ef4:	00074703          	lbu	a4,0(a4)
ffffffe000201ef8:	00e78023          	sb	a4,0(a5)
        i++;
ffffffe000201efc:	fec42783          	lw	a5,-20(s0)
ffffffe000201f00:	0017879b          	addiw	a5,a5,1
ffffffe000201f04:	fef42623          	sw	a5,-20(s0)
    while (i < n && src[i] != '\0') {
ffffffe000201f08:	fec42783          	lw	a5,-20(s0)
ffffffe000201f0c:	00078713          	mv	a4,a5
ffffffe000201f10:	fcc42783          	lw	a5,-52(s0)
ffffffe000201f14:	0007071b          	sext.w	a4,a4
ffffffe000201f18:	0007879b          	sext.w	a5,a5
ffffffe000201f1c:	00f75c63          	bge	a4,a5,ffffffe000201f34 <strncpy+0x7c>
ffffffe000201f20:	fec42783          	lw	a5,-20(s0)
ffffffe000201f24:	fd043703          	ld	a4,-48(s0)
ffffffe000201f28:	00f707b3          	add	a5,a4,a5
ffffffe000201f2c:	0007c783          	lbu	a5,0(a5)
ffffffe000201f30:	fa0796e3          	bnez	a5,ffffffe000201edc <strncpy+0x24>
    }
    dest[i] = '\0';
ffffffe000201f34:	fec42783          	lw	a5,-20(s0)
ffffffe000201f38:	fd843703          	ld	a4,-40(s0)
ffffffe000201f3c:	00f707b3          	add	a5,a4,a5
ffffffe000201f40:	00078023          	sb	zero,0(a5)
    return i;
ffffffe000201f44:	fec42783          	lw	a5,-20(s0)
}
ffffffe000201f48:	00078513          	mv	a0,a5
ffffffe000201f4c:	03813403          	ld	s0,56(sp)
ffffffe000201f50:	04010113          	addi	sp,sp,64
ffffffe000201f54:	00008067          	ret

ffffffe000201f58 <sys_openat>:

int64_t sys_openat(int dfd, const char *path, int flags) {
ffffffe000201f58:	fc010113          	addi	sp,sp,-64
ffffffe000201f5c:	02113c23          	sd	ra,56(sp)
ffffffe000201f60:	02813823          	sd	s0,48(sp)
ffffffe000201f64:	04010413          	addi	s0,sp,64
ffffffe000201f68:	00050793          	mv	a5,a0
ffffffe000201f6c:	fcb43023          	sd	a1,-64(s0)
ffffffe000201f70:	00060713          	mv	a4,a2
ffffffe000201f74:	fcf42623          	sw	a5,-52(s0)
ffffffe000201f78:	00070793          	mv	a5,a4
ffffffe000201f7c:	fcf42423          	sw	a5,-56(s0)
    // Log("sys_openat: path = %s, flags = %d", path, flags);
    struct task_struct *current_task = get_current_proc();
ffffffe000201f80:	b89fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000201f84:	fea43423          	sd	a0,-24(s0)
    struct files_struct *files = current_task->files;
ffffffe000201f88:	fe843783          	ld	a5,-24(s0)
ffffffe000201f8c:	0b87b783          	ld	a5,184(a5)
ffffffe000201f90:	fef43023          	sd	a5,-32(s0)
    int fd = find_free_fd(files);
ffffffe000201f94:	fe043503          	ld	a0,-32(s0)
ffffffe000201f98:	dfdff0ef          	jal	ra,ffffffe000201d94 <find_free_fd>
ffffffe000201f9c:	00050793          	mv	a5,a0
ffffffe000201fa0:	fcf42e23          	sw	a5,-36(s0)

    if (fd == -1) {
ffffffe000201fa4:	fdc42783          	lw	a5,-36(s0)
ffffffe000201fa8:	0007871b          	sext.w	a4,a5
ffffffe000201fac:	fff00793          	li	a5,-1
ffffffe000201fb0:	02f71463          	bne	a4,a5,ffffffe000201fd8 <sys_openat+0x80>
        Err("No available file descriptor");
ffffffe000201fb4:	00005697          	auipc	a3,0x5
ffffffe000201fb8:	3f468693          	addi	a3,a3,1012 # ffffffe0002073a8 <__func__.3>
ffffffe000201fbc:	0a000613          	li	a2,160
ffffffe000201fc0:	00005597          	auipc	a1,0x5
ffffffe000201fc4:	15058593          	addi	a1,a1,336 # ffffffe000207110 <__func__.4+0x110>
ffffffe000201fc8:	00005517          	auipc	a0,0x5
ffffffe000201fcc:	22050513          	addi	a0,a0,544 # ffffffe0002071e8 <__func__.4+0x1e8>
ffffffe000201fd0:	3a0020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000201fd4:	0000006f          	j	ffffffe000201fd4 <sys_openat+0x7c>
        return -1;
    }

    int32_t ret = file_open(&files->fd_array[fd], path, flags);
ffffffe000201fd8:	fdc42703          	lw	a4,-36(s0)
ffffffe000201fdc:	00070793          	mv	a5,a4
ffffffe000201fe0:	00479793          	slli	a5,a5,0x4
ffffffe000201fe4:	00e787b3          	add	a5,a5,a4
ffffffe000201fe8:	00379793          	slli	a5,a5,0x3
ffffffe000201fec:	fe043703          	ld	a4,-32(s0)
ffffffe000201ff0:	00f707b3          	add	a5,a4,a5
ffffffe000201ff4:	fc842703          	lw	a4,-56(s0)
ffffffe000201ff8:	00070613          	mv	a2,a4
ffffffe000201ffc:	fc043583          	ld	a1,-64(s0)
ffffffe000202000:	00078513          	mv	a0,a5
ffffffe000202004:	71c030ef          	jal	ra,ffffffe000205720 <file_open>
ffffffe000202008:	00050793          	mv	a5,a0
ffffffe00020200c:	fcf42c23          	sw	a5,-40(s0)
    if (ret < 0) {
ffffffe000202010:	fd842783          	lw	a5,-40(s0)
ffffffe000202014:	0007879b          	sext.w	a5,a5
ffffffe000202018:	0207d463          	bgez	a5,ffffffe000202040 <sys_openat+0xe8>
        Err("file open error");
ffffffe00020201c:	00005697          	auipc	a3,0x5
ffffffe000202020:	38c68693          	addi	a3,a3,908 # ffffffe0002073a8 <__func__.3>
ffffffe000202024:	0a600613          	li	a2,166
ffffffe000202028:	00005597          	auipc	a1,0x5
ffffffe00020202c:	0e858593          	addi	a1,a1,232 # ffffffe000207110 <__func__.4+0x110>
ffffffe000202030:	00005517          	auipc	a0,0x5
ffffffe000202034:	1f050513          	addi	a0,a0,496 # ffffffe000207220 <__func__.4+0x220>
ffffffe000202038:	338020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe00020203c:	0000006f          	j	ffffffe00020203c <sys_openat+0xe4>
    }
    Log("sys_openat: fd = %d, path = %s", fd, path);
ffffffe000202040:	fdc42703          	lw	a4,-36(s0)
ffffffe000202044:	fc043783          	ld	a5,-64(s0)
ffffffe000202048:	00005697          	auipc	a3,0x5
ffffffe00020204c:	36068693          	addi	a3,a3,864 # ffffffe0002073a8 <__func__.3>
ffffffe000202050:	0a800613          	li	a2,168
ffffffe000202054:	00005597          	auipc	a1,0x5
ffffffe000202058:	0bc58593          	addi	a1,a1,188 # ffffffe000207110 <__func__.4+0x110>
ffffffe00020205c:	00005517          	auipc	a0,0x5
ffffffe000202060:	1ec50513          	addi	a0,a0,492 # ffffffe000207248 <__func__.4+0x248>
ffffffe000202064:	30c020ef          	jal	ra,ffffffe000204370 <printk>
    return fd;
ffffffe000202068:	fdc42783          	lw	a5,-36(s0)
}
ffffffe00020206c:	00078513          	mv	a0,a5
ffffffe000202070:	03813083          	ld	ra,56(sp)
ffffffe000202074:	03013403          	ld	s0,48(sp)
ffffffe000202078:	04010113          	addi	sp,sp,64
ffffffe00020207c:	00008067          	ret

ffffffe000202080 <sys_close>:

int64_t sys_close(int64_t fd) {
ffffffe000202080:	fc010113          	addi	sp,sp,-64
ffffffe000202084:	02113c23          	sd	ra,56(sp)
ffffffe000202088:	02813823          	sd	s0,48(sp)
ffffffe00020208c:	04010413          	addi	s0,sp,64
ffffffe000202090:	fca43423          	sd	a0,-56(s0)
    struct task_struct *current_task = get_current_proc();
ffffffe000202094:	a75fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000202098:	fea43423          	sd	a0,-24(s0)
    struct files_struct *files = current_task->files;
ffffffe00020209c:	fe843783          	ld	a5,-24(s0)
ffffffe0002020a0:	0b87b783          	ld	a5,184(a5)
ffffffe0002020a4:	fef43023          	sd	a5,-32(s0)
    if (fd < 0 || fd >= MAX_FILE_NUMBER) {
ffffffe0002020a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002020ac:	0007c863          	bltz	a5,ffffffe0002020bc <sys_close+0x3c>
ffffffe0002020b0:	fc843703          	ld	a4,-56(s0)
ffffffe0002020b4:	00f00793          	li	a5,15
ffffffe0002020b8:	02e7d463          	bge	a5,a4,ffffffe0002020e0 <sys_close+0x60>
        Err("Invalid file descriptor");
ffffffe0002020bc:	00005697          	auipc	a3,0x5
ffffffe0002020c0:	2fc68693          	addi	a3,a3,764 # ffffffe0002073b8 <__func__.2>
ffffffe0002020c4:	0b000613          	li	a2,176
ffffffe0002020c8:	00005597          	auipc	a1,0x5
ffffffe0002020cc:	04858593          	addi	a1,a1,72 # ffffffe000207110 <__func__.4+0x110>
ffffffe0002020d0:	00005517          	auipc	a0,0x5
ffffffe0002020d4:	1b050513          	addi	a0,a0,432 # ffffffe000207280 <__func__.4+0x280>
ffffffe0002020d8:	298020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002020dc:	0000006f          	j	ffffffe0002020dc <sys_close+0x5c>
    }
    struct file *file = &files->fd_array[fd];
ffffffe0002020e0:	fc843703          	ld	a4,-56(s0)
ffffffe0002020e4:	00070793          	mv	a5,a4
ffffffe0002020e8:	00479793          	slli	a5,a5,0x4
ffffffe0002020ec:	00e787b3          	add	a5,a5,a4
ffffffe0002020f0:	00379793          	slli	a5,a5,0x3
ffffffe0002020f4:	fe043703          	ld	a4,-32(s0)
ffffffe0002020f8:	00f707b3          	add	a5,a4,a5
ffffffe0002020fc:	fcf43c23          	sd	a5,-40(s0)
    if (!file || file->opened == 0) {
ffffffe000202100:	fd843783          	ld	a5,-40(s0)
ffffffe000202104:	00078863          	beqz	a5,ffffffe000202114 <sys_close+0x94>
ffffffe000202108:	fd843783          	ld	a5,-40(s0)
ffffffe00020210c:	0007a783          	lw	a5,0(a5)
ffffffe000202110:	02079463          	bnez	a5,ffffffe000202138 <sys_close+0xb8>
        Err("File not opened");
ffffffe000202114:	00005697          	auipc	a3,0x5
ffffffe000202118:	2a468693          	addi	a3,a3,676 # ffffffe0002073b8 <__func__.2>
ffffffe00020211c:	0b400613          	li	a2,180
ffffffe000202120:	00005597          	auipc	a1,0x5
ffffffe000202124:	ff058593          	addi	a1,a1,-16 # ffffffe000207110 <__func__.4+0x110>
ffffffe000202128:	00005517          	auipc	a0,0x5
ffffffe00020212c:	18850513          	addi	a0,a0,392 # ffffffe0002072b0 <__func__.4+0x2b0>
ffffffe000202130:	240020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000202134:	0000006f          	j	ffffffe000202134 <sys_close+0xb4>
    }
    file->opened = 0;
ffffffe000202138:	fd843783          	ld	a5,-40(s0)
ffffffe00020213c:	0007a023          	sw	zero,0(a5)
    return 0;
ffffffe000202140:	00000793          	li	a5,0
}
ffffffe000202144:	00078513          	mv	a0,a5
ffffffe000202148:	03813083          	ld	ra,56(sp)
ffffffe00020214c:	03013403          	ld	s0,48(sp)
ffffffe000202150:	04010113          	addi	sp,sp,64
ffffffe000202154:	00008067          	ret

ffffffe000202158 <sys_lseek>:

int64_t sys_lseek(uint64_t fd, int64_t offset, uint64_t whence) {
ffffffe000202158:	fb010113          	addi	sp,sp,-80
ffffffe00020215c:	04113423          	sd	ra,72(sp)
ffffffe000202160:	04813023          	sd	s0,64(sp)
ffffffe000202164:	05010413          	addi	s0,sp,80
ffffffe000202168:	fca43423          	sd	a0,-56(s0)
ffffffe00020216c:	fcb43023          	sd	a1,-64(s0)
ffffffe000202170:	fac43c23          	sd	a2,-72(s0)
    struct task_struct *current = get_current_proc();
ffffffe000202174:	995fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000202178:	fea43423          	sd	a0,-24(s0)
    struct file *file = &(current->files->fd_array[fd]);
ffffffe00020217c:	fe843783          	ld	a5,-24(s0)
ffffffe000202180:	0b87b683          	ld	a3,184(a5)
ffffffe000202184:	fc843703          	ld	a4,-56(s0)
ffffffe000202188:	00070793          	mv	a5,a4
ffffffe00020218c:	00479793          	slli	a5,a5,0x4
ffffffe000202190:	00e787b3          	add	a5,a5,a4
ffffffe000202194:	00379793          	slli	a5,a5,0x3
ffffffe000202198:	00f687b3          	add	a5,a3,a5
ffffffe00020219c:	fef43023          	sd	a5,-32(s0)

    if (file->opened == 0) {
ffffffe0002021a0:	fe043783          	ld	a5,-32(s0)
ffffffe0002021a4:	0007a783          	lw	a5,0(a5)
ffffffe0002021a8:	00079c63          	bnez	a5,ffffffe0002021c0 <sys_lseek+0x68>
        printk("file not opened\n");
ffffffe0002021ac:	00005517          	auipc	a0,0x5
ffffffe0002021b0:	f4c50513          	addi	a0,a0,-180 # ffffffe0002070f8 <__func__.4+0xf8>
ffffffe0002021b4:	1bc020ef          	jal	ra,ffffffe000204370 <printk>
        return ERROR_FILE_NOT_OPEN;
ffffffe0002021b8:	0ff00793          	li	a5,255
ffffffe0002021bc:	0800006f          	j	ffffffe00020223c <sys_lseek+0xe4>
    }

    if (file->lseek == NULL) {
ffffffe0002021c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002021c4:	0207b783          	ld	a5,32(a5)
ffffffe0002021c8:	02079463          	bnez	a5,ffffffe0002021f0 <sys_lseek+0x98>
        Err("file not support lseek function");
ffffffe0002021cc:	00005697          	auipc	a3,0x5
ffffffe0002021d0:	1fc68693          	addi	a3,a3,508 # ffffffe0002073c8 <__func__.1>
ffffffe0002021d4:	0c400613          	li	a2,196
ffffffe0002021d8:	00005597          	auipc	a1,0x5
ffffffe0002021dc:	f3858593          	addi	a1,a1,-200 # ffffffe000207110 <__func__.4+0x110>
ffffffe0002021e0:	00005517          	auipc	a0,0x5
ffffffe0002021e4:	0f850513          	addi	a0,a0,248 # ffffffe0002072d8 <__func__.4+0x2d8>
ffffffe0002021e8:	188020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002021ec:	0000006f          	j	ffffffe0002021ec <sys_lseek+0x94>
    }

    int64_t ret = file->lseek(file, offset, whence);
ffffffe0002021f0:	fe043783          	ld	a5,-32(s0)
ffffffe0002021f4:	0207b783          	ld	a5,32(a5)
ffffffe0002021f8:	fb843603          	ld	a2,-72(s0)
ffffffe0002021fc:	fc043583          	ld	a1,-64(s0)
ffffffe000202200:	fe043503          	ld	a0,-32(s0)
ffffffe000202204:	000780e7          	jalr	a5
ffffffe000202208:	fca43c23          	sd	a0,-40(s0)

    if (ret < 0) {
ffffffe00020220c:	fd843783          	ld	a5,-40(s0)
ffffffe000202210:	0207d463          	bgez	a5,ffffffe000202238 <sys_lseek+0xe0>
        Err("file lseek error");
ffffffe000202214:	00005697          	auipc	a3,0x5
ffffffe000202218:	1b468693          	addi	a3,a3,436 # ffffffe0002073c8 <__func__.1>
ffffffe00020221c:	0ca00613          	li	a2,202
ffffffe000202220:	00005597          	auipc	a1,0x5
ffffffe000202224:	ef058593          	addi	a1,a1,-272 # ffffffe000207110 <__func__.4+0x110>
ffffffe000202228:	00005517          	auipc	a0,0x5
ffffffe00020222c:	0e850513          	addi	a0,a0,232 # ffffffe000207310 <__func__.4+0x310>
ffffffe000202230:	140020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000202234:	0000006f          	j	ffffffe000202234 <sys_lseek+0xdc>
    }

    return ret;
ffffffe000202238:	fd843783          	ld	a5,-40(s0)
}
ffffffe00020223c:	00078513          	mv	a0,a5
ffffffe000202240:	04813083          	ld	ra,72(sp)
ffffffe000202244:	04013403          	ld	s0,64(sp)
ffffffe000202248:	05010113          	addi	sp,sp,80
ffffffe00020224c:	00008067          	ret

ffffffe000202250 <sys_read>:

int64_t sys_read(uint64_t fd, void *buf, uint64_t len) {
ffffffe000202250:	fb010113          	addi	sp,sp,-80
ffffffe000202254:	04113423          	sd	ra,72(sp)
ffffffe000202258:	04813023          	sd	s0,64(sp)
ffffffe00020225c:	05010413          	addi	s0,sp,80
ffffffe000202260:	fca43423          	sd	a0,-56(s0)
ffffffe000202264:	fcb43023          	sd	a1,-64(s0)
ffffffe000202268:	fac43c23          	sd	a2,-72(s0)
    struct task_struct *current = get_current_proc();
ffffffe00020226c:	89dfe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000202270:	fea43423          	sd	a0,-24(s0)
    struct file *file = &(current->files->fd_array[fd]);
ffffffe000202274:	fe843783          	ld	a5,-24(s0)
ffffffe000202278:	0b87b683          	ld	a3,184(a5)
ffffffe00020227c:	fc843703          	ld	a4,-56(s0)
ffffffe000202280:	00070793          	mv	a5,a4
ffffffe000202284:	00479793          	slli	a5,a5,0x4
ffffffe000202288:	00e787b3          	add	a5,a5,a4
ffffffe00020228c:	00379793          	slli	a5,a5,0x3
ffffffe000202290:	00f687b3          	add	a5,a3,a5
ffffffe000202294:	fef43023          	sd	a5,-32(s0)

    if (file->opened == 0) {
ffffffe000202298:	fe043783          	ld	a5,-32(s0)
ffffffe00020229c:	0007a783          	lw	a5,0(a5)
ffffffe0002022a0:	00079c63          	bnez	a5,ffffffe0002022b8 <sys_read+0x68>
        printk("file not opened\n");
ffffffe0002022a4:	00005517          	auipc	a0,0x5
ffffffe0002022a8:	e5450513          	addi	a0,a0,-428 # ffffffe0002070f8 <__func__.4+0xf8>
ffffffe0002022ac:	0c4020ef          	jal	ra,ffffffe000204370 <printk>
        return ERROR_FILE_NOT_OPEN;
ffffffe0002022b0:	0ff00793          	li	a5,255
ffffffe0002022b4:	0800006f          	j	ffffffe000202334 <sys_read+0xe4>
    }

    if (file->read == NULL) {
ffffffe0002022b8:	fe043783          	ld	a5,-32(s0)
ffffffe0002022bc:	0307b783          	ld	a5,48(a5)
ffffffe0002022c0:	02079463          	bnez	a5,ffffffe0002022e8 <sys_read+0x98>
        Err("file not support read function");
ffffffe0002022c4:	00005697          	auipc	a3,0x5
ffffffe0002022c8:	11468693          	addi	a3,a3,276 # ffffffe0002073d8 <__func__.0>
ffffffe0002022cc:	0da00613          	li	a2,218
ffffffe0002022d0:	00005597          	auipc	a1,0x5
ffffffe0002022d4:	e4058593          	addi	a1,a1,-448 # ffffffe000207110 <__func__.4+0x110>
ffffffe0002022d8:	00005517          	auipc	a0,0x5
ffffffe0002022dc:	06050513          	addi	a0,a0,96 # ffffffe000207338 <__func__.4+0x338>
ffffffe0002022e0:	090020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002022e4:	0000006f          	j	ffffffe0002022e4 <sys_read+0x94>
    }

    int64_t ret = file->read(file, buf, len);
ffffffe0002022e8:	fe043783          	ld	a5,-32(s0)
ffffffe0002022ec:	0307b783          	ld	a5,48(a5)
ffffffe0002022f0:	fb843603          	ld	a2,-72(s0)
ffffffe0002022f4:	fc043583          	ld	a1,-64(s0)
ffffffe0002022f8:	fe043503          	ld	a0,-32(s0)
ffffffe0002022fc:	000780e7          	jalr	a5
ffffffe000202300:	fca43c23          	sd	a0,-40(s0)

    if (ret < 0) {
ffffffe000202304:	fd843783          	ld	a5,-40(s0)
ffffffe000202308:	0207d463          	bgez	a5,ffffffe000202330 <sys_read+0xe0>
        Err("file read error");
ffffffe00020230c:	00005697          	auipc	a3,0x5
ffffffe000202310:	0cc68693          	addi	a3,a3,204 # ffffffe0002073d8 <__func__.0>
ffffffe000202314:	0e000613          	li	a2,224
ffffffe000202318:	00005597          	auipc	a1,0x5
ffffffe00020231c:	df858593          	addi	a1,a1,-520 # ffffffe000207110 <__func__.4+0x110>
ffffffe000202320:	00005517          	auipc	a0,0x5
ffffffe000202324:	05050513          	addi	a0,a0,80 # ffffffe000207370 <__func__.4+0x370>
ffffffe000202328:	048020ef          	jal	ra,ffffffe000204370 <printk>
ffffffe00020232c:	0000006f          	j	ffffffe00020232c <sys_read+0xdc>
    }

    return ret;
ffffffe000202330:	fd843783          	ld	a5,-40(s0)
ffffffe000202334:	00078513          	mv	a0,a5
ffffffe000202338:	04813083          	ld	ra,72(sp)
ffffffe00020233c:	04013403          	ld	s0,64(sp)
ffffffe000202340:	05010113          	addi	sp,sp,80
ffffffe000202344:	00008067          	ret

ffffffe000202348 <trap_handler>:
extern void dummy();
extern char _sramdisk[];
void do_page_fault(struct pt_regs *regs);

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs)
{
ffffffe000202348:	f2010113          	addi	sp,sp,-224
ffffffe00020234c:	0c113c23          	sd	ra,216(sp)
ffffffe000202350:	0c813823          	sd	s0,208(sp)
ffffffe000202354:	0e010413          	addi	s0,sp,224
ffffffe000202358:	f2a43c23          	sd	a0,-200(s0)
ffffffe00020235c:	f2b43823          	sd	a1,-208(s0)
ffffffe000202360:	f2c43423          	sd	a2,-216(s0)
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    // Err("trap_handler: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    if (scause & 0x8000000000000000)
ffffffe000202364:	f3843783          	ld	a5,-200(s0)
ffffffe000202368:	0407d063          	bgez	a5,ffffffe0002023a8 <trap_handler+0x60>
    {
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe00020236c:	f3843783          	ld	a5,-200(s0)
ffffffe000202370:	0ff7f793          	zext.b	a5,a5
ffffffe000202374:	f4f43023          	sd	a5,-192(s0)
        if (interrupt_t == 0x5)
ffffffe000202378:	f4043703          	ld	a4,-192(s0)
ffffffe00020237c:	00500793          	li	a5,5
ffffffe000202380:	00f71863          	bne	a4,a5,ffffffe000202390 <trap_handler+0x48>
        {
            // timer interrupt
            // printk("timer interrupt, time = %ld\n", get_cycles());
            clock_set_next_event();
ffffffe000202384:	f79fd0ef          	jal	ra,ffffffe0002002fc <clock_set_next_event>
            do_timer();
ffffffe000202388:	dadfe0ef          	jal	ra,ffffffe000201134 <do_timer>
ffffffe00020238c:	2e00006f          	j	ffffffe00020266c <trap_handler+0x324>
        }
        else
        {
            // other interrupt
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000202390:	f3043603          	ld	a2,-208(s0)
ffffffe000202394:	f3843583          	ld	a1,-200(s0)
ffffffe000202398:	00005517          	auipc	a0,0x5
ffffffe00020239c:	05050513          	addi	a0,a0,80 # ffffffe0002073e8 <__func__.0+0x10>
ffffffe0002023a0:	7d1010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002023a4:	2c80006f          	j	ffffffe00020266c <trap_handler+0x324>
        }
    }
    else
    {
        // exception
        if (scause == ECALL_FROM_U_MODE)
ffffffe0002023a8:	f3843703          	ld	a4,-200(s0)
ffffffe0002023ac:	00800793          	li	a5,8
ffffffe0002023b0:	26f71063          	bne	a4,a5,ffffffe000202610 <trap_handler+0x2c8>
        {
            uint64_t syscall_id = regs->a[7];
ffffffe0002023b4:	f2843783          	ld	a5,-216(s0)
ffffffe0002023b8:	0787b783          	ld	a5,120(a5)
ffffffe0002023bc:	fef43423          	sd	a5,-24(s0)
            // printk("[trap_handler] ecall from user mode, syscall_id = %ld\n", syscall_id);

            switch (syscall_id)
ffffffe0002023c0:	fe843703          	ld	a4,-24(s0)
ffffffe0002023c4:	0dc00793          	li	a5,220
ffffffe0002023c8:	0ef70063          	beq	a4,a5,ffffffe0002024a8 <trap_handler+0x160>
ffffffe0002023cc:	fe843703          	ld	a4,-24(s0)
ffffffe0002023d0:	0dc00793          	li	a5,220
ffffffe0002023d4:	1ee7ee63          	bltu	a5,a4,ffffffe0002025d0 <trap_handler+0x288>
ffffffe0002023d8:	fe843703          	ld	a4,-24(s0)
ffffffe0002023dc:	04000793          	li	a5,64
ffffffe0002023e0:	04e7e463          	bltu	a5,a4,ffffffe000202428 <trap_handler+0xe0>
ffffffe0002023e4:	fe843703          	ld	a4,-24(s0)
ffffffe0002023e8:	03800793          	li	a5,56
ffffffe0002023ec:	1ef76263          	bltu	a4,a5,ffffffe0002025d0 <trap_handler+0x288>
ffffffe0002023f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002023f4:	fc878793          	addi	a5,a5,-56
ffffffe0002023f8:	00800713          	li	a4,8
ffffffe0002023fc:	1cf76a63          	bltu	a4,a5,ffffffe0002025d0 <trap_handler+0x288>
ffffffe000202400:	00279713          	slli	a4,a5,0x2
ffffffe000202404:	00005797          	auipc	a5,0x5
ffffffe000202408:	20478793          	addi	a5,a5,516 # ffffffe000207608 <__func__.0+0x230>
ffffffe00020240c:	00f707b3          	add	a5,a4,a5
ffffffe000202410:	0007a783          	lw	a5,0(a5)
ffffffe000202414:	0007871b          	sext.w	a4,a5
ffffffe000202418:	00005797          	auipc	a5,0x5
ffffffe00020241c:	1f078793          	addi	a5,a5,496 # ffffffe000207608 <__func__.0+0x230>
ffffffe000202420:	00f707b3          	add	a5,a4,a5
ffffffe000202424:	00078067          	jr	a5
ffffffe000202428:	fe843703          	ld	a4,-24(s0)
ffffffe00020242c:	0ac00793          	li	a5,172
ffffffe000202430:	04f70e63          	beq	a4,a5,ffffffe00020248c <trap_handler+0x144>
ffffffe000202434:	19c0006f          	j	ffffffe0002025d0 <trap_handler+0x288>
            {
            case SYS_WRITE:
            {
                uint64_t fd = (unsigned int)regs->a[0];
ffffffe000202438:	f2843783          	ld	a5,-216(s0)
ffffffe00020243c:	0407b783          	ld	a5,64(a5)
ffffffe000202440:	0007879b          	sext.w	a5,a5
ffffffe000202444:	02079793          	slli	a5,a5,0x20
ffffffe000202448:	0207d793          	srli	a5,a5,0x20
ffffffe00020244c:	fcf43823          	sd	a5,-48(s0)
                const char *buf = (const char *)regs->a[1];
ffffffe000202450:	f2843783          	ld	a5,-216(s0)
ffffffe000202454:	0487b783          	ld	a5,72(a5)
ffffffe000202458:	fcf43423          	sd	a5,-56(s0)
                uint64_t count = (size_t)regs->a[2];
ffffffe00020245c:	f2843783          	ld	a5,-216(s0)
ffffffe000202460:	0507b783          	ld	a5,80(a5)
ffffffe000202464:	fcf43023          	sd	a5,-64(s0)
                int64_t ret = sys_write(fd, buf, count);
ffffffe000202468:	fc043603          	ld	a2,-64(s0)
ffffffe00020246c:	fc843583          	ld	a1,-56(s0)
ffffffe000202470:	fd043503          	ld	a0,-48(s0)
ffffffe000202474:	c84ff0ef          	jal	ra,ffffffe0002018f8 <sys_write>
ffffffe000202478:	faa43c23          	sd	a0,-72(s0)
                regs->a[0] = ret;
ffffffe00020247c:	fb843703          	ld	a4,-72(s0)
ffffffe000202480:	f2843783          	ld	a5,-216(s0)
ffffffe000202484:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe000202488:	1700006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
            }

            case SYS_GETPID:
            {
                uint64_t pid = sys_getpid();
ffffffe00020248c:	d9cff0ef          	jal	ra,ffffffe000201a28 <sys_getpid>
ffffffe000202490:	00050793          	mv	a5,a0
ffffffe000202494:	fcf43c23          	sd	a5,-40(s0)
                regs->a[0] = pid;
ffffffe000202498:	f2843783          	ld	a5,-216(s0)
ffffffe00020249c:	fd843703          	ld	a4,-40(s0)
ffffffe0002024a0:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe0002024a4:	1540006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
            }

            case SYS_CLONE:
            {
                uint64_t ret = do_fork(regs);
ffffffe0002024a8:	f2843503          	ld	a0,-216(s0)
ffffffe0002024ac:	db4ff0ef          	jal	ra,ffffffe000201a60 <do_fork>
ffffffe0002024b0:	fea43023          	sd	a0,-32(s0)
                regs->a[0] = ret;
ffffffe0002024b4:	f2843783          	ld	a5,-216(s0)
ffffffe0002024b8:	fe043703          	ld	a4,-32(s0)
ffffffe0002024bc:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe0002024c0:	1380006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
                // void *buf = (void *)regs->a[1];
                // uint64_t len = (uint64_t)regs->a[2];
                // int64_t ret = stdin_read(file, buf, len);
                // regs->a[0] = ret;
                // break;
                uint64_t fd = (uint64_t)regs->a[0];
ffffffe0002024c4:	f2843783          	ld	a5,-216(s0)
ffffffe0002024c8:	0407b783          	ld	a5,64(a5)
ffffffe0002024cc:	faf43823          	sd	a5,-80(s0)
                void *buf = (void *)regs->a[1];
ffffffe0002024d0:	f2843783          	ld	a5,-216(s0)
ffffffe0002024d4:	0487b783          	ld	a5,72(a5)
ffffffe0002024d8:	faf43423          	sd	a5,-88(s0)
                uint64_t len = (uint64_t)regs->a[2];
ffffffe0002024dc:	f2843783          	ld	a5,-216(s0)
ffffffe0002024e0:	0507b783          	ld	a5,80(a5)
ffffffe0002024e4:	faf43023          	sd	a5,-96(s0)
                int64_t ret = sys_read(fd, buf, len);
ffffffe0002024e8:	fa043603          	ld	a2,-96(s0)
ffffffe0002024ec:	fa843583          	ld	a1,-88(s0)
ffffffe0002024f0:	fb043503          	ld	a0,-80(s0)
ffffffe0002024f4:	d5dff0ef          	jal	ra,ffffffe000202250 <sys_read>
ffffffe0002024f8:	f8a43c23          	sd	a0,-104(s0)
                regs->a[0] = ret;
ffffffe0002024fc:	f9843703          	ld	a4,-104(s0)
ffffffe000202500:	f2843783          	ld	a5,-216(s0)
ffffffe000202504:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe000202508:	0f00006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
            }

            case SYS_OPENAT:
            {
                // Log("path = %lx, flags = %ld", regs->a[0], regs->a[1]);
                int dfd = (int)regs->a[0];
ffffffe00020250c:	f2843783          	ld	a5,-216(s0)
ffffffe000202510:	0407b783          	ld	a5,64(a5)
ffffffe000202514:	f6f42223          	sw	a5,-156(s0)
                const char *path = (const char *)regs->a[1];
ffffffe000202518:	f2843783          	ld	a5,-216(s0)
ffffffe00020251c:	0487b783          	ld	a5,72(a5)
ffffffe000202520:	f4f43c23          	sd	a5,-168(s0)
                int64_t flags = (int64_t)regs->a[2];
ffffffe000202524:	f2843783          	ld	a5,-216(s0)
ffffffe000202528:	0507b783          	ld	a5,80(a5)
ffffffe00020252c:	f4f43823          	sd	a5,-176(s0)
                int64_t ret = sys_openat(dfd, path, flags);
ffffffe000202530:	f5043783          	ld	a5,-176(s0)
ffffffe000202534:	0007871b          	sext.w	a4,a5
ffffffe000202538:	f6442783          	lw	a5,-156(s0)
ffffffe00020253c:	00070613          	mv	a2,a4
ffffffe000202540:	f5843583          	ld	a1,-168(s0)
ffffffe000202544:	00078513          	mv	a0,a5
ffffffe000202548:	a11ff0ef          	jal	ra,ffffffe000201f58 <sys_openat>
ffffffe00020254c:	f4a43423          	sd	a0,-184(s0)
                regs->a[0] = ret;
ffffffe000202550:	f4843703          	ld	a4,-184(s0)
ffffffe000202554:	f2843783          	ld	a5,-216(s0)
ffffffe000202558:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe00020255c:	09c0006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
            }

            case SYS_CLOSE:
            {
                int64_t fd = (int64_t)regs->a[0];
ffffffe000202560:	f2843783          	ld	a5,-216(s0)
ffffffe000202564:	0407b783          	ld	a5,64(a5)
ffffffe000202568:	f6f43823          	sd	a5,-144(s0)
                int64_t ret = sys_close(fd);
ffffffe00020256c:	f7043503          	ld	a0,-144(s0)
ffffffe000202570:	b11ff0ef          	jal	ra,ffffffe000202080 <sys_close>
ffffffe000202574:	f6a43423          	sd	a0,-152(s0)
                regs->a[0] = ret;
ffffffe000202578:	f6843703          	ld	a4,-152(s0)
ffffffe00020257c:	f2843783          	ld	a5,-216(s0)
ffffffe000202580:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe000202584:	0740006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
            }

            case SYS_LSEEK:
            {
                uint64_t fd = (uint64_t)regs->a[0];
ffffffe000202588:	f2843783          	ld	a5,-216(s0)
ffffffe00020258c:	0407b783          	ld	a5,64(a5)
ffffffe000202590:	f8f43823          	sd	a5,-112(s0)
                int64_t offset = (int64_t)regs->a[1];
ffffffe000202594:	f2843783          	ld	a5,-216(s0)
ffffffe000202598:	0487b783          	ld	a5,72(a5)
ffffffe00020259c:	f8f43423          	sd	a5,-120(s0)
                uint64_t whence = (uint64_t)regs->a[2];
ffffffe0002025a0:	f2843783          	ld	a5,-216(s0)
ffffffe0002025a4:	0507b783          	ld	a5,80(a5)
ffffffe0002025a8:	f8f43023          	sd	a5,-128(s0)
                int64_t ret = sys_lseek(fd, offset, whence);
ffffffe0002025ac:	f8043603          	ld	a2,-128(s0)
ffffffe0002025b0:	f8843583          	ld	a1,-120(s0)
ffffffe0002025b4:	f9043503          	ld	a0,-112(s0)
ffffffe0002025b8:	ba1ff0ef          	jal	ra,ffffffe000202158 <sys_lseek>
ffffffe0002025bc:	f6a43c23          	sd	a0,-136(s0)
                regs->a[0] = ret;
ffffffe0002025c0:	f7843703          	ld	a4,-136(s0)
ffffffe0002025c4:	f2843783          	ld	a5,-216(s0)
ffffffe0002025c8:	04e7b023          	sd	a4,64(a5)
                break;
ffffffe0002025cc:	02c0006f          	j	ffffffe0002025f8 <trap_handler+0x2b0>
            }

            default:
                Err("unimplemented syscall_id: %ld\n", syscall_id);
ffffffe0002025d0:	fe843703          	ld	a4,-24(s0)
ffffffe0002025d4:	00005697          	auipc	a3,0x5
ffffffe0002025d8:	05c68693          	addi	a3,a3,92 # ffffffe000207630 <__func__.1>
ffffffe0002025dc:	07c00613          	li	a2,124
ffffffe0002025e0:	00005597          	auipc	a1,0x5
ffffffe0002025e4:	e3858593          	addi	a1,a1,-456 # ffffffe000207418 <__func__.0+0x40>
ffffffe0002025e8:	00005517          	auipc	a0,0x5
ffffffe0002025ec:	e3850513          	addi	a0,a0,-456 # ffffffe000207420 <__func__.0+0x48>
ffffffe0002025f0:	581010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002025f4:	0000006f          	j	ffffffe0002025f4 <trap_handler+0x2ac>
                break;
            }

            regs->sepc += 4;
ffffffe0002025f8:	f2843783          	ld	a5,-216(s0)
ffffffe0002025fc:	0f07b783          	ld	a5,240(a5)
ffffffe000202600:	00478713          	addi	a4,a5,4
ffffffe000202604:	f2843783          	ld	a5,-216(s0)
ffffffe000202608:	0ee7b823          	sd	a4,240(a5)
            return;
ffffffe00020260c:	0600006f          	j	ffffffe00020266c <trap_handler+0x324>
        }
        else if (scause == INST_PAGE_FAULT)
ffffffe000202610:	f3843703          	ld	a4,-200(s0)
ffffffe000202614:	00c00793          	li	a5,12
ffffffe000202618:	00f71863          	bne	a4,a5,ffffffe000202628 <trap_handler+0x2e0>
        {
            // Warning("pc @ %lx, instruction page fault, stval = %lx", sepc, csr_read(stval));
            do_page_fault(regs);
ffffffe00020261c:	f2843503          	ld	a0,-216(s0)
ffffffe000202620:	05c000ef          	jal	ra,ffffffe00020267c <do_page_fault>
ffffffe000202624:	0480006f          	j	ffffffe00020266c <trap_handler+0x324>
        }
        else if (scause == LOAD_PAGE_FAULT)
ffffffe000202628:	f3843703          	ld	a4,-200(s0)
ffffffe00020262c:	00d00793          	li	a5,13
ffffffe000202630:	00f71863          	bne	a4,a5,ffffffe000202640 <trap_handler+0x2f8>
        {
            // Warning("pc @ %lx, load page fault, stval = %lx", sepc, csr_read(stval));
            do_page_fault(regs);
ffffffe000202634:	f2843503          	ld	a0,-216(s0)
ffffffe000202638:	044000ef          	jal	ra,ffffffe00020267c <do_page_fault>
ffffffe00020263c:	0300006f          	j	ffffffe00020266c <trap_handler+0x324>
        }
        else if (scause == STORE_PAGE_FAULT)
ffffffe000202640:	f3843703          	ld	a4,-200(s0)
ffffffe000202644:	00f00793          	li	a5,15
ffffffe000202648:	00f71863          	bne	a4,a5,ffffffe000202658 <trap_handler+0x310>
        {
            // Warning("pc @ %lx, store page fault, stval = %lx", sepc, csr_read(stval));
            do_page_fault(regs);
ffffffe00020264c:	f2843503          	ld	a0,-216(s0)
ffffffe000202650:	02c000ef          	jal	ra,ffffffe00020267c <do_page_fault>
ffffffe000202654:	0180006f          	j	ffffffe00020266c <trap_handler+0x324>
        }
        else
        {
            printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000202658:	f3043603          	ld	a2,-208(s0)
ffffffe00020265c:	f3843583          	ld	a1,-200(s0)
ffffffe000202660:	00005517          	auipc	a0,0x5
ffffffe000202664:	df850513          	addi	a0,a0,-520 # ffffffe000207458 <__func__.0+0x80>
ffffffe000202668:	509010ef          	jal	ra,ffffffe000204370 <printk>
        }
    }
}
ffffffe00020266c:	0d813083          	ld	ra,216(sp)
ffffffe000202670:	0d013403          	ld	s0,208(sp)
ffffffe000202674:	0e010113          	addi	sp,sp,224
ffffffe000202678:	00008067          	ret

ffffffe00020267c <do_page_fault>:

void do_page_fault(struct pt_regs *regs)
{
ffffffe00020267c:	f4010113          	addi	sp,sp,-192
ffffffe000202680:	0a113c23          	sd	ra,184(sp)
ffffffe000202684:	0a813823          	sd	s0,176(sp)
ffffffe000202688:	0c010413          	addi	s0,sp,192
ffffffe00020268c:	f4a43423          	sd	a0,-184(s0)
    uint64_t bad_addr = csr_read(stval);
ffffffe000202690:	143027f3          	csrr	a5,stval
ffffffe000202694:	fef43023          	sd	a5,-32(s0)
ffffffe000202698:	fe043783          	ld	a5,-32(s0)
ffffffe00020269c:	fcf43c23          	sd	a5,-40(s0)
    struct vm_area_struct *vma = find_vma(&(get_current_proc()->mm), bad_addr);
ffffffe0002026a0:	c68fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe0002026a4:	00050793          	mv	a5,a0
ffffffe0002026a8:	0b078793          	addi	a5,a5,176
ffffffe0002026ac:	fd843583          	ld	a1,-40(s0)
ffffffe0002026b0:	00078513          	mv	a0,a5
ffffffe0002026b4:	cc5fe0ef          	jal	ra,ffffffe000201378 <find_vma>
ffffffe0002026b8:	fca43823          	sd	a0,-48(s0)
    if (!vma)
ffffffe0002026bc:	fd043783          	ld	a5,-48(s0)
ffffffe0002026c0:	02079663          	bnez	a5,ffffffe0002026ec <do_page_fault+0x70>
    {
        Err("do_page_fault: cannot find vma, bad_addr = %lx", bad_addr);
ffffffe0002026c4:	fd843703          	ld	a4,-40(s0)
ffffffe0002026c8:	00005697          	auipc	a3,0x5
ffffffe0002026cc:	f7868693          	addi	a3,a3,-136 # ffffffe000207640 <__func__.0>
ffffffe0002026d0:	09f00613          	li	a2,159
ffffffe0002026d4:	00005597          	auipc	a1,0x5
ffffffe0002026d8:	d4458593          	addi	a1,a1,-700 # ffffffe000207418 <__func__.0+0x40>
ffffffe0002026dc:	00005517          	auipc	a0,0x5
ffffffe0002026e0:	dac50513          	addi	a0,a0,-596 # ffffffe000207488 <__func__.0+0xb0>
ffffffe0002026e4:	48d010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002026e8:	0000006f          	j	ffffffe0002026e8 <do_page_fault+0x6c>
    }

    uint64_t scause = csr_read(scause);
ffffffe0002026ec:	142027f3          	csrr	a5,scause
ffffffe0002026f0:	fcf43423          	sd	a5,-56(s0)
ffffffe0002026f4:	fc843783          	ld	a5,-56(s0)
ffffffe0002026f8:	fcf43023          	sd	a5,-64(s0)
    switch (scause)
ffffffe0002026fc:	fc043703          	ld	a4,-64(s0)
ffffffe000202700:	00f00793          	li	a5,15
ffffffe000202704:	08f70e63          	beq	a4,a5,ffffffe0002027a0 <do_page_fault+0x124>
ffffffe000202708:	fc043703          	ld	a4,-64(s0)
ffffffe00020270c:	00f00793          	li	a5,15
ffffffe000202710:	0ce7e463          	bltu	a5,a4,ffffffe0002027d8 <do_page_fault+0x15c>
ffffffe000202714:	fc043703          	ld	a4,-64(s0)
ffffffe000202718:	00c00793          	li	a5,12
ffffffe00020271c:	00f70a63          	beq	a4,a5,ffffffe000202730 <do_page_fault+0xb4>
ffffffe000202720:	fc043703          	ld	a4,-64(s0)
ffffffe000202724:	00d00793          	li	a5,13
ffffffe000202728:	04f70063          	beq	a4,a5,ffffffe000202768 <do_page_fault+0xec>
ffffffe00020272c:	0ac0006f          	j	ffffffe0002027d8 <do_page_fault+0x15c>
    {
    case INST_PAGE_FAULT:
        if (!(vma->vm_flags & VM_EXEC))
ffffffe000202730:	fd043783          	ld	a5,-48(s0)
ffffffe000202734:	0287b783          	ld	a5,40(a5)
ffffffe000202738:	0087f793          	andi	a5,a5,8
ffffffe00020273c:	0c079463          	bnez	a5,ffffffe000202804 <do_page_fault+0x188>
        {
            Err("do_page_fault: instruction page fault, bad_addr = %lx", bad_addr);
ffffffe000202740:	fd843703          	ld	a4,-40(s0)
ffffffe000202744:	00005697          	auipc	a3,0x5
ffffffe000202748:	efc68693          	addi	a3,a3,-260 # ffffffe000207640 <__func__.0>
ffffffe00020274c:	0a800613          	li	a2,168
ffffffe000202750:	00005597          	auipc	a1,0x5
ffffffe000202754:	cc858593          	addi	a1,a1,-824 # ffffffe000207418 <__func__.0+0x40>
ffffffe000202758:	00005517          	auipc	a0,0x5
ffffffe00020275c:	d7850513          	addi	a0,a0,-648 # ffffffe0002074d0 <__func__.0+0xf8>
ffffffe000202760:	411010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000202764:	0000006f          	j	ffffffe000202764 <do_page_fault+0xe8>
        }
        break;

    case LOAD_PAGE_FAULT:
        if (!(vma->vm_flags & VM_READ))
ffffffe000202768:	fd043783          	ld	a5,-48(s0)
ffffffe00020276c:	0287b783          	ld	a5,40(a5)
ffffffe000202770:	0027f793          	andi	a5,a5,2
ffffffe000202774:	08079c63          	bnez	a5,ffffffe00020280c <do_page_fault+0x190>
        {
            Err("do_page_fault: load page fault, bad_addr = %lx", bad_addr);
ffffffe000202778:	fd843703          	ld	a4,-40(s0)
ffffffe00020277c:	00005697          	auipc	a3,0x5
ffffffe000202780:	ec468693          	addi	a3,a3,-316 # ffffffe000207640 <__func__.0>
ffffffe000202784:	0af00613          	li	a2,175
ffffffe000202788:	00005597          	auipc	a1,0x5
ffffffe00020278c:	c9058593          	addi	a1,a1,-880 # ffffffe000207418 <__func__.0+0x40>
ffffffe000202790:	00005517          	auipc	a0,0x5
ffffffe000202794:	d9050513          	addi	a0,a0,-624 # ffffffe000207520 <__func__.0+0x148>
ffffffe000202798:	3d9010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe00020279c:	0000006f          	j	ffffffe00020279c <do_page_fault+0x120>
        }
        break;

    case STORE_PAGE_FAULT:
        if (!(vma->vm_flags & VM_WRITE))
ffffffe0002027a0:	fd043783          	ld	a5,-48(s0)
ffffffe0002027a4:	0287b783          	ld	a5,40(a5)
ffffffe0002027a8:	0047f793          	andi	a5,a5,4
ffffffe0002027ac:	06079463          	bnez	a5,ffffffe000202814 <do_page_fault+0x198>
        {
            Err("do_page_fault: store page fault, bad_addr = %lx", bad_addr);
ffffffe0002027b0:	fd843703          	ld	a4,-40(s0)
ffffffe0002027b4:	00005697          	auipc	a3,0x5
ffffffe0002027b8:	e8c68693          	addi	a3,a3,-372 # ffffffe000207640 <__func__.0>
ffffffe0002027bc:	0b600613          	li	a2,182
ffffffe0002027c0:	00005597          	auipc	a1,0x5
ffffffe0002027c4:	c5858593          	addi	a1,a1,-936 # ffffffe000207418 <__func__.0+0x40>
ffffffe0002027c8:	00005517          	auipc	a0,0x5
ffffffe0002027cc:	da050513          	addi	a0,a0,-608 # ffffffe000207568 <__func__.0+0x190>
ffffffe0002027d0:	3a1010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe0002027d4:	0000006f          	j	ffffffe0002027d4 <do_page_fault+0x158>
        }
        break;

    default:
        Err("do_page_fault: unknown page fault, scause = %d, bad_addr = %lx", scause, bad_addr);
ffffffe0002027d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002027dc:	fc043703          	ld	a4,-64(s0)
ffffffe0002027e0:	00005697          	auipc	a3,0x5
ffffffe0002027e4:	e6068693          	addi	a3,a3,-416 # ffffffe000207640 <__func__.0>
ffffffe0002027e8:	0bb00613          	li	a2,187
ffffffe0002027ec:	00005597          	auipc	a1,0x5
ffffffe0002027f0:	c2c58593          	addi	a1,a1,-980 # ffffffe000207418 <__func__.0+0x40>
ffffffe0002027f4:	00005517          	auipc	a0,0x5
ffffffe0002027f8:	dbc50513          	addi	a0,a0,-580 # ffffffe0002075b0 <__func__.0+0x1d8>
ffffffe0002027fc:	375010ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000202800:	0000006f          	j	ffffffe000202800 <do_page_fault+0x184>
        break;
ffffffe000202804:	00000013          	nop
ffffffe000202808:	0100006f          	j	ffffffe000202818 <do_page_fault+0x19c>
        break;
ffffffe00020280c:	00000013          	nop
ffffffe000202810:	0080006f          	j	ffffffe000202818 <do_page_fault+0x19c>
        break;
ffffffe000202814:	00000013          	nop
        break;
    }

    if (vma->vm_flags & VM_ANON)
ffffffe000202818:	fd043783          	ld	a5,-48(s0)
ffffffe00020281c:	0287b783          	ld	a5,40(a5)
ffffffe000202820:	0017f793          	andi	a5,a5,1
ffffffe000202824:	08078463          	beqz	a5,ffffffe0002028ac <do_page_fault+0x230>
    {
        uint64_t *pg = (uint64_t *)alloc_page();
ffffffe000202828:	938fe0ef          	jal	ra,ffffffe000200960 <alloc_page>
ffffffe00020282c:	f6a43823          	sd	a0,-144(s0)
        uint64_t pa_s = VA2PA(pg);
ffffffe000202830:	f7043703          	ld	a4,-144(s0)
ffffffe000202834:	04100793          	li	a5,65
ffffffe000202838:	01f79793          	slli	a5,a5,0x1f
ffffffe00020283c:	00f707b3          	add	a5,a4,a5
ffffffe000202840:	f6f43423          	sd	a5,-152(s0)
        memset((void *)pg, 0, PGSIZE);
ffffffe000202844:	00001637          	lui	a2,0x1
ffffffe000202848:	00000593          	li	a1,0
ffffffe00020284c:	f7043503          	ld	a0,-144(s0)
ffffffe000202850:	441010ef          	jal	ra,ffffffe000204490 <memset>
        uint64_t va_s = PGROUNDDOWN(bad_addr);
ffffffe000202854:	fd843703          	ld	a4,-40(s0)
ffffffe000202858:	fffff7b7          	lui	a5,0xfffff
ffffffe00020285c:	00f777b3          	and	a5,a4,a5
ffffffe000202860:	f6f43023          	sd	a5,-160(s0)
        uint64_t *pgtbl = get_current_proc()->pgd;
ffffffe000202864:	aa4fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe000202868:	00050793          	mv	a5,a0
ffffffe00020286c:	0a87b783          	ld	a5,168(a5) # fffffffffffff0a8 <VM_END+0xfffff0a8>
ffffffe000202870:	f4f43c23          	sd	a5,-168(s0)
        uint64_t perm = vmflags2pte(vma->vm_flags) | PTE_V | PTE_U;
ffffffe000202874:	fd043783          	ld	a5,-48(s0)
ffffffe000202878:	0287b783          	ld	a5,40(a5)
ffffffe00020287c:	00078513          	mv	a0,a5
ffffffe000202880:	5bc000ef          	jal	ra,ffffffe000202e3c <vmflags2pte>
ffffffe000202884:	00050793          	mv	a5,a0
ffffffe000202888:	0117e793          	ori	a5,a5,17
ffffffe00020288c:	f4f43823          	sd	a5,-176(s0)
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
ffffffe000202890:	f5043703          	ld	a4,-176(s0)
ffffffe000202894:	000016b7          	lui	a3,0x1
ffffffe000202898:	f6843603          	ld	a2,-152(s0)
ffffffe00020289c:	f6043583          	ld	a1,-160(s0)
ffffffe0002028a0:	f5843503          	ld	a0,-168(s0)
ffffffe0002028a4:	5c4000ef          	jal	ra,ffffffe000202e68 <create_mapping>
        }
        uint64_t va_s = PGROUNDDOWN(bad_addr); // 映射的起点 与物理页做映射
        uint64_t pa_s = VA2PA(pg);
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
    }
ffffffe0002028a8:	1280006f          	j	ffffffe0002029d0 <do_page_fault+0x354>
        uint64_t perm = vmflags2pte(vma->vm_flags) | PTE_V | PTE_U;
ffffffe0002028ac:	fd043783          	ld	a5,-48(s0)
ffffffe0002028b0:	0287b783          	ld	a5,40(a5)
ffffffe0002028b4:	00078513          	mv	a0,a5
ffffffe0002028b8:	584000ef          	jal	ra,ffffffe000202e3c <vmflags2pte>
ffffffe0002028bc:	00050793          	mv	a5,a0
ffffffe0002028c0:	0117e793          	ori	a5,a5,17
ffffffe0002028c4:	faf43c23          	sd	a5,-72(s0)
        uint64_t *pgtbl = get_current_proc()->pgd;
ffffffe0002028c8:	a40fe0ef          	jal	ra,ffffffe000200b08 <get_current_proc>
ffffffe0002028cc:	00050793          	mv	a5,a0
ffffffe0002028d0:	0a87b783          	ld	a5,168(a5)
ffffffe0002028d4:	faf43823          	sd	a5,-80(s0)
        uint64_t file_start = (uint64_t)_sramdisk + vma->vm_pgoff;
ffffffe0002028d8:	fd043783          	ld	a5,-48(s0)
ffffffe0002028dc:	0307b703          	ld	a4,48(a5)
ffffffe0002028e0:	00006797          	auipc	a5,0x6
ffffffe0002028e4:	72078793          	addi	a5,a5,1824 # ffffffe000209000 <_sramdisk>
ffffffe0002028e8:	00f707b3          	add	a5,a4,a5
ffffffe0002028ec:	faf43423          	sd	a5,-88(s0)
        uint64_t file_end = file_start + vma->vm_filesz;
ffffffe0002028f0:	fd043783          	ld	a5,-48(s0)
ffffffe0002028f4:	0387b783          	ld	a5,56(a5)
ffffffe0002028f8:	fa843703          	ld	a4,-88(s0)
ffffffe0002028fc:	00f707b3          	add	a5,a4,a5
ffffffe000202900:	faf43023          	sd	a5,-96(s0)
        uint64_t offset = bad_addr - vma->vm_start;
ffffffe000202904:	fd043783          	ld	a5,-48(s0)
ffffffe000202908:	0087b783          	ld	a5,8(a5)
ffffffe00020290c:	fd843703          	ld	a4,-40(s0)
ffffffe000202910:	40f707b3          	sub	a5,a4,a5
ffffffe000202914:	f8f43c23          	sd	a5,-104(s0)
        uint64_t file_page_start = PGROUNDDOWN(file_start + offset); // 文件一页的起点 拷贝到分配的物理页
ffffffe000202918:	fa843703          	ld	a4,-88(s0)
ffffffe00020291c:	f9843783          	ld	a5,-104(s0)
ffffffe000202920:	00f70733          	add	a4,a4,a5
ffffffe000202924:	fffff7b7          	lui	a5,0xfffff
ffffffe000202928:	00f777b3          	and	a5,a4,a5
ffffffe00020292c:	f8f43823          	sd	a5,-112(s0)
        uint64_t *pg = (uint64_t *)alloc_page();
ffffffe000202930:	830fe0ef          	jal	ra,ffffffe000200960 <alloc_page>
ffffffe000202934:	f8a43423          	sd	a0,-120(s0)
        memset((void *)pg, 0, PGSIZE);
ffffffe000202938:	00001637          	lui	a2,0x1
ffffffe00020293c:	00000593          	li	a1,0
ffffffe000202940:	f8843503          	ld	a0,-120(s0)
ffffffe000202944:	34d010ef          	jal	ra,ffffffe000204490 <memset>
        if (file_page_start < file_end)
ffffffe000202948:	f9043703          	ld	a4,-112(s0)
ffffffe00020294c:	fa043783          	ld	a5,-96(s0)
ffffffe000202950:	04f77263          	bgeu	a4,a5,ffffffe000202994 <do_page_fault+0x318>
            uint64_t sz = PGSIZE;
ffffffe000202954:	000017b7          	lui	a5,0x1
ffffffe000202958:	fef43423          	sd	a5,-24(s0)
            if (file_page_start + sz > file_end)
ffffffe00020295c:	f9043703          	ld	a4,-112(s0)
ffffffe000202960:	fe843783          	ld	a5,-24(s0)
ffffffe000202964:	00f707b3          	add	a5,a4,a5
ffffffe000202968:	fa043703          	ld	a4,-96(s0)
ffffffe00020296c:	00f77a63          	bgeu	a4,a5,ffffffe000202980 <do_page_fault+0x304>
                sz = file_end - file_page_start;
ffffffe000202970:	fa043703          	ld	a4,-96(s0)
ffffffe000202974:	f9043783          	ld	a5,-112(s0)
ffffffe000202978:	40f707b3          	sub	a5,a4,a5
ffffffe00020297c:	fef43423          	sd	a5,-24(s0)
            memcpy((void *)pg, (void *)file_page_start, sz);
ffffffe000202980:	f9043783          	ld	a5,-112(s0)
ffffffe000202984:	fe843603          	ld	a2,-24(s0)
ffffffe000202988:	00078593          	mv	a1,a5
ffffffe00020298c:	f8843503          	ld	a0,-120(s0)
ffffffe000202990:	371010ef          	jal	ra,ffffffe000204500 <memcpy>
        uint64_t va_s = PGROUNDDOWN(bad_addr); // 映射的起点 与物理页做映射
ffffffe000202994:	fd843703          	ld	a4,-40(s0)
ffffffe000202998:	fffff7b7          	lui	a5,0xfffff
ffffffe00020299c:	00f777b3          	and	a5,a4,a5
ffffffe0002029a0:	f8f43023          	sd	a5,-128(s0)
        uint64_t pa_s = VA2PA(pg);
ffffffe0002029a4:	f8843703          	ld	a4,-120(s0)
ffffffe0002029a8:	04100793          	li	a5,65
ffffffe0002029ac:	01f79793          	slli	a5,a5,0x1f
ffffffe0002029b0:	00f707b3          	add	a5,a4,a5
ffffffe0002029b4:	f6f43c23          	sd	a5,-136(s0)
        create_mapping(pgtbl, va_s, pa_s, PGSIZE, perm);
ffffffe0002029b8:	fb843703          	ld	a4,-72(s0)
ffffffe0002029bc:	000016b7          	lui	a3,0x1
ffffffe0002029c0:	f7843603          	ld	a2,-136(s0)
ffffffe0002029c4:	f8043583          	ld	a1,-128(s0)
ffffffe0002029c8:	fb043503          	ld	a0,-80(s0)
ffffffe0002029cc:	49c000ef          	jal	ra,ffffffe000202e68 <create_mapping>
ffffffe0002029d0:	00000013          	nop
ffffffe0002029d4:	0b813083          	ld	ra,184(sp)
ffffffe0002029d8:	0b013403          	ld	s0,176(sp)
ffffffe0002029dc:	0c010113          	addi	sp,sp,192
ffffffe0002029e0:	00008067          	ret

ffffffe0002029e4 <io_to_virt>:

static inline void memory_barrier() {
    asm volatile ("fence rw, rw"); // Full memory fence for both read and write
}

static inline uint64_t io_to_virt(uint64_t pa) {
ffffffe0002029e4:	fe010113          	addi	sp,sp,-32
ffffffe0002029e8:	00813c23          	sd	s0,24(sp)
ffffffe0002029ec:	02010413          	addi	s0,sp,32
ffffffe0002029f0:	fea43423          	sd	a0,-24(s0)
    return pa + IOMAP_OFFSET;
ffffffe0002029f4:	fe843703          	ld	a4,-24(s0)
ffffffe0002029f8:	ff900793          	li	a5,-7
ffffffe0002029fc:	02379793          	slli	a5,a5,0x23
ffffffe000202a00:	00f707b3          	add	a5,a4,a5
}
ffffffe000202a04:	00078513          	mv	a0,a5
ffffffe000202a08:	01813403          	ld	s0,24(sp)
ffffffe000202a0c:	02010113          	addi	sp,sp,32
ffffffe000202a10:	00008067          	ret

ffffffe000202a14 <setup_vm>:
#include "virtio.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe000202a14:	fe010113          	addi	sp,sp,-32
ffffffe000202a18:	00113c23          	sd	ra,24(sp)
ffffffe000202a1c:	00813823          	sd	s0,16(sp)
ffffffe000202a20:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe000202a24:	00001637          	lui	a2,0x1
ffffffe000202a28:	00000593          	li	a1,0
ffffffe000202a2c:	0000b517          	auipc	a0,0xb
ffffffe000202a30:	5d450513          	addi	a0,a0,1492 # ffffffe00020e000 <early_pgtbl>
ffffffe000202a34:	25d010ef          	jal	ra,ffffffe000204490 <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000202a38:	00f00793          	li	a5,15
ffffffe000202a3c:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000202a40:	fe043423          	sd	zero,-24(s0)
ffffffe000202a44:	0740006f          	j	ffffffe000202ab8 <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000202a48:	fe843703          	ld	a4,-24(s0)
ffffffe000202a4c:	fff00793          	li	a5,-1
ffffffe000202a50:	02579793          	slli	a5,a5,0x25
ffffffe000202a54:	00f706b3          	add	a3,a4,a5
ffffffe000202a58:	fe843703          	ld	a4,-24(s0)
ffffffe000202a5c:	00100793          	li	a5,1
ffffffe000202a60:	01f79793          	slli	a5,a5,0x1f
ffffffe000202a64:	00f707b3          	add	a5,a4,a5
ffffffe000202a68:	fe043603          	ld	a2,-32(s0)
ffffffe000202a6c:	00078593          	mv	a1,a5
ffffffe000202a70:	00068513          	mv	a0,a3
ffffffe000202a74:	074000ef          	jal	ra,ffffffe000202ae8 <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe000202a78:	fe843703          	ld	a4,-24(s0)
ffffffe000202a7c:	00100793          	li	a5,1
ffffffe000202a80:	01f79793          	slli	a5,a5,0x1f
ffffffe000202a84:	00f706b3          	add	a3,a4,a5
ffffffe000202a88:	fe843703          	ld	a4,-24(s0)
ffffffe000202a8c:	00100793          	li	a5,1
ffffffe000202a90:	01f79793          	slli	a5,a5,0x1f
ffffffe000202a94:	00f707b3          	add	a5,a4,a5
ffffffe000202a98:	fe043603          	ld	a2,-32(s0)
ffffffe000202a9c:	00078593          	mv	a1,a5
ffffffe000202aa0:	00068513          	mv	a0,a3
ffffffe000202aa4:	044000ef          	jal	ra,ffffffe000202ae8 <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000202aa8:	fe843703          	ld	a4,-24(s0)
ffffffe000202aac:	400007b7          	lui	a5,0x40000
ffffffe000202ab0:	00f707b3          	add	a5,a4,a5
ffffffe000202ab4:	fef43423          	sd	a5,-24(s0)
ffffffe000202ab8:	fe843703          	ld	a4,-24(s0)
ffffffe000202abc:	01f00793          	li	a5,31
ffffffe000202ac0:	02079793          	slli	a5,a5,0x20
ffffffe000202ac4:	f8f762e3          	bltu	a4,a5,ffffffe000202a48 <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe000202ac8:	00005517          	auipc	a0,0x5
ffffffe000202acc:	b8850513          	addi	a0,a0,-1144 # ffffffe000207650 <__func__.0+0x10>
ffffffe000202ad0:	0a1010ef          	jal	ra,ffffffe000204370 <printk>
    return;
ffffffe000202ad4:	00000013          	nop
}
ffffffe000202ad8:	01813083          	ld	ra,24(sp)
ffffffe000202adc:	01013403          	ld	s0,16(sp)
ffffffe000202ae0:	02010113          	addi	sp,sp,32
ffffffe000202ae4:	00008067          	ret

ffffffe000202ae8 <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000202ae8:	fc010113          	addi	sp,sp,-64
ffffffe000202aec:	02813c23          	sd	s0,56(sp)
ffffffe000202af0:	04010413          	addi	s0,sp,64
ffffffe000202af4:	fca43c23          	sd	a0,-40(s0)
ffffffe000202af8:	fcb43823          	sd	a1,-48(s0)
ffffffe000202afc:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000202b00:	fd843783          	ld	a5,-40(s0)
ffffffe000202b04:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202b08:	1ff7f793          	andi	a5,a5,511
ffffffe000202b0c:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000202b10:	fd043783          	ld	a5,-48(s0)
ffffffe000202b14:	00c7d793          	srli	a5,a5,0xc
ffffffe000202b18:	00a79793          	slli	a5,a5,0xa
ffffffe000202b1c:	fc843703          	ld	a4,-56(s0)
ffffffe000202b20:	00f767b3          	or	a5,a4,a5
ffffffe000202b24:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000202b28:	0000b717          	auipc	a4,0xb
ffffffe000202b2c:	4d870713          	addi	a4,a4,1240 # ffffffe00020e000 <early_pgtbl>
ffffffe000202b30:	fe843783          	ld	a5,-24(s0)
ffffffe000202b34:	00379793          	slli	a5,a5,0x3
ffffffe000202b38:	00f707b3          	add	a5,a4,a5
ffffffe000202b3c:	fe043703          	ld	a4,-32(s0)
ffffffe000202b40:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe000202b44:	00000013          	nop
ffffffe000202b48:	03813403          	ld	s0,56(sp)
ffffffe000202b4c:	04010113          	addi	sp,sp,64
ffffffe000202b50:	00008067          	ret

ffffffe000202b54 <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe000202b54:	fc010113          	addi	sp,sp,-64
ffffffe000202b58:	02113c23          	sd	ra,56(sp)
ffffffe000202b5c:	02813823          	sd	s0,48(sp)
ffffffe000202b60:	04010413          	addi	s0,sp,64
ffffffe000202b64:	fca43c23          	sd	a0,-40(s0)
ffffffe000202b68:	fcb43823          	sd	a1,-48(s0)
ffffffe000202b6c:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000202b70:	e65fd0ef          	jal	ra,ffffffe0002009d4 <kalloc>
ffffffe000202b74:	00050793          	mv	a5,a0
ffffffe000202b78:	00078713          	mv	a4,a5
ffffffe000202b7c:	04100793          	li	a5,65
ffffffe000202b80:	01f79793          	slli	a5,a5,0x1f
ffffffe000202b84:	00f707b3          	add	a5,a4,a5
ffffffe000202b88:	fef43423          	sd	a5,-24(s0)
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000202b8c:	fe843783          	ld	a5,-24(s0)
ffffffe000202b90:	00c7d793          	srli	a5,a5,0xc
ffffffe000202b94:	00a79693          	slli	a3,a5,0xa
ffffffe000202b98:	fd043783          	ld	a5,-48(s0)
ffffffe000202b9c:	00379793          	slli	a5,a5,0x3
ffffffe000202ba0:	fd843703          	ld	a4,-40(s0)
ffffffe000202ba4:	00f707b3          	add	a5,a4,a5
ffffffe000202ba8:	fc843703          	ld	a4,-56(s0)
ffffffe000202bac:	00e6e733          	or	a4,a3,a4
ffffffe000202bb0:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe000202bb4:	fd043783          	ld	a5,-48(s0)
ffffffe000202bb8:	00379793          	slli	a5,a5,0x3
ffffffe000202bbc:	fd843703          	ld	a4,-40(s0)
ffffffe000202bc0:	00f707b3          	add	a5,a4,a5
ffffffe000202bc4:	0007b783          	ld	a5,0(a5)
}
ffffffe000202bc8:	00078513          	mv	a0,a5
ffffffe000202bcc:	03813083          	ld	ra,56(sp)
ffffffe000202bd0:	03013403          	ld	s0,48(sp)
ffffffe000202bd4:	04010113          	addi	sp,sp,64
ffffffe000202bd8:	00008067          	ret

ffffffe000202bdc <setup_vm_final>:

void setup_vm_final() {
ffffffe000202bdc:	f9010113          	addi	sp,sp,-112
ffffffe000202be0:	06113423          	sd	ra,104(sp)
ffffffe000202be4:	06813023          	sd	s0,96(sp)
ffffffe000202be8:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe000202bec:	00005517          	auipc	a0,0x5
ffffffe000202bf0:	a7c50513          	addi	a0,a0,-1412 # ffffffe000207668 <__func__.0+0x28>
ffffffe000202bf4:	77c010ef          	jal	ra,ffffffe000204370 <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000202bf8:	00001637          	lui	a2,0x1
ffffffe000202bfc:	00000593          	li	a1,0
ffffffe000202c00:	0000c517          	auipc	a0,0xc
ffffffe000202c04:	40050513          	addi	a0,a0,1024 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000202c08:	089010ef          	jal	ra,ffffffe000204490 <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000202c0c:	40100793          	li	a5,1025
ffffffe000202c10:	01579793          	slli	a5,a5,0x15
ffffffe000202c14:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000202c18:	f00017b7          	lui	a5,0xf0001
ffffffe000202c1c:	00979793          	slli	a5,a5,0x9
ffffffe000202c20:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe000202c24:	01100793          	li	a5,17
ffffffe000202c28:	01b79793          	slli	a5,a5,0x1b
ffffffe000202c2c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000202c30:	c0100793          	li	a5,-1023
ffffffe000202c34:	01b79793          	slli	a5,a5,0x1b
ffffffe000202c38:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000202c3c:	fe043783          	ld	a5,-32(s0)
ffffffe000202c40:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe000202c44:	00004717          	auipc	a4,0x4
ffffffe000202c48:	a8070713          	addi	a4,a4,-1408 # ffffffe0002066c4 <_etext>
ffffffe000202c4c:	000017b7          	lui	a5,0x1
ffffffe000202c50:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000202c54:	00f70733          	add	a4,a4,a5
ffffffe000202c58:	fffff7b7          	lui	a5,0xfffff
ffffffe000202c5c:	00f777b3          	and	a5,a4,a5
ffffffe000202c60:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe000202c64:	fc843703          	ld	a4,-56(s0)
ffffffe000202c68:	04100793          	li	a5,65
ffffffe000202c6c:	01f79793          	slli	a5,a5,0x1f
ffffffe000202c70:	00f70633          	add	a2,a4,a5
ffffffe000202c74:	fc043703          	ld	a4,-64(s0)
ffffffe000202c78:	fc843783          	ld	a5,-56(s0)
ffffffe000202c7c:	40f707b3          	sub	a5,a4,a5
ffffffe000202c80:	00b00713          	li	a4,11
ffffffe000202c84:	00078693          	mv	a3,a5
ffffffe000202c88:	fc843583          	ld	a1,-56(s0)
ffffffe000202c8c:	0000c517          	auipc	a0,0xc
ffffffe000202c90:	37450513          	addi	a0,a0,884 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000202c94:	1d4000ef          	jal	ra,ffffffe000202e68 <create_mapping>
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);
ffffffe000202c98:	00b00693          	li	a3,11
ffffffe000202c9c:	fc043603          	ld	a2,-64(s0)
ffffffe000202ca0:	fc843583          	ld	a1,-56(s0)
ffffffe000202ca4:	00005517          	auipc	a0,0x5
ffffffe000202ca8:	9dc50513          	addi	a0,a0,-1572 # ffffffe000207680 <__func__.0+0x40>
ffffffe000202cac:	6c4010ef          	jal	ra,ffffffe000204370 <printk>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe000202cb0:	fc043783          	ld	a5,-64(s0)
ffffffe000202cb4:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe000202cb8:	00005717          	auipc	a4,0x5
ffffffe000202cbc:	11070713          	addi	a4,a4,272 # ffffffe000207dc8 <_erodata>
ffffffe000202cc0:	000017b7          	lui	a5,0x1
ffffffe000202cc4:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000202cc8:	00f70733          	add	a4,a4,a5
ffffffe000202ccc:	fffff7b7          	lui	a5,0xfffff
ffffffe000202cd0:	00f777b3          	and	a5,a4,a5
ffffffe000202cd4:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe000202cd8:	fb843703          	ld	a4,-72(s0)
ffffffe000202cdc:	04100793          	li	a5,65
ffffffe000202ce0:	01f79793          	slli	a5,a5,0x1f
ffffffe000202ce4:	00f70633          	add	a2,a4,a5
ffffffe000202ce8:	fb043703          	ld	a4,-80(s0)
ffffffe000202cec:	fb843783          	ld	a5,-72(s0)
ffffffe000202cf0:	40f707b3          	sub	a5,a4,a5
ffffffe000202cf4:	00300713          	li	a4,3
ffffffe000202cf8:	00078693          	mv	a3,a5
ffffffe000202cfc:	fb843583          	ld	a1,-72(s0)
ffffffe000202d00:	0000c517          	auipc	a0,0xc
ffffffe000202d04:	30050513          	addi	a0,a0,768 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000202d08:	160000ef          	jal	ra,ffffffe000202e68 <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);
ffffffe000202d0c:	00300693          	li	a3,3
ffffffe000202d10:	fb043603          	ld	a2,-80(s0)
ffffffe000202d14:	fb843583          	ld	a1,-72(s0)
ffffffe000202d18:	00005517          	auipc	a0,0x5
ffffffe000202d1c:	9a050513          	addi	a0,a0,-1632 # ffffffe0002076b8 <__func__.0+0x78>
ffffffe000202d20:	650010ef          	jal	ra,ffffffe000204370 <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe000202d24:	fb043783          	ld	a5,-80(s0)
ffffffe000202d28:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe000202d2c:	fd043783          	ld	a5,-48(s0)
ffffffe000202d30:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe000202d34:	fa843703          	ld	a4,-88(s0)
ffffffe000202d38:	04100793          	li	a5,65
ffffffe000202d3c:	01f79793          	slli	a5,a5,0x1f
ffffffe000202d40:	00f70633          	add	a2,a4,a5
ffffffe000202d44:	fa043703          	ld	a4,-96(s0)
ffffffe000202d48:	fa843783          	ld	a5,-88(s0)
ffffffe000202d4c:	40f707b3          	sub	a5,a4,a5
ffffffe000202d50:	00700713          	li	a4,7
ffffffe000202d54:	00078693          	mv	a3,a5
ffffffe000202d58:	fa843583          	ld	a1,-88(s0)
ffffffe000202d5c:	0000c517          	auipc	a0,0xc
ffffffe000202d60:	2a450513          	addi	a0,a0,676 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000202d64:	104000ef          	jal	ra,ffffffe000202e68 <create_mapping>
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);
ffffffe000202d68:	00700693          	li	a3,7
ffffffe000202d6c:	fa043603          	ld	a2,-96(s0)
ffffffe000202d70:	fa843583          	ld	a1,-88(s0)
ffffffe000202d74:	00005517          	auipc	a0,0x5
ffffffe000202d78:	97c50513          	addi	a0,a0,-1668 # ffffffe0002076f0 <__func__.0+0xb0>
ffffffe000202d7c:	5f4010ef          	jal	ra,ffffffe000204370 <printk>

    // lab6
    create_mapping(swapper_pg_dir, io_to_virt(VIRTIO_START), VIRTIO_START, VIRTIO_SIZE * VIRTIO_COUNT, PTE_W | PTE_R | PTE_V);
ffffffe000202d80:	10001537          	lui	a0,0x10001
ffffffe000202d84:	c61ff0ef          	jal	ra,ffffffe0002029e4 <io_to_virt>
ffffffe000202d88:	00050793          	mv	a5,a0
ffffffe000202d8c:	00700713          	li	a4,7
ffffffe000202d90:	000086b7          	lui	a3,0x8
ffffffe000202d94:	10001637          	lui	a2,0x10001
ffffffe000202d98:	00078593          	mv	a1,a5
ffffffe000202d9c:	0000c517          	auipc	a0,0xc
ffffffe000202da0:	26450513          	addi	a0,a0,612 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000202da4:	0c4000ef          	jal	ra,ffffffe000202e68 <create_mapping>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000202da8:	0000c517          	auipc	a0,0xc
ffffffe000202dac:	25850513          	addi	a0,a0,600 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000202db0:	044000ef          	jal	ra,ffffffe000202df4 <get_satp>
ffffffe000202db4:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000202db8:	f9843783          	ld	a5,-104(s0)
ffffffe000202dbc:	f8f43823          	sd	a5,-112(s0)
ffffffe000202dc0:	f9043783          	ld	a5,-112(s0)
ffffffe000202dc4:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe000202dc8:	f9843583          	ld	a1,-104(s0)
ffffffe000202dcc:	00005517          	auipc	a0,0x5
ffffffe000202dd0:	95450513          	addi	a0,a0,-1708 # ffffffe000207720 <__func__.0+0xe0>
ffffffe000202dd4:	59c010ef          	jal	ra,ffffffe000204370 <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000202dd8:	12000073          	sfence.vma

    // flush icache
    asm volatile("fence.i");
ffffffe000202ddc:	0000100f          	fence.i
    return;
ffffffe000202de0:	00000013          	nop
}
ffffffe000202de4:	06813083          	ld	ra,104(sp)
ffffffe000202de8:	06013403          	ld	s0,96(sp)
ffffffe000202dec:	07010113          	addi	sp,sp,112
ffffffe000202df0:	00008067          	ret

ffffffe000202df4 <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe000202df4:	fd010113          	addi	sp,sp,-48
ffffffe000202df8:	02813423          	sd	s0,40(sp)
ffffffe000202dfc:	03010413          	addi	s0,sp,48
ffffffe000202e00:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe000202e04:	fd843703          	ld	a4,-40(s0)
ffffffe000202e08:	04100793          	li	a5,65
ffffffe000202e0c:	01f79793          	slli	a5,a5,0x1f
ffffffe000202e10:	00f707b3          	add	a5,a4,a5
ffffffe000202e14:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe000202e18:	fe843783          	ld	a5,-24(s0)
ffffffe000202e1c:	00c7d713          	srli	a4,a5,0xc
ffffffe000202e20:	fff00793          	li	a5,-1
ffffffe000202e24:	03f79793          	slli	a5,a5,0x3f
ffffffe000202e28:	00f767b3          	or	a5,a4,a5
}
ffffffe000202e2c:	00078513          	mv	a0,a5
ffffffe000202e30:	02813403          	ld	s0,40(sp)
ffffffe000202e34:	03010113          	addi	sp,sp,48
ffffffe000202e38:	00008067          	ret

ffffffe000202e3c <vmflags2pte>:

uint64_t vmflags2pte(uint64_t vm_flags){
ffffffe000202e3c:	fe010113          	addi	sp,sp,-32
ffffffe000202e40:	00813c23          	sd	s0,24(sp)
ffffffe000202e44:	02010413          	addi	s0,sp,32
ffffffe000202e48:	fea43423          	sd	a0,-24(s0)
    return ((vm_flags & VM_READ) ? PTE_R : 0) | ((vm_flags & VM_WRITE) ? PTE_W : 0) | ((vm_flags & VM_EXEC) ? PTE_X : 0);
ffffffe000202e4c:	fe843783          	ld	a5,-24(s0)
ffffffe000202e50:	0007879b          	sext.w	a5,a5
ffffffe000202e54:	00e7f793          	andi	a5,a5,14
}
ffffffe000202e58:	00078513          	mv	a0,a5
ffffffe000202e5c:	01813403          	ld	s0,24(sp)
ffffffe000202e60:	02010113          	addi	sp,sp,32
ffffffe000202e64:	00008067          	ret

ffffffe000202e68 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000202e68:	fb010113          	addi	sp,sp,-80
ffffffe000202e6c:	04113423          	sd	ra,72(sp)
ffffffe000202e70:	04813023          	sd	s0,64(sp)
ffffffe000202e74:	05010413          	addi	s0,sp,80
ffffffe000202e78:	fca43c23          	sd	a0,-40(s0)
ffffffe000202e7c:	fcb43823          	sd	a1,-48(s0)
ffffffe000202e80:	fcc43423          	sd	a2,-56(s0)
ffffffe000202e84:	fcd43023          	sd	a3,-64(s0)
ffffffe000202e88:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe000202e8c:	fc043683          	ld	a3,-64(s0)
ffffffe000202e90:	fc843603          	ld	a2,-56(s0)
ffffffe000202e94:	fd043583          	ld	a1,-48(s0)
ffffffe000202e98:	00005517          	auipc	a0,0x5
ffffffe000202e9c:	89850513          	addi	a0,a0,-1896 # ffffffe000207730 <__func__.0+0xf0>
ffffffe000202ea0:	4d0010ef          	jal	ra,ffffffe000204370 <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000202ea4:	fd043783          	ld	a5,-48(s0)
ffffffe000202ea8:	fef43423          	sd	a5,-24(s0)
ffffffe000202eac:	fc843783          	ld	a5,-56(s0)
ffffffe000202eb0:	fef43023          	sd	a5,-32(s0)
ffffffe000202eb4:	0380006f          	j	ffffffe000202eec <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe000202eb8:	fb843683          	ld	a3,-72(s0)
ffffffe000202ebc:	fe043603          	ld	a2,-32(s0)
ffffffe000202ec0:	fe843583          	ld	a1,-24(s0)
ffffffe000202ec4:	fd843503          	ld	a0,-40(s0)
ffffffe000202ec8:	050000ef          	jal	ra,ffffffe000202f18 <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000202ecc:	fe843703          	ld	a4,-24(s0)
ffffffe000202ed0:	000017b7          	lui	a5,0x1
ffffffe000202ed4:	00f707b3          	add	a5,a4,a5
ffffffe000202ed8:	fef43423          	sd	a5,-24(s0)
ffffffe000202edc:	fe043703          	ld	a4,-32(s0)
ffffffe000202ee0:	000017b7          	lui	a5,0x1
ffffffe000202ee4:	00f707b3          	add	a5,a4,a5
ffffffe000202ee8:	fef43023          	sd	a5,-32(s0)
ffffffe000202eec:	fd043703          	ld	a4,-48(s0)
ffffffe000202ef0:	fc043783          	ld	a5,-64(s0)
ffffffe000202ef4:	00f707b3          	add	a5,a4,a5
ffffffe000202ef8:	fe843703          	ld	a4,-24(s0)
ffffffe000202efc:	faf76ee3          	bltu	a4,a5,ffffffe000202eb8 <create_mapping+0x50>
   }
}
ffffffe000202f00:	00000013          	nop
ffffffe000202f04:	00000013          	nop
ffffffe000202f08:	04813083          	ld	ra,72(sp)
ffffffe000202f0c:	04013403          	ld	s0,64(sp)
ffffffe000202f10:	05010113          	addi	sp,sp,80
ffffffe000202f14:	00008067          	ret

ffffffe000202f18 <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000202f18:	f9010113          	addi	sp,sp,-112
ffffffe000202f1c:	06113423          	sd	ra,104(sp)
ffffffe000202f20:	06813023          	sd	s0,96(sp)
ffffffe000202f24:	07010413          	addi	s0,sp,112
ffffffe000202f28:	faa43423          	sd	a0,-88(s0)
ffffffe000202f2c:	fab43023          	sd	a1,-96(s0)
ffffffe000202f30:	f8c43c23          	sd	a2,-104(s0)
ffffffe000202f34:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000202f38:	fa043783          	ld	a5,-96(s0)
ffffffe000202f3c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202f40:	1ff7f793          	andi	a5,a5,511
ffffffe000202f44:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000202f48:	fa043783          	ld	a5,-96(s0)
ffffffe000202f4c:	0157d793          	srli	a5,a5,0x15
ffffffe000202f50:	1ff7f793          	andi	a5,a5,511
ffffffe000202f54:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000202f58:	fa043783          	ld	a5,-96(s0)
ffffffe000202f5c:	00c7d793          	srli	a5,a5,0xc
ffffffe000202f60:	1ff7f793          	andi	a5,a5,511
ffffffe000202f64:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe000202f68:	fd843783          	ld	a5,-40(s0)
ffffffe000202f6c:	00379793          	slli	a5,a5,0x3
ffffffe000202f70:	fa843703          	ld	a4,-88(s0)
ffffffe000202f74:	00f707b3          	add	a5,a4,a5
ffffffe000202f78:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe000202f7c:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe000202f80:	fe843783          	ld	a5,-24(s0)
ffffffe000202f84:	0017f793          	andi	a5,a5,1
ffffffe000202f88:	00079c63          	bnez	a5,ffffffe000202fa0 <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe000202f8c:	00100613          	li	a2,1
ffffffe000202f90:	fd843583          	ld	a1,-40(s0)
ffffffe000202f94:	fa843503          	ld	a0,-88(s0)
ffffffe000202f98:	bbdff0ef          	jal	ra,ffffffe000202b54 <setup_pgtbl>
ffffffe000202f9c:	fea43423          	sd	a0,-24(s0)
    }
    // printk("pte1 = %lx\n", pte);

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET); // VA
ffffffe000202fa0:	fe843783          	ld	a5,-24(s0)
ffffffe000202fa4:	00a7d793          	srli	a5,a5,0xa
ffffffe000202fa8:	00c79713          	slli	a4,a5,0xc
ffffffe000202fac:	fbf00793          	li	a5,-65
ffffffe000202fb0:	01f79793          	slli	a5,a5,0x1f
ffffffe000202fb4:	00f707b3          	add	a5,a4,a5
ffffffe000202fb8:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe000202fbc:	fd043783          	ld	a5,-48(s0)
ffffffe000202fc0:	00379793          	slli	a5,a5,0x3
ffffffe000202fc4:	fc043703          	ld	a4,-64(s0)
ffffffe000202fc8:	00f707b3          	add	a5,a4,a5
ffffffe000202fcc:	0007b783          	ld	a5,0(a5)
ffffffe000202fd0:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe000202fd4:	fe043783          	ld	a5,-32(s0)
ffffffe000202fd8:	0017f793          	andi	a5,a5,1
ffffffe000202fdc:	00079c63          	bnez	a5,ffffffe000202ff4 <map_vm_final+0xdc>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe000202fe0:	00100613          	li	a2,1
ffffffe000202fe4:	fd043583          	ld	a1,-48(s0)
ffffffe000202fe8:	fc043503          	ld	a0,-64(s0)
ffffffe000202fec:	b69ff0ef          	jal	ra,ffffffe000202b54 <setup_pgtbl>
ffffffe000202ff0:	fea43023          	sd	a0,-32(s0)
    }
    // printk("pte2 = %lx\n", pte2);

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);// VA
ffffffe000202ff4:	fe043783          	ld	a5,-32(s0)
ffffffe000202ff8:	00a7d793          	srli	a5,a5,0xa
ffffffe000202ffc:	00c79713          	slli	a4,a5,0xc
ffffffe000203000:	fbf00793          	li	a5,-65
ffffffe000203004:	01f79793          	slli	a5,a5,0x1f
ffffffe000203008:	00f707b3          	add	a5,a4,a5
ffffffe00020300c:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe000203010:	f9043783          	ld	a5,-112(s0)
ffffffe000203014:	0017e793          	ori	a5,a5,1
ffffffe000203018:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe00020301c:	f9843783          	ld	a5,-104(s0)
ffffffe000203020:	00c7d793          	srli	a5,a5,0xc
ffffffe000203024:	00a79693          	slli	a3,a5,0xa
ffffffe000203028:	fc843783          	ld	a5,-56(s0)
ffffffe00020302c:	00379793          	slli	a5,a5,0x3
ffffffe000203030:	fb843703          	ld	a4,-72(s0)
ffffffe000203034:	00f707b3          	add	a5,a4,a5
ffffffe000203038:	f9043703          	ld	a4,-112(s0)
ffffffe00020303c:	00e6e733          	or	a4,a3,a4
ffffffe000203040:	00e7b023          	sd	a4,0(a5)
}
ffffffe000203044:	00000013          	nop
ffffffe000203048:	06813083          	ld	ra,104(sp)
ffffffe00020304c:	06013403          	ld	s0,96(sp)
ffffffe000203050:	07010113          	addi	sp,sp,112
ffffffe000203054:	00008067          	ret

ffffffe000203058 <get_kernel_pgtbl>:

uint64_t* get_kernel_pgtbl() { return swapper_pg_dir; }
ffffffe000203058:	ff010113          	addi	sp,sp,-16
ffffffe00020305c:	00813423          	sd	s0,8(sp)
ffffffe000203060:	01010413          	addi	s0,sp,16
ffffffe000203064:	0000c797          	auipc	a5,0xc
ffffffe000203068:	f9c78793          	addi	a5,a5,-100 # ffffffe00020f000 <swapper_pg_dir>
ffffffe00020306c:	00078513          	mv	a0,a5
ffffffe000203070:	00813403          	ld	s0,8(sp)
ffffffe000203074:	01010113          	addi	sp,sp,16
ffffffe000203078:	00008067          	ret

ffffffe00020307c <get_pte>:

uint64_t get_pte(uint64_t *pgtbl, uint64_t va){
ffffffe00020307c:	fa010113          	addi	sp,sp,-96
ffffffe000203080:	04813c23          	sd	s0,88(sp)
ffffffe000203084:	06010413          	addi	s0,sp,96
ffffffe000203088:	faa43423          	sd	a0,-88(s0)
ffffffe00020308c:	fab43023          	sd	a1,-96(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000203090:	fa043783          	ld	a5,-96(s0)
ffffffe000203094:	01e7d793          	srli	a5,a5,0x1e
ffffffe000203098:	1ff7f793          	andi	a5,a5,511
ffffffe00020309c:	fef43423          	sd	a5,-24(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe0002030a0:	fa043783          	ld	a5,-96(s0)
ffffffe0002030a4:	0157d793          	srli	a5,a5,0x15
ffffffe0002030a8:	1ff7f793          	andi	a5,a5,511
ffffffe0002030ac:	fef43023          	sd	a5,-32(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe0002030b0:	fa043783          	ld	a5,-96(s0)
ffffffe0002030b4:	00c7d793          	srli	a5,a5,0xc
ffffffe0002030b8:	1ff7f793          	andi	a5,a5,511
ffffffe0002030bc:	fcf43c23          	sd	a5,-40(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe0002030c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002030c4:	00379793          	slli	a5,a5,0x3
ffffffe0002030c8:	fa843703          	ld	a4,-88(s0)
ffffffe0002030cc:	00f707b3          	add	a5,a4,a5
ffffffe0002030d0:	0007b783          	ld	a5,0(a5)
ffffffe0002030d4:	fcf43823          	sd	a5,-48(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe0002030d8:	fd043783          	ld	a5,-48(s0)
ffffffe0002030dc:	0017f793          	andi	a5,a5,1
ffffffe0002030e0:	00079663          	bnez	a5,ffffffe0002030ec <get_pte+0x70>
        return 0;
ffffffe0002030e4:	00000793          	li	a5,0
ffffffe0002030e8:	07c0006f          	j	ffffffe000203164 <get_pte+0xe8>
    }

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe0002030ec:	fd043783          	ld	a5,-48(s0)
ffffffe0002030f0:	00a7d793          	srli	a5,a5,0xa
ffffffe0002030f4:	00c79713          	slli	a4,a5,0xc
ffffffe0002030f8:	fbf00793          	li	a5,-65
ffffffe0002030fc:	01f79793          	slli	a5,a5,0x1f
ffffffe000203100:	00f707b3          	add	a5,a4,a5
ffffffe000203104:	fcf43423          	sd	a5,-56(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe000203108:	fe043783          	ld	a5,-32(s0)
ffffffe00020310c:	00379793          	slli	a5,a5,0x3
ffffffe000203110:	fc843703          	ld	a4,-56(s0)
ffffffe000203114:	00f707b3          	add	a5,a4,a5
ffffffe000203118:	0007b783          	ld	a5,0(a5)
ffffffe00020311c:	fcf43023          	sd	a5,-64(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe000203120:	fc043783          	ld	a5,-64(s0)
ffffffe000203124:	0017f793          	andi	a5,a5,1
ffffffe000203128:	00079663          	bnez	a5,ffffffe000203134 <get_pte+0xb8>
        return 0;
ffffffe00020312c:	00000793          	li	a5,0
ffffffe000203130:	0340006f          	j	ffffffe000203164 <get_pte+0xe8>
    }

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);
ffffffe000203134:	fc043783          	ld	a5,-64(s0)
ffffffe000203138:	00a7d793          	srli	a5,a5,0xa
ffffffe00020313c:	00c79713          	slli	a4,a5,0xc
ffffffe000203140:	fbf00793          	li	a5,-65
ffffffe000203144:	01f79793          	slli	a5,a5,0x1f
ffffffe000203148:	00f707b3          	add	a5,a4,a5
ffffffe00020314c:	faf43c23          	sd	a5,-72(s0)
    return pgtbl3[idx3];
ffffffe000203150:	fd843783          	ld	a5,-40(s0)
ffffffe000203154:	00379793          	slli	a5,a5,0x3
ffffffe000203158:	fb843703          	ld	a4,-72(s0)
ffffffe00020315c:	00f707b3          	add	a5,a4,a5
ffffffe000203160:	0007b783          	ld	a5,0(a5)
}
ffffffe000203164:	00078513          	mv	a0,a5
ffffffe000203168:	05813403          	ld	s0,88(sp)
ffffffe00020316c:	06010113          	addi	sp,sp,96
ffffffe000203170:	00008067          	ret

ffffffe000203174 <va_mapped>:

int va_mapped(uint64_t *pgtbl, uint64_t va){
ffffffe000203174:	fd010113          	addi	sp,sp,-48
ffffffe000203178:	02113423          	sd	ra,40(sp)
ffffffe00020317c:	02813023          	sd	s0,32(sp)
ffffffe000203180:	03010413          	addi	s0,sp,48
ffffffe000203184:	fca43c23          	sd	a0,-40(s0)
ffffffe000203188:	fcb43823          	sd	a1,-48(s0)
    uint64_t pte = get_pte(pgtbl, va);
ffffffe00020318c:	fd043583          	ld	a1,-48(s0)
ffffffe000203190:	fd843503          	ld	a0,-40(s0)
ffffffe000203194:	ee9ff0ef          	jal	ra,ffffffe00020307c <get_pte>
ffffffe000203198:	fea43423          	sd	a0,-24(s0)
    return PTE_ISVALID(pte);
ffffffe00020319c:	fe843783          	ld	a5,-24(s0)
ffffffe0002031a0:	0007879b          	sext.w	a5,a5
ffffffe0002031a4:	0017f793          	andi	a5,a5,1
ffffffe0002031a8:	0007879b          	sext.w	a5,a5
ffffffe0002031ac:	00078513          	mv	a0,a5
ffffffe0002031b0:	02813083          	ld	ra,40(sp)
ffffffe0002031b4:	02013403          	ld	s0,32(sp)
ffffffe0002031b8:	03010113          	addi	sp,sp,48
ffffffe0002031bc:	00008067          	ret

ffffffe0002031c0 <start_kernel>:
#include "defs.h"
#include "proc.h"

extern void test();

int start_kernel() {
ffffffe0002031c0:	ff010113          	addi	sp,sp,-16
ffffffe0002031c4:	00113423          	sd	ra,8(sp)
ffffffe0002031c8:	00813023          	sd	s0,0(sp)
ffffffe0002031cc:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe0002031d0:	00004517          	auipc	a0,0x4
ffffffe0002031d4:	58850513          	addi	a0,a0,1416 # ffffffe000207758 <__func__.0+0x118>
ffffffe0002031d8:	198010ef          	jal	ra,ffffffe000204370 <printk>
    printk(" ZJU Operating System\n");
ffffffe0002031dc:	00004517          	auipc	a0,0x4
ffffffe0002031e0:	58450513          	addi	a0,a0,1412 # ffffffe000207760 <__func__.0+0x120>
ffffffe0002031e4:	18c010ef          	jal	ra,ffffffe000204370 <printk>
    schedule();
ffffffe0002031e8:	fd5fd0ef          	jal	ra,ffffffe0002011bc <schedule>
    // verify_vm();

    test();
ffffffe0002031ec:	2c0000ef          	jal	ra,ffffffe0002034ac <test>
    return 0;
ffffffe0002031f0:	00000793          	li	a5,0
}
ffffffe0002031f4:	00078513          	mv	a0,a5
ffffffe0002031f8:	00813083          	ld	ra,8(sp)
ffffffe0002031fc:	00013403          	ld	s0,0(sp)
ffffffe000203200:	01010113          	addi	sp,sp,16
ffffffe000203204:	00008067          	ret

ffffffe000203208 <test_rodata_write>:

void test_rodata_write(uint64_t *addr) {
ffffffe000203208:	fd010113          	addi	sp,sp,-48
ffffffe00020320c:	02113423          	sd	ra,40(sp)
ffffffe000203210:	02813023          	sd	s0,32(sp)
ffffffe000203214:	03010413          	addi	s0,sp,48
ffffffe000203218:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr;
ffffffe00020321c:	fd843783          	ld	a5,-40(s0)
ffffffe000203220:	0007b783          	ld	a5,0(a5)
ffffffe000203224:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000203228:	00100793          	li	a5,1
ffffffe00020322c:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000203230:	fd843783          	ld	a5,-40(s0)
ffffffe000203234:	00100293          	li	t0,1
ffffffe000203238:	0057b023          	sd	t0,0(a5)
ffffffe00020323c:	00000793          	li	a5,0
ffffffe000203240:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000203244:	fe442783          	lw	a5,-28(s0)
ffffffe000203248:	0007879b          	sext.w	a5,a5
ffffffe00020324c:	02078063          	beqz	a5,ffffffe00020326c <test_rodata_write+0x64>
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
ffffffe000203250:	00004517          	auipc	a0,0x4
ffffffe000203254:	52850513          	addi	a0,a0,1320 # ffffffe000207778 <__func__.0+0x138>
ffffffe000203258:	118010ef          	jal	ra,ffffffe000204370 <printk>
        *addr = backup; // 恢复原值
ffffffe00020325c:	fd843783          	ld	a5,-40(s0)
ffffffe000203260:	fe843703          	ld	a4,-24(s0)
ffffffe000203264:	00e7b023          	sd	a4,0(a5)
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}
ffffffe000203268:	0100006f          	j	ffffffe000203278 <test_rodata_write+0x70>
        printk("PASS: .rodata write failed as expected.\n");
ffffffe00020326c:	00004517          	auipc	a0,0x4
ffffffe000203270:	53c50513          	addi	a0,a0,1340 # ffffffe0002077a8 <__func__.0+0x168>
ffffffe000203274:	0fc010ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe000203278:	00000013          	nop
ffffffe00020327c:	02813083          	ld	ra,40(sp)
ffffffe000203280:	02013403          	ld	s0,32(sp)
ffffffe000203284:	03010113          	addi	sp,sp,48
ffffffe000203288:	00008067          	ret

ffffffe00020328c <test_rodata_exec>:

void test_rodata_exec(uint64_t *addr) {
ffffffe00020328c:	fd010113          	addi	sp,sp,-48
ffffffe000203290:	02113423          	sd	ra,40(sp)
ffffffe000203294:	02813023          	sd	s0,32(sp)
ffffffe000203298:	03010413          	addi	s0,sp,48
ffffffe00020329c:	fca43c23          	sd	a0,-40(s0)
    int success = 1;
ffffffe0002032a0:	00100793          	li	a5,1
ffffffe0002032a4:	fef42623          	sw	a5,-20(s0)

    asm volatile(
ffffffe0002032a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002032ac:	000780e7          	jalr	a5
ffffffe0002032b0:	00000793          	li	a5,0
ffffffe0002032b4:	fef42623          	sw	a5,-20(s0)
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
ffffffe0002032b8:	fec42783          	lw	a5,-20(s0)
ffffffe0002032bc:	0007879b          	sext.w	a5,a5
ffffffe0002032c0:	00078a63          	beqz	a5,ffffffe0002032d4 <test_rodata_exec+0x48>
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
ffffffe0002032c4:	00004517          	auipc	a0,0x4
ffffffe0002032c8:	51450513          	addi	a0,a0,1300 # ffffffe0002077d8 <__func__.0+0x198>
ffffffe0002032cc:	0a4010ef          	jal	ra,ffffffe000204370 <printk>
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}
ffffffe0002032d0:	0100006f          	j	ffffffe0002032e0 <test_rodata_exec+0x54>
        printk("PASS: .rodata execute failed as expected.\n");
ffffffe0002032d4:	00004517          	auipc	a0,0x4
ffffffe0002032d8:	53450513          	addi	a0,a0,1332 # ffffffe000207808 <__func__.0+0x1c8>
ffffffe0002032dc:	094010ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe0002032e0:	00000013          	nop
ffffffe0002032e4:	02813083          	ld	ra,40(sp)
ffffffe0002032e8:	02013403          	ld	s0,32(sp)
ffffffe0002032ec:	03010113          	addi	sp,sp,48
ffffffe0002032f0:	00008067          	ret

ffffffe0002032f4 <test_text_read>:

void test_text_read(uint64_t *addr) {
ffffffe0002032f4:	fd010113          	addi	sp,sp,-48
ffffffe0002032f8:	02113423          	sd	ra,40(sp)
ffffffe0002032fc:	02813023          	sd	s0,32(sp)
ffffffe000203300:	03010413          	addi	s0,sp,48
ffffffe000203304:	fca43c23          	sd	a0,-40(s0)
    printk(".text read test: ");
ffffffe000203308:	00004517          	auipc	a0,0x4
ffffffe00020330c:	53050513          	addi	a0,a0,1328 # ffffffe000207838 <__func__.0+0x1f8>
ffffffe000203310:	060010ef          	jal	ra,ffffffe000204370 <printk>
    uint64_t value = *addr;
ffffffe000203314:	fd843783          	ld	a5,-40(s0)
ffffffe000203318:	0007b783          	ld	a5,0(a5)
ffffffe00020331c:	fef43423          	sd	a5,-24(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe000203320:	fe843583          	ld	a1,-24(s0)
ffffffe000203324:	00004517          	auipc	a0,0x4
ffffffe000203328:	52c50513          	addi	a0,a0,1324 # ffffffe000207850 <__func__.0+0x210>
ffffffe00020332c:	044010ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe000203330:	00000013          	nop
ffffffe000203334:	02813083          	ld	ra,40(sp)
ffffffe000203338:	02013403          	ld	s0,32(sp)
ffffffe00020333c:	03010113          	addi	sp,sp,48
ffffffe000203340:	00008067          	ret

ffffffe000203344 <test_text_write>:

void test_text_write(uint64_t *addr) {
ffffffe000203344:	fd010113          	addi	sp,sp,-48
ffffffe000203348:	02113423          	sd	ra,40(sp)
ffffffe00020334c:	02813023          	sd	s0,32(sp)
ffffffe000203350:	03010413          	addi	s0,sp,48
ffffffe000203354:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr; // 备份原始值
ffffffe000203358:	fd843783          	ld	a5,-40(s0)
ffffffe00020335c:	0007b783          	ld	a5,0(a5)
ffffffe000203360:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000203364:	00100793          	li	a5,1
ffffffe000203368:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe00020336c:	fd843783          	ld	a5,-40(s0)
ffffffe000203370:	00100293          	li	t0,1
ffffffe000203374:	0057b023          	sd	t0,0(a5)
ffffffe000203378:	00000793          	li	a5,0
ffffffe00020337c:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000203380:	fe442783          	lw	a5,-28(s0)
ffffffe000203384:	0007879b          	sext.w	a5,a5
ffffffe000203388:	00078a63          	beqz	a5,ffffffe00020339c <test_text_write+0x58>
        printk("PASS: .text write failed as expected.\n");
ffffffe00020338c:	00004517          	auipc	a0,0x4
ffffffe000203390:	4ec50513          	addi	a0,a0,1260 # ffffffe000207878 <__func__.0+0x238>
ffffffe000203394:	7dd000ef          	jal	ra,ffffffe000204370 <printk>
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}
ffffffe000203398:	01c0006f          	j	ffffffe0002033b4 <test_text_write+0x70>
        printk("ERROR: .text write succeeded unexpectedly!\n");
ffffffe00020339c:	00004517          	auipc	a0,0x4
ffffffe0002033a0:	50450513          	addi	a0,a0,1284 # ffffffe0002078a0 <__func__.0+0x260>
ffffffe0002033a4:	7cd000ef          	jal	ra,ffffffe000204370 <printk>
        *addr = backup; // 恢复原始值，避免破坏代码段
ffffffe0002033a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002033ac:	fe843703          	ld	a4,-24(s0)
ffffffe0002033b0:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002033b4:	00000013          	nop
ffffffe0002033b8:	02813083          	ld	ra,40(sp)
ffffffe0002033bc:	02013403          	ld	s0,32(sp)
ffffffe0002033c0:	03010113          	addi	sp,sp,48
ffffffe0002033c4:	00008067          	ret

ffffffe0002033c8 <test_text_exec>:

void test_text_exec() {
ffffffe0002033c8:	ff010113          	addi	sp,sp,-16
ffffffe0002033cc:	00113423          	sd	ra,8(sp)
ffffffe0002033d0:	00813023          	sd	s0,0(sp)
ffffffe0002033d4:	01010413          	addi	s0,sp,16
    printk("Executing .text segment test: ");
ffffffe0002033d8:	00004517          	auipc	a0,0x4
ffffffe0002033dc:	4f850513          	addi	a0,a0,1272 # ffffffe0002078d0 <__func__.0+0x290>
ffffffe0002033e0:	791000ef          	jal	ra,ffffffe000204370 <printk>
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
ffffffe0002033e4:	00004517          	auipc	a0,0x4
ffffffe0002033e8:	50c50513          	addi	a0,a0,1292 # ffffffe0002078f0 <__func__.0+0x2b0>
ffffffe0002033ec:	785000ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe0002033f0:	00000013          	nop
ffffffe0002033f4:	00813083          	ld	ra,8(sp)
ffffffe0002033f8:	00013403          	ld	s0,0(sp)
ffffffe0002033fc:	01010113          	addi	sp,sp,16
ffffffe000203400:	00008067          	ret

ffffffe000203404 <verify_vm>:

void verify_vm() {
ffffffe000203404:	fd010113          	addi	sp,sp,-48
ffffffe000203408:	02113423          	sd	ra,40(sp)
ffffffe00020340c:	02813023          	sd	s0,32(sp)
ffffffe000203410:	03010413          	addi	s0,sp,48
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
ffffffe000203414:	f00017b7          	lui	a5,0xf0001
ffffffe000203418:	00979793          	slli	a5,a5,0x9
ffffffe00020341c:	fef43423          	sd	a5,-24(s0)
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段
ffffffe000203420:	fe0007b7          	lui	a5,0xfe000
ffffffe000203424:	20378793          	addi	a5,a5,515 # fffffffffe000203 <VM_END+0xfe000203>
ffffffe000203428:	00c79793          	slli	a5,a5,0xc
ffffffe00020342c:	fef43023          	sd	a5,-32(s0)

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;
ffffffe000203430:	fe843783          	ld	a5,-24(s0)
ffffffe000203434:	fcf43c23          	sd	a5,-40(s0)

    // .text R
    printk(".text read test: \n");
ffffffe000203438:	00004517          	auipc	a0,0x4
ffffffe00020343c:	4d850513          	addi	a0,a0,1240 # ffffffe000207910 <__func__.0+0x2d0>
ffffffe000203440:	731000ef          	jal	ra,ffffffe000204370 <printk>
    test_text_read(test_addr);
ffffffe000203444:	fd843503          	ld	a0,-40(s0)
ffffffe000203448:	eadff0ef          	jal	ra,ffffffe0002032f4 <test_text_read>
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
ffffffe00020344c:	00004517          	auipc	a0,0x4
ffffffe000203450:	4dc50513          	addi	a0,a0,1244 # ffffffe000207928 <__func__.0+0x2e8>
ffffffe000203454:	71d000ef          	jal	ra,ffffffe000204370 <printk>
    test_text_exec();
ffffffe000203458:	f71ff0ef          	jal	ra,ffffffe0002033c8 <test_text_exec>

    // .rodata
    test_addr = (uint64_t *)va_rodata;
ffffffe00020345c:	fe043783          	ld	a5,-32(s0)
ffffffe000203460:	fcf43c23          	sd	a5,-40(s0)

    // .rodata R
    printk(".rodata read test: \n");
ffffffe000203464:	00004517          	auipc	a0,0x4
ffffffe000203468:	4dc50513          	addi	a0,a0,1244 # ffffffe000207940 <__func__.0+0x300>
ffffffe00020346c:	705000ef          	jal	ra,ffffffe000204370 <printk>
    uint64_t value = *test_addr;
ffffffe000203470:	fd843783          	ld	a5,-40(s0)
ffffffe000203474:	0007b783          	ld	a5,0(a5)
ffffffe000203478:	fcf43823          	sd	a5,-48(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe00020347c:	fd043583          	ld	a1,-48(s0)
ffffffe000203480:	00004517          	auipc	a0,0x4
ffffffe000203484:	3d050513          	addi	a0,a0,976 # ffffffe000207850 <__func__.0+0x210>
ffffffe000203488:	6e9000ef          	jal	ra,ffffffe000204370 <printk>

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
ffffffe00020348c:	00004517          	auipc	a0,0x4
ffffffe000203490:	4cc50513          	addi	a0,a0,1228 # ffffffe000207958 <__func__.0+0x318>
ffffffe000203494:	6dd000ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000203498:	00000013          	nop
ffffffe00020349c:	02813083          	ld	ra,40(sp)
ffffffe0002034a0:	02013403          	ld	s0,32(sp)
ffffffe0002034a4:	03010113          	addi	sp,sp,48
ffffffe0002034a8:	00008067          	ret

ffffffe0002034ac <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe0002034ac:	fe010113          	addi	sp,sp,-32
ffffffe0002034b0:	00113c23          	sd	ra,24(sp)
ffffffe0002034b4:	00813823          	sd	s0,16(sp)
ffffffe0002034b8:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe0002034bc:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe0002034c0:	00004517          	auipc	a0,0x4
ffffffe0002034c4:	4b850513          	addi	a0,a0,1208 # ffffffe000207978 <__func__.0+0x338>
ffffffe0002034c8:	6a9000ef          	jal	ra,ffffffe000204370 <printk>
    while (1)
    {
        i++;
ffffffe0002034cc:	fec42783          	lw	a5,-20(s0)
ffffffe0002034d0:	0017879b          	addiw	a5,a5,1
ffffffe0002034d4:	fef42623          	sw	a5,-20(s0)
ffffffe0002034d8:	ff5ff06f          	j	ffffffe0002034cc <test+0x20>

ffffffe0002034dc <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe0002034dc:	fe010113          	addi	sp,sp,-32
ffffffe0002034e0:	00113c23          	sd	ra,24(sp)
ffffffe0002034e4:	00813823          	sd	s0,16(sp)
ffffffe0002034e8:	02010413          	addi	s0,sp,32
ffffffe0002034ec:	00050793          	mv	a5,a0
ffffffe0002034f0:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe0002034f4:	fec42783          	lw	a5,-20(s0)
ffffffe0002034f8:	0ff7f793          	zext.b	a5,a5
ffffffe0002034fc:	00078513          	mv	a0,a5
ffffffe000203500:	a70fe0ef          	jal	ra,ffffffe000201770 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000203504:	fec42783          	lw	a5,-20(s0)
ffffffe000203508:	0ff7f793          	zext.b	a5,a5
ffffffe00020350c:	0007879b          	sext.w	a5,a5
}
ffffffe000203510:	00078513          	mv	a0,a5
ffffffe000203514:	01813083          	ld	ra,24(sp)
ffffffe000203518:	01013403          	ld	s0,16(sp)
ffffffe00020351c:	02010113          	addi	sp,sp,32
ffffffe000203520:	00008067          	ret

ffffffe000203524 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe000203524:	fe010113          	addi	sp,sp,-32
ffffffe000203528:	00813c23          	sd	s0,24(sp)
ffffffe00020352c:	02010413          	addi	s0,sp,32
ffffffe000203530:	00050793          	mv	a5,a0
ffffffe000203534:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000203538:	fec42783          	lw	a5,-20(s0)
ffffffe00020353c:	0007871b          	sext.w	a4,a5
ffffffe000203540:	02000793          	li	a5,32
ffffffe000203544:	02f70263          	beq	a4,a5,ffffffe000203568 <isspace+0x44>
ffffffe000203548:	fec42783          	lw	a5,-20(s0)
ffffffe00020354c:	0007871b          	sext.w	a4,a5
ffffffe000203550:	00800793          	li	a5,8
ffffffe000203554:	00e7de63          	bge	a5,a4,ffffffe000203570 <isspace+0x4c>
ffffffe000203558:	fec42783          	lw	a5,-20(s0)
ffffffe00020355c:	0007871b          	sext.w	a4,a5
ffffffe000203560:	00d00793          	li	a5,13
ffffffe000203564:	00e7c663          	blt	a5,a4,ffffffe000203570 <isspace+0x4c>
ffffffe000203568:	00100793          	li	a5,1
ffffffe00020356c:	0080006f          	j	ffffffe000203574 <isspace+0x50>
ffffffe000203570:	00000793          	li	a5,0
}
ffffffe000203574:	00078513          	mv	a0,a5
ffffffe000203578:	01813403          	ld	s0,24(sp)
ffffffe00020357c:	02010113          	addi	sp,sp,32
ffffffe000203580:	00008067          	ret

ffffffe000203584 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000203584:	fb010113          	addi	sp,sp,-80
ffffffe000203588:	04113423          	sd	ra,72(sp)
ffffffe00020358c:	04813023          	sd	s0,64(sp)
ffffffe000203590:	05010413          	addi	s0,sp,80
ffffffe000203594:	fca43423          	sd	a0,-56(s0)
ffffffe000203598:	fcb43023          	sd	a1,-64(s0)
ffffffe00020359c:	00060793          	mv	a5,a2
ffffffe0002035a0:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe0002035a4:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe0002035a8:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe0002035ac:	fc843783          	ld	a5,-56(s0)
ffffffe0002035b0:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe0002035b4:	0100006f          	j	ffffffe0002035c4 <strtol+0x40>
        p++;
ffffffe0002035b8:	fd843783          	ld	a5,-40(s0)
ffffffe0002035bc:	00178793          	addi	a5,a5,1
ffffffe0002035c0:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe0002035c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002035c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002035cc:	0007879b          	sext.w	a5,a5
ffffffe0002035d0:	00078513          	mv	a0,a5
ffffffe0002035d4:	f51ff0ef          	jal	ra,ffffffe000203524 <isspace>
ffffffe0002035d8:	00050793          	mv	a5,a0
ffffffe0002035dc:	fc079ee3          	bnez	a5,ffffffe0002035b8 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe0002035e0:	fd843783          	ld	a5,-40(s0)
ffffffe0002035e4:	0007c783          	lbu	a5,0(a5)
ffffffe0002035e8:	00078713          	mv	a4,a5
ffffffe0002035ec:	02d00793          	li	a5,45
ffffffe0002035f0:	00f71e63          	bne	a4,a5,ffffffe00020360c <strtol+0x88>
        neg = true;
ffffffe0002035f4:	00100793          	li	a5,1
ffffffe0002035f8:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002035fc:	fd843783          	ld	a5,-40(s0)
ffffffe000203600:	00178793          	addi	a5,a5,1
ffffffe000203604:	fcf43c23          	sd	a5,-40(s0)
ffffffe000203608:	0240006f          	j	ffffffe00020362c <strtol+0xa8>
    } else if (*p == '+') {
ffffffe00020360c:	fd843783          	ld	a5,-40(s0)
ffffffe000203610:	0007c783          	lbu	a5,0(a5)
ffffffe000203614:	00078713          	mv	a4,a5
ffffffe000203618:	02b00793          	li	a5,43
ffffffe00020361c:	00f71863          	bne	a4,a5,ffffffe00020362c <strtol+0xa8>
        p++;
ffffffe000203620:	fd843783          	ld	a5,-40(s0)
ffffffe000203624:	00178793          	addi	a5,a5,1
ffffffe000203628:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe00020362c:	fbc42783          	lw	a5,-68(s0)
ffffffe000203630:	0007879b          	sext.w	a5,a5
ffffffe000203634:	06079c63          	bnez	a5,ffffffe0002036ac <strtol+0x128>
        if (*p == '0') {
ffffffe000203638:	fd843783          	ld	a5,-40(s0)
ffffffe00020363c:	0007c783          	lbu	a5,0(a5)
ffffffe000203640:	00078713          	mv	a4,a5
ffffffe000203644:	03000793          	li	a5,48
ffffffe000203648:	04f71e63          	bne	a4,a5,ffffffe0002036a4 <strtol+0x120>
            p++;
ffffffe00020364c:	fd843783          	ld	a5,-40(s0)
ffffffe000203650:	00178793          	addi	a5,a5,1
ffffffe000203654:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000203658:	fd843783          	ld	a5,-40(s0)
ffffffe00020365c:	0007c783          	lbu	a5,0(a5)
ffffffe000203660:	00078713          	mv	a4,a5
ffffffe000203664:	07800793          	li	a5,120
ffffffe000203668:	00f70c63          	beq	a4,a5,ffffffe000203680 <strtol+0xfc>
ffffffe00020366c:	fd843783          	ld	a5,-40(s0)
ffffffe000203670:	0007c783          	lbu	a5,0(a5)
ffffffe000203674:	00078713          	mv	a4,a5
ffffffe000203678:	05800793          	li	a5,88
ffffffe00020367c:	00f71e63          	bne	a4,a5,ffffffe000203698 <strtol+0x114>
                base = 16;
ffffffe000203680:	01000793          	li	a5,16
ffffffe000203684:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000203688:	fd843783          	ld	a5,-40(s0)
ffffffe00020368c:	00178793          	addi	a5,a5,1
ffffffe000203690:	fcf43c23          	sd	a5,-40(s0)
ffffffe000203694:	0180006f          	j	ffffffe0002036ac <strtol+0x128>
            } else {
                base = 8;
ffffffe000203698:	00800793          	li	a5,8
ffffffe00020369c:	faf42e23          	sw	a5,-68(s0)
ffffffe0002036a0:	00c0006f          	j	ffffffe0002036ac <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe0002036a4:	00a00793          	li	a5,10
ffffffe0002036a8:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe0002036ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002036b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002036b4:	00078713          	mv	a4,a5
ffffffe0002036b8:	02f00793          	li	a5,47
ffffffe0002036bc:	02e7f863          	bgeu	a5,a4,ffffffe0002036ec <strtol+0x168>
ffffffe0002036c0:	fd843783          	ld	a5,-40(s0)
ffffffe0002036c4:	0007c783          	lbu	a5,0(a5)
ffffffe0002036c8:	00078713          	mv	a4,a5
ffffffe0002036cc:	03900793          	li	a5,57
ffffffe0002036d0:	00e7ee63          	bltu	a5,a4,ffffffe0002036ec <strtol+0x168>
            digit = *p - '0';
ffffffe0002036d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002036d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002036dc:	0007879b          	sext.w	a5,a5
ffffffe0002036e0:	fd07879b          	addiw	a5,a5,-48
ffffffe0002036e4:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002036e8:	0800006f          	j	ffffffe000203768 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe0002036ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002036f0:	0007c783          	lbu	a5,0(a5)
ffffffe0002036f4:	00078713          	mv	a4,a5
ffffffe0002036f8:	06000793          	li	a5,96
ffffffe0002036fc:	02e7f863          	bgeu	a5,a4,ffffffe00020372c <strtol+0x1a8>
ffffffe000203700:	fd843783          	ld	a5,-40(s0)
ffffffe000203704:	0007c783          	lbu	a5,0(a5)
ffffffe000203708:	00078713          	mv	a4,a5
ffffffe00020370c:	07a00793          	li	a5,122
ffffffe000203710:	00e7ee63          	bltu	a5,a4,ffffffe00020372c <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe000203714:	fd843783          	ld	a5,-40(s0)
ffffffe000203718:	0007c783          	lbu	a5,0(a5)
ffffffe00020371c:	0007879b          	sext.w	a5,a5
ffffffe000203720:	fa97879b          	addiw	a5,a5,-87
ffffffe000203724:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203728:	0400006f          	j	ffffffe000203768 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe00020372c:	fd843783          	ld	a5,-40(s0)
ffffffe000203730:	0007c783          	lbu	a5,0(a5)
ffffffe000203734:	00078713          	mv	a4,a5
ffffffe000203738:	04000793          	li	a5,64
ffffffe00020373c:	06e7f863          	bgeu	a5,a4,ffffffe0002037ac <strtol+0x228>
ffffffe000203740:	fd843783          	ld	a5,-40(s0)
ffffffe000203744:	0007c783          	lbu	a5,0(a5)
ffffffe000203748:	00078713          	mv	a4,a5
ffffffe00020374c:	05a00793          	li	a5,90
ffffffe000203750:	04e7ee63          	bltu	a5,a4,ffffffe0002037ac <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000203754:	fd843783          	ld	a5,-40(s0)
ffffffe000203758:	0007c783          	lbu	a5,0(a5)
ffffffe00020375c:	0007879b          	sext.w	a5,a5
ffffffe000203760:	fc97879b          	addiw	a5,a5,-55
ffffffe000203764:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000203768:	fd442783          	lw	a5,-44(s0)
ffffffe00020376c:	00078713          	mv	a4,a5
ffffffe000203770:	fbc42783          	lw	a5,-68(s0)
ffffffe000203774:	0007071b          	sext.w	a4,a4
ffffffe000203778:	0007879b          	sext.w	a5,a5
ffffffe00020377c:	02f75663          	bge	a4,a5,ffffffe0002037a8 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000203780:	fbc42703          	lw	a4,-68(s0)
ffffffe000203784:	fe843783          	ld	a5,-24(s0)
ffffffe000203788:	02f70733          	mul	a4,a4,a5
ffffffe00020378c:	fd442783          	lw	a5,-44(s0)
ffffffe000203790:	00f707b3          	add	a5,a4,a5
ffffffe000203794:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000203798:	fd843783          	ld	a5,-40(s0)
ffffffe00020379c:	00178793          	addi	a5,a5,1
ffffffe0002037a0:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe0002037a4:	f09ff06f          	j	ffffffe0002036ac <strtol+0x128>
            break;
ffffffe0002037a8:	00000013          	nop
    }

    if (endptr) {
ffffffe0002037ac:	fc043783          	ld	a5,-64(s0)
ffffffe0002037b0:	00078863          	beqz	a5,ffffffe0002037c0 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe0002037b4:	fc043783          	ld	a5,-64(s0)
ffffffe0002037b8:	fd843703          	ld	a4,-40(s0)
ffffffe0002037bc:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe0002037c0:	fe744783          	lbu	a5,-25(s0)
ffffffe0002037c4:	0ff7f793          	zext.b	a5,a5
ffffffe0002037c8:	00078863          	beqz	a5,ffffffe0002037d8 <strtol+0x254>
ffffffe0002037cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002037d0:	40f007b3          	neg	a5,a5
ffffffe0002037d4:	0080006f          	j	ffffffe0002037dc <strtol+0x258>
ffffffe0002037d8:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002037dc:	00078513          	mv	a0,a5
ffffffe0002037e0:	04813083          	ld	ra,72(sp)
ffffffe0002037e4:	04013403          	ld	s0,64(sp)
ffffffe0002037e8:	05010113          	addi	sp,sp,80
ffffffe0002037ec:	00008067          	ret

ffffffe0002037f0 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe0002037f0:	fd010113          	addi	sp,sp,-48
ffffffe0002037f4:	02113423          	sd	ra,40(sp)
ffffffe0002037f8:	02813023          	sd	s0,32(sp)
ffffffe0002037fc:	03010413          	addi	s0,sp,48
ffffffe000203800:	fca43c23          	sd	a0,-40(s0)
ffffffe000203804:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe000203808:	fd043783          	ld	a5,-48(s0)
ffffffe00020380c:	00079863          	bnez	a5,ffffffe00020381c <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe000203810:	00004797          	auipc	a5,0x4
ffffffe000203814:	18078793          	addi	a5,a5,384 # ffffffe000207990 <__func__.0+0x350>
ffffffe000203818:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe00020381c:	fd043783          	ld	a5,-48(s0)
ffffffe000203820:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe000203824:	0240006f          	j	ffffffe000203848 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe000203828:	fe843783          	ld	a5,-24(s0)
ffffffe00020382c:	00178713          	addi	a4,a5,1
ffffffe000203830:	fee43423          	sd	a4,-24(s0)
ffffffe000203834:	0007c783          	lbu	a5,0(a5)
ffffffe000203838:	0007871b          	sext.w	a4,a5
ffffffe00020383c:	fd843783          	ld	a5,-40(s0)
ffffffe000203840:	00070513          	mv	a0,a4
ffffffe000203844:	000780e7          	jalr	a5
    while (*p) {
ffffffe000203848:	fe843783          	ld	a5,-24(s0)
ffffffe00020384c:	0007c783          	lbu	a5,0(a5)
ffffffe000203850:	fc079ce3          	bnez	a5,ffffffe000203828 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000203854:	fe843703          	ld	a4,-24(s0)
ffffffe000203858:	fd043783          	ld	a5,-48(s0)
ffffffe00020385c:	40f707b3          	sub	a5,a4,a5
ffffffe000203860:	0007879b          	sext.w	a5,a5
}
ffffffe000203864:	00078513          	mv	a0,a5
ffffffe000203868:	02813083          	ld	ra,40(sp)
ffffffe00020386c:	02013403          	ld	s0,32(sp)
ffffffe000203870:	03010113          	addi	sp,sp,48
ffffffe000203874:	00008067          	ret

ffffffe000203878 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000203878:	f9010113          	addi	sp,sp,-112
ffffffe00020387c:	06113423          	sd	ra,104(sp)
ffffffe000203880:	06813023          	sd	s0,96(sp)
ffffffe000203884:	07010413          	addi	s0,sp,112
ffffffe000203888:	faa43423          	sd	a0,-88(s0)
ffffffe00020388c:	fab43023          	sd	a1,-96(s0)
ffffffe000203890:	00060793          	mv	a5,a2
ffffffe000203894:	f8d43823          	sd	a3,-112(s0)
ffffffe000203898:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe00020389c:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002038a0:	0ff7f793          	zext.b	a5,a5
ffffffe0002038a4:	02078663          	beqz	a5,ffffffe0002038d0 <print_dec_int+0x58>
ffffffe0002038a8:	fa043703          	ld	a4,-96(s0)
ffffffe0002038ac:	fff00793          	li	a5,-1
ffffffe0002038b0:	03f79793          	slli	a5,a5,0x3f
ffffffe0002038b4:	00f71e63          	bne	a4,a5,ffffffe0002038d0 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe0002038b8:	00004597          	auipc	a1,0x4
ffffffe0002038bc:	0e058593          	addi	a1,a1,224 # ffffffe000207998 <__func__.0+0x358>
ffffffe0002038c0:	fa843503          	ld	a0,-88(s0)
ffffffe0002038c4:	f2dff0ef          	jal	ra,ffffffe0002037f0 <puts_wo_nl>
ffffffe0002038c8:	00050793          	mv	a5,a0
ffffffe0002038cc:	2a00006f          	j	ffffffe000203b6c <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe0002038d0:	f9043783          	ld	a5,-112(s0)
ffffffe0002038d4:	00c7a783          	lw	a5,12(a5)
ffffffe0002038d8:	00079a63          	bnez	a5,ffffffe0002038ec <print_dec_int+0x74>
ffffffe0002038dc:	fa043783          	ld	a5,-96(s0)
ffffffe0002038e0:	00079663          	bnez	a5,ffffffe0002038ec <print_dec_int+0x74>
        return 0;
ffffffe0002038e4:	00000793          	li	a5,0
ffffffe0002038e8:	2840006f          	j	ffffffe000203b6c <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe0002038ec:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe0002038f0:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002038f4:	0ff7f793          	zext.b	a5,a5
ffffffe0002038f8:	02078063          	beqz	a5,ffffffe000203918 <print_dec_int+0xa0>
ffffffe0002038fc:	fa043783          	ld	a5,-96(s0)
ffffffe000203900:	0007dc63          	bgez	a5,ffffffe000203918 <print_dec_int+0xa0>
        neg = true;
ffffffe000203904:	00100793          	li	a5,1
ffffffe000203908:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe00020390c:	fa043783          	ld	a5,-96(s0)
ffffffe000203910:	40f007b3          	neg	a5,a5
ffffffe000203914:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000203918:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe00020391c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000203920:	0ff7f793          	zext.b	a5,a5
ffffffe000203924:	02078863          	beqz	a5,ffffffe000203954 <print_dec_int+0xdc>
ffffffe000203928:	fef44783          	lbu	a5,-17(s0)
ffffffe00020392c:	0ff7f793          	zext.b	a5,a5
ffffffe000203930:	00079e63          	bnez	a5,ffffffe00020394c <print_dec_int+0xd4>
ffffffe000203934:	f9043783          	ld	a5,-112(s0)
ffffffe000203938:	0057c783          	lbu	a5,5(a5)
ffffffe00020393c:	00079863          	bnez	a5,ffffffe00020394c <print_dec_int+0xd4>
ffffffe000203940:	f9043783          	ld	a5,-112(s0)
ffffffe000203944:	0047c783          	lbu	a5,4(a5)
ffffffe000203948:	00078663          	beqz	a5,ffffffe000203954 <print_dec_int+0xdc>
ffffffe00020394c:	00100793          	li	a5,1
ffffffe000203950:	0080006f          	j	ffffffe000203958 <print_dec_int+0xe0>
ffffffe000203954:	00000793          	li	a5,0
ffffffe000203958:	fcf40ba3          	sb	a5,-41(s0)
ffffffe00020395c:	fd744783          	lbu	a5,-41(s0)
ffffffe000203960:	0017f793          	andi	a5,a5,1
ffffffe000203964:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000203968:	fa043703          	ld	a4,-96(s0)
ffffffe00020396c:	00a00793          	li	a5,10
ffffffe000203970:	02f777b3          	remu	a5,a4,a5
ffffffe000203974:	0ff7f713          	zext.b	a4,a5
ffffffe000203978:	fe842783          	lw	a5,-24(s0)
ffffffe00020397c:	0017869b          	addiw	a3,a5,1
ffffffe000203980:	fed42423          	sw	a3,-24(s0)
ffffffe000203984:	0307071b          	addiw	a4,a4,48
ffffffe000203988:	0ff77713          	zext.b	a4,a4
ffffffe00020398c:	ff078793          	addi	a5,a5,-16
ffffffe000203990:	008787b3          	add	a5,a5,s0
ffffffe000203994:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000203998:	fa043703          	ld	a4,-96(s0)
ffffffe00020399c:	00a00793          	li	a5,10
ffffffe0002039a0:	02f757b3          	divu	a5,a4,a5
ffffffe0002039a4:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe0002039a8:	fa043783          	ld	a5,-96(s0)
ffffffe0002039ac:	fa079ee3          	bnez	a5,ffffffe000203968 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe0002039b0:	f9043783          	ld	a5,-112(s0)
ffffffe0002039b4:	00c7a783          	lw	a5,12(a5)
ffffffe0002039b8:	00078713          	mv	a4,a5
ffffffe0002039bc:	fff00793          	li	a5,-1
ffffffe0002039c0:	02f71063          	bne	a4,a5,ffffffe0002039e0 <print_dec_int+0x168>
ffffffe0002039c4:	f9043783          	ld	a5,-112(s0)
ffffffe0002039c8:	0037c783          	lbu	a5,3(a5)
ffffffe0002039cc:	00078a63          	beqz	a5,ffffffe0002039e0 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe0002039d0:	f9043783          	ld	a5,-112(s0)
ffffffe0002039d4:	0087a703          	lw	a4,8(a5)
ffffffe0002039d8:	f9043783          	ld	a5,-112(s0)
ffffffe0002039dc:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe0002039e0:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002039e4:	f9043783          	ld	a5,-112(s0)
ffffffe0002039e8:	0087a703          	lw	a4,8(a5)
ffffffe0002039ec:	fe842783          	lw	a5,-24(s0)
ffffffe0002039f0:	fcf42823          	sw	a5,-48(s0)
ffffffe0002039f4:	f9043783          	ld	a5,-112(s0)
ffffffe0002039f8:	00c7a783          	lw	a5,12(a5)
ffffffe0002039fc:	fcf42623          	sw	a5,-52(s0)
ffffffe000203a00:	fd042783          	lw	a5,-48(s0)
ffffffe000203a04:	00078593          	mv	a1,a5
ffffffe000203a08:	fcc42783          	lw	a5,-52(s0)
ffffffe000203a0c:	00078613          	mv	a2,a5
ffffffe000203a10:	0006069b          	sext.w	a3,a2
ffffffe000203a14:	0005879b          	sext.w	a5,a1
ffffffe000203a18:	00f6d463          	bge	a3,a5,ffffffe000203a20 <print_dec_int+0x1a8>
ffffffe000203a1c:	00058613          	mv	a2,a1
ffffffe000203a20:	0006079b          	sext.w	a5,a2
ffffffe000203a24:	40f707bb          	subw	a5,a4,a5
ffffffe000203a28:	0007871b          	sext.w	a4,a5
ffffffe000203a2c:	fd744783          	lbu	a5,-41(s0)
ffffffe000203a30:	0007879b          	sext.w	a5,a5
ffffffe000203a34:	40f707bb          	subw	a5,a4,a5
ffffffe000203a38:	fef42023          	sw	a5,-32(s0)
ffffffe000203a3c:	0280006f          	j	ffffffe000203a64 <print_dec_int+0x1ec>
        putch(' ');
ffffffe000203a40:	fa843783          	ld	a5,-88(s0)
ffffffe000203a44:	02000513          	li	a0,32
ffffffe000203a48:	000780e7          	jalr	a5
        ++written;
ffffffe000203a4c:	fe442783          	lw	a5,-28(s0)
ffffffe000203a50:	0017879b          	addiw	a5,a5,1
ffffffe000203a54:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000203a58:	fe042783          	lw	a5,-32(s0)
ffffffe000203a5c:	fff7879b          	addiw	a5,a5,-1
ffffffe000203a60:	fef42023          	sw	a5,-32(s0)
ffffffe000203a64:	fe042783          	lw	a5,-32(s0)
ffffffe000203a68:	0007879b          	sext.w	a5,a5
ffffffe000203a6c:	fcf04ae3          	bgtz	a5,ffffffe000203a40 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000203a70:	fd744783          	lbu	a5,-41(s0)
ffffffe000203a74:	0ff7f793          	zext.b	a5,a5
ffffffe000203a78:	04078463          	beqz	a5,ffffffe000203ac0 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000203a7c:	fef44783          	lbu	a5,-17(s0)
ffffffe000203a80:	0ff7f793          	zext.b	a5,a5
ffffffe000203a84:	00078663          	beqz	a5,ffffffe000203a90 <print_dec_int+0x218>
ffffffe000203a88:	02d00793          	li	a5,45
ffffffe000203a8c:	01c0006f          	j	ffffffe000203aa8 <print_dec_int+0x230>
ffffffe000203a90:	f9043783          	ld	a5,-112(s0)
ffffffe000203a94:	0057c783          	lbu	a5,5(a5)
ffffffe000203a98:	00078663          	beqz	a5,ffffffe000203aa4 <print_dec_int+0x22c>
ffffffe000203a9c:	02b00793          	li	a5,43
ffffffe000203aa0:	0080006f          	j	ffffffe000203aa8 <print_dec_int+0x230>
ffffffe000203aa4:	02000793          	li	a5,32
ffffffe000203aa8:	fa843703          	ld	a4,-88(s0)
ffffffe000203aac:	00078513          	mv	a0,a5
ffffffe000203ab0:	000700e7          	jalr	a4
        ++written;
ffffffe000203ab4:	fe442783          	lw	a5,-28(s0)
ffffffe000203ab8:	0017879b          	addiw	a5,a5,1
ffffffe000203abc:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000203ac0:	fe842783          	lw	a5,-24(s0)
ffffffe000203ac4:	fcf42e23          	sw	a5,-36(s0)
ffffffe000203ac8:	0280006f          	j	ffffffe000203af0 <print_dec_int+0x278>
        putch('0');
ffffffe000203acc:	fa843783          	ld	a5,-88(s0)
ffffffe000203ad0:	03000513          	li	a0,48
ffffffe000203ad4:	000780e7          	jalr	a5
        ++written;
ffffffe000203ad8:	fe442783          	lw	a5,-28(s0)
ffffffe000203adc:	0017879b          	addiw	a5,a5,1
ffffffe000203ae0:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000203ae4:	fdc42783          	lw	a5,-36(s0)
ffffffe000203ae8:	0017879b          	addiw	a5,a5,1
ffffffe000203aec:	fcf42e23          	sw	a5,-36(s0)
ffffffe000203af0:	f9043783          	ld	a5,-112(s0)
ffffffe000203af4:	00c7a703          	lw	a4,12(a5)
ffffffe000203af8:	fd744783          	lbu	a5,-41(s0)
ffffffe000203afc:	0007879b          	sext.w	a5,a5
ffffffe000203b00:	40f707bb          	subw	a5,a4,a5
ffffffe000203b04:	0007871b          	sext.w	a4,a5
ffffffe000203b08:	fdc42783          	lw	a5,-36(s0)
ffffffe000203b0c:	0007879b          	sext.w	a5,a5
ffffffe000203b10:	fae7cee3          	blt	a5,a4,ffffffe000203acc <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000203b14:	fe842783          	lw	a5,-24(s0)
ffffffe000203b18:	fff7879b          	addiw	a5,a5,-1
ffffffe000203b1c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203b20:	03c0006f          	j	ffffffe000203b5c <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe000203b24:	fd842783          	lw	a5,-40(s0)
ffffffe000203b28:	ff078793          	addi	a5,a5,-16
ffffffe000203b2c:	008787b3          	add	a5,a5,s0
ffffffe000203b30:	fc87c783          	lbu	a5,-56(a5)
ffffffe000203b34:	0007871b          	sext.w	a4,a5
ffffffe000203b38:	fa843783          	ld	a5,-88(s0)
ffffffe000203b3c:	00070513          	mv	a0,a4
ffffffe000203b40:	000780e7          	jalr	a5
        ++written;
ffffffe000203b44:	fe442783          	lw	a5,-28(s0)
ffffffe000203b48:	0017879b          	addiw	a5,a5,1
ffffffe000203b4c:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000203b50:	fd842783          	lw	a5,-40(s0)
ffffffe000203b54:	fff7879b          	addiw	a5,a5,-1
ffffffe000203b58:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203b5c:	fd842783          	lw	a5,-40(s0)
ffffffe000203b60:	0007879b          	sext.w	a5,a5
ffffffe000203b64:	fc07d0e3          	bgez	a5,ffffffe000203b24 <print_dec_int+0x2ac>
    }

    return written;
ffffffe000203b68:	fe442783          	lw	a5,-28(s0)
}
ffffffe000203b6c:	00078513          	mv	a0,a5
ffffffe000203b70:	06813083          	ld	ra,104(sp)
ffffffe000203b74:	06013403          	ld	s0,96(sp)
ffffffe000203b78:	07010113          	addi	sp,sp,112
ffffffe000203b7c:	00008067          	ret

ffffffe000203b80 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000203b80:	f4010113          	addi	sp,sp,-192
ffffffe000203b84:	0a113c23          	sd	ra,184(sp)
ffffffe000203b88:	0a813823          	sd	s0,176(sp)
ffffffe000203b8c:	0c010413          	addi	s0,sp,192
ffffffe000203b90:	f4a43c23          	sd	a0,-168(s0)
ffffffe000203b94:	f4b43823          	sd	a1,-176(s0)
ffffffe000203b98:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000203b9c:	f8043023          	sd	zero,-128(s0)
ffffffe000203ba0:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000203ba4:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000203ba8:	7a40006f          	j	ffffffe00020434c <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000203bac:	f8044783          	lbu	a5,-128(s0)
ffffffe000203bb0:	72078e63          	beqz	a5,ffffffe0002042ec <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000203bb4:	f5043783          	ld	a5,-176(s0)
ffffffe000203bb8:	0007c783          	lbu	a5,0(a5)
ffffffe000203bbc:	00078713          	mv	a4,a5
ffffffe000203bc0:	02300793          	li	a5,35
ffffffe000203bc4:	00f71863          	bne	a4,a5,ffffffe000203bd4 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000203bc8:	00100793          	li	a5,1
ffffffe000203bcc:	f8f40123          	sb	a5,-126(s0)
ffffffe000203bd0:	7700006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000203bd4:	f5043783          	ld	a5,-176(s0)
ffffffe000203bd8:	0007c783          	lbu	a5,0(a5)
ffffffe000203bdc:	00078713          	mv	a4,a5
ffffffe000203be0:	03000793          	li	a5,48
ffffffe000203be4:	00f71863          	bne	a4,a5,ffffffe000203bf4 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000203be8:	00100793          	li	a5,1
ffffffe000203bec:	f8f401a3          	sb	a5,-125(s0)
ffffffe000203bf0:	7500006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000203bf4:	f5043783          	ld	a5,-176(s0)
ffffffe000203bf8:	0007c783          	lbu	a5,0(a5)
ffffffe000203bfc:	00078713          	mv	a4,a5
ffffffe000203c00:	06c00793          	li	a5,108
ffffffe000203c04:	04f70063          	beq	a4,a5,ffffffe000203c44 <vprintfmt+0xc4>
ffffffe000203c08:	f5043783          	ld	a5,-176(s0)
ffffffe000203c0c:	0007c783          	lbu	a5,0(a5)
ffffffe000203c10:	00078713          	mv	a4,a5
ffffffe000203c14:	07a00793          	li	a5,122
ffffffe000203c18:	02f70663          	beq	a4,a5,ffffffe000203c44 <vprintfmt+0xc4>
ffffffe000203c1c:	f5043783          	ld	a5,-176(s0)
ffffffe000203c20:	0007c783          	lbu	a5,0(a5)
ffffffe000203c24:	00078713          	mv	a4,a5
ffffffe000203c28:	07400793          	li	a5,116
ffffffe000203c2c:	00f70c63          	beq	a4,a5,ffffffe000203c44 <vprintfmt+0xc4>
ffffffe000203c30:	f5043783          	ld	a5,-176(s0)
ffffffe000203c34:	0007c783          	lbu	a5,0(a5)
ffffffe000203c38:	00078713          	mv	a4,a5
ffffffe000203c3c:	06a00793          	li	a5,106
ffffffe000203c40:	00f71863          	bne	a4,a5,ffffffe000203c50 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000203c44:	00100793          	li	a5,1
ffffffe000203c48:	f8f400a3          	sb	a5,-127(s0)
ffffffe000203c4c:	6f40006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000203c50:	f5043783          	ld	a5,-176(s0)
ffffffe000203c54:	0007c783          	lbu	a5,0(a5)
ffffffe000203c58:	00078713          	mv	a4,a5
ffffffe000203c5c:	02b00793          	li	a5,43
ffffffe000203c60:	00f71863          	bne	a4,a5,ffffffe000203c70 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000203c64:	00100793          	li	a5,1
ffffffe000203c68:	f8f402a3          	sb	a5,-123(s0)
ffffffe000203c6c:	6d40006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000203c70:	f5043783          	ld	a5,-176(s0)
ffffffe000203c74:	0007c783          	lbu	a5,0(a5)
ffffffe000203c78:	00078713          	mv	a4,a5
ffffffe000203c7c:	02000793          	li	a5,32
ffffffe000203c80:	00f71863          	bne	a4,a5,ffffffe000203c90 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000203c84:	00100793          	li	a5,1
ffffffe000203c88:	f8f40223          	sb	a5,-124(s0)
ffffffe000203c8c:	6b40006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000203c90:	f5043783          	ld	a5,-176(s0)
ffffffe000203c94:	0007c783          	lbu	a5,0(a5)
ffffffe000203c98:	00078713          	mv	a4,a5
ffffffe000203c9c:	02a00793          	li	a5,42
ffffffe000203ca0:	00f71e63          	bne	a4,a5,ffffffe000203cbc <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000203ca4:	f4843783          	ld	a5,-184(s0)
ffffffe000203ca8:	00878713          	addi	a4,a5,8
ffffffe000203cac:	f4e43423          	sd	a4,-184(s0)
ffffffe000203cb0:	0007a783          	lw	a5,0(a5)
ffffffe000203cb4:	f8f42423          	sw	a5,-120(s0)
ffffffe000203cb8:	6880006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000203cbc:	f5043783          	ld	a5,-176(s0)
ffffffe000203cc0:	0007c783          	lbu	a5,0(a5)
ffffffe000203cc4:	00078713          	mv	a4,a5
ffffffe000203cc8:	03000793          	li	a5,48
ffffffe000203ccc:	04e7f663          	bgeu	a5,a4,ffffffe000203d18 <vprintfmt+0x198>
ffffffe000203cd0:	f5043783          	ld	a5,-176(s0)
ffffffe000203cd4:	0007c783          	lbu	a5,0(a5)
ffffffe000203cd8:	00078713          	mv	a4,a5
ffffffe000203cdc:	03900793          	li	a5,57
ffffffe000203ce0:	02e7ec63          	bltu	a5,a4,ffffffe000203d18 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000203ce4:	f5043783          	ld	a5,-176(s0)
ffffffe000203ce8:	f5040713          	addi	a4,s0,-176
ffffffe000203cec:	00a00613          	li	a2,10
ffffffe000203cf0:	00070593          	mv	a1,a4
ffffffe000203cf4:	00078513          	mv	a0,a5
ffffffe000203cf8:	88dff0ef          	jal	ra,ffffffe000203584 <strtol>
ffffffe000203cfc:	00050793          	mv	a5,a0
ffffffe000203d00:	0007879b          	sext.w	a5,a5
ffffffe000203d04:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000203d08:	f5043783          	ld	a5,-176(s0)
ffffffe000203d0c:	fff78793          	addi	a5,a5,-1
ffffffe000203d10:	f4f43823          	sd	a5,-176(s0)
ffffffe000203d14:	62c0006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000203d18:	f5043783          	ld	a5,-176(s0)
ffffffe000203d1c:	0007c783          	lbu	a5,0(a5)
ffffffe000203d20:	00078713          	mv	a4,a5
ffffffe000203d24:	02e00793          	li	a5,46
ffffffe000203d28:	06f71863          	bne	a4,a5,ffffffe000203d98 <vprintfmt+0x218>
                fmt++;
ffffffe000203d2c:	f5043783          	ld	a5,-176(s0)
ffffffe000203d30:	00178793          	addi	a5,a5,1
ffffffe000203d34:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000203d38:	f5043783          	ld	a5,-176(s0)
ffffffe000203d3c:	0007c783          	lbu	a5,0(a5)
ffffffe000203d40:	00078713          	mv	a4,a5
ffffffe000203d44:	02a00793          	li	a5,42
ffffffe000203d48:	00f71e63          	bne	a4,a5,ffffffe000203d64 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000203d4c:	f4843783          	ld	a5,-184(s0)
ffffffe000203d50:	00878713          	addi	a4,a5,8
ffffffe000203d54:	f4e43423          	sd	a4,-184(s0)
ffffffe000203d58:	0007a783          	lw	a5,0(a5)
ffffffe000203d5c:	f8f42623          	sw	a5,-116(s0)
ffffffe000203d60:	5e00006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000203d64:	f5043783          	ld	a5,-176(s0)
ffffffe000203d68:	f5040713          	addi	a4,s0,-176
ffffffe000203d6c:	00a00613          	li	a2,10
ffffffe000203d70:	00070593          	mv	a1,a4
ffffffe000203d74:	00078513          	mv	a0,a5
ffffffe000203d78:	80dff0ef          	jal	ra,ffffffe000203584 <strtol>
ffffffe000203d7c:	00050793          	mv	a5,a0
ffffffe000203d80:	0007879b          	sext.w	a5,a5
ffffffe000203d84:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000203d88:	f5043783          	ld	a5,-176(s0)
ffffffe000203d8c:	fff78793          	addi	a5,a5,-1
ffffffe000203d90:	f4f43823          	sd	a5,-176(s0)
ffffffe000203d94:	5ac0006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000203d98:	f5043783          	ld	a5,-176(s0)
ffffffe000203d9c:	0007c783          	lbu	a5,0(a5)
ffffffe000203da0:	00078713          	mv	a4,a5
ffffffe000203da4:	07800793          	li	a5,120
ffffffe000203da8:	02f70663          	beq	a4,a5,ffffffe000203dd4 <vprintfmt+0x254>
ffffffe000203dac:	f5043783          	ld	a5,-176(s0)
ffffffe000203db0:	0007c783          	lbu	a5,0(a5)
ffffffe000203db4:	00078713          	mv	a4,a5
ffffffe000203db8:	05800793          	li	a5,88
ffffffe000203dbc:	00f70c63          	beq	a4,a5,ffffffe000203dd4 <vprintfmt+0x254>
ffffffe000203dc0:	f5043783          	ld	a5,-176(s0)
ffffffe000203dc4:	0007c783          	lbu	a5,0(a5)
ffffffe000203dc8:	00078713          	mv	a4,a5
ffffffe000203dcc:	07000793          	li	a5,112
ffffffe000203dd0:	30f71263          	bne	a4,a5,ffffffe0002040d4 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000203dd4:	f5043783          	ld	a5,-176(s0)
ffffffe000203dd8:	0007c783          	lbu	a5,0(a5)
ffffffe000203ddc:	00078713          	mv	a4,a5
ffffffe000203de0:	07000793          	li	a5,112
ffffffe000203de4:	00f70663          	beq	a4,a5,ffffffe000203df0 <vprintfmt+0x270>
ffffffe000203de8:	f8144783          	lbu	a5,-127(s0)
ffffffe000203dec:	00078663          	beqz	a5,ffffffe000203df8 <vprintfmt+0x278>
ffffffe000203df0:	00100793          	li	a5,1
ffffffe000203df4:	0080006f          	j	ffffffe000203dfc <vprintfmt+0x27c>
ffffffe000203df8:	00000793          	li	a5,0
ffffffe000203dfc:	faf403a3          	sb	a5,-89(s0)
ffffffe000203e00:	fa744783          	lbu	a5,-89(s0)
ffffffe000203e04:	0017f793          	andi	a5,a5,1
ffffffe000203e08:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000203e0c:	fa744783          	lbu	a5,-89(s0)
ffffffe000203e10:	0ff7f793          	zext.b	a5,a5
ffffffe000203e14:	00078c63          	beqz	a5,ffffffe000203e2c <vprintfmt+0x2ac>
ffffffe000203e18:	f4843783          	ld	a5,-184(s0)
ffffffe000203e1c:	00878713          	addi	a4,a5,8
ffffffe000203e20:	f4e43423          	sd	a4,-184(s0)
ffffffe000203e24:	0007b783          	ld	a5,0(a5)
ffffffe000203e28:	01c0006f          	j	ffffffe000203e44 <vprintfmt+0x2c4>
ffffffe000203e2c:	f4843783          	ld	a5,-184(s0)
ffffffe000203e30:	00878713          	addi	a4,a5,8
ffffffe000203e34:	f4e43423          	sd	a4,-184(s0)
ffffffe000203e38:	0007a783          	lw	a5,0(a5)
ffffffe000203e3c:	02079793          	slli	a5,a5,0x20
ffffffe000203e40:	0207d793          	srli	a5,a5,0x20
ffffffe000203e44:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000203e48:	f8c42783          	lw	a5,-116(s0)
ffffffe000203e4c:	02079463          	bnez	a5,ffffffe000203e74 <vprintfmt+0x2f4>
ffffffe000203e50:	fe043783          	ld	a5,-32(s0)
ffffffe000203e54:	02079063          	bnez	a5,ffffffe000203e74 <vprintfmt+0x2f4>
ffffffe000203e58:	f5043783          	ld	a5,-176(s0)
ffffffe000203e5c:	0007c783          	lbu	a5,0(a5)
ffffffe000203e60:	00078713          	mv	a4,a5
ffffffe000203e64:	07000793          	li	a5,112
ffffffe000203e68:	00f70663          	beq	a4,a5,ffffffe000203e74 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000203e6c:	f8040023          	sb	zero,-128(s0)
ffffffe000203e70:	4d00006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000203e74:	f5043783          	ld	a5,-176(s0)
ffffffe000203e78:	0007c783          	lbu	a5,0(a5)
ffffffe000203e7c:	00078713          	mv	a4,a5
ffffffe000203e80:	07000793          	li	a5,112
ffffffe000203e84:	00f70a63          	beq	a4,a5,ffffffe000203e98 <vprintfmt+0x318>
ffffffe000203e88:	f8244783          	lbu	a5,-126(s0)
ffffffe000203e8c:	00078a63          	beqz	a5,ffffffe000203ea0 <vprintfmt+0x320>
ffffffe000203e90:	fe043783          	ld	a5,-32(s0)
ffffffe000203e94:	00078663          	beqz	a5,ffffffe000203ea0 <vprintfmt+0x320>
ffffffe000203e98:	00100793          	li	a5,1
ffffffe000203e9c:	0080006f          	j	ffffffe000203ea4 <vprintfmt+0x324>
ffffffe000203ea0:	00000793          	li	a5,0
ffffffe000203ea4:	faf40323          	sb	a5,-90(s0)
ffffffe000203ea8:	fa644783          	lbu	a5,-90(s0)
ffffffe000203eac:	0017f793          	andi	a5,a5,1
ffffffe000203eb0:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000203eb4:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000203eb8:	f5043783          	ld	a5,-176(s0)
ffffffe000203ebc:	0007c783          	lbu	a5,0(a5)
ffffffe000203ec0:	00078713          	mv	a4,a5
ffffffe000203ec4:	05800793          	li	a5,88
ffffffe000203ec8:	00f71863          	bne	a4,a5,ffffffe000203ed8 <vprintfmt+0x358>
ffffffe000203ecc:	00004797          	auipc	a5,0x4
ffffffe000203ed0:	ae478793          	addi	a5,a5,-1308 # ffffffe0002079b0 <upperxdigits.1>
ffffffe000203ed4:	00c0006f          	j	ffffffe000203ee0 <vprintfmt+0x360>
ffffffe000203ed8:	00004797          	auipc	a5,0x4
ffffffe000203edc:	af078793          	addi	a5,a5,-1296 # ffffffe0002079c8 <lowerxdigits.0>
ffffffe000203ee0:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000203ee4:	fe043783          	ld	a5,-32(s0)
ffffffe000203ee8:	00f7f793          	andi	a5,a5,15
ffffffe000203eec:	f9843703          	ld	a4,-104(s0)
ffffffe000203ef0:	00f70733          	add	a4,a4,a5
ffffffe000203ef4:	fdc42783          	lw	a5,-36(s0)
ffffffe000203ef8:	0017869b          	addiw	a3,a5,1
ffffffe000203efc:	fcd42e23          	sw	a3,-36(s0)
ffffffe000203f00:	00074703          	lbu	a4,0(a4)
ffffffe000203f04:	ff078793          	addi	a5,a5,-16
ffffffe000203f08:	008787b3          	add	a5,a5,s0
ffffffe000203f0c:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000203f10:	fe043783          	ld	a5,-32(s0)
ffffffe000203f14:	0047d793          	srli	a5,a5,0x4
ffffffe000203f18:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000203f1c:	fe043783          	ld	a5,-32(s0)
ffffffe000203f20:	fc0792e3          	bnez	a5,ffffffe000203ee4 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000203f24:	f8c42783          	lw	a5,-116(s0)
ffffffe000203f28:	00078713          	mv	a4,a5
ffffffe000203f2c:	fff00793          	li	a5,-1
ffffffe000203f30:	02f71663          	bne	a4,a5,ffffffe000203f5c <vprintfmt+0x3dc>
ffffffe000203f34:	f8344783          	lbu	a5,-125(s0)
ffffffe000203f38:	02078263          	beqz	a5,ffffffe000203f5c <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000203f3c:	f8842703          	lw	a4,-120(s0)
ffffffe000203f40:	fa644783          	lbu	a5,-90(s0)
ffffffe000203f44:	0007879b          	sext.w	a5,a5
ffffffe000203f48:	0017979b          	slliw	a5,a5,0x1
ffffffe000203f4c:	0007879b          	sext.w	a5,a5
ffffffe000203f50:	40f707bb          	subw	a5,a4,a5
ffffffe000203f54:	0007879b          	sext.w	a5,a5
ffffffe000203f58:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000203f5c:	f8842703          	lw	a4,-120(s0)
ffffffe000203f60:	fa644783          	lbu	a5,-90(s0)
ffffffe000203f64:	0007879b          	sext.w	a5,a5
ffffffe000203f68:	0017979b          	slliw	a5,a5,0x1
ffffffe000203f6c:	0007879b          	sext.w	a5,a5
ffffffe000203f70:	40f707bb          	subw	a5,a4,a5
ffffffe000203f74:	0007871b          	sext.w	a4,a5
ffffffe000203f78:	fdc42783          	lw	a5,-36(s0)
ffffffe000203f7c:	f8f42a23          	sw	a5,-108(s0)
ffffffe000203f80:	f8c42783          	lw	a5,-116(s0)
ffffffe000203f84:	f8f42823          	sw	a5,-112(s0)
ffffffe000203f88:	f9442783          	lw	a5,-108(s0)
ffffffe000203f8c:	00078593          	mv	a1,a5
ffffffe000203f90:	f9042783          	lw	a5,-112(s0)
ffffffe000203f94:	00078613          	mv	a2,a5
ffffffe000203f98:	0006069b          	sext.w	a3,a2
ffffffe000203f9c:	0005879b          	sext.w	a5,a1
ffffffe000203fa0:	00f6d463          	bge	a3,a5,ffffffe000203fa8 <vprintfmt+0x428>
ffffffe000203fa4:	00058613          	mv	a2,a1
ffffffe000203fa8:	0006079b          	sext.w	a5,a2
ffffffe000203fac:	40f707bb          	subw	a5,a4,a5
ffffffe000203fb0:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203fb4:	0280006f          	j	ffffffe000203fdc <vprintfmt+0x45c>
                    putch(' ');
ffffffe000203fb8:	f5843783          	ld	a5,-168(s0)
ffffffe000203fbc:	02000513          	li	a0,32
ffffffe000203fc0:	000780e7          	jalr	a5
                    ++written;
ffffffe000203fc4:	fec42783          	lw	a5,-20(s0)
ffffffe000203fc8:	0017879b          	addiw	a5,a5,1
ffffffe000203fcc:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000203fd0:	fd842783          	lw	a5,-40(s0)
ffffffe000203fd4:	fff7879b          	addiw	a5,a5,-1
ffffffe000203fd8:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203fdc:	fd842783          	lw	a5,-40(s0)
ffffffe000203fe0:	0007879b          	sext.w	a5,a5
ffffffe000203fe4:	fcf04ae3          	bgtz	a5,ffffffe000203fb8 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000203fe8:	fa644783          	lbu	a5,-90(s0)
ffffffe000203fec:	0ff7f793          	zext.b	a5,a5
ffffffe000203ff0:	04078463          	beqz	a5,ffffffe000204038 <vprintfmt+0x4b8>
                    putch('0');
ffffffe000203ff4:	f5843783          	ld	a5,-168(s0)
ffffffe000203ff8:	03000513          	li	a0,48
ffffffe000203ffc:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000204000:	f5043783          	ld	a5,-176(s0)
ffffffe000204004:	0007c783          	lbu	a5,0(a5)
ffffffe000204008:	00078713          	mv	a4,a5
ffffffe00020400c:	05800793          	li	a5,88
ffffffe000204010:	00f71663          	bne	a4,a5,ffffffe00020401c <vprintfmt+0x49c>
ffffffe000204014:	05800793          	li	a5,88
ffffffe000204018:	0080006f          	j	ffffffe000204020 <vprintfmt+0x4a0>
ffffffe00020401c:	07800793          	li	a5,120
ffffffe000204020:	f5843703          	ld	a4,-168(s0)
ffffffe000204024:	00078513          	mv	a0,a5
ffffffe000204028:	000700e7          	jalr	a4
                    written += 2;
ffffffe00020402c:	fec42783          	lw	a5,-20(s0)
ffffffe000204030:	0027879b          	addiw	a5,a5,2
ffffffe000204034:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000204038:	fdc42783          	lw	a5,-36(s0)
ffffffe00020403c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000204040:	0280006f          	j	ffffffe000204068 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000204044:	f5843783          	ld	a5,-168(s0)
ffffffe000204048:	03000513          	li	a0,48
ffffffe00020404c:	000780e7          	jalr	a5
                    ++written;
ffffffe000204050:	fec42783          	lw	a5,-20(s0)
ffffffe000204054:	0017879b          	addiw	a5,a5,1
ffffffe000204058:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe00020405c:	fd442783          	lw	a5,-44(s0)
ffffffe000204060:	0017879b          	addiw	a5,a5,1
ffffffe000204064:	fcf42a23          	sw	a5,-44(s0)
ffffffe000204068:	f8c42703          	lw	a4,-116(s0)
ffffffe00020406c:	fd442783          	lw	a5,-44(s0)
ffffffe000204070:	0007879b          	sext.w	a5,a5
ffffffe000204074:	fce7c8e3          	blt	a5,a4,ffffffe000204044 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000204078:	fdc42783          	lw	a5,-36(s0)
ffffffe00020407c:	fff7879b          	addiw	a5,a5,-1
ffffffe000204080:	fcf42823          	sw	a5,-48(s0)
ffffffe000204084:	03c0006f          	j	ffffffe0002040c0 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000204088:	fd042783          	lw	a5,-48(s0)
ffffffe00020408c:	ff078793          	addi	a5,a5,-16
ffffffe000204090:	008787b3          	add	a5,a5,s0
ffffffe000204094:	f807c783          	lbu	a5,-128(a5)
ffffffe000204098:	0007871b          	sext.w	a4,a5
ffffffe00020409c:	f5843783          	ld	a5,-168(s0)
ffffffe0002040a0:	00070513          	mv	a0,a4
ffffffe0002040a4:	000780e7          	jalr	a5
                    ++written;
ffffffe0002040a8:	fec42783          	lw	a5,-20(s0)
ffffffe0002040ac:	0017879b          	addiw	a5,a5,1
ffffffe0002040b0:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe0002040b4:	fd042783          	lw	a5,-48(s0)
ffffffe0002040b8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002040bc:	fcf42823          	sw	a5,-48(s0)
ffffffe0002040c0:	fd042783          	lw	a5,-48(s0)
ffffffe0002040c4:	0007879b          	sext.w	a5,a5
ffffffe0002040c8:	fc07d0e3          	bgez	a5,ffffffe000204088 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe0002040cc:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe0002040d0:	2700006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe0002040d4:	f5043783          	ld	a5,-176(s0)
ffffffe0002040d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002040dc:	00078713          	mv	a4,a5
ffffffe0002040e0:	06400793          	li	a5,100
ffffffe0002040e4:	02f70663          	beq	a4,a5,ffffffe000204110 <vprintfmt+0x590>
ffffffe0002040e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002040ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002040f0:	00078713          	mv	a4,a5
ffffffe0002040f4:	06900793          	li	a5,105
ffffffe0002040f8:	00f70c63          	beq	a4,a5,ffffffe000204110 <vprintfmt+0x590>
ffffffe0002040fc:	f5043783          	ld	a5,-176(s0)
ffffffe000204100:	0007c783          	lbu	a5,0(a5)
ffffffe000204104:	00078713          	mv	a4,a5
ffffffe000204108:	07500793          	li	a5,117
ffffffe00020410c:	08f71063          	bne	a4,a5,ffffffe00020418c <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000204110:	f8144783          	lbu	a5,-127(s0)
ffffffe000204114:	00078c63          	beqz	a5,ffffffe00020412c <vprintfmt+0x5ac>
ffffffe000204118:	f4843783          	ld	a5,-184(s0)
ffffffe00020411c:	00878713          	addi	a4,a5,8
ffffffe000204120:	f4e43423          	sd	a4,-184(s0)
ffffffe000204124:	0007b783          	ld	a5,0(a5)
ffffffe000204128:	0140006f          	j	ffffffe00020413c <vprintfmt+0x5bc>
ffffffe00020412c:	f4843783          	ld	a5,-184(s0)
ffffffe000204130:	00878713          	addi	a4,a5,8
ffffffe000204134:	f4e43423          	sd	a4,-184(s0)
ffffffe000204138:	0007a783          	lw	a5,0(a5)
ffffffe00020413c:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000204140:	fa843583          	ld	a1,-88(s0)
ffffffe000204144:	f5043783          	ld	a5,-176(s0)
ffffffe000204148:	0007c783          	lbu	a5,0(a5)
ffffffe00020414c:	0007871b          	sext.w	a4,a5
ffffffe000204150:	07500793          	li	a5,117
ffffffe000204154:	40f707b3          	sub	a5,a4,a5
ffffffe000204158:	00f037b3          	snez	a5,a5
ffffffe00020415c:	0ff7f793          	zext.b	a5,a5
ffffffe000204160:	f8040713          	addi	a4,s0,-128
ffffffe000204164:	00070693          	mv	a3,a4
ffffffe000204168:	00078613          	mv	a2,a5
ffffffe00020416c:	f5843503          	ld	a0,-168(s0)
ffffffe000204170:	f08ff0ef          	jal	ra,ffffffe000203878 <print_dec_int>
ffffffe000204174:	00050793          	mv	a5,a0
ffffffe000204178:	fec42703          	lw	a4,-20(s0)
ffffffe00020417c:	00f707bb          	addw	a5,a4,a5
ffffffe000204180:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000204184:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000204188:	1b80006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe00020418c:	f5043783          	ld	a5,-176(s0)
ffffffe000204190:	0007c783          	lbu	a5,0(a5)
ffffffe000204194:	00078713          	mv	a4,a5
ffffffe000204198:	06e00793          	li	a5,110
ffffffe00020419c:	04f71c63          	bne	a4,a5,ffffffe0002041f4 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe0002041a0:	f8144783          	lbu	a5,-127(s0)
ffffffe0002041a4:	02078463          	beqz	a5,ffffffe0002041cc <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe0002041a8:	f4843783          	ld	a5,-184(s0)
ffffffe0002041ac:	00878713          	addi	a4,a5,8
ffffffe0002041b0:	f4e43423          	sd	a4,-184(s0)
ffffffe0002041b4:	0007b783          	ld	a5,0(a5)
ffffffe0002041b8:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe0002041bc:	fec42703          	lw	a4,-20(s0)
ffffffe0002041c0:	fb043783          	ld	a5,-80(s0)
ffffffe0002041c4:	00e7b023          	sd	a4,0(a5)
ffffffe0002041c8:	0240006f          	j	ffffffe0002041ec <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe0002041cc:	f4843783          	ld	a5,-184(s0)
ffffffe0002041d0:	00878713          	addi	a4,a5,8
ffffffe0002041d4:	f4e43423          	sd	a4,-184(s0)
ffffffe0002041d8:	0007b783          	ld	a5,0(a5)
ffffffe0002041dc:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe0002041e0:	fb843783          	ld	a5,-72(s0)
ffffffe0002041e4:	fec42703          	lw	a4,-20(s0)
ffffffe0002041e8:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe0002041ec:	f8040023          	sb	zero,-128(s0)
ffffffe0002041f0:	1500006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe0002041f4:	f5043783          	ld	a5,-176(s0)
ffffffe0002041f8:	0007c783          	lbu	a5,0(a5)
ffffffe0002041fc:	00078713          	mv	a4,a5
ffffffe000204200:	07300793          	li	a5,115
ffffffe000204204:	02f71e63          	bne	a4,a5,ffffffe000204240 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000204208:	f4843783          	ld	a5,-184(s0)
ffffffe00020420c:	00878713          	addi	a4,a5,8
ffffffe000204210:	f4e43423          	sd	a4,-184(s0)
ffffffe000204214:	0007b783          	ld	a5,0(a5)
ffffffe000204218:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe00020421c:	fc043583          	ld	a1,-64(s0)
ffffffe000204220:	f5843503          	ld	a0,-168(s0)
ffffffe000204224:	dccff0ef          	jal	ra,ffffffe0002037f0 <puts_wo_nl>
ffffffe000204228:	00050793          	mv	a5,a0
ffffffe00020422c:	fec42703          	lw	a4,-20(s0)
ffffffe000204230:	00f707bb          	addw	a5,a4,a5
ffffffe000204234:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000204238:	f8040023          	sb	zero,-128(s0)
ffffffe00020423c:	1040006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000204240:	f5043783          	ld	a5,-176(s0)
ffffffe000204244:	0007c783          	lbu	a5,0(a5)
ffffffe000204248:	00078713          	mv	a4,a5
ffffffe00020424c:	06300793          	li	a5,99
ffffffe000204250:	02f71e63          	bne	a4,a5,ffffffe00020428c <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000204254:	f4843783          	ld	a5,-184(s0)
ffffffe000204258:	00878713          	addi	a4,a5,8
ffffffe00020425c:	f4e43423          	sd	a4,-184(s0)
ffffffe000204260:	0007a783          	lw	a5,0(a5)
ffffffe000204264:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000204268:	fcc42703          	lw	a4,-52(s0)
ffffffe00020426c:	f5843783          	ld	a5,-168(s0)
ffffffe000204270:	00070513          	mv	a0,a4
ffffffe000204274:	000780e7          	jalr	a5
                ++written;
ffffffe000204278:	fec42783          	lw	a5,-20(s0)
ffffffe00020427c:	0017879b          	addiw	a5,a5,1
ffffffe000204280:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000204284:	f8040023          	sb	zero,-128(s0)
ffffffe000204288:	0b80006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe00020428c:	f5043783          	ld	a5,-176(s0)
ffffffe000204290:	0007c783          	lbu	a5,0(a5)
ffffffe000204294:	00078713          	mv	a4,a5
ffffffe000204298:	02500793          	li	a5,37
ffffffe00020429c:	02f71263          	bne	a4,a5,ffffffe0002042c0 <vprintfmt+0x740>
                putch('%');
ffffffe0002042a0:	f5843783          	ld	a5,-168(s0)
ffffffe0002042a4:	02500513          	li	a0,37
ffffffe0002042a8:	000780e7          	jalr	a5
                ++written;
ffffffe0002042ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002042b0:	0017879b          	addiw	a5,a5,1
ffffffe0002042b4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002042b8:	f8040023          	sb	zero,-128(s0)
ffffffe0002042bc:	0840006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe0002042c0:	f5043783          	ld	a5,-176(s0)
ffffffe0002042c4:	0007c783          	lbu	a5,0(a5)
ffffffe0002042c8:	0007871b          	sext.w	a4,a5
ffffffe0002042cc:	f5843783          	ld	a5,-168(s0)
ffffffe0002042d0:	00070513          	mv	a0,a4
ffffffe0002042d4:	000780e7          	jalr	a5
                ++written;
ffffffe0002042d8:	fec42783          	lw	a5,-20(s0)
ffffffe0002042dc:	0017879b          	addiw	a5,a5,1
ffffffe0002042e0:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002042e4:	f8040023          	sb	zero,-128(s0)
ffffffe0002042e8:	0580006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe0002042ec:	f5043783          	ld	a5,-176(s0)
ffffffe0002042f0:	0007c783          	lbu	a5,0(a5)
ffffffe0002042f4:	00078713          	mv	a4,a5
ffffffe0002042f8:	02500793          	li	a5,37
ffffffe0002042fc:	02f71063          	bne	a4,a5,ffffffe00020431c <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe000204300:	f8043023          	sd	zero,-128(s0)
ffffffe000204304:	f8043423          	sd	zero,-120(s0)
ffffffe000204308:	00100793          	li	a5,1
ffffffe00020430c:	f8f40023          	sb	a5,-128(s0)
ffffffe000204310:	fff00793          	li	a5,-1
ffffffe000204314:	f8f42623          	sw	a5,-116(s0)
ffffffe000204318:	0280006f          	j	ffffffe000204340 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe00020431c:	f5043783          	ld	a5,-176(s0)
ffffffe000204320:	0007c783          	lbu	a5,0(a5)
ffffffe000204324:	0007871b          	sext.w	a4,a5
ffffffe000204328:	f5843783          	ld	a5,-168(s0)
ffffffe00020432c:	00070513          	mv	a0,a4
ffffffe000204330:	000780e7          	jalr	a5
            ++written;
ffffffe000204334:	fec42783          	lw	a5,-20(s0)
ffffffe000204338:	0017879b          	addiw	a5,a5,1
ffffffe00020433c:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000204340:	f5043783          	ld	a5,-176(s0)
ffffffe000204344:	00178793          	addi	a5,a5,1
ffffffe000204348:	f4f43823          	sd	a5,-176(s0)
ffffffe00020434c:	f5043783          	ld	a5,-176(s0)
ffffffe000204350:	0007c783          	lbu	a5,0(a5)
ffffffe000204354:	84079ce3          	bnez	a5,ffffffe000203bac <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000204358:	fec42783          	lw	a5,-20(s0)
}
ffffffe00020435c:	00078513          	mv	a0,a5
ffffffe000204360:	0b813083          	ld	ra,184(sp)
ffffffe000204364:	0b013403          	ld	s0,176(sp)
ffffffe000204368:	0c010113          	addi	sp,sp,192
ffffffe00020436c:	00008067          	ret

ffffffe000204370 <printk>:

int printk(const char* s, ...) {
ffffffe000204370:	f9010113          	addi	sp,sp,-112
ffffffe000204374:	02113423          	sd	ra,40(sp)
ffffffe000204378:	02813023          	sd	s0,32(sp)
ffffffe00020437c:	03010413          	addi	s0,sp,48
ffffffe000204380:	fca43c23          	sd	a0,-40(s0)
ffffffe000204384:	00b43423          	sd	a1,8(s0)
ffffffe000204388:	00c43823          	sd	a2,16(s0)
ffffffe00020438c:	00d43c23          	sd	a3,24(s0)
ffffffe000204390:	02e43023          	sd	a4,32(s0)
ffffffe000204394:	02f43423          	sd	a5,40(s0)
ffffffe000204398:	03043823          	sd	a6,48(s0)
ffffffe00020439c:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe0002043a0:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe0002043a4:	04040793          	addi	a5,s0,64
ffffffe0002043a8:	fcf43823          	sd	a5,-48(s0)
ffffffe0002043ac:	fd043783          	ld	a5,-48(s0)
ffffffe0002043b0:	fc878793          	addi	a5,a5,-56
ffffffe0002043b4:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe0002043b8:	fe043783          	ld	a5,-32(s0)
ffffffe0002043bc:	00078613          	mv	a2,a5
ffffffe0002043c0:	fd843583          	ld	a1,-40(s0)
ffffffe0002043c4:	fffff517          	auipc	a0,0xfffff
ffffffe0002043c8:	11850513          	addi	a0,a0,280 # ffffffe0002034dc <putc>
ffffffe0002043cc:	fb4ff0ef          	jal	ra,ffffffe000203b80 <vprintfmt>
ffffffe0002043d0:	00050793          	mv	a5,a0
ffffffe0002043d4:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe0002043d8:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002043dc:	00078513          	mv	a0,a5
ffffffe0002043e0:	02813083          	ld	ra,40(sp)
ffffffe0002043e4:	02013403          	ld	s0,32(sp)
ffffffe0002043e8:	07010113          	addi	sp,sp,112
ffffffe0002043ec:	00008067          	ret

ffffffe0002043f0 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe0002043f0:	fe010113          	addi	sp,sp,-32
ffffffe0002043f4:	00813c23          	sd	s0,24(sp)
ffffffe0002043f8:	02010413          	addi	s0,sp,32
ffffffe0002043fc:	00050793          	mv	a5,a0
ffffffe000204400:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe000204404:	fec42783          	lw	a5,-20(s0)
ffffffe000204408:	fff7879b          	addiw	a5,a5,-1
ffffffe00020440c:	0007879b          	sext.w	a5,a5
ffffffe000204410:	02079713          	slli	a4,a5,0x20
ffffffe000204414:	02075713          	srli	a4,a4,0x20
ffffffe000204418:	00009797          	auipc	a5,0x9
ffffffe00020441c:	c0878793          	addi	a5,a5,-1016 # ffffffe00020d020 <seed>
ffffffe000204420:	00e7b023          	sd	a4,0(a5)
}
ffffffe000204424:	00000013          	nop
ffffffe000204428:	01813403          	ld	s0,24(sp)
ffffffe00020442c:	02010113          	addi	sp,sp,32
ffffffe000204430:	00008067          	ret

ffffffe000204434 <rand>:

int rand(void) {
ffffffe000204434:	ff010113          	addi	sp,sp,-16
ffffffe000204438:	00813423          	sd	s0,8(sp)
ffffffe00020443c:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000204440:	00009797          	auipc	a5,0x9
ffffffe000204444:	be078793          	addi	a5,a5,-1056 # ffffffe00020d020 <seed>
ffffffe000204448:	0007b703          	ld	a4,0(a5)
ffffffe00020444c:	00003797          	auipc	a5,0x3
ffffffe000204450:	59478793          	addi	a5,a5,1428 # ffffffe0002079e0 <lowerxdigits.0+0x18>
ffffffe000204454:	0007b783          	ld	a5,0(a5)
ffffffe000204458:	02f707b3          	mul	a5,a4,a5
ffffffe00020445c:	00178713          	addi	a4,a5,1
ffffffe000204460:	00009797          	auipc	a5,0x9
ffffffe000204464:	bc078793          	addi	a5,a5,-1088 # ffffffe00020d020 <seed>
ffffffe000204468:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe00020446c:	00009797          	auipc	a5,0x9
ffffffe000204470:	bb478793          	addi	a5,a5,-1100 # ffffffe00020d020 <seed>
ffffffe000204474:	0007b783          	ld	a5,0(a5)
ffffffe000204478:	0217d793          	srli	a5,a5,0x21
ffffffe00020447c:	0007879b          	sext.w	a5,a5
}
ffffffe000204480:	00078513          	mv	a0,a5
ffffffe000204484:	00813403          	ld	s0,8(sp)
ffffffe000204488:	01010113          	addi	sp,sp,16
ffffffe00020448c:	00008067          	ret

ffffffe000204490 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000204490:	fc010113          	addi	sp,sp,-64
ffffffe000204494:	02813c23          	sd	s0,56(sp)
ffffffe000204498:	04010413          	addi	s0,sp,64
ffffffe00020449c:	fca43c23          	sd	a0,-40(s0)
ffffffe0002044a0:	00058793          	mv	a5,a1
ffffffe0002044a4:	fcc43423          	sd	a2,-56(s0)
ffffffe0002044a8:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe0002044ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002044b0:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002044b4:	fe043423          	sd	zero,-24(s0)
ffffffe0002044b8:	0280006f          	j	ffffffe0002044e0 <memset+0x50>
        s[i] = c;
ffffffe0002044bc:	fe043703          	ld	a4,-32(s0)
ffffffe0002044c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002044c4:	00f707b3          	add	a5,a4,a5
ffffffe0002044c8:	fd442703          	lw	a4,-44(s0)
ffffffe0002044cc:	0ff77713          	zext.b	a4,a4
ffffffe0002044d0:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002044d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002044d8:	00178793          	addi	a5,a5,1
ffffffe0002044dc:	fef43423          	sd	a5,-24(s0)
ffffffe0002044e0:	fe843703          	ld	a4,-24(s0)
ffffffe0002044e4:	fc843783          	ld	a5,-56(s0)
ffffffe0002044e8:	fcf76ae3          	bltu	a4,a5,ffffffe0002044bc <memset+0x2c>
    }
    return dest;
ffffffe0002044ec:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002044f0:	00078513          	mv	a0,a5
ffffffe0002044f4:	03813403          	ld	s0,56(sp)
ffffffe0002044f8:	04010113          	addi	sp,sp,64
ffffffe0002044fc:	00008067          	ret

ffffffe000204500 <memcpy>:

void *memcpy(void *dest, const void *src, uint64_t n) {
ffffffe000204500:	fb010113          	addi	sp,sp,-80
ffffffe000204504:	04813423          	sd	s0,72(sp)
ffffffe000204508:	05010413          	addi	s0,sp,80
ffffffe00020450c:	fca43423          	sd	a0,-56(s0)
ffffffe000204510:	fcb43023          	sd	a1,-64(s0)
ffffffe000204514:	fac43c23          	sd	a2,-72(s0)
    char *d = (char *)dest;
ffffffe000204518:	fc843783          	ld	a5,-56(s0)
ffffffe00020451c:	fef43023          	sd	a5,-32(s0)
    const char *s = (const char *)src;
ffffffe000204520:	fc043783          	ld	a5,-64(s0)
ffffffe000204524:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000204528:	fe043423          	sd	zero,-24(s0)
ffffffe00020452c:	0300006f          	j	ffffffe00020455c <memcpy+0x5c>
        d[i] = s[i];
ffffffe000204530:	fd843703          	ld	a4,-40(s0)
ffffffe000204534:	fe843783          	ld	a5,-24(s0)
ffffffe000204538:	00f70733          	add	a4,a4,a5
ffffffe00020453c:	fe043683          	ld	a3,-32(s0)
ffffffe000204540:	fe843783          	ld	a5,-24(s0)
ffffffe000204544:	00f687b3          	add	a5,a3,a5
ffffffe000204548:	00074703          	lbu	a4,0(a4)
ffffffe00020454c:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000204550:	fe843783          	ld	a5,-24(s0)
ffffffe000204554:	00178793          	addi	a5,a5,1
ffffffe000204558:	fef43423          	sd	a5,-24(s0)
ffffffe00020455c:	fe843703          	ld	a4,-24(s0)
ffffffe000204560:	fb843783          	ld	a5,-72(s0)
ffffffe000204564:	fcf766e3          	bltu	a4,a5,ffffffe000204530 <memcpy+0x30>
    }
    return dest;
ffffffe000204568:	fc843783          	ld	a5,-56(s0)
}
ffffffe00020456c:	00078513          	mv	a0,a5
ffffffe000204570:	04813403          	ld	s0,72(sp)
ffffffe000204574:	05010113          	addi	sp,sp,80
ffffffe000204578:	00008067          	ret

ffffffe00020457c <memcmp>:

uint64_t memcmp(const void *s1, const void *s2, size_t n) {
ffffffe00020457c:	fb010113          	addi	sp,sp,-80
ffffffe000204580:	04813423          	sd	s0,72(sp)
ffffffe000204584:	05010413          	addi	s0,sp,80
ffffffe000204588:	fca43423          	sd	a0,-56(s0)
ffffffe00020458c:	fcb43023          	sd	a1,-64(s0)
ffffffe000204590:	fac43c23          	sd	a2,-72(s0)
    const unsigned char *p1 = (const unsigned char *)s1;
ffffffe000204594:	fc843783          	ld	a5,-56(s0)
ffffffe000204598:	fef43023          	sd	a5,-32(s0)
    const unsigned char *p2 = (const unsigned char *)s2;
ffffffe00020459c:	fc043783          	ld	a5,-64(s0)
ffffffe0002045a0:	fcf43c23          	sd	a5,-40(s0)

    for (size_t i = 0; i < n; i++) {
ffffffe0002045a4:	fe043423          	sd	zero,-24(s0)
ffffffe0002045a8:	06c0006f          	j	ffffffe000204614 <memcmp+0x98>
        if (p1[i] != p2[i]) {
ffffffe0002045ac:	fe043703          	ld	a4,-32(s0)
ffffffe0002045b0:	fe843783          	ld	a5,-24(s0)
ffffffe0002045b4:	00f707b3          	add	a5,a4,a5
ffffffe0002045b8:	0007c683          	lbu	a3,0(a5)
ffffffe0002045bc:	fd843703          	ld	a4,-40(s0)
ffffffe0002045c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002045c4:	00f707b3          	add	a5,a4,a5
ffffffe0002045c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002045cc:	00068713          	mv	a4,a3
ffffffe0002045d0:	02f70c63          	beq	a4,a5,ffffffe000204608 <memcmp+0x8c>
            return p1[i] - p2[i];
ffffffe0002045d4:	fe043703          	ld	a4,-32(s0)
ffffffe0002045d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002045dc:	00f707b3          	add	a5,a4,a5
ffffffe0002045e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002045e4:	0007871b          	sext.w	a4,a5
ffffffe0002045e8:	fd843683          	ld	a3,-40(s0)
ffffffe0002045ec:	fe843783          	ld	a5,-24(s0)
ffffffe0002045f0:	00f687b3          	add	a5,a3,a5
ffffffe0002045f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002045f8:	0007879b          	sext.w	a5,a5
ffffffe0002045fc:	40f707bb          	subw	a5,a4,a5
ffffffe000204600:	0007879b          	sext.w	a5,a5
ffffffe000204604:	0200006f          	j	ffffffe000204624 <memcmp+0xa8>
    for (size_t i = 0; i < n; i++) {
ffffffe000204608:	fe843783          	ld	a5,-24(s0)
ffffffe00020460c:	00178793          	addi	a5,a5,1
ffffffe000204610:	fef43423          	sd	a5,-24(s0)
ffffffe000204614:	fe843703          	ld	a4,-24(s0)
ffffffe000204618:	fb843783          	ld	a5,-72(s0)
ffffffe00020461c:	f8f768e3          	bltu	a4,a5,ffffffe0002045ac <memcmp+0x30>
        }
    }
    return 0;
ffffffe000204620:	00000793          	li	a5,0
}
ffffffe000204624:	00078513          	mv	a0,a5
ffffffe000204628:	04813403          	ld	s0,72(sp)
ffffffe00020462c:	05010113          	addi	sp,sp,80
ffffffe000204630:	00008067          	ret

ffffffe000204634 <strlen>:

size_t strlen(const char *s) {
ffffffe000204634:	fd010113          	addi	sp,sp,-48
ffffffe000204638:	02813423          	sd	s0,40(sp)
ffffffe00020463c:	03010413          	addi	s0,sp,48
ffffffe000204640:	fca43c23          	sd	a0,-40(s0)
    size_t len = 0;
ffffffe000204644:	fe043423          	sd	zero,-24(s0)
    while (s[len] != '\0') {
ffffffe000204648:	0100006f          	j	ffffffe000204658 <strlen+0x24>
        len++;
ffffffe00020464c:	fe843783          	ld	a5,-24(s0)
ffffffe000204650:	00178793          	addi	a5,a5,1
ffffffe000204654:	fef43423          	sd	a5,-24(s0)
    while (s[len] != '\0') {
ffffffe000204658:	fd843703          	ld	a4,-40(s0)
ffffffe00020465c:	fe843783          	ld	a5,-24(s0)
ffffffe000204660:	00f707b3          	add	a5,a4,a5
ffffffe000204664:	0007c783          	lbu	a5,0(a5)
ffffffe000204668:	fe0792e3          	bnez	a5,ffffffe00020464c <strlen+0x18>
    }
    return len;
ffffffe00020466c:	fe843783          	ld	a5,-24(s0)
ffffffe000204670:	00078513          	mv	a0,a5
ffffffe000204674:	02813403          	ld	s0,40(sp)
ffffffe000204678:	03010113          	addi	sp,sp,48
ffffffe00020467c:	00008067          	ret

ffffffe000204680 <cluster_to_sector>:
struct fat32_volume fat32_volume;

uint8_t fat32_buf[VIRTIO_BLK_SECTOR_SIZE];
uint8_t fat32_table_buf[VIRTIO_BLK_SECTOR_SIZE];

uint64_t cluster_to_sector(uint64_t cluster) {
ffffffe000204680:	fe010113          	addi	sp,sp,-32
ffffffe000204684:	00813c23          	sd	s0,24(sp)
ffffffe000204688:	02010413          	addi	s0,sp,32
ffffffe00020468c:	fea43423          	sd	a0,-24(s0)
    return (cluster - 2) * fat32_volume.sec_per_cluster + fat32_volume.first_data_sec;
ffffffe000204690:	fe843783          	ld	a5,-24(s0)
ffffffe000204694:	ffe78713          	addi	a4,a5,-2
ffffffe000204698:	0000c797          	auipc	a5,0xc
ffffffe00020469c:	b6878793          	addi	a5,a5,-1176 # ffffffe000210200 <fat32_volume>
ffffffe0002046a0:	0107b783          	ld	a5,16(a5)
ffffffe0002046a4:	02f70733          	mul	a4,a4,a5
ffffffe0002046a8:	0000c797          	auipc	a5,0xc
ffffffe0002046ac:	b5878793          	addi	a5,a5,-1192 # ffffffe000210200 <fat32_volume>
ffffffe0002046b0:	0007b783          	ld	a5,0(a5)
ffffffe0002046b4:	00f707b3          	add	a5,a4,a5
}
ffffffe0002046b8:	00078513          	mv	a0,a5
ffffffe0002046bc:	01813403          	ld	s0,24(sp)
ffffffe0002046c0:	02010113          	addi	sp,sp,32
ffffffe0002046c4:	00008067          	ret

ffffffe0002046c8 <sector_to_cluster>:

uint32_t sector_to_cluster(uint64_t sector) {
ffffffe0002046c8:	fe010113          	addi	sp,sp,-32
ffffffe0002046cc:	00813c23          	sd	s0,24(sp)
ffffffe0002046d0:	02010413          	addi	s0,sp,32
ffffffe0002046d4:	fea43423          	sd	a0,-24(s0)
    return (sector - fat32_volume.first_data_sec) / fat32_volume.sec_per_cluster + 2;
ffffffe0002046d8:	0000c797          	auipc	a5,0xc
ffffffe0002046dc:	b2878793          	addi	a5,a5,-1240 # ffffffe000210200 <fat32_volume>
ffffffe0002046e0:	0007b783          	ld	a5,0(a5)
ffffffe0002046e4:	fe843703          	ld	a4,-24(s0)
ffffffe0002046e8:	40f70733          	sub	a4,a4,a5
ffffffe0002046ec:	0000c797          	auipc	a5,0xc
ffffffe0002046f0:	b1478793          	addi	a5,a5,-1260 # ffffffe000210200 <fat32_volume>
ffffffe0002046f4:	0107b783          	ld	a5,16(a5)
ffffffe0002046f8:	02f757b3          	divu	a5,a4,a5
ffffffe0002046fc:	0007879b          	sext.w	a5,a5
ffffffe000204700:	0027879b          	addiw	a5,a5,2
ffffffe000204704:	0007879b          	sext.w	a5,a5
}
ffffffe000204708:	00078513          	mv	a0,a5
ffffffe00020470c:	01813403          	ld	s0,24(sp)
ffffffe000204710:	02010113          	addi	sp,sp,32
ffffffe000204714:	00008067          	ret

ffffffe000204718 <next_cluster>:

uint32_t next_cluster(uint64_t cluster) {
ffffffe000204718:	fc010113          	addi	sp,sp,-64
ffffffe00020471c:	02113c23          	sd	ra,56(sp)
ffffffe000204720:	02813823          	sd	s0,48(sp)
ffffffe000204724:	04010413          	addi	s0,sp,64
ffffffe000204728:	fca43423          	sd	a0,-56(s0)
    uint64_t fat_offset = cluster * 4; // 每个簇在 FAT 表中占用 4 字节
ffffffe00020472c:	fc843783          	ld	a5,-56(s0)
ffffffe000204730:	00279793          	slli	a5,a5,0x2
ffffffe000204734:	fef43423          	sd	a5,-24(s0)
    uint64_t fat_sector = fat32_volume.first_fat_sec + fat_offset / VIRTIO_BLK_SECTOR_SIZE;
ffffffe000204738:	0000c797          	auipc	a5,0xc
ffffffe00020473c:	ac878793          	addi	a5,a5,-1336 # ffffffe000210200 <fat32_volume>
ffffffe000204740:	0087b703          	ld	a4,8(a5)
ffffffe000204744:	fe843783          	ld	a5,-24(s0)
ffffffe000204748:	0097d793          	srli	a5,a5,0x9
ffffffe00020474c:	00f707b3          	add	a5,a4,a5
ffffffe000204750:	fef43023          	sd	a5,-32(s0)
    virtio_blk_read_sector(fat_sector, fat32_table_buf);
ffffffe000204754:	0000c597          	auipc	a1,0xc
ffffffe000204758:	ccc58593          	addi	a1,a1,-820 # ffffffe000210420 <fat32_table_buf>
ffffffe00020475c:	fe043503          	ld	a0,-32(s0)
ffffffe000204760:	4c5010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
    int index_in_sector = fat_offset % (VIRTIO_BLK_SECTOR_SIZE / sizeof(uint32_t)); // 扇区内偏移量
ffffffe000204764:	fe843783          	ld	a5,-24(s0)
ffffffe000204768:	0007879b          	sext.w	a5,a5
ffffffe00020476c:	07f7f793          	andi	a5,a5,127
ffffffe000204770:	fcf42e23          	sw	a5,-36(s0)
    return *(uint32_t*)(fat32_table_buf + index_in_sector);
ffffffe000204774:	fdc42703          	lw	a4,-36(s0)
ffffffe000204778:	0000c797          	auipc	a5,0xc
ffffffe00020477c:	ca878793          	addi	a5,a5,-856 # ffffffe000210420 <fat32_table_buf>
ffffffe000204780:	00f707b3          	add	a5,a4,a5
ffffffe000204784:	0007a783          	lw	a5,0(a5)
}
ffffffe000204788:	00078513          	mv	a0,a5
ffffffe00020478c:	03813083          	ld	ra,56(sp)
ffffffe000204790:	03013403          	ld	s0,48(sp)
ffffffe000204794:	04010113          	addi	sp,sp,64
ffffffe000204798:	00008067          	ret

ffffffe00020479c <fat32_init>:

void fat32_init(uint64_t lba, uint64_t size) {
ffffffe00020479c:	fe010113          	addi	sp,sp,-32
ffffffe0002047a0:	00113c23          	sd	ra,24(sp)
ffffffe0002047a4:	00813823          	sd	s0,16(sp)
ffffffe0002047a8:	02010413          	addi	s0,sp,32
ffffffe0002047ac:	fea43423          	sd	a0,-24(s0)
ffffffe0002047b0:	feb43023          	sd	a1,-32(s0)
    virtio_blk_read_sector(lba, (void*)&fat32_header);
ffffffe0002047b4:	0000c597          	auipc	a1,0xc
ffffffe0002047b8:	84c58593          	addi	a1,a1,-1972 # ffffffe000210000 <fat32_header>
ffffffe0002047bc:	fe843503          	ld	a0,-24(s0)
ffffffe0002047c0:	465010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>

    fat32_volume.first_fat_sec = lba + fat32_header.rsvd_sec_cnt;/* to calculate */
ffffffe0002047c4:	0000c797          	auipc	a5,0xc
ffffffe0002047c8:	83c78793          	addi	a5,a5,-1988 # ffffffe000210000 <fat32_header>
ffffffe0002047cc:	00e7d783          	lhu	a5,14(a5)
ffffffe0002047d0:	00078713          	mv	a4,a5
ffffffe0002047d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002047d8:	00f70733          	add	a4,a4,a5
ffffffe0002047dc:	0000c797          	auipc	a5,0xc
ffffffe0002047e0:	a2478793          	addi	a5,a5,-1500 # ffffffe000210200 <fat32_volume>
ffffffe0002047e4:	00e7b423          	sd	a4,8(a5)
    fat32_volume.sec_per_cluster = fat32_header.sec_per_clus;/* to calculate */
ffffffe0002047e8:	0000c797          	auipc	a5,0xc
ffffffe0002047ec:	81878793          	addi	a5,a5,-2024 # ffffffe000210000 <fat32_header>
ffffffe0002047f0:	00d7c783          	lbu	a5,13(a5)
ffffffe0002047f4:	00078713          	mv	a4,a5
ffffffe0002047f8:	0000c797          	auipc	a5,0xc
ffffffe0002047fc:	a0878793          	addi	a5,a5,-1528 # ffffffe000210200 <fat32_volume>
ffffffe000204800:	00e7b823          	sd	a4,16(a5)
    fat32_volume.first_data_sec = fat32_volume.first_fat_sec + fat32_header.num_fats * fat32_header.fat_sz32;/* to calculate */
ffffffe000204804:	0000c797          	auipc	a5,0xc
ffffffe000204808:	9fc78793          	addi	a5,a5,-1540 # ffffffe000210200 <fat32_volume>
ffffffe00020480c:	0087b703          	ld	a4,8(a5)
ffffffe000204810:	0000b797          	auipc	a5,0xb
ffffffe000204814:	7f078793          	addi	a5,a5,2032 # ffffffe000210000 <fat32_header>
ffffffe000204818:	0107c783          	lbu	a5,16(a5)
ffffffe00020481c:	0007869b          	sext.w	a3,a5
ffffffe000204820:	0000b797          	auipc	a5,0xb
ffffffe000204824:	7e078793          	addi	a5,a5,2016 # ffffffe000210000 <fat32_header>
ffffffe000204828:	0247a783          	lw	a5,36(a5)
ffffffe00020482c:	02f687bb          	mulw	a5,a3,a5
ffffffe000204830:	0007879b          	sext.w	a5,a5
ffffffe000204834:	02079793          	slli	a5,a5,0x20
ffffffe000204838:	0207d793          	srli	a5,a5,0x20
ffffffe00020483c:	00f70733          	add	a4,a4,a5
ffffffe000204840:	0000c797          	auipc	a5,0xc
ffffffe000204844:	9c078793          	addi	a5,a5,-1600 # ffffffe000210200 <fat32_volume>
ffffffe000204848:	00e7b023          	sd	a4,0(a5)
    fat32_volume.fat_sz = fat32_header.fat_sz32;/* to calculate */
ffffffe00020484c:	0000b797          	auipc	a5,0xb
ffffffe000204850:	7b478793          	addi	a5,a5,1972 # ffffffe000210000 <fat32_header>
ffffffe000204854:	0247a783          	lw	a5,36(a5)
ffffffe000204858:	02079713          	slli	a4,a5,0x20
ffffffe00020485c:	02075713          	srli	a4,a4,0x20
ffffffe000204860:	0000c797          	auipc	a5,0xc
ffffffe000204864:	9a078793          	addi	a5,a5,-1632 # ffffffe000210200 <fat32_volume>
ffffffe000204868:	00e7bc23          	sd	a4,24(a5)

    Log("FAT32 Volume Info:");
ffffffe00020486c:	00003697          	auipc	a3,0x3
ffffffe000204870:	37468693          	addi	a3,a3,884 # ffffffe000207be0 <__func__.2>
ffffffe000204874:	02600613          	li	a2,38
ffffffe000204878:	00003597          	auipc	a1,0x3
ffffffe00020487c:	17058593          	addi	a1,a1,368 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204880:	00003517          	auipc	a0,0x3
ffffffe000204884:	17050513          	addi	a0,a0,368 # ffffffe0002079f0 <lowerxdigits.0+0x28>
ffffffe000204888:	ae9ff0ef          	jal	ra,ffffffe000204370 <printk>
    Log("  First FAT Sector: %llu", fat32_volume.first_fat_sec);
ffffffe00020488c:	0000c797          	auipc	a5,0xc
ffffffe000204890:	97478793          	addi	a5,a5,-1676 # ffffffe000210200 <fat32_volume>
ffffffe000204894:	0087b783          	ld	a5,8(a5)
ffffffe000204898:	00078713          	mv	a4,a5
ffffffe00020489c:	00003697          	auipc	a3,0x3
ffffffe0002048a0:	34468693          	addi	a3,a3,836 # ffffffe000207be0 <__func__.2>
ffffffe0002048a4:	02700613          	li	a2,39
ffffffe0002048a8:	00003597          	auipc	a1,0x3
ffffffe0002048ac:	14058593          	addi	a1,a1,320 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe0002048b0:	00003517          	auipc	a0,0x3
ffffffe0002048b4:	17050513          	addi	a0,a0,368 # ffffffe000207a20 <lowerxdigits.0+0x58>
ffffffe0002048b8:	ab9ff0ef          	jal	ra,ffffffe000204370 <printk>
    Log("  Sector per Cluster: %llu", fat32_volume.sec_per_cluster);
ffffffe0002048bc:	0000c797          	auipc	a5,0xc
ffffffe0002048c0:	94478793          	addi	a5,a5,-1724 # ffffffe000210200 <fat32_volume>
ffffffe0002048c4:	0107b783          	ld	a5,16(a5)
ffffffe0002048c8:	00078713          	mv	a4,a5
ffffffe0002048cc:	00003697          	auipc	a3,0x3
ffffffe0002048d0:	31468693          	addi	a3,a3,788 # ffffffe000207be0 <__func__.2>
ffffffe0002048d4:	02800613          	li	a2,40
ffffffe0002048d8:	00003597          	auipc	a1,0x3
ffffffe0002048dc:	11058593          	addi	a1,a1,272 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe0002048e0:	00003517          	auipc	a0,0x3
ffffffe0002048e4:	17050513          	addi	a0,a0,368 # ffffffe000207a50 <lowerxdigits.0+0x88>
ffffffe0002048e8:	a89ff0ef          	jal	ra,ffffffe000204370 <printk>
    Log("  First Data Sector: %llu", fat32_volume.first_data_sec);
ffffffe0002048ec:	0000c797          	auipc	a5,0xc
ffffffe0002048f0:	91478793          	addi	a5,a5,-1772 # ffffffe000210200 <fat32_volume>
ffffffe0002048f4:	0007b783          	ld	a5,0(a5)
ffffffe0002048f8:	00078713          	mv	a4,a5
ffffffe0002048fc:	00003697          	auipc	a3,0x3
ffffffe000204900:	2e468693          	addi	a3,a3,740 # ffffffe000207be0 <__func__.2>
ffffffe000204904:	02900613          	li	a2,41
ffffffe000204908:	00003597          	auipc	a1,0x3
ffffffe00020490c:	0e058593          	addi	a1,a1,224 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204910:	00003517          	auipc	a0,0x3
ffffffe000204914:	17850513          	addi	a0,a0,376 # ffffffe000207a88 <lowerxdigits.0+0xc0>
ffffffe000204918:	a59ff0ef          	jal	ra,ffffffe000204370 <printk>
    Log("  FAT Table Size: %llu sectors", fat32_volume.fat_sz);
ffffffe00020491c:	0000c797          	auipc	a5,0xc
ffffffe000204920:	8e478793          	addi	a5,a5,-1820 # ffffffe000210200 <fat32_volume>
ffffffe000204924:	0187b783          	ld	a5,24(a5)
ffffffe000204928:	00078713          	mv	a4,a5
ffffffe00020492c:	00003697          	auipc	a3,0x3
ffffffe000204930:	2b468693          	addi	a3,a3,692 # ffffffe000207be0 <__func__.2>
ffffffe000204934:	02a00613          	li	a2,42
ffffffe000204938:	00003597          	auipc	a1,0x3
ffffffe00020493c:	0b058593          	addi	a1,a1,176 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204940:	00003517          	auipc	a0,0x3
ffffffe000204944:	18050513          	addi	a0,a0,384 # ffffffe000207ac0 <lowerxdigits.0+0xf8>
ffffffe000204948:	a29ff0ef          	jal	ra,ffffffe000204370 <printk>

    // virtio_blk_read_sector(fat32_volume.first_data_sec, fat32_buf);
}
ffffffe00020494c:	00000013          	nop
ffffffe000204950:	01813083          	ld	ra,24(sp)
ffffffe000204954:	01013403          	ld	s0,16(sp)
ffffffe000204958:	02010113          	addi	sp,sp,32
ffffffe00020495c:	00008067          	ret

ffffffe000204960 <is_fat32>:

int is_fat32(uint64_t lba) {
ffffffe000204960:	fe010113          	addi	sp,sp,-32
ffffffe000204964:	00113c23          	sd	ra,24(sp)
ffffffe000204968:	00813823          	sd	s0,16(sp)
ffffffe00020496c:	02010413          	addi	s0,sp,32
ffffffe000204970:	fea43423          	sd	a0,-24(s0)
    virtio_blk_read_sector(lba, (void*)&fat32_header);
ffffffe000204974:	0000b597          	auipc	a1,0xb
ffffffe000204978:	68c58593          	addi	a1,a1,1676 # ffffffe000210000 <fat32_header>
ffffffe00020497c:	fe843503          	ld	a0,-24(s0)
ffffffe000204980:	2a5010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
    if (fat32_header.boot_sector_signature != 0xaa55) {
ffffffe000204984:	0000b797          	auipc	a5,0xb
ffffffe000204988:	67c78793          	addi	a5,a5,1660 # ffffffe000210000 <fat32_header>
ffffffe00020498c:	1fe7d783          	lhu	a5,510(a5)
ffffffe000204990:	0007871b          	sext.w	a4,a5
ffffffe000204994:	0000b7b7          	lui	a5,0xb
ffffffe000204998:	a5578793          	addi	a5,a5,-1451 # aa55 <PGSIZE+0x9a55>
ffffffe00020499c:	00f70663          	beq	a4,a5,ffffffe0002049a8 <is_fat32+0x48>
        return 0;
ffffffe0002049a0:	00000793          	li	a5,0
ffffffe0002049a4:	0080006f          	j	ffffffe0002049ac <is_fat32+0x4c>
    }
    return 1;
ffffffe0002049a8:	00100793          	li	a5,1
}
ffffffe0002049ac:	00078513          	mv	a0,a5
ffffffe0002049b0:	01813083          	ld	ra,24(sp)
ffffffe0002049b4:	01013403          	ld	s0,16(sp)
ffffffe0002049b8:	02010113          	addi	sp,sp,32
ffffffe0002049bc:	00008067          	ret

ffffffe0002049c0 <next_slash>:

int next_slash(const char* path) {  // util function to be used in fat32_open_file
ffffffe0002049c0:	fd010113          	addi	sp,sp,-48
ffffffe0002049c4:	02813423          	sd	s0,40(sp)
ffffffe0002049c8:	03010413          	addi	s0,sp,48
ffffffe0002049cc:	fca43c23          	sd	a0,-40(s0)
    int i = 0;
ffffffe0002049d0:	fe042623          	sw	zero,-20(s0)
    while (path[i] != '\0' && path[i] != '/') {
ffffffe0002049d4:	0100006f          	j	ffffffe0002049e4 <next_slash+0x24>
        i++;
ffffffe0002049d8:	fec42783          	lw	a5,-20(s0)
ffffffe0002049dc:	0017879b          	addiw	a5,a5,1
ffffffe0002049e0:	fef42623          	sw	a5,-20(s0)
    while (path[i] != '\0' && path[i] != '/') {
ffffffe0002049e4:	fec42783          	lw	a5,-20(s0)
ffffffe0002049e8:	fd843703          	ld	a4,-40(s0)
ffffffe0002049ec:	00f707b3          	add	a5,a4,a5
ffffffe0002049f0:	0007c783          	lbu	a5,0(a5)
ffffffe0002049f4:	02078063          	beqz	a5,ffffffe000204a14 <next_slash+0x54>
ffffffe0002049f8:	fec42783          	lw	a5,-20(s0)
ffffffe0002049fc:	fd843703          	ld	a4,-40(s0)
ffffffe000204a00:	00f707b3          	add	a5,a4,a5
ffffffe000204a04:	0007c783          	lbu	a5,0(a5)
ffffffe000204a08:	00078713          	mv	a4,a5
ffffffe000204a0c:	02f00793          	li	a5,47
ffffffe000204a10:	fcf714e3          	bne	a4,a5,ffffffe0002049d8 <next_slash+0x18>
    }
    if (path[i] == '\0') {
ffffffe000204a14:	fec42783          	lw	a5,-20(s0)
ffffffe000204a18:	fd843703          	ld	a4,-40(s0)
ffffffe000204a1c:	00f707b3          	add	a5,a4,a5
ffffffe000204a20:	0007c783          	lbu	a5,0(a5)
ffffffe000204a24:	00079663          	bnez	a5,ffffffe000204a30 <next_slash+0x70>
        return -1;
ffffffe000204a28:	fff00793          	li	a5,-1
ffffffe000204a2c:	0080006f          	j	ffffffe000204a34 <next_slash+0x74>
    }
    return i;
ffffffe000204a30:	fec42783          	lw	a5,-20(s0)
}
ffffffe000204a34:	00078513          	mv	a0,a5
ffffffe000204a38:	02813403          	ld	s0,40(sp)
ffffffe000204a3c:	03010113          	addi	sp,sp,48
ffffffe000204a40:	00008067          	ret

ffffffe000204a44 <to_upper_case>:

void to_upper_case(char *str) {     // util function to be used in fat32_open_file
ffffffe000204a44:	fd010113          	addi	sp,sp,-48
ffffffe000204a48:	02813423          	sd	s0,40(sp)
ffffffe000204a4c:	03010413          	addi	s0,sp,48
ffffffe000204a50:	fca43c23          	sd	a0,-40(s0)
    for (int i = 0; str[i] != '\0'; i++) {
ffffffe000204a54:	fe042623          	sw	zero,-20(s0)
ffffffe000204a58:	0700006f          	j	ffffffe000204ac8 <to_upper_case+0x84>
        if (str[i] >= 'a' && str[i] <= 'z') {
ffffffe000204a5c:	fec42783          	lw	a5,-20(s0)
ffffffe000204a60:	fd843703          	ld	a4,-40(s0)
ffffffe000204a64:	00f707b3          	add	a5,a4,a5
ffffffe000204a68:	0007c783          	lbu	a5,0(a5)
ffffffe000204a6c:	00078713          	mv	a4,a5
ffffffe000204a70:	06000793          	li	a5,96
ffffffe000204a74:	04e7f463          	bgeu	a5,a4,ffffffe000204abc <to_upper_case+0x78>
ffffffe000204a78:	fec42783          	lw	a5,-20(s0)
ffffffe000204a7c:	fd843703          	ld	a4,-40(s0)
ffffffe000204a80:	00f707b3          	add	a5,a4,a5
ffffffe000204a84:	0007c783          	lbu	a5,0(a5)
ffffffe000204a88:	00078713          	mv	a4,a5
ffffffe000204a8c:	07a00793          	li	a5,122
ffffffe000204a90:	02e7e663          	bltu	a5,a4,ffffffe000204abc <to_upper_case+0x78>
            str[i] -= 32;
ffffffe000204a94:	fec42783          	lw	a5,-20(s0)
ffffffe000204a98:	fd843703          	ld	a4,-40(s0)
ffffffe000204a9c:	00f707b3          	add	a5,a4,a5
ffffffe000204aa0:	0007c703          	lbu	a4,0(a5)
ffffffe000204aa4:	fec42783          	lw	a5,-20(s0)
ffffffe000204aa8:	fd843683          	ld	a3,-40(s0)
ffffffe000204aac:	00f687b3          	add	a5,a3,a5
ffffffe000204ab0:	fe07071b          	addiw	a4,a4,-32
ffffffe000204ab4:	0ff77713          	zext.b	a4,a4
ffffffe000204ab8:	00e78023          	sb	a4,0(a5)
    for (int i = 0; str[i] != '\0'; i++) {
ffffffe000204abc:	fec42783          	lw	a5,-20(s0)
ffffffe000204ac0:	0017879b          	addiw	a5,a5,1
ffffffe000204ac4:	fef42623          	sw	a5,-20(s0)
ffffffe000204ac8:	fec42783          	lw	a5,-20(s0)
ffffffe000204acc:	fd843703          	ld	a4,-40(s0)
ffffffe000204ad0:	00f707b3          	add	a5,a4,a5
ffffffe000204ad4:	0007c783          	lbu	a5,0(a5)
ffffffe000204ad8:	f80792e3          	bnez	a5,ffffffe000204a5c <to_upper_case+0x18>
        }
    }
}
ffffffe000204adc:	00000013          	nop
ffffffe000204ae0:	00000013          	nop
ffffffe000204ae4:	02813403          	ld	s0,40(sp)
ffffffe000204ae8:	03010113          	addi	sp,sp,48
ffffffe000204aec:	00008067          	ret

ffffffe000204af0 <count_clusters>:

uint32_t count_clusters(uint32_t first_cluster) {
ffffffe000204af0:	fd010113          	addi	sp,sp,-48
ffffffe000204af4:	02113423          	sd	ra,40(sp)
ffffffe000204af8:	02813023          	sd	s0,32(sp)
ffffffe000204afc:	03010413          	addi	s0,sp,48
ffffffe000204b00:	00050793          	mv	a5,a0
ffffffe000204b04:	fcf42e23          	sw	a5,-36(s0)
    uint32_t count = 0;
ffffffe000204b08:	fe042623          	sw	zero,-20(s0)

    while (first_cluster < 0x0FFFFFF8) {
ffffffe000204b0c:	0240006f          	j	ffffffe000204b30 <count_clusters+0x40>
        count++;
ffffffe000204b10:	fec42783          	lw	a5,-20(s0)
ffffffe000204b14:	0017879b          	addiw	a5,a5,1
ffffffe000204b18:	fef42623          	sw	a5,-20(s0)
        first_cluster = next_cluster(first_cluster);
ffffffe000204b1c:	fdc46783          	lwu	a5,-36(s0)
ffffffe000204b20:	00078513          	mv	a0,a5
ffffffe000204b24:	bf5ff0ef          	jal	ra,ffffffe000204718 <next_cluster>
ffffffe000204b28:	00050793          	mv	a5,a0
ffffffe000204b2c:	fcf42e23          	sw	a5,-36(s0)
    while (first_cluster < 0x0FFFFFF8) {
ffffffe000204b30:	fdc42783          	lw	a5,-36(s0)
ffffffe000204b34:	0007871b          	sext.w	a4,a5
ffffffe000204b38:	100007b7          	lui	a5,0x10000
ffffffe000204b3c:	ff778793          	addi	a5,a5,-9 # ffffff7 <PHY_SIZE+0x7fffff7>
ffffffe000204b40:	fce7f8e3          	bgeu	a5,a4,ffffffe000204b10 <count_clusters+0x20>
    }

    return count;
ffffffe000204b44:	fec42783          	lw	a5,-20(s0)
}
ffffffe000204b48:	00078513          	mv	a0,a5
ffffffe000204b4c:	02813083          	ld	ra,40(sp)
ffffffe000204b50:	02013403          	ld	s0,32(sp)
ffffffe000204b54:	03010113          	addi	sp,sp,48
ffffffe000204b58:	00008067          	ret

ffffffe000204b5c <fat32_open_file>:

struct fat32_file fat32_open_file(const char *path) {
ffffffe000204b5c:	f3010113          	addi	sp,sp,-208
ffffffe000204b60:	0c113423          	sd	ra,200(sp)
ffffffe000204b64:	0c813023          	sd	s0,192(sp)
ffffffe000204b68:	0b213c23          	sd	s2,184(sp)
ffffffe000204b6c:	0b313823          	sd	s3,176(sp)
ffffffe000204b70:	0d010413          	addi	s0,sp,208
ffffffe000204b74:	f2a43c23          	sd	a0,-200(s0)
    struct fat32_file file;
    char path_copy[MAX_PATH_LENGTH];
    memset(path_copy, ' ', MAX_PATH_LENGTH);
ffffffe000204b78:	f4840793          	addi	a5,s0,-184
ffffffe000204b7c:	05000613          	li	a2,80
ffffffe000204b80:	02000593          	li	a1,32
ffffffe000204b84:	00078513          	mv	a0,a5
ffffffe000204b88:	909ff0ef          	jal	ra,ffffffe000204490 <memset>
    path_copy[MAX_PATH_LENGTH - 1] = '\0';
ffffffe000204b8c:	f8040ba3          	sb	zero,-105(s0)
    uint64_t len = strlen(path);
ffffffe000204b90:	f3843503          	ld	a0,-200(s0)
ffffffe000204b94:	aa1ff0ef          	jal	ra,ffffffe000204634 <strlen>
ffffffe000204b98:	fca43423          	sd	a0,-56(s0)
    if(len < 7 || len > 15) {
ffffffe000204b9c:	fc843703          	ld	a4,-56(s0)
ffffffe000204ba0:	00600793          	li	a5,6
ffffffe000204ba4:	00e7f863          	bgeu	a5,a4,ffffffe000204bb4 <fat32_open_file+0x58>
ffffffe000204ba8:	fc843703          	ld	a4,-56(s0)
ffffffe000204bac:	00f00793          	li	a5,15
ffffffe000204bb0:	02e7f463          	bgeu	a5,a4,ffffffe000204bd8 <fat32_open_file+0x7c>
        Err("path err");
ffffffe000204bb4:	00003697          	auipc	a3,0x3
ffffffe000204bb8:	03c68693          	addi	a3,a3,60 # ffffffe000207bf0 <__func__.1>
ffffffe000204bbc:	05c00613          	li	a2,92
ffffffe000204bc0:	00003597          	auipc	a1,0x3
ffffffe000204bc4:	e2858593          	addi	a1,a1,-472 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204bc8:	00003517          	auipc	a0,0x3
ffffffe000204bcc:	f3050513          	addi	a0,a0,-208 # ffffffe000207af8 <lowerxdigits.0+0x130>
ffffffe000204bd0:	fa0ff0ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000204bd4:	0000006f          	j	ffffffe000204bd4 <fat32_open_file+0x78>
    }
    memcpy(path_copy, path + 7, len - 7); // ignore "/fat32/" fill the rest with ' '
ffffffe000204bd8:	f3843783          	ld	a5,-200(s0)
ffffffe000204bdc:	00778713          	addi	a4,a5,7
ffffffe000204be0:	fc843783          	ld	a5,-56(s0)
ffffffe000204be4:	ff978693          	addi	a3,a5,-7
ffffffe000204be8:	f4840793          	addi	a5,s0,-184
ffffffe000204bec:	00068613          	mv	a2,a3
ffffffe000204bf0:	00070593          	mv	a1,a4
ffffffe000204bf4:	00078513          	mv	a0,a5
ffffffe000204bf8:	909ff0ef          	jal	ra,ffffffe000204500 <memcpy>
    Log("path_copy: %s, len: %d, path: %s", path_copy, len, path);
ffffffe000204bfc:	f4840713          	addi	a4,s0,-184
ffffffe000204c00:	f3843803          	ld	a6,-200(s0)
ffffffe000204c04:	fc843783          	ld	a5,-56(s0)
ffffffe000204c08:	00003697          	auipc	a3,0x3
ffffffe000204c0c:	fe868693          	addi	a3,a3,-24 # ffffffe000207bf0 <__func__.1>
ffffffe000204c10:	05f00613          	li	a2,95
ffffffe000204c14:	00003597          	auipc	a1,0x3
ffffffe000204c18:	dd458593          	addi	a1,a1,-556 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204c1c:	00003517          	auipc	a0,0x3
ffffffe000204c20:	efc50513          	addi	a0,a0,-260 # ffffffe000207b18 <lowerxdigits.0+0x150>
ffffffe000204c24:	f4cff0ef          	jal	ra,ffffffe000204370 <printk>
    to_upper_case(path_copy);
ffffffe000204c28:	f4840793          	addi	a5,s0,-184
ffffffe000204c2c:	00078513          	mv	a0,a5
ffffffe000204c30:	e15ff0ef          	jal	ra,ffffffe000204a44 <to_upper_case>
    

    uint64_t sector = fat32_volume.first_data_sec;
ffffffe000204c34:	0000b797          	auipc	a5,0xb
ffffffe000204c38:	5cc78793          	addi	a5,a5,1484 # ffffffe000210200 <fat32_volume>
ffffffe000204c3c:	0007b783          	ld	a5,0(a5)
ffffffe000204c40:	fcf43c23          	sd	a5,-40(s0)
    uint32_t cluster = sector_to_cluster(sector);
ffffffe000204c44:	fd843503          	ld	a0,-40(s0)
ffffffe000204c48:	a81ff0ef          	jal	ra,ffffffe0002046c8 <sector_to_cluster>
ffffffe000204c4c:	00050793          	mv	a5,a0
ffffffe000204c50:	fcf42223          	sw	a5,-60(s0)
    uint32_t count = count_clusters(cluster);
ffffffe000204c54:	fc442783          	lw	a5,-60(s0)
ffffffe000204c58:	00078513          	mv	a0,a5
ffffffe000204c5c:	e95ff0ef          	jal	ra,ffffffe000204af0 <count_clusters>
ffffffe000204c60:	00050793          	mv	a5,a0
ffffffe000204c64:	fcf42023          	sw	a5,-64(s0)

    virtio_blk_read_sector(sector, fat32_buf);
ffffffe000204c68:	0000b597          	auipc	a1,0xb
ffffffe000204c6c:	5b858593          	addi	a1,a1,1464 # ffffffe000210220 <fat32_buf>
ffffffe000204c70:	fd843503          	ld	a0,-40(s0)
ffffffe000204c74:	7b0010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
    struct fat32_dir_entry *entry = (struct fat32_dir_entry *)fat32_buf;
ffffffe000204c78:	0000b797          	auipc	a5,0xb
ffffffe000204c7c:	5a878793          	addi	a5,a5,1448 # ffffffe000210220 <fat32_buf>
ffffffe000204c80:	faf43c23          	sd	a5,-72(s0)

    for (int i = 0; i < fat32_volume.sec_per_cluster * count; i++) {
ffffffe000204c84:	fc042a23          	sw	zero,-44(s0)
ffffffe000204c88:	1200006f          	j	ffffffe000204da8 <fat32_open_file+0x24c>
        for (int j = 0; j < FAT32_ENTRY_PER_SECTOR; j++) {
ffffffe000204c8c:	fc042823          	sw	zero,-48(s0)
ffffffe000204c90:	0e00006f          	j	ffffffe000204d70 <fat32_open_file+0x214>
            if (memcmp(entry[j].name, path_copy, 8) == 0) {
ffffffe000204c94:	fd042783          	lw	a5,-48(s0)
ffffffe000204c98:	00579793          	slli	a5,a5,0x5
ffffffe000204c9c:	fb843703          	ld	a4,-72(s0)
ffffffe000204ca0:	00f707b3          	add	a5,a4,a5
ffffffe000204ca4:	00078713          	mv	a4,a5
ffffffe000204ca8:	f4840793          	addi	a5,s0,-184
ffffffe000204cac:	00800613          	li	a2,8
ffffffe000204cb0:	00078593          	mv	a1,a5
ffffffe000204cb4:	00070513          	mv	a0,a4
ffffffe000204cb8:	8c5ff0ef          	jal	ra,ffffffe00020457c <memcmp>
ffffffe000204cbc:	00050793          	mv	a5,a0
ffffffe000204cc0:	0a079263          	bnez	a5,ffffffe000204d64 <fat32_open_file+0x208>
                Log("file name: %s", entry[j].name);
ffffffe000204cc4:	fd042783          	lw	a5,-48(s0)
ffffffe000204cc8:	00579793          	slli	a5,a5,0x5
ffffffe000204ccc:	fb843703          	ld	a4,-72(s0)
ffffffe000204cd0:	00f707b3          	add	a5,a4,a5
ffffffe000204cd4:	00078713          	mv	a4,a5
ffffffe000204cd8:	00003697          	auipc	a3,0x3
ffffffe000204cdc:	f1868693          	addi	a3,a3,-232 # ffffffe000207bf0 <__func__.1>
ffffffe000204ce0:	06d00613          	li	a2,109
ffffffe000204ce4:	00003597          	auipc	a1,0x3
ffffffe000204ce8:	d0458593          	addi	a1,a1,-764 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204cec:	00003517          	auipc	a0,0x3
ffffffe000204cf0:	e6450513          	addi	a0,a0,-412 # ffffffe000207b50 <lowerxdigits.0+0x188>
ffffffe000204cf4:	e7cff0ef          	jal	ra,ffffffe000204370 <printk>
                file.cluster = (uint32_t)entry[j].starthi << 16 | entry[j].startlow;
ffffffe000204cf8:	fd042783          	lw	a5,-48(s0)
ffffffe000204cfc:	00579793          	slli	a5,a5,0x5
ffffffe000204d00:	fb843703          	ld	a4,-72(s0)
ffffffe000204d04:	00f707b3          	add	a5,a4,a5
ffffffe000204d08:	0147d783          	lhu	a5,20(a5)
ffffffe000204d0c:	0007879b          	sext.w	a5,a5
ffffffe000204d10:	0107979b          	slliw	a5,a5,0x10
ffffffe000204d14:	0007869b          	sext.w	a3,a5
ffffffe000204d18:	fd042783          	lw	a5,-48(s0)
ffffffe000204d1c:	00579793          	slli	a5,a5,0x5
ffffffe000204d20:	fb843703          	ld	a4,-72(s0)
ffffffe000204d24:	00f707b3          	add	a5,a4,a5
ffffffe000204d28:	01a7d783          	lhu	a5,26(a5)
ffffffe000204d2c:	0007879b          	sext.w	a5,a5
ffffffe000204d30:	00068713          	mv	a4,a3
ffffffe000204d34:	00f767b3          	or	a5,a4,a5
ffffffe000204d38:	0007879b          	sext.w	a5,a5
ffffffe000204d3c:	f8f42c23          	sw	a5,-104(s0)
                file.dir.index = j;
ffffffe000204d40:	fd042783          	lw	a5,-48(s0)
ffffffe000204d44:	faf42023          	sw	a5,-96(s0)
                file.dir.cluster = cluster;
ffffffe000204d48:	fc442783          	lw	a5,-60(s0)
ffffffe000204d4c:	f8f42e23          	sw	a5,-100(s0)
                return file;
ffffffe000204d50:	f9843783          	ld	a5,-104(s0)
ffffffe000204d54:	faf43423          	sd	a5,-88(s0)
ffffffe000204d58:	fa042783          	lw	a5,-96(s0)
ffffffe000204d5c:	faf42823          	sw	a5,-80(s0)
ffffffe000204d60:	0a80006f          	j	ffffffe000204e08 <fat32_open_file+0x2ac>
        for (int j = 0; j < FAT32_ENTRY_PER_SECTOR; j++) {
ffffffe000204d64:	fd042783          	lw	a5,-48(s0)
ffffffe000204d68:	0017879b          	addiw	a5,a5,1
ffffffe000204d6c:	fcf42823          	sw	a5,-48(s0)
ffffffe000204d70:	fd042783          	lw	a5,-48(s0)
ffffffe000204d74:	00078713          	mv	a4,a5
ffffffe000204d78:	00f00793          	li	a5,15
ffffffe000204d7c:	f0e7fce3          	bgeu	a5,a4,ffffffe000204c94 <fat32_open_file+0x138>
            }
        }
        sector++;
ffffffe000204d80:	fd843783          	ld	a5,-40(s0)
ffffffe000204d84:	00178793          	addi	a5,a5,1
ffffffe000204d88:	fcf43c23          	sd	a5,-40(s0)
        virtio_blk_read_sector(sector, fat32_buf);
ffffffe000204d8c:	0000b597          	auipc	a1,0xb
ffffffe000204d90:	49458593          	addi	a1,a1,1172 # ffffffe000210220 <fat32_buf>
ffffffe000204d94:	fd843503          	ld	a0,-40(s0)
ffffffe000204d98:	68c010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
    for (int i = 0; i < fat32_volume.sec_per_cluster * count; i++) {
ffffffe000204d9c:	fd442783          	lw	a5,-44(s0)
ffffffe000204da0:	0017879b          	addiw	a5,a5,1
ffffffe000204da4:	fcf42a23          	sw	a5,-44(s0)
ffffffe000204da8:	fd442703          	lw	a4,-44(s0)
ffffffe000204dac:	0000b797          	auipc	a5,0xb
ffffffe000204db0:	45478793          	addi	a5,a5,1108 # ffffffe000210200 <fat32_volume>
ffffffe000204db4:	0107b683          	ld	a3,16(a5)
ffffffe000204db8:	fc046783          	lwu	a5,-64(s0)
ffffffe000204dbc:	02f687b3          	mul	a5,a3,a5
ffffffe000204dc0:	ecf766e3          	bltu	a4,a5,ffffffe000204c8c <fat32_open_file+0x130>
    }
    Log("file not found");
ffffffe000204dc4:	00003697          	auipc	a3,0x3
ffffffe000204dc8:	e2c68693          	addi	a3,a3,-468 # ffffffe000207bf0 <__func__.1>
ffffffe000204dcc:	07700613          	li	a2,119
ffffffe000204dd0:	00003597          	auipc	a1,0x3
ffffffe000204dd4:	c1858593          	addi	a1,a1,-1000 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204dd8:	00003517          	auipc	a0,0x3
ffffffe000204ddc:	da050513          	addi	a0,a0,-608 # ffffffe000207b78 <lowerxdigits.0+0x1b0>
ffffffe000204de0:	d90ff0ef          	jal	ra,ffffffe000204370 <printk>
    memset(&file, 0, sizeof(struct fat32_file));
ffffffe000204de4:	f9840793          	addi	a5,s0,-104
ffffffe000204de8:	00c00613          	li	a2,12
ffffffe000204dec:	00000593          	li	a1,0
ffffffe000204df0:	00078513          	mv	a0,a5
ffffffe000204df4:	e9cff0ef          	jal	ra,ffffffe000204490 <memset>

    return file;
ffffffe000204df8:	f9843783          	ld	a5,-104(s0)
ffffffe000204dfc:	faf43423          	sd	a5,-88(s0)
ffffffe000204e00:	fa042783          	lw	a5,-96(s0)
ffffffe000204e04:	faf42823          	sw	a5,-80(s0)
}
ffffffe000204e08:	00000793          	li	a5,0
ffffffe000204e0c:	fa846683          	lwu	a3,-88(s0)
ffffffe000204e10:	fff00713          	li	a4,-1
ffffffe000204e14:	02075713          	srli	a4,a4,0x20
ffffffe000204e18:	00e6f733          	and	a4,a3,a4
ffffffe000204e1c:	fff00693          	li	a3,-1
ffffffe000204e20:	02069693          	slli	a3,a3,0x20
ffffffe000204e24:	00d7f7b3          	and	a5,a5,a3
ffffffe000204e28:	00e7e7b3          	or	a5,a5,a4
ffffffe000204e2c:	fac46703          	lwu	a4,-84(s0)
ffffffe000204e30:	02071713          	slli	a4,a4,0x20
ffffffe000204e34:	fff00693          	li	a3,-1
ffffffe000204e38:	0206d693          	srli	a3,a3,0x20
ffffffe000204e3c:	00d7f7b3          	and	a5,a5,a3
ffffffe000204e40:	00e7e7b3          	or	a5,a5,a4
ffffffe000204e44:	00000713          	li	a4,0
ffffffe000204e48:	fb046603          	lwu	a2,-80(s0)
ffffffe000204e4c:	fff00693          	li	a3,-1
ffffffe000204e50:	0206d693          	srli	a3,a3,0x20
ffffffe000204e54:	00d676b3          	and	a3,a2,a3
ffffffe000204e58:	fff00613          	li	a2,-1
ffffffe000204e5c:	02061613          	slli	a2,a2,0x20
ffffffe000204e60:	00c77733          	and	a4,a4,a2
ffffffe000204e64:	00d76733          	or	a4,a4,a3
ffffffe000204e68:	00078913          	mv	s2,a5
ffffffe000204e6c:	00070993          	mv	s3,a4
ffffffe000204e70:	00090713          	mv	a4,s2
ffffffe000204e74:	00098793          	mv	a5,s3
ffffffe000204e78:	00070513          	mv	a0,a4
ffffffe000204e7c:	00078593          	mv	a1,a5
ffffffe000204e80:	0c813083          	ld	ra,200(sp)
ffffffe000204e84:	0c013403          	ld	s0,192(sp)
ffffffe000204e88:	0b813903          	ld	s2,184(sp)
ffffffe000204e8c:	0b013983          	ld	s3,176(sp)
ffffffe000204e90:	0d010113          	addi	sp,sp,208
ffffffe000204e94:	00008067          	ret

ffffffe000204e98 <fat32_lseek>:

int64_t fat32_lseek(struct file* file, int64_t offset, uint64_t whence) {
ffffffe000204e98:	fb010113          	addi	sp,sp,-80
ffffffe000204e9c:	04113423          	sd	ra,72(sp)
ffffffe000204ea0:	04813023          	sd	s0,64(sp)
ffffffe000204ea4:	05010413          	addi	s0,sp,80
ffffffe000204ea8:	fca43423          	sd	a0,-56(s0)
ffffffe000204eac:	fcb43023          	sd	a1,-64(s0)
ffffffe000204eb0:	fac43c23          	sd	a2,-72(s0)
    if (whence == SEEK_SET) {
ffffffe000204eb4:	fb843783          	ld	a5,-72(s0)
ffffffe000204eb8:	00079a63          	bnez	a5,ffffffe000204ecc <fat32_lseek+0x34>
        file->cfo = offset/* to calculate */;
ffffffe000204ebc:	fc843783          	ld	a5,-56(s0)
ffffffe000204ec0:	fc043703          	ld	a4,-64(s0)
ffffffe000204ec4:	00e7b423          	sd	a4,8(a5)
ffffffe000204ec8:	0f40006f          	j	ffffffe000204fbc <fat32_lseek+0x124>
    } else if (whence == SEEK_CUR) {
ffffffe000204ecc:	fb843703          	ld	a4,-72(s0)
ffffffe000204ed0:	00100793          	li	a5,1
ffffffe000204ed4:	02f71063          	bne	a4,a5,ffffffe000204ef4 <fat32_lseek+0x5c>
        file->cfo = file->cfo + offset/* to calculate */;
ffffffe000204ed8:	fc843783          	ld	a5,-56(s0)
ffffffe000204edc:	0087b703          	ld	a4,8(a5)
ffffffe000204ee0:	fc043783          	ld	a5,-64(s0)
ffffffe000204ee4:	00f70733          	add	a4,a4,a5
ffffffe000204ee8:	fc843783          	ld	a5,-56(s0)
ffffffe000204eec:	00e7b423          	sd	a4,8(a5)
ffffffe000204ef0:	0cc0006f          	j	ffffffe000204fbc <fat32_lseek+0x124>
    } else if (whence == SEEK_END) {
ffffffe000204ef4:	fb843703          	ld	a4,-72(s0)
ffffffe000204ef8:	00200793          	li	a5,2
ffffffe000204efc:	08f71e63          	bne	a4,a5,ffffffe000204f98 <fat32_lseek+0x100>
        /* Calculate file length */
        uint64_t sector = cluster_to_sector(file->fat32_file.dir.cluster) + file->fat32_file.dir.index / FAT32_ENTRY_PER_SECTOR;
ffffffe000204f00:	fc843783          	ld	a5,-56(s0)
ffffffe000204f04:	0187a783          	lw	a5,24(a5)
ffffffe000204f08:	02079793          	slli	a5,a5,0x20
ffffffe000204f0c:	0207d793          	srli	a5,a5,0x20
ffffffe000204f10:	00078513          	mv	a0,a5
ffffffe000204f14:	f6cff0ef          	jal	ra,ffffffe000204680 <cluster_to_sector>
ffffffe000204f18:	00050713          	mv	a4,a0
ffffffe000204f1c:	fc843783          	ld	a5,-56(s0)
ffffffe000204f20:	01c7a783          	lw	a5,28(a5)
ffffffe000204f24:	0047d79b          	srliw	a5,a5,0x4
ffffffe000204f28:	0007879b          	sext.w	a5,a5
ffffffe000204f2c:	02079793          	slli	a5,a5,0x20
ffffffe000204f30:	0207d793          	srli	a5,a5,0x20
ffffffe000204f34:	00f707b3          	add	a5,a4,a5
ffffffe000204f38:	fef43423          	sd	a5,-24(s0)
        virtio_blk_read_sector(sector, fat32_table_buf);
ffffffe000204f3c:	0000b597          	auipc	a1,0xb
ffffffe000204f40:	4e458593          	addi	a1,a1,1252 # ffffffe000210420 <fat32_table_buf>
ffffffe000204f44:	fe843503          	ld	a0,-24(s0)
ffffffe000204f48:	4dc010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
        uint32_t index = file->fat32_file.dir.index % FAT32_ENTRY_PER_SECTOR;
ffffffe000204f4c:	fc843783          	ld	a5,-56(s0)
ffffffe000204f50:	01c7a783          	lw	a5,28(a5)
ffffffe000204f54:	00f7f793          	andi	a5,a5,15
ffffffe000204f58:	fef42223          	sw	a5,-28(s0)
        struct fat32_dir_entry *entry = (struct fat32_dir_entry *)fat32_table_buf;
ffffffe000204f5c:	0000b797          	auipc	a5,0xb
ffffffe000204f60:	4c478793          	addi	a5,a5,1220 # ffffffe000210420 <fat32_table_buf>
ffffffe000204f64:	fcf43c23          	sd	a5,-40(s0)
        file->cfo = entry[index].size + offset/* to calculate */;
ffffffe000204f68:	fe446783          	lwu	a5,-28(s0)
ffffffe000204f6c:	00579793          	slli	a5,a5,0x5
ffffffe000204f70:	fd843703          	ld	a4,-40(s0)
ffffffe000204f74:	00f707b3          	add	a5,a4,a5
ffffffe000204f78:	01c7a783          	lw	a5,28(a5)
ffffffe000204f7c:	02079713          	slli	a4,a5,0x20
ffffffe000204f80:	02075713          	srli	a4,a4,0x20
ffffffe000204f84:	fc043783          	ld	a5,-64(s0)
ffffffe000204f88:	00f70733          	add	a4,a4,a5
ffffffe000204f8c:	fc843783          	ld	a5,-56(s0)
ffffffe000204f90:	00e7b423          	sd	a4,8(a5)
ffffffe000204f94:	0280006f          	j	ffffffe000204fbc <fat32_lseek+0x124>
    } else {
        Err("fat32_lseek: whence not implemented");
ffffffe000204f98:	00003697          	auipc	a3,0x3
ffffffe000204f9c:	c6868693          	addi	a3,a3,-920 # ffffffe000207c00 <__func__.0>
ffffffe000204fa0:	08a00613          	li	a2,138
ffffffe000204fa4:	00003597          	auipc	a1,0x3
ffffffe000204fa8:	a4458593          	addi	a1,a1,-1468 # ffffffe0002079e8 <lowerxdigits.0+0x20>
ffffffe000204fac:	00003517          	auipc	a0,0x3
ffffffe000204fb0:	bf450513          	addi	a0,a0,-1036 # ffffffe000207ba0 <lowerxdigits.0+0x1d8>
ffffffe000204fb4:	bbcff0ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000204fb8:	0000006f          	j	ffffffe000204fb8 <fat32_lseek+0x120>
        while (1);
    }
    return file->cfo;
ffffffe000204fbc:	fc843783          	ld	a5,-56(s0)
ffffffe000204fc0:	0087b783          	ld	a5,8(a5)
}
ffffffe000204fc4:	00078513          	mv	a0,a5
ffffffe000204fc8:	04813083          	ld	ra,72(sp)
ffffffe000204fcc:	04013403          	ld	s0,64(sp)
ffffffe000204fd0:	05010113          	addi	sp,sp,80
ffffffe000204fd4:	00008067          	ret

ffffffe000204fd8 <fat32_table_sector_of_cluster>:

uint64_t fat32_table_sector_of_cluster(uint32_t cluster) {
ffffffe000204fd8:	fe010113          	addi	sp,sp,-32
ffffffe000204fdc:	00813c23          	sd	s0,24(sp)
ffffffe000204fe0:	02010413          	addi	s0,sp,32
ffffffe000204fe4:	00050793          	mv	a5,a0
ffffffe000204fe8:	fef42623          	sw	a5,-20(s0)
    return fat32_volume.first_fat_sec + cluster / (VIRTIO_BLK_SECTOR_SIZE / sizeof(uint32_t));
ffffffe000204fec:	0000b797          	auipc	a5,0xb
ffffffe000204ff0:	21478793          	addi	a5,a5,532 # ffffffe000210200 <fat32_volume>
ffffffe000204ff4:	0087b703          	ld	a4,8(a5)
ffffffe000204ff8:	fec42783          	lw	a5,-20(s0)
ffffffe000204ffc:	0077d79b          	srliw	a5,a5,0x7
ffffffe000205000:	0007879b          	sext.w	a5,a5
ffffffe000205004:	02079793          	slli	a5,a5,0x20
ffffffe000205008:	0207d793          	srli	a5,a5,0x20
ffffffe00020500c:	00f707b3          	add	a5,a4,a5
}
ffffffe000205010:	00078513          	mv	a0,a5
ffffffe000205014:	01813403          	ld	s0,24(sp)
ffffffe000205018:	02010113          	addi	sp,sp,32
ffffffe00020501c:	00008067          	ret

ffffffe000205020 <find_cluster>:
// int64_t fat32_write(struct file* file, const void* buf, uint64_t len) {
//     /* todo: fat32_write */
//     return 0;
// }

uint32_t find_cluster(uint32_t file_start_cluster, int64_t cfo) {
ffffffe000205020:	fd010113          	addi	sp,sp,-48
ffffffe000205024:	02113423          	sd	ra,40(sp)
ffffffe000205028:	02813023          	sd	s0,32(sp)
ffffffe00020502c:	03010413          	addi	s0,sp,48
ffffffe000205030:	00050793          	mv	a5,a0
ffffffe000205034:	fcb43823          	sd	a1,-48(s0)
ffffffe000205038:	fcf42e23          	sw	a5,-36(s0)
    uint32_t cluster_offset = cfo / (fat32_volume.sec_per_cluster * VIRTIO_BLK_SECTOR_SIZE);
ffffffe00020503c:	fd043703          	ld	a4,-48(s0)
ffffffe000205040:	0000b797          	auipc	a5,0xb
ffffffe000205044:	1c078793          	addi	a5,a5,448 # ffffffe000210200 <fat32_volume>
ffffffe000205048:	0107b783          	ld	a5,16(a5)
ffffffe00020504c:	00979793          	slli	a5,a5,0x9
ffffffe000205050:	02f757b3          	divu	a5,a4,a5
ffffffe000205054:	fef42423          	sw	a5,-24(s0)
    for (int i = 0; i < cluster_offset && file_start_cluster < 0xffffff8; i++) {
ffffffe000205058:	fe042623          	sw	zero,-20(s0)
ffffffe00020505c:	0240006f          	j	ffffffe000205080 <find_cluster+0x60>
        file_start_cluster = next_cluster(file_start_cluster);
ffffffe000205060:	fdc46783          	lwu	a5,-36(s0)
ffffffe000205064:	00078513          	mv	a0,a5
ffffffe000205068:	eb0ff0ef          	jal	ra,ffffffe000204718 <next_cluster>
ffffffe00020506c:	00050793          	mv	a5,a0
ffffffe000205070:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 0; i < cluster_offset && file_start_cluster < 0xffffff8; i++) {
ffffffe000205074:	fec42783          	lw	a5,-20(s0)
ffffffe000205078:	0017879b          	addiw	a5,a5,1
ffffffe00020507c:	fef42623          	sw	a5,-20(s0)
ffffffe000205080:	fec42703          	lw	a4,-20(s0)
ffffffe000205084:	fe842783          	lw	a5,-24(s0)
ffffffe000205088:	0007879b          	sext.w	a5,a5
ffffffe00020508c:	00f77c63          	bgeu	a4,a5,ffffffe0002050a4 <find_cluster+0x84>
ffffffe000205090:	fdc42783          	lw	a5,-36(s0)
ffffffe000205094:	0007871b          	sext.w	a4,a5
ffffffe000205098:	100007b7          	lui	a5,0x10000
ffffffe00020509c:	ff778793          	addi	a5,a5,-9 # ffffff7 <PHY_SIZE+0x7fffff7>
ffffffe0002050a0:	fce7f0e3          	bgeu	a5,a4,ffffffe000205060 <find_cluster+0x40>
    }
    return file_start_cluster;
ffffffe0002050a4:	fdc42783          	lw	a5,-36(s0)
}
ffffffe0002050a8:	00078513          	mv	a0,a5
ffffffe0002050ac:	02813083          	ld	ra,40(sp)
ffffffe0002050b0:	02013403          	ld	s0,32(sp)
ffffffe0002050b4:	03010113          	addi	sp,sp,48
ffffffe0002050b8:	00008067          	ret

ffffffe0002050bc <fat32_read>:

int64_t fat32_read(struct file *file, void *buf, uint64_t len) {
ffffffe0002050bc:	f8010113          	addi	sp,sp,-128
ffffffe0002050c0:	06113c23          	sd	ra,120(sp)
ffffffe0002050c4:	06813823          	sd	s0,112(sp)
ffffffe0002050c8:	08010413          	addi	s0,sp,128
ffffffe0002050cc:	f8a43c23          	sd	a0,-104(s0)
ffffffe0002050d0:	f8b43823          	sd	a1,-112(s0)
ffffffe0002050d4:	f8c43423          	sd	a2,-120(s0)
    uint64_t sector = cluster_to_sector(file->fat32_file.dir.cluster) + file->fat32_file.dir.index / FAT32_ENTRY_PER_SECTOR;
ffffffe0002050d8:	f9843783          	ld	a5,-104(s0)
ffffffe0002050dc:	0187a783          	lw	a5,24(a5)
ffffffe0002050e0:	02079793          	slli	a5,a5,0x20
ffffffe0002050e4:	0207d793          	srli	a5,a5,0x20
ffffffe0002050e8:	00078513          	mv	a0,a5
ffffffe0002050ec:	d94ff0ef          	jal	ra,ffffffe000204680 <cluster_to_sector>
ffffffe0002050f0:	00050713          	mv	a4,a0
ffffffe0002050f4:	f9843783          	ld	a5,-104(s0)
ffffffe0002050f8:	01c7a783          	lw	a5,28(a5)
ffffffe0002050fc:	0047d79b          	srliw	a5,a5,0x4
ffffffe000205100:	0007879b          	sext.w	a5,a5
ffffffe000205104:	02079793          	slli	a5,a5,0x20
ffffffe000205108:	0207d793          	srli	a5,a5,0x20
ffffffe00020510c:	00f707b3          	add	a5,a4,a5
ffffffe000205110:	fef43023          	sd	a5,-32(s0)
    virtio_blk_read_sector(sector, fat32_table_buf);
ffffffe000205114:	0000b597          	auipc	a1,0xb
ffffffe000205118:	30c58593          	addi	a1,a1,780 # ffffffe000210420 <fat32_table_buf>
ffffffe00020511c:	fe043503          	ld	a0,-32(s0)
ffffffe000205120:	304010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
    uint32_t index = file->fat32_file.dir.index % FAT32_ENTRY_PER_SECTOR;
ffffffe000205124:	f9843783          	ld	a5,-104(s0)
ffffffe000205128:	01c7a783          	lw	a5,28(a5)
ffffffe00020512c:	00f7f793          	andi	a5,a5,15
ffffffe000205130:	fcf42e23          	sw	a5,-36(s0)
    struct fat32_dir_entry *entry = (struct fat32_dir_entry *)fat32_table_buf;
ffffffe000205134:	0000b797          	auipc	a5,0xb
ffffffe000205138:	2ec78793          	addi	a5,a5,748 # ffffffe000210420 <fat32_table_buf>
ffffffe00020513c:	fcf43823          	sd	a5,-48(s0)
    uint64_t filesz = entry[index].size;
ffffffe000205140:	fdc46783          	lwu	a5,-36(s0)
ffffffe000205144:	00579793          	slli	a5,a5,0x5
ffffffe000205148:	fd043703          	ld	a4,-48(s0)
ffffffe00020514c:	00f707b3          	add	a5,a4,a5
ffffffe000205150:	01c7a783          	lw	a5,28(a5)
ffffffe000205154:	02079793          	slli	a5,a5,0x20
ffffffe000205158:	0207d793          	srli	a5,a5,0x20
ffffffe00020515c:	fcf43423          	sd	a5,-56(s0)

    uint64_t read_len = 0;
ffffffe000205160:	fe043423          	sd	zero,-24(s0)
    while (read_len < len && file->cfo < filesz) {
ffffffe000205164:	1180006f          	j	ffffffe00020527c <fat32_read+0x1c0>
        
        uint32_t cluster = find_cluster(file->fat32_file.cluster, file->cfo);// 当前簇 
ffffffe000205168:	f9843783          	ld	a5,-104(s0)
ffffffe00020516c:	0147a703          	lw	a4,20(a5)
ffffffe000205170:	f9843783          	ld	a5,-104(s0)
ffffffe000205174:	0087b783          	ld	a5,8(a5)
ffffffe000205178:	00078593          	mv	a1,a5
ffffffe00020517c:	00070513          	mv	a0,a4
ffffffe000205180:	ea1ff0ef          	jal	ra,ffffffe000205020 <find_cluster>
ffffffe000205184:	00050793          	mv	a5,a0
ffffffe000205188:	fcf42223          	sw	a5,-60(s0)
        uint64_t sector = cluster_to_sector(cluster); // 当前扇区
ffffffe00020518c:	fc446783          	lwu	a5,-60(s0)
ffffffe000205190:	00078513          	mv	a0,a5
ffffffe000205194:	cecff0ef          	jal	ra,ffffffe000204680 <cluster_to_sector>
ffffffe000205198:	faa43c23          	sd	a0,-72(s0)
        uint64_t offset_in_sector = file->cfo % VIRTIO_BLK_SECTOR_SIZE; // 当前扇区内偏移
ffffffe00020519c:	f9843783          	ld	a5,-104(s0)
ffffffe0002051a0:	0087b703          	ld	a4,8(a5)
ffffffe0002051a4:	43f75793          	srai	a5,a4,0x3f
ffffffe0002051a8:	0377d793          	srli	a5,a5,0x37
ffffffe0002051ac:	00f70733          	add	a4,a4,a5
ffffffe0002051b0:	1ff77713          	andi	a4,a4,511
ffffffe0002051b4:	40f707b3          	sub	a5,a4,a5
ffffffe0002051b8:	faf43823          	sd	a5,-80(s0)
        uint64_t read_size = VIRTIO_BLK_SECTOR_SIZE - offset_in_sector; // 当前扇区内剩余可读字节数
ffffffe0002051bc:	20000713          	li	a4,512
ffffffe0002051c0:	fb043783          	ld	a5,-80(s0)
ffffffe0002051c4:	40f707b3          	sub	a5,a4,a5
ffffffe0002051c8:	faf43423          	sd	a5,-88(s0)
        read_size = min(read_size, len - read_len);
ffffffe0002051cc:	f8843703          	ld	a4,-120(s0)
ffffffe0002051d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002051d4:	40f70733          	sub	a4,a4,a5
ffffffe0002051d8:	fa843783          	ld	a5,-88(s0)
ffffffe0002051dc:	00f77463          	bgeu	a4,a5,ffffffe0002051e4 <fat32_read+0x128>
ffffffe0002051e0:	00070793          	mv	a5,a4
ffffffe0002051e4:	faf43423          	sd	a5,-88(s0)
        read_size = min(read_size, filesz - file->cfo);
ffffffe0002051e8:	f9843783          	ld	a5,-104(s0)
ffffffe0002051ec:	0087b783          	ld	a5,8(a5)
ffffffe0002051f0:	00078713          	mv	a4,a5
ffffffe0002051f4:	fc843783          	ld	a5,-56(s0)
ffffffe0002051f8:	40e78733          	sub	a4,a5,a4
ffffffe0002051fc:	fa843783          	ld	a5,-88(s0)
ffffffe000205200:	00f77463          	bgeu	a4,a5,ffffffe000205208 <fat32_read+0x14c>
ffffffe000205204:	00070793          	mv	a5,a4
ffffffe000205208:	faf43423          	sd	a5,-88(s0)
        virtio_blk_read_sector(sector, fat32_buf);
ffffffe00020520c:	0000b597          	auipc	a1,0xb
ffffffe000205210:	01458593          	addi	a1,a1,20 # ffffffe000210220 <fat32_buf>
ffffffe000205214:	fb843503          	ld	a0,-72(s0)
ffffffe000205218:	20c010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
        memcpy(buf, fat32_buf + offset_in_sector, read_size);
ffffffe00020521c:	fb043703          	ld	a4,-80(s0)
ffffffe000205220:	0000b797          	auipc	a5,0xb
ffffffe000205224:	00078793          	mv	a5,a5
ffffffe000205228:	00f707b3          	add	a5,a4,a5
ffffffe00020522c:	fa843603          	ld	a2,-88(s0)
ffffffe000205230:	00078593          	mv	a1,a5
ffffffe000205234:	f9043503          	ld	a0,-112(s0)
ffffffe000205238:	ac8ff0ef          	jal	ra,ffffffe000204500 <memcpy>

        file->cfo += read_size;
ffffffe00020523c:	f9843783          	ld	a5,-104(s0)
ffffffe000205240:	0087b783          	ld	a5,8(a5) # ffffffe000210228 <fat32_buf+0x8>
ffffffe000205244:	00078713          	mv	a4,a5
ffffffe000205248:	fa843783          	ld	a5,-88(s0)
ffffffe00020524c:	00f707b3          	add	a5,a4,a5
ffffffe000205250:	00078713          	mv	a4,a5
ffffffe000205254:	f9843783          	ld	a5,-104(s0)
ffffffe000205258:	00e7b423          	sd	a4,8(a5)
        buf += read_size;
ffffffe00020525c:	f9043703          	ld	a4,-112(s0)
ffffffe000205260:	fa843783          	ld	a5,-88(s0)
ffffffe000205264:	00f707b3          	add	a5,a4,a5
ffffffe000205268:	f8f43823          	sd	a5,-112(s0)
        read_len += read_size;
ffffffe00020526c:	fe843703          	ld	a4,-24(s0)
ffffffe000205270:	fa843783          	ld	a5,-88(s0)
ffffffe000205274:	00f707b3          	add	a5,a4,a5
ffffffe000205278:	fef43423          	sd	a5,-24(s0)
    while (read_len < len && file->cfo < filesz) {
ffffffe00020527c:	fe843703          	ld	a4,-24(s0)
ffffffe000205280:	f8843783          	ld	a5,-120(s0)
ffffffe000205284:	00f77c63          	bgeu	a4,a5,ffffffe00020529c <fat32_read+0x1e0>
ffffffe000205288:	f9843783          	ld	a5,-104(s0)
ffffffe00020528c:	0087b783          	ld	a5,8(a5)
ffffffe000205290:	00078713          	mv	a4,a5
ffffffe000205294:	fc843783          	ld	a5,-56(s0)
ffffffe000205298:	ecf768e3          	bltu	a4,a5,ffffffe000205168 <fat32_read+0xac>
    }

    return read_len;
ffffffe00020529c:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002052a0:	00078513          	mv	a0,a5
ffffffe0002052a4:	07813083          	ld	ra,120(sp)
ffffffe0002052a8:	07013403          	ld	s0,112(sp)
ffffffe0002052ac:	08010113          	addi	sp,sp,128
ffffffe0002052b0:	00008067          	ret

ffffffe0002052b4 <fat32_write>:

int64_t fat32_write(struct file *file, const void *buf, uint64_t len) {
ffffffe0002052b4:	fa010113          	addi	sp,sp,-96
ffffffe0002052b8:	04113c23          	sd	ra,88(sp)
ffffffe0002052bc:	04813823          	sd	s0,80(sp)
ffffffe0002052c0:	06010413          	addi	s0,sp,96
ffffffe0002052c4:	faa43c23          	sd	a0,-72(s0)
ffffffe0002052c8:	fab43823          	sd	a1,-80(s0)
ffffffe0002052cc:	fac43423          	sd	a2,-88(s0)
    uint64_t write_len = 0;
ffffffe0002052d0:	fe043423          	sd	zero,-24(s0)
    while (len > 0) {
ffffffe0002052d4:	10c0006f          	j	ffffffe0002053e0 <fat32_write+0x12c>
        uint32_t cluster = find_cluster(file->fat32_file.cluster, file->cfo);
ffffffe0002052d8:	fb843783          	ld	a5,-72(s0)
ffffffe0002052dc:	0147a703          	lw	a4,20(a5)
ffffffe0002052e0:	fb843783          	ld	a5,-72(s0)
ffffffe0002052e4:	0087b783          	ld	a5,8(a5)
ffffffe0002052e8:	00078593          	mv	a1,a5
ffffffe0002052ec:	00070513          	mv	a0,a4
ffffffe0002052f0:	d31ff0ef          	jal	ra,ffffffe000205020 <find_cluster>
ffffffe0002052f4:	00050793          	mv	a5,a0
ffffffe0002052f8:	fcf42e23          	sw	a5,-36(s0)
        uint64_t sector = cluster_to_sector(cluster);
ffffffe0002052fc:	fdc46783          	lwu	a5,-36(s0)
ffffffe000205300:	00078513          	mv	a0,a5
ffffffe000205304:	b7cff0ef          	jal	ra,ffffffe000204680 <cluster_to_sector>
ffffffe000205308:	fca43823          	sd	a0,-48(s0)
        uint64_t offset_in_sector = file->cfo % VIRTIO_BLK_SECTOR_SIZE;
ffffffe00020530c:	fb843783          	ld	a5,-72(s0)
ffffffe000205310:	0087b703          	ld	a4,8(a5)
ffffffe000205314:	43f75793          	srai	a5,a4,0x3f
ffffffe000205318:	0377d793          	srli	a5,a5,0x37
ffffffe00020531c:	00f70733          	add	a4,a4,a5
ffffffe000205320:	1ff77713          	andi	a4,a4,511
ffffffe000205324:	40f707b3          	sub	a5,a4,a5
ffffffe000205328:	fcf43423          	sd	a5,-56(s0)
        uint64_t write_size = VIRTIO_BLK_SECTOR_SIZE - offset_in_sector;
ffffffe00020532c:	20000713          	li	a4,512
ffffffe000205330:	fc843783          	ld	a5,-56(s0)
ffffffe000205334:	40f707b3          	sub	a5,a4,a5
ffffffe000205338:	fef43023          	sd	a5,-32(s0)
        if (write_size > len) {
ffffffe00020533c:	fe043703          	ld	a4,-32(s0)
ffffffe000205340:	fa843783          	ld	a5,-88(s0)
ffffffe000205344:	00e7f663          	bgeu	a5,a4,ffffffe000205350 <fat32_write+0x9c>
            write_size = len;
ffffffe000205348:	fa843783          	ld	a5,-88(s0)
ffffffe00020534c:	fef43023          	sd	a5,-32(s0)
        }

        virtio_blk_read_sector(sector, fat32_buf);
ffffffe000205350:	0000b597          	auipc	a1,0xb
ffffffe000205354:	ed058593          	addi	a1,a1,-304 # ffffffe000210220 <fat32_buf>
ffffffe000205358:	fd043503          	ld	a0,-48(s0)
ffffffe00020535c:	0c8010ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
        memcpy(fat32_buf + offset_in_sector, buf, write_size);
ffffffe000205360:	fc843703          	ld	a4,-56(s0)
ffffffe000205364:	0000b797          	auipc	a5,0xb
ffffffe000205368:	ebc78793          	addi	a5,a5,-324 # ffffffe000210220 <fat32_buf>
ffffffe00020536c:	00f707b3          	add	a5,a4,a5
ffffffe000205370:	fe043603          	ld	a2,-32(s0)
ffffffe000205374:	fb043583          	ld	a1,-80(s0)
ffffffe000205378:	00078513          	mv	a0,a5
ffffffe00020537c:	984ff0ef          	jal	ra,ffffffe000204500 <memcpy>
        virtio_blk_write_sector(sector, fat32_buf);
ffffffe000205380:	0000b597          	auipc	a1,0xb
ffffffe000205384:	ea058593          	addi	a1,a1,-352 # ffffffe000210220 <fat32_buf>
ffffffe000205388:	fd043503          	ld	a0,-48(s0)
ffffffe00020538c:	114010ef          	jal	ra,ffffffe0002064a0 <virtio_blk_write_sector>

        file->cfo += write_size;
ffffffe000205390:	fb843783          	ld	a5,-72(s0)
ffffffe000205394:	0087b783          	ld	a5,8(a5)
ffffffe000205398:	00078713          	mv	a4,a5
ffffffe00020539c:	fe043783          	ld	a5,-32(s0)
ffffffe0002053a0:	00f707b3          	add	a5,a4,a5
ffffffe0002053a4:	00078713          	mv	a4,a5
ffffffe0002053a8:	fb843783          	ld	a5,-72(s0)
ffffffe0002053ac:	00e7b423          	sd	a4,8(a5)
        buf += write_size;
ffffffe0002053b0:	fb043703          	ld	a4,-80(s0)
ffffffe0002053b4:	fe043783          	ld	a5,-32(s0)
ffffffe0002053b8:	00f707b3          	add	a5,a4,a5
ffffffe0002053bc:	faf43823          	sd	a5,-80(s0)
        len -= write_size;
ffffffe0002053c0:	fa843703          	ld	a4,-88(s0)
ffffffe0002053c4:	fe043783          	ld	a5,-32(s0)
ffffffe0002053c8:	40f707b3          	sub	a5,a4,a5
ffffffe0002053cc:	faf43423          	sd	a5,-88(s0)
        write_len += write_size;
ffffffe0002053d0:	fe843703          	ld	a4,-24(s0)
ffffffe0002053d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002053d8:	00f707b3          	add	a5,a4,a5
ffffffe0002053dc:	fef43423          	sd	a5,-24(s0)
    while (len > 0) {
ffffffe0002053e0:	fa843783          	ld	a5,-88(s0)
ffffffe0002053e4:	ee079ae3          	bnez	a5,ffffffe0002052d8 <fat32_write+0x24>
    }
    return write_len;
ffffffe0002053e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002053ec:	00078513          	mv	a0,a5
ffffffe0002053f0:	05813083          	ld	ra,88(sp)
ffffffe0002053f4:	05013403          	ld	s0,80(sp)
ffffffe0002053f8:	06010113          	addi	sp,sp,96
ffffffe0002053fc:	00008067          	ret

ffffffe000205400 <file_init>:
#include "string.h"
#include "printk.h"
#include "fat32.h"

struct files_struct *file_init()
{
ffffffe000205400:	fe010113          	addi	sp,sp,-32
ffffffe000205404:	00113c23          	sd	ra,24(sp)
ffffffe000205408:	00813823          	sd	s0,16(sp)
ffffffe00020540c:	02010413          	addi	s0,sp,32
    // todo: alloc pages for files_struct, and initialize stdin, stdout, stderr
    // 根据files_struct的大小分配页空间；
    struct files_struct *ret = (struct files_struct *)alloc_page();
ffffffe000205410:	d50fb0ef          	jal	ra,ffffffe000200960 <alloc_page>
ffffffe000205414:	fea43023          	sd	a0,-32(s0)
    if (!ret)
ffffffe000205418:	fe043783          	ld	a5,-32(s0)
ffffffe00020541c:	00079663          	bnez	a5,ffffffe000205428 <file_init+0x28>
    {
        return NULL; // 分配失败
ffffffe000205420:	00000793          	li	a5,0
ffffffe000205424:	2640006f          	j	ffffffe000205688 <file_init+0x288>
    }

    ret->fd_array[0].opened = 1;
ffffffe000205428:	fe043783          	ld	a5,-32(s0)
ffffffe00020542c:	00100713          	li	a4,1
ffffffe000205430:	00e7a023          	sw	a4,0(a5)
    ret->fd_array[0].perms = FILE_READABLE;
ffffffe000205434:	fe043783          	ld	a5,-32(s0)
ffffffe000205438:	00100713          	li	a4,1
ffffffe00020543c:	00e7a223          	sw	a4,4(a5)
    ret->fd_array[0].cfo = 0;
ffffffe000205440:	fe043783          	ld	a5,-32(s0)
ffffffe000205444:	0007b423          	sd	zero,8(a5)
    ret->fd_array[0].lseek = NULL;
ffffffe000205448:	fe043783          	ld	a5,-32(s0)
ffffffe00020544c:	0207b023          	sd	zero,32(a5)
    ret->fd_array[0].write = NULL;
ffffffe000205450:	fe043783          	ld	a5,-32(s0)
ffffffe000205454:	0207b423          	sd	zero,40(a5)
    ret->fd_array[0].read = stdin_read;
ffffffe000205458:	fe043783          	ld	a5,-32(s0)
ffffffe00020545c:	00000717          	auipc	a4,0x0
ffffffe000205460:	63470713          	addi	a4,a4,1588 # ffffffe000205a90 <stdin_read>
ffffffe000205464:	02e7b823          	sd	a4,48(a5)
    memcpy(ret->fd_array[0].path, "stdin", 6);
ffffffe000205468:	fe043783          	ld	a5,-32(s0)
ffffffe00020546c:	03878793          	addi	a5,a5,56
ffffffe000205470:	00600613          	li	a2,6
ffffffe000205474:	00002597          	auipc	a1,0x2
ffffffe000205478:	79c58593          	addi	a1,a1,1948 # ffffffe000207c10 <__func__.0+0x10>
ffffffe00020547c:	00078513          	mv	a0,a5
ffffffe000205480:	880ff0ef          	jal	ra,ffffffe000204500 <memcpy>
    Log("file_init: stdin path: %s", ret->fd_array[0].path);
ffffffe000205484:	fe043783          	ld	a5,-32(s0)
ffffffe000205488:	03878793          	addi	a5,a5,56
ffffffe00020548c:	00078713          	mv	a4,a5
ffffffe000205490:	00003697          	auipc	a3,0x3
ffffffe000205494:	86068693          	addi	a3,a3,-1952 # ffffffe000207cf0 <__func__.1>
ffffffe000205498:	01900613          	li	a2,25
ffffffe00020549c:	00002597          	auipc	a1,0x2
ffffffe0002054a0:	77c58593          	addi	a1,a1,1916 # ffffffe000207c18 <__func__.0+0x18>
ffffffe0002054a4:	00002517          	auipc	a0,0x2
ffffffe0002054a8:	77c50513          	addi	a0,a0,1916 # ffffffe000207c20 <__func__.0+0x20>
ffffffe0002054ac:	ec5fe0ef          	jal	ra,ffffffe000204370 <printk>

    ret->fd_array[1].opened = 1;
ffffffe0002054b0:	fe043783          	ld	a5,-32(s0)
ffffffe0002054b4:	00100713          	li	a4,1
ffffffe0002054b8:	08e7a423          	sw	a4,136(a5)
    ret->fd_array[1].perms = FILE_WRITABLE;
ffffffe0002054bc:	fe043783          	ld	a5,-32(s0)
ffffffe0002054c0:	00200713          	li	a4,2
ffffffe0002054c4:	08e7a623          	sw	a4,140(a5)
    ret->fd_array[1].cfo = 0;
ffffffe0002054c8:	fe043783          	ld	a5,-32(s0)
ffffffe0002054cc:	0807b823          	sd	zero,144(a5)
    ret->fd_array[1].lseek = NULL;
ffffffe0002054d0:	fe043783          	ld	a5,-32(s0)
ffffffe0002054d4:	0a07b423          	sd	zero,168(a5)
    ret->fd_array[1].write = stdout_write;
ffffffe0002054d8:	fe043783          	ld	a5,-32(s0)
ffffffe0002054dc:	00000717          	auipc	a4,0x0
ffffffe0002054e0:	63070713          	addi	a4,a4,1584 # ffffffe000205b0c <stdout_write>
ffffffe0002054e4:	0ae7b823          	sd	a4,176(a5)
    ret->fd_array[1].read = NULL;
ffffffe0002054e8:	fe043783          	ld	a5,-32(s0)
ffffffe0002054ec:	0a07bc23          	sd	zero,184(a5)
    memcpy(ret->fd_array[1].path, "stdout", 7);
ffffffe0002054f0:	fe043783          	ld	a5,-32(s0)
ffffffe0002054f4:	0c078793          	addi	a5,a5,192
ffffffe0002054f8:	00700613          	li	a2,7
ffffffe0002054fc:	00002597          	auipc	a1,0x2
ffffffe000205500:	75c58593          	addi	a1,a1,1884 # ffffffe000207c58 <__func__.0+0x58>
ffffffe000205504:	00078513          	mv	a0,a5
ffffffe000205508:	ff9fe0ef          	jal	ra,ffffffe000204500 <memcpy>

    ret->fd_array[2].opened = 1;
ffffffe00020550c:	fe043783          	ld	a5,-32(s0)
ffffffe000205510:	00100713          	li	a4,1
ffffffe000205514:	10e7a823          	sw	a4,272(a5)
    ret->fd_array[2].perms = FILE_WRITABLE;
ffffffe000205518:	fe043783          	ld	a5,-32(s0)
ffffffe00020551c:	00200713          	li	a4,2
ffffffe000205520:	10e7aa23          	sw	a4,276(a5)
    ret->fd_array[2].cfo = 0;
ffffffe000205524:	fe043783          	ld	a5,-32(s0)
ffffffe000205528:	1007bc23          	sd	zero,280(a5)
    ret->fd_array[2].lseek = NULL;
ffffffe00020552c:	fe043783          	ld	a5,-32(s0)
ffffffe000205530:	1207b823          	sd	zero,304(a5)
    ret->fd_array[2].write = stderr_write;
ffffffe000205534:	fe043783          	ld	a5,-32(s0)
ffffffe000205538:	00000717          	auipc	a4,0x0
ffffffe00020553c:	6d870713          	addi	a4,a4,1752 # ffffffe000205c10 <stderr_write>
ffffffe000205540:	12e7bc23          	sd	a4,312(a5)
    ret->fd_array[2].read = NULL;
ffffffe000205544:	fe043783          	ld	a5,-32(s0)
ffffffe000205548:	1407b023          	sd	zero,320(a5)
    memcpy(ret->fd_array[2].path, "stderr", 7);
ffffffe00020554c:	fe043783          	ld	a5,-32(s0)
ffffffe000205550:	14878793          	addi	a5,a5,328
ffffffe000205554:	00700613          	li	a2,7
ffffffe000205558:	00002597          	auipc	a1,0x2
ffffffe00020555c:	70858593          	addi	a1,a1,1800 # ffffffe000207c60 <__func__.0+0x60>
ffffffe000205560:	00078513          	mv	a0,a5
ffffffe000205564:	f9dfe0ef          	jal	ra,ffffffe000204500 <memcpy>

    for (int i = 3; i < MAX_FILE_NUMBER; i++)
ffffffe000205568:	00300793          	li	a5,3
ffffffe00020556c:	fef42623          	sw	a5,-20(s0)
ffffffe000205570:	1040006f          	j	ffffffe000205674 <file_init+0x274>
    {
        ret->fd_array[i].opened = 0;
ffffffe000205574:	fe043683          	ld	a3,-32(s0)
ffffffe000205578:	fec42703          	lw	a4,-20(s0)
ffffffe00020557c:	00070793          	mv	a5,a4
ffffffe000205580:	00479793          	slli	a5,a5,0x4
ffffffe000205584:	00e787b3          	add	a5,a5,a4
ffffffe000205588:	00379793          	slli	a5,a5,0x3
ffffffe00020558c:	00f687b3          	add	a5,a3,a5
ffffffe000205590:	0007a023          	sw	zero,0(a5)
        ret->fd_array[i].perms = 0;
ffffffe000205594:	fe043683          	ld	a3,-32(s0)
ffffffe000205598:	fec42703          	lw	a4,-20(s0)
ffffffe00020559c:	00070793          	mv	a5,a4
ffffffe0002055a0:	00479793          	slli	a5,a5,0x4
ffffffe0002055a4:	00e787b3          	add	a5,a5,a4
ffffffe0002055a8:	00379793          	slli	a5,a5,0x3
ffffffe0002055ac:	00f687b3          	add	a5,a3,a5
ffffffe0002055b0:	0007a223          	sw	zero,4(a5)
        ret->fd_array[i].cfo = 0;
ffffffe0002055b4:	fe043683          	ld	a3,-32(s0)
ffffffe0002055b8:	fec42703          	lw	a4,-20(s0)
ffffffe0002055bc:	00070793          	mv	a5,a4
ffffffe0002055c0:	00479793          	slli	a5,a5,0x4
ffffffe0002055c4:	00e787b3          	add	a5,a5,a4
ffffffe0002055c8:	00379793          	slli	a5,a5,0x3
ffffffe0002055cc:	00f687b3          	add	a5,a3,a5
ffffffe0002055d0:	0007b423          	sd	zero,8(a5)
        ret->fd_array[i].lseek = NULL;
ffffffe0002055d4:	fe043683          	ld	a3,-32(s0)
ffffffe0002055d8:	fec42703          	lw	a4,-20(s0)
ffffffe0002055dc:	00070793          	mv	a5,a4
ffffffe0002055e0:	00479793          	slli	a5,a5,0x4
ffffffe0002055e4:	00e787b3          	add	a5,a5,a4
ffffffe0002055e8:	00379793          	slli	a5,a5,0x3
ffffffe0002055ec:	00f687b3          	add	a5,a3,a5
ffffffe0002055f0:	0207b023          	sd	zero,32(a5)
        ret->fd_array[i].write = NULL;
ffffffe0002055f4:	fe043683          	ld	a3,-32(s0)
ffffffe0002055f8:	fec42703          	lw	a4,-20(s0)
ffffffe0002055fc:	00070793          	mv	a5,a4
ffffffe000205600:	00479793          	slli	a5,a5,0x4
ffffffe000205604:	00e787b3          	add	a5,a5,a4
ffffffe000205608:	00379793          	slli	a5,a5,0x3
ffffffe00020560c:	00f687b3          	add	a5,a3,a5
ffffffe000205610:	0207b423          	sd	zero,40(a5)
        ret->fd_array[i].read = NULL;
ffffffe000205614:	fe043683          	ld	a3,-32(s0)
ffffffe000205618:	fec42703          	lw	a4,-20(s0)
ffffffe00020561c:	00070793          	mv	a5,a4
ffffffe000205620:	00479793          	slli	a5,a5,0x4
ffffffe000205624:	00e787b3          	add	a5,a5,a4
ffffffe000205628:	00379793          	slli	a5,a5,0x3
ffffffe00020562c:	00f687b3          	add	a5,a3,a5
ffffffe000205630:	0207b823          	sd	zero,48(a5)
        memset(ret->fd_array[i].path, 0, MAX_PATH_LENGTH);
ffffffe000205634:	fec42703          	lw	a4,-20(s0)
ffffffe000205638:	00070793          	mv	a5,a4
ffffffe00020563c:	00479793          	slli	a5,a5,0x4
ffffffe000205640:	00e787b3          	add	a5,a5,a4
ffffffe000205644:	00379793          	slli	a5,a5,0x3
ffffffe000205648:	03078793          	addi	a5,a5,48
ffffffe00020564c:	fe043703          	ld	a4,-32(s0)
ffffffe000205650:	00f707b3          	add	a5,a4,a5
ffffffe000205654:	00878793          	addi	a5,a5,8
ffffffe000205658:	05000613          	li	a2,80
ffffffe00020565c:	00000593          	li	a1,0
ffffffe000205660:	00078513          	mv	a0,a5
ffffffe000205664:	e2dfe0ef          	jal	ra,ffffffe000204490 <memset>
    for (int i = 3; i < MAX_FILE_NUMBER; i++)
ffffffe000205668:	fec42783          	lw	a5,-20(s0)
ffffffe00020566c:	0017879b          	addiw	a5,a5,1
ffffffe000205670:	fef42623          	sw	a5,-20(s0)
ffffffe000205674:	fec42783          	lw	a5,-20(s0)
ffffffe000205678:	0007871b          	sext.w	a4,a5
ffffffe00020567c:	00f00793          	li	a5,15
ffffffe000205680:	eee7dae3          	bge	a5,a4,ffffffe000205574 <file_init+0x174>
    }

    return ret;
ffffffe000205684:	fe043783          	ld	a5,-32(s0)
}
ffffffe000205688:	00078513          	mv	a0,a5
ffffffe00020568c:	01813083          	ld	ra,24(sp)
ffffffe000205690:	01013403          	ld	s0,16(sp)
ffffffe000205694:	02010113          	addi	sp,sp,32
ffffffe000205698:	00008067          	ret

ffffffe00020569c <get_fs_type>:

uint32_t get_fs_type(const char *filename)
{
ffffffe00020569c:	fd010113          	addi	sp,sp,-48
ffffffe0002056a0:	02113423          	sd	ra,40(sp)
ffffffe0002056a4:	02813023          	sd	s0,32(sp)
ffffffe0002056a8:	03010413          	addi	s0,sp,48
ffffffe0002056ac:	fca43c23          	sd	a0,-40(s0)
    uint32_t ret;
    if (memcmp(filename, "/fat32/", 7) == 0)
ffffffe0002056b0:	00700613          	li	a2,7
ffffffe0002056b4:	00002597          	auipc	a1,0x2
ffffffe0002056b8:	5b458593          	addi	a1,a1,1460 # ffffffe000207c68 <__func__.0+0x68>
ffffffe0002056bc:	fd843503          	ld	a0,-40(s0)
ffffffe0002056c0:	ebdfe0ef          	jal	ra,ffffffe00020457c <memcmp>
ffffffe0002056c4:	00050793          	mv	a5,a0
ffffffe0002056c8:	00079863          	bnez	a5,ffffffe0002056d8 <get_fs_type+0x3c>
    {
        ret = FS_TYPE_FAT32;
ffffffe0002056cc:	00100793          	li	a5,1
ffffffe0002056d0:	fef42623          	sw	a5,-20(s0)
ffffffe0002056d4:	0340006f          	j	ffffffe000205708 <get_fs_type+0x6c>
    }
    else if (memcmp(filename, "/ext2/", 6) == 0)
ffffffe0002056d8:	00600613          	li	a2,6
ffffffe0002056dc:	00002597          	auipc	a1,0x2
ffffffe0002056e0:	59458593          	addi	a1,a1,1428 # ffffffe000207c70 <__func__.0+0x70>
ffffffe0002056e4:	fd843503          	ld	a0,-40(s0)
ffffffe0002056e8:	e95fe0ef          	jal	ra,ffffffe00020457c <memcmp>
ffffffe0002056ec:	00050793          	mv	a5,a0
ffffffe0002056f0:	00079863          	bnez	a5,ffffffe000205700 <get_fs_type+0x64>
    {
        ret = FS_TYPE_EXT2;
ffffffe0002056f4:	00200793          	li	a5,2
ffffffe0002056f8:	fef42623          	sw	a5,-20(s0)
ffffffe0002056fc:	00c0006f          	j	ffffffe000205708 <get_fs_type+0x6c>
    }
    else
    {
        ret = -1;
ffffffe000205700:	fff00793          	li	a5,-1
ffffffe000205704:	fef42623          	sw	a5,-20(s0)
    }
    return ret;
ffffffe000205708:	fec42783          	lw	a5,-20(s0)
}
ffffffe00020570c:	00078513          	mv	a0,a5
ffffffe000205710:	02813083          	ld	ra,40(sp)
ffffffe000205714:	02013403          	ld	s0,32(sp)
ffffffe000205718:	03010113          	addi	sp,sp,48
ffffffe00020571c:	00008067          	ret

ffffffe000205720 <file_open>:

int32_t file_open(struct file *file, const char *path, int flags)
{
ffffffe000205720:	fc010113          	addi	sp,sp,-64
ffffffe000205724:	02113c23          	sd	ra,56(sp)
ffffffe000205728:	02813823          	sd	s0,48(sp)
ffffffe00020572c:	02913423          	sd	s1,40(sp)
ffffffe000205730:	04010413          	addi	s0,sp,64
ffffffe000205734:	fca43c23          	sd	a0,-40(s0)
ffffffe000205738:	fcb43823          	sd	a1,-48(s0)
ffffffe00020573c:	00060793          	mv	a5,a2
ffffffe000205740:	fcf42623          	sw	a5,-52(s0)
    file->opened = 1;
ffffffe000205744:	fd843783          	ld	a5,-40(s0)
ffffffe000205748:	00100713          	li	a4,1
ffffffe00020574c:	00e7a023          	sw	a4,0(a5)
    file->perms = flags;
ffffffe000205750:	fcc42703          	lw	a4,-52(s0)
ffffffe000205754:	fd843783          	ld	a5,-40(s0)
ffffffe000205758:	00e7a223          	sw	a4,4(a5)
    file->cfo = 0;
ffffffe00020575c:	fd843783          	ld	a5,-40(s0)
ffffffe000205760:	0007b423          	sd	zero,8(a5)
    file->fs_type = get_fs_type(path);
ffffffe000205764:	fd043503          	ld	a0,-48(s0)
ffffffe000205768:	f35ff0ef          	jal	ra,ffffffe00020569c <get_fs_type>
ffffffe00020576c:	00050793          	mv	a5,a0
ffffffe000205770:	0007871b          	sext.w	a4,a5
ffffffe000205774:	fd843783          	ld	a5,-40(s0)
ffffffe000205778:	00e7a823          	sw	a4,16(a5)
    memcpy(file->path, path, strlen(path) + 1);
ffffffe00020577c:	fd843783          	ld	a5,-40(s0)
ffffffe000205780:	03878493          	addi	s1,a5,56
ffffffe000205784:	fd043503          	ld	a0,-48(s0)
ffffffe000205788:	eadfe0ef          	jal	ra,ffffffe000204634 <strlen>
ffffffe00020578c:	00050793          	mv	a5,a0
ffffffe000205790:	00178793          	addi	a5,a5,1
ffffffe000205794:	00078613          	mv	a2,a5
ffffffe000205798:	fd043583          	ld	a1,-48(s0)
ffffffe00020579c:	00048513          	mv	a0,s1
ffffffe0002057a0:	d61fe0ef          	jal	ra,ffffffe000204500 <memcpy>

    if (file->fs_type == FS_TYPE_FAT32)
ffffffe0002057a4:	fd843783          	ld	a5,-40(s0)
ffffffe0002057a8:	0107a783          	lw	a5,16(a5)
ffffffe0002057ac:	00078713          	mv	a4,a5
ffffffe0002057b0:	00100793          	li	a5,1
ffffffe0002057b4:	08f71663          	bne	a4,a5,ffffffe000205840 <file_open+0x120>
    {
        file->lseek = fat32_lseek;
ffffffe0002057b8:	fd843783          	ld	a5,-40(s0)
ffffffe0002057bc:	fffff717          	auipc	a4,0xfffff
ffffffe0002057c0:	6dc70713          	addi	a4,a4,1756 # ffffffe000204e98 <fat32_lseek>
ffffffe0002057c4:	02e7b023          	sd	a4,32(a5)
        file->write = fat32_write;
ffffffe0002057c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002057cc:	00000717          	auipc	a4,0x0
ffffffe0002057d0:	ae870713          	addi	a4,a4,-1304 # ffffffe0002052b4 <fat32_write>
ffffffe0002057d4:	02e7b423          	sd	a4,40(a5)
        file->read = fat32_read;
ffffffe0002057d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002057dc:	00000717          	auipc	a4,0x0
ffffffe0002057e0:	8e070713          	addi	a4,a4,-1824 # ffffffe0002050bc <fat32_read>
ffffffe0002057e4:	02e7b823          	sd	a4,48(a5)
        file->fat32_file = fat32_open_file(path);
ffffffe0002057e8:	fd843483          	ld	s1,-40(s0)
ffffffe0002057ec:	fd043503          	ld	a0,-48(s0)
ffffffe0002057f0:	b6cff0ef          	jal	ra,ffffffe000204b5c <fat32_open_file>
ffffffe0002057f4:	00050713          	mv	a4,a0
ffffffe0002057f8:	00058793          	mv	a5,a1
ffffffe0002057fc:	00e4aa23          	sw	a4,20(s1)
ffffffe000205800:	02075693          	srli	a3,a4,0x20
ffffffe000205804:	00d4ac23          	sw	a3,24(s1)
ffffffe000205808:	00f4ae23          	sw	a5,28(s1)
        Log("file_open: %s, cluster: %d", path, file->fat32_file.cluster);
ffffffe00020580c:	fd843783          	ld	a5,-40(s0)
ffffffe000205810:	0147a783          	lw	a5,20(a5)
ffffffe000205814:	fd043703          	ld	a4,-48(s0)
ffffffe000205818:	00002697          	auipc	a3,0x2
ffffffe00020581c:	4e868693          	addi	a3,a3,1256 # ffffffe000207d00 <__func__.0>
ffffffe000205820:	05900613          	li	a2,89
ffffffe000205824:	00002597          	auipc	a1,0x2
ffffffe000205828:	3f458593          	addi	a1,a1,1012 # ffffffe000207c18 <__func__.0+0x18>
ffffffe00020582c:	00002517          	auipc	a0,0x2
ffffffe000205830:	44c50513          	addi	a0,a0,1100 # ffffffe000207c78 <__func__.0+0x78>
ffffffe000205834:	b3dfe0ef          	jal	ra,ffffffe000204370 <printk>
        return 0;
ffffffe000205838:	00000793          	li	a5,0
ffffffe00020583c:	0400006f          	j	ffffffe00020587c <file_open+0x15c>
        // todo: check if fat32_file is valid (i.e. successfully opened) and return
    }
    else if (file->fs_type == FS_TYPE_EXT2)
ffffffe000205840:	fd843783          	ld	a5,-40(s0)
ffffffe000205844:	0107a783          	lw	a5,16(a5)
ffffffe000205848:	00078713          	mv	a4,a5
ffffffe00020584c:	00200793          	li	a5,2
ffffffe000205850:	00f71c63          	bne	a4,a5,ffffffe000205868 <file_open+0x148>
    {
        printk(RED "Unsupport ext2\n" CLEAR);
ffffffe000205854:	00002517          	auipc	a0,0x2
ffffffe000205858:	45c50513          	addi	a0,a0,1116 # ffffffe000207cb0 <__func__.0+0xb0>
ffffffe00020585c:	b15fe0ef          	jal	ra,ffffffe000204370 <printk>
        return -1;
ffffffe000205860:	fff00793          	li	a5,-1
ffffffe000205864:	0180006f          	j	ffffffe00020587c <file_open+0x15c>
    }
    else
    {
        printk(RED "Unknown fs type: %s\n" CLEAR, path);
ffffffe000205868:	fd043583          	ld	a1,-48(s0)
ffffffe00020586c:	00002517          	auipc	a0,0x2
ffffffe000205870:	46450513          	addi	a0,a0,1124 # ffffffe000207cd0 <__func__.0+0xd0>
ffffffe000205874:	afdfe0ef          	jal	ra,ffffffe000204370 <printk>
        return -1;
ffffffe000205878:	fff00793          	li	a5,-1
    }
ffffffe00020587c:	00078513          	mv	a0,a5
ffffffe000205880:	03813083          	ld	ra,56(sp)
ffffffe000205884:	03013403          	ld	s0,48(sp)
ffffffe000205888:	02813483          	ld	s1,40(sp)
ffffffe00020588c:	04010113          	addi	sp,sp,64
ffffffe000205890:	00008067          	ret

ffffffe000205894 <mbr_init>:
#include "fat32.h"

uint8_t mbr_buf[VIRTIO_BLK_SECTOR_SIZE];
struct partition_info partitions[MBR_MAX_PARTITIONS];

void mbr_init() {
ffffffe000205894:	fd010113          	addi	sp,sp,-48
ffffffe000205898:	02113423          	sd	ra,40(sp)
ffffffe00020589c:	02813023          	sd	s0,32(sp)
ffffffe0002058a0:	03010413          	addi	s0,sp,48
    virtio_blk_read_sector(0, mbr_buf);
ffffffe0002058a4:	0000b597          	auipc	a1,0xb
ffffffe0002058a8:	d7c58593          	addi	a1,a1,-644 # ffffffe000210620 <mbr_buf>
ffffffe0002058ac:	00000513          	li	a0,0
ffffffe0002058b0:	375000ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>
    struct mbr_layout *mbr = (struct mbr_layout *)mbr_buf;
ffffffe0002058b4:	0000b797          	auipc	a5,0xb
ffffffe0002058b8:	d6c78793          	addi	a5,a5,-660 # ffffffe000210620 <mbr_buf>
ffffffe0002058bc:	fef43023          	sd	a5,-32(s0)
    for (int i = 0; i < 4; i++) {
ffffffe0002058c0:	fe042623          	sw	zero,-20(s0)
ffffffe0002058c4:	0d40006f          	j	ffffffe000205998 <mbr_init+0x104>
        if (mbr->partition_table[i].type == 0x83) {
ffffffe0002058c8:	fe043703          	ld	a4,-32(s0)
ffffffe0002058cc:	fec42783          	lw	a5,-20(s0)
ffffffe0002058d0:	01b78793          	addi	a5,a5,27
ffffffe0002058d4:	00479793          	slli	a5,a5,0x4
ffffffe0002058d8:	00f707b3          	add	a5,a4,a5
ffffffe0002058dc:	0127c783          	lbu	a5,18(a5)
ffffffe0002058e0:	00078713          	mv	a4,a5
ffffffe0002058e4:	08300793          	li	a5,131
ffffffe0002058e8:	0af71263          	bne	a4,a5,ffffffe00020598c <mbr_init+0xf8>
            uint32_t lba = mbr->partition_table[i].lba_first_sector;
ffffffe0002058ec:	fe043703          	ld	a4,-32(s0)
ffffffe0002058f0:	fec42783          	lw	a5,-20(s0)
ffffffe0002058f4:	01b78793          	addi	a5,a5,27
ffffffe0002058f8:	00479793          	slli	a5,a5,0x4
ffffffe0002058fc:	00f707b3          	add	a5,a4,a5
ffffffe000205900:	0167c703          	lbu	a4,22(a5)
ffffffe000205904:	0177c683          	lbu	a3,23(a5)
ffffffe000205908:	00869693          	slli	a3,a3,0x8
ffffffe00020590c:	00e6e733          	or	a4,a3,a4
ffffffe000205910:	0187c683          	lbu	a3,24(a5)
ffffffe000205914:	01069693          	slli	a3,a3,0x10
ffffffe000205918:	00e6e733          	or	a4,a3,a4
ffffffe00020591c:	0197c783          	lbu	a5,25(a5)
ffffffe000205920:	01879793          	slli	a5,a5,0x18
ffffffe000205924:	00e7e7b3          	or	a5,a5,a4
ffffffe000205928:	fcf42e23          	sw	a5,-36(s0)
            partition_init(i + 1, lba, mbr->partition_table[i].sector_count);
ffffffe00020592c:	fec42783          	lw	a5,-20(s0)
ffffffe000205930:	0017879b          	addiw	a5,a5,1
ffffffe000205934:	0007851b          	sext.w	a0,a5
ffffffe000205938:	fdc46583          	lwu	a1,-36(s0)
ffffffe00020593c:	fe043703          	ld	a4,-32(s0)
ffffffe000205940:	fec42783          	lw	a5,-20(s0)
ffffffe000205944:	01b78793          	addi	a5,a5,27
ffffffe000205948:	00479793          	slli	a5,a5,0x4
ffffffe00020594c:	00f707b3          	add	a5,a4,a5
ffffffe000205950:	01a7c703          	lbu	a4,26(a5)
ffffffe000205954:	01b7c683          	lbu	a3,27(a5)
ffffffe000205958:	00869693          	slli	a3,a3,0x8
ffffffe00020595c:	00e6e733          	or	a4,a3,a4
ffffffe000205960:	01c7c683          	lbu	a3,28(a5)
ffffffe000205964:	01069693          	slli	a3,a3,0x10
ffffffe000205968:	00e6e733          	or	a4,a3,a4
ffffffe00020596c:	01d7c783          	lbu	a5,29(a5)
ffffffe000205970:	01879793          	slli	a5,a5,0x18
ffffffe000205974:	00e7e7b3          	or	a5,a5,a4
ffffffe000205978:	0007879b          	sext.w	a5,a5
ffffffe00020597c:	02079793          	slli	a5,a5,0x20
ffffffe000205980:	0207d793          	srli	a5,a5,0x20
ffffffe000205984:	00078613          	mv	a2,a5
ffffffe000205988:	038000ef          	jal	ra,ffffffe0002059c0 <partition_init>
    for (int i = 0; i < 4; i++) {
ffffffe00020598c:	fec42783          	lw	a5,-20(s0)
ffffffe000205990:	0017879b          	addiw	a5,a5,1
ffffffe000205994:	fef42623          	sw	a5,-20(s0)
ffffffe000205998:	fec42783          	lw	a5,-20(s0)
ffffffe00020599c:	0007871b          	sext.w	a4,a5
ffffffe0002059a0:	00300793          	li	a5,3
ffffffe0002059a4:	f2e7d2e3          	bge	a5,a4,ffffffe0002058c8 <mbr_init+0x34>
        }
    }
}
ffffffe0002059a8:	00000013          	nop
ffffffe0002059ac:	00000013          	nop
ffffffe0002059b0:	02813083          	ld	ra,40(sp)
ffffffe0002059b4:	02013403          	ld	s0,32(sp)
ffffffe0002059b8:	03010113          	addi	sp,sp,48
ffffffe0002059bc:	00008067          	ret

ffffffe0002059c0 <partition_init>:

void partition_init(int partion_number, uint64_t start_lba, uint64_t sector_count) {
ffffffe0002059c0:	fd010113          	addi	sp,sp,-48
ffffffe0002059c4:	02113423          	sd	ra,40(sp)
ffffffe0002059c8:	02813023          	sd	s0,32(sp)
ffffffe0002059cc:	03010413          	addi	s0,sp,48
ffffffe0002059d0:	00050793          	mv	a5,a0
ffffffe0002059d4:	feb43023          	sd	a1,-32(s0)
ffffffe0002059d8:	fcc43c23          	sd	a2,-40(s0)
ffffffe0002059dc:	fef42623          	sw	a5,-20(s0)
    if (is_fat32(start_lba)) {
ffffffe0002059e0:	fe043503          	ld	a0,-32(s0)
ffffffe0002059e4:	f7dfe0ef          	jal	ra,ffffffe000204960 <is_fat32>
ffffffe0002059e8:	00050793          	mv	a5,a0
ffffffe0002059ec:	02078263          	beqz	a5,ffffffe000205a10 <partition_init+0x50>
        fat32_init(start_lba, sector_count);
ffffffe0002059f0:	fd843583          	ld	a1,-40(s0)
ffffffe0002059f4:	fe043503          	ld	a0,-32(s0)
ffffffe0002059f8:	da5fe0ef          	jal	ra,ffffffe00020479c <fat32_init>
        printk("...fat32 partition #%d init done!\n", partion_number);
ffffffe0002059fc:	fec42783          	lw	a5,-20(s0)
ffffffe000205a00:	00078593          	mv	a1,a5
ffffffe000205a04:	00002517          	auipc	a0,0x2
ffffffe000205a08:	30c50513          	addi	a0,a0,780 # ffffffe000207d10 <__func__.0+0x10>
ffffffe000205a0c:	965fe0ef          	jal	ra,ffffffe000204370 <printk>
    }
}
ffffffe000205a10:	00000013          	nop
ffffffe000205a14:	02813083          	ld	ra,40(sp)
ffffffe000205a18:	02013403          	ld	s0,32(sp)
ffffffe000205a1c:	03010113          	addi	sp,sp,48
ffffffe000205a20:	00008067          	ret

ffffffe000205a24 <uart_getchar>:
#include "vfs.h"
#include "sbi.h"
#include "defs.h"
#include "printk.h"

char uart_getchar() {
ffffffe000205a24:	fd010113          	addi	sp,sp,-48
ffffffe000205a28:	02113423          	sd	ra,40(sp)
ffffffe000205a2c:	02813023          	sd	s0,32(sp)
ffffffe000205a30:	03010413          	addi	s0,sp,48
    char ret;
    while (1) {
        struct sbiret sbi_result = sbi_debug_console_read(1, ((uint64_t)&ret - PA2VA_OFFSET), 0);
ffffffe000205a34:	fef40713          	addi	a4,s0,-17
ffffffe000205a38:	04100793          	li	a5,65
ffffffe000205a3c:	01f79793          	slli	a5,a5,0x1f
ffffffe000205a40:	00f707b3          	add	a5,a4,a5
ffffffe000205a44:	00000613          	li	a2,0
ffffffe000205a48:	00078593          	mv	a1,a5
ffffffe000205a4c:	00100513          	li	a0,1
ffffffe000205a50:	e15fb0ef          	jal	ra,ffffffe000201864 <sbi_debug_console_read>
ffffffe000205a54:	00050713          	mv	a4,a0
ffffffe000205a58:	00058793          	mv	a5,a1
ffffffe000205a5c:	fce43c23          	sd	a4,-40(s0)
ffffffe000205a60:	fef43023          	sd	a5,-32(s0)
        // Log("uart_getchar: sbi_result.error = %d, sbi_result.value = %d", sbi_result.error, sbi_result.value);
        if (sbi_result.error == 0 && sbi_result.value == 1) {
ffffffe000205a64:	fd843783          	ld	a5,-40(s0)
ffffffe000205a68:	fc0796e3          	bnez	a5,ffffffe000205a34 <uart_getchar+0x10>
ffffffe000205a6c:	fe043703          	ld	a4,-32(s0)
ffffffe000205a70:	00100793          	li	a5,1
ffffffe000205a74:	fcf710e3          	bne	a4,a5,ffffffe000205a34 <uart_getchar+0x10>
            break;
        }
    }
    return ret;
ffffffe000205a78:	fef44783          	lbu	a5,-17(s0)
}
ffffffe000205a7c:	00078513          	mv	a0,a5
ffffffe000205a80:	02813083          	ld	ra,40(sp)
ffffffe000205a84:	02013403          	ld	s0,32(sp)
ffffffe000205a88:	03010113          	addi	sp,sp,48
ffffffe000205a8c:	00008067          	ret

ffffffe000205a90 <stdin_read>:

int64_t stdin_read(struct file *file, void *buf, uint64_t len) {
ffffffe000205a90:	fb010113          	addi	sp,sp,-80
ffffffe000205a94:	04113423          	sd	ra,72(sp)
ffffffe000205a98:	04813023          	sd	s0,64(sp)
ffffffe000205a9c:	02913c23          	sd	s1,56(sp)
ffffffe000205aa0:	05010413          	addi	s0,sp,80
ffffffe000205aa4:	fca43423          	sd	a0,-56(s0)
ffffffe000205aa8:	fcb43023          	sd	a1,-64(s0)
ffffffe000205aac:	fac43c23          	sd	a2,-72(s0)
    // Log("stdin_read: len = %d", len);
    char *buffer = (char *)buf;
ffffffe000205ab0:	fc043783          	ld	a5,-64(s0)
ffffffe000205ab4:	fcf43823          	sd	a5,-48(s0)
    for (uint64_t i = 0; i < len; i++) {
ffffffe000205ab8:	fc043c23          	sd	zero,-40(s0)
ffffffe000205abc:	0280006f          	j	ffffffe000205ae4 <stdin_read+0x54>
        // Log("stdin_read: buffer[%d] = %c", i, buffer[i]);
        buffer[i] = uart_getchar();
ffffffe000205ac0:	fd043703          	ld	a4,-48(s0)
ffffffe000205ac4:	fd843783          	ld	a5,-40(s0)
ffffffe000205ac8:	00f704b3          	add	s1,a4,a5
ffffffe000205acc:	f59ff0ef          	jal	ra,ffffffe000205a24 <uart_getchar>
ffffffe000205ad0:	00050793          	mv	a5,a0
ffffffe000205ad4:	00f48023          	sb	a5,0(s1)
    for (uint64_t i = 0; i < len; i++) {
ffffffe000205ad8:	fd843783          	ld	a5,-40(s0)
ffffffe000205adc:	00178793          	addi	a5,a5,1
ffffffe000205ae0:	fcf43c23          	sd	a5,-40(s0)
ffffffe000205ae4:	fd843703          	ld	a4,-40(s0)
ffffffe000205ae8:	fb843783          	ld	a5,-72(s0)
ffffffe000205aec:	fcf76ae3          	bltu	a4,a5,ffffffe000205ac0 <stdin_read+0x30>
        // Log("stdin_read: buffer[%d] = %c", i, buffer[i]);
    }
    return len;
ffffffe000205af0:	fb843783          	ld	a5,-72(s0)
}
ffffffe000205af4:	00078513          	mv	a0,a5
ffffffe000205af8:	04813083          	ld	ra,72(sp)
ffffffe000205afc:	04013403          	ld	s0,64(sp)
ffffffe000205b00:	03813483          	ld	s1,56(sp)
ffffffe000205b04:	05010113          	addi	sp,sp,80
ffffffe000205b08:	00008067          	ret

ffffffe000205b0c <stdout_write>:

int64_t stdout_write(struct file *file, const void *buf, uint64_t len) {
ffffffe000205b0c:	fa010113          	addi	sp,sp,-96
ffffffe000205b10:	04113c23          	sd	ra,88(sp)
ffffffe000205b14:	04813823          	sd	s0,80(sp)
ffffffe000205b18:	04913423          	sd	s1,72(sp)
ffffffe000205b1c:	06010413          	addi	s0,sp,96
ffffffe000205b20:	faa43c23          	sd	a0,-72(s0)
ffffffe000205b24:	fab43823          	sd	a1,-80(s0)
ffffffe000205b28:	fac43423          	sd	a2,-88(s0)
ffffffe000205b2c:	00010693          	mv	a3,sp
ffffffe000205b30:	00068493          	mv	s1,a3
    char to_print[len + 1];
ffffffe000205b34:	fa843683          	ld	a3,-88(s0)
ffffffe000205b38:	00168693          	addi	a3,a3,1
ffffffe000205b3c:	00068613          	mv	a2,a3
ffffffe000205b40:	fff60613          	addi	a2,a2,-1 # 10000fff <PHY_SIZE+0x8000fff>
ffffffe000205b44:	fcc43823          	sd	a2,-48(s0)
ffffffe000205b48:	00068e13          	mv	t3,a3
ffffffe000205b4c:	00000e93          	li	t4,0
ffffffe000205b50:	03de5613          	srli	a2,t3,0x3d
ffffffe000205b54:	003e9893          	slli	a7,t4,0x3
ffffffe000205b58:	011668b3          	or	a7,a2,a7
ffffffe000205b5c:	003e1813          	slli	a6,t3,0x3
ffffffe000205b60:	00068313          	mv	t1,a3
ffffffe000205b64:	00000393          	li	t2,0
ffffffe000205b68:	03d35613          	srli	a2,t1,0x3d
ffffffe000205b6c:	00339793          	slli	a5,t2,0x3
ffffffe000205b70:	00f667b3          	or	a5,a2,a5
ffffffe000205b74:	00331713          	slli	a4,t1,0x3
ffffffe000205b78:	00f68793          	addi	a5,a3,15
ffffffe000205b7c:	0047d793          	srli	a5,a5,0x4
ffffffe000205b80:	00479793          	slli	a5,a5,0x4
ffffffe000205b84:	40f10133          	sub	sp,sp,a5
ffffffe000205b88:	00010793          	mv	a5,sp
ffffffe000205b8c:	00078793          	mv	a5,a5
ffffffe000205b90:	fcf43423          	sd	a5,-56(s0)
    for (int i = 0; i < len; i++) {
ffffffe000205b94:	fc042e23          	sw	zero,-36(s0)
ffffffe000205b98:	0300006f          	j	ffffffe000205bc8 <stdout_write+0xbc>
        to_print[i] = ((const char *)buf)[i];
ffffffe000205b9c:	fdc42783          	lw	a5,-36(s0)
ffffffe000205ba0:	fb043703          	ld	a4,-80(s0)
ffffffe000205ba4:	00f707b3          	add	a5,a4,a5
ffffffe000205ba8:	0007c703          	lbu	a4,0(a5)
ffffffe000205bac:	fc843683          	ld	a3,-56(s0)
ffffffe000205bb0:	fdc42783          	lw	a5,-36(s0)
ffffffe000205bb4:	00f687b3          	add	a5,a3,a5
ffffffe000205bb8:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < len; i++) {
ffffffe000205bbc:	fdc42783          	lw	a5,-36(s0)
ffffffe000205bc0:	0017879b          	addiw	a5,a5,1
ffffffe000205bc4:	fcf42e23          	sw	a5,-36(s0)
ffffffe000205bc8:	fdc42783          	lw	a5,-36(s0)
ffffffe000205bcc:	fa843703          	ld	a4,-88(s0)
ffffffe000205bd0:	fce7e6e3          	bltu	a5,a4,ffffffe000205b9c <stdout_write+0x90>
    }
    to_print[len] = 0;
ffffffe000205bd4:	fc843703          	ld	a4,-56(s0)
ffffffe000205bd8:	fa843783          	ld	a5,-88(s0)
ffffffe000205bdc:	00f707b3          	add	a5,a4,a5
ffffffe000205be0:	00078023          	sb	zero,0(a5)
    return printk(buf);
ffffffe000205be4:	fb043503          	ld	a0,-80(s0)
ffffffe000205be8:	f88fe0ef          	jal	ra,ffffffe000204370 <printk>
ffffffe000205bec:	00050793          	mv	a5,a0
ffffffe000205bf0:	00048113          	mv	sp,s1
}
ffffffe000205bf4:	00078513          	mv	a0,a5
ffffffe000205bf8:	fa040113          	addi	sp,s0,-96
ffffffe000205bfc:	05813083          	ld	ra,88(sp)
ffffffe000205c00:	05013403          	ld	s0,80(sp)
ffffffe000205c04:	04813483          	ld	s1,72(sp)
ffffffe000205c08:	06010113          	addi	sp,sp,96
ffffffe000205c0c:	00008067          	ret

ffffffe000205c10 <stderr_write>:

int64_t stderr_write(struct file *file, const void *buf, uint64_t len) {
ffffffe000205c10:	fa010113          	addi	sp,sp,-96
ffffffe000205c14:	04113c23          	sd	ra,88(sp)
ffffffe000205c18:	04813823          	sd	s0,80(sp)
ffffffe000205c1c:	04913423          	sd	s1,72(sp)
ffffffe000205c20:	06010413          	addi	s0,sp,96
ffffffe000205c24:	faa43c23          	sd	a0,-72(s0)
ffffffe000205c28:	fab43823          	sd	a1,-80(s0)
ffffffe000205c2c:	fac43423          	sd	a2,-88(s0)
ffffffe000205c30:	00010693          	mv	a3,sp
ffffffe000205c34:	00068493          	mv	s1,a3
    // todo
    char to_print[len + 1];
ffffffe000205c38:	fa843683          	ld	a3,-88(s0)
ffffffe000205c3c:	00168693          	addi	a3,a3,1
ffffffe000205c40:	00068613          	mv	a2,a3
ffffffe000205c44:	fff60613          	addi	a2,a2,-1
ffffffe000205c48:	fcc43823          	sd	a2,-48(s0)
ffffffe000205c4c:	00068e13          	mv	t3,a3
ffffffe000205c50:	00000e93          	li	t4,0
ffffffe000205c54:	03de5613          	srli	a2,t3,0x3d
ffffffe000205c58:	003e9893          	slli	a7,t4,0x3
ffffffe000205c5c:	011668b3          	or	a7,a2,a7
ffffffe000205c60:	003e1813          	slli	a6,t3,0x3
ffffffe000205c64:	00068313          	mv	t1,a3
ffffffe000205c68:	00000393          	li	t2,0
ffffffe000205c6c:	03d35613          	srli	a2,t1,0x3d
ffffffe000205c70:	00339793          	slli	a5,t2,0x3
ffffffe000205c74:	00f667b3          	or	a5,a2,a5
ffffffe000205c78:	00331713          	slli	a4,t1,0x3
ffffffe000205c7c:	00f68793          	addi	a5,a3,15
ffffffe000205c80:	0047d793          	srli	a5,a5,0x4
ffffffe000205c84:	00479793          	slli	a5,a5,0x4
ffffffe000205c88:	40f10133          	sub	sp,sp,a5
ffffffe000205c8c:	00010793          	mv	a5,sp
ffffffe000205c90:	00078793          	mv	a5,a5
ffffffe000205c94:	fcf43423          	sd	a5,-56(s0)
    for (int i = 0; i < len; i++) {
ffffffe000205c98:	fc042e23          	sw	zero,-36(s0)
ffffffe000205c9c:	0300006f          	j	ffffffe000205ccc <stderr_write+0xbc>
        to_print[i] = ((const char *)buf)[i];
ffffffe000205ca0:	fdc42783          	lw	a5,-36(s0)
ffffffe000205ca4:	fb043703          	ld	a4,-80(s0)
ffffffe000205ca8:	00f707b3          	add	a5,a4,a5
ffffffe000205cac:	0007c703          	lbu	a4,0(a5)
ffffffe000205cb0:	fc843683          	ld	a3,-56(s0)
ffffffe000205cb4:	fdc42783          	lw	a5,-36(s0)
ffffffe000205cb8:	00f687b3          	add	a5,a3,a5
ffffffe000205cbc:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < len; i++) {
ffffffe000205cc0:	fdc42783          	lw	a5,-36(s0)
ffffffe000205cc4:	0017879b          	addiw	a5,a5,1
ffffffe000205cc8:	fcf42e23          	sw	a5,-36(s0)
ffffffe000205ccc:	fdc42783          	lw	a5,-36(s0)
ffffffe000205cd0:	fa843703          	ld	a4,-88(s0)
ffffffe000205cd4:	fce7e6e3          	bltu	a5,a4,ffffffe000205ca0 <stderr_write+0x90>
    }
    to_print[len] = 0;
ffffffe000205cd8:	fc843703          	ld	a4,-56(s0)
ffffffe000205cdc:	fa843783          	ld	a5,-88(s0)
ffffffe000205ce0:	00f707b3          	add	a5,a4,a5
ffffffe000205ce4:	00078023          	sb	zero,0(a5)
    
    // stderr
    printk("[stderr] %s", to_print);
ffffffe000205ce8:	fc843583          	ld	a1,-56(s0)
ffffffe000205cec:	00002517          	auipc	a0,0x2
ffffffe000205cf0:	04c50513          	addi	a0,a0,76 # ffffffe000207d38 <__func__.0+0x38>
ffffffe000205cf4:	e7cfe0ef          	jal	ra,ffffffe000204370 <printk>
    return len;  // return the length of the string
ffffffe000205cf8:	fa843783          	ld	a5,-88(s0)
ffffffe000205cfc:	00048113          	mv	sp,s1
}
ffffffe000205d00:	00078513          	mv	a0,a5
ffffffe000205d04:	fa040113          	addi	sp,s0,-96
ffffffe000205d08:	05813083          	ld	ra,88(sp)
ffffffe000205d0c:	05013403          	ld	s0,80(sp)
ffffffe000205d10:	04813483          	ld	s1,72(sp)
ffffffe000205d14:	06010113          	addi	sp,sp,96
ffffffe000205d18:	00008067          	ret

ffffffe000205d1c <in32>:
static inline uint32_t in32(uint32_t *memory_address) {
ffffffe000205d1c:	fd010113          	addi	sp,sp,-48
ffffffe000205d20:	02813423          	sd	s0,40(sp)
ffffffe000205d24:	03010413          	addi	s0,sp,48
ffffffe000205d28:	fca43c23          	sd	a0,-40(s0)
    asm volatile (
ffffffe000205d2c:	fd843783          	ld	a5,-40(s0)
ffffffe000205d30:	0007a783          	lw	a5,0(a5)
ffffffe000205d34:	fef42623          	sw	a5,-20(s0)
    return result;
ffffffe000205d38:	fec42783          	lw	a5,-20(s0)
}
ffffffe000205d3c:	00078513          	mv	a0,a5
ffffffe000205d40:	02813403          	ld	s0,40(sp)
ffffffe000205d44:	03010113          	addi	sp,sp,48
ffffffe000205d48:	00008067          	ret

ffffffe000205d4c <memory_barrier>:
static inline void memory_barrier() {
ffffffe000205d4c:	ff010113          	addi	sp,sp,-16
ffffffe000205d50:	00813423          	sd	s0,8(sp)
ffffffe000205d54:	01010413          	addi	s0,sp,16
    asm volatile ("fence rw, rw"); // Full memory fence for both read and write
ffffffe000205d58:	0330000f          	fence	rw,rw
}
ffffffe000205d5c:	00000013          	nop
ffffffe000205d60:	00813403          	ld	s0,8(sp)
ffffffe000205d64:	01010113          	addi	sp,sp,16
ffffffe000205d68:	00008067          	ret

ffffffe000205d6c <io_to_virt>:
static inline uint64_t io_to_virt(uint64_t pa) {
ffffffe000205d6c:	fe010113          	addi	sp,sp,-32
ffffffe000205d70:	00813c23          	sd	s0,24(sp)
ffffffe000205d74:	02010413          	addi	s0,sp,32
ffffffe000205d78:	fea43423          	sd	a0,-24(s0)
    return pa + IOMAP_OFFSET;
ffffffe000205d7c:	fe843703          	ld	a4,-24(s0)
ffffffe000205d80:	ff900793          	li	a5,-7
ffffffe000205d84:	02379793          	slli	a5,a5,0x23
ffffffe000205d88:	00f707b3          	add	a5,a4,a5
}
ffffffe000205d8c:	00078513          	mv	a0,a5
ffffffe000205d90:	01813403          	ld	s0,24(sp)
ffffffe000205d94:	02010113          	addi	sp,sp,32
ffffffe000205d98:	00008067          	ret

ffffffe000205d9c <virtio_blk_driver_init>:

volatile struct virtio_regs * virtio_blk_regs = NULL;
struct vring virtio_blk_ring;
uint64_t virtio_blk_capacity;

void virtio_blk_driver_init() {
ffffffe000205d9c:	ff010113          	addi	sp,sp,-16
ffffffe000205da0:	00113423          	sd	ra,8(sp)
ffffffe000205da4:	00813023          	sd	s0,0(sp)
ffffffe000205da8:	01010413          	addi	s0,sp,16
    virtio_blk_regs->Status = 0;
ffffffe000205dac:	00007797          	auipc	a5,0x7
ffffffe000205db0:	27c78793          	addi	a5,a5,636 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205db4:	0007b783          	ld	a5,0(a5)
ffffffe000205db8:	0607a823          	sw	zero,112(a5)
    virtio_blk_regs->Status |= DEVICE_ACKNOWLEDGE;
ffffffe000205dbc:	00007797          	auipc	a5,0x7
ffffffe000205dc0:	26c78793          	addi	a5,a5,620 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205dc4:	0007b783          	ld	a5,0(a5)
ffffffe000205dc8:	0707a783          	lw	a5,112(a5)
ffffffe000205dcc:	0007871b          	sext.w	a4,a5
ffffffe000205dd0:	00007797          	auipc	a5,0x7
ffffffe000205dd4:	25878793          	addi	a5,a5,600 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205dd8:	0007b783          	ld	a5,0(a5)
ffffffe000205ddc:	00176713          	ori	a4,a4,1
ffffffe000205de0:	0007071b          	sext.w	a4,a4
ffffffe000205de4:	06e7a823          	sw	a4,112(a5)
    virtio_blk_regs->Status |= DEVICE_DRIVER;
ffffffe000205de8:	00007797          	auipc	a5,0x7
ffffffe000205dec:	24078793          	addi	a5,a5,576 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205df0:	0007b783          	ld	a5,0(a5)
ffffffe000205df4:	0707a783          	lw	a5,112(a5)
ffffffe000205df8:	0007871b          	sext.w	a4,a5
ffffffe000205dfc:	00007797          	auipc	a5,0x7
ffffffe000205e00:	22c78793          	addi	a5,a5,556 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205e04:	0007b783          	ld	a5,0(a5)
ffffffe000205e08:	00276713          	ori	a4,a4,2
ffffffe000205e0c:	0007071b          	sext.w	a4,a4
ffffffe000205e10:	06e7a823          	sw	a4,112(a5)
    memory_barrier();
ffffffe000205e14:	f39ff0ef          	jal	ra,ffffffe000205d4c <memory_barrier>
}
ffffffe000205e18:	00000013          	nop
ffffffe000205e1c:	00813083          	ld	ra,8(sp)
ffffffe000205e20:	00013403          	ld	s0,0(sp)
ffffffe000205e24:	01010113          	addi	sp,sp,16
ffffffe000205e28:	00008067          	ret

ffffffe000205e2c <virtio_blk_feature_init>:

void virtio_blk_feature_init() {
ffffffe000205e2c:	ff010113          	addi	sp,sp,-16
ffffffe000205e30:	00113423          	sd	ra,8(sp)
ffffffe000205e34:	00813023          	sd	s0,0(sp)
ffffffe000205e38:	01010413          	addi	s0,sp,16
    virtio_blk_regs->DeviceFeaturesSel = 0;
ffffffe000205e3c:	00007797          	auipc	a5,0x7
ffffffe000205e40:	1ec78793          	addi	a5,a5,492 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205e44:	0007b783          	ld	a5,0(a5)
ffffffe000205e48:	0007aa23          	sw	zero,20(a5)
    virtio_blk_regs->DeviceFeaturesSel = 1;
ffffffe000205e4c:	00007797          	auipc	a5,0x7
ffffffe000205e50:	1dc78793          	addi	a5,a5,476 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205e54:	0007b783          	ld	a5,0(a5)
ffffffe000205e58:	00100713          	li	a4,1
ffffffe000205e5c:	00e7aa23          	sw	a4,20(a5)
    virtio_blk_regs->DriverFeaturesSel = 0;
ffffffe000205e60:	00007797          	auipc	a5,0x7
ffffffe000205e64:	1c878793          	addi	a5,a5,456 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205e68:	0007b783          	ld	a5,0(a5)
ffffffe000205e6c:	0207a223          	sw	zero,36(a5)
    virtio_blk_regs->DriverFeatures = 0x30000200;
ffffffe000205e70:	00007797          	auipc	a5,0x7
ffffffe000205e74:	1b878793          	addi	a5,a5,440 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205e78:	0007b783          	ld	a5,0(a5)
ffffffe000205e7c:	30000737          	lui	a4,0x30000
ffffffe000205e80:	20070713          	addi	a4,a4,512 # 30000200 <PHY_SIZE+0x28000200>
ffffffe000205e84:	02e7a023          	sw	a4,32(a5)
    virtio_blk_regs->DriverFeaturesSel = 1;
ffffffe000205e88:	00007797          	auipc	a5,0x7
ffffffe000205e8c:	1a078793          	addi	a5,a5,416 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205e90:	0007b783          	ld	a5,0(a5)
ffffffe000205e94:	00100713          	li	a4,1
ffffffe000205e98:	02e7a223          	sw	a4,36(a5)
    virtio_blk_regs->DriverFeatures = 0x0;
ffffffe000205e9c:	00007797          	auipc	a5,0x7
ffffffe000205ea0:	18c78793          	addi	a5,a5,396 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205ea4:	0007b783          	ld	a5,0(a5)
ffffffe000205ea8:	0207a023          	sw	zero,32(a5)
    virtio_blk_regs->Status |= DEVICE_FEATURES_OK;
ffffffe000205eac:	00007797          	auipc	a5,0x7
ffffffe000205eb0:	17c78793          	addi	a5,a5,380 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205eb4:	0007b783          	ld	a5,0(a5)
ffffffe000205eb8:	0707a783          	lw	a5,112(a5)
ffffffe000205ebc:	0007871b          	sext.w	a4,a5
ffffffe000205ec0:	00007797          	auipc	a5,0x7
ffffffe000205ec4:	16878793          	addi	a5,a5,360 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205ec8:	0007b783          	ld	a5,0(a5)
ffffffe000205ecc:	00876713          	ori	a4,a4,8
ffffffe000205ed0:	0007071b          	sext.w	a4,a4
ffffffe000205ed4:	06e7a823          	sw	a4,112(a5)
    memory_barrier();
ffffffe000205ed8:	e75ff0ef          	jal	ra,ffffffe000205d4c <memory_barrier>
}
ffffffe000205edc:	00000013          	nop
ffffffe000205ee0:	00813083          	ld	ra,8(sp)
ffffffe000205ee4:	00013403          	ld	s0,0(sp)
ffffffe000205ee8:	01010113          	addi	sp,sp,16
ffffffe000205eec:	00008067          	ret

ffffffe000205ef0 <virtio_blk_queue_init>:

void virtio_blk_queue_init() {
ffffffe000205ef0:	fc010113          	addi	sp,sp,-64
ffffffe000205ef4:	02113c23          	sd	ra,56(sp)
ffffffe000205ef8:	02813823          	sd	s0,48(sp)
ffffffe000205efc:	04010413          	addi	s0,sp,64
    virtio_blk_ring.num = VIRTIO_QUEUE_SIZE;
ffffffe000205f00:	0000b797          	auipc	a5,0xb
ffffffe000205f04:	95078793          	addi	a5,a5,-1712 # ffffffe000210850 <virtio_blk_ring>
ffffffe000205f08:	01000713          	li	a4,16
ffffffe000205f0c:	00e79023          	sh	a4,0(a5)
    
    uint64_t size_of_descs = VIRTIO_QUEUE_SIZE * sizeof(struct virtio_desc);
ffffffe000205f10:	10000793          	li	a5,256
ffffffe000205f14:	fef43023          	sd	a5,-32(s0)
    uint64_t size_of_avail = sizeof(struct virtio_avail);
ffffffe000205f18:	02600793          	li	a5,38
ffffffe000205f1c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t size_of_used = sizeof(struct virtio_used);
ffffffe000205f20:	08800793          	li	a5,136
ffffffe000205f24:	fcf43823          	sd	a5,-48(s0)

    uint64_t pages = alloc_pages(3);
ffffffe000205f28:	00300513          	li	a0,3
ffffffe000205f2c:	9ddfa0ef          	jal	ra,ffffffe000200908 <alloc_pages>
ffffffe000205f30:	00050793          	mv	a5,a0
ffffffe000205f34:	fcf43423          	sd	a5,-56(s0)
    virtio_blk_ring.desc = (struct virtio_desc*)(pages);
ffffffe000205f38:	fc843703          	ld	a4,-56(s0)
ffffffe000205f3c:	0000b797          	auipc	a5,0xb
ffffffe000205f40:	91478793          	addi	a5,a5,-1772 # ffffffe000210850 <virtio_blk_ring>
ffffffe000205f44:	00e7b423          	sd	a4,8(a5)
    virtio_blk_ring.avail = (struct virtio_avail*)(pages + PGSIZE);
ffffffe000205f48:	fc843703          	ld	a4,-56(s0)
ffffffe000205f4c:	000017b7          	lui	a5,0x1
ffffffe000205f50:	00f707b3          	add	a5,a4,a5
ffffffe000205f54:	00078713          	mv	a4,a5
ffffffe000205f58:	0000b797          	auipc	a5,0xb
ffffffe000205f5c:	8f878793          	addi	a5,a5,-1800 # ffffffe000210850 <virtio_blk_ring>
ffffffe000205f60:	00e7b823          	sd	a4,16(a5)
    virtio_blk_ring.used = (struct virtio_used*)(pages + 2*PGSIZE);
ffffffe000205f64:	fc843703          	ld	a4,-56(s0)
ffffffe000205f68:	000027b7          	lui	a5,0x2
ffffffe000205f6c:	00f707b3          	add	a5,a4,a5
ffffffe000205f70:	00078713          	mv	a4,a5
ffffffe000205f74:	0000b797          	auipc	a5,0xb
ffffffe000205f78:	8dc78793          	addi	a5,a5,-1828 # ffffffe000210850 <virtio_blk_ring>
ffffffe000205f7c:	00e7bc23          	sd	a4,24(a5)
    virtio_blk_ring.avail->flags = VIRTQ_AVAIL_F_NO_INTERRUPT;
ffffffe000205f80:	0000b797          	auipc	a5,0xb
ffffffe000205f84:	8d078793          	addi	a5,a5,-1840 # ffffffe000210850 <virtio_blk_ring>
ffffffe000205f88:	0107b783          	ld	a5,16(a5)
ffffffe000205f8c:	00100713          	li	a4,1
ffffffe000205f90:	00e79023          	sh	a4,0(a5)

    for (int i = 1; i < VIRTIO_QUEUE_SIZE; i++) {
ffffffe000205f94:	00100793          	li	a5,1
ffffffe000205f98:	fef42623          	sw	a5,-20(s0)
ffffffe000205f9c:	03c0006f          	j	ffffffe000205fd8 <virtio_blk_queue_init+0xe8>
        virtio_blk_ring.desc[i - 1].next = i;
ffffffe000205fa0:	0000b797          	auipc	a5,0xb
ffffffe000205fa4:	8b078793          	addi	a5,a5,-1872 # ffffffe000210850 <virtio_blk_ring>
ffffffe000205fa8:	0087b703          	ld	a4,8(a5)
ffffffe000205fac:	fec42783          	lw	a5,-20(s0)
ffffffe000205fb0:	00479793          	slli	a5,a5,0x4
ffffffe000205fb4:	ff078793          	addi	a5,a5,-16
ffffffe000205fb8:	00f707b3          	add	a5,a4,a5
ffffffe000205fbc:	fec42703          	lw	a4,-20(s0)
ffffffe000205fc0:	03071713          	slli	a4,a4,0x30
ffffffe000205fc4:	03075713          	srli	a4,a4,0x30
ffffffe000205fc8:	00e79723          	sh	a4,14(a5)
    for (int i = 1; i < VIRTIO_QUEUE_SIZE; i++) {
ffffffe000205fcc:	fec42783          	lw	a5,-20(s0)
ffffffe000205fd0:	0017879b          	addiw	a5,a5,1
ffffffe000205fd4:	fef42623          	sw	a5,-20(s0)
ffffffe000205fd8:	fec42783          	lw	a5,-20(s0)
ffffffe000205fdc:	0007871b          	sext.w	a4,a5
ffffffe000205fe0:	00f00793          	li	a5,15
ffffffe000205fe4:	fae7dee3          	bge	a5,a4,ffffffe000205fa0 <virtio_blk_queue_init+0xb0>
    }

    virtio_blk_regs->QueueSel = 0;
ffffffe000205fe8:	00007797          	auipc	a5,0x7
ffffffe000205fec:	04078793          	addi	a5,a5,64 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000205ff0:	0007b783          	ld	a5,0(a5)
ffffffe000205ff4:	0207a823          	sw	zero,48(a5)
    virtio_blk_regs->QueueNum = VIRTIO_QUEUE_SIZE;
ffffffe000205ff8:	00007797          	auipc	a5,0x7
ffffffe000205ffc:	03078793          	addi	a5,a5,48 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206000:	0007b783          	ld	a5,0(a5)
ffffffe000206004:	01000713          	li	a4,16
ffffffe000206008:	02e7ac23          	sw	a4,56(a5)
    virtio_blk_regs->QueueAvailLow = 0xffffffff & virt_to_phys((uint64_t)virtio_blk_ring.avail);
ffffffe00020600c:	0000b797          	auipc	a5,0xb
ffffffe000206010:	84478793          	addi	a5,a5,-1980 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206014:	0107b783          	ld	a5,16(a5)
ffffffe000206018:	0007869b          	sext.w	a3,a5
ffffffe00020601c:	00007797          	auipc	a5,0x7
ffffffe000206020:	00c78793          	addi	a5,a5,12 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206024:	0007b783          	ld	a5,0(a5)
ffffffe000206028:	80000737          	lui	a4,0x80000
ffffffe00020602c:	00e6873b          	addw	a4,a3,a4
ffffffe000206030:	0007071b          	sext.w	a4,a4
ffffffe000206034:	08e7a823          	sw	a4,144(a5)
    virtio_blk_regs->QueueAvailHigh = virt_to_phys((uint64_t)virtio_blk_ring.avail) >> 32;
ffffffe000206038:	0000b797          	auipc	a5,0xb
ffffffe00020603c:	81878793          	addi	a5,a5,-2024 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206040:	0107b783          	ld	a5,16(a5)
ffffffe000206044:	00078713          	mv	a4,a5
ffffffe000206048:	04100793          	li	a5,65
ffffffe00020604c:	01f79793          	slli	a5,a5,0x1f
ffffffe000206050:	00f707b3          	add	a5,a4,a5
ffffffe000206054:	0207d713          	srli	a4,a5,0x20
ffffffe000206058:	00007797          	auipc	a5,0x7
ffffffe00020605c:	fd078793          	addi	a5,a5,-48 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206060:	0007b783          	ld	a5,0(a5)
ffffffe000206064:	0007071b          	sext.w	a4,a4
ffffffe000206068:	08e7aa23          	sw	a4,148(a5)
    virtio_blk_regs->QueueDescLow = 0xffffffff & virt_to_phys((uint64_t)virtio_blk_ring.desc);
ffffffe00020606c:	0000a797          	auipc	a5,0xa
ffffffe000206070:	7e478793          	addi	a5,a5,2020 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206074:	0087b783          	ld	a5,8(a5)
ffffffe000206078:	0007869b          	sext.w	a3,a5
ffffffe00020607c:	00007797          	auipc	a5,0x7
ffffffe000206080:	fac78793          	addi	a5,a5,-84 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206084:	0007b783          	ld	a5,0(a5)
ffffffe000206088:	80000737          	lui	a4,0x80000
ffffffe00020608c:	00e6873b          	addw	a4,a3,a4
ffffffe000206090:	0007071b          	sext.w	a4,a4
ffffffe000206094:	08e7a023          	sw	a4,128(a5)
    virtio_blk_regs->QueueDescHigh = virt_to_phys((uint64_t)virtio_blk_ring.desc) >> 32;
ffffffe000206098:	0000a797          	auipc	a5,0xa
ffffffe00020609c:	7b878793          	addi	a5,a5,1976 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002060a0:	0087b783          	ld	a5,8(a5)
ffffffe0002060a4:	00078713          	mv	a4,a5
ffffffe0002060a8:	04100793          	li	a5,65
ffffffe0002060ac:	01f79793          	slli	a5,a5,0x1f
ffffffe0002060b0:	00f707b3          	add	a5,a4,a5
ffffffe0002060b4:	0207d713          	srli	a4,a5,0x20
ffffffe0002060b8:	00007797          	auipc	a5,0x7
ffffffe0002060bc:	f7078793          	addi	a5,a5,-144 # ffffffe00020d028 <virtio_blk_regs>
ffffffe0002060c0:	0007b783          	ld	a5,0(a5)
ffffffe0002060c4:	0007071b          	sext.w	a4,a4
ffffffe0002060c8:	08e7a223          	sw	a4,132(a5)
    virtio_blk_regs->QueueUsedLow = 0xffffffff & virt_to_phys((uint64_t)virtio_blk_ring.used);
ffffffe0002060cc:	0000a797          	auipc	a5,0xa
ffffffe0002060d0:	78478793          	addi	a5,a5,1924 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002060d4:	0187b783          	ld	a5,24(a5)
ffffffe0002060d8:	0007869b          	sext.w	a3,a5
ffffffe0002060dc:	00007797          	auipc	a5,0x7
ffffffe0002060e0:	f4c78793          	addi	a5,a5,-180 # ffffffe00020d028 <virtio_blk_regs>
ffffffe0002060e4:	0007b783          	ld	a5,0(a5)
ffffffe0002060e8:	80000737          	lui	a4,0x80000
ffffffe0002060ec:	00e6873b          	addw	a4,a3,a4
ffffffe0002060f0:	0007071b          	sext.w	a4,a4
ffffffe0002060f4:	0ae7a023          	sw	a4,160(a5)
    virtio_blk_regs->QueueUsedHigh = virt_to_phys((uint64_t)virtio_blk_ring.used) >> 32;
ffffffe0002060f8:	0000a797          	auipc	a5,0xa
ffffffe0002060fc:	75878793          	addi	a5,a5,1880 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206100:	0187b783          	ld	a5,24(a5)
ffffffe000206104:	00078713          	mv	a4,a5
ffffffe000206108:	04100793          	li	a5,65
ffffffe00020610c:	01f79793          	slli	a5,a5,0x1f
ffffffe000206110:	00f707b3          	add	a5,a4,a5
ffffffe000206114:	0207d713          	srli	a4,a5,0x20
ffffffe000206118:	00007797          	auipc	a5,0x7
ffffffe00020611c:	f1078793          	addi	a5,a5,-240 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206120:	0007b783          	ld	a5,0(a5)
ffffffe000206124:	0007071b          	sext.w	a4,a4
ffffffe000206128:	0ae7a223          	sw	a4,164(a5)
    memory_barrier();
ffffffe00020612c:	c21ff0ef          	jal	ra,ffffffe000205d4c <memory_barrier>

    virtio_blk_regs->QueueReady = 1;
ffffffe000206130:	00007797          	auipc	a5,0x7
ffffffe000206134:	ef878793          	addi	a5,a5,-264 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206138:	0007b783          	ld	a5,0(a5)
ffffffe00020613c:	00100713          	li	a4,1
ffffffe000206140:	04e7a223          	sw	a4,68(a5)
    memory_barrier();
ffffffe000206144:	c09ff0ef          	jal	ra,ffffffe000205d4c <memory_barrier>
}
ffffffe000206148:	00000013          	nop
ffffffe00020614c:	03813083          	ld	ra,56(sp)
ffffffe000206150:	03013403          	ld	s0,48(sp)
ffffffe000206154:	04010113          	addi	sp,sp,64
ffffffe000206158:	00008067          	ret

ffffffe00020615c <virtio_blk_config_init>:

void virtio_blk_config_init() {
ffffffe00020615c:	fe010113          	addi	sp,sp,-32
ffffffe000206160:	00813c23          	sd	s0,24(sp)
ffffffe000206164:	02010413          	addi	s0,sp,32
    volatile struct virtio_blk_config *config = (struct virtio_blk_config*)(&virtio_blk_regs->Config);
ffffffe000206168:	00007797          	auipc	a5,0x7
ffffffe00020616c:	ec078793          	addi	a5,a5,-320 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206170:	0007b783          	ld	a5,0(a5)
ffffffe000206174:	10078793          	addi	a5,a5,256
ffffffe000206178:	fef43423          	sd	a5,-24(s0)
    uint64_t capacity = ((uint64_t)config->capacity_hi << 32) | config->capacity_lo;
ffffffe00020617c:	fe843783          	ld	a5,-24(s0)
ffffffe000206180:	0047a783          	lw	a5,4(a5)
ffffffe000206184:	0007879b          	sext.w	a5,a5
ffffffe000206188:	02079793          	slli	a5,a5,0x20
ffffffe00020618c:	0207d793          	srli	a5,a5,0x20
ffffffe000206190:	02079713          	slli	a4,a5,0x20
ffffffe000206194:	fe843783          	ld	a5,-24(s0)
ffffffe000206198:	0007a783          	lw	a5,0(a5)
ffffffe00020619c:	0007879b          	sext.w	a5,a5
ffffffe0002061a0:	02079793          	slli	a5,a5,0x20
ffffffe0002061a4:	0207d793          	srli	a5,a5,0x20
ffffffe0002061a8:	00f767b3          	or	a5,a4,a5
ffffffe0002061ac:	fef43023          	sd	a5,-32(s0)
}
ffffffe0002061b0:	00000013          	nop
ffffffe0002061b4:	01813403          	ld	s0,24(sp)
ffffffe0002061b8:	02010113          	addi	sp,sp,32
ffffffe0002061bc:	00008067          	ret

ffffffe0002061c0 <virtio_blk_cmd>:

char virtio_blk_status;
struct virtio_blk_req virtio_blk_req;

void virtio_blk_cmd(uint32_t type, uint32_t sector, void* buf) {
ffffffe0002061c0:	fe010113          	addi	sp,sp,-32
ffffffe0002061c4:	00113c23          	sd	ra,24(sp)
ffffffe0002061c8:	00813823          	sd	s0,16(sp)
ffffffe0002061cc:	02010413          	addi	s0,sp,32
ffffffe0002061d0:	00050793          	mv	a5,a0
ffffffe0002061d4:	00058713          	mv	a4,a1
ffffffe0002061d8:	fec43023          	sd	a2,-32(s0)
ffffffe0002061dc:	fef42623          	sw	a5,-20(s0)
ffffffe0002061e0:	00070793          	mv	a5,a4
ffffffe0002061e4:	fef42423          	sw	a5,-24(s0)
	virtio_blk_req.type = type;
ffffffe0002061e8:	0000a797          	auipc	a5,0xa
ffffffe0002061ec:	68878793          	addi	a5,a5,1672 # ffffffe000210870 <virtio_blk_req>
ffffffe0002061f0:	fec42703          	lw	a4,-20(s0)
ffffffe0002061f4:	00e7a023          	sw	a4,0(a5)
    virtio_blk_req.sector = sector;
ffffffe0002061f8:	fe846703          	lwu	a4,-24(s0)
ffffffe0002061fc:	0000a797          	auipc	a5,0xa
ffffffe000206200:	67478793          	addi	a5,a5,1652 # ffffffe000210870 <virtio_blk_req>
ffffffe000206204:	00e7b423          	sd	a4,8(a5)

    virtio_blk_ring.desc[0].addr = virt_to_phys((uint64_t)&virtio_blk_req);
ffffffe000206208:	0000a697          	auipc	a3,0xa
ffffffe00020620c:	66868693          	addi	a3,a3,1640 # ffffffe000210870 <virtio_blk_req>
ffffffe000206210:	0000a797          	auipc	a5,0xa
ffffffe000206214:	64078793          	addi	a5,a5,1600 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206218:	0087b783          	ld	a5,8(a5)
ffffffe00020621c:	04100713          	li	a4,65
ffffffe000206220:	01f71713          	slli	a4,a4,0x1f
ffffffe000206224:	00e68733          	add	a4,a3,a4
ffffffe000206228:	00e7b023          	sd	a4,0(a5)
    virtio_blk_ring.desc[0].len = sizeof(struct virtio_blk_req);
ffffffe00020622c:	0000a797          	auipc	a5,0xa
ffffffe000206230:	62478793          	addi	a5,a5,1572 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206234:	0087b783          	ld	a5,8(a5)
ffffffe000206238:	01000713          	li	a4,16
ffffffe00020623c:	00e7a423          	sw	a4,8(a5)
    virtio_blk_ring.desc[0].flags = VIRTQ_DESC_F_NEXT;
ffffffe000206240:	0000a797          	auipc	a5,0xa
ffffffe000206244:	61078793          	addi	a5,a5,1552 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206248:	0087b783          	ld	a5,8(a5)
ffffffe00020624c:	00100713          	li	a4,1
ffffffe000206250:	00e79623          	sh	a4,12(a5)
    virtio_blk_ring.desc[0].next = 1;
ffffffe000206254:	0000a797          	auipc	a5,0xa
ffffffe000206258:	5fc78793          	addi	a5,a5,1532 # ffffffe000210850 <virtio_blk_ring>
ffffffe00020625c:	0087b783          	ld	a5,8(a5)
ffffffe000206260:	00100713          	li	a4,1
ffffffe000206264:	00e79723          	sh	a4,14(a5)

    virtio_blk_ring.desc[1].addr = virt_to_phys((uint64_t)buf);
ffffffe000206268:	fe043683          	ld	a3,-32(s0)
ffffffe00020626c:	0000a797          	auipc	a5,0xa
ffffffe000206270:	5e478793          	addi	a5,a5,1508 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206274:	0087b783          	ld	a5,8(a5)
ffffffe000206278:	01078793          	addi	a5,a5,16
ffffffe00020627c:	04100713          	li	a4,65
ffffffe000206280:	01f71713          	slli	a4,a4,0x1f
ffffffe000206284:	00e68733          	add	a4,a3,a4
ffffffe000206288:	00e7b023          	sd	a4,0(a5)
    virtio_blk_ring.desc[1].len = VIRTIO_BLK_SECTOR_SIZE;
ffffffe00020628c:	0000a797          	auipc	a5,0xa
ffffffe000206290:	5c478793          	addi	a5,a5,1476 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206294:	0087b783          	ld	a5,8(a5)
ffffffe000206298:	01078793          	addi	a5,a5,16
ffffffe00020629c:	20000713          	li	a4,512
ffffffe0002062a0:	00e7a423          	sw	a4,8(a5)
    if (type == VIRTIO_BLK_T_IN) {
ffffffe0002062a4:	fec42783          	lw	a5,-20(s0)
ffffffe0002062a8:	0007879b          	sext.w	a5,a5
ffffffe0002062ac:	02079063          	bnez	a5,ffffffe0002062cc <virtio_blk_cmd+0x10c>
        virtio_blk_ring.desc[1].flags = VIRTQ_DESC_F_WRITE | VIRTQ_DESC_F_NEXT; 
ffffffe0002062b0:	0000a797          	auipc	a5,0xa
ffffffe0002062b4:	5a078793          	addi	a5,a5,1440 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002062b8:	0087b783          	ld	a5,8(a5)
ffffffe0002062bc:	01078793          	addi	a5,a5,16
ffffffe0002062c0:	00300713          	li	a4,3
ffffffe0002062c4:	00e79623          	sh	a4,12(a5)
ffffffe0002062c8:	01c0006f          	j	ffffffe0002062e4 <virtio_blk_cmd+0x124>
    } else {
        virtio_blk_ring.desc[1].flags = VIRTQ_DESC_F_NEXT;
ffffffe0002062cc:	0000a797          	auipc	a5,0xa
ffffffe0002062d0:	58478793          	addi	a5,a5,1412 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002062d4:	0087b783          	ld	a5,8(a5)
ffffffe0002062d8:	01078793          	addi	a5,a5,16
ffffffe0002062dc:	00100713          	li	a4,1
ffffffe0002062e0:	00e79623          	sh	a4,12(a5)
    }
    virtio_blk_ring.desc[1].next = 2;
ffffffe0002062e4:	0000a797          	auipc	a5,0xa
ffffffe0002062e8:	56c78793          	addi	a5,a5,1388 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002062ec:	0087b783          	ld	a5,8(a5)
ffffffe0002062f0:	01078793          	addi	a5,a5,16
ffffffe0002062f4:	00200713          	li	a4,2
ffffffe0002062f8:	00e79723          	sh	a4,14(a5)

    virtio_blk_ring.desc[2].addr = virt_to_phys((uint64_t)&virtio_blk_status);
ffffffe0002062fc:	00007697          	auipc	a3,0x7
ffffffe000206300:	d3c68693          	addi	a3,a3,-708 # ffffffe00020d038 <virtio_blk_status>
ffffffe000206304:	0000a797          	auipc	a5,0xa
ffffffe000206308:	54c78793          	addi	a5,a5,1356 # ffffffe000210850 <virtio_blk_ring>
ffffffe00020630c:	0087b783          	ld	a5,8(a5)
ffffffe000206310:	02078793          	addi	a5,a5,32
ffffffe000206314:	04100713          	li	a4,65
ffffffe000206318:	01f71713          	slli	a4,a4,0x1f
ffffffe00020631c:	00e68733          	add	a4,a3,a4
ffffffe000206320:	00e7b023          	sd	a4,0(a5)
    virtio_blk_ring.desc[2].len = sizeof(virtio_blk_status);
ffffffe000206324:	0000a797          	auipc	a5,0xa
ffffffe000206328:	52c78793          	addi	a5,a5,1324 # ffffffe000210850 <virtio_blk_ring>
ffffffe00020632c:	0087b783          	ld	a5,8(a5)
ffffffe000206330:	02078793          	addi	a5,a5,32
ffffffe000206334:	00100713          	li	a4,1
ffffffe000206338:	00e7a423          	sw	a4,8(a5)
    virtio_blk_ring.desc[2].flags = VIRTQ_DESC_F_WRITE;
ffffffe00020633c:	0000a797          	auipc	a5,0xa
ffffffe000206340:	51478793          	addi	a5,a5,1300 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206344:	0087b783          	ld	a5,8(a5)
ffffffe000206348:	02078793          	addi	a5,a5,32
ffffffe00020634c:	00200713          	li	a4,2
ffffffe000206350:	00e79623          	sh	a4,12(a5)

    virtio_blk_regs->Status |= DEVICE_DRIVER_OK;
ffffffe000206354:	00007797          	auipc	a5,0x7
ffffffe000206358:	cd478793          	addi	a5,a5,-812 # ffffffe00020d028 <virtio_blk_regs>
ffffffe00020635c:	0007b783          	ld	a5,0(a5)
ffffffe000206360:	0707a783          	lw	a5,112(a5)
ffffffe000206364:	0007871b          	sext.w	a4,a5
ffffffe000206368:	00007797          	auipc	a5,0x7
ffffffe00020636c:	cc078793          	addi	a5,a5,-832 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206370:	0007b783          	ld	a5,0(a5)
ffffffe000206374:	00476713          	ori	a4,a4,4
ffffffe000206378:	0007071b          	sext.w	a4,a4
ffffffe00020637c:	06e7a823          	sw	a4,112(a5)

    virtio_blk_ring.avail->ring[(virtio_blk_ring.avail->idx + 1) % VIRTIO_QUEUE_SIZE] = 0;
ffffffe000206380:	0000a797          	auipc	a5,0xa
ffffffe000206384:	4d078793          	addi	a5,a5,1232 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206388:	0107b683          	ld	a3,16(a5)
ffffffe00020638c:	0000a797          	auipc	a5,0xa
ffffffe000206390:	4c478793          	addi	a5,a5,1220 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206394:	0107b783          	ld	a5,16(a5)
ffffffe000206398:	0027d783          	lhu	a5,2(a5)
ffffffe00020639c:	0007879b          	sext.w	a5,a5
ffffffe0002063a0:	0017879b          	addiw	a5,a5,1
ffffffe0002063a4:	0007879b          	sext.w	a5,a5
ffffffe0002063a8:	00078713          	mv	a4,a5
ffffffe0002063ac:	41f7579b          	sraiw	a5,a4,0x1f
ffffffe0002063b0:	01c7d79b          	srliw	a5,a5,0x1c
ffffffe0002063b4:	00f7073b          	addw	a4,a4,a5
ffffffe0002063b8:	00f77713          	andi	a4,a4,15
ffffffe0002063bc:	40f707bb          	subw	a5,a4,a5
ffffffe0002063c0:	0007879b          	sext.w	a5,a5
ffffffe0002063c4:	00179793          	slli	a5,a5,0x1
ffffffe0002063c8:	00f687b3          	add	a5,a3,a5
ffffffe0002063cc:	00079223          	sh	zero,4(a5)
    virtio_blk_ring.avail->idx += 1;
ffffffe0002063d0:	0000a797          	auipc	a5,0xa
ffffffe0002063d4:	48078793          	addi	a5,a5,1152 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002063d8:	0107b783          	ld	a5,16(a5)
ffffffe0002063dc:	0027d703          	lhu	a4,2(a5)
ffffffe0002063e0:	0000a797          	auipc	a5,0xa
ffffffe0002063e4:	47078793          	addi	a5,a5,1136 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002063e8:	0107b783          	ld	a5,16(a5)
ffffffe0002063ec:	0017071b          	addiw	a4,a4,1 # ffffffff80000001 <VM_END+0x80000001>
ffffffe0002063f0:	03071713          	slli	a4,a4,0x30
ffffffe0002063f4:	03075713          	srli	a4,a4,0x30
ffffffe0002063f8:	00e79123          	sh	a4,2(a5)

    virtio_blk_regs->QueueNotify = 0;
ffffffe0002063fc:	00007797          	auipc	a5,0x7
ffffffe000206400:	c2c78793          	addi	a5,a5,-980 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206404:	0007b783          	ld	a5,0(a5)
ffffffe000206408:	0407a823          	sw	zero,80(a5)
    memory_barrier();
ffffffe00020640c:	941ff0ef          	jal	ra,ffffffe000205d4c <memory_barrier>
}
ffffffe000206410:	00000013          	nop
ffffffe000206414:	01813083          	ld	ra,24(sp)
ffffffe000206418:	01013403          	ld	s0,16(sp)
ffffffe00020641c:	02010113          	addi	sp,sp,32
ffffffe000206420:	00008067          	ret

ffffffe000206424 <virtio_blk_read_sector>:

void virtio_blk_read_sector(uint64_t sector, void *buf) {
ffffffe000206424:	fd010113          	addi	sp,sp,-48
ffffffe000206428:	02113423          	sd	ra,40(sp)
ffffffe00020642c:	02813023          	sd	s0,32(sp)
ffffffe000206430:	03010413          	addi	s0,sp,48
ffffffe000206434:	fca43c23          	sd	a0,-40(s0)
ffffffe000206438:	fcb43823          	sd	a1,-48(s0)
    uint64_t original_idx = virtio_blk_ring.used->idx;
ffffffe00020643c:	0000a797          	auipc	a5,0xa
ffffffe000206440:	41478793          	addi	a5,a5,1044 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206444:	0187b783          	ld	a5,24(a5)
ffffffe000206448:	0027d783          	lhu	a5,2(a5)
ffffffe00020644c:	fef43423          	sd	a5,-24(s0)
    virtio_blk_cmd(VIRTIO_BLK_T_IN, sector, buf);
ffffffe000206450:	fd843783          	ld	a5,-40(s0)
ffffffe000206454:	0007879b          	sext.w	a5,a5
ffffffe000206458:	fd043603          	ld	a2,-48(s0)
ffffffe00020645c:	00078593          	mv	a1,a5
ffffffe000206460:	00000513          	li	a0,0
ffffffe000206464:	d5dff0ef          	jal	ra,ffffffe0002061c0 <virtio_blk_cmd>
    while (1) {
        if (virtio_blk_ring.used->idx != original_idx) {
ffffffe000206468:	0000a797          	auipc	a5,0xa
ffffffe00020646c:	3e878793          	addi	a5,a5,1000 # ffffffe000210850 <virtio_blk_ring>
ffffffe000206470:	0187b783          	ld	a5,24(a5)
ffffffe000206474:	0027d783          	lhu	a5,2(a5)
ffffffe000206478:	00078713          	mv	a4,a5
ffffffe00020647c:	fe843783          	ld	a5,-24(s0)
ffffffe000206480:	00e79463          	bne	a5,a4,ffffffe000206488 <virtio_blk_read_sector+0x64>
ffffffe000206484:	fe5ff06f          	j	ffffffe000206468 <virtio_blk_read_sector+0x44>
            break;
ffffffe000206488:	00000013          	nop
        }
    }
}
ffffffe00020648c:	00000013          	nop
ffffffe000206490:	02813083          	ld	ra,40(sp)
ffffffe000206494:	02013403          	ld	s0,32(sp)
ffffffe000206498:	03010113          	addi	sp,sp,48
ffffffe00020649c:	00008067          	ret

ffffffe0002064a0 <virtio_blk_write_sector>:

void virtio_blk_write_sector(uint64_t sector, const void *buf) {
ffffffe0002064a0:	fd010113          	addi	sp,sp,-48
ffffffe0002064a4:	02113423          	sd	ra,40(sp)
ffffffe0002064a8:	02813023          	sd	s0,32(sp)
ffffffe0002064ac:	03010413          	addi	s0,sp,48
ffffffe0002064b0:	fca43c23          	sd	a0,-40(s0)
ffffffe0002064b4:	fcb43823          	sd	a1,-48(s0)
    uint64_t original_idx = virtio_blk_ring.used->idx;
ffffffe0002064b8:	0000a797          	auipc	a5,0xa
ffffffe0002064bc:	39878793          	addi	a5,a5,920 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002064c0:	0187b783          	ld	a5,24(a5)
ffffffe0002064c4:	0027d783          	lhu	a5,2(a5)
ffffffe0002064c8:	fef43423          	sd	a5,-24(s0)
    virtio_blk_cmd(VIRTIO_BLK_T_OUT, sector, (void*)buf);
ffffffe0002064cc:	fd843783          	ld	a5,-40(s0)
ffffffe0002064d0:	0007879b          	sext.w	a5,a5
ffffffe0002064d4:	fd043603          	ld	a2,-48(s0)
ffffffe0002064d8:	00078593          	mv	a1,a5
ffffffe0002064dc:	00100513          	li	a0,1
ffffffe0002064e0:	ce1ff0ef          	jal	ra,ffffffe0002061c0 <virtio_blk_cmd>
    while (1) {
        if (virtio_blk_ring.used->idx != original_idx) {
ffffffe0002064e4:	0000a797          	auipc	a5,0xa
ffffffe0002064e8:	36c78793          	addi	a5,a5,876 # ffffffe000210850 <virtio_blk_ring>
ffffffe0002064ec:	0187b783          	ld	a5,24(a5)
ffffffe0002064f0:	0027d783          	lhu	a5,2(a5)
ffffffe0002064f4:	00078713          	mv	a4,a5
ffffffe0002064f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002064fc:	00e79463          	bne	a5,a4,ffffffe000206504 <virtio_blk_write_sector+0x64>
ffffffe000206500:	fe5ff06f          	j	ffffffe0002064e4 <virtio_blk_write_sector+0x44>
            break;
ffffffe000206504:	00000013          	nop
        }
    }
}
ffffffe000206508:	00000013          	nop
ffffffe00020650c:	02813083          	ld	ra,40(sp)
ffffffe000206510:	02013403          	ld	s0,32(sp)
ffffffe000206514:	03010113          	addi	sp,sp,48
ffffffe000206518:	00008067          	ret

ffffffe00020651c <virtio_blk_init>:

void virtio_blk_init() {
ffffffe00020651c:	de010113          	addi	sp,sp,-544
ffffffe000206520:	20113c23          	sd	ra,536(sp)
ffffffe000206524:	20813823          	sd	s0,528(sp)
ffffffe000206528:	22010413          	addi	s0,sp,544
    // First, tell the device that the driver is ok
    virtio_blk_driver_init();
ffffffe00020652c:	871ff0ef          	jal	ra,ffffffe000205d9c <virtio_blk_driver_init>
    // Second, initialize the features
    virtio_blk_feature_init();
ffffffe000206530:	8fdff0ef          	jal	ra,ffffffe000205e2c <virtio_blk_feature_init>
    // Then, initialize the configs
    virtio_blk_config_init();
ffffffe000206534:	c29ff0ef          	jal	ra,ffffffe00020615c <virtio_blk_config_init>
    // Now, start initialize the vring
    virtio_blk_queue_init();
ffffffe000206538:	9b9ff0ef          	jal	ra,ffffffe000205ef0 <virtio_blk_queue_init>

    char buf[VIRTIO_BLK_SECTOR_SIZE];

    virtio_blk_read_sector(0, buf);
ffffffe00020653c:	df040793          	addi	a5,s0,-528
ffffffe000206540:	00078593          	mv	a1,a5
ffffffe000206544:	00000513          	li	a0,0
ffffffe000206548:	eddff0ef          	jal	ra,ffffffe000206424 <virtio_blk_read_sector>

    // test if the disk is added properly
    char boot_signature[2];
    boot_signature[0] = buf[510];
ffffffe00020654c:	fee44783          	lbu	a5,-18(s0)
ffffffe000206550:	def40423          	sb	a5,-536(s0)
    boot_signature[1] = buf[511];
ffffffe000206554:	fef44783          	lbu	a5,-17(s0)
ffffffe000206558:	def404a3          	sb	a5,-535(s0)

    if (boot_signature[0] != 0x55 || boot_signature[1] != 0xaa) {
ffffffe00020655c:	de844783          	lbu	a5,-536(s0)
ffffffe000206560:	00078713          	mv	a4,a5
ffffffe000206564:	05500793          	li	a5,85
ffffffe000206568:	00f71a63          	bne	a4,a5,ffffffe00020657c <virtio_blk_init+0x60>
ffffffe00020656c:	de944783          	lbu	a5,-535(s0)
ffffffe000206570:	00078713          	mv	a4,a5
ffffffe000206574:	0aa00793          	li	a5,170
ffffffe000206578:	02f70463          	beq	a4,a5,ffffffe0002065a0 <virtio_blk_init+0x84>
        Err("[S] mbr boot signature not found!");
ffffffe00020657c:	00002697          	auipc	a3,0x2
ffffffe000206580:	83c68693          	addi	a3,a3,-1988 # ffffffe000207db8 <__func__.0>
ffffffe000206584:	08a00613          	li	a2,138
ffffffe000206588:	00001597          	auipc	a1,0x1
ffffffe00020658c:	7c058593          	addi	a1,a1,1984 # ffffffe000207d48 <__func__.0+0x48>
ffffffe000206590:	00001517          	auipc	a0,0x1
ffffffe000206594:	7c850513          	addi	a0,a0,1992 # ffffffe000207d58 <__func__.0+0x58>
ffffffe000206598:	dd9fd0ef          	jal	ra,ffffffe000204370 <printk>
ffffffe00020659c:	0000006f          	j	ffffffe00020659c <virtio_blk_init+0x80>
    }

    printk("...virtio_blk_init done!\n");
ffffffe0002065a0:	00001517          	auipc	a0,0x1
ffffffe0002065a4:	7f850513          	addi	a0,a0,2040 # ffffffe000207d98 <__func__.0+0x98>
ffffffe0002065a8:	dc9fd0ef          	jal	ra,ffffffe000204370 <printk>
}
ffffffe0002065ac:	00000013          	nop
ffffffe0002065b0:	21813083          	ld	ra,536(sp)
ffffffe0002065b4:	21013403          	ld	s0,528(sp)
ffffffe0002065b8:	22010113          	addi	sp,sp,544
ffffffe0002065bc:	00008067          	ret

ffffffe0002065c0 <virtio_dev_test>:

int virtio_dev_test(uint64_t virtio_addr) {
ffffffe0002065c0:	fd010113          	addi	sp,sp,-48
ffffffe0002065c4:	02113423          	sd	ra,40(sp)
ffffffe0002065c8:	02813023          	sd	s0,32(sp)
ffffffe0002065cc:	03010413          	addi	s0,sp,48
ffffffe0002065d0:	fca43c23          	sd	a0,-40(s0)
    void *virtio_space = (char*)(virtio_addr);
ffffffe0002065d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002065d8:	fef43423          	sd	a5,-24(s0)

    struct virtio_regs *virtio_header = virtio_space;
ffffffe0002065dc:	fe843783          	ld	a5,-24(s0)
ffffffe0002065e0:	fef43023          	sd	a5,-32(s0)
    if (in32(&virtio_header->DeviceID) == ID_VIRTIO_BLK) {
ffffffe0002065e4:	fe043783          	ld	a5,-32(s0)
ffffffe0002065e8:	00878793          	addi	a5,a5,8
ffffffe0002065ec:	00078513          	mv	a0,a5
ffffffe0002065f0:	f2cff0ef          	jal	ra,ffffffe000205d1c <in32>
ffffffe0002065f4:	00050793          	mv	a5,a0
ffffffe0002065f8:	0007879b          	sext.w	a5,a5
ffffffe0002065fc:	00078713          	mv	a4,a5
ffffffe000206600:	00200793          	li	a5,2
ffffffe000206604:	00f71a63          	bne	a4,a5,ffffffe000206618 <virtio_dev_test+0x58>
        virtio_blk_regs = virtio_space;
ffffffe000206608:	00007797          	auipc	a5,0x7
ffffffe00020660c:	a2078793          	addi	a5,a5,-1504 # ffffffe00020d028 <virtio_blk_regs>
ffffffe000206610:	fe843703          	ld	a4,-24(s0)
ffffffe000206614:	00e7b023          	sd	a4,0(a5)
    }

    return 0;
ffffffe000206618:	00000793          	li	a5,0
}
ffffffe00020661c:	00078513          	mv	a0,a5
ffffffe000206620:	02813083          	ld	ra,40(sp)
ffffffe000206624:	02013403          	ld	s0,32(sp)
ffffffe000206628:	03010113          	addi	sp,sp,48
ffffffe00020662c:	00008067          	ret

ffffffe000206630 <virtio_dev_init>:

void virtio_dev_init() {
ffffffe000206630:	fe010113          	addi	sp,sp,-32
ffffffe000206634:	00113c23          	sd	ra,24(sp)
ffffffe000206638:	00813823          	sd	s0,16(sp)
ffffffe00020663c:	02010413          	addi	s0,sp,32
    for (int i = 0; i < VIRTIO_COUNT; i++) {
ffffffe000206640:	fe042623          	sw	zero,-20(s0)
ffffffe000206644:	0480006f          	j	ffffffe00020668c <virtio_dev_init+0x5c>
        uint64_t addr = VIRTIO_START + i * VIRTIO_SIZE;
ffffffe000206648:	fec42783          	lw	a5,-20(s0)
ffffffe00020664c:	00078713          	mv	a4,a5
ffffffe000206650:	000107b7          	lui	a5,0x10
ffffffe000206654:	0017879b          	addiw	a5,a5,1 # 10001 <PGSIZE+0xf001>
ffffffe000206658:	00f707bb          	addw	a5,a4,a5
ffffffe00020665c:	0007879b          	sext.w	a5,a5
ffffffe000206660:	00c7979b          	slliw	a5,a5,0xc
ffffffe000206664:	0007879b          	sext.w	a5,a5
ffffffe000206668:	fef43023          	sd	a5,-32(s0)
        virtio_dev_test(io_to_virt(addr));
ffffffe00020666c:	fe043503          	ld	a0,-32(s0)
ffffffe000206670:	efcff0ef          	jal	ra,ffffffe000205d6c <io_to_virt>
ffffffe000206674:	00050793          	mv	a5,a0
ffffffe000206678:	00078513          	mv	a0,a5
ffffffe00020667c:	f45ff0ef          	jal	ra,ffffffe0002065c0 <virtio_dev_test>
    for (int i = 0; i < VIRTIO_COUNT; i++) {
ffffffe000206680:	fec42783          	lw	a5,-20(s0)
ffffffe000206684:	0017879b          	addiw	a5,a5,1
ffffffe000206688:	fef42623          	sw	a5,-20(s0)
ffffffe00020668c:	fec42783          	lw	a5,-20(s0)
ffffffe000206690:	0007871b          	sext.w	a4,a5
ffffffe000206694:	00700793          	li	a5,7
ffffffe000206698:	fae7d8e3          	bge	a5,a4,ffffffe000206648 <virtio_dev_init+0x18>
    }

    if (virtio_blk_regs) {
ffffffe00020669c:	00007797          	auipc	a5,0x7
ffffffe0002066a0:	98c78793          	addi	a5,a5,-1652 # ffffffe00020d028 <virtio_blk_regs>
ffffffe0002066a4:	0007b783          	ld	a5,0(a5)
ffffffe0002066a8:	00078463          	beqz	a5,ffffffe0002066b0 <virtio_dev_init+0x80>
        virtio_blk_init();
ffffffe0002066ac:	e71ff0ef          	jal	ra,ffffffe00020651c <virtio_blk_init>
    }
ffffffe0002066b0:	00000013          	nop
ffffffe0002066b4:	01813083          	ld	ra,24(sp)
ffffffe0002066b8:	01013403          	ld	s0,16(sp)
ffffffe0002066bc:	02010113          	addi	sp,sp,32
ffffffe0002066c0:	00008067          	ret
