with GAda.Text_IO , Assert , Avion_Sol , INSA_Air ,Train , Pilote_Automatique,Tour,Carburant,cartographie ;

procedure Mission3 is


   --
   -- Mission 2, partie 1 : fonction Delta_Cap
   --
   -- Cette fonction Delta_Cap est incorrecte.
   -- À vous de corriger son algorithme.
   --
   function Delta_Cap(Cap_Actuel : Float ; Cap_Voulu : Float) return Float is
      Ecart_Angle : Float ;
   begin
      Ecart_Angle := Cap_Voulu - Cap_Actuel ;

      while Ecart_Angle > 180.0 loop
         Ecart_Angle := Ecart_Angle - 360.0  ;
      end loop ;
      
      while Ecart_Angle < -180.0 loop
	 Ecart_Angle :=Ecart_Angle +360.0;
      end loop;
	

      return Ecart_Angle ;
   end Delta_Cap ;

   
   --
   -- Mission 2, partie 1 : procédure de test de Delta_Cap
   -- 
   -- Cette procédure est incomplète, à vous de la rendre utile.
   --
   procedure Tester_Delta_Cap(CapA : Float ; CapV : Float) is
   begin
      GAda.Text_IO.Put_Line (Aff => "Le cap actuel vaut " & Float'Image(CapA) );
      GAda.Text_IO.Put_Line (Aff => "Le cap voulu vaut " & Float'Image(CapV) );
      GAda.Text_IO.Put_Line (Aff => "Delta cap vaut " & Float'Image(Delta_Cap(Cap_Actuel =>CapA,Cap_Voulu=>CapV))) ;
   end Tester_Delta_Cap ;
   
 
   --
   -- Mission 2, partie 2 : fonction Caps_Egaux
   --
   function Caps_Egaux (Cap1 :Float ;Cap2 :Float) return Boolean is
      Resultat:Boolean;
   begin
      if abs(Delta_cap(Cap_Actuel=>Cap1 ,Cap_Voulu=> Cap2)) <= 5.0 then
	 Resultat:= True ;
      else Resultat:= False ;
      end if;
      return Resultat;
   end Caps_Egaux;
   
   
   --
   -- Mission 2, partie 2 : procédure de test de Caps_Egaux
   --
   procedure Texter_Caps_Egaux(Cap1:Float;Cap2:Float) is
      
   begin
      GAda.Text_Io.Put_Line(Aff=>"cap1"&Float'Image(Cap1)&"et cap2"&Float'Image(Cap2));
      if Caps_Egaux(Cap1=>Cap1,Cap2=>Cap2)=True then
	 GAda.Text_Io.Put_Line(Aff=>"sont egaux");
      else
	   GAda.Text_Io.Put_Line(Aff=>"ne sont pas egaux");
      end if;
   
   end Texter_Caps_Egaux;
      
   
   --
   -- Mission 2, partie 3 : procédure Orienter_au_sol
   --
   procedure Orienter_Au_Sol(Cap_Voulu_sol:Float) is
   begin
      Assert.Failif(Cond=>Cap_Voulu_Sol>360.0 or Cap_Voulu_Sol<0.0,Message=>"le cap voulu n'est pas entre 0 et 360");
      INSA_Air.Regler_Reacteur(Force=>1);
     
      while Caps_Egaux(Cap1=>INSA_Air.Cap_Courant,Cap2=>Cap_Voulu_Sol) = False  loop
	if Delta_Cap(Cap_Actuel=>INSA_Air.Cap_Courant,Cap_Voulu=>Cap_Voulu_Sol) >0.0 then
	   Train.Positionner_A_Droite;
	 else
	    Train.Positionner_A_Gauche;
	end if;
      end loop;
      Train.Pivoter_Train_Avant(Angle=> Delta_Cap(Cap_Actuel=>INSA_Air.Cap_Courant,Cap_Voulu=>Cap_Voulu_Sol));
     
      Avion_Sol.Freiner;
   end Orienter_Au_Sol;
   
   --
   -- Mission 2, partie 3 : procédure Tester_Cap
   --
   procedure Tester_Cap is
   begin
      Avion_Sol.Rouler_Vers(Dest=>'M');
      Avion_Sol.Freiner;
      Avion_Sol.Attendre_Entree;
      Orienter_Au_Sol(Cap_Voulu_Sol=>0.0);
      Avion_Sol.Attendre_Entree;
      Orienter_Au_Sol(Cap_Voulu_Sol=>90.0);
      Avion_Sol.Attendre_Entree;
      Orienter_Au_Sol(Cap_Voulu_Sol=>270.0);
      Avion_Sol.Attendre_Entree;
      Orienter_Au_Sol(Cap_Voulu_Sol=>180.0);
      Avion_Sol.Attendre_Entree;
      Avion_Sol.Rouler_Vers(Dest=>'k');
   end Tester_Cap;
   
      
   
   --
   -- Mission 2, partie 4 : procédure Orienter_en_vol
   --
   --tourner gouverne
   procedure Orienter_En_Vol(Cap:Float)is
   begin
            --pour ne pas bloquer
            Assert.Failif(Cond=>Cap>360.0 or Cap<0.0,Message=>"le cap voulu n'est pas entre 0 et 360");
     
      while not  Caps_Egaux(Cap1=>INSA_Air.Cap_Courant,Cap2=>Cap)   loop
	if Delta_Cap(Cap_Actuel=>INSA_Air.Cap_Courant,Cap_Voulu=>Cap) >0.0 then
	   INSA_air.Positionner_Gouverne_A_Droite;
	 else
	   INSA_air.Positionner_gouverne_A_Gauche;
	end if;
      end loop;
      INSA_Air.Positionner_Gouverne_A_Zero;
     -- INSA_Air.Incliner_Gouverne(Angle=> Delta_Cap(Cap_Actuel=>INSA_Air.Cap_Courant,Cap_Voulu=>Cap));
   end Orienter_En_Vol;
   
   
   --
   -- Mission 2, partie 4 : procédure Realiser_Vol_Demo
   --
   
   procedure Realiser_Vol_Demo is
   begin
     -- Carburant.Faire_Le_Plein;
      Tour.Attendre_Autorisation_Decollage;
      INSA_Air.Regler_Reacteur(Force=>8);
      Pilote_Automatique.Decoller;
      INSA_Air.Regler_Reacteur(Force=>6);
      --rentrer le train
      Train.Deplacer_Train(Sens=>False);
      Orienter_En_Vol(Cap=>295.0);
      INSA_Air.Attendre(Sec=>1200.0);
      Orienter_En_Vol(Cap=>115.0);
      INSA_Air.Attendre(Sec=>900.0);
      INSA_Air.Regler_Reacteur(Force=>3);
      --sortir le train
      Train.Deplacer_Train(Sens=>True);
      Tour.Attendre_Autorisation_Atterrissage;
      Pilote_Automatique.Atterrir;
   end Realiser_Vol_Demo;
   
   

   
   
   --
   --mission3,partie1  Info_Aeroport
   --
   procedure Info_Aeroport(Code:String) is
   begin
      GAda.Text_IO.Put_Line(Aff=>"Le nom complet de aeroport "&Code&" est:");
      GAda.Text_IO.Put_line(Aff=>Cartographie.Nom_Aeroport(Code=>Code));
      GAda.Text_IO.Put_Line(Aff=>"Les coordonees de aeroport "&Code&" est:");
      GAda.Text_IO.Put(Aff=>"Longitude");
      GAda.Text_IO.Put_line(Aff=>Float'Image(Cartographie.Coords_Aeroport(Code=>Code).long));
      GAda.Text_IO.Put(Aff=>"Latitude");
      GAda.Text_IO.Put_line(Aff=>Float'Image(Cartographie.Coords_Aeroport(Code=>Code).Lat));
   end Info_Aeroport;
   
   
   --
   --mission3,partie1   Tester_carto
   --
   procedure Tester_Carto is
   begin
      Info_Aeroport(Code=>"LFBO");
      Info_Aeroport(Code=>"EGLL");
      Info_Aeroport(Code=>"LFPG");
   end Tester_Carto;
   
   
   
   --
   --mission3,partie1   Distance
   --
   --1 degre de longitude ou latitude mesure (m)
   
   L_Deg:constant Float :=111600.0;
   --
   
   function Distance(Point1:Cartographie.T_Coords;Point2:Cartographie.T_Coords)return float is
      Resultat_Long:Float;
      Resultat_Lat:Float;
      Resultat:Float;
   begin
      Resultat_Long:=(Point2.Long - Point1.Long)*L_deg;
      Resultat_Lat:=(Point2.Lat - Point1.Lat)*L_deg;
      Resultat:=Cartographie.SQRT(X=>(Resultat_Long**2 + Resultat_Lat**2));
      return Resultat;
      
   end Distance;
   
   
   --
   --mission3,partie1  Cap_cible
   --
   --LFBO(blagnac) est l'aeroport toulouse
   function Cap_Cible(Code:String) return Float is
      Resultat:Float;
      Resultat_Long:Float;
      Resultat_Lat:Float;
   begin
      Resultat_Long:=(Cartographie.Coords_Aeroport(Code=>Code).Long - Cartographie.Coords_Aeroport(Code=>"LFBO").Long) ;
      Resultat_Lat:=(Cartographie.Coords_Aeroport(Code=>Code).Lat - Cartographie.Coords_Aeroport(Code=>"LFBO").Lat) ;
      Resultat:=Cartographie.Cap_Vecteur(Dx=>Resultat_Long,Dy=>Resultat_Lat);
      return Resultat;      
   end Cap_Cible;
   
   
   
   --mission3,partie1 Cap_orienter
   --
   -- trouver le cap pour orienter en vol
   function Cap_Orienter (Code:String) return Float is
      Resultat:Float;
      Resultat_Long:Float;
      Resultat_Lat:Float;
   begin
      Resultat_Long:=(Cartographie.Coords_Aeroport(Code=>Code).Long - Cartographie.Coords_avion.Long) ;
      Resultat_Lat:=(Cartographie.Coords_Aeroport(Code=>Code).Lat - Cartographie.Coords_avion.Lat) ;
      Resultat:=Cartographie.Cap_Vecteur(Dx=>Resultat_Long,Dy=>Resultat_Lat);
      return Resultat;      
   end Cap_Orienter;
   
   
   
   --mission3,partie2 Nb_Aeroport_Plus_Proche
   --
   function Code_Aeroport_Plus_Proche return String is
      Distance_Variable :Float;
      Distance_Plus_Proche:Float:=1.0E+18 ;
      Nb_Aeroport_Plus_Proche:Integer:=1;
      
   begin
      for N in 1 .. Cartographie.Nb_Aeroports loop
	 
	 Distance_Variable:= Distance (Point1=>Cartographie.Coords_Aeroport(Code=>Cartographie.Code_Aeroport(Numero=>N)),Point2=>Cartographie.Coords_Avion) ;
	 
	 if Distance_Variable < Distance_Plus_Proche then
	    Distance_Plus_Proche:=Distance_Variable;
	    Nb_Aeroport_Plus_Proche:=N;
	 end if;
	
	   
      end loop;
      return Cartographie.Code_Aeroport(Numero=>Nb_Aeroport_Plus_Proche);
      

   end Code_Aeroport_Plus_Proche;
   
     
   --mission3,partie2 Nb_Aeroport_Plus_Proche_Etranger
   --
   function Code_Aeroport_Plus_Proche_Etranger return String is
      Distance_Variable :Float;
      Distance_Plus_Proche:Float:=1.0E+18 ;
      Nb_Aeroport_Plus_Proche:Integer:=1;
      
   begin
      for N in 1 .. Cartographie.Nb_Aeroports loop
	 
	 Distance_Variable:= Distance (Point1=>Cartographie.Coords_Aeroport(Code=>Cartographie.Code_Aeroport(Numero=>N)),Point2=>Cartographie.Coords_Avion) ;
	 if Cartographie.Pays_Aeroport (Code =>Cartographie.Code_Aeroport (Numero=> N)) /= "FR" then
	    
	   if Distance_Variable < Distance_Plus_Proche then
	      Distance_Plus_Proche:=Distance_Variable;
	      Nb_Aeroport_Plus_Proche:=N;
	   end if;
	   
	 end if;
	
	   
      end loop;
      return Cartographie.Code_Aeroport(Numero=>Nb_Aeroport_Plus_Proche);
      

   end Code_Aeroport_Plus_Proche_etranger;
   
   
   
   --
   --mission3,partie1  Naviguer_Vers
   --
   --mission3,partie2 Marauer pour reparer
   --
   --mission3,partie2 Marauer etranger,calculer
   procedure Naviguer_Vers(Code:String) is
      Distance_Moyenne_Vers_Aeroport_Etranger:Float:=0.0;
      N:Float:=0.0;
   begin
      while Distance(Point1=>Cartographie.Coords_Avion , 
		     Point2 => Cartographie.Coords_Aeroport(Code=>Code)) > 100000.0 loop
	 Orienter_En_Vol(Cap=>Cap_Orienter (Code=>Code));
	 Cartographie.Placer_Marque(Point=>Cartographie.Coords_Aeroport(Code=>Code_Aeroport_Plus_Proche_Etranger ));
	 --INSA_air.attendre(sec=>5.0);
	 Distance_Moyenne_Vers_Aeroport_Etranger:= Distance_Moyenne_Vers_Aeroport_Etranger + Distance(Point1=>Cartographie.Coords_Avion ,
												      Point2=>Cartographie.Coords_Aeroport(Code=>Code_Aeroport_Plus_Proche_Etranger));
	 N:=N + 1.0;

      end loop;
      
      GAda.Text_IO.Put_Line(Aff=>"L'avion est deja dans la zone de l'aeroport "
			      & Cartographie.Nom_Aeroport(Code=>Code) );
      GAda.Text_IO.Put_Line(Aff=>"Durant ce voyage,la distance moyenne entre avion et Aeroport Etranger plus proche est "
			      & Float'Image(Distance_Moyenne_Vers_Aeroport_Etranger / N)
			      & " M.");
      
   end Naviguer_Vers;
   
   
   
   
   
   
       
          --essai
   procedure Vol_Essai is
   begin
      Carburant.Faire_Le_Plein;
      Tour.Attendre_Autorisation_Roulage;
      Avion_Sol.Rouler_Vers(Dest=>'L');
      Avion_Sol.Rouler_Vers(Dest=>'M');
      Avion_Sol.Rouler_Vers(Dest=>'E');
      Avion_Sol.Rouler_Vers(Dest=>'A');
      Tour.Attendre_Autorisation_Decollage;
      INSA_Air.Regler_Reacteur(Force=>8);
      Pilote_Automatique.Decoller;
      INSA_Air.Regler_Reacteur(Force=>6);
      --rentrer le train
      Train.Deplacer_Train(Sens=>False);
      --pret a vol!
      
      Naviguer_Vers(Code=>"LFLL");
      Avion_Sol.Attendre_Entree;
      
      
      Naviguer_Vers(Code=>"LFPG");
      Avion_Sol.Attendre_Entree;
      
      
      Naviguer_Vers(Code=>"EGKK");
      Avion_Sol.Attendre_Entree;
      
      Naviguer_Vers(Code=>"LFBO");
      
      --fin vol essai,atterrisage!
      INSA_Air.Regler_Reacteur(Force=>3);
      Tour.Attendre_Autorisation_Atterrissage;
      
      --sortir le train
      Train.Deplacer_Train(Sens=>True);
      Pilote_Automatique.Atterrir;
      Avion_Sol.Freiner;
      Avion_Sol.Rouler_Vers(Dest=>'N');
      Avion_Sol.Rouler_Vers(Dest=>'M');
      Avion_Sol.Rouler_Vers(Dest=>'L');
      Avion_Sol.Rouler_Vers(Dest=>'K');
      Avion_Sol.Freiner;     
   end Vol_Essai;
   


begin

  -- Tester_Delta_Cap (CapA => 0.0,   CapV => 45.0) ;
  -- Tester_Delta_Cap (CapA => 45.0,  CapV => 0.0) ;
  -- Tester_Delta_Cap (CapA => 350.0, CapV => 10.0) ;
  -- Tester_Delta_Cap (CapA => 10.0,  CapV => 350.0) ;
  -- Tester_Delta_Cap (CapA => 30.0,  CapV => 285.0) ;
  -- Texter_Caps_Egaux(Cap1=>358.0,Cap2=>2.0);
  -- Texter_Caps_Egaux(Cap1=>2.0,Cap2=>358.0);
  -- Texter_Caps_Egaux(Cap1=>38.0,Cap2=>56.0);
  -- Texter_Caps_Egaux(Cap1=>256.0,Cap2=>250.0);
  -- Tester_Cap;
  
  --------
  --
  -- Tester_Carto;   
   
   --
  -- GAda.Text_IO.Put_Line(Aff=>"la distance entre Blagnac(LFBO) et Heathrow(EGLL) est:");
  --GAda.Text_IO.Put_Line(Aff=>Float'Image( Distance(Point1=>Cartographie.Coords_Aeroport(Code=>"LFBO"),Point2=>Cartographie.Coords_Aeroport(Code=>"EGLL"))));
   
   
   --
   --GAda.Text_IO.Put_Line(Aff=>"le cap vers cet aeroport est:");
   --GAda.Text_IO.Put_Line(Aff=>Float'Image( Cap_Cible(Code=>"EGLL")));
   --

   Vol_Essai;
   

end Mission3 ;

