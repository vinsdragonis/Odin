nasm -f bin -o ./boot/boot.bin ./boot/boot.asm
dd if=./boot/boot.bin of=./boot/boot.img bs=512 count=1 conv=notrunc
