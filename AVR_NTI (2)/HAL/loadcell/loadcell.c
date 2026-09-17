#include "loadcell.h"
#include "adc.h"

static uint16 s_currentLoadKg = 0u;
static uint8  s_isOverloaded  = 0u;

/* Sample buffer for median-of-3 filtering */
static uint16 s_samples[3] = {0u, 0u, 0u};
static uint8 s_sampleIdx  = 0u;


static uint16 GetMedianOfThree(uint16 a, uint16 b, uint16 c)
{
    if ((a >= b && a <= c) || (a <= b && a >= c))
    {
        return a;
    }
    if ((b >= a && b <= c) || (b <= a && b >= c))
    {
        return b;
    }
    return c;
}


void LOADCELL_Init(void)
{
    s_currentLoadKg = 0u;
    s_isOverloaded  = 0u;
    s_sampleIdx     = 0u;
    
    s_samples[0] = 0u;
    s_samples[1] = 0u;
    s_samples[2] = 0u;
}

uint16 LOADCELL_ReadKg(void)
{
    //  Read raw value from ADC Channel 1 (PA1) 
    uint16 rawAdc = ADC_Read(LOADCELL_ADC_CHANNEL);
    
    /* 2. Store sample in ring buffer for median filter */
    s_samples[s_sampleIdx] = rawAdc;
    s_sampleIdx = (s_sampleIdx + 1u) % 3u;
    
    /* 3. Get filtered ADC value */
    uint16 filteredAdc = GetMedianOfThree(s_samples[0], s_samples[1], s_samples[2]);
    
    /* 4. Convert ADC (0..1023) to load in kg (0..1000) using uint32_t intermediate */
    s_currentLoadKg = (uint16)(((uint32)filteredAdc * LOADCELL_MAX_KG) / 1023u);
    
    /* 5. Update overload flag with hysteresis */
    if (s_currentLoadKg > LOADCELL_OVERLOAD_LIMIT_KG)
    {
        s_isOverloaded = 1u;
    }
    else if (s_currentLoadKg < LOADCELL_OVERLOAD_HYST_KG)
    {
        s_isOverloaded = 0u;
    }
    else
    {
        /* Keep previous s_isOverloaded state inside hysteresis band (850 - 900 kg) */
    }

    return s_currentLoadKg;
}

uint8 LOADCELL_IsOverloaded(void)
{
    return s_isOverloaded;
}