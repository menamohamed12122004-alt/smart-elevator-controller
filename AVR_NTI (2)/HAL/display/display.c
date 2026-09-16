#include "display_interface.h"
#include "74HC595_interface.h" // استدعاء درايفر الـ 595 السفلي

/* جدول تحويل الأرقام لـ 7-Segment */
static const uint8 SEG_LOOKUP_TABLE[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66,
    0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

void SEG_Show(uint8 floor, uint8 dir) {
    (void)dir;

    if (floor < 10) {
        uint8 pattern = SEG_LOOKUP_TABLE[floor];
        HC595_SendByte(pattern);
    }
}