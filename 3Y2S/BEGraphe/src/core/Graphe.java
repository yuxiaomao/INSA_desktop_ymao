package core;

/**
 *   Classe representant un graphe.
 *   A vous de completer selon vos choix de conception.
 */

import java.io.*;
import java.util.Iterator;

import base.*;

public class Graphe {

	// Nom de la carte utilisee pour construire ce graphe
	private final String nomCarte;

	// Fenetre graphique
	private final Dessin dessin;

	// Version du format MAP utilise'.
	private static final int version_map = 4;
	private static final int magic_number_map = 0xbacaff;

	// Version du format PATH.
	private static final int version_path = 1;
	private static final int magic_number_path = 0xdecafe;

	// Identifiant de la carte
	private int idcarte;

	// Numero de zone de la carte
	private int numzone;
	
	//Nombre de noeuds/sommets
	private int nb_nodes;

	/*
	 * Ces attributs constituent une structure ad-hoc pour stocker les
	 * informations du graphe. Vous devez modifier et ameliorer ce choix de
	 * conception simpliste.
	 */
	// private float[] longitudes ;
	// private float[] latitudes ;
	private Sommet[] sommets;
	private Descripteur[] descripteurs;

	// Deux malheureux getters.
	public Dessin getDessin() {
		return dessin;
	}

	public int getZone() {
		return numzone;
	}

	// Le constructeur cree le graphe en lisant les donnees depuis le
	// DataInputStream
	public Graphe(String nomCarte, DataInputStream dis, Dessin dessin) {

		this.nomCarte = nomCarte;
		this.dessin = dessin;
		Utils.calibrer(nomCarte, dessin);

		// Lecture du fichier MAP.
		// Voir le fichier "FORMAT" pour le detail du format binaire.
		try {

			// Nombre d'aretes
			int edges = 0;

			// Verification du magic number et de la version du format du
			// fichier .map
			int magic = dis.readInt();
			int version = dis.readInt();
			Utils.checkVersion(magic, magic_number_map, version, version_map,
					nomCarte, ".map");

			// Lecture de l'identifiant de carte et du numero de zone,
			this.idcarte = dis.readInt();
			this.numzone = dis.readInt();

			// Lecture du nombre de descripteurs, nombre de noeuds.
			int nb_descripteurs = dis.readInt();
			nb_nodes = dis.readInt();

			// Nombre de successeurs enregistres dans le fichier.
			int[] nsuccesseurs_a_lire = new int[nb_nodes];

			// En fonction de vos choix de conception, vous devrez certainement
			// adapter la suite.
			// this.longitudes = new float[nb_nodes] ;
			// this.latitudes = new float[nb_nodes] ;
			this.sommets = new Sommet[nb_nodes];
			this.descripteurs = new Descripteur[nb_descripteurs];

			// Lecture des noeuds
			for (int num_node = 0; num_node < nb_nodes; num_node++) {
				// Lecture du noeud numero num_node
				// longitudes[num_node] = ((float)dis.readInt ()) / 1E6f ;
				// latitudes[num_node] = ((float)dis.readInt ()) / 1E6f ;
				sommets[num_node] = new Sommet(((float) dis.readInt()) / 1E6f,
						((float) dis.readInt()) / 1E6f);
				nsuccesseurs_a_lire[num_node] = dis.readUnsignedByte();
			}

			Utils.checkByte(255, dis);

			// Lecture des descripteurs
			for (int num_descr = 0; num_descr < nb_descripteurs; num_descr++) {
				// Lecture du descripteur numero num_descr
				descripteurs[num_descr] = new Descripteur(dis);

				// On affiche quelques descripteurs parmi tous.
				if (0 == num_descr % (1 + nb_descripteurs / 400))
					System.out.println("Descripteur " + num_descr + " = "
							+ descripteurs[num_descr]);
			}

			Utils.checkByte(254, dis);

			// Lecture des successeurs
			for (int num_node = 0; num_node < nb_nodes; num_node++) {
				// Lecture de tous les successeurs du noeud num_node
				for (int num_succ = 0; num_succ < nsuccesseurs_a_lire[num_node]; num_succ++) {
					// zone du successeur
					int succ_zone = dis.readUnsignedByte();

					// numero de noeud du successeur
					int dest_node = Utils.read24bits(dis);

					// descripteur de l'arete
					int descr_num = Utils.read24bits(dis);

					// longueur de l'arete en metres
					int longueur = dis.readUnsignedShort();

					// System.out.println("longueur = " + longueur + " type = "
					// + descripteurs[descr_num].getType()) ;

					Arc a = new Arc(succ_zone, dest_node,
							descripteurs[descr_num], longueur);
					sommets[num_node].addArc(a);
					//pour graphe inverse
					/*Arc ainv = new Arc(succ_zone, num_node,
							descripteurs[descr_num], longueur);
					sommets[dest_node].addPredecesseur(ainv);*/

					// dans le cas ou la arc pas en sens unique
					if (descripteurs[descr_num].isSensUnique() == false) {
						Arc b = new Arc(numzone, num_node,
								descripteurs[descr_num], longueur);
						sommets[dest_node].addArc(b);
						/*Arc binv = new Arc(succ_zone, dest_node,
								descripteurs[descr_num], longueur);
						sommets[num_node].addPredecesseur(binv);*/
					}

					// Nombre de segments constituant l'arete
					int nb_segm = dis.readUnsignedShort();

					edges++;

					Couleur.set(dessin, descripteurs[descr_num].getType());

					float current_long = sommets[num_node].getLongitude();
					float current_lat = sommets[num_node].getLatitude();

					// Chaque segment est dessine'
					for (int i = 0; i < nb_segm; i++) {
						float delta_lon = (dis.readShort()) / 2.0E5f;
						float delta_lat = (dis.readShort()) / 2.0E5f;
						dessin.drawLine(current_long, current_lat,
								(current_long + delta_lon),
								(current_lat + delta_lat));
						current_long += delta_lon;
						current_lat += delta_lat;
					}

					// Le dernier trait rejoint le sommet destination.
					// On le dessine si le noeud destination est dans la zone du
					// graphe courant.
					if (succ_zone == numzone) {
						dessin.drawLine(current_long, current_lat,
								sommets[dest_node].getLongitude(),
								sommets[dest_node].getLatitude());
					}
				}
			}

			Utils.checkByte(253, dis);

			System.out.println("Fichier lu : " + nb_nodes + " sommets, "
					+ edges + " aretes, " + nb_descripteurs + " descripteurs.");

		} catch (IOException e) {
			e.printStackTrace();
			System.exit(1);
		}

	}

	// Rayon de la terre en metres
	private static final double rayon_terre = 6378137.0;

	/**
	 * Calcule de la distance orthodromique - plus court chemin entre deux
	 * points à la surface d'une sphère
	 * 
	 * @param long1
	 *            longitude du premier point.
	 * @param lat1
	 *            latitude du premier point.
	 * @param long2
	 *            longitude du second point.
	 * @param lat2
	 *            latitude du second point.
	 * @return la distance entre les deux points en metres. Methode écrite par
	 *         Thomas Thiebaud, mai 2013
	 */
	public static double distance(double long1, double lat1, double long2,
			double lat2) {
		double sinLat = Math.sin(Math.toRadians(lat1))
				* Math.sin(Math.toRadians(lat2));
		double cosLat = Math.cos(Math.toRadians(lat1))
				* Math.cos(Math.toRadians(lat2));
		double cosLong = Math.cos(Math.toRadians(long2 - long1));
		return rayon_terre * Math.acos(sinLat + cosLat * cosLong);
	}

	/**
	 * Attend un clic sur la carte et affiche le numero de sommet le plus proche
	 * du clic. A n'utiliser que pour faire du debug ou des tests ponctuels. Ne
	 * pas utiliser automatiquement a chaque invocation des algorithmes.
	 */
	public void situerClick() {

		System.out.println("Allez-y, cliquez donc.");

		if (dessin.waitClick()) {
			float lon = dessin.getClickLon();
			float lat = dessin.getClickLat();

			System.out.println("Clic aux coordonnees lon = " + lon + "  lat = "
					+ lat);

			// On cherche le noeud le plus proche. O(n)
			float minDist = Float.MAX_VALUE;
			int noeud = 0;

			for (int num_node = 0; num_node < sommets.length; num_node++) {
				float londiff = (sommets[num_node].getLongitude() - lon);
				float latdiff = (sommets[num_node].getLatitude() - lat);
				float dist = londiff * londiff + latdiff * latdiff;
				if (dist < minDist) {
					noeud = num_node;
					minDist = dist;
				}
			}

			System.out.println("Noeud le plus proche : " + noeud);
			System.out.println();
			dessin.setColor(java.awt.Color.red);
			dessin.drawPoint(sommets[noeud].getLongitude(),
					sommets[noeud].getLatitude(), 5);
		}
	}

