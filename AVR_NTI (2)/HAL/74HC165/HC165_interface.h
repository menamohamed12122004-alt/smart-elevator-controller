#ifndef HC165_INTERFACE_H_
#define HC165_INTERFACE_H_

#include "STD_TYPES.h"

#define HC165_NUM_CHIPS      2u  
#define HC165_SHLD_PORT       GPIO_PORTB
#define HC165_SHLD_PIN        4u

/* ---------------- Button bit map ------ */
#define BTN_CAR_CALL_G        0u
#define BTN_CAR_CALL_1        1u
#define BTN_CAR_CALL_2        2u
#define BTN_CAR_CALL_3        3u
#define BTN_DOOR_OPEN         4u
#define BTN_DOOR_CLOSE        5u
#define BTN_EMERGENCY_ALARM   6u
#define BTN_INDEPENDENT_SVC   7u
#define BTN_HALL_UP_G         8u
#define BTN_HALL_UP_1         9u
#define BTN_HALL_DOWN_1      10u
#define BTN_HALL_UP_2        11u
#define BTN_HALL_DOWN_2      12u
#define BTN_HALL_DOWN_3      13u
#define BTN_SPARE_14         14u
#define BTN_SPARE_15         15u
#define BTN_COUNT            16u

void  BTN_Init(void);
 
/* One 16-bit acquisition + debounce + edge detection. Call every 50 ms.
 * Returns E_OK on a completed read, E_NOK if the bus was busy (the cycle is
 * skipped, never blocked - README 9.3 rule 4).                             */
uint8 BTN_Scan(void);
 
/* Debounced steady state of one input: 1 = pressed, 0 = released.          */
uint8 BTN_Pressed(uint8 Copy_u8Button);
 
/* One-shot press event, consumed by this call. A held button reports a
 * single edge, so a call is never re-registered (FR-01, TC-14).            */
uint8 BTN_PressedEdge(uint8 Copy_u8Button);
 
/* Release edge, consumed by this call.                                     */
uint8 BTN_ReleasedEdge(uint8 Copy_u8Button);
 
/* All sixteen debounced states as one word, bit n = button n pressed.      */
uint16 BTN_GetAll(void);
 
/* Last raw word, normalised but not debounced. For TC-08 / TC-09 evidence. */
uint16 BTN_GetRaw(void);
 
/* Drop every pending edge without acting on it (E-stop, fire service).     */
void  BTN_ClearEdges(void);







#endif 