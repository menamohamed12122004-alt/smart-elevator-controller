#include "STD_TYPES.h"
#include "GPIO_interface.h"
#include "dio_interface.h"


STD_ReturnType Elevator_InitButtons(void)
{
    GPIO_SetPinDirection(CAR_PORT, CAR_BUTTON_1, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(CAR_PORT, CAR_BUTTON_2, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(CAR_PORT, CAR_BUTTON_3, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(CAR_PORT, CAR_BUTTON_4, GPIO_INPUT_PULLUP);

    GPIO_SetPinDirection(FLOOR_PORT, FLOOR_BUTTON_1, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(FLOOR_PORT, FLOOR_BUTTON_2, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(FLOOR_PORT, FLOOR_BUTTON_3, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(FLOOR_PORT, FLOOR_BUTTON_4, GPIO_INPUT_PULLUP);

    return E_OK;
}

STD_ReturnType Elevator_ReadCarButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State)
{
    uint8 pin = 0xFF;
    
    switch(Copy_u8Floor) {
        case 1: pin = CAR_BUTTON_1; break;
        case 2: pin = CAR_BUTTON_2; break;
        case 3: pin = CAR_BUTTON_3; break;
        case 4: pin = CAR_BUTTON_4; break;
        default: return E_NOK;
    }

    return GPIO_GetPinValue(CAR_PORT, pin, Copy_pu8State);
}

STD_ReturnType Elevator_ReadFloorButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State)
{
    uint8 pin = 0xFF;
    
    switch(Copy_u8Floor) {
        case 1: pin = FLOOR_BUTTON_1; break;
        case 2: pin = FLOOR_BUTTON_2; break;
        case 3: pin = FLOOR_BUTTON_3; break;
        case 4: pin = FLOOR_BUTTON_4; break;
        default: return E_NOK;
    }

    return GPIO_GetPinValue(FLOOR_PORT, pin, Copy_pu8State);
}