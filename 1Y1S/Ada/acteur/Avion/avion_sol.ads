--
-- Contrôle de l'avion au sol
--

package Avion_Sol is


   -- Fait rouler l'avion en ligne droite jusqu'au point indiqué
   procedure Rouler_Vers (Dest : Character) ;


   -- Lorsque l'avion a obtenu l'autorisation de décollage, cette action parcourt
   -- toute la piste à grande vitesse, mais sans décoller, puis freine en fin de piste.
   -- L'action se termine lorsque l'avion est en fin de piste.
   procedure Parcourir_Piste ;


   -- Stoppe les réacteurs et commande le freinage de l'avion
   procedure Freiner ;


   -- Attend que l'utilisateur appuie sur "entrée"
   procedure Attendre_Entree ;


end Avion_Sol ;
