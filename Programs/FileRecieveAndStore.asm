ORG 0100h
CPU 8086
BITS 16

; The goal of the program is to accept a specific byte sequence from serial, then take a command, an address, and write a file in 64 byte sequences to the specified location with checksums every internval.

; No fallback or timeout during CONSUME_AND_STORE
TEST:
	mov ax, 0x0400
	push ax
	call MAIN
	add sp, 2
	int 2

MAIN:				; One argument, SI, push to stack before call
.INIT:
	push bp
	mov bp, sp		; Use BP as the ref for local variables
	sub sp, 2		; allocate 1 word variable

	mov word [bp - 2], 0	; temp = 0

	push ax			; Push used regs

	mov si, [bp + 4]	; Load SI argument
	xor ax, ax		; Clear AX

.RECIEVE_TRANSMIT_SIGNAL:	; Add sliding window for transmission
	lea ax, [bp - 2]        ; Low byte of local word
	push ax                	; Persistent pointer
	
	call CONSUME_BYTE      	; Receive low byte for temp, [lo][hi]
	
	inc word [bp - 6]      	; Advance pointer to high byte
	
	call CONSUME_BYTE      	; Receive high byte for temp, [lo][hi]
	
	add sp, 2              	; Remove pointer
	
	cmp word [bp-2], 0x8086	; Signature for recieve, sender must send in little endian, 86h, then 80h
	jne .RECIEVE_TRANSMIT_SIGNAL
	
	jmp .INTERPRET_COMMAND

.INTERPRET_COMMAND:		; For now just one command, but command logic would go here, likely using a table
	push si			; Push destination address adrgument passed to main to argument for FILE_RECV
	call FILE_RECV
	add sp, 2		; Remove reference location made before FILE_RECV call
	
	jmp .END

.END:
	pop ax

	add sp, 2		; Clear temp
	pop bp

	ret

FILE_RECV:
	push bp
	mov bp, sp
	push ax
	push cx

	mov cx, 64
	mov ax, [bp + 4]
	push ax
.CONSUME_LOOP:
	call CONSUME_BYTE
	inc word [bp - 6]
	loop .CONSUME_LOOP

	add sp, 2
	pop cx
	pop ax
	pop bp
	ret


CONSUME_BYTE:			; Takes an argument to store one byte
	push bp
	mov bp, sp
	push dx
	push si

	mov dx, 0xFFF2

.CONSUME_BYTE_LOOP:		; Standby loop; waits until UART signals that a byte is ready
	in al, dx
	test al, 0x02
	jz .CONSUME_BYTE_LOOP

.WRITE_BYTE:			; Write word to SI locations
	mov dx, 0xFFF0		; UART read/write location
	in al, dx

	mov si, [bp + 4]	; Deref the address and move to that location
	mov [ss:si], al
	
	pop si
	pop dx
	pop bp
	ret			; RET to caller



; Possibly don't need this loop
;SHIFT_TMP_LEFT:			; One argument indicating which memory location to move
;	push bp			; Save the last bp
;	mov bp, sp		; point to bp, so stack is [caller bp][ret][arg]
;	
;	push ax
;	mov ax, [bp + 4]	; Passed in argument
;	push cx
;	mov cx, 8
;
;.SHIFT_TMP_LEFT_LOOP:
;	shl ax, 1
;	loop .SHIFT_TMP_LEFT_LOOP
;
;	pop cx			; Restore the variables and stack pointers
;	pop ax
;	pop bp
;	ret
