
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern vm_init
    .section .text.init
    .globl _start
_start:
    #implement
    la sp, boot_stack_top # initialize stack
ffffffe000200000:	00006117          	auipc	sp,0x6
ffffffe000200004:	00010113          	mv	sp,sp

    call setup_vm
ffffffe000200008:	5ad000ef          	jal	ra,ffffffe000200db4 <setup_vm>
    call relocate
ffffffe00020000c:	04c000ef          	jal	ra,ffffffe000200058 <relocate>
    call mm_init
ffffffe000200010:	420000ef          	jal	ra,ffffffe000200430 <mm_init>
    call setup_vm_final
ffffffe000200014:	769000ef          	jal	ra,ffffffe000200f7c <setup_vm_final>
    call task_init
ffffffe000200018:	45c000ef          	jal	ra,ffffffe000200474 <task_init>

    la t0, _traps # load traps
ffffffe00020001c:	00000297          	auipc	t0,0x0
ffffffe000200020:	07c28293          	addi	t0,t0,124 # ffffffe000200098 <_traps>
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

    li t0, (1 << 1)
ffffffe00020004c:	00200293          	li	t0,2
    csrs sstatus, t0 # enable global interrupt
ffffffe000200050:	1002a073          	csrs	sstatus,t0

    call start_kernel # jump to start_kernel
ffffffe000200054:	34c010ef          	jal	ra,ffffffe0002013a0 <start_kernel>

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
ffffffe000200074:	00007297          	auipc	t0,0x7
ffffffe000200078:	f8c28293          	addi	t0,t0,-116 # ffffffe000207000 <early_pgtbl>
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

    # flush icache (included)
    # fence.i

    ret
ffffffe000200094:	00008067          	ret

ffffffe000200098 <_traps>:
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap

    addi sp, sp, -33*8
ffffffe000200098:	ef810113          	addi	sp,sp,-264 # ffffffe000205ef8 <_sbss+0xef8>
    sd ra, 0*8(sp)
ffffffe00020009c:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
ffffffe0002000a0:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
ffffffe0002000a4:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
ffffffe0002000a8:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
ffffffe0002000ac:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
ffffffe0002000b0:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
ffffffe0002000b4:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
ffffffe0002000b8:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
ffffffe0002000bc:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
ffffffe0002000c0:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
ffffffe0002000c4:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
ffffffe0002000c8:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
ffffffe0002000cc:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
ffffffe0002000d0:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
ffffffe0002000d4:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
ffffffe0002000d8:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
ffffffe0002000dc:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
ffffffe0002000e0:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
ffffffe0002000e4:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
ffffffe0002000e8:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
ffffffe0002000ec:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
ffffffe0002000f0:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
ffffffe0002000f4:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
ffffffe0002000f8:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
ffffffe0002000fc:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
ffffffe000200100:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
ffffffe000200104:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
ffffffe000200108:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
ffffffe00020010c:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
ffffffe000200110:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
ffffffe000200114:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
ffffffe000200118:	0e513823          	sd	t0,240(sp)
    sd sp, 31*8(sp)
ffffffe00020011c:	0e213c23          	sd	sp,248(sp)

    csrr a0, scause
ffffffe000200120:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe000200124:	141025f3          	csrr	a1,sepc
    call trap_handler
ffffffe000200128:	409000ef          	jal	ra,ffffffe000200d30 <trap_handler>

    ld sp, 31*8(sp)
ffffffe00020012c:	0f813103          	ld	sp,248(sp)
    ld t0, 30*8(sp)
ffffffe000200130:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
ffffffe000200134:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
ffffffe000200138:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
ffffffe00020013c:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
ffffffe000200140:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
ffffffe000200144:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
ffffffe000200148:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
ffffffe00020014c:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
ffffffe000200150:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
ffffffe000200154:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
ffffffe000200158:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
ffffffe00020015c:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
ffffffe000200160:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
ffffffe000200164:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
ffffffe000200168:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
ffffffe00020016c:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
ffffffe000200170:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
ffffffe000200174:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
ffffffe000200178:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
ffffffe00020017c:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
ffffffe000200180:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
ffffffe000200184:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
ffffffe000200188:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
ffffffe00020018c:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
ffffffe000200190:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
ffffffe000200194:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
ffffffe000200198:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
ffffffe00020019c:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
ffffffe0002001a0:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
ffffffe0002001a4:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
ffffffe0002001a8:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
ffffffe0002001ac:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
ffffffe0002001b0:	10810113          	addi	sp,sp,264
    sret
ffffffe0002001b4:	10200073          	sret

ffffffe0002001b8 <__dummy>:

    .globl __dummy
__dummy:
    la t0, dummy
ffffffe0002001b8:	00000297          	auipc	t0,0x0
ffffffe0002001bc:	7ac28293          	addi	t0,t0,1964 # ffffffe000200964 <dummy>
    csrw sepc, t0
ffffffe0002001c0:	14129073          	csrw	sepc,t0
    sret
ffffffe0002001c4:	10200073          	sret

ffffffe0002001c8 <__switch_to>:

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
ffffffe0002001c8:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
ffffffe0002001cc:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
ffffffe0002001d0:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
ffffffe0002001d4:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
ffffffe0002001d8:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
ffffffe0002001dc:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
ffffffe0002001e0:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
ffffffe0002001e4:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
ffffffe0002001e8:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
ffffffe0002001ec:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
ffffffe0002001f0:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
ffffffe0002001f4:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
ffffffe0002001f8:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
ffffffe0002001fc:	07b53423          	sd	s11,104(a0)
    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
ffffffe000200200:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
ffffffe000200204:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
ffffffe000200208:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
ffffffe00020020c:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
ffffffe000200210:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
ffffffe000200214:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
ffffffe000200218:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
ffffffe00020021c:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
ffffffe000200220:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
ffffffe000200224:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
ffffffe000200228:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
ffffffe00020022c:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
ffffffe000200230:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
ffffffe000200234:	0685bd83          	ld	s11,104(a1)
ffffffe000200238:	00008067          	ret

ffffffe00020023c <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 30000000;

uint64_t get_cycles() {
ffffffe00020023c:	fe010113          	addi	sp,sp,-32
ffffffe000200240:	00813c23          	sd	s0,24(sp)
ffffffe000200244:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe000200248:	c01027f3          	rdtime	a5
ffffffe00020024c:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe000200250:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200254:	00078513          	mv	a0,a5
ffffffe000200258:	01813403          	ld	s0,24(sp)
ffffffe00020025c:	02010113          	addi	sp,sp,32
ffffffe000200260:	00008067          	ret

ffffffe000200264 <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
ffffffe000200264:	fe010113          	addi	sp,sp,-32
ffffffe000200268:	00813c23          	sd	s0,24(sp)
ffffffe00020026c:	02010413          	addi	s0,sp,32
ffffffe000200270:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
ffffffe000200274:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
ffffffe000200278:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
ffffffe00020027c:	00000073          	ecall
}
ffffffe000200280:	00000013          	nop
ffffffe000200284:	01813403          	ld	s0,24(sp)
ffffffe000200288:	02010113          	addi	sp,sp,32
ffffffe00020028c:	00008067          	ret

ffffffe000200290 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe000200290:	fe010113          	addi	sp,sp,-32
ffffffe000200294:	00113c23          	sd	ra,24(sp)
ffffffe000200298:	00813823          	sd	s0,16(sp)
ffffffe00020029c:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe0002002a0:	f9dff0ef          	jal	ra,ffffffe00020023c <get_cycles>
ffffffe0002002a4:	00050713          	mv	a4,a0
ffffffe0002002a8:	00004797          	auipc	a5,0x4
ffffffe0002002ac:	d5878793          	addi	a5,a5,-680 # ffffffe000204000 <TIMECLOCK>
ffffffe0002002b0:	0007b783          	ld	a5,0(a5)
ffffffe0002002b4:	00f707b3          	add	a5,a4,a5
ffffffe0002002b8:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe0002002bc:	fe843503          	ld	a0,-24(s0)
ffffffe0002002c0:	fa5ff0ef          	jal	ra,ffffffe000200264 <sbi_set_timer>
ffffffe0002002c4:	00000013          	nop
ffffffe0002002c8:	01813083          	ld	ra,24(sp)
ffffffe0002002cc:	01013403          	ld	s0,16(sp)
ffffffe0002002d0:	02010113          	addi	sp,sp,32
ffffffe0002002d4:	00008067          	ret

ffffffe0002002d8 <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
ffffffe0002002d8:	fe010113          	addi	sp,sp,-32
ffffffe0002002dc:	00113c23          	sd	ra,24(sp)
ffffffe0002002e0:	00813823          	sd	s0,16(sp)
ffffffe0002002e4:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
ffffffe0002002e8:	00006797          	auipc	a5,0x6
ffffffe0002002ec:	d1878793          	addi	a5,a5,-744 # ffffffe000206000 <kmem>
ffffffe0002002f0:	0007b783          	ld	a5,0(a5)
ffffffe0002002f4:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
ffffffe0002002f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002002fc:	0007b703          	ld	a4,0(a5)
ffffffe000200300:	00006797          	auipc	a5,0x6
ffffffe000200304:	d0078793          	addi	a5,a5,-768 # ffffffe000206000 <kmem>
ffffffe000200308:	00e7b023          	sd	a4,0(a5)
    memset((void *)r, 0x0, PGSIZE);
ffffffe00020030c:	00001637          	lui	a2,0x1
ffffffe000200310:	00000593          	li	a1,0
ffffffe000200314:	fe843503          	ld	a0,-24(s0)
ffffffe000200318:	354020ef          	jal	ra,ffffffe00020266c <memset>
    return (void *)r;
ffffffe00020031c:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200320:	00078513          	mv	a0,a5
ffffffe000200324:	01813083          	ld	ra,24(sp)
ffffffe000200328:	01013403          	ld	s0,16(sp)
ffffffe00020032c:	02010113          	addi	sp,sp,32
ffffffe000200330:	00008067          	ret

ffffffe000200334 <kfree>:

void kfree(void *addr) {
ffffffe000200334:	fd010113          	addi	sp,sp,-48
ffffffe000200338:	02113423          	sd	ra,40(sp)
ffffffe00020033c:	02813023          	sd	s0,32(sp)
ffffffe000200340:	03010413          	addi	s0,sp,48
ffffffe000200344:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
ffffffe000200348:	fd843783          	ld	a5,-40(s0)
ffffffe00020034c:	00078693          	mv	a3,a5
ffffffe000200350:	fd840793          	addi	a5,s0,-40
ffffffe000200354:	fffff737          	lui	a4,0xfffff
ffffffe000200358:	00e6f733          	and	a4,a3,a4
ffffffe00020035c:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
ffffffe000200360:	fd843783          	ld	a5,-40(s0)
ffffffe000200364:	00001637          	lui	a2,0x1
ffffffe000200368:	00000593          	li	a1,0
ffffffe00020036c:	00078513          	mv	a0,a5
ffffffe000200370:	2fc020ef          	jal	ra,ffffffe00020266c <memset>

    r = (struct run *)addr;
ffffffe000200374:	fd843783          	ld	a5,-40(s0)
ffffffe000200378:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
ffffffe00020037c:	00006797          	auipc	a5,0x6
ffffffe000200380:	c8478793          	addi	a5,a5,-892 # ffffffe000206000 <kmem>
ffffffe000200384:	0007b703          	ld	a4,0(a5)
ffffffe000200388:	fe843783          	ld	a5,-24(s0)
ffffffe00020038c:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
ffffffe000200390:	00006797          	auipc	a5,0x6
ffffffe000200394:	c7078793          	addi	a5,a5,-912 # ffffffe000206000 <kmem>
ffffffe000200398:	fe843703          	ld	a4,-24(s0)
ffffffe00020039c:	00e7b023          	sd	a4,0(a5)

    return;
ffffffe0002003a0:	00000013          	nop
}
ffffffe0002003a4:	02813083          	ld	ra,40(sp)
ffffffe0002003a8:	02013403          	ld	s0,32(sp)
ffffffe0002003ac:	03010113          	addi	sp,sp,48
ffffffe0002003b0:	00008067          	ret

ffffffe0002003b4 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe0002003b4:	fd010113          	addi	sp,sp,-48
ffffffe0002003b8:	02113423          	sd	ra,40(sp)
ffffffe0002003bc:	02813023          	sd	s0,32(sp)
ffffffe0002003c0:	03010413          	addi	s0,sp,48
ffffffe0002003c4:	fca43c23          	sd	a0,-40(s0)
ffffffe0002003c8:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe0002003cc:	fd843703          	ld	a4,-40(s0)
ffffffe0002003d0:	000017b7          	lui	a5,0x1
ffffffe0002003d4:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe0002003d8:	00f70733          	add	a4,a4,a5
ffffffe0002003dc:	fffff7b7          	lui	a5,0xfffff
ffffffe0002003e0:	00f777b3          	and	a5,a4,a5
ffffffe0002003e4:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe0002003e8:	01c0006f          	j	ffffffe000200404 <kfreerange+0x50>
        kfree((void *)addr);
ffffffe0002003ec:	fe843503          	ld	a0,-24(s0)
ffffffe0002003f0:	f45ff0ef          	jal	ra,ffffffe000200334 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe0002003f4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003f8:	000017b7          	lui	a5,0x1
ffffffe0002003fc:	00f707b3          	add	a5,a4,a5
ffffffe000200400:	fef43423          	sd	a5,-24(s0)
ffffffe000200404:	fe843703          	ld	a4,-24(s0)
ffffffe000200408:	000017b7          	lui	a5,0x1
ffffffe00020040c:	00f70733          	add	a4,a4,a5
ffffffe000200410:	fd043783          	ld	a5,-48(s0)
ffffffe000200414:	fce7fce3          	bgeu	a5,a4,ffffffe0002003ec <kfreerange+0x38>
    }
}
ffffffe000200418:	00000013          	nop
ffffffe00020041c:	00000013          	nop
ffffffe000200420:	02813083          	ld	ra,40(sp)
ffffffe000200424:	02013403          	ld	s0,32(sp)
ffffffe000200428:	03010113          	addi	sp,sp,48
ffffffe00020042c:	00008067          	ret

ffffffe000200430 <mm_init>:

void mm_init(void) {
ffffffe000200430:	ff010113          	addi	sp,sp,-16
ffffffe000200434:	00113423          	sd	ra,8(sp)
ffffffe000200438:	00813023          	sd	s0,0(sp)
ffffffe00020043c:	01010413          	addi	s0,sp,16
    kfreerange((char *)_ekernel, (char *)(PHY_END + PA2VA_OFFSET)); // VA
ffffffe000200440:	c0100793          	li	a5,-1023
ffffffe000200444:	01b79593          	slli	a1,a5,0x1b
ffffffe000200448:	00009517          	auipc	a0,0x9
ffffffe00020044c:	bb850513          	addi	a0,a0,-1096 # ffffffe000209000 <_ebss>
ffffffe000200450:	f65ff0ef          	jal	ra,ffffffe0002003b4 <kfreerange>
    printk("...mm_init done!\n");
ffffffe000200454:	00003517          	auipc	a0,0x3
ffffffe000200458:	bac50513          	addi	a0,a0,-1108 # ffffffe000203000 <_srodata>
ffffffe00020045c:	0f0020ef          	jal	ra,ffffffe00020254c <printk>
}
ffffffe000200460:	00000013          	nop
ffffffe000200464:	00813083          	ld	ra,8(sp)
ffffffe000200468:	00013403          	ld	s0,0(sp)
ffffffe00020046c:	01010113          	addi	sp,sp,16
ffffffe000200470:	00008067          	ret

ffffffe000200474 <task_init>:
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

extern void __dummy();

