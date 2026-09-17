#include "motion_interface.h"
#include "position_interface.h"
#include "pwm_interface.h"
#include "STD_TYPES.h"

// تعريف حالات الحركة (Motion States) بناءً على ملف الـ Trapezoidal Profile
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

// الثوابت الحركية وقنوات الـ PWM
#define MAX_SPEED_CM_PER_SEC    50.0f
#define ACCEL_RATE              10.0f // معدل التسارع
#define CREEP_SPEED_CM_PER_SEC  5.0f  // سرعة الزحف للوقوف بدقة
#define LEVELLING_THRESHOLD_CM  2.0f  // مسافة بدء التباطؤ والتسوية

// رقم القناة المخصصة للمحرك في وحدة الـ PWM
#define MOTOR_PWM_CHANNEL       0u    

void MOT_Init(void) {
    current_motion_state = MOT_IDLE;
    target_position_cm = 0.0f;
    current_target_speed = 0.0f;
    
    // تهيئة وحدة الـ PWM للمحرك
    PWM_Init();
}

STD_ReturnType MOT_GoTo(float target_cm) {
    target_position_cm = target_cm;
    current_motion_state = MOT_ACCELERATING;
    return E_OK;
}

void MOT_Step(void) {
    float current_cm = 0.0f;
    
    // الحصول على الموضع الحالي للمصعد من نظام الـ Position
    if (POS_GetCm(&current_cm) != E_OK) {
        return; 
    }

    float distance_to_target = target_position_cm - current_cm;
    
    if (distance_to_target < 0.0f) {
        distance_to_target = -distance_to_target; // القيمة المطلقة للمسافة
    }

    switch (current_motion_state) {
        case MOT_IDLE:
        case MOT_STOPPED:
            current_target_speed = 0.0f;
            break;

        case MOT_ACCELERATING:
            if (current_target_speed < MAX_SPEED_CM_PER_SEC) {
                current_target_speed += ACCEL_RATE;
            }
            
            if (distance_to_target <= (LEVELLING_THRESHOLD_CM * 3.0f)) {
                current_motion_state = MOT_DECELERATING;
            } else if (current_target_speed >= MAX_SPEED_CM_PER_SEC) {
                current_motion_state = MOT_CONSTANT_SPEED;
            }
            break;

        case MOT_CONSTANT_SPEED:
            if (distance_to_target <= (LEVELLING_THRESHOLD_CM * 3.0f)) {
                current_motion_state = MOT_DECELERATING;
            }
            break;

        case MOT_DECELERATING:
            if (current_target_speed > CREEP_SPEED_CM_PER_SEC) {
                current_target_speed -= ACCEL_RATE;
            }
            
            if (distance_to_target <= LEVELLING_THRESHOLD_CM) {
                current_motion_state = MOT_CREEPING_AND_LEVELLING;
            }
            break;

        case MOT_CREEPING_AND_LEVELLING:
            current_target_speed = CREEP_SPEED_CM_PER_SEC;

            // الوصول الفعلي للهدف (هامش خطأ أقل من 2 مم)
            if (distance_to_target <= 0.2f) {
                MOT_Stop();
            }
            break;
    }

    // تطبيق السرعة المحسوبة وحساب قيمة الـ Duty Cycle (من 0 إلى 255)
    if (current_motion_state == MOT_STOPPED || current_motion_state == MOT_IDLE) {
        PWM_SetDutyCycle(MOTOR_PWM_CHANNEL, 0);
    } else {
        uint8 duty_cycle = (uint8)((current_target_speed / MAX_SPEED_CM_PER_SEC) * 255.0f);
        PWM_SetDutyCycle(MOTOR_PWM_CHANNEL, duty_cycle);
    }
}

void MOT_Stop(void) {
    current_motion_state = MOT_STOPPED;
    current_target_speed = 0.0f;
    PWM_SetDutyCycle(MOTOR_PWM_CHANNEL, 0); // إيقاف إرسال الـ PWM للمحرك
}