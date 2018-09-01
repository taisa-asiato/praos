; haribote-os
; TAB=4
; BOOT_INFO関係
CYLS	EQU	0x0ff0		; ブートセクタが設定する
LEDS	EQU	0x0ff1
VMODE	EQU	0x0ff2		; 色数に関する情報
SCRNX	EQU	0x0ff4		; 横軸の解像度
SCRNY	EQU	0x0ff6		; 縦軸の解像度
VRAM	EQU	0x0ff8		; グラフィックバッファの開始アドレス


		ORG		0xc200			; このプログラムがどこに読み込まれるのか

		MOV		AL, 0x13
		MOV		AH, 0x00
		INT		0x10
		MOV		BYTE [VMODE], 8
		MOV		WORD [SCRNX], 320
		MOV		WORD [SCRNY], 200
		MOV		DWORD [VRAM], 0x000a0000

		; キーボードの状態をBIOSに教えてもらう
		MOV		AH, 0x02
		INT		0x16
		MOV		[LEDS], AL

fin:
		HLT
		JMP		fin
