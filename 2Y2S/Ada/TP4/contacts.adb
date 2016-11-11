package body Contacts is

   function Initialiser_Contact(Nom, Prenom, Ville, Specialite, Telephone : in String) return Un_Contact is
   begin
      return (new String'(Nom), new String'(Prenom), new string'(Ville), new string'(Specialite), new string'(Telephone));
   end Initialiser_Contact;

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

   function Telephone(C : in Un_Contact) return String is
   begin
      return C.Telephone.all;
   end Telephone;

   function Contact_To_String(C : in Un_Contact) return String is
   begin
      return C.Nom.all & " " & C.Prenom.all & " " & C.Ville.all & " " & C.Specialite.all & " " & C.Telephone.all;
   end Contact_To_String;

   function "="(C1, C2 : in Un_Contact) return Boolean is
   begin
      return C1.Nom.all = C2.Nom.all and C1.Prenom.all = C2.Prenom.all and C1.Ville.all = C2.Ville.all and C1.Specialite.all = C2.Specialite.all and C1.Telephone.all = C2.Telephone.all;
   end "=";

   function "<"(C1, C2 : in Un_Contact) return Boolean is
   begin
      return C1.Nom.all < C2.Nom.all or else (C1.Nom.all = C2.Nom.all and C1.Prenom.all < C2.Prenom.all);
   end "<";

   procedure Liberer_Contact(C : in out Un_Contact) is
   begin
      Liberer_String(C.Nom);
      Liberer_String(C.Prenom);
      Liberer_String(C.Ville);
      Liberer_String(C.Specialite);
      Liberer_String(C.Telephone);
   end Liberer_Contact;


end Contacts;
