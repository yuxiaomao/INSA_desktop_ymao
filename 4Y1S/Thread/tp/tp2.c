#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>

/*appeler par ./tp2 1 */
/*suppression en car problem dans shell: ipcm -S 0x2001 */

int main(int argc, char*argv[]){
  /*numero process*/
  int num;//recuperer num prog
  /*semaphore*/
  int key_id;
  int semaphore;
  struct sembuf sembuf_p;
  struct sembuf sembuf_v;
  /*donnee pour boucle*/
  char donnee[20];
  /*initialisation des variables*/
  num = atoi(argv[1]);
  printf("num %d\n", num);
  key_id = 0x2001;
  sembuf_p.sem_num = 0;
  sembuf_p.sem_flg = 0;
  sembuf_p.sem_op = -1;
  sembuf_v.sem_num = 0;
  sembuf_v.sem_flg = 0;
  sembuf_v.sem_op = 1;
  //semctl(semaphore,0,IPC_RMID,0);//detruire
  semaphore = semget(key_id,1,0666|IPC_CREAT|IPC_EXCL);//exclu, deja creer
  printf("Valeur semaphore : %i\n", semaphore);
  if (semaphore == -1){// si deja creer
    semaphore = semget(key_id,1,0666);
  }else{
     semctl(semaphore,0,SETVAL,1);
  }
  /*
  semaphore = semget(key_id,1,0666|IPC_CREAT);
  if (num == 1){
    semctl(semaphore,0,SETVAL,1);
  }*/

  while(1){
    semop(semaphore,&sembuf_p,1);
    printf("Veuillez taper (<19char):");
    fgets(donnee,20,stdin);
    printf("donnee : %s\n", donnee);
    semop(semaphore,&sembuf_v,1);
    if (donnee[0]=='\n'){
      printf("Destruction semaphore clef 0x2001.\n");
      semctl(semaphore,0,IPC_RMID,0);//detruire
      break;
    }
  }

  return 0;
}
