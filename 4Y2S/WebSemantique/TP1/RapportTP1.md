# Compte rendu du TP1

# Peuplement de l'ébauche d'ontologie du I

Nous avons remarqué dans cette partie que le raisonneur est capable de déduire les types des individus simplement en analysant les propriétés des objets.

Par exemple, Berenice Bejo a été lié par la relation 'joue dans' au film 'The Artist'.
Hermit peut donc inférer de cette relation que Bernice Bejo est de type 'artiste' puisque ce sont des 'artiste' qui 'joue dans' un 'film'.

Puisque le relation 'a été réalisateur de' n'existe pas, nous avons utilisé la relation 'réalisé par' pour lier The Artist et Michel Hazanavicius.

# Peuplement de l'ébauche d'ontologie du II

Après avoir rajouté les différentes contraintes et individus, on se rend compte que deux règles entrent en collisions. Le fait qu'une ville ne puisse pas être un pays et que le fait que Monaco soit une ville et un pays.

Les solutions possibles pour pallier ce problème sont :
- Créer deux individus Monaco dont l'un est une ville et l'autre un pays.
- Créer un état intermédiaire (ville_principauté) qui est l'intermédiaire entre une ville et un pays.

## Où est situé Paris ?
Le raisonneur a réussi à déduire que Paris se situe dans la France puisque Paris est la capitale de la France.

## Où s'est déroulé Midnight in Paris ?

Puisque Midnight in Paris se déroule à Paris alors il se déroule dans 'La ville lumière', en France et donc en Europe.

## Ce que le raisonneur sait sur Paris.

En plus de la question 1, il est en mesure de déduire que Paris est équivalent à la 'Ville lumière' et qu'il est situé en Europe puisque la France est situé en Europe.

## Ce que le raisonneur sait sur The Artist.

Le raisonneur a déduit que The Artist est un long_métrage de par sa durée de 100 minutes.

## Ce que le raisonneur sait sur les acteurs de The Artist.

Comme Jean Dujardin et Bérénice Bejo joue dans The Artist tous les deux, le raisonneur sait que les deux acteurs 'joue ensemble' dans 'The Artist'.

Normalement, on aurait dû rajouter le caractère irreflexif de la relation joue ensemble pour éviter qu'un acteur ne joue ensemble avec lui-même.
