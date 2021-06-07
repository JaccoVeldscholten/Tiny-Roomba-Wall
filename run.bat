@ECHO OFF

echo (Commando to exectute:  %1)

if "%1"=="flash" (STM32_Programmer_CLI -c port=SWD -w bin\nucleo-l452re\lifecycle.bin 0x08000000 --start 0x08000000)

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

if "%1"=="buildflash" (
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

if "%1"=="clean" (
    rmdir /s /q bin
    docker exec -i riot_toolchain bash -c "rm -rf /RIOT/projects/"
    echo Target Cleaned      
)

if "%1"=="rundocker" (
    docker pull jjveldscholten/arm_riot_toolchain:latest 				
    docker run --name riot_toolchain -it jjveldscholten/arm_riot_toolchain:latest
)

if "%1"=="" (
    echo No Args given Error!
)

