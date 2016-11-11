--
-- Contr�le de l'avion au sol
--

package Avion_Sol is


   -- Fait rouler l'avion en ligne droite jusqu'au point indiqu�
   procedure Rouler_Vers (Dest : Character) ;


   -- Lorsque l'avion a obtenu l'autorisation de d�collage, cette action parcourt
   -- toute la piste � grande vitesse, mais sans d�coller, puis freine en fin de piste.
   -- L'action se termine lorsque l'avion est en fin de piste.
   procedure Parcourir_Piste ;


   -- Stoppe les r�acteurs et commande le freinage de l'avion
   procedure Freiner ;


   -- Attend que l'utilisateur appuie sur "entr�e"
   procedure Attendre_Entree ;


end Avion_Sol ;
