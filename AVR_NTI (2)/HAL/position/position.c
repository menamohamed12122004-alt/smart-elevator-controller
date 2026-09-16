#include "position_interface.h"
#include "ADC_interface.h"

// إعدادات المعايرة والثوابت لنظام المصعد
#define ADC_MIN_VAL     0.0f
#define ADC_MAX_VAL     1023.0f  // أقصى قيمة لـ ADC بـ 10-bit في ATmega32
#define HEIGHT_MIN_CM   0.0f     // أدنى ارتفاع (الطابق الأول - الأرضي)
#define HEIGHT_MAX_CM   450.0f   // أقصى ارتفاع (الطابق الرابع)

// مصفوفة تحتوي على ارتفاعات الطوابق بالسنتيمتر
static const float floor_positions[] = {0.0f, 150.0f, 300.0f, 450.0f};
#define NUM_FLOORS (sizeof(floor_positions) / sizeof(floor_positions[0]))

void POS_Init(void) {
    // يمكن وضع أي إعدادات أولية لمتغيرات تتبع الموقع هنا
}

STD_ReturnType POS_GetCm(float *Copy_pfCurrentCm) {
    if (Copy_pfCurrentCm == NULL) {
        return E_NOK;
    }

    uint16 local_adc_raw = 0;
    
    // قراءة القيمة من القناة المخصصة لموضع عمود المصعد (ADC_CHANNEL_0) بشكل متزامن
    STD_ReturnType local_status = ADC_ReadChannel(ADC_CHANNEL_0, &local_adc_raw);

    if (local_status == E_OK) {
        // حماية ضد تجاوز الحدود
        if (local_adc_raw <= (uint16)ADC_MIN_VAL) {
            *Copy_pfCurrentCm = HEIGHT_MIN_CM;
        } else if (local_adc_raw >= (uint16)ADC_MAX_VAL) {
            *Copy_pfCurrentCm = HEIGHT_MAX_CM;
        } else {
            // تحويل خطي من قيم ADC (0..1023) إلى سنتيمترات (0..450 سم)
            *Copy_pfCurrentCm = ((float)local_adc_raw - ADC_MIN_VAL) / (ADC_MAX_VAL - ADC_MIN_VAL) 
                                * (HEIGHT_MAX_CM - HEIGHT_MIN_CM) + HEIGHT_MIN_CM;
        }
        return E_OK;
    }

    return E_NOK;
}

sint32 POS_GetNearestFloor(float current_cm) {
    sint32 nearest_floor = 0;
    float min_diff = 1000000.0f;

    for (sint32 i = 0; i < (sint32)NUM_FLOORS; i++) {
        float diff = current_cm - floor_positions[i];
        if (diff < 0.0f) {
            diff = -diff; // حساب القيمة المطلقة للفرق
        }

        if (diff < min_diff) {
            min_diff = diff;
            nearest_floor = i; // حفظ رقم الطابق الأقرب (من 0 إلى 3)
        }
    }

    return nearest_floor;
}