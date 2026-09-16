# 0 "HAL/display/display.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/display/display.c"
# 1 "HAL/display/display_interface.h" 1
# 2 "HAL/display/display.c" 2
# 1 "HAL/74HC595/74HC595_interface.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 13 "LIB/STD_TYPES.h"
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;
typedef signed char sint8;
typedef signed short sint16;
typedef signed long sint32;

typedef unsigned char uint8_h;

typedef enum
{
    E_OK = 0,
    E_NOK = 1,
    E_PORT_Not_valid = 2,
    E_PIN_Not_valid = 3,
} STD_ReturnType;
# 5 "HAL/74HC595/74HC595_interface.h" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 6 "HAL/74HC595/74HC595_interface.h" 2







typedef enum
{
 HC595_DIR_NONE = 0,
 HC595_DIR_UP,
 HC595_DIR_DOWN
} HC595_Direction_t;


STD_ReturnType HC595_Init(void);
STD_ReturnType HC595_SendByte(uint8 Copy_u8Data);


STD_ReturnType HC595_DisplayFloor(uint8 Copy_u8FloorNum, HC595_Direction_t Copy_tDirection);


STD_ReturnType HC595_DisplaySpecial(char Copy_cSymbol);
# 3 "HAL/display/display.c" 2


static const uint8 SEG_LOOKUP_TABLE[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66,
    0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

void SEG_Show(uint8 floor, uint8 dir) {
    (void)dir;

    if (floor < 10) {
        uint8 pattern = SEG_LOOKUP_TABLE[floor];
        HC595_SendByte(pattern);
    }
}
