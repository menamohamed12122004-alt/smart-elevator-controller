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
/* #include "GPIO_interface.h" */  /* use this for SS and the Port-B pin directions */

/*
 * SPI_InitMaster
 * 1. Reject prescaler > SPI_PRESC_128.
 * 2. SS / MOSI / SCK = output, MISO = input. Drive SS HIGH (idle).
 * 3. SPCR = SPE | MSTR | Copy_u8Prescaler.  (mode 0, MSB first)
 * 4. 8 MHz / 16 = 500 kHz SPI clock with SPI_PRESC_16.
 */

/*
 * SPI_InitSlave
 * 1. MISO = output. MOSI, SCK, SS = input.
 * 2. SPCR = SPE only (MSTR = 0).
 */

/*
 * SPI_Transceive
 * 1. Reject a NULL receive pointer.
 * 2. SPDR = Copy_u8Sent;          // starts the shift in master mode
 * 3. while (SPIF == 0) ;
 * 4. *Copy_pu8Received = SPDR;    // also clears SPIF
 */

/*
 * SPI_SelectSlave
 * 1. GPIO_SetPinDirection(port, pin, GPIO_OUTPUT);
 * 2. GPIO_SetPinValue(port, pin, GPIO_LOW);
 *
 * SPI_ReleaseSlave
 * 1. GPIO_SetPinValue(port, pin, GPIO_HIGH);
 */
