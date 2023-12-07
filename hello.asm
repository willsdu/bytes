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
  dw 32 dup(0)
stack ends

str segment
    dw 8 dup(0)
    dw 8 dup(0)
str ends




code segment
start:
    ;数据段的地址
    mov ax, data
    mov ds, ax
    mov si, 0

    ;表格的地址
    mov ax, table
    mov es, ax
    mov di, 0

    ;栈段的地址
    mov ax, stack 
    mov ss, ax
    mov sp, 40h

    call totable

    mov ax, str
    mov ds, ax
    mov byte ptr ds:[10h], 3h
    mov byte ptr ds:[11h], 5h
    mov byte ptr ds:[12h], 2h

    call show_table

    mov ax, 4c00H
    int 21h

show_table:
    mov cx, 21
    mov bx, 0           ;每年地址的初始地址

    show_table_start:
    call show_table_body
    loop show_table_start

    ret
    

show_table_body:  
    push cx

    mov si, 0           ;str  地址
    mov di, 0           ;每年数据的移动地址

    mov ax,es:[bx+di]
    mov ds:[si], ax
    add di,2
    add si,2
    mov ax,es:[bx+di]
    mov ds:[si], ax
    add di,2
    add si,2
    mov byte ptr ds:[si], 0
    add si, 1

    mov dh, ds:[10h]
    mov dl, ds:[11h]
    mov cl, ds:[12h]
    call show_str
    
    inc dh
    mov ds:[10h], dh
    add bx, 0010H

    pop cx
    ret




;功能：将ds:si的字符，以指定颜色显示在屏幕指定位置
;     显存默认es
;参数：dh 行号 
;     dl 列号
;     cl 颜色
;返回：无
show_str: 
    push ax
    push dx
    push cx
    push si
    push es
    push di

    mov ax, 0B800H
    mov es, ax

    call display_offset
    mov di, dx
    mov al, cl
    mov si, 0
    show_str_start:
    mov ch, 0
    mov cl, ds:[si]
    jcxz show_str_end
    mov ch, al
    mov es:[di], cx
    inc si
    add di, 2
    jmp short show_str_start
    show_str_end:

    pop di
    pop es
    pop si
    pop cx
    pop dx
    pop ax
    ret


;功能：将dx中的行列数据计算成真正的偏移地址
display_offset: 
    push ax

    mov ax, 0A0h
    mul dh
    mov dh, 0
    add al, dl
    add al, dl
    mov dx, ax

    pop ax
    ret

;功能： 将年份，收入，员工数等写到table中去；同时计算总收入
totable:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp


    ;写入年份
    mov cx, 21
    mov bp, 4
    call column_copy
    ;写入收入
    mov cx, 21
    mov bp, 4
    add di, 5
    call column_copy
    ;写入员工数量
    mov cx, 21
    mov bp, 2
    add di, 5
    call column_copy
    ;计算人均收入
    mov di, 0 
    mov cx, 21
    avg:
    mov ax, es:[di+5]
    mov dx, es:[di+7]
    div word ptr es:[di+10]
    mov es:[di+13], ax
    add di, 10h
    loop avg

    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret



;功能：将年份，收入的数据拷贝到指定的内存
;参数：  cx，外循环，一共多少年
;       bp, 内循环，每个年份占用多少字节
;       ds:si   目的地址
;       es:di   复制数据的起点地址
;返回   ds:di
column_copy:   
    push bp
    push bx
    push ax
    push di
   
    copy_main_loop:
    push cx
    mov cx, bp
    copy_dw:   ;将table段中的4个字节拷贝到目的地址中
    mov al, ds:[si]
    mov es:[bx+di], al
    inc si
    inc di
    loop copy_dw

    add bx, 10H
    sub di, bp
    pop cx
    loop copy_main_loop

    pop di
    pop ax
    pop bx
    pop bp

    ret

code ends
end start


