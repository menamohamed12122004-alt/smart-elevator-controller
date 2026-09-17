#include "STD_TYPES.h"
#include "door_interface.h"
#include "hoist_interface.h"
#include "elevator_app_interface.h"

typedef enum {
    ELEVATOR_IDLE = 0,
    ELEVATOR_MOVING,
    ELEVATOR_DOOR_OPENING,
    ELEVATOR_DOOR_CLOSING
} Elevator_State_t;

static Elevator_State_t g_ElevatorState = ELEVATOR_IDLE;

void Elevator_Init(void) {
    Door_Init();
    /* Motor_Init(); */
    g_ElevatorState = ELEVATOR_IDLE;
}

void Elevator_Run(void) {
    switch (g_ElevatorState) {
        case ELEVATOR_IDLE:
            /* Check if there is a floor request, then open door or move */
            break;

        case ELEVATOR_MOVING:
            /* Use Motor functions here, e.g., Motor_MoveUp(speed); */
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