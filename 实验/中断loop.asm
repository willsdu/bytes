assume cs:code

;通用中断程序
code  segment

start:
    call install_loop_op

    mov ax, 0B800H
    mov es, ax
    mov di, 160*12

    mov bx, offset loop_s -  offset  loop_s_end
    mov cx, 80

    loop_s:
    mov byte ptr es:[di], '!'
    add di, 2
    int 7ch
    loop_s_end:
    nop

    mov ax,4c00H
    int 21H


install_loop_op:
    mov ax, cs
    mov ds, ax
    lea si, loop_op

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset loop_end - offset loop_op

    mov bx, 7ch
    call install

    ret

;功能：安装中断程序
;参数：bx, 中断号
;     ds:si, 中断代码的初始位置
;     es:di, 中断程序安装位置
;     cx, 中断程序长度
;返回：无
install:
    push ax
    push di
    push si
    push cx
    push ds
    push bx
    
    ;拷贝代码
    cld
    rep movsb 

    ;修改中断向量表
    mov ax, 0
    mov ds, ax
    add bx, bx
    add bx, bx
    mov word ptr ds:[bx+0], 200h
    mov word ptr ds:[bx+2], 0

    pop bx
    pop ds
    pop cx
    pop si
    pop di
    pop ax
    ret

;loop指令的功能
;bx 跳转偏移量
;cx 计数器
loop_op:
    push bp
    
    mov bp, sp
    dec cx
    jcxz loop_op_end
    add ss:[bp+2], bx

    loop_op_end:
    pop bp
    iret
    
    loop_end:
    nop



code ends
end start