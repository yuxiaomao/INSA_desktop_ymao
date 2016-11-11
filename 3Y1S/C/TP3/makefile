default: afd
all:afd
clean:
	rm *.o afd
afd:graphe.o automate.o
	gcc -g graphe.o automate.o -o $@
%.o:%.c
	gcc -g -c $<
graphe.o:graphe.h
automate.o:automate.h
