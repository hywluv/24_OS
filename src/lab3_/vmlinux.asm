
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
ffffffe000200008:	48d000ef          	jal	ra,ffffffe000200c94 <setup_vm>
    call relocate
ffffffe00020000c:	04c000ef          	jal	ra,ffffffe000200058 <relocate>
    call mm_init
ffffffe000200010:	424000ef          	jal	ra,ffffffe000200434 <mm_init>
    call setup_vm_final
ffffffe000200014:	649000ef          	jal	ra,ffffffe000200e5c <setup_vm_final>
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
ffffffe000200054:	218010ef          	jal	ra,ffffffe00020126c <start_kernel>

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
ffffffe00020012c:	2e5000ef          	jal	ra,ffffffe000200c10 <trap_handler>

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
ffffffe00020031c:	21c020ef          	jal	ra,ffffffe000202538 <memset>
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
ffffffe000200374:	1c4020ef          	jal	ra,ffffffe000202538 <memset>

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
    kfreerange((char *)_ekernel, (char *)(PHY_END + PA2VA_OFFSET)); // VA
ffffffe000200444:	c0100793          	li	a5,-1023
ffffffe000200448:	01b79593          	slli	a1,a5,0x1b
ffffffe00020044c:	00009517          	auipc	a0,0x9
ffffffe000200450:	bb450513          	addi	a0,a0,-1100 # ffffffe000209000 <_ebss>
ffffffe000200454:	f65ff0ef          	jal	ra,ffffffe0002003b8 <kfreerange>
    printk("...mm_init done!\n");
ffffffe000200458:	00003517          	auipc	a0,0x3
ffffffe00020045c:	ba850513          	addi	a0,a0,-1112 # ffffffe000203000 <_srodata>
ffffffe000200460:	7b9010ef          	jal	ra,ffffffe000202418 <printk>
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
ffffffe00020048c:	00c020ef          	jal	ra,ffffffe000202498 <srand>
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
ffffffe00020050c:	b1878793          	addi	a5,a5,-1256 # ffffffe000206020 <task>
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
ffffffe00020052c:	af870713          	addi	a4,a4,-1288 # ffffffe000206020 <task>
ffffffe000200530:	fec42783          	lw	a5,-20(s0)
ffffffe000200534:	00379793          	slli	a5,a5,0x3
ffffffe000200538:	00f707b3          	add	a5,a4,a5
ffffffe00020053c:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200540:	00006717          	auipc	a4,0x6
ffffffe000200544:	ae070713          	addi	a4,a4,-1312 # ffffffe000206020 <task>
ffffffe000200548:	fec42783          	lw	a5,-20(s0)
ffffffe00020054c:	00379793          	slli	a5,a5,0x3
ffffffe000200550:	00f707b3          	add	a5,a4,a5
ffffffe000200554:	0007b783          	ld	a5,0(a5)
ffffffe000200558:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe00020055c:	781010ef          	jal	ra,ffffffe0002024dc <rand>
ffffffe000200560:	00050793          	mv	a5,a0
ffffffe000200564:	00078713          	mv	a4,a5
ffffffe000200568:	00a00793          	li	a5,10
ffffffe00020056c:	02f767bb          	remw	a5,a4,a5
ffffffe000200570:	0007879b          	sext.w	a5,a5
ffffffe000200574:	0017879b          	addiw	a5,a5,1
ffffffe000200578:	0007869b          	sext.w	a3,a5
ffffffe00020057c:	00006717          	auipc	a4,0x6
ffffffe000200580:	aa470713          	addi	a4,a4,-1372 # ffffffe000206020 <task>
ffffffe000200584:	fec42783          	lw	a5,-20(s0)
ffffffe000200588:	00379793          	slli	a5,a5,0x3
ffffffe00020058c:	00f707b3          	add	a5,a4,a5
ffffffe000200590:	0007b783          	ld	a5,0(a5)
ffffffe000200594:	00068713          	mv	a4,a3
ffffffe000200598:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
ffffffe00020059c:	00006717          	auipc	a4,0x6
ffffffe0002005a0:	a8470713          	addi	a4,a4,-1404 # ffffffe000206020 <task>
ffffffe0002005a4:	fec42783          	lw	a5,-20(s0)
ffffffe0002005a8:	00379793          	slli	a5,a5,0x3
ffffffe0002005ac:	00f707b3          	add	a5,a4,a5
ffffffe0002005b0:	0007b783          	ld	a5,0(a5)
ffffffe0002005b4:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
ffffffe0002005b8:	00006717          	auipc	a4,0x6
ffffffe0002005bc:	a6870713          	addi	a4,a4,-1432 # ffffffe000206020 <task>
ffffffe0002005c0:	fec42783          	lw	a5,-20(s0)
ffffffe0002005c4:	00379793          	slli	a5,a5,0x3
ffffffe0002005c8:	00f707b3          	add	a5,a4,a5
ffffffe0002005cc:	0007b783          	ld	a5,0(a5)
ffffffe0002005d0:	fec42703          	lw	a4,-20(s0)
ffffffe0002005d4:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe0002005d8:	00006717          	auipc	a4,0x6
ffffffe0002005dc:	a4870713          	addi	a4,a4,-1464 # ffffffe000206020 <task>
ffffffe0002005e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002005e4:	00379793          	slli	a5,a5,0x3
ffffffe0002005e8:	00f707b3          	add	a5,a4,a5
ffffffe0002005ec:	0007b783          	ld	a5,0(a5)
ffffffe0002005f0:	00000717          	auipc	a4,0x0
ffffffe0002005f4:	bcc70713          	addi	a4,a4,-1076 # ffffffe0002001bc <__dummy>
ffffffe0002005f8:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe0002005fc:	00006717          	auipc	a4,0x6
ffffffe000200600:	a2470713          	addi	a4,a4,-1500 # ffffffe000206020 <task>
ffffffe000200604:	fec42783          	lw	a5,-20(s0)
ffffffe000200608:	00379793          	slli	a5,a5,0x3
ffffffe00020060c:	00f707b3          	add	a5,a4,a5
ffffffe000200610:	0007b783          	ld	a5,0(a5)
ffffffe000200614:	00078693          	mv	a3,a5
ffffffe000200618:	00006717          	auipc	a4,0x6
ffffffe00020061c:	a0870713          	addi	a4,a4,-1528 # ffffffe000206020 <task>
ffffffe000200620:	fec42783          	lw	a5,-20(s0)
ffffffe000200624:	00379793          	slli	a5,a5,0x3
ffffffe000200628:	00f707b3          	add	a5,a4,a5
ffffffe00020062c:	0007b783          	ld	a5,0(a5)
ffffffe000200630:	00001737          	lui	a4,0x1
ffffffe000200634:	00e68733          	add	a4,a3,a4
ffffffe000200638:	02e7b423          	sd	a4,40(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
ffffffe00020063c:	00006717          	auipc	a4,0x6
ffffffe000200640:	9e470713          	addi	a4,a4,-1564 # ffffffe000206020 <task>
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
ffffffe00020066c:	5ad010ef          	jal	ra,ffffffe000202418 <printk>
    for(int i = 1; i < NR_TASKS; i++) {
ffffffe000200670:	fec42783          	lw	a5,-20(s0)
ffffffe000200674:	0017879b          	addiw	a5,a5,1
ffffffe000200678:	fef42623          	sw	a5,-20(s0)
ffffffe00020067c:	fec42783          	lw	a5,-20(s0)
ffffffe000200680:	0007871b          	sext.w	a4,a5
ffffffe000200684:	01f00793          	li	a5,31
ffffffe000200688:	e8e7dce3          	bge	a5,a4,ffffffe000200520 <task_init+0xa8>
    }

    printk("...task_init done!\n");
ffffffe00020068c:	00003517          	auipc	a0,0x3
ffffffe000200690:	9ac50513          	addi	a0,a0,-1620 # ffffffe000203038 <_srodata+0x38>
ffffffe000200694:	585010ef          	jal	ra,ffffffe000202418 <printk>
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
ffffffe0002007d4:	85070713          	addi	a4,a4,-1968 # ffffffe000206020 <task>
ffffffe0002007d8:	fe042783          	lw	a5,-32(s0)
ffffffe0002007dc:	00379793          	slli	a5,a5,0x3
ffffffe0002007e0:	00f707b3          	add	a5,a4,a5
ffffffe0002007e4:	0007b783          	ld	a5,0(a5)
ffffffe0002007e8:	08078263          	beqz	a5,ffffffe00020086c <schedule+0xc0>
ffffffe0002007ec:	00006717          	auipc	a4,0x6
ffffffe0002007f0:	83470713          	addi	a4,a4,-1996 # ffffffe000206020 <task>
ffffffe0002007f4:	fe042783          	lw	a5,-32(s0)
ffffffe0002007f8:	00379793          	slli	a5,a5,0x3
ffffffe0002007fc:	00f707b3          	add	a5,a4,a5
ffffffe000200800:	0007b783          	ld	a5,0(a5)
ffffffe000200804:	0007b783          	ld	a5,0(a5)
ffffffe000200808:	06079263          	bnez	a5,ffffffe00020086c <schedule+0xc0>
            if (task[i]->counter > max_counter) {
ffffffe00020080c:	00006717          	auipc	a4,0x6
ffffffe000200810:	81470713          	addi	a4,a4,-2028 # ffffffe000206020 <task>
ffffffe000200814:	fe042783          	lw	a5,-32(s0)
ffffffe000200818:	00379793          	slli	a5,a5,0x3
ffffffe00020081c:	00f707b3          	add	a5,a4,a5
ffffffe000200820:	0007b783          	ld	a5,0(a5)
ffffffe000200824:	0087b703          	ld	a4,8(a5)
ffffffe000200828:	fe442783          	lw	a5,-28(s0)
ffffffe00020082c:	04e7f063          	bgeu	a5,a4,ffffffe00020086c <schedule+0xc0>
                max_counter = task[i]->counter;
ffffffe000200830:	00005717          	auipc	a4,0x5
ffffffe000200834:	7f070713          	addi	a4,a4,2032 # ffffffe000206020 <task>
ffffffe000200838:	fe042783          	lw	a5,-32(s0)
ffffffe00020083c:	00379793          	slli	a5,a5,0x3
ffffffe000200840:	00f707b3          	add	a5,a4,a5
ffffffe000200844:	0007b783          	ld	a5,0(a5)
ffffffe000200848:	0087b783          	ld	a5,8(a5)
ffffffe00020084c:	fef42223          	sw	a5,-28(s0)
                next = task[i];
ffffffe000200850:	00005717          	auipc	a4,0x5
ffffffe000200854:	7d070713          	addi	a4,a4,2000 # ffffffe000206020 <task>
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
ffffffe000200880:	01f00793          	li	a5,31
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
ffffffe0002008a0:	78470713          	addi	a4,a4,1924 # ffffffe000206020 <task>
ffffffe0002008a4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008a8:	00379793          	slli	a5,a5,0x3
ffffffe0002008ac:	00f707b3          	add	a5,a4,a5
ffffffe0002008b0:	0007b783          	ld	a5,0(a5)
ffffffe0002008b4:	04078e63          	beqz	a5,ffffffe000200910 <schedule+0x164>
ffffffe0002008b8:	00005717          	auipc	a4,0x5
ffffffe0002008bc:	76870713          	addi	a4,a4,1896 # ffffffe000206020 <task>
ffffffe0002008c0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008c4:	00379793          	slli	a5,a5,0x3
ffffffe0002008c8:	00f707b3          	add	a5,a4,a5
ffffffe0002008cc:	0007b783          	ld	a5,0(a5)
ffffffe0002008d0:	0007b783          	ld	a5,0(a5)
ffffffe0002008d4:	02079e63          	bnez	a5,ffffffe000200910 <schedule+0x164>
                task[i]->counter = task[i]->priority;
ffffffe0002008d8:	00005717          	auipc	a4,0x5
ffffffe0002008dc:	74870713          	addi	a4,a4,1864 # ffffffe000206020 <task>
ffffffe0002008e0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008e4:	00379793          	slli	a5,a5,0x3
ffffffe0002008e8:	00f707b3          	add	a5,a4,a5
ffffffe0002008ec:	0007b703          	ld	a4,0(a5)
ffffffe0002008f0:	00005697          	auipc	a3,0x5
ffffffe0002008f4:	73068693          	addi	a3,a3,1840 # ffffffe000206020 <task>
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
ffffffe000200924:	01f00793          	li	a5,31
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
ffffffe000200a44:	1d5010ef          	jal	ra,ffffffe000202418 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200a48:	f49ff06f          	j	ffffffe000200990 <dummy+0x28>

ffffffe000200a4c <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000200a4c:	f8010113          	addi	sp,sp,-128
ffffffe000200a50:	06813c23          	sd	s0,120(sp)
ffffffe000200a54:	06913823          	sd	s1,112(sp)
ffffffe000200a58:	07213423          	sd	s2,104(sp)
ffffffe000200a5c:	07313023          	sd	s3,96(sp)
ffffffe000200a60:	08010413          	addi	s0,sp,128
ffffffe000200a64:	faa43c23          	sd	a0,-72(s0)
ffffffe000200a68:	fab43823          	sd	a1,-80(s0)
ffffffe000200a6c:	fac43423          	sd	a2,-88(s0)
ffffffe000200a70:	fad43023          	sd	a3,-96(s0)
ffffffe000200a74:	f8e43c23          	sd	a4,-104(s0)
ffffffe000200a78:	f8f43823          	sd	a5,-112(s0)
ffffffe000200a7c:	f9043423          	sd	a6,-120(s0)
ffffffe000200a80:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
ffffffe000200a84:	fb843e03          	ld	t3,-72(s0)
ffffffe000200a88:	fb043e83          	ld	t4,-80(s0)
ffffffe000200a8c:	fa843f03          	ld	t5,-88(s0)
ffffffe000200a90:	fa043f83          	ld	t6,-96(s0)
ffffffe000200a94:	f9843283          	ld	t0,-104(s0)
ffffffe000200a98:	f9043483          	ld	s1,-112(s0)
ffffffe000200a9c:	f8843903          	ld	s2,-120(s0)
ffffffe000200aa0:	f8043983          	ld	s3,-128(s0)
ffffffe000200aa4:	000e0893          	mv	a7,t3
ffffffe000200aa8:	000e8813          	mv	a6,t4
ffffffe000200aac:	000f0513          	mv	a0,t5
ffffffe000200ab0:	000f8593          	mv	a1,t6
ffffffe000200ab4:	00028613          	mv	a2,t0
ffffffe000200ab8:	00048693          	mv	a3,s1
ffffffe000200abc:	00090713          	mv	a4,s2
ffffffe000200ac0:	00098793          	mv	a5,s3
ffffffe000200ac4:	00000073          	ecall
ffffffe000200ac8:	00050e93          	mv	t4,a0
ffffffe000200acc:	00058e13          	mv	t3,a1
ffffffe000200ad0:	fdd43023          	sd	t4,-64(s0)
ffffffe000200ad4:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
ffffffe000200ad8:	fc043783          	ld	a5,-64(s0)
ffffffe000200adc:	fcf43823          	sd	a5,-48(s0)
ffffffe000200ae0:	fc843783          	ld	a5,-56(s0)
ffffffe000200ae4:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200ae8:	fd043703          	ld	a4,-48(s0)
ffffffe000200aec:	fd843783          	ld	a5,-40(s0)
ffffffe000200af0:	00070313          	mv	t1,a4
ffffffe000200af4:	00078393          	mv	t2,a5
ffffffe000200af8:	00030713          	mv	a4,t1
ffffffe000200afc:	00038793          	mv	a5,t2
}
ffffffe000200b00:	00070513          	mv	a0,a4
ffffffe000200b04:	00078593          	mv	a1,a5
ffffffe000200b08:	07813403          	ld	s0,120(sp)
ffffffe000200b0c:	07013483          	ld	s1,112(sp)
ffffffe000200b10:	06813903          	ld	s2,104(sp)
ffffffe000200b14:	06013983          	ld	s3,96(sp)
ffffffe000200b18:	08010113          	addi	sp,sp,128
ffffffe000200b1c:	00008067          	ret

ffffffe000200b20 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000200b20:	fd010113          	addi	sp,sp,-48
ffffffe000200b24:	02813423          	sd	s0,40(sp)
ffffffe000200b28:	03010413          	addi	s0,sp,48
ffffffe000200b2c:	00050793          	mv	a5,a0
ffffffe000200b30:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200b34:	00100793          	li	a5,1
ffffffe000200b38:	00000713          	li	a4,0
ffffffe000200b3c:	fdf44683          	lbu	a3,-33(s0)
ffffffe000200b40:	00078893          	mv	a7,a5
ffffffe000200b44:	00070813          	mv	a6,a4
ffffffe000200b48:	00068513          	mv	a0,a3
ffffffe000200b4c:	00000073          	ecall
ffffffe000200b50:	00050713          	mv	a4,a0
ffffffe000200b54:	00058793          	mv	a5,a1
ffffffe000200b58:	fee43023          	sd	a4,-32(s0)
ffffffe000200b5c:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
ffffffe000200b60:	00000013          	nop
ffffffe000200b64:	00070513          	mv	a0,a4
ffffffe000200b68:	00078593          	mv	a1,a5
ffffffe000200b6c:	02813403          	ld	s0,40(sp)
ffffffe000200b70:	03010113          	addi	sp,sp,48
ffffffe000200b74:	00008067          	ret

ffffffe000200b78 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000200b78:	fc010113          	addi	sp,sp,-64
ffffffe000200b7c:	02813c23          	sd	s0,56(sp)
ffffffe000200b80:	04010413          	addi	s0,sp,64
ffffffe000200b84:	00050793          	mv	a5,a0
ffffffe000200b88:	00058713          	mv	a4,a1
ffffffe000200b8c:	fcf42623          	sw	a5,-52(s0)
ffffffe000200b90:	00070793          	mv	a5,a4
ffffffe000200b94:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200b98:	00800793          	li	a5,8
ffffffe000200b9c:	00000713          	li	a4,0
ffffffe000200ba0:	fcc42583          	lw	a1,-52(s0)
ffffffe000200ba4:	00058313          	mv	t1,a1
ffffffe000200ba8:	fc842583          	lw	a1,-56(s0)
ffffffe000200bac:	00058e13          	mv	t3,a1
ffffffe000200bb0:	00078893          	mv	a7,a5
ffffffe000200bb4:	00070813          	mv	a6,a4
ffffffe000200bb8:	00030513          	mv	a0,t1
ffffffe000200bbc:	000e0593          	mv	a1,t3
ffffffe000200bc0:	00000073          	ecall
ffffffe000200bc4:	00050713          	mv	a4,a0
ffffffe000200bc8:	00058793          	mv	a5,a1
ffffffe000200bcc:	fce43823          	sd	a4,-48(s0)
ffffffe000200bd0:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
ffffffe000200bd4:	fd043783          	ld	a5,-48(s0)
ffffffe000200bd8:	fef43023          	sd	a5,-32(s0)
ffffffe000200bdc:	fd843783          	ld	a5,-40(s0)
ffffffe000200be0:	fef43423          	sd	a5,-24(s0)
ffffffe000200be4:	fe043703          	ld	a4,-32(s0)
ffffffe000200be8:	fe843783          	ld	a5,-24(s0)
ffffffe000200bec:	00070613          	mv	a2,a4
ffffffe000200bf0:	00078693          	mv	a3,a5
ffffffe000200bf4:	00060713          	mv	a4,a2
ffffffe000200bf8:	00068793          	mv	a5,a3
ffffffe000200bfc:	00070513          	mv	a0,a4
ffffffe000200c00:	00078593          	mv	a1,a5
ffffffe000200c04:	03813403          	ld	s0,56(sp)
ffffffe000200c08:	04010113          	addi	sp,sp,64
ffffffe000200c0c:	00008067          	ret

ffffffe000200c10 <trap_handler>:
extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc) {
ffffffe000200c10:	fd010113          	addi	sp,sp,-48
ffffffe000200c14:	02113423          	sd	ra,40(sp)
ffffffe000200c18:	02813023          	sd	s0,32(sp)
ffffffe000200c1c:	03010413          	addi	s0,sp,48
ffffffe000200c20:	fca43c23          	sd	a0,-40(s0)
ffffffe000200c24:	fcb43823          	sd	a1,-48(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
ffffffe000200c28:	fd843783          	ld	a5,-40(s0)
ffffffe000200c2c:	0407d063          	bgez	a5,ffffffe000200c6c <trap_handler+0x5c>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
ffffffe000200c30:	fd843783          	ld	a5,-40(s0)
ffffffe000200c34:	0ff7f793          	zext.b	a5,a5
ffffffe000200c38:	fef43423          	sd	a5,-24(s0)
        if (interrupt_t == 0x5) {
ffffffe000200c3c:	fe843703          	ld	a4,-24(s0)
ffffffe000200c40:	00500793          	li	a5,5
ffffffe000200c44:	00f71863          	bne	a4,a5,ffffffe000200c54 <trap_handler+0x44>
            // timer interrupt
            clock_set_next_event();
ffffffe000200c48:	e4cff0ef          	jal	ra,ffffffe000200294 <clock_set_next_event>
            do_timer();
ffffffe000200c4c:	ad9ff0ef          	jal	ra,ffffffe000200724 <do_timer>
    }
    else {
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        // exception
    }
ffffffe000200c50:	0300006f          	j	ffffffe000200c80 <trap_handler+0x70>
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000200c54:	fd043603          	ld	a2,-48(s0)
ffffffe000200c58:	fd843583          	ld	a1,-40(s0)
ffffffe000200c5c:	00002517          	auipc	a0,0x2
ffffffe000200c60:	42450513          	addi	a0,a0,1060 # ffffffe000203080 <_srodata+0x80>
ffffffe000200c64:	7b4010ef          	jal	ra,ffffffe000202418 <printk>
ffffffe000200c68:	0180006f          	j	ffffffe000200c80 <trap_handler+0x70>
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
ffffffe000200c6c:	fd043603          	ld	a2,-48(s0)
ffffffe000200c70:	fd843583          	ld	a1,-40(s0)
ffffffe000200c74:	00002517          	auipc	a0,0x2
ffffffe000200c78:	43c50513          	addi	a0,a0,1084 # ffffffe0002030b0 <_srodata+0xb0>
ffffffe000200c7c:	79c010ef          	jal	ra,ffffffe000202418 <printk>
ffffffe000200c80:	00000013          	nop
ffffffe000200c84:	02813083          	ld	ra,40(sp)
ffffffe000200c88:	02013403          	ld	s0,32(sp)
ffffffe000200c8c:	03010113          	addi	sp,sp,48
ffffffe000200c90:	00008067          	ret

ffffffe000200c94 <setup_vm>:
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe000200c94:	fe010113          	addi	sp,sp,-32
ffffffe000200c98:	00113c23          	sd	ra,24(sp)
ffffffe000200c9c:	00813823          	sd	s0,16(sp)
ffffffe000200ca0:	02010413          	addi	s0,sp,32
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);
ffffffe000200ca4:	00001637          	lui	a2,0x1
ffffffe000200ca8:	00000593          	li	a1,0
ffffffe000200cac:	00006517          	auipc	a0,0x6
ffffffe000200cb0:	35450513          	addi	a0,a0,852 # ffffffe000207000 <early_pgtbl>
ffffffe000200cb4:	085010ef          	jal	ra,ffffffe000202538 <memset>

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)
ffffffe000200cb8:	00f00793          	li	a5,15
ffffffe000200cbc:	fef43023          	sd	a5,-32(s0)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000200cc0:	fe043423          	sd	zero,-24(s0)
ffffffe000200cc4:	0740006f          	j	ffffffe000200d38 <setup_vm+0xa4>
        map_vm(VM_START + i, PHY_START + i, entry_perm);
