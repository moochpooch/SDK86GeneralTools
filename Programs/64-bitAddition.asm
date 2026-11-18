ORG 0100h
BITS 16

; Goal is to add two 64 bit numbers using memory and functions provided in x86. The result will be stored in the A register, but an additional OF byte is written to in case of large of overflow.
INIT:
	mov word [ALO0], 0xFFFF
	mov word [ALO1], 0xFFFF
	mov word [AHI0], 0xFFFF
	mov word [AHI1], 0xFFFF

	mov word [BLO0], 0xFFFF
	mov word [BLO1], 0xFFFF
	mov word [BHI0], 0xFFFF
	mov word [BHI1], 0xFFFF

	mov byte [OF], 0xFF

_64BITADDITION:
	mov ax, [ALO0]
	mov bx, [BLO0]
	add ax, bx
	mov [ALO0], ax

	mov ax, [ALO1]
	mov bx, [BLO1]
	adc ax, bx
	mov [ALO1], ax

	mov ax, [AHI0]
	mov bx, [BHI0]
	adc ax, bx
	mov [AHI0], ax

	mov ax, [AHI1]
	mov bx, [BHI1]
	adc ax, bx
	mov [AHI1], ax

	adc [OF], 0

	int 2

MEM_REGS:
	ALO0 dw 0
	ALO1 dw 0
	AHI0 dw 0
	AHI1 dw 0

	BLO0 dw 0
	BLO1 dw 0
	BHI0 dw 0
	BHI1 dw 0

	OF db 0
