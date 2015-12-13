; strings
menu db 'MENU', 0
options db 'Sketch Pad,Option 2,Option 3,Option 4,Option 5', 0

; ------------------------------------------------------------------
; draw_menu -- Render menu
draw_menu:
	call clear_screen
	mov cx, 0 			; Scrolling starts at index 0

.draw_ui:
	pusha

	mov bx, 10010000b
	call set_background_color

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

	; Print title
	mov dl, 37
	mov dh, 7
	call move_cursor
	mov si, menu
	call print_string

	popa

.print_scrollbar:
	call get_menu_defaults
	call draw_scrollbar

call print_options

.watch_keys
	call wait_for_key

	cmp ah, 48h			; Up pressed?
		je .scroll_up
	cmp ah, 50h			; Down pressed?
		je .scroll_down
	cmp al, 13			; Enter pressed?
		je .option_selected
	cmp al, 27			; Esc pressed?
		je .menu_exit
	
	jmp .watch_keys		; If not, wait for another key

.scroll_to_top:
	call remove_scrollbar

	mov cx, 0				; Set scroll index to 0
	call get_menu_defaults	; Get starting positions
	call draw_scrollbar

	call print_options

	jmp .watch_keys

.scroll_to_bottom:
	call remove_scrollbar

	mov cx, bx				; Set scroll index to 0
	call get_menu_defaults	; Get starting positions
	add dh, cl
	add di, cx
	call draw_scrollbar

	call print_options

	jmp .watch_keys

.scroll_up:
	; If we are already at the top move to the bottom
	cmp cx, 0
	je .scroll_to_bottom

	; Hide previous scroll bar
	call remove_scrollbar

	; Draw new one
	dec cx

	call get_menu_defaults	; Ensure we are always adding to the original values
	add dh, cl
	add di, cx
	call draw_scrollbar

	call print_options

	jmp .watch_keys

.scroll_down:
	; If we are already at the bottom move to the top
	cmp cx, bx
	je .scroll_to_top

	; Hide previous scroll bar
	call remove_scrollbar

	; Draw new one
	inc cx

	call get_menu_defaults	; Ensure we are always adding to the original values
	add dh, cl
	add di, cx
	call draw_scrollbar

	call print_options

	jmp .watch_keys

.option_selected:
	cmp cx, 0
		je app_drawing_game
	; cmp cx, 1
	; 	je app_calculator

	jmp .watch_keys

.menu_exit:
	jmp .watch_keys

	jmp $

; ------------------------------------------------------------------
; draw_scrollbar -- Draw scrollbar
; IN: DH/DI = staring Y pos/ending Y pos
draw_scrollbar:
	push bx

	mov bl, 10011111b	; White on light blue
	mov dl, 21			; Starting X pos
	mov si, 38			; Ending X pos
	call draw_block

	pop bx
	ret

; ------------------------------------------------------------------
; remove_scrollbar -- Remove scrollbar
; IN: DH/DI = staring Y pos/ending Y pos
remove_scrollbar:
	push bx

	call get_menu_defaults
	add dh, cl
	add di, cx

	mov bl, 01111000b	; Dark gray on white
	mov dl, 21			; Starting X pos
	mov si, 38			; Ending X pos
	call draw_block

	pop bx
	ret

; ------------------------------------------------------------------
; get_menu_defaults -- Gets the default values for our menu
; OUT: DL/DH/DI = starting X pos/starting Y pos/ending Y pos
get_menu_defaults:
	mov dl, 22			; Starting X Pos
	mov dh, 9			; Starting Y Pos
	mov di, 10			; Ending Y Pos

	ret

; ------------------------------------------------------------------
; print_options -- Prints the menu's options
print_options:
	mov bx, 0					; Count num of options
	mov si, options

	call get_menu_defaults
	call move_cursor

.print_option:
	lodsb

	cmp al, 0
	je .done

	cmp al, ','
	je .new_line

	mov ah, 0Eh
	int 10h
	jmp .print_option

.new_line:
	inc bx

	mov dl, 22
	inc dh
	call move_cursor

	jmp .print_option

.done:
	ret