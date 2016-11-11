#include <string.h>
#include "eleves.h"
void init_eleve(struct eleve* pe)
{
  strcpy(pe->nom,"NA");
  pe->promo=0;
}

void affiche_eleve(struct eleve* pe)
{
  printf("Nom:%s\n",pe->nom);
  printf("Promo:%d\n",pe->promo);
}
