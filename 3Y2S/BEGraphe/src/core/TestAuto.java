package core;

import java.io.PrintStream;
import java.util.Random;

import base.Readarg;


public class TestAuto extends Algo {
	protected int nbTest;
	Readarg readarg;

	//pour pcc
	public int pccTailleTasMoyen;
	public int pccTailleHmap;
	public long pccMemoireMoyen;
	public long pccChronoMoyen;

	//pour A*
	public int starTailleTasMoyen;
	public int starTailleHmap;
	public long starMemoireMoyen;
	public long starChronoMoyen;

	public TestAuto(Graphe gr, PrintStream sortie, Readarg readarg) {
		super(gr, sortie, readarg);
		this.readarg = readarg;
		this.nbTest = readarg.lireInt("Nombre de tests à effectuer ? ");
	}

	public void run() {
		//genere une "fonction" aleatoire
		Random random = new Random();

		//origine et destination
		int randOrigine, randDest;

		int i;
		for(i=0;i<this.nbTest;i++){
			//renvoi le prochain int de la fonction aleatoire random créée
			randOrigine = random.nextInt(this.graphe.getNbNodes());
			randDest = randOrigine;

			//évite le cas origine = destination (0 info sur les performances de l'algo)
			while (randDest == randOrigine){
				randDest = random.nextInt(this.graphe.getNbNodes());
			}

			System.out.println();
			System.out.println("** TEST PERFORMANCE " + (i+1));
			System.out.println("Origine : " + randOrigine);
			System.out.println("Destination : " + randDest);

			Pcc pcc = new Pcc(this.graphe, sortie, readarg, randOrigine, randDest);
			pcc.run();
			if (pcc.isCheminTrouve()){
				//System.out.println("PCC: Tas " + pcc.getMaxSizeTas());
				//System.out.println("PCC: Temps " + pcc.getChrono());
				if(i==0){
					pccTailleTasMoyen = pcc.getMaxSizeTas();
					pccTailleHmap = pcc.getHmapSize();
					pccMemoireMoyen = pcc.getMemory();
					pccChronoMoyen = pcc.getChrono();
				}else{
					pccTailleTasMoyen = pccTailleTasMoyen + pcc.getMaxSizeTas();
					pccTailleHmap = pccTailleHmap + pcc.getHmapSize();
					pccMemoireMoyen = pccMemoireMoyen + pcc.getMemory();
					pccChronoMoyen = pccChronoMoyen + pcc.getChrono();
					//System.out.println("PCC: Tas " + pccTailleTasMoyen);
					//System.out.println("PCC: Temps " + pccChronoMoyen);
				}
			}else{
				System.out.println("PAS DE CHEMIN TROUVE!");
			}

			PccStar pccStar = new PccStar(this.graphe, sortie, readarg, randOrigine, randDest);
			pccStar.run();
			if (pccStar.isCheminTrouve()){
				//System.out.println("PCC STAR: Tas " + pccStar.getMaxSizeTas());
				//System.out.println("PCC STAR: Temps " + pccStar.getChrono());
				if(i==0){
					starTailleTasMoyen = pccStar.getMaxSizeTas();
					starTailleHmap = pccStar.getHmapSize();
					starMemoireMoyen = pccStar.getMemory();
					starChronoMoyen = pccStar.getChrono();
				}else{
					starTailleTasMoyen = starTailleTasMoyen + pccStar.getMaxSizeTas();
					starTailleHmap = starTailleHmap + pccStar.getHmapSize();
					starMemoireMoyen = starMemoireMoyen + pccStar.getMemory();
					starChronoMoyen = starChronoMoyen + pccStar.getChrono();
					//System.out.println("PCC STAR: Tas " + starTailleTasMoyen);
					//System.out.println("PCC STAR: Temps " + starChronoMoyen);
				}
			}else{
				System.out.println("PAS DE CHEMIN TROUVE!");
			}
		}

		//calcul des moyennes
		//moyenne Pcc
		pccTailleTasMoyen = pccTailleTasMoyen/this.nbTest;
		pccTailleHmap = pccTailleHmap/this.nbTest;
		pccMemoireMoyen = pccMemoireMoyen/this.nbTest;
		pccChronoMoyen = pccChronoMoyen/this.nbTest;

		//moyenne A*
		starTailleTasMoyen = starTailleTasMoyen/this.nbTest;
		starTailleHmap = starTailleHmap/this.nbTest;
		starMemoireMoyen = starMemoireMoyen/this.nbTest;
		starChronoMoyen = starChronoMoyen/this.nbTest;

		//Affichage
		System.out.println();
		System.out.println("** Resultats des " + this.nbTest + " tests");
		System.out.println("PCC: Taille max du tas en moyenne: " + pccTailleTasMoyen);
		System.out.println("PCC: Taille de la hmap en moyenne: " + pccTailleHmap);
		System.out.println("PCC: Memoire moyenne utilisee (en octet): " + pccMemoireMoyen);
		pccMemoireMoyen = pccMemoireMoyen/1000000;
		System.out.println("PCC: Memoire moyenne utilisee (en Mo): " + pccMemoireMoyen);
		System.out.println("PCC: Temps moyen d'execution: " + pccChronoMoyen);
		
		System.out.println();
		System.out.println("A*: Taille max du tas en moyenne: " + starTailleTasMoyen);
		System.out.println("A*: Taille de la hmap en moyenne: " + starTailleHmap);
		System.out.println("A*: Memoire moyenne utilisee (en octet): " + starMemoireMoyen);
		starMemoireMoyen = starMemoireMoyen/1000000;
		System.out.println("A*: Memoire moyenne utilisee (en Mo): " + starMemoireMoyen);
		System.out.println("A*: Temps moyen d'execution: " + starChronoMoyen);
	}
}
