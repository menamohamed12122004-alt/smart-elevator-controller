#ifndef PWM_INTERFACE_H_
#define PWM_INTERFACE_H_

#include "STD_TYPES.h"

void PWM_Init(void);
void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle);

#endif /* PWM_INTERFACE_H_ */