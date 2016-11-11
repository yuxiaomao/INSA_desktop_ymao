#ifndef _AUTOMATE_H
#define _AUTOMATE_H

#include <stdio.h>
#include <stdlib.h>
#include "graphe.h"

struct afd{
  struct graphe* g_trans;
  char* alphabet; //tous les alphabet possible
  int nbr_a;
  int etat_init;
  int* etat_fin;
  int nbr_etat_f;
};

struct afd * initialiser_afd(int nbr_etat,
			     char*alphabet, int nbr_a,
			     int etat_init,
			     int*etat_fin, int nbr_etat_f);
//ne contient aucun transition au départ

void liberer_afd(struct afd *pafd);

int appartenir_alphabet(char*alphabet,int nbr_a,char etiq);
//si un etiq appartient à l'alphabet

void ajouter_trans_afd(struct afd *pafd,int e1,int e2,char etiq);
//ssi possible et existe

int appartenir_etat_f(int*etat_fin,int nbr_etat_f,int etat_actuel);
int accepte(struct afd*pafd, char*mot,int long_m);

#endif