ffffffe000200cc8:	fe843703          	ld	a4,-24(s0)
ffffffe000200ccc:	fff00793          	li	a5,-1
ffffffe000200cd0:	02579793          	slli	a5,a5,0x25
ffffffe000200cd4:	00f706b3          	add	a3,a4,a5
ffffffe000200cd8:	fe843703          	ld	a4,-24(s0)
ffffffe000200cdc:	00100793          	li	a5,1
ffffffe000200ce0:	01f79793          	slli	a5,a5,0x1f
ffffffe000200ce4:	00f707b3          	add	a5,a4,a5
ffffffe000200ce8:	fe043603          	ld	a2,-32(s0)
ffffffe000200cec:	00078593          	mv	a1,a5
ffffffe000200cf0:	00068513          	mv	a0,a3
ffffffe000200cf4:	074000ef          	jal	ra,ffffffe000200d68 <map_vm>
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
ffffffe000200cf8:	fe843703          	ld	a4,-24(s0)
ffffffe000200cfc:	00100793          	li	a5,1
ffffffe000200d00:	01f79793          	slli	a5,a5,0x1f
ffffffe000200d04:	00f706b3          	add	a3,a4,a5
ffffffe000200d08:	fe843703          	ld	a4,-24(s0)
ffffffe000200d0c:	00100793          	li	a5,1
ffffffe000200d10:	01f79793          	slli	a5,a5,0x1f
ffffffe000200d14:	00f707b3          	add	a5,a4,a5
ffffffe000200d18:	fe043603          	ld	a2,-32(s0)
ffffffe000200d1c:	00078593          	mv	a1,a5
ffffffe000200d20:	00068513          	mv	a0,a3
ffffffe000200d24:	044000ef          	jal	ra,ffffffe000200d68 <map_vm>
    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
ffffffe000200d28:	fe843703          	ld	a4,-24(s0)
ffffffe000200d2c:	400007b7          	lui	a5,0x40000
ffffffe000200d30:	00f707b3          	add	a5,a4,a5
ffffffe000200d34:	fef43423          	sd	a5,-24(s0)
ffffffe000200d38:	fe843703          	ld	a4,-24(s0)
ffffffe000200d3c:	01f00793          	li	a5,31
ffffffe000200d40:	02079793          	slli	a5,a5,0x20
ffffffe000200d44:	f8f762e3          	bltu	a4,a5,ffffffe000200cc8 <setup_vm+0x34>
    }

    printk("...setup_vm done\n");
ffffffe000200d48:	00002517          	auipc	a0,0x2
ffffffe000200d4c:	39850513          	addi	a0,a0,920 # ffffffe0002030e0 <_srodata+0xe0>
ffffffe000200d50:	6c8010ef          	jal	ra,ffffffe000202418 <printk>
    return;
ffffffe000200d54:	00000013          	nop
}
ffffffe000200d58:	01813083          	ld	ra,24(sp)
ffffffe000200d5c:	01013403          	ld	s0,16(sp)
ffffffe000200d60:	02010113          	addi	sp,sp,32
ffffffe000200d64:	00008067          	ret

ffffffe000200d68 <map_vm>:

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000200d68:	fc010113          	addi	sp,sp,-64
ffffffe000200d6c:	02813c23          	sd	s0,56(sp)
ffffffe000200d70:	04010413          	addi	s0,sp,64
ffffffe000200d74:	fca43c23          	sd	a0,-40(s0)
ffffffe000200d78:	fcb43823          	sd	a1,-48(s0)
ffffffe000200d7c:	fcc43423          	sd	a2,-56(s0)
    uint64_t idx = (va >> 30) & 0x1FF;
ffffffe000200d80:	fd843783          	ld	a5,-40(s0)
ffffffe000200d84:	01e7d793          	srli	a5,a5,0x1e
ffffffe000200d88:	1ff7f793          	andi	a5,a5,511
ffffffe000200d8c:	fef43423          	sd	a5,-24(s0)
    uint64_t entry = ((pa >> 12) << 10) | perm;
ffffffe000200d90:	fd043783          	ld	a5,-48(s0)
ffffffe000200d94:	00c7d793          	srli	a5,a5,0xc
ffffffe000200d98:	00a79793          	slli	a5,a5,0xa
ffffffe000200d9c:	fc843703          	ld	a4,-56(s0)
ffffffe000200da0:	00f767b3          	or	a5,a4,a5
ffffffe000200da4:	fef43023          	sd	a5,-32(s0)
    early_pgtbl[idx] = entry;
ffffffe000200da8:	00006717          	auipc	a4,0x6
ffffffe000200dac:	25870713          	addi	a4,a4,600 # ffffffe000207000 <early_pgtbl>
ffffffe000200db0:	fe843783          	ld	a5,-24(s0)
ffffffe000200db4:	00379793          	slli	a5,a5,0x3
ffffffe000200db8:	00f707b3          	add	a5,a4,a5
ffffffe000200dbc:	fe043703          	ld	a4,-32(s0)
ffffffe000200dc0:	00e7b023          	sd	a4,0(a5) # 40000000 <PHY_SIZE+0x38000000>
}
ffffffe000200dc4:	00000013          	nop
ffffffe000200dc8:	03813403          	ld	s0,56(sp)
ffffffe000200dcc:	04010113          	addi	sp,sp,64
ffffffe000200dd0:	00008067          	ret

ffffffe000200dd4 <setup_pgtbl>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
ffffffe000200dd4:	fc010113          	addi	sp,sp,-64
ffffffe000200dd8:	02113c23          	sd	ra,56(sp)
ffffffe000200ddc:	02813823          	sd	s0,48(sp)
ffffffe000200de0:	04010413          	addi	s0,sp,64
ffffffe000200de4:	fca43c23          	sd	a0,-40(s0)
ffffffe000200de8:	fcb43823          	sd	a1,-48(s0)
ffffffe000200dec:	fcc43423          	sd	a2,-56(s0)
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
ffffffe000200df0:	cecff0ef          	jal	ra,ffffffe0002002dc <kalloc>
ffffffe000200df4:	00050793          	mv	a5,a0
ffffffe000200df8:	00078713          	mv	a4,a5
ffffffe000200dfc:	04100793          	li	a5,65
ffffffe000200e00:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e04:	00f707b3          	add	a5,a4,a5
ffffffe000200e08:	fef43423          	sd	a5,-24(s0)
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
ffffffe000200e0c:	fe843783          	ld	a5,-24(s0)
ffffffe000200e10:	00c7d793          	srli	a5,a5,0xc
ffffffe000200e14:	00a79693          	slli	a3,a5,0xa
ffffffe000200e18:	fd043783          	ld	a5,-48(s0)
ffffffe000200e1c:	00379793          	slli	a5,a5,0x3
ffffffe000200e20:	fd843703          	ld	a4,-40(s0)
ffffffe000200e24:	00f707b3          	add	a5,a4,a5
ffffffe000200e28:	fc843703          	ld	a4,-56(s0)
ffffffe000200e2c:	00e6e733          	or	a4,a3,a4
ffffffe000200e30:	00e7b023          	sd	a4,0(a5)
    return pgtbl[pte_idx];
ffffffe000200e34:	fd043783          	ld	a5,-48(s0)
ffffffe000200e38:	00379793          	slli	a5,a5,0x3
ffffffe000200e3c:	fd843703          	ld	a4,-40(s0)
ffffffe000200e40:	00f707b3          	add	a5,a4,a5
ffffffe000200e44:	0007b783          	ld	a5,0(a5)
}
ffffffe000200e48:	00078513          	mv	a0,a5
ffffffe000200e4c:	03813083          	ld	ra,56(sp)
ffffffe000200e50:	03013403          	ld	s0,48(sp)
ffffffe000200e54:	04010113          	addi	sp,sp,64
ffffffe000200e58:	00008067          	ret

ffffffe000200e5c <setup_vm_final>:

