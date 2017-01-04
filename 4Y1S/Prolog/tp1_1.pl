 % Faits
personne(edouard, homme, 72, retraite(commandant(armee_de_terre)), nice).
personne(agathe, femme, 58, musicienne(blues), nice).
personne(gaston, homme, 65, retraite(chauffeur(semvat)), balma).
personne(simone, femme, 65, retraite(cableur(airbus)), balma).
personne(georges, homme, 28, animateur(club_med), toulouse).
personne(marie_cecile,femme,35, clerc_de_notaire, toulouse).
personne(octave, homme, 40, huissier, nice).
personne(elton, homme, 10, ecolier, toulouse).
personne(vanessa, femme, 5, ecolier, toulouse).
parent(edouard, marie_cecile).
parent(agathe, marie_cecile).
parent(edouard, octave).
parent(agathe, octave).
parent(gaston, georges).
parent(simone, georges).
parent(georges, elton).
parent(georges, vanessa).
parent(marie_cecile, elton).
parent(marie_cecile, vanessa).
 % Règles
pere(Pere, Enfant) :-
 personne(Pere, homme, _, _, _),
 parent(Pere, Enfant).
fille(Fille, Parent) :-
 personne(Fille, femme, _, _, _),
 parent(Parent, Fille). 
mere(Mere,Enfant) :-
 personne(Mere,femme,_,_,_),
 parent(Mere,Enfant).
fils(Fils,Parent) :-
 personne(Fils, femme, _, _, _),
 parent(Parent, Fils). 
habite_a_nice(Nicien) :-
 personne(Nicien,_,_,_,nice).
habite_dans_meme_ville_que_parents(Enfant,Ville) :-
 personne(Enfant,_,_,_,Ville),
 personne(Pere,homme,_,_,Ville),
 personne(Mere,femme,_,_,Ville),
 parent(Pere,enfant),
 parent(Mere,enfant).
parent_d_ecolier(P) :-
 personne(P,_,_,_,_),
 once((parent(P,Enfant),personne(Enfant,_,_,ecolier,_))).
 
 
