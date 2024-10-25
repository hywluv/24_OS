
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern dummy
    .section .text.init
    .globl _start
_start:
    #implement
    la sp, boot_stack_top # initialize stack
    80200000:	00003117          	auipc	sp,0x3
    80200004:	02013103          	ld	sp,32(sp) # 80203020 <_GLOBAL_OFFSET_TABLE_+0x18>

    call mm_init
    80200008:	3e0000ef          	jal	ra,802003e8 <mm_init>
    call task_init
    8020000c:	420000ef          	jal	ra,8020042c <task_init>

    la t0, _traps # load traps
    80200010:	00003297          	auipc	t0,0x3
    80200014:	0202b283          	ld	t0,32(t0) # 80203030 <_GLOBAL_OFFSET_TABLE_+0x28>
    csrw stvec, t0 # set traps
    80200018:	10529073          	csrw	stvec,t0

    li t0, (1 << 5) # enable interrupts
    8020001c:	02000293          	li	t0,32
    csrs sie, t0
    80200020:	1042a073          	csrs	sie,t0

    li t1, 10000000
    80200024:	00989337          	lui	t1,0x989
    80200028:	6803031b          	addiw	t1,t1,1664 # 989680 <_skernel-0x7f876980>
    rdtime t0
    8020002c:	c01022f3          	rdtime	t0
    add t0, t0, t1
    80200030:	006282b3          	add	t0,t0,t1
    mv a0, t0 # set time to 1s
    80200034:	00028513          	mv	a0,t0
    li a7, 0 # set eid to 0
    80200038:	00000893          	li	a7,0
    ecall # call sbi_set_timer
    8020003c:	00000073          	ecall

    li t0, (1 << 1)
    80200040:	00200293          	li	t0,2
    csrs sstatus, t0 # enable global interrupt
    80200044:	1002a073          	csrs	sstatus,t0

    call start_kernel # jump to start_kernel
    80200048:	401000ef          	jal	ra,80200c48 <start_kernel>
    j _start # loop
    8020004c:	fb5ff06f          	j	80200000 <_skernel>

0000000080200050 <_traps>:
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap

    addi sp, sp, -33*8
    80200050:	ef810113          	addi	sp,sp,-264
    sd ra, 0*8(sp)
    80200054:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
    80200058:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
    8020005c:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
    80200060:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
    80200064:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
    80200068:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
    8020006c:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
    80200070:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
    80200074:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
    80200078:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
    8020007c:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
    80200080:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
    80200084:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
    80200088:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
    8020008c:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
    80200090:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
    80200094:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
    80200098:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
    8020009c:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
    802000a0:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
    802000a4:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
    802000a8:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
    802000ac:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
    802000b0:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
    802000b4:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
    802000b8:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
    802000bc:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
    802000c0:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
    802000c4:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
    802000c8:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
    802000cc:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
    802000d0:	0e513823          	sd	t0,240(sp)
    sd sp, 31*8(sp)
    802000d4:	0e213c23          	sd	sp,248(sp)

    csrr a0, scause
    802000d8:	14202573          	csrr	a0,scause
    csrr a1, sepc
    802000dc:	141025f3          	csrr	a1,sepc
    call trap_handler
    802000e0:	2e5000ef          	jal	ra,80200bc4 <trap_handler>

    ld sp, 31*8(sp)
    802000e4:	0f813103          	ld	sp,248(sp)
    ld t0, 30*8(sp)
    802000e8:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
    802000ec:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
    802000f0:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
    802000f4:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
    802000f8:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
    802000fc:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
    80200100:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
    80200104:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
    80200108:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
    8020010c:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
    80200110:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
    80200114:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
    80200118:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
    8020011c:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
    80200120:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
    80200124:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
    80200128:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
    8020012c:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
    80200130:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
    80200134:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
    80200138:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
    8020013c:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
    80200140:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
    80200144:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
    80200148:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
    8020014c:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
    80200150:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
    80200154:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
    80200158:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
    8020015c:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
    80200160:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
    80200164:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
    80200168:	10810113          	addi	sp,sp,264
    sret
    8020016c:	10200073          	sret

0000000080200170 <__dummy>:

    .globl __dummy
__dummy:
    la t0, dummy
    80200170:	00003297          	auipc	t0,0x3
    80200174:	eb82b283          	ld	t0,-328(t0) # 80203028 <_GLOBAL_OFFSET_TABLE_+0x20>
    csrw sepc, t0
    80200178:	14129073          	csrw	sepc,t0
    sret
    8020017c:	10200073          	sret

0000000080200180 <__switch_to>:

.globl __switch_to
__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra, 0(a0)
    80200180:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
    80200184:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
    80200188:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
    8020018c:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
    80200190:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
    80200194:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
    80200198:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
    8020019c:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
    802001a0:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
    802001a4:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
    802001a8:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
    802001ac:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
    802001b0:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
    802001b4:	07b53423          	sd	s11,104(a0)
    # restore state from next process
    # YOUR CODE HERE
    ld ra, 0(a1)
    802001b8:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
    802001bc:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
    802001c0:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
    802001c4:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
    802001c8:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
    802001cc:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
    802001d0:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
    802001d4:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
    802001d8:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
    802001dc:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
    802001e0:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
    802001e4:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
    802001e8:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
    802001ec:	0685bd83          	ld	s11,104(a1)
    802001f0:	00008067          	ret

00000000802001f4 <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 30000000;

uint64_t get_cycles() {
    802001f4:	fe010113          	addi	sp,sp,-32
    802001f8:	00813c23          	sd	s0,24(sp)
    802001fc:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
    80200200:	c01027f3          	rdtime	a5
    80200204:	fef43423          	sd	a5,-24(s0)
    return cycles;
    80200208:	fe843783          	ld	a5,-24(s0)
}
    8020020c:	00078513          	mv	a0,a5
    80200210:	01813403          	ld	s0,24(sp)
    80200214:	02010113          	addi	sp,sp,32
    80200218:	00008067          	ret

000000008020021c <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
    8020021c:	fe010113          	addi	sp,sp,-32
    80200220:	00813c23          	sd	s0,24(sp)
    80200224:	02010413          	addi	s0,sp,32
    80200228:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
    8020022c:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
    80200230:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
    80200234:	00000073          	ecall
}
    80200238:	00000013          	nop
    8020023c:	01813403          	ld	s0,24(sp)
    80200240:	02010113          	addi	sp,sp,32
    80200244:	00008067          	ret

0000000080200248 <clock_set_next_event>:

void clock_set_next_event() {
    80200248:	fe010113          	addi	sp,sp,-32
    8020024c:	00113c23          	sd	ra,24(sp)
    80200250:	00813823          	sd	s0,16(sp)
    80200254:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    80200258:	f9dff0ef          	jal	ra,802001f4 <get_cycles>
    8020025c:	00050713          	mv	a4,a0
    80200260:	00003797          	auipc	a5,0x3
    80200264:	da078793          	addi	a5,a5,-608 # 80203000 <TIMECLOCK>
    80200268:	0007b783          	ld	a5,0(a5)
    8020026c:	00f707b3          	add	a5,a4,a5
    80200270:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
    80200274:	fe843503          	ld	a0,-24(s0)
    80200278:	fa5ff0ef          	jal	ra,8020021c <sbi_set_timer>
    8020027c:	00000013          	nop
    80200280:	01813083          	ld	ra,24(sp)
    80200284:	01013403          	ld	s0,16(sp)
    80200288:	02010113          	addi	sp,sp,32
    8020028c:	00008067          	ret

0000000080200290 <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
    80200290:	fe010113          	addi	sp,sp,-32
    80200294:	00113c23          	sd	ra,24(sp)
    80200298:	00813823          	sd	s0,16(sp)
    8020029c:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
    802002a0:	00005797          	auipc	a5,0x5
    802002a4:	d6078793          	addi	a5,a5,-672 # 80205000 <kmem>
    802002a8:	0007b783          	ld	a5,0(a5)
    802002ac:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
    802002b0:	fe843783          	ld	a5,-24(s0)
    802002b4:	0007b703          	ld	a4,0(a5)
    802002b8:	00005797          	auipc	a5,0x5
    802002bc:	d4878793          	addi	a5,a5,-696 # 80205000 <kmem>
    802002c0:	00e7b023          	sd	a4,0(a5)
    memset((void *)r, 0x0, PGSIZE);
    802002c4:	00001637          	lui	a2,0x1
    802002c8:	00000593          	li	a1,0
    802002cc:	fe843503          	ld	a0,-24(s0)
    802002d0:	1a5010ef          	jal	ra,80201c74 <memset>
    return (void *)r;
    802002d4:	fe843783          	ld	a5,-24(s0)
}
    802002d8:	00078513          	mv	a0,a5
    802002dc:	01813083          	ld	ra,24(sp)
    802002e0:	01013403          	ld	s0,16(sp)
    802002e4:	02010113          	addi	sp,sp,32
    802002e8:	00008067          	ret

00000000802002ec <kfree>:

void kfree(void *addr) {
    802002ec:	fd010113          	addi	sp,sp,-48
    802002f0:	02113423          	sd	ra,40(sp)
    802002f4:	02813023          	sd	s0,32(sp)
    802002f8:	03010413          	addi	s0,sp,48
    802002fc:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
    80200300:	fd843783          	ld	a5,-40(s0)
    80200304:	00078693          	mv	a3,a5
    80200308:	fd840793          	addi	a5,s0,-40
    8020030c:	fffff737          	lui	a4,0xfffff
    80200310:	00e6f733          	and	a4,a3,a4
    80200314:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
    80200318:	fd843783          	ld	a5,-40(s0)
    8020031c:	00001637          	lui	a2,0x1
    80200320:	00000593          	li	a1,0
    80200324:	00078513          	mv	a0,a5
    80200328:	14d010ef          	jal	ra,80201c74 <memset>

    r = (struct run *)addr;
    8020032c:	fd843783          	ld	a5,-40(s0)
    80200330:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
    80200334:	00005797          	auipc	a5,0x5
    80200338:	ccc78793          	addi	a5,a5,-820 # 80205000 <kmem>
    8020033c:	0007b703          	ld	a4,0(a5)
    80200340:	fe843783          	ld	a5,-24(s0)
    80200344:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
    80200348:	00005797          	auipc	a5,0x5
    8020034c:	cb878793          	addi	a5,a5,-840 # 80205000 <kmem>
    80200350:	fe843703          	ld	a4,-24(s0)
    80200354:	00e7b023          	sd	a4,0(a5)

    return;
    80200358:	00000013          	nop
}
    8020035c:	02813083          	ld	ra,40(sp)
    80200360:	02013403          	ld	s0,32(sp)
    80200364:	03010113          	addi	sp,sp,48
    80200368:	00008067          	ret

000000008020036c <kfreerange>:

void kfreerange(char *start, char *end) {
    8020036c:	fd010113          	addi	sp,sp,-48
    80200370:	02113423          	sd	ra,40(sp)
    80200374:	02813023          	sd	s0,32(sp)
    80200378:	03010413          	addi	s0,sp,48
    8020037c:	fca43c23          	sd	a0,-40(s0)
    80200380:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
    80200384:	fd843703          	ld	a4,-40(s0)
    80200388:	000017b7          	lui	a5,0x1
    8020038c:	fff78793          	addi	a5,a5,-1 # fff <_skernel-0x801ff001>
    80200390:	00f70733          	add	a4,a4,a5
    80200394:	fffff7b7          	lui	a5,0xfffff
    80200398:	00f777b3          	and	a5,a4,a5
    8020039c:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    802003a0:	01c0006f          	j	802003bc <kfreerange+0x50>
        kfree((void *)addr);
    802003a4:	fe843503          	ld	a0,-24(s0)
    802003a8:	f45ff0ef          	jal	ra,802002ec <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    802003ac:	fe843703          	ld	a4,-24(s0)
    802003b0:	000017b7          	lui	a5,0x1
    802003b4:	00f707b3          	add	a5,a4,a5
    802003b8:	fef43423          	sd	a5,-24(s0)
    802003bc:	fe843703          	ld	a4,-24(s0)
    802003c0:	000017b7          	lui	a5,0x1
    802003c4:	00f70733          	add	a4,a4,a5
    802003c8:	fd043783          	ld	a5,-48(s0)
    802003cc:	fce7fce3          	bgeu	a5,a4,802003a4 <kfreerange+0x38>
    }
}
    802003d0:	00000013          	nop
    802003d4:	00000013          	nop
    802003d8:	02813083          	ld	ra,40(sp)
    802003dc:	02013403          	ld	s0,32(sp)
    802003e0:	03010113          	addi	sp,sp,48
    802003e4:	00008067          	ret

00000000802003e8 <mm_init>:

void mm_init(void) {
    802003e8:	ff010113          	addi	sp,sp,-16
    802003ec:	00113423          	sd	ra,8(sp)
    802003f0:	00813023          	sd	s0,0(sp)
    802003f4:	01010413          	addi	s0,sp,16
    kfreerange(_ekernel, (char *)PHY_END);
    802003f8:	01100793          	li	a5,17
    802003fc:	01b79593          	slli	a1,a5,0x1b
    80200400:	00003517          	auipc	a0,0x3
    80200404:	c1053503          	ld	a0,-1008(a0) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>
    80200408:	f65ff0ef          	jal	ra,8020036c <kfreerange>
    printk("...mm_init done!\n");
    8020040c:	00002517          	auipc	a0,0x2
    80200410:	bf450513          	addi	a0,a0,-1036 # 80202000 <_srodata>
    80200414:	740010ef          	jal	ra,80201b54 <printk>
}
    80200418:	00000013          	nop
    8020041c:	00813083          	ld	ra,8(sp)
    80200420:	00013403          	ld	s0,0(sp)
    80200424:	01010113          	addi	sp,sp,16
    80200428:	00008067          	ret

000000008020042c <task_init>:
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

extern void __dummy();

