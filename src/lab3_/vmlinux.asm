
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
ffffffe000200008:	5b1000ef          	jal	ra,ffffffe000200db8 <setup_vm>
    call realocate
ffffffe00020000c:	04c000ef          	jal	ra,ffffffe000200058 <realocate>
    call mm_init
ffffffe000200010:	424000ef          	jal	ra,ffffffe000200434 <mm_init>
    call setup_vm_final
ffffffe000200014:	76d000ef          	jal	ra,ffffffe000200f80 <setup_vm_final>
    call task_init
ffffffe000200018:	460000ef          	jal	ra,ffffffe000200478 <task_init>

    la t0, _traps # load traps
ffffffe00020001c:	00000297          	auipc	t0,0x0
ffffffe000200020:	08028293          	addi	t0,t0,128 # ffffffe00020009c <_traps>
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
ffffffe000200054:	31c010ef          	jal	ra,ffffffe000201370 <start_kernel>

ffffffe000200058 <realocate>:

realocate:
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
    csrw satp, t0
ffffffe00020008c:	18029073          	csrw	satp,t0

    # flush tlb
    sfence.vma zero, zero
ffffffe000200090:	12000073          	sfence.vma

    # flush icache
    fence.i
ffffffe000200094:	0000100f          	fence.i

    ret
ffffffe000200098:	00008067          	ret

ffffffe00020009c <_traps>:
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap

    addi sp, sp, -33*8
ffffffe00020009c:	ef810113          	addi	sp,sp,-264 # ffffffe000205ef8 <_sbss+0xef8>
    sd ra, 0*8(sp)
ffffffe0002000a0:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
ffffffe0002000a4:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
ffffffe0002000a8:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
ffffffe0002000ac:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
ffffffe0002000b0:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
ffffffe0002000b4:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
ffffffe0002000b8:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
ffffffe0002000bc:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
ffffffe0002000c0:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
ffffffe0002000c4:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
ffffffe0002000c8:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
ffffffe0002000cc:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
ffffffe0002000d0:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
ffffffe0002000d4:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
ffffffe0002000d8:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
ffffffe0002000dc:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
ffffffe0002000e0:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
ffffffe0002000e4:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
ffffffe0002000e8:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
ffffffe0002000ec:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
ffffffe0002000f0:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
ffffffe0002000f4:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
ffffffe0002000f8:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
ffffffe0002000fc:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
ffffffe000200100:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
ffffffe000200104:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
ffffffe000200108:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
ffffffe00020010c:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
ffffffe000200110:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
ffffffe000200114:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
ffffffe000200118:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
ffffffe00020011c:	0e513823          	sd	t0,240(sp)
    sd sp, 31*8(sp)
ffffffe000200120:	0e213c23          	sd	sp,248(sp)

    csrr a0, scause
ffffffe000200124:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe000200128:	141025f3          	csrr	a1,sepc
    call trap_handler
ffffffe00020012c:	409000ef          	jal	ra,ffffffe000200d34 <trap_handler>

    ld sp, 31*8(sp)
ffffffe000200130:	0f813103          	ld	sp,248(sp)
    ld t0, 30*8(sp)
ffffffe000200134:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
ffffffe000200138:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
ffffffe00020013c:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
ffffffe000200140:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
ffffffe000200144:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
ffffffe000200148:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
ffffffe00020014c:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
ffffffe000200150:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
ffffffe000200154:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
ffffffe000200158:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
ffffffe00020015c:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
ffffffe000200160:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
ffffffe000200164:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
ffffffe000200168:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
ffffffe00020016c:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
ffffffe000200170:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
ffffffe000200174:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
ffffffe000200178:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
ffffffe00020017c:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
ffffffe000200180:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
ffffffe000200184:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
ffffffe000200188:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
ffffffe00020018c:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
ffffffe000200190:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
ffffffe000200194:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
ffffffe000200198:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
ffffffe00020019c:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
ffffffe0002001a0:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
ffffffe0002001a4:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
ffffffe0002001a8:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
ffffffe0002001ac:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
ffffffe0002001b0:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
ffffffe0002001b4:	10810113          	addi	sp,sp,264
    sret
ffffffe0002001b8:	10200073          	sret

ffffffe0002001bc <__dummy>:

    .globl __dummy
__dummy:
    la t0, dummy
ffffffe0002001bc:	00000297          	auipc	t0,0x0
ffffffe0002001c0:	7ac28293          	addi	t0,t0,1964 # ffffffe000200968 <dummy>
    csrw sepc, t0
ffffffe0002001c4:	14129073          	csrw	sepc,t0
    sret
ffffffe0002001c8:	10200073          	sret

ffffffe0002001cc <__switch_to>:

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
ffffffe0002001cc:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
ffffffe0002001d0:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
ffffffe0002001d4:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
ffffffe0002001d8:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
ffffffe0002001dc:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
ffffffe0002001e0:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
ffffffe0002001e4:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
ffffffe0002001e8:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
ffffffe0002001ec:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
ffffffe0002001f0:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
ffffffe0002001f4:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
ffffffe0002001f8:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
ffffffe0002001fc:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
ffffffe000200200:	07b53423          	sd	s11,104(a0)
    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
ffffffe000200204:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
ffffffe000200208:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
ffffffe00020020c:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
ffffffe000200210:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
ffffffe000200214:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
ffffffe000200218:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
ffffffe00020021c:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
ffffffe000200220:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
ffffffe000200224:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
ffffffe000200228:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
ffffffe00020022c:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
ffffffe000200230:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
ffffffe000200234:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
ffffffe000200238:	0685bd83          	ld	s11,104(a1)
ffffffe00020023c:	00008067          	ret

ffffffe000200240 <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 30000000;

uint64_t get_cycles() {
ffffffe000200240:	fe010113          	addi	sp,sp,-32
ffffffe000200244:	00813c23          	sd	s0,24(sp)
ffffffe000200248:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe00020024c:	c01027f3          	rdtime	a5
ffffffe000200250:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe000200254:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200258:	00078513          	mv	a0,a5
ffffffe00020025c:	01813403          	ld	s0,24(sp)
ffffffe000200260:	02010113          	addi	sp,sp,32
ffffffe000200264:	00008067          	ret

ffffffe000200268 <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
ffffffe000200268:	fe010113          	addi	sp,sp,-32
ffffffe00020026c:	00813c23          	sd	s0,24(sp)
ffffffe000200270:	02010413          	addi	s0,sp,32
ffffffe000200274:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
ffffffe000200278:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
ffffffe00020027c:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
ffffffe000200280:	00000073          	ecall
}
ffffffe000200284:	00000013          	nop
ffffffe000200288:	01813403          	ld	s0,24(sp)
ffffffe00020028c:	02010113          	addi	sp,sp,32
ffffffe000200290:	00008067          	ret

ffffffe000200294 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe000200294:	fe010113          	addi	sp,sp,-32
ffffffe000200298:	00113c23          	sd	ra,24(sp)
ffffffe00020029c:	00813823          	sd	s0,16(sp)
ffffffe0002002a0:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe0002002a4:	f9dff0ef          	jal	ra,ffffffe000200240 <get_cycles>
ffffffe0002002a8:	00050713          	mv	a4,a0
ffffffe0002002ac:	00004797          	auipc	a5,0x4
ffffffe0002002b0:	d5478793          	addi	a5,a5,-684 # ffffffe000204000 <TIMECLOCK>
ffffffe0002002b4:	0007b783          	ld	a5,0(a5)
ffffffe0002002b8:	00f707b3          	add	a5,a4,a5
ffffffe0002002bc:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe0002002c0:	fe843503          	ld	a0,-24(s0)
ffffffe0002002c4:	fa5ff0ef          	jal	ra,ffffffe000200268 <sbi_set_timer>
ffffffe0002002c8:	00000013          	nop
ffffffe0002002cc:	01813083          	ld	ra,24(sp)
ffffffe0002002d0:	01013403          	ld	s0,16(sp)
ffffffe0002002d4:	02010113          	addi	sp,sp,32
ffffffe0002002d8:	00008067          	ret

ffffffe0002002dc <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
ffffffe0002002dc:	fe010113          	addi	sp,sp,-32
ffffffe0002002e0:	00113c23          	sd	ra,24(sp)
ffffffe0002002e4:	00813823          	sd	s0,16(sp)
ffffffe0002002e8:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
ffffffe0002002ec:	00006797          	auipc	a5,0x6
ffffffe0002002f0:	d1478793          	addi	a5,a5,-748 # ffffffe000206000 <kmem>
ffffffe0002002f4:	0007b783          	ld	a5,0(a5)
ffffffe0002002f8:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
ffffffe0002002fc:	fe843783          	ld	a5,-24(s0)
ffffffe000200300:	0007b703          	ld	a4,0(a5)
ffffffe000200304:	00006797          	auipc	a5,0x6
ffffffe000200308:	cfc78793          	addi	a5,a5,-772 # ffffffe000206000 <kmem>
ffffffe00020030c:	00e7b023          	sd	a4,0(a5)
    memset((void *)r, 0x0, PGSIZE);
ffffffe000200310:	00001637          	lui	a2,0x1
ffffffe000200314:	00000593          	li	a1,0
ffffffe000200318:	fe843503          	ld	a0,-24(s0)
ffffffe00020031c:	07c020ef          	jal	ra,ffffffe000202398 <memset>
    return (void *)r;
ffffffe000200320:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200324:	00078513          	mv	a0,a5
ffffffe000200328:	01813083          	ld	ra,24(sp)
ffffffe00020032c:	01013403          	ld	s0,16(sp)
ffffffe000200330:	02010113          	addi	sp,sp,32
ffffffe000200334:	00008067          	ret

ffffffe000200338 <kfree>:

void kfree(void *addr) {
ffffffe000200338:	fd010113          	addi	sp,sp,-48
ffffffe00020033c:	02113423          	sd	ra,40(sp)
ffffffe000200340:	02813023          	sd	s0,32(sp)
ffffffe000200344:	03010413          	addi	s0,sp,48
ffffffe000200348:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
ffffffe00020034c:	fd843783          	ld	a5,-40(s0)
ffffffe000200350:	00078693          	mv	a3,a5
ffffffe000200354:	fd840793          	addi	a5,s0,-40
ffffffe000200358:	fffff737          	lui	a4,0xfffff
ffffffe00020035c:	00e6f733          	and	a4,a3,a4
ffffffe000200360:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
ffffffe000200364:	fd843783          	ld	a5,-40(s0)
ffffffe000200368:	00001637          	lui	a2,0x1
ffffffe00020036c:	00000593          	li	a1,0
ffffffe000200370:	00078513          	mv	a0,a5
ffffffe000200374:	024020ef          	jal	ra,ffffffe000202398 <memset>

    r = (struct run *)addr;
ffffffe000200378:	fd843783          	ld	a5,-40(s0)
ffffffe00020037c:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
ffffffe000200380:	00006797          	auipc	a5,0x6
ffffffe000200384:	c8078793          	addi	a5,a5,-896 # ffffffe000206000 <kmem>
ffffffe000200388:	0007b703          	ld	a4,0(a5)
ffffffe00020038c:	fe843783          	ld	a5,-24(s0)
ffffffe000200390:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
ffffffe000200394:	00006797          	auipc	a5,0x6
ffffffe000200398:	c6c78793          	addi	a5,a5,-916 # ffffffe000206000 <kmem>
ffffffe00020039c:	fe843703          	ld	a4,-24(s0)
ffffffe0002003a0:	00e7b023          	sd	a4,0(a5)

    return;
ffffffe0002003a4:	00000013          	nop
}
ffffffe0002003a8:	02813083          	ld	ra,40(sp)
ffffffe0002003ac:	02013403          	ld	s0,32(sp)
ffffffe0002003b0:	03010113          	addi	sp,sp,48
ffffffe0002003b4:	00008067          	ret

ffffffe0002003b8 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe0002003b8:	fd010113          	addi	sp,sp,-48
ffffffe0002003bc:	02113423          	sd	ra,40(sp)
ffffffe0002003c0:	02813023          	sd	s0,32(sp)
ffffffe0002003c4:	03010413          	addi	s0,sp,48
ffffffe0002003c8:	fca43c23          	sd	a0,-40(s0)
ffffffe0002003cc:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe0002003d0:	fd843703          	ld	a4,-40(s0)
ffffffe0002003d4:	000017b7          	lui	a5,0x1
ffffffe0002003d8:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe0002003dc:	00f70733          	add	a4,a4,a5
ffffffe0002003e0:	fffff7b7          	lui	a5,0xfffff
ffffffe0002003e4:	00f777b3          	and	a5,a4,a5
ffffffe0002003e8:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe0002003ec:	01c0006f          	j	ffffffe000200408 <kfreerange+0x50>
        kfree((void *)addr);
ffffffe0002003f0:	fe843503          	ld	a0,-24(s0)
ffffffe0002003f4:	f45ff0ef          	jal	ra,ffffffe000200338 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe0002003f8:	fe843703          	ld	a4,-24(s0)
ffffffe0002003fc:	000017b7          	lui	a5,0x1
ffffffe000200400:	00f707b3          	add	a5,a4,a5
ffffffe000200404:	fef43423          	sd	a5,-24(s0)
ffffffe000200408:	fe843703          	ld	a4,-24(s0)
ffffffe00020040c:	000017b7          	lui	a5,0x1
ffffffe000200410:	00f70733          	add	a4,a4,a5
ffffffe000200414:	fd043783          	ld	a5,-48(s0)
ffffffe000200418:	fce7fce3          	bgeu	a5,a4,ffffffe0002003f0 <kfreerange+0x38>
    }
}
ffffffe00020041c:	00000013          	nop
ffffffe000200420:	00000013          	nop
ffffffe000200424:	02813083          	ld	ra,40(sp)
ffffffe000200428:	02013403          	ld	s0,32(sp)
ffffffe00020042c:	03010113          	addi	sp,sp,48
ffffffe000200430:	00008067          	ret

ffffffe000200434 <mm_init>:

void mm_init(void) {
ffffffe000200434:	ff010113          	addi	sp,sp,-16
ffffffe000200438:	00113423          	sd	ra,8(sp)
ffffffe00020043c:	00813023          	sd	s0,0(sp)
ffffffe000200440:	01010413          	addi	s0,sp,16
    kfreerange((char *)_ekernel, (char *)0xffffffe008000000); // VA
ffffffe000200444:	c0100793          	li	a5,-1023
ffffffe000200448:	01b79593          	slli	a1,a5,0x1b
ffffffe00020044c:	00009517          	auipc	a0,0x9
ffffffe000200450:	bb450513          	addi	a0,a0,-1100 # ffffffe000209000 <_ebss>
ffffffe000200454:	f65ff0ef          	jal	ra,ffffffe0002003b8 <kfreerange>
    printk("...mm_init done!\n");
ffffffe000200458:	00003517          	auipc	a0,0x3
ffffffe00020045c:	ba850513          	addi	a0,a0,-1112 # ffffffe000203000 <_srodata>
ffffffe000200460:	619010ef          	jal	ra,ffffffe000202278 <printk>
}
ffffffe000200464:	00000013          	nop
ffffffe000200468:	00813083          	ld	ra,8(sp)
ffffffe00020046c:	00013403          	ld	s0,0(sp)
ffffffe000200470:	01010113          	addi	sp,sp,16
ffffffe000200474:	00008067          	ret

ffffffe000200478 <task_init>:
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

extern void __dummy();

