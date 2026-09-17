
#ifndef GONG_H
#define GONG_H


#include "STD_TYPES.h"

#define GONG_TICK_MS       10u
#define GONG_TONE_TICKS    25u
#define GONG_PAUSE_TICKS   10u

#define GONG_TICK_PERIOD_MS  10u
#define GONG_TICKS_500MS     (500u / GONG_TICK_PERIOD_MS)

typedef enum
{
    GONG_DIR_UP = 0u,
    GONG_DIR_DOWN
} GongDirection_t;

typedef enum
{
    GONG_MODE_OFF = 0u,
    GONG_MODE_ARRIVE_UP,
    GONG_MODE_ARRIVE_DOWN,
    GONG_MODE_OVERLOAD_ALARM,
    GONG_MODE_FAULT_ALARM
} GongMode_t;

void Gong_Init(void);

STD_ReturnType Gong_PlayArrivalTone(GongDirection_t Copy_enDirection);

void Gong_PlayAlarm(void);
void Gong_StopAlarm(void);

void Gong_Run(void);
void GONG_Stop(void);

#endif 