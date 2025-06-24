#include "ad1848.h"
#include <string.h>

void AD1848_Reset(AD1848 *ad)
{
    memset(ad, 0, sizeof(*ad));
}

uint8_t AD1848_Read(AD1848 *ad, uint16_t port)
{
    switch(port & 3)
    {
        case 0:
            return ad->index;
        case 1:
            return ad->regs[ad->index & 0x1F];
        case 2:
            return 0; //status not emulated
    }
    return 0xFF;
}

void AD1848_Write(AD1848 *ad, uint16_t port, uint8_t val)
{
    switch(port & 3)
    {
        case 0:
            ad->index = val & 0x1F;
            break;
        case 1:
            ad->regs[ad->index & 0x1F] = val;
            break;
        case 2:
            //control write ignored
            break;
    }
}
