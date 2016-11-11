import java.io.*;

public class Exe {

	public static void main(String[] args) {
		try {
			// avec decalage prédefini "  "
			if (FileInfo.isDirectory(args[0])) {
				Node n = new Dossier(args[0]);
				String decalage = "";
				n.afficherDecalage(decalage);
				System.out.println("Taille Total: "+ n.getTaille());
			} else {
				Node n = new Fichier(args[0]);
				System.out.println("File");
				n.afficher();
				
			}

		} catch (IOException e) {
			System.out.println("Error IOE");
		}
	}

}
