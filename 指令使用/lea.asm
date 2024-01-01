assume cs:code, ds:data

data segment 
   d1 db '223456789012',0
   d2 db 32 dup(0), 10,'$'
data ends



code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax

    lea si, d1
    lea di, d2

    mov cx, offset d2-offset d1 -1

    cld

    s:
    movsb
    loop s

    lea dx, d2
    mov ah, 9H
    int 21h
    
    mov ax, 4c00H
    int 21H

code ends
end start