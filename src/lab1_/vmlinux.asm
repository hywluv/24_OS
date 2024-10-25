
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    #implement
    la sp, boot_stack_top # initialize stack
    80200000:	00003117          	auipc	sp,0x3
    80200004:	01013103          	ld	sp,16(sp) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>

    la t0, _traps # load traps
    80200008:	00003297          	auipc	t0,0x3
    8020000c:	0102b283          	ld	t0,16(t0) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    csrw stvec, t0 # set traps
    80200010:	10529073          	csrw	stvec,t0

    li t0, (1 << 5) # enable interrupts
    80200014:	02000293          	li	t0,32
    csrs sie, t0
    80200018:	1042a073          	csrs	sie,t0

    li t1, 10000000
    8020001c:	00989337          	lui	t1,0x989
    80200020:	6803031b          	addiw	t1,t1,1664 # 989680 <_skernel-0x7f876980>
    rdtime t0
    80200024:	c01022f3          	rdtime	t0
    add t0, t0, t1
    80200028:	006282b3          	add	t0,t0,t1
    mv a0, t0 # set time to 1s
    8020002c:	00028513          	mv	a0,t0
    li a7, 0 # set eid to 0
    80200030:	00000893          	li	a7,0
    ecall # call sbi_set_timer
    80200034:	00000073          	ecall

    li t0, (1 << 1)
    80200038:	00200293          	li	t0,2
    csrs sstatus, t0 # enable global interrupt
    8020003c:	1002a073          	csrs	sstatus,t0

    call start_kernel # jump to start_kernel
    80200040:	430000ef          	jal	ra,80200470 <start_kernel>
    j _start # loop
    80200044:	fbdff06f          	j	80200000 <_skernel>

0000000080200048 <_traps>:
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap

    addi sp, sp, -33*8
    80200048:	ef810113          	addi	sp,sp,-264
    sd ra, 0*8(sp)
    8020004c:	00113023          	sd	ra,0(sp)
    sd t0, 1*8(sp)
    80200050:	00513423          	sd	t0,8(sp)
    sd t1, 2*8(sp)
    80200054:	00613823          	sd	t1,16(sp)
    sd t2, 3*8(sp)
    80200058:	00713c23          	sd	t2,24(sp)
    sd t3, 4*8(sp)
    8020005c:	03c13023          	sd	t3,32(sp)
    sd t4, 5*8(sp)
    80200060:	03d13423          	sd	t4,40(sp)
    sd t5, 6*8(sp)
    80200064:	03e13823          	sd	t5,48(sp)
    sd t6, 7*8(sp)
    80200068:	03f13c23          	sd	t6,56(sp)
    sd a0, 8*8(sp)
    8020006c:	04a13023          	sd	a0,64(sp)
    sd a1, 9*8(sp)
    80200070:	04b13423          	sd	a1,72(sp)
    sd a2, 10*8(sp)
    80200074:	04c13823          	sd	a2,80(sp)
    sd a3, 11*8(sp)
    80200078:	04d13c23          	sd	a3,88(sp)
    sd a4, 12*8(sp)
    8020007c:	06e13023          	sd	a4,96(sp)
    sd a5, 13*8(sp)
    80200080:	06f13423          	sd	a5,104(sp)
    sd a6, 14*8(sp)
    80200084:	07013823          	sd	a6,112(sp)
    sd a7, 15*8(sp)
    80200088:	07113c23          	sd	a7,120(sp)
    sd s0, 16*8(sp)
    8020008c:	08813023          	sd	s0,128(sp)
    sd s1, 17*8(sp)
    80200090:	08913423          	sd	s1,136(sp)
    sd s2, 18*8(sp)
    80200094:	09213823          	sd	s2,144(sp)
    sd s3, 19*8(sp)
    80200098:	09313c23          	sd	s3,152(sp)
    sd s4, 20*8(sp)
    8020009c:	0b413023          	sd	s4,160(sp)
    sd s5, 21*8(sp)
    802000a0:	0b513423          	sd	s5,168(sp)
    sd s6, 22*8(sp)
    802000a4:	0b613823          	sd	s6,176(sp)
    sd s7, 23*8(sp)
    802000a8:	0b713c23          	sd	s7,184(sp)
    sd s8, 24*8(sp)
    802000ac:	0d813023          	sd	s8,192(sp)
    sd s9, 25*8(sp)
    802000b0:	0d913423          	sd	s9,200(sp)
    sd s10, 26*8(sp)
    802000b4:	0da13823          	sd	s10,208(sp)
    sd s11, 27*8(sp)
    802000b8:	0db13c23          	sd	s11,216(sp)
    sd gp, 28*8(sp)
    802000bc:	0e313023          	sd	gp,224(sp)
    sd tp, 29*8(sp)
    802000c0:	0e413423          	sd	tp,232(sp)
    csrr t0, sepc
    802000c4:	141022f3          	csrr	t0,sepc
    sd t0, 30*8(sp)
    802000c8:	0e513823          	sd	t0,240(sp)
    sd sp, 31*8(sp)
    802000cc:	0e213c23          	sd	sp,248(sp)

    csrr a0, scause
    802000d0:	14202573          	csrr	a0,scause
    csrr a1, sepc
    802000d4:	141025f3          	csrr	a1,sepc
    call trap_handler
    802000d8:	2f0000ef          	jal	ra,802003c8 <trap_handler>

    ld sp, 31*8(sp)
    802000dc:	0f813103          	ld	sp,248(sp)
    ld t0, 30*8(sp)
    802000e0:	0f013283          	ld	t0,240(sp)
    csrw sepc, t0
    802000e4:	14129073          	csrw	sepc,t0
    ld ra, 0*8(sp)
    802000e8:	00013083          	ld	ra,0(sp)
    ld t0, 1*8(sp)
    802000ec:	00813283          	ld	t0,8(sp)
    ld t1, 2*8(sp)
    802000f0:	01013303          	ld	t1,16(sp)
    ld t2, 3*8(sp)
    802000f4:	01813383          	ld	t2,24(sp)
    ld t3, 4*8(sp)
    802000f8:	02013e03          	ld	t3,32(sp)
    ld t4, 5*8(sp)
    802000fc:	02813e83          	ld	t4,40(sp)
    ld t5, 6*8(sp)
    80200100:	03013f03          	ld	t5,48(sp)
    ld t6, 7*8(sp)
    80200104:	03813f83          	ld	t6,56(sp)
    ld a0, 8*8(sp)
    80200108:	04013503          	ld	a0,64(sp)
    ld a1, 9*8(sp)
    8020010c:	04813583          	ld	a1,72(sp)
    ld a2, 10*8(sp)
    80200110:	05013603          	ld	a2,80(sp)
    ld a3, 11*8(sp)
    80200114:	05813683          	ld	a3,88(sp)
    ld a4, 12*8(sp)
    80200118:	06013703          	ld	a4,96(sp)
    ld a5, 13*8(sp)
    8020011c:	06813783          	ld	a5,104(sp)
    ld a6, 14*8(sp)
    80200120:	07013803          	ld	a6,112(sp)
    ld a7, 15*8(sp)
    80200124:	07813883          	ld	a7,120(sp)
    ld s0, 16*8(sp)
    80200128:	08013403          	ld	s0,128(sp)
    ld s1, 17*8(sp)
    8020012c:	08813483          	ld	s1,136(sp)
    ld s2, 18*8(sp)
    80200130:	09013903          	ld	s2,144(sp)
    ld s3, 19*8(sp)
    80200134:	09813983          	ld	s3,152(sp)
    ld s4, 20*8(sp)
    80200138:	0a013a03          	ld	s4,160(sp)
    ld s5, 21*8(sp)
    8020013c:	0a813a83          	ld	s5,168(sp)
    ld s6, 22*8(sp)
    80200140:	0b013b03          	ld	s6,176(sp)
    ld s7, 23*8(sp)
    80200144:	0b813b83          	ld	s7,184(sp)
    ld s8, 24*8(sp)
    80200148:	0c013c03          	ld	s8,192(sp)
    ld s9, 25*8(sp)
    8020014c:	0c813c83          	ld	s9,200(sp)
    ld s10, 26*8(sp)
    80200150:	0d013d03          	ld	s10,208(sp)
    ld s11, 27*8(sp)
    80200154:	0d813d83          	ld	s11,216(sp)
    ld gp, 28*8(sp)
    80200158:	0e013183          	ld	gp,224(sp)
    ld tp, 29*8(sp)
    8020015c:	0e813203          	ld	tp,232(sp)
    addi sp, sp, 33*8
    80200160:	10810113          	addi	sp,sp,264

    sret
    80200164:	10200073          	sret

0000000080200168 <get_cycles>:
#include "stdint.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    80200168:	fe010113          	addi	sp,sp,-32
    8020016c:	00813c23          	sd	s0,24(sp)
    80200170:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
    80200174:	c01027f3          	rdtime	a5
    80200178:	fef43423          	sd	a5,-24(s0)
    return cycles;
    8020017c:	fe843783          	ld	a5,-24(s0)
}
    80200180:	00078513          	mv	a0,a5
    80200184:	01813403          	ld	s0,24(sp)
    80200188:	02010113          	addi	sp,sp,32
    8020018c:	00008067          	ret

0000000080200190 <sbi_set_timer>:

static inline void sbi_set_timer(uint64_t stime_value) {
    80200190:	fe010113          	addi	sp,sp,-32
    80200194:	00813c23          	sd	s0,24(sp)
    80200198:	02010413          	addi	s0,sp,32
    8020019c:	fea43423          	sd	a0,-24(s0)
    register uint64_t a0 asm("a0") = stime_value;
    802001a0:	fe843503          	ld	a0,-24(s0)
    register uint64_t a7 asm("a7") = 0x0;
    802001a4:	00000893          	li	a7,0
    asm volatile("ecall" : : "r"(a0), "r"(a7) : "memory");
    802001a8:	00000073          	ecall
}
    802001ac:	00000013          	nop
    802001b0:	01813403          	ld	s0,24(sp)
    802001b4:	02010113          	addi	sp,sp,32
    802001b8:	00008067          	ret

00000000802001bc <clock_set_next_event>:

