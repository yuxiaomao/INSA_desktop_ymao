
(: for $a in db:open('LAAS') :)
(: let $nombre := count(//team) :)
(: return <equipe>$nombre</equipe> :)
(: return <equipe nombreEquipe="{$nombre}"/> :)
(:
let $equipe := //team 
return
 <TousLesEquipes>
 {$equipe/shortName}
 </TousLesEquipes> 
:)

<TousLesEquipes> {

    for $equipe in //team 
    return <equipe>{$equipe/shortName/text()}</equipe>
    
}
<ccc></ccc>
</TousLesEquipes>



