#ifndef DOOR_FSM_H
#define DOOR_FSM_H

/*
 * Elevator Door FSM Header File
 * Manages Door States, Dwell Time, and Safety Reversal
 */

#include "STD_TYPES.h"
#include "door_interface.h"   /* استدعاء الـ interface لجلب الـ DoorState_t أو الـ Door_State_t الموجود هناك */

/* ---------------- Function Prototypes ---------------- */

/* تهيئة الـ FSM وحالة الباب الابتدائية */
void Door_FSM_Init(void);

/* طلب فتح الباب عبر الـ FSM */
void Door_FSM_Open(void);

/* طلب إغلاق الباب عبر الـ FSM */
void Door_FSM_Close(void);

/* الدالة الرئيسية المسؤولة عن تنفيذ الـ FSM (تُستدعى دورياً في الـ Main Loop) */
void Door_Run(uint8 Copy_u8ObstructionDetected);

/* معرفة حالة الباب الحالية من الـ FSM */
Door_State_t Door_FSM_GetState(void);

#endif /* DOOR_FSM_H */