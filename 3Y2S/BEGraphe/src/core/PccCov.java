package core;

import java.io.*;
//import base.BinaryHeap;
//import java.util.HashMap;
import base.Readarg;


public class PccCov extends Algo {
	// Numero des sommets et zones
	protected int zonePieton;
	protected int pieton;
	protected int zoneVoiture;
	protected int voiture;
	protected int zoneDestination;
	protected int destination;

	//Pcc utilises 
	//pieton voiture rencontre
	protected Pcc PccPD;
	protected Pcc PccVD;
	protected Pcc PccRD;
	protected Pcc PccDR;

	//un hmap et un tas pour faire la comparaison et trouver une solution
	//public HashMap<Integer, LabelCov> hmapCov;
	//public BinaryHeap<LabelCov> tasCov;

	public PccCov(Graphe gr, PrintStream sortie, Readarg readarg) {
		super(gr, sortie, readarg);

		this.zonePieton = gr.getZone();
		this.pieton = readarg.lireInt("Numero du sommet de pieton ? ");
		this.zoneVoiture = gr.getZone();
		this.voiture = readarg.lireInt("Numero du sommet de la voiture ? ");
		this.zoneDestination = gr.getZone();
		this.destination = readarg.lireInt("Numero du sommet destination ? ");
		this.PccPD = new PccStarPieton(gr, sortie,readarg, this.pieton, this.destination);
		this.PccVD = new PccStar(gr, sortie,readarg, this.voiture, this.destination);
		this.PccRD = new PccStar(gr, sortie, readarg, this.pieton, this.destination);
		this.PccDR = new PccStarGrapheInverse(gr, sortie, readarg, this.destination, this.pieton);
		//this.hmapCov = new HashMap<Integer, LabelCov>();
		//this.tasCov = new BinaryHeap<LabelCov>();

	}

	//*
	//SOLUTION 1: TPS EGAUX VOITURE PIETON
	public void run2() {

		System.out.println("Run PCC-Cov de Pieton " + zonePieton + ":" + pieton
				+ " avec Voiture " + zoneVoiture + ":" +voiture
				+ " vers Destination " + zoneDestination + ":" + destination);
		this.graphe.getDessin().setColor(java.awt.Color.cyan);

		//indique combien de sommet commun trouve
		boolean trouve = false;
		//qui indique le point de rencontre, -1 pour pas de solution
		int pointRencontre = -1;

		int compteurWhile = 0;

		this.PccPD.unPasDijkstra();
		this.PccVD.unPasDijkstra();
		//un boucle
		//condition arret? on a chercher sur un zone de 0.1% pour obtient un couverture et essaye de chercher dans cette zone
		while ((!this.PccPD.tas.isEmpty())&&(!this.PccVD.tas.isEmpty())&&(!trouve)){
			compteurWhile += 1;
			Label minTasPD = this.PccPD.tas.findMin();
			Label minTasVD = this.PccVD.tas.findMin();
			//si le cout de pd est plus grand
			if (minTasPD.compareTo(minTasVD) >0){
				// analyser ce sommet
				//si le nouveau min de tas Voiture est dans hashmap de pieton
				if ( this.PccPD.hmap.containsKey(minTasVD.getSommet_courant())  ){
					pointRencontre = minTasVD.getSommet_courant();
					trouve = true;
				}

				//le sens n'est pas tres bon, il faut que la voiture aille cherche pieton
				//problem des valeurs estimation deja rempli
				/*
				if(this.PccVD.hmap.get(this.destination) != null){
					this.PccVD.setDestination(this.pieton);
					voiturePlus = true;
				}*/
				this.graphe.getDessin().setColor(java.awt.Color.pink);
				this.PccVD.unPasDijkstra();
			}else{
				//si le nouveau min de tas Pieton est dans hashmap de voiture
				if ( this.PccVD.hmap.containsKey( minTasPD.getSommet_courant())  ){
					//if (this.PccVD.hmap.get(sommetCourant).isMarquage()){
					pointRencontre =  minTasPD.getSommet_courant();
					trouve = true;
					//}
				}

				this.graphe.getDessin().setColor(java.awt.Color.orange);
				this.PccPD.unPasDijkstra();
			}			
		}


		System.out.println("Compteur While : " + compteurWhile);

		//apres boucle
		if (trouve){	
			//faire les trois chemin
			this.PccRD.setOrigine(pointRencontre);
			System.out.println( "numero de point de rencontre : " + pointRencontre);
			this.PccRD.initHmapEtTas();
			this.PccRD.dijkstra();
			this.graphe.getDessin().setColor(java.awt.Color.black);
			this.graphe.getDessin().drawPoint(this.graphe.getSommets()[pointRencontre].getLongitude(),
					this.graphe.getSommets()[pointRencontre].getLatitude(), 10);
			//recupere les cout
			Chemin cheminPR = this.PccPD.recupereChemin(this.PccPD.hmap, this.pieton, pointRencontre);
			System.out.println("Taille de cheminPR : " + cheminPR.getSize());
			float coutPR = this.PccPD.graphe.calculCheminTpsPieton(cheminPR);
			Chemin cheminVR = this.PccVD.recupereChemin(this.PccVD.hmap, this.voiture, pointRencontre);
			System.out.println("Taille de cheminVR : " + cheminVR.getSize());
			float coutVR = this.PccPD.graphe.calculCheminTps(cheminVR);
			Chemin cheminRD = this.PccRD.recupereChemin(this.PccRD.hmap, pointRencontre, this.destination);
			System.out.println("Taille de cheminRD : " + cheminRD.getSize());
			float coutRD = this.PccPD.graphe.calculCheminTps(cheminRD);
			System.out.println();
			System.out.println("Cout total cov : ");
			System.out.println("Temps piÃ©ton avant rencontre : " + coutPR);
			System.out.println("Temps voiture avant rencontre : " + coutVR);
			System.out.println("Temps du point de rencontre Ã  destination : " + coutRD);
		}
		else{
			System.out.println();
			System.out.println("on n'a pas trouve une solution");
			Chemin cheminPD = this.PccPD.recupereChemin(this.PccPD.hmap, this.pieton, this.destination);
			System.out.println("Taille de cheminPD : " + cheminPD.getSize());
			float coutPD = this.PccPD.graphe.calculCheminTpsPieton(cheminPD);
			Chemin cheminVD = this.PccVD.recupereChemin(this.PccVD.hmap, this.voiture, this.destination);
			System.out.println("Taille de cheminVD : " + cheminVD.getSize());
			float coutVD = this.PccPD.graphe.calculCheminTps(cheminVD);

			System.out.println();
			System.out.println("Temps piÃ©ton Ã  destination : " + coutPD);
			System.out.println("Temps voiture Ã  destination : " + coutVD);
		}

	}

	//***
	//SOLUTION 3: MINIMISATION DE COUT(P)+COUT(V)+ABS(COUT(P)-COUT(V))
	public void run3(){

		System.out.println("Run PCC-Cov de Pieton " + zonePieton + ":" + pieton
				+ " avec Voiture " + zoneVoiture + ":" +voiture
				+ " vers Destination " + zoneDestination + ":" + destination);
		this.graphe.getDessin().setColor(java.awt.Color.cyan);

		//indique si on a trouve un chemin minimal
		boolean trouve = false;
		//qui indique le point de rencontre, -1 pour pas de solution
		int pointRencontre = -1;
		//le cout qu'on veut minimiser c'est coutVoiture+coutPieton
		//Une meilleur solution est de minimiser coutV+coutP+abs(coutV-couP)
		//ceci depend du fonctionnement qu'on veut, est-ce qu'on prend en compte l'attente
		float coutMinVP = 90000000.0f;

		int compteurWhile = 0;
		//avant sortir du boucle avec destination visité
		//il faut encore lancer while pour actualise le coutMin
		boolean dernierPas = false;

		this.PccPD.unPasDijkstra();
		this.PccVD.unPasDijkstra();

		while ((!this.PccPD.tas.isEmpty())&&(!this.PccVD.tas.isEmpty())&&(!trouve)){
			compteurWhile += 1;
			Label minTasPD = this.PccPD.tas.findMin();
			Label minTasVD = this.PccVD.tas.findMin();
			float coutActuelVP;

			if (dernierPas){
				trouve = true;
			}

			//si le cout de pd est plus grand
			if (minTasPD.compareTo(minTasVD) >0){
				// analyser ce sommet
				//si le nouveau min de tas Voiture est dans hashmap de pieton
				if ( this.PccPD.hmap.containsKey(minTasVD.getSommet_courant())  ){
					//on somme le cout de la voiture au point de rencontre et du pieton au point de rencontre
					coutActuelVP = minTasVD.getCout() + this.PccPD.hmap.get(minTasVD.getSommet_courant()).getCout()
							+Math.abs(minTasVD.getCout() - this.PccPD.hmap.get(minTasVD.getSommet_courant()).getCout());
					if (coutActuelVP < coutMinVP){
						coutMinVP = coutActuelVP;
						System.out.println("coutMinVP : "+ coutMinVP);
						pointRencontre = minTasVD.getSommet_courant();
					}
				}
				this.graphe.getDessin().setColor(java.awt.Color.pink);
				this.PccVD.unPasDijkstra();
			}else{
				//si le nouveau min de tas Pieton est dans hashmap de voiture
				if ( this.PccVD.hmap.containsKey( minTasPD.getSommet_courant())  ){
					coutActuelVP = minTasPD.getCout() + this.PccVD.hmap.get(minTasPD.getSommet_courant()).getCout()
							+Math.abs(minTasPD.getCout() - this.PccVD.hmap.get(minTasPD.getSommet_courant()).getCout());
					if (coutActuelVP < coutMinVP){
						coutMinVP = coutActuelVP;
						System.out.println("coutMinVP : "+ coutMinVP);
						pointRencontre =  minTasPD.getSommet_courant();
					}
				}
				this.graphe.getDessin().setColor(java.awt.Color.orange);
				this.PccPD.unPasDijkstra();
			}		


			//2 conditions d'arret
			//--destination marquee dans la hmap de voiture et pieton
			//-- OU destination et origine pieton marquee dans la hmap de voiture (cas ou pieton ne peut pas atteindre dest)
			if (PccPD.hmap.containsKey(this.destination) && PccVD.hmap.containsKey(this.destination)){
				if(PccPD.hmap.get(this.destination).isMarquage() && PccVD.hmap.get(this.destination).isMarquage()){
					dernierPas = true;
				}
			}else if(PccVD.hmap.containsKey(this.pieton) && PccVD.hmap.containsKey(this.destination)){
				if (PccVD.hmap.get(this.pieton).isMarquage() && PccVD.hmap.get(this.destination).isMarquage()){
					dernierPas = true;
				}
			}

		}


		System.out.println("Compteur While : " + compteurWhile);

		//apres boucle
		if (pointRencontre != -1){	
			//faire le chemin rencontre-destination
			this.PccRD.setOrigine(pointRencontre);
			System.out.println( "numero de point de rencontre : " + pointRencontre);
			this.PccRD.initHmapEtTas();
			this.PccRD.dijkstra();
			//dessiner point de rencontre
			this.graphe.getDessin().setColor(java.awt.Color.black);
			this.graphe.getDessin().drawPoint(this.graphe.getSommets()[pointRencontre].getLongitude(),
					this.graphe.getSommets()[pointRencontre].getLatitude(), 10);
			//recupere les cout
			Chemin cheminPR = this.PccPD.recupereChemin(this.PccPD.hmap, this.pieton, pointRencontre);
			System.out.println("Taille de cheminPR : " + cheminPR.getSize());
			float coutPR = this.PccPD.graphe.calculCheminTpsPieton(cheminPR);
			Chemin cheminVR = this.PccVD.recupereChemin(this.PccVD.hmap, this.voiture, pointRencontre);
			System.out.println("Taille de cheminVR : " + cheminVR.getSize());
			float coutVR = this.PccPD.graphe.calculCheminTps(cheminVR);
			Chemin cheminRD = this.PccRD.recupereChemin(this.PccRD.hmap, pointRencontre, this.destination);
			System.out.println("Taille de cheminRD : " + cheminRD.getSize());
			float coutRD = this.PccPD.graphe.calculCheminTps(cheminRD);
			System.out.println();
			System.out.println("Cout total cov : ");
			System.out.println("Temps piéton avant rencontre : " + coutPR);
			System.out.println("Temps voiture avant rencontre : " + coutVR);
			System.out.println("Temps du point de rencontre a destination : " + coutRD);
		}
		//
		else{
			System.out.println();
			System.out.println("on n'a pas trouve une solution");
		}
	}



	//**
	//SOLUTION 2: MINIMISATION DE COUT(P)+COUT(V)
	public void run(){

		System.out.println("Run PCC-Cov de Pieton " + zonePieton + ":" + pieton
				+ " avec Voiture " + zoneVoiture + ":" +voiture
				+ " vers Destination " + zoneDestination + ":" + destination);
		this.graphe.getDessin().setColor(java.awt.Color.cyan);

		//indique si on a trouve un chemin minimal
		boolean trouve = false;

		//qui indique le point de rencontre, -1 pour pas de solution
		int pointRencontre = -1;

		//le cout qu'on veut minimiser c'est coutVoiture+coutPieton
		//Une meilleur solution est de minimiser coutV+coutP+abs(coutV-couP)
		//ceci depend du fonctionnement qu'on veut, est-ce qu'on prend en compte l'attente
		float coutMinVP = 90000000.0f;

		int compteurWhile = 0;
		//avant de sortir de la boucle avec destination visitee
		//il faut encore lancer une fois le while pour actualiser le coutMin
		boolean dernierPas = false;

		this.PccPD.unPasDijkstra();
		this.PccVD.unPasDijkstra();

		//tant que aucun des 2 tas n'est vide et qu'on a pas trouve 
		while ((!this.PccPD.tas.isEmpty())&&(!this.PccVD.tas.isEmpty())&&(!trouve)){
			compteurWhile += 1;
			Label minTasPD = this.PccPD.tas.findMin();
			Label minTasVD = this.PccVD.tas.findMin();
			float coutActuelVP;

			if (dernierPas){
				trouve = true;
			}

			//on compare les min des 2 tas
			//si le cout de pieton-dest est plus grand
			if (minTasPD.compareTo(minTasVD) >0){
				// analyser ce sommet

				//si le nouveau min de tas Voiture est dans hashmap de pieton
				if ( this.PccPD.hmap.containsKey(minTasVD.getSommet_courant())  ){				
					//on somme le cout de la voiture au point de rencontre et du pieton au point de rencontre
					coutActuelVP = minTasVD.getCout() + this.PccPD.hmap.get(minTasVD.getSommet_courant()).getCout();

					if (coutActuelVP < coutMinVP){
						coutMinVP = coutActuelVP;
						System.out.println("coutMinVP : "+ coutMinVP);
						pointRencontre = minTasVD.getSommet_courant();
					}
				}
				this.graphe.getDessin().setColor(java.awt.Color.pink);
				this.PccVD.unPasDijkstra();

				//si le cout de pieton-dest est plus petit que (ou =) voiture-dest
			}else{

				//si le nouveau min de tas Pieton est dans hashmap de voiture
				if ( this.PccVD.hmap.containsKey( minTasPD.getSommet_courant()) ){
					coutActuelVP = minTasPD.getCout() + this.PccVD.hmap.get(minTasPD.getSommet_courant()).getCout();

					if (coutActuelVP < coutMinVP){
						coutMinVP = coutActuelVP;
						System.out.println("coutMinVP : "+ coutMinVP);
						pointRencontre =  minTasPD.getSommet_courant();
					}
				}
				this.graphe.getDessin().setColor(java.awt.Color.orange);
				this.PccPD.unPasDijkstra();
			}		


			//2 conditions d'arret
			//1-- destination marquee dans la hmap de voiture et pieton
			//(on verifie d'abord s'ils sont presents dans les hmap PUIS s'ils sont marques pour eviter des erreurs)
			if (PccPD.hmap.containsKey(this.destination) && PccVD.hmap.containsKey(this.destination)){
				if(PccPD.hmap.get(this.destination).isMarquage() && PccVD.hmap.get(this.destination).isMarquage()){
					dernierPas = true;
				}
				//2-- OU destination et origine pieton marquee dans la hmap de voiture (cas ou pieton ne peut pas atteindre dest)
			}else if(PccVD.hmap.containsKey(this.pieton) && PccVD.hmap.containsKey(this.destination)){
				if (PccVD.hmap.get(this.pieton).isMarquage() && PccVD.hmap.get(this.destination).isMarquage()){
					dernierPas = true;
				}
			}

		}


		System.out.println("Compteur While : " + compteurWhile);

		//apres boucle
		if (pointRencontre != -1){	
			//faire le chemin rencontre-destination
			this.PccRD.setOrigine(pointRencontre);
			System.out.println( "numero de point de rencontre : " + pointRencontre);
			this.PccRD.initHmapEtTas();
			this.PccRD.dijkstra();
			//dessiner point de rencontre
			this.graphe.getDessin().setColor(java.awt.Color.black);
			this.graphe.getDessin().drawPoint(this.graphe.getSommets()[pointRencontre].getLongitude(),
					this.graphe.getSommets()[pointRencontre].getLatitude(), 10);
			//recupere les couts
			Chemin cheminPR = this.PccPD.recupereChemin(this.PccPD.hmap, this.pieton, pointRencontre);
			System.out.println("Taille de cheminPR : " + cheminPR.getSize());
			float coutPR = this.PccPD.graphe.calculCheminTpsPieton(cheminPR);
			Chemin cheminVR = this.PccVD.recupereChemin(this.PccVD.hmap, this.voiture, pointRencontre);
			System.out.println("Taille de cheminVR : " + cheminVR.getSize());
			float coutVR = this.PccPD.graphe.calculCheminTps(cheminVR);
			Chemin cheminRD = this.PccRD.recupereChemin(this.PccRD.hmap, pointRencontre, this.destination);
			System.out.println("Taille de cheminRD : " + cheminRD.getSize());
			float coutRD = this.PccPD.graphe.calculCheminTps(cheminRD);
			System.out.println();
			System.out.println("Cout total cov : ");
			System.out.println("Temps pieton avant rencontre : " + coutPR);
			System.out.println("Temps voiture avant rencontre : " + coutVR);
			System.out.println("Temps du point de rencontre a  destination : " + coutRD);
		}
		//
		else{
			System.out.println();
			System.out.println("On n'a pas trouve une solution");
		}
	}

}
