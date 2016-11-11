; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code, readonly
	export subtest
;
subtest	proc
	push	{lr}
	bl	subtest2
	add	r0,r1
	pop	{pc}
	endp
;

; rend le carre sur 32 bits
subtest2	proc
	mul	r0, r0, r0
	bx	lr
	endp
	end