fact(0,1) :- !.      % factorielle(0) = 1
fact(N,F) :-          % factorielle(N) = N*factorielle(N-1)
 N1 is N-1,
 fact(N1,F1),
 F is N*F1. 

/*
celui ne peut pas utiliser pour nombre negatif

fact(2,F)
 N1 is 1,
 fact(1,F1), % not fact(0,1)
   N2 is 0,
   fact(0,F2), 
     - fact(0,1), ! % permet de couper les fact(N,F) inutile.
     #- fact(N,F).
 F is 2*1
*/

my_fact(N,F) :-
 N>0,
 N1 is N-1,
 my_fact(N1,F1),
 F is N*F1.
my_fact(0,1).


/*somme(+L,?S), sinon overflow*/
somme([],0).
somme([A|TL],S) :-
 somme(TL,S1),
 S is A+S1.


/*somme tail recursif*/
somme2([], S,S).
somme2([X|L],I,S) :-
 J is X+I,
 somme2(L,J,S). 

/*Fibonacci fibo(n,value)*/
fibo(0,0) :- !.
fibo(1,1) :- !.
fibo(N,Value) :-
 N>1
 N1 is N-1,
 N2 is N-2,
 fibo(N1,V1),
 fibo(N2,V2),
 Value is V1+V2.


/*fiboplus(n,value_n,value_n-1)*/
fiboplus(0,0,0).
fiboplus(1,1,0).
fiboplus(N,Value_n,Value_n1) :-
 N>1,
 N1 is N-1,
 fiboplus(N1,Value_n1,V2),
 Value_n is Value_n1+V2.

