/*
 * Author: Eman Elsayed Ali
 * Email:  eman.elsayed.ali9@gmail.com
 */


#ifndef HC165_INTERFACE_H_
#define HC165_INTERFACE_H_

#include "STD_TYPES.h"


#define HC165_PL_PORT          GPIO_PORTD
#define HC165_PL_PIN           GPIO_PIN0

#define HC165_CE_PORT          GPIO_PORTD
#define HC165_CE_PIN           GPIO_PIN1
#define HC165_USE_CE           0u     

#define HC165_NUM_OF_DEVICES   2u


STD_ReturnType HC165_Init(void);


STD_ReturnType HC165_ReadByte(uint8 *Copy_pu8Data);


STD_ReturnType HC165_ReadMultiple(uint8 *Copy_pu8Buffer, uint8 Copy_u8NumOfDevices);


STD_ReturnType HC165_Read16Bits(uint16 *Copy_pu16Data);

#endif