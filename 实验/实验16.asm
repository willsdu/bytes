assume cs:code

code  segment
start:
    call install_int7c
    
    mov ah, 3
    mov al, 2
    int 7ch

    mov ax, 4c00H
    int 21h

install_int7c:
    push ax
    push es
    push ds
    push si  
    push di  

    mov ax, cs
    mov ds, ax  
    mov si, offset set_screen
    
    mov ax, 0 
    mov es, ax 
    mov di, 204h

    mov cx, offset sub_programe_end - offset set_screen
    rep movsb

    mov ax, es:[7ch*4]
    mov es:[200h], ax
    mov ax, es:[7ch*4+2]
    mov es:[202h], ax

    mov word ptr es:[7ch*4], 204h
    mov word ptr es:[7ch*4+2], 0 
    
    pop di
    pop si  
    pop ds  
    pop es  
    pop ax  
    ret

set_screen:
    jmp short set_screen_start

    set_screen_start:
    push ax  
    push bx

    cmp ah, 3
    ja set_screen_end


    cmp ah, 0
    je short do0

    cmp ah, 1
    je short do1

    cmp ah, 2
    je short do2

    cmp ah, 3
    je short do3

    do0:
    call cls
    jmp short set_screen_end

    do1:
    call set_pre_color
    jmp short set_screen_end

    do2:
    call set_tail_color
    jmp short set_screen_end

    do3:
    call scroll

    set_screen_end:
    pop bx  
    pop ax  
    ret

cls: 
    push ax
    push es
    push di
    push cx


    mov ax, 0b800h
    mov es, ax
    mov di, 0

    mov cx, 2000
    cls_loop:
    mov byte ptr es:[di], ' '
    add di, 2
    loop cls_loop

    pop cx 
    pop di
    pop es
    pop ax
    ret 

set_pre_color:
    push ax
    push es
    push di
    push cx


    mov di, 0b800h
    mov es, di
    mov di, 1

    mov cx, 2000
    set_pre_color_loop:
    and byte ptr es:[di],11111000b
    or es:[di], al
    add di, 2
    loop set_pre_color_loop

    pop cx 
    pop di
    pop es
    pop ax
    ret 

set_tail_color:
    push ax
    push es
    push di
    push cx


    mov di, 0b800h
    mov es, di
    mov di, 1

    mov cl, 4
    shl al, cl

    mov cx, 2000
    set_tail_color_loop:
    and byte ptr es:[di],10001111b
    or es:[di], al
    add di, 2
    loop set_tail_color_loop

    pop cx 
    pop di
    pop es
    pop ax
    ret 

scroll:
    push  ax 
    push  es  
    push  ds
    push  di 
    push  cx 
    push  si

    mov di, 0b800h
    mov es, di
    mov ds, di
    mov di, 0
    mov si, 160
    cld 
    mov cx, 24

    scroll_line_loop:
    push cx
    mov cx, 160
    rep movsb
    pop cx
    loop scroll_line_loop

    mov cx, 80
    mov si, 0
    scroll_last_loop:
    mov byte ptr es:[160*24+si], ' '
    add si, 2
    loop scroll_last_loop

    pop cx 
    pop di
    pop ds
    pop es
    pop ax
    ret 
sub_programe_end:
    nop

code ends
end start