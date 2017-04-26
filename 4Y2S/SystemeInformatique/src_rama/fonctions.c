/**********************************************************************************
*  fonctions.c
*
*  Created by Rama Desplats and Yuxiao Mao on 21/02/17.
*  Last modified on 21/02/17.
*
*  This file will contain all the functions use by Yacc actions
**********************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "fonctions.h"

/**********************************************************************************
 * Constants and symbols definitions
 **********************************************************************************/

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

/*
 * Open a file
 */
static FILE* fichier;
static FILE* fichier_op;

/**********************************************************************************
 *
 * @Name : malloc_asmline
 * @Descr : allocate memory for an asm line of the asmtab
 * @Args : 
 *      @int line : line in the tab that need to be allocated
 *
 **********************************************************************************/

void malloc_asmline(int line){
    tab_instruct[line].instruct=malloc(sizeof(char)*5);
    tab_instruct[line].reg1=malloc(sizeof(char)*4);
    tab_instruct[line].reg2=malloc(sizeof(char)*4);
    tab_instruct[line].reg3=malloc(sizeof(char)*4);
}

/**********************************************************************************
 *
 * @Name : malloc_asmline_op
 * @Descr : allocate memory for an asm line of the asmtab in opcodes
 * @Args :
 *      @int line : line in the tab that need to be allocated
 *
 **********************************************************************************/

void malloc_asmline_op(int line){
    tab_instruct_op[line].instruct=malloc(sizeof(char)*5);
    tab_instruct_op[line].reg1=malloc(sizeof(char)*5);
    tab_instruct_op[line].reg2=malloc(sizeof(char)*5);
    tab_instruct_op[line].reg3=malloc(sizeof(char)*5);
}

/**********************************************************************************
 *
 * @Name : get_asmline & set_asmline
 * @Descr : getter and setter for asm line number
 * @Args : none
 *
 **********************************************************************************/

int get_asmline(){
    //printf("getting depth: %d\n",current_depth);
    return compteur_asm;
}

void set_asmline(int asmline){
    //printf("setting depth: %d\n",depth);
    compteur_asm=asmline;
}

/**********************************************************************************
 *
 * @Name : get_whilesave & set_whilesave
 * @Descr : getter and setter for while source asm save
 * @Args : none
 *
 **********************************************************************************/

int get_whilesave(){
    //printf("getting depth: %d\n",current_depth);
    return while_save;
}

void set_whilesave(int asmwhile){
    //printf("setting depth: %d\n",depth);
    while_save=asmwhile;
}

/**********************************************************************************
 *
 * @Name : get_depth & set_depth
 * @Descr : getter and setter for current_depth
 * @Args : none
 *
 **********************************************************************************/

int get_depth(){
    //printf("getting depth: %d\n",current_depth);
    return current_depth;
}

void set_depth(int depth){
    //printf("setting depth: %d\n",depth);
    current_depth=depth;
}

/**********************************************************************************
 *
 * @Name : get_cpt_jmp & set_cpt_jmp
 * @Descr : getter and setter for jump counter
 * @Args : none
 *
 **********************************************************************************/

int get_cpt_jmp(){
    return compteur_jmp;
}

void set_cpt_jmp(int number){
    compteur_jmp=number;
}

/**********************************************************************************
 *
 * @Name : clear_depth
 * @Descr : clear all the variable of a given depth in the variable table
 * @Args :
 *      @int depth : depth of the variables that need to be clean
 *
 **********************************************************************************/

void clear_depth(int depth){
    if(depth!=1){
        int count=0;
        printf(YELLOW "Clearing all the variables of %d depth.\n",depth);
        printf(RESET);
        for(iterator=0;iterator<compteur+compteur_tmp;iterator++){
            if(tabvar[iterator].depth==depth){
                count=count+1;
            }
        }
        compteur=compteur-count;
        printf(GREEN "Cleared %d variables\n\n",count);
        printf(RESET);
    }
}

/**********************************************************************************
 *
 * @Name : get_tmp & set_tmp
 * @Descr : getter and setter for temporary variables counter
 * @Args : none
 *
 **********************************************************************************/

int get_tmp(){
    //printf("getting depth: %d\n",current_depth);
    return compteur_tmp;
}

void set_tmp(int nbtmp){
    //printf("setting depth: %d\n",depth);
    compteur_tmp=nbtmp;
}


/**********************************************************************************
 *
 * @Name : open_files
 * @Descr : open files in writing mode
 * @Args : none
 *
 **********************************************************************************/

