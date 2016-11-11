with Ada.Text_Io, Ada.Integer_Text_Io,Tortue ;
use Ada.Text_Io, Ada.Integer_Text_Io,Tortue ;

procedure Koch is 
   
   procedure Tracer_Courbe_Koch(Finesse:in Positive;Long:in float) is 
      Long_Sur_3:Float:=Long/3.0;
      Fin:Natural:=Finesse-1;
   begin
      if Finesse=1 then
	 Avancer(Long);
      else
	 Tracer_Courbe_Koch(Fin,Long_Sur_3);
	 Tourner_Gauche(60.0);
	 Tracer_Courbe_Koch(Fin,Long_Sur_3);
	 Tourner_Droite(120.0);
	 Tracer_Courbe_Koch(Fin,Long_Sur_3);
	 Tourner_Gauche(60.0);
	 Tracer_Courbe_Koch(Fin,Long_Sur_3);
      end if;
   end Tracer_Courbe_Koch;
   
   
   procedure Tracer_Flocon_Koch(Finesse:in Positive ;Long:in float) is
   begin
     
      Baisser_Crayon;
      Tracer_Courbe_Koch(Finesse,Long);
      Tourner_Droite(120.0);
      Tracer_Courbe_Koch(Finesse,Long);
      Tourner_Droite(120.0);
      Tracer_Courbe_Koch(Finesse,Long);
      Tourner_Droite(120.0);
   end Tracer_Flocon_Koch;
   
     
begin
   Ouvrir_Fenetre;
   Tourner_Droite(90.0);
   --Tracer_Flocon_Koch(12,120.0);
   Tracer_Flocon_Koch(1,100.0);
   Lever_Crayon;
   Avancer(120.0);
   Tracer_Flocon_Koch(2,100.0);
   Lever_Crayon;
   Avancer(120.0);
   Tracer_Flocon_Koch(3,100.0);
   
end Koch;
