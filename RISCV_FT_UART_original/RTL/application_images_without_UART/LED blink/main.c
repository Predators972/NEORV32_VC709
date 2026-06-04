#include <neorv32.h>
#include <stdio.h>

#define BAUD_RATE 19200

/**********************************************************************//**
 * Main function: randomly blink leds (GPIO_o of the cpu) when s is press, stop blink when e is pressed. This program is mainly
 * for testing the terminal communication
 **************************************************************************/
 
 void terminate() {
	if (neorv32_uart0_char_received()) {
		//check for terminate
		if (neorv32_uart0_char_received_get() == 't') {
			neorv32_gpio_port_set(0);
			neorv32_cpu_delay_ms(500);
			exit(0);
		}
	}
}

int main() {

  // clear GPIO output (set all bits to 0)
  neorv32_gpio_port_set(0);
  int rand_number = rand() % 5;
  int button = 1;
  
  neorv32_uart0_setup(BAUD_RATE, 0);
  //if (neorv32_uart0_available() == 0) {
    //return 1;
  //}
  neorv32_uart0_printf("link start \n");

  //if (neorv32_spi_available()) {
	//neorv32_uart0_printf("SPI enabled\n\r");
  //}
  //else {
	//neorv32_uart0_printf("SPI is not available\n\r");
  //}

  while (1) {
    //idle state
    neorv32_gpio_port_set(0b0001);
    
    //button = (neorv32_gpio_pin_get(0) & 0b1);
    //while(button == (0)) {
    	//if (neorv32_uart0_char_received()) {
			//if (neorv32_uart0_char_received_get() == 's') {
				button = 1;
			//}
			//else if (neorv32_uart0_char_received_get() == 't') {
				//return 0;
			//}
		//}
    //}
    
    
    if (button == (1)) {
   	    //prepare state, will auto transfer to blink state
    	    srand(neorv32_mtime_get_time()); //set rand seed with current system time
    	    neorv32_gpio_port_set(0b1111);
    	    button = 0;
    	    //neorv32_cpu_delay_ms(250);
    	    while (1) {
    	    	    
    	    	//blink state
				if (neorv32_uart0_char_received()) {
					if (neorv32_uart0_char_received_get() == 'e') {
						button = 1;
					}	
					else if (neorv32_uart0_char_received_get() == 't') {
						button = 1;
						return 0;
					}
				}
    	            
				if (button == (1)) {
					//exit state, wait for 500ms and back to idle state
					//All Leds off
					neorv32_gpio_port_set(0);
					neorv32_cpu_delay_ms(500);
					button = 0;
					break;
				}
		    rand_number = rand() % 5;
		    neorv32_gpio_port_set(rand_number & 0b1111); // increment counter and mask for lowest 8 bit
		    neorv32_cpu_delay_ms(250); // wait 250ms using busy wait
		    
		    //terminate();
		}
	}

  }

  // this should never be reached
  return 0;
}
