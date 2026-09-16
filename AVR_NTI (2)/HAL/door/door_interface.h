#ifndef DOOR_CTRL_H_
#define DOOR_CTRL_H_

#include "STD_TYPES.h"

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

#endif