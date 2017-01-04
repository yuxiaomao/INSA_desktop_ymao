 % LES ENTREES
hors_d_oeuvre(artichauts_melanie).
hors_d_oeuvre(truffes_sous_le_sel).
hors_d_oeuvre(cresson_oeuf_poche).

 % LES VIANDES
viande(grillade_de_boeuf).
viande(poulet_au_tilleul).

 % LES POISSONS
poisson(bar_aux_algues).
poisson(truite_meuniere).

 % LES DESSERTS
dessert(sorbet_aux_poires).
dessert(fraises_chantilly).
dessert(melon_surprise). 

 % LES BOISSONS (25 cl)
boisson(eau_minerale(hepar)).
boisson(vin_rouge(morgon)).
boisson(biere(gueuze)).

 % VALEURS CALORIFIQUES
calories(artichauts_melanie, 150).
calories(truffes_sous_le_sel, 212).
calories(cresson_oeuf_poche, 202).
calories(grillade_de_boeuf, 532).
calories(poulet_au_tilleul, 400).
calories(bar_aux_algues, 292).
calories(truite_meuniere, 254).
calories(sorbet_aux_poires, 223).
calories(fraises_chantilly, 289).
calories(melon_surprise, 122).
calories(eau_minerale(hepar), 0).
calories(vin_rouge(morgon), 175).
calories(biere(gueuze), 250). 

 % RELATIONS
plat(P) :- viande(P).
plat(P) :- poisson(P).
/*repas_leger(R) :- 
 R=[Entree, Plat, Dessert, Boisson],
 hors_d_oeuvre(Entree),
 plat(Plat),
 dessert(Dessert),
 boisson(Boisson),
 calories(Entree, CEntree),
 calories(Plat, CPlat),
 calories(Dessert, CDessert),
 calories(Boisson, CBoisson),
 CEntree+CPlat+CDessert+CBoisson < 600.*/
repas_leger(R,X,L) :- 
 R=[Entree, Plat, Dessert, Boisson],
 hors_d_oeuvre(Entree),
 plat(Plat),
 dessert(Dessert),
 boisson(Boisson),
 calories(Entree, CEntree),
 calories(Plat, CPlat),
 calories(Dessert, CDessert),
 calories(Boisson, CBoisson),
 X is CEntree+CPlat+CDessert+CBoisson,
 X<L.
repas_leger(R) :-
 repas_leger(R,_,600).
