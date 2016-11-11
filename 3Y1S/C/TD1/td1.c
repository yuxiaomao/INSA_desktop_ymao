#include <stdio.h>

//Tri des éléments d'un tableau
void afficher (int tab[],int taille){
  int i;
  for(i=0; i<taille; i++){
    printf("%d ", tab[i]);
  }
  printf("\n");
}

// un tri recursif bull....
void tri_bull1 (int tab[],int taille){
  int i;
  int aux;
  if (taille>1){
    for(i=0;i<taille-1;i++){
      if(tab[i]>tab[i+1]){
	aux=tab[i+1];
	tab[i+1]=tab[i];
	tab[i]=aux;
      }
    }
    tri_bull1(tab,taille-1);
  }
}


//Opération bit à bit
int multip2(int x){
  return x << 1;
}

int creer_c(int a, int b){
  int c;
  c=(a>>16)+(0x0000FFFF & (~b));
  printf("%x %x %x \n",a>>16,~b, (0x0000FFFF & (~b)));
  return c;

}




int main(){
  
  //--------partie 1---------
  int Tab[10]={7,5,9,6,3,1,8,10,4,2};
  printf("Tableau avant tri bull: ");
  afficher(Tab,10);
  tri_bull1(Tab,10);
  printf("Tableau apres tri bull: ");
  afficher(Tab,10);

  //-------partie 2---------
  printf("2 multipli 2 = %d \n",multip2(2));
  //printf("%d", 2<<2);
  //printf("%d", 2>>2);

  printf(" = %x \n",creer_c(0x12345678,0xCCCCEEEE));
  


  return 0;
}
