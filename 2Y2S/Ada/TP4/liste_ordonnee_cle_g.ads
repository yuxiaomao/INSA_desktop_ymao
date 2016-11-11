-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : specification liste ordonnee generique
-- 
-- Remarque : 
--  	les elements disposent d'une cle permettant de les identifier
-----------------------------------------------------------------------------
generic
   type Element is private;
   type Key is private;
   with function Cle_De(E : in Element) return Key;
   with function "<"(C1, C2 : in Key) return Boolean;
   with function "="(C1, C2 : in Key) return Boolean;
   with procedure Free_Element(E : in out Element);
   with function Element_To_String(E : in Element) return String;
   
package Liste_Ordonnee_Cle_G is
   type Une_Liste_Ordonnee is limited private; 

   Element_Non_Present, Element_Deja_Present : exception;

   function Est_Vide(L : in Une_Liste_Ordonnee) return Boolean;
   function Cardinal(L : in Une_Liste_Ordonnee) return Integer;
   function Appartient(E : in Element; L : in Une_Liste_Ordonnee) return Boolean;
   function Appartient(C : in Key; L : in Une_Liste_Ordonnee) return Boolean;
   procedure Inserer(E: in Element; L: in out Une_Liste_Ordonnee);
   procedure Supprimer(E: in Element; L: in out Une_Liste_Ordonnee);
   function Liste_To_String(L: in Une_Liste_Ordonnee) return String;
   
   function Rechercher_Par_Cle(C : in Key; L : Une_Liste_Ordonnee) return Element;
   
   generic
      with function Selection(E : in Element) return Boolean;
   procedure Filtrage(L : in Une_Liste_Ordonnee; SL : out Une_Liste_Ordonnee);
   
private
   -- types classiques permettant de realiser des listes simplement chainees
   type Cellule;
   type Lien    is access Cellule;
   type Cellule is record
        Info : Element;
        Suiv : Lien;
   end record;

   -- type liste ameliore : record contenant la liste et sa taille
   -- (evite de parcourir la liste pour calculer la taille)

   type Une_Liste_Ordonnee is record
      Debut  : Lien    := null;
      Taille : Natural := 0;
   end record;
end Liste_Ordonnee_Cle_G ;
