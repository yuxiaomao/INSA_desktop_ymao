with Ada.Text_Io , Ada.Integer_Text_Io ;
use Ada.Text_Io , Ada.Integer_Text_Io ;

procedure kaprekar is
   
   type T_Kaprekar is array (Integer range <>) of Integer;
   
   function  Calcul_Kaprekar (Nombre:Integer) return Integer is
      Tab_4_Chiffre:T_Kaprekar(1..4);
      --on n'a que besion changer ce 4 pour plus ou moins de chiffres
      N:Integer:=Nombre;
      --prend la valeur de nombre et ainsi devient un variable
      K:Integer:=-1;
      Trouve:Boolean:=False;
      N_Itera:Integer:=0;
      
      --decomposer n en 4 chiffres,inverser(5463 à 3645)
      procedure Decomposer (N:in Integer;Tab:in out T_Kaprekar) is
	 N_Var:integer:=N ;
      begin
	 for X in Tab'Range loop
	    Tab(X):=N_var mod 10;
	    N_var:=N_var / 10;
	 end loop;
      end Decomposer;
      
      procedure Tester_Dec is
      begin
	 Decomposer(5463 , Tab_4_Chiffre);
	 Put_Line("Tester_Dec");
	 Put_Line("resultat attendu: 3 6 4 5");
	 Put_Line("resultat obtenu:"&
		    Integer'Image(Tab_4_Chiffre(1))&
		    Integer'Image(Tab_4_Chiffre(2))&
		    Integer'Image(Tab_4_Chiffre(3))&
		    Integer'Image(Tab_4_Chiffre(4)));
      end Tester_Dec;
      
      
      --pour les classer dans ordre(3645 à 3<4<5<6)
      procedure Tirer (Tab:in out T_Kaprekar) is
	 A:Integer:=0;
	 --un variable de passage
      begin
	 for X in Tab'first .. (Tab'Last - 1) loop
	    for Y in (X+1) .. Tab'Last loop
	       if Tab(X)>Tab(Y) then
		  A:=Tab(X);
		  Tab(X):=Tab(Y);
		  Tab(Y):=A;
	       end if;
	    end loop;
	 end loop;
      end Tirer;
      
      procedure Tester_tir is
      begin
	 tirer(Tab_4_Chiffre);
	 Put_Line("Tester_tir");
	 Put_Line("resultat attendu: 3 4 5 6");
	 Put_Line("resultat obtenu:"&
		    Integer'Image(Tab_4_Chiffre(1))&
		    Integer'Image(Tab_4_Chiffre(2))&
		    Integer'Image(Tab_4_Chiffre(3))&
		    Integer'Image(Tab_4_Chiffre(4)));
      end Tester_tir;
      
      
      --kalcul de k
      function Recomposer(Tab:T_Kaprekar) return Integer is
	 N1:Integer:=0;--6543
	 N2:Integer:=0;--3456
      begin
	 for X in Tab'Range loop
	    N1:=10*N1 + Tab(Tab'Last+1-X);
	    N2:=10*N2 + Tab(X);
	 end loop;
	 return N1-N2;
      end Recomposer;
      
      procedure Tester_Rec is
      begin
	 Put_Line("Tester_Rec");
	 Put_Line("resultat attendu: 3087");
	 Put_Line("resultat obtenu:"& Integer'Image(Recomposer(Tab_4_Chiffre)));
      end Tester_Rec;
      
      
      --si on trouve le k final? soit k=1,soit k=n.
      function Trouver(N,K:Integer) return Boolean is
      begin
	 return K=0 or N=K ;
      end Trouver;
      
      procedure Tester_Tro is
      begin
	 Put_Line("Tester_Trouver");
	 Put_Line("n=3087,k=0,resultat attendu:true");
	 if Trouver(3087,0) then Put_Line("true");
	 else Put_Line("false");
	 end if;
	 Put_Line("n=k=6174,resultat attendu:true");
	 if Trouver(6174,6174) then Put_Line("true");
	 else Put_Line("false");
	 end if;
	 Put_Line("n=8352,k=6174,resultat attendu:false");
	 if Trouver(8352,6174) then Put_Line("true");
	 else Put_Line("false");
	 end if;
      end Tester_Tro;
      
      --procedure principal--
   begin
      --Tester_Dec;
      --Tester_Tir;
      --Tester_Rec;
      --Tester_Tro; 
      while (not Trouve) and (N_Itera<1000) Loop
	 Decomposer(N,Tab_4_Chiffre);
	 Tirer(Tab_4_Chiffre);
	 K:=Recomposer(Tab_4_Chiffre);
	 Trouve:=Trouver(N,K);
	 N:=K;
	 N_Itera:=N_Itera+1;	 
      end loop;
      Put(Integer'Image(N_Itera));
      return K ; 
   end Calcul_Kaprekar;
   
   
   N:Integer:=1;
begin
   Put_Line(Integer'Image(Calcul_Kaprekar(5463)));
   while N /= 0 loop
      Put("Veuillez taper un nombre de 4 chiffre,ou 0 pour quitter:");
      Get(N); 
      Put_Line(Integer'Image(Calcul_Kaprekar(N)));
   end loop;
end Kaprekar;