void clock_set_next_event() {
    802001bc:	fe010113          	addi	sp,sp,-32
    802001c0:	00113c23          	sd	ra,24(sp)
    802001c4:	00813823          	sd	s0,16(sp)
    802001c8:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    802001cc:	f9dff0ef          	jal	ra,80200168 <get_cycles>
    802001d0:	00050713          	mv	a4,a0
    802001d4:	00003797          	auipc	a5,0x3
    802001d8:	e2c78793          	addi	a5,a5,-468 # 80203000 <TIMECLOCK>
    802001dc:	0007b783          	ld	a5,0(a5)
    802001e0:	00f707b3          	add	a5,a4,a5
    802001e4:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
    802001e8:	fe843503          	ld	a0,-24(s0)
    802001ec:	fa5ff0ef          	jal	ra,80200190 <sbi_set_timer>
    802001f0:	00000013          	nop
    802001f4:	01813083          	ld	ra,24(sp)
    802001f8:	01013403          	ld	s0,16(sp)
    802001fc:	02010113          	addi	sp,sp,32
    80200200:	00008067          	ret

0000000080200204 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    80200204:	f8010113          	addi	sp,sp,-128
    80200208:	06813c23          	sd	s0,120(sp)
    8020020c:	06913823          	sd	s1,112(sp)
    80200210:	07213423          	sd	s2,104(sp)
    80200214:	07313023          	sd	s3,96(sp)
    80200218:	08010413          	addi	s0,sp,128
    8020021c:	faa43c23          	sd	a0,-72(s0)
    80200220:	fab43823          	sd	a1,-80(s0)
    80200224:	fac43423          	sd	a2,-88(s0)
    80200228:	fad43023          	sd	a3,-96(s0)
    8020022c:	f8e43c23          	sd	a4,-104(s0)
    80200230:	f8f43823          	sd	a5,-112(s0)
    80200234:	f9043423          	sd	a6,-120(s0)
    80200238:	f9143023          	sd	a7,-128(s0)

    struct sbiret ret;
    asm volatile(
    8020023c:	fb843e03          	ld	t3,-72(s0)
    80200240:	fb043e83          	ld	t4,-80(s0)
    80200244:	fa843f03          	ld	t5,-88(s0)
    80200248:	fa043f83          	ld	t6,-96(s0)
    8020024c:	f9843283          	ld	t0,-104(s0)
    80200250:	f9043483          	ld	s1,-112(s0)
    80200254:	f8843903          	ld	s2,-120(s0)
    80200258:	f8043983          	ld	s3,-128(s0)
    8020025c:	000e0893          	mv	a7,t3
    80200260:	000e8813          	mv	a6,t4
    80200264:	000f0513          	mv	a0,t5
    80200268:	000f8593          	mv	a1,t6
    8020026c:	00028613          	mv	a2,t0
    80200270:	00048693          	mv	a3,s1
    80200274:	00090713          	mv	a4,s2
    80200278:	00098793          	mv	a5,s3
    8020027c:	00000073          	ecall
    80200280:	00050e93          	mv	t4,a0
    80200284:	00058e13          	mv	t3,a1
    80200288:	fdd43023          	sd	t4,-64(s0)
    8020028c:	fdc43423          	sd	t3,-56(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return ret;
    80200290:	fc043783          	ld	a5,-64(s0)
    80200294:	fcf43823          	sd	a5,-48(s0)
    80200298:	fc843783          	ld	a5,-56(s0)
    8020029c:	fcf43c23          	sd	a5,-40(s0)
    802002a0:	fd043703          	ld	a4,-48(s0)
    802002a4:	fd843783          	ld	a5,-40(s0)
    802002a8:	00070313          	mv	t1,a4
    802002ac:	00078393          	mv	t2,a5
    802002b0:	00030713          	mv	a4,t1
    802002b4:	00038793          	mv	a5,t2
}
    802002b8:	00070513          	mv	a0,a4
    802002bc:	00078593          	mv	a1,a5
    802002c0:	07813403          	ld	s0,120(sp)
    802002c4:	07013483          	ld	s1,112(sp)
    802002c8:	06813903          	ld	s2,104(sp)
    802002cc:	06013983          	ld	s3,96(sp)
    802002d0:	08010113          	addi	sp,sp,128
    802002d4:	00008067          	ret

00000000802002d8 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    802002d8:	fd010113          	addi	sp,sp,-48
    802002dc:	02813423          	sd	s0,40(sp)
    802002e0:	03010413          	addi	s0,sp,48
    802002e4:	00050793          	mv	a5,a0
    802002e8:	fcf40fa3          	sb	a5,-33(s0)
    struct sbiret ret;
    asm volatile(
    802002ec:	00100793          	li	a5,1
    802002f0:	00000713          	li	a4,0
    802002f4:	fdf44683          	lbu	a3,-33(s0)
    802002f8:	00078893          	mv	a7,a5
    802002fc:	00070813          	mv	a6,a4
    80200300:	00068513          	mv	a0,a3
    80200304:	00000073          	ecall
    80200308:	00050713          	mv	a4,a0
    8020030c:	00058793          	mv	a5,a1
    80200310:	fee43023          	sd	a4,-32(s0)
    80200314:	fef43423          	sd	a5,-24(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x01), [fid] "r"(0), [byte] "r"(byte)
        : "memory", "a0", "a1", "a6", "a7"
    );
}
    80200318:	00000013          	nop
    8020031c:	00070513          	mv	a0,a4
    80200320:	00078593          	mv	a1,a5
    80200324:	02813403          	ld	s0,40(sp)
    80200328:	03010113          	addi	sp,sp,48
    8020032c:	00008067          	ret

0000000080200330 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200330:	fc010113          	addi	sp,sp,-64
    80200334:	02813c23          	sd	s0,56(sp)
    80200338:	04010413          	addi	s0,sp,64
    8020033c:	00050793          	mv	a5,a0
    80200340:	00058713          	mv	a4,a1
    80200344:	fcf42623          	sw	a5,-52(s0)
    80200348:	00070793          	mv	a5,a4
    8020034c:	fcf42423          	sw	a5,-56(s0)
    struct sbiret ret;
    asm volatile(
    80200350:	00800793          	li	a5,8
    80200354:	00000713          	li	a4,0
    80200358:	fcc42583          	lw	a1,-52(s0)
    8020035c:	00058313          	mv	t1,a1
    80200360:	fc842583          	lw	a1,-56(s0)
    80200364:	00058e13          	mv	t3,a1
    80200368:	00078893          	mv	a7,a5
    8020036c:	00070813          	mv	a6,a4
    80200370:	00030513          	mv	a0,t1
    80200374:	000e0593          	mv	a1,t3
    80200378:	00000073          	ecall
    8020037c:	00050713          	mv	a4,a0
    80200380:	00058793          	mv	a5,a1
    80200384:	fce43823          	sd	a4,-48(s0)
    80200388:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1\n"
        : [error] "=r"(ret.error), [value] "=r"(ret.value)
        : [eid] "r"(0x08), [fid] "r"(0), [reset_type] "r"(reset_type), [reset_reason] "r"(reset_reason)
        : "memory", "a0", "a1", "a6", "a7"
    );
    return ret;
    8020038c:	fd043783          	ld	a5,-48(s0)
    80200390:	fef43023          	sd	a5,-32(s0)
    80200394:	fd843783          	ld	a5,-40(s0)
    80200398:	fef43423          	sd	a5,-24(s0)
    8020039c:	fe043703          	ld	a4,-32(s0)
    802003a0:	fe843783          	ld	a5,-24(s0)
    802003a4:	00070613          	mv	a2,a4
    802003a8:	00078693          	mv	a3,a5
    802003ac:	00060713          	mv	a4,a2
    802003b0:	00068793          	mv	a5,a3
    802003b4:	00070513          	mv	a0,a4
    802003b8:	00078593          	mv	a1,a5
    802003bc:	03813403          	ld	s0,56(sp)
    802003c0:	04010113          	addi	sp,sp,64
    802003c4:	00008067          	ret

00000000802003c8 <trap_handler>:
#include "printk.h"

extern void clock_set_next_event();
extern uint64_t get_cycles();

void trap_handler(uint64_t scause, uint64_t sepc) {
    802003c8:	fd010113          	addi	sp,sp,-48
    802003cc:	02113423          	sd	ra,40(sp)
    802003d0:	02813023          	sd	s0,32(sp)
    802003d4:	03010413          	addi	s0,sp,48
    802003d8:	fca43c23          	sd	a0,-40(s0)
    802003dc:	fcb43823          	sd	a1,-48(s0)
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    // implement
    if(scause & 0x8000000000000000) {
    802003e0:	fd843783          	ld	a5,-40(s0)
    802003e4:	0607d263          	bgez	a5,80200448 <trap_handler+0x80>
        // interrupt
        uint64_t interrupt_t = scause & 0xFF;
    802003e8:	fd843783          	ld	a5,-40(s0)
    802003ec:	0ff7f793          	zext.b	a5,a5
    802003f0:	fef43423          	sd	a5,-24(s0)
        if (interrupt_t == 0x5) {
    802003f4:	fe843703          	ld	a4,-24(s0)
    802003f8:	00500793          	li	a5,5
    802003fc:	02f71a63          	bne	a4,a5,80200430 <trap_handler+0x68>
            // timer interrupt
            uint64_t time = get_cycles()/10000000;
    80200400:	d69ff0ef          	jal	ra,80200168 <get_cycles>
    80200404:	00050713          	mv	a4,a0
    80200408:	009897b7          	lui	a5,0x989
    8020040c:	68078793          	addi	a5,a5,1664 # 989680 <_skernel-0x7f876980>
    80200410:	02f757b3          	divu	a5,a4,a5
    80200414:	fef43023          	sd	a5,-32(s0)
            printk("timer interrupt. time in OS: %ld\n", time);
    80200418:	fe043583          	ld	a1,-32(s0)
    8020041c:	00002517          	auipc	a0,0x2
    80200420:	be450513          	addi	a0,a0,-1052 # 80202000 <_srodata>
    80200424:	775000ef          	jal	ra,80201398 <printk>
            clock_set_next_event();
    80200428:	d95ff0ef          	jal	ra,802001bc <clock_set_next_event>
    }
    else {
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
        // exception
    }
    8020042c:	0300006f          	j	8020045c <trap_handler+0x94>
            printk("Unkown interrupt: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    80200430:	fd043603          	ld	a2,-48(s0)
    80200434:	fd843583          	ld	a1,-40(s0)
    80200438:	00002517          	auipc	a0,0x2
    8020043c:	bf050513          	addi	a0,a0,-1040 # 80202028 <_srodata+0x28>
    80200440:	759000ef          	jal	ra,80201398 <printk>
    80200444:	0180006f          	j	8020045c <trap_handler+0x94>
        printk("Unkown exception: scause = 0x%lx, sepc = 0x%lx\n", scause, sepc);
    80200448:	fd043603          	ld	a2,-48(s0)
    8020044c:	fd843583          	ld	a1,-40(s0)
    80200450:	00002517          	auipc	a0,0x2
    80200454:	c0850513          	addi	a0,a0,-1016 # 80202058 <_srodata+0x58>
    80200458:	741000ef          	jal	ra,80201398 <printk>
    8020045c:	00000013          	nop
    80200460:	02813083          	ld	ra,40(sp)
    80200464:	02013403          	ld	s0,32(sp)
    80200468:	03010113          	addi	sp,sp,48
    8020046c:	00008067          	ret

0000000080200470 <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
    80200470:	ff010113          	addi	sp,sp,-16
    80200474:	00113423          	sd	ra,8(sp)
    80200478:	00813023          	sd	s0,0(sp)
    8020047c:	01010413          	addi	s0,sp,16
    printk("2024");
    80200480:	00002517          	auipc	a0,0x2
    80200484:	c0850513          	addi	a0,a0,-1016 # 80202088 <_srodata+0x88>
    80200488:	711000ef          	jal	ra,80201398 <printk>
    printk(" ZJU Operating System\n");
    8020048c:	00002517          	auipc	a0,0x2
    80200490:	c0450513          	addi	a0,a0,-1020 # 80202090 <_srodata+0x90>
    80200494:	705000ef          	jal	ra,80201398 <printk>

    test();
    80200498:	01c000ef          	jal	ra,802004b4 <test>
    return 0;
    8020049c:	00000793          	li	a5,0
}
    802004a0:	00078513          	mv	a0,a5
    802004a4:	00813083          	ld	ra,8(sp)
    802004a8:	00013403          	ld	s0,0(sp)
    802004ac:	01010113          	addi	sp,sp,16
    802004b0:	00008067          	ret

00000000802004b4 <test>:
//     __builtin_unreachable();
// }

// test for interrupt
void test()
{
    802004b4:	fe010113          	addi	sp,sp,-32
    802004b8:	00113c23          	sd	ra,24(sp)
    802004bc:	00813823          	sd	s0,16(sp)
    802004c0:	02010413          	addi	s0,sp,32
    int i = 0;
    802004c4:	fe042623          	sw	zero,-20(s0)
    while (1)
    {
        if ((++i) % 100000000 == 0)
    802004c8:	fec42783          	lw	a5,-20(s0)
    802004cc:	0017879b          	addiw	a5,a5,1
    802004d0:	fef42623          	sw	a5,-20(s0)
    802004d4:	fec42783          	lw	a5,-20(s0)
    802004d8:	00078713          	mv	a4,a5
    802004dc:	05f5e7b7          	lui	a5,0x5f5e
    802004e0:	1007879b          	addiw	a5,a5,256 # 5f5e100 <_skernel-0x7a2a1f00>
    802004e4:	02f767bb          	remw	a5,a4,a5
    802004e8:	0007879b          	sext.w	a5,a5
    802004ec:	fc079ee3          	bnez	a5,802004c8 <test+0x14>
        {
            printk("kernel is running!\n");
    802004f0:	00002517          	auipc	a0,0x2
    802004f4:	bb850513          	addi	a0,a0,-1096 # 802020a8 <_srodata+0xa8>
    802004f8:	6a1000ef          	jal	ra,80201398 <printk>
            i = 0;
    802004fc:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0)
    80200500:	fc9ff06f          	j	802004c8 <test+0x14>

0000000080200504 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    80200504:	fe010113          	addi	sp,sp,-32
    80200508:	00113c23          	sd	ra,24(sp)
    8020050c:	00813823          	sd	s0,16(sp)
    80200510:	02010413          	addi	s0,sp,32
    80200514:	00050793          	mv	a5,a0
    80200518:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    8020051c:	fec42783          	lw	a5,-20(s0)
    80200520:	0ff7f793          	zext.b	a5,a5
    80200524:	00078513          	mv	a0,a5
    80200528:	db1ff0ef          	jal	ra,802002d8 <sbi_debug_console_write_byte>
    return (char)c;
    8020052c:	fec42783          	lw	a5,-20(s0)
    80200530:	0ff7f793          	zext.b	a5,a5
    80200534:	0007879b          	sext.w	a5,a5
}
    80200538:	00078513          	mv	a0,a5
    8020053c:	01813083          	ld	ra,24(sp)
    80200540:	01013403          	ld	s0,16(sp)
    80200544:	02010113          	addi	sp,sp,32
    80200548:	00008067          	ret

000000008020054c <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    8020054c:	fe010113          	addi	sp,sp,-32
    80200550:	00813c23          	sd	s0,24(sp)
    80200554:	02010413          	addi	s0,sp,32
    80200558:	00050793          	mv	a5,a0
    8020055c:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    80200560:	fec42783          	lw	a5,-20(s0)
    80200564:	0007871b          	sext.w	a4,a5
    80200568:	02000793          	li	a5,32
    8020056c:	02f70263          	beq	a4,a5,80200590 <isspace+0x44>
    80200570:	fec42783          	lw	a5,-20(s0)
    80200574:	0007871b          	sext.w	a4,a5
    80200578:	00800793          	li	a5,8
    8020057c:	00e7de63          	bge	a5,a4,80200598 <isspace+0x4c>
    80200580:	fec42783          	lw	a5,-20(s0)
    80200584:	0007871b          	sext.w	a4,a5
    80200588:	00d00793          	li	a5,13
    8020058c:	00e7c663          	blt	a5,a4,80200598 <isspace+0x4c>
    80200590:	00100793          	li	a5,1
    80200594:	0080006f          	j	8020059c <isspace+0x50>
    80200598:	00000793          	li	a5,0
}
    8020059c:	00078513          	mv	a0,a5
    802005a0:	01813403          	ld	s0,24(sp)
    802005a4:	02010113          	addi	sp,sp,32
    802005a8:	00008067          	ret

00000000802005ac <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    802005ac:	fb010113          	addi	sp,sp,-80
    802005b0:	04113423          	sd	ra,72(sp)
    802005b4:	04813023          	sd	s0,64(sp)
    802005b8:	05010413          	addi	s0,sp,80
    802005bc:	fca43423          	sd	a0,-56(s0)
    802005c0:	fcb43023          	sd	a1,-64(s0)
    802005c4:	00060793          	mv	a5,a2
    802005c8:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    802005cc:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    802005d0:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    802005d4:	fc843783          	ld	a5,-56(s0)
    802005d8:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    802005dc:	0100006f          	j	802005ec <strtol+0x40>
        p++;
    802005e0:	fd843783          	ld	a5,-40(s0)
    802005e4:	00178793          	addi	a5,a5,1
    802005e8:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    802005ec:	fd843783          	ld	a5,-40(s0)
    802005f0:	0007c783          	lbu	a5,0(a5)
    802005f4:	0007879b          	sext.w	a5,a5
    802005f8:	00078513          	mv	a0,a5
    802005fc:	f51ff0ef          	jal	ra,8020054c <isspace>
    80200600:	00050793          	mv	a5,a0
    80200604:	fc079ee3          	bnez	a5,802005e0 <strtol+0x34>
    }

    if (*p == '-') {
    80200608:	fd843783          	ld	a5,-40(s0)
    8020060c:	0007c783          	lbu	a5,0(a5)
    80200610:	00078713          	mv	a4,a5
    80200614:	02d00793          	li	a5,45
    80200618:	00f71e63          	bne	a4,a5,80200634 <strtol+0x88>
        neg = true;
    8020061c:	00100793          	li	a5,1
    80200620:	fef403a3          	sb	a5,-25(s0)
        p++;
    80200624:	fd843783          	ld	a5,-40(s0)
    80200628:	00178793          	addi	a5,a5,1
    8020062c:	fcf43c23          	sd	a5,-40(s0)
    80200630:	0240006f          	j	80200654 <strtol+0xa8>
    } else if (*p == '+') {
    80200634:	fd843783          	ld	a5,-40(s0)
    80200638:	0007c783          	lbu	a5,0(a5)
    8020063c:	00078713          	mv	a4,a5
    80200640:	02b00793          	li	a5,43
    80200644:	00f71863          	bne	a4,a5,80200654 <strtol+0xa8>
        p++;
    80200648:	fd843783          	ld	a5,-40(s0)
    8020064c:	00178793          	addi	a5,a5,1
    80200650:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    80200654:	fbc42783          	lw	a5,-68(s0)
    80200658:	0007879b          	sext.w	a5,a5
    8020065c:	06079c63          	bnez	a5,802006d4 <strtol+0x128>
        if (*p == '0') {
    80200660:	fd843783          	ld	a5,-40(s0)
    80200664:	0007c783          	lbu	a5,0(a5)
    80200668:	00078713          	mv	a4,a5
    8020066c:	03000793          	li	a5,48
    80200670:	04f71e63          	bne	a4,a5,802006cc <strtol+0x120>
            p++;
    80200674:	fd843783          	ld	a5,-40(s0)
    80200678:	00178793          	addi	a5,a5,1
    8020067c:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    80200680:	fd843783          	ld	a5,-40(s0)
    80200684:	0007c783          	lbu	a5,0(a5)
    80200688:	00078713          	mv	a4,a5
    8020068c:	07800793          	li	a5,120
    80200690:	00f70c63          	beq	a4,a5,802006a8 <strtol+0xfc>
    80200694:	fd843783          	ld	a5,-40(s0)
    80200698:	0007c783          	lbu	a5,0(a5)
    8020069c:	00078713          	mv	a4,a5
    802006a0:	05800793          	li	a5,88
    802006a4:	00f71e63          	bne	a4,a5,802006c0 <strtol+0x114>
                base = 16;
    802006a8:	01000793          	li	a5,16
    802006ac:	faf42e23          	sw	a5,-68(s0)
                p++;
    802006b0:	fd843783          	ld	a5,-40(s0)
    802006b4:	00178793          	addi	a5,a5,1
    802006b8:	fcf43c23          	sd	a5,-40(s0)
    802006bc:	0180006f          	j	802006d4 <strtol+0x128>
            } else {
                base = 8;
    802006c0:	00800793          	li	a5,8
    802006c4:	faf42e23          	sw	a5,-68(s0)
    802006c8:	00c0006f          	j	802006d4 <strtol+0x128>
            }
        } else {
            base = 10;
    802006cc:	00a00793          	li	a5,10
    802006d0:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    802006d4:	fd843783          	ld	a5,-40(s0)
    802006d8:	0007c783          	lbu	a5,0(a5)
    802006dc:	00078713          	mv	a4,a5
    802006e0:	02f00793          	li	a5,47
    802006e4:	02e7f863          	bgeu	a5,a4,80200714 <strtol+0x168>
    802006e8:	fd843783          	ld	a5,-40(s0)
    802006ec:	0007c783          	lbu	a5,0(a5)
    802006f0:	00078713          	mv	a4,a5
    802006f4:	03900793          	li	a5,57
    802006f8:	00e7ee63          	bltu	a5,a4,80200714 <strtol+0x168>
            digit = *p - '0';
    802006fc:	fd843783          	ld	a5,-40(s0)
    80200700:	0007c783          	lbu	a5,0(a5)
    80200704:	0007879b          	sext.w	a5,a5
    80200708:	fd07879b          	addiw	a5,a5,-48
    8020070c:	fcf42a23          	sw	a5,-44(s0)
    80200710:	0800006f          	j	80200790 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    80200714:	fd843783          	ld	a5,-40(s0)
    80200718:	0007c783          	lbu	a5,0(a5)
    8020071c:	00078713          	mv	a4,a5
    80200720:	06000793          	li	a5,96
    80200724:	02e7f863          	bgeu	a5,a4,80200754 <strtol+0x1a8>
    80200728:	fd843783          	ld	a5,-40(s0)
    8020072c:	0007c783          	lbu	a5,0(a5)
    80200730:	00078713          	mv	a4,a5
    80200734:	07a00793          	li	a5,122
    80200738:	00e7ee63          	bltu	a5,a4,80200754 <strtol+0x1a8>
            digit = *p - ('a' - 10);
    8020073c:	fd843783          	ld	a5,-40(s0)
    80200740:	0007c783          	lbu	a5,0(a5)
    80200744:	0007879b          	sext.w	a5,a5
    80200748:	fa97879b          	addiw	a5,a5,-87
    8020074c:	fcf42a23          	sw	a5,-44(s0)
    80200750:	0400006f          	j	80200790 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    80200754:	fd843783          	ld	a5,-40(s0)
    80200758:	0007c783          	lbu	a5,0(a5)
    8020075c:	00078713          	mv	a4,a5
    80200760:	04000793          	li	a5,64
    80200764:	06e7f863          	bgeu	a5,a4,802007d4 <strtol+0x228>
    80200768:	fd843783          	ld	a5,-40(s0)
    8020076c:	0007c783          	lbu	a5,0(a5)
    80200770:	00078713          	mv	a4,a5
    80200774:	05a00793          	li	a5,90
    80200778:	04e7ee63          	bltu	a5,a4,802007d4 <strtol+0x228>
            digit = *p - ('A' - 10);
    8020077c:	fd843783          	ld	a5,-40(s0)
    80200780:	0007c783          	lbu	a5,0(a5)
    80200784:	0007879b          	sext.w	a5,a5
    80200788:	fc97879b          	addiw	a5,a5,-55
    8020078c:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    80200790:	fd442783          	lw	a5,-44(s0)
    80200794:	00078713          	mv	a4,a5
    80200798:	fbc42783          	lw	a5,-68(s0)
    8020079c:	0007071b          	sext.w	a4,a4
    802007a0:	0007879b          	sext.w	a5,a5
    802007a4:	02f75663          	bge	a4,a5,802007d0 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    802007a8:	fbc42703          	lw	a4,-68(s0)
    802007ac:	fe843783          	ld	a5,-24(s0)
    802007b0:	02f70733          	mul	a4,a4,a5
    802007b4:	fd442783          	lw	a5,-44(s0)
    802007b8:	00f707b3          	add	a5,a4,a5
    802007bc:	fef43423          	sd	a5,-24(s0)
        p++;
    802007c0:	fd843783          	ld	a5,-40(s0)
    802007c4:	00178793          	addi	a5,a5,1
    802007c8:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    802007cc:	f09ff06f          	j	802006d4 <strtol+0x128>
            break;
    802007d0:	00000013          	nop
    }

    if (endptr) {
    802007d4:	fc043783          	ld	a5,-64(s0)
    802007d8:	00078863          	beqz	a5,802007e8 <strtol+0x23c>
        *endptr = (char *)p;
    802007dc:	fc043783          	ld	a5,-64(s0)
    802007e0:	fd843703          	ld	a4,-40(s0)
    802007e4:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    802007e8:	fe744783          	lbu	a5,-25(s0)
    802007ec:	0ff7f793          	zext.b	a5,a5
    802007f0:	00078863          	beqz	a5,80200800 <strtol+0x254>
    802007f4:	fe843783          	ld	a5,-24(s0)
    802007f8:	40f007b3          	neg	a5,a5
    802007fc:	0080006f          	j	80200804 <strtol+0x258>
    80200800:	fe843783          	ld	a5,-24(s0)
}
    80200804:	00078513          	mv	a0,a5
    80200808:	04813083          	ld	ra,72(sp)
    8020080c:	04013403          	ld	s0,64(sp)
    80200810:	05010113          	addi	sp,sp,80
    80200814:	00008067          	ret

0000000080200818 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    80200818:	fd010113          	addi	sp,sp,-48
    8020081c:	02113423          	sd	ra,40(sp)
    80200820:	02813023          	sd	s0,32(sp)
    80200824:	03010413          	addi	s0,sp,48
    80200828:	fca43c23          	sd	a0,-40(s0)
    8020082c:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    80200830:	fd043783          	ld	a5,-48(s0)
    80200834:	00079863          	bnez	a5,80200844 <puts_wo_nl+0x2c>
        s = "(null)";
    80200838:	00002797          	auipc	a5,0x2
    8020083c:	88878793          	addi	a5,a5,-1912 # 802020c0 <_srodata+0xc0>
    80200840:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    80200844:	fd043783          	ld	a5,-48(s0)
    80200848:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    8020084c:	0240006f          	j	80200870 <puts_wo_nl+0x58>
        putch(*p++);
    80200850:	fe843783          	ld	a5,-24(s0)
    80200854:	00178713          	addi	a4,a5,1
    80200858:	fee43423          	sd	a4,-24(s0)
    8020085c:	0007c783          	lbu	a5,0(a5)
    80200860:	0007871b          	sext.w	a4,a5
    80200864:	fd843783          	ld	a5,-40(s0)
    80200868:	00070513          	mv	a0,a4
    8020086c:	000780e7          	jalr	a5
    while (*p) {
    80200870:	fe843783          	ld	a5,-24(s0)
    80200874:	0007c783          	lbu	a5,0(a5)
    80200878:	fc079ce3          	bnez	a5,80200850 <puts_wo_nl+0x38>
    }
    return p - s;
    8020087c:	fe843703          	ld	a4,-24(s0)
    80200880:	fd043783          	ld	a5,-48(s0)
    80200884:	40f707b3          	sub	a5,a4,a5
    80200888:	0007879b          	sext.w	a5,a5
}
    8020088c:	00078513          	mv	a0,a5
    80200890:	02813083          	ld	ra,40(sp)
    80200894:	02013403          	ld	s0,32(sp)
    80200898:	03010113          	addi	sp,sp,48
    8020089c:	00008067          	ret

00000000802008a0 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    802008a0:	f9010113          	addi	sp,sp,-112
    802008a4:	06113423          	sd	ra,104(sp)
    802008a8:	06813023          	sd	s0,96(sp)
    802008ac:	07010413          	addi	s0,sp,112
    802008b0:	faa43423          	sd	a0,-88(s0)
    802008b4:	fab43023          	sd	a1,-96(s0)
    802008b8:	00060793          	mv	a5,a2
    802008bc:	f8d43823          	sd	a3,-112(s0)
    802008c0:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    802008c4:	f9f44783          	lbu	a5,-97(s0)
    802008c8:	0ff7f793          	zext.b	a5,a5
    802008cc:	02078663          	beqz	a5,802008f8 <print_dec_int+0x58>
    802008d0:	fa043703          	ld	a4,-96(s0)
    802008d4:	fff00793          	li	a5,-1
    802008d8:	03f79793          	slli	a5,a5,0x3f
    802008dc:	00f71e63          	bne	a4,a5,802008f8 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    802008e0:	00001597          	auipc	a1,0x1
    802008e4:	7e858593          	addi	a1,a1,2024 # 802020c8 <_srodata+0xc8>
    802008e8:	fa843503          	ld	a0,-88(s0)
    802008ec:	f2dff0ef          	jal	ra,80200818 <puts_wo_nl>
    802008f0:	00050793          	mv	a5,a0
    802008f4:	2a00006f          	j	80200b94 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    802008f8:	f9043783          	ld	a5,-112(s0)
    802008fc:	00c7a783          	lw	a5,12(a5)
    80200900:	00079a63          	bnez	a5,80200914 <print_dec_int+0x74>
    80200904:	fa043783          	ld	a5,-96(s0)
    80200908:	00079663          	bnez	a5,80200914 <print_dec_int+0x74>
        return 0;
    8020090c:	00000793          	li	a5,0
    80200910:	2840006f          	j	80200b94 <print_dec_int+0x2f4>
    }

    bool neg = false;
    80200914:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    80200918:	f9f44783          	lbu	a5,-97(s0)
    8020091c:	0ff7f793          	zext.b	a5,a5
    80200920:	02078063          	beqz	a5,80200940 <print_dec_int+0xa0>
    80200924:	fa043783          	ld	a5,-96(s0)
    80200928:	0007dc63          	bgez	a5,80200940 <print_dec_int+0xa0>
        neg = true;
    8020092c:	00100793          	li	a5,1
    80200930:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    80200934:	fa043783          	ld	a5,-96(s0)
    80200938:	40f007b3          	neg	a5,a5
    8020093c:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    80200940:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    80200944:	f9f44783          	lbu	a5,-97(s0)
    80200948:	0ff7f793          	zext.b	a5,a5
    8020094c:	02078863          	beqz	a5,8020097c <print_dec_int+0xdc>
    80200950:	fef44783          	lbu	a5,-17(s0)
    80200954:	0ff7f793          	zext.b	a5,a5
    80200958:	00079e63          	bnez	a5,80200974 <print_dec_int+0xd4>
    8020095c:	f9043783          	ld	a5,-112(s0)
    80200960:	0057c783          	lbu	a5,5(a5)
    80200964:	00079863          	bnez	a5,80200974 <print_dec_int+0xd4>
    80200968:	f9043783          	ld	a5,-112(s0)
    8020096c:	0047c783          	lbu	a5,4(a5)
    80200970:	00078663          	beqz	a5,8020097c <print_dec_int+0xdc>
    80200974:	00100793          	li	a5,1
    80200978:	0080006f          	j	80200980 <print_dec_int+0xe0>
    8020097c:	00000793          	li	a5,0
    80200980:	fcf40ba3          	sb	a5,-41(s0)
    80200984:	fd744783          	lbu	a5,-41(s0)
    80200988:	0017f793          	andi	a5,a5,1
    8020098c:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    80200990:	fa043703          	ld	a4,-96(s0)
    80200994:	00a00793          	li	a5,10
    80200998:	02f777b3          	remu	a5,a4,a5
    8020099c:	0ff7f713          	zext.b	a4,a5
    802009a0:	fe842783          	lw	a5,-24(s0)
    802009a4:	0017869b          	addiw	a3,a5,1
    802009a8:	fed42423          	sw	a3,-24(s0)
    802009ac:	0307071b          	addiw	a4,a4,48
    802009b0:	0ff77713          	zext.b	a4,a4
    802009b4:	ff078793          	addi	a5,a5,-16
    802009b8:	008787b3          	add	a5,a5,s0
    802009bc:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    802009c0:	fa043703          	ld	a4,-96(s0)
    802009c4:	00a00793          	li	a5,10
    802009c8:	02f757b3          	divu	a5,a4,a5
    802009cc:	faf43023          	sd	a5,-96(s0)
    } while (num);
    802009d0:	fa043783          	ld	a5,-96(s0)
    802009d4:	fa079ee3          	bnez	a5,80200990 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    802009d8:	f9043783          	ld	a5,-112(s0)
    802009dc:	00c7a783          	lw	a5,12(a5)
    802009e0:	00078713          	mv	a4,a5
    802009e4:	fff00793          	li	a5,-1
    802009e8:	02f71063          	bne	a4,a5,80200a08 <print_dec_int+0x168>
    802009ec:	f9043783          	ld	a5,-112(s0)
    802009f0:	0037c783          	lbu	a5,3(a5)
    802009f4:	00078a63          	beqz	a5,80200a08 <print_dec_int+0x168>
        flags->prec = flags->width;
    802009f8:	f9043783          	ld	a5,-112(s0)
    802009fc:	0087a703          	lw	a4,8(a5)
    80200a00:	f9043783          	ld	a5,-112(s0)
    80200a04:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    80200a08:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80200a0c:	f9043783          	ld	a5,-112(s0)
    80200a10:	0087a703          	lw	a4,8(a5)
    80200a14:	fe842783          	lw	a5,-24(s0)
    80200a18:	fcf42823          	sw	a5,-48(s0)
    80200a1c:	f9043783          	ld	a5,-112(s0)
    80200a20:	00c7a783          	lw	a5,12(a5)
    80200a24:	fcf42623          	sw	a5,-52(s0)
    80200a28:	fd042783          	lw	a5,-48(s0)
    80200a2c:	00078593          	mv	a1,a5
    80200a30:	fcc42783          	lw	a5,-52(s0)
    80200a34:	00078613          	mv	a2,a5
    80200a38:	0006069b          	sext.w	a3,a2
    80200a3c:	0005879b          	sext.w	a5,a1
    80200a40:	00f6d463          	bge	a3,a5,80200a48 <print_dec_int+0x1a8>
    80200a44:	00058613          	mv	a2,a1
    80200a48:	0006079b          	sext.w	a5,a2
    80200a4c:	40f707bb          	subw	a5,a4,a5
    80200a50:	0007871b          	sext.w	a4,a5
    80200a54:	fd744783          	lbu	a5,-41(s0)
    80200a58:	0007879b          	sext.w	a5,a5
    80200a5c:	40f707bb          	subw	a5,a4,a5
    80200a60:	fef42023          	sw	a5,-32(s0)
    80200a64:	0280006f          	j	80200a8c <print_dec_int+0x1ec>
        putch(' ');
    80200a68:	fa843783          	ld	a5,-88(s0)
    80200a6c:	02000513          	li	a0,32
    80200a70:	000780e7          	jalr	a5
        ++written;
    80200a74:	fe442783          	lw	a5,-28(s0)
    80200a78:	0017879b          	addiw	a5,a5,1
    80200a7c:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80200a80:	fe042783          	lw	a5,-32(s0)
    80200a84:	fff7879b          	addiw	a5,a5,-1
    80200a88:	fef42023          	sw	a5,-32(s0)
    80200a8c:	fe042783          	lw	a5,-32(s0)
    80200a90:	0007879b          	sext.w	a5,a5
    80200a94:	fcf04ae3          	bgtz	a5,80200a68 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    80200a98:	fd744783          	lbu	a5,-41(s0)
    80200a9c:	0ff7f793          	zext.b	a5,a5
    80200aa0:	04078463          	beqz	a5,80200ae8 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    80200aa4:	fef44783          	lbu	a5,-17(s0)
    80200aa8:	0ff7f793          	zext.b	a5,a5
    80200aac:	00078663          	beqz	a5,80200ab8 <print_dec_int+0x218>
    80200ab0:	02d00793          	li	a5,45
    80200ab4:	01c0006f          	j	80200ad0 <print_dec_int+0x230>
    80200ab8:	f9043783          	ld	a5,-112(s0)
    80200abc:	0057c783          	lbu	a5,5(a5)
    80200ac0:	00078663          	beqz	a5,80200acc <print_dec_int+0x22c>
    80200ac4:	02b00793          	li	a5,43
    80200ac8:	0080006f          	j	80200ad0 <print_dec_int+0x230>
    80200acc:	02000793          	li	a5,32
    80200ad0:	fa843703          	ld	a4,-88(s0)
    80200ad4:	00078513          	mv	a0,a5
    80200ad8:	000700e7          	jalr	a4
        ++written;
    80200adc:	fe442783          	lw	a5,-28(s0)
    80200ae0:	0017879b          	addiw	a5,a5,1
    80200ae4:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80200ae8:	fe842783          	lw	a5,-24(s0)
    80200aec:	fcf42e23          	sw	a5,-36(s0)
    80200af0:	0280006f          	j	80200b18 <print_dec_int+0x278>
        putch('0');
    80200af4:	fa843783          	ld	a5,-88(s0)
    80200af8:	03000513          	li	a0,48
    80200afc:	000780e7          	jalr	a5
        ++written;
    80200b00:	fe442783          	lw	a5,-28(s0)
    80200b04:	0017879b          	addiw	a5,a5,1
    80200b08:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80200b0c:	fdc42783          	lw	a5,-36(s0)
    80200b10:	0017879b          	addiw	a5,a5,1
    80200b14:	fcf42e23          	sw	a5,-36(s0)
    80200b18:	f9043783          	ld	a5,-112(s0)
    80200b1c:	00c7a703          	lw	a4,12(a5)
    80200b20:	fd744783          	lbu	a5,-41(s0)
    80200b24:	0007879b          	sext.w	a5,a5
    80200b28:	40f707bb          	subw	a5,a4,a5
    80200b2c:	0007871b          	sext.w	a4,a5
    80200b30:	fdc42783          	lw	a5,-36(s0)
    80200b34:	0007879b          	sext.w	a5,a5
    80200b38:	fae7cee3          	blt	a5,a4,80200af4 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    80200b3c:	fe842783          	lw	a5,-24(s0)
    80200b40:	fff7879b          	addiw	a5,a5,-1
    80200b44:	fcf42c23          	sw	a5,-40(s0)
    80200b48:	03c0006f          	j	80200b84 <print_dec_int+0x2e4>
        putch(buf[i]);
    80200b4c:	fd842783          	lw	a5,-40(s0)
    80200b50:	ff078793          	addi	a5,a5,-16
    80200b54:	008787b3          	add	a5,a5,s0
    80200b58:	fc87c783          	lbu	a5,-56(a5)
    80200b5c:	0007871b          	sext.w	a4,a5
    80200b60:	fa843783          	ld	a5,-88(s0)
    80200b64:	00070513          	mv	a0,a4
    80200b68:	000780e7          	jalr	a5
        ++written;
    80200b6c:	fe442783          	lw	a5,-28(s0)
    80200b70:	0017879b          	addiw	a5,a5,1
    80200b74:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    80200b78:	fd842783          	lw	a5,-40(s0)
    80200b7c:	fff7879b          	addiw	a5,a5,-1
    80200b80:	fcf42c23          	sw	a5,-40(s0)
    80200b84:	fd842783          	lw	a5,-40(s0)
    80200b88:	0007879b          	sext.w	a5,a5
    80200b8c:	fc07d0e3          	bgez	a5,80200b4c <print_dec_int+0x2ac>
    }

    return written;
    80200b90:	fe442783          	lw	a5,-28(s0)
}
    80200b94:	00078513          	mv	a0,a5
    80200b98:	06813083          	ld	ra,104(sp)
    80200b9c:	06013403          	ld	s0,96(sp)
    80200ba0:	07010113          	addi	sp,sp,112
    80200ba4:	00008067          	ret

