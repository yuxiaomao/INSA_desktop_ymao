:- include('taquin.pl').
:- include('avl.pl').

main(N):-
    initial_state(N, S0),
    write_state(S0),
    G0 is 0,
    heuristique(S0,H0),
    F0 is G0 + H0,
    Pf0 = nil,
    Pu0 = nil,
    Q = nil,
    insert([[F0,H0,G0],S0], Pf0, Pf),
    insert([S0,[F0,H0,G0],nil,nil], Pu0, Pu),
    aetoile(Pf,Pu,Q).

% aetoile
aetoile(Pf,Pu,Q) :-
    suppress_min([_,U], Pf, _),
    final_state(U),
    %writeln(10),
    affiche_solution(U,Pu,Q).
aetoile(Pf,Pu,Q) :-
    suppress_min([Val,U], Pf, Pf2),
    not(final_state(U)),
    %writeln(11),
    suppress([U,Val,Pereu,Actionu],Pu,Pu2),
    insert([U,Val,Pereu,Actionu], Q, Q2),
    findall([S, Newval, U, A],(expand(U, Val, S, Newval, A)),ListElement),
    loop_successors(ListElement,Pf2,Pu2,Q2,Pfres,Pures),
    %write(pfe),put_flat(Pfres),writeln(''),
    %write(pue),put_flat(Pures),writeln(''),
    %write(qe),put_flat(Q2),writeln(''),
    (empty(Pfres) -> writeln('Empty Pf.') ; true),
    aetoile(Pfres,Pures,Q2).
    
% affiche
affiche_solution(nil,_,_).
/*
affiche_solution(U,Pu,Q) :-
    U \= nil,
    belongs([U,[_,_,_],Pere,_],Q),
    affiche_solution(Pere,Pu,Q),
    write_state(U).

affiche_solution(U,Pu,Q) :-
    U \= nil,
    belongs([U,[_,_,_],Pere,_],Pu),
    affiche_solution(Pere,Pu,Q),
    write_state(U).
*/
affiche_solution(U,Pu,Q) :-
    U \= nil,
    belongs([U,[_,_,_],Pere,A],Q),
    affiche_solution(Pere,Pu,Q),
    write(A), write(' -> ').

affiche_solution(U,Pu,Q) :-
    U \= nil,
    belongs([U,[_,_,_],Pere,A],Pu),
    affiche_solution(Pere,Pu,Q),
    write(A), write(' -> ').
    
expand(U, [_, _, Gu], S, [Fs, Hs, Gs], A) :-
    rule(A, C, U, S),
    Gs is Gu + C,
    heuristique(S, Hs),
    Fs is Gs + Hs.

% expand
/*
expand([],_,[]).
expand([[Action,Cost,S]|RestACS],[Pere,[_,_,Gu]],[Element|RestElement]) :-
    %writeln(3),
    G is Gu + Cost,
    heuristique(S,H),
    F is G + H,
    Element = [S,[F,H,G],Pere,Action], 
    expand(RestACS,[Pere,[_,_,Gu]],RestElement).
*/

% test
affiche_list_element([]).
affiche_list_element([[S,[F,H,G],nil,_]|RestElement]) :-
    write(s),write_state(S),writeln(''),
    write(f),write(F),write(H),write(G),writeln(''),
    write(pere),write(nil),writeln(''),
    affiche_list_element(RestElement).
affiche_list_element([[S,[F,H,G],Pere,_]|RestElement]) :-
    Pere \= nil,
    write(s),write_state(S),writeln(''),
    write(f),write(F),write(H),write(G),writeln(''),
    write(pere),write_state(Pere),writeln(''),
    affiche_list_element(RestElement).

% loop_successors
loop_successors([],Pf,Pu,_,Pf,Pu).

loop_successors([[S,[_,_,_],_,_]|RestElement],Pf,Pu,Q,Pfafter,Puafter) :-
    belongs([S,[_,_,_],_,_],Q),  
    loop_successors(RestElement,Pf,Pu,Q,Pfafter,Puafter).

loop_successors([[S,[F,_,_],_,_]|RestElement],Pf,Pu,Q,Pfafter,Puafter) :-
    not(belongs([S,[_,_,_],_,_],Q)),
    belongs([S,[Fu,_,_],_,_],Pu),
    not(F < Fu),
    loop_successors(RestElement,Pf,Pu,Q,Pfafter,Puafter).

loop_successors([[S,[F,H,G],Pere,Action]|RestElement],Pf,Pu,Q,Pfafter,Puafter) :-
    not(belongs([S,[_,_,_],_,_],Q)),
    belongs([S,[Fu,Hu,Gu],_,_],Pu),
    F < Fu,
    suppress([S,[Fu,Hu,Gu],_,_],Pu,Pu2),
    insert([S,[F,H,G],Pere,Action],Pu2,Pu3),
    suppress([[Fu,Hu,Gu],S],Pf,Pf2),
    insert([[F,H,G],S],Pf2,Pf3),
    loop_successors(RestElement,Pf3,Pu3,Q,Pfafter,Puafter).
 
loop_successors([[S,[F,H,G],Pere,Action]|RestElement],Pf,Pu,Q,Pfafter,Puafter) :-
    not(belongs([S,[_,_,_],_,_],Q)),
    not(belongs([S,[_,_,_],_,_],Pu)),
    insert([S,[F,H,G],Pere,Action],Pu,Pu2),
    insert([[F,H,G],S],Pf,Pf2),
    loop_successors(RestElement,Pf2,Pu2,Q,Pfafter,Puafter).
 
 
