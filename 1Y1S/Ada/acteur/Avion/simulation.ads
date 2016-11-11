--
-- Contrôle de l'avion au sol
--

package Simulation is


   -- Lorsque l'avion est garé, cette action attend
   -- l'autorisation de rouler sur le taxiway.
   -- L'action termine lorsque l'autorisation est arrivée.
   procedure Attendre_Autorisation_Roulage ;


   -- Fait rouler l'avion en ligne droite jusqu'au point indiqué
   procedure Rouler_Vers (Dest : Character) ;


   -- Lorsque l'avion est en début de piste, cette action attend
   -- l'autorisation de décollage de la tour de contrôle.
   -- L'action termine lorsque l'autorisation est arrivée.
   procedure Attendre_Autorisation_Decollage ;


   -- Lorsque l'avion a obtenu l'autorisation de décollage,
   -- cette action parcourt toute la piste à grande vitesse,
   -- mais sans décoller, puis freine en fin de piste.
   -- L'action se termine lorsque l'avion est en fin de piste.
   procedure Parcourir_Piste ;

end Simulation ;
