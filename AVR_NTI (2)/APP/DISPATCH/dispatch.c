/*
 * Elevator Dispatcher Implementation File
 * Look Algorithm (SCAN-based) for Efficient Passenger Routing
 */

#include "STD_TYPES.h"
#include "dispatch.h"

/* مصفوفة تمثل الأدوار المطلوب الذهاب إليها (1 = مطلوب، 0 = غير مطلوب) */
static uint8 g_u8FloorRequests[NUM_FLOORS] = {0};

void Dispatch_Init(void) {
    uint8 i;
    for (i = 0; i < NUM_FLOORS; i++) {
        g_u8FloorRequests[i] = 0;
    }
}

void Dispatch_UpdateQueue(uint8 Copy_u8Floor, uint8 Copy_u8Requested) {
    if (Copy_u8Floor < NUM_FLOORS) {
        g_u8FloorRequests[Copy_u8Floor] = Copy_u8Requested;
    }
}

void Dispatch_ClearFloorRequest(uint8 Copy_u8Floor) {
    if (Copy_u8Floor < NUM_FLOORS) {
        g_u8FloorRequests[Copy_u8Floor] = 0;
    }
}

uint8 Dispatch_GetNextFloor(uint8 Copy_u8CurrentFloor, Direction_t Copy_eCurrentDir) {
    int i;

    /* 1. إذا كان المصعد متحركاً لأعلى: ابحث عن أقرب دور مطلوب في الاتجاه الصاعد */
    if (Copy_eCurrentDir == DIR_UP) {
        for (i = Copy_u8CurrentFloor + 1; i < NUM_FLOORS; i++) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
        /* إذا لم نجد طلبات أعلاه، نفحص الطلبات في الاتجاه النازل */
        for (i = Copy_u8CurrentFloor - 1; i >= 0; i--) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
    } 
    /* 2. إذا كان المصعد متحركاً لأسفل: ابحث عن أقرب دور مطلوب في الاتجاه الهابط */
    else if (Copy_eCurrentDir == DIR_DOWN) {
        for (i = Copy_u8CurrentFloor - 1; i >= 0; i--) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
        /* إذا لم نجد طلبات أسفله، نفحص الطلبات في الاتجاه الصاعد */
        for (i = Copy_u8CurrentFloor + 1; i < NUM_FLOORS; i++) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
    } 
    /* 3. إذا كان المصعد متوقفاً: ابحث عن أي دور به طلب معلق */
    else {
        /* فحص الدور الحالي أولاً */
        if (g_u8FloorRequests[Copy_u8CurrentFloor] == 1) {
            return Copy_u8CurrentFloor;
        }
        /* فحص بقية الأدوار */
        for (i = 0; i < NUM_FLOORS; i++) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
    }

    /* لا توجد أي طلبات معلقة حالياً */
    return NO_REQ_FLOOR;
}