void task_init() {
ffffffe000200478:	fe010113          	addi	sp,sp,-32
ffffffe00020047c:	00113c23          	sd	ra,24(sp)
ffffffe000200480:	00813823          	sd	s0,16(sp)
ffffffe000200484:	02010413          	addi	s0,sp,32
    srand(2024);
ffffffe000200488:	7e800513          	li	a0,2024
ffffffe00020048c:	66d010ef          	jal	ra,ffffffe0002022f8 <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
ffffffe000200490:	e4dff0ef          	jal	ra,ffffffe0002002dc <kalloc>
ffffffe000200494:	00050713          	mv	a4,a0
ffffffe000200498:	00006797          	auipc	a5,0x6
ffffffe00020049c:	b7078793          	addi	a5,a5,-1168 # ffffffe000206008 <idle>
ffffffe0002004a0:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe0002004a4:	00006797          	auipc	a5,0x6
ffffffe0002004a8:	b6478793          	addi	a5,a5,-1180 # ffffffe000206008 <idle>
ffffffe0002004ac:	0007b783          	ld	a5,0(a5)
ffffffe0002004b0:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe0002004b4:	00006797          	auipc	a5,0x6
ffffffe0002004b8:	b5478793          	addi	a5,a5,-1196 # ffffffe000206008 <idle>
ffffffe0002004bc:	0007b783          	ld	a5,0(a5)
ffffffe0002004c0:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe0002004c4:	00006797          	auipc	a5,0x6
ffffffe0002004c8:	b4478793          	addi	a5,a5,-1212 # ffffffe000206008 <idle>
ffffffe0002004cc:	0007b783          	ld	a5,0(a5)
ffffffe0002004d0:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe0002004d4:	00006797          	auipc	a5,0x6
ffffffe0002004d8:	b3478793          	addi	a5,a5,-1228 # ffffffe000206008 <idle>
ffffffe0002004dc:	0007b783          	ld	a5,0(a5)
ffffffe0002004e0:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe0002004e4:	00006797          	auipc	a5,0x6
ffffffe0002004e8:	b2478793          	addi	a5,a5,-1244 # ffffffe000206008 <idle>
ffffffe0002004ec:	0007b703          	ld	a4,0(a5)
ffffffe0002004f0:	00006797          	auipc	a5,0x6
ffffffe0002004f4:	b2078793          	addi	a5,a5,-1248 # ffffffe000206010 <current>
ffffffe0002004f8:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe0002004fc:	00006797          	auipc	a5,0x6
ffffffe000200500:	b0c78793          	addi	a5,a5,-1268 # ffffffe000206008 <idle>
ffffffe000200504:	0007b703          	ld	a4,0(a5)
ffffffe000200508:	00006797          	auipc	a5,0x6
ffffffe00020050c:	b2078793          	addi	a5,a5,-1248 # ffffffe000206028 <task>
ffffffe000200510:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for(int i = 1; i < NR_TASKS; i++) {
ffffffe000200514:	00100793          	li	a5,1
ffffffe000200518:	fef42623          	sw	a5,-20(s0)
ffffffe00020051c:	1600006f          	j	ffffffe00020067c <task_init+0x204>
        task[i] = (struct task_struct *)kalloc();
ffffffe000200520:	dbdff0ef          	jal	ra,ffffffe0002002dc <kalloc>
ffffffe000200524:	00050693          	mv	a3,a0
ffffffe000200528:	00006717          	auipc	a4,0x6
ffffffe00020052c:	b0070713          	addi	a4,a4,-1280 # ffffffe000206028 <task>
ffffffe000200530:	fec42783          	lw	a5,-20(s0)
ffffffe000200534:	00379793          	slli	a5,a5,0x3
ffffffe000200538:	00f707b3          	add	a5,a4,a5
ffffffe00020053c:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200540:	00006717          	auipc	a4,0x6
ffffffe000200544:	ae870713          	addi	a4,a4,-1304 # ffffffe000206028 <task>
ffffffe000200548:	fec42783          	lw	a5,-20(s0)
ffffffe00020054c:	00379793          	slli	a5,a5,0x3
ffffffe000200550:	00f707b3          	add	a5,a4,a5
ffffffe000200554:	0007b783          	ld	a5,0(a5)
ffffffe000200558:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe00020055c:	5e1010ef          	jal	ra,ffffffe00020233c <rand>
ffffffe000200560:	00050793          	mv	a5,a0
ffffffe000200564:	00078713          	mv	a4,a5
ffffffe000200568:	00a00793          	li	a5,10
ffffffe00020056c:	02f767bb          	remw	a5,a4,a5
ffffffe000200570:	0007879b          	sext.w	a5,a5
ffffffe000200574:	0017879b          	addiw	a5,a5,1
ffffffe000200578:	0007869b          	sext.w	a3,a5
ffffffe00020057c:	00006717          	auipc	a4,0x6
ffffffe000200580:	aac70713          	addi	a4,a4,-1364 # ffffffe000206028 <task>
ffffffe000200584:	fec42783          	lw	a5,-20(s0)
ffffffe000200588:	00379793          	slli	a5,a5,0x3
ffffffe00020058c:	00f707b3          	add	a5,a4,a5
ffffffe000200590:	0007b783          	ld	a5,0(a5)
ffffffe000200594:	00068713          	mv	a4,a3
ffffffe000200598:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe00020059c:	00006717          	auipc	a4,0x6
ffffffe0002005a0:	a8c70713          	addi	a4,a4,-1396 # ffffffe000206028 <task>
ffffffe0002005a4:	fec42783          	lw	a5,-20(s0)
ffffffe0002005a8:	00379793          	slli	a5,a5,0x3
ffffffe0002005ac:	00f707b3          	add	a5,a4,a5
ffffffe0002005b0:	0007b783          	ld	a5,0(a5)
ffffffe0002005b4:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe0002005b8:	00006717          	auipc	a4,0x6
ffffffe0002005bc:	a7070713          	addi	a4,a4,-1424 # ffffffe000206028 <task>
ffffffe0002005c0:	fec42783          	lw	a5,-20(s0)
ffffffe0002005c4:	00379793          	slli	a5,a5,0x3
ffffffe0002005c8:	00f707b3          	add	a5,a4,a5
ffffffe0002005cc:	0007b783          	ld	a5,0(a5)
ffffffe0002005d0:	fec42703          	lw	a4,-20(s0)
ffffffe0002005d4:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe0002005d8:	00006717          	auipc	a4,0x6
ffffffe0002005dc:	a5070713          	addi	a4,a4,-1456 # ffffffe000206028 <task>
ffffffe0002005e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002005e4:	00379793          	slli	a5,a5,0x3
ffffffe0002005e8:	00f707b3          	add	a5,a4,a5
ffffffe0002005ec:	0007b783          	ld	a5,0(a5)
ffffffe0002005f0:	00000717          	auipc	a4,0x0
ffffffe0002005f4:	bcc70713          	addi	a4,a4,-1076 # ffffffe0002001bc <__dummy>
ffffffe0002005f8:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe0002005fc:	00006717          	auipc	a4,0x6
ffffffe000200600:	a2c70713          	addi	a4,a4,-1492 # ffffffe000206028 <task>
ffffffe000200604:	fec42783          	lw	a5,-20(s0)
ffffffe000200608:	00379793          	slli	a5,a5,0x3
ffffffe00020060c:	00f707b3          	add	a5,a4,a5
ffffffe000200610:	0007b783          	ld	a5,0(a5)
ffffffe000200614:	00078693          	mv	a3,a5
ffffffe000200618:	00006717          	auipc	a4,0x6
ffffffe00020061c:	a1070713          	addi	a4,a4,-1520 # ffffffe000206028 <task>
ffffffe000200620:	fec42783          	lw	a5,-20(s0)
ffffffe000200624:	00379793          	slli	a5,a5,0x3
ffffffe000200628:	00f707b3          	add	a5,a4,a5
ffffffe00020062c:	0007b783          	ld	a5,0(a5)
ffffffe000200630:	00001737          	lui	a4,0x1
ffffffe000200634:	00e68733          	add	a4,a3,a4
ffffffe000200638:	02e7b423          	sd	a4,40(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe00020063c:	00006717          	auipc	a4,0x6
ffffffe000200640:	9ec70713          	addi	a4,a4,-1556 # ffffffe000206028 <task>
ffffffe000200644:	fec42783          	lw	a5,-20(s0)
ffffffe000200648:	00379793          	slli	a5,a5,0x3
ffffffe00020064c:	00f707b3          	add	a5,a4,a5
ffffffe000200650:	0007b783          	ld	a5,0(a5)
ffffffe000200654:	0107b703          	ld	a4,16(a5)
ffffffe000200658:	fec42783          	lw	a5,-20(s0)
ffffffe00020065c:	00070613          	mv	a2,a4
ffffffe000200660:	00078593          	mv	a1,a5
ffffffe000200664:	00003517          	auipc	a0,0x3
ffffffe000200668:	9b450513          	addi	a0,a0,-1612 # ffffffe000203018 <_srodata+0x18>
ffffffe00020066c:	40d010ef          	jal	ra,ffffffe000202278 <printk>
    for(int i = 1; i < NR_TASKS; i++) {
ffffffe000200670:	fec42783          	lw	a5,-20(s0)
ffffffe000200674:	0017879b          	addiw	a5,a5,1
ffffffe000200678:	fef42623          	sw	a5,-20(s0)
ffffffe00020067c:	fec42783          	lw	a5,-20(s0)
ffffffe000200680:	0007871b          	sext.w	a4,a5
ffffffe000200684:	00400793          	li	a5,4
ffffffe000200688:	e8e7dce3          	bge	a5,a4,ffffffe000200520 <task_init+0xa8>
    }

    printk("...task_init done!\n");
ffffffe00020068c:	00003517          	auipc	a0,0x3
ffffffe000200690:	9ac50513          	addi	a0,a0,-1620 # ffffffe000203038 <_srodata+0x38>
ffffffe000200694:	3e5010ef          	jal	ra,ffffffe000202278 <printk>
}
ffffffe000200698:	00000013          	nop
ffffffe00020069c:	01813083          	ld	ra,24(sp)
ffffffe0002006a0:	01013403          	ld	s0,16(sp)
ffffffe0002006a4:	02010113          	addi	sp,sp,32
ffffffe0002006a8:	00008067          	ret

ffffffe0002006ac <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next);

void switch_to(struct task_struct *next) {
ffffffe0002006ac:	fd010113          	addi	sp,sp,-48
ffffffe0002006b0:	02113423          	sd	ra,40(sp)
ffffffe0002006b4:	02813023          	sd	s0,32(sp)
ffffffe0002006b8:	03010413          	addi	s0,sp,48
ffffffe0002006bc:	fca43c23          	sd	a0,-40(s0)
    if (current != next) {
ffffffe0002006c0:	00006797          	auipc	a5,0x6
ffffffe0002006c4:	95078793          	addi	a5,a5,-1712 # ffffffe000206010 <current>
ffffffe0002006c8:	0007b783          	ld	a5,0(a5)
ffffffe0002006cc:	fd843703          	ld	a4,-40(s0)
ffffffe0002006d0:	04f70063          	beq	a4,a5,ffffffe000200710 <switch_to+0x64>
        struct task_struct *prev = current;
ffffffe0002006d4:	00006797          	auipc	a5,0x6
ffffffe0002006d8:	93c78793          	addi	a5,a5,-1732 # ffffffe000206010 <current>
ffffffe0002006dc:	0007b783          	ld	a5,0(a5)
ffffffe0002006e0:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002006e4:	00006797          	auipc	a5,0x6
ffffffe0002006e8:	92c78793          	addi	a5,a5,-1748 # ffffffe000206010 <current>
ffffffe0002006ec:	fd843703          	ld	a4,-40(s0)
ffffffe0002006f0:	00e7b023          	sd	a4,0(a5)
        __switch_to(&(prev->thread), &(next->thread));
ffffffe0002006f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002006f8:	02078713          	addi	a4,a5,32
ffffffe0002006fc:	fd843783          	ld	a5,-40(s0)
ffffffe000200700:	02078793          	addi	a5,a5,32
ffffffe000200704:	00078593          	mv	a1,a5
ffffffe000200708:	00070513          	mv	a0,a4
ffffffe00020070c:	ac1ff0ef          	jal	ra,ffffffe0002001cc <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
ffffffe000200710:	00000013          	nop
ffffffe000200714:	02813083          	ld	ra,40(sp)
ffffffe000200718:	02013403          	ld	s0,32(sp)
ffffffe00020071c:	03010113          	addi	sp,sp,48
ffffffe000200720:	00008067          	ret

ffffffe000200724 <do_timer>:

void do_timer() {
ffffffe000200724:	ff010113          	addi	sp,sp,-16
ffffffe000200728:	00113423          	sd	ra,8(sp)
ffffffe00020072c:	00813023          	sd	s0,0(sp)
ffffffe000200730:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0) {
ffffffe000200734:	00006797          	auipc	a5,0x6
ffffffe000200738:	8dc78793          	addi	a5,a5,-1828 # ffffffe000206010 <current>
ffffffe00020073c:	0007b783          	ld	a5,0(a5)
ffffffe000200740:	0187b783          	ld	a5,24(a5)
ffffffe000200744:	00078c63          	beqz	a5,ffffffe00020075c <do_timer+0x38>
ffffffe000200748:	00006797          	auipc	a5,0x6
ffffffe00020074c:	8c878793          	addi	a5,a5,-1848 # ffffffe000206010 <current>
ffffffe000200750:	0007b783          	ld	a5,0(a5)
ffffffe000200754:	0087b783          	ld	a5,8(a5)
ffffffe000200758:	00079663          	bnez	a5,ffffffe000200764 <do_timer+0x40>
        schedule();
ffffffe00020075c:	050000ef          	jal	ra,ffffffe0002007ac <schedule>
ffffffe000200760:	03c0006f          	j	ffffffe00020079c <do_timer+0x78>
    } else {
        --(current->counter);
ffffffe000200764:	00006797          	auipc	a5,0x6
ffffffe000200768:	8ac78793          	addi	a5,a5,-1876 # ffffffe000206010 <current>
ffffffe00020076c:	0007b783          	ld	a5,0(a5)
ffffffe000200770:	0087b703          	ld	a4,8(a5)
ffffffe000200774:	fff70713          	addi	a4,a4,-1
ffffffe000200778:	00e7b423          	sd	a4,8(a5)
        if(current->counter > 0) {
ffffffe00020077c:	00006797          	auipc	a5,0x6
ffffffe000200780:	89478793          	addi	a5,a5,-1900 # ffffffe000206010 <current>
ffffffe000200784:	0007b783          	ld	a5,0(a5)
ffffffe000200788:	0087b783          	ld	a5,8(a5)
ffffffe00020078c:	00079663          	bnez	a5,ffffffe000200798 <do_timer+0x74>
            return;
        }
        schedule();
ffffffe000200790:	01c000ef          	jal	ra,ffffffe0002007ac <schedule>
ffffffe000200794:	0080006f          	j	ffffffe00020079c <do_timer+0x78>
            return;
ffffffe000200798:	00000013          	nop
    }
}
ffffffe00020079c:	00813083          	ld	ra,8(sp)
ffffffe0002007a0:	00013403          	ld	s0,0(sp)
ffffffe0002007a4:	01010113          	addi	sp,sp,16
ffffffe0002007a8:	00008067          	ret

ffffffe0002007ac <schedule>:

void schedule() {
ffffffe0002007ac:	fd010113          	addi	sp,sp,-48
ffffffe0002007b0:	02113423          	sd	ra,40(sp)
ffffffe0002007b4:	02813023          	sd	s0,32(sp)
ffffffe0002007b8:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe0002007bc:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
ffffffe0002007c0:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < NR_TASKS; i++) {
ffffffe0002007c4:	00100793          	li	a5,1
ffffffe0002007c8:	fef42023          	sw	a5,-32(s0)
ffffffe0002007cc:	0ac0006f          	j	ffffffe000200878 <schedule+0xcc>
        if (task[i] && task[i]->state == TASK_RUNNING) {
ffffffe0002007d0:	00006717          	auipc	a4,0x6
ffffffe0002007d4:	85870713          	addi	a4,a4,-1960 # ffffffe000206028 <task>
ffffffe0002007d8:	fe042783          	lw	a5,-32(s0)
ffffffe0002007dc:	00379793          	slli	a5,a5,0x3
ffffffe0002007e0:	00f707b3          	add	a5,a4,a5
ffffffe0002007e4:	0007b783          	ld	a5,0(a5)
ffffffe0002007e8:	08078263          	beqz	a5,ffffffe00020086c <schedule+0xc0>
ffffffe0002007ec:	00006717          	auipc	a4,0x6
ffffffe0002007f0:	83c70713          	addi	a4,a4,-1988 # ffffffe000206028 <task>
ffffffe0002007f4:	fe042783          	lw	a5,-32(s0)
ffffffe0002007f8:	00379793          	slli	a5,a5,0x3
ffffffe0002007fc:	00f707b3          	add	a5,a4,a5
ffffffe000200800:	0007b783          	ld	a5,0(a5)
ffffffe000200804:	0007b783          	ld	a5,0(a5)
ffffffe000200808:	06079263          	bnez	a5,ffffffe00020086c <schedule+0xc0>
            if (task[i]->counter > max_counter) {
ffffffe00020080c:	00006717          	auipc	a4,0x6
ffffffe000200810:	81c70713          	addi	a4,a4,-2020 # ffffffe000206028 <task>
ffffffe000200814:	fe042783          	lw	a5,-32(s0)
ffffffe000200818:	00379793          	slli	a5,a5,0x3
ffffffe00020081c:	00f707b3          	add	a5,a4,a5
ffffffe000200820:	0007b783          	ld	a5,0(a5)
ffffffe000200824:	0087b703          	ld	a4,8(a5)
ffffffe000200828:	fe442783          	lw	a5,-28(s0)
ffffffe00020082c:	04e7f063          	bgeu	a5,a4,ffffffe00020086c <schedule+0xc0>
                max_counter = task[i]->counter;
ffffffe000200830:	00005717          	auipc	a4,0x5
ffffffe000200834:	7f870713          	addi	a4,a4,2040 # ffffffe000206028 <task>
ffffffe000200838:	fe042783          	lw	a5,-32(s0)
ffffffe00020083c:	00379793          	slli	a5,a5,0x3
ffffffe000200840:	00f707b3          	add	a5,a4,a5
ffffffe000200844:	0007b783          	ld	a5,0(a5)
ffffffe000200848:	0087b783          	ld	a5,8(a5)
ffffffe00020084c:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe000200850:	00005717          	auipc	a4,0x5
ffffffe000200854:	7d870713          	addi	a4,a4,2008 # ffffffe000206028 <task>
ffffffe000200858:	fe042783          	lw	a5,-32(s0)
ffffffe00020085c:	00379793          	slli	a5,a5,0x3
ffffffe000200860:	00f707b3          	add	a5,a4,a5
ffffffe000200864:	0007b783          	ld	a5,0(a5)
ffffffe000200868:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < NR_TASKS; i++) {
ffffffe00020086c:	fe042783          	lw	a5,-32(s0)
ffffffe000200870:	0017879b          	addiw	a5,a5,1
ffffffe000200874:	fef42023          	sw	a5,-32(s0)
ffffffe000200878:	fe042783          	lw	a5,-32(s0)
ffffffe00020087c:	0007871b          	sext.w	a4,a5
ffffffe000200880:	00400793          	li	a5,4
ffffffe000200884:	f4e7d6e3          	bge	a5,a4,ffffffe0002007d0 <schedule+0x24>
            }
        }
    }

    if (max_counter == 0) {
ffffffe000200888:	fe442783          	lw	a5,-28(s0)
ffffffe00020088c:	0007879b          	sext.w	a5,a5
ffffffe000200890:	0a079263          	bnez	a5,ffffffe000200934 <schedule+0x188>
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe000200894:	fc042e23          	sw	zero,-36(s0)
ffffffe000200898:	0840006f          	j	ffffffe00020091c <schedule+0x170>
            if (task[i] && task[i]->state == TASK_RUNNING) {
ffffffe00020089c:	00005717          	auipc	a4,0x5
ffffffe0002008a0:	78c70713          	addi	a4,a4,1932 # ffffffe000206028 <task>
ffffffe0002008a4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008a8:	00379793          	slli	a5,a5,0x3
ffffffe0002008ac:	00f707b3          	add	a5,a4,a5
ffffffe0002008b0:	0007b783          	ld	a5,0(a5)
ffffffe0002008b4:	04078e63          	beqz	a5,ffffffe000200910 <schedule+0x164>
ffffffe0002008b8:	00005717          	auipc	a4,0x5
ffffffe0002008bc:	77070713          	addi	a4,a4,1904 # ffffffe000206028 <task>
ffffffe0002008c0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008c4:	00379793          	slli	a5,a5,0x3
ffffffe0002008c8:	00f707b3          	add	a5,a4,a5
ffffffe0002008cc:	0007b783          	ld	a5,0(a5)
ffffffe0002008d0:	0007b783          	ld	a5,0(a5)
ffffffe0002008d4:	02079e63          	bnez	a5,ffffffe000200910 <schedule+0x164>
                task[i]->counter = task[i]->priority;
ffffffe0002008d8:	00005717          	auipc	a4,0x5
ffffffe0002008dc:	75070713          	addi	a4,a4,1872 # ffffffe000206028 <task>
ffffffe0002008e0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008e4:	00379793          	slli	a5,a5,0x3
ffffffe0002008e8:	00f707b3          	add	a5,a4,a5
ffffffe0002008ec:	0007b703          	ld	a4,0(a5)
ffffffe0002008f0:	00005697          	auipc	a3,0x5
ffffffe0002008f4:	73868693          	addi	a3,a3,1848 # ffffffe000206028 <task>
ffffffe0002008f8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008fc:	00379793          	slli	a5,a5,0x3
ffffffe000200900:	00f687b3          	add	a5,a3,a5
ffffffe000200904:	0007b783          	ld	a5,0(a5)
ffffffe000200908:	01073703          	ld	a4,16(a4)
ffffffe00020090c:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe000200910:	fdc42783          	lw	a5,-36(s0)
ffffffe000200914:	0017879b          	addiw	a5,a5,1
ffffffe000200918:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020091c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200920:	0007871b          	sext.w	a4,a5
ffffffe000200924:	00400793          	li	a5,4
ffffffe000200928:	f6e7dae3          	bge	a5,a4,ffffffe00020089c <schedule+0xf0>
            }
        }
        schedule();
ffffffe00020092c:	e81ff0ef          	jal	ra,ffffffe0002007ac <schedule>
        return;
ffffffe000200930:	0280006f          	j	ffffffe000200958 <schedule+0x1ac>
    }

    if (next && next != current) {
ffffffe000200934:	fe843783          	ld	a5,-24(s0)
ffffffe000200938:	02078063          	beqz	a5,ffffffe000200958 <schedule+0x1ac>
ffffffe00020093c:	00005797          	auipc	a5,0x5
ffffffe000200940:	6d478793          	addi	a5,a5,1748 # ffffffe000206010 <current>
ffffffe000200944:	0007b783          	ld	a5,0(a5)
ffffffe000200948:	fe843703          	ld	a4,-24(s0)
ffffffe00020094c:	00f70663          	beq	a4,a5,ffffffe000200958 <schedule+0x1ac>
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
ffffffe000200950:	fe843503          	ld	a0,-24(s0)
ffffffe000200954:	d59ff0ef          	jal	ra,ffffffe0002006ac <switch_to>
    }
}
ffffffe000200958:	02813083          	ld	ra,40(sp)
ffffffe00020095c:	02013403          	ld	s0,32(sp)
ffffffe000200960:	03010113          	addi	sp,sp,48
ffffffe000200964:	00008067          	ret

