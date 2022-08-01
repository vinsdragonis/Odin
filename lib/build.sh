# !/bin/bash

nasm -f elf64 -o syscall.o syscall.asm
nasm -f elf64 -o lib.o lib.asm
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c print.c
ar rcs lib.a print.o syscall.o lib.o