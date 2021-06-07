#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

int main(void)
{
    DDRB  |= _BV(PB1);
    while(1)
    {
        _delay_ms(1000);
        PORTB ^= _BV(PB1);
    }
}