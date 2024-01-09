assume cs:code,ss:stack,ds:data

stack segment
  dw 128 dup(0)
stack ends

data segment
 dw 0,0
data ends



code  segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 128

    mov ax, data
    mov ds, ax
    mov si, 0

    ;处理中断程序
    call install_int9
    
    call display_alphabet

    mov ax, 0
    mov es, ax

    push ds:[0]
    pop es:[9*4]
    push ds:[2]
    pop es:[9*4+2]

    mov ax, 4c00H
    int 21H


;安装中断处理程序
install_int9:
    push es
    push ax

    mov ax, 0
    mov es, ax

    ;保存原来的中断程序地址
    cli
    mov ax, es:[9*4]
    mov ds:[0], ax
    mov ax, es:[9*4+2]
    mov ds:[2], ax
    sti

    ;重新设置中断处理程序    
    cli
    mov word ptr es:[9*4], offset int9_change_color
    mov es:[9*4+2], cs
    sti

    pop ax
    pop es
    ret

;功能： int9中断程序，改变颜色，然后调用原来的中断处理程序
int9_change_color:
    push ax
    push bx
    push es
    
    ;读取键盘输入
    in al, 60h

    pushf 
    ;设置不可屏蔽中断
    ; pushf
    ; pop bx
    ; and bh, 11111100b
    ; push bx
    ; popf
    ;调用原来的中断程序
    call dword ptr ds:[0]

    cmp al, 1
    jne int9_change_color_end
    mov ax, 0b800h
    mov es, ax
    inc byte ptr es:[160*12+40*2+1]

    int9_change_color_end:
    pop es
    pop bx
    pop ax
    iret


display_alphabet:
    mov ax, 0b800h
    mov es, ax

    mov ah, 'a'
    diaplay_alpbet:
    mov di, 160*12+40*2
    mov es:[di], ah
    call sleep
    inc ah
    cmp ah, 'z'
    jna diaplay_alpbet

    ret

;功能： 实现睡眠功能
;参数： ax需要睡眠的秒数
sleep:
    push ax
    push dx

    mov dx, 10
    mov ax, 0

    sleep_loop:
    sub ax, 1
    sbb dx, 0 
    cmp ax, 0
    jne sleep_loop
    cmp dx, 0
    jne sleep_loop

    pop dx
    pop ax
    ret


code ends
end start