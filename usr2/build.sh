# !/bin/bash

nasm -f elf64 -o ./obj/start.o start.asm
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c -o ./obj/main.o
ld -nostdlib -Tlink.lds -o usr ./obj/start.o ./obj/main.o ./lib.a
objcopy -O binary usr ./bin/usr.bin