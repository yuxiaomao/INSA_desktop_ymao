; ce programme est pour l'assembleur RealView (Keil)
	thumb

;	area  madata, data, readwrite
;	export compteur4
	import etat;
TIM3_CCR3	equ	0x4000043C	; adresse registre PWM

E_POS	equ	0
E_TAI	equ	4
E_SON	equ	8
E_RES	equ	12
E_PER	equ	16



	area  moncode, code, readonly
	export timer_callback ; pour exporter la fonction timer_callback
;
;temporisation
;modifie TIM3_CCR3 pour PWM à chaque appelle du timer_callback
timer_callback	proc


; If ( position< taille )    ; si la valeur dépasse la taille , on arrete de compter ; 
	LDR	r3, =etat
	LDR	r0, [r3, #E_POS]
	LDR	r1, [r3, #E_TAI]
	CMP	r0,r1
	BLS	comp 	;si position <= taille
	B	arret	;si position > taille
comp	;si position <= taille
	LDR	r1, [r3, #E_SON]
	ADD	r1, r0 ;trouver la position du son à traiter
	
	;etat.position<= etat.position + 2
	ADD r0, #2 ; car les sons sont de 16 bits, 
	STR	r0, [r3, #E_POS]
	
	LDRSH	r1, [r1]
	ADD 	r1, #32768
	LDRSH	r2, [r3, #E_RES]
	MUL	r1, r2 	; on a potentiellement 32 bits
	LSR 	r1 ,#16 ; diviser par 2^16
	LDR 	r2 , =TIM3_CCR3
	STR	r1 , [r2]
	B	fin
arret	;si position > taille, mettre valeur moyen de resolution
	LDR	r1, [r3, #E_RES]
	LSR r1,#1	; resolition/2
	LDR r2 , =TIM3_CCR3
	STR	r1 , [r2]
		; Incrementer la valeur de position à chaque timer callback ( TIM 4 ) 
		;Calculer la valeur de TIM3 et l'affecter ;
; else 
; 		TIM3 = const ( ne pas la modifier ) ;
	

fin	bx	lr	; dernière instruction de la fonction ramenant à l'endroit appelé
	endp
;
	end