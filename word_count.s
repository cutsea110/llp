	section .data
msg:	db "the quick brown fox jumps over the lazy dog", 0
	
	section .text
	global _start

word_count:
	xor rax, rax
	xor rcx, rcx

	.off:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end
	cmp r11b, ' '
	je .off
	cmp r11b, 0x9 		; \t
	je .off
	cmp r11b, 0xa 		; \n
	je .off
	cmp r11b, 0xd 		; \r
	je .off
	inc rax

	.on:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end
	cmp r11b, ' '
	je .off
	cmp r11b, 0x9 		; \t
	je .off
	cmp r11b, 0xa 		; \n
	je .off
	cmp r11b, 0xd 		; \r
	je .off
	jmp .on

	.end:
	ret

_start:
	mov rdi, msg
	call word_count
	mov rdi, rax
	mov rax, 60
	syscall
