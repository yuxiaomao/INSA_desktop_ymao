; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code, readonly
	export subtest
;
subtest	proc
	push	{lr}
	push	{r0}
	ldr	r0, [r0] ;r0=i
	bl	subtest2
	pop	{r2}
	
	ldr r1,[r2,#4]
	add r0, r1
	;add r0, #[r2,#4] 
	str r0, [r2,#4] 
	
	pop	{pc};lr
	endp
;

; rend le cube sur 32 bits
subtest2	proc
	mul	r3, r0, r0
	mul	r0, r3, r0
	bx	lr
	endp
	end