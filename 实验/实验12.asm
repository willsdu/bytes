assume cs:code
;重新设置0号中断处理程序

code  segment

start:
    call install
    int 0

;安装中断程序
install:
    mov ax, cs
    mov ds, ax
    lea si, int0

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset int0_end - offset int0
    cld
    
    rep movsb 

    ;修改中断向量表
    mov ax, 0
    mov ds, ax
    mov word ptr ds:[0], 200h
    mov word ptr ds:[2], 0

    ret

;0自定义的0号中断处理程序
int0:
    jmp short int0_start
    db "overflow!"
    int0_start:
    mov ax,cs
    mov ds,ax
    mov si,202h   ;安装后的字符串偏移地址

    mov ax, 0B800H
    mov es, ax
    mov di, 160*12+2*26

    mov cx, 9
    int0_loop:
    mov al, ds:[si]
    mov es:[di], al
    inc si
    add di, 2
    dec cx
    cmp cx, 0
    jne int0_loop

    int0_loop_end:
    mov ax, 4c00H
    int 21h

    int0_end:
    nop






code ends
end start