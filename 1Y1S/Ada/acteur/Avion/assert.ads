package Assert is

   --
   -- Cette action fait échouer tout le programme en affichant
   -- le message d'erreur si la condition est VRAIE.
   --
   -- Si la condition est fausse, il ne se passe rien.
   --
   procedure Failif (Cond : Boolean ; Message : String) ;

end Assert ;