ffffffe000200968 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
ffffffe000200968:	fd010113          	addi	sp,sp,-48
ffffffe00020096c:	02113423          	sd	ra,40(sp)
ffffffe000200970:	02813023          	sd	s0,32(sp)
ffffffe000200974:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000200978:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe00020097c:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000200980:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000200984:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000200988:	fff00793          	li	a5,-1
ffffffe00020098c:	fef42223          	sw	a5,-28(s0)
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200990:	fe442783          	lw	a5,-28(s0)
ffffffe000200994:	0007871b          	sext.w	a4,a5
ffffffe000200998:	fff00793          	li	a5,-1
ffffffe00020099c:	00f70e63          	beq	a4,a5,ffffffe0002009b8 <dummy+0x50>
ffffffe0002009a0:	00005797          	auipc	a5,0x5
ffffffe0002009a4:	67078793          	addi	a5,a5,1648 # ffffffe000206010 <current>
ffffffe0002009a8:	0007b783          	ld	a5,0(a5)
ffffffe0002009ac:	0087b703          	ld	a4,8(a5)
ffffffe0002009b0:	fe442783          	lw	a5,-28(s0)
ffffffe0002009b4:	fcf70ee3          	beq	a4,a5,ffffffe000200990 <dummy+0x28>
ffffffe0002009b8:	00005797          	auipc	a5,0x5
ffffffe0002009bc:	65878793          	addi	a5,a5,1624 # ffffffe000206010 <current>
ffffffe0002009c0:	0007b783          	ld	a5,0(a5)
ffffffe0002009c4:	0087b783          	ld	a5,8(a5)
ffffffe0002009c8:	fc0784e3          	beqz	a5,ffffffe000200990 <dummy+0x28>
            if (current->counter == 1) {
ffffffe0002009cc:	00005797          	auipc	a5,0x5
ffffffe0002009d0:	64478793          	addi	a5,a5,1604 # ffffffe000206010 <current>
ffffffe0002009d4:	0007b783          	ld	a5,0(a5)
ffffffe0002009d8:	0087b703          	ld	a4,8(a5)
ffffffe0002009dc:	00100793          	li	a5,1
ffffffe0002009e0:	00f71e63          	bne	a4,a5,ffffffe0002009fc <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002009e4:	00005797          	auipc	a5,0x5
ffffffe0002009e8:	62c78793          	addi	a5,a5,1580 # ffffffe000206010 <current>
ffffffe0002009ec:	0007b783          	ld	a5,0(a5)
ffffffe0002009f0:	0087b703          	ld	a4,8(a5)
ffffffe0002009f4:	fff70713          	addi	a4,a4,-1
ffffffe0002009f8:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002009fc:	00005797          	auipc	a5,0x5
ffffffe000200a00:	61478793          	addi	a5,a5,1556 # ffffffe000206010 <current>
ffffffe000200a04:	0007b783          	ld	a5,0(a5)
ffffffe000200a08:	0087b783          	ld	a5,8(a5)
ffffffe000200a0c:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000200a10:	fe843783          	ld	a5,-24(s0)
ffffffe000200a14:	00178713          	addi	a4,a5,1
ffffffe000200a18:	fd843783          	ld	a5,-40(s0)
ffffffe000200a1c:	02f777b3          	remu	a5,a4,a5
ffffffe000200a20:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe000200a24:	00005797          	auipc	a5,0x5
ffffffe000200a28:	5ec78793          	addi	a5,a5,1516 # ffffffe000206010 <current>
ffffffe000200a2c:	0007b783          	ld	a5,0(a5)
ffffffe000200a30:	0187b783          	ld	a5,24(a5)
ffffffe000200a34:	fe843603          	ld	a2,-24(s0)
ffffffe000200a38:	00078593          	mv	a1,a5
ffffffe000200a3c:	00002517          	auipc	a0,0x2
ffffffe000200a40:	61450513          	addi	a0,a0,1556 # ffffffe000203050 <_srodata+0x50>
ffffffe000200a44:	035010ef          	jal	ra,ffffffe000202278 <printk>
            #if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
ffffffe000200a48:	00005797          	auipc	a5,0x5
ffffffe000200a4c:	5c878793          	addi	a5,a5,1480 # ffffffe000206010 <current>
ffffffe000200a50:	0007b783          	ld	a5,0(a5)
ffffffe000200a54:	0187b783          	ld	a5,24(a5)
ffffffe000200a58:	0ff7f713          	zext.b	a4,a5
ffffffe000200a5c:	00005797          	auipc	a5,0x5
ffffffe000200a60:	5bc78793          	addi	a5,a5,1468 # ffffffe000206018 <tasks_output_index>
ffffffe000200a64:	0007a783          	lw	a5,0(a5)
ffffffe000200a68:	0017869b          	addiw	a3,a5,1
ffffffe000200a6c:	0006861b          	sext.w	a2,a3
ffffffe000200a70:	00005697          	auipc	a3,0x5
ffffffe000200a74:	5a868693          	addi	a3,a3,1448 # ffffffe000206018 <tasks_output_index>
ffffffe000200a78:	00c6a023          	sw	a2,0(a3)
ffffffe000200a7c:	0307071b          	addiw	a4,a4,48
ffffffe000200a80:	0ff77713          	zext.b	a4,a4
ffffffe000200a84:	00005697          	auipc	a3,0x5
ffffffe000200a88:	5cc68693          	addi	a3,a3,1484 # ffffffe000206050 <tasks_output>
ffffffe000200a8c:	00f687b3          	add	a5,a3,a5
ffffffe000200a90:	00e78023          	sb	a4,0(a5)
            if (tasks_output_index == MAX_OUTPUT) {
ffffffe000200a94:	00005797          	auipc	a5,0x5
ffffffe000200a98:	58478793          	addi	a5,a5,1412 # ffffffe000206018 <tasks_output_index>
ffffffe000200a9c:	0007a783          	lw	a5,0(a5)
ffffffe000200aa0:	00078713          	mv	a4,a5
ffffffe000200aa4:	02800793          	li	a5,40
ffffffe000200aa8:	eef714e3          	bne	a4,a5,ffffffe000200990 <dummy+0x28>
                for (int i = 0; i < MAX_OUTPUT; ++i) {
ffffffe000200aac:	fe042023          	sw	zero,-32(s0)
ffffffe000200ab0:	0800006f          	j	ffffffe000200b30 <dummy+0x1c8>
                    if (tasks_output[i] != expected_output[i]) {
ffffffe000200ab4:	00005717          	auipc	a4,0x5
ffffffe000200ab8:	59c70713          	addi	a4,a4,1436 # ffffffe000206050 <tasks_output>
ffffffe000200abc:	fe042783          	lw	a5,-32(s0)
ffffffe000200ac0:	00f707b3          	add	a5,a4,a5
ffffffe000200ac4:	0007c683          	lbu	a3,0(a5)
ffffffe000200ac8:	00003717          	auipc	a4,0x3
ffffffe000200acc:	54070713          	addi	a4,a4,1344 # ffffffe000204008 <expected_output>
ffffffe000200ad0:	fe042783          	lw	a5,-32(s0)
ffffffe000200ad4:	00f707b3          	add	a5,a4,a5
ffffffe000200ad8:	0007c783          	lbu	a5,0(a5)
ffffffe000200adc:	00068713          	mv	a4,a3
ffffffe000200ae0:	04f70263          	beq	a4,a5,ffffffe000200b24 <dummy+0x1bc>
                        printk("\033[31mTest failed!\033[0m\n");
ffffffe000200ae4:	00002517          	auipc	a0,0x2
ffffffe000200ae8:	59c50513          	addi	a0,a0,1436 # ffffffe000203080 <_srodata+0x80>
ffffffe000200aec:	78c010ef          	jal	ra,ffffffe000202278 <printk>
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
ffffffe000200af0:	00003597          	auipc	a1,0x3
ffffffe000200af4:	51858593          	addi	a1,a1,1304 # ffffffe000204008 <expected_output>
ffffffe000200af8:	00002517          	auipc	a0,0x2
ffffffe000200afc:	5a050513          	addi	a0,a0,1440 # ffffffe000203098 <_srodata+0x98>
ffffffe000200b00:	778010ef          	jal	ra,ffffffe000202278 <printk>
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
ffffffe000200b04:	00005597          	auipc	a1,0x5
ffffffe000200b08:	54c58593          	addi	a1,a1,1356 # ffffffe000206050 <tasks_output>
ffffffe000200b0c:	00002517          	auipc	a0,0x2
ffffffe000200b10:	5ac50513          	addi	a0,a0,1452 # ffffffe0002030b8 <_srodata+0xb8>
ffffffe000200b14:	764010ef          	jal	ra,ffffffe000202278 <printk>
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
ffffffe000200b18:	00000593          	li	a1,0
ffffffe000200b1c:	00000513          	li	a0,0
ffffffe000200b20:	17c000ef          	jal	ra,ffffffe000200c9c <sbi_system_reset>
                for (int i = 0; i < MAX_OUTPUT; ++i) {
ffffffe000200b24:	fe042783          	lw	a5,-32(s0)
ffffffe000200b28:	0017879b          	addiw	a5,a5,1
ffffffe000200b2c:	fef42023          	sw	a5,-32(s0)
ffffffe000200b30:	fe042783          	lw	a5,-32(s0)
ffffffe000200b34:	0007871b          	sext.w	a4,a5
ffffffe000200b38:	02700793          	li	a5,39
ffffffe000200b3c:	f6e7dce3          	bge	a5,a4,ffffffe000200ab4 <dummy+0x14c>
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
ffffffe000200b40:	00002517          	auipc	a0,0x2
ffffffe000200b44:	59850513          	addi	a0,a0,1432 # ffffffe0002030d8 <_srodata+0xd8>
ffffffe000200b48:	730010ef          	jal	ra,ffffffe000202278 <printk>
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
ffffffe000200b4c:	00003597          	auipc	a1,0x3
ffffffe000200b50:	4bc58593          	addi	a1,a1,1212 # ffffffe000204008 <expected_output>
ffffffe000200b54:	00002517          	auipc	a0,0x2
ffffffe000200b58:	59c50513          	addi	a0,a0,1436 # ffffffe0002030f0 <_srodata+0xf0>
ffffffe000200b5c:	71c010ef          	jal	ra,ffffffe000202278 <printk>
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
ffffffe000200b60:	00000593          	li	a1,0
ffffffe000200b64:	00000513          	li	a0,0
ffffffe000200b68:	134000ef          	jal	ra,ffffffe000200c9c <sbi_system_reset>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200b6c:	e25ff06f          	j	ffffffe000200990 <dummy+0x28>

ffffffe000200b70 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000200b70:	f8010113          	addi	sp,sp,-128
ffffffe000200b74:	06813c23          	sd	s0,120(sp)
ffffffe000200b78:	06913823          	sd	s1,112(sp)
ffffffe000200b7c:	07213423          	sd	s2,104(sp)
ffffffe000200b80:	07313023          	sd	s3,96(sp)
ffffffe000200b84:	08010413          	addi	s0,sp,128
ffffffe000200b88:	faa43c23          	sd	a0,-72(s0)
ffffffe000200b8c:	fab43823          	sd	a1,-80(s0)
ffffffe000200b90:	fac43423          	sd	a2,-88(s0)
ffffffe000200b94:	fad43023          	sd	a3,-96(s0)
ffffffe000200b98:	f8e43c23          	sd	a4,-104(s0)
ffffffe000200b9c:	f8f43823          	sd	a5,-112(s0)
ffffffe000200ba0:	f9043423          	sd	a6,-120(s0)
ffffffe000200ba4:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe000200ba8:	fb843e03          	ld	t3,-72(s0)
ffffffe000200bac:	fb043e83          	ld	t4,-80(s0)
ffffffe000200bb0:	fa843f03          	ld	t5,-88(s0)
ffffffe000200bb4:	fa043f83          	ld	t6,-96(s0)
ffffffe000200bb8:	f9843283          	ld	t0,-104(s0)
ffffffe000200bbc:	f9043483          	ld	s1,-112(s0)
ffffffe000200bc0:	f8843903          	ld	s2,-120(s0)
ffffffe000200bc4:	f8043983          	ld	s3,-128(s0)
ffffffe000200bc8:	000e0893          	mv	a7,t3
ffffffe000200bcc:	000e8813          	mv	a6,t4
ffffffe000200bd0:	000f0513          	mv	a0,t5
ffffffe000200bd4:	000f8593          	mv	a1,t6
ffffffe000200bd8:	00028613          	mv	a2,t0
ffffffe000200bdc:	00048693          	mv	a3,s1
ffffffe000200be0:	00090713          	mv	a4,s2
ffffffe000200be4:	00098793          	mv	a5,s3
ffffffe000200be8:	00000073          	ecall
ffffffe000200bec:	00050e93          	mv	t4,a0
ffffffe000200bf0:	00058e13          	mv	t3,a1
ffffffe000200bf4:	fdd43023          	sd	t4,-64(s0)
ffffffe000200bf8:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe000200bfc:	fc043783          	ld	a5,-64(s0)
ffffffe000200c00:	fcf43823          	sd	a5,-48(s0)
ffffffe000200c04:	fc843783          	ld	a5,-56(s0)
ffffffe000200c08:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200c0c:	fd043703          	ld	a4,-48(s0)
ffffffe000200c10:	fd843783          	ld	a5,-40(s0)
ffffffe000200c14:	00070313          	mv	t1,a4
ffffffe000200c18:	00078393          	mv	t2,a5
ffffffe000200c1c:	00030713          	mv	a4,t1
ffffffe000200c20:	00038793          	mv	a5,t2
}
ffffffe000200c24:	00070513          	mv	a0,a4
ffffffe000200c28:	00078593          	mv	a1,a5
ffffffe000200c2c:	07813403          	ld	s0,120(sp)
ffffffe000200c30:	07013483          	ld	s1,112(sp)
ffffffe000200c34:	06813903          	ld	s2,104(sp)
ffffffe000200c38:	06013983          	ld	s3,96(sp)
ffffffe000200c3c:	08010113          	addi	sp,sp,128
ffffffe000200c40:	00008067          	ret

ffffffe000200c44 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000200c44:	fd010113          	addi	sp,sp,-48
ffffffe000200c48:	02813423          	sd	s0,40(sp)
ffffffe000200c4c:	03010413          	addi	s0,sp,48
ffffffe000200c50:	00050793          	mv	a5,a0
ffffffe000200c54:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200c58:	00100793          	li	a5,1
ffffffe000200c5c:	00000713          	li	a4,0
ffffffe000200c60:	fdf44683          	lbu	a3,-33(s0)
ffffffe000200c64:	00078893          	mv	a7,a5
ffffffe000200c68:	00070813          	mv	a6,a4
ffffffe000200c6c:	00068513          	mv	a0,a3
ffffffe000200c70:	00000073          	ecall
ffffffe000200c74:	00050713          	mv	a4,a0
ffffffe000200c78:	00058793          	mv	a5,a1
ffffffe000200c7c:	fee43023          	sd	a4,-32(s0)
ffffffe000200c80:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe000200c84:	00000013          	nop
ffffffe000200c88:	00070513          	mv	a0,a4
ffffffe000200c8c:	00078593          	mv	a1,a5
ffffffe000200c90:	02813403          	ld	s0,40(sp)
ffffffe000200c94:	03010113          	addi	sp,sp,48
ffffffe000200c98:	00008067          	ret

ffffffe000200c9c <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000200c9c:	fc010113          	addi	sp,sp,-64
ffffffe000200ca0:	02813c23          	sd	s0,56(sp)
ffffffe000200ca4:	04010413          	addi	s0,sp,64
ffffffe000200ca8:	00050793          	mv	a5,a0
ffffffe000200cac:	00058713          	mv	a4,a1
ffffffe000200cb0:	fcf42623          	sw	a5,-52(s0)
ffffffe000200cb4:	00070793          	mv	a5,a4
ffffffe000200cb8:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200cbc:	00800793          	li	a5,8
ffffffe000200cc0:	00000713          	li	a4,0
ffffffe000200cc4:	fcc42583          	lw	a1,-52(s0)
ffffffe000200cc8:	00058313          	mv	t1,a1
ffffffe000200ccc:	fc842583          	lw	a1,-56(s0)
ffffffe000200cd0:	00058e13          	mv	t3,a1
ffffffe000200cd4:	00078893          	mv	a7,a5
ffffffe000200cd8:	00070813          	mv	a6,a4
ffffffe000200cdc:	00030513          	mv	a0,t1
ffffffe000200ce0:	000e0593          	mv	a1,t3
ffffffe000200ce4:	00000073          	ecall
ffffffe000200ce8:	00050713          	mv	a4,a0
ffffffe000200cec:	00058793          	mv	a5,a1
ffffffe000200cf0:	fce43823          	sd	a4,-48(s0)
ffffffe000200cf4:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe000200cf8:	fd043783          	ld	a5,-48(s0)
ffffffe000200cfc:	fef43023          	sd	a5,-32(s0)
ffffffe000200d00:	fd843783          	ld	a5,-40(s0)
ffffffe000200d04:	fef43423          	sd	a5,-24(s0)
ffffffe000200d08:	fe043703          	ld	a4,-32(s0)
ffffffe000200d0c:	fe843783          	ld	a5,-24(s0)
ffffffe000200d10:	00070613          	mv	a2,a4
ffffffe000200d14:	00078693          	mv	a3,a5
ffffffe000200d18:	00060713          	mv	a4,a2
ffffffe000200d1c:	00068793          	mv	a5,a3
ffffffe000200d20:	00070513          	mv	a0,a4
ffffffe000200d24:	00078593          	mv	a1,a5
ffffffe000200d28:	03813403          	ld	s0,56(sp)
ffffffe000200d2c:	04010113          	addi	sp,sp,64
ffffffe000200d30:	00008067          	ret

ffffffe000200d34 <trap_handler>:
extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc) {
ffffffe000200d34:	fd010113          	addi	sp,sp,-48
ffffffe000200d38:	02113423          	sd	ra,40(sp)
ffffffe000200d3c:	02813023          	sd	s0,32(sp)
ffffffe000200d40:	03010413          	addi	s0,sp,48
ffffffe000200d44:	fca43c23          	sd	a0,-40(s0)
ffffffe000200d48:	fcb43823          	sd	a1,-48(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
ffffffe000200d4c:	fd843783          	ld	a5,-40(s0)
ffffffe000200d50:	0407d063          	bgez	a5,ffffffe000200d90 <trap_handler+0x5c>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe000200d54:	fd843783          	ld	a5,-40(s0)
ffffffe000200d58:	0ff7f793          	zext.b	a5,a5
ffffffe000200d5c:	fef43423          	sd	a5,-24(s0)
        if (interrupt_t == 0x5) {
ffffffe000200d60:	fe843703          	ld	a4,-24(s0)
ffffffe000200d64:	00500793          	li	a5,5
ffffffe000200d68:	00f71863          	bne	a4,a5,ffffffe000200d78 <trap_handler+0x44>
            // timer interrupt
            clock_set_next_event();
ffffffe000200d6c:	d28ff0ef          	jal	ra,ffffffe000200294 <clock_set_next_event>
            do_timer();
ffffffe000200d70:	9b5ff0ef          	jal	ra,ffffffe000200724 <do_timer>
    }
    else {
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        // exception
    }
ffffffe000200d74:	0300006f          	j	ffffffe000200da4 <trap_handler+0x70>
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000200d78:	fd043603          	ld	a2,-48(s0)
ffffffe000200d7c:	fd843583          	ld	a1,-40(s0)
ffffffe000200d80:	00002517          	auipc	a0,0x2
ffffffe000200d84:	39050513          	addi	a0,a0,912 # ffffffe000203110 <_srodata+0x110>
ffffffe000200d88:	4f0010ef          	jal	ra,ffffffe000202278 <printk>
ffffffe000200d8c:	0180006f          	j	ffffffe000200da4 <trap_handler+0x70>
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000200d90:	fd043603          	ld	a2,-48(s0)
ffffffe000200d94:	fd843583          	ld	a1,-40(s0)
ffffffe000200d98:	00002517          	auipc	a0,0x2
ffffffe000200d9c:	3a850513          	addi	a0,a0,936 # ffffffe000203140 <_srodata+0x140>
ffffffe000200da0:	4d8010ef          	jal	ra,ffffffe000202278 <printk>
ffffffe000200da4:	00000013          	nop
ffffffe000200da8:	02813083          	ld	ra,40(sp)
ffffffe000200dac:	02013403          	ld	s0,32(sp)
ffffffe000200db0:	03010113          	addi	sp,sp,48
ffffffe000200db4:	00008067          	ret

ffffffe000200db8 <setup_vm>:
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe000200db8:	fe010113          	addi	sp,sp,-32
ffffffe000200dbc:	00113c23          	sd	ra,24(sp)
ffffffe000200dc0:	00813823          	sd	s0,16(sp)
ffffffe000200dc4:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe000200dc8:	00001637          	lui	a2,0x1
ffffffe000200dcc:	00000593          	li	a1,0
ffffffe000200dd0:	00006517          	auipc	a0,0x6
ffffffe000200dd4:	23050513          	addi	a0,a0,560 # ffffffe000207000 <early_pgtbl>
ffffffe000200dd8:	5c0010ef          	jal	ra,ffffffe000202398 <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000200ddc:	00f00793          	li	a5,15
ffffffe000200de0:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000200de4:	fe043423          	sd	zero,-24(s0)
ffffffe000200de8:	0740006f          	j	ffffffe000200e5c <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000200dec:	fe843703          	ld	a4,-24(s0)
ffffffe000200df0:	fff00793          	li	a5,-1
ffffffe000200df4:	02579793          	slli	a5,a5,0x25
ffffffe000200df8:	00f706b3          	add	a3,a4,a5
ffffffe000200dfc:	fe843703          	ld	a4,-24(s0)
ffffffe000200e00:	00100793          	li	a5,1
ffffffe000200e04:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e08:	00f707b3          	add	a5,a4,a5
ffffffe000200e0c:	fe043603          	ld	a2,-32(s0)
ffffffe000200e10:	00078593          	mv	a1,a5
ffffffe000200e14:	00068513          	mv	a0,a3
ffffffe000200e18:	074000ef          	jal	ra,ffffffe000200e8c <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe000200e1c:	fe843703          	ld	a4,-24(s0)
ffffffe000200e20:	00100793          	li	a5,1
ffffffe000200e24:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e28:	00f706b3          	add	a3,a4,a5
ffffffe000200e2c:	fe843703          	ld	a4,-24(s0)
ffffffe000200e30:	00100793          	li	a5,1
ffffffe000200e34:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e38:	00f707b3          	add	a5,a4,a5
ffffffe000200e3c:	fe043603          	ld	a2,-32(s0)
ffffffe000200e40:	00078593          	mv	a1,a5
ffffffe000200e44:	00068513          	mv	a0,a3
ffffffe000200e48:	044000ef          	jal	ra,ffffffe000200e8c <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000200e4c:	fe843703          	ld	a4,-24(s0)
ffffffe000200e50:	400007b7          	lui	a5,0x40000
ffffffe000200e54:	00f707b3          	add	a5,a4,a5
ffffffe000200e58:	fef43423          	sd	a5,-24(s0)
ffffffe000200e5c:	fe843703          	ld	a4,-24(s0)
ffffffe000200e60:	01f00793          	li	a5,31
ffffffe000200e64:	02079793          	slli	a5,a5,0x20
ffffffe000200e68:	f8f762e3          	bltu	a4,a5,ffffffe000200dec <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe000200e6c:	00002517          	auipc	a0,0x2
ffffffe000200e70:	30450513          	addi	a0,a0,772 # ffffffe000203170 <_srodata+0x170>
ffffffe000200e74:	404010ef          	jal	ra,ffffffe000202278 <printk>
    return;
ffffffe000200e78:	00000013          	nop
}
ffffffe000200e7c:	01813083          	ld	ra,24(sp)
ffffffe000200e80:	01013403          	ld	s0,16(sp)
ffffffe000200e84:	02010113          	addi	sp,sp,32
ffffffe000200e88:	00008067          	ret

ffffffe000200e8c <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000200e8c:	fc010113          	addi	sp,sp,-64
ffffffe000200e90:	02813c23          	sd	s0,56(sp)
ffffffe000200e94:	04010413          	addi	s0,sp,64
ffffffe000200e98:	fca43c23          	sd	a0,-40(s0)
ffffffe000200e9c:	fcb43823          	sd	a1,-48(s0)
ffffffe000200ea0:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000200ea4:	fd843783          	ld	a5,-40(s0)
ffffffe000200ea8:	01e7d793          	srli	a5,a5,0x1e
ffffffe000200eac:	1ff7f793          	andi	a5,a5,511
ffffffe000200eb0:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000200eb4:	fd043783          	ld	a5,-48(s0)
ffffffe000200eb8:	00c7d793          	srli	a5,a5,0xc
ffffffe000200ebc:	00a79793          	slli	a5,a5,0xa
ffffffe000200ec0:	fc843703          	ld	a4,-56(s0)
ffffffe000200ec4:	00f767b3          	or	a5,a4,a5
ffffffe000200ec8:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000200ecc:	00006717          	auipc	a4,0x6
ffffffe000200ed0:	13470713          	addi	a4,a4,308 # ffffffe000207000 <early_pgtbl>
ffffffe000200ed4:	fe843783          	ld	a5,-24(s0)
ffffffe000200ed8:	00379793          	slli	a5,a5,0x3
ffffffe000200edc:	00f707b3          	add	a5,a4,a5
ffffffe000200ee0:	fe043703          	ld	a4,-32(s0)
ffffffe000200ee4:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe000200ee8:	00000013          	nop
ffffffe000200eec:	03813403          	ld	s0,56(sp)
ffffffe000200ef0:	04010113          	addi	sp,sp,64
ffffffe000200ef4:	00008067          	ret

ffffffe000200ef8 <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe000200ef8:	fc010113          	addi	sp,sp,-64
ffffffe000200efc:	02113c23          	sd	ra,56(sp)
ffffffe000200f00:	02813823          	sd	s0,48(sp)
ffffffe000200f04:	04010413          	addi	s0,sp,64
ffffffe000200f08:	fca43c23          	sd	a0,-40(s0)
ffffffe000200f0c:	fcb43823          	sd	a1,-48(s0)
ffffffe000200f10:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000200f14:	bc8ff0ef          	jal	ra,ffffffe0002002dc <kalloc>
ffffffe000200f18:	00050793          	mv	a5,a0
ffffffe000200f1c:	00078713          	mv	a4,a5
ffffffe000200f20:	04100793          	li	a5,65
ffffffe000200f24:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f28:	00f707b3          	add	a5,a4,a5
ffffffe000200f2c:	fef43423          	sd	a5,-24(s0)
    // memset((void *)pte, 0x0, PGSIZE);
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000200f30:	fe843783          	ld	a5,-24(s0)
ffffffe000200f34:	00c7d793          	srli	a5,a5,0xc
ffffffe000200f38:	00a79693          	slli	a3,a5,0xa
ffffffe000200f3c:	fd043783          	ld	a5,-48(s0)
ffffffe000200f40:	00379793          	slli	a5,a5,0x3
ffffffe000200f44:	fd843703          	ld	a4,-40(s0)
ffffffe000200f48:	00f707b3          	add	a5,a4,a5
ffffffe000200f4c:	fc843703          	ld	a4,-56(s0)
ffffffe000200f50:	00e6e733          	or	a4,a3,a4
ffffffe000200f54:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe000200f58:	fd043783          	ld	a5,-48(s0)
ffffffe000200f5c:	00379793          	slli	a5,a5,0x3
ffffffe000200f60:	fd843703          	ld	a4,-40(s0)
ffffffe000200f64:	00f707b3          	add	a5,a4,a5
ffffffe000200f68:	0007b783          	ld	a5,0(a5)
}
ffffffe000200f6c:	00078513          	mv	a0,a5
ffffffe000200f70:	03813083          	ld	ra,56(sp)
ffffffe000200f74:	03013403          	ld	s0,48(sp)
ffffffe000200f78:	04010113          	addi	sp,sp,64
ffffffe000200f7c:	00008067          	ret

ffffffe000200f80 <setup_vm_final>:

void setup_vm_final() {
ffffffe000200f80:	f9010113          	addi	sp,sp,-112
ffffffe000200f84:	06113423          	sd	ra,104(sp)
ffffffe000200f88:	06813023          	sd	s0,96(sp)
ffffffe000200f8c:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe000200f90:	00002517          	auipc	a0,0x2
ffffffe000200f94:	1f850513          	addi	a0,a0,504 # ffffffe000203188 <_srodata+0x188>
ffffffe000200f98:	2e0010ef          	jal	ra,ffffffe000202278 <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000200f9c:	00001637          	lui	a2,0x1
ffffffe000200fa0:	00000593          	li	a1,0
ffffffe000200fa4:	00007517          	auipc	a0,0x7
ffffffe000200fa8:	05c50513          	addi	a0,a0,92 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200fac:	3ec010ef          	jal	ra,ffffffe000202398 <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000200fb0:	40100793          	li	a5,1025
ffffffe000200fb4:	01579793          	slli	a5,a5,0x15
ffffffe000200fb8:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000200fbc:	f00017b7          	lui	a5,0xf0001
ffffffe000200fc0:	00979793          	slli	a5,a5,0x9
ffffffe000200fc4:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe000200fc8:	01100793          	li	a5,17
ffffffe000200fcc:	01b79793          	slli	a5,a5,0x1b
ffffffe000200fd0:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000200fd4:	c0100793          	li	a5,-1023
ffffffe000200fd8:	01b79793          	slli	a5,a5,0x1b
ffffffe000200fdc:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000200fe0:	fe043783          	ld	a5,-32(s0)
ffffffe000200fe4:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe000200fe8:	00001717          	auipc	a4,0x1
ffffffe000200fec:	42070713          	addi	a4,a4,1056 # ffffffe000202408 <_etext>
ffffffe000200ff0:	000017b7          	lui	a5,0x1
ffffffe000200ff4:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200ff8:	00f70733          	add	a4,a4,a5
ffffffe000200ffc:	fffff7b7          	lui	a5,0xfffff
ffffffe000201000:	00f777b3          	and	a5,a4,a5
ffffffe000201004:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe000201008:	fc843703          	ld	a4,-56(s0)
ffffffe00020100c:	04100793          	li	a5,65
ffffffe000201010:	01f79793          	slli	a5,a5,0x1f
ffffffe000201014:	00f70633          	add	a2,a4,a5
ffffffe000201018:	fc043703          	ld	a4,-64(s0)
ffffffe00020101c:	fc843783          	ld	a5,-56(s0)
ffffffe000201020:	40f707b3          	sub	a5,a4,a5
ffffffe000201024:	00b00713          	li	a4,11
ffffffe000201028:	00078693          	mv	a3,a5
ffffffe00020102c:	fc843583          	ld	a1,-56(s0)
ffffffe000201030:	00007517          	auipc	a0,0x7
ffffffe000201034:	fd050513          	addi	a0,a0,-48 # ffffffe000208000 <swapper_pg_dir>
ffffffe000201038:	160000ef          	jal	ra,ffffffe000201198 <create_mapping>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe00020103c:	fc043783          	ld	a5,-64(s0)
ffffffe000201040:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe000201044:	00002717          	auipc	a4,0x2
ffffffe000201048:	27470713          	addi	a4,a4,628 # ffffffe0002032b8 <_erodata>
ffffffe00020104c:	000017b7          	lui	a5,0x1
ffffffe000201050:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201054:	00f70733          	add	a4,a4,a5
ffffffe000201058:	fffff7b7          	lui	a5,0xfffff
ffffffe00020105c:	00f777b3          	and	a5,a4,a5
ffffffe000201060:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe000201064:	fb843703          	ld	a4,-72(s0)
ffffffe000201068:	04100793          	li	a5,65
ffffffe00020106c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201070:	00f70633          	add	a2,a4,a5
ffffffe000201074:	fb043703          	ld	a4,-80(s0)
ffffffe000201078:	fb843783          	ld	a5,-72(s0)
ffffffe00020107c:	40f707b3          	sub	a5,a4,a5
ffffffe000201080:	00300713          	li	a4,3
ffffffe000201084:	00078693          	mv	a3,a5
ffffffe000201088:	fb843583          	ld	a1,-72(s0)
ffffffe00020108c:	00007517          	auipc	a0,0x7
ffffffe000201090:	f7450513          	addi	a0,a0,-140 # ffffffe000208000 <swapper_pg_dir>
ffffffe000201094:	104000ef          	jal	ra,ffffffe000201198 <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx\n", rodata_start, rodata_end);
ffffffe000201098:	fb043603          	ld	a2,-80(s0)
ffffffe00020109c:	fb843583          	ld	a1,-72(s0)
ffffffe0002010a0:	00002517          	auipc	a0,0x2
ffffffe0002010a4:	10050513          	addi	a0,a0,256 # ffffffe0002031a0 <_srodata+0x1a0>
ffffffe0002010a8:	1d0010ef          	jal	ra,ffffffe000202278 <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe0002010ac:	fb043783          	ld	a5,-80(s0)
ffffffe0002010b0:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe0002010b4:	fd043783          	ld	a5,-48(s0)
ffffffe0002010b8:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe0002010bc:	fa843703          	ld	a4,-88(s0)
ffffffe0002010c0:	04100793          	li	a5,65
ffffffe0002010c4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002010c8:	00f70633          	add	a2,a4,a5
ffffffe0002010cc:	fa043703          	ld	a4,-96(s0)
ffffffe0002010d0:	fa843783          	ld	a5,-88(s0)
ffffffe0002010d4:	40f707b3          	sub	a5,a4,a5
ffffffe0002010d8:	00700713          	li	a4,7
ffffffe0002010dc:	00078693          	mv	a3,a5
ffffffe0002010e0:	fa843583          	ld	a1,-88(s0)
ffffffe0002010e4:	00007517          	auipc	a0,0x7
ffffffe0002010e8:	f1c50513          	addi	a0,a0,-228 # ffffffe000208000 <swapper_pg_dir>
ffffffe0002010ec:	0ac000ef          	jal	ra,ffffffe000201198 <create_mapping>
    printk("data_start = %lx, data_end = %lx\n", data_start, data_end);
ffffffe0002010f0:	fa043603          	ld	a2,-96(s0)
ffffffe0002010f4:	fa843583          	ld	a1,-88(s0)
ffffffe0002010f8:	00002517          	auipc	a0,0x2
ffffffe0002010fc:	0d050513          	addi	a0,a0,208 # ffffffe0002031c8 <_srodata+0x1c8>
ffffffe000201100:	178010ef          	jal	ra,ffffffe000202278 <printk>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000201104:	00007517          	auipc	a0,0x7
ffffffe000201108:	efc50513          	addi	a0,a0,-260 # ffffffe000208000 <swapper_pg_dir>
ffffffe00020110c:	044000ef          	jal	ra,ffffffe000201150 <get_satp>
ffffffe000201110:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000201114:	f9843783          	ld	a5,-104(s0)
ffffffe000201118:	f8f43823          	sd	a5,-112(s0)
ffffffe00020111c:	f9043783          	ld	a5,-112(s0)
ffffffe000201120:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe000201124:	f9843583          	ld	a1,-104(s0)
ffffffe000201128:	00002517          	auipc	a0,0x2
ffffffe00020112c:	0c850513          	addi	a0,a0,200 # ffffffe0002031f0 <_srodata+0x1f0>
ffffffe000201130:	148010ef          	jal	ra,ffffffe000202278 <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201134:	12000073          	sfence.vma

    // flush icache
    asm volatile("fence.i");
ffffffe000201138:	0000100f          	fence.i
    return;
ffffffe00020113c:	00000013          	nop
}
ffffffe000201140:	06813083          	ld	ra,104(sp)
ffffffe000201144:	06013403          	ld	s0,96(sp)
ffffffe000201148:	07010113          	addi	sp,sp,112
ffffffe00020114c:	00008067          	ret

ffffffe000201150 <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe000201150:	fd010113          	addi	sp,sp,-48
ffffffe000201154:	02813423          	sd	s0,40(sp)
ffffffe000201158:	03010413          	addi	s0,sp,48
ffffffe00020115c:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe000201160:	fd843703          	ld	a4,-40(s0)
ffffffe000201164:	04100793          	li	a5,65
ffffffe000201168:	01f79793          	slli	a5,a5,0x1f
ffffffe00020116c:	00f707b3          	add	a5,a4,a5
ffffffe000201170:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe000201174:	fe843783          	ld	a5,-24(s0)
ffffffe000201178:	00c7d713          	srli	a4,a5,0xc
ffffffe00020117c:	fff00793          	li	a5,-1
ffffffe000201180:	03f79793          	slli	a5,a5,0x3f
ffffffe000201184:	00f767b3          	or	a5,a4,a5
}
ffffffe000201188:	00078513          	mv	a0,a5
ffffffe00020118c:	02813403          	ld	s0,40(sp)
ffffffe000201190:	03010113          	addi	sp,sp,48
ffffffe000201194:	00008067          	ret

ffffffe000201198 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201198:	fb010113          	addi	sp,sp,-80
ffffffe00020119c:	04113423          	sd	ra,72(sp)
ffffffe0002011a0:	04813023          	sd	s0,64(sp)
ffffffe0002011a4:	05010413          	addi	s0,sp,80
ffffffe0002011a8:	fca43c23          	sd	a0,-40(s0)
ffffffe0002011ac:	fcb43823          	sd	a1,-48(s0)
ffffffe0002011b0:	fcc43423          	sd	a2,-56(s0)
ffffffe0002011b4:	fcd43023          	sd	a3,-64(s0)
ffffffe0002011b8:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe0002011bc:	fc043683          	ld	a3,-64(s0)
ffffffe0002011c0:	fc843603          	ld	a2,-56(s0)
ffffffe0002011c4:	fd043583          	ld	a1,-48(s0)
ffffffe0002011c8:	00002517          	auipc	a0,0x2
ffffffe0002011cc:	03850513          	addi	a0,a0,56 # ffffffe000203200 <_srodata+0x200>
ffffffe0002011d0:	0a8010ef          	jal	ra,ffffffe000202278 <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe0002011d4:	fd043783          	ld	a5,-48(s0)
ffffffe0002011d8:	fef43423          	sd	a5,-24(s0)
ffffffe0002011dc:	fc843783          	ld	a5,-56(s0)
ffffffe0002011e0:	fef43023          	sd	a5,-32(s0)
ffffffe0002011e4:	0380006f          	j	ffffffe00020121c <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe0002011e8:	fb843683          	ld	a3,-72(s0)
ffffffe0002011ec:	fe043603          	ld	a2,-32(s0)
ffffffe0002011f0:	fe843583          	ld	a1,-24(s0)
ffffffe0002011f4:	fd843503          	ld	a0,-40(s0)
ffffffe0002011f8:	050000ef          	jal	ra,ffffffe000201248 <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe0002011fc:	fe843703          	ld	a4,-24(s0)
ffffffe000201200:	000017b7          	lui	a5,0x1
ffffffe000201204:	00f707b3          	add	a5,a4,a5
ffffffe000201208:	fef43423          	sd	a5,-24(s0)
ffffffe00020120c:	fe043703          	ld	a4,-32(s0)
ffffffe000201210:	000017b7          	lui	a5,0x1
ffffffe000201214:	00f707b3          	add	a5,a4,a5
ffffffe000201218:	fef43023          	sd	a5,-32(s0)
ffffffe00020121c:	fd043703          	ld	a4,-48(s0)
ffffffe000201220:	fc043783          	ld	a5,-64(s0)
ffffffe000201224:	00f707b3          	add	a5,a4,a5
ffffffe000201228:	fe843703          	ld	a4,-24(s0)
ffffffe00020122c:	faf76ee3          	bltu	a4,a5,ffffffe0002011e8 <create_mapping+0x50>
   }
}
ffffffe000201230:	00000013          	nop
ffffffe000201234:	00000013          	nop
ffffffe000201238:	04813083          	ld	ra,72(sp)
ffffffe00020123c:	04013403          	ld	s0,64(sp)
ffffffe000201240:	05010113          	addi	sp,sp,80
ffffffe000201244:	00008067          	ret

