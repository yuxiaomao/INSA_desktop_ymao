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

## Saisi formulaire html vers une base de données SQL
- date: 20170510
- keyword: NodeJS(express, ejs), SQL, XAMPP(MariaDB, PhpMyAdmin)
- objective:
  - Créer un formulaire html, qui permet utilisateur saisir 2 valeur integer
  - Ces deux valeurs sont envoyé à la base de données, leur somme et l'heure' d'enregistrement est aussi sauvegardé
  - Afficher une ligne qui dit l'insertion a réussi, et aussi le condenu de la base après insertion
- code [`201705ServeurSQL/`](./201705ServeurSQL)
  - dependencies: express, ejs, mariasql, body-parser
    - install: `npm init`, `npm install [nom-du-package] --save`
  - Serveur express écoute sur le port 8080 du localhost
    - au `/`, serveur affiche simplement le tableau
    - suite à la demande post du formulaire, au `/action_form`, serveur insert une ligne dans la base, et récupère le nouveau base pour affichier
  - MariaDB
    - Après trourné XAMPP, dans `localhost/phpmyadmin`, j'ai créé une base `mytest`, dedans, j'ai ajouté une table `INFORMATION`
    - Cette table contitent 5 colonne: `_id`primary key autoincrement, `int_a`, `int_b`, `int_s`, `save_time` default timestamp
- Remarques:
  - MySQL refuse de s'installer sur un ordi qui a déjà MariaDB
  - XAMPP a écris "MySQL" mais en fait il est passé en MariaDB
