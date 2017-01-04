% droite
a_droite(_,[],[]).
a_droite(X,[X|Tl],Tl).
a_droite(X,[A|Tl],D) :-
 X \= A,
 a_droite(X,Tl,D).
 
% gauche
a_gauche(_,[],[]).
a_gauche(X,[X|_],[]).
a_gauche(X,[A|Tl],[A|G]) :-
 X \= A,
 a_gauche(X,Tl,G).
 
% separer
separer(_,[],[],[]).
separer(X,[X|Tl],[],Tl).
separer(X,[A|Tl],[A|G],D) :-
 X \= A,
 separer(X,Tl,G,D).
