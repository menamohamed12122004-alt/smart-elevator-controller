#ifndef HOIST_INTERFACE_H_
#define HOIST_INTERFACE_H_

#include "STD_TYPES.h"

void Motor_Init(void);
void Motor_MoveUp(void);
void Motor_MoveDown(void);
void Motor_Stop(void);
void Motor_SetSpeed(uint8 Copy_u8Speed);

#endif /* HOIST_INTERFACE_H_ */