void task_init() {
ffffffe000200474:	fe010113          	addi	sp,sp,-32
ffffffe000200478:	00113c23          	sd	ra,24(sp)
ffffffe00020047c:	00813823          	sd	s0,16(sp)
ffffffe000200480:	02010413          	addi	s0,sp,32
    srand(2024);
ffffffe000200484:	7e800513          	li	a0,2024
ffffffe000200488:	144020ef          	jal	ra,ffffffe0002025cc <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
ffffffe00020048c:	e4dff0ef          	jal	ra,ffffffe0002002d8 <kalloc>
ffffffe000200490:	00050713          	mv	a4,a0
ffffffe000200494:	00006797          	auipc	a5,0x6
ffffffe000200498:	b7478793          	addi	a5,a5,-1164 # ffffffe000206008 <idle>
ffffffe00020049c:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe0002004a0:	00006797          	auipc	a5,0x6
ffffffe0002004a4:	b6878793          	addi	a5,a5,-1176 # ffffffe000206008 <idle>
ffffffe0002004a8:	0007b783          	ld	a5,0(a5)
ffffffe0002004ac:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe0002004b0:	00006797          	auipc	a5,0x6
ffffffe0002004b4:	b5878793          	addi	a5,a5,-1192 # ffffffe000206008 <idle>
ffffffe0002004b8:	0007b783          	ld	a5,0(a5)
ffffffe0002004bc:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe0002004c0:	00006797          	auipc	a5,0x6
ffffffe0002004c4:	b4878793          	addi	a5,a5,-1208 # ffffffe000206008 <idle>
ffffffe0002004c8:	0007b783          	ld	a5,0(a5)
ffffffe0002004cc:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe0002004d0:	00006797          	auipc	a5,0x6
ffffffe0002004d4:	b3878793          	addi	a5,a5,-1224 # ffffffe000206008 <idle>
ffffffe0002004d8:	0007b783          	ld	a5,0(a5)
ffffffe0002004dc:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe0002004e0:	00006797          	auipc	a5,0x6
ffffffe0002004e4:	b2878793          	addi	a5,a5,-1240 # ffffffe000206008 <idle>
ffffffe0002004e8:	0007b703          	ld	a4,0(a5)
ffffffe0002004ec:	00006797          	auipc	a5,0x6
ffffffe0002004f0:	b2478793          	addi	a5,a5,-1244 # ffffffe000206010 <current>
ffffffe0002004f4:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe0002004f8:	00006797          	auipc	a5,0x6
ffffffe0002004fc:	b1078793          	addi	a5,a5,-1264 # ffffffe000206008 <idle>
ffffffe000200500:	0007b703          	ld	a4,0(a5)
ffffffe000200504:	00006797          	auipc	a5,0x6
ffffffe000200508:	b2478793          	addi	a5,a5,-1244 # ffffffe000206028 <task>
ffffffe00020050c:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for(int i = 1; i < NR_TASKS; i++) {
ffffffe000200510:	00100793          	li	a5,1
ffffffe000200514:	fef42623          	sw	a5,-20(s0)
ffffffe000200518:	1600006f          	j	ffffffe000200678 <task_init+0x204>
        task[i] = (struct task_struct *)kalloc();
ffffffe00020051c:	dbdff0ef          	jal	ra,ffffffe0002002d8 <kalloc>
ffffffe000200520:	00050693          	mv	a3,a0
ffffffe000200524:	00006717          	auipc	a4,0x6
ffffffe000200528:	b0470713          	addi	a4,a4,-1276 # ffffffe000206028 <task>
ffffffe00020052c:	fec42783          	lw	a5,-20(s0)
ffffffe000200530:	00379793          	slli	a5,a5,0x3
ffffffe000200534:	00f707b3          	add	a5,a4,a5
ffffffe000200538:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe00020053c:	00006717          	auipc	a4,0x6
ffffffe000200540:	aec70713          	addi	a4,a4,-1300 # ffffffe000206028 <task>
ffffffe000200544:	fec42783          	lw	a5,-20(s0)
ffffffe000200548:	00379793          	slli	a5,a5,0x3
ffffffe00020054c:	00f707b3          	add	a5,a4,a5
ffffffe000200550:	0007b783          	ld	a5,0(a5)
ffffffe000200554:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200558:	0b8020ef          	jal	ra,ffffffe000202610 <rand>
ffffffe00020055c:	00050793          	mv	a5,a0
ffffffe000200560:	00078713          	mv	a4,a5
ffffffe000200564:	00a00793          	li	a5,10
ffffffe000200568:	02f767bb          	remw	a5,a4,a5
ffffffe00020056c:	0007879b          	sext.w	a5,a5
ffffffe000200570:	0017879b          	addiw	a5,a5,1
ffffffe000200574:	0007869b          	sext.w	a3,a5
ffffffe000200578:	00006717          	auipc	a4,0x6
ffffffe00020057c:	ab070713          	addi	a4,a4,-1360 # ffffffe000206028 <task>
ffffffe000200580:	fec42783          	lw	a5,-20(s0)
ffffffe000200584:	00379793          	slli	a5,a5,0x3
ffffffe000200588:	00f707b3          	add	a5,a4,a5
ffffffe00020058c:	0007b783          	ld	a5,0(a5)
ffffffe000200590:	00068713          	mv	a4,a3
ffffffe000200594:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe000200598:	00006717          	auipc	a4,0x6
ffffffe00020059c:	a9070713          	addi	a4,a4,-1392 # ffffffe000206028 <task>
ffffffe0002005a0:	fec42783          	lw	a5,-20(s0)
ffffffe0002005a4:	00379793          	slli	a5,a5,0x3
ffffffe0002005a8:	00f707b3          	add	a5,a4,a5
ffffffe0002005ac:	0007b783          	ld	a5,0(a5)
ffffffe0002005b0:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe0002005b4:	00006717          	auipc	a4,0x6
ffffffe0002005b8:	a7470713          	addi	a4,a4,-1420 # ffffffe000206028 <task>
ffffffe0002005bc:	fec42783          	lw	a5,-20(s0)
ffffffe0002005c0:	00379793          	slli	a5,a5,0x3
ffffffe0002005c4:	00f707b3          	add	a5,a4,a5
ffffffe0002005c8:	0007b783          	ld	a5,0(a5)
ffffffe0002005cc:	fec42703          	lw	a4,-20(s0)
ffffffe0002005d0:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe0002005d4:	00006717          	auipc	a4,0x6
ffffffe0002005d8:	a5470713          	addi	a4,a4,-1452 # ffffffe000206028 <task>
ffffffe0002005dc:	fec42783          	lw	a5,-20(s0)
ffffffe0002005e0:	00379793          	slli	a5,a5,0x3
ffffffe0002005e4:	00f707b3          	add	a5,a4,a5
ffffffe0002005e8:	0007b783          	ld	a5,0(a5)
ffffffe0002005ec:	00000717          	auipc	a4,0x0
ffffffe0002005f0:	bcc70713          	addi	a4,a4,-1076 # ffffffe0002001b8 <__dummy>
ffffffe0002005f4:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe0002005f8:	00006717          	auipc	a4,0x6
ffffffe0002005fc:	a3070713          	addi	a4,a4,-1488 # ffffffe000206028 <task>
ffffffe000200600:	fec42783          	lw	a5,-20(s0)
ffffffe000200604:	00379793          	slli	a5,a5,0x3
ffffffe000200608:	00f707b3          	add	a5,a4,a5
ffffffe00020060c:	0007b783          	ld	a5,0(a5)
ffffffe000200610:	00078693          	mv	a3,a5
ffffffe000200614:	00006717          	auipc	a4,0x6
ffffffe000200618:	a1470713          	addi	a4,a4,-1516 # ffffffe000206028 <task>
ffffffe00020061c:	fec42783          	lw	a5,-20(s0)
ffffffe000200620:	00379793          	slli	a5,a5,0x3
ffffffe000200624:	00f707b3          	add	a5,a4,a5
ffffffe000200628:	0007b783          	ld	a5,0(a5)
ffffffe00020062c:	00001737          	lui	a4,0x1
ffffffe000200630:	00e68733          	add	a4,a3,a4
ffffffe000200634:	02e7b423          	sd	a4,40(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe000200638:	00006717          	auipc	a4,0x6
ffffffe00020063c:	9f070713          	addi	a4,a4,-1552 # ffffffe000206028 <task>
ffffffe000200640:	fec42783          	lw	a5,-20(s0)
ffffffe000200644:	00379793          	slli	a5,a5,0x3
ffffffe000200648:	00f707b3          	add	a5,a4,a5
ffffffe00020064c:	0007b783          	ld	a5,0(a5)
ffffffe000200650:	0107b703          	ld	a4,16(a5)
ffffffe000200654:	fec42783          	lw	a5,-20(s0)
ffffffe000200658:	00070613          	mv	a2,a4
ffffffe00020065c:	00078593          	mv	a1,a5
ffffffe000200660:	00003517          	auipc	a0,0x3
ffffffe000200664:	9b850513          	addi	a0,a0,-1608 # ffffffe000203018 <_srodata+0x18>
ffffffe000200668:	6e5010ef          	jal	ra,ffffffe00020254c <printk>
    for(int i = 1; i < NR_TASKS; i++) {
ffffffe00020066c:	fec42783          	lw	a5,-20(s0)
ffffffe000200670:	0017879b          	addiw	a5,a5,1
ffffffe000200674:	fef42623          	sw	a5,-20(s0)
ffffffe000200678:	fec42783          	lw	a5,-20(s0)
ffffffe00020067c:	0007871b          	sext.w	a4,a5
ffffffe000200680:	00400793          	li	a5,4
ffffffe000200684:	e8e7dce3          	bge	a5,a4,ffffffe00020051c <task_init+0xa8>
    }

    printk("...task_init done!\n");
ffffffe000200688:	00003517          	auipc	a0,0x3
ffffffe00020068c:	9b050513          	addi	a0,a0,-1616 # ffffffe000203038 <_srodata+0x38>
ffffffe000200690:	6bd010ef          	jal	ra,ffffffe00020254c <printk>
}
ffffffe000200694:	00000013          	nop
ffffffe000200698:	01813083          	ld	ra,24(sp)
ffffffe00020069c:	01013403          	ld	s0,16(sp)
ffffffe0002006a0:	02010113          	addi	sp,sp,32
ffffffe0002006a4:	00008067          	ret

ffffffe0002006a8 <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next);

void switch_to(struct task_struct *next) {
ffffffe0002006a8:	fd010113          	addi	sp,sp,-48
ffffffe0002006ac:	02113423          	sd	ra,40(sp)
ffffffe0002006b0:	02813023          	sd	s0,32(sp)
ffffffe0002006b4:	03010413          	addi	s0,sp,48
ffffffe0002006b8:	fca43c23          	sd	a0,-40(s0)
    if (current != next) {
ffffffe0002006bc:	00006797          	auipc	a5,0x6
ffffffe0002006c0:	95478793          	addi	a5,a5,-1708 # ffffffe000206010 <current>
ffffffe0002006c4:	0007b783          	ld	a5,0(a5)
ffffffe0002006c8:	fd843703          	ld	a4,-40(s0)
ffffffe0002006cc:	04f70063          	beq	a4,a5,ffffffe00020070c <switch_to+0x64>
        struct task_struct *prev = current;
ffffffe0002006d0:	00006797          	auipc	a5,0x6
ffffffe0002006d4:	94078793          	addi	a5,a5,-1728 # ffffffe000206010 <current>
ffffffe0002006d8:	0007b783          	ld	a5,0(a5)
ffffffe0002006dc:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002006e0:	00006797          	auipc	a5,0x6
ffffffe0002006e4:	93078793          	addi	a5,a5,-1744 # ffffffe000206010 <current>
ffffffe0002006e8:	fd843703          	ld	a4,-40(s0)
ffffffe0002006ec:	00e7b023          	sd	a4,0(a5)
        __switch_to(&(prev->thread), &(next->thread));
ffffffe0002006f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002006f4:	02078713          	addi	a4,a5,32
ffffffe0002006f8:	fd843783          	ld	a5,-40(s0)
ffffffe0002006fc:	02078793          	addi	a5,a5,32
ffffffe000200700:	00078593          	mv	a1,a5
ffffffe000200704:	00070513          	mv	a0,a4
ffffffe000200708:	ac1ff0ef          	jal	ra,ffffffe0002001c8 <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
ffffffe00020070c:	00000013          	nop
ffffffe000200710:	02813083          	ld	ra,40(sp)
ffffffe000200714:	02013403          	ld	s0,32(sp)
ffffffe000200718:	03010113          	addi	sp,sp,48
ffffffe00020071c:	00008067          	ret

ffffffe000200720 <do_timer>:

void do_timer() {
ffffffe000200720:	ff010113          	addi	sp,sp,-16
ffffffe000200724:	00113423          	sd	ra,8(sp)
ffffffe000200728:	00813023          	sd	s0,0(sp)
ffffffe00020072c:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0) {
ffffffe000200730:	00006797          	auipc	a5,0x6
ffffffe000200734:	8e078793          	addi	a5,a5,-1824 # ffffffe000206010 <current>
ffffffe000200738:	0007b783          	ld	a5,0(a5)
ffffffe00020073c:	0187b783          	ld	a5,24(a5)
ffffffe000200740:	00078c63          	beqz	a5,ffffffe000200758 <do_timer+0x38>
ffffffe000200744:	00006797          	auipc	a5,0x6
ffffffe000200748:	8cc78793          	addi	a5,a5,-1844 # ffffffe000206010 <current>
ffffffe00020074c:	0007b783          	ld	a5,0(a5)
ffffffe000200750:	0087b783          	ld	a5,8(a5)
ffffffe000200754:	00079663          	bnez	a5,ffffffe000200760 <do_timer+0x40>
        schedule();
ffffffe000200758:	050000ef          	jal	ra,ffffffe0002007a8 <schedule>
ffffffe00020075c:	03c0006f          	j	ffffffe000200798 <do_timer+0x78>
    } else {
        --(current->counter);
ffffffe000200760:	00006797          	auipc	a5,0x6
ffffffe000200764:	8b078793          	addi	a5,a5,-1872 # ffffffe000206010 <current>
ffffffe000200768:	0007b783          	ld	a5,0(a5)
ffffffe00020076c:	0087b703          	ld	a4,8(a5)
ffffffe000200770:	fff70713          	addi	a4,a4,-1
ffffffe000200774:	00e7b423          	sd	a4,8(a5)
        if(current->counter > 0) {
ffffffe000200778:	00006797          	auipc	a5,0x6
ffffffe00020077c:	89878793          	addi	a5,a5,-1896 # ffffffe000206010 <current>
ffffffe000200780:	0007b783          	ld	a5,0(a5)
ffffffe000200784:	0087b783          	ld	a5,8(a5)
ffffffe000200788:	00079663          	bnez	a5,ffffffe000200794 <do_timer+0x74>
            return;
        }
        schedule();
ffffffe00020078c:	01c000ef          	jal	ra,ffffffe0002007a8 <schedule>
ffffffe000200790:	0080006f          	j	ffffffe000200798 <do_timer+0x78>
            return;
ffffffe000200794:	00000013          	nop
    }
}
ffffffe000200798:	00813083          	ld	ra,8(sp)
ffffffe00020079c:	00013403          	ld	s0,0(sp)
ffffffe0002007a0:	01010113          	addi	sp,sp,16
ffffffe0002007a4:	00008067          	ret

ffffffe0002007a8 <schedule>:

void schedule() {
ffffffe0002007a8:	fd010113          	addi	sp,sp,-48
ffffffe0002007ac:	02113423          	sd	ra,40(sp)
ffffffe0002007b0:	02813023          	sd	s0,32(sp)
ffffffe0002007b4:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe0002007b8:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
ffffffe0002007bc:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < NR_TASKS; i++) {
ffffffe0002007c0:	00100793          	li	a5,1
ffffffe0002007c4:	fef42023          	sw	a5,-32(s0)
ffffffe0002007c8:	0ac0006f          	j	ffffffe000200874 <schedule+0xcc>
        if (task[i] && task[i]->state == TASK_RUNNING) {
ffffffe0002007cc:	00006717          	auipc	a4,0x6
ffffffe0002007d0:	85c70713          	addi	a4,a4,-1956 # ffffffe000206028 <task>
ffffffe0002007d4:	fe042783          	lw	a5,-32(s0)
ffffffe0002007d8:	00379793          	slli	a5,a5,0x3
ffffffe0002007dc:	00f707b3          	add	a5,a4,a5
ffffffe0002007e0:	0007b783          	ld	a5,0(a5)
ffffffe0002007e4:	08078263          	beqz	a5,ffffffe000200868 <schedule+0xc0>
ffffffe0002007e8:	00006717          	auipc	a4,0x6
ffffffe0002007ec:	84070713          	addi	a4,a4,-1984 # ffffffe000206028 <task>
ffffffe0002007f0:	fe042783          	lw	a5,-32(s0)
ffffffe0002007f4:	00379793          	slli	a5,a5,0x3
ffffffe0002007f8:	00f707b3          	add	a5,a4,a5
ffffffe0002007fc:	0007b783          	ld	a5,0(a5)
ffffffe000200800:	0007b783          	ld	a5,0(a5)
ffffffe000200804:	06079263          	bnez	a5,ffffffe000200868 <schedule+0xc0>
            if (task[i]->counter > max_counter) {
ffffffe000200808:	00006717          	auipc	a4,0x6
ffffffe00020080c:	82070713          	addi	a4,a4,-2016 # ffffffe000206028 <task>
ffffffe000200810:	fe042783          	lw	a5,-32(s0)
ffffffe000200814:	00379793          	slli	a5,a5,0x3
ffffffe000200818:	00f707b3          	add	a5,a4,a5
ffffffe00020081c:	0007b783          	ld	a5,0(a5)
ffffffe000200820:	0087b703          	ld	a4,8(a5)
ffffffe000200824:	fe442783          	lw	a5,-28(s0)
ffffffe000200828:	04e7f063          	bgeu	a5,a4,ffffffe000200868 <schedule+0xc0>
                max_counter = task[i]->counter;
ffffffe00020082c:	00005717          	auipc	a4,0x5
ffffffe000200830:	7fc70713          	addi	a4,a4,2044 # ffffffe000206028 <task>
ffffffe000200834:	fe042783          	lw	a5,-32(s0)
ffffffe000200838:	00379793          	slli	a5,a5,0x3
ffffffe00020083c:	00f707b3          	add	a5,a4,a5
ffffffe000200840:	0007b783          	ld	a5,0(a5)
ffffffe000200844:	0087b783          	ld	a5,8(a5)
ffffffe000200848:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe00020084c:	00005717          	auipc	a4,0x5
ffffffe000200850:	7dc70713          	addi	a4,a4,2012 # ffffffe000206028 <task>
ffffffe000200854:	fe042783          	lw	a5,-32(s0)
ffffffe000200858:	00379793          	slli	a5,a5,0x3
ffffffe00020085c:	00f707b3          	add	a5,a4,a5
ffffffe000200860:	0007b783          	ld	a5,0(a5)
ffffffe000200864:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < NR_TASKS; i++) {
ffffffe000200868:	fe042783          	lw	a5,-32(s0)
ffffffe00020086c:	0017879b          	addiw	a5,a5,1
ffffffe000200870:	fef42023          	sw	a5,-32(s0)
ffffffe000200874:	fe042783          	lw	a5,-32(s0)
ffffffe000200878:	0007871b          	sext.w	a4,a5
ffffffe00020087c:	00400793          	li	a5,4
ffffffe000200880:	f4e7d6e3          	bge	a5,a4,ffffffe0002007cc <schedule+0x24>
            }
        }
    }

    if (max_counter == 0) {
ffffffe000200884:	fe442783          	lw	a5,-28(s0)
ffffffe000200888:	0007879b          	sext.w	a5,a5
ffffffe00020088c:	0a079263          	bnez	a5,ffffffe000200930 <schedule+0x188>
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe000200890:	fc042e23          	sw	zero,-36(s0)
ffffffe000200894:	0840006f          	j	ffffffe000200918 <schedule+0x170>
            if (task[i] && task[i]->state == TASK_RUNNING) {
ffffffe000200898:	00005717          	auipc	a4,0x5
ffffffe00020089c:	79070713          	addi	a4,a4,1936 # ffffffe000206028 <task>
ffffffe0002008a0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008a4:	00379793          	slli	a5,a5,0x3
ffffffe0002008a8:	00f707b3          	add	a5,a4,a5
ffffffe0002008ac:	0007b783          	ld	a5,0(a5)
ffffffe0002008b0:	04078e63          	beqz	a5,ffffffe00020090c <schedule+0x164>
ffffffe0002008b4:	00005717          	auipc	a4,0x5
ffffffe0002008b8:	77470713          	addi	a4,a4,1908 # ffffffe000206028 <task>
ffffffe0002008bc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008c0:	00379793          	slli	a5,a5,0x3
ffffffe0002008c4:	00f707b3          	add	a5,a4,a5
ffffffe0002008c8:	0007b783          	ld	a5,0(a5)
ffffffe0002008cc:	0007b783          	ld	a5,0(a5)
ffffffe0002008d0:	02079e63          	bnez	a5,ffffffe00020090c <schedule+0x164>
                task[i]->counter = task[i]->priority;
ffffffe0002008d4:	00005717          	auipc	a4,0x5
ffffffe0002008d8:	75470713          	addi	a4,a4,1876 # ffffffe000206028 <task>
ffffffe0002008dc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008e0:	00379793          	slli	a5,a5,0x3
ffffffe0002008e4:	00f707b3          	add	a5,a4,a5
ffffffe0002008e8:	0007b703          	ld	a4,0(a5)
ffffffe0002008ec:	00005697          	auipc	a3,0x5
ffffffe0002008f0:	73c68693          	addi	a3,a3,1852 # ffffffe000206028 <task>
ffffffe0002008f4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008f8:	00379793          	slli	a5,a5,0x3
ffffffe0002008fc:	00f687b3          	add	a5,a3,a5
ffffffe000200900:	0007b783          	ld	a5,0(a5)
ffffffe000200904:	01073703          	ld	a4,16(a4)
ffffffe000200908:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe00020090c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200910:	0017879b          	addiw	a5,a5,1
ffffffe000200914:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200918:	fdc42783          	lw	a5,-36(s0)
ffffffe00020091c:	0007871b          	sext.w	a4,a5
ffffffe000200920:	00400793          	li	a5,4
ffffffe000200924:	f6e7dae3          	bge	a5,a4,ffffffe000200898 <schedule+0xf0>
            }
        }
        schedule();
ffffffe000200928:	e81ff0ef          	jal	ra,ffffffe0002007a8 <schedule>
        return;
ffffffe00020092c:	0280006f          	j	ffffffe000200954 <schedule+0x1ac>
    }

    if (next && next != current) {
ffffffe000200930:	fe843783          	ld	a5,-24(s0)
ffffffe000200934:	02078063          	beqz	a5,ffffffe000200954 <schedule+0x1ac>
ffffffe000200938:	00005797          	auipc	a5,0x5
ffffffe00020093c:	6d878793          	addi	a5,a5,1752 # ffffffe000206010 <current>
ffffffe000200940:	0007b783          	ld	a5,0(a5)
ffffffe000200944:	fe843703          	ld	a4,-24(s0)
ffffffe000200948:	00f70663          	beq	a4,a5,ffffffe000200954 <schedule+0x1ac>
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
ffffffe00020094c:	fe843503          	ld	a0,-24(s0)
ffffffe000200950:	d59ff0ef          	jal	ra,ffffffe0002006a8 <switch_to>
    }
}
ffffffe000200954:	02813083          	ld	ra,40(sp)
ffffffe000200958:	02013403          	ld	s0,32(sp)
ffffffe00020095c:	03010113          	addi	sp,sp,48
ffffffe000200960:	00008067          	ret

