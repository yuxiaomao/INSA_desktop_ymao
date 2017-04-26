:- lib(listut).

test_jeu(1):-
    situation_initiale(S),
    successeur(x,S,[2,2]),
    heuristique(x,S,H),
    write_state(S),
    writeln(H),
    writeln(""),
    successeur(o,S,[2,1]),
    heuristique(o,S,H1),
    write_state(S),
    writeln(H1),
    writeln(""),
    /*successeur(o,S,[2,1]),
    heuristique(o,S,H2),
    write_state(S),
    writeln(H2),
    writeln(""),
    Renvoie no car il est interdit de jouer sur une case non vide*/
    successeur(x,S,[1,3]),
    heuristique(x,S,H3),
    write_state(S),
    writeln(H3),
    writeln(""),
    successeur(o,S,[3,1]),
    heuristique(o,S,H4),
    write_state(S),
    writeln(H4),
    writeln(""),
    successeur(x,S,[1,1]),
    heuristique(x,S,H5),
    write_state(S),
    writeln(H5),
    writeln(""),
    successeur(o,S,[3,3]),
    heuristique(o,S,H6),
    write_state(S),
    writeln(H6),
    writeln(""),
    successeur(x,S,[1,2]),
    heuristique(x,S,H7),
    write_state(S),
    writeln(H7).

write_state([]).
write_state([Line|Rest]) :-
   writeln(Line),
   write_state(Rest).


	/*********************************
	DESCRIPTION DU JEU DU TIC-TAC-TOE
	*********************************/

	/*
	Une situation est decrite par un tableau 3x3
  	Les joueurs jouent à tour de role
	soit une croix (x) soit un rond (o)
	dans un emplacement libre.

	Pour modéliser un emplacement initialement libre
	on utilise une variable libre.
	Pour modéliser le placement d'un symbole il suffira
	alors d'instancier cette variable via le prédicat
	member/2 ou select/3, ou nth1/3 ...

	La situation initiale est une matrice 3x3 ne comportant
	que des variables libres

	DEFINIR ICI LA CLAUSE DEFINISSANT LA SITUATION INITIALE
	*/


situation_initiale([ [_, _, _],
                [_, _, _],
                [_, _, _] ]).

	/* Convention (arbitraire) : c'est x qui commence

	DEFINIR ICI LE JOUEUR QUI COMMENCE A JOUER EN PREMIER
	*/

joueur_initial(x).

	/* Definition de la relation adversaire/2
	DEFINIR ICI QUI EST ADVERSAIRE DE x ET QUI EST ADVERSAIRE DE o*/

adversaire(x, o).
adversaire(o, x).

	/****************************************************
	 DEFINIR ICI à l'aide du prédicat ground/1 comment
	 reconnaitre une situation terminale due au fait qu'il
	 n'y a plus aucun emplacement libre pour le Joueur
	 (quel qu'il soit) ou qu'on a gagné ou que l'adversaire a gagné
	 ****************************************************/

situation_terminale(_Joueur, Situation) :-
    ground(Situation),!.

situation_terminale(Joueur, Situation) :-
    alignement(Alig,Situation),
    alignement_gagnant(Alig,Joueur),!.

situation_terminale(Joueur, Situation) :-
    adversaire(Joueur,Adv),
    alignement(Alig,Situation),
    alignement_gagnant(Alig,Adv),!.

test_situation_terminale(1) :-
    S1 = [ [x, x, x],
          [x, x, o],
          [o, x, x] ],
    situation_terminale(_,S1),
    S2 = [ [x, _, x],
          [x, x, o],
          [o, x, x] ],
    situation_terminale(_,S2),
    S3 = [ [_, _, _],
          [x, x, o],
          [o, x, x] ],
    not(situation_terminale(_,S3)),
    S4 = [ [x, _, _],
          [x, x, o],
          [o, _, x] ],
    situation_terminale(_,S4).

/**************************
 DEFINITION D'UN ALIGNEMENT
 **************************/

alignement(L, Matrix) :- ligne(L,Matrix).
alignement(C, Matrix) :- colonne(C,Matrix).
alignement(D, Matrix) :- diagonale(D,Matrix).

	/**********************************************
	 COMPLETER LES DEFINITIONS des différents types
 	 d'alignements existant dans une matrice carree
	 **********************************************/

% L est une liste représentant une ligne de la matrice M
ligne(L, M) :-
    member(L,M).

% C est une liste représentant une colonne de la matrice M
colonne(C,M) :-
    colonne(_, C, M).
