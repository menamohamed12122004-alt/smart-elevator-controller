# 1 "MCAL/ADC/ADC.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "MCAL/ADC/ADC.c"
# 9 "MCAL/ADC/ADC.c"
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
# 10 "MCAL/ADC/ADC.c" 2
# 1 "MCAL/ADC/ADC_interface.h" 1
# 46 "MCAL/ADC/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 11 "MCAL/ADC/ADC.c" 2
# 1 "MCAL/ADC/ADC_private.h" 1
# 12 "MCAL/ADC/ADC.c" 2
# 20 "MCAL/ADC/ADC.c"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler){
    if((Copy_u8Ref != 0u && Copy_u8Ref != 1u && Copy_u8Ref != 3u) ||
       (Copy_u8Prescaler < 1u || Copy_u8Prescaler > 7u)){
        return E_NOK;
    }

    (*(volatile uint8 *)0x27) = (Copy_u8Ref << 6) | (0u << 5);


    (*(volatile uint8 *)0x26) = (Copy_u8Prescaler & 0x07) | (1 << 7);


    return E_OK;
}
# 42 "MCAL/ADC/ADC.c"
STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading){
    if(Copy_u8Channel > 7u || Copy_pu16Reading == ((void *)0)){
        return E_NOK;
    }

    (*(volatile uint8 *)0x27) |= (Copy_u8Channel & 0x1F);


    (*(volatile uint8 *)0x26) |= (1 << 6);

    while(((*(volatile uint8 *)0x26) & (1 << 4)) == 0);

    (*(volatile uint8 *)0x26) |= (1 << 4);

    *Copy_pu16Reading = (*(volatile uint8 *)0x24) | ((uint16)(*(volatile uint8 *)0x25) << 8);
    return E_OK;
}
