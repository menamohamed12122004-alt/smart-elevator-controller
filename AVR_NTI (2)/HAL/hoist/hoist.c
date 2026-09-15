#include "STD_TYPES.h"
#include "MATH.h"
#include "GPIO_interface.h"
#include "timer_interface.h"
#include "pwm_interface.h"

#include "hoist_private.h"
#include "hoist_interface.h"

void Motor_Init(void)
{
    GPIO_SetPinDirection(MOTOR_PORT, MOTOR_PIN_IN1, GPIO_OUTPUT);
    GPIO_SetPinDirection(MOTOR_PORT, MOTOR_PIN_IN2, GPIO_OUTPUT);
    Motor_Stop();
}

void Motor_MoveUp(void)
{
    GPIO_SetPinValue(MOTOR_PORT, MOTOR_PIN_IN1, GPIO_HIGH);
    GPIO_SetPinValue(MOTOR_PORT, MOTOR_PIN_IN2, GPIO_LOW);
}

void Motor_MoveDown(void)
{
    GPIO_SetPinValue(MOTOR_PORT, MOTOR_PIN_IN1, GPIO_LOW);
    GPIO_SetPinValue(MOTOR_PORT, MOTOR_PIN_IN2, GPIO_HIGH);
}

void Motor_Stop(void)
{
    GPIO_SetPinValue(MOTOR_PORT, MOTOR_PIN_IN1, GPIO_LOW);
    GPIO_SetPinValue(MOTOR_PORT, MOTOR_PIN_IN2, GPIO_LOW);
    Motor_SetSpeed(0);
}

void Motor_SetSpeed(uint8 Copy_u8Speed)
{
    PWM_SetDutyCycle(0,Copy_u8Speed);
}