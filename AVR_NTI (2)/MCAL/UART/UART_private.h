#ifndef UART_PRIVATE_H
#define UART_PRIVATE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — UART private layer (ATmega32 USART)
 * Include this file ONLY from UART.c.
 *
 * What you must add here:
 * 1. Registers:
 *      UDR    0x2C    shared TX / RX data
 *      UCSRA  0x2B    RXC TXC UDRE FE DOR PE U2X MPCM
 *      UCSRB  0x2A    RXCIE TXCIE UDRIE RXEN TXEN UCSZ2 RXB8 TXB8
 *      UCSRC  0x40    URSEL UMSEL UPM1 UPM0 USBS UCSZ1 UCSZ0 UCPOL
 *      UBRRL  0x29
 *      UBRRH  0x40    same address as UCSRC — URSEL selects which one

 * 2. Bit names you will poll:
 *      UDRE = 5 in UCSRA  (transmitter ready)
 *      RXC  = 7 in UCSRA  (byte received)
 *      RXEN = 4, TXEN = 3 in UCSRB
 *
 * 3. 8N1 in UCSRC (must set URSEL = 1 when writing UCSRC):
 *      URSEL=1, UMSEL=0 (async), UPM=00 (no parity), USBS=0 (1 stop),
 *      UCSZ1:0 = 11 (8-bit). UCSZ2 in UCSRB stays 0.
 *
 * 4. Baud helper:
 *      ubrr = (F_CPU / (16UL * baud)) - 1     // U2X = 0
 *      write UBRRH (URSEL=0) then UBRRL.
 *
 * 5. This project uses F_CPU 8000000UL unless you override it.
 */

#define UDR     (*(volatile unsigned char*)0x2C)
#define UCSRA   (*(volatile unsigned char*)0x2B)
#define UCSRB   (*(volatile unsigned char*)0x2A)
#define UCSRC   (*(volatile unsigned char*)0x40)
#define UBRRL   (*(volatile unsigned char*)0x29)
#define UBRRH   (*(volatile unsigned char*)0x40)

/* UCSRA Bits */
#define UDRE  5
#define RXC   7

/* UCSRB Bits */
#define RXCIE 7
#define RXEN  4
#define TXEN  3

/* UCSRC Bits */
#define URSEL 7
#define UCSZ1 2
#define UCSZ0 1

/* CPU Frequency */
#ifndef F_CPU
#define F_CPU 8000000UL
#endif

/* Baud Rate Helper */
#define UART_UBRR(baud) ((F_CPU / (16UL * (baud))) - 1)

#endif /* UART_PRIVATE_H */
