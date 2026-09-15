#include "74HC595_interface.h"
#include "SPI_interface.h"
#include "dio.h"


STD_ReturnType HC595_Init(void)
{
    SPI_Init();

    /* RCLK (Latch) -> PC3 */
    DIO_Init(DIO_PORTC, DIO_PIN3, DIO_OUTPUT);

    /* Initial Latch state */
    DIO_Write(DIO_PORTC, DIO_PIN3, DIO_LOW);

    return E_OK;
}


STD_ReturnType HC595_SendByte(uint8 Copy_u8Data)
{
    /* Send data through SPI */
    SPI_Transfer(Copy_u8Data);

    /* Latch the data */
    DIO_Write(DIO_PORTC, DIO_PIN3, DIO_HIGH);
    DIO_Write(DIO_PORTC, DIO_PIN3, DIO_LOW);

    return E_OK;
}