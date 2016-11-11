with GAda.Text_IO , Assert , Avion_Sol , INSA_Air ,train ;

procedure Mission2b is


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
      Train.Positionner_A_Zero;
     
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
   
   
   --
   -- Mission 2, partie 4 : procédure Realiser_Vol_Demo
   --


begin

   Tester_Delta_Cap (CapA => 0.0,   CapV => 45.0) ;
   Tester_Delta_Cap (CapA => 45.0,  CapV => 0.0) ;
   Tester_Delta_Cap (CapA => 350.0, CapV => 10.0) ;
   Tester_Delta_Cap (CapA => 10.0,  CapV => 350.0) ;
   Tester_Delta_Cap (CapA => 30.0,  CapV => 285.0) ;
   Texter_Caps_Egaux(Cap1=>358.0,Cap2=>2.0);
   Texter_Caps_Egaux(Cap1=>2.0,Cap2=>358.0);
   Texter_Caps_Egaux(Cap1=>38.0,Cap2=>56.0);
   Texter_Caps_Egaux(Cap1=>256.0,Cap2=>250.0);
   Tester_Cap;
   
   

end Mission2b ;

