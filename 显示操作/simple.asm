data segment
 str1 db 'Please enter a hexadecimal number',10,'$';定义提示字符串
data ends

code segment
assume cs:code,ds:data

start:
	mov ax, data
	mov ds, ax
	lea dx, str1
	mov ah, 9h
	int 21h

code ends
end start


