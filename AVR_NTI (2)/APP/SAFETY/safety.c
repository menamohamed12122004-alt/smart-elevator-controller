#include "STD_TYPES.h"
#include "safety.h"

#define MAX_WEIGHT_GRAMS    65000U  /* Maximum allowed cabin weight */

static Safety_Fault_t g_eActiveFault = SAF_FAULT_NONE;

void SAF_Init(void) {
    g_eActiveFault = SAF_FAULT_NONE;
}

Safety_Fault_t SAF_Evaluate(uint8 Copy_u8EStopPin, 
                            uint8 Copy_u8OvertravelPin, 
                            uint8 Copy_u8FireAlarm, 
                            uint16 Copy_u16WeightGrams, 
                            uint8 Copy_u8DoorFault) {
    
    /* Strict Tier Evaluation (Order determines precedence) */
    if (Copy_u8EStopPin == 1) {
        g_eActiveFault = SAF_FAULT_ESTOP;
    } 
    else if (Copy_u8OvertravelPin == 1) {
        g_eActiveFault = SAF_FAULT_OVERTRAVEL;
    } 
    else if (Copy_u8FireAlarm == 1) {
        g_eActiveFault = SAF_FAULT_FIRE;
    } 
    else if (Copy_u16WeightGrams > MAX_WEIGHT_GRAMS) {
        g_eActiveFault = SAF_FAULT_OVERLOAD;
    } 
    else if (Copy_u8DoorFault == 1) {
        g_eActiveFault = SAF_FAULT_DOOR_STUCK;
    } 
    else {
        g_eActiveFault = SAF_FAULT_NONE;
    }

    return g_eActiveFault;
}

uint8 SAF_IsActive(void) {
    return (g_eActiveFault != SAF_FAULT_NONE) ? 1 : 0;
}

Safety_Fault_t SAF_GetActiveFault(void) {
    return g_eActiveFault;
}