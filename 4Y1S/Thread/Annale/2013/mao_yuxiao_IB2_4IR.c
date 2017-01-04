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

#define NOMBRE_MAGICIENS 4
#define SEMAPHORE_ID 2016
#define SHM_ID 2016
#define FORCE_INIT 5
#define FORCE_PERDU 2
#define FORCE_RECOIT 1


/* Les variables local au fils */
static int mon_camp;
static int ma_force_actuel;
static int ma_sem;
static int ma_shm;
static struct champ_bataille *la_champs_bataille;
static int id_mage;

/* Les entete de fonctions utiliser dans les fils mage*/
static void creerXmagiciens(int nombre_magicien);
static void lancerdanslaguerre();

static void initialisation();
static int choisirchamps(int pid);
static void P(int sem, int numSem);
static void V(int sem, int numSem);


static void attendrealeatoirement();
static void jetersort();

static void handler_plus(int sig);
static void handler_moins(int sig);//indiquer si je suis mort



struct champ_bataille{
  int pid_magiciens[NOMBRE_MAGICIENS];
  int camp_magiciens[NOMBRE_MAGICIENS]; 
  int num;//une valeur pour synchronisation
};



int main(int argc, char** argv){

  /* God magicien Gary Poutter*/
  creerXmagiciens(NOMBRE_MAGICIENS-1);
  
  /* Un magicien normal */
  lancerdanslaguerre();

  int status;
  waitpid(-1, &status,0);
}

static void creerXmagiciens(int nombre_magicien){
  int i;
  pid_t pid;
  id_mage = 0;
  for (i=0;i<nombre_magicien;i++){
    pid = fork();
    if (pid == 0){ /* Fils */
      printf("[Gary Poutter]Creation du magicien %d\n", i);
      lancerdanslaguerre();
      exit(0);
    } else if (pid == -1){
      printf("Erreur fork.\n");
    }
    id_mage ++;
    /* else pere, continue la boucle*/
  }
}

static void lancerdanslaguerre(){
  int pid = getpid();

  printf("[%d]Process pid %d.\n",id_mage,pid);

  /* Attente x secondes que tous les magiciens soient là*/
  printf("[%d]Attends tout le monde.\n",id_mage);
  sleep(5);
  
  /* Initialisation 
   * Pour definir mon camp et initialiser ma force
   * Pour connaitre les autres mages par un memoire partage
   */
  printf("[%d]Initialisation... DEBUT\n",id_mage);
  initialisation();
  printf("[%d]Initialisation... FIN\n",id_mage);

  /* Attend que tous le monde a initialiser son champ de bataille */
  while(la_champs_bataille->num < NOMBRE_MAGICIENS){};
  printf("[%d]Le jeux commence... \n",id_mage);

  /* Initialisation valeur aleatoire */
  srand(time(NULL));
  
  while (1){
    attendrealeatoirement();
    jetersort();
  }
  
  /* Enterrement se fait à la suite de recevoir un signal */
}

