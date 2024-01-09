assume cs:code

data segment
    db 32 dup(0)
data ends

code  segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    mov dh, 24
    mov dl, 0
    call  get_str
    mov ax, 4c00H
    int 21h

get_str:
    push ax

    get_str_start:
    mov ah, 0
    int 16h
    cmp al, 20h
    jb not_char
    mov ah, 0
    call chars_stack
    mov ah, 2
    call chars_stack
    jmp short get_str_start
  
  not_char:
    cmp ah, 0eh
    je delete_char
    cmp ah, 1ch
    je enter
    jmp short get_str_start

  delete_char:
    mov ah, 1
    call chars_stack
    mov ah, 2
    call chars_stack
    jmp short get_str_start
    
  enter: 
    mov al, 0
    mov ah, 0
    call chars_stack
    mov ah, 2
    call chars_stack

    pop ax
    ret
   

    



;子程序:字符栈的入栈、出栈和显示(ah)-功能号，0 表示入栈，1 表示出栈，2 表示显示
;参数说明:ds:si 指向字符栈空间;
;对于 0号功能:(al)-入栈字符;
;对于 1 号功能:(al)-返的字符;
;对于 2 号功能:(dh)、(dl)-字符串在屏幕上显示的行、列位置
chars_stack:
    jmp short chars_stack_start
    table dw push_char,pop_char,show_str
    top dw 0

    chars_stack_start:
    push ax
    push bx
    push cx
    push dx
    push es
    push si
    push di

    cmp ah, 2
    ja sret

    mov bh, 0
    mov bl, ah
    add bl, bl
    jmp word ptr table[bx]
    
  push_char:
    mov bx, top
    mov [si][bx], al
    inc top
    jmp short sret

  pop_char:
    mov bx, top
    mov al, [si][bx-1]
    mov byte ptr [si][bx-1], 0
    dec top
    jmp short sret

  show_str:
    mov bx, 0b800h
    mov es, bx
    mov ah, 0
    mov al, 160
    mul dh
    mov di, ax
    add dl, dl
    mov dh, 0
    add di, dx

    mov bx, 0
    show_str_loop:
    cmp bx, top
    jne show_str_not_empty
    mov byte ptr es:[di], ' '
    jmp short sret
    
    show_str_not_empty:
    mov al, [si][bx]
    mov es:[di], al
    add di, 2
    inc bx
    jmp short show_str_loop

    sret:
    pop di
    pop si
    pop es
    pop dx
    pop cx
    pop bx
    pop ax

    ret

code ends
end start