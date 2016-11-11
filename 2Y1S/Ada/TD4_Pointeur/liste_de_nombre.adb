with Ada.Text_Io, Ada.Integer_Text_io;
use Ada.Text_Io, Ada.Integer_Text_io;

procedure Liste_De_Nombre is
   
   type Element;
   type P_Element is access Element;
   type Element is record
      Info:Integer;
      Suiv:P_Element;
   end record;
   
   procedure Creer_Liste(L:out P_Element) is
      Fin:P_Element:=null;
      Val:Integer;
   begin
      Put_line("Veillez saisir integer dans la liste. 0 pour finir:");
      L:=null;
      Get(Val);
      if Val /= 0 then
	 L:=new Element'(Val,null);
	 Fin:=L;
	 Get(Val);
	 while Val/=0 loop
	    Fin.all.suiv:=new Element'(Val,null);
	    Fin:=Fin.all.Suiv;
	    Get(Val);
	 end loop;
      end if;
   end Creer_Liste;
   
   
   procedure Afficher(L:in P_Element) is
      Aux:P_Element:=L;
   begin
      while Aux /=null loop
	 Put(Integer'Image(Aux.all.Info));
	 Aux:=Aux.all.Suiv;
      end loop;
   end Afficher;
   
   
   
   procedure Afficher_Inv(L:in P_Element) is
   begin
      if L/=null then
	 Afficher_Inv(L.all.Suiv);
	 Put(Integer'Image(L.all.Info));
      end if;
   end Afficher_Inv;
   

   
   Liste:P_Element:=null;
begin
   Creer_Liste(Liste);
   Afficher(Liste);
   New_Line;
   Afficher_Inv(Liste);
end Liste_De_Nombre;
