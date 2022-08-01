# !/bin/bash

nasm -f bin -o ./bin/boot.bin ./boot.asm
nasm -f bin -o ./bin/loader.bin ./src/loader.asm
nasm -f elf64 -o ./obj/kernel.o ./src/kernel.asm
nasm -f elf64 -o ./obj/trapa.o ./src/trap.asm
nasm -f elf64 -o ./obj/liba.o ./src/lib.asm
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/main.c -o ./obj/main.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/trap.c  -o ./obj/trap.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/print.c  -o ./obj/print.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/debug.c  -o ./obj/debug.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/memory.c -o ./obj/memory.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/process.c -o ./obj/process.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/syscall.c -o ./obj/syscall.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/lib.c -o ./obj/lib.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/keyboard.c -o ./obj/keyboard.o
ld -nostdlib -T link.lds -o kernel ./obj/kernel.o ./obj/main.o ./obj/trapa.o ./obj/trap.o ./obj/liba.o ./obj/print.o ./obj/debug.o ./obj/memory.o ./obj/process.o ./obj/syscall.o ./obj/lib.o ./obj/keyboard.o
objcopy -O binary kernel ./bin/kernel.bin 
dd if=./bin/boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=./bin/loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=./bin/kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc
dd if=./usr1/bin/usr.bin of=boot.img bs=512 count=10 seek=106 conv=notrunc
dd if=./usr2/bin/usr.bin of=boot.img bs=512 count=10 seek=116 conv=notrunc
dd if=./usr3/bin/usr.bin of=boot.img bs=512 count=10 seek=126 conv=notrunc