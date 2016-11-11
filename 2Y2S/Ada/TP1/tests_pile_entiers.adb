-- MJ. Huguet - Janvier 2015
-- P. ESQUIROL - D. VIAL
-- VERSION MISE A JOUR 01/02/2013

--fichier tests_piles.adb

with Ada.Text_Io, Pile_Entiers, Afficher_Test;
use  Ada.Text_Io, Pile_Entiers;

procedure Tests_Pile_Entiers is

   
begin

	-----------------------------------------------------
	-- 1. Tests après la declaration et l'acces à une pile vide
	--   Nécessite les primitives : 
	--      Est_Vide
	--      Hauteur
	--      Pile_To_String
	--      Sommet
   declare
      P : Une_Pile_Entiers;
   begin
      Put_Line("Test 1 : apres Declaration d'une pile P");
      Afficher_Test("Est_Vide(P)  ?", "TRUE", Boolean'Image(Est_Vide(P)));
      Afficher_Test("Hauteur(P)   ?", " 0", Integer'Image(Hauteur(P)));
      Afficher_Test("To_String(P) ?", "()", Pile_To_String(P));
   end;
   
   New_Line;
   Put_Line("Test 2: Tentative d'acces au sommet d'une pile vide");
   declare
      P : Une_Pile_Entiers;
      Nb : Integer;
   begin
      Nb := Sommet(P);
      Afficher_Test("Sommet(P)  ?", "levee exception", Integer'Image(Nb));
      Put_Line("      bizarre ... si on est passe ici c'est que l'exception ne s'est pas levee ... ");
   exception      
       when Pile_Vide =>
	  Put_Line("      exception Pile_Vide levee !!");
   end;
      
	-----------------------------------------------------
	-- 2. Tests d'empiler
	--  Nécessite 
	--      Empiler
   	--      Est_Vide
	--      Hauteur
	--      Pile_To_String
   declare
      P : Une_Pile_Entiers;
   begin
      New_Line;
      Put_Line("Test 3 : Empiler 10 entiers ");
      for I in 1..10 loop
	 Empiler(I,P);
      end loop;
      Afficher_Test("Est_Vide(P)  ?", "FALSE", Boolean'Image(Est_Vide(P)));
      Afficher_Test("Hauteur(P)  ?", "10", Integer'Image(Hauteur(P)));
      Afficher_Test("To_String(P) ?", "10;10 9 8 7 6 5 4 3 2 1", Pile_To_String(P));
   end;
   
	-----------------------------------------------------
	-- 3. Tests de depiler et de sommet (et de depilement d'une pile vide)
	--   Nécessite :
	--      Depiler
	--      Sommet
	--   Mais aussi : 
	--      Empiler
   	--      Est_Vide
	--      Hauteur
	--      Pile_To_String
	--
   declare
      P : Une_Pile_Entiers;
     
   begin
      -- on commence par empiler 10 élements (empiler fonctionne)
      for I in 1..10 loop
	 Empiler(I,P);
      end loop;
      Afficher_Test("Est_Vide(P)  ?", "FALSE", Boolean'Image(Est_Vide(P)));
      Afficher_Test("Hauteur(P)  ?", "10", Integer'Image(Hauteur(P)));
      Afficher_Test("To_String(P) ?", "10;10 9 8 7 6 5 4 3 2 1", Pile_To_String(P));

     
      New_Line;
      Put_Line("Test 4: Affichage du sommet et depilement pendant 10 fois ...");
      for I in 1..10 loop
	 Afficher_Test("Sommet(P)  ?", Integer'Image(11-I), Integer'Image(Sommet(P)));
	 Depiler(P);
      end loop;
      
      -- VERIFIER QUE LA PILE EST BIEN VIDE APRES LES 10 APPELS A DEPILER
      Afficher_Test("Est_Vide(P)  ?", "TRUE", Boolean'Image(Est_Vide(P)));
      
      New_Line;
      Put_Line("Test 5: Tentative de depilement d'une pile vide ...");
      Depiler(P);
      Put_Line("      bizarre ... si on est passe ici c'est que l'exception ne s'est pas levee ... ");
   exception
      when Pile_Vide =>
	 Put_Line("      exception Pile_Vide levee !!");
   end;
   
   
	-----------------------------------------------------
	-- 4. Test sur l'égalité de 2 piles
	Put_Line("Test 6 : Initialisation de 2 piles P1 et P2, et comparaison, ajout de 10 elements et comparaison");
	declare
		P1, P2 : Une_Pile_Entiers;
	begin
	    -- comparer P1 et P2
		Afficher_Test("P1=P2?", "TRUE", Boolean'Image(P1=P2));
		-- Empiler 10 entiers sur les 2 piles
		for Un_Entier in 1..10 loop
			Empiler(Un_Entier, P1);
			Empiler(Un_Entier, P2);
		end loop;
		-- comparer P1 et P2
		Afficher_Test("P1=P2?", "TRUE", Boolean'Image(P1=P2));
	end;
	
	
	
	--test_vider
	declare
		P: Une_Pile_Entiers;
	begin
	
		for Un_Entier in 1..10 loop
			Empiler(Un_Entier, P);
		end loop;
		Afficher_Test("P vide", "FALSE", Boolean'Image(Est_Vide(P)));
		Vider(P);
		Afficher_Test("P vide", "TRUE", Boolean'Image(Est_Vide(P)));
	end;
	
end Tests_Pile_Entiers;
