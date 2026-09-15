#ifndef DIO_INTERFACE_H
#define DIO_INTERFACE_H

#define CAR_PORT        GPIO_PORTA
#define FLOOR_PORT      GPIO_PORTB

#define CAR_BUTTON_1    GPIO_PIN0
#define CAR_BUTTON_2    GPIO_PIN1
#define CAR_BUTTON_3    GPIO_PIN2
#define CAR_BUTTON_4    GPIO_PIN3

#define FLOOR_BUTTON_1  GPIO_PIN4
#define FLOOR_BUTTON_2  GPIO_PIN5
#define FLOOR_BUTTON_3  GPIO_PIN6
#define FLOOR_BUTTON_4  GPIO_PIN7

STD_ReturnType Elevator_InitButtons(void);
STD_ReturnType Elevator_ReadCarButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State);
STD_ReturnType Elevator_ReadFloorButton(uint8 Copy_u8Floor, uint8 *Copy_pu8State);

#endif