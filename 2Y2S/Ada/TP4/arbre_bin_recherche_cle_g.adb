-- Date : Mars 2015
-- Auteur : MJ. Huguet
-- 
-- Objet : corps paquetage arbre binaire de recherche generique
--
-- CONSIGNES : 
--            SOUS-PROGRAMMES A COMPLETER
-----------------------------------------------------------------------------
with Unchecked_Deallocation;

package body Arbre_Bin_Recherche_Cle_G is
   
   -----------------------------------------------------------------------------
   procedure Free_Noeud IS NEW Unchecked_Deallocation(Noeud, LienArbre);
   
   procedure Liberer_Lien(LA : in out LienArbre) is
   begin
      if LA /= null then
         Liberer_Lien(LA.all.gauche); -- desallocation partie gauche
         Liberer_Lien(LA.all.droite); -- desallocation partie droite
         Liberer_Element(LA.All.Info);   -- desallocation contenu du noeud racine
         Free_Noeud(LA);              -- desallocation noeud racine
      end if;
   end Liberer_Lien;
   
   procedure Liberer(A : in out Arbre) is
   begin
      Liberer_Lien(A.Debut);
      A.Debut := null;
      A.Taille := 0;
   end Liberer;
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   function Est_Vide(A : in Arbre) return Boolean is
   begin
      return A.Debut=null;
   end Est_Vide;
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   function Taille(A : in Arbre) return Natural is
   begin
      return A.Taille;
   end Taille;
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   function Racine(A: in Arbre) return Element is
   begin
      if Est_Vide(A) then
	 raise Arbre_Vide;
      else
	 return A.Debut.all.Info;
      end if;
   end Racine;
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   function Appartient_Lien(C : in Cle; LA : in LienArbre) return Boolean is
      -- A FAIRE
   begin
      if LA=null then
	 return False;
      elsif C=Cle_De_E(LA.all.Info) then
	 return True;
      elsif C<Cle_De_E(LA.all.Info) then
	 return Appartient_Lien(C,LA.all.Gauche);
      else
	 return Appartient_Lien(C,LA.all.Droite);
      end if;
   end Appartient_Lien;
   
   function Appartient(E : in Element; A : in Arbre) return Boolean is
   begin
      return Appartient_Lien(Cle_De_E(E), A.Debut);
   end Appartient;
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   
   function Recherche_Lien(C : in Cle; LA : in LienArbre) return Element is
      -- A FAIRE
   begin
      if LA=null then
	 raise Element_Non_Present;
      elsif C=Cle_De_E(LA.all.Info) then
	 return LA.all.Info;
      elsif C<Cle_De_E(LA.all.Info) then
	 return Recherche_Lien(C,LA.all.Gauche);
      else
	 return Recherche_Lien(C,LA.all.Droite);
      end if;
   end Recherche_Lien;
   
   function Cle_To_element(C : in  Cle ; A : in Arbre) return Element is
      begin
      return Recherche_Lien(C, A.Debut);
   end Cle_To_Element;

   
   
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   function Lien_To_String(LA : in LienArbre) return String is
      -- A FAIRE
   begin
      if LA=null then
	 return "";
      else
	 return Lien_To_String(LA.all.Gauche)
	   &" "& E_To_String(La.all.Info)
	   &" "& Lien_To_String(LA.all.Droite)&" ";
      end if;
   end Lien_To_String;

   function Arbre_To_String(A : in Arbre) return String is
   begin
      return Integer'Image(A.Taille) & " elements : (" & Lien_To_String(A.Debut) & " )";
   end Arbre_To_String;
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   procedure Inserer_Lien(E : in Element; LA : in out LienArbre) is
      -- VERSION ITERATIVE
      -- A FAIRE
      Aux:LienArbre:=LA;
      C:Cle:=Cle_De_E(E);
      Fin_Insersion:Boolean:=False;
   begin
      if La=null then
	 La:=new Noeud'(E,null,null);
	 Fin_Insersion:=True;
      end if;
      while not Fin_Insersion loop
	 if C=Cle_De_E(Aux.all.Info) then
	    raise Element_Deja_Present;
	 elsif C<Cle_De_E(Aux.all.Info) then
	    if Aux.all.Gauche=null then
	       Aux.all.Gauche:=new Noeud'(E,null,null);
	       Fin_Insersion:=True;
	    else
	       Aux:=Aux.all.Gauche;
	    end if;
	 else
	     if Aux.all.Droite=null then
	       Aux.all.Droite:=new Noeud'(E,null,null);
	       Fin_Insersion:=True;
	    else
	       Aux:=Aux.all.Droite;
	     end if;
	 end if;
      end loop;
   end Inserer_Lien;

   procedure Inserer(E : Element; A : in out Arbre) is
   begin
      Inserer_Lien(E, A.Debut);
      A.Taille := A.Taille + 1;
   end Inserer;
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   procedure Supprimer_Maxg(LA : in out LienArbre; Maxg : out Element) is
      -- A FAIRE
      Recup:LienArbre;
   begin
      -- LA est la branche gauche de ABR dont on veut supprimer sa racine
      -- le cas LA=null traite dans supprimer_lien
      if La.all.Droite=null then
	 Maxg:=LA.all.Info;
	 Recup:=LA;
	 LA:=LA.all.Gauche;
	 Liberer_Element(Recup.all.Info);
	 Free_Noeud(Recup);
      else
	 Supprimer_Maxg(LA.all.Droite, Maxg);
      end if;
   end Supprimer_Maxg;
   
   procedure Supprimer_Lien(E : in Element; LA : in out LienArbre ) is
      -- VERSION RECURSIVE DONNEE EN COURS
      -- A FAIRE
      Recup:LienArbre;
      Maxg:Element;
   begin
      if LA=null then
	 raise Element_Non_Present;
      elsif Cle_De_E(E)=Cle_De_E(LA.all.Info) then
	 Recup:=LA;
	 if LA.all.Gauche=null then
	    LA:=LA.all.Droite;
	 elsif LA.all.Droite=null then
	    LA:=LA.all.Gauche;
	 else
	    Supprimer_Maxg(LA.all.Gauche,Maxg);
	    LA.all.Info:=Maxg;
	 end if;
	 Liberer_Element(Recup.all.Info);
	 Free_Noeud(Recup);
      elsif Cle_De_E(E) < Cle_De_E(LA.all.Info) then
	 Supprimer_Lien(E,LA.all.Gauche);
      else
	 Supprimer_Lien(E,LA.all.Droite);
      end if;	
   end Supprimer_Lien;
   
   procedure Supprimer(E : in Element; A : in out Arbre) is
   begin
      Supprimer_Lien(E, A.Debut);
      A.Taille := A.Taille - 1;
   end Supprimer;
   -----------------------------------------------------------------------------
   

end Arbre_Bin_Recherche_Cle_G;



