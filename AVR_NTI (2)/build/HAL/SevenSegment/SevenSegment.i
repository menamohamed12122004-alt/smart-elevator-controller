# 1 "HAL/SevenSegment/SevenSegment.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "HAL/SevenSegment/SevenSegment.c"
# 1 "HAL/SevenSegment/SevenSegment_interface.h" 1



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
# 5 "HAL/SevenSegment/SevenSegment_interface.h" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 6 "HAL/SevenSegment/SevenSegment_interface.h" 2

STD_ReturnType SevenSegment_Init(uint8 port);
STD_ReturnType SevenSegment_Display(uint8 port, uint8 digit);
# 2 "HAL/SevenSegment/SevenSegment.c" 2


STD_ReturnType SevenSegment_Init(uint8 port) {
    if (port > 3u) {

        return E_NOK;
    }

  GPIO_SetPortDirection(port, 0xFF);
  return E_OK;
}


STD_ReturnType SevenSegment_Display(uint8 port, uint8 digit) {
    if (digit > 9) {

        return E_NOK;
    }


    const uint8 segmentPatterns[10] = {
        0b00111111,
        0b00000110,
        0b01011011,
        0b01001111,
        0b01100110,
        0b01101101,
        0b01111101,
        0b00000111,
        0b01111111,
        0b01101111
    };


    GPIO_SetPortValue(port, segmentPatterns[digit]);
    return E_OK;
}
