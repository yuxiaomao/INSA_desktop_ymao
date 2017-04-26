%{
#include "y.tab.h"

%}

/* expression reg */
separateur [ \t\r\n]
id [A-Za-z][A-Za-z0-9_]*
nbdec [0-9]+\.[0-9]+
nbexp [0-9]+e[0-9]+
nb [0-9]+


%option yylineno
/*defined as 1 somewhere in yy.yacc.h ?*/
/* On peut rajouter yylineno qui s'incrémente à chaque \n pour
un message d'erreur qui affiche à quel ligne on fait une erreur*/

/* yytext is a reference into lex's token scanning buffer, 
 * it is only valid until the next time the parser calls yylex. 
 * need to make a copy of the string in yytext*/

%%
"\""                    { return tQUOTE; }
"main"                  { return tMAIN; }
"printf"                { return tPRINTF; }
"if"                    { return tIF; }
"else"                  { return tELSE; }
"while"                 { return tWHILE; }
"int"                   { return tINT; }
"const"                 { return tCONST; }
"("                     { return tPO; }
")"                     { return tPF; }
"{"                     { return tAO; }
"}"                     { return tAF; }
","                     { return tVIR; }
";"                     { return tPV; }
"=="                    { return tEQEQ; }
"="                     { return tEQ; }
"+"                     { return tADD; }
"-"                     { return tSUB; }
"*"                     { return tMUL; }
"/"                     { return tDIV; }
"!="				    { return tNEQ; }
"&&"                    { return tAND; }
"||"                    { return tOR; }
">"				  	    { return tSUP; }
"<"						{ return tINF; }
">="				  	{ return tSUPEQ; }
"<="					{ return tINFEQ; }

{separateur}            ;
{id}                    { yylval.str = strdup(yytext); return tID; }
{nb}   					{ yylval.nb = atoi(yytext); return tNB; }
{nbexp}|{nbdec} 		{ yylval.nb = (int)atof(yytext); return tNB; }

%%

int yywrap() {return 1;}