void setup_vm_final() {
ffffffe000200e5c:	f9010113          	addi	sp,sp,-112
ffffffe000200e60:	06113423          	sd	ra,104(sp)
ffffffe000200e64:	06813023          	sd	s0,96(sp)
ffffffe000200e68:	07010413          	addi	s0,sp,112
    printk("...setup_vm_final\n");
ffffffe000200e6c:	00002517          	auipc	a0,0x2
ffffffe000200e70:	28c50513          	addi	a0,a0,652 # ffffffe0002030f8 <_srodata+0xf8>
ffffffe000200e74:	5a4010ef          	jal	ra,ffffffe000202418 <printk>
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000200e78:	00001637          	lui	a2,0x1
ffffffe000200e7c:	00000593          	li	a1,0
ffffffe000200e80:	00007517          	auipc	a0,0x7
ffffffe000200e84:	18050513          	addi	a0,a0,384 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200e88:	6b0010ef          	jal	ra,ffffffe000202538 <memset>

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
ffffffe000200e8c:	40100793          	li	a5,1025
ffffffe000200e90:	01579793          	slli	a5,a5,0x15
ffffffe000200e94:	fef43423          	sd	a5,-24(s0)
    uint64_t v_base = VM_START + OPENSBI_SIZE;
ffffffe000200e98:	f00017b7          	lui	a5,0xf0001
ffffffe000200e9c:	00979793          	slli	a5,a5,0x9
ffffffe000200ea0:	fef43023          	sd	a5,-32(s0)
    uint64_t p_end = PHY_END;
ffffffe000200ea4:	01100793          	li	a5,17
ffffffe000200ea8:	01b79793          	slli	a5,a5,0x1b
ffffffe000200eac:	fcf43c23          	sd	a5,-40(s0)
    uint64_t v_end = PHY_END + PA2VA_OFFSET;
ffffffe000200eb0:	c0100793          	li	a5,-1023
ffffffe000200eb4:	01b79793          	slli	a5,a5,0x1b
ffffffe000200eb8:	fcf43823          	sd	a5,-48(s0)

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
ffffffe000200ebc:	fe043783          	ld	a5,-32(s0)
ffffffe000200ec0:	fcf43423          	sd	a5,-56(s0)
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
ffffffe000200ec4:	00001717          	auipc	a4,0x1
ffffffe000200ec8:	6e470713          	addi	a4,a4,1764 # ffffffe0002025a8 <_etext>
ffffffe000200ecc:	000017b7          	lui	a5,0x1
ffffffe000200ed0:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200ed4:	00f70733          	add	a4,a4,a5
ffffffe000200ed8:	fffff7b7          	lui	a5,0xfffff
ffffffe000200edc:	00f777b3          	and	a5,a4,a5
ffffffe000200ee0:	fcf43023          	sd	a5,-64(s0)
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
ffffffe000200ee4:	fc843703          	ld	a4,-56(s0)
ffffffe000200ee8:	04100793          	li	a5,65
ffffffe000200eec:	01f79793          	slli	a5,a5,0x1f
ffffffe000200ef0:	00f70633          	add	a2,a4,a5
ffffffe000200ef4:	fc043703          	ld	a4,-64(s0)
ffffffe000200ef8:	fc843783          	ld	a5,-56(s0)
ffffffe000200efc:	40f707b3          	sub	a5,a4,a5
ffffffe000200f00:	00b00713          	li	a4,11
ffffffe000200f04:	00078693          	mv	a3,a5
ffffffe000200f08:	fc843583          	ld	a1,-56(s0)
ffffffe000200f0c:	00007517          	auipc	a0,0x7
ffffffe000200f10:	0f450513          	addi	a0,a0,244 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200f14:	180000ef          	jal	ra,ffffffe000201094 <create_mapping>
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);
ffffffe000200f18:	00b00693          	li	a3,11
ffffffe000200f1c:	fc043603          	ld	a2,-64(s0)
ffffffe000200f20:	fc843583          	ld	a1,-56(s0)
ffffffe000200f24:	00002517          	auipc	a0,0x2
ffffffe000200f28:	1ec50513          	addi	a0,a0,492 # ffffffe000203110 <_srodata+0x110>
ffffffe000200f2c:	4ec010ef          	jal	ra,ffffffe000202418 <printk>

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
ffffffe000200f30:	fc043783          	ld	a5,-64(s0)
ffffffe000200f34:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
ffffffe000200f38:	00002717          	auipc	a4,0x2
ffffffe000200f3c:	54070713          	addi	a4,a4,1344 # ffffffe000203478 <_erodata>
ffffffe000200f40:	000017b7          	lui	a5,0x1
ffffffe000200f44:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200f48:	00f70733          	add	a4,a4,a5
ffffffe000200f4c:	fffff7b7          	lui	a5,0xfffff
ffffffe000200f50:	00f777b3          	and	a5,a4,a5
ffffffe000200f54:	faf43823          	sd	a5,-80(s0)
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
ffffffe000200f58:	fb843703          	ld	a4,-72(s0)
ffffffe000200f5c:	04100793          	li	a5,65
ffffffe000200f60:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f64:	00f70633          	add	a2,a4,a5
ffffffe000200f68:	fb043703          	ld	a4,-80(s0)
ffffffe000200f6c:	fb843783          	ld	a5,-72(s0)
ffffffe000200f70:	40f707b3          	sub	a5,a4,a5
ffffffe000200f74:	00300713          	li	a4,3
ffffffe000200f78:	00078693          	mv	a3,a5
ffffffe000200f7c:	fb843583          	ld	a1,-72(s0)
ffffffe000200f80:	00007517          	auipc	a0,0x7
ffffffe000200f84:	08050513          	addi	a0,a0,128 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200f88:	10c000ef          	jal	ra,ffffffe000201094 <create_mapping>
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);
ffffffe000200f8c:	00300693          	li	a3,3
ffffffe000200f90:	fb043603          	ld	a2,-80(s0)
ffffffe000200f94:	fb843583          	ld	a1,-72(s0)
ffffffe000200f98:	00002517          	auipc	a0,0x2
ffffffe000200f9c:	1b050513          	addi	a0,a0,432 # ffffffe000203148 <_srodata+0x148>
ffffffe000200fa0:	478010ef          	jal	ra,ffffffe000202418 <printk>

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
ffffffe000200fa4:	fb043783          	ld	a5,-80(s0)
ffffffe000200fa8:	faf43423          	sd	a5,-88(s0)
    uint64_t data_end = v_end;
ffffffe000200fac:	fd043783          	ld	a5,-48(s0)
ffffffe000200fb0:	faf43023          	sd	a5,-96(s0)
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
ffffffe000200fb4:	fa843703          	ld	a4,-88(s0)
ffffffe000200fb8:	04100793          	li	a5,65
ffffffe000200fbc:	01f79793          	slli	a5,a5,0x1f
ffffffe000200fc0:	00f70633          	add	a2,a4,a5
ffffffe000200fc4:	fa043703          	ld	a4,-96(s0)
ffffffe000200fc8:	fa843783          	ld	a5,-88(s0)
ffffffe000200fcc:	40f707b3          	sub	a5,a4,a5
ffffffe000200fd0:	00700713          	li	a4,7
ffffffe000200fd4:	00078693          	mv	a3,a5
ffffffe000200fd8:	fa843583          	ld	a1,-88(s0)
ffffffe000200fdc:	00007517          	auipc	a0,0x7
ffffffe000200fe0:	02450513          	addi	a0,a0,36 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200fe4:	0b0000ef          	jal	ra,ffffffe000201094 <create_mapping>
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);
ffffffe000200fe8:	00700693          	li	a3,7
ffffffe000200fec:	fa043603          	ld	a2,-96(s0)
ffffffe000200ff0:	fa843583          	ld	a1,-88(s0)
ffffffe000200ff4:	00002517          	auipc	a0,0x2
ffffffe000200ff8:	18c50513          	addi	a0,a0,396 # ffffffe000203180 <_srodata+0x180>
ffffffe000200ffc:	41c010ef          	jal	ra,ffffffe000202418 <printk>

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
ffffffe000201000:	00007517          	auipc	a0,0x7
ffffffe000201004:	00050513          	mv	a0,a0
ffffffe000201008:	044000ef          	jal	ra,ffffffe00020104c <get_satp>
ffffffe00020100c:	f8a43c23          	sd	a0,-104(s0)
    csr_write(satp, satp);
ffffffe000201010:	f9843783          	ld	a5,-104(s0)
ffffffe000201014:	f8f43823          	sd	a5,-112(s0)
ffffffe000201018:	f9043783          	ld	a5,-112(s0)
ffffffe00020101c:	18079073          	csrw	satp,a5

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);
ffffffe000201020:	f9843583          	ld	a1,-104(s0)
ffffffe000201024:	00002517          	auipc	a0,0x2
ffffffe000201028:	18c50513          	addi	a0,a0,396 # ffffffe0002031b0 <_srodata+0x1b0>
ffffffe00020102c:	3ec010ef          	jal	ra,ffffffe000202418 <printk>

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201030:	12000073          	sfence.vma

    // flush icache
    asm volatile("fence.i");
ffffffe000201034:	0000100f          	fence.i
    return;
ffffffe000201038:	00000013          	nop
}
ffffffe00020103c:	06813083          	ld	ra,104(sp)
ffffffe000201040:	06013403          	ld	s0,96(sp)
ffffffe000201044:	07010113          	addi	sp,sp,112
ffffffe000201048:	00008067          	ret

ffffffe00020104c <get_satp>:

uint64_t get_satp(uint64_t *pgtbl){
ffffffe00020104c:	fd010113          	addi	sp,sp,-48
ffffffe000201050:	02813423          	sd	s0,40(sp)
ffffffe000201054:	03010413          	addi	s0,sp,48
ffffffe000201058:	fca43c23          	sd	a0,-40(s0)
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
ffffffe00020105c:	fd843703          	ld	a4,-40(s0)
ffffffe000201060:	04100793          	li	a5,65
ffffffe000201064:	01f79793          	slli	a5,a5,0x1f
ffffffe000201068:	00f707b3          	add	a5,a4,a5
ffffffe00020106c:	fef43423          	sd	a5,-24(s0)
    return (SV39 << 60) | (pa_pgtbl >> 12);
ffffffe000201070:	fe843783          	ld	a5,-24(s0)
ffffffe000201074:	00c7d713          	srli	a4,a5,0xc
ffffffe000201078:	fff00793          	li	a5,-1
ffffffe00020107c:	03f79793          	slli	a5,a5,0x3f
ffffffe000201080:	00f767b3          	or	a5,a4,a5
}
ffffffe000201084:	00078513          	mv	a0,a5
ffffffe000201088:	02813403          	ld	s0,40(sp)
ffffffe00020108c:	03010113          	addi	sp,sp,48
ffffffe000201090:	00008067          	ret

ffffffe000201094 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201094:	fb010113          	addi	sp,sp,-80
ffffffe000201098:	04113423          	sd	ra,72(sp)
ffffffe00020109c:	04813023          	sd	s0,64(sp)
ffffffe0002010a0:	05010413          	addi	s0,sp,80
ffffffe0002010a4:	fca43c23          	sd	a0,-40(s0)
ffffffe0002010a8:	fcb43823          	sd	a1,-48(s0)
ffffffe0002010ac:	fcc43423          	sd	a2,-56(s0)
ffffffe0002010b0:	fcd43023          	sd	a3,-64(s0)
ffffffe0002010b4:	fae43c23          	sd	a4,-72(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
ffffffe0002010b8:	fc043683          	ld	a3,-64(s0)
ffffffe0002010bc:	fc843603          	ld	a2,-56(s0)
ffffffe0002010c0:	fd043583          	ld	a1,-48(s0)
ffffffe0002010c4:	00002517          	auipc	a0,0x2
ffffffe0002010c8:	0fc50513          	addi	a0,a0,252 # ffffffe0002031c0 <_srodata+0x1c0>
ffffffe0002010cc:	34c010ef          	jal	ra,ffffffe000202418 <printk>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe0002010d0:	fd043783          	ld	a5,-48(s0)
ffffffe0002010d4:	fef43423          	sd	a5,-24(s0)
ffffffe0002010d8:	fc843783          	ld	a5,-56(s0)
ffffffe0002010dc:	fef43023          	sd	a5,-32(s0)
ffffffe0002010e0:	0380006f          	j	ffffffe000201118 <create_mapping+0x84>
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
ffffffe0002010e4:	fb843683          	ld	a3,-72(s0)
ffffffe0002010e8:	fe043603          	ld	a2,-32(s0)
ffffffe0002010ec:	fe843583          	ld	a1,-24(s0)
ffffffe0002010f0:	fd843503          	ld	a0,-40(s0)
ffffffe0002010f4:	050000ef          	jal	ra,ffffffe000201144 <map_vm_final>
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
ffffffe0002010f8:	fe843703          	ld	a4,-24(s0)
ffffffe0002010fc:	000017b7          	lui	a5,0x1
ffffffe000201100:	00f707b3          	add	a5,a4,a5
ffffffe000201104:	fef43423          	sd	a5,-24(s0)
ffffffe000201108:	fe043703          	ld	a4,-32(s0)
ffffffe00020110c:	000017b7          	lui	a5,0x1
ffffffe000201110:	00f707b3          	add	a5,a4,a5
ffffffe000201114:	fef43023          	sd	a5,-32(s0)
ffffffe000201118:	fd043703          	ld	a4,-48(s0)
ffffffe00020111c:	fc043783          	ld	a5,-64(s0)
ffffffe000201120:	00f707b3          	add	a5,a4,a5
ffffffe000201124:	fe843703          	ld	a4,-24(s0)
ffffffe000201128:	faf76ee3          	bltu	a4,a5,ffffffe0002010e4 <create_mapping+0x50>
   }
}
ffffffe00020112c:	00000013          	nop
ffffffe000201130:	00000013          	nop
ffffffe000201134:	04813083          	ld	ra,72(sp)
ffffffe000201138:	04013403          	ld	s0,64(sp)
ffffffe00020113c:	05010113          	addi	sp,sp,80
ffffffe000201140:	00008067          	ret

ffffffe000201144 <map_vm_final>:

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
ffffffe000201144:	f9010113          	addi	sp,sp,-112
ffffffe000201148:	06113423          	sd	ra,104(sp)
ffffffe00020114c:	06813023          	sd	s0,96(sp)
ffffffe000201150:	07010413          	addi	s0,sp,112
ffffffe000201154:	faa43423          	sd	a0,-88(s0)
ffffffe000201158:	fab43023          	sd	a1,-96(s0)
ffffffe00020115c:	f8c43c23          	sd	a2,-104(s0)
ffffffe000201160:	f8d43823          	sd	a3,-112(s0)
    uint64_t idx1 = (va >> 30) & 0x1FF;
ffffffe000201164:	fa043783          	ld	a5,-96(s0)
ffffffe000201168:	01e7d793          	srli	a5,a5,0x1e
ffffffe00020116c:	1ff7f793          	andi	a5,a5,511
ffffffe000201170:	fcf43c23          	sd	a5,-40(s0)
    uint64_t idx2 = (va >> 21) & 0x1FF;
ffffffe000201174:	fa043783          	ld	a5,-96(s0)
ffffffe000201178:	0157d793          	srli	a5,a5,0x15
ffffffe00020117c:	1ff7f793          	andi	a5,a5,511
ffffffe000201180:	fcf43823          	sd	a5,-48(s0)
    uint64_t idx3 = (va >> 12) & 0x1FF;
ffffffe000201184:	fa043783          	ld	a5,-96(s0)
ffffffe000201188:	00c7d793          	srli	a5,a5,0xc
ffffffe00020118c:	1ff7f793          	andi	a5,a5,511
ffffffe000201190:	fcf43423          	sd	a5,-56(s0)

    uint64_t pte = pgtbl[idx1];
ffffffe000201194:	fd843783          	ld	a5,-40(s0)
ffffffe000201198:	00379793          	slli	a5,a5,0x3
ffffffe00020119c:	fa843703          	ld	a4,-88(s0)
ffffffe0002011a0:	00f707b3          	add	a5,a4,a5
ffffffe0002011a4:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe0002011a8:	fef43423          	sd	a5,-24(s0)
    if(PTE_ISVALID(pte) == 0){
ffffffe0002011ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002011b0:	0017f793          	andi	a5,a5,1
ffffffe0002011b4:	00079c63          	bnez	a5,ffffffe0002011cc <map_vm_final+0x88>
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
ffffffe0002011b8:	00100613          	li	a2,1
ffffffe0002011bc:	fd843583          	ld	a1,-40(s0)
ffffffe0002011c0:	fa843503          	ld	a0,-88(s0)
ffffffe0002011c4:	c11ff0ef          	jal	ra,ffffffe000200dd4 <setup_pgtbl>
ffffffe0002011c8:	fea43423          	sd	a0,-24(s0)
    }

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12)); // VA
ffffffe0002011cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002011d0:	00a7d793          	srli	a5,a5,0xa
ffffffe0002011d4:	00c79793          	slli	a5,a5,0xc
ffffffe0002011d8:	fcf43023          	sd	a5,-64(s0)
    uint64_t pte2 = pgtbl2[idx2];
ffffffe0002011dc:	fd043783          	ld	a5,-48(s0)
ffffffe0002011e0:	00379793          	slli	a5,a5,0x3
ffffffe0002011e4:	fc043703          	ld	a4,-64(s0)
ffffffe0002011e8:	00f707b3          	add	a5,a4,a5
ffffffe0002011ec:	0007b783          	ld	a5,0(a5)
ffffffe0002011f0:	fef43023          	sd	a5,-32(s0)
    if(PTE_ISVALID(pte2) == 0){
ffffffe0002011f4:	fe043783          	ld	a5,-32(s0)
ffffffe0002011f8:	0017f793          	andi	a5,a5,1
ffffffe0002011fc:	00079c63          	bnez	a5,ffffffe000201214 <map_vm_final+0xd0>
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
ffffffe000201200:	00100613          	li	a2,1
ffffffe000201204:	fd043583          	ld	a1,-48(s0)
ffffffe000201208:	fc043503          	ld	a0,-64(s0)
ffffffe00020120c:	bc9ff0ef          	jal	ra,ffffffe000200dd4 <setup_pgtbl>
ffffffe000201210:	fea43023          	sd	a0,-32(s0)
    }

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12));// VA
ffffffe000201214:	fe043783          	ld	a5,-32(s0)
ffffffe000201218:	00a7d793          	srli	a5,a5,0xa
ffffffe00020121c:	00c79793          	slli	a5,a5,0xc
ffffffe000201220:	faf43c23          	sd	a5,-72(s0)
    perm = perm | PTE_V;
ffffffe000201224:	f9043783          	ld	a5,-112(s0)
ffffffe000201228:	0017e793          	ori	a5,a5,1
ffffffe00020122c:	f8f43823          	sd	a5,-112(s0)
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
ffffffe000201230:	f9843783          	ld	a5,-104(s0)
ffffffe000201234:	00c7d793          	srli	a5,a5,0xc
ffffffe000201238:	00a79693          	slli	a3,a5,0xa
ffffffe00020123c:	fc843783          	ld	a5,-56(s0)
ffffffe000201240:	00379793          	slli	a5,a5,0x3
ffffffe000201244:	fb843703          	ld	a4,-72(s0)
ffffffe000201248:	00f707b3          	add	a5,a4,a5
ffffffe00020124c:	f9043703          	ld	a4,-112(s0)
ffffffe000201250:	00e6e733          	or	a4,a3,a4
ffffffe000201254:	00e7b023          	sd	a4,0(a5)
ffffffe000201258:	00000013          	nop
ffffffe00020125c:	06813083          	ld	ra,104(sp)
ffffffe000201260:	06013403          	ld	s0,96(sp)
ffffffe000201264:	07010113          	addi	sp,sp,112
ffffffe000201268:	00008067          	ret

ffffffe00020126c <start_kernel>:
#include "printk.h"
#include "defs.h"

extern void test();