void open_files(){
    printf( BOLDBLACK "\n==> Creating the files\n\n" RESET );
    fichier=fopen("result_clair.txt", "w");
    fichier_op=fopen("result_opcode.txt", "w");
}

/**********************************************************************************
 *
 * @Name : write_asm()
 * @Descr : open files in writing mode and write all the asm lines
 * @Args : none
 *
 **********************************************************************************/

void write_asm(){
    printf( BOLDBLACK "\n==> Writing ASMLines in file\n\n" RESET );
    fichier=fopen("result_clair.txt", "a+");
    for(iterator=0;iterator<compteur_asm;iterator++){
        
        fwrite(tab_instruct[iterator].instruct, 1, sizeof(char)*5, fichier);
        fwrite(" ",1,sizeof(char),fichier);
        fwrite(tab_instruct[iterator].reg1, 1, sizeof(char)*4, fichier);
        fwrite(" ",1,sizeof(char),fichier);
        fwrite(tab_instruct[iterator].reg2, 1, sizeof(char)*4, fichier);
        fwrite(" ",1,sizeof(char),fichier);
        fwrite(tab_instruct[iterator].reg3, 1, sizeof(char)*4, fichier);
        fwrite("\n",1,sizeof(char),fichier);
    }
    fclose(fichier);
}

/**********************************************************************************
 *
 * @Name : write_asm_opcode()
 * @Descr : open files in writing mode and write all the asm lines
 * @Args : none
 *
 **********************************************************************************/

void write_asm_opcode(){
    printf( BOLDBLACK "\n==> Writing ASMLines (opcodes) in file\n\n" RESET );
    fichier=fopen("result_opcode.txt", "a+");
    for(iterator=0;iterator<compteur_asm;iterator++){
        fwrite(tab_instruct_op[iterator].instruct, 1, sizeof(char)*5, fichier);
        fwrite(" ",1,sizeof(char),fichier);
        fwrite(tab_instruct_op[iterator].reg1, 1, sizeof(char)*5, fichier);
        fwrite(" ",1,sizeof(char),fichier);
        fwrite(tab_instruct_op[iterator].reg2, 1, sizeof(char)*5, fichier);
        fwrite(" ",1,sizeof(char),fichier);
        fwrite(tab_instruct_op[iterator].reg3, 1, sizeof(char)*5, fichier);
        fwrite("\n",1,sizeof(char),fichier);
    }
    fclose(fichier);
}


/**********************************************************************************
 *
 * @Name : print_symbol_table
 * @Descr : print the symbol table for each variable
 * @Args : none
 *
 **********************************************************************************/
void print_symbol_table(){
    printf("------------------------------------------------------------------------\n");
    printf("|####################### ");
    printf(BOLDBLACK "TABLE DES SYMBOLES " RESET);
    printf("###########################|\n");
    printf("|----------------------------------------------------------------------|\n");
    printf("|   var   |   init   |   type    |   adresse   |   depth   |   value   |\n");
    printf("|----------------------------------------------------------------------|\n");
    for(iterator=0;iterator<compteur+compteur_tmp;iterator++){
        printf("|   %s   |",tabvar[iterator].id);
        if(tabvar[iterator].init==0){
            printf(RED " not_init " RESET);
            printf("|   ");
        }
        else{
            printf(GREEN "   init   " RESET);
            printf("|   " );
        }
        if(tabvar[iterator].type==0){
            printf("int   |   ");
        }
        else if(tabvar[iterator].type==1){
            printf("const |   ");
        }
        else{
            printf("tmp   |   ");
        }
        printf("%d   |   ",tabvar[iterator].adresse);
        printf("%d   |   ",tabvar[iterator].depth);
        printf("%d   |\n",pile[tabvar[iterator].adresse]);
    }
    printf("------------------------------------------------------------------------\n");
    
}

/**********************************************************************************
 *
 * @Name : print_while_array
 * @Descr : print the entire while saved array
 * @Args : none
 *
 **********************************************************************************/

void print_while_array(){

    printf("-------------------------------------------------------------\n");
    printf("|####################    ");
    printf(BOLDBLACK "WHILE ARRAY   " RESET);
    printf("#####################|\n");
    printf("|-----------------------------------------------------------|\n");
    printf("|    while from line    |   while destination   |   depth   |\n");
    printf("|-----------------------------------------------------------|\n");
    for(iterator=0;iterator<compteur_while;iterator++){
        printf("|         %d         |",tab_while[iterator].while_line);
        printf("         %d         |",tab_while[iterator].while_dest);
        printf("         %d       |\n",tab_while[iterator].depth);
    }
    printf("-------------------------------------------------------------\n");
    
}

