assume cs:code, ds:data, ss:stack

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上是表示21年的21个字符串
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示21年公司总收入的21个dword型数据
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

stack segment
  dw 16 dup(0)
stack ends


code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    ;表格的段地址
    mov ax, table
    mov es, ax
    mov di, 0

    mov ax, stack 
    mov ss, ax
    mov sp, 30

    





copy: ;将内存一端的数据拷贝到其他地方
     ; cx 保存拷贝长度
     ; 从ds拷贝到es
    call save_stack
copy_loop:
    mov al, ds:[si]
    mov es:[di], al
    sub cx, 1
    cmp cx, 0
    je copy_return
    add si, 1
    add di, 1
    jmp copy_loop
copy_return:
    call recover_stack
    ret


save_stack:
    pop ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push ax
    ret

recover_stack:
    pop ax
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    push ax
    ret

code ends
end start


