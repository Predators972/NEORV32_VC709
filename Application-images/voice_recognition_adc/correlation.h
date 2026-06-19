#ifndef CORRELATION_H
#define CORRELATION_H

#include <stdint.h>

uint32_t correlation_distance(const uint8_t *signal1, const uint8_t *signal2, int length);

#endif