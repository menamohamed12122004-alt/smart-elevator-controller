#include "display_interface.h"
#include "74HC595_interface.h"

STD_ReturnType Display_Init(void)
{
    return HC595_Init();
}

STD_ReturnType Display_SetFloor(uint8 Copy_u8FloorNum, HC595_Direction_t Copy_tDirection)
{
    /* استدعاء دالة العرض الموجودة في درايفر الـ 595 مباشرة */
    return HC595_DisplayFloor(Copy_u8FloorNum, Copy_tDirection);
}