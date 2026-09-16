# 0 "APP/DISPATCH/dispatch.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/DISPATCH/dispatch.c"





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
# 7 "APP/DISPATCH/dispatch.c" 2
# 1 "APP/DISPATCH/dispatch.h" 1
# 14 "APP/DISPATCH/dispatch.h"
typedef enum {
    DIR_STOPPED = 0,
    DIR_UP,
    DIR_DOWN
} Direction_t;




void Dispatch_Init(void);


void Dispatch_UpdateQueue(uint8 Copy_u8Floor, uint8 Copy_u8Requested);


uint8 Dispatch_GetNextFloor(uint8 Copy_u8CurrentFloor, Direction_t Copy_eCurrentDir);


void Dispatch_ClearFloorRequest(uint8 Copy_u8Floor);
# 8 "APP/DISPATCH/dispatch.c" 2


static uint8 g_u8FloorRequests[4] = {0};

void Dispatch_Init(void) {
    uint8 i;
    for (i = 0; i < 4; i++) {
        g_u8FloorRequests[i] = 0;
    }
}

void Dispatch_UpdateQueue(uint8 Copy_u8Floor, uint8 Copy_u8Requested) {
    if (Copy_u8Floor < 4) {
        g_u8FloorRequests[Copy_u8Floor] = Copy_u8Requested;
    }
}

void Dispatch_ClearFloorRequest(uint8 Copy_u8Floor) {
    if (Copy_u8Floor < 4) {
        g_u8FloorRequests[Copy_u8Floor] = 0;
    }
}

uint8 Dispatch_GetNextFloor(uint8 Copy_u8CurrentFloor, Direction_t Copy_eCurrentDir) {
    int i;


    if (Copy_eCurrentDir == DIR_UP) {
        for (i = Copy_u8CurrentFloor + 1; i < 4; i++) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }

        for (i = Copy_u8CurrentFloor - 1; i >= 0; i--) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
    }

    else if (Copy_eCurrentDir == DIR_DOWN) {
        for (i = Copy_u8CurrentFloor - 1; i >= 0; i--) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }

        for (i = Copy_u8CurrentFloor + 1; i < 4; i++) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
    }

    else {

        if (g_u8FloorRequests[Copy_u8CurrentFloor] == 1) {
            return Copy_u8CurrentFloor;
        }

        for (i = 0; i < 4; i++) {
            if (g_u8FloorRequests[i] == 1) {
                return (uint8)i;
            }
        }
    }


    return 255;
}
