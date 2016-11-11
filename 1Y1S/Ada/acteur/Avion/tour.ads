--
-- Communication avec la tour de contrôle.
--
package Tour is

   -- Lorsque l'avion est garé, cette action attend
   -- l'autorisation de rouler sur le taxiway.
   -- L'action termine lorsque l'autorisation est arrivée.
   procedure Attendre_Autorisation_Roulage ;

   -- Lorsque l'avion est en début de piste, cette action attend
   -- l'autorisation de décollage de la tour de contrôle.
   -- L'action termine lorsque l'autorisation est arrivée.
   procedure Attendre_Autorisation_Decollage ;

   -- Lorsque l'avion approche de la destination, cette action attend
   -- l'autorisation d'atterrissage de la tour de contrôle.
   -- L'action termine lorsque l'autorisation est arrivée.
   procedure Attendre_Autorisation_Atterrissage ;


end Tour ;
