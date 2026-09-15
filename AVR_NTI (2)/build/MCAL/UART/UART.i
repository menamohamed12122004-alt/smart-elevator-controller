# 0 "MCAL/UART/UART.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/UART/UART.c"
# 9 "MCAL/UART/UART.c"
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
# 10 "MCAL/UART/UART.c" 2
# 1 "MCAL/UART/UART_interface.h" 1
# 20 "MCAL/UART/UART_interface.h"
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate);




STD_ReturnType UART_SendByte(uint8 Copy_u8Data);




STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data);




STD_ReturnType UART_SendString(const uint8 *Copy_pu8String);





STD_ReturnType UART_IsDataReady(void);





STD_ReturnType UART_SetRxInterrupt(uint8 Copy_u8State);
STD_ReturnType UART_SetTxInterrupt(uint8 Copy_u8State);
# 11 "MCAL/UART/UART.c" 2
# 1 "MCAL/UART/UART_private.h" 1
# 12 "MCAL/UART/UART.c" 2
# 21 "MCAL/UART/UART.c"
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate) {
    uint16 local_u16Ubr = 0;

    if (Copy_u32BaudRate == 0U) {
        return E_NOK;
    }

    local_u16Ubr = (uint16)(((8000000UL / (16UL * Copy_u32BaudRate)) - 1UL));

    (*(volatile unsigned char*)0x40) = (uint8)(local_u16Ubr >> 8);
    (*(volatile unsigned char*)0x29) = (uint8)(local_u16Ubr & 0xFFU);

    (*(volatile unsigned char*)0x40) = (uint8)((1U << 7) | (1U << 2) | (1U << 1));
    (*(volatile unsigned char*)0x2A) = (uint8)((1U << 4) | (1U << 3) | (1U << 7));

    return E_OK;
}




   STD_ReturnType UART_SendByte(uint8 Copy_u8Data)
{
    while (((*(volatile unsigned char*)0x2B) & (1 << 5)) == 0)
    {
    }

    (*(volatile unsigned char*)0x2C) = Copy_u8Data;

    return E_OK;
}






   STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data)
{
    if (Copy_pu8Data == ((void *)0))
    {
        return E_NOK;
    }

    while (((*(volatile unsigned char*)0x2B) & (1 << 7)) == 0)
    {
    }

    *Copy_pu8Data = (*(volatile unsigned char*)0x2C);

    return E_OK;
}
