nasm -f bin -o boot.bin boot.asm
nasm -f bin -o loader.bin ./loader/loader.asm
nasm -f elf64 -o kernel.o kernel.asm
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c 
ld -nostdlib -T link.lds -o kernel kernel.o main.o
objcopy -O binary kernel kernel.bin 
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc
