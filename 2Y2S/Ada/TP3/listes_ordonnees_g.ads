generic
   type Element is private;
   with function "="(E1,E2:Element) return Boolean;
   with function "<"(E1,E2:Element) return Boolean;
   with function Element_To_String(E:in Element) return String;
   with procedure Liberer_Element(E:in out Element);
   
package Listes_Ordonnees_G is

   type Une_Liste_Ordonnee is limited private;

   Element_Non_Present, Element_Deja_Present : exception;
   
   function Est_Vide(L : in Une_Liste_Ordonnee) return Boolean;

   function Cardinal(L : in Une_Liste_Ordonnee) return Integer;

   function Appartient(E : in Element; L : in Une_Liste_Ordonnee) return Boolean;

   procedure Inserer(E: in Element; L: in out Une_Liste_Ordonnee);

   procedure Supprimer(E: in Element; L: in out Une_Liste_Ordonnee);
   
   --il n'y a que liste_to_string connait ce function.. mais pas lien_to_string
   --generic
      --with function Element_To_String(E:in Element) return String;
   function Liste_To_String(L: in Une_Liste_Ordonnee) return String;
   
   --copier L1 to L2
   procedure Copier(L1:in Une_Liste_Ordonnee;
		    L2:out Une_Liste_Ordonnee);
   
   function "="(L1,L2:in Une_Liste_Ordonnee) return Boolean; 

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
end Listes_Ordonnees_g;
