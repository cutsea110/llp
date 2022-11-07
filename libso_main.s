	global _start

	extern func

	section .text

_start:
	call func
	mov rdi, rax
	mov rax, 60
	syscall
