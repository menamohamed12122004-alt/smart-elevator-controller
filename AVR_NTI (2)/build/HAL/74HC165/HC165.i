# 0 "HAL/74HC165/HC165.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/74HC165/HC165.c"





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
# 7 "HAL/74HC165/HC165.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 8 "HAL/74HC165/HC165.c" 2
# 1 "MCAL/SPI/SPI_interface.h" 1
# 30 "MCAL/SPI/SPI_interface.h"
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);




STD_ReturnType SPI_InitSlave(void);





STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);





STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 9 "HAL/74HC165/HC165.c" 2
# 1 "HAL/74HC165/HC165_interface.h" 1
# 23 "HAL/74HC165/HC165_interface.h"
STD_ReturnType HC165_Init(void);


STD_ReturnType HC165_ReadByte(uint8 *Copy_pu8Data);


STD_ReturnType HC165_ReadMultiple(uint8 *Copy_pu8Buffer, uint8 Copy_u8NumOfDevices);


STD_ReturnType HC165_Read16Bits(uint16 *Copy_pu16Data);
# 10 "HAL/74HC165/HC165.c" 2

STD_ReturnType HC165_Init(void)
{

    GPIO_SetPinDirection(3u, 0u, 1u);
    GPIO_SetPinValue(3u, 0u, 1u);







    return E_OK;
}

STD_ReturnType HC165_ReadByte(uint8 *Copy_pu8Data)
{

    if (Copy_pu8Data == ((void *)0))
    {
        return E_NOK;
    }
    else
    {

        GPIO_SetPinValue(3u, 0u, 0u);
        GPIO_SetPinValue(3u, 0u, 1u);


        return SPI_Transceive(0xFFu, Copy_pu8Data);
    }
}

STD_ReturnType HC165_ReadMultiple(uint8 *Copy_pu8Buffer, uint8 Copy_u8NumOfDevices)
{
    uint8 Local_u8Index;


    if ((Copy_pu8Buffer == ((void *)0)) || (Copy_u8NumOfDevices == 0u))
    {
        return E_NOK;
    }
    else
    {

        GPIO_SetPinValue(3u, 0u, 0u);
        GPIO_SetPinValue(3u, 0u, 1u);


        for (Local_u8Index = 0u; Local_u8Index < Copy_u8NumOfDevices; Local_u8Index++)
        {
            if (SPI_Transceive(0xFFu, &Copy_pu8Buffer[Local_u8Index]) != E_OK)
            {
                return E_NOK;
            }
        }

        return E_OK;
    }
}

STD_ReturnType HC165_Read16Bits(uint16 *Copy_pu16Data)
{
    uint8 Local_au8Buffer[2] = {0u, 0u};


    if (Copy_pu16Data == ((void *)0))
    {
        return E_NOK;
    }
    else
    {

        if (HC165_ReadMultiple(Local_au8Buffer, 2u) != E_OK)
        {
            return E_NOK;
        }


        *Copy_pu16Data = ((uint16)Local_au8Buffer[1] << 8) | (uint16)Local_au8Buffer[0];

        return E_OK;
    }
}
