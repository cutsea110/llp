	section .data
msg:	 db "Hello World", 0

	section .text
	global _start

trimable:
	xor rax, rax
	xor rcx, rcx

	.start:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_no_trimable
	cmp r11b, ' '
	je .in_left_spaces

	.in_word_without_left_spaces:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_no_trimable
	cmp r11b, ' '
	je .in_right_spaces_without_left_spaces
	jmp .in_word_without_left_spaces

	.in_right_spaces_without_left_spaces:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_right_trimable
	cmp r11b, ' '
	je .in_right_spaces_without_left_spaces
	jmp .in_word_without_left_spaces

	.in_left_spaces:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_all_spaces
	cmp r11b, ' '
	je .in_left_spaces

	.in_word_with_left_spaces:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_left_trimable
	cmp r11b, ' '
	je .in_right_spaces_with_left_spaces
	jmp .in_word_with_left_spaces

	.in_right_spaces_with_left_spaces:
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .end_both_trimable
	cmp r11b, ' '
	je .in_right_spaces_with_left_spaces
	jmp .in_word_with_left_spaces

	.end_no_trimable:
	mov rax, 0x0
	ret

	.end_all_spaces:
	mov rax, 0xf
	ret
	
	.end_left_trimable:
	mov rax, 0x1
	ret

	.end_right_trimable:
	mov rax, 0x2
	ret

	.end_both_trimable:
	mov rax, 0x3
	ret
	
_start:
	mov rdi, msg
	call trimable
	mov rdi, rax
	mov rax, 60
	syscall