colonne(_,[],[]).
colonne(N, [E|C], [L|M]) :-
    nth1(N, L, E),
    colonne(N, C, M).

% D est une liste représentant une diagonale de la matrice M
% il y en a 2 sortes

diagonale(D,M) :- diago_desc(1,M,D).
diagonale(D,M) :- length(M,LEN), diago_mont(LEN,M,D).

diago_desc(_,[],[]).
diago_desc(N,[L1|M],[X|D]) :-
	nth1(N,L1,X),
	Nsuiv is N+1,
	diago_desc(Nsuiv,M,D).

% A FAIRE :
diago_mont(_,[],[]).
diago_mont(N,[L1|M],[X|D]) :-
    nth1(N,L1,X),
	Nsuiv is N-1,
	diago_mont(Nsuiv,M,D).



	/***********************************
	 DEFINITION D'UN ALIGNEMENT POSSIBLE
	 POUR UN JOUEUR DONNE
	 **********************************/

alignement_possible(J,Ali,M) :- alignement(Ali,M), possible(Ali,J).

possible([X|L], J) :- unifiable(X,J), possible(L,J).
possible([   ], _).

	/* Attention
	il faut juste verifier le caractere unifiable
	de chaque emplacement de la liste, mais il ne
	faut pas realiser l'unification.
	*/

/* si X est une variable libre alors ok
si elle ne l'est pas, on regarde si elle est égale à J*/
unifiable(X,J) :-
    var(X)
    ;
    ground(X),  X=J.

test_unifiable(1):-
%%Test x non unifiable � o
    unifiable(o,x),
%%Test variable libre non modifi� par unifiable/2
    unifiable(X,o),
    unifiable(X,x).

	/**********************************
	 DEFINITION D'UN ALIGNEMENT GAGNANT
	 OU PERDANT POUR UN JOUEUR DONNE J
	 **********************************/

	/*
	Un alignement gagnant pour J est un alignement
possible pour J qui n'a aucun element encore libre.
Un alignement perdant pour J est gagnant
pour son adversaire.
	*/

alignement_gagnant(Ali, J) :-
    ground(Ali),
    possible(Ali,J).


alignement_perdant(Ali, J) :-
    adversaire(J,Adv),
    alignement_gagnant(Ali, Adv).

test_alignement_gagnant(1) :-
    alignement_gagnant([x,x,x], x),
    not(alignement_gagnant([x,x,x], o)),
    not(alignement_gagnant([x,o,x], x)),
    not(alignement_gagnant([o,o,x], x)),
    not(alignement_gagnant([_,_,_], x)),
    not(alignement_gagnant([x,x,_], x)).

	/******************************
	DEFINITION D'UN ETAT SUCCESSEUR
	*******************************/

	/*
	Il faut définir quelle opération subit
	une matrice M representant la situation courante
	lorsqu'un joueur J joue en coordonnees [L,C]
	*/

successeur(J,Etat,[L,C]) :-
    nth1(L,Etat,Ligne),
    nth1(C,Ligne,Element),
    var(Element),
    Element=J.

	/**************************************
   	 EVALUATION HEURISTIQUE D'UNE SITUATION
  	 **************************************/

	/*
1/ l'heuristique est +infini si la situation J est gagnante pour J
2/ l'heuristique est -infini si la situation J est perdante pour J
3/ sinon, on fait la difference entre :
	   le nombre d'alignements possibles pour J
	moins
 	   le nombre d'alignements possibles pour l'adversaire de J
*/


heuristique(J,Situation,H) :-		% cas 1
   H = 10000,				% grand nombre approximant +infini
   alignement(Alig,Situation),
   alignement_gagnant(Alig,J), !.

heuristique(J,Situation,H) :-		% cas 2
   H = -10000,				% grand nombre approximant -infini
   alignement(Alig,Situation),
   alignement_perdant(Alig,J),!.


% on ne vient ici que si les cut precedents n'ont pas fonctionne,
% c-a-d si Situation n'est ni perdante ni gagnante.

heuristique(J,Situation,H) :-       % cas 3
    findall(Ali,alignement_possible(J,Ali,Situation),ListAli),
    length(ListAli,CountJ),
    %write("nb alignement J:"),
    %writeln(CountJ),
    adversaire(J,Adv),
    findall(Ali,alignement_possible(Adv,Ali,Situation),ListAliAdv),
    length(ListAliAdv,CountAdv),
    %write("nb alignement adversaire J:"),
    %writeln(CountAdv),
    H is CountJ-CountAdv.
