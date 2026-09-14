/*
 * Author: Menna Allah (Elevator Controller Project PRJ-08-ELEVATOR)
 * MCAL EXTI Implementation File
 */

#include "STD_TYPES.h"
#include "EXTI_interface.h"
#include "EXTI_private.h"

/* Array of Function Pointers for Callback Handlers */
static void (*g_EXTI_CallBacks[3])(void) = {NULL, NULL, NULL};

STD_ReturnType EXTI_Init(uint8 Copy_u8Channel, uint8 Copy_u8SenseMode) {
    if (Copy_u8Channel > EXTI_INT2) {
        return E_NOK;
    }

    /* 1. Set Input Direction for INT0 (PD2) and INT1 (PD3) */
    if (Copy_u8Channel == EXTI_INT0) {
        EXTI_DDRD &= ~(1 << 2);  /* Set PD2 as Input */
        EXTI_PORTD |= (1 << 2);  /* Enable Internal Pull-Up */
    } else if (Copy_u8Channel == EXTI_INT1) {
        EXTI_DDRD &= ~(1 << 3);  /* Set PD3 as Input */
        EXTI_PORTD |= (1 << 3);  /* Enable Internal Pull-Up */
    }

    /* 2. Configure Sense Control Signals */
    switch (Copy_u8Channel) {
        case EXTI_INT0:
            /* Clear Bit 0 & 1 in MCUCR */
            EXTI_MCUCR &= ~((1 << MCUCR_ISC00) | (1 << MCUCR_ISC01));
            /* Apply Sense Mode */
            EXTI_MCUCR |= (Copy_u8SenseMode & 0x03);
            break;

        case EXTI_INT1:
            /* Clear Bit 2 & 3 in MCUCR */
            EXTI_MCUCR &= ~((1 << MCUCR_ISC10) | (1 << MCUCR_ISC11));
            /* Apply Sense Mode */
            EXTI_MCUCR |= ((Copy_u8SenseMode & 0x03) << 2);
            break;

        case EXTI_INT2:
            if (Copy_u8SenseMode == EXTI_FALLING_EDGE) {
                EXTI_MCUCSR &= ~(1 << MCUCSR_ISC2);
            } else if (Copy_u8SenseMode == EXTI_RISING_EDGE) {
                EXTI_MCUCSR |= (1 << MCUCSR_ISC2);
            } else {
                return E_NOK; /* INT2 only supports Falling or Rising */
            }
            break;

        default:
            return E_NOK;
    }

    /* 3. Enable Peripheral Interrupt Enable (PIE) in GICR */
    EXTI_EnableChannel(Copy_u8Channel);

    /* 4. Enable Global Interrupt Enable (I-bit in SREG) */
    EXTI_SREG |= (1 << SREG_I_BIT);

    return E_OK;
}

STD_ReturnType EXTI_EnableChannel(uint8 Copy_u8Channel) {
    switch (Copy_u8Channel) {
        case EXTI_INT0: EXTI_GICR |= (1 << GICR_INT0); break;
        case EXTI_INT1: EXTI_GICR |= (1 << GICR_INT1); break;
        case EXTI_INT2: EXTI_GICR |= (1 << GICR_INT2); break;
        default: return E_NOK;
    }
    return E_OK;
}

STD_ReturnType EXTI_DisableChannel(uint8 Copy_u8Channel) {
    switch (Copy_u8Channel) {
        case EXTI_INT0: EXTI_GICR &= ~(1 << GICR_INT0); break;
        case EXTI_INT1: EXTI_GICR &= ~(1 << GICR_INT1); break;
        case EXTI_INT2: EXTI_GICR &= ~(1 << GICR_INT2); break;
        default: return E_NOK;
    }
    return E_OK;
}

STD_ReturnType EXTI_SetCallBack(uint8 Copy_u8Channel, void (*Copy_pvoidCallBack)(void)) {
    if (Copy_u8Channel > EXTI_INT2 || Copy_pvoidCallBack == NULL) {
        return E_NOK;
    }
    g_EXTI_CallBacks[Copy_u8Channel] = Copy_pvoidCallBack;
    return E_OK;
}

/* ---------------- Low-Latency Minimal ISR Stubs ---------------- */

/* ISR for EXTI0 - Emergency Stop Pushbutton */
ISR(ISR_INT0) {
    if (g_EXTI_CallBacks[EXTI_INT0] != NULL) {
        g_EXTI_CallBacks[EXTI_INT0](); /* Fast Execute Callback */
    }
}

/* ISR for EXTI1 - Door Safety Edge Sensor */
ISR(ISR_INT1) {
    if (g_EXTI_CallBacks[EXTI_INT1] != NULL) {
        g_EXTI_CallBacks[EXTI_INT1](); /* Fast Execute Callback */
    }
}

/* ISR for EXTI2 - Auxiliary */
ISR(ISR_INT2) {
    if (g_EXTI_CallBacks[EXTI_INT2] != NULL) {
        g_EXTI_CallBacks[EXTI_INT2]();
    }
}