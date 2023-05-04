assume cs:code
;将下面的数字，显示在屏幕的第8行，第6列

data segment
        db '1234567890',0
data ends

code segment
start:  ;需要显示的数据地址
        mov ax, data
        mov ds, ax
        mov di, 0
        ;显存地址
        mov ax, 0b800h
        mov es, ax
        mov dh, 8
        mov dl, 5
        call position
        mov si, dx
        ;处理数据
s:      mov ch, 0
        mov cl, ds:[di]
        jcxz e
        mov ch, 24h
        mov es:[si], cx
        ;循环计数
        add di, 1
        add si, 2
        jmp s

e:      mov ax, 4c00h
        int 21h
        


;根据给定的行和列，计算出在屏幕中的位置，
;参数：dh行，dl列,
;结果：dx
position:
        mov ax, 0
        mov al, 2
        mul dl
        mov dl, al
        mov al, 0a0h
        mul dh
        mov dh, 0
        add ax, dx
        mov dx, ax
        ret
        
code ends
end start
