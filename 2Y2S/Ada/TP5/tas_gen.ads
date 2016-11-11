-- Avril 2014
-- Auteurs : MJ. Huguet - R. Guillerm
--
-- Mise à jour : avril 2015 
-- Auteur : MJ. Huguet
-- Modif : ajout de la cle des elements
--
-- OBJET : paquetage generique de Tas
------------------------------------------------------------------------
generic
   type Element is private;		    
   -- type des noms des éléments
   type Key is private;
   -- type de la cle des elements
   with function Cle_De(E : in Element) return Key;
   with function "<"(C1, C2 : in Key) return Boolean;	
   -- fonction de comparaison de deux valeurs
   with procedure Liberer_Element(E : in out Element);
   with function Element_To_String(E : in Element) return string;
package Tas_Gen is

	Tas_Vide, Tas_Plein : exception;

	type Un_Tas(Dimension : Natural) is limited private;

	-- Vider le tas
	procedure Liberer(T : in out Un_Tas);
	
	--Retourne si le tas est vide
	function Est_Vide(T : in Un_Tas) return Boolean;
	
	-- Retourne le nb courant d'éléments du tas
	function Cardinal(T : in Un_Tas) return Natural;

	-- Retirer la racine du tas et la retourne
	procedure Enlever_Racine(T : in out Un_Tas; E : out Element);

	-- Ajouter un nouvel élément dans le tas
	procedure Ajouter(E : in Element; T : in out Un_Tas);

	function Tas_To_String(T : in Un_Tas) return string;

private

   type Tab_Elements is array(natural range <>) of Element;	
   -- les éléments sont dans un tableau

   type Un_Tas(Dimension : Natural) is record    -- le record Tas mémorise :
      Cardinal : Natural := 0;		             --    - le nombre d'éléments du tas
      Les_Elements : Tab_Elements(1..Dimension); --    - le tableau des éléments du tas
   end record;

end Tas_Gen;
