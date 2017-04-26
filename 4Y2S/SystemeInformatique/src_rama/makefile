cleaner: cleaner.c asm_analyser.c parser
	gcc cleaner.c -o cleaner
	gcc asm_analyser.c -o asm_analyser

parser: y.tab.c lex.yy.c fonctions.c
	gcc y.tab.c lex.yy.c fonctions.c -ll -o parser

y.tab.c: erase compilateur.y
	yacc -d -v compilateur.y

lex.yy.c: compilateur.l 
	lex compilateur.l

erase: 
	 rm -f cleaner asm_analyser parser lex.yy.c y.output y.tab.c y.tab.h