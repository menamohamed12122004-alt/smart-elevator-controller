/*
 * Author: Eman Elsayed Ali
 * Email:  eman.elsayed.ali9@gmail.com
 */

#include "STD_TYPES.h"
#include "GPIO_interface.h"
#include "SPI_interface.h"
#include "HC165_interface.h"

STD_ReturnType HC165_Init(void)
{
    // 1
    GPIO_SetPinDirection(HC165_PL_PORT, HC165_PL_PIN, GPIO_OUTPUT);
    GPIO_SetPinValue(HC165_PL_PORT, HC165_PL_PIN, GPIO_HIGH);

#if HC165_USE_CE
    // 2
    GPIO_SetPinDirection(HC165_CE_PORT, HC165_CE_PIN, GPIO_OUTPUT);
    GPIO_SetPinValue(HC165_CE_PORT, HC165_CE_PIN, GPIO_LOW);
#endif

    return E_OK;
}

STD_ReturnType HC165_ReadByte(uint8 *Copy_pu8Data)
{
    // 1
    if (Copy_pu8Data == NULL)
    {
        return E_NOK;
    }
    else
    {
        // 2: Load
        GPIO_SetPinValue(HC165_PL_PORT, HC165_PL_PIN, GPIO_LOW);
        GPIO_SetPinValue(HC165_PL_PORT, HC165_PL_PIN, GPIO_HIGH);

        // 3: Shift
        return SPI_Transceive(0xFFu, Copy_pu8Data);
    }
}

STD_ReturnType HC165_ReadMultiple(uint8 *Copy_pu8Buffer, uint8 Copy_u8NumOfDevices)
{
    uint8 Local_u8Index;

    // 1
    if ((Copy_pu8Buffer == NULL) || (Copy_u8NumOfDevices == 0u))
    {
        return E_NOK;
    }
    else
    {
        
        GPIO_SetPinValue(HC165_PL_PORT, HC165_PL_PIN, GPIO_LOW);
        GPIO_SetPinValue(HC165_PL_PORT, HC165_PL_PIN, GPIO_HIGH);

       
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

    // 1
    if (Copy_pu16Data == NULL)
    {
        return E_NOK;
    }
    else
    {
        // 2
        if (HC165_ReadMultiple(Local_au8Buffer, 2u) != E_OK)
        {
            return E_NOK;
        }

        // 3
        *Copy_pu16Data = ((uint16)Local_au8Buffer[1] << 8) | (uint16)Local_au8Buffer[0];

        return E_OK;
    }
}
