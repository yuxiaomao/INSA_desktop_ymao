#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>

/* Signal dans le thread */

typedef void *(*fct_ptr_t)(void *);

void handler_1 (int sig){
  printf("handler_1 appele.\n");
}

void handler_2 (int sig){
  printf("handler_2 appele, main exit.\n");
  exit(1);
}


void f_thread(unsigned int * numero_affichage)
{
  pthread_t current_thread = pthread_self();	
  sigset_t masque;
  struct sigaction action;
  sigfillset(&masque);
  sigdelset(&masque,SIGUSR1);
  action.sa_handler = handler_1;
  action.sa_flags = 0;
  sigaction(SIGUSR1, &action, NULL);
  printf("*** Thread[%lu] *** Je suis thread %u. Masque ok.\n",
	   current_thread,
	   *numero_affichage);
  while(1){}

}


int main(int argc, char** argcv)
{
  pthread_t thread1;
  unsigned int r1 = 1;
  pthread_t current_thread = pthread_self();	
  int pid = getpid();
  sigset_t masque;
  struct sigaction action;
  sigfillset(&masque);
  sigdelset(&masque,SIGUSR1);
  action.sa_handler = handler_2;
  action.sa_flags = 0;
  sigaction(SIGUSR2, &action, NULL);
  printf("*** Thread[%lu] *** Main pid [%d]. Masque ok.\n",
	 current_thread, pid);
  
  pthread_create(&thread1, NULL, (fct_ptr_t)f_thread, &r1);

  while(1){}

  pthread_exit(NULL);

  return EXIT_SUCCESS;
}
