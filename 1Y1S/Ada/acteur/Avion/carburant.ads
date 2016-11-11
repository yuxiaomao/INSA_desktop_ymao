--
-- Gestion du carburant
--

package Carburant is

   -- Retourne le prix du carburant sur place, en euros par litre
   function Prix return Float ;

   -- Retourne la quantit� de carburant dans les r�servoirs de l'avion
   -- (en litres)
   function Volume return Float ;

   -- Retourne le volume total du r�servoir (en litres)
   function Capacite_Reservoir return Float ;

   -- Lorsque l'avion est sur l'a�roport, cette action connecte un tuyau
   -- d'alimentation en carburant. La vanne est initialement ferm�e.
   procedure Brancher_Tuyau ;

   -- Si le tuyau est branch�, ouvre la vanne : le carburant commence
   -- � entrer dans les r�servoirs
   procedure Ouvrir_Vanne ;

   procedure Fermer_Vanne ;

   -- Si la vanne est ferm�e, d�branche le tuyau
   procedure Debrancher_Tuyau ;


   -- Fait le plein de l'avion (195 881 litres)
   -- Cette action s'occupe elle-m�me de brancher le tuyau d'alimentation,
   -- d'ouvrir la vanne, etc., puis de le d�brancher lorsque le plein est fait.
   procedure Faire_Le_Plein ;

end Carburant ;
