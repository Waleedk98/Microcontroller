 /*.equ output_bit = 2
 .equ input_bit = 3
 .equ input_bit2 = 4

    ; Set DDRD bit 2 (PD2) as output
    sbi DDRD, output_bit

start:
    ; Reset r17 and r18 at the start of each loop iteration
    ldi r17, 0x00    ; reset r17
    ldi r18, 0x00    ; reset r18

    ; Read PIND into r16
    in r16, PI ND

    ; Bit Store to T from button 1 (PD3)
    bst r16, input_bit
    ; Bit Load from T to r17 bit 0
    bld r17, 0

    ; Bit Store to T from button 2 (PD4)
    bst r16, input_bit2
    ; Bit Load from T to r18 bit 0
    bld r18, 0

    ; XOR r17 and r18
    eor r17, r18

    ; Skip if bit 0 in r17 is clear (if result was 0)
    sbrc r17, 0
    ; Set bit 2 in PORTD (turn LED on)
    sbi PORTD, output_bit

    ; Skip if bit 0 in r17 is set (if result was 1)
    sbrs r17, 0
    ; Clear bit 2 in PORTD (turn LED off)
    cbi PORTD, output_bit

    ; Repeat the loop
    rjmp start
	*/

	; Konstanten und Definition
	.equ clk_freq_in_Hz = 16000000												;Taktfrequenz des Microcontrollers
	.equ blink_freq_in_Hz = 1													;Blinkfrequenz der LED in Hz (1Hz = 1s an, 1s aus)

	;Berechnung des Startwertes f�r den Z�hler (7 Taktzyklen pro Schleife, 0,5s an, 0,5 aus)
	.equ cnt_Start = (clk_freq_in_Hz / blink_freq_in_Hz) / (7 * 2)
	
	.def accu = r16																;Akkumulator
	.def cnt_low = r17															;Niedrigster Byte des Z�hlers
	.def cnt_mid = r18															;Middle Byte of counter
	.def cnt_high = r19															;highest Byte of counter
	.def zero_test = r20														;Register f�r Zero-Test
	  
   ;Initialisierung
   sbi DDRD, 2		;set PD2 as Output
   sbi PORTD, 3		;Schalte internen Pull-up-Wiederstand f�r PD3 aus (Button1)
   sbi PORTD, 4		;Schalte internen Pull-up-Wiederstand f�r PD4 aus (Button2)

   ;Hauptschleife
   start:
		sbi PORTD, 2		;Schalte LED an (PD2 auf High setzen)
		;Z�hler zur�cksetzen
		ldi cnt_low, byte1(cnt_start)		;Lade das niedrigste Byte des Startwerts in cnt_low
		ldi cnt_mid, byte2(cnt_start)		;Lade das mittlere Byte des Startwerts in cnt_mid
		ldi cnt_high, byte3(cnt_start)		;Lade das h�hste Byte des Startwerts in cnt_high
		rcall delay_long					;Rufe die Verz�gerung auf

		cbi PORTD, 2		;Schalte LED aus (PD2 auf Low setzen)
		;Z�hler zur�cksetzen
		ldi cnt_low, byte1(cnt_start)		;Lade das niedrigste Byte des Startwerts in cnt_low
		ldi cnt_mid, byte2(cnt_start)		;Lade das mittlere Byte des Startwerts in cnt_mid
		ldi cnt_high, byte3(cnt_start)		;Lade das h�hste Byte des Startwerts in cnt_high
		rcall delay_long					;Rufe die Verz�gerung auf

		; delay_long Methode
		delay_long:
		clc		;clear Cary
		delay_loop:
		sbci cnt_low, 1		;verringere das niedrigste Byte um 1
		sbci cnt_mid, 0		;verringere das mittlere Byte um 1 (mit Ber�cksichtigungs des �bertrags)
		sbci cnt_high,0     ;verringere das h�hste Byte um 1 (mit Ber�cksichtigung des �bertrags)
		tst cnt_high		;Test das h�hste Byte
		brne delay_loop		;wenn cnt_high != , springe zu delay_loop
		tst cnt_mid         ;Test mid Byte
		brne delay_loop     ;""
		tst cnt_low			;""
		brne delay_loop		;""
		ret					;R�ckher aus Mehtode