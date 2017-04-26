/**********************************************************************************
*  compilateur.y
*
*  Created by Rama Desplats and Yuxiao Mao on 21/02/17.
*  Last modified on 21/02/17.
*
*  This file will contain all the functions use by Yacc actions
**********************************************************************************/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "fonctions.h"

int yylex(void);
void yyerror(char *s);

/* Type definition for the type column of the symbol table*/
#define TYPE_NORMAL 0
#define TYPE_CONST 1
#define TYPE_TMP 2

/* Type definition for arithmetical operations purpose */
#define EQEQ 10
#define NEQ 11
#define AND 12
#define OR 13
#define ADD 14
#define SUB 15
#define MUL 16
#define DIV 17
#define INF 18
#define SUP 19
#define INFEQ 20
#define SUPEQ 21

/* Type definition for enhanced printf */
#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

%}

/*
* Priorities definition on arithmetic expressions' tokens
* Prevents from reduce/reduce and deplacement/reduce conflicts
*/
%left tOR tAND tSUP tINF tNEQ tSUPEQ tINFEQ
%right tEQ
%left tADD tSUB
%left tMUL tDIV
%left tEQEQ
%left tPO tPF
%left error tPV

/*Union for yyval*/
%union {int nb; char *str;}

/*
* Token defintions and return type defintions for non-terminal token
*/
%token tMAIN tPRINTF tQUOTE
%token tIF tELSE tWHILE
%token tINT tCONST
%token tVIR tPV  tPF tAF /* , ; )  } */
%token tEQ tEQEQ tAND tOR tNEQ tSUP tINF tSUPEQ tINFEQ /* = == && || != > < <= >= */
%token tADD tSUB tMUL tDIV /* + - * / */
%token <nb> tPO tAO /* For value saving purpose we use PO and AO as int token */
%token <str> tID
%token <nb> tNB
%type <nb> E Invocation
%type <str> Decl1 Decl1Const Fonction

/*
* Entry point for Yacc
*/
%start Prog

%%

Prog :  {open_files();}//open files
        Fonctions
        | Prog error tPV {yyerrok;}
;

Fonctions :
		/*epsilon*/
		| Main
		| Fonction Fonctions
;


Main :
        tINT tMAIN tPO Params tPF Body {
            print_symbol_table();
            print_asm_instructions();
            write_asm();
            write_asm_opcode();
        }
;

/*
BodyMain :
        tAO DeclMain Insts tAF
            {print_symbol_table();}

;

DeclMain :
		| Declaration tPV DeclMain
        | DeclMain error tPV { yyerrok;}
;*/

Fonction :
		tINT tID tPO Args tPF Body
			{printf("Function definition %s.\n", $2);}
;

Args :
		/*epsilon*/
		| tINT tID ArgsN
		| tCONST tID ArgsN
;

ArgsN :
		/*epsilon*/
		| tVIR tINT tID ArgsN
		| tCONST tINT tID ArgsN
;

//pour eviter les bug checquer les profondeurs

Body :
        tAO {$1=get_depth();set_depth($1+1);} Insts {set_depth($1);} tAF {
            if(set_jump(get_asmline(),$1)==-2){
                yyerror("The if jump has already been set.");
                /* @1.first_line returns the line where else is located so we add 1
                 * to get the line just under token else which is the first instruction
                 * of else block. Plus the set had to be added here as if might not
                 * be associated to else. We use the tAF has end of If */
            }
            if(set_while_jump(get_asmline()+2,$1)==-2){
                //We add 2 as there are two asm instructions added in the set_while_jump
                //which are the one to jump back to while condition
                yyerror("The while jump has already been set.");
            }
            clear_depth($1+1);
        }
        | Body error tPV {yyerrok;}
;

Insts :
		/*epsilon*/
		| Affectation tPV Insts
        | Declaration tPV Insts
		| Invocation tPV Insts
		| If Insts
		| While Insts
        | Printf tPV Insts
;

Affectation :
		tID tEQ E
            { int result=affect_variable($1,$3);
              if(result==-1){
                  yyerror("trying to affect a value to an undeclared variable");
              }
              else if (result==-2){
                  yyerror("trying to affect a value to a constant");
              }
              store_variable($1);
            }

;

Declaration :
		tINT Decl1 DeclN
		| tCONST tINT Decl1Const DeclNConst

;



Decl1 :
		tID
			{$$ = $1;
                if(declare_variable($1)==-1){
                    yyerror("redefinition of a variable");
                }
            }
		| tID tEQ E
			{$$ = $1;
                if(declare_variable_affectation($1,$3,TYPE_NORMAL)==-1){
                    yyerror("redefinition of a variable");
                }
                store_variable($1);
            }
;

DeclN :
		/*epsilon*/
		| tVIR Decl1 DeclN
;

