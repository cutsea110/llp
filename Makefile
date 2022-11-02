OBJS=ret42 hello hello_proper_exit print_rax strlen read_char

all: ${OBJS}

ret42: ret42.o
	ld -o $@ $<
	chmod u+x $@

ret42.o: ret42.s
	nasm -felf64 $< -o $@

hello: hello.o
	ld -o $@ $<
	chmod u+x $@

hello.o: hello.s
	nasm -felf64 $< -o $@

hello_proper_exit: hello_proper_exit.o
	ld -o $@ $<
	chmod u+x $@

hello_proper_exit.o: hello_proper_exit.s
	nasm -felf64 $< -o $@

print_rax: print_rax.o
	ld -o $@ $<
	chmod u+x $@

print_rax.o: print_rax.s
	nasm -felf64 $< -o $@

strlen: strlen.o
	ld -o $@ $<
	chmod u+x $@

strlen.o: strlen.s
	nasm -felf64 $< -o $@

read_char: read_char.o
	ld -o $@ $<
	chmod u+x $@

read_char.o: read_char.s
	nasm -felf64 $< -o $@

clean:
	rm -f *.o *~ ${OBJS}
