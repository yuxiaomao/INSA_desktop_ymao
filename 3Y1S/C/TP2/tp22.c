#include <stdio.h>
#include <stdlib.h>

#define NBRLIGNE 2
#define NBRCOLONNE 3


void Saisir2(int**tab,int ligne,int colonne){
  int i;
  int j;
  for (i=0;i<ligne;i++){
    for (j=0;j<colonne;j++){
      printf("Saisir la valeur du %d ligne et %d colonne:",i,j);
      scanf("%d",&tab[i][j]);
    }
  }
}

void Saisir2p(int**tab,int ligne,int colonne){
  int i;
  int j;
  for (i=0;i<ligne;i++){
    for (j=0;j<colonne;j++){
      printf("Saisir la valeur du %d ligne et %d colonne:",i,j);
      scanf("%d",*(tab+i)+j);
    }
  }
}

void Afficher2(int**tab,int ligne,int colonne){
  int i;
  int j;
  for (i=0;i<ligne;i++){
    for (j=0;j<colonne;j++){
      printf("%d ",tab[i][j]);
    }
    printf("\n");
  }
}

void Init(int***tab,int* pligne, int* pcolonne){
  int i;
   printf("Combien de ligne voulez vous?");
   scanf("%d",pligne);
   printf("Combien de ligne voulez vous?");
   scanf("%d",pcolonne);

  *tab=malloc((*pligne)*sizeof(int*));
  for (i=0;i<(*pligne);i++){
    (*tab)[i]=malloc((*pcolonne)*sizeof(int));
  }
}

int main(){
  int ** M;
  int l;
  int c;
  /*
  Init(&M,NBRLIGNE,NBRCOLONNE);
  Saisir2p(M,NBRLIGNE,NBRCOLONNE);
  Afficher2(M,NBRLIGNE,NBRCOLONNE);
  */ 
  Init(&M,&l,&c);
  Saisir2p(M,l,c);
  Afficher2(M,l,c);
  return 0;
}
