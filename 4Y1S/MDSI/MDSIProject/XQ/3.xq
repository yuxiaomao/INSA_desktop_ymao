(:3. Le nombre d'industriels qui ont encadré des stage:)
count(distinct-values(
  for $codeEncadrantSoutenu in distinct-values(main/stages/stage/encadrant)
  return 
    for $encadrant in main/encadrants/encadrant
    return 
      if ($codeEncadrantSoutenu = $encadrant/@codePersonnel)
      then data($encadrant/industriel/@numSIRET)
      else ()
))