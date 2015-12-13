;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CURSOR FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_cursor:
	pusha

	mov bh, 0
	mov ah, 2
	int 10h				; BIOS interrupt to move cursor

	popa
	ret

; Gets the cursor position
get_curs_pos:
	mov ah, 03h
	int 10h
	ret

; Moves the cursor once to the right
move_curs_right:
	call get_curs_pos

	mov ah, 02h
	add dl, 1 ; adds one to the value retrieved from get_curs_pos
	int 10h

	ret

; Moves the cursor once to the left
move_curs_left:
	call get_curs_pos

	mov ah, 02h
	sub dl, 1 ; subtracts one to the value retrieved from get_curs_pos
	int 10h

	ret


; Moves the cursor once up
move_curs_up:
	call get_curs_pos

	mov ah, 02h
	sub dh, 1 ; subtracts one to the value retrieved from get_curs_pos
	int 10h

	ret

; Moves the cursor once down
move_curs_down:
	call get_curs_pos

	mov ah, 02h
	add dh, 1 ; adds one to the value retrieved from get_curs_pos
	int 10h

	ret

; ------------------------------------------------------------------
; show_cursor -- Turns on cursor in text mode
; IN/OUT: Nothing

show_cursor:
	pusha

	mov ch, 6
	mov cl, 7
	mov ah, 1
	mov al, 3
	int 10h

	popa
	ret


; ------------------------------------------------------------------
; hide_cursor -- Turns off cursor in text mode
; IN/OUT: Nothing

hide_cursor:
	pusha

	mov ch, 32
	mov ah, 1
	mov al, 3			; Must be video mode for buggy BIOSes!
	int 10h

	popa
	ret