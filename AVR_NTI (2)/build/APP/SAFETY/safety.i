# 0 "APP/SAFETY/safety.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/SAFETY/safety.c"
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
# 2 "APP/SAFETY/safety.c" 2
# 1 "APP/SAFETY/safety.h" 1






typedef enum {
    SAF_FAULT_NONE = 0,
    SAF_FAULT_ESTOP,
    SAF_FAULT_OVERTRAVEL,
    SAF_FAULT_FIRE,
    SAF_FAULT_OVERLOAD,
    SAF_FAULT_DOOR_STUCK,
    SAF_FAULT_SENSOR_ERR,
    SAF_FAULT_COMM_TIMEOUT
} Safety_Fault_t;



void SAF_Init(void);


Safety_Fault_t SAF_Evaluate(uint8 Copy_u8EStopPin,
                            uint8 Copy_u8OvertravelPin,
                            uint8 Copy_u8FireAlarm,
                            uint16 Copy_u16WeightGrams,
                            uint8 Copy_u8DoorFault);


uint8 SAF_IsActive(void);


Safety_Fault_t SAF_GetActiveFault(void);
# 3 "APP/SAFETY/safety.c" 2



static Safety_Fault_t g_eActiveFault = SAF_FAULT_NONE;

void SAF_Init(void) {
    g_eActiveFault = SAF_FAULT_NONE;
}

Safety_Fault_t SAF_Evaluate(uint8 Copy_u8EStopPin,
                            uint8 Copy_u8OvertravelPin,
                            uint8 Copy_u8FireAlarm,
                            uint16 Copy_u16WeightGrams,
                            uint8 Copy_u8DoorFault) {


    if (Copy_u8EStopPin == 1) {
        g_eActiveFault = SAF_FAULT_ESTOP;
    }
    else if (Copy_u8OvertravelPin == 1) {
        g_eActiveFault = SAF_FAULT_OVERTRAVEL;
    }
    else if (Copy_u8FireAlarm == 1) {
        g_eActiveFault = SAF_FAULT_FIRE;
    }
    else if (Copy_u16WeightGrams > 65000U) {
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
