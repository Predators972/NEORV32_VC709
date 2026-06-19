#include <neorv32.h>
#include "yes.h"
#include "no.h"
#include "correlation.h"

#define CHUNK_SIZE 1000
#define NUM_CHUNKS 8
#define NOISE_THRESHOLD 20

static uint8_t chunk_buffer[CHUNK_SIZE];
static int chunk_index = 0;
static int chunk_count = 0;
static int recording = 0;
static uint32_t distance_yes = 0;
static uint32_t distance_no = 0;
static uint8_t baseline = 128;

// Helper: read GPIO input as 64-bit
static inline uint64_t gpio_input_read(void) {
    uint32_t lo = NEORV32_GPIO->INPUT_LO;
    uint32_t hi = NEORV32_GPIO->INPUT_HI;
    return ((uint64_t)hi << 32) | (uint64_t)lo;
}

// Helper: extract byte from 64-bit value
static inline uint8_t gpio_byte(uint64_t gpio_val, int byte_index) {
    return (uint8_t)((gpio_val >> (byte_index * 8)) & 0xFF);
}

// Read VP/VN raw ADC value
static uint16_t xadc_read_raw(void) {
    uint64_t gpio = gpio_input_read();
    uint8_t hi = gpio_byte(gpio, 0);
    uint8_t lo = gpio_byte(gpio, 1);
    return ((uint16_t)hi << 8) | (uint16_t)lo;
}

// Check if ADC has new data ready
static int xadc_eoc(void) {
    uint64_t gpio = gpio_input_read();
    return (int)((gpio >> 17) & 0x01);
}

// Calibrate noise floor
void calibrate_noise_floor(void) {
    neorv32_uart0_printf("Calibrating noise floor...\n");
    uint32_t sum = 0;
    int count = 0;
    
    for (int i = 0; i < 100; i++) {
        if (xadc_eoc()) {
            uint16_t raw = xadc_read_raw();
            sum += (uint8_t)(raw >> 8);
            count++;
        }
        neorv32_cpu_delay_ms(10);
    }
    
    baseline = sum / count;
    neorv32_uart0_printf("Baseline: %d\n", baseline);
    neorv32_uart0_printf("Threshold: %d\n\n", baseline + NOISE_THRESHOLD);
}

// Read one sample from ADC waiting for EOC flag
static uint8_t read_adc_sample(void) {
    while (!xadc_eoc()) {
        // Wait for ADC to have data ready
    }
    uint16_t raw = xadc_read_raw();
    return (uint8_t)(raw >> 8);
}

// Process current chunk and accumulate distances
void process_chunk(void) {
    distance_yes += correlation_distance(
        chunk_buffer,
        yes_dat + (chunk_count * CHUNK_SIZE),
        CHUNK_SIZE
    );
    
    distance_no += correlation_distance(
        chunk_buffer,
        no_dat + (chunk_count * CHUNK_SIZE),
        CHUNK_SIZE
    );
    
    chunk_count++;
}

// Display result
void display_result(void) {
    uint32_t avg_yes = distance_yes / NUM_CHUNKS;
    uint32_t avg_no = distance_no / NUM_CHUNKS;
    
    neorv32_uart0_printf("=== RESULT ===\n");
    neorv32_uart0_printf("Distance YES: %d\n", avg_yes);
    neorv32_uart0_printf("Distance NO: %d\n", avg_no);
    
    if (avg_yes < avg_no) {
        neorv32_uart0_printf(">>> RECOGNIZED: YES\n");
        neorv32_gpio_port_set(0xFF);
    } else {
        neorv32_uart0_printf(">>> RECOGNIZED: NO\n");
        neorv32_gpio_port_set(0x00);
    }
    neorv32_uart0_printf("\n");
}

// Reset for next recording
void reset_recording(void) {
    recording = 0;
    chunk_index = 0;
    chunk_count = 0;
    distance_yes = 0;
    distance_no = 0;
}

int main(void) {
    neorv32_uart0_setup(19200, 0);
    
    if (neorv32_gpio_available() == 0) {
        neorv32_uart0_printf("ERROR: GPIO not available\n");
        return 1;
    }
    
    neorv32_uart0_printf("\n=== Voice Recognition - ADC Streaming ===\n");
    neorv32_uart0_printf("Sample Rate: 8000 Hz (via ADC EOC flag)\n");
    neorv32_uart0_printf("Duration: 1 second (8 chunks of 1000 samples)\n\n");
    
    calibrate_noise_floor();
    
    neorv32_uart0_printf("Waiting for voice input...\n");
    neorv32_uart0_printf("Say 'yes' or 'no' now!\n\n");
    
    while (1) {
        uint8_t sample = read_adc_sample();
        
        // Detect start of signal (threshold crossing)
        if (!recording && sample > (baseline + NOISE_THRESHOLD)) {
            recording = 1;
            chunk_index = 0;
            chunk_count = 0;
            distance_yes = 0;
            distance_no = 0;
            neorv32_uart0_printf("Voice detected! Recording...\n");
        }
        
        // Store sample if recording
        if (recording) {
            chunk_buffer[chunk_index] = sample;
            chunk_index++;
            
            // When chunk is full
            if (chunk_index >= CHUNK_SIZE) {
                neorv32_uart0_printf("Chunk %d/%d processed\n", chunk_count + 1, NUM_CHUNKS);
                
                // Process the chunk
                process_chunk();
                
                // Reset for next chunk
                chunk_index = 0;
                
                // Check if recording complete (1 second)
                if (chunk_count >= NUM_CHUNKS) {
                    recording = 0;
                    neorv32_uart0_printf("Recording complete!\n\n");
                    display_result();
                    neorv32_uart0_printf("Ready for next input...\n\n");
                }
            }
        }
    }
    
    return 0;
}