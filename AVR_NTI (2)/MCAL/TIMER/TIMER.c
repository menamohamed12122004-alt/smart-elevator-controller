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

/*
 * TIMER_WaitFlag
 * 1. Sit in an empty while loop until the bit Copy_u8BitMask is set in the
 *    register Copy_pu8Register (that register is TIFR).
 * 2. Clear the flag by writing 1 to that bit, so the next period starts clean.
 * 3. Both delay functions call this, which is the whole reason it exists —
 *    the wait-then-clear pattern is written once and cannot drift apart.
 */
static void TIMER_WaitFlag(volatile uint8 *Copy_pu8Register, uint8 Copy_u8BitMask);

/*
 * TIMER_DutyToCompare
 * 1. Turn a 0..100 percent into a compare value: (Top + 1) * percent / 100.
 * 2. Do the multiply in uint32. Timer1 can reach 20000 * 100 = 2,000,000,
 *    which overflows uint16 long before the divide happens.
 * 3. Return the result; the caller writes it to OCR0 or OCR1A.
 */
static uint16 TIMER_DutyToCompare(uint16 Copy_u16Top, uint8 Copy_u8DutyPercent);

/*==================================================================
 *  Timer0 — 8-bit
 *==================================================================*/

STD_ReturnType TIMER0_Init(void)
{
    /*
     * Goal: one compare match every 1 ms.
     * 1. Select CTC mode in TCCR0: WGM01 = 1 , WGM00 = 0.
     *    Careful — WGM00 is bit 6 and WGM01 is bit 3. They are not adjacent.
     * 2. OCR0 = 124. With prescaler 64 a tick is 8 us, and the counter clears
     *    after OCR0 + 1 = 125 ticks, so 125 * 8 us = 1 ms exactly.
     * 3. Clear TCNT0 so the first millisecond is a full one.
     * 4. Leave the clock stopped (CS02:0 = 000). The delay functions start it.
     * 5. Return E_OK.
     */
     

     // Seolect CTC mode 
    TIMER0_REG_TCCR0 = (1 << 3) | (0 << 6); // Set WGM01 to 1 and WGM00 to 0 for CTC mode
    TIMER0_REG_OCR0 = 124; // Set compare value for 1 ms delay
    TIMER0_REG_TCNT0 = 0; // Clear timer counter

    return E_OK;
}

STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds)
{
    /*
     * 1. Clear a stale OCF0 in TIFR before starting, or the first millisecond
     *    ends instantly on an old flag left over from last time.
     * 2. Start the clock: CS02:0 = prescaler 64.
     * 3. Loop Copy_u16Milliseconds times, calling TIMER_WaitFlag on OCF0 —
     *    each pass through the loop is one millisecond.
     * 4. Stop the clock when the loop ends, so the timer is not left running.
     * 5. Return E_OK.
     * 6. This blocks: nothing else in main runs while it counts.
     */

    // Clear stale OCF0 flag
    TIFR_REG |= (1 << 1); // Clear OCF0 flag by
    // prescaler 64 -> CS02:0 = 011
    TIMER0_REG_TCCR0 |= (1 << 0) | (1 << 1); // Start the clock with prescaler 64
    // Loop for the specified number of milliseconds
    for (uint16 i = 0; i < Copy_u16Milliseconds; i++){
        TIMER_WaitFlag(&TIFR_REG, (1 << 1)); // Wait for OCF0 flag
    }
    // Stop the clock
    TIMER0_REG_TCCR0 &= ~((1 << 2) | (1 << 1) | (1 << 0)); // Stop the clock

    return E_OK;
}

STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds)
{
    /*
     * 1. Loop Copy_u16Seconds times and call TIMER0_DelayMS(1000) each pass.
     * 2. Do not try 1000 * seconds in one call — the argument is uint16 and
     *    anything past 65 seconds would wrap round to a short delay.
     * 3. Return E_OK.
     */
}

STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent)
{
    /*
     * 1. Return E_NOK if Copy_u8DutyPercent is above 100.
     * 2. Make PB3 an output — the compare unit cannot drive a pin that DDRB
     *    still calls an input, and this is the usual reason "PWM does nothing".
     * 3. Fast PWM in TCCR0: WGM01 = 1 , WGM00 = 1.
     * 4. Non-inverting output: COM01 = 1 , COM00 = 0 (TCCR0 bits 5 and 4).
     *    The pin goes high at BOTTOM and low on the compare match.
     * 5. OCR0 = TIMER_DutyToCompare(255, Copy_u8DutyPercent).
     * 6. Start the clock with prescaler 64 and return E_OK.
     *    Frequency = 8 MHz / (64 * 256) = 488 Hz, fine for an LED or a motor.
     * 7. Known quirk to expect on the scope: 0% still emits a one-tick spike
     *    each period. For a true off, call TIMER0_Stop instead.
     */
}

