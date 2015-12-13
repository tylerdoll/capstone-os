load_calculator:
	popa
	call clear_screen

	mov bl, 00001010b	; bg: black - fg: light green
	call set_background_color

	call draw_calculator

	call monitor_keys

monitor_keys:
	.wait_for_correct:
		call get_key

		; Pressed 1
		cmp al, 49
		je do_addtion

		; Pressed 2
		cmp al, 50
		je do_subtraction

		; Pressed 3
		cmp al, 51
		je do_multiplication

		; Pressed 4
		cmp al, 52
		je do_division

		jmp .wait_for_correct

	ret

do_addtion:
	mov si, addition
	ret

do_subtraction:
	ret

do_multiplication:
	ret

do_division:
	ret

draw_calculator:
	; Draw title
	mov dl, 16
	mov dh, 0
	call move_cursor
	mov si, calculator_1
	call print_string
	mov dl, 16
	mov dh, 1
	call move_cursor
	mov si, calculator_2
	call print_string
	mov dl, 16
	mov dh, 2
	call move_cursor
	mov si, calculator_3
	call print_string

	; Draw addition
	mov dl, 1
	mov dh, 4
	call move_cursor
	mov si, addition_1
	call print_string
	mov dl, 1
	mov dh, 5
	call move_cursor
	mov si, addition_2
	call print_string
	mov dl, 1
	mov dh, 6
	call move_cursor
	mov si, addition_3
	call print_string
	mov dl, 1
	mov dh, 7
	call move_cursor
	mov si, addition_4
	call print_string
	mov dl, 1
	mov dh, 8
	call move_cursor
	mov si, addition_5
	call print_string

	; Draw subtraction
	mov dl, 1
	mov dh, 9
	call move_cursor
	mov si, subtraction_1
	call print_string
	mov dl, 1
	mov dh, 10
	call move_cursor
	mov si, subtraction_2
	call print_string
	mov dl, 1
	mov dh, 11
	call move_cursor
	mov si, subtraction_3
	call print_string
	mov dl, 1
	mov dh, 12
	call move_cursor
	mov si, subtraction_4
	call print_string
	mov dl, 1
	mov dh, 13
	call move_cursor
	mov si, subtraction_5
	call print_string

	; Draw multiplication
	mov dl, 1
	mov dh, 14
	call move_cursor
	mov si, multiplication_1
	call print_string
	mov dl, 1
	mov dh, 15
	call move_cursor
	mov si, multiplication_2
	call print_string
	mov dl, 1
	mov dh, 16
	call move_cursor
	mov si, multiplication_3
	call print_string
	mov dl, 1
	mov dh, 17
	call move_cursor
	mov si, multiplication_4
	call print_string
	mov dl, 1
	mov dh, 18
	call move_cursor
	mov si, multiplication_5
	call print_string

	; Draw division
	mov dl, 1
	mov dh, 19
	call move_cursor
	mov si, division_1
	call print_string
	mov dl, 1
	mov dh, 20
	call move_cursor
	mov si, division_2
	call print_string
	mov dl, 1
	mov dh, 21
	call move_cursor
	mov si, division_3
	call print_string
	mov dl, 1
	mov dh, 22
	call move_cursor
	mov si, division_4
	call print_string
	mov dl, 1
	mov dh, 23
	call move_cursor
	mov si, division_5
	call print_string

	; Draw instructions
	mov dl, 11
	mov dh, 5
	call move_cursor
	mov si, press1_1
	call print_string
	mov dl, 11
	mov dh, 6
	call move_cursor
	mov si, press1_2
	call print_string
	mov dl, 11
	mov dh, 7
	call move_cursor
	mov si, press1_3
	call print_string

	mov dl, 11
	mov dh, 10
	call move_cursor
	mov si, press2_1
	call print_string
	mov dl, 11
	mov dh, 11
	call move_cursor
	mov si, press2_2
	call print_string
	mov dl, 11
	mov dh, 12
	call move_cursor
	mov si, press2_3
	call print_string

	mov dl, 11
	mov dh, 15
	call move_cursor
	mov si, press3_1
	call print_string
	mov dl, 11
	mov dh, 16
	call move_cursor
	mov si, press3_2
	call print_string
	mov dl, 11
	mov dh, 17
	call move_cursor
	mov si, press3_3
	call print_string

	mov dl, 11
	mov dh, 20
	call move_cursor
	mov si, press4_1
	call print_string
	mov dl, 11
	mov dh, 21
	call move_cursor
	mov si, press4_2
	call print_string
	mov dl, 11
	mov dh, 22
	call move_cursor
	mov si, press4_3
	call print_string

	calculator_1 db '____ ____ _    ____ _  _ _    ____ ___ ____ ____', 0
	calculator_2 db '|    |__| |    |    |  | |    |__|  |  |  | |__/', 0
	calculator_3 db '|___ |  | |___ |___ |__| |___ |  |  |  |__| |  \', 0

	addition_1 db ' _______', 0
	addition_2 db '|       |', 0
	addition_3 db '| __|__ |', 0
	addition_4 db '|   |   |', 0
	addition_5 db '|_______|', 0

	subtraction_1 db ' _______', 0
	subtraction_2 db '|       |', 0
	subtraction_3 db '| _____ |', 0
	subtraction_4 db '|       |', 0
	subtraction_5 db '|_______|', 0

	multiplication_1 db ' _______', 0
	multiplication_2 db '|       |', 0
	multiplication_3 db '|  \ /  |', 0
	multiplication_4 db '|  / \  |', 0
	multiplication_5 db '|_______|', 0

	division_1 db ' _______', 0
	division_2 db '|       |', 0
	division_3 db '|    /  |', 0
	division_4 db '|  /    |', 0
	division_5 db '|_______|', 0

	press1_1 db '___  ____ ____ ____ ____    ____ _  _ ____', 0
	press1_2 db '|__] |__/ |___ [__  [__     |  | |\ | |___', 0
	press1_3 db '|    |  \ |___ ___] ___]    |__| | \| |___', 0

	press2_1 db '___  ____ ____ ____ ____    ___ _ _ _ ____', 0
	press2_2 db '|__] |__/ |___ [__  [__      |  | | | |  |', 0
	press2_3 db '|    |  \ |___ ___] ___]     |  |_|_| |__|', 0

	press3_1 db '___  ____ ____ ____ ____    ___ _  _ ____ ____ ____', 0
	press3_2 db '|__] |__/ |___ [__  [__      |  |__| |__/ |___ |___', 0
	press3_3 db '|    |  \ |___ ___] ___]     |  |  | |  \ |___ |___', 0

	press4_1 db '___  ____ ____ ____ ____    ____ ____ _  _ ____', 0
	press4_2 db '|__] |__/ |___ [__  [__     |___ |  | |  | |__/', 0
	press4_3 db '|    |  \ |___ ___] ___]    |    |__| |__| |  \', 0
	ret

.exit:
	pusha
	ret