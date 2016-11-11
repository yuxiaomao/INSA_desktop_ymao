-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : test Arbre Binaire Générique (avec des entiers)
-- 
-- CONSIGNE
--      ECRIRE L'INSTANCIATION
--      FAIRE PASSER LES TESTS LORSQUE LES SOUS-PROGRAMMES ASSOCIES SONT CODES
--------------------------------------------------------------------------------
with Afficher_Test;
with Ada.Text_io;                 use Ada.Text_Io;
with Arbre_Bin_Recherche_Cle_G;


procedure Tester_Abr_entiers is
   
   function Identique(E:in Integer) return Integer is
   begin
      return E;
   end Identique;
   
   procedure Liberer_Entier(E:in Integer) is 
   begin
      null;
   end Liberer_Entier;
   
   
   
   -----------------------------------------------------------------------------
   -- Instanciation Arbre Binaire Générique sur des entiers
   Package Abr_Entiers is new Arbre_Bin_Recherche_Cle_G(Integer,Integer,
							Identique,"<","=",
							Liberer_Entier,
							Integer'Image);
   use Abr_Entiers;
   --  
   -----------------------------------------------------------------------------

begin
   -----------------------------------------------------------------------------
   -- test dans le cas Arbre Vide (Test 1)
   declare
      A : Arbre;
   begin
      Put_Line("Test 1 : apres Declaration d'un ABR");
      Afficher_Test("Est_Vide(A)  ?", "TRUE", Boolean'Image(Est_Vide(A)));
      Afficher_Test("Taille(A)   ?", " 0", Integer'Image(Taille(A)));
      Afficher_Test("To_String(A) ?", "(0|)", Arbre_To_String(A));
      Afficher_Test("Appartient(2, A)  ?", "FALSE", Boolean'Image(Appartient(2, A)));
   end;
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   -- Test d'insertion et appartient (Tests 2; 3; 4; 5; 6) 
   declare
      A : Arbre;
   begin
      New_Line;
      Put_Line("Test 2 : Insertion de 6 entiers distincts");
      Inserer(7, A);
      Inserer(5, A);
      Inserer(3, A);
      Inserer(9, A);
      Inserer(4, A);
      Inserer(8, A);
      Afficher_Test("Est_Vide(A)  ?", "FALSE", Boolean'Image(Est_Vide(A)));
      Afficher_Test("Taille(A)  ?", " 6", Integer'Image(Taille(A)));
      Afficher_Test("To_String(A) ?","( 6| 3 4 5 7 8 9)", Arbre_To_String(A));
      
      New_Line;
      Put_Line("Test 3 : Appartient (debut/fin/milieu)");
      Afficher_Test("Appartient(3, A)  ?", "TRUE", Boolean'Image(Appartient(3, A)));
      Afficher_Test("Appartient(9, A)  ?", "TRUE", Boolean'Image(Appartient(9, A)));
      Afficher_Test("Appartient(5, A)  ?", "TRUE", Boolean'Image(Appartient(5, A)));
   
      New_Line;
      Put_Line("Test 4 : Insertion d'un doublon (au debut)");
      begin
	 Inserer(3, A);
	 Put_Line("      bizarre ... si on passe ici c'est que l'exception ne s'est pas levee ... ");
      exception
	 when Element_Deja_Present =>
	    Put_Line("      exception Element_Deja_Present levee !!");
      end;
   
      New_Line;
      Put_Line("Test 5 : Insertion d'un doublon (en fin)");
      begin
	 Inserer(9, A);
	 Put_Line("      bizarre ... si on passe ici c'est que l'exception ne s'est pas levee ... ");
      exception
	 when Element_Deja_Present =>
	    Put_Line("      exception Element_Deja_Present levee !!");
      end;
   
      New_Line;
      Put_Line("Test 6 : Insertion d'un doublon (au milieu)");
      begin
	 Inserer(5, A);
	 Put_Line("      bizarre ... si on passe ici c'est que l'exception ne s'est pas levee ... ");
      exception
	 when Element_Deja_Present =>
	    Put_Line("      exception Element_Deja_Present levee !!");
      end;
   end;
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   -- Tests sur la suppression (Test 7; 8; 9; 10)
   -- On considère que l'insertion est correcte
   declare
      A : Arbre;
   begin
      --New_Line;
      --Put_Line("Test 3 : Insertion de 6 entiers distincts");
      Inserer(7, A);
      Inserer(5, A);
      Inserer(3, A);
      Inserer(9, A);
      Inserer(4, A);
      Inserer(8, A);
      New_Line;
      Put_Line("Test 7 : Suppression d'un element (en fin)");
      Put_Line("Arbre avant suppression : " & Arbre_To_String(A));
      begin
	 Supprimer(9, A);
	 Afficher_Test("Taille(A)  ?", " 5", Integer'Image(Taille(A)));
	 Afficher_Test("To_String(A) ?","( 5| 3 4 5 7 8)", Arbre_To_String(A));

      exception
	 when Element_Non_Present =>
	    Put_Line("      bizarre !!! exception Element_Non_Present levee !!");
      end;
      
      New_Line;
      Put_Line("Test 8 : Suppression d'un element (en milieu)");
      --Put_Line("Arbre avant suppression : " & Arbre_To_String(A));
      begin
	 Supprimer(5, A);
	 Afficher_Test("Taille(A)  ?", " 4", Integer'Image(Taille(A)));
	 Afficher_Test("To_String(A) ?","( 4| 3 4 7 8)", Arbre_To_String(A));

      exception
	 when Element_Non_Present =>
	    Put_Line("      bizarre !!! exception Element_Non_Present levee !!");
      end;
            New_Line;
      Put_Line("Test 9 : Suppression d'un element (en debut)");
      --Put_Line("Arbre avant suppression : " & Arbre_To_String(A));
      begin
	 Supprimer(3, A);
	 Afficher_Test("Taille(A)  ?", " 3", Integer'Image(Taille(A)));
	 Afficher_Test("To_String(A) ?","( 3| 4 7 8)", Arbre_To_String(A));

      exception
	 when Element_Non_Present =>
	    Put_Line("      bizarre !!! exception Element_Non_Present levee !!");
      end;
      
      New_Line;
      Put_Line("Test 10 : Suppression d'un element non present");
      --Put_Line("Arbre avant suppression : " & Arbre_To_String(A));
      begin
	 Supprimer(6, A);
	 Afficher_Test("Taille(A)  ?", " 3", Integer'Image(Taille(A)));
	 Afficher_Test("To_String(A) ?","( 3| 4 7 8)", Arbre_To_String(A));
	 Put_Line("      bizarre ... si on passe ici c'est que l'exception ne s'est pas levee ... ");
      exception
	 when Element_Non_Present =>
	    Put_Line("      Exception Element_Non_Present levee !!");
      end;
      
   end;
end Tester_Abr_entiers;
