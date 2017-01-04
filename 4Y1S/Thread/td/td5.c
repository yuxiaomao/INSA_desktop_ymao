#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

/*pthread_CANCEL*/

typedef void *(*fct_ptr_t)(void *);
#define MAX 6

pthread_mutex_t mutex_1 = PTHREAD_MUTEX_INITIALIZER;


void f_thread(unsigned int * numero_affichage)
{
  int i;
  pthread_t current_thread = pthread_self();	
  
  pthread_cleanup_push(pthread_mutex_unlock,&mutex_1);
  pthread_mutex_lock(&mutex_1);
  
  for (i=0; i<MAX; i++){
    printf("*** Thread[%lu] *** Je suis thread %u.\n",
	   current_thread,
	   *numero_affichage);
    sleep(1);
  }
  pthread_cleanup_pop(1);
}


int main(int argc, char** argcv)
{
  pthread_t thread1;
  //unsigned int r1 = 1;
  int i;
  int j;
  pthread_t current_thread = pthread_self();	
  for (i=0; i<2; i++){
    pthread_create(&thread1, NULL, (fct_ptr_t)f_thread, &i);
    for (j=0; j<MAX/2; j++){
      printf("*** Thread[%lu] *** Je suis thread main.\n",
	     current_thread);
      sleep(1);
    }
    pthread_cancel(thread1);
  }

  pthread_exit(NULL);

  return EXIT_SUCCESS;
}
