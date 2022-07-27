nasm -f elf64 -o syscall.o syscall.asm
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c print.c
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-ar rcs lib.a print.o syscall.o