int start_kernel() {
ffffffe00020126c:	ff010113          	addi	sp,sp,-16
ffffffe000201270:	00113423          	sd	ra,8(sp)
ffffffe000201274:	00813023          	sd	s0,0(sp)
ffffffe000201278:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe00020127c:	00002517          	auipc	a0,0x2
ffffffe000201280:	f6c50513          	addi	a0,a0,-148 # ffffffe0002031e8 <_srodata+0x1e8>
ffffffe000201284:	194010ef          	jal	ra,ffffffe000202418 <printk>
    printk(" ZJU Operating System\n");
ffffffe000201288:	00002517          	auipc	a0,0x2
ffffffe00020128c:	f6850513          	addi	a0,a0,-152 # ffffffe0002031f0 <_srodata+0x1f0>
ffffffe000201290:	188010ef          	jal	ra,ffffffe000202418 <printk>
    // verify_vm();

    test();
ffffffe000201294:	2c0000ef          	jal	ra,ffffffe000201554 <test>
    return 0;
ffffffe000201298:	00000793          	li	a5,0
}
ffffffe00020129c:	00078513          	mv	a0,a5
ffffffe0002012a0:	00813083          	ld	ra,8(sp)
ffffffe0002012a4:	00013403          	ld	s0,0(sp)
ffffffe0002012a8:	01010113          	addi	sp,sp,16
ffffffe0002012ac:	00008067          	ret

ffffffe0002012b0 <test_rodata_write>:

void test_rodata_write(uint64_t *addr) {
ffffffe0002012b0:	fd010113          	addi	sp,sp,-48
ffffffe0002012b4:	02113423          	sd	ra,40(sp)
ffffffe0002012b8:	02813023          	sd	s0,32(sp)
ffffffe0002012bc:	03010413          	addi	s0,sp,48
ffffffe0002012c0:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr;
ffffffe0002012c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002012c8:	0007b783          	ld	a5,0(a5)
ffffffe0002012cc:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe0002012d0:	00100793          	li	a5,1
ffffffe0002012d4:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe0002012d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002012dc:	00100293          	li	t0,1
ffffffe0002012e0:	0057b023          	sd	t0,0(a5)
ffffffe0002012e4:	00000793          	li	a5,0
ffffffe0002012e8:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe0002012ec:	fe442783          	lw	a5,-28(s0)
ffffffe0002012f0:	0007879b          	sext.w	a5,a5
ffffffe0002012f4:	02078063          	beqz	a5,ffffffe000201314 <test_rodata_write+0x64>
        printk("ERROR: .rodata write succeeded unexpectedly!\n");
ffffffe0002012f8:	00002517          	auipc	a0,0x2
ffffffe0002012fc:	f1050513          	addi	a0,a0,-240 # ffffffe000203208 <_srodata+0x208>
ffffffe000201300:	118010ef          	jal	ra,ffffffe000202418 <printk>
        *addr = backup; // 恢复原值
ffffffe000201304:	fd843783          	ld	a5,-40(s0)
ffffffe000201308:	fe843703          	ld	a4,-24(s0)
ffffffe00020130c:	00e7b023          	sd	a4,0(a5)
    } else {
        printk("PASS: .rodata write failed as expected.\n");
    }
}
ffffffe000201310:	0100006f          	j	ffffffe000201320 <test_rodata_write+0x70>
        printk("PASS: .rodata write failed as expected.\n");
ffffffe000201314:	00002517          	auipc	a0,0x2
ffffffe000201318:	f2450513          	addi	a0,a0,-220 # ffffffe000203238 <_srodata+0x238>
ffffffe00020131c:	0fc010ef          	jal	ra,ffffffe000202418 <printk>
}
ffffffe000201320:	00000013          	nop
ffffffe000201324:	02813083          	ld	ra,40(sp)
ffffffe000201328:	02013403          	ld	s0,32(sp)
ffffffe00020132c:	03010113          	addi	sp,sp,48
ffffffe000201330:	00008067          	ret

ffffffe000201334 <test_rodata_exec>:

void test_rodata_exec(uint64_t *addr) {
ffffffe000201334:	fd010113          	addi	sp,sp,-48
ffffffe000201338:	02113423          	sd	ra,40(sp)
ffffffe00020133c:	02813023          	sd	s0,32(sp)
ffffffe000201340:	03010413          	addi	s0,sp,48
ffffffe000201344:	fca43c23          	sd	a0,-40(s0)
    int success = 1;
ffffffe000201348:	00100793          	li	a5,1
ffffffe00020134c:	fef42623          	sw	a5,-20(s0)

    asm volatile(
ffffffe000201350:	fd843783          	ld	a5,-40(s0)
ffffffe000201354:	000780e7          	jalr	a5
ffffffe000201358:	00000793          	li	a5,0
ffffffe00020135c:	fef42623          	sw	a5,-20(s0)
        "li %0, 0\n"
        : "=r"(success)
        : "r"(addr)
    );

    if (success) {
ffffffe000201360:	fec42783          	lw	a5,-20(s0)
ffffffe000201364:	0007879b          	sext.w	a5,a5
ffffffe000201368:	00078a63          	beqz	a5,ffffffe00020137c <test_rodata_exec+0x48>
        printk("ERROR: .rodata execute succeeded unexpectedly!\n");
ffffffe00020136c:	00002517          	auipc	a0,0x2
ffffffe000201370:	efc50513          	addi	a0,a0,-260 # ffffffe000203268 <_srodata+0x268>
ffffffe000201374:	0a4010ef          	jal	ra,ffffffe000202418 <printk>
    } else {
        printk("PASS: .rodata execute failed as expected.\n");
    }
}
ffffffe000201378:	0100006f          	j	ffffffe000201388 <test_rodata_exec+0x54>
        printk("PASS: .rodata execute failed as expected.\n");
ffffffe00020137c:	00002517          	auipc	a0,0x2
ffffffe000201380:	f1c50513          	addi	a0,a0,-228 # ffffffe000203298 <_srodata+0x298>
ffffffe000201384:	094010ef          	jal	ra,ffffffe000202418 <printk>
}
ffffffe000201388:	00000013          	nop
ffffffe00020138c:	02813083          	ld	ra,40(sp)
ffffffe000201390:	02013403          	ld	s0,32(sp)
ffffffe000201394:	03010113          	addi	sp,sp,48
ffffffe000201398:	00008067          	ret

ffffffe00020139c <test_text_read>:

void test_text_read(uint64_t *addr) {
ffffffe00020139c:	fd010113          	addi	sp,sp,-48
ffffffe0002013a0:	02113423          	sd	ra,40(sp)
ffffffe0002013a4:	02813023          	sd	s0,32(sp)
ffffffe0002013a8:	03010413          	addi	s0,sp,48
ffffffe0002013ac:	fca43c23          	sd	a0,-40(s0)
    printk(".text read test: ");
ffffffe0002013b0:	00002517          	auipc	a0,0x2
ffffffe0002013b4:	f1850513          	addi	a0,a0,-232 # ffffffe0002032c8 <_srodata+0x2c8>
ffffffe0002013b8:	060010ef          	jal	ra,ffffffe000202418 <printk>
    uint64_t value = *addr;
ffffffe0002013bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002013c0:	0007b783          	ld	a5,0(a5)
ffffffe0002013c4:	fef43423          	sd	a5,-24(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe0002013c8:	fe843583          	ld	a1,-24(s0)
ffffffe0002013cc:	00002517          	auipc	a0,0x2
ffffffe0002013d0:	f1450513          	addi	a0,a0,-236 # ffffffe0002032e0 <_srodata+0x2e0>
ffffffe0002013d4:	044010ef          	jal	ra,ffffffe000202418 <printk>
}
ffffffe0002013d8:	00000013          	nop
ffffffe0002013dc:	02813083          	ld	ra,40(sp)
ffffffe0002013e0:	02013403          	ld	s0,32(sp)
ffffffe0002013e4:	03010113          	addi	sp,sp,48
ffffffe0002013e8:	00008067          	ret

ffffffe0002013ec <test_text_write>:

void test_text_write(uint64_t *addr) {
ffffffe0002013ec:	fd010113          	addi	sp,sp,-48
ffffffe0002013f0:	02113423          	sd	ra,40(sp)
ffffffe0002013f4:	02813023          	sd	s0,32(sp)
ffffffe0002013f8:	03010413          	addi	s0,sp,48
ffffffe0002013fc:	fca43c23          	sd	a0,-40(s0)
    uint64_t backup = *addr; // 备份原始值
ffffffe000201400:	fd843783          	ld	a5,-40(s0)
ffffffe000201404:	0007b783          	ld	a5,0(a5)
ffffffe000201408:	fef43423          	sd	a5,-24(s0)
    int success = 1;
ffffffe00020140c:	00100793          	li	a5,1
ffffffe000201410:	fef42223          	sw	a5,-28(s0)

    asm volatile(
ffffffe000201414:	fd843783          	ld	a5,-40(s0)
ffffffe000201418:	00100293          	li	t0,1
ffffffe00020141c:	0057b023          	sd	t0,0(a5)
ffffffe000201420:	00000793          	li	a5,0
ffffffe000201424:	fef42223          	sw	a5,-28(s0)
        : "=r"(success)
        : "r"(addr)
        : "t0"
    );

    if (success) {
ffffffe000201428:	fe442783          	lw	a5,-28(s0)
ffffffe00020142c:	0007879b          	sext.w	a5,a5
ffffffe000201430:	00078a63          	beqz	a5,ffffffe000201444 <test_text_write+0x58>
        printk("PASS: .text write failed as expected.\n");
ffffffe000201434:	00002517          	auipc	a0,0x2
ffffffe000201438:	ed450513          	addi	a0,a0,-300 # ffffffe000203308 <_srodata+0x308>
ffffffe00020143c:	7dd000ef          	jal	ra,ffffffe000202418 <printk>
    } else {
        printk("ERROR: .text write succeeded unexpectedly!\n");
        *addr = backup; // 恢复原始值，避免破坏代码段
    }
}
ffffffe000201440:	01c0006f          	j	ffffffe00020145c <test_text_write+0x70>
        printk("ERROR: .text write succeeded unexpectedly!\n");
ffffffe000201444:	00002517          	auipc	a0,0x2
ffffffe000201448:	eec50513          	addi	a0,a0,-276 # ffffffe000203330 <_srodata+0x330>
ffffffe00020144c:	7cd000ef          	jal	ra,ffffffe000202418 <printk>
        *addr = backup; // 恢复原始值，避免破坏代码段
ffffffe000201450:	fd843783          	ld	a5,-40(s0)
ffffffe000201454:	fe843703          	ld	a4,-24(s0)
ffffffe000201458:	00e7b023          	sd	a4,0(a5)
}
ffffffe00020145c:	00000013          	nop
ffffffe000201460:	02813083          	ld	ra,40(sp)
ffffffe000201464:	02013403          	ld	s0,32(sp)
ffffffe000201468:	03010113          	addi	sp,sp,48
ffffffe00020146c:	00008067          	ret

ffffffe000201470 <test_text_exec>:

void test_text_exec() {
ffffffe000201470:	ff010113          	addi	sp,sp,-16
ffffffe000201474:	00113423          	sd	ra,8(sp)
ffffffe000201478:	00813023          	sd	s0,0(sp)
ffffffe00020147c:	01010413          	addi	s0,sp,16
    printk("Executing .text segment test: ");
ffffffe000201480:	00002517          	auipc	a0,0x2
ffffffe000201484:	ee050513          	addi	a0,a0,-288 # ffffffe000203360 <_srodata+0x360>
ffffffe000201488:	791000ef          	jal	ra,ffffffe000202418 <printk>
    // 执行测试函数本身
    printk("PASS: Execution succeeded.\n");
ffffffe00020148c:	00002517          	auipc	a0,0x2
ffffffe000201490:	ef450513          	addi	a0,a0,-268 # ffffffe000203380 <_srodata+0x380>
ffffffe000201494:	785000ef          	jal	ra,ffffffe000202418 <printk>
}
ffffffe000201498:	00000013          	nop
ffffffe00020149c:	00813083          	ld	ra,8(sp)
ffffffe0002014a0:	00013403          	ld	s0,0(sp)
ffffffe0002014a4:	01010113          	addi	sp,sp,16
ffffffe0002014a8:	00008067          	ret

ffffffe0002014ac <verify_vm>:

void verify_vm() {
ffffffe0002014ac:	fd010113          	addi	sp,sp,-48
ffffffe0002014b0:	02113423          	sd	ra,40(sp)
ffffffe0002014b4:	02813023          	sd	s0,32(sp)
ffffffe0002014b8:	03010413          	addi	s0,sp,48
    uint64_t va_text = 0xffffffe000200000;  // 虚拟地址对应 .text 段
ffffffe0002014bc:	f00017b7          	lui	a5,0xf0001
ffffffe0002014c0:	00979793          	slli	a5,a5,0x9
ffffffe0002014c4:	fef43423          	sd	a5,-24(s0)
    uint64_t va_rodata = 0xffffffe000203000; // 虚拟地址对应 .rodata 段
ffffffe0002014c8:	fe0007b7          	lui	a5,0xfe000
ffffffe0002014cc:	20378793          	addi	a5,a5,515 # fffffffffe000203 <VM_END+0xfe000203>
ffffffe0002014d0:	00c79793          	slli	a5,a5,0xc
ffffffe0002014d4:	fef43023          	sd	a5,-32(s0)

    uint64_t *test_addr;

    // .text
    test_addr = (uint64_t *)va_text;
ffffffe0002014d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002014dc:	fcf43c23          	sd	a5,-40(s0)

    // .text R
    printk(".text read test: \n");
ffffffe0002014e0:	00002517          	auipc	a0,0x2
ffffffe0002014e4:	ec050513          	addi	a0,a0,-320 # ffffffe0002033a0 <_srodata+0x3a0>
ffffffe0002014e8:	731000ef          	jal	ra,ffffffe000202418 <printk>
    test_text_read(test_addr);
ffffffe0002014ec:	fd843503          	ld	a0,-40(s0)
ffffffe0002014f0:	eadff0ef          	jal	ra,ffffffe00020139c <test_text_read>
    // Invalid operation, should trigger an exception
    // printk(".text write test: \n");
    // test_text_write(test_addr);

    // .text X
    printk(".text execute test: \n");
ffffffe0002014f4:	00002517          	auipc	a0,0x2
ffffffe0002014f8:	ec450513          	addi	a0,a0,-316 # ffffffe0002033b8 <_srodata+0x3b8>
ffffffe0002014fc:	71d000ef          	jal	ra,ffffffe000202418 <printk>
    test_text_exec();
ffffffe000201500:	f71ff0ef          	jal	ra,ffffffe000201470 <test_text_exec>

    // .rodata
    test_addr = (uint64_t *)va_rodata;
ffffffe000201504:	fe043783          	ld	a5,-32(s0)
ffffffe000201508:	fcf43c23          	sd	a5,-40(s0)

    // .rodata R
    printk(".rodata read test: \n");
ffffffe00020150c:	00002517          	auipc	a0,0x2
ffffffe000201510:	ec450513          	addi	a0,a0,-316 # ffffffe0002033d0 <_srodata+0x3d0>
ffffffe000201514:	705000ef          	jal	ra,ffffffe000202418 <printk>
    uint64_t value = *test_addr;
ffffffe000201518:	fd843783          	ld	a5,-40(s0)
ffffffe00020151c:	0007b783          	ld	a5,0(a5)
ffffffe000201520:	fcf43823          	sd	a5,-48(s0)
    printk("PASS: Read succeeded, value = %lx\n", value);
ffffffe000201524:	fd043583          	ld	a1,-48(s0)
ffffffe000201528:	00002517          	auipc	a0,0x2
ffffffe00020152c:	db850513          	addi	a0,a0,-584 # ffffffe0002032e0 <_srodata+0x2e0>
ffffffe000201530:	6e9000ef          	jal	ra,ffffffe000202418 <printk>

    // printk(".rodata execute test: \n");
    // test_rodata_exec((uint64_t *)va_rodata);
    

    printk("W/R/X verification completed.\n");
ffffffe000201534:	00002517          	auipc	a0,0x2
ffffffe000201538:	eb450513          	addi	a0,a0,-332 # ffffffe0002033e8 <_srodata+0x3e8>
ffffffe00020153c:	6dd000ef          	jal	ra,ffffffe000202418 <printk>
ffffffe000201540:	00000013          	nop
ffffffe000201544:	02813083          	ld	ra,40(sp)
ffffffe000201548:	02013403          	ld	s0,32(sp)
ffffffe00020154c:	03010113          	addi	sp,sp,48
ffffffe000201550:	00008067          	ret

ffffffe000201554 <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
ffffffe000201554:	fe010113          	addi	sp,sp,-32
ffffffe000201558:	00113c23          	sd	ra,24(sp)
ffffffe00020155c:	00813823          	sd	s0,16(sp)
ffffffe000201560:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000201564:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
ffffffe000201568:	00002517          	auipc	a0,0x2
ffffffe00020156c:	ea050513          	addi	a0,a0,-352 # ffffffe000203408 <_srodata+0x408>
ffffffe000201570:	6a9000ef          	jal	ra,ffffffe000202418 <printk>
    while (1)
    {
        i++;
ffffffe000201574:	fec42783          	lw	a5,-20(s0)
ffffffe000201578:	0017879b          	addiw	a5,a5,1
ffffffe00020157c:	fef42623          	sw	a5,-20(s0)
ffffffe000201580:	ff5ff06f          	j	ffffffe000201574 <test+0x20>

ffffffe000201584 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000201584:	fe010113          	addi	sp,sp,-32
ffffffe000201588:	00113c23          	sd	ra,24(sp)
ffffffe00020158c:	00813823          	sd	s0,16(sp)
ffffffe000201590:	02010413          	addi	s0,sp,32
ffffffe000201594:	00050793          	mv	a5,a0
ffffffe000201598:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe00020159c:	fec42783          	lw	a5,-20(s0)
ffffffe0002015a0:	0ff7f793          	zext.b	a5,a5
ffffffe0002015a4:	00078513          	mv	a0,a5
ffffffe0002015a8:	d78ff0ef          	jal	ra,ffffffe000200b20 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe0002015ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002015b0:	0ff7f793          	zext.b	a5,a5
ffffffe0002015b4:	0007879b          	sext.w	a5,a5
}
ffffffe0002015b8:	00078513          	mv	a0,a5
ffffffe0002015bc:	01813083          	ld	ra,24(sp)
ffffffe0002015c0:	01013403          	ld	s0,16(sp)
ffffffe0002015c4:	02010113          	addi	sp,sp,32
ffffffe0002015c8:	00008067          	ret

ffffffe0002015cc <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe0002015cc:	fe010113          	addi	sp,sp,-32
ffffffe0002015d0:	00813c23          	sd	s0,24(sp)
ffffffe0002015d4:	02010413          	addi	s0,sp,32
ffffffe0002015d8:	00050793          	mv	a5,a0
ffffffe0002015dc:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe0002015e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002015e4:	0007871b          	sext.w	a4,a5
ffffffe0002015e8:	02000793          	li	a5,32
ffffffe0002015ec:	02f70263          	beq	a4,a5,ffffffe000201610 <isspace+0x44>
ffffffe0002015f0:	fec42783          	lw	a5,-20(s0)
ffffffe0002015f4:	0007871b          	sext.w	a4,a5
ffffffe0002015f8:	00800793          	li	a5,8
ffffffe0002015fc:	00e7de63          	bge	a5,a4,ffffffe000201618 <isspace+0x4c>
ffffffe000201600:	fec42783          	lw	a5,-20(s0)
ffffffe000201604:	0007871b          	sext.w	a4,a5
ffffffe000201608:	00d00793          	li	a5,13
ffffffe00020160c:	00e7c663          	blt	a5,a4,ffffffe000201618 <isspace+0x4c>
ffffffe000201610:	00100793          	li	a5,1
ffffffe000201614:	0080006f          	j	ffffffe00020161c <isspace+0x50>
ffffffe000201618:	00000793          	li	a5,0
}
ffffffe00020161c:	00078513          	mv	a0,a5
ffffffe000201620:	01813403          	ld	s0,24(sp)
ffffffe000201624:	02010113          	addi	sp,sp,32
ffffffe000201628:	00008067          	ret

