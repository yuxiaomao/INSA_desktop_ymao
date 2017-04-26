//
//  asm_analyser.h
//  
//
//  Created by Rama Desplats on 06/03/17.
//
//

#ifndef asm_analyser_h
#define asm_analyser_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

//32 tab registers
int tab_reg[33];

/* Array used to simulate the stack */
int pile[20];

typedef struct {
    char *code;
    int line;
} type_tab_instruct;

type_tab_instruct tabinstruct[200];

//iterator 0= de la crotte

//iterator 1 à 5 = ASM instruction
//iterator 7 à 8 = reg1
//iterator 12 à 13 = reg2
//iterator 17 à 18 = reg3

//iterator 21=\n


#define CLEAR   "\033[2J"
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */

#endif /* asm_analyser_h */

/*iterator++;

//printf("Reading char : %c\n",c);
//printf("compteur : %d - iterator : %d\n", compteur, iterator);
if(iterator==0){
    
}
//Asm command
else if(iterator>=1 && iterator<=5){
    if(isspace(c) || c=='\0'){
        
    }
    else{
        strcpy(tabinstruct[compteur].code,c);
        //printf("Reading char : %c\n",c); OK
    }
}
//always a register
else if(iterator>=7 && iterator<=8){
    tabinstruct[compteur].code[iterator]=c;
    //printf("Reading char : %c\n",c); OK
}

//can be variable
else if(iterator>=12 && iterator<=13){
    if(iterator==12 && c!='R'){
        variable=1;
    }
    tabinstruct[compteur].code[iterator]=c;
}
else if(iterator>=14 && variable==1 && endvariable==0){
    //if variable but not already entire read
    if(isspace(c) || c=='\0'){
        endvariable=1;
    }
    tabinstruct[compteur].code[iterator]=c;
}
//always a register located at +4 after end of variable
else if(iterator>=17 && iterator<=18 && variable==0){
    tabinstruct[compteur].code[iterator]=c;
}
if(c=='\n'){
    //execute(tabinstruct[compteur].code);
    print_line_read(compteur);
    iterator=0;
    compteur++;
}

free(append);*/