; ==================================================================
; CapstoneOS -- The Capstone Operating System kernel
;
; This is loaded from the drive by BOOTLOAD.BIN, as KERNEL.BIN.
; First we have the system call vectors, which start at a static point
; for programs to use. Following that is the main kernel code and
; then additional system call code is included.
; ==================================================================


	BITS 16

	%DEFINE CAPSTONEOS_VER '1'		; OS version number
	%DEFINE CAPSTONEOS_API_VER 1	; API version for programs to check


	; This is the location in RAM for kernel disk operations, 24K
	; after the point where the kernel has loaded; it's 8K in size,
	; because external programs load after it at the 32K point:

	disk_buffer	equ	24576
; in the kernel source code...

call_vectors:
	jmp main			; 0000h -- Called from bootloader


; ------------------------------------------------------------------
; START OF MAIN KERNEL CODE

main:
	cli				; Clear interrupts
	mov ax, 0
	mov ss, ax			; Set stack segment and pointer
	mov sp, 0FFFFh
	sti				; Restore interrupts

	cld				; The default direction for string operations
					; will be 'up' - incrementing address in RAM

	mov ax, 2000h			; Set all segments to match where kernel is loaded
	mov ds, ax			; After this, we don't need to bother with
	mov es, ax			; segments ever again, as MikeOS and its programs
	mov fs, ax			; live entirely in 64K
	mov gs, ax

	cmp dl, 0
	je no_change
	mov [bootdev], dl		; Save boot device number
	push es
	mov ah, 8			; Get drive parameters
	int 13h
	pop es
	and cx, 3Fh			; Maximum sector number
	mov [SecsPerTrack], cx		; Sector numbers start at 1
	movzx dx, dh			; Maximum head number
	add dx, 1			; Head numbers start at 0 - add 1 for total
	mov [Sides], dx

no_change:
	mov ax, 1003h			; Set text output with certain attributes
	mov bx, 0			; to be bright, and not blinking
	int 10h

	; call os_seed_random		; Seed random number generator

	; Begin OS run

	call clear_screen
	call hide_cursor

	mov bx, 10010000b
	call set_background_color

	; Draw welcome dialog
	mov ax, str_welcome
	mov bx, str_title
	mov cx, str_created_by
	call draw_dialog

	jmp $			; Jump here - infinite loop!

	; String defs
	str_new_line db 0dh, 0ah, 0
	str_title db 'Capstone OS', 0
	str_created_by db 'Created by Tyler Doll', 0
	str_welcome db 'WELCOME', 0
	

app_exit:
	call draw_menu

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
	push cx
	
	mov ah, 09h ; prints key to screen
	mov cx, 1 ; only prints the key once
	int 10h

	pop cx
	ret


; ------------------------------------------------------------------
; SYSTEM VARIABLES -- Settings for programs and system calls


	; Time and date formatting

	fmt_12_24	db 0		; Non-zero = 24-hr format

	fmt_date	db 0, '/'	; 0, 1, 2 = M/D/Y, D/M/Y or Y/M/D
					; Bit 7 = use name for months
					; If bit 7 = 0, second byte = separator character

; ------------------------------------------------------------------
; DISK VARIABLES -- Settings for programs and system calls

; ******************************************************************
	mov dl, [bootdev]		; Set correct device
; ******************************************************************

	ret


	Sides dw 2
	SecsPerTrack dw 18
; ******************************************************************
	bootdev db 0			; Boot device number
; ******************************************************************


; ------------------------------------------------------------------
; INCLUDES -- Code to pull into the kernel

	%INCLUDE "apps/calculator.asm"
	%INCLUDE "apps/drawing_game.asm"

	%INCLUDE "includes/cursor.asm"
	%INCLUDE "includes/drawing.asm"
	%INCLUDE "includes/screen.asm"
	%INCLUDE "includes/string.asm"


; ==================================================================
; END OF KERNEL
; ==================================================================

