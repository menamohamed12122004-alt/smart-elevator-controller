#define F_CPU 8000000UL
#include <util/delay.h>
#include "STD_TYPES.h"
#include "I2C_interface.h"
#include "lcd_i2c.h"

#define LCD_RS_PIN     (1U << 0)
#define LCD_EN_PIN     (1U << 2)
#define LCD_BACKLIGHT  (1U << 3)

static uint8 Global_u8SlaveAddress = 0x27U;
static uint8 Global_u8BacklightState = LCD_BACKLIGHT;

static void LCD_I2C_WritePulse(uint8 Copy_u8DataToSend)
{
    I2C_SendStart();
    I2C_SendSlaveAddressWithWrite(Global_u8SlaveAddress);

    uint8 Local_u8DataPacket = Copy_u8DataToSend | Global_u8BacklightState;
    
    I2C_SendByte(Local_u8DataPacket | LCD_EN_PIN);
    _delay_us(1);
    I2C_SendByte(Local_u8DataPacket & ~LCD_EN_PIN);
    _delay_us(50);

    I2C_SendStop();
}

static void LCD_I2C_SendHalfPort(uint8 Copy_u8DataNibble, uint8 Copy_u8RsValue)
{
    uint8 Local_u8PortVal = 0;

    Local_u8PortVal |= (Copy_u8DataNibble & 0xF0U);

    if (Copy_u8RsValue == 1U)
    {
        Local_u8PortVal |= LCD_RS_PIN;
    }
    else
    {
        Local_u8PortVal &= ~LCD_RS_PIN;
    }

    LCD_I2C_WritePulse(Local_u8PortVal);
}

void LCD_I2C_Init(uint8 Copy_u8SlaveAddress)
{
    Global_u8SlaveAddress = Copy_u8SlaveAddress;
    
    _delay_ms(50);
    _delay_ms(20);
    
    LCD_I2C_SendHalfPort(0x30U, 0U);
    _delay_ms(5);
    LCD_I2C_SendHalfPort(0x30U, 0U);
    _delay_us(150);
    LCD_I2C_SendHalfPort(0x30U, 0U);
    
    LCD_I2C_SendHalfPort(0x20U, 0U);

    LCD_I2C_SendCommand(0x28U);
    LCD_I2C_SendCommand(0x0CU);
    LCD_I2C_Clear();
    LCD_I2C_SendCommand(0x06U);
}

void LCD_I2C_SendCommand(uint8 Copy_u8Command)
{
    LCD_I2C_SendHalfPort(Copy_u8Command & 0xF0U, 0U);
    LCD_I2C_SendHalfPort((Copy_u8Command << 4U) & 0xF0U, 0U);
    _delay_ms(2);
}

void LCD_I2C_SendData(uint8 Copy_u8Data)
{
    LCD_I2C_SendHalfPort(Copy_u8Data & 0xF0U, 1U);
    LCD_I2C_SendHalfPort((Copy_u8Data << 4U) & 0xF0U, 1U);
    _delay_ms(2);
}

void LCD_I2C_SendString(const char *Copy_pcString)
{
    while (*Copy_pcString != '\0')
    {
        LCD_I2C_SendData((uint8)*Copy_pcString);
        Copy_pcString++;
    }
}

void LCD_I2C_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col)
{
    uint8 Local_u8Address = 0;

    if (Copy_u8Row == 0U)
    {
        Local_u8Address = 0x80U + Copy_u8Col;
    }
    else if (Copy_u8Row == 1U)
    {
        Local_u8Address = 0xC0U + Copy_u8Col;
    }

    LCD_I2C_SendCommand(Local_u8Address);
}

void LCD_I2C_Clear(void)
{
    LCD_I2C_SendCommand(0x01U);
    _delay_ms(2);
}