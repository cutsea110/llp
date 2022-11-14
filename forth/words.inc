	; ( a -- )
	native "drop", drop
	add rsp, 8
	jmp next


	; ( a b -- b a )
	native "swap", swap
	pop rax
	pop rdx
	push rax
	push rdx
	jmp next

	; ( a -- a a )
	native "dup", dup
	push qword[rsp]
	jmp next

	; ( a b c -- b c a )
	native "rot", rot
	pop rcx
	pop rdx
	pop rax
	push rdx
	push rcx
	push rax
	jmp next

	; ( y x -- [ x + y ] )
	native "+", plus
	pop rax
	add [rsp], rax
	jmp next

	; ( y x -- [ x * y ] )
	native "*", mul
	pop rax
	pop rdx
	imul rdx
	push rax
	jmp next

	; ( y x -- [ x / y ] )
	native "/", div
	pop rcx
	pop rax
	cqo
	idiv rcx
	push rax
	jmp next

	; ( y x -- [ x mod y ] )
	native "/", mod
	pop rcx
	pop rax
	cqo
	idiv rcx
	push rdx
	jmp next

	; ( y x -- [ x - y ] )
	native "-", sub
	pop rax
	sub [rsp], rax
	jmp next

	; ( a -- a' )
	; a' = 0 if a != 0
	; a' = 1 if a == 0
	native "not", not
	pop rax
	test rax, rax
	setz al
	movzx rax, al
	push rax
	jmp next

	; ( a b -- c )
	; c = 1 if a == b
	; c = 0 if a != b
	native "=", eq
	pop rax
	pop rdx
	cmp rax, rdx
	sete al
	movzx rax, al
	push rax
	jmp next

	; ( str -- len )
	native "len", len
	pop rdi
	call string_length
	push rax
	jmp next

	; ( n -- ) ;; send n to stdout
	native ".", dot
	pop rdi
	call print_int
	call print_newline
	jmp next

	; show stack contents
	native ".S", show_stack
	mov rcx, rsp
.loop:
	cmp rcx, [stack_base]
	jae next
	mov rdi, [rcx]
	push rcx
	call print_int
	call print_newline
	pop rcx
	add rcx, 8
	jmp .loop


section .rodata
interpreter_stub: dq xt_interpreter

section .data
stack_base: dq 0

	; stores the data stack base. it is useful for .S
	native "init", init
	mov qword[state], 0
	mov rstack, rstack_start
	mov pc, interpreter_stub
	cmp qword[stack_base], 0
	je .first
	mov rsp, [stack_base]
	jmp next
.first:
	mov [stack_base], rsp
	jmp next


	; this is the implementation of any colon-word.
	; the XT itself is not used, but the implementation (i_docol) is.
	native "docol", docol
	rpush pc
	add w, 8
	mov pc, w
	jmp next

	; exit from colon-word.
	native "exit", exit
	rpop pc
	jmp next

	; pop from data stack into rstack
	native ">r", to_r
	pop rax
	rpush rax
	jmp next

	; push from rstack into data stack
	rpop rax
	push rax
	jmp next

	; non-destructive copy from the top of rstack to the top of data stack
	native "r@", r_fetch.
	push qword[rstack]
	jmp next

	colon "const", const

	; ( str -- header_addr )
	native "find", find
	mov rsi, [last_word]
.loop:
	mov rdi, [rsp]
	push rsi
	add rsi, 9
	call string_equals
	pop rsi
	test rax, rax
	jnz .found

	mov rsi, [rsi]
	test rsi, rsi
	jnz .loop
.not_found:
	mov qword[rsp], 0
	push 0
	jmp next
.found:
	mov [rsp], rsi
	jmp next


	; ( word_addr -- xt )
	; converts word header start address to the execution token
	native "cfa", cfa
	pop rsi
	add rsi, 9
.loop:
	mov al, [rsi]
	test al, al
	jz .end
	inc rsi
	jmp .loop

.end:
	add rsi, 2
	push rsi
	jmp next

	; ( c -- )
	; outputs a single char to stdout
	native "emit", emit
	pop rdi
	call print_char
	jmp next

	; ( addr -- len )
	; reads word from stdin and stores it starting at address
	; word length is pushed into stack
	native "word", word
	pop rdi
	call read_word
	push rdx
	jmp next

	; ( str -- len num )
	; parse an integer from string
	native "num", num
	pop rdi
	call parse_int
	push rax
	push rdx
	jmp next

	; ( addr -- )
	; prints a null-terminated string
	native "prints", prints
	pop rdi
	call print_string
	jmp next

	; exits forth
	native "bye", bye
	mov rax, 60
	xor rdi, rdi
	syscall

	; ( call_num a1 a2 a3 a4 a5 a6 -- new_rax )
	; execute system call
	; the following registers store arguments (according to ABI)
	; rdi, rsi, rdx, r10, r8, r9
	native "syscall", syscall
	pop r9
	pop r8
	pop r10
	pop rdx
	pop rsi
	pop rdi
	pop rax
	syscall
	push rax
	jmp next