void task_init() {
    8020042c:	fe010113          	addi	sp,sp,-32
    80200430:	00113c23          	sd	ra,24(sp)
    80200434:	00813823          	sd	s0,16(sp)
    80200438:	02010413          	addi	s0,sp,32
    srand(2024);
    8020043c:	7e800513          	li	a0,2024
    80200440:	794010ef          	jal	ra,80201bd4 <srand>
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    /* YOUR CODE HERE */
    idle = (struct task_struct *)kalloc();
    80200444:	e4dff0ef          	jal	ra,80200290 <kalloc>
    80200448:	00050713          	mv	a4,a0
    8020044c:	00005797          	auipc	a5,0x5
    80200450:	bbc78793          	addi	a5,a5,-1092 # 80205008 <idle>
    80200454:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
    80200458:	00005797          	auipc	a5,0x5
    8020045c:	bb078793          	addi	a5,a5,-1104 # 80205008 <idle>
    80200460:	0007b783          	ld	a5,0(a5)
    80200464:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
    80200468:	00005797          	auipc	a5,0x5
    8020046c:	ba078793          	addi	a5,a5,-1120 # 80205008 <idle>
    80200470:	0007b783          	ld	a5,0(a5)
    80200474:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
    80200478:	00005797          	auipc	a5,0x5
    8020047c:	b9078793          	addi	a5,a5,-1136 # 80205008 <idle>
    80200480:	0007b783          	ld	a5,0(a5)
    80200484:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
    80200488:	00005797          	auipc	a5,0x5
    8020048c:	b8078793          	addi	a5,a5,-1152 # 80205008 <idle>
    80200490:	0007b783          	ld	a5,0(a5)
    80200494:	0007bc23          	sd	zero,24(a5)
    current = idle;
    80200498:	00005797          	auipc	a5,0x5
    8020049c:	b7078793          	addi	a5,a5,-1168 # 80205008 <idle>
    802004a0:	0007b703          	ld	a4,0(a5)
    802004a4:	00005797          	auipc	a5,0x5
    802004a8:	b6c78793          	addi	a5,a5,-1172 # 80205010 <current>
    802004ac:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
    802004b0:	00005797          	auipc	a5,0x5
    802004b4:	b5878793          	addi	a5,a5,-1192 # 80205008 <idle>
    802004b8:	0007b703          	ld	a4,0(a5)
    802004bc:	00005797          	auipc	a5,0x5
    802004c0:	b5c78793          	addi	a5,a5,-1188 # 80205018 <task>
    802004c4:	00e7b023          	sd	a4,0(a5)
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    /* YOUR CODE HERE */
    for(int i = 1; i < NR_TASKS; i++) {
    802004c8:	00100793          	li	a5,1
    802004cc:	fef42623          	sw	a5,-20(s0)
    802004d0:	1600006f          	j	80200630 <task_init+0x204>
        task[i] = (struct task_struct *)kalloc();
    802004d4:	dbdff0ef          	jal	ra,80200290 <kalloc>
    802004d8:	00050693          	mv	a3,a0
    802004dc:	00005717          	auipc	a4,0x5
    802004e0:	b3c70713          	addi	a4,a4,-1220 # 80205018 <task>
    802004e4:	fec42783          	lw	a5,-20(s0)
    802004e8:	00379793          	slli	a5,a5,0x3
    802004ec:	00f707b3          	add	a5,a4,a5
    802004f0:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
    802004f4:	00005717          	auipc	a4,0x5
    802004f8:	b2470713          	addi	a4,a4,-1244 # 80205018 <task>
    802004fc:	fec42783          	lw	a5,-20(s0)
    80200500:	00379793          	slli	a5,a5,0x3
    80200504:	00f707b3          	add	a5,a4,a5
    80200508:	0007b783          	ld	a5,0(a5)
    8020050c:	0007b023          	sd	zero,0(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
    80200510:	708010ef          	jal	ra,80201c18 <rand>
    80200514:	00050793          	mv	a5,a0
    80200518:	00078713          	mv	a4,a5
    8020051c:	00a00793          	li	a5,10
    80200520:	02f767bb          	remw	a5,a4,a5
    80200524:	0007879b          	sext.w	a5,a5
    80200528:	0017879b          	addiw	a5,a5,1
    8020052c:	0007869b          	sext.w	a3,a5
    80200530:	00005717          	auipc	a4,0x5
    80200534:	ae870713          	addi	a4,a4,-1304 # 80205018 <task>
    80200538:	fec42783          	lw	a5,-20(s0)
    8020053c:	00379793          	slli	a5,a5,0x3
    80200540:	00f707b3          	add	a5,a4,a5
    80200544:	0007b783          	ld	a5,0(a5)
    80200548:	00068713          	mv	a4,a3
    8020054c:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = 0;
    80200550:	00005717          	auipc	a4,0x5
    80200554:	ac870713          	addi	a4,a4,-1336 # 80205018 <task>
    80200558:	fec42783          	lw	a5,-20(s0)
    8020055c:	00379793          	slli	a5,a5,0x3
    80200560:	00f707b3          	add	a5,a4,a5
    80200564:	0007b783          	ld	a5,0(a5)
    80200568:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
    8020056c:	00005717          	auipc	a4,0x5
    80200570:	aac70713          	addi	a4,a4,-1364 # 80205018 <task>
    80200574:	fec42783          	lw	a5,-20(s0)
    80200578:	00379793          	slli	a5,a5,0x3
    8020057c:	00f707b3          	add	a5,a4,a5
    80200580:	0007b783          	ld	a5,0(a5)
    80200584:	fec42703          	lw	a4,-20(s0)
    80200588:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
    8020058c:	00005717          	auipc	a4,0x5
    80200590:	a8c70713          	addi	a4,a4,-1396 # 80205018 <task>
    80200594:	fec42783          	lw	a5,-20(s0)
    80200598:	00379793          	slli	a5,a5,0x3
    8020059c:	00f707b3          	add	a5,a4,a5
    802005a0:	0007b783          	ld	a5,0(a5)
    802005a4:	00003717          	auipc	a4,0x3
    802005a8:	a7473703          	ld	a4,-1420(a4) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    802005ac:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
    802005b0:	00005717          	auipc	a4,0x5
    802005b4:	a6870713          	addi	a4,a4,-1432 # 80205018 <task>
    802005b8:	fec42783          	lw	a5,-20(s0)
    802005bc:	00379793          	slli	a5,a5,0x3
    802005c0:	00f707b3          	add	a5,a4,a5
    802005c4:	0007b783          	ld	a5,0(a5)
    802005c8:	00078693          	mv	a3,a5
    802005cc:	00005717          	auipc	a4,0x5
    802005d0:	a4c70713          	addi	a4,a4,-1460 # 80205018 <task>
    802005d4:	fec42783          	lw	a5,-20(s0)
    802005d8:	00379793          	slli	a5,a5,0x3
    802005dc:	00f707b3          	add	a5,a4,a5
    802005e0:	0007b783          	ld	a5,0(a5)
    802005e4:	00001737          	lui	a4,0x1
    802005e8:	00e68733          	add	a4,a3,a4
    802005ec:	02e7b423          	sd	a4,40(a5)
        printk("task[%d]: priority = %d\n", i, task[i]->priority);
    802005f0:	00005717          	auipc	a4,0x5
    802005f4:	a2870713          	addi	a4,a4,-1496 # 80205018 <task>
    802005f8:	fec42783          	lw	a5,-20(s0)
    802005fc:	00379793          	slli	a5,a5,0x3
    80200600:	00f707b3          	add	a5,a4,a5
    80200604:	0007b783          	ld	a5,0(a5)
    80200608:	0107b703          	ld	a4,16(a5)
    8020060c:	fec42783          	lw	a5,-20(s0)
    80200610:	00070613          	mv	a2,a4
    80200614:	00078593          	mv	a1,a5
    80200618:	00002517          	auipc	a0,0x2
    8020061c:	a0050513          	addi	a0,a0,-1536 # 80202018 <_srodata+0x18>
    80200620:	534010ef          	jal	ra,80201b54 <printk>
    for(int i = 1; i < NR_TASKS; i++) {
    80200624:	fec42783          	lw	a5,-20(s0)
    80200628:	0017879b          	addiw	a5,a5,1
    8020062c:	fef42623          	sw	a5,-20(s0)
    80200630:	fec42783          	lw	a5,-20(s0)
    80200634:	0007871b          	sext.w	a4,a5
    80200638:	01f00793          	li	a5,31
    8020063c:	e8e7dce3          	bge	a5,a4,802004d4 <task_init+0xa8>
    }

    printk("...task_init done!\n");
    80200640:	00002517          	auipc	a0,0x2
    80200644:	9f850513          	addi	a0,a0,-1544 # 80202038 <_srodata+0x38>
    80200648:	50c010ef          	jal	ra,80201b54 <printk>
}
    8020064c:	00000013          	nop
    80200650:	01813083          	ld	ra,24(sp)
    80200654:	01013403          	ld	s0,16(sp)
    80200658:	02010113          	addi	sp,sp,32
    8020065c:	00008067          	ret

0000000080200660 <switch_to>:

extern void __switch_to(struct thread_struct *prev, struct thread_struct *next);

void switch_to(struct task_struct *next) {
    80200660:	fd010113          	addi	sp,sp,-48
    80200664:	02113423          	sd	ra,40(sp)
    80200668:	02813023          	sd	s0,32(sp)
    8020066c:	03010413          	addi	s0,sp,48
    80200670:	fca43c23          	sd	a0,-40(s0)
    if (current != next) {
    80200674:	00005797          	auipc	a5,0x5
    80200678:	99c78793          	addi	a5,a5,-1636 # 80205010 <current>
    8020067c:	0007b783          	ld	a5,0(a5)
    80200680:	fd843703          	ld	a4,-40(s0)
    80200684:	04f70063          	beq	a4,a5,802006c4 <switch_to+0x64>
        struct task_struct *prev = current;
    80200688:	00005797          	auipc	a5,0x5
    8020068c:	98878793          	addi	a5,a5,-1656 # 80205010 <current>
    80200690:	0007b783          	ld	a5,0(a5)
    80200694:	fef43423          	sd	a5,-24(s0)
        current = next;
    80200698:	00005797          	auipc	a5,0x5
    8020069c:	97878793          	addi	a5,a5,-1672 # 80205010 <current>
    802006a0:	fd843703          	ld	a4,-40(s0)
    802006a4:	00e7b023          	sd	a4,0(a5)
        __switch_to(&(prev->thread), &(next->thread));
    802006a8:	fe843783          	ld	a5,-24(s0)
    802006ac:	02078713          	addi	a4,a5,32
    802006b0:	fd843783          	ld	a5,-40(s0)
    802006b4:	02078793          	addi	a5,a5,32
    802006b8:	00078593          	mv	a1,a5
    802006bc:	00070513          	mv	a0,a4
    802006c0:	ac1ff0ef          	jal	ra,80200180 <__switch_to>
        // printk("switch_to: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
    }
}
    802006c4:	00000013          	nop
    802006c8:	02813083          	ld	ra,40(sp)
    802006cc:	02013403          	ld	s0,32(sp)
    802006d0:	03010113          	addi	sp,sp,48
    802006d4:	00008067          	ret

00000000802006d8 <do_timer>:

void do_timer() {
    802006d8:	ff010113          	addi	sp,sp,-16
    802006dc:	00113423          	sd	ra,8(sp)
    802006e0:	00813023          	sd	s0,0(sp)
    802006e4:	01010413          	addi	s0,sp,16
    if (current->pid == 0 || current->counter == 0) {
    802006e8:	00005797          	auipc	a5,0x5
    802006ec:	92878793          	addi	a5,a5,-1752 # 80205010 <current>
    802006f0:	0007b783          	ld	a5,0(a5)
    802006f4:	0187b783          	ld	a5,24(a5)
    802006f8:	00078c63          	beqz	a5,80200710 <do_timer+0x38>
    802006fc:	00005797          	auipc	a5,0x5
    80200700:	91478793          	addi	a5,a5,-1772 # 80205010 <current>
    80200704:	0007b783          	ld	a5,0(a5)
    80200708:	0087b783          	ld	a5,8(a5)
    8020070c:	00079663          	bnez	a5,80200718 <do_timer+0x40>
        schedule();
    80200710:	050000ef          	jal	ra,80200760 <schedule>
    80200714:	03c0006f          	j	80200750 <do_timer+0x78>
    } else {
        --(current->counter);
    80200718:	00005797          	auipc	a5,0x5
    8020071c:	8f878793          	addi	a5,a5,-1800 # 80205010 <current>
    80200720:	0007b783          	ld	a5,0(a5)
    80200724:	0087b703          	ld	a4,8(a5)
    80200728:	fff70713          	addi	a4,a4,-1
    8020072c:	00e7b423          	sd	a4,8(a5)
        if(current->counter > 0) {
    80200730:	00005797          	auipc	a5,0x5
    80200734:	8e078793          	addi	a5,a5,-1824 # 80205010 <current>
    80200738:	0007b783          	ld	a5,0(a5)
    8020073c:	0087b783          	ld	a5,8(a5)
    80200740:	00079663          	bnez	a5,8020074c <do_timer+0x74>
            return;
        }
        schedule();
    80200744:	01c000ef          	jal	ra,80200760 <schedule>
    80200748:	0080006f          	j	80200750 <do_timer+0x78>
            return;
    8020074c:	00000013          	nop
    }
}
    80200750:	00813083          	ld	ra,8(sp)
    80200754:	00013403          	ld	s0,0(sp)
    80200758:	01010113          	addi	sp,sp,16
    8020075c:	00008067          	ret

0000000080200760 <schedule>:

void schedule() {
    80200760:	fd010113          	addi	sp,sp,-48
    80200764:	02113423          	sd	ra,40(sp)
    80200768:	02813023          	sd	s0,32(sp)
    8020076c:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
    80200770:	fe043423          	sd	zero,-24(s0)
    int max_counter = 0;
    80200774:	fe042223          	sw	zero,-28(s0)

    for (int i = 1; i < NR_TASKS; i++) {
    80200778:	00100793          	li	a5,1
    8020077c:	fef42023          	sw	a5,-32(s0)
    80200780:	0ac0006f          	j	8020082c <schedule+0xcc>
        if (task[i] && task[i]->state == TASK_RUNNING) {
    80200784:	00005717          	auipc	a4,0x5
    80200788:	89470713          	addi	a4,a4,-1900 # 80205018 <task>
    8020078c:	fe042783          	lw	a5,-32(s0)
    80200790:	00379793          	slli	a5,a5,0x3
    80200794:	00f707b3          	add	a5,a4,a5
    80200798:	0007b783          	ld	a5,0(a5)
    8020079c:	08078263          	beqz	a5,80200820 <schedule+0xc0>
    802007a0:	00005717          	auipc	a4,0x5
    802007a4:	87870713          	addi	a4,a4,-1928 # 80205018 <task>
    802007a8:	fe042783          	lw	a5,-32(s0)
    802007ac:	00379793          	slli	a5,a5,0x3
    802007b0:	00f707b3          	add	a5,a4,a5
    802007b4:	0007b783          	ld	a5,0(a5)
    802007b8:	0007b783          	ld	a5,0(a5)
    802007bc:	06079263          	bnez	a5,80200820 <schedule+0xc0>
            if (task[i]->counter > max_counter) {
    802007c0:	00005717          	auipc	a4,0x5
    802007c4:	85870713          	addi	a4,a4,-1960 # 80205018 <task>
    802007c8:	fe042783          	lw	a5,-32(s0)
    802007cc:	00379793          	slli	a5,a5,0x3
    802007d0:	00f707b3          	add	a5,a4,a5
    802007d4:	0007b783          	ld	a5,0(a5)
    802007d8:	0087b703          	ld	a4,8(a5)
    802007dc:	fe442783          	lw	a5,-28(s0)
    802007e0:	04e7f063          	bgeu	a5,a4,80200820 <schedule+0xc0>
                max_counter = task[i]->counter;
    802007e4:	00005717          	auipc	a4,0x5
    802007e8:	83470713          	addi	a4,a4,-1996 # 80205018 <task>
    802007ec:	fe042783          	lw	a5,-32(s0)
    802007f0:	00379793          	slli	a5,a5,0x3
    802007f4:	00f707b3          	add	a5,a4,a5
    802007f8:	0007b783          	ld	a5,0(a5)
    802007fc:	0087b783          	ld	a5,8(a5)
    80200800:	fef42223          	sw	a5,-28(s0)
                next = task[i];
    80200804:	00005717          	auipc	a4,0x5
    80200808:	81470713          	addi	a4,a4,-2028 # 80205018 <task>
    8020080c:	fe042783          	lw	a5,-32(s0)
    80200810:	00379793          	slli	a5,a5,0x3
    80200814:	00f707b3          	add	a5,a4,a5
    80200818:	0007b783          	ld	a5,0(a5)
    8020081c:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < NR_TASKS; i++) {
    80200820:	fe042783          	lw	a5,-32(s0)
    80200824:	0017879b          	addiw	a5,a5,1
    80200828:	fef42023          	sw	a5,-32(s0)
    8020082c:	fe042783          	lw	a5,-32(s0)
    80200830:	0007871b          	sext.w	a4,a5
    80200834:	01f00793          	li	a5,31
    80200838:	f4e7d6e3          	bge	a5,a4,80200784 <schedule+0x24>
            }
        }
    }

    if (max_counter == 0) {
    8020083c:	fe442783          	lw	a5,-28(s0)
    80200840:	0007879b          	sext.w	a5,a5
    80200844:	0a079263          	bnez	a5,802008e8 <schedule+0x188>
        for (int i = 0; i < NR_TASKS; i++) {
    80200848:	fc042e23          	sw	zero,-36(s0)
    8020084c:	0840006f          	j	802008d0 <schedule+0x170>
            if (task[i] && task[i]->state == TASK_RUNNING) {
    80200850:	00004717          	auipc	a4,0x4
    80200854:	7c870713          	addi	a4,a4,1992 # 80205018 <task>
    80200858:	fdc42783          	lw	a5,-36(s0)
    8020085c:	00379793          	slli	a5,a5,0x3
    80200860:	00f707b3          	add	a5,a4,a5
    80200864:	0007b783          	ld	a5,0(a5)
    80200868:	04078e63          	beqz	a5,802008c4 <schedule+0x164>
    8020086c:	00004717          	auipc	a4,0x4
    80200870:	7ac70713          	addi	a4,a4,1964 # 80205018 <task>
    80200874:	fdc42783          	lw	a5,-36(s0)
    80200878:	00379793          	slli	a5,a5,0x3
    8020087c:	00f707b3          	add	a5,a4,a5
    80200880:	0007b783          	ld	a5,0(a5)
    80200884:	0007b783          	ld	a5,0(a5)
    80200888:	02079e63          	bnez	a5,802008c4 <schedule+0x164>
                task[i]->counter = task[i]->priority;
    8020088c:	00004717          	auipc	a4,0x4
    80200890:	78c70713          	addi	a4,a4,1932 # 80205018 <task>
    80200894:	fdc42783          	lw	a5,-36(s0)
    80200898:	00379793          	slli	a5,a5,0x3
    8020089c:	00f707b3          	add	a5,a4,a5
    802008a0:	0007b703          	ld	a4,0(a5)
    802008a4:	00004697          	auipc	a3,0x4
    802008a8:	77468693          	addi	a3,a3,1908 # 80205018 <task>
    802008ac:	fdc42783          	lw	a5,-36(s0)
    802008b0:	00379793          	slli	a5,a5,0x3
    802008b4:	00f687b3          	add	a5,a3,a5
    802008b8:	0007b783          	ld	a5,0(a5)
    802008bc:	01073703          	ld	a4,16(a4)
    802008c0:	00e7b423          	sd	a4,8(a5)
        for (int i = 0; i < NR_TASKS; i++) {
    802008c4:	fdc42783          	lw	a5,-36(s0)
    802008c8:	0017879b          	addiw	a5,a5,1
    802008cc:	fcf42e23          	sw	a5,-36(s0)
    802008d0:	fdc42783          	lw	a5,-36(s0)
    802008d4:	0007871b          	sext.w	a4,a5
    802008d8:	01f00793          	li	a5,31
    802008dc:	f6e7dae3          	bge	a5,a4,80200850 <schedule+0xf0>
            }
        }
        schedule();
    802008e0:	e81ff0ef          	jal	ra,80200760 <schedule>
        return;
    802008e4:	0280006f          	j	8020090c <schedule+0x1ac>
    }

    if (next && next != current) {
    802008e8:	fe843783          	ld	a5,-24(s0)
    802008ec:	02078063          	beqz	a5,8020090c <schedule+0x1ac>
    802008f0:	00004797          	auipc	a5,0x4
    802008f4:	72078793          	addi	a5,a5,1824 # 80205010 <current>
    802008f8:	0007b783          	ld	a5,0(a5)
    802008fc:	fe843703          	ld	a4,-24(s0)
    80200900:	00f70663          	beq	a4,a5,8020090c <schedule+0x1ac>
        // printk("schedule: current->pid = %d, next->pid = %d\n", current->pid, next->pid);
        switch_to(next);
    80200904:	fe843503          	ld	a0,-24(s0)
    80200908:	d59ff0ef          	jal	ra,80200660 <switch_to>
    }
}
    8020090c:	02813083          	ld	ra,40(sp)
    80200910:	02013403          	ld	s0,32(sp)
    80200914:	03010113          	addi	sp,sp,48
    80200918:	00008067          	ret

000000008020091c <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    8020091c:	fd010113          	addi	sp,sp,-48
    80200920:	02113423          	sd	ra,40(sp)
    80200924:	02813023          	sd	s0,32(sp)
    80200928:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
    8020092c:	3b9ad7b7          	lui	a5,0x3b9ad
    80200930:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_skernel-0x448535f9>
    80200934:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
    80200938:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
    8020093c:	fff00793          	li	a5,-1
    80200940:	fef42223          	sw	a5,-28(s0)
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    80200944:	fe442783          	lw	a5,-28(s0)
    80200948:	0007871b          	sext.w	a4,a5
    8020094c:	fff00793          	li	a5,-1
    80200950:	00f70e63          	beq	a4,a5,8020096c <dummy+0x50>
    80200954:	00004797          	auipc	a5,0x4
    80200958:	6bc78793          	addi	a5,a5,1724 # 80205010 <current>
    8020095c:	0007b783          	ld	a5,0(a5)
    80200960:	0087b703          	ld	a4,8(a5)
    80200964:	fe442783          	lw	a5,-28(s0)
    80200968:	fcf70ee3          	beq	a4,a5,80200944 <dummy+0x28>
    8020096c:	00004797          	auipc	a5,0x4
    80200970:	6a478793          	addi	a5,a5,1700 # 80205010 <current>
    80200974:	0007b783          	ld	a5,0(a5)
    80200978:	0087b783          	ld	a5,8(a5)
    8020097c:	fc0784e3          	beqz	a5,80200944 <dummy+0x28>
            if (current->counter == 1) {
    80200980:	00004797          	auipc	a5,0x4
    80200984:	69078793          	addi	a5,a5,1680 # 80205010 <current>
    80200988:	0007b783          	ld	a5,0(a5)
    8020098c:	0087b703          	ld	a4,8(a5)
    80200990:	00100793          	li	a5,1
    80200994:	00f71e63          	bne	a4,a5,802009b0 <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
    80200998:	00004797          	auipc	a5,0x4
    8020099c:	67878793          	addi	a5,a5,1656 # 80205010 <current>
    802009a0:	0007b783          	ld	a5,0(a5)
    802009a4:	0087b703          	ld	a4,8(a5)
    802009a8:	fff70713          	addi	a4,a4,-1
    802009ac:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
    802009b0:	00004797          	auipc	a5,0x4
    802009b4:	66078793          	addi	a5,a5,1632 # 80205010 <current>
    802009b8:	0007b783          	ld	a5,0(a5)
    802009bc:	0087b783          	ld	a5,8(a5)
    802009c0:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
    802009c4:	fe843783          	ld	a5,-24(s0)
    802009c8:	00178713          	addi	a4,a5,1
    802009cc:	fd843783          	ld	a5,-40(s0)
    802009d0:	02f777b3          	remu	a5,a4,a5
    802009d4:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
    802009d8:	00004797          	auipc	a5,0x4
    802009dc:	63878793          	addi	a5,a5,1592 # 80205010 <current>
    802009e0:	0007b783          	ld	a5,0(a5)
    802009e4:	0187b783          	ld	a5,24(a5)
    802009e8:	fe843603          	ld	a2,-24(s0)
    802009ec:	00078593          	mv	a1,a5
    802009f0:	00001517          	auipc	a0,0x1
    802009f4:	66050513          	addi	a0,a0,1632 # 80202050 <_srodata+0x50>
    802009f8:	15c010ef          	jal	ra,80201b54 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    802009fc:	f49ff06f          	j	80200944 <dummy+0x28>

0000000080200a00 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    80200a00:	f8010113          	addi	sp,sp,-128
    80200a04:	06813c23          	sd	s0,120(sp)
    80200a08:	06913823          	sd	s1,112(sp)
    80200a0c:	07213423          	sd	s2,104(sp)
    80200a10:	07313023          	sd	s3,96(sp)
    80200a14:	08010413          	addi	s0,sp,128
    80200a18:	faa43c23          	sd	a0,-72(s0)
    80200a1c:	fab43823          	sd	a1,-80(s0)
    80200a20:	fac43423          	sd	a2,-88(s0)
    80200a24:	fad43023          	sd	a3,-96(s0)
    80200a28:	f8e43c23          	sd	a4,-104(s0)
    80200a2c:	f8f43823          	sd	a5,-112(s0)
    80200a30:	f9043423          	sd	a6,-120(s0)
    80200a34:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
    80200a38:	fb843e03          	ld	t3,-72(s0)
    80200a3c:	fb043e83          	ld	t4,-80(s0)
    80200a40:	fa843f03          	ld	t5,-88(s0)
    80200a44:	fa043f83          	ld	t6,-96(s0)
    80200a48:	f9843283          	ld	t0,-104(s0)
    80200a4c:	f9043483          	ld	s1,-112(s0)
    80200a50:	f8843903          	ld	s2,-120(s0)
    80200a54:	f8043983          	ld	s3,-128(s0)
    80200a58:	000e0893          	mv	a7,t3
    80200a5c:	000e8813          	mv	a6,t4
    80200a60:	000f0513          	mv	a0,t5
    80200a64:	000f8593          	mv	a1,t6
    80200a68:	00028613          	mv	a2,t0
    80200a6c:	00048693          	mv	a3,s1
    80200a70:	00090713          	mv	a4,s2
    80200a74:	00098793          	mv	a5,s3
    80200a78:	00000073          	ecall
    80200a7c:	00050e93          	mv	t4,a0
    80200a80:	00058e13          	mv	t3,a1
    80200a84:	fdd43023          	sd	t4,-64(s0)
    80200a88:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
    80200a8c:	fc043783          	ld	a5,-64(s0)
    80200a90:	fcf43823          	sd	a5,-48(s0)
    80200a94:	fc843783          	ld	a5,-56(s0)
    80200a98:	fcf43c23          	sd	a5,-40(s0)
    80200a9c:	fd043703          	ld	a4,-48(s0)
    80200aa0:	fd843783          	ld	a5,-40(s0)
    80200aa4:	00070313          	mv	t1,a4
    80200aa8:	00078393          	mv	t2,a5
    80200aac:	00030713          	mv	a4,t1
    80200ab0:	00038793          	mv	a5,t2
}
    80200ab4:	00070513          	mv	a0,a4
    80200ab8:	00078593          	mv	a1,a5
    80200abc:	07813403          	ld	s0,120(sp)
    80200ac0:	07013483          	ld	s1,112(sp)
    80200ac4:	06813903          	ld	s2,104(sp)
    80200ac8:	06013983          	ld	s3,96(sp)
    80200acc:	08010113          	addi	sp,sp,128
    80200ad0:	00008067          	ret

0000000080200ad4 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    80200ad4:	fd010113          	addi	sp,sp,-48
    80200ad8:	02813423          	sd	s0,40(sp)
    80200adc:	03010413          	addi	s0,sp,48
    80200ae0:	00050793          	mv	a5,a0
    80200ae4:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
    80200ae8:	00100793          	li	a5,1
    80200aec:	00000713          	li	a4,0
    80200af0:	fdf44683          	lbu	a3,-33(s0)
    80200af4:	00078893          	mv	a7,a5
    80200af8:	00070813          	mv	a6,a4
    80200afc:	00068513          	mv	a0,a3
    80200b00:	00000073          	ecall
    80200b04:	00050713          	mv	a4,a0
    80200b08:	00058793          	mv	a5,a1
    80200b0c:	fee43023          	sd	a4,-32(s0)
    80200b10:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
    80200b14:	00000013          	nop
    80200b18:	00070513          	mv	a0,a4
    80200b1c:	00078593          	mv	a1,a5
    80200b20:	02813403          	ld	s0,40(sp)
    80200b24:	03010113          	addi	sp,sp,48
    80200b28:	00008067          	ret

0000000080200b2c <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200b2c:	fc010113          	addi	sp,sp,-64
    80200b30:	02813c23          	sd	s0,56(sp)
    80200b34:	04010413          	addi	s0,sp,64
    80200b38:	00050793          	mv	a5,a0
    80200b3c:	00058713          	mv	a4,a1
    80200b40:	fcf42623          	sw	a5,-52(s0)
    80200b44:	00070793          	mv	a5,a4
    80200b48:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
    80200b4c:	00800793          	li	a5,8
    80200b50:	00000713          	li	a4,0
    80200b54:	fcc42583          	lw	a1,-52(s0)
    80200b58:	00058313          	mv	t1,a1
    80200b5c:	fc842583          	lw	a1,-56(s0)
    80200b60:	00058e13          	mv	t3,a1
    80200b64:	00078893          	mv	a7,a5
    80200b68:	00070813          	mv	a6,a4
    80200b6c:	00030513          	mv	a0,t1
    80200b70:	000e0593          	mv	a1,t3
    80200b74:	00000073          	ecall
    80200b78:	00050713          	mv	a4,a0
    80200b7c:	00058793          	mv	a5,a1
    80200b80:	fce43823          	sd	a4,-48(s0)
    80200b84:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
    80200b88:	fd043783          	ld	a5,-48(s0)
    80200b8c:	fef43023          	sd	a5,-32(s0)
    80200b90:	fd843783          	ld	a5,-40(s0)
    80200b94:	fef43423          	sd	a5,-24(s0)
    80200b98:	fe043703          	ld	a4,-32(s0)
    80200b9c:	fe843783          	ld	a5,-24(s0)
    80200ba0:	00070613          	mv	a2,a4
    80200ba4:	00078693          	mv	a3,a5
    80200ba8:	00060713          	mv	a4,a2
    80200bac:	00068793          	mv	a5,a3
    80200bb0:	00070513          	mv	a0,a4
    80200bb4:	00078593          	mv	a1,a5
    80200bb8:	03813403          	ld	s0,56(sp)
    80200bbc:	04010113          	addi	sp,sp,64
    80200bc0:	00008067          	ret

0000000080200bc4 <trap_handler>:
extern void clock_set_next_event();
extern uint64_t get_cycles();
extern void do_timer();
extern void dummy();

void trap_handler(uint64_t scause, uint64_t sepc) {
    80200bc4:	fd010113          	addi	sp,sp,-48
    80200bc8:	02113423          	sd	ra,40(sp)
    80200bcc:	02813023          	sd	s0,32(sp)
    80200bd0:	03010413          	addi	s0,sp,48
    80200bd4:	fca43c23          	sd	a0,-40(s0)
    80200bd8:	fcb43823          	sd	a1,-48(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
    80200bdc:	fd843783          	ld	a5,-40(s0)
    80200be0:	0407d063          	bgez	a5,80200c20 <trap_handler+0x5c>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
    80200be4:	fd843783          	ld	a5,-40(s0)
    80200be8:	0ff7f793          	zext.b	a5,a5
    80200bec:	fef43423          	sd	a5,-24(s0)
        if (interrupt_t == 0x5) {
    80200bf0:	fe843703          	ld	a4,-24(s0)
    80200bf4:	00500793          	li	a5,5
    80200bf8:	00f71863          	bne	a4,a5,80200c08 <trap_handler+0x44>
            // timer interrupt
            clock_set_next_event();
    80200bfc:	e4cff0ef          	jal	ra,80200248 <clock_set_next_event>
            do_timer();
    80200c00:	ad9ff0ef          	jal	ra,802006d8 <do_timer>
    }
    else {
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        // exception
    }
    80200c04:	0300006f          	j	80200c34 <trap_handler+0x70>
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    80200c08:	fd043603          	ld	a2,-48(s0)
    80200c0c:	fd843583          	ld	a1,-40(s0)
    80200c10:	00001517          	auipc	a0,0x1
    80200c14:	47050513          	addi	a0,a0,1136 # 80202080 <_srodata+0x80>
    80200c18:	73d000ef          	jal	ra,80201b54 <printk>
    80200c1c:	0180006f          	j	80200c34 <trap_handler+0x70>
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    80200c20:	fd043603          	ld	a2,-48(s0)
    80200c24:	fd843583          	ld	a1,-40(s0)
    80200c28:	00001517          	auipc	a0,0x1
    80200c2c:	48850513          	addi	a0,a0,1160 # 802020b0 <_srodata+0xb0>
    80200c30:	725000ef          	jal	ra,80201b54 <printk>
    80200c34:	00000013          	nop
    80200c38:	02813083          	ld	ra,40(sp)
    80200c3c:	02013403          	ld	s0,32(sp)
    80200c40:	03010113          	addi	sp,sp,48
    80200c44:	00008067          	ret

0000000080200c48 <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
    80200c48:	ff010113          	addi	sp,sp,-16
    80200c4c:	00113423          	sd	ra,8(sp)
    80200c50:	00813023          	sd	s0,0(sp)
    80200c54:	01010413          	addi	s0,sp,16
    printk("2024");
    80200c58:	00001517          	auipc	a0,0x1
    80200c5c:	48850513          	addi	a0,a0,1160 # 802020e0 <_srodata+0xe0>
    80200c60:	6f5000ef          	jal	ra,80201b54 <printk>
    printk(" ZJU Operating System\n");
    80200c64:	00001517          	auipc	a0,0x1
    80200c68:	48450513          	addi	a0,a0,1156 # 802020e8 <_srodata+0xe8>
    80200c6c:	6e9000ef          	jal	ra,80201b54 <printk>

    test();
    80200c70:	01c000ef          	jal	ra,80200c8c <test>
    return 0;
    80200c74:	00000793          	li	a5,0
}
    80200c78:	00078513          	mv	a0,a5
    80200c7c:	00813083          	ld	ra,8(sp)
    80200c80:	00013403          	ld	s0,0(sp)
    80200c84:	01010113          	addi	sp,sp,16
    80200c88:	00008067          	ret

0000000080200c8c <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
    80200c8c:	fe010113          	addi	sp,sp,-32
    80200c90:	00113c23          	sd	ra,24(sp)
    80200c94:	00813823          	sd	s0,16(sp)
    80200c98:	02010413          	addi	s0,sp,32
    int i = 0;
    80200c9c:	fe042623          	sw	zero,-20(s0)
    printk("kernel is running!\n");
    80200ca0:	00001517          	auipc	a0,0x1
    80200ca4:	46050513          	addi	a0,a0,1120 # 80202100 <_srodata+0x100>
    80200ca8:	6ad000ef          	jal	ra,80201b54 <printk>
    //     {
    //         // printk("kernel is running!\n");
    //         i = 0;
    //     }
    // }
}
    80200cac:	00000013          	nop
    80200cb0:	01813083          	ld	ra,24(sp)
    80200cb4:	01013403          	ld	s0,16(sp)
    80200cb8:	02010113          	addi	sp,sp,32
    80200cbc:	00008067          	ret

0000000080200cc0 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    80200cc0:	fe010113          	addi	sp,sp,-32
    80200cc4:	00113c23          	sd	ra,24(sp)
    80200cc8:	00813823          	sd	s0,16(sp)
    80200ccc:	02010413          	addi	s0,sp,32
    80200cd0:	00050793          	mv	a5,a0
    80200cd4:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    80200cd8:	fec42783          	lw	a5,-20(s0)
    80200cdc:	0ff7f793          	zext.b	a5,a5
    80200ce0:	00078513          	mv	a0,a5
    80200ce4:	df1ff0ef          	jal	ra,80200ad4 <sbi_debug_console_write_byte>
    return (char)c;
    80200ce8:	fec42783          	lw	a5,-20(s0)
    80200cec:	0ff7f793          	zext.b	a5,a5
    80200cf0:	0007879b          	sext.w	a5,a5
}
    80200cf4:	00078513          	mv	a0,a5
    80200cf8:	01813083          	ld	ra,24(sp)
    80200cfc:	01013403          	ld	s0,16(sp)
    80200d00:	02010113          	addi	sp,sp,32
    80200d04:	00008067          	ret

0000000080200d08 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    80200d08:	fe010113          	addi	sp,sp,-32
    80200d0c:	00813c23          	sd	s0,24(sp)
    80200d10:	02010413          	addi	s0,sp,32
    80200d14:	00050793          	mv	a5,a0
    80200d18:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    80200d1c:	fec42783          	lw	a5,-20(s0)
    80200d20:	0007871b          	sext.w	a4,a5
    80200d24:	02000793          	li	a5,32
    80200d28:	02f70263          	beq	a4,a5,80200d4c <isspace+0x44>
    80200d2c:	fec42783          	lw	a5,-20(s0)
    80200d30:	0007871b          	sext.w	a4,a5
    80200d34:	00800793          	li	a5,8
    80200d38:	00e7de63          	bge	a5,a4,80200d54 <isspace+0x4c>
    80200d3c:	fec42783          	lw	a5,-20(s0)
    80200d40:	0007871b          	sext.w	a4,a5
    80200d44:	00d00793          	li	a5,13
    80200d48:	00e7c663          	blt	a5,a4,80200d54 <isspace+0x4c>
    80200d4c:	00100793          	li	a5,1
    80200d50:	0080006f          	j	80200d58 <isspace+0x50>
    80200d54:	00000793          	li	a5,0
}
    80200d58:	00078513          	mv	a0,a5
    80200d5c:	01813403          	ld	s0,24(sp)
    80200d60:	02010113          	addi	sp,sp,32
    80200d64:	00008067          	ret

0000000080200d68 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    80200d68:	fb010113          	addi	sp,sp,-80
    80200d6c:	04113423          	sd	ra,72(sp)
    80200d70:	04813023          	sd	s0,64(sp)
    80200d74:	05010413          	addi	s0,sp,80
    80200d78:	fca43423          	sd	a0,-56(s0)
    80200d7c:	fcb43023          	sd	a1,-64(s0)
    80200d80:	00060793          	mv	a5,a2
    80200d84:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    80200d88:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    80200d8c:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    80200d90:	fc843783          	ld	a5,-56(s0)
    80200d94:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    80200d98:	0100006f          	j	80200da8 <strtol+0x40>
        p++;
    80200d9c:	fd843783          	ld	a5,-40(s0)
    80200da0:	00178793          	addi	a5,a5,1
    80200da4:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    80200da8:	fd843783          	ld	a5,-40(s0)
    80200dac:	0007c783          	lbu	a5,0(a5)
    80200db0:	0007879b          	sext.w	a5,a5
    80200db4:	00078513          	mv	a0,a5
    80200db8:	f51ff0ef          	jal	ra,80200d08 <isspace>
    80200dbc:	00050793          	mv	a5,a0
    80200dc0:	fc079ee3          	bnez	a5,80200d9c <strtol+0x34>
    }

    if (*p == '-') {
    80200dc4:	fd843783          	ld	a5,-40(s0)
    80200dc8:	0007c783          	lbu	a5,0(a5)
    80200dcc:	00078713          	mv	a4,a5
    80200dd0:	02d00793          	li	a5,45
    80200dd4:	00f71e63          	bne	a4,a5,80200df0 <strtol+0x88>
        neg = true;
    80200dd8:	00100793          	li	a5,1
    80200ddc:	fef403a3          	sb	a5,-25(s0)
        p++;
    80200de0:	fd843783          	ld	a5,-40(s0)
    80200de4:	00178793          	addi	a5,a5,1
    80200de8:	fcf43c23          	sd	a5,-40(s0)
    80200dec:	0240006f          	j	80200e10 <strtol+0xa8>
    } else if (*p == '+') {
    80200df0:	fd843783          	ld	a5,-40(s0)
    80200df4:	0007c783          	lbu	a5,0(a5)
    80200df8:	00078713          	mv	a4,a5
    80200dfc:	02b00793          	li	a5,43
    80200e00:	00f71863          	bne	a4,a5,80200e10 <strtol+0xa8>
        p++;
    80200e04:	fd843783          	ld	a5,-40(s0)
    80200e08:	00178793          	addi	a5,a5,1
    80200e0c:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    80200e10:	fbc42783          	lw	a5,-68(s0)
    80200e14:	0007879b          	sext.w	a5,a5
    80200e18:	06079c63          	bnez	a5,80200e90 <strtol+0x128>
        if (*p == '0') {
    80200e1c:	fd843783          	ld	a5,-40(s0)
    80200e20:	0007c783          	lbu	a5,0(a5)
    80200e24:	00078713          	mv	a4,a5
    80200e28:	03000793          	li	a5,48
    80200e2c:	04f71e63          	bne	a4,a5,80200e88 <strtol+0x120>
            p++;
    80200e30:	fd843783          	ld	a5,-40(s0)
    80200e34:	00178793          	addi	a5,a5,1
    80200e38:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    80200e3c:	fd843783          	ld	a5,-40(s0)
    80200e40:	0007c783          	lbu	a5,0(a5)
    80200e44:	00078713          	mv	a4,a5
    80200e48:	07800793          	li	a5,120
    80200e4c:	00f70c63          	beq	a4,a5,80200e64 <strtol+0xfc>
    80200e50:	fd843783          	ld	a5,-40(s0)
    80200e54:	0007c783          	lbu	a5,0(a5)
    80200e58:	00078713          	mv	a4,a5
    80200e5c:	05800793          	li	a5,88
    80200e60:	00f71e63          	bne	a4,a5,80200e7c <strtol+0x114>
                base = 16;
    80200e64:	01000793          	li	a5,16
    80200e68:	faf42e23          	sw	a5,-68(s0)
                p++;
    80200e6c:	fd843783          	ld	a5,-40(s0)
    80200e70:	00178793          	addi	a5,a5,1
    80200e74:	fcf43c23          	sd	a5,-40(s0)
    80200e78:	0180006f          	j	80200e90 <strtol+0x128>
            } else {
                base = 8;
    80200e7c:	00800793          	li	a5,8
    80200e80:	faf42e23          	sw	a5,-68(s0)
    80200e84:	00c0006f          	j	80200e90 <strtol+0x128>
            }
        } else {
            base = 10;
    80200e88:	00a00793          	li	a5,10
    80200e8c:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    80200e90:	fd843783          	ld	a5,-40(s0)
    80200e94:	0007c783          	lbu	a5,0(a5)
    80200e98:	00078713          	mv	a4,a5
    80200e9c:	02f00793          	li	a5,47
    80200ea0:	02e7f863          	bgeu	a5,a4,80200ed0 <strtol+0x168>
    80200ea4:	fd843783          	ld	a5,-40(s0)
    80200ea8:	0007c783          	lbu	a5,0(a5)
    80200eac:	00078713          	mv	a4,a5
    80200eb0:	03900793          	li	a5,57
    80200eb4:	00e7ee63          	bltu	a5,a4,80200ed0 <strtol+0x168>
            digit = *p - '0';
    80200eb8:	fd843783          	ld	a5,-40(s0)
    80200ebc:	0007c783          	lbu	a5,0(a5)
    80200ec0:	0007879b          	sext.w	a5,a5
    80200ec4:	fd07879b          	addiw	a5,a5,-48
    80200ec8:	fcf42a23          	sw	a5,-44(s0)
    80200ecc:	0800006f          	j	80200f4c <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    80200ed0:	fd843783          	ld	a5,-40(s0)
    80200ed4:	0007c783          	lbu	a5,0(a5)
    80200ed8:	00078713          	mv	a4,a5
    80200edc:	06000793          	li	a5,96
    80200ee0:	02e7f863          	bgeu	a5,a4,80200f10 <strtol+0x1a8>
    80200ee4:	fd843783          	ld	a5,-40(s0)
    80200ee8:	0007c783          	lbu	a5,0(a5)
    80200eec:	00078713          	mv	a4,a5
    80200ef0:	07a00793          	li	a5,122
    80200ef4:	00e7ee63          	bltu	a5,a4,80200f10 <strtol+0x1a8>
            digit = *p - ('a' - 10);
    80200ef8:	fd843783          	ld	a5,-40(s0)
    80200efc:	0007c783          	lbu	a5,0(a5)
    80200f00:	0007879b          	sext.w	a5,a5
    80200f04:	fa97879b          	addiw	a5,a5,-87
    80200f08:	fcf42a23          	sw	a5,-44(s0)
    80200f0c:	0400006f          	j	80200f4c <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    80200f10:	fd843783          	ld	a5,-40(s0)
    80200f14:	0007c783          	lbu	a5,0(a5)
    80200f18:	00078713          	mv	a4,a5
    80200f1c:	04000793          	li	a5,64
    80200f20:	06e7f863          	bgeu	a5,a4,80200f90 <strtol+0x228>
    80200f24:	fd843783          	ld	a5,-40(s0)
    80200f28:	0007c783          	lbu	a5,0(a5)
    80200f2c:	00078713          	mv	a4,a5
    80200f30:	05a00793          	li	a5,90
    80200f34:	04e7ee63          	bltu	a5,a4,80200f90 <strtol+0x228>
            digit = *p - ('A' - 10);
    80200f38:	fd843783          	ld	a5,-40(s0)
    80200f3c:	0007c783          	lbu	a5,0(a5)
    80200f40:	0007879b          	sext.w	a5,a5
    80200f44:	fc97879b          	addiw	a5,a5,-55
    80200f48:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    80200f4c:	fd442783          	lw	a5,-44(s0)
    80200f50:	00078713          	mv	a4,a5
    80200f54:	fbc42783          	lw	a5,-68(s0)
    80200f58:	0007071b          	sext.w	a4,a4
    80200f5c:	0007879b          	sext.w	a5,a5
    80200f60:	02f75663          	bge	a4,a5,80200f8c <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    80200f64:	fbc42703          	lw	a4,-68(s0)
    80200f68:	fe843783          	ld	a5,-24(s0)
    80200f6c:	02f70733          	mul	a4,a4,a5
    80200f70:	fd442783          	lw	a5,-44(s0)
    80200f74:	00f707b3          	add	a5,a4,a5
    80200f78:	fef43423          	sd	a5,-24(s0)
        p++;
    80200f7c:	fd843783          	ld	a5,-40(s0)
    80200f80:	00178793          	addi	a5,a5,1
    80200f84:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    80200f88:	f09ff06f          	j	80200e90 <strtol+0x128>
            break;
    80200f8c:	00000013          	nop
    }

    if (endptr) {
    80200f90:	fc043783          	ld	a5,-64(s0)
    80200f94:	00078863          	beqz	a5,80200fa4 <strtol+0x23c>
        *endptr = (char *)p;
    80200f98:	fc043783          	ld	a5,-64(s0)
    80200f9c:	fd843703          	ld	a4,-40(s0)
    80200fa0:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    80200fa4:	fe744783          	lbu	a5,-25(s0)
    80200fa8:	0ff7f793          	zext.b	a5,a5
    80200fac:	00078863          	beqz	a5,80200fbc <strtol+0x254>
    80200fb0:	fe843783          	ld	a5,-24(s0)
    80200fb4:	40f007b3          	neg	a5,a5
    80200fb8:	0080006f          	j	80200fc0 <strtol+0x258>
    80200fbc:	fe843783          	ld	a5,-24(s0)
}
    80200fc0:	00078513          	mv	a0,a5
    80200fc4:	04813083          	ld	ra,72(sp)
    80200fc8:	04013403          	ld	s0,64(sp)
    80200fcc:	05010113          	addi	sp,sp,80
    80200fd0:	00008067          	ret