/**********************************************************************************
 *
 * @Name : print_jmp_array
 * @Descr : print the entire jmp saved array
 * @Args : none
 *
 **********************************************************************************/

void print_jmp_array(){
    
    printf("-------------------------------------------------------------\n");
    printf("|####################     ");
    printf(BOLDBLACK "JMP ARRAY    " RESET);
    printf("#####################|\n");
    printf("|-----------------------------------------------------------|\n");
    printf("|    jmp from line    |   jmp destination   |     depth     |\n");
    printf("|-----------------------------------------------------------|\n");
    for(iterator=0;iterator<compteur_jmp;iterator++){
        printf("|         %d         |",tab_jmp[iterator].jmp_line);
        printf("         %d         |",tab_jmp[iterator].jmp_dest);
        printf("         %d        |\n",tab_jmp[iterator].depth);

    }
    printf("-------------------------------------------------------------\n");
    
}

/**********************************************************************************
 *
 * @Name : print_asm_instructions
 * @Descr : print the entire asm instructions table
 * @Args : none
 *
 **********************************************************************************/

void print_asm_instructions(){
    printf("----------------------------------------------------------------------\n");
    printf("|###################### ");
    printf(BOLDBLACK "ASM INSTRUCT ARRAY " RESET);
    printf("##########################|\n");
    printf("|--------------------------------------------------------------------|\n");
    printf(CYAN "==> lines are printed for debug purposes\n\n"RESET);
    for(iterator=0;iterator<compteur_asm;iterator++){
        printf("line %d - ",iterator);
        if (strcmp(tab_instruct[iterator].instruct,"LOAD")==0 || strcmp(tab_instruct[iterator].instruct,"JMPC")==0){
            printf(BOLDBLACK"%s  ",tab_instruct[iterator].instruct);
            printf(RESET);
        }
        else if(strcmp(tab_instruct[iterator].instruct,"STORE")==0){
            printf(BOLDBLACK "%s ",tab_instruct[iterator].instruct);
            printf(RESET);
        }
        else{
            printf(BOLDBLACK "%s   ",tab_instruct[iterator].instruct);
            printf(RESET);
        }
        printf(BOLDBLACK"%s   ",tab_instruct[iterator].reg1);
        printf("%s   ",tab_instruct[iterator].reg2);
        printf("%s\n",tab_instruct[iterator].reg3);
        printf(RESET);
    }
    printf("----------------------------------------------------------------------\n");
}

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
 *      . -1 if no variable with var1 name has been found
 *      . -2 if the variable found is a constant
 *
 **********************************************************************************/

int affect_variable(char *var1,int e1){
    //r+ - open for reading and writing, start at beginning
    int result=-1;
    for(iterator=0;iterator<compteur;iterator++){
        if(strcmp(tabvar[iterator].id,var1)==0){
            if(tabvar[iterator].type!=TYPE_CONST){
                tabvar[iterator].init=1; //init=true
                pile[tabvar[iterator].adresse]=e1;
                printf(CYAN "\n==> " RESET);
                printf("Affectation %s, value : %d.\n", var1, e1);
                result=0;
                printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp+1);
                compteur_tmp=compteur_tmp-1;
                printf(RESET);
                //compteur_asm=compteur_asm-1;
                /* We should not consider e1 temporary variable as it is already the result of
                 * a arithmetical expression. That is why we decrement the temporary variable counter.
                 */
            }
            else{
                result=-2;
            }
        }
    }
    return result;
}

/**********************************************************************************
 *
 * @Name : declare_variable
 * @Descr : try to declare the variable without affectation and add it to the symbol table
 * @Args :
 *      @char *var1 : variable that is going to be declared
 * @Return :
 *      . 0 if everything has been sucessfull
 *      . -1 if a variable with var1 name and same depth has been found already
 *
 **********************************************************************************/

