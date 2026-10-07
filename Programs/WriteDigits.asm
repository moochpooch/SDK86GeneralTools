org 0100h
bits 16

test:
    call write_start
    int 2

write_start:
    push ax
    push bx
    push cx
    push dx
    push si

    ; 8279 command port
    mov dx, 0FFEAh

    ; Save current ax
    push ax
    ; Clear display command
    mov al, 11010001b
    out dx, al

    call delay

    ; Write display RAM, auto-increment
    mov al, 10010000b
    out dx, al

    mov bx, 10
    
    ; Recall original ax
    pop ax
.loop_start:
    xor dx, dx
    div bx                  ; AX = quotient, DX = remainder   

    mov si, dx              ; save digit before restoring port

    ; Preserve quotient because loading AL would modify AX
    push ax

    mov al, [cs:lookup_table + si]

    mov dx, 0FFE8h
    out dx, al

    pop ax                  ; restore quotient

    test ax, ax
    jnz .loop_start

.exit_routine:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

delay:
	mov cx, 48
.wait:
	loop .wait
	ret

lookup_table:
    db 3Fh                  ; 0
    db 06h                  ; 1
    db 5Bh                  ; 2
    db 4Fh                  ; 3
    db 66h                  ; 4
    db 6Dh                  ; 5
    db 7Dh                  ; 6
    db 07h                  ; 7
    db 7Fh                  ; 8
    db 6Fh                  ; 9
