--
-- Programme à compléter
--
with Tour , Avion_sol ;

procedure Mission2a is
   package T renames Tour ;
   package As renames Avion_Sol;
   procedure Rouler_Ka is
     begin
        As.Rouler_Vers (Dest => 'L' ) ;
        As.Rouler_Vers (Dest => 'M' ) ;
        As.Rouler_Vers (Dest => 'E' ) ;
        As.Rouler_Vers (Dest => 'A' ) ;
     end Rouler_Ka;
   procedure Rouler_Dk is
     begin
       As.Rouler_Vers (Dest => 'N') ;
       As.Rouler_Vers (Dest => 'M') ;
       As.Rouler_Vers (Dest => 'l') ;
       As.Rouler_Vers (Dest => 'K') ;
     end Rouler_Dk;
   procedure Tester_Roulage is
     begin
       As.Attendre_Entree ;
       T.Attendre_Autorisation_Roulage;
       Rouler_Ka;
       T.Attendre_Autorisation_Decollage;
       As.Parcourir_Piste;
       As.Freiner;
       --T.Attendre_Autorisation_Atterrissage;
       Rouler_Dk;
       As.Freiner;
     end Tester_Roulage;
begin
  Tester_Roulage;	  
       
       
end Mission2a ;