ffffffe000201248 <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201248:	f9010113          	addi	sp,sp,-112
ffffffe00020124c:	06113423          	sd	ra,104(sp)
ffffffe000201250:	06813023          	sd	s0,96(sp)
ffffffe000201254:	07010413          	addi	s0,sp,112
ffffffe000201258:	faa43423          	sd	a0,-88(s0)
ffffffe00020125c:	fab43023          	sd	a1,-96(s0)
ffffffe000201260:	f8c43c23          	sd	a2,-104(s0)
ffffffe000201264:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000201268:	fa043783          	ld	a5,-96(s0)
ffffffe00020126c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201270:	1ff7f793          	andi	a5,a5,511
ffffffe000201274:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000201278:	fa043783          	ld	a5,-96(s0)
ffffffe00020127c:	0157d793          	srli	a5,a5,0x15
ffffffe000201280:	1ff7f793          	andi	a5,a5,511
ffffffe000201284:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000201288:	fa043783          	ld	a5,-96(s0)
ffffffe00020128c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201290:	1ff7f793          	andi	a5,a5,511
ffffffe000201294:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe000201298:	fd843783          	ld	a5,-40(s0)
ffffffe00020129c:	00379793          	slli	a5,a5,0x3
ffffffe0002012a0:	fa843703          	ld	a4,-88(s0)
ffffffe0002012a4:	00f707b3          	add	a5,a4,a5
ffffffe0002012a8:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe0002012ac:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe0002012b0:	fe843783          	ld	a5,-24(s0)
ffffffe0002012b4:	0017f793          	andi	a5,a5,1
ffffffe0002012b8:	00079c63          	bnez	a5,ffffffe0002012d0 <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe0002012bc:	00100613          	li	a2,1
ffffffe0002012c0:	fd843583          	ld	a1,-40(s0)
ffffffe0002012c4:	fa843503          	ld	a0,-88(s0)
ffffffe0002012c8:	c31ff0ef          	jal	ra,ffffffe000200ef8 <setup_pgtbl>
ffffffe0002012cc:	fea43423          	sd	a0,-24(s0)
    }

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12)); // VA
ffffffe0002012d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002012d4:	00a7d793          	srli	a5,a5,0xa
ffffffe0002012d8:	00c79793          	slli	a5,a5,0xc
ffffffe0002012dc:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe0002012e0:	fd043783          	ld	a5,-48(s0)
ffffffe0002012e4:	00379793          	slli	a5,a5,0x3
ffffffe0002012e8:	fc043703          	ld	a4,-64(s0)
ffffffe0002012ec:	00f707b3          	add	a5,a4,a5
ffffffe0002012f0:	0007b783          	ld	a5,0(a5)
ffffffe0002012f4:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe0002012f8:	fe043783          	ld	a5,-32(s0)
ffffffe0002012fc:	0017f793          	andi	a5,a5,1
ffffffe000201300:	00079c63          	bnez	a5,ffffffe000201318 <map_vm_final+0xd0>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe000201304:	00100613          	li	a2,1
ffffffe000201308:	fd043583          	ld	a1,-48(s0)
ffffffe00020130c:	fc043503          	ld	a0,-64(s0)
ffffffe000201310:	be9ff0ef          	jal	ra,ffffffe000200ef8 <setup_pgtbl>
ffffffe000201314:	fea43023          	sd	a0,-32(s0)
    }

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12));// VA
ffffffe000201318:	fe043783          	ld	a5,-32(s0)
ffffffe00020131c:	00a7d793          	srli	a5,a5,0xa
ffffffe000201320:	00c79793          	slli	a5,a5,0xc
ffffffe000201324:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe000201328:	f9043783          	ld	a5,-112(s0)
ffffffe00020132c:	0017e793          	ori	a5,a5,1
ffffffe000201330:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe000201334:	f9843783          	ld	a5,-104(s0)
ffffffe000201338:	00c7d793          	srli	a5,a5,0xc
ffffffe00020133c:	00a79693          	slli	a3,a5,0xa
ffffffe000201340:	fc843783          	ld	a5,-56(s0)
ffffffe000201344:	00379793          	slli	a5,a5,0x3
ffffffe000201348:	fb843703          	ld	a4,-72(s0)
ffffffe00020134c:	00f707b3          	add	a5,a4,a5
ffffffe000201350:	f9043703          	ld	a4,-112(s0)
ffffffe000201354:	00e6e733          	or	a4,a3,a4
ffffffe000201358:	00e7b023          	sd	a4,0(a5)
ffffffe00020135c:	00000013          	nop
ffffffe000201360:	06813083          	ld	ra,104(sp)
ffffffe000201364:	06013403          	ld	s0,96(sp)
ffffffe000201368:	07010113          	addi	sp,sp,112
ffffffe00020136c:	00008067          	ret

