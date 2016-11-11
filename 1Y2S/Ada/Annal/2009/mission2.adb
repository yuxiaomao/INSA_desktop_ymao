with Gada.Graphics;
with Plongee;
with Gada.Text_Io;

procedure Mission2 is
   
   function Temps_Remontee(D:Plongee.Une_Duree;P:Plongee.Une_Profondeur) return Integer is
      Seq:Plongee.Une_Sequence:=Plongee.Table(P,D).Sequence;
   begin
      if Plongee.Table(P,D).Definis then
	 return Seq.Trois+Seq.Six+Seq.Neuf+Seq.Douze+Seq.Quinze+P;
      else
	 return 24*60; 
      end if;
   end Temps_Remontee;
   
   
   function  Chercher_Profondeur (T:Natural;D:Plongee.Une_Duree) return Plongee.Une_Profondeur is
      Trouvee:Boolean:=false;
      P_Cherche:Plongee.Une_Profondeur:=6;
   begin
      for P in 0 .. 6 loop
	 if (not Trouvee) and ((Temps_Remontee(D,P)+P)>T) then
	    Trouvee:=True;
	    P_Cherche:=P;
	 end if;
      end loop;
      return P_Cherche;  
   end Chercher_Profondeur;
   
   --mission1
   
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
   
   function Transformer (D:Plongee.Une_Duree;P:Plongee.Une_Profondeur) return Des_Coords is 
   begin
      return (40+D*420/36,360-P*320/6);
   end Transformer;
   
   --mission2
   
   procedure Tracer_Courbe_De_Securite (T:Integer) is
      P:Integer;
   begin
      Gada.Graphics.Resize(500,400);
      for D in 0 .. 36 loop
	 P:=Chercher_Profondeur(T,D);
	 Disque(Transformer(D,P),1);
      end loop;
   end Tracer_Courbe_De_Securite;

      
   
   
   
   
   
begin
   Gada.Graphics.Resize(500,400);
   Gada.Text_Io.Put_Line(Integer'Image(Temps_Remontee(7,4)));
   Gada.Text_Io.Put_Line(Integer'Image(Chercher_Profondeur(200,2)));
   Tracer_Courbe_De_Securite(100);
end Mission2;
