TBLGER:		; $13f2
				.dw			GER01						; Extended time					
				.dw			GER02						; Your rating						
				.dw			GER03						; Score									
				.dw			GER04						; New record						
				.dw			GER05						; Shift Low							
				.dw			GER06						; Shift high						
				.dw			GER07						; Insert coin						
				.dw			GER08						; Push button						
				.dw			GER09						; Game over							
				.dw			ENG0A						; Speedometer						
				.dw			GER0B						; Time									
				.dw			GER0C						; High score						
				.dw			GER0D						; Prev score						
				.dw			ENG0E						; Datsun								
				.dw			GER0F						; Congrats							
				.dw			ENG10						; Nothing
				.dw			GER11						; Max 160
				.dw			GER12						; Max 120
				.dw			GER13						; Max 80
				.dw			GER14						; Rate 1
				.dw			GER15						; Rate 2
				.dw			GER16						; Rate 3
				.dw			GER17						; Rate 4
				.dw			ENG18						; Rate 5
				.dw			ENG18						; Rate 5  (duplicate)
				
				.dw			$0087						; Garbage
				.dw			$0000						; Garbage
								
GER11:		; $1428
				.db			$0c																			; 12 spaces
				.db			$31, $36, $30, $40, $4b, $cd						; 160_KM

GER12:		; $142f
				.db			$0c																			; 12 spaces
				.db			$31, $32, $30, $40, $4b, $cd						; 120_KM

GER13:		; $1436
				.db			$0d																			; 13 spaces
				.db			$38, $30, $40, $4b, $cd									; 80_KM

GER01:		; $143c
				.db			$0a																			; 10 spaces
				.db			$5a, $45, $49, $54, $40, $50, $52, $41	; ZEIT_PRA
				.db			$45, $4d, $49, $c5											; EMIE

GER05:		; $1449
				.db			$06																			; 6 spaces
				.db			$47, $41, $4e, $47, $40, $41, $55, $46	; GANG_AUF
				.db			$40, $4c, $4f, $40, $53, $43, $48, $41	; _LO_SCHA
				.db			$4c, $54, $45, $ce											; LTEN

GER06:		; $145e
				.db			$06																			; 6 spaces
				.db			$47, $41, $4e, $47, $40, $41, $55, $46	; GANG_AUF
				.db			$40, $48, $49, $40, $53, $43, $48, $41	; _HI_SCHA
				.db			$4c, $54, $45, $ce											; LTEN

GER07:		; $1473
				.db			$09																			; 9 spaces
				.db			$47, $45, $4c, $44, $40, $45, $49, $4e	; GELD_EIN
				.db			$57, $45, $52, $46, $45, $ce						; WERFEN

GER08:		; $1482
				.db			$09																			; 9 spaces
				.db			$4b, $4e, $4f, $50, $46, $40, $44, $52	; KNOPF_DR
				.db			$55, $45, $43, $4b, $45, $ce						; UECKEN

GER09:		; $1491
				.db			$0b																			; 11 spaces
				.db			$53, $50, $49, $45, $4c, $45, $4e, $44	; SPIELEND
				.db			$c5																			; E

GER0B:		; $149b
				.db			$02																			; 2 spaces
				.db			$5a, $45, $49, $54, $3a									; ZEIT:
				.db			$08																			; 8 spaces
GER03:	
				.db			$03																			; 3 spaces
				.db			$50, $55, $4e, $4b, $54, $45, $ba				; PUNKTE:

GER0C:		; $14aa
				.db			$03																			; 3 spaces
				.db			$48, $4f, $45, $43, $48, $53, $54, $45	; HOECHSTE
				.db			$40, $50, $55, $4e, $4b, $54, $5a, $41	; _PUNKTZA
				.db			$48, $4c, $ba														; HL:

GER0D:		; $14be
				.db			$03																			; 3 spaces
				.db			$4c, $45, $54, $5a, $54, $45, $40, $50	; LETZTE_P
				.db			$55, $4e, $4b, $54, $5a, $41, $48, $4c	; UNKTZAHL
				.db			$ba																			; :

GER0F:		; $14d0
				.db			$02																			; 2 spaces
				.db			$47, $52, $41, $54, $55, $4c, $49, $45	; GRATULIE
				.db			$52, $45, $3f														; RE?
				.db			$02																			; 2 spaces
				.db			$53, $49, $45, $40, $48, $41, $42, $45	; SIE_HABE
				.db			$4e, $40, $45, $49, $4e, $45, $ce				; N_EINEN

GER04:		; $14ec
				.db			$04																			; 4 spaces
				.db			$4e, $45, $56, $45, $4e, $40, $52, $45	; NEVEN_RE
				.db			$4b, $4f, $52, $44, $40, $41, $55, $46	; KORD_AUF
				.db			$47, $45, $53, $54, $45, $4c, $4c, $d4	; GESTELLT

GER14:		; $1505
				.db			$0a																			; 10 spaces
				.db			$31																			; 1
				.db			$02																			; 2 spaces
				.db			$41, $4e, $46, $41, $45, $4e, $47, $45	; ANFAENGE
				.db			$d2																			; R

GER15:		; $1511
				.db			$09																			; 9 spaces
				.db			$32																			; 2
				.db			$02																			; 2 spaces
				.db			$53, $50, $4f, $52, $54, $46, $41, $48	; SPORTFAH
				.db			$52, $45, $d2														; RER

GER16:		; $151f
				.db			$09																			; 9 spaces
				.db			$33																			; 3
				.db			$02																			; 2 spaces
				.db			$52, $45, $4e, $4e, $46, $41, $48, $52	; RENNFAHR
				.db			$45, $d2																; ER

GER17:		; $152c
				.db			$06																			; 6 spaces
				.db			$34																			; 4
				.db			$02																			; 2 spaces
				.db			$47, $52, $41, $4e, $44, $40, $50, $52	; GRAND_PR
				.db			$49, $58, $40, $46, $41, $48, $52, $45	; IX_FAHRE
				.db			$d2																			; R

GER02:		; $1540
				.db			$07																			; 7 spaces
				.db			$52, $41, $4e, $47, $46, $4f, $4c, $47	; RANGFOLG
				.db			$45, $40, $31, $40, $42, $49, $53, $40	; E_1_BIS_
				.db			$35, $ba																; 5:

				.end
