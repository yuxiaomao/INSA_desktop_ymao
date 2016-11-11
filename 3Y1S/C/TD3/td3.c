#include <stdio.h>

# define MAXNOTES 10

struct etudiant {
  char Nom[10];
  int Annee;
  int Nbrnotes;
  int Tabnotes[MAXNOTES];
};


void SaisirFiche(struct etudiant *s ){
  int i;
  printf("Nom:");
  scanf("%s",s->Nom);
  printf("Annee:");
  scanf("%d",&(s->Annee));
  printf("Nombre de notes(<=MAXNOTES):");
  scanf("%d",&(s->Nbrnotes));
  if ((s->Nbrnotes) > MAXNOTES)
    s->Nbrnotes=MAXNOTES;
  for(i=0;i<(s->Nbrnotes);i++){
    printf("%d eme note:",i+1);
    scanf("%d",&(s->Tabnotes[i]));
  }
}

void AfficherFiche(struct etudiant *s){
  int i;
  printf("Nom:%s\n",s->Nom);
  printf("Annee:%d\n",s->Annee);
  printf("Nombre de notes:%d\n",s->Nbrnotes);
  for(i=0;i<(s->Nbrnotes);i++){
    printf("%d eme note:%d\n",i+1,s->Tabnotes[i]);
  }
}

int Moyenne(struct etudiant *s){
  int i;
  int somme=0;
  if (s->Nbrnotes){ 
    for(i=0;i<(s->Nbrnotes);i++){
      somme=somme+(s->Tabnotes[i]);
    };
    somme=somme/(s->Nbrnotes);
  }
  else{
    printf("impossible de calculer!\n");
  };
  return somme;
}

int main(){
  struct etudiant s;
  SaisirFiche(&s);
  AfficherFiche(&s);
  printf("Moyenne=%d \n",Moyenne(&s));
  return 0;
}
  
