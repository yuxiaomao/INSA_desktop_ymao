(:6. Le nombre d'étudiant ayant fait des stages en laboratoire de recherche:)
count(distinct-values(
for $stage in main/stages/stage
return
  for $encadrant in main/encadrants/encadrant[chercheur]/@codePersonnel
  return
    for $encadrantStage in $stage/encadrant
    return
      if ($encadrantStage=$encadrant)
      then data($stage/@etudiant)
      else ()
))