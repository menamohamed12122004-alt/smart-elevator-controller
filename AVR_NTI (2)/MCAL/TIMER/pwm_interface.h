#ifndef pwm_interface.h
#define pwm_interface.h

#include "STD_TYPES.h"

void PWM_Init(void);
void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle);

#endif /* pwm_interface.h */