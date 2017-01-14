(:4. Pour chaque PO, on veut récupérer le nobre d'étudiants ayant la moyenne de toute leurs notes:)
for $PO in main/POs/PO/@intitule
return
  <PO>{$PO}
  {count(
    for $etudiant in main/etudiants/etudiant/@numEtudiant
    return
      let $noteEtudiant := (
      for $stage in main/stages/stage
      return 
        if (($stage/@PO = $PO) and ($stage/@etudiant=$etudiant))
        then (
          for $rapport in main/rapports/rapport
          return 
          for $evaluation in main/evaluations/evaluation
          return
            if(($rapport/@codeRapport = $stage/@rapport)
            and ($evaluation/@codeEvaluation = $stage/@evaluation) )
            then (
              if ($rapport/soutenance)
              then (
                for $soutenance in main/soutenances/soutenance
                return 
                  if ($soutenance/@codeSoutenance = $rapport/soutenance)
                  then (
                    avg((data($rapport/note),
                         data($evaluation/note),
                         data($soutenance/notePresentation),
                         data($soutenance/noteRapport)))
                  )
                  else ()
              )
              else(
                avg((data($rapport/note),data($evaluation/note)))
              )
              
            )
            else ()
        )
        else ()
      )
      return 
        if ($noteEtudiant>=10)then 1 else()
  )}
  </PO>