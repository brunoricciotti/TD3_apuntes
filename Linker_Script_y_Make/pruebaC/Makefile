all:
	nasm main16.asm -o main16.bin
	nasm main32.asm -f elf32 -o main32.o
	gcc -fno-stack-protector -fno-pie -m32 cuadrado.c -c -o cuadrado.o
	ld -z max-page-size=0x1000 -m elf_i386 -T pruebaC.lds main32.o cuadrado.o -o mi_rom.o
	ld -z max-page-size=0x1000 --oformat=binary -m elf_i386 -T pruebaC.lds main32.o cuadrado.o -o mi_rom.bin

clean:
	rm *.o *.bin *.txt
	
