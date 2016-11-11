package GAda.Text_IO is

   -- Affiche le message sans passer Ã  la ligne
   procedure Put (Aff : String) ;

   -- Affiche le message et passe Ã  la ligne
   procedure Put_Line (Aff : String) ;

   -- Passe Ã  la ligne
   procedure New_Line ;

   -- Lit et retourne une chaÃ®ne
   function FGet return String ;

   -- Lit une chaÃ®ne (version originale)
   procedure Get (Item : out String) ;

   -- Pour les caractÃ¨res
   procedure Put (Aff : in Character) ;
   procedure Put_Line (Aff : in Character) ;

   -- Prend une chaÃ®ne de caractÃ¨re X et renvoie une chaÃ®ne de caractÃ¨re
   -- de type String(1..N), oÃ¹ N est le second argument.
   -- Si X est trop petit, en ajoutant des espaces ;
   -- Si X est trop grand, en tronquant le texte.
   function Normalise (X : String ; N : Integer) return String ;

   -- Retourne au dÃ©but de la ligne courante et Ã©crit le message indiquÃ©.
   -- Utile pour afficher l'Ã©volution d'une variable.
   procedure Replace (Aff : in String) ;

end GAda.Text_IO ;