ffffffe00020162c <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe00020162c:	fb010113          	addi	sp,sp,-80
ffffffe000201630:	04113423          	sd	ra,72(sp)
ffffffe000201634:	04813023          	sd	s0,64(sp)
ffffffe000201638:	05010413          	addi	s0,sp,80
ffffffe00020163c:	fca43423          	sd	a0,-56(s0)
ffffffe000201640:	fcb43023          	sd	a1,-64(s0)
ffffffe000201644:	00060793          	mv	a5,a2
ffffffe000201648:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe00020164c:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000201650:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000201654:	fc843783          	ld	a5,-56(s0)
ffffffe000201658:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe00020165c:	0100006f          	j	ffffffe00020166c <strtol+0x40>
        p++;
ffffffe000201660:	fd843783          	ld	a5,-40(s0)
ffffffe000201664:	00178793          	addi	a5,a5,1
ffffffe000201668:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe00020166c:	fd843783          	ld	a5,-40(s0)
ffffffe000201670:	0007c783          	lbu	a5,0(a5)
ffffffe000201674:	0007879b          	sext.w	a5,a5
ffffffe000201678:	00078513          	mv	a0,a5
ffffffe00020167c:	f51ff0ef          	jal	ra,ffffffe0002015cc <isspace>
ffffffe000201680:	00050793          	mv	a5,a0
ffffffe000201684:	fc079ee3          	bnez	a5,ffffffe000201660 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000201688:	fd843783          	ld	a5,-40(s0)
ffffffe00020168c:	0007c783          	lbu	a5,0(a5)
ffffffe000201690:	00078713          	mv	a4,a5
ffffffe000201694:	02d00793          	li	a5,45
ffffffe000201698:	00f71e63          	bne	a4,a5,ffffffe0002016b4 <strtol+0x88>
        neg = true;
ffffffe00020169c:	00100793          	li	a5,1
ffffffe0002016a0:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002016a4:	fd843783          	ld	a5,-40(s0)
ffffffe0002016a8:	00178793          	addi	a5,a5,1
ffffffe0002016ac:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002016b0:	0240006f          	j	ffffffe0002016d4 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe0002016b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002016b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002016bc:	00078713          	mv	a4,a5
ffffffe0002016c0:	02b00793          	li	a5,43
ffffffe0002016c4:	00f71863          	bne	a4,a5,ffffffe0002016d4 <strtol+0xa8>
        p++;
ffffffe0002016c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002016cc:	00178793          	addi	a5,a5,1
ffffffe0002016d0:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002016d4:	fbc42783          	lw	a5,-68(s0)
ffffffe0002016d8:	0007879b          	sext.w	a5,a5
ffffffe0002016dc:	06079c63          	bnez	a5,ffffffe000201754 <strtol+0x128>
        if (*p == '0') {
ffffffe0002016e0:	fd843783          	ld	a5,-40(s0)
ffffffe0002016e4:	0007c783          	lbu	a5,0(a5)
ffffffe0002016e8:	00078713          	mv	a4,a5
ffffffe0002016ec:	03000793          	li	a5,48
ffffffe0002016f0:	04f71e63          	bne	a4,a5,ffffffe00020174c <strtol+0x120>
            p++;
ffffffe0002016f4:	fd843783          	ld	a5,-40(s0)
ffffffe0002016f8:	00178793          	addi	a5,a5,1
ffffffe0002016fc:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000201700:	fd843783          	ld	a5,-40(s0)
ffffffe000201704:	0007c783          	lbu	a5,0(a5)
ffffffe000201708:	00078713          	mv	a4,a5
ffffffe00020170c:	07800793          	li	a5,120
ffffffe000201710:	00f70c63          	beq	a4,a5,ffffffe000201728 <strtol+0xfc>
ffffffe000201714:	fd843783          	ld	a5,-40(s0)
ffffffe000201718:	0007c783          	lbu	a5,0(a5)
ffffffe00020171c:	00078713          	mv	a4,a5
ffffffe000201720:	05800793          	li	a5,88
ffffffe000201724:	00f71e63          	bne	a4,a5,ffffffe000201740 <strtol+0x114>
                base = 16;
ffffffe000201728:	01000793          	li	a5,16
ffffffe00020172c:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000201730:	fd843783          	ld	a5,-40(s0)
ffffffe000201734:	00178793          	addi	a5,a5,1
ffffffe000201738:	fcf43c23          	sd	a5,-40(s0)
ffffffe00020173c:	0180006f          	j	ffffffe000201754 <strtol+0x128>
            } else {
                base = 8;
ffffffe000201740:	00800793          	li	a5,8
ffffffe000201744:	faf42e23          	sw	a5,-68(s0)
ffffffe000201748:	00c0006f          	j	ffffffe000201754 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe00020174c:	00a00793          	li	a5,10
ffffffe000201750:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000201754:	fd843783          	ld	a5,-40(s0)
ffffffe000201758:	0007c783          	lbu	a5,0(a5)
ffffffe00020175c:	00078713          	mv	a4,a5
ffffffe000201760:	02f00793          	li	a5,47
ffffffe000201764:	02e7f863          	bgeu	a5,a4,ffffffe000201794 <strtol+0x168>
ffffffe000201768:	fd843783          	ld	a5,-40(s0)
ffffffe00020176c:	0007c783          	lbu	a5,0(a5)
ffffffe000201770:	00078713          	mv	a4,a5
ffffffe000201774:	03900793          	li	a5,57
ffffffe000201778:	00e7ee63          	bltu	a5,a4,ffffffe000201794 <strtol+0x168>
            digit = *p - '0';
ffffffe00020177c:	fd843783          	ld	a5,-40(s0)
ffffffe000201780:	0007c783          	lbu	a5,0(a5)
ffffffe000201784:	0007879b          	sext.w	a5,a5
ffffffe000201788:	fd07879b          	addiw	a5,a5,-48
ffffffe00020178c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201790:	0800006f          	j	ffffffe000201810 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000201794:	fd843783          	ld	a5,-40(s0)
ffffffe000201798:	0007c783          	lbu	a5,0(a5)
ffffffe00020179c:	00078713          	mv	a4,a5
ffffffe0002017a0:	06000793          	li	a5,96
ffffffe0002017a4:	02e7f863          	bgeu	a5,a4,ffffffe0002017d4 <strtol+0x1a8>
ffffffe0002017a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002017ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002017b0:	00078713          	mv	a4,a5
ffffffe0002017b4:	07a00793          	li	a5,122
ffffffe0002017b8:	00e7ee63          	bltu	a5,a4,ffffffe0002017d4 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe0002017bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002017c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002017c4:	0007879b          	sext.w	a5,a5
ffffffe0002017c8:	fa97879b          	addiw	a5,a5,-87
ffffffe0002017cc:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002017d0:	0400006f          	j	ffffffe000201810 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002017d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002017d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002017dc:	00078713          	mv	a4,a5
ffffffe0002017e0:	04000793          	li	a5,64
ffffffe0002017e4:	06e7f863          	bgeu	a5,a4,ffffffe000201854 <strtol+0x228>
ffffffe0002017e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002017ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002017f0:	00078713          	mv	a4,a5
ffffffe0002017f4:	05a00793          	li	a5,90
ffffffe0002017f8:	04e7ee63          	bltu	a5,a4,ffffffe000201854 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe0002017fc:	fd843783          	ld	a5,-40(s0)
ffffffe000201800:	0007c783          	lbu	a5,0(a5)
ffffffe000201804:	0007879b          	sext.w	a5,a5
ffffffe000201808:	fc97879b          	addiw	a5,a5,-55
ffffffe00020180c:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000201810:	fd442783          	lw	a5,-44(s0)
ffffffe000201814:	00078713          	mv	a4,a5
ffffffe000201818:	fbc42783          	lw	a5,-68(s0)
ffffffe00020181c:	0007071b          	sext.w	a4,a4
ffffffe000201820:	0007879b          	sext.w	a5,a5
ffffffe000201824:	02f75663          	bge	a4,a5,ffffffe000201850 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000201828:	fbc42703          	lw	a4,-68(s0)
ffffffe00020182c:	fe843783          	ld	a5,-24(s0)
ffffffe000201830:	02f70733          	mul	a4,a4,a5
ffffffe000201834:	fd442783          	lw	a5,-44(s0)
ffffffe000201838:	00f707b3          	add	a5,a4,a5
ffffffe00020183c:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000201840:	fd843783          	ld	a5,-40(s0)
ffffffe000201844:	00178793          	addi	a5,a5,1
ffffffe000201848:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe00020184c:	f09ff06f          	j	ffffffe000201754 <strtol+0x128>
            break;
ffffffe000201850:	00000013          	nop
    }

    if (endptr) {
ffffffe000201854:	fc043783          	ld	a5,-64(s0)
ffffffe000201858:	00078863          	beqz	a5,ffffffe000201868 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe00020185c:	fc043783          	ld	a5,-64(s0)
ffffffe000201860:	fd843703          	ld	a4,-40(s0)
ffffffe000201864:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000201868:	fe744783          	lbu	a5,-25(s0)
ffffffe00020186c:	0ff7f793          	zext.b	a5,a5
ffffffe000201870:	00078863          	beqz	a5,ffffffe000201880 <strtol+0x254>
ffffffe000201874:	fe843783          	ld	a5,-24(s0)
ffffffe000201878:	40f007b3          	neg	a5,a5
ffffffe00020187c:	0080006f          	j	ffffffe000201884 <strtol+0x258>
ffffffe000201880:	fe843783          	ld	a5,-24(s0)
}
ffffffe000201884:	00078513          	mv	a0,a5
ffffffe000201888:	04813083          	ld	ra,72(sp)
ffffffe00020188c:	04013403          	ld	s0,64(sp)
ffffffe000201890:	05010113          	addi	sp,sp,80
ffffffe000201894:	00008067          	ret

ffffffe000201898 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe000201898:	fd010113          	addi	sp,sp,-48
ffffffe00020189c:	02113423          	sd	ra,40(sp)
ffffffe0002018a0:	02813023          	sd	s0,32(sp)
ffffffe0002018a4:	03010413          	addi	s0,sp,48
ffffffe0002018a8:	fca43c23          	sd	a0,-40(s0)
ffffffe0002018ac:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe0002018b0:	fd043783          	ld	a5,-48(s0)
ffffffe0002018b4:	00079863          	bnez	a5,ffffffe0002018c4 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002018b8:	00002797          	auipc	a5,0x2
ffffffe0002018bc:	b6878793          	addi	a5,a5,-1176 # ffffffe000203420 <_srodata+0x420>
ffffffe0002018c0:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002018c4:	fd043783          	ld	a5,-48(s0)
ffffffe0002018c8:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002018cc:	0240006f          	j	ffffffe0002018f0 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002018d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002018d4:	00178713          	addi	a4,a5,1
ffffffe0002018d8:	fee43423          	sd	a4,-24(s0)
ffffffe0002018dc:	0007c783          	lbu	a5,0(a5)
ffffffe0002018e0:	0007871b          	sext.w	a4,a5
ffffffe0002018e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002018e8:	00070513          	mv	a0,a4
ffffffe0002018ec:	000780e7          	jalr	a5
    while (*p) {
ffffffe0002018f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002018f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002018f8:	fc079ce3          	bnez	a5,ffffffe0002018d0 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe0002018fc:	fe843703          	ld	a4,-24(s0)
ffffffe000201900:	fd043783          	ld	a5,-48(s0)
ffffffe000201904:	40f707b3          	sub	a5,a4,a5
ffffffe000201908:	0007879b          	sext.w	a5,a5
}
ffffffe00020190c:	00078513          	mv	a0,a5
ffffffe000201910:	02813083          	ld	ra,40(sp)
ffffffe000201914:	02013403          	ld	s0,32(sp)
ffffffe000201918:	03010113          	addi	sp,sp,48
ffffffe00020191c:	00008067          	ret

ffffffe000201920 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000201920:	f9010113          	addi	sp,sp,-112
ffffffe000201924:	06113423          	sd	ra,104(sp)
ffffffe000201928:	06813023          	sd	s0,96(sp)
ffffffe00020192c:	07010413          	addi	s0,sp,112
ffffffe000201930:	faa43423          	sd	a0,-88(s0)
ffffffe000201934:	fab43023          	sd	a1,-96(s0)
ffffffe000201938:	00060793          	mv	a5,a2
ffffffe00020193c:	f8d43823          	sd	a3,-112(s0)
ffffffe000201940:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000201944:	f9f44783          	lbu	a5,-97(s0)
ffffffe000201948:	0ff7f793          	zext.b	a5,a5
ffffffe00020194c:	02078663          	beqz	a5,ffffffe000201978 <print_dec_int+0x58>
ffffffe000201950:	fa043703          	ld	a4,-96(s0)
ffffffe000201954:	fff00793          	li	a5,-1
ffffffe000201958:	03f79793          	slli	a5,a5,0x3f
ffffffe00020195c:	00f71e63          	bne	a4,a5,ffffffe000201978 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000201960:	00002597          	auipc	a1,0x2
ffffffe000201964:	ac858593          	addi	a1,a1,-1336 # ffffffe000203428 <_srodata+0x428>
ffffffe000201968:	fa843503          	ld	a0,-88(s0)
ffffffe00020196c:	f2dff0ef          	jal	ra,ffffffe000201898 <puts_wo_nl>
ffffffe000201970:	00050793          	mv	a5,a0
ffffffe000201974:	2a00006f          	j	ffffffe000201c14 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000201978:	f9043783          	ld	a5,-112(s0)
ffffffe00020197c:	00c7a783          	lw	a5,12(a5)
ffffffe000201980:	00079a63          	bnez	a5,ffffffe000201994 <print_dec_int+0x74>
ffffffe000201984:	fa043783          	ld	a5,-96(s0)
ffffffe000201988:	00079663          	bnez	a5,ffffffe000201994 <print_dec_int+0x74>
        return 0;
