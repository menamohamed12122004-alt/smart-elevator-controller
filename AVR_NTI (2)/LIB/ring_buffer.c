#include "ring_buffer.h"
#include "STD_TYPES.h"

void Buffer_Init(RingBuffer_t *psBuffer, uint8 *pu8Data, uint8 u8Capacity)
{
    if (psBuffer != NULL)
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
    if (psBuffer == NULL)
    {
        return 1u;
    }

    return (uint8)(psBuffer->u8Count == 0u);
}

uint8 Buffer_IsFull(const RingBuffer_t *psBuffer)
{
    if (psBuffer == NULL)
    {
        return 1u;
    }

    return (uint8)(psBuffer->u8Count >= psBuffer->u8Capacity);
}

uint8 Buffer_GetCount(const RingBuffer_t *psBuffer)
{
    if (psBuffer == NULL)
    {
        return 0u;
    }

    return psBuffer->u8Count;
}

STD_ReturnType Buffer_Enqueue(RingBuffer_t *psBuffer, uint8 u8Data)
{
    if ((psBuffer == NULL) || (psBuffer->pu8Data == NULL) || (psBuffer->u8Capacity == 0u) || Buffer_IsFull(psBuffer))
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
    if ((psBuffer == NULL) || (pu8Data == NULL) || (psBuffer->pu8Data == NULL) || Buffer_IsEmpty(psBuffer))
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