ffffffe000201370 <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
ffffffe000201370:	ff010113          	addi	sp,sp,-16
ffffffe000201374:	00113423          	sd	ra,8(sp)
ffffffe000201378:	00813023          	sd	s0,0(sp)
ffffffe00020137c:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000201380:	00002517          	auipc	a0,0x2
ffffffe000201384:	ea850513          	addi	a0,a0,-344 # ffffffe000203228 <_srodata+0x228>
ffffffe000201388:	6f1000ef          	jal	ra,ffffffe000202278 <printk>
    printk(" ZJU Operating System\n");
ffffffe00020138c:	00002517          	auipc	a0,0x2
ffffffe000201390:	ea450513          	addi	a0,a0,-348 # ffffffe000203230 <_srodata+0x230>
ffffffe000201394:	6e5000ef          	jal	ra,ffffffe000202278 <printk>

    test();
ffffffe000201398:	01c000ef          	jal	ra,ffffffe0002013b4 <test>
    return 0;
ffffffe00020139c:	00000793          	li	a5,0
}
ffffffe0002013a0:	00078513          	mv	a0,a5
ffffffe0002013a4:	00813083          	ld	ra,8(sp)
ffffffe0002013a8:	00013403          	ld	s0,0(sp)
ffffffe0002013ac:	01010113          	addi	sp,sp,16
ffffffe0002013b0:	00008067          	ret

ffffffe0002013b4 <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe0002013b4:	fe010113          	addi	sp,sp,-32
ffffffe0002013b8:	00113c23          	sd	ra,24(sp)
ffffffe0002013bc:	00813823          	sd	s0,16(sp)
ffffffe0002013c0:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe0002013c4:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe0002013c8:	00002517          	auipc	a0,0x2
ffffffe0002013cc:	e8050513          	addi	a0,a0,-384 # ffffffe000203248 <_srodata+0x248>
ffffffe0002013d0:	6a9000ef          	jal	ra,ffffffe000202278 <printk>
    while (1)
    {
        i++;
ffffffe0002013d4:	fec42783          	lw	a5,-20(s0)
ffffffe0002013d8:	0017879b          	addiw	a5,a5,1
ffffffe0002013dc:	fef42623          	sw	a5,-20(s0)
ffffffe0002013e0:	ff5ff06f          	j	ffffffe0002013d4 <test+0x20>

ffffffe0002013e4 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe0002013e4:	fe010113          	addi	sp,sp,-32
ffffffe0002013e8:	00113c23          	sd	ra,24(sp)
ffffffe0002013ec:	00813823          	sd	s0,16(sp)
ffffffe0002013f0:	02010413          	addi	s0,sp,32
ffffffe0002013f4:	00050793          	mv	a5,a0
ffffffe0002013f8:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe0002013fc:	fec42783          	lw	a5,-20(s0)
ffffffe000201400:	0ff7f793          	zext.b	a5,a5
ffffffe000201404:	00078513          	mv	a0,a5
ffffffe000201408:	83dff0ef          	jal	ra,ffffffe000200c44 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe00020140c:	fec42783          	lw	a5,-20(s0)
ffffffe000201410:	0ff7f793          	zext.b	a5,a5
ffffffe000201414:	0007879b          	sext.w	a5,a5
}
ffffffe000201418:	00078513          	mv	a0,a5
ffffffe00020141c:	01813083          	ld	ra,24(sp)
ffffffe000201420:	01013403          	ld	s0,16(sp)
ffffffe000201424:	02010113          	addi	sp,sp,32
ffffffe000201428:	00008067          	ret

ffffffe00020142c <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe00020142c:	fe010113          	addi	sp,sp,-32
ffffffe000201430:	00813c23          	sd	s0,24(sp)
ffffffe000201434:	02010413          	addi	s0,sp,32
ffffffe000201438:	00050793          	mv	a5,a0
ffffffe00020143c:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000201440:	fec42783          	lw	a5,-20(s0)
ffffffe000201444:	0007871b          	sext.w	a4,a5
ffffffe000201448:	02000793          	li	a5,32
ffffffe00020144c:	02f70263          	beq	a4,a5,ffffffe000201470 <isspace+0x44>
ffffffe000201450:	fec42783          	lw	a5,-20(s0)
ffffffe000201454:	0007871b          	sext.w	a4,a5
ffffffe000201458:	00800793          	li	a5,8
ffffffe00020145c:	00e7de63          	bge	a5,a4,ffffffe000201478 <isspace+0x4c>
ffffffe000201460:	fec42783          	lw	a5,-20(s0)
ffffffe000201464:	0007871b          	sext.w	a4,a5
ffffffe000201468:	00d00793          	li	a5,13
ffffffe00020146c:	00e7c663          	blt	a5,a4,ffffffe000201478 <isspace+0x4c>
ffffffe000201470:	00100793          	li	a5,1
ffffffe000201474:	0080006f          	j	ffffffe00020147c <isspace+0x50>
ffffffe000201478:	00000793          	li	a5,0
}
ffffffe00020147c:	00078513          	mv	a0,a5
ffffffe000201480:	01813403          	ld	s0,24(sp)
ffffffe000201484:	02010113          	addi	sp,sp,32
ffffffe000201488:	00008067          	ret

ffffffe00020148c <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe00020148c:	fb010113          	addi	sp,sp,-80
ffffffe000201490:	04113423          	sd	ra,72(sp)
ffffffe000201494:	04813023          	sd	s0,64(sp)
ffffffe000201498:	05010413          	addi	s0,sp,80
ffffffe00020149c:	fca43423          	sd	a0,-56(s0)
ffffffe0002014a0:	fcb43023          	sd	a1,-64(s0)
ffffffe0002014a4:	00060793          	mv	a5,a2
ffffffe0002014a8:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe0002014ac:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe0002014b0:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe0002014b4:	fc843783          	ld	a5,-56(s0)
ffffffe0002014b8:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe0002014bc:	0100006f          	j	ffffffe0002014cc <strtol+0x40>
        p++;
ffffffe0002014c0:	fd843783          	ld	a5,-40(s0)
ffffffe0002014c4:	00178793          	addi	a5,a5,1
ffffffe0002014c8:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe0002014cc:	fd843783          	ld	a5,-40(s0)
ffffffe0002014d0:	0007c783          	lbu	a5,0(a5)
ffffffe0002014d4:	0007879b          	sext.w	a5,a5
ffffffe0002014d8:	00078513          	mv	a0,a5
ffffffe0002014dc:	f51ff0ef          	jal	ra,ffffffe00020142c <isspace>
ffffffe0002014e0:	00050793          	mv	a5,a0
ffffffe0002014e4:	fc079ee3          	bnez	a5,ffffffe0002014c0 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe0002014e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002014ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002014f0:	00078713          	mv	a4,a5
ffffffe0002014f4:	02d00793          	li	a5,45
ffffffe0002014f8:	00f71e63          	bne	a4,a5,ffffffe000201514 <strtol+0x88>
        neg = true;
ffffffe0002014fc:	00100793          	li	a5,1
ffffffe000201500:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe000201504:	fd843783          	ld	a5,-40(s0)
ffffffe000201508:	00178793          	addi	a5,a5,1
ffffffe00020150c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201510:	0240006f          	j	ffffffe000201534 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe000201514:	fd843783          	ld	a5,-40(s0)
ffffffe000201518:	0007c783          	lbu	a5,0(a5)
ffffffe00020151c:	00078713          	mv	a4,a5
ffffffe000201520:	02b00793          	li	a5,43
ffffffe000201524:	00f71863          	bne	a4,a5,ffffffe000201534 <strtol+0xa8>
        p++;
