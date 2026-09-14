#ifndef ADC_PRIVATE_H
#define ADC_PRIVATE_H

/*
 * Author: Menna Allah (Elevator Controller Project PRJ-08-ELEVATOR)
 * MCAL ADC — Private Hardware Registers & Bit Maps
 * Include ONLY inside ADC.c
 */

/* ---------------- Hardware Register Addresses ---------------- */
#define ADC_ADMUX       (*(volatile uint8 *)0x27)
#define ADC_ADCSRA      (*(volatile uint8 *)0x26)
#define ADC_ADCH        (*(volatile uint8 *)0x25)
#define ADC_ADCL        (*(volatile uint8 *)0x24)
#define ADC_DATA_REG    (*(volatile uint16*)0x24) /* Read combined 16-bit register directly */

/* ---------------- ADMUX Bit Positions ---------------- */
#define ADMUX_REFS1     7
#define ADMUX_REFS0     6
#define ADMUX_ADLAR     5
#define ADMUX_MUX4      4
#define ADMUX_MUX3      3
#define ADMUX_MUX2      2
#define ADMUX_MUX1      1
#define ADMUX_MUX0      0

/* ---------------- ADCSRA Bit Positions ---------------- */
#define ADCSRA_ADEN     7
#define ADCSRA_ADSC     6
#define ADCSRA_ADATE    5
#define ADCSRA_ADIF     4
#define ADCSRA_ADIE     3
#define ADCSRA_ADPS2    2
#define ADCSRA_ADPS1    1
#define ADCSRA_ADPS0    0

/* Channel Masking Helper */
#define ADC_CHANNEL_MASK 0xE0  /* Preserves REFS1:0 and ADLAR, clears MUX4:0 */

#endif /* ADC_PRIVATE_H */