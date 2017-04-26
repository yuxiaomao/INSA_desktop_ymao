import java.util.Vector;

import perso.Enseignant;

public class EnseignantChercheurVector extends Enseignant implements IChercheur {

	private Vector<Publication> vectorPublication;

	public EnseignantChercheurVector(String nom, int age, int heures) {
		super(nom, age, heures);
		this.vectorPublication = new Vector<Publication>();
	}

	public void ajouterPublication(Publication p) {
		this.vectorPublication.add(p);
	}

	public String listerPublications() {
		return this.vectorPublication.toString();
	}

	public String toString() {
		return "EnseignantChercheurVector " + super.toString()
				+ ". Liste des publications:" + this.listerPublications();
	}

}
