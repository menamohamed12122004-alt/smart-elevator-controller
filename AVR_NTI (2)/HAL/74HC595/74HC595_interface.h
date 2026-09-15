#ifndef HC595_INTERFACE_H
#define HC595_INTERFACE_H

#include "STD_TYPES.h"

STD_ReturnType HC595_Init(void);

STD_ReturnType HC595_SendByte(uint8 Copy_u8Data);

#endif