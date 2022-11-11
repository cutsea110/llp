	section .data
msg:	 db "Hello World", 0

	section .text
	global _start

trimable:
	xor rax, rax
	xor rcx, rcx

	.S: 			; Start
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .EN
	cmp r11b, ' '
	je .LS

	.RW: 			; In Right Word
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .EN
	cmp r11b, ' '
	je .RS
	jmp .RW

	.RS: 			; In Right Space
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .ER
	cmp r11b, ' '
	je .RS
	jmp .RW

	.LS: 			; In Left Space
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .EA
	cmp r11b, ' '
	je .LS

	.LW: 			; In Left Word
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .EL
	cmp r11b, ' '
	je .BS
	jmp .LW

	.BS: 			; In Both Space
	mov r11b, [rdi + rcx]
	inc rcx
	cmp r11b, 0x0
	je .EB
	cmp r11b, ' '
	je .BS
	jmp .LW

	.EN: 			; None Trimable
	mov rax, 0x0
	ret

	.EA: 			; All Spaces
	mov rax, 0xf
	ret
	
	.EL: 			; Left Trimable
	mov rax, 0x1
	ret

	.ER: 			; Right Trimable
	mov rax, 0x2
	ret

	.EB: 			; Both Trimable
	mov rax, 0x3
	ret
	
_start:
	mov rdi, msg
	call trimable
	mov rdi, rax
	mov rax, 60
	syscall
