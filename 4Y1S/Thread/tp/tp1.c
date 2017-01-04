#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/wait.h>

void handler_fils(int sig){
  printf("fils exit!!\n");
  exit(0);
}


void handler_pere(int sig){
  printf("pere exit!!\n");
  exit(0);
}


/*@return debit en Mb/s
*/
int main(){
  /*gestion fork*/
  int pid = 0;//pid de soi
  int id_fork = 0;//pid de fils au cas pere
  /*gestion signal handler*/
  sigset_t masque; 
  struct sigaction action;
  /*gestion signal sigchld*/
  int status;
  /*gestion tube*/
  int p1[2];
  int p2[2];
  int *donnee;
  /*gestion debit*/
  struct timeval td,tf;
  //int td, tf;//temps debut fin d'envoi
  int debit;
  /*gestion boucle*/
  int i;

  /*init pipe*/
  donnee=malloc(sizeof(int));
  *donnee=1;
  printf("Donnée actuel : %d\n", *donnee);
  pipe(p1);//fils 0 read <-pere 1 write
  pipe(p2);//fils 1 write ->pere 0 read
  
  switch ( id_fork=fork() ){
  case -1: 
    printf("erreur");exit(-1);break;
  case 0: 
    pid = getpid();
    printf("[%d]fils\n",pid);
    sigfillset(&masque);
    sigdelset(&masque, SIGUSR1);
    sigprocmask(SIG_SETMASK,&masque,NULL);//application du masque
    action.sa_handler = handler_fils;
    action.sa_flags = 0;
    sigaction(SIGUSR1, &action, NULL);
    close(p1[1]);
    close(p2[0]);
    for(i=0; i<1000;i++){
      read(p1[0],donnee,sizeof(int));
      *donnee +=1;
      write(p2[1],donnee,sizeof(int));
    }
    close(p1[0]);/*fermer les pipe qu'on utilise plus*/
    close(p2[1]);
    while(1);
    break;
  default:
    pid = getpid();
    printf("[%d]pere\n",pid);
    sigfillset(&masque);
    sigdelset(&masque, SIGUSR1);
    sigdelset(&masque, SIGCHLD);
    sigprocmask(SIG_SETMASK,&masque,NULL);
    action.sa_handler = handler_pere;
    action.sa_flags = 0;
    sigaction(SIGUSR1, &action, NULL);
    close(p1[0]);
    close(p2[1]);
    //td=clock();
    gettimeofday(&td,NULL);
    for(i=0; i<1000;i++){
      write(p1[1],donnee,sizeof(int));
      *donnee +=1;
      read(p2[0],donnee,sizeof(int));
    }
    close(p1[1]);
    close(p2[0]);
    printf("Donnée actuel : %d\n", *donnee);
    //tf=clock();
    gettimeofday(&tf,NULL);
    free(donnee);
    debit=(double)(1000*2*sizeof(int)*8)
      /(double)(tf.tv_sec*1000000L+tf.tv_usec-td.tv_sec*1000000L-td.tv_usec);
    printf("Debit final: %d Mb/s\n",debit);
    kill(id_fork, SIGUSR1);
    waitpid(-1,&status,0);
    //while(1);
    break;
  }
 
  return debit;

}
