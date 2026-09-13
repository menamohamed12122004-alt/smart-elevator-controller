#ifndef TIMER_PRIVATE_H
#define TIMER_PRIVATE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — TIMER private layer (ATmega32)
 * Include this file ONLY from TIMER.c.
 *
 * What you must add here:
 * 1. Timer0 registers (I/O space):
 *      TCCR0  0x53    FOC0 WGM00 COM01 COM00 WGM01 CS02 CS01 CS00
 *      TCNT0  0x52
 *      OCR0   0x5C
 * 2. Timer1 registers:
 *      TCCR1A 0x4F    COM1A1 COM1A0 COM1B1 COM1B0 FOC1A FOC1B WGM11 WGM10
 *      TCCR1B 0x4E    ICNC1  ICES1  – WGM13 WGM12 CS12 CS11 CS10
 *      TCNT1  0x4C    (16-bit, write high byte first)
 *      OCR1A  0x4A
 *      ICR1   0x46
 * 3. Shared:
 *      TIMSK  0x59    OCIE2 TOIE2 TICIE1 OCIE1A OCIE1B TOIE1 OCIE0 TOIE0
 *      TIFR   0x58    matching flags — write 1 to clear
 *
 * 4. Bit-position macros for WGM, CS, COM, TOIE0, OCIE0, OCF0, TOV0.
 *
 * 5. Remember: a flag is cleared by writing 1 to it (w1c).
 */
#define TIMER0_REG_TCCR0  (*(volatile uint8*)0x53)
#define TIMER0_REG_TCNT0  (*(volatile uint8*)0x52)
#define TIMER0_REG_OCR0   (*(volatile uint8*)0x5C)

#define TIMER1_REG_TCCR1A (*(volatile uint8*)0x4F)
#define TIMER1_REG_TCCR1B (*(volatile uint8*)0x4E)
#define TIMER1_REG_TCNT1  (*(volatile uint16*)0x4C)
#define TIMER1_REG_OCR1A  (*(volatile uint16*)0x4A)
#define TIMER1_REG_ICR1   (*(volatile uint16*)0x46)

#define TIMSK_REG         (*(volatile uint8*)0x59)
#define TIFR_REG          (*(volatile uint8*)0x58)

/* TODO: map the bit names for each register. */

#endif /* TIMER_PRIVATE_H */
