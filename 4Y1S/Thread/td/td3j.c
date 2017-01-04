#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>


int * px = NULL;
int * py = NULL;
pthread_mutex_t mutex_px = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_py = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond_finx = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond_finy = PTHREAD_COND_INITIALIZER;


/* thread pour afficher */
void * mon_thread1 (void * arg){
  int i;
  printf("[Thread1] Deb\n");
  for (i=0;i<*(int*)arg;i++){  
    pthread_mutex_lock(&mutex_px);
    printf("[Thread1] Valeur px: %d\n", *px);
    pthread_mutex_unlock(&mutex_px);
    usleep(100);
  }
  printf("[Thread1]Fin\n");
  pthread_exit(NULL);
  return NULL;
}

void * mon_thread2 (void * arg){
  int i;
  printf("[Thread2] Deb\n");
  for (i=0;i<*(int*)arg;i++){  
    pthread_mutex_lock(&mutex_py);
    printf("[Thread2] Valeur py: %d\n", *py);
    pthread_mutex_unlock(&mutex_py);
    usleep(100);
  }
  printf("[Thread2] Fin\n");
  pthread_exit(NULL);
  return NULL;
}


/*programme principal*/
int main(){
  int x = 1;
  int y = 2;
  pthread_t tid1,tid2;
  int max = 5;
  int i = 0;

  px = &x;
  py = &y;
 
  pthread_create(&tid1, NULL, mon_thread1, &max);
  pthread_create(&tid2, NULL, mon_thread2, &max);

  usleep(100);
  
  
  /*on a lock px et py*/
  while(i<max){  
    pthread_mutex_lock(&mutex_px);
    if (pthread_mutex_trylock(&mutex_py) != 0){
      printf("[Thread main] Lock py\n");
      px = NULL;
      py = NULL;
      printf("[Thread main] Valeur i: %d\n", i);
      px = &x;
      py = &y;
      i++;
      pthread_mutex_unlock(&mutex_py);
      printf("[Thread main] Unlock py\n");
    }
    pthread_mutex_unlock(&mutex_px);
    usleep(100);
  }
 
  pthread_exit(NULL) ;

  printf("Fin main\n");
  
  return 0;

}
