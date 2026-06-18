#include <neorv32.h>
#include "yes.h"
#include "no.h"
#include "correlation.h"

#define SAMPLE_COUNT 1000

static uint32_t distances_yes[5];
static uint32_t distances_no[5];

uint32_t calculate_average(uint32_t *array, int length) {
    uint32_t sum = 0;
    for (int i = 0; i < length; i++) {
        sum += array[i];
    }
    return sum / length;
}

void test_signal(int which_signal) {
    const uint8_t *signal_data;
    
    if (which_signal == 0) {
        signal_data = yes_dat;
    } else {
        signal_data = no_dat;
    }
    
    distances_yes[0] = correlation_distance(signal_data, yes_dat, SAMPLE_COUNT);
    distances_no[0] = correlation_distance(signal_data, no_dat, SAMPLE_COUNT);
    
    uint32_t avg_yes = distances_yes[0];
    uint32_t avg_no = distances_no[0];
    
    if (avg_yes < avg_no) {
        neorv32_uart0_printf("YES\n");
        neorv32_gpio_port_set(0xFF);
    } else {
        neorv32_uart0_printf("NO\n");
        neorv32_gpio_port_set(0x00);
    }
}

int main(void) {
    neorv32_uart0_setup(19200, 0);
    
    neorv32_uart0_printf("Test1:");
    test_signal(0);
    
    neorv32_uart0_printf("Test2:");
    test_signal(1);
    
    return 0;
}