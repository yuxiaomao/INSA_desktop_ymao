package Train is

   -- Oriente le train d'atterrissage à gauche, à droite, ou le positionne tout droit :
   procedure Positionner_A_Gauche ;
   procedure Positionner_A_Droite ;
   procedure Positionner_A_Zero ;

   -- Rentre ou sort les trains d'atterrissage
   -- Pour le SORTIR  : mettre Sens à TRUE
   -- Pour le RENTRER : mettre Sens à FALSE
   procedure Deplacer_Train (Sens : Boolean) ;





   --
   -- Pour un contrôle plus fin du train avant
   --
   -- A N'UTILISER QUE SI VOUS AVEZ DEJA UNE SOLUTION QUI MARCHE EN UTILISANT
   -- LES PROCEDURES A_GAUCHE et A_DROITE
   --
   -- Positionne le train d'atterrissage précisément selon l'orientation indiquée
   -- L'angle 0 signifie que le train est parfaitement droit
   -- Un angle positif fait tourner à droite
   -- Un angle négatif fait tourner à gauche
   -- L'angle doit être compris dans [-Course_Max ; +Course_Max] (défini ci-après)
   procedure Pivoter_Train_Avant (Angle : Float) ;

   -- Orientation maximale du train avant en degrés.
   Course_Max : constant Float := 45.0 ;


end Train ;
