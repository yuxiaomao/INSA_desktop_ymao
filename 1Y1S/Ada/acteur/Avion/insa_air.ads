package INSA_Air is

   -- Permet de donner un nom à l'avion
   procedure Donner_Nom_Compagnie (Nom : String) ;


   -- Cette fonction renvoie le cap actuel de l'avion, en degrés,
   -- entre 0 et 360
   function Cap_Courant return Float ;


   -- Cette action contrôle les quatre réacteurs Rolls-Royce Trent 500
   -- La force peut aller de 0 (réacteur éteint) à 10
   -- Pour rouler sur le taxiway, utiliser une force de 1.
   procedure Regler_Reacteur (Force : Integer) ;



   --
   -- LES COMMANDES SUR LA GOUVERNE N'ONT AUCUN EFFET AU SOL.
   -- Pour faire tourner l'avion au sol, utiliser l'acteur Train.
   --

   -- Oriente la gouverne pour faire tourner l'avion :
   procedure Positionner_Gouverne_A_Droite ;
   procedure Positionner_Gouverne_A_Gauche ;
   procedure Positionner_Gouverne_A_Zero ;


   --
   -- Pour un contrôle plus fin de la gouverne :
   --
   -- A N'UTILISER QUE SI VOUS AVEZ DEJA UNE SOLUTION QUI MARCHE EN UTILISANT
   -- LES PROCEDURES GOUVERNE_A_GAUCHE et GOUVERNE_A_DROITE
   --
   --
   -- Commande la gouverne de l'avion (en vol)
   -- A 0 degrés, l'avion reste en ligne droite.
   -- A +25 degrés, l'avion tourne à droite
   -- A -25 degrés, l'avion tourne à gauche.
   Gouverne_Max : constant Float := 25.0 ;

   procedure Incliner_Gouverne (Angle : Float) ;

   -- Attend le nombre de secondes indiqué
   procedure Attendre (Sec : Float) ;


end INSA_Air ;
