nasm -f bin -o boot.bin boot.asm
nasm -f bin -o loader.bin ./loader/loader.asm
nasm -f bin -o kernel.bin ./kernel.asm
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc