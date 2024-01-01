assume cs:code,ds:data

data segment
    db "Beginner All purpose Symbolic Instruction Code",0,'$'
data ends

;通用用户自定义中断程序
code  segment

start:
    call install_capital
    mov ax, data
    mov ds, ax
    mov si, 0
    int 7ch

    mov dx, 0
    mov ah, 9h 
    int 21h

    mov ax,4c00H
    int 21H


install_capital:
    mov ax, cs
    mov ds, ax
    lea si, capital

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset capital_end - offset capital

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

capital:
    push cx
    push si
    
    change:
    mov cl, [si]
    mov ch, 0
    jcxz ok
    and byte ptr [si], 11011111b
    inc si
    jmp short change

    ok:
    pop si
    pop cx
    iret
    
    capital_end:
    nop






code ends
end start