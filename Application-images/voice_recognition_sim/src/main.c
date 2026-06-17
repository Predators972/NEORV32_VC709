#include <neorv32.h>
#include "yes.h"
#include "no.h"
#include "dtw.h"

#define SAMPLE_COUNT 2000

// Allocate globally (before main)
static uint8_t test_audio[SAMPLE_COUNT];  // On HEAP/DATA, not on STACK

const uint8_t* current_test_signal = NULL;

void load_test_signal(int which) {
    if (which == 0) {
        current_test_signal = yes_dat;
    } else {
        current_test_signal = no_dat;
    }
}

void test_voice_recognition() {
    neorv32_uart0_printf("  Copying audio...\n");
    
    for (int i = 0; i < SAMPLE_COUNT; i++) {
        test_audio[i] = current_test_signal[i];
    }
    
    neorv32_uart0_printf("  Computing DTW distances...\n");
    
    float distance_to_yes = dtw_distance(test_audio, yes_dat, SAMPLE_COUNT);
    float distance_to_no = dtw_distance(test_audio, no_dat, SAMPLE_COUNT);
    
    neorv32_uart0_printf("Distance YES: %d\n", (int)distance_to_yes);
    neorv32_uart0_printf("Distance NO: %d\n", (int)distance_to_no);
    
    if (distance_to_yes < distance_to_no) {
        neorv32_uart0_printf(">>> RECOGNIZED: YES\n");
        neorv32_gpio_port_set(0xFF);  // LEDs on
    } else {
        neorv32_uart0_printf(">>> RECOGNIZED: NO\n");
        neorv32_gpio_port_set(0x00);  // LEDs off
    }
}

int main(void) {
    neorv32_uart0_setup(19200, 0);
    
    neorv32_uart0_printf("\n=== Voice Recognition Test ===\n");
    
    // TEST 1: Recognize YES
    neorv32_uart0_printf("Test 1: Recognizing YES\n");
    load_test_signal(0);
    test_voice_recognition();
    
    neorv32_cpu_delay_ms(500);
    
    // TEST 2: Recognize NO
    neorv32_uart0_printf("\nTest 2: Recognizing NO\n");
    load_test_signal(1);
    test_voice_recognition();
    
    neorv32_uart0_printf("\n=== Tests Complete ===\n");
    
    return 0;
}