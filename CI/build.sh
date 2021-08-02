#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Install packages we need for building
sudo apt-get update -y
sudo apt-get install binutils gcc-avr avr-libc uisp avrdude flex byacc bison

# Make sure we are inside the github workspace
cd $GITHUB_WORKSPACE

# Install toolchain


# Compile
avr-gcc -Wall -g -Os -mmcu=attiny85 -o main.bin main.c
avr-objcopy -j .text -j .data -O ihex main.bin main.hex

ls