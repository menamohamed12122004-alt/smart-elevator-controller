#include "STD_TYPES.h"
#include "faultlog.h"
#include "../../MCAL/UART/UART_interface.h"

static FaultRecord_t g_sFaultBuffer[FAULT_LOG_SIZE];
static uint8 g_u8Head = 0;
static uint8 g_u8Count = 0;

void FLG_Init(void) {
    uint8 i;
    g_u8Head = 0;
    g_u8Count = 0;
    for (i = 0; i < FAULT_LOG_SIZE; i++) {
        g_sFaultBuffer[i].faultCode = SAF_FAULT_NONE;
        g_sFaultBuffer[i].floor = 0;
        g_sFaultBuffer[i].doorState = 0;
        g_sFaultBuffer[i].timeStamp = 0;
    }
}

void FLG_Append(Safety_Fault_t Copy_eFault, uint8 Copy_u8Floor, uint8 Copy_u8DoorState, uint32 Copy_u32Time) {
    if (Copy_eFault == SAF_FAULT_NONE) return;

    /* Write record at current head index */
    g_sFaultBuffer[g_u8Head].faultCode = Copy_eFault;
    g_sFaultBuffer[g_u8Head].floor = Copy_u8Floor;
    g_sFaultBuffer[g_u8Head].doorState = Copy_u8DoorState;
    g_sFaultBuffer[g_u8Head].timeStamp = Copy_u32Time;

    /* Advance head circular index */
    g_u8Head = (g_u8Head + 1) % FAULT_LOG_SIZE;

    if (g_u8Count < FAULT_LOG_SIZE) {
        g_u8Count++;
    }
}

void FLG_Dump(void) {
    uint8 i;
    UART_SendString((const uint8 *)"\r\n--- FAULT LOG DUMP ---\r\n");
    
    for (i = 0; i < g_u8Count; i++) {
        UART_SendString((const uint8 *)"Fault Code: ");
        UART_SendByte((uint8)(g_sFaultBuffer[i].faultCode + '0'));
        UART_SendString((const uint8 *)" | Floor: ");
        UART_SendByte((uint8)(g_sFaultBuffer[i].floor + '0'));
        UART_SendString((const uint8 *)"\r\n");
    }
    
    UART_SendString((const uint8 *)"----------------------\r\n");
}