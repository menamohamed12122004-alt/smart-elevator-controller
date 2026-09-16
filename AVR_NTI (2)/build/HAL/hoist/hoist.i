# 0 "HAL/hoist/hoist.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/hoist/hoist.c"
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
# 2 "HAL/hoist/hoist.c" 2
# 1 "LIB/MATH.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/MATH.h" 2
# 3 "HAL/hoist/hoist.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 42 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 4 "HAL/hoist/hoist.c" 2
# 1 "MCAL/TIMER/timer_interface.h" 1
# 29 "MCAL/TIMER/timer_interface.h"
STD_ReturnType TIMER0_Init(void);




STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds);




STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds);







STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent);




STD_ReturnType TIMER0_Stop(void);






STD_ReturnType TIMER1_Init(void);




STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds);
# 73 "MCAL/TIMER/timer_interface.h"
STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent);




STD_ReturnType TIMER1_Stop(void);
# 5 "HAL/hoist/hoist.c" 2
# 1 "MCAL/TIMER/pwm_interface.h" 1





void PWM_Init(void);
void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle);
# 6 "HAL/hoist/hoist.c" 2

# 1 "HAL/hoist/hoist_private.h" 1
# 8 "HAL/hoist/hoist.c" 2
# 1 "HAL/hoist/hoist_interface.h" 1





void Motor_Init(void);
void Motor_MoveUp(void);
void Motor_MoveDown(void);
void Motor_Stop(void);
void Motor_SetSpeed(uint8 Copy_u8Speed);
# 9 "HAL/hoist/hoist.c" 2

void Motor_Init(void)
{
    GPIO_SetPinDirection(1u, 0u, 1u);
    GPIO_SetPinDirection(1u, 1u, 1u);
    Motor_Stop();
}

void Motor_MoveUp(void)
{
    GPIO_SetPinValue(1u, 0u, 1u);
    GPIO_SetPinValue(1u, 1u, 0u);
}

void Motor_MoveDown(void)
{
    GPIO_SetPinValue(1u, 0u, 0u);
    GPIO_SetPinValue(1u, 1u, 1u);
}

void Motor_Stop(void)
{
    GPIO_SetPinValue(1u, 0u, 0u);
    GPIO_SetPinValue(1u, 1u, 0u);
    Motor_SetSpeed(0);
}

void Motor_SetSpeed(uint8 Copy_u8Speed)
{
    PWM_SetDutyCycle(0,Copy_u8Speed);
}