ffffffe000200964 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
ffffffe000200964:	fd010113          	addi	sp,sp,-48
ffffffe000200968:	02113423          	sd	ra,40(sp)
ffffffe00020096c:	02813023          	sd	s0,32(sp)
ffffffe000200970:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000200974:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000200978:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe00020097c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000200980:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000200984:	fff00793          	li	a5,-1
ffffffe000200988:	fef42223          	sw	a5,-28(s0)
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe00020098c:	fe442783          	lw	a5,-28(s0)
ffffffe000200990:	0007871b          	sext.w	a4,a5
ffffffe000200994:	fff00793          	li	a5,-1
ffffffe000200998:	00f70e63          	beq	a4,a5,ffffffe0002009b4 <dummy+0x50>
ffffffe00020099c:	00005797          	auipc	a5,0x5
ffffffe0002009a0:	67478793          	addi	a5,a5,1652 # ffffffe000206010 <current>
ffffffe0002009a4:	0007b783          	ld	a5,0(a5)
ffffffe0002009a8:	0087b703          	ld	a4,8(a5)
ffffffe0002009ac:	fe442783          	lw	a5,-28(s0)
ffffffe0002009b0:	fcf70ee3          	beq	a4,a5,ffffffe00020098c <dummy+0x28>
ffffffe0002009b4:	00005797          	auipc	a5,0x5
ffffffe0002009b8:	65c78793          	addi	a5,a5,1628 # ffffffe000206010 <current>
ffffffe0002009bc:	0007b783          	ld	a5,0(a5)
ffffffe0002009c0:	0087b783          	ld	a5,8(a5)
ffffffe0002009c4:	fc0784e3          	beqz	a5,ffffffe00020098c <dummy+0x28>
            if (current->counter == 1) {
ffffffe0002009c8:	00005797          	auipc	a5,0x5
ffffffe0002009cc:	64878793          	addi	a5,a5,1608 # ffffffe000206010 <current>
ffffffe0002009d0:	0007b783          	ld	a5,0(a5)
ffffffe0002009d4:	0087b703          	ld	a4,8(a5)
ffffffe0002009d8:	00100793          	li	a5,1
ffffffe0002009dc:	00f71e63          	bne	a4,a5,ffffffe0002009f8 <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002009e0:	00005797          	auipc	a5,0x5
ffffffe0002009e4:	63078793          	addi	a5,a5,1584 # ffffffe000206010 <current>
ffffffe0002009e8:	0007b783          	ld	a5,0(a5)
ffffffe0002009ec:	0087b703          	ld	a4,8(a5)
ffffffe0002009f0:	fff70713          	addi	a4,a4,-1
ffffffe0002009f4:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002009f8:	00005797          	auipc	a5,0x5
ffffffe0002009fc:	61878793          	addi	a5,a5,1560 # ffffffe000206010 <current>
ffffffe000200a00:	0007b783          	ld	a5,0(a5)
ffffffe000200a04:	0087b783          	ld	a5,8(a5)
ffffffe000200a08:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000200a0c:	fe843783          	ld	a5,-24(s0)
ffffffe000200a10:	00178713          	addi	a4,a5,1
ffffffe000200a14:	fd843783          	ld	a5,-40(s0)
ffffffe000200a18:	02f777b3          	remu	a5,a4,a5
ffffffe000200a1c:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe000200a20:	00005797          	auipc	a5,0x5
ffffffe000200a24:	5f078793          	addi	a5,a5,1520 # ffffffe000206010 <current>
ffffffe000200a28:	0007b783          	ld	a5,0(a5)
ffffffe000200a2c:	0187b783          	ld	a5,24(a5)
ffffffe000200a30:	fe843603          	ld	a2,-24(s0)
ffffffe000200a34:	00078593          	mv	a1,a5
ffffffe000200a38:	00002517          	auipc	a0,0x2
ffffffe000200a3c:	61850513          	addi	a0,a0,1560 # ffffffe000203050 <_srodata+0x50>
ffffffe000200a40:	30d010ef          	jal	ra,ffffffe00020254c <printk>
            #if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
ffffffe000200a44:	00005797          	auipc	a5,0x5
ffffffe000200a48:	5cc78793          	addi	a5,a5,1484 # ffffffe000206010 <current>
ffffffe000200a4c:	0007b783          	ld	a5,0(a5)
ffffffe000200a50:	0187b783          	ld	a5,24(a5)
ffffffe000200a54:	0ff7f713          	zext.b	a4,a5
ffffffe000200a58:	00005797          	auipc	a5,0x5
ffffffe000200a5c:	5c078793          	addi	a5,a5,1472 # ffffffe000206018 <tasks_output_index>
ffffffe000200a60:	0007a783          	lw	a5,0(a5)
ffffffe000200a64:	0017869b          	addiw	a3,a5,1
ffffffe000200a68:	0006861b          	sext.w	a2,a3
ffffffe000200a6c:	00005697          	auipc	a3,0x5
ffffffe000200a70:	5ac68693          	addi	a3,a3,1452 # ffffffe000206018 <tasks_output_index>
ffffffe000200a74:	00c6a023          	sw	a2,0(a3)
ffffffe000200a78:	0307071b          	addiw	a4,a4,48
ffffffe000200a7c:	0ff77713          	zext.b	a4,a4
ffffffe000200a80:	00005697          	auipc	a3,0x5
ffffffe000200a84:	5d068693          	addi	a3,a3,1488 # ffffffe000206050 <tasks_output>
ffffffe000200a88:	00f687b3          	add	a5,a3,a5
ffffffe000200a8c:	00e78023          	sb	a4,0(a5)
            if (tasks_output_index == MAX_OUTPUT) {
ffffffe000200a90:	00005797          	auipc	a5,0x5
ffffffe000200a94:	58878793          	addi	a5,a5,1416 # ffffffe000206018 <tasks_output_index>
ffffffe000200a98:	0007a783          	lw	a5,0(a5)
ffffffe000200a9c:	00078713          	mv	a4,a5
ffffffe000200aa0:	02800793          	li	a5,40
ffffffe000200aa4:	eef714e3          	bne	a4,a5,ffffffe00020098c <dummy+0x28>
                for (int i = 0; i < MAX_OUTPUT; ++i) {
ffffffe000200aa8:	fe042023          	sw	zero,-32(s0)
ffffffe000200aac:	0800006f          	j	ffffffe000200b2c <dummy+0x1c8>
                    if (tasks_output[i] != expected_output[i]) {
ffffffe000200ab0:	00005717          	auipc	a4,0x5
ffffffe000200ab4:	5a070713          	addi	a4,a4,1440 # ffffffe000206050 <tasks_output>
ffffffe000200ab8:	fe042783          	lw	a5,-32(s0)
ffffffe000200abc:	00f707b3          	add	a5,a4,a5
ffffffe000200ac0:	0007c683          	lbu	a3,0(a5)
ffffffe000200ac4:	00003717          	auipc	a4,0x3
ffffffe000200ac8:	54470713          	addi	a4,a4,1348 # ffffffe000204008 <expected_output>
ffffffe000200acc:	fe042783          	lw	a5,-32(s0)
ffffffe000200ad0:	00f707b3          	add	a5,a4,a5
ffffffe000200ad4:	0007c783          	lbu	a5,0(a5)
ffffffe000200ad8:	00068713          	mv	a4,a3
ffffffe000200adc:	04f70263          	beq	a4,a5,ffffffe000200b20 <dummy+0x1bc>
                        printk("\033[31mTest failed!\033[0m\n");
ffffffe000200ae0:	00002517          	auipc	a0,0x2
ffffffe000200ae4:	5a050513          	addi	a0,a0,1440 # ffffffe000203080 <_srodata+0x80>
ffffffe000200ae8:	265010ef          	jal	ra,ffffffe00020254c <printk>
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
ffffffe000200aec:	00003597          	auipc	a1,0x3
ffffffe000200af0:	51c58593          	addi	a1,a1,1308 # ffffffe000204008 <expected_output>
ffffffe000200af4:	00002517          	auipc	a0,0x2
ffffffe000200af8:	5a450513          	addi	a0,a0,1444 # ffffffe000203098 <_srodata+0x98>
ffffffe000200afc:	251010ef          	jal	ra,ffffffe00020254c <printk>
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
ffffffe000200b00:	00005597          	auipc	a1,0x5
ffffffe000200b04:	55058593          	addi	a1,a1,1360 # ffffffe000206050 <tasks_output>
ffffffe000200b08:	00002517          	auipc	a0,0x2
ffffffe000200b0c:	5b050513          	addi	a0,a0,1456 # ffffffe0002030b8 <_srodata+0xb8>
ffffffe000200b10:	23d010ef          	jal	ra,ffffffe00020254c <printk>
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
ffffffe000200b14:	00000593          	li	a1,0
ffffffe000200b18:	00000513          	li	a0,0
ffffffe000200b1c:	17c000ef          	jal	ra,ffffffe000200c98 <sbi_system_reset>
                for (int i = 0; i < MAX_OUTPUT; ++i) {
ffffffe000200b20:	fe042783          	lw	a5,-32(s0)
ffffffe000200b24:	0017879b          	addiw	a5,a5,1
ffffffe000200b28:	fef42023          	sw	a5,-32(s0)
ffffffe000200b2c:	fe042783          	lw	a5,-32(s0)
ffffffe000200b30:	0007871b          	sext.w	a4,a5
ffffffe000200b34:	02700793          	li	a5,39
ffffffe000200b38:	f6e7dce3          	bge	a5,a4,ffffffe000200ab0 <dummy+0x14c>
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
ffffffe000200b3c:	00002517          	auipc	a0,0x2
ffffffe000200b40:	59c50513          	addi	a0,a0,1436 # ffffffe0002030d8 <_srodata+0xd8>
ffffffe000200b44:	209010ef          	jal	ra,ffffffe00020254c <printk>
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
ffffffe000200b48:	00003597          	auipc	a1,0x3
ffffffe000200b4c:	4c058593          	addi	a1,a1,1216 # ffffffe000204008 <expected_output>
ffffffe000200b50:	00002517          	auipc	a0,0x2
ffffffe000200b54:	5a050513          	addi	a0,a0,1440 # ffffffe0002030f0 <_srodata+0xf0>
ffffffe000200b58:	1f5010ef          	jal	ra,ffffffe00020254c <printk>
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
ffffffe000200b5c:	00000593          	li	a1,0
ffffffe000200b60:	00000513          	li	a0,0
ffffffe000200b64:	134000ef          	jal	ra,ffffffe000200c98 <sbi_system_reset>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200b68:	e25ff06f          	j	ffffffe00020098c <dummy+0x28>

ffffffe000200b6c <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000200b6c:	f8010113          	addi	sp,sp,-128
ffffffe000200b70:	06813c23          	sd	s0,120(sp)
ffffffe000200b74:	06913823          	sd	s1,112(sp)
ffffffe000200b78:	07213423          	sd	s2,104(sp)
ffffffe000200b7c:	07313023          	sd	s3,96(sp)
ffffffe000200b80:	08010413          	addi	s0,sp,128
ffffffe000200b84:	faa43c23          	sd	a0,-72(s0)
ffffffe000200b88:	fab43823          	sd	a1,-80(s0)
ffffffe000200b8c:	fac43423          	sd	a2,-88(s0)
ffffffe000200b90:	fad43023          	sd	a3,-96(s0)
ffffffe000200b94:	f8e43c23          	sd	a4,-104(s0)
ffffffe000200b98:	f8f43823          	sd	a5,-112(s0)
ffffffe000200b9c:	f9043423          	sd	a6,-120(s0)
ffffffe000200ba0:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe000200ba4:	fb843e03          	ld	t3,-72(s0)
ffffffe000200ba8:	fb043e83          	ld	t4,-80(s0)
ffffffe000200bac:	fa843f03          	ld	t5,-88(s0)
ffffffe000200bb0:	fa043f83          	ld	t6,-96(s0)
ffffffe000200bb4:	f9843283          	ld	t0,-104(s0)
ffffffe000200bb8:	f9043483          	ld	s1,-112(s0)
ffffffe000200bbc:	f8843903          	ld	s2,-120(s0)
ffffffe000200bc0:	f8043983          	ld	s3,-128(s0)
ffffffe000200bc4:	000e0893          	mv	a7,t3
ffffffe000200bc8:	000e8813          	mv	a6,t4
ffffffe000200bcc:	000f0513          	mv	a0,t5
ffffffe000200bd0:	000f8593          	mv	a1,t6
ffffffe000200bd4:	00028613          	mv	a2,t0
ffffffe000200bd8:	00048693          	mv	a3,s1
ffffffe000200bdc:	00090713          	mv	a4,s2
ffffffe000200be0:	00098793          	mv	a5,s3
ffffffe000200be4:	00000073          	ecall
ffffffe000200be8:	00050e93          	mv	t4,a0
ffffffe000200bec:	00058e13          	mv	t3,a1
ffffffe000200bf0:	fdd43023          	sd	t4,-64(s0)
ffffffe000200bf4:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe000200bf8:	fc043783          	ld	a5,-64(s0)
ffffffe000200bfc:	fcf43823          	sd	a5,-48(s0)
ffffffe000200c00:	fc843783          	ld	a5,-56(s0)
ffffffe000200c04:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200c08:	fd043703          	ld	a4,-48(s0)
ffffffe000200c0c:	fd843783          	ld	a5,-40(s0)
ffffffe000200c10:	00070313          	mv	t1,a4
ffffffe000200c14:	00078393          	mv	t2,a5
ffffffe000200c18:	00030713          	mv	a4,t1
ffffffe000200c1c:	00038793          	mv	a5,t2
}
ffffffe000200c20:	00070513          	mv	a0,a4
ffffffe000200c24:	00078593          	mv	a1,a5
ffffffe000200c28:	07813403          	ld	s0,120(sp)
ffffffe000200c2c:	07013483          	ld	s1,112(sp)
ffffffe000200c30:	06813903          	ld	s2,104(sp)
ffffffe000200c34:	06013983          	ld	s3,96(sp)
ffffffe000200c38:	08010113          	addi	sp,sp,128
ffffffe000200c3c:	00008067          	ret

ffffffe000200c40 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000200c40:	fd010113          	addi	sp,sp,-48
ffffffe000200c44:	02813423          	sd	s0,40(sp)
ffffffe000200c48:	03010413          	addi	s0,sp,48
ffffffe000200c4c:	00050793          	mv	a5,a0
ffffffe000200c50:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200c54:	00100793          	li	a5,1
ffffffe000200c58:	00000713          	li	a4,0
ffffffe000200c5c:	fdf44683          	lbu	a3,-33(s0)
ffffffe000200c60:	00078893          	mv	a7,a5
ffffffe000200c64:	00070813          	mv	a6,a4
ffffffe000200c68:	00068513          	mv	a0,a3
ffffffe000200c6c:	00000073          	ecall
ffffffe000200c70:	00050713          	mv	a4,a0
ffffffe000200c74:	00058793          	mv	a5,a1
ffffffe000200c78:	fee43023          	sd	a4,-32(s0)
ffffffe000200c7c:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe000200c80:	00000013          	nop
ffffffe000200c84:	00070513          	mv	a0,a4
ffffffe000200c88:	00078593          	mv	a1,a5
ffffffe000200c8c:	02813403          	ld	s0,40(sp)
ffffffe000200c90:	03010113          	addi	sp,sp,48
ffffffe000200c94:	00008067          	ret

ffffffe000200c98 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000200c98:	fc010113          	addi	sp,sp,-64
ffffffe000200c9c:	02813c23          	sd	s0,56(sp)
ffffffe000200ca0:	04010413          	addi	s0,sp,64
ffffffe000200ca4:	00050793          	mv	a5,a0
ffffffe000200ca8:	00058713          	mv	a4,a1
ffffffe000200cac:	fcf42623          	sw	a5,-52(s0)
ffffffe000200cb0:	00070793          	mv	a5,a4
ffffffe000200cb4:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200cb8:	00800793          	li	a5,8
ffffffe000200cbc:	00000713          	li	a4,0
ffffffe000200cc0:	fcc42583          	lw	a1,-52(s0)
ffffffe000200cc4:	00058313          	mv	t1,a1
ffffffe000200cc8:	fc842583          	lw	a1,-56(s0)
ffffffe000200ccc:	00058e13          	mv	t3,a1
ffffffe000200cd0:	00078893          	mv	a7,a5
ffffffe000200cd4:	00070813          	mv	a6,a4
ffffffe000200cd8:	00030513          	mv	a0,t1
ffffffe000200cdc:	000e0593          	mv	a1,t3
ffffffe000200ce0:	00000073          	ecall
ffffffe000200ce4:	00050713          	mv	a4,a0
ffffffe000200ce8:	00058793          	mv	a5,a1
ffffffe000200cec:	fce43823          	sd	a4,-48(s0)
ffffffe000200cf0:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe000200cf4:	fd043783          	ld	a5,-48(s0)
ffffffe000200cf8:	fef43023          	sd	a5,-32(s0)
ffffffe000200cfc:	fd843783          	ld	a5,-40(s0)
ffffffe000200d00:	fef43423          	sd	a5,-24(s0)
ffffffe000200d04:	fe043703          	ld	a4,-32(s0)
ffffffe000200d08:	fe843783          	ld	a5,-24(s0)
ffffffe000200d0c:	00070613          	mv	a2,a4
ffffffe000200d10:	00078693          	mv	a3,a5
ffffffe000200d14:	00060713          	mv	a4,a2
ffffffe000200d18:	00068793          	mv	a5,a3
ffffffe000200d1c:	00070513          	mv	a0,a4
ffffffe000200d20:	00078593          	mv	a1,a5
ffffffe000200d24:	03813403          	ld	s0,56(sp)
ffffffe000200d28:	04010113          	addi	sp,sp,64
ffffffe000200d2c:	00008067          	ret

ffffffe000200d30 <trap_handler>:
extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc) {
ffffffe000200d30:	fd010113          	addi	sp,sp,-48
ffffffe000200d34:	02113423          	sd	ra,40(sp)
ffffffe000200d38:	02813023          	sd	s0,32(sp)
ffffffe000200d3c:	03010413          	addi	s0,sp,48
ffffffe000200d40:	fca43c23          	sd	a0,-40(s0)
ffffffe000200d44:	fcb43823          	sd	a1,-48(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
ffffffe000200d48:	fd843783          	ld	a5,-40(s0)
ffffffe000200d4c:	0407d063          	bgez	a5,ffffffe000200d8c <trap_handler+0x5c>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe000200d50:	fd843783          	ld	a5,-40(s0)
ffffffe000200d54:	0ff7f793          	zext.b	a5,a5
ffffffe000200d58:	fef43423          	sd	a5,-24(s0)
        if (interrupt_t == 0x5) {
ffffffe000200d5c:	fe843703          	ld	a4,-24(s0)
ffffffe000200d60:	00500793          	li	a5,5
ffffffe000200d64:	00f71863          	bne	a4,a5,ffffffe000200d74 <trap_handler+0x44>
            // timer interrupt
            clock_set_next_event();
ffffffe000200d68:	d28ff0ef          	jal	ra,ffffffe000200290 <clock_set_next_event>
            do_timer();
ffffffe000200d6c:	9b5ff0ef          	jal	ra,ffffffe000200720 <do_timer>
    }
    else {
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        // exception
    }
ffffffe000200d70:	0300006f          	j	ffffffe000200da0 <trap_handler+0x70>
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000200d74:	fd043603          	ld	a2,-48(s0)
ffffffe000200d78:	fd843583          	ld	a1,-40(s0)
ffffffe000200d7c:	00002517          	auipc	a0,0x2
ffffffe000200d80:	39450513          	addi	a0,a0,916 # ffffffe000203110 <_srodata+0x110>
ffffffe000200d84:	7c8010ef          	jal	ra,ffffffe00020254c <printk>
ffffffe000200d88:	0180006f          	j	ffffffe000200da0 <trap_handler+0x70>
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000200d8c:	fd043603          	ld	a2,-48(s0)
ffffffe000200d90:	fd843583          	ld	a1,-40(s0)
ffffffe000200d94:	00002517          	auipc	a0,0x2
ffffffe000200d98:	3ac50513          	addi	a0,a0,940 # ffffffe000203140 <_srodata+0x140>
ffffffe000200d9c:	7b0010ef          	jal	ra,ffffffe00020254c <printk>
ffffffe000200da0:	00000013          	nop
ffffffe000200da4:	02813083          	ld	ra,40(sp)
ffffffe000200da8:	02013403          	ld	s0,32(sp)
ffffffe000200dac:	03010113          	addi	sp,sp,48
ffffffe000200db0:	00008067          	ret

ffffffe000200db4 <setup_vm>:
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe000200db4:	fe010113          	addi	sp,sp,-32
ffffffe000200db8:	00113c23          	sd	ra,24(sp)
ffffffe000200dbc:	00813823          	sd	s0,16(sp)
ffffffe000200dc0:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe000200dc4:	00001637          	lui	a2,0x1
ffffffe000200dc8:	00000593          	li	a1,0
ffffffe000200dcc:	00006517          	auipc	a0,0x6
ffffffe000200dd0:	23450513          	addi	a0,a0,564 # ffffffe000207000 <early_pgtbl>
ffffffe000200dd4:	099010ef          	jal	ra,ffffffe00020266c <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000200dd8:	00f00793          	li	a5,15
ffffffe000200ddc:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000200de0:	fe043423          	sd	zero,-24(s0)
ffffffe000200de4:	0740006f          	j	ffffffe000200e58 <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000200de8:	fe843703          	ld	a4,-24(s0)
ffffffe000200dec:	fff00793          	li	a5,-1
ffffffe000200df0:	02579793          	slli	a5,a5,0x25
ffffffe000200df4:	00f706b3          	add	a3,a4,a5
ffffffe000200df8:	fe843703          	ld	a4,-24(s0)
ffffffe000200dfc:	00100793          	li	a5,1
ffffffe000200e00:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e04:	00f707b3          	add	a5,a4,a5
ffffffe000200e08:	fe043603          	ld	a2,-32(s0)
ffffffe000200e0c:	00078593          	mv	a1,a5
ffffffe000200e10:	00068513          	mv	a0,a3
ffffffe000200e14:	074000ef          	jal	ra,ffffffe000200e88 <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe000200e18:	fe843703          	ld	a4,-24(s0)
ffffffe000200e1c:	00100793          	li	a5,1
ffffffe000200e20:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e24:	00f706b3          	add	a3,a4,a5
ffffffe000200e28:	fe843703          	ld	a4,-24(s0)
ffffffe000200e2c:	00100793          	li	a5,1
ffffffe000200e30:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e34:	00f707b3          	add	a5,a4,a5
ffffffe000200e38:	fe043603          	ld	a2,-32(s0)
ffffffe000200e3c:	00078593          	mv	a1,a5
ffffffe000200e40:	00068513          	mv	a0,a3
ffffffe000200e44:	044000ef          	jal	ra,ffffffe000200e88 <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000200e48:	fe843703          	ld	a4,-24(s0)
ffffffe000200e4c:	400007b7          	lui	a5,0x40000
ffffffe000200e50:	00f707b3          	add	a5,a4,a5
ffffffe000200e54:	fef43423          	sd	a5,-24(s0)
ffffffe000200e58:	fe843703          	ld	a4,-24(s0)
ffffffe000200e5c:	01f00793          	li	a5,31
ffffffe000200e60:	02079793          	slli	a5,a5,0x20
ffffffe000200e64:	f8f762e3          	bltu	a4,a5,ffffffe000200de8 <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe000200e68:	00002517          	auipc	a0,0x2
ffffffe000200e6c:	30850513          	addi	a0,a0,776 # ffffffe000203170 <_srodata+0x170>
ffffffe000200e70:	6dc010ef          	jal	ra,ffffffe00020254c <printk>
    return;
ffffffe000200e74:	00000013          	nop
}
ffffffe000200e78:	01813083          	ld	ra,24(sp)
ffffffe000200e7c:	01013403          	ld	s0,16(sp)
ffffffe000200e80:	02010113          	addi	sp,sp,32
ffffffe000200e84:	00008067          	ret

ffffffe000200e88 <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000200e88:	fc010113          	addi	sp,sp,-64
ffffffe000200e8c:	02813c23          	sd	s0,56(sp)
ffffffe000200e90:	04010413          	addi	s0,sp,64
ffffffe000200e94:	fca43c23          	sd	a0,-40(s0)
ffffffe000200e98:	fcb43823          	sd	a1,-48(s0)
ffffffe000200e9c:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000200ea0:	fd843783          	ld	a5,-40(s0)
ffffffe000200ea4:	01e7d793          	srli	a5,a5,0x1e
ffffffe000200ea8:	1ff7f793          	andi	a5,a5,511
ffffffe000200eac:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000200eb0:	fd043783          	ld	a5,-48(s0)
ffffffe000200eb4:	00c7d793          	srli	a5,a5,0xc
ffffffe000200eb8:	00a79793          	slli	a5,a5,0xa
ffffffe000200ebc:	fc843703          	ld	a4,-56(s0)
ffffffe000200ec0:	00f767b3          	or	a5,a4,a5
ffffffe000200ec4:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000200ec8:	00006717          	auipc	a4,0x6
ffffffe000200ecc:	13870713          	addi	a4,a4,312 # ffffffe000207000 <early_pgtbl>
ffffffe000200ed0:	fe843783          	ld	a5,-24(s0)
ffffffe000200ed4:	00379793          	slli	a5,a5,0x3
ffffffe000200ed8:	00f707b3          	add	a5,a4,a5
ffffffe000200edc:	fe043703          	ld	a4,-32(s0)
ffffffe000200ee0:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe000200ee4:	00000013          	nop
ffffffe000200ee8:	03813403          	ld	s0,56(sp)
ffffffe000200eec:	04010113          	addi	sp,sp,64
ffffffe000200ef0:	00008067          	ret

ffffffe000200ef4 <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe000200ef4:	fc010113          	addi	sp,sp,-64
ffffffe000200ef8:	02113c23          	sd	ra,56(sp)
ffffffe000200efc:	02813823          	sd	s0,48(sp)
ffffffe000200f00:	04010413          	addi	s0,sp,64
ffffffe000200f04:	fca43c23          	sd	a0,-40(s0)
ffffffe000200f08:	fcb43823          	sd	a1,-48(s0)
ffffffe000200f0c:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000200f10:	bc8ff0ef          	jal	ra,ffffffe0002002d8 <kalloc>
ffffffe000200f14:	00050793          	mv	a5,a0
ffffffe000200f18:	00078713          	mv	a4,a5
ffffffe000200f1c:	04100793          	li	a5,65
ffffffe000200f20:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f24:	00f707b3          	add	a5,a4,a5
ffffffe000200f28:	fef43423          	sd	a5,-24(s0)
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000200f2c:	fe843783          	ld	a5,-24(s0)
ffffffe000200f30:	00c7d793          	srli	a5,a5,0xc
ffffffe000200f34:	00a79693          	slli	a3,a5,0xa
ffffffe000200f38:	fd043783          	ld	a5,-48(s0)
ffffffe000200f3c:	00379793          	slli	a5,a5,0x3
ffffffe000200f40:	fd843703          	ld	a4,-40(s0)
ffffffe000200f44:	00f707b3          	add	a5,a4,a5
ffffffe000200f48:	fc843703          	ld	a4,-56(s0)
ffffffe000200f4c:	00e6e733          	or	a4,a3,a4
ffffffe000200f50:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe000200f54:	fd043783          	ld	a5,-48(s0)
ffffffe000200f58:	00379793          	slli	a5,a5,0x3
ffffffe000200f5c:	fd843703          	ld	a4,-40(s0)
ffffffe000200f60:	00f707b3          	add	a5,a4,a5
ffffffe000200f64:	0007b783          	ld	a5,0(a5)
}
ffffffe000200f68:	00078513          	mv	a0,a5
ffffffe000200f6c:	03813083          	ld	ra,56(sp)
ffffffe000200f70:	03013403          	ld	s0,48(sp)
ffffffe000200f74:	04010113          	addi	sp,sp,64
ffffffe000200f78:	00008067          	ret

ffffffe000200f7c <setup_vm_final>:

void setup_vm_final() {
ffffffe000200f7c:	f9010113          	addi	sp,sp,-112
ffffffe000200f80:	06113423          	sd	ra,104(sp)
ffffffe000200f84:	06813023          	sd	s0,96(sp)
ffffffe000200f88:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe000200f8c:	00002517          	auipc	a0,0x2
ffffffe000200f90:	1fc50513          	addi	a0,a0,508 # ffffffe000203188 <_srodata+0x188>
ffffffe000200f94:	5b8010ef          	jal	ra,ffffffe00020254c <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000200f98:	00001637          	lui	a2,0x1
ffffffe000200f9c:	00000593          	li	a1,0
ffffffe000200fa0:	00007517          	auipc	a0,0x7
ffffffe000200fa4:	06050513          	addi	a0,a0,96 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200fa8:	6c4010ef          	jal	ra,ffffffe00020266c <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000200fac:	40100793          	li	a5,1025
ffffffe000200fb0:	01579793          	slli	a5,a5,0x15
ffffffe000200fb4:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000200fb8:	f00017b7          	lui	a5,0xf0001
ffffffe000200fbc:	00979793          	slli	a5,a5,0x9
ffffffe000200fc0:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe000200fc4:	01100793          	li	a5,17
ffffffe000200fc8:	01b79793          	slli	a5,a5,0x1b
ffffffe000200fcc:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000200fd0:	c0100793          	li	a5,-1023
ffffffe000200fd4:	01b79793          	slli	a5,a5,0x1b
ffffffe000200fd8:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000200fdc:	fe043783          	ld	a5,-32(s0)
ffffffe000200fe0:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe000200fe4:	00001717          	auipc	a4,0x1
ffffffe000200fe8:	6f870713          	addi	a4,a4,1784 # ffffffe0002026dc <_etext>
ffffffe000200fec:	000017b7          	lui	a5,0x1
ffffffe000200ff0:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200ff4:	00f70733          	add	a4,a4,a5
ffffffe000200ff8:	fffff7b7          	lui	a5,0xfffff
ffffffe000200ffc:	00f777b3          	and	a5,a4,a5
ffffffe000201000:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe000201004:	fc843703          	ld	a4,-56(s0)
ffffffe000201008:	04100793          	li	a5,65
ffffffe00020100c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201010:	00f70633          	add	a2,a4,a5
ffffffe000201014:	fc043703          	ld	a4,-64(s0)
ffffffe000201018:	fc843783          	ld	a5,-56(s0)
ffffffe00020101c:	40f707b3          	sub	a5,a4,a5
ffffffe000201020:	00b00713          	li	a4,11
ffffffe000201024:	00078693          	mv	a3,a5
ffffffe000201028:	fc843583          	ld	a1,-56(s0)
ffffffe00020102c:	00007517          	auipc	a0,0x7
ffffffe000201030:	fd450513          	addi	a0,a0,-44 # ffffffe000208000 <swapper_pg_dir>
ffffffe000201034:	17c000ef          	jal	ra,ffffffe0002011b0 <create_mapping>
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);
ffffffe000201038:	00b00693          	li	a3,11
ffffffe00020103c:	fc043603          	ld	a2,-64(s0)
ffffffe000201040:	fc843583          	ld	a1,-56(s0)
ffffffe000201044:	00002517          	auipc	a0,0x2
ffffffe000201048:	15c50513          	addi	a0,a0,348 # ffffffe0002031a0 <_srodata+0x1a0>
ffffffe00020104c:	500010ef          	jal	ra,ffffffe00020254c <printk>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe000201050:	fc043783          	ld	a5,-64(s0)
ffffffe000201054:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe000201058:	00002717          	auipc	a4,0x2
ffffffe00020105c:	4b070713          	addi	a4,a4,1200 # ffffffe000203508 <_erodata>
ffffffe000201060:	000017b7          	lui	a5,0x1
ffffffe000201064:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201068:	00f70733          	add	a4,a4,a5
ffffffe00020106c:	fffff7b7          	lui	a5,0xfffff
ffffffe000201070:	00f777b3          	and	a5,a4,a5
ffffffe000201074:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe000201078:	fb843703          	ld	a4,-72(s0)
ffffffe00020107c:	04100793          	li	a5,65
ffffffe000201080:	01f79793          	slli	a5,a5,0x1f
ffffffe000201084:	00f70633          	add	a2,a4,a5
ffffffe000201088:	fb043703          	ld	a4,-80(s0)
ffffffe00020108c:	fb843783          	ld	a5,-72(s0)
ffffffe000201090:	40f707b3          	sub	a5,a4,a5
ffffffe000201094:	00300713          	li	a4,3
ffffffe000201098:	00078693          	mv	a3,a5
ffffffe00020109c:	fb843583          	ld	a1,-72(s0)
ffffffe0002010a0:	00007517          	auipc	a0,0x7
ffffffe0002010a4:	f6050513          	addi	a0,a0,-160 # ffffffe000208000 <swapper_pg_dir>
ffffffe0002010a8:	108000ef          	jal	ra,ffffffe0002011b0 <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);
ffffffe0002010ac:	00300693          	li	a3,3
ffffffe0002010b0:	fb043603          	ld	a2,-80(s0)
ffffffe0002010b4:	fb843583          	ld	a1,-72(s0)
ffffffe0002010b8:	00002517          	auipc	a0,0x2
ffffffe0002010bc:	12050513          	addi	a0,a0,288 # ffffffe0002031d8 <_srodata+0x1d8>
ffffffe0002010c0:	48c010ef          	jal	ra,ffffffe00020254c <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe0002010c4:	fb043783          	ld	a5,-80(s0)
ffffffe0002010c8:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe0002010cc:	fd043783          	ld	a5,-48(s0)
ffffffe0002010d0:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe0002010d4:	fa843703          	ld	a4,-88(s0)
ffffffe0002010d8:	04100793          	li	a5,65
ffffffe0002010dc:	01f79793          	slli	a5,a5,0x1f
ffffffe0002010e0:	00f70633          	add	a2,a4,a5
ffffffe0002010e4:	fa043703          	ld	a4,-96(s0)
ffffffe0002010e8:	fa843783          	ld	a5,-88(s0)
ffffffe0002010ec:	40f707b3          	sub	a5,a4,a5
ffffffe0002010f0:	00700713          	li	a4,7
ffffffe0002010f4:	00078693          	mv	a3,a5
ffffffe0002010f8:	fa843583          	ld	a1,-88(s0)
ffffffe0002010fc:	00007517          	auipc	a0,0x7
ffffffe000201100:	f0450513          	addi	a0,a0,-252 # ffffffe000208000 <swapper_pg_dir>
ffffffe000201104:	0ac000ef          	jal	ra,ffffffe0002011b0 <create_mapping>
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);
ffffffe000201108:	00700693          	li	a3,7
ffffffe00020110c:	fa043603          	ld	a2,-96(s0)
ffffffe000201110:	fa843583          	ld	a1,-88(s0)
ffffffe000201114:	00002517          	auipc	a0,0x2
ffffffe000201118:	0fc50513          	addi	a0,a0,252 # ffffffe000203210 <_srodata+0x210>
ffffffe00020111c:	430010ef          	jal	ra,ffffffe00020254c <printk>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000201120:	00007517          	auipc	a0,0x7
ffffffe000201124:	ee050513          	addi	a0,a0,-288 # ffffffe000208000 <swapper_pg_dir>
ffffffe000201128:	040000ef          	jal	ra,ffffffe000201168 <get_satp>
ffffffe00020112c:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000201130:	f9843783          	ld	a5,-104(s0)
ffffffe000201134:	f8f43823          	sd	a5,-112(s0)
ffffffe000201138:	f9043783          	ld	a5,-112(s0)
ffffffe00020113c:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe000201140:	f9843583          	ld	a1,-104(s0)
ffffffe000201144:	00002517          	auipc	a0,0x2
ffffffe000201148:	0fc50513          	addi	a0,a0,252 # ffffffe000203240 <_srodata+0x240>
ffffffe00020114c:	400010ef          	jal	ra,ffffffe00020254c <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201150:	12000073          	sfence.vma

    // flush icache 
    // asm volatile("fence.i");
    return;
ffffffe000201154:	00000013          	nop
}
ffffffe000201158:	06813083          	ld	ra,104(sp)
ffffffe00020115c:	06013403          	ld	s0,96(sp)
ffffffe000201160:	07010113          	addi	sp,sp,112
ffffffe000201164:	00008067          	ret

