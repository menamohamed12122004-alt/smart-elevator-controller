#ifndef KEYPAD_INTERFACE_H
#define KEYPAD_INTERFACE_H

#include "STD_TYPES.h"
#include "GPIO_interface.h"

STD_ReturnType KeyPad_Init(uint8 port);
STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *pressedKey);

#endif // KEYPAD_INTERFACE_H