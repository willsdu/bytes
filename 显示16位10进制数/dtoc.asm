assume cs:code, ds:data

data segment
dw 5937
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    mov ax, 0b800h
    mov es, ax 
    mov di, 400h
    mov ax, ds:[si]
    call display_16_integer
    mov ax, 04c00h
    int 21h


display_16_integer:
    call div16
    cmp ax, 0
    je display_16_integer_return
    add dl, 30H
    mov dh, 24h
    mov es:[di], dx
    sub di, 2
    jmp  display_16_integer
display_16_integer_return:
    add dl, 30H
    mov dh, 24h
    mov es:[di], dx
    ret

div16:
    mov dx, 0
    mov bx, 0ah
    div bx
    ret

code ends
end start

