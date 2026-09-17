#ifndef COMM_MGR_H
#define COMM_MGR_H

/*
 * Communications Manager Header File (comm_mgr.h)
 * Real-time Communication with Building Management Console via USART
 */

#include "STD_TYPES.h"

/* ---------------- Command Definitions from Console ---------------- */
typedef enum {
    COMM_CMD_NONE = 0,
    COMM_CMD_STOP,          /* Emergency Stop from Building Console */
    COMM_CMD_OVERRIDE_OPEN, /* Manual Door Open Override */
    COMM_CMD_RESET          /* System Reset Command */
} Comm_Command_t;

/* ---------------- Telemetry Data Structure ---------------- */
typedef struct {
    uint8 currentFloor;     /* Shaft Floor Position (0..3) */
    uint16 passengerWeight; /* Weight read from Load Cell (ADC) */
    uint8 doorState;        /* 0: Closed, 1: Opening, 2: Open, 3: Closing */
    uint8 emergencyState;   /* 0: Normal, 1: Emergency Triggered */
} TelemetryMsg_t;

/* ---------------- Function Prototypes ---------------- */

/* Initializes USART for 9600 Baud Rate */
void Comm_Init(void);

/* Format and Send Telemetry Data Report to Building Console */
void Comm_SendTelemetry(const TelemetryMsg_t *msg);

/* Non-blocking Receive Command from Building Console */
Comm_Command_t Comm_ReceiveCommand(void);

#endif /* COMM_MGR_H */