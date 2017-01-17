all: mathvm mathvm.s
mathvm: mathvm.c
	gcc -Wall -g mathvm.c -o mathvm
mathvm.s: mathvm.c
	gcc -Wall -g -S mathvm.c
