import java.lang.Throwable;

public class PasTrouve extends Exception {

	private String contenu;

	public PasTrouve(String contenu) {
		this.contenu = contenu;
	};
}
