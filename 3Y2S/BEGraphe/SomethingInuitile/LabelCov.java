package core;

// n'a pas mis en place pour notre algo
//mais peuve en servir si on desire de faire mieux, ajouter un tas pour trier dessus
public class LabelCov implements Comparable<LabelCov>{
	//pour l'instant, remplir uniquement les points communs PV et VP
	
	
	private double coutPieton;
	private double coutVoiture;
	//private double coutDestination;
	private int sommetCourant;
	private double coutTotal;
	
	//cout distance en m, coutTemps en min
	public LabelCov(int sommetCourant) {
		this.coutPieton = 9000000.0f;
		this.coutVoiture = 9000000.0f;
		//this.coutDestination = 9000000.0f;
		this.sommetCourant = sommetCourant;
		this.coutTotal = 27000000.0f;
	}

	public double getCoutPieton() {
		return coutPieton;
	}

	public void setCoutPieton(double coutPieton) {
		this.coutPieton = coutPieton;
	}

	public double getCoutVoiture() {
		return coutVoiture;
	}

	public void setCoutVoiture(double coutVoiture) {
		this.coutVoiture = coutVoiture;
	}

	/*
	public double getCoutDestination() {
		return coutDestination;
	}

	public void setCoutDestination(double coutEstimee) {
		this.coutDestination = coutEstimee;
	}

	*/
	
	public int getSommetCourant() {
		return sommetCourant;
	}

	public void setSommetCourant(int sommetCourant) {
		this.sommetCourant = sommetCourant;
	}
	
	public double getCoutTotal() {
		return coutTotal;
	}
	
	public void setCoutTotal() {
		if ((this.coutPieton < 9000000.0f) && (this.coutVoiture < 9000000.0f)){
			this.coutTotal = this.coutPieton + this.coutVoiture;
		}
	}

	public int compareTo(LabelCov o){
		return (int) (this.coutTotal - o.coutTotal);
	}



}
