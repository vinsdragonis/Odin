nasm -f bin -o boot.bin boot.asm
nasm -f bin -o loader.bin loader.asm
nasm -f elf64 -o kernel.o kernel.asm
nasm -f elf64 -o trapa.o trap.asm
nasm -f elf64 -o liba.o lib.asm
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c 
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c trap.c 
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c print.c 
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-ld -nostdlib -T link.lds -o kernel kernel.o main.o trapa.o trap.o liba.o print.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-objcopy -O binary kernel kernel.bin 
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc