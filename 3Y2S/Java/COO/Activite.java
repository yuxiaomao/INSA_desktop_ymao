
import java.util.*;

public class Activite {

	private String nom;
	private Personne pers1;
	private Personne pers2;
	private ArrayList<Tache> listeTache;

	//activite realise par 1 personne
	public Activite(String nom,Personne pers1){
		this.nom = nom;
		this.pers1 = pers1;
		this.pers1.addActivite(this);
		this.pers2 = null;
		this.listeTache = new ArrayList<Tache>() ;
	}

	//activite realise par 2 personnes
	public Activite(String nom,Personne pers1,Personne pers2){
		this.nom = nom;
		this.pers1 = pers1;
		this.pers1.addActivite(this);
		this.pers2 = pers2;
		this.pers2.addActivite(this);

		this.listeTache = new ArrayList<Tache>() ;
	}

	public void addTache(Tache t) throws PersNonPermis {
		if ((t.getPers() != pers1)&&(t.getPers() != pers2)){
			throw new PersNonPermis("out of 2");
		}else{
			this.listeTache.add(t);
		}
	}


	public void afficher(){
		System.out.println(this.nom+this.pers1+this.pers2);
		for (Iterator<Tache> it = this.listeTache.iterator() ; it.hasNext(); ) {
			Tache t = it.next();
			t.afficher();
		}


	}

}
