#ifndef WSS_EMU_H
#define WSS_EMU_H

#include <stdint.h>
#include "ad1848.h"

void WSS_Reset(void);
uint8_t WSS_ReadPort(uint16_t port);
void WSS_WritePort(uint16_t port, uint8_t value);
int WSS_GetDMA(void);
int WSS_GetIRQ(void);

#endif // WSS_EMU_H
