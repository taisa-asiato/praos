[BITS 32]
	MOV	AL, 'A'
	CALL	2*8:0xbe7

fin:
	HLT
	jmp fin