int declare_variable(char *var1){
    int result=0;
    printf(GREEN "\n==> " RESET);
    printf("Declaration %s.\n", var1);
    for(iterator=0;iterator<compteur;iterator++){
        if(strcmp(tabvar[iterator].id,var1)==0 && current_depth==tabvar[iterator].depth){
            result=-1;
        }
    }
    //if no variable with the same name has been found
    if(result==0){
        tabvar[compteur].id=var1;
        tabvar[compteur].adresse=compteur;
        tabvar[compteur].type=TYPE_NORMAL;
        tabvar[compteur].init=0;
        tabvar[compteur].depth=current_depth;
        pile[compteur]=0;
        printf(BLUE "Added %s at adress %d.\n", var1, compteur);
        printf(RESET);
        compteur++;
    }
    return result;
}

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

int declare_variable_affectation(char *var1, int e1, int type){
    
    int result=0;
    printf(GREEN "==> " RESET);
    printf("Declaration with affectation %s.\n", var1);
    for(iterator=0;iterator<compteur;iterator++){
        if(strcmp(tabvar[iterator].id,var1)==0 && current_depth==tabvar[iterator].depth){
            result=-1;
        }
    }
    //if no variable with the same name has been found
    if(result==0){
        tabvar[compteur].id=var1;
        tabvar[compteur].adresse=compteur;
        tabvar[compteur].init=1;
        tabvar[compteur].depth=current_depth;
        if (type==TYPE_NORMAL) {
            tabvar[compteur].type=TYPE_NORMAL;
        }
        else{
            tabvar[compteur].type=TYPE_CONST;
        }
        printf(BLUE "Added %s at adress %d.\n", var1, compteur);
        printf(RESET);
        pile[compteur]=e1;
        printf("Affectation %s, value : %d.\n", var1, e1);
        printf(YELLOW "Removing tmp variable at adress %d.\n\n",compteur_tmp+1);
        printf(RESET);
        compteur_tmp=compteur_tmp-1;
        //compteur_asm=compteur_asm-1;
        compteur++;
    }
    return result;
}

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
void print_symbol_value(char *var1){
    for(iterator=0;iterator<compteur;iterator++){
        if(strcmp(tabvar[iterator].id,var1)==0){
            printf("%d\n",pile[tabvar[iterator].adresse]);
        }
    }
}

/**********************************************************************************
 *
 * @Name : store_variable()
 * @Descr : add store instruction after an affectation
 * @Args :
 *      @char *var1 : variable which value is receiving the result of an expression
 *
 **********************************************************************************/

void store_variable(char *var1){
    char *final=malloc(sizeof(char)*5);
    char *append=malloc(sizeof(char)*2);
    int result=-1;
    for(iterator=compteur-1;iterator>=0;iterator--){
        if(strcmp(tabvar[iterator].id,var1)==0){
            //Adding ASM Instruction
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //printf("###%d     #######%d\n",compteur_tmp, compteur_asm);
            strcpy(tab_instruct[compteur_asm].instruct,"AFC");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            sprintf(append,"%d",tabvar[iterator].adresse);
            strcpy(tab_instruct[compteur_asm].reg2,append);
            strcpy(tab_instruct[compteur_asm].reg3,"");
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x06");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            sprintf(append,"%d",tabvar[iterator].adresse);
            strcpy(tab_instruct_op[compteur_asm].reg2,append);
            strcpy(tab_instruct_op[compteur_asm].reg3,"");
            compteur_asm=compteur_asm+1;
            
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            strcpy(tab_instruct[compteur_asm].instruct,"STORE");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm-2].reg1);
            strcpy(tab_instruct[compteur_asm].reg3,"");
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x08");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm-2].reg1);
            strcpy(tab_instruct_op[compteur_asm].reg3,"");
            compteur_asm=compteur_asm+1;
            
            //print_asm_instructions();
            //print_symbol_table();
            
            break;
        }
    }

}


/**********************************************************************************
 *
 * @Name : tId_value()
 * @Descr : return the value of a variable and add a temporary variable for 
 *          arithmetical operations purpose
 * @Args :
 *      @char *var1 : variable which value is going to be returned
 * @Return :
 *      . the value of the variable if everything has been sucessfull
 *      . -1 if no variable with this name has been found or hasn't been initialized
 *
 **********************************************************************************/

