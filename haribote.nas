; haribote-os
; TAB=4
; BOOT_INFO�֌W
CYLS	EQU	0x0ff0		; �u�[�g�Z�N�^���ݒ肷��
LEDS	EQU	0x0ff1
VMODE	EQU	0x0ff2		; �F���Ɋւ�����
SCRNX	EQU	0x0ff4		; �����̉𑜓x
SCRNY	EQU	0x0ff6		; �c���̉𑜓x
VRAM	EQU	0x0ff8		; �O���t�B�b�N�o�b�t�@�̊J�n�A�h���X


		ORG		0xc200			; ���̃v���O�������ǂ��ɓǂݍ��܂��̂�

		MOV		AL, 0x13
		MOV		AH, 0x00
		INT		0x10
		MOV		BYTE [VMODE], 8
		MOV		WORD [SCRNX], 320
		MOV		WORD [SCRNY], 200
		MOV		DWORD [VRAM], 0x000a0000

		; �L�[�{�[�h�̏�Ԃ�BIOS�ɋ����Ă��炤
		MOV		AH, 0x02
		INT		0x16
		MOV		[LEDS], AL

fin:
		HLT
		JMP		fin
