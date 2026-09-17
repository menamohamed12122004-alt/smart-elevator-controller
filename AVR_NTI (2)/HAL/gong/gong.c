#include "gong.h"
#include "TIMER_interface.h"
#include "STD_TYPES.h"

#define FREQ_GONG_HIGH    1000u  /* High pitch tone for Up arrival / Gong 1 */
#define FREQ_GONG_LOW     750u   /* Low pitch tone for Down arrival / Gong 2 */
#define FREQ_ALARM        2000u  /* High frequency for Overload/Fault alarm */


static GongMode_t s_currentMode = GONG_MODE_OFF;
static uint16     s_timerTicks   = 0u;
static uint8    s_sequenceStep = 0u;


void GONG_Init(void)
{
    s_currentMode  = GONG_MODE_OFF;
    s_timerTicks   = 0u;
    s_sequenceStep = 0u;
    TIMER1_Init();
    TIMER1_Stop();
}

void GONG_Play(GongMode_t mode)
{
    s_currentMode  = mode;
    s_timerTicks   = 0u;
    s_sequenceStep = 0u;

    switch (mode)
    {
        case GONG_MODE_ARRIVE_UP:
            /* Single 500 ms tone at high frequency */
            TIMER1_PWM(FREQ_GONG_HIGH, 50u);
            s_timerTicks = GONG_TICKS_500MS;
            break;

        case GONG_MODE_ARRIVE_DOWN:
            /* First tone of the two-tone arrival sequence */
            TIMER1_PWM(FREQ_GONG_HIGH, 50u);
            s_timerTicks = 25u; /* 250 ms for 1st tone */
            s_sequenceStep = 1u;
            break;

        case GONG_MODE_OVERLOAD_ALARM:
            /* Intermittent pulse start */
            TIMER1_PWM(FREQ_ALARM, 50u);
            s_timerTicks = 20u; /* 200 ms ON */
            s_sequenceStep = 1u;
            break;

        case GONG_MODE_FAULT_ALARM:
            /* Continuous high-pitch tone */
            TIMER1_PWM(FREQ_ALARM, 50u);
            s_timerTicks = 0u; /* Runs until stopped */
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

    /* Decrement timer if active */
    if (s_timerTicks > 0u)
    {
        s_timerTicks--;
        if (s_timerTicks > 0u)
        {
            return; /* Still playing current step */
        }
    }

    /* Handle state transitions when timer reaches 0 */
    switch (s_currentMode)
    {
        case GONG_MODE_ARRIVE_UP:
            /* 500 ms finished -> stop gong */
            GONG_Stop();
            break;

        case GONG_MODE_ARRIVE_DOWN:
            if (s_sequenceStep == 1u)
            {
                /* Pause between 1st and 2nd tone */
                TIMER1_Stop();
                s_timerTicks = 10u; /* 100 ms silence */
                s_sequenceStep = 2u;
            }
            else if (s_sequenceStep == 2u)
            {
                /* Play 2nd tone (Lower frequency) */
                TIMER1_PWM(FREQ_GONG_LOW, 50u);
                s_timerTicks = 25u; /* 250 ms */
                s_sequenceStep = 3u;
            }
            else
            {
                /* Sequence finished */
                GONG_Stop();
            }
            break;

        case GONG_MODE_OVERLOAD_ALARM:
            if (s_sequenceStep == 1u)
            {
                /* Pause in intermittent beep */
                TIMER1_Stop();
                s_timerTicks = 20u; /* 200 ms OFF */
                s_sequenceStep = 0u;
            }
            else
            {
                /* Beep ON */
                TIMER1_PWM(FREQ_ALARM, 50u);
                s_timerTicks = 20u; /* 200 ms ON */
                s_sequenceStep = 1u;
            }
            break;

        case GONG_MODE_FAULT_ALARM:
            /* Continuous alarm stays ON until explicit GONG_Stop() */
            break;

        default:
            GONG_Stop();
            break;
    }
}

void GONG_Stop(void)
{
    TIMER1_Stop();
    s_currentMode  = GONG_MODE_OFF;
    s_timerTicks   = 0u;
    s_sequenceStep = 0u;
}