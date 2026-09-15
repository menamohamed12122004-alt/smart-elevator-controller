#include "STD_TYPES.h"
#include "MATH.h"
#include "pwm_interface.h"
#include <avr/io.h>

void PWM_Init(void)
{
    SET_BIT(TCCR0, WGM00);
    SET_BIT(TCCR0, WGM01);
    
    CLEAR_BIT(TCCR0, COM00);
    SET_BIT(TCCR0, COM01);
    
    SET_BIT(TCCR0, CS01);
    SET_BIT(TCCR0, CS00);
}

void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle)
{
    uint8 Local_u8CompareValue = (uint8)(((uint16)Copy_u8DutyCycle * 255) / 100);
    
    OCR0 = Local_u8CompareValue;
}