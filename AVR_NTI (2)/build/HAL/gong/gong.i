# 0 "HAL/gong/gong.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/gong/gong.c"
# 1 "HAL/gong/gong.h" 1





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
# 7 "HAL/gong/gong.h" 2
# 15 "HAL/gong/gong.h"
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
# 2 "HAL/gong/gong.c" 2
# 1 "MCAL/TIMER/TIMER_interface.h" 1
# 29 "MCAL/TIMER/TIMER_interface.h"
STD_ReturnType TIMER0_Init(void);




STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds);




STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds);







STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent);




STD_ReturnType TIMER0_Stop(void);






STD_ReturnType TIMER1_Init(void);




STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds);
# 73 "MCAL/TIMER/TIMER_interface.h"
STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent);




STD_ReturnType TIMER1_Stop(void);
# 3 "HAL/gong/gong.c" 2







static GongMode_t s_currentMode = GONG_MODE_OFF;
static uint16 s_timerTicks = 0u;
static uint8 s_sequenceStep = 0u;


void GONG_Init(void)
{
    s_currentMode = GONG_MODE_OFF;
    s_timerTicks = 0u;
    s_sequenceStep = 0u;
    TIMER1_Init();
    TIMER1_Stop();
}

void GONG_Play(GongMode_t mode)
{
    s_currentMode = mode;
    s_timerTicks = 0u;
    s_sequenceStep = 0u;

    switch (mode)
    {
        case GONG_MODE_ARRIVE_UP:

            TIMER1_PWM(1000u, 50u);
            s_timerTicks = (500u / 10u);
            break;

        case GONG_MODE_ARRIVE_DOWN:

            TIMER1_PWM(1000u, 50u);
            s_timerTicks = 25u;
            s_sequenceStep = 1u;
            break;

        case GONG_MODE_OVERLOAD_ALARM:

            TIMER1_PWM(2000u, 50u);
            s_timerTicks = 20u;
            s_sequenceStep = 1u;
            break;

        case GONG_MODE_FAULT_ALARM:

            TIMER1_PWM(2000u, 50u);
            s_timerTicks = 0u;
            break;

        case GONG_MODE_OFF:
        default:
            GONG_Stop();
            break;
    }
}

void GONG_Update(void)
{
    if (s_currentMode == GONG_MODE_OFF)
    {
        return;
    }


    if (s_timerTicks > 0u)
    {
        s_timerTicks--;
        if (s_timerTicks > 0u)
        {
            return;
        }
    }


    switch (s_currentMode)
    {
        case GONG_MODE_ARRIVE_UP:

            GONG_Stop();
            break;

        case GONG_MODE_ARRIVE_DOWN:
            if (s_sequenceStep == 1u)
            {

                TIMER1_Stop();
                s_timerTicks = 10u;
                s_sequenceStep = 2u;
            }
            else if (s_sequenceStep == 2u)
            {

                TIMER1_PWM(750u, 50u);
                s_timerTicks = 25u;
                s_sequenceStep = 3u;
            }
            else
            {

                GONG_Stop();
            }
            break;

        case GONG_MODE_OVERLOAD_ALARM:
            if (s_sequenceStep == 1u)
            {

                TIMER1_Stop();
                s_timerTicks = 20u;
                s_sequenceStep = 0u;
            }
            else
            {

                TIMER1_PWM(2000u, 50u);
                s_timerTicks = 20u;
                s_sequenceStep = 1u;
            }
            break;

        case GONG_MODE_FAULT_ALARM:

            break;

        default:
            GONG_Stop();
            break;
    }
}

void GONG_Stop(void)
{
    TIMER1_Stop();
    s_currentMode = GONG_MODE_OFF;
    s_timerTicks = 0u;
    s_sequenceStep = 0u;
}