ffffffe000201168 <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe000201168:	fd010113          	addi	sp,sp,-48
ffffffe00020116c:	02813423          	sd	s0,40(sp)
ffffffe000201170:	03010413          	addi	s0,sp,48
ffffffe000201174:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe000201178:	fd843703          	ld	a4,-40(s0)
ffffffe00020117c:	04100793          	li	a5,65
ffffffe000201180:	01f79793          	slli	a5,a5,0x1f
ffffffe000201184:	00f707b3          	add	a5,a4,a5
ffffffe000201188:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe00020118c:	fe843783          	ld	a5,-24(s0)
ffffffe000201190:	00c7d713          	srli	a4,a5,0xc
ffffffe000201194:	fff00793          	li	a5,-1
ffffffe000201198:	03f79793          	slli	a5,a5,0x3f
ffffffe00020119c:	00f767b3          	or	a5,a4,a5
}
ffffffe0002011a0:	00078513          	mv	a0,a5
ffffffe0002011a4:	02813403          	ld	s0,40(sp)
ffffffe0002011a8:	03010113          	addi	sp,sp,48
ffffffe0002011ac:	00008067          	ret

ffffffe0002011b0 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe0002011b0:	fb010113          	addi	sp,sp,-80
ffffffe0002011b4:	04113423          	sd	ra,72(sp)
ffffffe0002011b8:	04813023          	sd	s0,64(sp)
ffffffe0002011bc:	05010413          	addi	s0,sp,80
ffffffe0002011c0:	fca43c23          	sd	a0,-40(s0)
ffffffe0002011c4:	fcb43823          	sd	a1,-48(s0)
ffffffe0002011c8:	fcc43423          	sd	a2,-56(s0)
ffffffe0002011cc:	fcd43023          	sd	a3,-64(s0)
ffffffe0002011d0:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe0002011d4:	fc043683          	ld	a3,-64(s0)
ffffffe0002011d8:	fc843603          	ld	a2,-56(s0)
ffffffe0002011dc:	fd043583          	ld	a1,-48(s0)
ffffffe0002011e0:	00002517          	auipc	a0,0x2
ffffffe0002011e4:	07050513          	addi	a0,a0,112 # ffffffe000203250 <_srodata+0x250>
ffffffe0002011e8:	364010ef          	jal	ra,ffffffe00020254c <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe0002011ec:	fd043783          	ld	a5,-48(s0)
ffffffe0002011f0:	fef43423          	sd	a5,-24(s0)
ffffffe0002011f4:	fc843783          	ld	a5,-56(s0)
ffffffe0002011f8:	fef43023          	sd	a5,-32(s0)
ffffffe0002011fc:	0380006f          	j	ffffffe000201234 <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe000201200:	fb843683          	ld	a3,-72(s0)
ffffffe000201204:	fe043603          	ld	a2,-32(s0)
ffffffe000201208:	fe843583          	ld	a1,-24(s0)
ffffffe00020120c:	fd843503          	ld	a0,-40(s0)
ffffffe000201210:	050000ef          	jal	ra,ffffffe000201260 <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe000201214:	fe843703          	ld	a4,-24(s0)
ffffffe000201218:	000017b7          	lui	a5,0x1
ffffffe00020121c:	00f707b3          	add	a5,a4,a5
ffffffe000201220:	fef43423          	sd	a5,-24(s0)
ffffffe000201224:	fe043703          	ld	a4,-32(s0)
ffffffe000201228:	000017b7          	lui	a5,0x1
ffffffe00020122c:	00f707b3          	add	a5,a4,a5
ffffffe000201230:	fef43023          	sd	a5,-32(s0)
ffffffe000201234:	fd043703          	ld	a4,-48(s0)
ffffffe000201238:	fc043783          	ld	a5,-64(s0)
ffffffe00020123c:	00f707b3          	add	a5,a4,a5
ffffffe000201240:	fe843703          	ld	a4,-24(s0)
ffffffe000201244:	faf76ee3          	bltu	a4,a5,ffffffe000201200 <create_mapping+0x50>
   }
}
ffffffe000201248:	00000013          	nop
ffffffe00020124c:	00000013          	nop
ffffffe000201250:	04813083          	ld	ra,72(sp)
ffffffe000201254:	04013403          	ld	s0,64(sp)
ffffffe000201258:	05010113          	addi	sp,sp,80
ffffffe00020125c:	00008067          	ret

ffffffe000201260 <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201260:	f9010113          	addi	sp,sp,-112
ffffffe000201264:	06113423          	sd	ra,104(sp)
ffffffe000201268:	06813023          	sd	s0,96(sp)
ffffffe00020126c:	07010413          	addi	s0,sp,112
ffffffe000201270:	faa43423          	sd	a0,-88(s0)
ffffffe000201274:	fab43023          	sd	a1,-96(s0)
ffffffe000201278:	f8c43c23          	sd	a2,-104(s0)
ffffffe00020127c:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000201280:	fa043783          	ld	a5,-96(s0)
ffffffe000201284:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201288:	1ff7f793          	andi	a5,a5,511
ffffffe00020128c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000201290:	fa043783          	ld	a5,-96(s0)
ffffffe000201294:	0157d793          	srli	a5,a5,0x15
ffffffe000201298:	1ff7f793          	andi	a5,a5,511
ffffffe00020129c:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe0002012a0:	fa043783          	ld	a5,-96(s0)
ffffffe0002012a4:	00c7d793          	srli	a5,a5,0xc
ffffffe0002012a8:	1ff7f793          	andi	a5,a5,511
ffffffe0002012ac:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe0002012b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002012b4:	00379793          	slli	a5,a5,0x3
ffffffe0002012b8:	fa843703          	ld	a4,-88(s0)
ffffffe0002012bc:	00f707b3          	add	a5,a4,a5
ffffffe0002012c0:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe0002012c4:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe0002012c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002012cc:	0017f793          	andi	a5,a5,1
ffffffe0002012d0:	00079c63          	bnez	a5,ffffffe0002012e8 <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe0002012d4:	00100613          	li	a2,1
ffffffe0002012d8:	fd843583          	ld	a1,-40(s0)
ffffffe0002012dc:	fa843503          	ld	a0,-88(s0)
ffffffe0002012e0:	c15ff0ef          	jal	ra,ffffffe000200ef4 <setup_pgtbl>
ffffffe0002012e4:	fea43423          	sd	a0,-24(s0)
    }

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET); // VA
ffffffe0002012e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002012ec:	00a7d793          	srli	a5,a5,0xa
ffffffe0002012f0:	00c79713          	slli	a4,a5,0xc
ffffffe0002012f4:	fbf00793          	li	a5,-65
ffffffe0002012f8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002012fc:	00f707b3          	add	a5,a4,a5
ffffffe000201300:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe000201304:	fd043783          	ld	a5,-48(s0)
ffffffe000201308:	00379793          	slli	a5,a5,0x3
ffffffe00020130c:	fc043703          	ld	a4,-64(s0)
ffffffe000201310:	00f707b3          	add	a5,a4,a5
ffffffe000201314:	0007b783          	ld	a5,0(a5)
ffffffe000201318:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe00020131c:	fe043783          	ld	a5,-32(s0)
ffffffe000201320:	0017f793          	andi	a5,a5,1
ffffffe000201324:	00079c63          	bnez	a5,ffffffe00020133c <map_vm_final+0xdc>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe000201328:	00100613          	li	a2,1
ffffffe00020132c:	fd043583          	ld	a1,-48(s0)
ffffffe000201330:	fc043503          	ld	a0,-64(s0)
ffffffe000201334:	bc1ff0ef          	jal	ra,ffffffe000200ef4 <setup_pgtbl>
ffffffe000201338:	fea43023          	sd	a0,-32(s0)
    }

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);// VA
ffffffe00020133c:	fe043783          	ld	a5,-32(s0)
ffffffe000201340:	00a7d793          	srli	a5,a5,0xa
ffffffe000201344:	00c79713          	slli	a4,a5,0xc
ffffffe000201348:	fbf00793          	li	a5,-65
ffffffe00020134c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201350:	00f707b3          	add	a5,a4,a5
ffffffe000201354:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe000201358:	f9043783          	ld	a5,-112(s0)
ffffffe00020135c:	0017e793          	ori	a5,a5,1
ffffffe000201360:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe000201364:	f9843783          	ld	a5,-104(s0)
ffffffe000201368:	00c7d793          	srli	a5,a5,0xc
ffffffe00020136c:	00a79693          	slli	a3,a5,0xa
ffffffe000201370:	fc843783          	ld	a5,-56(s0)
ffffffe000201374:	00379793          	slli	a5,a5,0x3
ffffffe000201378:	fb843703          	ld	a4,-72(s0)
ffffffe00020137c:	00f707b3          	add	a5,a4,a5
ffffffe000201380:	f9043703          	ld	a4,-112(s0)
ffffffe000201384:	00e6e733          	or	a4,a3,a4
ffffffe000201388:	00e7b023          	sd	a4,0(a5)
ffffffe00020138c:	00000013          	nop
ffffffe000201390:	06813083          	ld	ra,104(sp)
ffffffe000201394:	06013403          	ld	s0,96(sp)
ffffffe000201398:	07010113          	addi	sp,sp,112
ffffffe00020139c:	00008067          	ret

