	
		#include<p18F4550.inc>

loop_cnt1	set	0x00
loop_cnt2	set	0x01

			org 0x00    
			goto start
			org 0x08  
			retfie 
			org 0x18 
			retfie

;*************************************************************************
;Subroutine for 1 second delay
;*************************************************************************

dup_nop		macro kk
		variable i
i = 0		
		while i < kk
		nop
i += 1
	
		endw				
		endm

delay1s		movlw		D'80'			;1sec delay subroutine
		movwf		loop_cnt2,A		;for 20 MHz
again1		movlw		D'250'
		movwf		loop_cnt1,A
again2		dup_nop		D'247'
		decfsz		loop_cnt1,F,A
		bra		again2
		decfsz		loop_cnt2,F,A
		bra		again1
		nop

		return
		

;*************************************************************************
;Subroutine for Buzzer.
;*************************************************************************


buzzer		bsf	PORTC, 2, A		;Turn on the buzzer
		call	delay1s
		bcf	PORTC, 2, A		;Turn off the buzzer
		call	delay1s
		bsf	PORTC, 2, A		
		call	delay1s
		bcf	PORTC, 2, A		
		call	delay1s

		return

;*************************************************************************
;Subroutine for Reset Button
;*************************************************************************
 
resetbutton	setf	PORTD,A
		clrf	buzzer
		clrf	PORTD,A
			
		return


;*************************************************************************
;Subroutine for Student ID Number.
;*************************************************************************

IDnum		movlw		D'9'  			;display 9
		movwf		PORTD,A
		call		delay1s	
		btfss		PORTB,2,A
		bra		button3

		movlw		D'6'			;display 6
		movwf		PORTD,A
		call		delay1s
		btfss		PORTB,2,A
		bra		button3

		movlw		D'3'			;display 3
		movwf		PORTD,A
		call		delay1s
		btfss		PORTB,2,A
		bra		button3

		movlw		D'5'			;display 5
		movwf		PORTD,A
		call		delay1s
		btfss		PORTB,2,A
		bra		button3

		movlw		D'6'			;display 6
		movwf		PORTD,A
		call		delay1s			
		btfss		PORTB,2,A
		bra		button3
		bra		IDnum


;************************************************************************
;My Main Program.
;************************************************************************
	
start		setf		TRISB,A			;configure PORTB as input
		clrf		TRISE,A			;configure PORTE as output
		clrf		TRISD,A			;configure PORTD as output
		clrf		PORTD,A			;initialize PORTD to turn OFF
		bsf		PORTE,0,A 		;7 segment ON when sw1 pressed
		bcf		TRISC,2,A		;configure PORTC as output
		bcf		PORTC,2,A		;Buzzer turn OFF
				

button1		btfss		PORTB,0,A		;check SW1 condition
		call 		IDnum
		bra		button2

button2		btfss		PORTB,1,A		;check SW2 condition
		call		buzzer
		bra		button1

button3		btfss		PORTB,2,A		;check SW3 condition
		call		resetbutton
		bra 		button1		
			
		end
