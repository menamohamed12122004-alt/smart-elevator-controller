#ifndef SAFETY_H
#define SAFETY_H

#include "STD_TYPES.h"

/* 7-Tier Strict Safety Precedence */
typedef enum {
    SAF_FAULT_NONE = 0,
    SAF_FAULT_ESTOP,        /* Tier 1: Hardware Emergency Stop (Highest Priority) */
    SAF_FAULT_OVERTRAVEL,   /* Tier 2: Cabin passed limit switches */
    SAF_FAULT_FIRE,         /* Tier 3: Building Fire Alarm */
    SAF_FAULT_OVERLOAD,     /* Tier 4: Passenger Weight > Maximum Limit */
    SAF_FAULT_DOOR_STUCK,   /* Tier 5: Door Obstruction / Timeout */
    SAF_FAULT_SENSOR_ERR,   /* Tier 6: ADC or Sensor Communication Failure */
    SAF_FAULT_COMM_TIMEOUT  /* Tier 7: Lost Building Console Connection */
} Safety_Fault_t;

/* ---------------- Function Prototypes ---------------- */

void SAF_Init(void);

/* Evaluates inputs according to the 7-tier strict precedence */
Safety_Fault_t SAF_Evaluate(uint8 Copy_u8EStopPin, 
                            uint8 Copy_u8OvertravelPin, 
                            uint8 Copy_u8FireAlarm, 
                            uint16 Copy_u16WeightGrams, 
                            uint8 Copy_u8DoorFault);

/* Returns 1 if any safety fault is active, 0 if safe */
uint8 SAF_IsActive(void);

/* Get current active highest priority fault */
Safety_Fault_t SAF_GetActiveFault(void);

#endif /* SAFETY_H */