; test.asm
bits 16

    mov ax, 0xABCF
    mov bx, 0x1234
    add ax, bx

.loop:
    jmp .loop
