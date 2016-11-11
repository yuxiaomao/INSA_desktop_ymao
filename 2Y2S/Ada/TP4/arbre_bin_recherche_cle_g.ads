-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : specification paquetage arbre binaire de recherche generique
-- 
-- CONSIGNE
--      DONNER LES PARAMETRES DE GENERICITE
--      LIRE ET COMPRENDRE LA DECLARATION DES TYPES 
--          (    Arbre, LienArbre, Noeud)
-----------------------------------------------------------------------------
generic
   type Element is private;
   type Cle is private;
   with function Cle_De_E(E:in Element) return Cle ;
   with function "<"(C1,C2:in Cle) return Boolean;
   with function "="(C1,C2:in Cle) return Boolean;
   with procedure Liberer_Element(E:in out Element);
   with function E_To_String(E:in Element) return String;
	-- A FAIRE
	-----------
package Arbre_Bin_Recherche_Cle_G is
      Element_Deja_Present, Element_Non_Present, Arbre_Vide : exception;

      type Arbre is limited private;  -- A la declaration un arbre est initialise (arbre vide)

      procedure Liberer(A : in out Arbre);
      function Est_Vide(A : in Arbre) return Boolean;
      function Taille(A : in Arbre) return Natural;
      function Racine(A: in Arbre) return Element; -- peut lever l'exception Arbre_Vide
 
      function Appartient(E : in Element; A : in Arbre) return Boolean;
      function Cle_To_Element(C : in  Cle ; A : in Arbre) return Element;--cherche un element; peut lever l'exception element_non_present 
      
      -- Chaine correspondant a un parcours infixe (Gauche-Racine-Droite)
      function Arbre_To_String(A : in Arbre) return string;

      procedure Inserer(E: in Element; A: in out Arbre );    -- peut lever l'exception Element_Deja_Present
      procedure Supprimer(E : in Element; A : in out Arbre); -- peut lever l'exception Element_Non_Present

private
      type Noeud;

      type LienArbre is access Noeud;
      type Noeud is record
         Info : Element;
         Gauche : LienArbre;
         Droite : LienArbre;
      end record;
	  
      type Arbre is record
	 Debut : LienArbre := null;
	 Taille : natural := 0;
      end record;

end Arbre_Bin_Recherche_Cle_G;