	/**
	 * Charge un chemin depuis un fichier .path (voir le fichier FORMAT_PATH qui
	 * decrit le format) Verifie que le chemin est empruntable et calcule le
	 * temps de trajet.
	 */
	public void verifierChemin(DataInputStream dis, String nom_chemin) {

		try {

			// Verification du magic number et de la version du format du
			// fichier .path
			int magic = dis.readInt();
			int version = dis.readInt();
			Utils.checkVersion(magic, magic_number_path, version, version_path,
					nom_chemin, ".path");

			// Lecture de l'identifiant de carte
			int path_carte = dis.readInt();

			if (path_carte != this.idcarte) {
				System.out.println("Le chemin du fichier " + nom_chemin
						+ " n'appartient pas a la carte actuellement chargee.");
				System.exit(1);
			}

			int nb_noeuds = dis.readInt();

			// structure pour stocker un chemin
			Chemin chemin = new Chemin();

			// Origine du chemin
			int first_zone = dis.readUnsignedByte();
			int first_node = Utils.read24bits(dis);

			// Destination du chemin
			int last_zone = dis.readUnsignedByte();
			int last_node = Utils.read24bits(dis);

			System.out.println("Chemin de " + first_zone + ":" + first_node
					+ " vers " + last_zone + ":" + last_node);

			int current_zone = 0;
			int current_node = 0;

			// Tous les noeuds du chemin
			for (int i = 0; i < nb_noeuds; i++) {
				current_zone = dis.readUnsignedByte();
				current_node = Utils.read24bits(dis);

				// construction du chemin
				chemin.addSommet(current_node);

				System.out.println(" --> " + current_zone + ":" + current_node);
			}

			if ((current_zone != last_zone) || (current_node != last_node)) {
				System.out.println("Le chemin " + nom_chemin
						+ " ne termine pas sur le bon noeud.");
				System.exit(1);
			}

			// on teste nos fcts calcul_cout et calcul_chemin
			float test_cout_dist = calculCheminDist(chemin);
			float test_cout_tps = calculCheminTps(chemin);
			System.out.println("Test distance et temps");
			System.out.println("Distance min = " + test_cout_dist + " m");
			System.out.println("Temps de trajet min = " + test_cout_tps
					+ " min");

		} catch (IOException e) {
			e.printStackTrace();
			System.exit(1);
		}

	}

	// pour tester le nombre moyenne d'arc par sommet
	public float testMoyenArc() {
		int compteur = 0;
		for (int num_node = 0; num_node < sommets.length; num_node++) {
			Iterator<Arc> it = sommets[num_node].arcs.iterator();
			while (it.hasNext()) {
				it.next();
				compteur++;
			}
		}
		return (float) compteur / sommets.length;
	}
	
	//calculer le cout entre deux sommet
	public float calculCoutDist(int s1, int s2){
		float min_dist = 9000000.0f;
		Iterator<Arc> it = sommets[s1].arcs.iterator();
		while (it.hasNext()) {
			Arc a = it.next();
			if (a.getDest_node() == s2) {
				int current_dist = a.getLongueur();
				
				if (current_dist < min_dist) {
					min_dist = current_dist;
				}
			}
		}
		
		//on enleve l'affichage pour gagner du temps pour les tests
		/*
		if (min_dist == 9000000)  {
			System.out.println("Dist. Il n'existe pas d'arc entre les sommets " + s1
					+ " et " + s2);
		}
		*/
		
		return min_dist;
	}
	
	public float calculCoutTps(int s1, int s2){
		float min_tps = 9000000.0f;
		Iterator<Arc> it = sommets[s1].arcs.iterator();
		while (it.hasNext()) {
			Arc a = it.next();
			if (a.getDest_node() == s2) {
				float current_tps = ((float) a.getLongueur() * 0.001f * 60)
						/ (a.getDescr().vitesseMax());
				if (current_tps < min_tps) {
					min_tps = current_tps;
				}
			}
		}
		
		//on enleve l'affichage pour gagner du temps pour les tests
		/*
		if (min_tps == 9000000.0f) {
			System.out.println("Tps. Il n'existe pas d'arc entre les sommets " + s1
					+ " et " + s2);
		}
		*/
		
		return min_tps;
	}
	
