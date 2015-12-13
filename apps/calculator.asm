app_calculator:
	call app_exit
; 	popa
; 	call clear_screen

; 	mov di, input			; Clear input buffer each time
; 	mov al, 0
; 	mov cx, 256
; 	rep stosb

; 	mov di, command			; And single command buffer
; 	mov cx, 32
; 	rep stosb

; 	mov ax, input			; Get command string from user
; 	call input_string




; input			times 256 db 0
; command			times 32 db 0