0000000080200fd4 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    80200fd4:	fd010113          	addi	sp,sp,-48
    80200fd8:	02113423          	sd	ra,40(sp)
    80200fdc:	02813023          	sd	s0,32(sp)
    80200fe0:	03010413          	addi	s0,sp,48
    80200fe4:	fca43c23          	sd	a0,-40(s0)
    80200fe8:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    80200fec:	fd043783          	ld	a5,-48(s0)
    80200ff0:	00079863          	bnez	a5,80201000 <puts_wo_nl+0x2c>
        s = "(null)";
    80200ff4:	00001797          	auipc	a5,0x1
    80200ff8:	12478793          	addi	a5,a5,292 # 80202118 <_srodata+0x118>
    80200ffc:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    80201000:	fd043783          	ld	a5,-48(s0)
    80201004:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    80201008:	0240006f          	j	8020102c <puts_wo_nl+0x58>
        putch(*p++);
    8020100c:	fe843783          	ld	a5,-24(s0)
    80201010:	00178713          	addi	a4,a5,1
    80201014:	fee43423          	sd	a4,-24(s0)
    80201018:	0007c783          	lbu	a5,0(a5)
    8020101c:	0007871b          	sext.w	a4,a5
    80201020:	fd843783          	ld	a5,-40(s0)
    80201024:	00070513          	mv	a0,a4
    80201028:	000780e7          	jalr	a5
    while (*p) {
    8020102c:	fe843783          	ld	a5,-24(s0)
    80201030:	0007c783          	lbu	a5,0(a5)
    80201034:	fc079ce3          	bnez	a5,8020100c <puts_wo_nl+0x38>
    }
    return p - s;
    80201038:	fe843703          	ld	a4,-24(s0)
    8020103c:	fd043783          	ld	a5,-48(s0)
    80201040:	40f707b3          	sub	a5,a4,a5
    80201044:	0007879b          	sext.w	a5,a5
}
    80201048:	00078513          	mv	a0,a5
    8020104c:	02813083          	ld	ra,40(sp)
    80201050:	02013403          	ld	s0,32(sp)
    80201054:	03010113          	addi	sp,sp,48
    80201058:	00008067          	ret

