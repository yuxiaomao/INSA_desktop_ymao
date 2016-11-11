package GAda.Text_IO is

   -- Affiche le message sans passer à la ligne
   procedure Put (Aff : String) ;

   -- Affiche le message et passe à la ligne
   procedure Put_Line (Aff : String) ;

   -- Passe à la ligne
   procedure New_Line ;

   -- Lit et retourne une chaîne
   function FGet return String ;

   -- Lit une chaîne (version originale)
   procedure Get (Item : out String) ;

   -- Pour les caractères
   procedure Put (Aff : in Character) ;
   procedure Put_Line (Aff : in Character) ;

   -- Prend une chaîne de caractère X et renvoie une chaîne de caractère
   -- de type String(1..N), où N est le second argument.
   -- Si X est trop petit, en ajoutant des espaces ;
   -- Si X est trop grand, en tronquant le texte.
   function Normalise (X : String ; N : Integer) return String ;

   -- Retourne au début de la ligne courante et écrit le message indiqué.
   -- Utile pour afficher l'évolution d'une variable.
   procedure Replace (Aff : in String) ;

end GAda.Text_IO ;