int tID_value(char *var1){
    char *final=malloc(sizeof(char)*5);
    char *append=malloc(sizeof(char)*2);
    int result=-1;
    for(iterator=compteur-1;iterator>=0;iterator--){
        if(strcmp(tabvar[iterator].id,var1)==0){
            //Adding ASM Instruction
            
            //printf("value : %s and init : %d\n",tabvar[iterator].id, tabvar[iterator].init);
            
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //printf("###%d     #######%d\n",compteur_tmp, compteur_asm);
            strcpy(tab_instruct[compteur_asm].instruct,"AFC");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            sprintf(append,"%d",tabvar[iterator].adresse);
            strcpy(tab_instruct[compteur_asm].reg2,append);
            strcpy(tab_instruct[compteur_asm].reg3,"");
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x06");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            sprintf(append,"%d",tabvar[iterator].adresse);
            strcpy(tab_instruct_op[compteur_asm].reg2,append);
            strcpy(tab_instruct_op[compteur_asm].reg3,"");
            compteur_asm=compteur_asm+1;
            
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            strcpy(tab_instruct[compteur_asm].instruct,"LOAD");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(tab_instruct[compteur_asm].reg3,"");
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x07");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(tab_instruct_op[compteur_asm].reg3,"");
            compteur_asm=compteur_asm+1;
            
            //print_asm_instructions();
            //print_symbol_table();
            
            tabvar[compteur+compteur_tmp].id="_tmp";
            tabvar[compteur+compteur_tmp].adresse=compteur+compteur_tmp;
            tabvar[compteur+compteur_tmp].type=TYPE_TMP;
            pile[tabvar[compteur+compteur_tmp].adresse]=pile[tabvar[iterator].adresse];
            /*printf(YELLOW "Added temporary id %s at adress %d with value %d.\n", tabvar[compteur+compteur_tmp].id, compteur+compteur_tmp, pile[tabvar[compteur+compteur_tmp].adresse]);
            printf(RESET);*/
            //print_symbol_table();
            compteur_tmp++;
            result=pile[tabvar[iterator].adresse];
            break;
        }
    }
    free(final);
    free(append);
    
    return result;
}

/**********************************************************************************
 *
 * @Name : tNB_value()
 * @Descr : add a temporary variable of the number for
 *          arithmetical operations purpose
 * @Args :
 *      @int var1 : variable which value is going to be printed
 *
 **********************************************************************************/

void tNB_value(int var1){
    char *final=malloc(sizeof(char)*4);
    char *append=malloc(sizeof(char)*2);
    int result=-1;
    
    malloc_asmline(compteur_asm);
    malloc_asmline_op(compteur_asm);
    
    strcpy(tab_instruct[compteur_asm].instruct,"AFC");
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp);
    strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
    sprintf(append,"%d",var1);
    strcpy(tab_instruct[compteur_asm].reg2,append);
    strcpy(tab_instruct[compteur_asm].reg3,"");
    
    strcpy(tab_instruct_op[compteur_asm].instruct,"0x06");
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp);
    strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
    sprintf(append,"%d",var1);
    strcpy(tab_instruct_op[compteur_asm].reg2,append);
    strcpy(tab_instruct_op[compteur_asm].reg3,"");
    compteur_asm=compteur_asm+1;
    
    
    //print_asm_instructions();
    //print_symbol_table();
    
    tabvar[compteur+compteur_tmp].id=malloc(sizeof(char)*5);
    tabvar[compteur+compteur_tmp].id="_tmp";
    tabvar[compteur+compteur_tmp].adresse=compteur+compteur_tmp;
    tabvar[compteur+compteur_tmp].type=TYPE_TMP;
    pile[tabvar[compteur+compteur_tmp].adresse]=var1;
    /*printf(YELLOW "Added temporary nb %s at adress %d with value %d.\n", tabvar[compteur+compteur_tmp].id, compteur+compteur_tmp, pile[tabvar[compteur+compteur_tmp].adresse]);
     printf(RESET);*/
    compteur_tmp++;
    
    free(final);
    free(append);
}

/**********************************************************************************
 *
 * @Name : create_jump()
 * @Descr : add the jump asm instruction and set the variables in order to save where
 *          the jump has to be processed
 * @Args :
 *      @int depth : depth of the IF instruction
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if jmp array can't save more jmp instructions while waiting 
 *        for destination to be added
 **********************************************************************************/

