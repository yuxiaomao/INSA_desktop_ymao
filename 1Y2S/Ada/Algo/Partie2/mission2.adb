with Jpg , Gada.Graphics , Gada.Plus,Gada.Text_io ;
--use Jpg , Gada.Graphics ;

procedure Mission2 is
   
   
   --coordonnees x,y
   procedure Afficher_Image (X,Y:Integer;Image:Jpg.T_Image) is
   begin
      for L in Image'Range(1) loop
	 for C in Image'Range(2) loop
	    Gada.Graphics.Colorpoint(X=>X+C,Y=>Y+Image'Last(1)-L,Coul=>Image(L,C));
	 end loop;	 
      end loop;
   end Afficher_Image;
   
   
   --x,y coordonnees
   procedure Tester_Afficher_Image(X,Y:Integer) is
   begin
      Afficher_Image(X,Y,Jpg.Lire_Image(Gada.Plus.Choisir_Fichier));
   end Tester_Afficher_Image;
   
   
   procedure Filtrer_Image_Permuter(X,Y:Integer;Image:Jpg.T_Image) is
      Color:Gada.Graphics.T_Couleur:=(0,0,0);
   begin
      for L in Image'Range(1) loop
	 for C in Image'Range(2) loop
	    Color:=(Image(L,C).Bleu,Image(L,C).rouge,Image(L,C).vert);
	    Gada.Graphics.Colorpoint(X+C,Y+Image'Last(1)-L,color);
	 end loop;	 
      end loop;
      
   end Filtrer_Image_Permuter;
   
   
   procedure Filtrer_Image_negatif(X,Y:Integer;Image:Jpg.T_Image) is
      Color:Gada.Graphics.T_Couleur:=(0,0,0);
   begin
      for L in Image'Range(1) loop
	 for C in Image'Range(2) loop
	    Color:=(255-Image(L,C).rouge,255-Image(L,C).Vert,255-Image(L,C).bleu);
	    Gada.Graphics.Colorpoint(X+C,Y+Image'Last(1)-L,Coul=>color);
	 end loop;	 
      end loop;
      
   end Filtrer_Image_negatif;
   
   procedure Filtrer_Image_Nb(X,Y:Integer;Image:Jpg.T_Image) is
      Color:Gada.Graphics.T_Couleur:=(0,0,0);
      Moyenne:Integer:=0;
   begin
      for L in Image'Range(1) loop
	 for C in Image'Range(2) loop
	    Moyenne:=(Image(L,C).Rouge+Image(L,C).Vert+Image(L,C).Bleu)/3;
	    Color:=(Moyenne,Moyenne,moyenne);
	    Gada.Graphics.Colorpoint(X+C,Y+Image'Last(1)-L,Coul=>color);
	 end loop;	 
      end loop;
      
   end Filtrer_Image_Nb;
   
   
   procedure Floutage(X,Y:Integer;Image:Jpg.T_Image;Flou:integer) is
      Color:Gada.Graphics.T_Couleur:=(0,0,0);
      Total_R:Integer:=0;
      Total_V:Integer:=0;
      Total_B:Integer:=0;	
   begin
      for L in Image'First(1)+ flou  ..Image'Last(1)-flou loop
	 for C in Image'First(2)+flou .. Image'Last(2)-flou loop
	    
	    --initialisation!!!!!
	    Total_R:=0;
            Total_V:=0;
            Total_B:=0;
	   for Lf in L - flou .. L + flou loop
	     for Cf in C - flou .. C + flou loop
		Total_R:=Total_R+Image(Lf,Cf).Rouge;
		--Gada.Text_Io.Put_Line("r"&Integer'Image(Total_R));
		Total_V:=Total_V+Image(Lf,Cf).Vert;
		--Gada.Text_Io.Put_Line("v"&Integer'Image(Total_v));
		Total_B:=Total_B+Image(Lf,Cf).Bleu;
		--Gada.Text_Io.Put_Line("b"&Integer'Image(Total_b));
	      end loop;
	   end loop;

	   Color:=(Total_R/((2*Flou+2)**2),Total_V/((2*Flou+2)**2),Total_B/((2*Flou+2)**2));
	   
	  Gada.Graphics.Colorpoint(X+C,Y+Image'Last(1)-L,color);
	 end loop;	 
      end loop;
      
      
   end Floutage;
   
   
   Image:Jpg.T_Image:=Jpg.Lire_Image(Gada.Plus.Choisir_Fichier);
   Long:Integer:=Image'Length(1);
   Larg:Integer:=Image'Length(2);

begin
   Gada.Graphics.Resize(Larg*2,Long*2);
   --Tester_Afficher_Image(0,0);
   --Tester_Afficher_Image(Larg,0);
   --Tester_Afficher_Image(0,Long);
   --Tester_Afficher_Image(Larg,Long);
   
   
   --filtre

   Filtrer_Image_Permuter(Larg,0,Image);
   Filtrer_Image_Negatif(0,Long,Image);
   Filtrer_Image_Nb(0,0,Image);
   
   Floutage(Larg,Long,Image,3);
end Mission2;
