#include <stdio.h>
#include <stdlib.h>

#define TAILLE 10

int main(){
  char*chaine;
  int*tab;
  int i;
  chaine=(char*)malloc(TAILLE*sizeof(char));
  tab=(int*)malloc(TAILLE*sizeof(int));
  for (i=0;i<TAILLE-1;i++){
    tab[i]=i+1;
    chaine[i]=(char)(i+65);
    printf("i=%d tab=%d chaine=%c \n",i,tab[i], chaine[i]);
  }
  chaine[TAILLE-1]=0;
  return 0;
}
