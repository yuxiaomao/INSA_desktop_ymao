% plus simple avec liste inverse

% Faits
palindrome([]).

% Regles Principal
palindrome([A|Tl]) :-
    palindrome([A],Tl).

% Regles
palindrome([_],[]).
palindrome(Hd,[A|Tl]) :- % [A|Hd]
    append(Hd,[A],L),
    palindrome(L,Tl).
palindrome([A|Tl],[A]) :-
    palindrome(Tl).


 
 
