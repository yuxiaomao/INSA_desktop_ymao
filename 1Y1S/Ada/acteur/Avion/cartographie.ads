
--
-- Acc�s aux informations de la carte
--

package Cartographie is

   --
   -- Le type T_Coords est form� d'une longitude (X) et d'une latitude (Y)
   --  (mesur�s en degr�s)
   --
   -- Voir "type article" dans l'aide-m�moire.
   --
   type T_Coords is record
      Long : Float ;
      Lat  : Float ;
   end record ;

   -- Renvoie les coodonn�es actuelles de l'avion
   function Coords_Avion return T_Coords;
   -- Note technique : Coords_Avion n�cessite d'interroger le r�cepteur GPS
   -- de l'avion, ce qui prend quelques millisecondes (4 ms environ).


   -- Renvoie le nom complet de l'a�roport
   -- Le code est le code OACI de l'a�roport (4 lettres)
   function Nom_Aeroport (Code : String) return String ;

   -- Renvoie le pays (sur deux lettres) de l'a�roport
   -- dont on donne le code OACI
   function Pays_Aeroport (Code : String) return String ;

   -- Renvoie les coordonn�es de l'a�roport indiqu� par son code OACI
   function Coords_Aeroport (Code : String) return T_Coords ;

   -- Renvoie le nombre d'a�roports connus
   -- Les a�roports sont num�rot�s de 1 � n
   function Nb_Aeroports return Integer ;

   -- Renvoie le code OACI de l'a�roport rep�r� par son num�ro
   function Code_Aeroport (Numero : Integer) return String ;

   -- Place une marque aux coordonn�es indiqu�es
   procedure Placer_Marque (Point : T_Coords) ;

   -- Renvoie le cap correspondant au vecteur indiqu�, entre 0 et 360
   -- Par exemple, le cap du vecteur (0, 1) est 0
   -- Le cap du vecteur (1, 1) est 45
   -- Le cap du vecteur (0, -1) est 180
   function Cap_Vecteur (DX, DY : Float) return Float ;


   -- Fonction racine carr�e
   function SQRT (X : Float) return Float ;

end Cartographie ;
