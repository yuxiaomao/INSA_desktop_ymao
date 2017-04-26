# TP ChatSystem
**keyword**: UML, Tau, Java, MVC, JUnit

**Description**: ChatSystem P2P, c'est à dire pas de serveur central. On doit pouvoir s'identifier et s'envoyer des message, savoir qui est connecté. Ce TP s'agit de la conception en UML avec le logiciel Tau(IBM), et puis réaliser avec Java. Le final but est de pouvoir s'envoyer des messages entre les membres de groupe de TP.

- `lib/message.jar` et `src/Contact` : partagé dans notre groupe de TP, afin de pouvoir communiquer ensemble. Réellement il n'y a que le Message.jar commune est obligatoire.
- `src/` : fichier source code, principalement codé par mon binôme Rama.
- `src_yuxiao/` : fichier source code, principalement codé par moi, avec une implémentation légèrement différente.

# Conception
[Rapport TP Conception Orientée Objet](./RapportCOO.md)

En gros, il y a:
- Use case: Déterminer les fonctionnalités qu'on veut réaliser et les entités externes.
- Sequence: Pour chaque fonctionnalité, ou chaque situation possible,
  - Boîte noire: spécifier les interactions entre le système et l'environnement(les acteurs)
  - Boîte blanche: découper le système, spécifier la communication entre les différents composants du système. Dans notre cas, on est basé sur la conception MVC, model view controller.
  - par la proposition de notre encadrant, les interactions avec réseau se font dans la class controller au lieu de model, le model reviens donc un simple model de données, qui ressemble un peu à une base de donnée.
- Class: S'appuie sur le diagramme de séquence, identifier les différents méthodes de class.
- Interface et Signal: Les signaux, des flèches asynchrones dans le diagramme de séquence, pour avoir plus de liberté. Concrètement dans Java, il s'agit des eventlistener.
- State Machine: On a identifié 3 états: Connected, Connecting, Disconnected. L'état actuelle est dans le model, certains signaux causent le changement d'états.

Protocole de communication déterminé par notre groupe de TP:
- Quand un user A connecte, il broadcast Message HELLO pour manifester sa présence dans le réseau.
- Pour user B qui reçoit HELLO, doivent vérifier si username de A est déjà utilisé par un autre utilisateur. Si B a le même username que A, alors envoit un HELLO_NOT_OK; sinon, répond HELLO_OK pour indiquer que tout se passe bien.
- Quand un user A disconnect, il broadcast Message Goodbye.
- Afin d'évider quelqu'un disconnect par perte de connection réseau, il y a un système de Check, les CHECK et sa réponse CHECK_OK permettent de garandir que l'user distant est toujours présent.
- Comme l'environnement de travail est un Ethernet, on a choisi d'établir la connection en UDP.

_La conception était difficile à comprendre et à manipuler, je la comprends un peu mieux lors du codage._

# src
**Main class**: gui/Window.java

Les sockets derrières ne se créent après le click sur "Login" de utilisateur afin d'économiser l'utilisation des ressources'.

# src_yuxiao
**Main class**: controller/Main.java

Ayant le même conception et interface graphique, j'ai un Controller divisé en 3 partie et un modèle légèrement différent.
- ControllerGui, le seul objet créer par Main.java, gérer la création d'un gui.Window et écoute des actions venant de gui.Window.
- Controller, créé par ControllerGui à chaque fois que l'user click sur le boutton "Login", elle va créer un objet ControllerNetwork et un Model.
- ControllerNetwork, géré les sockets pour communication, réponds automatiquement aux messages de gestion de la liste d'utilisateur, fournis des méthodes pour envoyer des messages.
- Model, mémoriser en plus les fichiers txt pour mémoriser l'historique de chat.
