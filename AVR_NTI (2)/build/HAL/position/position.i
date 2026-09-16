# 0 "HAL/position/position.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/position/position.c"
# 1 "HAL/position/position_interface.h" 1
# 2 "HAL/position/position.c" 2
# 1 "MCAL/ADC/ADC_interface.h" 1
# 9 "MCAL/ADC/ADC_interface.h"
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
# 10 "MCAL/ADC/ADC_interface.h" 2
# 42 "MCAL/ADC/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);




STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);




STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);




STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 3 "HAL/position/position.c" 2
# 11 "HAL/position/position.c"
static const float floor_positions[] = {0.0f, 150.0f, 300.0f, 450.0f};


void POS_Init(void) {

}

STD_ReturnType POS_GetCm(float *Copy_pfCurrentCm) {
    if (Copy_pfCurrentCm == ((void *)0)) {
        return E_NOK;
    }

    uint16 local_adc_raw = 0;


    STD_ReturnType local_status = ADC_ReadChannel(0u, &local_adc_raw);

    if (local_status == E_OK) {

        if (local_adc_raw <= (uint16)0.0f) {
            *Copy_pfCurrentCm = 0.0f;
        } else if (local_adc_raw >= (uint16)1023.0f) {
            *Copy_pfCurrentCm = 450.0f;
        } else {

            *Copy_pfCurrentCm = ((float)local_adc_raw - 0.0f) / (1023.0f - 0.0f)
                                * (450.0f - 0.0f) + 0.0f;
        }
        return E_OK;
    }

    return E_NOK;
}

sint32 POS_GetNearestFloor(float current_cm) {
    sint32 nearest_floor = 0;
    float min_diff = 1000000.0f;

    for (sint32 i = 0; i < (sint32)(sizeof(floor_positions) / sizeof(floor_positions[0])); i++) {
        float diff = current_cm - floor_positions[i];
        if (diff < 0.0f) {
            diff = -diff;
        }

        if (diff < min_diff) {
            min_diff = diff;
            nearest_floor = i;
        }
    }

    return nearest_floor;
}
