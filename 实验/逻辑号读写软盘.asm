assume cs:code

data segment
  db 5000 dup(0)
data ends

code  segment
start:

    mov ax, 0b800h
    mov es, ax
    mov bx, 0

    mov ah, 1
    mov al, 8
    mov dx, 16 
    call rw_floppy

    mov ax, data
    mov es, ax
    mov bx, 0

    mov ah, 0
    mov al, 8
    mov dx, 16
    call rw_floppy

    mov ax, 4c00H
    int 21h



;功能，通过编号读写扇区，一个2880个扇区
; 参数说明:
;(1) 用 ah 寄存器传递功能号: 0 表示读，1 表示写;
;(2) 用 dx 寄存器传递要读写的扇区的逻辑扇区号;
;(3) 用 es:bx 指向存储读出数据或写入数据的内存区。
;(4) 用 al 传递需要读写的扇区数量 

;入口参数:
;(al)-写入的扇区数
;(ch)-磁道号
;(cl)扇区号
;(dh)-头(面)(dI)器号软驱从0开始，0:软驱 A，1: 软驱 B硬盘从 80h 开始，80h: 硬盘 C，81h: 硬盘 Des:bx 指向将写入磁盘的数据
;返回参数:
;操作成功:(ah)-0，(al)-写入的扇区数
;操作失败:(ah)-出错代码
rw_floppy:
    push bx
    push cx
    push dx
    
    push ax
    mov ax, dx
    mov dx, 0
    mov cx, 1440
    div cx
    push ax  ;商是扇面号
    mov ax, dx
    mov dx, 0
    mov cx, 18
    div cx

    mov cl, dl
    mov ch, al
    pop ax
    mov dh, al
    mov dl, 0
    pop ax
    add ah, 2

    int 13h

    pop dx
    pop cx
    pop bx

    ret

code ends
end start