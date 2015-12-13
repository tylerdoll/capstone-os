%INCLUDE "includes/assets/menu.asm"

; ------------------------------------------------------------------
; draw_dialog -- Render dialog box with button
; IN: AX = title

draw_dialog:
	push ax
	push bx
	push cx

	; border
	mov bl, 11111000b	; Dark gray on white
	mov dl, 20			; Start X position
	mov dh, 6			; Start Y position
	mov si, 40			; Width
	mov di, 18			; Finish Y position
	call draw_block

	; background
	mov bl, 01111000b	; Dark gray on white
	mov dl, 21			; Start X position
	mov dh, 9			; Start Y position
	mov si, 38			; Width
	mov di, 17			; Finish Y position
	call draw_block

	; Print line 2
	mov dl, 30
	mov dh, 13
	call move_cursor
	pop cx
	mov si, cx
	call print_string

	; Print line 1
	mov dl, 35
	mov dh, 11
	call move_cursor
	pop bx
	mov si, bx
	call print_string

	; Print title
	mov dl, 37
	mov dh, 7
	call move_cursor
	pop ax
	mov si, ax
	call print_string

	; draw continue button
	mov bl, 10011111b
	mov dl, 34
	mov dh, 15
	mov si, 12			; Width
	mov di, 16			; Finish Y position
	call draw_block
	mov si, button_continue
	call print_string

	jmp .continue

	ret

.continue:
	call wait_for_key

	; if enter is pressed
	cmp al, 13
		je draw_menu
	; else
		jmp .continue

;--------
; Strings
	
button_continue db '  CONTINUE  ', 0	; LENGTH = 12	

; ------------------------------------------------------------------
; draw_block -- Render block of specified colour
; IN: BL/DL/DH/SI/DI = colour/start X pos/start Y pos/width/finish Y pos

draw_block:
	pusha

.more:
	call move_cursor		; Move to block starting position

	mov ah, 09h			; Draw colour section
	mov bh, 0
	mov cx, si
	mov al, ' '
	int 10h

	inc dh				; Get ready for next line

	mov ax, 0
	mov al, dh			; Get current Y position into DL
	cmp ax, di			; Reached finishing point (DI)?
	jne .more			; If not, keep drawing

	popa
	ret