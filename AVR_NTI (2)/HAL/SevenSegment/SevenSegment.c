#include "SevenSegment_interface.h"


STD_ReturnType SevenSegment_Init(uint8 port) {
    if (port > GPIO_PORTD) {
        // Invalid port, handle error (e.g., return or assert)
        return E_NOK;
    }
  // Set all pins of the specified port as output
  GPIO_SetPortDirection(port, 0xFF);
  return E_OK;
}


STD_ReturnType SevenSegment_Display(uint8 port, uint8 digit) {
    if (digit > 9) {
        // Invalid digit, handle error (e.g., return or assert)
        return E_NOK;
    }

    // Define the segment patterns for digits 0-9
    const uint8 segmentPatterns[10] = {
        0b00111111, // 0
        0b00000110, // 1
        0b01011011, // 2
        0b01001111, // 3
        0b01100110, // 4
        0b01101101, // 5
        0b01111101, // 6
        0b00000111, // 7
        0b01111111, // 8
        0b01101111  // 9
    };

    // Set the segment values for the specified digit
    GPIO_SetPortValue(port, segmentPatterns[digit]);
    return E_OK;
}