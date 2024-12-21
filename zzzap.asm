				;; IORd
				;; 00						= Start / Coin / Shift / Pedal
				;; 01						= Steering
				;; 02						= DIPs
				;;

				;; Memory
				;; 2000-2001		= "Car" location -- shifts pylons
				;; 2002					= ??
				;; 2003					= ?? Index into $2245 table
				;; 2004-2005		= ?? ($2000-2001) + offset stored here
				;; 2006					= New pylon height
				;; 2007					= New pylon width
				;; 2008					= Value from $2245 table
				;; 2009-200C		= PRNG?
				;; 2020					= IN0 store for IRQ
				;; 2021					= Coin flag?
				;; 2022					= Game state (D7 set = do big gfx?)
				
				;; 2023					= 00 = Attract, 01/02 = game play, 03 = extended time
				
				;; 2024					= Toggles $00/$01 in IRQ
				;; 2025-2026		= Pointer to 5-byte tables for pylons
				;; 2027-2028		= Pointer to 5-byte tables for pylons
				;; 2029-202A		= Previous score
				;; 202B-202C		= High score
				;; 202D					= Write value for audio port too (when 202E hits $00)
				;; 202E					= Timer for audio port 2
				;; 202F					= Coins

				;; 2032-2033		= Score in hex
				;; 2034					= Tick counter for ratings
				;; 2035					= # of crashes

				;; 4 bytes set together in $1037?
				;; 2036					= ??
				;; 2037					= ??
				;; 2038					= ??
				;; 2039					= ?? (Copied to $204A)
				
				;; 203A					= Steering value ($3F-$C0)
				
				;; 203B-203C		= Track location?
				;; 203D-203E		= Score in BCD
				;; 203F					= Countdown timer
				;; 2040					= Countdown timer
				;; 2041					= Countdown timer ($3C to $00 = 1 second)
				;; 2042					= Game time
				;; 2044					= Bonus time
				;; 2045					= IN0 store (Inputs)
				;; 2046					= IN1 store (Steering)
				;; 2047-2048		= 
				;; 2049-204A		= ?? (Coped from $2039, tested at $100f)

				;; 9-byte structure for timed animation
				;; 204B					= Down counter
				;; 204C					= Adder for ($2054)
				;; 204D-204E		= Pointer to next ($204B-$2053)

				;; 5-byte sub-structure
				;; 204F					= Down counter
				;; 2050-2051		= Gfx table entry
				;; 2052-2053		= Pointer to next ($204F-$2053)
				
				;; 2054					= ??
				;; 2055					= Big gfx shift
				;; 2056-2057		= Big gfx loc offset

				;; 2058-2059		= Big gfx loc store
				
				;; 205a					= ?? (added to $213E?)
				
				;; 205B					= Loc 0 string ( $2400 = Top of screen )
				;; 205C					= Loc 1 string ( $3840 = 3 from bottom )
				;; 205D					= Loc 2 string ( $3ac0 = 2 from bottom )
				;; 205E					= Loc 3 string ( $3ca0 = 1 from bottom )
				;; 205F					= Loc 4 string ( $3e80 =        bottom )

				;; 2060-2061		= Pylon to update?
				
				;; 5-byte Pylon table
				;; 0		= Width (0 = inactive);
				;; 1		= Height
				;; 2		= X Shift
				;; 3-4	= Screen address

				;; 2062-20CF		= $16 x 5 byte pylon table (initial $2027)
				;; 20D0-213D		= $16 x 5 byte pylon table (initial $2025)

				;; 213E					= Current speed (hex)
				;; 213F					= ?? (Sets $50 at start)
				;; 2141					= ??
				;; 2142					= Current speed thermometer
				
				;; 2143					= Counts $03, $02, $01, $00, (action on reset)

				;; 2144					= Seed value for tables ($35)

				;; Road data in $20 byte chunks?
				;; 2145-2244		= + decoded values
				;; 2245-2344		= - decoded values

				;; ????-23FF		= Stack
				
				;; 2400-3FFF		= (Visible screen)


				;; rst $00
				;; Reset vector

				.org $0000
L0000:
				nop
				nop
				xor			a
L0003:
				out			($05),a					; Audio Port 2
				jp			L0064

				;; rst $08
				;; Interrupt vector
L0008:
				push		af
				push		bc
				push		de
				ld			c,$00						; Interrupt type
				jp			L069E

				;; rst $10
				;; Interrupt vector
L0010:
				push		af
				push		bc
				push		de
				ld			c,$01						; Interrupt type
				jp			L069E

				;; rst $18
L0018:
				;; Stack regs 
				ex			(sp),hl
				push		de
				push		bc
				push		af
				jp			(hl)						; Return to calling address

				;; "4" byte table for $0bed
				;; Extended time (0x03 = None)
L001D:
				.db			$25, $30, $20		; Extended time table

L0020:
				;; rst $20
				;; Unstack regs and rts
				pop			hl							; (Calling adddress thrown away)
				pop			af
				pop			bc
				pop			de
				pop			hl
				ret

				;; Garbage
				.db			$35, $00				; Garbage?

L0028:
				;; rst $28
				jp			L0F16

				;; 5-byte entry
L002B:
				.db			$05							; $204F   (Down counter)
				.dw			L04B4						; $2050-1 (Gfx table)
				.dw			L0414						; $2052-3 (Next pointer)

				;; rst $30
				;; Update string entry (a&$E0) >> 5
L0030:
				ex			(sp),hl
				ld			a,(hl)					; Grab argument from call
				inc			hl
				ex			(sp),hl					; Restore stack pointer

				call		L0F91						; Exit if message didn't change
				
				ld			(hl),a					; store a in table
				rst			$18							; Stack regs
				ld			hl,$205E				; $205E = String loc 3
				ld			a,(hl)
				inc			hl							; $205F = String loc 4
				or			(hl)
				and			$1F							; Either string set?
				jp			z,L005D					; Jump if both messages clear

				ld			bc,$1DFF				;	Bottom d29 lines white
				call		L0162						; Write c from bottom of screen b*32 times

				ld			hl,$205E
				ld			a,(hl)
				call		L0F5E						; String @ loc from a
				inc			hl							; $205F
				ld			a,(hl)
				call		L0F5E						; String @ loc from a
				rst			$20							; Unstack regs (and return)

				;; White out bottom 29 lines of screen ( to prepare for string draw )
L0057:
				ld			bc,$1DFF				;	Bottom d29 lines white
				jp			L0162						; Write c from bottom of screen b*32 times
				;; And return


				;; Black out bottom 29 lines of screen
L005D:
				ld			bc,$1D00				; Bottom d19 lines black
				call		L0162						; Write c from bottom of screen b*32 times

				rst			$20							; Unstack regs (and return)


				;; Code start
L0064:
				in			a,($02)					; IN2
				and			$0C							; Mask game time
				cp			$04
				jp			nz,L0B61				; Not test mode

				;; Test mode
				ld			b,$01						; Initial bit to test
				ld			de,$0000				; Odd/even errors
L0072:
				ld			hl,$2000
L0075:
				out			($07),a					; Watchdog

				;; Bitwise RAM test
				ld			(hl),b					; Write
				ld			a,(hl)					; Read
				xor			b								; Compare
				jp			z,L008C					; OK

				;; RAM Error
				ld			c,a
				ld			a,l
				and			$01
				ld			a,c
				jp			nz,L008A				; Odd address

				;; Even RAM error
				or			d
				ld			d,a							; Set even errot bits?
				jp			L008C

				;; Odd RAM error
L008A:
				or			e
				ld			e,a							; Set odd error bits?

L008C:
				inc			hl
				ld			a,h
				cp			$40							; End of RAM?
				jp			nz,L0075				; Loop

L0093:
				out			($07),a					; Watchdog

				dec			hl
				ld			a,h
				cp			$1F
				jp			z,L00C9					; Done

				ld			a,(hl)
				xor			b
				jp			z,L00B0					; OK

				ld			c,a
				ld			a,l
				and			$01
				ld			a,c
				jp			nz,L00AE				; Odd address

				;; Even RAM error
				or			d
				ld			d,a							; Set even error bits
				jp			L00B0

				;; Odd RAM error
L00AE:
				or			e
				ld			e,a							; Set odd error bits

L00B0:
				ld			a,b
				cpl
				ld			(hl),a					; Write
				xor			(hl)						; Read/write
				jp			z,L0093					; OK = Loop

				ld			c,a
				ld			a,l
				and			$01
				ld			a,c
				jp			nz,L00C4				; Odd address

				;; Even RAM error
				or			d
L00C0:
				ld			d,a							; Set even error bits
				jp			L00C6

				;; Odd RAM error
L00C4:
				or			e
				ld			e,a							; Set odd error bits
L00C6:
				jp			L0093						; Loop

				;; RAM test continues
L00C9:
				out			($07),a					; Watchdog

				inc			hl
				ld			a,h
				cp			$40
				jp			z,L00EC					; Done

				ld			a,b
				cpl
				xor			(hl)
				jp			z,L00E7					; OK

				ld			c,a
				ld			a,l
				and			$01
				ld			a,c
				jp			nz,L00E5				; Odd address
L00E0:
				or			d
				ld			d,a							; Set even error bits
				jp			L00E7

L00E5:
				or			e
				ld			e,a							; Set odd error bits

L00E7:
				xor			a
				ld			(hl),a					; Clear RAM
				jp			L00C9						; Loop

				;; RAM test bit loop complete
