ORG 0100
bits 16
start:
	mov ax, 00FFh
	add al, 1
	adc ah, 0
stop:
	jmp stop
