#include "correlation.h"

uint32_t correlation_distance(const uint8_t *signal1, const uint8_t *signal2, int length) {
    uint32_t distance = 0;
    
    for (int i = 0; i < length; i++) {
        int diff = signal1[i] - signal2[i];
        distance += diff * diff;
    }
    
    return distance / length;
}