000000008020105c <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    8020105c:	f9010113          	addi	sp,sp,-112
    80201060:	06113423          	sd	ra,104(sp)
    80201064:	06813023          	sd	s0,96(sp)
    80201068:	07010413          	addi	s0,sp,112
    8020106c:	faa43423          	sd	a0,-88(s0)
    80201070:	fab43023          	sd	a1,-96(s0)
    80201074:	00060793          	mv	a5,a2
    80201078:	f8d43823          	sd	a3,-112(s0)
    8020107c:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    80201080:	f9f44783          	lbu	a5,-97(s0)
    80201084:	0ff7f793          	zext.b	a5,a5
    80201088:	02078663          	beqz	a5,802010b4 <print_dec_int+0x58>
    8020108c:	fa043703          	ld	a4,-96(s0)
    80201090:	fff00793          	li	a5,-1
    80201094:	03f79793          	slli	a5,a5,0x3f
    80201098:	00f71e63          	bne	a4,a5,802010b4 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    8020109c:	00001597          	auipc	a1,0x1
    802010a0:	08458593          	addi	a1,a1,132 # 80202120 <_srodata+0x120>
    802010a4:	fa843503          	ld	a0,-88(s0)
    802010a8:	f2dff0ef          	jal	ra,80200fd4 <puts_wo_nl>
    802010ac:	00050793          	mv	a5,a0
    802010b0:	2a00006f          	j	80201350 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    802010b4:	f9043783          	ld	a5,-112(s0)
    802010b8:	00c7a783          	lw	a5,12(a5)
    802010bc:	00079a63          	bnez	a5,802010d0 <print_dec_int+0x74>
    802010c0:	fa043783          	ld	a5,-96(s0)
    802010c4:	00079663          	bnez	a5,802010d0 <print_dec_int+0x74>
        return 0;
    802010c8:	00000793          	li	a5,0
    802010cc:	2840006f          	j	80201350 <print_dec_int+0x2f4>
    }

    bool neg = false;
    802010d0:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    802010d4:	f9f44783          	lbu	a5,-97(s0)
    802010d8:	0ff7f793          	zext.b	a5,a5
    802010dc:	02078063          	beqz	a5,802010fc <print_dec_int+0xa0>
    802010e0:	fa043783          	ld	a5,-96(s0)
    802010e4:	0007dc63          	bgez	a5,802010fc <print_dec_int+0xa0>
        neg = true;
    802010e8:	00100793          	li	a5,1
    802010ec:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    802010f0:	fa043783          	ld	a5,-96(s0)
    802010f4:	40f007b3          	neg	a5,a5
    802010f8:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    802010fc:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    80201100:	f9f44783          	lbu	a5,-97(s0)
    80201104:	0ff7f793          	zext.b	a5,a5
    80201108:	02078863          	beqz	a5,80201138 <print_dec_int+0xdc>
    8020110c:	fef44783          	lbu	a5,-17(s0)
    80201110:	0ff7f793          	zext.b	a5,a5
    80201114:	00079e63          	bnez	a5,80201130 <print_dec_int+0xd4>
    80201118:	f9043783          	ld	a5,-112(s0)
    8020111c:	0057c783          	lbu	a5,5(a5)
    80201120:	00079863          	bnez	a5,80201130 <print_dec_int+0xd4>
    80201124:	f9043783          	ld	a5,-112(s0)
    80201128:	0047c783          	lbu	a5,4(a5)
    8020112c:	00078663          	beqz	a5,80201138 <print_dec_int+0xdc>
    80201130:	00100793          	li	a5,1
    80201134:	0080006f          	j	8020113c <print_dec_int+0xe0>
    80201138:	00000793          	li	a5,0
    8020113c:	fcf40ba3          	sb	a5,-41(s0)
    80201140:	fd744783          	lbu	a5,-41(s0)
    80201144:	0017f793          	andi	a5,a5,1
    80201148:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    8020114c:	fa043703          	ld	a4,-96(s0)
    80201150:	00a00793          	li	a5,10
    80201154:	02f777b3          	remu	a5,a4,a5
    80201158:	0ff7f713          	zext.b	a4,a5
    8020115c:	fe842783          	lw	a5,-24(s0)
    80201160:	0017869b          	addiw	a3,a5,1
    80201164:	fed42423          	sw	a3,-24(s0)
    80201168:	0307071b          	addiw	a4,a4,48
    8020116c:	0ff77713          	zext.b	a4,a4
    80201170:	ff078793          	addi	a5,a5,-16
    80201174:	008787b3          	add	a5,a5,s0
    80201178:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    8020117c:	fa043703          	ld	a4,-96(s0)
    80201180:	00a00793          	li	a5,10
    80201184:	02f757b3          	divu	a5,a4,a5
    80201188:	faf43023          	sd	a5,-96(s0)
    } while (num);
    8020118c:	fa043783          	ld	a5,-96(s0)
    80201190:	fa079ee3          	bnez	a5,8020114c <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    80201194:	f9043783          	ld	a5,-112(s0)
    80201198:	00c7a783          	lw	a5,12(a5)
    8020119c:	00078713          	mv	a4,a5
    802011a0:	fff00793          	li	a5,-1
    802011a4:	02f71063          	bne	a4,a5,802011c4 <print_dec_int+0x168>
    802011a8:	f9043783          	ld	a5,-112(s0)
    802011ac:	0037c783          	lbu	a5,3(a5)
    802011b0:	00078a63          	beqz	a5,802011c4 <print_dec_int+0x168>
        flags->prec = flags->width;
    802011b4:	f9043783          	ld	a5,-112(s0)
    802011b8:	0087a703          	lw	a4,8(a5)
    802011bc:	f9043783          	ld	a5,-112(s0)
    802011c0:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    802011c4:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    802011c8:	f9043783          	ld	a5,-112(s0)
    802011cc:	0087a703          	lw	a4,8(a5)
    802011d0:	fe842783          	lw	a5,-24(s0)
    802011d4:	fcf42823          	sw	a5,-48(s0)
    802011d8:	f9043783          	ld	a5,-112(s0)
    802011dc:	00c7a783          	lw	a5,12(a5)
    802011e0:	fcf42623          	sw	a5,-52(s0)
    802011e4:	fd042783          	lw	a5,-48(s0)
    802011e8:	00078593          	mv	a1,a5
    802011ec:	fcc42783          	lw	a5,-52(s0)
    802011f0:	00078613          	mv	a2,a5
    802011f4:	0006069b          	sext.w	a3,a2
    802011f8:	0005879b          	sext.w	a5,a1
    802011fc:	00f6d463          	bge	a3,a5,80201204 <print_dec_int+0x1a8>
    80201200:	00058613          	mv	a2,a1
    80201204:	0006079b          	sext.w	a5,a2
    80201208:	40f707bb          	subw	a5,a4,a5
    8020120c:	0007871b          	sext.w	a4,a5
    80201210:	fd744783          	lbu	a5,-41(s0)
    80201214:	0007879b          	sext.w	a5,a5
    80201218:	40f707bb          	subw	a5,a4,a5
    8020121c:	fef42023          	sw	a5,-32(s0)
    80201220:	0280006f          	j	80201248 <print_dec_int+0x1ec>
        putch(' ');
    80201224:	fa843783          	ld	a5,-88(s0)
    80201228:	02000513          	li	a0,32
    8020122c:	000780e7          	jalr	a5
        ++written;
    80201230:	fe442783          	lw	a5,-28(s0)
    80201234:	0017879b          	addiw	a5,a5,1
    80201238:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    8020123c:	fe042783          	lw	a5,-32(s0)
    80201240:	fff7879b          	addiw	a5,a5,-1
    80201244:	fef42023          	sw	a5,-32(s0)
    80201248:	fe042783          	lw	a5,-32(s0)
    8020124c:	0007879b          	sext.w	a5,a5
    80201250:	fcf04ae3          	bgtz	a5,80201224 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    80201254:	fd744783          	lbu	a5,-41(s0)
    80201258:	0ff7f793          	zext.b	a5,a5
    8020125c:	04078463          	beqz	a5,802012a4 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    80201260:	fef44783          	lbu	a5,-17(s0)
    80201264:	0ff7f793          	zext.b	a5,a5
    80201268:	00078663          	beqz	a5,80201274 <print_dec_int+0x218>
    8020126c:	02d00793          	li	a5,45
    80201270:	01c0006f          	j	8020128c <print_dec_int+0x230>
    80201274:	f9043783          	ld	a5,-112(s0)
    80201278:	0057c783          	lbu	a5,5(a5)
    8020127c:	00078663          	beqz	a5,80201288 <print_dec_int+0x22c>
    80201280:	02b00793          	li	a5,43
    80201284:	0080006f          	j	8020128c <print_dec_int+0x230>
    80201288:	02000793          	li	a5,32
    8020128c:	fa843703          	ld	a4,-88(s0)
    80201290:	00078513          	mv	a0,a5
    80201294:	000700e7          	jalr	a4
        ++written;
    80201298:	fe442783          	lw	a5,-28(s0)
    8020129c:	0017879b          	addiw	a5,a5,1
    802012a0:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    802012a4:	fe842783          	lw	a5,-24(s0)
    802012a8:	fcf42e23          	sw	a5,-36(s0)
    802012ac:	0280006f          	j	802012d4 <print_dec_int+0x278>
        putch('0');
    802012b0:	fa843783          	ld	a5,-88(s0)
    802012b4:	03000513          	li	a0,48
    802012b8:	000780e7          	jalr	a5
        ++written;
    802012bc:	fe442783          	lw	a5,-28(s0)
    802012c0:	0017879b          	addiw	a5,a5,1
    802012c4:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    802012c8:	fdc42783          	lw	a5,-36(s0)
    802012cc:	0017879b          	addiw	a5,a5,1
    802012d0:	fcf42e23          	sw	a5,-36(s0)
    802012d4:	f9043783          	ld	a5,-112(s0)
    802012d8:	00c7a703          	lw	a4,12(a5)
    802012dc:	fd744783          	lbu	a5,-41(s0)
    802012e0:	0007879b          	sext.w	a5,a5
    802012e4:	40f707bb          	subw	a5,a4,a5
    802012e8:	0007871b          	sext.w	a4,a5
    802012ec:	fdc42783          	lw	a5,-36(s0)
    802012f0:	0007879b          	sext.w	a5,a5
    802012f4:	fae7cee3          	blt	a5,a4,802012b0 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    802012f8:	fe842783          	lw	a5,-24(s0)
    802012fc:	fff7879b          	addiw	a5,a5,-1
    80201300:	fcf42c23          	sw	a5,-40(s0)
    80201304:	03c0006f          	j	80201340 <print_dec_int+0x2e4>
        putch(buf[i]);
    80201308:	fd842783          	lw	a5,-40(s0)
    8020130c:	ff078793          	addi	a5,a5,-16
    80201310:	008787b3          	add	a5,a5,s0
    80201314:	fc87c783          	lbu	a5,-56(a5)
    80201318:	0007871b          	sext.w	a4,a5
    8020131c:	fa843783          	ld	a5,-88(s0)
    80201320:	00070513          	mv	a0,a4
    80201324:	000780e7          	jalr	a5
        ++written;
    80201328:	fe442783          	lw	a5,-28(s0)
    8020132c:	0017879b          	addiw	a5,a5,1
    80201330:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    80201334:	fd842783          	lw	a5,-40(s0)
    80201338:	fff7879b          	addiw	a5,a5,-1
    8020133c:	fcf42c23          	sw	a5,-40(s0)
    80201340:	fd842783          	lw	a5,-40(s0)
    80201344:	0007879b          	sext.w	a5,a5
    80201348:	fc07d0e3          	bgez	a5,80201308 <print_dec_int+0x2ac>
    }

    return written;
    8020134c:	fe442783          	lw	a5,-28(s0)
}
    80201350:	00078513          	mv	a0,a5
    80201354:	06813083          	ld	ra,104(sp)
    80201358:	06013403          	ld	s0,96(sp)
    8020135c:	07010113          	addi	sp,sp,112
    80201360:	00008067          	ret

