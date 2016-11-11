-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : specification paquetage Contact (avec cle)
-- 
-----------------------------------------------------------------------------
with Pointeurs_De_Strings;
use Pointeurs_De_Strings;

package Contact_Cle is

   type Un_Contact is private; 
   subtype Cle_Contact is String(1..10);
   
   function Creer_Contact(Nom, Prenom, Ville, Specialite, Telephone : in String) return Un_Contact;
   function Nom(C : in Un_Contact) return String;
   function Prenom(C : in Un_Contact) return String;
   function Ville(C : in Un_Contact) return String;
   function Specialite(C : in Un_Contact) return String;
   function Telephone(C : in Un_Contact) return Cle_Contact;
	
   function Contact_To_String(C : in Un_Contact) return String;
   procedure Liberer_Contact(C : in out Un_Contact);
   
      -- Cle : le champ Telephone sous forme d'entier
   -- fonction de comparaison sur la cle
   function Cle(C : in Un_Contact) return Cle_Contact;
   function"="(S1, S2 : Cle_Contact) return Boolean;
   function"<"(S1, S2 : Cle_Contact) return Boolean;
   
   function Equal(C1, C2 : in Un_Contact) return Boolean;
   function Inf_OrdreAlpha(C1, C2 : in Un_Contact) return Boolean;
   
   
   
private

   type Un_Contact is record
      Nom : P_String;
      Prenom : P_String;
      Ville : P_String;
      Specialite : P_String;
      Telephone : Cle_Contact;
   end record;

end Contact_Cle;