ffffffe000201528:	fd843783          	ld	a5,-40(s0)
ffffffe00020152c:	00178793          	addi	a5,a5,1
ffffffe000201530:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe000201534:	fbc42783          	lw	a5,-68(s0)
ffffffe000201538:	0007879b          	sext.w	a5,a5
ffffffe00020153c:	06079c63          	bnez	a5,ffffffe0002015b4 <strtol+0x128>
        if (*p == '0') {
ffffffe000201540:	fd843783          	ld	a5,-40(s0)
ffffffe000201544:	0007c783          	lbu	a5,0(a5)
ffffffe000201548:	00078713          	mv	a4,a5
ffffffe00020154c:	03000793          	li	a5,48
ffffffe000201550:	04f71e63          	bne	a4,a5,ffffffe0002015ac <strtol+0x120>
            p++;
ffffffe000201554:	fd843783          	ld	a5,-40(s0)
ffffffe000201558:	00178793          	addi	a5,a5,1
ffffffe00020155c:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000201560:	fd843783          	ld	a5,-40(s0)
ffffffe000201564:	0007c783          	lbu	a5,0(a5)
ffffffe000201568:	00078713          	mv	a4,a5
ffffffe00020156c:	07800793          	li	a5,120
ffffffe000201570:	00f70c63          	beq	a4,a5,ffffffe000201588 <strtol+0xfc>
ffffffe000201574:	fd843783          	ld	a5,-40(s0)
ffffffe000201578:	0007c783          	lbu	a5,0(a5)
ffffffe00020157c:	00078713          	mv	a4,a5
ffffffe000201580:	05800793          	li	a5,88
ffffffe000201584:	00f71e63          	bne	a4,a5,ffffffe0002015a0 <strtol+0x114>
                base = 16;
ffffffe000201588:	01000793          	li	a5,16
ffffffe00020158c:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000201590:	fd843783          	ld	a5,-40(s0)
ffffffe000201594:	00178793          	addi	a5,a5,1
ffffffe000201598:	fcf43c23          	sd	a5,-40(s0)
ffffffe00020159c:	0180006f          	j	ffffffe0002015b4 <strtol+0x128>
            } else {
                base = 8;
ffffffe0002015a0:	00800793          	li	a5,8
ffffffe0002015a4:	faf42e23          	sw	a5,-68(s0)
ffffffe0002015a8:	00c0006f          	j	ffffffe0002015b4 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe0002015ac:	00a00793          	li	a5,10
ffffffe0002015b0:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe0002015b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002015b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002015bc:	00078713          	mv	a4,a5
ffffffe0002015c0:	02f00793          	li	a5,47
ffffffe0002015c4:	02e7f863          	bgeu	a5,a4,ffffffe0002015f4 <strtol+0x168>
ffffffe0002015c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002015cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002015d0:	00078713          	mv	a4,a5
ffffffe0002015d4:	03900793          	li	a5,57
ffffffe0002015d8:	00e7ee63          	bltu	a5,a4,ffffffe0002015f4 <strtol+0x168>
            digit = *p - '0';
ffffffe0002015dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002015e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002015e4:	0007879b          	sext.w	a5,a5
ffffffe0002015e8:	fd07879b          	addiw	a5,a5,-48
ffffffe0002015ec:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002015f0:	0800006f          	j	ffffffe000201670 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe0002015f4:	fd843783          	ld	a5,-40(s0)
ffffffe0002015f8:	0007c783          	lbu	a5,0(a5)
ffffffe0002015fc:	00078713          	mv	a4,a5
ffffffe000201600:	06000793          	li	a5,96
ffffffe000201604:	02e7f863          	bgeu	a5,a4,ffffffe000201634 <strtol+0x1a8>
ffffffe000201608:	fd843783          	ld	a5,-40(s0)
ffffffe00020160c:	0007c783          	lbu	a5,0(a5)
ffffffe000201610:	00078713          	mv	a4,a5
ffffffe000201614:	07a00793          	li	a5,122
ffffffe000201618:	00e7ee63          	bltu	a5,a4,ffffffe000201634 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe00020161c:	fd843783          	ld	a5,-40(s0)
ffffffe000201620:	0007c783          	lbu	a5,0(a5)
ffffffe000201624:	0007879b          	sext.w	a5,a5
ffffffe000201628:	fa97879b          	addiw	a5,a5,-87
ffffffe00020162c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201630:	0400006f          	j	ffffffe000201670 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe000201634:	fd843783          	ld	a5,-40(s0)
ffffffe000201638:	0007c783          	lbu	a5,0(a5)
ffffffe00020163c:	00078713          	mv	a4,a5
ffffffe000201640:	04000793          	li	a5,64
ffffffe000201644:	06e7f863          	bgeu	a5,a4,ffffffe0002016b4 <strtol+0x228>
ffffffe000201648:	fd843783          	ld	a5,-40(s0)
ffffffe00020164c:	0007c783          	lbu	a5,0(a5)
ffffffe000201650:	00078713          	mv	a4,a5
ffffffe000201654:	05a00793          	li	a5,90
ffffffe000201658:	04e7ee63          	bltu	a5,a4,ffffffe0002016b4 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe00020165c:	fd843783          	ld	a5,-40(s0)
ffffffe000201660:	0007c783          	lbu	a5,0(a5)
ffffffe000201664:	0007879b          	sext.w	a5,a5
ffffffe000201668:	fc97879b          	addiw	a5,a5,-55
ffffffe00020166c:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000201670:	fd442783          	lw	a5,-44(s0)
ffffffe000201674:	00078713          	mv	a4,a5
ffffffe000201678:	fbc42783          	lw	a5,-68(s0)
ffffffe00020167c:	0007071b          	sext.w	a4,a4
ffffffe000201680:	0007879b          	sext.w	a5,a5
ffffffe000201684:	02f75663          	bge	a4,a5,ffffffe0002016b0 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000201688:	fbc42703          	lw	a4,-68(s0)
ffffffe00020168c:	fe843783          	ld	a5,-24(s0)
ffffffe000201690:	02f70733          	mul	a4,a4,a5
ffffffe000201694:	fd442783          	lw	a5,-44(s0)
ffffffe000201698:	00f707b3          	add	a5,a4,a5
ffffffe00020169c:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe0002016a0:	fd843783          	ld	a5,-40(s0)
ffffffe0002016a4:	00178793          	addi	a5,a5,1
ffffffe0002016a8:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe0002016ac:	f09ff06f          	j	ffffffe0002015b4 <strtol+0x128>
            break;
ffffffe0002016b0:	00000013          	nop
    }

    if (endptr) {
ffffffe0002016b4:	fc043783          	ld	a5,-64(s0)
ffffffe0002016b8:	00078863          	beqz	a5,ffffffe0002016c8 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe0002016bc:	fc043783          	ld	a5,-64(s0)
ffffffe0002016c0:	fd843703          	ld	a4,-40(s0)
ffffffe0002016c4:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe0002016c8:	fe744783          	lbu	a5,-25(s0)
ffffffe0002016cc:	0ff7f793          	zext.b	a5,a5
ffffffe0002016d0:	00078863          	beqz	a5,ffffffe0002016e0 <strtol+0x254>
ffffffe0002016d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002016d8:	40f007b3          	neg	a5,a5
ffffffe0002016dc:	0080006f          	j	ffffffe0002016e4 <strtol+0x258>
ffffffe0002016e0:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002016e4:	00078513          	mv	a0,a5
ffffffe0002016e8:	04813083          	ld	ra,72(sp)
ffffffe0002016ec:	04013403          	ld	s0,64(sp)
ffffffe0002016f0:	05010113          	addi	sp,sp,80
ffffffe0002016f4:	00008067          	ret

ffffffe0002016f8 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe0002016f8:	fd010113          	addi	sp,sp,-48
ffffffe0002016fc:	02113423          	sd	ra,40(sp)
ffffffe000201700:	02813023          	sd	s0,32(sp)
ffffffe000201704:	03010413          	addi	s0,sp,48
ffffffe000201708:	fca43c23          	sd	a0,-40(s0)
ffffffe00020170c:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe000201710:	fd043783          	ld	a5,-48(s0)
ffffffe000201714:	00079863          	bnez	a5,ffffffe000201724 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe000201718:	00002797          	auipc	a5,0x2
ffffffe00020171c:	b4878793          	addi	a5,a5,-1208 # ffffffe000203260 <_srodata+0x260>
ffffffe000201720:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe000201724:	fd043783          	ld	a5,-48(s0)
ffffffe000201728:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe00020172c:	0240006f          	j	ffffffe000201750 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe000201730:	fe843783          	ld	a5,-24(s0)
ffffffe000201734:	00178713          	addi	a4,a5,1
ffffffe000201738:	fee43423          	sd	a4,-24(s0)
ffffffe00020173c:	0007c783          	lbu	a5,0(a5)
ffffffe000201740:	0007871b          	sext.w	a4,a5
ffffffe000201744:	fd843783          	ld	a5,-40(s0)
ffffffe000201748:	00070513          	mv	a0,a4
ffffffe00020174c:	000780e7          	jalr	a5
    while (*p) {
ffffffe000201750:	fe843783          	ld	a5,-24(s0)
ffffffe000201754:	0007c783          	lbu	a5,0(a5)
ffffffe000201758:	fc079ce3          	bnez	a5,ffffffe000201730 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe00020175c:	fe843703          	ld	a4,-24(s0)
ffffffe000201760:	fd043783          	ld	a5,-48(s0)
ffffffe000201764:	40f707b3          	sub	a5,a4,a5
ffffffe000201768:	0007879b          	sext.w	a5,a5
}
ffffffe00020176c:	00078513          	mv	a0,a5
ffffffe000201770:	02813083          	ld	ra,40(sp)
ffffffe000201774:	02013403          	ld	s0,32(sp)
ffffffe000201778:	03010113          	addi	sp,sp,48
ffffffe00020177c:	00008067          	ret

ffffffe000201780 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000201780:	f9010113          	addi	sp,sp,-112
ffffffe000201784:	06113423          	sd	ra,104(sp)
ffffffe000201788:	06813023          	sd	s0,96(sp)
ffffffe00020178c:	07010413          	addi	s0,sp,112
ffffffe000201790:	faa43423          	sd	a0,-88(s0)
ffffffe000201794:	fab43023          	sd	a1,-96(s0)
ffffffe000201798:	00060793          	mv	a5,a2
ffffffe00020179c:	f8d43823          	sd	a3,-112(s0)
ffffffe0002017a0:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe0002017a4:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002017a8:	0ff7f793          	zext.b	a5,a5
ffffffe0002017ac:	02078663          	beqz	a5,ffffffe0002017d8 <print_dec_int+0x58>
ffffffe0002017b0:	fa043703          	ld	a4,-96(s0)
ffffffe0002017b4:	fff00793          	li	a5,-1
ffffffe0002017b8:	03f79793          	slli	a5,a5,0x3f
ffffffe0002017bc:	00f71e63          	bne	a4,a5,ffffffe0002017d8 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe0002017c0:	00002597          	auipc	a1,0x2
ffffffe0002017c4:	aa858593          	addi	a1,a1,-1368 # ffffffe000203268 <_srodata+0x268>
ffffffe0002017c8:	fa843503          	ld	a0,-88(s0)
ffffffe0002017cc:	f2dff0ef          	jal	ra,ffffffe0002016f8 <puts_wo_nl>
ffffffe0002017d0:	00050793          	mv	a5,a0
ffffffe0002017d4:	2a00006f          	j	ffffffe000201a74 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe0002017d8:	f9043783          	ld	a5,-112(s0)
ffffffe0002017dc:	00c7a783          	lw	a5,12(a5)
ffffffe0002017e0:	00079a63          	bnez	a5,ffffffe0002017f4 <print_dec_int+0x74>
ffffffe0002017e4:	fa043783          	ld	a5,-96(s0)
ffffffe0002017e8:	00079663          	bnez	a5,ffffffe0002017f4 <print_dec_int+0x74>
        return 0;
ffffffe0002017ec:	00000793          	li	a5,0
ffffffe0002017f0:	2840006f          	j	ffffffe000201a74 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe0002017f4:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe0002017f8:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002017fc:	0ff7f793          	zext.b	a5,a5
ffffffe000201800:	02078063          	beqz	a5,ffffffe000201820 <print_dec_int+0xa0>
ffffffe000201804:	fa043783          	ld	a5,-96(s0)
ffffffe000201808:	0007dc63          	bgez	a5,ffffffe000201820 <print_dec_int+0xa0>
        neg = true;
ffffffe00020180c:	00100793          	li	a5,1
ffffffe000201810:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000201814:	fa043783          	ld	a5,-96(s0)
ffffffe000201818:	40f007b3          	neg	a5,a5
ffffffe00020181c:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000201820:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe000201824:	f9f44783          	lbu	a5,-97(s0)
ffffffe000201828:	0ff7f793          	zext.b	a5,a5
ffffffe00020182c:	02078863          	beqz	a5,ffffffe00020185c <print_dec_int+0xdc>
ffffffe000201830:	fef44783          	lbu	a5,-17(s0)
ffffffe000201834:	0ff7f793          	zext.b	a5,a5
ffffffe000201838:	00079e63          	bnez	a5,ffffffe000201854 <print_dec_int+0xd4>
ffffffe00020183c:	f9043783          	ld	a5,-112(s0)
ffffffe000201840:	0057c783          	lbu	a5,5(a5)
ffffffe000201844:	00079863          	bnez	a5,ffffffe000201854 <print_dec_int+0xd4>
ffffffe000201848:	f9043783          	ld	a5,-112(s0)
ffffffe00020184c:	0047c783          	lbu	a5,4(a5)
ffffffe000201850:	00078663          	beqz	a5,ffffffe00020185c <print_dec_int+0xdc>
ffffffe000201854:	00100793          	li	a5,1
ffffffe000201858:	0080006f          	j	ffffffe000201860 <print_dec_int+0xe0>
ffffffe00020185c:	00000793          	li	a5,0
ffffffe000201860:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000201864:	fd744783          	lbu	a5,-41(s0)
ffffffe000201868:	0017f793          	andi	a5,a5,1
ffffffe00020186c:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000201870:	fa043703          	ld	a4,-96(s0)
ffffffe000201874:	00a00793          	li	a5,10
ffffffe000201878:	02f777b3          	remu	a5,a4,a5
ffffffe00020187c:	0ff7f713          	zext.b	a4,a5
ffffffe000201880:	fe842783          	lw	a5,-24(s0)
ffffffe000201884:	0017869b          	addiw	a3,a5,1
ffffffe000201888:	fed42423          	sw	a3,-24(s0)
ffffffe00020188c:	0307071b          	addiw	a4,a4,48
ffffffe000201890:	0ff77713          	zext.b	a4,a4
ffffffe000201894:	ff078793          	addi	a5,a5,-16
ffffffe000201898:	008787b3          	add	a5,a5,s0
ffffffe00020189c:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe0002018a0:	fa043703          	ld	a4,-96(s0)
ffffffe0002018a4:	00a00793          	li	a5,10
ffffffe0002018a8:	02f757b3          	divu	a5,a4,a5
ffffffe0002018ac:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe0002018b0:	fa043783          	ld	a5,-96(s0)
ffffffe0002018b4:	fa079ee3          	bnez	a5,ffffffe000201870 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe0002018b8:	f9043783          	ld	a5,-112(s0)
ffffffe0002018bc:	00c7a783          	lw	a5,12(a5)
ffffffe0002018c0:	00078713          	mv	a4,a5
ffffffe0002018c4:	fff00793          	li	a5,-1
ffffffe0002018c8:	02f71063          	bne	a4,a5,ffffffe0002018e8 <print_dec_int+0x168>
ffffffe0002018cc:	f9043783          	ld	a5,-112(s0)
ffffffe0002018d0:	0037c783          	lbu	a5,3(a5)
ffffffe0002018d4:	00078a63          	beqz	a5,ffffffe0002018e8 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe0002018d8:	f9043783          	ld	a5,-112(s0)
ffffffe0002018dc:	0087a703          	lw	a4,8(a5)
ffffffe0002018e0:	f9043783          	ld	a5,-112(s0)
ffffffe0002018e4:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe0002018e8:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002018ec:	f9043783          	ld	a5,-112(s0)
ffffffe0002018f0:	0087a703          	lw	a4,8(a5)
ffffffe0002018f4:	fe842783          	lw	a5,-24(s0)
ffffffe0002018f8:	fcf42823          	sw	a5,-48(s0)
ffffffe0002018fc:	f9043783          	ld	a5,-112(s0)
ffffffe000201900:	00c7a783          	lw	a5,12(a5)
ffffffe000201904:	fcf42623          	sw	a5,-52(s0)
ffffffe000201908:	fd042783          	lw	a5,-48(s0)
ffffffe00020190c:	00078593          	mv	a1,a5
ffffffe000201910:	fcc42783          	lw	a5,-52(s0)
ffffffe000201914:	00078613          	mv	a2,a5
ffffffe000201918:	0006069b          	sext.w	a3,a2
ffffffe00020191c:	0005879b          	sext.w	a5,a1
ffffffe000201920:	00f6d463          	bge	a3,a5,ffffffe000201928 <print_dec_int+0x1a8>
ffffffe000201924:	00058613          	mv	a2,a1
ffffffe000201928:	0006079b          	sext.w	a5,a2
ffffffe00020192c:	40f707bb          	subw	a5,a4,a5
ffffffe000201930:	0007871b          	sext.w	a4,a5
ffffffe000201934:	fd744783          	lbu	a5,-41(s0)
ffffffe000201938:	0007879b          	sext.w	a5,a5
ffffffe00020193c:	40f707bb          	subw	a5,a4,a5
ffffffe000201940:	fef42023          	sw	a5,-32(s0)
ffffffe000201944:	0280006f          	j	ffffffe00020196c <print_dec_int+0x1ec>
        putch(' ');
ffffffe000201948:	fa843783          	ld	a5,-88(s0)
ffffffe00020194c:	02000513          	li	a0,32
ffffffe000201950:	000780e7          	jalr	a5
        ++written;
ffffffe000201954:	fe442783          	lw	a5,-28(s0)
ffffffe000201958:	0017879b          	addiw	a5,a5,1
ffffffe00020195c:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000201960:	fe042783          	lw	a5,-32(s0)
ffffffe000201964:	fff7879b          	addiw	a5,a5,-1
ffffffe000201968:	fef42023          	sw	a5,-32(s0)
ffffffe00020196c:	fe042783          	lw	a5,-32(s0)
ffffffe000201970:	0007879b          	sext.w	a5,a5
ffffffe000201974:	fcf04ae3          	bgtz	a5,ffffffe000201948 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000201978:	fd744783          	lbu	a5,-41(s0)
ffffffe00020197c:	0ff7f793          	zext.b	a5,a5
ffffffe000201980:	04078463          	beqz	a5,ffffffe0002019c8 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000201984:	fef44783          	lbu	a5,-17(s0)
ffffffe000201988:	0ff7f793          	zext.b	a5,a5
ffffffe00020198c:	00078663          	beqz	a5,ffffffe000201998 <print_dec_int+0x218>
ffffffe000201990:	02d00793          	li	a5,45
ffffffe000201994:	01c0006f          	j	ffffffe0002019b0 <print_dec_int+0x230>
ffffffe000201998:	f9043783          	ld	a5,-112(s0)
ffffffe00020199c:	0057c783          	lbu	a5,5(a5)
ffffffe0002019a0:	00078663          	beqz	a5,ffffffe0002019ac <print_dec_int+0x22c>
ffffffe0002019a4:	02b00793          	li	a5,43
ffffffe0002019a8:	0080006f          	j	ffffffe0002019b0 <print_dec_int+0x230>
ffffffe0002019ac:	02000793          	li	a5,32
ffffffe0002019b0:	fa843703          	ld	a4,-88(s0)
ffffffe0002019b4:	00078513          	mv	a0,a5
ffffffe0002019b8:	000700e7          	jalr	a4
        ++written;
ffffffe0002019bc:	fe442783          	lw	a5,-28(s0)
ffffffe0002019c0:	0017879b          	addiw	a5,a5,1
ffffffe0002019c4:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002019c8:	fe842783          	lw	a5,-24(s0)
ffffffe0002019cc:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002019d0:	0280006f          	j	ffffffe0002019f8 <print_dec_int+0x278>
        putch('0');
ffffffe0002019d4:	fa843783          	ld	a5,-88(s0)
ffffffe0002019d8:	03000513          	li	a0,48
ffffffe0002019dc:	000780e7          	jalr	a5
        ++written;
ffffffe0002019e0:	fe442783          	lw	a5,-28(s0)
ffffffe0002019e4:	0017879b          	addiw	a5,a5,1
ffffffe0002019e8:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002019ec:	fdc42783          	lw	a5,-36(s0)
ffffffe0002019f0:	0017879b          	addiw	a5,a5,1
ffffffe0002019f4:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002019f8:	f9043783          	ld	a5,-112(s0)
ffffffe0002019fc:	00c7a703          	lw	a4,12(a5)
ffffffe000201a00:	fd744783          	lbu	a5,-41(s0)
ffffffe000201a04:	0007879b          	sext.w	a5,a5
ffffffe000201a08:	40f707bb          	subw	a5,a4,a5
ffffffe000201a0c:	0007871b          	sext.w	a4,a5
ffffffe000201a10:	fdc42783          	lw	a5,-36(s0)
ffffffe000201a14:	0007879b          	sext.w	a5,a5
ffffffe000201a18:	fae7cee3          	blt	a5,a4,ffffffe0002019d4 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201a1c:	fe842783          	lw	a5,-24(s0)
ffffffe000201a20:	fff7879b          	addiw	a5,a5,-1
ffffffe000201a24:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201a28:	03c0006f          	j	ffffffe000201a64 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe000201a2c:	fd842783          	lw	a5,-40(s0)
ffffffe000201a30:	ff078793          	addi	a5,a5,-16
ffffffe000201a34:	008787b3          	add	a5,a5,s0
ffffffe000201a38:	fc87c783          	lbu	a5,-56(a5)
ffffffe000201a3c:	0007871b          	sext.w	a4,a5
ffffffe000201a40:	fa843783          	ld	a5,-88(s0)
ffffffe000201a44:	00070513          	mv	a0,a4
ffffffe000201a48:	000780e7          	jalr	a5
        ++written;
ffffffe000201a4c:	fe442783          	lw	a5,-28(s0)
ffffffe000201a50:	0017879b          	addiw	a5,a5,1
ffffffe000201a54:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201a58:	fd842783          	lw	a5,-40(s0)
ffffffe000201a5c:	fff7879b          	addiw	a5,a5,-1
ffffffe000201a60:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201a64:	fd842783          	lw	a5,-40(s0)
ffffffe000201a68:	0007879b          	sext.w	a5,a5
ffffffe000201a6c:	fc07d0e3          	bgez	a5,ffffffe000201a2c <print_dec_int+0x2ac>
    }

    return written;
ffffffe000201a70:	fe442783          	lw	a5,-28(s0)
}
ffffffe000201a74:	00078513          	mv	a0,a5
ffffffe000201a78:	06813083          	ld	ra,104(sp)
ffffffe000201a7c:	06013403          	ld	s0,96(sp)
ffffffe000201a80:	07010113          	addi	sp,sp,112
ffffffe000201a84:	00008067          	ret