ffffffe00020198c:	00000793          	li	a5,0
ffffffe000201990:	2840006f          	j	ffffffe000201c14 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe000201994:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000201998:	f9f44783          	lbu	a5,-97(s0)
ffffffe00020199c:	0ff7f793          	zext.b	a5,a5
ffffffe0002019a0:	02078063          	beqz	a5,ffffffe0002019c0 <print_dec_int+0xa0>
ffffffe0002019a4:	fa043783          	ld	a5,-96(s0)
ffffffe0002019a8:	0007dc63          	bgez	a5,ffffffe0002019c0 <print_dec_int+0xa0>
        neg = true;
ffffffe0002019ac:	00100793          	li	a5,1
ffffffe0002019b0:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe0002019b4:	fa043783          	ld	a5,-96(s0)
ffffffe0002019b8:	40f007b3          	neg	a5,a5
ffffffe0002019bc:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe0002019c0:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe0002019c4:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002019c8:	0ff7f793          	zext.b	a5,a5
ffffffe0002019cc:	02078863          	beqz	a5,ffffffe0002019fc <print_dec_int+0xdc>
ffffffe0002019d0:	fef44783          	lbu	a5,-17(s0)
ffffffe0002019d4:	0ff7f793          	zext.b	a5,a5
ffffffe0002019d8:	00079e63          	bnez	a5,ffffffe0002019f4 <print_dec_int+0xd4>
ffffffe0002019dc:	f9043783          	ld	a5,-112(s0)
ffffffe0002019e0:	0057c783          	lbu	a5,5(a5)
ffffffe0002019e4:	00079863          	bnez	a5,ffffffe0002019f4 <print_dec_int+0xd4>
ffffffe0002019e8:	f9043783          	ld	a5,-112(s0)
ffffffe0002019ec:	0047c783          	lbu	a5,4(a5)
ffffffe0002019f0:	00078663          	beqz	a5,ffffffe0002019fc <print_dec_int+0xdc>
ffffffe0002019f4:	00100793          	li	a5,1
ffffffe0002019f8:	0080006f          	j	ffffffe000201a00 <print_dec_int+0xe0>
ffffffe0002019fc:	00000793          	li	a5,0
ffffffe000201a00:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000201a04:	fd744783          	lbu	a5,-41(s0)
ffffffe000201a08:	0017f793          	andi	a5,a5,1
ffffffe000201a0c:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000201a10:	fa043703          	ld	a4,-96(s0)
ffffffe000201a14:	00a00793          	li	a5,10
ffffffe000201a18:	02f777b3          	remu	a5,a4,a5
ffffffe000201a1c:	0ff7f713          	zext.b	a4,a5
ffffffe000201a20:	fe842783          	lw	a5,-24(s0)
ffffffe000201a24:	0017869b          	addiw	a3,a5,1
ffffffe000201a28:	fed42423          	sw	a3,-24(s0)
ffffffe000201a2c:	0307071b          	addiw	a4,a4,48
ffffffe000201a30:	0ff77713          	zext.b	a4,a4
ffffffe000201a34:	ff078793          	addi	a5,a5,-16
ffffffe000201a38:	008787b3          	add	a5,a5,s0
ffffffe000201a3c:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000201a40:	fa043703          	ld	a4,-96(s0)
ffffffe000201a44:	00a00793          	li	a5,10
ffffffe000201a48:	02f757b3          	divu	a5,a4,a5
ffffffe000201a4c:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000201a50:	fa043783          	ld	a5,-96(s0)
ffffffe000201a54:	fa079ee3          	bnez	a5,ffffffe000201a10 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000201a58:	f9043783          	ld	a5,-112(s0)
ffffffe000201a5c:	00c7a783          	lw	a5,12(a5)
ffffffe000201a60:	00078713          	mv	a4,a5
ffffffe000201a64:	fff00793          	li	a5,-1
ffffffe000201a68:	02f71063          	bne	a4,a5,ffffffe000201a88 <print_dec_int+0x168>
ffffffe000201a6c:	f9043783          	ld	a5,-112(s0)
ffffffe000201a70:	0037c783          	lbu	a5,3(a5)
ffffffe000201a74:	00078a63          	beqz	a5,ffffffe000201a88 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000201a78:	f9043783          	ld	a5,-112(s0)
ffffffe000201a7c:	0087a703          	lw	a4,8(a5)
ffffffe000201a80:	f9043783          	ld	a5,-112(s0)
ffffffe000201a84:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000201a88:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000201a8c:	f9043783          	ld	a5,-112(s0)
ffffffe000201a90:	0087a703          	lw	a4,8(a5)
ffffffe000201a94:	fe842783          	lw	a5,-24(s0)
ffffffe000201a98:	fcf42823          	sw	a5,-48(s0)
ffffffe000201a9c:	f9043783          	ld	a5,-112(s0)
ffffffe000201aa0:	00c7a783          	lw	a5,12(a5)
ffffffe000201aa4:	fcf42623          	sw	a5,-52(s0)
ffffffe000201aa8:	fd042783          	lw	a5,-48(s0)
ffffffe000201aac:	00078593          	mv	a1,a5
ffffffe000201ab0:	fcc42783          	lw	a5,-52(s0)
ffffffe000201ab4:	00078613          	mv	a2,a5
ffffffe000201ab8:	0006069b          	sext.w	a3,a2
ffffffe000201abc:	0005879b          	sext.w	a5,a1
ffffffe000201ac0:	00f6d463          	bge	a3,a5,ffffffe000201ac8 <print_dec_int+0x1a8>
ffffffe000201ac4:	00058613          	mv	a2,a1
ffffffe000201ac8:	0006079b          	sext.w	a5,a2
ffffffe000201acc:	40f707bb          	subw	a5,a4,a5
ffffffe000201ad0:	0007871b          	sext.w	a4,a5
ffffffe000201ad4:	fd744783          	lbu	a5,-41(s0)
ffffffe000201ad8:	0007879b          	sext.w	a5,a5
ffffffe000201adc:	40f707bb          	subw	a5,a4,a5
ffffffe000201ae0:	fef42023          	sw	a5,-32(s0)
ffffffe000201ae4:	0280006f          	j	ffffffe000201b0c <print_dec_int+0x1ec>
        putch(' ');
ffffffe000201ae8:	fa843783          	ld	a5,-88(s0)
ffffffe000201aec:	02000513          	li	a0,32
ffffffe000201af0:	000780e7          	jalr	a5
        ++written;
ffffffe000201af4:	fe442783          	lw	a5,-28(s0)
ffffffe000201af8:	0017879b          	addiw	a5,a5,1
ffffffe000201afc:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000201b00:	fe042783          	lw	a5,-32(s0)
ffffffe000201b04:	fff7879b          	addiw	a5,a5,-1
ffffffe000201b08:	fef42023          	sw	a5,-32(s0)
ffffffe000201b0c:	fe042783          	lw	a5,-32(s0)
ffffffe000201b10:	0007879b          	sext.w	a5,a5
ffffffe000201b14:	fcf04ae3          	bgtz	a5,ffffffe000201ae8 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000201b18:	fd744783          	lbu	a5,-41(s0)
ffffffe000201b1c:	0ff7f793          	zext.b	a5,a5
ffffffe000201b20:	04078463          	beqz	a5,ffffffe000201b68 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000201b24:	fef44783          	lbu	a5,-17(s0)
ffffffe000201b28:	0ff7f793          	zext.b	a5,a5
ffffffe000201b2c:	00078663          	beqz	a5,ffffffe000201b38 <print_dec_int+0x218>
ffffffe000201b30:	02d00793          	li	a5,45
ffffffe000201b34:	01c0006f          	j	ffffffe000201b50 <print_dec_int+0x230>
ffffffe000201b38:	f9043783          	ld	a5,-112(s0)
ffffffe000201b3c:	0057c783          	lbu	a5,5(a5)
ffffffe000201b40:	00078663          	beqz	a5,ffffffe000201b4c <print_dec_int+0x22c>
ffffffe000201b44:	02b00793          	li	a5,43
ffffffe000201b48:	0080006f          	j	ffffffe000201b50 <print_dec_int+0x230>
ffffffe000201b4c:	02000793          	li	a5,32
ffffffe000201b50:	fa843703          	ld	a4,-88(s0)
ffffffe000201b54:	00078513          	mv	a0,a5
ffffffe000201b58:	000700e7          	jalr	a4
        ++written;
ffffffe000201b5c:	fe442783          	lw	a5,-28(s0)
ffffffe000201b60:	0017879b          	addiw	a5,a5,1
ffffffe000201b64:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000201b68:	fe842783          	lw	a5,-24(s0)
ffffffe000201b6c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201b70:	0280006f          	j	ffffffe000201b98 <print_dec_int+0x278>
        putch('0');
ffffffe000201b74:	fa843783          	ld	a5,-88(s0)
ffffffe000201b78:	03000513          	li	a0,48
ffffffe000201b7c:	000780e7          	jalr	a5
        ++written;
ffffffe000201b80:	fe442783          	lw	a5,-28(s0)
ffffffe000201b84:	0017879b          	addiw	a5,a5,1
ffffffe000201b88:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000201b8c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201b90:	0017879b          	addiw	a5,a5,1
ffffffe000201b94:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201b98:	f9043783          	ld	a5,-112(s0)
ffffffe000201b9c:	00c7a703          	lw	a4,12(a5)
ffffffe000201ba0:	fd744783          	lbu	a5,-41(s0)
ffffffe000201ba4:	0007879b          	sext.w	a5,a5
ffffffe000201ba8:	40f707bb          	subw	a5,a4,a5
ffffffe000201bac:	0007871b          	sext.w	a4,a5
ffffffe000201bb0:	fdc42783          	lw	a5,-36(s0)
ffffffe000201bb4:	0007879b          	sext.w	a5,a5
ffffffe000201bb8:	fae7cee3          	blt	a5,a4,ffffffe000201b74 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201bbc:	fe842783          	lw	a5,-24(s0)
ffffffe000201bc0:	fff7879b          	addiw	a5,a5,-1
ffffffe000201bc4:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201bc8:	03c0006f          	j	ffffffe000201c04 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe000201bcc:	fd842783          	lw	a5,-40(s0)
ffffffe000201bd0:	ff078793          	addi	a5,a5,-16
ffffffe000201bd4:	008787b3          	add	a5,a5,s0
ffffffe000201bd8:	fc87c783          	lbu	a5,-56(a5)
ffffffe000201bdc:	0007871b          	sext.w	a4,a5
ffffffe000201be0:	fa843783          	ld	a5,-88(s0)
ffffffe000201be4:	00070513          	mv	a0,a4
ffffffe000201be8:	000780e7          	jalr	a5
        ++written;
ffffffe000201bec:	fe442783          	lw	a5,-28(s0)
ffffffe000201bf0:	0017879b          	addiw	a5,a5,1
ffffffe000201bf4:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201bf8:	fd842783          	lw	a5,-40(s0)
ffffffe000201bfc:	fff7879b          	addiw	a5,a5,-1
ffffffe000201c00:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201c04:	fd842783          	lw	a5,-40(s0)
ffffffe000201c08:	0007879b          	sext.w	a5,a5
ffffffe000201c0c:	fc07d0e3          	bgez	a5,ffffffe000201bcc <print_dec_int+0x2ac>
    }

    return written;
ffffffe000201c10:	fe442783          	lw	a5,-28(s0)
}
ffffffe000201c14:	00078513          	mv	a0,a5
ffffffe000201c18:	06813083          	ld	ra,104(sp)
ffffffe000201c1c:	06013403          	ld	s0,96(sp)
ffffffe000201c20:	07010113          	addi	sp,sp,112
ffffffe000201c24:	00008067          	ret

ffffffe000201c28 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000201c28:	f4010113          	addi	sp,sp,-192
ffffffe000201c2c:	0a113c23          	sd	ra,184(sp)
ffffffe000201c30:	0a813823          	sd	s0,176(sp)
ffffffe000201c34:	0c010413          	addi	s0,sp,192
ffffffe000201c38:	f4a43c23          	sd	a0,-168(s0)
ffffffe000201c3c:	f4b43823          	sd	a1,-176(s0)
ffffffe000201c40:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000201c44:	f8043023          	sd	zero,-128(s0)
ffffffe000201c48:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000201c4c:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000201c50:	7a40006f          	j	ffffffe0002023f4 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000201c54:	f8044783          	lbu	a5,-128(s0)
ffffffe000201c58:	72078e63          	beqz	a5,ffffffe000202394 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000201c5c:	f5043783          	ld	a5,-176(s0)
ffffffe000201c60:	0007c783          	lbu	a5,0(a5)
ffffffe000201c64:	00078713          	mv	a4,a5
ffffffe000201c68:	02300793          	li	a5,35
ffffffe000201c6c:	00f71863          	bne	a4,a5,ffffffe000201c7c <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000201c70:	00100793          	li	a5,1
ffffffe000201c74:	f8f40123          	sb	a5,-126(s0)
ffffffe000201c78:	7700006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000201c7c:	f5043783          	ld	a5,-176(s0)
ffffffe000201c80:	0007c783          	lbu	a5,0(a5)
ffffffe000201c84:	00078713          	mv	a4,a5
ffffffe000201c88:	03000793          	li	a5,48
ffffffe000201c8c:	00f71863          	bne	a4,a5,ffffffe000201c9c <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000201c90:	00100793          	li	a5,1
ffffffe000201c94:	f8f401a3          	sb	a5,-125(s0)
ffffffe000201c98:	7500006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000201c9c:	f5043783          	ld	a5,-176(s0)
ffffffe000201ca0:	0007c783          	lbu	a5,0(a5)
ffffffe000201ca4:	00078713          	mv	a4,a5
ffffffe000201ca8:	06c00793          	li	a5,108
ffffffe000201cac:	04f70063          	beq	a4,a5,ffffffe000201cec <vprintfmt+0xc4>
ffffffe000201cb0:	f5043783          	ld	a5,-176(s0)
ffffffe000201cb4:	0007c783          	lbu	a5,0(a5)
ffffffe000201cb8:	00078713          	mv	a4,a5
ffffffe000201cbc:	07a00793          	li	a5,122
ffffffe000201cc0:	02f70663          	beq	a4,a5,ffffffe000201cec <vprintfmt+0xc4>
ffffffe000201cc4:	f5043783          	ld	a5,-176(s0)
ffffffe000201cc8:	0007c783          	lbu	a5,0(a5)
ffffffe000201ccc:	00078713          	mv	a4,a5
ffffffe000201cd0:	07400793          	li	a5,116
ffffffe000201cd4:	00f70c63          	beq	a4,a5,ffffffe000201cec <vprintfmt+0xc4>
ffffffe000201cd8:	f5043783          	ld	a5,-176(s0)
ffffffe000201cdc:	0007c783          	lbu	a5,0(a5)
ffffffe000201ce0:	00078713          	mv	a4,a5
ffffffe000201ce4:	06a00793          	li	a5,106
ffffffe000201ce8:	00f71863          	bne	a4,a5,ffffffe000201cf8 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000201cec:	00100793          	li	a5,1
ffffffe000201cf0:	f8f400a3          	sb	a5,-127(s0)
ffffffe000201cf4:	6f40006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000201cf8:	f5043783          	ld	a5,-176(s0)
ffffffe000201cfc:	0007c783          	lbu	a5,0(a5)
ffffffe000201d00:	00078713          	mv	a4,a5
ffffffe000201d04:	02b00793          	li	a5,43
ffffffe000201d08:	00f71863          	bne	a4,a5,ffffffe000201d18 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000201d0c:	00100793          	li	a5,1
ffffffe000201d10:	f8f402a3          	sb	a5,-123(s0)
ffffffe000201d14:	6d40006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000201d18:	f5043783          	ld	a5,-176(s0)
ffffffe000201d1c:	0007c783          	lbu	a5,0(a5)
ffffffe000201d20:	00078713          	mv	a4,a5
ffffffe000201d24:	02000793          	li	a5,32
ffffffe000201d28:	00f71863          	bne	a4,a5,ffffffe000201d38 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000201d2c:	00100793          	li	a5,1
ffffffe000201d30:	f8f40223          	sb	a5,-124(s0)
ffffffe000201d34:	6b40006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000201d38:	f5043783          	ld	a5,-176(s0)
ffffffe000201d3c:	0007c783          	lbu	a5,0(a5)
ffffffe000201d40:	00078713          	mv	a4,a5
ffffffe000201d44:	02a00793          	li	a5,42
ffffffe000201d48:	00f71e63          	bne	a4,a5,ffffffe000201d64 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000201d4c:	f4843783          	ld	a5,-184(s0)
ffffffe000201d50:	00878713          	addi	a4,a5,8
ffffffe000201d54:	f4e43423          	sd	a4,-184(s0)
ffffffe000201d58:	0007a783          	lw	a5,0(a5)
ffffffe000201d5c:	f8f42423          	sw	a5,-120(s0)
ffffffe000201d60:	6880006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000201d64:	f5043783          	ld	a5,-176(s0)
ffffffe000201d68:	0007c783          	lbu	a5,0(a5)
ffffffe000201d6c:	00078713          	mv	a4,a5
ffffffe000201d70:	03000793          	li	a5,48
ffffffe000201d74:	04e7f663          	bgeu	a5,a4,ffffffe000201dc0 <vprintfmt+0x198>
ffffffe000201d78:	f5043783          	ld	a5,-176(s0)
ffffffe000201d7c:	0007c783          	lbu	a5,0(a5)
ffffffe000201d80:	00078713          	mv	a4,a5
ffffffe000201d84:	03900793          	li	a5,57
ffffffe000201d88:	02e7ec63          	bltu	a5,a4,ffffffe000201dc0 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000201d8c:	f5043783          	ld	a5,-176(s0)
ffffffe000201d90:	f5040713          	addi	a4,s0,-176
ffffffe000201d94:	00a00613          	li	a2,10
ffffffe000201d98:	00070593          	mv	a1,a4
ffffffe000201d9c:	00078513          	mv	a0,a5
ffffffe000201da0:	88dff0ef          	jal	ra,ffffffe00020162c <strtol>
ffffffe000201da4:	00050793          	mv	a5,a0
ffffffe000201da8:	0007879b          	sext.w	a5,a5
ffffffe000201dac:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000201db0:	f5043783          	ld	a5,-176(s0)
ffffffe000201db4:	fff78793          	addi	a5,a5,-1
ffffffe000201db8:	f4f43823          	sd	a5,-176(s0)
ffffffe000201dbc:	62c0006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000201dc0:	f5043783          	ld	a5,-176(s0)
ffffffe000201dc4:	0007c783          	lbu	a5,0(a5)
ffffffe000201dc8:	00078713          	mv	a4,a5
ffffffe000201dcc:	02e00793          	li	a5,46
ffffffe000201dd0:	06f71863          	bne	a4,a5,ffffffe000201e40 <vprintfmt+0x218>
                fmt++;
