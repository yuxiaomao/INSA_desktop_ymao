:- lib(listut).       % a placer en commentaire si on utilise Swi-Prolog
                      % (le predicat delete/3 est predefini)

                      % Indispensable dans le cas de ECLiPSe Prolog
                      % (le predicat delete/3 fait partie de la librairie listut)

%***************************
%DESCRIPTION DU JEU DU TAKIN
%***************************

   %********************
   % ETAT INITIAL DU JEU
   %********************

initial_state(2, [ [a, b, c],
                [g, h, d],
                [vide,f,e] ]). % h=2, f*=2



initial_state(5, [ [b, h, c],     % EXEMPLE
                [a, f, d],     % DU COURS
                [g,vide,e] ]). % h=5 = f* = 5actions


initial_state(10, [ [b, c, d],
                [a,vide,g],
                [f, h, e]  ]). % h=10 f*=10


initial_state(20, [ [f, g, a],
                [h,vide,b],
                [d, c, e]  ]). % h=16, f*=20

initial_state(30, [ [e, f, g],
                [d,vide,h],
                [c, b, a]  ]). % h=24, f*=30


   %******************
   % ETAT FINAL DU JEU
   %******************

final_state([[a, b,  c],
             [h,vide,d],
             [g, f,  e]]).

   %********************
   % AFFICHAGE D'UN ETAT
   %********************

write_state([]).
write_state([Line|Rest]) :-
   writeln(Line),
   write_state(Rest).


%**********************************************
% REGLES DE DEPLACEMENT (up, down, left, right)
%**********************************************
   % format :   rule(+Rule_Name, ?Rule_Cost, +Current_State, ?Next_State)

rule(up,   1, S1, S2) :-
   vertical_permutation(_X,vide,S1,S2).

rule(down, 1, S1, S2) :-
   vertical_permutation(vide,_X,S1,S2).

rule(left, 1, S1, S2) :-
   horizontal_permutation(_X,vide,S1,S2).

rule(right,1, S1, S2) :-
   horizontal_permutation(vide,_X,S1,S2).

   %***********************
   % Deplacement horizontal
   %***********************

horizontal_permutation(X,Y,S1,S2) :-
   append(Above,[Line1|Rest], S1),
   exchange(X,Y,Line1,Line2),
   append(Above,[Line2|Rest], S2).

   %***********************************************
   % Echange de 2 objets consecutifs dans une liste
   %***********************************************

exchange(X,Y,[X,Y|List], [Y,X|List]).
exchange(X,Y,[Z|List1],  [Z|List2] ):-
   exchange(X,Y,List1,List2).

   %*********************
   % Deplacement vertical
   %*********************

vertical_permutation(X,Y,S1,S2) :-
   append(Above, [Line1,Line2|Below], S1), % decompose S1
   delete(N,X,Line1,Rest1),    % enleve X en position N a Line1,   donne Rest1
   delete(N,Y,Line2,Rest2),    % enleve Y en position N a Line2,   donne Rest2
   delete(N,Y,Line3,Rest1),    % insere Y en position N dans Rest1 donne Line3
   delete(N,X,Line4,Rest2),    % insere X en position N dans Rest2 donne Line4
   append(Above, [Line3,Line4|Below], S2). % recompose S2

   %***********************************************************************
   % Retrait d'une occurrence X en position N dans une liste L (resultat R)
   %***********************************************************************
   % use case 1 :   delete(?N,?X,+L,?R)
   % use case 2 :   delete(?N,?X,?L,+R)

delete(1,X,[X|L], L).
delete(N,X,[Y|L], [Y|R]) :-
   delete(N1,X,L,R),
   N is N1 + 1.

   %**********************************
   % HEURISTIQUES (PARTIE A COMPLETER)
   %**********************************

heuristique(U,H) :-
%   heuristique1(U, H).  % choisir l'heuristique
   heuristique2(U, H).  % utilisee ( 1 ou 2)

   %****************
   %HEURISTIQUE no 1
   %****************

   % Calcul du nombre de pieces mal placees dans l'etat courant U
   % par rapport a l'etat final F

heuristique1(U, H) :-
    final_state(F),
    heuristique1(U,F,H).
% heuristique1(M1,M2,H).
heuristique1([],[],0).
heuristique1([L1|R1],[L2|R2],H) :-
    heuristique1_line(L1,L2,Hl),
    heuristique1(R1,R2,Hr),
    H is Hl + Hr.
% heuristique1_line
heuristique1_line([],[],0).
heuristique1_line([E1|R1],[E2|R2],H) :-
    heuristique1_element(E1,E2,He),
    heuristique1_line(R1,R2,Hl),
    H is He + Hl.
% heuristique1_element
heuristique1_element(E1,E2,1) :-
    E1 \= E2,
    E1 \= vide,
    E2 \= vide.
heuristique1_element(E1,E1,0).
heuristique1_element(vide,_,0).
heuristique1_element(_,vide,0).

   %****************
   %HEURISTIQUE no 2
   %****************

   % Somme sur l'ensemble des pieces des distances de Manhattan
   % entre la position courante de la piece et sa positon dans l'etat final


heuristique2(U, H) :-
    final_state(F),
    heuristique2(U,F,H).
heuristique2(M1,F,H):-
    findall(E,(member(L1,M1),member(E,L1),E\=vide),ListElement),
    heuristique2_element(M1,F,ListElement,H).
% heuristique2_une_liste_d_element
heuristique2_element(_,_,[],0).
heuristique2_element(M1,M2,[E|Rest],H):-
    nth1(Y1,M1,L1),
    nth1(X1,L1,E),
    nth1(Y2,M2,L2),
    nth1(X2,L2,E),
    heuristique2_element(M1,M2,Rest,Hrest),
    H is abs(X1-X2)+abs(Y1-Y2)+Hrest.
