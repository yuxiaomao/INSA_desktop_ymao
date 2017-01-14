(:5. Le nombre d'étudiant ayant fait des stages à l'industrie:)
count(distinct-values(
for $stage in main/stages/stage
return
  for $encadrant in main/encadrants/encadrant[industriel]/@codePersonnel
  return
    for $encadrantStage in $stage/encadrant
    return
      if ($encadrantStage=$encadrant)
      then data($stage/@etudiant)
      else ()
))