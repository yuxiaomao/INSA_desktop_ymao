package core;

import java.io.PrintStream;
import java.util.Iterator;

import base.Readarg;

//n'entre pas dans notre algorithme
public class PccStarGrapheInverse extends PccStar {

	public PccStarGrapheInverse(Graphe gr, PrintStream sortie, Readarg readarg) {
		super(gr, sortie, readarg);
	}

	public PccStarGrapheInverse(Graphe gr, PrintStream sortie, Readarg readarg, int origine, int destination) {
		super(gr, sortie, readarg, origine, destination);
	}
	
	// envie de midifie Dijkstra pour qu'il parcours ид sens inverse
	public void unPasDijkstra(){
		Label x = tas.deleteMin();

		// dessine chaque sommet sorti du tas
		this.graphe.getDessin().drawPoint(this.graphe.getSommets()[x.getSommet_courant()].getLongitude(),
				this.graphe.getSommets()[x.getSommet_courant()].getLatitude(), 5);

		x.setMarquage(true);
		// nbSommetMarque++;


		Iterator<Arc> it = this.graphe.getSommets()[x.getSommet_courant()].predecesseurs.iterator();
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
					// on a choisi plus court chemin

					y.setPere(x.getSommet_courant());
					if (maxSizeTas < tas.size()) {
						maxSizeTas = tas.size();
					}
				}
			}
		}
	}

	
}
