with GAda.Graphics ;
with Plongee ;
with Gada.Text_IO ;

procedure Mission1 is

   type Des_Coords is record
      PosX:Integer;
      PosY:Integer;
   end record;
   
   procedure Disque (Position:Des_Coords;DPalier:Natural) is
      Couleur:Gada.Graphics.T_Couleur:=(255,0,255);
   begin
      if Dpalier=0 then
	 Gada.Graphics.Cercle(Position.PosX,Position.PosY,5,couleur);
      else
	 Gada.Graphics.Disque(Position.PosX,Position.PosY,5,couleur);
      end if;
   end Disque;
   
   
   procedure Dessine_Resultat (Res:Plongee.Un_Resultat;Centre:Des_Coords) is
   begin
      if Res.Definis then
	 Disque((Centre.PosX,Centre.PosY+20),Res.Sequence.Trois);
	 Disque((Centre.PosX,Centre.PosY+10),Res.Sequence.Six);
	 Disque((Centre.PosX,Centre.PosY+0),Res.Sequence.Neuf);
	 Disque((Centre.PosX,Centre.PosY-10),Res.Sequence.Douze);
	 Disque((Centre.PosX,Centre.PosY-20),Res.Sequence.Quinze);
	 Gada.Text_Io.Put_line("pos"&Integer'Image(Centre.PosX)&Integer'Image(Centre.PosY)
			    &"trois"&Integer'Image(Res.Sequence.Trois));
	 
      end if;
   end Dessine_Resultat;
   
   
   function Transformer (D:Plongee.Une_Duree;P:Plongee.Une_Profondeur) return Des_Coords is 
   begin
      return (40+D*420/36,360-P*320/6);
   end Transformer;
   
   
   procedure Dessine_Ligne (P:Plongee.Une_Profondeur) is
   begin
      for D in 0 .. 36 loop
	 Dessine_Resultat (Plongee.Table(P,D),Transformer(D,P));
      end loop;
   end Dessine_Ligne;
   
   procedure Dessine_Table is
   begin
      for P in 0 .. 6 loop
	 Dessine_Ligne(P);
      end loop;
   end Dessine_Table;
   
   
   
   
   --Pos:Des_Coords:=(100,200);
begin
   Gada.Graphics.Resize(500,400);
   
   -- Dessine_Resultat(Plongee.Table(1,36),pos);
 
   Dessine_Table;
   
end Mission1 ;
