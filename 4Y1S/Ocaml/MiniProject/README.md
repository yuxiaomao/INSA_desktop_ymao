# Mini Projet Ocaml

## 0.
- compiler avec : `ocamlbuild -use-ocamlfind gameplay.native`
- lancer master avec: `./gameplay.native master`
- lancer worker avec: `./gameplay.native`, en cas de changement de worker, il faut modifier gameplay.ml ligne 70
- jouer avec entrée clavier des entiers

## 1. Description des 3 fichiers

game : jeu de puissance 4 simplifié avec grille réduit à 4\*4 et une ligne de 3 gagne. Ceci est finalement représenté par une matrice(*gameplan*). Changer la taille de grille dans *initial*(ligne 41). Pour changer une ligne de x gagne, il faut modifié la fonction *resultlist4*(ligne 84).

game_ia : + hashtbl, + functory

gameplay : declare_worker + set_default_port_number

## 2. Performance

Avec hashtble et map reduit, les grilles de jeu de 4\*4 et 4\*5 sont possible et relativement rapide(de toute façon il va gagné dans 4\*4). Mais il n'est pas capable de faire plus que 4*5.

Si tout se passe bien alors il gagne. Mais:

## 3.Problème non résolu de broken pipe (AI avec map-réduit)

J'ai testé beaucoup de fois. 2 cas de figure quand il se passe mal. Mais je n'ai pas pu trouvé la raison.

Soit au lancement de best_move
```sh
could not send message ping to worker 1 (127.0.0.1:51020, idle)
(Unix_error (Broken pipe, "write", ""))
Fatal error: exception Unix.Unix_error(Unix.EPIPE, "write", "")
Raised at file "network.ml", line 536, characters 10-11
...
```

Soit au milieu du calcul, dans ce cas, il fourni des mauvais résultat et je peux gagné.
```sh
create_job: worker=1 (127.0.0.1:51020, idle), task=done=false, workers={}
could not send message assign 45 f=<length 263> a=<length 58>
to worker 1 (127.0.0.1:51020, idle) (Unix_error (Broken pipe, "write", ""))
create_job for worker 1 (127.0.0.1:51020, idle) failed:
Unix_error (Broken pipe, "write", "")create_job: worker=2 (127.0.0.1:51020,
idle),
task=done=false, workers={}
could not send message assign 46 f=<length 263> a=<length 58>
to worker 2 (127.0.0.1:51020, idle) (Unix_error (Broken pipe, "write", ""))
create_job for worker 2 (127.0.0.1:51020, idle) failed:
Unix_error (Broken pipe, "write", "")create_job: worker=3 (10.1.5.49:51020,
idle),
task=done=false, workers={}
```
