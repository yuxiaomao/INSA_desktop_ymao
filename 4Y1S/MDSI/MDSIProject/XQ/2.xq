(:2. Le nombre de stage sans soutenance:)
count(
for $rapport in main/rapports/rapport
return
  if ($rapport/soutenance)
  then ()
  else 1
)