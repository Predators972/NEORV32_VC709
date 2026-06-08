#include <neorv32.h>

#define BAUD_RATE 19200
#define SAMPLE_DELAY_MS 500

/**************************************************************************
 * XADC Debug Program: UART + LED Display + LED Counter Test
 **************************************************************************/

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

// Read status flags from GPIO
static int xadc_busy(void) {
  uint64_t gpio = gpio_input_read();
  return (int)((gpio >> 16) & 0x01);
}

static int xadc_eoc(void) {
  uint64_t gpio = gpio_input_read();
  return (int)((gpio >> 17) & 0x01);
}

static int xadc_eos(void) {
  uint64_t gpio = gpio_input_read();
  return (int)((gpio >> 18) & 0x01);
}

static int xadc_alarm(void) {
  uint64_t gpio = gpio_input_read();
  return (int)((gpio >> 19) & 0x01);
}

// Convert raw to voltage
static uint16_t xadc_to_voltage_mv(uint16_t raw) {
  uint16_t adc12 = raw >> 4;
  return (uint16_t)(((uint32_t)adc12 * 1000) >> 12); 
}

// Print 8-bit value in binary
static void print_binary_8bit(uint8_t value) {
  for (int i = 7; i >= 0; i--) {
    neorv32_uart0_printf("%d", (value >> i) & 1);
  }
}

// Simple delay helper
void delay_ms(uint32_t time_ms) {
  neorv32_cpu_delay_ms(time_ms);
}

// Print 32-bit value en hex (sans format string)
static void print_hex32(uint32_t value) {
  for (int i = 7; i >= 0; i--) {
    uint8_t nibble = (value >> (i * 4)) & 0xF;
    if (nibble < 10) {
      neorv32_uart0_printf("%d", nibble);
    } else {
      neorv32_uart0_printf("%c", 'A' + (nibble - 10));
    }
  }
}

// Print voltage nicely
static void print_voltage(uint16_t mv) {
  int whole = mv / 1000;
  int frac = mv % 1000;
  neorv32_uart0_printf("%d.%d", whole, frac);
}

int main(void) {

  // Initialize UART
  neorv32_uart0_setup(BAUD_RATE, 0);

  if (neorv32_gpio_available() == 0) {
    neorv32_uart0_printf("ERROR: GPIO not available\n");
    return 1;
  }

  // Clear LEDs initially
  neorv32_gpio_port_set(0);

  // Print banner
  neorv32_uart0_printf("\n");
  neorv32_uart0_printf("==========================================\n");
  neorv32_uart0_printf("  XADC Debug Program: UART + LED + Counter\n");
  neorv32_uart0_printf("==========================================\n");
  neorv32_uart0_printf("Channel    : VP/VN (dedicated input)\n");
  neorv32_uart0_printf("Full scale : 0 to 1.000 V\n");
  neorv32_uart0_printf("Resolution : 12-bit (4096 steps)\n");
  neorv32_uart0_printf("LEDs       : 8-bit counter / voltage display\n");
  neorv32_uart0_printf("==========================================\n");
  neorv32_uart0_printf("\nCommands:\n");
  neorv32_uart0_printf("  's' = start ADC sampling (display voltage on LEDs)\n");
  neorv32_uart0_printf("  'e' = LED counter test (verify LED hardware)\n");
  neorv32_uart0_printf("\nWaiting for command...\n");

  int sampling = 0;
  int led_test = 0;
  int sample_count = 0;
  int led_counter = 0;

  while (1) {

    // Check for user input
    if (neorv32_uart0_char_received()) {
      char cmd = neorv32_uart0_char_received_get();
      
      if (cmd == 's') {
        sampling = 1;
        led_test = 0;
        sample_count = 0;
        neorv32_uart0_printf("\nStarting ADC sampling...\n\n");
        neorv32_uart0_printf("Sample | Raw_Hex | Voltage | LED_Bits_8 | Busy EOC EOS Alarm | GPIO_Buffer\n");
        neorv32_uart0_printf("-------|---------|---------|------------|-------------------|---------------\n");
      } 
      else if (cmd == 'e') {
        sampling = 0;
        led_test = 1;
        led_counter = 0;
        neorv32_uart0_printf("\nStarting LED counter test (8-bit)...\n");
        neorv32_uart0_printf("LEDs should increment from 00000000 to 11111111 (binary)\n");
        neorv32_uart0_printf("Each count takes 250ms\n\n");
      }
    }

    // ADC Sampling mode
    if (sampling) {
      
      // Read ADC value and status
      uint16_t raw_vpvn = xadc_read_raw();
      uint16_t mv_vpvn = xadc_to_voltage_mv(raw_vpvn);
      uint8_t led_value = raw_vpvn >> 8;
      int busy = xadc_busy();
      int eoc = xadc_eoc();
      int eos = xadc_eos();
      int alarm = xadc_alarm();
      uint32_t buffer_lo = (uint32_t)gpio_input_read();

      // Display on LEDs
      neorv32_gpio_port_set(led_value);

      // Print entire line
      neorv32_uart0_printf("  %d | %d | ", sample_count, raw_vpvn);
      print_voltage(mv_vpvn);
      neorv32_uart0_printf(" | ");
      print_binary_8bit(led_value);
      neorv32_uart0_printf(" | %d %d %d %d | ", busy, eoc, eos, alarm);
      print_hex32(buffer_lo);
      neorv32_uart0_printf("\n");
      
      // Debug: afficher la trame complète en hex
      neorv32_uart0_printf("Full_Buffer: ");
      print_hex32(buffer_lo);
      neorv32_uart0_printf("\n\n");

      sample_count++;

      // Delay between samples
      neorv32_cpu_delay_ms(SAMPLE_DELAY_MS);
    } 
    // LED Counter Test mode
    else if (led_test) {
      
      // Set LEDs to current counter value (0-255)
      neorv32_gpio_port_set(led_counter & 0xFF);

      // Print current counter value
      neorv32_uart0_printf("Counter: %d (binary: ", led_counter);
      print_binary_8bit(led_counter);
      neorv32_uart0_printf(")\n");

      // Increment counter
      led_counter++;
      if (led_counter > 255) {
        led_counter = 0;
        neorv32_uart0_printf("--- Counter reset to 0 ---\n");
      }

      // Delay
      delay_ms(250);
    } 
    else {
      // Idle - just wait
      neorv32_cpu_delay_ms(100);
    }
  }

  return 0;
}