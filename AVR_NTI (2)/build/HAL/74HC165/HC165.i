# 0 "HAL/74HC165/HC165.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/74HC165/HC165.c"
# 10 "HAL/74HC165/HC165.c"
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
# 11 "HAL/74HC165/HC165.c" 2
# 1 "LIB/MATH.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/MATH.h" 2
# 12 "HAL/74HC165/HC165.c" 2
# 1 "MCAL/GPIO/GPIO_INTERFACE.h" 1
# 42 "MCAL/GPIO/GPIO_INTERFACE.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 13 "HAL/74HC165/HC165.c" 2
# 1 "MCAL/SPI/SPI_INTERFACE.h" 1
# 30 "MCAL/SPI/SPI_INTERFACE.h"
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);




STD_ReturnType SPI_InitSlave(void);





STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);





STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 14 "HAL/74HC165/HC165.c" 2
# 1 "HAL/74HC165/HC165_INTERFACE.h" 1
# 40 "HAL/74HC165/HC165_INTERFACE.h"
void BTN_Init(void);




uint8 BTN_Scan(void);


uint8 BTN_Pressed(uint8 Copy_u8Button);



uint8 BTN_PressedEdge(uint8 Copy_u8Button);


uint8 BTN_ReleasedEdge(uint8 Copy_u8Button);


uint16 BTN_GetAll(void);


uint16 BTN_GetRaw(void);


void BTN_ClearEdges(void);
# 15 "HAL/74HC165/HC165.c" 2
