#include <neorv32.h>
#include <stdio.h>

#define BAUD_RATE 19200
#define MAX_SIZE 1000


/**********************************************************************//**
 * Main function; calculate 10 Fibonacci numbers every time s is pressed, restart the sequence when e is pressed
 **************************************************************************/

int fib_sequence[MAX_SIZE]; 
int fib_count = 0; 

void calculate_fibonacci(int n) {
    int i;
    
    if (n <= 0)
        return;
    
    if (fib_count == 0) { // If the sequence is not started, add 0
        fib_sequence[0] = 0;
        fib_count++;
        if (n == 1) 
            return;
    }

    if (fib_count == 1) { // If we only have the first number in the sequence, add the second
        fib_sequence[1] = 1;
        fib_count++;
        n--;
    }
    
    for(i = fib_count; i < fib_count + n && i < MAX_SIZE; i++) {
        fib_sequence[i] = fib_sequence[i-1] + fib_sequence[i-2];
    }
    fib_count = i;
}

void print_fibonacci(int start, int end) {
    int i;
    for(i = start; i < end && i < fib_count; i++) {
        neorv32_uart0_printf("%d ", fib_sequence[i]);
    }
    neorv32_uart0_printf("\n\r");
}

int main() {

    neorv32_uart0_setup(BAUD_RATE, 0);
    if (neorv32_uart0_available() == 0) {
        return 1;
    }
  
    neorv32_uart0_printf("Press 's' to calculate 10 more Fibonacci numbers or 'e' to restart sequence.\n");

    while(1) {
        if (neorv32_uart0_char_received()) {
            char c = neorv32_uart0_char_received_get();
            if(c == 's') {
                int prev_count = fib_count;
                calculate_fibonacci(10);
                print_fibonacci(prev_count, fib_count);
            } else if(c == 'e') {
                fib_count = 0;
                calculate_fibonacci(10);
                print_fibonacci(0, fib_count);
            }
        }
    }
    return 0;
}

