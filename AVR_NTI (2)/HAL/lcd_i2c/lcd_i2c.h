#ifndef LCD_I2C_INTERFACE_H_
#define LCD_I2C_INTERFACE_H_

#include "STD_TYPES.h"

void LCD_I2C_Init(uint8 Copy_u8SlaveAddress);
void LCD_I2C_SendCommand(uint8 Copy_u8Command);
void LCD_I2C_SendData(uint8 Copy_u8Data);
void LCD_I2C_SendString(const char *Copy_pcString);
void LCD_I2C_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
void LCD_I2C_Clear(void);

#endif
