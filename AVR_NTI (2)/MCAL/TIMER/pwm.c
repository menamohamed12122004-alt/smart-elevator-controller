#include "STD_TYPES.h"
#include "MATH.h"
#include "pwm_interface.h"
#include <avr/io.h>

void PWM_Init(void)
{
    SET_BIT(TCCR1A, WGM11);
    CLEAR_BIT(TCCR1A, WGM10);
    SET_BIT(TCCR1B, WGM13);
    SET_BIT(TCCR1B, WGM12);
    
    CLEAR_BIT(TCCR1A, COM1A0);
    SET_BIT(TCCR1A, COM1A1);
    
    ICR1 = 799;
    
    SET_BIT(TCCR1B, CS10);
    CLEAR_BIT(TCCR1B, CS11);
    CLEAR_BIT(TCCR1B, CS12);
}

void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle)
{
    uint16 Local_u16CompareValue = (uint16)(((uint32)Copy_u8DutyCycle * 799) / 100);
    
    if (Copy_u8Channel == 0)
    {
        OCR1A = Local_u16CompareValue;
    }
}