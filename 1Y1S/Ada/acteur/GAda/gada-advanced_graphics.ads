with Gada.Gr_Core ;

package GAda.Advanced_Graphics is

   --
   -- Cet acteur n'est pas destin� aux TPs de premi�re ann�e.
   --

   ---------------------
   --     IMAGES
   ---------------------

   -- Le type des images est simplement "Image"
   subtype Image is GAda.Gr_Core.Image ;

   -- Charge une image depuis un fichier (png, jpg, etc.)
   function Load_Image (Filename : String) return Image ;

   -- Dessine une image � l'endroit indiqu�
   procedure Put_Image (X, Y : Integer ; Img : Image) ;

   -- Obtient les dimensions de l'image
   function Hauteur_Image(Img : Image) return Integer ;
   function Largeur_Image(Img : Image) return Integer ;


   ---------------------
   --     EVENEMENTS
   ---------------------
   type T_Event_Type is (Button_Press, Key_Press) ;

   type T_Event is record
      -- Vaut FALSE si aucun evenement n'est disponible maintenant
      Trouve : Boolean ;

      -- Type de l'evenement
      Etype : T_Event_Type ;

      -- Age en millisecondes de cet �v�nement
      Age : Integer ;

      -- Coordonn�es de la souris
      X, Y : Integer ;

      -- Touche appuy�e (si Key_Press)
      Key : Character ;

      -- Code de la touche appuy�e
      Key_Code : Integer ;
   end record ;

   -- Renvoie les �v�nements dans l'ordre chronologique.
   -- Si aucun �v�nement n'est disponible, l'attribut Trouve vaut False.
   function Next_Event return T_Event ;



   ---------------------
   --     TEXTE
   ---------------------
   procedure Put_Text (X, Y : Integer ; Msg : String ; Size : Integer := 0) ;


end GAda.Advanced_Graphics ;
