#ifndef SPI_INTERFACE_H
#define SPI_INTERFACE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * MCAL SPI — public API for the ATmega32 SPI (mode 0, MSB first).
 * Include this header from HAL, Logic, and main. Do not include SPI_private.h there.
 *
 * Master pins: SS=PB4, MOSI=PB5, MISO=PB6, SCK=PB7.
 */

#include "STD_TYPES.h"

/* ---------------- Clock rate (SPCR SPR1:0, SPSR SPI2X = 0) ---------------- */
#define SPI_PRESC_4           0u
#define SPI_PRESC_16          1u
#define SPI_PRESC_64          2u
#define SPI_PRESC_128         3u

/* ---------------- Data order ---------------- */
#define SPI_MSB_FIRST         0u
#define SPI_LSB_FIRST         1u

/*
 * Description : Set PB4/PB5/PB7 as outputs and PB6 as input, then enable SPI
 *               as master, mode 0 (CPOL=0, CPHA=0), at Copy_u8Prescaler.
 */
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);

/*
 * Description : Enable SPI as slave. MISO is an output; MOSI, SCK, SS are inputs.
 */
STD_ReturnType SPI_InitSlave(void);

/*
 * Description : Write Copy_u8Sent to SPDR, wait for SPIF, then store SPDR
 *               in *Copy_pu8Received (the byte the other side shifted in).
 */
STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);

/*
 * Description : Drive a slave's SS pin LOW (select) or HIGH (release).
 *               Use GPIO_PORT / GPIO_PIN values from GPIO_interface.h.
 */
STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);

#endif /* SPI_INTERFACE_H */
