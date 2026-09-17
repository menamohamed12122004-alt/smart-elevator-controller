#ifndef LOADCELL_H_
#define LOADCELL_H_

#include "STD_TYPES.h"

#define LOADCELL_ADC_CHANNEL        1u      /* PA1 / ADC1 */
#define LOADCELL_MAX_KG             1000u   /* Maximum readable load */
#define LOADCELL_OVERLOAD_LIMIT_KG  900u    /* Departure inhibited if load > 900kg */
#define LOADCELL_OVERLOAD_HYST_KG   850u    /* Overload clears if load < 850kg */

void LOADCELL_Init(void);

uint16 LOADCELL_ReadKg(void);

uint8 LOADCELL_IsOverloaded(void);

#endif /* LOADCELL_H_ */