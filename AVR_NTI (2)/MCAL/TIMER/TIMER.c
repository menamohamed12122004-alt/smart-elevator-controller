/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — TIMER.c  (ATmega32 Timer0 + Timer1, F_CPU = 8 MHz)
 * Implement every prototype from TIMER_interface.h.
 *
 * Rules for this file:
 *   - The application only ever sees what TIMER_interface.h declares.
 *   - Anything only this file needs is static, so no other .c can reach it.
 *   - Register names and bit numbers come from TIMER_private.h. Fill that in
 *     first, or nothing here will compile.
 *
 * Numbers you will need, all at 8 MHz:
 *   prescaler 64 -> 1 tick = 8 us      prescaler 8 -> 1 tick = 1 us
 *   A flag in TIFR is cleared by writing 1 to it, not 0.
 */

#include "STD_TYPES.h"
#include "TIMER_interface.h"
#include "TIMER_private.h"

/*==================================================================
 *  Local helpers — static, used only inside TIMER.c
 *==================================================================*/

static void TIMER_WaitFlag(volatile uint8 *Copy_pu8Register, uint8 Copy_u8BitMask)
{
    while ((*Copy_pu8Register & Copy_u8BitMask) == 0u)
    {
    }

    *Copy_pu8Register = Copy_u8BitMask;
}

static uint16 TIMER_DutyToCompare(uint16 Copy_u16Top, uint8 Copy_u8DutyPercent)
{
    return (uint16)(((uint32)(Copy_u16Top + 1u) * Copy_u8DutyPercent) / 100u);
}

/*==================================================================
 *  Timer0 — 8-bit
 *==================================================================*/

STD_ReturnType TIMER0_Init(void)
{
    TIMER0_REG_TCCR0 = (1u << TIMER0_WGM01);
    TIMER0_REG_OCR0 = 124u;
    TIMER0_REG_TCNT0 = 0u;
    return E_OK;
}

STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds)
{
    uint16 Local_u16Index;

    TIFR_REG = (1u << TIMER_OCF0);
    TIMER0_REG_TCCR0 &= ~((1u << TIMER0_CS02) | (1u << TIMER0_CS01) | (1u << TIMER0_CS00));
    TIMER0_REG_TCCR0 |= (1u << TIMER0_CS01) | (1u << TIMER0_CS00);

    for (Local_u16Index = 0u; Local_u16Index < Copy_u16Milliseconds; Local_u16Index++)
    {
        TIMER_WaitFlag(&TIFR_REG, (1u << TIMER_OCF0));
    }

    TIMER0_REG_TCCR0 &= ~((1u << TIMER0_CS02) | (1u << TIMER0_CS01) | (1u << TIMER0_CS00));
    return E_OK;
}

STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds)
{
    uint16 Local_u16Index;

    for (Local_u16Index = 0u; Local_u16Index < Copy_u16Seconds; Local_u16Index++)
    {
        TIMER0_DelayMS(1000u);
    }

    return E_OK;
}

STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent)
{
    if (Copy_u8DutyPercent > 100u)
    {
        return E_NOK;
    }

    TIMER_DDRB |= (1u << TIMER_PB3);
    TIMER0_REG_TCCR0 = (1u << TIMER0_WGM01) | (1u << TIMER0_WGM00) | (1u << TIMER0_COM01);
    TIMER0_REG_OCR0 = TIMER_DutyToCompare(255u, Copy_u8DutyPercent);
    TIMER0_REG_TCCR0 |= (1u << TIMER0_CS01) | (1u << TIMER0_CS00);

    return E_OK;
}

STD_ReturnType TIMER0_Stop(void)
{
    TIMER0_REG_TCCR0 &= ~((1u << TIMER0_CS02) | (1u << TIMER0_CS01) | (1u << TIMER0_CS00));
    TIMER0_REG_TCCR0 &= ~((1u << TIMER0_COM01) | (1u << TIMER0_COM00));
    return E_OK;
}

/*==================================================================
 *  Timer1 — 16-bit
 *==================================================================*/

STD_ReturnType TIMER1_Init(void)
{
    TIMER1_REG_TCCR1A &= ~((1u << TIMER1_WGM11) | (1u << TIMER1_WGM10));
    TIMER1_REG_TCCR1B &= ~(1u << TIMER1_WGM13);
    TIMER1_REG_TCCR1B |= (1u << TIMER1_WGM12);
    TIMER1_REG_OCR1A = 999u;
    TIMER1_REG_TCNT1 = 0u;
    TIMER1_REG_TCCR1B &= ~((1u << TIMER1_CS12) | (1u << TIMER1_CS11) | (1u << TIMER1_CS10));
    return E_OK;
}

STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds)
{
    uint16 Local_u16Index;

    TIFR_REG = (1u << TIMER_OCF1A);
    TIMER1_REG_TCCR1B &= ~((1u << TIMER1_CS12) | (1u << TIMER1_CS11) | (1u << TIMER1_CS10));
    TIMER1_REG_TCCR1B |= (1u << TIMER1_CS11);

    for (Local_u16Index = 0u; Local_u16Index < Copy_u16Milliseconds; Local_u16Index++)
    {
        TIMER_WaitFlag(&TIFR_REG, (1u << TIMER_OCF1A));
    }

    TIMER1_REG_TCCR1B &= ~((1u << TIMER1_CS12) | (1u << TIMER1_CS11) | (1u << TIMER1_CS10));
    return E_OK;
}

STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent)
{
    uint32 Local_u32Period;

    if ((Copy_u8DutyPercent > 100u) || (Copy_u16FrequencyHz < 16u) || (Copy_u16FrequencyHz > 20000u))
    {
        return E_NOK;
    }

    TIMER_DDRD |= (1u << TIMER_PD5);
    TIMER1_REG_TCCR1A = (1u << TIMER1_COM1A1) | (1u << TIMER1_WGM11);
    TIMER1_REG_TCCR1B = (1u << TIMER1_WGM13) | (1u << TIMER1_WGM12) | (1u << TIMER1_CS11);

    Local_u32Period = (1000000UL / (uint32)Copy_u16FrequencyHz) - 1UL;
    TIMER1_REG_ICR1 = (uint16)Local_u32Period;
    TIMER1_REG_OCR1A = TIMER_DutyToCompare(TIMER1_REG_ICR1, Copy_u8DutyPercent);

    return E_OK;
}

STD_ReturnType TIMER1_Stop(void)
{
    TIMER1_REG_TCCR1B &= ~((1u << TIMER1_CS12) | (1u << TIMER1_CS11) | (1u << TIMER1_CS10));
    TIMER1_REG_TCCR1A &= ~((1u << TIMER1_COM1A1) | (1u << TIMER1_COM1A0));
    return E_OK;
}

