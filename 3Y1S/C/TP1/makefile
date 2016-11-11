default : princ3

all : princ3

clean:
	rm *.o princ3

princ3: princ3.o eleves.o
	gcc -Wall $^ -o $@

%.o:%.c
	gcc -c $<

eleves.o:eleves.h
