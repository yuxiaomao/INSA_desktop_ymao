package INSA_Air is

   -- Permet de donner un nom � l'avion
   procedure Donner_Nom_Compagnie (Nom : String) ;


   -- Cette fonction renvoie le cap actuel de l'avion, en degr�s,
   -- entre 0 et 360
   function Cap_Courant return Float ;


   -- Cette action contr�le les quatre r�acteurs Rolls-Royce Trent 500
   -- La force peut aller de 0 (r�acteur �teint) � 10
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
   -- Pour un contr�le plus fin de la gouverne :
   --
   -- A N'UTILISER QUE SI VOUS AVEZ DEJA UNE SOLUTION QUI MARCHE EN UTILISANT
   -- LES PROCEDURES GOUVERNE_A_GAUCHE et GOUVERNE_A_DROITE
   --
   --
   -- Commande la gouverne de l'avion (en vol)
   -- A 0 degr�s, l'avion reste en ligne droite.
   -- A +25 degr�s, l'avion tourne � droite
   -- A -25 degr�s, l'avion tourne � gauche.
   Gouverne_Max : constant Float := 25.0 ;

   procedure Incliner_Gouverne (Angle : Float) ;

   -- Attend le nombre de secondes indiqu�
   procedure Attendre (Sec : Float) ;


end INSA_Air ;
