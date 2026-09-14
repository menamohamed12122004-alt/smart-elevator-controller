#ifndef EXTI_PRIVATE_H
#define EXTI_PRIVATE_H

/*
 * Author: Menna Allah (Elevator Controller Project PRJ-08-ELEVATOR)
 * MCAL EXTI — Private Hardware Registers
 * Include ONLY inside EXTI.c
 */

/* ---------------- Memory-Mapped Hardware Registers ---------------- */
#define EXTI_MCUCR   (*(volatile uint8 *)0x55)  /* MCU Control Register (INT0 & INT1 Sense Control) */
#define EXTI_MCUCSR  (*(volatile uint8 *)0x54)  /* MCU Control and Status Register (INT2 Sense Control) */
#define EXTI_GICR    (*(volatile uint8 *)0x5B)  /* General Interrupt Control Register (PIE Bits) */
#define EXTI_GIFR    (*(volatile uint8 *)0x5A)  /* General Interrupt Flag Register */
#define EXTI_SREG    (*(volatile uint8 *)0x5F)  /* Status Register (Global Interrupt Enable - I bit) */

/* DDRD and PORTD Register Definitions for Pin Direction Control */
#define EXTI_DDRD    (*(volatile uint8 *)0x31)
#define EXTI_PORTD   (*(volatile uint8 *)0x32)

/* ---------------- MCUCR Bit Positions ---------------- */
#define MCUCR_ISC00  0
#define MCUCR_ISC01  1
#define MCUCR_ISC10  2
#define MCUCR_ISC11  3

/* ---------------- MCUCSR Bit Positions ---------------- */
#define MCUCSR_ISC2  6

/* ---------------- GICR Bit Positions ---------------- */
#define GICR_INT1    7
#define GICR_INT0    6
#define GICR_INT2    5

/* ---------------- SREG Bit Positions ---------------- */
#define SREG_I_BIT   7

/* ---------------- Interrupt Vector Macros for ATmega32 ---------------- */
#define ISR_INT0     __vector_1
#define ISR_INT1     __vector_2
#define ISR_INT2     __vector_3

/* ISR Attribute Function Standard Prototype */
#define ISR(vector) \
    void vector (void) __attribute__ ((signal, used)); \
    void vector (void)

#endif /* EXTI_PRIVATE_H */