L00EC:
				ld			a,b
				rlca
				ld			b,a
				jp			nc,L0072				; Loop for other bits

				ld			a,d
				or			e
				jp			z,L011B					; RAM check OK

				ex			de,hl
				ld			sp,hl						; Stash de in sp

				ld			de,$2000
				ld			b,$00
L00FE:
				ld			hl,L0000
				add			hl,sp						; hl = sp
				ld			c,$10
L0104:
				xor			a
				add			hl,hl						; hl = 2*sp
				jp			c,L010A
				cpl											;	a=$FF
L010A:
				ld			(de),a					; de=$2000
				inc			de							; de=$2001
				ld			a,$18
				ld			(de),a
				inc			de
				dec			c
				jp			nz,L0104				; Loop
				dec			b
				jp			nz,L00FE				; Loop

				jp			L0154						; ERROR

L011B:
				ld			sp,$2400				; Reset stack pointer
				ld			hl,$280C
				push		hl

				;; ROM Checksum
				ld			hl,L0000				; Start address
				ld			de,L0159				; Bad ROM codes
L0128:
				ld			bc,$0400				; Count 
				xor			a								; a=0 
L012C:
				add			a,(hl)
				out			($07),a					; Watchdog
				inc			hl
				dec			c
				jp			nz,L012C				; Loop for $100
				dec			b
				jp			nz,L012C				; Loop for $400 bloack 
				and			a								; Should be zero! 
				jp			z,L0146

				ld			a,(de)					; Bad ROM code 
				ex			(sp),hl					; hl to top of stack
				ex			de,hl						; de = old stack top
				push		bc
				call		L0381						; Draw char from A 

				pop			bc
				ex			de,hl						; hl = old stack top
				ex			(sp),hl					; Swap back
L0146:
				inc			de							; Next code 
				ld			a,h
				cp			$18							; End of ROMs
				jp			nz,L0128				; Loop

				pop			hl							; Should still be $280C
				ld			a,l
				cp			$0C
				jp			z,L0000					; Reset

				;; Stop on RAM/ROM Error
L0154:
				out			($07),a					; Watchdog
				jp			L0154						; Spin forever

				;; Bad ROM codes
L0159:
				.db			"HGFEDC"				; HGFEDC


				;; Clear screen ($2400-$3FFF)
L015F:
				ld			bc,$E000				; 00 pushed E0 times

				;; bc passed in?
				;; b -> a for loop count
				;; c -> b for value to write
L0162:
				ld			de,$4000				; Address
				
				;; de = adddress passed in
L0165:
				ld			hl,$0000
				add			hl,sp						; hl = sp
				ex			de,hl						; hl = $4000, de = original sp
				di											; Disable interrtups (since stack gets trashed)
				ld			sp,hl						; hl = sp, sp = $4000
				ex			de,hl						; de = sp, hl = original sp
				ld			a,b							; a = b (Loop count)
				ld			b,c							; c = b (value to write)

				;; Push		bc 16*a times
L016F:
				push		bc							; 0
				push		bc							; 1
				push		bc							; 2
				push		bc							; 3
				push		bc							; 4
				push		bc							; 5
				push		bc							; 6
				push		bc							; 7
				push		bc							; 8
				push		bc							; 9
				push		bc							; a
				push		bc							; b
				push		bc							; c
				push		bc							; d
				push		bc							; e
				push		bc							; f
				dec			a
				jp			nz,L016F				; Loop
				ld			sp,hl						; Restore SP
				ei											; Enable interrupts
				ret

#include "zapfont.asm"

				;; Draw BCD w/ leading space
L0366:
				ld			a,(hl)
				and			$F0							; Mask high hybble 
				jp			nz,L0375				; Jump if non-zero 
				ld			a,$40
				call		L0381						; Draw char from A 
				jp			L037C

				;; Draw BCD w/ leading zero
L0374:
				ld			a,(hl)
L0375:
				rlca
				rlca
				rlca
				rlca
				call		L037D

				;; Draw single BCD digit form hl
L037C:
				ld			a,(hl)

				;; Draw single BCD digit from a
L037D:
				and			$0F							; Mask low nybble 
				add			a,$30						; BCD to char code 

				;; Draw char from a
L0381:
				and			$7F							; Clear high bit 
				cp			$30
				ld			b,$00
				jp			nc,L038F				; a>=$30

				;; a<$30 = # of spaces
				ld			c,a
				ex			de,hl						; de=de+a 
				add			hl,bc
				ex			de,hl
				ret

				;; Draw char from a at de
L038F:
				push		hl
				push		de							; Screen loc 
				call		L03B2						; Get table entry for char in a 
				ld			a,h							; hl = screen loc on return
				cp			$3B
				ld			a,$00
				jp			c,L039D					; Not bottom area of screen

				cpl
L039D:
				ld			c,a							; a=$00 or $FF
L039E:
				push		bc
				ld			a,(de)					; Data from table
				inc			de
				xor			c								; Invert for bottom area
				ld			(hl),a
				ld			bc,$0020				; Row increment
				add			hl,bc
				pop			bc
				dec			b
				jp			nz,L039E				; Loop for char
				pop			de
				inc			de
				pop			hl
				ret


				;; Get char table entry for char 'a'
L03B0:
				ld			b,$00
L03B2:
				sub			$30
				ld			c,a							; Stash a
				ld			h,b							; bc = a  
				ld			l,c							; hl = a
				add			hl,hl						; hl = 2*a
				add			hl,hl						; hl = 4*a
				add			hl,hl						; hl = 8*a
				add			hl,bc						; hl = 9*a
				add			hl,bc						; hl = 10*a
				ld			bc,L0186				; Start of char table
				add			hl,bc						; hl = $0186 + 10*a
				ld			b,$0A						; Byte count
				ex			de,hl						; de = $0186 + 10*a
				ret

				;; Draw crash message
L03C4:
				call		L1088						; Kick PRNG, get #
				and			$1C							; Mask by 0x07 << 3
				ld			c,a
				ld			b,$00
				ld			hl,L0FA5				; Crash string table
				add			hl,bc

				;; Draw 4 char string BIG
				ld			de,$2800				; Screen loc?
				ld			b,$04						; 4 Chars
L03D5:
				call		L03E2						; Draw 1 big char
				ld			a,e
				add			a,$08
				ld			e,a							; de+=8
				inc			hl							; Next char
				dec			b
				jp			nz,L03D5				; Loop
				ret

				;; Draw 1 char 64x64 for crash
L03E2:
				ld			a,(hl)					; Get char
				rst			$18							; Stack regs
				call		L03B0						; Get table entry for char to de
L03E7:
				push		hl
				ld			a,(de)					; Get byte for char
				inc			de
L03EA:
				rra
				call		c,L03FA					; Draw if bit set
				inc			hl
				and			a
				jp			nz,L03EA				; No remaining bits set
				pop			hl
				inc			h
				dec			b
				jp			nz,L03E7
				rst			$20							; Unstack regs (and return)

				;; 17 bytes here
				;; Draw 8x8 8x8 block at hl
L03FA:
				push		hl
				push		de
				push		bc
				push		af
				ld			bc,$08FF				; Count + Data
				ld			de,$0020				; Line increment
L0404:
				ld			(hl),c
				add			hl,de
				dec			b
				jp			nz,L0404
				rst			$20							; Unstack regs (and return)


				;; Flag guy animation control
L040B:													; 9b table
				.db			$6d							; $204B (Down counter)
				.db			$FF							; $204C (Adder for $2054)
				.dw			L0419						; $204D-E (Next pointer)

L040F:													; 5b table
				.db			$05							; $204F (Down counter)
				.dw			L043E						; $2050-1 (Gfx table)
				.dw			L002B						; $2052-3 (Next pointer)

L0414:													; 5b table
				.db			$05							; $204F (Down counter)
				.dw			L0527						; $2050-1 (Gfx table)
				.dw			L040F						; $2052-3 (Next pointer)

L0419:													; 9b table
				.db			$3b							; $204B (Down counter)
				.db			$00							; $204C (Adder for $2054)
				.dw			L0427						; $204D-E (Next pointer)
				.db			$13							; $204F (Down counter)
				.dw			L059D						; $2050-1 (Gfx table)
				.dw			L0422						; $2052-3 (Next pointer)

L0422:													; 5b table
				.db			$27							; $204F (Down counter)
				.dw			L061D						; $2050-1 (Gfx table)
				.dw			L0422						; $2052-3 (Next pointer)

L0427:													; 9b table
				.db			$36							; $204B (Down counter)
				.db			$fe							; $204C (Adder for $2054)
				.dw			L0435						; $204D-E (Next pointer)
L042B:													; 5b table
				.db			$03							; $204F (Down counter)
				.dw			L043E						; $2050-1 (Gfx table)
				.dw			L0430						; $2052-3 (Next pointer)

L0430:													; 5b table
				.db			$03							; $204F (Down counter)
				.dw			L04B4						; $2050-1 (Gfx table)
				.dw			L0439						; $2052-3 (Next pointer)

L0435:													; 9b table
				.db			$7f							; $204B (Down counter)
				.db			$00							; $204C (Adder for $2054)
				.dw			L0000						; $204D-E (Next pointer)
L0439:
				.db			$03							; $204F (Down counter)
				.dw			L0527						; $2050-1 (Gfx table)
				.dw			L042B						; $2052-3 (Next pointer)

#include "zapgfx.asm"

L069D:
				.db			$E0							; Garbage?

				;; Common interrupt routine
