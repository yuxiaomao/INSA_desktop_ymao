# Rapport Travaux Pratiques Conception Orientée Objet
**(Ce rapport, initialement en pdf, transformé en Markdown, des images ne sont pas fournis)**

A l’attention de M. Slim Abdellatif,

par Rama DESPLATS et Yuxiao MAO

Année 2016/2017 - 4ème année IR

# Introduction
Dans ce rapport, nous nous efforcerons d’expliquer avec le plus de recul possible le processus de conception qui nous a conduit à réaliser les différents diagramme UML.

Ce rapport sera accompagné des diagrammes UML (contenus dans l’archive contenant aussi ce rapport) afin de conserver la qualité visuelle. En effet, les diagrammes étant de tailles conséquentes, il est impossible de tout montrer au vu de la taille réduite d’un document texte.

# Sommaire
- [Scénarios/StoryBoard](#scénariosstoryboard)
- [Diagrammes UML](#diagrammes-uml)
- [Conclusion](#conclusion)

# Scénarios/StoryBoard
Les scénarios ou les storyboards ont pour but de décrire plus en détail les cas d’utilisations que nous avons identifiés depuis le “System Requirements Specification” (SRS) et reproduit dans le diagramme de cas d’utilisation que nous présenterons dans la partie suivante. Ci-après, vous pourrez trouver les scénarios que nous avons écrit dans le cadre du projet ChatSystem.

## Connection
| Use Case ID | 1 |
| --- | --- |
| Name | connection |
| Actors | local user |
| Description | This use case describes the connection to the system of a local user
| Purpose/Overview | This use case is aimed at allowing the local user to connect to the system. The user press the connect button after providing a valid login or username. The system indicates to the user if the connection is successful or not. |
| Triggers | connect button |
| Preconditions | 1. a username has been provided 2. the user is not already connected (he is disconnected) |
| Post-conditions | the user is connected |
| Business rules |1. a valid username is an unique identifier for the user 2. when a user gets connected, all the other users already connected need to be informed about the arrival of the new user. A hello message containing the local user name is used. |
| Notes | several possibilities to provide an unique identifier exist: 1. the login is compared with the other users to check is valid 2. the login is automatically converted in a valid login by adding the unique host address |

Basic course of events:

| Local User | ChatSystem |
| --- | --- |
| provides username | |
| press connect button | |
| | sends hello messages to other users |
| | indicates that local user is connected |
| **Alternative path** | |
| | indicates that local user is not connected because the username is not valid or because he isn’t disconnected yet |


## Disconnection
| Use Case ID | 2 |
| --- | --- |
| Name | disconnection |
| Actors | local user |
| Description | This use case describes the disconnection to the system of a local user |
| Purpose/Overview | This use case is aimed at allowing the local user to disconnect of the system. The user press the disconnect button. The system asks if the user really want to disconnect and indicates to the user if the disconnection is successful or not. |
| Triggers | disconnect button |
| Preconditions | the user is not already disconnected (he is connected) |
| Post-conditions | the user is disconnected |
| Business rules | when a user gets disconnected, all the other users already connected need to be informed about the departure of the user. A goodbye message containing the local user name is used. |

Basic course of events:

| Local User | ChatSystem |
| --- | --- |
| press disconnect button | |
| | sends goodbye messages to other users |
| | indicates that local user is disconnected |
| **Alternative path** | |
| | indicates that local user is not disconnected because he isn’t connected yet

## Send
| Use Case ID | 3 |
| --- | --- |
| Name | send |
| Actors | local user, other user |
| Description | This use case describes how the local user send a message or a file to other user(s) |
| Purpose/Overview | This use case describes how the local user send a message or a file to other user(s). The user writes a message or uploads a file via the IHM, chooses one or a group of remote users, then clicks the send button. The message/file will be sent to the chosen user(s). |
| Triggers | send button |
| Preconditions | 1. local user have choose a remote user/group of user 2. the user is connected 3. the remote user/group of user are connected |
| Post-conditions | the message is sent |
| Business rules | A message can be a text message or a File |

Basic course of events:

| Local User | ChatSystem |
| --- | --- |
| write the text or choose a file | |
| choose remote user(s) | |
| press send button | |
| | send the text or the file to remote user(s) |
| | indicates that the message is sent |
| **Alternative path** | |
| | the send function failed |

## Receive
| Use Case ID | 4 |
| --- | --- |
| Name | receive
| Actors | local user, other user
| Description | This use case describes how the local user receive a message or a file to other user(s).
| Purpose/Overview | This use case describes how the local user receive a message or a file to other user(s). The system inform the user about the file received and the user who sent the message.
| Triggers | Reception of a message by the system
| Preconditions | The user is already connected
| Post-conditions | The message is displayed to the user
| Business rules | 1. a message can be a text message or a File 2. when an user receive a message, he needs to be informed about the message received.

Basic course of events:

| Local User | ChatSystem |
| --- | --- |
| | inform the user he received a message |
| | display the message received |

## RefreshConnectedList
| Use Case ID | 5 |
| --- | --- |
| Name | refreshConnectedList |
| Actors | Network, other user |
| Description | This use case describes how the network refresh the list of connected users. |
| Purpose/Overview | This use case describes how the network refresh the list of connected users. The system update visually if a new user has joined or if a connected user left the network. |
| Triggers | Reception of defined type of message by the system |
| Preconditions | The system is connected to the Internet |
| Post-conditions | The visual is refreshed considering the users who left and joined
| Business rules | The messages exchanged by the users to join or leave the system aren’t displayed to the user. |

Basic course of events:

| Local User | ChatSystem |
| --- | --- |
| Check if the connected users are stil connected | |
| | 1. remove users that aren’t connected anymore 2. add the users who joined the system |


# Diagrammes UML

## Diagramme de cas d’utilisation
Le diagramme de cas d’utilisation est le diagramme UML le plus représentatif des possibilités offertes à l’utilisateur par notre Chat System. Il est une retranscription de ce que nous avons compris du fichier de “System Requirements Specification” (SRS) et de l’identification que nous avons fait de différentes actions possibles pour l’utilisateur (et le network dans notre cas) comme, entre autres, communiquer, se connecter et se déconnecter.

Nous avons cependant chércher à aller plus loin en proposant une fonctionnalité supplémentaire qui est le produit de notre réflexion. Ainsi, nous proposons en plus une fonctionnalité de rafraîchissement de la liste des utilisateurs connectés. Cette fonctionnalité sera expliquée plus en détail dans son diagramme de séquence correspondant.

## Diagramme de classe
Dans cette partie, nous chercherons à expliquer l’architecture choisie pour réaliser ce projet. Nous avons choisi d’articuler le projet autour de l’architecture MVC(Modèle-Vue-Contrôleur) pour tirer profit des interactions entre les composants et l’utilisateur. Le modèle MVC offrant une séparation claire des responsabilités au sein d’une application et permettant à la partie Vue de contenir le moins possible de code gérant la dynamique de l’application.

Dans l’archive vous pourrez trouver, le diagramme de classe des acteurs et des différents signaux mais ce sont le diagramme de classe MVC et le diagramme de structure composite qui sont les plus représentatifs de nos choix résultant du processus de conception.

Respectant les principes de l’architecture MVC, nous avons choisi de créer un groupe entre la Vue, le Contrôleur et le Réseau. La majorité des signaux transitent à l’intérieur de ce groupe puisque l’utilisateur ne pourra, en fait, qu’interagir avec la partie graphique du projet : la Vue.

C’est dans ce diagramme qu’apparaissent le plus nos choix de conception tout en respectant (une fois de plus) les règles imposées par l’architecture MVC. Les messages étant envoyés sur le réseau, il nous a paru judicieux de créer une classe de message à partir de laquelle nous allons créer des instances de message.

Cela pour deux raisons principales :
- La première étant que les différents binômes de TP, avec leurs propres implémentations du projet, doivent être en mesure de recevoir les messages et les traiter.
- La deuxième étant que nous avons choisi d’envoyer un objet de type Message sur le réseau (à l’aide de la sérialisation) et de les différencier à la réception en testant son instance. C’est une solution qui nous a permis de gagner du temps et d’être plus simple que de préparer la stérilisation et l’envoi des six instances de la classe Message.

Le contrôleur gérant la dynamique de l’application et faisant le lien entre les différents composants du modèle MVC, nous avons fait le choix de conception de créer des instances du contrôleur, chacune dédiée aux fonctionnalités les plus importantes du projet.

Le modèle gérant principalement l’accès aux données, il contient les informations importantes du projet : les informations concernant l’utilisateur du chat (Contact) et la liste des Utilisateurs avec lesquels il peut communiquer. Plus en détail, nous avons choisi de représenter un utilisateur par un nom d’utilisateur et une adresse ip. L’adresse ip pour l’identifier sur le réseau pour l’envoi de message et le nom d’utilisateur pour l’identifier à l’intérieur de tout le système de chat. Par choix, nous avons instauré un caractère passif au modèle qui joue le rôle d’un endroit où les données sont stockées. Le modèle ne répond qu’aux requêtes du contrôleur ce qui le rend indépendant de l’implémentation du contrôleur et réutilisable par d’autres applications.

La vue n’étant qu’un affichage graphique avec lequel l’utilisateur va interagir, nous avons cherché à le simplifier au maximum vis à vis du reste du système de chat. C’est pourquoi la vue n’interagit pas directement avec le reste du système mais à l’aide de signaux et que les méthodes de la Vue ne sont que des méthodes permettant d’agir sur l’interface graphique visible à l’utilisateur.

## Diagramme d’états transition
Les diagrammes d’états transition représentent, à l’instar des graphes, le comportement d’un composant.
On peut voir sur ces diagrammes que nous avons créé trois états différents : Déconnecté, En connexion et Connecté. En effet, comme l’utilisateur ne peut pas accéder au système de chat s’il a choisi le même pseudonyme qu’un utilisateur déjà présent et que cette vérification n’est pas instantanée (dû au temps que mettent les messages à transiter sur le réseau), nous avons choisi de créer un état intermédiaire
de connexion.

C’est une phase, au temps défini, pendant laquelle l’utilisateur ne peut pas communiquer. Si après cette période de temps, il ne reçoit pas de message contradictoire, il est déclaré connecté dans le système de chat.

## Diagramme de séquence
Dans cette partie, nous expliquerons les raisons qui nous ont poussées à organiser d’une certaine façon les différentes fonctionnalités du ChatSystem.

### Fonctionnalité de Connexion
Nous avons choisi de mettre en place une phase de test préliminaire à toute action du système. En effet, nous avons prévu la conception du projet de façon à ce que l’utilisateur ne puisse accéder qu’aux fonctionnalités prévues en fonction de l’état dans lequel il se trouve (Déconnecté, Connecté ou en Connexion). Cependant, nous avons choisi de rajouter un niveau de sécurité afin d’éviter de potentiels conflits. On peut donc voir s’exécuter la fonction getState() après les actions de l’utilisateur sur la vue et avant les actions du contrôleur sur le reste des composants. Cela a pour but d’éviter à l’utilisateur la possibilité de se connecter s’il est déjà connecté (et inversement pour la déconnexion) ou la possibilité d’envoyer des messages alors que l’utilisateur est déconnecté.

On peut aussi retrouver dans ce diagramme la période de vérification du pseudonyme comme expliquée dans la partie des Diagrammes de transition. Le timer ici est fixé à 6min pour la conception mais nous avons prévu de faire des tests afin d’estimer une durée plus réaliste de vérification en fonction, entre autres, de la vitesse de transmission des messages sur le réseau et du nombre moyen d’utilisateurs sur le système. Ainsi, si l’utilisateur est effectivement dans l’état déconnecté, il est en droit de lancer le processus de connexion et de vérification qui dure le temps du timer (à la fin de celui-ci, la vue est mise à jour). Un processus de vérification qui consiste juste à recevoir des messages.

La méthode sendPacket correspond à la méthode d’envoi de messages sur le réseau. Cela n’apparaît pas sur les diagrammes mais nous avons privilégié l’envoi de packet UDP sur le réseau puisque l’environnement du système correspond à un réseau local avec un très faible taux de perte de paquet. L’envoi en UDP se fait donc avec une adresse ip source, une adresse ip destination et le message.

### Fonctionnalité d’envoi de message
Lors de la conception de notre fonctionnalité d’envoi, nous nous sommes posés la question de comment nous allions gérer l’envoi des messages qu’ils soient textuels ou accompagnés d’un fichier.

Comme expliqué précédemment dans le rapport, nous avons choisi de gérer l’envoi de message en UDP. Cela impose l’envoi de tableau de byte et la reconstitution de ces bytes en Message ou en File à la réception : nous avons donc associé la sérialisation à notre processus d’envoi. Dans la conception, nous avons dissocié l’envoi de messages ou de fichiers pour rester au plus proche de la réalité.

En effet, transformer une classe Message et un fichier présent sur le système d’exploitation en bytes ne se fait pas exactement de la même façon.

Pour éviter de surcharger le système, nous avons choisi de créer le message en récupérant les destinataires et le contenu directement à partir de la vue. Dans un souci graphique et pour montrer à l’utilisateur que le message s’est bien envoyé, nous vidons la zone de la Vue dans laquelle il a écrit son message.

### Fonctionnalité de réception
Pour les mêmes raisons qu’expliquées précédemment, nous avons choisi de séparer la réception d’un fichier ou d’un message textuel lors de la conception de la fonctionnalité de la réception. De plus, l’utilisateur est informé de la réception d’un message sur son interface graphique.

### Fonctionnalité de rafraîchissement de la liste d’utilisateurs connectés
Cette fonctionnalité résulte de notre conception et n’est pas présente dans le SRS. Après avoir réfléchi à l’environnement et tout ce qui pourrait venir perturber l’utilisation voulu du système, nous avons identifié un cas qui n’était pas explicite dans le SRS. Si par hasard, un utilisateur n’est plus connecté à son réseau Internet, il ne pourra pas notifier les autres utilisateurs de sa déconnexion via le système de Chat. Or, il ne devrait plus apparaitre dans la liste des utilisateurs connectés.

C’est pourquoi nous avons créé une fonctionnalité qui teste si les utilisateurs sont toujours connectés au système ou non. Une fonctionnalité qui fonctionne de façon totalement invisible à l’utilisateur. Le système de chat de chaque utilisateur envoie périodiquement un message de test auquel la réponse est automatique. Si on ne reçoit pas de réponse à ce message, on considère que l’utilisateur n’est plus actif.

Note: Le timer est fixé à 1s mais lors de la programmation du système, nous nous pencherons sur une durée d’activité plus réaliste quant à l’utilisation moyenne des utilisateurs.

### Schéma général
Le diagramme ci-dessous, est un diagramme général du système de Chat. De façon parallèle, s’exécutent les fonctions d’envoi, de réception et de rafraîchissement de la liste d’utilisateurs connectés.

Nous avons aussi choisi d’un point de vue conceptuel de dissocier la réception d’envoi de message (texte ou fichier) et ceux des messages de connexion/ déconnexion des autres utilisateurs. Cela afin de rapprocher l’envoi et la réception déclenchés par des actions de l’utilisateur (local pour l’envoie ou les utilisateurs distants avant la réception) et de rapprocher l’envoi de message de test (pour le rafraîchissement) et la réception de messages de connexion/déconnexion.

On peut donc voir rapidement que l’implémentation de ces deux groupes d’envoi/ réception sera à faire de façon différente.

### Fonctionnalité de déconnexion
La déconnexion est plus simple que le processus de connexion. Nous avons choisi de le rendre simple en envoyant une notification de déconnexion à toutes les personnes présente sur le réseau, même si ces personnes ne sont pas dans la liste d’amis. Cela est rendu possible par le fait que le système de chat ne prend pas en compte les messages dont l’adresse ip source ne font pas partie de la liste d’amis.

# Conclusion
En conclusion, on peut dire que le plus gros choix de conception que nous avons réalisé est lorsque nous avons décidé d’articuler le projet autour de l’architecture MVC avec un modèle passif et un contrôleur responsable des échanges inter-composants.

Nous avons ensuite décidé, au vue de l’environnement, choisi l’envoi de messages UDP sur le réseau afin d’implémenter la communication inter-utilisateurs.

En plus de ce que nous avons identifié dans le SRS, nous avons rajouté une protection en fonction de l’état de l’utilisateur et une fonctionnalité permettant de gérer les déconnexions d’utilisateurs ne suivant pas le protocole de déconnexion prévu.
