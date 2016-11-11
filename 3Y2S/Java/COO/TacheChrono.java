
import java.util.*;

public class TacheChrono extends Tache{

	private Date dateDebut;
	private Date dateEcheance;
	private Date dateRealise;
	private ArrayList<TacheChrono> listeDepend;

	public TacheChrono(String nom,Personne pers,
			Date dateDebut,Date dateEcheance){
		super(nom,pers);
		this.dateDebut = dateDebut;
		this.dateEcheance = dateEcheance;
		this.listeDepend = new ArrayList<TacheChrono>();
	}

	public void setDateRealise(Date dateRealise){
		this.dateRealise = dateRealise;
	}

	public int bonus(){
		if (this.dateRealise == null){
			return 0;
		}else{if (this.dateRealise.after(this.dateEcheance)){
			return -2;
		}
		else{
			return 1;
			//possible pas encore realise?exception?
		}
		}
	}

	public void afficher(){
		System.out.println(this.getNom()+this.dateDebut+this.dateEcheance);
	}

}
