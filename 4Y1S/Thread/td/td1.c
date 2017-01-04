#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

/* thread pour afficher */
void * mon_thread (void * arg){
  int i;
  for (i=0;i<*(int*)arg;i++){  
    printf(" et mon courroux\n");
    sleep(1);
  }
  *(int*)arg=123;
  pthread_exit(arg);
  return NULL;
}

int main(){
  pthread_t tid;
  int m=0;
  int n=0;
  int i=0;
  int * presult;
  printf("Donnez la valeur de M: ");
  scanf("%d",&m);
  printf("Donnez la valeur de N: ");
  scanf("%d",&n);

  pthread_create(&tid, NULL, mon_thread, &n);

  for (i=0;i<m;i++){  
    printf("coucou\n");
    sleep(1);
  }

  pthread_join(tid, (void **)&presult) ;
  printf("La valeur de statut fourni par thread: %d\n", *presult);
  
  return 0;

}
