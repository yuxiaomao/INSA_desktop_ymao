package core;

import java.io.*;
import java.util.*;

import base.BinaryHeap;
import base.Readarg;

public class Pcc extends Algo {

	// Numero des sommets origine et destination
	protected int zoneOrigine;
	protected int origine;

	protected int zoneDestination;
	protected int destination;

	// Pour choisir le cout en distance ou en tps
	protected int choixCout;
	protected int maxSizeTas = 0;

	public HashMap<Integer, Label> hmap;
	public BinaryHeap<Label> tas;
	
	//pour les tests: un chemin trouve?
	public boolean cheminTrouve;
	//tps d'execution de l'algo
	long chrono = 0;
	//taille de la hmap
	int hmapSize = 0;
	//memoire utilisee
	long memory = 0;

	public Pcc(Graphe gr, PrintStream sortie, Readarg readarg) {
		super(gr, sortie, readarg);
		System.out.println();
		System.out.println("0 - Distance minimale");
		System.out.println("1 - Temps minimum");
		this.choixCout = readarg.lireInt("Choix du cout ? ");
		System.out.println();

		this.zoneOrigine = gr.getZone();
		this.origine = readarg.lireInt("Numero du sommet d'origine ? ");

		// Demander la zone et le sommet destination.
		this.zoneDestination = gr.getZone();
		this.destination = readarg.lireInt("Numero du sommet destination ? ");

		// Hashmap avec label et sommet correspondant	
		this.initHmapEtTas();
		
		//au debut pas de chemin trouve
		this.cheminTrouve = false;
	}

	//pour cov et test, n'a pas besion entrer les num de sommet a la main
	public Pcc(Graphe gr, PrintStream sortie, Readarg readarg, int origine, int destination ) {
		super(gr, sortie, readarg);
		//algo en temps min
		this.choixCout = 1;

		this.zoneOrigine = gr.getZone();
		this.origine = origine;

		// Demander la zone et le sommet destination.
		this.zoneDestination = gr.getZone();
		this.destination = destination;

		// Hashmap avec label et sommet correspondant	
		this.initHmapEtTas();

	}


	public void setOrigine(int origine) {
		this.origine = origine;
	}
	
	public void setDestination(int destination) {
		this.destination = destination;
	}

	//si on a changer origine il faut relance initHmapEtTas, comme dans le cas covoiturage
	//apres appel de cette fonction, le hmap et le tas sont non null 
	public void initHmapEtTas(){
		this.hmap = new HashMap<Integer, Label>();
		Label lOrigine;
		lOrigine = this.initLabel(-1,origine);//origine n'a pas de pere
		lOrigine.setCout(0);
		this.hmap.put(origine, lOrigine);//on ajoute origine dans hmap

		this.tas = new BinaryHeap<Label>();
		this.tas.insert(lOrigine);//on ajoute origine dans tas
	}


