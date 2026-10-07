org 0100h
bits 16

start:
	; Clear display.
	mov dx, 0FFEAH
	mov al, 11010001b
	out dx, al

	; Wait for mandatory clear before writing into ram.
	call delay

	; Write display, auto increment enabled.
	mov al, 10010000b
	out dx, al

	; Store the segment pattern for “E” at RAM address 0.
	mov dx, 0FFE8H
	mov ax, 00079H
	out dx, ax

	; Store the segment pattern for "n",.
	mov ax, 00054h
	out dx, ax

	; Store the segment pattern for "O".
	mov ax, 0003Fh
	out dx, ax

	; Store the segment pattern for "D".
	mov ax, 0005Eh
	out dx, ax
stop:
	int 2

delay:
	mov cx, 48
.wait:
	loop .wait
	ret


