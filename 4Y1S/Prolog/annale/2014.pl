% graphe
graphe(g1,[1,2,3,4,5],[[1,2],[1,3],[1,5],[2,3],[3,4],[4,5]]).
graphe(g2,[1,2,3,4,5],[[1,2],[1,3],[1,4],[1,5],[2,3],[3,4],[4,5]]).
graphe(g3,[1,2,3,4,5],[[1,2],[1,3],[1,5],[2,3],[2,5],[4,5]]).

% sommet
sommet(G,X) :-
 graphe(G,S,_),
 member(X,S).

arete(G,[O,E]) :-
 graphe(G,_,A),
 member([O,E],A).

% etat
etat_initial(G,Sommet_A_Quitter,Arrets_Restant) :-
 graphe(G,S,Arrets_Restant),
 member(Sommet_A_Quitter,S).
etat_final(_,_,[]).

% enlever
enlever(X,[X|L], L).		% cas du retrait du 1er de la liste
enlever(X,[Y|L], [Y|R]):-       % cas des elements suivants 
	enlever(X,L,R).

% transition(Etat_init,Etat_fin,Arc)
transition([S1,A1],[S2,A2],[S1,S2]) :-
 enlever([S1,S2],A1,A2).
transition([S1,A1],[S2,A2],[S1,S2]) :-
 enlever([S2,S1],A1,A2).

% resoudre
resoudre(_,[],_).
resoudre(S0,Arrets_Restant,[Arc|Liste_Parcours]) :-
 transition([S0,Arrets_Restant],[S1,A1],Arc),
 resoudre(S1,A1,Liste_Parcours).
 

% main
main(G,Solution) :-
 etat_initial(G,S0,TousArrets),
 resoudre(S0,TousArrets,Solution).
 
