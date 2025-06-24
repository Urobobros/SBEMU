// SPDX-License-Identifier: GPL-2.0
// Simplified Windows Sound System emulation
// Modelled after the implementation in PCem but without actual audio output.

#include "wss.h"
#include "../hdpmipt.h"
#include "pic.h"

static const int WSS_DMA_Map[4] = {0, 0, 1, 3};
static const int WSS_IRQ_Map[8] = {5, 7, 9, 10, 11, 12, 14, 15};

static uint8_t WSS_Config;
static int WSS_DMA;
static int WSS_IRQ;
static AD1848 WSS_AD;

void WSS_Reset(void)
{
    AD1848_Reset(&WSS_AD);
    WSS_Config = 0;
    WSS_DMA = 3; /* PCem defaults to DMA 3 */
    WSS_IRQ = 7; /* PCem defaults to IRQ 7 */
    AD1848_SetDMA(&WSS_AD, WSS_DMA);
    AD1848_SetIRQ(&WSS_AD, WSS_IRQ);
}

uint8_t WSS_ReadPort(uint16_t port)
{
    if(port == 0x530)
        return 0x04 | (WSS_Config & 0x40);
    if(port >= 0x534 && port <= 0x537)
        return AD1848_Read(&WSS_AD, port - 0x534);
    return 0xFF;
}

void WSS_WritePort(uint16_t port, uint8_t value)
{
    if(port == 0x530)
    {
        WSS_Config = value;
        WSS_DMA = WSS_DMA_Map[value & 3];
        WSS_IRQ = WSS_IRQ_Map[(value >> 3) & 7];
        AD1848_SetDMA(&WSS_AD, WSS_DMA);
        AD1848_SetIRQ(&WSS_AD, WSS_IRQ);
        return;
    }
    if(port >= 0x534 && port <= 0x537)
    {
        AD1848_Write(&WSS_AD, port - 0x534, value);
    }
}

int WSS_GetDMA(void)
{
    return WSS_DMA;
}

int WSS_GetIRQ(void)
{
    return WSS_IRQ;
}

BOOL WSS_IRQFree(void)
{
    HDPMIPT_IRQRoutedHandle h;
    if(!HDPMIPT_GetIRQRoutedHandlerH(WSS_IRQ, &h))
        return FALSE;
    if(h.cs == 0 && h.offset == 0 && h.rmcs == 0 && h.rmoffset == 0)
    {
        uint16_t mask = PIC_GetIRQMask();
        return PIC_IS_IRQ_MASKED(mask, WSS_IRQ);
    }
    return FALSE;
}
