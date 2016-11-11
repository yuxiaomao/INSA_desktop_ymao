// programme pour calculer la somme des cubes d'une suite d'entiers consécutifs

void subtest( int, int * );

int main(void)
{
int i, j;
j = 0;
for	( i = 1; i < 5; ++i)
	subtest( i, &j );
while (1) {}
}
