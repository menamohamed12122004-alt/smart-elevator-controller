/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * MCAL INTERRUPT — ATmega32 EXTI + global I-bit.
 */

#include <avr/interrupt.h>

#include "STD_TYPES.h"
#include "MATH.h"
#include "INTERRUPT_interface.h"
#include "INTERRUPT_private.h"

/*
 * Callback table — one entry per source (INT0, INT1, INT2), all NULL at reset.
 *
 * The volatile belongs on the POINTERS, not on the return type:
 *   void (* volatile callback[3])(void)   <- array of volatile function pointers
 *   volatile void (*callback[3])(void)    <- WRONG, qualifies the void return
 * Main writes these, an ISR reads them, so the compiler must not cache them.
 */
static void (* volatile callback[3])(void) = {NULL, NULL, NULL};

/*
 * INTERRUPT_EnableGlobal  : set SREG I-bit (sei).
 * INTERRUPT_DisableGlobal : clear SREG I-bit (cli).
 *
 * sei()/cli() are single instructions and carry a memory barrier, so the
 * compiler cannot float loads/stores across the point where interrupts turn
 * on or off. A read-modify-write on SREG through a pointer does neither.
 */
STD_ReturnType INTERRUPT_EnableGlobal(void){
    sei();
    return E_OK;
}

STD_ReturnType INTERRUPT_DisableGlobal(void){
    cli();
    return E_OK;
}

/*
 * EXTI_SetSense
 * 1. Reject an unknown source or an out-of-range sense.
 * 2. INT0 : write ISC01:ISC00 (MCUCR bits 1:0) from Copy_u8Sense (0..3).
 * 3. INT1 : write ISC11:ISC10 (MCUCR bits 3:2) the same way.
 * 4. INT2 : only EXTI_FALLING_EDGE (ISC2=0) or EXTI_RISING_EDGE (ISC2=1).
 *    Return E_NOK for low-level / any-change on INT2.
 * 5. Writing the sense bits can raise the flag, so clear it before returning.
 *
 * NOTE: SET_BIT/CLEAR_BIT take a bit NUMBER, never a mask. Writing a
 * two-bit field needs a read-modify-write with an explicit mask.
 */
STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense){
    if(Copy_u8Int > EXTI_INT2 || Copy_u8Sense > EXTI_RISING_EDGE){
        return E_NOK; /* Invalid source or sense */
    }
    switch(Copy_u8Int){
        case EXTI_INT0:
            /* ISC01:ISC00 = MCUCR bits 1:0 */
            INTERRUPT_REG_MCUCR = (uint8)((INTERRUPT_REG_MCUCR & ~0x03u)
                                          | (Copy_u8Sense & 0x03u));
            break;
        case EXTI_INT1:
            /* ISC11:ISC10 = MCUCR bits 3:2 */
            INTERRUPT_REG_MCUCR = (uint8)((INTERRUPT_REG_MCUCR & ~0x0Cu)
                                          | ((Copy_u8Sense << 2) & 0x0Cu));
            break;
        case EXTI_INT2:
            /* ISC2 = MCUCSR bit 6 : 0 = falling, 1 = rising */
            if(Copy_u8Sense == EXTI_FALLING_EDGE){
                CLEAR_BIT(INTERRUPT_REG_MCUCSR, 6);
            } else if(Copy_u8Sense == EXTI_RISING_EDGE){
                SET_BIT(INTERRUPT_REG_MCUCSR, 6);
            } else {
                return E_NOK; /* INT2 has no low-level / any-change mode */
            }
            break;
    }
    /* Changing the sense can latch a spurious edge — drop it. */
    (void)EXTI_ClearFlag(Copy_u8Int);
    return E_OK;
}

/*
 * EXTI_ClearFlag — write 1 to INTF0 / INTF1 / INTF2 in GIFR (w1c).
 *
 * Plain assignment, NOT SET_BIT. GIFR is write-1-to-clear, so the
 * read-modify-write that SET_BIT expands to reads the other two pending
 * flags as 1 and writes them straight back — clearing interrupts that
 * were never handled. Assign the single bit and leave the rest zero.
 */
STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int){
    if(Copy_u8Int > EXTI_INT2){
        return E_NOK; /* Invalid source */
    }
    switch(Copy_u8Int){
        case EXTI_INT0: INTERRUPT_REG_GIFR = (1u << 6); break; /* INTF0 */
        case EXTI_INT1: INTERRUPT_REG_GIFR = (1u << 7); break; /* INTF1 */
        case EXTI_INT2: INTERRUPT_REG_GIFR = (1u << 5); break; /* INTF2 */
    }
    return E_OK;
}

/*
 * EXTI_Enable
 * 1. Validate the source.
 * 2. Clear the stale flag first, then set INT0/INT1/INT2 in GICR.
 *
 * EXTI_Disable
 * 1. Clear the matching GICR bit. Keep the sense bits and the callback.
 *
 * Full order that always works:
 *   callback -> sense -> clear flag -> enable -> sei()
 */
STD_ReturnType EXTI_Enable(uint8 Copy_u8Int){
    if(Copy_u8Int > EXTI_INT2){
        return E_NOK; /* Invalid source */
    }
    (void)EXTI_ClearFlag(Copy_u8Int);
    switch(Copy_u8Int){
        case EXTI_INT0: SET_BIT(INTERRUPT_REG_GICR, 6); break; /* INT0 */
        case EXTI_INT1: SET_BIT(INTERRUPT_REG_GICR, 7); break; /* INT1 */
        case EXTI_INT2: SET_BIT(INTERRUPT_REG_GICR, 5); break; /* INT2 */
    }
    return E_OK;
}

STD_ReturnType EXTI_Disable(uint8 Copy_u8Int){
    if(Copy_u8Int > EXTI_INT2){
        return E_NOK; /* Invalid source */
    }
    switch(Copy_u8Int){
        case EXTI_INT0: CLEAR_BIT(INTERRUPT_REG_GICR, 6); break;
        case EXTI_INT1: CLEAR_BIT(INTERRUPT_REG_GICR, 7); break;
        case EXTI_INT2: CLEAR_BIT(INTERRUPT_REG_GICR, 5); break;
    }
    return E_OK;
}

/*
 * EXTI_SetCallback
 * 1. Reject an unknown source or a NULL function pointer.
 * 2. Store the pointer in the callback table entry of that source.
 */
STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, void (*Copy_pfCallback)(void)){
    if(Copy_u8Int > EXTI_INT2 || Copy_pfCallback == NULL){
        return E_NOK; /* Invalid source or NULL callback */
    }
    callback[Copy_u8Int] = Copy_pfCallback;
    return E_OK;
}

/*
 * ISRs — this driver owns them, the application does not write them.
 *
 * These MUST be declared with the ISR() macro from <avr/interrupt.h>.
 * A plain C function named INT0_vect is just an ordinary function: it ends
 * in RET instead of RETI, it saves no registers and no SREG, and — the part
 * that actually breaks everything — it does not define the symbol
 * __vector_1 that the vector table at address 0x0000 points at. avr-libc
 * builds that table from crt<mcu>.o with weak references to __vector_N; any
 * vector you have not defined resolves to __bad_interrupt, which is a
 * JMP 0 — a soft reset. ISR(INT0_vect) expands to __vector_1 and fills the
 * slot in.
 *
 * Do not hand-roll a vector table in a custom section either. The hardware
 * jumps to fixed flash addresses and expects JMP instructions there, not an
 * array of function pointers, and a section the linker script does not place
 * at 0x0000 is dead data.
 *
 * Always test against NULL first — an edge can arrive before main registers
 * anything, and calling a NULL pointer jumps to address 0 and resets the MCU.
 * Keep the ISR body to that one call; the work belongs in the callback, and
 * the callback must not block (no _delay_ms, no UART_SendString).
 *
 * The hardware clears INTF0/1/2 automatically on vector entry, so a callback
 * must NOT call EXTI_ClearFlag for its own source — doing so throws away an
 * edge that arrived while the ISR was running.
 */
ISR(INT0_vect){
    if(callback[EXTI_INT0] != NULL){
        callback[EXTI_INT0]();
    }
}

ISR(INT1_vect){
    if(callback[EXTI_INT1] != NULL){
        callback[EXTI_INT1]();
    }
}

ISR(INT2_vect){
    if(callback[EXTI_INT2] != NULL){
        callback[EXTI_INT2]();
    }
}
