assume cs:code


code  segment
start:

    mov al, 23h
    call display_number
    mov ax, 4c00H
    int 21h

display_number:
    jmp short display_number_start
    table db '0123456789ABCDEF'

    display_number_start:
    push ax
    push bx
    push cx

    mov ah, al
    mov cl, 4
    shr ah, cl
    and al, 00001111b

    mov bl, ah
    mov bh, 0
    mov ah, table[bx]

    mov bl, al
    mov bh, 0
    mov al, table[bx]

    mov bx, ax
    mov ax, 0b800h
    mov es, ax
    
    mov es:[160*12+2*40], bh
    mov es:[160*12+2*40+2], bl

    pop cx
    pop bx
    pop ax
    ret

code ends
end start