L069E:
				push		hl
				in			a,($00)					; IN0
				ld			b,a							; Stash read value
				in			a,($00)					; IN0
				xor			b
				and			$40							; Mask COIN
				jp			nz,L06BE				; Bit 6 unstable

				ld			a,b							; Restore read value
				ld			hl,$2020
				xor			(hl)						; xor
				ld			(hl),b					; Store new value
				and			$40							; Mask COIN
				jp			z,L06BE					; No change

				ld			a,b							; Restore read value
				and			$40
				jp			nz,L06BE				; Not pressed

				inc			hl							; == $2021
				ld			(hl),$01				; Set coin flag?

L06BE:
				ld			hl,$2024
				ld			a,(hl)
				xor			c								; c=0 for rst $08, 1 for rst $10
				jp			nz,L06DA				; Do nothing for rst $08, ($2024)==$00

				ld			a,(hl)
				ld			hl,L06D2				; Return address
				push		hl
				and			a
				jp			nz,L088B				; For ($2024)!=$00
				jp			L06E0						; rst $10, ($2024)==$00

				;; Return address for IRQs
				;; Flip $2024 LSB
L06D2:
				ld			hl,$2024
				ld			a,(hl)
				inc			a
				and			$01
				ld			(hl),a

				;; End of IRQ routine
L06DA:
				pop			hl
				pop			de
				pop			bc
				pop			af
				ei
				ret


L06E0:
				ld			a,($2022)				; Game state
				and			a
				jp			m,L0A9D					; D7 set = do big gfx in attract

				ret			z								; Do nothing if zero

				rrca
				jp			nc,L0831				; Jump if even

				;; Redo pylons
				ld			hl,($2027)			; Pointer to set of pylons
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?

				ld			bc,$0020				; Row increment
				call		L09E5						; Erase small pylon?
				call		L09E5						; Erase small pylon?
				call		L09E5						; Erase small pylon?
				call		L09E5						; Erase small pylon?
				call		L09E5						; Erase small pylon?
				call		L09E5						; Erase small pylon?

				ld			hl,($2025)			; Pointer to set of pylons
				call		L09FB						; Draw big pylon 
				call		L09FB						; Draw big pylon 
				call		L09FB						; Draw big pylon 
				call		L09FB						; Draw big pylon 
				call		L09FB						; Draw big pylon 
				call		L09FB						; Draw big pylon 

				call		L0A33						; Draw small pylon
				call		L0A33						; Draw small pylon
				call		L0A33						; Draw small pylon
				call		L0A33						; Draw small pylon
				call		L0A33						; Draw small pylon
				call		L0A33						; Draw small pylon

				call		L08EF

				;; Decrement $2143 timer, reset act on overflow
				;; Only adjust speed every 4th cycle?
				ld			a,($213E)				; Current speed
				ld			hl,$2143
				dec			(hl)
				jp			p,L076D					; Skip if no overflow

				ld			(hl),$03
				ld			hl,$213E				; Current speed
				ld			a,(hl)
				inc			hl							; hl = $213F
				cp			(hl)
				jp			z,L076D					; Skip if zero

				jp			c,L0766					; Jump if <

				cp			$04
				jp			nc,L0761				; a>4
				xor			a								; a=0
				jp			L076B
				
L0761:
				sub			$04
				jp			L076B
				
L0766:
				ld			e,a
				ld			a,($205A)
				add			a,e
				
L076B:
				dec			hl							; hl = $213E
				ld			(hl),a					; Current speed

L076D:
				ld			e,a							; a = ($213E)
				ld			d,$00						; de = (Current speed)
				ld			hl,($2047)
				ld			a,h
				and			a
				jp			z,L077C
				
				add			hl,de
				ld			($2047),hl			; ($2049-4A) += current speed
L077C:
				ld			hl,($2049)
				ld			a,h
				and			a
				jp			z,L0788
				
				add			hl,de
				ld			($2049),hl			; ($2049-4A) += current speed

				;; ($203B) += ($213E)<<4
L0788:
				ex			de,hl						; hl=($213E)
				add			hl,hl						; hl=($213E)*$02
				add			hl,hl						; hl=($213E)*$04
				add			hl,hl						; hl=($213E)*$08
				add			hl,hl						; hl=($213E)*$10
				ex			de,hl						; de=($213E)*$10
				ld			hl,($203B)
				add			hl,de
				ld			($203B),hl			; ($203B-$203C) +- 16* current speed
				
				ld			a,h
				cpl
				and			$1F
				add			a,$40						; a=$40-$5F
				ld			($2003),a
				
				ld			c,d							; What is d?
				ld			d,$00
				ld			a,($2037)				; Curve parameter
				call		L085C
				push		af
				ld			a,b
				ld			($2002),a
				ld			a,($2022)				; Game state
				xor			$03
				jp			z,L0830
				ld			a,($213E)				; Current speed
				and			a
				jp			z,L0830					; Skip if stopped

				ld			a,($2037)				; Curve parameter
				ld			b,a
				call		L0887						; Complement a if negative
				rrca
				rrca
				rrca
				and			$06							; |($2037)| >> 3				a=00/02/04/06
				cpl											;												a=ff/fd/fb/f9
				inc			a								; -|($2037)| >> 3				a=00/fd/fc/fa
				add			a,$0B						; $0b - |($2037)| >> 3	a=0b/09/07/05
				cp			c
				jp			nc,L07E8
				
				cpl
				inc			a
				add			a,c
				inc			a
				rrca
				and			$03
				ld			c,a
				ld			($2141),a
				
				pop			af
				ld			a,b
				ld			b,d
				and			a
				jp			p,L0801
				ld			a,c
				cpl
				inc			a
				ld			c,a
				jp			L07FF
				
L07E8:
				xor			a								; a=0
				ld			($2141),a
				ld			a,c
				rrca
				and			$07
				add			a,c
				ld			a,c
				ld			a,($203A)				; Steering value
				call		L085C
				ld			b,d							; b=d=0?
				pop			de
				add			a,d
				ld			c,a
				jp			p,L0801					; c<$80 = add
L07FF:
				ld			b,$FF						; 
L0801:
				ld			hl,($2000)			; Car position
				add			hl,bc						; bc = delta
				ld			($2000),hl			; Store
				ld			a,h
				and			a
				jp			z,L0822
				
				ld			a,($2022)				; Game state
				xor			$05
				jp			z,L081A
				ld			hl,$2022				; Game state
				inc			(hl)
				ret
				
L081A:
				ld			a,h
				cpl
				ld			l,a
				ld			h,$00
				ld			($2000),hl			; Car position
L0822:
				ld			a,l
				call		L0887						; Complement a if negative
				cp			$28
				ld			a,h
				adc			a,a							; Carry from cp $28
				ld			($2140),a
				jp			L0831						; Why not push af? 

				;; Get af from stack for $0831
L0830:
				pop			af							; Throw away calling address? 

L0831:
				ld			hl,$2045				; $2045 = IN0 Store
				in			a,($00)					; IN0
				ld			(hl),a					; Store IN0 
				inc			hl							; $2046 = IN1 store
				in			a,($01)					; IN1
				ld			(hl),a					; Store IN1

				call		L084E						; Handle audio port 2 timer
				ld			hl,$203F
				call		L0849						; Handle timer $203F
				inc			hl							; hl=$2040
				call		L0849						; Handle timer $2040
				inc			hl							; hl=$2041

				;; Handle timer
L0849:
				ld			a,(hl)
				and			a
				ret			z								; Skip if zero
				dec			(hl)						; Decrement
				ret

				;; Handle audio port 2 timer
