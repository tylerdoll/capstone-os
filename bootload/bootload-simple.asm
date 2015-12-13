	BITS 16


; Line Break = 0ah
; Carraige Return = 0dh

start:
	; Setup OS
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax

	; Begin OS run

	call clear_screen
	call hide_cursor

	; Draw OS
	mov ax, str_title
	mov bx, str_created_by
	call draw_frame

	mov ax, str_welcome
	mov bx, str_title
	mov cx, str_created_by
	call draw_menu



	; call show_welcome
	; call request_login
	;call show_welcome
	;call show_instruct
	;call get_key

	jmp $			; Jump here - infinite loop!

	; String defs
	str_new_line db 0dh, 0ah, 0
	str_title db 'Simple OS Alpha Build 0.1', 0
	str_created_by db 'Created by Tyler Doll', 0
	str_welcome db 'WELCOME', 0
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; KEYBOARD FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ------------------------------------------------------------------
; wait_for_key -- Waits for keypress and returns key
; IN: Nothing; OUT: AX = key pressed, other regs preserved

wait_for_key:
	pusha

	mov ax, 0
	mov ah, 10h			; BIOS call to wait for key
	int 16h

	mov [.tmp_buf], ax		; Store resulting keypress

	popa				; But restore all other regs
	mov ax, [.tmp_buf]
	ret


	.tmp_buf	dw 0

; Gets the key that is pressed and displays it
; get_key:
; 	mov ah, 01h ; Checks status of keyboard
; 	int 16h
; 	; if key is not pressed
; 		je get_key ; loops until key is found
; 	; else if key is pressed
; 		mov ah, 00h ; reads key if pressed
; 		int 16h
; 		ret

; Print key to screen
print_key:
	mov ah, 09h ; prints key to screen
	mov cx, 1 ; only prints the key once
	mov bl, 09h ; makes text light blue
	int 10h
	ret

; Prints key and moves cursor to the right
; type_key:
; 	call print_key
; 	call move_curs_right
; 	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WELCOME FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OUTPUT FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


%INCLUDE "../includes/cursor.asm"
%INCLUDE "../includes/drawing.asm"
%INCLUDE "../includes/screen.asm"
%INCLUDE "../includes/string.asm"

; End OS

	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature