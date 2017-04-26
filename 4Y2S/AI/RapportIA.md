# Rapport Travaux Pratiques Intelligence Artificielle
**(Ce rapport, initialement en pdf, transformé en Markdown donc des images sont simplifiés)**

A l’attention de _M. Capelle_ et _M. Esquirol_,

par _Rama DESPLATS_ et _Yuxiao MAO_

Année 2016/2017 - 4ème année IR

# Introduction
Dans ce rapport, nous nous efforcerons d’expliquer avec le plus de recul possible les choix de programmation, les choix algorithmiques, les tests unitaires et les résultats des tests effectués.

Ce rapport sera accompagné des fichiers de code commentés et indentés.

# Travaux pratiques n°1
Le premier TP d’Intelligence Artificielle consistait à implémenter l’algorithme A\* sous forme générique, mais appliqué au Takin dans le cadre de ce TP.

L’implémentation de l’algorithme A\* s’aide des arbres binaires de recherches(AVL) et de deux heuristiques :
- l’une utilisant le nombre de pièces mal placées
- l’autre utilisant la somme des distances de Manhattan

Intuitivement, on peut déjà sentir que la deuxième heuristique sera capable de résoudre des problèmes plus compliqués et plus rapidement. Afin de vérifier cette intuition, nous avons étudié le temps de calcul de séquences de taille variable pour chacune des deux heuristiques.

| Heuristique | Longueur 2 | Longuer 5 | Longueur 10 | Longueur 20 | Longueur 30 |
| --- | --- | --- | --- | --- | --- |
| pièces mal placées | 0.186 | 0.186 | 0.186 | 0.481 | 12.954 |
| distances de Manhattan | 0.182 | 0.188 | 0.181 | 0.189 | 0.430 |

_Figure 1 - Temps de calcul (en ms) pour chaque heuristique des différentes séquences_

On peut facilement remarquer que pour des séquences de petites tailles, les deux heuristiques peuvent résoudre le problème de façon “triviale” (quelques millisecondes). Pour la longueur 20, le temps de calcul double pour l’heuristique 1 et explose littéralement pour un calcul de longueur 30. Il a même été nécessaire d’augmenter manuellement la taille de la pile pour réaliser les calculs.

De plus, il a fallu faire très attention à l’optimisation du code puisque le fait de renseigner deux paramètres de moins au prédicat suppress a entrainé une explosion de la pile même pour l’heuristique 2.

En conclusion, on peut donc dire que qu’il est envisageable de résoudre en un temps raisonnable des problèmes de longueur 20 et qu’en étant pointilleux, on peut résoudre des problèmes de longueur 30 avec les bonnes heuristiques. De plus, on remarque que l’heuristique 2 est meilleure puisqu’elle est inférieur à l’heuristique 1 et qu’elle est le plus proche possible de la valeur réelle. On sent bien que cette heuristique est plus précise.

Cette forte consommation de mémoire nous amène à nous poser des questions sur des améliorations possibles de l’algorithme. On peut se pencher dans un premier temps sur la structure stockant les états : les arbres binaires. Il aurait été plus rapide d’utiliser un arbre binaire pour la recherche mais d’utiliser une autre structure triée pour stocker les résultats. En utilisant, par exemple, un tas pour chercher le noeud de coût minimum, la complexité de l’algorithme sera meilleure.

L’insertion revient à faire une opération en 0(log n) et l’accès au meilleur élément
en O(1).

De plus, avant d’intégrer les différents prédicats au programme général, nous avons testé leur fonctionnement indépendamment lors de tests unitaires.

Par exemple, pour le prédicat loop_successors nous avons testé :
- loop_successors sur une liste vide => ne doit rien faire
- loop_successors sur une liste non vide :
  - liste contenant un état connu dans Q => doit oublier l’état
  - liste contenant un état connu dans Pu avec une moins bonne évaluation => doit ne rien faire
  - liste contenant un état connu dans Pu avec une meilleure évaluation => doit garder la meilleure évaluation dans Pu et Pf
  - liste contenant un état inconnu => création du terme à insérer dans Pu et Pf

Pour les autres prédicats, nous avons principalement vérifié qu’ils fonctionnent comme attendus (exemple: expand calcule bien l’évaluation d’une situation).

Comme la programmation de l’algorithme A\* est générique, il suffit entre autres (à l’instar du fichier taquin.pl) de définir la situation initiale, la situation finale, les heuristiques et comment se déplace les pièces pour qu’A\* puisse résoudre d’autres problèmes classiques comme le Rubik’s Cube ou l’Ane Rouge.

