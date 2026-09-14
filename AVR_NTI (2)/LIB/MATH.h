#ifndef MATH_H
#define MATH_H

#include "STD_TYPES.h"

#define SET_BIT(REG, BIT)    ((REG) |= (1u << (BIT)))
#define CLEAR_BIT(REG, BIT)  ((REG) &= ~(1u << (BIT)))
#define TOGGLE_BIT(REG, BIT) ((REG) ^= (1u << (BIT)))
<<<<<<< HEAD
#define GET_BIT(REG, BIT)    (((REG) >> (BIT)) & 1)
=======
#define GET_BIT(REG, BIT)    (((REG) >> (BIT)) & 1u)
>>>>>>> 0e6b039 (Update AVR project to use GCC 15.2.0 and optimize memory layout)

#endif /* MATH_H */