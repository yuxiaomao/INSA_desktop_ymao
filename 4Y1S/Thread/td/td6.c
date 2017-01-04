#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>

/* Calcul pi */

typedef void *(*fct_ptr_t)(void *);

void f_thread(unsigned int * nombre_fleches)
{
  int i;
  int x,y;
  int dans_cercle = 0;
  pthread_t current_thread = pthread_self();	
  printf("*** Thread[%lu] *** \n", current_thread);
  for(i=0; i<nombre_fleches; i++){
    x=rand();
    y=rand();
    if ((x*x+y*y)<=1){
      dans_cercle ++;
    }
  }
  pthread_exit(&dans_cercle);

}

/* @param nombre_thread nombre_fleches_total //nom_fichier_resu */
int main(int argc, char* argv[])
{
  /* Recuperation param */
  int nombre_thread = *((int *)argv[1]);
  int nombre_fleches_total = *((int *)argv[2]);
  int nombre_fleches;
  ////nom_fichier
  /* Gestion thread */
  pthread_t thread1;
  unsigned int r1 = 1;
  pthread_t current_thread = pthread_self();	
  int pid = getpid();
  /* Gestion time*/
  struct timeval td,tf;
  int i;
 

  printf("*** Thread[%lu] *** Main pid [%d].\n",
	 current_thread, pid);
  nombre_fleches = nombre_fleches_total/nombre_thread;
  srand(time(NULL));
  
  gettimeofday(&td,NULL);
  for(i=0;i<nombre_thread;i++){
    pthread_t threadx;
    pthread_create(&threadx, NULL, (void *)f_thread, &nombre_fleches);
  }

  }




  pthread_exit(NULL);

  return EXIT_SUCCESS;
}
