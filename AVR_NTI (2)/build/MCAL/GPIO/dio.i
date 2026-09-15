# 0 "MCAL/GPIO/dio.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/GPIO/dio.c"
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
# 2 "MCAL/GPIO/dio.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 3 "MCAL/GPIO/dio.c" 2
# 1 "MCAL/GPIO/dio_interface.h" 1
# 17 "MCAL/GPIO/dio_interface.h"
STD_ReturnType Elevator_InitButtons(void);
STD_ReturnType Elevator_ReadCarButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State);
STD_ReturnType Elevator_ReadFloorButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State);
# 4 "MCAL/GPIO/dio.c" 2


STD_ReturnType Elevator_InitButtons(void)
{
    GPIO_SetPinDirection(0u, 0u, 2u);
    GPIO_SetPinDirection(0u, 1u, 2u);
    GPIO_SetPinDirection(0u, 2u, 2u);
    GPIO_SetPinDirection(0u, 3u, 2u);

    GPIO_SetPinDirection(1u, 4u, 2u);
    GPIO_SetPinDirection(1u, 5u, 2u);
    GPIO_SetPinDirection(1u, 6u, 2u);
    GPIO_SetPinDirection(1u, 7u, 2u);

    return E_OK;
}

STD_ReturnType Elevator_ReadCarButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State)
{
    uint8 pin = 0xFF;

    switch(Copy_u8Floor) {
        case 1: pin = 0u; break;
        case 2: pin = 1u; break;
        case 3: pin = 2u; break;
        case 4: pin = 3u; break;
        default: return E_NOK;
    }

    return GPIO_GetPinValue(0u, pin, Copy_pu8State);
}

STD_ReturnType Elevator_ReadFloorButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State)
{
    uint8 pin = 0xFF;

    switch(Copy_u8Floor) {
        case 1: pin = 4u; break;
        case 2: pin = 5u; break;
        case 3: pin = 6u; break;
        case 4: pin = 7u; break;
        default: return E_NOK;
    }

    return GPIO_GetPinValue(1u, pin, Copy_pu8State);
}
