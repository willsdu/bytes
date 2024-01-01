assume cs:code, ds:data

;将下面的字符串以0结尾的字符串中的小写字母转换成大写字母

data segment 
    db "Beginner's All-purpose Symbolic Instruction Code.",0,'$'
data ends


code segment
start:
    mov ax, data
    mov ds, ax

    call letterc

    mov dx, 0
    mov ah, 9H
    int 21h

    mov ax, 4c00H
    int 21H

;功能：将ds所在的字符串中的小写字母转转成大写字母
;参数：ds:si 
;返回值： 无
letterc:
    push ax
    push si

    mov si, 0
letterc_start:
    inc si 
    mov al, ds:[si]
    cmp al, 0
    je letterc_end
    sub al, 61h
    jc letterc_start
    sub al, 1ah
    jnc letterc_start
    mov al, ds:[si]
    sub al, 20H
    mov ds:[si], al
    jmp short letterc_start

letterc_end:
    pop si
    pop ax

    ret

code ends
end start