[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_load_gdtr
	EXTERN	_load_idtr
	EXTERN	_asm_inthandler0d
	EXTERN	_asm_inthandler20
	EXTERN	_asm_inthandler21
	EXTERN	_asm_inthandler27
	EXTERN	_asm_inthandler2c
	EXTERN	_asm_hrb_api
[FILE "dsctbl.c"]
[SECTION .text]
	GLOBAL	_init_gdtidt
_init_gdtidt:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	MOV	ESI,2555904
	MOV	EBX,8191
L6:
	PUSH	0
	PUSH	0
	PUSH	0
	PUSH	ESI
	ADD	ESI,8
	CALL	_set_segmdesc
	ADD	ESP,16
	DEC	EBX
	JNS	L6
	PUSH	16530
	MOV	ESI,2553856
	PUSH	0
	MOV	EBX,255
	PUSH	-1
	PUSH	2555912
	CALL	_set_segmdesc
	PUSH	16538
	PUSH	2621440
	PUSH	524287
	PUSH	2555920
	CALL	_set_segmdesc
	ADD	ESP,32
	PUSH	2555904
	PUSH	65535
	CALL	_load_gdtr
	POP	EAX
	POP	EDX
L11:
	PUSH	0
	PUSH	0
	PUSH	0
	PUSH	ESI
	ADD	ESI,8
	CALL	_set_gatedesc
	ADD	ESP,16
	DEC	EBX
	JNS	L11
	PUSH	2553856
	PUSH	2047
	CALL	_load_idtr
	PUSH	142
	PUSH	16
	PUSH	_asm_inthandler0d
	PUSH	2553960
	CALL	_set_gatedesc
	PUSH	142
	PUSH	16
	PUSH	_asm_inthandler20
	PUSH	2554112
	CALL	_set_gatedesc
	ADD	ESP,40
	PUSH	142
	PUSH	16
	PUSH	_asm_inthandler21
	PUSH	2554120
	CALL	_set_gatedesc
	PUSH	142
	PUSH	16
	PUSH	_asm_inthandler27
	PUSH	2554168
	CALL	_set_gatedesc
	ADD	ESP,32
	PUSH	142
	PUSH	16
	PUSH	_asm_inthandler2c
	PUSH	2554208
	CALL	_set_gatedesc
	PUSH	142
	PUSH	16
	PUSH	_asm_hrb_api
	PUSH	2554368
	CALL	_set_gatedesc
	LEA	ESP,DWORD [-8+EBP]
	POP	EBX
	POP	ESI
	POP	EBP
	RET
	GLOBAL	_set_segmdesc
_set_segmdesc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	MOV	EDX,DWORD [12+EBP]
	MOV	ECX,DWORD [16+EBP]
	MOV	EBX,DWORD [8+EBP]
	MOV	EAX,DWORD [20+EBP]
	CMP	EDX,1048575
	JBE	L17
	SHR	EDX,12
	OR	EAX,32768
L17:
	MOV	WORD [EBX],DX
	MOV	BYTE [5+EBX],AL
	SHR	EDX,16
	SAR	EAX,8
	AND	EDX,15
	MOV	WORD [2+EBX],CX
	AND	EAX,-16
	SAR	ECX,16
	OR	EDX,EAX
	MOV	BYTE [4+EBX],CL
	MOV	BYTE [6+EBX],DL
	SAR	ECX,8
	MOV	BYTE [7+EBX],CL
	POP	EBX
	POP	EBP
	RET
	GLOBAL	_set_gatedesc
_set_gatedesc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [16+EBP]
	MOV	EBX,DWORD [20+EBP]
	MOV	ECX,DWORD [12+EBP]
	MOV	WORD [2+EDX],AX
	MOV	BYTE [5+EDX],BL
	MOV	WORD [EDX],CX
	MOV	EAX,EBX
	SAR	EAX,8
	SAR	ECX,16
	MOV	BYTE [4+EDX],AL
	MOV	WORD [6+EDX],CX
	POP	EBX
	POP	EBP
	RET
