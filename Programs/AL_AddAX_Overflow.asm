bits 16
start:
	mov ax, 00FFh
	add ax, 1
stop:
	jmp stop