L084E:
				ld			hl,$202E				; Audio port 2 timer
				ld			a,(hl)
				and			a
				ret			z								; Skip if 0
				dec			(hl)						; Decrement timer
				ret			nz							; Return if not 0

				ld			a,($202D)				; Audio port 2 default
				out			($05),a					; Audio Port 2
				ret

				;; a = index into $116D table (steering value ($3F-$C0)
				;; c = index into $122E table
				;; d should be 0
				;; Returns b = $116D table entry (steering delta)
				;; Returns e = $11AE table entry (??)
L085C:
				and			a
				push		af							; Store flags for later
				call		L0887						; Complement a if negative

				ld			e,a							; e=a
				ld			hl,L116D
				add			hl,de						; hl = $116D + a
				ld			a,(hl)
				ld			b,a							; Stash table value
				
				ld			e,c
				ld			hl,L122E				; hl = $122E + c
				add			hl,de
				add			a,(hl)
				jp			p,L087B					; Sum positive = get e from $11AE table

				ld			e,d							; e=0
				cp			$EE
				jp			c,L0881					; a>$EE?
				
				inc			e								; e=1
				jp			L0881

L087B:
				ld			e,a
				ld			hl,$11AE
				add			hl,de						; hl = $11AE + a
				ld			e,(hl)					; Get e from table

L0881:
				pop			af							; Use flags for ret p?
				ld			a,e							
				ret			p								; (original) a<$80
				
				;; 2's complement if (original) a >=$80
				cpl
				inc			a
				ret											


				;; Complement a if negative
L0887:
				and			a
				ret			p
				cpl
				ret


				;; IRQ routine for $2024 non-zero
L088B:
				ld			a,($2022)				; Game state
				and			a
				ret			m								; Return if high bit set

				rrca
				ret			nc							; REturn if low bit was set

				ld			hl,($2027)
				ld			de,$0046				; $0e * $05
				add			hl,de
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?
				ld			hl,($2025)
				ld			de,$0046				; $0e * $05
				add			hl,de
				call		L0A5C						; Draw pylon (no or)
				call		L0A5C						; Draw pylon (no or)
				ld			hl,($2027)
				ld			de,$003C				; $0a * $05
				add			hl,de
				call		L09C9						; Erase big pylon?
				call		L09C9						; Erase big pylon?
				ld			hl,($2025)
				ld			de,$003C				; $0a * $05
				add			hl,de
				call		L0A5C						; Draw plyon (no or)
				call		L0A5C						; Draw pylon (no or)

				;; Swap ($2027) and ($2025)
				ld			hl,($2027)
				ex			de,hl
				ld			hl,($2025)
				ld			($2027),hl
				ex			de,hl
				ld			($2025),hl

				ld			($2060),hl			; ??
				ld			a,$05
				out			($04),a					; MB14241 Count
				xor			a
				out			($03),a					; MB14241 Data
				ld			a,($2003)

				;; ($2003) is probably $00-$1f, so this is done 8 times
L08E1:
				call		L090D

				ld			hl,$2003
				ld			a,(hl)
				add			a,$20
				ld			(hl),a
				jp			nc,L08E1
				ret

L08EF:
				ld			hl,($2060)
				ld			a,h
				or			l
				ret			z								; Pointer clear = Nothing to do
				
				ld			a,$05
				out			($04),a					; MB14241 Count
				xor			a
				out			($03),a					; MB14241 Data

				;; Do ?? with a=$00-$1F
				ld			hl,$2003
				ld			a,(hl)
				and			$1F							; Mask low 5 bits
				ld			(hl),a					; Store
				call		L090D

				;; Do again with a=$20-2F
				ld			hl,$2003
				ld			a,(hl)
				add			a,$20						; a=$20-$3F
				ld			(hl),a

L090D:
				ld			c,a
				ld			b,$00
				ld			hl,$2145				; Use top half of table $2145-$2244
				add			hl,bc						; hl=$2145+a
				ld			c,(hl)
				ld			a,($2002)
				add			a,c							; a = ($2002)+(hl)
				and			a
				jp			p,L092B					; a>0, get l from $11AE table

				cp			$EE
				jp			nc,L0926				; a>=$EE

				;; a = ($80-$ED) --> l=0
				ld			l,b							; l=b=0
				jp			L0931

				;; a = ($EE-$FF) --> l=1
L0926:
				ld			l,$01
				jp			L0931


				;; Get l from $11AE table
L092B:
				ld			c,a
				ld			hl,$11AE
				add			hl,bc
				ld			l,(hl)

L0931:
				ld			h,b							; h=b=0
				ld			a,($2037)
				and			a
				jp			p,L093F					; a>0

				;; hl = -hl
				xor			a
				sub			l
				ld			l,a
				ld			a,b
				sbc			a,h
				ld			h,a
L093F:
				ex			de,hl			
				ld			hl,($2000)			; Car position
				add			hl,de
				ld			($2004),hl
				
				ld			a,($2003)
				ld			c,a
				ld			hl,$2245				; Use bottom half of table $2245-$2344
				add			hl,bc
				ld			a,(hl)					; Index into table
				ld			($2008),a
				ld			d,a
				ld			a,(hl)
				ld			hl,$2006
				rrca										; 07654321
				and			$7F
				ld			e,a
				rrca										; 10765432
				and			$1F
				ld			(hl),a					; $2006
				inc			hl							; $2007
				rrca										; 21076543
				rrca										; 32107654
				and			$07
				ld			c,a
				inc			a
				ld			(hl),a					; $2007
				ld			a,d
				ld			d,b
				add			a,e
				ld			e,a
				push		de

				ld			hl,($2004)
				add			hl,de
				push		hl
				add			hl,bc
				ld			a,h
				pop			hl
				call		L098D						; Write pylon data
				
				pop			de
				;; de = -de
				xor			a
				sub			e
				ld			e,a
				ld			a,$00
				sbc			a,d
				ld			d,a

				;; bc = -bc
				xor			a
				sub			c
				ld			c,a
				ld			a,$00
				sbc			a,b
				ld			b,a
				
				ld			hl,($2004)
				add			hl,bc
				add			hl,de
				ld			a,h

				;; Store calculated pylon data (if a!=0)
L098D:
				and			a
				jp			nz,L09BC				; Pylon offscreen?
				
				ex			de,hl
				ld			hl,($2060)			; Get pylon update pointer
				ld			a,($2007)
				ld			(hl),a					; +0 = Store width
				inc			hl							; +1
				ld			a,($2006)
				ld			(hl),a					; +1 = Store height
				inc			hl							; +2
				ld			a,e
				out			($03),a					; MB14241 Data
				and			$07
				ld			(hl),a					; +2 = Store shift
				inc			hl							; +3
				ld			a,($2008)
				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			(hl),a					; +3 = screen loc low
				inc			hl							; +4
				xor			a
				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				add			a,$24
				ld			(hl),a					; +4 = screen lo high
				inc			hl
				ld			($2060),hl			; Store pylon update pointer
				ret

				;; Clear pylon if offscreen
L09BC:
				ld			hl,($2060)			; Get pylon update pointer
				ld			(hl),$00				; Clear pylon
				ld			de,$0005				; Pylon increment
				add			hl,de
				ld			($2060),hl			; Store pylon update pointer
				ret


				;; Erase big pylon @ hl
L09C9:
				ld			a,(hl)					; Acrive flag?
				and			a
				jp			z,L0A61					; Jump to end if a==0

				inc			hl							; +1
				ld			b,(hl)					; Height
				inc			hl							; +2
				inc			hl							; +3
				ld			e,(hl)					; Screen loc low
				inc			hl							; +4
				ld			d,(hl)					; Screen loc high
				inc			hl							; +5
				push		hl							; Store hl

				ex			de,hl						; hl = screen loc
				ld			de,$001F				; Row increment -1
L09DB:
				ld			(hl),d					; ==0
				inc			hl
				ld			(hl),d					; ==0
				add			hl,de						; Next row
				dec			b
				jp			nz,L09DB				; Loop
				pop			hl
				ret

				;; Erase small pylon at hl
L09E5:
				ld			a,(hl)					; Active flag?
				and			a
				jp			z,L0A61					; Jump to end if a==0

				inc			hl							; +1
				ld			a,(hl)					; Loop counter
				inc			hl							; +2
				inc			hl							; +3
				ld			e,(hl)					; Screen loc low
				inc			hl							; +4
				ld			d,(hl)					; Screen log high
				inc			hl							; +5

				ex			de,hl						; hl = screen loc
L09F3:
				ld			(hl),b					; b=0 (erase)
				add			hl,bc						; bc = $0020 = line increment
				dec			a
				jp			nz,L09F3				; Loop
				ex			de,hl						; Swap back
				ret

				;; Draw big pylon?
L09FB:
				ld			a,(hl)					; Active flag
				and			a
				jp			z,L0A61

				ld			c,a							; Width
				inc			hl							; +1
				ld			b,(hl)					; Height
				inc			hl							; +2
				ld			a,(hl)					; Shift
				inc			hl							; +3
				ld			e,(hl)					; Screen loc low
				inc			hl							; +4
				ld			d,(hl)					; Screen loc high
				inc			hl							; +5
				push		hl

				ex			de,hl						; hl = screen loc
				out			($04),a					; MB14241 Count
				xor			a
				out			($03),a					; MB14241 Data

				;; set c LSBs in a
				ld			d,a							; d=0
				push		hl
				ld			e,c
				ld			hl,L0A94				; Table of bits
				add			hl,de
				ld			a,(hl)

				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			c,a
				xor			a
				out			($03),a					; MB14241 Data
				ld			e,$1F						; Line increment (d=0)
				pop			hl

L0A24:
				ld			a,(hl)					; Read screen
				or			c								; or w/ data
				ld			(hl),a					; Store screen
				inc			hl
				in			a,($03)					; MB14241 Result
				or			(hl)						; or w/ screen
				ld			(hl),a					; Store screen
				add			hl,de						; Next row
				dec			b
				jp			nz,L0A24				; Loop
				pop			hl
				ret

				;; Draw small pylon
L0A33:
				ld			a,(hl)					; Active flag
				and			a
				jp			z,L0A61					; Skip if inactive

				inc			hl							; +1
				ld			b,(hl)					; Height
				inc			hl							; +2
				ld			a,(hl)					; Shift

				out			($04),a					; MB14241 Count
				xor			a
				out			($03),a					; MB14241 Data
				ld			a,$01
				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			c,a							; Stash
				inc			hl							; +3
				ld			e,(hl)					; Screen loc lo
				inc			hl							; +4
				ld			d,(hl)					; Screen loc hi
				inc			hl							; +5
				push		hl							; Store table
				ex			de,hl						; hl = screen address
				ld			de,$0020				; Line increment
L0A52:
				ld			a,(hl)					; Load screen
				or			c								; or w/ data
				ld			(hl),a					; Store screen
				add			hl,de						; Next line
				dec			b
				jp			nz,L0A52				; Loop for height
				pop			hl							; Get table back
				ret

				;; Draw pylon w/o or
L0A5C:
				ld			a,(hl)
				and			a
				jp			nz,L0A66				; Continue if active

				;; End of routine
				;; Go to next able entry and return
L0A61:
				ld			de,$0005
				add			hl,de
				ret

L0A66:
				ld			c,a							; Width
				inc			hl							; +1
				ld			b,(hl)					; Height
				inc			hl							; +2
				ld			a,(hl)					; Shift
				inc			hl							; +3
				ld			e,(hl)					; Screen loc lo
				inc			hl							; +4
				ld			d,(hl)					; Screen low hi
				inc			hl							; +5
				push		hl							; Stash table
				push		de							; Stash screen loc
				out			($04),a					; MB14241 Count
				xor			a
				out			($03),a					; MB14241 Data

				;; set c LSBs in a
				ld			d,a							; d=0
				ld			e,c							; e=width
				ld			hl,L0A94				; ??
				add			hl,de
				ld			a,(hl)

				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			c,a							; Result to c
				xor			a								; a=0
				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			e,$1F						; Line inrement
				pop			hl
L0A8B:
				ld			(hl),c					; Write screen
				inc			hl
				ld			(hl),a					; a=0
				add			hl,de						; Next line
				dec			b
				jp			nz,L0A8B				; Loop for height
				pop			hl
L0A94:
				ret

				;; Data
L0A95:
				.db			$01, $03, $07, $0f			; Bits walking from LSB
				.db			$1f, $3f, $7f, $ff			; 


L0A9D:
				call		L0AAA
				call		L0AE8						; Draw big gfx
				ld			hl,L06DA
				ex			(sp),hl					; Set return address?
				jp			L0831

L0AAA:
				ld			hl,$204B
				dec			(hl)
				jp			p,L0ABA

				;; Get next 9-byte linked list
				ex			de,hl						; de = $204B
				ld			hl,($204D)
				ld			b,$09
				call		L0ADF						; Copy (hl) to (de) b times
L0ABA:
				;; ($2054) += ($204C)
				ld			hl,$2054
				ld			a,($204C)
				add			a,(hl)
				ld			(hl),a

				;; ($2055) &= $07
				inc			hl							; $2055
				ld			c,a
				and			$07
				ld			(hl),a

				;; ($2056) = ($2055)>>3
				inc			hl							; $2056
				ld			a,c
				rrca
				rrca
				rrca
				and			$1F							; Mask low 5 bits (original high 5)
				add			a,$A0
				ld			(hl),a
				
				inc			hl							; $2057
				ld			(hl),$29
				ld			hl,$204F
				dec			(hl)
				ret			p

				;; (Get next part of linked list)
				ex			de,hl						; de=$204F
				ld			hl,($2052)
				ld			b,$05

				;; Copy (hl) to (de) b times
L0ADF:
				ld			a,(hl)
				inc			hl
				ld			(de),a
				inc			de
				dec			b
				jp			nz,L0ADF
				ret


				;; Draw big gfx
L0AE8:
				ld			hl,($2056)			; Big gfx loc offset
				ld			a,h
				or			l
				ret			z								; Skip if hl == L0000

				ld			hl,($2058)			; Big gfx loc store
				ld			a,h
				or			l
				jp			z,L0B08					; Skip if hl == $0000

				;; Erase big gfx
				ld			bc,$0526				; b = width, c = height
				ld			de,$001B				; d = write val, e = $20-b
L0AFC:
				ld			a,b
L0AFD:
				ld			(hl),d					; (0) 
				inc			hl
				dec			a
				jp			nz,L0AFD				; Loop for width
				 
				add			hl,de						; Next line 
				dec			c
				jp			nz,L0AFC				; Loop for height

L0B08:
				ld			hl,($204D)
				ld			a,h
				or			l
				jp			nz,L0B18				; Draw if hl != $0000 

				ld			a,$01
				ld			($2022),a				; Game state
				jp			L0B52						; Draw pylons only 

				;; Draw large gfx
L0B18:
				ld			hl,($2050)
				ld			c,(hl)					; Width 
				inc			hl
				ld			b,(hl)					; Height 
				inc			hl
				ld			e,(hl)					; Initial loc lo 
				inc			hl
				ld			d,(hl)					; Initial loc hi 
				inc			hl
				push		hl							; Data ptr 
				ld			hl,($2056)			; Loc offset 
				add			hl,de
				ld			($2058),hl			; Loc store 
				ld			a,($2055)				; Big sprite shift 
				out			($04),a					; MB14241 Count
				xor			a
				out			($03),a					; MB14241 Data
				pop			de							; Data ptr 
L0B34:
				push		bc
				push		hl
L0B36:
				ld			a,(de)					; Read table
				inc			de
				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			(hl),a					; Write to screen 
				inc			hl
				dec			c
				jp			nz,L0B36				; Loop for width 
				xor			a
				out			($03),a					; MB14241 Data
				in			a,($03)					; MB14241 Result
				ld			(hl),a					; Final write 
				ld			bc,$0020				; Line increment 
				pop			hl
				add			hl,bc
				pop			bc
				dec			b
				jp			nz,L0B34				; Loop for height

				;; Draw pylons
L0B52:
				ld			hl,($2025)
				ld			de,$003C				; = $0c x $05 
				add			hl,de
				call		L09FB						; Draw big pylon 
				call		L09FB						; Draw big pylon
				ret

					
				ld			a,a							; Garbage byte? 

				;; Startup code (non test mode)
L0B61:
				;; Clear $3FFF down to $2020
				ld			bc,$FF00				; All screen + $2020-$23FF
				ld			sp,$2005				; (Temporary so L0162 won't clear it)
				call		L0162						; Write c from bottom of screen b*32 times
				
				ld			sp,$2400				; Reset stack pointer
				call		L10AF						; Unpack track data (?)

				;; Initialiaze PRNG
				ld			hl,$FFFF
				ld			($2009),hl
				ld			($200B),hl
				
				call		L0EB3
				ei
				jp			L0E1F


L0B80:
				out			($07),a					; Watchdog
				ld			hl,$2021				; Coin flag
				ld			a,(hl)
				and			a
				jp			z,L0BB8					; No coin

				xor			a
				ld			(hl),a					; Clear coin flag
				ld			b,a							; b=0
				ld			a,$0A
				ld			($202E),a				; Audio port 2 timer
				ld			a,$22
				out			($05),a					; Audio Port 2
				in			a,($02)					; IN2 
				rlca										; 65432107
				and			$06							; Mask DIPS <1:0> = Coinage
				ld			c,a
				ld			hl,L0FCF				; Coinage Table 
				add			hl,bc

				;; Get de from table 
				ld			e,(hl)					; Coins needed
				inc			hl
				ld			d,(hl)					; Credits

				ld			hl,$202F				; Coins
				inc			(hl)
				ld			a,(hl)
				cp			e
				jp			nz,L0BB8				; Not enough coins
				 
				ld			(hl),b					; b=($2021)
				inc			hl							; Credits
				ld			a,(hl)
				add			a,d							; Add credits
				ld			(hl),a					; Store

				ld			a,($2023)
				and			a
				jp			z,L0C2A					; (In attract mode)

				;; No coin or not enough credits for game
L0BB8:
				call		L100F
				ld			a,($2023)
				and			a
				jp			z,L0C21					; (In attract mode)

				ld			hl,$2041
				ld			a,(hl)
				and			a
				jp			nz,L0C12				; 
				ld			(hl),$3C				; Reset to d60

				;; (This happens once a second)
				ld			hl,$2034				; Tick counter for ratings
				dec			(hl)
				
				;; Decrement game time
				ld			hl,$2042				; Game time
				ld			a,(hl)
				add			a,$99						; Decrement
				daa
				ld			(hl),a					; Store
				jp			nz,L0C0F				; Game timer not zero

				;; Game timer zero
				ld			a,($2023)
				xor			$03
				jp			z,L0DB6					; Already did extended time = Don't calculate

				in			a,($02)					; IN2
				rrca										; 07654321
				rrca										; 10765432
				rrca										; 12076543
				and			$06							; D5=extended time, D4=2.0, not 2.5
				ld			c,a
				ld			b,$00
				ld			hl,L001D				; Index into table 
				add			hl,bc
				ld			c,(hl)					; (Score for extended play)
				ld			hl,$203E				; Score 
				ld			a,(hl)
				and			$F0							; Mask 2nd nybble 
				dec			hl
				add			a,(hl)					; Get 3rd nybble 
				rrca										; Rotate 
				rrca
				rrca
				rrca
				cp			c								; Compare to table value 
				jp			c,L0DB6					; No extra time = Game over
				
				ld			a,$03
				ld			($2023),a				; Mark extended time
				
				ld			a,($2044)				; Extended time
				ld			($2042),a				; Game time

				rst			$30							; Write string table entry
				.db			$81							; Loc 4, string 1 ("EXTENDED TIME")

L0C0F:
				call		L0FF1						; Update time
L0C12:
				ld			hl,$2023
				ld			a,(hl)
				cp			$01
				ret			nz
				ld			a,($203D)				; Player score
				cp			$01
				ret			c
				inc			(hl)
				ret
		
				;; Chekc start botton
L0C21:
				call		L1088						; Kick PRNG, get #
				ld			a,($2045)				; IN 0 store
				and			$80							; Mask Start
				ret			nz							; Not pressed

L0C2A:
				ld			hl,$2030				; Credits
				ld			a,(hl)
				and			a
				ret			z								; No credits

				dec			(hl)						; Decrenent credits

				;; Go to game mode
				ld			sp,$2400				; Rwset stack pointer
				xor			a
				ld			($2022),a				; Leave Attract mode state

				;; Copy score to previous
				ld			hl,($203D)			; Player score
				ld			($2029),hl			; Previous score

				;; Clear $2032-2057
				ld			de,$2032
				ld			b,$28
L0C43:
				ld			(de),a
				inc			de
				dec			b
				jp			nz,L0C43

				ld			h,a							; h=a=0
				in			a,($02)					; IN2
				rrca										; 07654321
				and			$06							; Mask game time
				ld			l,a
				ld			de,L0FD7				; Game time table
				add			hl,de
				ld			a,(hl)					; Get game time
				ld			($2042),a				; Store game time
				inc			hl
				ld			a,(hl)					; Get bonus time
				ld			($2044),a				; Store bonus time
				ld			a,$00
				ld			($202D),a				; Audio port 2 default
				ld			a,$20
				out			($02),a					; Sound Port 1
				call		L0E98

				ld			a,$01
				ld			($2023),a
				ld			a,$FF						; Time value
				ld			($2041),a				; Set timer
				ld			a,$F8
				ld			($2048),a
				in			a,($00)					; IN0
				and			$10							; Mask shifter 
				jp			z,L0C81

				rst			$30							; Write string table entry
				.db			$65							; Loc 3, string $05 ("SHIFT LOW")


L0C81:
				rst			$28							; (call L0F16) Delay time
				.db			$04							; Data for $0F16

				ld			hl,L040B				; Table address
				ld			($204D),hl			; Write table address
				ld			a,$E0
				ld			($2054),a
				ld			a,$FF
				ld			($2022),a				; Game state
				rst			$28							; (call L0F16) Delay time
				.db			$E8							; Data for $0F16

L0C95:
				call		L0B80
				ld			hl,$2140
				ld			a,(hl)
				inc			hl
				or			(hl)
				jp			z,L0CB0
				ld			a,($213E)				; Current speed
				and			a
				jp			z,L0CB0					; Skip if stopped
				
				call		L0F33						; Write data and timer for audio
				.db			$04, $00				; Data for $0F33

				jp			L0CB5

L0CB0:
				call		L0F33						; Write data and timer for audio
				.db			$00, $00				; Data for $0F33

L0CB5:
				ld			hl,$2022				; Game state
				ld			a,(hl)
				xor			$05
				jp			nz,L0CC7

				;; ($2022) == $05
				ld			a,($2040)
				and			a
				jp			nz,L0CC7				; Timer non-zero

				ld			(hl),$01				; Set timer ot 1

L0CC7:
				ld			a,(hl)
				xor			$02
				jp			z,L0E59

				;; ($2022) !- $02
				ld			hl,$2048
				ld			a,(hl)
				and			a
				jp			m,L0CEE
				ld			(hl),$F8
				ld			hl,($2032)
				inc			hl
				ld			($2032),hl

				;; Increment score
				ld			hl,$203E				; Score
				ld			a,(hl)
				add			a,$01
				daa
				ld			(hl),a
				jp			nc,L0CEB
				dec			hl							; Handle 3rd digit
				inc			(hl)

L0CEB:
				call		L0FDF						; Update score
L0CEE:
				call		L0D77						; Update speedometer gauge
				
				ld			a,($2037)
				call		L0887						; Complement a if negative
				rrca
				rrca
				rrca
				rrca										; |($2037)| >> 4
				and			$03							; String $00-$03
				add			a,$10						; Loc $00, (Max curve string)
				call		L0F48						; Rewrite top of screen

				ld			a,($2045)
				ld			b,a
				and			$0F
				ld			d,a
				rlca
				ld			c,a
				rlca
				add			a,c
				ld			c,a
				ld			a,b
				and			$10
				ld			a,($213E)				; Current speed
				jp			z,L0D39
				cp			$28
				jp			nc,L0D27

				rst			$30							; Write string table entry
				.db			$65							; Loc 3, string $05 ("SHIFT LOW")

				ld			c,$00						; Value to $213F
				ld			a,$20
				out			($02),a					; Sound Port 1
				jp			L0D4F
				
L0D27:
				ld			a,c
				rlca
				ld			c,a							; Value to $213F
				ld			a,d
				or			$10
				out			($02),a					; Sound Port 1
				ld			a,$01
				ld			($205A),a
				rst			$30							; Write string table entry
				.db			$60							; Loc 3, (Clear)

				jp			L0D4F
L0D39:
				cp			$28
				jp			c,L0D43
				rst			$30							; Write string table entry
				.db			$66							; Loc 3, string $05 ("SHIFT HIGH")

				jp			L0D45
L0D43:
				rst			$30							; Write string table entry
				.db			$60							; Loc 3, (Clear)

L0D45:
				ld			a,d
				or			$20
				out			($02),a					; Sound Port 1
				ld			a,$02
				ld			($205A),a
L0D4F:
				ld			a,c
				ld			($213F),a
				ld			a,($2046)				; IN1 Steering store
				call		L0D60						; Limit to $3F-$C0
				cpl
				ld			($203A),a				; Steering value
				jp			L0C95
				
L0D60:
				ld			a,($2046)				; IN1 Steering store
				cpl
				add			a,$81						; ($7F becomes $00)
				cp			$81
				jp			c,L0D71					; <$81
				cp			$C0
				ret			nc							; <=$C0 = OK
				ld			a,$C0						; Limit to $C0
				ret
L0D71:
				cp			$40
				ret			c								; >$40 = OK
				ld			a,$3F						; Limit to $3F
				ret


				;; Update speedometer gauge (if needed)
L0D77:
				ld			a,($213E)				; Current speed

				;; Do some funny math
				ld			b,a
				rrca										; 07654321
				rrca										; 10765432
				rrca										; 21076543
				and			$1F							; a = +($213E)/8
				cpl
				inc			a								; a = -($213E)/8
				add			a,b							; a =~ 7/8 of ($213E)
				ld			hl,$2142
				cp			(hl)
				ret			z								; Nothing to do
				
				jp			c,L0D8F

				;; <($2042) -> increment
				inc			(hl)
				jp			L0D90
L0D8F:

				;; >($2042) -> decrement
				dec			(hl)
L0D90:
				ld			a,(hl)					; a = ($2142)
				rrca
				rrca
				rrca
				and			$1F							; a = ($2142)/8
				add			a,$A5
				ld			e,a							; Screen loc LSB
				ld			d,$39						; Screen loc MSB

				;; Fractional part to thermometer code
				ld			a,(hl)
				and			$07
				ld			c,a
				ld			b,$00
				ld			hl,L0A95				; Walking bits table
				add			hl,bc
				ld			a,(hl)
				cpl
				ex			de,hl						; hl = Screen loc
				ld			c,$1F						; bc = $001F = Row increment - 1
				ld			de,$04FF				; d = 4 fows, e = $FF (white)
L0DAD:
				ld			(hl),a					; Draw fractional byte
				inc			hl
				ld			(hl),e					; Draw white byte
				add			hl,bc						; Next row
				dec			d
				jp			nz,L0DAD
				ret

				;; Game Over
L0DB6:													
				ld			sp,$2400				; Reset stack pointer
				ld			a,$04
				ld			($2022),a				; Game state
				call		L0E4B
				ld			($2023),a				; a=0 from L0E4B
				call		L0FF1						; Update time

				call		L0F44
				.db			$09							; Loc $00, string $09 "GAME OVER"

				ld			hl,($202B)			; High score
				ex			de,hl
				ld			hl,($203D)			; Player score
				ld			a,l
				cp			e
				jp			c,L0DEF
				jp			nz,L0DDF
				ld			a,d
				cp			h
				jp			nc,L0DEF

L0DDF:
				ld			($202B),hl			; High score
				call		L0057						; White out bottom 40 rows

				;; "CONGRATULATIONS"
				call		L0F5A						; Draw string from arg
				.db			$6f							; Loc $03, string $0F ("CONGRATS")

				;; "NEW RECORD"
				call		L0F5A						; Draw string from arg
				.db			$84							; Loc $04, string $04 ("NEW RECORD")

				rst			$28							; (Call $0F16) Delay time
				.db			$ff							; Data for $0F16

L0DEF:
				call		L0057						; White out bottom 40 rows

				;; "YOUR RATING"
				call		L0F5A						; Draw string from arg
				.db			$62							; Loc $03, string $02 ("YOUR RATING")

				;; bc = -(Game time/2)
				ld			a,($2034) 
				ld			c,a
				ld			b,$FF
				ld			e,b							; e = $FF

				;; Crude divide for rank
				;; Count # of times to add bc to make score negative
				ld			hl,($2032)			; Score in hex
L0E00:
				ld			a,h
				and			a
				jp			m,L0E0A					; Score negative = done

				add			hl,bc
				inc			e
				jp			L0E00						; Loop back

				;; Extra rating point if no crashes
L0E0A:
				ld			a,($2035)				; Crashes
				and			a
				ld			a,e
				jp			nz,L0E13				; Skip increment

				inc			a
L0E13:
				;; "RATING TEXT"
				add			a,$94						; Loc 4, String $14+a (rating)
				call		L0F5E						; String @ loc from a

				rst			$28							; (call	L0F16) Delay time
				.db			$ff							; Data for $0F16

				rst			$28							; (call	L0F16) Delay time
				.db			$ff							; Data for $0F16

L0E1C:
				call		L0EB3
L0E1F:
				ld			a,$0A
				ld			($2031),a
L0E24:
				call		L0E4B
				ld			a,($2030)
				and			a
				jp			z,L0E35

				call		L0F44
				.db			$08							; Loc $00, string $08 "PUSH BUTTON"

				jp			L0E39

L0E35:
				call		L0F44
				.db			$07							; Loc $00, string $07 "INSERT COIN"

L0E39:
				rst			$28							; (call	L0F16) Delay time
				.db			$ff							; Data for $0F16

				call		L0F44
				.db			$0e							; Loc $00, string $0E "DATSUN"

				rst			$28							; (call	L0F16) Delay time
				.db			$ff							; Data for $0F16

				ld			hl,$2031
				dec			(hl)
				jp			nz,L0E24
				jp			L0E1C


L0E4B:
				call		L0F33						; Write data and timer for audio
				.db			$02, $00				; Data for $0F33
				
				ld			a,$02
				ld			($202D),a				; Audio port 2 default
				xor			a
				out			($02),a					; Sound Port 1
				ret


				;; ($2022) == $02
L0E59:
				ld			sp,$2400				; Reset stack pointer
				call		L0F33						; Write data and timer for audio
				.db			$03, $3c				; Data for $0F33

				call		L03C4						; Draw crash message
				ld			hl,$2035
				inc			(hl)						; Increment crashes
				call		L0F28						; Wait for audio timer
				
				xor			a
				out			($02),a					; Sound Port 1
				call		L0F33						; Write data and timer for audio
				.db			$02, $0a				; Data for $0F33

				call		L0F28						; Wait for audio timer
				
				call		L0F33						; Write data and timer for audio
				.db			$0a, $50				; Data for $0F33

				call		L0F28						; Wait for audio timer
				
				call		L0E98						; Reset screen
				
				ld			a,($2023)
				cp			$01
				ld			a,$FF
				jp			z,L0E8D
				
				ld			a,$78
L0E8D:
				ld			($2040),a				; Set timer
				
				ld			a,$05
				ld			($2022),a				; Game state
				jp			L0C95

				;; Set screen state at beginning of game or afer crash
L0E98:
				call		L0EDE						; Initial screen setup

				;; Draw SCORE line
				call		L0F5A						; Draw string from arg
				.db			$4b							; Data for $0F5A -- Loc 2, String 0B

				call		L0FF1						; Update time
				call		L0FDF						; Update score
				ld			a,$01
				ld			($2022),a				; Game state
				ld			a,($2023)
				xor			$03
				ret			nz							; $03 = "active, not extended"

				rst			$30							; Write string table entry
				.db			$81							; Loc $04, string $01 ("EXTENDED TIME")

				ret

L0EB3:
				call		L0EDE						; Initial screen setup

				;; Draw SCORE line
				call		L0F5A						; Draw string from arg
				.db			$43							; Loc $02, string $03 ("SCORE")

				rst			$30							; Write string table entry
				.db			$6c							; Loc $03, string $0c ("HIGH SCORE")

				rst			$30							; Write string table entry
				.db			$8d							; Loc $04, string $0d ("PREV SCORE")

				call		L0FDF						; Update score
				ld			hl,$202B				; High score
				ld			de,$3CB9				; Screen loc
				call		L0FE5						; Draw high score
				ld			hl,$2029				; Previous score
				ld			de,$3E99				; Screen loc
				call		L0FE5						; Draw previous score
				ld			a,$03
				ld			($2022),a				; Game state
				ld			a,$50
				ld			($213F),a
				ret


				;; Initial screen setup
L0EDE:
				xor			a
				ld			($2022),a				; Game state
				call		L015F						; Clear screen

				;; White area near the bottom of the screen
				ld			bc,$14FF				; d20 lines of $FF
				ld			de,$3A80				; d44 lines up from the bottom
				call		L0165						; Write c to de b*16 times.

				;; Clear $205A-2143
				ld			hl,$205A				; Start loc
				ld			c,$EA						; Loop counter
				xor			a								; 1=0
L0EF4:
				ld			(hl),a
				inc			hl
				dec			c
				jp			nz,L0EF4				; Loop
				
				ld			a,$01
				ld			($205A),a
				ld			hl,$2062				; Initial pylon table
				ld			($2027),hl			; Initial pylon table
				ld			hl,$20D0				; Initial pylon table
				ld			($2025),hl			; Initial pylon table
				ld			hl,$0080				; Center
				ld			($2000),hl			; Car position

				;; Draw speedometer
				call		L0F5A						; Draw string from arg
				.db			$2A							; Loc $01, string $0A (Speedometer)

				ret


				;; Actual rst $28
				;; Get argument from call
				;; Write timer and do L0B80 until it clears
L0F16:
				ex			(sp),hl
				ld			a,(hl)
				inc			hl
				ex			(sp),hl

				ld			($203F),a				; Timer
L0F1D:
				call		L0B80
				ld			a,($203F)
				and			a
				jp			nz,L0F1D
				ret

				;; Wait for audio timer
L0F28:
				call		L0B80
				ld			a,($202E)				; Audio port 2 timer
				and			a
				jp			nz,L0F28				; Loop until timer clear
				ret

				;; Get bc from calling address
L0F33:
				ex			(sp),hl
				ld			c,(hl)
				inc			hl
				ld			b,(hl)
				inc			hl
				ex			(sp),hl

				ld			hl,$202E				; Audio port 2 timer
				ld			a,(hl)
				and			a
				ret			nz							; Skip if active

				ld			(hl),b					; Set timer
				ld			a,c
				out			($05),a					; Audio Port 2
				ret

				;; Get single argument from stack 
L0F44:
				ex			(sp),hl
				ld			a,(hl)
				inc			hl
				ex			(sp),hl

				;; Clear top of screen message, if changed
L0F48:
				call		L0F91						; Return if a matches table
				ld			(hl),a
				push		af
				ld			bc,$0A00				; d10 lines of black
				ld			de,$2540				; $2400-253F = Top 10 lines
				call		L0165						; Push c to de b*16 times.
				pop			af
				jp			L0F5E						; String @ loc from a
				;; And return


				;; String @ loc from calling 
				;; Get argument from calling address
L0F5A:
				ex			(sp),hl
				ld			a,(hl)
				inc			hl
				ex			(sp),hl

				;; String @ Loc from a
L0F5E:
				push		hl							; Stash hl
				rlca
				push		af							; Stash a<<1
				rlca
				rlca
				rlca
				and			$0E							; Previous bits <7:5>
				ld			c,a
				ld			b,$00
				ld			hl,L0FC5				; Location table
				add			hl,bc

				;; Get de from table
				ld			e,(hl)
				inc			hl
				ld			d,(hl)

				pop			af							; Original a<<1
				and			$3E							; Original bits <4:0>
				jp			z,L0F8F					; No phrase

				push		de
				ld			c,a							; a = phrase index
				ld			hl,$123F				; Language table 
				call		L1000						; Index into language table
				ex			de,hl						; Phrase list to hl
				add			hl,bc
				ld			e,(hl)
				inc			hl
				ld			d,(hl)
				ex			de,hl						; hl = start of phrase
				pop			de
L0F85:
				ld			a,(hl)					; Get char
				call		L0381						; Draw char from a
				ld			a,(hl)					; Get char
				inc			hl
				and			a
				jp			p,L0F85					; Loop (last char has D7 set)
L0F8F:
				pop			hl							; Restore hl
				ret

				;; Called from rst $30 and elsewhere
				;; Dump calling address if a matches spot in table
L0F91:
				push		bc
				push		af
				rlca
				rlca
				rlca
				and			$07							; Previous high 3 bits 
				ld			c,a
				ld			b,$00
				ld			hl,$205B				; Table 
				add			hl,bc						; Index into table 
				pop			af
				pop			bc
				cp			(hl)						; Compare to table 
				ret			nz
				pop			hl							; Throw away last calling address 
				ret

				;; Crash string table
L0FA5:
				.db			"POW?"					; POW_
				.db			"ZAP?"					; ZAP_
				.db			"WAM?"					; WAM_
				.db			"BAM?"					; BAM_
				.db			"ZORK"					; ZORK
				.db			"BANG"					; BANG
				.db			"BOOM"					; BOOM
				.db			"ZONK"					; ZONK

				;; 2-byte table (8 entries, 5 used)
				;; Screen location for phrases?
L0FC5:
				.dw			$2400						; Top of screen
				.dw			$3840						; 3rd from bottom
				.dw			$3ac0						; 2nd from bottom
				.dw			$3ca0						; 1st from bottom
				.dw			$3e80						; Bottom

				;; 2-byte tabke (4 entries) == Coinage
L0FCF:
				.db			$01, $01				; 1 coin, 1 credit
				.db			$01, $02				; 1 coin, 2 credit
				.db			$02, $01				; 2 coin, 1 credit
				.db			$02, $03				; 2 coin, 3 credit

				;; 2-byte tabke (4 entries) == Game time
L0FD7:	
				.db			$80, $40				; 80 + 40 ext
				.db			$01, $01				; Test mode
				.db			$99, $50				; 99 + 50 ext
				.db			$60, $30				; 60 + 30 ext

				;; Update score
L0FDF:
				ld			hl,$203d				; Memory location 
				ld			de,$3ad9				; Screen location

				;; Draw ##.## from hl to de
L0FE5:
				call		L0366						; Draw BCD from hl at de w/ _
				ld			a,$3E						; . 
				call		L0381						; Draw char from A 
				inc			hl
				jp			L0374						; Draw BCD from hl at de w/ 0
				;; And return

				;; Draw game time
L0FF1:
				ld			hl,$1247				; Language loc table
				call		L1000						; Index into language table (to de)
				ld			hl,$2042				; (Game time)
				jp			L0366						; Draw BCD from hl at de w/ _

				.db			$a7							; Checksum fix byte 
				nop
				nop

				;; Index into language table
				;; hl = table
				;; Returns de = entry
L1000:
				in			a,($02)					; IN2
				rlca										; 65432107
				rlca										; 54321076
				rlca										; 43210765
				and			$06							; Language
				ld			e,a
				ld			d,$00
				add			hl,de
				ld			e,(hl)
				inc			hl
				ld			d,(hl)
				ret

L100F:
				ld			a,($204A)
				and			a
				ret			m
				
				ld			hl,$2036
				ld			b,(hl)
				ld			a,(hl)
				inc			hl							; $2037
				cp			(hl)
				jp			z,L1037					; Jump if ($2036 == $2037)
				xor			(hl)						; a = ($2036) ^ ($2037)
				ld			a,b							; a = ($2036)
				jp			m,$102B					; D7 different
				cp			(hl)
				jp			nc,$102F

L1027:
				dec			(hl)
				jp			$1030

L102B:
				cp			(hl)
				jp			nc,$1027

L102F:
				inc			(hl)

L1030:
				ld			a,($2039)
				ld			($204A),a
				ret


L1037:
				inc			hl							; $2038
				ld			a,(hl)
				and			a
				jp			nz,$1027

				ld			b,a							; ($2038)
				ld			a,($2023)
				ld			c,a
				rlca
				add			a,c							; a=($2023)*3
				ld			c,a							; c=($2023)*3
				ld			hl,L107C				; Table, (returns $00-$03)
				add			hl,bc						; Index into table
				
				ld			de,$2036				; ??
				call		L1088						; Kick PRNG, get #
				and			$07
				jp			z,L106F
				
				call		L1088						; Kick PRNG, get #
				and			$7F							; $00-$7F
				sub			$40							; $C0-$3F
				ld			(de),a
				inc			de							; $2037
				inc			de							; $2038
				call		L1088						; Kick PRNG, get #
				and			(hl)						; Mask bits 0,1
				
L1062:
				ld			(de),a
				inc			de							; $2039
				inc			hl
				call		L1088						; Kick PRNG, get #
				and			(hl)						; Mask bits 0,1
				inc			hl
				add			a,(hl)
				add			a,$FC						; $FC-$FF
				ld			(de),a
				ret

L106F:
				ld			(de),a
				inc			de							; $2037
				inc			de							; $2038
				call		L1088						; Kick PRNG, get #
				and			$3F							; $00-$3F
				add			a,$20						; $20-$5F
				jp			$1062


				;; Table for $1045 ??
L107C:
				.db			$03, $03, $00
				.db			$03, $03, $00
				.db		  $03, $01, $02
				.db			$03, $00, $03


				;; PRNG?
L1088:
				push		hl
				push		bc
				ld			hl,$2009
				ld			b,$08						; Loop counter
				ld			a,(hl)

L1090:
				rlca
				rlca
				rlca
				xor			(hl)
				rla
				rla
				ld			hl,$2009
				ld			a,(hl)
				rla
				ld			(hl),a
				inc			hl							; hl=$2010
				ld			a,(hl)
				rla
				ld			(hl),a
				inc			hl							; hl=$2011
				ld			a,(hl)
				rla
				ld			(hl),a
				inc			hl							; hl=$2012
				ld			a,(hl)
				rla
				ld			(hl),a
				dec			b
				jp			nz,$1090				; Loop

				pop			bc
				pop			hl
				ret


				;; Write track data?
L10AF:
				ld			hl,$2144
				ld			(hl),$35				; Initial value

				;; Unpack positive delta-encoded data
				ld			de,L10E7
				ld			bc,$0040				; b = xor value, c=count
				call		L10C9						; Unpack + delta-encoded data
				
				inc			hl
				ex			de,hl
				ld			b,$08
				call		L0ADF						; Copy (hl) to (de) b times
				ex			de,hl

				dec			hl
				;; Unpack negative delta-encoded data
				ld			bc,$FF3E				; b = xor value, c=count
				
				;; Unpack delta-encoded track data
				;; de = Table of packed 2-bit values
				;; b  = xor value, c  = loop counter
L10C9:
				ld			a,(de)					; Get 4x 2bit delta encoded value
				push		de
				ld			d,$04						; Loop counter (4 packed 2 bit values

				;; Unpack 2 bits from (de)
L10CD:
				rlca
				rlca
				ld			e,a							; e = a<<2
				and			$03							; Previous high 2 bits of a
				xor			b
				jp			p,$10D7

				inc			a								; 2's complement if negative
L10D7:
				add			a,(hl)					; Add delta to last value
				inc			hl							; Increment
				ld			(hl),a					; Store value
				dec			d
				ld			a,e
				jp			nz,$10CD				; Loop for byte

				pop			de
				inc			de							; Next encoded byte
				dec			c
				jp			nz,$10C9				; Loop for table length
				ret

				push		de							; Garbage byte?


				;; $40 long table
				;; Delta encoded positive values
				;; Unpacked $2145-$2244
				;; $25 = 00 10 01 01 = +0 +2 +1 +1 -> (35) 35 37 38 39
L10E7:
				.db			$25, $55, $55, $15, $15, $15, $04, $51		; 
				.db			$11, $11, $04, $44, $11, $04, $10, $41		; 
				.db			$04, $10, $41, $01, $01, $04, $04, $04		; 
				.db			$04, $04, $01, $01, $00, $40, $10, $04		; 
				.db			$01, $00, $40, $10, $01, $00, $10, $04		; 
				.db			$00, $40, $04, $00, $10, $01, $00, $10		; 
				.db			$00, $40, $01, $00, $10, $00, $40, $01		; 
				.db			$00, $01, $00, $04, $00, $10, $00, $40		; 

				;; $08 long table
				;; Unencoded -- 0, -7, 5, -4, -5, -4, -3, -4
				;; Written $2245-$224c
				;; Tight curve?
L1127:
				.db			$7f, $79, $74, $70, $6b, $67, $64, $60		;

				;; $3E long table
				;; Delta encoded negative values
				;; Unpacked $224d-$2344
				;; $fe = 11 11 11 10 = -3 -3 -3 -2 -> (60) 5d 5a 59 57
L112F:
				.db			$fe, $ee, $a6, $99, $65, $55, $55, $54		;
				.db			$51, $45, $11, $11, $11, $04, $41, $04		;
				.db			$10, $40, $41, $00, $40, $40, $10, $04		;
				.db			$00, $40, $04, $00, $10, $00, $10, $00		;
				.db			$10, $00, $01, $00, $00, $04, $00, $00		;
				.db			$04, $00, $00, $00, $40, $00, $00, $00		;
				.db			$10, $00, $00, $00, $00, $40, $00, $00		;
				.db			$00, $00, $01, $00, $00, $00							;


				;; Table for $0862
				;; $40 byte table for |$C0-$3F|
				;; Translate steering position to delta?
L116D:
				.db			$81, $8f, $a2, $ad, $b5, $bb, $c0, $c4		; 
				.db			$c8, $cb, $ce, $d0, $d3, $d5, $d7, $d9		; 
				.db			$db, $dc, $de, $df, $e1, $e2, $e3, $e4		; 
				.db			$e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed		; 
				.db			$ed, $ee, $ef, $f0, $f1, $f1, $f2, $f3		; 
				.db			$f4, $f4, $f5, $f6, $f6, $f7, $f7, $f8		; 
				.db			$f9, $f9, $fa, $fa, $fb, $fb, $fc, $fc		; 
				.db			$fd, $fd, $fe, $fe, $ff, $ff, $ff, $ff		;
				
				.db			$ff																				; Garbage?

				;; $80 byte Table
L11AE:
				.db			$01, $01, $01, $01, $01, $01, $01, $01		; 11x 01
				.db			$01, $01, $01, $02, $02, $02, $02, $02		; 15x 02
				.db			$02, $02, $02, $02, $02, $02, $02, $02		; 15x 02
				.db			$02, $02, $03, $03, $03, $03, $03, $03		; 9x  03
				.db			$03, $03, $03, $04, $04, $04, $04, $04		; 7x  04
				.db			$04, $04, $05, $05, $05, $05, $05, $06		; 5x  05, 5x  06
				.db			$06, $06, $06, $06, $07, $07, $07, $07		; 4x  07
				.db			$08, $08, $08, $09, $09, $09, $0a, $0a		; 3x  08, 3x  09, 3x  0a
				.db			$0a, $0b, $0b, $0c, $0c, $0c, $0d, $0d		; 2x  0b, 3x  0c, 2x  0d
				.db			$0e, $0e, $0f, $10, $10, $11, $11, $12		; 2x  0e
				.db			$13, $13, $14, $15, $16, $16, $17, $18		; 
				.db			$19, $1a, $1b, $1c, $1d, $1e, $1f, $20		; 
				.db			$21, $23, $24, $25, $27, $28, $2a, $2b		; 
				.db			$2d, $2f, $30, $32, $34, $36, $38, $3a		; 
				.db			$3c, $3e, $41, $43, $46, $48, $4b, $4e		; 
				.db			$51, $54, $57, $5a, $5c, $61, $64, $68		; 

				;; $11 byte table for $0869
L122E:
				.db			$00, $01, $13, $1e, $26, $2c, $31, $33		; 
				.db			$35, $39, $3b, $3d, $3f, $41, $42, $43		; 
				.db			$44																				; 

#include "zaptext.asm"

				;; Fill to end of ROM space
				.org		$17FF
				.db			$FF

				.end
