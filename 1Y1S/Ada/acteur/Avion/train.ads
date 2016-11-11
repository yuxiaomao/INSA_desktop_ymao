package Train is

   -- Oriente le train d'atterrissage � gauche, � droite, ou le positionne tout droit :
   procedure Positionner_A_Gauche ;
   procedure Positionner_A_Droite ;
   procedure Positionner_A_Zero ;

   -- Rentre ou sort les trains d'atterrissage
   -- Pour le SORTIR  : mettre Sens � TRUE
   -- Pour le RENTRER : mettre Sens � FALSE
   procedure Deplacer_Train (Sens : Boolean) ;





   --
   -- Pour un contr�le plus fin du train avant
   --
   -- A N'UTILISER QUE SI VOUS AVEZ DEJA UNE SOLUTION QUI MARCHE EN UTILISANT
   -- LES PROCEDURES A_GAUCHE et A_DROITE
   --
   -- Positionne le train d'atterrissage pr�cis�ment selon l'orientation indiqu�e
   -- L'angle 0 signifie que le train est parfaitement droit
   -- Un angle positif fait tourner � droite
   -- Un angle n�gatif fait tourner � gauche
   -- L'angle doit �tre compris dans [-Course_Max ; +Course_Max] (d�fini ci-apr�s)
   procedure Pivoter_Train_Avant (Angle : Float) ;

   -- Orientation maximale du train avant en degr�s.
   Course_Max : constant Float := 45.0 ;


end Train ;