int create_jump(int depth){
    int jmp_tabsize=sizeof(tab_jmp) / sizeof(tab_jmp[0]);
    int result=0;
    
    char *final=malloc(sizeof(char)*5);
    char *append=malloc(sizeof(char)*2);
    
    //Set the register that will receive the @ where to jump
    //as @ is unknown we put blank instead
    malloc_asmline(compteur_asm);
    malloc_asmline_op(compteur_asm);
    
    //Adding ASM Instruction
    strcpy(tab_instruct[compteur_asm].instruct,"AFC");
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
    strcpy(tab_instruct[compteur_asm].reg2,"");
    strcpy(tab_instruct[compteur_asm].reg3,"");
    
    strcpy(tab_instruct_op[compteur_asm].instruct,"0x06");
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
    strcpy(tab_instruct_op[compteur_asm].reg2,"");
    strcpy(tab_instruct_op[compteur_asm].reg3,"");

    
    //prevents from segmentation fault errors
    if(compteur_jmp>=jmp_tabsize){
        result=-1;
    }
    else{
        tab_jmp[compteur_jmp].jmp_line=compteur_asm;
        tab_jmp[compteur_jmp].jmp_dest=0;
        tab_jmp[compteur_jmp].depth=depth;
        compteur_jmp=compteur_jmp+1;
        printf(BLUE "\nSaved jmp number %d at line %d in the asm tab\n",compteur_jmp,compteur_asm);
        printf(RESET);
    }
    
    print_jmp_array();
    
    compteur_asm=compteur_asm+1;
    
    malloc_asmline(compteur_asm);
    malloc_asmline_op(compteur_asm);
    
    //JMP JUMP IF RI==0 so if boolean condition of while is false
    //=> so jump to the else part of the function
    
    //Adding ASM Instruction
    strcpy(tab_instruct[compteur_asm].instruct,"JMPC");
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp);
    strcpy(tab_instruct[compteur_asm].reg2,strcat(final,append));
    strcpy(tab_instruct[compteur_asm].reg3,"");
    
    strcpy(tab_instruct_op[compteur_asm].instruct,"0xF");
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp);
    strcpy(tab_instruct_op[compteur_asm].reg2,strcat(final,append));
    strcpy(tab_instruct_op[compteur_asm].reg3,"");
 
    compteur_asm=compteur_asm+1;
    
    free(final);
    free(append);
    
    return result;

}

/**********************************************************************************
 *
 * @Name : set_jump()
 * @Descr : set the jump with the informations gathered in the global variables
 * @Args :
 *      @int destination : destination for the jump to be set
 *      @int depth : depth of the jump to be set
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if there is no jump to set
 *      . return -2 if the jump has already been set
 *
 **********************************************************************************/

int set_jump(int destination, int depth){
    
    char *append=malloc(sizeof(int));
    int result=0;
    int i;
    
    for (i=compteur_jmp-1;i>=0;i--){
        if(tab_jmp[i].jmp_dest==0 && tab_jmp[i].depth==depth){
            
            //printf("ASM LINE : %d - %d\n",get_asmline(), depth);
            printf(BLUE "Tyring to set a jump to dest %d from line %d\n",destination,tab_jmp[i].jmp_line);
            printf(RESET);
            tab_jmp[i].jmp_dest=destination;
            sprintf(append,"%d",destination);
            strcpy(tab_instruct[tab_jmp[i].jmp_line].reg2,append);
            strcpy(tab_instruct_op[tab_jmp[i].jmp_line].reg2,append);
            
            print_jmp_array();
            
            compteur_jmp=compteur_jmp-1;
            //We decrement the compteur_jmp so the next jmp will overwrite
            //the one we just set
            break;
        }
        if(i==0 && tab_jmp[i].jmp_dest!=0){
            result=-2;
        }
    }
    
    return result;
    
}

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

