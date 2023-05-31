assume cs:code, ds:data

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


code segment
				
start:
	;数据段的地址  
	mov ax, data
    mov ds, ax
	mov si, 0 

	;显存开始地址
	mov ax, 0b800h
    mov es, ax 
    mov di, 10h

s:  ;显示公司的总体数据
	mov ax, 21
	push ax
	;显示年份
	mov cx, 4
	call display_string
	add di, 10h
	;显示总收入
	add si, 54h
	call dtoc
	add di, 10h
	;显示雇员人数
	add si, 54h
	call dtoc
	pop ax
	sub ax, 1
	cmp 0
	je far ptr stop

display_string:
	jmp display_string_return 
	mov ah, 24h
	mov al, ds:[si]
	mov es:[di], ax
	add si, 1
	add di, 2
	sub cx, 1
	jmp display_string
display_string:
	ret
				
dtoc:
    call mdiv
    mov bx, ax
    add bx, dx
    cmp bx, 0
    je send
    add cl, 30H
    mov ch, 24h
    mov es:[di], cx
    sub di, 2

	mov ds:[si], ax
	mov ds:[si+2], dx
    jmp  dtoc
send:
    add cl, 30H
    mov ch, 24h
    mov es:[di], cx
    ret

;mdiv 除法, 商的高位在dx，低位在ax， 余数在cx
mdiv:
    mov ax, ds:[si+2]
    mov dx, 0
    mov bx, 0ah
    div bx
    mov cx, ax
    mov ax, ds:[si]
    div bx
    mov bx, dx
	mov dx, cx
	mov cx, bx	
    ret

stop:
	mov ax, 04c00h
    int 21h

code ends
end start