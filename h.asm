assume cs:code, ds:data

data segment
    ;下面表示21年的21个字符串
    years db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984','1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995' $
    ;下面表示21年公司总收入的21个dword型数据
    total dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000 $
    ;下面是表示21年公司雇员人数的21个word型数据
    employees dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542,14430,15257,17800 $
data ends

; 每行显示的样式  'year summ ne ??

code segment
start:  mov ax, data    ;数据段的地址
        mov ds, ax
        mov si, 0
		
        mov ax, 0b800h   ;显存地址
        mov es, ax
        mov di, 0

        mov cx, 21       ;一共多少的年份

        ;显示年份
        mov dh, 2 
        mov dl, 5
        mov bl, 4
        call display_string

        mov ax, 4c00h
	    int 21h

;显示所有的年份
display_string: 
    mov cx, 20 
display_loop:
    call position
    call display_one_year; 显示年份
    jcxz display_end
    dec cx
    add dh, 1
    jmp  display_loop
display_end:
    ret
    

display_string: 
    push cx  ; 写入年份，si是原始数据， di是显存数据
    mov cx, bl; 移动四个字节
one_year_loop: 
    jcxz one_year_end
    mov ah, 20
    mov al, ds:[si]
    mov es:[di], ax
    add di, 2
    add si, 1
    dec cx
    jmp one_year_loop

one_year_end:
    pop cx
    ret
 
display_info_test: ; 显示收入
    mov ax, ds:[bx]
    mov es:[si], ax;
	mov ax, ds:[bx+2]
	mov es:[si+2], ax
	;填入总收入
	mov ax, ds:[bx+84]
	mov es:[si+5], ax
	mov dx, ds:[bx+84+2]
	mov es:[si+5+2], dx
	;计算平均收入
	div  word ptr ds:[di+168]
	;填入员工数
	mov dx, ds:[di+168]
	mov es:[si+10], dx
	;填入平均收入
	mov es:[si+13], ax
    ret

;将数字显示在屏幕上
dtoc:	
    mov cx, 10
	mov dx, 0
	div cx
	mov cx, dx
	jcxz ok
	add cx, 30H
	mov ds:[si], cx 
	add si, 1
	jmp dtoc
		

;计算显示位置的函数
;dh保存行， dl保存列
;结果保存在di中, 
position:    
    mov al, 0A0h
    mul dh
    mov di, ax
    mov al, 2
    mul dl
    add di, ax
    ret 		

code ends

end start