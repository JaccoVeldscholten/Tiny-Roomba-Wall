// Using 4Mhz for Low Power
// ATtiny25V/45V/85V: 0 – 4 MHz @ 1.8 - 5.5V
#define F_CPU 16500000UL


#include <avr/io.h>
#include <util/delay.h>



// https://www.engbedded.com/fusecalc/

// Calculation of Prescaler
//  38Khz IR    = 38000 Hz
//  4Mhz  CPU   = 4000000 Hz
//  4000000 / (1 * 38000) - 1  = 104

//  In case of 8Mhz:
//  8000000 / 3800 - 1  = 420
//  To big. So Prescaler set to 8
//  (8000000 / 38000 - 1 ) / 8 = 26.1907894737 ~ 26
//  The Value is under the 256 so Prescaler is not needed

/* Reminder Information for BitWise
************************************
*  Set Bit         |=
*  Clear Bit       &= ~
*  Toggle          ^=
************************************
*/


// 3 pulses Measured Then Pause

//1e Pulse:     0.5ms on. IR off
//Delay:        7.5ms off. IR off
//2e Pulse:     0.5ms on. IR on
//Delay:        7.5ms off. IR off
//3e Pulse:     0.5ms on. IR on
//Delay:        108ms. IR off.

//Loop.


#define LEDPIN PB0          // Defined IR Led Pin

void init(void){
    /* Enable GPIO */
    DDRB  |= _BV(LEDPIN);       /* Enable LED Pin */

    /* Clean Timers */
    TCNT0 = 0;                   /* Reset Counter Timer 0 */
    TCCR0A = 0;                  /* Clean Timer0 A */
    TCCR0B = 0;                  /* Clean Timer0 B */

    /* Initilize Timers Toggle for IR */
    TCCR0A |= (1 << COM0A0);	/* Timer0 Toggle Pin Mode           Table Ref: 11-2 */ 
    TCCR0A |= (1 << WGM01);     /* Timer0 CTC (Compare Match)       Table Ref: 11-5 */
    TCCR0B |= (1 << CS01);	    /* Timer0 Prescaler on Zero         Table Ref: 11-6 */
    OCR0A = 26;                 /* Timer0 CTC Value */
}


void PulseWall(void){
    TCCR0A |= (1 << COM0A0);
    _delay_ms(0.5);
    TCCR0A &= ~(1 << COM0A0);
    _delay_ms(7.5);
}

int main(void)
{
    init();                 /* Tmer Setup */
    while(1)
    {
        PulseWall();        /* Call Pulses */
        PulseWall();
        PulseWall();
        _delay_ms(100.5); /* Delay = 108 - 7.5 (last pulse) */
    }
}
