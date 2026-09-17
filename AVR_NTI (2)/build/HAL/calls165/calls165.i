# 0 "HAL/calls165/calls165.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/calls165/calls165.c"




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
# 6 "HAL/calls165/calls165.c" 2
# 1 "HAL/74HC165/HC165_interface.h" 1
# 23 "HAL/74HC165/HC165_interface.h"
STD_ReturnType HC165_Init(void);


STD_ReturnType HC165_ReadByte(uint8 *Copy_pu8Data);


STD_ReturnType HC165_ReadMultiple(uint8 *Copy_pu8Buffer, uint8 Copy_u8NumOfDevices);


STD_ReturnType HC165_Read16Bits(uint16 *Copy_pu16Data);
# 7 "HAL/calls165/calls165.c" 2
# 1 "HAL/calls165/calls165_interface.h" 1






void BTN_Init(void);


void BTN_Scan(void);


uint8 BTN_Pressed(uint8 Copy_u8ButtonId);
# 8 "HAL/calls165/calls165.c" 2



static uint16 g_u16CurrentButtonStates = 0;
static uint16 g_u16LastButtonStates = 0;

void BTN_Init(void) {

    HC165_Init();
    g_u16CurrentButtonStates = 0;
    g_u16LastButtonStates = 0;
}

void BTN_Scan(void) {
    uint16 Local_u16RawData = 0;


    g_u16LastButtonStates = g_u16CurrentButtonStates;


    if (HC165_Read16Bits(&Local_u16RawData) == E_OK) {
        g_u16CurrentButtonStates = Local_u16RawData;
    }
}

uint8 BTN_Pressed(uint8 Copy_u8ButtonId) {
    if (Copy_u8ButtonId >= 16u) {
        return 0;
    }


    if ((g_u16CurrentButtonStates & (1u << Copy_u8ButtonId)) != 0) {
        return 1;
    }

    return 0;
}
