bits 16
start:
	mov ax, 1234h
	mov ah, 0FFh
	mov al, 0ABh
stop:
	jmp stop