	public void run() {
		System.out
		.println("Run PCC de " + zoneOrigine + ":" + origine + " vers " + zoneDestination + ":" + destination);
		this.graphe.getDessin().setColor(java.awt.Color.green);
		// A vous d'implementer la recherche de plus court chemin.
		if (this.choixCout == 0 || this.choixCout == 1){
			//chrono debut
			long dateDebut = new Date().getTime();
			
			//algo
			this.dijkstra();
			
			// Affichage
			System.out.println("Nombre max dans le tas : " + maxSizeTas + "/" + this.graphe.getSommets().length);
			
			//chrono fin
			long dateFin = new Date().getTime();
			
			//tps d'execution de l'algo
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


	// pour pouvoir utilise autrement, pour choisir les 2 pts qu'on applique dijkstra
	// ne pas utiliser this.origine ni this.destination dans dijkstra
	public void dijkstra(){
		// top depart

		// si le tas est vide alors on sait qu'il n'y a pas de chemin possible
		while ((!tas.isEmpty()) && (hmap.get(destination) == null)) {
				this.unPasDijkstra();
		}// les labels bien remplis

		if (hmap.get(destination) != null){
			//un chemin a ete trouve
			this.cheminTrouve = true;
			
			// recupere le chemin parcouru
			Chemin chemin = this.recupereChemin(this.hmap, this.origine, this.destination);
			float cout = this.retourneCoutChemin(chemin);
			// on affiche les resultats uniquement si le chemin existe
			System.out.println();
			System.out.println("** Resultats de chemin");
			if (this.choixCout == 0) {
				System.out.println("Cout en distance du chemin (en m): " + cout  );
			} else {
				System.out.println("Cout en tps du chemin (en min): " + cout);
			}
			System.out.println("Taille du chemin: " + chemin.getSize());
		}else{
			System.out.println();
			System.out.println("** Chemin null");
		}
	}


	//peut lancer uniquement si le tas n'est pas vide
	public void unPasDijkstra(){
		Label x = tas.deleteMin();

		// dessine chaque sommet sorti du tas
		this.graphe.getDessin().drawPoint(this.graphe.getSommets()[x.getSommet_courant()].getLongitude(),
				this.graphe.getSommets()[x.getSommet_courant()].getLatitude(), 5);
		
		x.setMarquage(true);

		Iterator<Arc> it = this.graphe.getSommets()[x.getSommet_courant()].arcs.iterator();
		for (; it.hasNext();) {
			Arc a = it.next();// parcourir tout arc sortant de x
			Label y;// un successeur de x

			// on verifie si le successeur est dans la hashmap
			if (hmap.containsKey(a.getDest_node())) {
				y = hmap.get(a.getDest_node());
				// ...et sinon on l'initialise et on ajoute le label y
				// dans la hashmap
			} else {
				y = initLabel(x.getSommet_courant(), a.getDest_node());
				// pere de y est x
				hmap.put(a.getDest_node(), y);
			}

			if (!y.isMarquage()) {
				// calcul du cout x vers y
				float coutXtoY;
				coutXtoY = this.calculCoutXtoY(x.getSommet_courant(), y.getSommet_courant());
				float nouveauCout = x.getCout() + coutXtoY;
				if (y.getCout() > nouveauCout) {
					y.setCout(nouveauCout);
					tas.updateOrInsert(y);

					y.setPere(x.getSommet_courant());
					if (maxSizeTas < tas.size()) {
						maxSizeTas = tas.size();
					}
				}
			}
		}
	}

	//apres voir fini le parcours, on obtient un hmap
	//si un tel chemin est possible, nous pouvons le recupere 
	public Chemin recupereChemin(HashMap<Integer,Label> hmap, int origine, int destination){
		// recupere le chemin parcouru
		Chemin chemin = new Chemin();
		if (hmap.get(destination) == null){
			System.out.println("Il n'existe pas de chemin entre origine et destination");
		} else {
			Label l = hmap.get(destination);
			for (; l.getSommet_courant() != origine;) {
				chemin.addSommetInverse(l.getSommet_courant());
				l = hmap.get(l.getPere());

			}
			chemin.addSommetInverse(origine);
		}
		return chemin;
	}


	//Si chemin null cout=0
	//trouve, a partir d'un chemin, son cout
	public float retourneCoutChemin(Chemin chemin){
		float cout = 0.0f;
		// chemin n'est pas null car on l'initialise, mais on peut faire getSize
		if (chemin.getSize() != 0){
			// calcul cout
			if (this.choixCout == 0) {
				cout = this.graphe.calculCheminDist(chemin);
			} else {
				cout = this.graphe.calculCheminTps(chemin);
			}
		}
		return cout;

	}


	public Label initLabel(int pere, int sommetCourant){
		return new Label(false, 9000000 , pere, sommetCourant);
	}

	public float calculCoutXtoY(int s1, int s2){
		float coutXtoY;
		if (this.choixCout == 0) {
			coutXtoY = this.graphe.calculCoutDist(s1, s2);
		} else {
			coutXtoY = this.graphe.calculCoutTps(s1, s2);
		}
		return coutXtoY;	
	}

	//GETTEURS POUR TESTS
	//retourne vrai si un chemin est trouve par l'algo
	public boolean isCheminTrouve() {
		return cheminTrouve;
	}

	//retourne le nb max de nodes dans le tas
	public int getMaxSizeTas() {
		return maxSizeTas;
	}

	//retourne tps d'execution de l'algo
	public long getChrono() {
		return chrono;
	}

	//retourne la taille de la hmap
	public int getHmapSize() {
		return hmapSize;
	}

	//retourne la memoire utilisee
	public long getMemory() {
		return memory;
	}

}