ffffffe000201dd4:	f5043783          	ld	a5,-176(s0)
ffffffe000201dd8:	00178793          	addi	a5,a5,1
ffffffe000201ddc:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000201de0:	f5043783          	ld	a5,-176(s0)
ffffffe000201de4:	0007c783          	lbu	a5,0(a5)
ffffffe000201de8:	00078713          	mv	a4,a5
ffffffe000201dec:	02a00793          	li	a5,42
ffffffe000201df0:	00f71e63          	bne	a4,a5,ffffffe000201e0c <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000201df4:	f4843783          	ld	a5,-184(s0)
ffffffe000201df8:	00878713          	addi	a4,a5,8
ffffffe000201dfc:	f4e43423          	sd	a4,-184(s0)
ffffffe000201e00:	0007a783          	lw	a5,0(a5)
ffffffe000201e04:	f8f42623          	sw	a5,-116(s0)
ffffffe000201e08:	5e00006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000201e0c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e10:	f5040713          	addi	a4,s0,-176
ffffffe000201e14:	00a00613          	li	a2,10
ffffffe000201e18:	00070593          	mv	a1,a4
ffffffe000201e1c:	00078513          	mv	a0,a5
ffffffe000201e20:	80dff0ef          	jal	ra,ffffffe00020162c <strtol>
ffffffe000201e24:	00050793          	mv	a5,a0
ffffffe000201e28:	0007879b          	sext.w	a5,a5
ffffffe000201e2c:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000201e30:	f5043783          	ld	a5,-176(s0)
ffffffe000201e34:	fff78793          	addi	a5,a5,-1
ffffffe000201e38:	f4f43823          	sd	a5,-176(s0)
ffffffe000201e3c:	5ac0006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000201e40:	f5043783          	ld	a5,-176(s0)
ffffffe000201e44:	0007c783          	lbu	a5,0(a5)
ffffffe000201e48:	00078713          	mv	a4,a5
ffffffe000201e4c:	07800793          	li	a5,120
ffffffe000201e50:	02f70663          	beq	a4,a5,ffffffe000201e7c <vprintfmt+0x254>
ffffffe000201e54:	f5043783          	ld	a5,-176(s0)
ffffffe000201e58:	0007c783          	lbu	a5,0(a5)
ffffffe000201e5c:	00078713          	mv	a4,a5
ffffffe000201e60:	05800793          	li	a5,88
ffffffe000201e64:	00f70c63          	beq	a4,a5,ffffffe000201e7c <vprintfmt+0x254>
ffffffe000201e68:	f5043783          	ld	a5,-176(s0)
ffffffe000201e6c:	0007c783          	lbu	a5,0(a5)
ffffffe000201e70:	00078713          	mv	a4,a5
ffffffe000201e74:	07000793          	li	a5,112
ffffffe000201e78:	30f71263          	bne	a4,a5,ffffffe00020217c <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000201e7c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e80:	0007c783          	lbu	a5,0(a5)
ffffffe000201e84:	00078713          	mv	a4,a5
ffffffe000201e88:	07000793          	li	a5,112
ffffffe000201e8c:	00f70663          	beq	a4,a5,ffffffe000201e98 <vprintfmt+0x270>
ffffffe000201e90:	f8144783          	lbu	a5,-127(s0)
ffffffe000201e94:	00078663          	beqz	a5,ffffffe000201ea0 <vprintfmt+0x278>
ffffffe000201e98:	00100793          	li	a5,1
ffffffe000201e9c:	0080006f          	j	ffffffe000201ea4 <vprintfmt+0x27c>
ffffffe000201ea0:	00000793          	li	a5,0
ffffffe000201ea4:	faf403a3          	sb	a5,-89(s0)
ffffffe000201ea8:	fa744783          	lbu	a5,-89(s0)
ffffffe000201eac:	0017f793          	andi	a5,a5,1
ffffffe000201eb0:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000201eb4:	fa744783          	lbu	a5,-89(s0)
ffffffe000201eb8:	0ff7f793          	zext.b	a5,a5
ffffffe000201ebc:	00078c63          	beqz	a5,ffffffe000201ed4 <vprintfmt+0x2ac>
ffffffe000201ec0:	f4843783          	ld	a5,-184(s0)
ffffffe000201ec4:	00878713          	addi	a4,a5,8
ffffffe000201ec8:	f4e43423          	sd	a4,-184(s0)
ffffffe000201ecc:	0007b783          	ld	a5,0(a5)
ffffffe000201ed0:	01c0006f          	j	ffffffe000201eec <vprintfmt+0x2c4>
ffffffe000201ed4:	f4843783          	ld	a5,-184(s0)
ffffffe000201ed8:	00878713          	addi	a4,a5,8
ffffffe000201edc:	f4e43423          	sd	a4,-184(s0)
ffffffe000201ee0:	0007a783          	lw	a5,0(a5)
ffffffe000201ee4:	02079793          	slli	a5,a5,0x20
ffffffe000201ee8:	0207d793          	srli	a5,a5,0x20
ffffffe000201eec:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000201ef0:	f8c42783          	lw	a5,-116(s0)
ffffffe000201ef4:	02079463          	bnez	a5,ffffffe000201f1c <vprintfmt+0x2f4>
ffffffe000201ef8:	fe043783          	ld	a5,-32(s0)
ffffffe000201efc:	02079063          	bnez	a5,ffffffe000201f1c <vprintfmt+0x2f4>
ffffffe000201f00:	f5043783          	ld	a5,-176(s0)
ffffffe000201f04:	0007c783          	lbu	a5,0(a5)
ffffffe000201f08:	00078713          	mv	a4,a5
ffffffe000201f0c:	07000793          	li	a5,112
ffffffe000201f10:	00f70663          	beq	a4,a5,ffffffe000201f1c <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000201f14:	f8040023          	sb	zero,-128(s0)
ffffffe000201f18:	4d00006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000201f1c:	f5043783          	ld	a5,-176(s0)
ffffffe000201f20:	0007c783          	lbu	a5,0(a5)
ffffffe000201f24:	00078713          	mv	a4,a5
ffffffe000201f28:	07000793          	li	a5,112
ffffffe000201f2c:	00f70a63          	beq	a4,a5,ffffffe000201f40 <vprintfmt+0x318>
ffffffe000201f30:	f8244783          	lbu	a5,-126(s0)
ffffffe000201f34:	00078a63          	beqz	a5,ffffffe000201f48 <vprintfmt+0x320>
ffffffe000201f38:	fe043783          	ld	a5,-32(s0)
ffffffe000201f3c:	00078663          	beqz	a5,ffffffe000201f48 <vprintfmt+0x320>
ffffffe000201f40:	00100793          	li	a5,1
ffffffe000201f44:	0080006f          	j	ffffffe000201f4c <vprintfmt+0x324>
ffffffe000201f48:	00000793          	li	a5,0
ffffffe000201f4c:	faf40323          	sb	a5,-90(s0)
ffffffe000201f50:	fa644783          	lbu	a5,-90(s0)
ffffffe000201f54:	0017f793          	andi	a5,a5,1
ffffffe000201f58:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000201f5c:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000201f60:	f5043783          	ld	a5,-176(s0)
ffffffe000201f64:	0007c783          	lbu	a5,0(a5)
ffffffe000201f68:	00078713          	mv	a4,a5
ffffffe000201f6c:	05800793          	li	a5,88
ffffffe000201f70:	00f71863          	bne	a4,a5,ffffffe000201f80 <vprintfmt+0x358>
ffffffe000201f74:	00001797          	auipc	a5,0x1
ffffffe000201f78:	4cc78793          	addi	a5,a5,1228 # ffffffe000203440 <upperxdigits.1>
ffffffe000201f7c:	00c0006f          	j	ffffffe000201f88 <vprintfmt+0x360>
ffffffe000201f80:	00001797          	auipc	a5,0x1
ffffffe000201f84:	4d878793          	addi	a5,a5,1240 # ffffffe000203458 <lowerxdigits.0>
ffffffe000201f88:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000201f8c:	fe043783          	ld	a5,-32(s0)
ffffffe000201f90:	00f7f793          	andi	a5,a5,15
ffffffe000201f94:	f9843703          	ld	a4,-104(s0)
ffffffe000201f98:	00f70733          	add	a4,a4,a5
ffffffe000201f9c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201fa0:	0017869b          	addiw	a3,a5,1
ffffffe000201fa4:	fcd42e23          	sw	a3,-36(s0)
ffffffe000201fa8:	00074703          	lbu	a4,0(a4)
ffffffe000201fac:	ff078793          	addi	a5,a5,-16
ffffffe000201fb0:	008787b3          	add	a5,a5,s0
ffffffe000201fb4:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000201fb8:	fe043783          	ld	a5,-32(s0)
ffffffe000201fbc:	0047d793          	srli	a5,a5,0x4
ffffffe000201fc0:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000201fc4:	fe043783          	ld	a5,-32(s0)
ffffffe000201fc8:	fc0792e3          	bnez	a5,ffffffe000201f8c <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000201fcc:	f8c42783          	lw	a5,-116(s0)
ffffffe000201fd0:	00078713          	mv	a4,a5
ffffffe000201fd4:	fff00793          	li	a5,-1
ffffffe000201fd8:	02f71663          	bne	a4,a5,ffffffe000202004 <vprintfmt+0x3dc>
ffffffe000201fdc:	f8344783          	lbu	a5,-125(s0)
ffffffe000201fe0:	02078263          	beqz	a5,ffffffe000202004 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000201fe4:	f8842703          	lw	a4,-120(s0)
ffffffe000201fe8:	fa644783          	lbu	a5,-90(s0)
ffffffe000201fec:	0007879b          	sext.w	a5,a5
ffffffe000201ff0:	0017979b          	slliw	a5,a5,0x1
ffffffe000201ff4:	0007879b          	sext.w	a5,a5
ffffffe000201ff8:	40f707bb          	subw	a5,a4,a5
ffffffe000201ffc:	0007879b          	sext.w	a5,a5
ffffffe000202000:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202004:	f8842703          	lw	a4,-120(s0)
ffffffe000202008:	fa644783          	lbu	a5,-90(s0)
ffffffe00020200c:	0007879b          	sext.w	a5,a5
ffffffe000202010:	0017979b          	slliw	a5,a5,0x1
ffffffe000202014:	0007879b          	sext.w	a5,a5
ffffffe000202018:	40f707bb          	subw	a5,a4,a5
ffffffe00020201c:	0007871b          	sext.w	a4,a5
ffffffe000202020:	fdc42783          	lw	a5,-36(s0)
ffffffe000202024:	f8f42a23          	sw	a5,-108(s0)
ffffffe000202028:	f8c42783          	lw	a5,-116(s0)
ffffffe00020202c:	f8f42823          	sw	a5,-112(s0)
ffffffe000202030:	f9442783          	lw	a5,-108(s0)
ffffffe000202034:	00078593          	mv	a1,a5
ffffffe000202038:	f9042783          	lw	a5,-112(s0)
ffffffe00020203c:	00078613          	mv	a2,a5
ffffffe000202040:	0006069b          	sext.w	a3,a2
ffffffe000202044:	0005879b          	sext.w	a5,a1
ffffffe000202048:	00f6d463          	bge	a3,a5,ffffffe000202050 <vprintfmt+0x428>
ffffffe00020204c:	00058613          	mv	a2,a1
ffffffe000202050:	0006079b          	sext.w	a5,a2
ffffffe000202054:	40f707bb          	subw	a5,a4,a5
ffffffe000202058:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020205c:	0280006f          	j	ffffffe000202084 <vprintfmt+0x45c>
                    putch(' ');
ffffffe000202060:	f5843783          	ld	a5,-168(s0)
ffffffe000202064:	02000513          	li	a0,32
ffffffe000202068:	000780e7          	jalr	a5
                    ++written;
ffffffe00020206c:	fec42783          	lw	a5,-20(s0)
ffffffe000202070:	0017879b          	addiw	a5,a5,1
ffffffe000202074:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202078:	fd842783          	lw	a5,-40(s0)
ffffffe00020207c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202080:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202084:	fd842783          	lw	a5,-40(s0)
ffffffe000202088:	0007879b          	sext.w	a5,a5
ffffffe00020208c:	fcf04ae3          	bgtz	a5,ffffffe000202060 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000202090:	fa644783          	lbu	a5,-90(s0)
ffffffe000202094:	0ff7f793          	zext.b	a5,a5
ffffffe000202098:	04078463          	beqz	a5,ffffffe0002020e0 <vprintfmt+0x4b8>
                    putch('0');
ffffffe00020209c:	f5843783          	ld	a5,-168(s0)
ffffffe0002020a0:	03000513          	li	a0,48
ffffffe0002020a4:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe0002020a8:	f5043783          	ld	a5,-176(s0)
ffffffe0002020ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002020b0:	00078713          	mv	a4,a5
ffffffe0002020b4:	05800793          	li	a5,88
ffffffe0002020b8:	00f71663          	bne	a4,a5,ffffffe0002020c4 <vprintfmt+0x49c>
ffffffe0002020bc:	05800793          	li	a5,88
ffffffe0002020c0:	0080006f          	j	ffffffe0002020c8 <vprintfmt+0x4a0>
ffffffe0002020c4:	07800793          	li	a5,120
ffffffe0002020c8:	f5843703          	ld	a4,-168(s0)
ffffffe0002020cc:	00078513          	mv	a0,a5
ffffffe0002020d0:	000700e7          	jalr	a4
                    written += 2;
ffffffe0002020d4:	fec42783          	lw	a5,-20(s0)
ffffffe0002020d8:	0027879b          	addiw	a5,a5,2
ffffffe0002020dc:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe0002020e0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002020e4:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002020e8:	0280006f          	j	ffffffe000202110 <vprintfmt+0x4e8>
                    putch('0');
ffffffe0002020ec:	f5843783          	ld	a5,-168(s0)
ffffffe0002020f0:	03000513          	li	a0,48
ffffffe0002020f4:	000780e7          	jalr	a5
                    ++written;
ffffffe0002020f8:	fec42783          	lw	a5,-20(s0)
ffffffe0002020fc:	0017879b          	addiw	a5,a5,1
ffffffe000202100:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202104:	fd442783          	lw	a5,-44(s0)
ffffffe000202108:	0017879b          	addiw	a5,a5,1
ffffffe00020210c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202110:	f8c42703          	lw	a4,-116(s0)
ffffffe000202114:	fd442783          	lw	a5,-44(s0)
ffffffe000202118:	0007879b          	sext.w	a5,a5
ffffffe00020211c:	fce7c8e3          	blt	a5,a4,ffffffe0002020ec <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202120:	fdc42783          	lw	a5,-36(s0)
ffffffe000202124:	fff7879b          	addiw	a5,a5,-1
ffffffe000202128:	fcf42823          	sw	a5,-48(s0)
ffffffe00020212c:	03c0006f          	j	ffffffe000202168 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000202130:	fd042783          	lw	a5,-48(s0)
ffffffe000202134:	ff078793          	addi	a5,a5,-16
ffffffe000202138:	008787b3          	add	a5,a5,s0
ffffffe00020213c:	f807c783          	lbu	a5,-128(a5)
ffffffe000202140:	0007871b          	sext.w	a4,a5
ffffffe000202144:	f5843783          	ld	a5,-168(s0)
ffffffe000202148:	00070513          	mv	a0,a4
ffffffe00020214c:	000780e7          	jalr	a5
                    ++written;
