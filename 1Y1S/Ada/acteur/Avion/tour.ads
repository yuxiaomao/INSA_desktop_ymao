--
-- Communication avec la tour de contr�le.
--
package Tour is

   -- Lorsque l'avion est gar�, cette action attend
   -- l'autorisation de rouler sur le taxiway.
   -- L'action termine lorsque l'autorisation est arriv�e.
   procedure Attendre_Autorisation_Roulage ;

   -- Lorsque l'avion est en d�but de piste, cette action attend
   -- l'autorisation de d�collage de la tour de contr�le.
   -- L'action termine lorsque l'autorisation est arriv�e.
   procedure Attendre_Autorisation_Decollage ;

   -- Lorsque l'avion approche de la destination, cette action attend
   -- l'autorisation d'atterrissage de la tour de contr�le.
   -- L'action termine lorsque l'autorisation est arriv�e.
   procedure Attendre_Autorisation_Atterrissage ;


end Tour ;
