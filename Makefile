OBJS=ret42 hello hello_proper_exit print_rax strlen read_char cat executable_object libso_main dict_main

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

cat: cat.o
	ld -o $@ $<
	chmod u+x $@

cat.o: cat.s
	nasm -felf64 $< -o $@

symbols.o: symbols.s
	nasm -felf64 $< -o $@
executable_object.o: executable_object.s
	nasm -felf64 $< -o $@
executable_object: executable_object.o symbols.o
	ld $? -o $@
	chmod u+x $@

libso.o: libso.s
	nasm -felf64 $< -o $@
libso.so: libso.o
	ld -shared -o $@ $< 
libso_main.o: libso_main.s
	nasm -felf64 $< -o $@
libso_main: libso_main.o libso.so
	ld -o $@ libso_main.o -d libso.so --dynamic-linker /lib64/ld-linux-x86-64.so.2
	chmod u+x $@

dict_main: dict_main.o dict.o stdio.o
	ld $? -o $@
	chmod u+x $@
stdio.o: stdio.s
	nasm -felf64 $< -o $@
dict.o: dict.s
	nasm -felf64 $< -o $@
dict_main.o: dict_main.s
	nasm -felf64 $< -o $@


clean:
	rm -f *.o *.so *~ ${OBJS}
