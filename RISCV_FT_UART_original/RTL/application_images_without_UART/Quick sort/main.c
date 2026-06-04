#include <neorv32.h>
#include <stdio.h>

#define array_size 100

#define BAUD_RATE 19200

/**********************************************************************//**
 * Main function; generate a array that is filled with random number, and then run quick sort on it.
 **************************************************************************/

int compare(const void *a, const void *b) {
	return ( *(int*)a - *(int*)b);
}

int terminate() {
	if (neorv32_uart0_char_received()) {
		//check for terminate
		if (neorv32_uart0_char_received_get() == 'e') {
			neorv32_gpio_port_set(0);
			neorv32_cpu_delay_ms(500);
			return 0;
		}
		return 1;
	}
	else {
		return 1;
	}
}

int main() {

  // clear GPIO output (set all bits to 0)
  neorv32_gpio_port_set(0);
  int numbers[array_size];
  int button = 0;
  
  neorv32_uart0_setup(BAUD_RATE, 0);
//  if (neorv32_uart0_available() == 0) {
//    return 1;
//  }
  neorv32_uart0_printf("link start \n");

//  while (1) {
    //idle state
//    neorv32_gpio_port_set(0b0001);
    
    //button = (neorv32_gpio_pin_get(0) & 0b1);
//    while(button == (0)) {
//    	if (neorv32_uart0_char_received()) {
//			if (neorv32_uart0_char_received_get() == 's') {
//				button = 1;
//			}
//		}
//    }
    
    
    //if (button == (1)) {
    while(1) {
   	    //prepare state, for set rand() seed
    	    srand(neorv32_mtime_get_time()); //set rand seed with current system time
    	    neorv32_gpio_port_set(0b1111);
    	    //button = 0;
    	    //neorv32_cpu_delay_ms(250);

			neorv32_uart0_printf("\n\rrandom number sequence start: \n\r");
			for (int i = 0; i < array_size; i++) {
				numbers[i] = rand();
				neorv32_uart0_printf("%d\n\r", numbers[i]);
			}
			qsort(numbers, array_size, sizeof(int), compare);

			neorv32_uart0_printf("\n\rSorted sequence start: \n\r");
			for(int i = 0; i < array_size; i++) {
				neorv32_uart0_printf("%d\n\r", numbers[i]);
			}
	}

  //}

  // this should never be reached
  return 0;
}
