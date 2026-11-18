ORG 0100h
BITS 16

; The goal of the program is to take a pointer form DI, then store one from word from UART in that memory address.

; Used to initialize I/O port and push elements to stack. Since the program should be general purpose, the stack location will not be changed. At DI, the word is stored as [first RX][second RX]
.INIT:
	push ax			; Used regs are stored in stack
	push cx
	push dx
	push di

	xor ax, ax
	xor cx, cx
	xor dx, dx
	
	mov dx, 0xFFF2		; Status port location

CONSUME_AND_STORE:
	mov cx, 2		; UART holds a byte at a time, so we must track how many bytes were read

	.loop:
	in ax, dx
	test ax, 0x02
	jz .loop

	mov dx, 0xFFF0		; UART read/write location
	in ax, dx
	mov [di], ax
	inc di
	mov dx, 0xFFF2
	loop .loop

.restore:			; Restore the last help registers
	pop di
	pop dx
	pop cx
	pop ax

.end:
	int 2
