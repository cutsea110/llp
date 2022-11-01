all: hello hello_proper_exit print_rax

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

clean:
	rm -f *.o hello hello_proper_exit print_rax *~
