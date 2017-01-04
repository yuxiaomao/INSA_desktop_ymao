% etat_problem (Liste_des_plaques_restant,Nombre_a_realiser)

plaques_disponibles([1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,25,25,50,50,75,75,100,100]).

% --- 5.1 ---
etat_initial([5,100,2,6,2,1]).
etat_final([994|_]).
% 
% E1(L1,N) à E2(L2,N)
% on choisi deux nombre dans L1 qui est possible pour faire une calcul
% on realise le calcul et mettre le resultat dans L2
% L2 = L1 enleve 2 nombre utilise et ajoute resultat du calcul

% --- 5.2 ---
operation(A,B,[add(A,B),Res]) :-
 Res is A + B,
 Res =< 999.
operation(A,B,[mul(A,B),Res]) :-
 Res is A * B,
 Res =< 999.
operation(A,B,[div(A,B),Res]) :-
 0 is A mod B,
 Res is A // B.
operation(A,B,[del(A,B),Res]) :-
 A > B,
 Res is A - B.

% --- 5.3 ---
choix_plaques(P1,A,B,P2) :-
 member(A,P1),
 delete(A,P1,Paux),
 member(B,Paux),
 delete(B,Paux,P2).

% --- 5.4 ---
arc(Pi,[Res|Paux], Aij) :-
 choix_plaques(Pi,A,B,Paux),
 operation(A,B,[Aij,Res]).

% --- 5.5 ---
chemin(Ei,Ej,[Aij]):-
 arc(Ei,Ej,Aij).
chemin(Ei,Ej,[Aiaux|Tl]) :-
 arc(Ei,Eaux,Aiaux),
 chemin(Eaux,Ej,Tl).

main(Solution) :-
 etat_initial(Ei),
 chemin(Ei,Ef,Solution),
 etat_final(Ef).
 
 
