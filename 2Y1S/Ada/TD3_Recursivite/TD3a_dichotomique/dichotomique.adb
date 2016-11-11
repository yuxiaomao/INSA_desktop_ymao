with Ada.Text_Io, Ada.Integer_Text_io;
use Ada.Text_Io, Ada.Integer_Text_io;

procedure Dichotomique is
   
   type T_Vecteur is array (Integer range <>) of Integer;
   
   procedure Recherche (V:in T_Vecteur;
			Val:in Integer;
			Trouve:out Boolean;
			Ind:out integer) is
      M:Integer;--indice du milieu
   begin
      if V'Length <= 0 then
	 Trouve:=False;
	 Ind:=0;--signifie qu'on n'a pas trouve
      else
	 M:=(V'First+V'Last)/2; --1~3,2; 1~4,2;
	 if Val=V(M) then
	    Trouve:=True;
	    Ind:=M;
	 elsif Val<V(M) then
	    Recherche(V(V'First..M-1),Val,Trouve,Ind);
	 else
	    Recherche(V(M+1..V'Last),Val,Trouve,Ind);
	 end if;
      end if;
   end Recherche;
   
   procedure Un_Recherche(V:in T_Vecteur; Val:in Integer) is
      Trouve:Boolean;
      Ind:Integer;
   begin
      Recherche(V,Val,Trouve,Ind);
      if Trouve then
	 Put_Line("resultat obtenu:"&"true"&Integer'Image(Ind));
      else
	 Put_Line("resultat obtenu:"&"false"&Integer'Image(Ind));
      end if;
   end Un_Recherche;

   
   procedure Tester_Recherche is
      V_1:T_Vecteur(2..1);--tableau vide
      V_2:T_Vecteur(1..10):=(1,3,5,7,9,11,13,15,17,19);
   begin
      Put_Line("tableau vide,resultat attendu: false, 0. Ce 0 signifie not trouve");
      Un_Recherche(V_1,3);
      Put_Line("resultat attendu: false, 0. Ce 0 signifie not trouve");
      Un_Recherche(V_2,4);
      Put_Line("resultat attendu: true, 4");
      Un_Recherche(V_2,7);
      Put_Line("resultat attendu: true, 9 ");
      Un_Recherche(V_2,17);
      Put_Line("resultat attendu: true, 1 ");
      Un_Recherche(V_2,1);
   end Tester_Recherche;
   

   
begin
   
   Tester_Recherche;
   
   
end Dichotomique;
