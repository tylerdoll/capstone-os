; ------------------------------------------------------------------
; get_string_length -- Return length of a string
; IN: AX = string location
; OUT AX = length (other regs preserved)

get_string_length:
	pusha

	mov bx, ax			; Move location of string to BX

	mov cx, 0			; Counter

.more:
	cmp byte [bx], 0		; Zero (end of string) yet?
	je .done
	inc bx				; If not, keep adding
	inc cx
	jmp .more


.done:
	mov word [.tmp_counter], cx	; Store count before restoring other registers
	popa

	mov ax, [.tmp_counter]		; Put count back into AX before returning
	ret


	.tmp_counter	dw 0