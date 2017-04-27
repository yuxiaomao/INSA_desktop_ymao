# Web sémantique
**keyword**: Ontology, Protégé, OMDB, popQue, SPARQL, MushUP

[Sujet TP1: Ebauche d'un ontologie pour des films](https://cloud.irit.fr/index.php/s/KzZyrjHRIQqEwWU/download)

[Sujet TP2: Peuplement d'ontologie automatique avec des bases de données](https://www.irit.fr/~Cassia.Trojahn/insa/TP2.pdf)

[Sujet TP3: SPARQL](http://swip.univ-tlse2.fr/tpsparql/) (
[Cours SPARQL](https://www.irit.fr/~Cassia.Trojahn/websem/sparql.pdf) )

[Sujet TP4: MushUP pour affichier des infos de films sur la carte française](https://cloud.irit.fr/index.php/s/1N5YPQvEl4uiAq6)

[Rapport TP1](./TP1/RapportTP1.md)

[Rapport TP3](./TP3/RapportTP3.md)

# Notes Personnels

## TP1 Ontologie
Créer des classes et des properties pour représenter des films.

Triplet, URI, Domaine, Range.

## TP2 Peuplement Ontologie
A partir base de données libéré par Paris et Montpellier et les sites où on peut faire des requêtes. Enrichir l'ontologie construite lors du TP 1.

Attention pour les csv:
- "," sont utilisés aussi dans le titre, le lieu, etc. Donc utiliser ";" (xsl -> csv, option separateur)
- Utiliser un split qui prend en compte les champs vide à la fin, comme: String[] split = s.split(";", -1);

lib (OMDB.zip):
- HermiT.jar
- owlapi-distribution-3.4.10.jar

Modification onto:
- changer tous les IRI, pour être identique à label et donc accessible facilement par script

## TP3 SPARQL
Ressemble à SQL.

## TP4 MashUP
Pour visualiser visu.html, il faut tourner serveur Fuseki et avoir le base de connaissance peuplé des films (BCVisuAll.ttl).
