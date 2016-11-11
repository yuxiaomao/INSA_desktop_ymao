with Ada.Text_Io, Ada.Integer_Text_io;
use Ada.Text_Io, Ada.Integer_Text_io;

procedure Decomposition is
   
   --trouver le 1er mot 
   procedure Chercher_Mot (Dans: in String;
			   Trouve: out Boolean;
			   Deb,Fin: out Positive ) is
      X:Integer:=Dans'First;
      Trouve_Fin_Mot:Boolean:=False;
   begin
      --Put(Integer'Image(Dans'First));
      --initialiser de var out
      Trouve:=False;
      --trouver le debut de mot
      while X <= Dans'Last and (not Trouve) loop
	 if Dans(X) /= ' ' then
	    Trouve:=True;
	    Deb:=X;
	    Fin:=X;
	 end if;
	 X:=X+1;	 
      end loop;
      
      --trouver la fin de mot
      while X <= Dans'Last and (not Trouve_Fin_Mot) loop
	 if Dans(X)/=' 'then
	    Fin:=X;
	    --Put("Fin"&Integer'Image(X));
	 else
	    Trouve_Fin_Mot:=True;
	 end if;
	 X:=X+1;
      end loop;

   end Chercher_Mot;
   
   --tester une chaine
   procedure Tester_Chercher_Mot(Dans: in String) is
      Trouve:Boolean;
      Deb:Positive:=1;
      Fin:Positive:=1;
   begin
      Chercher_Mot(Dans,Trouve,Deb,Fin);
      if Trouve then
	 Put_Line("deb="&Integer'Image(Deb)
		    &"fin="&Integer'Image(Fin));
      else
	 Put_Line("pas de mot possible");
      end if;
   end Tester_Chercher_Mot;
   
   --tester plusieur chaine de plusieur type
   procedure Tester_Proc_Chercher_Mot is
   begin
      Tester_Chercher_Mot("");
      Tester_Chercher_Mot("    ");    
      Tester_Chercher_Mot("chien");
      Tester_Chercher_Mot(" chien");
      Tester_Chercher_Mot("chien ");
      Tester_Chercher_Mot("un chien");
   end Tester_Proc_Chercher_Mot;
   
   
   Trouve:Boolean;
   Deb:Positive;
   Fin:Integer;
   Long:Integer:=1;
   Dans:String(1..100);
   Nbr_Mot:Integer;
begin
   --Tester_Proc_Chercher_Mot;
   while Long /= 0 loop
      Put_Line("taper une phrase,taper entree pour quitter:");
      Get_Line(Dans,Long);
      Deb:=1;
      Fin:=0;
      Nbr_Mot:=0;
      Trouve:=True;
      while Fin<long loop
	 Chercher_Mot(Dans(Fin+1..Long),Trouve,Deb,Fin);
	 --Put_Line("deb="&Integer'Image(Deb)&"fin="&Integer'Image(Fin));
	 if Trouve then
	    Nbr_Mot:=Nbr_Mot+1;
	    Put_Line(Dans(Deb..Fin));
	 else
	    Fin:=Long;
	 end if;
      end loop;
      Put_Line("nombre de mot est:"& Integer'Image(Nbr_Mot));
   end loop;
end Decomposition;

