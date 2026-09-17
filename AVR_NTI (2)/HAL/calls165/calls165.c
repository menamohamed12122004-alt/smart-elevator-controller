/*
 * calls165.c - HAL Layer for 16-Button Cabin and Floor Calls via 74HC165
 */

#include "STD_TYPES.h"
#include "HC165_interface.h"   /* استدعاء الـ driver الأساسي لإيمان */
#include "calls165_interface.h"

#define TOTAL_BUTTONS   16u

static uint16 g_u16CurrentButtonStates = 0;
static uint16 g_u16LastButtonStates = 0;

void BTN_Init(void) {
    /* استدعاء تهيئة الـ Hardware السفلي */
    HC165_Init();
    g_u16CurrentButtonStates = 0;
    g_u16LastButtonStates = 0;
}

void BTN_Scan(void) {
    uint16 Local_u16RawData = 0;
    
    /* حفظ القراءة السابقة للـ Debouncing */
    g_u16LastButtonStates = g_u16CurrentButtonStates;

    /* قراءة الـ 16 بت دفعة واحدة باستخدام دالة إيمان */
    if (HC165_Read16Bits(&Local_u16RawData) == E_OK) {
        g_u16CurrentButtonStates = Local_u16RawData;
    }
}

uint8 BTN_Pressed(uint8 Copy_u8ButtonId) {
    if (Copy_u8ButtonId >= TOTAL_BUTTONS) {
        return 0; /* رقم زر غير صالح */
    }

    /* فحص حالة البت الخاص بالزر المطلوب */
    if ((g_u16CurrentButtonStates & (1u << Copy_u8ButtonId)) != 0) {
        return 1; /* الزر مضغوط */
    }

    return 0; /* الزر غير مضغوط */
}