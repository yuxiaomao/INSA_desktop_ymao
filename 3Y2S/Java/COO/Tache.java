
import java.util.*;

public abstract class Tache {

	private String nom;
	private Personne pers;


	public Tache(String nom,Personne pers){
		this.nom = nom;
		this.pers = pers;
	}

	public String getNom(){
		return this.nom;
	}

	public Personne getPers(){
		return this.pers;
	}

	public abstract void setDateRealise(Date d);
	public abstract int bonus();    
	public abstract void afficher();



}
