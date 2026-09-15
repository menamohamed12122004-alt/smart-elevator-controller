# 0 "MCAL/EXTI/EXTI.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/EXTI/EXTI.c"





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
# 7 "MCAL/EXTI/EXTI.c" 2
# 1 "MCAL/EXTI/EXTI_interface.h" 1
# 26 "MCAL/EXTI/EXTI_interface.h"
STD_ReturnType EXTI_Init(uint8 Copy_u8Channel, uint8 Copy_u8SenseMode);




STD_ReturnType EXTI_EnableChannel(uint8 Copy_u8Channel);




STD_ReturnType EXTI_DisableChannel(uint8 Copy_u8Channel);





STD_ReturnType EXTI_SetCallBack(uint8 Copy_u8Channel, void (*Copy_pvoidCallBack)(void));
# 8 "MCAL/EXTI/EXTI.c" 2
# 1 "MCAL/EXTI/EXTI_private.h" 1
# 9 "MCAL/EXTI/EXTI.c" 2


static void (*g_EXTI_CallBacks[3])(void) = {((void *)0), ((void *)0), ((void *)0)};

STD_ReturnType EXTI_Init(uint8 Copy_u8Channel, uint8 Copy_u8SenseMode) {
    if (Copy_u8Channel > 2u) {
        return E_NOK;
    }


    if (Copy_u8Channel == 0u) {
        (*(volatile uint8 *)0x31) &= ~(1 << 2);
        (*(volatile uint8 *)0x32) |= (1 << 2);
    } else if (Copy_u8Channel == 1u) {
        (*(volatile uint8 *)0x31) &= ~(1 << 3);
        (*(volatile uint8 *)0x32) |= (1 << 3);
    }


    switch (Copy_u8Channel) {
        case 0u:

            (*(volatile uint8 *)0x55) &= ~((1 << 0) | (1 << 1));

            (*(volatile uint8 *)0x55) |= (Copy_u8SenseMode & 0x03);
            break;

        case 1u:

            (*(volatile uint8 *)0x55) &= ~((1 << 2) | (1 << 3));

            (*(volatile uint8 *)0x55) |= ((Copy_u8SenseMode & 0x03) << 2);
            break;

        case 2u:
            if (Copy_u8SenseMode == 2u) {
                (*(volatile uint8 *)0x54) &= ~(1 << 6);
            } else if (Copy_u8SenseMode == 3u) {
                (*(volatile uint8 *)0x54) |= (1 << 6);
            } else {
                return E_NOK;
            }
            break;

        default:
            return E_NOK;
    }


    EXTI_EnableChannel(Copy_u8Channel);


    (*(volatile uint8 *)0x5F) |= (1 << 7);

    return E_OK;
}

STD_ReturnType EXTI_EnableChannel(uint8 Copy_u8Channel) {
    switch (Copy_u8Channel) {
        case 0u: (*(volatile uint8 *)0x5B) |= (1 << 6); break;
        case 1u: (*(volatile uint8 *)0x5B) |= (1 << 7); break;
        case 2u: (*(volatile uint8 *)0x5B) |= (1 << 5); break;
        default: return E_NOK;
    }
    return E_OK;
}

STD_ReturnType EXTI_DisableChannel(uint8 Copy_u8Channel) {
    switch (Copy_u8Channel) {
        case 0u: (*(volatile uint8 *)0x5B) &= ~(1 << 6); break;
        case 1u: (*(volatile uint8 *)0x5B) &= ~(1 << 7); break;
        case 2u: (*(volatile uint8 *)0x5B) &= ~(1 << 5); break;
        default: return E_NOK;
    }
    return E_OK;
}

STD_ReturnType EXTI_SetCallBack(uint8 Copy_u8Channel, void (*Copy_pvoidCallBack)(void)) {
    if (Copy_u8Channel > 2u || Copy_pvoidCallBack == ((void *)0)) {
        return E_NOK;
    }
    g_EXTI_CallBacks[Copy_u8Channel] = Copy_pvoidCallBack;
    return E_OK;
}




void __vector_1 (void) __attribute__ ((signal, used)); void __vector_1 (void) {
    if (g_EXTI_CallBacks[0u] != ((void *)0)) {
        g_EXTI_CallBacks[0u]();
    }
}


void __vector_2 (void) __attribute__ ((signal, used)); void __vector_2 (void) {
    if (g_EXTI_CallBacks[1u] != ((void *)0)) {
        g_EXTI_CallBacks[1u]();
    }
}


void __vector_3 (void) __attribute__ ((signal, used)); void __vector_3 (void) {
    if (g_EXTI_CallBacks[2u] != ((void *)0)) {
        g_EXTI_CallBacks[2u]();
    }
}
