with Caracteres, Jpg, Gada.Graphics, Gada.Plus, Gada.Text_io;

procedure Mission3 is
   
   --pour facile a trouver le trame qu'on veut
   type T_Lumiere is record
      Paire:Caracteres.T_Paire;
      Nb_Blanc:Integer;
   end record;
   
   --pour aide noter le caractere ressemble le image en morceau
   type T_Morceau is array (Integer range <>, Integer range<>) of character ;
   
   
   type T_L_Table is array (Integer range <>) of T_Lumiere;
   
   
   --L_Table:T_L_Table(1 .. Caracteres.Nombre_De_Caractere);
   --initialisation de ce table
   procedure Init_L_Table(L_Table: in out T_L_Table) is
      Pt_blanc:Integer:=0;
   begin
      for N in 1 .. Caracteres.Nombre_De_Caracteres loop
	 L_Table(N).paire:=Caracteres.Table(N);
	 --calcule combien de pt blanc a ce trame
	 Pt_blanc:=0;
         for H in 1 .. Caracteres.Hauteur_Car loop
	    for L in 1 .. Caracteres.Largeur_Car loop
	       case Caracteres.Table(N).Trame(H,L) is
		  when Caracteres.Allume => Pt_blanc:=Pt_blanc+1;
		  when Caracteres.Eteint => null;
	       end case;
	    end loop;
	 end loop;
	 L_Table(N).Nb_Blanc:=Pt_Blanc*3*255;
      end loop;
   end Init_L_Table;
   
   
   
   --d'abord,couper en morceau
   --image a trame
   procedure Transformation (Image:Jpg.T_Image) is
      Nb_L:Integer:=(Image'Length(1)/Caracteres.Hauteur_Car);
      Nb_C:Integer:=(Image'Length(2)/Caracteres.Largeur_Car);
      Image_Coupe:T_Morceau(1..Nb_L,1..Nb_C);
      Morceau:Jpg.T_Image(1..Caracteres.Hauteur_Car,1..Caracteres.Largeur_Car);
      Lum:Integer:=0;
      Num_Ressemble:Integer:=1;
      
      L_Table:T_L_Table(1 .. Caracteres.Nombre_De_Caracteres);
   begin
      --texter
      Gada.Text_Io.Put_Line(Integer'Image(Nb_L)&" and"&Integer'Image(Nb_C));

      --initialiser l_table
      Init_L_Table(L_Table);
      
      --initialiser morceau
      for L in 1 .. Nb_L loop
	 for C in 1 .. Nb_C loop
	    Lum:=0;
	    --y vers bas-line,x vers droite-colone
	    --donner valeur au morceau
	    
	    --initialiser morceau
	    Morceau:=(others=>(others=>(0,0,0)));
	    for Y in 1 .. 13 loop
	       for X in 1 .. 6 loop
		  
		  --Gada.Text_Io.Put(Integer'Image(Y-1+(L-1)*13));
		  Morceau(Y,X):=Image(Y-1+(L-1)*13,X-1+(C-1)*6);

		  Lum:=Lum+Morceau(Y,X).Rouge+Morceau(Y,X).Vert+Morceau(Y,X).Bleu;
	       end loop;
	    end loop;
	    --3couleur,13*6case,255pour blanc
	    --ca ressemble combien de pt blanc?
	    --GAda.Text_Io.Put(Integer'Image(Lum));
	    --Lum:=Lum;
	    
	    --Comparer Luminausite avec trame
	    Num_Ressemble:=1;
	    for Pix in 1 .. Caracteres.Nombre_De_Caracteres loop
	       if abs(L_Table(Pix).Nb_Blanc - Lum) < abs(L_Table(Num_Ressemble).Nb_Blanc - Lum) then
		  Num_Ressemble:=Pix;
	       end if;
	       --Gada.Text_Io.Put(Integer'Image(Pix));
	    end loop;
   
	    Image_Coupe(L,C):=L_Table(Num_Ressemble).Paire.Car;
	    
	 end loop;
      end loop;
      
      --afficher
      for L in 1 .. Nb_L loop
	 for C in 1 .. Nb_C loop
	    Gada.Text_Io.Put(Image_Coupe(L,C));
	    if C=Nb_C then
	       Gada.Text_Io.New_Line;
	    end if;
	 end loop;
      end loop;
      
   end Transformation;
   
   
   
   
   Image:Jpg.T_Image:=Jpg.Lire_Image(Gada.Plus.Choisir_Fichier);
   --L_Table:T_L_Table(1 .. Caracteres.Nombre_De_Caracteres);
begin
   --Gada.Graphics.Resize(Larg*2,Long*2);
   --Init_L_Table(L_Table);
   --Gada.Text_Io.Put_Line(Integer'Image(L_Table(32).Nb_Blanc));
   Transformation(Image);
   
   
end Mission3;
