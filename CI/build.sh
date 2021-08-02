#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Install packages we need for building
sudo apt-get update -y
sudo apt-get install binutils gcc-avr avr-libc uisp avrdude flex byacc bison

# Make sure we are inside the github workspace
cd $GITHUB_WORKSPACE

# Compile for Attiny85
avr-gcc -Wall -g -Os -mmcu=attiny85 -o main_attiny85.bin main.c
avr-objcopy -j .text -j .data -O ihex main_attiny85.bin main_attiny85.hex

# Compile for Atmega328
avr-gcc -Wall -g -Os -mmcu=atmega328 -o main_atmega328.bin main.c
avr-objcopy -j .text -j .data -O ihex main_atmega328.bin main_atmega328.hex