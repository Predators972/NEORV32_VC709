#ifndef DTW_H
#define DTW_H

#include <stdint.h>

// Compare 2 signaux audio et retourne la "distance"
// Plus petite distance = plus similaire
float dtw_distance(const uint8_t *signal1, const uint8_t *signal2, int length);

#endif