#ifndef CALLS165_H_
#define CALLS165_H_

#include "STD_TYPES.h"

/* تهيئة أزرار المصعد */
void BTN_Init(void);

/* مسح وقراءة جميع الـ 16 زر عبر الـ 74HC165 */
void BTN_Scan(void);

/* التحقق مما إذا كان الزر رقم n مضغوطاً أم لا */
uint8 BTN_Pressed(uint8 Copy_u8ButtonId);

#endif /* CALLS165_H_ */