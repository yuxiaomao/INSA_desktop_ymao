import java.io.*;
import java.util.*;

public class Dossier extends Node {

	private ArrayList<Node> elements;

	public Dossier(String chemin) throws IOException {
		super(chemin, 0);
		this.elements = new ArrayList<Node>();
		long tailleD = 0;
		tailleD = this.initArrayTaille(chemin, tailleD);
		this.setTaille(tailleD);
	}

	// y compris construit array et calcul taille
	public long initArrayTaille(String chemin, long accumuleTaille)
			throws IOException {
		long taille = accumuleTaille;
		for (Iterator<String> it = FileInfo.getElements(chemin); it.hasNext();) {
			String eChemin = it.next();
			if (FileInfo.isDirectory(eChemin)) {
				Dossier eDossier = new Dossier(eChemin);
				this.elements.add(eDossier);
				taille += this.initArrayTaille(eChemin, 0);
			} else {
				Fichier eFichier = new Fichier(eChemin);
				this.elements.add(eFichier);
				taille += FileInfo.size(eChemin);
			}
		}
		return taille;
	}

	// affichage sans decalage
	public void afficher() {
		System.out.println(this.getNom());
		for (Iterator<Node> it = elements.iterator(); it.hasNext();) {
			Node eNext = it.next();
			eNext.afficher();
		}
	}

	// affichage avec decalage
	public void afficherDecalage(String decalage) {
		System.out.println(decalage + '+' + this.getNom());
		for (Iterator<Node> it = elements.iterator(); it.hasNext();) {
			Node eNext = it.next();
			eNext.afficherDecalage(decalage + "    ");
		}
	}

}
