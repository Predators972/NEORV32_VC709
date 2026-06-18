#ifndef DTW_H
#define DTW_H

#include <stdint.h>

uint32_t dtw_distance(const uint8_t *signal1, const uint8_t *signal2, int length);

#endif