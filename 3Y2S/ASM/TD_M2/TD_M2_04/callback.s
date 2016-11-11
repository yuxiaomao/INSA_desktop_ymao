; ce programme est pour l'assembleur RealView (Keil)
	thumb

	area  madata, data, readwrite
	export compteur4

compteur4	dcd	0



	area  moncode, code, readonly
	export t4_callback
;
t4_callback	proc
	ldr	r1, =compteur4
	ldr	r0, [r1]
	add	r0, #1
	str	r0, [r1]
	bx	lr	; dernière instruction de la fonction
	endp
;
	end