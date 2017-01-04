#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>

/*clef shm et sem = 0x2001
  ipcrm -M 0x2001
  ipcrm -S 0x2001
  at_0(sem) (sem_op=0) attendre semaphore jusqua 0
*/


int main(int argc, char*argv[]){
  int num;//recuperer num prog
  /*semaphore*/
  int key_id;
  int semaphore;
  struct sembuf sembuf_p[2];
  struct sembuf sembuf_v[2];
  /*shm, memoire partage*/
  int shm;
  int *ptr;
  /*variable boucle*/
  int i = 0;
  int donnee = 0;
  /*initialisation des variables num, key, pv*/
  num = atoi(argv[1]);
  printf("num %d\n", num);
  key_id = 0x2001;
  sembuf_p[0].sem_num = 0;
  sembuf_p[0].sem_flg = 0;
  sembuf_p[0].sem_op = -1;
  sembuf_p[1].sem_num = 1;
  sembuf_p[1].sem_flg = 0;
  sembuf_p[1].sem_op = -1;
  sembuf_v[0].sem_num = 0;
  sembuf_v[0].sem_flg = 0;
  sembuf_v[0].sem_op = 1;
  sembuf_v[1].sem_num = 1;
  sembuf_v[1].sem_flg = 0;
  sembuf_v[1].sem_op = 1;
  /*creation semaphore*/
  semaphore = semget(key_id,2,0666|IPC_CREAT|IPC_EXCL);//exclu, deja creer
  printf("Valeur semaphore : %d\n", semaphore);
  if (semaphore == -1){// si deja creer
    semaphore = semget(key_id,2,0666);
  }else{
    semctl(semaphore,0,SETVAL,1);//valeur init du semaphore 1
    semctl(semaphore,1,SETVAL,0);
  }
  /*shm:creation et attachement zone memoire*/
  shm = shmget(key_id,sizeof(int),0666|IPC_CREAT);
  ptr = shmat(shm,NULL,0);
  printf("Valeur shm : %d\n", shm);
  printf("Valeur ptr : %d\n", *ptr);
  /*processus*/
  switch (num){
  case 1:
    for(i=0;i<1000;i++){
      semop(semaphore,&sembuf_p[0],1);
      printf("[Processus %d]Ecriture *ptr :%d\n", num, *ptr);
      *ptr = donnee;
      semop(semaphore,&sembuf_v[1],1);
      
      semop(semaphore,&sembuf_p[0],1);
      printf("[Processus %d]Lecture *ptr :%d\n", num, *ptr);
      semop(semaphore,&sembuf_v[1],1);
      donnee++;
    }
    shmdt(&ptr);
    break;
  case 2:
    for(i=0;i<1000;i++){
      semop(semaphore,&sembuf_p[1],1);
      printf("[Processus %d]Valeur *ptr :%d\n", num, *ptr);
      semop(semaphore,&sembuf_v[0],1);
      donnee++;
      semop(semaphore,&sembuf_p[1],1);
      *ptr = donnee;
       printf("[Processus %d]Ecriture *ptr :%d\n", num, *ptr);
      semop(semaphore,&sembuf_v[0],1);
    }
    shmdt(&ptr);
    printf("Destruction semaphore clef 0x2001.\n");
    semctl(semaphore,0,IPC_RMID,0);//detruire
    semctl(semaphore,1,IPC_RMID,0);
    shmctl(shm,IPC_RMID,0);
    break;
  default:
    exit(-1);
    break;
  }

  return 0;
}
