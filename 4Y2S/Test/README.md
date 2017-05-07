# Test
Classé par temps croissant.

## Tirage au sort
- date: 20170504
- keyword: php
- objective:
  - Tirer une élément aléatoirement selon un sondage, avec proba(X)=nbr(X)/nbr(Total)
  - Tirer plusieurs fois avec ce principe et obtenir une suite de marque, sans tirer plusieurs fois le même élement
- code: [`201705tirage.php`](./201705tirage.php)
  - préfère FOR que de WHILE

## Affichage list d'applications
- date: 20170507
- keyword: Android Studio, SQLite, SQL, Java, Xml
- objective:
  - Créer une base de données SQLite pour gérer les applications
  - Pouvoir choisir entre 2 type GAME et OTHER, aller faire requête SQL pour récuperer des applications du type choisi
  - Afficher le résultat
- code: [`201705AndroidList/`](./201705AndroidList)
  - 2 Activités principales: Main page, List page
  - La liste est gérer par ListView + CursorLoader, donc update automatique (pas encore testé)
- Remarques:
  - Il faut un SQLiteOpenHelper pour créer et garder la base de donnée, une fois créer, à n'import où tu as l'accès à ce même base (singleton?)
  - Pour Loader, il faut définir son URI, donc cela amène à extends ContentProvider qui est en fait l'interface entre activité et base, et définir un UriMatcher dedans
- Axe d'amélioration:
  - Layout plus joli
  - Changer les noms pour être plus explicite (myfirstapp est vraiment trivial)
