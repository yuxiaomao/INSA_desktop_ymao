with Ada.Text_Io, Ada.Integer_Text_io;
use Ada.Text_Io, Ada.Integer_Text_io;

procedure Simulation is
   
   type Tache;
   type P_Tache is access Tache;
   type Tache is record
      Num:Integer;
      Duree:Integer;
      Suiv:P_Tache;
   end record;
   
   procedure Creer_Tache(Fin:out P_Tache) is
      Deb:P_Tache:=null;
      Duree:Integer;
      Nbr:Integer;
   begin
      Fin:=null;
      Put("Veuillez saisir le nombre de tache:");
      Get(Nbr);
      for I in 1..Nbr loop
	 Put("Veuillez saisir la duree de tache numero"&Integer'Image(I)&":");
	 Get(Duree);
	 if I=1 then
	    Deb:=new Tache'(I,Duree,null);
	    Fin:=Deb;
	 else
	    Fin.all.Suiv:=new Tache'(I,Duree,null);
	    Fin:=Fin.all.Suiv;
	 end if;
      end loop;
      
      if Nbr>=0 then
	 Fin.all.Suiv:=Deb;
      end if;
   end Creer_Tache;
   
   
   --afficher la liste
   procedure Lire_Tache(T:in P_Tache) is
      Num_Deb:Integer;
      Aux:P_Tache:=T;
   begin
      if T /= null then
	 Aux:=T.all.Suiv;
	 --T represent le dernier, mais il faut commencer par le premier
	 Num_Deb:=Aux.all.Num;
	 Put_Line("Num"&Integer'Image(Aux.all.Num)
		    &",Duree"&Integer'Image(Aux.all.Duree));
	 Aux:=Aux.all.Suiv;
	 while Aux.all.Num /= Num_Deb loop
	    Put_Line("Num"&Integer'Image(Aux.all.Num)
		       &",Duree"&Integer'Image(Aux.all.Duree));
	    Aux:=Aux.all.Suiv;
	 end loop;
      end if;
   end Lire_Tache;
   
   
   --procedure recursif
   procedure Simuler (L:in out P_Tache;Q:in Integer) is
   begin
      if L =null then
	 null;
      elsif L.all.Suiv=L then
	 Put_Line("numero"&Integer'Image(L.all.Num));
      else
	 --Put("num"&Integer'Image(L.all.Suiv.all.Num));
	 L.all.Suiv.all.Duree:=L.all.Suiv.all.Duree - Q;
	 --Put("duree"&Integer'Image(L.all.Suiv.all.Duree));
	 if L.all.Suiv.all.Duree <=0 then
	    Put_Line("numero"&Integer'Image(L.all.Suiv.all.Num));
	    L.all.Suiv:=L.all.Suiv.all.Suiv;
	 else
	    L:=L.all.Suiv;
	 end if;
	 Simuler(L,Q);
      end if;
   end Simuler;
   
   
   function Copier(L_Origine: in P_Tache) return P_Tache is
      Deb:P_Tache:=null;
      Fin:P_Tache:=null;
      Aux:P_Tache:=L_Origine;
      Num_Deb:Integer;
   begin
      if L_Origine =null then
	 null;
      else
	 --l commence par le dernier, aux commence par le premier
	 Aux:=Aux.all.Suiv;
	 Num_Deb:=Aux.all.Num;
	 Deb:=new Tache'(Aux.all.Num,Aux.all.Duree,null);
	 Fin:=Deb;
	 Aux:=Aux.all.Suiv;
	 while Aux.all.Num /= Num_deb loop
	    
	    Fin.all.Suiv:=new Tache'(Aux.all.Num,Aux.all.Duree,null);
	    Fin:=Fin.all.Suiv;
	    Aux:=Aux.all.Suiv;
	 end loop;
	 Fin.all.Suiv:=Deb;
      end if;
      return Fin;
   end Copier;
   


   --programme principal-- 
   Liste:P_Tache;
   Liste_Copie:P_Tache;
   Q:Integer;
begin
   
   Creer_Tache(Liste);
   Put_Line("En voici votre liste:");
   Lire_Tache(Liste);
   Put("Veuillez saisir la valeur de Quantum, 0 pour quitter:");
   Get(Q);
   while Q/=0 loop
      Liste_Copie:=Copier(Liste);
      --Lire_Tache(Liste_copie);
      Simuler(Liste_copie,Q);
      Put("Veuillez saisir la valeur de Quantum, 0 pour quitter:");
      Get(Q);
   end loop;
   
   
end Simulation;
