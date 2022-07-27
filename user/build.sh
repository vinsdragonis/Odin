nasm -f elf64 -o start.o start.asm
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c
ld -nostdlib -Tlink.lds -o user start.o main.o ../lib/lib.a 
objcopy -O binary user user.bin
