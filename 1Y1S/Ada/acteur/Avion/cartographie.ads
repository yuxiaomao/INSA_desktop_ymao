
--
-- Accès aux informations de la carte
--

package Cartographie is

   --
   -- Le type T_Coords est formé d'une longitude (X) et d'une latitude (Y)
   --  (mesurés en degrés)
   --
   -- Voir "type article" dans l'aide-mémoire.
   --
   type T_Coords is record
      Long : Float ;
      Lat  : Float ;
   end record ;

   -- Renvoie les coodonnées actuelles de l'avion
   function Coords_Avion return T_Coords;
   -- Note technique : Coords_Avion nécessite d'interroger le récepteur GPS
   -- de l'avion, ce qui prend quelques millisecondes (4 ms environ).


   -- Renvoie le nom complet de l'aéroport
   -- Le code est le code OACI de l'aéroport (4 lettres)
   function Nom_Aeroport (Code : String) return String ;

   -- Renvoie le pays (sur deux lettres) de l'aéroport
   -- dont on donne le code OACI
   function Pays_Aeroport (Code : String) return String ;

   -- Renvoie les coordonnées de l'aéroport indiqué par son code OACI
   function Coords_Aeroport (Code : String) return T_Coords ;

   -- Renvoie le nombre d'aéroports connus
   -- Les aéroports sont numérotés de 1 à n
   function Nb_Aeroports return Integer ;

   -- Renvoie le code OACI de l'aéroport repéré par son numéro
   function Code_Aeroport (Numero : Integer) return String ;

   -- Place une marque aux coordonnées indiquées
   procedure Placer_Marque (Point : T_Coords) ;

   -- Renvoie le cap correspondant au vecteur indiqué, entre 0 et 360
   -- Par exemple, le cap du vecteur (0, 1) est 0
   -- Le cap du vecteur (1, 1) est 45
   -- Le cap du vecteur (0, -1) est 180
   function Cap_Vecteur (DX, DY : Float) return Float ;


   -- Fonction racine carrée
   function SQRT (X : Float) return Float ;

end Cartographie ;
