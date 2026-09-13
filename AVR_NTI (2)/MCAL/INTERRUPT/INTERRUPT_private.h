#ifndef INTERRUPT_PRIVATE_H
#define INTERRUPT_PRIVATE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — INTERRUPT private layer (ATmega32)
 * Include this file ONLY from INTERRUPT.c.
 *
 * What you must add here:
 * 1. Registers:
 *      MCUCR   0x55    ISC11 ISC10 ISC01 ISC00
 *      MCUCSR  0x54    ISC2 is bit 6
 *      GICR    0x5B    INT1=7 INT0=6 INT2=5
 *      GIFR    0x5A    INTF1=7 INTF0=6 INTF2=5   (write 1 to clear)
 *      SREG    0x5F    I-bit is bit 7
 *
 * 2. Sense-bit mapping:
 *      INT0 : ISC01 ISC00 in MCUCR
 *      INT1 : ISC11 ISC10 in MCUCR
 *      INT2 : ISC2 in MCUCSR   (0 = falling, 1 = rising) — no low-level / any-change
 *
 * 3. Optional: a small static helper that writes the two ISC bits for INT0/INT1,
 *    and one that maps a source to its GICR / GIFR bit number.
 *
 * 4. The ISR bodies (INT0_vect, INT1_vect, INT2_vect) live in INTERRUPT.c, not
 *    here — a vector defined in a header would be duplicated in every file that
 *    includes it. This driver owns those vectors: each one only calls the
 *    callback that EXTI_SetCallback registered, after testing it against NULL.
 *    The application never writes ISR(INTx_vect) itself.
 */

 #define INTERRUPT_REG_MCUCR   (*(volatile uint8*)0x55)
 #define INTERRUPT_REG_MCUCSR  (*(volatile uint8*)0x54)
 #define INTERRUPT_REG_GICR    (*(volatile uint8*)0x5B)
 #define INTERRUPT_REG_GIFR    (*(volatile uint8*)0x5A)
 #define INTERRUPT_REG_SREG    (*(volatile uint8*)0x5F)
 
/* TODO: map MCUCR, MCUCSR, GICR, GIFR, SREG and the bit names. */

#endif /* INTERRUPT_PRIVATE_H */
