
import java.util.Date;

public class TacheLibre extends Tache{

	private Date dateEnregistrement;
	private Date dateRealise;

	public TacheLibre(String nom,Personne pers,Date dateEnregistrement){
		super(nom,pers);
		this.dateEnregistrement = dateEnregistrement;
	}

	public void setDateRealise(Date dateRealise){
		this.dateRealise = dateRealise;
	}

	public int bonus(){
		if(this.dateRealise == null){
			return 0;
		}else{
			return +1;
			//possible pas encore realise?exception?
		}
	}

	public void afficher(){
		System.out.println(this.getNom()+this.dateEnregistrement);
	}

}


