assume cs:code,ss:stack 
 
data segment    ;这些是要写入的数据
  db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984'
  db '1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995'
  dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
  dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
  dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
  dw 11542,14430,15257,17800
data ends
 
stack segment
  dw 32 dup(0)    ;64个字节.32个push位
stack ends
 
table segment            ;将data段中给定数据按照格式填写到这个table段中
  db 21 dup ('year summ ne ?? ')
table ends
 
str segment        
    dw 8 dup(0)    ;16个字节，将每一个数据转为十进制字符形式，存到这里
    dw 8 dup(0)    ;16个字节，存放指定的屏幕显示行号字节、列号字节、字符属性字节
str ends
 
code segment
start:
  
    mov ax,stack        ;设置栈顶
    mov ss,ax
    mov sp,40H
    mov ax,data          ;设置ds段指向data段
    mov ds,ax
    mov ax,table          ;设置es段指向table段
    mov es,ax
 
    call totable        ;调用子程序，将data段中21年的数据复制到table段中
    
    
    mov bx,str    ;设置ds指向str段
    mov ds,bx
    mov dl,03H    ;指定在屏幕上开始显示的行号
    mov ds:[10H],dl   ;存到str段中
    mov dl,05H    ;指定在屏幕上开始显示的列号
    mov ds:[11H],dl    ;存到str段中
    mov cl,2        ;显示的字符的属性字节
    mov ds:[12H],cl    ;存到str段中
    call show_table    ;将table段中的数据显示到屏幕指定位置上
 
 
    mov ax,4c00H        ;程序返回
    int 21H
 
show_table:        ;功能：将table段中的数据按照格式显示到屏幕的指定位置上
                    ;参数：ds指向str段，es指向table段
                    ;    显示指定的行号、列号、字符数形在str段第10H-12H中
                    ;返回：无
 
    push bx        ;将寄存器的值压入栈
    push si  
    push di  
    push cx
    push ax
    push dx
 
    mov bx,0        ;table段中当年数据的起始地址
    mov si,0        ;转换成字符后的数据从str哪个地址开始存
    mov cx,21      ;一共21年，所以循环21次
    thisyear:      
    call show_table2
    loop thisyear     ;这一年的显示完成，继续显示下一年的数据
 
    pop dx        ;将寄存器的值pop出来
    pop ax
    pop cx
    pop di
    pop si
    pop bx
 
    ret
 
;这是个show_table内部的函数
show_table2:        ;通过循环，将table段中的数据显示到屏幕上
    
    push cx        ;将寄存器的值压入栈，此时cx是循环次数，代表当前是第几年
 
    mov di,0        ;table段中当前该存每年第N个字节的数据
    mov ax,es:[bx+di]    ;取年份数据的前两个字节的数据  
    mov ds:[0],ax        ;将年份数据存入str段
    add di,2
    mov dx,es:[bx+di]    ;取年份数据的高两个字节的数据
    add di,2
    mov ds:[2],dx
    mov byte ptr ds:[4],0    ;以0作为结尾符
 
    mov dh,ds:[10H]    ;从str段中取出指定的显示起始行号
    mov dl,ds:[11H]    ;从str段中取出指定的显示起始列号
    mov cl,ds:[12H]    ;从str段中取出指定的显示字符的属性字节
    call show_str    ;调用子程序，将str段中的十进制数据显示在屏幕指定位置
    
    inc di
    mov ax,es:[bx+di]    ;取年总收入的低16位数据
    add di,2
    mov dx,es:[bx+di]    ;取年总收入的高16位数据
    add di,2   
    call dtoc_dword    ;调用子程序，将dword型数据转为十进制，存入str段中指定位置
 
    mov dh,ds:[10H]    ;从str段中取出指定的显示起始行号
    mov dl,ds:[11H]    ;从str段中取出指定的显示起始列号
    add dl,0aH        ;上一项数据占10列
    mov cl,ds:[12H]    ;从str段中取出指定的显示字符的属性字节
    call show_str    ;调用子程序，将str段中的十进制数据显示在屏幕指定位置
 
    inc di                ;复制 雇员人数
    mov ax,es:[bx+di]
    add di,2
    mov dx,0
    call dtoc_dword    ;调用子程序，将dword型数据转为十进制，存入str段中指定位置
 
    mov dh,ds:[10H]    ;从str段中取出指定的显示起始行号
    mov dl,ds:[11H]    ;从str段中取出指定的显示起始列号
    add dl,14H        ;上一项数据再占10列
    mov cl,ds:[12H]    ;从str段中取出指定的显示字符的属性字节
    
    call show_str    ;调用子程序，将str段中的十进制数据显示在屏幕指定位置
 
    inc di            ;计算 人均收入
    mov ax,es:[bx+di]
    add di,2
    mov dx,0
    call dtoc_dword    ;调用子程序，将dword型数据转为十进制，存入str段中指定位置
 
    mov dh,ds:[10H]    ;从str段中取出指定的显示起始行号
    mov dl,ds:[11H]    ;从str段中取出指定的显示起始列号
    add dl,1EH        ;上一项数据再占10列
    mov cl,ds:[12H]    ;从str段中取出指定的显示字符的属性字节
    call show_str    ;调用子程序，将str段中的十进制数据显示在屏幕指定位置
 
    add bx,0010H        ;切换到下一年，table段中的下一行
    mov cl,ds:[10H]        ;取出当前行号
    inc cl                ;将行号+1，因为要在屏幕下一行写下一年的数据
    mov ds:[10H],cl
 
    pop cx        ;将寄存器的值pop出来
 
    ret    ;这一年的显示完成，继续显示下一年的数据
 
