/*
 * Communications Manager Implementation File (comm_mgr.c)
 * Handles real-time communication with Building Management Console via UART
 */

#include "STD_TYPES.h"
#include "comm_mgr.h"

/* استدعاء ملف الـ Interface الخاص بدرايفر الـ UART في MCAL */
#include "../../MCAL/UART/UART_interface.h"

void Comm_Init(void) {
    /* تهيئة الـ UART على Baud Rate 9600 */
    UART_Init(9600); 
}

/* دالة مساعدة لتحويل الأرقام إلى نصوص وإرسالها عبر الـ UART */
static void Comm_SendNum(uint16 Copy_u16Number) {
    char str[6];
    int i = 0; /* تم استخدام int القياسية لمنع أي خطأ في تعريفات Types */
    
    if (Copy_u16Number == 0) {
        UART_SendByte('0');
        return;
    }
    
    while (Copy_u16Number > 0) {
        str[i++] = (Copy_u16Number % 10) + '0';
        Copy_u16Number /= 10;
    }
    
    while (--i >= 0) {
        UART_SendByte((uint8)str[i]);
    }
}

void Comm_SendTelemetry(const TelemetryMsg_t *msg) {
    if (msg == NULL) return;

    /* صيغة التقرير المرسل لكونسول المبنى: [FLR:X|WGT:XXXX|DR:X|EMG:X]\r\n */
    UART_SendString((const uint8 *)"[FLR:");
    Comm_SendNum(msg->currentFloor);
    
    UART_SendString((const uint8 *)"|WGT:");
    Comm_SendNum(msg->passengerWeight);
    
    UART_SendString((const uint8 *)"|DR:");
    Comm_SendNum(msg->doorState);
    
    UART_SendString((const uint8 *)"|EMG:");
    Comm_SendNum(msg->emergencyState);
    
    UART_SendString((const uint8 *)"]\r\n");
}

Comm_Command_t Comm_ReceiveCommand(void) {
    uint8 u8ReceivedChar = 0;
    
    /* فحص هل توجد بيانات جاهزة للاستقبال دون تعطيل التنفيذ (Non-blocking check) */
    if (UART_IsDataReady() == E_OK) {
        if (UART_ReceiveByte(&u8ReceivedChar) == E_OK) {
            switch (u8ReceivedChar) {
                case 'S': return COMM_CMD_STOP;          /* أمر إيقاف الطوارئ */
                case 'O': return COMM_CMD_OVERRIDE_OPEN; /* أمر فتح الباب يدوياً */
                case 'R': return COMM_CMD_RESET;         /* أمر إعادة الضبط */
                default:  return COMM_CMD_NONE;
            }
        }
    }
    
    return COMM_CMD_NONE;
}