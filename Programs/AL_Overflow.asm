bits 16
start:
	mov ax, 00FFh
	add al, 1

stop:
	jmp stop
