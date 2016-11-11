
#include <stdio.h>

void Permute (int*p1,int*p2){
  int aux;
  aux=*p1;
  *p1=*p2;
  *p2=aux;
}




int main(){
  
  int a=5;
  int b=10;
  printf("avant permute: a=%d b=%d \n",a,b);
  Permute(&a,&b);
  printf("apres permute: a=%d b=%d \n",a,b);


  return 0;
}
