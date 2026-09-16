#ifndef POSITION_H
#define POSITION_H

#include "STD_TYPES.h"

// تهيئة نظام تتبع الموقع
void POS_Init(void);

// قراءة الـ ADC من القناة المخصصة وتحويل القيمة الخام إلى سنتيمترات
// تأخذ مؤتمر لتخزين القراءة المرتجعة وتُرجع E_OK أو E_NOK
STD_ReturnType POS_GetCm(float *Copy_pfCurrentCm);

// تحديد أقرب طابق بناءً على الموضع الحالي بالسنتيمتر
sint32 POS_GetNearestFloor(float current_cm);

#endif // POSITION_H