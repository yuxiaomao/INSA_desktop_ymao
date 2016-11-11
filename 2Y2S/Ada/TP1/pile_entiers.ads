-- MJ. Huguet (Mise à jour janvier 2015)
-- P. ESQUIROL - D. VIAL
-- VERSION MISE A JOUR 01/02/2013

--fichier piles_entiers.ads

package Pile_Entiers is

   Pile_Vide : exception;

   type Une_Pile_Entiers is limited private;

   function Est_Vide(P : in Une_Pile_Entiers) return Boolean;   
   
   function Hauteur(P : in Une_Pile_Entiers) return Natural;
   
   function Pile_To_String(P : in Une_Pile_Entiers) return String;
   
   function Sommet(P : in Une_Pile_Entiers) return Integer;

   procedure Empiler(E : in Integer; P : in out Une_Pile_Entiers);

   procedure Depiler(P: in out Une_Pile_Entiers);
   
   procedure Vider(P:in out Une_Pile_Entiers);
   
   function "="(P1, P2 : Une_Pile_Entiers) return boolean;
   

private

   -- implementation de la pile d'entiers par une liste chainee d'entiers
   type Cellule;
   type Liste is access Cellule;

   type Cellule is record
      Info : Integer;
      Suiv : Liste;
   end record;

   -- declaration du type pile d'entiers (avec initialisation)
   type Une_Pile_Entiers is record
      Debut  : Liste := null;
      Hauteur: Natural := 0;
   end record;

end Pile_Entiers;



