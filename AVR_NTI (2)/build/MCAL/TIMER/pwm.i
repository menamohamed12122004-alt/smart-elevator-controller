# 0 "MCAL/TIMER/pwm.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/TIMER/pwm.c"
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
# 2 "MCAL/TIMER/pwm.c" 2
# 1 "LIB/MATH.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/MATH.h" 2
# 3 "MCAL/TIMER/pwm.c" 2
# 1 "MCAL/TIMER/pwm_interface.h" 1





void PWM_Init(void);
void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle);
# 4 "MCAL/TIMER/pwm.c" 2
# 1 "C:/avr-gcc/avr/include/avr/io.h" 1 3
# 99 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 1 3
# 126 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 37 "C:/avr-gcc/avr/include/inttypes.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 38 "C:/avr-gcc/avr/include/inttypes.h" 2 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 127 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 2 3
# 100 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 230 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/iom32.h" 1 3
# 720 "C:/avr-gcc/avr/include/avr/iom32.h" 3
       
# 721 "C:/avr-gcc/avr/include/avr/iom32.h" 3

       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
# 231 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 785 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/portpins.h" 1 3
# 786 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/common.h" 1 3
# 788 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/version.h" 1 3
# 790 "C:/avr-gcc/avr/include/avr/io.h" 2 3






# 1 "C:/avr-gcc/avr/include/avr/fuse.h" 1 3
# 248 "C:/avr-gcc/avr/include/avr/fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
} __fuse_t;
# 797 "C:/avr-gcc/avr/include/avr/io.h" 2 3


# 1 "C:/avr-gcc/avr/include/avr/lock.h" 1 3
# 800 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 5 "MCAL/TIMER/pwm.c" 2


# 6 "MCAL/TIMER/pwm.c"
void PWM_Init(void)
{
    ((
# 8 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2F) + 0x20))
# 8 "MCAL/TIMER/pwm.c"
   ) |= (1u << (
# 8 "MCAL/TIMER/pwm.c" 3
   1
# 8 "MCAL/TIMER/pwm.c"
   )));
    ((
# 9 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2F) + 0x20))
# 9 "MCAL/TIMER/pwm.c"
   ) &= ~(1u << (
# 9 "MCAL/TIMER/pwm.c" 3
   0
# 9 "MCAL/TIMER/pwm.c"
   )));
    ((
# 10 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2E) + 0x20))
# 10 "MCAL/TIMER/pwm.c"
   ) |= (1u << (
# 10 "MCAL/TIMER/pwm.c" 3
   4
# 10 "MCAL/TIMER/pwm.c"
   )));
    ((
# 11 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2E) + 0x20))
# 11 "MCAL/TIMER/pwm.c"
   ) |= (1u << (
# 11 "MCAL/TIMER/pwm.c" 3
   3
# 11 "MCAL/TIMER/pwm.c"
   )));

    ((
# 13 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2F) + 0x20))
# 13 "MCAL/TIMER/pwm.c"
   ) &= ~(1u << (
# 13 "MCAL/TIMER/pwm.c" 3
   6
# 13 "MCAL/TIMER/pwm.c"
   )));
    ((
# 14 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2F) + 0x20))
# 14 "MCAL/TIMER/pwm.c"
   ) |= (1u << (
# 14 "MCAL/TIMER/pwm.c" 3
   7
# 14 "MCAL/TIMER/pwm.c"
   )));

    
# 16 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint16_t *)((0x26) + 0x20)) 
# 16 "MCAL/TIMER/pwm.c"
        = 799;

    ((
# 18 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2E) + 0x20))
# 18 "MCAL/TIMER/pwm.c"
   ) |= (1u << (
# 18 "MCAL/TIMER/pwm.c" 3
   0
# 18 "MCAL/TIMER/pwm.c"
   )));
    ((
# 19 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2E) + 0x20))
# 19 "MCAL/TIMER/pwm.c"
   ) &= ~(1u << (
# 19 "MCAL/TIMER/pwm.c" 3
   1
# 19 "MCAL/TIMER/pwm.c"
   )));
    ((
# 20 "MCAL/TIMER/pwm.c" 3
   (*(volatile uint8_t *)((0x2E) + 0x20))
# 20 "MCAL/TIMER/pwm.c"
   ) &= ~(1u << (
# 20 "MCAL/TIMER/pwm.c" 3
   2
# 20 "MCAL/TIMER/pwm.c"
   )));
}

void PWM_SetDutyCycle(uint8 Copy_u8Channel, uint8 Copy_u8DutyCycle)
{
    uint16 Local_u16CompareValue = (uint16)(((uint32)Copy_u8DutyCycle * 799) / 100);

    if (Copy_u8Channel == 0)
    {
        
# 29 "MCAL/TIMER/pwm.c" 3
       (*(volatile uint16_t *)((0x2A) + 0x20)) 
# 29 "MCAL/TIMER/pwm.c"
             = Local_u16CompareValue;
    }
}
