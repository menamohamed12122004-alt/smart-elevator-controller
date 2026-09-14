#ifndef ADC_INTERFACE_H
#define ADC_INTERFACE_H

/*
 * Author: Menna Allah (Elevator Controller Project PRJ-08-ELEVATOR)
 * MCAL ADC — Public API for ATmega32 10-bit ADC
 */

#include "STD_TYPES.h"

/* ---------------- Voltage Reference (ADMUX REFS1:0) ---------------- */
#define ADC_REF_AREF          0u    /* AREF pin, internal Vref off */
#define ADC_REF_AVCC          1u    /* AVCC with cap on AREF pin   */
#define ADC_REF_INTERNAL_2V56 3u    /* Internal 2.56 V             */

/* ---------------- Result Adjust (ADMUX ADLAR) ---------------- */
#define ADC_RIGHT_ADJUST      0u    /* 10-bit value right adjusted */
#define ADC_LEFT_ADJUST       1u

/* ---------------- Prescaler (ADCSRA ADPS2:0) ---------------- */
#define ADC_PRESC_2           1u
#define ADC_PRESC_4           2u
#define ADC_PRESC_8           3u
#define ADC_PRESC_16          4u
#define ADC_PRESC_32          5u
#define ADC_PRESC_64          6u
#define ADC_PRESC_128         7u    /* Recommended for 8MHz (62.5kHz ADC clock) */

/* ---------------- Dedicated Elevator Project Channels ---------------- */
#define ADC_CHANNEL_0         0u    /* PA0: Shaft Floor Position Feedback Potentiometer */
#define ADC_CHANNEL_1         1u    /* PA1: Passenger Weight Load Cell Strain-Gauge    */
#define ADC_CHANNEL_2         2u    /* PA2: Door Opening Span Feedback Potentiometer   */
#define ADC_CHANNEL_3         3u
#define ADC_CHANNEL_4         4u
#define ADC_CHANNEL_5         5u
#define ADC_CHANNEL_6         6u
#define ADC_CHANNEL_7         7u

/*
 * Description : Enables ADC, sets reference voltage (AVCC) and prescaler (128).
 */
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);

/*
 * Description : Synchronous read for a selected channel (0..7). Returns 10-bit value (0..1023).
 */
STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);

/*
 * Description : Starts a conversion on a channel without blocking.
 */
STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);

/*
 * Description : Returns E_OK and reading if conversion is complete; E_NOK if still running.
 */
STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);

/*
 * Description : Enable/Disable ADC Interrupt (ADIE).
 */
STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);

#endif /* ADC_INTERFACE_H */