0000000080201364 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    80201364:	f4010113          	addi	sp,sp,-192
    80201368:	0a113c23          	sd	ra,184(sp)
    8020136c:	0a813823          	sd	s0,176(sp)
    80201370:	0c010413          	addi	s0,sp,192
    80201374:	f4a43c23          	sd	a0,-168(s0)
    80201378:	f4b43823          	sd	a1,-176(s0)
    8020137c:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    80201380:	f8043023          	sd	zero,-128(s0)
    80201384:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    80201388:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    8020138c:	7a40006f          	j	80201b30 <vprintfmt+0x7cc>
        if (flags.in_format) {
    80201390:	f8044783          	lbu	a5,-128(s0)
    80201394:	72078e63          	beqz	a5,80201ad0 <vprintfmt+0x76c>
            if (*fmt == '#') {
    80201398:	f5043783          	ld	a5,-176(s0)
    8020139c:	0007c783          	lbu	a5,0(a5)
    802013a0:	00078713          	mv	a4,a5
    802013a4:	02300793          	li	a5,35
    802013a8:	00f71863          	bne	a4,a5,802013b8 <vprintfmt+0x54>
                flags.sharpflag = true;
    802013ac:	00100793          	li	a5,1
    802013b0:	f8f40123          	sb	a5,-126(s0)
    802013b4:	7700006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    802013b8:	f5043783          	ld	a5,-176(s0)
    802013bc:	0007c783          	lbu	a5,0(a5)
    802013c0:	00078713          	mv	a4,a5
    802013c4:	03000793          	li	a5,48
    802013c8:	00f71863          	bne	a4,a5,802013d8 <vprintfmt+0x74>
                flags.zeroflag = true;
    802013cc:	00100793          	li	a5,1
    802013d0:	f8f401a3          	sb	a5,-125(s0)
    802013d4:	7500006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    802013d8:	f5043783          	ld	a5,-176(s0)
    802013dc:	0007c783          	lbu	a5,0(a5)
    802013e0:	00078713          	mv	a4,a5
    802013e4:	06c00793          	li	a5,108
    802013e8:	04f70063          	beq	a4,a5,80201428 <vprintfmt+0xc4>
    802013ec:	f5043783          	ld	a5,-176(s0)
    802013f0:	0007c783          	lbu	a5,0(a5)
    802013f4:	00078713          	mv	a4,a5
    802013f8:	07a00793          	li	a5,122
    802013fc:	02f70663          	beq	a4,a5,80201428 <vprintfmt+0xc4>
    80201400:	f5043783          	ld	a5,-176(s0)
    80201404:	0007c783          	lbu	a5,0(a5)
    80201408:	00078713          	mv	a4,a5
    8020140c:	07400793          	li	a5,116
    80201410:	00f70c63          	beq	a4,a5,80201428 <vprintfmt+0xc4>
    80201414:	f5043783          	ld	a5,-176(s0)
    80201418:	0007c783          	lbu	a5,0(a5)
    8020141c:	00078713          	mv	a4,a5
    80201420:	06a00793          	li	a5,106
    80201424:	00f71863          	bne	a4,a5,80201434 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    80201428:	00100793          	li	a5,1
    8020142c:	f8f400a3          	sb	a5,-127(s0)
    80201430:	6f40006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    80201434:	f5043783          	ld	a5,-176(s0)
    80201438:	0007c783          	lbu	a5,0(a5)
    8020143c:	00078713          	mv	a4,a5
    80201440:	02b00793          	li	a5,43
    80201444:	00f71863          	bne	a4,a5,80201454 <vprintfmt+0xf0>
                flags.sign = true;
    80201448:	00100793          	li	a5,1
    8020144c:	f8f402a3          	sb	a5,-123(s0)
    80201450:	6d40006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    80201454:	f5043783          	ld	a5,-176(s0)
    80201458:	0007c783          	lbu	a5,0(a5)
    8020145c:	00078713          	mv	a4,a5
    80201460:	02000793          	li	a5,32
    80201464:	00f71863          	bne	a4,a5,80201474 <vprintfmt+0x110>
                flags.spaceflag = true;
    80201468:	00100793          	li	a5,1
    8020146c:	f8f40223          	sb	a5,-124(s0)
    80201470:	6b40006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    80201474:	f5043783          	ld	a5,-176(s0)
    80201478:	0007c783          	lbu	a5,0(a5)
    8020147c:	00078713          	mv	a4,a5
    80201480:	02a00793          	li	a5,42
    80201484:	00f71e63          	bne	a4,a5,802014a0 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    80201488:	f4843783          	ld	a5,-184(s0)
    8020148c:	00878713          	addi	a4,a5,8
    80201490:	f4e43423          	sd	a4,-184(s0)
    80201494:	0007a783          	lw	a5,0(a5)
    80201498:	f8f42423          	sw	a5,-120(s0)
    8020149c:	6880006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    802014a0:	f5043783          	ld	a5,-176(s0)
    802014a4:	0007c783          	lbu	a5,0(a5)
    802014a8:	00078713          	mv	a4,a5
    802014ac:	03000793          	li	a5,48
    802014b0:	04e7f663          	bgeu	a5,a4,802014fc <vprintfmt+0x198>
    802014b4:	f5043783          	ld	a5,-176(s0)
    802014b8:	0007c783          	lbu	a5,0(a5)
    802014bc:	00078713          	mv	a4,a5
    802014c0:	03900793          	li	a5,57
    802014c4:	02e7ec63          	bltu	a5,a4,802014fc <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    802014c8:	f5043783          	ld	a5,-176(s0)
    802014cc:	f5040713          	addi	a4,s0,-176
    802014d0:	00a00613          	li	a2,10
    802014d4:	00070593          	mv	a1,a4
    802014d8:	00078513          	mv	a0,a5
    802014dc:	88dff0ef          	jal	ra,80200d68 <strtol>
    802014e0:	00050793          	mv	a5,a0
    802014e4:	0007879b          	sext.w	a5,a5
    802014e8:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    802014ec:	f5043783          	ld	a5,-176(s0)
    802014f0:	fff78793          	addi	a5,a5,-1
    802014f4:	f4f43823          	sd	a5,-176(s0)
    802014f8:	62c0006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    802014fc:	f5043783          	ld	a5,-176(s0)
    80201500:	0007c783          	lbu	a5,0(a5)
    80201504:	00078713          	mv	a4,a5
    80201508:	02e00793          	li	a5,46
    8020150c:	06f71863          	bne	a4,a5,8020157c <vprintfmt+0x218>
                fmt++;
    80201510:	f5043783          	ld	a5,-176(s0)
    80201514:	00178793          	addi	a5,a5,1
    80201518:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    8020151c:	f5043783          	ld	a5,-176(s0)
    80201520:	0007c783          	lbu	a5,0(a5)
    80201524:	00078713          	mv	a4,a5
    80201528:	02a00793          	li	a5,42
    8020152c:	00f71e63          	bne	a4,a5,80201548 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    80201530:	f4843783          	ld	a5,-184(s0)
    80201534:	00878713          	addi	a4,a5,8
    80201538:	f4e43423          	sd	a4,-184(s0)
    8020153c:	0007a783          	lw	a5,0(a5)
    80201540:	f8f42623          	sw	a5,-116(s0)
    80201544:	5e00006f          	j	80201b24 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    80201548:	f5043783          	ld	a5,-176(s0)
    8020154c:	f5040713          	addi	a4,s0,-176
    80201550:	00a00613          	li	a2,10
    80201554:	00070593          	mv	a1,a4
    80201558:	00078513          	mv	a0,a5
    8020155c:	80dff0ef          	jal	ra,80200d68 <strtol>
    80201560:	00050793          	mv	a5,a0
    80201564:	0007879b          	sext.w	a5,a5
    80201568:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    8020156c:	f5043783          	ld	a5,-176(s0)
    80201570:	fff78793          	addi	a5,a5,-1
    80201574:	f4f43823          	sd	a5,-176(s0)
    80201578:	5ac0006f          	j	80201b24 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    8020157c:	f5043783          	ld	a5,-176(s0)
    80201580:	0007c783          	lbu	a5,0(a5)
    80201584:	00078713          	mv	a4,a5
    80201588:	07800793          	li	a5,120
    8020158c:	02f70663          	beq	a4,a5,802015b8 <vprintfmt+0x254>
    80201590:	f5043783          	ld	a5,-176(s0)
    80201594:	0007c783          	lbu	a5,0(a5)
    80201598:	00078713          	mv	a4,a5
    8020159c:	05800793          	li	a5,88
    802015a0:	00f70c63          	beq	a4,a5,802015b8 <vprintfmt+0x254>
    802015a4:	f5043783          	ld	a5,-176(s0)
    802015a8:	0007c783          	lbu	a5,0(a5)
    802015ac:	00078713          	mv	a4,a5
    802015b0:	07000793          	li	a5,112
    802015b4:	30f71263          	bne	a4,a5,802018b8 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    802015b8:	f5043783          	ld	a5,-176(s0)
    802015bc:	0007c783          	lbu	a5,0(a5)
    802015c0:	00078713          	mv	a4,a5
    802015c4:	07000793          	li	a5,112
    802015c8:	00f70663          	beq	a4,a5,802015d4 <vprintfmt+0x270>
    802015cc:	f8144783          	lbu	a5,-127(s0)
    802015d0:	00078663          	beqz	a5,802015dc <vprintfmt+0x278>
    802015d4:	00100793          	li	a5,1
    802015d8:	0080006f          	j	802015e0 <vprintfmt+0x27c>
    802015dc:	00000793          	li	a5,0
    802015e0:	faf403a3          	sb	a5,-89(s0)
    802015e4:	fa744783          	lbu	a5,-89(s0)
    802015e8:	0017f793          	andi	a5,a5,1
    802015ec:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    802015f0:	fa744783          	lbu	a5,-89(s0)
    802015f4:	0ff7f793          	zext.b	a5,a5
    802015f8:	00078c63          	beqz	a5,80201610 <vprintfmt+0x2ac>
    802015fc:	f4843783          	ld	a5,-184(s0)
    80201600:	00878713          	addi	a4,a5,8
    80201604:	f4e43423          	sd	a4,-184(s0)
    80201608:	0007b783          	ld	a5,0(a5)
    8020160c:	01c0006f          	j	80201628 <vprintfmt+0x2c4>
    80201610:	f4843783          	ld	a5,-184(s0)
    80201614:	00878713          	addi	a4,a5,8
    80201618:	f4e43423          	sd	a4,-184(s0)
    8020161c:	0007a783          	lw	a5,0(a5)
    80201620:	02079793          	slli	a5,a5,0x20
    80201624:	0207d793          	srli	a5,a5,0x20
    80201628:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    8020162c:	f8c42783          	lw	a5,-116(s0)
    80201630:	02079463          	bnez	a5,80201658 <vprintfmt+0x2f4>
    80201634:	fe043783          	ld	a5,-32(s0)
    80201638:	02079063          	bnez	a5,80201658 <vprintfmt+0x2f4>
    8020163c:	f5043783          	ld	a5,-176(s0)
    80201640:	0007c783          	lbu	a5,0(a5)
    80201644:	00078713          	mv	a4,a5
    80201648:	07000793          	li	a5,112
    8020164c:	00f70663          	beq	a4,a5,80201658 <vprintfmt+0x2f4>
                    flags.in_format = false;
    80201650:	f8040023          	sb	zero,-128(s0)
    80201654:	4d00006f          	j	80201b24 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    80201658:	f5043783          	ld	a5,-176(s0)
    8020165c:	0007c783          	lbu	a5,0(a5)
    80201660:	00078713          	mv	a4,a5
    80201664:	07000793          	li	a5,112
    80201668:	00f70a63          	beq	a4,a5,8020167c <vprintfmt+0x318>
    8020166c:	f8244783          	lbu	a5,-126(s0)
    80201670:	00078a63          	beqz	a5,80201684 <vprintfmt+0x320>
    80201674:	fe043783          	ld	a5,-32(s0)
    80201678:	00078663          	beqz	a5,80201684 <vprintfmt+0x320>
    8020167c:	00100793          	li	a5,1
    80201680:	0080006f          	j	80201688 <vprintfmt+0x324>
    80201684:	00000793          	li	a5,0
    80201688:	faf40323          	sb	a5,-90(s0)
    8020168c:	fa644783          	lbu	a5,-90(s0)
    80201690:	0017f793          	andi	a5,a5,1
    80201694:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    80201698:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    8020169c:	f5043783          	ld	a5,-176(s0)
    802016a0:	0007c783          	lbu	a5,0(a5)
    802016a4:	00078713          	mv	a4,a5
    802016a8:	05800793          	li	a5,88
    802016ac:	00f71863          	bne	a4,a5,802016bc <vprintfmt+0x358>
    802016b0:	00001797          	auipc	a5,0x1
    802016b4:	a8878793          	addi	a5,a5,-1400 # 80202138 <upperxdigits.1>
    802016b8:	00c0006f          	j	802016c4 <vprintfmt+0x360>
    802016bc:	00001797          	auipc	a5,0x1
    802016c0:	a9478793          	addi	a5,a5,-1388 # 80202150 <lowerxdigits.0>
    802016c4:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    802016c8:	fe043783          	ld	a5,-32(s0)
    802016cc:	00f7f793          	andi	a5,a5,15
    802016d0:	f9843703          	ld	a4,-104(s0)
    802016d4:	00f70733          	add	a4,a4,a5
    802016d8:	fdc42783          	lw	a5,-36(s0)
    802016dc:	0017869b          	addiw	a3,a5,1
    802016e0:	fcd42e23          	sw	a3,-36(s0)
    802016e4:	00074703          	lbu	a4,0(a4)
    802016e8:	ff078793          	addi	a5,a5,-16
    802016ec:	008787b3          	add	a5,a5,s0
    802016f0:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    802016f4:	fe043783          	ld	a5,-32(s0)
    802016f8:	0047d793          	srli	a5,a5,0x4
    802016fc:	fef43023          	sd	a5,-32(s0)
                } while (num);
    80201700:	fe043783          	ld	a5,-32(s0)
    80201704:	fc0792e3          	bnez	a5,802016c8 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    80201708:	f8c42783          	lw	a5,-116(s0)
    8020170c:	00078713          	mv	a4,a5
    80201710:	fff00793          	li	a5,-1
    80201714:	02f71663          	bne	a4,a5,80201740 <vprintfmt+0x3dc>
    80201718:	f8344783          	lbu	a5,-125(s0)
    8020171c:	02078263          	beqz	a5,80201740 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    80201720:	f8842703          	lw	a4,-120(s0)
    80201724:	fa644783          	lbu	a5,-90(s0)
    80201728:	0007879b          	sext.w	a5,a5
    8020172c:	0017979b          	slliw	a5,a5,0x1
    80201730:	0007879b          	sext.w	a5,a5
    80201734:	40f707bb          	subw	a5,a4,a5
    80201738:	0007879b          	sext.w	a5,a5
    8020173c:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201740:	f8842703          	lw	a4,-120(s0)
    80201744:	fa644783          	lbu	a5,-90(s0)
    80201748:	0007879b          	sext.w	a5,a5
    8020174c:	0017979b          	slliw	a5,a5,0x1
    80201750:	0007879b          	sext.w	a5,a5
    80201754:	40f707bb          	subw	a5,a4,a5
    80201758:	0007871b          	sext.w	a4,a5
    8020175c:	fdc42783          	lw	a5,-36(s0)
    80201760:	f8f42a23          	sw	a5,-108(s0)
    80201764:	f8c42783          	lw	a5,-116(s0)
    80201768:	f8f42823          	sw	a5,-112(s0)
    8020176c:	f9442783          	lw	a5,-108(s0)
    80201770:	00078593          	mv	a1,a5
    80201774:	f9042783          	lw	a5,-112(s0)
    80201778:	00078613          	mv	a2,a5
    8020177c:	0006069b          	sext.w	a3,a2
    80201780:	0005879b          	sext.w	a5,a1
    80201784:	00f6d463          	bge	a3,a5,8020178c <vprintfmt+0x428>
    80201788:	00058613          	mv	a2,a1
    8020178c:	0006079b          	sext.w	a5,a2
    80201790:	40f707bb          	subw	a5,a4,a5
    80201794:	fcf42c23          	sw	a5,-40(s0)
    80201798:	0280006f          	j	802017c0 <vprintfmt+0x45c>
                    putch(' ');
    8020179c:	f5843783          	ld	a5,-168(s0)
    802017a0:	02000513          	li	a0,32
    802017a4:	000780e7          	jalr	a5
                    ++written;
    802017a8:	fec42783          	lw	a5,-20(s0)
    802017ac:	0017879b          	addiw	a5,a5,1
    802017b0:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    802017b4:	fd842783          	lw	a5,-40(s0)
    802017b8:	fff7879b          	addiw	a5,a5,-1
    802017bc:	fcf42c23          	sw	a5,-40(s0)
    802017c0:	fd842783          	lw	a5,-40(s0)
    802017c4:	0007879b          	sext.w	a5,a5
    802017c8:	fcf04ae3          	bgtz	a5,8020179c <vprintfmt+0x438>
                }

                if (prefix) {
    802017cc:	fa644783          	lbu	a5,-90(s0)
    802017d0:	0ff7f793          	zext.b	a5,a5
    802017d4:	04078463          	beqz	a5,8020181c <vprintfmt+0x4b8>
                    putch('0');
    802017d8:	f5843783          	ld	a5,-168(s0)
    802017dc:	03000513          	li	a0,48
    802017e0:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    802017e4:	f5043783          	ld	a5,-176(s0)
    802017e8:	0007c783          	lbu	a5,0(a5)
    802017ec:	00078713          	mv	a4,a5
    802017f0:	05800793          	li	a5,88
    802017f4:	00f71663          	bne	a4,a5,80201800 <vprintfmt+0x49c>
    802017f8:	05800793          	li	a5,88
    802017fc:	0080006f          	j	80201804 <vprintfmt+0x4a0>
    80201800:	07800793          	li	a5,120
    80201804:	f5843703          	ld	a4,-168(s0)
    80201808:	00078513          	mv	a0,a5
    8020180c:	000700e7          	jalr	a4
                    written += 2;
    80201810:	fec42783          	lw	a5,-20(s0)
    80201814:	0027879b          	addiw	a5,a5,2
    80201818:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    8020181c:	fdc42783          	lw	a5,-36(s0)
    80201820:	fcf42a23          	sw	a5,-44(s0)
    80201824:	0280006f          	j	8020184c <vprintfmt+0x4e8>
                    putch('0');
    80201828:	f5843783          	ld	a5,-168(s0)
    8020182c:	03000513          	li	a0,48
    80201830:	000780e7          	jalr	a5
                    ++written;
    80201834:	fec42783          	lw	a5,-20(s0)
    80201838:	0017879b          	addiw	a5,a5,1
    8020183c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    80201840:	fd442783          	lw	a5,-44(s0)
    80201844:	0017879b          	addiw	a5,a5,1
    80201848:	fcf42a23          	sw	a5,-44(s0)
    8020184c:	f8c42703          	lw	a4,-116(s0)
    80201850:	fd442783          	lw	a5,-44(s0)
    80201854:	0007879b          	sext.w	a5,a5
    80201858:	fce7c8e3          	blt	a5,a4,80201828 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    8020185c:	fdc42783          	lw	a5,-36(s0)
    80201860:	fff7879b          	addiw	a5,a5,-1
    80201864:	fcf42823          	sw	a5,-48(s0)
    80201868:	03c0006f          	j	802018a4 <vprintfmt+0x540>
                    putch(buf[i]);
    8020186c:	fd042783          	lw	a5,-48(s0)
    80201870:	ff078793          	addi	a5,a5,-16
    80201874:	008787b3          	add	a5,a5,s0
    80201878:	f807c783          	lbu	a5,-128(a5)
    8020187c:	0007871b          	sext.w	a4,a5
    80201880:	f5843783          	ld	a5,-168(s0)
    80201884:	00070513          	mv	a0,a4
    80201888:	000780e7          	jalr	a5
                    ++written;
    8020188c:	fec42783          	lw	a5,-20(s0)
    80201890:	0017879b          	addiw	a5,a5,1
    80201894:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    80201898:	fd042783          	lw	a5,-48(s0)
    8020189c:	fff7879b          	addiw	a5,a5,-1
    802018a0:	fcf42823          	sw	a5,-48(s0)
    802018a4:	fd042783          	lw	a5,-48(s0)
    802018a8:	0007879b          	sext.w	a5,a5
    802018ac:	fc07d0e3          	bgez	a5,8020186c <vprintfmt+0x508>
                }

                flags.in_format = false;
    802018b0:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    802018b4:	2700006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    802018b8:	f5043783          	ld	a5,-176(s0)
    802018bc:	0007c783          	lbu	a5,0(a5)
    802018c0:	00078713          	mv	a4,a5
    802018c4:	06400793          	li	a5,100
    802018c8:	02f70663          	beq	a4,a5,802018f4 <vprintfmt+0x590>
    802018cc:	f5043783          	ld	a5,-176(s0)
    802018d0:	0007c783          	lbu	a5,0(a5)
    802018d4:	00078713          	mv	a4,a5
    802018d8:	06900793          	li	a5,105
    802018dc:	00f70c63          	beq	a4,a5,802018f4 <vprintfmt+0x590>
    802018e0:	f5043783          	ld	a5,-176(s0)
    802018e4:	0007c783          	lbu	a5,0(a5)
    802018e8:	00078713          	mv	a4,a5
    802018ec:	07500793          	li	a5,117
    802018f0:	08f71063          	bne	a4,a5,80201970 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    802018f4:	f8144783          	lbu	a5,-127(s0)
    802018f8:	00078c63          	beqz	a5,80201910 <vprintfmt+0x5ac>
    802018fc:	f4843783          	ld	a5,-184(s0)
    80201900:	00878713          	addi	a4,a5,8
    80201904:	f4e43423          	sd	a4,-184(s0)
    80201908:	0007b783          	ld	a5,0(a5)
    8020190c:	0140006f          	j	80201920 <vprintfmt+0x5bc>
    80201910:	f4843783          	ld	a5,-184(s0)
    80201914:	00878713          	addi	a4,a5,8
    80201918:	f4e43423          	sd	a4,-184(s0)
    8020191c:	0007a783          	lw	a5,0(a5)
    80201920:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    80201924:	fa843583          	ld	a1,-88(s0)
    80201928:	f5043783          	ld	a5,-176(s0)
    8020192c:	0007c783          	lbu	a5,0(a5)
    80201930:	0007871b          	sext.w	a4,a5
    80201934:	07500793          	li	a5,117
    80201938:	40f707b3          	sub	a5,a4,a5
    8020193c:	00f037b3          	snez	a5,a5
    80201940:	0ff7f793          	zext.b	a5,a5
    80201944:	f8040713          	addi	a4,s0,-128
    80201948:	00070693          	mv	a3,a4
    8020194c:	00078613          	mv	a2,a5
    80201950:	f5843503          	ld	a0,-168(s0)
    80201954:	f08ff0ef          	jal	ra,8020105c <print_dec_int>
    80201958:	00050793          	mv	a5,a0
    8020195c:	fec42703          	lw	a4,-20(s0)
    80201960:	00f707bb          	addw	a5,a4,a5
    80201964:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201968:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    8020196c:	1b80006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    80201970:	f5043783          	ld	a5,-176(s0)
    80201974:	0007c783          	lbu	a5,0(a5)
    80201978:	00078713          	mv	a4,a5
    8020197c:	06e00793          	li	a5,110
    80201980:	04f71c63          	bne	a4,a5,802019d8 <vprintfmt+0x674>
                if (flags.longflag) {
    80201984:	f8144783          	lbu	a5,-127(s0)
    80201988:	02078463          	beqz	a5,802019b0 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    8020198c:	f4843783          	ld	a5,-184(s0)
    80201990:	00878713          	addi	a4,a5,8
    80201994:	f4e43423          	sd	a4,-184(s0)
    80201998:	0007b783          	ld	a5,0(a5)
    8020199c:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    802019a0:	fec42703          	lw	a4,-20(s0)
    802019a4:	fb043783          	ld	a5,-80(s0)
    802019a8:	00e7b023          	sd	a4,0(a5)
    802019ac:	0240006f          	j	802019d0 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    802019b0:	f4843783          	ld	a5,-184(s0)
    802019b4:	00878713          	addi	a4,a5,8
    802019b8:	f4e43423          	sd	a4,-184(s0)
    802019bc:	0007b783          	ld	a5,0(a5)
    802019c0:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    802019c4:	fb843783          	ld	a5,-72(s0)
    802019c8:	fec42703          	lw	a4,-20(s0)
    802019cc:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    802019d0:	f8040023          	sb	zero,-128(s0)
    802019d4:	1500006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    802019d8:	f5043783          	ld	a5,-176(s0)
    802019dc:	0007c783          	lbu	a5,0(a5)
    802019e0:	00078713          	mv	a4,a5
    802019e4:	07300793          	li	a5,115
    802019e8:	02f71e63          	bne	a4,a5,80201a24 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    802019ec:	f4843783          	ld	a5,-184(s0)
    802019f0:	00878713          	addi	a4,a5,8
    802019f4:	f4e43423          	sd	a4,-184(s0)
    802019f8:	0007b783          	ld	a5,0(a5)
    802019fc:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    80201a00:	fc043583          	ld	a1,-64(s0)
    80201a04:	f5843503          	ld	a0,-168(s0)
    80201a08:	dccff0ef          	jal	ra,80200fd4 <puts_wo_nl>
    80201a0c:	00050793          	mv	a5,a0
    80201a10:	fec42703          	lw	a4,-20(s0)
    80201a14:	00f707bb          	addw	a5,a4,a5
    80201a18:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201a1c:	f8040023          	sb	zero,-128(s0)
    80201a20:	1040006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    80201a24:	f5043783          	ld	a5,-176(s0)
    80201a28:	0007c783          	lbu	a5,0(a5)
    80201a2c:	00078713          	mv	a4,a5
    80201a30:	06300793          	li	a5,99
    80201a34:	02f71e63          	bne	a4,a5,80201a70 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    80201a38:	f4843783          	ld	a5,-184(s0)
    80201a3c:	00878713          	addi	a4,a5,8
    80201a40:	f4e43423          	sd	a4,-184(s0)
    80201a44:	0007a783          	lw	a5,0(a5)
    80201a48:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    80201a4c:	fcc42703          	lw	a4,-52(s0)
    80201a50:	f5843783          	ld	a5,-168(s0)
    80201a54:	00070513          	mv	a0,a4
    80201a58:	000780e7          	jalr	a5
                ++written;
    80201a5c:	fec42783          	lw	a5,-20(s0)
    80201a60:	0017879b          	addiw	a5,a5,1
    80201a64:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201a68:	f8040023          	sb	zero,-128(s0)
    80201a6c:	0b80006f          	j	80201b24 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    80201a70:	f5043783          	ld	a5,-176(s0)
    80201a74:	0007c783          	lbu	a5,0(a5)
    80201a78:	00078713          	mv	a4,a5
    80201a7c:	02500793          	li	a5,37
    80201a80:	02f71263          	bne	a4,a5,80201aa4 <vprintfmt+0x740>
                putch('%');
    80201a84:	f5843783          	ld	a5,-168(s0)
    80201a88:	02500513          	li	a0,37
    80201a8c:	000780e7          	jalr	a5
                ++written;
    80201a90:	fec42783          	lw	a5,-20(s0)
    80201a94:	0017879b          	addiw	a5,a5,1
    80201a98:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201a9c:	f8040023          	sb	zero,-128(s0)
    80201aa0:	0840006f          	j	80201b24 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    80201aa4:	f5043783          	ld	a5,-176(s0)
    80201aa8:	0007c783          	lbu	a5,0(a5)
    80201aac:	0007871b          	sext.w	a4,a5
    80201ab0:	f5843783          	ld	a5,-168(s0)
    80201ab4:	00070513          	mv	a0,a4
    80201ab8:	000780e7          	jalr	a5
                ++written;
    80201abc:	fec42783          	lw	a5,-20(s0)
    80201ac0:	0017879b          	addiw	a5,a5,1
    80201ac4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201ac8:	f8040023          	sb	zero,-128(s0)
    80201acc:	0580006f          	j	80201b24 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    80201ad0:	f5043783          	ld	a5,-176(s0)
    80201ad4:	0007c783          	lbu	a5,0(a5)
    80201ad8:	00078713          	mv	a4,a5
    80201adc:	02500793          	li	a5,37
    80201ae0:	02f71063          	bne	a4,a5,80201b00 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    80201ae4:	f8043023          	sd	zero,-128(s0)
    80201ae8:	f8043423          	sd	zero,-120(s0)
    80201aec:	00100793          	li	a5,1
    80201af0:	f8f40023          	sb	a5,-128(s0)
    80201af4:	fff00793          	li	a5,-1
    80201af8:	f8f42623          	sw	a5,-116(s0)
    80201afc:	0280006f          	j	80201b24 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    80201b00:	f5043783          	ld	a5,-176(s0)
    80201b04:	0007c783          	lbu	a5,0(a5)
    80201b08:	0007871b          	sext.w	a4,a5
    80201b0c:	f5843783          	ld	a5,-168(s0)
    80201b10:	00070513          	mv	a0,a4
    80201b14:	000780e7          	jalr	a5
            ++written;
    80201b18:	fec42783          	lw	a5,-20(s0)
    80201b1c:	0017879b          	addiw	a5,a5,1
    80201b20:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    80201b24:	f5043783          	ld	a5,-176(s0)
    80201b28:	00178793          	addi	a5,a5,1
    80201b2c:	f4f43823          	sd	a5,-176(s0)
    80201b30:	f5043783          	ld	a5,-176(s0)
    80201b34:	0007c783          	lbu	a5,0(a5)
    80201b38:	84079ce3          	bnez	a5,80201390 <vprintfmt+0x2c>
        }
    }

    return written;
    80201b3c:	fec42783          	lw	a5,-20(s0)
}
    80201b40:	00078513          	mv	a0,a5
    80201b44:	0b813083          	ld	ra,184(sp)
    80201b48:	0b013403          	ld	s0,176(sp)
    80201b4c:	0c010113          	addi	sp,sp,192
    80201b50:	00008067          	ret

