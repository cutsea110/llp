	section .data
msg:	 db " Hello ", 0

	section .text
	global _start


_start:
	mov rdi, rax
	mov rax, 60
	syscall
