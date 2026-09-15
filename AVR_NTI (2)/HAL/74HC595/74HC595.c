#include "STD_TYPES.h"
#include "GPIO_interface.h"
#include "SPI_interface.h"
#include "74HC595_interface.h"

/* مصفوفة تمثيل الأرقام 0-3 على الـ 7-Segment (Common Cathode) */
static const uint8 SEGMENT_MAP[] = {
    [0] = 0b00111111, /* رقم 0 */
    [1] = 0b00000110, /* رقم 1 */
    [2] = 0b01011011, /* رقم 2 */
    [3] = 0b01001111  /* رقم 3 */
};

STD_ReturnType HC595_Init(void) {
    /* 1. ضبط طرف الـ Latch (PC3) كمخرج وتثبيته على LOW */
    GPIO_SetPinDirection(HC595_LATCH_PORT, HC595_LATCH_PIN, GPIO_OUTPUT);
    GPIO_SetPinValue(HC595_LATCH_PORT, HC595_LATCH_PIN, GPIO_LOW);
    
    /* 2. ضبط أطراف أسهم الاتجاهات (PC4 / PC5) كمخرجات */
    GPIO_SetPinDirection(HC595_LATCH_PORT, HC595_DIR_UP_PIN, GPIO_OUTPUT);
    GPIO_SetPinDirection(HC595_LATCH_PORT, HC595_DIR_DN_PIN, GPIO_OUTPUT);
    GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_UP_PIN, GPIO_LOW);
    GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_DN_PIN, GPIO_LOW);

    /* 3. تهيئة وحدة الـ SPI كـ Master */
    SPI_InitMaster(SPI_PRESC_16);
    
    return E_OK;
}

STD_ReturnType HC595_SendByte(uint8 Copy_u8Data) {
    uint8 Local_u8Received = 0;

    /* 1. إرسال البايت عبر الـ SPI */
    SPI_Transceive(Copy_u8Data, &Local_u8Received);
    
    /* 2. عمل نبضة Latch (Rising Edge) لنقل البيانات للمخرجات */
    GPIO_SetPinValue(HC595_LATCH_PORT, HC595_LATCH_PIN, GPIO_HIGH);
    GPIO_SetPinValue(HC595_LATCH_PORT, HC595_LATCH_PIN, GPIO_LOW);
    
    return E_OK;
}

STD_ReturnType HC595_DisplayFloor(uint8 Copy_u8FloorNum, HC595_Direction_t Copy_tDirection) {
    if (Copy_u8FloorNum > 3) return E_NOK;

    /* إرسال رسمة الرقم */
    HC595_SendByte(SEGMENT_MAP[Copy_u8FloorNum]);

    /* تحديث إضاءة أسهم الاتجاهات */
    if (Copy_tDirection == HC595_DIR_UP) {
        GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_UP_PIN, GPIO_HIGH);
        GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_DN_PIN, GPIO_LOW);
    } 
    else if (Copy_tDirection == HC595_DIR_DOWN) {
        GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_UP_PIN, GPIO_LOW);
        GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_DN_PIN, GPIO_HIGH);
    } 
    else {
        GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_UP_PIN, GPIO_LOW);
        GPIO_SetPinValue(HC595_LATCH_PORT, HC595_DIR_DN_PIN, GPIO_LOW);
    }

    return E_OK;
}

STD_ReturnType HC595_DisplaySpecial(char Copy_cSymbol) {
    uint8 Local_u8Pattern = 0x00;

    if (Copy_cSymbol == 'E')      Local_u8Pattern = 0b01111001; /* حرف E للأعطال */
    else if (Copy_cSymbol == 'F') Local_u8Pattern = 0b01110001; /* حرف F للحريق */
    else return E_NOK;

    return HC595_SendByte(Local_u8Pattern);
}