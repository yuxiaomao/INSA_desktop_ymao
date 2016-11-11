#include "graphe.h"


struct graphe * creer_graphe(int nbr_s){
  struct graphe *g;
  int i;
  g=malloc(sizeof(struct liste_arc **)+sizeof(int));
  g->tabetat=malloc(nbr_s*sizeof(struct liste_arc *));
  g->nbr_sommet=nbr_s;
  for(i=0;i<nbr_s;i++){
    g->tabetat[i]=NULL;
  }
  return g;
}


void ajouter_arc(struct graphe * pg, int s_prec, int s_suc, char etiq){
  //création du nouveau struct liste
  struct liste_arc * pl;
  struct liste_arc * aux;
  pl=malloc(sizeof(struct liste_arc));
  pl->etiq=etiq;
  pl->etat=s_suc;
  pl->suiv=NULL;
  //ajout dans graphe
  //ajout un exception?  s_prec ou s_suc >= nbr sommet
  aux=pg->tabetat[s_prec];
  if (aux){
    while (aux->suiv){
      aux=aux->suiv;
    }//ici aux->suiv =NULL,aux represent la fin du liste
    aux->suiv=pl;
  }
  else{//qd aucun succ pour ce s_prec
    pg->tabetat[s_prec]=pl;
  }
}


int arc_existe(struct graphe*pg,int s_prec,int s_suc,char etiq){
  int exist=0;
  struct liste_arc *aux;
  if (pg->tabetat[s_prec]){
    aux=pg->tabetat[s_prec];
    while ((aux)&&(!exist)){
      if ((aux->etat==s_suc)&&(aux->etiq==etiq)) {
	exist=1;
      }
      aux=aux->suiv;
    }
  } //else, =NULL, qu'il n'a pas suc, donc not existe
  return exist;
}


void retirer_arc(struct graphe*pg,int s_prec,int s_suc,char etiq){
  int retire=0;
  struct liste_arc *aux;
  struct liste_arc *pf;
  if (arc_existe(pg,s_prec,s_suc,etiq)){
    aux=pg->tabetat[s_prec];
    if ((aux->etat==s_suc)&&(aux->etiq==etiq)) {
      pf=aux;
      pg->tabetat[s_prec]=aux->suiv;
      free(pf);
      retire=1;
    }
    else{
      while ((aux->suiv)&&(!retire)){
	if ((aux->suiv->etat==s_suc)&&(aux->suiv->etiq==etiq)) {
	  pf=aux->suiv;
	  aux->suiv=aux->suiv->suiv;
	  free(pf);
	}
	aux=aux->suiv;
      }
    }//retire=1 si on a retire
  }
}


int transiter(struct graphe *pg, int s_init, int etiq){
  int res=-1;
  struct liste_arc *aux;
  if (pg->tabetat[s_init]){
    aux=pg->tabetat[s_init];
    while ((res==-1)&&(aux)){
      if (aux->etiq==etiq){
	res=aux->etat;
      }
      aux=aux->suiv;
    }
  }
  return res;
}

void afficher(struct graphe*pg){
  int i;
  struct liste_arc *aux;
  for(i=0;i<pg->nbr_sommet;i++){
    printf("%d :",i);
    aux=pg->tabetat[i];
    while (aux){
      printf("-%c->%d, ",aux->etiq,aux->etat);
      aux=aux->suiv;
    }
    printf("\n");
  }
}

void liberer_graphe(struct graphe *pg){
  int i;
  struct liste_arc *pf;
  for(i=0;i<pg->nbr_sommet;i++){
    while (pg->tabetat[i]){
      pf=pg->tabetat[i];
      pg->tabetat[i]=pf->suiv;
      free(pf);
    }
  }
  free(pg->tabetat);
  free(pg);
}


/* 
int main(){
  struct graphe *pg;
  pg=creer_graphe(4);
  
  //tester - ajouter,exister, retirer,transister -
  printf("nbr_sommet:%d \n",pg->nbr_sommet);
  printf("adress liste de etat 0:%p \n",pg->tabetat[0]);
  ajouter_arc(pg,0,1,'a');
  printf("apres ajout adres liste de 0:%p \n",pg->tabetat[0]);
  printf("apres ajout etat suc de 0:%d \n",pg->tabetat[0]->etat);
  ajouter_arc(pg,0,2,'b');
  printf("apres ajout adres liste de 0:%p \n",pg->tabetat[0]->suiv);
  printf("apres ajout etat suc de 0:%d \n",pg->tabetat[0]->suiv->etat);
  printf("existe 0,1,a?: %d (attendu 1)\n",arc_existe(pg,0,1,'a'));
  printf("existe 0,1,b?: %d (attendu 0)\n",arc_existe(pg,0,1,'b'));
  ajouter_arc(pg,0,2,'a');
  ajouter_arc(pg,0,2,'c');
  retirer_arc(pg,0,1,'b');//enleve not existe
  printf("existe 0,2,a avant?: %d (attendu 1)\n",arc_existe(pg,0,2,'a'));
  retirer_arc(pg,0,2,'a');//enleve au milieu
  printf("existe 0,2,a,apres?: %d (attendu 0)\n",arc_existe(pg,0,2,'a'));
  printf("existe 0,1,a avant?: %d (attendu 1)\n",arc_existe(pg,0,1,'a'));
  retirer_arc(pg,0,1,'a');//enleve premier element
  printf("existe 0,1,a apres?: %d (attendu 0)\n",arc_existe(pg,0,1,'a'));
  ajouter_arc(pg,1,0,'a');
  ajouter_arc(pg,0,2,'b');
  printf("transiter 0 -b> 2?:%d \n",transiter(pg,0,'b'));
  printf("transiter 0 -a> -1?:%d \n",transiter(pg,0,'a'));
  
  //tester -afficher,liberer
  ajouter_arc(pg,0,0,'b');
  ajouter_arc(pg,0,1,'a');
  ajouter_arc(pg,1,1,'a');
  ajouter_arc(pg,1,2,'b');
  ajouter_arc(pg,2,1,'a');
  ajouter_arc(pg,2,3,'b');
  ajouter_arc(pg,3,1,'a');
  ajouter_arc(pg,3,0,'b');
  afficher(pg);
  
  liberer_graphe(pg);
  return 0;
}

*/
