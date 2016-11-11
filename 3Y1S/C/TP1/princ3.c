#include <stdio.h>
#include "constantes.h"
#include "eleves.h"

int main()
{
  struct eleve e;
  init_eleve(&e);
  affiche_eleve(&e);
  printf("OUAIS\n");
  return 0;
}
