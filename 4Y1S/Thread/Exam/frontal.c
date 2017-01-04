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

/* Bug: 
 * 1. problème 	execl("./MV",&prochain_mv_id,"/",NULL);
 *à chaque lance d'un MV, j'ai envoyé un id_mv, 
 mais pour mv reçu, il me sembre que les deux pid se cache derriere la MV 0
 *kill_all_mv entraine kill tous..
 mais arret une machine virtuel ne peut arret le dernier mis...

 * 2.fichier de configuration
 FILE*fopen, FILE*fread
 
 * 3. Je n'ai pas encore ecris de quoi sur synchronisation thread...
 frontal -> SIGUSR2 entraine MV consulte un tableau de shm 
 (deux case spécifique à lui , lancer/arreter
 en fonction du quelle il va creer ou cancel les services)

 * 4. Q3 : cela peut faire dans SIGUSR2 aussi
 il se met dans un mutex_lock & mutex_cond_wait?
 
*/


#define TAILLE_MAX_LU 10
#define SEMAPHORE_ID 2016
#define SHM_ID 2016
#define NOMBRE_MAX_MV 20

static int m_sem;
static int m_shm;
struct liste_des_mv *m_list;

struct liste_des_mv{
  int nombre_mv_actuel;
  int pid_mv[NOMBRE_MAX_MV];
  int status_mv[NOMBRE_MAX_MV]; //1 si vivant
  int commande_service[NOMBRE_MAX_MV];
};

static void afficher_liste_mv();
static void kill_all_mv();


int main(int argc, char** argv){
  int pid = getpid();
  /* Pour lire les commande */
  char data[TAILLE_MAX_LU];
  int num_commande;
  int num_service;
  /* Pour lancer mv*/
  char prochain_mv_id = '0';

  printf("[Frontal]Lancement d'un frontal %d ... \n",pid);

  /* Gestion du signal recu */
  /*
  sigset_t masque; 
  struct sigaction action;
  sigfillset(&masque);
  sigdelset(&masque, SIGUSR1);
  sigprocmask(SIG_SETMASK,&masque,NULL);*/

  /* Creation du semaphore et de shm*/
  m_sem = semget(SEMAPHORE_ID, 1, 0666 | IPC_CREAT);
  semctl(m_sem, 0, SETVAL, 1); 
  m_shm = shmget(SHM_ID, sizeof(struct liste_des_mv), 0666 | IPC_CREAT);
  m_list = shmat(m_shm, NULL, 0);
    
  /* Initialisation de shm */
  m_list->nombre_mv_actuel = 0;
 
  
  while (1){
    /* Menu */
    printf("[Frontal]1 Arrete de la frontale.\n");
    printf("[Frontal]2 Affiche la liste des machines virtuelles.\n");
    printf("[Frontal]3 Lancer d'une machine virtuelle.\n");
    printf("[Frontal]4 Arret d'une machine virtuelle.\n");
    printf("[Frontal]5 Lancer une service.\n");
    printf("[Frontal] Votre choix ? :\n");

    /* Lire et traitement des commandes*/
    fgets(data,TAILLE_MAX_LU,stdin);
    num_commande = atoi(data);
    if (num_commande == 1){
      kill_all_mv();
      printf("[Frontal] Quitter.\n");
      exit(0);
    }else if (num_commande == 2){
      afficher_liste_mv();
    }else if (num_commande == 3){
      int pid_fork = fork();
      if (pid_fork == 0){//fils
	printf("[Frontal] Prochain_mv_id %d.\n",prochain_mv_id);
	execl("./MV",&prochain_mv_id,"/",NULL);
      }else if (pid_fork == -1){
	printf("[Frontal] Erreur fork.\n");exit(1);
      }//else pere
      prochain_mv_id +=1;
    }else if (num_commande == 4){
      printf("[Frontal]Veuillez entrer numero du mv a arreter:\n");
      fgets(data,TAILLE_MAX_LU,stdin);
      num_commande = atoi(data);
      kill(m_list->pid_mv[num_commande],SIGUSR1);
    }else if(num_commande == 5){
      printf("[Frontal]Veuillez entrer numero du mv a utiliser:\n");
      fgets(data,TAILLE_MAX_LU,stdin);
      num_commande = atoi(data);
      printf("[Frontal]Veuillez entrer le type du service:\n");
      fgets(data,TAILLE_MAX_LU,stdin);
      num_service = atoi(data);
      printf("[Frontal]MV %d, Service %d",num_commande,num_service);
      printf("[Frontal]Attention le service pour l'instant ne marche pas\n");
      //ecriture de commande dans shm et forcer traitement par mv
      m_list->commande_service[num_commande] = num_service;
      kill(m_list->pid_mv[num_commande],SIGUSR2);
    }else{
      printf("[Frontal]Commande inconnu.\n");
    }
  }//fin while

}


static void afficher_liste_mv(){
  int i;
  
  for(i=0;i<NOMBRE_MAX_MV;i++){
    printf("[Frontal]MV %d, pid %d, status %d ... \n",
	   i, m_list->pid_mv[i],m_list->status_mv[i]);
  }
  printf("[Frontal]Nombre_mv_actuel %d ... \n",
	 m_list->nombre_mv_actuel);
}

static void kill_all_mv(){
  int i;
  //for(i=0;i<MIN(m_list->nombre_mv_actuel,NOMBRE_MAX_MV);i++){
 for(i=0;i<NOMBRE_MAX_MV;i++){
     kill(m_list->pid_mv[i],SIGUSR1);
  }
  printf("[Frontal]All mv clean %d... \n",m_list->nombre_mv_actuel);
  m_list->nombre_mv_actuel = 0;
  
}
