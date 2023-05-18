DATAS SEGMENT ;定义数据段代码
	STR1 DB 'Please enter a hexadecimal number',10,'$';定义提示字符串
DATAS ENDS

CODES SEGMENT
ASSUME CS:CODES,DS:DATAS
START: 
	MOV AX,DATAS
	MOV DS,AX ;将数据段的地址赋给DS
	LEA DX,STR1 ;利用LEA直接将STR1的内容赋值到DX中
	MOV AH,9H ;将9H赋值到AH中
	INT 21H ;输出提示字符串

CODES ENDS
END START

