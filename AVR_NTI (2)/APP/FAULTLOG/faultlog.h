#ifndef FAULTLOG_H
#define FAULTLOG_H

#include "STD_TYPES.h"
#include "safety.h"

#define FAULT_LOG_SIZE 16

typedef struct {
    Safety_Fault_t faultCode;
    uint8 floor;
    uint8 doorState;
    uint32 timeStamp;
} FaultRecord_t;

void FLG_Init(void);

void FLG_Append(
    Safety_Fault_t Copy_eFault,
    uint8 Copy_u8Floor,
    uint8 Copy_u8DoorState,   uint32 Copy_u32Time
);

void FLG_Dump(void);

#endif /* FAULTLOG_H */