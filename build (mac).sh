nasm -f bin -o ./bin/boot.bin ./boot.asm
nasm -f bin -o ./bin/loader.bin ./src/loader.asm
nasm -f elf64 -o ./obj/kernel.o ./src/kernel.asm
nasm -f elf64 -o ./obj/trapa.o ./src/trap.asm
nasm -f elf64 -o ./obj/liba.o ./src/lib.asm
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/main.c -o ./obj/main.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/trap.c -o ./obj/trap.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/print.c -o ./obj/print.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/debug.c -o ./obj/debug.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/memory.c -o ./obj/memory.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/process.c -o ./obj/process.
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/syscall.c -o ./obj/syscall.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-ld -nostdlib -T link.lds -o kernel kernel.o main.o trapa.o trap.o liba.o print.o debug.o memory.o process.o syscall.o
/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-objcopy -O binary kernel kernel.bin 
dd if=./bin/boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=./bin/loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=./bin/kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc
dd if=./usr/usr.bin of=boot.img bs=512 count=10 seek=106 conv=notrunc