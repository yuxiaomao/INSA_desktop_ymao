
import java.util.*;

public class Personne {

	private String nom;
	private ArrayList<Activite> listeActivite;


	public Personne(String nom){
		this.nom = nom;
		this.listeActivite = new ArrayList<Activite>();
	}

	public void addActivite(Activite act){
		this.listeActivite.add(act);
	}

	public void afficherActivite(){
		for (Iterator<Activite> it = this.listeActivite.iterator() ; it.hasNext(); ) {
			Activite a = it.next();
			a.afficher();
		}
	}

	@Override
	public String toString() {
		return "Personne [nom=" + nom + ", listeActivite=" + listeActivite
				+ "]";
	}  


}
