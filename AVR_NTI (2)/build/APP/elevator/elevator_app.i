# 0 "APP/elevator/elevator_app.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/elevator/elevator_app.c"
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
# 2 "APP/elevator/elevator_app.c" 2
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
# 3 "APP/elevator/elevator_app.c" 2
# 1 "HAL/hoist/hoist_interface.h" 1





void Motor_Init(void);
void Motor_MoveUp(void);
void Motor_MoveDown(void);
void Motor_Stop(void);
void Motor_SetSpeed(uint8 Copy_u8Speed);
# 4 "APP/elevator/elevator_app.c" 2
# 1 "APP/elevator/elevator_app_interface.h" 1





void Elevator_Init(void);
void Elevator_Run(void);
# 5 "APP/elevator/elevator_app.c" 2

typedef enum {
    ELEVATOR_IDLE = 0,
    ELEVATOR_MOVING,
    ELEVATOR_DOOR_OPENING,
    ELEVATOR_DOOR_CLOSING
} Elevator_State_t;

static Elevator_State_t g_ElevatorState = ELEVATOR_IDLE;

void Elevator_Init(void) {
    Door_Init();

    g_ElevatorState = ELEVATOR_IDLE;
}

void Elevator_Run(void) {
    switch (g_ElevatorState) {
        case ELEVATOR_IDLE:

            break;

        case ELEVATOR_MOVING:

            break;

        case ELEVATOR_DOOR_OPENING:
            Door_Open();
            g_ElevatorState = ELEVATOR_IDLE;
            break;

        case ELEVATOR_DOOR_CLOSING:
            Door_Close();
            g_ElevatorState = ELEVATOR_MOVING;
            break;

        default:
            g_ElevatorState = ELEVATOR_IDLE;
            break;
    }
}
