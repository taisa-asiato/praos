; haribote-ipl
; TAB=4

CYLS	EQU	9	; どこまで読み込むか


		ORG		0x7c00			; このプログラムがどこに読み込まれるのか

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; ブートセクタの名前を自由に書いてよい（8バイト）
		DW		512				; 1セクタの大きさ（512にしなければいけない）
		DB		1				; クラスタの大きさ（1セクタにしなければいけない）
		DW		1				; FATがどこから始まるか（普通は1セクタ目からにする）
		DB		2				; FATの個数（2にしなければいけない）
		DW		224				; ルートディレクトリ領域の大きさ（普通は224エントリにする）
		DW		2880			; このドライブの大きさ（2880セクタにしなければいけない）
		DB		0xf0			; メディアのタイプ（0xf0にしなければいけない）
		DW		9				; FAT領域の長さ（9セクタにしなければいけない）
		DW		18				; 1トラックにいくつのセクタがあるか（18にしなければいけない）
		DW		2				; ヘッドの数（2にしなければいけない）
		DD		0				; パーティションを使ってないのでここは必ず0
		DD		2880			; このドライブ大きさをもう一度書く
		DB		0,0,0x29		; よくわからないけどこの値にしておくといいらしい
		DD		0xffffffff		; たぶんボリュームシリアル番号
		DB		"HARIBOTEOS "	; ディスクの名前（11バイト）
		DB		"FAT12   "		; フォーマットの名前（8バイト）
		RESB	18				; とりあえず18バイトあけておく

; プログラム本体

entry:
		MOV		AX,0			; レジスタ初期化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; ディスクを読む
		MOV		AX, 0x0820
		MOV		ES, AX
		MOV		CH, 0	; シリンダ0
		MOV		DH, 0	; ヘッド0
		MOV		CL, 2	; セクタ2
		MOV		BX, 18*2*CYLS-1
		CALL		readfast	; 高速読み込み
	
; 読み終わったのでharibote.sysを実行
		MOV		BYTE [0x0ff0], CYLS	; IPLがどこまで読んだかmemo 
		JMP		0xc200

error:
		MOV		AX, 0
		MOV		ES, AX
		MOV		SI, msg

putloop:
		MOV		AL, [SI]
		ADD		SI, 1		; SIに1足す
		CMP		AL, 0
		JE		fin
		MOV		AH, 0x0e	; 一文字表示ファンクション
		MOV		BX, 15		; カラーコード
		INT		0x10 		; ビデオBIOS読み出し
		JMP		putloop
fin:
		HLT
		JMP		fin

msg:
		DB		0x0a, 0x0a	; 改行を2つ
		DB		"loda error"
		DB		0x0a
		DB		0

readfast:	; ALを使用してできるだけまとめて読出
; ES:読み込み番地, CH;シリンダ DH:ヘッド CL:セクタ BX:読み込むセクタ数
		MOV		AX,ES	; < ESからALの最大値を計算 >
		SHL		AX, 3	; AXを32で割って, その結果をAHに入れる( SHLは左シフト命令 )
		AND		AH, 0x7f ; AHはAHを128で割ったあまり
		MOV		AL,128
		SUB		AL, AH

		MOV		AH, BL
		CMP		BH, 0
		JE		.skip1
		MOV		AH, 18
.skip1:
		CMP		AL, AH
		JBE		.skip2
		MOV		AL, AH
.skip2:
		MOV		AH, 19
		SUB		AH, CL
		CMP		AL, AH
		JBE		.skip3
		MOV		AL, AH
.skip3:
		PUSH		BX
		MOV		SI, 0
retry:
		MOV		AH, 0x02
		MOV		BX, 0
		MOV		DL, 0x00
		PUSH		ES
		PUSH		DX
		PUSH		CX
		PUSH		AX
		INT		0x13
		JNC		next
		ADD		SI, 1
		CMP		SI, 5
		JAE		error
		MOV		AH, 0x00
		MOV		DL, 0x00
		INT		0x13
		POP		AX
		POP		CX
		POP		DX
		POP		ES
		JMP		retry
next:
		POP		AX
		POP		CX
		POP		DX
		POP		BX
		SHR		BX, 5
		MOV		AH, 0
		ADD 		BX, AX
		SHL		BX, 5
		MOV		ES, BX
		POP		BX
		SUB		BX, AX
		JZ		.ret
		ADD		CL, AL
		CMP		CL, 18
		JBE		readfast
		MOV		CL, 1
		ADD		DH, 1
		CMP		DH, 2
		JB		readfast
		MOV		DH, 0
		ADD		CH, 1
		JMP		readfast
.ret:
		RET

		RESB		0x7dfe-$

		DB		0x55, 0xaa
