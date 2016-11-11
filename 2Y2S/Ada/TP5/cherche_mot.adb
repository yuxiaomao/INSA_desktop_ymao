procedure Cherche_Mot(S : in String; Separateur : in character; Deb, Fin: out Integer; Trouve : out Boolean) is

begin
   Trouve := FALSE;
   Deb    := S'First;
   while Deb <= S'Last and then S(Deb)=Separateur loop
      Deb := Deb + 1;
   end loop;
   -- le debut est la position qui suit le dernier separateur rencontre
   Trouve := (Deb <= S'last) ;

   if Trouve then      -- si on tient le debut du mot, on cherche sa fin
      Fin  := Deb;
      while Fin <= S'Last and then S(Fin) /= Separateur loop
         Fin := Fin+1;
      end loop;
      Fin := Fin-1;
      --la fin est la position qui precede le premier separateur rencontre
   end if;
end Cherche_Mot;

