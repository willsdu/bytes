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

table segment
    db 21 dup ('year summ ne ?? ')
table ends

code segment
				;数据段的地址
start:  mov ax, data
        mov ds, ax

				;表格的段地址
        mov ax, table
        mov es, ax

        mov bx, 0
        mov cx, 21
        mov si, 0
				mov di, 0

				;填入年份
    s:  mov ax, ds:[bx]
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

				;下一个循环
				add bx, 4
				add si, 16
				add di, 2
				loop s

				mov ax, 4c00h
				int 21h
				
code ends

end start