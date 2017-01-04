% okkkkkk

% disque

disque(a,[-1,0,0,0,0,0]).
disque(b,[-1,-1,0,0,0,0]).
disque(c,[-1,0,-1,0,0,0]).
disque(d,[-1,0,0,-1,0,0]).
disque(e,[-1,-1,-1,0,0,0]).
disque(f,[-1,-1,0,-1,0,0]).
disque(g,[-1,0,-1,0,-1,0]).
disque(h,[-1,-1,-1,-1,0,0]).
disque(i,[-1,-1,-1,0,-1,0]).
disque(j,[-1,-1,0,-1,-1,0]).
disque(k,[-1,-1,-1,-1,-1,0]).
disque(l,[-1,-1,-1,-1,-1,-1]).

% liste
liste_des_disques(L) :-
 findall(X,disque(X,_),L).

% rotation
orienter(M1,M2,N):-
 orienter(M1,M1,M2,N).
rotation_droite(M1, [Hd|Tl]) :-
 append(Tl,[Hd],M1).
orienter(_,M1,M1,0).
orienter(Minit,M1,M2,N) :-
 rotation_droite(M1,Maux),
 Minit\=Maux,
 orienter(Minit,Maux,M2,N1),
 N is N1+1.

% empilement_secteur(Sect_surf,Sect_Disq,New_Sect_Surf)
empilement_secteur(0,0,0).
empilement_secteur(0,-1,2).
empilement_secteur(1,-1,0).
empilement_secteur(2,-1,1).
empilement([],[],[]).
empilement([Hd_ss|Tl_ss],[Hd_sd|Tl_sd],[Hd_nss|Tl_nss]) :-
 empilement_secteur(Hd_ss,Hd_sd,Hd_nss),
 empilement(Tl_ss,Tl_sd,Tl_nss).

% enlever
enlever(E,[E|R],R).
enlever(E,[P|R],[P|Q]) :-
 enlever(E,R,Q).

% etat
% solutions(X)
surface_plat([0,0,0,0,0,0]).
%% action(Disque, Rotation,M2) :-
%%  disque(Disque,M1),
%%  orienter(M1,M2,Rotation).
solutions(List_actions) :-
 surface_plat(Surf),
 liste_des_disques(L),
 solution(Surf,L,List_actions,Surf).
% solution(Surf_init,L_disque_restant,Action,Surf_fin)
solution(Surf_plat,[],[],Surf_plat) :-
 surface_plat(Surf_plat).
solution(Surf1,L,[(D,Rot)|Tl_ac],Surf2) :-
 member(D,L),
 enlever(D,L,L2),
 disque(D,M1),
% (Cond -> True ; False)
 (surface_plat(Surf1) -> orienter(M1,M2,0),Rot=0; orienter(M1,M2,Rot)),
 empilement(Surf1,M2,Surfaux),
 solution(Surfaux,L2,Tl_ac,Surf2).


 

