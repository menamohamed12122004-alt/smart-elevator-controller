#ifndef HC595_INTERFACE_H
#define HC595_INTERFACE_H

#include "STD_TYPES.h"


#define HC595_LATCH_PORT    DIO_PORTC   // أو PORTC حسب درايفر الـ GPIO عندك
#define HC595_LATCH_PIN     DIO_PIN3    // أو PIN3

// الدوال الأساسية
STD_ReturnType HC595_Init(void);
STD_ReturnType HC595_SendByte(uint8_t Copy_u8Data);

// دالة إضافية لعرض رقم الدور مباشرة على الـ 7-Segment
STD_ReturnType HC595_DisplayFloor(uint8_t Copy_u8FloorNum);

#endif 