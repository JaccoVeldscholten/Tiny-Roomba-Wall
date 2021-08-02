DEVICE     = attiny85
PROGRAMMER = stk500v1
BAUD       = 19200
FILENAME   = main
COMPILE    = avr-gcc -Wall -Os -mmcu=$(DEVICE)

all: build clean
	
build:
	$(COMPILE) -c $(FILENAME).c -o $(FILENAME).o
	$(COMPILE) -o $(FILENAME).elf $(FILENAME).o
	avr-objcopy -j .text -j .data -O ihex $(FILENAME).elf $(FILENAME).hex
	avr-size --format=avr --mcu=$(DEVICE) $(FILENAME).elf

clean:
	rm main.o
	rm main.elf
	rm main.hex