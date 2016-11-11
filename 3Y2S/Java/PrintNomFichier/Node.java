import java.io.*;

public abstract class Node {

	public String chemin;
	public String nom;
	public long taille;


	public Node(String chemin, long taille) {
		this.chemin = chemin;
		this.nom = FileInfo.getName(this.chemin);
		this.taille = taille;
	}

	public void setTaille(long taille) {
		this.taille = taille;
	}
	

	public long getTaille() {
		return taille;
	}

	public String getNom() {
		return this.nom;
	}

	public abstract void afficher();

	public abstract void afficherDecalage(String s);

}
