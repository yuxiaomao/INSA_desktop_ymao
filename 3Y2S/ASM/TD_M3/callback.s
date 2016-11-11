; ce programme est pour l'assembleur RealView (Keil)
	thumb

	area  moncode, code, readonly
	export subtest
;

;pi/2=N/D
;x*N < 2^32 avec x<40000
;donc N<2^32/40000
;pi/2=51472/2^15 je n'ai pas mis 102944 car non recevable par registre
subtest	proc
	
	mov r2,#51472;N
	mul r0,r2
	lsr r0,#15;D=2^15
	
	bx	lr	; dernière instruction de la fonction
	endp
;
	end