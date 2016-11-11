import java.lang.Throwable;


public class PersNonPermis extends Exception{

	private String contenu;

	public PersNonPermis(String contenu){
		this.contenu = contenu;
	};
}
