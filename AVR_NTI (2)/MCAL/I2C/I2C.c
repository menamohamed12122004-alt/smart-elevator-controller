/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — I2C.c  (ATmega32 TWI master)
 * Implement every prototype from I2C_interface.h.
 */
#ifndef F_CPU
#define F_CPU 8000000UL
#include "STD_TYPES.h"
#include "I2C_interface.h"
#include "I2C_private.h"
#include "MATH.h"

/*
 * I2C_InitMaster
 * 1. Reject SCL == 0.
 * 2. TWBR = ((F_CPU / Copy_u32SclHz) - 16) / 2.  TWSR prescaler bits = 00.
 * 3. TWCR = (1 << TWEN). Do not send START here.
 */
STD_ReturnType I2C_InitMaster(uint32 Copy_u32SclHz)
{

    if(Copy_u32SclHz == NULL)
    {
        return E_NOK ;              // 1
    }
    else
    {
     TWSR = 0U ;                                                     // 2
     TWBR = (uint8)(((F_CPU / Copy_u32SclHz) - 16u) / 2u);           // 2
     TWCR = (uint8)(1 << TWEN) ;                                     // 3
    }
     return E_OK ; 
}

/*
 * I2C_SendStart
 * 1. TWCR = TWINT | TWSTA | TWEN.
 * 2. Wait for TWINT. Return E_OK only if status == I2C_START_ACK.
 */

  STD_ReturnType I2C_SendStart(void)
  {
     TWCR = (1u << TWINT) | (1u << TWSTA) | (1u << TWEN);

     while (CLR_BIT(TWCR, TWINT));  

	 return ((TWSR & 0xF8U) == I2C_START_ACK) ? E_OK : E_NOK;

  }
/*
 * I2C_SendRepeatedStart
 * 1. Same as START, but expect I2C_REP_START_ACK (0x10).
 */
STD_ReturnType I2C_SendRepeatedStart(void)
{
    TWCR = (uint8)((1U << TWINT) | (1U << TWSTA) | (1U << TWEN));

	while (CLR_BIT(TWCR, TWINT));  
	
	return ((TWSR & 0xF8U) == I2C_REP_START_ACK) ? E_OK : E_NOK;
}
/*
 * I2C_SendStop
 * 1. TWCR = TWINT | TWSTO | TWEN. No status check.
 */

 void I2C_SendStop(void)
 {
  TWCR = (uint8)((1U << TWINT) | (1U << TWSTO) | (1U << TWEN));
 }
/*
 * I2C_SendSlaveAddressWithWrite
 * 1. TWDR = (Copy_u8Address << 1) | 0.
 * 2. TWCR = TWINT | TWEN. Expect I2C_SLA_W_ACK (0x18).
 *
 * I2C_SendSlaveAddressWithRead
 * 1. TWDR = (Copy_u8Address << 1) | 1.
 * 2. Expect I2C_SLA_R_ACK (0x40).
 */
STD_ReturnType I2C_SendSlaveAddressWithWrite(uint8 Copy_u8Address)
{
   TWDR = (uint8) ((Copy_u8Address << 1U )  | 0U) ;               // 1

   TWCR = (uint8)((1U << TWINT) | (1U << TWEN));                  // 2

   while (CLR_BIT(TWCR, TWINT));  
	
   return ((TWSR & 0xF8U) == I2C_SLA_W_ACK) ? E_OK : E_NOK;
}

STD_ReturnType I2C_SendSlaveAddressWithRead(uint8 Copy_u8Address)
{
     TWDR = (uint8) ((Copy_u8Address << 1U )  | 1U) ;  

     TWCR = (uint8)((1U << TWINT) | (1U << TWEN));

	 while (CLR_BIT(TWCR, TWINT));  
	
	 return ((TWSR & 0xF8U) == I2C_SLA_R_ACK) ? E_OK : E_NOK;
}

/*
 * I2C_SendByte
 * 1. TWDR = Copy_u8Data. TWCR = TWINT | TWEN. Expect I2C_DATA_TX_ACK (0x28).
 */

STD_ReturnType I2C_SendByte(uint8 Copy_u8Data)
{
    TWDR = Copy_u8Data ;

    TWCR = (uint8)((1U << TWINT) | (1U << TWEN));                  

    while (CLR_BIT(TWCR, TWINT));  
 	
    return ((TWSR & 0xF8U) == I2C_DATA_TX_ACK) ? E_OK : E_NOK;

}
/*
 * I2C_ReceiveByte
 * 1. Reject a NULL pointer.
 * 2. If Copy_u8SendAck == I2C_ACK: TWCR = TWINT | TWEA | TWEN, expect 0x50.
 *    If I2C_NACK:                 TWCR = TWINT | TWEN,        expect 0x58.
 * 3. *Copy_pu8Data = TWDR.
 */

 STD_ReturnType I2C_ReceiveByte(uint8 *Copy_pu8Data, uint8 Copy_u8SendAck)
{
	uint8 local_u8ExpectedStatus;

	if (Copy_pu8Data == NULL)
	{
		return E_NOK;
	}

	if (Copy_u8SendAck == I2C_ACK)
	{
		TWCR = (uint8)((1U << TWINT) | (1U << TWEA) | (1U << TWEN));
		local_u8ExpectedStatus = I2C_DATA_RX_ACK;
	}
	else
	{
		TWCR = (uint8)((1U << TWINT) | (1U << TWEN));
		local_u8ExpectedStatus = I2C_DATA_RX_NACK;
	}

	while ((TWCR & (1U << TWINT)) == 0U)
	{
	}

	if ((TWSR & 0xF8U) != local_u8ExpectedStatus)
	{
		return E_NOK;
	}

	*Copy_pu8Data = TWDR;
	return E_OK;
}

 /*STD_ReturnType I2C_ReceiveByte(uint8 *Copy_pu8Data, uint8 Copy_u8SendAck)
{
    if(Copy_pu8Data == NULL)
    {
        return E_NOK ;
    
    }

    else if (Copy_u8SendAck == I2C_ACK )
    {
        TWCR = (uint8)((1U << TWINT) | (1U << TWEA) | (1U << TWEN));

         while (CLEAR_BIT(TWCR, TWINT));

         return ((TWSR & 0xF8U) == I2C_DATA_RX_ACK) ? E_OK : E_NOK;
    } 
    else                                                                  // if (Copy_u8SendAck == I2C_NACK )
    {
        TWCR = (1u << TWINT) | (1u << TWEN);

        while (CLEAR_BIT(TWCR, TWINT));
       
        return ((TWSR & 0xF8U) == I2C_DATA_RX_NACK) ? E_OK : E_NOK;
    }
    *Copy_pu8Data = TWDR;
}

/*
 * Typical 24Cxx write: START -> SLA+W -> word address -> data -> STOP
 * Typical 24Cxx read : START -> SLA+W -> word address -> REP START -> SLA+R -> data+NACK -> STOP
 */
#endif