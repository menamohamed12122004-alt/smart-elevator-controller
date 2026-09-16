# 0 "APP/COMM/comm_mgr.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/COMM/comm_mgr.c"





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
# 7 "APP/COMM/comm_mgr.c" 2
# 1 "APP/COMM/comm_mgr.h" 1
# 12 "APP/COMM/comm_mgr.h"
typedef enum {
    COMM_CMD_NONE = 0,
    COMM_CMD_STOP,
    COMM_CMD_OVERRIDE_OPEN,
    COMM_CMD_RESET
} Comm_Command_t;


typedef struct {
    uint8 currentFloor;
    uint16 passengerWeight;
    uint8 doorState;
    uint8 emergencyState;
} TelemetryMsg_t;




void Comm_Init(void);


void Comm_SendTelemetry(const TelemetryMsg_t *msg);


Comm_Command_t Comm_ReceiveCommand(void);
# 8 "APP/COMM/comm_mgr.c" 2


# 1 "APP/COMM/../../MCAL/UART/UART_interface.h" 1
# 20 "APP/COMM/../../MCAL/UART/UART_interface.h"
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate);




STD_ReturnType UART_SendByte(uint8 Copy_u8Data);




STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data);




STD_ReturnType UART_SendString(const uint8 *Copy_pu8String);





STD_ReturnType UART_IsDataReady(void);





STD_ReturnType UART_SetRxInterrupt(uint8 Copy_u8State);
STD_ReturnType UART_SetTxInterrupt(uint8 Copy_u8State);
# 11 "APP/COMM/comm_mgr.c" 2

void Comm_Init(void) {

    UART_Init(9600);
}


static void Comm_SendNum(uint16 Copy_u16Number) {
    char str[6];
    int i = 0;

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
    if (msg == ((void *)0)) return;


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


    if (UART_IsDataReady() == E_OK) {
        if (UART_ReceiveByte(&u8ReceivedChar) == E_OK) {
            switch (u8ReceivedChar) {
                case 'S': return COMM_CMD_STOP;
                case 'O': return COMM_CMD_OVERRIDE_OPEN;
                case 'R': return COMM_CMD_RESET;
                default: return COMM_CMD_NONE;
            }
        }
    }

    return COMM_CMD_NONE;
}
