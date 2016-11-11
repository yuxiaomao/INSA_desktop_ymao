package core;

import java.io.*;
import base.Readarg;

//Pcc specialise pour la vitesse de pieton
public class PccPieton extends Pcc {

	public PccPieton(Graphe gr, PrintStream sortie, Readarg readarg) {
		super(gr, sortie, readarg);
	}
	
	//sert a cov
	public PccPieton(Graphe gr, PrintStream sortie, Readarg readarg,
			int origine, int destination ) {
		super(gr, sortie, readarg, origine, destination);
	}

	public void run() {

		System.out.println("Run PCC-Pieton-Star de " + zoneOrigine + ":" + origine
				+ " vers " + zoneDestination + ":" + destination);
		this.graphe.getDessin().setColor(java.awt.Color.gray);
		// A vous d'implementer la recherche de plus court chemin A*
		this.dijkstra();

	}
	
	
	public float calculCoutXtoY(int s1, int s2){
		float coutXtoY;
		if (this.choixCout == 0) {// ne sais pas encore comment faire pour dist
			coutXtoY = this.graphe.calculCoutDist(s1, s2);
		} else {
			coutXtoY = this.graphe.calculCoutTpsPieton(s1, s2);
		}
		return coutXtoY;	
	}

}
