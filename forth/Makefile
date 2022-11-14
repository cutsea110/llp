all: forth

stdlib.o: stdlib.s
	nasm -felf64 $< -o $@

forth: forth.o stdlib.o
	ld $? -o $@
	chmod u+x $@

forth.o: forth.s stdlib.inc macro.inc words.inc
	nasm -felf64 $< -o $@

clean:
	rm -f *.o *.so *~ forth
