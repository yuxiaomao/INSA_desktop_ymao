#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>


int * px = NULL;
pthread_mutex_t mutex_px = PTHREAD_MUTEX_INITIALIZER;

/* thread pour afficher */
void * mon_thread (void * arg){
  int i;
  for (i=0;i<*(int*)arg;i++){  
    pthread_mutex_lock(&mutex_px);
    printf("Valeur px: %d\n", *px);
    pthread_mutex_unlock(&mutex_px);
    //sleep(1);
  }
  printf("Fin thread\n");
  pthread_exit(NULL);
  return NULL;
}

int main(){
  int x = 1;
  pthread_t tid;
  int max = 5;
  int i;

  px = &x;
 
  pthread_create(&tid, NULL, mon_thread, &max);

  for (i=0;i<max;i++){  
    pthread_mutex_lock(&mutex_px);
    px = NULL;
    printf("Valeur de i: %d\n", i);
    px = &x;
    pthread_mutex_unlock(&mutex_px);
  }

  pthread_join(tid, NULL) ;
  printf("Fin main\n");
  
  return 0;

}
