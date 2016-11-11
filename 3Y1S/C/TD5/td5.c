#include <stdio.h>

#define MAX 256

int EcritFichier(FILE *fich_lect, char *nom_fiche_ecrit, int nb_lines)
{
  char Ligne[MAX];
  int res=0;
  FILE *fe;
  if (nb_lines){
    fe=fopen(nom_fiche_ecrit,"a");
    fgets(Ligne, MAX, fich_lect);
    fputs(Ligne, fe);
    fclose(fe);
    EcritFichier(fich_lect, nom_fiche_ecrit, nb_lines-1);
    //comment gérer les erreurs?
  }
  return res ;
}

/*
int main(){
  FILE *f;
  char nom_fich_lect[MAX];
  char nom_fich_ecrit[MAX];
  int res;
  printf("Veuillez taper nom de ficher à lire:");
  scanf("%s",nom_fich_lect);
  printf("Veuillez taper nom de ficher à créer:");
  scanf("%s",nom_fich_ecrit);
  f=fopen(nom_fich_lect,"r");
  res = EcritFichier(f,nom_fich_ecrit,10);
  printf("%d\n",res);

  return 0;
}

*/

int main(int argc, char *argv[]){
  FILE *f;
  int res;
  f=fopen(argv[1],"r");
  res = EcritFichier(f,argv[2],5);
  printf("%d\n",res);

  return 0;
}