Decl1Const :
		tID tEQ E
			{$$ = $1;
                if(declare_variable_affectation($1,$3,TYPE_CONST)==-1){
                    fprintf(stderr, "error: redefinition of \'%s\'\n.",$1);
                }
                store_variable($1);
            }
;

DeclNConst :
		/*epsilon*/
		| tVIR Decl1Const DeclNConst
;

Invocation :
		tID tPO Params tPF
			{$$ = 0;printf("Invocation\n");}
;

Params :
		/*epsilon*/
		| E ParamsN
;

ParamsN :
		/*epsilon*/
		| tVIR E ParamsN
;

Printf :
        | tPRINTF tPO tID tPF{
            print_symbol_value($3);};
        //idée de printf plus compliqué :
        /*| tPRINTF tPO tQUOTE tID %[dsf] TQUOTE tPF tVIR E
        * mais tVIR et E ne doivent être présent que si on a un elt à afficher
        * (présence de *dsf)*/

If :
        tIF tPO E {
                set_tmp(get_tmp()-1);
    /* decrement temporary variables counter as for comparaisons in if, two temporary variables
     * are initialized and if there is compteur_tmp=compteur_tmp-2; in arithmetical expression
     * it is not working for some reasons jump(); */
        } tPF {
            if(create_jump(get_depth())==-1){
                yyerror("Maximum jmp saved limit has been reached./nYour last jmp instructions for IF might have not been saved.");
            }
        } Body Else{
            printf("If (%d) {}\n\n", $3);
        }
;

Else :
		/*epsilon*/
        | tELSE {
            
            //we add one jump counter just to ignore the double AC from else and AC from if
        } Body
;

While :
tWHILE tPO {
        $2=get_asmline();
        } E {
                set_tmp(get_tmp()-1);
        } tPF {
            if(create_while_jump($2,get_depth())==-1){
                yyerror("Maximum jmp saved limit has been reached./nYour last jmp instructions for WHILE might have not been saved.");
            }
        }Body{
                //printf("While (%d)\n",$3);
        }
;

/* in each arithmetical expressions make sure that the variables are both initialized*/
E :
		tID {
            $$=tID_value($1);
        }
        | tNB {
            tNB_value($1);
            $$ = $1;
        }
		| tPO E tPF {$$ = $2;}
		| Invocation
		| E tEQEQ E {
                $$=arithmetical_expression(EQEQ);
        }
		| E tNEQ E {
                $$=arithmetical_expression(NEQ);
        }
		| E tAND E {$$ = ($1 && $3);}
		| E tOR E {$$ = ($1 || $3);}
		| E tADD E {
                $$=arithmetical_expression(ADD);
        }
		| E tSUB E {
            $$=arithmetical_expression(SUB);
        }
        | E tMUL E {
            $$=arithmetical_expression(MUL);
        }
        | E tDIV E {
            $$=arithmetical_expression(DIV);
        }
		| E tINF E {
            $$=arithmetical_expression(INF);
        }
		| E tSUP E {
            $$=arithmetical_expression(SUP);
        }
        | E tINFEQ E {
            $$=arithmetical_expression(INFEQ);
        }
        | E tSUPEQ E {
            $$=arithmetical_expression(SUPEQ);
        }
        | E error tPV {yyerrok;}
;


%%
extern FILE *yyin;

extern int optind ;
extern char *optarg ;

void printUsage (const char *exec, FILE* stream) {
    fprintf(stream, "Usage: %s input\n", exec) ;
}

void yyerror(char *s) {
    
    extern int yylineno; /* defined in lex.c*/
    
    printf(BOLDRED "Error: ");
    printf("%s on line %d\n\n", s, yylineno);
    printf(RESET);

}
int main(int argc, char *argv[]){
    int res;
    char opt;
    
    char *tmpName = "result.tmp" ;
    
    if (!(optind < argc)) {
        fprintf(stderr, "No input file specified.\n") ;
        printUsage(argv[0], stderr) ;
        return 1 ;
    }
    yyin = fopen(argv[optind], "r") ;
    if (!yyin) {
        fprintf(stderr, "Input file \"%s\" not found.\n", argv[optind]) ;
        printUsage(argv[0], stderr) ;
        return 1 ;
    }
    
    printf("  \n");
    printf(BOLDBLACK "     === Sample program of a C to ASM translator ===     \n" RESET);
    printf(BOLDBLACK "       *** Authors: Rama Desplats & Yuxiao Mao ***           \n" RESET);
    printf("  \n");
    printf(CYAN "                     +++ Parsing +++                      \n" RESET);
    res= yyparse();
    printf("  \n");
    printf(CYAN "                  +++ End of Parsing +++                      \n\n" RESET);
    
    /*if (getNbErrors()) {
     unlink(tmpName) ;
     return 1 ;
     //If there are errors then we unlink the asm file
     }*/
    
    return res;
}

