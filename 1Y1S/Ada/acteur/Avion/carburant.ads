--
-- Gestion du carburant
--

package Carburant is

   -- Retourne le prix du carburant sur place, en euros par litre
   function Prix return Float ;

   -- Retourne la quantité de carburant dans les réservoirs de l'avion
   -- (en litres)
   function Volume return Float ;

   -- Retourne le volume total du réservoir (en litres)
   function Capacite_Reservoir return Float ;

   -- Lorsque l'avion est sur l'aéroport, cette action connecte un tuyau
   -- d'alimentation en carburant. La vanne est initialement fermée.
   procedure Brancher_Tuyau ;

   -- Si le tuyau est branché, ouvre la vanne : le carburant commence
   -- à entrer dans les réservoirs
   procedure Ouvrir_Vanne ;

   procedure Fermer_Vanne ;

   -- Si la vanne est fermée, débranche le tuyau
   procedure Debrancher_Tuyau ;


   -- Fait le plein de l'avion (195 881 litres)
   -- Cette action s'occupe elle-même de brancher le tuyau d'alimentation,
   -- d'ouvrir la vanne, etc., puis de le débrancher lorsque le plein est fait.
   procedure Faire_Le_Plein ;

end Carburant ;
