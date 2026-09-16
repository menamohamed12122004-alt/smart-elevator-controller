# 0 "MCAL/TIMER/TIMER.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/TIMER/TIMER.c"
# 19 "MCAL/TIMER/TIMER.c"
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
# 20 "MCAL/TIMER/TIMER.c" 2
# 1 "MCAL/TIMER/TIMER_interface.h" 1
# 29 "MCAL/TIMER/TIMER_interface.h"
STD_ReturnType TIMER0_Init(void);




STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds);




STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds);







STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent);




STD_ReturnType TIMER0_Stop(void);






STD_ReturnType TIMER1_Init(void);




STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds);
# 73 "MCAL/TIMER/TIMER_interface.h"
STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent);




STD_ReturnType TIMER1_Stop(void);
# 21 "MCAL/TIMER/TIMER.c" 2
# 1 "MCAL/TIMER/TIMER_private.h" 1
# 22 "MCAL/TIMER/TIMER.c" 2





static void TIMER_WaitFlag(volatile uint8 *Copy_pu8Register, uint8 Copy_u8BitMask)
{
    while ((*Copy_pu8Register & Copy_u8BitMask) == 0u)
    {
    }

    *Copy_pu8Register = Copy_u8BitMask;
}

static uint16 TIMER_DutyToCompare(uint16 Copy_u16Top, uint8 Copy_u8DutyPercent)
{
    return (uint16)(((uint32)(Copy_u16Top + 1u) * Copy_u8DutyPercent) / 100u);
}





STD_ReturnType TIMER0_Init(void)
{
    (*(volatile uint8*)0x53) = (1u << 3u);
    (*(volatile uint8*)0x5C) = 124u;
    (*(volatile uint8*)0x52) = 0u;
    return E_OK;
}

STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds)
{
    uint16 Local_u16Index;

    (*(volatile uint8*)0x58) = (1u << 1u);
    (*(volatile uint8*)0x53) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    (*(volatile uint8*)0x53) |= (1u << 1u) | (1u << 0u);

    for (Local_u16Index = 0u; Local_u16Index < Copy_u16Milliseconds; Local_u16Index++)
    {
        TIMER_WaitFlag(&(*(volatile uint8*)0x58), (1u << 1u));
    }

    (*(volatile uint8*)0x53) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    return E_OK;
}

STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds)
{
    uint16 Local_u16Index;

    for (Local_u16Index = 0u; Local_u16Index < Copy_u16Seconds; Local_u16Index++)
    {
        TIMER0_DelayMS(1000u);
    }

    return E_OK;
}

STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent)
{
    if (Copy_u8DutyPercent > 100u)
    {
        return E_NOK;
    }

    (*(volatile uint8*)0x37) |= (1u << 3u);
    (*(volatile uint8*)0x53) = (1u << 3u) | (1u << 6u) | (1u << 5u);
    (*(volatile uint8*)0x5C) = TIMER_DutyToCompare(255u, Copy_u8DutyPercent);
    (*(volatile uint8*)0x53) |= (1u << 1u) | (1u << 0u);

    return E_OK;
}

STD_ReturnType TIMER0_Stop(void)
{
    (*(volatile uint8*)0x53) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    (*(volatile uint8*)0x53) &= ~((1u << 5u) | (1u << 4u));
    return E_OK;
}





STD_ReturnType TIMER1_Init(void)
{
    (*(volatile uint8*)0x4F) &= ~((1u << 1u) | (1u << 0u));
    (*(volatile uint8*)0x4E) &= ~(1u << 4u);
    (*(volatile uint8*)0x4E) |= (1u << 3u);
    (*(volatile uint16*)0x4A) = 999u;
    (*(volatile uint16*)0x4C) = 0u;
    (*(volatile uint8*)0x4E) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    return E_OK;
}

STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds)
{
    uint16 Local_u16Index;

    (*(volatile uint8*)0x58) = (1u << 4u);
    (*(volatile uint8*)0x4E) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    (*(volatile uint8*)0x4E) |= (1u << 1u);

    for (Local_u16Index = 0u; Local_u16Index < Copy_u16Milliseconds; Local_u16Index++)
    {
        TIMER_WaitFlag(&(*(volatile uint8*)0x58), (1u << 4u));
    }

    (*(volatile uint8*)0x4E) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    return E_OK;
}

STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent)
{
    uint32 Local_u32Period;

    if ((Copy_u8DutyPercent > 100u) || (Copy_u16FrequencyHz < 16u) || (Copy_u16FrequencyHz > 20000u))
    {
        return E_NOK;
    }

    (*(volatile uint8*)0x31) |= (1u << 5u);
    (*(volatile uint8*)0x4F) = (1u << 7u) | (1u << 1u);
    (*(volatile uint8*)0x4E) = (1u << 4u) | (1u << 3u) | (1u << 1u);

    Local_u32Period = (1000000UL / (uint32)Copy_u16FrequencyHz) - 1UL;
    (*(volatile uint16*)0x46) = (uint16)Local_u32Period;
    (*(volatile uint16*)0x4A) = TIMER_DutyToCompare((*(volatile uint16*)0x46), Copy_u8DutyPercent);

    return E_OK;
}

STD_ReturnType TIMER1_Stop(void)
{
    (*(volatile uint8*)0x4E) &= ~((1u << 2u) | (1u << 1u) | (1u << 0u));
    (*(volatile uint8*)0x4F) &= ~((1u << 7u) | (1u << 6u));
    return E_OK;
}
