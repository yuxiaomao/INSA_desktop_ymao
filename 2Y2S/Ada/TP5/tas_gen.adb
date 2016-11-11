with Ada.Text_Io; use Ada.Text_Io;
--with Unchecked_Deallocation;

package body Tas_Gen is
   
   -----------------------------------
   
   procedure Liberer(T : in out Un_Tas) is
   begin
      for I in 1..T.Cardinal loop
	 Liberer_Element(T.Les_Elements(i));
      end loop;
      T.Cardinal:=0;
   end Liberer;

   
   -----------------------------------
   --ne sais pas encore si je le laisse...
   function Est_vide (T : in Un_Tas) return Boolean is
   begin
      return T.Cardinal=0;
   end Est_Vide;

   ----------------------------------
   function Cardinal(T : in Un_Tas) return Natural is
   begin
      return T.Cardinal;
   end Cardinal;
   
   -----------------------------------
   --pour permuter E1 et E2 dans un tas-- 
   --si l'un n'est pas dans tas, on fait rien--
   procedure Permuter_Element(T:in out Un_Tas; Ind1, Ind2:in Positive) is
      Aux:Element;
   begin
      if T.Cardinal >= Ind1 and T.Cardinal >= Ind2 then
	 Aux:=T.Les_Elements(Ind1);
	 T.Les_Elements(Ind1):=T.Les_Elements(Ind2);
	 T.Les_Elements(Ind2):=Aux;
      end if;
   end Permuter_Element;
   
   --pour faire descendre un element à partir de sa position haute--
   procedure Descendre_Element(T:in out Un_Tas; Indice: in Positive) is
   begin
      if Indice*2 > T.Cardinal then --pas de fils
	 null;
      elsif Indice*2 = T.Cardinal then --un seul fils
	 if Cle_De(T.Les_Elements(Indice)) < Cle_De(T.Les_Elements(Indice*2)) then
	    null;
	 else
	    Permuter_Element(T,Indice,Indice*2);
	 end if;
      else --2fils
	 if Cle_De(T.Les_Elements(Indice)) < Cle_De(T.Les_Elements(Indice*2)) 
	   and Cle_De(T.Les_Elements(Indice)) < Cle_De(T.Les_Elements(Indice*2+1)) 
	 then
	    null;
	 elsif Cle_De(T.Les_Elements(Indice)) < Cle_De(T.Les_Elements(Indice*2))
	 then --permuter avec fils droite
	    Permuter_Element(T,Indice,Indice*2+1);
	    Descendre_Element(T,Indice);--verifier si fils est bien placé
	    Descendre_Element(T,Indice*2+1);--traitement du fils droite
	 else --permuter avec fils gauche
	    Permuter_Element(T,Indice,Indice*2);
	    Descendre_Element(T,Indice);--verifier si fils est bien placé
	    Descendre_Element(T,Indice*2);--traitement du fils gauche
	 end if;
      end if;
   end Descendre_Element;
   
   
   procedure Enlever_Racine(T : in out Un_Tas; E : out Element) is
   begin
      if Est_Vide(T) then
	 raise Tas_Vide;
      elsif T.Cardinal=1 then
	 E:=T.Les_Elements(1);
	 Liberer(T);
      else
	 E:=T.Les_Elements(1);
	 T.Les_Elements(1):=T.Les_Elements(T.Cardinal);
	 --copier? si pointeur on ne peut pas liberer cette case cardinal
	 --Liberer_Element(T.Les_Elements(T.Cardinal));
	 T.Cardinal:=T.Cardinal-1;
	 Descendre_Element(T,1);--faire descendre la racine
      end if;
   end Enlever_Racine;
   
   ---------------------------------------
   --faire monter unn element à partir de sa position basse--
   --T ne dois pas etre vide
   procedure Monter_Element (T : in out Un_Tas; Indice:in Positive) is
   begin
      if T.Cardinal=0 then
	 raise Tas_Vide;
      elsif T.Cardinal=1 then
	 null;
      elsif Indice=1 then --s'il est déjà racine
	 null;
      elsif Cle_De(T.Les_Elements(Indice)) < Cle_De(T.Les_Elements(Indice/2))
      then --si fils plus petit que pere
	 Permuter_Element(T,Indice,Indice/2);
	 Monter_Element(T,Indice/2);
	 --traitement du pere, pas besion de traiter lui
				    --else null;
      end if;
   end Monter_Element;
   
   
   procedure Ajouter(E : in Element; T : in out Un_Tas) is
   begin
      if T.Cardinal=T.Dimension then
	 raise Tas_Plein;
      else
	 T.Cardinal:=T.Cardinal+1;--modifier la taille
	 T.Les_Elements(T.Cardinal):=E;--remplire la dernier case
	 Monter_Element(T,T.Cardinal);
      end if;
   end Ajouter;
   

   ----------------------------------
   --affichage dans l'ordre du tableau
   function Tas_To_String(T : in Un_Tas) return String is
      
   begin
      if T.Cardinal=0 then
	 return "";
      else
	 return Tas_To_String((T.Dimension,T.Cardinal-1,T.Les_Elements))
	   &Element_To_String(T.Les_Elements(T.Cardinal));
      end if;
   end Tas_To_String;
   

end Tas_Gen;
