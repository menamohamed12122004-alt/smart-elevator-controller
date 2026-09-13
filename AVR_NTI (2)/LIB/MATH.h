#ifndef MATH_H
#define MATH_H

#include "STD_TYPES.h"

#define SET_BIT(REG, BIT)    ((REG) |= (1u << (BIT)))
#define CLEAR_BIT(REG, BIT)  ((REG) &= ~(1u << (BIT)))
#define TOGGLE_BIT(REG, BIT) ((REG) ^= (1u << (BIT)))

#endif /* MATH_H */