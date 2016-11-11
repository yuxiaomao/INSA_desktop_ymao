	thumb
	area	reset, data, readonly
	export __Vectors
__Vectors
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	dcd	Reset_Handler	; point d'entree de notre programme
;
	area	moncode, code, readonly
;
; procedure principale
;
	export	Reset_Handler
Reset_Handler proc

	ldr r0,=1
	ldr r1,=0x55
	ldr r2,=0x228
	ldr r3,=0x1ff
	ldr r4,=-1
	ldr r5,=0x15263748
	ldr r6,=0x12345678
	push {r6,r5,r1}
	mov r1,#0
	mov r5,#0
	mov r6,#0
	ldr r1,[SP]
	ldr r5,[SP,#4]
	ldr r6,[SP,#8]
	pop {r5,r6}
	
boo     b       boo
	endp
;
	end