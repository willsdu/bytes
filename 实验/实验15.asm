assume cs:code,ss:stack

;定时显示a-z，键盘输入esc, 改变显示字符的颜色

stack segment
  dw 128 dup(0)
stack ends


code  segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 128

    ;安装中断程序
    call install_int9

    mov ax, 4c00H
    int 21H


;安装中断处理程序
install_int9:
    push es
    push ax
    push di
    push cx

    push cs
    pop ds
    mov si, offset int9

    mov ax, 0
    mov es, ax 
    mov di, 204h

    mov cx, offset int9_over -  offset int9
    cld 

    rep movsb

    ;保存原来的中断程序地址
    cli
    mov ax, es:[9*4]
    mov es:[200h], ax
    mov ax, es:[9*4+2]
    mov es:[202h], ax
    sti

    ;重新设置中断处理程序    
    cli
    mov word ptr es:[9*4], 204h
    mov word ptr es:[9*4+2], 0
    sti

    pop cx
    pop di
    pop ax
    pop es
    ret

;功能： int9中断程序，改变颜色，然后调用原来的中断处理程序
int9:
    push ax
    push es
    push di
    push cx

    mov ax, 0
    mov es, ax

    in al, 60h

    pushf
    call dword ptr es:[200h]

    cmp al, 9eh
    jne int9_end

    mov ax,0b800h
    mov es, ax

    mov cx, 2000
    mov di, 0
    int9_loop:
    mov  byte ptr es:[di], 'A'
    add di,2
    loop int9_loop

    int9_end:
    pop cx
    pop di  
    pop es
    pop ax
    iret

    int9_over: nop
   

code ends
end start