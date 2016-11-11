import java.awt.Color;

public class Cyborg extends Robot {

	private int nombreCollisions = 0;

	private int maxCollisions = 6;

	/*
	 * Constructeur de Robot.
	 */

	/**
	 * Cree un nouveau robot avec l'image indiquee, a la position indiquee sur
	 * le plateau La vitesse de depart est aleatoire
	 */
	/** Constructeur avec maxCollisions predefinie */
	public Cyborg(String nomImage, int init_x, int init_y, Plateau pt, Color c,
			int num_serie, String nom) {
		super(nomImage, init_x, init_y, pt, c, num_serie, nom);
	}

	/** Constructeur avec maxCollision */
	public Cyborg(String nomImage, int init_x, int init_y, Plateau pt, Color c,
			int num_serie, String nom, int maxCol) {
		super(nomImage, init_x, init_y, pt, c, num_serie, nom);
		this.maxCollisions = maxCol;
	}

	// redefinition collision
	public void collision(Robot autre) {
		nombreCollisions += 1;
		if (nombreCollisions <= maxCollisions) {
			super.changeDirection();
		} else {
			super.explose();
		}
		super.direBonjour(autre);
	}

	public String toString() {
		return "Cyborg" + super.toString();
	}

}
