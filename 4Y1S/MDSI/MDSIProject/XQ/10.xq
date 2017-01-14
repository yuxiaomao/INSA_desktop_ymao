(:10-1. Pour chaque entreprise, on veut retourner le nombre de stages ayant plus de 14 comme moyenne et le nombre d'étudiant ayant une moyenne moins de 11 effectués au sein de cette entreprise:)
for $entreprise in main/etablissements/entreprise/@numSIRET
return
  <e>{$entreprise}
   <stage>{count(
      for $stage in main/stages/stage
      return for $encadrant in main/encadrants/encadrant[industriel/@numSIRET = $entreprise]
      return for $encadrantStage in $stage/encadrant
      return
        if (data($encadrantStage)=$encadrant/@codePersonnel)
        then (
          (:calcul moyenne:)
          let $moyenne :=(
          for $rapport in main/rapports/rapport
          return for $evaluation in main/evaluations/evaluation
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
          ))
            else()
          )
          return (if($moyenne>=14) then $moyenne else())
        )
        else ()
   )}</stage>
   <etud>
   {count(
    for $etudiant in main/etudiants/etudiant/@numEtudiant
    return
      let $noteEtudiant := (
      for $stage in main/stages/stage
      return for $encadrant in main/encadrants/encadrant[industriel/@numSIRET = $entreprise]
      return for $encadrantStage in $stage/encadrant
      return
        if ((data($encadrantStage)=$encadrant/@codePersonnel) and ($stage/@etudiant=$etudiant))
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
        if ($noteEtudiant<=11)then 1 else()
  )}</etud>
  </e>