0000000080200ba8 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    80200ba8:	f4010113          	addi	sp,sp,-192
    80200bac:	0a113c23          	sd	ra,184(sp)
    80200bb0:	0a813823          	sd	s0,176(sp)
    80200bb4:	0c010413          	addi	s0,sp,192
    80200bb8:	f4a43c23          	sd	a0,-168(s0)
    80200bbc:	f4b43823          	sd	a1,-176(s0)
    80200bc0:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    80200bc4:	f8043023          	sd	zero,-128(s0)
    80200bc8:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    80200bcc:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    80200bd0:	7a40006f          	j	80201374 <vprintfmt+0x7cc>
        if (flags.in_format) {
    80200bd4:	f8044783          	lbu	a5,-128(s0)
    80200bd8:	72078e63          	beqz	a5,80201314 <vprintfmt+0x76c>
            if (*fmt == '#') {
    80200bdc:	f5043783          	ld	a5,-176(s0)
    80200be0:	0007c783          	lbu	a5,0(a5)
    80200be4:	00078713          	mv	a4,a5
    80200be8:	02300793          	li	a5,35
    80200bec:	00f71863          	bne	a4,a5,80200bfc <vprintfmt+0x54>
                flags.sharpflag = true;
    80200bf0:	00100793          	li	a5,1
    80200bf4:	f8f40123          	sb	a5,-126(s0)
    80200bf8:	7700006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    80200bfc:	f5043783          	ld	a5,-176(s0)
    80200c00:	0007c783          	lbu	a5,0(a5)
    80200c04:	00078713          	mv	a4,a5
    80200c08:	03000793          	li	a5,48
    80200c0c:	00f71863          	bne	a4,a5,80200c1c <vprintfmt+0x74>
                flags.zeroflag = true;
    80200c10:	00100793          	li	a5,1
    80200c14:	f8f401a3          	sb	a5,-125(s0)
    80200c18:	7500006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    80200c1c:	f5043783          	ld	a5,-176(s0)
    80200c20:	0007c783          	lbu	a5,0(a5)
    80200c24:	00078713          	mv	a4,a5
    80200c28:	06c00793          	li	a5,108
    80200c2c:	04f70063          	beq	a4,a5,80200c6c <vprintfmt+0xc4>
    80200c30:	f5043783          	ld	a5,-176(s0)
    80200c34:	0007c783          	lbu	a5,0(a5)
    80200c38:	00078713          	mv	a4,a5
    80200c3c:	07a00793          	li	a5,122
    80200c40:	02f70663          	beq	a4,a5,80200c6c <vprintfmt+0xc4>
    80200c44:	f5043783          	ld	a5,-176(s0)
    80200c48:	0007c783          	lbu	a5,0(a5)
    80200c4c:	00078713          	mv	a4,a5
    80200c50:	07400793          	li	a5,116
    80200c54:	00f70c63          	beq	a4,a5,80200c6c <vprintfmt+0xc4>
    80200c58:	f5043783          	ld	a5,-176(s0)
    80200c5c:	0007c783          	lbu	a5,0(a5)
    80200c60:	00078713          	mv	a4,a5
    80200c64:	06a00793          	li	a5,106
    80200c68:	00f71863          	bne	a4,a5,80200c78 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    80200c6c:	00100793          	li	a5,1
    80200c70:	f8f400a3          	sb	a5,-127(s0)
    80200c74:	6f40006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    80200c78:	f5043783          	ld	a5,-176(s0)
    80200c7c:	0007c783          	lbu	a5,0(a5)
    80200c80:	00078713          	mv	a4,a5
    80200c84:	02b00793          	li	a5,43
    80200c88:	00f71863          	bne	a4,a5,80200c98 <vprintfmt+0xf0>
                flags.sign = true;
    80200c8c:	00100793          	li	a5,1
    80200c90:	f8f402a3          	sb	a5,-123(s0)
    80200c94:	6d40006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    80200c98:	f5043783          	ld	a5,-176(s0)
    80200c9c:	0007c783          	lbu	a5,0(a5)
    80200ca0:	00078713          	mv	a4,a5
    80200ca4:	02000793          	li	a5,32
    80200ca8:	00f71863          	bne	a4,a5,80200cb8 <vprintfmt+0x110>
                flags.spaceflag = true;
    80200cac:	00100793          	li	a5,1
    80200cb0:	f8f40223          	sb	a5,-124(s0)
    80200cb4:	6b40006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    80200cb8:	f5043783          	ld	a5,-176(s0)
    80200cbc:	0007c783          	lbu	a5,0(a5)
    80200cc0:	00078713          	mv	a4,a5
    80200cc4:	02a00793          	li	a5,42
    80200cc8:	00f71e63          	bne	a4,a5,80200ce4 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    80200ccc:	f4843783          	ld	a5,-184(s0)
    80200cd0:	00878713          	addi	a4,a5,8
    80200cd4:	f4e43423          	sd	a4,-184(s0)
    80200cd8:	0007a783          	lw	a5,0(a5)
    80200cdc:	f8f42423          	sw	a5,-120(s0)
    80200ce0:	6880006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    80200ce4:	f5043783          	ld	a5,-176(s0)
    80200ce8:	0007c783          	lbu	a5,0(a5)
    80200cec:	00078713          	mv	a4,a5
    80200cf0:	03000793          	li	a5,48
    80200cf4:	04e7f663          	bgeu	a5,a4,80200d40 <vprintfmt+0x198>
    80200cf8:	f5043783          	ld	a5,-176(s0)
    80200cfc:	0007c783          	lbu	a5,0(a5)
    80200d00:	00078713          	mv	a4,a5
    80200d04:	03900793          	li	a5,57
    80200d08:	02e7ec63          	bltu	a5,a4,80200d40 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    80200d0c:	f5043783          	ld	a5,-176(s0)
    80200d10:	f5040713          	addi	a4,s0,-176
    80200d14:	00a00613          	li	a2,10
    80200d18:	00070593          	mv	a1,a4
    80200d1c:	00078513          	mv	a0,a5
    80200d20:	88dff0ef          	jal	ra,802005ac <strtol>
    80200d24:	00050793          	mv	a5,a0
    80200d28:	0007879b          	sext.w	a5,a5
    80200d2c:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    80200d30:	f5043783          	ld	a5,-176(s0)
    80200d34:	fff78793          	addi	a5,a5,-1
    80200d38:	f4f43823          	sd	a5,-176(s0)
    80200d3c:	62c0006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    80200d40:	f5043783          	ld	a5,-176(s0)
    80200d44:	0007c783          	lbu	a5,0(a5)
    80200d48:	00078713          	mv	a4,a5
    80200d4c:	02e00793          	li	a5,46
    80200d50:	06f71863          	bne	a4,a5,80200dc0 <vprintfmt+0x218>
                fmt++;
    80200d54:	f5043783          	ld	a5,-176(s0)
    80200d58:	00178793          	addi	a5,a5,1
    80200d5c:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    80200d60:	f5043783          	ld	a5,-176(s0)
    80200d64:	0007c783          	lbu	a5,0(a5)
    80200d68:	00078713          	mv	a4,a5
    80200d6c:	02a00793          	li	a5,42
    80200d70:	00f71e63          	bne	a4,a5,80200d8c <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    80200d74:	f4843783          	ld	a5,-184(s0)
    80200d78:	00878713          	addi	a4,a5,8
    80200d7c:	f4e43423          	sd	a4,-184(s0)
    80200d80:	0007a783          	lw	a5,0(a5)
    80200d84:	f8f42623          	sw	a5,-116(s0)
    80200d88:	5e00006f          	j	80201368 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    80200d8c:	f5043783          	ld	a5,-176(s0)
    80200d90:	f5040713          	addi	a4,s0,-176
    80200d94:	00a00613          	li	a2,10
    80200d98:	00070593          	mv	a1,a4
    80200d9c:	00078513          	mv	a0,a5
    80200da0:	80dff0ef          	jal	ra,802005ac <strtol>
    80200da4:	00050793          	mv	a5,a0
    80200da8:	0007879b          	sext.w	a5,a5
    80200dac:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    80200db0:	f5043783          	ld	a5,-176(s0)
    80200db4:	fff78793          	addi	a5,a5,-1
    80200db8:	f4f43823          	sd	a5,-176(s0)
    80200dbc:	5ac0006f          	j	80201368 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80200dc0:	f5043783          	ld	a5,-176(s0)
    80200dc4:	0007c783          	lbu	a5,0(a5)
    80200dc8:	00078713          	mv	a4,a5
    80200dcc:	07800793          	li	a5,120
    80200dd0:	02f70663          	beq	a4,a5,80200dfc <vprintfmt+0x254>
    80200dd4:	f5043783          	ld	a5,-176(s0)
    80200dd8:	0007c783          	lbu	a5,0(a5)
    80200ddc:	00078713          	mv	a4,a5
    80200de0:	05800793          	li	a5,88
    80200de4:	00f70c63          	beq	a4,a5,80200dfc <vprintfmt+0x254>
    80200de8:	f5043783          	ld	a5,-176(s0)
    80200dec:	0007c783          	lbu	a5,0(a5)
    80200df0:	00078713          	mv	a4,a5
    80200df4:	07000793          	li	a5,112
    80200df8:	30f71263          	bne	a4,a5,802010fc <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    80200dfc:	f5043783          	ld	a5,-176(s0)
    80200e00:	0007c783          	lbu	a5,0(a5)
    80200e04:	00078713          	mv	a4,a5
    80200e08:	07000793          	li	a5,112
    80200e0c:	00f70663          	beq	a4,a5,80200e18 <vprintfmt+0x270>
    80200e10:	f8144783          	lbu	a5,-127(s0)
    80200e14:	00078663          	beqz	a5,80200e20 <vprintfmt+0x278>
    80200e18:	00100793          	li	a5,1
    80200e1c:	0080006f          	j	80200e24 <vprintfmt+0x27c>
    80200e20:	00000793          	li	a5,0
    80200e24:	faf403a3          	sb	a5,-89(s0)
    80200e28:	fa744783          	lbu	a5,-89(s0)
    80200e2c:	0017f793          	andi	a5,a5,1
    80200e30:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    80200e34:	fa744783          	lbu	a5,-89(s0)
    80200e38:	0ff7f793          	zext.b	a5,a5
    80200e3c:	00078c63          	beqz	a5,80200e54 <vprintfmt+0x2ac>
    80200e40:	f4843783          	ld	a5,-184(s0)
    80200e44:	00878713          	addi	a4,a5,8
    80200e48:	f4e43423          	sd	a4,-184(s0)
    80200e4c:	0007b783          	ld	a5,0(a5)
    80200e50:	01c0006f          	j	80200e6c <vprintfmt+0x2c4>
    80200e54:	f4843783          	ld	a5,-184(s0)
    80200e58:	00878713          	addi	a4,a5,8
    80200e5c:	f4e43423          	sd	a4,-184(s0)
    80200e60:	0007a783          	lw	a5,0(a5)
    80200e64:	02079793          	slli	a5,a5,0x20
    80200e68:	0207d793          	srli	a5,a5,0x20
    80200e6c:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    80200e70:	f8c42783          	lw	a5,-116(s0)
    80200e74:	02079463          	bnez	a5,80200e9c <vprintfmt+0x2f4>
    80200e78:	fe043783          	ld	a5,-32(s0)
    80200e7c:	02079063          	bnez	a5,80200e9c <vprintfmt+0x2f4>
    80200e80:	f5043783          	ld	a5,-176(s0)
    80200e84:	0007c783          	lbu	a5,0(a5)
    80200e88:	00078713          	mv	a4,a5
    80200e8c:	07000793          	li	a5,112
    80200e90:	00f70663          	beq	a4,a5,80200e9c <vprintfmt+0x2f4>
                    flags.in_format = false;
    80200e94:	f8040023          	sb	zero,-128(s0)
    80200e98:	4d00006f          	j	80201368 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    80200e9c:	f5043783          	ld	a5,-176(s0)
    80200ea0:	0007c783          	lbu	a5,0(a5)
    80200ea4:	00078713          	mv	a4,a5
    80200ea8:	07000793          	li	a5,112
    80200eac:	00f70a63          	beq	a4,a5,80200ec0 <vprintfmt+0x318>
    80200eb0:	f8244783          	lbu	a5,-126(s0)
    80200eb4:	00078a63          	beqz	a5,80200ec8 <vprintfmt+0x320>
    80200eb8:	fe043783          	ld	a5,-32(s0)
    80200ebc:	00078663          	beqz	a5,80200ec8 <vprintfmt+0x320>
    80200ec0:	00100793          	li	a5,1
    80200ec4:	0080006f          	j	80200ecc <vprintfmt+0x324>
    80200ec8:	00000793          	li	a5,0
    80200ecc:	faf40323          	sb	a5,-90(s0)
    80200ed0:	fa644783          	lbu	a5,-90(s0)
    80200ed4:	0017f793          	andi	a5,a5,1
    80200ed8:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    80200edc:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    80200ee0:	f5043783          	ld	a5,-176(s0)
    80200ee4:	0007c783          	lbu	a5,0(a5)
    80200ee8:	00078713          	mv	a4,a5
    80200eec:	05800793          	li	a5,88
    80200ef0:	00f71863          	bne	a4,a5,80200f00 <vprintfmt+0x358>
    80200ef4:	00001797          	auipc	a5,0x1
    80200ef8:	1ec78793          	addi	a5,a5,492 # 802020e0 <upperxdigits.1>
    80200efc:	00c0006f          	j	80200f08 <vprintfmt+0x360>
    80200f00:	00001797          	auipc	a5,0x1
    80200f04:	1f878793          	addi	a5,a5,504 # 802020f8 <lowerxdigits.0>
    80200f08:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    80200f0c:	fe043783          	ld	a5,-32(s0)
    80200f10:	00f7f793          	andi	a5,a5,15
    80200f14:	f9843703          	ld	a4,-104(s0)
    80200f18:	00f70733          	add	a4,a4,a5
    80200f1c:	fdc42783          	lw	a5,-36(s0)
    80200f20:	0017869b          	addiw	a3,a5,1
    80200f24:	fcd42e23          	sw	a3,-36(s0)
    80200f28:	00074703          	lbu	a4,0(a4)
    80200f2c:	ff078793          	addi	a5,a5,-16
    80200f30:	008787b3          	add	a5,a5,s0
    80200f34:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    80200f38:	fe043783          	ld	a5,-32(s0)
    80200f3c:	0047d793          	srli	a5,a5,0x4
    80200f40:	fef43023          	sd	a5,-32(s0)
                } while (num);
    80200f44:	fe043783          	ld	a5,-32(s0)
    80200f48:	fc0792e3          	bnez	a5,80200f0c <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    80200f4c:	f8c42783          	lw	a5,-116(s0)
    80200f50:	00078713          	mv	a4,a5
    80200f54:	fff00793          	li	a5,-1
    80200f58:	02f71663          	bne	a4,a5,80200f84 <vprintfmt+0x3dc>
    80200f5c:	f8344783          	lbu	a5,-125(s0)
    80200f60:	02078263          	beqz	a5,80200f84 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    80200f64:	f8842703          	lw	a4,-120(s0)
    80200f68:	fa644783          	lbu	a5,-90(s0)
    80200f6c:	0007879b          	sext.w	a5,a5
    80200f70:	0017979b          	slliw	a5,a5,0x1
    80200f74:	0007879b          	sext.w	a5,a5
    80200f78:	40f707bb          	subw	a5,a4,a5
    80200f7c:	0007879b          	sext.w	a5,a5
    80200f80:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80200f84:	f8842703          	lw	a4,-120(s0)
    80200f88:	fa644783          	lbu	a5,-90(s0)
    80200f8c:	0007879b          	sext.w	a5,a5
    80200f90:	0017979b          	slliw	a5,a5,0x1
    80200f94:	0007879b          	sext.w	a5,a5
    80200f98:	40f707bb          	subw	a5,a4,a5
    80200f9c:	0007871b          	sext.w	a4,a5
    80200fa0:	fdc42783          	lw	a5,-36(s0)
    80200fa4:	f8f42a23          	sw	a5,-108(s0)
    80200fa8:	f8c42783          	lw	a5,-116(s0)
    80200fac:	f8f42823          	sw	a5,-112(s0)
    80200fb0:	f9442783          	lw	a5,-108(s0)
    80200fb4:	00078593          	mv	a1,a5
    80200fb8:	f9042783          	lw	a5,-112(s0)
    80200fbc:	00078613          	mv	a2,a5
    80200fc0:	0006069b          	sext.w	a3,a2
    80200fc4:	0005879b          	sext.w	a5,a1
    80200fc8:	00f6d463          	bge	a3,a5,80200fd0 <vprintfmt+0x428>
    80200fcc:	00058613          	mv	a2,a1
    80200fd0:	0006079b          	sext.w	a5,a2
    80200fd4:	40f707bb          	subw	a5,a4,a5
    80200fd8:	fcf42c23          	sw	a5,-40(s0)
    80200fdc:	0280006f          	j	80201004 <vprintfmt+0x45c>
                    putch(' ');
    80200fe0:	f5843783          	ld	a5,-168(s0)
    80200fe4:	02000513          	li	a0,32
    80200fe8:	000780e7          	jalr	a5
                    ++written;
    80200fec:	fec42783          	lw	a5,-20(s0)
    80200ff0:	0017879b          	addiw	a5,a5,1
    80200ff4:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80200ff8:	fd842783          	lw	a5,-40(s0)
    80200ffc:	fff7879b          	addiw	a5,a5,-1
    80201000:	fcf42c23          	sw	a5,-40(s0)
    80201004:	fd842783          	lw	a5,-40(s0)
    80201008:	0007879b          	sext.w	a5,a5
    8020100c:	fcf04ae3          	bgtz	a5,80200fe0 <vprintfmt+0x438>
                }

                if (prefix) {
    80201010:	fa644783          	lbu	a5,-90(s0)
    80201014:	0ff7f793          	zext.b	a5,a5
    80201018:	04078463          	beqz	a5,80201060 <vprintfmt+0x4b8>
                    putch('0');
    8020101c:	f5843783          	ld	a5,-168(s0)
    80201020:	03000513          	li	a0,48
    80201024:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    80201028:	f5043783          	ld	a5,-176(s0)
    8020102c:	0007c783          	lbu	a5,0(a5)
    80201030:	00078713          	mv	a4,a5
    80201034:	05800793          	li	a5,88
    80201038:	00f71663          	bne	a4,a5,80201044 <vprintfmt+0x49c>
    8020103c:	05800793          	li	a5,88
    80201040:	0080006f          	j	80201048 <vprintfmt+0x4a0>
    80201044:	07800793          	li	a5,120
    80201048:	f5843703          	ld	a4,-168(s0)
    8020104c:	00078513          	mv	a0,a5
    80201050:	000700e7          	jalr	a4
                    written += 2;
    80201054:	fec42783          	lw	a5,-20(s0)
    80201058:	0027879b          	addiw	a5,a5,2
    8020105c:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    80201060:	fdc42783          	lw	a5,-36(s0)
    80201064:	fcf42a23          	sw	a5,-44(s0)
    80201068:	0280006f          	j	80201090 <vprintfmt+0x4e8>
                    putch('0');
    8020106c:	f5843783          	ld	a5,-168(s0)
    80201070:	03000513          	li	a0,48
    80201074:	000780e7          	jalr	a5
                    ++written;
    80201078:	fec42783          	lw	a5,-20(s0)
    8020107c:	0017879b          	addiw	a5,a5,1
    80201080:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    80201084:	fd442783          	lw	a5,-44(s0)
    80201088:	0017879b          	addiw	a5,a5,1
    8020108c:	fcf42a23          	sw	a5,-44(s0)
    80201090:	f8c42703          	lw	a4,-116(s0)
    80201094:	fd442783          	lw	a5,-44(s0)
    80201098:	0007879b          	sext.w	a5,a5
    8020109c:	fce7c8e3          	blt	a5,a4,8020106c <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    802010a0:	fdc42783          	lw	a5,-36(s0)
    802010a4:	fff7879b          	addiw	a5,a5,-1
    802010a8:	fcf42823          	sw	a5,-48(s0)
    802010ac:	03c0006f          	j	802010e8 <vprintfmt+0x540>
                    putch(buf[i]);
    802010b0:	fd042783          	lw	a5,-48(s0)
    802010b4:	ff078793          	addi	a5,a5,-16
    802010b8:	008787b3          	add	a5,a5,s0
    802010bc:	f807c783          	lbu	a5,-128(a5)
    802010c0:	0007871b          	sext.w	a4,a5
    802010c4:	f5843783          	ld	a5,-168(s0)
    802010c8:	00070513          	mv	a0,a4
    802010cc:	000780e7          	jalr	a5
                    ++written;
    802010d0:	fec42783          	lw	a5,-20(s0)
    802010d4:	0017879b          	addiw	a5,a5,1
    802010d8:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    802010dc:	fd042783          	lw	a5,-48(s0)
    802010e0:	fff7879b          	addiw	a5,a5,-1
    802010e4:	fcf42823          	sw	a5,-48(s0)
    802010e8:	fd042783          	lw	a5,-48(s0)
    802010ec:	0007879b          	sext.w	a5,a5
    802010f0:	fc07d0e3          	bgez	a5,802010b0 <vprintfmt+0x508>
                }

                flags.in_format = false;
    802010f4:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    802010f8:	2700006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    802010fc:	f5043783          	ld	a5,-176(s0)
    80201100:	0007c783          	lbu	a5,0(a5)
    80201104:	00078713          	mv	a4,a5
    80201108:	06400793          	li	a5,100
    8020110c:	02f70663          	beq	a4,a5,80201138 <vprintfmt+0x590>
    80201110:	f5043783          	ld	a5,-176(s0)
    80201114:	0007c783          	lbu	a5,0(a5)
    80201118:	00078713          	mv	a4,a5
    8020111c:	06900793          	li	a5,105
    80201120:	00f70c63          	beq	a4,a5,80201138 <vprintfmt+0x590>
    80201124:	f5043783          	ld	a5,-176(s0)
    80201128:	0007c783          	lbu	a5,0(a5)
    8020112c:	00078713          	mv	a4,a5
    80201130:	07500793          	li	a5,117
    80201134:	08f71063          	bne	a4,a5,802011b4 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    80201138:	f8144783          	lbu	a5,-127(s0)
    8020113c:	00078c63          	beqz	a5,80201154 <vprintfmt+0x5ac>
    80201140:	f4843783          	ld	a5,-184(s0)
    80201144:	00878713          	addi	a4,a5,8
    80201148:	f4e43423          	sd	a4,-184(s0)
    8020114c:	0007b783          	ld	a5,0(a5)
    80201150:	0140006f          	j	80201164 <vprintfmt+0x5bc>
    80201154:	f4843783          	ld	a5,-184(s0)
    80201158:	00878713          	addi	a4,a5,8
    8020115c:	f4e43423          	sd	a4,-184(s0)
    80201160:	0007a783          	lw	a5,0(a5)
    80201164:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    80201168:	fa843583          	ld	a1,-88(s0)
    8020116c:	f5043783          	ld	a5,-176(s0)
    80201170:	0007c783          	lbu	a5,0(a5)
    80201174:	0007871b          	sext.w	a4,a5
    80201178:	07500793          	li	a5,117
    8020117c:	40f707b3          	sub	a5,a4,a5
    80201180:	00f037b3          	snez	a5,a5
    80201184:	0ff7f793          	zext.b	a5,a5
    80201188:	f8040713          	addi	a4,s0,-128
    8020118c:	00070693          	mv	a3,a4
    80201190:	00078613          	mv	a2,a5
    80201194:	f5843503          	ld	a0,-168(s0)
    80201198:	f08ff0ef          	jal	ra,802008a0 <print_dec_int>
    8020119c:	00050793          	mv	a5,a0
    802011a0:	fec42703          	lw	a4,-20(s0)
    802011a4:	00f707bb          	addw	a5,a4,a5
    802011a8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    802011ac:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    802011b0:	1b80006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    802011b4:	f5043783          	ld	a5,-176(s0)
    802011b8:	0007c783          	lbu	a5,0(a5)
    802011bc:	00078713          	mv	a4,a5
    802011c0:	06e00793          	li	a5,110
    802011c4:	04f71c63          	bne	a4,a5,8020121c <vprintfmt+0x674>
                if (flags.longflag) {
    802011c8:	f8144783          	lbu	a5,-127(s0)
    802011cc:	02078463          	beqz	a5,802011f4 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    802011d0:	f4843783          	ld	a5,-184(s0)
    802011d4:	00878713          	addi	a4,a5,8
    802011d8:	f4e43423          	sd	a4,-184(s0)
    802011dc:	0007b783          	ld	a5,0(a5)
    802011e0:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    802011e4:	fec42703          	lw	a4,-20(s0)
    802011e8:	fb043783          	ld	a5,-80(s0)
    802011ec:	00e7b023          	sd	a4,0(a5)
    802011f0:	0240006f          	j	80201214 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    802011f4:	f4843783          	ld	a5,-184(s0)
    802011f8:	00878713          	addi	a4,a5,8
    802011fc:	f4e43423          	sd	a4,-184(s0)
    80201200:	0007b783          	ld	a5,0(a5)
    80201204:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    80201208:	fb843783          	ld	a5,-72(s0)
    8020120c:	fec42703          	lw	a4,-20(s0)
    80201210:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    80201214:	f8040023          	sb	zero,-128(s0)
    80201218:	1500006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    8020121c:	f5043783          	ld	a5,-176(s0)
    80201220:	0007c783          	lbu	a5,0(a5)
    80201224:	00078713          	mv	a4,a5
    80201228:	07300793          	li	a5,115
    8020122c:	02f71e63          	bne	a4,a5,80201268 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    80201230:	f4843783          	ld	a5,-184(s0)
    80201234:	00878713          	addi	a4,a5,8
    80201238:	f4e43423          	sd	a4,-184(s0)
    8020123c:	0007b783          	ld	a5,0(a5)
    80201240:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    80201244:	fc043583          	ld	a1,-64(s0)
    80201248:	f5843503          	ld	a0,-168(s0)
    8020124c:	dccff0ef          	jal	ra,80200818 <puts_wo_nl>
    80201250:	00050793          	mv	a5,a0
    80201254:	fec42703          	lw	a4,-20(s0)
    80201258:	00f707bb          	addw	a5,a4,a5
    8020125c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201260:	f8040023          	sb	zero,-128(s0)
    80201264:	1040006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    80201268:	f5043783          	ld	a5,-176(s0)
    8020126c:	0007c783          	lbu	a5,0(a5)
    80201270:	00078713          	mv	a4,a5
    80201274:	06300793          	li	a5,99
    80201278:	02f71e63          	bne	a4,a5,802012b4 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    8020127c:	f4843783          	ld	a5,-184(s0)
    80201280:	00878713          	addi	a4,a5,8
    80201284:	f4e43423          	sd	a4,-184(s0)
    80201288:	0007a783          	lw	a5,0(a5)
    8020128c:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    80201290:	fcc42703          	lw	a4,-52(s0)
    80201294:	f5843783          	ld	a5,-168(s0)
    80201298:	00070513          	mv	a0,a4
    8020129c:	000780e7          	jalr	a5
                ++written;
    802012a0:	fec42783          	lw	a5,-20(s0)
    802012a4:	0017879b          	addiw	a5,a5,1
    802012a8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    802012ac:	f8040023          	sb	zero,-128(s0)
    802012b0:	0b80006f          	j	80201368 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    802012b4:	f5043783          	ld	a5,-176(s0)
    802012b8:	0007c783          	lbu	a5,0(a5)
    802012bc:	00078713          	mv	a4,a5
    802012c0:	02500793          	li	a5,37
    802012c4:	02f71263          	bne	a4,a5,802012e8 <vprintfmt+0x740>
                putch('%');
    802012c8:	f5843783          	ld	a5,-168(s0)
    802012cc:	02500513          	li	a0,37
    802012d0:	000780e7          	jalr	a5
                ++written;
    802012d4:	fec42783          	lw	a5,-20(s0)
    802012d8:	0017879b          	addiw	a5,a5,1
    802012dc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    802012e0:	f8040023          	sb	zero,-128(s0)
    802012e4:	0840006f          	j	80201368 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    802012e8:	f5043783          	ld	a5,-176(s0)
    802012ec:	0007c783          	lbu	a5,0(a5)
    802012f0:	0007871b          	sext.w	a4,a5
    802012f4:	f5843783          	ld	a5,-168(s0)
    802012f8:	00070513          	mv	a0,a4
    802012fc:	000780e7          	jalr	a5
                ++written;
    80201300:	fec42783          	lw	a5,-20(s0)
    80201304:	0017879b          	addiw	a5,a5,1
    80201308:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    8020130c:	f8040023          	sb	zero,-128(s0)
    80201310:	0580006f          	j	80201368 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    80201314:	f5043783          	ld	a5,-176(s0)
    80201318:	0007c783          	lbu	a5,0(a5)
    8020131c:	00078713          	mv	a4,a5
    80201320:	02500793          	li	a5,37
    80201324:	02f71063          	bne	a4,a5,80201344 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    80201328:	f8043023          	sd	zero,-128(s0)
    8020132c:	f8043423          	sd	zero,-120(s0)
    80201330:	00100793          	li	a5,1
    80201334:	f8f40023          	sb	a5,-128(s0)
    80201338:	fff00793          	li	a5,-1
    8020133c:	f8f42623          	sw	a5,-116(s0)
    80201340:	0280006f          	j	80201368 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    80201344:	f5043783          	ld	a5,-176(s0)
    80201348:	0007c783          	lbu	a5,0(a5)
    8020134c:	0007871b          	sext.w	a4,a5
    80201350:	f5843783          	ld	a5,-168(s0)
    80201354:	00070513          	mv	a0,a4
    80201358:	000780e7          	jalr	a5
            ++written;
    8020135c:	fec42783          	lw	a5,-20(s0)
    80201360:	0017879b          	addiw	a5,a5,1
    80201364:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    80201368:	f5043783          	ld	a5,-176(s0)
    8020136c:	00178793          	addi	a5,a5,1
    80201370:	f4f43823          	sd	a5,-176(s0)
    80201374:	f5043783          	ld	a5,-176(s0)
    80201378:	0007c783          	lbu	a5,0(a5)
    8020137c:	84079ce3          	bnez	a5,80200bd4 <vprintfmt+0x2c>
        }
    }

    return written;
    80201380:	fec42783          	lw	a5,-20(s0)
}
    80201384:	00078513          	mv	a0,a5
    80201388:	0b813083          	ld	ra,184(sp)
    8020138c:	0b013403          	ld	s0,176(sp)
    80201390:	0c010113          	addi	sp,sp,192
    80201394:	00008067          	ret

