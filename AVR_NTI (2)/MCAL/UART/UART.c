/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — UART.c  (ATmega32 USART, 8N1 polling)
 * Implement every prototype from UART_interface.h.
 */

#include "STD_TYPES.h"
#include "UART_interface.h"
#include "UART_private.h"

/*
 * UART_Init
 * 1. Reject baud == 0.
 * 2. Compute UBRR = F_CPU / (16 * baud) - 1. Write UBRRH then UBRRL.
 * 3. UCSRC = URSEL | UCSZ1 | UCSZ0   (8N1, async).
 * 4. UCSRB = RXEN | TXEN.
 * 5. At 8 MHz, 9600 baud -> UBRR = 51.
 */
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate) {
    uint16 local_u16Ubr = 0;

    if (Copy_u32BaudRate == 0U) {
        return E_NOK;
    }

    local_u16Ubr = (uint16)(((F_CPU / (16UL * Copy_u32BaudRate)) - 1UL));

    UBRRH = (uint8)(local_u16Ubr >> 8);
    UBRRL = (uint8)(local_u16Ubr & 0xFFU);

    UCSRC = (uint8)((1U << URSEL) | (1U << UCSZ1) | (1U << UCSZ0));
    UCSRB = (uint8)((1U << RXEN) | (1U << TXEN) | (1U << RXCIE));

    return E_OK;
}

/*
 * UART_SendByte
 * 1. while (UDRE == 0) ;   then UDR = Copy_u8Data.
 */STD_ReturnType UART_SendByte(uint8 Copy_u8Data)
{
    while ((UCSRA & (1 << UDRE)) == 0)
    {
    }

    UDR = Copy_u8Data;

    return E_OK;
}


/*
 * UART_ReceiveByte
 * 1. Reject a NULL pointer.
 * 2. while (RXC == 0) ;    then *Copy_pu8Data = UDR.
 */

/*
 * UART_SendString
 * 1. Reject a NULL pointer.
 * 2. Send bytes until '\0'. Do not send the terminator unless the lab asks.
 */

/*
 * UART_IsDataReady
 * 1. Return E_OK if RXC is 1, else E_NOK.
 */

/*
 * UART_SetRxInterrupt / UART_SetTxInterrupt
 * 1. Set or clear RXCIE / UDRIE in UCSRB.
 * 2. Vectors: USART_RXC_vect , USART_UDRE_vect.
 */
