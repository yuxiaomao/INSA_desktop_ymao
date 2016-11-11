-- MJ. Huguet (Mise à jour janvier 2015)
-- P. ESQUIROL - D. VIAL
-- VERSION MISE A JOUR 01/02/2013

--fichier piles_entiers.adb

with Unchecked_Deallocation, Ada.Integer_Text_Io;
use Ada.Integer_Text_Io;

package body Pile_Entiers is

   --desallocation d'une cellule
   procedure Free is new Unchecked_Deallocation(Cellule, Liste);

	------------------------------------------------------------------------------
	-- 1 : Coder les primitives : 
	--      Est_Vide
	--      Hauteur
	--      Pile_To_String
	--      Sommet
	--  Exécuter ensuite les tests fournis (Tests 1 et 2 du programme de tests)
   --complexite Est_vide = O(1)
   function Est_Vide(P : in Une_Pile_Entiers) return Boolean is
   begin
      if P.Debut=null then
	 return true;      
      else
	 return False;
      end if;
   end Est_Vide;
   
   --complexite Hauteur = O(1)
   function Hauteur(P : in Une_Pile_Entiers) return Natural is
   begin
      return P.Hauteur;
   end Hauteur;

   -- Conseil : ecrire une fonction de conversion d'une liste en chaine de caractères
   --   function Liste_To_String(L : in Liste) return String 
   --complexite Liste_To_String= O(n)
   function Liste_To_String(L : in Liste) return String is
   begin
      if L/=null then
	 return Integer'Image(L.all.Info)&Liste_To_String(L.all.Suiv);
      else
	 return "";   
      end if;
   end Liste_To_String;
   
   
   -- Utiliser cette fonction dans Pile_To_String
   --complexite Pile_To_String= O(n)
   function Pile_To_String(P : in Une_Pile_Entiers) return String is
   begin
      return Integer'Image(P.Hauteur)&";"&Liste_To_String(P.Debut) ;
   end Pile_To_String;
   
   --complexite Sommet= O(1)
   function Sommet(P : in Une_Pile_Entiers) return Integer is
   begin
      if P.Debut=null then
	 raise Pile_Vide;
      else 
	 return P.Debut.all.Info;
      end if;
   end Sommet;
   ------------------------------------------------------------------------------

	------------------------------------------------------------------------------
	-- 2 : Coder la primitive : 
	--      Empiler
	--  Développer ensuite les tests dans le programme de tests (Tests 3)
        --complexite Empiler= O(1)
	procedure Empiler(E : in Integer; P : in out Une_Pile_Entiers) is
	begin
	   P.Debut:=new Cellule'(E,P.Debut);
	   P.Hauteur:=P.Hauteur+1;
	end Empiler;
	------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------
    -- 3 : Coder la primitive : 		
	--      Depiler
	--  Développer ensuite les tests dans le programme de tests (Tests 4 et 5)
	--complexite Depiler= O(1)
	procedure Depiler(P: in out Une_Pile_Entiers) is
	   Supr:Liste;
	begin
	   if P.Debut=null then
	      raise Pile_Vide;
	   else
	      Supr:=P.Debut;
	      P.Debut:=P.Debut.all.Suiv;
	      P.Hauteur:=P.Hauteur-1;
	      Free(Supr);
	   end if;
	end Depiler;
	------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------
   	-- 4 : Tester (Test 6 du programme de test) et Corriger la primitive : 
	--      =
	--  
	--complexite Depiler= O(n)
	--au pire des cas..
	function "="(P1, P2 : Une_Pile_Entiers) return Boolean is
	begin
	   --pile-to-string demande de parcourir toute la liste
	   --complexite trop grand
	   
	   if P1.Debut=null and P2.Debut=null then
	      return True;
	   elsif P1.Hauteur /= P2.Hauteur then
	      return False;
	   --si on n'a pas meme hauteur, on tombe jamais dans ce situation
	   --elsif P1.Debut=null or P2.Debut=null then
	      --return False;
	   else
	      return (P1.Debut.all.Suiv,P1.Hauteur-1) = (P2.Debut.all.Suiv,P2.Hauteur-1);
	   end if;
	end "=";
	------------------------------------------------------------------------------
	
	
	procedure Vider(P:in out Une_Pile_Entiers) is
	begin
	   while not Est_Vide(P) loop
	      Depiler(P);
	   end loop;
	end Vider;
	
	
   
end Pile_Entiers;



