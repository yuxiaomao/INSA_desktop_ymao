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


void print_line_read(int nb){
    int i;
    printf("Reading line %d : ",nb);
    for(i=0;i<22;i++){
         printf("%s",tabinstruct[nb].code);
    }
    printf("\n");
}

int main (int argc, char **argv)
{
    int c;
    
    int compteur=0;//compteur in tabinstruct
    
    char *input = argv[1];
    FILE *file;
    
    int iterator;
    
    file = fopen(input, "r+");
    
    if (file == 0){
        //fopen returns 0, the NULL pointer, on failure
        perror("Canot open input file\n");
        exit(-1);
    }
    else{

        while ((c = fgetc(file)) != EOF ){
            if(c=='\0'){
            printf("0 cleaned\n");
                fseek(file, ftell(file) - 1, SEEK_SET); /* set the position of the stream
                                                             one character back, this is done by
                                                             getting the current position using
                                                             ftell, subtracting one from it and
                                                             using fseek to set a new position */
                
                fprintf(file, "%c", ' ');
            }
            compteur++;
        }
    }
    printf("File %s cleaned.\n",argv[1]);
    fclose(file);
    
    return 0;
}