0000000080201398 <printk>:

int printk(const char* s, ...) {
    80201398:	f9010113          	addi	sp,sp,-112
    8020139c:	02113423          	sd	ra,40(sp)
    802013a0:	02813023          	sd	s0,32(sp)
    802013a4:	03010413          	addi	s0,sp,48
    802013a8:	fca43c23          	sd	a0,-40(s0)
    802013ac:	00b43423          	sd	a1,8(s0)
    802013b0:	00c43823          	sd	a2,16(s0)
    802013b4:	00d43c23          	sd	a3,24(s0)
    802013b8:	02e43023          	sd	a4,32(s0)
    802013bc:	02f43423          	sd	a5,40(s0)
    802013c0:	03043823          	sd	a6,48(s0)
    802013c4:	03143c23          	sd	a7,56(s0)
    int res = 0;
    802013c8:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    802013cc:	04040793          	addi	a5,s0,64
    802013d0:	fcf43823          	sd	a5,-48(s0)
    802013d4:	fd043783          	ld	a5,-48(s0)
    802013d8:	fc878793          	addi	a5,a5,-56
    802013dc:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    802013e0:	fe043783          	ld	a5,-32(s0)
    802013e4:	00078613          	mv	a2,a5
    802013e8:	fd843583          	ld	a1,-40(s0)
    802013ec:	fffff517          	auipc	a0,0xfffff
    802013f0:	11850513          	addi	a0,a0,280 # 80200504 <putc>
    802013f4:	fb4ff0ef          	jal	ra,80200ba8 <vprintfmt>
    802013f8:	00050793          	mv	a5,a0
    802013fc:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    80201400:	fec42783          	lw	a5,-20(s0)
}
    80201404:	00078513          	mv	a0,a5
    80201408:	02813083          	ld	ra,40(sp)
    8020140c:	02013403          	ld	s0,32(sp)
    80201410:	07010113          	addi	sp,sp,112
    80201414:	00008067          	ret
