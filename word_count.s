	section .data
msg:	db "the quick brown fox jumps over the lazy dog", 0
	
	section .text
	global _start

word_count:
	xor rax, rax
	xor rcx, rcx

	.init:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end
	cmp r11b, ' '
	je .init
	inc rax

	.on:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end
	cmp r11b, ' '
	jne .on

	.off:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end
	cmp r11b, ' '
	je .off
	inc rax
	jmp .on

	.end:
	ret

_start:
	mov rdi, msg
	call word_count
	mov rdi, rax
	mov rax, 60
	syscall
