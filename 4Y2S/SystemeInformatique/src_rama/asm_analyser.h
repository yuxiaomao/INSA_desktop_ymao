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
#include <unistd.h>

int current_line;

//32 tab registers
int tab_reg[33];

/* Array used to simulate the stack */
int pile[20];

typedef struct {
    char *code;
    int line;
} type_tab_instruct;

type_tab_instruct tabinstruct[200];

//line 0 to 5 ASM
// line 6-7 (max 9) reg1
//line 11-12 (max 14) reg2
//line 16-17 reg3


#define CLEAR   "\033[2J"
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */

#endif /* asm_analyser_h */
