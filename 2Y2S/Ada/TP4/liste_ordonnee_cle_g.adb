-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : corps liste ordonnee generique
--
-- Remarque : 
--  	les elements disposent d'une cle permettant de les identifier
-----------------------------------------------------------------------------
with Ada.Unchecked_Deallocation;

package body Liste_Ordonnee_Cle_G is
   
   -----------------------------------------------------------------------------
   -- Definir l'egalite sur des elements comme l'egalite sur la cle
   -- c'est pour blinder la definition d'une cle !!!
   function "="(E1, E2 : Element) return Boolean is
   begin
      return Cle_De(E1)=Cle_De(E2);
   end "=";
   function "<"(E1, E2 : Element) return Boolean is
   begin
      return Cle_De(E1)<Cle_De(E2);
   end "<";
   
   
   -------------------------------------------------------------------------
   function Est_Vide(L : in Une_Liste_Ordonnee) return Boolean is
   begin
      return L.Debut = null;
   end Est_Vide;
   -------------------------------------------------------------------------

   -------------------------------------------------------------------------
   function Cardinal(L : in Une_Liste_Ordonnee) return Integer is
   begin
      return L.Taille;
   end Cardinal;
   -------------------------------------------------------------------------

   -----------------------------------------------------------------------------
   -- Appartient classique sur une liste simplement chainee (type Lien) ordonnee
   --    base sur un element
   function Appartient_Lien(E : in Element; LL : in Lien) return Boolean is
      Resultat :boolean;
   begin
      if LL = null or else E < LL.all.Info then
         Resultat := False;         -- element non trouve
      elsif E = LL.all.Info then
         Resultat := True;          -- element trouve en 1ere place
      else
         Resultat := Appartient_Lien(E, LL.all.Suiv);  -- on cherche plus loin
      end if;
      return Resultat;
   end Appartient_Lien;

   function Appartient(E : in Element; L : in Une_Liste_Ordonnee) return Boolean is
   begin
      return Appartient_Lien(E, L.Debut);
   end Appartient;
   
   --    base sur une cle
   function Appartient_Lien(C : in Key; LL : in Lien) return Boolean is
      Resultat :boolean;
   begin
      if LL = null or else C < Cle_De(LL.all.Info) then
         Resultat := False;         -- element non trouve
      elsif C = Cle_De(LL.all.Info) then
         Resultat := True;          -- element trouve en 1ere place
      else
         Resultat := Appartient_Lien(C, LL.all.Suiv);  -- on cherche plus loin
      end if;
      return Resultat;
   end Appartient_Lien;

   function Appartient(C : in Key; L : in Une_Liste_Ordonnee) return Boolean is
   begin
      return Appartient_Lien(C, L.Debut);
   end Appartient;
   -------------------------------------------------------------------------

   -------------------------------------------------------------------------
   -- Conversion en chaine de caracteres
   --
   -- sur le type Lien

   function Lien_To_String(LL : in Lien) return String is
   begin
      if LL = null then return "";
                   else return Element_To_String(LL.all.info) & Lien_To_String(LL.all.suiv);
      end if;
   end Lien_To_String;

   -- sur le type Une_Liste_Ordonnee_Entiers
   function Liste_To_String(L: in Une_Liste_Ordonnee) return String is
   begin
      return Integer'Image(L.Taille) & " elements : (" & Lien_To_String(L.Debut) & " )";
   end Liste_To_String;
   -------------------------------------------------------------------------

   -------------------------------------------------------------------------
   -- Insertion ORDONNEE et SANS DOUBLON
   --    A CORRIGER PAR LES ETUDIANTS (FAIT ICI)
   procedure Inserer_Lien(E: in Element; LL: in out Lien) is
   begin
      if LL=null then
	    LL := new Cellule'(E, LL);
      elsif E < LL.all.Info then
	    -- LL := new Cellule'(E, LL.all.Suiv); 
	    LL:= new Cellule'(E, LL); -- la correction est ici !	
      elsif E=LL.all.Info then
	    raise Element_Deja_Present;
      else
	    Inserer_Lien(E, LL.all.Suiv);
      end if;
   end Inserer_Lien;

   -------------------------------------------------------------------------
   procedure Inserer(E: in Element; L: in out Une_Liste_Ordonnee) is
   begin
      Inserer_Lien(E, L.Debut);
      L.Taille := L.Taille + 1;
   end Inserer;
   -------------------------------------------------------------------------


   -- Instanciation de Ada.Unchecked_Deallocation pour desallouer
   -- la memoire en cas de suppression des elements d'une liste
   -------------------------------------------------------------------------
   procedure Free is new Ada.Unchecked_Deallocation(Cellule, Lien);
   -------------------------------------------------------------------------
   procedure Supprimer_Lien(E : in Element; LL: in out Lien) is
      Recup : Lien;
   begin
      if LL = null or else E < LL.All.Info then
         raise Element_Non_Present;
      elsif E = LL.All.Info then
         Recup := LL;           -- on repere la cellule a recycler
         LL     := LL.All.Suiv;  -- on modifie le debut de la liste
         Free(Recup);          -- on recupere la memoire
      else
         Supprimer_Lien(E, LL.all.suiv);
      end if;
   end Supprimer_Lien;
   -------------------------------------------------------------------------
   procedure Supprimer(E: in Element; L: in out Une_Liste_Ordonnee) is
   begin
      Supprimer_Lien(E, L.debut);
      L.Taille := L.Taille - 1;
   end Supprimer;
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   function Rechercher_Lien(C : in Key; LL : in Lien) return Element is
   begin
      if LL = null or else C < Cle_De(LL.all.Info) then
         raise Element_Non_Present;
      else
         if C = Cle_De(LL.All.Info) then
            return LL.all.Info;
         else
            return Rechercher_Lien(C, LL.All.Suiv);
         end if;
      end if;
   end Rechercher_Lien;
   
   function Rechercher_Par_Cle(C : in Key; L : Une_Liste_Ordonnee) return Element is
   begin
      return Rechercher_Lien(C, L.Debut);
   end Rechercher_Par_Cle;
   -----------------------------------------------------------------------------
  
   procedure Filtrage(L : in Une_Liste_Ordonnee; SL : out Une_Liste_Ordonnee) is
      Aux : Lien := L.Debut;
   begin
      while Aux /= null loop
	 if Selection(Aux.all.Info) then
	    Inserer(Aux.all.Info, SL);
	 end if;
	 Aux := Aux.all.Suiv;
      end loop;
   end Filtrage;

end Liste_Ordonnee_Cle_G;

