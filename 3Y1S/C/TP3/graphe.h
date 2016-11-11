#ifndef _GRAPHE_H
#define _GRAPHE_H

#include <stdio.h>
#include <stdlib.h>

struct liste_arc{
  char etiq;
  int etat;
  //commence de 0
  struct liste_arc* suiv;
};

struct graphe {
  struct liste_arc **tabetat;
  int nbr_sommet;//numero 0 à nbr-1
};

struct graphe * creer_graphe(int nbr_s);
//malloc

void ajouter_arc(struct graphe * pg, int s_prec, int s_suc, char etiq);
//ajout sans verif existe

int arc_existe(struct graphe*pg,int s_prec,int s_suc,char etiq);
//1 si existe, 0 sinon

void retirer_arc(struct graphe*pg,int s_prec,int s_suc,char etiq);
//ne retire pas duplication

int transiter(struct graphe *pg, int s_init, int etiq);
//renvoi etat arrive, -1 si impossible

void afficher(struct graphe*pg);

void liberer_graphe(struct graphe *pg);

#endif
