package core;

import java.util.ArrayList;

public class Sommet {
	private float longitude;
	private float latitude;
	ArrayList<Arc> arcs; //une liste des arcs o¨´ l'origine est ce sommet 
	ArrayList<Arc> predecesseurs;

	public Sommet(float longitude, float latitude) {
		this.longitude = longitude;
		this.latitude = latitude;
		this.arcs = new ArrayList<Arc>();
		//this.predecesseurs = new ArrayList<Arc>();
	}

	public float getLongitude() {
		return this.longitude;
	}

	public float getLatitude() {
		return this.latitude;
	}

	public void addArc(Arc a) {
		arcs.add(a);
	}
	
	
	/*public void addPredecesseur(Arc a) {
		predecesseurs.add(a);
	}*/
}
