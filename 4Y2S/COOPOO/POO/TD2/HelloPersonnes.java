import perso.*;

public class HelloPersonnes {

	public static void main(String[] args) {
		Personne tabPersonnes[] = new Personne[3];
		tabPersonnes[0] = new Personne("P1", 20);
		tabPersonnes[1] = new Etudiant("S1", 21, 14.5f);
		tabPersonnes[2] = new Enseignant("E1", 31, 40);

		for (int i = 0; i < 3; i++) {
			System.out.println("This is person " + i + ", "
					+ tabPersonnes[i].toString());
		}
	}

}