STD_ReturnType TIMER0_Stop(void)
{
    /*
     * 1. Clear CS02:0 in TCCR0 — the counter freezes.
     * 2. Clear COM01:COM00 as well, which hands PB3 back to GPIO. Without this
     *    the pin keeps whatever level the compare unit left on it.
     * 3. Return E_OK.
     */
}

/*==================================================================
 *  Timer1 — 16-bit
 *==================================================================*/

STD_ReturnType TIMER1_Init(void)
{
    /*
     * Goal: one compare match every 1 ms, same idea as Timer0.
     * 1. CTC with TOP = OCR1A is mode 4, so WGM13:0 = 0100. The bits are split:
     *      WGM11 , WGM10 -> TCCR1A bits 1 and 0   (both 0 here)
     *      WGM13 , WGM12 -> TCCR1B bits 4 and 3   (0 and 1 here)
     * 2. OCR1A = 999. With prescaler 8 a tick is 1 us, so 1000 ticks = 1 ms.
     * 3. Clear TCNT1 and leave the clock stopped.
     * 4. Return E_OK.
     */
}

STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds)
{
    /*
     * 1. Same shape as TIMER0_DelayMS, but the flag is OCF1A in TIFR.
     * 2. Clear the stale flag, start prescaler 8, loop calling TIMER_WaitFlag,
     *    then stop the clock.
     * 3. Return E_OK.
     */
}

STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent)
{
    /*
     * 1. Return E_NOK if the duty is above 100, or the frequency is outside
     *    16 .. 20000 Hz. Below 16 Hz the ICR1 value in step 4 will not fit.
     * 2. Make PD5 an output.
     * 3. Fast PWM with TOP = ICR1 is mode 14, so WGM13:0 = 1110:
     *      TCCR1A: WGM11 = 1 , WGM10 = 0
     *      TCCR1B: WGM13 = 1 , WGM12 = 1
     *    Non-inverting on channel A: COM1A1 = 1 , COM1A0 = 0 (TCCR1A bits 7, 6).
     * 4. With prescaler 8 a tick is 1 us, so one period needs
     *      ICR1 = (1000000UL / Copy_u16FrequencyHz) - 1
     *    Write the UL — 1000000 does not fit in the 16-bit int avr-gcc would
     *    otherwise use, and the result would be nonsense.
     * 5. OCR1A = TIMER_DutyToCompare(ICR1, Copy_u8DutyPercent).
     * 6. Start the clock with prescaler 8 and return E_OK.
     * 7. Servo check: 50 Hz gives ICR1 = 19999, so one tick is 1 us and a
     *    1..2 ms pulse is a compare value of 1000..2000.
     */
}

STD_ReturnType TIMER1_Stop(void)
{
    /*
     * 1. Clear CS12:0 in TCCR1B.
     * 2. Clear COM1A1:COM1A0 in TCCR1A to hand PD5 back to GPIO.
     * 3. Return E_OK.
     */
}

/*==================================================================
 *  Local helper bodies
 *==================================================================*/

static void TIMER_WaitFlag(volatile uint8 *Copy_pu8Register, uint8 Copy_u8BitMask)
{
    /*
     * 1. while ((*Copy_pu8Register & Copy_u8BitMask) == 0) { }  — spin until set.
     * 2. Then write 1 to that bit to clear it: *Copy_pu8Register = Copy_u8BitMask.
     *    Plain assignment, not |=. On TIFR a 1 clears and a 0 leaves alone, so
     *    assigning the single mask clears your flag and touches no other.
     */
    while (!( *Copy_pu8Register & Copy_u8BitMask ));
    *Copy_pu8Register |= Copy_u8BitMask;
}

static uint16 TIMER_DutyToCompare(uint16 Copy_u16Top, uint8 Copy_u8DutyPercent)
{
    /*
     * 1. Promote first: ((uint32)Copy_u16Top + 1) * Copy_u8DutyPercent / 100.
     * 2. Cast the result back to uint16 and return it.
     * 3. Sanity check with Timer0: Top = 255, 50 percent -> 128.
     */
}
