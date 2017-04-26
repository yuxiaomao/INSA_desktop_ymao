import perso.Enseignant;

public class EnseignantChercheur extends Enseignant implements IChercheur {

	private Publication tabPublication[];
	//max capacity = 10
	private int indiceNextPublication;

	public EnseignantChercheur(String nom, int age, int heures) {
		super(nom, age, heures);
		this.tabPublication = new Publication[10];
		this.indiceNextPublication = 0;
	}

	// add publication when less then 10 existed
	public void ajouterPublication(Publication p) {
		if (this.indiceNextPublication < 10) {
			this.tabPublication[this.indiceNextPublication] = p;
			this.indiceNextPublication++;
		}
	}

	public String listerPublications() {
		String s = "";
		for (int i = 0; i < this.indiceNextPublication; i++) {
			s = s + "[" + this.tabPublication[i].toString() + "]";
		}
		return s;
	}

	public String toString() {
		return "EnseignantChercheur " + super.toString()
				+ ". Liste des publications:" + this.listerPublications();
	}

}
