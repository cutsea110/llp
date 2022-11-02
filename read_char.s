	global _start
section .text
read_char:
	push 0
	xor rax, rax
	xor rdi, rdi
	mov rsi, rsp
	mov rdx, 1
	syscall
	pop rax
	ret

_start:
	call read_char
	mov rdi, rax
	mov rax, 60
	syscall
