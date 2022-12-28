/*
 * CP15 Barrier instructions
 * Please note that we have separate barrier instructions in ARMv7
 * However, we use the CP15 based instructtions because we use
 * -march=armv5 in U-Boot
 */
//1295 + armv7 implies armv8 aarch32 mode

//#ifdef __ARM_ARCH_8A__
#if 1
#define CP15ISB	asm volatile ("ISB SY" : : : "memory")
#define CP15DSB	asm volatile ("DSB SY" : : : "memory")
#define CP15DMB	asm volatile ("DMB SY" : : : "memory")
#else
#define CP15ISB	asm volatile ("mcr     p15, 0, %0, c7, c5, 4" : : "r" (0))
#define CP15DSB	asm volatile ("mcr     p15, 0, %0, c7, c10, 4" : : "r" (0))
#define CP15DMB	asm volatile ("mcr     p15, 0, %0, c7, c10, 5" : : "r" (0))
#endif
#define isb() __asm__ __volatile__ ("" : : : "memory")
#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
