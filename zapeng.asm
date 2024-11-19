TBLENG:		; $124f
				.dw			ENG01						; Extended time
				.dw			ENG02						; Your rating
				.dw			ENG03						; Score
				.dw			ENG04						; New record
				.dw			ENG05						; Shift Low
				.dw			ENG06						; Shift high
				.dw			ENG07						; Insert coin
				.dw			ENG08						; Push button
				.dw			ENG09						; Game over
				.dw			ENG0A						; Speedometer
				.dw			ENG0B						; Time
				.dw			ENG0C						; High score
				.dw			ENG0D						; Prev score
				.dw			ENG0E						; Datsun
				.dw			ENG0F						; Congrats							
				.dw			ENG10						; Nothing
				.dw			ENG11						; Max 160
				.dw			ENG12						; Max 120
				.dw			ENG13						; Max 80
				.dw			ENG14						; Rate 1
				.dw			ENG15						; Rate 2
				.dw			ENG16						; Rate 3
				.dw			ENG17						; Rate 4
				.dw			ENG18						; Rate 5
				.dw			ENG18						; Rate 5  (duplicate)
				
ENG11:		; $1281
				.db			$07																			; 7 spaces
				.db			$4d, $41, $58, $40, $43, $55, $52, $56	; MAX_CURV
				.db			$45, $40, $31, $36, $30, $40, $4d, $50	; E_160_MP
				.db			$48																			; H 
ENG10:	
				.db			$c0																			; _
				
ENG12:		; $1294
				.db			$07																			; 7 spaces
				.db			$4d, $41, $58, $40, $43, $55, $52, $56	; MAX_CURV
				.db			$45, $40, $31, $32, $30, $40, $4d, $50	; E_120_MP
				.db			$c8																			; H

ENG13:		; $12a6
				.db			$07																			; 7 spaces
				.db			$4d, $41, $58, $40, $43, $55, $52, $56	; MAX_CURV
				.db			$45, $40, $40, $38, $30, $40, $4d, $50	; E__80_MP
				.db			$c8																			; H

ENG01:		; $12b8
				.db			$0a																			; 10 spaces
				.db			$45, $58, $54, $45, $4e, $44, $45, $44	; EXTENDED
				.db			$40, $54, $49, $4d, $c5									; _TIME

ENG05:		; $12c6
				.db			$04																			; 4 spaces
				.db			$53, $48, $49, $46, $54, $40, $47, $45	; SHIFT_GE
				.db			$41, $52, $40, $49, $4e, $54, $4f, $40	; AR_INTO_
				.db			$4c, $4f, $57, $40, $53, $50, $45, $45	; LOW_SPEE
				.db			$c4																			; D

ENG06:		; $12e0
				.db			$02																			; 2 spaces
				.db			$53, $48, $49, $46, $54, $40, $54, $4f	; SHIFT_TO
				.db			$40, $48, $49, $47, $48, $40, $46, $4f	; _HIGH_FO
				.db			$52, $40, $4d, $41, $58, $40, $53, $43	; R_MAX_SC
				.db			$4f, $52, $45, $bf											; ORE?

ENG07:		; $12fd
				.db			$0a																			; 10 spaces
				.db			$49, $4e, $53, $45, $52, $54, $40, $43	; INSERT_C
				.db			$4f, $49, $ce														; OIN

ENG08:		; $1309
				.db			$0a																			; 10 spaces
				.db			$50, $55, $53, $48, $40, $42, $55, $54	; PUSH_BUT
				.db			$54, $4f, $ce														; TON

ENG09:		; $1315
				.db			$0c																			; 12 spaces
				.db			$47, $41, $4d, $45, $40, $4f, $56, $45	; GAME_OVE
				.db			$d2																			; R

ENG0A:		; $131f
				.db			$05																			; 5 spaces
				.db			$5b, $3b, $5c, $3b, $5d, $3b, $5e, $3b	; [;\;];^;
				.db			$5f, $3c, $5b, $3c, $5c, $3c, $5d, $3c	; _<[<\<]<
				.db			$5e, $3c, $5f, $3d, $db									; ^<_=[

ENG0B:		; $1335
				.db			$02																			; 2 spaces
				.db			$54, $49, $4d, $45, $3a									; TIME:
				.db			$09																			; 9 spaces
ENG03:	
				.db			$03																			; 3 spaces
				.db			$53, $43, $4f, $52, $45, $ba						; SCORE:

ENG0C:		; $1343
				.db			$03																			; 3 spaces
				.db			$48, $49, $47, $48, $40, $53, $43, $4f	; HIGH_SCO
				.db			$52, $45, $ba														; RE:

ENG0D:		; $134f
				.db			$03																			; 3 spaces
				.db			$50, $52, $45, $56, $49, $4f, $55, $53	; PREVIOUS
				.db			$40, $53, $43, $4f, $52, $45, $ba				; _SCORE:

ENG0E:		; $135f
				.db			$08																			; 8 spaces
				.db			$44, $41, $54, $53, $55, $4e, $40, $32	; DATSUN_2
				.db			$38, $30, $40, $5a, $5a, $5a, $41, $d0	; 80_ZZZAP

ENG0F:		; $1370
				.db			$08																			; 8 spaces
				.db			$43, $4f, $4e, $47, $52, $41, $54, $55	; CONGRATU
				.db			$4c, $41, $54, $49, $4f, $4e, $53, $bf	; LATIONS?

ENG04:		; $1381
				.db			$03																			; 3 spaces
				.db			$59, $4f, $55, $40, $48, $41, $56, $45	; YOU_HAVE
				.db			$40, $53, $45, $54, $40, $41, $40, $4e	; _SET_A_N
				.db			$45, $57, $40, $52, $45, $43, $4f, $52	; EW_RECOR
				.db			$44, $bf																; D?

ENG14:		; $139c
				.db			$0a																			; 10 spaces
				.db			$31																			; 1
				.db			$02																			; 2 spaces
				.db			$52, $4f, $41, $44, $40, $48, $4f, $c7	; ROAD_HOG

ENG15:		; $13a7
				.db			$08																			; 8 spaces
				.db			$32																			; 2
				.db			$02																			; 2 spaces
				.db			$46, $45, $4e, $44, $45, $52, $40, $42	; FENDER_B
				.db			$45, $4e, $44, $45, $d2									; ENDER

ENG16:		; $13b7
				.db			$09																			; 9 spaces
				.db			$33																			; 3
				.db			$02																			; 2 spaces
				.db			$48, $4f, $54, $40, $57, $48, $45, $45	; HOT_WHEE
				.db			$4c, $d3																; LS

ENG17:		; $13c4
				.db			$0a																			; 10 spaces
				.db			$34																			; 4
				.db			$02																			; 2 spaces
				.db			$50, $52, $4f, $40, $52, $41, $43, $45	; PRO_RACE
				.db			$d2																			; R

ENG18:		; $13d0
				.db			$0a																			; 10 spaces
				.db			$35																			; 5
				.db			$02																			; 2 spaces
				.db			$43, $48, $41, $4d, $50, $49, $4f, $ce	; CHAMPION

ENG02:		; $13db
				.db			$06																			; 6 spaces
				.db			$59, $4f, $55, $52, $40, $52, $41, $54	; YOUR_RAT
				.db			$49, $4e, $47, $40, $31, $40, $54, $4f	; ING_1_TO
				.db			$40, $35, $ba														; _5:

				.db			$00, $00, $00														; Garbage

				.end
