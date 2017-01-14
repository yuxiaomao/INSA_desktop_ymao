(:7. Pour chaque PO, le nombre de stages effectue:)
for $PO in main/POs/PO/@intitule
return (
  <PO>{$PO}
  {count(
    for $stage in main/stages/stage
    return 
      if ($stage/@PO=$PO )
      then $PO
      else ()
  )}</PO>
)