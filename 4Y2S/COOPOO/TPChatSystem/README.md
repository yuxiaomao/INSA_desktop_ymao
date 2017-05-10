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

Dans un commit, j'ai implémenté "envoyer HELLO_NOT_OK si username de userRemote est dans ma liste". Mais ceci n'est pas dans le protocole.

# Notes Personnelles

### Amélioration?
- Design pattern Singleton:
Si on ne veut pas plusieurs models apparaître.
Mais certains logiciels permettent d'avoir plusieurs user connectés et ne s'influensent pas (Tencent QQ Desktop).
De toutes façon notre logiciel ne support qu'un seul user connecté, donc un singleton est une amélioration possible.

### MsgFile: détection extension?
Pendant un moment Rama veut deviner l'extension du fichier reçu à l'aide de certains méthodes, mais ceci n'est toujours pas réussi.
Il semble que File toByteArray n'ajoute pas le nom du fichier.
- Solution possible: Au moment d'envoi, envoyé le nom du fichier par un MsgTxt(ou autre) séparé pour indiquer le nom du fichier.

### jUnit: Visibilité?
Les tests jUnit ne sont pas dans le même package que Controller.
Plusieurs méthodes passe de private à public, et il apparaît des méthodes "illégales" spécialement pour tester.
Ceci agrandir l'interface et je le trouve dangereux.
Mais je n'ai pas trouvé d'autres solutions pour ça.

### jUnit: Test partagé?
Au début nous voudrons faire les tests ensemble, c'est à dire ceux qui ont le même protocole (dans le même groupe de TP) peuvent s'échange des jUnit tests. Mais finalement on n'a pas réussi.
Nous avons essayé de rendre jUnitTest/ControllerAdapter générale.
Au final moi et Rama nous avons le même fichier Test et l'implémentation de Adapter spécialisé à son propre code.
Comme la conception est le même, la division controller/model et le lancement(création de principale controller après avoir cliqué Login) se ressemble beaucoup, nous ne savons pas si c'est adaptable aux autres groupes.

### jUnit: Test network?
Les tests sur la partie network ne sont pas réellement par network.
Par exemple, il y a un eventlistener dans UDPReceiver, à chaque fois reçoit d'un packet message, il va appeler une méthode de Controller.
Pour simuler les reçoits, nous n'avons pas envoyé les packets sur réseau mais nous avons appelé directement cette méthode avec un Message pré-construit.
Idem pour send, nous n'avons pas écouté sur le réseau, mais nous avons appelé une méthode qui permet de récupère le dernier packet envoyé.
- Amélioration: Design pattern Mock?
