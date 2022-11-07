	section .data
datavar1:	dq 1488
datavar2:	dq 42

	section .bss
bssvar1:	resq 4*1024*1024
bssvar2:	resq 1
	
	section .text

	extern somewhere
	global _start
	mov rax, datavar1
	mov rax, datavar2
	mov rax, bssvar1
	mov rdx, bssvar2
_start:
	jmp _start
	ret
textlabel:	dq 0
	
	
