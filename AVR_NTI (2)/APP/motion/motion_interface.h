#ifndef MOTION_INTERFACE_H
#define MOTION_INTERFACE_H

#include "STD_TYPES.h"

// تهيئة نظام الحركة ووحدة الـ PWM
void MOT_Init(void);

// إعطاء أمر بالذهاب إلى موضع محدد بالسنتيمتر (الطابق المستهدف)
STD_ReturnType MOT_GoTo(float target_cm);

// دالة دورية يتم استدعاؤها بانتظام لتنفيذ حسابات السرعة وحركة المحرك (Trapezoidal Profile)
void MOT_Step(void);

// إيقاف الحركة فوراً وإيقاف المحرك
void MOT_Stop(void);

#endif /* MOTION_INTERFACE_H */