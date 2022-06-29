C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o}

# -g: Use debugging symbols in gcc
CFLAGS = -g

# Notice how dependencies are built as needed
kernel.bin: ./kernel/obj/kernel_entry.o ./kernel/obj/kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: ./boot/kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: ./kernel/kernel.c
	x86_64-elf-gcc -ffreestanding -c $< -o $@

# Rule to disassemble the kernel - may be useful to debug
kernel.dis: ./kernel/bin/kernel.bin
	ndisasm -b 32 $< > $@

bootsector.bin: ./boot/bootsector.asm
	nasm $< -f bin -o $@

os-image.bin: ./boot/bootsector.bin ./kernel/bin/kernel.bin
	cat $^ > $@

run: ./kernel/os-image.bin
	qemu-system-i386 -fda $< --nographic -display curses

# Open the connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	qemu-system-i386 -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm

clean:
	rm ./*.bin ./*.o ./*.dis