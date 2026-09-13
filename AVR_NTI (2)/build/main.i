# 1 "main.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "main.c"
# 12 "main.c"
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
# 13 "main.c" 2
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
# 14 "main.c" 2
# 1 "MCAL/INTERRUPT/INTERRUPT_interface.h" 1
# 28 "MCAL/INTERRUPT/INTERRUPT_interface.h"
STD_ReturnType INTERRUPT_EnableGlobal(void);




STD_ReturnType INTERRUPT_DisableGlobal(void);





STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense);





STD_ReturnType EXTI_Enable(uint8 Copy_u8Int);




STD_ReturnType EXTI_Disable(uint8 Copy_u8Int);




STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int);
# 65 "MCAL/INTERRUPT/INTERRUPT_interface.h"
STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, void (*Copy_pfCallback)(void));
# 15 "main.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 16 "main.c" 2

void INT0_Handler(void);
int main(void) {

  GPIO_SetPinDirection(0u, 5u, 1u);
  GPIO_SetPinDirection(0u, 6u, 1u);
  GPIO_SetPinDirection(3u, 2u, 0u);

  TIMER0_Init();




  EXTI_SetCallback(0u, INT0_Handler);
  EXTI_SetSense(0u, 1u);
  EXTI_Enable(0u);
  INTERRUPT_EnableGlobal();

  while (1) {
    GPIO_TogglePinValue(0u, 5u);
    TIMER0_DelayMS(1000);
  }

  return 0;
}

void INT0_Handler(void) {
  GPIO_TogglePinValue(0u, 6u);
}
