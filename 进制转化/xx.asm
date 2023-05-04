DATAS SEGMENT ;定义数据段代码
	STR1 DB 'Please enter a hexadecimal number',10,'$';定义提示字符串
	STR2 DB 10,'Please enter a right number',10,'$';定义错误提示字符串
DATAS ENDS

STACKS SEGMENT STACK
	DW 8 DUP(?) ;保留8个字变量的位置
STACKS ENDS

CODES SEGMENT
ASSUME CS:CODES,DS:DATAS,SS:STACKS
START: 
	MOV AX,DATAS
	MOV DS,AX ;将数据段的地址赋给DS
	MOV AX,STACKS
	MOV SS,AX ;将栈的段地址赋给SS
	MOV SP,20H ;指出栈顶
	LEA DX,STR1 ;利用LEA直接将STR1的内容赋值到DX中
	MOV AH,9H ;将9H赋值到AH中
	INT 21H ;输出提示字符串
	MOV BX,0 ;将0赋值到BX中
INPUT:
	MOV AH,1H
	INT 21H ;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符
	ADD DX,1 ;输入数字
	CMP AL,0DH
	JE HH ;若判断结果相等，即输入回车时则跳转至HH
JUDGE: 
	CMP AL,'f' ;比较输入的字符和f的ASCII码大小
	JA ERROR ;无符号大于则跳转至ERROR
	CMP AL,'a'
	JNB SIT1 ;无符号不小于则跳转至 SIT1
	CMP AL,'F' ;判断输入的字符是否是A~F
	JA ERROR ;无符号大于则跳转至ERROR
	CMP AL,'A'
	JNB SIT2 ;无符号不小于则跳转至SIT2
	CMP AL,'9' ;判断输入的字符是否是1~9
	JA ERROR ;无符号大于则跳转至ERROR
	CMP AL,'0'
	JNB SIT3 ;无符号不小于则跳转至SIT3
	JMP ERROR ;跳转至ERROR处
SIT1: 
	SUB AL,57H ;若位于a—f 之间，则AL-57H
	JMP TRA ;无条件跳转至TRA
SIT2: 
	SUB AL,37H ;若位于A-F 之间，则AL-37H
	JMP TRA ;无条件跳转至TRA
SIT3: 
	SUB AL,30H ;若为0—9，则AL-30H
	JMP TRA ;无条件跳转至TRA
TRA: 
	ADD DX,1
	MOV AH,0H ;将AH置零
	JE INPUT
	MOV CX,4H ;将循环次数设置为4
S: ROL BX,1 ;将bx左移四位
	LOOP S
	ADD BX,AX
	JMP INPUT ;跳转至输入阶段
HH: 
	MOV AX,BX ;将bx的值赋给ax
	MOV BX,10 ;设置除数为16位，用于解决四位十六进制数字。
	MOV CX,0
CIR: 
	MOV DX,0 ;输入的是四位及以下十六进制数字，因此被除数高位置零
	ADD CX,1 ;为输出时循环结束做准备
	DIV BX ;AX中的数字除以10，ax存储商数，dx中存储余数
	PUSH DX ;之后将余数入栈
	CMP AX,0 ;直到商为0时结束循环
	JNE CIR
NEXT: 
	POP AX ;将余数出栈
	MOV DL,AL ;转入DL 准备输出
	ADD DL,30H ;余数位于1—9 之间，因此需要将AL+30
	MOV AH,2
	INT 21H ;输出该十进制数字
	LOOP NEXT ;根据cx中的值进行循环输出的操作
	JMP STOP ;跳转至STOP
ERROR: ;错误情况处理
	LEA DX,STR2 ;获取STR至DX中
	MOV AH,9H
	INT 21H ;输出该提示语句
	JMP INPUT ;跳转至输入
STOP: 
	MOV AH,4CH
	INT 21H
	CODES ENDS
	END START

