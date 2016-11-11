import java.awt.Color;

public class Indestructible extends Robot {

	/*
	 * Constructeur de Robot.
	 */

	/**
	 * Cree un nouveau robot avec l'image indiquee, a la position indiquee sur
	 * le plateau La vitesse de depart est aleatoire
	 */
	/** Constructeur avec maxCollisions predefinie */
	public Indestructible(String nomImage, int init_x, int init_y, Plateau pt,
			Color c, int num_serie, String nom) {
		super(nomImage, init_x, init_y, pt, c, num_serie, nom);
	}

	/** s'arreter qd collision */
	/** Redefinition exploire */
	public void explose() {

	}

	public String toString() {
		return "Indestructible" + super.toString();
	}

}