	public float calculCoutTpsPieton(int s1, int s2){
		float min_tps = 9000000.0f;
		Iterator<Arc> it = sommets[s1].arcs.iterator();
		while (it.hasNext()) {
			Arc a = it.next();
			// tant que le s est ce qu'on veut, et que le pieton peut y marche
			if ((a.getDest_node() == s2)&& (a.getDescr().vitesseMax()<110) ) {
				float current_tps = ((float) a.getLongueur() * 0.001f * 60)
						/ (4);//4km/h
				if (current_tps < min_tps) {
					min_tps = current_tps;
				}
			}
		}
		if (min_tps == 9000000.0f) {
			System.out.println("Il n'existe pas d'arc accessible aux pietons entre les sommets " + s1
					+ " et " + s2 );
		}
		return min_tps;
	}
	
	
	//calculer le cout pour un chemin
	public float calculCheminDist(Chemin chemin){
			float cout_dist = 0.0f;
			//dessiner point de depart et d'arrive
			dessin.setColor(java.awt.Color.blue);
			dessin.drawPoint(sommets[chemin.getSommet(0)].getLongitude(),
					sommets[chemin.getSommet(0)].getLatitude(), 5);
			dessin.drawPoint(sommets[chemin.getSommet(chemin.getSize() - 1)].getLongitude(),
					sommets[chemin.getSommet(chemin.getSize() - 1)].getLatitude(), 5);

			// length-1 car besoin de 2 sommets pour calculer un cout
			for (int i = 0; i < chemin.getSize() - 1; i++) {
				cout_dist += this.calculCoutDist(chemin.getSommet(i), chemin.getSommet(i+1));
				dessinerArc(chemin.getSommet(i), chemin.getSommet(i + 1));
			}
			return cout_dist;
	}
	
	public float calculCheminTps(Chemin chemin){
		float cout_tps = 0.0f;
		//dessiner point de depart et d'arrive
		dessin.setColor(java.awt.Color.blue);
		dessin.drawPoint(sommets[chemin.getSommet(0)].getLongitude(),
				sommets[chemin.getSommet(0)].getLatitude(), 5);
		dessin.drawPoint(sommets[chemin.getSommet(chemin.getSize() - 1)].getLongitude(),
				sommets[chemin.getSommet(chemin.getSize() - 1)].getLatitude(), 5);

		// length-1 car besoin de 2 sommets pour calculer un cout
		for (int i = 0; i < chemin.getSize() - 1; i++) {
			cout_tps += this.calculCoutTps(chemin.getSommet(i), chemin.getSommet(i+1));
			dessinerArc(chemin.getSommet(i), chemin.getSommet(i + 1));
		}
		return cout_tps;
	}
	
	
	public float calculCheminTpsPieton(Chemin chemin){
		float cout_tps = 0.0f;
		//dessiner point de depart et d'arrive
		dessin.setColor(java.awt.Color.blue);
		dessin.drawPoint(sommets[chemin.getSommet(0)].getLongitude(),
				sommets[chemin.getSommet(0)].getLatitude(), 5);
		dessin.drawPoint(sommets[chemin.getSommet(chemin.getSize() - 1)].getLongitude(),
				sommets[chemin.getSommet(chemin.getSize() - 1)].getLatitude(), 5);

		// length-1 car besoin de 2 sommets pour calculer un cout
		for (int i = 0; i < chemin.getSize() - 1; i++) {
			cout_tps += this.calculCoutTpsPieton(chemin.getSommet(i), chemin.getSommet(i+1));
			dessinerArc(chemin.getSommet(i), chemin.getSommet(i + 1));
		}
		return cout_tps;
	}
	
	//estimation de cout pour PccStar
	public double calculCoutEstimeeDist(int s1, int s2){// en m
		return Graphe.distance(sommets[s1].getLongitude(), sommets[s1].getLatitude(),
				sommets[s2].getLongitude(), sommets[s2].getLatitude());	
	}
	
	public double calculCoutEstimeeTps(int s1, int s2){// division 130km/h, en min
		return (Graphe.distance(sommets[s1].getLongitude(), sommets[s1].getLatitude(),
				sommets[s2].getLongitude(), sommets[s2].getLatitude()) / (130000)) * 60;	
	}
	
	public double calculCoutEstimeeTpsPieton(int s1, int s2){// division 4km/h, en min
		return (Graphe.distance(sommets[s1].getLongitude(), sommets[s1].getLatitude(),
				sommets[s2].getLongitude(), sommets[s2].getLatitude()) / (4)) * 60;	
	}
	
	//pour dessiner des Arc et des chemins parcouru
	public void dessinerArc(int s1, int s2) {
		// dessin.setColor(java.awt.Color.blue);
		dessin.drawLine(sommets[s1].getLongitude(), sommets[s1].getLatitude(),
				sommets[s2].getLongitude(), sommets[s2].getLatitude());
	}


	public Sommet[] getSommets(){
		return this.sommets;
	}

	//on recup le nb de sommets du graphe
	// =getSommets().length
	public int getNbNodes() {
		return nb_nodes;
	}

}
