with Contacts; use Contacts;
with Listes_Ordonnees_G;

--package Liste_Ordonnee_Contacts is 
   package Liste_Ordonnee_Contacts is new Listes_Ordonnees_G(Un_Contact,"=","<",
							     Contact_To_String,
							     Liberer_Contact);
   
--end Liste_Ordonnee_Contacts;
   
