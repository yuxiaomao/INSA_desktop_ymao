; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code, readonly
	export subtest
;
subtest	proc
	push	{lr}
	bl	subtest2
	ldr	r2,[r1]
	add	r0,r2
	str	r0,[r1]

	pop	{pc}
	endp
;

; rend le cube sur 32 bits
subtest2	proc
	mul	r3, r0, r0
	mul	r0, r3, r0
	bx	lr
	endp
	end