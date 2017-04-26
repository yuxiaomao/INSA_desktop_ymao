import java.util.HashMap;

import perso.Enseignant;

public class EnseignantChercheurHashMap extends Enseignant implements IChercheur {

	private HashMap<Integer, Publication> mapPublication;
	private int indiceHashMap;

	public EnseignantChercheurHashMap(String nom, int age, int heures) {
		super(nom, age, heures);
		this.mapPublication = new HashMap<Integer, Publication>();
		this.indiceHashMap = 0;
	}

	public void ajouterPublication(Publication p) {
		this.mapPublication.put(this.indiceHashMap, p);
		this.indiceHashMap++;
	}

	public String listerPublications() {
		return this.mapPublication.toString();
	}

	public String toString() {
		return "EnseignantChercheurHashMap " + super.toString()
				+ ". Liste des publications:" + this.listerPublications();
	}

}
