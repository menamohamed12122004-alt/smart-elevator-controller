#define FAULTLOG_H

#include "STD_TYPES.h"
#include "safety.h"

#define FAULT_LOG_SIZE    16

typedef struct {
    Safety_Fault_t faultCode;
    uint8 floor;
    uint8 doorState;
    uint32 timeStamp;
} FaultRecord_t;

/* ---------------- Function Prototypes ---------------- */

void FLG_Init(void);

/* Append a fault snapshot to the 16-entry Ring Buffer */
void FLG_Append(Safety_Fault_t Copy_eFault, uint8 Copy_u8Floor, uint8 Copy_u8DoorState, uint32 Copy_u32Time);

/* Dump all stored faults over UART (Building Console) */
void FLG_Dump(void);

#endif /* FAULTLOG_H */