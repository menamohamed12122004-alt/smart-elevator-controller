#include "STD_TYPES.h"
#include "DIO_interface.h"
#include "EXTI_interface.h"
#include "door_interface.h"
#include "door_private.h"
#include "GPIO_interface.h"

static Door_State_t g_DoorState = DOOR_CLOSED;

STD_ReturnType Door_Init(void) {
    STD_ReturnType Local_u8Status = E_OK;

    Local_u8Status &= GPIO_SetPinDirection(DOOR_PORT, DOOR_PIN_OPEN, GPIO_OUTPUT);
    Local_u8Status &= GPIO_SetPinDirection(DOOR_PORT, DOOR_PIN_CLOSE, GPIO_OUTPUT);

    Local_u8Status &= EXTI_Init(EXTI_INT1, EXTI_FALLING_EDGE);
    Local_u8Status &= EXTI_SetCallBack(EXTI_INT1, &Door_CheckSafety);

    g_DoorState = DOOR_CLOSED;

    return Local_u8Status;
}

STD_ReturnType Door_Open(void) {
    if (g_DoorState == DOOR_OPENED) {
        return E_OK;
    }

    GPIO_SetPinValue(DOOR_PORT, DOOR_PIN_CLOSE, GPIO_LOW);
    GPIO_SetPinValue(DOOR_PORT, DOOR_PIN_OPEN, GPIO_HIGH);

    g_DoorState = DOOR_OPENING;
    g_DoorState = DOOR_OPENED;

    return E_OK;
}

STD_ReturnType Door_Close(void) {
    if (g_DoorState == DOOR_CLOSED || g_DoorState == DOOR_CLOSING) {
        return E_OK;
    }

    GPIO_SetPinValue(DOOR_PORT, DOOR_PIN_OPEN, GPIO_LOW);
    GPIO_SetPinValue(DOOR_PORT, DOOR_PIN_CLOSE, GPIO_HIGH);

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