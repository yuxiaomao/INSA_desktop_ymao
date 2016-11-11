--with Afficher_Test;
with Ada.Text_io;                 use Ada.Text_Io;
with Arbre_Bin_Recherche_Cle_G;
with Contacts;                 use Contacts;
with Cherche_Mot;


procedure Tester_Abr_contacts is
   
   subtype Cle_Contact is String(1..10);
   
   --function Cle (E:in Un_Contact) return Cle_Contact is
  -- begin
   --   return Telephone(E);
   --end Cle;
   
   --------------------------------------------------------------
   package Abr_Bin_Contact is new Arbre_Bin_Recherche_Cle_G(Un_contact,Cle_contact,Telephone,"<","=",Liberer_Contact,Contact_To_string);
   use Abr_Bin_Contact;
   
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
   
   
   procedure Creer_Annuaire(Nom_Fichier:in String; Abr:out Arbre) is
      F:File_Type;
      Ligne:String(1..100);
      Last:Natural;
      C:Un_Contact;
   begin
      Open(F,In_File,Nom_Fichier);
      while not End_Of_File(F) loop
	 Get_Line(F,Ligne,Last);
	 Ligne_To_Contact(Ligne(1..Last),C);
	 Inserer(C,Abr);
      end loop;
   end Creer_Annuaire;
  
   
   --Nom_Fichier:String(1..100);
   --Long:Integer;
   Nom0:String:="Annuaire_10.txt";
   Nom1:String:="Annuaire_100.txt";
   Nom2:String:="Annuaire_50000.txt";
   
   --A0:Arbre;
   --A:Arbre;
   A2:Arbre;
begin
   --Get_Line(Nom_Fichier,Long);
   --Creer_Annuaire(Nom_Fichier(1..Long),A);
   
   --Creer_Annuaire(Nom0,A0);
   --Creer_Annuaire(Nom1,A);
   Creer_Annuaire(Nom2,A2);
   --annuaire pret!
   --Put_Line(Arbre_To_String(A0));
    Put_Line(Arbre_To_String(A2));
   New_Line;
   
   begin
      Put_Line("recherche 1er");
      Put_Line(Contact_To_String(Cle_To_Element("0614557340",A2)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!!???");
   end;
   
   
   begin
      Put_Line("recherche milieu");
      Put_Line(Contact_To_String(Cle_To_Element("0789751830",A2)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!!???");
   end;
   
   begin
      Put_Line("recherche FIN");
      Put_Line(Contact_To_String(Cle_To_Element("0783971691",A2)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!!???");
   end;
   
   begin
      Put_Line("recherche non_present");
      Put_Line(Contact_To_String(Cle_To_Element("0589751830",A2)));
   exception
      when Element_Non_Present => Put_Line("Element_non_present LEVEE!! ok!");
   end;
   
   Liberer(A2);
   
end Tester_Abr_Contacts;
