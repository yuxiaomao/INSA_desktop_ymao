
#include <stdio.h>

#include <stdlib.h>

#include <unistd.h>

#include <pthread.h>

#define SIZE 10

pthread_key_t key; /* gestion d'une cle */

int cpt=0;

void fonction(){

int *tab;

tab= (int*)pthread_getspecific(key);

tab[0]=cpt;

cpt++;

}

void* lesthreads(){

int* tab;

tab=malloc(sizeof(int)*SIZE);

pthread_setspecific(key,(void*)tab);

fonction();

printf("%d\n",tab[0]);

pthread_exit(NULL);

return(NULL);

}

int main()

{

pthread_t thread;

pthread_key_create(&key,NULL) ;

pthread_create( & thread, NULL,lesthreads ,NULL);

pthread_create( & thread, NULL,lesthreads ,NULL);

sleep(5);

return(0);

}
