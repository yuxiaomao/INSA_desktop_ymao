package Pilote_Automatique is

   -- Fait décoller l'avion, à condition
   --   1 - d'être au début de la piste
   --   2 - d'avoir l'autorisation de décollage
   --   3 - que les réacteurs soient réglés sur force 8
   --
   -- À la fin de la procédure, l'avion est à l'altitude de vol.
   procedure Decoller ;

   -- Fait atterrir l'avion, à condition
   --   1 - d'être en approche de l'aéroport de destination
   --   2 - d'avoir l'autorisation d'atterrissage
   --   3 - que les réacteurs soient réglés sur force 3
   --   4 - que le train d'atterrissage soit sorti
   --
   --   À la fin de la procédure, l'avion est arrêté en fin de piste.
   procedure Atterrir ;


end Pilote_Automatique ;
