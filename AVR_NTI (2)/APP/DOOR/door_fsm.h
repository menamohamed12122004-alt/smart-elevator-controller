#ifndef DOOR_FSM_H
#define DOOR_FSM_H

/*
 * Elevator Door FSM Header File
 * Manages Door States, Dwell Time, and Safety Reversal
 */

#include "STD_TYPES.h"

typedef enum {
    DOOR_CLOSED = 0,
    DOOR_OPENING,
    DOOR_OPEN,
    DOOR_CLOSING
} DoorState_t;

/* ---------------- Function Prototypes ---------------- */

/* تهيئة الـ FSM وحالة الباب الابتدائية */
void Door_Init(void);

/* طلب فتح الباب يدوياً أو عند الوصول لدور */
void Door_Open(void);

/* طلب إغلاق الباب يدوياً */
void Door_Close(void);

/* الدالة الرئيسية المسؤولة عن تنفيذ الـ FSM (تُستدعى دورياً في الـ Main Loop) */
void Door_Run(uint8 Copy_u8ObstructionDetected);

/* معرفة حالة الباب الحالية */
DoorState_t Door_GetState(void);

#endif /* DOOR_FSM_H */