
import java.util.*;

public class Exe{

	public static void main(String[] args){
		Personne pers1 = new Personne("nom1");
		Personne pers2 = new Personne("nom2");
		Activite act1 = new Activite("act1",pers1,pers2);
		Activite act2 = new Activite("act2",pers1,pers2);
		Date d1 = new Date();
		Date d2 = new Date();
		Tache t1 = new TacheChrono("t1",pers1,d1,d2);
		Tache t2 = new TacheChrono("t2",pers2,d1,d2);
		try{
			act1.addTache(t1);
		}catch(PersNonPermis e){
			System.out.println("oula");
		}
		pers1.afficherActivite();
	}

}
