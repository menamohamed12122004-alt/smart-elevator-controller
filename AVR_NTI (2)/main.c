/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * AVR_NTI application entry.
 * Layers: LIB (types) -> MCAL (drivers) -> HAL (devices) -> Logic (app) ->
 * main.
 */

#define F_CPU 8000000UL

#include "STD_TYPES.h"
#include "TIMER_interface.h"
#include "INTERRUPT_interface.h"
#include "GPIO_interface.h"

void INT0_Handler(void);
int main(void) {

  GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN5, GPIO_OUTPUT);
  GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN6, GPIO_OUTPUT);
  GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN2, GPIO_INPUT);

  TIMER0_Init();

  /* Order matters: callback -> sense -> enable source -> enable global.
     Registering the callback last leaves a window where an edge can fire
     with no handler in place. */
  EXTI_SetCallback(EXTI_INT0, INT0_Handler);
  EXTI_SetSense(EXTI_INT0, EXTI_ANY_CHANGE);
  EXTI_Enable(EXTI_INT0);
  INTERRUPT_EnableGlobal();

  while (1) {
    GPIO_TogglePinValue(GPIO_PORTA, GPIO_PIN5);
    TIMER0_DelayMS(1000);
  }

  return 0;
}

void INT0_Handler(void) {
  GPIO_TogglePinValue(GPIO_PORTA, GPIO_PIN6);
}