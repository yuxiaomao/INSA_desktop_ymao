/** Boucle principale de la simulation */
import java.awt.*;

public class Anim {

	/** Effectue une pause de la duree indiquee en millisecondes */
	public static void pause(int duree) {
		try {
			Thread.currentThread().sleep(duree);
		} catch (InterruptedException e) {
		}
	}

	/** Boucle principale */
	public void go() {

		Plateau plat;
		Robot[] robots;

		plat = new Plateau(800, 600);
		robots = new Robot[8];

		robots[0] = new Indestructible("Images/mini1.png", 80, 100, plat,
				Color.red, 0, "Alice");
		robots[1] = new Robot("Images/mini2.png", 480, 250, plat, Color.green,
				1, "Bob");
		robots[2] = new Robot("Images/mini3.png", 280, 400, plat, Color.cyan,
				2, "Cici");
		robots[3] = new Robot("Images/mini4.png", 100, 400, plat, Color.blue,
				3, "Doo");
		robots[4] = new Cyborg("Images/mini5.png", 100, 10, plat, Color.orange,
				4, "Eye");
		robots[5] = new Cyborg("Images/mini6.png", 400, 400, plat, Color.pink,
				5, "Fool", 15);
		robots[6] = new Cyborg("Images/mini7.png", 0, 400, plat, Color.yellow,
				6, "GM", 30);
		robots[7] = new Killer("Images/mini8.png", 200, 200, plat, Color.gray,
				7, "Hyper", 8, 10);

		// On repete la boucle d'animation sans arret
		while (true) {

			// On fait evoluer chaque robot
			for (int i = 0; i < robots.length; i++) {
				robots[i].bouge();
			}

			// Puis on teste les collisions deux a deux
			for (int i = 0; i < robots.length; i++) {
				for (int j = i + 1; j < robots.length; j++) {
					robots[i].testeCollision(robots[j]);
				}
			}

			// Petite pause
			this.pause(12);

		}

	}

	public static void main(String[] args) {
		Anim an = new Anim();
		Images.init();
		an.go();
	}

}