ffffffe0002013a0 <start_kernel>:
#include "printk.h"
#include "defs.h"

extern void test();

int start_kernel() {
ffffffe0002013a0:	ff010113          	addi	sp,sp,-16
ffffffe0002013a4:	00113423          	sd	ra,8(sp)
ffffffe0002013a8:	00813023          	sd	s0,0(sp)
ffffffe0002013ac:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe0002013b0:	00002517          	auipc	a0,0x2
ffffffe0002013b4:	ec850513          	addi	a0,a0,-312 # ffffffe000203278 <_srodata+0x278>
ffffffe0002013b8:	194010ef          	jal	ra,ffffffe00020254c <printk>
    printk(" ZJU Operating System\n");
ffffffe0002013bc:	00002517          	auipc	a0,0x2
ffffffe0002013c0:	ec450513          	addi	a0,a0,-316 # ffffffe000203280 <_srodata+0x280>
ffffffe0002013c4:	188010ef          	jal	ra,ffffffe00020254c <printk>
    // verify_vm();

    test();
ffffffe0002013c8:	2c0000ef          	jal	ra,ffffffe000201688 <test>
    return 0;
ffffffe0002013cc:	00000793          	li	a5,0
}
ffffffe0002013d0:	00078513          	mv	a0,a5
ffffffe0002013d4:	00813083          	ld	ra,8(sp)
ffffffe0002013d8:	00013403          	ld	s0,0(sp)
ffffffe0002013dc:	01010113          	addi	sp,sp,16
ffffffe0002013e0:	00008067          	ret

ffffffe0002013e4 <test_rodata_write>:

void test_rodata_write(uint64_t *addr) {
ffffffe0002013e4:	fd010113          	addi	sp,sp,-48
ffffffe0002013e8:	02113423          	sd	ra,40(sp)
ffffffe0002013ec:	02813023          	sd	s0,32(sp)
ffffffe0002013f0:	03010413          	addi	s0,sp,48
ffffffe0002013f4:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr;
ffffffe0002013f8:	fd843783          	ld	a5,-40(s0)
ffffffe0002013fc:	0007b783          	ld	a5,0(a5)
ffffffe000201400:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000201404:	00100793          	li	a5,1
ffffffe000201408:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe00020140c:	fd843783          	ld	a5,-40(s0)
ffffffe000201410:	00100293          	li	t0,1
ffffffe000201414:	0057b023          	sd	t0,0(a5)
ffffffe000201418:	00000793          	li	a5,0
ffffffe00020141c:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000201420:	fe442783          	lw	a5,-28(s0)
ffffffe000201424:	0007879b          	sext.w	a5,a5
ffffffe000201428:	02078063          	beqz	a5,ffffffe000201448 <test_rodata_write+0x64>
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
ffffffe00020142c:	00002517          	auipc	a0,0x2
ffffffe000201430:	e6c50513          	addi	a0,a0,-404 # ffffffe000203298 <_srodata+0x298>
ffffffe000201434:	118010ef          	jal	ra,ffffffe00020254c <printk>
        *addr = backup; // 恢复原值
ffffffe000201438:	fd843783          	ld	a5,-40(s0)
ffffffe00020143c:	fe843703          	ld	a4,-24(s0)
ffffffe000201440:	00e7b023          	sd	a4,0(a5)
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}
ffffffe000201444:	0100006f          	j	ffffffe000201454 <test_rodata_write+0x70>
        printk("PASS: .rodata write failed as expected.\n");
ffffffe000201448:	00002517          	auipc	a0,0x2
ffffffe00020144c:	e8050513          	addi	a0,a0,-384 # ffffffe0002032c8 <_srodata+0x2c8>
ffffffe000201450:	0fc010ef          	jal	ra,ffffffe00020254c <printk>
}
ffffffe000201454:	00000013          	nop
ffffffe000201458:	02813083          	ld	ra,40(sp)
ffffffe00020145c:	02013403          	ld	s0,32(sp)
ffffffe000201460:	03010113          	addi	sp,sp,48
ffffffe000201464:	00008067          	ret

ffffffe000201468 <test_rodata_exec>:

void test_rodata_exec(uint64_t *addr) {
ffffffe000201468:	fd010113          	addi	sp,sp,-48
ffffffe00020146c:	02113423          	sd	ra,40(sp)
ffffffe000201470:	02813023          	sd	s0,32(sp)
ffffffe000201474:	03010413          	addi	s0,sp,48
ffffffe000201478:	fca43c23          	sd	a0,-40(s0)
    int success = 1;
ffffffe00020147c:	00100793          	li	a5,1
ffffffe000201480:	fef42623          	sw	a5,-20(s0)

    asm volatile(
ffffffe000201484:	fd843783          	ld	a5,-40(s0)
ffffffe000201488:	000780e7          	jalr	a5
ffffffe00020148c:	00000793          	li	a5,0
ffffffe000201490:	fef42623          	sw	a5,-20(s0)
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
ffffffe000201494:	fec42783          	lw	a5,-20(s0)
ffffffe000201498:	0007879b          	sext.w	a5,a5
ffffffe00020149c:	00078a63          	beqz	a5,ffffffe0002014b0 <test_rodata_exec+0x48>
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
ffffffe0002014a0:	00002517          	auipc	a0,0x2
ffffffe0002014a4:	e5850513          	addi	a0,a0,-424 # ffffffe0002032f8 <_srodata+0x2f8>
ffffffe0002014a8:	0a4010ef          	jal	ra,ffffffe00020254c <printk>
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}
ffffffe0002014ac:	0100006f          	j	ffffffe0002014bc <test_rodata_exec+0x54>
        printk("PASS: .rodata execute failed as expected.\n");
ffffffe0002014b0:	00002517          	auipc	a0,0x2
ffffffe0002014b4:	e7850513          	addi	a0,a0,-392 # ffffffe000203328 <_srodata+0x328>
ffffffe0002014b8:	094010ef          	jal	ra,ffffffe00020254c <printk>
}
ffffffe0002014bc:	00000013          	nop
ffffffe0002014c0:	02813083          	ld	ra,40(sp)
ffffffe0002014c4:	02013403          	ld	s0,32(sp)
ffffffe0002014c8:	03010113          	addi	sp,sp,48
ffffffe0002014cc:	00008067          	ret

ffffffe0002014d0 <test_text_read>:

void test_text_read(uint64_t *addr) {
ffffffe0002014d0:	fd010113          	addi	sp,sp,-48
ffffffe0002014d4:	02113423          	sd	ra,40(sp)
ffffffe0002014d8:	02813023          	sd	s0,32(sp)
ffffffe0002014dc:	03010413          	addi	s0,sp,48
ffffffe0002014e0:	fca43c23          	sd	a0,-40(s0)
    printk(".text read test: ");
ffffffe0002014e4:	00002517          	auipc	a0,0x2
ffffffe0002014e8:	e7450513          	addi	a0,a0,-396 # ffffffe000203358 <_srodata+0x358>
ffffffe0002014ec:	060010ef          	jal	ra,ffffffe00020254c <printk>
    uint64_t value = *addr;
ffffffe0002014f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002014f4:	0007b783          	ld	a5,0(a5)
ffffffe0002014f8:	fef43423          	sd	a5,-24(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe0002014fc:	fe843583          	ld	a1,-24(s0)
ffffffe000201500:	00002517          	auipc	a0,0x2
ffffffe000201504:	e7050513          	addi	a0,a0,-400 # ffffffe000203370 <_srodata+0x370>
ffffffe000201508:	044010ef          	jal	ra,ffffffe00020254c <printk>
}
ffffffe00020150c:	00000013          	nop
ffffffe000201510:	02813083          	ld	ra,40(sp)
ffffffe000201514:	02013403          	ld	s0,32(sp)
ffffffe000201518:	03010113          	addi	sp,sp,48
ffffffe00020151c:	00008067          	ret

ffffffe000201520 <test_text_write>:

void test_text_write(uint64_t *addr) {
ffffffe000201520:	fd010113          	addi	sp,sp,-48
ffffffe000201524:	02113423          	sd	ra,40(sp)
ffffffe000201528:	02813023          	sd	s0,32(sp)
ffffffe00020152c:	03010413          	addi	s0,sp,48
ffffffe000201530:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr; // 备份原始值
ffffffe000201534:	fd843783          	ld	a5,-40(s0)
ffffffe000201538:	0007b783          	ld	a5,0(a5)
ffffffe00020153c:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe000201540:	00100793          	li	a5,1
ffffffe000201544:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000201548:	fd843783          	ld	a5,-40(s0)
ffffffe00020154c:	00100293          	li	t0,1
ffffffe000201550:	0057b023          	sd	t0,0(a5)
ffffffe000201554:	00000793          	li	a5,0
ffffffe000201558:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe00020155c:	fe442783          	lw	a5,-28(s0)
ffffffe000201560:	0007879b          	sext.w	a5,a5
ffffffe000201564:	00078a63          	beqz	a5,ffffffe000201578 <test_text_write+0x58>
        printk("PASS: .text write failed as expected.\n");
ffffffe000201568:	00002517          	auipc	a0,0x2
ffffffe00020156c:	e3050513          	addi	a0,a0,-464 # ffffffe000203398 <_srodata+0x398>
ffffffe000201570:	7dd000ef          	jal	ra,ffffffe00020254c <printk>
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}
ffffffe000201574:	01c0006f          	j	ffffffe000201590 <test_text_write+0x70>
        printk("ERROR: .text write succeeded unexpectedly!\n");
ffffffe000201578:	00002517          	auipc	a0,0x2
ffffffe00020157c:	e4850513          	addi	a0,a0,-440 # ffffffe0002033c0 <_srodata+0x3c0>
ffffffe000201580:	7cd000ef          	jal	ra,ffffffe00020254c <printk>
        *addr = backup; // 恢复原始值，避免破坏代码段
ffffffe000201584:	fd843783          	ld	a5,-40(s0)
ffffffe000201588:	fe843703          	ld	a4,-24(s0)
ffffffe00020158c:	00e7b023          	sd	a4,0(a5)
}
ffffffe000201590:	00000013          	nop
ffffffe000201594:	02813083          	ld	ra,40(sp)
ffffffe000201598:	02013403          	ld	s0,32(sp)
ffffffe00020159c:	03010113          	addi	sp,sp,48
ffffffe0002015a0:	00008067          	ret

ffffffe0002015a4 <test_text_exec>:

void test_text_exec() {
ffffffe0002015a4:	ff010113          	addi	sp,sp,-16
ffffffe0002015a8:	00113423          	sd	ra,8(sp)
ffffffe0002015ac:	00813023          	sd	s0,0(sp)
ffffffe0002015b0:	01010413          	addi	s0,sp,16
    printk("Executing .text segment test: ");
ffffffe0002015b4:	00002517          	auipc	a0,0x2
ffffffe0002015b8:	e3c50513          	addi	a0,a0,-452 # ffffffe0002033f0 <_srodata+0x3f0>
ffffffe0002015bc:	791000ef          	jal	ra,ffffffe00020254c <printk>
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
ffffffe0002015c0:	00002517          	auipc	a0,0x2
ffffffe0002015c4:	e5050513          	addi	a0,a0,-432 # ffffffe000203410 <_srodata+0x410>
ffffffe0002015c8:	785000ef          	jal	ra,ffffffe00020254c <printk>
}
ffffffe0002015cc:	00000013          	nop
ffffffe0002015d0:	00813083          	ld	ra,8(sp)
ffffffe0002015d4:	00013403          	ld	s0,0(sp)
ffffffe0002015d8:	01010113          	addi	sp,sp,16
ffffffe0002015dc:	00008067          	ret

ffffffe0002015e0 <verify_vm>:

void verify_vm() {
ffffffe0002015e0:	fd010113          	addi	sp,sp,-48
ffffffe0002015e4:	02113423          	sd	ra,40(sp)
ffffffe0002015e8:	02813023          	sd	s0,32(sp)
ffffffe0002015ec:	03010413          	addi	s0,sp,48
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
ffffffe0002015f0:	f00017b7          	lui	a5,0xf0001
ffffffe0002015f4:	00979793          	slli	a5,a5,0x9
ffffffe0002015f8:	fef43423          	sd	a5,-24(s0)
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段
ffffffe0002015fc:	fe0007b7          	lui	a5,0xfe000
ffffffe000201600:	20378793          	addi	a5,a5,515 # fffffffffe000203 <VM_END+0xfe000203>
ffffffe000201604:	00c79793          	slli	a5,a5,0xc
ffffffe000201608:	fef43023          	sd	a5,-32(s0)

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;
ffffffe00020160c:	fe843783          	ld	a5,-24(s0)
ffffffe000201610:	fcf43c23          	sd	a5,-40(s0)

    // .text R
    printk(".text read test: \n");
ffffffe000201614:	00002517          	auipc	a0,0x2
ffffffe000201618:	e1c50513          	addi	a0,a0,-484 # ffffffe000203430 <_srodata+0x430>
ffffffe00020161c:	731000ef          	jal	ra,ffffffe00020254c <printk>
    test_text_read(test_addr);
ffffffe000201620:	fd843503          	ld	a0,-40(s0)
ffffffe000201624:	eadff0ef          	jal	ra,ffffffe0002014d0 <test_text_read>
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
ffffffe000201628:	00002517          	auipc	a0,0x2
ffffffe00020162c:	e2050513          	addi	a0,a0,-480 # ffffffe000203448 <_srodata+0x448>
ffffffe000201630:	71d000ef          	jal	ra,ffffffe00020254c <printk>
    test_text_exec();
ffffffe000201634:	f71ff0ef          	jal	ra,ffffffe0002015a4 <test_text_exec>

    // .rodata
    test_addr = (uint64_t *)va_rodata;
ffffffe000201638:	fe043783          	ld	a5,-32(s0)
ffffffe00020163c:	fcf43c23          	sd	a5,-40(s0)

    // .rodata R
    printk(".rodata read test: \n");
ffffffe000201640:	00002517          	auipc	a0,0x2
ffffffe000201644:	e2050513          	addi	a0,a0,-480 # ffffffe000203460 <_srodata+0x460>
ffffffe000201648:	705000ef          	jal	ra,ffffffe00020254c <printk>
    uint64_t value = *test_addr;
ffffffe00020164c:	fd843783          	ld	a5,-40(s0)
ffffffe000201650:	0007b783          	ld	a5,0(a5)
ffffffe000201654:	fcf43823          	sd	a5,-48(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe000201658:	fd043583          	ld	a1,-48(s0)
ffffffe00020165c:	00002517          	auipc	a0,0x2
ffffffe000201660:	d1450513          	addi	a0,a0,-748 # ffffffe000203370 <_srodata+0x370>
ffffffe000201664:	6e9000ef          	jal	ra,ffffffe00020254c <printk>

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
ffffffe000201668:	00002517          	auipc	a0,0x2
ffffffe00020166c:	e1050513          	addi	a0,a0,-496 # ffffffe000203478 <_srodata+0x478>
ffffffe000201670:	6dd000ef          	jal	ra,ffffffe00020254c <printk>
ffffffe000201674:	00000013          	nop
ffffffe000201678:	02813083          	ld	ra,40(sp)
ffffffe00020167c:	02013403          	ld	s0,32(sp)
ffffffe000201680:	03010113          	addi	sp,sp,48
ffffffe000201684:	00008067          	ret

ffffffe000201688 <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe000201688:	fe010113          	addi	sp,sp,-32
ffffffe00020168c:	00113c23          	sd	ra,24(sp)
ffffffe000201690:	00813823          	sd	s0,16(sp)
ffffffe000201694:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000201698:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe00020169c:	00002517          	auipc	a0,0x2
ffffffe0002016a0:	dfc50513          	addi	a0,a0,-516 # ffffffe000203498 <_srodata+0x498>
ffffffe0002016a4:	6a9000ef          	jal	ra,ffffffe00020254c <printk>
    while (1)
    {
        i++;
ffffffe0002016a8:	fec42783          	lw	a5,-20(s0)
ffffffe0002016ac:	0017879b          	addiw	a5,a5,1
ffffffe0002016b0:	fef42623          	sw	a5,-20(s0)
ffffffe0002016b4:	ff5ff06f          	j	ffffffe0002016a8 <test+0x20>

ffffffe0002016b8 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe0002016b8:	fe010113          	addi	sp,sp,-32
ffffffe0002016bc:	00113c23          	sd	ra,24(sp)
ffffffe0002016c0:	00813823          	sd	s0,16(sp)
ffffffe0002016c4:	02010413          	addi	s0,sp,32
ffffffe0002016c8:	00050793          	mv	a5,a0
ffffffe0002016cc:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe0002016d0:	fec42783          	lw	a5,-20(s0)
ffffffe0002016d4:	0ff7f793          	zext.b	a5,a5
ffffffe0002016d8:	00078513          	mv	a0,a5
ffffffe0002016dc:	d64ff0ef          	jal	ra,ffffffe000200c40 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe0002016e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002016e4:	0ff7f793          	zext.b	a5,a5
ffffffe0002016e8:	0007879b          	sext.w	a5,a5
}
ffffffe0002016ec:	00078513          	mv	a0,a5
ffffffe0002016f0:	01813083          	ld	ra,24(sp)
ffffffe0002016f4:	01013403          	ld	s0,16(sp)
ffffffe0002016f8:	02010113          	addi	sp,sp,32
ffffffe0002016fc:	00008067          	ret

ffffffe000201700 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe000201700:	fe010113          	addi	sp,sp,-32
ffffffe000201704:	00813c23          	sd	s0,24(sp)
ffffffe000201708:	02010413          	addi	s0,sp,32
ffffffe00020170c:	00050793          	mv	a5,a0
ffffffe000201710:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000201714:	fec42783          	lw	a5,-20(s0)
ffffffe000201718:	0007871b          	sext.w	a4,a5
ffffffe00020171c:	02000793          	li	a5,32
ffffffe000201720:	02f70263          	beq	a4,a5,ffffffe000201744 <isspace+0x44>
ffffffe000201724:	fec42783          	lw	a5,-20(s0)
ffffffe000201728:	0007871b          	sext.w	a4,a5
ffffffe00020172c:	00800793          	li	a5,8
ffffffe000201730:	00e7de63          	bge	a5,a4,ffffffe00020174c <isspace+0x4c>
ffffffe000201734:	fec42783          	lw	a5,-20(s0)
ffffffe000201738:	0007871b          	sext.w	a4,a5
ffffffe00020173c:	00d00793          	li	a5,13
ffffffe000201740:	00e7c663          	blt	a5,a4,ffffffe00020174c <isspace+0x4c>
ffffffe000201744:	00100793          	li	a5,1
ffffffe000201748:	0080006f          	j	ffffffe000201750 <isspace+0x50>
ffffffe00020174c:	00000793          	li	a5,0
}
ffffffe000201750:	00078513          	mv	a0,a5
ffffffe000201754:	01813403          	ld	s0,24(sp)
ffffffe000201758:	02010113          	addi	sp,sp,32
ffffffe00020175c:	00008067          	ret

ffffffe000201760 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000201760:	fb010113          	addi	sp,sp,-80
ffffffe000201764:	04113423          	sd	ra,72(sp)
ffffffe000201768:	04813023          	sd	s0,64(sp)
ffffffe00020176c:	05010413          	addi	s0,sp,80
ffffffe000201770:	fca43423          	sd	a0,-56(s0)
ffffffe000201774:	fcb43023          	sd	a1,-64(s0)
ffffffe000201778:	00060793          	mv	a5,a2
ffffffe00020177c:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000201780:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000201784:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000201788:	fc843783          	ld	a5,-56(s0)
ffffffe00020178c:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000201790:	0100006f          	j	ffffffe0002017a0 <strtol+0x40>
        p++;
ffffffe000201794:	fd843783          	ld	a5,-40(s0)
ffffffe000201798:	00178793          	addi	a5,a5,1
ffffffe00020179c:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe0002017a0:	fd843783          	ld	a5,-40(s0)
ffffffe0002017a4:	0007c783          	lbu	a5,0(a5)
ffffffe0002017a8:	0007879b          	sext.w	a5,a5
ffffffe0002017ac:	00078513          	mv	a0,a5
ffffffe0002017b0:	f51ff0ef          	jal	ra,ffffffe000201700 <isspace>
ffffffe0002017b4:	00050793          	mv	a5,a0
ffffffe0002017b8:	fc079ee3          	bnez	a5,ffffffe000201794 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe0002017bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002017c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002017c4:	00078713          	mv	a4,a5
ffffffe0002017c8:	02d00793          	li	a5,45
ffffffe0002017cc:	00f71e63          	bne	a4,a5,ffffffe0002017e8 <strtol+0x88>
        neg = true;
ffffffe0002017d0:	00100793          	li	a5,1
ffffffe0002017d4:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002017d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002017dc:	00178793          	addi	a5,a5,1
ffffffe0002017e0:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002017e4:	0240006f          	j	ffffffe000201808 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe0002017e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002017ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002017f0:	00078713          	mv	a4,a5
ffffffe0002017f4:	02b00793          	li	a5,43
ffffffe0002017f8:	00f71863          	bne	a4,a5,ffffffe000201808 <strtol+0xa8>
        p++;
ffffffe0002017fc:	fd843783          	ld	a5,-40(s0)
ffffffe000201800:	00178793          	addi	a5,a5,1
ffffffe000201804:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe000201808:	fbc42783          	lw	a5,-68(s0)
ffffffe00020180c:	0007879b          	sext.w	a5,a5
ffffffe000201810:	06079c63          	bnez	a5,ffffffe000201888 <strtol+0x128>
        if (*p == '0') {
ffffffe000201814:	fd843783          	ld	a5,-40(s0)
ffffffe000201818:	0007c783          	lbu	a5,0(a5)
ffffffe00020181c:	00078713          	mv	a4,a5
ffffffe000201820:	03000793          	li	a5,48
ffffffe000201824:	04f71e63          	bne	a4,a5,ffffffe000201880 <strtol+0x120>
            p++;
ffffffe000201828:	fd843783          	ld	a5,-40(s0)
ffffffe00020182c:	00178793          	addi	a5,a5,1
ffffffe000201830:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000201834:	fd843783          	ld	a5,-40(s0)
ffffffe000201838:	0007c783          	lbu	a5,0(a5)
ffffffe00020183c:	00078713          	mv	a4,a5
ffffffe000201840:	07800793          	li	a5,120
ffffffe000201844:	00f70c63          	beq	a4,a5,ffffffe00020185c <strtol+0xfc>
ffffffe000201848:	fd843783          	ld	a5,-40(s0)
ffffffe00020184c:	0007c783          	lbu	a5,0(a5)
ffffffe000201850:	00078713          	mv	a4,a5
ffffffe000201854:	05800793          	li	a5,88
ffffffe000201858:	00f71e63          	bne	a4,a5,ffffffe000201874 <strtol+0x114>
                base = 16;
ffffffe00020185c:	01000793          	li	a5,16
ffffffe000201860:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000201864:	fd843783          	ld	a5,-40(s0)
ffffffe000201868:	00178793          	addi	a5,a5,1
ffffffe00020186c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201870:	0180006f          	j	ffffffe000201888 <strtol+0x128>
            } else {
                base = 8;
ffffffe000201874:	00800793          	li	a5,8
ffffffe000201878:	faf42e23          	sw	a5,-68(s0)
ffffffe00020187c:	00c0006f          	j	ffffffe000201888 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000201880:	00a00793          	li	a5,10
ffffffe000201884:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000201888:	fd843783          	ld	a5,-40(s0)
ffffffe00020188c:	0007c783          	lbu	a5,0(a5)
ffffffe000201890:	00078713          	mv	a4,a5
ffffffe000201894:	02f00793          	li	a5,47
ffffffe000201898:	02e7f863          	bgeu	a5,a4,ffffffe0002018c8 <strtol+0x168>
ffffffe00020189c:	fd843783          	ld	a5,-40(s0)
ffffffe0002018a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002018a4:	00078713          	mv	a4,a5
ffffffe0002018a8:	03900793          	li	a5,57
ffffffe0002018ac:	00e7ee63          	bltu	a5,a4,ffffffe0002018c8 <strtol+0x168>
            digit = *p - '0';
ffffffe0002018b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002018b4:	0007c783          	lbu	a5,0(a5)
ffffffe0002018b8:	0007879b          	sext.w	a5,a5
ffffffe0002018bc:	fd07879b          	addiw	a5,a5,-48
ffffffe0002018c0:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002018c4:	0800006f          	j	ffffffe000201944 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe0002018c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002018cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002018d0:	00078713          	mv	a4,a5
ffffffe0002018d4:	06000793          	li	a5,96
ffffffe0002018d8:	02e7f863          	bgeu	a5,a4,ffffffe000201908 <strtol+0x1a8>
ffffffe0002018dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002018e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002018e4:	00078713          	mv	a4,a5
ffffffe0002018e8:	07a00793          	li	a5,122
ffffffe0002018ec:	00e7ee63          	bltu	a5,a4,ffffffe000201908 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe0002018f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002018f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002018f8:	0007879b          	sext.w	a5,a5
ffffffe0002018fc:	fa97879b          	addiw	a5,a5,-87
ffffffe000201900:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201904:	0400006f          	j	ffffffe000201944 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe000201908:	fd843783          	ld	a5,-40(s0)
ffffffe00020190c:	0007c783          	lbu	a5,0(a5)
ffffffe000201910:	00078713          	mv	a4,a5
ffffffe000201914:	04000793          	li	a5,64
ffffffe000201918:	06e7f863          	bgeu	a5,a4,ffffffe000201988 <strtol+0x228>
ffffffe00020191c:	fd843783          	ld	a5,-40(s0)
ffffffe000201920:	0007c783          	lbu	a5,0(a5)
ffffffe000201924:	00078713          	mv	a4,a5
ffffffe000201928:	05a00793          	li	a5,90
ffffffe00020192c:	04e7ee63          	bltu	a5,a4,ffffffe000201988 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000201930:	fd843783          	ld	a5,-40(s0)
ffffffe000201934:	0007c783          	lbu	a5,0(a5)
ffffffe000201938:	0007879b          	sext.w	a5,a5
ffffffe00020193c:	fc97879b          	addiw	a5,a5,-55
ffffffe000201940:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000201944:	fd442783          	lw	a5,-44(s0)
ffffffe000201948:	00078713          	mv	a4,a5
ffffffe00020194c:	fbc42783          	lw	a5,-68(s0)
ffffffe000201950:	0007071b          	sext.w	a4,a4
ffffffe000201954:	0007879b          	sext.w	a5,a5
ffffffe000201958:	02f75663          	bge	a4,a5,ffffffe000201984 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe00020195c:	fbc42703          	lw	a4,-68(s0)
ffffffe000201960:	fe843783          	ld	a5,-24(s0)
ffffffe000201964:	02f70733          	mul	a4,a4,a5
ffffffe000201968:	fd442783          	lw	a5,-44(s0)
ffffffe00020196c:	00f707b3          	add	a5,a4,a5
ffffffe000201970:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000201974:	fd843783          	ld	a5,-40(s0)
ffffffe000201978:	00178793          	addi	a5,a5,1
ffffffe00020197c:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000201980:	f09ff06f          	j	ffffffe000201888 <strtol+0x128>
            break;
ffffffe000201984:	00000013          	nop
    }

    if (endptr) {
ffffffe000201988:	fc043783          	ld	a5,-64(s0)
ffffffe00020198c:	00078863          	beqz	a5,ffffffe00020199c <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000201990:	fc043783          	ld	a5,-64(s0)
ffffffe000201994:	fd843703          	ld	a4,-40(s0)
ffffffe000201998:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe00020199c:	fe744783          	lbu	a5,-25(s0)
ffffffe0002019a0:	0ff7f793          	zext.b	a5,a5
ffffffe0002019a4:	00078863          	beqz	a5,ffffffe0002019b4 <strtol+0x254>
ffffffe0002019a8:	fe843783          	ld	a5,-24(s0)
ffffffe0002019ac:	40f007b3          	neg	a5,a5
ffffffe0002019b0:	0080006f          	j	ffffffe0002019b8 <strtol+0x258>
ffffffe0002019b4:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002019b8:	00078513          	mv	a0,a5
ffffffe0002019bc:	04813083          	ld	ra,72(sp)
ffffffe0002019c0:	04013403          	ld	s0,64(sp)
ffffffe0002019c4:	05010113          	addi	sp,sp,80
ffffffe0002019c8:	00008067          	ret

ffffffe0002019cc <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe0002019cc:	fd010113          	addi	sp,sp,-48
ffffffe0002019d0:	02113423          	sd	ra,40(sp)
ffffffe0002019d4:	02813023          	sd	s0,32(sp)
ffffffe0002019d8:	03010413          	addi	s0,sp,48
ffffffe0002019dc:	fca43c23          	sd	a0,-40(s0)
ffffffe0002019e0:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe0002019e4:	fd043783          	ld	a5,-48(s0)
ffffffe0002019e8:	00079863          	bnez	a5,ffffffe0002019f8 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002019ec:	00002797          	auipc	a5,0x2
ffffffe0002019f0:	ac478793          	addi	a5,a5,-1340 # ffffffe0002034b0 <_srodata+0x4b0>
ffffffe0002019f4:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002019f8:	fd043783          	ld	a5,-48(s0)
ffffffe0002019fc:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe000201a00:	0240006f          	j	ffffffe000201a24 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe000201a04:	fe843783          	ld	a5,-24(s0)
ffffffe000201a08:	00178713          	addi	a4,a5,1
ffffffe000201a0c:	fee43423          	sd	a4,-24(s0)
ffffffe000201a10:	0007c783          	lbu	a5,0(a5)
ffffffe000201a14:	0007871b          	sext.w	a4,a5
ffffffe000201a18:	fd843783          	ld	a5,-40(s0)
ffffffe000201a1c:	00070513          	mv	a0,a4
ffffffe000201a20:	000780e7          	jalr	a5
    while (*p) {
ffffffe000201a24:	fe843783          	ld	a5,-24(s0)
ffffffe000201a28:	0007c783          	lbu	a5,0(a5)
ffffffe000201a2c:	fc079ce3          	bnez	a5,ffffffe000201a04 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000201a30:	fe843703          	ld	a4,-24(s0)
ffffffe000201a34:	fd043783          	ld	a5,-48(s0)
ffffffe000201a38:	40f707b3          	sub	a5,a4,a5
ffffffe000201a3c:	0007879b          	sext.w	a5,a5
}
ffffffe000201a40:	00078513          	mv	a0,a5
ffffffe000201a44:	02813083          	ld	ra,40(sp)
ffffffe000201a48:	02013403          	ld	s0,32(sp)
ffffffe000201a4c:	03010113          	addi	sp,sp,48
ffffffe000201a50:	00008067          	ret

ffffffe000201a54 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000201a54:	f9010113          	addi	sp,sp,-112
ffffffe000201a58:	06113423          	sd	ra,104(sp)
ffffffe000201a5c:	06813023          	sd	s0,96(sp)
ffffffe000201a60:	07010413          	addi	s0,sp,112
ffffffe000201a64:	faa43423          	sd	a0,-88(s0)
ffffffe000201a68:	fab43023          	sd	a1,-96(s0)
ffffffe000201a6c:	00060793          	mv	a5,a2
ffffffe000201a70:	f8d43823          	sd	a3,-112(s0)
ffffffe000201a74:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000201a78:	f9f44783          	lbu	a5,-97(s0)
ffffffe000201a7c:	0ff7f793          	zext.b	a5,a5
ffffffe000201a80:	02078663          	beqz	a5,ffffffe000201aac <print_dec_int+0x58>
ffffffe000201a84:	fa043703          	ld	a4,-96(s0)
ffffffe000201a88:	fff00793          	li	a5,-1
ffffffe000201a8c:	03f79793          	slli	a5,a5,0x3f
ffffffe000201a90:	00f71e63          	bne	a4,a5,ffffffe000201aac <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000201a94:	00002597          	auipc	a1,0x2
ffffffe000201a98:	a2458593          	addi	a1,a1,-1500 # ffffffe0002034b8 <_srodata+0x4b8>
ffffffe000201a9c:	fa843503          	ld	a0,-88(s0)
ffffffe000201aa0:	f2dff0ef          	jal	ra,ffffffe0002019cc <puts_wo_nl>
ffffffe000201aa4:	00050793          	mv	a5,a0
ffffffe000201aa8:	2a00006f          	j	ffffffe000201d48 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000201aac:	f9043783          	ld	a5,-112(s0)
ffffffe000201ab0:	00c7a783          	lw	a5,12(a5)
ffffffe000201ab4:	00079a63          	bnez	a5,ffffffe000201ac8 <print_dec_int+0x74>
ffffffe000201ab8:	fa043783          	ld	a5,-96(s0)
ffffffe000201abc:	00079663          	bnez	a5,ffffffe000201ac8 <print_dec_int+0x74>
        return 0;
ffffffe000201ac0:	00000793          	li	a5,0
ffffffe000201ac4:	2840006f          	j	ffffffe000201d48 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe000201ac8:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000201acc:	f9f44783          	lbu	a5,-97(s0)
ffffffe000201ad0:	0ff7f793          	zext.b	a5,a5
ffffffe000201ad4:	02078063          	beqz	a5,ffffffe000201af4 <print_dec_int+0xa0>
ffffffe000201ad8:	fa043783          	ld	a5,-96(s0)
ffffffe000201adc:	0007dc63          	bgez	a5,ffffffe000201af4 <print_dec_int+0xa0>
        neg = true;
ffffffe000201ae0:	00100793          	li	a5,1
ffffffe000201ae4:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000201ae8:	fa043783          	ld	a5,-96(s0)
ffffffe000201aec:	40f007b3          	neg	a5,a5
ffffffe000201af0:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000201af4:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe000201af8:	f9f44783          	lbu	a5,-97(s0)
ffffffe000201afc:	0ff7f793          	zext.b	a5,a5
ffffffe000201b00:	02078863          	beqz	a5,ffffffe000201b30 <print_dec_int+0xdc>
ffffffe000201b04:	fef44783          	lbu	a5,-17(s0)
ffffffe000201b08:	0ff7f793          	zext.b	a5,a5
ffffffe000201b0c:	00079e63          	bnez	a5,ffffffe000201b28 <print_dec_int+0xd4>
ffffffe000201b10:	f9043783          	ld	a5,-112(s0)
ffffffe000201b14:	0057c783          	lbu	a5,5(a5)
ffffffe000201b18:	00079863          	bnez	a5,ffffffe000201b28 <print_dec_int+0xd4>
ffffffe000201b1c:	f9043783          	ld	a5,-112(s0)
ffffffe000201b20:	0047c783          	lbu	a5,4(a5)
ffffffe000201b24:	00078663          	beqz	a5,ffffffe000201b30 <print_dec_int+0xdc>
ffffffe000201b28:	00100793          	li	a5,1
ffffffe000201b2c:	0080006f          	j	ffffffe000201b34 <print_dec_int+0xe0>
ffffffe000201b30:	00000793          	li	a5,0
ffffffe000201b34:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000201b38:	fd744783          	lbu	a5,-41(s0)
ffffffe000201b3c:	0017f793          	andi	a5,a5,1
ffffffe000201b40:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000201b44:	fa043703          	ld	a4,-96(s0)
ffffffe000201b48:	00a00793          	li	a5,10
ffffffe000201b4c:	02f777b3          	remu	a5,a4,a5
ffffffe000201b50:	0ff7f713          	zext.b	a4,a5
ffffffe000201b54:	fe842783          	lw	a5,-24(s0)
ffffffe000201b58:	0017869b          	addiw	a3,a5,1
ffffffe000201b5c:	fed42423          	sw	a3,-24(s0)
ffffffe000201b60:	0307071b          	addiw	a4,a4,48
ffffffe000201b64:	0ff77713          	zext.b	a4,a4
ffffffe000201b68:	ff078793          	addi	a5,a5,-16
ffffffe000201b6c:	008787b3          	add	a5,a5,s0
ffffffe000201b70:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000201b74:	fa043703          	ld	a4,-96(s0)
ffffffe000201b78:	00a00793          	li	a5,10
ffffffe000201b7c:	02f757b3          	divu	a5,a4,a5
ffffffe000201b80:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000201b84:	fa043783          	ld	a5,-96(s0)
ffffffe000201b88:	fa079ee3          	bnez	a5,ffffffe000201b44 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000201b8c:	f9043783          	ld	a5,-112(s0)
ffffffe000201b90:	00c7a783          	lw	a5,12(a5)
ffffffe000201b94:	00078713          	mv	a4,a5
ffffffe000201b98:	fff00793          	li	a5,-1
ffffffe000201b9c:	02f71063          	bne	a4,a5,ffffffe000201bbc <print_dec_int+0x168>
ffffffe000201ba0:	f9043783          	ld	a5,-112(s0)
ffffffe000201ba4:	0037c783          	lbu	a5,3(a5)
ffffffe000201ba8:	00078a63          	beqz	a5,ffffffe000201bbc <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000201bac:	f9043783          	ld	a5,-112(s0)
ffffffe000201bb0:	0087a703          	lw	a4,8(a5)
ffffffe000201bb4:	f9043783          	ld	a5,-112(s0)
ffffffe000201bb8:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000201bbc:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000201bc0:	f9043783          	ld	a5,-112(s0)
ffffffe000201bc4:	0087a703          	lw	a4,8(a5)
ffffffe000201bc8:	fe842783          	lw	a5,-24(s0)
ffffffe000201bcc:	fcf42823          	sw	a5,-48(s0)
ffffffe000201bd0:	f9043783          	ld	a5,-112(s0)
ffffffe000201bd4:	00c7a783          	lw	a5,12(a5)
ffffffe000201bd8:	fcf42623          	sw	a5,-52(s0)
ffffffe000201bdc:	fd042783          	lw	a5,-48(s0)
ffffffe000201be0:	00078593          	mv	a1,a5
ffffffe000201be4:	fcc42783          	lw	a5,-52(s0)
ffffffe000201be8:	00078613          	mv	a2,a5
ffffffe000201bec:	0006069b          	sext.w	a3,a2
ffffffe000201bf0:	0005879b          	sext.w	a5,a1
ffffffe000201bf4:	00f6d463          	bge	a3,a5,ffffffe000201bfc <print_dec_int+0x1a8>
ffffffe000201bf8:	00058613          	mv	a2,a1
ffffffe000201bfc:	0006079b          	sext.w	a5,a2
ffffffe000201c00:	40f707bb          	subw	a5,a4,a5
ffffffe000201c04:	0007871b          	sext.w	a4,a5
ffffffe000201c08:	fd744783          	lbu	a5,-41(s0)
ffffffe000201c0c:	0007879b          	sext.w	a5,a5
ffffffe000201c10:	40f707bb          	subw	a5,a4,a5
ffffffe000201c14:	fef42023          	sw	a5,-32(s0)
ffffffe000201c18:	0280006f          	j	ffffffe000201c40 <print_dec_int+0x1ec>
        putch(' ');
ffffffe000201c1c:	fa843783          	ld	a5,-88(s0)
ffffffe000201c20:	02000513          	li	a0,32
ffffffe000201c24:	000780e7          	jalr	a5
        ++written;
ffffffe000201c28:	fe442783          	lw	a5,-28(s0)
ffffffe000201c2c:	0017879b          	addiw	a5,a5,1
ffffffe000201c30:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000201c34:	fe042783          	lw	a5,-32(s0)
ffffffe000201c38:	fff7879b          	addiw	a5,a5,-1
ffffffe000201c3c:	fef42023          	sw	a5,-32(s0)
ffffffe000201c40:	fe042783          	lw	a5,-32(s0)
ffffffe000201c44:	0007879b          	sext.w	a5,a5
ffffffe000201c48:	fcf04ae3          	bgtz	a5,ffffffe000201c1c <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000201c4c:	fd744783          	lbu	a5,-41(s0)
ffffffe000201c50:	0ff7f793          	zext.b	a5,a5
ffffffe000201c54:	04078463          	beqz	a5,ffffffe000201c9c <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000201c58:	fef44783          	lbu	a5,-17(s0)
ffffffe000201c5c:	0ff7f793          	zext.b	a5,a5
ffffffe000201c60:	00078663          	beqz	a5,ffffffe000201c6c <print_dec_int+0x218>
ffffffe000201c64:	02d00793          	li	a5,45
ffffffe000201c68:	01c0006f          	j	ffffffe000201c84 <print_dec_int+0x230>
ffffffe000201c6c:	f9043783          	ld	a5,-112(s0)
ffffffe000201c70:	0057c783          	lbu	a5,5(a5)
ffffffe000201c74:	00078663          	beqz	a5,ffffffe000201c80 <print_dec_int+0x22c>
ffffffe000201c78:	02b00793          	li	a5,43
ffffffe000201c7c:	0080006f          	j	ffffffe000201c84 <print_dec_int+0x230>
ffffffe000201c80:	02000793          	li	a5,32
ffffffe000201c84:	fa843703          	ld	a4,-88(s0)
ffffffe000201c88:	00078513          	mv	a0,a5
ffffffe000201c8c:	000700e7          	jalr	a4
        ++written;
ffffffe000201c90:	fe442783          	lw	a5,-28(s0)
ffffffe000201c94:	0017879b          	addiw	a5,a5,1
ffffffe000201c98:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000201c9c:	fe842783          	lw	a5,-24(s0)
ffffffe000201ca0:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201ca4:	0280006f          	j	ffffffe000201ccc <print_dec_int+0x278>
        putch('0');
ffffffe000201ca8:	fa843783          	ld	a5,-88(s0)
ffffffe000201cac:	03000513          	li	a0,48
ffffffe000201cb0:	000780e7          	jalr	a5
        ++written;
ffffffe000201cb4:	fe442783          	lw	a5,-28(s0)
ffffffe000201cb8:	0017879b          	addiw	a5,a5,1
ffffffe000201cbc:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000201cc0:	fdc42783          	lw	a5,-36(s0)
ffffffe000201cc4:	0017879b          	addiw	a5,a5,1
ffffffe000201cc8:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201ccc:	f9043783          	ld	a5,-112(s0)
ffffffe000201cd0:	00c7a703          	lw	a4,12(a5)
ffffffe000201cd4:	fd744783          	lbu	a5,-41(s0)
ffffffe000201cd8:	0007879b          	sext.w	a5,a5
ffffffe000201cdc:	40f707bb          	subw	a5,a4,a5
ffffffe000201ce0:	0007871b          	sext.w	a4,a5
ffffffe000201ce4:	fdc42783          	lw	a5,-36(s0)
ffffffe000201ce8:	0007879b          	sext.w	a5,a5
ffffffe000201cec:	fae7cee3          	blt	a5,a4,ffffffe000201ca8 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201cf0:	fe842783          	lw	a5,-24(s0)
ffffffe000201cf4:	fff7879b          	addiw	a5,a5,-1
ffffffe000201cf8:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201cfc:	03c0006f          	j	ffffffe000201d38 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe000201d00:	fd842783          	lw	a5,-40(s0)
ffffffe000201d04:	ff078793          	addi	a5,a5,-16
ffffffe000201d08:	008787b3          	add	a5,a5,s0
ffffffe000201d0c:	fc87c783          	lbu	a5,-56(a5)
ffffffe000201d10:	0007871b          	sext.w	a4,a5
ffffffe000201d14:	fa843783          	ld	a5,-88(s0)
ffffffe000201d18:	00070513          	mv	a0,a4
ffffffe000201d1c:	000780e7          	jalr	a5
        ++written;
ffffffe000201d20:	fe442783          	lw	a5,-28(s0)
ffffffe000201d24:	0017879b          	addiw	a5,a5,1
ffffffe000201d28:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201d2c:	fd842783          	lw	a5,-40(s0)
ffffffe000201d30:	fff7879b          	addiw	a5,a5,-1
ffffffe000201d34:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201d38:	fd842783          	lw	a5,-40(s0)
ffffffe000201d3c:	0007879b          	sext.w	a5,a5
ffffffe000201d40:	fc07d0e3          	bgez	a5,ffffffe000201d00 <print_dec_int+0x2ac>
    }

    return written;
ffffffe000201d44:	fe442783          	lw	a5,-28(s0)
}
ffffffe000201d48:	00078513          	mv	a0,a5
ffffffe000201d4c:	06813083          	ld	ra,104(sp)
ffffffe000201d50:	06013403          	ld	s0,96(sp)
ffffffe000201d54:	07010113          	addi	sp,sp,112
ffffffe000201d58:	00008067          	ret

