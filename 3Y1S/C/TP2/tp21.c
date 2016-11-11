#include <stdio.h>

#define NBRCOLONNE 3

void Saisir(int tab[][NBRCOLONNE],int ligne){
  int i;
  int j;
  for (i=0;i<ligne;i++){
    for (j=0;j<NBRCOLONNE;j++){
      printf("Saisir la valeur du %d ligne et %d colonne:",i,j);
      scanf("%d",&tab[i][j]);
    }
  }
}

void Afficher(int tab[][NBRCOLONNE],int ligne){
  int i;
  int j;
  for (i=0;i<ligne;i++){
    for (j=0;j<NBRCOLONNE;j++){
      printf("%d ",tab[i][j]);
    }
    printf("\n");
  }
}

void Saisirp(int* ptab,int ligne,int colonne){
  int i;
  int j;
  for (i=0;i<ligne;i++){
    for (j=0;j<colonne;j++){
      printf("Saisir la valeur du %d ligne et %d colonne:",i,j);
      scanf("%d",ptab+i*NBRCOLONNE+j);
    }
  }

}


int main(){
  int nbrligne=2;
  int tab[nbrligne][NBRCOLONNE];
  Saisirp((int*)tab,nbrligne,NBRCOLONNE);
  Afficher(tab,nbrligne);
  return 0;
}
