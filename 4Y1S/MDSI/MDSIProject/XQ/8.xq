(:8. Pour chaque PO, le nombre d'enseignants tuteurs:)
for $PO in main/POs/PO/@intitule
return 
  <PO>{$PO}
  {count(distinct-values(
    main/stages/stage[@PO=$PO]/enseignant
  ))}</PO>