ffffffe000201d5c <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000201d5c:	f4010113          	addi	sp,sp,-192
ffffffe000201d60:	0a113c23          	sd	ra,184(sp)
ffffffe000201d64:	0a813823          	sd	s0,176(sp)
ffffffe000201d68:	0c010413          	addi	s0,sp,192
ffffffe000201d6c:	f4a43c23          	sd	a0,-168(s0)
ffffffe000201d70:	f4b43823          	sd	a1,-176(s0)
ffffffe000201d74:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000201d78:	f8043023          	sd	zero,-128(s0)
ffffffe000201d7c:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000201d80:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000201d84:	7a40006f          	j	ffffffe000202528 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000201d88:	f8044783          	lbu	a5,-128(s0)
ffffffe000201d8c:	72078e63          	beqz	a5,ffffffe0002024c8 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000201d90:	f5043783          	ld	a5,-176(s0)
ffffffe000201d94:	0007c783          	lbu	a5,0(a5)
ffffffe000201d98:	00078713          	mv	a4,a5
ffffffe000201d9c:	02300793          	li	a5,35
ffffffe000201da0:	00f71863          	bne	a4,a5,ffffffe000201db0 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000201da4:	00100793          	li	a5,1
ffffffe000201da8:	f8f40123          	sb	a5,-126(s0)
ffffffe000201dac:	7700006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000201db0:	f5043783          	ld	a5,-176(s0)
ffffffe000201db4:	0007c783          	lbu	a5,0(a5)
ffffffe000201db8:	00078713          	mv	a4,a5
ffffffe000201dbc:	03000793          	li	a5,48
ffffffe000201dc0:	00f71863          	bne	a4,a5,ffffffe000201dd0 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000201dc4:	00100793          	li	a5,1
ffffffe000201dc8:	f8f401a3          	sb	a5,-125(s0)
ffffffe000201dcc:	7500006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000201dd0:	f5043783          	ld	a5,-176(s0)
ffffffe000201dd4:	0007c783          	lbu	a5,0(a5)
ffffffe000201dd8:	00078713          	mv	a4,a5
ffffffe000201ddc:	06c00793          	li	a5,108
ffffffe000201de0:	04f70063          	beq	a4,a5,ffffffe000201e20 <vprintfmt+0xc4>
ffffffe000201de4:	f5043783          	ld	a5,-176(s0)
ffffffe000201de8:	0007c783          	lbu	a5,0(a5)
ffffffe000201dec:	00078713          	mv	a4,a5
ffffffe000201df0:	07a00793          	li	a5,122
ffffffe000201df4:	02f70663          	beq	a4,a5,ffffffe000201e20 <vprintfmt+0xc4>
ffffffe000201df8:	f5043783          	ld	a5,-176(s0)
ffffffe000201dfc:	0007c783          	lbu	a5,0(a5)
ffffffe000201e00:	00078713          	mv	a4,a5
ffffffe000201e04:	07400793          	li	a5,116
ffffffe000201e08:	00f70c63          	beq	a4,a5,ffffffe000201e20 <vprintfmt+0xc4>
ffffffe000201e0c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e10:	0007c783          	lbu	a5,0(a5)
ffffffe000201e14:	00078713          	mv	a4,a5
ffffffe000201e18:	06a00793          	li	a5,106
ffffffe000201e1c:	00f71863          	bne	a4,a5,ffffffe000201e2c <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000201e20:	00100793          	li	a5,1
ffffffe000201e24:	f8f400a3          	sb	a5,-127(s0)
ffffffe000201e28:	6f40006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000201e2c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e30:	0007c783          	lbu	a5,0(a5)
ffffffe000201e34:	00078713          	mv	a4,a5
ffffffe000201e38:	02b00793          	li	a5,43
ffffffe000201e3c:	00f71863          	bne	a4,a5,ffffffe000201e4c <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000201e40:	00100793          	li	a5,1
ffffffe000201e44:	f8f402a3          	sb	a5,-123(s0)
ffffffe000201e48:	6d40006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000201e4c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e50:	0007c783          	lbu	a5,0(a5)
ffffffe000201e54:	00078713          	mv	a4,a5
ffffffe000201e58:	02000793          	li	a5,32
ffffffe000201e5c:	00f71863          	bne	a4,a5,ffffffe000201e6c <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000201e60:	00100793          	li	a5,1
ffffffe000201e64:	f8f40223          	sb	a5,-124(s0)
ffffffe000201e68:	6b40006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000201e6c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e70:	0007c783          	lbu	a5,0(a5)
ffffffe000201e74:	00078713          	mv	a4,a5
ffffffe000201e78:	02a00793          	li	a5,42
ffffffe000201e7c:	00f71e63          	bne	a4,a5,ffffffe000201e98 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000201e80:	f4843783          	ld	a5,-184(s0)
ffffffe000201e84:	00878713          	addi	a4,a5,8
ffffffe000201e88:	f4e43423          	sd	a4,-184(s0)
ffffffe000201e8c:	0007a783          	lw	a5,0(a5)
ffffffe000201e90:	f8f42423          	sw	a5,-120(s0)
ffffffe000201e94:	6880006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000201e98:	f5043783          	ld	a5,-176(s0)
ffffffe000201e9c:	0007c783          	lbu	a5,0(a5)
ffffffe000201ea0:	00078713          	mv	a4,a5
ffffffe000201ea4:	03000793          	li	a5,48
ffffffe000201ea8:	04e7f663          	bgeu	a5,a4,ffffffe000201ef4 <vprintfmt+0x198>
ffffffe000201eac:	f5043783          	ld	a5,-176(s0)
ffffffe000201eb0:	0007c783          	lbu	a5,0(a5)
ffffffe000201eb4:	00078713          	mv	a4,a5
ffffffe000201eb8:	03900793          	li	a5,57
ffffffe000201ebc:	02e7ec63          	bltu	a5,a4,ffffffe000201ef4 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000201ec0:	f5043783          	ld	a5,-176(s0)
ffffffe000201ec4:	f5040713          	addi	a4,s0,-176
ffffffe000201ec8:	00a00613          	li	a2,10
ffffffe000201ecc:	00070593          	mv	a1,a4
ffffffe000201ed0:	00078513          	mv	a0,a5
ffffffe000201ed4:	88dff0ef          	jal	ra,ffffffe000201760 <strtol>
ffffffe000201ed8:	00050793          	mv	a5,a0
ffffffe000201edc:	0007879b          	sext.w	a5,a5
ffffffe000201ee0:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000201ee4:	f5043783          	ld	a5,-176(s0)
ffffffe000201ee8:	fff78793          	addi	a5,a5,-1
ffffffe000201eec:	f4f43823          	sd	a5,-176(s0)
ffffffe000201ef0:	62c0006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000201ef4:	f5043783          	ld	a5,-176(s0)
ffffffe000201ef8:	0007c783          	lbu	a5,0(a5)
ffffffe000201efc:	00078713          	mv	a4,a5
ffffffe000201f00:	02e00793          	li	a5,46
ffffffe000201f04:	06f71863          	bne	a4,a5,ffffffe000201f74 <vprintfmt+0x218>
                fmt++;
ffffffe000201f08:	f5043783          	ld	a5,-176(s0)
ffffffe000201f0c:	00178793          	addi	a5,a5,1
ffffffe000201f10:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000201f14:	f5043783          	ld	a5,-176(s0)
ffffffe000201f18:	0007c783          	lbu	a5,0(a5)
ffffffe000201f1c:	00078713          	mv	a4,a5
ffffffe000201f20:	02a00793          	li	a5,42
ffffffe000201f24:	00f71e63          	bne	a4,a5,ffffffe000201f40 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000201f28:	f4843783          	ld	a5,-184(s0)
ffffffe000201f2c:	00878713          	addi	a4,a5,8
ffffffe000201f30:	f4e43423          	sd	a4,-184(s0)
ffffffe000201f34:	0007a783          	lw	a5,0(a5)
ffffffe000201f38:	f8f42623          	sw	a5,-116(s0)
ffffffe000201f3c:	5e00006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000201f40:	f5043783          	ld	a5,-176(s0)
ffffffe000201f44:	f5040713          	addi	a4,s0,-176
ffffffe000201f48:	00a00613          	li	a2,10
ffffffe000201f4c:	00070593          	mv	a1,a4
ffffffe000201f50:	00078513          	mv	a0,a5
ffffffe000201f54:	80dff0ef          	jal	ra,ffffffe000201760 <strtol>
ffffffe000201f58:	00050793          	mv	a5,a0
ffffffe000201f5c:	0007879b          	sext.w	a5,a5
ffffffe000201f60:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000201f64:	f5043783          	ld	a5,-176(s0)
ffffffe000201f68:	fff78793          	addi	a5,a5,-1
ffffffe000201f6c:	f4f43823          	sd	a5,-176(s0)
ffffffe000201f70:	5ac0006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000201f74:	f5043783          	ld	a5,-176(s0)
ffffffe000201f78:	0007c783          	lbu	a5,0(a5)
ffffffe000201f7c:	00078713          	mv	a4,a5
ffffffe000201f80:	07800793          	li	a5,120
ffffffe000201f84:	02f70663          	beq	a4,a5,ffffffe000201fb0 <vprintfmt+0x254>
ffffffe000201f88:	f5043783          	ld	a5,-176(s0)
ffffffe000201f8c:	0007c783          	lbu	a5,0(a5)
ffffffe000201f90:	00078713          	mv	a4,a5
ffffffe000201f94:	05800793          	li	a5,88
ffffffe000201f98:	00f70c63          	beq	a4,a5,ffffffe000201fb0 <vprintfmt+0x254>
ffffffe000201f9c:	f5043783          	ld	a5,-176(s0)
ffffffe000201fa0:	0007c783          	lbu	a5,0(a5)
ffffffe000201fa4:	00078713          	mv	a4,a5
ffffffe000201fa8:	07000793          	li	a5,112
ffffffe000201fac:	30f71263          	bne	a4,a5,ffffffe0002022b0 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000201fb0:	f5043783          	ld	a5,-176(s0)
ffffffe000201fb4:	0007c783          	lbu	a5,0(a5)
ffffffe000201fb8:	00078713          	mv	a4,a5
ffffffe000201fbc:	07000793          	li	a5,112
ffffffe000201fc0:	00f70663          	beq	a4,a5,ffffffe000201fcc <vprintfmt+0x270>
ffffffe000201fc4:	f8144783          	lbu	a5,-127(s0)
ffffffe000201fc8:	00078663          	beqz	a5,ffffffe000201fd4 <vprintfmt+0x278>
ffffffe000201fcc:	00100793          	li	a5,1
ffffffe000201fd0:	0080006f          	j	ffffffe000201fd8 <vprintfmt+0x27c>
ffffffe000201fd4:	00000793          	li	a5,0
ffffffe000201fd8:	faf403a3          	sb	a5,-89(s0)
ffffffe000201fdc:	fa744783          	lbu	a5,-89(s0)
ffffffe000201fe0:	0017f793          	andi	a5,a5,1
ffffffe000201fe4:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000201fe8:	fa744783          	lbu	a5,-89(s0)
ffffffe000201fec:	0ff7f793          	zext.b	a5,a5
ffffffe000201ff0:	00078c63          	beqz	a5,ffffffe000202008 <vprintfmt+0x2ac>
ffffffe000201ff4:	f4843783          	ld	a5,-184(s0)
ffffffe000201ff8:	00878713          	addi	a4,a5,8
ffffffe000201ffc:	f4e43423          	sd	a4,-184(s0)
ffffffe000202000:	0007b783          	ld	a5,0(a5)
ffffffe000202004:	01c0006f          	j	ffffffe000202020 <vprintfmt+0x2c4>
ffffffe000202008:	f4843783          	ld	a5,-184(s0)
ffffffe00020200c:	00878713          	addi	a4,a5,8
ffffffe000202010:	f4e43423          	sd	a4,-184(s0)
ffffffe000202014:	0007a783          	lw	a5,0(a5)
ffffffe000202018:	02079793          	slli	a5,a5,0x20
ffffffe00020201c:	0207d793          	srli	a5,a5,0x20
ffffffe000202020:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000202024:	f8c42783          	lw	a5,-116(s0)
ffffffe000202028:	02079463          	bnez	a5,ffffffe000202050 <vprintfmt+0x2f4>
ffffffe00020202c:	fe043783          	ld	a5,-32(s0)
ffffffe000202030:	02079063          	bnez	a5,ffffffe000202050 <vprintfmt+0x2f4>
ffffffe000202034:	f5043783          	ld	a5,-176(s0)
ffffffe000202038:	0007c783          	lbu	a5,0(a5)
ffffffe00020203c:	00078713          	mv	a4,a5
ffffffe000202040:	07000793          	li	a5,112
ffffffe000202044:	00f70663          	beq	a4,a5,ffffffe000202050 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000202048:	f8040023          	sb	zero,-128(s0)
ffffffe00020204c:	4d00006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000202050:	f5043783          	ld	a5,-176(s0)
ffffffe000202054:	0007c783          	lbu	a5,0(a5)
ffffffe000202058:	00078713          	mv	a4,a5
ffffffe00020205c:	07000793          	li	a5,112
ffffffe000202060:	00f70a63          	beq	a4,a5,ffffffe000202074 <vprintfmt+0x318>
ffffffe000202064:	f8244783          	lbu	a5,-126(s0)
ffffffe000202068:	00078a63          	beqz	a5,ffffffe00020207c <vprintfmt+0x320>
ffffffe00020206c:	fe043783          	ld	a5,-32(s0)
ffffffe000202070:	00078663          	beqz	a5,ffffffe00020207c <vprintfmt+0x320>
ffffffe000202074:	00100793          	li	a5,1
ffffffe000202078:	0080006f          	j	ffffffe000202080 <vprintfmt+0x324>
ffffffe00020207c:	00000793          	li	a5,0
ffffffe000202080:	faf40323          	sb	a5,-90(s0)
ffffffe000202084:	fa644783          	lbu	a5,-90(s0)
ffffffe000202088:	0017f793          	andi	a5,a5,1
ffffffe00020208c:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000202090:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000202094:	f5043783          	ld	a5,-176(s0)
ffffffe000202098:	0007c783          	lbu	a5,0(a5)
ffffffe00020209c:	00078713          	mv	a4,a5
ffffffe0002020a0:	05800793          	li	a5,88
ffffffe0002020a4:	00f71863          	bne	a4,a5,ffffffe0002020b4 <vprintfmt+0x358>
ffffffe0002020a8:	00001797          	auipc	a5,0x1
ffffffe0002020ac:	42878793          	addi	a5,a5,1064 # ffffffe0002034d0 <upperxdigits.1>
ffffffe0002020b0:	00c0006f          	j	ffffffe0002020bc <vprintfmt+0x360>
ffffffe0002020b4:	00001797          	auipc	a5,0x1
ffffffe0002020b8:	43478793          	addi	a5,a5,1076 # ffffffe0002034e8 <lowerxdigits.0>
ffffffe0002020bc:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe0002020c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002020c4:	00f7f793          	andi	a5,a5,15
ffffffe0002020c8:	f9843703          	ld	a4,-104(s0)
ffffffe0002020cc:	00f70733          	add	a4,a4,a5
ffffffe0002020d0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002020d4:	0017869b          	addiw	a3,a5,1
ffffffe0002020d8:	fcd42e23          	sw	a3,-36(s0)
ffffffe0002020dc:	00074703          	lbu	a4,0(a4)
ffffffe0002020e0:	ff078793          	addi	a5,a5,-16
ffffffe0002020e4:	008787b3          	add	a5,a5,s0
ffffffe0002020e8:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe0002020ec:	fe043783          	ld	a5,-32(s0)
ffffffe0002020f0:	0047d793          	srli	a5,a5,0x4
ffffffe0002020f4:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe0002020f8:	fe043783          	ld	a5,-32(s0)
ffffffe0002020fc:	fc0792e3          	bnez	a5,ffffffe0002020c0 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000202100:	f8c42783          	lw	a5,-116(s0)
ffffffe000202104:	00078713          	mv	a4,a5
ffffffe000202108:	fff00793          	li	a5,-1
ffffffe00020210c:	02f71663          	bne	a4,a5,ffffffe000202138 <vprintfmt+0x3dc>
ffffffe000202110:	f8344783          	lbu	a5,-125(s0)
ffffffe000202114:	02078263          	beqz	a5,ffffffe000202138 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000202118:	f8842703          	lw	a4,-120(s0)
ffffffe00020211c:	fa644783          	lbu	a5,-90(s0)
ffffffe000202120:	0007879b          	sext.w	a5,a5
ffffffe000202124:	0017979b          	slliw	a5,a5,0x1
ffffffe000202128:	0007879b          	sext.w	a5,a5
ffffffe00020212c:	40f707bb          	subw	a5,a4,a5
ffffffe000202130:	0007879b          	sext.w	a5,a5
ffffffe000202134:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202138:	f8842703          	lw	a4,-120(s0)
ffffffe00020213c:	fa644783          	lbu	a5,-90(s0)
ffffffe000202140:	0007879b          	sext.w	a5,a5
ffffffe000202144:	0017979b          	slliw	a5,a5,0x1
ffffffe000202148:	0007879b          	sext.w	a5,a5
ffffffe00020214c:	40f707bb          	subw	a5,a4,a5
ffffffe000202150:	0007871b          	sext.w	a4,a5
ffffffe000202154:	fdc42783          	lw	a5,-36(s0)
ffffffe000202158:	f8f42a23          	sw	a5,-108(s0)
ffffffe00020215c:	f8c42783          	lw	a5,-116(s0)
ffffffe000202160:	f8f42823          	sw	a5,-112(s0)
ffffffe000202164:	f9442783          	lw	a5,-108(s0)
ffffffe000202168:	00078593          	mv	a1,a5
ffffffe00020216c:	f9042783          	lw	a5,-112(s0)
ffffffe000202170:	00078613          	mv	a2,a5
ffffffe000202174:	0006069b          	sext.w	a3,a2
ffffffe000202178:	0005879b          	sext.w	a5,a1
ffffffe00020217c:	00f6d463          	bge	a3,a5,ffffffe000202184 <vprintfmt+0x428>
ffffffe000202180:	00058613          	mv	a2,a1
ffffffe000202184:	0006079b          	sext.w	a5,a2
ffffffe000202188:	40f707bb          	subw	a5,a4,a5
ffffffe00020218c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202190:	0280006f          	j	ffffffe0002021b8 <vprintfmt+0x45c>
                    putch(' ');
ffffffe000202194:	f5843783          	ld	a5,-168(s0)
ffffffe000202198:	02000513          	li	a0,32
ffffffe00020219c:	000780e7          	jalr	a5
                    ++written;
