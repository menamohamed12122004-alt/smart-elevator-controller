#ifndef DISPATCH_H
#define DISPATCH_H

/*
 * Elevator Dispatcher & Scheduler Header File
 * Handles Queue management and Direction/Floor determination
 */

#include "STD_TYPES.h"

#define NUM_FLOORS           4    /* إجمالي عدد الأدوار بالمبنى (0 إلى 3) */
#define NO_REQ_FLOOR        255   /* قيمة تدل على عدم وجود طلبات معلقة */

typedef enum {
    DIR_STOPPED = 0,
    DIR_UP,
    DIR_DOWN
} Direction_t;

/* ---------------- Function Prototypes ---------------- */

/* تهيئة صف الطلبات (Queue) والاتجاه الابتدائي */
void Dispatch_Init(void);

/* إضافة أو تحديث طلب جديد في القائمة لتبية الأدوار */
void Dispatch_UpdateQueue(uint8 Copy_u8Floor, uint8 Copy_u8Requested);

/* تحديد وإرجاع رقم الدور التالي الذي يجب التوجه إليه بناءً على اتجاه الحركة الحالي */
uint8 Dispatch_GetNextFloor(uint8 Copy_u8CurrentFloor, Direction_t Copy_eCurrentDir);

/* دالة مساعدة لإلغاء طلب دور معين بعد الوصول إليه */
void Dispatch_ClearFloorRequest(uint8 Copy_u8Floor);

#endif /* DISPATCH_H */