0000000080201b54 <printk>:

int printk(const char* s, ...) {
    80201b54:	f9010113          	addi	sp,sp,-112
    80201b58:	02113423          	sd	ra,40(sp)
    80201b5c:	02813023          	sd	s0,32(sp)
    80201b60:	03010413          	addi	s0,sp,48
    80201b64:	fca43c23          	sd	a0,-40(s0)
    80201b68:	00b43423          	sd	a1,8(s0)
    80201b6c:	00c43823          	sd	a2,16(s0)
    80201b70:	00d43c23          	sd	a3,24(s0)
    80201b74:	02e43023          	sd	a4,32(s0)
    80201b78:	02f43423          	sd	a5,40(s0)
    80201b7c:	03043823          	sd	a6,48(s0)
    80201b80:	03143c23          	sd	a7,56(s0)
    int res = 0;
    80201b84:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    80201b88:	04040793          	addi	a5,s0,64
    80201b8c:	fcf43823          	sd	a5,-48(s0)
    80201b90:	fd043783          	ld	a5,-48(s0)
    80201b94:	fc878793          	addi	a5,a5,-56
    80201b98:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    80201b9c:	fe043783          	ld	a5,-32(s0)
    80201ba0:	00078613          	mv	a2,a5
    80201ba4:	fd843583          	ld	a1,-40(s0)
    80201ba8:	fffff517          	auipc	a0,0xfffff
    80201bac:	11850513          	addi	a0,a0,280 # 80200cc0 <putc>
    80201bb0:	fb4ff0ef          	jal	ra,80201364 <vprintfmt>
    80201bb4:	00050793          	mv	a5,a0
    80201bb8:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    80201bbc:	fec42783          	lw	a5,-20(s0)
}
    80201bc0:	00078513          	mv	a0,a5
    80201bc4:	02813083          	ld	ra,40(sp)
    80201bc8:	02013403          	ld	s0,32(sp)
    80201bcc:	07010113          	addi	sp,sp,112
    80201bd0:	00008067          	ret

