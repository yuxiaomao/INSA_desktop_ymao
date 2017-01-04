
% fait
graphe(g1, [1,2,3,4,5,6], [ [1,2],[1,3],[2,4],[3,4],[4,5],[4,6] ]). 
graphe(g2,[1,2,3,4,5,6], [ [1,2],[1,3],[2,3],[2,4],[3,4],[4,1],[4,5],[4,6] ]). 

% relation
arc(G,O,E) :-
 graphe(G,_,Arcs),
 member([O,E],Arcs).

% existe_chemin
existe_chemin(G,O,E) :-
 arc(G,O,E), 
 !.
existe_chemin(G,O,E) :-
 arc(G,O,Aux),
 existe_chemin(G,E,Aux).

% chemin ex?-chemin(g1,1,6,Ch).
chemin(G,O,E,[[O,E]]) :-
 arc(G,O,E).
chemin(G,O,E,[[O,Aux]|Ch]) :-
 arc(G,O,Aux),
 chemin(G,Aux,E,Ch).

% chemin_sans_circuit, chemin_sans_circuit(g2,1,6,Chemin,[]).
% Memo = accumulateur

chemin_sans_circuit(G,O,E,[[O,E]],Memo) :-
 not(member(O,Memo)),
 arc(G,O,E).
chemin_sans_circuit(G,O,E,[[O,Aux]|Ch],Memo) :-
 not(member(O,Memo)),
 arc(G,O,Aux),
 chemin_sans_circuit(G,Aux,E,Ch,[O|Memo]).
