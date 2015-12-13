app_calculator:
	popa
	call clear_screen

	call monitor_keys

monitor_keys:
	mov bx, 0	; Starting number
	mov cx, 0	; Count the number of digits we enter
	mov dx, 0	; Store our string

	.wait_for_correct:
		call wait_for_key	

		; Figure out if a number or operation key was pressed
		; 48-57 are number keys
		cmp al, 48
			jl check_if_operation
		cmp al, 57
			jg check_if_operation

		call print_number

		; mov [input_buffer], dh
		; mov si, input_buffer
		; call print_string

		; add bl, al
		; cmp bl, 10
		; 	jge .carry_remainder

		; jmp .print_result

; .print_result:
; 		mov dx, bx

; 		add dh, 48
; 		mov [input_buffer], dh
; 		mov si, input_buffer
; 		call print_string

		; .print_result

		; push ax
		; mov al, 10
		; mul bl					; Move over digit
		; pop ax

		; add bl, 48
		; mov [input_buffer], bl 	; Store ASCII character
		; sub bl, 48
		; mov si, input_buffer
		; call print_string

		; mov [input_buffer], al 	; Store ASCII character
		; sub al, 48				; Get real number
		; add bl, al				; Add new digit
		; inc cx					; We added a new digit

		; add bl, 48
		; mov [input_buffer], bl 	; Store ASCII character
		; sub bl, 48
		; mov si, input_buffer
		; call print_string

		; If we make it here a number key was pressed

		; Store pressed key
		; mov byte [input_buffer], al
		; inc [input_buffer]



		jmp .wait_for_correct

		input_buffer: resb 255

	.carry_remainder:
		add bh, 1
		sub bl, 10

	ret

; ------------------------------------------------------------------
; print_number -- Print the key we entered
; IN: AL = key
print_number:
	push cx

	mov cl, al
	add cl, 48

	push ax
	mov al, cl
	mov cx, 1
	call move_curs_right
	call print_key

	pop ax
	pop cx

	ret

; ------------------------------------------------------------------
; check_if_operation -- Check if key calls for an operation to be performed
; IN: AL = key

check_if_operation:
	cmp al, 42 ; Multiply
		je .do_multiplication
	cmp al, 43 ; Add
		je .do_addition
	cmp al, 45 ; Subtract
		je .do_subtraction
	cmp al, 47 ; Divide
		je .do_division
	cmp al, 61 ; Equals
		je .do_equals

	call monitor_keys

	.do_multiplication:
		ret
		
	.do_addition:
		ret
		
	.do_subtraction:
		ret
		
	.do_division:
		ret
		
	.do_equals:
		mov [input_buffer], bl
		mov si, input_buffer
		call print_string

	ret

; read_input:
; 	pusha
; 	mov dx, 255
; 	mov cx, input
; 	mov bx, 0
; 	mov ax, 3
; 	int 80h

; 	mov si, input
; 	call print_string

; 	popa
; 	ret


.exit:
	pusha
	ret