ffffffe000201a88 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000201a88:	f4010113          	addi	sp,sp,-192
ffffffe000201a8c:	0a113c23          	sd	ra,184(sp)
ffffffe000201a90:	0a813823          	sd	s0,176(sp)
ffffffe000201a94:	0c010413          	addi	s0,sp,192
ffffffe000201a98:	f4a43c23          	sd	a0,-168(s0)
ffffffe000201a9c:	f4b43823          	sd	a1,-176(s0)
ffffffe000201aa0:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000201aa4:	f8043023          	sd	zero,-128(s0)
ffffffe000201aa8:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000201aac:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000201ab0:	7a40006f          	j	ffffffe000202254 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000201ab4:	f8044783          	lbu	a5,-128(s0)
ffffffe000201ab8:	72078e63          	beqz	a5,ffffffe0002021f4 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000201abc:	f5043783          	ld	a5,-176(s0)
ffffffe000201ac0:	0007c783          	lbu	a5,0(a5)
ffffffe000201ac4:	00078713          	mv	a4,a5
ffffffe000201ac8:	02300793          	li	a5,35
ffffffe000201acc:	00f71863          	bne	a4,a5,ffffffe000201adc <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000201ad0:	00100793          	li	a5,1
ffffffe000201ad4:	f8f40123          	sb	a5,-126(s0)
ffffffe000201ad8:	7700006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000201adc:	f5043783          	ld	a5,-176(s0)
ffffffe000201ae0:	0007c783          	lbu	a5,0(a5)
ffffffe000201ae4:	00078713          	mv	a4,a5
ffffffe000201ae8:	03000793          	li	a5,48
ffffffe000201aec:	00f71863          	bne	a4,a5,ffffffe000201afc <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000201af0:	00100793          	li	a5,1
ffffffe000201af4:	f8f401a3          	sb	a5,-125(s0)
ffffffe000201af8:	7500006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000201afc:	f5043783          	ld	a5,-176(s0)
ffffffe000201b00:	0007c783          	lbu	a5,0(a5)
ffffffe000201b04:	00078713          	mv	a4,a5
ffffffe000201b08:	06c00793          	li	a5,108
ffffffe000201b0c:	04f70063          	beq	a4,a5,ffffffe000201b4c <vprintfmt+0xc4>
ffffffe000201b10:	f5043783          	ld	a5,-176(s0)
ffffffe000201b14:	0007c783          	lbu	a5,0(a5)
ffffffe000201b18:	00078713          	mv	a4,a5
ffffffe000201b1c:	07a00793          	li	a5,122
ffffffe000201b20:	02f70663          	beq	a4,a5,ffffffe000201b4c <vprintfmt+0xc4>
ffffffe000201b24:	f5043783          	ld	a5,-176(s0)
ffffffe000201b28:	0007c783          	lbu	a5,0(a5)
ffffffe000201b2c:	00078713          	mv	a4,a5
ffffffe000201b30:	07400793          	li	a5,116
ffffffe000201b34:	00f70c63          	beq	a4,a5,ffffffe000201b4c <vprintfmt+0xc4>
ffffffe000201b38:	f5043783          	ld	a5,-176(s0)
ffffffe000201b3c:	0007c783          	lbu	a5,0(a5)
ffffffe000201b40:	00078713          	mv	a4,a5
ffffffe000201b44:	06a00793          	li	a5,106
ffffffe000201b48:	00f71863          	bne	a4,a5,ffffffe000201b58 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000201b4c:	00100793          	li	a5,1
ffffffe000201b50:	f8f400a3          	sb	a5,-127(s0)
ffffffe000201b54:	6f40006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000201b58:	f5043783          	ld	a5,-176(s0)
ffffffe000201b5c:	0007c783          	lbu	a5,0(a5)
ffffffe000201b60:	00078713          	mv	a4,a5
ffffffe000201b64:	02b00793          	li	a5,43
ffffffe000201b68:	00f71863          	bne	a4,a5,ffffffe000201b78 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000201b6c:	00100793          	li	a5,1
ffffffe000201b70:	f8f402a3          	sb	a5,-123(s0)
ffffffe000201b74:	6d40006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000201b78:	f5043783          	ld	a5,-176(s0)
ffffffe000201b7c:	0007c783          	lbu	a5,0(a5)
ffffffe000201b80:	00078713          	mv	a4,a5
ffffffe000201b84:	02000793          	li	a5,32
ffffffe000201b88:	00f71863          	bne	a4,a5,ffffffe000201b98 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000201b8c:	00100793          	li	a5,1
ffffffe000201b90:	f8f40223          	sb	a5,-124(s0)
ffffffe000201b94:	6b40006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000201b98:	f5043783          	ld	a5,-176(s0)
ffffffe000201b9c:	0007c783          	lbu	a5,0(a5)
ffffffe000201ba0:	00078713          	mv	a4,a5
ffffffe000201ba4:	02a00793          	li	a5,42
ffffffe000201ba8:	00f71e63          	bne	a4,a5,ffffffe000201bc4 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000201bac:	f4843783          	ld	a5,-184(s0)
ffffffe000201bb0:	00878713          	addi	a4,a5,8
ffffffe000201bb4:	f4e43423          	sd	a4,-184(s0)
ffffffe000201bb8:	0007a783          	lw	a5,0(a5)
ffffffe000201bbc:	f8f42423          	sw	a5,-120(s0)
ffffffe000201bc0:	6880006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000201bc4:	f5043783          	ld	a5,-176(s0)
ffffffe000201bc8:	0007c783          	lbu	a5,0(a5)
ffffffe000201bcc:	00078713          	mv	a4,a5
ffffffe000201bd0:	03000793          	li	a5,48
ffffffe000201bd4:	04e7f663          	bgeu	a5,a4,ffffffe000201c20 <vprintfmt+0x198>
ffffffe000201bd8:	f5043783          	ld	a5,-176(s0)
ffffffe000201bdc:	0007c783          	lbu	a5,0(a5)
ffffffe000201be0:	00078713          	mv	a4,a5
ffffffe000201be4:	03900793          	li	a5,57
ffffffe000201be8:	02e7ec63          	bltu	a5,a4,ffffffe000201c20 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000201bec:	f5043783          	ld	a5,-176(s0)
ffffffe000201bf0:	f5040713          	addi	a4,s0,-176
ffffffe000201bf4:	00a00613          	li	a2,10
ffffffe000201bf8:	00070593          	mv	a1,a4
ffffffe000201bfc:	00078513          	mv	a0,a5
ffffffe000201c00:	88dff0ef          	jal	ra,ffffffe00020148c <strtol>
ffffffe000201c04:	00050793          	mv	a5,a0
ffffffe000201c08:	0007879b          	sext.w	a5,a5
ffffffe000201c0c:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000201c10:	f5043783          	ld	a5,-176(s0)
ffffffe000201c14:	fff78793          	addi	a5,a5,-1
ffffffe000201c18:	f4f43823          	sd	a5,-176(s0)
ffffffe000201c1c:	62c0006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000201c20:	f5043783          	ld	a5,-176(s0)
ffffffe000201c24:	0007c783          	lbu	a5,0(a5)
ffffffe000201c28:	00078713          	mv	a4,a5
ffffffe000201c2c:	02e00793          	li	a5,46
ffffffe000201c30:	06f71863          	bne	a4,a5,ffffffe000201ca0 <vprintfmt+0x218>
                fmt++;
ffffffe000201c34:	f5043783          	ld	a5,-176(s0)
ffffffe000201c38:	00178793          	addi	a5,a5,1
ffffffe000201c3c:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000201c40:	f5043783          	ld	a5,-176(s0)
ffffffe000201c44:	0007c783          	lbu	a5,0(a5)
ffffffe000201c48:	00078713          	mv	a4,a5
ffffffe000201c4c:	02a00793          	li	a5,42
ffffffe000201c50:	00f71e63          	bne	a4,a5,ffffffe000201c6c <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000201c54:	f4843783          	ld	a5,-184(s0)
ffffffe000201c58:	00878713          	addi	a4,a5,8
ffffffe000201c5c:	f4e43423          	sd	a4,-184(s0)
ffffffe000201c60:	0007a783          	lw	a5,0(a5)
ffffffe000201c64:	f8f42623          	sw	a5,-116(s0)
ffffffe000201c68:	5e00006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000201c6c:	f5043783          	ld	a5,-176(s0)
ffffffe000201c70:	f5040713          	addi	a4,s0,-176
ffffffe000201c74:	00a00613          	li	a2,10
ffffffe000201c78:	00070593          	mv	a1,a4
ffffffe000201c7c:	00078513          	mv	a0,a5
ffffffe000201c80:	80dff0ef          	jal	ra,ffffffe00020148c <strtol>
ffffffe000201c84:	00050793          	mv	a5,a0
ffffffe000201c88:	0007879b          	sext.w	a5,a5
ffffffe000201c8c:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000201c90:	f5043783          	ld	a5,-176(s0)
ffffffe000201c94:	fff78793          	addi	a5,a5,-1
ffffffe000201c98:	f4f43823          	sd	a5,-176(s0)
ffffffe000201c9c:	5ac0006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000201ca0:	f5043783          	ld	a5,-176(s0)
ffffffe000201ca4:	0007c783          	lbu	a5,0(a5)
ffffffe000201ca8:	00078713          	mv	a4,a5
ffffffe000201cac:	07800793          	li	a5,120
ffffffe000201cb0:	02f70663          	beq	a4,a5,ffffffe000201cdc <vprintfmt+0x254>
ffffffe000201cb4:	f5043783          	ld	a5,-176(s0)
ffffffe000201cb8:	0007c783          	lbu	a5,0(a5)
ffffffe000201cbc:	00078713          	mv	a4,a5
ffffffe000201cc0:	05800793          	li	a5,88
ffffffe000201cc4:	00f70c63          	beq	a4,a5,ffffffe000201cdc <vprintfmt+0x254>
ffffffe000201cc8:	f5043783          	ld	a5,-176(s0)
ffffffe000201ccc:	0007c783          	lbu	a5,0(a5)
ffffffe000201cd0:	00078713          	mv	a4,a5
ffffffe000201cd4:	07000793          	li	a5,112
ffffffe000201cd8:	30f71263          	bne	a4,a5,ffffffe000201fdc <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000201cdc:	f5043783          	ld	a5,-176(s0)
ffffffe000201ce0:	0007c783          	lbu	a5,0(a5)
ffffffe000201ce4:	00078713          	mv	a4,a5
ffffffe000201ce8:	07000793          	li	a5,112
ffffffe000201cec:	00f70663          	beq	a4,a5,ffffffe000201cf8 <vprintfmt+0x270>
ffffffe000201cf0:	f8144783          	lbu	a5,-127(s0)
ffffffe000201cf4:	00078663          	beqz	a5,ffffffe000201d00 <vprintfmt+0x278>
ffffffe000201cf8:	00100793          	li	a5,1
ffffffe000201cfc:	0080006f          	j	ffffffe000201d04 <vprintfmt+0x27c>
ffffffe000201d00:	00000793          	li	a5,0
ffffffe000201d04:	faf403a3          	sb	a5,-89(s0)
ffffffe000201d08:	fa744783          	lbu	a5,-89(s0)
ffffffe000201d0c:	0017f793          	andi	a5,a5,1
ffffffe000201d10:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000201d14:	fa744783          	lbu	a5,-89(s0)
ffffffe000201d18:	0ff7f793          	zext.b	a5,a5
ffffffe000201d1c:	00078c63          	beqz	a5,ffffffe000201d34 <vprintfmt+0x2ac>
ffffffe000201d20:	f4843783          	ld	a5,-184(s0)
ffffffe000201d24:	00878713          	addi	a4,a5,8
ffffffe000201d28:	f4e43423          	sd	a4,-184(s0)
ffffffe000201d2c:	0007b783          	ld	a5,0(a5)
ffffffe000201d30:	01c0006f          	j	ffffffe000201d4c <vprintfmt+0x2c4>
ffffffe000201d34:	f4843783          	ld	a5,-184(s0)
ffffffe000201d38:	00878713          	addi	a4,a5,8
ffffffe000201d3c:	f4e43423          	sd	a4,-184(s0)
ffffffe000201d40:	0007a783          	lw	a5,0(a5)
ffffffe000201d44:	02079793          	slli	a5,a5,0x20
ffffffe000201d48:	0207d793          	srli	a5,a5,0x20
ffffffe000201d4c:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000201d50:	f8c42783          	lw	a5,-116(s0)
ffffffe000201d54:	02079463          	bnez	a5,ffffffe000201d7c <vprintfmt+0x2f4>
ffffffe000201d58:	fe043783          	ld	a5,-32(s0)
ffffffe000201d5c:	02079063          	bnez	a5,ffffffe000201d7c <vprintfmt+0x2f4>
ffffffe000201d60:	f5043783          	ld	a5,-176(s0)
ffffffe000201d64:	0007c783          	lbu	a5,0(a5)
ffffffe000201d68:	00078713          	mv	a4,a5
ffffffe000201d6c:	07000793          	li	a5,112
ffffffe000201d70:	00f70663          	beq	a4,a5,ffffffe000201d7c <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000201d74:	f8040023          	sb	zero,-128(s0)
ffffffe000201d78:	4d00006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000201d7c:	f5043783          	ld	a5,-176(s0)
ffffffe000201d80:	0007c783          	lbu	a5,0(a5)
ffffffe000201d84:	00078713          	mv	a4,a5
ffffffe000201d88:	07000793          	li	a5,112
ffffffe000201d8c:	00f70a63          	beq	a4,a5,ffffffe000201da0 <vprintfmt+0x318>
ffffffe000201d90:	f8244783          	lbu	a5,-126(s0)
ffffffe000201d94:	00078a63          	beqz	a5,ffffffe000201da8 <vprintfmt+0x320>
ffffffe000201d98:	fe043783          	ld	a5,-32(s0)
ffffffe000201d9c:	00078663          	beqz	a5,ffffffe000201da8 <vprintfmt+0x320>
ffffffe000201da0:	00100793          	li	a5,1
ffffffe000201da4:	0080006f          	j	ffffffe000201dac <vprintfmt+0x324>
ffffffe000201da8:	00000793          	li	a5,0
ffffffe000201dac:	faf40323          	sb	a5,-90(s0)
ffffffe000201db0:	fa644783          	lbu	a5,-90(s0)
ffffffe000201db4:	0017f793          	andi	a5,a5,1
ffffffe000201db8:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000201dbc:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000201dc0:	f5043783          	ld	a5,-176(s0)
ffffffe000201dc4:	0007c783          	lbu	a5,0(a5)
ffffffe000201dc8:	00078713          	mv	a4,a5
ffffffe000201dcc:	05800793          	li	a5,88
ffffffe000201dd0:	00f71863          	bne	a4,a5,ffffffe000201de0 <vprintfmt+0x358>
ffffffe000201dd4:	00001797          	auipc	a5,0x1
ffffffe000201dd8:	4ac78793          	addi	a5,a5,1196 # ffffffe000203280 <upperxdigits.1>
ffffffe000201ddc:	00c0006f          	j	ffffffe000201de8 <vprintfmt+0x360>
ffffffe000201de0:	00001797          	auipc	a5,0x1
ffffffe000201de4:	4b878793          	addi	a5,a5,1208 # ffffffe000203298 <lowerxdigits.0>
ffffffe000201de8:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000201dec:	fe043783          	ld	a5,-32(s0)
ffffffe000201df0:	00f7f793          	andi	a5,a5,15
ffffffe000201df4:	f9843703          	ld	a4,-104(s0)
ffffffe000201df8:	00f70733          	add	a4,a4,a5
ffffffe000201dfc:	fdc42783          	lw	a5,-36(s0)
ffffffe000201e00:	0017869b          	addiw	a3,a5,1
ffffffe000201e04:	fcd42e23          	sw	a3,-36(s0)
ffffffe000201e08:	00074703          	lbu	a4,0(a4)
ffffffe000201e0c:	ff078793          	addi	a5,a5,-16
ffffffe000201e10:	008787b3          	add	a5,a5,s0
ffffffe000201e14:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000201e18:	fe043783          	ld	a5,-32(s0)
ffffffe000201e1c:	0047d793          	srli	a5,a5,0x4
ffffffe000201e20:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000201e24:	fe043783          	ld	a5,-32(s0)
ffffffe000201e28:	fc0792e3          	bnez	a5,ffffffe000201dec <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000201e2c:	f8c42783          	lw	a5,-116(s0)
ffffffe000201e30:	00078713          	mv	a4,a5
ffffffe000201e34:	fff00793          	li	a5,-1
ffffffe000201e38:	02f71663          	bne	a4,a5,ffffffe000201e64 <vprintfmt+0x3dc>
ffffffe000201e3c:	f8344783          	lbu	a5,-125(s0)
ffffffe000201e40:	02078263          	beqz	a5,ffffffe000201e64 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000201e44:	f8842703          	lw	a4,-120(s0)
ffffffe000201e48:	fa644783          	lbu	a5,-90(s0)
ffffffe000201e4c:	0007879b          	sext.w	a5,a5
ffffffe000201e50:	0017979b          	slliw	a5,a5,0x1
ffffffe000201e54:	0007879b          	sext.w	a5,a5
ffffffe000201e58:	40f707bb          	subw	a5,a4,a5
ffffffe000201e5c:	0007879b          	sext.w	a5,a5
ffffffe000201e60:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000201e64:	f8842703          	lw	a4,-120(s0)
ffffffe000201e68:	fa644783          	lbu	a5,-90(s0)
ffffffe000201e6c:	0007879b          	sext.w	a5,a5
ffffffe000201e70:	0017979b          	slliw	a5,a5,0x1
ffffffe000201e74:	0007879b          	sext.w	a5,a5
ffffffe000201e78:	40f707bb          	subw	a5,a4,a5
ffffffe000201e7c:	0007871b          	sext.w	a4,a5
ffffffe000201e80:	fdc42783          	lw	a5,-36(s0)
ffffffe000201e84:	f8f42a23          	sw	a5,-108(s0)
ffffffe000201e88:	f8c42783          	lw	a5,-116(s0)
ffffffe000201e8c:	f8f42823          	sw	a5,-112(s0)
ffffffe000201e90:	f9442783          	lw	a5,-108(s0)
ffffffe000201e94:	00078593          	mv	a1,a5
ffffffe000201e98:	f9042783          	lw	a5,-112(s0)
ffffffe000201e9c:	00078613          	mv	a2,a5
ffffffe000201ea0:	0006069b          	sext.w	a3,a2
ffffffe000201ea4:	0005879b          	sext.w	a5,a1
ffffffe000201ea8:	00f6d463          	bge	a3,a5,ffffffe000201eb0 <vprintfmt+0x428>
ffffffe000201eac:	00058613          	mv	a2,a1
ffffffe000201eb0:	0006079b          	sext.w	a5,a2
ffffffe000201eb4:	40f707bb          	subw	a5,a4,a5
ffffffe000201eb8:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201ebc:	0280006f          	j	ffffffe000201ee4 <vprintfmt+0x45c>
                    putch(' ');
ffffffe000201ec0:	f5843783          	ld	a5,-168(s0)
ffffffe000201ec4:	02000513          	li	a0,32
ffffffe000201ec8:	000780e7          	jalr	a5
                    ++written;
ffffffe000201ecc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ed0:	0017879b          	addiw	a5,a5,1
ffffffe000201ed4:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000201ed8:	fd842783          	lw	a5,-40(s0)
ffffffe000201edc:	fff7879b          	addiw	a5,a5,-1
ffffffe000201ee0:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201ee4:	fd842783          	lw	a5,-40(s0)
ffffffe000201ee8:	0007879b          	sext.w	a5,a5
ffffffe000201eec:	fcf04ae3          	bgtz	a5,ffffffe000201ec0 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000201ef0:	fa644783          	lbu	a5,-90(s0)
ffffffe000201ef4:	0ff7f793          	zext.b	a5,a5
ffffffe000201ef8:	04078463          	beqz	a5,ffffffe000201f40 <vprintfmt+0x4b8>
                    putch('0');
ffffffe000201efc:	f5843783          	ld	a5,-168(s0)
ffffffe000201f00:	03000513          	li	a0,48
ffffffe000201f04:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000201f08:	f5043783          	ld	a5,-176(s0)
ffffffe000201f0c:	0007c783          	lbu	a5,0(a5)
ffffffe000201f10:	00078713          	mv	a4,a5
ffffffe000201f14:	05800793          	li	a5,88
ffffffe000201f18:	00f71663          	bne	a4,a5,ffffffe000201f24 <vprintfmt+0x49c>
ffffffe000201f1c:	05800793          	li	a5,88
ffffffe000201f20:	0080006f          	j	ffffffe000201f28 <vprintfmt+0x4a0>
ffffffe000201f24:	07800793          	li	a5,120
ffffffe000201f28:	f5843703          	ld	a4,-168(s0)
ffffffe000201f2c:	00078513          	mv	a0,a5
ffffffe000201f30:	000700e7          	jalr	a4
                    written += 2;
ffffffe000201f34:	fec42783          	lw	a5,-20(s0)
ffffffe000201f38:	0027879b          	addiw	a5,a5,2
ffffffe000201f3c:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000201f40:	fdc42783          	lw	a5,-36(s0)
ffffffe000201f44:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201f48:	0280006f          	j	ffffffe000201f70 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000201f4c:	f5843783          	ld	a5,-168(s0)
ffffffe000201f50:	03000513          	li	a0,48
ffffffe000201f54:	000780e7          	jalr	a5
                    ++written;
