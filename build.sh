nasm -f bin -o ./bin/boot.bin boot.asm
nasm -f bin -o ./bin/loader.bin ./loader/loader.asm
nasm -f elf64 -o kernel.o kernel.asm
nasm -f elf64 -o ./trapa.o ./trap/trap.asm
nasm -f elf64 -o ./lib/liba.o ./lib/lib.asm
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./trap/trap.c
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./print/print.c
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./debug/debug.c
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./memory/memory.c
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./process/process.c 
ld -nostdlib -T link.lds -o kernel kernel.o main.o ./trapa.o ./trap.o ./lib/liba.o ./print.o ./debug/debug.o ./memory.o ./process.o
objcopy -O binary kernel ./bin/kernel.bin 
dd if=./bin/boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=./bin/loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=./bin/kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc
