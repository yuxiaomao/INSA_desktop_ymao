% split
split(D,0,[],D).
split([X|L1],K,[X|G1],D) :-
 split(L1,K1,G1,D),
 K is K1+1.

% ----- exo 5 -----
% vases
% etat
etat_initial([0,0]).
etat_final([1,_]).
etat_final([_,1]).

% capacite
capacite(a,9).
capacite(b,4).

% action
% remplir
action(remplir(a,Volume),[Va,Vb],[Vamax,Vb]) :-
 capacite(a,Vamax),
 Va < Vamax,
 Volume is Vamax - Va.
action(remplir(b,Volume),[Va,Vb],[Va,Vbmax]) :-
 capacite(b,Vbmax),
 Vb < Vbmax,
 Volume is Vbmax - Vb.
% vider
action(vider(a,Volume),[Va,Vb],[0,Vb]) :-
 Va > 0,
 Volume = Va.
action(vider(b,Volume),[Va,Vb],[Va,0]) :-
 Vb > 0,
 Volume = Vb.
% transferer (Origine, Destination, Volume)
action(transferer(a,b,Volume),[Va1,Vb1],[Va2,Vb2]) :-
 Va1 > 0,
 capacite(b,Vbmax),
 Vb1 < Vbmax,
 Vbremplimax is Vbmax - Vb1,
 Volume is min(Va1, Vbremplimax),
 Va2 is Va1 - Volume,
 Vb2 is Vb1 + Volume.
action(transferer(b,a,Volume),[Va1,Vb1],[Va2,Vb2]) :-
 Vb1 > 0,
 capacite(a,Vamax),
 Va1 < Vamax,
 Varemplimax is Vamax - Va1,
 Volume is min(Vb1, Varemplimax),
 Va2 is Va1 + Volume,
 Vb2 is Vb1 - Volume.
 
% chemin(E1,E2,Actions,Memo)
chemin(E1,E1,[],_).
chemin(E1,E2,[A|Actions],Memo) :-
 not(member(E1,Memo)),
 action(A,E1,Eaux),
 chemin(Eaux,E2,Actions,[E1|Memo]).
%chemin2(E1,E2,Actions,Memo,Eau_Perdue)
chemin2(E1,E1,[],_,0).
chemin2(E1,E2,[A|Actions],Memo,Eau_Perdu2) :-
 not(member(E1,Memo)),
 action(A,E1,Eaux),
 (A = remplir(_,Volume) ; A = vider(_,Volume) ; A = transferer(_,_,Volume)),
 chemin2(Eaux,E2,Actions,[E1|Memo],Eau_Perdu1),
 Eau_Perdu2 is Eau_Perdu1 + Volume.


% pour findall(A,solution0(A),L), length(L,X). X=205
solution0(Actions) :-
 etat_initial(EI),
 etat_final(EF),
 chemin(EI,EF,Actions,[]).
% afficher tout en 1 seul coupsolution(Actions)
solution(Actions) :-
 etat_initial(EI),
 etat_final(EF),
 chemin(EI,EF,Actions,[]),
 write(Actions),
 nl,
 fail.
% solution2(Actions,Eau_Perdue)
solution2(Actions,Eau_Perdu) :-
 etat_initial(EI),
 etat_final(EF),
 chemin2(EI,EF,Actions,[],Eau_Perdu).


% solution_sort(A,E,Amin,Emin,Afin,Efin)
solution2_sort(A,E,_,Emin,A,E) :-
 E<Emin.
solution_sort(_,E,Amin,Emin,Amin,Emin) :-
 E>=Emin.

% solution2_un(List,Amin,Emin).
solution2_un([],none,5000).
solution2_un([(_,E)|Tl],Amin,Emin):-
 solution2_un(Tl,Amin,Emin),
 Emin < E.
solution2_un([(A,E)|Tl],A,E):-
 solution2_un(Tl,_,Eaux),
 Eaux >= E.

solution2_all(A,E) :-
 findall((A1,E1),solution2(A1,E1),LAE),
 solution2_un(LAE,A,E).
% mettre trop longtemps pour s'executer..??


% resu out of range sort
