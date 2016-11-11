--

with GAda.Text_IO ,Caracteres,GAda.Integer_Text_IO;

procedure Mission1 is
   procedure Afficher_Trame (N_eme:integer) is
   begin
      for H in 1 .. Caracteres.Hauteur_Car loop
	 for L in 1 .. Caracteres.Largeur_Car loop

	    case Caracteres.Table(N_Eme).Trame(H,L) is
	       when Caracteres.Allume => GAda.Text_IO.Put("#");
	       when Caracteres.Eteint => GAda.Text_IO.Put(" ");
	    end case;
	    
	    if L=Caracteres.Largeur_Car then
	       GAda.Text_IO.New_Line;
	    end if;
	    
	 end loop;
      end loop;
      
   end Afficher_Trame;
   
   
   procedure Afficher_Mot (Mot_taper:String) is 
   begin
      
      for Car in Mot_Taper'Range loop
	 for N in 1 .. Caracteres.Nombre_De_Caracteres loop
	    if Caracteres.Table(N).Car = Mot_Taper(Car)  then
	       Afficher_Trame(N);
	    end if;
	 end loop;
      end loop;
      
      
   end Afficher_Mot;
   
   
   
   
   --premier partie,get N_taper,mot_taper
   
   
   N_Taper:Integer;

   
   
begin
   
   --entier N
   GAda.Text_IO.Put(Aff=>"Veuillez taper un entier N entre 1 et 91:");
   GAda.Integer_Text_IO.Get(Item => N_taper);
   GAda.Text_IO.New_Line;
   GAda.Text_IO.Put_Line(Aff=>"Vous avez tape"&Integer'Image(N_Taper));
   GAda.Text_IO.Put(Aff=>"C'est caracteres "&Caracteres.Table(N_taper).Car&".");
   Afficher_Trame(N_Eme=>N_Taper);
   
   --string M
   
   GAda.Text_IO.New_Line;
   Afficher_Mot(Mot_Taper=>GAda.Text_IO.FGet);
   
end Mission1;
