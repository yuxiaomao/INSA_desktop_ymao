package Pilote_Automatique is

   -- Fait d�coller l'avion, � condition
   --   1 - d'�tre au d�but de la piste
   --   2 - d'avoir l'autorisation de d�collage
   --   3 - que les r�acteurs soient r�gl�s sur force 8
   --
   -- � la fin de la proc�dure, l'avion est � l'altitude de vol.
   procedure Decoller ;

   -- Fait atterrir l'avion, � condition
   --   1 - d'�tre en approche de l'a�roport de destination
   --   2 - d'avoir l'autorisation d'atterrissage
   --   3 - que les r�acteurs soient r�gl�s sur force 3
   --   4 - que le train d'atterrissage soit sorti
   --
   --   � la fin de la proc�dure, l'avion est arr�t� en fin de piste.
   procedure Atterrir ;


end Pilote_Automatique ;
