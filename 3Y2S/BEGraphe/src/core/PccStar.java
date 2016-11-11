package core;

import java.io.*;
import java.util.Date;

import base.Readarg;

public class PccStar extends Pcc {
	//tps d'execution de l'algo
	long chrono = 0;
	//taille de la hmap
	int hmapSize;
	//memoire utilisee
	long memory = 0;

	public PccStar(Graphe gr, PrintStream sortie, Readarg readarg) {
		super(gr, sortie, readarg);
	}

	//sert a cov
	public PccStar(Graphe gr, PrintStream sortie, Readarg readarg,
			int origine, int destination ) {
		super(gr, sortie, readarg, origine, destination);
	}

	public void run() {

		System.out.println("Run PCC-Star de " + zoneOrigine + ":" + origine
				+ " vers " + zoneDestination + ":" + destination);
		this.graphe.getDessin().setColor(java.awt.Color.gray);
		// A vous d'implementer la recherche de plus court chemin A*
		if (this.choixCout == 0 || this.choixCout == 1){
			long dateDebut = new Date().getTime();
			this.dijkstra();
			// Affichage
			System.out.println("Nombre max dans le tas : " + maxSizeTas + "/" + this.graphe.getSommets().length);
			long dateFin = new Date().getTime();

			chrono = dateFin - dateDebut;
			//taille de la hmap
			hmapSize = this.hmap.size();

			System.out.println("Temps d'execution de l'algo (en ms): " + chrono);

			//memoire utilisee
			Runtime rt =Runtime.getRuntime();
			memory = rt.totalMemory()-rt.freeMemory();
			System.out.println("Memoire Utilise (en octet): " + memory);

			System.out.println("Taille de la hashmap: " + hmapSize);
			System.out.println();
		}else{
			System.out.println("Wrong input: choix du cout incorrect!");
		}
	}

	//dans ce label, ajout du cout estimee
	public Label initLabel(int pere, int sommetCourant){
		if (this.choixCout == 0) {
			return new LabelStar(false, 9000000, pere, sommetCourant,
					this.graphe.calculCoutEstimeeDist(sommetCourant, this.destination));
		} else {
			return new LabelStar(false, 9000000, pere, sommetCourant,
					this.graphe.calculCoutEstimeeTps(sommetCourant, this.destination));
		}
	}

	//recupere le temps d'execution du A*
	public long getChrono() {
		return chrono;
	}

	//retourne la taille de la hmap
	public int getHmapSize() {
		return hmapSize;
	}

	//retourne le memoire utilisee
	public long getMemory() {
		return memory;
	}
}
