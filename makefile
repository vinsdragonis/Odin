all: bootloader

bootloader:
	mkdir "./prototype/bin"
	nasm -f bin "./prototype/boot.asm" -o "./prototype/bin/boot.bin"
	nasm -f bin "./prototype/boot_sect_memory.asm" -o "./prototype/bin/boot_sect_memory.bin"
	nasm -f bin "./prototype/bootsector_stack.asm" -o "./prototype/bin/bootsector_stack.bin"

clear:
	rm -rf "./prototype/bin"

run:
	qemu-system-x86_64 boot.bin --nographic