0000000080201bd4 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
    80201bd4:	fe010113          	addi	sp,sp,-32
    80201bd8:	00813c23          	sd	s0,24(sp)
    80201bdc:	02010413          	addi	s0,sp,32
    80201be0:	00050793          	mv	a5,a0
    80201be4:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
    80201be8:	fec42783          	lw	a5,-20(s0)
    80201bec:	fff7879b          	addiw	a5,a5,-1
    80201bf0:	0007879b          	sext.w	a5,a5
    80201bf4:	02079713          	slli	a4,a5,0x20
    80201bf8:	02075713          	srli	a4,a4,0x20
    80201bfc:	00003797          	auipc	a5,0x3
    80201c00:	51c78793          	addi	a5,a5,1308 # 80205118 <seed>
    80201c04:	00e7b023          	sd	a4,0(a5)
}
    80201c08:	00000013          	nop
    80201c0c:	01813403          	ld	s0,24(sp)
    80201c10:	02010113          	addi	sp,sp,32
    80201c14:	00008067          	ret

0000000080201c18 <rand>:

int rand(void) {
    80201c18:	ff010113          	addi	sp,sp,-16
    80201c1c:	00813423          	sd	s0,8(sp)
    80201c20:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
    80201c24:	00003797          	auipc	a5,0x3
    80201c28:	4f478793          	addi	a5,a5,1268 # 80205118 <seed>
    80201c2c:	0007b703          	ld	a4,0(a5)
    80201c30:	00000797          	auipc	a5,0x0
    80201c34:	53878793          	addi	a5,a5,1336 # 80202168 <lowerxdigits.0+0x18>
    80201c38:	0007b783          	ld	a5,0(a5)
    80201c3c:	02f707b3          	mul	a5,a4,a5
    80201c40:	00178713          	addi	a4,a5,1
    80201c44:	00003797          	auipc	a5,0x3
    80201c48:	4d478793          	addi	a5,a5,1236 # 80205118 <seed>
    80201c4c:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
    80201c50:	00003797          	auipc	a5,0x3
    80201c54:	4c878793          	addi	a5,a5,1224 # 80205118 <seed>
    80201c58:	0007b783          	ld	a5,0(a5)
    80201c5c:	0217d793          	srli	a5,a5,0x21
    80201c60:	0007879b          	sext.w	a5,a5
}
    80201c64:	00078513          	mv	a0,a5
    80201c68:	00813403          	ld	s0,8(sp)
    80201c6c:	01010113          	addi	sp,sp,16
    80201c70:	00008067          	ret

0000000080201c74 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
    80201c74:	fc010113          	addi	sp,sp,-64
    80201c78:	02813c23          	sd	s0,56(sp)
    80201c7c:	04010413          	addi	s0,sp,64
    80201c80:	fca43c23          	sd	a0,-40(s0)
    80201c84:	00058793          	mv	a5,a1
    80201c88:	fcc43423          	sd	a2,-56(s0)
    80201c8c:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
    80201c90:	fd843783          	ld	a5,-40(s0)
    80201c94:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
    80201c98:	fe043423          	sd	zero,-24(s0)
    80201c9c:	0280006f          	j	80201cc4 <memset+0x50>
        s[i] = c;
    80201ca0:	fe043703          	ld	a4,-32(s0)
    80201ca4:	fe843783          	ld	a5,-24(s0)
    80201ca8:	00f707b3          	add	a5,a4,a5
    80201cac:	fd442703          	lw	a4,-44(s0)
    80201cb0:	0ff77713          	zext.b	a4,a4
    80201cb4:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
    80201cb8:	fe843783          	ld	a5,-24(s0)
    80201cbc:	00178793          	addi	a5,a5,1
    80201cc0:	fef43423          	sd	a5,-24(s0)
    80201cc4:	fe843703          	ld	a4,-24(s0)
    80201cc8:	fc843783          	ld	a5,-56(s0)
    80201ccc:	fcf76ae3          	bltu	a4,a5,80201ca0 <memset+0x2c>
    }
    return dest;
    80201cd0:	fd843783          	ld	a5,-40(s0)
}
    80201cd4:	00078513          	mv	a0,a5
    80201cd8:	03813403          	ld	s0,56(sp)
    80201cdc:	04010113          	addi	sp,sp,64
    80201ce0:	00008067          	ret
