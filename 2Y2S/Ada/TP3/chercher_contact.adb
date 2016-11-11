with Pointeurs_De_Strings;
use Pointeurs_De_Strings;

procedure Chercher_Contact (Dans: in String;
			    Nom,Prenom,Ville,Spec,Tel:out P_String) is
  
   -----------------------------------------------------
   --trouver le 1er mot-------------------------------- 
   procedure Chercher_Mot (Dans: in String;
			   Trouve: out Boolean;
			   Deb,Fin: out Integer ) is
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
   ----------------------------------------------
   -----------------------------------------------
   
   Trouve:Boolean;
   Deb:integer;
   Fin:Integer;
   Long:Integer:=1;
begin
    ----initialisation
   Nom:=new String'("");
   Prenom:=new String'("");
   Ville:=new String'("");
   Spec:=new String'("");
   Tel:=new String'("");
   
   
   
   
   
   Chercher_Mot(Dans,Trouve,Deb,Fin);
   if Trouve then Nom.all:=Dans(Deb..Fin);
   end if;
   Chercher_Mot(Dans(Fin+1..Dans'Last),Trouve,Deb,Fin);
   if Trouve then Prenom.all:=Dans(Deb..Fin);
   end if; 
   Chercher_Mot(Dans(Fin+1..Dans'Last),Trouve,Deb,Fin);
   if Trouve then Ville.all:=Dans(Deb..Fin);
   end if;
   Chercher_Mot(Dans(Fin+1..Dans'Last),Trouve,Deb,Fin);
   if Trouve then Spec.all:=Dans(Deb..Fin);
   end if;
   Chercher_Mot(Dans(Fin+1..Dans'Last),Trouve,Deb,Fin);
   if Trouve then Tel.all:=Dans(Deb..Fin);
   end if;
end Chercher_Contact;

