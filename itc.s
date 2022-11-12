	%include "stdio.s"

	global _start

	%define pc r15
	%define w r14
	%define rstack r13

	section .bss
	resq 1023
rstack_start:
	resq 1
input_buf:
	resb 1024

	section .text

main_stub:
	dq xt_main

	;; Dictionary

;;;  drop stack top
w_drop:	
	dq 0 			; no previous node
	db "drop", 0
	db 0 			; Flags = 0
xt_drop:
	dq i_drop
i_drop:
	add rsp, 8
	jmp next

;;; initialize registers
w_init:	
	dq w_drop
	db "init", 0
	db 0 			; Flags = 0
xt_init:
	dq i_init
i_init:
	mov rstack, rstack_start
	mov pc, main_stub
	jmp next

;;; save pc
w_docol:
	dq w_init
	db "docol", 0
	db 0 			; Flags = 0
xt_docol:
	dq i_docol
i_docol:
	sub rstack, 8
	mov [rstack], pc
	add w, 8
	mov pc, w
	jmp next

;;; return from colon word
w_exit:
	dq w_docol
	db "exit", 0
	db 0 			; Flags = 0
xt_exit:
	dq i_exit
i_exit:
	mov pc, [rstack]
	add rstack, 8
	jmp next

;;; fetch word
w_word:
	dq w_exit
	db "word", 0
	db 0 			; Flags = 0
xt_word:
	dq i_word
i_word:
	pop rdi
	call read_word
	push rdx
	jmp next

;;; print char
w_prints:
	dq w_word
	db "prints", 0
	db 0 			; Flags = 0
xt_prints:
	dq i_prints
i_prints:
	pop rdi
	call print_string
	jmp next

;;; terminate program
w_bye:	
	dq w_prints
	db "bye", 0
	db 0 			; Flags = 0
xt_bye:
	dq i_bye
i_bye:
	mov rax, 60
	xor rdi, rdi
	syscall
	
;;; load bufaddr
w_inbuf:
	dq w_bye
	db "inbuf", 0
	db 0 			; Flags = 0
xt_inbuf:
	dq i_inbuf
i_inbuf:
	push qword input_buf
	jmp next

;;; main
w_main:
	dq w_inbuf
	db "main", 0
	db 0 			; Flags = 0
xt_main:
	dq i_docol
	dq xt_inbuf
	dq xt_word
	dq xt_drop
	dq xt_inbuf
	dq xt_prints
	dq xt_bye

;;; internal interpreter
next:
	mov w, [pc]
	add pc, 8
	jmp [w]

_start:	jmp i_init
