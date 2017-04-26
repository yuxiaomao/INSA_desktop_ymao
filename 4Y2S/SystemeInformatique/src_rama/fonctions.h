/**********************************************************************************
 *  fonctions.c
 *
 *  Created by Rama Desplats and Yuxiao Mao on 21/02/17.
 *  Last modified on 21/02/17.
 *
 *  This file will contain all the functions use by Yacc actions
 **********************************************************************************/

#ifndef fonctions_h
#define fonctions_h

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

/**********************************************************************************
 * Constants and symbols definitions
 **********************************************************************************/

/* Array used to simulate the stack */
int pile[20];

/* Structure used to represent the symbol table*/
typedef struct {
    char *id;
    int init;
    int adresse;
    int type;
    int depth;
} type_tabvar;

/* The symbol table*/
type_tabvar tabvar[80];

/* Structure used to represent all the ASM instructions*/
typedef struct {
    char *instruct;
    char *reg1;
    char *reg2;
    char *reg3;
} type_tab_instruct;

/* Array of ASM instructions */
type_tab_instruct tab_instruct[90];
type_tab_instruct tab_instruct_op[90];

/* Structure used for jump in IF instructions */
typedef struct {
    int jmp_line;
    int jmp_dest;
    int depth;
} type_tab_jmp;

/* jmp_dest=0 means no destinations have been initiliazed yet as line starts at 1
 * in all text editors */

type_tab_jmp tab_jmp[10];

/* Structure used for jump in IF instructions */
typedef struct {
    int while_save;
    int while_line;
    int while_dest;
    int depth;
} type_tab_while;

/* jmp_dest=0 means no destinations have been initiliazed yet as line starts at 1
 * in all text editors */

type_tab_while tab_while[10];

/* Global variable declarations*/
int iterator,found;
int compteur;
int compteur_tmp;
int current_depth;
int compteur_asm;
int compteur_jmp;
int compteur_while;

//?//
int jmp_save;
int while_save;

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

#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

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

/**********************************************************************************
 *
 * @Name : malloc_asmline
 * @Descr : allocate memory for an asm line of the asmtab
 * @Args :
 *      @int line : line in the tab that need to be allocated
 *
 **********************************************************************************/

void malloc_asmline(int line);

/**********************************************************************************
 *
 * @Name : malloc_asmline_op
 * @Descr : allocate memory for an asm line of the asmtab in opcodes
 * @Args :
 *      @int line : line in the tab that need to be allocated
 *
 **********************************************************************************/

void malloc_asmline_op(int line);

/**********************************************************************************
 *
 * @Name : get_asmline & set_asmline
 * @Descr : getter and setter for asm line number
 * @Args : none
 *
 **********************************************************************************/

int get_asmline();

void set_asmline(int asmline);

/**********************************************************************************
 *
 * @Name : get_whilesave & set_whilesave
 * @Descr : getter and setter for while source asm save
 * @Args : none
 *
 **********************************************************************************/

int get_whilesave();

void set_whilesave(int asmwhile);

/**********************************************************************************
 *
 * @Name : get_depth & set_depth
 * @Descr : getter and setter for current_depth
 * @Args : none
 *
 **********************************************************************************/

int get_depth();

void set_depth(int depth);

/**********************************************************************************
 *
 * @Name : clear_depth
 * @Descr : clear all the variable of a given depth in the variable table
 * @Args :
 *      @int depth : depth of the variables that need to be clean
 *
 **********************************************************************************/

void clear_depth(int depth);

/**********************************************************************************
 *
 * @Name : get_tmp & set_tmp
 * @Descr : getter and setter for temporary variables counter
 * @Args : none
 *
 **********************************************************************************/

int get_tmp();

void set_tmp(int nbtmp);

/**********************************************************************************
 *
 * @Name : get_cpt_jmp & set_cpt_jmp
 * @Descr : getter and setter for jump counter
 * @Args : none
 *
 **********************************************************************************/

int get_cpt_jmp();

void set_cpt_jmp(int number);

/**********************************************************************************
 *
 * @Name : open_files
 * @Descr : open files in writing mode
 * @Args : none
 *
 **********************************************************************************/

void open_files();

/**********************************************************************************
 *
 * @Name : write_asm()
 * @Descr : open files in writing mode and write all the asm lines
 * @Args : none
 *
 **********************************************************************************/

void write_asm();

/**********************************************************************************
 *
 * @Name : write_asm_opcode()
 * @Descr : open files in writing mode and write all the asm lines
 * @Args : none
 *
 **********************************************************************************/

void write_asm_opcode();

/**********************************************************************************
 *
 * @Name : print_while_array
 * @Descr : print the entire while saved array
 * @Args : none
 *
 **********************************************************************************/

void print_while_array();

/**********************************************************************************
 *
 * @Name : print_jmp_array
 * @Descr : print the entire jmp saved array
 * @Args : none
 *
 **********************************************************************************/
void print_jmp_array();

/**********************************************************************************
 *
 * @Name : print_symbol_table
 * @Descr : print the symbol table for each variable
 * @Args : none
 *
 **********************************************************************************/
