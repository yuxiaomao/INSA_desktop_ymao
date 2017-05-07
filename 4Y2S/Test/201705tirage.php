<!DOCTYPE html>
<html>
<body>
<?php
// MAO Yuxiao
// Element = array(String name, int value, Boolean enable)
$listElements = array
  (
  array("Adidas", 153, true),
  array("converse", 193, true),
  array("Nike", 124, true),
  array("Autre", 67, true)
  );

function tirage($listOfEV) {
    $arrlength = count($listOfEV);
    $res = array();
    
    // calculer le total des valeurs
    $somme = 0;
    for ($x = 0; $x < $arrlength ; $x++) {
        if ($listOfEV[$x][2]){
            $somme = $somme + $listOfEV[$x][1];
        }
    }
    
    // effectuer n tirage
    for ($i = 0; $i < $arrlength ; $i++) {
        // random value
        $tmp = mt_rand(1,$somme);
        
        // decision
        for ($x = 0; $x < $arrlength ; $x++) {
            // si on a deja depasser le random value, alors on a trouve ce qu'on cherche
            if ($tmp <= 0) 
                break;
            // sinon, on test si cet element est valid et n'a pas encore ete choisi
            if ($listOfEV[$x][2]){
                $tmp = $tmp - $listOfEV[$x][1];
            }
        }
        // on a choisi l'element numero $x, la somme de valeur change, ajouter dans list res
        $somme = $somme - $listOfEV[$x-1][1];
        $listOfEV[$x-1][2] = false;
        $res[$i] = $listOfEV[$x-1][0];
    }
    
    return $res;
}

echo var_dump(tirage($listElements));
?>

</body>
</html>
