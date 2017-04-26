//
//  parser.c
//  
//
//  Created by Rama Desplats on 06/03/17.
//
//

#define CLEAR   "\033[2J"           /* Clear Terminal */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define RESET   "\033[0m"


#include "asm_analyser.h"



void print_reg(){
    int i;
    for(i=0;i<10;i++){
        printf(BOLDBLACK "R%d",i);
        printf(RESET);
        printf(" - ");
        printf("%d\n",tab_reg[i]);
    }
}

void print_memory(){
    int i;
    for(i=0;i<20;i++){
        printf(BOLDBLACK "@%d",i);
        printf(RESET);
        printf(" - ");
        printf("%d\n",pile[i]);
    }
}

void start(){
    printf("Please expand terminal frame until you can see all of this.\n");
    print_reg();
    printf("\n");
    print_memory();
    printf("\n\n");
    puts("Appuyez sur ENTREE pour continuer...");
    getchar();
    printf(CLEAR);
}

void execute(int nbline){
    char *_asm=malloc(sizeof(char)*5);
    char *reg1=malloc(sizeof(char)*4);
    char *reg2=malloc(sizeof(char)*4);
    char *reg3=malloc(sizeof(char)*4);
    
    printf(CLEAR);
    
    printf("Executing ASM: ");
    printf(BOLDBLACK);
    printf("%s",tabinstruct[nbline].code);
    printf(RESET);
    printf("\n");
    
    _asm[0]=tabinstruct[nbline].code[0];
    _asm[1]=tabinstruct[nbline].code[1];
    _asm[2]=tabinstruct[nbline].code[2];
    if(tabinstruct[nbline].code[3]!=' '){
        _asm[3]=tabinstruct[nbline].code[3];
    }
    if(tabinstruct[nbline].code[4]!=' '){
        _asm[4]=tabinstruct[nbline].code[4];
    }
    
    printf("%s",_asm);
    printf("#\n");
    
    if (strcmp(_asm,"ADD")==0){
        tab_reg[tabinstruct[nbline].code[7]-'0']=tab_reg[tabinstruct[nbline].code[12]-'0']+tab_reg[tabinstruct[nbline].code[17]-'0'];
        current_line++;
    }
    else if (strcmp(_asm,"MUL")==0){
        tab_reg[tabinstruct[nbline].code[7]-'0']=tab_reg[tabinstruct[nbline].code[12]-'0']*tab_reg[tabinstruct[nbline].code[17]-'0'];
        current_line++;
    }
    else if (strcmp(_asm,"SOU")==0){
        tab_reg[tabinstruct[nbline].code[7]-'0']=tab_reg[tabinstruct[nbline].code[12]-'0']-tab_reg[tabinstruct[nbline].code[17]-'0'];
        current_line++;
    }
    else if (strcmp(_asm,"DIV")==0){
        tab_reg[tabinstruct[nbline].code[7]-'0']=tab_reg[tabinstruct[nbline].code[12]-'0']/tab_reg[tabinstruct[nbline].code[17]-'0'];

        current_line++;
    }
    else if (strcmp(_asm,"COP")==0){
        tab_reg[tabinstruct[nbline].code[7]-'0']=tab_reg[tabinstruct[nbline].code[12]-'0'];
        current_line++;
    }
    else if (strcmp(_asm,"AFC")==0){
        int res;
        reg2[0]=tabinstruct[nbline].code[11];
        reg2[1]=tabinstruct[nbline].code[12];
        reg2[2]=tabinstruct[nbline].code[13];
        reg2[3]=tabinstruct[nbline].code[14];
        
        if(tabinstruct[nbline].code[11]!='R'){
            res=atoi(reg2);
        }
        else{
            printf("Error AFC is [RI] <- j\n");
        }
        tab_reg[tabinstruct[nbline].code[7]-'0']=res;
        current_line++;
    }
    else if (strcmp(_asm,"LOAD")==0){
        tab_reg[tabinstruct[nbline].code[7]-'0']=pile[tab_reg[tabinstruct[nbline].code[12]-'0']];
        current_line++;
    }
    else if (strcmp(_asm,"STORE")==0){
        //printf("%d - %d \n",tab_reg[tabinstruct[nbline].code[7]-'0'],tab_reg[tabinstruct[nbline].code[12]-'0']);
        pile[tab_reg[tabinstruct[nbline].code[7]-'0']]=tab_reg[tabinstruct[nbline].code[12]-'0'];
        current_line++;
    }
    else if (strcmp(_asm,"EQU")==0){
        if(tab_reg[tabinstruct[nbline].code[12]-'0']==tab_reg[tabinstruct[nbline].code[17]-'0']){
            tab_reg[tabinstruct[nbline].code[7]-'0']=1;
        }
        else{
            tab_reg[tabinstruct[nbline].code[7]-'0']=0;
        }
        current_line++;
    }
    else if (strcmp(_asm,"INF")==0){
        if(tab_reg[tabinstruct[nbline].code[12]-'0']<tab_reg[tabinstruct[nbline].code[17]-'0']){
            tab_reg[tabinstruct[nbline].code[7]-'0']=1;
        }
        else{
            tab_reg[tabinstruct[nbline].code[7]-'0']=0;
        }
        current_line++;
    }
    else if (strcmp(_asm,"INFE")==0){
        if(tab_reg[tabinstruct[nbline].code[12]-'0']<=tab_reg[tabinstruct[nbline].code[17]-'0']){
            tab_reg[tabinstruct[nbline].code[7]-'0']=1;
        }
        else{
            tab_reg[tabinstruct[nbline].code[7]-'0']=0;
        }
        current_line++;
    }
    else if (strcmp(_asm,"SUP")==0){
        if(tab_reg[tabinstruct[nbline].code[12]-'0']>tab_reg[tabinstruct[nbline].code[17]-'0']){
            tab_reg[tabinstruct[nbline].code[7]-'0']=1;
        }
        else{
            tab_reg[tabinstruct[nbline].code[7]-'0']=0;
        }
        current_line++;
    }
    else if (strcmp(_asm,"SUPE")==0){
        if(tab_reg[tabinstruct[nbline].code[12]-'0']>=tab_reg[tabinstruct[nbline].code[17]-'0']){
            tab_reg[tabinstruct[nbline].code[7]-'0']=1;
        }
        else{
            tab_reg[tabinstruct[nbline].code[7]-'0']=0;
        }
        current_line++;
    }
    else if (strcmp(_asm,"JMP")==0){
        current_line=tab_reg[tabinstruct[nbline].code[7]-'0']-1;
        current_line++;
    }
    else if (strcmp(_asm,"JMPC")==0){
        if(tab_reg[tabinstruct[nbline].code[12]-'0']==0){
            current_line=tab_reg[tabinstruct[nbline].code[7]-'0'];
        }
        else{
            current_line++;
        }
    }
    else{
        printf("Instruction not recognized.\n");
    }
    
    print_reg();
    printf("\n");
    print_memory();
    printf("\n");
    
    puts("Appuyez sur ENTREE pour continuer...");
    getchar();
    
    free(_asm);
    free(reg1);
    free(reg2);
    free(reg3);
    
}


int main (int argc, char **argv)
{
    
    int compteur=0;//compteur in tabinstruct
    
    char *input = argv[1];
    FILE *file;
    
    int iterator;
    
    char *line=malloc(sizeof(char)*20);
    
    file = fopen(input, "r");
    
    if (file == 0){
        //fopen returns 0, the NULL pointer, on failure
        perror("Canot open input file\n");
        exit(-1);
    }
    else{
        while (fgets(line,20, file)){
            if(line[0]!=' '){
                tabinstruct[compteur].code=malloc(sizeof(char)*20);
                tabinstruct[compteur].line=compteur;
                strcpy(tabinstruct[compteur].code,line);
                compteur++;
            }
        }
    }//end of reading file
    
    start();
    while(current_line<compteur){
        execute(current_line);
    }
    
    printf(BOLDBLACK "End of execution\n" RESET);
    
    fclose(file);
    
    printf("\n");
    
    return 0;
}

