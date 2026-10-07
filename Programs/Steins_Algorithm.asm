org 0100h
bits 16

; AX = current A
; BX = current B
; CX = shared powers of 2 removed
; SI = next trace record

start:
    push cs
    pop ds

    mov si, trace
    mov ax, 244
    mov bx, 277
    xor cx, cx

main:
    cmp ax, bx
    je finished

    ; Are both values even?
    test ax, 1
    jnz not_both_even

    test bx, 1
    jnz not_both_even

both_even:
    ; Divide A by 2, preserving B.
    push bx
    mov bx, 2
    xor dx, dx
    div bx
    pop bx

    ; Divide B by 2, preserving new A.
    push ax
    mov ax, bx
    mov bx, 2
    xor dx, dx
    div bx
    mov bx, ax
    pop ax

    inc cx
    jmp record_state

not_both_even:
    test ax, 1
    jz a_even

    test bx, 1
    jz b_even

    ; Both are odd.
    cmp ax, bx
    ja a_greater

b_greater:
    sub bx, ax
    jmp record_state

a_greater:
    sub ax, bx
    jmp record_state

a_even:
    push bx
    mov bx, 2
    xor dx, dx
    div bx
    pop bx
    jmp record_state

b_even:
    push ax
    mov ax, bx
    mov bx, 2
    xor dx, dx
    div bx
    mov bx, ax
    pop ax
    jmp record_state

record_state:
    mov [si], ax
    mov [si+2], bx
    add si, 4
    jmp main

finished:
    ; AX == BX here, but shared powers of two were removed.
    shl ax, cl
    mov [result], ax

stop:
    jmp $

trace:  times 124 * 2 dw 0
result: dw 0
