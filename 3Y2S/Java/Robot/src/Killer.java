import java.awt.Color;
import java.util.ArrayList;

public class Killer extends Robot {

	/** Le seuil de killer */
	private int seuilKiller;

	/** Un tableau de rencontre */
	// private ArrayList <Integer> listeRencontre;
	int[] listeRencontre;

	/*
	 * Constructeur de Robot.
	 */

	/**
	 * Cree un nouveau robot avec l'image indiquee, a la position indiquee sur
	 * le plateau La vitesse de depart est aleatoire
	 */
	/** Constructeur avec maxCollisions predefinie */
	public Killer(String nomImage, int init_x, int init_y, Plateau pt, Color c,
			int num_serie, String nom, int nombreRobot, int seuilKiller) {
		super(nomImage, init_x, init_y, pt, c, num_serie, nom);
		this.seuilKiller = seuilKiller;
		// this.listeRencontre = new ArrayList<Integer>(nombreRobot);
		listeRencontre = new int[nombreRobot];
	}

	/** Redefinition collision */
	public void collision(Robot autre) {
		int i = autre.getNumSerie();
		listeRencontre[i] += 1;
		if (this.listeRencontre[i] >= seuilKiller) {
			autre.explose();
		} else {
			super.changeDirection();
		}
		super.direBonjour(autre);
		/*
		 * this.listeRencontre.set(i,this.listeRencontre.get(i)+1); if
		 * (this.listeRencontre.get(i) == this.seuilKiller){ autre.explose(); }
		 */
	}

	public String toString() {
		return "Killer" + super.toString();
	}

}
