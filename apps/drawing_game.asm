;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DRAWING GAME FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instructs db 'w = cursor up,s = cursor down,a = cursor right,d = cursor down,,Press enter to start,Press esc to exit', 0
title db  '  ______ _                      _        ______           _ , / _____) |            _       | |      (_____ \         | |,( (____ | |  _ _____ _| |_ ____| |__     _____) )____  __| |, \____ \| |_/ ) ___ (_   _) ___)  _ \   |  ____(____ |/ _  |, _____) )  _ (| ____| | |( (___| | | |  | |    / ___ ( (_| |,(______/|_| \_)_____)  \__)____)_| |_|  |_|    \_____|\____|,                                                            ', 0

app_drawing_game:
	pusha

	call app_drawing_game_reset

jmp $

; ------------------------------------------------------------------
; app_drawing_game_wait_for_start -- Waits for game session to start
app_drawing_game_wait_for_start:
	call wait_for_key

	cmp al, 13		; if key pressed is enter
		je app_drawing_game_start
	cmp al, 27		; if key pressed is esc
		je app_drawing_game_exit

	call app_drawing_game_wait_for_start

; ------------------------------------------------------------------
; app_drawing_game_start -- Starts game session
app_drawing_game_start:
	call show_cursor
	jmp .clear

	.watch_keys:
		call wait_for_key

		cmp al, 64h		; if key pressed is d
			je .move_right
		cmp al, 61h		; if key pressed is a
			je .move_left
		cmp al, 73h		; if key pressed is s
			je .move_down
		cmp al, 77h		; if key pressed is w
			je .move_up
		cmp al, 13		; if key pressed is enter
			je app_drawing_game_reset

		jmp .watch_keys

		.move_right:
			mov al, '-'
			call move_curs_right
			call .draw

		.move_left:
			mov al, '-'
			call move_curs_left
			call .draw

		.move_down:
			mov al, '|'
			call move_curs_down
			call .draw

		.move_up:
			mov al, '|'
			call move_curs_up
			call .draw

		.draw:
			call print_key

			jmp .watch_keys

		.clear:
			call app_drawing_game_clear
			jmp .watch_keys

; ------------------------------------------------------------------
; app_drawing_game_exit -- Exit app
app_drawing_game_exit:
	popa
	call app_exit

; ------------------------------------------------------------------
; app_drawing_game_reset -- Resets screen
app_drawing_game_reset:
	call hide_cursor
	call app_drawing_game_clear
	call app_drawing_game_show_title
	call app_drawing_game_show_instructions

	call app_drawing_game_wait_for_start

	ret

app_drawing_game_clear:
	call clear_screen

	mov bx, 01110001b	; Dark blue on black
	call set_background_color

	ret

; ------------------------------------------------------------------
; app_drawing_game_show_title -- Draw title
app_drawing_game_show_title:
	mov si, title
	mov dl, 2
	mov dh, 2
	call move_cursor
	
	.display_title:
		lodsb

		cmp al, 0
		je .done

		cmp al, ','
		je .new_line

		mov ah, 0Eh
		int 10h
		jmp .display_title

	.new_line:
		mov dl, 2
		inc dh
		call move_cursor

		jmp .display_title

	.done:
		ret

; ------------------------------------------------------------------
; app_drawing_game_show_instructions -- Draw instructions
app_drawing_game_show_instructions:
	mov si, instructs
	mov dl, 2
	inc dh
	call move_cursor
	
	.display_instructs:
		lodsb

		cmp al, 0
		je .done

		cmp al, ','
		je .new_line

		mov ah, 0Eh
		int 10h
		jmp .display_instructs

	.new_line:
		mov dl, 2
		inc dh
		call move_cursor

		jmp .display_instructs

	.done:
		ret