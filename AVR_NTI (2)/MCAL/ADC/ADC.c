/*
 * Author: Menna Allah (Elevator Controller Project PRJ-08-ELEVATOR)
 * MCAL ADC Implementation File
 */

#include "STD_TYPES.h"
#include "ADC_interface.h"
#include "ADC_private.h"

STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler) {
    if ((Copy_u8Ref != ADC_REF_AREF && Copy_u8Ref != ADC_REF_AVCC && Copy_u8Ref != ADC_REF_INTERNAL_2V56) ||
        (Copy_u8Prescaler < ADC_PRESC_2 || Copy_u8Prescaler > ADC_PRESC_128)) {
        return E_NOK;
    }

    /* 1. Set Reference Voltage and Default to Right Adjustment (10-bit resolution) */
    ADC_ADMUX = (Copy_u8Ref << ADMUX_REFS0) | (ADC_RIGHT_ADJUST << ADMUX_ADLAR);

    /* 2. Set Prescaler Selection and Enable ADC Peripheral (ADEN) */
    ADC_ADCSRA = (Copy_u8Prescaler & 0x07) | (1 << ADCSRA_ADEN);

    return E_OK;
}

STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading) {
    if (Copy_u8Channel > ADC_CHANNEL_7 || Copy_pu16Reading == NULL) {
        return E_NOK;
    }

    /* 1. Clear previous channel bits MUX4:0 while keeping Reference & ADLAR settings */
    ADC_ADMUX &= ADC_CHANNEL_MASK;

    /* 2. Select new channel */
    ADC_ADMUX |= (Copy_u8Channel & 0x1F);

    /* 3. Start Single Conversion */
    ADC_ADCSRA |= (1 << ADCSRA_ADSC);

    /* 4. Poll ADIF flag until conversion completes */
    while ((ADC_ADCSRA & (1 << ADCSRA_ADIF)) == 0);

    /* 5. Clear ADIF flag by writing logic 1 */
    ADC_ADCSRA |= (1 << ADCSRA_ADIF);

    /* 6. Read 10-bit Digital Result (ADCL must be read before ADCH, or read combined 16-bit register) */
    *Copy_pu16Reading = ADC_DATA_REG;

    return E_OK;
}

STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel) {
    if (Copy_u8Channel > ADC_CHANNEL_7) {
        return E_NOK;
    }

    /* Clear channel bits and load new channel */
    ADC_ADMUX &= ADC_CHANNEL_MASK;
    ADC_ADMUX |= (Copy_u8Channel & 0x1F);

    /* Start conversion */
    ADC_ADCSRA |= (1 << ADCSRA_ADSC);

    return E_OK;
}

STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading) {
    if (Copy_pu16Reading == NULL) {
        return E_NOK;
    }

    /* Check if ADIF is set (Conversion Completed) */
    if ((ADC_ADCSRA & (1 << ADCSRA_ADIF)) != 0) {
        /* Clear ADIF Flag */
        ADC_ADCSRA |= (1 << ADCSRA_ADIF);

        /* Fetch value */
        *Copy_pu16Reading = ADC_DATA_REG;
        return E_OK;
    }

    return E_NOK;
}

STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State) {
    if (Copy_u8State == 1u) {
        ADC_ADCSRA |= (1 << ADCSRA_ADIE);
    } else if (Copy_u8State == 0u) {
        ADC_ADCSRA &= ~(1 << ADCSRA_ADIE);
    } else {
        return E_NOK;
    }

    return E_OK;
}
/*
 * ADC_StartConversion
 * 1. Select the channel as above.
 * 2. Set ADSC and return. Used when the result will be read later or in an ISR.
 */

/*
 * ADC_GetResult
 * 1. If ADIF is 0, return E_NOK (still busy).
 * 2. Clear ADIF, read ADCL then ADCH, store the 10-bit value.
 */

/*
 * ADC_SetInterrupt
 * 1. Copy_u8State == 1 -> set ADIE.  == 0 -> clear ADIE.
 * 2. The ISR vector is ADC_vect. Do not write the ISR in this file unless asked.
 */
