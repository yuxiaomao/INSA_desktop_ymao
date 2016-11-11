with Ada.Text_Io, Unchecked_Deallocation;
use  Ada.Text_Io;

package body Gen_Tas is

   Tentative_D_Acces_Avant_La_Racine : exception;

   procedure Creer(T : out Tas) is
      --cree un tas vide
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Creer;

   procedure Free is new Unchecked_Deallocation(Rec_Tas, Tas);

   procedure Desallouer(T : in out Tas) is
   begin
      Free(T);
   end Desallouer;


   function Taille(T : in Tas) return Natural is
      --retourne le nb d'elements contenus dans le tas

   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Taille;


   function Racine(T : in Tas) return Element is
      --retourne le plus petit element

   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Racine;


   function Appartient(R : in Element; T : in Tas) return Boolean is
      --test d'appartenance

   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Appartient;


   function Valeur_De(R : in Element; T : in Tas) return Valeur is
      --retourne la valeur d'un element donne

   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Valeur_De;

   --sous-programmes internes necessaires a l'insertion, a la suppression et a l'actualisation

   function Position_Pere(Position_Fils : in Position) return Position is
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Position_Pere;

   procedure Move_Up(Pos_Fils : in Position; T : in out Tas) is
      Pos_Pere : Position; Fils, Pere     : Rec_Element;
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Move_Up;

   procedure Move_Down(Pos_Pere : in Position; T : in out Tas) is
      Pos_Fd, Pos_Fils : Position; Fd, Fils, Pere : Rec_Element;
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANT
   end Move_Down;


   procedure Inserer(R : in Element; V : in Valeur; T : in out Tas) is
      --insere un nouveau noeud
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Inserer;

   procedure Supprimer(R : in Element; T : in out Tas) is
      --supprime un noeud
      Pos : Position;
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Supprimer;

   procedure Actualiser(R : in Element; New_Val : in Valeur; T : in out Tas) is
      --modifie la valeur d'un noeud et le reclasse dans le tas
      Pos     : Position; -- position de l'element a actualiser
      Old_Val : Valeur;   -- ancienne valeur
   begin
      --<<<<   A COMPLETER PAR LES ETUDIANTS
   end Actualiser;

   procedure Put(T : in Tas) is
      Taille_Maxi : constant positive:=  2**6-1;

      procedure Put90(P: Positive; Espacement : in String) is
      --affichage en position couchee (ne doit etre utilise que si le tas est petit (~63 elements au plus)
         Decalage : String := "    ";
      begin
         if P >= 1 and then P <= T.all.Cardinal then
            Put90(2*P+1, Decalage & Espacement);
            Ada.Text_Io.Put(Espacement);
            Put(Element_To_String(T.Elements(P).Nom));
            Put(Valeur_To_String( T.Elements(P).Val));
            New_line;
            Put90(2*P,   Decalage & Espacement);
         end if;
      end Put90;

   begin --put
      if T.Cardinal > Taille_Maxi then
         Put("Ce tas est trop grand pour un affichage console");
      else
         New_Line;
         Put90(1,"");  --affichage a 90 degres a partir du bord gauche de l'écran
         New_Line;
      end if;
   end Put;

end Gen_Tas;

   