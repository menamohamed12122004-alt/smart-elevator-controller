#include "KeyPad_interface.h"

STD_ReturnType KeyPad_Init(uint8 port) {
    if (port > GPIO_PORTD) {
        // Invalid port, handle error (e.g., return or assert)
        return E_NOK;
    }
    // Set the first 4 pins of the specified port as output (for rows)
    GPIO_SetPortDirection(port, 0xF0);
    return E_OK;
}

STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *pressedKey) {
    if (port > GPIO_PORTD || pressedKey == NULL) {
        // Invalid port or null pointer, handle error
        return E_NOK;
    }
    // Set the first 4 pins of the specified port as input (for columns)
    GPIO_SetPortDirection(port, 0xF0);

    // Read the column values from the specified port
    uint8 columnValues;
    GPIO_GetPortValue(port, &columnValues);

    for (uint8 row = 0; row < 4; row++) {
        // Set the current row pin to LOW and others to HIGH
        GPIO_SetPortValue(port, ~(1 << (row + 4)));
        for (uint8 col = 0; col < 4; col++) {
            // Read the column values again
            GPIO_GetPortValue(port, &columnValues);
            if (!(columnValues & (1 << col))) {
                // A key is pressed at (row, col)
                *pressedKey = row * 4 + col;
                return E_OK;
            }
        }
    }
    *pressedKey = 0xFF; // Indicate no key pressed
    return E_OK;
}