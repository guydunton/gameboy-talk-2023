
hello-world.o: hello-world.asm
	rgbasm -L -o hello-world.o hello-world.asm

hello-world.gb: hello-world.o
	rgblink -o hello-world.gb hello-world.o
	rgbfix -v -p 0xFF hello-world.gb

build: hello-world.gb

clean:
	rm -f hello-world.gb hello-world.o