dtoc_dword:     ;功能：将dword型数据转为十进制，存入str段中
                    ;参数：ds指向str段，si指向在str段的哪个地址开始存
                    ;ax存放dword型数据的低16位，dx存放dword型数据的高16位  
                    ;返回：ds:si指向str段十进制数据的首地址                 
 
    push cx        ;将用到的寄存器压入栈
    push bx
    push si
    push ax
    push dx
    
    mov bx,0        ;bx = 压入栈的余数的个数
    pushyushu:
    mov cx,000aH    ;cx = 除数 = 10
    call divdw        ;调用子程序进行除法计算，返回值：商低16位在ax，高16位在dx，余数在cx
    push cx        ;将余数压入栈
    inc bx            ;压入栈的余数个数+1
    mov cx,ax
    add cx,dx        ;商的高低16位必然都是非负数，如果和为0，那么说明商为0，则除法进行完毕
    jcxz popyushu    ;若除法进行完毕，则转去将栈中余数倒序pop出来
    jmp pushyushu    ;否则，就再进行一次除法
    
    popyushu:        ;将栈中余数倒序pop出来，存入str段
    mov cx,bx        ;如果循环次数剩余0，就退出循环
    jcxz dtoc_over
    pop ax            ;取出一个余数
    add ax,30H        ;转为数字对应的字符
    mov ds:[si],ax    ;将该余数存入str段内存中
    inc si            
    dec bx            ;循环次数-1
    loop popyushu     ;再继续取余数，转存到str段
 
    dtoc_over:
    inc si        ;都存完以后，再存个0到str段，作为结尾符
    mov byte ptr ds:[si],0  
    
    pop dx            ;将寄存器的值pop出来
    pop ax
    pop si
    pop bx
    pop cx
    
    ret
 
divdw:    ;功能：计算dword型被除数与word型除数的除法
            ;参数：  ax=被除数低16位，dx=被除数高16位，cx = 除数
            ;返回：  ax=商的低16位，dx=商的高16位，cx = 余数
 
    ;计算公式： X/N = int( H/N ) * 65536 + [rem( H/N) * 65536 + L]/N  
    ;其中X为被除数，N为除数，H为被除数的高16位，L为被除数的低16位，
    ;int()表示结果的商，rem()表示结果的余数。
 
                ;思路是分左右两项分别计算，然后再求和。
    
    push bx    ;bx是额外用到的寄存器，要压入栈
 
    mov bx,ax    ;bx=L
    mov ax,dx    ;ax = dx = H
    mov dx,0        ;要计算的是H/N，H和N都是16位，但CPU只能计算16/8位，因此让高位dx=0
    div cx        ;计算H/N，结果的商即int(H/N)保存在ax，余数即rem(H/N)保存在dx
                    
                    ;接下来要计算int(H/N)*65536，即ax * 65536
                    ;思考一下，65536就是0001 0000 H，
                    ;因此计算结果就是，高16位=int(H/N)=ax，低16位为0000H。
    
    push ax        ;将int(H/N)*65536结果的高16位，即int(H/N)，压入栈
    
    mov ax,0
    push ax        ;将int(H/N)*65536结果的低16位，即0000H，压入栈
                    
                    ;至此，左边项已计算完毕，且高低16位已先后入栈。
                    ;接下来要计算 rem(H/N)*65536 ，同理可得，
                    ;计算结果为 高16位=  rem(H/N) ，即此时dx的值，
                    ;低16位为 0000H。
    
    mov ax,bx        ;ax = bx = L ，而rem(H/N)*65536的低16位=0，
                    ;因此ax = bx = 即 [rem(H/N)*65536 + L]的低16位
                  ;此时dx = rem(H/N) = rem(H/N)*65536的高16位 = [rem(H/N)*65536 + L]高16位
    div cx        ;计算 [rem( H/N) * 65536 + L]/N ，结果的商保存在ax，余数保存在dx
 
                    ;至此，右边项计算完毕，商在ax中，余数在dx中。
                    ;接下来要将两项求和。  左边项的高、低16位都在栈中，
                    ;其中高16位就是最终结果的高16位，低16位是0000H。
                    ;右边项的商为16位，在ax中，也就是最终结果的低16位，
                    ;余数在dx中，也就是最终结果的余数。
    
    mov cx,dx    ;cx = 最终结果的余数
    
    pop bx        ;bx = int(H/N)*65536结果的低16位，即0000H。
    pop dx        ;dx = int(H/N)*65536结果的高16位，即最终结果的高16位
    
    pop bx    ;还原寄存器的值
 
    ret
 
