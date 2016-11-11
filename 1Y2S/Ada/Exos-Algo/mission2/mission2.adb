
with Gada.Text_IO;


procedure Mission2 is
   
   --
   --premiere partie
   --
   type T_Intervalle is record
      -- il faut toujour inf < sup!!!
      Inf:Float;
      Sup:Float;
   end record;
   
   
   function Est_Inclus (A:T_Intervalle;B:T_Intervalle) return Boolean is
   begin
      return A.Inf >= B.Inf and A.Sup <= B.Sup ;
   end Est_Inclus;
   
   
   function Disjoints (A:T_Intervalle;B:T_Intervalle) return Boolean is
   begin
      return A.sup < B.Inf or  A.inf > B.Sup ;
   end Disjoints ;
   
   procedure Afficher_Relation (A:T_Intervalle;B:T_Intervalle) is
   begin
      if Est_Inclus(A=>A,B=>B)=true then
	 Gada.Text_IO.Put_Line(Aff=>"A est inclus dans B");
      elsif Est_Inclus(A=>B,B=>A)=True then
	 Gada.Text_IO.Put_Line(Aff=>"B est inclus dans A");
      elsif Disjoints(A=>A,B=>B) then
	 Gada.Text_IO.Put_Line(Aff=>"A et B sont disjoints");
      else
	 Gada.Text_IO.Put_Line(Aff=>"A et B ne sont pas disjoints et aucun n'est inclus dans l'autre");
      end if;
      
			       
      
   end Afficher_Relation;
   
   
   --
   --deuxieme partie
   --
   
   type T_Prod is record
      pre:T_Intervalle;
      sec:T_Intervalle;
      
   end record;
   
   
   function Prod_Est_Inclus (A:T_Prod;B:T_Prod)return boolean is
   begin
   return Est_Inclus(A=>A.pre,B=>B.pre) and Est_Inclus(A=>A.sec,B=>B.sec);
   end Prod_Est_Inclus;
   
   
   
   
   
   
   
   
   C:constant T_Intervalle := (Inf=>5.0,Sup=>10.0);
   D:constant T_Intervalle := (Inf=>7.0,Sup=>8.0);
   E:constant T_Intervalle := (Inf=>4.0,Sup=>6.0);
   
   
begin
   
   -- null;
   
   Afficher_Relation(A=>C,B=>D);
   Afficher_Relation(A=>D,B=>C);
   Afficher_Relation(A=>C,B=>E);
   Afficher_Relation(A=>D,B=>E);
   
   
   
end Mission2;
