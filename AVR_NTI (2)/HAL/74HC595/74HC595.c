#include <stdint.h>
#include "STD_TYPES.h"
#include "74HC595_interface.h"
#include <avr/io.h>
// استدعاء ملف الـ Interface الخاص بدرايفر الـ SPI (حسب التسمية عندك في المشروع)
#include "SPI_interface.h" 

// تعريفات الـ Ports والأطراف الخاصة بالاتش (لو مش معرفة في مكان عام)
#define HC595_PORT_REG    PORTC
#define HC595_DDR_REG     DDRC
#define HC595_PIN_NUM     3

// مصفوفة تحويل الأرقام (0 إلى 9) للـ 7-Segment (Common Cathode)
static const uint8_t SEGMENT_MAP[10] = {
    0b00111111, // 0
    0b00000110, // 1
    0b01011011, // 2
    0b01001111, // 3
    0b01100110, // 4
    0b01101101, // 5
    0b01111101, // 6
    0b00000111, // 7
    0b01111111, // 8
    0b01101111  // 9
};

STD_ReturnType HC595_Init(void) {
    // 1. ضبط طرف الـ Latch كـ Output (بناءً على جدول التوصيلات PC3)
    HC595_DDR_REG |= (1 << HC595_PIN_NUM);
    
    // 2. ضبط طرف الـ Latch على وضع High في البداية
    HC595_PORT_REG |= (1 << HC595_PIN_NUM);
    
    // 3. تهيئة وحدة الـ SPI من طبقة الـ MCAL
    // (تأكد من اسم دالة التهيئة عندك في الـ SPI driver، مثلاً SPI_voidInit)
    SPI_InitSlave(); 
    
    return E_OK;
}

STD_ReturnType HC595_SendByte(uint8_t Copy_u8Data) {
    // 1. خفض طرف الـ Latch لمنع اهتزاز الشاشة أثناء نقل البيانات الجديدة
    HC595_PORT_REG &= ~(1 << HC595_PIN_NUM);
    
    // 2. إرسال البايت عبر هاردوير الـ SPI بسرعة عالية
    SPI_Transceive(Copy_u8Data , 0);
    
    // 3. رفع طرف الـ Latch لنقل البيانات إلى الأطراف الخرجية دفعة واحدة
    HC595_PORT_REG |= (1 << HC595_PIN_NUM);
    
    return E_OK;
}

STD_ReturnType HC595_DisplayFloor(uint8_t Copy_u8FloorNum) {
    STD_ReturnType Local_u8Status = E_NOK;
    
    if (Copy_u8FloorNum <= 9) {
        // إرسال النمط الخاص بالرقم من جدول التحويل
        HC595_SendByte(SEGMENT_MAP[Copy_u8FloorNum]);
        Local_u8Status = E_OK;
    }
    
    return Local_u8Status;
}