-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : corps du paquetage Contact (avec cle)
-- 
-----------------------------------------------------------------------------
package body Contact_Cle is

   function Creer_Contact(Nom, Prenom, Ville, Specialite, Telephone : in String) return Un_Contact is
   begin
      return (new String'(Nom), new String'(Prenom), new string'(Ville), new string'(Specialite), Telephone);
   end Creer_Contact;

   function Nom(C : in Un_Contact) return String is
   begin
      return C.Nom.all;
   end Nom;

   function Prenom(C : in Un_Contact) return String is
   begin
      return C.Prenom.all;
   end Prenom;

   function Ville(C : in Un_Contact) return String is
   begin
      return C.Ville.all;
   end Ville;
	
   function Specialite(C : in Un_Contact) return String is
   begin
      return C.Specialite.all;
   end Specialite;
		
   function Telephone(C : in Un_Contact) return Cle_Contact is
   begin
      return C.Telephone;
   end Telephone;
	
   function Contact_To_String(C : in Un_Contact) return String is
   begin
      return C.Nom.all & " " & C.Prenom.all & " " & C.Ville.all & " " & C.Specialite.all & " " & C.Telephone & "; ";
   end Contact_To_String;


   function Cle(C : in Un_Contact) return Cle_Contact is
   begin
      return C.Telephone;
   end Cle;
   
   function "="(S1, S2 : in Cle_Contact) return Boolean is
      Res : Boolean := True;
      indice : Integer := S1'First;
   begin
      while Indice <= S1'Last and Res=True loop
	 if S1(Indice) /= S2(Indice) then
	    Indice := Indice+1;
	 else
	    Res := False;
	 end if;
      end loop;      
      return Res;
   end "=";

   function "<"(S1, S2 : in Cle_Contact) return Boolean is
      Res : Boolean := True;
      indice : Integer := S1'First;
   begin
      while Indice <= S1'Last and Res=True loop
	 if S1(Indice) < S2(Indice) then
	    Indice := Indice+1;
	 else
	    Res := False;
	 end if;
      end loop;      
      return Res;
   end "<";
   
   procedure Liberer_Contact(C : in out Un_Contact) is
   begin
      Liberer_String(C.Nom);
      Liberer_String(C.Prenom);
      Liberer_String(C.Ville);
      Liberer_String(C.Specialite);
      --Liberer_String(C.Telephone);
   end Liberer_Contact;
   
   
   -- Egalite champ a champ sur les elements
   function Equal(C1, C2 : in Un_Contact) return Boolean is
   begin
      return C1.Nom.all = C2.Nom.all and C1.Prenom.all = C2.Prenom.all and C1.Ville.all = C2.Ville.all and C1.Specialite.all = C2.Specialite.all and C1.Telephone = C2.Telephone;
   end Equal;
   
   -- Ordre alphabetique sur nom et prenom
   function Inf_OrdreAlpha(C1, C2 : in Un_Contact) return Boolean is
   begin
      return C1.Nom.all < C2.Nom.all or else (C1.Nom.all = C2.Nom.all and C1.Prenom.all < C2.Prenom.all);
   end Inf_OrdreAlpha;
   
   
   
end Contact_Cle;