void print_symbol_table();

/**********************************************************************************
 *
 * @Name : print_asm_instructions
 * @Descr : print the entire asm instructions table
 * @Args : none
 *
 **********************************************************************************/
void print_asm_instructions();

/**********************************************************************************
 *
 * @Name : affect_variable
 * @Descr : try to affect the variable with the corresponding value and modify the
 *          value at variable's adress
 * @Args :
 *      @char *var1 : variable that is going to receive the value
 *      @int e1 : Arithmetical expression result that will be affected to @var1
 * @Return :
 *      . 0 if everything has been sucessfull
 *      . -1 if no variable with var1 name and same depth has been found
 *      . -2 if the variable found is a constant
 *
 **********************************************************************************/

int affect_variable(char *var1,int e1);

/**********************************************************************************
 *
 * @Name : declare_variable
 * @Descr : try to declare the variable without affectation and add it to the symbol table
 * @Args :
 *      @char *var1 : variable that is going to be declared
 * @Return :
 *      . 0 if everything has been sucessfull
 *      . -1 if a variable with var1 name has been found already
 *
 **********************************************************************************/

int declare_variable(char *var1);

/**********************************************************************************
 *
 * @Name : declare_variable_affectation
 * @Descr : try to declare the variable with affectation and add it to the symbol table
 * @Args :
 *      @char *var1 : variable that is going to be declared
 *      @int e1 : Arithmetical expression result that will be affected to @var1
 *      @int type : type of the variable
 * @Return :
 *      . 0 if everything has been sucessfull
 *      . -1 if a variable with var1 name has been found already
 *
 **********************************************************************************/

int declare_variable_affectation(char *var1, int e1, int type);

/**********************************************************************************
 *
 * @Name : print_symbol_value
 * @Descr : print the value of a given variable. For the subject purpose, printf only
 *          take one argument which is the variable.
 *          ex: printf(a);
 * @Args :
 *      @char *var1 : variable which value is going to be printed
 *
 **********************************************************************************/
void print_symbol_value(char *var1);

/**********************************************************************************
 *
 * @Name : store_variable()
 * @Descr : add store instruction after an affectation
 * @Args :
 *      @char *var1 : variable which value is receiving the result of an expression
 *
 **********************************************************************************/

void store_variable(char *var1);


/**********************************************************************************
 *
 * @Name : tId_value()
 * @Descr : return the value of a variable and add a temporary variable for
 *          arithmetical operations purpose
 * @Args :
 *      @char *var1 : variable which value is going to be returned
 * @Return :
 *      . the value of the variable if everything has been sucessfull
 *      . -1 if no variable with this name has been found
 *
 **********************************************************************************/

int tID_value(char *var1);

/**********************************************************************************
 *
 * @Name : tNB_value()
 * @Descr : add a temporary variable of the number for
 *          arithmetical operations purpose
 * @Args :
 *      @int *var1 : variable which value is going to be printed
 *
 **********************************************************************************/

void tNB_value(int var1);

/**********************************************************************************
 *
 * @Name : create_jump()
 * @Descr : add the jump asm instruction and set the variables in order to save where
 *          the jump has to be processed for IF instruction
 * @Args :
 *      @int depth : depth of the IF instruction
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if jmp array can't save more jmp instructions while waiting
 *        for destination to be added
 **********************************************************************************/

int create_jump(int depth);

/**********************************************************************************
 *
 * @Name : set_jump()
 * @Descr : set the jump with the informations gathered in the global variables
 * @Args :
 *      @int destination : destination for the jump to be set
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if we try to set a jump that has aready been set
 *
 **********************************************************************************/

int set_jump(int destination, int depth);

/**********************************************************************************
 *
 * @Name : create_while_jmp()
 * @Descr : add the jump asm instruction and set the variables in order to save where
 *          the jump has to be processed for WHILE instruction
 * @Args :
 *      @int source : source of the WHILE instruction
 *      @int depth : depth of the WHILE instruction
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if jmp array can't save more jmp instructions while waiting
 *        for destination to be added
 **********************************************************************************/

int create_while_jump(int source, int depth);

/**********************************************************************************
 *
 * @Name : set_while_jump()
 * @Descr : set the jump for while with the informations gathered in the global variables
 * @Args :
 *      @int destination : destination for the jump to be set
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if there is no jump to set
 *      . return -2 if the jump has already been set
 *
 **********************************************************************************/

int set_while_jump(int destination, int depth);

/**********************************************************************************
 *
 * @Name : arithmetical_expression()
 * @Descr : return the value of an arithmetical operation using the stack temporary
 *          variables
 * @Args :
 *      @int type : type of operations that has to be executed
 * @Return :
 *      . the value of the arithmetical opeartion if everything has been sucessfull
 *      . return 1 if boolean test is true, 0 if not
 *
 **********************************************************************************/

int arithmetical_expression(int type);

extern void PrintError(char *errorstring, ...);


#endif /* fonctions_h */
