# 1 "HAL/KeyPad/KeyPad.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "HAL/KeyPad/KeyPad.c"
# 1 "HAL/KeyPad/KeyPad_interface.h" 1



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
# 5 "HAL/KeyPad/KeyPad_interface.h" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 6 "HAL/KeyPad/KeyPad_interface.h" 2

STD_ReturnType KeyPad_Init(uint8 port);
STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *pressedKey);
# 2 "HAL/KeyPad/KeyPad.c" 2

STD_ReturnType KeyPad_Init(uint8 port) {
    if (port > 3u) {

        return E_NOK;
    }

    GPIO_SetPortDirection(port, 0xF0);
    return E_OK;
}

STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *pressedKey) {
    if (port > 3u || pressedKey == ((void *)0)) {

        return E_NOK;
    }

    GPIO_SetPortDirection(port, 0xF0);


    uint8 columnValues;
    GPIO_GetPortValue(port, &columnValues);

    for (uint8 row = 0; row < 4; row++) {

        GPIO_SetPortValue(port, ~(1 << (row + 4)));
        for (uint8 col = 0; col < 4; col++) {

            GPIO_GetPortValue(port, &columnValues);
            if (!(columnValues & (1 << col))) {

                *pressedKey = row * 4 + col;
                return E_OK;
            }
        }
    }
    *pressedKey = 0xFF;
    return E_OK;
}