int create_while_jump(int source,int depth){
    int while_tabsize=sizeof(tab_while) / sizeof(tab_while[0]);
    int result=0;
    
    char *final=malloc(sizeof(char)*5);
    char *append=malloc(sizeof(char)*2);
    
    //Set the register that will receive the @ where to jump
    //as @ is unknown we put blank instead
    malloc_asmline(compteur_asm);
    malloc_asmline_op(compteur_asm);
    
    //Adding ASM Instruction
    strcpy(tab_instruct[compteur_asm].instruct,"AFC");
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
    strcpy(tab_instruct[compteur_asm].reg2,"");
    strcpy(tab_instruct[compteur_asm].reg3,"");
    
    strcpy(tab_instruct_op[compteur_asm].instruct,"0x06");
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
    strcpy(tab_instruct_op[compteur_asm].reg2,"");
    strcpy(tab_instruct_op[compteur_asm].reg3,"");
    
    //prevents from segmentation fault errors
    if(compteur_while>=while_tabsize){
        result=-1;
    }
    else{
        tab_while[compteur_while].while_save=source;
        tab_while[compteur_while].while_line=compteur_asm;
        tab_while[compteur_while].while_dest=0;
        tab_while[compteur_while].depth=depth;
        compteur_while=compteur_while+1;
        printf(BLUE "\nSaved while number %d at line %d in the asm tab\n",compteur_while,compteur_asm);
        printf(RESET);
    }
    
    print_while_array();
    
    compteur_asm=compteur_asm+1;
    
    malloc_asmline(compteur_asm);
    malloc_asmline_op(compteur_asm);
    
    
    //JMP JUMP IF RI ==0 so if boolean condition is false
    //=> so jump to the else part of the function
    
    //Adding ASM Instruction
    strcpy(tab_instruct[compteur_asm].instruct,"JMPC");
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
    strcpy(final,"R");
    sprintf(append,"%d",compteur_tmp);
    strcpy(tab_instruct[compteur_asm].reg2,strcat(final,append));
    strcpy(tab_instruct[compteur_asm].reg3,"");
    
    strcpy(tab_instruct_op[compteur_asm].instruct,"0xF");
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp+1);
    strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
    strcpy(final,"0x0");
    sprintf(append,"%d",compteur_tmp);
    strcpy(tab_instruct_op[compteur_asm].reg2,strcat(final,append));
    strcpy(tab_instruct_op[compteur_asm].reg3,"");
    compteur_asm=compteur_asm+1;
    
    free(final);
    free(append);
    
    return result;
    
}

/**********************************************************************************
 *
 * @Name : set_while_jump()
 * @Descr : set the jump for while with the informations gathered in the global variables
 * @Args :
 *      @int destination : destination for the while jump to be set
 *      @int depth : depth of the while jump to be set
 * @Return :
 *      . O if everything has been successfull
 *      . return -1 if there is no jump to set
 *      . return -2 if the jump has already been set
 *
 **********************************************************************************/

int set_while_jump(int destination, int depth){
    int result=0;
    int i;
    
    for (i=compteur_while-1;i>=0;i--){
        if(tab_while[i].while_dest==0 && tab_while[i].depth==depth){
            
            char *final=malloc(sizeof(char)*4);
            char *append=malloc(sizeof(char)*2);
            
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Ce AFC n'existe pas ?
            
            //Adding ASM Instruction of jump to begining while
            strcpy(tab_instruct[compteur_asm].instruct,"AFC");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            sprintf(append,"%d",tab_while[i].while_save);
            strcpy(tab_instruct[compteur_asm].reg2,append);
            strcpy(tab_instruct[compteur_asm].reg3,"");
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x06");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            sprintf(append,"%d",tab_while[i].while_save);
            strcpy(tab_instruct_op[compteur_asm].reg2,append);
            strcpy(tab_instruct_op[compteur_asm].reg3,"");
            
            compteur_asm=compteur_asm+1;

            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            strcpy(tab_instruct[compteur_asm].instruct,"JMP");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,"");
            strcpy(tab_instruct[compteur_asm].reg3,"");
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0xE");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp+1);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,"");
            strcpy(tab_instruct_op[compteur_asm].reg3,"");
            
            compteur_asm=compteur_asm+1;
            
            
            printf(BLUE "Tyring to set a while_jump to dest %d from line %d with source at %d\n",destination,tab_while[i].while_line, tab_while[i].while_save);
            printf(RESET);
            tab_while[i].while_dest=destination;
            sprintf(append,"%d",destination);
            strcpy(tab_instruct[tab_while[i].while_line].reg2,append);
            strcpy(tab_instruct_op[tab_while[i].while_line].reg2,append);
            
            print_while_array();
            
            compteur_while=compteur_while-1;
            //We decrement the compteur_jmp so the next jmp will overwrite
            //the one we just set
            break;
        }
        if(i==0 && tab_while[i].while_dest!=0){
            result=-2;
        }
    }
    
    return result;
    
}

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

