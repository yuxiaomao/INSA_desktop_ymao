package GAda.Graphics is

   --
   -- Attention, l'axe des Y est vers le haut.
   --


   -- Trace un point noir aux coordonnées X,Y
   procedure BlackPoint(X, Y : Integer) ;

   -- Redimensionne la fenêtre graphique, et efface l'image courante.
   -- Largeur et hauteur sont en pixels (points)
   procedure Resize(Largeur : Integer ; Hauteur : Integer) ;


   -- Une couleur est caractérisée par trois composantes
   -- rouge, vert, bleu, dont la valeur va de 0 (pas de couleur) à 255 (couleur vive).
   -- Une couleur est donc un triplet de trois entiers entre 0 et 255.
   --
   -- Par exemple, le blanc correspond à (255,255,255), le rouge à (255,0,0)
   -- et le violet à (255,0,255) car c'est un mélange de rouge et de bleu.
   --
   type T_Couleur is record
      Rouge : Integer range 0..255 ;
      Vert  : Integer range 0..255 ;
      Bleu  : Integer range 0..255 ;
   end record ;


   -- Trace un point de la couleur indiquée
   procedure ColorPoint(X, Y : Integer ; Coul : T_Couleur) ;

   -- Trace une ligne entres les points (X1,Y1) et (X2,Y2)
   procedure ColorLine(X1, Y1, X2, Y2 : Integer ; Coul : T_Couleur) ;

   -- Idem, mais la ligne est noire
   procedure BlackLine(X1, Y1, X2, Y2 : Integer) ;

   -- Trace un cercle (vide) ou un disque (plein) centré en (X, Y) et du rayon indiqué.
   procedure Cercle(X, Y, Rayon : Integer ; Coul : T_Couleur) ;
   procedure Disque(X, Y, Rayon : Integer ; Coul : T_Couleur) ;

   -- Trace un rectangle coloré
   procedure ColorRectangle(X, Y, Largeur, Hauteur : Integer ; Coul : T_Couleur) ;


   -- Met (Flag => true) ou enlève (Flag => false) la marge grise.
   procedure Avec_Marge(Flag : Boolean) ;

   --
   -- Ignorez cette partie
   -- qui sert à optimiser la mémoire
   --
   for T_Couleur use record
      Rouge  at 0 range 0..7;
      Vert   at 0 range 8..15;
      Bleu   at 0 range 16..23;
   end record;

end GAda.Graphics ;
