assume cs:code

data segment
  db 5000 dup(0)
data ends

code  segment
start:
    call write_disk
    call read_disk

    mov ax, 4c00H
    int 21h

read_disk:
    push ax
    push bx
    push cx
    push dx

    mov ax, data
    mov es, ax
    mov bx, 0

    mov al, 1 
    mov ch, 0
    mov cl, 1
    mov dh, 1
    mov dl, 0
    mov ah, 2
    int 13h

    pop dx
    pop cx
    pop bx
    pop ax

    ret

write_disk:
    mov ax, 0b800h
    mov es, ax
    mov bx, 0

    mov al, 8
    mov ch, 0
    mov cl, 1
    mov dl, 0
    mov dh, 0
    mov ah, 3
    int 13h
    ret
    
code ends
end start