--
-- Programme à compléter
--
with Simulation ;

procedure Mission1 is
   package Ia renames Simulation ;

begin
   Ia.Attendre_Autorisation_Roulage;
   Ia.Rouler_Vers (Dest => 'L' ) ;
   Ia.Rouler_Vers (Dest => 'M' ) ;
   Ia.Rouler_Vers (Dest => 'E' ) ;
   Ia.Rouler_Vers (Dest => 'A' ) ;
   Ia.Attendre_Autorisation_Decollage ;
   Ia.Parcourir_Piste ;
   Ia.Rouler_Vers (Dest => 'N') ;
   Ia.Rouler_Vers (Dest => 'M') ;
   Ia.Rouler_Vers (Dest=>'l');
   Ia.Rouler_Vers (Dest => 'K' );
   
end Mission1 ;




