	/*
	Ce programme met en oeuvre l'algorithme Minmax (avec convention
	negamax) et l'illustre sur le jeu du TicTacToe (morpion 3x3)
	*/

:- [tictactoe].


	/****************************************************
  	ALGORITHME MINMAX avec convention NEGAMAX : negamax/5
  	*****************************************************/

	/*
	negamax(+J, +Etat, +P, +Pmax, [?Coup, ?Val])

	SPECIFICATIONS :

	retourne pour un joueur J donn�, devant jouer dans
	une situation donnee Etat, de profondeur donnee P,
	le meilleur couple [Coup, Valeur] apres une analyse
	pouvant aller jusqu'a la profondeur Pmax.

	Il y a 3 cas a decrire (donc 3 clauses pour negamax/5)

	1/ la profondeur maximale est atteinte : on ne peut pas
	developper cet Etat ;
	il n'y a donc pas de coup possible a jouer (Coup = rien)
	et l'evaluation de Etat est faite par l'heuristique.

	2/ la profondeur maximale n'est pas  atteinte mais J ne
	peut pas jouer ; au TicTacToe un joueur ne peut pas jouer
	quand le tableau est complet (totalement instancie) ;
	ou quand un adversaire a déjà gagner
	il n'y a pas de coup a jouer (Coup = rien)
	et l'evaluation de Etat est faite par l'heuristique.

	3/ la profondeur maxi n'est pas atteinte et J peut encore
	jouer. Il faut evaluer le sous-arbre complet situe sous Etat ;

	- on determine d'abord la liste de tous les couples
	[Coup_possible, Situation_suivante] via le predicat
	 successeurs/3 (deja fourni, voir plus bas).

	- cette liste est passée à un predicat intermediaire :
	loop_negamax/5, charge d'appliquer negamax sur chaque
	Situation_suivante ; loop_negamax/5 retourne une liste de
	couples [Coup_possible, Valeur]

	- parmi cette liste, on garde le meilleur couple, c-a-d celui
	qui a la plus petite valeur (cf. predicat meilleur/2);
	soit [C1,V1] ce couple optimal. Le predicat meilleur/2
	effectue cette selection.

	- finalement le couple retourne par negamax est [Coup, V2]
	avec : V2 is -V1 (cf. convention negamax vue en cours).

A FAIRE : ECRIRE ici les 3 clauses de negamax/5
.....................................
	*/

%negamax(+J, +Etat, +P, +Pmax, [?Coup, ?Val])
%negamax(J, E, P, P, [rien, V]) :-
%    !,
%    heuristique(J, E, V).
%negamax(
negamax(J, Etat, P, Pmax, [Coup, Val]) :-
    (P = Pmax -> % cas1
        (Coup = rien,
         heuristique(J, Etat, Val)
         )
        ;( situation_terminale(J, Etat) -> % cas2
            (Coup = rien,
             heuristique(J, Etat, Val))
            ;( % cas3
                successeurs(J, Etat, Succ),
                loop_negamax(J,P,Pmax,Succ,SuccV),
                meilleur(SuccV, [C1,V1]),
                Coup = C1,
                Val is -V1
            )
        )
    ).

	/*******************************************
	 DEVELOPPEMENT D'UNE SITUATION NON TERMINALE
	 successeurs/3
	 *******************************************/

	 /*
   	 successeurs(+J,+Etat, ?Succ)

   	 retourne la liste des couples [Coup, Etat_Suivant]
 	 pour un joueur donne dans une situation donnee
	 */

successeurs(J,Etat,Succ) :-
	findall([Coup,Etat_Suiv],
		(copy_term(Etat, Etat_Suiv), successeur(J,Etat_Suiv,Coup)),
		 Succ).

	/*************************************
         Boucle permettant d'appliquer negamax
         a chaque situation suivante :
	 loop_negamax/5
         *************************************/

	/*
	loop_negamax(+J,+P,+Pmax,+Successeurs,?Liste_Couples)
	retourne la liste des couples [Coup, Valeur_Situation_Suivante]
	a partir de la liste des couples [Coup, Situation_Suivante]
	*/

loop_negamax(_,_, _  ,[                ],[			    ]).
loop_negamax(J,P,Pmax,[[Coup,Suiv]|Succ],[[Coup,Vsuiv]|Reste_Couples]) :-
	loop_negamax(J,P,Pmax,Succ,Reste_Couples),
	% loop pour appliquer sur tous les couples
	adversaire(J,A), % comme on joue du point de vue de J
	%la situation suivante sera celle de son adversaire: A
	Pnew is P+1, % on incrémente la profondeur
	negamax(A,Suiv,Pnew,Pmax, [_,Vsuiv]). % on applique negamax pour la situation suivante mais on envoie pas Coup puisque c'est le co�t optimal de la situation suivante par rapport aux situations suivantes+1.

	/*

A FAIRE : commenter chaque litteral de la 2eme clause de loop_negamax/5,
	en particulier la forme du terme [_,Vsuiv] dans le dernier
	litteral ?
	*/

	/*********************************
	 Selection du couple qui a la plus
	 petite valeur V
	 *********************************/

	/*
	meilleur(+Liste_de_Couples, ?Meilleur_Couple)

	SPECIFICATIONS :
	On suppose que chaque element de la liste est du type [C,V]
	- le meilleur dans une liste a un seul element, est cet element
	- le meilleur dans une liste [X|L] avec L \= [], est obtenu en comparant
	  X et Y,le meilleur couple de L
	  Entre X et Y on garde celui qui a la petite valeur de V.

A FAIRE : ECRIRE ici les clauses de meilleur/2
................................................

	*/
meilleur([Couple], Couple).
meilleur([[C1,V1]|Rest], MeilleurCouple) :-
    meilleur(Rest, [C2,V2]),
    (V1 > V2 ->
        (MeilleurCouple = [C2,V2]);
        (MeilleurCouple = [C1,V1])
    ).


	/******************
  	PROGRAMME PRINCIPAL
  	*******************/

main(C,V, Pmax) :-
	situation_initiale(Ini),
	joueur_initial(J),
	negamax(J, Ini, 1, Pmax, [C, V]).


	/*
A FAIRE :
	Tester ce programme pour plusieurs valeurs de la profondeur maximale.
	Pmax = 1, 2, 3, 4 ...
	Commentez les résultats obtenus.
	*/
