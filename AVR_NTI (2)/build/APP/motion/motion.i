# 0 "APP/motion/motion.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/motion/motion.c"
# 1 "APP/motion/motion_interface.h" 1



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
# 5 "APP/motion/motion_interface.h" 2


void MOT_Init(void);


STD_ReturnType MOT_GoTo(float target_cm);


void MOT_Step(void);


void MOT_Stop(void);
# 2 "APP/motion/motion.c" 2
# 1 "HAL/position/position_interface.h" 1






void POS_Init(void);



STD_ReturnType POS_GetCm(float *Copy_pfCurrentCm);


sint32 POS_GetNearestFloor(float current_cm);
# 3 "APP/motion/motion.c" 2
# 1 "MCAL/TIMER/pwm_interface.h" 1





void PWM_Init(void);
void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle);
# 4 "APP/motion/motion.c" 2



typedef enum {
    MOT_IDLE = 0,
    MOT_ACCELERATING,
    MOT_CONSTANT_SPEED,
    MOT_DECELERATING,
    MOT_CREEPING_AND_LEVELLING,
    MOT_STOPPED
} MotionState_t;

static MotionState_t current_motion_state = MOT_IDLE;
static float target_position_cm = 0.0f;
static float current_target_speed = 0.0f;
# 29 "APP/motion/motion.c"
void MOT_Init(void) {
    current_motion_state = MOT_IDLE;
    target_position_cm = 0.0f;
    current_target_speed = 0.0f;


    PWM_Init();
}

STD_ReturnType MOT_GoTo(float target_cm) {
    target_position_cm = target_cm;
    current_motion_state = MOT_ACCELERATING;
    return E_OK;
}

void MOT_Step(void) {
    float current_cm = 0.0f;


    if (POS_GetCm(&current_cm) != E_OK) {
        return;
    }

    float distance_to_target = target_position_cm - current_cm;

    if (distance_to_target < 0.0f) {
        distance_to_target = -distance_to_target;
    }

    switch (current_motion_state) {
        case MOT_IDLE:
        case MOT_STOPPED:
            current_target_speed = 0.0f;
            break;

        case MOT_ACCELERATING:
            if (current_target_speed < 50.0f) {
                current_target_speed += 10.0f;
            }

            if (distance_to_target <= (2.0f * 3.0f)) {
                current_motion_state = MOT_DECELERATING;
            } else if (current_target_speed >= 50.0f) {
                current_motion_state = MOT_CONSTANT_SPEED;
            }
            break;

        case MOT_CONSTANT_SPEED:
            if (distance_to_target <= (2.0f * 3.0f)) {
                current_motion_state = MOT_DECELERATING;
            }
            break;

        case MOT_DECELERATING:
            if (current_target_speed > 5.0f) {
                current_target_speed -= 10.0f;
            }

            if (distance_to_target <= 2.0f) {
                current_motion_state = MOT_CREEPING_AND_LEVELLING;
            }
            break;

        case MOT_CREEPING_AND_LEVELLING:
            current_target_speed = 5.0f;


            if (distance_to_target <= 0.2f) {
                MOT_Stop();
            }
            break;
    }


    if (current_motion_state == MOT_STOPPED || current_motion_state == MOT_IDLE) {
        PWM_SetDutyCycle(0u, 0);
    } else {
        uint8 duty_cycle = (uint8)((current_target_speed / 50.0f) * 255.0f);
        PWM_SetDutyCycle(0u, duty_cycle);
    }
}

void MOT_Stop(void) {
    current_motion_state = MOT_STOPPED;
    current_target_speed = 0.0f;
    PWM_SetDutyCycle(0u, 0);
}
