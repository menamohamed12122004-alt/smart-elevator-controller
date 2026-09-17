# 0 "APP/FAULTLOG/faultlog.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/FAULTLOG/faultlog.c"
# 1 "LIB/STD_TYPES.h" 1
# 13 "LIB/STD_TYPES.h"
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;
typedef signed char sint8;
typedef signed short sint16;
typedef signed long sint32;

typedef unsigned char uint8_h;

typedef enum
{
    E_OK = 0,
    E_NOK = 1,
    E_PORT_Not_valid = 2,
    E_PIN_Not_valid = 3,
} STD_ReturnType;
# 2 "APP/FAULTLOG/faultlog.c" 2
# 1 "APP/FAULTLOG/faultlog.h" 1




# 1 "APP/SAFETY/safety.h" 1






typedef enum {
    SAF_FAULT_NONE = 0,
    SAF_FAULT_ESTOP,
    SAF_FAULT_OVERTRAVEL,
    SAF_FAULT_FIRE,
    SAF_FAULT_OVERLOAD,
    SAF_FAULT_DOOR_STUCK,
    SAF_FAULT_SENSOR_ERR,
    SAF_FAULT_COMM_TIMEOUT
} Safety_Fault_t;



void SAF_Init(void);


Safety_Fault_t SAF_Evaluate(uint8 Copy_u8EStopPin,
                            uint8 Copy_u8OvertravelPin,
                            uint8 Copy_u8FireAlarm,
                            uint16 Copy_u16WeightGrams,
                            uint8 Copy_u8DoorFault);


uint8 SAF_IsActive(void);


Safety_Fault_t SAF_GetActiveFault(void);
# 6 "APP/FAULTLOG/faultlog.h" 2



typedef struct {
    Safety_Fault_t faultCode;
    uint8 floor;
    uint8 doorState;
    uint32 timeStamp;
} FaultRecord_t;

void FLG_Init(void);

void FLG_Append(
    Safety_Fault_t Copy_eFault,
    uint8 Copy_u8Floor,
    uint8 Copy_u8DoorState, uint32 Copy_u32Time
);

void FLG_Dump(void);
# 3 "APP/FAULTLOG/faultlog.c" 2
# 1 "APP/FAULTLOG/../../MCAL/UART/UART_interface.h" 1
# 20 "APP/FAULTLOG/../../MCAL/UART/UART_interface.h"
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate);




STD_ReturnType UART_SendByte(uint8 Copy_u8Data);




STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data);




STD_ReturnType UART_SendString(const uint8 *Copy_pu8String);





STD_ReturnType UART_IsDataReady(void);





STD_ReturnType UART_SetRxInterrupt(uint8 Copy_u8State);
STD_ReturnType UART_SetTxInterrupt(uint8 Copy_u8State);
# 4 "APP/FAULTLOG/faultlog.c" 2

static FaultRecord_t g_sFaultBuffer[16];
static uint8 g_u8Head = 0;
static uint8 g_u8Count = 0;

void FLG_Init(void) {
    uint8 i;
    g_u8Head = 0;
    g_u8Count = 0;
    for (i = 0; i < 16; i++) {
        g_sFaultBuffer[i].faultCode = SAF_FAULT_NONE;
        g_sFaultBuffer[i].floor = 0;
        g_sFaultBuffer[i].doorState = 0;
        g_sFaultBuffer[i].timeStamp = 0;
    }
}

void FLG_Append(Safety_Fault_t Copy_eFault, uint8 Copy_u8Floor, uint8 Copy_u8DoorState, uint32 Copy_u32Time) {
    if (Copy_eFault == SAF_FAULT_NONE) return;


    g_sFaultBuffer[g_u8Head].faultCode = Copy_eFault;
    g_sFaultBuffer[g_u8Head].floor = Copy_u8Floor;
    g_sFaultBuffer[g_u8Head].doorState = Copy_u8DoorState;
    g_sFaultBuffer[g_u8Head].timeStamp = Copy_u32Time;


    g_u8Head = (g_u8Head + 1) % 16;

    if (g_u8Count < 16) {
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
