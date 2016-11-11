with Ada.Text_io;                 use Ada.Text_Io;
with Arbre_Bin_Recherche_Cle_G;
with Cherche_Mot;


procedure Tri_Arbre is
   
   function Identique(E:in Integer) return Integer is
   begin return E;end Identique;
   
   procedure Liberer_Entier(E:in Integer) is 
   begin null; end Liberer_Entier;
   -----------------------------------------------------------------------------
   -- Instanciation Arbre Binaire Générique sur des entiers
   Package Abr_Entiers is new Arbre_Bin_Recherche_Cle_G(Integer,Integer,
							Identique,"<","=",
							Liberer_Entier,
							Integer'Image);
   use Abr_Entiers;
   --  
   --------------------------------
    --------------tableau du resultat de tri------
   type Tab_Resu is array(Integer range <>) of Integer;
   type Un_Resu_Tri(N:Integer) is record
      Tab:Tab_Resu(1..N);
      Taille:Integer:=0; --pour ne pas afficher le reste du tableau
   end record;
   ----------------------------------------------
   
   
   procedure Creer_Arbre(Nom_Fichier:in String; A:out Arbre) is
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
	    Inserer(Integer'Value(Ligne(Deb..Fin-1)),A);
	 end if;
      end loop;
   end Creer_Arbre;
   
   -----------------------------------
   
   procedure Trier_Arbre(A:in out Arbre; Resu:out Un_Resu_Tri) is
      procedure String_To_Tab (S:in String; Resu:out Un_Resu_Tri) is
	 Deb,Fin:Integer;
	 Trouve:Boolean:=True;
	 Indice:Integer:=1;
      begin
	 while Trouve loop
	    Cherche_Mot(S,' ',Deb,Fin,Trouve);
	    if Trouve then
	       Integer'Value(S(Deb..Fin));
	       Resu.Tab(Indice):=Integer'Value(S(Deb..Fin));
	       Resu.Taille:=Resu.Taille +1;
	       Indice:=Indice+1;
	    end if;
	 end loop;
      end String_To_Tab;
      
   begin
      String_To_Tab(Arbre_To_String,Resu)
   end Trier_Tas;
