#ifndef DISPLAY_INTERFACE_H
#define DISPLAY_INTERFACE_H

#include "STD_TYPES.h"

/* تهيئة شاشة العرض */
STD_ReturnType Display_Init(void);

/* الدالة المطلوبة لضبط الدور */
STD_ReturnType Display_SetFloor(uint8 Copy_u8FloorNum);

#endif /* DISPLAY_INTERFACE_H */