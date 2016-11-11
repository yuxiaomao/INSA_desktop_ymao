; ce programme est pour l'assembleur RealView (Keil)
	thumb

;	area  madata, data, readwrite
;	export compteur4
	import TabCos
	import TabSin
	
	area  moncode, code, readonly
	export Calcul_Val ; pour exporter la fonction Calcul_DFT
;
;temporisation

Calcul_Val	proc
	PUSH	{r3, r4, r5, r6}
	MOV	r3, #0 ; valeur de i

	MOV	r6, #0		; resultat à renvoyer ( Re, ou Im )
boucle	MUL	r4, r1, r3	;mul i*k
	AND	r4, #63    	;indice du tableau= (i*k)modulo 64(n)
	LDRSH	r4, [r2, r4,LSL #1] ; Valeur dans le tableau à l'indice (i*k)mod64  ( r4 = cosousin((ik)mod64 * 2pi/N ) )  ; 
	; We use LSL because of Half-word, only on R4 = i
	LDRSH	r5, [r0, r3, LSL #1]  ; Valeur de x(i) 
	MLA	r6, r4 ,r5 ,r6   ; R6= R6 + R4*R5 = x(i) * cos/sin  ( tout le temps signé ) 
	ADD	r3, #1   ;i++
	CMP	r3, #64   ; if r3<64
	BLO	boucle
	MOV	r0, r6 
	POP	{r3, r4, r5, r6}
fin	bx	lr	; dernière instruction de la fonction ramenant à l'endroit appelé
	endp
;


	area  moncode, code, readonly
	export Calcul_DFT; pour exporter la fonction 
;
; calcul pour un tab de 64pts et une frequence (k*5khz) fixe
Calcul_DFT	proc
	PUSH	{lr}
	PUSH	{r0}	;sauvegarde adress signal
	LDR	r2, =TabCos
	BL	Calcul_Val
	SMULL	r12, r3, r0, r0	;r2 poids faible qu'on utilise pas 
	POP	{r0}
	LDR	r2, =TabSin
	BL	Calcul_Val
	SMLAL	r12, r3, r0, r0    ; MLA r1,r3 = r1,r3 + r0*r0
	MOV	r0, r3
	POP	{lr}
	bx	lr	; dernière instruction de la fonction ramenant à l'endroit appelé
	endp
;



	end
