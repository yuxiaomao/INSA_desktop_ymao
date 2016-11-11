--
-- Package Caracteres
--
-- Ce package fournit la reprÃ©sentation graphique des caractÃ¨res
-- sous la forme d'une trame de points (une matrice).
--
package Caracteres is

   -- Ignorez cette ligne.
   pragma Elaborate_Body ;


   -- Dans la trame de chaque caractÃ¨re, une case contient un pixel (un point)
   -- qui peut Ãªtre Ã©teint ou allumÃ©.
   type T_Pixel is (Eteint, Allume) ;

   -- Tous les caractÃ¨res ont la mÃªme taille (en pixels).
   Hauteur_Car : constant Integer := 13 ;
   Largeur_Car : constant Integer := 6 ;

   -- Une trame est une matrice de pixels (le dessin du caractÃ¨re).
   -- Voir un exemple Ã  la fin du fichier
   type T_Trame is array(Integer range <>, Integer range <>) of T_Pixel ;

   -- La table contient des paires (caractÃ¨re, trame) :
   --   un caractÃ¨re et sa trame
   type T_Paire is record
      Car   : Character ;
      Trame : T_Trame (1..Hauteur_Car, 1..Largeur_Car) ;
   end record ;

   --
   -- DÃ©finition de la table contenant les paires (caractÃ¨re, trame)
   --
   Nombre_De_Caracteres : constant Integer := 91 ;

   type T_Table is array (Integer range <>) of T_Paire ;

   -- Attention, le premier caractÃ¨re est un espace.
   Table : T_Table (1..Nombre_De_Caracteres) ;



   -- Initialise la table.
   procedure Init ;

end Caracteres ;

   --
   -- Exemple de trame : la trame du caractÃ¨re $
   --   (cette trame est plus petite que celles utilisÃ©es dans l'acteur)
   --
   -- Colonne   123456
   --
   -- Ligne 1     #
   -- Ligne 2    ####
   -- Ligne 3   # #
   -- Ligne 4   # #
   -- Ligne 5    ###
   -- Ligne 6     # #
   -- Ligne 7     # #
   -- Ligne 8   ####
   -- Ligne 9     #
   --
   --
   -- # ReprÃ©sente un pixel allumÃ©
   -- Un blanc reprÃ©sente un pixel Ã©teint.
   --

