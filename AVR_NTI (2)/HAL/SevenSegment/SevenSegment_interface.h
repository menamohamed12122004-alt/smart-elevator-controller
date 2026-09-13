#ifndef SEVENSEGMENT_INTERFACE_H
#define SEVENSEGMENT_INTERFACE_H

#include "STD_TYPES.h"
#include "GPIO_interface.h"

STD_ReturnType SevenSegment_Init(uint8 port);
STD_ReturnType SevenSegment_Display(uint8 port, uint8 digit);

#endif // SEVENSEGMENT_INTERFACE_H