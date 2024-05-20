.equ output_bit = 2
.equ input_bit = 3
.equ input_bit2 = 4

    ; Set DDRD bit 2 (PD2) as output
    sbi DDRD, output_bit
    
    ; Initialize registers
    ldi r17, 0x00    ; reset r17
    ldi r18, 0x00    ; reset r18

start:
    ; Read PIND into r16
    in r16, PIND

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

    ; Skip if bit 0 in