# Travaux pratiques n°2
Le deuxième TP d’Intelligence Artificielle consistait à implémenter l’algorithme Negamax, mais appliqué au Tic Tac Toe (comprenez le Morpion 3x3) dans le cadre de ce TP.

Cet algorithme parcourt une liste de coups possible et retourne le couple [Coup,Valeur] optimal parmi cette liste.

Le sujet tel qu’il était posé présentait une amélioration possible. En effet, le calcul de l’heuristique ne se fait que lorsqu’on détecte une situation terminale. Or, le sujet définissait la situation terminale comme une situation où il n’y a plus aucun emplacement libre pour le joueur. Cependant, il est possible que l’un des joueurs ait gagné (réalisé un alignement gagnant) avant que tous les emplacements soient joués.

On peut donc arriver dans une situation où les deux joueurs “gagnent” mais que l’algorithme en le détecte pas (cf ci-dessous).

Comme les 3 clauses de l’heuristique sont définies dans un ordre qui laisse prévaloir l’alignement gagnant pour J alors le programme retournerait toujours 10000 (victoire de J).

| Tic | Tac | Toe|
| --- | --- | --- |
| x | o | o |
| x | x | o |
| x | x | o |

_Figure 2 - Exemple de Tic Tac Toe gagnant pour deux joueurs_

Il a donc fallu modifier le concept de situation terminale pour prendre en
compte le fait que le jeu se termine dès lors que le joueur J a réalisé un alignement
gagnant ou que son adversaire Adv a réalisé un alignement gagnant ou qu’il n’y ait
plus d’emplacements libres.

Le prédicat devient donc :
```prolog
situation_terminale(_Joueur, Situation) :-
    ground(Situation),!.

situation_terminale(Joueur, Situation) :-
    alignement(Alig,Situation),
    alignement_gagnant(Alig,Joueur),!.

situation_terminale(Joueur, Situation) :-
    adversaire(Joueur,Adv),
    alignement(Alig,Situation),
    alignement_gagnant(Alig,Adv),!.
```
_Figure 3 - Nouvelles clauses du prédicat situation terminale_

Nous avons réalisés des tests afin de mesurer le temps de calcul pour les différentes profondeurs et afin de voir si le programme donne toujours les mêmes résultats suivant les profondeurs.

| Profondeur max | Temps moyen | Coup | Valeur |
| --- | --- | --- | --- |
| 1 | 0.147 | null | 0 |
| 2 | 0.158 | [2,2] | 4 |
| 4 | 0.159 | [2,2] | 3 |
| 6 | 0.390 | [2,2] | 3 |
| 8 | 2.489 | [2,2] | 2 |
| 9 | 4.359 | [1,1] | 0 |
| 10 | 5.178 | [1,1] | 0 |

_Figure 4 - Temps de calcul (en ms) et résultat pour chaque profondeur max_

On remarque que le temps de calcul double pour chaque itération entre les profondeurs 6 et 9 pour se stabiliser à partir de 10 et pour les itérations supérieurs.

On peut expliquer ce phénomène puisqu’il va toujours évaluer un Tic Tac Toe rempli. On peut aussi remarquer que pour un Tic Tac Toe rempli, le coup renvoyé devient [1,1] (en haut à gauche) au lieu de [2,2] (milieu) puisque si les deux joueurs jouent “parfaitement”, on arrive systématiquement dans une situation d’égalité à partir de ce coup.

Expliquons le prédicat intermédiaire du Negamax : loop_negamax.

```prolog
loop_negamax(_,_, _  ,[                ],[			    ]).
loop_negamax(J,P,Pmax,[[Coup,Suiv]|Succ],[[Coup,Vsuiv]|Reste_Couples]) :-
	loop_negamax(J,P,Pmax,Succ,Reste_Couples),
	adversaire(J,A),
	Pnew is P+1,
	negamax(A,Suiv,Pnew,Pmax, [_,Vsuiv]).
```

_Figure 5 - Prédicat loopnegamax_

Dans un premier temps, on rappelle loop_negamax avec le reste de la liste des couples. Comme on se place du point de vue du joueur, la situation suivante (S2) sera celle du point de vue de l’adversaire (ici A) et sera de profondeur P+1.

Ensuite, on applique negamax à la situation suivante (S2). Comme negamax nous renvoie le meilleur couple (Coup,Valeur) pour chaque situation et qu’on chercher à minimiser l’avantage de l’adversaire sur sa situation alors on veut juste récupérer la valeur (Vsuiv) associé à la situation de l’adversaire par rapport à notre situation.
