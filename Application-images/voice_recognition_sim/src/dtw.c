#include "dtw.h"
#include <stdlib.h>

#define MAX_CHUNK_SIZE 1600

static uint16_t dtw_matrix[2 * MAX_CHUNK_SIZE];

static uint16_t min3(uint16_t a, uint16_t b, uint16_t c) {
    if (a < b && a < c) return a;
    if (b < c) return b;
    return c;
}

uint32_t dtw_distance(const uint8_t *signal1, const uint8_t *signal2, int length) {
    uint16_t *prev_row = dtw_matrix;
    uint16_t *curr_row = dtw_matrix + MAX_CHUNK_SIZE;
    
    for (int j = 0; j < length; j++) {
        int diff = signal1[0] - signal2[j];
        if (diff < 0) diff = -diff;
        curr_row[j] = diff;
        if (j > 0) curr_row[j] += curr_row[j-1];
    }
    
    for (int i = 1; i < length; i++) {
        uint16_t *temp = prev_row;
        prev_row = curr_row;
        curr_row = temp;
        
        for (int j = 0; j < length; j++) {
            int diff = signal1[i] - signal2[j];
            if (diff < 0) diff = -diff;
            uint16_t cost = diff;
            
            if (j == 0) {
                curr_row[j] = cost + prev_row[j];
            } else {
                curr_row[j] = cost + min3(prev_row[j], curr_row[j-1], prev_row[j-1]);
            }
        }
    }
    
    return (uint32_t)curr_row[length-1];
}