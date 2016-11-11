--
-- Programme à compléter
--
with Simulation ;

procedure Mission1 is
   package Ia renames Simulation ;
   procedure Rouler_Ka is
     begin
        Ia.Rouler_Vers (Dest => 'L' ) ;
        Ia.Rouler_Vers (Dest => 'M' ) ;
        Ia.Rouler_Vers (Dest => 'E' ) ;
        Ia.Rouler_Vers (Dest => 'A' ) ;
     end Rouler_Ka;
   procedure Rouler_Dk is
     begin
       Ia.Rouler_Vers (Dest => 'N') ;
       Ia.Rouler_Vers (Dest => 'M') ;
       Ia.Rouler_Vers (Dest => 'l') ;
       Ia.Rouler_Vers (Dest => 'K') ;
     end Rouler_Dk;
   procedure Tester_Roulage is
     begin
       Ia.Attendre_Autorisation_Roulage;
       Rouler_Ka;
       Ia.Attendre_Autorisation_Decollage;
       Ia.Parcourir_Piste;
       Rouler_Dk;
     end Tester_Roulage;
begin
  Tester_Roulage;	  
       
       
end Mission1 ;




