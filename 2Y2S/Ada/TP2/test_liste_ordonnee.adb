with Afficher_Test,Listes_Ordonnees_Entiers;
use Listes_Ordonnees_Entiers;

procedure Test_Liste_Ordonnee is
   
begin
   declare
      L:Une_Liste_Ordonnee_Entiers;
   begin
      Afficher_Test("Est_vide_1","TRUE",Boolean'Image(Est_Vide(L)));
      --Afficher_Test("Card","0",Integer'Image(Cardinal(L)));
      Afficher_Test("Inserer_Avant","0",Liste_To_String(L));
      Inserer(1,L);
      Afficher_Test("Est_vide_2","FALSE",Boolean'Image(Est_Vide(L)));
      Afficher_Test("Card","1",Integer'Image(Cardinal(L)));
      Inserer(15,L);
      Inserer(7,L);
      Inserer(2,L);
      Inserer(19,L);
      Afficher_Test("Inserer_Global","1,2,7,15,19",Liste_To_String(L));
      --Afficher_Test("Card","5",Integer'Image(Cardinal(L)));
      Afficher_Test("Appartient","TRUE",Boolean'Image(Appartient(7,L)));
      Afficher_Test("Appartient","FALSE",Boolean'Image(Appartient(5,L)));
   end;

   --inserer doublon
   declare
      L:Une_Liste_Ordonnee_Entiers;
   begin
      Inserer(1,L);
      Inserer(1,L);
      Afficher_Test("INCORRECT","1",Liste_To_String(L));
   exception
      when Element_Deja_Present=>
	 Afficher_Test("OK","1",Liste_To_String(L));
   end;


   --supprimer
   declare
      L:Une_Liste_Ordonnee_Entiers;
   begin
      Inserer(1,L);
      Inserer(15,L);
      Inserer(7,L);
      Inserer(2,L);
      Inserer(19,L);
      Supprimer(15,L);
      Afficher_Test("Supprimer_Normal","1,2,7,19",Liste_To_String(L));
      Supprimer(5,L);
      Afficher_Test("Supprimer_ANormal","1,2,7,19",Liste_To_String(L));
   exception
      when Element_Non_Present =>
	 Afficher_Test("Supprimer_OK","1,2,7,19",Liste_To_String(L));
   end;


end;
