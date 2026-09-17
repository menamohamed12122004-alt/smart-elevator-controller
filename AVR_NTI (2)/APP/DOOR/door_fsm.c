/*
 * Elevator Door FSM Implementation File
 */

#include "STD_TYPES.h"
#include "door_interface.h"   /* نحتاج استدعاء الـ interface الخاص بالهاردوير */
#include "door_fsm.h"

#define DWELL_TIME_TICKS     50    /* زمن بقاء الباب مفتوحاً قبل البدء بالإغلاق تلقائياً */
#define MOVEMENT_TIME_TICKS  30    /* زمن يستغرقه الباب للفتح أو الإغلاق الكامل */

static Door_State_t g_eCurrentState = DOOR_CLOSED;
static uint16 g_u16TimerTicks = 0;

void Door_FSM_Init(void) {
    g_eCurrentState = DOOR_CLOSED;
    g_u16TimerTicks = 0;
    // استدعاء تهيئة الهاردوير الفعلي
    Door_Init();
}

void Door_FSM_Open(void) {
    if (g_eCurrentState != DOOR_OPENED) {
        g_eCurrentState = DOOR_OPENING;
        g_u16TimerTicks = 0;
        // تطبيق الأمر فعلياً على الهاردوير
        Door_Open(); 
    }
}

void Door_FSM_Close(void) {
    if (g_eCurrentState == DOOR_OPENED) {
        g_eCurrentState = DOOR_CLOSING;
        g_u16TimerTicks = 0;
        // تطبيق الأمر فعلياً على الهاردوير
        Door_Close();
    }
}

Door_State_t Door_FSM_GetState(void) {
    return g_eCurrentState;
}

void Door_Run(uint8 Copy_u8ObstructionDetected) {
    switch (g_eCurrentState) {
        
        case DOOR_CLOSED:
            /* الباب مغلق بالكامل، بانتظار أمر فتح */
            break;

        case DOOR_OPENING:
            g_u16TimerTicks++;
            /* الانتهاء من الفتح بعد انقضاء الوقت المطلوب */
            if (g_u16TimerTicks >= MOVEMENT_TIME_TICKS) {
                g_eCurrentState = DOOR_OPENED;
                g_u16TimerTicks = 0;
            }
            break;

        case DOOR_OPENED:
            /* في حالة اكتشاف عائق أثناء الفتح، نعيد العد التنازلي للـ Dwell */
            if (Copy_u8ObstructionDetected) {
                g_u16TimerTicks = 0;
            } else {
                g_u16TimerTicks++;
                /* بعد انقضاء زمن الـ Dwell Time يبدأ الباب بالإغلاق تلقائياً */
                if (g_u16TimerTicks >= DWELL_TIME_TICKS) {
                    g_eCurrentState = DOOR_CLOSING;
                    g_u16TimerTicks = 0;
                    Door_Close(); // أمر للهاردوير بالإغلاق
                }
            }
            break;

        case DOOR_CLOSING:
            /* ميزة الأمان Reversal: لو ظهر عائق أثناء الإغلاق يفتح الباب فوراً */
            if (Copy_u8ObstructionDetected) {
                g_eCurrentState = DOOR_OPENING;
                g_u16TimerTicks = 0;
                Door_Open(); // أمر للهاردوير بالفتح فوراً
            } else {
                g_u16TimerTicks++;
                if (g_u16TimerTicks >= MOVEMENT_TIME_TICKS) {
                    g_eCurrentState = DOOR_CLOSED;
                    g_u16TimerTicks = 0;
                }
            }
            break;

        default:
            g_eCurrentState = DOOR_CLOSED;
            break;
    }
}