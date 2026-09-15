#ifndef EXTI_INTERFACE_H
#define EXTI_INTERFACE_H

/*
 * Author: Menna Allah (Elevator Controller Project PRJ-08-ELEVATOR)
 * MCAL EXTI — Public Interface Header
 */

#include "STD_TYPES.h"

/* ---------------- EXTI Hardware Channels ---------------- */
#define EXTI_INT0           0u   /* PD2: Emergency Stop Pushbutton (NC Logic) */
#define EXTI_INT1           1u   /* PD3: Door Safety Edge IR Sensor            */
#define EXTI_INT2           2u   /* PB2: Auxiliary Line (If needed)           */

/* ---------------- EXTI Sense Control Modes ---------------- */
#define EXTI_LOW_LEVEL      0u   /* Trigger on Low Level                      */
#define EXTI_ON_CHANGE      1u   /* Trigger on Any Logical Change             */
#define EXTI_FALLING_EDGE   2u   /* Trigger on Falling Edge (Door IR Receiver) */
#define EXTI_RISING_EDGE    3u   /* Trigger on Rising Edge (Emergency Stop Button) */

/*
 * Description : Configures EXTI Pin Direction, Sense Control Signal, 
 *               and enables Global/Peripheral Interrupts.
 */
STD_ReturnType EXTI_Init(uint8 Copy_u8Channel, uint8 Copy_u8SenseMode);

/*
 * Description : Enables a specific EXTI Peripheral Channel (INT0 / INT1 / INT2).
 */
STD_ReturnType EXTI_EnableChannel(uint8 Copy_u8Channel);

/*
 * Description : Disables a specific EXTI Peripheral Channel.
 */
STD_ReturnType EXTI_DisableChannel(uint8 Copy_u8Channel);

/*
 * Description : Pass a function address from APP/HAL layer to be executed inside ISR.
 *               Ensures strict Layering compliance.
 */
STD_ReturnType EXTI_SetCallBack(uint8 Copy_u8Channel, void (*Copy_pvoidCallBack)(void));

#endif /* EXTI_INTERFACE_H */