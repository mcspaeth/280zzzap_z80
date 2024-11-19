TBLFRA:		; $1553
				.dw			FRA01						; Extended time					
				.dw			FRA02						; Your rating						
				.dw			ENG03						; Score									
				.dw			FRA04						; New record						
				.dw			FRA05						; Shift Low							
				.dw			FRA06						; Shift high						
				.dw			FRA07						; Insert coin						
				.dw			FRA08						; Push button						
				.dw			FRA09						; Game over							
				.dw			ENG0A						; Speedometer						
				.dw			FRA0B						; Time									
				.dw			FRA0C						; High score						
				.dw			FRA0D						; Prev score						
				.dw			ENG0E						; Datsun								
				.dw			FRA0F						; Congrats							
				.dw			ENG10						; Nothing
				.dw			GER11						; Max 160
				.dw			GER12						; Max 120
				.dw			GER13						; Max 80
				.dw			FRA14						; Rate 1
				.dw			FRA15						; Rate 2
				.dw			FRA16						; Rate 3
				.dw			FRA17						; Rate 4
				.dw			FRA18						; Rate 5
				.dw			FRA18						; Rate 5  (duplicate)
				
				.dw			$0000						; Garbage
				.dw			$0000						; Garbage

FRA0B:		; $1589
				.db			$02																			; 2 spaces
				.db			$54, $45, $4d, $50, $53, $3a						; TEMPS:
FRA03:	
				.db			$0b																			; 11 spaces
				.db			$53, $43, $4f, $52, $45, $ba						; SCORE:

FRA01:		; $1597
				.db			$06																			; 6 spaces
				.db			$54, $45, $4d, $50, $53, $40, $53, $55	; TEMPS_SU
				.db			$50, $50, $4c, $45, $4d, $45, $4e, $54	; PPLEMENT
				.db			$41, $49, $52, $c5											; AIRE

FRA05:		; $15ac
				.db			$03																			; 3 spaces
				.db			$50, $41, $53, $53, $45, $5a, $40, $4c	; PASSEZ_L
				.db			$41, $40, $50, $52, $45, $4d, $49, $45	; A_PREMIE
				.db			$52, $45, $40, $56, $49, $54, $45, $53	; RE_VITES
				.db			$53, $c5																; SE

FRA09:		; $15c7
				.db			$0c																			; 12 spaces
				.db			$54, $45, $52, $4d, $49, $4e, $c5				; TERMINE

FRA06:		; $15cf
				.db			$03																			; 3 spaces
				.db			$50, $41, $53, $53, $45, $5a, $40, $4c	; PASSEZ_L
				.db			$41, $40, $53, $45, $43, $4f, $4e, $44	; A_SECOND
				.db			$45, $40, $56, $49, $54, $45, $53, $53	; E_VITESS
				.db			$c5																			; E

FRA0F:		; $15e9
				.db			$02																			; 2 spaces
				.db			$42, $52, $41, $56, $4f, $3f						; BRAVO?
				.db			$02																			; 2 spaces
				.db			$56, $4f, $55, $53, $40, $41, $56, $45	; VOUS_AVE
				.db			$5a, $40, $52, $45, $41, $4c, $49, $53	; Z_REALIS
				.db			$45, $40, $55, $ce											; E_UN

FRA04:		; $1605
				.db			$04																			; 4 spaces
				.db			$4e, $4f, $55, $56, $45, $41, $55, $40	; NOUVEAU_
				.db			$52, $45, $43, $4f, $52, $44, $40, $44	; RECORD_D
				.db			$45, $40, $50, $49, $53, $54, $c5				; E_PISTE

FRA02:		; $161d
				.db			$08				; 8 spaces
				.db			$56, $4f, $54, $52, $45, $40, $43, $41	; VOTRE_CA
				.db			$54, $45, $47, $4f, $52, $49, $45, $ba	; TEGORIE:

FRA14:		; $162e
				.db			$07																			; 7 spaces
				.db			$52, $45, $50, $52, $45, $4e, $45, $5a	; REPRENEZ
				.db			$40, $55, $4e, $45, $40, $4c, $45, $43	; _UNE_LEC
				.db			$4f, $ce				; ON

FRA15:		; $1641
				.db			$0c																			; 12 spaces
				.db			$41, $4d, $41, $54, $45, $55, $d2				; AMATEUR

FRA16:		; $1649
				.db			$0a																			; 10 spaces
				.db			$50, $52, $4f, $46, $45, $53, $53, $49	; PROFESSI
				.db			$4f, $4e, $45, $cc											; ONEL

FRA17:		; $1656
				.db			$0c																			; 12 spaces
				.db			$43, $48, $41, $4d, $50, $49, $4f, $ce	; CHAMPION

FRA18:		; $165f
				.db			$09																			; 9 spaces
				.db			$53, $55, $50, $45, $52, $40, $43, $48	; SUPER_CH
				.db			$41, $4d, $50, $49, $4f, $ce						; AMPION

FRA0C:		; $166e
				.db			$03																			; 3 spaces
				.db			$53, $43, $4f, $52, $45, $40, $41, $40	; SCORE_A_
				.db			$42, $41, $54, $54, $52, $45, $ba				; BATTRE:

FRA0D:		; $167e
				.db			$03																			; 3 spaces
				.db			$53, $43, $4f, $52, $45, $40, $50, $52	; SCORE_PR
				.db			$45, $43, $45, $44, $45, $4e, $54, $ba	; ECEDENT:

FRA07:		; $168f
				.db			$06																			; 6 spaces
				.db			$49, $4e, $54, $52, $4f, $44, $55, $49	; INTRODUI
				.db			$53, $45, $52, $40, $31, $40, $46, $52	; SER_1_FR
				.db			$41, $4e, $c3														; ANC

FRA08:		; $16a3
				.db			$07																			; 7 spaces
				.db			$50, $4f, $55, $53, $53, $45, $5a, $40	; POUSSEZ_
				.db			$4c, $45, $40, $42, $4f, $55, $54, $4f	; LE_BOUTO
				.db			$ce																			; N

				.end
