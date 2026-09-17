# 0 "APP/DOOR/door_fsm.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/DOOR/door_fsm.c"
# 9 "APP/DOOR/door_fsm.c"
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
# 10 "APP/DOOR/door_fsm.c" 2
# 1 "HAL/door/door_interface.h" 1





typedef enum {
    DOOR_CLOSED = 0,
    DOOR_OPENED,
    DOOR_OPENING,
    DOOR_CLOSING
} Door_State_t;

STD_ReturnType Door_Init(void);
STD_ReturnType Door_Open(void);
STD_ReturnType Door_Close(void);
void Door_CheckSafety(void);
Door_State_t Door_GetState(void);
# 11 "APP/DOOR/door_fsm.c" 2




void Door_FSM_Init(void);


void Door_FSM_Open(void);


void Door_FSM_Close(void);


void Door_Run(uint8 Copy_u8ObstructionDetected);


Door_State_t Door_FSM_GetState(void);
