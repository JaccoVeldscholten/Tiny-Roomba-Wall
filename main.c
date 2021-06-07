#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>


/* Reminder Information for BitWise
************************************
*  Set Bit         |=
*  Clear Bit       &= ~
*  Toggle          ^=
************************************
*/


#define LEDPIN PB1

void init(void){
    /* Enable GPIO */
    DDRB  |= _BV(LEDPIN);       /* Enable LED Pin */

    /* Clean Timers */
    TCNT0 = 0;                   /* Reset Counter Timer 0 */
    TCCR0A = 0;                  /* Clean Timer0 A */
	TCCR0B = 0;                  /* Clean Timer0 B */

    /* Initilize Timers */
	TCCR0A |= (1 << COM0A0);	/* Timer0 Toggle Mode         Table Ref: 11-2 */ 
    TCCR0A |= (1 << WGM01);     /* Timer0 CTC (Compare Match) Table Ref: 11-5 */
    TCCR0B |= (1 << CS00);	    /* Timer0 Prescaler on Zero   Table Ref: 11-6 */
    OCR0A = 104;                /* Timer0 CTC Value */
}


void BlinkLed(void){

}

int main(void)
{
    init();
    while(1)
    {

        PORTB |= _BV(LEDPIN);
        _delay_ms(100);
        PORTB &= ~_BV(LEDPIN);
        _delay_ms(100);
    }
}