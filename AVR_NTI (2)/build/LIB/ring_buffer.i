# 0 "LIB/ring_buffer.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "LIB/ring_buffer.c"
# 1 "LIB/ring_buffer.h" 1



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
# 5 "LIB/ring_buffer.h" 2

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
# 2 "LIB/ring_buffer.c" 2


void Buffer_Init(RingBuffer_t *psBuffer, uint8 *pu8Data, uint8 u8Capacity)
{
    if (psBuffer != ((void *)0))
    {
        psBuffer->pu8Data = pu8Data;
        psBuffer->u8Capacity = u8Capacity;
        psBuffer->u8Head = 0u;
        psBuffer->u8Tail = 0u;
        psBuffer->u8Count = 0u;
    }
}

void RingBuffer_Init(RingBuffer_t *psBuffer, uint8 *pu8Data, uint8 u8Capacity)
{
    Buffer_Init(psBuffer, pu8Data, u8Capacity);
}

uint8 Buffer_IsEmpty(const RingBuffer_t *psBuffer)
{
    if (psBuffer == ((void *)0))
    {
        return 1u;
    }

    return (uint8)(psBuffer->u8Count == 0u);
}

uint8 Buffer_IsFull(const RingBuffer_t *psBuffer)
{
    if (psBuffer == ((void *)0))
    {
        return 1u;
    }

    return (uint8)(psBuffer->u8Count >= psBuffer->u8Capacity);
}

uint8 Buffer_GetCount(const RingBuffer_t *psBuffer)
{
    if (psBuffer == ((void *)0))
    {
        return 0u;
    }

    return psBuffer->u8Count;
}

STD_ReturnType Buffer_Enqueue(RingBuffer_t *psBuffer, uint8 u8Data)
{
    if ((psBuffer == ((void *)0)) || (psBuffer->pu8Data == ((void *)0)) || (psBuffer->u8Capacity == 0u) || Buffer_IsFull(psBuffer))
    {
        return E_NOK;
    }

    psBuffer->pu8Data[psBuffer->u8Head] = u8Data;
    psBuffer->u8Head = (uint8)((psBuffer->u8Head + 1u) % psBuffer->u8Capacity);
    psBuffer->u8Count++;

    return E_OK;
}

STD_ReturnType RingBuffer_Enqueue(RingBuffer_t *psBuffer, uint8 u8Data)
{
    return Buffer_Enqueue(psBuffer, u8Data);
}

STD_ReturnType Buffer_Dequeue(RingBuffer_t *psBuffer, uint8 *pu8Data)
{
    if ((psBuffer == ((void *)0)) || (pu8Data == ((void *)0)) || (psBuffer->pu8Data == ((void *)0)) || Buffer_IsEmpty(psBuffer))
    {
        return E_NOK;
    }

    *pu8Data = psBuffer->pu8Data[psBuffer->u8Tail];
    psBuffer->u8Tail = (uint8)((psBuffer->u8Tail + 1u) % psBuffer->u8Capacity);
    psBuffer->u8Count--;

    return E_OK;
}

STD_ReturnType RingBuffer_Dequeue(RingBuffer_t *psBuffer, uint8 *pu8Data)
{
    return Buffer_Dequeue(psBuffer, pu8Data);
}
