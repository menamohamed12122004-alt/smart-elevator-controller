# 0 "HAL/door/door.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/door/door.c"
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
# 2 "HAL/door/door.c" 2
# 1 "HAL/DIO/DIO_interface.h" 1
# 17 "HAL/DIO/DIO_interface.h"
STD_ReturnType Elevator_InitButtons(void);
STD_ReturnType Elevator_ReadCarButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State);
STD_ReturnType Elevator_ReadFloorButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State);
# 3 "HAL/door/door.c" 2
# 1 "MCAL/EXTI/EXTI_interface.h" 1
# 26 "MCAL/EXTI/EXTI_interface.h"
STD_ReturnType EXTI_Init(uint8 Copy_u8Channel, uint8 Copy_u8SenseMode);




STD_ReturnType EXTI_EnableChannel(uint8 Copy_u8Channel);




STD_ReturnType EXTI_DisableChannel(uint8 Copy_u8Channel);





STD_ReturnType EXTI_SetCallBack(uint8 Copy_u8Channel, void (*Copy_pvoidCallBack)(void));
# 4 "HAL/door/door.c" 2
# 1 "HAL/door/door_interface.h" 1





typedef enum {
    DOOR_CLOSED = 0,
    DOOR_OPENED,
    DOOR_OPENING,
    DOOR_CLOSING
} Door_State_t;

STD_ReturnType Door_Init(void);
STD_ReturnType Door_Open(void);
STD_ReturnType Door_Close(void);
void Door_CheckSafety(void);
Door_State_t Door_GetState(void);
# 5 "HAL/door/door.c" 2
# 1 "HAL/door/door_private.h" 1
# 6 "HAL/door/door.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 7 "HAL/door/door.c" 2

static Door_State_t g_DoorState = DOOR_CLOSED;

STD_ReturnType Door_Init(void) {
    STD_ReturnType Local_u8Status = E_OK;

    Local_u8Status &= GPIO_SetPinDirection(1u, 0u, 1u);
    Local_u8Status &= GPIO_SetPinDirection(1u, 1u, 1u);

    Local_u8Status &= EXTI_Init(1u, 2u);
    Local_u8Status &= EXTI_SetCallBack(1u, &Door_CheckSafety);

    g_DoorState = DOOR_CLOSED;

    return Local_u8Status;
}

STD_ReturnType Door_Open(void) {
    if (g_DoorState == DOOR_OPENED) {
        return E_OK;
    }

    GPIO_SetPinValue(1u, 1u, 0u);
    GPIO_SetPinValue(1u, 0u, 1u);

    g_DoorState = DOOR_OPENING;
    g_DoorState = DOOR_OPENED;

    return E_OK;
}

STD_ReturnType Door_Close(void) {
    if (g_DoorState == DOOR_CLOSED || g_DoorState == DOOR_CLOSING) {
        return E_OK;
    }

    GPIO_SetPinValue(1u, 0u, 0u);
    GPIO_SetPinValue(1u, 1u, 1u);

    g_DoorState = DOOR_CLOSING;
    g_DoorState = DOOR_CLOSED;

    return E_OK;
}

void Door_CheckSafety(void) {
    if (g_DoorState == DOOR_CLOSING || g_DoorState == DOOR_CLOSED) {
        Door_Open();
    }
}

Door_State_t Door_GetState(void) {
    return g_DoorState;
}
