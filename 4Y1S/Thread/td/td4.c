#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

typedef void *(*fct_ptr_t)(void *);
#define MAX 3

static pthread_once_t once1 = PTHREAD_ONCE_INIT;
static pthread_key_t key;

void fonction_init(){
  printf("*** INIT ***\n");
  pthread_key_create(&key, free);
}

long int incrementation(){
  long int* occu;
  occu = pthread_getspecific(key);
  /*  printf("*** Incrementation *** Je lu la valeur %lu.\n",
   *occu);*/
  (*occu)++;
  return *occu;
}

void f_thread(unsigned int * numero_affichage)
{
  int i;
  long int* zone_memoire;
  zone_memoire = malloc(sizeof(long int));	
  pthread_t current_thread = pthread_self();
    
  pthread_once(&once1,fonction_init);
  pthread_setspecific(key, zone_memoire);	

  *zone_memoire = current_thread;
	
  for (i=0; i<MAX; i++){
    printf("*** Thread[%lu] *** Je suis thread %u.\n",
	   current_thread,
	   *numero_affichage);
    printf("*** Thread[%lu] *** J'incremente %ld.\n",
	   current_thread,
	   incrementation());
    sleep(1);
  }
}

int main(int argc, char** argcv)
{
  pthread_t thread1, thread2, thread3;
  unsigned int r1 = 3, r2 = 2, r3 = 1;
  pthread_create(&thread1, NULL, (fct_ptr_t)f_thread, &r1);
  pthread_create(&thread2, NULL, (fct_ptr_t)f_thread, &r2);
  pthread_create(&thread3, NULL, (fct_ptr_t)f_thread, &r3);

  pthread_exit(NULL);

  return EXIT_SUCCESS;
}
