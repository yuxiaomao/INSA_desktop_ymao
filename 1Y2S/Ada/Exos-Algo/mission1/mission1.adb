
with Gada.Text_IO ;

procedure Mission1 is
   
   procedure Tracer_Ligne (Long:Integer) is
   begin
      for L in 1 .. Long loop
	 Gada.Text_IO.Put(Aff=>"#");
      end loop;
      Gada.Text_IO.New_Line;
   end Tracer_Ligne;
   
   
   procedure Tracer_Tectangle (Largeur:Integer;Hauteur:Integer ) is
   begin
      for H in 1 .. Hauteur loop
	 
	 if H = 1 or H = Hauteur  then
	    Tracer_Ligne(Long=>Largeur);
	 else
	    for L in 1 .. Largeur loop
	       
	       if L = 1  then
		  Gada.Text_IO.Put(Aff=>"#");
	       elsif  L = Largeur then
		  Gada.Text_IO.Put(Aff=>"#");
		  Gada.Text_IO.New_Line;
	       else
		  Gada.Text_IO.Put(Aff=>" ");
	       end if;
	       
	    end loop;
	         
	 end if;
      end loop;
   end Tracer_Tectangle;
   
   
   procedure Tracer_Quadrillage (Largeur:Integer;Hauteur:Integer) is
   begin
      for H in 1 .. Hauteur loop
	 if ( H mod 2 ) =1 then
	    Tracer_Ligne(Long=>Largeur);
	 else
	    
	    for L in 1 .. Largeur loop
	       
	       if ( L mod 2 )=1 then
		  Gada.Text_IO.Put(Aff=>"#");
	       else
		  Gada.Text_IO.Put(Aff=>" ");
	       end if;
	       
	       if L=Largeur then
		  Gada.Text_IO.New_Line;
	       end if;
	       
	    end loop;
	 end if;	 
      end loop;
      
   end Tracer_Quadrillage;
   
   
   procedure Tracer_Damier(Largeur:Integer;Hauteur:Integer) is
   begin
      for H in 1 .. Hauteur loop
	 if ( H mod 2 ) =1 then
	     for L in 1 .. Largeur loop
	       
	       if ( L mod 2 )=1 then
		  Gada.Text_IO.Put(Aff=>"#");
	       else
		  Gada.Text_IO.Put(Aff=>" ");
	       end if;
	       
	       if L=Largeur then
		  Gada.Text_IO.New_Line;
	       end if;
	       
	     end loop;
	     
	 else
	    
	    for L in 1 .. Largeur loop
	       
	       if ( L mod 2 )=0 then
		  Gada.Text_IO.Put(Aff=>"#");
	       else
		  Gada.Text_IO.Put(Aff=>" ");
	       end if;
	       
	       if L=Largeur then
		  Gada.Text_IO.New_Line;
	       end if;
	       
	    end loop;
	 end if;	 
      end loop;
      
   end Tracer_Damier;
	 
   
   procedure Tracer_Gros_Damier (Largeur:Integer;Hauteur:Integer) is
   begin
      for H in 1 .. Hauteur loop
	 if ( H mod 4 ) =1 or ( H mod 4 ) =2  then
	     for L in 1 .. Largeur loop
	       
	       if ( L mod 4 )=0 or( L mod 4 )=3  then
		  Gada.Text_IO.Put(Aff=>"#");
	       else
		  Gada.Text_IO.Put(Aff=>" ");
	       end if;
	       
	       if L=Largeur then
		  Gada.Text_IO.New_Line;
	       end if;
	       
	     end loop;
	     
	 else
	    
	    for L in 1 .. Largeur loop
	       
	       if ( L mod 4 )=1 or( L mod 4 )=2 then
		  Gada.Text_IO.Put(Aff=>"#");
	       else
		  Gada.Text_IO.Put(Aff=>" ");
	       end if;
	       
	       if L=Largeur then
		  Gada.Text_IO.New_Line;
	       end if;
	       
	    end loop;
	 end if;	 
      end loop;
      
   end Tracer_Gros_Damier;
   
   
	 
	 
	 
	 
begin

   Tracer_Ligne(Long=>3);
   Tracer_Ligne(Long=>8);
   Tracer_Tectangle(Largeur=>4,Hauteur=>6);
   Tracer_Tectangle(Largeur=>14,Hauteur=>2);
   Tracer_Quadrillage(Largeur=>19,Hauteur=>11);
   Tracer_Damier(Largeur=>18,Hauteur=>10);
   Tracer_Gros_Damier(Largeur=>18,Hauteur=>10);
   
   
   
end mission1;
