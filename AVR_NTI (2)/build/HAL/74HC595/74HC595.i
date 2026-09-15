# 0 "HAL/74HC595/74HC595.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/74HC595/74HC595.c"
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
# 2 "HAL/74HC595/74HC595.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 3 "HAL/74HC595/74HC595.c" 2
# 1 "MCAL/SPI/SPI_interface.h" 1
# 30 "MCAL/SPI/SPI_interface.h"
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);




STD_ReturnType SPI_InitSlave(void);





STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);





STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 4 "HAL/74HC595/74HC595.c" 2
# 1 "HAL/74HC595/74HC595_interface.h" 1
# 13 "HAL/74HC595/74HC595_interface.h"
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
# 5 "HAL/74HC595/74HC595.c" 2


static const uint8 SEGMENT_MAP[] = {
    [0] = 0b00111111,
    [1] = 0b00000110,
    [2] = 0b01011011,
    [3] = 0b01001111
};

STD_ReturnType HC595_Init(void) {

    GPIO_SetPinDirection(2u, 3u, 1u);
    GPIO_SetPinValue(2u, 3u, 0u);


    GPIO_SetPinDirection(2u, 4u, 1u);
    GPIO_SetPinDirection(2u, 5u, 1u);
    GPIO_SetPinValue(2u, 4u, 0u);
    GPIO_SetPinValue(2u, 5u, 0u);


    SPI_InitMaster(1u);

    return E_OK;
}

STD_ReturnType HC595_SendByte(uint8 Copy_u8Data) {
    uint8 Local_u8Received = 0;


    SPI_Transceive(Copy_u8Data, &Local_u8Received);


    GPIO_SetPinValue(2u, 3u, 1u);
    GPIO_SetPinValue(2u, 3u, 0u);

    return E_OK;
}

STD_ReturnType HC595_DisplayFloor(uint8 Copy_u8FloorNum, HC595_Direction_t Copy_tDirection) {
    if (Copy_u8FloorNum > 3) return E_NOK;


    HC595_SendByte(SEGMENT_MAP[Copy_u8FloorNum]);


    if (Copy_tDirection == HC595_DIR_UP) {
        GPIO_SetPinValue(2u, 4u, 1u);
        GPIO_SetPinValue(2u, 5u, 0u);
    }
    else if (Copy_tDirection == HC595_DIR_DOWN) {
        GPIO_SetPinValue(2u, 4u, 0u);
        GPIO_SetPinValue(2u, 5u, 1u);
    }
    else {
        GPIO_SetPinValue(2u, 4u, 0u);
        GPIO_SetPinValue(2u, 5u, 0u);
    }

    return E_OK;
}

STD_ReturnType HC595_DisplaySpecial(char Copy_cSymbol) {
    uint8 Local_u8Pattern = 0x00;

    if (Copy_cSymbol == 'E') Local_u8Pattern = 0b01111001;
    else if (Copy_cSymbol == 'F') Local_u8Pattern = 0b01110001;
    else return E_NOK;

    return HC595_SendByte(Local_u8Pattern);
}
