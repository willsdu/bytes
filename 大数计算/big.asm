assume cs:code, ds:data

data segment 
   d1 db '223456789012',0
   d2 db '933464565645',0
   d3 db 32 dup(0), 10,'$'
data ends



code segment
start:
    mov ax, data
    mov ds, ax
    mov di, 0

    ;sum two big data
    call big_add
    ;diaplay result
    lea dx, d3
    add dx, bp
    mov ah, 9H
    int 21h
    
    mov ax, 4c00H
    int 21H


big_add:
    push ax
    push bx
    push cx
    push si
    push di
    
    sub ax, ax
    mov si, 0
    mov di, 0


    call leading

    mov si, offset d2 - offset d1 -1
    mov di, offset d3 - offset d2 -1
    mov dl, 0

    big_add_loop: 
    cmp si, 0
    je big_add_left
    mov al, d1[si-1]
    sub al, 30h
    dec si
    jmp short big_add_right_start
    big_add_left:
    mov al, 0

    big_add_right_start:
    cmp di, 0
    je big_add_right
    mov bl, d2[di-1]
    sub bl, 30h
    dec di
    jmp short big_add_com
    big_add_right:
    mov bl, 0

    big_add_com:
    add al, bl
    add al, dl
    cmp al, 10
    jb big_add_rec
    sub al, 10
    mov dl, 1
    jmp short big_add_char

    big_add_rec:
    mov dl, 0
    big_add_char:
    add al, 30h
    mov bp, cx
    mov d3[bp+1], al

    loop big_add_loop
    
    cmp dl, 1
    jne big_add_over
    mov d3[bp], 31h
    
    big_add_over:
    pop di
    pop si
    pop cx
    pop bx
    pop ax

    ret



;leading 
;功能：计算最大长度，结果在cl
;参数：无
;结果: al
leading:
    push ax

    mov ch, 0

    mov al, offset d2- offset d1
    mov ah, offset d3- offset d2
    cmp al, ah
    ja leading_big
    mov cl, ah
    jmp leading_over

    leading_big:
    mov cl, al
    jmp leading_over

    leading_over:
    pop ax

    ret


code ends
end start


