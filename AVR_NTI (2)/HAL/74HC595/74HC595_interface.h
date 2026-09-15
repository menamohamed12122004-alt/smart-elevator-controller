#ifndef HC595_INTERFACE_H
#define HC595_INTERFACE_H

#include "STD_TYPES.h"
#include "GPIO_interface.h"

/* تحديد طرف الـ Latch وطرفي أسهم الاتجاهات */
#define HC595_LATCH_PORT     GPIO_PORTC
#define HC595_LATCH_PIN      GPIO_PIN3
#define HC595_DIR_UP_PIN     GPIO_PIN4
#define HC595_DIR_DN_PIN     GPIO_PIN5

typedef enum
{
	HC595_DIR_NONE = 0,
	HC595_DIR_UP,
	HC595_DIR_DOWN
} HC595_Direction_t;

// الدوال الأساسية
STD_ReturnType HC595_Init(void);
STD_ReturnType HC595_SendByte(uint8 Copy_u8Data);

// لعرض رقم الدور مباشرة على الـ 7-Segment
STD_ReturnType HC595_DisplayFloor(uint8 Copy_u8FloorNum, HC595_Direction_t Copy_tDirection);

// لعرض الرموز الخاصة مثل 'E' للأعطال و 'F' للحريق
STD_ReturnType HC595_DisplaySpecial(char Copy_cSymbol);

#endif /* HC595_INTERFACE_H */