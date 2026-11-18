ORG 0100h
BITS 16
; Goal of the program is to consume one word from serial and write it into memory
; The monitor seems to keep UART control word as FFFF

INIT_UART:
mov dx, 0xFFF2 ; Status word location
xor ax, ax
xor bx, bx
; Word contents will be placed in BX
CONSUME_WORD:
mov cx, 2 ; Loop twice to get just 2  bytes

.loop:
in al, dx
test al, 0x02
jz .loop

mov dx, 0xFFF0 ; Read write location
in al, dx
mov bl, al

test cx, 1
je .shift_bx

mov dx, 0xFFF2
loop .loop

int 2

.shift_bx:
xchg bh, bl
mov dx, 0xFFF2
loop .loop
