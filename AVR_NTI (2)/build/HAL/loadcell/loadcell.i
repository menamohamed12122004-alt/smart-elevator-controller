# 0 "HAL/loadcell/loadcell.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/loadcell/loadcell.c"
# 1 "HAL/loadcell/loadcell.h" 1



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
# 5 "HAL/loadcell/loadcell.h" 2






void LOADCELL_Init(void);

uint16 LOADCELL_ReadKg(void);

uint8 LOADCELL_IsOverloaded(void);
# 2 "HAL/loadcell/loadcell.c" 2
# 1 "MCAL/ADC/ADC_interface.h" 1
# 42 "MCAL/ADC/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);




STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);




STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);




STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 3 "HAL/loadcell/loadcell.c" 2

static uint16 s_currentLoadKg = 0u;
static uint8 s_isOverloaded = 0u;


static uint16 s_samples[3] = {0u, 0u, 0u};
static uint8 s_sampleIdx = 0u;


static uint16 GetMedianOfThree(uint16 a, uint16 b, uint16 c)
{
    if ((a >= b && a <= c) || (a <= b && a >= c))
    {
        return a;
    }
    if ((b >= a && b <= c) || (b <= a && b >= c))
    {
        return b;
    }
    return c;
}


void LOADCELL_Init(void)
{
    s_currentLoadKg = 0u;
    s_isOverloaded = 0u;
    s_sampleIdx = 0u;

    s_samples[0] = 0u;
    s_samples[1] = 0u;
    s_samples[2] = 0u;
}

uint16 LOADCELL_ReadKg(void)
{

    uint16 rawAdc ;
    STD_ReturnType status = ADC_ReadChannel(1u, &rawAdc);


    s_samples[s_sampleIdx] = rawAdc;
    s_sampleIdx = (s_sampleIdx + 1u) % 3u;


    uint16 filteredAdc = GetMedianOfThree(s_samples[0], s_samples[1], s_samples[2]);


    s_currentLoadKg = (uint16)(((uint32)filteredAdc * 1000u) / 1023u);


    if (s_currentLoadKg > 900u)
    {
        s_isOverloaded = 1u;
    }
    else if (s_currentLoadKg < 850u)
    {
        s_isOverloaded = 0u;
    }
    else
    {

    }

    return s_currentLoadKg;
}

uint8 LOADCELL_IsOverloaded(void)
{
    return s_isOverloaded;
}
