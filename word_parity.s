	section .data
msg:	db "the quick brown fox jumps over the lazy dog", 0 

	section .text
	global _start

word_parity:
	xor rax, rax
	xor rcx, rcx

	.skip:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_even
	cmp r11b, ' '
	je .skip
	cmp r11b, 0x9 		; \t
	je .skip
	cmp r11b, 0xa 		; \n
	je .skip
	cmp r11b, 0xd 		; \r
	je .skip

	.odd:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_odd
	cmp r11b, ' '
	je .even
	cmp r11b, 0x9 		; \t
	je .even
	cmp r11b, 0xa 		; \n
	je .even
	cmp r11b, 0xd 		; \r
	je .even
	jmp .odd
	

	.even:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_even
	cmp r11b, ' '
	je .odd
	cmp r11b, 0x9 		; \t
	je .odd
	cmp r11b, 0xa 		; \n
	je .odd
	cmp r11b, 0xd 		; \r
	je .odd
	jmp .even
	

	.end_even:
	mov rax, 0
	ret

	.end_odd:
	mov rax, 1
	ret

_start:
	mov rdi, msg
	call word_parity
	mov rdi, rax
	mov rax, 60
	syscall
