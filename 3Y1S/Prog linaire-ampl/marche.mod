set DETAILLANTS;
set REGIONS;
set CATEGORIES;
set LISTE;

param region{LISTE} symbolic in REGIONS;
param huile{LISTE}>=0;
param nb_pts_vente{LISTE}>=0;
param spiritueux{LISTE}>=0;
param categorie{LISTE} symbolic in CATEGORIES;

var repartition_d1 {m in DETAILLANTS} integer >=0,<=1;
#=1si Mi in D1, =0si Mi in D2

minimize obj:
	0;

subject to total_pts_vente_inf:
	((sum{m1 in DETAILLANTS}
		nb_pts_vente[m1]*repartition_d1[m1])
	/(sum{m2 in DETAILLANTS}
		nb_pts_vente[m2]*(1-repartition_d1[m2])))>= 7/13;
subject to total_pts_vente_sup:
	((sum{m1 in DETAILLANTS}
		nb_pts_vente[m1]*repartition_d1[m1])
	/(sum{m2 in DETAILLANTS}
		nb_pts_vente[m2]*(1-repartition_d1[m2])))<=9/11;
	
/*var var_total_pts_vente :=
	(sum{m1 in DETAILLANTS}
		nb_pts_vente[m1]*repartition_d1[m1])
	/(sum{m2 in DETAILLANTS}
		nb_pts_vente[m2]*(1-repartition_d1[m2]));
subject to total_pts_vente_inf:
	var_total_pts_vente>= 7/13;
subject to total_pts_vente_sup:
	var_total_pts_vente<=9/11;

/*
var var_total_spiritueux :=
	(sum{m1 in DETAILLANTS}
		spiritueux[m1]*repartition_d1[m1])
	/(sum{m2 in DETAILLANTS}
		spiritueux[m2]*(1-repartition_d1[m2]));
subject to total_spiritueux_inf:
	var_total_spiritueux>= 7/13;
subject to total_spiritueux_sup:
	var_total_spiritueux<= 9/11;

var var_total_huile_region{r in REGIONS} :=
	(sum{m1 in DETAILLANTS : region[m1]=r}
		spiritueux[m1]*repartition_d1[m1])
	/(sum{m2 in DETAILLANTS: region[m2]=r}
		spiritueux[m2]*(1-repartition_d1[m2]));
subject to total_huile_region_inf{r in REGIONS}:
	var_total_huile_region[r]>= 7/13;
subject to total_huile_region_sup{r in REGIONS}:
	var_total_huile_region[r]<= 9/11;
	
	
var var_total_d_categorie{c in CATEGORIES} :=
	(sum{m1 in DETAILLANTS: categorie[m1]=c}
		1*repartition_d1[m1])
	/(sum{m2 in DETAILLANTS: categorie[m2]=c}
		1*(1-repartition_d1[m2]));
subject to total_d_categorie_inf{c in CATEGORIES}:
	var_total_d_categorie[c]>= 7/13;
subject to total_d_categorie_sup{c in CATEGORIES}:
	var_total_d_categorie[c]<= 9/11;