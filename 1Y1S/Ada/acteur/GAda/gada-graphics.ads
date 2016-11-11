package GAda.Graphics is

   --
   -- Attention, l'axe des Y est vers le haut.
   --


   -- Trace un point noir aux coordonn�es X,Y
   procedure BlackPoint(X, Y : Integer) ;

   -- Redimensionne la fen�tre graphique, et efface l'image courante.
   -- Largeur et hauteur sont en pixels (points)
   procedure Resize(Largeur : Integer ; Hauteur : Integer) ;


   -- Une couleur est caract�ris�e par trois composantes
   -- rouge, vert, bleu, dont la valeur va de 0 (pas de couleur) � 255 (couleur vive).
   -- Une couleur est donc un triplet de trois entiers entre 0 et 255.
   --
   -- Par exemple, le blanc correspond � (255,255,255), le rouge � (255,0,0)
   -- et le violet � (255,0,255) car c'est un m�lange de rouge et de bleu.
   --
   type T_Couleur is record
      Rouge : Integer range 0..255 ;
      Vert  : Integer range 0..255 ;
      Bleu  : Integer range 0..255 ;
   end record ;


   -- Trace un point de la couleur indiqu�e
   procedure ColorPoint(X, Y : Integer ; Coul : T_Couleur) ;

   -- Trace une ligne entres les points (X1,Y1) et (X2,Y2)
   procedure ColorLine(X1, Y1, X2, Y2 : Integer ; Coul : T_Couleur) ;

   -- Idem, mais la ligne est noire
   procedure BlackLine(X1, Y1, X2, Y2 : Integer) ;

   -- Trace un cercle (vide) ou un disque (plein) centr� en (X, Y) et du rayon indiqu�.
   procedure Cercle(X, Y, Rayon : Integer ; Coul : T_Couleur) ;
   procedure Disque(X, Y, Rayon : Integer ; Coul : T_Couleur) ;

   -- Trace un rectangle color�
   procedure ColorRectangle(X, Y, Largeur, Hauteur : Integer ; Coul : T_Couleur) ;


   -- Met (Flag => true) ou enl�ve (Flag => false) la marge grise.
   procedure Avec_Marge(Flag : Boolean) ;

   --
   -- Ignorez cette partie
   -- qui sert � optimiser la m�moire
   --
   for T_Couleur use record
      Rouge  at 0 range 0..7;
      Vert   at 0 range 8..15;
      Bleu   at 0 range 16..23;
   end record;

end GAda.Graphics ;