static void initialisation(){
  int pid = getpid();
  
  /* Definir le champs de magicien */
  mon_camp = choisirchamps(pid);
  printf("[%d]Choisir camp... Ma pid %d, Mon camp %d\n", id_mage, pid, mon_camp);
  /* Donner force initial */
  ma_force_actuel = FORCE_INIT;
  printf("[%d]Force init %d\n", id_mage, ma_force_actuel);

  /* Memoire partage et semaphore */
  if (id_mage == 0){ /*Gary Poutter*/
    /* Creation & Initialisation des semaphores */
    ma_sem = semget(SEMAPHORE_ID, 1, 0666 | IPC_CREAT);
    semctl(ma_sem, 0, SETVAL, 1); 

    /* Creation de la shm */
    ma_shm = shmget(SHM_ID, sizeof(int), 0666 | IPC_CREAT);
    la_champs_bataille = shmat(ma_shm, NULL, 0);
  }else{
    /* Recuperation de la semaphore et memoire partage */
     ma_sem = semget(SEMAPHORE_ID, 1, 0666);
     ma_shm = shmget(SHM_ID, sizeof(int), 0666);
     la_champs_bataille = shmat(ma_shm, NULL, 0);
  }

  /* Affectation de mes donnees dans shm*/
  la_champs_bataille->pid_magiciens[id_mage] = pid;
  la_champs_bataille->camp_magiciens[id_mage] = mon_camp;
  la_champs_bataille->num += 1;
  printf("[%d]champs_bataille %d\n", id_mage, 
	 la_champs_bataille->pid_magiciens[id_mage]);
  printf("[%d]champs_bataille num %d\n", id_mage, 
	 la_champs_bataille->num);


  /* Traitement de reception signal
   * SIGUSR1 pour son propre camp
   * SIGUSR2 pour adversaire
   */
  /*gestion signal handler*/
  sigset_t masque; 
  struct sigaction action;
  sigfillset(&masque);
  sigdelset(&masque, SIGUSR1);
  sigdelset(&masque, SIGUSR2);
  sigprocmask(SIG_SETMASK,&masque,NULL);
  action.sa_handler = handler_plus;
  action.sa_flags = 0;
  sigaction(SIGUSR1, &action, NULL);
  action.sa_handler = handler_moins;
  sigaction(SIGUSR2, &action, NULL);
}


static int choisirchamps(const int pid){
  int return_value = 0;
  int pid_local = pid;
  while (pid_local > 0){
    return_value += pid_local % 10;
    pid_local = pid_local/10;
  }
  return return_value %2;
}

static void attendrealeatoirement(){
  sleep(5);
}

static void jetersort(){
  printf("[%d]Jetersort... DEBUT\n",id_mage);
  if( rand() %2 ){
    int choix_mage = rand() % NOMBRE_MAGICIENS;
    /* Si j'ai choisi un mage de champs adversaire, je re-choisi un */
    while ( la_champs_bataille->camp_magiciens[choix_mage] 
	    != mon_camp ){
      choix_mage = rand() % NOMBRE_MAGICIENS;
    }
    printf("[%d]Jetersort... plus %d\n",id_mage,choix_mage);
    kill(la_champs_bataille->pid_magiciens[choix_mage],SIGUSR1);
  }else{
    int choix_mage = rand() % NOMBRE_MAGICIENS;
    while ( la_champs_bataille->camp_magiciens[choix_mage] 
	    == mon_camp ){
      choix_mage = rand() % NOMBRE_MAGICIENS;
    }
    printf("[%d]Jetersort... moins %d\n",id_mage,choix_mage);
    kill(la_champs_bataille->pid_magiciens[choix_mage],SIGUSR2);
  }
}


static void handler_plus(int sig){
  ma_force_actuel += FORCE_RECOIT;
}

static void handler_moins(int sig){
  ma_force_actuel -= FORCE_PERDU;
  if (ma_force_actuel <= 0) {
    printf("[%d]MORT \n", getpid());
    exit(0);
  }
}





/*------------------------------------------------------*/
/* Quelques code deja existe fourni par notre prof ...*/
static void P(int sem, int numSem)
{
    struct sembuf sop;
    sop.sem_num = numSem;   /* Numéro du sémaphore cible */
    sop.sem_flg = 0;        /* Flags par défaut */
    sop.sem_op = -1;        /* Soustrait 1 à la valeur du sémaphore */

    semop(sem, &sop, 1);
}

static void V(int sem, int numSem)
{
    struct sembuf sop;
    sop.sem_num = numSem;   /* Numéro du sémaphore cible */
    sop.sem_flg = 0;        /* Flags par défaut */
    sop.sem_op = 1;         /* Ajoute 1 à la valeur du sémaphore */

    semop(sem, &sop, 1);
}
