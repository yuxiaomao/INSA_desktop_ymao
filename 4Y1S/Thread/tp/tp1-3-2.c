#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


/*pas resolu problem open*/


int main(int argc, char*argv[]){
  int num;//recuperer num prog
  int d_read;
  int d_write;
  int i=0;
  int donnee;
  num=atoi(argv[1]);
  donnee=1;
  printf("donnee %d\n", donnee);
  printf("num %d\n", num);
  switch (num){
  case 1:
    printf("1\n");
    mkfifo("tube1.txt",S_IRUSR|S_IWUSR|S_IRGRP);
    mkfifo("tube2.txt",S_IRUSR|S_IWUSR|S_IRGRP);
    printf("2\n");
    d_write=open("./tube1.txt",O_WRONLY);
    printf("3\n");
    d_read=open("./tube2.txt",O_RDONLY);
    printf("4\n");
    printf("d_write %d\n", d_write);
    for(i=0;i<1000;i++){
      write(d_write,&donnee, sizeof(int));
      donnee++;
      read(d_read,&donnee, sizeof(int));
    }
    unlink("./tube2.txt");
    unlink("./tube1.txt");
    break;
  case 2:
    printf("2\n");
    d_write=open("./tube2.txt",O_WRONLY);
    printf("3\n");
    d_read=open("./tube1.txt",O_RDONLY);
    printf("4\n");
    for(i=0;i<1000;i++){
      read(d_read,&donnee, sizeof(int));
      donnee ++;
      write(d_write,&donnee, sizeof(int));
    }
    unlink("./tube2.txt");
    unlink("./tube1.txt");
    break;
  default:
    exit(-1);break;
  }

  return 0;
}
