assume cs:code, ds:data, ss:stack

data segment
dd 5937000
data ends

stack segment
dw  16 dup(0)
stack ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    mov ax, stack
    mov ss, ax
    mov sp, 0

    mov ax, 0b800h
    mov es, ax 
    mov di, 400h
    call display
    mov ax, 04c00h
    int 21h


display:
    call mdiv
    mov bx, ax
    add bx, dx
    cmp bx, 0
    je send
    add cl, 30H
    mov ch, 24h
    mov es:[di], cx
    sub di, 2

    mov ds:[si], ax
    mov ds:[si+2], dx
    jmp  display
send:
    add cl, 30H
    mov ch, 24h
    mov es:[di], cx
    ret
    
;mdiv 除法, 商的高位在dx，低位在ax， 余数在cx
mdiv:
    mov ax, ds:[si+2]
    mov dx, 0
    mov bx, 0ah
    div bx
    push ax
    mov ax, ds:[si]
    div bx
    mov cx, dx
    pop dx
    ret

code ends
end start

