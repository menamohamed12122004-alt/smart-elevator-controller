#ifndef RING_BUFFER_H
#define RING_BUFFER_H

#include "STD_TYPES.h"

typedef struct
{
    uint8 *pu8Data;
    uint8 u8Capacity;
    uint8 u8Head;
    uint8 u8Tail;
    uint8 u8Count;
} RingBuffer_t;


void Buffer_Init(RingBuffer_t *psBuffer, uint8 *pu8Data, uint8 u8Capacity);
STD_ReturnType Buffer_Enqueue(RingBuffer_t *psBuffer, uint8 u8Data);
STD_ReturnType Buffer_Dequeue(RingBuffer_t *psBuffer, uint8 *pu8Data);
uint8 Buffer_IsEmpty(const RingBuffer_t *psBuffer);
uint8 Buffer_IsFull(const RingBuffer_t *psBuffer);
uint8 Buffer_GetCount(const RingBuffer_t *psBuffer);


void RingBuffer_Init(RingBuffer_t *psBuffer, uint8 *pu8Data, uint8 u8Capacity);
STD_ReturnType RingBuffer_Enqueue(RingBuffer_t *psBuffer, uint8 u8Data);
STD_ReturnType RingBuffer_Dequeue(RingBuffer_t *psBuffer, uint8 *pu8Data);

#endif 
