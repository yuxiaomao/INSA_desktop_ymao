import java.awt.Color;

public class Robot {

	/*
	 * Les attributs de chaque Robot.
	 */

	/** Position du robot */
	protected int x, y;

	/** Vitesse du robot */
	protected int vx, vy;

	/** Etat du robot */
	private boolean vivant;

	/** Sprite (==image) representant le robot */
	private Sprite image;

	/** Plateau sur lequel le robot evolue */
	private Plateau plat;

	/** Ce robot est-il arrete' ? */
	private boolean arrete;

	/** La couleur de la trajectoire */
	private Color color;

	/** Numero de serie */
	private int numSerie;

	/** Nom de robot */
	private String nom;

	private static Log logCollisions = new Log();
	private static Log logExploisions = new Log();

	/*
	 * Constructeur de Robot.
	 */

	/**
	 * Cree un nouveau robot avec l'image indiquee, a la position indiquee sur
	 * le plateau La vitesse de depart est aleatoire
	 */
	public Robot(String nomImage, int init_x, int init_y, Plateau pt, Color c,
			int num_serie, String nom) {
		this.x = init_x;
		this.y = init_y;
		this.vivant = true;
		this.vx = this.randomV();
		this.vy = this.randomV();
		this.plat = pt;
		this.image = pt.addSprite(nomImage, this.x, this.y);
		this.arrete = false;
		this.color = c;
		this.numSerie = num_serie;
		this.nom = nom;
	}

	/*
	 * Méthodes
	 */

	/** Renvoie une valeur de vitesse aleatoire */
	public int randomV() {
		return (int) (Math.random() * 6) - 3;
	}

	/** Recupere la largeur de l'image du robot */
	public int getLarg() {
		return this.image.getLarg();
	}

	/** Recupere la hauteur de l'image du robot */
	public int getHaut() {
		return this.image.getHaut();
	}

	/** Recupere le numero de serie du robot */
	public int getNumSerie() {
		return this.numSerie;
	}

	/** Effectue un deplacement elementaire du robot */
	public void bouge() {

		if (this.vivant) {

			this.x += this.vx;
			this.y += this.vy;

			// Si le robot rejoint un bord de la fenetre, il rebondit et change
			// de direction
			int futurX = this.x + this.vx;
			int futurY = this.y + this.vy;

			// Collision avec le bord gauche
			if (futurX < 0) {
				this.vx = Math.abs(this.vx);
				this.vy = this.randomV();
			}

			// Collision avec le bord droit
			if (futurX + this.getLarg() > this.plat.getLarg()) {
				this.vx = -Math.abs(this.vx);
				this.vy = this.randomV();
			}

			// Collision avec le bord haut
			if (futurY < 0) {
				this.vy = Math.abs(this.vy);
				this.vx = this.randomV();
			}

			// Collision avec le bord bas
			if (futurY + this.getHaut() > this.plat.getHaut()) {
				this.vy = -Math.abs(this.vy);
				this.vx = this.randomV();
			}
		}

		// Redessine le robot au nouvel endroit
		// Force a redessiner, meme si le robot n'a pas bouge.
		this.image.moveTo(this.x, this.y);

		// dessiner un cercle au x,y
		this.plat.setColor(this.color);
		this.plat.drawCircle(this.x, this.y, 1);

	}

	/** Teste si ce robot est en collision avec le robot 'autre' */
	public void testeCollision(Robot autre) {

		// Pour etre en collision, il faut une intersection sur les X ET sur les
		// Y
		boolean enCollision = ((this.x + this.getLarg() >= autre.x)
				&& (this.x < autre.x + autre.getLarg())
				&& (this.y + this.getHaut() >= autre.y) && (this.y < autre.y
				+ autre.getHaut()));

		// Si on est en collision avec un robot different de soi-meme, on reagit
		// et l'autre aussi.
		if (this.vivant && autre.vivant && (autre != this) && enCollision) {

			// Si les deux robots sont deja arretes, on ne fait rien.
			if (this.arrete && autre.arrete) {
			} else {
				System.out.println(this + " VS " + autre);
				this.collision(autre);
				autre.collision(this);
				logCollisions.add("C", this, autre);
			}
		}
	}

	/** Arrêter ce robot. */
	public void arreterRobot() {
		this.vx = 0;
		this.vy = 0;
		this.arrete = true;
	}

	/** Fait exploser ce robot */
	public void explose() {
		this.image.playSequence(Images.explosion, false);
		this.vivant = false;
		logExploisions.add("E", this, null);
		// System.out.println(logExploisions);
		// System.out.println(logCollisions);
	}

	/** Reaction a une collision : on s'arrete */
	public void collision(Robot autre) {
		this.arreterRobot();
		this.direBonjour(autre);
	}

	/** permet de changer direction */
	public void changeDirection() {
		this.vx = this.randomV();
		this.vy = this.randomV();
	}

	public void direBonjour(Robot autre) {
		LogLine ligne;
		try {
			ligne = logCollisions.trouveLigne(this, autre);
			System.out.println("Rebonjour, on s'est deja croise le "
					+ ligne.getDate());
		} catch (PasTrouve e) {
			System.out.println("Bonjour, on ne se connait pas");
		}
	}

	public String toString() {
		return "(No." + this.numSerie + " " + this.nom + " " + this.x + " "
				+ this.y + ")";
	}
}
