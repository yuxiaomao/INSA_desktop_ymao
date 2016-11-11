with GAda.Graphics ;
use  GAda.Graphics ;


package Tortue is

   Tortue_Dans_Hyperespace : exception ;

   procedure Ouvrir_Fenetre ;

   -- Positionne la tortue aux coordonnées indiquées
   procedure Aller_A (X, Y : Integer) ;

   -- L'origine est en bas à gauche
   function Largeur_Ecran return Integer ;
   function Hauteur_Ecran return Integer ;


   procedure Lever_Crayon ;
   procedure Baisser_Crayon ;

   procedure Avancer (Longueur : Float) ;
   procedure Reculer (Longueur : Float) ;


   -- Angle en degrés
   procedure Tourner_Gauche (Angle : Float) ;
   procedure Tourner_Droite (Angle : Float) ;

   -- Voir l'acteur GAda.Graphics pour la définition du type T_Couleur
   procedure Regler_Couleur (Coul : T_Couleur) ;

end Tortue ;
