(:9.Pour chaque PO, la moyenne des soutenances:)
for $PO in main/POs/PO/@intitule
return 
  <PO>{$PO}
  {avg(
    for $stage in main/stages/stage[@PO=$PO]
    return
      for $rapport in main/rapports/rapport[@codeRapport = $stage/@rapport]
      return
        for $soutenance in main/soutenances/soutenance[@codeSoutenance = $rapport/soutenance]
        return avg(($soutenance/notePresentation,$soutenance/noteRapport))
)}</PO>
