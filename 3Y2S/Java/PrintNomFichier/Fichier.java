import java.io.*;

public class Fichier extends Node {

	public Fichier(String chemin) throws IOException {
		super(chemin, FileInfo.size(chemin));

	}

	// affichage sans decalage
	public void afficher() {
		System.out.println("nom:" + this.nom + ' ' + "taille:" + this.taille);
	}

	// affichage avec decalage
	public void afficherDecalage(String decalage) {
		System.out.println(decalage + '/' + this.nom + ' ' + "[" + this.taille
				+ " octets]");
	}

}
