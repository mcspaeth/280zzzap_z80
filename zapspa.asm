TBLSPA:		; $16b5
				.dw			SPA01						; Extended time					
				.dw			SPA02						; Your rating						
				.dw			SPA03						; Score									
				.dw			SPA04						; New record						
				.dw			SPA05						; Shift Low							
				.dw			SPA06						; Shift high						
				.dw			SPA07						; Insert coin						
				.dw			SPA08						; Push button						
				.dw			SPA09						; Game over							
				.dw			ENG0A						; Speedometer						
				.dw			SPA0B						; Time									
				.dw			SPA0C						; High score						
				.dw			SPA0D						; Prev score						
				.dw			ENG0E						; Datsun								
				.dw			SPA0F						; Congrats							
				.dw			ENG10						; Nothing
				.dw			GER11						; Max 160
				.dw			GER12						; Max 120
				.dw			GER13						; Max 80
				.dw			SPA14						; Rate 1
				.dw			SPA15						; Rate 2
				.dw			SPA16						; Rate 3
				.dw			SPA17						; Rate 4
				.dw			SPA18						; Rate 5
				.dw			SPA18						; Rate 5  (duplicate)
				.dw			$0000						; Garbage
				.dw			$0000						; Garbage

SPA0B:		; $16eb
				.db			$02																			; 2 spaces
				.db			$54, $49, $45, $4d, $50, $4f, $3a				; TIEMPO:
				.db			$06																			; 6 spaces
				
SPA03:		; $16f4
				.db			$03																			; 3 spaces
				.db			$50, $55, $4e, $54, $45, $4f, $ba				; PUNTEO:

SPA01:		; $16fc
				.db			$08																			; 8 spaces
				.db			$54, $49, $45, $4d, $50, $4f, $40, $45	; TIEMPO_E
				.db			$58, $54, $45, $4e, $44, $49, $44, $cf	; XTENDIDO

SPA05:		; $170d
				.db			$03																			; 3 spaces
				.db			$43, $41, $4d, $42, $49, $45, $4c, $4f	; CAMBIELO
				.db			$40, $41, $40, $4d, $45, $4e, $4f, $53	; _A_MENOS
				.db			$40, $56, $45, $4c, $4f, $43, $49, $44	; _VELOCID
				.db			$41, $c4																; AD

SPA06:		; $1728
				.db			$04																			; 4 spaces
				.db			$43, $41, $4d, $42, $49, $45, $4c, $4f	; CAMBIELO
				.db			$40, $41, $4d, $41, $53, $40, $56, $45	; _AMAS_VE
				.db			$4c, $4f, $43, $49, $44, $41, $c4				; LOCIDAD

SPA09:		; $1740
				.db			$08																			; 8 spaces
				.db			$4a, $55, $45, $47, $4f, $40, $54, $45	; JUEGO_TE
				.db			$52, $4d, $49, $4e, $41, $44, $cf				; RMINADO

SPA0F:		; $1750
				.db			$09																			; 9 spaces
				.db			$46, $45, $4c, $49, $43, $49, $54, $41	; FELICITA
				.db			$43, $49, $4f, $4e, $45, $d3						; CIONES

SPA04:		; $175f
				.db			$05																			; 5 spaces
				.db			$48, $49, $43, $49, $53, $54, $45, $40	; HICISTE_
				.db			$55, $4e, $40, $4e, $55, $45, $56, $4f	; UN_NUEVO
				.db			$40, $52, $45, $43, $4f, $d2						; _RECOR

SPA02:		; $1776
				.db			$0a																			; 10 spaces
				.db			$54, $55, $40, $50, $55, $4e, $54, $45	; TU_PUNTE
				.db			$4f, $40, $45, $d3											; O_ES

SPA14:		; $1783
				.db			$06																			; 6 spaces
				.db			$4c, $4c, $45, $56, $41, $53, $40, $4c	; LLEVAS_L
				.db			$41, $40, $44, $45, $4c, $41, $4e, $54	; A_DELANT
				.db			$45, $52, $c1														; ERA

SPA15:		; $1797
				.db			$07																			; 7 spaces
				.db			$56, $41, $40, $45, $4e, $40, $53, $45	; VA_EN_SE
				.db			$47, $55, $4e, $44, $4f, $40, $4c, $55	; GUNDO_LU
				.db			$47, $41, $d2														; GAR

SPA16:		; $17ab
				.db			$07																			; 7 spaces
				.db			$4c, $4c, $41, $4e, $54, $41, $53, $40	; LLANTAS_
				.db			$43, $41, $4c, $49, $45, $4e, $54, $45	; CALIENTE
				.db			$d3																			; S

SPA17:		; $17bd
				.db			$06																			; 6 spaces
SPA0D:		; $17be
				.db			$03																			; 3 spaces
				.db			$53, $45, $47, $55, $4e, $44, $4f, $40	; SEGUNDO_
				.db			$50, $55, $45, $53, $54, $cf						; PUESTO

SPA18:		; $17cd
				.db			$06																			; 6 spaces
SPA0C:		; $17cE
				.db			$03																			; 3 spaces
				.db			$50, $52, $49, $4d, $45, $52, $40, $50	; PRIMER_P
				.db			$55, $45, $53, $54, $cf									; UESTO

SPA07:		; $17dc
				.db			$08																			; 8 spaces
				.db			$50, $4f, $4e, $47, $41, $40, $4c, $41	; PONGA_LA
				.db			$40, $4d, $4f, $4e, $45, $44, $c1				; _MONEDA

SPA08:		; $17ec
				.db			$08																			; 8 spaces
				.db			$41, $47, $41, $43, $48, $41, $40, $45	; AGACHA_E
				.db			$4c, $40, $42, $4f, $54, $4f, $ce				; L_BOTON

				.end
