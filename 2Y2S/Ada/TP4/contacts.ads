with Pointeurs_De_Strings;
use  Pointeurs_De_Strings;

package Contacts is

   type Un_Contact is private;

   --constructeur
   function Initialiser_Contact(Nom, Prenom, Ville, Specialite, Telephone : in String) return Un_Contact;

   --accesseurs
   function Nom(C : in Un_Contact) return String;
   function Prenom(C : in Un_Contact) return String;
   function Ville(C : in Un_Contact) return String;
   function Specialite(C : in Un_Contact) return String;
   function Telephone(C : in Un_Contact) return String;

   --conversion en chaine
   function Contact_To_String(C : in Un_Contact) return String;

   -- egalite
   function "="(C1, C2 : in Un_Contact) return Boolean;

   --relation d'ordre
   function "<"(C1, C2 : in Un_Contact) return Boolean;

   --recuperation memoire
   procedure Liberer_Contact(C : in out Un_Contact);


private

   type Un_Contact is record
      Nom        : P_String;
      Prenom     : P_String;
      Ville      : P_String;
      Specialite : P_String;
      Telephone  : P_String;
   end record;

end Contacts;
