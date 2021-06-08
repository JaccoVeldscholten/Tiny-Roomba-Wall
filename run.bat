@ECHO OFF

echo (Commando to exectute:  %1)

if "%1"=="flash-usb" (launcher -cdigispark --timeout 60 -Uflash:w:bin\main.hex:i)
if "%1"=="flash-usbasp" (avrdude -c usbasp -p t85 -B 0.5 -U flash:w:".\bin\main.hex":a)

if "%1"=="build" (
    rmdir /s /q bin 
    docker cp . avr-toolchain:/build
    docker exec -i avr-toolchain bash -c "avr-gcc -Wall -g -Os -mmcu=attiny85 -o main.bin main.c"
    docker exec -i avr-toolchain bash -c "avr-objcopy -j .text -j .data -O ihex main.bin main.hex"
    mkdir bin    
    docker cp avr-toolchain:/build/main.bin ./bin/
    docker cp avr-toolchain:/build/main.hex ./bin/
    echo Build Done
)

if "%1"=="buildflash-usb" (
    rmdir /s /q bin 
    docker cp . avr-toolchain:/build
    docker exec -i avr-toolchain bash -c "avr-gcc -Wall -g -Os -mmcu=attiny85 -o main.bin main.c"
    docker exec -i avr-toolchain bash -c "avr-objcopy -j .text -j .data -O ihex main.bin main.hex"
    mkdir bin    
    docker cp avr-toolchain:/build/main.bin ./bin/
    docker cp avr-toolchain:/build/main.hex ./bin/
    echo Build Done
    launcher -cdigispark --timeout 60 -Uflash:w:bin\main.hex:i
    echo Flash Done
)

if "%1"=="buildflash-usbasp" (
        rmdir /s /q bin 
    docker cp . avr-toolchain:/build
    docker exec -i avr-toolchain bash -c "avr-gcc -Wall -g -Os -mmcu=attiny85 -o main.bin main.c"
    docker exec -i avr-toolchain bash -c "avr-objcopy -j .text -j .data -O ihex main.bin main.hex"
    mkdir bin    
    docker cp avr-toolchain:/build/main.bin ./bin/
    docker cp avr-toolchain:/build/main.hex ./bin/
    echo Build Done
    avrdude -c usbasp -p t85 -B 0.5 -U flash:w:".\bin\main.hex":a 
    echo Flash Done
)

if "%1"=="clean" (
    rmdir /s /q bin 
    docker exec -i riot_toolchain bash -c "rm -rf /build"
    echo Target Cleaned      
)

if "%1"=="rundocker" (
    docker pull jjveldscholten/arm_riot_toolchain:latest 				
    docker run --name riot_toolchain -it jjveldscholten/arm_riot_toolchain:latest
)

if "%1"=="" (
    echo No Args given Error!
)

