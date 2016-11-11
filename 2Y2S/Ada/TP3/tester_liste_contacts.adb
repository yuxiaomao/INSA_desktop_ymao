with Contacts, Liste_Ordonnee_Contacts,Ada.Text_Io;
with Afficher_Test,Chercher_contact;
use Contacts,Liste_Ordonnee_Contacts,Ada.Text_io;
with Pointeurs_De_Strings;
use Pointeurs_De_Strings;


procedure Tester_Liste_Contacts is
   L:Une_Liste_Ordonnee;
   F:File_Type;
   Ligne:String(1..100);--un ligne d'un ficher
   Last:Natural;
   Nom_Ficher:String(1..100);
   Long:Natural;
   Info_Nom,Info_Prenom,Info_Ville,Info_Spec,Info_Tel:P_String;
begin
   Put_Line("Veuillez entrer le nom de ficher annuaire");
   Get_Line(Nom_Ficher,Long);
   Open(F,In_File,Nom_Ficher(1..Long));
   --initialisation des contacts
   while not End_Of_File(F) loop
      Get_Line(F,Ligne,Last);
      Chercher_Contact(Ligne(1..Last),
		       Info_Nom,Info_Prenom,Info_Ville,Info_Spec,Info_Tel);
      Inserer(Initialiser_Contact(Info_Nom.all,Info_Prenom.all,Info_Ville.all,
				  Info_Spec.all,Info_Tel.all),L);
   end loop;
   
      
   --Inserer(Initialiser_Contact("Charles","Chang","Beziers","ORL","0703888032"),L);
   --Inserer(Initialiser_Contact("Martha", "Bibbs", "Beauvais", "Psychiatre", "0616751216"),L);
   --Inserer(Initialiser_Contact("Jerry", "Joosten", "Albi", "Pharmacien", "0724258260"),L);
   --Inserer(Initialiser_Contact("Elijah", "Taylor", "Caen", "Orthodontiste", "0770222606"),L);
   Put_Line(Liste_To_String(L));
--   Afficher_Test("Appartient","TRUE",
--		 Boolean'Image(Appartient(Initialiser_Contact("Martha", "Bibbs","Beauvais", "Psychiatre", "0616751216"),L)));
--   Afficher_Test("Appartient","FALSE",
--		 Boolean'Image(Appartient(Initialiser_Contact("Gary", "Maupin", "Bayonne", "Rhumatologue", "0705071875"),L)));
--   Supprimer(Initialiser_Contact("Martha", "Bibbs","Beauvais", "Psychiatre", "0616751216"),L);
--   Put_Line(Liste_To_String(L));
   
end Tester_Liste_Contacts;