ffffffe0002021a0:	fec42783          	lw	a5,-20(s0)
ffffffe0002021a4:	0017879b          	addiw	a5,a5,1
ffffffe0002021a8:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe0002021ac:	fd842783          	lw	a5,-40(s0)
ffffffe0002021b0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002021b4:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002021b8:	fd842783          	lw	a5,-40(s0)
ffffffe0002021bc:	0007879b          	sext.w	a5,a5
ffffffe0002021c0:	fcf04ae3          	bgtz	a5,ffffffe000202194 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe0002021c4:	fa644783          	lbu	a5,-90(s0)
ffffffe0002021c8:	0ff7f793          	zext.b	a5,a5
ffffffe0002021cc:	04078463          	beqz	a5,ffffffe000202214 <vprintfmt+0x4b8>
                    putch('0');
ffffffe0002021d0:	f5843783          	ld	a5,-168(s0)
ffffffe0002021d4:	03000513          	li	a0,48
ffffffe0002021d8:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe0002021dc:	f5043783          	ld	a5,-176(s0)
ffffffe0002021e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002021e4:	00078713          	mv	a4,a5
ffffffe0002021e8:	05800793          	li	a5,88
ffffffe0002021ec:	00f71663          	bne	a4,a5,ffffffe0002021f8 <vprintfmt+0x49c>
ffffffe0002021f0:	05800793          	li	a5,88
ffffffe0002021f4:	0080006f          	j	ffffffe0002021fc <vprintfmt+0x4a0>
ffffffe0002021f8:	07800793          	li	a5,120
ffffffe0002021fc:	f5843703          	ld	a4,-168(s0)
ffffffe000202200:	00078513          	mv	a0,a5
ffffffe000202204:	000700e7          	jalr	a4
                    written += 2;
ffffffe000202208:	fec42783          	lw	a5,-20(s0)
ffffffe00020220c:	0027879b          	addiw	a5,a5,2
ffffffe000202210:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202214:	fdc42783          	lw	a5,-36(s0)
ffffffe000202218:	fcf42a23          	sw	a5,-44(s0)
ffffffe00020221c:	0280006f          	j	ffffffe000202244 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000202220:	f5843783          	ld	a5,-168(s0)
ffffffe000202224:	03000513          	li	a0,48
ffffffe000202228:	000780e7          	jalr	a5
                    ++written;
ffffffe00020222c:	fec42783          	lw	a5,-20(s0)
ffffffe000202230:	0017879b          	addiw	a5,a5,1
ffffffe000202234:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202238:	fd442783          	lw	a5,-44(s0)
ffffffe00020223c:	0017879b          	addiw	a5,a5,1
ffffffe000202240:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202244:	f8c42703          	lw	a4,-116(s0)
ffffffe000202248:	fd442783          	lw	a5,-44(s0)
ffffffe00020224c:	0007879b          	sext.w	a5,a5
ffffffe000202250:	fce7c8e3          	blt	a5,a4,ffffffe000202220 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202254:	fdc42783          	lw	a5,-36(s0)
ffffffe000202258:	fff7879b          	addiw	a5,a5,-1
ffffffe00020225c:	fcf42823          	sw	a5,-48(s0)
ffffffe000202260:	03c0006f          	j	ffffffe00020229c <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000202264:	fd042783          	lw	a5,-48(s0)
ffffffe000202268:	ff078793          	addi	a5,a5,-16
ffffffe00020226c:	008787b3          	add	a5,a5,s0
ffffffe000202270:	f807c783          	lbu	a5,-128(a5)
ffffffe000202274:	0007871b          	sext.w	a4,a5
ffffffe000202278:	f5843783          	ld	a5,-168(s0)
ffffffe00020227c:	00070513          	mv	a0,a4
ffffffe000202280:	000780e7          	jalr	a5
                    ++written;
ffffffe000202284:	fec42783          	lw	a5,-20(s0)
ffffffe000202288:	0017879b          	addiw	a5,a5,1
ffffffe00020228c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202290:	fd042783          	lw	a5,-48(s0)
ffffffe000202294:	fff7879b          	addiw	a5,a5,-1
ffffffe000202298:	fcf42823          	sw	a5,-48(s0)
ffffffe00020229c:	fd042783          	lw	a5,-48(s0)
ffffffe0002022a0:	0007879b          	sext.w	a5,a5
ffffffe0002022a4:	fc07d0e3          	bgez	a5,ffffffe000202264 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe0002022a8:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe0002022ac:	2700006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe0002022b0:	f5043783          	ld	a5,-176(s0)
ffffffe0002022b4:	0007c783          	lbu	a5,0(a5)
ffffffe0002022b8:	00078713          	mv	a4,a5
ffffffe0002022bc:	06400793          	li	a5,100
ffffffe0002022c0:	02f70663          	beq	a4,a5,ffffffe0002022ec <vprintfmt+0x590>
ffffffe0002022c4:	f5043783          	ld	a5,-176(s0)
ffffffe0002022c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002022cc:	00078713          	mv	a4,a5
ffffffe0002022d0:	06900793          	li	a5,105
ffffffe0002022d4:	00f70c63          	beq	a4,a5,ffffffe0002022ec <vprintfmt+0x590>
ffffffe0002022d8:	f5043783          	ld	a5,-176(s0)
ffffffe0002022dc:	0007c783          	lbu	a5,0(a5)
ffffffe0002022e0:	00078713          	mv	a4,a5
ffffffe0002022e4:	07500793          	li	a5,117
ffffffe0002022e8:	08f71063          	bne	a4,a5,ffffffe000202368 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe0002022ec:	f8144783          	lbu	a5,-127(s0)
ffffffe0002022f0:	00078c63          	beqz	a5,ffffffe000202308 <vprintfmt+0x5ac>
ffffffe0002022f4:	f4843783          	ld	a5,-184(s0)
ffffffe0002022f8:	00878713          	addi	a4,a5,8
ffffffe0002022fc:	f4e43423          	sd	a4,-184(s0)
ffffffe000202300:	0007b783          	ld	a5,0(a5)
ffffffe000202304:	0140006f          	j	ffffffe000202318 <vprintfmt+0x5bc>
ffffffe000202308:	f4843783          	ld	a5,-184(s0)
ffffffe00020230c:	00878713          	addi	a4,a5,8
ffffffe000202310:	f4e43423          	sd	a4,-184(s0)
ffffffe000202314:	0007a783          	lw	a5,0(a5)
ffffffe000202318:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe00020231c:	fa843583          	ld	a1,-88(s0)
ffffffe000202320:	f5043783          	ld	a5,-176(s0)
ffffffe000202324:	0007c783          	lbu	a5,0(a5)
ffffffe000202328:	0007871b          	sext.w	a4,a5
ffffffe00020232c:	07500793          	li	a5,117
ffffffe000202330:	40f707b3          	sub	a5,a4,a5
ffffffe000202334:	00f037b3          	snez	a5,a5
ffffffe000202338:	0ff7f793          	zext.b	a5,a5
ffffffe00020233c:	f8040713          	addi	a4,s0,-128
ffffffe000202340:	00070693          	mv	a3,a4
ffffffe000202344:	00078613          	mv	a2,a5
ffffffe000202348:	f5843503          	ld	a0,-168(s0)
ffffffe00020234c:	f08ff0ef          	jal	ra,ffffffe000201a54 <print_dec_int>
ffffffe000202350:	00050793          	mv	a5,a0
ffffffe000202354:	fec42703          	lw	a4,-20(s0)
ffffffe000202358:	00f707bb          	addw	a5,a4,a5
ffffffe00020235c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202360:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202364:	1b80006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202368:	f5043783          	ld	a5,-176(s0)
ffffffe00020236c:	0007c783          	lbu	a5,0(a5)
ffffffe000202370:	00078713          	mv	a4,a5
ffffffe000202374:	06e00793          	li	a5,110
ffffffe000202378:	04f71c63          	bne	a4,a5,ffffffe0002023d0 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe00020237c:	f8144783          	lbu	a5,-127(s0)
ffffffe000202380:	02078463          	beqz	a5,ffffffe0002023a8 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000202384:	f4843783          	ld	a5,-184(s0)
ffffffe000202388:	00878713          	addi	a4,a5,8
ffffffe00020238c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202390:	0007b783          	ld	a5,0(a5)
ffffffe000202394:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202398:	fec42703          	lw	a4,-20(s0)
ffffffe00020239c:	fb043783          	ld	a5,-80(s0)
ffffffe0002023a0:	00e7b023          	sd	a4,0(a5)
ffffffe0002023a4:	0240006f          	j	ffffffe0002023c8 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe0002023a8:	f4843783          	ld	a5,-184(s0)
ffffffe0002023ac:	00878713          	addi	a4,a5,8
ffffffe0002023b0:	f4e43423          	sd	a4,-184(s0)
ffffffe0002023b4:	0007b783          	ld	a5,0(a5)
ffffffe0002023b8:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe0002023bc:	fb843783          	ld	a5,-72(s0)
ffffffe0002023c0:	fec42703          	lw	a4,-20(s0)
ffffffe0002023c4:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe0002023c8:	f8040023          	sb	zero,-128(s0)
ffffffe0002023cc:	1500006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe0002023d0:	f5043783          	ld	a5,-176(s0)
ffffffe0002023d4:	0007c783          	lbu	a5,0(a5)
ffffffe0002023d8:	00078713          	mv	a4,a5
ffffffe0002023dc:	07300793          	li	a5,115
ffffffe0002023e0:	02f71e63          	bne	a4,a5,ffffffe00020241c <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe0002023e4:	f4843783          	ld	a5,-184(s0)
ffffffe0002023e8:	00878713          	addi	a4,a5,8
ffffffe0002023ec:	f4e43423          	sd	a4,-184(s0)
ffffffe0002023f0:	0007b783          	ld	a5,0(a5)
ffffffe0002023f4:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe0002023f8:	fc043583          	ld	a1,-64(s0)
ffffffe0002023fc:	f5843503          	ld	a0,-168(s0)
ffffffe000202400:	dccff0ef          	jal	ra,ffffffe0002019cc <puts_wo_nl>
ffffffe000202404:	00050793          	mv	a5,a0
ffffffe000202408:	fec42703          	lw	a4,-20(s0)
ffffffe00020240c:	00f707bb          	addw	a5,a4,a5
ffffffe000202410:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202414:	f8040023          	sb	zero,-128(s0)
ffffffe000202418:	1040006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe00020241c:	f5043783          	ld	a5,-176(s0)
ffffffe000202420:	0007c783          	lbu	a5,0(a5)
ffffffe000202424:	00078713          	mv	a4,a5
ffffffe000202428:	06300793          	li	a5,99
ffffffe00020242c:	02f71e63          	bne	a4,a5,ffffffe000202468 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000202430:	f4843783          	ld	a5,-184(s0)
ffffffe000202434:	00878713          	addi	a4,a5,8
ffffffe000202438:	f4e43423          	sd	a4,-184(s0)
ffffffe00020243c:	0007a783          	lw	a5,0(a5)
ffffffe000202440:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000202444:	fcc42703          	lw	a4,-52(s0)
ffffffe000202448:	f5843783          	ld	a5,-168(s0)
ffffffe00020244c:	00070513          	mv	a0,a4
ffffffe000202450:	000780e7          	jalr	a5
                ++written;
ffffffe000202454:	fec42783          	lw	a5,-20(s0)
ffffffe000202458:	0017879b          	addiw	a5,a5,1
ffffffe00020245c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202460:	f8040023          	sb	zero,-128(s0)
ffffffe000202464:	0b80006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000202468:	f5043783          	ld	a5,-176(s0)
ffffffe00020246c:	0007c783          	lbu	a5,0(a5)
ffffffe000202470:	00078713          	mv	a4,a5
ffffffe000202474:	02500793          	li	a5,37
ffffffe000202478:	02f71263          	bne	a4,a5,ffffffe00020249c <vprintfmt+0x740>
                putch('%');
ffffffe00020247c:	f5843783          	ld	a5,-168(s0)
ffffffe000202480:	02500513          	li	a0,37
ffffffe000202484:	000780e7          	jalr	a5
                ++written;
ffffffe000202488:	fec42783          	lw	a5,-20(s0)
ffffffe00020248c:	0017879b          	addiw	a5,a5,1
ffffffe000202490:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202494:	f8040023          	sb	zero,-128(s0)
ffffffe000202498:	0840006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe00020249c:	f5043783          	ld	a5,-176(s0)
ffffffe0002024a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002024a4:	0007871b          	sext.w	a4,a5
ffffffe0002024a8:	f5843783          	ld	a5,-168(s0)
ffffffe0002024ac:	00070513          	mv	a0,a4
ffffffe0002024b0:	000780e7          	jalr	a5
                ++written;
ffffffe0002024b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002024b8:	0017879b          	addiw	a5,a5,1
ffffffe0002024bc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002024c0:	f8040023          	sb	zero,-128(s0)
ffffffe0002024c4:	0580006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe0002024c8:	f5043783          	ld	a5,-176(s0)
ffffffe0002024cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002024d0:	00078713          	mv	a4,a5
ffffffe0002024d4:	02500793          	li	a5,37
ffffffe0002024d8:	02f71063          	bne	a4,a5,ffffffe0002024f8 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe0002024dc:	f8043023          	sd	zero,-128(s0)
ffffffe0002024e0:	f8043423          	sd	zero,-120(s0)
ffffffe0002024e4:	00100793          	li	a5,1
ffffffe0002024e8:	f8f40023          	sb	a5,-128(s0)
ffffffe0002024ec:	fff00793          	li	a5,-1
ffffffe0002024f0:	f8f42623          	sw	a5,-116(s0)
ffffffe0002024f4:	0280006f          	j	ffffffe00020251c <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe0002024f8:	f5043783          	ld	a5,-176(s0)
ffffffe0002024fc:	0007c783          	lbu	a5,0(a5)
ffffffe000202500:	0007871b          	sext.w	a4,a5
ffffffe000202504:	f5843783          	ld	a5,-168(s0)
ffffffe000202508:	00070513          	mv	a0,a4
ffffffe00020250c:	000780e7          	jalr	a5
            ++written;
ffffffe000202510:	fec42783          	lw	a5,-20(s0)
ffffffe000202514:	0017879b          	addiw	a5,a5,1
ffffffe000202518:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe00020251c:	f5043783          	ld	a5,-176(s0)
ffffffe000202520:	00178793          	addi	a5,a5,1
ffffffe000202524:	f4f43823          	sd	a5,-176(s0)
ffffffe000202528:	f5043783          	ld	a5,-176(s0)
ffffffe00020252c:	0007c783          	lbu	a5,0(a5)
ffffffe000202530:	84079ce3          	bnez	a5,ffffffe000201d88 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000202534:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202538:	00078513          	mv	a0,a5
ffffffe00020253c:	0b813083          	ld	ra,184(sp)
ffffffe000202540:	0b013403          	ld	s0,176(sp)
ffffffe000202544:	0c010113          	addi	sp,sp,192
ffffffe000202548:	00008067          	ret

ffffffe00020254c <printk>:

int printk(const char* s, ...) {
ffffffe00020254c:	f9010113          	addi	sp,sp,-112
ffffffe000202550:	02113423          	sd	ra,40(sp)
ffffffe000202554:	02813023          	sd	s0,32(sp)
ffffffe000202558:	03010413          	addi	s0,sp,48
ffffffe00020255c:	fca43c23          	sd	a0,-40(s0)
ffffffe000202560:	00b43423          	sd	a1,8(s0)
ffffffe000202564:	00c43823          	sd	a2,16(s0)
ffffffe000202568:	00d43c23          	sd	a3,24(s0)
ffffffe00020256c:	02e43023          	sd	a4,32(s0)
ffffffe000202570:	02f43423          	sd	a5,40(s0)
ffffffe000202574:	03043823          	sd	a6,48(s0)
ffffffe000202578:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe00020257c:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000202580:	04040793          	addi	a5,s0,64
ffffffe000202584:	fcf43823          	sd	a5,-48(s0)
ffffffe000202588:	fd043783          	ld	a5,-48(s0)
ffffffe00020258c:	fc878793          	addi	a5,a5,-56
ffffffe000202590:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000202594:	fe043783          	ld	a5,-32(s0)
ffffffe000202598:	00078613          	mv	a2,a5
ffffffe00020259c:	fd843583          	ld	a1,-40(s0)
ffffffe0002025a0:	fffff517          	auipc	a0,0xfffff
ffffffe0002025a4:	11850513          	addi	a0,a0,280 # ffffffe0002016b8 <putc>
ffffffe0002025a8:	fb4ff0ef          	jal	ra,ffffffe000201d5c <vprintfmt>
ffffffe0002025ac:	00050793          	mv	a5,a0
ffffffe0002025b0:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe0002025b4:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002025b8:	00078513          	mv	a0,a5
ffffffe0002025bc:	02813083          	ld	ra,40(sp)
ffffffe0002025c0:	02013403          	ld	s0,32(sp)
ffffffe0002025c4:	07010113          	addi	sp,sp,112
ffffffe0002025c8:	00008067          	ret

ffffffe0002025cc <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe0002025cc:	fe010113          	addi	sp,sp,-32
ffffffe0002025d0:	00813c23          	sd	s0,24(sp)
ffffffe0002025d4:	02010413          	addi	s0,sp,32
ffffffe0002025d8:	00050793          	mv	a5,a0
ffffffe0002025dc:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe0002025e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002025e4:	fff7879b          	addiw	a5,a5,-1
ffffffe0002025e8:	0007879b          	sext.w	a5,a5
ffffffe0002025ec:	02079713          	slli	a4,a5,0x20
ffffffe0002025f0:	02075713          	srli	a4,a4,0x20
ffffffe0002025f4:	00004797          	auipc	a5,0x4
ffffffe0002025f8:	a2c78793          	addi	a5,a5,-1492 # ffffffe000206020 <seed>
ffffffe0002025fc:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202600:	00000013          	nop
ffffffe000202604:	01813403          	ld	s0,24(sp)
ffffffe000202608:	02010113          	addi	sp,sp,32
ffffffe00020260c:	00008067          	ret

ffffffe000202610 <rand>:

int rand(void) {
ffffffe000202610:	ff010113          	addi	sp,sp,-16
ffffffe000202614:	00813423          	sd	s0,8(sp)
ffffffe000202618:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe00020261c:	00004797          	auipc	a5,0x4
ffffffe000202620:	a0478793          	addi	a5,a5,-1532 # ffffffe000206020 <seed>
ffffffe000202624:	0007b703          	ld	a4,0(a5)
ffffffe000202628:	00001797          	auipc	a5,0x1
ffffffe00020262c:	ed878793          	addi	a5,a5,-296 # ffffffe000203500 <lowerxdigits.0+0x18>
ffffffe000202630:	0007b783          	ld	a5,0(a5)
ffffffe000202634:	02f707b3          	mul	a5,a4,a5
ffffffe000202638:	00178713          	addi	a4,a5,1
ffffffe00020263c:	00004797          	auipc	a5,0x4
ffffffe000202640:	9e478793          	addi	a5,a5,-1564 # ffffffe000206020 <seed>
ffffffe000202644:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000202648:	00004797          	auipc	a5,0x4
ffffffe00020264c:	9d878793          	addi	a5,a5,-1576 # ffffffe000206020 <seed>
ffffffe000202650:	0007b783          	ld	a5,0(a5)
ffffffe000202654:	0217d793          	srli	a5,a5,0x21
ffffffe000202658:	0007879b          	sext.w	a5,a5
}
ffffffe00020265c:	00078513          	mv	a0,a5
ffffffe000202660:	00813403          	ld	s0,8(sp)
ffffffe000202664:	01010113          	addi	sp,sp,16
ffffffe000202668:	00008067          	ret

ffffffe00020266c <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe00020266c:	fc010113          	addi	sp,sp,-64
ffffffe000202670:	02813c23          	sd	s0,56(sp)
ffffffe000202674:	04010413          	addi	s0,sp,64
ffffffe000202678:	fca43c23          	sd	a0,-40(s0)
ffffffe00020267c:	00058793          	mv	a5,a1
ffffffe000202680:	fcc43423          	sd	a2,-56(s0)
ffffffe000202684:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000202688:	fd843783          	ld	a5,-40(s0)
ffffffe00020268c:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202690:	fe043423          	sd	zero,-24(s0)
ffffffe000202694:	0280006f          	j	ffffffe0002026bc <memset+0x50>
        s[i] = c;
ffffffe000202698:	fe043703          	ld	a4,-32(s0)
ffffffe00020269c:	fe843783          	ld	a5,-24(s0)
ffffffe0002026a0:	00f707b3          	add	a5,a4,a5
ffffffe0002026a4:	fd442703          	lw	a4,-44(s0)
ffffffe0002026a8:	0ff77713          	zext.b	a4,a4
ffffffe0002026ac:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002026b0:	fe843783          	ld	a5,-24(s0)
ffffffe0002026b4:	00178793          	addi	a5,a5,1
ffffffe0002026b8:	fef43423          	sd	a5,-24(s0)
ffffffe0002026bc:	fe843703          	ld	a4,-24(s0)
ffffffe0002026c0:	fc843783          	ld	a5,-56(s0)
ffffffe0002026c4:	fcf76ae3          	bltu	a4,a5,ffffffe000202698 <memset+0x2c>
    }
    return dest;
ffffffe0002026c8:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002026cc:	00078513          	mv	a0,a5
ffffffe0002026d0:	03813403          	ld	s0,56(sp)
ffffffe0002026d4:	04010113          	addi	sp,sp,64
ffffffe0002026d8:	00008067          	ret
