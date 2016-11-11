with Ada.Text_Io; use Ada.Text_Io;
with Tas_Gen;
with Afficher_Test;

procedure Tester_Tas_Gen is
   
   -----------------------------------
   --definition du tas des integer
   function Cle_De_Integer(E:in Integer) return Integer is begin return E; end;
   
   procedure Liberer_Integer(E:in out Integer) is begin null; end;
   
   
   package Tas_Integer is new Tas_Gen(Integer,Integer,Cle_De_Integer,"<",
				      Liberer_Integer,Integer'Image);
   use Tas_Integer;
   
   -----------------------------------
   
   T:Un_Tas(20);
   E:Integer;
begin
   --un tas vide
   begin
      Afficher_Test("1.1, Tester Est_vide", "TRUE", Boolean'Image(Est_Vide(T)));
      Afficher_Test("1.2, Tester Cardinal", "0", Integer'Image(Cardinal(T)));
      
      Afficher_Test("1.3, Tester Affichage","", Tas_To_String(T));
      Put_Line("1.4, Tester Racine");
      Enlever_Racine(T,E);
      Put_Line("Si tu vois ceci, il y a un problème..");
   exception
      when Tas_Vide => Put_Line("Exception Tas_Vide levée! OK!");
   end;
   
   -- 1 seul element
   begin
      Ajouter(50,T);
      Afficher_Test("2.1, Tester Est_vide", "FALSE", Boolean'Image(Est_Vide(T)));
      Afficher_Test("2.2, Tester Cardinal", "1", Integer'Image(Cardinal(T)));
      Afficher_Test("2.3, Tester Affichage","50", Tas_To_String(T));
      Enlever_Racine(T,E);
      Afficher_Test("2.4, Tester Racine","50", Integer'Image(E));
   end;
   
   --tester l'ordre
   begin
      Ajouter(50,T);
      Ajouter(100,T);
      Ajouter(80,T);
      Ajouter(60,T);
      Ajouter(40,T);
      Ajouter(90,T);
      Afficher_Test("3.1, Tester Cardinal", "6", Integer'Image(Cardinal(T)));
      Afficher_Test("3.2, Tester Affichage","40 50 80 100 60 90", Tas_To_String(T));
      Enlever_Racine(T,E);
      Afficher_Test("3.3, Tester Racine","40", Integer'Image(E));
      Afficher_Test("3.4, Tester Racine enlevée","50 60 80 100 90", Tas_To_String(T));
      Enlever_Racine(T,E);
      Afficher_Test("3.5, Tester Racine enlevée","60 90 80 100", Tas_To_String(T));
      Afficher_Test("3.6, Tester Cardinal","4", Integer'Image(Cardinal(T)));
      Liberer(T);
      Afficher_Test("3.7, Tester Liberer","", Tas_To_String(T));
   end;
   
   --tester 80permute avec60 puis le 60 permute avec50
   begin
      Ajouter(30,T);
      Ajouter(80,T);
      Ajouter(50,T);
      Ajouter(60,T);
      Enlever_Racine(T,E);
      Afficher_Test("4, Tester ","50 80 60", Tas_To_String(T));
   end;
end Tester_Tas_Gen;
