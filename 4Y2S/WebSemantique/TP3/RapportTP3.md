# Rapport Travaux Pratiques Web Sémantique TP3
**(Ce rapport, initialement en pdf, transformé en Markdown donc des images sont simplifiés)**

A l’attention de Mme. Cassia Trojahn et Mme. Hernandez,

par Rama DESPLATS et Yuxiao MAO

Année 2016/2017 - 4ème année IR

# Sommaire
- [Première partie](#première-partie)
- [Deuxième partie](#deuxième-partie)

# Première partie
La première partie de ce TP consistait, à l’instar du Cluedo, à trouver le
responsable du meurtre dans la maison du crime. Seulement, il ne fallait pas faire preuve
de déduction mais de réfléchir à des requêtes SPARQL.

Nous mettrons pour chaque question, la requête correspondante et le résultat
trouvé. Par soucis de visibilité, nous omettrons la définition des PREFIX.

## 1 - Combien y a-t-il de pièces dans la maison?
```text
SELECT (COUNT(?pieces) AS ?nbpieces) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
}
```
Réponse : 9 pièces.

## 2 - Combien y a-t-il de personnes dans la maison?
```text
SELECT (COUNT(?personnes) AS ?nbpersonnes) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?personnes.
}
```
Réponse : 10 personnes.

## 3 - Qui est la victime?
```text
SELECT ?personne ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?personne.
    ?personne :estVivant False.
    ?personne rdfs:label ?label
}
```
Réponse : Patt Chance.

## 4 - Toutes les personnes encore en vie sont considérées suspectes. Donnez la liste des suspects.
```text
SELECT ?suspect ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?suspect.
    ?suspect :estVivant True.
    ?suspect rdfs:label ?label
}
```
Réponses :
Armand Chabalet,
Lucy Nuzyte,
Aubin Gladèche,
Vanessa Lami,
Gladis Tileri,
Emma Niolia,
Guy Tarsaich,
Paul Ochon,
Sophie Stulle.

## 5 - Dans quelle pièce se situe la victime
```text
SELECT ?piece ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientPersonne ?victime.
    ?victime :estVivant False.
    ?piece rdfs:label ?label
}
```
Réponse : Chambre.

## 6 - Y a-t-il d'autres personnes dans cette pièce? (transformez la requête précédente; utilisez ASK)
```text
ASK
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientPersonne ?victime.
    ?victime :estVivant False.
    ?piece :pieceContientPersonne ?personnes.
    FILTER(?personnes != ?victime)
}
```
Réponse : Non (False).

## 7 - Listez les personnes dans chaque pièce
```text
SELECT ?pieces ?personne ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?personne.
    ?personne rdfs:label ?label
}
```
Réponse :
- Salon :
Armand Chabalet
Luci Nuzyte
- Bureau :
Aubin Gladèche
Vanessa Lami
- Chambre :
Patt Chance
- Salle de bain :
Gladis Tileri
- Toilette :
Emma Niolia
- Salle à manger :
Guy Tarsaich
Paul Ochon
- Hall :
Sophie Stulle

## 8 - Combien y a-t-il de personnes dans chaque pièce (contenant au moins une personne)?
```text
SELECT ?label (COUNT(?personne) AS ?nbpersonne) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?personne.
    ?pieces rdfs:label ?label
}
GROUP BY ?label
```
Réponse :
- Salon :
2 personnes
- Bureau :
2 personnes
- Chambre :
1 personne
- Salle de bain :
1 personne
- Toilette :
1 personne
- Salle à manger :
2 personnes
- Hall :
1 personne

## 9 - Quelle(s) pièce(s) contien-nen-t au moins deux personnes?
```text
SELECT ?label (COUNT(?personne) as ?nbpersonne) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?personne.
    ?pieces rdfs:label ?label.
}
GROUP BY ?label
HAVING (COUNT(?personne) > 1)
```
Réponse : Salle à manger, Salon et Bureau.

## 10 - Quelle(s) pièce(s) est/sont vide(s)?
```text
SELECT ?label (COUNT(?personne) as ?nbpersonne) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    NOT EXISTS{?pieces :pieceContientPersonne ?personne}.
    ?pieces rdfs:label ?label.
}
GROUP BY ?label
```
Réponse : Couloir et Cuisine.

## 11 - On déchiffre cependant que son nom de famille ou son prénom finit par ‘e.' Quels sont les suspects restants? (augmentez la requête listant les suspects)
```text
SELECT ?suspect ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?pieces.
    ?pieces :pieceContientPersonne ?suspect.
    ?suspect :estVivant True.
    ?suspect rdfs:label ?label.
    FILTER(regex(?label,"(e )|e$","i"))
}
```
Réponse : Luci Nuzyte, Aubin Gladèche et Sophie Stulle.

## 12 - Le meurtrier n'est pas dans une des pièces voisines à celle où se situe la victime. Qui est par conséquent innocent?
```text
SELECT ?suspect ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientPersonne ?suspect.
    ?suspect :estVivant True.
    ?suspect rdfs:label ?label.
    FILTER(regex(?label,"(e )|e$","i")).
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece_victime.
    ?piece_victime :pieceContientPersonne ?victime.
    ?victime :estVivant False.
    ?piece_victime :aPourPieceVoisine ?piece
}
```
Réponse : Aubin Gladèche.

## 13 - Quels sont les suspects restants? (augmentez la requête listant les suspects)
```text
SELECT ?suspect ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientPersonne ?suspect.
    ?suspect :estVivant True.
    ?suspect rdfs:label ?label.
    FILTER(regex(?label,"(e )|e$","i")).
    NOT EXISTS{<http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece_victime.
        ?piece_victime :pieceContientPersonne ?victime.
        ?victime :estVivant False.
        ?piece_victime :aPourPieceVoisine ?piece}
}
```
Réponse : Luci Nuzyte et Sophie Stulle.

## 14 - Un certain nombre d'objets suspects ont été identifiés dans la maison. L'un d'entre eux est l'arme du crime.Combien y a-t-il d'objets dans la maison?
```text
SELECT (COUNT(?objets) AS ?nbobjets) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientObjet ?objets.
}
```
Réponse : 10 objets.

## 15 - L'arme du crime ne se trouve pas dans la pièce où se situe la victime. Quels objets ne peuvent pas être l'arme du crime?
```text
SELECT ?labels WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientObjet ?objets.
    ?objets rdfs:label ?labels.
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece_victime.
    ?piece_victime :pieceContientPersonne ?victime.
    ?victime :estVivant False.
    ?piece_victime :pieceContientObjet ?objets
}
```
Réponse : L’oreiller et le poignard.

## 16 - Personne ne se situe dans une pièce où a été posée l'arme du crime. Quel objet est l'arme du crime?
```text
SELECT ?labels (COUNT(?personne) as ?nbpersonne) WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientObjet ?objets.
    ?objets rdfs:label ?labels.
    NOT EXISTS{<http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece_victime.
        ?piece_victime :pieceContientPersonne ?victime.
        ?victime :estVivant False.
        ?piece_victime :pieceContientObjet ?objets.}
    NOT EXISTS{?piece :pieceContientPersonne ?personne}.
}
GROUP BY ?labels
```
Réponse : Le pic à glace.

## 17 - Le meurtrier se situe dans une pièce sans objet. Qui est le meurtrier? (augmentez la requête listant les suspects)
```text
SELECT ?suspect ?label WHERE
{
    <http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece.
    ?piece :pieceContientPersonne ?suspect.
    ?suspect :estVivant True.
    ?suspect rdfs:label ?label.
    FILTER(regex(?label,"(e )|e$","i")).
    NOT EXISTS{<http://www.lamaisondumeurtre.fr/instances#LaMaisonDuMeurtre> :maisonContientPiece ?piece_victime.
        ?piece_victime :pieceContientPersonne ?victime.
        ?victime :estVivant False.
        ?piece_victime :aPourPieceVoisine ?piece.}
    NOT EXISTS{?piece :pieceContientObjet ?objets}.
}
```
Réponse : Sophie Stulle.

## Conclusion
En conlusion, Patt Chance est mort dans la chambre et c’est Sophie Stulle qui l’a tué avec un pic à glace.

# Deuxième partie
La deuxième partie de ce TP consistait à prendre en main les requêtes SPARQL avec une base de connaissances réelles.

## Quel est l'URI de "Minuit à Paris"?
```text
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX res: <http://dbpedia.org/resource/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT ?film WHERE
{
    ?film rdfs:label "Minuit à Paris"@fr.
}
```
Réponse : http://dbpedia.org/page/Midnight_in_Paris

## Quels sont les autres labels définis pour "Minuit à Paris” ?
```text
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX res: <http://dbpedia.org/resource/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT ?film ?labels WHERE
{
    ?film rdfs:label "Minuit à Paris"@fr.
    ?film rdfs:label ?labels
}
```

## Quel est le type de "Minuit à Paris” ?
```text
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX res: <http://dbpedia.org/resource/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT ?film ?type WHERE
{
    ?film rdfs:label "Minuit à Paris"@fr.
    ?film a ?type
}
```

## Afficher l'ensemble des triplets concernant "Minuit à Paris"
```text
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX res: <http://dbpedia.org/resource/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
DESCRIBE ?film
WHERE
{
    ?film rdfs:label "Minuit à Paris"@fr.
}
```

## Quels-les sont les acteurs-trices de "Minuit à Paris” ?
```text
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX res: <http://dbpedia.org/resource/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT ?film ?acteurs WHERE
{
    ?film rdfs:label "Minuit à Paris"@fr.
    ?film dbo:starring ?acteurs
}