ffffffe000202150:	fec42783          	lw	a5,-20(s0)
ffffffe000202154:	0017879b          	addiw	a5,a5,1
ffffffe000202158:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe00020215c:	fd042783          	lw	a5,-48(s0)
ffffffe000202160:	fff7879b          	addiw	a5,a5,-1
ffffffe000202164:	fcf42823          	sw	a5,-48(s0)
ffffffe000202168:	fd042783          	lw	a5,-48(s0)
ffffffe00020216c:	0007879b          	sext.w	a5,a5
ffffffe000202170:	fc07d0e3          	bgez	a5,ffffffe000202130 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000202174:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202178:	2700006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe00020217c:	f5043783          	ld	a5,-176(s0)
ffffffe000202180:	0007c783          	lbu	a5,0(a5)
ffffffe000202184:	00078713          	mv	a4,a5
ffffffe000202188:	06400793          	li	a5,100
ffffffe00020218c:	02f70663          	beq	a4,a5,ffffffe0002021b8 <vprintfmt+0x590>
ffffffe000202190:	f5043783          	ld	a5,-176(s0)
ffffffe000202194:	0007c783          	lbu	a5,0(a5)
ffffffe000202198:	00078713          	mv	a4,a5
ffffffe00020219c:	06900793          	li	a5,105
ffffffe0002021a0:	00f70c63          	beq	a4,a5,ffffffe0002021b8 <vprintfmt+0x590>
ffffffe0002021a4:	f5043783          	ld	a5,-176(s0)
ffffffe0002021a8:	0007c783          	lbu	a5,0(a5)
ffffffe0002021ac:	00078713          	mv	a4,a5
ffffffe0002021b0:	07500793          	li	a5,117
ffffffe0002021b4:	08f71063          	bne	a4,a5,ffffffe000202234 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe0002021b8:	f8144783          	lbu	a5,-127(s0)
ffffffe0002021bc:	00078c63          	beqz	a5,ffffffe0002021d4 <vprintfmt+0x5ac>
ffffffe0002021c0:	f4843783          	ld	a5,-184(s0)
ffffffe0002021c4:	00878713          	addi	a4,a5,8
ffffffe0002021c8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002021cc:	0007b783          	ld	a5,0(a5)
ffffffe0002021d0:	0140006f          	j	ffffffe0002021e4 <vprintfmt+0x5bc>
ffffffe0002021d4:	f4843783          	ld	a5,-184(s0)
ffffffe0002021d8:	00878713          	addi	a4,a5,8
ffffffe0002021dc:	f4e43423          	sd	a4,-184(s0)
ffffffe0002021e0:	0007a783          	lw	a5,0(a5)
ffffffe0002021e4:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe0002021e8:	fa843583          	ld	a1,-88(s0)
ffffffe0002021ec:	f5043783          	ld	a5,-176(s0)
ffffffe0002021f0:	0007c783          	lbu	a5,0(a5)
ffffffe0002021f4:	0007871b          	sext.w	a4,a5
ffffffe0002021f8:	07500793          	li	a5,117
ffffffe0002021fc:	40f707b3          	sub	a5,a4,a5
ffffffe000202200:	00f037b3          	snez	a5,a5
ffffffe000202204:	0ff7f793          	zext.b	a5,a5
ffffffe000202208:	f8040713          	addi	a4,s0,-128
ffffffe00020220c:	00070693          	mv	a3,a4
ffffffe000202210:	00078613          	mv	a2,a5
ffffffe000202214:	f5843503          	ld	a0,-168(s0)
ffffffe000202218:	f08ff0ef          	jal	ra,ffffffe000201920 <print_dec_int>
ffffffe00020221c:	00050793          	mv	a5,a0
ffffffe000202220:	fec42703          	lw	a4,-20(s0)
ffffffe000202224:	00f707bb          	addw	a5,a4,a5
ffffffe000202228:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020222c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202230:	1b80006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202234:	f5043783          	ld	a5,-176(s0)
ffffffe000202238:	0007c783          	lbu	a5,0(a5)
ffffffe00020223c:	00078713          	mv	a4,a5
ffffffe000202240:	06e00793          	li	a5,110
ffffffe000202244:	04f71c63          	bne	a4,a5,ffffffe00020229c <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe000202248:	f8144783          	lbu	a5,-127(s0)
ffffffe00020224c:	02078463          	beqz	a5,ffffffe000202274 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000202250:	f4843783          	ld	a5,-184(s0)
ffffffe000202254:	00878713          	addi	a4,a5,8
ffffffe000202258:	f4e43423          	sd	a4,-184(s0)
ffffffe00020225c:	0007b783          	ld	a5,0(a5)
ffffffe000202260:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202264:	fec42703          	lw	a4,-20(s0)
ffffffe000202268:	fb043783          	ld	a5,-80(s0)
ffffffe00020226c:	00e7b023          	sd	a4,0(a5)
ffffffe000202270:	0240006f          	j	ffffffe000202294 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000202274:	f4843783          	ld	a5,-184(s0)
ffffffe000202278:	00878713          	addi	a4,a5,8
ffffffe00020227c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202280:	0007b783          	ld	a5,0(a5)
ffffffe000202284:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe000202288:	fb843783          	ld	a5,-72(s0)
ffffffe00020228c:	fec42703          	lw	a4,-20(s0)
ffffffe000202290:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000202294:	f8040023          	sb	zero,-128(s0)
ffffffe000202298:	1500006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe00020229c:	f5043783          	ld	a5,-176(s0)
ffffffe0002022a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002022a4:	00078713          	mv	a4,a5
ffffffe0002022a8:	07300793          	li	a5,115
ffffffe0002022ac:	02f71e63          	bne	a4,a5,ffffffe0002022e8 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe0002022b0:	f4843783          	ld	a5,-184(s0)
ffffffe0002022b4:	00878713          	addi	a4,a5,8
ffffffe0002022b8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002022bc:	0007b783          	ld	a5,0(a5)
ffffffe0002022c0:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe0002022c4:	fc043583          	ld	a1,-64(s0)
ffffffe0002022c8:	f5843503          	ld	a0,-168(s0)
ffffffe0002022cc:	dccff0ef          	jal	ra,ffffffe000201898 <puts_wo_nl>
ffffffe0002022d0:	00050793          	mv	a5,a0
ffffffe0002022d4:	fec42703          	lw	a4,-20(s0)
ffffffe0002022d8:	00f707bb          	addw	a5,a4,a5
ffffffe0002022dc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002022e0:	f8040023          	sb	zero,-128(s0)
ffffffe0002022e4:	1040006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe0002022e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002022ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002022f0:	00078713          	mv	a4,a5
ffffffe0002022f4:	06300793          	li	a5,99
ffffffe0002022f8:	02f71e63          	bne	a4,a5,ffffffe000202334 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe0002022fc:	f4843783          	ld	a5,-184(s0)
ffffffe000202300:	00878713          	addi	a4,a5,8
ffffffe000202304:	f4e43423          	sd	a4,-184(s0)
ffffffe000202308:	0007a783          	lw	a5,0(a5)
ffffffe00020230c:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000202310:	fcc42703          	lw	a4,-52(s0)
ffffffe000202314:	f5843783          	ld	a5,-168(s0)
ffffffe000202318:	00070513          	mv	a0,a4
ffffffe00020231c:	000780e7          	jalr	a5
                ++written;
ffffffe000202320:	fec42783          	lw	a5,-20(s0)
ffffffe000202324:	0017879b          	addiw	a5,a5,1
ffffffe000202328:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020232c:	f8040023          	sb	zero,-128(s0)
ffffffe000202330:	0b80006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000202334:	f5043783          	ld	a5,-176(s0)
ffffffe000202338:	0007c783          	lbu	a5,0(a5)
ffffffe00020233c:	00078713          	mv	a4,a5
ffffffe000202340:	02500793          	li	a5,37
ffffffe000202344:	02f71263          	bne	a4,a5,ffffffe000202368 <vprintfmt+0x740>
                putch('%');
ffffffe000202348:	f5843783          	ld	a5,-168(s0)
ffffffe00020234c:	02500513          	li	a0,37
ffffffe000202350:	000780e7          	jalr	a5
                ++written;
ffffffe000202354:	fec42783          	lw	a5,-20(s0)
ffffffe000202358:	0017879b          	addiw	a5,a5,1
ffffffe00020235c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202360:	f8040023          	sb	zero,-128(s0)
ffffffe000202364:	0840006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe000202368:	f5043783          	ld	a5,-176(s0)
ffffffe00020236c:	0007c783          	lbu	a5,0(a5)
ffffffe000202370:	0007871b          	sext.w	a4,a5
ffffffe000202374:	f5843783          	ld	a5,-168(s0)
ffffffe000202378:	00070513          	mv	a0,a4
ffffffe00020237c:	000780e7          	jalr	a5
                ++written;
ffffffe000202380:	fec42783          	lw	a5,-20(s0)
ffffffe000202384:	0017879b          	addiw	a5,a5,1
ffffffe000202388:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020238c:	f8040023          	sb	zero,-128(s0)
ffffffe000202390:	0580006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe000202394:	f5043783          	ld	a5,-176(s0)
ffffffe000202398:	0007c783          	lbu	a5,0(a5)
ffffffe00020239c:	00078713          	mv	a4,a5
ffffffe0002023a0:	02500793          	li	a5,37
ffffffe0002023a4:	02f71063          	bne	a4,a5,ffffffe0002023c4 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe0002023a8:	f8043023          	sd	zero,-128(s0)
ffffffe0002023ac:	f8043423          	sd	zero,-120(s0)
ffffffe0002023b0:	00100793          	li	a5,1
ffffffe0002023b4:	f8f40023          	sb	a5,-128(s0)
ffffffe0002023b8:	fff00793          	li	a5,-1
ffffffe0002023bc:	f8f42623          	sw	a5,-116(s0)
ffffffe0002023c0:	0280006f          	j	ffffffe0002023e8 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe0002023c4:	f5043783          	ld	a5,-176(s0)
ffffffe0002023c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002023cc:	0007871b          	sext.w	a4,a5
ffffffe0002023d0:	f5843783          	ld	a5,-168(s0)
ffffffe0002023d4:	00070513          	mv	a0,a4
ffffffe0002023d8:	000780e7          	jalr	a5
            ++written;
ffffffe0002023dc:	fec42783          	lw	a5,-20(s0)
ffffffe0002023e0:	0017879b          	addiw	a5,a5,1
ffffffe0002023e4:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe0002023e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002023ec:	00178793          	addi	a5,a5,1
ffffffe0002023f0:	f4f43823          	sd	a5,-176(s0)
ffffffe0002023f4:	f5043783          	ld	a5,-176(s0)
ffffffe0002023f8:	0007c783          	lbu	a5,0(a5)
ffffffe0002023fc:	84079ce3          	bnez	a5,ffffffe000201c54 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000202400:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202404:	00078513          	mv	a0,a5
ffffffe000202408:	0b813083          	ld	ra,184(sp)
ffffffe00020240c:	0b013403          	ld	s0,176(sp)
ffffffe000202410:	0c010113          	addi	sp,sp,192
ffffffe000202414:	00008067          	ret

ffffffe000202418 <printk>:

int printk(const char* s, ...) {
ffffffe000202418:	f9010113          	addi	sp,sp,-112
ffffffe00020241c:	02113423          	sd	ra,40(sp)
ffffffe000202420:	02813023          	sd	s0,32(sp)
ffffffe000202424:	03010413          	addi	s0,sp,48
ffffffe000202428:	fca43c23          	sd	a0,-40(s0)
ffffffe00020242c:	00b43423          	sd	a1,8(s0)
ffffffe000202430:	00c43823          	sd	a2,16(s0)
ffffffe000202434:	00d43c23          	sd	a3,24(s0)
ffffffe000202438:	02e43023          	sd	a4,32(s0)
ffffffe00020243c:	02f43423          	sd	a5,40(s0)
ffffffe000202440:	03043823          	sd	a6,48(s0)
ffffffe000202444:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000202448:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe00020244c:	04040793          	addi	a5,s0,64
ffffffe000202450:	fcf43823          	sd	a5,-48(s0)
ffffffe000202454:	fd043783          	ld	a5,-48(s0)
ffffffe000202458:	fc878793          	addi	a5,a5,-56
ffffffe00020245c:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000202460:	fe043783          	ld	a5,-32(s0)
ffffffe000202464:	00078613          	mv	a2,a5
ffffffe000202468:	fd843583          	ld	a1,-40(s0)
ffffffe00020246c:	fffff517          	auipc	a0,0xfffff
ffffffe000202470:	11850513          	addi	a0,a0,280 # ffffffe000201584 <putc>
ffffffe000202474:	fb4ff0ef          	jal	ra,ffffffe000201c28 <vprintfmt>
ffffffe000202478:	00050793          	mv	a5,a0
ffffffe00020247c:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000202480:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202484:	00078513          	mv	a0,a5
ffffffe000202488:	02813083          	ld	ra,40(sp)
ffffffe00020248c:	02013403          	ld	s0,32(sp)
ffffffe000202490:	07010113          	addi	sp,sp,112
ffffffe000202494:	00008067          	ret

ffffffe000202498 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe000202498:	fe010113          	addi	sp,sp,-32
ffffffe00020249c:	00813c23          	sd	s0,24(sp)
ffffffe0002024a0:	02010413          	addi	s0,sp,32
ffffffe0002024a4:	00050793          	mv	a5,a0
ffffffe0002024a8:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe0002024ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002024b0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002024b4:	0007879b          	sext.w	a5,a5
ffffffe0002024b8:	02079713          	slli	a4,a5,0x20
ffffffe0002024bc:	02075713          	srli	a4,a4,0x20
ffffffe0002024c0:	00004797          	auipc	a5,0x4
ffffffe0002024c4:	b5878793          	addi	a5,a5,-1192 # ffffffe000206018 <seed>
ffffffe0002024c8:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002024cc:	00000013          	nop
ffffffe0002024d0:	01813403          	ld	s0,24(sp)
ffffffe0002024d4:	02010113          	addi	sp,sp,32
ffffffe0002024d8:	00008067          	ret

ffffffe0002024dc <rand>:

int rand(void) {
ffffffe0002024dc:	ff010113          	addi	sp,sp,-16
ffffffe0002024e0:	00813423          	sd	s0,8(sp)
ffffffe0002024e4:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe0002024e8:	00004797          	auipc	a5,0x4
ffffffe0002024ec:	b3078793          	addi	a5,a5,-1232 # ffffffe000206018 <seed>
ffffffe0002024f0:	0007b703          	ld	a4,0(a5)
ffffffe0002024f4:	00001797          	auipc	a5,0x1
ffffffe0002024f8:	f7c78793          	addi	a5,a5,-132 # ffffffe000203470 <lowerxdigits.0+0x18>
ffffffe0002024fc:	0007b783          	ld	a5,0(a5)
ffffffe000202500:	02f707b3          	mul	a5,a4,a5
ffffffe000202504:	00178713          	addi	a4,a5,1
ffffffe000202508:	00004797          	auipc	a5,0x4
ffffffe00020250c:	b1078793          	addi	a5,a5,-1264 # ffffffe000206018 <seed>
ffffffe000202510:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000202514:	00004797          	auipc	a5,0x4
ffffffe000202518:	b0478793          	addi	a5,a5,-1276 # ffffffe000206018 <seed>
ffffffe00020251c:	0007b783          	ld	a5,0(a5)
ffffffe000202520:	0217d793          	srli	a5,a5,0x21
ffffffe000202524:	0007879b          	sext.w	a5,a5
}
ffffffe000202528:	00078513          	mv	a0,a5
ffffffe00020252c:	00813403          	ld	s0,8(sp)
ffffffe000202530:	01010113          	addi	sp,sp,16
ffffffe000202534:	00008067          	ret

ffffffe000202538 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000202538:	fc010113          	addi	sp,sp,-64
ffffffe00020253c:	02813c23          	sd	s0,56(sp)
ffffffe000202540:	04010413          	addi	s0,sp,64
ffffffe000202544:	fca43c23          	sd	a0,-40(s0)
ffffffe000202548:	00058793          	mv	a5,a1
ffffffe00020254c:	fcc43423          	sd	a2,-56(s0)
ffffffe000202550:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000202554:	fd843783          	ld	a5,-40(s0)
ffffffe000202558:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe00020255c:	fe043423          	sd	zero,-24(s0)
ffffffe000202560:	0280006f          	j	ffffffe000202588 <memset+0x50>
        s[i] = c;
ffffffe000202564:	fe043703          	ld	a4,-32(s0)
ffffffe000202568:	fe843783          	ld	a5,-24(s0)
ffffffe00020256c:	00f707b3          	add	a5,a4,a5
ffffffe000202570:	fd442703          	lw	a4,-44(s0)
ffffffe000202574:	0ff77713          	zext.b	a4,a4
ffffffe000202578:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe00020257c:	fe843783          	ld	a5,-24(s0)
ffffffe000202580:	00178793          	addi	a5,a5,1
ffffffe000202584:	fef43423          	sd	a5,-24(s0)
ffffffe000202588:	fe843703          	ld	a4,-24(s0)
ffffffe00020258c:	fc843783          	ld	a5,-56(s0)
ffffffe000202590:	fcf76ae3          	bltu	a4,a5,ffffffe000202564 <memset+0x2c>
    }
    return dest;
ffffffe000202594:	fd843783          	ld	a5,-40(s0)
}
ffffffe000202598:	00078513          	mv	a0,a5
ffffffe00020259c:	03813403          	ld	s0,56(sp)
ffffffe0002025a0:	04010113          	addi	sp,sp,64
ffffffe0002025a4:	00008067          	ret
