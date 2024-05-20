
.equ output_bit = 2
.equ input_bit = 3
.equ input_bit2 = 4

	sbi DDRD , output_bit

sbi DDRD ,2 ; PD2 is output
ldi r17 ,0 x00 ; reset r17
ldi r18 ,0 x00 ; reset r18
start :
in r16 , PIND ; read in r16
bst r16 ,3 ; T <- button 1
bld r17 ,0 ; r17 <- T
bst r16 ,4 ; T <- button 2
bld r18 ,0 ; r18 <- T
eor r17 , r18 ; r17 xor r18
sbrc r17 ,0 ; skip next instruction if result was 0
sbi PORTD ,2 ; turn LED on
sbrs r17 ,0 ; skip next instruction if result was 1
cbi PORTD ,2 ; turn LED off
rjmp start ; goto start