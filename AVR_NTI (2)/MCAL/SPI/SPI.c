/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — SPI.c  (ATmega32, mode 0)
 * Implement every prototype from SPI_interface.h.
 */

#include "STD_TYPES.h"
#include "SPI_interface.h"
#include "SPI_private.h"
#include "MATH.h"
#include "GPIO_interface.h"

/* #include "GPIO_interface.h" */  /* use this for SS and the Port-B pin directions */

/*
 * SPI_InitMaster
 * 1. Reject prescaler > SPI_PRESC_128.
 * 2. SS / MOSI / SCK = output, MISO = input. Drive SS HIGH (idle).
 * 3. SPCR = SPE | MSTR | Copy_u8Prescaler.  (mode 0, MSB first)
 * 4. 8 MHz / 16 = 500 kHz SPI clock with SPI_PRESC_16.///////
 */

 STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler)
{
   
    if (Copy_u8Prescaler > SPI_PRESC_128)
    {
       return E_NOK;              // 1
    }
       else
    {
        // 2
        GPIO_SetPinDirection(GPIO_PORTB, SPI_SS_PIN, GPIO_OUTPUT);
        GPIO_SetPinDirection(GPIO_PORTB, SPI_MOSI_PIN, GPIO_OUTPUT);
        GPIO_SetPinDirection(GPIO_PORTB, SPI_SCK_PIN, GPIO_OUTPUT);
        GPIO_SetPinDirection(GPIO_PORTB, SPI_MISO_PIN, GPIO_INPUT);
        GPIO_SetPinValue(GPIO_PORTB, SPI_SS_PIN, GPIO_HIGH);

       // 3
        SPI_SPCR = (1u << SPE) | (1u << MSTR) | (Copy_u8Prescaler & 0x03u);
    }

    return E_OK;
}

/*
 * SPI_InitSlave
 * 1. MISO = output. MOSI, SCK, SS = input.
 * 2. SPCR = SPE only (MSTR = 0). /////
 */
STD_ReturnType SPI_InitSlave(void)
{
    // 1
    GPIO_SetPinDirection(GPIO_PORTB, SPI_MISO_PIN, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTB, SPI_MOSI_PIN, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTB, SPI_SCK_PIN,  GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTB, SPI_SS_PIN,   GPIO_INPUT);

    // 2
    SPI_SPCR  = (1 << SPE);
<<<<<<< HEAD
=======

>>>>>>> 0e6b039 (Update AVR project to use GCC 15.2.0 and optimize memory layout)
    return E_OK;
}
/*
 * SPI_Transceive
 * 1. Reject a NULL receive pointer.
 * 2. SPDR = Copy_u8Sent;          // starts the shift in master mode
 * 3. while (SPIF == 0) ;
 * 4. *Copy_pu8Received = SPDR;    // also clears SPIF
 */
STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received)
{
   // 1
    if (Copy_pu8Received == NULL)
    {
       return E_NOK;
    }
    else
    {
        SPI_SPDR = Copy_u8Sent;
        while (GET_BIT(SPI_SPSR, SPIF) == 0);
        *Copy_pu8Received = SPI_SPDR;
    }

    return E_OK ;
}
/*
 * SPI_SelectSlave
 * 1. GPIO_SetPinDirection(port, pin, GPIO_OUTPUT);
 * 2. GPIO_SetPinValue(port, pin, GPIO_LOW);
 *
 * SPI_ReleaseSlave
 * 1. GPIO_SetPinValue(port, pin, GPIO_HIGH);
 */