#include <stdio.h>
extern void system(char*c);

void Affiche(char* s)
{
  printf("%s",s);
}

int Fact(int e)
{
  if (e>1)  
    return Fact(e-1)*e;
  else 
    return 1;
}

void Date()
{
  system("/bin/date");
}

/*
int main()
{
  Affiche("HAHAHA\n");
  printf("%d\n",Fact(4));
  Date();
  return 0;
}
*/
