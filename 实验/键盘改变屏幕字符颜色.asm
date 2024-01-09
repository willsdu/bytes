assume cs:code

code  segment
start:
    mov ah, 0
    int 16h

    mov ah, 1 
    cmp al, 'r'
    je set_red

    cmp al, 'g'
    je set_green

    cmp al, 'b'
    je set_blue

    jmp short set_ends
    
    set_red:
    shl ah, 1
    
    set_green:
    shl ah, 1

    set_blue:
    call set_color

    set_ends:

    mov ax, 4c00H
    int 21h

set_color:
    push ax 
    push es 
    push di
    push cx

    mov di, 0b800h
    mov es, di
    mov di, 1

    mov cx, 2000
    set_color_loop:
    and byte ptr es:[di], 11111000b
    or  byte ptr es:[di], ah
    add di, 2 
    loop set_color_loop

    pop cx
    pop di
    pop es
    pop ax

    ret 

code ends
end start