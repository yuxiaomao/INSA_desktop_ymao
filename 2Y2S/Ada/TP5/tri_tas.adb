with Ada.Text_Io ;  use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Cherche_Mot;
with Tas_Gen;

procedure Tri_Tas is
   
   ----------------creer tas_integer-------------
   function Cle_De_Integer(E:in Integer) return Integer is begin return E; end;
   
   procedure Liberer_Integer(E:in out Integer) is begin null; end;
   
   package Tas_Integer is new Tas_Gen(Integer,Integer,Cle_De_Integer,"<",
				      Liberer_Integer,Integer'Image);
   use Tas_Integer;
   -----------------------------------------------
   
   --------------tableau du resultat de tri------
   type Tab_Resu is array(Integer range <>) of Integer;
   type Un_Resu_Tri(N:Integer) is record
      Tab:Tab_Resu(1..N);
      Taille:Integer:=0; --pour ne pas afficher le reste du tableau
   end record;
   ----------------------------------------------
   
   
   
   procedure Creer_Tas(Nom_Fichier:in String; T:out Un_Tas) is
      F:File_Type;
      Ligne:String(1..100);
      Last:Natural;
      Deb,Fin:Integer;
      Trouve:boolean;
   begin
      Open(F,In_File,Nom_Fichier);
      while not End_Of_File(F) loop
	 Get_Line(F,Ligne,Last);
	 Cherche_Mot(Ligne(1..Last),' ',Deb,Fin,Trouve);
	 --Put_Line(Integer'Image(Deb)&Integer'Image(Fin));
	 --Put_Line(Ligne(Deb..Fin));
	 if Trouve=True then
	    Ajouter(Integer'Value(Ligne(Deb..Fin-1)),T);
	 end if;
      end loop;
   end Creer_Tas;
   
   ------------------------------------------------------
   
   procedure Trier_Tas(T:in out Un_Tas; Resu:out Un_Resu_Tri) is
      E:Integer;
      Indice:Integer:=1;
   begin
      while (not Est_Vide(T)) and Indice <= Resu.Tab'last loop
	 Put_Line(Integer'Image(Indice));
	 Enlever_Racine(T,E);
	 Resu.Tab(Indice):=E;
	 Resu.Taille:=Resu.Taille +1;
	 Indice:=Indice+1;
      end loop;
   end Trier_Tas;
   
   ---------------------------------------------------------
   procedure Ecrire_Resultat(Resu:in Un_Resu_Tri; Nom_Fichier:in String) is
      F:File_Type;
   begin
      Open(F,Out_File,Nom_Fichier);
      Put(F,"taille du resu");
      Put(F,Resu.Taille);
      New_Line(F);
      for I in 1..Resu.Taille loop
	 Put(F,Resu.Tab(I));
	 New_Line(F);
      end loop;
      Close(F);
   end Ecrire_Resultat;
   
   ---------------------------------------------------------
   
   
   
   T:Un_Tas(100);
   Resu:Un_Resu_Tri(100);
begin
   Creer_Tas("data_10.txt",T);
   Put_Line(Tas_To_String(T));
   Put_Line("..");
   Trier_Tas(T,Resu);
   for I in 1..Resu.Taille loop
      Put(Resu.Tab(I));
   end loop;
   Ecrire_Resultat(Resu,"resu.txt");
   
   
   
end Tri_Tas;
