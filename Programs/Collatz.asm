org 0100h

bits 16
start:
    ; Initial clear display.
	mov dx, 0FFEAH
	mov al, 11010001b
	out dx, al

    push cs
    pop ds              ; make DS point at this code/data segment

    mov cx, 500         ; current Collatz value
    mov si, trace       ; SI points at next trace slot
    mov word [steps], 0
    mov word [status], 0

main:
    ; Save the current value before changing it.
    cmp si, trace_end
    jae trace_full

    mov [si], cx
    add si, 2           ; each trace entry is a word
    inc word [steps]

    cmp cx, 1
    je finished

    ; Divide CX by 2.
    mov ax, cx
    mov bx, 2
    xor dx, dx
    div bx              ; AX = CX / 2, DX = CX % 2

    test dx, dx
    jz even

    ; Odd: CX = 3 * CX + 1
    mov ax, cx
    mov bx, 3
    mul bx              ; DX:AX = CX * 3

    or dx, dx
    jnz overflow        ; product did not fit in 16 bits

    add ax, 1
    jc overflow         ; result wrapped from FFFFh to 0000h

    mov cx, ax
    jmp main

even:
    ; AX already contains CX / 2.
    mov cx, ax
    jmp main

finished:
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
    mov word [status], 1
	int 2

trace_full:
    mov word [status], 2
    jmp $

overflow:
    mov word [status], 3
    jmp $

delay:
    push cx
	mov cx, 48
.wait:
	loop .wait
    pop cx
	ret

; Data lives after the endless loops, so execution never falls into it.
; test dw
trace:
    times 128 dw 0
trace_end:

steps:
    dw 0

status:
    dw 0
