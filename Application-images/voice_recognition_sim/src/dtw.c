#include "dtw.h"
#include <stdlib.h>
#include <math.h>

#define MAX_SAMPLES 2000

// Allocate correctly: 2 rows of MAX_SAMPLES
static uint16_t dtw_matrix[2 * MAX_SAMPLES];

static uint16_t min3(uint16_t a, uint16_t b, uint16_t c) {
    if (a < b && a < c) return a;
    if (b < c) return b;
    return c;
}

float dtw_distance(const uint8_t *signal1, const uint8_t *signal2, int length) {
    uint16_t *prev_row = dtw_matrix;
    uint16_t *curr_row = dtw_matrix + MAX_SAMPLES;
    
    // Initialize first row
    for (int j = 0; j < length; j++) {
        int diff = signal1[0] - signal2[j];
        curr_row[j] = abs(diff);
        if (j > 0) curr_row[j] += curr_row[j-1];
    }
    
    // Fill matrix
    for (int i = 1; i < length; i++) {
        uint16_t *temp = prev_row;
        prev_row = curr_row;
        curr_row = temp;
        
        for (int j = 0; j < length; j++) {
            int diff = signal1[i] - signal2[j];
            uint16_t cost = abs(diff);
            
            if (j == 0) {
                curr_row[j] = cost + prev_row[j];
            } else {
                curr_row[j] = cost + min3(prev_row[j], curr_row[j-1], prev_row[j-1]);
            }
        }
    }
    
    float result = (float)curr_row[length-1];  // Convert to float for return
    return result;
}