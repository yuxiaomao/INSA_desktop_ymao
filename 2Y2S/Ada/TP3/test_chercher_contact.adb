with Chercher_Contact;
with Ada.Text_Io; use Ada.Text_Io;

procedure Test_Chercher_Contact is
   S:String:="nomm prenomm villl speccc 1425313";
   Info_Nom,Info_Prenom,Info_Ville,Info_Spec,Info_Tel:String(1..20);
begin
   Chercher_Contact(S, Info_Nom,Info_Prenom,Info_Ville,Info_Spec,Info_Tel);
   Put_Line(Info_Nom);
   Put_Line(Info_Prenom);
   Put_Line(Info_Ville);
   Put_Line(Info_Spec);
   Put_Line(Info_Tel);
end Test_Chercher_Contact;
