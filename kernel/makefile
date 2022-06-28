all: run

# Notice how dependencies are built as needed
kernel.bin: kernel_entry.o kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	x86_64-elf-gcc -ffreestanding -c $< -o $@

# Rule to disassemble the kernel - may be useful to debug
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

bootsector.bin: bootsector.asm
	nasm $< -f bin -o $@

os-image.bin: bootsector.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-x86_64 -fda $< --nographic -display curses

clean:
	rm *.bin *.o *.dis