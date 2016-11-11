package core;

import base.Descripteur;

//un arc partant d'un sommet
public class Arc {
	
	private int succ_zone;
	private int dest_node;
	private Descripteur descr;
	private int longueur;  // en metres!

	public Arc(int succ_zone, int dest_node, Descripteur descr, int longueur) {
		this.succ_zone = succ_zone;
		this.dest_node = dest_node;
		this.descr = descr;
		this.longueur = longueur;
	}

	public int getDest_node() {
		return dest_node;
	}

	public int getLongueur() {
		return longueur;
	}

	public Descripteur getDescr() {
		return descr;
	}
}
