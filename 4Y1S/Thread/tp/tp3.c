#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>

#define DIM 100
#define MIN(a,b) (a<=b?a:b)

/*lancer d'abord 4 pour 4 lignes*/
/*
struct param_Calcul{
  int methode;
  unsigned int *Vn;
  unsigned int (*pA)[DIM];//attention ne pas changer valeurs
  int num_l;//numero ligne/colone
};
*/

struct param_Calcul{
  int methode;
  unsigned int *Vn;
  unsigned int **pA;//attention ne pas changer valeurs
  int num_l;//numero ligne/colone
};

void * thread_calcul(struct param_Calcul *arg){
  int i;
  unsigned int *res = malloc(sizeof(unsigned int));
  *res = 0;
  printf("[Thread]Ligne/colone %d\n",arg->num_l);
  /*calcul*/
  if (arg->methode==1){
    for(i=0;i<DIM;i++){
      *res += (arg->Vn[i]) * (arg->pA[i][arg->num_l]);
    }
  }else{
    for(i=0;i<DIM;i++){
      *res += (arg->Vn[i]) * (arg->pA[i][arg->num_l]);
    }
  }
  pthread_exit((void *)res);
}

int main(int argc, char*argv[]){
  /*recuperation parametre*/
  int methode;
  int nbr_thread;
  int nbr_iter;
  /*initialisation matrice*/
  unsigned int **tab_A;
  unsigned int *vec_V;
  unsigned int *vec_V1; //stocker iter suivant
  /*variable thread*/
  pthread_t tid[4];
  struct param_Calcul param_c[4];
  unsigned int *return_value;
  /*variable de la boucle*/
  int i;
  int j;//ligne/colonne courant
  int t;//1-4
  int nbr_ligne_a_calculer;

  /*exit quand il n'y a pas assez param*/
  if (argc<3) {
    printf("3 argument obligatoire, methode, nbr_thread,nbr_iter\n");
    exit(1);
  }

  /*recuperation + affichage parametre*/
  methode = atoi(argv[1]);
  nbr_thread = atoi(argv[2]);
  nbr_iter = atoi(argv[3]);
  printf("[MAIN]Methode %d, Nbr_thread %d, Nbr_iter %d.\n",
	 methode,nbr_thread,nbr_iter);
  /*initialisation de vecteur V et matrice A*/
  printf("[MAIN]Init vec_V tab_A....\n");
  tab_A = (unsigned int**)malloc(DIM*sizeof(unsigned int*));
  for(i=0;i<DIM;i++){
    tab_A[i] = (unsigned int*)malloc(DIM*sizeof(unsigned int));
  }
  vec_V = malloc(DIM*sizeof(unsigned int));
  vec_V1 = malloc(DIM*sizeof(unsigned int));
  srand(time(NULL));
  for(i=0;i<DIM;i++){
    vec_V[i]=(unsigned int)rand();
    vec_V1[i]=0;
    for(j=0;j<DIM;j++){
      tab_A[i][j]=(unsigned int)rand();
      //tab_A[i][j]=1;
    }
  }
  printf("[Main]Fin init vecV tabA, dimension %d\n",DIM);

  /*creation struct param*/
  for(i=0;i<4;i++){
    param_c[i].methode = methode;
    param_c[i].pA=tab_A;
  }
  /*iteration*/
  for(i=0;i<nbr_iter;i++){
    /*init struct*/
     for(t=0;t<4;t++){
       param_c[t].Vn = vec_V;
       param_c[t].num_l = t;
     }
    printf("[MAIN]num iter=%d ....\n",i);
    /*creation thread*/
    for(j=0;j<DIM;){
      //j s'inctremante dans join, prochain ligne a calculer
      nbr_ligne_a_calculer=MIN(DIM-j,nbr_thread);
      	for(t=0;t<nbr_ligne_a_calculer;t++){
	  pthread_create(&tid[t], NULL, (void*)thread_calcul, &param_c[t]);
	}
	/*join thread*/
	for(t=0;t<nbr_ligne_a_calculer;t++){
	  pthread_join(tid[t], (void**)&return_value) ;
	  vec_V1[j]=*return_value;
	  free(return_value);
	  j++;//incrementation de j
	}
	printf("[MAIN]Valeur j %d\n",j);
	for(t=0;t<4;t++){
	  param_c[t].num_l += nbr_thread;
	}
    }
    printf("[MAIN]Valeur param_c.num_l %d\n",param_c[0].num_l);
    /*passage a iter suivant*/
    memcpy(vec_V,vec_V1,DIM*sizeof(unsigned int));
  }
  /*Fin programme, affichage vec_V*/
  printf("[MAIN]Fin iter.\n");
  printf("[MAIN]Resu V:\n");
  for (i=0;i<DIM;i++){
    printf("%d ",vec_V[i]);
  }
  printf("\n");
  for(i=0;i<DIM;i++){
    free(tab_A[i]);
  }
  free(tab_A);
  free(vec_V);
  free(vec_V1);
  printf("[MAIN]Fin prog.\n");
  return 0;
}