show_str:   ;功能：将str段中首地址为ds:si的字符，以指定颜色显示在屏幕指定位置
                ;参数：dh 行号， dl 列号 ，cl 颜色，
                ;    ds指向str段，si指向str段要显示的字符串首地址
                ;返回：无
    
    push dx        ;将子程序用到的寄存器压入栈
    push si
    push es
    push cx
    push ax
    push bx
    
    mov ax,0B800H    ;设置es为显示区段地址
    mov es,ax
    
    mov ax,00A0H    ;设置首字符显示的地址
    mul dh
    mov dh,0
    add ax,dx 
    add ax,dx
    mov bx,ax    ;bx是显示区的偏移地址
        
    mov al,cl    ;用al存储属性字节
    mov ch,0
    mov si,0
    
    show2:                ;循环读取字符并显示
    mov cl,ds:[si]
    jcxz showpop            ;若读到0，就退出循环
    mov es:[bx],cl
    inc bx
    mov es:[bx],al
    inc bx
    inc si
    jmp short show2
 
    showpop:        ;将寄存器的值pop出来
    pop bx
    pop ax
    pop cx
    pop es
    pop si
    pop dx
    
    ret    ;返回
 
totable:        ;功能：将data段中给定的21年的数据按照指定格式写到table段中 
                ;参数：无
                ;返回：table段中按格式写入了21年的数据（年份、年总收入、雇员人数、人均收入）
    
    push di    ;将用到的寄存器压入栈
    push si
    push bp
    push ax
    push bx
    push cx
    push dx
 
                ;复制 年份 数据
    mov di,0            ;data段当前该复制的数据的偏移地址，设置初始值为data段数据的首地址
    mov si,0            ;索引，table段（es段）当前年份的数据的首地址
    mov bp,4            ;每年的数据所占的字节数，即内循环的次数；
    call copy1            ;调用子程序，复制数据
 
                ;复制 年总收入
    mov si,5            ;索引，table段（es段）当前年份的数据的首地址
    mov bp,4            ;每年的数据所占的字节数，即内循环的次数；
    call copy1
    
                ;复制 雇员人数
    mov si,0aH            ;索引，table段（es段）当前年份的数据的首地址          
    mov bp,2            ;每年的数据所占的字节数，即内循环的次数；
    call copy1
 
                ;计算 人均收入
    mov bx,0                ;第N年
    mov si,0dH            ;索引，table段（es段）当前年份的数据的首地址      
    mov cx,21            ;共有N年
    totable2:
    mov ax,es:[bx+5]        ;取年总收入的低16位
    mov dx,es:[bx+7]        ;取年总收入的高16位
    div word ptr es:[bx+0aH]        ;除法运算，人均收入不超过65535，可以直接运算
    mov es:[bx+si],ax        ;商（即结果取整）写入table段
    add bx,10H            ;年份索引+1，切换到下一年
    loop totable2                 ;计算下一年的数据
 
 
    pop dx    ;将寄存器的值pop出来
    pop cx
    pop bx
    pop ax
    pop bp
    pop si
    pop di
 
    ret
 
copy1:        ;功能：将N年的某项数据按照指定格式复制到table段中 
                ;参数：cx 年份的个数，即外循环的次数； 
                ;    bp 每年的数据所占的字节数，即内循环的次数；
                ;    bx 索引，table段中第N个年份
                ;    di data段当前该复制的数据的偏移地址
                ;    si 索引，table段（es段）当前年份的数据的首地址
                ;返回：table段指定数据项N年的数据 按照格式填写完成
                ;    di 索引，data段当前该复制的数据的偏移地址(因而di不用压入栈)
 
    push bp        ;将用到的寄存器压入栈
    push bx
    push si
    push ax        ;cx会在copy2即外循环中压入栈
 
    mov bx,0        ;bx = 第N个年份的数据
    mov cx,21        ;cx = 外循环的次数
 
    copy2:            
    push cx        ;将外层循环的次数压入栈                 
    mov cx,bp       ;cx = bp = 每年的数据所占的字节数，即内循环的次数；
    
    copy3:            
    mov al,ds:[di]      ;将data段中的字节复制到table段中
    mov es:[bx+si],al
    inc si            ;table段中当前字节索引+1
    inc di            ;data段中当前字节索引+1
    loop copy3       
 
    add bx,10H        ;年份索引+1，即table段中切换到下一年的数据
    sub si,bp        ;table段中当前字节索引回退到初始值
    pop cx            ;pop出外层循环计数器
    loop copy2        ;进行下一年的数据复制 
 
    pop ax            ;程序返回前将寄存器的值pop出来
    pop si    
    pop bx
    pop bp 
 
    ret
 
code ends
end start