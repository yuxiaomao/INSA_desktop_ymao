--with Afficher_Test;
with Ada.Text_io;                 use Ada.Text_Io;
with Liste_ordonnee_Cle_G;
with Contacts;                 use Contacts;
with Cherche_Mot;


procedure Tester_Liste_contacts is
   
   subtype Cle_Contact is String(1..10);
   
   function Cle (E:in Un_Contact) return Cle_Contact is
   begin
      return Telephone(E);
   end Cle;
   
   --------------------------------------------------------------
   package Liste_Contact is new Liste_Ordonnee_Cle_G(Un_contact,Cle_contact,Cle,"<","=",Liberer_Contact,Contact_To_string);
   use Liste_Contact;
   
   -------------------------
   procedure Ligne_To_Contact(Ligne:in String; C:out Un_Contact) is
      Deb1,Deb2,Deb3,Deb4,Deb5:Integer;
      Fin1,Fin2,Fin3,Fin4,Fin5:Integer;
      Trouve:Boolean;
   begin
      Cherche_Mot(Ligne,' ',Deb1,Fin1,Trouve);
      Cherche_Mot(Ligne(Fin1+1..Ligne'Last),' ',Deb2,Fin2,Trouve);
      Cherche_Mot(Ligne(Fin2+1..Ligne'Last),' ',Deb3,Fin3,Trouve);
      Cherche_Mot(Ligne(Fin3+1..Ligne'Last),' ',Deb4,Fin4,Trouve);
      Cherche_Mot(Ligne(Fin4+1..Ligne'Last),' ',Deb5,Fin5,Trouve);
      C:=Initialiser_Contact(Ligne(Deb1..Fin1),Ligne(Deb2..Fin2),
			     Ligne(Deb3..Fin3),
			     Ligne(Deb4..Fin4),Ligne(Deb5..Fin5));
   end Ligne_To_Contact;
   
   
   procedure Creer_Annuaire(Nom_Fichier:in String; L:out Une_Liste_Ordonnee) is
      F:File_Type;
      Ligne:String(1..100);
      Last:Natural;
      C:Un_Contact;
   begin
      Open(F,In_File,Nom_Fichier);
      while not End_Of_File(F) loop
	 Get_Line(F,Ligne,Last);
	 Ligne_To_Contact(Ligne(1..Last),C);
	 Inserer(C,L);
      end loop;
   end Creer_Annuaire;
  
   
   Nom_Fichier:String(1..100);
   Long:Integer;
   A:Une_Liste_Ordonnee;
begin
   Get_Line(Nom_Fichier,Long);
   Creer_Annuaire(Nom_Fichier(1..Long),A);
   --annuaire pret!
   Put_Line(Liste_To_String(A));
   New_Line;
   
   begin
      Put_Line("recherche 1er");
      Put_Line(Contact_To_String(Rechercher_Par_Cle("0614557340",A)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!!???");
   end;
   
   
   begin
      Put_Line("recherche milieu");
      Put_Line(Contact_To_String(Rechercher_Par_Cle("0789751830",A)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!!???");
   end;
   
   begin
      Put_Line("recherche FIN");
      Put_Line(Contact_To_String(Rechercher_Par_Cle("0783971691",A)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!!???");
   end;
   
   begin
      Put_Line("recherche non_present");
      Put_Line(Contact_To_String(Rechercher_Par_Cle("0589751830",A)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!! ok!");
   end;
   
   --Liberer(A);
   
end Tester_Liste_Contacts;
