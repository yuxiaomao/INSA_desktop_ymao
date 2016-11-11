-- MJ. Huguet - Janvier 2015
-- P. ESQUIROL - D. VIAL
-- VERSION MISE A JOUR 01/02/2013

--fichier tests_piles.adb

with Ada.Text_Io,Ada.Integer_Text_Io, Pile_Entiers, Afficher_Test;
use  Ada.Text_Io,Ada.Integer_Text_Io, Pile_Entiers;

procedure Evaluer_Expression is

   type T_Variables is array (character range 'A'..'Z') of Integer;
   type T_Boolean is array (character range 'A'..'Z') of Boolean;
   Erreur_Manque_Operande:exception;
   Erreur_Manque_Operateur:exception;
   Erreur_Denominateur_Nul:exception;
   Erreur_Symbole_Inconnu:exception;
   Exp_Long_Null:exception;
     
     
   function Calcul(A,B:in Integer; Op:in Character) return Integer is
   begin
      if Op='+' then
	 return A+B;
      elsif Op='-' then
	 return A-B;
      elsif Op='*' then
	 return A*B;
      elsif Op='/' then
	 if B=0 then raise Erreur_Denominateur_Nul;
	 end if;
	 return A/B;
      else
      raise Erreur_Symbole_Inconnu;
      end if;
   end Calcul;
   
   
   
   procedure Eval_ExpPostFixee(Exp:in String;
			      Tab:in T_Variables;
			      Res:out Integer) is
      P:Une_Pile_Entiers;   
      Val1:Integer;
      Val2:Integer;
   begin
      Res:=0;
      
      for X in Exp'Range loop
	 if Exp(X) in 'A'..'Z' then
	    Empiler(Tab(Exp(X)),P);
	 else
	    Val2:=Sommet(P);
	    Depiler(P);
	    Val1:=Sommet(P);
	    Depiler(P);
	    Empiler(Calcul(Val1,Val2,Exp(X)),P);
	 end if;
      end loop;
      Res:=Sommet(P);
      Depiler(P);
      if not Est_Vide(P) then raise Erreur_Manque_Operateur;
      end if;
   --exception
      --when Pile_Vide=> Put_Line("Erreur_Manque_Operande");
      --when Erreur_Symbole_Inconnu => Put_Line("Erreur_Symbole_Inconnu");
      --when Erreur_Denominateur_Nul => Put_Line("Erreur_Denominateur_Nul");
      --when Erreur_Manque_Operateur => Put_Line("Erreur_Manque_Operateur");
   end Eval_ExpPostFixee;
   
   procedure Test_Eval_Exp is
      Valeur_De:T_Variables:=(6,0,5,2,4,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
      Res:Integer:=0;
   begin
      Eval_Exppostfixee("AB+CD-*EFG-/+",Valeur_De,Res);
      Put_Line("resultat:"&Integer'Image(Res));
      Eval_Exppostfixee("+",Valeur_De,Res);
      Eval_Exppostfixee("AB++",Valeur_De,Res);
      Eval_Exppostfixee("AB",Valeur_De,Res);
      Eval_Exppostfixee("AB#",Valeur_De,Res);
      Eval_Exppostfixee("ABB-/",Valeur_De,Res);
   end Test_Eval_Exp;
   
     
   
   
   function Utilisateur(Tab:in T_Variables) return Integer is
      Exp:String(1..50);
      Long:Integer;
      Res:Integer;
   begin
      Get_Line(Exp,Long);
      --Put_Line(Exp&Integer'Image(Long));
      Eval_ExpPostFixee(Exp(1..Long),Tab,Res);
      return Res;
   end Utilisateur;
   
   --celui demande des valeur du A à Z
   function Utilisateur_Var return Integer is
      Tab_Var:T_Variables:=(others=>1);
      Tab_Saisir:T_Boolean:=(others=>False);
      Exp:String(1..50);
      Long:Integer;
      Valeur:Integer;
      Res:Integer;
   begin
      Put_Line("Veuillez saisir expression:");
      Get_Line(Exp,Long);
      if Long=0 then raise Exp_Long_Null;
      end if;
      --quelles sont les characters qu'on veut
      for Indice_Exp in 1..Long loop
	 if Exp(Indice_Exp) in Tab_Saisir'Range then
	    Tab_Saisir(Exp(Indice_Exp)):=True;
	 end if;
      end loop;
      --saisir les valeurs des operandes
      for Indice_Tab in Tab_Saisir'Range loop
	 if Tab_Saisir(Indice_Tab) then
	    Put_Line("Veuillez saisir expression de "&Indice_Tab&" :");
	    Get(Valeur);
	    Tab_Var(Indice_Tab):=Valeur;
	 end if;
      end loop;
      Eval_ExpPostFixee(Exp(1..Long),Tab_Var,Res);
      return Res;
   end Utilisateur_Var;
     
     
   
   Res:Integer:=0;
   Calcul_Fin:Boolean;
begin
   --Test_Eval_Exp;
   Calcul_Fin:=False;
   while not Calcul_Fin loop
      begin
	 Res:=Utilisateur_var;
	 Put_Line("res="&Integer'Image(Res));
	 Calcul_Fin:=True;
      exception
	 when Pile_Vide=> 
	    Put_Line("Erreur_Manque_Operande");Skip_Line;
	 when Erreur_Symbole_Inconnu => 
	    Put_Line("Erreur_Symbole_Inconnu");Skip_Line;
	 when Erreur_Denominateur_Nul => 
	    Put_Line("Erreur_Denominateur_Nul");Skip_Line;
	 when Erreur_Manque_Operateur => 
	    Put_Line("Erreur_Manque_Operateur");Skip_Line;
	 when Exp_Long_Null =>
	    Calcul_Fin:=True;Put_Line("EXIT!");
      end;
   end loop;
   
      
end Evaluer_Expression ;
