package GAda.Text_IO is

   -- Affiche le message sans passer � la ligne
   procedure Put (Aff : String) ;

   -- Affiche le message et passe � la ligne
   procedure Put_Line (Aff : String) ;

   -- Passe � la ligne
   procedure New_Line ;

   -- Lit et retourne une cha�ne
   function FGet return String ;

   -- Lit une cha�ne (version originale)
   procedure Get (Item : out String) ;

   -- Pour les caract�res
   procedure Put (Aff : in Character) ;
   procedure Put_Line (Aff : in Character) ;

   -- Prend une cha�ne de caract�re X et renvoie une cha�ne de caract�re
   -- de type String(1..N), o� N est le second argument.
   -- Si X est trop petit, en ajoutant des espaces ;
   -- Si X est trop grand, en tronquant le texte.
   function Normalise (X : String ; N : Integer) return String ;

   -- Retourne au d�but de la ligne courante et �crit le message indiqu�.
   -- Utile pour afficher l'�volution d'une variable.
   procedure Replace (Aff : in String) ;

end GAda.Text_IO ;

