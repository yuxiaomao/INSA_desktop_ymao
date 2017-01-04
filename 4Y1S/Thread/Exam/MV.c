#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <pthread.h>

#define SEMAPHORE_ID 2016
#define SHM_ID 2016
#define NOMBRE_MAX_MV 20

typedef void *(*fct_ptr_t)(void *);

static int m_sem;
static int m_shm;
struct liste_des_mv *m_list;
static int id_mv;

struct liste_des_mv{
  int nombre_mv_actuel;
  int pid_mv[NOMBRE_MAX_MV];
  int status_mv[NOMBRE_MAX_MV]; //1 si vivant
  int commande_service[NOMBRE_MAX_MV];
};


static void handler_arreter(int sig);
static void handler_service(int sig);
void thread(int *type_service);//thread(1)=service S1

int main(int argc, char** argv){
  int pid = getpid();
  if(argc != 2){
    printf("Il faut un id_mv... \n");
  }
  id_mv = atoi(argv[1]);
  printf("[%d]Lancement d'un MV , id_mv=%d... \n",pid,id_mv);

  /* Gestion du signal reçu */
  sigset_t masque; 
  struct sigaction action;
  sigfillset(&masque);
  sigdelset(&masque, SIGUSR1);//fermer mv
  sigdelset(&masque, SIGUSR2);//imposer lire un ficher ou il y a des info?
  sigprocmask(SIG_SETMASK,&masque,NULL);
  action.sa_handler = handler_arreter;
  action.sa_flags = 0;
  sigaction(SIGUSR1, &action, NULL);
  action.sa_handler = handler_service;
  sigaction(SIGUSR2, &action, NULL);

  /* Gestion du memoire partage pour recuperer les pid du MV*/
  m_sem = semget(SEMAPHORE_ID, 1, 0666);
  m_shm = shmget(SHM_ID, sizeof(struct liste_des_mv), 0666);  //Mais pourquoi il n'accepte pas struct
  m_list = shmat(m_shm, NULL, 0);
  
  /* Affectation de ses donnees dans la liste*/
  m_list->pid_mv[id_mv] = pid;
  m_list->status_mv[id_mv] = 1;
  m_list->nombre_mv_actuel += 1;
  
  /* Boucle Principal */
  while(1){
    printf("[%d]MV Exe ... \n",pid);
    sleep(3);
  }
}


static void handler_arreter(int sig){
  printf("[%d]Signal recu, exit prog... \n",getpid());
  exit(0);
}

static void handler_service(int sig){
  //pthread_t tid;
  int type_service = m_list->commande_service[id_mv];
  printf("[%d]Creation service ... \n",getpid());
  if (type_service > 0){
    //pthread_create(&tid, NULL, (fct_ptr_t)thread, &type_service);
  } else if (type_service == 0){
    //prevu pour bloquer
  }

}

void thread(int *type_service){
  pthread_t pthread_id = pthread_self();
  while(1){
    printf("[MV %d]N service %d\n",getpid(),(int)pthread_id);
    sleep(*type_service);
    }
  
}
