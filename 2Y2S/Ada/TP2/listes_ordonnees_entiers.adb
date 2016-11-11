with Ada.Unchecked_Deallocation;

package body Listes_Ordonnees_Entiers is

   -------------------------------------------------------------------------
   function Est_Vide(L : in Une_Liste_Ordonnee_Entiers) return Boolean is
   begin
      return L.Debut = null;
   end Est_Vide;
   -------------------------------------------------------------------------

   -------------------------------------------------------------------------
   function Cardinal(L : in Une_Liste_Ordonnee_Entiers) return Integer is
   begin
      return L.Taille;
   end Cardinal;
   -------------------------------------------------------------------------

   -----------------------------------------------------------------------------
   -- Appartient classique sur une liste simplement chainee (type Lien) ordonnee

   function Appartient_Lien(E : Integer; LL : in Lien) return Boolean is
      Resultat :boolean;
   begin
      if LL = null or else E < LL.all.info then
         Resultat := False;         -- element non trouve
      elsif LL.all.Info = E then
         Resultat := True;          -- element trouve en 1ere place
      else
         Resultat := Appartient_Lien(E, LL.all.Suiv);  -- on cherche plus loin
      end if;
      return Resultat;
   end Appartient_Lien;

   -- Appartient sur le type Une_Liste_Ordonnee_Entiers
   -- On reutilise la fonction classique Appartient_Lien sur L.debut
   function Appartient(E : in integer; L : in Une_Liste_Ordonnee_Entiers) return Boolean is
   begin
      return Appartient_Lien(E, L.Debut);
   end Appartient;
   -------------------------------------------------------------------------

   -------------------------------------------------------------------------
   -- Conversion en chaine de caracteres
   --
   -- sur le type Lien

   function Lien_To_String(LL : in Lien) return String is
   begin
      if LL = null then return "";
                   else return integer'image(LL.all.info) & Lien_To_String(LL.all.suiv);
      end if;
   end Lien_To_String;

   -- sur le type Une_Liste_Ordonnee_Entiers
   function Liste_To_String(L: in Une_Liste_Ordonnee_Entiers) return String is
   begin
      return Integer'Image(L.Taille) & " elements : (" & Lien_To_String(L.Debut) & " )";
   end Liste_To_String;
   -------------------------------------------------------------------------

   -------------------------------------------------------------------------
   -- Insertion ORDONNEE et SANS DOUBLON

   procedure Inserer_Lien(E: in Integer; L: in out Lien) is
   begin
      if L = null then
	 L:=new Cellule'(E,null);
      elsif L.all.Info=E then
	 raise Element_Deja_Present;
      elsif L.all.Info>E then 
	    L:=new Cellule'(E,L);
      else
	    Inserer_Lien(E,L.all.Suiv);
      end if;
   -- On desire une version RECURSIVE
   -- La procedure doit LEVER L'EXCEPTION Element_Deja_Present en
   -- cas de tentative d'insertion d'un doublon
   end Inserer_Lien;



   -------------------------------------------------------------------------
   procedure Inserer(E: in integer; L: in out Une_Liste_Ordonnee_Entiers) is
   begin
      Inserer_Lien(E,L.Debut);
      L.Taille:=L.Taille +1;
   end Inserer;
   -------------------------------------------------------------------------


   -- Instanciation de Ada.Unchecked_Deallocation pour desallouer
   -- la memoire en cas de suppression des elements d'une liste
   -------------------------------------------------------------------------
   procedure Free is new Ada.Unchecked_Deallocation(Cellule, Lien);
   -------------------------------------------------------------------------
   procedure Supprimer_Lien(E : in Integer; L: in out Lien) is
      Recup : Lien;
   begin
      if L = null or else E < L.All.Info then
         raise Element_Non_Present;
      elsif E = L.All.Info then
         Recup := L;           -- on repere la cellule a recycler
         L     := L.All.Suiv;  -- on modifie le debut de la liste
         Free(Recup);          -- on recupere la memoire
      else
         Supprimer_Lien(E, L.all.suiv);
      end if;
   end Supprimer_Lien;
   -------------------------------------------------------------------------
   procedure Supprimer(E: in integer; L: in out Une_Liste_Ordonnee_Entiers) is
   begin
      Supprimer_Lien(E, L.debut);
      L.Taille := L.Taille - 1;
   end Supprimer;
   -------------------------------------------------------------------------
   
   
   procedure Copier_Lien(L1:in Lien;L2:out Lien) is
   begin
      if L1=null then
	 L2:=null;
      else
	 L2:=new Cellule'(L1.all.Info,null);
	 Copier_Lien(L1.all.Suiv,L2.all.suiv);
      end if;
   end Copier_Lien;
   
   procedure Copier(L1:in Une_Liste_Ordonnee_Entiers; L2:out Une_Liste_Ordonnee_Entiers) is
   begin
      Copier_Lien(L1.Debut,L2.Debut);
      L2.Taille:=L1.Taille;
   end Copier;
   
   --------------------------------------------------------------------------
   
   function Egaux_Lien(L1,L2:in Lien) return Boolean is
   begin
      if L1=null and L2=null then
	 return True;
      elsif L1=null or L2=null then
	 return False;
      elsif L1.all.Info /= L2.all.Info then
	 return False;
      else
	 return Egaux_Lien(L1.all.Suiv,L2.all.Suiv);
      end if;
   end Egaux_Lien;
   
   
   function "="(L1,L2:in Une_Liste_Ordonnee_Entiers) return Boolean is
   begin
      if L1.Taille /= L2.Taille then
	 return False;
      else
	 return Egaux_Lien(L1.Debut,L2.Debut);
      end if;
   end "=";
   
   

end Listes_Ordonnees_Entiers;