int arithmetical_expression(int type){
    char *final=malloc(sizeof(char)*4);
    char *append=malloc(sizeof(char)*2);
    int result=0;
    switch (type) {
        case EQEQ:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"EQU");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
            
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x09");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            if(pile[tabvar[compteur+(compteur_tmp-2)].adresse]==pile[tabvar[compteur+(compteur_tmp-1)].adresse]){
                result=1;
            }
            
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            
            free(final);
            free(append);
            
            return result;
            break;
        case NEQ:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"EQU");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x09");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            
            if(pile[tabvar[compteur+(compteur_tmp-2)].adresse]!=pile[tabvar[compteur+(compteur_tmp-1)].adresse]){
                result=1;
            }
            
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            
            free(final);
            free(append);
            
            return result;
            break;
        case AND:
            break;
        case OR:
            break;
        case ADD:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"ADD");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x01");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            result=pile[tabvar[compteur+(compteur_tmp-2)].adresse]+pile[tabvar[compteur+(compteur_tmp-1)].adresse];
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp+1);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            pile[tabvar[compteur+(compteur_tmp-1)].adresse]=result;
            
            //printf("###### ADD #####\n");
            //print_symbol_table();
            
            free(final);
            free(append);
            
            return result;
            break;
        case SUB:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            
            strcpy(tab_instruct[compteur_asm].instruct,"SUB");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x03");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            result=pile[tabvar[compteur+(compteur_tmp-2)].adresse]-pile[tabvar[compteur+(compteur_tmp-1)].adresse];
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp+1);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            pile[tabvar[compteur+(compteur_tmp-1)].adresse]=result;
            
            free(final);
            free(append);
            
            return result;
            break;
        case MUL:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction

            strcpy(tab_instruct[compteur_asm].instruct,"MUL");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x02");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            result=pile[tabvar[compteur+(compteur_tmp-2)].adresse]*pile[tabvar[compteur+(compteur_tmp-1)].adresse];
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp+1);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            pile[tabvar[compteur+(compteur_tmp-1)].adresse]=result;
            
            //printf("###### MUL #####\n");
            //print_symbol_table();
            
            free(final);
            free(append);
            
            return result;
            break;
        case DIV:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            
            strcpy(tab_instruct[compteur_asm].instruct,"DIV");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0x04");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            printf("HERE4\n");
            
            result=pile[tabvar[compteur+(compteur_tmp-2)].adresse]/pile[tabvar[compteur+(compteur_tmp-1)].adresse];
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp+1);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            pile[tabvar[compteur+(compteur_tmp-1)].adresse]=result;
            
            //printf("###### DIV #####\n");
            //print_symbol_table();
            
            free(final);
            free(append);
            
            return result;
            break;
        case INF:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"INF");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0xA");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            if(pile[tabvar[compteur+(compteur_tmp-2)].adresse]<pile[tabvar[compteur+(compteur_tmp-1)].adresse]){
                result=1;
            }
            
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            
            free(final);
            free(append);
            
            return result;
            break;
        case SUP:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"SUP");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0xC");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            if(pile[tabvar[compteur+(compteur_tmp-2)].adresse]>pile[tabvar[compteur+(compteur_tmp-1)].adresse]){
                result=1;
            }
            
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            
            free(final);
            free(append);
            return result;
            break;
        case INFEQ:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"INFE");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0xB");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            if(pile[tabvar[compteur+(compteur_tmp-2)].adresse]<=pile[tabvar[compteur+(compteur_tmp-1)].adresse]){
                result=1;
            }
            
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            
            free(final);
            free(append);
            return result;
            break;
        case SUPEQ:
            malloc_asmline(compteur_asm);
            malloc_asmline_op(compteur_asm);
            
            //Adding ASM Instruction
            strcpy(tab_instruct[compteur_asm].instruct,"SUPE");
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct[compteur_asm].reg2,tab_instruct[compteur_asm].reg1);
            strcpy(final,"R");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct[compteur_asm].reg3,strcat(final,append));
                   
            strcpy(tab_instruct_op[compteur_asm].instruct,"0xD");
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-2);
            strcpy(tab_instruct_op[compteur_asm].reg1,strcat(final,append));
            strcpy(tab_instruct_op[compteur_asm].reg2,tab_instruct_op[compteur_asm].reg1);
            strcpy(final,"0x0");
            sprintf(append,"%d",compteur_tmp-1);
            strcpy(tab_instruct_op[compteur_asm].reg3,strcat(final,append));
            compteur_asm=compteur_asm+1;
            
            if(pile[tabvar[compteur+(compteur_tmp-2)].adresse]>=pile[tabvar[compteur+(compteur_tmp-1)].adresse]){
                result=1;
            }
            
            printf(YELLOW "Removing tmp variable at adress %d.\n",compteur_tmp);
            printf(RESET);
            compteur_tmp=compteur_tmp-1;
            
            free(final);
            free(append);
            return result;
            break;
        default:
            printf("Make sure you have inserted the right operation type\n");
            printf("It should be of type ==  !=  &&  ||  +  -  *  / <  >  <=  >=\n");
            return result;
            break;
    }
    return result;
}





