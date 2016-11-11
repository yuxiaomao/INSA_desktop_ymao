--
-- Contr�le de l'avion au sol
--

package Simulation is


   -- Lorsque l'avion est gar�, cette action attend
   -- l'autorisation de rouler sur le taxiway.
   -- L'action termine lorsque l'autorisation est arriv�e.
   procedure Attendre_Autorisation_Roulage ;


   -- Fait rouler l'avion en ligne droite jusqu'au point indiqu�
   procedure Rouler_Vers (Dest : Character) ;


   -- Lorsque l'avion est en d�but de piste, cette action attend
   -- l'autorisation de d�collage de la tour de contr�le.
   -- L'action termine lorsque l'autorisation est arriv�e.
   procedure Attendre_Autorisation_Decollage ;


   -- Lorsque l'avion a obtenu l'autorisation de d�collage,
   -- cette action parcourt toute la piste � grande vitesse,
   -- mais sans d�coller, puis freine en fin de piste.
   -- L'action se termine lorsque l'avion est en fin de piste.
   procedure Parcourir_Piste ;

end Simulation ;
