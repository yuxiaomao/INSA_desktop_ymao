#include "automate.h"


struct afd * initialiser_afd(int nbr_etat,
			     char*alphabet, int nbr_a,
			     int etat_init,
			     int*etat_fin, int nbr_etat_f){
  struct afd * pafd;
  struct graphe *pg_trans;
  pg_trans=creer_graphe(nbr_etat);
  pafd=malloc(sizeof(struct afd));
  pafd->g_trans=pg_trans;
  pafd->alphabet=alphabet;
  pafd->nbr_a=nbr_a;
  pafd->etat_init=etat_init;
  pafd->etat_fin=etat_fin;
  pafd->nbr_etat_f=nbr_etat_f;
  return pafd;
}


void liberer_afd(struct afd *pafd){
  liberer_graphe(pafd->g_trans);
  free(pafd->alphabet);
  free(pafd->etat_fin);
  free(pafd);
  printf("Fin liberation\n");
}


int appartenir_alphabet(char*alphabet,int nbr_a,char etiq){
  int i;
  for (i=0;i<nbr_a;i++){
    if (alphabet[i]==etiq){
      return 1;
    }
  }
  return 0;
}

void ajouter_trans_afd(struct afd *pafd,int e1,int e2,char etiq){
  if (e1<((pafd->g_trans)->nbr_sommet)){
    if (e2<((pafd->g_trans)->nbr_sommet)){
      if (appartenir_alphabet(pafd->alphabet,pafd->nbr_a,etiq)){
	if (arc_existe(pafd->g_trans,e1,e2,etiq)){
	  printf("Arc %d-%c->%d deja existe\n",e1,etiq,e2);
	    }
	  else{//Ici on puisse ajouter
	    ajouter_arc(pafd->g_trans,e1,e2,etiq);
	  }
	}
      else{
	printf("Etiq %c n'appartient pas à alphabet\n",etiq);
      }
    }
    else{
      printf("Etat depart %d not existe\n",e2);
    }
  }
  else{
    printf("Etat arrive %d not existe\n",e1);
  }
}


int appartenir_etat_f(int*etat_fin,int nbr_etat_f,int etat_actuel){
  int i;
  for (i=0;i<nbr_etat_f;i++){
    if (etat_fin[i]==etat_actuel){
      return 1;
    }
  }
  return 0;
}



int accepte(struct afd*pafd, char*mot,int long_m){
  int reconnu;
  int etat_actuel;
  int i;
  etat_actuel=pafd->etat_init;
  for (i=0;i<long_m;i++){
    etat_actuel=transiter(pafd->g_trans,etat_actuel,mot[i]);
    if (etat_actuel<0){//impossible trans
      break;
    }
  }
  if (appartenir_etat_f(pafd->etat_fin,pafd->nbr_etat_f,etat_actuel)){
    reconnu=1;
  }
  else{
    reconnu=0;
  }
 
  return reconnu;
}


int main(){
  char *alphabet;
  alphabet=malloc(2*sizeof(int));
  alphabet[0]='a';
  alphabet[1]='b';
  int *etat_fin;
  etat_fin=malloc(sizeof(int));
  etat_fin[0]=0;
  
  struct afd *pafd;
  pafd=initialiser_afd(4,alphabet,2,0,etat_fin,1);
  afficher(pafd->g_trans);
  
  ajouter_trans_afd(pafd,0,1,'a');
  printf("Existe 0-a->1?(attendu 1): %d\n",arc_existe(pafd->g_trans, 0,1,'a'));
  
  ajouter_trans_afd(pafd,0,0,'b');
  ajouter_trans_afd(pafd,0,1,'a');
  ajouter_trans_afd(pafd,1,1,'a');
  ajouter_trans_afd(pafd,1,2,'b');
  ajouter_trans_afd(pafd,2,1,'a');
  ajouter_trans_afd(pafd,2,3,'b');
  ajouter_trans_afd(pafd,3,1,'a');
  ajouter_trans_afd(pafd,3,0,'b');
  afficher(pafd->g_trans);

  printf("Accepte baabb?(attendu 1): %d\n",accepte(pafd,"baabb",5));
  printf("Accepte bababbb?(attendu 0): %d\n",accepte(pafd,"bababbb",7));

  liberer_afd(pafd);
  return 0;
}
