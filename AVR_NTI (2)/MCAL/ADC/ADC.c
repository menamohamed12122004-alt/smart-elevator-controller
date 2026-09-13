/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — ADC.c  (ATmega32, 10-bit)
 * Implement every prototype from ADC_interface.h.
 */

#include "STD_TYPES.h"
#include "ADC_interface.h"
#include "ADC_private.h"

/*
 * ADC_Init
 * 1. Reject an unknown reference or prescaler.
 * 2. Write REFS1:0 (and ADLAR = 0 for right adjust) in ADMUX.
 * 3. Write ADPS2:0, then set ADEN. Do not start a conversion yet.
 * 4. Target ADC clock 50..200 kHz (8 MHz / 64 = 125 kHz).
 */
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler){
    if((Copy_u8Ref != ADC_REF_AREF && Copy_u8Ref != ADC_REF_AVCC && Copy_u8Ref != ADC_REF_INTERNAL_2V56) ||
       (Copy_u8Prescaler < ADC_PRESC_2 || Copy_u8Prescaler > ADC_PRESC_128)){
        return E_NOK;
    }
    // Set reference voltage and adjust result to right
    ADC_ADMUX = (Copy_u8Ref << 6) | (ADC_RIGHT_ADJUST << 5);            // 0000 0011 - "<<6" ->  1100 0000
                                                                        // 0000 0000 - "<<5" ->  0000 0000
    // Set prescaler and enable ADC
    ADC_ADCSRA = (Copy_u8Prescaler & 0x07) | (1 << 7);                  // 0000 0111 - "&0x07" ->  0000 0110
                                                                        // 0000 0001 - "<<7" ->     1000 0000
                                                                        // 0000 0011 | 1000 0000 = 1000 0110
    return E_OK;        
}
/*
 * ADC_ReadChannel
 * 1. Reject Channel > 7 or a NULL pointer.
 * 2. Keep REFS bits, replace MUX4:0 with the channel.
 * 3. Set ADSC. Poll ADIF (or ADSC) until the conversion ends.
 * 4. Clear ADIF by writing 1 to it.
 * 5. Read ADCL then ADCH. Combine: reading = ADCL | ((uint16)ADCH << 8).
 */
STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading){
    if(Copy_u8Channel > ADC_CHANNEL_7 || Copy_pu16Reading == NULL){
        return E_NOK;
    }
    // Select channel, keep reference bits
    ADC_ADMUX |=  (Copy_u8Channel & 0x1F);    // XXX0 0000 | (XXXX XXXX & 0001 1111) = 000X XXXX                   
                                              // 000X XXXX 
    // Start conversion
    ADC_ADCSRA |= (1 << 6);                   // 0000 0001 << 6 = 0100 0000
    // Wait for conversion to complete (ADIF = 1)
    while((ADC_ADCSRA & (1 << 4)) == 0);       // 0000 0001 << 4 = 0001 0000
    // Clear ADIF by writing 1 to it
    ADC_ADCSRA |= (1 << 4);                   // 0000 000
    // Read result
    *Copy_pu16Reading = ADC_ADCL | ((uint16)ADC_ADCH << 8);              // Combine ADCL and ADCH into a single uint16 value
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