ffffffe000201f58:	fec42783          	lw	a5,-20(s0)
ffffffe000201f5c:	0017879b          	addiw	a5,a5,1
ffffffe000201f60:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000201f64:	fd442783          	lw	a5,-44(s0)
ffffffe000201f68:	0017879b          	addiw	a5,a5,1
ffffffe000201f6c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201f70:	f8c42703          	lw	a4,-116(s0)
ffffffe000201f74:	fd442783          	lw	a5,-44(s0)
ffffffe000201f78:	0007879b          	sext.w	a5,a5
ffffffe000201f7c:	fce7c8e3          	blt	a5,a4,ffffffe000201f4c <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000201f80:	fdc42783          	lw	a5,-36(s0)
ffffffe000201f84:	fff7879b          	addiw	a5,a5,-1
ffffffe000201f88:	fcf42823          	sw	a5,-48(s0)
ffffffe000201f8c:	03c0006f          	j	ffffffe000201fc8 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000201f90:	fd042783          	lw	a5,-48(s0)
ffffffe000201f94:	ff078793          	addi	a5,a5,-16
ffffffe000201f98:	008787b3          	add	a5,a5,s0
ffffffe000201f9c:	f807c783          	lbu	a5,-128(a5)
ffffffe000201fa0:	0007871b          	sext.w	a4,a5
ffffffe000201fa4:	f5843783          	ld	a5,-168(s0)
ffffffe000201fa8:	00070513          	mv	a0,a4
ffffffe000201fac:	000780e7          	jalr	a5
                    ++written;
ffffffe000201fb0:	fec42783          	lw	a5,-20(s0)
ffffffe000201fb4:	0017879b          	addiw	a5,a5,1
ffffffe000201fb8:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000201fbc:	fd042783          	lw	a5,-48(s0)
ffffffe000201fc0:	fff7879b          	addiw	a5,a5,-1
ffffffe000201fc4:	fcf42823          	sw	a5,-48(s0)
ffffffe000201fc8:	fd042783          	lw	a5,-48(s0)
ffffffe000201fcc:	0007879b          	sext.w	a5,a5
ffffffe000201fd0:	fc07d0e3          	bgez	a5,ffffffe000201f90 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000201fd4:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000201fd8:	2700006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000201fdc:	f5043783          	ld	a5,-176(s0)
ffffffe000201fe0:	0007c783          	lbu	a5,0(a5)
ffffffe000201fe4:	00078713          	mv	a4,a5
ffffffe000201fe8:	06400793          	li	a5,100
ffffffe000201fec:	02f70663          	beq	a4,a5,ffffffe000202018 <vprintfmt+0x590>
ffffffe000201ff0:	f5043783          	ld	a5,-176(s0)
ffffffe000201ff4:	0007c783          	lbu	a5,0(a5)
ffffffe000201ff8:	00078713          	mv	a4,a5
ffffffe000201ffc:	06900793          	li	a5,105
ffffffe000202000:	00f70c63          	beq	a4,a5,ffffffe000202018 <vprintfmt+0x590>
ffffffe000202004:	f5043783          	ld	a5,-176(s0)
ffffffe000202008:	0007c783          	lbu	a5,0(a5)
ffffffe00020200c:	00078713          	mv	a4,a5
ffffffe000202010:	07500793          	li	a5,117
ffffffe000202014:	08f71063          	bne	a4,a5,ffffffe000202094 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000202018:	f8144783          	lbu	a5,-127(s0)
ffffffe00020201c:	00078c63          	beqz	a5,ffffffe000202034 <vprintfmt+0x5ac>
ffffffe000202020:	f4843783          	ld	a5,-184(s0)
ffffffe000202024:	00878713          	addi	a4,a5,8
ffffffe000202028:	f4e43423          	sd	a4,-184(s0)
ffffffe00020202c:	0007b783          	ld	a5,0(a5)
ffffffe000202030:	0140006f          	j	ffffffe000202044 <vprintfmt+0x5bc>
ffffffe000202034:	f4843783          	ld	a5,-184(s0)
ffffffe000202038:	00878713          	addi	a4,a5,8
ffffffe00020203c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202040:	0007a783          	lw	a5,0(a5)
ffffffe000202044:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000202048:	fa843583          	ld	a1,-88(s0)
ffffffe00020204c:	f5043783          	ld	a5,-176(s0)
ffffffe000202050:	0007c783          	lbu	a5,0(a5)
ffffffe000202054:	0007871b          	sext.w	a4,a5
ffffffe000202058:	07500793          	li	a5,117
ffffffe00020205c:	40f707b3          	sub	a5,a4,a5
ffffffe000202060:	00f037b3          	snez	a5,a5
ffffffe000202064:	0ff7f793          	zext.b	a5,a5
ffffffe000202068:	f8040713          	addi	a4,s0,-128
ffffffe00020206c:	00070693          	mv	a3,a4
ffffffe000202070:	00078613          	mv	a2,a5
ffffffe000202074:	f5843503          	ld	a0,-168(s0)
ffffffe000202078:	f08ff0ef          	jal	ra,ffffffe000201780 <print_dec_int>
ffffffe00020207c:	00050793          	mv	a5,a0
ffffffe000202080:	fec42703          	lw	a4,-20(s0)
ffffffe000202084:	00f707bb          	addw	a5,a4,a5
ffffffe000202088:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020208c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202090:	1b80006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202094:	f5043783          	ld	a5,-176(s0)
ffffffe000202098:	0007c783          	lbu	a5,0(a5)
ffffffe00020209c:	00078713          	mv	a4,a5
ffffffe0002020a0:	06e00793          	li	a5,110
ffffffe0002020a4:	04f71c63          	bne	a4,a5,ffffffe0002020fc <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe0002020a8:	f8144783          	lbu	a5,-127(s0)
ffffffe0002020ac:	02078463          	beqz	a5,ffffffe0002020d4 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe0002020b0:	f4843783          	ld	a5,-184(s0)
ffffffe0002020b4:	00878713          	addi	a4,a5,8
ffffffe0002020b8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002020bc:	0007b783          	ld	a5,0(a5)
ffffffe0002020c0:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe0002020c4:	fec42703          	lw	a4,-20(s0)
ffffffe0002020c8:	fb043783          	ld	a5,-80(s0)
ffffffe0002020cc:	00e7b023          	sd	a4,0(a5)
ffffffe0002020d0:	0240006f          	j	ffffffe0002020f4 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe0002020d4:	f4843783          	ld	a5,-184(s0)
ffffffe0002020d8:	00878713          	addi	a4,a5,8
ffffffe0002020dc:	f4e43423          	sd	a4,-184(s0)
ffffffe0002020e0:	0007b783          	ld	a5,0(a5)
ffffffe0002020e4:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe0002020e8:	fb843783          	ld	a5,-72(s0)
ffffffe0002020ec:	fec42703          	lw	a4,-20(s0)
ffffffe0002020f0:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe0002020f4:	f8040023          	sb	zero,-128(s0)
ffffffe0002020f8:	1500006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe0002020fc:	f5043783          	ld	a5,-176(s0)
ffffffe000202100:	0007c783          	lbu	a5,0(a5)
ffffffe000202104:	00078713          	mv	a4,a5
ffffffe000202108:	07300793          	li	a5,115
ffffffe00020210c:	02f71e63          	bne	a4,a5,ffffffe000202148 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000202110:	f4843783          	ld	a5,-184(s0)
ffffffe000202114:	00878713          	addi	a4,a5,8
ffffffe000202118:	f4e43423          	sd	a4,-184(s0)
ffffffe00020211c:	0007b783          	ld	a5,0(a5)
ffffffe000202120:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000202124:	fc043583          	ld	a1,-64(s0)
ffffffe000202128:	f5843503          	ld	a0,-168(s0)
ffffffe00020212c:	dccff0ef          	jal	ra,ffffffe0002016f8 <puts_wo_nl>
ffffffe000202130:	00050793          	mv	a5,a0
ffffffe000202134:	fec42703          	lw	a4,-20(s0)
ffffffe000202138:	00f707bb          	addw	a5,a4,a5
ffffffe00020213c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202140:	f8040023          	sb	zero,-128(s0)
ffffffe000202144:	1040006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000202148:	f5043783          	ld	a5,-176(s0)
ffffffe00020214c:	0007c783          	lbu	a5,0(a5)
ffffffe000202150:	00078713          	mv	a4,a5
ffffffe000202154:	06300793          	li	a5,99
ffffffe000202158:	02f71e63          	bne	a4,a5,ffffffe000202194 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe00020215c:	f4843783          	ld	a5,-184(s0)
ffffffe000202160:	00878713          	addi	a4,a5,8
ffffffe000202164:	f4e43423          	sd	a4,-184(s0)
ffffffe000202168:	0007a783          	lw	a5,0(a5)
ffffffe00020216c:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000202170:	fcc42703          	lw	a4,-52(s0)
ffffffe000202174:	f5843783          	ld	a5,-168(s0)
ffffffe000202178:	00070513          	mv	a0,a4
ffffffe00020217c:	000780e7          	jalr	a5
                ++written;
ffffffe000202180:	fec42783          	lw	a5,-20(s0)
ffffffe000202184:	0017879b          	addiw	a5,a5,1
ffffffe000202188:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020218c:	f8040023          	sb	zero,-128(s0)
ffffffe000202190:	0b80006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000202194:	f5043783          	ld	a5,-176(s0)
ffffffe000202198:	0007c783          	lbu	a5,0(a5)
ffffffe00020219c:	00078713          	mv	a4,a5
ffffffe0002021a0:	02500793          	li	a5,37
ffffffe0002021a4:	02f71263          	bne	a4,a5,ffffffe0002021c8 <vprintfmt+0x740>
                putch('%');
ffffffe0002021a8:	f5843783          	ld	a5,-168(s0)
ffffffe0002021ac:	02500513          	li	a0,37
ffffffe0002021b0:	000780e7          	jalr	a5
                ++written;
ffffffe0002021b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002021b8:	0017879b          	addiw	a5,a5,1
ffffffe0002021bc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002021c0:	f8040023          	sb	zero,-128(s0)
ffffffe0002021c4:	0840006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe0002021c8:	f5043783          	ld	a5,-176(s0)
ffffffe0002021cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002021d0:	0007871b          	sext.w	a4,a5
ffffffe0002021d4:	f5843783          	ld	a5,-168(s0)
ffffffe0002021d8:	00070513          	mv	a0,a4
ffffffe0002021dc:	000780e7          	jalr	a5
                ++written;
ffffffe0002021e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002021e4:	0017879b          	addiw	a5,a5,1
ffffffe0002021e8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002021ec:	f8040023          	sb	zero,-128(s0)
ffffffe0002021f0:	0580006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe0002021f4:	f5043783          	ld	a5,-176(s0)
ffffffe0002021f8:	0007c783          	lbu	a5,0(a5)
ffffffe0002021fc:	00078713          	mv	a4,a5
ffffffe000202200:	02500793          	li	a5,37
ffffffe000202204:	02f71063          	bne	a4,a5,ffffffe000202224 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe000202208:	f8043023          	sd	zero,-128(s0)
ffffffe00020220c:	f8043423          	sd	zero,-120(s0)
ffffffe000202210:	00100793          	li	a5,1
ffffffe000202214:	f8f40023          	sb	a5,-128(s0)
ffffffe000202218:	fff00793          	li	a5,-1
ffffffe00020221c:	f8f42623          	sw	a5,-116(s0)
ffffffe000202220:	0280006f          	j	ffffffe000202248 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe000202224:	f5043783          	ld	a5,-176(s0)
ffffffe000202228:	0007c783          	lbu	a5,0(a5)
ffffffe00020222c:	0007871b          	sext.w	a4,a5
ffffffe000202230:	f5843783          	ld	a5,-168(s0)
ffffffe000202234:	00070513          	mv	a0,a4
ffffffe000202238:	000780e7          	jalr	a5
            ++written;
ffffffe00020223c:	fec42783          	lw	a5,-20(s0)
ffffffe000202240:	0017879b          	addiw	a5,a5,1
ffffffe000202244:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000202248:	f5043783          	ld	a5,-176(s0)
ffffffe00020224c:	00178793          	addi	a5,a5,1
ffffffe000202250:	f4f43823          	sd	a5,-176(s0)
ffffffe000202254:	f5043783          	ld	a5,-176(s0)
ffffffe000202258:	0007c783          	lbu	a5,0(a5)
ffffffe00020225c:	84079ce3          	bnez	a5,ffffffe000201ab4 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000202260:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202264:	00078513          	mv	a0,a5
ffffffe000202268:	0b813083          	ld	ra,184(sp)
ffffffe00020226c:	0b013403          	ld	s0,176(sp)
ffffffe000202270:	0c010113          	addi	sp,sp,192
ffffffe000202274:	00008067          	ret

ffffffe000202278 <printk>:

int printk(const char* s, ...) {
ffffffe000202278:	f9010113          	addi	sp,sp,-112
ffffffe00020227c:	02113423          	sd	ra,40(sp)
ffffffe000202280:	02813023          	sd	s0,32(sp)
ffffffe000202284:	03010413          	addi	s0,sp,48
ffffffe000202288:	fca43c23          	sd	a0,-40(s0)
ffffffe00020228c:	00b43423          	sd	a1,8(s0)
ffffffe000202290:	00c43823          	sd	a2,16(s0)
ffffffe000202294:	00d43c23          	sd	a3,24(s0)
ffffffe000202298:	02e43023          	sd	a4,32(s0)
ffffffe00020229c:	02f43423          	sd	a5,40(s0)
ffffffe0002022a0:	03043823          	sd	a6,48(s0)
ffffffe0002022a4:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe0002022a8:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe0002022ac:	04040793          	addi	a5,s0,64
ffffffe0002022b0:	fcf43823          	sd	a5,-48(s0)
ffffffe0002022b4:	fd043783          	ld	a5,-48(s0)
ffffffe0002022b8:	fc878793          	addi	a5,a5,-56
ffffffe0002022bc:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe0002022c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002022c4:	00078613          	mv	a2,a5
ffffffe0002022c8:	fd843583          	ld	a1,-40(s0)
ffffffe0002022cc:	fffff517          	auipc	a0,0xfffff
ffffffe0002022d0:	11850513          	addi	a0,a0,280 # ffffffe0002013e4 <putc>
ffffffe0002022d4:	fb4ff0ef          	jal	ra,ffffffe000201a88 <vprintfmt>
ffffffe0002022d8:	00050793          	mv	a5,a0
ffffffe0002022dc:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe0002022e0:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002022e4:	00078513          	mv	a0,a5
ffffffe0002022e8:	02813083          	ld	ra,40(sp)
ffffffe0002022ec:	02013403          	ld	s0,32(sp)
ffffffe0002022f0:	07010113          	addi	sp,sp,112
ffffffe0002022f4:	00008067          	ret

ffffffe0002022f8 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe0002022f8:	fe010113          	addi	sp,sp,-32
ffffffe0002022fc:	00813c23          	sd	s0,24(sp)
ffffffe000202300:	02010413          	addi	s0,sp,32
ffffffe000202304:	00050793          	mv	a5,a0
ffffffe000202308:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe00020230c:	fec42783          	lw	a5,-20(s0)
ffffffe000202310:	fff7879b          	addiw	a5,a5,-1
ffffffe000202314:	0007879b          	sext.w	a5,a5
ffffffe000202318:	02079713          	slli	a4,a5,0x20
ffffffe00020231c:	02075713          	srli	a4,a4,0x20
ffffffe000202320:	00004797          	auipc	a5,0x4
ffffffe000202324:	d0078793          	addi	a5,a5,-768 # ffffffe000206020 <seed>
ffffffe000202328:	00e7b023          	sd	a4,0(a5)
}
ffffffe00020232c:	00000013          	nop
ffffffe000202330:	01813403          	ld	s0,24(sp)
ffffffe000202334:	02010113          	addi	sp,sp,32
ffffffe000202338:	00008067          	ret

ffffffe00020233c <rand>:

int rand(void) {
ffffffe00020233c:	ff010113          	addi	sp,sp,-16
ffffffe000202340:	00813423          	sd	s0,8(sp)
ffffffe000202344:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000202348:	00004797          	auipc	a5,0x4
ffffffe00020234c:	cd878793          	addi	a5,a5,-808 # ffffffe000206020 <seed>
ffffffe000202350:	0007b703          	ld	a4,0(a5)
ffffffe000202354:	00001797          	auipc	a5,0x1
ffffffe000202358:	f5c78793          	addi	a5,a5,-164 # ffffffe0002032b0 <lowerxdigits.0+0x18>
ffffffe00020235c:	0007b783          	ld	a5,0(a5)
ffffffe000202360:	02f707b3          	mul	a5,a4,a5
ffffffe000202364:	00178713          	addi	a4,a5,1
ffffffe000202368:	00004797          	auipc	a5,0x4
ffffffe00020236c:	cb878793          	addi	a5,a5,-840 # ffffffe000206020 <seed>
ffffffe000202370:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000202374:	00004797          	auipc	a5,0x4
ffffffe000202378:	cac78793          	addi	a5,a5,-852 # ffffffe000206020 <seed>
ffffffe00020237c:	0007b783          	ld	a5,0(a5)
ffffffe000202380:	0217d793          	srli	a5,a5,0x21
ffffffe000202384:	0007879b          	sext.w	a5,a5
}
ffffffe000202388:	00078513          	mv	a0,a5
ffffffe00020238c:	00813403          	ld	s0,8(sp)
ffffffe000202390:	01010113          	addi	sp,sp,16
ffffffe000202394:	00008067          	ret

ffffffe000202398 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000202398:	fc010113          	addi	sp,sp,-64
ffffffe00020239c:	02813c23          	sd	s0,56(sp)
ffffffe0002023a0:	04010413          	addi	s0,sp,64
ffffffe0002023a4:	fca43c23          	sd	a0,-40(s0)
ffffffe0002023a8:	00058793          	mv	a5,a1
ffffffe0002023ac:	fcc43423          	sd	a2,-56(s0)
ffffffe0002023b0:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe0002023b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002023b8:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002023bc:	fe043423          	sd	zero,-24(s0)
ffffffe0002023c0:	0280006f          	j	ffffffe0002023e8 <memset+0x50>
        s[i] = c;
ffffffe0002023c4:	fe043703          	ld	a4,-32(s0)
ffffffe0002023c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002023cc:	00f707b3          	add	a5,a4,a5
ffffffe0002023d0:	fd442703          	lw	a4,-44(s0)
ffffffe0002023d4:	0ff77713          	zext.b	a4,a4
ffffffe0002023d8:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002023dc:	fe843783          	ld	a5,-24(s0)
ffffffe0002023e0:	00178793          	addi	a5,a5,1
ffffffe0002023e4:	fef43423          	sd	a5,-24(s0)
ffffffe0002023e8:	fe843703          	ld	a4,-24(s0)
ffffffe0002023ec:	fc843783          	ld	a5,-56(s0)
ffffffe0002023f0:	fcf76ae3          	bltu	a4,a5,ffffffe0002023c4 <memset+0x2c>
    }
    return dest;
ffffffe0002023f4:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002023f8:	00078513          	mv	a0,a5
ffffffe0002023fc:	03813403          	ld	s0,56(sp)
ffffffe000202400:	04010113          	addi	sp,sp,64
ffffffe000202404:	00008067          	ret
